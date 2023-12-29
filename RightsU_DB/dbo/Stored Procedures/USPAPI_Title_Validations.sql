ALTER PROCEDURE [dbo].[USPAPI_Title_Validations]
	@InputValue NVARCHAR(MAX),
	@InputType VARCHAR(100)
AS
BEGIN
	If(LOWER(@InputType) = 'language')
	BEGIN
		IF EXISTS(SELECT Language_Code FROM Language (Nolock) WHERE Language_Name = @InputValue AND Is_Active='Y')
		BEGIN
			SELECT TOP 1 Language_Code as 'InputValueCode','' AS 'InvalidValue' FROM Language (Nolock) WHERE Language_Name = @InputValue AND Is_Active='Y'
		END
		ELSE
		SELECT  0 as 'InputValueCode',@InputValue AS 'InvalidValue'
	END

	If(LOWER(@InputType) = 'program')
	BEGIN
		IF EXISTS(SELECT Program_Code FROM Program (Nolock) WHERE Program_Name = @InputValue AND Is_Active='Y')
		BEGIN
			SELECT TOP 1 Program_Code as 'InputValueCode','' AS 'InvalidValue' FROM Program (Nolock) WHERE Program_Name = @InputValue AND Is_Active='Y'
		END
		ELSE
		SELECT  0 as 'InputValueCode',@InputValue AS 'InvalidValue'
	END

	If(LOWER(@InputType) = 'country')
	BEGIN
		DECLARE @TempCountry TABLE(Country_Name VARCHAR(255),Country_Code INT);

		INSERT INTO @TempCountry
		SELECT RTRIM(LTRIM(d.number)) as Country_Name,c.Country_Code from country c
		RIGHT JOIN dbo.fn_Split_withdelemiter(@InputValue,',') d ON RTRIM(LTRIM(d.number))=c.Country_Name 
		WHERE c.Is_Active='Y'

		IF EXISTS(SELECT * FROM @TempCountry WHERE Country_Code IS NULL)
		BEGIN
			SELECT  0 as 'InputValueCode',
					STUFF(
					(SELECT ',' + CAST(t2.Country_Name As VARCHAR)
						FROM @TempCountry t2
						WHERE t2.Country_Code IS NULL
						FOR XML PATH (''))
						, 1, 1, '')  AS 'InvalidValue'
		END
		ELSE
		BEGIN

			SELECT STUFF(
					(SELECT ',' + CAST(t2.Country_Code As VARCHAR)
						FROM @TempCountry t2						
						FOR XML PATH (''))
						, 1, 1, '')  AS 'InputValueCode','' AS 'InvalidValue'
		END
	END

	If(Lower(@InputType) = 'starcast' OR Lower(@InputType) = 'producer' OR Lower(@InputType) = 'director')
	BEGIN
		DECLARE @TempTalent TABLE(Talent_Name VARCHAR(255),Talent_Code INT);

		IF(Lower(@InputType) = 'starcast')
		BEGIN
			INSERT INTO @TempTalent
			SELECT RTRIM(LTRIM(d.number)) as 'Talent_Name',T.Talent_Code from Talent (NOLOCK) T
			INNER JOIN Talent_Role (NOLOCK) TR ON TR.Talent_Code = T.Talent_Code AND TR.Role_Code = 2 --for Star Cast
			RIGHT JOIN dbo.fn_Split_withdelemiter(@InputValue,',') d ON RTRIM(LTRIM(d.number))=T.Talent_Name 
			WHERE T.Is_Active='Y'
		END
		ELSE IF(Lower(@InputType) = 'producer')
		BEGIN
			INSERT INTO @TempTalent
			SELECT RTRIM(LTRIM(d.number)) as 'Talent_Name',T.Talent_Code from Talent (NOLOCK) T
			INNER JOIN Talent_Role (NOLOCK) TR ON TR.Talent_Code = T.Talent_Code AND TR.Role_Code = 4 --for Producer
			RIGHT JOIN dbo.fn_Split_withdelemiter(@InputValue,',') d ON RTRIM(LTRIM(d.number))=T.Talent_Name 
			WHERE T.Is_Active='Y'
		END
		ELSE IF(Lower(@InputType) = 'director')
		BEGIN
			INSERT INTO @TempTalent
			SELECT RTRIM(LTRIM(d.number)) as 'Talent_Name',T.Talent_Code from Talent (NOLOCK) T
			INNER JOIN Talent_Role (NOLOCK) TR ON TR.Talent_Code = T.Talent_Code AND TR.Role_Code = 1 --for Director
			RIGHT JOIN dbo.fn_Split_withdelemiter(@InputValue,',') d ON RTRIM(LTRIM(d.number))=T.Talent_Name 
			WHERE T.Is_Active='Y'
		END


		IF EXISTS(SELECT * FROM @TempTalent WHERE Talent_Code IS NULL)
		BEGIN
			SELECT  0 as 'InputValueCode',
					STUFF(
					(SELECT ',' + CAST(t2.Talent_Name As VARCHAR)
						FROM @TempTalent t2
						WHERE t2.Talent_Code IS NULL
						FOR XML PATH (''))
						, 1, 1, '')  AS 'InvalidValue'
		END
		ELSE
		BEGIN

			SELECT STUFF(
					(SELECT ',' + CAST(t2.Talent_Code As VARCHAR)
						FROM @TempTalent t2						
						FOR XML PATH (''))
						, 1, 1, '')  AS 'InputValueCode','' AS 'InvalidValue'
		END
	END

	If(Lower(@InputType) = 'assettype')
	BEGIN
		IF EXISTS(SELECT Deal_Type_Code FROM Deal_Type (Nolock) WHERE Deal_Type_Name = @InputValue AND Is_Active='Y')
		BEGIN
			SELECT TOP 1 Deal_Type_Code as 'InputValueCode','' AS 'InvalidValue' FROM Deal_Type (Nolock) WHERE Deal_Type_Name = @InputValue AND Is_Active='Y'
		END
		ELSE
		SELECT  0 as 'InputValueCode',@InputValue AS 'InvalidValue'

	END

	If(LOWER(@InputType) = 'genres')
	BEGIN
		DECLARE @TempGenres TABLE(Genres_Name VARCHAR(255),Genres_Code INT);

		INSERT INTO @TempGenres
		SELECT RTRIM(LTRIM(d.number)) as Genres_Name,g.Genres_Code from Genres g
		RIGHT JOIN dbo.fn_Split_withdelemiter(@InputValue,',') d ON RTRIM(LTRIM(d.number))=g.Genres_Name 
		WHERE g.Is_Active='Y'

		IF EXISTS(SELECT * FROM @TempGenres WHERE Genres_Code IS NULL)
		BEGIN
			SELECT  0 as 'InputValueCode',
					STUFF(
					(SELECT ',' + CAST(t2.Genres_Name As VARCHAR)
						FROM @TempGenres t2
						WHERE t2.Genres_Code IS NULL
						FOR XML PATH (''))
						, 1, 1, '')  AS 'InvalidValue'
		END
		ELSE
		BEGIN

			SELECT STUFF(
					(SELECT ',' + CAST(t2.Genres_Code As VARCHAR)
						FROM @TempGenres t2						
						FOR XML PATH (''))
						, 1, 1, '')  AS 'InputValueCode','' AS 'InvalidValue'
		END
	END

	If(LOWER(@InputType) = 'extendedgroup')
	BEGIN
		IF EXISTS(SELECT Extended_Group_Code FROM Extended_Group (Nolock) WHERE Module_Code = 27 AND Group_Name = @InputValue AND IsActive='Y')
		BEGIN
			SELECT TOP 1 Extended_Group_Code as 'InputValueCode','' AS 'InvalidValue' FROM Extended_Group (Nolock) WHERE Module_Code = 27 AND Group_Name = @InputValue AND IsActive='Y'
		END
		ELSE
		SELECT  0 as 'InputValueCode',@InputValue AS 'InvalidValue'
	END

	If(LOWER(@InputType) = 'extendedcolumns')
	BEGIN

		DECLARE @ExtendedGroup INT
		DECLARE @ExtendedColumn VARCHAR(100)

		SET @ExtendedColumn = (select SUBSTRING(@InputValue,CHARINDEX('|',@InputValue)+1,LEN(@InputValue)))

		SET @ExtendedGroup = (SELECT Top 1 number FROM dbo.fn_Split_withdelemiter(@InputValue,'|'))


		IF EXISTS(SELECT EC.Columns_Code FROM Extended_Columns EC (Nolock)
				  INNER JOIN Extended_Group_Config EGC ON EGC.Columns_Code=EC.Columns_Code
				  WHERE Extended_Group_Code = @ExtendedGroup AND EGC.Is_Active='Y' AND EC.Columns_Name = @ExtendedColumn)
		BEGIN
			SELECT TOP 1 EC.Columns_Code as 'InputValueCode','' AS 'InvalidValue' FROM Extended_Columns EC (Nolock) 
			INNER JOIN Extended_Group_Config EGC ON EGC.Columns_Code=EC.Columns_Code
			WHERE Extended_Group_Code = @ExtendedGroup AND EGC.Is_Active='Y' AND EC.Columns_Name = @ExtendedColumn
		END
		ELSE
		SELECT  0 as 'InputValueCode',@ExtendedColumn AS 'InvalidValue'
	END

	If(LOWER(@InputType) = 'extendedcolumnvalue')
	BEGIN

		DECLARE @ECCode INT
		DECLARE @ECValue VARCHAR(100)

		SET @ECValue = (select SUBSTRING(@InputValue,CHARINDEX('|',@InputValue)+1,LEN(@InputValue)))

		SET @ECCode = (SELECT Top 1 number FROM dbo.fn_Split_withdelemiter(@InputValue,'|'))


		DECLARE @Control_Type VARCHAR(10)
		DECLARE @Is_Ref CHAR(1)
		DECLARE @Is_Defined_Values CHAR(1)
		DECLARE @Is_Multiple_Select CHAR(1)
		DECLARE @Ref_Table VARCHAR(50)
		DECLARE @Ref_Display_Field VARCHAR(50)
		DECLARE @Ref_Value_Field VARCHAR(50)
		DECLARE @Additional_Condition VARCHAR(50)
		DECLARE @TempECValue TABLE(EC_Value VARCHAR(255),EC_Code INT);

		SELECT @Control_Type = Control_Type ,@Is_Ref = Is_Ref ,@Is_Defined_Values = Is_Defined_Values ,@Is_Multiple_Select = Is_Multiple_Select ,@Ref_Table = Ref_Table,
				@Ref_Display_Field = Ref_Display_Field ,@Ref_Value_Field = Ref_Value_Field ,@Additional_Condition = Additional_Condition
		FROM Extended_Columns WHERE Columns_Code = @ECCode

		IF(@Control_Type = 'TXT' OR @Control_Type = 'DATE')
		BEGIN
			SELECT  'True' as 'InputValueCode','' AS 'InvalidValue'
		END
		ELSE IF(@Control_Type = 'DDL' AND @Is_Ref = 'Y' AND @Is_Defined_Values = 'Y')
		BEGIN
			
			INSERT INTO @TempECValue
			SELECT RTRIM(LTRIM(d.number)) as EC_Value,ECV.Columns_Value_Code from Extended_Columns_Value ECV
			RIGHT JOIN dbo.fn_Split_withdelemiter(@ECValue,',') d ON RTRIM(LTRIM(d.number))=ECV.Columns_Value AND ECV.Columns_Code = @ECCode			

			IF EXISTS(SELECT * FROM @TempECValue WHERE EC_Code IS NULL)
			BEGIN
				SELECT  0 as 'InputValueCode',
						STUFF(
						(SELECT ',' + CAST(t2.EC_Value As VARCHAR)
							FROM @TempECValue t2
							WHERE t2.EC_Code IS NULL
							FOR XML PATH (''))
							, 1, 1, '')  AS 'InvalidValue'
			END
			ELSE
			BEGIN

				SELECT STUFF(
						(SELECT ',' + CAST(t2.EC_Code As VARCHAR)
							FROM @TempECValue t2						
							FOR XML PATH (''))
							, 1, 1, '')  AS 'InputValueCode','' AS 'InvalidValue'
			END
			
		END		
		ELSE IF(@Control_Type = 'DDL' AND @Is_Ref = 'Y' AND @Is_Defined_Values = 'N')
		BEGIN

			IF(Lower(@Ref_Table) = 'talent')
			BEGIN
				INSERT INTO @TempECValue
				SELECT RTRIM(LTRIM(d.number)) as EC_Value,T.Talent_Code as EC_Code from Talent T (NOLOCK)
				INNER JOIN Talent_Role TR (NOLOCK) ON TR.Talent_Code = T.Talent_Code AND TR.Role_Code = @Additional_Condition
				RIGHT JOIN dbo.fn_Split_withdelemiter(@ECValue,',') d ON RTRIM(LTRIM(d.number))=T.Talent_Name
			END
			ELSE
			BEGIN
				DECLARE @SQLQuery NVARCHAR(MAX)
				SET @SQLQuery = 'SELECT RTRIM(LTRIM(d.number)) as EC_Value,'+@Ref_Value_Field+' as EC_Code from '+@Ref_Table+' (NOLOCK)								
								RIGHT JOIN dbo.fn_Split_withdelemiter('''+@ECValue+''','','') d ON RTRIM(LTRIM(d.number))='+@Ref_Display_Field

				INSERT INTO @TempECValue EXEC(@SQLQuery)

			END

			
			IF EXISTS(SELECT * FROM @TempECValue WHERE EC_Code IS NULL)
			BEGIN
				SELECT  0 as 'InputValueCode',
						STUFF(
						(SELECT ',' + CAST(t2.EC_Value As VARCHAR)
							FROM @TempECValue t2
							WHERE t2.EC_Code IS NULL
							FOR XML PATH (''))
							, 1, 1, '')  AS 'InvalidValue'
			END
			ELSE
			BEGIN

				SELECT STUFF(
						(SELECT ',' + CAST(t2.EC_Code As VARCHAR)
							FROM @TempECValue t2						
							FOR XML PATH (''))
							, 1, 1, '')  AS 'InputValueCode','' AS 'InvalidValue'
			END

		END
	END


END

