
CREATE PROC USP_Get_Platform_Code_For_Syn_Run
(
	@Syn_Deal_Code INT, 
	@Title_Codes VARCHAR(MAX), 
	@CodeType VARCHAR(3)
)
AS
BEGIN

	--DECLARE @Syn_Deal_Code INT = 46, 
	--@Title_Codes VARCHAR(MAX) = '82' /*'2943'*/, 
	--@CodeType VARCHAR(3) = 'DMC'

	
	IF (OBJECT_ID('TEMPDB..#SelectedTitles') IS NOT NULL)
	BEGIN
		DROP TABLE #SelectedTitles
	END

	CREATE TABLE #SelectedTitles
	(
		Title_Code INT,
		Episode_From INT,
		Episode_To INT
	)

	IF(@CodeType = 'DMC')
	BEGIN
		INSERT INTO #SelectedTitles(Title_Code,	Episode_From, Episode_To)
		SELECT DISTINCT Title_Code, Episode_From, Episode_End_To FROM Syn_Deal_Movie WHERE Syn_Deal_Movie_Code IN (
			SELECT number FROM fn_Split_withdelemiter(@Title_Codes, ','	)
		)
	END
	ELSE
	BEGIN
		INSERT INTO #SelectedTitles(Title_Code,	Episode_From, Episode_To)
		SELECT DISTINCT number AS Title_Code , 1 AS Episode_From, 1 AS Episode_To FROM fn_Split_withdelemiter(@Title_Codes, ','	)
	END

	DECLARE @Title_Count INT = 0, @Platform_Codes VARCHAR(MAX) = ''
	SELECT @Title_Count = COUNT(*) FROM #SelectedTitles 

	SELECT @Platform_Codes = @Platform_Codes +  ',' + CAST(Platform_Code AS VARCHAR) FROM (
	SELECT DISTINCT SDRP.Platform_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To FROM Syn_Deal SD 
	INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
	INNER JOIN #SelectedTitles ST ON SDRT.Title_Code = ST.Title_Code AND SDRT.Episode_From = ST.Episode_From AND SDRT.Episode_To = ST.Episode_To
	INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code AND SDRT.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code
	INNER JOIN Platform P ON SDRP.Platform_Code = P.Platform_Code AND  P.Is_Applicable_Syn_Run = 'Y'
	WHERE SD.Syn_Deal_Code = @Syn_Deal_Code
	) AS Tbl
	GROUP BY Platform_Code
	HAVING COUNT(*) = @Title_Count

	IF(LEN(@Platform_Codes) > 1)
	BEGIN
		SELECT RIGHT(@Platform_Codes, LEN(@Platform_Codes) - 1) As Platform_Codes
	END
	ELSE
		SELECT '' As Platform_Codes

	IF OBJECT_ID('tempdb..#SelectedTitles') IS NOT NULL DROP TABLE #SelectedTitles
END