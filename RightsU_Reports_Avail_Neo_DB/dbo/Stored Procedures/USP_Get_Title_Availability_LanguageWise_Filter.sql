CREATE PROCEDURE [dbo].[USP_Get_Title_Availability_LanguageWise_Filter]
(
	@TitleCodes VARCHAR(MAX),
	@PlatformCodes VARCHAR(MAX),
	@CountryCodes VARCHAR(MAX),
	@SubtitlingCodes VARCHAR(MAX),
	@DubbingCodes VARCHAR(MAX),
	@MustHavePlatforms VARCHAR(MAX)='0',
	@DubbingSubtitling Varchar(20),
	@MustHaveRegion VARCHAR(MAX)='0',
	@Region_Exclusion VARCHAR(MAX)='0',
	@TitleLanguageCode VARCHAR(MAX)='0',
	@CallFROM INT,
	@IsIFTACluster CHAR(1) = 'N',
	@SubtitlingGroupCodes VARCHAR(MAX),
	@MustHaveSubtitling VARCHAR(MAX),
	@ExclusionSubtitling VARCHAR(MAX),
	@DubbingGroupCodes VARCHAR(MAX),
	@MustHaveDubbing VARCHAR(MAX),
	@ExclusionDubbing VARCHAR(MAX),
	@ExactMatchPlatforms VARCHAR(MAX),
	@TerritoryCodes VARCHAR(MAX)
)
AS
BEGIN

	SET NOCOUNT ON;
	SET FMTONLY OFF;
    
	INSERT INTO TestParam(Params, ProcType)
	SELECT '@TitleCodes=''' + CAST(@TitleCodes AS VARCHAR(MAX)) +
	''', @PlatformCodes=''' + CAST(ISNULL(@PlatformCodes, '') AS VARCHAR(MAX)) +
	''', @CountryCodes=''' + CAST(ISNULL(@CountryCodes, '') AS VARCHAR(MAX)) +
	''', @SubtitlingCodes=''' + CAST(ISNULL(@SubtitlingCodes, '') AS VARCHAR(MAX)) +
	''', @DubbingCodes=''' + CAST(ISNULL(@DubbingCodes, '') AS VARCHAR(MAX)) +
	''', @MustHavePlatforms=''' + CAST(ISNULL(@MustHavePlatforms, '') AS VARCHAR(MAX)) +
	''', @DubbingSubtitling=''' + CAST(ISNULL(@DubbingSubtitling, '') AS VARCHAR(MAX)) +
	''', @MustHaveRegion=''' + CAST(ISNULL(@MustHaveRegion, '') AS VARCHAR(MAX)) +
	''', @Region_Exclusion=''' + CAST(ISNULL(@Region_Exclusion, '') AS VARCHAR(MAX)) +
	''', @TitleLanguageCode=''' + CAST(ISNULL(@TitleLanguageCode, '') AS VARCHAR(MAX)) +
	''', @CallFROM=''' + CAST(ISNULL(@CallFROM, '') AS VARCHAR(MAX)) +
	''', @IsIFTACluster=''' + CAST(ISNULL(@IsIFTACluster, '') AS VARCHAR(MAX)) +
	''', @SubtitlingGroupCodes=''' + CAST(ISNULL(@SubtitlingGroupCodes, '') AS VARCHAR(MAX)) +
	''', @MustHaveSubtitling=''' + CAST(ISNULL(@MustHaveSubtitling, '') AS VARCHAR(MAX)) +
	''', @ExclusionSubtitling=''' + CAST(ISNULL(@ExclusionSubtitling, '') AS VARCHAR(MAX)) +
	''', @DubbingGroupCodes=''' + CAST(ISNULL(@DubbingGroupCodes, '') AS VARCHAR(MAX)) +
	''', @MustHaveDubbing=''' + CAST(ISNULL(@MustHaveDubbing, '') AS VARCHAR(MAX)) +
	''', @ExclusionDubbing=''' + CAST(ISNULL(@ExclusionDubbing, '') AS VARCHAR(MAX)) + 
	''', @ExactMatchPlatforms=''' + CAST(ISNULL(@ExactMatchPlatforms, '') AS VARCHAR(MAX)) +	
	''', @TerritoryCodes=''' + CAST(ISNULL(@TerritoryCodes, '') AS VARCHAR(MAX)) + '''', 'MAvailFilter'
    
	--SELECT @TitleCodes='0', @PlatformCodes='90', @CountryCodes='0,268,282,285', @SubtitlingCodes='0,55,65,42,1136,56,63,41,66,43,1,62,61,58,38,49,54,1127,47,1131,60,53', @DubbingCodes='0,77,78,6,89,92,1152,1151,1150,1149,26,1153,1154,1156,1158,33,1157,1155', @MustHavePlatforms='0', @DubbingSubtitling='S,D', @MustHaveRegion='', @Region_Exclusion='', @TitleLanguageCode='0', @CallFROM='0', @IsIFTACluster='Y', @SubtitlingGroupCodes='G49', @MustHaveSubtitling='0', @ExclusionSubtitling='', @DubbingGroupCodes='G66', @MustHaveDubbing='0', @ExclusionDubbing='', @ExactMatchPlatforms='', @TerritoryCodes='T2'
	      
	DECLARE @territoryCode VARCHAR(MAX),@countryCode VARCHAR(MAX),@languageGroupCodes VARCHAR(MAX),@subtiti_languageCodes VARCHAR(MAX),@dubbing_languageCodes VARCHAR(MAX),
			@subtitlingGroupCode VARCHAR(MAX),@subtitlingMustHave VARCHAR(MAX), @subtitlingExclusion VARCHAR(MAX),@dubbingGroupCode VARCHAR(MAX),
			@TitleNames NVARCHAR(MAX), @PlatformNames NVARCHAR(MAX), @TerritoryNames NVARCHAR(MAX), @CountryNames NVARCHAR(MAX), @MustHavePlatformsNames NVARCHAR(MAX),
			@LanguageGroupNames NVARCHAR(MAX), @Subtit_LanguageNames NVARCHAR(MAX), @MustHaveCountryNames NVARCHAR(MAX), @Dubbing_LanguageNames NVARCHAR(MAX), 
			@TitleLanguage_Names NVARCHAR(MAX)='', @ExclusionCountryNames NVARCHAR(MAX)='', @Tmp_MustHaveCountryNames NVARCHAR(MAX)='', @SubDub NVARCHAR(MAX) ='',
			@SubtitlingGroupName NVARCHAR(MAX),@subtitlingMustHaveNames nVARCHAR(MAX),@subtitlingExclusionNames nVARCHAR(MAX), @DubbingGroupName NVARCHAR(MAX),
			@dubbingMustHaveNames nVARCHAR(MAX),@dubbingExclusionNames nVARCHAR(MAX), @PlatformGroupName nVARCHAR(MAX),@PlatformMustHaveNames nVARCHAR(MAX),
			@RegionMustHaveNames nVARCHAR(MAX),@RegionExclusionNames nVARCHAR(MAX)
 
	/*---TITLE START---*/

	SET @TitleNAmes =ISNULL(STUFF((
		SELECT DISTINCT ',' + t.Title_Name FROM Title t
		WHERE t.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@TitleCodes,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
 
	/*---TITLE END---*/

	/*---SUBTITLING & SUBTITLING GROUP START---*/
     
	SET @subtitlingGroupCode = ISNULL(STUFF((
		SELECT DISTINCT ',' + REPLACE(number,'G','') FROM fn_Split_withdelemiter(@SubtitlingGroupCodes,',') 
		WHERE number LIKE 'G%' AND number NOT IN('0')
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)') , 1, 1, ''), '')    
     
	SET @SubtitlingGroupName =ISNULL(STUFF((
		SELECT DISTINCT ',' + lg.Language_Group_Name FROM Language_Group LG 
		WHERE lg.Language_Group_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@subtitlingGroupCode,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
 
	SET @subtitlingMustHaveNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + L.Language_Name FROM Language L 
		WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@MustHaveSubtitling,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	SET @subtitlingExclusionNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + L.Language_Name FROM Language L 
		WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@ExclusionSubtitling,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
	
	SELECT @SubtitlingCodes = LTRIM(RTRIM(@SubtitlingCodes))

	SET @subtiti_languageCodes = ISNULL(STUFF((
		SELECT DISTINCT ',' + REPLACE(number,'L','') FROM fn_Split_withdelemiter(@SubtitlingCodes,',')
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	SET @Subtit_LanguageNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + l.Language_Name FROM Language l 
		WHERE l.language_code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@subtiti_languageCodes,',') WHERE number NOT IN ('0',''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	/*---SUBTITLING & SUBTITLING GROUP END ---*/

	/*---DUBBING & DUBBING GROUP START---*/

	SET @dubbingGroupCode = ISNULL(STUFF((
		SELECT DISTINCT ',' + REPLACE(number,'G','') FROM fn_Split_withdelemiter(@DubbingGroupCodes,',') 
		WHERE number LIKE 'G%' AND number NOT IN('0')
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')    
    
	SET @DubbingGroupName = ISNULL(STUFF((
		SELECT DISTINCT ',' + lg.Language_Group_Name FROM Language_Group LG 
		WHERE lg.Language_Group_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@dubbingGroupCode,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
 
	SET @dubbingMustHaveNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + L.Language_Name FROM Language L 
		WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@MustHaveDubbing,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	SET @dubbingExclusionNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + L.Language_Name FROM Language L 
		WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@ExclusionDubbing,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
	
	SELECT @DubbingCodes = LTRIM(RTRIM(@DubbingCodes))
	
	SET @dubbing_languageCodes = ISNULL(STUFF((
		SELECT DISTINCT ',' + REPLACE(number,'L','') FROM fn_Split_withdelemiter(@DubbingCodes,',')
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	SET @Dubbing_LanguageNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + l.Language_Name FROM Language l 
		WHERE l.language_code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@dubbing_languageCodes,',') WHERE number NOT IN ('0',''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	/*---DUBBING & DUBBING GROUP END---*/

	/*---PLATFORM START---*/
	
	SET @PlatformNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + p.Platform_Hiearachy FROM Platform p 
		WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@PlatformCodes,',') WHERE number NOT IN('0', '')) AND p.Is_Last_Level = 'Y'
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	SET @PlatformGroupName = ISNULL(STUFF((
		SELECT DISTINCT ',' + PG.Platform_Group_Name FROM Platform_Group PG 
		WHERE PG.Platform_Group_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@ExactMatchPlatforms,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	SET @PlatformMustHaveNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + P.Platform_Name FROM Platform P 
		WHERE P.Platform_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@MustHavePlatforms,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
      
	SET @MustHavePlatformsNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + p.Platform_Hiearachy FROM Platform p 
		WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@MustHavePlatforms,',') WHERE number NOT IN('0', ''))
		AND p.Is_Last_Level = 'Y'
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'),1,1,''), '')

	/*---PLATFORM END---*/

	/*---REGION START---*/

	SET @countryCode =  ISNULL(STUFF((
		SELECT DISTINCT ',' + REPLACE(number,'C','') FROM fn_Split_withdelemiter(@CountryCodes,',') 
		WHERE number NOT IN('0')
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
	
	SET @CountryNames = ISNULL(STUFF((
		SELECT DISTINCT ',' + c.Country_Name FROM Country c 
		WHERE c.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@countryCode,',') WHERE number  NOT IN ( '0',''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	SET @RegionMustHaveNames = ISNULL(STUFF((
		SELECT DISTINCT ',' +  C.Country_Name FROM Country C 
		WHERE C.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@MustHaveRegion,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
      
	SET @RegionExclusionNames = ISNULL(STUFF((
		SELECT DISTINCT ',' +  C.Country_Name FROM Country C 
		WHERE C.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion,',') WHERE number NOT IN('0', ''))
		FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
    
	IF(@IsIFTACluster = 'Y')
	BEGIN
		
		SET @territoryCode = ISNULL(STUFF((
			SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@TerritoryCodes,',')
			WHERE number LIKE 'T%' AND number NOT IN('0')
			FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
 
		SET @TerritoryNames = ISNULL(STUFF((
			SELECT DISTINCT ',' + t.Report_Territory_Name FROM Report_Territory t
			WHERE t.Report_Territory_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCode,',') WHERE number NOT IN ('0',''))
			FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	END
	ELSE
	BEGIN

		SET @territoryCode = ISNULL(STUFF((
			SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@TerritoryCodes,',')
			WHERE number LIKE 'T%' AND number NOT IN('0')
			FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
 
		SET @TerritoryNames = ISNULL(STUFF((
			SELECT DISTINCT ',' + t.Territory_Name FROM Territory t
			WHERE t.Territory_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCode,',') WHERE number NOT IN ('0',''))
			FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	END

	/*---REGION END---*/
  
	IF EXISTS(SELECT * WHERE 'S' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@DubbingSubtitling, ',')))
	BEGIN 
		SET @SubDub ='Subtitling'
	END
	
	IF EXISTS(SELECT * WHERE 'D' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@DubbingSubtitling, ',')))
	BEGIN 
		IF(@SubDub = 'Subtitling')
			SET @SubDub = @SubDub + ', Dubbing'
		ELSE
			SET @SubDub ='Dubbing'
	END

	SELECT @TitleNames TitleNames, @TitleLanguage_Names TitleLanguage_Names, @LanguageGroupNames LanguageGroupNames, 
		   @CountryNames CountryNames, @TerritoryNames TerritoryNames, @RegionMustHaveNames MustHaveCountryNames, @RegionExclusionNames ExclusionCountryNames, 
		   @PlatformNames PlatformNames, @MustHavePlatformsNames MustHavePlatformsNames, @PlatformGroupName Platform_Group_Name, @PlatformMustHaveNames Platform_Must_Have_Names,
		   @Subtit_LanguageNames Subtit_LanguageNames, @SubtitlingGroupName Subtitling_Group_Name, @subtitlingMustHaveNames Subtitling_Must_Have_Names, @subtitlingExclusionNames Subtitling_Exclusion_Names,
		   @Dubbing_LanguageNames Dubbing_LanguageNames, @DubbingGroupName Dubbing_Group_Name, @dubbingMustHaveNames Dubbing_Must_Have_Names, @dubbingExclusionNames Duubing_Exclusion_Names,
		   @SubDub SubtitlingDubbing, getdate() Created_On

END     
