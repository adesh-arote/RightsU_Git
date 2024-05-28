CREATE PROCEDURE [dbo].[USPITGetGenreWiseTitle]
@DashboardType VARCHAR(50),
@Language NVARCHAR(50)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetGenreWiseTitle]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
		IF OBJECT_ID('tempdb..#tempFinal') IS NOT NULL DROP TABLE #tempFinal
		IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage

		DECLARE @Deal_Type_Code NVARCHAR(100),
		@LanguageNames NVARCHAR(MAX)
	
		CREATE TABLE #tempLanguage(
		Language_Codes INT
		)

		SET @LanguageNames = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DBLanguageNames_IT')

		IF(@Language = 'ALL')
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code FROM Language WITH(NOLOCK)
			END
		ELSE IF(@Language = 'Others')
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code  FROM Language WITH(NOLOCK) where Language_Name COLLATE DATABASE_DEFAULT NOT IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
			END
		ELSE
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code FROM Language WITH(NOLOCK) where Language_Name = ''+@Language+''
			END

		
		IF(@DashboardType = 'M')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Movie_IT' )
			END
		ELSE IF(@DashboardType = 'p')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New  WITH(NOLOCK) where Parameter_Name = 'DashboardType_Prog_IT' )
			END
		ELSE
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Web_IT' )
			END

		SELECT * INTO #temp
		FROM (
			SELECT COUNT(B.Genres_Code) GenresCount,B.Genres_Name,B.Genres_Code FROM (
				SELECT ROW_NUMBER() OVER (PARTITION BY A.Title_Code ORDER BY A.Genres_Name) row_num,A.Title_Code,A.Genres_Code,A.Genres_Name 
				FROM (
					Select Distinct ADRT.Title_Code,TG.Genres_Code,G.Genres_Name 
					from Acq_Deal_Rights ADR WITH(NOLOCK)
					INNER JOIN Acq_Deal AD WITH(NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))) 
					INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
					INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADRT.Title_Code
					INNER JOIN #tempLanguage l ON t.Title_Language_Code = l.Language_Codes
					INNER JOIN Title_Geners TG WITH(NOLOCK) ON TG.Title_Code = ADRT.Title_Code
					INNER JOIN Genres G WITH(NOLOCK) ON G.Genres_Code = TG.Genres_Code --AND TG.Genres_Code IN (10,14,17,20,26,30,32,34,1236,37,40,1237,46,51,52,56,131,1238,1239,68,69,1240,1241,1242,1243,1244,1245,1246,127,1247,1248,63,1249,1250,1251,1252,1253,1254,1255,1256,1257)
					WHERE GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31Dec9999')
					AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
				) AS A
			) AS B 
		where B.row_num = 1
		GROUP BY B.Genres_Code,B.Genres_Name
		--order by GenresCount desc
		) temp
		ORDER by GenresCount DESC
	
		Select Final.GenresName,Final.GenresCount, (Select SUM(GenresCount) from #temp) AS Total INTO #tempFinal FROM (
		SELECT 'a' AS Sort,GenresCount, Genres_Name AS GenresName FROM (
			SELECT ROW_NUMBER() OVER( order by GenresCount desc) as 'a',GenresCount,Genres_Name  FROM #temp --WHERE Genres_Code IN (1,2,3,64,24)
		) AS A WHERE A < 6 
		UNION
		SELECT 'b' AS Sort,SUM(GenresCount) AS 'GenresCount', 'Others' AS GenresName FROM (
			SELECT ROW_NUMBER() OVER( order by GenresCount desc) as 'a',GenresCount,Genres_Name  FROM #temp --WHERE Genres_Code NOT IN (1,2,3,64,24)
		) AS A WHERE A > 5 AND GenresCount > 0
		--ORDER BY Sort,GenresCount Desc
		) AS Final
		Where Final.GenresCount > 0
		ORDER BY Sort,GenresCount Desc

		Select GenresName AS Name,ISNULL(GenresCount,0) AS Count,ISNULL(Total,0) AS Total, ISNULL(CAST(ROUND(GenresCount * 100.0 / Total, 1)  as numeric(36,2)),0) AS Percentage from #tempFinal
	
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
		IF OBJECT_ID('tempdb..#tempFinal') IS NOT NULL DROP TABLE #tempFinal
		IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetGenreWiseTitle]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
