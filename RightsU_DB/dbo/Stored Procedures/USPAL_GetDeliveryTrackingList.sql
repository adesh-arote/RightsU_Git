CREATE Procedure [dbo].[USPAL_GetDeliveryTrackingList](@Client VARCHAR(MAX), @Cycle VARCHAR(100), @AL_Lab_Code VARCHAR(MAX), @Distributor VARCHAR(MAX), @Display VARCHAR(1), @TabName CHAR(1), @IncludeHoldover CHAR(1))
AS
BEGIN

	--DECLARE 
	--@Client VARCHAR(MAX) = '', @Cycle VARCHAR(100) = '', @AL_Lab_Code VARCHAR(MAX) = '', @Distributor VARCHAR(MAX) = '', @Display VARCHAR(1) = '', @TabName CHAR(1) = 'M'
	IF(OBJECT_ID('tempdb..#TempOutput_Data') IS NOT NULL) DROP TABLE #TempOutput_Data
	IF(OBJECT_ID('tempdb..#tmpDealType') IS NOT NULL) DROP TABLE #tmpDealType
	IF(OBJECT_ID('tempdb..#tempDataMovies') IS NOT NULL) DROP TABLE #tempDataMovies
	IF(OBJECT_ID('tempdb..#tempHeaders') IS NOT NULL) DROP TABLE #tempHeaders
	IF(OBJECT_ID('tempdb..#tempDate') IS NOT NULL) DROP TABLE #tempDate

	CREATE TABLE #TempOutput_Data
	(
	    AL_Material_Tracking_Code VARCHAR(MAX),
	    Title_Name VARCHAR(MAX),
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
	    COL20 NVARCHAR(MAX)
	)

	CREATE TABLE #tempDataMovies(
	    [0ID] VARCHAR(10),
	    Titles NVARCHAR(MAX),
	    [Season] VARCHAR(100),
	    [Episode No] VARCHAR(10),
	    [Episode Title] NVARCHAR(MAX),
	    Distributor VARCHAR(100),
	    Lab VARCHAR(100),
	    [PO Numbers] VARCHAR(100),
	    [PO Status] VARCHAR(100),
	    [OEM] VARCHAR(100),
	    [OEM File Name] VARCHAR(1000),
	    [Delivered Date] VARCHAR(100),
	    Poster VARCHAR(100),
	    Still VARCHAR(100),
	    Trailer VARCHAR(100),
	    [Embedded Subs] VARCHAR(100),
	    [Edited Poster] VARCHAR(100),
	    [Edited Still] VARCHAR(100),
	    [Due Date] VARCHAR(100),
	    [Status] VARCHAR(100),
		[Content Status] VARCHAR(20)
	)

	CREATE TABLE #tempHeaders(
	    ColNames NVARCHAR(MAX)       
	)

	CREATE TABLE #tmpDealType(
	    Deal_Type_Code INT
	)

	CREATE TABLE #tempDate
	(
	    RowNum INT,
	    number INT
	)

	INSERT INTO #tempDate(RowNum, number)
	select ROW_NUMBER() OVER (ORDER BY number) row_num, number From dbo.fn_Split_withdelemiter(@Cycle,'-')

	DECLARE @AL_DealType_Show VARCHAR(100) = '', @AL_DealType_Movies VARCHAR(100) = '', @query nvarchar(Max) = '', @Condition nvarchar(Max) = ''

	SELECT @AL_DealType_Movies = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_DealType_Movies'
	SELECT @AL_DealType_Show = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_DealType_Show'

	IF(ISNULL(@Client, '') <> '')
    BEGIN
        SET @Condition = @Condition +'  AND bs.Vendor_Code = ' + @Client
    END
    --print @Client

	IF(ISNULL(@AL_Lab_Code, '') <> '')
    BEGIN
        SET @Condition = @Condition +'  AND l.AL_Lab_Code = ' + @AL_Lab_Code
    END

	IF(ISNULL(@Distributor, '') <> '')
    BEGIN
        SET @Condition = @Condition +'  AND v.Vendor_Code = ' + @Distributor
    END

	IF(ISNULL(@Display, '') <> '')
    BEGIN
        SET @Condition = @Condition +'  AND mt.Status = ''' + @Display + ''''
    END

	IF(ISNULL(@Cycle, '') <> '')
    BEGIN
        --SET @Condition = @Condition +'  AND  = ' + '(MONTH(ar.Start_Date) = ' + CAST((select number from #tempDate where RowNum = 1), NVARCHAR(MAX)) +' AND YEAR(ar.Start_Date) = '+ CAST((select number from #tempDate where RowNum = 2), NVARCHAR(MAX))+')'''
		SET @Condition = @Condition +' AND MONTH(ar.Start_Date) = ' + CAST((select number from #tempDate where RowNum = 1) AS NVARCHAR(MAX)) + ' AND YEAR(ar.Start_Date) = ' + CAST((select number from #tempDate where RowNum = 2) AS NVARCHAR(MAX)) + ''
    END

	DECLARE @IncludeHoldoverStr VARCHAR(MAX) = ''

	IF(@IncludeHoldover = 'N')
	BEGIN
		SET @IncludeHoldoverStr = ' AND rel.Content_Status = ''N'' '
	END
	--print @IncludeHoldoverStr
	
	IF(@TabName = 'S')
	BEGIN
                
		INSERT INTO #tmpDealType(Deal_Type_Code)
		SELECT DISTINCT Item FROM [dbo].[Split](@AL_DealType_Show, ',') WHERE ISNULL(Item, '') NOT IN ('', '0')

		SET @query = 'INSERT INTO #tempDataMovies
		SELECT DISTINCT mt.AL_Material_Tracking_Code AS [0ID], t.Title_Name AS Titles, mec.Column_Value AS [Season], tc.Episode_No AS [Episode No], tc.Episode_Title AS [Episode Title], V.Vendor_Name AS Distributer, l.AL_Lab_Name AS Lab, mt.PO_Number AS [PO Numbers], mt.PO_Status AS [PO Status],
			aom.Company_Short_Name, mt.OEM_File_Name, Format(mt.Delivery_Date,''dd-MMM-yyyy'') AS Delivery_Date, mt.Poster, mt.Still, mt.Trailer, mt.Embedded_Subs AS [Embedded Subs], mt.Edited_Poster AS [Edited Poster], Edited_Still AS [Edited Still], mt.Due_Date AS [Due Date],
			mt.Status AS [Status], rel.Content_Status AS [Content Status]
		FROM AL_Material_Tracking mt
		INNER JOIN Title t ON t.Title_Code = mt.Title_Code --AND mt.Status = ''P''
		INNER JOIN #tmpDealType dt ON t.Deal_Type_Code = dt.Deal_Type_Code
		INNER JOIN Title_Content tc ON mt.Title_Content_Code = tc.Title_Content_Code
		INNER JOIN Vendor v ON v.Vendor_Code = mt.Vendor_Code
		INNER JOIN AL_Lab l ON l.AL_Lab_Code = mt.AL_Lab_Code
		INNER JOIN AL_Load_Sheet_MT_Rel rel ON rel.AL_Material_Tracking_Code = mt.AL_Material_Tracking_Code
		INNER JOIN AL_Booking_Sheet bs ON bs.AL_Booking_Sheet_Code = rel.AL_Booking_Sheet_Code
		INNER JOIN AL_OEM aom ON aom.AL_OEM_Code = mt.AL_OEM_Code
		LEFT JOIN MAP_Extended_Columns mec ON t.Title_Code = mec.Record_Code AND mec.Table_Name = ''TITLE'' AND mec.Columns_Code = 31
		INNER JOIN AL_Recommendation ar on ar.AL_Recommendation_Code = bs.AL_Recommendation_Code
		
		WHERE 1=1' + @IncludeHoldoverStr + @Condition
		--print @query
		--print 'A'
		exec(@query);
		--print 'B'
		INSERT INTO #tempHeaders(ColNames)
		SELECT Name
		FROM tempdb.sys.columns
		WHERE object_id = Object_id('tempdb..#tempDataMovies');

		INSERT INTO #TempOutput_Data(AL_Material_Tracking_Code, Title_Name, COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14, COL15, COL16,COL17)
		Select *
		from (
		    Select ColNames, RowN = Row_Number() over (ORDER BY (SELECT NULL)) from #tempHeaders
		) a
		pivot (max(ColNames) for RowN in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19])) p
		--print 'C'
		--Select * from #tempDataMovies
		--RETURN
		--SELECT * FROM #TempOutput_Data
		EXEC('INSERT INTO #TempOutput_Data(AL_Material_Tracking_Code, Title_Name, COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17)
		SELECT [0ID], Titles, Season, [Episode No], [Episode Title], Distributor, Lab, [PO Numbers], [PO Status], OEM, [OEM File Name], [Delivered Date], Poster, Still, Trailer, [Embedded Subs], [Edited Poster], [Edited Still], [Due Date] FROM #tempDataMovies')
		--print 'D'
		--SELECT * FROM #TempOutput_Data
                
	END
	ELSE
	BEGIN
                
		ALTER TABLE #tempDataMovies DROP COLUMN [Season]
		ALTER TABLE #tempDataMovies DROP COLUMN [Episode No]
		ALTER TABLE #tempDataMovies DROP COLUMN [Episode Title]
		            
		INSERT INTO #tmpDealType(Deal_Type_Code)
		SELECT DISTINCT Item FROM [dbo].[Split](@AL_DealType_Movies, ',') WHERE ISNULL(Item, '') NOT IN ('', '0')

		SET @query = 'INSERT INTO #tempDataMovies
		SELECT DISTINCT mt.AL_Material_Tracking_Code AS [0ID], t.Title_Name AS Titles, V.Vendor_Name AS Distributer, l.AL_Lab_Name AS Lab, mt.PO_Number AS [PO Numbers], mt.PO_Status AS [PO Status],
			aom.Company_Short_Name, mt.OEM_File_Name, Format(mt.Delivery_Date,''dd-MMM-yyyy'') AS Delivery_Date, mt.Poster, mt.Still, mt.Trailer, mt.Embedded_Subs AS [Embedded Subs], mt.Edited_Poster AS [Edited Poster], Edited_Still AS [Edited Still], mt.Due_Date AS [Due Date],
			mt.Status AS [Status], rel.Content_Status AS [Content Status]
		FROM AL_Material_Tracking mt
		INNER JOIN Title t ON t.Title_Code = mt.Title_Code --AND mt.Status = ''P''
		INNER JOIN #tmpDealType dt ON t.Deal_Type_Code = dt.Deal_Type_Code
		INNER JOIN Vendor v ON v.Vendor_Code = mt.Vendor_Code
		INNER JOIN AL_Lab l ON l.AL_Lab_Code = mt.AL_Lab_Code
		INNER JOIN AL_Load_Sheet_MT_Rel rel ON rel.AL_Material_Tracking_Code = mt.AL_Material_Tracking_Code
		INNER JOIN AL_Booking_Sheet bs ON bs.AL_Booking_Sheet_Code = rel.AL_Booking_Sheet_Code
		INNER JOIN AL_OEM aom ON aom.AL_OEM_Code = mt.AL_OEM_Code
		INNER JOIN AL_Recommendation ar on ar.AL_Recommendation_Code = bs.AL_Recommendation_Code

		WHERE 1=1' + @IncludeHoldoverStr + @Condition
		--print @query
		exec(@query);

		INSERT INTO #tempHeaders(ColNames)
		SELECT Name
		FROM tempdb.sys.columns
		WHERE object_id = Object_id('tempdb..#tempDataMovies');

		INSERT INTO #TempOutput_Data(AL_Material_Tracking_Code, Title_Name, COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14)
		Select *
		from (
		    Select ColNames, RowN = Row_Number() over (ORDER BY (SELECT NULL)) from #tempHeaders
		) a
		pivot (max(ColNames) for RowN in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16])) p
		            
		EXEC('INSERT INTO #TempOutput_Data(AL_Material_Tracking_Code, Title_Name, COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14)
		SELECT [0ID], Titles, Distributor, Lab, [PO Numbers], [PO Status], OEM, [OEM File Name], [Delivered Date], Poster, Still, Trailer, [Embedded Subs], [Edited Poster], [Edited Still], [Due Date] FROM #tempDataMovies')
	END

	IF(OBJECT_ID('tempdb..#tempOEM') IS NOT NULL) DROP TABLE #tempOEM

	--SELECT * FROM #TempOutput_OEM

	SELECT dt.AL_Material_Tracking_Code, dt.Title_Name ,COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20
	FROM #TempOutput_Data dt
	ORDER BY dt.AL_Material_Tracking_Code ASC

	IF(OBJECT_ID('tempdb..#TempOutput_Data') IS NOT NULL) DROP TABLE #TempOutput_Data
	IF(OBJECT_ID('tempdb..#tmpDealType') IS NOT NULL) DROP TABLE #tmpDealType
	IF(OBJECT_ID('tempdb..#tempDataMovies') IS NOT NULL) DROP TABLE #tempDataMovies
	IF(OBJECT_ID('tempdb..#tempHeaders') IS NOT NULL) DROP TABLE #tempHeaders
	IF(OBJECT_ID('tempdb..#tempDate') IS NOT NULL) DROP TABLE #tempDate

END