CREATE Procedure [dbo].[USP_SendMail_On_Rejection]   
	 @RecordCode INT,
	 @module_workflow_detail_code INT,
	 @module_code INT,
	 @RedirectToApprovalList VARCHAR(100),
	 @AutoLoginUser VARCHAR(100),
	 @Login_User INT,
	 @Is_Error CHAR(1) OUTPUT  
AS  
-- =============================================  
-- Author:		<Adesh P Arote>
-- Create date: 02-FEB-2011
-- Description: SEND MAIL TO ALL LAST APPROVER IF DEAL IS REJECT FORM ANY USER  
-- =============================================  
BEGIN 
 
	--DECLARE 
	--@RecordCode INT =15226,
	--@module_workflow_detail_code INT = 37288,
	--@module_code INT = 30,
	--@RedirectToApprovalList VARCHAR(100)='Y',
	--@AutoLoginUser VARCHAR(100)='Y',
	--@Login_User VARCHAR(100) = 204,
	--@Is_Error CHAR(1) = 'N'

	SET @Is_Error='N'  
	BEGIN TRY  
		DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 
		DECLARE @Rejected_by NVARCHAR(500) SET @Rejected_by=''  
		DECLARE @cur_first_name NVARCHAR(500)  
		DECLARE @cur_security_group_name NVARCHAR(500)   
		DECLARE @cur_email_id NVARCHAR(500)   
		DECLARE @cur_security_group_code VARCHAR(500)   
		DECLARE @cur_user_code INT  
		DECLARE @DealType VARCHAR(100)   
		DECLARE @DealNo VARCHAR(500) SET @DealNo=0  
		DECLARE @body1 NVARCHAR(MAX)  SET @body1 =''  
		DECLARE @MailSubjectCr NVARCHAR(500)  
		DECLARE @CC NVARCHAR(MAX)SET @CC =''  
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)
	    DECLARE	@DefaultSiteUrl_Param  NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl NVARCHAR(500) SET @DefaultSiteUrl = ''  
		DECLARE @BUCode INT = 0 
		DECLARE @Email_Table NVARCHAR(MAX) = ''
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='ASCM'
 
		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param  
  
		SELECT @Rejected_by = ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
		FROM Users U  
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U.Security_Group_Code  
		WHERE Users_Code   = @Login_User 

		IF(@module_code = 30)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 35)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal  WHERE Syn_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 163)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal  WHERE Music_Deal_Code = @RecordCode 
		END

		DECLARE 
			@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
			@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0, @BU_Name VARCHAR(MAX) = ''
		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
				WHERE Acq_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(varchar(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
				WHERE Syn_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name, @BU_Name =BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END

		DECLARE @DefaultSiteUrlHold NVARCHAR(500)
		SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  
		SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is rejected'   

		IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

		CREATE TABLE #TempCursorOnRej (
			First_name NVARCHAR(MAX),
			Security_group_name NVARCHAR(500),
			Email_id NVARCHAR(500),
			Security_group_code INT,
			User_code INT 
		)
		
		INSERT INTO #TempCursorOnRej(First_name, Security_group_name, Email_id, Security_group_code, User_code)
		SELECT DISTINCT ISNULL(U2.First_Name,'') + ' ' + ISNULL(U2.Middle_Name,'') + ' ' + ISNULL(U2.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')', 
		SG.Security_Group_Name, U2.Email_Id, U2.Security_Group_Code, U2.Users_Code   
		FROM Users U1
		INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code IN (@BUCode)
		INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code AND U2.Is_Active = 'Y' AND U1.Is_Active = 'Y'
		INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		INNER JOIN Module_Workflow_Detail MWD ON MWD.Primary_User_Code = U1.Users_Code AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode
			AND Module_Workflow_Detail_Code < @module_workflow_detail_code

		DECLARE @Is_CustomUsers_WF_SendMail VARCHAR(10)
		SELECT @Is_CustomUsers_WF_SendMail = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_CustomUsers_WF_SendMail'
		DECLARE @Email_Config_Code_V18 VARCHAR(10)
		SELECT @Email_Config_Code_V18 = Email_Config_Code from Email_Config where [Key] = 'ASCM'

		IF(@Is_CustomUsers_WF_SendMail = 'Y')
		BEGIN
			DECLARE @ENL TABLE (
				BUCode INT,
				User_Code INT,
				EmailId NVARCHAR(MAX)
			)
			--print '111'
			INSERT INTO @ENL (BUCode, User_Code, EmailId)
			EXEC USP_Get_EmailConfig_Users 'ASCM', 'Y'
				
			INSERT INTO #TempCursorOnRej(First_name, Security_group_name, Email_id, Security_group_code, User_code)
			SELECT DISTINCT ISNULL(usr.First_Name,'') + ' ' + ISNULL(usr.Middle_Name,'') + ' ' + ISNULL(usr.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, usr.Email_Id, usr.Security_Group_Code, usr.Users_Code 
			FROM @ENL ec
			INNER JOIN Users usr ON usr.Users_Code  = EC.User_Code
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = Usr.Security_Group_Code
		END
	
		/* CURSOR START */
		DECLARE cur_on_rejection CURSOR KEYSET FOR
		SELECT First_name, Security_group_name, Email_id, Security_group_code, User_code FROM #TempCursorOnRej 
		OPEN cur_on_rejection  
		FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
		WHILE (@@fetch_status <> -1)  
		BEGIN  
			IF (@@fetch_status <> -2)  
			BEGIN  
				SELECT @DefaultSiteUrl = @DefaultSiteUrlHold
				--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) +
				--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
				SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=R'
				
				SET @Email_Table =	
				'<table class="tblFormat" style="width:100%"> 
					 <tr>     
									<th align="center" width="14%" class="tblHead">Agreement No.</th>    
									<th align="center" width="14%" class="tblHead">Agreement Date</th>   
									<th align="center" width="19%" class="tblHead">Deal Description</th> 
									<th align="center" width="19%" class="tblHead">Primary Licensor</th>   
									<th align="center" width="25%" class="tblHead">Title(s)</th>
									<th align="center" width="10%" class="tblHead">Business Unit</th>
				     </tr>  
					 <tr>
									<td align="center" class="tblData">{Agreement_No}</td>   
									<td align="center" class="tblData">{Agreement_Date}</td>     
									<td align="center" class="tblData">{Deal_Desc}</td>    
									<td align="center" class="tblData">{Primary_Licensor}</td>   
									<td align="center" class="tblData">{Titles}</td> 
									<td align="center" class="tblData">{BU_Name}</td> 
				    </tr>  
				</table>'
				SELECT @body1 = template_desc FROM Email_Template WHERE Template_For='R'
				PRINT @DealNo  
				--REPLACE ALL THE PARAMETER VALUE  
				SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
				SET @body1 = replace(@body1,'{deal_no}',@DealNo)  
				SET @body1 = replace(@body1,'{deal_type}',@DealType)  
				SET @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
				SET @body1 = replace(@body1,'{rejected_by}',@Rejected_by) 
				 
				SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
				SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
				SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
				SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
				SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
				SET @Email_Table = replace(@Email_Table,'{BU_Name}', @BU_Name)
      
				SET @CC = ''  
				SET @body1 = replace(@body1,'{table}',@Email_Table)
				--IF(@Is_Mail_Send_To_Group='Y')  
				--BEGIN  
				--	SELECT @CC = @CC + ';' + Email_Id FROM Users WHERE security_group_code IN (@cur_security_group_code)   
				--	AND Users_Code NOT IN (@cur_user_code)  
				--END
  
				DECLARE @DatabaseEmail_Profile varchar(200)	= ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				--EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile, 
				--@recipients =  @cur_email_id, 
				--@copy_recipients = @CC, 
				--@subject = @MailSubjectCr, 
				--@body = @body1,
				--@body_format = 'HTML';
				

				INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, [Subject])
				SELECT @Email_Config_Code,@body1, ISNULL(@Cur_user_code,''), ISNULL(@Cur_email_id ,''),  @MailSubjectCr

			END  
			FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
		END  
  
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
		/* CURSOR END */

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT, @module_code,  @RecordCode
    
	IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej
		SET @Is_Error='N'  
	END TRY  
	BEGIN CATCH		
		SET @Is_Error='Y'
		PRINT ERROR_MESSAGE()   
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
   
		INSERT INTO ERRORON_SENDMAIL_FOR_WORKFLOW   
		SELECT  
			ERROR_NUMBER() AS ERRORNUMBER,  
			ERROR_SEVERITY() AS ERRORSEVERITY,    
			ERROR_STATE() AS ERRORSTATE,  
			ERROR_PROCEDURE() AS ERRORPROCEDURE,  
			ERROR_LINE() AS ERRORLINE,  
			ERROR_MESSAGE() AS ERRORMESSAGE;  
	END CATCH  
END  

--SELECT template_desc FROM Email_Template WHERE Template_For='R'  
--<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}td.tblHead{border:1px solid black;
--color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px;}td.tblData{border:1px solid black;vertical-align:top;
--font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head>
--<body><div class="textFont">Dear&nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is rejected by <b>{rejected_by}</b>.
--<br /><br />     Please <a href='{link}' target='_blank'><b>click here</b></a> for more details.<br /><br /><br /><br />
--</div>   
-- <table class="tblFormat" >     <tr>      
-- <td align="center" width="15%" class="tblHead"><b>Agreement No.<b></td>
-- <td align="center" width="15%" class="tblHead"><b>Agreement Date<b></td>
-- <td align="center" width="20%" class="tblHead"><b>Deal Description<b></td>
-- <td align="center" width="20%" class="tblHead"><b>Primary Licensor<b></td>
-- <td align="center" width="30%" class="tblHead"><b>Title(s)<b></td>     </tr>     
-- <tr>
-- <td align="center" class="tblData">{Agreement_No}</td>
-- <td align="center" class="tblData">{Agreement_Date}</td>
-- <td align="center" class="tblData">{Deal_Desc}</td>
-- <td align="center" class="tblData">{Primary_Licensor}</td>
-- <td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
 
-- <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>

-- UPDATE Email_Template SET template_desc =
-- '<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold}td.tblData{border:1px solid black;vertical-align:top;font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head><body><div class="textFont">Dear&nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is rejected by <b>{rejected_by}</b>.<br /><br />     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> for more details.<br /><br /><br /><br /></div> {table} <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>'
--WHERE Template_For='R'

