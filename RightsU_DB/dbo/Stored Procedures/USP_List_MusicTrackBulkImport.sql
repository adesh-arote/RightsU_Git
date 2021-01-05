
CREATE PROCEDURE USP_List_MusicTrackBulkImport
(
	@DM_Master_Import_Code INT = 0,
	@SearchCriteria VARCHAR(MAX) = '',
	@MusicTrack NVARCHAR(MAX) = '',
	@MovieAlbum NVARCHAR(MAX) = '',
	@MusicLabel NVARCHAR(MAX) = '',
	@TitleLanguage NVARCHAR(MAX) = '',
	@StarCast NVARCHAR(MAX) = '',
	@Singer NVARCHAR(MAX) = '',
	@Status NVARCHAR(MAX) = '',
	@ErrorMsg NVARCHAR(MAX) = '',
	@MusicAlbumType NVARCHAR(MAX) = '',
	@Genres NVARCHAR(MAX) = '',
	@PageNo INT = 1,
	@PageSize INT = 999,
	@RecordCount INT OUT
)
AS
BEGIN
	DECLARE @Record_Status VARCHAR(1) = '',
	@Is_Ignore VARCHAR(1) = '' 

	IF(OBJECT_ID('TEMPDB..#TempStarCast') IS NOT NULL)
		DROP TABLE #TempStarCast   
	IF(OBJECT_ID('TEMPDB..#TempSinger') IS NOT NULL)
		DROP TABLE #TempSinger 
	IF(OBJECT_ID('TEMPDB..#TempErrorMsg') IS NOT NULL)
		DROP TABLE #TempErrorMsg	
	IF(OBJECT_ID('TEMPDB..#TempLanguage') IS NOT NULL)
		DROP TABLE #TempLanguage 		
	IF(OBJECT_ID('TEMPDB..#TempDM_Music_Title') IS NOT NULL)
		DROP TABLE #TempDM_Music_Title
   
	BEGIN
	CREATE TABLE #TempDM_Music_Title
	(
		Row_No INT IDENTITY(1,1),
		DMMusicTitleCode INT,
		ExcelLineNo VARCHAR(MAX),
		MusicTrackName VARCHAR(MAX),
		MovieAlbumName VARCHAR(MAX),
		MusicLable VARCHAR(MAX),
		TitleLanguage NVARCHAR(MAX),
		MovieStarCast VARCHAR(MAX),
		MusicAlbumType VARCHAR(MAX),
		Singers NVARCHAR(MAX),
		Genres VARCHAR(MAX),		
		Status VARCHAR(MAX),
		ErrorMessage VARCHAR(MAX)
	)
	CREATE TABLE #TempStarCast
	(
		ID INT,		
		StarCast NVARCHAR(MAX)			
	)
	CREATE TABLE #TempSinger
	(
		ID INT,
		Singer NVARCHAR(MAX)
	)	
	CREATE TABLE #TempErrorMsg
	(
		ID INT,
		ErrorMsg NVARCHAR(MAX)
	)
	CREATE TABLE #TempLanguage
	(
		ID INT,
		Language NVARCHAR(MAX)
	)
	END

	SELECT @Record_Status = CASE WHEN @SearchCriteria = 'Success' THEN  'C' WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict') THEN  'R'
								 WHEN @SearchCriteria = 'Proceed' THEN  'P' WHEN @SearchCriteria = 'No Error' THEN  'N'
								 WHEN @SearchCriteria = 'Error' THEN  'E' ELSE '' END, 
		   @Is_Ignore = CASE WHEN (@SearchCriteria = 'Ignore' OR @Status = 'Y' ) THEN 'Y' ELSE '' END,
		   @SearchCriteria = CASE WHEN @SearchCriteria = 'Success' THEN  ''
								WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict' ) THEN  ''
								WHEN @SearchCriteria = 'Proceed' THEN  ''
								WHEN @SearchCriteria = 'No Error' THEN  ''
								WHEN @SearchCriteria = 'Error' THEN  ''
								WHEN @SearchCriteria = 'Ignore' THEN ''
								ELSE @SearchCriteria END,
		   @Status = CASE WHEN @Status = 'Y' THEN '' ELSE @Status END
						 			
	INSERT INTO #TempStarCast(ID, StarCast)
	SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS StarCast from DM_Music_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter([Star_Cast],',') 
	WHERE LTRIM(RTRIM(ISNULL([Star_Cast], ''))) <> ''
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code
			
	INSERT INTO #TempSinger(ID, Singer)
	SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Singers from DM_Music_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter([Singers],',') 
	WHERE LTRIM(RTRIM(ISNULL([Singers], ''))) <> '' 
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code
		
	INSERT INTO #TempErrorMsg(ID, ErrorMsg)
	SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS ErrorMsg from DM_Music_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
	WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> '' 
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

	INSERT INTO #TempLanguage(ID, Language)
	SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Language from DM_Music_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',') 
	WHERE LTRIM(RTRIM(ISNULL(DMT.Title_Language, ''))) <> '' 
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code


	IF(@PageNo = 0)
		Set @PageNo = 1 

	INSERT INTO #TempDM_Music_Title
	(
		DMMusicTitleCode, ExcelLineNo, MusicTrackName, MovieAlbumName, MusicLable, TitleLanguage, MovieStarCast, MusicAlbumType, Singers, Genres, 
		Status, ErrorMessage
	)
	
	SELECT DISTINCT [IntCode], [Excel_Line_No], [Music_Title_Name], [Movie_Album], [Music_Label], [Title_Language], [Star_Cast], [Music_Album_Type], [Singers], [Genres],
	CASE WHEN [Is_Ignore] = 'Y' THEN 'Ignore'
		 WHEN [Record_Status] = 'C' THEN 'Success'
		 WHEN [Record_Status] = 'E' THEN 'Error'
		 WHEN [Record_Status] = 'N' THEN 'No Error'
		 WHEN [Record_Status] = 'P' THEN 'Proceed'
		 WHEN [Record_Status] = 'R' THEN 'Resolve Conflict'
	END AS Status, 
	[Error_Message]
	FROM DM_Music_Title DMT	
	LEFT JOIN #TempErrorMsg TEM ON DMT.IntCode = TEM.ID 
	LEFT JOIN #TempSinger TS ON DMT.IntCode = TS.ID
	LEFT JOIN #TempStarCast TST ON DMT.IntCode = TST.ID
	LEFT JOIN #TempLanguage TL ON DMT.IntCode = TL.ID
    Where @DM_Master_Import_Code = 0 OR DM_Master_Import_Code = @DM_Master_Import_Code		
	AND (@SearchCriteria = '' 
			 OR [Music_Title_Name] Like '%' + @SearchCriteria + '%' 
			 OR [Movie_Album] Like '%' + @SearchCriteria + '%'
			 OR [Music_Label] Like '%' + @SearchCriteria + '%' 
			 OR [Title_Language] Like '%' + @SearchCriteria + '%' 
			 OR [Star_Cast] Like '%' + @SearchCriteria + '%'
			 OR [Music_Album_Type] Like '%' + @SearchCriteria + '%'
			 OR [Singers] Like '%' + @SearchCriteria + '%' 
			 OR [Genres] Like '%' + @SearchCriteria + '%' 
			)
	AND (@Record_Status = '' OR [Record_Status] = @Record_Status AND [Is_Ignore] != 'Y')
	AND (@Is_Ignore = '' OR [Is_Ignore] = @Is_Ignore)	
	AND (@TitleLanguage = '' OR TL.Language collate SQL_Latin1_General_CP1_CI_AS IN (Select LTRIM(RTRIM(number)) collate SQL_Latin1_General_CP1_CI_AS from dbo.fn_Split_withdelemiter(@TitleLanguage,',')))
	AND (@MovieAlbum = '' OR [Movie_Album]  IN (Select LTRIM(RTRIM(number))  from dbo.fn_Split_withdelemiter(@MovieAlbum,',')))
	AND (@MusicTrack = '' OR [Music_Title_Name] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@MusicTrack,',')))
	AND (@MusicLabel = '' OR [Music_Label] IN (Select  LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@MusicLabel,',')))
	AND (@Status = '' OR [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@Status,',') WHERE LTRIM(RTRIM(ISNULL(@Status,','))) <> '' ) AND Is_Ignore = 'N')
	AND (@StarCast = '' OR TST.StarCast collate SQL_Latin1_General_CP1_CI_AS IN(Select splitdata collate SQL_Latin1_General_CP1_CI_AS from dbo.fnSplitString(@StarCast,',')))
	AND (@Singer = '' OR TS.Singer collate SQL_Latin1_General_CP1_CI_AS IN(Select splitdata collate SQL_Latin1_General_CP1_CI_AS from dbo.fnSplitString(@Singer,',')))
	AND (@ErrorMsg = '' OR TEM.ErrorMsg collate SQL_Latin1_General_CP1_CI_AS IN(Select splitdata collate SQL_Latin1_General_CP1_CI_AS from dbo.fnSplitString(@ErrorMsg,',')))
	AND (@Genres = '' OR [Genres] collate SQL_Latin1_General_CP1_CI_AS IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@Genres,',')))
	AND (@MusicAlbumType = '' OR [Music_Album_Type] = @MusicAlbumType)
		
	SELECT @RecordCount = COUNT(*) FROM #TempDM_Music_Title

	DELETE from  #TempDM_Music_Title WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

	SELECT  DMMusicTitleCode, ExcelLineNo, MusicTrackName, MovieAlbumName, MusicLable, TitleLanguage, MovieStarCast, MusicAlbumType, Singers, Genres, Status, ErrorMessage FROM #TempDM_Music_Title

	IF OBJECT_ID('tempdb..#TempDM_Music_Title') IS NOT NULL DROP TABLE #TempDM_Music_Title
	IF OBJECT_ID('tempdb..#TempErrorMsg') IS NOT NULL DROP TABLE #TempErrorMsg
	IF OBJECT_ID('tempdb..#TempLanguage') IS NOT NULL DROP TABLE #TempLanguage
	IF OBJECT_ID('tempdb..#TempSinger') IS NOT NULL DROP TABLE #TempSinger
	IF OBJECT_ID('tempdb..#TempStarCast') IS NOT NULL DROP TABLE #TempStarCast
