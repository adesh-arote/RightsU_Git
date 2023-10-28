


CREATE PROCEDURE [dbo].[USPDashboardI](@BUCode INT, @UsersCode INT, @DBNum NVARCHAR(MAX),@DashboardType VARCHAR(20),@Language NVARCHAR(50))
AS
--DECLARE
--@BUCode INT = 0, @UsersCode INT = 143, @DBNum NVARCHAR(MAX) = 'DB1,DB2,DB3,DB4',@DashboardType VARCHAR(20) = 'Movies',@Language NVARCHAR(50) = 'ALL'
BEGIN
	IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard
	IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
	IF OBJECT_ID('tempdb..#tpmTitleLinearDealType') IS NOT NULL DROP TABLE #tpmTitleLinearDealType
	IF OBJECT_ID('tempdb..#tmpLanguageTitleCode') IS NOT NULL DROP TABLE #tmpLanguageTitleCode

	DECLARE
	@LanguageNames NVARCHAR(MAX)

	SET @LanguageNames = (Select Parameter_Value from SystemParameterNew where Parameter_Name = 'DBLanguageNames_IT')

	DECLARE @LinearCode NVARCHAR(MAX)
	DECLARE @NonLinearCode NVARCHAR(MAX)

	SET @LinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] where Attrib_Group_Name = 'Linear')
	SET @NonLinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] where Attrib_Group_Name = 'Non-Linear')

	CREATE TABLE #TempDashboard
	(
		DBNum VARCHAR(10),
		Field1 NVARCHAR(100),
		Field2 NVARCHAR(100),
		Field3 NVARCHAR(100),
	)

	
	CREATE TABLE #TempBU
	(
		BUCode INT
	)

	CREATE TABLE #tempLanguage(
	Language_Codes INT
	)

	CREATE TABLE #tempLanguageWithOthers(
	Language_Codes INT,
	Language_Name Varchar(500)
	)

	CREATE TABLE #LinearRightCode(
		RightsCode INT
	)

	INSERT INTO #LinearRightCode(RightsCode)
	SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
	FROM Acq_Deal_Rights_Platform ADRP
	INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
	WHERE pag.Attrib_Group_Code IN (@LinearCode,@NonLinearCode)


	IF(@Language = 'ALL')
		BEGIN
			INSERT INTO #tempLanguage
			SELECT Language_Code FROM [Language] With (NOLOCK)

			INSERT INTO #tempLanguageWithOthers
			SELECT Language_Code,Language_Name FROM [Language] With (NOLOCK) WHERE Language_Name COLLATE DATABASE_DEFAULT 
							     IN (SELECT number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
            UNION ALL
			SELECT Language_Code,'Others' FROM [Language] With (NOLOCK) WHERE Language_Name COLLATE DATABASE_DEFAULT 
							NOT IN (SELECT number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))

		END
	ELSE IF(@Language = 'Others')
		BEGIN
			INSERT INTO #tempLanguage
			SELECT Language_Code  FROM [Language] With (NOLOCK) WHERE Language_Name COLLATE DATABASE_DEFAULT 
							NOT IN (SELECT number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))

			Insert Into #tempLanguageWithOthers
			Select Language_Codes,'Others' From #tempLanguage
		END
	ELSE
		BEGIN
			INSERT INTO #tempLanguage
			SELECT Language_Code FROM Language where Language_Name = ''+@Language+''

			Insert Into #tempLanguageWithOthers
			SELECT Language_Code,Language_Name FROM [Language] With (NOLOCK) WHERE Language_Name = ''+@Language+''

		END

	INSERT INTO #TempBU(BUCode)
	SELECT DISTINCT agbu.Business_Unit_Code FROM AttribGroupBU agbu  With (NOLOCK)
	INNER JOIN UsersBU ubu  With (NOLOCK) ON agbu.Business_Unit_Code = ubu.Business_Unit_Code
	WHERE agbu.Attrib_Group_Code IN (Select Distinct BU_Code from UsersBusinessUnit  With (NOLOCK) where Users_Code = @UsersCode) --@BUCode 
	AND ubu.Users_Code = @USersCode


	DECLARE @Deal_Type_Code NVARCHAR(100)

	IF(@DashboardType = 'Movies')
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from SystemParameterNew  With (NOLOCK) where Parameter_Name = 'DashboardType_Movie_IT' )
		END
	ELSE IF(@DashboardType = 'Program')
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from SystemParameterNew  With (NOLOCK) where Parameter_Name = 'DashboardType_Prog_IT' )
		END
	ELSE
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from SystemParameterNew  With (NOLOCK) where Parameter_Name = 'DashboardType_Web_IT' )
		END

	DECLARE @ActiveAssets INT = 0, @TotalAssets FLOAT = 0, @TotalAcqDeal INT = 0, @TotalSynDeal INT,@ActiveAssetsSyn INT

	DECLARE @tblDealType AS TABLE
	(
		Deal_Type_Code INT
	)

	INSERT INTO @tblDealType
	select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')

	CREATE TABLE #tpmTitleLinearDealType
	(
		Title_Code INT,
		Actual_Right_Start_Date DATETIME,
		Actual_Right_End_Date DATETIME,
		Is_Sub_License VARCHAR(10)
	)

	CREATE TABLE #tmpLanguageTitleCode
	(
		Title_Code INT
	)

	INSERT INTO #tpmTitleLinearDealType
	SELECT DISTINCT tr.Title_Code, tr.Actual_Right_Start_Date, tr.Actual_Right_End_Date, tr.Is_Sub_License
	FROM TitleLinearDealType tr
	INNER JOIN @tblDealType dt ON dt.Deal_Type_Code = tr.Deal_Type_Code
	INNER JOIN #LinearRightCode lrc ON lrc.RightsCode = tr.Acq_Deal_Rights_Code
	--WHERE tr.Deal_Type_Code IN (SELECT Deal_Type_Code FROM @tblDealType) AND
	--tr.Acq_Deal_Rights_Code IN (SELECT RightsCode FROM #LinearRightCode)

	INSERT INTO #tmpLanguageTitleCode
	SELECT DISTINCT t.Title_Code FROM Title t
	WHERE t.Title_Language_Code IN (SELECT Language_Codes FROM #tempLanguage)

	SELECT @ActiveAssets =  COUNT(DISTINCT CAST(ttldt.TItle_Code AS VARCHAR(10))) --+ '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
	FROM #tpmTitleLinearDealType ttldt  With (NOLOCK)
	WHERE --Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND 
	GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') AND ttldt.Title_Code IN (SELECT Title_Code FROM #tmpLanguageTitleCode)

	--SELECT @ActiveAssets =  COUNT(DISTINCT CAST(tr.TItle_Code AS VARCHAR(10))) --+ '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
	--FROM TitleRights tr  With (NOLOCK)
	--INNER JOIN @tblDealType dt ON dt.Deal_Type_Code = tr.Deal_Type_Code
	--INNER JOIN Title t  With (NOLOCK) on t.Title_Code = tr.Title_Code
	--INNER JOIN #tempLanguage tl ON tl.Language_Codes = t.Title_Language_Code
	--INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
	--WHERE --Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND 
	--GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
	----AND tr.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')) 
	
	SELECT @ActiveAssetsSyn =  COUNT(DISTINCT CAST(ttldt.TItle_Code AS VARCHAR(10))) --+ '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
	FROM #tpmTitleLinearDealType ttldt  With (NOLOCK)
	WHERE --Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND 
	ttldt.Is_Sub_License = 'Y' AND 
	GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') AND ttldt.Title_Code IN (SELECT Title_Code FROM #tmpLanguageTitleCode)

	--SELECT @ActiveAssetsSyn =  COUNT(DISTINCT CAST(tr.TItle_Code AS VARCHAR(10))) --+ '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
	--FROM TitleRights tr  With (NOLOCK)
	--INNER JOIN @tblDealType dt ON dt.Deal_Type_Code = tr.Deal_Type_Code
	--INNER JOIN Title t  With (NOLOCK) on t.Title_Code = tr.Title_Code
	--INNER JOIN #tempLanguage tl ON tl.Language_Codes = t.Title_Language_Code
	--INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
	--WHERE --Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND 
	--tr.Is_Sub_License = 'Y' AND 
	--GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
	----AND tr.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')) 

	
	--SELECT @TotalAssets =  COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
	--FROM TitleRights WHERE GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') --Business_Unit_Code IN (SELECT BUCode FROM #TempBU)

	--SELECT @TotalAcqDeal = COUNT(DISTINCT Acq_Deal_Code) FROM TitleRights WHERE Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')

	SELECT @TotalSynDeal = COUNT(DISTINCT tr.TItle_Code) 
	FROM TitleSynRights tr  With (NOLOCK)
	WHERE GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
	AND tr.Deal_Type_Code IN (select Deal_Type_Code from @tblDealType) AND tr.Title_Code IN (SELECT Title_Code FROM #tmpLanguageTitleCode)

	--SELECT GETDATE()
	--SELECT @TotalSynDeal = COUNT(DISTINCT tr.TItle_Code) 
	--FROM TitleSynRights tr  With (NOLOCK)
	--INNER JOIN Title t  With (NOLOCK) on t.Title_Code = tr.Title_Code
	--INNER JOIN #tempLanguage tl ON tl.Language_Codes = t.Title_Language_Code
	--WHERE 
	--GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
	--AND tr.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')) 

	DECLARE @FNYearED DATE, @FNYearSD DATE, @Year INT, @YearEndDate DATE, @YearStartDate DATE = '01-' + DATENAME(MONTH, GETDATE()) + '-' +  DATENAME(YEAR,GETDATE())
			SET @YearEndDate = DATEADD(DAY, -1, DATEADD(YEAR, 1, @YearStartDate))
			SET @Year = DATEPART(YY, GETDATE())

			IF(DATEPART(MM, GETDATE()) > 3)
			BEGIN

			SET @Year = @Year + 1

			END

			SET @FNYearSD = '01-APR-' + CAST(@Year AS VARCHAR(5))
			SET @FNYearED = DATEADD(DAY, -1, DATEADD(YEAR, 1, @FNYearSD))


	IF(@DBNum = 'DB1,DB2,DB3,DB4')
		BEGIN
			PRINT 'DB1'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2)
			SELECT 'DB1' AS DBNum, 'ACTIVE ACQUIRED ASSETS' AS KeyField, @ActiveAssets AS ValueField
			UNION
			SELECT 'DB2' AS DBNum, 'INVENTORY SHARE', CASE WHEN @TotalAssets = 0 THEN 0 ELSE (@ActiveAssets / @TotalAssets) * 100 END --@TotalAssets
			UNION
			SELECT 'DB3' AS DBNum, 'ACTIVE ACQUISITIONS', @TotalAcqDeal
			UNION
			SELECT 'DB4' AS DBNum, 'ACTIVE SYNDICATIONS', @TotalSynDeal
			UNION
			SELECT 'SYN' AS DBNum, ' TOTAL ACTIVE SYNDICATIONS', @ActiveAssetsSyn
		END
	ELSE
	IF(@DBNum = 'DB5')
		BEGIN
			PRINT 'DB5'
			--SELECT @YearStartDate, @YearEndDate
			PRINT 'DB 5'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2, Field3)
			SELECT 'DB5', t2.Language_Name, RIGHT(CAST(DATEPART(YY, Actual_Right_End_Date) AS VARCHAR(10)), 2) + RIGHT('0' + CAST(DATEPART(MM, Actual_Right_End_Date) AS VARCHAR(10)), 2) + '_' + UPPER(LEFT(DATENAME(MONTH, Actual_Right_End_Date), 3)) + '-' + RIGHT(CAST(DATEPART(YY, Actual_Right_End_Date) AS VARCHAR(10)), 2) STRDATE, 
			COUNT(DISTINCT CAST(tr.TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TitleLinearDealType tr  With (NOLOCK)
			INNER JOIN Title T  With (NOLOCK) on T.Title_Code = tr.Title_Code
			INNER JOIN Language L  With (NOLOCK)  ON L.Language_Code = T.Title_Language_Code
			INNER JOIN #tempLanguage tl ON tl.Language_Codes = T.Title_Language_Code
			INNER JOIN #tempLanguageWithOthers t2  ON t2.Language_Codes = T.Title_Language_Code
			INNER JOIN BusinessUnit bu  With (NOLOCK) ON tr.Business_Unit_Code = bu.Business_Unit_Code --AND bu.Business_Unit_Name IN ('Hindi Movies', 'English Movies', 'Regional', 'Hindi Content', 'Digital', 'Sports')
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE ISNULL(Actual_Right_End_Date, '31DEC9999') BETWEEN @YearStartDate AND @YearEndDate 
			AND tr.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')) 
			GROUP BY t2.Language_Name, DATENAME(MONTH, Actual_Right_End_Date), DATEPART(YY, Actual_Right_End_Date), DATEPART(MM, Actual_Right_End_Date)
			ORDER BY 1, 2
		END
	ELSE IF(@DBNum = 'DB6')
		BEGIN
			PRINT 'DB6'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2, Field3)
			SELECT 'DB6', 'Deal Expiry Stats', 'FY ' + CAST(RIGHT(DATEPART(YY, @FNYearSD), 2) AS VARCHAR(5)) + '-' + CAST(RIGHT(DATEPART(YY, @FNYearED), 2) AS VARCHAR(5)), COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TitleRights tr  With (NOLOCK)
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE Business_Unit_Code IN (1, 2, 3, 4, 8, 9) AND ISNULL(Actual_Right_End_Date, '31DEC9999') BETWEEN @FNYearSD AND @FNYearED
			UNION
			SELECT 'DB6', 'Deal Expiry Stats', '90 Days', COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TitleRights tr  With (NOLOCK)
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE Business_Unit_Code IN (1, 2, 3, 4, 8, 9) AND ISNULL(Actual_Right_End_Date, '31DEC9999') BETWEEN DATEADD(DAY, 61, GETDATE()) AND  DATEADD(DAY, 90, GETDATE())
			UNION
			SELECT 'DB6', 'Deal Expiry Stats', '60 Days', COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TitleRights tr  With (NOLOCK)
			WHERE Business_Unit_Code IN (1, 2, 3, 4, 8, 9) AND ISNULL(Actual_Right_End_Date, '31DEC9999') BETWEEN DATEADD(DAY, 31, GETDATE()) AND  DATEADD(DAY, 60, GETDATE())
			UNION
			SELECT 'DB6', 'Deal Expiry Stats', '30 Days', COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TitleRights tr  With (NOLOCK)
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE Business_Unit_Code IN (1, 2, 3, 4, 8, 9) AND ISNULL(Actual_Right_End_Date, '31DEC9999') BETWEEN DATEADD(DAY, 0, GETDATE()) AND  DATEADD(DAY, 30, GETDATE())

			--SELECT COUNT(*) FROM TitleRights WHERE Business_Unit_Code IN (SELECT BUCode FROM #TempBU)
		END
	ELSE IF(@DBNum = 'DB7')
		BEGIN
			PRINT 'DB7'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2)
			SELECT 'DB7', bu.Business_Unit_Name, COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TitleRights tr  With (NOLOCK)
			INNER JOIN BusinessUnit bu  With (NOLOCK) ON tr.Business_Unit_Code = bu.Business_Unit_Code AND bu.Business_Unit_Code IN (1, 2, 3, 4, 8, 9)
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
			GROUP BY bu.Business_Unit_Name
		END
	ELSE IF(@DBNum = 'DB8')
		BEGIN
			PRINT 'DB8'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2)
			SELECT 'DB8', 'Acquisition Title Count', COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10)))
			FROM TitleRights tr With (NOLOCK) 
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE Is_Sub_License = 'Y' AND Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
			UNION
			SELECT 'DB8', 'Syndication Title Count', COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TitleSynRights  With (NOLOCK) WHERE Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
		END
	ELSE IF(@DBNum = 'DB9')
		BEGIN
			PRINT 'DB9'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2)
			SELECT 'DB9', p.Platform_Hiearachy, COUNT(DISTINCT tr.Title_Code) FROM TItlePlatform tp  With (NOLOCK)
			INNER JOIN TitleRights tr  With (NOLOCK) ON tr.Acq_Deal_Rights_Code = tp.Acq_Deal_Rights_Code AND Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
			RIGHT JOIN Platform p  With (NOLOCK) ON tp.Platform_Code = p.Platform_Code --AND p.Platform_Code IN (21, 34, 47, 48)
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE p.Platform_Code IN (21, 34, 47, 48)
			GROUP BY p.Platform_Hiearachy
		END
	ELSE IF(@DBNum = 'DB10')
		BEGIN
			PRINT 'DB10'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2)
			SELECT 'DB10', p.Platform_Hiearachy, COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10))) 
			FROM TItleSynPlatform tp  With (NOLOCK)
			INNER JOIN TitleSynRights tr  With (NOLOCK) ON tr.Syn_Deal_Rights_Code = tp.Syn_Deal_Rights_Code AND Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
			RIGHT JOIN Platform p  With (NOLOCK) ON tp.Platform_Code = p.Platform_Code
			WHERE p.Platform_Code IN (21, 34, 47, 48)
			GROUP BY p.Platform_Hiearachy
		END
	ELSE IF(@DBNum = 'DB12')
		BEGIN
			PRINT 'DB12'
			INSERT INTO #TempDashboard(DBNum, Field1, Field2, Field3)
			SELECT 'DB12', 'Acquisition', t.Territory_Name, COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10)))
			FROM TitleTerritory tt 
			INNER JOIN TitleRights tr  With (NOLOCK) ON tr.Acq_Deal_Rights_Code = tt.Acq_Deal_Rights_Code AND Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') --@BUCode
			INNER JOIN Territory t  With (NOLOCK) ON tt.Territory_Code = t.Territory_Code
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE tt.Territory_Code IN (3, 42, 22)
			GROUP BY t.Territory_Name
			UNION
			SELECT 'DB12', 'Acquisition', c.Country_Name, COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10)))
			FROM TitleTerritory tt With (NOLOCK)
			INNER JOIN TitleRights tr  With (NOLOCK) ON tr.Acq_Deal_Rights_Code = tt.Acq_Deal_Rights_Code AND Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') --@BUCode
			INNER JOIN Country c  With (NOLOCK) ON tt.Country_Code = c.Country_Code
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
			WHERE tt.Country_Code IN (3)
			GROUP BY c.Country_Name
			UNION
			SELECT 'DB12', 'Syndication', t.Territory_Name, COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10)))
			FROM TitleSynTerritory tt With (NOLOCK)
			INNER JOIN TitleSynRights tr  With (NOLOCK) ON tr.Syn_Deal_Rights_Code = tt.Syn_Deal_Rights_Code AND Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') --@BUCode
			INNER JOIN Territory t  With (NOLOCK) ON tt.Territory_Code = t.Territory_Code
			WHERE tt.Territory_Code IN (3, 42, 22)
			GROUP BY t.Territory_Name
			UNION
			SELECT 'DB12', 'Syndication', c.Country_Name, COUNT(DISTINCT CAST(TItle_Code AS VARCHAR(10)) + '-' + CAST(Episode_From AS VARCHAR(10)) + '-' + CAST(Episode_To AS VARCHAR(10)))
			FROM TitleSynTerritory tt With (NOLOCK)
			INNER JOIN TitleSynRights tr  With (NOLOCK) ON tr.Syn_Deal_Rights_Code = tt.Syn_Deal_Rights_Code AND Business_Unit_Code IN (SELECT BUCode FROM #TempBU) AND GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') --@BUCode
			INNER JOIN Country c  With (NOLOCK) ON tt.Country_Code = c.Country_Code
			WHERE tt.Country_Code IN (3)
			GROUP BY c.Country_Name
		END
	--SELECT * FROM BusinessUnit WHERE Business_Unit_Name IN('Hindi Movies', 'Hindi Contents', 'Sports', 'English Movies')
	--SELECT @FNYearED, @FNYearSD


	PRINT 'DB: '+@DBNum
	SELECT * FROM #TempDashboard --WHERE DBNum IN (select number from dbo.fn_Split_withdelemiter(''+@DBNum+'',','))
	
	IF OBJECT_ID('tempdb..#tpmTitleLinearDealType') IS NOT NULL DROP TABLE #tpmTitleLinearDealType
	IF OBJECT_ID('tempdb..#tmpLanguageTitleCode') IS NOT NULL DROP TABLE #tmpLanguageTitleCode

	DROP TABLE #TempDashboard
	DROP TABLE #TempBU
	DROP TABLE #tempLanguage
	Drop Table #tempLanguageWithOthers

END



--SELECT * FROM [TitleTerritory] tt

--3

--World, ' India ', ' Indian Subcontinent ', ' MENA '
--EXEC [USPDashboardI] 1,1280,'DB1,DB2,DB3,DB4'

--EXEC USPDashboardI 0,167,'DB5','Movies','ALL'
