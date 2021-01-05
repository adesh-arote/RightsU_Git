alter PROC USP_Send_Mail_WBS_Linked_Titles
(
--DECLARE
	@WBS_Codes VARCHAR(MAX)
)
AS
--=============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 16-July-2015
-- Description:	While importing any WBS comes with these status (TECO, CLSD or LKD) and that WBS is already in RightsU SAP_WBS table, 
--				so RightsU will update WBS entry and RightsU will check wether this WBS is linked, 
--				If yes then RightsU will send an email alert to user asking him to assign a new WBS Code for that particular deal and title.
-- =============================================
BEGIN
	--DECLARE @WBS_Codes VARCHAR(MAX) = 'F/LIC-0000001.01,F/LIC-0000001.02,F/LIC-0000001.03'
	DECLARE   @Is_Processed CHAR(1), @Business_Unit_Code INT
	DECLARE @BuCode INT, @User_Mail_Id NVARCHAR(1000), @Users_Code INT
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	BEGIN
		DROP TABLE #Temp
	END
	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config where [Key]='WTL'

	SELECT SW.WBS_Code, AD.Agreement_No, 
	dbo.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADB.Episode_From, ADB.Episode_To) AS Title_Name,
	AD.Business_Unit_Code
	INTO #Linked_Title
	FROM Acq_Deal_Budget ADB 
	INNER JOIN SAP_WBS SW ON ADB.SAP_WBS_Code = SW.SAP_WBS_Code
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADB.Acq_Deal_Code
	INNER JOIN Title T ON T.Title_Code = ADB.Title_Code
	WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND SW.WBS_Code IN ( SELECT number from dbo.fn_Split_withdelemiter(@WBS_Codes, ','))

	IF EXISTS(SELECT * FROM #Linked_Title)
	BEGIN
	PRINT 'Fount Linked Title Data'
		DECLARE @emailTemplate VARCHAR(MAX)
		SELECT @emailTemplate = Template_Desc FROM Email_Template WHERE Template_For='SAP_WBS_LINKED'

		DECLARE @WBS_Code VARCHAR(MAX) = NULL, @Agreement_No VARCHAR(MAX) = NULL, @Title_Name VARCHAR(MAX) = ''
		SELECT DISTINCT WBS_Code, Agreement_No, 'N' AS Is_Processed INTO #TEMP_AgreementNo FROM #Linked_Title

		DECLARE CurOuter CURSOR FOR
		SELECT BuCode, User_Mail_Id, Users_Code from [dbo].[UFN_Get_Bu_Wise_User]('WTL')
		OPEN CurOuter
		FETCH NEXT FROM CurOuter Into @BuCode, @User_Mail_Id, @Users_Code
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

			DECLARE @mailBody VARCHAR(MAX) = ''
			
			DECLARE @EmailTable VARCHAR(MAX) = '' 
			IF EXISTS(SELECT * FROM #Linked_Title WHERE Business_Unit_Code = @BuCode )
			BEGIN
			SET @EmailTable = '<table class="tblFormat"><tr>
				<th align="center" width="20%" class="tblHead">WBS Code</th>      
				<th align="center" width="15%" class="tblHead">Agreement No.</th>      
				<th align="center" width="30%" class="tblHead">Title(s)</th> 
			</tr>'
			END
			DECLARE CurInner CURSOR FOR
			SELECT DISTINCT WBS_Code, Agreement_No, 'N' AS Is_Processed, Business_Unit_Code FROM #Linked_Title 
			where Business_Unit_Code=@BuCode
			OPEN CurInner
			FETCH NEXT FROM CurInner Into @WBS_Code, @Agreement_No, @Is_Processed, @Business_Unit_Code
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				SET @Title_Name = ''
				SELECT @Title_Name += ', ' + Title_Name FROM #Linked_Title WHERE Agreement_No = @Agreement_No
				SET @Title_Name = RIGHT(@Title_Name, (LEN(@Title_Name) - 2))
			
				SET @EmailTable =@EmailTable +  '<tr>
				<td align="center" class="tblData">' + @WBS_Code + '</td>
				<td align="center" class="tblData">' + @Agreement_No + '</td>  
				<td align="center" class="tblData">'+@Title_Name + '</td></tr>'

				FETCH NEXT FROM CurInner Into @WBS_Code, @Agreement_No, @Is_Processed, @Business_Unit_Code
			END
			CLOSE CurInner
			DEALLOCATE CurInner

			IF(@EmailTable!='')
			BEGIN
				SET @EmailTable =@EmailTable +  '</table>'
				SET @mailBody = REPLACE(@emailTemplate,'{TABLE_DATA}',@EmailTable)  
			
			DECLARE @DatabaseEmail_Profile varchar(200), @emailAddresses VARCHAR(MAX) = ''
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'

			
			EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile 
			,@recipients =  @User_Mail_Id
			,@subject = 'WBS Codes are already linked'  
			,@body = @mailBody
			,@body_format = 'HTML';

			INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @EmailTable, @Users_Code, 'WBS Title Link', @User_Mail_Id
			END
			FETCH NEXT FROM CurOuter Into @BuCode, @User_Mail_Id, @Users_Code
		END
		CLOSE CurOuter
		DEALLOCATE CurOuter
		--DECLARE @allRows VARCHAR(MAX) = ''
		--DECLARE @row VARCHAR(MAX) = '<tr>
		--		<td align="center" class="tblData">{WBS_Code}</td>
		--		<td align="center" class="tblData">{Agreement_No}</td>
		--		<td align="center" class="tblData">{Titles}</td>
		--	</tr>'
		--SELECT TOP 1 @WBS_Code = WBS_Code, @Agreement_No = Agreement_No FROM #TEMP_AgreementNo WHERE Is_Processed = 'N'
		--WHILE(@Agreement_No IS NOT NULL AND @WBS_Code IS NOT NULL) 
		--BEGIN
			
		--	SET @Title_Name = ''
		--	SELECT @Title_Name += ', ' + Title_Name FROM #Linked_Title WHERE Agreement_No = @Agreement_No
		--	SET @Title_Name = RIGHT(@Title_Name, (LEN(@Title_Name) - 2))
		--	--PRINT 'WBS Code ''' + @WBS_Code + ''' is already linked with ''' + @Agreement_No + ''' for ''' + @Title_Name  + ''''
			
		--	DECLARE @currentRow VARCHAR(MAX) = ''
		--	SET @currentRow = REPLACE(@row,'{WBS_Code}',@WBS_Code)  
		--	SET @currentRow = REPLACE(@currentRow,'{Agreement_No}',@Agreement_No)  
		--	SET @currentRow = REPLACE(@currentRow,'{Titles}',@Title_Name)

		--	SET @allRows = (@allRows + @currentRow)
			  
		--	UPDATE #TEMP_AgreementNo SET Is_Processed = 'Y' WHERE Agreement_No = @Agreement_No AND WBS_Code = @WBS_Code
		--	SET @Agreement_No = NULL
		--	SELECT TOP 1 @WBS_Code = WBS_Code, @Agreement_No = Agreement_No FROM #TEMP_AgreementNo WHERE Is_Processed = 'N'
			
		--END

		--DECLARE @mailBody VARCHAR(MAX) = ''
		--SET @mailBody = REPLACE(@emailTemplate,'{TABLE_DATA}',@allRows)  

		--DECLARE @DatabaseEmail_Profile varchar(200), @emailAddresses VARCHAR(MAX) = ''
		--SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
		--SELECT @emailAddresses = parameter_value FROM system_parameter_new WHERE parameter_name = 'SAP_WBS_LINKED_Emails'
		
		--SELECT User_Mail_Id, Users_Code INTO #Temp from [dbo].[UFN_Get_Bu_Wise_User]('WTL')

		--SET @emailAddresses = STUFF((SELECT DISTINCT ',' + CAST(User_Mail_Id AS VARCHAR(MAX)) 
		--		FROM #Temp FOR XML PATH('') ), 1, 1, '')

		--EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile 
		--,@recipients =  @emailAddresses
		--,@subject = 'WBS Codes are already linked'  
		--,@body = @mailBody
		--,@body_format = 'HTML';

		--INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
		--SELECT @Email_Config_Code, GETDATE(), 'N', @mailBody, Users_Code, 'WBS Title Link', Users_Email_Id
		--FROM #Temp
	END

	IF OBJECT_ID('tempdb..#Linked_Title') IS NOT NULL
	BEGIN
		DROP TABLE #Linked_Title
	END
	IF OBJECT_ID('tempdb..#TEMP_AgreementNo') IS NOT NULL
	BEGIN
		DROP TABLE #TEMP_AgreementNo
	END
END

--Old template for 'SAP_WBS_LINKED' in Email_Template Table --<html>   <head>    <style type="text/css">     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     td.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          #divNotice     {      color: gray;      font-size:10px !important;     }    </style>   </head>   <body>    <div class="textFont">     Hi,<br /><br />     The below mentioned WBS codes have already been assigned. Kindly make relevant changes at your earliest convenience.<br /><br />    </div>    <table class="tblFormat" >     <tr>      <td align="center" width="20%" class="tblHead"><b>WBS Code<b></td>      <td align="center" width="15%" class="tblHead"><b>Agreement No.<b></td>      <td align="center" width="30%" class="tblHead"><b>Title(s)<b></td>     </tr>     {TABLE_DATA}    </table>    <br />    <div class="textFont">    If you have any questions or need assistance, please feel free to reach us at +91 22 43 222 222 Extn 213.    <br /><br />    <b>Regards,</b><br />    RightsU SAP Support<br />    U-TO Solutions (I) Pvt Ltd    </div><br />    <hr>    <div id="divNotice" class="textFont">     Confidentiality Notice: This e-mail transmission may contain confidential or legally privileged information that is intended only for the individual(s) or entity(ies) named in the e-mail address. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or reliance upon the contents of this e-mail is strictly prohibited. If you have received this e-mail transmission in error, please immediately notify the sender by email to the above address so that U-TO SOLUTIONS can arrange for proper delivery. Then please delete the message from your inbox. Thank you.    </div>   </body>  </html>
--New update script for this Temlate 
--UPDATE Email_Template SET Template_Desc='<html><head>    <style type="text/css">     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     th.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      font-size:12px;  font-weight:bold   }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          #divNotice     {      color: gray;      font-size:10px !important;     }    </style>   </head>   <body>    <div class="textFont">     Hi,<br /><br />     The below mentioned WBS codes have already been assigned. Kindly make relevant changes at your earliest convenience.<br /><br />    </div>{TABLE_DATA} <br />    <div class="textFont">If you have any questions or need assistance, please feel free to reach us at +91 22 43 222 222 Extn 213.    <br /><br /> <b>Regards,</b><br />    RightsU SAP Support<br />    U-TO Solutions (I) Pvt Ltd    </div><br /><hr>    <div id="divNotice" class="textFont"> Confidentiality Notice: This e-mail transmission may contain confidential or legally privileged information that is intended only for the individual(s) or entity(ies) named in the e-mail address. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or reliance upon the contents of this e-mail is strictly prohibited. If you have received this e-mail transmission in error, please immediately notify the sender by email to the above address so that U-TO SOLUTIONS can arrange for proper delivery. Then please delete the message from your inbox. Thank you.    </div>   </body>  </html>'
-- WHERE Template_For='SAP_WBS_LINKED'