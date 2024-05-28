
CREATE PROCEDURE [dbo].[USPUserTrackActivity](
@DBNum NVARCHAR(MAX))
AS
BEGIN

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

	DECLARE @StartDate DateTime, @EndDate DateTime, @Lastmonth VARCHAR(10), @Year VARCHAR(10)

	SELECT @StartDate = (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0))
	SELECT @EndDate = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))
	SELECT @Lastmonth = CAST((SELECT left(datename(month, dateadd(m,-1,getdate())), 3)) AS NVARCHAR)
	
	SELECT  @Year = (SELECT YEAR(@EndDate))

	BEGIN --DEBUG
	PRINT @StartDate
	PRINT @EndDate
	PRINT @Lastmonth
	END

	INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	Select 'DB1','Visits Till Date', (SELECT Count(*) from Trace WITH(NOLOCK) where RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0),NULL
	UNION
	Select 'DB2','Site visits in '+@Lastmonth+ ''''+(SELECT substring(@Year, 3, len(@Year)))+'' +''+'', (Select Count(*) from Trace WITH(NOLOCK) where RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND (RequestDateTime BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE))),NULL
	UNION
	SELECT 'DB3','New users in '+@Lastmonth + ''''+(SELECT substring(@Year, 3, len(@Year)))+''+ ' ',(select COUNT(DISTINCT UserID) FROM Trace WITH(NOLOCK) WHERE UserID NOT IN (Select Distinct UserId from Trace WITH(NOLOCK) where RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND RequestDateTime < @StartDate)
	AND RequestDateTime BETWEEN @StartDate AND @EndDate),NULL
	UNION
	Select 'DB4','Unique users in '+@Lastmonth + ''''+(SELECT substring(@Year, 3, len(@Year)))+''+'',(select COUNT(DISTINCT UserID) from Trace WITH(NOLOCK) Where RequestDateTime BETWEEN @StartDate AND @EndDate AND RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0), null 
	UNION
	Select 'DB6' AS DBNum,'Satisfied' ,COUNT(IsSatisfied),NUll FROM ReportFeedback WITH(NOLOCK) Where IsSatisfied = 'Y'
	UNION
	Select 'DB6','ALL',COUNT(IsSatisfied),Null FROM ReportFeedback WITH(NOLOCK) WHERE IsSatisfied IN ('Y','N')
	UNION
	Select 'DB9','SUGGESTIONS PROVIDED TILL DATE',COUNT(*),NULL FROM ReportFeedback WITH(NOLOCK) WHERE UserComments  <> '' 
	
	SELECT DISTINCT Attrib_Group_Name INTO #tempA FROM UsersDetail WITH(NOLOCK) WHERE Attrib_type = 'DP'
	SELECT StartDate,EndDate INTO #tempB FROM  DurationDefinition WITH(NOLOCK) WHERE DurationId <= 6

	SELECT * INTO #tempC FROM(
	SELECT B.StartDate,B.EndDate,A.Attrib_Group_Name FROM
	#tempA A CROSS JOIN #tempB B 
	)
	AS A
	
	PRINT 'AD'

	SELECT 'DB5' AS A,A.Attrib_Group_Name AS Attrib_Group_Name,A.EndDate AS EndDate,COUNT(A.UserID) AS Cnt INTO #tempD 
	FROM
	(
		select DISTINCT UserId,usersdetail.Attrib_Group_Name,dd.EndDate AS EndDate
		from usersdetail WITH(NOLOCK)
		INNER JOIN Users WITH(NOLOCK) ON Users.Users_Code = usersdetail.Users_Code 
		INNER JOIN Trace WITH(NOLOCK) ON Trace.userid = Users.users_code
		INNER JOIN DurationDefinition dd WITH(NOLOCK) ON Trace.RequestDateTime BETWEEN CAST(dd.StartDate AS DATETIME) AND CAST(dd.EndDate AS DATETIME) AND dd.DurationId <= 6
		where Attrib_Type = 'DP' AND Trace.Method = 'POST' AND issuccess = 1 
		AND Trace.RequestMethod = 'Login/GetLoginDetails' 
		--GROUP BY userid,usersdetail.Attrib_Group_Name,dd.EndDate
	) AS A
	GROUP BY  A.Attrib_Group_Name,A.EndDate 

	PRINT 'AD1'

	INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	SELECT 'DB5',C.Attrib_Group_Name, C.EndDate,ISNULL(dd.Cnt,0) FROM #tempC C
	LEFT JOIN #tempD dd ON dd.EndDate = C.EndDate AND C.Attrib_Group_Name = dd.Attrib_Group_Name

	-----------------------------------------------------------------------

		INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
		SELECT 'DB7' AS DBNum,A.Attrib_Group_Name as Field1, COUNT(A.UserID) as Field2,NUll FROM(
			select DISTINCT UserId,usersdetail.Attrib_Group_Name
			from usersdetail WITH(NOLOCK) INNER JOIN Users WITH(NOLOCK) ON Users.Users_Code = usersdetail.Users_Code 
			INNER JOIN Trace WITH(NOLOCK) ON Trace.userid = Users.users_code
			where Attrib_Type = 'DP' AND Trace.Method = 'POST' AND issuccess = 1 AND Trace.RequestMethod = 'Login/GetLoginDetails'
			GROUP BY userid,usersdetail.Attrib_Group_Name
		) AS A
		GROUP BY  A.Attrib_Group_Name       


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

--INSERT INTO #temp
SELECT month,year INTO #temp from @Months


	
		DECLARE @Month INT;
		SET @Month = 0;

		WHILE @Month < 12
		BEGIN
			SELECT @StartDate = (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-@Month, 0))
			SELECT @EndDate = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-@Month, -1))

			INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
			Select 'DB8','Suggestions Collected',(select convert(char(3), @StartDate, 0)),COUNT(*) from ReportFeedback WITH(NOLOCK) where UserComments <> '' AND (RequestTime Between @StartDate AND @EndDate)
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

--EXEC USPUserTrackActivity 'DB1,DB2,DB3,DB4,DB5,DB6,DB7,DB8,DB9'
