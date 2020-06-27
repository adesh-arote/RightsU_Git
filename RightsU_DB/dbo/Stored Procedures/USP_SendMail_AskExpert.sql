--[USP_SendMail_AskExpert] 143,'This is test','This is test','ashutosh@uto.in',''
CREATE PROCEDURE [dbo].[USP_SendMail_AskExpert]  
(  
	 @User_Code INT,  
	 @Subject VARCHAR(200),  
	 @Query VARCHAR(500),   
	 @FromMailId VARCHAR(500),  
	 @ToMailId VARCHAR(500)  
)  
AS  
 --=============================================  
 --Author:  NAVIN SAPALYA  
 --Create DATE: 24 MAY 2016  
 --Description: Send Query to RightsU_Support  
 --=============================================  
BEGIN  
	SET FMTONLY OFF   
	DECLARE @Result VARCHAR(1000)= 'Y'  
	BEGIN TRY    
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
		BEGIN
			DROP TABLE #Temp
		END
		DECLARE @User_Name VARCHAR(100),@Glossary_Code INT  
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = 'AAE'
		INSERT INTO Glossary_AskExpert(User_Code,Subject,Question,Inserted_On)  
		SELECT @User_Code,@Subject,@Query,GETDATE()  
		SELECT @Glossary_Code = SCOPE_IDENTITY()  
		SELECT @User_Name = U.First_Name  FROM Users U WHERE U.Users_Code = @User_Code  
  
  
		DECLARE @body  VARCHAR(MAX)   
		DECLARE @body_RightsUTeam VARCHAR(MAX)
		SET @body  = ''  
		SET @body_RightsUTeam = ''  
		SELECT TOP 1 @body = Template_Desc FROM Email_template WHERE Template_For = 'AEX'  
		SELECT TOP 1 @body_RightsUTeam = Template_Desc FROM Email_template WHERE Template_For = 'AEX_RightsTeam'  

  
		------------Send E-Mail----------  
		DECLARE @DatabaseEmail_Profile VARCHAR(200)   
		SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'  
		--SELECT DISTINCT User_Mail_Id from [dbo].[UFN_Get_Bu_Wise_User]('AAE')
		SELECT  DISTINCT User_Mail_Id, Users_Code 
		INTO #Temp 
		from [dbo].[UFN_Get_Bu_Wise_User]('AAE') WHERE BuCode IN(select Business_Unit_Code from Users_Business_Unit 
		where Users_Code = @User_Code)

		SET @ToMailId = STUFF((SELECT DISTINCT ';' + CAST(User_Mail_Id AS VARCHAR(MAX)) 
				FROM #Temp FOR XML PATH('') ), 1, 1, '')

		--SELECT TOP 1 @ToMailId = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'ToEmail_AskExpert' 
		  
		DECLARE @MailSubjectCr VARCHAR(250) = @Subject --'RightsU Glossary - Query'   
		DECLARE @U_Mail_Id NVARCHAR(1000), @U_Code INT
		SET @body  = REPLACE(@body ,'{User_Name}',@User_Name)    
		SET @body_RightsUTeam = REPLACE(@body_RightsUTeam,'{body}',@Query)
		SET @body_RightsUTeam = REPLACE(@body_RightsUTeam,'{User_Name}',@User_Name)
  
			EXEC msdb.dbo.sp_send_dbmail   
			@profile_name = @DatabaseEmail_Profile,  
			@reply_To = @FromMailId,
			@recipients =  @ToMailId,
			@subject = @MailSubjectCr,  
			@body = @body_RightsUTeam,   
			@body_format = 'HTML';    

			UPDATE Glossary_AskExpert  
			SET Is_Mail_Sent = 'Y'  
			WHERE Glossary_AskExpert_Code = @Glossary_Code

			EXEC msdb.dbo.sp_send_dbmail   
			@profile_name = @DatabaseEmail_Profile,  
			@recipients =  @FromMailId,  
			@reply_To = @ToMailId,
			@subject = @MailSubjectCr,  
			@body = @body,   
			@body_format = 'HTML'; 

			INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @body, @User_Code, 'Ask An Expert', @FromMailId

		DECLARE cur_SendMail CURSOR FOR
		select * from #Temp
		OPEN cur_SendMail  
		FETCH NEXT FROM cur_SendMail INTO @U_Mail_Id, @U_Code 
		WHILE (@@fetch_status <> -1)  
		BEGIN  
			
			--------Send E-Mail END   
			INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @body_RightsUTeam, @U_Code, 'Ask An Expert', @U_Mail_Id
			--from #Temp
		   
			--INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
			--SELECT @Email_Config_Code, GETDATE(), 'N', @body, Users_Code, 'Ask An Expert', User_Mail_Id
			--from #Temp
			FETCH NEXT FROM cur_SendMail INTO @U_Mail_Id, @U_Code 
		END
		CLOSE cur_SendMail
		DEALLOCATE cur_SendMail
	END TRY  
	BEGIN CATCH          
		DECLARE @ErrorMessage VARCHAR(4000),@Error_Line NVARCHAR(4000)    
		SELECT @ErrorMessage  = ERROR_MESSAGE() ,@Error_Line = ERROR_LINE()     
		--SET  @Result =  @Err orMessage + ' ' + @Error_Line + '~' + IsNull(@Is_Error, '')   
		--PRINT @ErrorMessage
		SET  @Result =  'N' 
  
		UPDATE Glossary_AskExpert  
		SET Is_Mail_Sent = 'N'  
		WHERE Glossary_AskExpert_Code = @Glossary_Code  

		SET @body = '<p>Some error occured.</p>' + @ErrorMessage

		EXEC msdb.dbo.sp_send_dbmail   
		@profile_name = @DatabaseEmail_Profile,  
		@recipients =  @ToMailId,  
		@subject = @MailSubjectCr,
		@body = @body,
		@body_format = 'HTML';    
	END CATCH   
	SELECT  @Result AS Result  
END