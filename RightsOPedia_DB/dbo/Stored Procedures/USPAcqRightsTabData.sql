CREATE PROCEDURE [dbo].[USPAcqRightsTabData]
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@AcqDealCode VARCHAR(1000),
	@TabName NVARCHAR(MAX)	
)
AS
BEGIN
	
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

	--DECLARE
	--@DepartmentCode NVARCHAR(1000) = 7,
	--@BVCode NVARCHAR(1000) = 19,
	--@TitleCode VARCHAR(MAX) = '1688',--'279',
	--@AcqDealCode VARCHAR(1000) = '5752',
	--@TabName NVARCHAR(MAX) = 'Rights Tab'

	CREATE TABLE #TempTitle
	(
		Title_Code INT,
		Deal_Type_Code INT,
		AcqDealMovieCode INT,
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
		AcqDealMovieCode INT,
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
	
	--SELECT * FROM #TempFields

	DECLARE @FieldOrder VARCHAR(3) = 0, 
			@ColumnSequence NVARCHAR(1000) = '', @ColName NVARCHAR(100) = '', @TableColumns VARCHAR(1000) = '', @OutputCounter INT = 0, @OutputCols NVARCHAR(MAX) = ''

	
	INSERT INTO #TempTitle(Title_Code, Title_Name, AcqDealMovieCode, Title_Language, YOR, Duration, Producer, Director, StarCast, Genres, ProgramCategory, CensorDetails, Deal_Type_Code)
	SELECT tm.Title_Code, Title_Name, 0, Title_Language, YOR, CAST(Duration AS INT), Producer, Director, StarCast, Genres, Program_Category, Censor_Details, tm.Deal_Type_Code
	FROM TitleMetadata tm
	INNER JOIN #UITitle tt ON tt.Title_Code = tm.Title_Code
	

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'License Period' AND ValidOpList = 'Rights Tab' )
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

	INSERT INTO #TempRights(TitleCode, AcqDealMovieCode, AcqDealCode, AcqRightsCode, LicensePeriod , Exclusivity, LinearNuances, EpisodesCnt,Remarks,[Sub-Licensing], FormOfExploitation, DealTypeCode, ListOfSubLicensees)	
	SELECT Title_Code, Acq_Deal_Movie_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, LicensePeriod + CAST(Expiring AS NVARCHAR(MAX)), Exclusivity, '', SUM((Episode_To - Episode_From) + 1) EpisodesCnt, a.Remarks, a.Sub_License_Name, '', a.Deal_Type_Code, 'No List of Sub-licensees'
	FROM (	
		SELECT DISTINCT tt.Title_Code, CASE WHEN @BVCode = 21 THEN ISNULL(tr.Acq_Deal_Movie_Code, 0) ELSE 0 END AS Acq_Deal_Movie_Code, tr.Acq_Deal_Code, tr.Acq_Deal_Rights_Code,	
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
				''  LinearNuances, ISNULL(Episode_To, 0) Episode_To, ISNULL(Episode_From, 0) Episode_From --((ISNULL(Episode_To, 0) - ISNULL(Episode_From, 0)) + 1) EpisodesCnt	
				,Remarks, Sub_License_Name, tt.Deal_Type_Code	
		FROM #TempTitle tt	
		LEFT JOIN TitleRights tr ON tr.Title_Code = tt.Title_Code AND ISNULL(tt.AcqDealMovieCode, 0) = CASE WHEN @BVCode = 21 THEN ISNULL(tr.Acq_Deal_Movie_Code, 0) ELSE 0 END	
		WHERE CAST(ISNULL(tr.Actual_Right_End_Date, '31DEC9999') AS DATE) >= CAST(GETDATE() AS DATE)	
		--WHERE GETDATE() BETWEEN tr.Actual_Right_Start_Date AND ISNULL(tr.Actual_Right_End_Date, '31DEC9999')	
	) AS a	
	GROUP BY Title_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, LicensePeriod, Exclusivity, LinearNuances, Acq_Deal_Movie_Code, Remarks,Sub_License_Name, Deal_Type_Code, Expiring

	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Platform' AND ValidOpList = 'Rights Tab' )
	BEGIN
	
		PRINT 'Platform - Start'

		INSERT INTO #TempAcqDealRightsCode
		SELECT DISTINCT AcqRightsCode FROM #TempRights

		INSERT INTO #TempPlatform
		SELECT DISTINCT adrp.acq_deal_rights_code, p.Platform_Hiearachy, count(adrp.Acq_Deal_Rights_Code)
		FROM Acq_Deal_Rights_Platform adrp
		INNER JOIN Platform p on p.Platform_Code = (SELECT TOP 1 Platform_Code FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code)
		GROUP BY adrp.Acq_Deal_Rights_Code, p.Platform_Hiearachy
		HAVING adrp.Acq_Deal_Rights_Code IN (SELECT AcqDealRightsCode FROM #TempAcqDealRightsCode )
		ORDER BY adrp.Acq_Deal_Rights_Code

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

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Territory') AND ValidOpList = 'Rights Tab' )
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
			AcqRightsCode INT,
			Territory_Name NVARCHAR(200)
		)

		INSERT INTO #TempTerritory
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, cn.Country_Name 
		FROM #TempRights tmd
		INNER JOIN AcqRightsTerritory tt ON tmd.AcqRightsCode = tt.Acq_Deal_Rights_Code AND tt.Territory_Type = 'I'
		INNER JOIN Country cn ON tt.Country_Code = cn.Country_Code
		
		INSERT INTO #TempTerritory
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, cn.Territory_Name 
		FROM #TempRights tmd
		INNER JOIN AcqRightsTerritory tt ON tmd.AcqRightsCode = tt.Acq_Deal_Rights_Code AND tt.Territory_Type = 'G'
		INNER JOIN Territory cn ON tt.Territory_Code = cn.Territory_Code
		
		MERGE #TempRights AS T
		USING (
			SELECT --'Language - ' + 
				(STUFF ((
				Select ', ' + tl.Territory_Name 
				FROM  #TempTerritory tl WHERE tl.TitleCode = a.TitleCode AND tl.AcqRightsCode = a.AcqRightsCode
				ORDER BY tl.Territory_Name
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
			) AS Territory_Name, AcqRightsCode, TitleCode
			FROM (
				SELECT DISTINCT TitleCode, AcqRightsCode FROM #TempTerritory
			) a
		) AS S ON s.AcqRightsCode = T.AcqRightsCode 
		WHEN MATCHED THEN
		UPDATE SET T.Territory = S.Territory_Name
		WHEN NOT MATCHED THEN
		INSERT (TitleCode, AcqRightsCode, Territory) VALUES (S.TitleCode, S.AcqRightsCode, S.Territory_Name);

		DROP TABLE #TempTerritory

		PRINT 'Territory - End'

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


	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Sub-Licensing' AND ValidOpList = 'Rights Tab' )
	BEGIN
		
		PRINT 'Sub-Licensing - Start'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Sub-Licensing')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + '[Sub-Licensing]'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		PRINT 'Sub-Licensing - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Subtitling Language', 'Subtitling Rights', 'Subtitling') AND ValidOpList = 'Rights Tab' )
	BEGIN
	
		PRINT 'Subtitling - End'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Subtitling Language', 'Subtitling Rights', 'Subtitling')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'SubtitlingLanguage'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		TRUNCATE TABLE #TempLang
		
		INSERT INTO #TempLang
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, l.Language_Name 
		FROM #TempRights tmd
		INNER JOIN AcqRightsSubtitling tb ON tmd.AcqRightsCode = tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'L'
		INNER JOIN Language l ON tb.Language_Code = l.Language_Code
		
		INSERT INTO #TempLang
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, l.Language_Group_Name 
		FROM #TempRights tmd
		INNER JOIN AcqRightsSubtitling tb ON tmd.AcqRightsCode = tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'G'
		INNER JOIN LanguageGroup l ON tb.Language_Group_Code = l.Language_Group_Code
		
		MERGE #TempRights AS T
		USING (
			SELECT --'Language - ' + 
				(STUFF ((
				Select ', ' + tl.Language_Name 
				FROM  #TempLang tl WHERE tl.TitleCode = a.TitleCode AND tl.AcqRightsCode = a.AcqRightsCode
				ORDER BY tl.Language_Name
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
			) AS SubtitlingLanguage, AcqRightsCode, TitleCode
			FROM (
				SELECT DISTINCT TitleCode, AcqRightsCode FROM #TempLang
			) a
		) AS S ON s.AcqRightsCode = T.AcqRightsCode 
		WHEN MATCHED THEN
		UPDATE SET T.SubtitlingLanguage = S.SubtitlingLanguage
		WHEN NOT MATCHED THEN
		INSERT (TitleCode, AcqRightsCode, SubtitlingLanguage) VALUES (S.TitleCode, S.AcqRightsCode, S.SubtitlingLanguage);

		TRUNCATE TABLE #TempLang
		
		PRINT 'Subtitling - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Dubbing Rights', 'Dubbing Language', 'Dubbing') AND ValidOpList = 'Rights Tab' )
	BEGIN
	
		PRINT 'Dubbing - End'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Dubbing Rights', 'Dubbing Language', 'Dubbing')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'DubbingLanguage'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 1

		TRUNCATE TABLE #TempLang
		
		INSERT INTO #TempLang
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, l.Language_Name 
		FROM #TempRights tmd
		INNER JOIN AcqRightsDubbing tb ON tmd.AcqRightsCode = tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'L'
		INNER JOIN Language l ON tb.Language_Code = l.Language_Code
		
		INSERT INTO #TempLang
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, l.Language_Group_Name 
		FROM #TempRights tmd
		INNER JOIN AcqRightsDubbing tb ON tmd.AcqRightsCode = tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'G'
		INNER JOIN LanguageGroup l ON tb.Language_Group_Code = l.Language_Group_Code
		
		MERGE #TempRights AS T
		USING (
			SELECT --'Language - ' + 
				(STUFF ((
				Select ', ' + tl.Language_Name 
				FROM  #TempLang tl WHERE tl.TitleCode = a.TitleCode AND tl.AcqRightsCode = a.AcqRightsCode
				ORDER BY tl.Language_Name
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
			) AS DubbingLanguage, AcqRightsCode, TitleCode
			FROM (
				SELECT DISTINCT TitleCode, AcqRightsCode FROM #TempLang
			) a
		) AS S ON s.AcqRightsCode = T.AcqRightsCode 
		WHEN MATCHED THEN
		UPDATE SET T.DubbingLanguage = S.DubbingLanguage
		WHEN NOT MATCHED THEN
		INSERT (TitleCode, AcqRightsCode, DubbingLanguage) VALUES (S.TitleCode, S.AcqRightsCode, S.DubbingLanguage);

		TRUNCATE TABLE #TempLang
		
		PRINT 'Dubbing - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Agreement No') AND ValidOpList = 'Rights Tab' )
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
		INNER JOIN RightsU_Plus_testing..Acq_Deal ad ON ad.Acq_Deal_Code = tr.AcqDealCode

		
		PRINT 'Agreement No - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'ROFR - ROFR Type' )
	BEGIN
		
		PRINT 'ROFR - ROFR Type - Start'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('ROFR - ROFR Type')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + '[ROFR - ROFR Type]'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder, GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 2
		
		
		UPDATE a SET a.[ROFR - ROFR Type] = FORMAT(adr.ROFR_Date,'dd-MM-yyyy') +' '+ r.ROFR_Type
		FROM #TempRights a
		INNER JOIN RightsU_Plus_Testing..Acq_Deal_Rights adr ON a.AcqRightsCode = adr.Acq_Deal_Code
		LEFT JOIN RightsU_Plus_Testing..ROFR r ON r.ROFR_Code = adr.ROFR_Code
		--INNER JOIN TitleRights tmd ON a.AcqRightsCode = tmd.Acq_Deal_Rights_Code

		UPDATE #TempRights
		SET [ROFR - ROFR Type] = NULL
		WHERE [ROFR - ROFR Type] = ' ' 

		PRINT 'ROFR - ROFR Type - End'

	END

	DECLARE @CurDisplayName NVARCHAR(100) = '', @CurFieldOrder VARCHAR(5) = '', @AncillaryFields VARCHAR(1000) = ''

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE ViewName = 'AcqDealRightsPromoterGroup' AND ValidOpList = 'Digital Tab')
	BEGIN

		CREATE TABLE #TempPromoterGroupParent
		(
			Promoter_Group_Name VARCHAR(MAX),
			Parent_Group_Code INT
		)
		
		PRINT 'AcqDealRightsPromoterGroup - Start'
		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurFieldOrder = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DisplayName, FieldOrder FROM #TempFields WHERE ViewName = 'AcqDealRightsPromoterGroup'
		OPEN CUR_SaleAncillary
		FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurFieldOrder
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + '[' + @CurDisplayName +']'
			
			IF(@AncillaryFields <> '')
				SET @AncillaryFields = @AncillaryFields + ', '
			SET @AncillaryFields = @AncillaryFields + '[' + @CurDisplayName +']'
			
			SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			INSERT INTO #TempOP(ColValue, KeyField, FieldOrder, GroupOrder)
			SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @CurDisplayName, @CurFieldOrder, 1

			EXEC('ALTER TABLE #TempPromoterGroup ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurFieldOrder
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary
		
		INSERT INTO #TempPromoterGroupParent(Promoter_Group_Name)
		SELECT DisplayName FROM #TempFields

		UPDATE tpgp
		SET tpgp.Parent_Group_Code = pg.Promoter_Group_Code
		FROM #TempPromoterGroupParent tpgp
		INNER JOIN RightsU_Plus_Testing..Promoter_Group pg ON pg.Promoter_Group_Name COLLATE Database_Default = tpgp.Promoter_Group_Name COLLATE Database_Default

		
		
		EXEC('INSERT INTO #TempPromoterGroup(AcqDealRightsCode, ' + @AncillaryFields + ')
		SELECT Acq_Deal_Rights_Code,  ' + @AncillaryFields + '
		FROM (
			SELECT Promoter_Group_Name, tnsa.Acq_Deal_Rights_Code, pr.Promoter_Remark_Desc
			FROM AcqDealRightsPromoterGroup tnsa
			INNER JOIN #TempFields tf ON tnsa.Promoter_Group_Name COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			INNER JOIN RightsU_Plus_Testing..Acq_Deal_Rights_Promoter adrp ON adrp.Acq_Deal_Rights_Code  = tnsa.Acq_Deal_Rights_Code 
			INNER JOIN RightsU_Plus_Testing..Acq_Deal_Rights_Promoter_Remarks adrpr ON adrpr.Acq_Deal_Rights_Promoter_Code  = adrp.Acq_Deal_Rights_Promoter_Code 
			INNER JOIN RightsU_Plus_Testing..Promoter_Remarks pr ON pr.Promoter_Remarks_Code  = adrpr.Promoter_Remarks_Code 
			WHERE ViewName = ''AcqDealRightsPromoterGroup'' AND tnsa.Acq_Deal_Rights_Code IN (
				SELECT AcqRightsCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			MAX(Promoter_Remark_Desc) 
			FOR Promoter_Group_Name IN (' + @AncillaryFields +')
		) AS pivot_table;')

		EXEC('INSERT INTO #TempPromoterGroup(AcqDealRightsCode, ' + @AncillaryFields + ')
		SELECT Acq_Deal_Rights_Code,  ' + @AncillaryFields + '
		FROM (
			SELECT tnsa.Promoter_Group_Name, tnsa.Acq_Deal_Rights_Code, pg.Promoter_Group_Name AS PlatformChild
			FROM AcqDealRightsPromoterGroup tnsa
			INNER JOIN #TempFields tf ON tnsa.Promoter_Group_Name COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			INNER JOIN #TempPromoterGroupParent tpgp ON tpgp.Promoter_Group_Name = tf.DisplayName
			INNER JOIN RightsU_Plus_Testing..Promoter_Group pg ON pg.Parent_Group_Code = tpgp.Parent_Group_Code
			WHERE ViewName = ''AcqDealRightsPromoterGroup'' AND tnsa.Acq_Deal_Rights_Code IN (
				SELECT AcqRightsCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			MAX(PlatformChild) 
			FOR Promoter_Group_Name IN (' + @AncillaryFields +')
		) AS pivot_table;')


		DROP TABLE #TempPromoterGroupParent

		PRINT 'AcqDealRightsPromoterGroup - End'
		
	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Deal Remarks') AND ValidOpList = 'Deal Remarks' )
	BEGIN
	
		PRINT 'Deal Remarks - Start'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Deal Remarks')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Restriction_Remarks'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Restriction Remarks', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Rights_Remarks'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Rights Remarks', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'General_Remarks'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'General Remarks', @FieldOrder, 1

		INSERT INTO #tempDealRemarks
		SELECT adr.Acq_Deal_Rights_Code, adr.Restriction_Remarks, ad.Remarks, ad.Rights_Remarks
		FROM #tempRights tr
		INNER JOIN Acq_Deal_Rights adr ON tr.AcqRightsCode = adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code

		
		PRINT 'Deal Remarks - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Litigation') AND ValidOpList = 'Litigation Tab' )
	BEGIN
	
		PRINT 'Litigation - Start'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Litigation')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LitigationStatus'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Objection Status', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'TypeofObjection'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Type of Objection', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LitigationPeriod'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Objection Period', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LitigationRemarks'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Objection Remarks', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'ResolutionRemarks'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Resolution Remarks', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LitigationPlatform'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Objection Platform', @FieldOrder, 1

		--INSERT INTO #tempDealRemarks
		--SELECT adr.Acq_Deal_Rights_Code, adr.Restriction_Remarks, ad.Remarks, ad.Rights_Remarks
		--FROM #tempRights tr
		--INNER JOIN RightsU_Plus_Testing..Acq_Deal_Rights adr ON tr.AcqRightsCode = adr.Acq_Deal_Rights_Code
		--INNER JOIN RightsU_Plus_Testing..Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code

		INSERT INTO #tempLitigation
		SELECT tr.AcqRightsCode, tr.TitleCode, tos.Objection_Status_Name, tot.Objection_Type_Name, Format(torp.Rights_Start_Date,'dd-MMM-yyyy') + ' to ' + Format(torp.Rights_End_Date,'dd-MMM-yyyy'),
		tobj.Objection_Remarks, tObj.Resolution_Remarks,
		ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(p.platform_name AS VARCHAR(Max))[text()]
		FROM Title_Objection_Platform topl
		INNER JOIN Platform p ON p.Platform_Code = topl.Platform_Code
		WHERE topl.Title_Objection_Code = tObj.Title_Objection_Code
		FOR XML PATH(''), TYPE)
		.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) AS BusinessVertical
		FROM 
		#TempRights tr
		INNER JOIN Title_Objection tObj ON tObj.Title_Code = tr.TitleCode
		INNER JOIN Title_Objection_Status tos ON tos.Title_Objection_Status_Code = tObj.Title_Objection_Status_Code
		INNER JOIN Title_Objection_Type tot ON tot.Objection_Type_Code = tObj.Title_Objection_Type_Code
		INNER JOIN Title_Objection_Rights_Period torp ON torp.Title_Objection_Code = tObj.Title_Objection_Code
		
		
		
		PRINT 'Litigation - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Cost Details') AND ValidOpList = 'Cost Details Tab' )
	BEGIN
	
		PRINT 'Cost Details - Start'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Cost Details')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'AgreementValue'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Agreement Value', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'CostType'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Cost Type', @FieldOrder, 1

		IF(@TableColumns <> '')
		SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'AdditionalExpense'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Additional Expense', @FieldOrder, 1

		IF(@TableColumns <> '')
		SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'StandardReturns'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Standard Returns', @FieldOrder, 1

		IF(@TableColumns <> '')
		SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Overflow'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Overflow', @FieldOrder, 1

		IF(@TableColumns <> '')
		SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'PaymentTerms'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Payment Terms', @FieldOrder, 1

		DECLARE @AgreementValue NVARCHAR(MAX)
		SET @AgreementValue = (
								SELECT A.AgreementValue FROM (
									--SELECT DISTINCT tr.TitleCode, SUM(adc.Deal_Cost) AS AgreementValue
									--FROM 
									--#TempRights tr
									--INNER JOIN Acq_Deal_Cost adc ON adc.Acq_Deal_Code = tr.AcqDealCode
									--INNER JOIN Acq_Deal_Cost_Title adct ON adct.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code AND adct.Title_Code = tr.TitleCode
									--GROUP BY tr.TitleCode
									SELECT SUM(B.AgreementValue) AS AgreementValue FROM (
										SELECT DISTINCT tr.TitleCode, tr.AcqDealCode , adc.Deal_Cost AS AgreementValue
										 FROM 
										 #TempRights tr
										 INNER JOIN Acq_Deal_Cost adc ON adc.Acq_Deal_Code = tr.AcqDealCode
										 INNER JOIN Acq_Deal_Cost_Title adct ON adct.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code AND adct.Title_Code = tr.TitleCode
									)  AS B
									GROUP BY B.TitleCode,B.AcqDealCode
								) AS A
							)
		
		DECLARE @CostType NVARCHAR(MAX)
		--SET @CostType = (
		--					SELECT SUM(A.Consumed_Amount) FROM 
		--					(
		--						Select DISTINCT adc.Acq_Deal_Code,adcct.Cost_Type_Code ,adct.Title_Code , adcct.Consumed_Amount
		--						from #TempRights tr
		--						INNER JOIN RightsU_Plus_Testing..Acq_Deal_Cost adc ON adc.Acq_Deal_Code = tr.AcqDealCode
		--						INNER JOIN RightsU_Plus_Testing..Acq_Deal_Cost_Title adct ON adct.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code AND adct.Title_Code = tr.TitleCode
		--						INNER JOIN RightsU_Plus_Testing..Acq_Deal_Cost_Costtype adcct ON adcct.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
		--						INNER JOIN RightsU_Plus_Testing..Cost_Type ct ON ct.Cost_Type_Code = adcct.Cost_Type_Code
		--					) AS A
		--)

		SELECT @CostType = COALESCE(@CostType+' ~ ' ,'') + A.Valuefield
		FROM (
			Select DISTINCT adc.Acq_Deal_Code, (ct.Cost_Type_Name +' : '+ CAST(adcc.Amount AS VARCHAR) ) AS Valuefield
			from #TempRights tr
			INNER JOIN Acq_Deal_Cost_Title adct ON adct.Title_Code = tr.TitleCode 
			INNER JOIN Acq_Deal_Cost adc ON adc.Acq_Deal_Cost_Code = adct.Acq_Deal_Cost_Code AND adc.Acq_Deal_Code = tr.AcqDealCode
			INNER JOIN Acq_Deal_Cost_Costtype adcc ON adcc.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
			INNER JOIN Cost_Type ct ON adcc.Cost_Type_Code = ct.Cost_Type_Code
			
		)
		AS A
		
		DECLARE @AdditionalExpense NVARCHAR(MAX)
		SET @AdditionalExpense = (
									SELECT SUM(A.Amount) FROM (
									Select DISTINCT adc.Acq_Deal_Code, adct.Title_Code, adcae.Additional_Expense_Code , adcae.Amount
									from #TempRights tr
									INNER JOIN Acq_Deal_Cost_Title adct ON adct.Title_Code = tr.TitleCode 
									INNER JOIN Acq_Deal_Cost adc ON adc.Acq_Deal_Cost_Code = adct.Acq_Deal_Cost_Code AND adc.Acq_Deal_Code = tr.AcqDealCode
									INNER JOIN Acq_Deal_Cost_Additional_Exp adcae ON adcae.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
									) AS A
								)


		DECLARE @StandardReturns VARCHAR(MAX)
		SELECT @StandardReturns = COALESCE(@StandardReturns+' ~ ' ,'') + A.Valuefield
		FROM (
			Select DISTINCT adc.Acq_Deal_Code, (CASE WHEN adcc.Vendor_Code IS NULL ThEN e.Entity_Name ELSE v.Vendor_Name END)  +' : '+ ct.Cost_Type_Name +' : '+ CAST( CAST(adcc.Amount AS DECIMAL(18, 2)) AS VARCHAR) AS Valuefield
			from #TempRights tr
			INNER JOIN Acq_Deal_Cost_Title adct ON adct.Title_Code = tr.TitleCode 
			INNER JOIN Acq_Deal_Cost adc ON adc.Acq_Deal_Cost_Code = adct.Acq_Deal_Cost_Code AND adc.Acq_Deal_Code = tr.AcqDealCode
			INNER JOIN Acq_Deal_Cost_Commission adcc ON adcc.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
			INNER JOIN Cost_Type ct ON adcc.Cost_Type_Code = ct.Cost_Type_Code
			LEFT JOIN Vendor V ON V.Vendor_Code = adcc.Vendor_Code
			LEFT JOIN Entity e on e.Entity_Code = adcc.Entity_Code
		)
		AS A

		DECLARE @Overflow VARCHAR(MAX)
		SELECT @Overflow = (
				Select DISTINCT CASE WHEN adc.Variable_Cost_Type = 'R' THEN 'Revenue Sharing' WHEN adc.Variable_Cost_Type = 'P' THEN 'Profit Sharing' ELSE 'NA' END AS Overflow
				from #TempRights tr
				INNER JOIN Acq_Deal_Cost_Title adct ON adct.Title_Code = tr.TitleCode 
				INNER JOIN Acq_Deal_Cost adc ON adc.Acq_Deal_Cost_Code = adct.Acq_Deal_Cost_Code AND adc.Acq_Deal_Code = tr.AcqDealCode
			)
			
		
		
		DECLARE @PaymentTerms VARCHAR(MAX)
		SELECT @PaymentTerms = COALESCE(@PaymentTerms+' ~ ' ,'') + A.Valuefield
								FROM (
										Select DISTINCT pt.Payment_Terms +' : '+ CAST(adpt.Amount AS VARCHAR) +' : '+  CASE WHEN adpt.Due_Date IS NOT NULL THEN  CONVERT(varchar,ISNULL(adpt.Due_Date,''),3) ELSE 'NA' END AS ValueField
										from Acq_Deal_Payment_Terms adpt
										INNER JOIN Payment_Terms pt ON pt.Payment_Terms_Code = adpt.Payment_Term_Code
										INNER JOIN #TempRights tr ON tr.AcqDealCode = adpt.Acq_Deal_Code
								) AS A
		

		
		INSERT INTO #tempCostDetails
		SELECT @TitleCode, @AcqDealCode, @AgreementValue, @CostType, @AdditionalExpense, @StandardReturns, @Overflow, @PaymentTerms
		
		PRINT 'Cost Details - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('General Info') AND ValidOpList = 'General Info Tab' )
	BEGIN
		IF OBJECT_ID('tempdb..#tempGI') IS NOT NULL DROP TABLE #tempGI
		IF OBJECT_ID('tempdb..#tempGeneralInfoPlatforms') IS NOT NULL DROP TABLE #tempGeneralInfoPlatforms
		IF OBJECT_ID('tempdb..#tempGeneralInfoRegion') IS NOT NULL DROP TABLE #tempGeneralInfoRegion
	
		PRINT 'General Info - Start'
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('General Info')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'RevenueVertical'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Revenue Vertical', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'DealSegment'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Deal Segment', @FieldOrder, 1

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'TheatricalRelease'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder,GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'Theatrical Release', @FieldOrder, 1

		Select DISTINCT tr.AcqDealCode ,tr.TitleCode ,ISNULL(rv.Revenue_Vertical_Name,'') RevenueVertical, ISNULL(ds.Deal_Segment_Name,'') DealSegment
		INTO #tempGI
		FROM #TempRights tr
		--INNER JOIN RightsU_Plus_Testing..Title_Release tRl ON tRl.Title_Code = tr.TitleCode	
		INNER JOIN RightsU_Plus_Testing..Acq_Deal ad on ad.Acq_Deal_Code = tr.AcqDealCode
		LEFT JOIN RightsU_Plus_Testing..Deal_Segment ds ON ds.Deal_Segment_Code = ad.Deal_Segment_Code
		LEFT JOIN RightsU_Plus_Testing..Revenue_Vertical rv ON rv.Revenue_Vertical_Code = ad.Revenue_Vertical_Code

		Select DISTINCT trl.Title_Release_Code, tr.AcqDealCode ,tr.TitleCode ,ISNULL(CONVERT(varchar,trl.Release_Date,3), 'NA') AS ReleaseDate,
		ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(p.Platform_Name AS VARCHAR(Max))[text()]
												 FROM  RightsU_Plus_Testing..Title_Release_Platforms trp
												 INNER JOIN  RightsU_Plus_Testing..Platform p ON p.Platform_Code = trp.Platform_Code
												 WHERE trp.Title_Release_Code = tRl.Title_Release_Code
												 FOR XML PATH(''), TYPE)
												.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) AS Platforms
		INTO #tempGeneralInfoPlatforms
		from #TempRights tr 
		INNER JOIN RightsU_Plus_Testing..Title_Release tRl ON tRl.Title_Code = tr.TitleCode

		Select DISTINCT trl.Title_Release_Code, tr.AcqDealCode, tr.TitleCode ,
		ISNULL(STUFF((SELECT DISTINCT ', ' + CAST((  CASE WHEN c.Country_Name IS NULL THEN t.Territory_Name ELSE c.Country_Name END  )AS VARCHAR(Max))[text()]
												 FROM RightsU_Plus_Testing..Title_Release_Region trp
												 LEFT JOIN RightsU_Plus_Testing..Country c ON c.Country_Code = trp.Country_Code
												 LEFT JOIN RightsU_Plus_Testing..Territory t ON t.Territory_Code = trp.Territory_Code
												 WHERE trp.Title_Release_Code = tRl.Title_Release_Code
												 FOR XML PATH(''), TYPE)
												.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) AS Region
		INTO #tempGeneralInfoRegion
		from #TempRights tr
		INNER JOIN RightsU_Plus_Testing..Title_Release tRl ON tRl.Title_Code = tr.TitleCode
	

		DECLARE @TheatricalRelease VARCHAR(MAX)
		SELECT @TheatricalRelease = COALESCE(@TheatricalRelease+' ~ ' ,'') + A.Valuefield
		FROM (
			Select tgP.ReleaseDate +' : '+ tgP.Platforms +' : '+ R.Region AS ValueField
			from #tempGeneralInfoPlatforms tgP
			INNER JOIN #tempGeneralInfoRegion R on r.Title_Release_Code = tgP.Title_Release_Code
			INNER JOIN #TempRights gi ON gi.TitleCode = tgP.TitleCode 
		) AS A
		

		INSERT INTO #tempGeneralInfo
		SELECT DISTINCT TitleCode, AcqDealCode ,ISNULL(RevenueVertical,'NA') AS RevenueVertical , ISNULL(DealSegment,'NA') AS DealSegment, @TheatricalRelease FROM #tempGI

		PRINT 'General Info - End'

	END
	
	DECLARE @IsRun CHAR(1) = 'N'

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Name of Channels') AND ValidOpList = 'Rights Tab')
	BEGIN
	
		PRINT 'Name of Channels - Start'

		IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Number of Runs'))
		BEGIN
			SET @IsRun = 'Y'
		END
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Name of Channels')
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'ChannelRuns'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder, GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 2

		MERGE #TempRights AS T
		USING (
			SELECT (STUFF ((
				SELECT DISTINCT ', ' + CASE WHEN trun.Run_Type = 'U' THEN trun.Channel_Name + CASE WHEN @IsRun = 'Y' THEN ' (Unlimited)' ELSE '' END ELSE trun.Channel_Name + CASE WHEN @IsRun = 'Y' THEN ' (' + CAST(ISNULL(Min_Runs, 0) AS VARCHAR(10)) + ')' ELSE '' END END 
				FROM  TitleRuns trun WHERE trun.Acq_Deal_Code = a.AcqDealCode AND trun.Title_Code = a.TitleCode
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
			) AS Channels, AcqDealCode, TitleCode
			FROM (
				SELECT DISTINCT AcqDealCode, TitleCode FROM #TempRights
			) a
		) AS S ON s.AcqDealCode = T.AcqDealCode AND s.TitleCode = T.TitleCode
		WHEN MATCHED THEN
		UPDATE SET T.ChannelRuns = S.Channels;

		--SELECT * FROM TitleRuns #TempRights

		PRINT 'Name of Channels - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Number of Runs') AND ValidOpList = 'Rights Tab')
	BEGIN
	
		PRINT 'Number of Runs - Start'

		IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Number of Runs'))
		BEGIN
			SET @IsRun = 'Y'
		END
		
		SELECT TOP 1 @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Number of Runs')
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'NoOfRuns'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder, GroupOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @ColName, @FieldOrder, 2

		MERGE #TempRights AS T
		USING (
			SELECT (
				SELECT DISTINCT No_Of_Runs
				FROM  TitleRuns trun WHERE trun.Acq_Deal_Code = a.AcqDealCode AND trun.Title_Code = a.TitleCode
			) AS NoOfRuns, AcqDealCode, TitleCode
			FROM (
				SELECT DISTINCT AcqDealCode, TitleCode FROM #TempRights
			) a
		) AS S ON s.AcqDealCode = T.AcqDealCode AND s.TitleCode = T.TitleCode
		WHEN MATCHED THEN
		UPDATE SET T.NoOfRuns = S.NoOfRuns;

		--SELECT * FROM #TempRights

		PRINT 'Name of Channels - End'

	END	
	
	DECLARE @OutputSQL NVARCHAR(MAX) = ''
	SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code, ' + @OutputCols + ')
	SELECT DISTINCT AcqRightsCode, ' + @TableColumns + '
	FROM #TempTitle tt
	INNER JOIN #TempRights tr ON CASE WHEN tt.Deal_Type_Code = 27 THEN tt.AcqDealMovieCode ELSE tt.Title_Code END = CASE WHEN tt.Deal_Type_Code = 27 THEN tr.AcqDealMovieCode ELSE tr.TitleCode END AND tr.AcqDealCode = ' + @AcqDealCode +'
	LEFT JOIN #TempPromoterGroup tpg ON tpg.AcqDealRightsCode = tr.AcqRightsCode
	LEFT JOIN #tempDealRemarks tdr ON tdr.AcqDealRightsCode = tr.AcqRightsCode
	LEFT JOIN #TempPlatform tp ON tp.AcqDealRightsCode = tr.AcqRightsCode 
	LEFT JOIN #TempLitigation tl ON tl.AcqDealRightsCode = tr.AcqRightsCode 
	LEFT JOIN #tempCostDetails tcd ON tcd.TitleCode = tr.TitleCode
	LEFT JOIN #tempGeneralInfo tgi ON tgi.TitleCode = tr.TitleCode
	'
	
	--SELECT @OutputSQL
	--RETURN
	EXEC(@OutputSQL)

	--SET @OutputCounter = 0;

	--UPDATE #TempOutput 
	--SET Title_Code = @OutputCounter, @OutputCounter = @OutputCounter + 1


	SELECT GroupOrder, Title_Code AS TitleCode , KeyField, ValueFields AS ValueField, FieldOrder FROM (
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