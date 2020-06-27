CREATE PROC USP_Email_Notification
AS
BEGIN
	DECLARE @Key char(3),@Email_Config_Code INT,@Notification_TimeInVar VARCHAR(20),@Current_TimeInVar VARCHAR(20),@LastExe_TimeInVar VARCHAR(20)
	DECLARE @Notification_Day INT, @Notification_Frequency CHAR(1), @Notification_Time TIME
	DECLARE CUS_EN CURSOR FOR 
	SELECT EC.[Key], EC.Email_Config_Code, ECD.Notification_Days, ECD.Notification_Frequency, ECD.Notification_Time
	FROM Email_Config EC INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code=EC.Email_Config_Code WHERE Is_Include_Job='Y'
	OPEN CUS_EN
	FETCH NEXT FROM CUS_EN INTO @Key,@Email_Config_Code,@Notification_Day,@Notification_Frequency,@Notification_Time
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		DECLARE @Created_Time DATETIME
		DECLARE @Last_Day DATETIME=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))

		SELECT @Created_Time = Created_Time FROM Email_Notification_Log where Email_Config_Code=@Email_Config_Code
		SELECT @Notification_TimeInVar= cast(DATEPART(hour, @Notification_Time) as varchar) + ':' + cast(DATEPART(minute, @Notification_Time) as varchar)
		SELECT @Current_TimeInVar=cast(DATEPART(hour, GETDATE()) as varchar) + ':' + cast(DATEPART(minute, GETDATE()) as varchar)
		SELECT @LastExe_TimeInVar=CAST(DATEPART(hour, Created_Time) as varchar) + ':' + CAST(DATEPART(minute, Created_Time) as varchar)
		FROM Email_Notification_Log where Email_Config_Code=@Email_Config_Code

		if((@Notification_Frequency='M' AND DATEPART(d, GETDATE())=@Notification_Day AND @Current_TimeInVar=@Notification_TimeInVar) 
			OR (@Notification_Frequency='M' AND DateDIFF(d,GETDATE(),@Last_Day)=0 AND @Notification_Day>DATEPART(d,@Last_Day) AND @Current_TimeInVar=@Notification_TimeInVar)
			OR (@Notification_Frequency='D' AND @Current_TimeInVar=@Notification_TimeInVar)
			OR (@Notification_Frequency='H' AND @LastExe_TimeInVar!=@Current_TimeInVar))
		BEGIN
			IF(@Key='CUR')
			BEGIN
				exec USP_Get_Unutilized_Run 
			END
			ELSE IF(@Key='SCE')
			BEGIN
				EXEC USP_Schedule_SendException_Userwise_Email --??
			END
			ELSE IF(@Key='NDA')
			BEGIN
				EXEC USP_Deal_Approval_Email
			END
			ELSE IF(@Key='WTL')
			BEGIN
				EXEC USP_Send_Mail_WBS_Linked_Titles @WBS_Codes --??
			END
			--IF(@Key='LMR')
			--BEGIN
			--	EXEC USP_Email_Run_Utilization
			--	--@Call_From CHAR(1),
			--	--@Title_Codes VARCHAR(1000),
			--	--@BU_Code INT,
			--	--@Channel_Codes VARCHAR(1000)
			--END
			ELSE IF(@Key='ARE')
			BEGIN
				EXEC USP_Workflow_Reminder_Mail
			END
			ELSE IF(@Key='SRV')
			BEGIN
				EXEC USP_Syn_Deal_Rights_Error_Details_Mail
			END
			ELSE IF(@Key='ACE')
			BEGIN
				PRINT 'Acq Rights'
			END
			ELSE IF(@Key='SYE')
			BEGIN
				print 'Syn Rights'
			END
			ELSE IF(@Key='ROD')
			BEGIN
				print 'ROFR'
			END
			ELSE IF(@Key='TER')
			BEGIN
				print 'Tentative'
			END
			--IF(@Key='MSE')
			--BEGIN
			--	EXEC USP_Music_Schedule_Process
			--	--@TitleCode BIGINT = 12921, 
			--	--@EpisodeNo INT = 1, 
			--	--@BV_Schedule_Transaction_Code BIGINT = 0, 
			--	--@MusicScheduleTransactionCode BIGINT = 0,
			--	--@CallFrom VARCHAR(10) = 
			--END
		END
		FETCH NEXT FROM CUS_EN INTO @Key
	END
END
