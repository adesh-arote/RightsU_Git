CREATE PROCEDURE [dbo].[USP_Reprocess_Rights](@Code INT, @Call_From CHAR(1))
AS
BEGIN
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
END