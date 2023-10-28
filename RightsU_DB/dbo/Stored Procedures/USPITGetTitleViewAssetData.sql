CREATE PROCEDURE [dbo].[USPITGetTitleViewAssetData]
(
	@TitleCode VARCHAR(MAX)	
)
AS
BEGIN
Declare @Loglevel int;
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewAssetData]', 'Step 1', 0, 'Started Procedure', 0, ''    
	IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP
    IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput

	DECLARE @IsParent VARCHAR(2)= 'N'
	DECLARE @IsChild VARCHAR(2)= 'N'
	DECLARE @ParentTitleCode VARCHAR(MAX)
	DECLARE @ChildTitleCode VARCHAR(MAX)
	DECLARE @OutputSQL NVARCHAR(MAX) = ''

	DECLARE  @TableColumns VARCHAR(MAX) = '', @OutputCols NVARCHAR(MAX) = ''

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
		COL13 NVARCHAR(MAX)
	)

	INSERT INTO #TempOP(ColValue, KeyField, FieldOrder)
	
		SELECT 'COL1',  'Original/Dubbed', 2
		UNION
		SELECT 'COL2',  'Title Name', 3
		UNION
		SELECT 'COL3', 'Title Language', 4
		UNION
		SELECT 'COL4', 'Year of Release', 5
		UNION
		SELECT 'COL5', 'Title Type', 6
		UNION
		SELECT 'COL6', 'Genre', 7
		UNION
		SELECT 'COL7', 'Duration', 8
		UNION
		SELECT 'COL8', 'Star Cast', 9
		UNION
		SELECT 'COL9', 'Director', 10
		UNION
		SELECT 'COL10', 'Producer', 11
		UNION
		SELECT 'COL11', 'Original CBFC Rating', 12
		UNION
		SELECT 'COL12', 'Dubbed CBFC Rating', 13
		UNION
		SELECT 'COL13', 'Original Title Name', 1

	SET @OutputCols = 'COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13'
	IF(@TableColumns <> '')
	SET @TableColumns = @TableColumns + ', '
	SET @TableColumns = @TableColumns + 'Title_Name, Language_Name, Year_Of_Production, Deal_Type_Name, STUFF((SELECT '', ''+ CONVERT(NVARCHAR(MAX),g.Genres_Name) FROM Genres g (NOLOCK) INNER JOIN Title_Geners tg (NOLOCK) ON g.Genres_Code = tg.Genres_Code WHERE tg.Title_Code = t.Title_Code FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Genres_Name, Duration_In_Min, STUFF((SELECT '', ''+ tl.Talent_Name FROM Title_Talent tt1 (NOLOCK) INNER JOIN Talent tl (NOLOCK) ON tl.Talent_Code =tt1.Talent_Code AND Role_Code = (Select TOP 1 Role_Code FROM Role r (NOLOCK) where r.Role_Name = ''Star Cast'' ) WHERE tt1.Title_Code = tt.Title_Code FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Talent_Name, STUFF((SELECT '', ''+ tl.Talent_Name FROM Title_Talent tt1 (NOLOCK) INNER JOIN Talent tl (NOLOCK) ON tl.Talent_Code =tt1.Talent_Code AND Role_Code = (Select TOP 1 Role_Code FROM Role r (NOLOCK) where r.Role_Name = ''Director'' ) WHERE tt1.Title_Code = tt.Title_Code FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Director, STUFF((SELECT '', ''+ tl.Talent_Name FROM Title_Talent tt1 (NOLOCK) INNER JOIN Talent tl (NOLOCK) ON tl.Talent_Code =tt1.Talent_Code AND Role_Code = (Select TOP 1 Role_Code FROM Role r (NOLOCK) where r.Role_Name = ''Producer'' ) WHERE tt1.Title_Code = tt.Title_Code FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '' ) AS Producer,
	                                     (SELECT TOP 1 ECV.Columns_Value FROM Map_Extended_Columns MEC (NOLOCK) INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code INNER JOIN Extended_Columns_Value ECV (NOLOCK) ON ECV.Columns_Value_Code = MEC.Columns_Value_Code WHERE MEC.Record_Code = tt.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = (Select top 1 Parameter_Value from System_Parameter_New where Parameter_Name = ''Original_CBFC_Rating_Name''))) AS Original_CBFC_Rating, (SELECT TOP 1 ECV.Columns_Value FROM Map_Extended_Columns MEC (NOLOCK) INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code INNER JOIN Extended_Columns_Value ECV (NOLOCK) ON ECV.Columns_Value_Code = MEC.Columns_Value_Code WHERE MEC.Record_Code = tt.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = (Select top 1 Parameter_Value from System_Parameter_New where Parameter_Name = ''Dubbed_CBFC_Rating_Name''))) AS Dubbed_CBFC_Rating, CASE WHEN Original_Title = '''' THEN NULL ELSE Original_Title END AS Original_Title'

    IF EXISTS(SELECT null FROM Title t (NOLOCK) where t.Original_Title_Code = @TitleCode )
		BEGIN
			SET @IsParent = 'Y'
			SET @ParentTitleCode = @TitleCode
		END
    ELSE IF EXISTS(SELECT null FROM Title t (NOLOCK) where t.Title_Code = @TitleCode AND ISNULL(t.Original_Title_Code,0) != 0 )
	    BEGIN
		    SET @IsChild = 'Y'
		    SELECT @ParentTitleCode = t.Original_Title_Code FROM Title t (NOLOCK) where t.Title_Code = @TitleCode
			SET @ChildTitleCode = @TitleCode
		END
	ELSE
		BEGIN
		    SET @ParentTitleCode = @TitleCode
		END

	IF(@IsParent = 'Y')
		BEGIN	
				
		SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code,' + @OutputCols + ')
		SELECT DISTINCT  t.Title_Code,''Original'' AS Original,' + @TableColumns + ' 
		FROM Title t  (NOLOCK)
			   LEFT JOIN Language l (NOLOCK) ON l.Language_Code=t.Title_Language_Code
			   LEFT JOIN Deal_Type dt (NOLOCK) ON t.Deal_Type_Code = dt.Deal_Type_Code
			   LEFT JOIN Title_Talent tt (NOLOCK) ON tt.Title_Code = t.Title_Code 
			   LEFT JOIN Talent tl (NOLOCK) ON tl.Talent_Code = tt.Talent_Code			   
			WHERE t.Title_Code IN ('+@ParentTitleCode+')
			UNION 
			SELECT DISTINCT t.Title_Code, ''Dubbed'' AS Original,'+ @TableColumns +' 
		    FROM Title t  (NOLOCK)
			   LEFT JOIN Language l (NOLOCK) ON l.Language_Code=t.Title_Language_Code
			   LEFT JOIN Deal_Type dt (NOLOCK) ON t.Deal_Type_Code = dt.Deal_Type_Code
			   LEFT JOIN Title_Talent tt (NOLOCK) ON tt.Title_Code = t.Title_Code 
			   LEFT JOIN Talent tl (NOLOCK) ON tl.Talent_Code = tt.Talent_Code			   
			WHERE t.Original_Title_Code IN ('+@TitleCode+')'
			print @OutputSQL
		EXEC(@OutputSQL)		

		END
    ELSE IF (@IsChild = 'Y')
		BEGIN

		SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code,' + @OutputCols + ')
		SELECT DISTINCT  t.Title_Code,''Original'' AS Original,' + @TableColumns + '
		FROM Title t  (NOLOCK)
			   LEFT JOIN Language l (NOLOCK) ON l.Language_Code=t.Title_Language_Code
			   LEFT JOIN Deal_Type dt (NOLOCK) ON t.Deal_Type_Code = dt.Deal_Type_Code
			   LEFT JOIN Title_Talent tt (NOLOCK) ON tt.Title_Code = t.Title_Code 
			   LEFT JOIN Talent tl (NOLOCK) ON tl.Talent_Code = tt.Talent_Code			   
			WHERE t.Title_Code IN ('+@ParentTitleCode+')
			UNION 
			SELECT DISTINCT t.Title_Code, ''Dubbed'' AS Original,'+ @TableColumns +' 
		    FROM Title t  (NOLOCK)
			   LEFT JOIN Language l (NOLOCK) ON l.Language_Code=t.Title_Language_Code
			   LEFT JOIN Deal_Type dt (NOLOCK) ON t.Deal_Type_Code = dt.Deal_Type_Code
			   LEFT JOIN Title_Talent tt (NOLOCK) ON tt.Title_Code = t.Title_Code 
			   LEFT JOIN Talent tl (NOLOCK) ON tl.Talent_Code = tt.Talent_Code			   
			WHERE t.Title_Code IN ('+@ChildTitleCode+')' -- t.Original_Title_Code IN ('+@ParentTitleCode+')'

		EXEC(@OutputSQL)
		END
    ELSE 
		BEGIN

		SET @OutputSQL = 'INSERT INTO #TempOutput(Title_Code,' + @OutputCols + ')
		SELECT DISTINCT  t.Title_Code,''Original'' AS Original,' + @TableColumns + '
		FROM Title t  (NOLOCK)
			   LEFT JOIN Language l (NOLOCK) ON l.Language_Code=t.Title_Language_Code
			   LEFT JOIN Deal_Type dt (NOLOCK) ON t.Deal_Type_Code = dt.Deal_Type_Code
			   LEFT JOIN Title_Talent tt (NOLOCK) ON tt.Title_Code = t.Title_Code 
			   LEFT JOIN Talent tl (NOLOCK) ON tl.Talent_Code = tt.Talent_Code			   
			WHERE t.Title_Code IN ('+@ParentTitleCode+')'

		EXEC(@OutputSQL)

		END

	SELECT  Title_Code AS TitleCode,KeyField, ValueFields AS ValueField, FieldOrder FROM (
			SELECT u.Title_Code, u.ColValues, u.ValueFields  FROM (
				SELECT Title_Code,
				ISNULL(COL1, 'NA') AS COL1, ISNULL(COL2, 'NA') AS COL2, ISNULL(COL3, 'NA') AS COL3, ISNULL(COL4, 'NA') AS COL4, ISNULL(COL5, 'NA') AS COL5, 	
				ISNULL(COL6, 'NA') AS COL6, ISNULL(COL7, 'NA') AS COL7, ISNULL(COL8, 'NA') AS COL8, ISNULL(COL9, 'NA') AS COL9, ISNULL(COL10, 'NA') AS COL10,
				ISNULL(COL11, 'NA') AS COL11, ISNULL(COL12, 'NA') AS COL12, ISNULL(COL13, '-') AS COL13
				FROM #TempOutput
				) AS s
				UNPIVOT 
				(
					ValueFields
					FOR ColValues IN (
						COL1, COL2, COL3, COL4, COL5, 
						COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13
					)
				) AS u
			) AS unpout
		INNER JOIN #TempOP op ON unpout.ColValues COLLATE Database_Default = op.ColValue COLLATE Database_Default
		ORDER BY Title_Code, FieldOrder

		IF OBJECT_ID('tempdb..#TempOP') IS NOT NULL DROP TABLE #TempOP
        IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewAssetData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END