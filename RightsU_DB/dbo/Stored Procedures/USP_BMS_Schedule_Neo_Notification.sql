CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Neo_Notification]
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Neo_Notification]', 'Step 1', 0, 'Started Procedure', 0, ''

	DECLARE @Email_Config_Code INT, @Notification_Subject VARCHAR(2000) = '', @Notification_Body VARCHAR(MAX) = '', @Event_Platform_Code INT = 0, @Event_Template_Type CHAR(1) = ''
	DECLARE curNotificationPlatforms CURSOR FOR 
			SELECT ec.Email_Config_Code, et.[Subject], et.Template, ect.Event_Platform_Code, ect.Event_Template_Type
			FROM Email_Config ec
			INNER JOIN Email_Config_Template ect ON ec.Email_Config_Code = ect.Email_Config_Code
			INNER JOIN Event_Template et ON ect.Event_Template_Code = et.Event_Template_Code
			WHERE ec.[Key] = 'SCE'
	--Change
	OPEN curNotificationPlatforms 
	FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type
	WHILE @@FETCH_STATUS = 0 
	BEGIN

		/*Create User data*/
		BEGIN
		--insert into Email_Check values ('1', '2','3','4','HTML' )
	
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
			Email_body NVARCHAR(max)
		)
	
		CREATE TABLE #Update_STATUS
		(
			Email_Notification_Schedule_code INT,
			File_Code INT,
			Channel_Code INT,
			User_code INT
		)

		--CREATE TABLE #Users_Email_Data
		--(
		--	ID int identity(1,1),
		--	users_code INT, 
		--	Channel_code INT,
		--	File_code INT ,
		--	Email_ID varchar(1000),
		--	Email_body varchar(max)
		--)
	
					
		DECLARE @cur_user_code INT
		DECLARE @cur_login_name NVARCHAR(500)	
		DECLARE @cur_first_name NVARCHAR(500)
		DECLARE @cur_middle_name NVARCHAR(500)	
		DECLARE @cur_last_name NVARCHAR(500)
		DECLARE @cur_email_id NVARCHAR(500) 
		DECLARE @cur_security_group_name NVARCHAR(500) 
		DECLARE @cur_userFullName NVARCHAR(500) 	

		INSERT INTO #Users_Data 
		select distinct U.users_code, U.login_name, U.first_name, U.middle_Name, U.last_name,U.email_id ,
		SG.security_group_name,
		ISNULL(U.first_name,'') + ' ' + ISNULL(U.middle_Name,'') + ' ' + ISNULL(U.last_name,'') + '   ('+ ISNULL(SG.security_group_name,'') + ')'
		,'' as Email_body 
		from BVException bve (NOLOCK)
		INNER JOIN BVException_Channel bve_c (NOLOCK) on bve_c.bv_exception_code = bve.bv_exception_code --and bve_c.channel_code = @Channel_Code
		INNER JOIN BVException_Users bve_u (NOLOCK) on bve_u.bv_exception_code = bve.bv_exception_code
		INNER JOIN Users U (NOLOCK) on U.users_code = bve_u.users_code
		INNER JOIN Security_Group SG (NOLOCK) ON SG.security_group_code = U.security_group_code
		WHERE bve.bv_exception_type = 'S'
				
	END


		/*Loop thorugh userwise data to get the distinct file(channelwise) for each users*/
		BEGIN

		DECLARE @IS_User_Send_Mail varchar(1)
		set @IS_User_Send_Mail = 'N'
	
		DECLARE cur_on_Users_Data CURSOR
		KEYSET
			FOR 
				SELECT  users_code, login_name, first_name, middle_Name, last_name, email_id, security_group_name, UserFullName FROM #Users_Data
		OPEN cur_on_Users_Data
		FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,
		@cur_email_id, @cur_security_group_name, @cur_userFullName
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN	
					DECLARE @Channel_Code INT
					DECLARE @File_Code INT
					DECLARE @Email_Notification_Msg NVARCHAR(2000)
				
					DECLARE @Email_Notification_code INT
					set @Email_Notification_code = 0
				
					set @Channel_Code = 0
					set @File_Code = 0
					set @Email_Notification_Msg  = ''
					DECLARE @RedirectUrl varchar(MAX)
					set @RedirectUrl = ''
					DECLARE @DefaultSiteUrl VARCHAR(500);	SET @DefaultSiteUrl = ''
					SELECT @DefaultSiteUrl =  DefaultSiteUrl FROM System_Param
				
					DECLARE @DatabaseEmail_Profile varchar(200)	
					SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

					--DECLARE @Email_Config_Code INT
					--SELECT @Email_Config_Code= Email_Config_Code FROM Email_Config (NOLOCK) WHERE [Key]='SCE'

					DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT
					

					DECLARE cur_on_Userwise_File_Data CURSOR
					KEYSET FOR
						--select distinct BVEC.Channel_Code,ENS.File_Code,ENS.Email_Notification_Msg from BVException BVE
						select distinct BVEC.Channel_Code,ENS.File_Code,ENS.Email_Notification_Msg,0 as Email_Notification_Schedule_Code from BVException BVE (NOLOCK)
						inner join BVException_Users BVEU (NOLOCK) on BVE.Bv_Exception_Code = BVEU.Bv_Exception_Code AND BVEU.Users_Code = @cur_user_code
						inner join BVException_Channel BVEC (NOLOCK) on BVEC.Bv_Exception_Code = BVEU.Bv_Exception_Code
						inner join Email_Notification_Schedule ENS (NOLOCK) on ENS.Channel_Code = BVEC.Channel_Code AND ENS.IsMailSent= 'N'	
						where ENS.Schedule_Item_Log_Date >= GETDATE();

					OPEN cur_on_Userwise_File_Data
					FETCH NEXT FROM cur_on_Userwise_File_Data INTO @Channel_Code,@File_Code,@Email_Notification_Msg,@Email_Notification_code
					WHILE (@@fetch_status <> -1)
					BEGIN
						IF (@@fetch_status <> -2)
						BEGIN
								if( 
										--(select COUNT(Email_Notification_Schedule_Code)  from Email_Notification_Schedule  
										--		where File_Code = @File_Code AND Channel_Code = @Channel_Code AND IsMailSent = 'N') 
										--> 0
										(select COUNT(File_Code) from #Update_STATUS where File_Code = @File_Code AND Channel_Code = @Channel_Code AND User_code = @cur_user_code) <= 0
								  )
								  BEGIN
										set @IS_User_Send_Mail = 'Y'
									
										--set @RedirectUrl = 'The schedule file has ‘Rights Exception’ for following channels.<br><br>For more details please login into the <b>RightsU System<b>. 
										--<br><br><a href='+ @DefaultSiteUrl +' target=''_blank''><b>'+ @DefaultSiteUrl+'</b></a>'	
										set @RedirectUrl = 'The schedule file has ‘Rights Exception’ for following channels.
										<br>For more details on licensed rights, login into the RightsU System : <a href='+ @DefaultSiteUrl +' target=''_blank''><b>RightsU</b></a>'
						
										DECLARE @Emailbody AS NVARCHAR(MAX);	SET @Emailbody = ''
										DECLARE @ScheduleFileName AS NVARCHAR(2500);	SET @ScheduleFileName = ''
										SELECT @ScheduleFileName = [File_Name] FROM Upload_Files (NOLOCK) WHERE File_code = @File_Code

										DECLARE @AiringChannelName AS NVARCHAR(2500)
										SELECT @AiringChannelName = channel_name FROM Channel (NOLOCK) WHERE channel_code in(select top 1 ChannelCode from Upload_Files WHERE File_Code = @File_Code)

									
										DECLARE @MailSubjectCr AS NVARCHAR(2500)	
										SET @MailSubjectCr = 'RightsU Email Alert : Schedule data exception '

									
										DECLARE @EMailFooter NVARCHAR(2000)
										SET @EMailFooter ='&nbsp;</br>&nbsp;</br>
										<FONT SIZE="2" COLOR="gray">This email is generated by RIGHTSU</font>'
									
									
										BEGIN
												PRINT '--===============3.5 Other Deal Rights Violation Email --==============='					
												

												DECLARE @RowTitleCodeOld VARCHAR(MAX),@RowTitleCodeNew VARCHAR(MAX),@WhereCondition VARCHAR (2)
													SET @RowTitleCodeOld = ''
													SET @RowTitleCodeNew = ''

												DECLARE @Temp_tbl_count INT = 0, @Index INT = 0, @Record_Found CHAR(1)-- @To_Users_Code NVARCHAR(MAX) = ''
													SELECT @Temp_tbl_count = 0, @Emailbody = '', @Index = 0, @Record_Found = 'N', @RowTitleCodeOld = ''

												DECLARE @To_Users_Code NVARCHAR(MAX) = '', @To_User_Mail_Id  NVARCHAR(MAX) = '', @CC_Users_Code  NVARCHAR(MAX) = '', @CC_User_Mail_Id  NVARCHAR(MAX) = '',
														@BCC_Users_Code  NVARCHAR(MAX) = '', @BCC_User_Mail_Id  NVARCHAR(MAX) = '', @Channel_Codes  NVARCHAR(MAX) = ''

														
												SET @Emailbody = @Notification_Body
												
												DECLARE @MainRowBody VARCHAR(MAX) = '', @ReplaceRowBody VARCHAR(MAX) = '', @PerRowBody VARCHAR(MAX) = '', @StartIndex INT = 0, @EndIndex INT = 0
												SELECT @StartIndex = CHARINDEX('<!--ROWSETSTART-->', @Emailbody), @EndIndex = CHARINDEX('<!--ROWSETEND-->', @Emailbody)
															
												SELECT @MainRowBody = SUBSTRING(@Emailbody, @StartIndex, (@EndIndex - @StartIndex) + 16)
															
												SET @Temp_tbl_count = 0

												DECLARE @Program_Title  NVARCHAR(MAX), @Program_Episode_Number  NVARCHAR(MAX), @Right_Start_Date  NVARCHAR(MAX), @Right_End_Date  NVARCHAR(MAX), @Available_Channels  NVARCHAR(MAX), @Channel_Name  NVARCHAR(MAX), @Schedule_Item_Log_Date  NVARCHAR(MAX), @Schedule_Item_Log_Time  NVARCHAR(MAX), @Allocated_Runs  NVARCHAR(MAX), @Consumed_Runs  NVARCHAR(MAX), @Deal_Desc NVARCHAR(MAX)

												DECLARE curP CURSOR FOR

													SELECT CAST(ISNULL(e.Email_Notification_Msg, ' ') AS NVARCHAR(1000)) AS Email_Notification_Msg
													      ,CAST  (ISNULL(e.Program_Title,' ')  AS NVARCHAR(250)) AS Program_Title
														  , CAST  (ISNULL(e.Program_Episode_Number,' ')  AS NVARCHAR(250)) AS Program_Episode_Number
														  , ISNULL(CAST(case WHEN ( CAST( case WHEN isnull(e.Right_Start_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' THEN '' 
																							   WHEN isnull(e.Right_Start_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' THEN '' ELSE e.Right_Start_Date END AS VARCHAR(250))) = '1900-01-01 00:00:00.000' THEN 'NA'
																							   WHEN ( CAST( case WHEN isnull(e.Right_Start_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' THEN '' 
																							   WHEN isnull(e.Right_Start_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' THEN '' ELSE e.Right_Start_Date END AS VARCHAR(250))) = 'Jan 1 1900 12:00AM' THEN 'NA' ELSE  convert(varchar, e.Right_Start_Date, 106) END  AS VARCHAR(250)),'NA') AS Right_Start_Date
														  ,ISNULL(CAST  (case WHEN ( CAST( case WHEN isnull(e.Right_End_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' THEN '' 
																							   WHEN isnull(e.Right_End_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' THEN '' ELSE e.Right_End_Date END AS VARCHAR(250))) ='1900-01-01 00:00:00.000' THEN 'NA'
																							   WHEN ( CAST( case WHEN isnull(e.Right_End_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' THEN '' WHEN isnull(e.Right_End_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' THEN '' ELSE e.Right_End_Date END AS VARCHAR(250))) ='Jan 1 1900 12:00AM' THEN 'NA' ELSE  convert(varchar, e.Right_End_Date, 106) END  AS VARCHAR(250)),'NA') AS Right_End_Date
														  ,CAST  (ISNULL(e.Available_Channels, ' ') AS NVARCHAR(250)) AS Available_Channels
														  ,CAST  (ISNULL(e.Channel_Name, ' ') AS NVARCHAR(250)) AS Channel_Name
														  ,ISNULL(convert(varchar, cast(e.Schedule_Item_Log_Date as datetime), 106) ,'') AS Schedule_Item_Log_Date
														  ,CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) AS Schedule_Item_Log_Time
														  ,CAST  (CASE WHEN ISNULL(e.Allocated_Runs, -1) = -1 THEN '0' ELSE CAST(e.Allocated_Runs AS VARCHAR(50)) END AS VARCHAR(250)) AS Allocated_Runs
														  ,CAST  (ISNULL(e.Consumed_Runs, '0') AS VARCHAR(250)) AS Consumed_Runs
														  ,CAST  (AD.Deal_Desc AS VARCHAR(250)) AS Deal_Desc
													FROM Email_Notification_Schedule e (NOLOCK)
													LEFT JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADM.Acq_Deal_Movie_Code = e.Deal_Movie_Code INNER JOIN Acq_Deal AD ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
													WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'

												OPEN curP 
												FETCH NEXT FROM curP INTO @Email_Notification_Msg, @Program_Title, @Program_Episode_Number, @Right_Start_Date, @Right_End_Date, @Available_Channels, @Channel_Name, @Schedule_Item_Log_Date, @Schedule_Item_Log_Time, @Allocated_Runs, @Consumed_Runs, @Deal_Desc
													WHILE @@FETCH_STATUS = 0 
													BEGIN
														SET @Index  = @Index  + 1
														
														SELECT @PerRowBody = ''
														--SET @RowTitleCodeNew=@Email_Notification_Msg+'|'+ @Program_Title +'|'+ ISNULL(@Program_Episode_Number, '') +'|'+ ISNULL(@Right_Start_Date, '') +'|'+ @Right_End_Date +'|'+@Available_Channels+'|'+@Channel_Name+'|'+@Schedule_Item_Log_Date+'|'+@Schedule_Item_Log_Time+'|'+@Allocated_Runs+'|'+@Consumed_Runs+'|'+@Deal_Desc
													    
														--IF((@RowTitleCodeOld <> @RowTitleCodeNew))
														--BEGIN
															SET @Temp_tbl_count = @Temp_tbl_count+1
															SELECT @PerRowBody = @MainRowBody

															SELECT @PerRowBody

															SELECT @PerRowBody = REPLACE(@PerRowBody, '{Exception}', CAST(ISNULL(@Email_Notification_Msg, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{Title_Name}', CAST(ISNULL(@Program_Title, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{EpisodeNumber}', CAST(ISNULL(@Program_Episode_Number, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{RightStartDate}', CAST(ISNULL(CONVERT(VARCHAR(11),ISNULL(@Right_Start_Date,''), 106), ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{RightEndDate}', CAST(ISNULL(CONVERT(VARCHAR(11),ISNULL(@Right_End_Date,''), 106), ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{AvailableChannels}', CAST(ISNULL(@Available_Channels, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{AiringChannel}', CAST(ISNULL(@Channel_Name, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{DateofSchedule}', CAST(ISNULL(@Schedule_Item_Log_Date, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{TimeofSchedule}', CAST(ISNULL(@Schedule_Item_Log_Time, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{AllocatedRuns}', CAST(ISNULL(@Allocated_Runs, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{ConsumedRuns}', CAST(ISNULL(@Consumed_Runs, ' ') AS NVARCHAR(1000)))
															SELECT @PerRowBody = REPLACE(@PerRowBody, '{Deal_Description}', CAST(ISNULL(@Deal_Desc, ' ') AS NVARCHAR(1000)))
															
															SELECT @ReplaceRowBody = @ReplaceRowBody + @PerRowBody

															SET @RowTitleCodeOld = @RowTitleCodeNew
															
														--END

														FETCH NEXT FROM curP INTO @Email_Notification_Msg, @Program_Title, @Program_Episode_Number, @Right_Start_Date, @Right_End_Date, @Available_Channels, @Channel_Name, @Schedule_Item_Log_Date, @Schedule_Item_Log_Time, @Allocated_Runs, @Consumed_Runs, @Deal_Desc
													END
												CLOSE curP
												DEALLOCATE curP

												IF( @Temp_tbl_count <> 0)
												BEGIN
													
													SELECT @Emailbody = REPLACE(@Emailbody, @MainRowBody, @ReplaceRowBody)
													SELECT @MailSubjectCr = @Notification_Subject
												
													INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
													SELECT @Email_Config_Code, @Emailbody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''), @MailSubjectCr
												
												END
							
												-------------------------------------------4.0A END SET_EMAIL_BODY_DELETED -------------------------------------------	
										END
										update #Users_Data set Email_body += @Emailbody where users_code = @cur_user_code
										--UPDATE Email_Notification_Schedule SET IsMailSent = 'Y' WHERE File_Code = @File_Code AND Channel_Code = @Channel_Code
										Insert into #Update_STATUS values (0,@File_Code,@Channel_Code,@cur_user_code)
								END
						END
						FETCH NEXT FROM cur_on_Userwise_File_Data INTO @Channel_Code,@File_Code,@Email_Notification_Msg,@Email_Notification_code
					END
					CLOSE cur_on_Userwise_File_Data
					DEALLOCATE cur_on_Userwise_File_Data
				
				

				
					if(@IS_User_Send_Mail = 'Y')
					BEGIN
							DECLARE @Emailbody_Username NVARCHAR(250);	SET @Emailbody_Username = ''
							--SET @Emailbody_Username = 'Dear&nbsp;' + @cur_userFullName + ' ,<br><br>' /*User name with seecurity Group*/
							SET @Emailbody_Username = 'Dear&nbsp;' + @cur_first_name + ' ,<br><br>' 

							DECLARE @Emailbody1 AS NVARCHAR(MAX);	SET @Emailbody1 = ''
							select  @Emailbody1=Email_body from #Users_Data where users_code = @cur_user_code
						
							--SET @Emailbody1 =@Emailbody_Username +  @Emailbody1 +  @RedirectUrl + @EMailFooter
							SET @Emailbody1 =@Emailbody_Username +  @RedirectUrl + @Emailbody1  + @EMailFooter
						
							--SET @Emailbody1 =@Emailbody_Username   +  @RedirectUrl + @EMailFooter
							--update #Users_Data set Email_body = @Emailbody1 where  users_code = @cur_user_code
						
							--select  @Emailbody1=Email_body from #Users_Data where users_code = @cur_user_code
						
							--EXEC msdb.dbo.sp_send_dbmail 
							--@profile_name = @DatabaseEmail_Profile,
							--@recipients =  @cur_email_id,
							--@subject = @MailSubjectCr,
							--@body = @Emailbody1, 
							--@body_format = 'HTML';

							SET @Emailbody1 = REPLACE(@Emailbody1, '{User_Name}', CAST(ISNULL(@cur_first_name, ' ') AS NVARCHAR(1000)))
							SET @Emailbody1 = REPLACE(@Emailbody1, '{DefaultSiteUrl}', CAST(ISNULL(@DefaultSiteUrl, ' ') AS NVARCHAR(1000)))
							SET @Emailbody1 = REPLACE(@Emailbody1, '{AiringChannelName}', CAST(ISNULL(@AiringChannelName, ' ') AS NVARCHAR(1000)))
							--SET @Emailbody1 = REPLACE(@Emailbody1, '{RedirectUrl}', CAST(ISNULL(@RedirectUrl, ' ') AS NVARCHAR(1000)))
							--SET @Emailbody1 = REPLACE(@Emailbody1, '{EMailFooter}', CAST(ISNULL(@EMailFooter, ' ') AS NVARCHAR(1000)))
							
							INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_User_Mail_Id, [Subject])
							SELECT @Email_Config_Code, @Emailbody1, ISNULL(@cur_email_id ,''), @MailSubjectCr
						
							--insert into Email_Check values (@DatabaseEmail_Profile, @cur_email_id,@MailSubjectCr,@Emailbody1,'HTML' )
							PRINT 'Email sent to ' + @cur_email_id
					END
					set @IS_User_Send_Mail = 'N'
			END
		FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,
		@cur_email_id, @cur_security_group_name, @cur_userFullName
		END
		CLOSE cur_on_Users_Data
		DEALLOCATE cur_on_Users_Data
		
		--UPDATE Email_Notification_Schedule SET IsMailSent = 'Y' WHERE File_Code = @File_Code				
		--UPDATE Temp_BV_Schedule_DeletedRecords SET IsMailSent = 'Y' WHERE File_Code = @File_Code				
	
	
		DECLARE @Email_Notification_Schedule_code_cur INT,@File_code_Cur INT,@Channel_Code_Cur INT
		set @Email_Notification_Schedule_code_cur = 0
		set  @File_code_Cur = 0
		set @Channel_Code_Cur = 0
	
	
		DECLARE cur_on_Update_Data CURSOR
		KEYSET
			FOR 
				SELECT distinct Email_Notification_Schedule_code ,File_Code ,Channel_Code  FROM #Update_STATUS
		OPEN cur_on_Update_Data
		FETCH NEXT FROM cur_on_Update_Data INTO @Email_Notification_Schedule_code_cur,@File_code_Cur,@Channel_Code_Cur
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
				update Email_Notification_Schedule set IsMailSent = 'Y' where File_Code=@File_code_Cur AND Channel_Code = @Channel_Code_Cur --AND Email_Notification_Schedule_Code = @Email_Notification_Schedule_code_cur
			END
		FETCH NEXT FROM cur_on_Update_Data INTO @Email_Notification_Schedule_code_cur,@File_code_Cur,@Channel_Code_Cur
		END
		CLOSE cur_on_Update_Data
		DEALLOCATE cur_on_Update_Data	

		EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT
		DELETE FROM @Email_Config_Users_UDT
	
	END		


			IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL
		BEGIN
			DROP TABLE #Users_Data
		END	
				
			IF OBJECT_ID('tempdb..#Update_STATUS') IS NOT NULL
		BEGIN
			DROP TABLE #Update_STATUS
		END	

			IF OBJECT_ID('tempdb..#Update_STATUS') IS NOT NULL DROP TABLE #Update_STATUS
			IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL DROP TABLE #Users_Data
			IF OBJECT_ID('tempdb..#Users_Email_Data') IS NOT NULL DROP TABLE #Users_Email_Data

	FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type
	END
	CLOSE curNotificationPlatforms
	DEALLOCATE curNotificationPlatforms
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Neo_Notification]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END