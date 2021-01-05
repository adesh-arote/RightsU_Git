
CREATE FUNCTION [dbo].[UFN_Calculate_Term]
(
	@startDate DATETIME, 
	@endDate DATETIME
)
RETURNS VARCHAR(10)
AS 
-- =============================================
-- Author:		Abhaysingh Rajpurohit
-- CREATE DATE: 10-October-2014
-- Description:	Calculate Term by passing Start Date and End Date
-- =============================================
BEGIN
	--DECLARE @startDate DATETIME = CAST('2020-03-24' AS DATETIME), @endDate DATETIME = CAST('9999-12-29' AS DATETIME)

	IF( @endDate <> '9999-12-31 00:00:00.000')
	 SET @endDate = DATEADD(D, 1, @endDate)

	DECLARE @term VARCHAR(10), @totalMonth INT, @year INT, @month INT
	DECLARE @day INT, @SDno INT, @EDno INT

	SET @totalMonth = DATEDIFF(MM, @startDate, @endDate)

	SET @SDno = DATEPART(day, @startDate)
    SET @EDno = DATEPART(day, @endDate)

	IF @EDno < @SDno 
		SET @totalMonth = @totalMonth -1

	SET @year = @totalMonth / 12
	SET @month = @totalMonth % 12
	
	IF (@EDno > @SDno)
       SET @day = @EDno - @SDno
    ELSE IF (@SDno = @EDno)
       SET @day = 0
	ELSE IF ( DATEPART(month, @startDate) =  DATEPART(month, @endDate) AND  DATEPART(YEAR, @startDate) = DATEPART(YEAR, @endDate)) 
       SET @day =  DATEDIFF(DD, @startDate, @endDate)
    ELSE
	BEGIN
		DECLARE @FirstDay DATETIME, @LastDay DATETIME

		SET @FirstDay = @endDate-DAY(@endDate)+1
		set @day =  DATEDIFF(DD, @FirstDay, @endDate)
	
		SET @startDate = DateAdd(month,@month,@startDate)
		SET @startDate = DateAdd(year,@year,@startDate)

		SET @LastDay =  DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@startDate)+1,1))
		SET @day = @day + DATEDIFF(DD, @startDate, @LastDay)
		--SELECT @day
	END

	SET @term = CAST(@year AS VARCHAR) + '.' + CAST(@month AS VARCHAR) + '.' + CAST(@day AS VARCHAR)
	RETURN  ISNULL(@term, '')
END

 /*var val = CalculateMonthBetweenTwoDate(startDate, endDate);
        var year = val / 12;
        var month = val % 12;

        var day = 0;
        var SDno = startDate.getDate();
        var EDno = endDate.getDate();
        
        if (EDno > SDno) {
            day = EDno - SDno
        }
        else if (startDate.getMonth() == endDate.getMonth() && startDate.getFullYear() == endDate.getFullYear()) {
            day = CalculateDaysBetweenTwoDates(startDate, endDate);
        }
        else if (SDno == EDno) {
            day = 0;
        }
        else {
            var m = endDate.getMonth(),
                y = endDate.getFullYear();
            var FirstDay = new Date(y, m, 1);
            day = CalculateDaysBetweenTwoDates(FirstDay, endDate);

            startDate.setMonth(startDate.getMonth() + month);

                m = startDate.getMonth(),
                y = startDate.getFullYear();
            var LastDay = new Date(y, m + 1, 1);
            day = day + CalculateDaysBetweenTwoDates(startDate , LastDay);
        }
        var term = parseInt(year) + '.' + month + "." + day;
        return term;
		*/

	--DECLARE @date datetime2 = '2018-06-02 08:24:14.3112042';
	--SELECT 
 --   DATEPART(day, @date) AS DAY,
 --   DATEPART(weekday, @date) AS WEEKDAY,
 --   DATEPART(month, @date) AS MONTH,
 --   DATEPART(year, @date) AS YEAR;


	--SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))