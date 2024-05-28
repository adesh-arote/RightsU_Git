CREATE PROCEDURE [dbo].[USP_SendMail_Intimation_New]
	@RecordCode INT,
	@module_workflow_detail_code INT,
	@module_code INT,
	@RedirectToApprovalList VARCHAR(100),
	@AutoLoginUser VARCHAR(100),
	@Is_Error CHAR(1) OUTPUT
AS  
-- =============================================  
-- Author:  Dadasaheb G. Karande  
-- Create date: 03-FEB-2011  
-- Description: To Send mail to a Last All approver after the Aquisition Or Syndication deal   
--    is approve from user  
-- =============================================  
BEGIN  

	--DECLARE 
	--@RecordCode INT =15510,
	--@module_workflow_detail_code INT = 0,
	--@module_code INT = 30,
	--@RedirectToApprovalList VARCHAR(100)='WA',
	--@AutoLoginUser VARCHAR(100) = 203,
	--@Is_Error CHAR(1)

	SET NOCOUNT ON; 
	SET @Is_Error='N'  

	IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

	BEGIN TRY
		DECLARE @Approved_by VARCHAR(MAX) SET @Approved_by=''
		DECLARE @cur_first_name NVARCHAR(500)
		DECLARE @cur_security_group_name NVARCHAR(500)
		DECLARE @cur_email_id VARCHAR(500)
		DECLARE @cur_security_group_code VARCHAR(500)
		DECLARE @cur_user_code INT
		DECLARE @cur_next_level_group INT

		DECLARE @DealType VARCHAR(100) = ''
		DECLARE @DealNo VARCHAR(500) = 0
		DECLARE @body1 NVARCHAR(MAX) = ''
		DECLARE @MailSubjectCr NVARCHAR(500)  
		DECLARE @CC VARCHAR(MAX) = ''  
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)  
		DECLARE @BU_Code Int = 0
		DECLARE  @DefaultSiteUrl_Param NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl VARCHAR(500) SET @DefaultSiteUrl = ''  
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='AIN'

		SELECT @Approved_by = --ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') 
		ISNULL(UPPER(LEFT(U.First_Name,1))+LOWER(SUBSTRING(U.First_Name,2,LEN(U.First_Name))), '') 
		+ ' ' + ISNULL(UPPER(LEFT(U.Middle_Name,1))+LOWER(SUBSTRING(U.Middle_Name,2,LEN(U.Middle_Name))), '') 
		+ ' ' + ISNULL(UPPER(LEFT(U.Last_Name,1))+LOWER(SUBSTRING(U.Last_Name,2,LEN(U.Last_Name))), '') 
		+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
		FROM Users U  
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U.Security_Group_Code  
		WHERE Users_Code   = @AutoLoginUser 

		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param --// SET A FLAG FOR SEND MAIL TO INDIVIDUAL PERSON OR SECURITY GROUP //--  

		IF(@module_code = 30)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 35)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal  WHERE Syn_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 163)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal  WHERE Music_Deal_Code = @RecordCode 
		END

		DECLARE 
			@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', @Primary_Licensor NVARCHAR(MAX) = '', 
			@Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0 ,@BU_Name VARCHAR(MAX) = ''
	
		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New 
			WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106),
					@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name, @BU_Name = BU.Business_Unit_Name
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
				WHERE Acq_Deal_Code = @RecordCode

			
				SELECT @Title_Count = COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
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
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
				WHERE Syn_Deal_Code = @RecordCode
			
				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
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
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name,@BU_Name = BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
  
		/* CHECK THAT DEAL IS APPROVED THROUGH ALL WORKFLOW LEVEL OR NOT */
		DECLARE @Is_Deal_Approved INT  = 0  
		SELECT @Is_Deal_Approved = COUNT(*) FROM Module_Workflow_Detail MWD 
		WHERE  Module_Workflow_Detail_Code IN (  
			SELECT Module_Workflow_Detail_Code FROM Module_Workflow_Detail 
			WHERE Record_Code = @RecordCode  AND Module_Code = @module_code  AND Is_Done = 'N'  
		)
   
		/* GET NEXT APPROVAL NAME */
		DECLARE @NextApprovalName NVARCHAR(500) = ''  
		SELECT @NextApprovalName = Security_Group_Name FROM Security_Group   
		WHERE Security_Group_Code IN (
			SELECT ISNULL(Next_Level_Group, 0) FROM Module_Workflow_Detail WHERE Module_Workflow_Detail_Code = @module_workflow_detail_code
		)    
    
		/* SELECT SITE URL */
		DECLARE @DefaultSiteUrlHold VARCHAR(500)
		SELECT  @DefaultSiteUrl_Param = DefaultSiteUrl , @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  

		IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

		CREATE TABLE #TempCursorOnRej (
			Email_id NVARCHAR(500),
			First_name NVARCHAR(MAX),
			Security_group_name NVARCHAR(500),
			Next_level_group INT,
			Security_group_code INT,
			User_code INT 
		)

		IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
			INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
			SELECT DISTINCT U2.Email_Id, 
			ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, 
			MWD.Next_Level_Group, 
			U2.Security_Group_Code, 
			U2.Users_Code 
			FROM Users U1
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			INNER JOIN Module_Workflow_Detail MWD ON MWD.Primary_User_Code = U1.Users_Code AND MWD.Is_Done = 'Y' 
			AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code
		ELSE
			INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
			SELECT DISTINCT U2.Email_Id, 
			ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, 
			MWD.Next_Level_Group, 
			U2.Security_Group_Code, 
			U2.Users_Code 
			FROM Users U1
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			INNER JOIN Module_Workflow_Detail MWD ON MWD.Primary_User_Code = U1.Users_Code AND MWD.Is_Done = 'Y' 
			AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code

		/* CURSOR START */
		DECLARE cur_on_rejection CURSOR KEYSET FOR 
		SELECT Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code FROM #TempCursorOnRej
		OPEN cur_on_rejection  
		FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, @cur_next_level_group, @cur_security_group_code, @cur_user_code  
		WHILE (@@fetch_status <> -1)  
		BEGIN  
			IF (@@fetch_status <> -2)  
			BEGIN  
				SELECT @DefaultSiteUrl  = @DefaultSiteUrlHold

				IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
				BEGIN
					SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=Y&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'
				
					select @body1 = template_desc FROM Email_template WHERE Template_For='AR'
					SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
					set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
					set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
					set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
					set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
					SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 
					

					
					IF (@RedirectToApprovalList = 'WA')
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Sent For Archive' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Sent For Archive by') 
					END
					ELSE IF @RedirectToApprovalList = 'AR'
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Archived' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Approved For Archived by') 
					END
					ELSE IF @RedirectToApprovalList = 'A'
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Rejected For Archive' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Rejected For Archive by') 
					END
				END
				ELSE
				BEGIN
					SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'

					IF(@Is_Deal_Approved > 0)  /* IF DEAL IS NOT APPROVED BY ALL WORKFLOW */
					BEGIN  
						print '1'
						--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) + 
						--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
						select @body1 = template_desc FROM Email_template WHERE Template_For='I'
						SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
						set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
						set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
						set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
						set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
						SET @body1 = REPLACE(@body1, '{next_approval}',@NextApprovalName) 		
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is sent for approve to next approval'   
					END  
					ELSE IF(@Is_Deal_Approved = 0) /* IF DEAL APPROVED BY ALL WORKFLOW */
					BEGIN  
						print '2'
						--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) + 
						--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
						select @body1 = template_desc FROM Email_template WHERE Template_For='D'
						SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
						set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
						set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
						set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
						set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
						SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is approved'   
					END  
				END

				DECLARE @Email_Table NVARCHAR(MAX) = ''
				SET @Email_Table = '
				<table class="tblFormat" style="width:100%">    
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

				print @DefaultSiteUrl
				IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
				BEGIN
					SET @body1 = replace(@body1,'{Agreement_No}',@Agreement_No)  
					SET @body1 = REPLACE(@body1,'{Agreement_Date}',@Agreement_Date)  
					SET @body1 = REPLACE(@body1,'{Deal_Desc}',@Deal_Desc)  
					SET @body1 = replace(@body1,'{Primary_Licensor}',@Primary_Licensor)  
					SET @body1 = replace(@body1,'{Titles}',@Titles)  
					SET @body1 = replace(@body1,'{BU_Name}',@BU_Name)
					SET @CC=''  
					--SET @body1 = replace(@body1,'{table}',@Email_Table)
				END
				ELSE
				BEGIN
					SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
					SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
					SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
					SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
					SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
					SET @Email_Table = replace(@Email_Table,'{BU_Name}',@BU_Name)
					SET @CC=''  
					SET @body1 = replace(@body1,'{table}',@Email_Table)
				END

				DECLARE @DatabaseEmail_Profile varchar(200)	= ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				
				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile  
				,@recipients =  @cur_email_id    
				,@copy_recipients = @CC  
				,@subject = @MailSubjectCr  
				,@body = @body1,@body_format = 'HTML';    


				IF (@RedirectToApprovalList = 'WA')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Waiting for Archive', @Cur_email_id
				ELSE IF (@RedirectToApprovalList = 'AR')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Archived', @Cur_email_id
				ELSE IF (@RedirectToApprovalList = 'A')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Rejected For Archive', @Cur_email_id
				ELSE
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id
				
			END  
			FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, 
			@cur_next_level_group ,@cur_security_group_code ,@cur_user_code  
		END
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
		/* CURSOR END */

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

