DROP PROC USP_Get_ResolveConflict_Data
GO

CREATE TABLE [dbo].[DM_Title_Resolve_Conflict] (
    [DM_Title_Resolve_Conflict_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Tab_Name]                       NVARCHAR (MAX) NULL,
    [Master_Type]                    NVARCHAR (MAX) NULL,
    [Roles]                          CHAR (1)       NULL,
    [Create_New]                     CHAR (1)       NULL,
    [Order_No]                       INT            NULL,
    PRIMARY KEY CLUSTERED ([DM_Title_Resolve_Conflict_Code] ASC)
);
GO

CREATE PROCEDURE USP_Title_Import_RCData(
	@Keyword NVARCHAR(MAX),
	@TabName NVARCHAR(MAX),
	@Roles NVARCHAR(MAX)
)
AS
BEGIN
	--DECLARE @Keyword NVARCHAR(MAX)='jai',
	--		@TabName NVARCHAR(MAX)='TA',
	--		@Roles NVARCHAR(MAX)='Star Cast'

	DECLARE @Reference_Table		NVARCHAR(MAX),
			@Reference_Text_Field	NVARCHAR(MAX),
			@Reference_Value_Field	NVARCHAR(MAX),
			@Reference_Whr_Criteria NVARCHAR(MAX)

	SELECT  @Reference_Table = Reference_Table,
			@Reference_Text_Field = Reference_Text_Field, 
			@Reference_Value_Field = Reference_Value_Field,
			@Reference_Whr_Criteria = Reference_Whr_Criteria
	FROM DM_Title_Import_Utility WHERE ShortName = @TabName and Is_Active='Y' AND Is_allowed_For_Resolve_Conflict='Y' 
		AND (Display_Name = @Roles OR ISNULL(@Roles,'') = '' )

	EXEC ('
			SELECT CAST (' + @Reference_Value_Field +' AS NVARCHAR(MAX)) ValueField, '+@Reference_Text_Field+' TextField
			FROM '+@Reference_Table+' WHERE
			'+@Reference_Text_Field+' LIKE ''%'+@Keyword+'%''
			'+@Reference_Whr_Criteria+' ORDER BY 2 
		')
END
GO

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
GO

ALTER PROCEDURE [dbo].[USP_Acq_Deal_Ancillary_Adv_Report]  
(  
	@Agreement_No VARCHAR(MAX),  
	@Title_Codes VARCHAR(MAX),  
	@Platform_Codes VARCHAR(MAX),  
	@Ancillary_Type_Code VARCHAR(MAX),  
	@Business_Unit_Code INT,  
	@IncludeExpired VARCHAR(MAX)  
)  
AS  
 --=============================================  
 --Author:  Akshay Rane  
 --Create DATE: 16-April-2018  
 --Description: Show Platform wise Ancillary Advance report  
 --=============================================  
BEGIN  
  
 --DECLARE  
 --@Agreement_No VARCHAR(MAX),  
 --@Title_Codes VARCHAR(MAX),  
 --@Platform_Codes VARCHAR(MAX),  
 --@Ancillary_Type_Code VARCHAR(MAX),  
 --@Business_Unit_Code INT,  
 --@IncludeExpired VARCHAR(MAX)  
  
 --SELECT  
 --@Agreement_No = '',  
 --@Title_Codes = '2138, 7511', --'545',  
 --@Platform_Codes = '',--'0,1,0,3,4,0,6,7,0,0,328,329,330,331,338,339,0,341,342,343,344,345,346,347,348,349,350,351,0,332,333,334,335,352,353,0,355,356,357,358,359,360,361,362,363,364,365,0,0,366,367,0,369,370,371,372,373,374,375,376,377,378,379,0,380,381,0,383,384,385,386,387,388,389,390,391,392,393,0,0,16,17,0,20,21,0,22,23,251,24,29,181,0,252,253,254,255,0,32,33,34,0,0,0,60,258,61,62,259,63,64,65,66,67,69,0,71,72,73,0,262,263,75,76,0,145,146,265,78,79,147,152,154,0,0,38,256,39,40,257,41,42,43,44,45,47,0,49,50,51,0,260,261,53,54,0,149,150,264,56,57,151,155,157,0,0,268,269,270,271,272,273,274,275,276,277,278,0,280,281,282,0,284,285,286,287,0,291,292,293,288,289,294,295,296,0,0,299,300,301,302,303,304,305,306,307,308,309,0,311,312,313,0,315,316,317,318,0,322,323,324,319,320,325,326,327,0,0,111,112,113,182,183,184,0,114,115,116,185,186,187,0,0,173,174,175,200,201,202,0,0,120,121,122,188,189,190,0,227,228,229,230,231,232,0,123,124,125,191,192,193,0,0,165,163,167,197,195,199,0,162,166,164,194,198,196,0,213,215,214,216,218,217,0,220,222,221,223,225,224,226,0,127,128,0,336,337,130,0,248,249,250,0,132,133,134,135,0,138,139,140,141,0,234,235,236,143,0,238,239,240,241,170,0,242,243,244,180,0,207,208,209,210,0,246,247,394',  
 --@Ancillary_Type_Code = '' ,  
 --@Business_Unit_Code = 1,  
 --@IncludeExpired = 'N'  
  
  
 IF(OBJECT_ID('tempdb..#GetDealTypeCondition') IS NOT NULL) DROP TABLE #GetDealTypeCondition  
 IF(OBJECT_ID('tempdb..#AncillaryTypeCode') IS NOT NULL) DROP TABLE #AncillaryTypeCode  
 IF(OBJECT_ID('tempdb..#PlatformCode') IS NOT NULL) DROP TABLE #PlatformCode  
 IF(OBJECT_ID('tempdb..#Tmp_AcqDeal') IS NOT NULL) DROP TABLE #Tmp_AcqDeal  
 IF(OBJECT_ID('tempdb..#Tmp_Report') IS NOT NULL) DROP TABLE #Tmp_Report

   
 DECLARE @Acq_Deal_Code int  = 0  
 DECLARE @Ancillary_Deal TABLE( Acq_Deal_Ancillary_Code INT, Title_Code INT)  
  
 create table #GetDealTypeCondition(  
  DealType VARCHAR(MAX),  
  Deal_Type_Code INT  
 )  
  
 CREATE TABLE #AncillaryTypeCode  
 (  
  Ancillary_Type_Code INT  
 )  
  
 CREATE TABLE #PlatformCode  
 (  
  Platform_Code INT  
 )  
  
 IF(@Title_Codes = '0')  
 BEGIN  
  SET @Title_Codes = ''  
 END  
  
 IF(@Platform_Codes = '0')  
 BEGIN  
  SET @Platform_Codes = ''  
 END  
  
 IF(@Ancillary_Type_Code = '0')  
 BEGIN  
  SET @Ancillary_Type_Code = ''  
 END  
  
 INSERT INTO #AncillaryTypeCode  
 SELECT number FROM fn_Split_withdelemiter(@Ancillary_Type_Code, ',')  
  
 INSERT INTO #PlatformCode  
 SELECT number FROM fn_Split_withdelemiter(@Platform_Codes, ',')  
  
 IF (@Agreement_No <> '' AND @Title_Codes = '') -- Agreement No = A-2018-00129 /  Title Codes = ''  
 BEGIN  
  PRINT 'STEP 1 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  SELECT @Acq_Deal_Code = Acq_Deal_Code FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No = @Agreement_No AND Business_Unit_Code = @Business_Unit_Code  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)  
  SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary WHERE Acq_deal_Code = @Acq_Deal_Code   
 END  
 ELSE IF (@Title_Codes <> '' AND @Agreement_No = '') --  Agreement No = '' /  Title Codes = '12,13,14,5'  
 BEGIN  
  PRINT 'STEP 2 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code, Title_Code)  
  SELECT ADAT.Acq_Deal_Ancillary_Code, ADAT.Title_Code FROM Acq_Deal_Ancillary_title ADAT   
  INNER JOIN Acq_Deal_Ancillary ADA ON ADA.Acq_Deal_Ancillary_Code = ADAT.Acq_Deal_Ancillary_Code  
  INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADA.Acq_Deal_Code AND Business_Unit_Code = @Business_Unit_Code  
  WHERE ADAT.Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))  
 END  
 ELSE IF (@Title_Codes = '' AND @AGREEMENT_NO = '') -- Agreement No = '' / Title Codes = ''  
 BEGIN  
  PRINT 'STEP 3 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  DECLARE @AcqDeal TABLE ( Acq_Deal_Code INT)  
  
  INSERT INTO @AcqDeal (Acq_Deal_Code)  
  SELECT  Acq_Deal_Code  FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Business_Unit_Code = @Business_Unit_Code  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)  
  SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary WHERE Acq_deal_Code IN (SELECT Acq_Deal_Code FROM @AcqDeal)  
 END  
 ELSE IF (@Title_Codes <> '' AND @Agreement_No <> '') -- Agreement No = A-2018-00129 / Title Codes = '12,13,14,5'  
 BEGIN  
  PRINT 'STEP 4 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes  
  
  SELECT @Acq_Deal_Code = Acq_Deal_Code FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No = @Agreement_No AND Business_Unit_Code = @Business_Unit_Code  
  
  INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code, Title_Code)  
  SELECT ADT.Acq_Deal_Ancillary_Code, ADT.Title_Code FROM Acq_Deal_Ancillary ADA  
  INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code  
  WHERE ADA.Acq_deal_Code = @Acq_Deal_Code AND   
  ADT.Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))  
 END  
  
 INSERT INTO #GetDealTypeCondition(Deal_Type_Code)  
 SELECT DISTINCT ad.Deal_Type_Code  
 FROM Acq_Deal_Ancillary ada  
 INNER JOIN Acq_Deal ad ON ada.Acq_Deal_Code = ad.Acq_Deal_Code  
 WHERE Business_Unit_Code = @Business_Unit_Code  
  
 UPDATE #GetDealTypeCondition SET DealType = DBO.UFN_GetDealTypeCondition(Deal_Type_Code)  
  
 CREATE TABLE #Tmp_AcqDeal  
 (  
  Agreement_No NVARCHAR(MAX),  
  Acq_Deal_Code INT,  
  Title_Code INT,  
  Deal_Type_Code INT  
 ) 
  CREATE TABLE #Tmp_Report  
 (  
  Agreement_No NVARCHAR(MAX),  
  Acq_Deal_Code INT,  
  Title_Code INT,  
  Deal_Type_Code INT,
  Title_Name VARCHAR(MAX),
  Title_Type VARCHAR(MAX),
  Ancillary_Type_Name VARCHAR(MAX),
  Duration VARCHAR(MAX),
  Day VARCHAR(MAX),
  Remarks VARCHAR(MAX),
  Platform_Hiearachy VARCHAR(MAX),
  Platform_Code INT,
  Available VARCHAR(MAX)
 ) 
 
 INSERT INTO #Tmp_AcqDeal(Agreement_No, Acq_Deal_Code, Title_Code, Deal_Type_Code)  
 SELECT AD.Agreement_No, AD.Acq_Deal_Code, adrt.Title_Code, AD.Deal_Type_Code  
 FROM Acq_Deal AD   
  INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code   
  INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code  
  INNER JOIN #GetDealTypeCondition GDTC ON AD.Deal_Type_Code = GDTC.Deal_Type_Code  
 WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')  
  AND AD.Business_Unit_Code = @Business_Unit_Code  
  AND (ADR.Actual_Right_Start_Date IS NOT NULL AND ISNULL(ADR.Actual_Right_End_Date, '31DEC9999') >= GETDATE() OR @IncludeExpired = 'Y')  
  AND ( @Title_Codes = '' OR (ADRT.Title_Code  IN (SELECT Title_Code FROM @Ancillary_Deal)))  
   
  INSERT INTO #Tmp_Report
 SELECT DISTINCT  
  AD.*,  
  DBO.UFN_GetTitleNameInFormat(GDTC.DealType,   
  T.Title_Name, ADT.Episode_From, ADT.Episode_To) AS Title_Name,  
  CASE GDTC.DealType WHEN 'DEAL_MOVIE' THEN 'Movie' WHEN 'DEAL_PROGRAM' THEN 'Program' END  AS Title_Type,  
  AT.Ancillary_Type_Name,  
  ISNULL(CAST(ADA.Duration AS VARCHAR(MAX)),'') AS Duration,  
  ISNULL(CAST(ADA.Day AS VARCHAR(MAX)),'')  AS Day,  
  ADA.Remarks,  
  P.Platform_Hiearachy,  
  P.Platform_Code,  
  'YES' Available  
 FROM Acq_Deal_Ancillary ADA   
  INNER JOIN @Ancillary_Deal ADN ON ADN.Acq_Deal_Ancillary_Code =  ADA.Acq_Deal_Ancillary_Code  
  INNER JOIN #Tmp_AcqDeal AD ON ADA.Acq_Deal_Code = AD.Acq_Deal_Code  
  INNER JOIN Acq_Deal_Ancillary_Platform ADP ON ADA.Acq_Deal_Ancillary_Code = ADP.Acq_Deal_Ancillary_Code  
  INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Title_Code = AD.Title_Code  
  INNER JOIN Platform P On P.Platform_Code = ADP.Platform_Code  
  INNER JOIN Title T On ADT.Title_Code = T.Title_Code  
  INNER JOIN Ancillary_Type AT ON AT.Ancillary_Type_Code = ADA.Ancillary_Type_Code  
  INNER JOIN #GetDealTypeCondition GDTC ON AD.Deal_Type_Code = GDTC.Deal_Type_Code  
  WHERE   
  (@Ancillary_Type_Code  = '' OR (ADA.Ancillary_Type_code IN (SELECT DISTINCT Ancillary_Type_code FROM #AncillaryTypeCode) AND @Ancillary_Type_Code <> ''))  
  AND (@Platform_Codes  = '' OR (P.Platform_Code IN (SELECT DISTINCT Platform_Code FROM #PlatformCode )AND @Platform_Codes <> ''))  

  --SELECT * FROM #Tmp_Report

		DECLARE @TableColumns VARCHAR(MAX) = '',@CurDisplayName NVARCHAR(100) = ''
		SELECT @CurDisplayName = ''

		DECLARE CUR_SaleAncillary CURSOR FOR SELECT DISTINCT Platform_Hiearachy FROM #Tmp_Report 
		OPEN CUR_SaleAncillary
		FETCH FROM CUR_SaleAncillary INTO @CurDisplayName
		WHILE(@@FETCH_STATUS = 0)
		BEGIN

			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + '[' + @CurDisplayName +']'

			FETCH FROM CUR_SaleAncillary INTO @CurDisplayName
		END
		CLOSE CUR_SaleAncillary
		DEALLOCATE CUR_SaleAncillary

	--	PRINT  ('SELECT [Agreement_No],[Title_Name],[Title_Type],[Ancillary_Type_Name],[Duration],[Day],[Remarks] ,'+ @TableColumns +' FROM   
	--(SELECT [Agreement_No],[Title_Name],[Title_Type],[Ancillary_Type_Name],[Duration],[Day],[Remarks],[Platform_Hiearachy]-- CASE WHEN [Platform_Hiearachy] = 0 THEN ''Y'' ELSE ''N'' END Platform_Hiearachy
	--FROM #Tmp_Report)Tab1  
	--PIVOT  
	--(  
	--Count([Platform_Hiearachy])
	--FOR Platform_Hiearachy IN (' +@TableColumns+')) AS Tab2 ')
	
	--SELECT * FROM #Tmp_Report
	DECLARE @COUNT INT

	SELECT @COUNT = COUNT(*) FROM #Tmp_Report

	IF(@COUNT > 0)
	BEGIN
		EXEC ('SELECT [Agreement_No],[Title_Name] AS [Title],[Title_Type],[Ancillary_Type_Name] AS [Ancillary_Type],[Duration] AS [Duration(Sec)],[Day] AS [Period(Day)],[Remarks] ,'+ @TableColumns +' FROM   
		(SELECT [Agreement_No],[Title_Name],[Title_Type],[Ancillary_Type_Name],[Duration], [Day],[Remarks],[Platform_Hiearachy]
		FROM #Tmp_Report)Tab1  
		PIVOT  
		(  
		MAX([Platform_Hiearachy])
		FOR Platform_Hiearachy IN (' +@TableColumns+')) AS Tab2') 
	END
	ELSE
	BEGIN
		SELECT * FROM #Tmp_Report
	END 
	--Select * from #temp
    --SELECT * FROM #Tmp_Report
  
  IF(OBJECT_ID('tempdb..#GetDealTypeCondition') IS NOT NULL) DROP TABLE #GetDealTypeCondition  
  IF(OBJECT_ID('tempdb..#AncillaryTypeCode') IS NOT NULL) DROP TABLE #AncillaryTypeCode  
  IF(OBJECT_ID('tempdb..#PlatformCode') IS NOT NULL) DROP TABLE #PlatformCode  
  IF(OBJECT_ID('tempdb..#Tmp_AcqDeal') IS NOT NULL) DROP TABLE #Tmp_AcqDeal  
  IF(OBJECT_ID('tempdb..#Tmp_Report') IS NOT NULL) DROP TABLE #Tmp_Report

END
GO

ALTER PROCEDURE [dbo].[USP_Content_Music_PIV]        
 @DM_Master_Import_Code VARCHAR(500),        
 @User_Code INT=143        
AS    
 --declare @DM_Master_Import_Code VARCHAR(500) = 6179,  
 --@User_Code INT = 143  
         
BEGIN        
  
 --"CM" id content Music DM_Master_Log table  
 CREATE TABLE #Temp_Import        
 (        
 -- Temp Import Data        
  ID INT IDENTITY(1,1),        
  DM_Master_Import_Code VARCHAR(500),        
  Name NVARCHAR(4000),        
  Master_Type VARCHAR(100),        
  Action_By INT,        
  Action_On DATETIME,        
  Roles VARCHAR(100),      
  --DM_Master_Log_Code INT,  
  Master_Code INT,  
  Mapped_By CHAR(1)  
 )        
 -- Director Data        
 CREATE TABLE #Temp_Music        
 (         
  Name NVARCHAR(4000),        
  MusicTitleCode INT,        
  RoleExists CHAR(1)        
 )    
  
 INSERT INTO #Temp_Music(Name, RoleExists)        
   SELECT DISTINCT a.Music_Track_Name, 'N' FROM        
   (        
    SELECT [Music_Track] Music_Track_Name FROM DM_Content_Music WHERE ISNULL([Music_Track], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'       
   ) AS a    
   
 INSERT INTO #Temp_Import(DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Master_Code)      
 SELECT  @DM_Master_Import_Code, DMNAME, DMMASTER_TYPE, @User_Code, GETDATE(), NULL From (   
  SELECT LTRIM(RTRIM(Name)) As DMNAME, 'CM' As DMMASTER_TYPE FROM #Temp_Music      
  WHERE Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (      
  SELECT Music_Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Title      
  )  ) As a      
  --Left Join DM_Master_Log DM ON a.DMNAME collate SQL_Latin1_General_CP1_CI_AS = DM.Name collate SQL_Latin1_General_CP1_CI_AS AND      
  --a.DMMASTER_TYPE collate SQL_Latin1_General_CP1_CI_AS = DM.Master_Type  collate SQL_Latin1_General_CP1_CI_AS    
  --where ISNULL(DM.Master_Code,0)=0    
  
 IF NOT EXISTS (SELECT TOP 1 DM_Master_Import_Code  From DM_Master_Log  where DM_Master_Import_Code = @DM_Master_Import_Code)  
 BEGIN  
  INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Action_By, Action_On, Roles,Is_Ignore,Mapped_By)        
  SELECT  @DM_Master_Import_Code , Name, Master_Type, Action_By, Action_On, null,'N','U'  FROM #Temp_Import    
 END  
  
  
 UPDATE T set T.Master_Code = DM.Master_Code,T.Mapped_By = CASE WHEN DM.Master_Code != 0 THEN 'S' ELSE 'U'END  
 FROM #Temp_Import T  
 INNER JOIN DM_Master_Log DM ON DM.Name  COLLATE SQL_Latin1_General_CP1_CI_AS = T.Name COLLATE SQL_Latin1_General_CP1_CI_AS  
 AND DM.Master_Type = 'CM' AND DM.Is_Ignore = 'N'  
   
  
 UPDATE D SET D.Master_Code = T.Master_Code,D.Mapped_By = T.Mapped_By  
 FROM DM_Master_Log D  
 INNER JOIN #Temp_Import T ON T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = D.Name COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Master_Type = 'CM'  
 WHERE ISNULL(D.Master_Code,0)=0 AND D.DM_Master_Import_Code = @DM_Master_Import_Code  
  
  DECLARE @MusicCount INT = 0 ,@SystemMappingCount INT=0       
  SELECT @MusicCount = COUNT(*) FROM #Temp_Import    
   SELECT @SystemMappingCount = COUNT(*) FROM #Temp_Import  
  IF (@MusicCount > 0)        
  BEGIN        
   SELECT @MusicCount = COUNT(*) FROM DM_Master_Log Where DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND ISNULL(Master_Code, 0) = 0        
  END        
  IF (@SystemMappingCount > 0)        
  BEGIN        
   SELECT @SystemMappingCount = COUNT(*) FROM DM_Master_Log Where DM_Master_Import_Code LIKE '%' + @DM_Master_Import_Code + '%' AND Master_Code != 0        
  END   
  IF (@MusicCount > 0)        
  BEGIN    
  declare @status Varchar(2)  
  select @status = status from DM_Master_Import  where DM_Master_Import_Code = @DM_Master_Import_Code  
  if(@status != 'I' )  
  Begin   
   UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
   END    
   UPDATE D set D.Record_Status = Case When D.Record_Status IN('OR','MO') THEn 'MO' Else 'MR'END   
   FROM DM_Content_Music D  INNER JOIN DM_Master_Log T ON T.DM_Master_Import_Code = @DM_Master_Import_Code  
   WHERE T.Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Is_Ignore != 'Y' AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(T.Master_Code, 0) = 0 AND T.Mapped_By = 'U'  
   
  END      
  ELSE      
  BEGIN        
   IF EXISTS (SELECT Status FROM  DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Status = 'R')  
   BEGIN  
   UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code   
   END  
   --Else  
   --BEGIN  
   --UPDATE DM_Master_Import SET [Status] = 'P' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
   --END  
  --IF EXISTS (select Status from  DM_Master_Import where DM_Master_Import_Code = @DM_Master_Import_Code AND Status != 'R')  
  --BEGIN  
  -- UPDATE DM_Master_Import Set [Status] = 'P' Where DM_Master_Import_Code = @DM_Master_Import_Code         
  -- END  
  -- Else  
  --  UPDATE DM_Master_Import Set [Status] = 'R' Where DM_Master_Import_Code = @DM_Master_Import_Code      
  END      
   
     IF (@SystemMappingCount > 0)        
  BEGIN       
   
  declare @SystemMAppingstatus Varchar(2)  
  select @SystemMAppingstatus = status from DM_Master_Import  where DM_Master_Import_Code = @DM_Master_Import_Code  
  
  if(@SystemMAppingstatus != 'I' )  
  Begin   
   UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code      
   END  
   UPDATE D set D.Record_Status = Case When D.Record_Status IN('OR','SO') THEn 'SO' Else 'SM'END   
   FROM DM_Content_Music D  INNER JOIN DM_Master_Log T ON T.DM_Master_Import_Code = @DM_Master_Import_Code  
   WHERE T.Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  COLLATE SQL_Latin1_General_CP1_CI_AS AND D.Is_Ignore != 'Y' AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND T.Master_Code != 0  AND T.Mapped_By = 'S'  
   
  END      
  ELSE      
  BEGIN     
       
   IF EXISTS (SELECT Status FROM  DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Status = 'R')  
   BEGIN  
   UPDATE DM_Master_Import SET [Status] = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code   
   END  
   --Else  
   --BEGIN  
   --UPDATE DM_Master_Import SET [Status] = 'P' WHERE DM_Master_Import_Code = @DM_Master_Import_Code    
   --END  
  --IF EXISTS (select Status from  DM_Master_Import where DM_Master_Import_Code = @DM_Master_Import_Code AND Status != 'R')  
  --BEGIN  
  -- UPDATE DM_Master_Import Set [Status] = 'P' Where DM_Master_Import_Code = @DM_Master_Import_Code         
  -- END  
  -- Else  
  --  UPDATE DM_Master_Import Set [Status] = 'R' Where DM_Master_Import_Code = @DM_Master_Import_Code      
  END  
--DROP TABLE #Temp_Music     
--DROP TABLE #Temp_Import     
	IF OBJECT_ID('tempdb..#Temp_Import') IS NOT NULL DROP TABLE #Temp_Import
	IF OBJECT_ID('tempdb..#Temp_Music') IS NOT NULL DROP TABLE #Temp_Music
END
GO

ALTER PROCEDURE [dbo].[USP_DM_Title_PII]
	@DM_Import_UDT DM_Import_UDT READONLY,
	@DM_Master_Import_Code Int,
	@Users_Code Int
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @DM_Master_Import_Code INT = 115,@Users_Code Int = 143
	--DECLARE @DM_Import_UDT DM_Import_UDT
	--INSERT INTO @DM_Import_UDT(
	--	[Key],[value], [DM_Master_Type]
	--)
	--VALUES
	--	(5526,13,'PC')
	IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL
		DROP TABLE #Temp_DM

	IF OBJECT_ID('TEMPDB..#Temp_DM_Title') IS NOT NULL
		DROP TABLE #Temp_DM_Title

	IF OBJECT_ID('TEMPDB..#Temp_DM_Title_Ignore') IS NOT NULL
		DROP TABLE #Temp_DM_Title_Ignore

	IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL
		DROP TABLE #Temp_Talent_Role


	CREATE TABLE #Temp_DM
	(
		Master_Name NVarchar(2000),
		DM_Master_Log_Code BIGINT,
		DM_Master_Code NVARCHAR (100),
		Master_Type NVARCHAR (100),
		Is_New CHAR(1)
	)

	CREATE TABLE #Temp_DM_Title
	(
		DM_Title_Code INT,
		IsMusicDirectorValid CHAR(1) DEFAULT('Y'),
		IsStarCastValid CHAR(1) DEFAULT('Y'),
		IsMusicLabelValid CHAR(1) DEFAULT('Y'),
		IsTitleTypeValid CHAR(1) DEFAULT('Y'),
		IsTitleLanguageValid CHAR(1) DEFAULT('Y'),
		IsOriginalTitleLanguageValid CHAR(1) DEFAULT('Y'),
		IsProgramCategoryValid CHAR(1) DEFAULT('Y'),
		IsValid AS CASE 
						WHEN 'YYYYYYY' = (IsMusicDirectorValid + IsStarCastValid + IsMusicLabelValid + IsTitleTypeValid + IsTitleLanguageValid + 
											IsOriginalTitleLanguageValid + IsProgramCategoryValid ) 
						THEN 'Y' 
						ELSE 'N' 
				END
	)

	CREATE TABLE #Temp_DM_Title_Ignore
	(
		DM_Title_Code INT,
		IsMusicDirectorValid CHAR(1) DEFAULT('N'),
		IsStarCastValid CHAR(1) DEFAULT('N'),
		IsMusicLabelValid CHAR(1) DEFAULT('N'),
		IsTitleTypeValid CHAR(1) DEFAULT('N'),
		IsTitleLanguageValid CHAR(1) DEFAULT('N'),
		IsOriginalTitleLanguageValid CHAR(1) DEFAULT('N'),
		IsProgramCategoryValid CHAR(1) DEFAULT('N'),
		IsIgnore AS CASE 
						WHEN 'NNNNNNN' = (IsMusicDirectorValid + IsStarCastValid + IsMusicLabelValid + IsTitleTypeValid + IsTitleLanguageValid + 
											IsOriginalTitleLanguageValid + IsProgramCategoryValid ) 
						THEN 'N' 
						ELSE 'Y' 
				END
	)

	INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type, Is_New)
	SELECT [Name], [Key], [value], [DM_Master_Type] , CASE WHEN  ISNULL(RTRIM(LTRIM([value])),'') = 'NEW' THEN 'Y' ELSE 'N' END AS [Is_New]
	FROM @DM_Import_UDT udt
	Inner Join DM_Master_Log dm on dm.DM_Master_Log_Code = udt.[Key]

	DECLARE @DirectorRoleCode INT = 1, @StarCastRoleCode INT = 2

	IF EXISTS(SELECT TOP 1 DM_Master_Log_Code FROM #Temp_DM WHERE Is_New = 'Y')
	BEGIN
		Declare @CurDate DateTime = GetDate();

		INSERT INTO Talent(Talent_Name, Gender, Is_Active, Inserted_By, Inserted_On)
		SELECT DISTINCT TD.Master_Name, 'N', 'Y', @Users_Code, @CurDate FROM  #Temp_DM TD  
		WHERE TD.Master_Type = 'TA' AND Is_New = 'Y'
		
		UPDATE TD SET TD.DM_Master_Code = T.Talent_Code 
		FROM #Temp_DM TD
		INNER JOIN Talent T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Talent_Name collate SQL_Latin1_General_CP1_CI_AS
		AND TD.Master_Type = 'TA'
		
		INSERT INTO Music_Label(Music_Label_Name, Is_Active, Inserted_By,  Inserted_On)  
		SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
		WHERE TD.Master_Type = 'LB' AND Is_New = 'Y' AND 
		TD.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label)
        
		UPDATE TD SET TD.DM_Master_Code = ML.Music_Label_Code   
		FROM #Temp_DM TD  
		INNER JOIN Music_Label ML ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = ML.Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS  
		AND TD.Master_Type = 'LB'
    
	END

	UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code = 'Y'

	UPDATE D SET D.Master_Code = T.DM_Master_Code, D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code != 'Y'

	UPDATE D SET D.Mapped_By = 'V', D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code > '0' AND D.Mapped_By = 'S'

	BEGIN

		CREATE TABLE #Temp_Talent_Role
		(
			Talent_Code INT,
			Role_Code INT,
			[Name] NVarchar(2000)
		)

		INSERT INTO #Temp_Talent_Role(Talent_Code, Role_Code, [Name])
		Select Distinct DM_Master_Code, Role_Code, [Master_Name] From (
			SELECT DM_Master_Code, @DirectorRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T
			INNER JOIN DM_Master_Log DM ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles Like '%Director%' AND DM.Master_Type = 'TA'
			UNION
			SELECT DM_Master_Code, @StarCastRoleCode As Role_Code, [Master_Name] FROM #Temp_DM  T
			INNER JOIN DM_Master_Log DM ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code AND DM.Roles like '%Cast%' AND DM.Master_Type = 'TA'
		) AS a Where a.DM_Master_Code Not In (
			Select tr.Talent_Code From Talent_Role tr Where  tr.Role_Code = a.Role_Code AND tr.Talent_Code IS NOT NULL
		) AND a.DM_Master_Code != 'Y'

		DECLARE @count INt
		select @count = cOUNT(*) from #Temp_Talent_Role

		IF(@count > 0)	
		BEGIN
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Talent_Role(Talent_Code, Role_Code)
			SELECT Talent_Code, Role_Code FROM #Temp_Talent_Role	

			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)
			SELECT Distinct [Name] As Original_Title, [Name] As Title_Name, [Name] As Synopsis, 
					(SELECT Deal_Type_Code FROM [Role] a WHERE a.Role_Code = tl.Role_Code) As Deal_Type_Code, GetDate() As Inserted_On, 
				   'Y' As Is_Active, Talent_Code Reference_Key, 'T' AS Reference_Flag 
			FROM #Temp_Talent_Role tl
		END
		Drop Table #Temp_Talent_Role
		
	END

	BEGIN
		IF OBJECT_ID('TEMPDB..#TempMasterLog') IS NOT NULL
			DROP TABLE #TempMasterLog

		CREATE TABLE #TempMasterLog
		(
			Name NVARCHAR(500), 
			Master_Type VARCHAR(10), 
			Master_Code VARCHAR(1000), 
			Roles VARCHAR(100),
			Is_Ignore CHAR(1)
		)

		INSERT INTO #TempMasterLog(Name, Master_Type, Master_Code, Roles, Is_Ignore)
		SELECT Name, Master_Type, Master_Code, Roles, Is_Ignore FROM DM_Master_Log
		WHERE DM_Master_Import_Code = cast(@DM_Master_Import_Code as varchar) AND ISNULL(Master_Code, 0) = 0  
	END
	DECLARE @Master_Name NVARCHAR(1000) = ''

	BEGIN
		DECLARE CUR_DM_Title_Ignore CURSOR For SELECT Master_Name from #Temp_DM
		OPEN CUR_DM_Title_Ignore  

		FETCH NEXT FROM CUR_DM_Title_Ignore InTo @Master_Name
		WHILE @@FETCH_STATUS<>-1    
	BEGIN    
                                            
		IF(@@FETCH_STATUS<>-2)                                                            
		BEGIN                                                                                                                           
			PRINT 'BEGIN Start'   

				INSERT INTO #Temp_DM_Title_Ignore(DM_Title_Code)
				SELECT DM_Title_Code FROM DM_Title 
				WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_status <> 'N' AND 
				(
					[Title Type] like '%' + @Master_Name + '%' OR
					[Program Category] like '%' + @Master_Name + '%' OR
					[Director Name] like '%' + @Master_Name + '%' OR
					[Key Star Cast] like '%' + @Master_Name + '%' OR
					[Original Language (Hindi)] like '%' + @Master_Name + '%' OR
					[Original_Language] like '%' + @Master_Name + '%' OR
					[Music_Label] like '%' + @Master_Name + '%' 
				)
				AND DM_Title_Code NOT IN (SELECT DM_Title_Code FROM #Temp_DM_Title_Ignore)
			FETCH NEXT FROM CUR_DM_Title_Ignore INTO @Master_Name
		END    
	END
		CLOSE CUR_DM_Title_Ignore    
		DEALLOCATE CUR_DM_Title_Ignore   

	END
	BEGIN -- Ignore
			UPDATE mt SET mt.IsTitleTypeValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Title Type]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Title Type],',')
					WHERE LTRIM(RTRIM(ISNULL([Title Type], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Title Type] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TT' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsProgramCategoryValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Program Category]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Program Category],',')
					WHERE LTRIM(RTRIM(ISNULL([Program Category], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Program Category] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'PC' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsMusicDirectorValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Director Name]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Director Name],',')
					WHERE LTRIM(RTRIM(ISNULL([Director Name], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Director Name] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA'  AND CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0 AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsStarCastValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Key Star Cast]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Key Star Cast],',')
					WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Key Star Cast] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA' AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0  AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsTitleLanguageValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original Language (Hindi)]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original Language (Hindi)],',')
					WHERE LTRIM(RTRIM(ISNULL([Original Language (Hindi)], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Original Language (Hindi)] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TL' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsOriginalTitleLanguageValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original_Language]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original_Language],',')
					WHERE LTRIM(RTRIM(ISNULL([Original_Language], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Original_Language] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'OL' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE mt SET mt.IsMusicLabelValid = 'Y'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Music_Label]
					FROM #Temp_DM_Title_Ignore D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Music_Label],',')
					WHERE LTRIM(RTRIM(ISNULL([Music_Label], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Music_Label] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'LB' AND ml.Is_Ignore = 'Y'
			) AS main
			INNER JOIN #Temp_DM_Title_Ignore mt ON main.DM_Title_Code = mt.DM_Title_Code

			UPDATE DT SET DT.Record_Status = 'N', DT.Is_Ignore = 'Y'
			FROM DM_Title DT
			INNER JOIN #Temp_DM_Title_Ignore TDMT ON TDMT.DM_Title_Code = DT.DM_Title_Code
			WHERE TDMT.IsIgnore = 'Y'
	END

	BEGIN
		DECLARE CUR_DM_Title CURSOR For SELECT Master_Name from #Temp_DM
		OPEN CUR_DM_Title  

		FETCH NEXT FROM CUR_DM_Title InTo @Master_Name
		WHILE @@FETCH_STATUS<>-1    
		BEGIN                            
			IF(@@FETCH_STATUS<>-2)                                                            
			BEGIN                                                                                                                           
				PRINT 'BEGIN Start'   
					INSERT INTO #Temp_DM_Title(DM_Title_Code)
					SELECT DM_Title_Code FROM DM_Title 
					WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_status <> 'N' AND 
					(
						[Title Type] like '%' + @Master_Name + '%' OR
						[Program Category] like '%' + @Master_Name + '%' OR
						[Director Name] like '%' + @Master_Name + '%' OR
						[Key Star Cast] like '%' + @Master_Name + '%' OR
						[Original Language (Hindi)] like '%' + @Master_Name + '%' OR
						[Original_Language] like '%' + @Master_Name + '%' OR
						[Music_Label] like '%' + @Master_Name + '%' 
					)
					AND IS_Ignore ='N' AND DM_Title_Code NOT IN (SELECT DM_Title_Code FROM #Temp_DM_Title)

				FETCH NEXT FROM CUR_DM_Title INTO @Master_Name
			END    
		END
		CLOSE CUR_DM_Title    
		DEALLOCATE CUR_DM_Title   

	END
	BEGIN 

		UPDATE mt SET mt.IsTitleTypeValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Title Type]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Title Type],',')
				WHERE LTRIM(RTRIM(ISNULL([Title Type], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Title Type] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TT' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code

		UPDATE mt SET mt.IsProgramCategoryValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Program Category]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Program Category],',')
				WHERE LTRIM(RTRIM(ISNULL([Program Category], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Program Category] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'PC' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code

		UPDATE mt SET mt.IsMusicDirectorValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Director Name]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Director Name],',')
				WHERE LTRIM(RTRIM(ISNULL([Director Name], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Director Name] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS
			AND ml.Master_Type = 'TA' AND  CHARINDEX('MUSIC COMPOSER', UPPER(ml.Roles)) > 0
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code

		UPDATE mt SET mt.IsStarCastValid = 'N'
			FROM (
				SELECT DISTINCT DM_Title_Code
				FROM (
					SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Key Star Cast]
					FROM #Temp_DM_Title D
					INNER JOIN DM_Title DT ON DT.DM_Title_Code = D.DM_Title_Code
					CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Key Star Cast],',')
					WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> ''
				) AS a
				INNER JOIN #TempMasterLog ml ON a.[Key Star Cast] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
				AND ml.Master_Type = 'TA' AND CHARINDEX('STAR CAST', UPPER(ml.Roles)) > 0  
			) AS main
			INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code = mt.DM_Title_Code

		UPDATE mt SET mt.IsTitleLanguageValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original Title (Tanil/Telugu)]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original Title (Tanil/Telugu)],',')
				WHERE LTRIM(RTRIM(ISNULL([Original Title (Tanil/Telugu)], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Original Title (Tanil/Telugu)] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'TL' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code	

		UPDATE mt SET mt.IsOriginalTitleLanguageValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Original_Language]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Original_Language],',')
				WHERE LTRIM(RTRIM(ISNULL([Original_Language], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Original_Language] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'OL' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code	

		UPDATE mt SET mt.IsMusicLabelValid = 'N'
		FROM (
			SELECT DISTINCT DM_Title_Code
			FROM (
				SELECT Distinct D.DM_Title_Code, LTRIM(RTRIM(number)) AS [Music_Label]
				FROM #Temp_DM_Title D
				INNER JOIN DM_Title DT ON DT.DM_Title_Code= D.DM_Title_Code
				CROSS APPLY dbo.fn_Split_withdelemiter(DT.[Music_Label] ,',')
				WHERE LTRIM(RTRIM(ISNULL([Music_Label], ''))) <> ''
			) AS a
			INNER JOIN #TempMasterLog ml ON a.[Music_Label] collate SQL_Latin1_General_CP1_CI_AS = ml.Name collate SQL_Latin1_General_CP1_CI_AS 
			AND ml.Master_Type = 'LB' 
		) AS main
		INNER JOIN #Temp_DM_Title mt ON main.DM_Title_Code= mt.DM_Title_Code	

		UPDATE DT SET DT.Record_Status = 'N'
		FROM DM_Title DT
		INNER JOIN #Temp_DM_Title TDMT ON TDMT.DM_Title_Code = DT.DM_Title_Code
		WHERE TDMT.IsValid = 'Y'
	    
	END

	DECLARE @ResolveCount  Int , @TotalCount INT
	SELECT @ResolveCount = COUNT(*) FROM DM_Title WHERE Record_Status = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
	SELECT @TotalCount = COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code
	IF(@ResolveCount = @TotalCount)
	BEGIN
		UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
	END

	IF OBJECT_ID('tempdb..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
	IF OBJECT_ID('tempdb..#Temp_DM_Title') IS NOT NULL DROP TABLE #Temp_DM_Title
	IF OBJECT_ID('tempdb..#Temp_DM_Title_Ignore') IS NOT NULL DROP TABLE #Temp_DM_Title_Ignore
	IF OBJECT_ID('tempdb..#Temp_Talent_Role') IS NOT NULL DROP TABLE #Temp_Talent_Role
	IF OBJECT_ID('tempdb..#TempMasterLog') IS NOT NULL DROP TABLE #TempMasterLog
END
GO

ALTER PROCEDURE USP_List_MusicTrack    
(    
 @searchText NVARCHAR(500) = NULL    
)    
AS    
BEGIN    
	SELECT MT.Music_Title_Code, MT.Music_Title_Name, MT.Release_Year, MT.Duration_In_Min, 
	CASE WHEN LEN(MT.Movie_Album) > 0 THEN MT.Movie_Album ELSE MA.Music_Album_Name END AS [Movie_Album], ML.Music_Label_Name 
	FROM Music_Title MT    
	INNER JOIN Music_Title_Label MTL ON MT.Music_Title_Code = MTL.Music_Title_Code    
	INNER JOIN Music_Label ML ON MTL.Music_Label_Code = ML.Music_Label_Code    
	LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
	WHERE (
		(MT.Music_Title_Name LIKE N'%' + @searchText + '%' OR     
		MT.Movie_Album LIKE N'%' + @searchText + '%' OR    
		MA.Music_Album_Name LIKE N'%' + @searchText + '%' OR    
		ML.Music_Label_Name LIKE N'%' + @searchText + '%') AND MT.Is_Active = 'Y'
	)
	AND  MTL.Effective_From <= GETDATE()
END
GO

ALTER PROCEDURE USP_Title_Import_Utility_PII
	@DM_Import_UDT DM_Import_UDT READONLY,
	@DM_Master_Import_Code Int,
	@Users_Code Int
AS
BEGIN
	SET NOCOUNT ON

	IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
	IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL DROP TABLE #Temp_Talent_Role

	--DECLARE @DM_Master_Import_Code INT = 15,@Users_Code Int = 1265
	--DECLARE @DM_Import_UDT DM_Import_UDT

	--INSERT INTO @DM_Import_UDT([Key],[value], [DM_Master_Type])
	--SELECT 236,'Y','TA'
	--UNION ALL SELECT 230,'1626','TA'
	--UNION ALL SELECT 227,'35','TA'

	CREATE TABLE #Temp_DM
	(
		Master_Name NVarchar(2000),
		DM_Master_Log_Code BIGINT,
		DM_Master_Code NVARCHAR (100),
		Master_Type NVARCHAR (100),
		Is_New CHAR(1)
	)

	CREATE TABLE #Temp_Talent_Role
	(
		Talent_Code INT,
		Role_Code INT,
		[Name] NVarchar(2000)
	)

	INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type, Is_New)
	SELECT [Name], [Key], [value], [DM_Master_Type] , CASE WHEN  ISNULL(RTRIM(LTRIM([value])),'') = 'NEW' THEN 'Y' ELSE 'N' END AS [Is_New]
	FROM @DM_Import_UDT udt
	Inner Join DM_Master_Log dm on dm.DM_Master_Log_Code = udt.[Key]

	IF EXISTS(SELECT TOP 1 DM_Master_Log_Code FROM #Temp_DM WHERE Is_New = 'Y')
	BEGIN
		DECLARE @CurDate DATETIME = GETDATE()

		-- INSERTING NEW DATA INTO TABLE
		BEGIN
			INSERT INTO Talent(Talent_Name, Gender, Is_Active, Inserted_By, Inserted_On)
			SELECT DISTINCT TD.Master_Name, 'N', 'Y', @Users_Code, @CurDate FROM  #Temp_DM TD  
			WHERE TD.Master_Type = 'TA' AND Is_New = 'Y'

			INSERT INTO Deal_Type(Deal_Type_Name, Is_Default,Is_Grid_Required, Is_Active, Is_Master_Deal)
			SELECT DISTINCT TD.Master_Name, 'N', 'Y','Y','N' FROM  #Temp_DM TD  
			WHERE TD.Master_Type = 'TT' AND Is_New = 'Y'

			INSERT INTO Genres (Genres_Name, Inserted_On, Inserted_By, Is_Active)
			SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code, 'Y' FROM  #Temp_DM TD  
			WHERE TD.Master_Type = 'GE' AND Is_New = 'Y'

			INSERT INTO Language (Language_Name, Inserted_On, Inserted_By, Is_Active)
			SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code, 'Y' FROM  #Temp_DM TD  
			WHERE TD.Master_Type IN ('OL','TL') AND Is_New = 'Y'

			INSERT INTO Program (Program_Name, Inserted_On, Inserted_By, Is_Active)
			SELECT DISTINCT TD.Master_Name, @CurDate, @Users_Code, 'Y' FROM  #Temp_DM TD  
			WHERE TD.Master_Type = 'PG' AND Is_New = 'Y'
		END

		-- UPDATING #Temp_DM (DM_Master_Code) Column
		BEGIN
			UPDATE TD SET TD.DM_Master_Code = T.Talent_Code 
			FROM #Temp_DM TD
			INNER JOIN Talent T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Talent_Name collate SQL_Latin1_General_CP1_CI_AS
			AND TD.Master_Type = 'TA'

			UPDATE TD SET TD.DM_Master_Code = T.Deal_Type_Code 
			FROM #Temp_DM TD
			INNER JOIN Deal_Type T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Deal_Type_Name collate SQL_Latin1_General_CP1_CI_AS
			AND TD.Master_Type = 'TT'

			UPDATE TD SET TD.DM_Master_Code = T.Genres_Code 
			FROM #Temp_DM TD
			INNER JOIN Genres T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Genres_Name collate SQL_Latin1_General_CP1_CI_AS
			AND TD.Master_Type = 'GE'

			UPDATE TD SET TD.DM_Master_Code = T.Language_Code 
			FROM #Temp_DM TD
			INNER JOIN Language T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Language_Name collate SQL_Latin1_General_CP1_CI_AS
			AND TD.Master_Type IN ('OL','TL') 

			UPDATE TD SET TD.DM_Master_Code = T.Program_Code 
			FROM #Temp_DM TD
			INNER JOIN Program T ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = T.Program_Name collate SQL_Latin1_General_CP1_CI_AS
			AND TD.Master_Type = 'PG'
		END

		BEGIN -- MUSIC LABEL
			INSERT INTO Music_Label(Music_Label_Name, Is_Active, Inserted_By,  Inserted_On)  
			SELECT DISTINCT TD.Master_Name, 'Y', @Users_Code, @CurDate FROM #Temp_DM TD  
			WHERE TD.Master_Type = 'LB' AND Is_New = 'Y' AND 
			TD.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN(SELECT Music_Label_Name COLLATE SQL_Latin1_General_CP1_CI_AS FROM Music_Label)
        
			UPDATE TD SET TD.DM_Master_Code = ML.Music_Label_Code   
			FROM #Temp_DM TD  
			INNER JOIN Music_Label ML ON TD.Master_Name collate SQL_Latin1_General_CP1_CI_AS = ML.Music_Label_Name collate SQL_Latin1_General_CP1_CI_AS  
			AND TD.Master_Type = 'LB'
		END
	END

	-- UPDATING IS_Ignore = Y INTO DM_Master_Log Table
	UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code = 'Y'

	-- UPDATING IS_Ignore = Y INTO DM_Master_Log Table
	UPDATE D SET D.Master_Code = T.DM_Master_Code, D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code != 'Y'

	-- UPDATING Mapped_By = V INTO DM_Master_Log Table
	UPDATE D SET D.Mapped_By = 'V', D.Action_By = @Users_Code, D.Action_On = GETDATE()
	FROM DM_Master_Log D
	INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code > '0' AND D.Mapped_By = 'S'

	BEGIN -- TALENT ROLE HANDLED
		INSERT INTO #Temp_Talent_Role(Talent_Code, Role_Code, [Name])
		SELECT DISTINCT DM_Master_Code, Role_Code, [Master_Name] FROM (
			SELECT DM_Master_Code, R.Role_Code , [Master_Name] 
			FROM #Temp_DM  T
			INNER JOIN DM_Master_Log DM ON T.DM_Master_Log_Code = DM.DM_Master_Log_Code
			INNER JOIN Role R ON R.Role_Name = DM.Roles
			WHERE DM.Master_Type = 'TA'
		) AS a WHERE a.DM_Master_Code Not In (
			SELECT tr.Talent_Code FROM Talent_Role tr WHERE  tr.Role_Code = a.Role_Code AND tr.Talent_Code IS NOT NULL
		) AND a.DM_Master_Code != 'Y'

		DECLARE @count INT
		SELECT @count = COUNT(*) FROM #Temp_Talent_Role

		IF(@count > 0)	
		BEGIN
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role DISABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Talent_Role(Talent_Code, Role_Code)
			SELECT Talent_Code, Role_Code FROM #Temp_Talent_Role	

			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_Del
			ALTER TABLE Talent_Role ENABLE TRIGGER Trg_Talent_Role_INS

			INSERT INTO Title(Original_Title, Title_Name, Synopsis, Deal_Type_Code, Inserted_On, Is_Active, Reference_Key, Reference_Flag)
			SELECT Distinct [Name] As Original_Title, [Name] As Title_Name, [Name] As Synopsis, 
					(SELECT Deal_Type_Code FROM [Role] a WHERE a.Role_Code = tl.Role_Code) As Deal_Type_Code, GetDate() As Inserted_On, 
				   'Y' As Is_Active, Talent_Code Reference_Key, 'T' AS Reference_Flag 
			FROM #Temp_Talent_Role tl
		END
	END

	IF NOT EXISTS (SELECT TOP 1 *  FROM DM_Master_Log WHERE  DM_Master_Import_Code = @DM_Master_Import_Code AND Action_By IS NULL  AND Action_On IS NULL)
	BEGIN
		UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code  
	END

	IF OBJECT_ID('TEMPDB..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
	IF OBJECT_ID('TEMPDB..#Temp_Talent_Role') IS NOT NULL DROP TABLE #Temp_Talent_Role

END
GO

ALTER PROCEDURE [dbo].[USPListResolveConflict]
	@DM_Master_Import_Code VARCHAR(MAX) = '0',
	@Code INT = 0,	
	@FileType VARCHAR(1) = '',
	@PageNo INT = 1,
	@PageSize INT = 99,
	@RecordCount INT OUT
AS
/*=============================================
Author:			
Create date:	11 Feb, 2019
Description:	
--===============================================*/
BEGIN
--DECLARE
--	@DM_Master_Import_Code VARCHAR(MAX) = '10169',
--	@Code INT = 17,	
--	@FileType VARCHAR(1) = 'T',
--	@PageNo INT = 1,
	--@PageSize INT = 10,
	--@RecordCount INT 

	IF(OBJECT_ID('TEMPDB..#TempRoles') IS NOT NULL)
		DROP TABLE #TempRoles
	IF(OBJECT_ID('TEMPDB..#tempMasterLog') IS NOT NULL)
		DROP TABLE #tempMasterLog
    IF(OBJECT_ID('TEMPDB..#temp') IS NOT NULL)
		DROP TABLE #temp	
		
	CREATE TABLE #tempMasterLog
	(
		Row_No INT IDENTITY(1,1),		
		DMMasterLogCode NVARCHAR(MAX),	
		MasterType NVARCHAR(MAX),
		Type VARCHAR(MAX),
		ImportData NVARCHAR(MAX),
		MappedTo NVARCHAR(MAX),
		MappedBy NVARCHAR(MAX),		
		ActionBy NVARCHAR(MAX),
		MappedDate Datetime,
		DMMasterImportCode NVARCHAR(MAX)
	)

	CREATE TABLE #temp
	(
		Row_No INT IDENTITY(1,1),			
		Type VARCHAR(MAX),
		ImportData NVARCHAR(MAX),
		MappedTo NVARCHAR(MAX),
		MappedBy NVARCHAR(MAX),	
		ActionBy NVARCHAR(MAX),
		MappedDate Datetime
	)


	SELECT DML.DM_Master_Log_Code , LTRIM(RTRIM(number)) AS ROLE INTO #TempRoles
	FROM DM_Master_Log DML 
	CROSS APPLY dbo.fn_Split_withdelemiter(Roles,',') 
	WHERE LTRIM(RTRIM(ISNULL(Roles, ''))) <> '' 
	AND DML.DM_Master_Import_Code = @DM_Master_Import_Code 
					   
	INSERT INTO #tempMasterLog(DMMasterLogCode,  MasterType, Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate, DMMasterImportCode)
	SELECT DISTINCT DML.DM_Master_Log_Code, DML.Master_Type,
		CASE WHEN DML.Master_Type = 'TA' THEN TR.Role
			 WHEN DML.Master_Type = 'LB' THEN 'Music Label'
			 WHEN DML.Master_Type = 'GE' THEN 'Genres'
			 WHEN DML.Master_Type = 'MA' THEN 'Movie/Album'
			 WHEN DML.Master_Type = 'ML' THEN 'Language'
			 WHEN DML.Master_Type = 'MT' THEN 'Theme'
			 WHEN DML.Master_Type = 'TT' THEN 'Title Type'
			 WHEN DML.Master_Type = 'TL' THEN 'Title Language'
			 WHEN DML.Master_Type = 'OL' THEN 'Original Language'
			 WHEN DML.Master_Type = 'PC' THEN 'Program Category'
			 WHEN DML.Master_Type = 'CM' THEN 'Music Track'
			 WHEN DML.Master_Type = 'PG' THEN 'Program'
		END AS Type, 
		DML.Name, 
		CASE WHEN DML.Master_Type = 'TA' THEN T.Talent_Name
			 WHEN DML.Master_Type = 'LB' THEN LB.Music_Label_Name
			 WHEN DML.Master_Type = 'GE' THEN G.Genres_Name
			 WHEN DML.Master_Type = 'MA' THEN MA.Music_Album_Name
			 WHEN DML.Master_Type = 'ML' THEN ML.Language_Name
			 WHEN DML.Master_Type = 'MT' THEN MT.Music_Theme_Name
			 WHEN DML.Master_Type = 'TT' THEN DT.Deal_Type_Name
			 WHEN DML.Master_Type = 'TL' THEN TL.Language_Name
			 WHEN DML.Master_Type = 'OL' THEN TL.Language_Name
			 WHEN DML.Master_Type = 'PC' THEN ECV.Columns_Value
			 WHEN DML.Master_Type = 'CM' THEN TM.Music_Title_Name
			 WHEN DML.Master_Type = 'PG' THEN PG.Program_Name
		END AS MappedTo,
		CASE WHEN (DML.Mapped_By = 'U' AND DML.Master_Code IS NOT NULL)THEN 'Users'
			 WHEN (DML.Mapped_By = 'S' OR DML.Mapped_By = 'V' AND DML.Master_Code IS NOT NULL )THEN 'System'
		END AS MappedBy, 
		CASE WHEN (DML.Mapped_By = 'U' AND DML.Master_Code IS NOT NULL) THEN U.First_Name
		     ELSE '' END,
		CASE WHEN DML.Master_Code IS NOT NULL THEN DML.Action_On
			 ELSE NULL END,
	DML.DM_Master_Import_Code
	FROM DM_Master_Log DML
	LEFT JOIN Users U ON DML.Action_By = U.Users_Code
	LEFT JOIN Talent T ON T.Talent_Code = DML.Master_Code
	LEFT JOIN Music_Label LB ON LB.Music_Label_Code = DML.Master_Code
	LEFT JOIN Genres G ON G.Genres_Code = DML.Master_Code
	LEFT JOIN Program PG ON PG.Program_Code = DML.Master_Code
	LEFT JOIN Music_Album MA ON MA.Music_Album_Code = DML.Master_Code
	LEFT JOIN Music_Language ML ON ML.Music_Language_Code = DML.Master_Code
	LEFT JOIN Music_Theme MT ON MT.Music_Theme_Code = DML.Master_Code
	LEFT JOIN Deal_Type DT ON DT.Deal_Type_Code = DML.Master_Code
	LEFT JOIN Language TL ON TL.Language_Code = DML.Master_Code
	LEFT JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = DML.Master_Code
	LEFT JOIN Music_Title TM ON TM.Music_Title_Code = DML.Master_Code
	LEFT JOIN #TempRoles TR ON DML.DM_Master_Log_Code = TR.DM_Master_Log_Code
	
	WHERE @DM_Master_Import_Code = '0' OR DML.DM_Master_Import_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter(''+@DM_Master_Import_Code+'',','))  
					
	IF(@FileType = 'M')
	BEGIN
		IF(OBJECT_ID('TEMPDB..#TempSinger') IS NOT NULL)
			DROP TABLE #TempSinger
		IF(OBJECT_ID('TEMPDB..#TempMusicComposer') IS NOT NULL)
			DROP TABLE #TempMusicComposer
		IF(OBJECT_ID('TEMPDB..#TempStarCast') IS NOT NULL)
			DROP TABLE #TempStarCast   
		IF(OBJECT_ID('TEMPDB..#TempLyricist') IS NOT NULL)
			DROP TABLE #TempLyricist  
        IF(OBJECT_ID('TEMPDB..#TempLanguage') IS NOT NULL)
			DROP TABLE #TempLanguage
		IF(OBJECT_ID('TEMPDB..#TempTheme') IS NOT NULL)
			DROP TABLE #TempTheme

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Singers INTO #TempSinger
		FROM DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Singers],',') 
		WHERE LTRIM(RTRIM(ISNULL([Singers], ''))) <> '' 
		AND DMT.IntCode = @Code

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Composers INTO #TempMusicComposer
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Music_Director, ''))) <> '' 
		AND DMT.IntCode = @Code

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS StarCast INTO #TempStarCast
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Star_Cast, ''))) <> '' 
		AND DMT.IntCode = @Code

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Lyricist INTO #TempLyricist
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Lyricist, ''))) <> '' 
		AND DMT.IntCode = @Code
		
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Language INTO #TempLanguage
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Title_Language, ''))) <> '' 
		AND DMT.IntCode = @Code
		
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Theme INTO #TempTheme
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Theme,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Theme, ''))) <> '' 
		AND DMT.IntCode = @Code

	    INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT DISTINCT Type, 
		CASE WHEN (t.MasterType = 'TA' AND t.Type = 'Music Composer')THEN (SELECT TMS.Composers where TMS.Composers COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Singers')THEN (SELECT TS.Singers where TS.Singers COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'star cast')THEN (SELECT TSC.StarCast where TSC.StarCast COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Lyricist')THEN (SELECT TL.Lyricist where TL.Lyricist COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
		     WHEN t.MasterType = 'GE' THEN (SELECT DMT.Genres where DMT.Genres COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
			 WHEN (t.MasterType = 'ML' OR t.MasterType = 'TL') THEN (SELECT LT.Language where LT.Language COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'MA' THEN (SELECT DMT.Movie_Album WHERE DMT.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'MT' THEN (SELECT TT.Theme WHERE TT.Theme COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'LB' THEN (SELECT DMT.Music_Label WHERE DMT.Music_Label COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
		END AS ImportData, 
		MappedTo, MappedBy, ActionBy, MappedDate
		FROM #tempMasterLog t 
		INNER JOIN DM_Music_Title DMT ON DMT.DM_Master_Import_Code = t.DMMasterImportCode
		LEFT Join #TempSinger TS ON DMT.IntCode = TS.IntCode
		LEFT JOIN #TempMusicComposer TMS ON DMT.IntCode = TMS.IntCode
		LEFT JOIN #TempStarCast TSC ON DMT.IntCode = TSC.IntCode		
		LEFT JOIN #TempLanguage LT ON DMT.IntCode = LT.IntCode
		LEFT JOIN #TempTheme TT ON DMT.IntCode = TT.IntCode
		LEFT JOIN #TempLyricist TL ON DMT.IntCode = TL.IntCode
		WHERE DMT.IntCode = @Code   
	END		

	IF(@FileType = 'T')
	BEGIN
		DECLARE @Str_Contenate NVARCHAR(MAX) 

		SELECT @Str_Contenate = CONCAT(Col3,'-',Col4,'-',Col5,'-',Col6,'-',Col7,'-',Col8,'-',Col9,'-',Col10,'-',Col11,'-',Col12,'-',Col13,'-',Col14,'-',Col15,'-',Col16,'-',Col17,'-',Col18,'-',Col19,'-',Col20,'-',Col21,'-',Col22,'-',Col23,'-',Col24,'-',Col25,'-',Col26,'-',Col27,'-',Col28,'-',Col29,'-',Col30,'-',Col31,'-',Col32,'-',Col33,'-',Col34,'-',Col35,'-',Col36,'-',Col37,'-',Col38,'-',Col39,'-',Col40,'-',Col41,'-',Col42,'-',Col43,'-',Col44,'-',Col45,'-',Col46,'-',Col47,'-',Col48,'-',Col49,'-',Col50,'-',Col51,'-',Col52,'-',Col53,'-',Col54,'-',Col55,'-',Col56,'-',Col57,'-',Col58,'-',Col59,'-',Col60,'-',Col61,'-',Col62,'-',Col63,'-',Col64,'-',Col65,'-',Col66,'-',Col67,'-',Col68,'-',Col69,'-',Col70,'-',Col71,'-',Col72,'-',Col73,'-',Col74,'-',Col75,'-',Col76,'-',Col77,'-',Col78,'-',Col79,'-',Col80,'-',Col81,'-',Col82,'-',Col83,'-',Col84,'-',Col85,'-',Col86,'-',Col87,'-',Col88,'-',Col89,'-',Col90,'-',Col91,'-',Col92,'-',Col93,'-',Col94,'-',Col95,'-',Col96,'-',Col97,'-',Col98,'-',Col99,'-',Col100)
		FROM DM_Title_Import_Utility_Data  DT WHERE DM_Master_Import_Code =  @DM_Master_Import_Code AND DM_Title_Import_Utility_Data_Code = @Code

		INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT Distinct Type,ImportData,MappedTo, MappedBy, ActionBy, MappedDate
		FROM #tempMasterLog t
		WHERE T.DMMasterLogCode IN (SELECT DM_Master_Log_Code FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code and @Str_Contenate like '%'+Name+'%')
	END
		
	
	IF(@FileType = 'C')
	BEGIN
		INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT DISTINCT Type, 
		CASE WHEN t.MasterType = 'CM' THEN (SELECT DCM.Music_Track  WHERE DCM.Music_Track COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
		END AS ImportData, 
		MappedTo, MappedBy, ActionBy, MappedDate
		FROM #tempMasterLog t
		INNER JOIN DM_Content_Music DCM ON DCM.DM_Master_Import_Code = t.DMMasterImportCode   
		WHERE  DCM.IntCode = @Code 
	END

	SELECT Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate FROM #temp t WHERE t.ImportData IS NOT NULL

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#TempComposer') IS NOT NULL DROP TABLE #TempComposer
	IF OBJECT_ID('tempdb..#TempDirector') IS NOT NULL DROP TABLE #TempDirector
	IF OBJECT_ID('tempdb..#TempKeyStarCast') IS NOT NULL DROP TABLE #TempKeyStarCast
	IF OBJECT_ID('tempdb..#TempLanguage') IS NOT NULL DROP TABLE #TempLanguage
	IF OBJECT_ID('tempdb..#TempLyricist') IS NOT NULL DROP TABLE #TempLyricist
	IF OBJECT_ID('tempdb..#tempMasterLog') IS NOT NULL DROP TABLE #tempMasterLog
	IF OBJECT_ID('tempdb..#TempMusicComposer') IS NOT NULL DROP TABLE #TempMusicComposer
	IF OBJECT_ID('tempdb..#TempRoles') IS NOT NULL DROP TABLE #TempRoles
	IF OBJECT_ID('tempdb..#TempSinger') IS NOT NULL DROP TABLE #TempSinger
	IF OBJECT_ID('tempdb..#TempStarCast') IS NOT NULL DROP TABLE #TempStarCast
	IF OBJECT_ID('tempdb..#TempTheme') IS NOT NULL DROP TABLE #TempTheme

END
GO

ALTER PROCEDURE [dbo].[USPMHGetRequestDetails]
@RequestCode NVARCHAR(MAX),
@RequestTypeCode INT,
@IsCueSheet CHAR = 'N'
AS
BEGIN
	--DECLARE
	--@RequestCode NVARCHAR(MAX) = 10049,
	--@RequestTypeCode INT = 1,
	--@IsCueSheet CHAR = 'N'

	IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet

	IF(@RequestTypeCode = 1)
		BEGIN
		IF(@IsCueSheet = 'Y')
			BEGIN

				--Select COUNT(*) AS Cnt, TitleCode,MusicTitleCode, ma.Music_Album_Name INTO #tempCueSheet
				--from MHCuesheetsong mcs
				--INNER JOIN Music_Title mt ON mt.Music_Title_Code = mcs.MusicTitleCode
				--INNER JOIN Music_Album ma ON ma.Music_Album_Code = mt.Music_Album_Code
				--GROUP BY TitleCode,MusicTitleCode, ma.Music_Album_Name

				--SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') + ' ('+CAST(ISNULL(tcs.Cnt, 0) AS NVARCHAR) +')' AS RequestedMusicTitle, 
				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				--LEFT  JOIN #tempCueSheet tcs ON tcs.MusicTitleCode = mrd.MusicTitleCode AND tcs.TitleCode = mr.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',','))) AND MRD.IsApprove = 'Y'
			END
		ELSE
			BEGIN
				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',',')))
			END
			
		END
	ELSE IF(@RequestTypeCode = 2)
		BEGIN
			SELECT ISNULL(MRD.MusicTrackName,'') AS RequestedMusicTitleName,ISNULL(MT.Music_Title_Name,'') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'') AS MusicMovieAlbumName,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
			ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove,
				 ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.Singers,'')),'') AS Singers,ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.StarCasts,'')),'') AS StarCasts
			FROM MHRequestDetails MRD
			LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
			LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
			WHERE MRD.MHRequestCode = @RequestCode
		END
	ELSE
		BEGIN
			SELECT ISNULL(MRD.TitleName,'') AS RequestedMovieAlbumName,ISNULL(MA.Music_Album_Name,'') AS ApprovedMovieAlbumName,
			CASE WHEN MRD.MovieAlbum = 'A' THEN 'Album' 
				 ELSE 'Movie' END AS MovieAlbum,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
				 ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove
			FROM MHRequestDetails MRD 
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode
			WHERE MRD.MHRequestCode = @RequestCode
		END

		IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet
END
GO

