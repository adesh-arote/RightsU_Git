
CREATE PROCEDURE [dbo].[usp_Schedule_SendException_Userwise_Email] 
AS
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
	from BVException bve
	INNER JOIN BVException_Channel bve_c on bve_c.bv_exception_code = bve.bv_exception_code --and bve_c.channel_code = @Channel_Code
	INNER JOIN BVException_Users bve_u on bve_u.bv_exception_code = bve.bv_exception_code
	INNER JOIN Users U on U.users_code = bve_u.users_code
	INNER JOIN Security_Group SG ON SG.security_group_code = U.security_group_code
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

					
					

				DECLARE cur_on_Userwise_File_Data CURSOR
				KEYSET FOR
					--select distinct BVEC.Channel_Code,ENS.File_Code,ENS.Email_Notification_Msg from BVException BVE
					select distinct BVEC.Channel_Code,ENS.File_Code,ENS.Email_Notification_Msg,0 as Email_Notification_Schedule_Code from BVException BVE
					inner join BVException_Users BVEU on BVE.Bv_Exception_Code = BVEU.Bv_Exception_Code AND BVEU.Users_Code = @cur_user_code
					inner join BVException_Channel BVEC on BVEC.Bv_Exception_Code = BVEU.Bv_Exception_Code
					inner join Email_Notification_Schedule ENS on ENS.Channel_Code = BVEC.Channel_Code AND ENS.IsMailSent= 'N'	
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
									SELECT @ScheduleFileName = [File_Name] FROM Upload_Files WHERE File_code = @File_Code

									DECLARE @AiringChannelName AS NVARCHAR(2500)
									SELECT @AiringChannelName = channel_name FROM Channel WHERE channel_code in(select top 1 ChannelCode from Upload_Files WHERE File_Code = @File_Code)

									
									DECLARE @MailSubjectCr AS NVARCHAR(2500)	
									SET @MailSubjectCr = 'RightsU Email Alert : Schedule data exception '

									
									DECLARE @EMailFooter NVARCHAR(2000)
									SET @EMailFooter ='&nbsp;</br>&nbsp;</br>
									<FONT SIZE="2" COLOR="gray">This email is generated by RIGHTSU</font>'
									
									
									BEGIN
											PRINT '--===============3.5 Other Deal Rights Violation Email --==============='
						
											--Email Heading mentioned here.	
											--SET @Emailbody= 'The schedule file <b> ( ' + @ScheduleFileName + ' )</b> has exception for '+ @AiringChannelName+' channel. 
											--<br>Exception details are given below.
											--SET @Emailbody= '<table border="1" cellspacing="0" cellpadding="3">'				
											
											SET @Emailbody= '<br><br>'+@AiringChannelName+'<br><br><table border="1" cellspacing="0" cellpadding="3">'				
											
											
											--Table Heading mentioned below
											/*<td style="color: #ffffff; background-color: #F50606"><b>Consumed<b></td>
											<td>'+ CAST  (ISNULL(e.Count_Of_Schedule, ' ') AS VARCHAR(250)) +'</td>*/
											


											SET @Emailbody=@Emailbody + '<tr>
											<td style="color: #ffffff; background-color: #086B10"><b>Exception<b></td>
											<td style="color: #ffffff; background-color: #086B10"><b>Title Name<b></td>
											<td style="color: #ffffff; background-color: #086B10"><b>Right Start Date<b></td>
											<td style="color: #ffffff; background-color: #086B10"><b>Right End Date<b></td>
											<td style="color: #ffffff; background-color: #086B10"><b>Available Channels<b></td>
											<td style="color: #ffffff; background-color: #F50606"><b>Airing Channel<b></td>
											<td style="color: #ffffff; background-color: #F50606"><b>Date of Schedule<b></td>
											<td style="color: #ffffff; background-color: #F50606"><b>Time of Schedule<b></td>
											<td style="color: #ffffff; background-color: #F50606"><b>Allocated Runs<b></td>
											<td style="color: #ffffff; background-color: #F50606"><b>Consumed Runs<b></td>
											<td style="color: #ffffff; background-color: #F50606"><b>Deal_Description<b></td>
											</tr>'
											
											
											
											--SELECT @Emailbody=@Emailbody +'<tr>
											--<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS VARCHAR(1000)) +'</td>
											--<td>'+ CAST  (ISNULL(e.Program_Title,' ')  AS VARCHAR(250)) +'</td>			
											--<td>'+ CAST  (ISNULL(case WHEN e.Right_Start_Date = 'Jan 1 1900 12:00AM' THEN '' ELSE e.Right_Start_Date END,' ') AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(case WHEN  e.Right_End_Date = 'Jan 1 1900 12:00AM' THEN '' ELSE e.Right_End_Date  END ,' ')  AS VARCHAR(250))  +'</td>
											--<td>'+ CAST  (ISNULL(e.Available_Channels, ' ') AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(e.Channel_Name, ' ') AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(Schedule_Item_Log_Date,' ') AS VARCHAR(250))  +'</td>
											--<td>'+ CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) +'</td>
											

											--</tr>'
											--FROM Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
											
											
											
											
											SELECT @Emailbody=@Emailbody +'<tr>
											<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS NVARCHAR(1000)) +'</td>
											<td>'+ CAST  (ISNULL(e.Program_Title,' ')  AS NVARCHAR(250)) +'</td>			
											<td>'+ ISNULL(CAST(case WHEN
																				(
																					CAST(
																						case WHEN isnull(e.Right_Start_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
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
																						case WHEN isnull(e.Right_Start_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
																							THEN '' 
																						WHEN isnull(e.Right_Start_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' 
																							THEN ''
																						ELSE e.Right_Start_Date END AS VARCHAR(250)
																						)
																				)
																				='Jan 1 1900 12:00AM'
																				THEN 'NA'
																			ELSE  convert(varchar, e.Right_Start_Date, 106)
																			END  AS VARCHAR(250)),'NA')
																			+'</td>
											<td>'+ ISNULL(CAST  (case WHEN
																				(
																					CAST(
																						case WHEN isnull(e.Right_End_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
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
																						case WHEN isnull(e.Right_End_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000' 
																							THEN '' 
																						WHEN isnull(e.Right_End_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM' 
																							THEN ''
																						ELSE e.Right_End_Date END AS VARCHAR(250)
																						)
																				)
																				='Jan 1 1900 12:00AM'
																				THEN 'NA'
																			ELSE  convert(varchar, e.Right_End_Date, 106)
																			END  AS VARCHAR(250)),'NA') +'</td>
											<td>'+ CAST  (ISNULL(e.Available_Channels, ' ') AS NVARCHAR(250)) +'</td>
											<td>'+ CAST  (ISNULL(e.Channel_Name, ' ') AS NVARCHAR(250)) +'</td>
											<td>'+ ISNULL(convert(varchar, cast(e.Schedule_Item_Log_Date as datetime), 106) ,'') +'</td>
											<td>'+ CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) +'</td>
											<td>'+ CAST  (CASE WHEN ISNULL(e.Allocated_Runs, -1) = -1 THEN '0' 
											--WHEN ISNULL(e.Allocated_Runs, -1) = 0 THEN 'UNLIMTED' 
											ELSE CAST(e.Allocated_Runs AS VARCHAR(50)) END AS VARCHAR(250)) +'</td>
											<td>'+ CAST  (ISNULL(e.Consumed_Runs, '0') AS VARCHAR(250)) +'</td>
											<td>'+ CAST  (AD.Deal_Desc AS VARCHAR(250)) +'</td>
											</tr>' FROM Email_Notification_Schedule e 
											LEFT JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = e.Deal_Movie_Code INNER JOIN Acq_Deal AD ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
											WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'



											


											
											--AND ISNULL(IsRunCountCalculate,'N') = 'N'
											
											/*
												<td style="color: #ffffff; background-color: #F50606"><b>House-ID<b></td>	--Not Needed for SOny
											*/
											--Table contents are mentioned below
											--SELECT @Emailbody=@Emailbody +'<tr>
											--<td>'+ CAST  (ISNULL(e.Email_Notification_Msg, ' ') AS VARCHAR(1000)) +'</td>
											--<td>'+ CAST  (ISNULL(e.Title_Name,' ')  AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(e.Right_Start_Date,' ') AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(e.Right_End_Date,' ')  AS VARCHAR(250))  +'</td>
											--<td>'+ CAST  (ISNULL(e.Available_Channels, ' ') AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(e.Count_Of_Schedule, ' ') AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(e.Channel_Name, ' ') AS VARCHAR(250)) +'</td>
											--<td>'+ CAST  (ISNULL(Schedule_Item_Log_Date,' ') AS VARCHAR(250))  +'</td>
											--<td>'+ CAST  (ISNULL(Schedule_Item_Log_Time, ' ') AS VARCHAR(250)) +'</td>
											--</tr>
											--</table>'
											--FROM Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'
											--AND ISNULL(IsRunCountCalculate,'N') = 'Y'

											----Table contents are mentioned below
											
											set @Emailbody += '</table>'
											--set @Emailbody = 'hii'
							
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
						
						EXEC msdb.dbo.sp_send_dbmail 
						@profile_name = @DatabaseEmail_Profile,
						@recipients =  @cur_email_id,
						@subject = @MailSubjectCr,
						@body = @Emailbody1, 
						@body_format = 'HTML';  
						
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
	
	
END
	
/*	
	
--create table Email_Check 
--(
--	profile_name varchar(max),
--	recipients varchar(max),
--	subject varchar(max),
--	body varchar(max),
--	body_format varchar(max)
--)
--update Email_Notification_Schedule set IsMailSent = 'N'
EXEC [dbo].[usp_Schedule_SendException_Userwise_Email] 
select * from Email_Check
--delete from Email_Check

update Email_Notification_Schedule set IsMailSent = 'N' where 
File_Code in (865,864,863,862,861,860,859,858,857,856,855,854,853,852,851,850,849,848,847,846,845,844,843,842) 

*/



--EXEC [dbo].[usp_Schedule_SendException_Userwise_Email] 



/*
update Email_Notification_Schedule set IsMailSent = 'N' where Email_Notification_Schedule_Code in (
3601,3600,3599,3598,3597,3596
)
*/