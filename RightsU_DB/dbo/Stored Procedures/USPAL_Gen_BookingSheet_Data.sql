CREATE PROCEDURE [dbo].[USPAL_Gen_BookingSheet_Data](@BookingSheetCode INT)
AS
BEGIN

	--DECLARE @BookingSheetCode INT = 1080
	IF OBJECT_ID('tempdb..#TempBookingContent') IS NOT NULL DROP TABLE #TempBookingContent
	IF OBJECT_ID('tempdb..#TempBookingDataToGen') IS NOT NULL DROP TABLE #TempBookingDataToGen
	IF OBJECT_ID('tempdb..#TempFileName') IS NOT NULL DROP TABLE #TempFileName

	CREATE TABLE #TempBookingContent
	(
		Title_Code INT,
		Title_Content_Code INT,
		Columns_Code INT,
		Group_Control_Order INT,
		Validations VARCHAR(100),
		Additional_Condition VARCHAR(MAX),
		Display_Name VARCHAR(100),
		Target_Table VARCHAR(100),
		Target_Column VARCHAR(100),
		Allow_Import CHAR(1),
		Rule_Type CHAR(1),
		Content_Status CHAR(1),
		Columns_Value NVARCHAR(MAX)
	)

	CREATE TABLE #TempFileName
	(
		Title_Code INT,
		Title_Content_Code INT,
		Additional_Condition VARCHAR(MAX),
		File_Names VARCHAR(MAX),
		CycleStart VARCHAR(100),
		CycleStartYYYYMM VARCHAR(100),
		CycleStartYYMM VARCHAR(100),
		Title VARCHAR(1000),
		IncrementNo INT,
		TitleLanguage VARCHAR(1000),
		Season VARCHAR(100),
		Episode VARCHAR(100),
		TitleWOSpace VARCHAR(MAX),
		TitleLang3Char VARCHAR(100),
		EmbSubs3Char VARCHAR(100),
		Version VARCHAR(100),
		EpisodeTitleWOSpace VARCHAR(100),
		SeasonWOZero VARCHAR(100),
		EpisodeWOZero VARCHAR(100),
		TitleLang2Char VARCHAR(100),
		IncrementNo5Digit VARCHAR(100),
		Title_Type VARCHAR(100), 
		Columns_Code INT, 
		Target_Column VARCHAR(100)
	)
	
	CREATE TABLE #TempBookingDataToGen
	(
		Title_Code INT,
		Title_Content_Code INT
	)

	--DELETE FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @BookingSheetCode
	DECLARE @RecommendationCode INT = 0, @VendorCode INT = 0, @Extended_Group_ForBookingSheet INT = 0
	DECLARE @ProposalCode INT = 0, @CurrentRecomCode INT = 0, @CurrentCycleNo INT = 0, @PrevBookingSheetCode INT = 0, @PrevRecomCode INT = 0
	DECLARE @MovieCount INT = 0, @ShowCount INT = 0
	
	SELECT @VendorCode = Vendor_Code, @RecommendationCode = AL_Recommendation_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode
	SELECT @Extended_Group_ForBookingSheet = Extended_Group_Code_Booking FROM AL_Vendor_Details WHERE Vendor_Code = @VendorCode

	SELECT @MovieCount = COUNT(*)
	FROM AL_Recommendation_Content arc
	INNER JOIN AL_Vendor_Rule avr ON arc.AL_Vendor_Rule_Code = avr.AL_Vendor_Rule_Code
	WHERE AL_Recommendation_Code = @RecommendationCode AND Rule_Type = 'M'
	
	SELECT @ShowCount = COUNT(*)
	FROM AL_Recommendation_Content arc
	INNER JOIN AL_Vendor_Rule avr ON arc.AL_Vendor_Rule_Code = avr.AL_Vendor_Rule_Code
	WHERE AL_Recommendation_Code = @RecommendationCode AND Rule_Type = 'S'

	IF EXISTS(SELECT TOP 1 * FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @BookingSheetCode)
	BEGIN

		INSERT INTO #TempBookingDataToGen(Title_Code, Title_Content_Code)
		SELECT Title_Code, Title_Content_Code FROM AL_Recommendation_Content 
		WHERE AL_Recommendation_Code = @RecommendationCode AND Title_Content_Code NOT IN (
			SELECT DISTINCT Title_Content_Code FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @BookingSheetCode
		)

		DELETE FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @BookingSheetCode AND Title_Content_Code NOT IN (
			SELECT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @RecommendationCode
		)

		UPDATE AL_Booking_Sheet_Details SET Columns_Value = 'remove' WHERE AL_Booking_Sheet_Code = @BookingSheetCode AND Title_Content_Code IN (
			SELECT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @RecommendationCode AND Content_Status = 'D'
		) AND Validations like '%0%' --Validations = '0 & 1'

	END
	ELSE
	BEGIN

		SELECT @CurrentRecomCode = AL_Recommendation_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode
		SELECT @CurrentCycleNo = Refresh_Cycle_No, @ProposalCode = AL_Proposal_Code FROM AL_Recommendation WHERE AL_Recommendation_Code = @CurrentRecomCode

		INSERT INTO #TempBookingDataToGen(Title_Code, Title_Content_Code)
		SELECT Title_Code, Title_Content_Code FROM AL_Recommendation_Content 
		WHERE AL_Recommendation_Code = @RecommendationCode

		IF(@CurrentCycleNo > 1)
		BEGIN

			SELECT @PrevRecomCode = AL_Recommendation_Code FROM AL_Recommendation WHERE AL_Proposal_Code = @ProposalCode AND Refresh_Cycle_No = (@CurrentCycleNo - 1)
			SELECT @PrevBookingSheetCode = AL_Booking_Sheet_Code FROM AL_Booking_Sheet WHERE AL_Recommendation_Code = @PrevRecomCode

			DELETE FROM #TempBookingDataToGen WHERE Title_Content_Code IN (
				SELECT DISTINCT Title_Content_Code FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @PrevBookingSheetCode
			)

			INSERT INTO AL_Booking_Sheet_Details(AL_Booking_Sheet_Code, Title_Code, Title_Content_Code, Extended_Group_Code, Columns_Code, 
					Group_Control_Order, Validations, Additional_Condition, Display_Name, Allow_Import, 
					Columns_Value, Cell_Status, Action_By, Action_Date)
			SELECT @BookingSheetCode, Title_Code, Title_Content_Code, Extended_Group_Code, Columns_Code, 
					Group_Control_Order, Validations, Additional_Condition, Display_Name, Allow_Import, 
					CASE WHEN Columns_Code = (SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Status_Value') THEN 'Holdover' ELSE Columns_Value END, Cell_Status, Action_By, Action_Date
			FROM AL_Booking_Sheet_Details 
			WHERE AL_Booking_Sheet_Code = @PrevBookingSheetCode AND Title_Content_Code IN (
				SELECT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @RecommendationCode AND Content_Status <> 'D'
			)
			
			INSERT INTO AL_Booking_Sheet_Details(AL_Booking_Sheet_Code, Title_Code, Title_Content_Code, Extended_Group_Code, Columns_Code, 
					Group_Control_Order, Validations, Additional_Condition, Display_Name, Allow_Import, 
					Columns_Value, Cell_Status, Action_By, Action_Date)
			SELECT @BookingSheetCode, Title_Code, Title_Content_Code, Extended_Group_Code, Columns_Code, 
					Group_Control_Order, Validations, Additional_Condition, Display_Name, Allow_Import, 
					CASE WHEN Columns_Code = (SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Status_Value') THEN 'Holdover' ELSE Columns_Value END, Cell_Status, Action_By, Action_Date
			FROM AL_Booking_Sheet_Details 
			WHERE AL_Booking_Sheet_Code = @PrevBookingSheetCode AND Title_Content_Code IN (
				SELECT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @RecommendationCode AND Content_Status = 'D'
			)

			UPDATE AL_Booking_Sheet_Details SET Columns_Value = 'remove' WHERE AL_Booking_Sheet_Code = @BookingSheetCode AND Title_Content_Code IN (
				SELECT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @RecommendationCode AND Content_Status = 'D'
			) AND Validations like '%0%' --Validations = '0 & 1'

		END

	END
	
	INSERT INTO #TempBookingContent(Title_Code, Title_Content_Code, Columns_Code, Group_Control_Order, Validations, 
			Additional_Condition, Display_Name, Allow_Import, Rule_Type, Content_Status, Target_Table, Target_Column, 
			Columns_Value)
	SELECT DISTINCT arc.Title_Code, arc.Title_Content_Code, egc.Columns_Code, egc.Group_Control_Order, egc.Validations,
		   egc.Additional_Condition, egc.Display_Name, egc.Allow_Import, avr.Rule_Type, arc.Content_Status, Target_Table, Target_Column, 
		   ISNULL(egc.Default_Value, '')
	FROM Extended_Group_Config egc 
	INNER JOIN AL_Recommendation_Content arc ON 1 = 1
	INNER JOIN AL_Vendor_Rule avr ON arc.AL_Vendor_Rule_Code = avr.AL_Vendor_Rule_Code
	INNER JOIN #TempBookingDataToGen tmp ON tmp.Title_Content_Code = arc.Title_Content_Code
	WHERE Extended_Group_Code = @Extended_Group_ForBookingSheet AND arc.AL_Recommendation_Code = @RecommendationCode
	--AND arc.Title_Content_Code IN (SELECT arc.Title_Content_Code
	
	--INSERT INTO #TempFileName(Title_Code, Title_Content_Code, Additional_Condition, File_Names)
	--SELECT DISTINCT Title_Code, Title_Content_Code, Additional_Condition, Additional_Condition 
	--FROM #TempBookingContent WHERE Target_Table = 'FileNameGeneration'

	INSERT INTO #TempFileName(Title_Code, Title_Content_Code, Additional_Condition, File_Names, Title_Type, Columns_Code, Target_Column)
	SELECT DISTINCT tbc.Title_Code, tbc.Title_Content_Code, tbc.Additional_Condition, tbc.Additional_Condition,
		   CASE WHEN ec.Columns_Name like '%Trailer%' THEN 'T' ELSE Display_Name END AS Title_Type, tbc.Columns_Code, tbc.Target_Column
	FROM #TempBookingContent tbc
	    INNER JOIN Extended_Columns ec ON tbc.Columns_Code = ec.Columns_Code
    WHERE tbc.Target_Table = 'FileNameGeneration'

	--SELECT * 
	UPDATE tmp SET tmp.Title = t.Title_Name, tmp.TitleLanguage = LEFT(l.Language_Name, 3), tmp.TitleWOSpace = REPLACE(LTRIM(RTRIM(t.Title_Name)), ' ', ''), tmp.TitleLang3Char = LEFT(l.Language_Name, 3), tmp.TitleLang2Char = LEFT(l.Language_Name, 2)
	FROM #TempFileName tmp
	INNER JOIN Title t ON tmp.Title_Code = t.Title_Code
	INNER JOIN Language l ON t.Title_Language_Code = l.Language_Code

	UPDATE tmp SET tmp.Episode = 'E0' + CAST(tc.Episode_No AS VARCHAR(10))
	FROM #TempFileName tmp
	INNER JOIN Title_Content tc ON tmp.Title_Content_Code = tc.Title_Content_Code
	WHERE tc.Episode_No <= 9
	
	UPDATE tmp SET tmp.Episode = 'E' + CAST(tc.Episode_No AS VARCHAR(10))
	FROM #TempFileName tmp
	INNER JOIN Title_Content tc ON tmp.Title_Content_Code = tc.Title_Content_Code
	WHERE tc.Episode_No > 9

	UPDATE tmp SET tmp.EpisodeWOZero = 'E' + CAST(tc.Episode_No AS VARCHAR(10))
	FROM #TempFileName tmp
	INNER JOIN Title_Content tc ON tmp.Title_Content_Code = tc.Title_Content_Code

	UPDATE tmp SET tmp.EpisodeTitleWOSpace = REPLACE(LTRIM(RTRIM(ext.Episode_Title)), ' ', '')
	FROM (SELECT * FROM VWALTitleRecom WHERE AL_Recommendation_Code = @RecommendationCode) ext
	INNER JOIN #TempFileName tmp ON tmp.Title_Code = ext.Title_Code AND tmp.Title_Content_Code = ext.Title_Content_Code
    WHERE AL_Recommendation_Code = @RecommendationCode

	DECLARE @Start_Date DATE
	SELECT TOP 1 @Start_Date = Start_Date FROM VWALTitleRecom WHERE AL_Recommendation_Code = @RecommendationCode --1712

	UPDATE #TempFileName SET CycleStart = RIGHT('0'+CAST(Month(@Start_Date) AS VARCHAR), 2) + RIGHT(Year(@Start_Date), 2),
	CycleStartYYYYMM = CAST(Year(@Start_Date) AS VARCHAR(4)) + RIGHT('0'+CAST(Month(@Start_Date) AS VARCHAR), 2),
	CycleStartYYMM = RIGHT(Year(@Start_Date), 2) + RIGHT('0'+CAST(Month(@Start_Date) AS VARCHAR), 2)
	
	DECLARE @MAXNo INT = 100
	SELECT @MAXNo = RunningNo FROM MHRequestIds WHERE RequestType = 'BS' AND VendorCode = @VendorCode
	IF(ISNULL(@MAXNo, 0) = 0)
	BEGIN
		SET @MAXNo = 0
	END

	DECLARE @AL_DealType_Movies VARCHAR(100), @AL_DealType_Show VARCHAR(100)

	SELECT @AL_DealType_Movies = Parameter_Value FROM System_Parameter WHERE Parameter_Name = 'AL_DealType_Movies'

	SELECT @AL_DealType_Show = Parameter_Value FROM System_Parameter WHERE Parameter_Name = 'AL_DealType_Show'

	UPDATE tmp2 SET tmp2.IncrementNo = a.IncNo, tmp2.IncrementNo5Digit =  RIGHT('00000'+ CONVERT(VARCHAR,a.IncNo),5)
	FROM (
		SELECT Title_Content_Code, Additional_Condition, RIGHT('0000' + CAST((@MAXNo + ROW_NUMBER() OVER(ORDER BY Title_Content_Code ASC)) AS VARCHAR), 5) AS IncNo
		FROM #TempFileName tmp 
		INNER JOIN Title t ON tmp.Title_Code = t.Title_Code
		WHERE tmp.Additional_Condition LIKE '%increment%' AND tmp.Title_Type = 'M' AND t.Deal_Type_Code IN (select LTRIM(RTRIM(number)) from DBO.FN_Split_WithDelemiter(@AL_DealType_Movies, ','))
	) AS a
	INNER JOIN #TempFileName tmp2 ON a.Title_Content_Code = tmp2.Title_Content_Code AND a.Additional_Condition = tmp2.Additional_Condition

	SELECT @MAXNo = MAX(CAST(ISNULL(IncrementNo, 0) AS INT)) FROM #TempFileName WHERE CAST(ISNULL(IncrementNo, 0) AS INT) > 0

	UPDATE tmp2 SET tmp2.IncrementNo = a.IncNo, tmp2.IncrementNo5Digit =  RIGHT('00000'+ CONVERT(VARCHAR,a.IncNo),5)
	FROM (
		SELECT Title_Content_Code, Additional_Condition, RIGHT('0000' + CAST((@MAXNo + ROW_NUMBER() OVER(ORDER BY Title_Content_Code ASC)) AS VARCHAR), 5) AS IncNo
		FROM #TempFileName tmp 
		INNER JOIN Title t ON tmp.Title_Code = t.Title_Code
		WHERE tmp.Additional_Condition LIKE '%increment%' AND tmp.Title_Type = 'S' AND t.Deal_Type_Code IN (select LTRIM(RTRIM(number)) from DBO.FN_Split_WithDelemiter(@AL_DealType_Show, ','))
	) AS a
	INNER JOIN #TempFileName tmp2 ON a.Title_Content_Code = tmp2.Title_Content_Code AND a.Additional_Condition = tmp2.Additional_Condition

	SELECT @MAXNo = MAX(CAST(ISNULL(IncrementNo, 0) AS INT)) FROM #TempFileName WHERE CAST(ISNULL(IncrementNo, 0) AS INT) > 0

	UPDATE t1 SET t1.IncrementNo = t2.IncrementNo, t1.IncrementNo5Digit = t2.IncrementNo5Digit 
	FROM #TempFileName t1 
	INNER JOIN #TempFileName t2 ON t1.Title_Code = t2.Title_Code 
	AND t1.Title_Content_Code = t2.Title_Content_Code 
	AND t1.Title_Type = 'T' AND t2.Title_Type = 'M'
	AND t1.Target_Column = t2.Columns_Code 
	
	--SELECT @MAXNo = MAX(CAST(ISNULL(IncrementNo, 0) AS INT)) FROM #TempFileName WHERE CAST(ISNULL(IncrementNo, 0) AS INT) > 0

	IF NOT EXISTS(SELECT TOP 1 * FROM MHRequestIds WHERE RequestType = 'BS' AND VendorCode = @VendorCode)
	BEGIN
		INSERT INTO MHRequestIds(VendorCode, RunningNo, RequestType) VALUES(@VendorCode, @MAXNo, 'BS')
	END
	ELSE
	BEGIN
		UPDATE MHRequestIds SET RunningNo = @MAXNo WHERE VendorCode = @VendorCode AND RequestType = 'BS'
	END

	UPDATE tmp SET tmp.Season = 'S' + RIGHT('0' + ext.Column_Value, 2)
	FROM VWALTitleRecomExt ext
	INNER JOIN #TempFileName tmp ON tmp.Title_Code = ext.Record_Code
	WHERE Columns_Name = 'SEASON' AND Table_Name = 'TITLE'

	UPDATE tmp SET tmp.SeasonWOZero = 'S'  + CAST(ext.Column_Value AS VARCHAR(10))
	FROM VWALTitleRecomExt ext
	INNER JOIN #TempFileName tmp ON tmp.Title_Code = ext.Record_Code
	WHERE Columns_Name = 'SEASON' AND Table_Name = 'TITLE'

	UPDATE tmp SET tmp.EmbSubs3Char = LEFT(ext.Column_Value, 3)
	FROM VWALTitleRecomExt ext
	INNER JOIN #TempFileName tmp ON tmp.Title_Code = ext.Record_Code
	WHERE Columns_Name = 'Subtitling' AND Table_Name = 'TITLE'

	--UPDATE tmp SET tmp.Version = (LEFT(ext.Column_Value, 2)) 
	--FROM VWALTitleRecomExt ext
	--INNER JOIN #TempFileName tmp ON tmp.Title_Code = ext.Record_Code
	--WHERE Columns_Name = 'Version' AND Table_Name = 'TITLE'

	UPDATE tmp SET tmp.Version = ISNULL((SELECT TOP 1 BMS_Version_ID FROM [Version] WHERE Version_Name = ext.Column_Value),'') 
	FROM VWALTitleRecomExt ext
	INNER JOIN #TempFileName tmp ON tmp.Title_Code = ext.Record_Code
	WHERE Columns_Name = 'Version' AND Table_Name = 'TITLE'	
	
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{CycleStart}', CycleStart)
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{CycleStartYYYYMM}', CycleStartYYYYMM)
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{CycleStartYYMM}', CycleStartYYMM)
	--UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{Title}', REPLACE(Title, ' ', '_'))
	--UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{Title}', REPLACE((REPLACE(TRANSLATE(Title, '!@#$%^&*()-_=+[{]}\|:;"'',<.>/?~`', '################################'), '#', '')), ' ', '_'))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{Title}', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Title, '!', ''),'@',''),'#',''),'$',''),'%',''),'^',''),'&',''),'*',''),'(',''),')',''),'-',''),'_',''),'=',''),'+',''),'[',''),'{',''),']',''),'}',''),'\',''),'|',''),':',''),';',''),'"',''),'''',''),',',''),'<',''),'.',''),'>',''),'/',''),'?',''),'~',''),'`',''), ' ', '_'))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{IncrementNo}', ISNULL(IncrementNo, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{TitleLanguage}', TitleLanguage)
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{Season}', ISNULL(Season, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{Episode}', ISNULL(Episode, ''))
	--UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{TitleWOSpace}', ISNULL(TitleWOSpace, ''))
	--UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{TitleWOSpace}', REPLACE((REPLACE(TRANSLATE(ISNULL(TitleWOSpace, ''), '!@#$%^&*()-_=+[{]}\|:;"'',<.>/?~`', '################################'), '#', '')), ' ', ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{TitleWOSpace}', ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(TitleWOSpace, ''), '!', ''),'@',''),'#',''),'$',''),'%',''),'^',''),'&',''),'*',''),'(',''),')',''),'-',''),'_',''),'=',''),'+',''),'[',''),'{',''),']',''),'}',''),'\',''),'|',''),':',''),';',''),'"',''),'''',''),',',''),'<',''),'.',''),'>',''),'/',''),'?',''),'~',''),'`',''), ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{TitleLang3Char}', ISNULL(TitleLang3Char, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{EmbSubs3Char}', ISNULL(EmbSubs3Char, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{Version}', ISNULL(Version, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{EpisodeTitleWOSpace}', ISNULL(EpisodeTitleWOSpace, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{SeasonWOZero}', ISNULL(SeasonWOZero, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{EpisodeWOZero}', ISNULL(EpisodeWOZero, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{TitleLang2Char}', ISNULL(TitleLang2Char, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{IncrementNo5Digit}', ISNULL(IncrementNo5Digit, ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{AppendS}', IIF(ISNULL(EmbSubs3Char, '')<>'', 'S', ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{AppendSUB}', IIF(ISNULL(EmbSubs3Char, '')<>'', 'SUB', ''))
	UPDATE #TempFileName SET File_Names = REPLACE(File_Names, '{RemoveUnderscore}', IIF(ISNULL(EmbSubs3Char, '')<>'', '_', ''))
	--SELECT * FROM #TempFileName
	--RETURN
	UPDATE tbc SET tbc.Columns_Value = tfn.File_Names
	FROM #TempFileName tfn
	INNER JOIN #TempBookingContent tbc ON tfn.Title_Content_Code = tbc.Title_Content_Code AND tfn.Additional_Condition = tbc.Additional_Condition
	WHERE tbc.Target_Table = 'FileNameGeneration'
	
	DELETE FROM #TempBookingContent WHERE Display_Name = 'S' AND Rule_Type = 'M'
	DELETE FROM #TempBookingContent WHERE Display_Name = 'M' AND Rule_Type = 'S'
	
	UPDATE tbc SET tbc.Columns_Value = ale.Column_Value
	FROM #TempBookingContent tbc
	INNER JOIN VWALTitleRecomExt ale ON tbc.Title_Code = ale.Record_Code AND tbc.Additional_Condition = CAST(ale.Columns_Code AS varchar(100)) --ale.Columns_Code 
	WHERE ale.Table_Name = 'TITLE' AND tbc.Target_Table = 'VWALTitleRecomExt' 
	
	--------- Studio updation
	UPDATE tbc SET tbc.Columns_Value = ale.Column_Value
	FROM #TempBookingContent tbc
		INNER JOIN VWALTitleRecomExt ale ON tbc.Title_Code = ale.Record_Code 
	WHERE ale.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Banner_Value') 
		AND tbc.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Studio_Value') 
		AND ISNULL(ale.Column_Value,'') <> '';
	----------

	--------- Distributor updation
	UPDATE tbc SET tbc.Columns_Value = v.Vendor_Name
	FROM #TempBookingContent tbc
		INNER JOIN VWALTitleRecomExt ale ON tbc.Title_Code = ale.Record_Code  
		INNER JOIN Banner b ON b.Banner_Name = ale.Column_Value
		INNER JOIN AL_Vendor_Details avd ON avd.Banner_Codes = b.Banner_Code
		INNER JOIN Vendor v ON v.Vendor_Code = avd.Vendor_Code
	WHERE ale.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Banner_Value') 
		AND tbc.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Distributor_Value')  
		AND ISNULL(ale.Column_Value,'') <> '';
	----------

	--------- Lab updation
	UPDATE tbc SET tbc.Columns_Value = ale.Column_Value
	FROM #TempBookingContent tbc
		INNER JOIN VWALTitleRecomExt ale ON tbc.Title_Code = ale.Record_Code 
	WHERE ale.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Lab_Value') 
		AND tbc.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Lab_Value') 
		AND ISNULL(ale.Column_Value,'') <> '';
	----------

	--------- Version updation
	UPDATE tbc SET tbc.Columns_Value = ale.Column_Value
	FROM #TempBookingContent tbc
		INNER JOIN VWALTitleRecomExt ale ON tbc.Title_Code = ale.Record_Code 
	WHERE ale.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Version_Value') 
		AND tbc.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Version_Value') 
		AND ISNULL(ale.Column_Value,'') <> '';
	----------

	--------- MPAA Rating Updation
	UPDATE tbc SET tbc.Columns_Value = ale.Column_Value
	FROM #TempBookingContent tbc
		INNER JOIN VWALTitleRecomExt ale ON tbc.Title_Code = ale.Record_Code 
	WHERE ale.Columns_Code IN (41) 
		AND tbc.Columns_Code IN (71) 
		AND ISNULL(ale.Column_Value,'') <> '';
	----------

	UPDATE tbc SET tbc.Columns_Value = ale.Column_Value
	FROM #TempBookingContent tbc
	INNER JOIN VWALTitleRecomExt ale ON tbc.Additional_Condition = CAST(ale.Columns_Code AS varchar(100)) --ale.Columns_Code
	WHERE ale.Table_Name = 'AL_OEM' AND tbc.Target_Table = 'VWALTitleRecomExt' 
	
	UPDATE tbc SET tbc.Columns_Value = unpvt.ColumnValue
	FROM #TempBookingContent tbc
	INNER JOIN (
		SELECT Title_Code, Title_Content_Code, ColumnNames, ColumnValue FROM
		(
			SELECT * FROM VWALTitleRecom WHERE AL_Recommendation_Code = @RecommendationCode
		) p
		UNPIVOT
		(
			ColumnValue FOR ColumnNames IN([Airline], [Title_Name], [Deal_Type_Name], [Year_Of_Production], 
				[Language_Name], [Star_Cast], [Director], [Country], [Genre], [Synopsis], [Synopsis_Length], 
				[Runtime], [Runtime_Seconds], [Episode_Title], [Episode_No], [Episode_Synopsis], 
				[Episode_Synopsis_Length], [Start_Date], [End_Date], [Lic_End_Date], [Status], [Rule_Name])
		) AS upvt
	) unpvt ON tbc.Title_Code = unpvt.Title_Code AND tbc.Title_Content_Code = unpvt.Title_Content_Code 
			   AND unpvt.ColumnNames COLLATE Latin1_General_CI_AI = tbc.Target_Column COLLATE Latin1_General_CI_AI
	WHERE Target_Table = 'VWALTitleRecom'
	
	UPDATE #TempBookingContent SET Columns_Value = '' WHERE Allow_Import = 'I'

	INSERT INTO AL_Booking_Sheet_Details(AL_Booking_Sheet_Code, Title_Code, Title_Content_Code, Extended_Group_Code, Columns_Code, 
			Group_Control_Order, Validations, Additional_Condition, Display_Name, Allow_Import, 
			Columns_Value, 
			Cell_Status, Action_By, Action_Date)
	SELECT @BookingSheetCode, Title_Code, Title_Content_Code, @Extended_Group_ForBookingSheet, Columns_Code,
		   Group_Control_Order, Validations, Additional_Condition, Display_Name, Allow_Import, 
		   CASE WHEN Content_Status = 'D' AND Validations like '%0%' THEN 'remove' ELSE Columns_Value END, -- Validations = '0 & 1'
		   CASE WHEN Allow_Import = 'I' THEN 'P' ELSE 'C' END, 143, GETDATE()
	FROM #TempBookingContent tbc

	UPDATE AL_Booking_Sheet SET Record_Status = 'I', Movie_Content_Count = @MovieCount, Show_Content_Count = @ShowCount 
	WHERE AL_Booking_Sheet_Code = @BookingSheetCode
	
	IF OBJECT_ID('tempdb..#TempBookingContent') IS NOT NULL DROP TABLE #TempBookingContent
	IF OBJECT_ID('tempdb..#TempBookingDataToGen') IS NOT NULL DROP TABLE #TempBookingDataToGen
	IF OBJECT_ID('tempdb..#TempFileName') IS NOT NULL DROP TABLE #TempFileName

END
