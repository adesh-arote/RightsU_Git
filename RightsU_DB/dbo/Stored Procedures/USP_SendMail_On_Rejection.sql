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
--	 @RecordCode INT = 21617,
--	 @module_workflow_detail_code INT = 37243,
--	 @module_code INT = 30,
--	 @RedirectToApprovalList VARCHAR(100) ='N',
--	 @AutoLoginUser VARCHAR(100) ='',
--	 @Login_User INT=136,
--	 @Is_Error CHAR(1)='N'  

	SET @Is_Error='N'  
	BEGIN TRY  
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
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='ARJ'
 
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

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''


		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No,
					@Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Desc,
					@Primary_Licensor = V.Vendor_Name,
					@BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
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
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
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
   
		DECLARE @DefaultSiteUrlHold NVARCHAR(500), @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'
		SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  
		SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is rejected'   

		SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

		IF(@Is_RU_Content_Category = 'Y')
			SET  @BU_CC= 'Content Category'

		/* CURSOR START */
		
		DECLARE cur_on_rejection CURSOR KEYSET FOR 
		SELECT DISTINCT ISNULL(U1.First_Name,'') + ' ' + ISNULL(U1.Middle_Name,'') + ' ' + ISNULL(U1.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')', 
			SG.Security_Group_Name, U1.Email_Id, U1.Security_Group_Code, U1.Users_Code  
		FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BUCode)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		WHERE MWD.Module_Code = @module_code 
			AND MWD.Record_Code = @RecordCode 
			AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code


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
		
				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
				SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>     
										<td align="center" width="14%" class="tblHead">Agreement No.</td>    
										<td align="center" width="14%" class="tblHead">Agreement Date</td>   
										<td align="center" width="19%" class="tblHead">Deal Description</td> 
										<td align="center" width="19%" class="tblHead">Primary Licensor</td>   
										<td align="center" width="25%" class="tblHead">Title(s)</td>
										<td align="center" width="10%" class="tblHead">'+@BU_CC+'</td>
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
				END
				ELSE
				BEGIN 
				SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
										<td align="center" width="10%" class="tblHead">Agreement No.</td>    
										<td align="center" width="10%" class="tblHead">Agreement Date</td> 
										<td align="center" width="10%" class="tblHead">Created By</td> 
										<td align="center" width="10%" class="tblHead">Creation Date</td> 
										<td align="center" width="10%" class="tblHead">Deal Description</td> 
										<td align="center" width="10%" class="tblHead">Primary Licensor</td>   
										<td align="center" width="10%" class="tblHead">Title(s)</td>
										<td align="center" width="10%" class="tblHead">'+@BU_CC+'</td>
										<td align="center" width="10%" class="tblHead">Last Actioned By</td>
										<td align="center" width="10%" class="tblHead">Last Actioned Date</td>
						 </tr>  
						 <tr>
										<td align="center" class="tblData">{Agreement_No}</td>   
										<td align="center" class="tblData">{Agreement_Date}</td>    
										<td align="center" class="tblData">{Created_By}</td>    
										<td align="center" class="tblData">{Creation_Date}</td>    
										<td align="center" class="tblData">{Deal_Desc}</td>    
										<td align="center" class="tblData">{Primary_Licensor}</td>   
										<td align="center" class="tblData">{Titles}</td> 
										<td align="center" class="tblData">{BU_Name}</td> 
										<td align="center" class="tblData">{Last_Actioned_By}</td> 
										<td align="center" class="tblData">{Last_Actioned_Date}</td> 
						</tr>  
					</table>'
				END

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
			
				IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
				BEGIN
					SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
					SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
				END

				SET @CC = ''  
				SET @body1 = replace(@body1,'{table}',@Email_Table)
				--IF(@Is_Mail_Send_To_Group='Y')  
				--BEGIN  
				--	SELECT @CC = @CC + ';' + Email_Id FROM Users WHERE security_group_code IN (@cur_security_group_code)   
				--	AND Users_Code NOT IN (@cur_user_code)  
				--END
  
				DECLARE @DatabaseEmail_Profile varchar(200)	= ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile, 
				@recipients =  @cur_email_id, 
				@copy_recipients = @CC, 
				@subject = @MailSubjectCr, 
				@body = @body1,@body_format = 'HTML';

				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id
			END  
			FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
		END  
  
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
		/* CURSOR END */
    
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



