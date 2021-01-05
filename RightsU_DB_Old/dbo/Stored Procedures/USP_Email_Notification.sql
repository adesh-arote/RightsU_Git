ALTER PROC USP_Email_Notification
-- =============================================
-- Author:		Anchal Sikarwar
-- Create date: 13 June 2017
-- Description:	
-- =============================================
AS
BEGIN
	DECLARE @Key char(4), @Email_Config_Code INT, @Notification_TimeInVar VARCHAR(20), @Current_TimeInVar VARCHAR(20),
	@LastExe_TimeInVar VARCHAR(20), @IsNotification_Frequency CHAR(1)
	
	DECLARE @Notification_Day INT, @Notification_Frequency CHAR(1), @Notification_Time TIME
	
	DECLARE CUS_EN CURSOR FOR 
		SELECT EC.[Key], EC.Email_Config_Code, ECD.Notification_Days, ECD.Notification_Frequency, ECD.Notification_Time,
		EC.Notification_Frequency
		FROM 
		Email_Config EC 
		INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code 
		WHERE Is_Include_Job = 'Y' 
	OPEN CUS_EN
	FETCH NEXT FROM CUS_EN INTO @Key, @Email_Config_Code, @Notification_Day, @Notification_Frequency, @Notification_Time, @IsNotification_Frequency
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
	--select  @Key, @Email_Config_Code, @Notification_Day, @Notification_Frequency, @Notification_Time, @IsNotification_Frequency
		DECLARE @Created_Time DATETIME
		DECLARE @Last_Day DATETIME = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))
		--Last Email Procedure executed time
		SELECT TOP 1 @Created_Time = Created_Time FROM Email_Notification_Log where Email_Config_Code = @Email_Config_Code order by 1 desc

		SELECT @Notification_TimeInVar = cast(DATEPART(hour, @Notification_Time) as varchar) + ':' + cast(DATEPART(minute, @Notification_Time) as varchar)

		SELECT @Current_TimeInVar = cast(DATEPART(hour, GETDATE()) as varchar) + ':' + cast(DATEPART(minute, GETDATE()) as varchar)

		SELECT @LastExe_TimeInVar = CAST(DATEPART(hour, Created_Time) as varchar) + ':' + CAST(DATEPART(minute, Created_Time) as varchar)
		FROM Email_Notification_Log where Email_Config_Code = @Email_Config_Code
		
		IF(@Notification_Frequency='')
			SET @Notification_Frequency = 'N'
		IF(@IsNotification_Frequency='')
			SET @IsNotification_Frequency = 'N'

			PRINT '@Key = '+@Key+', @Notification_Frequency = '+@Notification_Frequency +', @Notification_Day = '+CAST(@Notification_Day AS VARCHAR)+', @Current_TimeInVar = '+@Current_TimeInVar
			+', @Notification_TimeInVar = '+ @Notification_TimeInVar+ ', @Last_Day = ' + CAST(@Last_Day AS VARCHAR) + ', @LastExe_TimeInVar = '
			+@LastExe_TimeInVar 
		--print @Key + ' a'
		IF(((@Notification_Frequency = 'M' AND DATEPART(d, GETDATE()) = @Notification_Day AND @Current_TimeInVar = @Notification_TimeInVar) 
			OR (@Notification_Frequency ='M' AND DateDIFF(d,GETDATE(),@Last_Day) = 0 AND @Notification_Day > DATEPART(d,@Last_Day) 
				AND @Current_TimeInVar = @Notification_TimeInVar)
			OR (@Notification_Frequency ='D' AND @Current_TimeInVar = @Notification_TimeInVar)
			OR (@Notification_Frequency ='H' AND @LastExe_TimeInVar != @Current_TimeInVar)) OR @IsNotification_Frequency = 'N' 
			OR ISNULL(@Notification_Frequency,'N') = 'N')
		BEGIN
			--print @Key + ' b'
			IF(@Key='CUR')--Channel Unutilized Run
			BEGIN
				EXEC USP_Get_Unutilized_Run 
				PRINT 'EXEC USP_Get_Unutilized_Run '
			END
			ELSE IF(@Key = 'SCE')
			BEGIN
				EXEC USP_Schedule_SendException_Userwise_Email
				PRINT 'EXEC USP_Schedule_SendException_Userwise_Email'
			END
			ELSE 
			IF(@Key = 'NDA')
			BEGIN
				EXEC USP_Deal_Approval_Email
				PRINT 'EXEC USP_Deal_Approval_Email'
			END
			ELSE 
			IF(@Key = 'SRV')
			BEGIN
			PRINT 'SRV'
				EXEC USP_Syn_Deal_Rights_Error_Details_Mail
				PRINT 'EXEC USP_Syn_Deal_Rights_Error_Details_Mail'
			END
			ELSE IF(@Key = 'ACE' OR @Key = 'SYE' OR @Key = 'AROD' OR @Key = 'SROD' OR @Key = 'TER')
			BEGIN
			
				EXEC USP_Deal_Expiry_Email 'D',@Key
				PRINT 'EXEC USP_Deal_Expiry_Email '+@Key
			END
			
			ELSE IF(@Key='ARE')
			BEGIN
				EXEC USP_Workflow_Reminder_Mail
			END
		END
		FETCH NEXT FROM CUS_EN INTO @Key, @Email_Config_Code, @Notification_Day, @Notification_Frequency, @Notification_Time, @IsNotification_Frequency
	END
	CLOSE CUS_EN
	DEALLOCATE CUS_EN
END

--EXEC USP_Deal_Expiry_Email 'D','ACE'
--EXEC USP_Deal_Expiry_Email 'D','SYE'
--EXEC USP_Deal_Expiry_Email 'D','AROD'
--EXEC USP_Deal_Expiry_Email 'D','SROD'
--EXEC USP_Deal_Expiry_Email 'D','TER'
