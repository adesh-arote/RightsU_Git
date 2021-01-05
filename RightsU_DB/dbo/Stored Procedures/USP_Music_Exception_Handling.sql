CREATE PROCEDURE [dbo].[USP_Music_Exception_Handling]
(
--DECLARE
	@IsAired CHAR(2) = 'Y',
	@PageNo Int=1,
	@RecordCount Int Out,
	@IsPaging Varchar(2)='N',
	@PageSize Int=10,
	@MusicTrackCode VARCHAR(1000)='',
	@MusicLabelCode VARCHAR(1000)='',
	@ChannelCode VARCHAR(1000)='',
	@ContentCode NVARCHAR(4000)='',
	@EpisodeFrom VARCHAR(20)='',
	@EpisodeTO VARCHAR(20)='',
	@InitialResponse VARCHAR(20)='',
	@ExceptionStatus VARCHAR(20)='',
	@UserCode INT=143,
	@CommonSearch NVARCHAR(1000)='',
	@StartDate DATE,
	@EndDate DATE
)
AS
/*=============================================
Author:			Anchal Sikarwar
Create date:	19 Oct, 2016
Description:	List for Music Exception Handling
===============================================*/
BEGIN
	--DECLARE
	--@IsAired CHAR(2) = 'Y',
	--@PageNo Int=1,
	--@RecordCount Int,
	--@IsPaging Varchar(2)='Y',
	--@PageSize Int=10,
	--@MusicTrackCode VARCHAR(1000)='',
	--@MusicLabelCode VARCHAR(1000)='',
	--@ChannelCode VARCHAR(1000)='',
	--@ContentCode NVARCHAR(4000)='',
	--@EpisodeFrom VARCHAR(20)='',
	--@EpisodeTO VARCHAR(20)='',
	--@InitialResponse VARCHAR(20)='',
	--@ExceptionStatus VARCHAR(20)='',
	--@UserCode INT=143,
	--@CommonSearch NVARCHAR(1000)='',	
	--@StartDate DATE='01-01-2018',
	--@EndDate DATE='12-01-2018'

	BEGIN
		IF(OBJECT_ID('TEMPDB..#TEMP') IS NOT NULL)
		BEGIN
			DROP TABLE #TEMP
		END
		IF(OBJECT_ID('TEMPDB..#TempMusicTrack') IS NOT NULL)
		BEGIN
			DROP TABLE #TempMusicTrack
		END
		IF(OBJECT_ID('TEMPDB..#TempMusicLabel') IS NOT NULL)
		BEGIN
			DROP TABLE #TempMusicLabel
		END
		IF(OBJECT_ID('TEMPDB..#TempChannel') IS NOT NULL)
		BEGIN
			DROP TABLE #TempChannel
		END
		IF(OBJECT_ID('TEMPDB..#TempContent') IS NOT NULL)
		BEGIN
			DROP TABLE #TempContent
		END
		IF(OBJECT_ID('TEMPDB..#InitialResp') IS NOT NULL)
		BEGIN
			DROP TABLE #InitialResp	
		END
		IF(OBJECT_ID('TEMPDB..#Exceptions') IS NOT NULL)
		BEGIN
			DROP TABLE #Exceptions
		END
		CREATE TABLE #TempMusicTrack
		(
			MusicTrackCode INT
		)
	
		CREATE TABLE #TempMusicLabel
		(
			MusicLabelCode INT
		)

		CREATE TABLE #TempChannel
		(
			ChannelCode INT
		)
	
		CREATE TABLE #TempContent
		(
			ContentCode NVARCHAR(1000)
		)

		CREATE TABLE #InitialResp
		(
			InitialResponse NVARCHAR(50)
		)

		CREATE TABLE #Exceptions
		(
			ExceptionStatus NVARCHAR(50)
		)

		INSERT INTO #TempMusicTrack(MusicTrackCode)
		SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicTrackCode, ',')
	
		INSERT INTO #TempMusicLabel(MusicLabelCode)
		SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicLabelCode, ',')
	
		INSERT INTO #TempChannel(ChannelCode)
		SELECT number FROM  dbo.fn_Split_withdelemiter(@ChannelCode, ',')
	
		INSERT INTO #TempContent(ContentCode)
		SELECT number FROM  dbo.fn_Split_withdelemiter(@ContentCode, ',')
	
		INSERT INTO #InitialResp(InitialResponse)
		SELECT number FROM  dbo.fn_Split_withdelemiter(@InitialResponse, ',')

		INSERT INTO #Exceptions(ExceptionStatus)
		SELECT number FROM  dbo.fn_Split_withdelemiter(@ExceptionStatus, ',')
	END

	SET FMTONLY OFF 
	;WITH CTE AS(
		SELECT  MST.Music_Schedule_Transaction_Code,
		COALESCE(TC.Episode_Title, MT.Music_Title_Name) AS Content_Name, TC.Episode_No AS Eps, BST.Schedule_Item_Duration As Dur,
		Convert(VARCHAR(12), FORMAT(Convert(datetime,BST.Schedule_Item_Log_Date,0),'dd-MMM-yyyy'),0) AS Airing_Date,
		BST.Schedule_Item_Log_Time AS Airing_Time, C.Channel_Name AS Channel, MT.Music_Title_Name AS Music_Track, MA.Music_Album_Name AS Movie_Album,
		ML.Music_Label_Name AS Music_Label, CML.Duration AS Music_Dur,
		REVERSE(STUFF(REVERSE(STUFF((
			Select DISTINCT  RTRIM(LTRIM(TA.Upload_Error_Code))+'~'
			from Music_Schedule_Exception MTT1
			INNER JOIN Error_Code_Master TA ON MTT1.Error_Code=TA.Error_Code
			where MTT1.Music_Schedule_Transaction_Code=MST.Music_Schedule_Transaction_Code
			AND MTT1.[Status] = 'E'
			FOR XML PATH(''), root('Exceptions'), type
			).value('/Exceptions[1]','Nvarchar(max)'
		),2,0, '')), 1, 1, ''))  as Exceptions,
		MST.Initial_Response,
		RTRIM(LTRIM(MST.Workflow_Status)) AS Workflow_Status
		FROM Music_Schedule_Transaction AS MST
		INNER JOIN BV_Schedule_Transaction AS BST ON BST.BV_Schedule_Transaction_Code  = MST.BV_Schedule_Transaction_Code
		INNER JOIN Content_Music_Link AS CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
		INNER JOIN Title_Content AS TC ON TC.Title_Content_Code = CML.Title_Content_Code
		INNER JOIN Title AS T ON T.Title_Code = TC.Title_Code
		INNER JOIN Music_Title AS MT ON MT.Music_Title_Code = CML.Music_Title_Code
		INNER JOIN Music_Album AS MA ON MT.Music_Album_Code = MA.Music_Album_Code
		INNER JOIN Channel AS C ON C.Channel_Code = MST.Channel_Code
		INNER JOIN #TempMusicTrack AS tmt ON (CML.Music_Title_Code = tmt.MusicTrackCode OR @MusicTrackCode = '')
		INNER JOIN #TempMusicLabel AS tml ON (MST.Music_Label_Code = tml.MusicLabelCode OR @MusicLabelCode = '')
		INNER JOIN #TempChannel AS tchn ON (MST.Channel_Code = tchn.ChannelCode OR @ChannelCode = '')
		INNER JOIN #TempContent AS tcnt ON (COALESCE(TC.Episode_Title, T.Title_Name) COLLATE DATABASE_DEFAULT  = tcnt.ContentCode COLLATE DATABASE_DEFAULT OR @ContentCode='')
		LEFT JOIN Music_Label AS ML ON ML.Music_Label_Code = MST.Music_Label_Code
		WHERE ISNULL(MST.Is_Exception, '') COLLATE DATABASE_DEFAULT = 'Y' COLLATE DATABASE_DEFAULT
		AND Convert(Date,BST.Schedule_Item_Log_Date,103) BETWEEN @StartDate AND @EndDate
		AND (
			(@IsAired='Y' AND Convert(Date,BST.Schedule_Item_Log_Date,103) < Convert(Date,GETDATE(),103)) OR 
			(@IsAired='N' AND Convert(Date,BST.Schedule_Item_Log_Date,103) >= Convert(Date,GETDATE(),103)) OR 
			@IsAired='NA'
		)
		AND (@EpisodeFrom='' OR (@EpisodeFrom <= TC.Episode_No)) 
		AND (@EpisodeTo='' OR (@EpisodeTo >= TC.Episode_No)) 
		AND (@InitialResponse='' OR (MST.Initial_Response COLLATE DATABASE_DEFAULT  IN(SELECT InitialResponse FROM #InitialResp)))
		AND (
			@ExceptionStatus='' OR (MST.Workflow_Status COLLATE DATABASE_DEFAULT IN(SELECT ExceptionStatus FROM #Exceptions)) OR 
			(@ExceptionStatus LIKE '%O%' AND MST.Workflow_Status IS NULL)
		)
	)
	SELECT ROW_NUMBER()  OVER(ORDER BY Music_Schedule_Transaction_Code DESC) RowNumber,*  INTO #TEMP FROM CTE 
	WHERE (
		@CommonSearch = '' OR 
		(Content_Name Like '%'+@CommonSearch+'%') OR (Music_Track Like '%'+@CommonSearch+'%') OR 
		(Music_Label Like '%'+@CommonSearch+'%') OR (Channel Like '%'+@CommonSearch+'%')
	) 
	AND (@IsAired='Y' OR @IsAired='N'  OR (@IsAired='NA' AND Exceptions='DNF' ))


	SELECT @RecordCount = COUNT(*) FROM #TEMP (nolock) 

	SELECT Music_Schedule_Transaction_Code, Content_Name, CAST (Eps AS VARCHAR) AS Eps, Dur, Airing_Date, Airing_Time, Channel, Music_Track, Movie_Album, Music_Label, 
	Music_Dur, Exceptions,
	CASE ISNULL(Workflow_Status, '')
		WHEN '' THEN 'Open' 
		WHEN 'W' THEN 'Waiting for authorization'
		WHEN 'A' THEN 'Approved'
		WHEN 'R' THEN 'Rejected' 
	END AS [Status], 
	CASE ISNULL(Initial_Response, '')
		WHEN '' THEN '' 
		WHEN 'O' THEN 'Override'
		WHEN 'I' THEN 'Ignore' 
	END AS Initial_Response, Workflow_Status, 
	[dbo].[UFN_Music_Exception_Button_Visibility](Music_Schedule_Transaction_Code, @UserCode, Workflow_Status) AS Button_Visibility,
	[dbo].[UFN_Check_Workflow](@UserCode, Music_Schedule_Transaction_Code) AS IsZeroWorkflow, RowNumber 
	FROM #TEMP
	WHERE ((((RowNumber BETWEEN (((@PageNo - 1)* @PageSize) + 1) AND (@PageNo * @PageSize)) OR ISNULL(@PageSize,'')='') AND @IsPaging='Y') OR @IsPaging='N')


	IF OBJECT_ID('tempdb..#Exceptions') IS NOT NULL DROP TABLE #Exceptions
	IF OBJECT_ID('tempdb..#InitialResp') IS NOT NULL DROP TABLE #InitialResp
	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
	IF OBJECT_ID('tempdb..#TempChannel') IS NOT NULL DROP TABLE #TempChannel
	IF OBJECT_ID('tempdb..#TempContent') IS NOT NULL DROP TABLE #TempContent
	IF OBJECT_ID('tempdb..#TempMusicLabel') IS NOT NULL DROP TABLE #TempMusicLabel
	IF OBJECT_ID('tempdb..#TempMusicTrack') IS NOT NULL DROP TABLE #TempMusicTrack
END