CREATE PROCEDURE [dbo].[usp_Schedule_SendException_Userwise_Email] 
AS
BEGIN

/*Create User data*/
BEGIN
	
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
		Email_body NVARCHAR(max),
		ChannelCodes NVARCHAR(max)
	)
	
	CREATE TABLE #Update_STATUS
	(
		Email_Notification_Schedule_code INT,
		File_Code INT,
		Channel_Code INT,
		User_code INT
	)
					
	DECLARE @cur_user_code INT
	DECLARE @cur_login_name NVARCHAR(500)	
	DECLARE @cur_first_name NVARCHAR(500)
	DECLARE @cur_middle_name NVARCHAR(500)	
	DECLARE @cur_last_name NVARCHAR(500)
	DECLARE @cur_email_id NVARCHAR(500) 
	DECLARE @cur_security_group_name NVARCHAR(500) 
	DECLARE @cur_userFullName NVARCHAR(500) 	
	DECLARE @cur_ChannelCodes NVARCHAR(500) 	

	INSERT INTO #Users_Data 
	SELECT DISTINCT U.users_code, U.login_name, U.first_name, U.middle_Name, U.last_name, U.email_id ,
	SG.security_group_name,
	ISNULL(U.first_name, '') + ' ' + ISNULL(U.middle_Name, '') + ' ' + ISNULL(U.last_name, '') + '   ('+ ISNULL(SG.security_group_name, '') + ')'
	,'' AS Email_body, buUsers.Channel_Codes 
	FROM [dbo].[UFN_Get_Bu_Wise_User]('SCE') buUsers
	INNER JOIN Users u ON u.Users_Code = buUsers.Users_Code
	INNER JOIN Security_Group SG ON SG.security_group_code = U.security_group_code
					
END

	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config WHERE [Key] = 'SCE'


