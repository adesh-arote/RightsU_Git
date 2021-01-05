CREATE PROC USP_MusicLabelConsumption_Report
(
--DECLARE
	@Title_Codes VARCHAR(MAX) = null , @Music_Label_Codes VARCHAR(MAX) = null, 
	@AiringDate_From DATETIME = null, @AiringDate_To DATETIME = null, @SysLanguageCode INT = 1 
)
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	03 November 2016
Description:	Music Lable Consumption Report
Last change by: Akshay Rane
Changes:		Added Agreement no in procedure
=======================================================================================================================================*/
BEGIN
	DECLARE
	--@Title_Codes VARCHAR(MAX) = '', @Music_Label_Codes VARCHAR(MAX) = '', 
	--@AiringDate_From DATETIME = '', @AiringDate_To DATETIME = '',@SysLanguageCode INT = 1,
	@Col_Head01 NVARCHAR(MAX) = '',  
	@Col_Head02 NVARCHAR(MAX) = '',  
	@Col_Head03 NVARCHAR(MAX) = '',
	@Col_Head04 NVARCHAR(MAX) = '',
	@Col_Head05 NVARCHAR(MAX) = '',
	@Col_Head06 NVARCHAR(MAX) = ''

	SELECT @Title_Codes = LTRIM(RTRIM(ISNULL(@Title_Codes, ''))), @Music_Label_Codes = LTRIM(RTRIM(ISNULL(@Music_Label_Codes, ''))),
	@AiringDate_From = LTRIM(RTRIM(ISNULL(@AiringDate_From, ''))), @AiringDate_To = LTRIM(RTRIM(ISNULL(@AiringDate_To, '')))

	IF(OBJECT_ID('TEMPDB..#Title_Temp') IS NOT NULL)
		DROP TABLE #Title_Temp

	IF(OBJECT_ID('TEMPDB..#Music_Label_Temp') IS NOT NULL)
		DROP TABLE #Music_Label_Temp

	IF(OBJECT_ID('TEMPDB..#MusicLabelConsumptionHeader') IS NOT NULL)
		DROP TABLE #MusicLabelConsumptionHeader

	SELECT number AS Title_Code INTO #Title_Temp FROM fn_Split_withdelemiter(@Title_Codes, ',') where number <> ''
	SELECT number AS Music_Label_Code INTO #Music_Label_Temp FROM fn_Split_withdelemiter(@Music_Label_Codes, ',') where number <> ''

	--SELECT T.Title_Code, T.Title_Name, V.Version_Code, V.Version_Name, ML.Music_Label_Code, ML.Music_Label_Name,
	SELECT MD.Agreement_No, T.Title_Code, T.Title_Name, ML.Music_Label_Code, ML.Music_Label_Name,  
	MD.No_OF_songs AS Total_No_Of_Songs, COUNT(MST.Content_Music_Link_Code) AS Music_Track_Consumption,
	P.Program_Name AS [Program Name],MD.Run_Type AS [Run_Type]
	INTO #MusicLabelConsumptionHeader
	--CONVERT(VARCHAR(11), MIN(CAST(BST.Schedule_Item_Log_Date AS DATETIME)), 103) AS [From], CONVERT(VARCHAR(11), MAX(CAST(BST.Schedule_Item_Log_Date AS DATETIME)), 103) AS [To]
	FROM Music_Schedule_Transaction MST
	INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
	INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
	INNER JOIN Title_Content TC ON TC.Title_Content_Code = CML.Title_Content_Code
	INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Code = CML.Title_Content_Code AND TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code
	--INNER JOIN [Version] V ON V.Version_Code = TCV.Version_Code
	INNER JOIN Title T ON T.Title_Code = BST.Title_Code AND TC.Title_Code = BST.Title_Code
	INNER JOIN Music_Label ML ON ML.Music_Label_Code = MST.Music_Label_Code
	INNER JOIN  Music_Deal MD ON MD.Music_Deal_Code = MST.Music_Deal_Code
	LEFT JOIN Program P ON T.Program_Code = P.Program_Code
	WHERE ISNULL(MST.Is_Ignore, '') = 'N'
	AND (BST.Title_Code IN (SELECT DISTINCT Title_Code FROM #Title_Temp) OR @Title_Codes = '')
	AND (MST.Music_Label_Code IN (SELECT DISTINCT Music_Label_Code FROM #Music_Label_Temp) OR @Music_Label_Codes = '')
	AND (CAST(BST.Schedule_Item_Log_Date AS DATETIME) >= CAST(@AiringDate_From AS DATETIME) OR @AiringDate_From = '')
	AND (CAST(BST.Schedule_Item_Log_Date AS DATETIME) <= CAST(@AiringDate_To AS DATETIME) OR @AiringDate_To = '')
	GROUP BY MD.Agreement_No, ML.Music_Label_Code, ML.Music_Label_Name, T.Title_Code, T.Title_Name, MD.No_OF_songs, P.Program_Name,MD.Run_Type

	 SELECT 
	 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
     @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
     @Col_Head03 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
	 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Content' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
	 @Col_Head05 = CASE WHEN  SM.Message_Key = 'TotalNoOfSongs' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
	 @Col_Head06 = CASE WHEN  SM.Message_Key = 'MusicTrackConsumed' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END

     FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('AgreementNo','MusicLabel','Program','Content','TotalNoOfSongs','MusicTrackConsumed')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

		  SELECT [Agreement_No],[Title_Code],[Title_Name],[Music_Label_Code],[Music_Label_Name],[Total_No_Of_Songs],[Music_Track_Consumption],[Program_Name],[Run_Type]
		  FROM (
			    SELECT
				sorter = 1,
				CAST(Agreement_No AS VARCHAR(100)) AS [Agreement_No],
				CAST(Title_Code AS NVARCHAR(MAX)) AS [Title_Code],
				CAST(Title_Name AS NVARCHAR(MAX)) AS [Title_Name],
				CAST(Music_Label_Code AS NVARCHAR(MAX)) AS [Music_Label_Code],
				CAST(Music_Label_Name AS NVARCHAR(MAX)) AS [Music_Label_Name],
				CAST(Total_No_Of_Songs AS NVARCHAR(MAX)) AS [Total_No_Of_Songs],
				CAST(Music_Track_Consumption AS NVARCHAR(MAX)) AS [Music_Track_Consumption],
				CAST([Program Name] AS NVARCHAR(MAX)) AS [Program_Name],
				CAST(Run_Type AS varchar(100)) AS [Run_Type]
  				
				From #MusicLabelConsumptionHeader
				UNION ALL
				  SELECT 0,@Col_Head01,'',@Col_Head04,'',@Col_Head02,@Col_Head05,@Col_Head06,@Col_Head03,''
				 ) X   
			ORDER BY Sorter

	IF OBJECT_ID('tempdb..#Music_Label_Temp') IS NOT NULL DROP TABLE #Music_Label_Temp
	IF OBJECT_ID('tempdb..#MusicLabelConsumptionHeader') IS NOT NULL DROP TABLE #MusicLabelConsumptionHeader
	IF OBJECT_ID('tempdb..#Title_Temp') IS NOT NULL DROP TABLE #Title_Temp
END