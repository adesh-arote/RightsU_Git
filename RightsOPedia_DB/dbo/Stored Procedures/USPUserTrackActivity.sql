

CREATE PROCEDURE [dbo].[USPUserTrackActivity](@DBNum NVARCHAR(MAX))
AS
--DECLARE
--@DBNum NVARCHAR(MAX) = 'DB8'
BEGIN

IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard

CREATE TABLE #TempDashboard
(
DBNum VARCHAR(10),
Field1 NVARCHAR(100),
Field2 NVARCHAR(100),
Field3 NVARCHAR(100),
)

DECLARE @IgnoredSecurityGrp NVARCHAR(MAX)
SET @IgnoredSecurityGrp = ''--(Select Parameter_Value FROM SystemParameterNew where Parameter_Name = 'IgnoreSecurityGroups_IT')

BEGIN ----Visits Till Date

DECLARE @Site_Visits_Till_Date INT;

SET @Site_Visits_Till_Date = (
SELECT SUM(SiteVisits) FROM Fact_UserActivity
WHERE Fact_UserActivity.SecurityGroupId
IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT 
NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
);

PRINT @Site_Visits_Till_Date;

END ----Visits Till Date

BEGIN ----Site Visits In Last Week

DECLARE @Site_Visits_In_Last_Week INT;

DECLARE @Last_Week_Start INT;
DECLARE @Last_Week_End INT;
DECLARE @Last_Week_Start_Text VARCHAR(20);
DECLARE @Last_Week_End_Text VARCHAR(20);

DECLARE @Current_Time_Id INT;
DECLARE @Current_Day_Id INT;

SET @Current_Time_Id = (SELECT TimeId FROM Dim_Time WHERE Day = (SELECT DAY(GETDATE())) AND MonthId = (SELECT MONTH(GETDATE())) AND Year = (SELECT YEAR(GETDATE())));
SET @Current_Day_Id = (SELECT DayId FROM Dim_Time WHERE Day = (SELECT DAY(GETDATE())) AND MonthId = (SELECT MONTH(GETDATE())) AND Year = (SELECT YEAR(GETDATE())));

--PRINT @Current_Time_Id;
--PRINT @Current_Day_Id;

SET @Last_Week_Start = @Current_Time_Id - @Current_Day_Id - 7 + 1;
SET @Last_Week_End = @Current_Time_Id - @Current_Day_Id;

--PRINT @Last_Week_Start;
--PRINT @Last_Week_End;

SET @Site_Visits_In_Last_Week =
(
SELECT SUM(SiteVisits) SiteVisitsInLastWeek
FROM Fact_UserActivity
INNER JOIN Dim_Time
ON Fact_UserActivity.TimeId = Dim_Time.TimeId
WHERE Fact_UserActivity.TimeId >= @Last_Week_Start AND Fact_UserActivity.TimeId <= @Last_Week_End
AND Fact_UserActivity.SecurityGroupId
IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT
NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
);

--PRINT @Site_Visits_In_Last_Week;
END ----Site Visits In Last Week

BEGIN ----New Users In Last Week
DECLARE @New_Users_In_Last_Week INT;

SET @New_Users_In_Last_Week =
(
SELECT COUNT(DISTINCT(UserId)) NewUsersInLastWeek
FROM Fact_UserActivity
INNER JOIN Dim_Time
ON Fact_UserActivity.TimeId = Dim_Time.TimeId
WHERE Fact_UserActivity.TimeId >= @Last_Week_Start AND Fact_UserActivity.TimeId <= @Last_Week_End
AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
AND Fact_UserActivity.UserId NOT IN(
SELECT UserId FROM Fact_UserActivity WHERE Fact_UserActivity.TimeId < @Last_Week_Start)
);

--PRINT @New_Users_In_Last_Week;
END ----New Users In Last Week

BEGIN ----Variables required for Site Visits In Last Week, New Users In Last Week
DECLARE @Text_Day VARCHAR(10);
DECLARE @Text_Month VARCHAR(10);
DECLARE @Text_Year VARCHAR(10);

