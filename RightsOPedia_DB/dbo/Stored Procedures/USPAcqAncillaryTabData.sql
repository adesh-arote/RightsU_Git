CREATE PROCEDURE USPAcqAncillaryTabData
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@AcqDealCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
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
	IF OBJECT_ID('tempdb..#TempAncillaryType') IS NOT NULL DROP TABLE #TempAncillaryType
	IF OBJECT_ID('tempdb..#TempAncillaryPlatform') IS NOT NULL DROP TABLE #TempAncillaryPlatform

	--DECLARE
	--@DepartmentCode NVARCHAR(1000) = 7,
	--@BVCode NVARCHAR(1000) = 19,
	--@TitleCode VARCHAR(MAX) = '279',
	--@TabName NVARCHAR(MAX) = ''

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
		AcqDealRightsCode INT,
		AncillaryTypeCode INT,
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
		ListOfSubLicensees NVARCHAR(MAX) DEFAULT '',
		DealTypeCode INT,
		[ROFR - ROFR Type] NVARCHAR(MAX) DEFAULT ''
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

	CREATE TABLE #TempAncillaryType
	(
		TitleCode INT,
		AncillaryTypeCode INT
	)

	CREATE TABLE #TempAncillaryPlatform
	(
		AcqDealRightsCode INT
	)

	INSERT INTO #UITitle(Title_Code)
	SELECT number from dbo.[UFNSplit](@TitleCode, ',') WHERE number IS NOT NULL

	INSERT INTO #TempFields(ViewName, DisplayName, FieldOrder, ValidOpList)
	SELECT View_Name, Display_Name, Display_Order, ValidOpList FROM Report_Setup WHERE Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode AND IsPartofSelectOnly IN ('Y', 'B') --AND ValidOpList = @TabName
	
	--SELECT * FROM #TempFields

	DECLARE @FieldOrder VARCHAR(3) = 0, 
			@ColumnSequence NVARCHAR(1000) = '', @ColName NVARCHAR(100) = '', @TableColumns VARCHAR(1000) = '', @OutputCounter INT = 0, @OutputCols NVARCHAR(MAX) = ''

	
	INSERT INTO #TempTitle(Title_Code, Title_Name, AcqDealMovieCode, Title_Language, YOR, Duration, Producer, Director, StarCast, Genres, ProgramCategory, CensorDetails, Deal_Type_Code)
	SELECT tm.Title_Code, Title_Name, 0, Title_Language, YOR, CAST(Duration AS INT), Producer, Director, StarCast, Genres, Program_Category, Censor_Details, tm.Deal_Type_Code
	FROM TitleMetadata tm
	INNER JOIN #UITitle tt ON tt.Title_Code = tm.Title_Code


	


	INSERT INTO #TempRights(TitleCode, AcqDealMovieCode, AcqDealCode, AcqRightsCode, LicensePeriod, Exclusivity, LinearNuances, EpisodesCnt,Remarks,[Sub-Licensing], FormOfExploitation, DealTypeCode, ListOfSubLicensees)	
	SELECT Title_Code, Acq_Deal_Movie_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, LicensePeriod, Exclusivity, '', SUM((Episode_To - Episode_From) + 1) EpisodesCnt, a.Remarks, a.Sub_License_Name, '', a.Deal_Type_Code, 'No List of Sub-licensees'	
	FROM (	
		SELECT DISTINCT tt.Title_Code, CASE WHEN @BVCode = 21 THEN ISNULL(tr.Acq_Deal_Movie_Code, 0) ELSE 0 END AS Acq_Deal_Movie_Code, tr.Acq_Deal_Code, tr.Acq_Deal_Rights_Code,	
				CASE WHEN tr.Right_Type = 'M' AND tr.Actual_Right_End_Date IS NULL THEN 'LP has not started since TC QC is Pending' 	
					ELSE UPPER(REPLACE(CONVERT(VARCHAR(20), tr.Actual_Right_Start_Date, 106), ' ', '-')  + ' TO ' + REPLACE(CONVERT(VARCHAR(20), tr.Actual_Right_End_Date, 106), ' ', '-')) 	
				END AS LicensePeriod,	
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
	GROUP BY Title_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, LicensePeriod, Exclusivity, LinearNuances, Acq_Deal_Movie_Code, Remarks,Sub_License_Name, Deal_Type_Code
	
	DECLARE @CurDisplayName NVARCHAR(100) = '', @CurFieldOrder VARCHAR(5) = '', @AncillaryFields VARCHAR(1000) = ''

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE ViewName = 'AncillaryPlatform')
	BEGIN
	
		PRINT 'AncillaryPlatform - Start'
		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurFieldOrder = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DisplayName, FieldOrder FROM #TempFields WHERE ViewName = 'AncillaryPlatform'
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

			EXEC('ALTER TABLE #TempAncillaryPlatform ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurFieldOrder
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary
		

		EXEC('INSERT INTO #TempAncillaryPlatform(AcqDealRightsCode, ' + @AncillaryFields + ')
		SELECT Acq_Deal_Rights_Code,  ' + @AncillaryFields + '
		FROM (
			SELECT Platform_Name, tnsa.Acq_Deal_Rights_Code, Platform_Code 
			FROM AncillaryPlatform tnsa
			INNER JOIN #TempFields tf ON tnsa.Platform_Name COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			WHERE ViewName = ''AncillaryPlatform'' AND tnsa.Acq_Deal_Rights_Code IN (
				SELECT AcqRightsCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			COUNT(Platform_Code) 
			FOR Platform_Name IN (' + @AncillaryFields +')
		) AS pivot_table;')

		PRINT 'AncillaryPlatform - End'
		
	END
	
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE ViewName = 'Ancillary_Type')
	BEGIN
	
		PRINT 'Ancillary_Type - Start'
		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurFieldOrder = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DisplayName, FieldOrder FROM #TempFields WHERE ViewName = 'Ancillary_Type'
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

			EXEC('ALTER TABLE #TempAncillaryType ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurFieldOrder
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary

		   
		
		
		EXEC('INSERT INTO #TempAncillaryType(TitleCode, AncillaryTypeCode,' + @AncillaryFields + ')
		SELECT Title_Code, Ancillary_Type_Code, ' + @AncillaryFields + '
		FROM (
			SELECT tnsa.Title_Code, Ancillary_Type_Code, AncillaryValue, Ancillary_Type_Name 
			FROM Ancillary_Type tnsa
			INNER JOIN #TempFields tf ON tnsa.Ancillary_Type_Name COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			WHERE ViewName = ''Ancillary_Type'' AND tnsa.Title_Code IN (
				SELECT TitleCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			COUNT(AncillaryValue) 
			FOR Ancillary_Type_Name IN (' + @AncillaryFields +')
		) AS pivot_table;')

		PRINT 'Ancillary_Type - End'
		
	END

	

	DECLARE @OutputSQL NVARCHAR(MAX) = ''
	SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code, AcqDealRightsCode, AncillaryTypeCode, ' + @OutputCols + ')
	SELECT DISTINCT tt.Title_Code, tr.AcqRightsCode, tat.AncillaryTypeCode, ' + @TableColumns + '
	FROM #TempTitle tt
	INNER JOIN #TempRights tr ON CASE WHEN tt.Deal_Type_Code = 27 THEN tt.AcqDealMovieCode ELSE tt.Title_Code END = CASE WHEN tt.Deal_Type_Code = 27 THEN tr.AcqDealMovieCode ELSE tr.TitleCode END AND tr.AcqDealCode = ' + @AcqDealCode +'
	LEFT JOIN #TempPromoterGroup tpg ON tpg.AcqDealRightsCode = tr.AcqRightsCode
	LEFT JOIN #TempAncillaryType tat ON tat.TitleCode = tt.Title_Code
	LEFT JOIN #TempAncillaryPlatform tap ON tap.AcqDealRightsCode = tr.AcqRightsCode'
	
	EXEC(@OutputSQL)


	SELECT DISTINCT GroupOrder, Title_Code AS TitleCode , KeyField,
		CASE	
			WHEN KeyField IN ('Right to create/Use Promos/Clips','Catch up Rights') AND ISNULL(ValueFields,'0') <> '0' THEN CONCAT('Available ', ISNULL(AncillaryValue, ''))
			WHEN KeyField IN ('Promotional Clip Rights', 'Merchandising Rights', 'Right to use Images and Artworks', 'Advertising and Sponsorship Rights',
								'Right to use CAC','Offline Viewing') AND ISNULL(ValueFields,'0') <> '0' THEN 'Available'
			WHEN KeyField IN ('Promotional Clip Rights', 'Merchandising Rights', 'Right to use Images and Artworks', 'Advertising and Sponsorship Rights',
								'Right to create/Use Promos/Clips','Right to use CAC') AND ISNULL(ValueFields,'0') = '0' THEN 'Not Available'
			ELSE ValueFields 
		END AS ValueField, FieldOrder FROM (
		SELECT u.Title_Code, AncillaryValue, u.ColValues, u.ValueFields  FROM (
			SELECT tpo.Title_Code, AncillaryValue,
			ISNULL(COL1, 'No') AS COL1, ISNULL(COL2, 'No') AS COL2, ISNULL(COL3, 'No') AS COL3, ISNULL(COL4, 'No') AS COL4, ISNULL(COL5, 'No') AS COL5, 	
			ISNULL(COL6, 'No') AS COL6, ISNULL(COL7, 'No') AS COL7, ISNULL(COL8, 'No') AS COL8, ISNULL(COL9, 'No') AS COL9, ISNULL(COL10, 'No') AS COL10, 	
			ISNULL(COL11, 'No') AS COL11, ISNULL(COL12, 'No') AS COL12, ISNULL(COL13, 'No') AS COL13, ISNULL(COL14, 'No') AS COL14, ISNULL(COL15, 'No') AS COL15
			FROM #TempOutput tpo
			INNER JOIN RightsU_Plus_Testing..Acq_deal_Rights adr ON adr.Acq_Deal_Rights_Code = tpo.AcqDealRightsCode 
			INNER JOIN RightsU_Plus_Testing..Acq_Deal_Ancillary ada ON ada.Acq_Deal_Code  = adr.Acq_Deal_Code 
			LEFT JOIN Ancillary_Type ata ON ata.Title_Code = tpo.Title_Code AND ata.Ancillary_Type_Code = tpo.AncillaryTypeCode
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
	IF OBJECT_ID('tempdb..#TempAncillaryType') IS NOT NULL DROP TABLE #TempAncillaryType
	IF OBJECT_ID('tempdb..#TempAncillaryPlatform') IS NOT NULL DROP TABLE #TempAncillaryPlatform

END