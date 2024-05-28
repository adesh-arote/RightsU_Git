CREATE PROCEDURE [dbo].[USP_Get_ExcelSrNo](
	@DM_Master_Import_Code INT,
	@Keyword VARCHAR(MAX),
	@CallFor VARCHAR(MAX)
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_ExcelSrNo]', 'Step 1', 0, 'Started Procedure', 0, '' 
		--DECLARE 
		--	@DM_Master_Import_Code INT=115, 
		--	@Keyword NVARCHAR(MAX)='',
		--	@CallFor  VARCHAR(MAX) = 'TN~|TT~Web-Series|TL~Hindi,Marathi,English|SC~|DR~|EM~|'

		IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
		IF(OBJECT_ID('tempdb..#tmpSearchCategory') IS NOT NULL) DROP TABLE #tmpSearchCategory
		IF(OBJECT_ID('tempdb..#TmpExcelSrNo') IS NOT NULL) DROP TABLE #TmpExcelSrNo
		IF(OBJECT_ID('tempdb..#TmpExcelSrNoFinalResult') IS NOT NULL) DROP TABLE #TmpExcelSrNoFinalResult
	
		CREATE TABLE #TempTitleUnPivot(
			ExcelSrNo NVARCHAR(MAX),
			ColumnHeader NVARCHAR(MAX),
			TitleData NVARCHAR(MAX)
		)
		CREATE TABLE #TmpExcelSrNo
		(
			ExcelSrNo NVARCHAR(MAX)
		)

			CREATE TABLE #TmpExcelSrNoFinalResult
		(
			ExcelSrNo NVARCHAR(MAX)
		)


		IF	(@CallFor = '')
		BEGIN
			INSERT INTO #TmpExcelSrNoFinalResult(ExcelSrNo)
			SELECT A.ExcelLineNo FROM (
				SELECT  Col1 AS ExcelLineNo, CONCAT(Col2,'-',Col3,'-',Col4,'-',Col5,'-',Col6,'-',Col7,'-',Col8,'-',Col9,'-',Col10,'-',Col11,'-',Col12,'-',Col13,'-',Col14,'-',Col15,'-',Col17,'-',Col18,'-',Col19,'-',Col20,'-',Col21,'-',Col22,'-',Col23,'-',Col24,'-',Col25,'-',Col26,'-',Col27,'-',Col28,'-',Col29,'-',Col30,'-',Col31,'-',Col32,'-',Col33) As [Concatenate]
				FROM DM_Title_Import_Utility_Data 
				WHERE DM_Master_Import_Code= @DM_Master_Import_Code AND (ISNUMERIC(Col1) = 1 OR Col1 = '')
			) AS A WHERE A.Concatenate LIKE '%' + @Keyword +'%' 
		END
		ELSE
		BEGIN
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
		
			SELECT id as RowNo, number as Search_Category INTO #tmpSearchCategory FROM DBO.FN_Split_WithDelemiter(@CallFor, '|')
		
			DECLARE @count INT = 1, @TotalCount INT = 0, @SearchCategory NVARCHAR(MAX) = '', @Key NVARCHAR(MAX)= '', @Value NVARCHAR(MAX)= ''
		
			SELECT @TotalCount = COUNT(*) FROM #tmpSearchCategory
    
			WHILE @count <= @TotalCount
			BEGIN
				SELECT @SearchCategory = Search_Category FROM #tmpSearchCategory where RowNo = @count
				SELECT @Key  = number FROM DBO.FN_Split_WithDelemiter(@SearchCategory, '~') WHERE ID = 1
				SELECT @Value = number FROM DBO.FN_Split_WithDelemiter(@SearchCategory, '~') WHERE ID = 2
		
				IF(@Value <> '')
				BEGIN
				DELETE FROM #TmpExcelSrNo
					IF(@KEY = 'TN')
					BEGIN
						INSERT INTO #TmpExcelSrNo (ExcelSrNo)
						SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND TitleData COLLATE SQL_Latin1_General_CP1_CI_AS 
						IN (SELECT number from DBO.FN_Split_WithDelemiter(@Value, ',') WHERE number <> '')

						IF NOT EXISTS (SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
							SELECT ExcelSrNo FROM #TmpExcelSrNo 
						END

						IF EXISTS(SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							IF EXISTS(SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo )
							BEGIN
								INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
								SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo 
							END
							ELSE
								DELETE FROM #TmpExcelSrNoFinalResult
						END
					END

					IF(@KEY = 'TL')
					BEGIN
						INSERT INTO #TmpExcelSrNo (ExcelSrNo)
						SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Language name' AND TitleData COLLATE SQL_Latin1_General_CP1_CI_AS 
						IN (SELECT number from DBO.FN_Split_WithDelemiter(@Value, ',') WHERE number <> '')

						IF NOT EXISTS (SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
							SELECT ExcelSrNo FROM #TmpExcelSrNo 
						END

						IF EXISTS(SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							IF EXISTS(SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo )
							BEGIN
								INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
								SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo 
							END
							ELSE
								DELETE FROM #TmpExcelSrNoFinalResult
						END
					END

					IF(@KEY = 'TT')
					BEGIN
						INSERT INTO #TmpExcelSrNo (ExcelSrNo)
						SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Type' AND TitleData COLLATE SQL_Latin1_General_CP1_CI_AS 
						IN (SELECT number from DBO.FN_Split_WithDelemiter(@Value, ',') WHERE number <> '')

						IF NOT EXISTS (SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
							SELECT ExcelSrNo FROM #TmpExcelSrNo 
						END

						IF EXISTS(SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							IF EXISTS(SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo )
							BEGIN
								INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
								SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo 
							END
							ELSE
								DELETE FROM #TmpExcelSrNoFinalResult
						END
					END

					IF(@KEY = 'DR')
					BEGIN
						INSERT INTO #TmpExcelSrNo (ExcelSrNo)
						SELECT DISTINCT ExcelSrNo
						--,LTRIM(RTRIM(f.Number)) 
						FROM #TempTitleUnPivot upvot
						CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
						WHERE upvot.ColumnHeader = 'Director' AND ISNULL(f.Number, '') <> '' 
						AND LTRIM(RTRIM(f.Number)) IN (SELECT LTRIM(RTRIM(number)) from DBO.FN_Split_WithDelemiter(@Value, ',') WHERE number <> '')

						IF NOT EXISTS (SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
							SELECT ExcelSrNo FROM #TmpExcelSrNo 
						END

						IF EXISTS(SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							IF EXISTS(SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo )
							BEGIN
								INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
								SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo 
							END
							ELSE
								DELETE FROM #TmpExcelSrNoFinalResult
						END
					END

					IF(@KEY = 'SC')
					BEGIN
						INSERT INTO #TmpExcelSrNo (ExcelSrNo)
						SELECT DISTINCT ExcelSrNo
						--,LTRIM(RTRIM(f.Number)) 
						FROM #TempTitleUnPivot upvot
						CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
						WHERE upvot.ColumnHeader = 'Star Cast' AND ISNULL(f.Number, '') <> '' 
						AND LTRIM(RTRIM(f.Number)) IN (SELECT LTRIM(RTRIM(number)) from DBO.FN_Split_WithDelemiter(@Value, ',') WHERE number <> '')

						IF NOT EXISTS (SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
							SELECT ExcelSrNo FROM #TmpExcelSrNo 
						END

						IF EXISTS(SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							IF EXISTS(SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo )
							BEGIN
								INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
								SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo 
							END
							ELSE
								DELETE FROM #TmpExcelSrNoFinalResult
						END
					END

					IF(@KEY = 'EM')
					BEGIN
						UPDATE #TempTitleUnPivot SET TitleData = REPLACE(TitleData,'~',',') where ColumnHeader = 'Error_message'

						INSERT INTO #TmpExcelSrNo (ExcelSrNo)
						SELECT DISTINCT ExcelSrNo
						--,LTRIM(RTRIM(f.Number)) 
						FROM #TempTitleUnPivot upvot
							CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
						WHERE upvot.ColumnHeader = 'Error_message' AND ISNULL(f.Number, '') <> '' 
						AND LTRIM(RTRIM(f.Number)) IN (SELECT LTRIM(RTRIM(number)) from DBO.FN_Split_WithDelemiter(@Value, ',') WHERE number <> '')

						IF NOT EXISTS (SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
							SELECT ExcelSrNo FROM #TmpExcelSrNo 
						END

						IF EXISTS(SELECT * FROM #TmpExcelSrNoFinalResult)
						BEGIN
							IF EXISTS(SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo )
							BEGIN
								INSERT INTO #TmpExcelSrNoFinalResult (ExcelSrNo)
								SELECT ExcelSrNo FROM #TmpExcelSrNoFinalResult INTERSECT SELECT ExcelSrNo FROM #TmpExcelSrNo 
							END
							ELSE
								DELETE FROM #TmpExcelSrNoFinalResult
						END
					END
				END

				SELECT @count = @count + 1, @SearchCategory = '', @Key = '', @Value = ''
			END
		END

		SELECT DISTINCT ExcelSrNo FROM #TmpExcelSrNoFinalResult
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_ExcelSrNo]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END