SET @Text_Day = (SELECT Day FROM Dim_Time WHERE TimeId = @Last_Week_Start);
SET @Text_Month = (SELECT MonthShort FROM Dim_Months
WHERE MonthId IN(
SELECT MonthId FROM Dim_Time
WHERE TimeId = @Last_Week_Start
));

SET @Text_Year = SUBSTRING(CAST((SELECT Year FROM Dim_Time WHERE TimeId = @Last_Week_Start) AS VARCHAR), 3, 2);
 
SET @Last_Week_Start_Text = @Text_Day + '-' + @Text_Month + '-' + @Text_Year;

SET @Text_Day = (SELECT Day FROM Dim_Time WHERE TimeId = @Last_Week_End);
SET @Text_Month = (SELECT MonthShort FROM Dim_Months
WHERE MonthId IN(
SELECT MonthId FROM Dim_Time
WHERE TimeId = @Last_Week_End
));

SET @Text_Year = SUBSTRING(CAST((SELECT Year FROM Dim_Time WHERE TimeId = @Last_Week_End) AS VARCHAR), 3, 2);
 
SET @Last_Week_End_Text = @Text_Day + '-' + @Text_Month + '-' + @Text_Year;

PRINT @Last_Week_Start_Text;
PRINT @Last_Week_End_Text;

END ----Variables required for Site Visits In Last Week, New Users In Last Week

BEGIN ----Unique Users In Last Month

DECLARE @Unique_Users_In_Last_Month INT;

DECLARE @currentProcessing_Day INT;
DECLARE @currentProcessing_Month INT;
DECLARE @previousProcessing_Month INT;
DECLARE @currentProcessing_Year INT;
DECLARE @previousProcessing_Year INT;

SET @currentProcessing_Day = (SELECT DATEPART(day, GETDATE()));
SET @currentProcessing_Month = (SELECT DATEPART(month, GETDATE()));
SET @currentProcessing_Year = (SELECT DATEPART(year, GETDATE()));

PRINT @currentProcessing_Month;
PRINT @currentProcessing_Year;

IF @currentProcessing_Month = 1
BEGIN
SET @previousProcessing_Month = 12;
SET @previousProcessing_Year = @currentProcessing_Year - 1;
END
ELSE
BEGIN
SET @previousProcessing_Month = @currentProcessing_Month - 1;
SET @previousProcessing_Year = @currentProcessing_Year;
END

