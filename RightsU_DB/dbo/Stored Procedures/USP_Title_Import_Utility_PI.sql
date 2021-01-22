CREATE PROC [dbo].[USP_Title_Import_Utility_PI] 
(  
	@Title_Import_Utility Title_Import_Utility READONLY, 
	@CallFor NVARCHAR(MAX),
	@User_Code INT= 143 ,
	@DM_Master_Import_Code INT
)
AS
BEGIN
	IF(OBJECT_ID('tempdb..#Temp_DM_TIUD') IS NOT NULL) DROP TABLE #Temp_DM_TIUD
	IF(OBJECT_ID('tempdb..#ColumnName') IS NOT NULL) DROP TABLE #ColumnName

	SET NOCOUNT ON
	--HV = HEADER VALIDATION
	--INS = INSERTION
	--CNM = Column Name Mismatch
	--CCM = Coumn Count Mismatch
	--CND = Column Name Duplicate
	--CNE = Column Name Error
	DECLARE @i INT = 1,
			@Output VARCHAR(MAX) = '',
			@CN_Count INT =0,
			@DM_TIU_Count INT =0,
			@Result NVARCHAR(200) = 'S~File Uploaded Successfully~',
			--@CallFor NVARCHAR(MAX) = 'HV',
			@ColNameMismatch NVARCHAR(MAX) = '',
			@ColNameDuplicate NVARCHAR(MAX) = '',
			@IsError CHAR(1) = 'N'

	CREATE TABlE #Temp_DM_TIUD(
		DM_Master_Import_Code INT,
		COL1 NVARCHAR(MAX),
		COL2 NVARCHAR(MAX),
		COL3 NVARCHAR(MAX),
		COL4 NVARCHAR(MAX),
		COL5 NVARCHAR(MAX),
		COL6 NVARCHAR(MAX),
		COL7 NVARCHAR(MAX),
		COL8 NVARCHAR(MAX),
		COL9 NVARCHAR(MAX),
		COL10 NVARCHAR(MAX),
		COL11 NVARCHAR(MAX),
		COL12 NVARCHAR(MAX),
		COL13 NVARCHAR(MAX),
		COL14 NVARCHAR(MAX),
		COL15 NVARCHAR(MAX),
		COL16 NVARCHAR(MAX),
		COL17 NVARCHAR(MAX),
		COL18 NVARCHAR(MAX),
		COL19 NVARCHAR(MAX),
		COL20 NVARCHAR(MAX),
		COL21 NVARCHAR(MAX),
		COL22 NVARCHAR(MAX),
		COL23 NVARCHAR(MAX),
		COL24 NVARCHAR(MAX),
		COL25 NVARCHAR(MAX),
		COL26 NVARCHAR(MAX),
		COL27 NVARCHAR(MAX),
		COL28 NVARCHAR(MAX),
		COL29 NVARCHAR(MAX),
		COL30 NVARCHAR(MAX),
		COL31 NVARCHAR(MAX),
		COL32 NVARCHAR(MAX),
		COL33 NVARCHAR(MAX),
		COL34 NVARCHAR(MAX),
		COL35 NVARCHAR(MAX),
		COL36 NVARCHAR(MAX),
		COL37 NVARCHAR(MAX),
		COL38 NVARCHAR(MAX),
		COL39 NVARCHAR(MAX),
		COL40 NVARCHAR(MAX),
		COL41 NVARCHAR(MAX),
		COL42 NVARCHAR(MAX),
		COL43 NVARCHAR(MAX),
		COL44 NVARCHAR(MAX),
		COL45 NVARCHAR(MAX),
		COL46 NVARCHAR(MAX),
		COL47 NVARCHAR(MAX),
		COL48 NVARCHAR(MAX),
		COL49 NVARCHAR(MAX),
		COL50 NVARCHAR(MAX),
		COL51 NVARCHAR(MAX),
		COL52 NVARCHAR(MAX),
		COL53 NVARCHAR(MAX),
		COL54 NVARCHAR(MAX),
		COL55 NVARCHAR(MAX),
		COL56 NVARCHAR(MAX),
		COL57 NVARCHAR(MAX),
		COL58 NVARCHAR(MAX),
		COL59 NVARCHAR(MAX),
		COL60 NVARCHAR(MAX),
		COL61 NVARCHAR(MAX),
		COL62 NVARCHAR(MAX),
		COL63 NVARCHAR(MAX),
		COL64 NVARCHAR(MAX),
		COL65 NVARCHAR(MAX),
		COL66 NVARCHAR(MAX),
		COL67 NVARCHAR(MAX),
		COL68 NVARCHAR(MAX),
		COL69 NVARCHAR(MAX),
		COL70 NVARCHAR(MAX),
		COL71 NVARCHAR(MAX),
		COL72 NVARCHAR(MAX),
		COL73 NVARCHAR(MAX),
		COL74 NVARCHAR(MAX),
		COL75 NVARCHAR(MAX),
		COL76 NVARCHAR(MAX),
		COL77 NVARCHAR(MAX),
		COL78 NVARCHAR(MAX),
		COL79 NVARCHAR(MAX),
		COL80 NVARCHAR(MAX),
		COL81 NVARCHAR(MAX),
		COL82 NVARCHAR(MAX),
		COL83 NVARCHAR(MAX),
		COL84 NVARCHAR(MAX),
		COL85 NVARCHAR(MAX),
		COL86 NVARCHAR(MAX),
		COL87 NVARCHAR(MAX),
		COL88 NVARCHAR(MAX),
		COL89 NVARCHAR(MAX),
		COL90 NVARCHAR(MAX),
		COL91 NVARCHAR(MAX),
		COL92 NVARCHAR(MAX),
		COL93 NVARCHAR(MAX),
		COL94 NVARCHAR(MAX),
		COL95 NVARCHAR(MAX),
		COL96 NVARCHAR(MAX),
		COL97 NVARCHAR(MAX),
		COL98 NVARCHAR(MAX),
		COL99 NVARCHAR(MAX),
		COL100 NVARCHAR(MAX)
	)

	CREATE TABLE #ColumnName(
		Id INT PRIMARY KEY IDENTITY(1,1),
		Column_Name NVARCHAR(MAX)
	)

	IF @CallFor = 'INS'
	BEGIN
		INSERT INTO DM_Title_Import_Utility_Data (DM_Master_Import_Code, Col1  ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100)
		SELECT @DM_Master_Import_Code, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100
		FROM @Title_Import_Utility
	END
	ELSE IF @CallFor ='HV'
	BEGIN
		INSERT INTO #Temp_DM_TIUD( COL1 ,COL2 ,COL3 ,COL4 ,COL5 ,COL6 ,COL7 ,COL8 ,COL9 ,COL10 ,COL11 ,COL12 ,COL13 ,COL14 ,COL15 ,COL16 ,COL17 ,COL18 ,COL19 ,COL20 ,COL21 ,COL22 ,COL23 ,COL24 ,COL25 ,COL26 ,COL27 ,COL28 ,COL29 ,COL30 ,COL31 ,COL32 ,COL33 ,COL34 ,COL35 ,COL36 ,COL37 ,COL38 ,COL39 ,COL40 ,COL41 ,COL42 ,COL43 ,COL44 ,COL45 ,COL46 ,COL47 ,COL48 ,COL49 ,COL50 ,COL51 ,COL52 ,COL53 ,COL54 ,COL55 ,COL56 ,COL57 ,COL58 ,COL59 ,COL60 ,COL61 ,COL62 ,COL63 ,COL64 ,COL65 ,COL66 ,COL67 ,COL68 ,COL69 ,COL70 ,COL71 ,COL72 ,COL73 ,COL74 ,COL75 ,COL76 ,COL77 ,COL78 ,COL79 ,COL80 ,COL81 ,COL82 ,COL83 ,COL84 ,COL85 ,COL86 ,COL87 ,COL88 ,COL89 ,COL90 ,COL91 ,COL92 ,COL93 ,COL94 ,COL95 ,COL96 ,COL97 ,COL98 ,COL99 ,COL100)
		SELECT  COL1 ,COL2 ,COL3 ,COL4 ,COL5 ,COL6 ,COL7 ,COL8 ,COL9 ,COL10 ,COL11 ,COL12 ,COL13 ,COL14 ,COL15 ,COL16 ,COL17 ,COL18 ,COL19 ,COL20 ,COL21 ,COL22 ,COL23 ,COL24 ,COL25 ,COL26 ,COL27 ,COL28 ,COL29 ,COL30 ,COL31 ,COL32 ,COL33 ,COL34 ,COL35 ,COL36 ,COL37 ,COL38 ,COL39 ,COL40 ,COL41 ,COL42 ,COL43 ,COL44 ,COL45 ,COL46 ,COL47 ,COL48 ,COL49 ,COL50 ,COL51 ,COL52 ,COL53 ,COL54 ,COL55 ,COL56 ,COL57 ,COL58 ,COL59 ,COL60 ,COL61 ,COL62 ,COL63 ,COL64 ,COL65 ,COL66 ,COL67 ,COL68 ,COL69 ,COL70 ,COL71 ,COL72 ,COL73 ,COL74 ,COL75 ,COL76 ,COL77 ,COL78 ,COL79 ,COL80 ,COL81 ,COL82 ,COL83 ,COL84 ,COL85 ,COL86 ,COL87 ,COL88 ,COL89 ,COL90 ,COL91 ,COL92 ,COL93 ,COL94 ,COL95 ,COL96 ,COL97 ,COL98 ,COL99 ,COL100
		FROM @Title_Import_Utility

		SELECT @DM_TIU_Count = COUNT(Display_Name) FROM DM_Title_Import_Utility WHERE Is_Active='Y'

		WHILE (@i <= 100)
		BEGIN
			SET @Output = 'Col' + CAST(@i AS VARCHAR)

			INSERT INTO #ColumnName (Column_Name)
			EXEC ('SELECT TOP 1 ' + @Output +' AS Column_Name FROM #Temp_DM_TIUD' )

			SET @i = @i + 1	
		END

		SELECT @ColNameDuplicate =   STUFF(( SELECT  ', ' + Column_Name FROM #ColumnName WHERE  Column_Name IS NOT NULL GROUP BY Column_Name HAVING  COUNT(Column_Name) > 1
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
		
		IF(@ColNameDuplicate <> '')
			SELECT @Result = 'CND~Column Name Duplicate~'+@ColNameDuplicate , @IsError = 'Y' --Column Name Mismatch

	
		IF (EXISTS (SELECT Column_Name FROM #ColumnName WHERE Column_Name = 'Excel Sr. No') AND @IsError = 'N')
		BEGIN
			DELETE FROM #ColumnName  WHERE Column_Name = 'Excel Sr. No' 
			SELECT @CN_Count = COUNT(*) FROM #ColumnName WHERE Column_Name IS NOT NULL AND Column_Name <> ''
	
			IF(@CN_Count <> @DM_TIU_Count)
			BEGIN 
				DELETE FROM #ColumnName WHERE Column_Name IS NULL
				DELETE FROM #ColumnName WHERE Column_Name = ''
		
				SELECT @ColNameMismatch =  STUFF(( SELECT  ', ' + Display_Name FROM  DM_Title_Import_Utility where Display_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN
				(
					SELECT DISTINCT  CN.Column_Name  FROM DM_Title_Import_Utility TIU
					INNER JOIN #ColumnName CN ON CN.Column_Name COLLATE SQL_Latin1_General_CP1_CI_AS = TIU.Display_Name
					WHERE TIU.Is_Active = 'Y'
				) AND  Is_Active = 'Y'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
	
				SELECT @ColNameMismatch = ISNULL(@ColNameMismatch ,'') + ',' +  ISNULL( STUFF(( SELECT  ', ' + Column_Name
				FROM #ColumnName WHERE Column_Name <> '' AND
				Column_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Display_Name FROM  DM_Title_Import_Utility WHERE Is_Active='Y')
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''),'')

				SELECT @Result = 'CCM~Column Count Mismatch~'+@ColNameMismatch , @IsError = 'Y' --Column Count Mismatch
			END
					
			IF ( @IsError = 'N')
			BEGIN
				DELETE FROM #ColumnName WHERE Column_Name IS NULL
				DELETE FROM #ColumnName WHERE Column_Name = ''
			
				SELECT @CN_Count = COUNT(*) FROM #ColumnName
			END

			IF (@CN_Count = @DM_TIU_Count) AND @IsError = 'N'
			BEGIN
				SELECT @ColNameMismatch =  STUFF(( SELECT  ', ' + Display_Name FROM  DM_Title_Import_Utility where Display_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN
				(
					SELECT DISTINCT  CN.Column_Name  FROM DM_Title_Import_Utility TIU
					INNER JOIN #ColumnName CN ON CN.Column_Name COLLATE SQL_Latin1_General_CP1_CI_AS = TIU.Display_Name
					WHERE TIU.Is_Active = 'Y'
				) AND  Is_Active = 'Y'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')

				SELECT @ColNameMismatch = ISNULL(@ColNameMismatch ,'') + ',' +  STUFF(( SELECT  ', ' + Column_Name
				FROM #ColumnName WHERE Column_Name <> '' AND
				Column_Name COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Display_Name FROM  DM_Title_Import_Utility WHERE Is_Active='Y')
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')

				IF @ColNameMismatch <> ''
					SET @Result = 'CNM~Column Name Mismatch~'+@ColNameMismatch --Column Name Mismatch
			END
		END
		ELSE IF (@IsError = 'N')
			SET @Result = 'CNE~Column Not Found~Excel Sr. No'
	END

	SELECT @Result AS 'Result'
	IF(OBJECT_ID('tempdb..#Temp_DM_TIUD') IS NOT NULL) DROP TABLE #Temp_DM_TIUD
	IF(OBJECT_ID('tempdb..#ColumnName') IS NOT NULL) DROP TABLE #ColumnName
END

--truncate table DM_Title_Import_Utility_Data
--select * from DM_Title_Import_Utility_Data
