CREATE PROC [dbo].[USP_Send_Mail_WBS_Linked_Titles]
(
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
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Send_Mail_WBS_Linked_Titles]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--DECLARE @WBS_Codes VARCHAR(MAX) = 'F/LIC-0000001.01,F/LIC-0000001.02,F/LIC-0000001.03'
		DECLARE   @Is_Processed CHAR(1)
		DECLARE @BuCode INT, @User_Mail_Id NVARCHAR(1000), @Users_Code INT
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
		BEGIN
			DROP TABLE #Temp
		END
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config (NOLOCK)  where [Key]='WTL'

		SELECT SW.WBS_Code, AD.Agreement_No, 
		dbo.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADB.Episode_From, ADB.Episode_To) AS Title_Name,
		AD.Business_Unit_Code
		INTO #Linked_Title
		FROM Acq_Deal_Budget ADB  (NOLOCK) 
		INNER JOIN SAP_WBS SW  (NOLOCK) ON ADB.SAP_WBS_Code = SW.SAP_WBS_Code
		INNER JOIN Acq_Deal AD (NOLOCK)  ON AD.Acq_Deal_Code = ADB.Acq_Deal_Code
		INNER JOIN Title T (NOLOCK)  ON T.Title_Code = ADB.Title_Code
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND SW.WBS_Code IN ( SELECT number from dbo.fn_Split_withdelemiter(@WBS_Codes, ','))

		IF EXISTS(SELECT * FROM #Linked_Title)
		BEGIN
		PRINT 'Fount Linked Title Data'


			DECLARE @Business_Unit_Code INT,
			@To_Users_Code NVARCHAR(MAX),
			@To_User_Mail_Id  NVARCHAR(MAX),
			@CC_Users_Code  NVARCHAR(MAX),
			@CC_User_Mail_Id  NVARCHAR(MAX),
			@BCC_Users_Code  NVARCHAR(MAX),
			@BCC_User_Mail_Id  NVARCHAR(MAX),
			@Channel_Codes NVARCHAR(MAX)
	
			DECLARE @Tbl2 TABLE (
				Id INT,
				BuCode INT,
				To_Users_Code NVARCHAR(MAX),
				To_User_Mail_Id  NVARCHAR(MAX),
				CC_Users_Code  NVARCHAR(MAX),
				CC_User_Mail_Id  NVARCHAR(MAX),
				BCC_Users_Code  NVARCHAR(MAX),
				BCC_User_Mail_Id  NVARCHAR(MAX),
				Channel_Codes NVARCHAR(MAX)
			)

		DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

		INSERT INTO @Tbl2(Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
		EXEC USP_Get_EmailConfig_Users 'WTL', 'N'


			DECLARE @emailTemplate VARCHAR(MAX)
			SELECT @emailTemplate = Template_Desc FROM Email_Template (NOLOCK)  WHERE Template_For='SAP_WBS_LINKED'

			DECLARE @WBS_Code VARCHAR(MAX) = NULL, @Agreement_No VARCHAR(MAX) = NULL, @Title_Name VARCHAR(MAX) = ''
			SELECT DISTINCT WBS_Code, Agreement_No, 'N' AS Is_Processed INTO #TEMP_AgreementNo FROM #Linked_Title

			DECLARE CurOuter CURSOR FOR
			SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
			--SELECT BuCode, User_Mail_Id, Users_Code from [dbo].[UFN_Get_Bu_Wise_User]('WTL')

			OPEN CurOuter
			FETCH NEXT FROM CurOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
			--Into @BuCode, @User_Mail_Id, @Users_Code
			WHILE(@@FETCH_STATUS = 0)
			BEGIN

				DECLARE @mailBody VARCHAR(MAX) = ''
			
				DECLARE @EmailTable VARCHAR(MAX) = '' 
				IF EXISTS(SELECT * FROM #Linked_Title WHERE Business_Unit_Code = @Business_Unit_Code )
				BEGIN
				SET @EmailTable = '<table class="tblFormat"><tr>
					<th align="center" width="20%" class="tblHead">WBS Code</th>      
					<th align="center" width="15%" class="tblHead">Agreement No.</th>      
					<th align="center" width="30%" class="tblHead">Title(s)</th> 
				</tr>'
				END
				DECLARE CurInner CURSOR FOR
				SELECT DISTINCT WBS_Code, Agreement_No, 'N' AS Is_Processed, Business_Unit_Code FROM #Linked_Title 
				where Business_Unit_Code=@Business_Unit_Code
				OPEN CurInner
				FETCH NEXT FROM CurInner Into @WBS_Code, @Agreement_No, @Is_Processed, @BuCode
				WHILE(@@FETCH_STATUS = 0)
				BEGIN
					SET @Title_Name = ''
					SELECT @Title_Name += ', ' + Title_Name FROM #Linked_Title WHERE Agreement_No = @Agreement_No
					SET @Title_Name = RIGHT(@Title_Name, (LEN(@Title_Name) - 2))
			
					SET @EmailTable =@EmailTable +  '<tr>
					<td align="center" class="tblData">' + @WBS_Code + '</td>
					<td align="center" class="tblData">' + @Agreement_No + '</td>  
					<td align="center" class="tblData">'+@Title_Name + '</td></tr>'

					FETCH NEXT FROM CurInner Into @WBS_Code, @Agreement_No, @Is_Processed, @BuCode
				END
				CLOSE CurInner
				DEALLOCATE CurInner

				IF(@EmailTable!='')
				BEGIN
					SET @EmailTable =@EmailTable +  '</table>'
					SET @mailBody = REPLACE(@emailTemplate,'{TABLE_DATA}',@EmailTable)  
			
				DECLARE @DatabaseEmail_Profile varchar(200), @emailAddresses VARCHAR(MAX) = ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'

				
					--EXEC msdb.dbo.sp_send_dbmail 
					--@profile_name = @DatabaseEmail_Profile,
					--@recipients =  @To_User_Mail_Id,
					--@copy_recipients = @CC_User_Mail_Id,
					--@blind_copy_recipients = @BCC_User_Mail_Id,
					--@subject = 'WBS Codes are already linked',
					--@body = @mailBody, 
					--@body_format = 'HTML';


				
					INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
					SELECT @Email_Config_Code,@mailBody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  'WBS Codes are already linked'

				END
				FETCH NEXT FROM CurOuter Into  @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
			END
			CLOSE CurOuter
			DEALLOCATE CurOuter

		END

		EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

		IF OBJECT_ID('tempdb..#Linked_Title') IS NOT NULL
		BEGIN
			DROP TABLE #Linked_Title
		END
		IF OBJECT_ID('tempdb..#TEMP_AgreementNo') IS NOT NULL
		BEGIN
			DROP TABLE #TEMP_AgreementNo
		END

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Send_Mail_WBS_Linked_Titles]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
