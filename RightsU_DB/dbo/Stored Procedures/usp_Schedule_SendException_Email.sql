﻿CREATE PROCEDURE [dbo].[usp_Schedule_SendException_Email] 
(
	@File_Code INT,
	@Channel_Code INT,
	@EmailFor VARCHAR(500) = NULL
)
AS
BEGIN 
-- =============================================
/*	
Steps:- Send an Schedule exception emails.
1.0	Email need to be send or not is depend on System_Parameter.
2.0 Define global variables.
	2.1	Define Email Subnect.
	2.2	Define Email Footer Msg.
	2.3	Database Email Profile is get from Sysytem_Parameter.
3.0	SET_EMAIL_BODY
	3.1 FILE IS REJECT DUE TO ImproperFile.
	3.2	FILE IS REJECT DUE TO InvalidSchedule.
	3.3	FILE IS REJECT DUE TO InvalidScheduleDate.
	3.4 FILE IS REJECT DUE TO HouseIDNotFound.
	3.5	FILE IS REJECT DUE TO Package Fail.
	3.6 Other Deal Rights Violation Email.
	
4.0 LOOPING THROUGH USERS DATA.
*/
-- =============================================
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

BEGIN TRY
	
	IF(@EmailFor IS NULL)
		SET @EmailFor = 'N'
	-----1.0-----
	DECLARE @Is_Mail_Send_ScheduleAsRun AS VARCHAR(1);	SET @Is_Mail_Send_ScheduleAsRun = 'Y'
	SELECT @Is_Mail_Send_ScheduleAsRun = parameter_value FROM system_parameter_new WHERE LTRIM(RTRIM(Parameter_Name)) = 'Is_Mail_Send_ScheduleAsRun'

	IF(@Is_Mail_Send_ScheduleAsRun = 'Y')
	BEGIN
	
		IF((SELECT ISNULL(Parameter_Value, 'N') FROM System_Parameter_New WHERE Parameter_Name = 'IS_Schedule_Mail_Channelwise')  = 'N' )
		BEGIN
			IF(@EmailFor = 'PkgFail')
			BEGIN
				
				INSERT INTO Email_Notification_Schedule (File_Code, Channel_Code, Email_Notification_Msg, IsMailSent)
				VALUES (@File_Code, @Channel_Code, @EmailFor, 'N')
				
				EXEC usp_Schedule_SendException_Userwise_Email 
				RETURN

			END
		END
		
		DECLARE @Exception_Cnt AS INT;	SET @Exception_Cnt = 0
		SELECT @Exception_Cnt = COUNT(*) FROM Email_Notification_Schedule WHERE File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N' AND ISNULL(IsPrimeException,'N') = 'N'
		DECLARE @DeletedCnt INT = 0
		SELECT @DeletedCnt = COUNT(*) FROM Temp_BV_Schedule_DeletedRecords WHERE File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
		
		DECLARE @ToatlException_Cnt INT = @Exception_Cnt + @DeletedCnt
		IF(@ToatlException_Cnt > 0)
		BEGIN
			------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
			IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL
			BEGIN
				DROP TABLE #Users_Data
			END
			------------------------------------------- END DELETE TEMP TABLES -------------------------------------------	

			-------------------------------------------2.0 GLOBAL VARIBALES -------------------------------------------
			--SELECT SITE URL
			DECLARE @DefaultSiteUrl VARCHAR(500);	SET @DefaultSiteUrl = ''
			SELECT @DefaultSiteUrl =  DefaultSiteUrl FROM System_Param
				
			DECLARE @UserName AS NVARCHAR(250);	SET @UserName = ''
			DECLARE @Emailbody AS NVARCHAR(MAX);	SET @Emailbody = ''
			DECLARE @ScheduleFileName AS NVARCHAR(250);	SET @ScheduleFileName = ''
			SELECT @ScheduleFileName = [File_Name] FROM Upload_Files WHERE File_code = @File_Code
			
			DECLARE @AiringChannelName AS NVARCHAR(250)
			SELECT @AiringChannelName = channel_name FROM Channel WHERE channel_code in
			(
				select top 1 ChannelCode from Upload_Files WHERE File_Code = @File_Code
			)
			
			-----2.1-----
			DECLARE @MailSubjectCr AS NVARCHAR(250)	
			SET @MailSubjectCr = 'RightsU Email Alert : Schedule data exception for '+@AiringChannelName+' channel' 
			
			-----2.2-----
			DECLARE @EMailFooter NVARCHAR(200)
			SET @EMailFooter ='&nbsp;</br>&nbsp;</br>
			<FONT SIZE="2" COLOR="gray">This email is generated by RIGHTSU</font>'
			
			-----2.3-----
			DECLARE @DatabaseEmail_Profile varchar(200)	
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
			-------------------------------------------2.0 END GLOBAL VARIBALES -------------------------------------------
			
			-------------------------------------------3.0 SET_EMAIL_BODY -------------------------------------------
			IF(@EmailFor = 'ImproperFile' OR @EmailFor = 'InvalidSchedule' OR @EmailFor = 'InvalidScheduleDate' OR @EmailFor = 'PkgFail')
			BEGIN
				PRINT '--===============3.1 FILE IS REJECT DUE TO ImproperFile ==============='
				--Email Heading mentioned here.
				DECLARE @EmailMsgText NVARCHAR(100) = 'been rejected'
				IF(@EmailFor = 'PkgFail')
					SET @EmailMsgText = 'exception'

				SET @Emailbody= 'The schedule file <b> ' + @ScheduleFileName + '</b> has '+ @EmailMsgText +'  for '+ @AiringChannelName+' channel. 
				<br>Exception details are given below.
				<br><br>For more details please login into the <b>RightsU System<b>. 
				<br><br><a href='+ @DefaultSiteUrl +' target=''_blank''><b>'+ @DefaultSiteUrl+'</b></a>
				<br><br><table border="1" cellspacing="0" cellpadding="3">'
						
				--Table Heading mentioned below
				SET @Emailbody=@Emailbody + '<tr>
				<td style="color: #ffffff; background-color: #086B10"><b>Exception<b></td>
				<td style="color: #ffffff; background-color: #086B10"><b>Title Name<b></td>
				<td style="color: #ffffff; background-color: #086B10"><b>Right Start Date<b></td>
				<td style="color: #ffffff; background-color: #086B10"><b>Right End Date<b></td>
				
				<td style="color: #ffffff; background-color: #086B10"><b>Available Channels<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Consumed<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Airing Channel<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Date of Schedule<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Time of Schedule<b></td>
				
				</tr>'				

				--Table contents are mentioned below
				SELECT @Emailbody=@Emailbody +'<tr>
				<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS NVARCHAR(1000)) +' </td>
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>						
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>						
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>												
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>
				
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>
				<td>'+ CAST  ('-------' AS NVARCHAR(250))  +'</td>

				</tr>'
				FROM Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
			END
			ELSE IF(@EmailFor = 'PrimeTime_Over_Run' OR @EmailFor = 'OffPrimeTime_Over_Run')
			BEGIN
				--Email Heading mentioned here.
				SET @Emailbody= 'The schedule file <b> ' + @ScheduleFileName + '</b> has exception for '+ @AiringChannelName+' channel. 
				<br>Exception details are given below.
				<br><br>For more details please login into the <b>RightsU System<b>. 
				<br><br><a href='+ @DefaultSiteUrl +' target=''_blank''><b>'+ @DefaultSiteUrl+'</b></a>
				<br><br><table border="1" cellspacing="0" cellpadding="3">'				
				
				--Table Heading mentioned below
				SET @Emailbody=@Emailbody + '<tr>
					<td style="color: #ffffff; background-color: #086B10"><b>Exception<b></td>
					<td style="color: #ffffff; background-color: #086B10"><b>Title Name<b></td>	
				</tr>'
				
				--Table contents are mentioned below
				SELECT @Emailbody=@Emailbody +'<tr>
					<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS NVARCHAR(1000)) +'</td>
					<td>'+ CAST  (ISNULL(e.Program_Title,' ')  AS NVARCHAR(250)) +'</td>
				</tr>'
				FROM Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
				AND ISNULL(IsRunCountCalculate,'N') = 'N'
				
			END
			BEGIN
				PRINT '--===============3.5 Other Deal Rights Violation Email --==============='
			
				--Email Heading mentioned here.
				SET @Emailbody= 'The schedule file <b> ( ' + @ScheduleFileName + ' )</b> has exception for '+ @AiringChannelName+' channel. 
				<br>Exception details are given below.
				<br><br>For more details please login into the <b>RightsU System<b>. 
				<br><br><a href='+ @DefaultSiteUrl +' target=''_blank''><b>'+ @DefaultSiteUrl+'</b></a>
				<br><br><table border="1" cellspacing="0" cellpadding="3">'				
				
				--Table Heading mentioned below
				SET @Emailbody = @Emailbody + '<tr>
				<td style="color: #ffffff; background-color: #086B10"><b>Exception<b></td>
				<td style="color: #ffffff; background-color: #086B10"><b>Title Name<b></td>
				<td style="color: #ffffff; background-color: #086B10"><b>Right Start Date<b></td>
				<td style="color: #ffffff; background-color: #086B10"><b>Right End Date<b></td>
				<td style="color: #ffffff; background-color: #086B10"><b>Available Channels<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Consumed<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Airing Channel<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Date of Schedule<b></td>
				<td style="color: #ffffff; background-color: #F50606"><b>Time of Schedule<b></td>
				
				</tr>'
				
				--Table contents are mentioned below
				SELECT @Emailbody = @Emailbody +'<tr>
				<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS NVARCHAR(1000)) +'</td>
				<td>'+ CAST  (ISNULL(e.Title_Name,' ')  AS NVARCHAR(250)) +'</td>
				<td>'+ CAST  (ISNULL(e.Right_Start_Date,' ') AS VARCHAR(250)) +'</td>
				<td>'+ CAST  (ISNULL(e.Right_End_Date,' ')  AS VARCHAR(250))  +'</td>
				<td>'+ CAST  (ISNULL(e.Available_Channels, ' ') AS VARCHAR(250)) +'</td>
				<td>'+ CAST  (ISNULL(e.Count_Of_Schedule, ' ') AS VARCHAR(250)) +'</td>
				<td>'+ CAST  (ISNULL(e.Channel_Name, ' ') AS NVARCHAR(250)) +'</td>
				<td>'+ CAST  (ISNULL(Schedule_Item_Log_Date,' ') AS VARCHAR(250))  +'</td>
				<td>'+ CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) +'</td>
				</tr>'
				FROM Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
				AND ISNULL(IsRunCountCalculate,'N') = 'Y'
								
				--Table contents are mentioned below
				SELECT @Emailbody = @Emailbody +'<tr>
				<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS NVARCHAR(1000)) +'</td>
				<td>'+ CAST  (ISNULL(e.Program_Title,' ')  AS NVARCHAR(250)) +'</td>			
				<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
				<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
				
				<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
				<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
				<td>'+ CAST  (ISNULL(e.Channel_Name, ' ') AS NVARCHAR(250)) +'</td>
				<td>'+ CAST  (ISNULL(Schedule_Item_Log_Date,' ') AS VARCHAR(250))  +'</td>
				<td>'+ CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) +'</td>
				

				</tr>'
				FROM Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
				AND ISNULL(IsRunCountCalculate,'N') = 'N'
				-------------------------------------------4.0A START SET_EMAIL_BODY_DELETED -------------------------------------------
				IF(@DeletedCnt > 0)
				BEGIN
					--- We are still ignoring the records which have no houseid's. THIS IS BECAUSE WHEN THE MOVIE IS SCHEDULE AT THAT TIME
					--- USERS DOES NOT HAVE THE HOUSE IDS. Later on as and when they receive they enter it into BV system. 
					DECLARE @Emailbody_Deleted AS NVARCHAR(MAX);	SET @Emailbody_Deleted = ''
					PRINT 'DELTED Records'
					
					IF(@Exception_Cnt <= 0)
					BEGIN
						SET @Emailbody = ''
						--Email Heading mentioned here.
						SET @Emailbody = 'The schedule file <b> ' + @ScheduleFileName + '</b> has exception for '+ @AiringChannelName+' channel. 
						<br>Exception details are given below.
						<br><br>For more details please login into the <b>RightsU System<b>. 
						<br><br><a href='+ @DefaultSiteUrl +' target=''_blank''><b>'+ @DefaultSiteUrl+'</b></a>
						<br><br><table border="1" cellspacing="0" cellpadding="3">'			
					END
					ELSE
					BEGIN
						SET @Emailbody = @Emailbody + '</table>'
					END
					
					--Email Heading mentioned here.
					SET @Emailbody_Deleted = '<br>
					<b>Following records are not process due to invalid range of HouseId.<b>
					<br><br><table border="1" cellspacing="0" cellpadding="3">'
					
					--Table Heading mentioned below
					SET @Emailbody_Deleted=@Emailbody_Deleted + '<tr>
					<td style="color: #ffffff; background-color: #086B10"><b>Exception<b></td>
					<td style="color: #ffffff; background-color: #086B10"><b>Title Name<b></td>
					<td style="color: #ffffff; background-color: #086B10"><b>Right Start Date<b></td>
					<td style="color: #ffffff; background-color: #086B10"><b>Right End Date<b></td>
					
					<td style="color: #ffffff; background-color: #086B10"><b>Available Channels<b></td>
					<td style="color: #ffffff; background-color: #F50606"><b>Consumed<b></td>
					<td style="color: #ffffff; background-color: #F50606"><b>Airing Channel<b></td>
					<td style="color: #ffffff; background-color: #F50606"><b>Date of Schedule<b></td>
					<td style="color: #ffffff; background-color: #F50606"><b>Time of Schedule<b></td>
					
					</tr>'				
					
					--Table contents are mentioned below
					SELECT @Emailbody_Deleted=@Emailbody_Deleted +'<tr>
					<td>'+ CAST  (ISNULL('Unhandled Exception', ' ') AS NVARCHAR(1000)) +'</td>
					<td>'+ CAST  (ISNULL(e.Program_Title,' ')  AS NVARCHAR(250)) +'</td>			
					<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
					<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
					
					<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
					<td>'+ CAST  ('-------' AS NVARCHAR(250)) +'</td>
					<td>'+ CAST  (ISNULL('-------', ' ') AS NVARCHAR(250)) +'</td>
					<td>'+ CAST  (ISNULL(Schedule_Item_Log_Date,' ') AS VARCHAR(250))  +'</td>
					<td>'+ CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) +'</td>
					

					</tr>'
					FROM Temp_BV_Schedule_DeletedRecords e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
					
					/*
					<td>'+ CAST  (ISNULL(Scheduled_Version_House_Number_List, ' ') AS VARCHAR(250))+'</td>	-- Not Needed for Sony
					*/
					SET @Emailbody = @Emailbody + @Emailbody_Deleted
					PRINT @Emailbody 
				END
				-------------------------------------------4.0A END SET_EMAIL_BODY_DELETED -------------------------------------------	
			END
			-------------------------------------------3.0 END SET_EMAIL_BODY -------------------------------------------

			-------------------------------------------4.0 LOOPING_THROUGH_USERS_DATA -------------------------------------------
			CREATE TABLE #Users_Data
			(
				users_code INT, 
				login_name NVARCHAR(250), 
				first_name NVARCHAR(250), 
				middle_Name NVARCHAR(250),
				last_name NVARCHAR(250),
				email_id NVARCHAR(250),
				security_group_name NVARCHAR(250),
				UserFullName NVARCHAR(250),
			)
			
			INSERT INTO #Users_Data (users_code, login_name, first_name, middle_Name, last_name, email_id, security_group_name, UserFullName)
			SELECT U.users_code, U.login_name, U.first_name, U.middle_Name, U.last_name,U.email_id ,
			SG.security_group_name,
			ISNULL(U.first_name,'') + ' ' + ISNULL(U.middle_Name,'') + ' ' + ISNULL(U.last_name,'') + '   ('+ ISNULL(SG.security_group_name,'') + ')'
			FROM BVException bve
			INNER JOIN BVException_Channel bve_c on bve_c.bv_exception_code = bve.bv_exception_code and bve_c.channel_code = @Channel_Code
			INNER JOIN BVException_Users bve_u on bve_u.bv_exception_code = bve.bv_exception_code
			INNER JOIN Users U on U.users_code = bve_u.users_code
			INNER JOIN Security_Group SG ON SG.security_group_code = U.security_group_code
			WHERE bve.bv_exception_type = 'S'

			DECLARE @cur_user_code INT
			DECLARE @cur_login_name NVARCHAR(500)	
			DECLARE @cur_first_name NVARCHAR(500)
			DECLARE @cur_middle_name NVARCHAR(500)	
			DECLARE @cur_last_name NVARCHAR(500)
			DECLARE @cur_email_id NVARCHAR(500) 
			DECLARE @cur_security_group_name NVARCHAR(500) 
			DECLARE @cur_userFullName NVARCHAR(500) 	


			--set @cur_email_id = ''
			--//---------- CURSOR START ----------//--
			DECLARE cur_on_Users_Data CURSOR
			KEYSET
			FOR SELECT  users_code, login_name, first_name, middle_Name, last_name, email_id, security_group_name, UserFullName
			FROM #Users_Data
			OPEN cur_on_Users_Data
			FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,
			@cur_email_id, @cur_security_group_name, @cur_userFullName
			WHILE (@@fetch_status <> -1)
			BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
					PRINT 'IN CURSOR'
					DECLARE @Emailbody_Username NVARCHAR(250);	SET @Emailbody_Username = ''
					SET @Emailbody_Username = 'Dear &nbsp;' + @cur_userFullName + ' ,<br><br>'
					
					DECLARE @Emailbody1 AS NVARCHAR(MAX);	SET @Emailbody1 = ''
					SET @Emailbody1 = @Emailbody+'</table>'				
					SET @Emailbody1 =@Emailbody_Username + @Emailbody1 + @EMailFooter


					PRINT ' @Emailbody_Username ' + cast(@Emailbody_Username  as NVARCHAR)
					PRINT ' DatabaseEmail_Profile ' + cast(@DatabaseEmail_Profile  as NVARCHAR)
					PRINT ' @MailSubjectCr ' + cast(@MailSubjectCr  as NVARCHAR)
					PRINT ' @Emailbody ' + cast(@Emailbody1  as NVARCHAR)
					
					EXEC msdb.dbo.sp_send_dbmail 
					@profile_name = @DatabaseEmail_Profile,
					@recipients =  @cur_email_id,
					@subject = @MailSubjectCr,
					@body = @Emailbody1, 
					@body_format = 'HTML';  
										
					PRINT 'Email sent to ' + @cur_email_id
					SET @cur_email_id = ''
					
				END
			FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,
			@cur_email_id, @cur_security_group_name, @cur_userFullName
			END
			CLOSE cur_on_Users_Data
			DEALLOCATE cur_on_Users_Data
			--//---------- CURSOR END----------//--
			-------------------------------------------4.0 LOOPING_THROUGH_USERS_DATA -------------------------------------------			
			
			UPDATE Email_Notification_Schedule SET IsMailSent = 'Y' WHERE File_Code = @File_Code				
			UPDATE Temp_BV_Schedule_DeletedRecords SET IsMailSent = 'Y' WHERE File_Code = @File_Code				
				
			------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
			IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL
			BEGIN
				DROP TABLE #Users_Data
			END
			------------------------------------------- END DELETE TEMP TABLES -------------------------------------------	
		END
		ELSE
		BEGIN
			PRINT 'DO NOTHING'
		END
	END
	
