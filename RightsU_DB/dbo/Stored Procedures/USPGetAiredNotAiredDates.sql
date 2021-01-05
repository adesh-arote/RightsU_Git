
--EXEC USPGetAiredNotAiredDates
CREATE PROCEDURE [dbo].[USPGetAiredNotAiredDates]
AS
BEGIN
	DECLARE @NStart_Date DATE = GETDATE(), @NEnd_Date DATE = GETDATE(), @AStart_Date DATE = GETDATE(), @AEnd_Date DATE = GETDATE()
    
	SET @NEnd_Date = DATEADD(DAY,15,@NStart_Date)  	  
	
	SET @AEnd_Date=(SELECT CONVERT(DATE,(SELECT MAX(CAST(Schedule_Item_Log_Date AS DATE)) from BV_Schedule_Transaction where Schedule_Item_Log_Date < GETDATE())))
	SET @AStart_Date = DATEADD(DAY, -15, @AEnd_Date) 
     	  
	SELECT @NStart_Date NStart_Date, @NEnd_Date NEnd_Date, @AStart_Date AStart_Date, @AEnd_Date AEnd_Date
END
