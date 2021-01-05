CREATE PROCEDURE [dbo].[USP_Music_Exception_Dashboard]
(
--DECLARE
	@IsAired CHAR(1) = 'Y',                       
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
/*==============================================
Author:			Anchal Sikarwar
Create date:	19 Oct, 2016
Description:	List for Music Exception Handling
===============================================*/
BEGIN
	IF(OBJECT_ID('TEMPDB..#TEMP') IS NOT NULL)
		DROP TABLE #TEMP

	IF(OBJECT_ID('TEMPDB..#TEMP1') IS NOT NULL)
		DROP TABLE #TEMP1
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

	CREATE TABLE #TEMP(MusicLabel NVARCHAR(500), OpenCount INT,InProcessCount INT, ClosedCount INT)
	CREATE TABLE #TEMP1(MusicLabel NVARCHAR(500),TCount INT, [Status] VARCHAR(100))
	
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
	
	INSERT INTO #TEMP1(TCount,MusicLabel,[Status])
	SELECT Count(*) AS TCount, ML.Music_Label_Name AS MusicLabel,
	CASE 
		WHEN MST.Workflow_Status IS NULL OR  MST.Workflow_Status='R' OR  MST.Workflow_Status='O' OR  MST.Workflow_Status='Open' Then 'Open' 
		WHEN MST.Workflow_Status='W' THEN 'IN Process'
		WHEN MST.Workflow_Status='A' THEN 'Closed' 
	END AS [Status]
	FROM Music_Schedule_Transaction AS MST
	INNER JOIN BV_Schedule_Transaction AS BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
	INNER JOIN Content_Music_Link AS CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
	INNER JOIN Title_Content AS TC ON TC.Title_Content_Code = CML.Title_Content_Code
	INNER JOIN Title  AS T ON T.Title_Code=TC.Title_Code 
	INNER JOIN Music_Title AS MT ON MT.Music_Title_Code = CML.Music_Title_Code
	INNER JOIN Music_Label AS ML ON ML.Music_Label_Code = MST.Music_Label_Code
	INNER JOIN Channel AS C ON C.Channel_Code = MST.Channel_Code
	INNER JOIN #TempMusicTrack AS tmt ON (CML.Music_Title_Code = tmt.MusicTrackCode OR @MusicTrackCode = '')
	INNER JOIN #TempMusicLabel AS tml ON (MST.Music_Label_Code = tml.MusicLabelCode OR @MusicLabelCode = '')
	INNER JOIN #TempChannel AS tchn ON (MST.Channel_Code = tchn.ChannelCode OR @ChannelCode = '')
	INNER JOIN #TempContent AS tcnt ON (COALESCE(TC.Episode_Title, T.Title_Name) COLLATE DATABASE_DEFAULT  = tcnt.ContentCode COLLATE DATABASE_DEFAULT OR @ContentCode='')
	WHERE ISNULL(MST.Is_Exception, '')  COLLATE DATABASE_DEFAULT = 'Y' COLLATE DATABASE_DEFAULT
	AND Convert(Date,BST.Schedule_Item_Log_Date,103) BETWEEN @StartDate AND @EndDate
	AND (
		(@IsAired='Y' AND Convert(Date,BST.Schedule_Item_Log_Date,103) < Convert(Date,GETDATE(),103)) OR 
		(@IsAired='N' AND Convert(Date,BST.Schedule_Item_Log_Date,103) >= Convert(Date,GETDATE(),103))
	)
	AND	(@EpisodeFrom = '' OR (@EpisodeFrom <= TC.Episode_No)) 
	AND	(@EpisodeTo = '' OR (@EpisodeTo >= TC.Episode_No))
	AND	(@InitialResponse = '' OR (MST.Initial_Response COLLATE DATABASE_DEFAULT  IN(SELECT InitialResponse FROM #InitialResp))
	AND	(
		@ExceptionStatus='' OR (MST.Workflow_Status COLLATE DATABASE_DEFAULT IN(SELECT ExceptionStatus FROM #Exceptions)) OR 
			(@ExceptionStatus LIKE '%O%' AND MST.Workflow_Status IS NULL)
	)
	AND (
		@CommonSearch = '' OR (COALESCE(TC.Episode_Title,MT.Music_Title_Name) Like '%' + @CommonSearch + '%') OR 
		(MT.Music_Title_Name Like '%' + @CommonSearch + '%') OR
		(ML.Music_Label_Name Like '%' + @CommonSearch + '%') OR 
		(C.Channel_Name Like '%' + @CommonSearch + '%')
	) )
	GROUP BY Music_Label_Name ,Workflow_Status

	INSERT INTO #TEMP(MusicLabel,OpenCount,ClosedCount,InProcessCount)
	SELECT MusicLabel,[Open],[Closed],[IN Process]
	FROM (SELECT MusicLabel, Tcount, [Status] FROM #TEMP1) AS TMP
	PIVOT (
		SUM(TCount)
		FOR Status IN ([Open],[Closed],[IN Process])
	)AS PVT

	SELECT MusicLabel, OpenCount , InProcessCount , ClosedCount FROM #TEMP
	
	--DROP TABLE #TEMP
	--DROP TABLE #TEMP1
	--DROP TABLE #TempMusicTrack
	--DROP TABLE #TempMusicLabel
	--DROP TABLE #TempChannel
	--DROP TABLE #TempContent
	--DROP TABLE #InitialResp	
	--DROP TABLE #Exceptions

	IF OBJECT_ID('tempdb..#Exceptions') IS NOT NULL DROP TABLE #Exceptions
	IF OBJECT_ID('tempdb..#InitialResp') IS NOT NULL DROP TABLE #InitialResp
	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
	IF OBJECT_ID('tempdb..#TEMP1') IS NOT NULL DROP TABLE #TEMP1
	IF OBJECT_ID('tempdb..#TempChannel') IS NOT NULL DROP TABLE #TempChannel
	IF OBJECT_ID('tempdb..#TempContent') IS NOT NULL DROP TABLE #TempContent
	IF OBJECT_ID('tempdb..#TempMusicLabel') IS NOT NULL DROP TABLE #TempMusicLabel
	IF OBJECT_ID('tempdb..#TempMusicTrack') IS NOT NULL DROP TABLE #TempMusicTrack
END