CREATE PROCEDURE [dbo].[USPUserTrackActivity_Old2](@DBNum NVARCHAR(MAX))
AS
--DECLARE
--@DBNum NVARCHAR(MAX) = 'DB2'
BEGIN

	--IF OBJECT_ID('tempdb..#tempSecurityGroup') IS NOT NULL DROP TABLE #tempSecurityGroup
	IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp 
	IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA 
	IF OBJECT_ID('tempdb..#tempB') IS NOT NULL DROP TABLE #tempB 
	IF OBJECT_ID('tempdb..#tempC') IS NOT NULL DROP TABLE #tempC 
	IF OBJECT_ID('tempdb..#tempD') IS NOT NULL DROP TABLE #tempD 
		
	CREATE TABLE #TempDashboard
	(
		DBNum VARCHAR(10),
		Field1 NVARCHAR(100),
		Field2 NVARCHAR(100),
		Field3 NVARCHAR(100),
	)

	DECLARE @StartDate DateTime, @EndDate DateTime, @Lastmonth VARCHAR(10),@Year VARCHAR(10)
	SELECT @StartDate = (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0))
	SELECT @EndDate = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))
	SELECT @Lastmonth = CAST((SELECT left(datename(month, dateadd(m,-1,getdate())), 3)) AS NVARCHAR)
	PRINT @StartDate
	PRINT @EndDate
	PRINT @Lastmonth
	SELECT  @Year = (SELECT YEAR(@EndDate))
	--Select substring(@Year, 3, len(@Year))

	PRINT @StartDate
	PRINT @EndDate

	BEGIN

		DECLARE @IgnoredSecurityGrp NVARCHAR(MAX)
		SET @IgnoredSecurityGrp = (Select Parameter_Value FROM RightsUngReports_16Mar..SystemParameterNew where Parameter_Name = 'IgnoreSecurityGroups_IT')
	
		--START: Site Visits In Last Week
	
		DECLARE @Site_Visits_In_Last_Week INT;
	
		DECLARE @Last_Week_Start INT;
		DECLARE @Last_Week_End INT;
		DECLARE @Last_Week_Start_Text VARCHAR(20);
		DECLARE @Last_Week_End_Text VARCHAR(20);
	
		DECLARE @Current_Time_Id INT;
		DECLARE @Current_Day_Id INT;
	
		SET @Current_Time_Id = (SELECT TimeId FROM Dim_Time WHERE Day = (SELECT DAY(GETDATE())) AND MonthId = (SELECT MONTH(GETDATE())) AND Year = (SELECT YEAR(GETDATE())));
		SET @Current_Day_Id = (SELECT DayId FROM Dim_Time WHERE Day = (SELECT DAY(GETDATE())) AND MonthId = (SELECT MONTH(GETDATE())) AND Year = (SELECT YEAR(GETDATE())));
	
		PRINT @Current_Time_Id;
		PRINT @Current_Day_Id;
	
		SET @Last_Week_Start = @Current_Time_Id - @Current_Day_Id - 7 + 1;
		SET @Last_Week_End = @Current_Time_Id - @Current_Day_Id;
	
		PRINT @Last_Week_Start;
		PRINT @Last_Week_End;
	
		SET @Site_Visits_In_Last_Week = (SELECT SUM(SiteVisits) SiteVisitsInLastWeek
		FROM Fact_UserActivity
		INNER JOIN Dim_Time
		ON Fact_UserActivity.TimeId = Dim_Time.TimeId
		WHERE Fact_UserActivity.TimeId >= @Last_Week_Start AND Fact_UserActivity.TimeId <= @Last_Week_End
		AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',','))));
	
		PRINT @Site_Visits_In_Last_Week;
	
		--END: Site Visits In Last Week
	
		--START: New Users In Last Week
		DECLARE @New_Users_In_Last_Week INT;
	
		SET @New_Users_In_Last_Week = (SELECT COUNT(DISTINCT(UserId)) NewUsersInLastWeek
		FROM Fact_UserActivity
		INNER JOIN Dim_Time
		ON Fact_UserActivity.TimeId = Dim_Time.TimeId
		WHERE Fact_UserActivity.TimeId >= @Last_Week_Start AND Fact_UserActivity.TimeId <= @Last_Week_End
		AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
		AND Fact_UserActivity.UserId
		NOT IN
		(
		SELECT UserId FROM Fact_UserActivity WHERE Fact_UserActivity.TimeId < @Last_Week_Start
		)
		)
		;
	
		PRINT @New_Users_In_Last_Week;
		--END: New Users In Last Week

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

	END

	INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	Select 'DB1','Visits Till Date', (SELECT SUM(SiteVisits) FROM Fact_UserActivity
WHERE Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))),NULL
	UNION
	--Select 'DB2','Site visits in '+@Lastmonth+ ''''+(SELECT substring(@Year, 3, len(@Year)))+'' +''+'',ISNULL( (Select SUM(NumberOfVisits) From DashboardSummary(NOLOCK) Where Period = 'D' AND DepartmentId = 0 
--AND CAST(ReportDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)),0),NULL
	SELECT 'DB2','SITE VISITS IN LAST WEEK (' + @Last_Week_Start_Text + ' To ' + @Last_Week_End_Text + ')',@Site_Visits_In_Last_Week, NULL
	UNION
	--SELECT 'DB3','New users in '+@Lastmonth + ''''+(SELECT substring(@Year, 3, len(@Year)))+''+ ' ',ISNULL((Select SUM(NumberOfNewVisits) From DashboardSummary(NOLOCK) Where Period = 'D' AND DepartmentId = 0 
