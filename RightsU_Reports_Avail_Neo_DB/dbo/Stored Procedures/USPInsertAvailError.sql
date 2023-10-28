CREATE PROCEDURE [dbo].[USPInsertAvailError](@ErrorMsg nvarchar(Max),@intCode int)
AS
BEGIN 	

--DECLARE @IntCode INT = 0

--SELECT TOP 1 @IntCode = IntCode FROM Avail_Schedule ORDER BY IntCode DESC

IF(@IntCode >0)
	BEGIN
		UPDATE Avail_Schedule set ProcessEndTime = GETDATE() ,ProcessStatus ='E' ,ErrorMessage = @ErrorMsg WHERE  IntCode = @IntCode
	END
Select @IntCode IntCode
END
