CREATE PROCEDURE [dbo].[USP_Music_Exception_Report]
(
--DECLARE
	@IsAired CHAR(2)='Y',
	@ContentCode NVARCHAR(4000)='',
	@MusicLabelCode VARCHAR(1000)='',
	@ChannelCode VARCHAR(1000)='',
	@EpisodeFrom VARCHAR(20)='',
	@EpisodeTo VARCHAR(20)='',
	@DateFrom VARCHAR(20)='',
	@DateTo VARCHAR(20)='',
	@SysLanguageCode INT 
)
AS
/*==============================================
Author:			Anchal Sikarwar
Create date:	17 NOV, 2016
Description:	Report for Music Exception Report
===============================================*/
BEGIN
	
	DECLARE
	--@IsAired CHAR(2)='Y',
	--@ContentCode NVARCHAR(4000)='',
	--@MusicLabelCode VARCHAR(1000)='',
	--@ChannelCode VARCHAR(1000)='',
	--@EpisodeFrom VARCHAR(20)='',
	--@EpisodeTo VARCHAR(20)='',
	--@DateFrom VARCHAR(20)='',
	--@DateTo VARCHAR(20)='',
	--@SysLanguageCode INT = 3,
	@Col_Head01 NVARCHAR(MAX) = '',  
	@Col_Head02 NVARCHAR(MAX) = '',  
	@Col_Head03 NVARCHAR(MAX) = '',
	@Col_Head04 NVARCHAR(MAX) = '',
	@Col_Head05 NVARCHAR(MAX) = '',
	@Col_Head06 NVARCHAR(MAX) = '',
	@Col_Head07 NVARCHAR(MAX) = '',
	@Col_Head08 NVARCHAR(MAX) = '',
	@Col_Head09 NVARCHAR(MAX) = '',
	@Col_Head10 NVARCHAR(MAX) = '',
	@Col_Head11 NVARCHAR(MAX) = '',
	@Col_Head12 NVARCHAR(MAX) = '',
	@Col_Head13 NVARCHAR(MAX) = ''
	

	SET FMTONLY OFF 
	
	IF OBJECT_ID('TEMPDB..#TEMP') IS NOT NULL
		DROP TABLE #TEMP
		
	IF OBJECT_ID('TEMPDB..#MusicExceptionHeader') IS NOT NULL
		DROP TABLE #MusicExceptionHeader
		

	SELECT DISTINCT
	COALESCE(TC.Episode_Title,MT.Music_Title_Name) AS Content_Name,
	TC.Episode_No AS Eps, V.[Version_Name], 
	--Convert(VARCHAR(12),FORMAT(Convert(datetime,BST.Schedule_Item_Log_Date,0),'dd-MMM-yyyy'),0) AS Airing_Date,
		CAST(BST.Schedule_Item_Log_Date as date) AS Airing_Date,
		   CAST('01-JAN-2000' as DATETIME) + CAST(BST.Schedule_Item_Log_Time as TIME) as Airing_Time,
	--BST.Schedule_Item_Log_Time AS Airing_Time,
	C.Channel_Name AS Channel,
	ML.Music_Label_Name AS Music_Label,
	MA.Music_Album_Name AS Movie_Album,
	MT.Music_Title_Name AS Music_Track,
	REVERSE(STUFF(REVERSE(STUFF((
		Select DISTINCT  RTRIM(LTRIM(TA.Error_Description))+'~'
		from Music_Schedule_Exception MTT1
		INNER JOIN Error_Code_Master TA ON MTT1.Error_Code=TA.Error_Code
		where MTT1.Music_Schedule_Transaction_Code=MST.Music_Schedule_Transaction_Code
		AND MTT1.[Status] = 'E'
		FOR XML PATH(''), root('Exceptions'), type
	).value('/Exceptions[1]','Nvarchar(max)'),2,0, '')), 1, 1, ''))  as Exceptions,
	CASE 
		WHEN MST.Initial_Response IS NULL THEN '' 
		WHEN MST.Initial_Response='O' THEN 'Override'
		WHEN MST.Initial_Response='I' THEN 'Ignore' 
	END AS [Initial_Response],
	CASE 
		WHEN MOR.Music_Override_Reason_Name IS NOT NULL AND  MST.Remarks IS NOT NULL THEN MOR.Music_Override_Reason_Name +'~~'+ MST.Remarks 
		WHEN MST.Remarks IS NOT NULL THEN MST.Remarks
		WHEN MOR.Music_Override_Reason_Name IS NOT NULL THEN MOR.Music_Override_Reason_Name
		ELSE '' 
	END AS Remarks,
	Convert(Date,BST.Schedule_Item_Log_Date,103) AS Scheduled_Date,  Convert(Date,GETDATE(),103) AS TodayDate,
	P.Program_Name AS [Program Name]
	INTO #MusicExceptionHeader
	--INTO #TEMP
	from Music_Schedule_Transaction AS MST
	INNER JOIN BV_Schedule_Transaction AS BST ON BST.BV_Schedule_Transaction_Code= MST.BV_Schedule_Transaction_Code

	INNER JOIN Content_Music_Link AS CML ON CML.Content_Music_Link_Code=MST.Content_Music_Link_Code
	INNER JOIn Title_Content TC On TC.Title_Content_Code = CML.Title_Content_Code
	INNER JOIn Title_Content_Version TCV On TCV.Title_Content_Code = TC.Title_Content_Code AND TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code
	
	INNER JOIN [Version] V ON V.Version_Code = TCV.Version_Code

	--INNER JOIN Title_Content_Mapping AS TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
	--INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code=TCM.Acq_Deal_Movie_Code

	--INNER JOIn Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code AND CCR.Content_Channel_Run_Code = BST.Content_Channel_Run_Code

	INNER JOIN Title AS T ON T.Title_Code = TC.Title_Code
	INNER JOIN Music_Title AS MT ON MT.Music_Title_Code = CML.Music_Title_Code
	INNER JOIN Music_Album AS MA ON MT.Music_Album_Code = MA.Music_Album_Code
	INNER JOIN Music_Label AS ML ON ML.Music_Label_Code = MST.Music_Label_Code
	INNER JOIN Channel AS C ON C.Channel_Code = MST.Channel_Code
	LEFT JOIN Program P ON T.Program_Code = P.Program_Code
	LEFT JOIN Music_Override_Reason AS MOR ON MST.Music_Override_Reason_Code = MOR.Music_Override_Reason_Code
	WHERE ISNULL(MST.Is_Exception,'') = 'Y' 
	AND (
		(@IsAired='Y' AND Convert(Date,BST.Schedule_Item_Log_Date,103) < Convert(Date,GETDATE(),103)) 
		OR (@IsAired='N' AND Convert(Date,BST.Schedule_Item_Log_Date,103) >= Convert(Date,GETDATE(),103)) 
		OR @IsAired='NA'
	)
	AND (@ContentCode = '' OR (COALESCE(TC.Title_Code,T.Title_Code) IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@ContentCode,','))))
	AND (ISNULL(@MusicLabelCode,'') = '' OR (MST.Music_Label_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicLabelCode,','))))
	AND (ISNULL(@ChannelCode,'') = '' OR (MST.Channel_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(ISNULL(@ChannelCode,''),','))))
	AND (ISNULL(@EpisodeFrom,'') = '' OR (@EpisodeFrom <= TC.Episode_No))
	AND (ISNULL(@EpisodeTo,'') = '' OR (@EpisodeTo >= TC.Episode_No))
	AND (ISNULL(MST.Workflow_Status, '') NOT IN('O','open','null','Open'))
	AND (
		ISNULL(@DateFrom,'') = '' OR ISNULL(@DateTo,'') = ''
		OR (
			ISNULL(@DateFrom,'') != '' AND ISNULL(@DateTo,'') != '' 
			AND	(Convert(Date,BST.Schedule_Item_Log_Date,103) >= Convert(Date,@DateFrom,103)
			AND  Convert(Date,BST.Schedule_Item_Log_Date,103) <= Convert(Date,@DateTo,103))
		)
	)
	AND ((ISNULL(@DateFrom,'') = '' OR (Convert(Date,BST.Schedule_Item_Log_Date,103) >= Convert(Date,@DateFrom,103))))
	AND ((ISNULL(@DateTo,'') = '' OR (Convert(Date,BST.Schedule_Item_Log_Date,103) <= Convert(Date,@DateTo,103))))

	 SELECT 
	 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
     @Col_Head02 = CASE WHEN  SM.Message_Key = 'Content' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
     @Col_Head03 = CASE WHEN  SM.Message_Key = 'Episode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
	 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
	 @Col_Head05 = CASE WHEN  SM.Message_Key = 'AiringDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
	 @Col_Head06 = CASE WHEN  SM.Message_Key = 'AiringTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
	 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Channel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
	 @Col_Head08 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
	 @Col_Head09 = CASE WHEN  SM.Message_Key = 'MovieAlbum' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
	 @Col_Head10 = CASE WHEN  SM.Message_Key = 'MusicTrack' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
	 @Col_Head11 = CASE WHEN  SM.Message_Key = 'Exceptions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
	 @Col_Head12 = CASE WHEN  SM.Message_Key = 'InitialResponse' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
	 @Col_Head13 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END

     FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('Program','Content','Episode','Version','AiringDate','AiringTime','Channel','MusicLabel','MovieAlbum','MusicTrack','Exceptions','InitialResponse','Remarks')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

		IF EXISTS(SELECT TOP 1 * FROM #MusicExceptionHeader)
		BEGIN
			SELECT [Content_Name],[Episode],[Version_Name],[Airing_Date],[Airing_Time],[Channel],[Music_Label],[Movie_Album],[Music_Track],
			[Exceptions],[Initial_Response],[Remarks],[Scheduled_Date],[TodayDate],[Program_Name]
			FROM (
				SELECT
				sorter = 1,
				CAST(Content_Name AS NVARCHAR(MAX)) AS [Content_Name],
				CAST(Eps AS varchar(100)) AS [Episode],
				CAST(Version_Name AS NVARCHAR(MAX)) AS [Version_Name],
				CAST(Airing_Date AS varchar(100)) AS [Airing_Date],
				CAST(Airing_Time AS varchar(100)) AS [Airing_Time],
				CAST([Channel] AS nvarchar(MAX)) AS [Channel],
				CAST(Music_Label AS nvarchar(MAX)) AS [Music_Label],
				CAST(Movie_Album AS nvarchar(MAX)) AS [Movie_Album],
				CAST(Music_Track AS nvarchar(MAX)) AS [Music_Track],
				CAST(Exceptions AS nvarchar(MAX)) AS [Exceptions],
				CAST(Initial_Response AS nvarchar(MAX)) AS [Initial_Response],
				CAST(Remarks AS nvarchar(MAX)) AS [Remarks],
				CAST(Scheduled_Date AS nvarchar(MAX)) AS [Scheduled_Date],
				CAST(TodayDate AS nvarchar(MAX)) AS [TodayDate],
				CAST([Program Name] AS nvarchar(MAX)) AS [Program_Name]
				
			From #MusicExceptionHeader
			UNION ALL
			  SELECT 0,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10,@Col_Head11,@Col_Head12,@Col_Head13,'','',@Col_Head01
			) X   
			ORDER BY Sorter
		END
		ELSE
		BEGIN
			SELECT * FROM #MusicExceptionHeader
		END

	IF OBJECT_ID('tempdb..#MusicExceptionHeader') IS NOT NULL DROP TABLE #MusicExceptionHeader
	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
	--SELECT * FROM #TEMP
END