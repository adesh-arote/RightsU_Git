CREATE PROCEDURE [dbo].[USPGenerateDates]
AS
BEGIN
	IF OBJECT_ID('tempdb.#TempDates') IS NOT NULL 
	BEGIN
	DROP TABLE #TempDates
	END


CREATE TABLE #TempDates
     (
     MonthOrder INT,
     StartDate DATE,
     EndDate DATE,
     strMonth VARCHAR(100)
     )

			DECLARE @Cnt INT = 1;
            DECLARE @date DAtetime = GETDATE()
            DECLARE
            @StartDate DATETIme,
            @EndDate DATETIME

            WHILE @Cnt <= 12
            BEGIN
          
                SET @StartDate = (SELECT DATEADD(month, DATEDIFF(month, 0, @date), 0) AS StartOfMonth)
                SET @EndDate  = (SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@date)+1,0)))

                INSERT INTO #TempDates (MonthOrder,StartDate,EndDate,strMonth)
                SELECT @cnt,@StartDate,@EndDate,
                RIGHT(CAST(DATEPART(YY, @EndDate) AS VARCHAR(10)), 2) + RIGHT('0' + CAST(DATEPART(MM, @EndDate) AS VARCHAR(10)), 2) + '_' + UPPER(LEFT(DATENAME(MONTH, @EndDate), 3)) + '-' + RIGHT(CAST(DATEPART(YY, @EndDate) AS VARCHAR(10)), 2) STRDATE
                SET @date = (SELECT dateadd(m, 1, @date))
                SET @Cnt = @Cnt + 1;
          
            END;

			Select MonthOrder,strMonth As [MonthName] From #TempDates

			Drop table #TempDates
END

