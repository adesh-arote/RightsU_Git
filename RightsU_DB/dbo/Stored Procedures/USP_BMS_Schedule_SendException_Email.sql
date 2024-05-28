CREATE PROCEDURE [dbo].[USP_BMS_Schedule_SendException_Email]   
AS  
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_SendException_Email]', 'Step 1', 0, 'Started Procedure', 0, ''
	 DECLARE @cur_user_code INT, @cur_login_name NVARCHAR(500), @cur_first_name NVARCHAR(500), @cur_middle_name NVARCHAR(500), @cur_last_name NVARCHAR(500),  
	 @cur_email_id NVARCHAR(500), @cur_security_group_name NVARCHAR(500), @cur_userFullName NVARCHAR(500) , @cur_ChannelCodes NVARCHAR(500), @Email_Config_Code INT  
	 SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config (NOLOCK) where [Key] = 'SCE'  
  
	 BEGIN/*DROP TEMP TABLE*/  
	  IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL  
	  BEGIN  
	   DROP TABLE #Users_Data  
	  END   
	  IF OBJECT_ID('tempdb..#Update_STATUS') IS NOT NULL  
	  BEGIN  
	   DROP TABLE #Update_STATUS  
	  END   
	  IF OBJECT_ID('tempdb..#Email_Notification_Schedule') IS NOT NULL  
	  BEGIN  
	   DROP TABLE #Email_Notification_Schedule  
	  END   
	 END  
	 BEGIN/*CREATE OF TABLES*/  
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
	   --Email_Notification_Schedule_code INT,  
	   BMS_Schedule_Exception_Code INT,  
	   File_Code INT,  
	   Channel_Code INT,  
	   User_code INT  
	  )  
	  CREATE TABLE #Email_Notification_Schedule  
	  (  
	   BMS_Schedule_Exception_Code INT,  
	   BMS_Schedule_Process_Data_Temp_Code INT,  
	   BV_Schedule_Transaction_Code INT,  
	   Program_Episode_Title NVARCHAR(500),  
	   Program_Episode_Number VARCHAR(50),  
	   Program_Title NVARCHAR(500),  
	   Schedule_Item_Log_Date VARCHAR(50),  
	   Schedule_Item_Log_Time VARCHAR(50),  
	   Schedule_Item_Duration VARCHAR(50),  
	   File_Code BIGINT,  
	   Channel_Code INT,  
	   Email_Notification_Msg NVARCHAR (MAX),  
	   IsMailSent CHAR (1),  
	   Right_Start_Date DATETIME,  
	   Right_End_Date DATETIME,  
	   Available_Channels VARCHAR(500),  
	   Channel_Name NVARCHAR(250),  
	   Allocated_Runs INT,  
	   Consumed_Runs INT,  
	   Program_Episode_ID INT  
	  )  
	 END  
	 BEGIN/*INSERT DATA IN TEMP TABLES*/  
	  INSERT INTO #Email_Notification_Schedule(BMS_Schedule_Exception_Code, BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Schedule_Item_Log_Date,  
		Schedule_Item_Log_Time, Schedule_Item_Duration, File_Code, Channel_Code, Email_Notification_Msg, Right_Start_Date, Right_End_Date,  
		Available_Channels, Channel_Name, Allocated_Runs, Consumed_Runs, Program_Episode_ID)  
	  select BSE.BMS_Schedule_Exception_Code, BST.BV_Schedule_Transaction_Code, TC.Episode_Title, TC.Episode_No, T.Title_Name, BST.Schedule_Item_Log_Date,   
	  BST.Schedule_Item_Log_Time, BST.Schedule_Item_Duration, BST.File_Code, BST.Channel_Code, EMN.Email_Msg, CCR.Rights_Start_Date, CCR.Rights_End_Date,   
	  '', CH.Channel_Name, CCR.Defined_Runs, CCR.Schedule_Runs, BST.Program_Episode_ID  
	  From BMS_Schedule_Exception BSE   (NOLOCK)
	  INNER JOIN BV_Schedule_Transaction BST (NOLOCK) ON BST.BV_Schedule_Transaction_Code = BSE.BV_Schedule_Transaction_Code  
	  INNER JOIN Email_Notification_Msg EMN (NOLOCK) ON EMN.Email_Notification_Msg_Code = BSE.Email_Notification_Msg_Code  
	  INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Content_Channel_Run_Code = BST.Content_Channel_Run_Code  
	  INNER JOIN Channel CH (NOLOCK) ON CH.Channel_Code = BST.Channel_Code  
	  INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Content_Code = CCR.Title_Content_Code  
	  INNER JOIN Title T (NOLOCK) ON T.Title_Code = TC.Title_Code WHERE IsMailSent= 'N'  
  
	  INSERT INTO #Email_Notification_Schedule(BMS_Schedule_Exception_Code, BMS_Schedule_Process_Data_Temp_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Schedule_Item_Log_Date,  
		Schedule_Item_Log_Time, Schedule_Item_Duration, File_Code, Channel_Code, Email_Notification_Msg, Right_Start_Date, Right_End_Date,  
		Available_Channels, Channel_Name, Allocated_Runs, Consumed_Runs, Program_Episode_ID)  
	  select BSE.BMS_Schedule_Exception_Code, BST.BMS_Schedule_Process_Data_Temp_Code, TC.Episode_Title, TC.Episode_No, T.Title_Name, BST.Log_Date,   
	  BST.Date_Time, T.Duration_In_Min, BST.BMS_Schedule_Log_Code, BST.Channel_Code, EMN.Email_Msg, CCR.Rights_Start_Date, CCR.Rights_End_Date,   
	  '', CH.Channel_Name, CCR.Defined_Runs, CCR.Schedule_Runs, BST.BMS_Asset_Ref_Key  
	  From BMS_Schedule_Exception BSE   (NOLOCK)
	  INNER JOIN BMS_Schedule_Process_Data_Temp BST (NOLOCK) ON BST.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code  
	  INNER JOIN Email_Notification_Msg EMN (NOLOCK) ON EMN.Email_Notification_Msg_Code = BSE.Email_Notification_Msg_Code  
	  INNER JOIN Channel CH  (NOLOCK) ON CH.Channel_Code = BST.Channel_Code  
	  LEFT JOIN Content_Channel_Run CCR  (NOLOCK) ON CCR.Content_Channel_Run_Code = BST.Content_Channel_Run_Code  
	  LEFT JOIN Title_Content TC (NOLOCK) ON TC.Title_Content_Code = CCR.Title_Content_Code  
	  LEFT JOIN Title T (NOLOCK) ON T.Title_Code = TC.Title_Code WHERE IsMailSent= 'N'  
    
	  UPDATE T SET T.Program_Title = BHD.BV_Title, T.Program_Episode_Title = BHD.BV_Title  
	  From #Email_Notification_Schedule T  
	  INNER JOIN BV_HouseId_Data BHD ON BHD.Program_Episode_ID = T.Program_Episode_ID  
	  WHERE T.Program_Title IS NULL  
  
	  UPDATE T SET Available_Channels =  
	  (STUFF((SELECT DISTINCT  ',' + C.Channel_Name from Title_Content TC  
	  INNER JOIN Content_Channel_Run CCR ON TC.Title_Content_Code = CCR.Title_Content_Code  
	  INNER JOIN Channel C ON C.Channel_Code = CCR.Channel_Code  
	  WHERE  TC.Ref_BMS_Content_Code = T.Program_Episode_ID AND ISNULL(CCR.Is_Archive, 'N') = 'N'  
	  FOR XML PATH('')), 1, 1, '')  
	  ) FROM #Email_Notification_Schedule T   
	  WHERE T.Email_Notification_Msg = 'Invalid Channel'  
  
	  INSERT INTO #Users_Data(users_code,login_name,first_name,middle_Name,last_name,email_id,security_group_name,UserFullName,Email_body,ChannelCodes)  
	  SELECT distinct U.users_code, U.login_name, U.first_name, U.middle_Name, U.last_name,U.email_id ,  
	  SG.security_group_name,  
	  ISNULL(U.first_name,'') + ' ' + ISNULL(U.middle_Name,'') + ' ' + ISNULL(U.last_name,'') + '   ('+ ISNULL(SG.security_group_name,'') + ')'  
	  ,'' as Email_body, buUsers.Channel_Codes   
	  from [dbo].[UFN_Get_Bu_Wise_User]('SCE') buUsers
	  INNER JOIN Users u (NOLOCK) on u.Users_Code = buUsers.Users_Code  
	  INNER JOIN Security_Group SG (NOLOCK) ON SG.security_group_code = U.security_group_code  
	  --select 143,'admin','Uto','','Admin','anchal@uto.in','','Uto'+''+'Admin'+'anchal@uto.in','','25,4'  
	 END    
	 -- select * from #Email_Notification_Schedule  
	 --select * fROm #Users_Data  
	 BEGIN/*Loop thorugh userwise data to get the distinct file(channelwise) for each users*/  
	  DECLARE @IS_User_Send_Mail varchar(1) = 'N'  
	  /*START CURSOR cur_on_Users_Data */  
	  DECLARE cur_on_Users_Data CURSOR  
	  KEYSET FOR SELECT  users_code, login_name, first_name, middle_Name, last_name, email_id, security_group_name, UserFullName, ChannelCodes FROM #Users_Data  
	  OPEN cur_on_Users_Data  
	  FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,  
	  @cur_email_id, @cur_security_group_name, @cur_userFullName, @cur_ChannelCodes  
	  WHILE (@@fetch_status <> -1)  
	  BEGIN  
	  PRINT 'A'  
	   IF (@@fetch_status <> -2)  
	   BEGIN   
		DECLARE @Channel_Code INT = 0, @File_Code INT = 0, @Email_Notification_Msg NVARCHAR(2000) = '', @BMS_Schedule_Exception_Code INT = 0,   
		  @RedirectUrl varchar(MAX) = '', @DefaultSiteUrl VARCHAR(500) = '', @DatabaseEmail_Profile varchar(200) = ''  
  
		SELECT @DefaultSiteUrl =  DefaultSiteUrl FROM System_Param   (NOLOCK)
		SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'  
		/*START INNER CURSOR cur_on_Userwise_File_Data */  
		DECLARE cur_on_Userwise_File_Data CURSOR  
		KEYSET FOR  
		select distinct ENS.Channel_Code,ENS.File_Code,ENS.Email_Notification_Msg, BMS_Schedule_Exception_Code   
		 from #Email_Notification_Schedule ENS where Channel_Code in (select number from  dbo.fn_Split_withdelemiter(@cur_ChannelCodes,','))  
		 AND ENS.Schedule_Item_Log_Date >= GETDATE();  
		OPEN cur_on_Userwise_File_Data  
		FETCH NEXT FROM cur_on_Userwise_File_Data INTO @Channel_Code, @File_Code, @Email_Notification_Msg, @BMS_Schedule_Exception_Code  
		WHILE (@@fetch_status <> -1)  
		BEGIN  
		PRINT 'B'  
		 IF (@@fetch_status <> -2)  
		 BEGIN  
		  if((select COUNT(File_Code) from #Update_STATUS where File_Code = @File_Code AND Channel_Code = @Channel_Code AND User_code = @cur_user_code) <= 0)  
		  BEGIN  
		   set @IS_User_Send_Mail = 'Y'  
		   set @RedirectUrl = 'The schedule file has ‘Rights Exception’ for following channels.  
		   <br>For more details on licensed rights, login into the RightsU System : <a href='+ @DefaultSiteUrl +' target=''_blank''><b>RightsU</b></a>'  
        
		   DECLARE @Emailbody AS NVARCHAR(MAX) = '', @ScheduleFileName AS NVARCHAR(2500) = '', @AiringChannelName AS NVARCHAR(2500)  
  
		   SELECT @ScheduleFileName = [File_Name] FROM Upload_Files (NOLOCK) WHERE File_code = @File_Code  
		   SELECT @AiringChannelName = channel_name FROM Channel (NOLOCK) WHERE channel_code in(select top 1 ChannelCode from Upload_Files (NOLOCK) WHERE File_Code = @File_Code)  
   
		   DECLARE @MailSubjectCr AS NVARCHAR(2500) = 'RightsU Email Alert : Schedule data exception ',   
		   @EMailFooter NVARCHAR(2000) ='&nbsp;</br>&nbsp;</br>  
		   <FONT SIZE="2" COLOR="gray">This email is generated by RIGHTSU</font>'  
  
		   BEGIN  
			PRINT '--===============3.5 Other Deal Rights Violation Email --==============='  
  
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
			<td>'+ ISNULL(CAST(case WHEN  
			  (  
			   CAST(  
				case WHEN isnull(e.Right_Start_Date,'1900-01-01 00:00:00.000') = '1900-01-01 00:00:00.000'   
				 THEN ''   
				WHEN isnull(e.Right_Start_Date,'Jan 1 1900 12:00AM') = 'Jan 1 1900 12:00AM'   
				 THEN ''  
				ELSE e.Right_Start_Date END AS VARCHAR(250)  
				)  
			  ) ='1900-01-01 00:00:00.000'  
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
			  END  AS VARCHAR(250)),'NA') +'</td>  
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
			<td>'+ CAST  (CASE WHEN ISNULL(e.Allocated_Runs, -1) = -1 THEN '0' WHEN ISNULL(e.Allocated_Runs, -1) = 0 THEN 'UNLIMTED' ELSE CAST(e.Allocated_Runs AS VARCHAR(50)) END AS VARCHAR(250)) +'</td>  
			<td>'+ CAST  (ISNULL(e.Consumed_Runs, '0') AS VARCHAR(250)) +'</td>   
			</tr>' FROM #Email_Notification_Schedule e WHERE e.File_Code = @File_Code AND ISNULL(IsMailSent,'N') = 'N'  
          
			set @Emailbody += '</table>'  
         
			  -------------------------------------------4.0A END SET_EMAIL_BODY_DELETED -------------------------------------------   
		   END  
		   update #Users_Data set Email_body += @Emailbody where users_code = @cur_user_code  
  
		   Insert into #Update_STATUS values (@BMS_Schedule_Exception_Code, @File_Code, @Channel_Code, @cur_user_code)  
		  END  
		 END  
		 FETCH NEXT FROM cur_on_Userwise_File_Data INTO @Channel_Code,@File_Code,@Email_Notification_Msg,@BMS_Schedule_Exception_Code  
		END  
		CLOSE cur_on_Userwise_File_Data  
		DEALLOCATE cur_on_Userwise_File_Data  
       
		if(@IS_User_Send_Mail = 'Y')  
		BEGIN  
		 DECLARE @Emailbody_Username NVARCHAR(250) = 'Dear&nbsp;' + @cur_first_name + ' ,<br><br>',  
		 @EmailTable AS NVARCHAR(MAX), @Emailbody1 AS NVARCHAR(MAX) = ''  
  
		 select  @Emailbody1=Email_body from #Users_Data where users_code = @cur_user_code  
		 SEt @EmailTable = @Emailbody1  
		 SET @Emailbody1 =@Emailbody_Username +  @RedirectUrl + @Emailbody1  + @EMailFooter  
  
		 EXEC msdb.dbo.sp_send_dbmail   
		 @profile_name = @DatabaseEmail_Profile,  
		 @recipients =  @cur_email_id,  
		 @subject = @MailSubjectCr,  
		 @body = @Emailbody1,   
		 @body_format = 'HTML';    
		  --select  @DatabaseEmail_Profile,  
		  --    @cur_email_id,  
		  --   @MailSubjectCr,  
		  --  @Emailbody1,   
		  --    'HTML'   
  
  
  
		 --insert into Email_Check values (@DatabaseEmail_Profile, @cur_email_id,@MailSubjectCr,@Emailbody1,'HTML' )  
		 PRINT 'Email sent to ' + @cur_email_id  
  
		 INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)  
		 SELECT @Email_Config_Code, GETDATE(),'N', @EmailTable, @cur_user_code, 'Schedule Exception', @cur_email_id  
		END  
		set @IS_User_Send_Mail = 'N'     
	  END  
	  FETCH NEXT FROM cur_on_Users_Data INTO @cur_user_code, @cur_login_name, @cur_first_name, @cur_middle_name, @cur_last_name,  
	  @cur_email_id, @cur_security_group_name, @cur_userFullName, @cur_ChannelCodes  
	  END  
	  CLOSE cur_on_Users_Data  
	  DEALLOCATE cur_on_Users_Data  
     
	  DECLARE @BMS_Schedule_Exception_Code_cur INT = 0, @File_code_Cur INT = 0, @Channel_Code_Cur INT = 0  
   
	  DECLARE cur_on_Update_Data CURSOR  
	  KEYSET FOR SELECT distinct BMS_Schedule_Exception_Code ,File_Code ,Channel_Code  FROM #Update_STATUS  
	  OPEN cur_on_Update_Data  
	  FETCH NEXT FROM cur_on_Update_Data INTO @BMS_Schedule_Exception_Code_cur,@File_code_Cur,@Channel_Code_Cur  
	  WHILE (@@fetch_status <> -1)  
	  BEGIN  
	   IF (@@fetch_status <> -2)  
	   BEGIN  
		UPDATE BMS_Schedule_Exception SET IsMailSent = 'Y' WHERE BMS_Schedule_Exception_Code = @BMS_Schedule_Exception_Code_cur  
		--update Email_Notification_Schedule set IsMailSent = 'Y' where File_Code=@File_code_Cur AND Channel_Code = @Channel_Code_Cur --AND BMS_Schedule_Exception_Code = @BMS_Schedule_Exception_Code_cur  
	   END  
	  FETCH NEXT FROM cur_on_Update_Data INTO @BMS_Schedule_Exception_Code_cur,@File_code_Cur,@Channel_Code_Cur  
	  END  
	  CLOSE cur_on_Update_Data  
	  DEALLOCATE cur_on_Update_Data   
	 END    
  
	 BEGIN/*DROP TEMP TABLE*/  
	  IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL  
	  BEGIN  
	   DROP TABLE #Users_Data  
	  END   
	  IF OBJECT_ID('tempdb..#Update_STATUS') IS NOT NULL  
	  BEGIN  
	   DROP TABLE #Update_STATUS  
	  END   
	  IF OBJECT_ID('tempdb..#Email_Notification_Schedule') IS NOT NULL  
	  BEGIN  
	   DROP TABLE #Email_Notification_Schedule  
	  END   
	 END  

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_SendException_Email]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
