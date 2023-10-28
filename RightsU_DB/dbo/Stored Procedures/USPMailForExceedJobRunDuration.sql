CREATE PROCEDURE [dbo].[USPMailForExceedJobRunDuration]
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMailForExceedJobRunDuration]', 'Step 1', 0, 'Started Procedure', 0, ''
	----------------------------------------------------
	--Author: Aditya bandivadekar
	--Description: Exceeds job run duration (more than 10 min) would trigger 
	--Date Created: 24-JUN-2018
	-----------------------------------------------------
	SET NOCOUNT ON;

	DECLARE 
		@Users_Email_Id VARCHAR(1000),
		@CC_Mail_ID VARCHAR(1000),
		@MailSubjectCr AS NVARCHAR(MAX),
		@DatabaseEmail_Profile varchar(MAX),
		@EmailUser_Body NVARCHAR(Max), 
		@Emailbody NVARCHAR(MAX)= '',
		@EmailHead NVARCHAR(max),
		@EMailFooter NVARCHAR(max),
		@JobName VARCHAR(MAX),
		@JobStartTime VARCHAR(MAX),
		@JobDuration VARCHAR(MAX),
		@MaxJobRunTime VARCHAR(MAX)

		SELECT @Users_Email_Id = 'jatin@uto.in'
		SELECT @CC_Mail_ID = 'aditya@uto.in'

		IF(OBJECT_ID('TEMPDB..#JobRunDurationExceed') IS NOT NULL)
			DROP TABLE #JobRunDurationExceed

		SELECT @DatabaseEmail_Profile = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile_User_Master'
		SELECT @MaxJobRunTime = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'MaxJobRunDuration'
	
		SET @MailSubjectCr='Notification for Jobs exceeds more than 10 minutes';
		------------------------------------------------------------------------
		set @EmailHead= 
				'<html><head><style>
						table{width:90%; border:1px solid black;border-collapse:collapse;}
						th{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;}
						td{border:1px solid black; vertical-align:top;font-family:verdana;font-size:12px; padding:5px;}
						td.center{text-align:center;}
				</style></head><body>
						<p>Dear User,</p>
						<p>Kindly take note of Job Which Exceeds your time limit.</p>
						'

		CREATE TABLE #JobRunDurationExceed (
			Job_Name		NVARCHAR(MAX),
			Job_Start_Time NVARCHAR(MAX),
			Job_Current_Duration NVARCHAR(MAX)
		)

		INSERT INTO #JobRunDurationExceed(Job_Name,Job_Start_Time,Job_Current_Duration)
		SELECT A.[JobName],A.JobStartTime,A.CurrentDuration from (
		SELECT [sJOB].[name] AS [JobName],SJA.start_execution_date as JobStartTime, SJA.stop_execution_date as JobEndTime
		,convert(varchar(10), GETDATE()- sja.start_execution_date, 108) AS CurrentDuration
		, [sDBP].[name] AS [JobOwner]
		, [sCAT].[name] AS [JobCategory]
		, [sJOB].[description] AS [JobDescription]
		, [sJSTP].[step_id] AS [JobStartStepNo]
		, [sJSTP].[step_name] AS [JobStartStepName]
		, [sJOB].[date_created] AS [JobCreatedOn]
		, [sJOB].[date_modified] AS [JobLastModifiedOn]
		, CASE [sJOB].[enabled] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END AS [IsEnabled]
		, CASE WHEN [sSCH].[schedule_uid] IS NULL THEN 'No' ELSE 'Yes' END AS [IsScheduled]
		, CASE WHEN [freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
			   WHEN [freq_type] = 128 THEN 'Start whenever the CPUs become idle'
			   WHEN [freq_type] IN (4,8,16,32) THEN 'Recurring'
			   WHEN [freq_type] = 1 THEN 'One Time'
		  END [ScheduleType]
		, CASE [freq_type]
			   WHEN 1 THEN 'One Time'
			   WHEN 4 THEN 'Daily'
			   WHEN 8 THEN 'Weekly'
			   WHEN 16 THEN 'Monthly'
			   WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
			   WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
			   WHEN 128 THEN 'Start whenever the CPUs become idle'
		  END [Occurrence]
		, CASE [freq_type]
			   WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
			   WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
						+ ' week(s) on '
						+ CASE WHEN [freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
						+ CASE WHEN [freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
						+ CASE WHEN [freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
						+ CASE WHEN [freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
						+ CASE WHEN [freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
						+ CASE WHEN [freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
						+ CASE WHEN [freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
			   WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) 
						 + ' of every '
						 + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
			   WHEN 32 THEN 'Occurs on '
						 + CASE [freq_relative_interval]
							WHEN 1 THEN 'First'
							WHEN 2 THEN 'Second'
							WHEN 4 THEN 'Third'
							WHEN 8 THEN 'Fourth'
							WHEN 16 THEN 'Last'
						   END
						 + ' ' 
						 + CASE [freq_interval]
							WHEN 1 THEN 'Sunday'
							WHEN 2 THEN 'Monday'
							WHEN 3 THEN 'Tuesday'
							WHEN 4 THEN 'Wednesday'
							WHEN 5 THEN 'Thursday'
							WHEN 6 THEN 'Friday'
							WHEN 7 THEN 'Saturday'
							WHEN 8 THEN 'Day'
							WHEN 9 THEN 'Weekday'
							WHEN 10 THEN 'Weekend day'
						   END
						 + ' of every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
						 + ' month(s)'
		  END AS [Recurrence]
		, CASE [freq_subday_type]
			WHEN 1 THEN 'Occurs once at ' 
						+ STUFF(
					 STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
									, 3, 0, ':')
								, 6, 0, ':')
			WHEN 2 THEN 'Occurs every ' 
						+ CAST([freq_subday_interval] AS VARCHAR(3)) + ' Second(s) between ' 
						+ STUFF(
					   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
									, 3, 0, ':')
								, 6, 0, ':')
						+ ' & ' 
						+ STUFF(
						STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
									, 3, 0, ':')
								, 6, 0, ':')
			WHEN 4 THEN 'Occurs every ' 
						+ CAST([freq_subday_interval] AS VARCHAR(3)) + ' Minute(s) between ' 
						+ STUFF(
					   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
									, 3, 0, ':')
								, 6, 0, ':')
						+ ' & ' 
						+ STUFF(
						STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
									, 3, 0, ':')
								, 6, 0, ':')
			WHEN 8 THEN 'Occurs every ' 
						+ CAST([freq_subday_interval] AS VARCHAR(3)) + ' Hour(s) between ' 
						+ STUFF(
						STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
									, 3, 0, ':')
								, 6, 0, ':')
						+ ' & ' 
						+ STUFF(
						STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
									, 3, 0, ':')
								, 6, 0, ':')
		  END [Frequency]

		  , [sSCH].[name] AS [JobScheduleName]
		  , Last_Run = CONVERT(DATETIME, RTRIM(run_date) + ' '
			+ STUFF(STUFF(REPLACE(STR(RTRIM(h.run_time),6,0),
			' ','0'),3,0,':'),6,0,':'))
		, case [sJSTP].Last_run_outcome
			  When 0 then 'Failed'
			  when 1 then 'Succeeded'
			  When 2 then 'Retry'
			  When 3 then 'Canceled'
			  When 5 then 'Unknown'
		  End as Last_Run_Status

		,Last_Run_Duration_HHMMSS = STUFF(STUFF(REPLACE(STR([sJSTP].last_run_duration,7,0),
			' ','0'),4,0,':'),7,0,':')
		, Max_Duration = STUFF(STUFF(REPLACE(STR(l.run_duration,7,0),
			' ','0'),4,0,':'),7,0,':')
		, Next_Run= CONVERT(DATETIME, RTRIM(NULLIF([sJOBSCH].next_run_date, 0)) + ' '
			 + STUFF(STUFF(REPLACE(STR(RTRIM([sJOBSCH].next_run_time),6,0),
			' ','0'),3,0,':'),6,0,':'))
		, CASE [sJOB].[delete_level]
			WHEN 0 THEN 'Never'
			WHEN 1 THEN 'On Success'
			WHEN 2 THEN 'On Failure'
			WHEN 3 THEN 'On Completion'
		  END AS [JobDeletionCriterion]

		, [sSVR].[name] AS [OriginatingServerName]
		,[sJSTP].subsystem
		,[sJSTP].command
		,h.message

	FROM
		[msdb].[dbo].[sysjobs] AS [sJOB]  (NOLOCK)
		INNER JOIN msdb.dbo.sysjobactivity AS SJA (NOLOCK) ON SJA.job_id = [sJOB].job_id
		LEFT JOIN [msdb].[sys].[servers] AS [sSVR]
			 (NOLOCK) ON [sJOB].[originating_server_id] = [sSVR].[server_id]
		LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT]
			 (NOLOCK) ON [sJOB].[category_id] = [sCAT].[category_id]
		LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sJSTP]
			 (NOLOCK) ON [sJOB].[job_id] = [sJSTP].[job_id]
			AND [sJOB].[start_step_id] = [sJSTP].[step_id]
		LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP]
			 (NOLOCK) ON [sJOB].[owner_sid] = [sDBP].[sid]
		LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH]
			 (NOLOCK) ON [sJOB].[job_id] = [sJOBSCH].[job_id]
		LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH]
			 (NOLOCK) ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]

			left JOIN
		(
			SELECT job_id, instance_id = MAX(instance_id),max(run_duration) AS run_duration
				FROM msdb.dbo.sysjobhistory (NOLOCK)
				GROUP BY job_id
		) AS l
		ON sJOB.job_id = l.job_id
		left JOIN
		msdb.dbo.sysjobhistory AS h
		ON h.job_id = l.job_id
		AND h.instance_id = l.instance_id 
		WHERE 
		sja.start_execution_date IS NOT NULL
		AND sja.stop_execution_date IS NULL AND [sJOB].enabled = 1
	 ) AS A ORDER BY A.[JobName]

		DECLARE
		@Count VARCHAR(20) ='', @TableHeader NVARCHAR(MAX) = ''

		SET  @TableHeader = 'Jobs that have exceeds the time limit'
		SET @Count =(SELECT COUNT(*) FROM #JobRunDurationExceed Where Job_Current_Duration > @MaxJobRunTime)

		IF @Count > 0
		BEGIN
			SELECT @Emailbody = @Emailbody + 
			'<p><b>'+ @TableHeader +'</b></p>
								<table>
									<tr>
										<th width="30%">Job Name</th>
										<th width="30%">Job Start Execution Duration</th>
										<th width="20%">Current Duration</th>
									</tr>'
								
								DECLARE Cur_On_ExpiryMail CURSOR  FOR 
								SELECT Job_Name,Job_Start_Time,Job_Current_Duration FROM #JobRunDurationExceed 
								OPEN Cur_On_ExpiryMail 

								FETCH NEXT FROM Cur_On_ExpiryMail INTO  @JobName,@JobStartTime,@JobDuration 
								While @@Fetch_Status = 0 
								BEGIN	
								--------------------------------------------
						
									SET @Emailbody = @Emailbody +
										'<tr>
											
												<td>'+@JobName +' </td>
												<td>'+@JobStartTime +' </td>
												<td>'+@JobDuration+'</td>
										</tr>'
							
						
								FETCH NEXT FROM Cur_On_ExpiryMail INTO  @JobName,@JobStartTime,@JobDuration 
								END
								Close Cur_On_ExpiryMail
								Deallocate Cur_On_ExpiryMail
								SET @Emailbody =  @Emailbody+ '</table>'
								SET @EMailFooter =
						'</br>
						(This is a system generated mail. Please do not reply back to the same)</br>
						</p>
						</body></html>'

				SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
				PRINT @EmailUser_Body

			
						EXEC msdb.dbo.sp_send_dbmail 
						@profile_name = @DatabaseEmail_Profile,
						@recipients = @Users_Email_Id,
						@copy_recipients = @CC_Mail_ID,
						@subject = @MailSubjectCr,
						@body = @EmailUser_Body, 
						@body_format = 'HTML';
			
		END
		IF OBJECT_ID('tempdb..#JobRunDurationExceed') IS NOT NULL DROP TABLE #JobRunDurationExceed
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMailForExceedJobRunDuration]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END