--change script
--select  template_desc FROM Email_template WHERE Template_For='D'
--<html>   <head>    <style>     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     
--td.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
--font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
--font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          
--#divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />
--The {deal_type} Deal No: <b>{deal_no}</b> is approved.<br /><br />     Please <a href='{link}' target='_blank'><b>click here</b>
--</a> for more details.<br /><br /><br />    </div>    
--<table class="tblFormat" >     <tr>      
--<th align="center" width="15%" class="tblHead"><b>Agreement No.<b></th>      
--<th align="center" width="15%" class="tblHead"><b>Agreement Date<b></th>      
--<th align="center" width="20%" class="tblHead"><b>Deal Description<b></th>      
--<th align="center" width="20%" class="tblHead"><b>Primary Licensor<b></th>      
--<th align="center" width="30%" class="tblHead"><b>Title(s)<b></th>     </tr>     
--<tr>      <td align="center" class="tblData">{Agreement_No}</td>      
--<td align="center" class="tblData">{Agreement_Date}</td>      
--<td align="center" class="tblData">{Deal_Desc}</td>      
--<td align="center" class="tblData">{Primary_Licensor}</td>      
--<td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
--<br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>


--select  template_desc FROM Email_template WHERE Template_For='D'
--UPDATE Email_template SET template_desc=
--'<html><head><style>table.tblFormat{border:1px solid black;border-collapse:collapse;} th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;      font-family:verdana; font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     } #divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is approved.<br /><br />     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> for more details.<br /><br /><br />    </div>{table} <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>'
--WHERE Template_For='D'

--select template_desc FROM Email_template WHERE Template_For='I'

--<html>   <head>    <style type="text/css">     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     
--td.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
--font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
--font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          
--#divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />    
-- The {deal_type} Deal No: <b>{deal_no}</b> is sent to {next_approval} for approval.<br /><br />     Please <a href='{link}' target='_blank'>
-- <b>click here</b></a> for more details.<br /><br /><br /><br />    </div>    
 
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

--UPDATE Email_template SET template_desc =
--'<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px; font-weight:bold}td.tblData{border:1px solid black;vertical-align:top;font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head><body><div class="textFont">Dear &nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is sent to {next_approval} for approval.<br /><br />Please <a href=''{link}'' target=''_blank''> <b>click here</b></a> for more details.<br /><br /><br /><br />    </div> {table}  <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU</div></body></html>'
--WHERE Template_For='I'
--change script