/*Loop thorugh userwise data to get the distinct file(channelwise) for each users*/
BEGIN

	DECLARE @IS_User_Send_Mail VARCHAR(1)
	SET @IS_User_Send_Mail = 'N'
	
	DECLARE cur_on_Users_Data CURSOR
	KEYset
		FOR 
			SELECT  users_code, login_name, first_name, middle_Name, last_name, email_id, security_group_name, UserFullName, ChannelCodes FROM #Users_Data
	OPEN cur_on_Users_Data
	FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,
	@cur_email_id, @cur_security_group_name, @cur_userFullName, @cur_ChannelCodes
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN		
				DECLARE @Channel_Code INT
				DECLARE @File_Code INT
				DECLARE @Email_Notification_Msg NVARCHAR(2000)
				DECLARE @Email_Notification_code INT
				SET @Email_Notification_code = 0
				
				SET @Channel_Code = 0
				SET @File_Code = 0
				SET @Email_Notification_Msg  = ''
				DECLARE @RedirectUrl VARCHAR(MAX)
				SET @RedirectUrl = ''
				DECLARE @DefaultSiteUrl VARCHAR(500);	SET @DefaultSiteUrl = ''
				SELECT @DefaultSiteUrl =  DefaultSiteUrl FROM System_Param
				
				DECLARE @DatabaseEmail_Profile VARCHAR(200)	
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				DECLARE cur_on_Userwise_File_Data CURSOR
				KEYSET FOR
					--SELECT distinct BVEC.Channel_Code,ENS.File_Code,ENS.Email_Notification_Msg FROM BVException BVE
					SELECT DISTINCT ens.Channel_Code, ENS.File_Code, ENS.Email_Notification_Msg, 0 AS Email_Notification_Schedule_Code 
					FROM Email_Notification_Schedule ens WHERE Channel_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@cur_ChannelCodes, ','))
					AND ENS.IsMailSent= 'N'	
					AND ENS.Schedule_Item_Log_Date >= GETDATE();

				OPEN cur_on_Userwise_File_Data
				FETCH NEXT FROM cur_on_Userwise_File_Data INTO @Channel_Code, @File_Code, @Email_Notification_Msg, @Email_Notification_code
				WHILE (@@fetch_status <> -1)
				BEGIN
					IF (@@fetch_status <> -2)
					BEGIN
							IF( 
								(SELECT COUNT(File_Code) FROM #Update_STATUS WHERE File_Code = @File_Code AND Channel_Code = @Channel_Code AND User_code = @cur_user_code) <= 0
							  )
							  BEGIN
									SET @IS_User_Send_Mail = 'Y'
									
									--SET @RedirectUrl = 'The schedule file has ‘Rights Exception’ for following channels.<br><br>For more details please login into the <b>RightsU System<b>. 
									--<br><br><a href='+ @DefaultSiteUrl +' target=''_blank''><b>'+ @DefaultSiteUrl+'</b></a>'	
									SET @RedirectUrl = 'The schedule file has ‘Rights Exception’ for following channels.
									<br>For more details on licensed rights, login into the RightsU System : <a href='+ @DefaultSiteUrl +' target=''_blank''><b>RightsU</b></a>'
						
									DECLARE @Emailbody AS NVARCHAR(MAX);	SET @Emailbody = ''
									DECLARE @ScheduleFileName AS NVARCHAR(2500);	SET @ScheduleFileName = ''
									SELECT @ScheduleFileName = [File_Name] FROM Upload_Files WHERE File_code = @File_Code

									DECLARE @AiringChannelName AS NVARCHAR(2500)
									SELECT @AiringChannelName = channel_name FROM Channel WHERE channel_code in(SELECT top 1 ChannelCode FROM Upload_Files WHERE File_Code = @File_Code)

									
									DECLARE @MailSubjectCr AS NVARCHAR(2500)	
									SET @MailSubjectCr = 'RightsU Email Alert : Schedule data exception '

									
									DECLARE @EMailFooter NVARCHAR(2000)
									SET @EMailFooter ='&nbsp;</br>&nbsp;</br>
									<FONT SIZE="2" COLOR="gray">This email is generated by RIGHTSU</font>'
									
									
									BEGIN
											PRINT '--===============3.5 Other Deal Rights Violation Email --==============='
						
											--Email Heading mentioned here.	
											SET @Emailbody= '<br><br>'+@AiringChannelName+'<br><br><table border="1" cellspacing="0" cellpadding="3">'				
											
									
											SET @Emailbody=@Emailbody + '<tr>
											<th style="color: #ffffff; background-color: #086B10"><b>Exception<b></th>
											<th style="color: #ffffff; background-color: #086B10"><b>Title Name<b></th>
											<th style="color: #ffffff; background-color: #086B10"><b>Right Start Date<b></th>
											<th style="color: #ffffff; background-color: #086B10"><b>Right End Date<b></th>
											<th style="color: #ffffff; background-color: #086B10"><b>Available Channels<b></th>
											<th style="color: #ffffff; background-color: #F50606"><b>Airing Channel<b></th>
											<th style="color: #ffffff; background-color: #F50606"><b>Date of Schedule<b></th>
											<th style="color: #ffffff; background-color: #F50606"><b>Time of Schedule<b></th>
											<th style="color: #ffffff; background-color: #F50606"><b>Allocated Runs<b></th>
											<th style="color: #ffffff; background-color: #F50606"><b>Consumed Runs<b></th>
											
											</tr>'
											
											SELECT @Emailbody=@Emailbody +'<tr>
											<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS NVARCHAR(1000)) +'</td>
											<td>'+ CAST  (ISNULL(e.Program_Title,' ')  AS NVARCHAR(250)) +'</td>			
											<td>'+ ISNULL(CAST(CASE WHEN
																				(
																					CAST(
																						CASE WHEN isnull(e.Right_Start_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
																							THEN '' 
																						WHEN isnull(e.Right_Start_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' 
																							THEN ''
																						ELSE e.Right_Start_Date END AS VARCHAR(250)
																						)
																				)
																			='1900-01-01 00:00:00.000'
																			THEN 'NA'
																			WHEN 
																			(
																					CAST(
																						CASE WHEN isnull(e.Right_Start_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
																							THEN '' 
																						WHEN isnull(e.Right_Start_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' 
																							THEN ''
																						ELSE e.Right_Start_Date END AS VARCHAR(250)
																						)
																				)
																				='Jan 1 1900 12:00AM'
																				THEN 'NA'
																			ELSE  convert(VARCHAR, e.Right_Start_Date, 106)
																			END  AS VARCHAR(250)),'NA')
																			+'</td>
											<td>'+ ISNULL(CAST  (CASE WHEN
																				(
																					CAST(
																						CASE WHEN isnull(e.Right_End_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
																							THEN '' 
																						WHEN isnull(e.Right_End_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' 
																							THEN ''
																						ELSE e.Right_End_Date END AS VARCHAR(250)
																						)
																				)
																			='1900-01-01 00:00:00.000'
																			THEN 'NA'
																			WHEN 
																			(
																					CAST(
																						CASE WHEN isnull(e.Right_End_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
																							THEN '' 
																						WHEN isnull(e.Right_End_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' 
																							THEN ''
																						ELSE e.Right_End_Date END AS VARCHAR(250)
																						)
																				)
																				='Jan 1 1900 12:00AM'
																				THEN 'NA'
																			ELSE  convert(VARCHAR, e.Right_End_Date, 106)
																			END  AS VARCHAR(250)),'NA') +'</td>
											<td>'+ CAST  (ISNULL(e.Available_Channels, ' ') AS NVARCHAR(250)) +'</td>
											<td>'+ CAST  (ISNULL(e.Channel_Name, ' ') AS NVARCHAR(250)) +'</td>
											<td>'+ ISNULL(convert(VARCHAR, cast(e.Schedule_Item_Log_Date as datetime), 106) ,'') +'</td>
											<td>'+ CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) +'</td>
											<td>'+ CAST  (CASE WHEN ISNULL(e.Allocated_Runs, -1) = -1 THEN '0' WHEN ISNULL(e.Allocated_Runs, -1) = 0 THEN 'UNLIMTED' ELSE CAST(e.Allocated_Runs AS VARCHAR(50)) END AS VARCHAR(250)) +'</td>
											<td>'+ CAST  (ISNULL(e.Consumed_Runs, '0') AS VARCHAR(250)) +'</td>

											</tr>' FROM Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'

											SET @Emailbody += '</table>'
											-------------------------------------------4.0A END set_EMAIL_BODY_DELETED -------------------------------------------	
									END

									UPDATE #Users_Data SET Email_body += @Emailbody WHERE users_code = @cur_user_code
									INSERT INTO #Update_STATUS VALUES (0, @File_Code, @Channel_Code, @cur_user_code)
							END
					END
					FETCH NEXT FROM cur_on_Userwise_File_Data INTO @Channel_Code ,@File_Code ,@Email_Notification_Msg, @Email_Notification_code
				END
				CLOSE cur_on_Userwise_File_Data
				DEALLOCATE cur_on_Userwise_File_Data
										
				IF(@IS_User_Send_Mail = 'Y')
				BEGIN
						DECLARE @Emailbody_Username NVARCHAR(250);	SET @Emailbody_Username = ''
						SET @Emailbody_Username = 'Dear&nbsp;' + @cur_first_name + ' ,<br><br>' 
						DECLARE @EmailTable AS NVARCHAR(MAX)
						DECLARE @Emailbody1 AS NVARCHAR(MAX);	SET @Emailbody1 = ''
						SELECT  @Emailbody1=Email_body FROM #Users_Data WHERE users_code = @cur_user_code
						SET @EmailTable = @Emailbody1
						SET @Emailbody1 =@Emailbody_Username +  @RedirectUrl + @Emailbody1  + @EMailFooter
						
						EXEC msdb.dbo.sp_send_dbmail 
						@profile_name = @DatabaseEmail_Profile,
						@recipients =  @cur_email_id,
						@subject = @MailSubjectCr,
						@body = @Emailbody1, 
						@body_format = 'HTML';  
						
						--insert into Email_Check values (@DatabaseEmail_Profile, @cur_email_id,@MailSubjectCr,@Emailbody1,'HTML' )
						PRINT 'Email sent to ' + @cur_email_id

						INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
						SELECT @Email_Config_Code, GETDATE(),'N', @EmailTable, @cur_user_code, 'Schedule Exception', @cur_email_id
				END
				SET @IS_User_Send_Mail = 'N'			

		END
	FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,
	@cur_email_id, @cur_security_group_name, @cur_userFullName, @cur_ChannelCodes
	END
	CLOSE cur_on_Users_Data
	DEALLOCATE cur_on_Users_Data
		
	DECLARE @Email_Notification_Schedule_code_cur INT, @File_code_Cur INT, @Channel_Code_Cur INT
	SET @Email_Notification_Schedule_code_cur = 0
	SET  @File_code_Cur = 0
	SET @Channel_Code_Cur = 0
	
	
	DECLARE cur_on_Update_Data CURSOR
	KEYSET
		FOR 
			SELECT DISTINCT Email_Notification_Schedule_code ,File_Code ,Channel_Code  FROM #Update_STATUS
	OPEN cur_on_Update_Data
	FETCH NEXT FROM cur_on_Update_Data INTO @Email_Notification_Schedule_code_cur,@File_code_Cur,@Channel_Code_Cur
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			UPDATE Email_Notification_Schedule SET IsMailSent = 'Y' WHERE File_Code=@File_code_Cur AND Channel_Code = @Channel_Code_Cur 
		END
	FETCH NEXT FROM cur_on_Update_Data INTO @Email_Notification_Schedule_code_cur,@File_code_Cur,@Channel_Code_Cur
	END
	CLOSE cur_on_Update_Data
	DEALLOCATE cur_on_Update_Data	
	
	
END		


	IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Users_Data
	END	
			
	IF OBJECT_ID('tempdb..#Update_STATUS') IS NOT NULL
	BEGIN
		DROP TABLE #Update_STATUS
	END	


	
	
END
	
/*	
--EXEC [dbo].[usp_Schedule_SendException_Userwise_Email] 

*/