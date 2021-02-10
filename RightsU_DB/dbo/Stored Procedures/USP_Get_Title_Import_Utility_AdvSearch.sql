CREATE PROCEDURE USP_Get_Title_Import_Utility_AdvSearch
(
	@DM_Master_Import_Code INT,
	@CallFor VARCHAR(MAX)
)
AS
BEGIN
	--DECLARE @DM_Master_Import_Code INT = 42, @CallFor CHAR(2) = 'SC'

	SET NOCOUNT ON

	IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
	IF(OBJECT_ID('tempdb..#TempResult') IS NOT NULL) DROP TABLE #TempResult
	
	CREATE TABLE #TempResult
	(
		DisplayText VARCHAR(MAX),
		CallFor VARCHAR(MAX)
	)

	CREATE TABLE #TempTitleUnPivot(
		ExcelSrNo NVARCHAR(MAX),
		ColumnHeader NVARCHAR(MAX),
		TitleData NVARCHAR(MAX)
	)

	BEGIN

		INSERT INTO #TempTitleUnPivot(ExcelSrNo, ColumnHeader, TitleData)
		SELECT Col1, LTRIM(RTRIM(ColumnHeader)), LTRIM(RTRIM(TitleData))
		FROM
		(
			SELECT Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99, Col100, Record_Status, Error_message, Is_Ignore 
			FROM DM_Title_Import_Utility_Data 
			WHERE DM_Master_Import_Code = @DM_Master_Import_Code
		) AS cp
		UNPIVOT 
		(
			TitleData FOR ColumnHeader IN (Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99, Col100, Record_Status, Error_message, Is_Ignore)
		) AS up

		UPDATE T2 SET T2.ColumnHeader = T1.TitleData
		FROM (
			SELECT * FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		) AS T1
		INNER JOIN #TempTitleUnPivot T2 ON T1.ColumnHeader = T2.ColumnHeader

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		DELETE FROM #TempTitleUnPivot WHERE TitleData = ''

	END

	--IF (@CallFor = 'TN')
	BEGIN
		INSERT INTO #TempResult (DisplayText, CallFor)
		SELECT TitleData, 'TN' FROM #TempTitleUnPivot WHERE ColumnHeader =  'Title Name'
	END

	--IF (@CallFor = 'TT')
	BEGIN
		INSERT INTO #TempResult (DisplayText, CallFor)
		SELECT TitleData, 'TT' FROM #TempTitleUnPivot WHERE ColumnHeader =  'Title Type'
	END

	--IF (@CallFor = 'TL')
	BEGIN
		INSERT INTO #TempResult (DisplayText, CallFor)
		SELECT TitleData, 'TL' FROM #TempTitleUnPivot WHERE ColumnHeader =  'Title Language name'
	END

	--IF (@CallFor = 'DR')
	BEGIN
		INSERT INTO #TempResult (DisplayText, CallFor)
		SELECT DISTINCT LTRIM(RTRIM(f.Number)), 'DR' FROM #TempTitleUnPivot upvot
		CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
		WHERE upvot.ColumnHeader = 'Director' AND ISNULL(f.Number, '') <> ''
	END

	--IF (@CallFor = 'SC')
	BEGIN
		INSERT INTO #TempResult (DisplayText, CallFor)
		SELECT DISTINCT LTRIM(RTRIM(f.Number)), 'SC' FROM #TempTitleUnPivot upvot
		CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
		WHERE upvot.ColumnHeader = 'Star Cast' AND ISNULL(f.Number, '') <> ''
	END

	--IF (@CallFor = 'EM')
	BEGIN
		INSERT INTO #TempResult (DisplayText, CallFor)
		SELECT TitleData ,'EM' FROM #TempTitleUnPivot WHERE ColumnHeader =  'Error_message'
	END

	SELECT DisplayText, CallFor FROM #TempResult

	IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
	IF(OBJECT_ID('tempdb..#TempResult') IS NOT NULL) DROP TABLE #TempResult
END

/*
TN = Title Name 
TT = Title Type
TL = Title Language
SC = Ket Start Cast
DR = Director
ML = Music Label
EM = Error Message

EXEC USP_Get_Title_Import_Utility_AdvSearch 44,''
*/