SET @Unique_Users_In_Last_Month = (
SELECT COUNT(DISTINCT UserId) from Fact_UserActivity
INNER JOIN Dim_Time
ON Dim_Time.TimeId = Fact_UserActivity.TimeId
WHERE Year = @previousProcessing_Year AND
MonthId = @previousProcessing_Month AND
Fact_UserActivity.SecurityGroupId
IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT
NOT IN(select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
);

PRINT @Unique_Users_In_Last_Month;

DECLARE @Last_Month_Text VARCHAR(100);
SET @Last_Month_Text = (SELECT MonthShort FROM Dim_Months WHERE MonthId = @previousProcessing_Month) + '''' + (SELECT SUBSTRING(CAST(@previousProcessing_Year AS VARCHAR), 3, 2));

PRINT @Last_Month_Text;
END ----Unique Users In Last Month

BEGIN ----Customer Satisfaction

DECLARE @Customer_Satisfaction_All INT;

SET @Customer_Satisfaction_All = (
SELECT (SUM(NumberOfThumbsUp) + SUM(NumberOfThumbsDown)) CustomerSatisfactionAll FROM Fact_UserActivity WITH(NOLOCK)
WHERE Fact_UserActivity.SecurityGroupId
IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT
NOT IN(select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
);

PRINT @Customer_Satisfaction_All;

DECLARE @Customer_Satisfaction_Satisfied INT;

SET @Customer_Satisfaction_Satisfied = (
SELECT SUM(NumberOfThumbsUp) FROM Fact_UserActivity WITH(NOLOCK)
WHERE Fact_UserActivity.SecurityGroupId
IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT
NOT IN(select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
);

PRINT @Customer_Satisfaction_Satisfied;

END ----Customer Satisfaction

BEGIN ----Suggestions Provided Till Date

DECLARE @SuggestionsProvidedTillDate INT;

SET @SuggestionsProvidedTillDate = (
SELECT SUM(NumberOfFeedbackMessages) FROM Fact_UserActivity
WHERE Fact_UserActivity.SecurityGroupId
IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT
NOT IN(select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
);

PRINT @SuggestionsProvidedTillDate;

END ----Suggestions Provided Till Date

BEGIN ----Suggestions Collected

DECLARE @Month INT;
SET @Month = 0;
DECLARE @StartDate DateTime, @EndDate DateTime;

WHILE @Month < 12
BEGIN
SELECT @StartDate = (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-@Month, 0))
SELECT @EndDate = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-@Month, -1))

DECLARE @CurrentStartDimTime INT;
DECLARE @CurrentEndDimTime INT;

DECLARE @StartCurrentDay INT;
DECLARE @StartCurrentMonth INT;
DECLARE @StartCurrentYear INT;

DECLARE @EndCurrentDay INT;
DECLARE @EndCurrentMonth INT;
DECLARE @EndCurrentYear INT;

SET @StartCurrentDay = (SELECT DAY(@StartDate));
SET @StartCurrentMonth = (SELECT MONTH(@StartDate));
SET @StartCurrentYear = (SELECT YEAR(@StartDate));

SET @EndCurrentDay = (SELECT DAY(@EndDate));
SET @EndCurrentMonth = (SELECT MONTH(@EndDate));
SET @EndCurrentYear = (SELECT YEAR(@EndDate));

SET @CurrentStartDimTime = (SELECT TimeId from Dim_Time WHERE Day = @StartCurrentDay AND MonthId = @StartCurrentMonth AND Year = @StartCurrentYear);
SET @CurrentEndDimTime = (SELECT TimeId from Dim_Time WHERE Day = @EndCurrentDay AND MonthId = @EndCurrentMonth AND Year = @EndCurrentYear);

INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
Select 'DB8','Suggestions Collected',(SELECT convert(char(3), @StartDate, 0)), SUM(NumberOfFeedbackMessages)
FROM Fact_UserActivity
WHERE Fact_UserActivity.SecurityGroupId
IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT
NOT IN(select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
AND (TimeId >= @CurrentStartDimTime AND TimeId <= @CurrentEndDimTime)

SET @Month = @Month + 1;
END;

END ----Suggestions Collected

INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
Select 'DB1','Visits Till Date', (@Site_Visits_Till_Date),NULL
UNION
SELECT 'DB2','Site Visits In Last Week (' + @Last_Week_Start_Text + ' To ' + @Last_Week_End_Text + ')',@Site_Visits_In_Last_Week, NULL
UNION
SELECT 'DB3','New Users In Last Week (' + @Last_Week_Start_Text + ' To ' + @Last_Week_End_Text + ')',@New_Users_In_Last_Week, NULL
UNION
SELECT 'DB4','Unique Users in ' + @Last_Month_Text, @Unique_Users_In_Last_Month, NULL
UNION
SELECT 'DB6' AS DBNum, 'Satisfied', @Customer_Satisfaction_Satisfied, NULL
UNION
SELECT 'DB6', 'ALL', @Customer_Satisfaction_All, NULL  
UNION
Select 'DB9', 'SUGGESTIONS PROVIDED TILL DATE', @SuggestionsProvidedTillDate, NULL

SELECT * FROM #TempDashboard WHERE DBNum COLLATE DATABASE_DEFAULT IN (select number from dbo.fn_Split_withdelemiter(''+@DBNum+'',',')) ORDER BY 1

IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard

END
