CREATE PROCEDURE [dbo].[USP_Invoke_Validation_Job]
As
Begin
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Invoke_Validation_Job]', 'Step 1', 0, 'Started Procedure', 0, ''  
		--Declare @Validation_Job_Name Varchar(1000) = ''
		--Select @Validation_Job_Name = Parameter_Value From System_Parameter_New Where Parameter_Name = 'Rights_Validation_Job'

		--Begin Try
		--Begin Try

		----IF Not EXISTS(SELECT 1
	 ----         FROM msdb.dbo.sysjobs J
	 ----         JOIN msdb.dbo.sysjobactivity A
	 ----             ON A.job_id=J.job_id
	 ----         WHERE J.name = @Validation_Job_Name
	 ----         AND A.run_requested_date IS NOT NULL
	 ----         AND A.stop_execution_date IS NULL
		----	)
		----Begin
		
		--	--EXEC msdb.dbo.sp_start_job @Validation_Job_Name
		----END
		--End Try
		--Begin Catch
		
		--	--WAITFOR DELAY '00:00:20';
		--	--exec [USP_Invoke_Validation_Job]
		--	Print 'ad'
		--End Catch
		--End Try
		--Begin Catch
		
		--	--WAITFOR DELAY '00:00:20';
		--	--exec [USP_Invoke_Validation_Job]
		--	Print 'ad'
		--End Catch
		--End
		Print 'abc'
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Invoke_Validation_Job]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
End
