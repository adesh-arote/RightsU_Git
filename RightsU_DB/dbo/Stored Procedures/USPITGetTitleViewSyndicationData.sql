CREATE PROCEDURE [dbo].[USPITGetTitleViewSyndicationData]
(
	@TitleCode VARCHAR(MAX)	
)
AS
BEGIN
Declare @Loglevel int;
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewSyndicationData]', 'Step 1', 0, 'Started Procedure', 0, ''

	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP
    IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform

	DECLARE @OutputSQL NVARCHAR(MAX) = ''
	DECLARE  @TableColumns VARCHAR(MAX) = '', @OutputCols NVARCHAR(MAX) = ''

	CREATE TABLE #TempPlatform
	(
		AcqDealRightsCode INT,
		Platform_Name NVARCHAR(MAX),
		Cnt INT,
		Platform_Code  NVARCHAR(MAX)
	)

	CREATE TABLE #TempOP
	(
		ColValue NVARCHAR(100),
		KeyField NVARCHAR(100),
		FieldOrder INT
	)

	CREATE TABLE #TempOutput
	(
	    Title_Code NVARCHAR(MAX),
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
		Deal_Rights_Code NVARCHAR(MAX)
	)

	IF EXISTS(SELECT TOP 1 * FROM Acq_Deal_Rights_Title (NOLOCK) WHERE Title_Code = @TitleCode)
	BEGIN
		INSERT INTO #TempPlatform
		SELECT DISTINCT adrp.Syn_Deal_Rights_Code, p.Platform_Hiearachy, count(adrp.Syn_Deal_Rights_Code),
		STUFF((SELECT ', '+ CONVERT(NVARCHAR(MAX),pf.Platform_Name) FROM Syn_Deal_Rights_Platform ad (NOLOCK) INNER JOIN Platform pf (NOLOCK) ON ad.Platform_Code=pf.Platform_Code WHERE Syn_Deal_Rights_Code IN (Select Syn_Deal_Rights_Code from Syn_Deal_Rights_Title (NOLOCK) where Title_Code = @TitleCode AND Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code) FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ' )
		FROM Syn_Deal_Rights_Platform adrp (NOLOCK)
		INNER JOIN Platform p  (NOLOCK) on p.Platform_Code = (SELECT TOP 1 Platform_Code FROM Syn_Deal_Rights_Platform (NOLOCK) WHERE Syn_Deal_Rights_Code = adrp.Syn_Deal_Rights_Code)
		GROUP BY adrp.Syn_Deal_Rights_Code, p.Platform_Hiearachy
		HAVING adrp.Syn_Deal_Rights_Code IN (Select Syn_Deal_Rights_Code from Syn_Deal_Rights_Title (NOLOCK) where Title_Code = @TitleCode)
		ORDER BY adrp.Syn_Deal_Rights_Code

		UPDATE #TempPlatform
		SET Platform_Name = ISNULL(Platform_Name, '') + '|' + CAST(Cnt AS VARCHAR(16))

	END
	ELSE
	BEGIN
		INSERT INTO #TempPlatform
		SELECT 0,'None',0,''

		UPDATE #TempPlatform
		SET Platform_Name = ISNULL(Platform_Name, '') + '|' + CAST(Cnt AS VARCHAR(16))

	END	

	INSERT INTO #TempOP(ColValue, KeyField, FieldOrder)
	
		SELECT 'COL1',  'Agreement No', 1
		UNION
		SELECT 'COL2',  'Platform', 2
		UNION
		SELECT 'COL3', 'Licensee', 3
		UNION
		SELECT 'COL4', 'Deal active or expired', 4
		UNION
		SELECT 'COL5', 'Exclusivity', 5
		UNION
		SELECT 'COL6', 'License Period Term', 6
		UNION
		SELECT 'COL7', 'Deal Description', 7
		UNION
		SELECT 'COL8', 'Country/Territory', 8
		UNION
		SELECT 'COL9', 'Deal Rights Code', 9
		UNION
		SELECT 'COL10', 'Platform Code', 10
		UNION
		SELECT 'COL11', 'Title Language', 11
		UNION
		SELECT 'COL12', 'Dubbing Language', 12
		UNION
		SELECT 'COL13', 'Subtitling Language', 13

	SET @OutputCols = 'COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13'
	IF(@TableColumns <> '')
	SET @TableColumns = @TableColumns + ', '

	SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code,' + @OutputCols + ', Deal_Rights_Code)
		              SELECT DISTINCT  t.Title_Code,' + 'Agreement_No, tp.Platform_Name AS Platform, STUFF((SELECT DISTINCT '', ''+ (Vendor_Name) FROM Syn_Deal sdInn (NOLOCK) INNER JOIN Syn_Deal_Rights sdr (NOLOCK) ON sdInn.Syn_Deal_Code = sdr.Syn_Deal_Code INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code INNER JOIN Title t (NOLOCK) ON t.Title_Code = sdrt.Title_Code 
	                  LEFT JOIN Vendor v (NOLOCK) ON v.Vendor_Code = sd.Vendor_Code FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Vendor_Name , CASE WHEN (ISNULL(sdr.Actual_Right_End_Date,''31DEC9999'') > GETDATE() AND sd.Is_Active = ''Y'') THEN ''Active'' ELSE ''Expired'' END AS Deal_Is_Active, CASE WHEN sdr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN sdr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END AS Exclusivity, 
	                  [dbo].[UFN_Get_Rights_Term](sdr.Actual_Right_Start_Date, sdr.Actual_Right_End_Date, '''') AS Term, Deal_Description, STUFF((SELECT DISTINCT '', ''+ (CASE WHEN sdrte.Territory_Type = ''G'' THEN te.Territory_Name ELSE c.Country_Name END) FROM Syn_Deal_Rights_Territory sdrte (NOLOCK) LEFT JOIN Country c (NOLOCK) ON c.Country_Code=sdrte.Country_Code LEFT JOIN Territory te (NOLOCK) ON te.Territory_Code=sdrte.Territory_Code WHERE sdrte.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
					  FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Country_Name, sdr.Syn_Deal_Rights_Code, tp.Platform_Code, ln.Language_Name AS Title_Language, STUFF((SELECT DISTINCT '', ''+ (CASE WHEN sdrd.Language_Type = ''G'' THEN lg.Language_Group_Name ELSE ln.Language_Name END) FROM Syn_Deal_Rights_Dubbing sdrd (NOLOCK) LEFT JOIN Language_Group lg  (NOLOCK) ON sdrd.Language_Group_Code = lg.Language_Group_Code LEFT JOIN Language ln (NOLOCK) ON sdrd.Language_Code = ln.Language_Code WHERE sdrd.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Dubbing_Language, STUFF((SELECT DISTINCT '', ''+ (CASE WHEN sdrs.Language_Type = ''G'' THEN lg.Language_Group_Name ELSE ln.Language_Name END) FROM Syn_Deal_Rights_Subtitling sdrs (NOLOCK)
					  LEFT JOIN Language_Group lg (NOLOCK) ON sdrs.Language_Group_Code = lg.Language_Group_Code LEFT JOIN Language ln (NOLOCK) ON sdrs.Language_Code = ln.Language_Code WHERE sdrs.Syn_Deal_Rights_Code  = sdr.Syn_Deal_Rights_Code FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Subtitling_Language, sdr.Syn_Deal_Rights_Code' + ' 
					  FROM Syn_Deal sd  (NOLOCK)
						  INNER JOIN Syn_Deal_Rights sdr (NOLOCK) ON sd.Syn_Deal_Code = sdr.Syn_Deal_Code
						  INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
						  INNER JOIN Title t (NOLOCK) ON t.Title_Code = sdrt.Title_Code AND t.Title_Code IN ('+@TitleCode+')
						  INNER JOIN Language ln (NOLOCK) ON ln.Language_Code = t.Title_Language_Code
						  LEFT JOIN #TempPlatform tp ON tp.AcqDealRightsCode = sdrt.Syn_Deal_Rights_Code'
    Print @OutputSQL;
	EXEC(@OutputSQL)

	SELECT  Title_Code AS TitleCode,KeyField, ValueFields AS ValueField, FieldOrder, Deal_Rights_Code FROM (
			SELECT u.Title_Code, u.ColValues, u.ValueFields, Deal_Rights_Code  FROM (
				SELECT Title_Code,
				ISNULL(COL1, 'No') AS COL1, ISNULL(COL2, 'No') AS COL2, ISNULL(COL3, 'No') AS COL3, ISNULL(COL4, 'No') AS COL4, ISNULL(COL5, 'No') AS COL5, 	
				ISNULL(COL6, 'No') AS COL6, ISNULL(COL7, 'No') AS COL7, ISNULL(COL8, 'No') AS COL8, ISNULL(COL9, 0) AS COL9, ISNULL(COL10, 0) AS COL10, ISNULL(COL11, 'No') AS COL11, ISNULL(COL12, 'No') AS COL12, ISNULL(COL13, 'No') AS COL13, Deal_Rights_Code
				FROM #TempOutput
				) AS s
				UNPIVOT 
				(
					ValueFields
					FOR ColValues IN (
						COL1, COL2, COL3, COL4, COL5, COL6,
						COL7, COL8, COL9, COL10, COL11, COL12, COL13
					)
				) AS u
			) AS unpout
		INNER JOIN #TempOP op ON unpout.ColValues COLLATE Database_Default = op.ColValue COLLATE Database_Default
		ORDER BY Title_Code, FieldOrder

		IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP
        IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
		IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewSyndicationData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END