CREATE PROC USP_MusicLabelConsumption_Report
(
--DECLARE
	@Title_Codes VARCHAR(MAX) = null , @Music_Label_Codes VARCHAR(MAX) = null, 
	@AiringDate_From DATETIME = null, @AiringDate_To DATETIME = null
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
	--DECLARE @Title_Codes VARCHAR(MAX) = NULL, @Music_Label_Codes VARCHAR(MAX) = '1,2,7,8,9', 
	--@AiringDate_From DATETIME = NULL, @AiringDate_To DATETIME = NULL

	SELECT @Title_Codes = LTRIM(RTRIM(ISNULL(@Title_Codes, ''))), @Music_Label_Codes = LTRIM(RTRIM(ISNULL(@Music_Label_Codes, ''))),
	@AiringDate_From = LTRIM(RTRIM(ISNULL(@AiringDate_From, ''))), @AiringDate_To = LTRIM(RTRIM(ISNULL(@AiringDate_To, '')))

	IF(OBJECT_ID('TEMPDB..#Title_Temp') IS NOT NULL)
		DROP TABLE #Title_Temp

	IF(OBJECT_ID('TEMPDB..#Music_Label_Temp') IS NOT NULL)
		DROP TABLE #Music_Label_Temp

	SELECT number AS Title_Code INTO #Title_Temp FROM fn_Split_withdelemiter(@Title_Codes, ',') where number <> ''
	SELECT number AS Music_Label_Code INTO #Music_Label_Temp FROM fn_Split_withdelemiter(@Music_Label_Codes, ',') where number <> ''

	--SELECT T.Title_Code, T.Title_Name, V.Version_Code, V.Version_Name, ML.Music_Label_Code, ML.Music_Label_Name,
	SELECT MD.Agreement_No, T.Title_Code, T.Title_Name, ML.Music_Label_Code, ML.Music_Label_Name,  
	MD.No_OF_songs AS Total_No_Of_Songs, COUNT(MST.Content_Music_Link_Code) AS Music_Track_Consumption,
	P.Program_Name AS [Program Name],MD.Run_Type AS [Run_Type]
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
END
GO
--exec USP_MusicLabelConsumption_Report '','1,2,7,8,9','',''
--select * from Music_Deal where Music_Deal_Code=59
--select DISTINCT *  from Music_Schedule_Transaction where Music_Deal_Code=59
--select * from Music_Label where Music_Label_Code=43
