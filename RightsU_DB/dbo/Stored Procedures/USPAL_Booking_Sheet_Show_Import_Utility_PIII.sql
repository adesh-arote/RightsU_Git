CREATE PROCEDURE [dbo].[USPAL_Booking_Sheet_Show_Import_Utility_PIII]
(
	@DM_Master_Import_Code INT
)
AS 
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_Booking_Sheet_Show_Import_Utility_PIII]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET NOCOUNT ON

--DECLARE @DM_Master_Import_Code INT = 119
		DECLARE @ISError CHAR(1) = 'N', @Error_Message NVARCHAR(MAX) = '', @ExcelCnt INT = 0, @Record_Code INT = 0

		IF(OBJECT_ID('tempdb..#TempTitle') IS NOT NULL) DROP TABLE #TempTitle
		IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
		IF(OBJECT_ID('tempdb..#TempExtendedColumn') IS NOT NULL) DROP TABLE #TempExtendedColumn
		IF(OBJECT_ID('tempdb..#TempCountRef') IS NOT NULL) DROP TABLE #TempCountRef
		IF(OBJECT_ID('tempdb..#TempTitleAndContetCode') IS NOT NULL) DROP TABLE #TempTitleAndContetCode
		IF(OBJECT_ID('tempdb..#TempTitleErrorTable') IS NOT NULL) DROP TABLE #TempTitleErrorTable
	    IF(OBJECT_ID('tempdb..#TempTitleEpisodeTable') IS NOT NULL) DROP TABLE #TempTitleEpisodeTable

		CREATE TABLE #TempTitle(
			DM_Master_Import_Code INT,
			DM_Booking_Sheet_Data_Code NVARCHAR(MAX),
			DataType Char,
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
			Col100 NVARCHAR(MAX),
			COL101 NVARCHAR(MAX),
			COL102 NVARCHAR(MAX),
			COL103 NVARCHAR(MAX),
			COL104 NVARCHAR(MAX),
			COL105 NVARCHAR(MAX),
			COL106 NVARCHAR(MAX),
			COL107 NVARCHAR(MAX),
			COL108 NVARCHAR(MAX),
			COL109 NVARCHAR(MAX),
			COL110 NVARCHAR(MAX),
			COL111 NVARCHAR(MAX),
			COL112 NVARCHAR(MAX),
			COL113 NVARCHAR(MAX),
			COL114 NVARCHAR(MAX),
			COL115 NVARCHAR(MAX),
			COL116 NVARCHAR(MAX),
			COL117 NVARCHAR(MAX),
			COL118 NVARCHAR(MAX),
			COL119 NVARCHAR(MAX),
			COL120 NVARCHAR(MAX),
			COL121 NVARCHAR(MAX),
			COL122 NVARCHAR(MAX),
			COL123 NVARCHAR(MAX),
			COL124 NVARCHAR(MAX),
			COL125 NVARCHAR(MAX),
			COL126 NVARCHAR(MAX),
			COL127 NVARCHAR(MAX),
			COL128 NVARCHAR(MAX),
			COL129 NVARCHAR(MAX),
			COL130 NVARCHAR(MAX),
			COL131 NVARCHAR(MAX),
			COL132 NVARCHAR(MAX),
			COL133 NVARCHAR(MAX),
			COL134 NVARCHAR(MAX),
			COL135 NVARCHAR(MAX),
			COL136 NVARCHAR(MAX),
			COL137 NVARCHAR(MAX),
			COL138 NVARCHAR(MAX),
			COL139 NVARCHAR(MAX),
			COL140 NVARCHAR(MAX),
			COL141 NVARCHAR(MAX),
			COL142 NVARCHAR(MAX),
			COL143 NVARCHAR(MAX),
			COL144 NVARCHAR(MAX),
			COL145 NVARCHAR(MAX),
			COL146 NVARCHAR(MAX),
			COL147 NVARCHAR(MAX),
			COL148 NVARCHAR(MAX),
			COL149 NVARCHAR(MAX),
			COL150 NVARCHAR(MAX),
			COL151 NVARCHAR(MAX),
			COL152 NVARCHAR(MAX),
			COL153 NVARCHAR(MAX),
			COL154 NVARCHAR(MAX),
			COL155 NVARCHAR(MAX),
			COL156 NVARCHAR(MAX),
			COL157 NVARCHAR(MAX),
			COL158 NVARCHAR(MAX),
			COL159 NVARCHAR(MAX),
			COL160 NVARCHAR(MAX),
			COL161 NVARCHAR(MAX),
			COL162 NVARCHAR(MAX),
			COL163 NVARCHAR(MAX),
			COL164 NVARCHAR(MAX),
			COL165 NVARCHAR(MAX),
			COL166 NVARCHAR(MAX),
			COL167 NVARCHAR(MAX),
			COL168 NVARCHAR(MAX),
			COL169 NVARCHAR(MAX),
			COL170 NVARCHAR(MAX),
			COL171 NVARCHAR(MAX),
			COL172 NVARCHAR(MAX),
			COL173 NVARCHAR(MAX),
			COL174 NVARCHAR(MAX),
			COL175 NVARCHAR(MAX),
			COL176 NVARCHAR(MAX),
			COL177 NVARCHAR(MAX),
			COL178 NVARCHAR(MAX),
			COL179 NVARCHAR(MAX),
			COL180 NVARCHAR(MAX),
			COL181 NVARCHAR(MAX),
			COL182 NVARCHAR(MAX),
			COL183 NVARCHAR(MAX),
			COL184 NVARCHAR(MAX),
			COL185 NVARCHAR(MAX),
			COL186 NVARCHAR(MAX),
			COL187 NVARCHAR(MAX),
			COL188 NVARCHAR(MAX),
			COL189 NVARCHAR(MAX),
			COL190 NVARCHAR(MAX),
			COL191 NVARCHAR(MAX),
			COL192 NVARCHAR(MAX),
			COL193 NVARCHAR(MAX),
			COL194 NVARCHAR(MAX),
			COL195 NVARCHAR(MAX),
			COL196 NVARCHAR(MAX),
			COL197 NVARCHAR(MAX),
			COL198 NVARCHAR(MAX),
			COL199 NVARCHAR(MAX),
			COL200 NVARCHAR(MAX)
		)

		CREATE TABLE #TempTitleUnPivot(
			DMBookingSheetDataCode NVARCHAR(MAX),
			DMMasterImportCode NVARCHAR(MAX),
			ColumnHeader NVARCHAR(MAX),
			DataType NVARCHAR(MAX),
			TitleData NVARCHAR(MAX),
			ColumnCode INT,
			Validations NVARCHAR(MAX),
			Allow_Import NVARCHAR(MAX),
			Title_Code INT,
			Title_Content_Code INT,
			RefKey NVARCHAR(MAX),
			IsError CHAR(1),
			ErrorMessage NVARCHAR(MAX)
		)

		CREATE Table #TempExtendedColumn(
			Columns_Code  NVARCHAR(MAX), 
			Columns_Name  NVARCHAR(MAX), 
			Control_Type  NVARCHAR(MAX), 
			Is_Ref  NVARCHAR(MAX), 
			Is_Defined_Values  NVARCHAR(MAX), 
			Is_Multiple_Select  NVARCHAR(MAX), 
			Ref_Table  NVARCHAR(MAX), 
			Ref_Display_Field  NVARCHAR(MAX), 
			Ref_Value_Field  NVARCHAR(MAX), 
			Additional_Condition  NVARCHAR(MAX), 
			Is_Add_OnScreen  NVARCHAR(MAX)
		)	
		
		CREATE Table #TempCountRef(
			Count_Ref  INT
		)

		CREATE Table #TempTitleAndContetCode(
			DMBookingSheetDataCode INT, 
			DMMasterImportCode INT, 
			Title_Code INT, 
			Title_Content_Code INT
		)

		CREATE Table #TempTitleErrorTable(
			DMBookingSheetDataCode INT,
			Title_Code INT,
			Title_Content_Code INT,
			IsError NVARCHAR(MAX),
			Error_Msg NVARCHAR(MAX)
		)
		
		CREATE Table #TempTitleEpisodeTable(
			DMBookingSheetDataCode INT,
			DMMasterImportCode INT,
			TitleName NVARCHAR(MAX),
			EpisodeNo NVARCHAR(MAX)
		)

		BEGIN TRY

		SELECT @Record_Code = Record_Code FROM DM_Master_Import WHERE DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE DM_Booking_Sheet_Data SET Error_Message = NULL, Is_Ignore = 'N', Record_Status = NULL 
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Data_Type NOT LIKE '%H%' AND Sheet_Name = 'Show' 

		PRINT 'Inserting Data into #TempTitle'
		INSERT INTO #TempTitle (DM_Master_Import_Code, DM_Booking_Sheet_Data_Code, DataType, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100 ,
		                        COL101, COL102, COL103, COL104, COL105, COL106, COL107, COL108, COL109, COL110, COL111, COL112, COL113, COL114, COL115, COL116, COL117, COL118, COL119, COL120, COL121, COL122, COL123, COL124, COL125, COL126, COL127, COL128, COL129, COL130, COL131, COL132, COL133, COL134, COL135, COL136, COL137, COL138, COL139, COL140, COL141, COL142, COL143, COL144, COL145, COL146, COL147, COL148, COL149, COL150, COL151, COL152, COL153, COL154, COL155, COL156, COL157, COL158, COL159, COL160, COL161, COL162, COL163, COL164, COL165, COL166, COL167, COL168, COL169, COL170, COL171, COL172, COL173, COL174, COL175, COL176, COL177, COL178, COL179, COL180, COL181, COL182, COL183, COL184, COL185, COL186, COL187, COL188, COL189, COL190, COL191, COL192, COL193, COL194, COL195, COL196, COL197, COL198, COL199, COL200)  
		SELECT DM_Master_Import_Code, DM_Booking_Sheet_Data_Code, Data_Type, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100 ,
		       COL101, COL102, COL103, COL104, COL105, COL106, COL107, COL108, COL109, COL110, COL111, COL112, COL113, COL114, COL115, COL116, COL117, COL118, COL119, COL120, COL121, COL122, COL123, COL124, COL125, COL126, COL127, COL128, COL129, COL130, COL131, COL132, COL133, COL134, COL135, COL136, COL137, COL138, COL139, COL140, COL141, COL142, COL143, COL144, COL145, COL146, COL147, COL148, COL149, COL150, COL151, COL152, COL153, COL154, COL155, COL156, COL157, COL158, COL159, COL160, COL161, COL162, COL163, COL164, COL165, COL166, COL167, COL168, COL169, COL170, COL171, COL172, COL173, COL174, COL175, COL176, COL177, COL178, COL179, COL180, COL181, COL182, COL183, COL184, COL185, COL186, COL187, COL188, COL189, COL190, COL191, COL192, COL193, COL194, COL195, COL196, COL197, COL198, COL199, COL200
		FROM DM_Booking_Sheet_Data  --(NOLOCK)
		WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Sheet_Name = 'Show'

		PRINT 'Inserting Extended column detail into #TempExtendedColumn'
		INSERT INTO #TempExtendedColumn (Columns_Code, Columns_Name, Control_Type, Is_Ref, Is_Defined_Values, Is_Multiple_Select, Ref_Table, Ref_Display_Field, Ref_Value_Field, Additional_Condition, Is_Add_OnScreen )
		SELECT DISTINCT ec.Columns_Code, Columns_Name, Control_Type, Is_Ref, Is_Defined_Values, Is_Multiple_Select, 
				Ref_Table, Ref_Display_Field, Ref_Value_Field, Additional_Condition, Is_Add_OnScreen 
		FROM (SELECT DISTINCT Extended_Group_Code, Columns_Code, Group_Control_Order, Validations, Allow_Import 
				FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @Record_Code) absd 
				INNER JOIN Extended_Columns ec ON absd.Columns_Code = ec.Columns_Code

		BEGIN
			PRINT 'Unpivoting Title data for further validation'
			INSERT INTO #TempTitleUnPivot(DMBookingSheetDataCode, DMMasterImportCode , ColumnHeader, DataType, TitleData)
			SELECT DM_Booking_Sheet_Data_Code, DM_Master_Import_Code, LTRIM(RTRIM(ColumnHeader)), DataType, LTRIM(RTRIM(TitleData))
			FROM
			(
				SELECT * FROM #TempTitle
			) AS cp
			UNPIVOT 
			(
				TitleData FOR ColumnHeader IN (Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100 ,
		                        COL101, COL102, COL103, COL104, COL105, COL106, COL107, COL108, COL109, COL110, COL111, COL112, COL113, COL114, COL115, COL116, COL117, COL118, COL119, COL120, COL121, COL122, COL123, COL124, COL125, COL126, COL127, COL128, COL129, COL130, COL131, COL132, COL133, COL134, COL135, COL136, COL137, COL138, COL139, COL140, COL141, COL142, COL143, COL144, COL145, COL146, COL147, COL148, COL149, COL150, COL151, COL152, COL153, COL154, COL155, COL156, COL157, COL158, COL159, COL160, COL161, COL162, COL163, COL164, COL165, COL166, COL167, COL168, COL169, COL170, COL171, COL172, COL173, COL174, COL175, COL176, COL177, COL178, COL179, COL180, COL181, COL182, COL183, COL184, COL185, COL186, COL187, COL188, COL189, COL190, COL191, COL192, COL193, COL194, COL195, COL196, COL197, COL198, COL199, COL200)
			) AS up

			UPDATE T2 SET T2.ColumnHeader = T1.TitleData
			FROM (
				SELECT * FROM #TempTitleUnPivot WHERE DataType LIKE '%H%' 
			) AS T1
			INNER JOIN (SELECT * FROM #TempTitleUnPivot) T2 ON T1.ColumnHeader = T2.ColumnHeader

			UPDATE ttup SET ColumnCode = (SELECT Columns_Code FROM #TempExtendedColumn tec WHERE tec.Columns_Name COLLATE SQL_Latin1_General_CP1_CI_AS = ttup.ColumnHeader) FROM #TempTitleUnPivot ttup
			
			UPDATE ttup SET 
			Validations = (SELECT Validations FROM (SELECT DISTINCT Columns_Code, Validations FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @Record_Code) AS T WHERE T.Columns_Code = ttup.ColumnCode),
			Allow_Import = (SELECT Allow_Import FROM (SELECT DISTINCT Columns_Code, Validations, Allow_Import FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @Record_Code) AS T WHERE T.Columns_Code = ttup.ColumnCode) FROM #TempTitleUnPivot ttup

			--DELETE FROM #TempTitleUnPivot WHERE DataType LIKE '%H%'
			--DELETE FROM #TempTitleUnPivot WHERE Allow_Import LIKE '%E%'

			INSERT INTO #TempTitleEpisodeTable (DMBookingSheetDataCode, DMMasterImportCode, TitleName, EpisodeNo)
			SELECT DMBookingSheetDataCode, DMMasterImportCode,
				(SELECT TOP 1 b.TitleData FROM #TempTitleUnPivot b WHERE UPPER(b.ColumnHeader) IN ('TITLE') AND b.DMBookingSheetDataCode = a.DMBookingSheetDataCode) AS TitleName,
				(SELECT TOP 1 b.TitleData FROM #TempTitleUnPivot b WHERE UPPER(b.ColumnHeader) IN ('EPISODE NUMBER') AND b.DMBookingSheetDataCode = a.DMBookingSheetDataCode) AS EpisodeNo
			FROM (
				SELECT DISTINCT DMBookingSheetDataCode, DMMasterImportCode FROM #TempTitleUnPivot WHERE UPPER(ColumnHeader) IN ('TITLE', 'EPISODE NUMBER')
			) AS a

			INSERT INTO #TempTitleAndContetCode (DMBookingSheetDataCode, DMMasterImportCode, Title_Code, Title_Content_Code)

			SELECT DISTINCT ttp.DMBookingSheetDataCode, ttp.DMMasterImportCode, absd.Title_Code, absd.Title_Content_Code FROM
			(Select * from #TempTitleEpisodeTable where UPPER(TitleName) <> 'TITLE') ttp 
				INNER JOIN (SELECT CAST(ti.Title_Name AS NVARCHAR(MAX)) + '(' + CAST(Episode_No AS NVARCHAR(MAX)) + ')' AS Title_Name, ti.Title_Code, tc.Title_Content_Code, tc.Episode_No  FROM Title ti INNER JOIN (SELECT DISTINCT Title_Code, Title_Content_Code FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @Record_Code) tt ON ti.Title_Code = tt.Title_Code
				INNER JOIN Title_Content tc ON tc.Title_Content_Code = tt.Title_Content_Code AND tc.Title_Code = tt.Title_Code) t ON LTRIM(RTRIM(ttp.TitleName + '(' + CAST(ttp.EpisodeNo AS NVARCHAR(MAX)) + ')')) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(t.Title_Name)) AND ttp.EpisodeNo = t.Episode_No
				INNER JOIN (SELECT DISTINCT Title_Code, Title_Content_Code FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @Record_Code) AS absd ON absd.Title_Code = t.Title_Code AND t.Title_Content_Code = absd.Title_Content_Code

			--Select DISTINCT ttp.DMBookingSheetDataCode, ttp.DMMasterImportCode, absd.Title_Code, absd.Title_Content_Code from (SELECT * FROM #TempTitleUnPivot WHERE ColumnHeader = 'TitleName') ttp 
			--	INNER JOIN (SELECT CAST(tc.Episode_Title AS NVARCHAR(MAX)) + '(' + CAST(Episode_No AS NVARCHAR(MAX)) + ')' AS Title_Name, ti.Title_Code, tc.Title_Content_Code  FROM Title ti INNER JOIN (SELECT DISTINCT Title_Code, Title_Content_Code FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @Record_Code) tt ON ti.Title_Code = tt.Title_Code
			--	INNER JOIN Title_Content tc ON tc.Title_Content_Code = tt.Title_Content_Code AND tc.Title_Code = tt.Title_Code) t ON LTRIM(RTRIM(ttp.TitleData)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(t.Title_Name))
			--	INNER JOIN (SELECT DISTINCT Title_Code, Title_Content_Code FROM AL_Booking_Sheet_Details WHERE AL_Booking_Sheet_Code = @Record_Code) AS absd ON absd.Title_Code = t.Title_Code AND t.Title_Content_Code = absd.Title_Content_Code
			--WHERE ttp.ColumnHeader = 'TitleName'

			DELETE FROM #TempTitleUnPivot WHERE DataType LIKE '%H%'
			DELETE FROM #TempTitleUnPivot WHERE Allow_Import LIKE '%E%'

			UPDATE ttup SET Title_Code = (SELECT TOP 1 Title_Code FROM #TempTitleAndContetCode tec WHERE tec.DMBookingSheetDataCode = ttup.DMBookingSheetDataCode) FROM #TempTitleUnPivot ttup
			UPDATE ttup SET Title_Content_Code = (SELECT TOP 1 Title_Content_Code FROM #TempTitleAndContetCode tec WHERE tec.DMBookingSheetDataCode = ttup.DMBookingSheetDataCode) FROM #TempTitleUnPivot ttup
			
			UPDATE T1 SET T1.IsError = '', ErrorMessage = '' FROM #TempTitleUnPivot T1
		END

		DECLARE @DMBookingSheetDataCode NVARCHAR(MAX), @DMMasterImportCode NVARCHAR(MAX), @ColumnCode NVARCHAR(MAX), @Validations NVARCHAR(MAX),  @TitleData NVARCHAR(MAX), @ColumnHeader NVARCHAR(MAX)
		DECLARE @Ref_Table NVARCHAR(MAX), @Ref_Display_Field NVARCHAR(MAX), @Ref_Value_Field NVARCHAR(MAX), @query NVARCHAR(MAX) = '', @Count_Ref INT = 0, @Count_Ref_Input INT = 0

		BEGIN
		PRINT 'Insert Final #TempResult'
		
			DECLARE db_cursor_Final_Result CURSOR FOR 
			SELECT DMBookingSheetDataCode, DMMasterImportCode, ColumnCode, Validations, TitleData, ColumnHeader FROM #TempTitleUnPivot --(NOLOCK) 
		
			OPEN db_cursor_Final_Result  
			FETCH NEXT FROM db_cursor_Final_Result INTO @DMBookingSheetDataCode, @DMMasterImportCode, @ColumnCode, @Validations, @TitleData, @ColumnHeader  
			
			WHILE @@FETCH_STATUS = 0  
			BEGIN 

				IF (UPPER(@Validations) LIKE '%MAN%')
				BEGIN

					IF(@TitleData = NULL OR @TitleData = '')
					BEGIN
						UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @ColumnHeader +') has mandatory'
						WHERE DMBookingSheetDataCode = @DMBookingSheetDataCode AND DMMasterImportCode = @DMMasterImportCode AND ColumnCode = @ColumnCode
					END
				END	
				
				IF (UPPER(@Validations) LIKE '%REF%')
				BEGIN

					IF(@TitleData != NULL OR @TitleData != '')

					BEGIN					   
						SELECT @Ref_Table = Ref_Table, @Ref_Display_Field = Ref_Display_Field, @Ref_Value_Field = Ref_Value_Field FROM Extended_Columns WHERE Columns_Code = @ColumnCode;
						SET @query = 'INSERT INTO #TempCountRef (Count_Ref) SELECT COUNT (*) AS Count_Ref FROM '+@Ref_Table+' WHERE '+@Ref_Display_Field+' IN (SELECT number FROM DBO.fn_Split_withdelemiter('''+(SELECT REPLACE(@TitleData, '''',''''''))+''', '',''))'					   
						EXEC(@query);
						SELECT @Count_Ref = Count_Ref from #TempCountRef
						SELECT @Count_Ref_Input = COUNT(number) FROM DBO.fn_Split_withdelemiter(''+(SELECT REPLACE(@TitleData, '',''''))+'', ',')

						DELETE FROM #TempCountRef;

						IF(@Count_Ref != @Count_Ref_Input)
						BEGIN
								UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @ColumnHeader +') Data Mismatch'
								WHERE DMBookingSheetDataCode = @DMBookingSheetDataCode AND DMMasterImportCode = @DMMasterImportCode AND ColumnCode = @ColumnCode
						END					
					END	
				END
				
				IF (UPPER(@Validations) LIKE '%0%')
				BEGIN
					IF(@TitleData != NULL OR @TitleData != '')

					BEGIN					   
						IF(@TitleData!='0' AND @TitleData!='1' AND UPPER(@TitleData) != 'REMOVE')
						BEGIN
							UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @ColumnHeader +') Data Mismatch'
							WHERE DMBookingSheetDataCode = @DMBookingSheetDataCode AND DMMasterImportCode = @DMMasterImportCode AND ColumnCode = @ColumnCode
						END						
					END					
				END

				IF (UPPER(@Validations) LIKE '%DATE%')
				BEGIN
					IF(@TitleData != NULL OR @TitleData != '')

					BEGIN					   
						IF NOT EXISTS(Select ISDATE(@TitleData))
						BEGIN
							UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @ColumnHeader +') has wrong date format'
							WHERE DMBookingSheetDataCode = @DMBookingSheetDataCode AND DMMasterImportCode = @DMMasterImportCode AND ColumnCode = @ColumnCode
						END						
					END					
				END

				FETCH NEXT FROM db_cursor_Final_Result INTO @DMBookingSheetDataCode, @DMMasterImportCode, @ColumnCode, @Validations, @TitleData, @ColumnHeader 
			END 
			CLOSE db_cursor_Final_Result  
			DEALLOCATE db_cursor_Final_Result 
		END

		INSERT INTO #TempTitleErrorTable (DMBookingSheetDataCode, Title_Code, Title_Content_Code, IsError, Error_Msg)
			SELECT DISTINCT T.DMBookingSheetDataCode, T.Title_Code, T.Title_Content_Code, T.IsError, STUFF((
			SELECT ', ' + ttup.ErrorMessage  FROM #TempTitleUnPivot ttup 
			WHERE ttup.IsError = 'Y' AND ttup.DMBookingSheetDataCode =T.DMBookingSheetDataCode
			ORDER BY ttup.DMBookingSheetDataCode
			FOR XML PATH('')), 1, 2, '') AS Error_Msg FROM #TempTitleUnPivot T WHERE T.IsError = 'Y'
		UNION
			SELECT DISTINCT DMBookingSheetDataCode, ISNULL(Title_Code,''), ISNULL(Title_Content_Code,''), IsError, '~Invalid Title For Current Booking Sheet.' AS Error_Msg FROM #TempTitleUnPivot WHERE ISNULL(Title_Code,'') = ''	AND ISNULL(Title_Content_Code,'') = ''

		--Select * from #TempTitleUnPivot;
		UPDATE DM_Booking_Sheet_Data SET Record_Status = 'C', Error_Message = NULL WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND  Data_Type <> 'H' AND Sheet_Name = 'Show' AND Record_Status IS NULL

		IF EXISTS(SELECT * FROM #TempTitleErrorTable)
		BEGIN
			UPDATE DM_Master_Import SET Status = 'E' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

			UPDATE DM_Booking_Sheet_Data SET Record_Status = 'E' , Error_Message = ttet.Error_Msg 
			FROM #TempTitleErrorTable ttet WHERE ttet.DMBookingSheetDataCode = DM_Booking_Sheet_Data.DM_Booking_Sheet_Data_Code	
		END
		ELSE
		BEGIN
			IF EXISTS(SELECT * FROM #TempTitleUnPivot)
			BEGIN				
				IF NOT EXISTS(SELECT * FROM DM_Master_Import WHERE File_Type = 'B' AND Status = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)
				BEGIN
					UPDATE DM_Master_Import SET Status = 'S' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
				END		
			END
		END
		
		IF EXISTS (SELECT DISTINCT ttup.Title_Code FROM #TempTitleUnPivot ttup WHERE ttup.Title_Code NOT IN (SELECT ttet.Title_Code FROM #TempTitleErrorTable ttet))
		BEGIN
			--UPDATE AL_Booking_Sheet_Details SET Columns_Value= T.TitleData , Action_Date = GETDATE(), Cell_Status = 'C'
			--FROM 
			--(SELECT DISTINCT ttup.Title_Code,@Record_Code AS Record_Code, ttup.ColumnCode, ttup.TitleData FROM #TempTitleUnPivot ttup WHERE ttup.Title_Code NOT IN (SELECT ttet.Title_Code FROM #TempTitleErrorTable ttet)) AS T
			--WHERE AL_Booking_Sheet_Details.AL_Booking_Sheet_Code = T.Record_Code
			--AND AL_Booking_Sheet_Details.Title_Code = T.Title_Code
			--AND AL_Booking_Sheet_Details.Columns_Code = T.ColumnCode		
			
			UPDATE absd SET Columns_Value= T.TitleData , Action_Date = GETDATE(), Cell_Status = 'C' 
			FROM AL_Booking_Sheet_Details absd 
			INNER JOIN (SELECT DISTINCT ttup.Title_Code, ttup.Title_Content_Code, @Record_Code AS Record_Code, ttup.ColumnCode, ttup.TitleData FROM #TempTitleUnPivot ttup WHERE ttup.Title_Code NOT IN (SELECT ttet.Title_Code FROM #TempTitleErrorTable ttet)) AS T 
			ON absd.Title_Code = T.Title_Code 
			AND absd.Title_Content_Code = T.Title_Content_Code 
			AND absd.AL_Booking_Sheet_Code = T.Record_Code 
			AND absd.Columns_Code = T.ColumnCode

		END

		UPDATE AL_Booking_Sheet SET Record_Status = 'I' WHERE AL_Booking_Sheet_Code = @Record_Code

		END TRY
		BEGIN CATCH
			UPDATE DM_Master_Import SET Status = 'E' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
		END CATCH

	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_Booking_Sheet_Show_Import_Utility_PIII]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END