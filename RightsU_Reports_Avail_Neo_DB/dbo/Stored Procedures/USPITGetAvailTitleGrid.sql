CREATE PROCEDURE [dbo].[USPITGetAvailTitleGrid]
AS
BEGIN

--DECLARE
--@UDT TitleCriteria --READONLY

	
	
	--INSERT INTO @UDT
	

	IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
	IF OBJECT_ID('tempdb..#CountryCode') IS NOT NULL DROP TABLE #CountryCode
	IF OBJECT_ID('tempdb..#MediaPlatforms') IS NOT NULL DROP TABLE #MediaPlatforms
	IF OBJECT_ID('tempdb..#ModeOfExploitations') IS NOT NULL DROP TABLE #ModeOfExploitations
	IF OBJECT_ID('tempdb..#PlatformCodes') IS NOT NULL DROP TABLE #PlatformCodes
	IF OBJECT_ID('tempdb..#Vendor') IS NOT NULL DROP TABLE #Vendor
	IF OBJECT_ID('tempdb..#Talent') IS NOT NULL DROP TABLE #Talent
	IF OBJECT_ID('tempdb..#TitleLanguage') IS NOT NULL DROP TABLE #TitleLanguage
	IF OBJECT_ID('tempdb..#SubtitlingLanguageCodes') IS NOT NULL DROP TABLE #SubtitlingLanguageCodes
	IF OBJECT_ID('tempdb..#DubbingLanguageCodes') IS NOT NULL DROP TABLE #DubbingLanguageCodes
	--IF OBJECT_ID('tempdb..##tempGlobal') IS NOT NULL DROP TABLE ##tempGlobal

	CREATE TABLE #tempCriteria(
		ValueField NVARCHAR(MAX),
		TextField NVARCHAR(MAX)
	)
	--Select * FROM ##tempGlobal

	INSERT INTO #tempCriteria
	SELECT * FROM ##tempGlobal

	--INSERT INTO @UDT VALUES('Country','1,2,3')
	--INSERT INTO @UDT VALUES('Media Platform','Cable-HITS,IPTV')
	--INSERT INTO @UDT VALUES('Mode of Exploitation','Free,NVOD,Pay' )
	--INSERT INTO @UDT VALUES('PeriodType','Min')
	--INSERT INTO @UDT VALUES('Start Date','12Jan2020')
	--INSERT INTO @UDT VALUES('End Date','12Jan2021')
	--INSERT INTO @UDT VALUES('Exclusivity','Y')
	--INSERT INTO @UDT VALUES('Title Language',',1,2,3,4')
	--INSERT INTO @UDT VALUES('Subtitling Language','')
	--INSERT INTO @UDT VALUES('Dubbing Language','')
	--INSERT INTO @UDT VALUES('Licensor','1,2,3,4')
	--INSERT INTO @UDT VALUES('Star Cast','')

	--INSERT INTO #tempCriteria
	--SELECT * FROM @UDT

	DECLARE @Exclusivity INT
	SET @Exclusivity = (SELECT CASE WHEN TextField = 'Y' THEN 1 ELSE '0' END FROM #tempCriteria where ValueField  = 'Exclusivity')

	BEGIN   /*-------Country--------------*/ 
		CREATE TABLE #CountryCode
		(
			CountryCode INT
		)
		
		DECLARE @CountryCodes NVARCHAR(MAX)
		SET @CountryCodes =  (SELECT TextField FROM #tempCriteria where ValueField  = 'Country')

		INSERT INTO #CountryCode
		select number from dbo.fn_Split_withdelemiter(''+@CountryCodes+'',',') where number <> ','
	END

	BEGIN /*-------Media Platforms & Mode of Exploitations--------------*/ 
		CREATE TABLE #MediaPlatforms(MediaPlatforms NVARCHAR(MAX))
		CREATE TABLE #ModeOfExploitations(ModeOfExploitations NVARCHAR(MAX))
		CREATE TABLE #PlatformCodes(PlatformCodes INT)

		DECLARE @MediaPlatforms NVARCHAR(MAX)
		SET @MediaPlatforms =  (Select TextField FROM #tempCriteria where ValueField = 'Media Platform')

		INSERT INTO #MediaPlatforms
		select number from dbo.fn_Split_withdelemiter(''+@MediaPlatforms+'',',') where number <> ','
	
		
		DECLARE @ModeOfExploitations NVARCHAR(MAX)
		SET @ModeOfExploitations =  (Select TextField FROM #tempCriteria where ValueField = 'Mode of Exploitation')

		INSERT INTO #ModeOfExploitations
		select number from dbo.fn_Split_withdelemiter(''+@ModeOfExploitations+'',',') where number <> ','

		INSERT INTO #PlatformCodes
		Select Platform_Code FROM Platform where Platform_Hiearachy COLLATE DATABASE_DEFAULT IN (
			Select MediaPlatforms + ' -- '+ ModeOfExploitations AS PlatformHierarchy
			FROM #MediaPlatforms
			CROSS JOIN #ModeOfExploitations
		)
	END

	BEGIN /*-------License Period--------------*/ 
		DECLARE @StartDate NVARCHAR(20),@EndDate NVARCHAR(20)
		SET @StartDate = (Select TextField FROM #tempCriteria where ValueField = 'Start Date' )
		SET @EndDate = (Select TextField FROM #tempCriteria where ValueField = 'End Date' )
		PRINT @StartDate
		PRINT @EndDate
	END
	
	BEGIN /*-------Vendor/Licensor--------------*/ 
		CREATE TABLE #Vendor
		(
			VendorCode INT
		)
		
		DECLARE @VendorCodes NVARCHAR(MAX)
		SET @VendorCodes =  (SELECT top 1 TextField FROM #tempCriteria where ValueField  = 'Licensor')

		INSERT INTO #Vendor
		select number from dbo.fn_Split_withdelemiter(''+@VendorCodes+'',',') where number <> ','
	END

	BEGIN /*-------Star cast--------------*/ 
		CREATE TABLE #Talent
		(
			TalentCode INT
		)
		
		DECLARE @TalentCodes NVARCHAR(MAX)
		SET @TalentCodes =  (SELECT top 1 TextField FROM #tempCriteria where ValueField  = 'Star Cast')

		INSERT INTO #Talent
		select number from dbo.fn_Split_withdelemiter(''+@TalentCodes+'',',') where number <> ','
	END

	BEGIN   /*-------Title Language--------------*/ 
		CREATE TABLE #TitleLanguage
		(
			LanguageCode INT
		)
		
		DECLARE @TitleLanguageCodes NVARCHAR(MAX)
		SET @TitleLanguageCodes =  (SELECT TextField FROM #tempCriteria where ValueField  = 'Title Language')

		INSERT INTO #TitleLanguage
		select number from dbo.fn_Split_withdelemiter(''+@TitleLanguageCodes+'',',') where number <> ','
	END

	BEGIN   /*-------Subtitling Language--------------*/ 
		CREATE TABLE #SubtitlingLanguageCodes
		(
			LanguageCode INT
		)
		
		DECLARE @SubtitlingLanguageCodes NVARCHAR(MAX)
		SET @SubtitlingLanguageCodes =  (SELECT TextField FROM #tempCriteria where ValueField  = 'Subtitling Language')

		INSERT INTO #SubtitlingLanguageCodes
		select number from dbo.fn_Split_withdelemiter(''+@SubtitlingLanguageCodes+'',',') where number <> ','
	END

	BEGIN   /*-------Dubbing Language--------------*/ 
		CREATE TABLE #DubbingLanguageCodes
		(
			LanguageCode INT
		)
		
		DECLARE @DubbingLanguageCodes NVARCHAR(MAX)
		SET @DubbingLanguageCodes =  (SELECT TextField FROM #tempCriteria where ValueField  = 'Dubbing Language')

		INSERT INTO #DubbingLanguageCodes
		select number from dbo.fn_Split_withdelemiter(''+@DubbingLanguageCodes+'',',') where number <> ','
	END
		
		SELECT DISTINCT atd.Title_Code,t.Title_Name,ISNULL(l.Language_Name,'') AS TitleLanguage,ISNULL(g.Genres_Name,'NA') AS Genre,'StarCast' AS StarCast,ISNULL(CAST(t.Year_Of_Production AS nvarchar),'NA') AS YOR
		FROM Avail_Title_Data atd
		INNER JOIN RightsU_16Mar..Acq_Deal ad ON ad.Acq_Deal_Code = atd.Acq_Deal_Code
		INNER JOIN RightsU_16Mar..Title t ON t.Title_Code = atd.Title_Code
		INNER JOIN RightsU_16Mar..Language l on l.Language_Code = t.Title_Language_Code
		LEFT JOIN RightsU_16Mar..Title_Geners tg on tg.Title_Code = atd.Title_Code
		LEFT JOIN RightsU_16Mar..Genres g on g.Genres_Code = tg.Genres_Code
		--INNER JOIN Title_Talent tt ON tt.Title_Code = t.Title_Code
		INNER JOIN #PlatformCodes p ON p.PlatformCodes = atd.Avail_Platform_Code
		INNER JOIN #CountryCode c ON c.CountryCode = atd.Avail_Country_Code
		WHERE atd.Is_Exclusive = @Exclusivity 
		--AND (atd.Avail_Subtitling_Code IN (Select * FROM #SubtitlingLanguageCodes) OR @SubtitlingLanguageCodes = '')
		--AND (atd.Avail_Dubbing_Code IN (Select * from #DubbingLanguageCodes) OR @DubbingLanguageCodes = '')
		--AND (AD.Vendor_Code IN (Select * FROM #Vendor) OR @VendorCodes = '')
		--AND (tt.Talent_Code IN (Select * FROM #Talent) OR @TalentCodes = '')
		--AND (atd.Title_Code IN (select number from dbo.fn_Split_withdelemiter(''+@TitleCode+'',',')) OR @TitleCode = '')

		--Select * INTO ##tempGlobal FROM @UDT 

		IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
		IF OBJECT_ID('tempdb..#CountryCode') IS NOT NULL DROP TABLE #CountryCode
		IF OBJECT_ID('tempdb..#MediaPlatforms') IS NOT NULL DROP TABLE #MediaPlatforms
		IF OBJECT_ID('tempdb..#ModeOfExploitations') IS NOT NULL DROP TABLE #ModeOfExploitations
		IF OBJECT_ID('tempdb..#PlatformCodes') IS NOT NULL DROP TABLE #PlatformCodes
		IF OBJECT_ID('tempdb..#Vendor') IS NOT NULL DROP TABLE #Vendor
		IF OBJECT_ID('tempdb..#Talent') IS NOT NULL DROP TABLE #Talent
		IF OBJECT_ID('tempdb..#TitleLanguage') IS NOT NULL DROP TABLE #TitleLanguage
		IF OBJECT_ID('tempdb..#SubtitlingLanguageCodes') IS NOT NULL DROP TABLE #SubtitlingLanguageCodes
		IF OBJECT_ID('tempdb..#DubbingLanguageCodes') IS NOT NULL DROP TABLE #DubbingLanguageCodes
		IF OBJECT_ID('tempdb..##tempGlobal') IS NOT NULL DROP TABLE ##tempGlobal
		
END




--DECLARE
--@UDT TitleCriteria

--INSERT INTO @UDT VALUES('Country','1,2,3')
--INSERT INTO @UDT VALUES('Media Platforms','Cable-HITS,IPTV')
--INSERT INTO @UDT VALUES('Mode of Exploitations','Free,NVOD,Pay' )
--INSERT INTO @UDT VALUES('PeriodType','Min')
--INSERT INTO @UDT VALUES('Start Date','12Jan2020')
--INSERT INTO @UDT VALUES('End Date','12Jan2021')
--INSERT INTO @UDT VALUES('Exclusivity','Y')
--INSERT INTO @UDT VALUES('Title Language',',1,2,3,4')
--INSERT INTO @UDT VALUES('Subtitling Language','')
--INSERT INTO @UDT VALUES('Dubbing Language','')
--INSERT INTO @UDT VALUES('Licensor','1,2,3,4')
--INSERT INTO @UDT VALUES('Star Cast','')

----Select * FROM @UDT
--EXEC USPITGetAvailTitle @UDT



