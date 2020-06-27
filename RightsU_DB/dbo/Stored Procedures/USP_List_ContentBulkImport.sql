
ALTER PROCEDURE USP_List_ContentBulkImport
(
	@DM_Master_Import_Code INT = 0,
	@SearchCriteria VARCHAR(MAX) = '',
	@ContentName NVARCHAR(MAX) = '',
	@MusicTrackName NVARCHAR(MAX) = '',
	@Status NVARCHAR(MAX) = '',
	@ErrorMsg NVARCHAR(MAX) = '',
	@EpisodeNos NVARCHAR(MAX) = '',
	@PageNo INT = 1,
	@PageSize INT = 999,
	@RecordCount INT OUT	
)
AS
BEGIN
	DECLARE @Record_Status VARCHAR(20) = '', @Is_Ignore VARCHAR(1) = ''

	BEGIN --Delete Temp Table
		IF(OBJECT_ID('TEMPDB..#TempSplitMusicTrack') IS NOT NULL)
			DROP TABLE #TempSplitMusicTrack
		IF(OBJECT_ID('TEMPDB..#TempContentName') IS NOT NULL)
			DROP TABLE #TempContentName
		IF(OBJECT_ID('TEMPDB..#TempSplitErrorMsg') IS NOT NULL)
			DROP TABLE #TempSplitErrorMsg
		IF(OBJECT_ID('TEMPDB..#TempErrorMsg') IS NOT NULL)
			DROP TABLE #TempErrorMsg
		IF(OBJECT_ID('TEMPDB..#TempDM_Content_Music') IS NOT NULL)
			DROP TABLE #TempDM_Content_Music
	END

	BEGIN --Create Temp Table
		CREATE TABLE #TempDM_Content_Music
		(
			Row_No INT IDENTITY(1,1),
			DMContentMusicCode VARCHAR(MAX),
			ExcelLineNo VARCHAR(50),
			Content VARCHAR(MAX),
			EpisodeNo NVARCHAR(10),
			VersionName VARCHAR(MAX),
			MusicTrackName VARCHAR(MAX),
			TC_IN NVARCHAR(20),
			TC_OUT NVARCHAR(20),
			FromFrame NVARCHAR(20),
			ToFrame NVARCHAR(20),
			Duration NVARCHAR(20),
			DurationFrame NVARCHAR(20),
			Status VARCHAR(20),
			ErrorMessage VARCHAR(MAX)
		)
		CREATE TABLE #TempContentName
		(
			ContentName NVARCHAR(MAX)
		)
		CREATE TABLE #TempSplitMusicTrack
		(
			MusicTrack NVARCHAR(MAX)
		)
		CREATE TABLE #TempSplitErrorMsg
		(
			ErrorMessage NVARCHAR(MAX)
		)
		CREATE TABLE #TempErrorMsg
		(
			ID INT,
			ErrorMsg NVARCHAR(MAX)
		)
	END
	
    SELECT @Record_Status = CASE WHEN @SearchCriteria = 'Success' THEN  'C'
								WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict') THEN  'OR,MR,SM,MO,SO'
								WHEN @SearchCriteria = 'Proceed' THEN  'P'
								WHEN @SearchCriteria = 'No Error' THEN  'N'
								WHEN @SearchCriteria = 'Error' THEN  'E'
								ELSE '' END, 
		  @Is_Ignore = CASE WHEN (@SearchCriteria = 'Ignore' OR @Status = 'Y') THEN 'Y' ELSE '' END,	
		  @SearchCriteria = CASE WHEN @SearchCriteria = 'Success' THEN  ''
							WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict') THEN  ''
							WHEN @SearchCriteria = 'Proceed' THEN  ''
							WHEN @SearchCriteria = 'No Error' THEN  ''
							WHEN @SearchCriteria = 'Error' THEN  ''
							WHEN @SearchCriteria = 'Ignore' THEN ''
							ELSE @SearchCriteria END,
		  @Status = CASE WHEN @Status = 'Y' THEN '' ELSE @Status END

	INSERT INTO #TempContentName(ContentName)
	SELECT LTRIM(RTRIM(number)) AS MusicTrack from dbo.fn_Split_withdelemiter(@ContentName,',') WHERE LTRIM(RTRIM(ISNULL(@ContentName, ''))) <> ''

	INSERT INTO #TempSplitMusicTrack(MusicTrack)
	SELECT LTRIM(RTRIM(number)) AS MusicTrack from dbo.fn_Split_withdelemiter(@MusicTrackName,',') WHERE LTRIM(RTRIM(ISNULL(@MusicTrackName, ''))) <> ''

	INSERT INTO #TempSplitErrorMsg(ErrorMessage)
	SELECT LTRIM(RTRIM(number)) AS ErrorMsg from dbo.fn_Split_withdelemiter(@ErrorMsg,',') WHERE LTRIM(RTRIM(ISNULL(@ErrorMsg, ''))) <> ''

	INSERT INTO #TempErrorMsg(ID, ErrorMsg)
	SELECT DCM.IntCode, LTRIM(RTRIM(number)) AS ErrorMsg from DM_Content_Music DCM
	CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
	WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> ''
	AND DCM.DM_Master_Import_Code = @DM_Master_Import_Code

	IF(@PageNo = 0)
		Set @PageNo = 1

	INSERT INTO #TempDM_Content_Music
	(
		DMContentMusicCode, ExcelLineNo, Content, EpisodeNo, VersionName, MusicTrackName, TC_IN, TC_OUT, 
		FromFrame, ToFrame, Duration, DurationFrame, 
		Status, ErrorMessage
	)

	SELECT DISTINCT [IntCode], [Excel_Line_No], [Content_Name], [Episode_No], [Version_Name], [Music_Track], [From] AS TC_IN, [To] AS TC_OUT,
		[From_Frame], [To_Frame], [Duration], [Duration_Frame],
		CASE WHEN [Is_Ignore] = 'Y' THEN 'Ignore'
				WHEN [Record_Status] = 'C' THEN 'Success'
				WHEN [Record_Status] = 'E' THEN 'Error'
				WHEN [Record_Status] = 'N' THEN 'No Error'
				WHEN [Record_Status] = 'P' THEN 'Proceed'
				WHEN ([Record_Status] = 'OR' OR [Record_Status] = 'MR' OR [Record_Status] = 'SM' OR [Record_Status] = 'MO' OR [Record_Status] = 'SO') THEN 'Resolve Conflict'  
		END AS Status, [Error_Message]
	FROM DM_Content_Music DCM
	LEFT JOIN #TempErrorMsg TEM ON DCM.IntCode = TEM.ID
	WHERE 
	(@DM_Master_Import_Code = 0 OR DM_Master_Import_Code = @DM_Master_Import_Code)
	AND(@SearchCriteria = '' 
		OR [Content_Name] Like '%' + @SearchCriteria + '%' 
		OR [Episode_No] Like '%' + @SearchCriteria + '%'
		OR [Music_Track] Like '%' + @SearchCriteria + '%'		
	) 
	AND (@Record_Status = '' OR [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@Record_Status,',') WHERE LTRIM(RTRIM(ISNULL(@Record_Status, ''))) <> '')  AND [Is_Ignore] != 'Y')
	AND (@Is_Ignore = '' OR [Is_Ignore] = @Is_Ignore)	
	AND (@ContentName = '' OR [Content_Name] collate SQL_Latin1_General_CP1_CI_AS IN (Select TCM.ContentName collate SQL_Latin1_General_CP1_CI_AS FROM #TempContentName TCM))
	AND (@Status = '' OR [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@Status,',') WHERE LTRIM(RTRIM(ISNULL(@Status,','))) <> '' ) AND Is_Ignore = 'N')
	AND (@MusicTrackName = '' OR [Music_Track] collate SQL_Latin1_General_CP1_CI_AS IN (Select TSMT.MusicTrack collate SQL_Latin1_General_CP1_CI_AS FROM #TempSplitMusicTrack TSMT))
	AND (@ErrorMsg = '' OR TEM.ErrorMsg collate SQL_Latin1_General_CP1_CI_AS IN(Select TSEM.ErrorMessage collate SQL_Latin1_General_CP1_CI_AS FROM #TempSplitErrorMsg TSEM))
	AND (@EpisodeNos = '' OR DCM.Episode_No in (select number from dbo.fn_Split_withdelemiter(''+@EpisodeNos+'',',')))

	SELECT @RecordCount = COUNT(*) FROM #TempDM_Content_Music

	DELETE from  #TempDM_Content_Music WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

	SELECT  DMContentMusicCode, ExcelLineNo, Content, EpisodeNo, VersionName, MusicTrackName, TC_IN, TC_OUT, FromFrame, ToFrame, Duration, DurationFrame, Status, ErrorMessage FROM #TempDM_Content_Music
END

--ALTER PROCEDURE USP_List_ContentBulkImport
--(
--	@DM_Master_Import_Code INT = 0,
--	@SearchCriteria VARCHAR(MAX) = '',
--	@ContentName NVARCHAR(MAX) = '',
--	@MusicTrackName NVARCHAR(MAX) = '',
--	@Status NVARCHAR(MAX) = '',
--	@ErrorMsg NVARCHAR(MAX) = '',
--	@EpisodeNos NVARCHAR(MAX) = '',
--	@PageNo INT = 1,
--	@PageSize INT = 999,
--	@RecordCount INT 
--)
--AS
--BEGIN
--	DECLARE
--			@DMContentMusicCode VARCHAR(MAX)='',
--			@ExcelLineNo VARCHAR(50)='',
--			@Content VARCHAR(MAX)='',
--			@EpisodeNo NVARCHAR(10)='',
--			@VersionName VARCHAR(MAX)='',
--			@TC_IN NVARCHAR(20)='',
--			@TC_OUT NVARCHAR(20)='',
--			@FromFrame NVARCHAR(20)='',
--			@ToFrame NVARCHAR(20)='',
--			@Duration NVARCHAR(20)='',
--			@DurationFrame NVARCHAR(20)='',
--			@ErrorMessage VARCHAR(MAX)=''
--SELECT @DMContentMusicCode DMContentMusicCode, @ExcelLineNo ExcelLineNo, @Content Content, @EpisodeNo EpisodeNo, @VersionName VersionName, @MusicTrackName MusicTrackName, @TC_IN TC_IN, @TC_OUT TC_OUT, 
--@FromFrame FromFrame, @ToFrame ToFrame, @Duration Duration, @DurationFrame DurationFrame, @Status Status, @ErrorMessage ErrorMessage 
--END
--DECLARE @RecordCount INT =0
--exec USP_List_ContentBulkImport 0,'','','','','',1,2000,@RecordCount
