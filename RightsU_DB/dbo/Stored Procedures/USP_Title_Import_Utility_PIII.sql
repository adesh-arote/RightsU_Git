CREATE PROCEDURE [dbo].[USP_Title_Import_Utility_PIII]
(
	@DM_Master_Import_Code INT
)
AS 
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_Utility_PIII]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET NOCOUNT ON
		--DECLARE @DM_Master_Import_Code INT = 115
		DECLARE @ISError CHAR(1) = 'N', @Error_Message NVARCHAR(MAX) = '', @ExcelCnt INT = 0
		
		DECLARE @ImportTypeBasedOnColumns VARCHAR(1)
		
		IF(OBJECT_ID('tempdb..#TempTitle') IS NOT NULL) DROP TABLE #TempTitle
		IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
		IF(OBJECT_ID('tempdb..#TempExcelSrNo') IS NOT NULL) DROP TABLE #TempExcelSrNo
		IF(OBJECT_ID('tempdb..#TempHeaderWithMultiple') IS NOT NULL) DROP TABLE #TempHeaderWithMultiple
		IF(OBJECT_ID('tempdb..#TempTalent') IS NOT NULL) DROP TABLE #TempTalent
		IF(OBJECT_ID('tempdb..#TempExtentedMetaData') IS NOT NULL) DROP TABLE #TempExtentedMetaData
		IF(OBJECT_ID('tempdb..#TempResolveConflict') IS NOT NULL) DROP TABLE #TempResolveConflict
		IF(OBJECT_ID('tempdb..#TempDuplicateRows') IS NOT NULL) DROP TABLE #TempDuplicateRows
		IF(OBJECT_ID('tempdb..#TempDupTitleName') IS NOT NULL) DROP TABLE #TempDupTitleName
		IF(OBJECT_ID('tempdb..#TempDataTable') IS NOT NULL) DROP TABLE #TempDataTable
		IF(OBJECT_ID('tempdb..#TempDistinctGrid') IS NOT NULL) DROP TABLE #TempDistinctGrid
		IF(OBJECT_ID('tempdb..#TempTblWithColumnCodeAndRowNum') IS NOT NULL) DROP TABLE #TempTblWithColumnCodeAndRowNum
		IF(OBJECT_ID('tempdb..#EpisodeDetails') IS NOT NULL) DROP TABLE #EpisodeDetails
		--IF(OBJECT_ID('tempdb..#TempTitleImportType') IS NOT NULL) DROP TABLE #TempTitleImportType
		IF(OBJECT_ID('tempdb..#TempTableExcelSrAndTitleName') IS NOT NULL) DROP TABLE #TempTableExcelSrAndTitleName
		IF(OBJECT_ID('tempdb..#TempTitleContentTable') IS NOT NULL) DROP TABLE #TempTitleContentTable
		IF(OBJECT_ID('tempdb..#TempTableWithRefTableAndSingleSelect') IS NOT NULL) DROP TABLE #TempTableWithRefTableAndSingleSelect
		IF(OBJECT_ID('tempdb..#TempDuplicateEpisodeNumberCheck') IS NOT NULL) DROP TABLE #TempDuplicateEpisodeNumberCheck
		IF(OBJECT_ID('tempdb..#TempMonths') IS NOT NULL) DROP TABLE #TempMonths
		IF(OBJECT_ID('tempdb..#TitleEpisodeDetails') IS NOT NULL) DROP TABLE #TitleEpisodeDetails

		BEGIN

		CREATE TABLE #TempTitle(
			DM_Master_Import_Code INT,
			ExcelSrNo NVARCHAR(MAX),
			Col1 NVARCHAR(MAX),
			Col2 NVARCHAR(MAX),
			Col3 NVARCHAR(MAX),
			Col4 NVARCHAR(MAX),
			Col5 NVARCHAR(MAX),
			Col6 NVARCHAR(MAX),
			Col7 NVARCHAR(MAX),
			Col8 NVARCHAR(MAX),
			Col9 NVARCHAR(MAX),
			Col10 NVARCHAR(MAX),
			Col11 NVARCHAR(MAX),
			Col12 NVARCHAR(MAX),
			Col13 NVARCHAR(MAX),
			Col14 NVARCHAR(MAX),
			Col15 NVARCHAR(MAX),
			Col16 NVARCHAR(MAX),
			Col17 NVARCHAR(MAX),
			Col18 NVARCHAR(MAX),
			Col19 NVARCHAR(MAX),
			Col20 NVARCHAR(MAX),
			Col21 NVARCHAR(MAX),
			Col22 NVARCHAR(MAX),
			Col23 NVARCHAR(MAX),
			Col24 NVARCHAR(MAX),
			Col25 NVARCHAR(MAX),
			Col26 NVARCHAR(MAX),
			Col27 NVARCHAR(MAX),
			Col28 NVARCHAR(MAX),
			Col29 NVARCHAR(MAX),
			Col30 NVARCHAR(MAX),
			Col31 NVARCHAR(MAX),
			Col32 NVARCHAR(MAX),
			Col33 NVARCHAR(MAX),
			Col34 NVARCHAR(MAX),
			Col35 NVARCHAR(MAX),
			Col36 NVARCHAR(MAX),
			Col37 NVARCHAR(MAX),
			Col38 NVARCHAR(MAX),
			Col39 NVARCHAR(MAX),
			Col40 NVARCHAR(MAX),
			Col41 NVARCHAR(MAX),
			Col42 NVARCHAR(MAX),
			Col43 NVARCHAR(MAX),
			Col44 NVARCHAR(MAX),
			Col45 NVARCHAR(MAX),
			Col46 NVARCHAR(MAX),
			Col47 NVARCHAR(MAX),
			Col48 NVARCHAR(MAX),
			Col49 NVARCHAR(MAX),
			Col50 NVARCHAR(MAX),
			Col51 NVARCHAR(MAX),
			Col52 NVARCHAR(MAX),
			Col53 NVARCHAR(MAX),
			Col54 NVARCHAR(MAX),
			Col55 NVARCHAR(MAX),
			Col56 NVARCHAR(MAX),
			Col57 NVARCHAR(MAX),
			Col58 NVARCHAR(MAX),
			Col59 NVARCHAR(MAX),
			Col60 NVARCHAR(MAX),
			Col61 NVARCHAR(MAX),
			Col62 NVARCHAR(MAX),
			Col63 NVARCHAR(MAX),
			Col64 NVARCHAR(MAX),
			Col65 NVARCHAR(MAX),
			Col66 NVARCHAR(MAX),
			Col67 NVARCHAR(MAX),
			Col68 NVARCHAR(MAX),
			Col69 NVARCHAR(MAX),
			Col70 NVARCHAR(MAX),
			Col71 NVARCHAR(MAX),
			Col72 NVARCHAR(MAX),
			Col73 NVARCHAR(MAX),
			Col74 NVARCHAR(MAX),
			Col75 NVARCHAR(MAX),
			Col76 NVARCHAR(MAX),
			Col77 NVARCHAR(MAX),
			Col78 NVARCHAR(MAX),
			Col79 NVARCHAR(MAX),
			Col80 NVARCHAR(MAX),
			Col81 NVARCHAR(MAX),
			Col82 NVARCHAR(MAX),
			Col83 NVARCHAR(MAX),
			Col84 NVARCHAR(MAX),
			Col85 NVARCHAR(MAX),
			Col86 NVARCHAR(MAX),
			Col87 NVARCHAR(MAX),
			Col88 NVARCHAR(MAX),
			Col89 NVARCHAR(MAX),
			Col90 NVARCHAR(MAX),
			Col91 NVARCHAR(MAX),
			Col92 NVARCHAR(MAX),
			Col93 NVARCHAR(MAX),
			Col94 NVARCHAR(MAX),
			Col95 NVARCHAR(MAX),
			Col96 NVARCHAR(MAX),
			Col97 NVARCHAR(MAX),
			Col98 NVARCHAR(MAX),
			Col99 NVARCHAR(MAX),
			Col100 NVARCHAR(MAX)
		)

		CREATE TABLE #TempTitleUnPivot(
			ExcelSrNo NVARCHAR(MAX),
			ColumnHeader NVARCHAR(MAX),
			TitleData NVARCHAR(MAX),
			RefKey NVARCHAR(MAX),
			IsError CHAR(1),
			FieldStatus CHAR(1),
			ErrorMessage NVARCHAR(MAX)
		)

		------FieldStatus (A = Add, I = Ignore, U = Update)------
		
		--CREATE TABLE #TempTitleImportType(
		--	ExcelSrNo NVARCHAR(MAX),
		--	ColumnHeader NVARCHAR(MAX),
		--	TitleData NVARCHAR(MAX),
		--	RefKey NVARCHAR(MAX),
		--	IsError CHAR(1),
		--	ErrorMessage NVARCHAR(MAX)
		--)

		CREATE TABLE #TempExcelSrNo(
			ExcelSrNo NVARCHAR(MAX),
		)

		CREATE TABLE #TempHeaderWithMultiple(
			ExcelSrNo NVARCHAR(MAX),
			TitleCode INT,
			HeaderName NVARCHAR(MAX),
			PropName NVARCHAR(MAX),
			PropCode INT
		)

		CREATE TABLE #TempResolveConflict(
			[Name] NVARCHAR(MAX),
			Master_Type NVARCHAR(MAX),
			Master_Code INT,
			Roles NVARCHAR(MAX),
			Mapped_By CHAR(1)
		)

		CREATE TABLE #TempTalent(
			ExcelSrNo NVARCHAR(MAX),
			HeaderName NVARCHAR(MAX),
			TalentName NVARCHAR(MAX),
			TalentCode INT,
			RoleCode INT
		)

		CREATE TABLE #TempExtentedMetaData(
			ExcelSrNo NVARCHAR(MAX),
			Columns_Code INT,
			HeaderName NVARCHAR(MAX),
			EMDName NVARCHAR(MAX),
			EMDCode INT
		)

		CREATE TABLE #TempDupTitleName
		(
			ExcelSrNo NVARCHAR(MAX),
			Title_Name NVARCHAR(MAX),
			Title_Code INT,
			Title_Type NVARCHAR(MAX),
			Deal_Type_Code INT,
			IsError CHAR(1)
		)

		END

		BEGIN TRY

		PRINT @DM_Master_Import_Code
		UPDATE DM_Title_Import_Utility_Data SET Error_Message = NULL, Is_Ignore = 'N', Record_Status = NULL 
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Col1 NOT LIKE '%Sr%' 

		PRINT 'Inserting Data into #TempTitle'
		INSERT INTO #TempTitle (DM_Master_Import_Code, ExcelSrNo, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99)  
		SELECT DM_Master_Import_Code, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100  
		FROM DM_Title_Import_Utility_Data  (NOLOCK)
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code

		--PRINT 'Changing Column entries to rows to check import type based on the columns'

		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*			INSERT INTO #TempTitleImportType(ExcelSrNo, ColumnHeader, TitleData)
			SELECT ExcelSrNo, LTRIM(RTRIM(ColumnHeader)), LTRIM(RTRIM(TitleData))
			FROM
			(
				SELECT * FROM #TempTitle
			) AS cp
			UNPIVOT 
			(
				TitleData FOR ColumnHeader IN (Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50)
			) AS up

			UPDATE T2 SET T2.ColumnHeader = T1.TitleData
			FROM (
				SELECT * FROM #TempTitleImportType WHERE ExcelSrNo LIKE '%Sr%'
			) AS T1
			INNER JOIN #TempTitleImportType T2 ON T1.ColumnHeader = T2.ColumnHeader

			--select * from #TempTitleImportType

		IF EXISTS(SELECT * FROM #TempTitleImportType WHERE ColumnHeader = 'Episode Name')
		BEGIN
			SET @ImportTypeBasedOnColumns = 'S'
		END
		ELSE
		BEGIN
			SET @ImportTypeBasedOnColumns = 'M'
		END
*/
		PRINT 'Selecting Import Type'
		SET @ImportTypeBasedOnColumns = (select TOP 1 Import_Type from DM_Master_Import d where d.DM_Master_Import_Code = @DM_Master_Import_Code)
		PRINT @ImportTypeBasedOnColumns + ' = Import Type'

		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		PRINT 'Fetching duplicate EXCEL Sr No'
		UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Duplicate EXCEL Sr. No. Found', Is_Ignore = 'Y' --A.Record_Status = 'E', 
		FROM DM_Title_Import_Utility_Data A
		WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
		AND A.Col1 COLLATE Latin1_General_CI_AI in (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))
		AND A.Col1!=''

		PRINT 'Mandatory Column EXCEL Sr No'
		UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Column EXCEL Sr. No. is Mandatory Field', Is_Ignore = 'N', A.Record_Status = 'E' 
		FROM DM_Title_Import_Utility_Data A
		WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
		AND A.Col1 COLLATE Latin1_General_CI_AI in ('')	

		DELETE FROM #TempTitle WHERE 
		ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

		DECLARE @Mandatory_message NVARCHAR(MAX)
		SELECT @Mandatory_message = STUFF(( SELECT '~ ' + Display_Name +' is Mandatory Field' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND Import_Type = @ImportTypeBasedOnColumns AND [validation] like '%man%' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		

		SELECT B.Col1 as ExcelSrNo
		INTO #TempDuplicateRows
		FROM DM_Title_Import_Utility_Data B (NOLOCK)
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND B.Col1 NOT LIKE '%Sr%'
		AND B.Col1 IN (
			SELECT A.ExcelSrNo FROM
			(
				SELECT Col1 AS ExcelSrNo , CONCAT(Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50, Col51, Col52, Col53, Col54, Col55, Col56, Col57, Col58, Col59, Col60, Col61, Col62, Col63, Col64, Col65, Col66, Col67, Col68, Col69, Col70, Col71, Col72, Col73, Col74, Col75, Col76, Col77, Col78, Col79, Col80, Col81, Col82, Col83, Col84, Col85, Col86, Col87, Col88, Col89, Col90, Col91, Col92, Col93, Col94, Col95, Col96, Col97, Col98, Col99, Col100) AS Concatenate
				FROM DM_Title_Import_Utility_Data   (NOLOCK)
				WHERE DM_Master_Import_Code =  @DM_Master_Import_Code
				AND Col1 NOT LIKE '%Sr%'
			) AS A WHERE A.Concatenate = ''
		)

		UPDATE B SET  B.Error_Message= ISNULL(B.Error_Message,'') + '~'+@Mandatory_message , B.Record_Status = 'E'
		FROM DM_Title_Import_Utility_Data B WHERE B.Col1 IN (SELECT ExcelSrNo FROM #TempDuplicateRows ) AND B.DM_Master_Import_Code = @DM_Master_Import_Code

		PRINT 'Fetching duplicate rows'
		UPDATE A SET  Error_Message= ISNULL(Error_Message,'') + '~Duplicate Rows Found', Is_Ignore = 'Y' --,A.Record_Status = 'E'
		FROM DM_Title_Import_Utility_Data A 
		INNER JOIN 
		(
			SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
			FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' 
		) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
		WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' AND B.rank > 1 AND A.Col1 NOT IN (SELECT ExcelSrNo FROM #TempDuplicateRows)

		DELETE A FROM #TempTitle A 
		INNER JOIN (
		SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
		FROM #TempTitle
		WHERE ExcelSrNo NOT LIKE '%Sr%' ) AS B ON A.ExcelSrNo = B.ExcelSrNo
		WHERE  A.ExcelSrNo NOT LIKE '%Sr%' AND B.rank > 1	

	
		BEGIN
			PRINT 'Unpivoting Title data for further validation'
			INSERT INTO #TempTitleUnPivot(ExcelSrNo, ColumnHeader, TitleData)
			SELECT ExcelSrNo, LTRIM(RTRIM(ColumnHeader)), LTRIM(RTRIM(TitleData))
			FROM
			(
				SELECT * FROM #TempTitle
			) AS cp
			UNPIVOT 
			(
				TitleData FOR ColumnHeader IN (Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50)
			) AS up

			UPDATE T2 SET T2.ColumnHeader = T1.TitleData
			FROM (
				SELECT * FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
			) AS T1
			INNER JOIN #TempTitleUnPivot T2 ON T1.ColumnHeader = T2.ColumnHeader

			DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
			DELETE FROM #TempTitleUnPivot WHERE TitleData = ''

			INSERT INTO #TempExcelSrNo(ExcelSrNo)
			SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot

			SELECT @ExcelCnt = COUNT(DISTINCT ExcelSrNo) FROM #TempExcelSrNo

			UPDATE T1 SET T1.IsError = '', ErrorMessage = '' FROM #TempTitleUnPivot T1
		END

		DECLARE @Display_Name NVARCHAR(MAX), @Reference_Table NVARCHAR(MAX), @Reference_Text_Field NVARCHAR(MAX), @Reference_Value_Field NVARCHAR(MAX)
		, @Reference_Whr_Criteria NVARCHAR(MAX),  @Control_Type NVARCHAR(MAX), @Is_Allowed_For_Resolve_Conflict CHAR(1), @ShortName NVARCHAR(MAX),
		@Target_Column NVARCHAR(MAX)

		BEGIN
			PRINT 'Duplication'

			IF(@ImportTypeBasedOnColumns = 'S')
			BEGIN
				PRINT 'No in-file Duplicate Check for Shows'
			END
			ELSE
			BEGIN

				PRINT 'Check Duplicate for Movies within same file'

			DECLARE db_cursor_Duplication CURSOR FOR 
			SELECT Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' AND [validation] like '%dup%'
		
			OPEN db_cursor_Duplication  
			FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name  

			WHILE @@FETCH_STATUS = 0  
			BEGIN  

				IF (@Display_Name = 'Title Name')
				BEGIN
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') has duplicate data'
					WHERE ExcelSrNo IN(
						SELECT C.ExcelSrNo FROM ( 
							SELECT D.excelSrNo, RANK() OVER(PARTITION BY D.TitleData ORDER BY D.excelSrNo) AS rank 
							FROM (
								SELECT A.ExcelSrNo, ISNULL(A.TitleData,'')+'~'+ISNULL(B.TitleData,'') as 'TitleData' from 
								( SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' ) as A
								LEFT JOIN 
								( SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Type' ) AS B 
								ON A.ExcelSrNo = B.ExcelSrNo 
							) AS D
						) AS C WHERE C.rank > 1
					)	
				END
				ELSE
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') has duplicate data'
					WHERE ExcelSrNo IN(
						SELECT A.ExcelSrNo FROM ( SELECT excelSrNo, RANK() OVER(PARTITION BY TitleData ORDER BY excelSrNo) AS rank FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name ) AS A WHERE A.rank > 1
					)
				
				--IF (@Display_Name = 'Title Name')
				--BEGIN
				--	UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Title Name is already existed'
				--	WHERE ExcelSrNo IN(
				--		SELECT EXCELSRNO FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name
				--		AND TitleData COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT DISTINCT ISNULL(Title_Name,'') FROM Title)
				--	)
				--END

				FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name 
			END 
			CLOSE db_cursor_Duplication  
			DEALLOCATE db_cursor_Duplication 
			END
		END

		BEGIN
			PRINT 'Check INT Column'
			DECLARE @Value NVARCHAR(MAX)= '', @ExcelNo_IntDec NVARCHAR(MAX) = ''

			DECLARE db_cursor_Int CURSOR FOR 
			SELECT Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' AND Colum_Type = 'INT' AND Import_Type = @ImportTypeBasedOnColumns

			OPEN db_cursor_Int  
			FETCH NEXT FROM db_cursor_Int INTO @Display_Name 

			WHILE @@FETCH_STATUS = 0  
			BEGIN 
	
				DECLARE db_cursor_Int_dec CURSOR FOR 
				SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name	AND ISNULL(TitleData,'') <> ''

				OPEN db_cursor_Int_dec  
				FETCH NEXT FROM db_cursor_Int_dec INTO @ExcelNo_IntDec, @Value 
	
				WHILE @@FETCH_STATUS = 0  
				BEGIN 
						IF (ISNUMERIC(Replace(Replace(@Value,'+','A'),'-','A') + '.0e0') > 0)
						BEGIN
							UPDATE #TempTitleUnPivot SET RefKey = 1 WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value AND ColumnHeader = @Display_Name
						END
						ELSE IF (REPLACE(ISNUMERIC(REPLACE(REPLACE(@Value,'+','A'),'-','A') + 'e0'),1,CHARINDEX('.',@Value)) > 0 AND @Display_Name = 'Duration In Minute')
						BEGIN
							UPDATE #TempTitleUnPivot SET RefKey = 2  WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value

							IF (right(@Value, 1) = '.')
								UPDATE #TempTitleUnPivot SET TitleData = TitleData + '0'  WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value
						END
						ELSE
						BEGIN 
							UPDATE #TempTitleUnPivot SET RefKey = 0 FROM #TempTitleUnPivot WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value AND ColumnHeader = @Display_Name
						END

					FETCH NEXT FROM db_cursor_Int_dec INTO @ExcelNo_IntDec, @Value 
				END 

				CLOSE db_cursor_Int_dec  
				DEALLOCATE db_cursor_Int_dec 
	
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Not Numeric'
				WHERE ExcelSrNo IN (
					SELECT ExcelSrNo FROM #TempTitleUnPivot 
					WHERE  ColumnHeader = @Display_Name AND RefKey = 0
				)
		
				IF ('YEAR OF RELEASE' = UPPER(@Display_Name))
				BEGIN
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1900 and 9999'
					WHERE ExcelSrNo IN (
					SELECT ExcelSrNo
					FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND  RefKey = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1900 AND 9999
					)

				END

				IF ('DURATION IN MINUTE' = UPPER(@Display_Name))
				BEGIN
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1 and 9999'
					WHERE ExcelSrNo IN (
						SELECT ExcelSrNo
						FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND RefKey = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1 AND 9999
					)

					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1 and 9999'
					WHERE ExcelSrNo IN (
						SELECT ExcelSrNo
						FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND RefKey = 2 AND CAST(TitleData AS DECIMAL(38,2)) NOT BETWEEN 1 AND 9999
					)
				END

				UPDATE #TempTitleUnPivot SET RefKey = NULL WHERE RefKey IN (0,1,2) AND ColumnHeader = @Display_Name

				FETCH NEXT FROM db_cursor_Int INTO @Display_Name 
			END 

			CLOSE db_cursor_Int  
			DEALLOCATE db_cursor_Int 
		END

		BEGIN
			PRINT 'Date Validation'
			DECLARE @DateValue VARCHAR(100) = ''
			DECLARE @DateValue_Replaced VARCHAR(100) = ''
			DECLARE @ExcelNo_Date VARCHAR(MAX) = ''
			DECLARE @DisplayNameDate VARCHAR(1000) = ''
			DECLARE @MonthName VARCHAR(10)

			CREATE TABLE #TempMonths(
				MonthName VARCHAR(10)
			)

			INSERT INTO #TempMonths (MonthName) VALUES ('Jan'),('Feb'),('Mar'),('Apr'),('May'),('Jun'),('Jul'),('Aug'),('Sep'),('Oct'),('Nov'),('Dec'),('January'),('February'),('March'),('April'),('May'),('June'),('July'),('August'),('September'),('October'),('November'),('December')

			DECLARE DateValidationCursor CURSOR FOR 
			SELECT dm.Display_Name FROM DM_Title_Import_Utility (NOLOCK) dm 
			WHERE dm.Is_Active = 'Y' 
				AND dm.validation = 'DATE'
				AND (dm.Import_Type = @ImportTypeBasedOnColumns)

			OPEN DateValidationCursor
			FETCH NEXT FROM DateValidationCursor INTO @DisplayNameDate

			WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE DateEntryinTitleUnpivot CURSOR FOR
					SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = @DisplayNameDate AND ISNULL(TitleData,'') <> ''
					
					OPEN DateEntryinTitleUnpivot
					FETCH NEXT FROM DateEntryinTitleUnpivot INTO @ExcelNo_Date, @DateValue

					WHILE @@FETCH_STATUS = 0
						BEGIN
							PRINT @DateValue
							SET @DateValue_Replaced = (select REPLACE(@DateValue, '/', '-'))
							PRINT @DateValue_Replaced + ' After Replace'
							IF((select Count(number) from DBO.FN_Split_WithDelemiter(@DateValue_Replaced, '-')) = 3)
							BEGIN
								BEGIN TRY
									SET @MonthName = (SELECT number FROM DBO.FN_Split_WithDelemiter(@DateValue_Replaced, '-') ORDER BY (SELECT NULL) OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY)
									IF EXISTS(select MonthName from #TempMonths where MonthName = @MonthName)
										BEGIN
											IF (ISDATE(@DateValue) = 1)
												BEGIN
													PRINT 'Is Date'
													UPDATE #TempTitleUnPivot SET titledata = (select REPLACE((SELECT CONVERT(VARCHAR(100), (SELECT CONVERT(DATE, @DateValue, 103)), 106)), ' ', '-')) WHERE ExcelSrNo = @ExcelNo_Date AND ColumnHeader = @DisplayNameDate
												END
											ELSE 
												BEGIN
													PRINT 'Is Not Date'
													UPDATE #TempTitleUnPivot SET RefKey = 2 WHERE ExcelSrNo = @ExcelNo_Date AND TitleData = @DateValue
												END
										END
									ELSE
										BEGIN
											PRINT 'Incorrect Month format'
											UPDATE #TempTitleUnPivot SET RefKey = 0 WHERE ExcelSrNo = @ExcelNo_Date AND TitleData = @DateValue
										END
								END TRY
								BEGIN CATCH
									PRINT 'Catch - Is Not Date'
									UPDATE #TempTitleUnPivot SET RefKey = 1 WHERE ExcelSrNo = @ExcelNo_Date AND TitleData = @DateValue
								END CATCH
							END
							ELSE
							BEGIN
								PRINT 'Not 3 Characters'
								UPDATE #TempTitleUnPivot SET RefKey = 1 WHERE ExcelSrNo = @ExcelNo_Date AND TitleData = @DateValue
							END

							FETCH NEXT FROM DateEntryinTitleUnpivot INTO @ExcelNo_Date, @DateValue
						END
					CLOSE DateEntryinTitleUnpivot
					DEALLOCATE DateEntryinTitleUnpivot

					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Incorrect Month at (' + @DisplayNameDate +').'
					WHERE ExcelSrNo IN (
						SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE Columnheader = @DisplayNameDate AND RefKey = 0
					)
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Improper Date format for Column(' + @DisplayNameDate +'). [dd-mmm-yyyy]'
					WHERE ExcelSrNo IN (
						SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE Columnheader = @DisplayNameDate AND RefKey = 1
					)
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Incorrect Date at (' + @DisplayNameDate +').'
					WHERE ExcelSrNo IN (
						SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE Columnheader = @DisplayNameDate AND RefKey = 2
					)

					UPDATE #TempTitleUnPivot SET RefKey = NULL WHERE RefKey IN (0,1,2) AND ColumnHeader = @DisplayNameDate

					FETCH NEXT FROM DateValidationCursor INTO @DisplayNameDate
				END

			CLOSE DateValidationCursor
			DEALLOCATE DateValidationCursor

		END

		BEGIN
			PRINT 'Length Validation'

			DECLARE @DisplayNameLen NVARCHAR(MAX)
			DECLARE @ValidationVar NVARCHAR(MAX)
			DECLARE @LengthVar VARCHAR (10)
			DECLARE @LengthInt INT
			
			DECLARE LengthValidationCursor CURSOR FOR 
			SELECT Display_Name, [validation] FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and [validation] like '%LEN%' AND Import_Type = @ImportTypeBasedOnColumns
			
			OPEN LengthValidationCursor
			FETCH NEXT FROM LengthValidationCursor INTO @DisplayNameLen, @ValidationVar
				
				WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @LengthVar = (select number from FN_Split_WithDelemiter(@ValidationVar, '~') where number like '%LEN%')
						SET @LengthInt = (select number from FN_Split_WithDelemiter(@LengthVar, '_')  ORDER BY (SELECT NULL) OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY)
						
						PRINT @DisplayNameLen + ' should have ' + CAST(@LengthInt as VARCHAR(100)) + ' characters'

						update #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @DisplayNameLen + ' should have Max ' + CAST(@LengthInt as VARCHAR(100)) + ' characters.' WHERE ExcelSrNo IN 
						(select ExcelSrNo from #TempTitleUnPivot tmp where tmp.ColumnHeader = @DisplayNameLen and LEN(TitleData) > @LengthInt) 
			
						FETCH NEXT FROM LengthValidationCursor INTO @DisplayNameLen, @ValidationVar
					END
			CLOSE LengthValidationCursor
			DEALLOCATE LengthValidationCursor

		END

		BEGIN
			PRINT 'Mandatory Validation'

			DECLARE db_cursor_Mandatory CURSOR FOR 
				SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' AND [validation] like '%man%' AND Import_Type = @ImportTypeBasedOnColumns

			OPEN db_cursor_Mandatory  
			FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name , @Is_Allowed_For_Resolve_Conflict, @ShortName

			WHILE @@FETCH_STATUS = 0  
			BEGIN  

				IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
				BEGIN
						UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Mandatory Columns are Ignored while Mapping', A.Is_Ignore = 'Y'  
						FROM DM_Title_Import_Utility_Data A
						WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 COLLATE Latin1_General_CI_AI IN (
							SELECT ExcelSrNo FROM #TempTitleUnPivot T
							INNER JOIN DM_Master_Log B (NOLOCK) ON T.TitleData = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
							WHERE B.DM_Master_Import_Code = @DM_Master_Import_Code
							AND  B.Is_Ignore = 'Y'
							AND  B.Master_Type = @ShortName
							AND T.ColumnHeader = @Display_Name )

						DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo IN (
						SELECT ExcelSrNo FROM #TempTitleUnPivot A
							INNER JOIN DM_Master_Log B (NOLOCK) ON A.TitleData = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
							WHERE DM_Master_Import_Code = @DM_Master_Import_Code
							AND  B.Is_Ignore = 'Y'
							AND  B.Master_Type = @ShortName
							AND A.ColumnHeader = @Display_Name			
						)
				END

				IF((SELECT COUNT(DISTINCT ExcelSrNo) FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name) < @ExcelCnt) --@ExcelCnt 2
				BEGIN
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Mandatory Field'
					WHERE ExcelSrNo NOT IN ( SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name)
				END

				  FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name , @Is_Allowed_For_Resolve_Conflict, @ShortName 
			END 

			CLOSE db_cursor_Mandatory  
			DEALLOCATE db_cursor_Mandatory 
		END

		BEGIN
			PRINT 'Show specific Error Resolving before Import'

			--select * from #TempTitleUnPivot
			--select ExcelSrNo, TitleData, IsError from #TempTitleUnPivot WHERE ColumnHeader = 'Title Name'
			--select TitleData from #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError = 'Y'
			--select ExcelSrNo from #TempTitleUnPivot where TitleData in (select TitleData from #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError = 'Y') and IsError <> 'Y'
			PRINT 'Setting Error for each show before deleting IsError = Y'
			--Update #TempTitleUnPivot SET IsError = 'Y' 
			--where ExcelSrNo in (select ExcelSrNo from #TempTitleUnPivot where TitleData in (select TitleData from #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError = 'Y') and IsError <> 'Y')
			----select ExcelSrNo, TitleData, IsError from #TempTitleUnPivot WHERE ColumnHeader = 'Title Name'

			IF(@ImportTypeBasedOnColumns = 'S')
			BEGIN
				PRINT 'Episode Number duplication check'

				Create table #TempDuplicateEpisodeNumberCheck(
					ExcelSrNo NVARCHAR(MAX),
					TitleName NVARCHAR(MAX),
					EpisodeNo NVARCHAR(MAX),
					Season NVARCHAR(MAX)
				)
										
				INSERT INTO #TempDuplicateEpisodeNumberCheck (ExcelSrNo, TitleName) SELECT tt.ExcelSrNo, TitleData FROM #TempTitleUnPivot tt inner join DM_Title_Import_Utility dm on tt.ColumnHeader  COLLATE SQL_Latin1_General_CP1_CI_AS = dm.Display_Name 
				WHERE tt.ColumnHeader = 'Title Name' and Import_Type = @ImportTypeBasedOnColumns
				
				Update #TempDuplicateEpisodeNumberCheck SET EpisodeNo = tt.TitleData from #TempTitleUnPivot tt 
				inner join #TempDuplicateEpisodeNumberCheck de on de.ExcelSrNo = tt.ExcelSrNo where tt.ColumnHeader = 'Episode No' 
				
				Update #TempDuplicateEpisodeNumberCheck SET Season = tt.TitleData from #TempTitleUnPivot tt 
				inner join #TempDuplicateEpisodeNumberCheck de on de.ExcelSrNo = tt.ExcelSrNo where tt.ColumnHeader = 'Season' 
				
				--select * from #TempDuplicateEpisodeNumberCheck

				--UPDATE tt SET tt.IsError = 'Y'
				--FROM #TempTitleUnPivot tt where tt.TitleData IN 
				--(select A.TitleName from (select dc.TitleName as TitleName, dc.EpisodeNo as EpisodeNo, COUNT(*) as RepeatCount 
				--from #TempDuplicateEpisodeNumberCheck dc group by dc.TitleName, dc.EpisodeNo HAVING COUNT(*) > 1) AS A) -- Does not check duplication based on season

				--UPDATE tt SET tt.IsError = 'Y'
				--FROM #TempTitleUnPivot tt where tt.TitleData IN 
				--(select A.TitleName from (select dc.TitleName as TitleName, dc.EpisodeNo as EpisodeNo, dc.Season as Season, COUNT(*) as RepeatCount 
				--from #TempDuplicateEpisodeNumberCheck dc group by dc.TitleName, dc.EpisodeNo, dc.Season HAVING COUNT(*) > 1) AS A) -- Checks duplication for episode based on season
				
				--Update #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~ Episode number cannot be duplicate for a Title ~'
				--where ExcelSrNo in (select ExcelSrNo from #TempTitleUnPivot where TitleData in (select TitleData from #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError = 'Y'))

				UPDATE tt SET tt.IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Episode number cannot be duplicate for a Title'
				FROM #TempTitleUnPivot tt where tt.ExcelSrNo IN 
				(SELECT A.ExcelSrNo FROM #TempTitleUnPivot A INNER JOIN 
				(select dc.TitleName as TitleName, dc.EpisodeNo as EpisodeNo, COUNT(*) as RepeatCount from #TempDuplicateEpisodeNumberCheck dc 
				group by dc.TitleName, dc.EpisodeNo HAVING COUNT(*) > 1) AS B on A.TitleData = B.TitleName WHERE A.ColumnHeader = 'Title Name')

			END

		END

		BEGIN
			PRINT 'Deleting IsError = Y and updating record status amd error message AND deleting existing title'

			INSERT INTO #TempDupTitleName (ExcelSrNo, Title_Name)
			SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError <> 'Y'

			UPDATE A SET A.Title_Type = B.TitleData
			FROM #TempDupTitleName A
			INNER JOIN #TempTitleUnPivot B ON A.ExcelSrNo COLLATE Latin1_General_CI_AI = B.ExcelSrNo
			WHERE B.ColumnHeader = 'Title Type'

			UPDATE A SET A.Title_Code = B.Title_Code
			FROM #TempDupTitleName A
			INNER JOIN Title B ON A.Title_Name  COLLATE Latin1_General_CI_AI  = B.Title_Name

			UPDATE A SET A.Deal_Type_Code = B.Deal_Type_Code
			FROM #TempDupTitleName A
			INNER JOIN Deal_Type B ON A.Title_Type  COLLATE Latin1_General_CI_AI  = B.Deal_Type_Name
			WHERE  B.Is_Active = 'Y'

			UPDATE A SET A.Deal_Type_Code = B.Master_Code
			FROM #TempDupTitleName A
			INNER JOIN DM_Master_Log B ON A.Title_Type COLLATE Latin1_General_CI_AI  = B.Name
			WHERE Master_Type = 'TT' AND Is_Ignore = 'N' AND B.DM_Master_Import_Code = @DM_Master_Import_Code
			
			UPDATE A SET A.IsError = 'Y'
			FROM #TempDupTitleName A
			inner join Title B ON A.Title_Name COLLATE Latin1_General_CI_AI  = B.Title_Name AND A.Deal_Type_Code = B.Deal_Type_Code
			
			--UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + 'Title Name Already Existed'--, Is_Ignore = 'Y'
			--FROM DM_Title_Import_Utility_Data A
			--WHERE A.DM_Master_Import_Code =  @DM_Master_Import_Code 
			--AND A.Col1 NOT LIKE '%Sr%' and A.Col1 COLLATE Latin1_General_CI_AI IN 
			--(
			--	SELECT ExcelSrNo FROM #TempDupTitleName where ISNULL(IsError, '') = 'Y'
			--)
			
			--UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + B.ErrorMessage --, Is_Ignore = 'Y'
			--FROM DM_Title_Import_Utility_Data A
			--INNER JOIN (
			--	SELECT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y' GROUP BY ExcelSrNo, ErrorMessage
			--) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
			--WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code 
			--AND A.Col1 NOT LIKE '%Sr%'

			--DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo COLLATE Latin1_General_CI_AI IN
			--(
			--	SELECT ExcelSrNo FROM #TempDupTitleName where ISNULL(IsError, '') = 'Y'
			--)

			--DELETE FROM #TempTitleUnPivot WHERE IsError = 'Y'
		END
		
		BEGIN
			PRINT 'Referene check not available where Is_Multiple = ''N'''

			DECLARE db_cursor_Reference CURSOR FOR 
			SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
			FROM DM_Title_Import_Utility (NOLOCK)
			WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'N' AND Import_Type = @ImportTypeBasedOnColumns

			OPEN db_cursor_Reference  
			FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
			
			WHILE @@FETCH_STATUS = 0  				 
			BEGIN  

					EXEC ('UPDATE B SET B.RefKey = A.'+@Reference_Value_Field+' 
							FROM #TempTitleUnPivot B
							INNER JOIN '+@Reference_Table+' A ON A.'+@Reference_Text_Field+'  COLLATE Latin1_General_CI_AI = B.TitleData  COLLATE Latin1_General_CI_AI AND B.ColumnHeader = '''+@Display_Name+'''
							WHERE 1=1 '+@Reference_Whr_Criteria+'
					')

					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
					BEGIN
					
						UPDATE B SET B.RefKey = A.Master_Code
						FROM DM_Master_Log A
						INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
						WHERE 
							A.DM_Master_Import_Code = @DM_Master_Import_Code 
							AND A.Master_Type   = @ShortName   
							AND B.ColumnHeader   = @Display_Name  
							AND B.RefKey IS NULL
							AND A.Master_Code IS NOT NULL
							AND A.Is_Ignore = 'N'
					END
				
					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE A SET A.IsError = 'Y', A.ErrorMessage = ISNULL(A.ErrorMessage, '') + '~' + @Display_Name +' Not Available'
						FROM #TempTitleUnPivot A WHERE  A.ExcelSrNo IN
						(
							SELECT DISTINCT  ExcelSrNo
							FROM #TempTitleUnPivot T1
							WHERE T1.ColumnHeader = @Display_Name AND T1.RefKey IS NULL AND T1.TitleData <> ''
						)

					FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
			END 

			CLOSE db_cursor_Reference  
			DEALLOCATE db_cursor_Reference 
		END
	
		BEGIN
			PRINT 'Referene check where Is_Multiple = ''Y'''

			DECLARE db_cursor_Reference CURSOR FOR 
			SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
			FROM DM_Title_Import_Utility (NOLOCK)
			WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'Y' AND Import_Type = @ImportTypeBasedOnColumns

			OPEN db_cursor_Reference  
			FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria,  @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
			WHILE @@FETCH_STATUS = 0  				 
			BEGIN  		
	
				INSERT INTO #TempHeaderWithMultiple(ExcelSrNo,HeaderName, PropName)
					SELECT DISTINCT 
							ExcelSrNo, 
							@Display_Name,
							LTRIM(RTRIM(f.Number))
					FROM #TempTitleUnPivot upvot
					CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
					WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> '' 

				UPDATE A SET A.PropCode = B.Master_Code
				FROM #TempHeaderWithMultiple A
				INNER JOIN DM_Master_Log B ON A.PropName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND B.Is_Ignore = 'N'

				EXEC ('UPDATE A SET A.PropCode = B.'+@Reference_Value_Field+' 
				FROM #TempHeaderWithMultiple A
				INNER JOIN '+@Reference_Table+' B ON A.PropName COLLATE SQL_Latin1_General_CP1_CI_AS = B.'+@Reference_Text_Field+'
				WHERE 1=1 AND A.PropCode IS NULL AND A.HeaderName ='''+@Display_Name+'''  '+@Reference_Whr_Criteria+'
				')

				FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name,  @Reference_Table, @Reference_Text_Field, @Reference_Value_Field,  @Reference_Whr_Criteria , @Is_Allowed_For_Resolve_Conflict, @ShortName
			END 

			CLOSE db_cursor_Reference  
			DEALLOCATE db_cursor_Reference 
		END
	
		BEGIN
			PRINT 'Talent Referene check'

			DECLARE db_cursor_Talent_Reference CURSOR FOR 
			SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName 
			FROM DM_Title_Import_Utility (NOLOCK) WHERE Reference_Table = 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Import_Type = @ImportTypeBasedOnColumns

			OPEN db_cursor_Talent_Reference  
			FETCH NEXT FROM db_cursor_Talent_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
			WHILE @@FETCH_STATUS = 0  				 
			BEGIN
					INSERT INTO #TempTalent(ExcelSrNo,HeaderName, TalentName, RoleCode)
					SELECT DISTINCT 
							ExcelSrNo, 
							upvot.ColumnHeader,
							LTRIM(RTRIM(f.Number)),
							r.Role_Code
					FROM #TempTitleUnPivot upvot
					inner join Role R (NOLOCK) ON R.Role_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
					CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
					WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''

					UPDATE A SET A.TalentCode = B.Master_Code FROM #TempTalent A
					INNER JOIN DM_Master_Log B ON A.TalentName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND Roles = @Display_Name AND B.Is_Ignore = 'N'

					FETCH NEXT FROM db_cursor_Talent_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
			END 

			CLOSE db_cursor_Talent_Reference  
			DEALLOCATE db_cursor_Talent_Reference 

			DELETE FROM #TempTalent WHERE TalentName in ('',' ','.')

			UPDATE tt SET tt.TalentCode = t.Talent_Code FROM Talent t
			INNER JOIN #TempTalent tt ON t.Talent_Name COLLATE Latin1_General_CI_AI = tt.TalentName COLLATE Latin1_General_CI_AI	
			WHERE TT.TalentCode IS NULL

		END

		BEGIN
			PRINT 'Extended metadata except talent Is_Multiple = ''N'''

			DECLARE db_cursor_EMD_Reference CURSOR FOR 
			SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility (NOLOCK) WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'N' AND Import_Type = @ImportTypeBasedOnColumns
	
			OPEN db_cursor_EMD_Reference  
			FETCH NEXT FROM db_cursor_EMD_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
											 
			WHILE @@FETCH_STATUS = 0  				 
			BEGIN  	
					SELECT @Control_Type = Control_Type FROM extended_columns (NOLOCK) WHERE Columns_Name = @Display_Name
					-- if TXT then directly insert ie banner 
					IF (@Control_Type = 'DDL')
					BEGIN
						UPDATE upvot SET upvot.RefKey = ECV.Columns_Value_Code
						FROM #TempTitleUnPivot upvot
						INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
						INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Code = EC.Columns_Code AND UPVOT.TitleData COLLATE Latin1_General_CI_AI = ECV.Columns_Value COLLATE Latin1_General_CI_AI 
						WHERE upvot.ColumnHeader = @Display_Name -- 'Colour or B&W'
	
						IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
						BEGIN
							UPDATE B SET B.RefKey = A.Master_Code
							FROM DM_Master_Log A
							INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
							WHERE 
								A.DM_Master_Import_Code = @DM_Master_Import_Code 
								AND A.Master_Type   = @ShortName   
								AND B.ColumnHeader   = @Display_Name  
								AND B.RefKey IS NULL
								AND A.Master_Code IS NOT NULL
								AND A.Is_Ignore = 'N'
						END

						IF(@Is_Allowed_For_Resolve_Conflict = 'N')
							UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available' 
							WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE RefKey is null AND ColumnHeader = @Display_Name )
					
					END
					FETCH NEXT FROM db_cursor_EMD_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
			END 
	
			CLOSE db_cursor_EMD_Reference  
			DEALLOCATE db_cursor_EMD_Reference 
		END

		BEGIN
			PRINT 'Extended metadata except talent Is_Multiple = ''Y'''

			DECLARE db_cursor_EMDY_Reference CURSOR FOR 
			SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria
			FROM DM_Title_Import_Utility (NOLOCK) WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'Y' AND Import_Type = @ImportTypeBasedOnColumns

			OPEN db_cursor_EMDY_Reference  
			FETCH NEXT FROM db_cursor_EMDY_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria
										 
			WHILE @@FETCH_STATUS = 0  				 
			BEGIN  	
					SELECT @Control_Type = Control_Type FROM extended_columns (NOLOCK) WHERE Columns_Name = @Display_Name
		
					IF (@Control_Type = 'DDL')
					BEGIN
						INSERT INTO #TempExtentedMetaData (ExcelSrNo, Columns_Code, HeaderName, EMDName)
						SELECT DISTINCT ExcelSrNo, EC.Columns_Code, upvot.ColumnHeader, LTRIM(RTRIM(f.Number))
						FROM #TempTitleUnPivot upvot
							INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
							CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
						WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''
					
						IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
							UPDATE A SET A.EMDCode = B.Master_Code FROM #TempExtentedMetaData A
							INNER JOIN DM_Master_Log B ON A.EMDName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
							WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND B.Is_Ignore = 'N'

						UPDATE A SET A.EMDCode= ECV.Columns_Value_Code  FROM #TempExtentedMetaData A
						INNER JOIN Extended_Columns_Value ECV 
						ON ECV.Columns_Value COLLATE Latin1_General_CI_AI = A.EMDName COLLATE Latin1_General_CI_AI AND ECV.Columns_Code = A.Columns_Code 

						IF(@Reference_Table <> '' AND @Reference_Table <> 'Extended_Columns_Value')
						BEGIN
							PRINT ('UPDATE A SET A.EMDCode = B.' + @Reference_Value_Field +'
							FROM #TempExtentedMetaData A
							INNER JOIN ' + @Reference_Table + ' B ON A.EMDName COLLATE SQL_Latin1_General_CP1_CI_AS = B.' + @Reference_Text_Field + ' 
							WHERE 1 = 1 AND A.EMDCode IS NULL' + @Reference_Whr_Criteria)

							EXEC ('UPDATE A SET A.EMDCode = B.' + @Reference_Value_Field +'
							FROM #TempExtentedMetaData A
							INNER JOIN ' + @Reference_Table + ' B ON A.EMDName COLLATE SQL_Latin1_General_CP1_CI_AS = B.' + @Reference_Text_Field + ' 
							WHERE 1 = 1 AND A.EMDCode IS NULL' + @Reference_Whr_Criteria)
						END

						IF(@Is_Allowed_For_Resolve_Conflict = 'N')
							UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available' 
							WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempExtentedMetaData WHERE EMDCode is null AND HeaderName = @Display_Name )
					END
					FETCH NEXT FROM db_cursor_EMDY_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria
			END 

			CLOSE db_cursor_EMDY_Reference  
			DEALLOCATE db_cursor_EMDY_Reference 
			
			UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + B.ErrorMessage --, Is_Ignore = 'Y'
			FROM DM_Title_Import_Utility_Data A
			INNER JOIN (
				SELECT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y' GROUP BY ExcelSrNo, ErrorMessage
			) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
			WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code 
			AND A.Col1 NOT LIKE '%Sr%'

			DELETE FROM #TempTitleUnPivot
			WHERE ExcelSrNo in (SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE TitleData IN (SELECT TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError = 'Y') AND IsError <> 'Y')

			DELETE FROM #TempTitleUnPivot WHERE IsError = 'Y'
		END

		BEGIN
			PRINT 'Resolve Conflict'
			PRINT 'Deletting unnecessary data before Resolve Conflict'

			DELETE FROM #TempHeaderWithMultiple WHERE ExcelSrNo IN (SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE IsError = 'Y')
			DELETE FROM #TempExtentedMetaData	WHERE ExcelSrNo IN (SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE IsError = 'Y')
			DELETE FROM #TempTalent				WHERE ExcelSrNo IN (SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE IsError = 'Y')

			DELETE FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code and Master_Code IS NULL AND Is_Ignore = 'N'
			--UPDATE DM_Title_Import_Utility_Data SET Record_Status = NULL WHERE Record_Status = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code

			INSERT INTO #TempResolveConflict ([Name], Master_Type, Roles)
			SELECT DISTINCT A.[Name], A.Master_Type, A.Roles FROM (
					SELECT A.TitleData AS Name ,B.ShortName AS Master_Type ,'' AS Roles FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B  (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE A.RefKey IS NULL
						  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
						  AND B.Reference_Table <> 'Talent' 
						  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N' AND A.ExcelSrNo NOT IN (SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE IsError = 'Y')
					UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD
					SELECT A.PropName AS Name ,B.ShortName AS Master_Type,'' AS Roles
					FROM #TempHeaderWithMultiple A
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
					UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD
					SELECT A.TitleData AS Name,B.ShortName AS Master_Type,''AS Roles
					FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE	A.RefKey IS NULL
							AND B.Target_Table = 'Map_Extended_Column' 
							AND Is_Multiple = 'N'
							AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
							AND A.ExcelSrNo NOT IN (SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE IsError = 'Y')
					UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD EXTENDED META DATA
					SELECT A.EMDName AS Name, B.ShortName AS Master_Type ,''AS Roles
					FROM #TempExtentedMetaData A
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
					UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD EXTENDED META DATA
					SELECT A.TalentName AS Name, B.ShortName AS Master_Type, R.Role_Name AS Roles
					FROM #TempTalent A
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN Role R (NOLOCK) ON R.Role_Code = A.RoleCode
					WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				--TITLE PROPERTIES WITH TALENT
			) AS A

			UPDATE A SET  A.Master_Code = B.Master_Code, A.Mapped_By = 'S' 
			FROM #TempResolveConflict A
			INNER JOIN DM_Master_Log B ON B.Name COLLATE Latin1_General_CI_AI = A.Name AND A.Master_Type COLLATE Latin1_General_CI_AI = B.Master_Type
			WHERE B.DM_Master_Log_Code IN ( SELECT  MAX(DM_Master_Log_Code) AS DM_Master_Log_Code FROM DM_Master_Log (NOLOCK) GROUP BY Name)

			UPDATE #TempResolveConflict SET Mapped_By = 'U' where Master_Code IS NULL 
	
			PRINT 'Delete from Temp table where is_ignore IS Y '
			BEGIN
				DELETE A
				FROM #TempTitleUnPivot A
						INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
					  AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

				DELETE A
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN DM_Master_Log DML ON DML.NAME = A.PropName collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
					AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

				DELETE A
				FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
						AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

				DELETE A
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN DM_Master_Log DML ON DML.NAME = A.EMDName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
					AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

				DELETE A
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
					INNER JOIN DM_Master_Log DML ON DML.NAME = A.TalentName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
													AND DML.Roles = R.Role_Name COLLATE Latin1_General_CI_AI
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
					AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

				DELETE A FROM #TempResolveConflict A 
					INNER JOIN DM_Master_Log B ON A.Name COLLATE SQL_Latin1_General_CP1_CI_AS = B.Name AND  B.Is_Ignore = 'Y'
				WHERE B.DM_Master_Import_Code = @DM_Master_Import_Code
			END

			IF EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
			BEGIN
				UPDATE TIU SET TIU.Record_Status = 'R' , TIU.Is_Ignore = 'N'
				FROM DM_Title_Import_Utility_Data AS TIU WHERE ISNULL(TIU.Record_Status,'') <> 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code 
				AND ISNUMERIC(TIU.Col1) = 1 AND TIU.Col1 COLLATE Latin1_General_CI_AI IN (
				SELECT DISTINCT A.ExcelSrNo FROM (
					SELECT A.ExcelSrNo
					FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B  (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE A.RefKey IS NULL
						  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
						  AND B.Reference_Table <> 'Talent' 
						  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
					UNION 
					SELECT A.ExcelSrNo
					FROM #TempHeaderWithMultiple A
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
					UNION 
					SELECT A.ExcelSrNo
					FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE	A.RefKey IS NULL
							AND B.Target_Table = 'Map_Extended_Column' 
							AND Is_Multiple = 'N'
							AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					UNION 
					SELECT A.ExcelSrNo
					FROM #TempExtentedMetaData A
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
					UNION  
					SELECT A.ExcelSrNo
					FROM #TempTalent A
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN Role R (NOLOCK) ON R.Role_Code = A.RoleCode
					WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				) AS A )

				INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By)
				SELECT @DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles,'N',Mapped_By FROM #TempResolveConflict

				IF EXISTS(SELECT TOP 1 * FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE ISNULL(Record_Status,'') = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code )
				BEGIN
					DECLARE @SystemCount INT = 0, @OverAllCount INT = 0

					SELECT @SystemCount = COUNT(*) FROM DM_Master_Log (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N' AND Mapped_By = 'S'
					SELECT @OverAllCount = COUNT(*) FROM DM_Master_Log (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N' 

					IF (@SystemCount = @OverAllCount)
						UPDATE DM_Master_Import SET Status = 'SR' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
					ELSE
						UPDATE DM_Master_Import SET Status = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
				END
			
			
			END
		END

		BEGIN
			PRINT 'Check Add, Update and Ignore fields'
			
			BEGIN
			PRINT 'Title field update'
			--Updates Title code as reference key in front of a title
			--UPDATE ttup SET RefKey = tdup.Title_Code, FieldStatus = 'U' FROM #TempTitleUnPivot ttup
			--INNER JOIN #TempDupTitleName tdup ON tdup.ExcelSrNo = ttup.ExcelSrNo AND tdup.Title_Name = ttup.TitleData AND tdup.Title_Code IS NOT NULL and ttup.ColumnHeader = 'Title Name'
			
			----Updates Deal type code as reference key in front of a title
			--UPDATE ttup SET RefKey = tdup.Deal_Type_Code, FieldStatus = 'U' FROM #TempTitleUnPivot ttup
			--INNER JOIN #TempDupTitleName tdup ON tdup.ExcelSrNo = ttup.ExcelSrNo AND tdup.Title_Type = ttup.TitleData AND tdup.Title_Code IS NOT NULL

			UPDATE ttup SET RefKey = t.Title_Code, FieldStatus = 'U' FROM #TempTitleUnPivot ttup
			INNER JOIN #TempTitleUnPivot ttup2 ON ttup2.ExcelSrNo = ttup.ExcelSrNo
			INNER JOIN Title t on t.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS = ttup.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS AND t.Deal_Type_Code = ttup2.RefKey
			WHERE ttup.ColumnHeader = 'Title Name'
			AND ttup2.ColumnHeader = 'Title Type'
			
			--Sets status for all Title with reference key to Update
			UPDATE ttup SET FieldStatus = 'U' FROM #TempTitleUnPivot ttup
			INNER JOIN DM_Title_Import_Utility dm on dm.Display_Name = ttup.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE ttup.ExcelSrNo in (select tt2.ExcelSrNo from #TempTitleUnPivot tt2 where tt2.ColumnHeader = 'Title Name' and tt2.RefKey IS NOT NULL)
			END

			BEGIN
			PRINT 'Map Extended Column status for (Date, Int, Text)'

			DECLARE @DisplayName VARCHAR(100)
			DECLARE @TargetTable VARCHAR(100)
			DECLARE @TargetColumn VARCHAR(100)

			-- Checks for fields which target Map Extended Columns and are Normal imput fields (Date, Int, Text) --

			DECLARE UpdateMapExtendedColumnsCursor CURSOR FOR
			SELECT  dm.Display_Name, dm.Target_Table, dm.Target_Column FROM DM_Title_Import_Utility dm where dm.Is_Active = 'Y' AND dm.Target_Table = 'Map_Extended_Column' AND dm.Import_Type = @ImportTypeBasedOnColumns
			
			OPEN UpdateMapExtendedColumnsCursor
			FETCH NEXT FROM UpdateMapExtendedColumnsCursor INTO  @DisplayName, @TargetTable, @TargetColumn
				WHILE @@FETCH_STATUS = 0
					BEGIN
						PRINT '[' + @DisplayName + '] = Display Name [' + @TargetTable + '] = Target Table [' + @TargetColumn + '] = Target Column'
						IF EXISTS(select tt1.* FROM #TempTitleUnPivot tt1 where tt1.ColumnHeader = @DisplayName)
						BEGIN
							UPDATE ttup SET FieldStatus = CASE WHEN EXISTS(SELECT * FROM Map_Extended_Columns mec 
							WHERE mec.Record_Code = ttup2.RefKey AND mec.Table_Name = 'TITLE' AND mec.Columns_Code = ec.Columns_Code) 
							THEN 'U' ELSE 'A' END 
							FROM #TempTitleUnPivot ttup 
							INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
							INNER JOIN DM_Title_Import_Utility dm on dm.Display_Name = ttup.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS
							INNER JOIN Extended_Columns ec ON ec.Columns_Name = dm.Display_Name
							INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = ec.Columns_Code
							INNER JOIN Extended_Group eg ON eg.Extended_Group_Code = egc.Extended_Group_Code
							WHERE ttup.ColumnHeader = @DisplayName
							AND dm.Import_Type = @ImportTypeBasedOnColumns
							AND eg.Module_Code = 27
							AND ttup.FieldStatus = 'U'
							AND ttup.IsError <> 'Y'
							AND ttup2.ColumnHeader = 'Title Name'
							AND ec.Control_Type in ('DATE', 'TXT')
			
							UPDATE ttup SET FieldStatus = CASE 
							WHEN EXISTS (SELECT * FROM Map_Extended_Columns mec WHERE mec.Record_Code = ttup2.RefKey AND mec.Table_Name = 'TITLE' AND mec.Columns_Code = ec.Columns_Code) THEN 'U' 
							WHEN EXISTS (SELECT * FROM Map_Extended_Columns mec INNER JOIN Map_Extended_Columns_Details mecd ON mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
							WHERE mec.Record_Code = ttup2.RefKey AND mec.Table_Name = 'TITLE' AND mec.Columns_Code = ec.Columns_Code AND mecd.Columns_Value_Code = ttup.RefKey) THEN 'I' 
							ELSE 'A' END 
							FROM #TempTitleUnPivot ttup 
							INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
							INNER JOIN DM_Title_Import_Utility dm on dm.Display_Name = ttup.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS
							INNER JOIN Extended_Columns ec ON ec.Columns_Name = dm.Display_Name
							INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = ec.Columns_Code
							INNER JOIN Extended_Group eg ON eg.Extended_Group_Code = egc.Extended_Group_Code
							WHERE ttup.ColumnHeader = @DisplayName
							AND dm.Import_Type = @ImportTypeBasedOnColumns
							AND eg.Module_Code = 27
							AND ttup.FieldStatus = 'U'
							AND ttup.IsError <> 'Y'
							AND dm.Is_Multiple = 'N'
							AND ttup2.ColumnHeader = 'Title Name'
							AND ec.Control_Type in ('DDL')
						END
			
						FETCH NEXT FROM UpdateMapExtendedColumnsCursor INTO  @DisplayName, @TargetTable, @TargetColumn
					END
			CLOSE UpdateMapExtendedColumnsCursor
			DEALLOCATE UpdateMapExtendedColumnsCursor

			END

			BEGIN
			PRINT 'Map Extended Column status for multi select dropdown'
			-- Checks for fields which target Map Extended Columns_Value and are Multi select --
			-- Deletes multi select values from #TempExtendedMetaData table so no need to check for field status if add or update. Multi select values will append so change status to Add (A).' --
			-- Same Logic will be used for Talent in Map Extended Columns
				
				--Checks for Multi select extended data that is already used
				UPDATE ttup set ttup.FieldStatus = 'I' FROM #TempTitleUnPivot ttup 
				INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
				inner join #TempExtentedMetaData emd on ttup.ExcelSrNo = emd.ExcelSrNo AND ttup.ColumnHeader = emd.HeaderName
				inner join Map_Extended_Columns mec on mec.Columns_Code = emd.Columns_Code 
				inner join Map_Extended_Columns_Details mecd on mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
				where mecd.Columns_Value_Code = emd.EMDCode and mec.Table_Name = 'TITLE' and mec.Record_Code in (select ttup.RefKey from #TempTitleUnPivot ttup where ttup.ColumnHeader = 'Title Name')
				AND ttup2.ColumnHeader = 'Title Name' AND mec.Record_Code = ttup2.RefKey

				--Deletes all values that are already used
				DELETE emd FROM #TempExtentedMetaData emd inner join Map_Extended_Columns mec on mec.Columns_Code = emd.Columns_Code 
				inner join Map_Extended_Columns_Details mecd on mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
				inner join #TempTitleUnPivot ttup on ttup.ExcelSrNo = emd.ExcelSrNo AND ttup.ColumnHeader = emd.HeaderName
				INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
				where mecd.Columns_Value_Code = emd.EMDCode and mec.Table_Name = 'TITLE' and mec.Record_Code in (select ttup.RefKey from #TempTitleUnPivot ttup where ttup.ColumnHeader = 'Title Name')
				AND ttup2.ColumnHeader = 'Title Name' AND mec.Record_Code = ttup2.RefKey
				
				--Sets fields status to add for values that are remaining in temp table
				UPDATE ttup set ttup.FieldStatus = 'A'
				FROM #TempTitleUnPivot ttup INNER JOIN #TempExtentedMetaData emd on ttup.ColumnHeader = emd.HeaderName 
				AND ttup.ExcelSrNo = emd.ExcelSrNo

				--checks if the fields already have their parent entry in map extended columns. If yes, changes status to add to prevent multiple entries
				UPDATE ttup set ttup.FieldStatus = 'U' from #TempTitleUnPivot ttup
				INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
				inner join #TempExtentedMetaData emd on ttup.ExcelSrNo = emd.ExcelSrNo AND ttup.ColumnHeader = emd.HeaderName
				inner join Map_Extended_Columns mec on mec.Columns_Code = emd.Columns_Code 
				inner join Map_Extended_Columns_Details mecd on mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
				where mecd.Columns_Value_Code <> emd.EMDCode and mec.Table_Name = 'TITLE' and mec.Record_Code in (select ttup.RefKey from #TempTitleUnPivot ttup where ttup.ColumnHeader = 'Title Name')
				AND ttup2.ColumnHeader = 'Title Name' AND mec.Record_Code = ttup2.RefKey

			END
			
			BEGIN
			PRINT 'Map Extended Column status for single select dropdown which is saved in Map_Extended_Column_Values'
			
			-- Checks for fields which target Map Extended Columns_Value and single select --

			DECLARE UpdateMapExtendedColumnsValueCursor CURSOR FOR
			SELECT dm.Display_Name, dm.Target_Table, dm.Target_Column FROM DM_Title_Import_Utility dm where dm.Is_Active = 'Y' AND dm.Target_Table = 'Map_Extended_Column_Values' AND dm.Import_Type = @ImportTypeBasedOnColumns
			
			OPEN UpdateMapExtendedColumnsValueCursor
			FETCH NEXT FROM UpdateMapExtendedColumnsValueCursor INTO  @DisplayName, @TargetTable, @TargetColumn
				WHILE @@FETCH_STATUS = 0
					BEGIN
						PRINT '[' + @DisplayName + '] = Display Name [' + @TargetTable + '] = Target Table [' + @TargetColumn + '] = Target Column'
						IF EXISTS(select tt1.* FROM #TempTitleUnPivot tt1 where tt1.ColumnHeader = @DisplayName)
						BEGIN
							UPDATE ttup SET FieldStatus = CASE 
							WHEN EXISTS (SELECT * FROM Map_Extended_Columns mec INNER JOIN Map_Extended_Columns_Details mecd ON mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
							WHERE mec.Record_Code = ttup2.RefKey AND mec.Table_Name = 'TITLE' AND mec.Columns_Code = ec.Columns_Code AND mecd.Columns_Value_Code <> ttup.RefKey) THEN 'U' 
							WHEN EXISTS (SELECT * FROM Map_Extended_Columns mec INNER JOIN Map_Extended_Columns_Details mecd ON mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
							WHERE mec.Record_Code = ttup2.RefKey AND mec.Table_Name = 'TITLE' AND mec.Columns_Code = ec.Columns_Code AND mecd.Columns_Value_Code = ttup.RefKey) THEN 'I' 
							ELSE 'A' END 
							FROM #TempTitleUnPivot ttup 
							INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
							INNER JOIN DM_Title_Import_Utility dm on dm.Display_Name = ttup.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS
							INNER JOIN Extended_Columns ec ON ec.Columns_Name = dm.Display_Name
							INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = ec.Columns_Code
							INNER JOIN Extended_Group eg ON eg.Extended_Group_Code = egc.Extended_Group_Code
							WHERE ttup.ColumnHeader = @DisplayName
							AND dm.Import_Type = @ImportTypeBasedOnColumns
							AND eg.Module_Code = 27
							AND ttup.FieldStatus = 'U'
							AND ttup.IsError <> 'Y'
							AND dm.Is_Multiple = 'N'
							AND ttup2.ColumnHeader = 'Title Name'
							AND ec.Control_Type in ('DDL')
						END
			
						FETCH NEXT FROM UpdateMapExtendedColumnsValueCursor INTO  @DisplayName, @TargetTable, @TargetColumn
					END
			CLOSE UpdateMapExtendedColumnsValueCursor
			DEALLOCATE UpdateMapExtendedColumnsValueCursor

			END

			BEGIN

				DELETE th from #TempHeaderWithMultiple th 
				inner join #TempTitleUnPivot ttup on th.ExcelSrNo = ttup.ExcelSrNo AND th.HeaderName = ttup.ColumnHeader
				inner join #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
				inner join Title_Geners tg on tg.Title_Code = ttup2.RefKey
				where ttup2.ColumnHeader = 'Title Name'
				AND tg.Genres_Code = th.PropCode
				AND th.HeaderName = 'Genre'

				DELETE th from #TempHeaderWithMultiple th
				inner join #TempTitleUnPivot ttup on th.ExcelSrNo = ttup.ExcelSrNo AND th.HeaderName = ttup.ColumnHeader
				inner join #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
				inner join Title_Country tc on tc.Title_Code = ttup2.RefKey
				where ttup2.ColumnHeader = 'Title Name'
				AND tc.Country_Code = th.PropCode
				AND th.HeaderName = 'Country Of Origin'

			END

			BEGIN

				--Talent handling during update. First for Talent entry in Title_Talent. Next following methodology used for Multi select Dropdown in map extended columns
				DELETE tt FROM #TempTalent tt
				inner join #TempTitleUnPivot ttup on ttup.ColumnHeader = tt.HeaderName and tt.ExcelSrNo = ttup.ExcelSrNo
				inner join #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
				inner join Title_Talent ttr on ttr.Talent_Code = tt.TalentCode and ttr.Role_Code = tt.RoleCode
				WHERE ttr.Title_Code = ttup2.RefKey
				AND ttup2.ColumnHeader = 'Title Name'

				UPDATE ttup set ttup.FieldStatus = 'I' FROM #TempTitleUnPivot ttup 
				INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo 
				INNER JOIN #TempTalent tt on tt.ExcelSrNo = ttup.ExcelSrNo and tt.HeaderName = ttup.ColumnHeader
				INNER JOIN Extended_Columns ec on ec.Columns_Name = tt.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS 
				inner join Map_Extended_Columns mec on mec.Columns_Code = ec.Columns_Code 
				inner join Map_Extended_Columns_Details mecd on mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
				where mecd.Columns_Value_Code = tt.TalentCode and mec.Table_Name = 'TITLE' and mec.Record_Code in (select ttup.RefKey from #TempTitleUnPivot ttup where ttup.ColumnHeader = 'Title Name')
				AND ttup2.ColumnHeader = 'Title Name' AND mec.Record_Code = ttup2.RefKey

				DELETE tt from #TempTalent tt
				inner join #TempTitleUnPivot ttup on ttup.ExcelSrNo = tt.ExcelSrNo and tt.HeaderName = ttup.ColumnHeader
				INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo 
				INNER JOIN Extended_Columns ec on ec.Columns_Name = tt.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS 
				inner join Map_Extended_Columns mec on mec.Columns_Code = ec.Columns_Code 
				inner join Map_Extended_Columns_Details mecd on mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
				where mecd.Columns_Value_Code = tt.TalentCode and mec.Table_Name = 'TITLE' and mec.Record_Code in (select ttup.RefKey from #TempTitleUnPivot ttup where ttup.ColumnHeader = 'Title Name')
				AND ttup2.ColumnHeader = 'Title Name' AND mec.Record_Code = ttup2.RefKey

				UPDATE ttup set ttup.FieldStatus = 'A' 
				from #TempTitleUnPivot ttup INNER JOIN #TempTalent tt on tt.ExcelSrNo = ttup.ExcelSrNo AND ttup.ColumnHeader = tt.HeaderName

				UPDATE ttup set ttup.FieldStatus = 'U' FROM #TempTitleUnPivot ttup 
				INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo 
				INNER JOIN #TempTalent tt on tt.ExcelSrNo = ttup.ExcelSrNo and tt.HeaderName = ttup.ColumnHeader
				INNER JOIN Extended_Columns ec on ec.Columns_Name = tt.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS 
				inner join Map_Extended_Columns mec on mec.Columns_Code = ec.Columns_Code 
				inner join Map_Extended_Columns_Details mecd on mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
				where mecd.Columns_Value_Code <> tt.TalentCode and mec.Table_Name = 'TITLE' and mec.Record_Code in (select ttup.RefKey from #TempTitleUnPivot ttup where ttup.ColumnHeader = 'Title Name')
				AND ttup2.ColumnHeader = 'Title Name' AND mec.Record_Code = ttup2.RefKey

			END
			-- Sets status to any remaining items without field status to Add (Usually titles that are not already in database have null field status)
			UPDATE ttup set ttup.FieldStatus = 'A' FROM #TempTitleUnPivot ttup WHERE ttup.FieldStatus IS NULL

		END

		BEGIN
			PRINT 'if error which cannot be resolved '

			UPDATE T SET T.IsError = 'Y' 
			FROM #TempTitleUnPivot T WHERE T.ExcelSrNo COLLATE SQL_Latin1_General_CP1_CI_AS IN
			(SELECT Col1 FROM DM_Title_Import_Utility_Data (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status = 'E')

			IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE IsError = 'Y') 
			BEGIN

				UPDATE A SET A.Error_Message =ISNULL(A.Error_Message,'') + B.ErrorMessage, Record_Status = 'E'
				FROM DM_Title_Import_Utility_Data A
				INNER JOIN 
				(SELECT DISTINCT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y') as B on B.ExcelSrNo = A.Col1 COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' 
			
			END
			
			--truncate table #TempTitleImportType
			--insert into #TempTitleImportType select * from #TempTitleUnPivot

			IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE ISNULL(IsError,'') <> 'Y')
			BEGIN
				IF NOT EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
				BEGIN	
					CREATE TABLE #TempTableExcelSrAndTitleName(
						ExcelSrNo INT,
						TitleData varchar(500),
						TitleType VARCHAR(100),
						TitleStatus VARCHAR(10)
					)
					--IF(@ImportTypeBasedOnColumns = 'S')
					--BEGIN
						--SELECT MIN(ExcelSrNo) as ExcNo, TitleData FROM #TempTableExcelSrAndTitleName WHERE TitleData IN (SELECT DISTINCT TitleData FROM #TempTableExcelSrAndTitleName) GROUP BY TitleData ORDER By ExcNo

						PRINT 'Gets the title with least excel sr. number and its respective name. Use the excel to insert into title table so other excessive records of same name will not be inserted'
						
						--INSERT INTO #TempTableExcelSrAndTitleName (ExcelSrNo, TitleData, TitleStatus) SELECT MIN(CAST(ExcelSrNo as INT)) as ExcNo, TitleData, FieldStatus 
						--FROM (SELECT ExcelSrNo, TitleData, FieldStatus from #TempTitleUnPivot where ColumnHeader = 'Title Name') as tp
						--WHERE TitleData IN (SELECT DISTINCT tp.TitleData) GROUP BY TitleData, FieldStatus ORDER By ExcNo

						--UPDATE A SET TitleType = ttup.RefKey FROM #TempTableExcelSrAndTitleName A 
						--INNER JOIN #TempTitleUnPivot ttup on ttup.ExcelSrNo = A.ExcelSrNo
						--WHERE ttup.ColumnHeader = 'Title Type'


						INSERT INTO #TempTableExcelSrAndTitleName (ExcelSrNo, TitleData, TitleType, TitleStatus) 
						SELECT MIN(CAST(ExcelSrNo as INT)) as ExcNo, TitleName, TitleType, FieldStatus 
						FROM (SELECT t1.ExcelSrNo, t1.TitleData as TitleName, t2.RefKey as TitleType, t1.FieldStatus from #TempTitleUnPivot t1 
						inner join #TempTitleUnPivot t2 on t1.ExcelSrNo = t2.ExcelSrNo 
						where t1.ColumnHeader = 'Title Name' and t2.ColumnHeader = 'Title Type') as tp
						WHERE tp.TitleName IN (SELECT DISTINCT tp.TitleName) 
						GROUP BY TitleName,TitleType, FieldStatus ORDER By ExcNo

						PRINT 'Entry into #TempTableExcelSrAndTitleName'
						
					--END

					DECLARE @cols_DisplayName AS NVARCHAR(MAX), @cols_TargetColumn AS NVARCHAR(MAX), @query AS NVARCHAR(MAX)
					UPDATE #TempTitleUnPivot SET IsError = '' WHERE IsError IS NULL

					-----------Title COLUMN--------------------
					SELECT @cols_DisplayName = STUFF(( SELECT ',[' + Display_Name +']' FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' and Target_Table = 'Title' AND Import_Type = @ImportTypeBasedOnColumns ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
					SELECT @cols_TargetColumn = STUFF(( SELECT ',[' + Target_Column +']' FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' and Target_Table = 'Title' AND Import_Type = @ImportTypeBasedOnColumns ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				
					PRINT ('
					INSERT INTO Title ( Is_Active, '+@cols_TargetColumn+')
					SELECT ''Y'', '+@cols_DisplayName+' FROM (SELECT tp.ExcelSrNo, ColumnHeader, 
					CASE WHEN RefKey IS NULL THEN tp.TitleData ELSE RefKey END
					TitleData FROM #TempTitleUnPivot 
					tp inner join #TempTableExcelSrAndTitleName tet on tet.ExcelSrNo = tp.ExcelSrNo
					WHERE ISError <> ''Y'') AS Tbl PIVOT( MAX(TitleData) FOR ColumnHeader IN ('+@cols_DisplayName+')) AS Pvt ')

					EXEC ('
					INSERT INTO Title ( Is_Active, '+@cols_TargetColumn+')
					SELECT ''Y'', '+@cols_DisplayName+' FROM (SELECT tp.ExcelSrNo, ColumnHeader, 
					CASE WHEN RefKey IS NULL THEN tp.TitleData ELSE RefKey END
					TitleData FROM #TempTitleUnPivot
					tp inner join #TempTableExcelSrAndTitleName tet on tet.ExcelSrNo = tp.ExcelSrNo
					WHERE ISError <> ''Y'' AND tet.TitleStatus = ''A'') AS Tbl PIVOT( MAX(TitleData) FOR ColumnHeader IN ('+@cols_DisplayName+')) AS Pvt ')
			
			--IMPORT LINE [tp inner join (select * from #TempTableExcelSrAndTitleName where ExcelSrNo = (select min(ExcelSrNo) from #TempTableExcelSrAndTitleName)) tet on tet.ExcelSrNo = tp.ExcelSrNo]
			--AND tet.TitleStatus = ''A'' checks for titles with Add (A) status in the distinct column and takes only those titles for insertion
					PRINT 'ONE'
					UPDATE A SET A.RefKey = B.Title_Code 
					FROM #TempTitleUnPivot A
					INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
					INNER JOIN #TempTableExcelSrAndTitleName te on te.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name AND te.TitleType = B.Deal_Type_Code
					WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y' AND A.FieldStatus <> 'U'

					PRINT 'TWO'
					UPDATE B SET B.Inserted_By = 143, B.Inserted_On = GETDATE(), B.Last_UpDated_Time = GETDATE()
					FROM #TempTitleUnPivot A
					INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
					INNER JOIN #TempTableExcelSrAndTitleName te on te.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name AND te.TitleType = B.Deal_Type_Code
					WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y'

					PRINT 'THREE'
					UPDATE B SET B.TitleCode = A.RefKey FROM  #TempTitleUnPivot A
					INNER JOIN #TempHeaderWithMultiple B ON A.ExcelSrNo = B.ExcelSrNo
					WHERE A.ColumnHeader = 'Title Name'  AND A.ISError <> 'Y'

					PRINT 'FOUR'
					-----------Title_Country COLUMN--------------------
					SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' AND Import_Type = @ImportTypeBasedOnColumns and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
					SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' AND Import_Type = @ImportTypeBasedOnColumns and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
					
					PRINT ('
					INSERT INTO Title_Country (Title_Code, '+@cols_TargetColumn+')
					SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE 
					HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = ''Y'' AND Import_Type = ''' + @ImportTypeBasedOnColumns + ''' and Target_Table = ''Title_Country'')
					')
					
					PRINT 'FIVE'
					-- Commented because it is giving issues while creating and executing insert statement as there are no Title country related import field for Movie and Show configuration
					-- check following query [ select * from DM_Title_Import_Utility where Target_Table = 'Title_Country' ]

					EXEC ('
					INSERT INTO Title_Country (Title_Code, '+@cols_TargetColumn+')
					SELECT DISTINCT TitleCode, PropCode from #TempHeaderWithMultiple WHERE 
					HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = ''Y'' AND Import_Type = ''' + @ImportTypeBasedOnColumns + ''' and Target_Table = ''Title_Country'')
					')
					
					PRINT 'SIX'
					-----------Title_Geners COLUMN--------------------
					SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' AND Import_Type = @ImportTypeBasedOnColumns and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
					SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = 'Y' AND Import_Type = @ImportTypeBasedOnColumns and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')	
					
					PRINT ('
					INSERT INTO Title_Geners (Title_Code, '+@cols_TargetColumn+')
					SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = ''Y'' AND Import_Type = ''' + @ImportTypeBasedOnColumns + ''' and Target_Table = ''Title_Geners'')
					')
					
					PRINT 'SEVEN'
					EXEC ('
					INSERT INTO Title_Geners (Title_Code, '+@cols_TargetColumn+')
					SELECT DISTINCT TitleCode, PropCode from #TempHeaderWithMultiple WHERE HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility (NOLOCK) WHERE Is_Active = ''Y'' AND Import_Type = ''' + @ImportTypeBasedOnColumns + '''  and Target_Table = ''Title_Geners'')
					')

					PRINT 'EIGHT'
					-----------Title_Talent COLUMN--------------------
					INSERT INTO Talent_Role (Talent_Code, Role_Code)
					SELECT A.TalentCode, A.RoleCode
					FROM #TempTalent A
					LEFT JOIN TALENT_ROLE TR (NOLOCK) ON TR.Talent_Code = A.TalentCode AND TR.Role_Code = A.RoleCode
					WHERE tr.Role_Code IS NULL and TR.Talent_Code IS NULL
					--OLD Line **LEFT JOIN TALENT_ROLE TR (NOLOCK) ON TR.Talent_Code = A.TalentCode AND TR.Role_Code = A.RoleCode**

					PRINT ('
					INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_Code)
					SELECT B.RefKey, A.TalentCode, A.RoleCode FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot B ON B.ExcelSrNo = A.ExcelSrNo
					WHERE B.ColumnHeader = ''Title Name'' AND  A.TalentCode IS NOT NULL AND B.ISError <> ''Y''
					')

					PRINT 'NINE'

					EXEC ('
					INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_Code)
					SELECT DISTINCT B.RefKey, A.TalentCode, A.RoleCode FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot B ON B.ExcelSrNo = A.ExcelSrNo
					WHERE B.ColumnHeader = ''Title Name'' AND  A.TalentCode IS NOT NULL AND B.ISError <> ''Y''
					')

					PRINT 'TEN'
					DECLARE @Counter INT 
					DECLARE @Theatrical_columnName NVARCHAR(Max);
					Set @Theatrical_columnName = 'Theatrical release date';
						SET @Counter = (select Count(*) from #TempTitleUnPivot where ColumnHeader = @Theatrical_columnName and TitleData <> '')

						Declare @I Int = 1;

						WHILE ( @I <= @Counter)
							Begin
								Declare @TitleCode NVARCHAR(MAX),@CountryCode INT;
								Declare @Release_date NVARCHAR(MAX);
								Declare @ExcelSrNo NVARCHAR(MAX);
								Declare @Title_Release_Code INT;

								SET @ExcelSrNo = (select a.ExcelSrNo from (select ROW_NUMBER() OVER(Order By ExcelSrNo) as 'RowNumber',* from #TempTitleUnPivot
								where ColumnHeader = @Theatrical_columnName and TitleData <> '') as a where RowNumber = @I)
								
								SET @Release_date = (Select TitleData from #TempTitleUnPivot where ColumnHeader = @Theatrical_columnName and ExcelSrNo = @ExcelSrNo)
								SEt @TitleCode  = (Select RefKey from #TempTitleUnPivot where ColumnHeader = 'Title Name' and ExcelSrNo = @ExcelSrNo)
								SET @CountryCode = CAST((select Parameter_Value from system_parameter where Parameter_Name = 'INDIA_COUNTRY_CODE')AS INT) 

								IF NOT EXISTS (SELECT * FROM Title_Release where Title_Code = @TitleCode)
								Begin
									
									Insert Into Title_Release(Title_Code,Release_Date,Release_Type)
									Values(@TitleCode,@Release_date,'C')
									Set @Title_Release_Code = (SELECT SCOPE_IDENTITY());
									
									Insert Into Title_Release_Platforms(Title_Release_Code,Platform_Code) 
									Values(@Title_Release_Code,1)
									
									Insert Into Title_Release_Region(Title_Release_Code,Country_Code)
									Values(@Title_Release_Code,@CountryCode)
								End
								Else if EXISTS (SELECT * FROM Title_Release where Title_Code = @TitleCode)
								Begin

								  Update Title_Release Set Release_Date = @Release_date where Title_Code = @TitleCode;
								End
							  SET @I = @I + 1;
					       End
					PRINT 'Insert Theatrical release data'
					--Inser


			--Might need that import join line mentioned above in this exec query as well
			
			--SELECT 'TempUnpivot table after inserting looks like this'
			--SELECT * FROM #TempTitleUnPivot
			--SELECT * FROM #TempTitleImportType

			--truncate table #TempTitleImportType
			--SELECT 'Truncate and re-insert again to get Title Code and other reference key data'
			--insert into #TempTitleImportType select * from #TempTitleUnPivot


			------------------------------------------------------------- UPDATE BLOCK -------------------------------------------------------------

			
				DECLARE TitleUpdateCursor CURSOR FOR
				SELECT dm.Display_Name, dm.Target_Table, dm.Target_Column FROM DM_Title_Import_Utility (NOLOCK) dm WHERE dm.Is_Active = 'Y' AND dm.Target_Table = 'TITLE' 
					AND dm.Import_Type = @ImportTypeBasedOnColumns AND Display_Name <> 'Title Name'
				
				OPEN TitleUpdateCursor
				FETCH NEXT FROM TitleUpdateCursor INTO @DisplayName, @TargetTable, @TargetColumn
					WHILE @@FETCH_STATUS = 0
						BEGIN
							PRINT '[' + @DisplayName + '] = Display Name [' + @TargetTable + '] = Target Table [' + @TargetColumn + '] = Target Column'
				
							IF EXISTS(select tt1.ColumnHeader, CASE WHEN tt1.RefKey IS NULL THEN tt1.TitleData ELSE tt1.RefKey END FROM #TempTitleUnPivot tt1 INNER JOIN #TempTitleUnPivot tt2 on tt1.ExcelSrNo = tt2.ExcelSrNo 
							where tt2.ColumnHeader = 'Title Name' and tt1.ColumnHeader = @DisplayName)
							BEGIN
								PRINT ('
								UPDATE Title SET '+ @TargetColumn +'  = CASE WHEN tt1.RefKey IS NULL THEN tt1.TitleData ELSE tt1.RefKey END
								FROM #TempTitleUnPivot tt1 INNER JOIN #TempTitleUnPivot tt2 on tt1.ExcelSrNo = tt2.ExcelSrNo 
								INNER JOIN DM_Title_Import_Utility dm on dm.Display_Name = tt1.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS
								INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = tt1.ExcelSrNo
								where tt1.ColumnHeader <> ''Title Name'' AND tt2.ColumnHeader = ''Title Name'' AND dm.Import_Type = ''' + @ImportTypeBasedOnColumns + ''' AND dm.Display_Name =  '''+ @DisplayName +''' AND Title_Code = tt2.RefKey AND tt2.FieldStatus = ''U''
								')
								EXEC ('
								UPDATE Title SET '+ @TargetColumn +'  = CASE WHEN tt1.RefKey IS NULL THEN tt1.TitleData ELSE tt1.RefKey END
								FROM #TempTitleUnPivot tt1 INNER JOIN #TempTitleUnPivot tt2 on tt1.ExcelSrNo = tt2.ExcelSrNo 
								INNER JOIN DM_Title_Import_Utility dm on dm.Display_Name = tt1.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS
								INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = tt1.ExcelSrNo
								where tt1.ColumnHeader <> ''Title Name'' AND tt2.ColumnHeader = ''Title Name'' AND dm.Import_Type = ''' + @ImportTypeBasedOnColumns + ''' AND dm.Display_Name =  '''+ @DisplayName +''' AND Title_Code = tt2.RefKey AND tt2.FieldStatus = ''U''
								')
							END
				
							FETCH NEXT FROM TitleUpdateCursor INTO @DisplayName, @TargetTable, @TargetColumn
						END
				CLOSE TitleUpdateCursor
				DEALLOCATE TitleUpdateCursor
				
					UPDATE mec SET Column_Value = ttup.TitleData
					from Map_Extended_Columns mec 
					inner join Extended_Columns ec on mec.Columns_Code = ec.Columns_Code
					inner join DM_Title_Import_Utility dm on dm.Display_Name = ec.Columns_Name
					inner join #TempTitleUnPivot ttup on ttup.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = dm.Display_Name 
					INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
					WHERE mec.Record_Code = ttup2.RefKey 
					AND ttup2.ColumnHeader = 'Title Name' 
					AND dm.Import_Type = @ImportTypeBasedOnColumns
					AND ttup.FieldStatus = 'U'
					AND ttup.IsError <> 'Y'
					AND ec.Control_Type in ('DATE', 'TXT')
					AND dm.Target_Table = 'Map_Extended_Column'
				
					UPDATE mecd SET Columns_Value_Code = ttup.RefKey
					from Map_Extended_Columns_Details mecd
					inner join Map_Extended_Columns mec on mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code
					inner join Extended_Columns ec on mec.Columns_Code = ec.Columns_Code
					inner join DM_Title_Import_Utility dm on dm.Display_Name = ec.Columns_Name
					inner join #TempTitleUnPivot ttup on ttup.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = dm.Display_Name 
					INNER JOIN #TempTitleUnPivot ttup2 on ttup.ExcelSrNo = ttup2.ExcelSrNo
					WHERE mec.Record_Code = ttup2.RefKey 
					AND ttup2.ColumnHeader = 'Title Name' 
					AND dm.Import_Type = @ImportTypeBasedOnColumns
					AND ttup.FieldStatus = 'U'
					AND ttup.IsError <> 'Y'
					AND dm.Is_Multiple = 'N'
					AND ec.Control_Type in ('DDL')
					AND dm.Target_Table = 'Map_Extended_Column_Values'

			------------------------------------------------------------- UPDATE BLOCK -------------------------------------------------------------
			
					----------------------------------- Added Table For Row Number in Map Extended ----------------------------------- 

					---------------- ADDED ON 21 - 04 - 2023 -------------------
					
					Create table #TempDataTable(
						ExtendedGroupName Varchar(100),
						ColumnCodeInExtGrpCfg int,
						ColumnCodeInExtColumms int,
						ExtendedColumnsName varchar(100)
					)
					Create table #TempDistinctGrid(
						DistinctGroupNameId int DEFAULT (1),
						DistinctExtendedGroupName varchar(100)
					)
					--DistinctGroupNameId int primary key identity(1,1),
					
					Create Table #TempTblWithColumnCodeAndRowNum(
						Columns_Code INT,
						TempRow_No INT
					)
					
					INSERT INTO #TempDataTable (ExtendedGroupName, ColumnCodeInExtGrpCfg, ColumnCodeInExtColumms, ExtendedColumnsName) 
					SELECT eg.Group_Name, egc.Columns_Code, ec.Columns_Code, ec.Columns_Name
					FROM Extended_Group eg 
						INNER JOIN Extended_Group_Config egc ON egc.Extended_Group_Code = eg.Extended_Group_Code 
						INNER JOIN Extended_Columns ec ON ec.Columns_Code = egc.Columns_Code AND eg.Module_Code = 27 AND eg.Add_Edit_Type = 'grid'
					
					INSERT INTO #TempDistinctGrid (DistinctExtendedGroupName) SELECT DISTINCT ExtendedGroupName FROM #TempDataTable
					
					INSERT INTO #TempTblWithColumnCodeAndRowNum SELECT ec.Columns_Code, DistinctGroupNameId FROM Extended_Columns ec 
					LEFT JOIN (SELECT * FROM #TempDataTable tdt INNER JOIN #TempDistinctGrid tdg ON tdt.ExtendedGroupName = tdg.DistinctExtendedGroupName) tbl 
					ON ec.Columns_Code = tbl.ColumnCodeInExtColumms

					--------- Added Inner Join line 
					------------------- INNER JOIN #TempTblWithColumnCodeAndRowNum tmpColRow ON tmpColRow.Columns_Code = EC.Columns_Code ---------
					--------- For Insert Into Row_No via TempRow_No

					------------------------------------------------------------------------------------------------------------------
					
					-----------EXTENDED COLUMN IS Multiple = N With DDL AND Map_Extended_Column--------------------
					INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Is_Multiple_Select, Row_No)
					SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.RefKey, 'N', TempRow_No
					FROM #TempTitleUnPivot A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name = B.Display_Name
						INNER JOIN #TempTblWithColumnCodeAndRowNum tmpColRow ON tmpColRow.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group eg on eg.Extended_Group_Code = egc.Extended_Group_Code
						INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = A.ExcelSrNo
					WHERE B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N' 
						AND EC.Control_Type = 'DDL' 
						AND AA.ColumnHeader = 'Title Name'
						AND AA.ISError <> 'Y'
						AND A.ISError <> 'Y'
						AND (B.Import_Type = @ImportTypeBasedOnColumns)
						AND eg.Module_Code = 27
						AND A.FieldStatus = 'A'

					-----------EXTENDED COLUMN IS Multiple = N With TXT AND Map_Extended_Column--------------------
					INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Column_Value, Is_Multiple_Select, Row_No)
					SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.TitleData, 'N', TempRow_No  
					FROM #TempTitleUnPivot A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name = B.Display_Name
						INNER JOIN #TempTblWithColumnCodeAndRowNum tmpColRow ON tmpColRow.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group eg on eg.Extended_Group_Code = egc.Extended_Group_Code
						INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = A.ExcelSrNo
					WHERE B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N' 
						AND EC.Control_Type = 'TXT'
						AND AA.ColumnHeader = 'Title Name'
						AND AA.ISError <> 'Y' 
						AND A.ISError <> 'Y'
						AND (B.Import_Type = @ImportTypeBasedOnColumns)
						AND eg.Module_Code = 27
						AND A.FieldStatus = 'A'

					-----------EXTENDED COLUMN IS Multiple = N With DATE AND Map_Extended_Column--------------------
					INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Column_Value, Is_Multiple_Select, Row_No)
					SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.TitleData, 'N', TempRow_No  
					FROM #TempTitleUnPivot A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name = B.Display_Name
						INNER JOIN #TempTblWithColumnCodeAndRowNum tmpColRow ON tmpColRow.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group eg on eg.Extended_Group_Code = egc.Extended_Group_Code
						INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = A.ExcelSrNo
					WHERE B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N' 
						AND EC.Control_Type = 'DATE'
						AND AA.ColumnHeader = 'Title Name'
						AND AA.ISError <> 'Y' 
						AND A.ISError <> 'Y'
						AND (B.Import_Type = @ImportTypeBasedOnColumns)
						AND eg.Module_Code = 27
						AND A.FieldStatus = 'A'
					
					-----------EXTENDED COLUMN IS Multiple = N AND Insert into Map_Extended_Column_Value-----------
					Create Table #TempTableWithRefTableAndSingleSelect(
						ExcelSrNo INT,
						TitleCode INT,
						TableType VARCHAR(100),
						ExtendedColumnCode INT,
						DDLSelectedValue INT,
						IsMultiSelect VARCHAR(5),
						TempRowNo INT
					)
										
					INSERT INTO #TempTableWithRefTableAndSingleSelect(ExcelSrNo, TitleCode, TableType, ExtendedColumnCode, DDLSelectedValue, IsMultiSelect, TempRowNo)
					SELECT A.ExcelSrNo, AA.RefKey,'TITLE', EC.Columns_Code, A.RefKey, 'N', TempRow_No
					FROM #TempTitleUnPivot A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name = B.Display_Name
						INNER JOIN #TempTblWithColumnCodeAndRowNum tmpColRow ON tmpColRow.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group eg on eg.Extended_Group_Code = egc.Extended_Group_Code
						INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = A.ExcelSrNo
					WHERE B.Target_Table = 'Map_Extended_Column_Values' 
						AND Is_Multiple = 'N' 
						AND EC.Control_Type = 'DDL' 
						AND AA.ColumnHeader = 'Title Name'
						AND AA.ISError <> 'Y'
						AND A.ISError <> 'Y'
						AND (B.Import_Type = @ImportTypeBasedOnColumns)
						AND eg.Module_Code = 27
						AND A.FieldStatus = 'A'
											
					INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select, Row_No)
					select A.TitleCode, A.TableType, A.ExtendedColumnCode, A.IsMultiSelect, A.TempRowNo from #TempTableWithRefTableAndSingleSelect A

					INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)	
					SELECT mec.Map_Extended_Columns_Code, a.DDLSelectedValue FROM #TempTableWithRefTableAndSingleSelect a
					INNER JOIN Map_Extended_Columns mec on mec.Record_Code = a.TitleCode AND mec.Columns_Code = a.ExtendedColumnCode 
					AND mec.Table_Name = a.TableType COLLATE SQL_Latin1_General_CP1_CI_AS
	

					-----------EXTENDED COLUMN IS Multiple = Y AND Map_Extended_Column --------------------

					INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select, Row_No)
					SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y', TempRow_No  
					FROM (select distinct * from #TempExtentedMetaData) A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN #TempTitleUnPivot ttup ON ttup.ExcelSrNo = A.ExcelSrNo AND ttup.ColumnHeader = A.HeaderName
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name = B.Display_Name
						INNER JOIN #TempTblWithColumnCodeAndRowNum tmpColRow ON tmpColRow.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group eg on eg.Extended_Group_Code = egc.Extended_Group_Code
						INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = A.ExcelSrNo
					WHERE B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'Y' 
						AND AA.ColumnHeader = 'Title Name'
						AND AA.ISError <> 'Y'
						AND (B.Import_Type = @ImportTypeBasedOnColumns)
						AND eg.Module_Code = 27
						AND ttup.FieldStatus = 'A'

					INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)
					SELECT DISTINCT MEC.Map_Extended_Columns_Code, A.EMDCode
					FROM (select distinct * from #TempExtentedMetaData) A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN Map_Extended_Columns MEC (NOLOCK) ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = A.Columns_Code
						INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = A.ExcelSrNo
					WHERE AA.ColumnHeader = 'Title Name'  
						AND AA.ISError <> 'Y'

					-----------EXTENDED COLUMN IS Multiple = Y IN TALENT --------------------

					INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
					SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
					FROM (select distinct * from #TempTalent) A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN #TempTitleUnPivot ttup ON ttup.ExcelSrNo = A.ExcelSrNo AND ttup.ColumnHeader = A.HeaderName
						INNER JOIN DM_Title_Import_Utility B (NOLOCK) ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
						INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name = B.Display_Name
						INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = EC.Columns_Code
						INNER JOIN Extended_Group eg on eg.Extended_Group_Code = egc.Extended_Group_Code
						INNER JOIN #TempTableExcelSrAndTitleName tet ON tet.ExcelSrNo = A.ExcelSrNo
					WHERE B.Target_Table = 'Map_Extended_Column_Values' 
						AND Is_Multiple = 'Y' 
						AND AA.ColumnHeader = 'Title Name'
						AND AA.ISError <> 'Y'
						AND (B.Import_Type = @ImportTypeBasedOnColumns)
						AND eg.Module_Code = 27
						AND ttup.FieldStatus = 'A'

					INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)
					SELECT MEC.Map_Extended_Columns_Code, A.TalentCode
					FROM (select distinct * from #TempTalent) A
						INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
						INNER JOIN extended_columns EC (NOLOCK) ON EC.Columns_Name = A.HeaderName COLLATE Latin1_General_CI_AI
						INNER JOIN Map_Extended_Columns MEC (NOLOCK) ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = EC.Columns_Code
					WHERE AA.ColumnHeader = 'Title Name'
						AND AA.ISError <> 'Y'
						
---------------------------------------------------------------------------------------- QUERY FOR EPISODE/PROGRAM ------------------------------------------------------------------------------------
		
		IF((SELECT Parameter_Value FROM System_Parameter WHERE Parameter_Name = 'Allow_Generate_Content_From_Title_Import') = 'Y')
		BEGIN
		PRINT 'Generating Content'
		IF(@ImportTypeBasedOnColumns = 'S')
		BEGIN
		PRINT 'Show Content Generation'
			DECLARE @MaxExcelSrNo INT
			DECLARE @MinExcelSrNo INT
			DECLARE @CurrentExcelNum INT
			DECLARE @MinTitleEntry INT = 1
			DECLARE @MaxTitleEntry INT
			DECLARE @CurrentTitleEntry INT
			DECLARE @Title_Code INT
			DECLARE @EpisodeNo INT
			DECLARE @EpsDuration  DECIMAL (18, 2)
			DECLARE @EpisodeTitle  NVARCHAR (2000)
			DECLARE @EpsSynopsis NVARCHAR (4000)
			DECLARE @ColumnString NVARCHAR(MAX)
			DECLARE @ValueString NVARCHAR(MAX)
			DECLARE @MovieCodes VARCHAR(1000);
			DECLARE @ShowCodes VARCHAR(1000);
			DECLARE @TableName VARCHAR(100)
			DECLARE @TableColumn VARCHAR(100)
			DECLARE @ColumnData VARCHAR(4000)
			DECLARE @TitleTypeCode INT
			DECLARE @DealType VARCHAR(10);
			DECLARE @UpdateColumnString NVARCHAR(MAX)
			DECLARE @UpdateValueString NVARCHAR(MAX)
			DECLARE @UpdateString NVARCHAR(MAX)

			CREATE TABLE #TempTitleContentTable(
				Title_Content_Code INT NULL,
				Title_Code INT NULL,
				Episode_No INT NULL,
				Duration DECIMAL (18, 2) NULL,
				Ref_BMS_Content_Code VARCHAR (50) NULL,
				Episode_Title NVARCHAR (2000) NULL,
				Content_Status CHAR (1) NULL,
				Synopsis NVARCHAR (4000) NULL
			)

			CREATE TABLE #EpisodeDetails(
				EpisodeDetailsCode INT IDENTITY(1, 1),
				TableName nvarchar(1000),
				TableDisplayName nvarchar(1000),
				TableColumnName nvarchar(1000),
				ColumnDataTxt nvarchar(4000),
				TitleCode INT,
				ExcelSrNo INT,
				DM_Title_Import_Code INT
			)

			CREATE TABLE #TitleEpisodeDetails(
				TitleEpisodeDetailsCode INT,
				TitleCode INT
			)

			DECLARE @RefTableFromImport VARCHAR(100) = 'Title_Content'
			INSERT INTO #EpisodeDetails(TableName, TableDisplayName, TableColumnName, ColumnDataTxt, TitleCode, ExcelSrNo, DM_Title_Import_Code) 
			SELECT tiu.Target_Table, ttup.ColumnHeader, tiu.Target_Column, ttup.TitleData, ttup.RefKey, ttup.ExcelSrNo, @DM_Master_Import_Code
			FROM #TempTitleUnPivot ttup 
				LEFT JOIN DM_Title_Import_Utility tiu ON tiu.Display_Name = ttup.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS
				INNER JOIN DM_Title_Import_Utility_Data tiud ON tiud.DM_Master_Import_Code = @DM_Master_Import_Code
				AND tiud.Col1 = ttup.ExcelSrNo  COLLATE SQL_Latin1_General_CP1_CI_AS
				AND tiu.Target_Table = @RefTableFromImport
				AND (ttup.IsError IS NULL or ttup.IsError = '')

			--select 'Selecting Episode Details table'
			--select * from #TempTitleUnPivot
			--select * from #EpisodeDetails
			PRINT 'Update Title Code in Episode Details Table'
			UPDATE EC SET TitleCode = tt.RefKey from #EpisodeDetails ec inner join #TempTitleUnPivot tt on ec.ExcelSrNo = tt.ExcelSrNo where tt.ColumnHeader = 'Title Name'
			--select * from #EpisodeDetails

			SET @MaxExcelSrNo = (SELECT MAX(ExcelSrNo) FROM #EpisodeDetails)
			SET @MinExcelSrNo = (SELECT MIN(ExcelSrNo) FROM #EpisodeDetails)
			--SELECT @MaxExcelSrNo as MaxExcelNo
			--SELECT @MinExcelSrNo as MinExcelNo

			SET @CurrentExcelNum = @MinExcelSrNo

			WHILE (@CurrentExcelNum <= @MaxExcelSrNo)
				BEGIN
					PRINT CAST(@CurrentExcelNum as NVARCHAR(100)) + ' = Current Excel No.'
					
						SET @Title_Code = (SELECT ttup.RefKey FROM #TempTitleUnPivot ttup WHERE ttup.ExcelSrNo = @CurrentExcelNum AND ttup.ColumnHeader = 'Title Name' AND (ttup.IsError IS NULL or ttup.IsError = ''))
					IF(@Title_Code IS NOT NULL)
					BEGIN

						PRINT CAST(@Title_Code as NVARCHAR(100)) + ' = Title Code'
						
						IF EXISTS(select * from Title_Content tc inner join #EpisodeDetails ec on tc.Title_Code = ec.TitleCode and tc.Episode_No = ec.ColumnDataTxt where ec.TableColumnName = 'Episode_No' AND ec.ExcelSrNo = @CurrentExcelNum)
						BEGIN
							PRINT 'UPDATE Show Episode'
							--select * from Title_Content tc inner join #EpisodeDetails ec on tc.Title_Code = ec.TitleCode and tc.Episode_No = ec.ColumnDataTxt where ec.TableColumnName = 'Episode_No'
							--select * from #TempTitleContentTable
							--select * from #EpisodeDetails
							SET @UpdateString = ''
								DECLARE EpisodeUpdateCursor CURSOR FOR
								SELECT ed.TableName, ed.TableColumnName, ed.ColumnDataTxt FROM #EpisodeDetails ed where ed.ExcelSrNo = @CurrentExcelNum

								OPEN EpisodeUpdateCursor
								FETCH NEXT FROM EpisodeUpdateCursor INTO @TableName, @TableColumn, @ColumnData
									WHILE @@FETCH_STATUS = 0
										BEGIN
											SET @UpdateString = @UpdateString + 'tc.' + @TableColumn + ' = ''' + (select REPLACE(@ColumnData, '''', '''''')) + ''', '
											FETCH NEXT FROM EpisodeUpdateCursor INTO @TableName, @TableColumn, @ColumnData
										END
								CLOSE EpisodeUpdateCursor
								DEALLOCATE EpisodeUpdateCursor

							SET @UpdateString = (select substring(@UpdateString, 1, (len(@UpdateString) - 1)))
							SELECT @UpdateString
							PRINT 'UPDATE tc SET ' + @UpdateString + ' from Title_Content tc inner join #EpisodeDetails ec on tc.Title_Code = ec.TitleCode and tc.Episode_No = ec.ColumnDataTxt where ec.TableColumnName = ''Episode_No'' AND ec.ExcelSrNo = ' + CAST(@CurrentExcelNum as NVARCHAR(100))
							EXEC ('UPDATE tc SET ' + @UpdateString + ' from Title_Content tc 
							inner join #EpisodeDetails ec on tc.Title_Code = ec.TitleCode and tc.Episode_No = ec.ColumnDataTxt 
							where ec.TableColumnName = ''Episode_No'' AND ec.ExcelSrNo = ' + @CurrentExcelNum)
						END
						ELSE
						BEGIN

						SET @ColumnString = 'Content_Status, Title_Code, '
						SET @ValueString = '''P'', ' + '''' + CAST(@Title_Code as NVARCHAR(100)) + '''' + ', '

						SET @MovieCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies');
						SET @ShowCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show');

							IF EXISTS(SELECT number FROM [dbo].[fn_Split_withdelemiter](@ShowCodes,',') WHERE number = @TitleTypeCode)
							BEGIN 
								SET @DealType = 'SHOW'
							END
							ELSE IF EXISTS(SELECT number FROM [dbo].[fn_Split_withdelemiter](@MovieCodes,',') WHERE number = @TitleTypeCode)
							BEGIN
								SET @DealType = 'MOVIE'
							END

							DECLARE curInsertQueryForTables CURSOR FOR SELECT ed.TableName, ed.TableColumnName, ed.ColumnDataTxt
							FROM #EpisodeDetails ed WHERE ed.TableName = @RefTableFromImport AND ed.ExcelSrNo = @CurrentExcelNum

								OPEN curInsertQueryForTables
								FETCH NEXT FROM curInsertQueryForTables
								INTO @TableName, @TableColumn, @ColumnData

									WHILE @@FETCH_STATUS = 0
										BEGIN
										
											IF (@DealType = 'MOVIE')
												BEGIN
													--PRINT 'MOVIE Detected. No Episode Entry'
													SET @ColumnString = @ColumnString + @TableColumn + ', '
													SET @ValueString = @ValueString + '''' + @ColumnData + '''' + ', '
												END
											ELSE
												BEGIN
													--PRINT 'SHOW Detected. Entering Episode data'
													SET @ColumnString = @ColumnString + @TableColumn + ', '
													SET @ColumnData = (select REPLACE(@ColumnData, '''', ''''''))
													SET @ValueString = @ValueString + '''' + @ColumnData + '''' + ', '
													--PRINT @ColumnString
													--PRINT @ValueString
												END

											FETCH NEXT FROM curInsertQueryForTables
											INTO @TableName, @TableColumn, @ColumnData
										END

							CLOSE curInsertQueryForTables
							DEALLOCATE curInsertQueryForTables

							PRINT 'Set Column Value Strings'

							SET @ColumnString = (select substring(@ColumnString, 1, (len(@ColumnString) - 1)))
							SET @ValueString = (select substring(@ValueString, 1, (len(@ValueString) - 1)))

							PRINT 'INSERT INTO ' + @RefTableFromImport + ' (' + @ColumnString + ') VALUES (' + @ValueString + ')';
							--PRINT 'INSERT INTO #TempTitleContentTable (' + @ColumnString + ') VALUES (' + @ValueString + ')';
							EXEC ('INSERT INTO ' + @RefTableFromImport + ' (' + @ColumnString + ')
							OUTPUT INSERTED.Title_Content_Code, INSERTED.Title_Code, INSERTED.Episode_No, INSERTED.Duration, INSERTED.Episode_Title, INSERTED.Content_Status, INSERTED.Synopsis
							into #TempTitleContentTable(Title_Content_Code, Title_Code, Episode_No, Duration, Episode_Title, Content_Status, Synopsis)
							VALUES (' + @ValueString + ')');
							--EXEC ('INSERT INTO #TempTitleContentTable (' + @ColumnString + ') VALUES (' + @ValueString + ')');

							--SELECT 'Selecting Temp Title Content Table after inserting'
							--SELECT * FROM #TempTitleContentTable
							END
					END
					SET @CurrentExcelNum = @CurrentExcelNum + 1
				END
			
			INSERT INTO Title_Content_Version (Title_Content_Code, Version_Code, Duration) 
				select tc.Title_Content_Code, 1, tc.Duration from Title_Content tc inner join #TempTitleContentTable ttc on tc.Title_Code = ttc.Title_Code 
				AND tc.Episode_No = ttc.Episode_No 
				AND tc.Duration = ttc.Duration 
				AND tc.Episode_Title COLLATE SQL_Latin1_General_CP1_CI_AS = ttc.Episode_Title COLLATE SQL_Latin1_General_CP1_CI_AS
			
			INSERT INTO Title_Episode_Details (Title_Code, Episode_Nos, Remarks, Status) 
			OUTPUT INSERTED.Title_Episode_Detail_Code, INSERTED.Title_Code INTO #TitleEpisodeDetails(TitleEpisodeDetailsCode, TitleCode)
			SELECT Title_Code, COUNT(Title_Code), 'Episodes generated during Import', 'C' 
			FROM #TempTitleContentTable GROUP BY Title_Code
			
			INSERT INTO Title_Episode_Details_TC (Title_Episode_Detail_Code, Title_Content_Code)
			select ted.Title_Episode_Detail_Code, tc.Title_Content_Code from Title_Content tc inner join Title_Episode_Details ted on ted.Title_Code = tc.Title_Code 
			WHERE tc.Title_Code in (select tted.TitleCode from #TitleEpisodeDetails tted) AND ted.Title_Episode_Detail_Code in (select tted.TitleEpisodeDetailsCode from #TitleEpisodeDetails tted)
			
			END
			ELSE IF(@ImportTypeBasedOnColumns = 'M')
			BEGIN
				PRINT 'Movie Content Generation'
				
				DECLARE @MaxExcelSrNoMov INT
				DECLARE @MinExcelSrNoMov INT
				DECLARE @CurrentExcelNumMov INT
				DECLARE @ExcelIncrementMov INT = 1
				DECLARE @MovRefKey INT
				DECLARE @Duration DECIMAL (18, 2)
				DECLARE @TitleName VARCHAR(1000)
				DECLARE @TitleSynopsis VARCHAR(4000)

				SET @MaxExcelSrNoMov = (SELECT MAX(CAST(ExcelSrNo AS INT)) FROM #TempTitleUnPivot)
				SET @MinExcelSrNoMov = (SELECT MIN(CAST(ExcelSrNo AS INT)) FROM #TempTitleUnPivot)
				PRINT @MaxExcelSrNoMov
				PRINT @MinExcelSrNoMov

				SET @CurrentExcelNumMov = @MinExcelSrNoMov
				
				WHILE (@CurrentExcelNumMov <= @MaxExcelSrNoMov)
					BEGIN
						PRINT CAST(@CurrentExcelNumMov as NVARCHAR(100)) + ' = Current Excel No.'

						SET @MovRefKey = (SELECT RefKey FROM #TempTitleUnPivot tup WHERE tup.ExcelSrNo = @CurrentExcelNumMov AND tup.ColumnHeader = 'Title Name')
						PRINT @MovRefKey
					IF(@MovRefKey IS NOT NULL)
					BEGIN
						SET @Duration = (SELECT TitleData FROM #TempTitleUnPivot tup WHERE tup.ExcelSrNo = @CurrentExcelNumMov AND tup.ColumnHeader = 'Duration (in mins)')
						PRINT @Duration
						SET @TitleName = (SELECT TitleData FROM #TempTitleUnPivot tup WHERE tup.ExcelSrNo = @CurrentExcelNumMov AND tup.ColumnHeader = 'Title Name')
						PRINT @TitleName
						SET @TitleSynopsis = (SELECT TitleData FROM #TempTitleUnPivot tup WHERE tup.ExcelSrNo = @CurrentExcelNumMov AND tup.ColumnHeader = 'Synopsis')
						PRINT @TitleSynopsis

					IF EXISTS(select * from Title_Content where Title_Code = @MovRefKey and Episode_No = 1)
						BEGIN
							PRINT 'Content Update'
							UPDATE Title_Content SET Title_Code = @MovRefKey, Duration = @Duration, Synopsis = @TitleSynopsis WHERE Title_Code = @MovRefKey
						END
					ELSE
						BEGIN
						PRINT 'Content Insert'
						INSERT INTO Title_Content (Title_Code, Episode_No, Duration, Episode_Title, Content_Status, Synopsis) VALUES (@MovRefKey, '1', @Duration, @TitleName, 'P', @TitleSynopsis);

						INSERT INTO Title_Content_Version (Title_Content_Code, Version_Code, Duration) select tc.Title_Content_Code, 1, tc.Duration from Title_Content tc 
						where tc.Title_Code = @MovRefKey AND tc.Episode_No = 1 AND Episode_Title = @TitleName AND tc.Duration = @Duration

						INSERT INTO Title_Episode_Details (Title_Code, Episode_Nos, Remarks, Status) VALUES (@MovRefKey, 1, 'Content generated during Import for ' + @TitleName, 'C')
						END
					END
						SET @CurrentExcelNumMov = @CurrentExcelNumMov + @ExcelIncrementMov
					END

			END
		END

---------------------------------------------------------------------------------------- QUERY FOR EPISODE/PROGRAM ------------------------------------------------------------------------------------

					UPDATE DM_Title_Import_Utility_Data SET Record_Status = 'C', Error_Message = NULL WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status IS NULL
					AND  ISNUMERIC(Col1) = 1 AND Is_Ignore = 'N'

					UPDATE DM_Master_Import SET Status = 'S' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
				END
			END
			ELSE
			BEGIN 
				UPDATE DM_Master_Import SET Status = 'E' WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(Status,'') <> 'R'
			END
		END
		END TRY
		BEGIN CATCH
			PRINT 'Error'
			UPDATE DM_Master_Import SET Status = 'T' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

			UPDATE A SET  A.Error_Message = ISNULL(Error_Message,'')  + '~' + ERROR_MESSAGE()
			FROM DM_Title_Import_Utility_Data A WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%'
		END CATCH
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_Utility_PIII]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END

