CREATE PROCEDURE USP_Music_Exception_Handling
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
	@CommonSearch NVARCHAR(1000)=''
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
	--@CommonSearch NVARCHAR(1000)=''

	IF(OBJECT_ID('TEMPDB..#TEMP') IS NOT NULL)
		DROP TABLE #TEMP

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
		CASE ISNULL(MST.Workflow_Status, '')
			WHEN '' THEN 'Open' 
			WHEN 'W' THEN 'Waiting for authorization'
			WHEN 'A' THEN 'Approved'
			WHEN 'R' THEN 'Rejected' 
		END AS [Status],
		CASE ISNULL(MST.Initial_Response, '')
			WHEN '' THEN '' 
			WHEN 'O' THEN 'Override'
			WHEN 'I' THEN 'Ignore' 
		END AS [Initial_Response],
		CASE 
			WHEN MST.Workflow_Status IS NOT NULL THEN RTRIM(LTRIM(MST.Workflow_Status)) 
			ELSE MST.Workflow_Status 
		END AS Workflow_Status,
		--[dbo].[UFN_Music_Exception_Button_Visibility](MST.Music_Schedule_Transaction_Code,@UserCode,MST.Workflow_Status) AS Button_Visibility,
		[dbo].[UFN_Check_Workflow](154,MST.Music_Schedule_Transaction_Code) AS IsZeroWorkflow
		FROM Music_Schedule_Transaction AS MST
		INNER JOIN BV_Schedule_Transaction AS BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
		INNER JOIN Content_Music_Link AS CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
		INNER JOIN Title_Content AS TC ON TC.Title_Content_Code = CML.Title_Content_Code
		INNER JOIN Title AS T ON T.Title_Code = TC.Title_Code
		INNER JOIN Music_Title AS MT ON MT.Music_Title_Code = CML.Music_Title_Code
		INNER JOIN Music_Album AS MA ON MT.Music_Album_Code = MA.Music_Album_Code
		INNER JOIN Channel AS C ON C.Channel_Code = MST.Channel_Code
		LEFT JOIN Music_Label AS ML ON ML.Music_Label_Code = MST.Music_Label_Code
		
		WHERE ISNULL(MST.Is_Exception, '') = 'Y' 
		AND (
			(@IsAired='Y' AND Convert(Date,BST.Schedule_Item_Log_Date,103) < Convert(Date,GETDATE(),103)) OR 
			(@IsAired='N' AND Convert(Date,BST.Schedule_Item_Log_Date,103) >= Convert(Date,GETDATE(),103)) OR 
			@IsAired='NA'
		) 
		AND (@MusicTrackCode='' OR (CML.Music_Title_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicTrackCode, ',')))) 
		AND (@MusicLabelCode='' OR (MST.Music_Label_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicLabelCode, ',')))) 
		AND (@ChannelCode='' OR (MST.Channel_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@ChannelCode,','))))
		AND (@ContentCode='' OR (COALESCE(TC.Episode_Title, T.Title_Name) IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@ContentCode, ',')))) 
		AND (@EpisodeFrom='' OR (@EpisodeFrom <= TC.Episode_No)) 
		AND (@EpisodeTo='' OR (@EpisodeTo >= TC.Episode_No)) 
		AND (@InitialResponse='' OR (MST.Initial_Response  IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@InitialResponse, ','))))
		AND (
			@ExceptionStatus='' OR (MST.Workflow_Status IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@ExceptionStatus, ','))) OR 
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
	Music_Dur, Exceptions, [Status], Initial_Response, Workflow_Status, 
	[dbo].[UFN_Music_Exception_Button_Visibility](Music_Schedule_Transaction_Code, @UserCode, Workflow_Status) AS Button_Visibility,
	IsZeroWorkflow, RowNumber 
	FROM #TEMP
	WHERE ((((RowNumber BETWEEN (((@PageNo - 1)* @PageSize) + 1) AND (@PageNo * @PageSize)) OR ISNULL(@PageSize,'')='') AND @IsPaging='Y') OR @IsPaging='N')
END


