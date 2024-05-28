CREATE PROCEDURE [dbo].[USPReportOutput]
(
	@UsersCode INT,
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@Country NVARCHAR(1000),
	@DubbingLanguage NVARCHAR(1000),
	@Genre NVARCHAR(1000),
	@LicensePeriod NVARCHAR(1000),
	@Licensor NVARCHAR(1000),
	@Platform NVARCHAR(1000),
	@StarCast NVARCHAR(1000),
	@SubtitlingLanguage NVARCHAR(1000),
	@Territory NVARCHAR(1000),
	@TitleLanguage NVARCHAR(1000)
)
AS
BEGIN

	--SELECT * FROM Title WHERE Title_Name LIKE '%kabir%'

	--DECLARE @UsersCode INT,
	--@DepartmentCode NVARCHAR(1000) = 35,
	--@BVCode NVARCHAR(1000) = 19,
	--@TitleCode VARCHAR(MAX) = '269',
	--@Country NVARCHAR(1000),
	--@DubbingLanguage NVARCHAR(1000),
	--@Genre NVARCHAR(1000),
	--@LicensePeriod NVARCHAR(1000),
	--@Licensor NVARCHAR(1000),
	--@Platform NVARCHAR(1000),
	--@StarCast NVARCHAR(1000),
	--@SubtitlingLanguage NVARCHAR(1000),
	--@Territory NVARCHAR(1000),
	--@TitleLanguage NVARCHAR(1000)

	IF OBJECT_ID('tempdb..#TempLang') IS NOT NULL DROP TABLE #TempLang
	IF OBJECT_ID('tempdb..#TempSubLang') IS NOT NULL DROP TABLE #TempSubLang
	IF OBJECT_ID('tempdb..#TempPlatforms') IS NOT NULL DROP TABLE #TempPlatforms
	IF OBJECT_ID('tempdb..#TempTerritory') IS NOT NULL DROP TABLE #TempTerritory
	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#UITitle') IS NOT NULL DROP TABLE #UITitle
	IF OBJECT_ID('tempdb..#TempRights') IS NOT NULL DROP TABLE #TempRights
	IF OBJECT_ID('tempdb..#TempNSAncillary') IS NOT NULL DROP TABLE #TempNSAncillary
	IF OBJECT_ID('tempdb..#TempSaleAncillary') IS NOT NULL DROP TABLE #TempSaleAncillary
	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP
	IF OBJECT_ID('tempdb..#TempAncillaryPlatform') IS NOT NULL DROP TABLE #TempAncillaryPlatform
	IF OBJECT_ID('tempdb..#TempAncillaryType') IS NOT NULL DROP TABLE #TempAncillaryType
	IF OBJECT_ID('tempdb..#TempPromoterGroup') IS NOT NULL DROP TABLE #TempPromoterGroup
	

	CREATE TABLE #TempOutput
	(
		ColumnGroup INT,
		TitleName NVARCHAR(1000),
		AcqDealCode INT,
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
		COL15 NVARCHAR(MAX),
		COL16 NVARCHAR(MAX),
		COL17 NVARCHAR(MAX),
		COL18 NVARCHAR(MAX),
		COL19 NVARCHAR(MAX),
		COL20 NVARCHAR(MAX),
		COL21 NVARCHAR(MAX),
		COL22 NVARCHAR(MAX),
		COL23 NVARCHAR(MAX),
		COL24 NVARCHAR(MAX),
		COL25 NVARCHAR(MAX),
		COL26 NVARCHAR(MAX),
		COL27 NVARCHAR(MAX),
		COL28 NVARCHAR(MAX),
		COL29 NVARCHAR(MAX),
		COL30 NVARCHAR(MAX),
		IsEmpty AS COALESCE(COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20, COL21, COL22, COL23, COL24, COL25, COL26, COL27, COL28, COL29, COL30)
	)

	CREATE TABLE #TempFields(
		ViewName VARCHAR(100),
		DisplayName VARCHAR(100),
		GroupOrder INT,
		FieldOrder INT
	)
	
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

	CREATE TABLE #UITitle
	(
		Title_Code INT
	)
	
	CREATE TABLE #TempLang
	(
		TitleCode INT,
		AcqRightsCode INT,
		Language_Name NVARCHAR(200)
	)
	
	CREATE TABLE #TempNSAncillary
	(
		TitleCode INT,
		AcqDealCode INT,
	)
	
	CREATE TABLE #TempSaleAncillary
	(
		TitleCode INT,
		AcqDealCode INT,
	)

	CREATE TABLE #TempAncillaryPlatform
	(
		AcqDealRightsCode INT
	)
	
	CREATE TABLE #TempAncillaryType
	(
		AcqDealRightsCode INT
	)

	CREATE TABLE #TempPromoterGroup
	(
		AcqDealRightsCode INT
	)

	CREATE TABLE #TempOP
	(
		ColValue NVARCHAR(100),
		GroupDetails NVARCHAR(100),
		GroupOrder INT,
		KeyField NVARCHAR(100),
		FieldOrder INT,
		ParentKeyField NVARCHAR(MAX)
	)

	--TitleName, GroupDetails, KeyField, ValueField, FieldOrder
	--TitleCode, GroupOrder,

	INSERT INTO #UITitle(Title_Code)
	SELECT number from dbo.[UFNSplit](@TitleCode, ',') WHERE number IS NOT NULL

	INSERT INTO #TempFields(ViewName, DisplayName, GroupOrder, FieldOrder)
	SELECT View_Name, Display_Name, Output_Group, Display_Order FROM Report_Setup WHERE Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode AND IsPartofSelectOnly IN ('Y', 'B')

	IF(@BVCode = 21)
	BEGIN

		INSERT INTO #TempTitle(Title_Code, Title_Name, AcqDealMovieCode, Deal_Type_Code)
		SELECT DISTINCT tr.Title_Code,p.TextField, st.Acq_Deal_Movie_Code, 27--,tr.Acq_Deal_Code 
		FROM #UITitle uit
		INNER JOIN SportTour st ON st.Program_Code = uit.Title_Code
		INNER JOIN TitleRights tr ON tr.Acq_Deal_Movie_Code = st.Acq_Deal_Movie_Code
		INNER JOIN Program p On p.ValueField = st.Program_Code
		--INNER JOIN #UITitle uit ON uit.Title_Code = tr.Title_Code

	END
	ELSE
	BEGIN
		INSERT INTO #TempTitle(Title_Code, Title_Name, AcqDealMovieCode, Title_Language, YOR, Duration, Producer, Director, StarCast, Genres, ProgramCategory, CensorDetails, Deal_Type_Code)
		SELECT tm.Title_Code, Title_Name, 0, Title_Language, YOR, CAST(Duration AS INT), Producer, Director, StarCast, Genres, Program_Category, Censor_Details, tm.Deal_Type_Code
		FROM TitleMetadata tm
		INNER JOIN #UITitle tt ON tt.Title_Code = tm.Title_Code
	END
	
	DECLARE @GroupOrder INT = 0, @FieldOrder VARCHAR(3) = 0, @GroupDetail VARCHAR(10) = '', @ColumnGroup NVARCHAR(1000) = '', @ColumnName NVARCHAR(1000) = '', 
			@ColumnSequence NVARCHAR(1000) = '', @ColName NVARCHAR(100) = '', @TableColumns VARCHAR(1000) = '', @OutputCounter INT = 0, @OutputCols NVARCHAR(MAX) = ''

	--SELECT 'ad', * FROM #TempFields

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Meta-data')
	BEGIN
	
		PRINT 'META-DATA - Start'

		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Meta-data'
		
		DECLARE @TitleCodeNew INT,@IsProgram CHAR(2) = 'N',@DealTypeForProg_SysParam NVARCHAR(100),@DealTypeCode INT 
		SET @TitleCodeNew = (Select TOP 1 Title_Code FROM #UITitle)
		SET @DealTypeCode =  (Select Deal_Type_Code FROM Title where Title_Code = @TitleCodeNew)
		SET @DealTypeForProg_SysParam = (Select Parameter_Value FROM SystemParameterNew WHERE Parameter_Name = 'DashboardType_Prog_IT')

		IF EXISTS ( SELECT number from dbo.fn_Split_withdelemiter(''+@DealTypeForProg_SysParam+'',',') WHERE number = @DealTypeCode)
			SET @IsProgram = 'Y'
		
		IF(@IsProgram = 'Y')
		BEGIN

			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL1', @GroupDetail, 'Title Language', 1
			UNION
			SELECT 'COL2', @GroupDetail, 'YOR', 2
			UNION
			SELECT 'COL2', @GroupDetail, 'Duration', 2
			UNION
			SELECT 'COL3', @GroupDetail, 'Producer', 3
			UNION
			SELECT 'COL4', @GroupDetail, 'Director', 4
			UNION
			SELECT 'COL5', @GroupDetail, 'Genres', 5

			SET @OutputCols = 'COL1, COL2, COL3, COL4, COL5'
			SET @OutputCounter = 6
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Title_Language, Duration, YOR, Director, Genres'

		END
		ELSE
		BEGIN

			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL1', @GroupDetail, 'Title Language', 1
			UNION
			SELECT 'COL2', @GroupDetail, 'YOR', 2
			UNION
			SELECT 'COL3', @GroupDetail, 'Duration', 3
			--UNION
			--SELECT 'COL3', @GroupDetail, 'Producer', 3
			--UNION
			--SELECT 'COL4', @GroupDetail, 'Director', 4
			UNION
			SELECT 'COL4', @GroupDetail, 'Star Cast', 4
			UNION
			SELECT 'COL5', @GroupDetail, 'Genres', 5

			SET @OutputCols = 'COL1, COL2, COL3, COL4, COL5'
			SET @OutputCounter = 6
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Title_Language, YOR, Duration, [StarCast], Genres'
		END

		--SET @TableColumns = @TableColumns + 'Title_Language, YOR, Duration, Producer, Director, StarCast, Genres'
		
		UPDATE #TempFields SET FieldOrder = FieldOrder + 6
		DELETE FROM #TempFields WHERE DisplayName = 'Meta-data'
		
		
		PRINT 'META-DATA - END'

	END
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Date of Last Telecast')
	BEGIN
	
		PRINT 'Date on Last Telecast - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Date of Last Telecast'
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LastTelecastDate'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		UPDATE a SET a.LastTelecastDate = UPPER(REPLACE(CONVERT(VARCHAR(20), CAST(Schedule_Item_Log_Date AS DATE), 106), ' ', '-')) + ' ' +Schedule_Item_Log_Time
		FROM #TempTitle a
		INNER JOIN TitleSchedule tmd ON a.Title_Code = tmd.Title_Code
		WHERE CAST(tmd.Schedule_Item_Log_Date AS date) <= GETDATE()
		
		PRINT 'Date on Last Telecast - End'

	END
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Channel on Last Telecast')
	BEGIN
	
		PRINT 'Channel on Last Telecast - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Channel on Last Telecast'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LastTelecastChannel'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		UPDATE a
		SET a.LastTelecastChannel = tmd.Channel_Name
		FROM #TempTitle a
		INNER JOIN TitleSchedule tmd ON a.Title_Code = tmd.Title_Code
		WHERE CAST(tmd.Schedule_Item_Log_Date AS date) <= GETDATE()
		
		PRINT 'Channel on Last Telecast - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Date of Next Telecast')
	BEGIN
	
		PRINT 'Date of Next Telecast - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Date of Next Telecast'
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'NextTelecastDate'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		UPDATE a SET a.NextTelecastDate = UPPER(REPLACE(CONVERT(VARCHAR(20), CAST(Schedule_Item_Log_Date AS DATE), 106), ' ', '-')) + ' ' +Schedule_Item_Log_Time
		FROM #TempTitle a
		INNER JOIN TitleSchedule tmd ON a.Title_Code = tmd.Title_Code
		WHERE CAST(tmd.Schedule_Item_Log_Date AS date) > GETDATE()
		
		
		PRINT 'Date of Next Telecast - End'

	END
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Channel on Next Telecast')
	BEGIN
	
		PRINT 'Channel on Next Telecast - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Channel on Next Telecast'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'NextTelecastChannel'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		UPDATE a
		SET a.NextTelecastChannel = tmd.Channel_Name
		FROM #TempTitle a
		INNER JOIN TitleSchedule tmd ON a.Title_Code = tmd.Title_Code
		WHERE CAST(tmd.Schedule_Item_Log_Date AS date) > GETDATE()
		
		PRINT 'Channel on Next Telecast - End'

	END

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
	print ' step 1'	
	SELECT @GroupDetail = '', @GroupOrder = 0, @FieldOrder = 0, @ColName = ''

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Deal Remarks')
	BEGIN
	
		PRINT 'General Remarks - Start'

		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Deal Remarks'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Remarks'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		
		PRINT 'General Remarks - End'

		--SELECT * FROM #TempRights
	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Form Of Exploitation')
	BEGIN
		PRINT 'FormOfExploitation - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Form Of Exploitation')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + '[FormOfExploitation]'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder
		
		UPDATE tr SET tr.FormOfExploitation =  CASE WHEN ISNULL(Cnt,0) > 0 THEN 'Clips - Yes' ELSE 'Clips - No' END FROM
		(
			Select tr.AcqRightsCode, COUNT(adrs.Platform_Code) Cnt
			from #TempRights tr
			INNER JOIN Acq_Deal_Rights_Sport adrs ON adrs.Acq_Deal_Rights_Code = tr.AcqRightsCode
			INNER JOIN Broadcast_Mode BM ON BM.Broadcast_Mode_Code = adrs.Broadcast_Mode_Code
			WHERE BM.Broadcast_Mode_Name = 'Clips'
			GROUP BY tr.AcqRightsCode
		) AS A
		RIGHT JOIN #TempRights tr ON tr.AcqRightsCode = A.AcqRightsCode

		PRINT 'FormOfExploitation - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'List of Sub-Licensees')
	BEGIN
		
		PRINT 'ListOfSubLicensees - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('List of Sub-Licensees')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + '[ListOfSubLicensees]'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		DECLARE @Path NVARCHAR(MAX) 
		SET @Path = (Select Parameter_Value from SystemParameterNew where Parameter_Name = 'AttachmentDownloadPath_OPS')

		--UPDATE tr SET tr.ListOfSubLicensees = --'Title_Import_27082020035157.380.xlsx$http://192.168.0.114/RightsU_Testing/UploadFolder/Title_Import_03012020052100.704.xlsx' 
		--CASE WHEN ISNULL(Attachment_File_Name,'') = '' THEN 'No List of Sub-licensees' Else Attachment_File_Name+'$'+@Path+''+System_File_Name end 
		--FROM
		--(
		--	Select tr.AcqDealCode, ada.Attachment_File_Name,ada.System_File_Name
		--	from #TempRights tr
		--	INNER JOIN RightsU_16Mar..Acq_Deal_Attachment ada ON ada.Acq_Deal_Code = tr.AcqDealCode
		--	INNER JOIN RightsU_16Mar..Document_Type dt On dt.Document_Type_Code = ada.Document_Type_Code
		--	WHERE Title_Code IS NULL AND dt.Document_Type_Name = 'Approved list of Sub-Licensees'
		--) AS A
		--RIGHT JOIN #TempRights tr ON tr.AcqDealCode = A.AcqDealCode

		IF OBJECT_ID('tempdb..#tempAttachment') IS NOT NULL DROP TABLE #tempAttachment

		CREATE TABLE #tempAttachment(
			AcqDealCode INT,
			Title_Code INt ,
			Attachment_File_Name NVARCHAR(MAX),
			System_File_Name NVARCHAR(MAX)
		)
			
		INSERT INTO #tempAttachment
		SELECT tr.AcqDealCode,
		ISNULL(ada.Title_Code,0) AS Title_Code ,ada.Attachment_File_Name,ada.System_File_Name --INTO #tempAttachment
		From #TempRights tr
		INNER JOIN Acq_Deal_Attachment ada ON ada.Acq_Deal_Code = tr.AcqDealCOde 
		INNER JOIN Document_Type dt On dt.Document_Type_Code = ada.Document_Type_Code
		WHERE dt.Document_Type_Name = 'Approved list of Sub-Licensees' AND ada.Title_Code IS NULL 
		
		INSERT INTO #tempAttachment
		SELECT tr.AcqDealCode,
		ISNULL(ada.Title_Code,0) AS Title_Code ,ada.Attachment_File_Name,ada.System_File_Name --INTO #tempAttachment
		From #TempRights tr
		INNER JOIN Acq_Deal_Attachment ada ON ada.Acq_Deal_Code = tr.AcqDealCOde 
		INNER JOIN Document_Type dt On dt.Document_Type_Code = ada.Document_Type_Code
		WHERE dt.Document_Type_Name = 'Approved list of Sub-Licensees' AND ada.Title_Code IS NOT NULL AND tr.AcqDealCOde NOT IN (SELECT AcqDealCode from #tempAttachment)

		UPDATE tr SET  tr.ListOfSubLicensees = CASE WHEN ISNULL(ta.Attachment_File_Name,'') = '' THEN 'No List of Sub-licensees' Else ISNULL(ta.Attachment_File_Name,'')+'$'+ISNULL(@Path,'')+''+ISNULL(ta.System_File_Name,'') end  
		from #TempRights tr
		INNER JOIN #tempAttachment ta ON ta.AcqDealCode = tr.AcqDealCode AND ta.Title_Code = 0

		UPDATE tr SET  tr.ListOfSubLicensees = CASE WHEN ISNULL(ta.Attachment_File_Name,'') = '' THEN 'No List of Sub-licensees' Else ISNULL(ta.Attachment_File_Name,'')+'$'+ISNULL(@Path,'')+''+ISNULL(ta.System_File_Name,'') end  
		from #TempRights tr
		INNER JOIN #tempAttachment ta ON ta.AcqDealCode = tr.AcqDealCode AND ta.Title_Code = CASE WHEN tr.DealTypeCode = 27 THEN tr.AcqDealMovieCode ELSE tr.TitleCode END
		AND ta.Title_Code <> 0

		--UPDATE tr SET  tr.ListOfSubLicensees = 'No List of Sub-licensees' 
		--from #TempRights tr
		--WHERE ISNULL(ListOfSubLicensees, '') = ''
		--INNER JOIN #tempAttachment ta ON ta.AcqDealCode = tr.AcqDealCode 
		--AND ta.Title_Code <> 0
		--WHERE ta.Title_Code <> CASE WHEN tr.DealTypeCode = 27 THEN tr.AcqDealMovieCode ELSE tr.TitleCode END
		--PRINT 'ListOfSubLicensees - End'

	END


	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'License Period')
	BEGIN
	
		PRINT 'License Period - Start'

		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'License Period'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LicensePeriod'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		PRINT 'License Period - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Exclusivity')
	BEGIN
	
		PRINT 'Exclusivity - Start'

		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Exclusivity'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Exclusivity'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		PRINT 'Exclusivity - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Licensor')
	BEGIN
	
		PRINT 'Licensor - Start'

		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Licensor'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Licensor'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		UPDATE t
		SET t.Licensor = s.Vendor_Name
		FROM #TempRights t
		INNER JOIN (
			SELECT DISTINCT Title_Code, Acq_Deal_Rights_Code, v.Vendor_Name FROM TitleRights tr
			INNER JOIN Vendor v ON tr.Vendor_Code = v.Vendor_Code
			WHERE Acq_Deal_Rights_Code IN(SELECT DISTINCT AcqRightsCode FROM #TempRights)
		) AS s ON t.AcqRightsCode = s.Acq_Deal_Rights_Code

		PRINT 'Licensor - End'

		--SELECT * FROM #TempRights
	END
		
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Linear Rights Nuances')
	BEGIN
	
		PRINT 'Linear Rights Nuances - Start'

		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Linear Rights Nuances'

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'LinearNuances'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		PRINT 'Linear Rights Nuances - End'

		--SELECT * FROM #TempRights
	END
		
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Number of Episodes')
	BEGIN
		IF(@IsProgram = 'Y')
		BEGIN
			PRINT 'Number of Episodes - Start'
			SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Number of Episodes'

			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'EpisodesCnt'
		
			SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder
			PRINT 'Number of Episodes - End'
		END
		--SELECT * FROM #TempRights
	END
		
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Dubbing Rights', 'Dubbing Language', 'Dubbing'))
	BEGIN
	
		PRINT 'Dubbing - End'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Dubbing Rights', 'Dubbing Language', 'Dubbing')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'DubbingLanguage'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

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

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Subtitling Language', 'Subtitling Rights', 'Subtitling'))
	BEGIN
	
		PRINT 'Subtitling - End'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Subtitling Language', 'Subtitling Rights', 'Subtitling')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'SubtitlingLanguage'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

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
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Territory'))
	BEGIN
	
		PRINT 'Territory - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Territory')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Territory'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

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
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Name of Channels'))
	BEGIN
	
		PRINT 'Name of Channels - Start'

		DECLARE @IsRun CHAR(1) = 'N'

		IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Number of Runs'))
		BEGIN
			SET @IsRun = 'Y'
		END
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Name of Channels')
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'ChannelRuns'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

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

		PRINT 'Name of Channels - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Media Platform', 'Platform', 'Platforms'))
	BEGIN
	
		PRINT 'Territory - Start'

		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Platform', 'Platforms', 'Media Platform')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'MediaPlatforms, ExploitationPlatforms'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, 'Media Platform', @FieldOrder

		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, 'Mode of Exploitation', @FieldOrder

		CREATE TABLE #TempPlatforms
		(
			TitleCode INT,
			AcqRightsCode INT,
			Platform_Code INT,
		)
		
		CREATE TABLE #TempPlatformsHL
		(
			TitleCode INT,
			AcqRightsCode INT,
			MediaPlatforms NVARCHAR(2000),
			ExploitationPlatforms NVARCHAR(2000),
		)

		INSERT INTO #TempPlatforms
		SELECT DISTINCT tmd.TitleCode, tmd.AcqRightsCode, tp.Platform_Code 
		FROM #TempRights tmd
		INNER JOIN TitlePlatform tp ON tmd.AcqRightsCode = tp.Acq_Deal_Rights_Code
		
		INSERT INTO #TempPlatformsHL(TitleCode, AcqRightsCode, MediaPlatforms, ExploitationPlatforms)
		SELECT DISTINCT TitleCode, AcqRightsCode, Media_Platform, ExploitatiON_Platform FROM (
			SELECT TitleCode, AcqRightsCode, (STUFF ((
				SELECT ',' + CAST(tl.Platform_Code AS VARCHAR)
				FROM  #TempPlatforms tl WHERE tl.TitleCode = a.TitleCode AND a.AcqRightsCode = tl.AcqRightsCode
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 1, '')
			) AS PlatformCodes
			FROM (
				SELECT DISTINCT TitleCode, AcqRightsCode FROM #TempPlatforms
			) AS a
		) AS b
		CROSS APPLY DBO.[UFN_Get_Platform_Group](b.PlatformCodes)

		MERGE #TempRights AS T
		USING #TempPlatformsHL S ON s.AcqRightsCode = T.AcqRightsCode 
		WHEN MATCHED THEN
		UPDATE SET T.MediaPlatforms = S.MediaPlatforms, T.ExploitationPlatforms = S.ExploitationPlatforms
		WHEN NOT MATCHED THEN
		INSERT (TitleCode, AcqRightsCode, MediaPlatforms, ExploitationPlatforms) VALUES (S.TitleCode, S.AcqRightsCode, S.MediaPlatforms, S.ExploitationPlatforms);

		DROP TABLE #TempPlatforms
		DROP TABLE #TempPlatformsHL

	END
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Program Category')
	BEGIN
	
		PRINT 'Program Category - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Program Category')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'ProgramCategory'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		PRINT 'Program Category - End'

	END
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Censor Details')
	BEGIN
		
		PRINT 'Censor Details - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Censor Details')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'CensorDetails'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		PRINT 'Censor Details - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Sub-Licensing')
	BEGIN
		
		PRINT 'Sub-Licensing - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('Sub-Licensing')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + '[Sub-Licensing]'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder

		PRINT 'Sub-Licensing - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'ROFR - ROFR Type')
	BEGIN
		
		PRINT 'ROFR - ROFR Type - Start'
		
		SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName IN ('ROFR - ROFR Type')

		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + '[ROFR - ROFR Type]'
		
		SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), @GroupDetail, @ColName, @FieldOrder
		
		UPDATE a SET a.[ROFR - ROFR Type] = FORMAT(tmd.ROFR_Date,'dd-MM-yyyy') +' '+tmd.ROFR_Type
		FROM #TempRights a
		INNER JOIN TitleRights tmd ON a.AcqRightsCode = tmd.Acq_Deal_Rights_Code

		PRINT 'ROFR - ROFR Type - End'

	END


	DECLARE @CurDisplayName NVARCHAR(100) = '', @CurGroupOrder VARCHAR(20) = '', @CurFieldOrder VARCHAR(5) = '', @AncillaryFields VARCHAR(1000) = ''
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE ViewName = 'TitleNonSaleableAncillary')
	BEGIN
	
		PRINT 'TitleNonSaleableAncillary - Start'

		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurGroupOrder = '', @CurFieldOrder = ''

		--DECLARE @ClipRightCol NVARCHAR(1000) = ''

		DECLARE CUR_NSAncillary CURSOR FOR SELECT DisplayName, GroupOrder, FieldOrder FROM #TempFields WHERE ViewName = 'TitleNonSaleableAncillary'
		OPEN CUR_NSAncillary
		FETCH FROM CUR_NSAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
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
		
			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'GROUP' + @CurGroupOrder, @CurDisplayName, @CurFieldOrder

			--IF(@CurDisplayName = 'Clip Rights')
			--BEGIN
			--	SET @ClipRightCol = '[Clip Rights]'
			--END

			EXEC('ALTER TABLE #TempNSAncillary ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_NSAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
		END
		CLOSE CUR_NSAncillary
		DEALLOCATE CUR_NSAncillary

		EXEC('INSERT INTO #TempNSAncillary(TitleCode, AcqDealCode, ' + @AncillaryFields + ')
		SELECT Title_Code,  Acq_Deal_Code, ' + @AncillaryFields + '
		FROM (
			SELECT tnsa.Title_Code, tnsa.Acq_Deal_Code, tnsa.Ancillary_Name,
			STUFF((SELECT DISTINCT ''‰¾‰'' + CAST(ts.Config_Value AS VARCHAR(Max)) [text()]
					FROm TitleNonSaleableAncillary ts
					WHERE ts.Ancillary_Name = tnsa.Ancillary_Name AND ts.Title_Code = tt.Title_Code
					AND ts.Acq_Deal_Code IN (SELECT AcqDealCode FROM #TempRights)
						  --AND ts.Episode_From = tsna.Episode_From AND ts.Episode_To = tsna.Episode_To
						  --AND ts.Ancillary_Code = tsna.Ancillary_Code
					FOR XML PATH(''''), TYPE)
					.value(''.'',''NVARCHAR(MAX)''),1,3,''''
				) AS Config_Value
			FROM TitleNonSaleableAncillary tnsa
			INNER JOIN #TempTitle tt ON tnsa.Title_Code = tt.Title_Code
			INNER JOIN #TempFields tf ON tnsa.Ancillary_Name COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			WHERE ViewName = ''TitleNonSaleableAncillary'' AND tnsa.Acq_Deal_Code IN (
				SELECT AcqDealCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			MIN(Config_Value) 
			FOR Ancillary_Name IN (' + @AncillaryFields +')
		) AS pivot_table;')

		--SELECT * FROM #TempNSAncillary

		--IF(@ClipRightCol <> '')
		--BEGIN

		--	EXEC('UPDATE #TempNSAncillary SET [Clip Rights] = CASE WHEN [Clip Rights] = '''' THEN ''Not Available'' ELSE ''Available'' END ')

		--END

		PRINT 'TitleNonSaleableAncillary - End'

	END
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName = 'Archive Rights')	
	BEGIN	
		
		PRINT 'Archive Rights - Start'	
		SELECT TOP 1 @CurDisplayName = DisplayName, @CurGroupOrder = GroupOrder, @CurFieldOrder = FieldOrder FROM #TempFields WHERE DisplayName = 'Archive Rights'	
			
		IF(@TableColumns <> '')	
			SET @TableColumns = @TableColumns + ', '	
		SET @TableColumns = @TableColumns + '[' + @CurDisplayName +']'	
				
		SET @OutputCounter = @OutputCounter + 1	
		IF(@OutputCols <> '')	
			SET @OutputCols = @OutputCols + ', '	
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)	
			
		INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)	
		SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'GROUP' + @CurGroupOrder, @CurDisplayName, @CurFieldOrder	
		EXEC('ALTER TABLE #TempNSAncillary ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')	
		EXEC('UPDATE tns SET tns.[' + @CurDisplayName + '] = REPLACE(tnsa.Config_Value, ''' + @CurDisplayName + ' - '', '''') FROM #TempNSAncillary tns	
		INNER JOIN TitleNonSaleableAncillary tnsa ON tns.TitleCode = tnsa.Title_Code AND tns.AcqDealCode = tnsa.Acq_Deal_Code	
		WHERE Ancillary_Name = ''Exploitation Rights'' AND Label_Name = ''' + @CurDisplayName + '''')	
		EXEC('INSERT INTO #TempNSAncillary(TitleCode, AcqDealCode, [' + @CurDisplayName + '])	
		SELECT tnsa.Title_Code, tnsa.Acq_Deal_Code, Config_Value 	
		FROM TitleNonSaleableAncillary tnsa	
		INNER JOIN #TempTitle tt ON tnsa.Title_Code = tt.Title_Code 	
		WHERE Ancillary_Name = ''Exploitation Rights'' AND Label_Name = ''' + @CurDisplayName + ''' AND tnsa.Acq_Deal_Code IN (	
			SELECT AcqDealCode FROM #TempRights	
		) AND tt.Title_Code NOT IN (SELECT tns.TitleCode FROM #TempNSAncillary tns WHERE tns.AcqDealCode = tnsa.Acq_Deal_Code) ')	
		--SELECT * FROM #TempNSAncillary	
		SELECT @CurDisplayName = '', @CurGroupOrder = '', @CurFieldOrder = ''	
			
		PRINT 'Archive Rights - Start'	
	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE ViewName = 'TitleSaleableAncillary')
	BEGIN
	
		PRINT 'TitleSaleableAncillary - Start'

		--SELECT * FROM TitleSaleableAncillary

		--SELECT tt.Title_Name, MIN(tr.Actual_Right_Start_Date) StartDate, MAX(tr.Actual_Right_End_Date) EndDate
		--UPDATE tt
		--SET tt.ValueField = tnsa.Config_Value
		--FROM TitleSaleableAncillary tnsa
		--INNER JOIN #TempOutput tt ON tnsa.Title_Code = tt.TitleCode AND tnsa.Platform_Hiearachy COLLATE Database_Default = tt.KeyField COLLATE Database_Default
		--INNER JOIN #TempFields tf ON tt.KeyField COLLATE Database_Default  = tf.DisplayName COLLATE Database_Default  --AND tf.Title_Code = tt.TitleCode
		--WHERE ViewName = 'TitleSaleableAncillary'
		
		
		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurGroupOrder = '', @CurFieldOrder = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DisplayName, GroupOrder, FieldOrder FROM #TempFields WHERE ViewName = 'TitleSaleableAncillary'
		OPEN CUR_SaleAncillary
		FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
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
		
			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'GROUP' + @CurGroupOrder, @CurDisplayName, @CurFieldOrder

			EXEC('ALTER TABLE #TempSaleAncillary ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary
		
		EXEC('INSERT INTO #TempSaleAncillary(TitleCode, AcqDealCode, ' + @AncillaryFields + ')
		SELECT Title_Code,  Acq_Deal_Code, ' + @AncillaryFields + '
		FROM (
			SELECT tnsa.Title_Code, tnsa.Acq_Deal_Code, tnsa.Platform_Hiearachy, Config_Value
			FROM TitleSaleableAncillary tnsa
			INNER JOIN #TempTitle tt ON tnsa.Title_Code = tt.Title_Code
			INNER JOIN #TempFields tf ON tnsa.Platform_Hiearachy COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			WHERE ViewName = ''TitleSaleableAncillary'' AND tnsa.Acq_Deal_Code IN (
				SELECT AcqDealCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			MIN(Config_Value) 
			FOR Platform_Hiearachy IN (' + @AncillaryFields +')
		) AS pivot_table;')


		PRINT 'TitleSaleableAncillary - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE ViewName = 'AncillaryPlatform')
	BEGIN
	
		PRINT 'AncillaryPlatform - Start'
		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurGroupOrder = '', @CurFieldOrder = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DisplayName, GroupOrder, FieldOrder FROM #TempFields WHERE ViewName = 'AncillaryPlatform'
		OPEN CUR_SaleAncillary
		FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
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
		
			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'GROUP' + @CurGroupOrder, @CurDisplayName, @CurFieldOrder

			EXEC('ALTER TABLE #TempAncillaryPlatform ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
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
		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurGroupOrder = '', @CurFieldOrder = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DisplayName, GroupOrder, FieldOrder FROM #TempFields WHERE ViewName = 'Ancillary_Type'
		OPEN CUR_SaleAncillary
		FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
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
		
			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'GROUP' + @CurGroupOrder, @CurDisplayName, @CurFieldOrder

			EXEC('ALTER TABLE #TempAncillaryType ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary
		
		EXEC('INSERT INTO #TempAncillaryType(AcqDealRightsCode, ' + @AncillaryFields + ')
		SELECT Acq_Deal_Rights_Code,  ' + @AncillaryFields + '
		FROM (
			SELECT Ancillary_Type_Name, tnsa.Acq_Deal_Rights_Code, Ancillary_Type_Code 
			FROM Ancillary_Type tnsa
			INNER JOIN #TempFields tf ON tnsa.Ancillary_Type_Name COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			WHERE ViewName = ''Ancillary_Type'' AND tnsa.Acq_Deal_Rights_Code IN (
				SELECT AcqRightsCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			COUNT(Ancillary_Type_Code) 
			FOR Ancillary_Type_Name IN (' + @AncillaryFields +')
		) AS pivot_table;')

		PRINT 'Ancillary_Type - End'
		
	END

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE ViewName = 'AcqDealRightsPromoterGroup')
	BEGIN
		
		PRINT 'AcqDealRightsPromoterGroup - Start'
		SELECT @AncillaryFields = '', @CurDisplayName = '', @CurGroupOrder = '', @CurFieldOrder = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DisplayName, GroupOrder, FieldOrder FROM #TempFields WHERE ViewName = 'AcqDealRightsPromoterGroup'
		OPEN CUR_SaleAncillary
		FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
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
		
			INSERT INTO #TempOP(ColValue, GroupDetails, KeyField, FieldOrder)
			SELECT 'COL' + CAST(@OutputCounter AS VARCHAR), 'GROUP' + @CurGroupOrder, @CurDisplayName, @CurFieldOrder

			EXEC('ALTER TABLE #TempPromoterGroup ADD [' + @CurDisplayName + '] NVARCHAR(MAX)')

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName, @CurGroupOrder, @CurFieldOrder
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary
		
		EXEC('INSERT INTO #TempPromoterGroup(AcqDealRightsCode, ' + @AncillaryFields + ')
		SELECT Acq_Deal_Rights_Code,  ' + @AncillaryFields + '
		FROM (
			SELECT Promoter_Group_Name, tnsa.Acq_Deal_Rights_Code, Promoter_Group_Code 
			FROM AcqDealRightsPromoterGroup tnsa
			INNER JOIN #TempFields tf ON tnsa.Promoter_Group_Name COLLATE Database_Default = tf.DisplayName COLLATE Database_Default
			WHERE ViewName = ''AcqDealRightsPromoterGroup'' AND tnsa.Acq_Deal_Rights_Code IN (
				SELECT AcqRightsCode FROM #TempRights
			)
		) tmp 
		PIVOT(
			COUNT(Promoter_Group_Name) 
			FOR Promoter_Group_Name IN (' + @AncillaryFields +')
		) AS pivot_table;')

		PRINT 'AcqDealRightsPromoterGroup - End'
		
	END

	
	MERGE #TempNSAncillary AS T
	USING (
		SELECT DISTINCT TitleCode, AcqDealCode FROM #TempRights
	) AS S ON s.TitleCode = T.TitleCode AND s.AcqDealCode = T.AcqDealCode
	WHEN NOT MATCHED THEN
	INSERT (TitleCode, AcqDealCode) VALUES (S.TitleCode, S.AcqDealCode);
	
	MERGE #TempSaleAncillary AS T
	USING (
		SELECT DISTINCT TitleCode, AcqDealCode FROM #TempRights
	) AS S ON s.TitleCode = T.TitleCode AND s.AcqDealCode = T.AcqDealCode
	WHEN NOT MATCHED THEN
	INSERT (TitleCode, AcqDealCode) VALUES (S.TitleCode, S.AcqDealCode);

	DECLARE @OutputSQL NVARCHAR(MAX) = ''
	SET @OutputSQL = 'INSERT INTO #TempOutput(ColumnGroup, AcqDealCode, TitleName, ' + @OutputCols + ')
	SELECT DISTINCT tr.AcqRightsCode, tr.AcqDealCode, Title_Name, ' + @TableColumns + '
	FROM #TempTitle tt
	INNER JOIN #TempRights tr ON CASE WHEN tt.Deal_Type_Code = 27 THEN tt.AcqDealMovieCode ELSE tt.Title_Code END = CASE WHEN tt.Deal_Type_Code = 27 THEN tr.AcqDealMovieCode ELSE tr.TitleCode END
	INNER JOIN #TempNSAncillary tnsa ON tnsa.TitleCode = tr.TitleCode AND tnsa.AcqDealCode = tr.AcqDealCode
	INNER JOIN #TempSaleAncillary tsalea ON tsalea.TitleCode = tr.TitleCode AND tsalea.AcqDealCode = tr.AcqDealCode	
	LEFT JOIN #TempAncillaryPlatform tap ON tap.AcqDealRightsCode = tr.AcqRightsCode
	LEFT JOIN #TempAncillaryType tat ON tat.AcqDealRightsCode = tr.AcqRightsCode
	LEFT JOIN #TempPromoterGroup tpg ON tpg.AcqDealRightsCode = tr.AcqRightsCode'

	PRINT(@OutputSQL)
	EXEC(@OutputSQL)

	UPDATE #TempOP SET GroupOrder = REPLACE(GroupDetails, 'GROUP', '')
	print 'Step 3'
	--SELECT * FROM #TempRights

	--TitleCode	TitleName	GroupDetails	GroupOrder	KeyField	ValueField	FieldOrder

	--SELECT * FROM Platform


	DECLARE @ParentKeyField NVARCHAR(MAX) 
	SET @ParentKeyField = (Select Parameter_Value from SystemParameterNew where Parameter_Name = 'ParentKeyField')

	--UPDATE op SET op.ParentKeyField = pkf.Ancillary_Tab_Description
	--FROM #tempOP op
	--INNER JOIN AncillaryParentKeyField pkf ON pkf.Ancillary_Name COLLATE Database_Default = op.KeyField COLLATE Database_Default
	--WHERE pkf.Ancillary_Tab_Description IN (SELECT LTRIM(RTRIM(number)) from dbo.[UFNSplit](@ParentKeyField, ',') WHERE number IS NOT NULL)


	SELECT ColumnGroup AS TitleCode, TitleName, AcqDealCode AS DealCode, GroupDetails, GroupOrder, ISNULL(ParentKeyField, '') AS ParentKeyField, KeyField, 
	CASE 
	     WHEN KeyField IN('Clip Rights') AND ISNULL(ValueField, '') <> '' THEN 'Available'
		-- WHEN KeyField IN('Merchandising Rights') AND ISNULL(ValueField, '') <> '' THEN 'Available - Check with Legal'
		 WHEN KeyField IN('Clip Rights', 'Merchandising Rights') AND ISNULL(ValueField, '') = '' THEN 'Not Available'
		 WHEN KeyField IN ('Promotional Clip Rights', 'Merchandising Rights', 'Right to use Images and Artworks', 'Advertising and Sponsorship Rights',
							'Right to create/Use Promos/Clips','Catch up Rights','Right to use CAC','Offline Viewing') AND ISNULL(ValueField,'0') <> '0' THEN 'Available'
		 WHEN KeyField IN ('Promotional Clip Rights', 'Merchandising Rights', 'Right to use Images and Artworks', 'Advertising and Sponsorship Rights',
							'Right to create/Use Promos/Clips','Catch up Rights','Right to use CAC','Offline Viewing') AND ISNULL(ValueField,'0') = '0' THEN 'Not Available'
		 ELSE ValueField 
	END AS ValueField, 
	FieldOrder FROM (
		SELECT u.ColumnGroup, u.TitleName, u.AcqDealCode ,u.ColValues, u.ValueField
		FROM (
			SELECT MAX(ColumnGroup) AS ColumnGroup, TitleName, AcqDealCode,
			ISNULL(COL1, 'No') AS COL1, ISNULL(COL2, 'No') AS COL2, ISNULL(COL3, 'No') AS COL3, ISNULL(COL4, 'No') AS COL4, ISNULL(COL5, 'No') AS COL5, 	
			ISNULL(COL6, 'No') AS COL6, ISNULL(COL7, 'No') AS COL7, ISNULL(COL8, 'No') AS COL8, ISNULL(COL9, 'No') AS COL9, ISNULL(COL10, 'No') AS COL10, 	
			ISNULL(COL11, 'No') AS COL11, ISNULL(COL12, 'No') AS COL12, ISNULL(COL13, 'No') AS COL13, ISNULL(COL14, 'No') AS COL14, ISNULL(COL15, 'No') AS COL15, 	
			ISNULL(COL16, 'No') AS COL16, ISNULL(COL17, 'No') AS COL17, ISNULL(COL18, 'No') AS COL18, ISNULL(COL19, 'No') AS COL19, ISNULL(COL20, 'No') AS COL20, 	
			ISNULL(COL21, 'No') AS COL21, ISNULL(COL22, 'No') AS COL22, ISNULL(COL23, 'No') AS COL23, ISNULL(COL24, 'No') AS COL24, ISNULL(COL25, 'No') AS COL25, 	
			ISNULL(COL26, 'No') AS COL26, ISNULL(COL27, 'No') AS COL27, ISNULL(COL28, 'No') AS COL28, ISNULL(COL29, 'No') AS COL29, ISNULL(COL30, 'No') AS COL30
			FROM #TempOutput --WHERE IsEmpty IS NOT NULL
			GROUP BY TitleName, AcqDealCode, COL1, COL2, COL3, COL4, COL5, 
			COL6, COL7, COL8, COL9, COL10, 
			COL11, COL12, COL13, COL14, COL15, 
			COL16, COL17, COL18, COL19, COL20, 
			COL21, COL22, COL23, COL24, COL25, 
			COL26, COL27, COL28, COL29, COL30
		) AS s
		UNPIVOT
		(
			ValueField
			FOR ColValues IN (
				COL1, COL2, COL3, COL4, COL5, 
				COL6, COL7, COL8, COL9, COL10, 
				COL11, COL12, COL13, COL14, COL15, 
				COL16, COL17, COL18, COL19, COL20, 
				COL21, COL22, COL23, COL24, COL25, 
				COL26, COL27, COL28, COL29, COL30
			)
		) AS u
	) AS unpout
	INNER JOIN #TempOP op ON unpout.ColValues COLLATE Database_Default = op.ColValue COLLATE Database_Default
	ORDER BY TitleName, ColumnGroup, GroupOrder, FieldOrder

	IF OBJECT_ID('tempdb..#TempLang') IS NOT NULL DROP TABLE #TempLang
	IF OBJECT_ID('tempdb..#TempSubLang') IS NOT NULL DROP TABLE #TempSubLang
	IF OBJECT_ID('tempdb..#TempPlatforms') IS NOT NULL DROP TABLE #TempPlatforms
	IF OBJECT_ID('tempdb..#TempTerritory') IS NOT NULL DROP TABLE #TempTerritory
	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#UITitle') IS NOT NULL DROP TABLE #UITitle
	IF OBJECT_ID('tempdb..#TempRights') IS NOT NULL DROP TABLE #TempRights
	IF OBJECT_ID('tempdb..#TempNSAncillary') IS NOT NULL DROP TABLE #TempNSAncillary
	IF OBJECT_ID('tempdb..#TempSaleAncillary') IS NOT NULL DROP TABLE #TempSaleAncillary
	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP
	IF OBJECT_ID('tempdb..#TempAncillaryPlatform') IS NOT NULL DROP TABLE #TempAncillaryPlatform

END
