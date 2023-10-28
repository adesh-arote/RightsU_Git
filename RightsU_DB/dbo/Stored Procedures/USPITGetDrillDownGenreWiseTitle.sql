CREATE PROCEDURE [dbo].[USPITGetDrillDownGenreWiseTitle]
@DashboardType VARCHAR(50),
@Language NVARCHAR(50),
@SearchText NVARCHAR(MAX)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[]', 'Step 1', 0, 'Started Procedure', 0, ''

	--DECLARE
	--@DashboardType VARCHAR(50) ='M',
	--@Language NVARCHAR(50) = 'ALL',
	--@SearchText NVARCHAR(MAX)

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

		
		IF(@DashboardType = 'M' OR @DashboardType = 'Movies')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Movie_IT' )
			END
		ELSE IF(@DashboardType = 'p' OR @DashboardType = 'Program')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New  WITH(NOLOCK) where Parameter_Name = 'DashboardType_Prog_IT' )
			END
		ELSE
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Web_IT' )
			END

			SELECT  g.Genres_Name AS Genre, ISNULL(ecv.Columns_Value,'NA') AS CBFCRating, dt.Deal_Type_Name AS TitleType, COUNT(t.Title_Code) AS TitleCount
			FROM Title t (NOLOCK) 
			INNER JOIN Map_Extended_Columns mec (NOLOCK)  ON mec.Record_Code = t.Title_Code AND mec.Columns_Code = 5 AND T.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')))  
			LEFT JOIN Map_Extended_Columns_Details mecd (NOLOCK)  ON mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code
			LEFT JOIN Extended_Columns_Value ecv  (NOLOCK) ON ecv.Columns_Value_Code = mecd.Columns_Value_Code
			INNER JOIN Title_Geners tg  (NOLOCK) ON tg.Title_Code = t.Title_Code
			INNER JOIN Genres g (NOLOCK)  ON g.Genres_Code = tg.Genres_Code
			INNER JOIN Deal_Type dt (NOLOCK)  ON dt.Deal_Type_Code = t.Deal_Type_Code
			INNER JOIN Acq_Deal_Rights_Title adrt (NOLOCK)  ON adrt.Title_Code = t.Title_Code
			INNER JOIN Acq_Deal_Rights adr (NOLOCK)  ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
			INNER JOIN #tempLanguage l ON t.Title_Language_Code = l.Language_Codes
			WHERE GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31Dec9999')
			AND ISNULL(adr.Right_Type, '') <> '' 
			GROUP BY g.Genres_Name, ecv.Columns_Value,dt.Deal_Type_Name
			order by 1

			--Select Distinct G.Genres_Name AS Genre, ISNULL(ecv.Columns_Value,'NA') AS CBFCRating, dt.Deal_Type_Name AS TitleType ,COUNT (ADRT.Title_Code) AS TitleCount
			--from Acq_Deal_Rights ADR WITH(NOLOCK)
			--INNER JOIN Acq_Deal AD WITH(NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))) 
			--INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
			--INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADRT.Title_Code
			--INNER JOIN #tempLanguage l ON t.Title_Language_Code = l.Language_Codes
			--INNER JOIN Title_Geners TG WITH(NOLOCK) ON TG.Title_Code = ADRT.Title_Code
			--INNER JOIN Genres G WITH(NOLOCK) ON G.Genres_Code = TG.Genres_Code
			--LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code AND mec.Columns_Code = 5
			--LEFT JOIN Extended_Columns_Value ecv ON ecv.Columns_Code = mec.Columns_Code
			--INNER JOIN Deal_Type dt ON AD.Deal_Type_Code = dt.Deal_Type_Code
			--WHERE GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31Dec9999')
			--AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
			--GROUP BY G.Genres_Name, ecv.Columns_Value, dt.Deal_Type_Name
			--order by G.Genres_Name

		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
		IF OBJECT_ID('tempdb..#tempFinal') IS NOT NULL DROP TABLE #tempFinal
		IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPITGetDrillDownGenreWiseTitle]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END