END TRY
BEGIN CATCH
	PRINT 'ERROR'
	
	PRINT ERROR_MESSAGE() 
	CLOSE cur_on_Users_Data
	DEALLOCATE cur_on_Users_Data
	
	INSERT INTO	ERRORON_SENDMAIL_FOR_WORKFLOW 
	SELECT
	ERROR_NUMBER() AS ERRORNUMBER,
	ERROR_SEVERITY() AS ERRORSEVERITY,		ERROR_STATE() AS ERRORSTATE,
	ERROR_PROCEDURE() AS ERRORPROCEDURE,
	ERROR_LINE() AS ERRORLINE,
	ERROR_MESSAGE() AS ERRORMESSAGE;
END CATCH

END

/*
EXEC [usp_Schedule_SendException_Email] 32, 1,'N'
EXEC [usp_Schedule_SendException_Email] 3890, 2, 'N' 
*/

/*
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
GO
RECONFIGURE;
GO

INSERT INTO OPENROWSET ('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=\\Uto18\Ex\contact.xls;HDR=YES',
'SELECT * FROM [Sheet1$]')
select CustomerCode,CustFirstName,CustEmailID From Customer

			UPDATE Email_Notification_Schedule SET IsMailSent = 'N' WHERE File_Code = 32				
			UPDATE Temp_BV_Schedule_DeletedRecords SET IsMailSent = 'N' WHERE File_Code = 32

*/