--AND CAST(ReportDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)),0),NULL
	SELECT 'DB3','NEW USERS IN LAST WEEK (' + @Last_Week_Start_Text + ' To ' + @Last_Week_End_Text + ')',@New_Users_In_Last_Week, NULL
	UNION
	Select 'DB4','Unique users in '+@Lastmonth + ''''+(SELECT substring(@Year, 3, len(@Year)))+''+'',ISNULL((SELECT COUNT(DISTINCT UserId) from Fact_UserActivity
INNER JOIN Dim_Time
ON Dim_Time.TimeId = Fact_UserActivity.TimeId
WHERE Year = @previousProcessing_Year AND 
MonthId = @previousProcessing_Month AND
Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))),0), null 
	UNION
	Select 'DB6' AS DBNum,'Satisfied' ,COUNT(IsSatisfied),NUll FROM ReportFeedback WITH(NOLOCK) 
	INNER JOIN Users
	ON Users.Users_Code = ReportFeedback.UsersCode
	INNER JOIN SecurityGroup
	ON SecurityGroup.Security_Group_Code = Users.Security_Group_Code
	Where IsSatisfied = 'Y'
	AND Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
	UNION
	Select 'DB6','ALL',COUNT(IsSatisfied),Null FROM ReportFeedback WITH(NOLOCK) 
	INNER JOIN Users
	ON Users.Users_Code = ReportFeedback.UsersCode
	INNER JOIN SecurityGroup
	ON SecurityGroup.Security_Group_Code = Users.Security_Group_Code
	WHERE IsSatisfied IN ('Y','N')
	AND Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
	UNION
	Select 'DB9','SUGGESTIONS PROVIDED TILL DATE',COUNT(*),NULL FROM ReportFeedback WITH(NOLOCK) 
	INNER JOIN Users
	ON Users.Users_Code = ReportFeedback.UsersCode
	INNER JOIN SecurityGroup
	ON SecurityGroup.Security_Group_Code = Users.Security_Group_Code
	WHERE UserComments  <> '' 
	AND Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
	
	--------------------New logic for DB6 Starts---------------------------

	--START: DB5
	DECLARE @currentActiveDurationId INT;
	DECLARE @currentActiveDurationId_Start INT;
	DECLARE @currentActiveDurationId_End INT;

	SET @currentActiveDurationId = (SELECT DurationId from DurationDefinition WHERE
									(CAST(GETDATE() AS DATETIME) BETWEEN CAST(StartDate AS DATETIME) AND
									CAST(EndDate AS DATETIME))
									)

	SET @currentActiveDurationId_Start = @currentActiveDurationId - 6
	SET @currentActiveDurationId_End = @currentActiveDurationId - 1

	SELECT DISTINCT Attrib_Group_Name INTO #tempA FROM UsersDetail WITH(NOLOCK) WHERE Attrib_type = 'DP'
	SELECT StartDate,EndDate INTO #tempB FROM  DurationDefinition WITH(NOLOCK) 
	WHERE DurationId >= @currentActiveDurationId_Start AND DurationId <= @currentActiveDurationId_End

	SELECT * INTO #tempC FROM(
	SELECT B.StartDate,B.EndDate,A.Attrib_Group_Name FROM
	#tempA A CROSS JOIN #tempB B 
	)
	AS A
	
	SELECT 'DB5' AS A,A.Attrib_Group_Name AS Attrib_Group_Name,A.EndDate AS EndDate, SUM(A.NumberOfUniqueVisits) AS Cnt INTO #tempD 
	FROM
	(
		SELECT Attrib_Group_Name, dd.EndDate, NumberOfUniqueVisits
		FROM DashboardSummary
		INNER JOIN DurationDefinition dd WITH(NOLOCK) ON CAST(DashboardSummary.ReportDate AS DATE) BETWEEN CAST(dd.StartDate AS DATE) AND CAST(dd.EndDate AS DATE) 
		INNER JOIN Attrib_Group ag WITH(NOLOCK) ON DashboardSummary.DepartmentId = ag.Attrib_Group_Code
		WHERE DashboardSummary.Period = 'B' 
	) AS A
	GROUP BY  A.Attrib_Group_Name, A.EndDate 

	INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	SELECT 'DB5',C.Attrib_Group_Name, C.EndDate,ISNULL(dd.Cnt,0) FROM #tempC C
	LEFT JOIN #tempD dd ON dd.EndDate = C.EndDate AND C.Attrib_Group_Name = dd.Attrib_Group_Name
	--END: DB5 

	-----------------------------------------------------------------------

		INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
		SELECT 'DB7' AS DBNum, Attrib_Group_Name as Field1, NumberOfUniqueVisits as Field2, NULL
				FROM DashboardSummary DS
				INNER JOIN Attrib_Group AG WITH(NOLOCK)
				ON DS.DepartmentId = AG.Attrib_Group_Code
				WHERE Period = 'A'   

		DECLARE @Months TABLE (month int,year int);
WITH R(N) AS
(
SELECT 0
UNION ALL
SELECT N+1 
FROM R
WHERE N < 12
)
INSERT INTO @Months
SELECT DATEPART(MONTH,DATEADD(MONTH,-N,GETDATE())) AS [month], 
       DATEPART(YEAR,DATEADD(MONTH,-N,GETDATE())) AS [year]
FROM R;

SELECT month,year INTO #temp from @Months



		DECLARE @Month INT;
		SET @Month = 0;

		WHILE @Month < 12
		BEGIN
			SELECT @StartDate = (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-@Month, 0))
			SELECT @EndDate = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-@Month, -1))

			INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
			Select 'DB8','Suggestions Collected',(select convert(char(3), @StartDate, 0)),COUNT(*) from ReportFeedback WITH(NOLOCK) 
			INNER JOIN Users
			ON Users.Users_Code = ReportFeedback.UsersCode
			INNER JOIN SecurityGroup
			ON SecurityGroup.Security_Group_Code = Users.Security_Group_Code
			where UserComments <> '' AND (RequestTime Between @StartDate AND @EndDate)
			AND Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
	
			SET @Month = @Month + 1;
		END;

		
		
		SELECT * FROM #TempDashboard WHERE DBNum COLLATE DATABASE_DEFAULT IN (select number from dbo.fn_Split_withdelemiter(''+@DBNum+'',',')) ORDER BY 1

		IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard 
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp 
		IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA 
		IF OBJECT_ID('tempdb..#tempB') IS NOT NULL DROP TABLE #tempB
		IF OBJECT_ID('tempdb..#tempC') IS NOT NULL DROP TABLE #tempC 
		IF OBJECT_ID('tempdb..#tempD') IS NOT NULL DROP TABLE #tempD 
END

