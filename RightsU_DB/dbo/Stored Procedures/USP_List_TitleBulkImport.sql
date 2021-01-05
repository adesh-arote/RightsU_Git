

CREATE PROCEDURE USP_List_TitleBulkImport
	@DM_Master_Import_Code INT = 0,
	@TitleName NVARCHAR(MAX) = '',
	@TitleType NVARCHAR(MAX) = '',
	@TitleLanguage NVARCHAR(MAX) = '',
	@KeyStarCast NVARCHAR(MAX) = '',
	@Status NVARCHAR(MAX) = '',	
	@ErrorMsg NVARCHAR(MAX) = '',
	@Director NVARCHAR(MAX) = '',
	@MusicLabel NVARCHAR(MAX) = '',
	@SearchCriteria VARCHAR(MAX) = '',	
	@PageNo INT = 1,
	@PageSize INT = 999,
	@RecordCount INT OUT	

AS
BEGIN
	DECLARE  @Record_Status VARCHAR(20) = '', @Is_Ignore VARCHAR(1) = ''
	BEGIN
		IF(OBJECT_ID('TEMPDB..#TempTitleLanguage') IS NOT NULL)
			DROP TABLE #TempTitleLanguage
		IF(OBJECT_ID('TEMPDB..#TempTitleName') IS NOT NULL)
			DROP TABLE #TempTitleName
		IF(OBJECT_ID('TEMPDB..#TempKeyStarCast') IS NOT NULL)
			DROP TABLE #TempKeyStarCast		
		IF(OBJECT_ID('TEMPDB..#TempSplitKeyStarCast') IS NOT NULL)
			DROP TABLE #TempSplitKeyStarCast
		IF(OBJECT_ID('TEMPDB..#TempErrorMsg') IS NOT NULL)
			DROP TABLE #TempErrorMsg
		IF(OBJECT_ID('TEMPDB..#TempSplitErrorMsg') IS NOT NULL)
			DROP TABLE #TempSplitErrorMsg
		IF(OBJECT_ID('TEMPDB..#TempDM_Title') IS NOT NULL)
			DROP TABLE #TempDM_Title
		IF(OBJECT_ID('TEMPDB..#TempDirector') IS NOT NULL)
			DROP TABLE #TempDirector
		IF(OBJECT_ID('TEMPDB..#TempMusicLabel') IS NOT NULL)
			DROP TABLE #TempMusicLabel
	END

	BEGIN
		CREATE TABLE #TempTitleLanguage
		(		
			TitleLanguage NVARCHAR(MAX)
		)
		CREATE TABLE #TempKeyStarCast
		(
			ID INT,	
			StarCast NVARCHAR(MAX)
		)
		CREATE TABLE #TempErrorMsg
		(
			ID INT,
			ErrorMessage NVARCHAR(MAX)
		)
		CREATE TABLE #TempDirector
		(
			ID INT,
			Director NVARCHAR(MAX)
		)
		CREATE TABLE #TempMusicLabel
		(
			ID INT,
			MusicLabel NVARCHAR(MAX)
		)
		CREATE TABLE #TempSplitErrorMsg
		(		
			ErrorMessage NVARCHAR(MAX)
		)
		CREATE TABLE #TempSplitKeyStarCast
		(		
			StarCast NVARCHAR(MAX)
		)
		CREATE TABLE #TempTitleName
		(
			TitleName NVARCHAR(MAX)
		)			
		CREATE TABLE #TempDM_Title
		(
			Row_No INT IDENTITY(1,1),
			DMTitleCode INT,
			ExcelLineNo VARCHAR(50),
			TitleName VARCHAR(MAX),
			TitleType VARCHAR(MAX),
			TitleLanguage NVARCHAR(MAX),
			KeyStarCast NVARCHAR(MAX),
			Director VARCHAR(MAX),
			MusicLable VARCHAR(MAX),
			YearOfRelease VARCHAR(MAX),
			Status VARCHAR(20),
			ErrorMessage NVARCHAR(MAX)
		)
	END

    SELECT @Record_Status = CASE WHEN @SearchCriteria = 'Success' THEN  'C'
								  WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict' ) THEN  'R'
								  WHEN @SearchCriteria = 'Proceed' THEN  'P'
								  WHEN @SearchCriteria = 'No Error' THEN  'N'
								  WHEN @SearchCriteria = 'Error' THEN  'E'
								  ELSE '' END, 
			@Is_Ignore = CASE WHEN (@SearchCriteria = 'Ignore' OR @Status = 'Y' ) THEN  'Y'
								  ELSE '' END,	
			@SearchCriteria = CASE WHEN @SearchCriteria = 'Success' THEN  ''
								  WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict' ) THEN  ''
								  WHEN @SearchCriteria = 'Proceed' THEN  ''
								  WHEN @SearchCriteria = 'No Error' THEN  ''
								  WHEN @SearchCriteria = 'Error' THEN  ''
								  WHEN @SearchCriteria = 'Ignore' THEN ''
								  ELSE @SearchCriteria END,
            @Status = CASE WHEN @Status = 'Y' THEN ''
			               ELSE @Status END

	INSERT INTO #TempTitleLanguage( TitleLanguage)
	SELECT  LTRIM(RTRIM(number)) FROM dbo.fn_Split_withdelemiter(@TitleLanguage,',') 
	WHERE LTRIM(RTRIM(ISNULL(@TitleLanguage, ''))) <> '' 

	INSERT INTO #TempDirector(ID, Director)
	SELECT  DM_Title_Code, LTRIM(RTRIM(number)) AS Director from DM_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter(DMT.[Director Name],',') 
	WHERE LTRIM(RTRIM(ISNULL(DMT.[Director Name], ''))) <> '' 
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code
	
	INSERT INTO #TempMusicLabel(ID, MusicLabel)
	SELECT  DM_Title_Code, LTRIM(RTRIM(number)) AS MusicLabel from DM_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',') 
	WHERE LTRIM(RTRIM(ISNULL(DMT.Music_Label, ''))) <> '' 
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

	INSERT INTO #TempKeyStarCast(ID, StarCast)
	SELECT  DM_Title_Code, LTRIM(RTRIM(number)) AS StarCast from DM_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter([Key Star Cast],',') 
	WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> '' 
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

	INSERT INTO #TempErrorMsg(ID, ErrorMessage)
	SELECT DM_Title_Code,  LTRIM(RTRIM(number)) AS ErrorMsg from DM_Title DMT
	CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
	WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> '' 
	AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

	INSERT INTO #TempSplitErrorMsg(ErrorMessage)
	SELECT LTRIM(RTRIM(number)) AS ErrorMsg from dbo.fn_Split_withdelemiter(@ErrorMsg,',') 
	WHERE LTRIM(RTRIM(ISNULL(@ErrorMsg, ''))) <> ''

	INSERT INTO #TempSplitKeyStarCast(StarCast)
	SELECT LTRIM(RTRIM(number)) AS StarCast from dbo.fn_Split_withdelemiter(@KeyStarCast,',') 
	WHERE LTRIM(RTRIM(ISNULL(@KeyStarCast, ''))) <> '' 

	INSERT INTO #TempTitleName(TitleName)
	SELECT LTRIM(RTRIM(number)) AS TitleName from dbo.fn_Split_withdelemiter(@TitleName,',')
	WHERE LTRIM(RTRIM(ISNULL(@TitleName, ''))) <> '' 

	IF(@PageNo = 0)
        Set @PageNo = 1

    INSERT INTO #TempDM_Title
	(
		DMTitleCode, ExcelLineNo, TitleName, TitleType, TitleLanguage, KeyStarCast, Director, 
		MusicLable, YearOfRelease, 
		Status, 
		ErrorMessage
	)
	SELECT DISTINCT [DM_Title_Code], [Excel_Line_No], [Original Title (Tanil/Telugu)], [Title Type], [Original Language (Hindi)], [Key Star Cast], [Director Name],
	[Music_Label], [Year of Release],
	CASE WHEN [Is_Ignore] = 'Y' THEN 'Ignore'
		 WHEN [Record_Status] = 'C' THEN 'Success'
		 WHEN [Record_Status] = 'E' THEN 'Error'
		 WHEN [Record_Status] = 'N' THEN 'No Error'
		 WHEN [Record_Status] = 'P' THEN 'Proceed'
		 WHEN [Record_Status] = 'R' THEN 'Resolve Conflict'
	END AS Status,
	CASE WHEN [Record_Status] = 'E' THEN [Error_Message]
	     ELSE '' END
	FROM DM_Title DMT
	LEFT JOIN #TempKeyStarCast TKST ON DMT.DM_Title_Code = TKST.ID
	LEFT JOIN #TempErrorMsg TEM ON DMT.DM_Title_Code = TEM.ID
	LEFT JOIN #TempDirector TD ON DMT.DM_Title_Code = TD.ID
	LEFT JOIN #TempMusicLabel TML ON DMT.DM_Title_Code = TML.ID
	WHERE 
		(@DM_Master_Import_Code = 0 OR DM_Master_Import_Code = @DM_Master_Import_Code)
		AND (@SearchCriteria = '' 
			 OR [Original Title (Tanil/Telugu)] Like '%' + @SearchCriteria + '%' 
			 OR [Title Type] Like '%' + @SearchCriteria + '%' 
			 OR [Original Language (Hindi)] Like '%' + @SearchCriteria + '%' 
			 OR [Key Star Cast] Like '%' + @SearchCriteria + '%' 
			 OR [Director Name] Like '%' + @SearchCriteria + '%' 
			 OR [Music_Label] Like '%' + @SearchCriteria + '%' 
			 OR [Year of Release] Like '%' + @SearchCriteria + '%'
		)
		AND (@Record_Status = '' OR [Record_Status] = @Record_Status AND [Is_Ignore] != 'Y')
		AND (@Is_Ignore = '' OR [Is_Ignore] = @Is_Ignore)
		AND (@TitleName = '' OR [Original Title (Tanil/Telugu)] collate SQL_Latin1_General_CP1_CI_AS IN (Select TTN.TitleName collate SQL_Latin1_General_CP1_CI_AS FROM #TempTitleName TTN))
		AND (@TitleType = '' OR [Title Type] = @TitleType)
		AND (@TitleLanguage = '' OR [Original Language (Hindi)] collate SQL_Latin1_General_CP1_CI_AS IN (Select TTL.TitleLanguage collate SQL_Latin1_General_CP1_CI_AS FROM #TempTitleLanguage TTL))
		AND (@Status = '' OR [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@Status,',') WHERE LTRIM(RTRIM(ISNULL(@Status,','))) <> '' ) AND Is_Ignore = 'N')
		AND (@KeyStarCast = '' OR TKST.StarCast collate SQL_Latin1_General_CP1_CI_AS IN(Select TSKST.StarCast collate SQL_Latin1_General_CP1_CI_AS FROM #TempSplitKeyStarCast TSKST))
		AND (@ErrorMsg = '' OR TEM.ErrorMessage collate SQL_Latin1_General_CP1_CI_AS IN(Select TSEM.ErrorMessage collate SQL_Latin1_General_CP1_CI_AS FROM #TempSplitErrorMsg TSEM))
		AND (@Director = '' OR TD.Director collate SQL_Latin1_General_CP1_CI_AS IN(Select  LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@Director,',')))
		AND (@MusicLabel = '' OR TML.MusicLabel collate SQL_Latin1_General_CP1_CI_AS IN(Select  LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter(@MusicLabel,',')))

	SELECT @RecordCount = COUNT(*) FROM #TempDM_Title
	
	DELETE from  #TempDM_Title WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

	SELECT DMTitleCode, ExcelLineNo, TitleName, TitleType, TitleLanguage, KeyStarCast, Director, MusicLable, YearOfRelease, Status, ErrorMessage FROM #TempDM_Title

	IF OBJECT_ID('tempdb..#TempDirector') IS NOT NULL DROP TABLE #TempDirector
	IF OBJECT_ID('tempdb..#TempDM_Title') IS NOT NULL DROP TABLE #TempDM_Title
	IF OBJECT_ID('tempdb..#TempErrorMsg') IS NOT NULL DROP TABLE #TempErrorMsg
	IF OBJECT_ID('tempdb..#TempKeyStarCast') IS NOT NULL DROP TABLE #TempKeyStarCast
	IF OBJECT_ID('tempdb..#TempMusicLabel') IS NOT NULL DROP TABLE #TempMusicLabel
	IF OBJECT_ID('tempdb..#TempSplitErrorMsg') IS NOT NULL DROP TABLE #TempSplitErrorMsg
	IF OBJECT_ID('tempdb..#TempSplitKeyStarCast') IS NOT NULL DROP TABLE #TempSplitKeyStarCast
	IF OBJECT_ID('tempdb..#TempTitleLanguage') IS NOT NULL DROP TABLE #TempTitleLanguage
	IF OBJECT_ID('tempdb..#TempTitleName') IS NOT NULL DROP TABLE #TempTitleName
END
 
--ALTER PROCEDURE USP_List_TitleBulkImport
--@DM_Master_Import_Code INT = 0,
--	@TitleName NVARCHAR(MAX) = '',
--	@TitleType NVARCHAR(MAX) = '',
--	@TitleLanguage NVARCHAR(MAX) = '',
--	@KeyStarCast NVARCHAR(MAX) = '',
--	@Status NVARCHAR(MAX) = '',	
--	@ErrorMsg NVARCHAR(MAX) = '',
--	@Director NVARCHAR(MAX) = '',
--	@MusicLabel NVARCHAR(MAX) = '',
--	@SearchCriteria VARCHAR(MAX) = '',	
--	@PageNo INT = 1,
--	@PageSize INT = 999,
--	@RecordCount INT OUT	
--AS
--BEGIN
--	DECLARE @DMTitleCode INT,
--			@ExcelLineNo VARCHAR(50),
--			@MusicLable VARCHAR(MAX),
--			@YearOfRelease VARCHAR(MAX),
--			@ErrorMessage NVARCHAR(MAX)
--SELECT @DMTitleCode  DMTitleCode, @ExcelLineNo ExcelLineNo, @TitleName TitleName, @TitleType TitleType, @TitleLanguage TitleLanguage, @KeyStarCast KeyStarCast, @Director Director, 
--@MusicLable MusicLable, @YearOfRelease YearOfRelease, @Status Status, @ErrorMessage ErrorMessage
--END