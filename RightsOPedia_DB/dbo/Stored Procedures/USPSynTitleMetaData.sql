CREATE PROCEDURE [dbo].[USPSynTitleMetaData]
(
	@TitleCode VARCHAR(MAX)	
)
AS
BEGIN
--DECLARE
--@TitleCode VARCHAR(MAX) = '7677'	
	
	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
	IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#UITitle') IS NOT NULL DROP TABLE #UITitle
	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP 
	IF OBJECT_ID('tempdb..#TempCensorDetails') IS NOT NULL DROP TABLE #TempCensorDetails	
	IF OBJECT_ID('tempdb..#TempIMDB') IS NOT NULL DROP TABLE #TempIMDB	
	

	--DECLARE @TitleCode VARCHAR(MAX) = '255,269'

	CREATE TABLE #TempTitle
	(
		Title_Code INT,
		Title_Name NVARCHAR(1000),
		Title_Language NVARCHAR(1000),
		YOR NVARCHAR(1000),
		Duration NVARCHAR(20),
		StarCast NVARCHAR(1000),
		Genres NVARCHAR(MAX)
	)

	CREATE TABLE #UITitle
	(
		Title_Code INT
	)

	CREATE TABLE #TempOP
	(
		ColValue NVARCHAR(100),
		KeyField NVARCHAR(100),
		FieldOrder INT
	)

	CREATE TABLE #TempCensorDetails
	(
		Title_Code INT,
		Columns_Code INT,
		Columns_Value NVARCHAR(100)
	)

	CREATE TABLE #TempIMDB
	(
		Title_Code INT,
		IMDB NVARCHAR(100)
	)

	CREATE TABLE #TempOutput
	(
		Title_Code INT,
		Vendor_Name NVARCHAR(MAX),
		Syn_Deal_Code INT,
		COL1 NVARCHAR(MAX),
		COL2 NVARCHAR(MAX),
		COL3 NVARCHAR(MAX),
		COL4 NVARCHAR(MAX),
		COL5 NVARCHAR(MAX),
		COL6 NVARCHAR(MAX),
		COL7 NVARCHAR(MAX),
		COL8 NVARCHAR(MAX),
		COL9 NVARCHAR(MAX)
	)


	INSERT INTO #UITitle(Title_Code)
	SELECT number from dbo.[UFNSplit](@TitleCode, ',') WHERE number IS NOT NULL

	DECLARE @IsProgram VARCHAR(2)= 'N'
	
	IF EXISTS(	
				SELECT * FROM Title t 
				INNER JOIN #UITitle ut ON t.Title_Code = ut.Title_Code
				WHERE t.Deal_Type_Code IN (11)
			)
	BEGIN
		SET @IsProgram = 'Y'
	END

	DECLARE  @TableColumns VARCHAR(1000) = '', @OutputCols NVARCHAR(MAX) = ''

	IF (@IsProgram = 'Y')
	BEGIN
		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder)
		SELECT 'COL1',  'Title Name', 1
		UNION
		SELECT 'COL2',  'Title Language', 2
		UNION
		SELECT 'COL3',  'YOR', 3
		UNION
		SELECT 'COL4', 'Duration', 4
		UNION
		SELECT 'COL5', 'Star Cast', 5
		UNION
		SELECT 'COL6', 'Genres', 6
		UNION
		SELECT 'COL7', 'Censor Details', 7
		UNION
		SELECT 'COL8', 'No. Of Episodes', 8
		UNION
		SELECT 'COL9', 'IMDB', 9

		SET @OutputCols = 'COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9'
			
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Title_Name, Title_Language, YOR, Duration, [StarCast], Genres, Columns_Value, SUM((Episode_To - Episode_From) + 1) EpisodesCnt, IMDB'
	END
	ELSE
	BEGIN

		INSERT INTO #TempOP(ColValue, KeyField, FieldOrder)
		SELECT 'COL1',  'Title Name', 1
		UNION
		SELECT 'COL2',  'Title Language', 2
		UNION
		SELECT 'COL3',  'YOR', 3
		UNION
		SELECT 'COL4', 'Duration', 4
		UNION
		SELECT 'COL5', 'Star Cast', 5
		UNION
		SELECT 'COL6', 'Genres', 6
		UNION
		SELECT 'COL7', 'Censor Details', 7
		UNION
		SELECT 'COL8', 'IMDB', 8

		SET @OutputCols = 'COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8'
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Title_Name, Title_Language, YOR, Duration, [StarCast], Genres, Columns_Value, IMDB'

	END
	
	
	INSERT INTO #TempTitle(Title_Code, Title_Name, Title_Language, YOR, Duration, StarCast, Genres)
	SELECT tm.Title_Code, Title_Name, Title_Language, YOR, CAST(Duration AS INT), StarCast, Genres
	FROM TitleMetadata tm
	INNER JOIN #UITitle tt ON tt.Title_Code = tm.Title_Code

	INSERT INTO #TempCensorDetails(Title_Code, Columns_Code, Columns_Value)
	SELECT uit.Title_Code, mec.Columns_Code, ecv.Columns_Value FROM #UITitle uit
	INNER JOIN Map_Extended_Columns mec ON mec.Record_Code = uit.Title_Code
	INNER JOIN Extended_Columns_Value ecv ON ecv.Columns_Value_Code = mec.Columns_Value_Code

	INSERT INTO #TempIMDB(Title_Code,IMDB)
	SELECT uit.Title_Code, mec.Column_Value
	FROM #UITitle uit
	INNER JOIN Map_Extended_Columns mec ON mec.Record_Code = uit.Title_Code

	DECLARE @OutputSQL NVARCHAR(MAX) = ''
	
	IF(@IsProgram = 'Y')
	BEGIN
		
		SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code, Vendor_Name, Syn_Deal_Code,' + @OutputCols + ')
		SELECT DISTINCT tt.Title_Code, v.Vendor_Name, tr.Syn_Deal_Code, ' + @TableColumns + '
		FROM #TempTitle tt
		INNER JOIN SynTitleRights tr ON tr.Title_Code = tt.Title_Code
		INNER JOIN Vendor v ON v.Vendor_Code = tr.Vendor_Code
		LEFT JOIN #TempCensorDetails tcd ON tcd.Title_Code = tr.Title_Code AND tcd.Columns_Code = 5
		LEFT JOIN #TempIMDB timdb ON timdb.Title_Code = tr.Title_Code
		WHERE tr.Actual_Right_End_Date > GETDATE()
		GROUP BY tt.Title_Code,tt.Title_Code, v.Vendor_Name, tr.Syn_Deal_Code, Title_Name, Title_Language, YOR, Duration, [StarCast], Genres, Columns_Value, IMDB'

		EXEC(@OutputSQL)
		
		SELECT Title_Code AS TitleCode, Syn_Deal_Code AS DealCode, Licensor, KeyField, ValueFields AS ValueField, FieldOrder FROM (
			SELECT u.Title_Code, u.Syn_Deal_Code, u.Vendor_Name AS Licensor, u.ColValues, u.ValueFields  FROM (
				SELECT Title_Code, Vendor_Name, Syn_Deal_Code,
				ISNULL(COL1, 'No') AS COL1, ISNULL(COL2, 'No') AS COL2, ISNULL(COL3, 'No') AS COL3, ISNULL(COL4, 'No') AS COL4, ISNULL(COL5, 'No') AS COL5, 	
				ISNULL(COL6, 'No') AS COL6, ISNULL(COL7, 'No') AS COL7, ISNULL(COL8, 'No') AS COL8, ISNULL(COL9, 'NA') AS COL9
				FROM #TempOutput
				) AS s
				UNPIVOT 
				(
					ValueFields
					FOR ColValues IN (
						COL1, COL2, COL3, COL4, COL5, 
						COL6, COL7, COL8, COL9
					)
				) AS u
			) AS unpout
		INNER JOIN #TempOP op ON unpout.ColValues COLLATE Database_Default = op.ColValue COLLATE Database_Default
		ORDER BY Title_Code, FieldOrder

	END
	ELSE
	BEGIN
		
		SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code, Vendor_Name, Syn_Deal_Code,' + @OutputCols + ')
		SELECT DISTINCT tt.Title_Code, v.Vendor_Name, tr.Syn_Deal_Code, ' + @TableColumns + '
		FROM #TempTitle tt
		INNER JOIN SynTitleRights tr ON tr.Title_Code = tt.Title_Code
		INNER JOIN Vendor v ON v.Vendor_Code = tr.Vendor_Code
		LEFT JOIN #TempCensorDetails tcd ON tcd.Title_Code = tr.Title_Code AND tcd.Columns_Code = 5
		LEFT JOIN #TempIMDB timdb ON timdb.Title_Code = tr.Title_Code
		WHERE tr.Actual_Right_End_Date > GETDATE()'
		
		EXEC(@OutputSQL)

		
		SELECT Title_Code AS TitleCode, Syn_Deal_Code AS DealCode, Licensor, KeyField, ValueFields AS ValueField, FieldOrder FROM (
			SELECT u.Title_Code, u.Syn_Deal_Code, u.Vendor_Name AS Licensor, u.ColValues, u.ValueFields  FROM (
				SELECT Title_Code, Vendor_Name, Syn_Deal_Code,
				ISNULL(COL1, 'No') AS COL1, ISNULL(COL2, 'No') AS COL2, ISNULL(COL3, 'No') AS COL3, ISNULL(COL4, 'No') AS COL4, ISNULL(COL5, 'No') AS COL5, 	
				ISNULL(COL6, 'No') AS COL6, ISNULL(COL7, 'No') AS COL7, ISNULL(COL8, 'NA') AS COL8
				FROM #TempOutput
				) AS s
				UNPIVOT 
				(
					ValueFields
					FOR ColValues IN (
						COL1, COL2, COL3, COL4, COL5, 
						COL6, COL7, COL8
					)
				) AS u
			) AS unpout
		INNER JOIN #TempOP op ON unpout.ColValues COLLATE Database_Default = op.ColValue COLLATE Database_Default
		ORDER BY Title_Code, FieldOrder

	END
	
	
	
	

	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
	IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#UITitle') IS NOT NULL DROP TABLE #UITitle
	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP	
	IF OBJECT_ID('tempdb..#TempCensorDetails') IS NOT NULL DROP TABLE #TempCensorDetails

END