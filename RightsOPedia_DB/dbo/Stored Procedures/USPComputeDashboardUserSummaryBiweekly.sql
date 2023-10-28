
CREATE PROCEDURE [dbo].[USPComputeDashboardUserSummaryBiweekly] 
AS 
BEGIN 
	
	PRINT 'START: PRE PROCESSING'
  	EXEC USPDashboardSummary_PreProcessing;
  	PRINT 'END: PRE PROCESSING'

	DECLARE @CurrentDate DATETIME;

	SET @CurrentDate = GETDATE();

	DECLARE @currentProcessing_Day INT;
	DECLARE @currentProcessing_Month INT;
	DECLARE @currentProcessing_Year INT;

	SET @currentProcessing_Day = (SELECT DATEPART(day, @CurrentDate));
	SET @currentProcessing_Month = (SELECT DATEPART(month, @CurrentDate));
	SET @currentProcessing_Year = (SELECT DATEPART(year, @CurrentDate));

	EXEC USPComputeDashboardUserSummaryBiweekly_CurrentBiweek @currentProcessing_Day, @currentProcessing_Month, @currentProcessing_Year;

	IF(@currentProcessing_Day <= 15)
	BEGIN
		SET @currentProcessing_Month = @currentProcessing_Month - 1;
		SET @currentProcessing_Day = 16;
	END
	ELSE
	BEGIN
		SET @currentProcessing_Day = 1;
	END

	EXEC USPComputeDashboardUserSummaryBiweekly_CurrentBiweek @currentProcessing_Day, @currentProcessing_Month, @currentProcessing_Year;
  
END
