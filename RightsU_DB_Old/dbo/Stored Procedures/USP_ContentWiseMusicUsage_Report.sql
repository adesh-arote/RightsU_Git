CREATE PROC USP_ContentWiseMusicUsage_Report
(
	@Title_Codes VARCHAR(MAX) = NULL, 
	@AiringDate_From VARCHAR(30) = NULL, 
	@AiringDate_To VARCHAR(30) = NULL
)
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	03 November 2016
Description:	Content wise Music Usage Report
=======================================================================================================================================*/
BEGIN
	--DECLARE @Title_Codes VARCHAR(MAX) = NULL,
	--@AiringDate_From DATETIME = NULL, @AiringDate_To DATETIME = NULL

	SELECT @Title_Codes = LTRIM(RTRIM(ISNULL(@Title_Codes, ''))), @AiringDate_From = LTRIM(RTRIM(ISNULL(@AiringDate_From, ''))), 
	@AiringDate_To = LTRIM(RTRIM(ISNULL(@AiringDate_To, '')))

	IF(OBJECT_ID('TEMPDB..#Title_Temp') IS NOT NULL)
		DROP TABLE #Title_Temp

	IF(OBJECT_ID('TEMPDB..#TempData') IS NOT NULL)
		DROP TABLE #TempData

	SELECT number AS Title_Code INTO #Title_Temp FROM fn_Split_withdelemiter(@Title_Codes, ',') where number <> ''

	SELECT Title_Name, Version_Name, Month_Year, COUNT(Music_Schedule_Transaction_Code) AS Music_Track_Count INTO #TempData FROM
	(
		SELECT T.Title_Name, V.Version_Name, MST.Music_Schedule_Transaction_Code, RIGHT(CONVERT(VARCHAR(11), CAST(BST.Schedule_Item_Log_Date AS DATETIME), 106), 8) AS Month_Year
		FROM Music_Schedule_Transaction MST
		INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
		INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
		INNER JOIN Title_Content TC ON TC.Title_Content_Code = CML.Title_Content_Code
		INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Code = CML.Title_Content_Code AND TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code
		INNER JOIN [Version] V ON V.Version_Code = TCV.Version_Code
		INNER JOIN Title T ON T.Title_Code = BST.Title_Code AND TC.Title_Code = BST.Title_Code
		WHERE
		 ISNULL(MST.Is_Ignore, '') = 'N'
		AND (BST.Title_Code IN (SELECT DISTINCT Title_Code FROM #Title_Temp) OR @Title_Codes = '')
		AND (CAST(BST.Schedule_Item_Log_Date AS DATETIME) >= CAST(@AiringDate_From AS DATETIME) OR @AiringDate_From = '')
		AND (CAST(BST.Schedule_Item_Log_Date AS DATETIME) <= CAST(@AiringDate_To AS DATETIME) OR @AiringDate_To = '')
	) AS A
	GROUP BY Title_Name, Version_Name, Month_Year
	SELECT Title_Name, Version_Name, Month_Year, Music_Track_Count FROM #TempData
END