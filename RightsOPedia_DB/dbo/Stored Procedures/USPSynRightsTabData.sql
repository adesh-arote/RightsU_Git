CREATE PROCEDURE [dbo].[USPSynRightsTabData]
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@AcqDealCode VARCHAR(1000),
	@TabName NVARCHAR(MAX)	
)
AS
BEGIN

	--DECLARE
	--@DepartmentCode NVARCHAR(1000) = 7,
	--@BVCode NVARCHAR(1000) = 19,
	--@TitleCode VARCHAR(MAX) = 20803,
	--@AcqDealCode VARCHAR(1000) = 9767,
	--@TabName NVARCHAR(MAX) = 'Syndication Rights Tab'	
	
	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
	IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#UITitle') IS NOT NULL DROP TABLE #UITitle
	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempRights') IS NOT NULL DROP TABLE #TempRights
	IF OBJECT_ID('tempdb..#TempLang') IS NOT NULL DROP TABLE #TempLang
	IF OBJECT_ID('tempdb..#TempPromoterGroup') IS NOT NULL DROP TABLE #TempPromoterGroup
	IF OBJECT_ID('tempdb..#tempDealRemarks') IS NOT NULL DROP TABLE #tempDealRemarks
	IF OBJECT_ID('tempdb..#TempAcqDealRightsCode') IS NOT NULL DROP TABLE #TempAcqDealRightsCode
	IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform
	IF OBJECT_ID('tempdb..#TempLitigation') IS NOT NULL DROP TABLE #TempLitigation
	IF OBJECT_ID('tempdb..#tempGeneralInfo') IS NOT NULL DROP TABLE #tempGeneralInfo
	IF OBJECT_ID('tempdb..#tempCostDetails') IS NOT NULL DROP TABLE #tempCostDetails
	IF OBJECT_ID('tempdb..#TempTerritory') IS NOT NULL DROP TABLE #TempTerritory

	CREATE TABLE #TempTitle
	(
		Title_Code INT,
		Deal_Type_Code INT,
		SynDealMovieCode INT,
		Title_Name NVARCHAR(1000),
		Title_Language NVARCHAR(1000),
		YOR NVARCHAR(1000),
		Duration NVARCHAR(20),
		Producer NVARCHAR(1000),
		Director NVARCHAR(1000),
		StarCast NVARCHAR(1000),
		Genres NVARCHAR(MAX),
		ProgramCategory NVARCHAR(100),
		CensorDetails NVARCHAR(100),
		LastTelecastDate NVARCHAR(30),
		LastTelecastChannel NVARCHAR(50),
		NextTelecastDate NVARCHAR(30),
		NextTelecastChannel NVARCHAR(50)
	)

	CREATE TABLE #UITitle
	(
		Title_Code INT
	)

	CREATE TABLE #TempFields(
		ViewName VARCHAR(100),
		DisplayName VARCHAR(100),
		FieldOrder INT,
		ValidOpList VARCHAR(100)
	)

	CREATE TABLE #TempOP
	(
		ColValue NVARCHAR(100),
		KeyField NVARCHAR(100),
		FieldOrder INT,
		GroupOrder INT
	)

	CREATE TABLE #TempOutput
	(
		Title_Code INT,
		COL1 NVARCHAR(MAX),
		COL2 NVARCHAR(MAX),
		COL3 NVARCHAR(MAX),
		COL4 NVARCHAR(MAX),
		COL5 NVARCHAR(MAX),
		COL6 NVARCHAR(MAX),
		COL7 NVARCHAR(MAX),	
		COL8 NVARCHAR(MAX),
		COL9 NVARCHAR(MAX),
		COL10 NVARCHAR(MAX),
		COL11 NVARCHAR(MAX),
		COL12 NVARCHAR(MAX),
		COL13 NVARCHAR(MAX),
		COL14 NVARCHAR(MAX),
		COL15 NVARCHAR(MAX)
	)
	
	CREATE TABLE #TempRights
	(
		TitleCode INT,
		SynDealMovieCode INT,
		AcqDealCode INT,
		AcqRightsCode INT,
		Licensor NVARCHAR(1000),
		LinearNuances NVARCHAR(10),
		EpisodesCnt INT,
		LicensePeriod NVARCHAR(100),
		Exclusivity NVARCHAR(100),
		MediaPlatforms NVARCHAR(MAX),
		ExploitationPlatforms NVARCHAR(MAX),
		Territory NVARCHAR(MAX),
		DubbingLanguage NVARCHAR(MAX),
		SubtitlingLanguage NVARCHAR(MAX),
		ChannelRuns NVARCHAR(MAX),
		Remarks NVARCHAR(MAX),
		[Sub-Licensing] NVARCHAR(100),
		FormOfExploitation NVARCHAR(100),
		NoOfRuns INT,
		ListOfSubLicensees NVARCHAR(MAX) DEFAULT '',
		DealTypeCode INT,
		[ROFR - ROFR Type] NVARCHAR(MAX) DEFAULT '',
		AgreementNo NVARCHAR(MAX)
	)

	CREATE TABLE #TempLang
	(
		TitleCode INT,
		AcqRightsCode INT,
		Language_Name NVARCHAR(200)
	)

	CREATE TABLE #TempPromoterGroup
	(
		AcqDealRightsCode INT
	)

	CREATE TABLE #TempAcqDealRightsCode
	(
		AcqDealRightsCode INT
	)

	CREATE TABLE #TempPlatform
	(
		AcqDealRightsCode INT,
		Platform_Name NVARCHAR(MAX),
		Cnt INT
	)


	CREATE TABLE #tempDealRemarks
	(
		AcqDealRightsCode INT,
		Restriction_Remarks VARCHAR(MAX),
		Rights_Remarks VARCHAR(MAX),
		General_Remarks VARCHAR(MAX)
	)

	CREATE TABLE #tempLitigation
	(
		AcqDealRightsCode INT,
		TitleCode INT,
		LitigationStatus VARCHAR(MAX),
		TypeofObjection VARCHAR(MAX),
		LitigationPeriod VARCHAR(MAX),
		LitigationRemarks VARCHAR(MAX),
		ResolutionRemarks VARCHAR(MAX),
		LitigationPlatform VARCHAR(MAX)

	)

	CREATE TABLE #tempCostDetails
	(
		TitleCode INT,
		AcqDealCode INT,
		AgreementValue  VARCHAR(MAX),
		CostType  VARCHAR(MAX),
		AdditionalExpense  VARCHAR(MAX), 
		StandardReturns  VARCHAR(MAX),
		Overflow  VARCHAR(MAX),
		PaymentTerms  VARCHAR(MAX)
	)

	CREATE TABLE #tempGeneralInfo
	(
		TitleCode INT,
		AcqDealCode INT,
		RevenueVertical NVARCHAR(MAX),
		DealSegment NVARCHAR(MAX),
		TheatricalRelease NVARCHAR(MAX)
	)	

	INSERT INTO #UITitle(Title_Code)
	SELECT number from dbo.[UFNSplit](@TitleCode, ',') WHERE number IS NOT NULL

	

	INSERT INTO #TempFields(ViewName, DisplayName, FieldOrder, ValidOpList)
	SELECT View_Name, Display_Name, Display_Order, ValidOpList FROM Report_Setup WHERE Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode AND IsPartofSelectOnly IN ('Y', 'B') AND ValidOpList = @TabName

	INSERT INTO #TempTitle(Title_Code, Title_Name, SynDealMovieCode, Title_Language, YOR, Duration, Producer, Director, StarCast, Genres, ProgramCategory, CensorDetails, Deal_Type_Code)
	SELECT tm.Title_Code, Title_Name, 0, Title_Language, YOR, CAST(Duration AS INT), Producer, Director, StarCast, Genres, Program_Category, Censor_Details, tm.Deal_Type_Code
	FROM TitleMetadata tm
	INNER JOIN #UITitle tt ON tt.Title_Code = tm.Title_Code

	
	
	INSERT INTO #TempRights(TitleCode, SynDealMovieCode, AcqDealCode, AcqRightsCode, LicensePeriod , Exclusivity, LinearNuances, EpisodesCnt, FormOfExploitation, DealTypeCode, ListOfSubLicensees)	
	SELECT Title_Code, Syn_Deal_Movie_Code, Syn_Deal_Code, Syn_Deal_Rights_Code, LicensePeriod + CAST(Expiring AS NVARCHAR(MAX)), Exclusivity, '', SUM((Episode_To - Episode_From) + 1) EpisodesCnt, '', a.Deal_Type_Code, 'No List of Sub-licensees'
	FROM (	
		SELECT DISTINCT tt.Title_Code, 0 AS  Syn_Deal_Movie_Code, tr.Syn_Deal_Code, tr.Syn_Deal_Rights_Code,	
				CASE WHEN (tr.Actual_Right_End_Date IS NULL AND tr.Actual_Right_Start_Date IS NOT NULL) THEN 'Perpetuity from '+  REPLACE(CONVERT(VARCHAR(20), tr.Actual_Right_Start_Date, 106), ' ', '-')   
					WHEN tr.Right_Type = 'M' AND tr.Actual_Right_End_Date IS NULL THEN 'LP has not started since TC QC is Pending' 	
					ELSE UPPER(REPLACE(CONVERT(VARCHAR(20), tr.Actual_Right_Start_Date, 106), ' ', '-')  + ' TO ' + REPLACE(CONVERT(VARCHAR(20), tr.Actual_Right_End_Date, 106), ' ', '-')) 	
				END AS LicensePeriod,
				(CASE WHEN (tr.Actual_Right_End_Date < GETDATE() AND tr.Actual_Right_End_Date IS NOT NULL) THEN 'EXPIRED' 
						WHEN (DATEDIFF(day, GETDATE() ,tr.Actual_Right_End_Date) < 30 ) THEN ' ~ (Expiring in ' + CAST(( DATEDIFF(day,GETDATE(), CAST(tr.Actual_Right_End_Date AS int))) AS NVARCHAR(MAX)) + ' days)'
						ELSE ''
						END
				) AS Expiring,
				CASE WHEN tr.Is_Exclusive = 'Y' THEN 'Exclusive'	
					WHEN tr.Is_Exclusive = 'N' THEN 'Non-Exclusive'	
					ELSE 'Co-Exclusive'	
				END Exclusivity, 	
				''  LinearNuances, ISNULL(Episode_To, 0) Episode_To, ISNULL(Episode_From, 0) Episode_From, --((ISNULL(Episode_To, 0) - ISNULL(Episode_From, 0)) + 1) EpisodesCnt	
				tt.Deal_Type_Code	
		FROM #TempTitle tt	
		LEFT JOIN TitleSynRights tr ON tr.Title_Code = tt.Title_Code --AND ISNULL(tt.SynDealMovieCode, 0) = CASE WHEN @BVCode = 21 THEN ISNULL(tr.Acq_Deal_Movie_Code, 0) ELSE 0 END	
		WHERE CAST(ISNULL(tr.Actual_Right_End_Date, '31DEC9999') AS DATE) >= CAST(GETDATE() AS DATE)	
		--WHERE GETDATE() BETWEEN tr.Actual_Right_Start_Date AND ISNULL(tr.Actual_Right_End_Date, '31DEC9999')	
	) AS a	
	GROUP BY Title_Code, Syn_Deal_Code, Syn_Deal_Rights_Code, LicensePeriod, Exclusivity, LinearNuances, Syn_Deal_Movie_Code, Deal_Type_Code, Expiring

	DECLARE @FieldOrder VARCHAR(3) = 0, 
			@ColumnSequence NVARCHAR(1000) = '', @ColName NVARCHAR(100) = '', @TableColumns VARCHAR(1000) = '', @OutputCounter INT = 0, @OutputCols NVARCHAR(MAX) = ''
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'License Period' AND ValidOpList = 'Syndication Rights Tab' )
	BEGIN
	
		PRINT 'License Period - Start'

		SELECT TOP 1  @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'License Period'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LicensePeriod'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		PRINT 'License Period - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Agreement No') AND ValidOpList = 'Syndication Rights Tab' )
	BEGIN
	
		PRINT 'Agreement No - End'

		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Agreement No')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'AgreementNo'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		UPDATE tr SET tr.AgreementNo = ad.Agreement_No
		FROM #tempRights tr
		INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = tr.AcqDealCode

		
		PRINT 'Agreement No - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Exclusivity' AND ValidOpList = 'Rights Tab' )
	BEGIN
	
		PRINT 'Exclusivity - Start'

		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Exclusivity'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Exclusivity'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		PRINT 'Exclusivity - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Territory') AND ValidOpList = 'Syndication Rights Tab' )
	BEGIN
	
		PRINT 'Territory - Start'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Territory')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Territory'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		CREATE TABLE #TempTerritory
		(
			TitleCode INT,
			SynRightsCode INT,
			Territory_Name NVARCHAR(200)
		)

		INSERT INTO #TempTerritory
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, cn.Country_Name 
		FROM #TempRights tmd
		INNER JOIN SynRightsTerritory tt ON tmd.AcqRightsCode = tt.Syn_Deal_Rights_Code AND tt.Territory_Type = 'I'
		INNER JOIN Country cn ON tt.Country_Code = cn.Country_Code
		
		INSERT INTO #TempTerritory
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, cn.Territory_Name 
		FROM #TempRights tmd
		INNER JOIN SynRightsTerritory tt ON tmd.AcqRightsCode = tt.Syn_Deal_Rights_Code AND tt.Territory_Type = 'G'
		INNER JOIN Territory cn ON tt.Territory_Code = cn.Territory_Code
		
		MERGE #TempRights AS T
		USING (
			SELECT --'Language - ' + 
				(STUFF ((
				Select ', ' + tl.Territory_Name 
				FROM  #TempTerritory tl WHERE tl.TitleCode = a.TitleCode AND tl.SynRightsCode = a.SynRightsCode
				ORDER BY tl.Territory_Name
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
			) AS Territory_Name, SynRightsCode, TitleCode
			FROM (
				SELECT DISTINCT TitleCode, SynRightsCode FROM #TempTerritory
			) a
		) AS S ON s.SynRightsCode = T.AcqRightsCode 
		WHEN MATCHED THEN
		UPDATE SET T.Territory = S.Territory_Name
		WHEN NOT MATCHED THEN
		INSERT (TitleCode, AcqRightsCode, Territory) VALUES (S.TitleCode, S.SynRightsCode, S.Territory_Name);

		DROP TABLE #TempTerritory

		PRINT 'Territory - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Platform' AND ValidOpList = 'Syndication Rights Tab' )
	BEGIN
	
		PRINT 'Platform - Start'

		INSERT INTO #TempAcqDealRightsCode
		SELECT DISTINCT AcqRightsCode FROM #TempRights

		INSERT INTO #TempPlatform
		SELECT DISTINCT adrp.Syn_Deal_Rights_Code, p.Platform_Hiearachy, count(adrp.Syn_Deal_Rights_Code)
		FROM Syn_Deal_Rights_Platform adrp
		INNER JOIN Platform p on p.Platform_Code = (SELECT TOP 1 Platform_Code FROM Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code)
		GROUP BY adrp.Syn_Deal_Rights_Code, p.Platform_Hiearachy
		HAVING adrp.Syn_Deal_Rights_Code IN (SELECT AcqDealRightsCode FROM #TempAcqDealRightsCode )
		ORDER BY adrp.Syn_Deal_Rights_Code

		UPDATE #TempPlatform
		SET Platform_Name = ISNULL(Platform_Name, '') + '|' + CAST(Cnt AS VARCHAR(16))

		

		SELECT TOP 1  @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Platform'
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Platform_Name'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		PRINT 'Platform - End'

	END

	--IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Platform' AND ValidOpList = 'Syndication Rights Tab' )
	--BEGIN
	
	--	PRINT 'Platform - Start'

	--	INSERT INTO #TempAcqDealRightsCode
	--	SELECT DISTINCT AcqRightsCode FROM #TempRights

	--	INSERT INTO #TempPlatform
	--	SELECT DISTINCT adrp.Syn_Deal_Rights_Code, p.Platform_Hiearachy, count(adrp.Syn_Deal_Rights_Code)
	--	FROM Syn_Deal_Rights_Platform adrp
	--	INNER JOIN Platform p on p.Platform_Code = (SELECT TOP 1 Platform_Code FROM Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code)
	--	GROUP BY adrp.Syn_Deal_Rights_Code, p.Platform_Hiearachy
	--	HAVING adrp.Syn_Deal_Rights_Code IN (SELECT AcqDealRightsCode FROM #TempAcqDealRightsCode )
	--	ORDER BY adrp.Syn_Deal_Rights_Code

	--	UPDATE #TempPlatform
	--	SET Platform_Name = ISNULL(Platform_Name, '') + '|' + CAST(Cnt AS VARCHAR(16))

		

	--	SELECT TOP 1  @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Platform'
		
	--	IF(@TableColumns <> '')
	--		SET @TableColumns = @TableColumns + ', '
	--	SET @TableColumns = @TableColumns + 'Platform_Name'
		
	--	SET @OutputCounter = @OutputCounter + 1
	--	IF(@OutputCols <> '')
	--		SET @OutputCols = @OutputCols + ', '
	--	SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
	--	INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
	--	SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

	--	PRINT 'Platform - End'

	--END	

	DECLARE @OutputSQL NVARCHAR(MAX) = ''
	SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code, ' + @OutputCols + ')
	SELECT DISTINCT AcqRightsCode, ' + @TableColumns + '
	FROM #TempTitle tt
	INNER JOIN #TempRights tr ON tr.TitleCode = tt.Title_Code
	LEFT JOIN #TempPlatform tp ON tp.AcqDealRightsCode = tr.AcqRightsCode 
	'

	--INNER JOIN #TempRights tr ON CASE WHEN tt.Deal_Type_Code = 27 THEN tt.SynDealMovieCode ELSE tt.Title_Code END = CASE WHEN tt.Deal_Type_Code = 27 THEN tr.SynDealMovieCode ELSE tr.TitleCode END AND tr.AcqDealCode = ' + @AcqDealCode +'
	
	--SELECT @OutputSQL
	--RETURN
	EXEC(@OutputSQL)

	SELECT DISTINCT GroupOrder, Title_Code AS TitleCode , KeyField, ValueFields AS ValueField, FieldOrder FROM (
		SELECT u.Title_Code, u.ColValues, u.ValueFields  FROM (
			SELECT Title_Code, 
			ISNULL(COL1, 'No') AS COL1, ISNULL(COL2, 'No') AS COL2, ISNULL(COL3, 'No') AS COL3, ISNULL(COL4, 'No') AS COL4, ISNULL(COL5, 'No') AS COL5, 	
			ISNULL(COL6, 'No') AS COL6, ISNULL(COL7, 'No') AS COL7, ISNULL(COL8, 'No') AS COL8, ISNULL(COL9, 'No') AS COL9, ISNULL(COL10, 'No') AS COL10, 	
			ISNULL(COL11, 'No') AS COL11, ISNULL(COL12, 'No') AS COL12, ISNULL(COL13, 'No') AS COL13, ISNULL(COL14, 'No') AS COL14, ISNULL(COL15, 'No') AS COL15
			FROM #TempOutput
			) AS s
			UNPIVOT 
			(
				ValueFields
				FOR ColValues IN (
					COL1, COL2, COL3, COL4, COL5, 
					COL6, COL7, COL8, COL9, COL10, 
					COL11, COL12, COL13, COL14, COL15
				)
			) AS u
		) AS unpout
	INNER JOIN #TempOP op ON unpout.ColValues COLLATE Database_Default = op.ColValue COLLATE Database_Default
	ORDER BY Title_Code, FieldOrder
	

	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
	IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#UITitle') IS NOT NULL DROP TABLE #UITitle
	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempRights') IS NOT NULL DROP TABLE #TempRights
	IF OBJECT_ID('tempdb..#TempLang') IS NOT NULL DROP TABLE #TempLang
	IF OBJECT_ID('tempdb..#TempPromoterGroup') IS NOT NULL DROP TABLE #TempPromoterGroup
	IF OBJECT_ID('tempdb..#tempDealRemarks') IS NOT NULL DROP TABLE #tempDealRemarks
	IF OBJECT_ID('tempdb..#TempAcqDealRightsCode') IS NOT NULL DROP TABLE #TempAcqDealRightsCode
	IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform
	IF OBJECT_ID('tempdb..#TempLitigation') IS NOT NULL DROP TABLE #TempLitigation
	IF OBJECT_ID('tempdb..#tempGeneralInfo') IS NOT NULL DROP TABLE #tempGeneralInfo
	IF OBJECT_ID('tempdb..#tempCostDetails') IS NOT NULL DROP TABLE #tempCostDetails
END