END
--go
--ALTER PROCEDURE USP_List_MusicTrackBulkImport
--(
--	@DM_Master_Import_Code INT = 0,
--	@SearchCriteria VARCHAR(MAX) = '',
--	@MusicTrack NVARCHAR(MAX) = '',
--	@MovieAlbum NVARCHAR(MAX) = '',
--	@MusicLabel NVARCHAR(MAX) = '',
--	@TitleLanguage NVARCHAR(MAX) = '',
--	@StarCast NVARCHAR(MAX) = '',
--	@Singer NVARCHAR(MAX) = '',
--	@Status NVARCHAR(MAX) = '',
--	@ErrorMsg NVARCHAR(MAX) = '',
--	@MusicAlbumType NVARCHAR(MAX) = '',
--	@Genres NVARCHAR(MAX) = '',
--	@PageNo INT = 1,
--	@PageSize INT = 999,
--	@RecordCount INT OUT 
--)
--AS
--BEGIN
--DECLARE

----		@DMMusicTitleCode INT,
--		@ExcelLineNo VARCHAR(MAX)
--		,@MusicTrackName VARCHAR(MAX)
--		,@MovieAlbumName VARCHAR(MAX)
--		,@MusicLable VARCHAR(MAX)
--		--,@TitleLanguage NVARCHAR(MAX)
--		,@MovieStarCast VARCHAR(MAX)
----		,@MusicAlbumType VARCHAR(MAX)
--		,@Singers NVARCHAR(MAX)
--		,@ErrorMessage VARCHAR(MAX)

--SELECT @ExcelLineNo ExcelLineNo, @MusicTrackName MusicTrackName, @MovieAlbumName MovieAlbumName, @MusicLable MusicLable, @TitleLanguage TitleLanguage, 
--@MovieStarCast MovieStarCast,
--@MusicAlbumType MusicAlbumType, @Singers Singers, @Genres Genres, @Status Status, @ErrorMessage ErrorMessage
--END