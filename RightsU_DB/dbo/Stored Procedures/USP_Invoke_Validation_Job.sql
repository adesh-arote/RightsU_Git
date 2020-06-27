CREATE Proc [dbo].[USP_Invoke_Validation_Job]
As
Begin

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
End


--If((Select Count(*) From System_Parameter_New Where Parameter_Name = 'Rights_Validation_Job') = 0)
--Begin
--	Insert InTo System_Parameter_New(Parameter_Name,Parameter_Value,IsActive) Values('Rights_Validation_Job', 'RightsU_Rights_Validation', 'Y')
--End