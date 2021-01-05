CREATE PROCEDURE [dbo].[USP_BV_Title_Mapping_Shows]
	@BV_HouseID_Data_Code VARCHAR(500)
AS
BEGIN

	CREATE TABLE #TempBv(
		bv_Title VARCHAR(1000),
		Title_Content_Code INT,
		Title_Code INT
	)

	INSERT INTO #TempBv(bv_Title, Title_Content_Code, Title_Code)
	SELECT BV_Title, Title_Content_Code, Title_Code FROM BV_HouseId_Data
	WHERE BV_HouseId_Data_Code IN (SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@BV_HouseID_Data_Code, ',') WHERE NUMBER <> '')

	SELECT DISTINCT(B.BV_HouseId_Data_Code), TC.Title_Content_Code, TC.Title_Code, B.Program_Episode_ID
	INTO #TEMP_BVDATA
	FROM BV_HouseId_Data B
	INNER JOIN Title_Content TC ON RIGHT('0000' + CAST(TC.Episode_No AS VARCHAR(10)), 4) = RIGHT('0000' + CAST(B.Episode_No AS VARCHAR(10)), 4)
	INNER JOIN #TempBv tmpBV ON TC.Title_Code = tmpBV.Title_Code
	AND B.BV_Title COLLATE SQL_Latin1_General_CP1_CI_AS = tmpBV.bv_Title COLLATE SQL_Latin1_General_CP1_CI_AS
	WHERE B.Is_Mapped = 'N'

	UPDATE TC
	SET TC.Ref_BMS_Content_Code = TB.Program_Episode_ID
	FROM Title_Content TC
	INNER JOIN #TEMP_BVDATA TB ON TB.Title_Content_Code = TC.Title_Content_Code

	UPDATE B
	SET B.Title_Code = TB.Title_Code, B.Title_Content_Code = TB.Title_Content_Code, B.Is_Mapped = 'Y'
	FROM BV_HouseId_Data B
	INNER JOIN #TEMP_BVDATA TB ON TB.BV_HouseId_Data_Code = B.BV_HouseId_Data_Code
	WHERE B.Is_Mapped = 'N'

	IF OBJECT_ID('tempdb..#TEMP_BVDATA') IS NOT NULL DROP TABLE #TEMP_BVDATA
	IF OBJECT_ID('tempdb..#TempBv') IS NOT NULL DROP TABLE #TempBv
END