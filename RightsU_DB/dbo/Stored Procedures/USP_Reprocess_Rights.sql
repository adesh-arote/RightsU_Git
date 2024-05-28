CREATE PROCEDURE [dbo].[USP_Reprocess_Rights](@Code INT, @Call_From CHAR(1))
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Reprocess_Rights]', 'Step 1', 0, 'Started Procedure', 0, ''
		PRINT 'Reporocess validation'
	
		IF(@Call_From = 'L')
		BEGIN
			UPDATE Syn_Deal_Rights SET Right_Status = 'P' WHERE Syn_Deal_Code = @Code AND Right_Status = 'E'
			PRINT 'UPDATE Syn_Deal_Rights SET Right_Status = ''P'' WHERE Syn_Deal_Code = ' + CAST(@Code AS VARCHAR) + ' AND Right_Status = ''E'''
		END
		ELSE
		BEGIN
			UPDATE Syn_Deal_Rights SET Right_Status = 'P' WHERE Syn_Deal_Rights_Code = @Code AND Right_Status = 'E'
			PRINT 'UPDATE Syn_Deal_Rights SET Right_Status = ''P'' WHERE Syn_Deal_Rights_Code = ' + CAST(@Code AS VARCHAR) + ' AND Right_Status = ''E'''
		END
		--EXEC USP_Invoke_Validation_Job
		 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Reprocess_Rights]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
