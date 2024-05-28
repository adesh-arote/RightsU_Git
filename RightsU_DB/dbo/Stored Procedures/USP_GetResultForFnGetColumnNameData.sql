
CREATE PROCEDURE USP_GetResultForFnGetColumnNameData
(
	@Columns_Value_Code INT,
	@Is_Defined_Values varchar(10),
	@Record_code INT,
	@Map_Extended_Columns_Code INT
)
AS
BEGIN

	DECLARE  @Result NVARCHAR(3000) = '', @Control_Type VARCHAR(50)= '', @IsRef CHAR(1) = 'N', @IsDef CHAR(1) = 'N', @IsMultiple CHAR(1) = 'N', @RefTable VARCHAR(100) = '', @Condition VARCHAR(100) = ''
	DECLARE @RefDisplayField VARCHAR(100) = ''
	DECLARE @RefValueField VARCHAR(1000) = ''

	SELECT @IsRef = Is_Ref, @Control_Type = Control_Type, @IsDef = Is_Defined_Values, @IsMultiple = Is_Multiple_Select, @RefTable = Ref_Table, @Condition = Additional_Condition, @RefDisplayField = Ref_Display_Field, @RefValueField = Ref_Value_Field
	FROM Extended_Columns WHERE Columns_Code IN (
		SELECT Columns_Code FROM Map_Extended_Columns WHERE Map_Extended_Columns_Code = @Map_Extended_Columns_Code
	)

	IF(@Control_Type = 'TXT')
	BEGIN
	
		SELECT  @Result = Column_Value FROM  Map_Extended_Columns WHERE Map_Extended_Columns_Code = @Map_Extended_Columns_Code
	
	END
	ELSE IF(@Control_Type = 'DDL')
	BEGIN
		
		IF(@IsRef = 'Y' AND @IsDef = 'Y' AND @IsMultiple = 'Y')
		BEGIN

			SET @Result = LTRIM(RTRIM(STUFF((
				SELECT ', ' + CAST(ECV.Columns_Value AS VARCHAR(100))
				FROM Map_Extended_Columns_Details MECD
				INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MECD.Columns_Value_Code
				WHERE MECD.Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)
				FOR XML PATH(''),root('MyString'), type
			).value('/MyString[1]','NVARCHAR(max)'), 1, 1, '')))

		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND @IsMultiple = 'Y' AND @RefTable = 'TALENT')
		BEGIN

			SET @Result = LTRIM(RTRIM(STUFF((
				SELECT DISTINCT ', ' + T.Talent_Name FROM Map_Extended_Columns_Details MECD
				INNER JOIN Talent T ON T.Talent_Code = MECD.Columns_Value_Code
				WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)
				FOR XML PATH(''),root('MyString'), type
			).value('/MyString[1]','NVARCHAR(max)'), 1, 1, '')))

		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'Y' AND @IsMultiple = 'N')
		BEGIN

			SELECT @Result = CAST(ECV.Columns_Value AS VARCHAR(100))
			FROM Map_Extended_Columns MECD
			INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MECD.Columns_Value_Code
			WHERE MECD.Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)

		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND @IsMultiple = 'N' AND @RefTable = 'TALENT')
		BEGIN

			SELECT @Result = T.Talent_Name 
			FROM Map_Extended_Columns MECD
			INNER JOIN Talent T ON T.Talent_Code = MECD.Columns_Value_Code
			WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)

		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND @RefDisplayField IS NOT NULL)
		BEGIN
			
			DECLARE @RunQuery1 VARCHAR(MAX) = ('SELECT @Result = A.' + @RefDisplayField + ' FROM Map_Extended_Columns MEC INNER JOIN ' + @RefTable + ' A on A.' + @RefValueField + '= MEC.Columns_Value_Code
			WHERE Map_Extended_Columns_Code IN (' + CAST(@Map_Extended_Columns_Code AS VARCHAR(1000)) + ')')
			EXEC @RunQuery1

			IF (@Result = '')
			BEGIN
				DECLARE @RunQuery2 VARCHAR(MAX) = ('SELECT @Result = B.' + @RefDisplayField + ' FROM Map_Extended_Columns_Details MECD INNER JOIN ' + @RefTable + ' B ON B.' + @RefValueField + '= MECD.Columns_Value_Code
				WHERE Map_Extended_Columns_Code IN (' + CAST(@Map_Extended_Columns_Code AS VARCHAR(1000)) + ')')
				EXEC @RunQuery2
			END

		END

	END
	RETURN @Result 
END