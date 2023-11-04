CREATE PROCEDURE [dbo].[USPAvailability]
(
	@TitleCodes VARCHAR(MAX) = '0', 
	
	@DateType VARCHAR(2) = 'FL',
	@StartDate VARCHAR(20) = '',
	@EndDate VARCHAR(20) = '',
	
	@PlatformCodes VARCHAR(MAX) = '0',
	@ExactMatchPlatforms VARCHAR(MAX) = NULL,
	@MustHavePlatforms VARCHAR(MAX) = NULL,

	@IsIFTACluster CHAR(1) = 'N',
	@TerritoryCodes VARCHAR(MAX) = '0', 
	@CountryCodes VARCHAR(MAX) = '0', 
	@ExactMatchCountry VARCHAR(MAX) = NULL,
	@MustHaveCountry VARCHAR(MAX) = NULL,
	@ExclusionCountry VARCHAR(MAX) = NULL,
	
	@IsTitleLanguage CHAR(1) = 'Y',
	@TitleLanguageCode VARCHAR(MAX),

	@DubbingSubtitling VARCHAR(20),
	@SubtitlingGroupCodes VARCHAR(MAX) = '0',
	@SubtitlingCodes VARCHAR(MAX) = '0',
	@ExactMatchSubtitling CHAR(10) = NULL,
	@MustHaveSubtitling VARCHAR(max) = NULL,
	@ExclusionSubtitling VARCHAR(max) = NULL,
	
	@DubbingGroupCodes VARCHAR(MAX) = '0',
	@DubbingCodes VARCHAR(MAX) = '0',
	@ExactMatchDubbing CHAR(10) = NULL,
	@MustHaveDubbing VARCHAR(max) = NULL,
	@ExclusionDubbing VARCHAR(max) = NULL,
	 
	@Exclusivity VARCHAR(1) = 'B',   --B-Both, E-Exclusive,N-NonExclusive 
	@SubLicenseCode VARCHAR(MAX) = NULL, --Comma   Separated SubLicensing Code. 0-No Sub Licensing,	
	@RestrictionRemarks CHAR(1) = 'N',
	@OthersRemarks CHAR(1) = 'N',
	@BUCode VARCHAR(20) = '0',
	@IsDigital CHAR(1) = 'N',
	@L1Output CHAR(1) = 'N',
	@ReportType CHAR(1) = 'M'
)
AS
BEGIN

	SET NOCOUNT ON;
	SET FMTONLY OFF;

	INSERT INTO TestParam(Params, ProcType)
	SELECT '@TitleCodes=''' + CAST(@TitleCodes AS VARCHAR(MAX)) +
	
	''', @DateType=''' + CAST(ISNULL(@DateType, '') AS VARCHAR(MAX)) +
	''', @StartDate=''' + CAST(ISNULL(@StartDate, '') AS VARCHAR(MAX)) +
	''', @EndDate=''' + CAST(ISNULL(@EndDate, '') AS VARCHAR(MAX)) +
	
	''', @PlatformCodes=''' + CAST(ISNULL(@PlatformCodes, '') AS VARCHAR(MAX)) +
	''', @ExactMatchPlatforms=''' + CAST(ISNULL(@ExactMatchPlatforms, '') AS VARCHAR(MAX)) +
	''', @MustHavePlatforms=''' + CAST(ISNULL(@MustHavePlatforms, '') AS VARCHAR(MAX)) +
	
	''', @IsIFTACluster=''' + CAST(ISNULL(@IsIFTACluster, '') AS VARCHAR(MAX)) +
	''', @TerritoryCodes=''' + CAST(ISNULL(@TerritoryCodes, '') AS VARCHAR(MAX)) +
	''', @CountryCodes=''' + CAST(ISNULL(@CountryCodes, '') AS VARCHAR(MAX)) +
	''', @ExactMatchCountry=''' + CAST(ISNULL(@ExactMatchCountry, '') AS VARCHAR(MAX)) +
	''', @MustHaveCountry=''' + CAST(ISNULL(@MustHaveCountry, '') AS VARCHAR(MAX)) +
	''', @ExclusionCountry=''' + CAST(ISNULL(@ExclusionCountry, '') AS VARCHAR(MAX)) +
	
	''', @IsTitleLanguage=''' + CAST(ISNULL(@IsTitleLanguage, '') AS VARCHAR(MAX)) +
	''', @TitleLanguageCode=''' + CAST(ISNULL(@TitleLanguageCode, '') AS VARCHAR(MAX)) +
	
	''', @DubbingSubtitling=''' + CAST(ISNULL(@DubbingSubtitling, '') AS VARCHAR(MAX)) +
	''', @SubtitlingGroupCodes=''' + CAST(ISNULL(@SubtitlingGroupCodes, '') AS VARCHAR(MAX)) +
	''', @SubtitlingCodes=''' + CAST(ISNULL(@SubtitlingCodes, '') AS VARCHAR(MAX)) +
	''', @ExactMatchSubtitling=''' + CAST(ISNULL(@ExactMatchSubtitling, '') AS VARCHAR(MAX)) +
	''', @MustHaveSubtitling=''' + CAST(ISNULL(@MustHaveSubtitling, '') AS VARCHAR(MAX)) +
	''', @ExclusionSubtitling=''' + CAST(ISNULL(@ExclusionSubtitling, '') AS VARCHAR(MAX)) +

	''', @DubbingGroupCodes=''' + CAST(ISNULL(@DubbingGroupCodes, '') AS VARCHAR(MAX)) +
	''', @DubbingCodes=''' + CAST(ISNULL(@DubbingCodes, '') AS VARCHAR(MAX)) +
	''', @ExactMatchDubbing=''' + CAST(ISNULL(@ExactMatchDubbing, '') AS VARCHAR(MAX)) +
	''', @MustHaveDubbing=''' + CAST(ISNULL(@MustHaveDubbing, '') AS VARCHAR(MAX)) +
	''', @ExclusionDubbing=''' + CAST(ISNULL(@ExclusionDubbing, '') AS VARCHAR(MAX)) +

	''', @Exclusivity=''' + CAST(ISNULL(@Exclusivity, '') AS VARCHAR(MAX)) +
	''', @SubLicenseCode=''' + CAST(ISNULL(@SubLicenseCode, '') AS VARCHAR(MAX)) +
	''', @RestrictionRemarks=''' + CAST(ISNULL(@RestrictionRemarks, '') AS VARCHAR(MAX)) +
	''', @OthersRemarks=''' + CAST(ISNULL(@OthersRemarks, '') AS VARCHAR(MAX)) +
	''', @BUCode=''' + CAST(ISNULL(@BUCode, '') AS VARCHAR(MAX)) +
	''', @IsDigital=''' + CAST(ISNULL(@IsDigital, '') AS VARCHAR(MAX)) +
	''', @L1Output=''' + CAST(ISNULL(@L1Output, '') AS VARCHAR(MAX)) + '''', 'MAvail'

	SET @TerritoryCodes = REPLACE(@TerritoryCodes, 'T', '')
	SET @SubtitlingGroupCodes = REPLACE(@SubtitlingGroupCodes, 'G', '')
	SET @DubbingGroupCodes = REPLACE(@DubbingGroupCodes, 'G', '')

	-- Title Language bit operator = 1 = Available / 0 = Not Aavailable
	
	--DECLARE @TitleCodes VARCHAR(MAX) = '39020', 
	
	--@DateType VARCHAR(2) = 'FL',
	--@StartDate VARCHAR(20) = '',
	--@EndDate VARCHAR(20) = '',
	
	--@PlatformCodes VARCHAR(MAX) = '0',
	--@ExactMatchPlatforms VARCHAR(MAX) = NULL,
	--@MustHavePlatforms VARCHAR(MAX) = NULL,

	--@IsIFTACluster CHAR(1) = 'N',
	--@TerritoryCodes VARCHAR(MAX) = '0', 
 --   @CountryCodes VARCHAR(MAX) = '0', 
	--@ExactMatchCountry VARCHAR(MAX) = NULL,
	--@MustHaveCountry VARCHAR(MAX) = NULL,
	--@ExclusionCountry VARCHAR(MAX) = NULL,
	
	--@IsTitleLanguage CHAR(1) = 'Y',
	--@TitleLanguageCode VARCHAR(MAX),

	--@DubbingSubtitling VARCHAR(20),
	--@SubtitlingGroupCodes VARCHAR(MAX) = '0',
	--@SubtitlingCodes VARCHAR(MAX) = '0',
	--@ExactMatchSubtitling CHAR(10) = NULL,
	--@MustHaveSubtitling VARCHAR(max) = NULL,
	--@ExclusionSubtitling VARCHAR(max) = NULL,
	
	--@DubbingGroupCodes VARCHAR(MAX) = '0',
	--@DubbingCodes VARCHAR(MAX) = '0',
	--@ExactMatchDubbing CHAR(10) = NULL,
	--@MustHaveDubbing VARCHAR(max) = NULL,
	--@ExclusionDubbing VARCHAR(max) = NULL,
	 
	--@Exclusivity VARCHAR(1) = 'B',   --B-Both, E-Exclusive,N-NonExclusive 
	--@SubLicenseCode VARCHAR(MAX) = '0', --Comma   Separated SubLicensing Code. 0-No Sub Licensing,	
	--@RestrictionRemarks CHAR(1) = 'N',
	--@OthersRemarks CHAR(1) = 'N',
	--@BUCode VARCHAR(20) = '0',
	--@IsDigital CHAR(1) = 'N',
	--@L1Output CHAR(1) = 'N'

	SET @EndDate = CASE WHEN ISNULL(@EndDate, '') = '' THEN '31Mar9999' ELSE @EndDate END

	BEGIN ------------------ CLEAR TEMP TABLE SECTION

		IF OBJECT_ID('tempdb..#SearchTitle') IS NOT NULL DROP TABLE #SearchTitle
		IF OBJECT_ID('tempdb..#SearchPlatform') IS NOT NULL DROP TABLE #SearchPlatform
		IF OBJECT_ID('tempdb..#SearchPlatformMH') IS NOT NULL DROP TABLE #SearchPlatformMH
		IF OBJECT_ID('tempdb..#SearchCountry') IS NOT NULL DROP TABLE #SearchCountry
		IF OBJECT_ID('tempdb..#SearchCountryMH') IS NOT NULL DROP TABLE #SearchCountryMH
		IF OBJECT_ID('tempdb..#SearchTitleLanguage') IS NOT NULL DROP TABLE #SearchTitleLanguage
		IF OBJECT_ID('tempdb..#SearchSubtitling') IS NOT NULL DROP TABLE #SearchSubtitling
		IF OBJECT_ID('tempdb..#SearchDubbing') IS NOT NULL DROP TABLE #SearchDubbing
		IF OBJECT_ID('tempdb..#SearchSubtitlingMH') IS NOT NULL DROP TABLE #SearchSubtitlingMH
		IF OBJECT_ID('tempdb..#SearchDubbingMH') IS NOT NULL DROP TABLE #SearchDubbingMH
		IF OBJECT_ID('tempdb..#SearchSubLicense') IS NOT NULL DROP TABLE #SearchSubLicense
		IF OBJECT_ID('tempdb..#DBAvailDates') IS NOT NULL DROP TABLE #DBAvailDates
		IF OBJECT_ID('tempdb..#DBAvailPlatform') IS NOT NULL DROP TABLE #DBAvailPlatform
		IF OBJECT_ID('tempdb..#DBAvailCountry') IS NOT NULL DROP TABLE #DBAvailCountry
		IF OBJECT_ID('tempdb..#DBAvailLanguages') IS NOT NULL DROP TABLE #DBAvailLanguages
		IF OBJECT_ID('tempdb..#AvailTitleData') IS NOT NULL DROP TABLE #AvailTitleData
		IF OBJECT_ID('tempdb..#TempMain') IS NOT NULL DROP TABLE #TempMain
		IF OBJECT_ID('tempdb..#TempMainL1') IS NOT NULL DROP TABLE #TempMainL1
		IF OBJECT_ID('tempdb..#TempPlatformData') IS NOT NULL DROP TABLE #TempPlatformData
		IF OBJECT_ID('tempdb..#TempLanguageNames') IS NOT NULL DROP TABLE #TempLanguageNames
		IF OBJECT_ID('tempdb..#TempRegions') IS NOT NULL DROP TABLE #TempRegions
		IF OBJECT_ID('tempdb..#TempRightRemarks') IS NOT NULL DROP TABLE #TempRightRemarks
		IF OBJECT_ID('tempdb..#TempTitlesInfo') IS NOT NULL DROP TABLE #TempTitlesInfo
		IF OBJECT_ID('tempdb..#TempMainHB') IS NOT NULL DROP TABLE #TempMainHB
		IF OBJECT_ID('tempdb..#MainHBTitles') IS NOT NULL DROP TABLE #MainHBTitles
		IF OBJECT_ID('tempdb..#MainHBDetails') IS NOT NULL DROP TABLE #MainHBDetails
		IF OBJECT_ID('tempdb..#MainReleaseCountry') IS NOT NULL DROP TABLE #MainReleaseCountry
		IF OBJECT_ID('tempdb..#TempRHB') IS NOT NULL DROP TABLE #TempRHB
		IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput

	END

	BEGIN ------------------ TEMP TABLE DECLARATION ------------------ TABLES FOR FILTER START

		CREATE TABLE #SearchTitle(
			TitleCode INT
		)

		CREATE TABLE #SearchPlatform(
			PlatformCode INT
		)
		
		CREATE TABLE #SearchPlatformMH(
			PlatformCode INT
		)

		CREATE TABLE #SearchCountry(
			CountryCode INT
		)
		
		CREATE TABLE #SearchCountryMH(
			CountryCode INT
		)

		CREATE TABLE #SearchTitleLanguage(
			LanguageCode INT
		)		
		
		CREATE TABLE #SearchSubtitling(
			LanguageCode INT
		)		
		
		CREATE TABLE #SearchDubbing(
			LanguageCode INT
		)
	
		CREATE TABLE #SearchSubtitlingMH(
			LanguageCode INT
		)
				
		CREATE TABLE #SearchDubbingMH(
			LanguageCode INT
		)

		CREATE TABLE #SearchSubLicense(
			SubLicenseCode INT
		)

		------------------ TABLES FOR FILTER END

		------------------ TABLES FOR DBAvailFilter START
		
		CREATE TABLE #DBAvailDates(
			Avail_Dates_Code INT,
			StartDate DATETIME,
			EndDate DATETIME
		)
		
		CREATE TABLE #DBAvailPlatform(
			Avail_Platform_Code Numeric(38,0),
			PlatformCodes VARCHAR(MAX),
			PlatformNames VARCHAR(MAx),
			PlatCnt INT
		)

		CREATE TABLE #DBAvailCountry(
			Avail_Country_Code Numeric(38,0),
			CountryCode VARCHAR(MAX),
			ClusterNames VARCHAR(MAX),
			RegionName VARCHAR(MAX),
			ContCnt INT
		)

		CREATE TABLE #DBAvailLanguages(
			Avail_Languages_Code Numeric(38,0),
			LanguageCodes VARCHAR(MAX),
			LanguageNames VARCHAR(MAx),
			LangType CHAR(1),
			LangCnt INT
		)

		------------------ TABLES FOR DBAvailFilter END

		------------------ TABLES FOR AVAIL START

		CREATE TABLE #AvailTitleData
		(
			IntCode INT IDENTITY(1, 1),
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT,
			Episode_From INT,
			Episode_To INT,
			Avail_Dates_Code INT,
			Is_Exclusive BIT,
			Avail_Platform_Code INT,
			Avail_Country_Code INT,
			Is_Theatrical BIT,
			Is_Title_Language BIT,
			Avail_Subtitling_Code INT,
			Avail_Dubbing_Code INT
		)
	
		CREATE TABLE #TempMain(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT, 
			Episode_From INT,
			Episode_To INT,
			Is_Exclusive BIT,
			Platform_Code INT,
			Available VARCHAR(50), 
			Avail_Country_Code INT,
			Start_Date DATE,
			End_Date DATE,
			Is_Title_Language BIT,
			Avail_Subtitling_Code INT,
			Avail_Dubbing_Code INT,
			Acq_Deal_Rights_Holdback_Code INT, 
			Holdback_Type CHAR(1), 
			Holdback_Release_Date DATE, 
			Holdback_On_Platform_Code INT,
			Country_Cd_Str VARCHAR(MAX),
			ClusterNames NVARCHAR(MAX),
			RegionName NVARCHAR(MAX) 
		)
	
		CREATE TABLE #TempMainL1(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT, 
			Episode_From INT,
			Episode_To INT,
			Is_Exclusive BIT,
			Platform_Code INT, 
			Avail_Country_Code INT,
			Start_Date DATE,
			End_Date DATE,
			Is_Title_Language BIT,
			Avail_Subtitling_Code INT,
			Avail_Dubbing_Code INT,
			Acq_Deal_Rights_Holdback_Code INT, 
			Holdback_Type CHAR(1), 
			Holdback_Release_Date DATE, 
			Holdback_On_Platform_Code INT,
			Country_Cd_Str VARCHAR(MAX),
			ClusterNames NVARCHAR(MAX), 
			RegionName NVARCHAR(MAX),
			Base_Platform_Code INT,
			Actual_Platform_Count INT,
			Avail_Platform_Count INT
		)
		
		------------------ TABLES FOR AVAIL END

		------------------ TABLES FOR TEMP USE START
		
		CREATE TABLE #TempPlatformData(
			Avail_Platform_Code INT,
			PlatformCode INT,
			PlatformName VARCHAR(1000)
		)

		CREATE TABLE #TempLanguageNames(
			LanguageCodes VARCHAR(MAX),
			LanguageNames VARCHAR(MAX)
		)

		CREATE TABLE #TempRegions (
			RowId INT IDENTITY(1, 1),
			RegionCodes VARCHAR(MAX),
			ClusterNames VARCHAR(MAX),
			RegionName VARCHAR(MAX)
		)
	
		CREATE TABLE #TempRightRemarks
		(
			Acq_Deal_Rights_Code INT, 
			Restriction_Remarks VARCHAR(4000), 
			Remarks VARCHAR(4000), 
			Rights_Remarks VARCHAR(4000),
			Sub_Deal_Restriction_Remark VARCHAR(8000), 
			Sub_License_Name VARCHAR(100)
		)
		
		CREATE TABLE #TempTitlesInfo
		(
			Title_Code INT,
			Title_Language_Code INT,
			Title_Name NVARCHAR(1000),
			Title_Type NVARCHAR(2000),
			Genres_Name NVARCHAR(2000),
			Star_Cast NVARCHAR(1000),
			Director NVARCHAR(1000),
			Duration_In_Min INT,
			Year_Of_Production INT,
			Language_Name NVARCHAR(1000)
		)

		------------------ TABLES FOR TEMP USE END

		------------------ TABLES FOR HOLDBACK START

		CREATE TABLE #TempMainHB(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT, 
			Episode_From INT,
			Episode_To INT,
			Is_Exclusive BIT,
			Platform_Code INT, 
			Country_Code INT,
			Start_Date DATE,
			End_Date DATE,
			Is_Title_Language BIT,
			Avail_Subtitling_Code INT,
			Avail_Dubbing_Code INT,
			Acq_Deal_Rights_Holdback_Code INT, 
			Holdback_Type CHAR(1), 
			Holdback_Release_Date DATE, 
			Holdback_On_Platform_Code INT
		)

		CREATE TABLE #MainHBTitles(
			Title_Code INT, 
			Episode_From INT,
			Episode_To INT
		)

		CREATE TABLE #MainHBDetails(
			Acq_Deal_Rights_Holdback_Code INT, 
			Holdback_Type CHAR(1),
			HBComments NVARCHAR(MAX),
			HB_Run_After_Release_No INT, 
			HB_Run_After_Release_Units INT
		)
		
		CREATE TABLE #MainReleaseCountry(
			Title_Release_Code INT, 
			Country_Code INT
		)

		CREATE TABLE #TempRHB(
			Title_Code INT, 
			strRHB NVARCHAR(MAX)
		)

		------------------ TABLES FOR HOLDBACK START

		------------------ TABLE FOR FINAL OUTPUT START

		CREATE TABLE #TempOutput
		(
			OutputOrder INT,
			TitleType VARCHAR(200),
			Title NVARCHAR(MAX),
			EpisodeFrom VARCHAR(20),
			EpisodeTo VARCHAR(20),
			ClusterNames NVARCHAR(MAX),
			RegionName NVARCHAR(MAX),
			StartDate NVARCHAR(50),
			EndDate NVARCHAR(50),
			ROFR NVARCHAR(50),
			TitleLanguage NVARCHAR(MAX),
			SubTiltling NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			StarCast NVARCHAR(MAX),
			Director NVARCHAR(MAX),
			Duration NVARCHAR(MAX),
			ReleaseYear NVARCHAR(MAX),
			RestrictionRemarks NVARCHAR(MAX),
			SubDealRestrictionRemarks NVARCHAR(MAX),
			Remarks NVARCHAR(MAX),
			RightsRemarks NVARCHAR(MAX),
			Exclusive VARCHAR(100),
			SubLicense VARCHAR(200),
			HoldbackOn NVARCHAR(200),
			HoldbackType NVARCHAR(100),
			HoldbackReleaseDate NVARCHAR(100),
			ReverseHoldback NVARCHAR(MAX),
			SelfUtilizationGroup NVARCHAR(MAX),
			SelfUtilizationRemarks NVARCHAR(MAX),
			PL_1 VARCHAR(500),
			PL_2 VARCHAR(500),
			PL_3 VARCHAR(500),
			PL_4 VARCHAR(500),
			PL_5 VARCHAR(500),
			PL_6 VARCHAR(500),
			PL_7 VARCHAR(500),
			PL_8 VARCHAR(500),
			PL_9 VARCHAR(500),
			PL_10 VARCHAR(500),
			PL_11 VARCHAR(500),
			PL_12 VARCHAR(500),
			PL_13 VARCHAR(500),
			PL_14 VARCHAR(500),
			PL_15 VARCHAR(500),
			PL_16 VARCHAR(500),
			PL_17 VARCHAR(500),
			PL_18 VARCHAR(500),
			PL_19 VARCHAR(500),
			PL_20 VARCHAR(500),
			PL_21 VARCHAR(500),
			PL_22 VARCHAR(500),
			PL_23 VARCHAR(500),
			PL_24 VARCHAR(500),
			PL_25 VARCHAR(500),
			PL_26 VARCHAR(500),
			PL_27 VARCHAR(500),
			PL_28 VARCHAR(500),
			PL_29 VARCHAR(500),
			PL_30 VARCHAR(500),
			PL_31 VARCHAR(500),
			PL_32 VARCHAR(500),
			PL_33 VARCHAR(500),
			PL_34 VARCHAR(500),
			PL_35 VARCHAR(500),
			PL_36 VARCHAR(500),
			PL_37 VARCHAR(500),
			PL_38 VARCHAR(500),
			PL_39 VARCHAR(500),
			PL_40 VARCHAR(500),
			PL_41 VARCHAR(500),
			PL_42 VARCHAR(500),
			PL_43 VARCHAR(500),
			PL_44 VARCHAR(500),
			PL_45 VARCHAR(500),
			PL_46 VARCHAR(500),
			PL_47 VARCHAR(500),
			PL_48 VARCHAR(500),
			PL_49 VARCHAR(500),
			PL_50 VARCHAR(500),
			PL_51 VARCHAR(500),
			PL_52 VARCHAR(500),
			PL_53 VARCHAR(500),
			PL_54 VARCHAR(500),
			PL_55 VARCHAR(500),
			PL_56 VARCHAR(500),
			PL_57 VARCHAR(500),
			PL_58 VARCHAR(500),
			PL_59 VARCHAR(500),
			PL_60 VARCHAR(500),
			PL_61 VARCHAR(500),
			PL_62 VARCHAR(500),
			PL_63 VARCHAR(500),
			PL_64 VARCHAR(500),
			PL_65 VARCHAR(500),
			PL_66 VARCHAR(500),
			PL_67 VARCHAR(500),
			PL_68 VARCHAR(500),
			PL_69 VARCHAR(500),
			PL_70 VARCHAR(500),
			PL_71 VARCHAR(500),
			PL_72 VARCHAR(500),
			PL_73 VARCHAR(500),
			PL_74 VARCHAR(500),
			PL_75 VARCHAR(500),
			PL_76 VARCHAR(500),
			PL_77 VARCHAR(500),
			PL_78 VARCHAR(500),
			PL_79 VARCHAR(500),
			PL_80 VARCHAR(500),
			PL_81 VARCHAR(500),
			PL_82 VARCHAR(500),
			PL_83 VARCHAR(500),
			PL_84 VARCHAR(500),
			PL_85 VARCHAR(500),
			PL_86 VARCHAR(500),
			PL_87 VARCHAR(500),
			PL_88 VARCHAR(500),
			PL_89 VARCHAR(500),
			PL_90 VARCHAR(500),
			PL_91 VARCHAR(500),
			PL_92 VARCHAR(500),
			PL_93 VARCHAR(500),
			PL_94 VARCHAR(500),
			PL_95 VARCHAR(500),
			PL_96 VARCHAR(500),
			PL_97 VARCHAR(500),
			PL_98 VARCHAR(500),
			PL_99 VARCHAR(500),
			PL_100 VARCHAR(500),
			PL_101 VARCHAR(500),
			PL_102 VARCHAR(500),
			PL_103 VARCHAR(500),
			PL_104 VARCHAR(500),
			PL_105 VARCHAR(500),
			PL_106 VARCHAR(500),
			PL_107 VARCHAR(500),
			PL_108 VARCHAR(500),
			PL_109 VARCHAR(500),
			PL_110 VARCHAR(500),
			PL_111 VARCHAR(500),
			PL_112 VARCHAR(500),
			PL_113 VARCHAR(500),
			PL_114 VARCHAR(500),
			PL_115 VARCHAR(500),
			PL_116 VARCHAR(500),
			PL_117 VARCHAR(500),
			PL_118 VARCHAR(500),
			PL_119 VARCHAR(500),
			PL_120 VARCHAR(500),
			PL_121 VARCHAR(500),
			PL_122 VARCHAR(500),
			PL_123 VARCHAR(500),
			PL_124 VARCHAR(500),
			PL_125 VARCHAR(500),
			PL_126 VARCHAR(500),
			PL_127 VARCHAR(500),
			PL_128 VARCHAR(500),
			PL_129 VARCHAR(500),
			PL_130 VARCHAR(500),
			PL_131 VARCHAR(500),
			PL_132 VARCHAR(500),
			PL_133 VARCHAR(500),
			PL_134 VARCHAR(500),
			PL_135 VARCHAR(500),
			PL_136 VARCHAR(500),
			PL_137 VARCHAR(500),
			PL_138 VARCHAR(500),
			PL_139 VARCHAR(500),
			PL_140 VARCHAR(500),
			PL_141 VARCHAR(500),
			PL_142 VARCHAR(500),
			PL_143 VARCHAR(500),
			PL_144 VARCHAR(500),
			PL_145 VARCHAR(500),
			PL_146 VARCHAR(500),
			PL_147 VARCHAR(500),
			PL_148 VARCHAR(500),
			PL_149 VARCHAR(500),
			PL_150 VARCHAR(500),
			PL_151 VARCHAR(500),
			PL_152 VARCHAR(500),
			PL_153 VARCHAR(500),
			PL_154 VARCHAR(500),
			PL_155 VARCHAR(500),
			PL_156 VARCHAR(500),
			PL_157 VARCHAR(500),
			PL_158 VARCHAR(500),
			PL_159 VARCHAR(500),
			PL_160 VARCHAR(500),
			PL_161 VARCHAR(500),
			PL_162 VARCHAR(500),
			PL_163 VARCHAR(500),
			PL_164 VARCHAR(500),
			PL_165 VARCHAR(500),
			PL_166 VARCHAR(500),
			PL_167 VARCHAR(500),
			PL_168 VARCHAR(500),
			PL_169 VARCHAR(500),
			PL_170 VARCHAR(500),
			PL_171 VARCHAR(500),
			PL_172 VARCHAR(500),
			PL_173 VARCHAR(500),
			PL_174 VARCHAR(500),
			PL_175 VARCHAR(500),
			PL_176 VARCHAR(500),
			PL_177 VARCHAR(500),
			PL_178 VARCHAR(500),
			PL_179 VARCHAR(500),
			PL_180 VARCHAR(500),
			PL_181 VARCHAR(500),
			PL_182 VARCHAR(500),
			PL_183 VARCHAR(500),
			PL_184 VARCHAR(500),
			PL_185 VARCHAR(500),
			PL_186 VARCHAR(500),
			PL_187 VARCHAR(500),
			PL_188 VARCHAR(500),
			PL_189 VARCHAR(500),
			PL_190 VARCHAR(500),
			PL_191 VARCHAR(500),
			PL_192 VARCHAR(500),
			PL_193 VARCHAR(500),
			PL_194 VARCHAR(500),
			PL_195 VARCHAR(500),
			PL_196 VARCHAR(500),
			PL_197 VARCHAR(500),
			PL_198 VARCHAR(500),
			PL_199 VARCHAR(500),
			PL_200 VARCHAR(500),
			PL_201 VARCHAR(500),
			PL_202 VARCHAR(500),
			PL_203 VARCHAR(500),
			PL_204 VARCHAR(500),
			PL_205 VARCHAR(500),
			PL_206 VARCHAR(500),
			PL_207 VARCHAR(500),
			PL_208 VARCHAR(500),
			PL_209 VARCHAR(500),
			PL_210 VARCHAR(500),
			PL_211 VARCHAR(500),
			PL_212 VARCHAR(500),
			PL_213 VARCHAR(500),
			PL_214 VARCHAR(500),
			PL_215 VARCHAR(500),
			PL_216 VARCHAR(500),
			PL_217 VARCHAR(500),
			PL_218 VARCHAR(500),
			PL_219 VARCHAR(500),
			PL_220 VARCHAR(500),
			PL_221 VARCHAR(500),
			PL_222 VARCHAR(500),
			PL_223 VARCHAR(500),
			PL_224 VARCHAR(500),
			PL_225 VARCHAR(500),
			PL_226 VARCHAR(500),
			PL_227 VARCHAR(500),
			PL_228 VARCHAR(500),
			PL_229 VARCHAR(500),
			PL_230 VARCHAR(500),
			PL_231 VARCHAR(500),
			PL_232 VARCHAR(500),
			PL_233 VARCHAR(500),
			PL_234 VARCHAR(500),
			PL_235 VARCHAR(500),
			PL_236 VARCHAR(500),
			PL_237 VARCHAR(500),
			PL_238 VARCHAR(500),
			PL_239 VARCHAR(500),
			PL_240 VARCHAR(500),
			PL_241 VARCHAR(500),
			PL_242 VARCHAR(500),
			PL_243 VARCHAR(500),
			PL_244 VARCHAR(500),
			PL_245 VARCHAR(500),
			PL_246 VARCHAR(500),
			PL_247 VARCHAR(500),
			PL_248 VARCHAR(500),
			PL_249 VARCHAR(500),
			PL_250 VARCHAR(500),
			PL_251 VARCHAR(500),
			PL_252 VARCHAR(500),
			PL_253 VARCHAR(500),
			PL_254 VARCHAR(500),
			PL_255 VARCHAR(500),
			PL_256 VARCHAR(500),
			PL_257 VARCHAR(500),
			PL_258 VARCHAR(500),
			PL_259 VARCHAR(500),
			PL_260 VARCHAR(500),
			PL_261 VARCHAR(500),
			PL_262 VARCHAR(500),
			PL_263 VARCHAR(500),
			PL_264 VARCHAR(500),
			PL_265 VARCHAR(500),
			PL_266 VARCHAR(500),
			PL_267 VARCHAR(500),
			PL_268 VARCHAR(500),
			PL_269 VARCHAR(500),
			PL_270 VARCHAR(500),
			PL_271 VARCHAR(500),
			PL_272 VARCHAR(500),
			PL_273 VARCHAR(500),
			PL_274 VARCHAR(500),
			PL_275 VARCHAR(500),
			PL_276 VARCHAR(500),
			PL_277 VARCHAR(500),
			PL_278 VARCHAR(500),
			PL_279 VARCHAR(500),
			PL_280 VARCHAR(500),
			PL_281 VARCHAR(500),
			PL_282 VARCHAR(500),
			PL_283 VARCHAR(500),
			PL_284 VARCHAR(500),
			PL_285 VARCHAR(500),
			PL_286 VARCHAR(500),
			PL_287 VARCHAR(500),
			PL_288 VARCHAR(500),
			PL_289 VARCHAR(500),
			PL_290 VARCHAR(500),
			PL_291 VARCHAR(500),
			PL_292 VARCHAR(500),
			PL_293 VARCHAR(500),
			PL_294 VARCHAR(500),
			PL_295 VARCHAR(500),
			PL_296 VARCHAR(500),
			PL_297 VARCHAR(500),
			PL_298 VARCHAR(500),
			PL_299 VARCHAR(500),
			PL_300 VARCHAR(500),
			PL_301 VARCHAR(500),
			PL_302 VARCHAR(500),
			PL_303 VARCHAR(500),
			PL_304 VARCHAR(500),
			PL_305 VARCHAR(500),
			PL_306 VARCHAR(500),
			PL_307 VARCHAR(500),
			PL_308 VARCHAR(500),
			PL_309 VARCHAR(500),
			PL_310 VARCHAR(500),
			PL_311 VARCHAR(500),
			PL_312 VARCHAR(500),
			PL_313 VARCHAR(500),
			PL_314 VARCHAR(500),
			PL_315 VARCHAR(500),
			PL_316 VARCHAR(500),
			PL_317 VARCHAR(500),
			PL_318 VARCHAR(500),
			PL_319 VARCHAR(500),
			PL_320 VARCHAR(500),
			PL_321 VARCHAR(500),
			PL_322 VARCHAR(500),
			PL_323 VARCHAR(500),
			PL_324 VARCHAR(500),
			PL_325 VARCHAR(500),
			PL_326 VARCHAR(500),
			PL_327 VARCHAR(500),
			PL_328 VARCHAR(500),
			PL_329 VARCHAR(500),
			PL_330 VARCHAR(500),
			PL_331 VARCHAR(500),
			PL_332 VARCHAR(500),
			PL_333 VARCHAR(500),
			PL_334 VARCHAR(500),
			PL_335 VARCHAR(500),
			PL_336 VARCHAR(500),
			PL_337 VARCHAR(500),
			PL_338 VARCHAR(500),
			PL_339 VARCHAR(500),
			PL_340 VARCHAR(500),
			PL_341 VARCHAR(500),
			PL_342 VARCHAR(500),
			PL_343 VARCHAR(500),
			PL_344 VARCHAR(500),
			PL_345 VARCHAR(500),
			PL_346 VARCHAR(500),
			PL_347 VARCHAR(500),
			PL_348 VARCHAR(500),
			PL_349 VARCHAR(500),
			PL_350 VARCHAR(500),
			PL_351 VARCHAR(500),
			PL_352 VARCHAR(500),
			PL_353 VARCHAR(500),
			PL_354 VARCHAR(500),
			PL_355 VARCHAR(500),
			PL_356 VARCHAR(500),
			PL_357 VARCHAR(500),
			PL_358 VARCHAR(500),
			PL_359 VARCHAR(500),
			PL_360 VARCHAR(500),
			PL_361 VARCHAR(500),
			PL_362 VARCHAR(500),
			PL_363 VARCHAR(500),
			PL_364 VARCHAR(500),
			PL_365 VARCHAR(500),
			PL_366 VARCHAR(500),
			PL_367 VARCHAR(500),
			PL_368 VARCHAR(500),
			PL_369 VARCHAR(500),
			PL_370 VARCHAR(500),
			PL_371 VARCHAR(500),
			PL_372 VARCHAR(500),
			PL_373 VARCHAR(500),
			PL_374 VARCHAR(500),
			PL_375 VARCHAR(500),
			PL_376 VARCHAR(500),
			PL_377 VARCHAR(500),
			PL_378 VARCHAR(500),
			PL_379 VARCHAR(500),
			PL_380 VARCHAR(500),
			PL_381 VARCHAR(500),
			PL_382 VARCHAR(500),
			PL_383 VARCHAR(500),
			PL_384 VARCHAR(500),
			PL_385 VARCHAR(500),
			PL_386 VARCHAR(500),
			PL_387 VARCHAR(500),
			PL_388 VARCHAR(500),
			PL_389 VARCHAR(500),
			PL_390 VARCHAR(500),
			PL_391 VARCHAR(500),
			PL_392 VARCHAR(500),
			PL_393 VARCHAR(500),
			PL_394 VARCHAR(500),
			PL_395 VARCHAR(500)--,
			--PL_396 VARCHAR(500),
			--PL_397 VARCHAR(500),
			--PL_398 VARCHAR(500),
			--PL_399 VARCHAR(500),
			--PL_400 VARCHAR(500)
			--,PL_401 VARCHAR(500),
			--PL_402 VARCHAR(500),
			--PL_403 VARCHAR(500),
			--PL_404 VARCHAR(500),
			--PL_405 VARCHAR(500),
			--PL_406 VARCHAR(500),
			--PL_407 VARCHAR(500),
			--PL_408 VARCHAR(500),
			--PL_409 VARCHAR(500),
			--PL_410 VARCHAR(500),
			--PL_411 VARCHAR(500),
			--PL_412 VARCHAR(500),
			--PL_413 VARCHAR(500),
			--PL_414 VARCHAR(500),
			--PL_415 VARCHAR(500),
			--PL_416 VARCHAR(500),
			--PL_417 VARCHAR(500),
			--PL_418 VARCHAR(500),
			--PL_419 VARCHAR(500),
			--PL_420 VARCHAR(500),
			--PL_421 VARCHAR(500),
			--PL_422 VARCHAR(500),
			--PL_423 VARCHAR(500),
			--PL_424 VARCHAR(500),
			--PL_425 VARCHAR(500),
			--PL_426 VARCHAR(500),
			--PL_427 VARCHAR(500),
			--PL_428 VARCHAR(500),
			--PL_429 VARCHAR(500),
			--PL_430 VARCHAR(500),
			--PL_431 VARCHAR(500),
			--PL_432 VARCHAR(500),
			--PL_433 VARCHAR(500),
			--PL_434 VARCHAR(500),
			--PL_435 VARCHAR(500),
			--PL_436 VARCHAR(500),
			--PL_437 VARCHAR(500),
			--PL_438 VARCHAR(500),
			--PL_439 VARCHAR(500),
			--PL_440 VARCHAR(500),
			--PL_441 VARCHAR(500),
			--PL_442 VARCHAR(500),
			--PL_443 VARCHAR(500),
			--PL_444 VARCHAR(500),
			--PL_445 VARCHAR(500),
			--PL_446 VARCHAR(500),
			--PL_447 VARCHAR(500),
			--PL_448 VARCHAR(500),
			--PL_449 VARCHAR(500),
			--PL_450 VARCHAR(500)
		)

		------------------ TABLES FOR FINAL OUTPUT END

	END

	PRINT 'STEP-1 POPULATE BASE FILTER CRITERIA -->' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		DECLARE @MHCnt INT = 0, @MHAllCnt INT = 0, @EX_YES INT = 3, @EX_NO INT = 3, @EX_CO INT = 3
		IF(UPPER(@Exclusivity) = 'E')
		BEGIN
			SET @EX_YES = 1
			SET @EX_CO = 2
		END
		ELSE IF(UPPER(@Exclusivity) = 'N')
		BEGIN
			SET @EX_NO = 0
		END
		ELSE IF(UPPER(@Exclusivity) = 'B')
		BEGIN
			SET @EX_YES = 1
			SET @EX_NO = 0
			SET @EX_CO = 2
		END
	
		BEGIN----------------- TITLE SEARCH IMPLEMENTATION 

			INSERT INTO #SearchTitle(TitleCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@TitleCodes, ',') WHERE [value] NOT IN('0', '')
		
			DELETE FROM #SearchTitle WHERE TitleCode = 0

			IF NOT EXISTS(SELECT TOP 1 * FROM #SearchTitle)
			BEGIN
				INSERT INTO #SearchTitle
				SELECT DISTINCT Title_Code FROM Avail_Title_Data
			END
			
		END ------------------ END

		BEGIN ----------------- SUBLICENSE SEARCH 

			INSERT INTO #SearchSubLicense(SubLicenseCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@SubLicenseCode, ',') WHERE ISNULL([value], 0) NOT IN('0', '')
		
			IF NOT EXISTS(SELECT TOP 1 * FROM #SearchSubLicense)
			BEGIN
				
				INSERT INTO #SearchSubLicense
				SELECT Sub_License_Code FROM Sub_License

			END
			
			--DELETE FROM #AvailTitleData WHERE Avail_Country_Code NOT IN (SELECT Avail_Country_Code FROM #DBAvailCountry)

		END ------------------ END

		INSERT INTO #AvailTitleData(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Avail_Dates_Code, Is_Exclusive, 
									Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code)
		SELECT DISTINCT adr.Acq_Deal_Code, atd.Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, atd.Avail_Dates_Code, atd.Is_Exclusive, 
				Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code
		FROM Avail_Title_Data atd
		INNER JOIN Avail_Dates adt ON adt.Avail_Dates_Code = atd.Avail_Dates_Code
		INNER JOIN #SearchTitle st ON atd.Title_Code = st.TitleCode
		INNER JOIN Acq_Deal_Rights adr ON atd.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal ad On adr.Acq_Deal_Code = ad.Acq_Deal_Code
		INNER JOIN #SearchSubLicense tsl On tsl.SubLicenseCode = adr.Sub_License_Code
		WHERE (ad.Business_Unit_Code = CAST(@BUCode AS INT) OR  CAST(@BUCode AS INT) = 0) AND atd.Is_Exclusive IN (@Ex_YES, @Ex_NO, @EX_CO)
		AND ISNULL(adt.End_Date, '9999-12-31') >= CAST(GETDATE() AS DATE)

	END

	PRINT 'STEP-2 SET / POPULATE FILTER CRITERIA -->' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		BEGIN ----------------- LICENSE PERIOD CRITERIA IMPLEMENTATION 

			IF(@DateType = 'MI' OR @DateType = 'FI')
			BEGIN
				INSERT INTO #DBAvailDates(Avail_Dates_Code, StartDate, EndDate)
				SELECT Avail_Dates_Code, Start_Date, End_Date 
				FROM Avail_Dates 
				WHERE (ISNULL(Start_Date, '9999-12-31') <= @StartDate AND ISNULL(End_Date, '9999-12-31') >= @EndDate)
			END
			ELSE
			BEGIN
				INSERT INTO #DBAvailDates(Avail_Dates_Code, StartDate, EndDate)
				SELECT Avail_Dates_Code, Start_Date, End_Date FROM Avail_Dates 
				WHERE (
					(ISNULL(Start_Date, '9999-12-31') BETWEEN @StartDate AND  @EndDate)
					OR (ISNULL(End_Date, '9999-12-31') BETWEEN @StartDate AND @EndDate)
					OR (@StartDate BETWEEN  ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
					OR (@EndDate BETWEEN ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
				)
			END

			UPDATE #DBAvailDates SET StartDate = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE StartDate < GETDATE()
			
			DELETE FROM #AvailTitleData WHERE Avail_Dates_Code NOT IN (SELECT Avail_Dates_Code FROM #DBAvailDates)

		END ------------------ END

		BEGIN ----------------- PLATFORM SEARCH / MUST HAVE / EXACT MATCH IMPLEMENTATION 

			INSERT INTO #SearchPlatform(PlatformCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@PlatformCodes,',') WHERE [value] NOT IN('0', '')
	
			INSERT INTO #SearchPlatformMH(PlatformCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@MustHavePlatforms, ',') WHERE [value] NOT IN('0', '')
			
			DELETE FROM #SearchPlatform WHERE PlatformCode = 0
			DELETE FROM #SearchPlatformMH WHERE PlatformCode = 0
	
			IF NOT EXISTS(SELECT * FROM #SearchPlatform)
			BEGIN
		
				INSERT INTO #SearchPlatform
				SELECT c.Platform_Code FROM Platform c WHERE ISNULL(c.Is_Active, 'N') = 'Y'

				INSERT INTO #DBAvailPlatform(Avail_Platform_Code, PlatformCodes)
				SELECT DISTINCT ap.Avail_Platform_Code, Platform_Codes FROM Avail_Platforms ap
				INNER JOIN #AvailTitleData atd ON ap.Avail_Platform_Code = atd.Avail_Platform_Code
				--SELECT Avail_Platform_Code, SUBSTRING(Platform_Codes, 2, LEN(Platform_Codes) - 2) FROM Avail_Platforms
				
			END
			ELSE
			BEGIN
			
				DECLARE @PlatformCode VARCHAR(10) = ''

				DECLARE CurPlatform CURSOR FOR SELECT PlatformCode FROM #SearchPlatform ORDER BY Cast(PlatformCode AS VARCHAR(10)) ASC
				OPEN CurPlatform
				FETCH NEXT FROM CurPlatform INTO @PlatformCode
				WHILE (@@FETCH_STATUS = 0)
				BEGIN

					SET @MHCnt = 0
					IF EXISTS (SELECT TOP 1 * FROM #SearchPlatformMH WHERE PlatformCode = @PlatformCode)
					BEGIN
						SET @MHCnt = 1
					END

					MERGE INTO #DBAvailPlatform AS tmp
					USING Avail_Platforms al On tmp.Avail_Platform_Code = al.Avail_Platform_Code AND al.Platform_Codes Like '%,' + @PlatformCode + ',%'
					WHEN MATCHED THEN
						UPDATE SET tmp.PlatformCodes = tmp.PlatformCodes + ',' + @PlatformCode, PlatCnt = PlatCnt + @MHCnt
					WHEN NOT MATCHED AND al.Platform_Codes Like '%,' + @PlatformCode + ',%' THEN
						INSERT VALUES (al.Avail_Platform_Code, @PlatformCode, '', @MHCnt)
					;

					FETCH NEXT FROM CurPlatform INTO @PlatformCode	
				END
				CLOSE CurPlatform
				DEALLOCATE CurPlatform

				IF(UPPER(@ExactMatchPlatforms) = 'EM')
				BEGIN
			
					DECLARE @PlatStr VARCHAR(1000) = ''
					SELECT @PlatStr = 
					STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(PlatformCode AS VARCHAR) FROM #SearchPlatform
							FOR XML PATH('')
						), 1, 1, ''
					)
			
					DELETE FROM #DBAvailPlatform WHERE PlatformCodes <> @PlatStr

				END
		
				IF(UPPER(@ExactMatchPlatforms) = 'MH')
				BEGIN
				
					SELECT @MHAllCnt = 0
					SELECT @MHAllCnt = COUNT(*) FROM #SearchPlatformMH
					DELETE FROM #DBAvailPlatform WHERE PlatCnt <> @MHAllCnt

				END
			END

			DELETE FROM #AvailTitleData WHERE Avail_Platform_Code NOT IN (SELECT Avail_Platform_Code FROM #DBAvailPlatform)
			DELETE FROM #DBAvailPlatform WHERE Avail_Platform_Code NOT IN (SELECT Avail_Platform_Code FROM #AvailTitleData)
			
			--SELECT * FROM #DBAvailPlatform
			--RETURN
		END------------------ END
			
		BEGIN ----------------- COUNTRY SEARCH / MUST HAVE / EXACT MATCH IMPLEMENTATION 
		
			INSERT INTO #SearchCountry(CountryCode)
			SELECT DISTINCT [value] FROM STRING_SPLIT(@CountryCodes , ',') WHERE [value] NOT IN('0')
			
			DELETE FROM #SearchCountry WHERE CountryCode = 0
	
			IF NOT EXISTS(SELECT * FROM #SearchCountry)
			BEGIN
		
				INSERT INTO #SearchCountry
				SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active, 'N') = 'Y'

				INSERT INTO #DBAvailCountry(Avail_Country_Code, CountryCode)
				SELECT DISTINCT ac.Avail_Country_Code, SUBSTRING(Country_Codes, 2, LEN(Country_Codes) - 2) FROM Avail_Countries ac
				INNER JOIN #AvailTitleData atd ON ac.Avail_Country_Code = atd.Avail_Country_Code

			END
			ELSE
			BEGIN

				IF(@IsIFTACluster = 'N')
				BEGIN

					INSERT INTO #SearchCountry(CountryCode)
					SELECT DISTINCT Country_Code FROM Territory_Details td WHERE td.Territory_Code IN (
						SELECT [value] FROM STRING_SPLIT(@TerritoryCodes, ',') WHERE [value] NOT IN('0')
					) AND td.Country_Code NOT IN (
						SELECT tc.CountryCode FROM #SearchCountry tc
					)
					AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
					AND td.Country_Code NOT IN (SELECT [value] FROM STRING_SPLIT(@ExclusionCountry, ',') WHERE [value] NOT IN ( '0', ''))

				END
				ELSE IF(@IsIFTACluster = 'Y')
				BEGIN
		
					INSERT INTO #SearchCountry(CountryCode)
					SELECT DISTINCT Country_Code FROM Report_Territory_Country td WHERE td.Report_Territory_Code IN (
						SELECT [value] FROM STRING_SPLIT(@TerritoryCodes, ',') WHERE [value] NOT IN('0')
					) AND td.Country_Code NOT IN (
						SELECT tc.CountryCode FROM #SearchCountry tc
					)
					AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
					AND td.Country_Code NOT IN (SELECT [value] FROM STRING_SPLIT(@ExclusionCountry, ',') WHERE [value] NOT IN ( '0', ''))

				END
			
				INSERT INTO #SearchCountryMH(CountryCode)
				SELECT CAST([value] AS INT) FROM STRING_SPLIT(@MustHaveCountry, ',') WHERE [value] NOT IN('0', '')
			
				DELETE FROM #SearchCountryMH WHERE CountryCode = 0
	
				DECLARE @CountryCode VARCHAR(10) = ''
				IF(ISNULL(@ExclusionCountry, '') = '')
					SET @ExclusionCountry = '0'

				DECLARE CurCountry CURSOR FOR SELECT CountryCode FROM #SearchCountry
												WHERE CountryCode Not In (
													SELECT CAST([value] AS INT) [value] FROM STRING_SPLIT(@ExclusionCountry, ',')
												)
												ORDER BY Cast(CountryCode AS VARCHAR(10)) ASC
				OPEN CurCountry
				FETCH NEXT FROM CurCountry INTO @CountryCode
				WHILE (@@FETCH_STATUS = 0)
				BEGIN

					SET @MHCnt = 0
					IF EXISTS (SELECT TOP 1 * FROM #SearchCountryMH WHERE CountryCode = @CountryCode)
					BEGIN
						SET @MHCnt = 1
					END
					
					MERGE INTO #DBAvailCountry AS tmp
					USING Avail_Countries al On tmp.Avail_Country_Code = al.Avail_Country_Code AND al.Country_Codes Like '%,' + @CountryCode + ',%'
					WHEN MATCHED THEN
						UPDATE SET tmp.CountryCode = tmp.CountryCode + ',' + @CountryCode, ContCnt = ContCnt + @MHCnt
					WHEN NOT MATCHED AND al.Country_Codes Like '%,' + @CountryCode + ',%' THEN
						INSERT VALUES (al.Avail_Country_Code, @CountryCode, '', '', @MHCnt)
					;

					FETCH NEXT FROM CurCountry INTO @CountryCode	
				END
				CLOSE CurCountry
				DEALLOCATE CurCountry

				IF(UPPER(@ExactMatchCountry) = 'EM')
				BEGIN
			
					DECLARE @ContStr VARCHAR(1000) = ''
					SELECT @ContStr = 
					STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(CountryCode AS VARCHAR) FROM #SearchCountry
							FOR XML PATH('')
						), 1, 1, ''
					)
			
					DELETE FROM #DBAvailCountry WHERE CountryCode <> @ContStr

				END
		
				IF(UPPER(@ExactMatchCountry) = 'MH')
				BEGIN
				
					SELECT @MHAllCnt = 0
					SELECT @MHAllCnt = COUNT(*) FROM #SearchCountryMH
					DELETE FROM #DBAvailCountry WHERE ContCnt <> @MHAllCnt

				END
			END
			
			DELETE FROM #AvailTitleData WHERE Avail_Country_Code NOT IN (SELECT Avail_Country_Code FROM #DBAvailCountry)
			DELETE FROM #DBAvailCountry WHERE Avail_Country_Code NOT IN (SELECT Avail_Country_Code FROM #AvailTitleData)

		END ------------------ END
	
		BEGIN ----------------- LANGUAGE SEARCH / EXACT MATCH / MUST HAVE IMPLEMENTATION 

			SELECT @SubtitlingCodes = LTRIM(RTRIM(@SubtitlingCodes)), @SubtitlingGroupCodes = LTRIM(RTRIM(@SubtitlingGroupCodes)), @TitleLanguageCode = LTRIM(RTRIM(@TitleLanguageCode)),
				   @DubbingCodes = LTRIM(RTRIM(@DubbingCodes)), @DubbingGroupCodes = LTRIM(RTRIM(@DubbingGroupCodes))
		
			INSERT INTO #SearchTitleLanguage(LanguageCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@TitleLanguageCode,',') WHERE [value] NOT IN('0', '')
			
			INSERT INTO #SearchSubtitling(LanguageCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@SubtitlingCodes, ',') WHERE [value] NOT IN('0', '')
	
			INSERT INTO #SearchSubtitling(LanguageCode)
			SELECT DISTINCT Language_Code FROM Language_Group_Details td WHERE td.Language_Group_Code IN (
				SELECT [value] FROM STRING_SPLIT(@SubtitlingGroupCodes, ',') WHERE [value] NOT IN('0')
			) AND td.Language_Code NOT IN (
				SELECT tc.LanguageCode FROM #SearchSubtitling tc
			)
			AND td.Language_Code IN (SELECT l.Language_Code FROM Language l WHERE ISNULL(l.Is_Active, 'N') = 'Y')

			INSERT INTO #SearchDubbing(LanguageCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@DubbingCodes, ',') WHERE [value] NOT IN('0', '')
	
			INSERT INTO #SearchDubbing(LanguageCode)
			SELECT DISTINCT Language_Code FROM Language_Group_Details td WHERE td.Language_Group_Code IN (
				SELECT [value] FROM STRING_SPLIT(@DubbingGroupCodes, ',') WHERE [value] NOT IN('0')
			) AND td.Language_Code NOT IN (
				SELECT tc.LanguageCode FROM #SearchDubbing tc
			)
			AND td.Language_Code IN (SELECT l.Language_Code FROM Language l WHERE ISNULL(l.Is_Active, 'N') = 'Y')

			INSERT INTO #SearchSubtitlingMH(LanguageCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@MustHaveSubtitling, ',') WHERE [value] NOT IN('0', '')
	
			INSERT INTO #SearchDubbingMH(LanguageCode)
			SELECT CAST([value] AS INT) FROM STRING_SPLIT(@MustHaveDubbing, ',') WHERE [value] NOT IN('0', '')
	
			DELETE FROM #SearchTitleLanguage WHERE LanguageCode = 0
			DELETE FROM #SearchSubtitling WHERE LanguageCode = 0
			DELETE FROM #SearchSubtitlingMH WHERE LanguageCode = 0
			DELETE FROM #SearchDubbing WHERE LanguageCode = 0
			DELETE FROM #SearchDubbingMH WHERE LanguageCode = 0
		
			DECLARE @LanguageCode VARCHAR(10) = ''
			IF(CHARINDEX('S', @DubbingSubtitling) > 0)
			BEGIN
	
				IF(ISNULL(@ExclusionSubtitling, '') = '')
					SET @ExclusionSubtitling = '0'

				DECLARE CurLanguage CURSOR FOR SELECT LanguageCode FROM #SearchSubtitling 
												WHERE LanguageCode Not In (
													SELECT CAST([value] AS INT) [value] FROM STRING_SPLIT(@ExclusionSubtitling, ',')
												)
												ORDER BY Cast(LanguageCode AS VARCHAR(10)) ASC
				OPEN CurLanguage
				FETCH NEXT FROM CurLanguage INTO @LanguageCode
				WHILE (@@FETCH_STATUS = 0)
				BEGIN

					SET @MHCnt = 0
					IF EXISTS (SELECT TOP 1 * FROM #SearchSubtitlingMH WHERE LanguageCode = @LanguageCode)
					BEGIN
						SET @MHCnt = 1
					END

					MERGE INTO #DBAvailLanguages AS tmp
					USING Avail_Languages al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @LanguageCode + ',%'
					WHEN MATCHED THEN
						UPDATE SET tmp.LanguageCodes = tmp.LanguageCodes + ',' + @LanguageCode, LangCnt = LangCnt + @MHCnt
					WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @LanguageCode + ',%' THEN
						INSERT VALUES (al.Avail_Languages_Code, @LanguageCode, '', 'S', @MHCnt)
					;

					FETCH NEXT FROM CurLanguage INTO @LanguageCode	
				END
				CLOSE CurLanguage
				DEALLOCATE CurLanguage

				IF(UPPER(@ExactMatchSubtitling) = 'EM')
				BEGIN
			
					DECLARE @SubStr VARCHAR(1000) = ''
					SELECT @SubStr = 
					STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(LanguageCode AS VARCHAR) FROM #SearchSubtitling
							FOR XML PATH('')
						), 1, 1, ''
					)
			
					DELETE FROM #DBAvailLanguages WHERE LanguageCodes <> @SubStr AND LangType = 'S'

				END
		
				IF(UPPER(@ExactMatchSubtitling) = 'MH')
				BEGIN
					SELECT @MHAllCnt = COUNT(*) FROM #SearchSubtitlingMH
					DELETE FROM #DBAvailLanguages WHERE LangCnt <> @MHAllCnt AND LangType = 'S'
				END
			END

			IF(CHARINDEX('D', @DubbingSubtitling) > 0)
			BEGIN
		
				IF(ISNULL(@ExclusionDubbing, '') = '')
					SET @ExclusionDubbing = '0'

				DECLARE CurLanguage CURSOR FOR SELECT LanguageCode FROM #SearchDubbing 
												WHERE LanguageCode Not In (
													SELECT CAST([value] AS INT) [value] FROM STRING_SPLIT(@ExclusionDubbing,',')
												)
												ORDER BY Cast(LanguageCode AS VARCHAR(10)) ASC
				OPEN CurLanguage
				FETCH NEXT FROM CurLanguage INTO @LanguageCode
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
		
					SET @MHCnt = 0
					IF EXISTS (SELECT TOP 1 * FROM #SearchDubbingMH WHERE LanguageCode = @LanguageCode)
					BEGIN
						SET @MHCnt = + 1
					END

					MERGE INTO #DBAvailLanguages AS tmp
					USING Avail_Languages al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @LanguageCode + ',%' AND tmp.LangType = 'D'
					WHEN MATCHED THEN
						UPDATE SET tmp.LanguageCodes = tmp.LanguageCodes + ',' + @LanguageCode, LangCnt = LangCnt + @MHCnt
					WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @LanguageCode + ',%' THEN
						INSERT VALUES (al.Avail_Languages_Code, @LanguageCode, '', 'D', @MHCnt)
					;

					FETCH NEXT FROM CurLanguage INTO @LanguageCode	
				END
				CLOSE CurLanguage
				DEALLOCATE CurLanguage
		
				IF(UPPER(@ExactMatchDubbing) = 'EM')
				BEGIN
			
					DECLARE @DubStr VARCHAR(1000) = ''
					SELECT @DubStr = 
					STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(LanguageCode AS VARCHAR) FROM #SearchDubbing
							FOR XML PATH('')
						), 1, 1, ''
					)
			
					DELETE FROM #DBAvailLanguages WHERE LanguageCodes <> @DubStr AND LangType = 'D'
				END
		
				IF(UPPER(@ExactMatchDubbing) = 'MH')
				BEGIN
					SELECT @MHAllCnt = COUNT(*) FROM #SearchDubbingMH
					DELETE FROM #DBAvailLanguages WHERE LangCnt <> @MHAllCnt AND LangType = 'D'
				END
			END

			UPDATE #AvailTitleData SET Avail_Subtitling_Code = NULL WHERE Avail_Subtitling_Code NOT IN (SELECT Avail_Languages_Code FROM #DBAvailLanguages WHERE LangType = 'S')
			UPDATE #AvailTitleData SET Avail_Dubbing_Code = NULL WHERE Avail_Subtitling_Code NOT IN (SELECT Avail_Languages_Code FROM #DBAvailLanguages WHERE LangType = 'D')
			IF(@IsTitleLanguage = 'Y')
			BEGIN
				UPDATE #AvailTitleData SET Is_Title_Language = NULL WHERE Is_Title_Language = 0
			END

			DELETE FROM #AvailTitleData WHERE Is_Title_Language IS NULL AND Avail_Subtitling_Code IS NULL AND Avail_Dubbing_Code IS NULL

		END ------------------ END
		
	END

	PRINT 'STEP-3 SET / POPULATE LANGUAGE NAMES --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
	BEGIN

		INSERT INTO #TempLanguageNames(LanguageCodes)
		SELECT DISTINCT LanguageCodes FROM #DBAvailLanguages
	
		UPDATE #TempLanguageNames SET LanguageNames = [dbo].[UFN_Get_Language_With_Parent](LanguageCodes)

		UPDATE tm SET tm.LanguageNames = tml.LanguageNames
		FROM #DBAvailLanguages tm 
		INNER JOIN #DBAvailLanguages tml ON tm.LanguageCodes = tml.LanguageCodes

	END
	
	PRINT 'STEP-4 POPULATE REMARKS --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		DECLARE @strSQLNEO AS VARCHAR(MAX)
		DECLARE @Sub_License_Code_Avail VARCHAR(10)
		--SELECT @Sub_License_Code_Avail = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Sub_License_Code_Avail'

		IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
		BEGIN
		
			INSERT INTO #TempRightRemarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name)
			SELECT DISTINCT ar.Acq_Deal_Rights_Code, ar.Restriction_Remarks, 
				   ad.Remarks, ad.Rights_Remarks, 
				   (
						STUFF((SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
						FROM Acq_Deal AD_Tmp
						INNER JOIN Acq_Deal_Rights ADR_Tmp ON adr_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
						WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
						(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = ar.Acq_Deal_Code)
						FOR XML PATH(''),type).value('.', 'NVARCHAR(MAX)'),1,1,'')
					) As Sub_Deal_Restriction_Remark, 
					CASE WHEN ISNULL(ar.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END
			FROM Acq_Deal_Rights ar
			INNER JOIN (SELECT DISTINCT Acq_Deal_Rights_Code FROM #AvailTitleData) ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal ad On ar.Acq_Deal_Code = ad.Acq_Deal_Code
			INNER JOIN Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code
			
		END
		ELSE
		BEGIN
		
			INSERT INTO #TempRightRemarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name)
			SELECT DISTINCT ar.Acq_Deal_Rights_Code, '', '', '', '', 
			CASE WHEN ISNULL(ar.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END
			FROM Acq_Deal_Rights ar
			INNER JOIN (SELECT DISTINCT Acq_Deal_Rights_Code FROM #AvailTitleData) ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			INNER JOIN Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code

		END

	END

	PRINT 'STEP-5 POPULATE TITLE INFO --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
	BEGIN
		-----------------Query to get title details

		INSERT INTO #TempTitlesInfo(Title_Code, Title_Language_Code, Title_Type,
									Title_Name,
									Genres_Name,
									Star_Cast,
									Director,
									Duration_In_Min, Year_Of_Production, Language_Name)
		SELECT t.Title_Code, t.Title_Language_Code, dt.Deal_Type_Name,
			CASE WHEN ISNULL(Year_Of_Production, '') = '' THEN Title_Name ELSE Title_Name + ' ('+ CAST(Year_Of_Production AS VARCHAR(10)) + ')' END Title_Name
			,Genres_Name = [dbo].[UFNGetGenresForTitle](t.Title_Code),
			Star_Cast = [dbo].[UFNGetTalentForTitle](t.Title_Code, 2),
			Director = [dbo].[UFNGetTalentForTitle](t.Title_Code, 1),
			COALESCE(t.Duration_In_Min, '0') Duration_In_Min, COALESCE(t.Year_Of_Production, '') Year_Of_Production, l.Language_Name
		FROM Title t 
		INNER JOIN Language l On t.Title_Language_Code = l.Language_Code
		INNER JOIN Deal_Type dt ON t.Deal_Type_Code = dt.Deal_Type_Code
		WHERE(t.Title_Code IN (SELECT tm.Title_Code FROM #AvailTitleData tm))
		
		------------------END
	END
	
	PRINT 'STEP-6 POPULATE PLATFORMWISE DATA --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
	BEGIN

		DELETE FROM #DBAvailPlatform WHERE Avail_Platform_Code NOT IN (
			SELECT DISTINCT Avail_Platform_Code FROM #AvailTitleData
		)

		PRINT 'STEP-6.1 DELETE Platform --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	

		INSERT INTO #TempPlatformData(Avail_Platform_Code, PlatformCode)
		SELECT dap.Avail_Platform_Code, a.value FROM #DBAvailPlatform dap
		CROSS APPLY STRING_SPLIT(dap.PlatformCodes, ',') a
		WHERE a.value <> '' 
		AND LEN(a.value) <= 3 ----- Need to remove this condition when priyal sir recheck and 
		
		PRINT 'STEP-6.2 Insert INTO Platform --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	

		--SELECT * FROM #TempPlatformData
		--ORDER BY 2 DESC
		--RETURN
		--UPDATE tpd SET tpd.PlatformName = p.Platform_Hiearachy
		--FROM #TempPlatformData tpd
		--INNER JOIN Platform p ON tpd.PlatformCode = p.Platform_Code

		INSERT INTO #TempMain(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, Avail_Country_Code, Start_Date, End_Date, 
							  Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code, Available)
		SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, tpd.PlatformCode, Avail_Country_Code, dad.StartDate, dad.EndDate,
			   Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code, 'Yes'
		FROM #AvailTitleData atd
		INNER JOIN #TempPlatformData tpd ON atd.Avail_Platform_Code = tpd.Avail_Platform_Code
		INNER JOIN #DBAvailDates dad ON atd.Avail_Dates_Code = dad.Avail_Dates_Code
		
		PRINT 'STEP-6.3 Insert INTO Platform --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	

	END

	--SELECT * FROM #TempMain WHERE Acq_Deal_Rights_Code = 2279 AND Platform_Code IN (19,20)
	--RETURN

	print 'STEP-7 GENERATE HOLDBACK DATA --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
	BEGIN
		
		INSERT INTO #TempMainHB(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, Country_Code, Start_Date, End_Date, 
							  Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code)
		SELECT tm.Acq_Deal_Code, tm.Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, a.[value], tm.Start_Date, tm.End_Date, 
							  Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code
		FROM #TempMain tm
		INNER JOIN Acq_Deal_Rights_Holdback hb ON hb.Acq_Deal_Rights_Code = tm.Acq_Deal_Rights_Code
		INNER JOIN #DBAvailCountry dac ON tm.Avail_Country_Code = dac.Avail_Country_Code
		CROSS APPLY STRING_SPLIT(dac.CountryCode, ',') a 
		WHERE a.[value] <> ''
		AND LEN(a.[value]) <= 3
		
		PRINT 'STEP-7.1 HB Data Gen --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	

		DELETE FROM #TempMain 
		WHERE Acq_Deal_Rights_Code IN (
			SELECT DISTINCT b.Acq_Deal_Rights_Code FROM #TempMainHB b
		)
		
		PRINT 'STEP-7.1 HB Data Gen --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
		--RETURN

		UPDATE ar
		SET ar.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code, ar.Holdback_Type = hb.Holdback_Type, 
			ar.Holdback_Release_Date = hb.Holdback_Release_Date, ar.Holdback_On_Platform_Code = hb.Holdback_On_Platform_Code
		FROM Acq_Deal_Rights_Holdback hb
		INNER JOIN #TempMainHB ar On hb.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Platform hbp On hb.Acq_Deal_Rights_Holdback_Code = hbp.Acq_Deal_Rights_Holdback_Code AND ar.Platform_Code = hbp.Platform_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Territory hbt On hb.Acq_Deal_Rights_Holdback_Code = hbt.Acq_Deal_Rights_Holdback_Code AND ar.Country_Code = hbt.Country_Code
		WHERE (hb.Holdback_Type = 'D' And CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME) > hb.Holdback_Release_Date AND hb.Holdback_Release_Date > GETDATE()) Or hb.Holdback_Type = 'R'
		
		INSERT INTO #MainHBTitles(Title_Code)
		SELECT DISTINCT Title_Code FROM #TempMainHB

		INSERT INTO #MainHBDetails(Acq_Deal_Rights_Holdback_Code, Holdback_Type, HBComments, HB_Run_After_Release_No, HB_Run_After_Release_Units)
		SELECT DISTINCT Acq_Deal_Rights_Holdback_Code, Holdback_Type, '', 0, 0
		FROM #TempMainHB WHERE Acq_Deal_Rights_Holdback_Code Is Not NULL

		UPDATE thb
		SET thb.HBComments = CASE WHEN hb.HB_Run_After_Release_No < 0 THEN 'Before ' ELSE 'After ' END + Cast (ABS(hb.HB_Run_After_Release_No) AS VARCHAR(10)) + 
							 CASE hb.HB_Run_After_Release_Units WHEN 1 THEN ' Days' WHEN 2 THEN ' Weeks' WHEN 3 THEN ' Months' WHEN 4 THEN ' Years' END + ' On ',
			thb.HB_Run_After_Release_No = hb.HB_Run_After_Release_No,
			thb.HB_Run_After_Release_Units = hb.HB_Run_After_Release_Units
		FROM #MainHBDetails thb
		INNER JOIN Acq_Deal_Rights_Holdback hb On thb.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code

		INSERT INTO #MainReleaseCountry(Title_Release_Code, Country_Code)
		SELECT DISTINCT tr.Title_Release_Code, Country_Code 
		FROM Title_Release tr
		INNER JOIN #MainHBTitles mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Region trr On tr.Title_Release_Code = trr.Title_Release_Code And Country_Code Is Not NULL
		UNION
		SELECT DISTINCT tr.Title_Release_Code, trd.Country_Code 
		FROM Title_Release tr
		INNER JOIN #MainHBTitles mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Region trr On tr.Title_Release_Code = trr.Title_Release_Code And Territory_Code Is Not NULL
		INNER JOIN Territory_Details trd On trr.Territory_Code = trd.Territory_Code

		--SELECT * FROM #TempMainHB WHERE Holdback_Release_Date IS NOT NULL
		UPDATE tm SET tm.Holdback_Release_Date = CASE mh.HB_Run_After_Release_Units 
													  WHEN 1 THEN DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
													  WHEN 2 THEN DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
													  WHEN 3 THEN DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
													  WHEN 4 THEN DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
													  ELSE tr.Release_Date
												 END
		FROM Title_Release tr
		INNER JOIN #MainHBTitles mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Platforms trp On tr.Title_Release_Code = trp.Title_Release_Code
		INNER JOIN #MainReleaseCountry trc On tr.Title_Release_Code = trc.Title_Release_Code
		INNER JOIN #TempMainHB tm On tm.Title_Code = tr.Title_Code AND tm.Title_Code = mt.Title_Code 
								   AND tm.Holdback_On_Platform_Code = trp.Platform_Code AND tm.Country_Code = trc.Country_Code
								   AND tm.Holdback_Type = 'R'
		INNER JOIN #MainHBDetails mh On tm.Acq_Deal_Rights_Holdback_Code = mh.Acq_Deal_Rights_Holdback_Code
		WHERE 
			CASE mh.HB_Run_After_Release_Units 
				WHEN 1 THEN DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
				WHEN 2 THEN DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
				WHEN 3 THEN DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
				WHEN 4 THEN DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
				ELSE tr.Release_Date
			END >= CAST(GETDATE() AS DATE)

		DELETE mh
		FROM Title_Release tr
		INNER JOIN #MainHBTitles mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Platforms trp On tr.Title_Release_Code = trp.Title_Release_Code
		INNER JOIN #MainReleaseCountry trc On tr.Title_Release_Code = trc.Title_Release_Code
		INNER JOIN #TempMainHB tm On tm.Title_Code = tr.Title_Code AND tm.Title_Code = mt.Title_Code 
								   AND tm.Holdback_On_Platform_Code = trp.Platform_Code AND tm.Country_Code = trc.Country_Code
								   AND tm.Holdback_Type = 'R'
		INNER JOIN #MainHBDetails mh On tm.Acq_Deal_Rights_Holdback_Code = mh.Acq_Deal_Rights_Holdback_Code
		WHERE 
			CASE mh.HB_Run_After_Release_Units 
				WHEN 1 THEN DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
				WHEN 2 THEN DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
				WHEN 3 THEN DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
				WHEN 4 THEN DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
				ELSE tr.Release_Date
			END < Cast(GETDATE() As Date)

	END
	
	print 'STEP-8 COUNTRY GROUPING POST HOLDBACK --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
	BEGIN

		INSERT INTO #TempMain(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, Start_Date, End_Date, 
							  Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code, 
							  Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, Available, 
							  Country_Cd_Str)
		SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, Start_Date, End_Date, 
			   Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code, 
			   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, 'Yes',
			   STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #TempMainHB t1 
						WHERE t1.Title_Code = t2.Title_Code
							  AND t1.Episode_From = t2.Episode_From
							  AND t1.Episode_To = t2.Episode_To
							  AND t1.Platform_Code = t2.Platform_Code
							  AND t1.Acq_Deal_Rights_Code = t2.Acq_Deal_Rights_Code
							  AND t1.Is_Exclusive = t2.Is_Exclusive
							  AND t1.Start_Date = t2.Start_Date
							  AND ISNULL(t1.End_Date, '31DEC9999') = ISNULL(t1.End_Date, '31DEC9999')
							  AND t1.Is_Title_Language = t2.Is_Title_Language
							  AND IsNull(t1.Avail_Subtitling_Code, 0) = IsNull(t2.Avail_Subtitling_Code, 0)
							  AND IsNull(t1.Avail_Dubbing_Code, 0) = IsNull(t2.Avail_Dubbing_Code, 0)
							  -------- Conditions for  Holdback
							  AND IsNull(t1.Acq_Deal_Rights_Holdback_Code, 0) = IsNull(t2.Acq_Deal_Rights_Holdback_Code, 0)
							  AND IsNull(t1.Holdback_Type, '') = IsNull(t2.Holdback_Type, '')
							  AND IsNull(t1.Holdback_Release_Date, '') = IsNull(t2.Holdback_Release_Date, '') 
							  AND IsNull(t1.Holdback_On_Platform_Code, 0) = IsNull(t2.Holdback_On_Platform_Code, 0) 
						FOR XML PATH('')
					), 1, 1, ''
				)
		FROM (
			SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, Start_Date, End_Date, 
				   Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code, 
				   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code
			FROM #TempMainHB 
		) AS t2

		DROP TABLE #TempMainHB
	END
	
	print 'STEP-9 REVERSE HOLDBACK --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
	BEGIN

		INSERT INTO #TempRHB(Title_Code, strRHB)
		SELECT DISTINCT Title_Code , ''
		FROM #AvailTitleData
		WHERE Title_Code IN (
			SELECT DISTINCT sdrt.Title_Code FROM Syn_Deal_Rights sdr
			INNER JOIN Syn_Deal_Rights_Title sdrt ON sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
			WHERE sdr.Is_Pushback = 'Y'
		)

		UPDATE #TempRHB SET strRHB = [dbo].[UFNGETSYNRHB](Title_Code)

	END
	--SELECT * FROM #TempRegions
	PRINT 'STEP-10 SET / POPULATE COUNTRY / TERRITORY NAMES --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN
	
		INSERT INTO #TempRegions(RegionCodes)
		SELECT DISTINCT CountryCode FROM #DBAvailCountry
		UNION
		SELECT DISTINCT Country_Cd_Str FROM #TempMain WHERE Country_Cd_Str IS NOT NULL

		PRINT 'STEP-10.1 GET DISTINCT COUNTRY_CD_STR  --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)

		UPDATE tr SET tr.ClusterNames = a.Cluster_Name, tr.RegionName = a.Region_Name
		FROM 
		(
			SELECT c.Region_Code, c.Cluster_Name, c.Region_Name, tc.RowId
			FROM #TempRegions tc
			CROSS APPLY DBO.UFN_Get_Report_Territory(tc.RegionCodes, tc.RowId) c
		) AS a
		INNER JOIN #TempRegions tr ON tr.RowId = a.RowId
	
		PRINT 'STEP-10.2 CALL FUNCTION AND UPDATE CLUSTER --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)

		UPDATE dac SET dac.ClusterNames = tr.ClusterNames, dac.RegionName = tr.RegionName
		FROM #DBAvailCountry dac
		INNER JOIN #TempRegions tr ON dac.CountryCode = tr.RegionCodes
	
		PRINT 'STEP-10.3 UPDATE #DBAvailCountry --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)

		UPDATE dac SET dac.ClusterNames = tr.ClusterNames, dac.RegionName = tr.RegionName
		FROM #TempMain dac
		INNER JOIN #TempRegions tr ON dac.Country_Cd_Str = tr.RegionCodes
		WHERE dac.Country_Cd_Str IS NOT NULL
		
		PRINT 'STEP-10.4 UPDATE #TempMain --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)

		UPDATE dac SET dac.ClusterNames = tr.ClusterNames, dac.RegionName = tr.RegionName
		FROM #TempMain dac
		INNER JOIN #DBAvailCountry tr ON dac.Avail_Country_Code = tr.Avail_Country_Code

	END

	PRINT 'STEP-11 REPORTING OUTPUT ON L1 --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		IF(@L1Output = 'Y')
		BEGIN
			
			--SELECT COUNT(*) FROM #TempMain

			INSERT INTO #TempMainL1(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, Avail_Country_Code, Start_Date, End_Date, Is_Title_Language, Avail_Subtitling_Code, 
									Avail_Dubbing_Code, Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, Country_Cd_Str, ClusterNames, RegionName, 
									Base_Platform_Code, Actual_Platform_Count, Avail_Platform_Count)
			SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, tm.Platform_Code, Avail_Country_Code, Start_Date, End_Date, Is_Title_Language, Avail_Subtitling_Code, 
				   Avail_Dubbing_Code, Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, Country_Cd_Str, ClusterNames, RegionName,
				   CASE WHEN ISNULL(pt.Base_Platform_Code, 0) = 0 THEN pt.Platform_Code ELSE pt.Base_Platform_Code END, 0, 0
			FROM #TempMain tm
			INNER JOIN Platform pt oN tm.Platform_Code = pt.Platform_Code
			
			DELETE FROM #TempMain
			
			UPDATE ctr SET ctr.Actual_Platform_Count = pl.CNT
			FROM #TempMainL1 ctr
			INNER JOIN (
				SELECT SUM(CNT) CNT, Platform_Code FROM(
					SELECT 1 CNT, CASE WHEN Base_Platform_Code = 0 THEN Platform_Code ELSE Base_Platform_Code END Platform_Code
					FROM Platform WHERE Is_Last_Level = 'Y'
				) AS a GROUP BY Platform_Code
			) as pl ON ctr.Base_Platform_Code = pl.Platform_Code
			
			UPDATE ctr SET ctr.Avail_Platform_Count = avail.AvailCnt
			FROM #TempMainL1 ctr
			INNER JOIN (
				SELECT Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Avail_Country_Code, Start_Date, End_Date, Is_Title_Language, Avail_Subtitling_Code, 
					   Avail_Dubbing_Code, Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, Country_Cd_Str, ClusterNames, RegionName, 
					   Base_Platform_Code, Actual_Platform_Count, COUNT(*) AvailCnt
				FROM #TempMainL1
				GROUP BY Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Avail_Country_Code, Start_Date, End_Date, Is_Title_Language, Avail_Subtitling_Code, 
						 Avail_Dubbing_Code, Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, Country_Cd_Str, ClusterNames, RegionName, 
					     Base_Platform_Code, Actual_Platform_Count
			) AS avail ON ISNULL(ctr.Acq_Deal_Rights_Code, 0) = ISNULL(avail.Acq_Deal_Rights_Code, 0) AND 
			ISNULL(ctr.Title_Code, 0) = ISNULL(avail.Title_Code, 0) AND 
			ISNULL(ctr.Episode_From, 0) = ISNULL(avail.Episode_From, 0) AND 
			ISNULL(ctr.Episode_To, 0) = ISNULL(avail.Episode_To, 0) AND 
			ISNULL(ctr.Is_Exclusive, '') = ISNULL(avail.Is_Exclusive, '') AND 
			ISNULL(ctr.Avail_Country_Code, 0) = ISNULL(avail.Avail_Country_Code, 0) AND 
			ctr.Start_Date = avail.Start_Date AND 
			ISNULL(ctr.End_Date, '31DEC9999') = ISNULL(avail.End_Date, '31DEC9999') AND 
			ISNULL(ctr.Is_Title_Language, '') = ISNULL(avail.Is_Title_Language, '') AND 
			ISNULL(ctr.Avail_Subtitling_Code, 0) = ISNULL(avail.Avail_Subtitling_Code, 0) AND 
			ISNULL(ctr.Avail_Dubbing_Code, 0) = ISNULL(avail.Avail_Dubbing_Code, 0) AND 
			ISNULL(ctr.Acq_Deal_Rights_Holdback_Code, 0) = ISNULL(avail.Acq_Deal_Rights_Holdback_Code, 0) AND 
			ISNULL(ctr.Holdback_Type, '') = ISNULL(avail.Holdback_Type, '') AND 
			ISNULL(ctr.Holdback_Release_Date, '') = ISNULL(avail.Holdback_Release_Date, '') AND 
			ISNULL(ctr.Holdback_On_Platform_Code, 0) = ISNULL(avail.Holdback_On_Platform_Code, 0) AND 
			ISNULL(ctr.Country_Cd_Str, '') = ISNULL(avail.Country_Cd_Str, '') AND 
			ISNULL(ctr.ClusterNames, '') = ISNULL(avail.ClusterNames, '') AND 
			ISNULL(ctr.RegionName, '') = ISNULL(avail.RegionName, '') AND 
			ISNULL(ctr.Base_Platform_Code, 0) = ISNULL(avail.Base_Platform_Code, 0) AND 
			ISNULL(ctr.Actual_Platform_Count, 0) = ISNULL(avail.Actual_Platform_Count, 0) 

			INSERT INTO #TempMain(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Avail_Country_Code, Start_Date, End_Date, Is_Title_Language, Avail_Subtitling_Code, 
								  Avail_Dubbing_Code, Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, Country_Cd_Str, ClusterNames, RegionName,
								  Platform_Code, Available)
			SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Avail_Country_Code, Start_Date, End_Date, Is_Title_Language, Avail_Subtitling_Code, 
				   Avail_Dubbing_Code, Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code, Country_Cd_Str, ClusterNames, RegionName,
				   Base_Platform_Code, CASE WHEN Actual_Platform_Count = Avail_Platform_Count THEN 'Yes' Else 'Partial' END AS Available
			FROM #TempMainL1

			DROP TABLE #TempMainL1
			--SELECT COUNT(*) FROM #TempMain
		END
	END

	PRINT 'STEP-12 WORKING FOR FIRST ROW --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		DECLARE @tblPlatformCodes AS TABLE
		(
			Platform_Code INT
		)

		INSERT INTO @tblPlatformCodes(Platform_Code)
		SELECT DISTINCT Platform_Code FROM #TempMain

		DECLARE @PlatformStr NVARCHAR(MAX) = '', @Cols VARCHAR(MAX) = '', @FirstRow NVARCHAR(MAX) = ''
		SELECT @PlatformStr = STUFF
		(
			(
				SELECT ', ''[' + Platform_Hiearachy +']''' FROM (
					SELECT Platform_Code FROM @tblPlatformCodes
				) AS tm
				INNER JOIN Platform pt ON tm.Platform_Code = pt.Platform_Code
				ORDER BY Module_Position ASC
				FOR XML PATH('')
			), 1, 1, ''
		)

		SELECT @Cols = STUFF
		(
			(
				SELECT ', PL_' + CAST(ROW_NUMBER() OVER(ORDER BY Platform_Code) AS VARCHAR(10))
				FROM (
					SELECT Platform_Code FROM @tblPlatformCodes
				) AS tm
				FOR XML PATH('')
			), 1, 1, ''
		)

		SELECT @FirstRow = 'INSERT INTO #TempOutput(OutputOrder, TitleType, Title, EpisodeFrom, EpisodeTo, ClusterNames, RegionName, StartDate, EndDate, TitleLanguage, SubTiltling, Dubbing, Genre, StarCast, Director, Duration, ReleaseYear, RestrictionRemarks, SubDealRestrictionRemarks, Remarks, RightsRemarks, Exclusive, SubLicense, HoldbackOn, HoldbackType, HoldbackReleaseDate, ReverseHoldback, ROFR, SelfUtilizationGroup, SelfUtilizationRemarks, ' + @Cols + ')' +
		'SELECT 0, ''Title Type'', ''Title Name'', ''Episode From'', ''Episode To'', ''Cluster Name'', ''Region Name'', ''Start Date'', ''End Date'', ''Title Language Name'', ''Subtitling Language'', ''Dubbing Language'', ''Genre Name'', ''Star Cast'', ''Director'', ''Duration(in min)'', ''Production Year'', ''Restriction Remark'', ''Sub Deal Restriction Remark'', ''Deal Remarks'', ''Rights Remarks'', ''Exclusive'', ''Sub License'', ''Holdback On'', ''Holdback Type'', ''Holdback Release Date'', ''Reverse Holdback'', ''ROFR'', ''Self-Utilization Group'', ''Self-Utilization Remarks'', ' + @PlatformStr

		EXEC(@FirstRow)

		SET @PlatformStr = REPLACE(@PlatformStr, '''', '')

	END

	PRINT 'STEP-13 FINAL OUTPUT --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		SET @FirstRow = ''
		SELECT @FirstRow = 'INSERT INTO #TempOutput(OutputOrder, TitleType, Title, EpisodeFrom, EpisodeTo, ClusterNames, RegionName, StartDate, EndDate, ' +
													'TitleLanguage, SubTiltling, Dubbing, Genre, StarCast, Director, ' +
													'Duration, ReleaseYear, RestrictionRemarks, SubDealRestrictionRemarks, Remarks, RightsRemarks, Exclusive, SubLicense, ' +
													'HoldbackOn, HoldbackType, HoldbackReleaseDate, ReverseHoldback, ' + @Cols + ') ' +
			'SELECT 1, Title_Type, Title_Name, Episode_From, Episode_To, ClusterNames, RegionName, REPLACE(CONVERT(VARCHAR(50), Right_Start_Date, 106), '' '', ''-''), REPLACE(CONVERT(VARCHAR(50), Rights_End_Date, 106), '' '', ''-''), ' + 
				   'Title_Language_Names, Sub_Language_Names, Dub_Language_Names, Genres_Name, Star_Cast, Director, ' +
				   'Duration_In_Min, Year_Of_Production, Restriction_Remark, Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, Sub_License, ' +
				   'HoldbackOn, Holdback_Type, Holdback_Release_Date, Reverse_Holdback, ' + @PlatformStr + ' FROM ( ' +
			'SELECT tti.Title_Type, tti.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name, tm.Episode_From, tm.Episode_To, pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name, Available AS Platform_Avail, ' +
				   'tm.ClusterNames, tm.RegionName, ' +
				   'CAST( ' +
			   			'CASE WHEN ISNULL(tm.Holdback_Release_Date,'''') = '''' OR tm.Start_Date > tm.Holdback_Release_Date ' +
			   			'THEN tm.Start_Date ' +
			   			'ELSE DATEADD(D, 1, tm.Holdback_Release_Date) ' +
			   			'END AS DATE ' +
				   ') AS Right_Start_Date, CAST(ISNULL(tm.End_Date, ''31Dec9999'') AS DATETIME) Rights_End_Date, ' +
				   'CASE WHEN tm.Is_Title_Language = 1 THEN tti.Language_Name ELSE '''' END COLLATE SQL_Latin1_General_CP1_CI_AS Title_Language_Names, ' +
				   'sub.LanguageNames AS Sub_Language_Names, dub.LanguageNames AS Dub_Language_Names, ' +
				   'tti.Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS Genres_Name, tti.Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS Star_Cast, ' +
				   'tti.Director COLLATE SQL_Latin1_General_CP1_CI_AS Director, tti.Duration_In_Min, tti.Year_Of_Production, ' +
				   'trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark, ' +
				   'trr.Remarks, trr.Rights_Remarks, CASE WHEN tm.Is_Exclusive = 1 THEN ''Exclusive'' ELSE ''Non Exclusive'' END AS Exclusive, ' +
				   'trr.Sub_License_Name AS Sub_License, ' +
				   'CASE WHEN ISNULL(pt1.Platform_Hiearachy, '''') = '''' OR tm.Start_Date > tm.Holdback_Release_Date THEN '''' ELSE hb.HBComments + pt1.Platform_Hiearachy END COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn, ' +
				   'tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, ' +
				   'CASE WHEN ISNULL(tm.Holdback_Release_Date, '''') = '''' OR tm.Start_Date > tm.Holdback_Release_Date THEN '''' ELSE CONVERT(VARCHAR(20),tm.Holdback_Release_Date, 103) END ' +
				   'COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date, rhb.strRHB COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback ' +
			'FROM #TempMain tm ' +
			'INNER JOIN #TempTitlesInfo tti ON tm.Title_Code = tti.Title_Code ' +
			'INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code ' +
			'INNER JOIN #TempRightRemarks trr ON tm.Acq_Deal_Rights_Code = trr.Acq_Deal_Rights_Code ' +
			'LEFT JOIN #DBAvailLanguages sub ON tm.Avail_Subtitling_Code = sub.Avail_Languages_Code ' +
			'LEFT JOIN #DBAvailLanguages dub ON tm.Avail_Subtitling_Code = dub.Avail_Languages_Code ' +
			'LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code ' +
			'LEFT JOIN #MainHBDetails hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code ' +
			'LEFT JOIN #TempRHB rhb ON tm.Title_Code = rhb.Title_Code ' +
		') AS main ' +
		'PIVOT( ' +
			'MAX(Platform_Avail) ' +
			'FOR Platform_Name IN (' + @PlatformStr + ') ' +
		') AS Tab2 ' +
		'ORDER BY Title_Name '

		EXEC(@FirstRow)

	END	

	SELECT * FROM #TempOutput

	BEGIN ------------------ CLEAR TEMP TABLE SECTION

		IF OBJECT_ID('tempdb..#SearchTitle') IS NOT NULL DROP TABLE #SearchTitle
		IF OBJECT_ID('tempdb..#SearchPlatform') IS NOT NULL DROP TABLE #SearchPlatform
		IF OBJECT_ID('tempdb..#SearchPlatformMH') IS NOT NULL DROP TABLE #SearchPlatformMH
		IF OBJECT_ID('tempdb..#SearchCountry') IS NOT NULL DROP TABLE #SearchCountry
		IF OBJECT_ID('tempdb..#SearchCountryMH') IS NOT NULL DROP TABLE #SearchCountryMH
		IF OBJECT_ID('tempdb..#SearchTitleLanguage') IS NOT NULL DROP TABLE #SearchTitleLanguage
		IF OBJECT_ID('tempdb..#SearchSubtitling') IS NOT NULL DROP TABLE #SearchSubtitling
		IF OBJECT_ID('tempdb..#SearchDubbing') IS NOT NULL DROP TABLE #SearchDubbing
		IF OBJECT_ID('tempdb..#SearchSubtitlingMH') IS NOT NULL DROP TABLE #SearchSubtitlingMH
		IF OBJECT_ID('tempdb..#SearchDubbingMH') IS NOT NULL DROP TABLE #SearchDubbingMH
		IF OBJECT_ID('tempdb..#SearchSubLicense') IS NOT NULL DROP TABLE #SearchSubLicense
		IF OBJECT_ID('tempdb..#DBAvailDates') IS NOT NULL DROP TABLE #DBAvailDates
		IF OBJECT_ID('tempdb..#DBAvailPlatform') IS NOT NULL DROP TABLE #DBAvailPlatform
		IF OBJECT_ID('tempdb..#DBAvailCountry') IS NOT NULL DROP TABLE #DBAvailCountry
		IF OBJECT_ID('tempdb..#DBAvailLanguages') IS NOT NULL DROP TABLE #DBAvailLanguages
		IF OBJECT_ID('tempdb..#AvailTitleData') IS NOT NULL DROP TABLE #AvailTitleData
		IF OBJECT_ID('tempdb..#TempMain') IS NOT NULL DROP TABLE #TempMain
		IF OBJECT_ID('tempdb..#TempMainL1') IS NOT NULL DROP TABLE #TempMainL1
		IF OBJECT_ID('tempdb..#TempPlatformData') IS NOT NULL DROP TABLE #TempPlatformData
		IF OBJECT_ID('tempdb..#TempLanguageNames') IS NOT NULL DROP TABLE #TempLanguageNames
		IF OBJECT_ID('tempdb..#TempRegions') IS NOT NULL DROP TABLE #TempRegions
		IF OBJECT_ID('tempdb..#TempRightRemarks') IS NOT NULL DROP TABLE #TempRightRemarks
		IF OBJECT_ID('tempdb..#TempTitlesInfo') IS NOT NULL DROP TABLE #TempTitlesInfo
		IF OBJECT_ID('tempdb..#TempMainHB') IS NOT NULL DROP TABLE #TempMainHB
		IF OBJECT_ID('tempdb..#MainHBTitles') IS NOT NULL DROP TABLE #MainHBTitles
		IF OBJECT_ID('tempdb..#MainHBDetails') IS NOT NULL DROP TABLE #MainHBDetails
		IF OBJECT_ID('tempdb..#MainReleaseCountry') IS NOT NULL DROP TABLE #MainReleaseCountry
		IF OBJECT_ID('tempdb..#TempRHB') IS NOT NULL DROP TABLE #TempRHB
		IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput

	END

END

/*

	EXEC [dbo].[USPAvailability]
	@TitleCodes = '0', 
	
	@DateType = 'FL',
	@StartDate = '',
	@EndDate = '',
	
	@PlatformCodes = '0',
	@ExactMatchPlatforms = NULL,
	@MustHavePlatforms = NULL,

	@IsIFTACluster = 'N',
	@TerritoryCodes = '0', 
    @CountryCodes = '0', 
	@ExactMatchCountry = NULL,
	@MustHaveCountry = NULL,
	@ExclusionCountry = NULL,
	
	@IsTitleLanguage = 'Y',
	@TitleLanguageCode = '',

	@DubbingSubtitling = '',
	@SubtitlingGroupCodes = '0',
	@SubtitlingCodes = '0',
	@ExactMatchSubtitling = NULL,
	@MustHaveSubtitling = NULL,
	@ExclusionSubtitling = NULL,
	
	@DubbingGroupCodes = '0',
	@DubbingCodes = '0',
	@ExactMatchDubbing = NULL,
	@MustHaveDubbing = NULL,
	@ExclusionDubbing = NULL,
	 
	@Exclusivity = 'B',   --B-Both, E-Exclusive,N-NonExclusive 
	@SubLicenseCode = NULL, --Comma   Separated SubLicensing Code. 0-No Sub Licensing,	
	@RestrictionRemarks = 'N',
	@OthersRemarks = 'N',
	@BUCode = '0',
	@IsDigital = 'N',
	@L1Output = 'Y'

*/
