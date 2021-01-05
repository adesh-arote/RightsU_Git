CREATE PROC USP_ChannelWiseMusicUsage_Report
(
	@Music_Label_Codes VARCHAR(MAX), 
	@Channel_Codes VARCHAR(MAX), 
	@Title_Codes VARCHAR(MAX) = NULL,
	@AiringDate_From VARCHAR(30) = NULL, 
	@AiringDate_To VARCHAR(30) = NULL
)
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	03 November 2016
Description:	MusicLabel->Channel->Content wise Music Usage Report
=======================================================================================================================================*/
BEGIN
	
	--DECLARE @Music_Label_Codes VARCHAR(MAX), @Channel_Codes VARCHAR(MAX), @Title_Codes VARCHAR(MAX) = NULL,
	--@AiringDate_From VARCHAR(30) = NULL, @AiringDate_To VARCHAR(30) = NULL

	SELECT @Music_Label_Codes = LTRIM(RTRIM(ISNULL(@Music_Label_Codes, ''))), @Channel_Codes = LTRIM(RTRIM(ISNULL(@Channel_Codes, ''))), 
	@Title_Codes = LTRIM(RTRIM(ISNULL(@Title_Codes, ''))), 
	@AiringDate_From = LTRIM(RTRIM(ISNULL(@AiringDate_From, ''))), @AiringDate_To = LTRIM(RTRIM(ISNULL(@AiringDate_To, '')))

	IF(OBJECT_ID('TEMPDB..#MusicLabel_Temp') IS NOT NULL)
		DROP TABLE #MusicLabel_Temp

	IF(OBJECT_ID('TEMPDB..#Channel_Temp') IS NOT NULL)
		DROP TABLE #Channel_Temp

	IF(OBJECT_ID('TEMPDB..#Title_Temp') IS NOT NULL)
		DROP TABLE #Title_Temp

	IF(OBJECT_ID('TEMPDB..#TempData') IS NOT NULL)
		DROP TABLE #TempData

	SELECT number AS Music_Lable_Code INTO #MusicLabel_Temp FROM fn_Split_withdelemiter(@Music_Label_Codes, ',') where number <> ''
	SELECT number AS Channel_Code INTO #Channel_Temp FROM fn_Split_withdelemiter(@Channel_Codes, ',') where number <> ''
	SELECT number AS Title_Code INTO #Title_Temp FROM fn_Split_withdelemiter(@Title_Codes, ',') where number <> ''

	SELECT Music_Label_Name, Channel_Name, Title_Name, Month_Year, COUNT(Music_Schedule_Transaction_Code) AS Music_Track_Count INTO #TempData FROM
	(
		SELECT ML.Music_Label_Name, C.Channel_Name, T.Title_Name, MST.Music_Schedule_Transaction_Code, RIGHT(CONVERT(VARCHAR(11), CAST(BST.Schedule_Item_Log_Date AS DATETIME), 106), 8) AS Month_Year
		FROM Music_Schedule_Transaction MST
		INNER JOIN Music_Label ML ON ML.Music_Label_Code = MST.Music_Label_Code
		INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
		INNER JOIN Title T ON T.Title_Code = BST.Title_Code
		INNER JOIN Channel C ON C.Channel_Code = MST.Channel_Code
		WHERE ISNULL(MST.Is_Ignore, '') = 'N'
		AND (MST.Music_Label_Code IN (SELECT DISTINCT TML.Music_Lable_Code FROM #MusicLabel_Temp TML) OR @Music_Label_Codes = '')
		AND (MST.Channel_Code IN (SELECT DISTINCT TC.Channel_Code FROM #Channel_Temp TC) OR @Channel_Codes = '')
		AND (BST.Title_Code IN (SELECT DISTINCT TT.Title_Code FROM #Title_Temp TT) OR @Title_Codes = '')
		AND (CAST(BST.Schedule_Item_Log_Date AS DATETIME) >= CAST(@AiringDate_From AS DATETIME) OR @AiringDate_From = '')
		AND (CAST(BST.Schedule_Item_Log_Date AS DATETIME) <= CAST(@AiringDate_To AS DATETIME) OR @AiringDate_To = '')
	) AS A
	GROUP BY Channel_Name, Music_Label_Name, Title_Name, Month_Year
	SELECT Channel_Name, Music_Label_Name, Title_Name, Month_Year, Music_Track_Count FROM #TempData

	IF OBJECT_ID('tempdb..#Channel_Temp') IS NOT NULL DROP TABLE #Channel_Temp
	IF OBJECT_ID('tempdb..#MusicLabel_Temp') IS NOT NULL DROP TABLE #MusicLabel_Temp
	IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
	IF OBJECT_ID('tempdb..#Title_Temp') IS NOT NULL DROP TABLE #Title_Temp
END