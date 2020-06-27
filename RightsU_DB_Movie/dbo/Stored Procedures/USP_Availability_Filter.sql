CREATE PROCEDURE [dbo].[USP_Availability_Filter]
(
	@Title_Code VARCHAR(MAX), 
	@Platform_Code VARCHAR(MAX),
    @Country_Code VARCHAR(MAX),
	@Subtit_Language_Code VARCHAR(MAX),
	@Dubbing_Language_Code VARCHAR(MAX),
	@MustHave_Platform Varchar(Max)='0',
	@Dubbing_Subtitling Varchar(20),
	@Region_MustHave Varchar(Max)='0',
	@Region_Exclusion Varchar(Max)='0',
	@Title_Language_Code Varchar(Max)='0',
	@CallFrom INT 
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	

	Declare @territoryCodes varchar(max),@countryCodes varchar(max),@languageGroupCodes varchar(max),@subtiti_languageCodes varchar(max),@dubbing_languageCodes varchar(max)
	DECLARE @TitleNames VARCHAR(MAX), @PlatformNames VARCHAR(MAX), @TerritoryNames VARCHAR(MAX), @CountryNames VARCHAR(MAX), @Platform_MustHavesNames VARCHAR(MAX)
	, @LanguageGroupNames VARCHAR(MAX), @Subtit_LanguageNames VARCHAR(MAX), @MustHaveCountryNames VARCHAR(MAX), @Dubbing_LanguageNames VARCHAR(MAX)
	DECLARE @TitleLanguage_Names VARCHAR(MAX)='', @ExclusionCountryNames VARCHAR(MAX)='', @Tmp_MustHaveCountryNames VARCHAR(MAX)='', @SubDub VARCHAR(MAX) =''
	/*---Start Title---*/
	
	--select number INTO #Temp_Title from dbo.fn_Split_withdelemiter(@Title_Code,',') Where number Not In('0', '')
	--Delete From #Temp_Title Where number = 0

	SET @TitleNAmes =ISNULL(STUFF((SELECT DISTINCT ',' + t.Title_Name 
	FROM Title t 
	WHERE t.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Code,',') WHERE number NOT IN('0', ''))
	FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
	
	/*---End Title---*/
		
	/*---Start Platform---*/
	
	--select Cast(number As Int) number INTO #Temp_Platform from dbo.fn_Split_withdelemiter(@Platform_Code,',') Where number Not In('0', '')
	--Delete From #Temp_Platform Where number = 0

	DECLARE @Platform_Count INT
	DECLARE @Selected_Platform_Count INT
	Select @Platform_Count = COUNT(*) FROM Platform p WHERE p.Is_Last_Level = 'Y'

	SELECT @Selected_Platform_Count = COUNT(*)
	FROM Platform p 
	WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Platform_Code,',') WHERE number NOT IN('0', ''))
	AND p.Is_Last_Level = 'Y'

	IF(@Selected_Platform_Count = @Platform_Count)
	BEGIN
		SET @PlatformNames = 'All Platforms'
	END
	ELSE
	BEGIN
		SET @PlatformNames =ISNULL(STUFF((SELECT DISTINCT ',' + p.Platform_Hiearachy
		FROM Platform p 
		WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Platform_Code,',') WHERE number NOT IN('0', ''))
		AND p.Is_Last_Level = 'Y'
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
	END

	/*---End Platform---*/
	
	/*---Start Country---*/
	IF(@CallFrom = 3)
	BEGIN
		SET @countryCodes =  IsNull(STUFF((SELECT DISTINCT ',' + number FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number NOT LIKE 'T%' 
		AND number NOT IN('0')
		--OR number = '0'
			FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
		, 1, 1, ''), '')
	END
	ELSE		
	BEGIN
		SET @countryCodes =  IsNull(STUFF((SELECT DISTINCT ',' + REPLACE(number,'C','') FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number LIKE 'C%' 
		AND number NOT IN('0')
		--OR number = '0'
			FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
		, 1, 1, ''), '')
	END
	--Create Table #Temp_Country(
	--	Country_Code Int
	--)

	--Insert InTo #Temp_Country
	--select number from dbo.fn_Split_withdelemiter(@countryCodes,',') Where number <> '0'

	--Delete From #Temp_Country Where Country_Code = 0

	SET @CountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name
	FROM Country c 
	WHERE c.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@countryCodes,',') WHERE number  NOT IN ( '0',''))
	FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	/*---End Country---*/
	
	/*---Start Territory---*/
	
	SET @territoryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number LIKE 'T%' AND number NOT IN('0')
		--OR number = '0'
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)')
        , 1, 1, ''), '')
	
	--Create Table #Temp_Territory(
	--	Territory_Code Int
	--)

	--Insert InTo #Temp_Territory
	--select number from dbo.fn_Split_withdelemiter(@territoryCodes,',') Where number <> '0'

	--Delete From #Temp_Territory Where Territory_Code = 0

	SET @TerritoryNames =ISNULL(STUFF((SELECT DISTINCT ',' + t.Territory_Name
	FROM Territory t 
	WHERE t.Territory_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCodes,',') WHERE number NOT IN ('0',''))
	FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	/*---End Territory---*/
	
	/*---Start Must Have Platform---*/
	
	--select Cast(number As Int) number INTO #Temp_MustHave from dbo.fn_Split_withdelemiter(@MustHave_Platform,',') Where number Not In('0', '')
	--Delete From #Temp_MustHave Where number = 0

	SET @Platform_MustHavesNames =ISNULL(STUFF((SELECT DISTINCT ',' + p.Platform_Hiearachy
	FROM Platform p 
	WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number from dbo.fn_Split_withdelemiter(@MustHave_Platform,',') Where number Not In('0', ''))
	AND p.Is_Last_Level = 'Y'
	FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')

	/*---End Must Have  Platform---*/
	
	Select @SubTit_Language_Code = LTRIM(Rtrim(@SubTit_Language_Code))
	Select @Dubbing_Language_Code = LTRIM(Rtrim(@Dubbing_Language_Code))

		 
	 IF(@CallFrom = 2)
	 BEGIN
	/*---Start Language Group---*/		

		SET @languageGroupCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'G','') from fn_Split_withdelemiter(@SubTit_Language_Code,',') Where number like 'G%' And number Not In('0')
			--OR number = '0'
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)')
			,1,1,''), '')

		Create Table #Temp_LanguageGroup(
			Language_Code Int
		)

		Insert InTo #Temp_LanguageGroup
		select number from dbo.fn_Split_withdelemiter(@languageGroupCodes,',') Where number <> '0'

		Delete From #Temp_LanguageGroup Where Language_Code = 0

		SET @LanguageGroupNames =ISNULL(STUFF((SELECT DISTINCT ',' + lg.Language_Group_Name
		FROM Language_Group lg 
		WHERE lg.Language_Group_Code IN (select number from dbo.fn_Split_withdelemiter(@languageGroupCodes,',') Where number NOT IN ('0',''))
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'),1,1,''), '')

		/*---End Language Group---*/		

		IF Exists(Select * where 'S' in (select number from dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))
		BEGIN	
			SET @SubDub ='Subtitling'
		END
		IF Exists(Select * where 'D' in (select number from dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))
		BEGIN	
			IF(@SubDub ='Subtitling')
				SET @SubDub =@SubDub +', Dubbing'
			ELSE
				SET @SubDub ='Dubbing'
		END
	END	
	/*---Start Language ---*/		

	SET @subtiti_languageCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'L','') from fn_Split_withdelemiter(@SubTit_Language_Code,',') Where number like 'L%' And number Not In('0')
		--OR number = '0'
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)')
        ,1,1,''), '')

	SET @dubbing_languageCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'L','') from fn_Split_withdelemiter(@Dubbing_Language_Code,',') Where number like 'L%' And number Not In('0')
		--OR number = '0'
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)')
        ,1,1,''), '')

	--Create Table #Temp_Language(
	--	Language_Code Int
	--)
	
	--Insert InTo #Temp_Language
	--select number from dbo.fn_Split_withdelemiter(@languageCodes,',') Where number <> '0'
		
	--Delete From #Temp_Language Where Language_Code = 0

	SET @Subtit_LanguageNames =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name
	FROM Language l 
	WHERE l.language_code IN (select number from dbo.fn_Split_withdelemiter(@subtiti_languageCodes,',') Where number NOT IN ('0',''))
	FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')


	SET @Dubbing_LanguageNames =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name
	FROM Language l 
	WHERE l.language_code IN (select number from dbo.fn_Split_withdelemiter(@dubbing_languageCodes,',') Where number NOT IN ('0',''))
	FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

		
	/*---End Language ---*/		

	/*---Start Must Have Country---*/
	
	--select Cast(number As Int) number INTO #Temp_MustHave_Region from dbo.fn_Split_withdelemiter(@Region_MustHave,',') Where number Not In('0', '')
	--Delete From #Temp_MustHave_Region Where number = 0

	--SET @MustHaveCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name
	--FROM Country c 
	--WHERE c.Country_Code IN (select Cast(number As Int) number FROM dbo.fn_Split_withdelemiter(@Region_MustHave,',') Where number Not In('0', ''))
	--FOR XML PATH(''), TYPE
 --   ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')

	
	 
	 IF(@CallFrom=3)
	 BEGIN
	 
		SELECT @Tmp_MustHaveCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number, 'C', '') FROM fn_Split_withdelemiter(@Region_MustHave, ',') WHERE number NOT IN('0','')
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)')
			, 1, 1, ''), '')

		
		SET @MustHaveCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name
		FROM Country c 
		WHERE c.Country_Code IN (select Cast(number As Int) number FROM dbo.fn_Split_withdelemiter(@Tmp_MustHaveCountryNames,',') Where number Not In('0', ''))
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'),1,1,''), '')
		/*---End Must Have  Country---*/

		/*---Country Exclusion---*/
	
		--select Cast(number As Int) number INTO #Temp_MustHave_Region from dbo.fn_Split_withdelemiter(@Region_MustHave,',') Where number Not In('0', '')
		--Delete From #Temp_MustHave_Region Where number = 0
	

		SET @ExclusionCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name
		FROM Country c 
		WHERE c.Country_Code IN (select Cast(number As Int) number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion,',') Where number Not In('0', ''))
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'),1,1,''), '')

		/*---End Country Exclusion---*/
	 


		 /*---Title Language---*/
	 
		 SET @TitleLanguage_Names =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name
		FROM Language l
		WHERE l.Language_Code IN (select number from dbo.fn_Split_withdelemiter(@Title_Language_Code,',') Where number NOT IN ('0',''))
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'),1,1,''), '')
		/*---End Title Language---*/
	END

	SELECT @TitleNames TitleNames, @PlatformNames PlatformNames, @CountryNames CountryNames, @TerritoryNames TerritoryNames, @Platform_MustHavesNames MustHavePlatformsNames
	, @Subtit_LanguageNames Subtit_LanguageNames, @Dubbing_LanguageNames Dubbing_LanguageNames, getdate() Created_On, @MustHaveCountryNames MustHaveCountryNames
	,@ExclusionCountryNames ExclusionCountryNames, @TitleLanguage_Names TitleLanguage_Names, @LanguageGroupNames LanguageGroupNames, @SubDub SubtitlingDubbing

	--DROP TABLE #Temp_Country
	--DROP TABLE #Temp_Language
	--DROP TABLE #Temp_Title
	--DROP TABLE #Temp_Platform
	--DROP TABLE #Temp_LanguageGroup
	--DROP TABLE #Temp_Territory
	--DROP TABLE #Temp_MustHave


END

/*

*/
