CREATE PROCEDURE [dbo].[USPUserTrackActivity_Old1](@DBNum NVARCHAR(MAX))
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

	INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	Select 'DB1','Visits Till Date', (Select SUM(NumberOfVisits) From DashboardSummary(NOLOCK) Where Period = 'D' AND DepartmentId = 0),NULL
	UNION
	Select 'DB2','Site visits in '+@Lastmonth+ ''''+(SELECT substring(@Year, 3, len(@Year)))+'' +''+'',ISNULL( (Select SUM(NumberOfVisits) From DashboardSummary(NOLOCK) Where Period = 'D' AND DepartmentId = 0 
AND CAST(ReportDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)),0),NULL
	UNION
	SELECT 'DB3','New users in '+@Lastmonth + ''''+(SELECT substring(@Year, 3, len(@Year)))+''+ ' ',ISNULL((Select SUM(NumberOfNewVisits) From DashboardSummary(NOLOCK) Where Period = 'D' AND DepartmentId = 0 
AND CAST(ReportDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)),0),NULL
	UNION
	Select 'DB4','Unique users in '+@Lastmonth + ''''+(SELECT substring(@Year, 3, len(@Year)))+''+'',ISNULL((Select SUM(NumberOfUniqueVisits) From DashboardSummary(NOLOCK) Where Period = 'M' AND DepartmentId = 0
AND MONTH(ReportDate) = MONTH(CAST(@StartDate AS DATE)) AND YEAR(ReportDate) = YEAR(CAST(@StartDate AS DATE))),0), null 
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

