CREATE PROCEDURE USP_Title_Import_Utility_PIII
(
	@DM_Master_Import_Code INT
)
AS 
BEGIN
	SET NOCOUNT ON
	--DECLARE @DM_Master_Import_Code INT = 15
	DECLARE @ISError CHAR(1) = 'N', @Error_Message NVARCHAR(MAX) = '', @ExcelCnt INT = 0

	IF(OBJECT_ID('tempdb..#TempTitle') IS NOT NULL) DROP TABLE #TempTitle
	IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
	IF(OBJECT_ID('tempdb..#TempExcelSrNo') IS NOT NULL) DROP TABLE #TempExcelSrNo
	IF(OBJECT_ID('tempdb..#TempHeaderWithMultiple') IS NOT NULL) DROP TABLE #TempHeaderWithMultiple
	IF(OBJECT_ID('tempdb..#TempTalent') IS NOT NULL) DROP TABLE #TempTalent
	IF(OBJECT_ID('tempdb..#TempExtentedMetaData') IS NOT NULL) DROP TABLE #TempExtentedMetaData
	IF(OBJECT_ID('tempdb..#TempResolveConflict') IS NOT NULL) DROP TABLE #TempResolveConflict
	IF(OBJECT_ID('tempdb..#TempDuplicateRows') IS NOT NULL) DROP TABLE #TempDuplicateRows
	
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
		ErrorMessage NVARCHAR(MAX)
	)

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

	BEGIN TRY

	UPDATE DM_Title_Import_Utility_Data SET Error_Message = NULL, Is_Ignore = 'N', Record_Status = NULL 
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Col1 NOT LIKE '%Sr%' 

	PRINT 'Inserting Data into #TempTitle'
	INSERT INTO #TempTitle (DM_Master_Import_Code, ExcelSrNo, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99)  
	SELECT DM_Master_Import_Code, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100  
	FROM DM_Title_Import_Utility_Data  
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code

	PRINT 'Fetching duplicate EXCEL Sr No'
	UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Duplicate EXCEL Sr. No. Found', Is_Ignore = 'Y' --A.Record_Status = 'E', 
	FROM DM_Title_Import_Utility_Data A
	WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
	AND A.Col1 COLLATE Latin1_General_CI_AI in (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DELETE FROM #TempTitle WHERE 
	ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DECLARE @Mandatory_message NVARCHAR(MAX)
	SELECT @Mandatory_message = STUFF(( SELECT ', ' + Display_Name +' is Mandatory Field' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		

	SELECT B.Col1 as ExcelSrNo
	INTO #TempDuplicateRows
	FROM DM_Title_Import_Utility_Data B
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND B.Col1 NOT LIKE '%Sr%'
	AND B.Col1 IN (
		SELECT A.ExcelSrNo FROM
		(
			SELECT Col1 AS ExcelSrNo , CONCAT(Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50, Col51, Col52, Col53, Col54, Col55, Col56, Col57, Col58, Col59, Col60, Col61, Col62, Col63, Col64, Col65, Col66, Col67, Col68, Col69, Col70, Col71, Col72, Col73, Col74, Col75, Col76, Col77, Col78, Col79, Col80, Col81, Col82, Col83, Col84, Col85, Col86, Col87, Col88, Col89, Col90, Col91, Col92, Col93, Col94, Col95, Col96, Col97, Col98, Col99, Col100) AS Concatenate
			FROM DM_Title_Import_Utility_Data  
			WHERE DM_Master_Import_Code =  @DM_Master_Import_Code
			AND Col1 NOT LIKE '%Sr%'
		) AS A WHERE A.Concatenate = ''
	)

	UPDATE B SET  B.Error_Message= ISNULL(B.Error_Message,'') + '~'+@Mandatory_message , B.Record_Status = 'E'
	FROM DM_Title_Import_Utility_Data B WHERE B.Col1 IN (SELECT ExcelSrNo FROM #TempDuplicateRows )

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

		UPDATE T1 SET T1.IsError = NULL, ErrorMessage = NULL FROM #TempTitleUnPivot T1
	END

	DECLARE @Display_Name NVARCHAR(MAX), @Reference_Table NVARCHAR(MAX), @Reference_Text_Field NVARCHAR(MAX), @Reference_Value_Field NVARCHAR(MAX)
	, @Reference_Whr_Criteria NVARCHAR(MAX),  @Control_Type NVARCHAR(MAX), @Is_Allowed_For_Resolve_Conflict CHAR(1), @ShortName NVARCHAR(MAX),
	@Target_Column NVARCHAR(MAX)

	BEGIN
		PRINT 'Duplication'

		DECLARE db_cursor_Duplication CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%dup%'

		OPEN db_cursor_Duplication  
		FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
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

	BEGIN
		PRINT 'Check INT Column'
		DECLARE db_cursor_Int CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND Colum_Type = 'INT'

		OPEN db_cursor_Int  
		FETCH NEXT FROM db_cursor_Int INTO @Display_Name 

		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Not Numeric'
			WHERE  ColumnHeader = @Display_Name AND ISNUMERIC(TitleData) <> 1

			IF ('YEAR OF RELEASE' = UPPER(@Display_Name))
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND ISNUMERIC(TitleData) = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1950 AND 9999
			
			
			FETCH NEXT FROM db_cursor_Int INTO @Display_Name 
		END 

		CLOSE db_cursor_Int  
		DEALLOCATE db_cursor_Int 
	END
	
	BEGIN
		PRINT 'Mandatory Validation'

		DECLARE db_cursor_Mandatory CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%'

		OPEN db_cursor_Mandatory  
		FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			 IF((SELECT COUNT(DISTINCT ExcelSrNo) FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name) < 2) --@ExcelCnt
				BEGIN
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Mandatory Field'
					WHERE ExcelSrNo NOT IN ( SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name)
				END
			  FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name 
		END 

		CLOSE db_cursor_Mandatory  
		DEALLOCATE db_cursor_Mandatory 
	END

	BEGIN
		PRINT 'Deleting IsError = Y and updating record status amd error message AND deleting existing title'

		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + 'Title Name Already Existed'--, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		WHERE A.DM_Master_Import_Code =  @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%' and A.Col1 COLLATE Latin1_General_CI_AI IN 
		(
			SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name'
			AND TitleData COLLATE Latin1_General_CI_AI IN (SELECT Title_Name FROM Title)
		)

		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + B.ErrorMessage --, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		INNER JOIN (
			SELECT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y' GROUP BY ExcelSrNo, ErrorMessage
		) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
		WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%'

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo IN
		(
			SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name'
			AND TitleData COLLATE Latin1_General_CI_AI IN (SELECT Title_Name FROM Title)
		)

		DELETE FROM #TempTitleUnPivot WHERE IsError = 'Y'
	END
	
	BEGIN
		PRINT 'Referene check not available where Is_Multiple = ''N'''

		DECLARE db_cursor_Reference CURSOR FOR 
		SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'N'

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
				END
				
				IF(@Is_Allowed_For_Resolve_Conflict = 'N')
					UPDATE A SET A.IsError = 'Y', A.ErrorMessage = ISNULL(A.ErrorMessage, '') + '~' + @Display_Name +' Not Available~'
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
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'Y'

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
			WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName

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
		FROM DM_Title_Import_Utility WHERE Reference_Table = 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y'

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
				inner join Role R ON R.Role_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
				CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
				WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''

				UPDATE A SET A.TalentCode = B.Master_Code FROM #TempTalent A
				INNER JOIN DM_Master_Log B ON A.TalentName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND Roles = @Display_Name

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
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'N'
	
		OPEN db_cursor_EMD_Reference  
		FETCH NEXT FROM db_cursor_EMD_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
											 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
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
					END

					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available~' 
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
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'Y'

		OPEN db_cursor_EMDY_Reference  
		FETCH NEXT FROM db_cursor_EMDY_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
		
				IF (@Control_Type = 'DDL')
				BEGIN
					INSERT INTO #TempExtentedMetaData (ExcelSrNo, Columns_Code, HeaderName, EMDName)
					SELECT DISTINCT ExcelSrNo, EC.Columns_Code, upvot.ColumnHeader, LTRIM(RTRIM(f.Number))
					FROM #TempTitleUnPivot upvot
						INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
						CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
					WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''
					
					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
						UPDATE A SET A.EMDCode = B.Master_Code FROM #TempExtentedMetaData A
						INNER JOIN DM_Master_Log B ON A.EMDName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
						WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName

					UPDATE A SET A.EMDCode= ECV.Columns_Value_Code  FROM #TempExtentedMetaData A
					INNER JOIN Extended_Columns_Value ECV 
					ON ECV.Columns_Value COLLATE Latin1_General_CI_AI = A.EMDName COLLATE Latin1_General_CI_AI AND ECV.Columns_Code = A.Columns_Code 

					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available~' 
						WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempExtentedMetaData WHERE EMDCode is null AND HeaderName = @Display_Name )
				END
				FETCH NEXT FROM db_cursor_EMDY_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_EMDY_Reference  
		DEALLOCATE db_cursor_EMDY_Reference 
	END

	BEGIN
		PRINT 'Resolve Conflict'
		
		DELETE FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code and Master_Code IS NULL AND Is_Ignore = 'N'
		--UPDATE DM_Title_Import_Utility_Data SET Record_Status = NULL WHERE Record_Status = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code

		INSERT INTO #TempResolveConflict ([Name], Master_Type, Roles)
		SELECT DISTINCT A.[Name], A.Master_Type, A.Roles FROM (
				SELECT A.TitleData AS Name ,B.ShortName AS Master_Type ,'' AS Roles FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD
				SELECT A.PropName AS Name ,B.ShortName AS Master_Type,'' AS Roles
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD
				SELECT A.TitleData AS Name,B.ShortName AS Master_Type,''AS Roles
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD EXTENDED META DATA
				SELECT A.EMDName AS Name, B.ShortName AS Master_Type ,''AS Roles
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD EXTENDED META DATA
				SELECT A.TalentName AS Name, B.ShortName AS Master_Type, R.Role_Name AS Roles
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			--TITLE PROPERTIES WITH TALENT
		) AS A

		UPDATE A SET  A.Master_Code = B.Master_Code, A.Mapped_By = 'S' 
		FROM #TempResolveConflict A
		INNER JOIN DM_Master_Log B ON B.Name COLLATE Latin1_General_CI_AI = A.Name AND A.Master_Type COLLATE Latin1_General_CI_AI = B.Master_Type
		WHERE B.DM_Master_Log_Code IN ( SELECT  MAX(DM_Master_Log_Code) AS DM_Master_Log_Code FROM DM_Master_Log GROUP BY Name)

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
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION  
				SELECT A.ExcelSrNo
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			) AS A )

			IF EXISTS(SELECT TOP 1 * FROM DM_Title_Import_Utility_Data WHERE ISNULL(Record_Status,'') = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code )
				UPDATE DM_Master_Import SET Status = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
			
			INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By)
			SELECT @DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles,'N',Mapped_By FROM #TempResolveConflict
		END
	END

	BEGIN
		PRINT 'if error which cannot be resolved '
		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE IsError = 'Y') 
		BEGIN

			UPDATE A SET A.Error_Message =ISNULL(A.Error_Message,'') + B.ErrorMessage, Record_Status = 'E'
			FROM DM_Title_Import_Utility_Data A
			INNER JOIN 
			(SELECT DISTINCT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y') as B on B.ExcelSrNo = A.Col1 COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' 
			
		END
	
		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE ISNULL(IsError,'') <> 'Y')
		BEGIN
			IF NOT EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
			BEGIN	
				DECLARE @cols_DisplayName AS NVARCHAR(MAX), @cols_TargetColumn AS NVARCHAR(MAX), @query AS NVARCHAR(MAX)
				UPDATE #TempTitleUnPivot SET IsError = '' WHERE IsError IS NULL

				-----------Title COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',[' + Display_Name +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',[' + Target_Column +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				
				EXEC ('
				INSERT INTO Title ( Is_Active, '+@cols_TargetColumn+')
				SELECT ''Y'', '+@cols_DisplayName+' FROM (SELECT ExcelSrNo, ColumnHeader, 
				CASE WHEN RefKey IS NULL THEN TitleData ELSE RefKey END
				TitleData FROM #TempTitleUnPivot WHERE ISError <> ''Y'') AS Tbl PIVOT( MAX(TitleData) FOR ColumnHeader IN ('+@cols_DisplayName+')) AS Pvt ')
			
				UPDATE A SET A.RefKey = B.Title_Code 
				FROM #TempTitleUnPivot A
				INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
				WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y'

				UPDATE B SET B.TitleCode = A.RefKey FROM  #TempTitleUnPivot A
				INNER JOIN #TempHeaderWithMultiple B ON A.ExcelSrNo = B.ExcelSrNo
				WHERE A.ColumnHeader = 'Title Name'  AND A.ISError <> 'Y'

				-----------Title_Country COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				EXEC ('
				INSERT INTO Title_Country (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE 
				HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Country'')
				')
				-----------Title_Geners COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')	
				EXEC ('
				INSERT INTO Title_Geners (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Geners'')
				')

				-----------Title_Talent COLUMN--------------------
				EXEC ('
				INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_Code)
				SELECT B.RefKey, A.TalentCode, A.RoleCode FROM #TempTalent A
				INNER JOIN #TempTitleUnPivot B ON B.ExcelSrNo = A.ExcelSrNo
				WHERE B.ColumnHeader = ''Title Name'' AND  A.TalentCode IS NOT NULL AND B.ISError <> ''Y''
				')

				-----------EXTENDED COLUMN IS Multiple = N With DDL AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.RefKey, 'N' 
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'DDL' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
					AND A.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = N With TXT AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Column_Value, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.TitleData, 'N'  
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'TXT' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y' 
					AND A.ISError <> 'Y'
	
				-----------EXTENDED COLUMN IS Multiple = Y AND Map_Extended_Column --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					 AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)	
				SELECT MEC.Map_Extended_Columns_Code, A.EMDCode
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = A.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'  
					AND AA.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = Y IN TALENT --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column_Values' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)
				SELECT MEC.Map_Extended_Columns_Code, A.TalentCode
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN extended_columns EC ON EC.Columns_Name = A.HeaderName COLLATE Latin1_General_CI_AI
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = EC.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
				
				UPDATE DM_Title_Import_Utility_Data SET Record_Status = 'C', Error_Message = NULL WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status IS NULL AND  ISNUMERIC(Col1) = 1 
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
		UPDATE DM_Master_Import SET Status = 'T' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE A SET  A.Error_Message = ISNULL(Error_Message,'')  + '~' + ERROR_MESSAGE()
		FROM DM_Title_Import_Utility_Data A WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
	END CATCH
END

