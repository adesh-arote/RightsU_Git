CREATE PROCEDURE [dbo].[USPAvailability]
(
	@TitleCodes VARCHAR(MAX) = '0', 
	@EpisodeFrom INT,
	@EpisodeTo INT,
	
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
	
	@IsTitleLanguage BIT = 1,
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
	@RestrictionRemarks VARCHAR(10) = 'TRUE',
	@OthersRemarks VARCHAR(10) = 'TRUE',
	@BUCode VARCHAR(20) = '0',
	@IsDigital BIT = 'FALSE',
	@L1Output CHAR(1) = 'N',
	@ReportType CHAR(1) = 'M'
)
AS
BEGIN

	SET NOCOUNT ON;
	SET FMTONLY OFF;

	--SELECT @TitleCodes='564', @EpisodeFrom='0', @EpisodeTo='0', @DateType='FL', @StartDate='2023-12-21', @EndDate='', @PlatformCodes='0,0,19,20,0,0,83,85,0,87,89,0,0,90,91,92,0,217,219,221,223,224,225,226,94,0,0,95,96,97,98,99,100,101,102,103,0,0,227,228,229,230,231,232,105,106,107,109,0,0,110,111,112,113,114,115,116,117,118,119,0,0,233,234,235,236,237,238,121,122,0,0,123,0,239,240,241,242,125,0,243,244,245,246,247,248,249,0,0,250,251,252,253,254,255,128,0,0,129,130,0,256,257,132,0,133,134,0,258,259,136,0,0,137,138,139,140,141,0,142,143,144,145,146,0,0,147,148,149,150,151,0,152,153,154,155,156,0,36,37,38,39,40,41,42,43,44,45,46,0,157,158,0,48,49,50,51,52,53,54,0,159,160,161,162,0,0,163,164,0,165,166,0,167,168,59,60,61,0,169,170,171,63,64,65,66,0,0,172,0,260,261,174,175,0,262,263,264,265,177,0,0,266,267,268,269,270,271,179,0,272,273,274,181,182,183,0,275,276,277,278,185,0,0,186,187,188,189,0,279,280,191,192,0,0,281,282,283,284,285,286,194,0,0,0,287,288,196,0,0,0,289,290,291,0,292,293,294,0,199,0,200,0,295,296,297,298,299,300,301,0,202,0,302,303,304,305,306,307,308,309,310,0,204,205,0,206,0,311,312,313,314,315,316,317,0,208,0,318,319,320,321,322,323,324,0,210,0,325,326,327,328,329,330,331,80,0,0,0,332,333,213,214,215,0,0,334,335,218,220,222,0,84,86,88', @ExactMatchPlatforms='', @MustHavePlatforms='0', @IsIFTACluster='Y', @TerritoryCodes='0', @CountryCodes='0,45,258,143,259,260,219,144,261,146,10,147,64,5,220,221,49,72,148,218,26,150,222,262,68,151,152,216,76,153,70,263,223,224,155,225,61,156,253,157,158,17,264,265,159,160,266,161,22,162,163,33,23,257,25,164,165,166,74,167,168,169,267,226,227,268,170,269,270,271,59,40,6,228,272,273,229,230,274,4,171,275,32,276,172,173,277,174,231,232,175,53,278,176,57,31,279,42,18,56,19,62,11,29,233,177,13,178,9,179,280,281,69,180,282,182,283,235,183,284,285,236,237,286,287,2,184,238,239,288,240,241,20,289,185,326,290,186,217,187,21,291,60,188,292,54,3,293,294,65,189,243,190,295,191,296,297,35,50,55,298,77,299,192,181,193,300,301,36,30,302,51,256,303,242,304,7,8,194,305,199,201,306,307,247,52,308,248,37,195,249,47,24,309,310,196,46,197,311,28,27,198,200,202,250,251,312,39,203,204,14,205,41,254,255,252,313,314,315,207,208,34,209,210,316,211,12,48,43,212,213,317,325,214,73,154,318,319,320,321,215,322,323', @ExactMatchCountry='', @MustHaveCountry='', @ExclusionCountry='', @IsTitleLanguage='1', @TitleLanguageCode='0', @DubbingSubtitling='S,D', @SubtitlingGroupCodes='G1', @SubtitlingCodes='0,77,117,78,2,1159,10,55,1167,65,79,17,80,76,42,1136,56,1133,1146,48,1163,1165,73,118,70,68,81,82,1130,1184,1162,128,83,19,20,22,126,127,84,63,1168,4,119,37,1141,1181,1126,35,6,85,86,120,5,28,41,1134,87,88,66,1169,89,11,90,43,1170,1,1132,1137,91,27,92,93,1144,1152,1151,1150,25,13,67,94,51,1139,62,1171,9,59,95,96,97,61,1172,15,72,121,1182,1183,1149,122,98,1164,1166,99,46,3,1140,123,45,58,1173,38,1142,57,100,101,102,124,74,103,49,1174,1147,30,54,1127,1175,1161,104,1180,69,18,1148,31,26,47,1143,105,1131,1185,7,8,1145,1176,64,1128,1177,106,32,1153,1154,1156,107,50,60,1178,23,1160,1158,21,75,24,108,33,34,109,110,14,125,39,1138,40,1135,36,1129,1157,1187,29,12,53,1179,111,71,52,1186,112,113,114,1155,115,116', @ExactMatchSubtitling='          ', @MustHaveSubtitling='0', @ExclusionSubtitling='', @DubbingGroupCodes='G1', @DubbingCodes='0,77,117,78,2,1159,10,55,1167,65,79,17,80,76,42,1136,56,1133,1146,48,1163,1165,73,118,70,68,81,82,1130,1184,1162,128,83,19,20,22,126,127,84,63,1168,4,119,37,1141,1181,1126,35,6,85,86,120,5,28,41,1134,87,88,66,1169,89,11,90,43,1170,1,1132,1137,91,27,92,93,1144,1152,1151,1150,25,13,67,94,51,1139,62,1171,9,59,95,96,97,61,1172,15,72,121,1182,1183,1149,122,98,1164,1166,99,46,3,1140,123,45,58,1173,38,1142,57,100,101,102,124,74,103,49,1174,1147,30,54,1127,1175,1161,104,1180,69,18,1148,31,26,47,1143,105,1131,1185,7,8,1145,1176,64,1128,1177,106,32,1153,1154,1156,107,50,60,1178,23,1160,1158,21,75,24,108,33,34,109,110,14,125,39,1138,40,1135,36,1129,1157,1187,29,12,53,1179,111,71,52,1186,112,113,114,1155,115,116', @ExactMatchDubbing='          ', @MustHaveDubbing='0', @ExclusionDubbing='', @Exclusivity='B', @SubLicenseCode='', @RestrictionRemarks='True', @OthersRemarks='True', @BUCode='0', @IsDigital='0', @L1Output='N', @ReportType='M'

	INSERT INTO TestParam(Params, ProcType)
	SELECT '@TitleCodes=''' + CAST(@TitleCodes AS VARCHAR(MAX)) +
	''', @EpisodeFrom=''' + CAST(ISNULL(@EpisodeFrom, '') AS VARCHAR(MAX)) +
	''', @EpisodeTo=''' + CAST(ISNULL(@EpisodeTo, '') AS VARCHAR(MAX)) +
	
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
	''', @L1Output=''' + CAST(ISNULL(@L1Output, '') AS VARCHAR(MAX)) +
	''', @ReportType=''' + CAST(ISNULL(@ReportType, '') AS VARCHAR(MAX)) + '''', 'MAvail'

	SET @TerritoryCodes = REPLACE(@TerritoryCodes, 'T', '')
	SET @SubtitlingGroupCodes = REPLACE(@SubtitlingGroupCodes, 'G', '')
	SET @DubbingGroupCodes = REPLACE(@DubbingGroupCodes, 'G', '')
	
	IF(UPPER(@RestrictionRemarks) = 'TRUE')
		SET @RestrictionRemarks = 'Y'
	ELSE
		SET @RestrictionRemarks = 'N'

	IF(UPPER(@OthersRemarks) = 'TRUE')
		SET @OthersRemarks = 'Y'
	ELSE
		SET @OthersRemarks = 'N'
		
	IF(@CountryCodes LIKE '%T%')
		SET @CountryCodes = ''

	IF(@SubtitlingCodes LIKE '%G%')
		SET @SubtitlingCodes = ''

	IF(@DubbingCodes LIKE '%G%')
		SET @DubbingCodes = ''

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
			Is_Exclusive INT,
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
			Is_Exclusive INT,
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
			RegionName NVARCHAR(MAX),
			Objection_Platform NVARCHAR(MAX) default ' ~ ',
			Objection_Region NVARCHAR(MAX),
			Objection_Start_Date DATETIME,
			Objection_End_Date DATETIME,
			Under_Litigation  NVARCHAR(MAX) DEFAULT 'No'
		)
	
		CREATE TABLE #TempMainL1(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT, 
			Episode_From INT,
			Episode_To INT,
			Is_Exclusive INT,
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
			Sub_License_Name VARCHAR(100),
			CoExclusive_Remark VARCHAR(8000)
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
			Year_Of_Production VARCHAR(10),
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
			Is_Exclusive INT,
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
			ObjectionPlatform NVARCHAR(MAX) default ' ~ ',
			ObjectionRegion NVARCHAR(MAX),
			ObjectionStartDate NVARCHAR(MAX),
			ObjectionEndDate NVARCHAR(MAX),
			UnderLitigation  NVARCHAR(MAX) DEFAULT 'No',
			CoExclusive_Remark VARCHAR(8000),
			PL_1 NVARCHAR(1000),
			PL_2 NVARCHAR(1000),
			PL_3 NVARCHAR(1000),
			PL_4 NVARCHAR(1000),
			PL_5 NVARCHAR(1000),
			PL_6 NVARCHAR(1000),
			PL_7 NVARCHAR(1000),
			PL_8 NVARCHAR(1000),
			PL_9 NVARCHAR(1000),
			PL_10 NVARCHAR(1000),
			PL_11 NVARCHAR(1000),
			PL_12 NVARCHAR(1000),
			PL_13 NVARCHAR(1000),
			PL_14 NVARCHAR(1000),
			PL_15 NVARCHAR(1000),
			PL_16 NVARCHAR(1000),
			PL_17 NVARCHAR(1000),
			PL_18 NVARCHAR(1000),
			PL_19 NVARCHAR(1000),
			PL_20 NVARCHAR(1000),
			PL_21 NVARCHAR(1000),
			PL_22 NVARCHAR(1000),
			PL_23 NVARCHAR(1000),
			PL_24 NVARCHAR(1000),
			PL_25 NVARCHAR(1000),
			PL_26 NVARCHAR(1000),
			PL_27 NVARCHAR(1000),
			PL_28 NVARCHAR(1000),
			PL_29 NVARCHAR(1000),
			PL_30 NVARCHAR(1000),
			PL_31 NVARCHAR(1000),
			PL_32 NVARCHAR(1000),
			PL_33 NVARCHAR(1000),
			PL_34 NVARCHAR(1000),
			PL_35 NVARCHAR(1000),
			PL_36 NVARCHAR(1000),
			PL_37 NVARCHAR(1000),
			PL_38 NVARCHAR(1000),
			PL_39 NVARCHAR(1000),
			PL_40 NVARCHAR(1000),
			PL_41 NVARCHAR(1000),
			PL_42 NVARCHAR(1000),
			PL_43 NVARCHAR(1000),
			PL_44 NVARCHAR(1000),
			PL_45 NVARCHAR(1000),
			PL_46 NVARCHAR(1000),
			PL_47 NVARCHAR(1000),
			PL_48 NVARCHAR(1000),
			PL_49 NVARCHAR(1000),
			PL_50 NVARCHAR(1000),
			PL_51 NVARCHAR(1000),
			PL_52 NVARCHAR(1000),
			PL_53 NVARCHAR(1000),
			PL_54 NVARCHAR(1000),
			PL_55 NVARCHAR(1000),
			PL_56 NVARCHAR(1000),
			PL_57 NVARCHAR(1000),
			PL_58 NVARCHAR(1000),
			PL_59 NVARCHAR(1000),
			PL_60 NVARCHAR(1000),
			PL_61 NVARCHAR(1000),
			PL_62 NVARCHAR(1000),
			PL_63 NVARCHAR(1000),
			PL_64 NVARCHAR(1000),
			PL_65 NVARCHAR(1000),
			PL_66 NVARCHAR(1000),
			PL_67 NVARCHAR(1000),
			PL_68 NVARCHAR(1000),
			PL_69 NVARCHAR(1000),
			PL_70 NVARCHAR(1000),
			PL_71 NVARCHAR(1000),
			PL_72 NVARCHAR(1000),
			PL_73 NVARCHAR(1000),
			PL_74 NVARCHAR(1000),
			PL_75 NVARCHAR(1000),
			PL_76 NVARCHAR(1000),
			PL_77 NVARCHAR(1000),
			PL_78 NVARCHAR(1000),
			PL_79 NVARCHAR(1000),
			PL_80 NVARCHAR(1000),
			PL_81 NVARCHAR(1000),
			PL_82 NVARCHAR(1000),
			PL_83 NVARCHAR(1000),
			PL_84 NVARCHAR(1000),
			PL_85 NVARCHAR(1000),
			PL_86 NVARCHAR(1000),
			PL_87 NVARCHAR(1000),
			PL_88 NVARCHAR(1000),
			PL_89 NVARCHAR(1000),
			PL_90 NVARCHAR(1000),
			PL_91 NVARCHAR(1000),
			PL_92 NVARCHAR(1000),
			PL_93 NVARCHAR(1000),
			PL_94 NVARCHAR(1000),
			PL_95 NVARCHAR(1000),
			PL_96 NVARCHAR(1000),
			PL_97 NVARCHAR(1000),
			PL_98 NVARCHAR(1000),
			PL_99 NVARCHAR(1000),
			PL_100 NVARCHAR(1000),
			PL_101 NVARCHAR(1000),
			PL_102 NVARCHAR(1000),
			PL_103 NVARCHAR(1000),
			PL_104 NVARCHAR(1000),
			PL_105 NVARCHAR(1000),
			PL_106 NVARCHAR(1000),
			PL_107 NVARCHAR(1000),
			PL_108 NVARCHAR(1000),
			PL_109 NVARCHAR(1000),
			PL_110 NVARCHAR(1000),
			PL_111 NVARCHAR(1000),
			PL_112 NVARCHAR(1000),
			PL_113 NVARCHAR(1000),
			PL_114 NVARCHAR(1000),
			PL_115 NVARCHAR(1000),
			PL_116 NVARCHAR(1000),
			PL_117 NVARCHAR(1000),
			PL_118 NVARCHAR(1000),
			PL_119 NVARCHAR(1000),
			PL_120 NVARCHAR(1000),
			PL_121 NVARCHAR(1000),
			PL_122 NVARCHAR(1000),
			PL_123 NVARCHAR(1000),
			PL_124 NVARCHAR(1000),
			PL_125 NVARCHAR(1000),
			PL_126 NVARCHAR(1000),
			PL_127 NVARCHAR(1000),
			PL_128 NVARCHAR(1000),
			PL_129 NVARCHAR(1000),
			PL_130 NVARCHAR(1000),
			PL_131 NVARCHAR(1000),
			PL_132 NVARCHAR(1000),
			PL_133 NVARCHAR(1000),
			PL_134 NVARCHAR(1000),
			PL_135 NVARCHAR(1000),
			PL_136 NVARCHAR(1000),
			PL_137 NVARCHAR(1000),
			PL_138 NVARCHAR(1000),
			PL_139 NVARCHAR(1000),
			PL_140 NVARCHAR(1000),
			PL_141 NVARCHAR(1000),
			PL_142 NVARCHAR(1000),
			PL_143 NVARCHAR(1000),
			PL_144 NVARCHAR(1000),
			PL_145 NVARCHAR(1000),
			PL_146 NVARCHAR(1000),
			PL_147 NVARCHAR(1000),
			PL_148 NVARCHAR(1000),
			PL_149 NVARCHAR(1000),
			PL_150 NVARCHAR(1000),
			PL_151 NVARCHAR(1000),
			PL_152 NVARCHAR(1000),
			PL_153 NVARCHAR(1000),
			PL_154 NVARCHAR(1000),
			PL_155 NVARCHAR(1000),
			PL_156 NVARCHAR(1000),
			PL_157 NVARCHAR(1000),
			PL_158 NVARCHAR(1000),
			PL_159 NVARCHAR(1000),
			PL_160 NVARCHAR(1000),
			PL_161 NVARCHAR(1000),
			PL_162 NVARCHAR(1000),
			PL_163 NVARCHAR(1000),
			PL_164 NVARCHAR(1000),
			PL_165 NVARCHAR(1000),
			PL_166 NVARCHAR(1000),
			PL_167 NVARCHAR(1000),
			PL_168 NVARCHAR(1000),
			PL_169 NVARCHAR(1000),
			PL_170 NVARCHAR(1000),
			PL_171 NVARCHAR(1000),
			PL_172 NVARCHAR(1000),
			PL_173 NVARCHAR(1000),
			PL_174 NVARCHAR(1000),
			PL_175 NVARCHAR(1000),
			PL_176 NVARCHAR(1000),
			PL_177 NVARCHAR(1000),
			PL_178 NVARCHAR(1000),
			PL_179 NVARCHAR(1000),
			PL_180 NVARCHAR(1000),
			PL_181 NVARCHAR(1000),
			PL_182 NVARCHAR(1000),
			PL_183 NVARCHAR(1000),
			PL_184 NVARCHAR(1000),
			PL_185 NVARCHAR(1000),
			PL_186 NVARCHAR(1000),
			PL_187 NVARCHAR(1000),
			PL_188 NVARCHAR(1000),
			PL_189 NVARCHAR(1000),
			PL_190 NVARCHAR(1000),
			PL_191 NVARCHAR(1000),
			PL_192 NVARCHAR(1000),
			PL_193 NVARCHAR(1000),
			PL_194 NVARCHAR(1000),
			PL_195 NVARCHAR(1000),
			PL_196 NVARCHAR(1000),
			PL_197 NVARCHAR(1000),
			PL_198 NVARCHAR(1000),
			PL_199 NVARCHAR(1000),
			PL_200 NVARCHAR(1000),
			PL_201 NVARCHAR(1000),
			PL_202 NVARCHAR(1000),
			PL_203 NVARCHAR(1000),
			PL_204 NVARCHAR(1000),
			PL_205 NVARCHAR(1000),
			PL_206 NVARCHAR(1000),
			PL_207 NVARCHAR(1000),
			PL_208 NVARCHAR(1000),
			PL_209 NVARCHAR(1000),
			PL_210 NVARCHAR(1000),
			PL_211 NVARCHAR(1000),
			PL_212 NVARCHAR(1000),
			PL_213 NVARCHAR(1000),
			PL_214 NVARCHAR(1000),
			PL_215 NVARCHAR(1000),
			PL_216 NVARCHAR(1000),
			PL_217 NVARCHAR(1000),
			PL_218 NVARCHAR(1000),
			PL_219 NVARCHAR(1000),
			PL_220 NVARCHAR(1000),
			PL_221 NVARCHAR(1000),
			PL_222 NVARCHAR(1000),
			PL_223 NVARCHAR(1000),
			PL_224 NVARCHAR(1000),
			PL_225 NVARCHAR(1000),
			PL_226 NVARCHAR(1000),
			PL_227 NVARCHAR(1000),
			PL_228 NVARCHAR(1000),
			PL_229 NVARCHAR(1000),
			PL_230 NVARCHAR(1000),
			PL_231 NVARCHAR(1000),
			PL_232 NVARCHAR(1000),
			PL_233 NVARCHAR(1000),
			PL_234 NVARCHAR(1000),
			PL_235 NVARCHAR(1000),
			PL_236 NVARCHAR(1000),
			PL_237 NVARCHAR(1000),
			PL_238 NVARCHAR(1000),
			PL_239 NVARCHAR(1000),
			PL_240 NVARCHAR(1000),
			PL_241 NVARCHAR(1000),
			PL_242 NVARCHAR(1000),
			PL_243 NVARCHAR(1000),
			PL_244 NVARCHAR(1000),
			PL_245 NVARCHAR(1000),
			PL_246 NVARCHAR(1000),
			PL_247 NVARCHAR(1000),
			PL_248 NVARCHAR(1000),
			PL_249 NVARCHAR(1000),
			PL_250 NVARCHAR(1000),
			PL_251 NVARCHAR(1000),
			PL_252 NVARCHAR(1000),
			PL_253 NVARCHAR(1000),
			PL_254 NVARCHAR(1000),
			PL_255 NVARCHAR(1000),
			PL_256 NVARCHAR(1000),
			PL_257 NVARCHAR(1000),
			PL_258 NVARCHAR(1000),
			PL_259 NVARCHAR(1000),
			PL_260 NVARCHAR(1000),
			PL_261 NVARCHAR(1000),
			PL_262 NVARCHAR(1000),
			PL_263 NVARCHAR(1000),
			PL_264 NVARCHAR(1000),
			PL_265 NVARCHAR(1000),
			PL_266 NVARCHAR(1000),
			PL_267 NVARCHAR(1000),
			PL_268 NVARCHAR(1000),
			PL_269 NVARCHAR(1000),
			PL_270 NVARCHAR(1000),
			PL_271 NVARCHAR(1000),
			PL_272 NVARCHAR(1000),
			PL_273 NVARCHAR(1000),
			PL_274 NVARCHAR(1000),
			PL_275 NVARCHAR(1000),
			PL_276 NVARCHAR(1000),
			PL_277 NVARCHAR(1000),
			PL_278 NVARCHAR(1000),
			PL_279 NVARCHAR(1000),
			PL_280 NVARCHAR(1000),
			PL_281 NVARCHAR(1000),
			PL_282 NVARCHAR(1000),
			PL_283 NVARCHAR(1000),
			PL_284 NVARCHAR(1000),
			PL_285 NVARCHAR(1000),
			PL_286 NVARCHAR(1000),
			PL_287 NVARCHAR(1000),
			PL_288 NVARCHAR(1000),
			PL_289 NVARCHAR(1000),
			PL_290 NVARCHAR(1000),
			PL_291 NVARCHAR(1000),
			PL_292 NVARCHAR(1000),
			PL_293 NVARCHAR(1000),
			PL_294 NVARCHAR(1000),
			PL_295 NVARCHAR(1000),
			PL_296 NVARCHAR(1000),
			PL_297 NVARCHAR(1000),
			PL_298 NVARCHAR(1000),
			PL_299 NVARCHAR(1000),
			PL_300 NVARCHAR(1000),
			PL_301 NVARCHAR(1000),
			PL_302 NVARCHAR(1000),
			PL_303 NVARCHAR(1000),
			PL_304 NVARCHAR(1000),
			PL_305 NVARCHAR(1000),
			PL_306 NVARCHAR(1000),
			PL_307 NVARCHAR(1000),
			PL_308 NVARCHAR(1000),
			PL_309 NVARCHAR(1000),
			PL_310 NVARCHAR(1000),
			PL_311 NVARCHAR(1000),
			PL_312 NVARCHAR(1000),
			PL_313 NVARCHAR(1000),
			PL_314 NVARCHAR(1000),
			PL_315 NVARCHAR(1000),
			PL_316 NVARCHAR(1000),
			PL_317 NVARCHAR(1000),
			PL_318 NVARCHAR(1000),
			PL_319 NVARCHAR(1000),
			PL_320 NVARCHAR(1000),
			PL_321 NVARCHAR(1000),
			PL_322 NVARCHAR(1000),
			PL_323 NVARCHAR(1000),
			PL_324 NVARCHAR(1000),
			PL_325 NVARCHAR(1000),
			PL_326 NVARCHAR(1000),
			PL_327 NVARCHAR(1000),
			PL_328 NVARCHAR(1000),
			PL_329 NVARCHAR(1000),
			PL_330 NVARCHAR(1000),
			PL_331 NVARCHAR(1000),
			PL_332 NVARCHAR(1000),
			PL_333 NVARCHAR(1000),
			PL_334 NVARCHAR(1000),
			PL_335 NVARCHAR(1000),
			PL_336 NVARCHAR(1000),
			PL_337 NVARCHAR(1000),
			PL_338 NVARCHAR(1000),
			PL_339 NVARCHAR(1000),
			PL_340 NVARCHAR(1000),
			PL_341 NVARCHAR(1000),
			PL_342 NVARCHAR(1000),
			PL_343 NVARCHAR(1000),
			PL_344 NVARCHAR(1000),
			PL_345 NVARCHAR(1000),
			PL_346 NVARCHAR(1000),
			PL_347 NVARCHAR(1000),
			PL_348 NVARCHAR(1000),
			PL_349 NVARCHAR(1000),
			PL_350 NVARCHAR(1000),
			PL_351 NVARCHAR(1000),
			PL_352 NVARCHAR(1000),
			PL_353 NVARCHAR(1000),
			PL_354 NVARCHAR(1000),
			PL_355 NVARCHAR(1000),
			PL_356 NVARCHAR(1000),
			PL_357 NVARCHAR(1000),
			PL_358 NVARCHAR(1000),
			PL_359 NVARCHAR(1000),
			PL_360 NVARCHAR(1000),
			PL_361 NVARCHAR(1000),
			PL_362 NVARCHAR(1000),
			PL_363 NVARCHAR(1000),
			PL_364 NVARCHAR(1000),
			PL_365 NVARCHAR(1000),
			PL_366 NVARCHAR(1000),
			PL_367 NVARCHAR(1000),
			PL_368 NVARCHAR(1000),
			PL_369 NVARCHAR(1000),
			PL_370 NVARCHAR(1000),
			PL_371 NVARCHAR(1000),
			PL_372 NVARCHAR(1000),
			PL_373 NVARCHAR(1000),
			PL_374 NVARCHAR(1000),
			PL_375 NVARCHAR(1000),
			PL_376 NVARCHAR(1000),
			PL_377 NVARCHAR(1000),
			PL_378 NVARCHAR(1000),
			PL_379 NVARCHAR(1000),
			PL_380 NVARCHAR(1000),
			PL_381 NVARCHAR(1000),
			PL_382 NVARCHAR(1000),
			PL_383 NVARCHAR(1000),
			PL_384 NVARCHAR(1000),
			PL_385 NVARCHAR(1000),
			PL_386 NVARCHAR(1000),
			PL_387 NVARCHAR(1000),
			PL_388 NVARCHAR(1000),
			PL_389 NVARCHAR(1000),
			PL_390 NVARCHAR(1000),
			PL_391 NVARCHAR(1000),
			PL_392 NVARCHAR(1000),
			PL_393 NVARCHAR(1000),
			PL_394 NVARCHAR(1000),
			PL_395 NVARCHAR(1000)--,
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
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@TitleCodes, ',') WHERE [number] NOT IN('0', '')
		
			DELETE FROM #SearchTitle WHERE TitleCode = 0

			IF NOT EXISTS(SELECT TOP 1 * FROM #SearchTitle)
			BEGIN
				INSERT INTO #SearchTitle
				SELECT DISTINCT Title_Code FROM Avail_Title_Data
			END
			
		END ------------------ END

		BEGIN ----------------- SUBLICENSE SEARCH 

			INSERT INTO #SearchSubLicense(SubLicenseCode)
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@SubLicenseCode, ',') WHERE ISNULL([number], 0) NOT IN('0', '')
		
			IF NOT EXISTS(SELECT TOP 1 * FROM #SearchSubLicense)
			BEGIN
				
				INSERT INTO #SearchSubLicense
				SELECT Sub_License_Code FROM Sub_License

			END
			
			--DELETE FROM #AvailTitleData WHERE Avail_Country_Code NOT IN (SELECT Avail_Country_Code FROM #DBAvailCountry)

		END ------------------ END

		DECLARE @DealType TABLE (
			DealTypeCode INT
		)

		DECLARE @DealTypes VARCHAR(500) = ''
		IF(@ReportType = 'M')
		BEGIN

			SELECT @DealTypes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_DealType_Movies'

			SELECT @EpisodeFrom = 1, @EpisodeTo = 1

		END
		ELSE
		BEGIN

			SELECT @DealTypes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_DealType_Show'
		
			SET @EpisodeFrom = CASE WHEN ISNULL(@EpisodeFrom, 0) < 1 THEN 1 ELSE @EpisodeFrom END
			SET @EpisodeTo = CASE WHEN ISNULL(@EpisodeTo, 0) < 1 THEN 100000 ELSE @EpisodeTo END

		END

		INSERT INTO @DealType(DealTypeCode)
		SELECT CAST(LTRIM(RTRIM(ISNULL([number], 0))) AS INT) FROM fn_Split_withdelemiter(@DealTypes, ',')

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
		INNER JOIN @DealType dt ON ad.Deal_Type_Code = dt.DealTypeCode
		WHERE (ad.Business_Unit_Code = CAST(@BUCode AS INT) OR  CAST(@BUCode AS INT) = 0) AND atd.Is_Exclusive IN (@Ex_YES, @Ex_NO, @EX_CO)
		AND ISNULL(adt.End_Date, '9999-12-31') >= CAST(GETDATE() AS DATE)
		AND (
			atd.Episode_From Between @EpisodeFrom And @EpisodeTo Or
			atd.Episode_To Between @EpisodeFrom And @EpisodeTo Or
			@EpisodeFrom Between atd.Episode_From And atd.Episode_To Or
			@EpisodeTo Between atd.Episode_From And atd.Episode_To
		) 

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
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@PlatformCodes,',') WHERE [number] NOT IN('0', '')
	
			INSERT INTO #SearchPlatformMH(PlatformCode)
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@MustHavePlatforms, ',') WHERE [number] NOT IN('0', '')
			
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
			SELECT DISTINCT [number] FROM fn_Split_withdelemiter(@CountryCodes , ',') WHERE [number] NOT IN('0')
			
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
						SELECT [number] FROM fn_Split_withdelemiter(@TerritoryCodes, ',') WHERE [number] NOT IN('0')
					) AND td.Country_Code NOT IN (
						SELECT tc.CountryCode FROM #SearchCountry tc
					)
					AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
					AND td.Country_Code NOT IN (SELECT [number] FROM fn_Split_withdelemiter(@ExclusionCountry, ',') WHERE [number] NOT IN ( '0', ''))

				END
				ELSE IF(@IsIFTACluster = 'Y')
				BEGIN
		
					INSERT INTO #SearchCountry(CountryCode)
					SELECT DISTINCT Country_Code FROM Report_Territory_Country td WHERE td.Report_Territory_Code IN (
						SELECT [number] FROM fn_Split_withdelemiter(@TerritoryCodes, ',') WHERE [number] NOT IN('0')
					) AND td.Country_Code NOT IN (
						SELECT tc.CountryCode FROM #SearchCountry tc
					)
					AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
					AND td.Country_Code NOT IN (SELECT [number] FROM fn_Split_withdelemiter(@ExclusionCountry, ',') WHERE [number] NOT IN ( '0', ''))

				END
			
				INSERT INTO #SearchCountryMH(CountryCode)
				SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@MustHaveCountry, ',') WHERE [number] NOT IN('0', '')
			
				DELETE FROM #SearchCountryMH WHERE CountryCode = 0
	
				DECLARE @CountryCode VARCHAR(10) = ''
				IF(ISNULL(@ExclusionCountry, '') = '')
					SET @ExclusionCountry = '0'

				DECLARE CurCountry CURSOR FOR SELECT CountryCode FROM #SearchCountry
												WHERE CountryCode Not In (
													SELECT CAST([number] AS INT) [value] FROM fn_Split_withdelemiter(@ExclusionCountry, ',')
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
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@TitleLanguageCode,',') WHERE [number] NOT IN('0', '')
			
			INSERT INTO #SearchSubtitling(LanguageCode)
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@SubtitlingCodes, ',') WHERE [number] NOT IN('0', '')
	
			INSERT INTO #SearchSubtitling(LanguageCode)
			SELECT DISTINCT Language_Code FROM Language_Group_Details td WHERE td.Language_Group_Code IN (
				SELECT [number] FROM fn_Split_withdelemiter(@SubtitlingGroupCodes, ',') WHERE [number] NOT IN('0')
			) AND td.Language_Code NOT IN (
				SELECT tc.LanguageCode FROM #SearchSubtitling tc
			)
			AND td.Language_Code IN (SELECT l.Language_Code FROM Language l WHERE ISNULL(l.Is_Active, 'N') = 'Y')

			INSERT INTO #SearchDubbing(LanguageCode)
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@DubbingCodes, ',') WHERE [number] NOT IN('0', '')
	
			INSERT INTO #SearchDubbing(LanguageCode)
			SELECT DISTINCT Language_Code FROM Language_Group_Details td WHERE td.Language_Group_Code IN (
				SELECT [number] FROM fn_Split_withdelemiter(@DubbingGroupCodes, ',') WHERE [number] NOT IN('0')
			) AND td.Language_Code NOT IN (
				SELECT tc.LanguageCode FROM #SearchDubbing tc
			)
			AND td.Language_Code IN (SELECT l.Language_Code FROM Language l WHERE ISNULL(l.Is_Active, 'N') = 'Y')

			INSERT INTO #SearchSubtitlingMH(LanguageCode)
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@MustHaveSubtitling, ',') WHERE [number] NOT IN('0', '')
	
			INSERT INTO #SearchDubbingMH(LanguageCode)
			SELECT CAST([number] AS INT) FROM fn_Split_withdelemiter(@MustHaveDubbing, ',') WHERE [number] NOT IN('0', '')
	
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
													SELECT CAST([number] AS INT) [number] FROM fn_Split_withdelemiter(@ExclusionSubtitling, ',')
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
													SELECT CAST([number] AS INT) [number] FROM fn_Split_withdelemiter(@ExclusionDubbing,',')
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
			IF(@IsTitleLanguage = 1)
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
		INNER JOIN #TempLanguageNames tml ON tm.LanguageCodes = tml.LanguageCodes

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
	
	--IF(@DisplayCoExRemarks = 1)
	--BEGIN

	--	UPDATE trrOut
	--	SET trrOut.CoExclusive_Remark =  STUFF
	--	(
	--		(
	--			SELECT DISTINCT ',' + ISNULL(sdr.CoExclusive_Remarks, '')
	--			FROM #TempRightRemarks trr
	--			INNER JOIN Syn_Acq_Mapping sam ON trr.Acq_Deal_Rights_Code = sam.Deal_Rights_Code
	--			INNER JOIN Syn_Deal_Rights sdr ON sam.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code AND sdr.Is_Exclusive = 'C'
	--			WHERE trr.Acq_Deal_Rights_Code = trrOut.Acq_Deal_Rights_Code
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	)
	--	FROM #TempRightRemarks trrOut

	--END

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
			--CASE WHEN ISNULL(Year_Of_Production, '') = '' THEN Title_Name ELSE Title_Name + ' ('+ CAST(Year_Of_Production AS VARCHAR(10)) + ')' END Title_Name
			Title_Name, Genres_Name = [dbo].[UFNGetGenresForTitle](t.Title_Code),
			Star_Cast = [dbo].[UFNGetTalentForTitle](t.Title_Code, 2),
			Director = [dbo].[UFNGetTalentForTitle](t.Title_Code, 1),
			COALESCE(t.Duration_In_Min, '0') Duration_In_Min, COALESCE(t.Year_Of_Production, '') Year_Of_Production, l.Language_Name
		FROM Title t 
		INNER JOIN Language l On t.Title_Language_Code = l.Language_Code
		INNER JOIN Deal_Type dt ON t.Deal_Type_Code = dt.Deal_Type_Code
		WHERE(t.Title_Code IN (SELECT tm.Title_Code FROM #AvailTitleData tm))

		UPDATE #TempTitlesInfo SET Year_Of_Production = '' WHERE Year_Of_Production = '0'
		------------------END
	END
	
	PRINT 'STEP-6 POPULATE PLATFORMWISE DATA --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	
	BEGIN

		DELETE FROM #DBAvailPlatform WHERE Avail_Platform_Code NOT IN (
			SELECT DISTINCT Avail_Platform_Code FROM #AvailTitleData
		)

		PRINT 'STEP-6.1 DELETE Platform --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)	

		INSERT INTO #TempPlatformData(Avail_Platform_Code, PlatformCode)
		SELECT dap.Avail_Platform_Code, a.number FROM #DBAvailPlatform dap
		CROSS APPLY fn_Split_withdelemiter(dap.PlatformCodes, ',') a
		WHERE a.number <> '' 
		AND LEN(a.number) <= 3 ----- Need to remove this condition when priyal sir recheck and 
		
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
		SELECT tm.Acq_Deal_Code, tm.Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Is_Exclusive, Platform_Code, a.[number], tm.Start_Date, tm.End_Date, 
							  Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code
		FROM #TempMain tm
		INNER JOIN Acq_Deal_Rights_Holdback hb ON hb.Acq_Deal_Rights_Code = tm.Acq_Deal_Rights_Code
		INNER JOIN #DBAvailCountry dac ON tm.Avail_Country_Code = dac.Avail_Country_Code
		CROSS APPLY fn_Split_withdelemiter(dac.CountryCode, ',') a 
		WHERE a.[number] <> ''
		AND LEN(a.[number]) <= 3
		
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
							  AND ISNULL(t1.Is_Title_Language, 2) = ISNULL(t2.Is_Title_Language, 2)
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

	PRINT 'STEP-12 OBJECTION OUTPUT --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	DECLARE @Is_Allow_Title_Objection CHAR(1) = 'N'
	SELECT @Is_Allow_Title_Objection = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_Allow_Title_Objection'
	IF (@Is_Allow_Title_Objection = 'Y')
	--IF (@DisplayObjection = 1)
	BEGIN
		IF OBJECT_ID('tempdb..#Title_Objection') IS NOT NULL DROP TABLE #Title_Objection
		IF OBJECT_ID('tempdb..#Title_Objection_Rights_Period') IS NOT NULL DROP TABLE #Title_Objection_Rights_Period

		SELECT * INTO #Title_Objection_Rights_Period FROM Title_Objection_Rights_Period
	
		SELECT DISTINCT A.Title_Objection_Code, A.Record_Code, A.Title_Code, A.Objection_Start_Date, A.Objection_End_Date 
		, B.Rights_Start_Date, B.Rights_End_Date,
		 STUFF((
			SELECT ', ' + COALESCE(C.Country_Name, TR.Territory_Name)
			FROM Title_Objection_Territory T
			LEFT JOIN Country C ON C.Country_Code = T.Country_Code
			LEFT JOIN Territory TR ON TR.Territory_Code = T.Territory_Code
			WHERE T.Title_Objection_Code = A.Title_Objection_Code
           FOR XML PATH('')
           ), 1, 1, '') AS Region,
		STUFF((
			SELECT ',' + CAST(P.Platform_Code AS VARCHAR)
			FROM Title_Objection_Platform P
			WHERE P.Title_Objection_Code = A.Title_Objection_Code
           FOR XML PATH('')
           ), 1, 1, '') AS Platform_Name
		INTO #Title_Objection
		FROM Title_Objection A
		INNER JOIN #Title_Objection_Rights_Period B ON A.Title_Objection_Code = B.Title_Objection_Code 
		WHERE A.Record_Type = 'A'

		UPDATE PT SET PT.Platform_Name = a.Platform_Hierarchy
		from #Title_Objection PT
		CROSS APPLY  [dbo].[UFNGetPlatformHierarchyWithNo](PT.Platform_Name) a
		
		UPDATE tm SET tm.Objection_Start_Date = TOB.Objection_Start_Date,
						tm.Objection_End_Date = TOB.Objection_End_Date,
						tm.Objection_Platform = TOB.Platform_Name,
						tm.Objection_Region = TOB.Region,
						tm.Under_Litigation = 'Yes. Please contact legal for further details'
		FROM #TempMain tm
		INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = tm.Acq_Deal_Rights_Code
		INNER JOIN #Title_Objection TOB ON TOB.Record_Code = tm.Acq_Deal_Code AND TOB.Title_Code = tm.Title_Code 
			AND TOB.Rights_Start_Date = ADR.[Actual_Right_Start_Date] AND ISNULL(TOB.Rights_End_Date,'') = ISNULL(ADR.Actual_Right_End_Date,'')

	END
	--SELECT * FROM Avail_Title_Data WHERE Title_Code IN (
	--	SELECT Title_Code FROM Title_Objection
	--)
	--SELECT * FROM #TempMain
	--RETURN

	PRINT 'STEP-13 WORKING FOR FIRST ROW --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		DECLARE @tblPlatformCodes AS TABLE
		(
			IntCode INT IDENTITY(1, 1),
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
			)--.value('text()[1]', 'NVARCHAR(MAX)')
			, 1, 1, ''
		)

		SELECT @PlatformStr = REPLACE(@PlatformStr, '&amp;', '&')

		SELECT @Cols = STUFF
		(
			(
				SELECT ', PL_' + CAST(IntCode AS VARCHAR(10))
				FROM @tblPlatformCodes
				--SELECT ', PL_' + CAST(ROW_NUMBER() OVER(ORDER BY Platform_Code) AS VARCHAR(10))
				--FROM (
				--	SELECT Platform_Code FROM @tblPlatformCodes
				--) AS tm
				FOR XML PATH('')
			), 1, 1, ''
		)

		--DECLARE @PlCounter INT = 0, @CurCounter INT = 1, @strWhileDefSet VARCHAR(2000) = '';
		--SELECT @PlCounter = MAX(IntCode) FROM @tblPlatformCodes
		--WHILE (@CurCounter <= @PlCounter)
		--BEGIN

		--	SET @strWhileDefSet = 'ALTER TABLE #TempOutput ADD CONSTRAINT TM_BLA_PL_' + CAST(@CurCounter AS VARCHAR(10)) + ' DEFAULT(''No'') FOR PL_' + CAST(@CurCounter AS VARCHAR(10))
		--	EXEC(@strWhileDefSet)

		--	SET @CurCounter = @CurCounter + 1
		--END

		SELECT @FirstRow = 'INSERT INTO #TempOutput(OutputOrder, TitleType, Title, EpisodeFrom, EpisodeTo, ClusterNames, RegionName, StartDate, EndDate, TitleLanguage, SubTiltling, ' +
						   'Dubbing, Genre, StarCast, Director, Duration, ReleaseYear, RestrictionRemarks, SubDealRestrictionRemarks, Remarks, RightsRemarks, Exclusive, SubLicense, HoldbackOn, ' +
						   'HoldbackType, HoldbackReleaseDate, ReverseHoldback, ROFR, SelfUtilizationGroup, SelfUtilizationRemarks, ' +
						   'ObjectionPlatform, ObjectionRegion, ObjectionStartDate, ObjectionEndDate, UnderLitigation, CoExclusive_Remark, ' + @Cols + ')' +
		'SELECT 0, ''Title Type'', ''Title Name'', ''Episode From'', ''Episode To'', ''Reporting Cluster'', ''Country'', ''Start Date'', ''End Date'', ''Title Language Name'', ''Subtitling Language'', 
		''Dubbing Language'', ''Genre Name'', ''Star Cast'', ''Director'', ''Duration(in min)'', ''Production Year'', ''Restriction Remark'', ''Sub Deal Restriction Remark'', ''Deal Remarks'', ''Rights Remarks'', ''Exclusive'', ''Sub License'', ''Holdback On'', 
		''Holdback Type'', ''Holdback Release Date'', ''Reverse Holdback'', ''ROFR'', ''Self-Utilization Group'', ''Self-Utilization Remarks'', 
		''Objection Platform'', ''Objection Region'', ''Objection Start Date'', ''Objection End Date'', ''Under Litigation'', ''CoExclusive Remark'', ' + REPLACE(REPLACE(@PlatformStr, '[', ''), ']', '')

		--SELECT @FirstRow
		EXEC(@FirstRow)

		SET @PlatformStr = REPLACE(@PlatformStr, '''', '')

	END

	PRINT 'STEP-14 FINAL OUTPUT --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		SET @FirstRow = ''
		SELECT @FirstRow = 'INSERT INTO #TempOutput(OutputOrder, TitleType, Title, EpisodeFrom, EpisodeTo, ClusterNames, RegionName, StartDate, EndDate, ' +
													'TitleLanguage, SubTiltling, Dubbing, Genre, StarCast, Director, ' +
													'Duration, ReleaseYear, RestrictionRemarks, SubDealRestrictionRemarks, Remarks, RightsRemarks, Exclusive, SubLicense, ' +
													'HoldbackOn, HoldbackType, HoldbackReleaseDate, ReverseHoldback, '+
													'ObjectionPlatform, ObjectionRegion, ObjectionStartDate, ObjectionEndDate, UnderLitigation, CoExclusive_Remark, ' + @Cols + ') ' +
			'SELECT 1, Title_Type, Title_Name, Episode_From, Episode_To, ClusterNames, RegionName, REPLACE(CONVERT(VARCHAR(50), Right_Start_Date, 106), '' '', ''-''), REPLACE(CONVERT(VARCHAR(50), Rights_End_Date, 106), '' '', ''-''), ' + 
				   'Title_Language_Names, Sub_Language_Names, Dub_Language_Names, Genres_Name, Star_Cast, Director, ' +
				   'Duration_In_Min, Year_Of_Production, Restriction_Remark, Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, Sub_License, ' +
				   'HoldbackOn, Holdback_Type, Holdback_Release_Date, Reverse_Holdback, ' + 
				   'Objection_Platform, Objection_Region, Objection_Start_Date, Objection_End_Date, Under_Litigation, CoExclusive_Remark, ' + @PlatformStr + ' FROM ( ' +
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
				   'trr.Remarks, trr.Rights_Remarks, CASE WHEN tm.Is_Exclusive = 1 THEN ''Exclusive'' WHEN tm.Is_Exclusive = 2 THEN ''Co-Exclusive'' ELSE ''Non Exclusive'' END AS  Exclusive, ' +
				   'trr.Sub_License_Name AS Sub_License, ' +
				   'CASE WHEN ISNULL(pt1.Platform_Hiearachy, '''') = '''' OR tm.Start_Date > tm.Holdback_Release_Date THEN '''' ELSE hb.HBComments + pt1.Platform_Hiearachy END COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn, ' +
				   'tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, ' +
				   'CASE WHEN ISNULL(tm.Holdback_Release_Date, '''') = '''' OR tm.Start_Date > tm.Holdback_Release_Date THEN '''' ELSE CONVERT(VARCHAR(20),tm.Holdback_Release_Date, 103) END ' +
				   'COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date, rhb.strRHB COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback, ' +
				   'tm.Objection_Platform, tm.Objection_Region, REPLACE(CONVERT(VARCHAR(50), tm.Objection_Start_Date, 106), '' '', ''-'') AS Objection_Start_Date, ' +
				   'REPLACE(CONVERT(VARCHAR(50), tm.Objection_End_Date, 106), '' '', ''-'') Objection_End_Date, tm.Under_Litigation, ' +
				   'CASE WHEN tm.Is_Exclusive = 2 THEN trr.CoExclusive_Remark ELSE '''' END AS CoExclusive_Remark ' +
			'FROM #TempMain tm ' +
			'INNER JOIN #TempTitlesInfo tti ON tm.Title_Code = tti.Title_Code ' +
			'INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code ' +
			'INNER JOIN #TempRightRemarks trr ON tm.Acq_Deal_Rights_Code = trr.Acq_Deal_Rights_Code ' +
			'LEFT JOIN #DBAvailLanguages sub ON tm.Avail_Subtitling_Code = sub.Avail_Languages_Code ' +
			'LEFT JOIN #DBAvailLanguages dub ON tm.Avail_Dubbing_Code = dub.Avail_Languages_Code ' +
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
		--SELECT @FirstRow

	END	

	SELECT * FROM #TempOutput ORDER BY OutputOrder, Title

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
		IF OBJECT_ID('tempdb..#Title_Objection') IS NOT NULL DROP TABLE #Title_Objection
		IF OBJECT_ID('tempdb..#Title_Objection_Rights_Period') IS NOT NULL DROP TABLE #Title_Objection_Rights_Period

	END

END

/*

EXEC [dbo].[USPAvailability] @TitleCodes='58509', @EpisodeFrom='0', @EpisodeTo='0', @DateType='FL', @StartDate='2023-12-21', @EndDate='', @PlatformCodes='0,0,19,20,0,0,83,85,0,87,89,0,0,90,91,92,0,217,219,221,223,224,225,226,94,0,0,95,96,97,98,99,100,101,102,103,0,0,227,228,229,230,231,232,105,106,107,109,0,0,110,111,112,113,114,115,116,117,118,119,0,0,233,234,235,236,237,238,121,122,0,0,123,0,239,240,241,242,125,0,243,244,245,246,247,248,249,0,0,250,251,252,253,254,255,128,0,0,129,130,0,256,257,132,0,133,134,0,258,259,136,0,0,137,138,139,140,141,0,142,143,144,145,146,0,0,147,148,149,150,151,0,152,153,154,155,156,0,36,37,38,39,40,41,42,43,44,45,46,0,157,158,0,48,49,50,51,52,53,54,0,159,160,161,162,0,0,163,164,0,165,166,0,167,168,59,60,61,0,169,170,171,63,64,65,66,0,0,172,0,260,261,174,175,0,262,263,264,265,177,0,0,266,267,268,269,270,271,179,0,272,273,274,181,182,183,0,275,276,277,278,185,0,0,186,187,188,189,0,279,280,191,192,0,0,281,282,283,284,285,286,194,0,0,0,287,288,196,0,0,0,289,290,291,0,292,293,294,0,199,0,200,0,295,296,297,298,299,300,301,0,202,0,302,303,304,305,306,307,308,309,310,0,204,205,0,206,0,311,312,313,314,315,316,317,0,208,0,318,319,320,321,322,323,324,0,210,0,325,326,327,328,329,330,331,80,0,0,0,332,333,213,214,215,0,0,334,335,218,220,222,0,84,86,88', @ExactMatchPlatforms='', @MustHavePlatforms='0', @IsIFTACluster='Y', @TerritoryCodes='0', @CountryCodes='0,45,258,143,259,260,219,144,261,146,10,147,64,5,220,221,49,72,148,218,26,150,222,262,68,151,152,216,76,153,70,263,223,224,155,225,61,156,253,157,158,17,264,265,159,160,266,161,22,162,163,33,23,257,25,164,165,166,74,167,168,169,267,226,227,268,170,269,270,271,59,40,6,228,272,273,229,230,274,4,171,275,32,276,172,173,277,174,231,232,175,53,278,176,57,31,279,42,18,56,19,62,11,29,233,177,13,178,9,179,280,281,69,180,282,182,283,235,183,284,285,236,237,286,287,2,184,238,239,288,240,241,20,289,185,326,290,186,217,187,21,291,60,188,292,54,3,293,294,65,189,243,190,295,191,296,297,35,50,55,298,77,299,192,181,193,300,301,36,30,302,51,256,303,242,304,7,8,194,305,199,201,306,307,247,52,308,248,37,195,249,47,24,309,310,196,46,197,311,28,27,198,200,202,250,251,312,39,203,204,14,205,41,254,255,252,313,314,315,207,208,34,209,210,316,211,12,48,43,212,213,317,325,214,73,154,318,319,320,321,215,322,323', @ExactMatchCountry='', @MustHaveCountry='', @ExclusionCountry='', @IsTitleLanguage='1', @TitleLanguageCode='0', @DubbingSubtitling='S,D', @SubtitlingGroupCodes='G1', @SubtitlingCodes='0,77,117,78,2,1159,10,55,1167,65,79,17,80,76,42,1136,56,1133,1146,48,1163,1165,73,118,70,68,81,82,1130,1184,1162,128,83,19,20,22,126,127,84,63,1168,4,119,37,1141,1181,1126,35,6,85,86,120,5,28,41,1134,87,88,66,1169,89,11,90,43,1170,1,1132,1137,91,27,92,93,1144,1152,1151,1150,25,13,67,94,51,1139,62,1171,9,59,95,96,97,61,1172,15,72,121,1182,1183,1149,122,98,1164,1166,99,46,3,1140,123,45,58,1173,38,1142,57,100,101,102,124,74,103,49,1174,1147,30,54,1127,1175,1161,104,1180,69,18,1148,31,26,47,1143,105,1131,1185,7,8,1145,1176,64,1128,1177,106,32,1153,1154,1156,107,50,60,1178,23,1160,1158,21,75,24,108,33,34,109,110,14,125,39,1138,40,1135,36,1129,1157,1187,29,12,53,1179,111,71,52,1186,112,113,114,1155,115,116', @ExactMatchSubtitling='          ', @MustHaveSubtitling='0', @ExclusionSubtitling='', @DubbingGroupCodes='G1', @DubbingCodes='0,77,117,78,2,1159,10,55,1167,65,79,17,80,76,42,1136,56,1133,1146,48,1163,1165,73,118,70,68,81,82,1130,1184,1162,128,83,19,20,22,126,127,84,63,1168,4,119,37,1141,1181,1126,35,6,85,86,120,5,28,41,1134,87,88,66,1169,89,11,90,43,1170,1,1132,1137,91,27,92,93,1144,1152,1151,1150,25,13,67,94,51,1139,62,1171,9,59,95,96,97,61,1172,15,72,121,1182,1183,1149,122,98,1164,1166,99,46,3,1140,123,45,58,1173,38,1142,57,100,101,102,124,74,103,49,1174,1147,30,54,1127,1175,1161,104,1180,69,18,1148,31,26,47,1143,105,1131,1185,7,8,1145,1176,64,1128,1177,106,32,1153,1154,1156,107,50,60,1178,23,1160,1158,21,75,24,108,33,34,109,110,14,125,39,1138,40,1135,36,1129,1157,1187,29,12,53,1179,111,71,52,1186,112,113,114,1155,115,116', @ExactMatchDubbing='          ', @MustHaveDubbing='0', @ExclusionDubbing='', @Exclusivity='B', @SubLicenseCode='', @RestrictionRemarks='True', @OthersRemarks='True', @BUCode='0', @IsDigital='0', @L1Output='N', @ReportType='M'

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


	PRINT 'STEP-12 WORKING FOR FIRST ROW --> ' + CONVERT(VARCHAR(30), GETDATE() ,109)
	BEGIN

		

		SELECT @FirstRow = 'INSERT INTO #TempOutput(OutputOrder, TitleType, Title, EpisodeFrom, EpisodeTo, ClusterNames, RegionName, StartDate, EndDate, TitleLanguage, SubTiltling, Dubbing, Genre, StarCast, Director, Duration, ReleaseYear, RestrictionRemarks, SubDealRestrictionRemarks, Remarks, RightsRemarks, Exclusive, SubLicense, HoldbackOn, HoldbackType, HoldbackReleaseDate, ReverseHoldback, ROFR, SelfUtilizationGroup, SelfUtilizationRemarks, ' + @Cols + ')' +
		'SELECT 0, ''Title Type'', ''Title Name'', ''Episode From'', ''Episode To'', ''Reporting Cluster'', ''Country'', ''Start Date'', ''End Date'', ''Title Language Name'', ''Subtitling Language'', ''Dubbing Language'', ''Genre Name'', ''Star Cast'', ''Director'', ''Duration(in min)'', ''Production Year'', ''Restriction Remark'', ''Sub Deal Restriction Remark'', ''Deal Remarks'', ''Rights Remarks'', ''Exclusive'', ''Sub License'', ''Holdback On'', ''Holdback Type'', ''Holdback Release Date'', ''Reverse Holdback'', ''ROFR'', ''Self-Utilization Group'', ''Self-Utilization Remarks'', ' + REPLACE(REPLACE(@PlatformStr, '[', ''), ']', '')

		EXEC(@FirstRow)

		SET @PlatformStr = REPLACE(@PlatformStr, '''', '')

	END
	lllllll
*/
