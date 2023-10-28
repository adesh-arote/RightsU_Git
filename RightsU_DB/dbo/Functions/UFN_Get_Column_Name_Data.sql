CREATE FUNCTION [dbo].[UFN_Get_Column_Name_Data] 
(
	@Columns_Value_Code INT,
	@Is_Defined_Values varchar(10),
	@Record_code INT,
	@Map_Extended_Columns_Code INT
)
RETURNS NVARCHAR(1000)
AS
BEGIN

	DECLARE  @Result NVARCHAR(3000) = '', @Control_Type VARCHAR(50)= '', @IsRef CHAR(1) = 'N', @IsDef CHAR(1) = 'N', @IsMultiple CHAR(1) = 'N', @RefTable VARCHAR(100) = '', @Condition VARCHAR(100) = ''

	SELECT @IsRef = Is_Ref, @Control_Type = Control_Type, @IsDef = Is_Defined_Values, @IsMultiple = Is_Multiple_Select, @RefTable = Ref_Table, @Condition = Additional_Condition
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
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND (@RefTable = 'Banner' OR @RefTable = 'BANNER'))
		BEGIN
			
			SELECT @Result = B.Banner_Name
			FROM Map_Extended_Columns_Details MECD
			INNER JOIN Banner B ON B.Banner_Code = MECD.Columns_Value_Code
			WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)

			IF (@Result = '')
			BEGIN
				SELECT @Result = B.Banner_Name
				FROM Map_Extended_Columns MEC
				INNER JOIN Banner B ON B.Banner_Code = MEC.Columns_Value_Code
				WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)
			END
		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND (@RefTable = 'AL_Lab' OR @RefTable = 'AL_LAB'))
		BEGIN
			
			SELECT @Result = A.AL_Lab_Name
			FROM Map_Extended_Columns_Details MECD
			INNER JOIN AL_Lab A ON A.AL_Lab_Code = MECD.Columns_Value_Code
			WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)

			IF (@Result = '')
			BEGIN
				SELECT @Result = A.AL_Lab_Name
				FROM Map_Extended_Columns MEC
				INNER JOIN AL_Lab A ON A.AL_Lab_Code = MEC.Columns_Value_Code
				WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)
			END
		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND (@RefTable = 'Version' OR @RefTable = 'VERSION'))
		BEGIN
			
			SELECT @Result = A.Version_Name
			FROM Map_Extended_Columns_Details MECD
			INNER JOIN Version A ON A.Version_Code = MECD.Columns_Value_Code
			WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)

			IF (@Result = '')
			BEGIN
				SELECT @Result = A.Version_Name
				FROM Map_Extended_Columns MEC
				INNER JOIN Version A ON A.Version_Code = MEC.Columns_Value_Code
				WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)
			END
		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND @IsMultiple = 'Y' AND (@RefTable = 'Language' or @RefTable = 'LANGUAGE'))
		BEGIN

			SET @Result = LTRIM(RTRIM(STUFF((
				SELECT DISTINCT ', ' + L.Language_Name FROM Map_Extended_Columns_Details MECD
				INNER JOIN Language L ON L.Language_Code = MECD.Columns_Value_Code
				WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)
				FOR XML PATH(''),root('MyString'), type
			).value('/MyString[1]','NVARCHAR(max)'), 1, 1, '')))

		END
		ELSE IF(@IsRef = 'Y' AND @IsDef = 'N' AND @IsMultiple = 'N' AND (@RefTable = 'Language' or @RefTable = 'LANGUAGE'))
		BEGIN

			SELECT @Result = L.Language_Name 
			FROM Map_Extended_Columns MECD
			INNER JOIN Language L ON L.Language_Code = MECD.Columns_Value_Code
			WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)

		END
		ELSE IF(@IsRef = 'N' AND @IsDef = 'Y' AND @IsMultiple = 'N')
		BEGIN
			SELECT @Result = ecv.Columns_Value 
			from Extended_Columns_Value ecv 
			INNER JOIN Map_Extended_Columns_Details mecd ON mecd.Columns_Value_Code = ecv.Columns_Value_Code
			WHERE Map_Extended_Columns_Code IN (@Map_Extended_Columns_Code)

		END
	END
	RETURN @Result 
END
