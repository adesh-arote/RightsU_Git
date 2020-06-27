CREATE PROCEDURE [dbo].[USP_Music_Exception_Dashboard]
(
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
	@CommonSearch NVARCHAR(1000)=''
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

	CREATE TABLE #TEMP(MusicLabel NVARCHAR(500), OpenCount INT,InProcessCount INT, ClosedCount INT)
	CREATE TABLE #TEMP1(MusicLabel NVARCHAR(500),TCount INT, [Status] VARCHAR(100))

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
	INNER JOIN Music_Title AS MT ON MT.Music_Title_Code = CML.Music_Title_Code
	INNER JOIN Music_Label AS ML ON ML.Music_Label_Code = MST.Music_Label_Code
	INNER JOIN Channel AS C ON C.Channel_Code = MST.Channel_Code
	WHERE ISNULL(MST.Is_Exception, '') = 'Y' 
		AND (
		(@IsAired='Y' AND Convert(Date,BST.Schedule_Item_Log_Date,103) < Convert(Date,GETDATE(),103)) OR 
		(@IsAired='N' AND Convert(Date,BST.Schedule_Item_Log_Date,103) >= Convert(Date,GETDATE(),103))
	)
	AND (@MusicTrackCode = '' OR (CMl.Music_Title_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicTrackCode, ',')))) 
	AND (@MusicLabelCode = '' OR (MST.Music_Label_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicLabelCode, ',')))) 
	AND (@ChannelCode = '' OR (MST.Channel_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@ChannelCode,','))))
	AND	(@ContentCode = '' OR (COALESCE(TC.Episode_Title, MT.Music_Title_Name) IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@ContentCode, ',')))) 
	AND	(@EpisodeFrom = '' OR (@EpisodeFrom <= TC.Episode_No)) 
	AND	(@EpisodeTo = '' OR (@EpisodeTo >= TC.Episode_No))
	AND	(@InitialResponse = '' OR (MST.Initial_Response IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@InitialResponse, ','))))
	AND	(
		@ExceptionStatus = '' OR (@ExceptionStatus LIKE '%O%' AND MST.Workflow_Status IS NULL) OR
		(MST.Workflow_Status IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@ExceptionStatus, ','))) 
	)
	AND (
		@CommonSearch = '' OR (COALESCE(TC.Episode_Title,MT.Music_Title_Name) Like '%' + @CommonSearch + '%') OR 
		(MT.Music_Title_Name Like '%' + @CommonSearch + '%') OR
		(ML.Music_Label_Name Like '%' + @CommonSearch + '%') OR 
		(C.Channel_Name Like '%' + @CommonSearch + '%')
	) 
	GROUP BY Music_Label_Name ,Workflow_Status

	INSERT INTO #TEMP(MusicLabel,OpenCount,ClosedCount,InProcessCount)
	SELECT MusicLabel,[Open],[Closed],[IN Process]
	FROM (SELECT MusicLabel, Tcount, [Status] FROM #TEMP1) AS TMP
	PIVOT (
		SUM(TCount)
		FOR Status IN ([Open],[Closed],[IN Process])
	)AS PVT

	SELECT MusicLabel, OpenCount , InProcessCount , ClosedCount FROM #TEMP
END