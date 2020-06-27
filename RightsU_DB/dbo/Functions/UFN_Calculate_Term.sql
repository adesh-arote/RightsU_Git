-- =============================================
-- Author:		Abhaysingh Rajpurohit
-- CREATE DATE: 10-October-2014
-- Description:	Calculate Term by passing Start Date and End Date
-- =============================================
CREATE FUNCTION [dbo].[UFN_Calculate_Term]
(
	@startDate DATETIME, 
	@endDate DATETIME
)
RETURNS VARCHAR(5)
AS 
BEGIN
	SET @endDate = DATEADD(D, 1, @endDate)
	DECLARE @term VARCHAR(5), @totalMonth INT, @year INT, @month INT
	SET @totalMonth = DATEDIFF(MM, @startDate, @endDate)
	SET @year = @totalMonth / 12
	SET @month = @totalMonth % 12
	SET @term = CAST(@year AS VARCHAR) + '.' + CAST(@month AS VARCHAR)
	RETURN ISNULL(@term, '')
END