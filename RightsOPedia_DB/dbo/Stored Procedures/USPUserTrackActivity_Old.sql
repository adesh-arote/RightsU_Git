CREATE PROCEDURE [dbo].[USPUserTrackActivity_Old](@DBNum NVARCHAR(MAX))
AS
--DECLARE @DBNum NVARCHAR(MAX) = 'DB5'
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
	

	INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	Select 'DB1','Visits Till Date', (Select Count(*) from Trace WITH(NOLOCK) where RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0
	AND ResponseContent LIKE '%Login Successful%' 
	),NULL
	UNION
	Select 'DB2','Site visits in '+@Lastmonth+ ''''+(Select substring(@Year, 3, len(@Year)))+'' +''+'', (Select Count(*) from Trace WITH(NOLOCK) where RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND (RequestDateTime BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE))),NULL
	UNION
	SELECT 'DB3','New users in '+@Lastmonth + ''''+(Select substring(@Year, 3, len(@Year)))+''+ ' ',(select COUNT(DISTINCT UserID) FROM Trace WITH(NOLOCK) WHERE UserID NOT IN (Select Distinct UserId from Trace WITH(NOLOCK) where RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND RequestDateTime < @StartDate)
	AND RequestDateTime BETWEEN @StartDate AND @EndDate),NULL
	UNION
	Select 'DB4','Unique users in '+@Lastmonth + ''''+(Select substring(@Year, 3, len(@Year)))+''+'',(select COUNT(DISTINCT UserID) from Trace WITH(NOLOCK) Where RequestDateTime BETWEEN @StartDate AND @EndDate AND RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0), null 
	UNION
	Select 'DB6' AS DBNum,'Satisfied' ,COUNT(IsSatisfied),NUll 
	from ReportFeedback rf WITH(NOLOCK) 
	INNER JOIN Users u WITH(NOLOCK) ON u.Users_Code = rf.UsersCode
	INNER JOIN SecurityGroup sg ON sg.Security_Group_Code = u.Security_Group_Code
	Where IsSatisfied = 'Y'
	AND sg.Security_Group_Name NOT IN ('System Admin','Legal','Deal Entry','IT','Legal Head','PFT Users')
	UNION
	Select 'DB6' AS DBNum,'ALL' ,COUNT(IsSatisfied),NUll 
	from ReportFeedback rf WITH(NOLOCK) 
	INNER JOIN Users u WITH(NOLOCK) ON u.Users_Code = rf.UsersCode
	INNER JOIN SecurityGroup sg ON sg.Security_Group_Code = u.Security_Group_Code
	WHERE IsSatisfied IN ('Y','N')
	AND sg.Security_Group_Name NOT IN ('System Admin','Legal','Deal Entry','IT','Legal Head','PFT Users')
	UNION
	Select 'DB9','SUGGESTIONS PROVIDED TILL DATE',COUNT(*),NULL from ReportFeedback WITH(NOLOCK) where UserComments  <> '' 
	
	-----Commented for new logic------------
	--DECLARE @StartDateNew DateTime, @EndDateNew DateTime
	--DECLARE db_cursor CURSOR FOR
	--		SELECT StartDate,EndDate from DurationDefinition
	--	OPEN db_cursor
	--	FETCH NEXT FROM db_cursor INTO @StartDateNew,@EndDateNew
	--		WHILE @@FETCH_STATUS = 0
	--			BEGIN
	--			PRINT @StartDAteNew
	--			PRINT @EndDateNew
	--			--select convert(varchar, @EndDateNew, 5)
	--			--SELECT LEFT(@EndDateNew, 6)

	--				INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	--				SELECT 'DB5',A.Attrib_Group_Name,(SELECT LEFT(@EndDateNew, 6)),COUNT(A.UserID) FROM(
	--				select DISTINCT UserId,First_Name, Last_Name,usersdetail.Attrib_Group_Name
	--				from usersdetail
	--				INNER JOIN Users ON Users.Users_Code = usersdetail.Users_Code 
	--				INNER JOIN Trace ON	Trace.userid = Users.users_code
	--				where Attrib_Type = 'DP' AND Trace.Method = 'POST' AND issuccess = 1 AND Trace.RequestMethod = 'Login/GetLoginDetails' AND Trace.RequestDateTime BETWEEN CAST(@StartDateNew AS DATETIME) AND CAST(@EndDateNew AS DATETIME)
	--				GROUP BY userid, first_name, last_name,usersdetail.Attrib_Group_Name
	--				) AS A
	--				GROUP BY  A.Attrib_Group_Name 

	--				FETCH NEXT FROM db_cursor INTO @StartDateNew,@EndDateNew
	--			END
	--		CLOSE db_cursor
	--		DEALLOCATE db_cursor
	---------------------------------------------------------------------------------------------

	--------------------New logic for DB6 Starts---------------------------


	CREATE TABLE #tempDurationDefinition
	(
		[DurationId] INT,
		[StartDate] DATE,
		[EndDate] DATE,
		[DurationLabel] NVARCHAR(MAX)

	)

	DECLARE @currentActiveDurationId INT;
	DECLARE @currentActiveDurationId_Start INT;
	DECLARE @currentActiveDurationId_End INT;
	
	SET @currentActiveDurationId = (SELECT DurationId from DurationDefinition WHERE
	(CAST(GETDATE() AS DATETIME) BETWEEN CAST(StartDate AS DATETIME) AND
	CAST(EndDate AS DATETIME))
	)
	
	SET @currentActiveDurationId_Start = @currentActiveDurationId - 6
	SET @currentActiveDurationId_End = @currentActiveDurationId - 1

	Select Distinct Attrib_Group_Name into #tempA from UsersDetail where Attrib_type = 'DP'
	--start: old commented
	--SELECT StartDate,EndDate into #tempB from  DurationDefinition where DurationId <= 6
	--end: old commented

	SELECT StartDate,EndDate INTO #tempB 
	FROM  DurationDefinition WITH(NOLOCK)
    WHERE DurationId >= @currentActiveDurationId_Start AND DurationId <= @currentActiveDurationId_End

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
		INNER JOIN SecurityGroup WITH(NOLOCK) ON Users.Security_Group_Code = SecurityGroup.Security_Group_Code 
		INNER JOIN Trace WITH(NOLOCK) ON Trace.userid = Users.users_code
		INNER JOIN DurationDefinition dd WITH(NOLOCK) ON Trace.RequestDateTime BETWEEN CAST(dd.StartDate AS DATETIME) AND CAST(dd.EndDate AS DATETIME) 
		--AND dd.DurationId <= 6
		where Attrib_Type = 'DP' AND Trace.Method = 'POST' AND issuccess = 1 
		AND Trace.RequestMethod = 'Login/GetLoginDetails' AND 
		Trace.ResponseContent LIKE '%Login Successful%'
		AND Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
		--GROUP BY userid,usersdetail.Attrib_Group_Name,dd.EndDate
	) AS A
	GROUP BY  A.Attrib_Group_Name,A.EndDate 

	--SELECT 'DB5' AS A,A.Attrib_Group_Name AS Attrib_Group_Name,A.EndDate AS EndDate,COUNT(A.UserID) AS Cnt INTO #tempD 
	--FROM
	--(
	--	select DISTINCT UserId,usersdetail.Attrib_Group_Name,dd.EndDate AS EndDate
	--	from usersdetail WITH(NOLOCK)
	--	INNER JOIN Users WITH(NOLOCK) ON Users.Users_Code = usersdetail.Users_Code 
	--	INNER JOIN Trace WITH(NOLOCK) ON	trace.RequestContent LIKE '%' + usersdetail.Login_Name + '%'--Trace.userid = Users.users_code
	--	INNER JOIN [#tempDurationDefinition] dd WITH(NOLOCK) ON Trace.RequestDateTime BETWEEN CAST(dd.StartDate AS DATETIME) 
	--	AND CAST(dd.EndDate AS DATETIME) 
	--	AND dd.DurationId >= @currentActiveDurationId_Start AND dd.DurationId <= @currentActiveDurationId_End
	--	where Attrib_Type = 'DP' AND Trace.Method = 'POST' AND issuccess = 1
	--	AND Trace.RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND 
	--	Trace.ResponseContent LIKE '%Login Successful%'
	--	--GROUP BY userid,usersdetail.Attrib_Group_Name,dd.EndDate
	--) AS A
	--GROUP BY  A.Attrib_Group_Name,A.EndDate 

	PRINT 'AD1'

	--CONVERT(CHAR(4), C.EndDate, 100) + CONVERT(CHAR(4), C.EndDate, 120)

	INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
	SELECT 'DB5',C.Attrib_Group_Name, C.EndDate,ISNULL(dd.Cnt,0) FROM #tempC C
	LEFT JOIN #tempD dd ON dd.EndDate = C.EndDate AND C.Attrib_Group_Name = dd.Attrib_Group_Name

	-----------------------------------------------------------------------

		INSERT INTO #TempDashboard(DBNum,Field1,Field2,Field3)
			Select 'DB7' AS DBNum,b.Attrib_Group_Name AS Field1,COUNT(B.Attrib_Group_Name) AS Field2,NULL FROM (
		SELECT a.Login_Name,a.Attrib_Group_Name FROM (
		Select Distinct u.Login_Name,ag.Attrib_Group_Name FROM UsersDetail ud WITH (NOLOCK)
		INNER JOIN Users u WITH (NOLOCK) ON u.Users_Code = ud.Users_Code
		INNER JOIN SecurityGroup sg ON sg.Security_Group_Code = u.Security_Group_Code AND SG.Security_Group_Name COLLATE DATABASE_DEFAULT NOT IN ('System Admin','Legal','Deal Entry','IT','Legal Head','PFT Users')
		INNER JOIN Attrib_Group ag WITH (NOLOCK) ON ag.Attrib_Group_Code = ud.Attrib_Group_Code AND ag.Attrib_Type = 'DP'
		--ORDER by u.Login_Name
		) A
		INNER JOIN Trace tr WITH (NOLOCK) ON tr.RequestContent COLLATE DATABASE_DEFAULT LIKE '%'+a.Login_Name+'%'  AND RequestMethod COLLATE DATABASE_DEFAULT like '%n/GetLoginDetails%' AND isSuccess = 1 
		AND ResponseContent like '%Login Successful%'
		) B
		GROUP BY b.Attrib_Group_Name


		--SELECT 'DB7' AS DBNum,A.Attrib_Group_Name as Field1, COUNT(A.UserID) as Field2,NUll FROM(
		--	select DISTINCT UserId,usersdetail.Attrib_Group_Name
		--	from usersdetail WITH(NOLOCK) INNER JOIN Users WITH(NOLOCK) ON Users.Users_Code = usersdetail.Users_Code 
		--	INNER JOIN Trace WITH(NOLOCK) ON	trace.RequestContent LIKE '%' + usersdetail.Login_Name + '%'--Trace.userid = Users.users_code
		--	where Attrib_Type = 'DP' AND Trace.Method = 'POST' AND issuccess = 1 AND Trace.RequestMethod = 'n/GetLoginDetails'
		--	GROUP BY userid,usersdetail.Attrib_Group_Name
		--) AS A
		--GROUP BY  A.Attrib_Group_Name       


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


		
		
--		SELECT 
--    Distinct Month as Field2,ISNULL(TotalCount,0) as Field3,
--	'DB8' AS DBNum, 'Suggestions Collected' AS Field1
--FROM 
--    (SELECT 
--			userid,
--			first_name, 
--			last_name, 
--			User_Image,
--			Datepart(year, trace.requestdatetime)  AS 'Year1', 
--			Datepart(month, trace.requestdatetime) AS 'Month1',
--			COUNT(first_name) AS TotalCount
--        FROM trace 
--        INNER JOIN pointsystemurl ON pointsystemurl.pointsystemurl = trace.requestmethod 
--        INNER JOIN pointsystem ON pointsystem.pointsystemurlid = pointsystemurl.pointsystemurlid 
--        INNER JOIN users ON users.users_code = trace.userid 
--		WHERE  
--		trace.method = 'POST' 
--		AND issuccess = 1 
--		AND pointsystem.isunique = 0 
--		AND pointsystemurl.PointSystemUrlId = 4 
--		AND Datepart(year, trace.requestdatetime) = Datepart(year, Getdate())   
--		GROUP  BY 
--		userid,first_name, last_name,User_Image,
--		Datepart(month, trace.requestdatetime), 
--		Datepart(year, trace.requestdatetime)) AS TotalCounts
--		RIGHT JOIN #temp t ON t.month = TotalCounts.Month1

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

	--SELECT * FROM #TempDashboard WHERE DBNum COLLATE DATABASE_DEFAULT IN (select number from dbo.fn_Split_withdelemiter(''+@DBNum+'',',')) ORDER BY 1

		/*Commented by Rahul*/
		--SELECT 'DB8' AS DBNum,'Suggestions Collected' AS Field1,CHOOSE(A.Month,'JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER') as Field2, SUM(A.TotalCount) as Field3 FROM(
		--SELECT userid,first_name, last_name, User_Image,Datepart(year, trace.requestdatetime)  AS 'Year', Datepart(month, trace.requestdatetime) AS 'Month',COUNT(first_name) AS TotalCount
  --      FROM trace 
  --      INNER JOIN pointsystemurl ON pointsystemurl.pointsystemurl = trace.requestmethod 
  --      INNER JOIN pointsystem ON pointsystem.pointsystemurlid = pointsystemurl.pointsystemurlid 
  --      INNER JOIN users ON users.users_code = trace.userid 
		--WHERE  trace.method = 'POST' AND issuccess = 1 AND pointsystem.isunique = 0 AND pointsystemurl.PointSystemUrlId = 4 AND Datepart(year, trace.requestdatetime) = Datepart(year, Getdate())   
		--GROUP  BY userid,first_name, last_name,User_Image,Datepart(month, trace.requestdatetime), Datepart(year, trace.requestdatetime)) AS A
		--GROUP BY  A.Month 
		
		
		SELECT * FROM #TempDashboard WHERE DBNum COLLATE DATABASE_DEFAULT IN (select number from dbo.fn_Split_withdelemiter(''+@DBNum+'',',')) ORDER BY 1

		IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard 
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp 
		IF OBJECT_ID('tempdb..#tempA') IS NOT NULL DROP TABLE #tempA 
		IF OBJECT_ID('tempdb..#tempB') IS NOT NULL DROP TABLE #tempB
		IF OBJECT_ID('tempdb..#tempC') IS NOT NULL DROP TABLE #tempC 
		IF OBJECT_ID('tempdb..#tempD') IS NOT NULL DROP TABLE #tempD 
		IF OBJECT_ID('tempdb..#tempDurationDefinition') IS NOT NULL DROP TABLE #tempDurationDefinition
		
END

--EXEC USPUserTrackActivity 'DB1,DB2,DB3,DB4,DB5,DB6,DB7,DB8,DB9'
