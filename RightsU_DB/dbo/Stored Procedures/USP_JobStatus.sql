CREATE PROC [dbo].[USP_JobStatus]
AS
BEGIN
Declare @Loglevel int
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_JobStatus]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	SELECT 
		SJ.NAME AS [Job_Name]
		,CASE SJ.enabled WHEN 0 THEN 'Disabled'
				WHEN 1 THEN 'Enabled'
				END AS IsEnabled
		,CASE jh.run_status WHEN 0 THEN 'Failed'
				WHEN 1 THEN 'Success'
				WHEN 2 THEN 'Retry'
				WHEN 3 THEN 'Canceled'
				WHEN 4 THEN 'In progress'
				ELSE 'NA'
				END AS Status
		,ISNULL(MAX(MSDB.DBO.AGENT_DATETIME(RUN_DATE, RUN_TIME)),'') AS [Last_Time_Job_Ran_On]
	FROM 
		msdb.dbo.sysjobs SJ (NOLOCK) LEFT JOIN  msdb.dbo.SYSJOBHISTORY JH
     (NOLOCK) ON SJ.job_id = JH.job_id WHERE 1=1 
    GROUP BY SJ.name, JH.run_status, SJ.enabled 
    ORDER BY  SJ.NAME ,[Last_Time_Job_Ran_On] DESC
	 
if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_JobStatus]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
