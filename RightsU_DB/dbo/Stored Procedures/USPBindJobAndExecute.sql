CREATE PROCEDURE [dbo].[USPBindJobAndExecute] 
--DECLARE
    @Type VARCHAR(50)='',
    @JobName VARCHAR(100)=''
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPBindJobAndExecute]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;	

		CREATE TABLE #TempUSPBindJobAndExecute
		(
			JobName VARCHAR(MAX)
		)

		IF(@Type='List')
		BEGIN
			insert into #TempUSPBindJobAndExecute(JobName)
			 select s.name
			 from  msdb..sysjobs s 
			 left join master.sys.syslogins l on s.owner_sid = l.sid
			 Where s.name like '%rightsu%';
		END

		IF(@Type='Execute')
		BEGIN
			execute msdb.dbo.sp_start_job @job_name = @JobName
		END
		select JobName from #TempUSPBindJobAndExecute

		IF OBJECT_ID('tempdb..#TempUSPBindJobAndExecute') IS NOT NULL DROP TABLE #TempUSPBindJobAndExecute
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPBindJobAndExecute]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END