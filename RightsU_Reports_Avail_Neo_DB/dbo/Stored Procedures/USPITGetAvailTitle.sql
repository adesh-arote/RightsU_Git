


CREATE PROCEDURE [dbo].[USPITGetAvailTitle]
(
	@UDT TitleCriteria READONLY,
	@IsDDL VARCHAR(2)
)
AS
BEGIN
/*----------------------------------------
Author: Rahul Kembhavi
Created On : 05/Feb/2020
Description: Used to get Avail titles & for title grid
-----------------------------------------*/
	--DECLARE
	--@IsDDL CHAR(2) = 'N',
	--@UDT TitleCriteria --READONLYINSERT INTO @UDT VALUES('Country','')
	--INSERT INTO @UDT VALUES('Territory','')
	--insert into @udt values('country','')
	--INSERT INTO @UDT VALUES('Platform','')
	----INSERT INTO @UDT VALUES('Mode of Exploitation','Everywhere TV,Free,Pay,Premium Pay' )
	--INSERT INTO @UDT VALUES('PeriodType','')
	--INSERT INTO @UDT VALUES('Start Date','')
	--INSERT INTO @UDT VALUES('End Date','')
	--INSERT INTO @UDT VALUES('Exclusivity','')
	--INSERT INTO @UDT VALUES('Title Language','')
	--INSERT INTO @UDT VALUES('Subtitling Language','')
	--INSERT INTO @UDT VALUES('Dubbing Language','')
	--INSERT INTO @UDT VALUES('Subtitling Language Group','')
	--INSERT INTO @UDT VALUES('Dubbing Language Group','')
	--INSERT INTO @UDT VALUES('TitleCode','')
	--INSERT INTO @UDT VALUES('Language Type','')
	--INSERT INTO @UDT VALUES('BVCode','19')
	--INSERT INTO @UDT VALUES('Star Cast','')
	--INSERT INTO @UDT VALUES('Licensor','') --8

	BEGIN /*---------Temp Tables-------------------*/
	
		IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
		IF OBJECT_ID('tempdb..#Languages_Avail') IS NOT NULL DROP TABLE #Languages_Avail
		IF OBJECT_ID('tempdb..#Platform_Avail') IS NOT NULL DROP TABLE #Platform_Avail
		IF OBJECT_ID('tempdb..#Country_Avail') IS NOT NULL DROP TABLE #Country_Avail
		IF OBJECT_ID('tempdb..#Sub_Language_Search') IS NOT NULL DROP TABLE #Sub_Language_Search
		IF OBJECT_ID('tempdb..#Dub_Language_Search') IS NOT NULL DROP TABLE #Dub_Language_Search
		IF OBJECT_ID('tempdb..#Country_Search') IS NOT NULL DROP TABLE #Country_Search
		IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
		IF OBJECT_ID('tempdb..#Avail_Dates') IS NOT NULL DROP TABLE #Avail_Dates
		IF OBJECT_ID('tempdb..#Vendor') IS NOT NULL DROP TABLE #Vendor
		IF OBJECT_ID('tempdb..#Talent') IS NOT NULL DROP TABLE #Talent
		IF OBJECT_ID('tempdb..#TitleLanguage') IS NOT NULL DROP TABLE #TitleLanguage
		IF OBJECT_ID('tempdb..#TitleCodes') IS NOT NULL DROP TABLE #TitleCodes


		CREATE TABLE #tempCriteria(
			ValueField NVARCHAR(MAX),
			TextField NVARCHAR(MAX)
		)
	
		CREATE TABLE #Country_Search(
			Country_Code INT
		)

		Create Table #Country_Avail(
			Avail_Country_Code NUMERIC(38, 0)
		)

		Create Table #Platform_Avail(
			Avail_Platform_Code NUMERIC(38, 0)
		)

		CREATE TABLE #Platform_Search(
			Platform_Code INT
		)

		CREATE TABLE #Avail_Dates(
			Avail_Dates_Code INT,
			Start_Date DATE,
			END_Date DATE
		)

		CREATE TABLE #Dub_Language_Search(
			Language_Code INT
		)

		CREATE TABLE #Sub_Language_Search(
			Language_Code INT
		)

		Create Table #Languages_Avail(
			Avail_Languages_Code NUMERIC(38,0),
			Lang_Type CHAR(1),
		)

	END

	/*----------------------------------------*/
	INSERT INTO #tempCriteria
	SELECT * FROM @UDT

	

	
	--SELECT @Exclusivity

	
	DECLARE @IsCountryFilter CHAR(1) = 'Y'

	-----------------Variables Declartion-------------
	DECLARE @Country_Codes NVARCHAR(MAX), @Territory_Codes NVARCHAR(MAX),@Media_Platform NVARCHAR(MAX), @Mode_Of_Exploitation NVARCHAR(MAX),
	@StartDate DATE,@ENDDate DATE,@Dubbing_Codes NVARCHAR(MAX), @Dubbing_Group_Codes NVARCHAR(MAX), @Language_Code NVARCHAR(MAX),
	@Subtitle_Codes NVARCHAR(MAX),@Subtitle_Group_Codes NVARCHAR(MAX),@LanguageCodes NVARCHAR(MAX),@VendorCodes NVARCHAR(MAX),@TalentCodes NVARCHAR(MAX),
	@Exclusivity VARCHAR(1), @BVCode INT,
	@TitleCodes NVARCHAR(MAX),@Deal_Type_Code NVARCHAR(MAX),@Platform NVARCHAR(MAX)


	SET @Country_Codes =  (SELECT top 1 TextField FROM #tempCriteria WHERE ValueField  = 'Country')
	SET @Territory_Codes = (SELECT top 1 ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'Territory')
	SET @Media_Platform =  (SELECT top 1 TextField FROM #tempCriteria WHERE ValueField = 'Media Platform')
	SET @Mode_Of_Exploitation =  (SELECT top 1 TextField FROM #tempCriteria WHERE ValueField = 'Mode of Exploitation')
	SET @StartDate  = (SELECT top 1 CAST(TextField AS DATE) FROM #tempCriteria WHERE ValueField = 'Start Date')
	SET @ENDDate = (SELECT top 1  CAST(TextField AS DATE) FROM #tempCriteria WHERE ValueField = 'End Date')
	SET @Dubbing_Codes =  (SELECT top 1 TextField FROM #tempCriteria WHERE ValueField  = 'Dubbing Language')
	SET @Subtitle_Codes =  (SELECT top 1 TextField FROM #tempCriteria WHERE ValueField  = 'Subtitling Language')
	SET @LanguageCodes = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'Title Language')
	SET @Subtitle_Group_Codes = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'Subtitling Language Group')
	SET @Dubbing_Group_Codes = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'Dubbing Language Group')
	SET @VendorCodes = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'Licensor')
	SET @TalentCodes =  (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'Star Cast')
	SET @TitleCodes = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'TitleCode')
	SET @BVCode = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'BVCode')
	SET @Platform = (SELECT TextField FROM #tempCriteria WHERE ValueField = 'Platform')
	
	IF(@BVCode = 19)
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Movie_IT' )
		END
	ELSE IF(@BVCode = 20)
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Prog_IT' )
		END
	ELSE
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Web_IT' )
		END


	SELECT @Exclusivity =  CASE WHEN TextField = 'Y' THEN 1 ELSE 0 END 
	FROM #tempCriteria WHERE ValueField  = 'Exclusivity'
	
	IF(@Exclusivity = 'Y')
		SET @Exclusivity = 'E'
	ELSE IF(@Exclusivity = 'N')
		SET @Exclusivity = 'N'
	ELSE
		SET @Exclusivity = 'B'

	DECLARE @EX_YES BIT = 2, @EX_NO BIT = 2
	IF(UPPER(@Exclusivity) = 'E')
		SET @EX_YES = 1
	ELSE IF(UPPER(@Exclusivity) = 'N')
		SET @EX_NO = 0
	ELSE IF(UPPER(@Exclusivity) = 'B')
	BEGIN
		SET @EX_YES = 1
		SET @EX_NO = 0
	END

	BEGIN ---------- COUNTRY FILTER PROCESSING

		INSERT INTO #Country_Search(Country_Code)
		SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Country_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

		INSERT INTO #Country_Search(Country_Code)
		SELECT DISTINCT Country_Code FROM Territory_Details WHERE Territory_Code IN (
			SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Territory_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
		)
		
		IF NOT EXISTS(SELECT TOP 1 * FROM #Country_Search)
		BEGIN

			SET @IsCountryFilter = 'N'

			INSERT INTO #Country_Avail
			SELECT Avail_Country_Code FROM Avail_Countries
		
		END
		ELSE
		BEGIN
		
			DECLARE @Country_Code VARCHAR(10) = ''
			DECLARE Cur_Country CURSOR FOR SELECT Country_Code FROM #Country_Search ORDER BY CAST(Country_Code AS VARCHAR(10)) ASC
			OPEN Cur_Country
			FETCH NEXT FROM Cur_Country INTO @Country_Code
			WHILE (@@FETCH_STATUS = 0)
			BEGIN

				INSERT INTO #Country_Avail(Avail_Country_Code)
				SELECT Avail_Country_Code FROM Avail_Countries 
				WHERE Country_Codes Like '%,' + @Country_Code + ',%' AND Avail_Country_Code NOT IN (
					SELECT Avail_Country_Code FROM #Country_Avail
				)

				FETCH NEXT FROM Cur_Country INTO @Country_Code	
			END
			CLOSE Cur_Country
			DEALLOCATE Cur_Country
		
		END

	END
	
	BEGIN ---------- PLATFORM PROCESSING

		BEGIN

			DECLARE @tempPlatform AS TABLE 
			(
				Platform_Code INT
			)

			INSERT INTO @tempPlatform(Platform_Code)
			SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@Platform,''), ',') 

			--INSERT INTO #Platform_Search(Platform_Code)
			--SELECT tp.Platform_Code
			--FROM Platform p
			--INNER JOIN @tempPlatform tp ON tp.Platform_Code = p.Platform_Code
			--WHERE p.Parent_Platform_Code NOT IN ( SELECT Platform_Code FROM @tempPlatform ) OR ISNULL(p.Parent_Platform_Code,0) = 0			
			DELETE FROM @tempPlatform WHERE Platform_Code = 0

			IF NOT EXISTS(SELECT TOP 1 * FROM @tempPlatform)
			BEGIN

				INSERT INTO #Platform_Avail(Avail_Platform_Code)
				SELECT Avail_Platform_Code FROM Avail_Platforms 
		
			END
			ELSE
			BEGIN
				DECLARE @Platform_Code VARCHAR(10) = ''
				DECLARE Cur_Platform CURSOR FOR SELECT Platform_Code FROM @tempPlatform ORDER BY CAST(Platform_Code AS VARCHAR(10)) ASC
				OPEN Cur_Platform
				FETCH NEXT FROM Cur_Platform INTO @Platform_Code
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
			
					INSERT INTO #Platform_Avail(Avail_Platform_Code)
					SELECT Avail_Platform_Code FROM Avail_Platforms 
					WHERE Platform_Codes Like '%,' + @Platform_Code + ',%' AND Avail_Platform_Code NOT IN (
						SELECT Avail_Platform_Code FROM #Platform_Avail
					)

					FETCH NEXT FROM Cur_Platform INTO @Platform_Code
				END
				CLOSE Cur_Platform
				DEALLOCATE Cur_Platform
			END
		END
	END

	BEGIN ---------- DATE PROCESSING
		DECLARE @Date_Type VARCHAR(2) = 'FL'
		
		IF(@StartDate < '01JAN2010' AND  @ENDDate < '01JAN2010')
		BEGIN

			INSERT INTO #Avail_Dates(Avail_Dates_Code, Start_Date, END_Date)
			SELECT Avail_Dates_Code, Start_Date, END_Date FROM Avail_Dates 

		END
		ELSE
		BEGIN

			IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
			BEGIN
			
				INSERT INTO #Avail_Dates(Avail_Dates_Code, Start_Date, END_Date)
				SELECT Avail_Dates_Code, Start_Date, END_Date FROM Avail_Dates 
				WHERE (ISNULL(Start_Date, '9999-12-31') <= @StartDate AND ISNULL(END_Date, '9999-12-31') >= @ENDDate)
		
			END
			ELSE
			BEGIN
			
				INSERT INTO #Avail_Dates(Avail_Dates_Code, Start_Date, END_Date)
				SELECT Avail_Dates_Code, Start_Date, END_Date FROM Avail_Dates
				WHERE (
					(ISNULL(Start_Date, '9999-12-31') BETWEEN @StartDate AND  @ENDDate)
					OR (ISNULL(END_Date, '9999-12-31') BETWEEN @StartDate AND @ENDDate)
					OR (@StartDate BETWEEN  ISNULL(Start_Date, '9999-12-31') AND ISNULL(END_Date, '9999-12-31'))
					OR (@ENDDate BETWEEN ISNULL(Start_Date, '9999-12-31') AND ISNULL(END_Date, '9999-12-31'))
				)

			END

		END

	END
	
	BEGIN ---------- DUBBING LNAGUAGE FILTER PROCESSING
		
		DECLARE @IsDubbingFilter CHAR(1) = 'Y'
	
	

		INSERT INTO #Dub_Language_Search(Language_Code)
		SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Dubbing_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

		INSERT INTO #Dub_Language_Search(Language_Code)
		SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN (
			SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Dubbing_Group_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
		)
		--SELECT TOP 1 * FROM #Dub_Language_Search
		IF NOT EXISTS(SELECT TOP 1 * FROM #Dub_Language_Search)
		BEGIN
			SET @IsDubbingFilter  = 'N'
			--INSERT INTO #Languages_Avail
			--SELECT Avail_Languages_Code, 'D' FROM Avail_Languages

		END
		ELSE
		BEGIN

			SET @Language_Code = ''
			DECLARE Cur_Dub_Language CURSOR FOR SELECT Language_Code FROM #Dub_Language_Search ORDER BY CAST(Language_Code AS VARCHAR(10)) ASC
			OPEN Cur_Dub_Language
			FETCH NEXT FROM Cur_Dub_Language INTO @Language_Code
			WHILE (@@FETCH_STATUS = 0)
			BEGIN

				INSERT INTO #Languages_Avail(Avail_Languages_Code, Lang_Type)
				SELECT Avail_Languages_Code, 'D' FROM Avail_Languages 
				WHERE Language_Codes Like '%,' + @Language_Code + ',%' AND Avail_Languages_Code NOT IN (
					SELECT Avail_Languages_Code FROM #Languages_Avail
				)

				FETCH NEXT FROM Cur_Dub_Language INTO @Language_Code	
			END
			CLOSE Cur_Dub_Language
			DEALLOCATE Cur_Dub_Language

		END
	END
	
	BEGIN ---------- SUBTITLE LNAGUAGE FILTER PROCESSING
		
		DECLARE @IsSubtitlingFilter CHAR(1) = 'Y'

		INSERT INTO #Sub_Language_Search(Language_Code)
		SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Subtitle_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

		INSERT INTO #Sub_Language_Search(Language_Code)
		SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN (
			SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Subtitle_Group_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
		)
	
		IF NOT EXISTS(SELECT TOP 1 * FROM #Sub_Language_Search)
		BEGIN
			
			SET @IsSubtitlingFilter = 'N'
			--INSERT INTO #Languages_Avail
			--SELECT Avail_Languages_Code, 'S' FROM Avail_Languages

		END
		ELSE
		BEGIN

			DECLARE Cur_Sub_Language CURSOR FOR SELECT Language_Code FROM #Sub_Language_Search ORDER BY CAST(Language_Code AS VARCHAR(10)) ASC
			OPEN Cur_Sub_Language
			FETCH NEXT FROM Cur_Sub_Language INTO @Language_Code
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
			
				INSERT INTO #Languages_Avail(Avail_Languages_Code, Lang_Type)
				SELECT Avail_Languages_Code, 'S' FROM Avail_Languages 
				WHERE Language_Codes Like '%,' + @Language_Code + ',%' AND Avail_Languages_Code NOT IN (
					SELECT Avail_Languages_Code FROM #Languages_Avail WHERE Lang_Type = 'S'
				)

				FETCH NEXT FROM Cur_Sub_Language INTO @Language_Code	
			END
			CLOSE Cur_Sub_Language
			DEALLOCATE Cur_Sub_Language

		END

	END
	
	BEGIN /*-------TITLE LANGUAGE--------------*/

		CREATE TABLE #TitleLanguage
		(
			Language_Code INT
		)
		
		INSERT INTO #TitleLanguage
		SELECT Number FROM dbo.fn_Split_withdelemiter(ISNULL(@LanguageCodes,''), ',') WHERE ISNULL(Number, '') NOT IN ('', '0')

		DECLARE @IsTitleLanguageFilter CHAR(1) = 'Y'
		IF NOT EXISTS(SELECT TOP 1 * FROM #TitleLanguage)
		BEGIN
			
			SET @IsTitleLanguageFilter = 'N'

		END

	END
	
	BEGIN /*-------Vendor/Licensor--------------*/

		CREATE TABLE #Vendor
		(
			VendorCode INT
		)
		
		INSERT INTO #Vendor
		SELECT Number FROM dbo.fn_Split_withdelemiter(ISNULL(@VendorCodes,''), ',') WHERE ISNULL(Number, '') NOT IN ('', '0')
		
		DECLARE @IsVendorFilter CHAR(1) = 'Y'
		IF NOT EXISTS(SELECT TOP 1 * FROM #Vendor)
		BEGIN
			
			SET @IsVendorFilter = 'N'

		END

	END

	BEGIN /*-------Star cast--------------*/

		CREATE TABLE #Talent
		(
			Title_Code INT
		)

		INSERT INTO #Talent(Title_Code)
		SELECT Title_Code FROM Title_Talent WHERE Talent_Code IN (
			SELECT Number FROM dbo.fn_Split_withdelemiter(ISNULL(@TalentCodes,''), ',') WHERE ISNULL(Number, '') NOT IN ('', '0')
		)
		
		DECLARE @IsTalentFilter CHAR(1) = 'Y'
		IF NOT EXISTS(SELECT TOP 1 * FROM #Talent)
		BEGIN
			
			SET @IsTalentFilter = 'N'

		END

	END
	
	IF(@IsDDL = 'Y')
	BEGIN

		SELECT DISTINCT atd.Title_Code, t.Title_Name, '' AS Title_Language, '' AS Genre, '' AS StarCast, '' AS ReleaseYear
		FROM Avail_Title_Data atd
		INNER JOIN Acq_Deal_Rights adr ON atd.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
		INNER JOIN Title t ON t.Title_Code = atd.Title_Code
		WHERE 
		atd.Avail_Country_Code IN (
			SELECT Avail_Country_Code FROM #Country_Avail
		) AND 
		(atd.Avail_Platform_Code IN (
			SELECT Avail_Platform_Code FROM #Platform_Avail
		) OR @Platform = '') AND 
		atd.Avail_Dates_Code IN (
			SELECT Avail_Dates_Code FROM #Avail_Dates
		) AND 
		atd.IS_Exclusive IN(@EX_YES, @EX_NO)
		AND 
		(
			t.Title_Language_Code IN (
				SELECT Language_Code FROM #TitleLanguage
			) OR @IsTitleLanguageFilter = 'N'
		)
		AND (
			atd.Avail_Dubbing_Code IN (
				SELECT Avail_Languages_Code FROM #Languages_Avail WHERE Lang_Type = 'D'
			) OR @IsDubbingFilter = 'N'
		)
		AND (
			atd.Avail_Subtitling_Code IN (
				SELECT Avail_Languages_Code FROM #Languages_Avail WHERE Lang_Type = 'S'
			) OR @IsSubtitlingFilter = 'N'
		)
		AND (
			ad.Vendor_Code IN (
				SELECT VendorCode FROM #Vendor
			) OR @IsVendorFilter = 'N'
		)
		AND (
			atd.Title_Code IN (
				SELECT Title_Code FROM #Talent
			) OR @IsTalentFilter = 'N'
		)

	END
	ELSE
	BEGIN
	
		BEGIN /*-------Star cast--------------*/

			CREATE TABLE #TitleCodes
			(
				Title_Code INT
			)
		
			

			INSERT INTO #TitleCodes(Title_Code)
			SELECT Number FROM dbo.fn_Split_withdelemiter(ISNULL(@TitleCodes,''), ',') WHERE ISNULL(Number, '') NOT IN ('', '0')
		
			DECLARE @IsTitleFilter CHAR(1) = 'Y'
			IF NOT EXISTS(SELECT TOP 1 * FROM #TitleCodes)
			BEGIN
			
				SET @IsTitleFilter = 'N'

			END

		END

		--Select * FROM Avail_Title_Data

		SELECT Title_Code, Title_Name, Language_Name AS Title_Language, 
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Genres_Name AS NVARCHAR(MAX)) FROM Title_Geners TG
			INNER JOIN Genres Tal ON tal.Genres_Code = TG.Genres_Code
			WHERE TG.Title_Code = TitleOutput.Title_Code
			FOR XML PATH(''), ROOT('Genres'), TYPE
		).value('/Genres[1]','NVARCHAR(max)'), 1, 2, '')),'')  AS Genre, 
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Talent_Name AS NVARCHAR(MAX)) FROM Title_Talent TT
			INNER JOIN Talent Tal on tal.talent_Code = TT.Talent_code
			WHERE TT.Title_Code = TitleOutput.Title_Code AND TT.Role_Code in (2)
			FOR XML PATH(''), ROOT('StarCast'), TYPE
		).value('/StarCast[1]','NVARCHAR(max)'), 1, 2, '')),'') AS StarCast, 
		Year_Of_Production AS ReleaseYear
		FROM (
			SELECT DISTINCT atd.Title_Code, t.Title_Name, t.Year_Of_Production, lg.Language_Name
			FROM Avail_Title_Data atd
			INNER JOIN Acq_Deal_Rights adr ON atd.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
			--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = atd.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
			INNER JOIN Title t ON t.Title_Code = atd.Title_Code
			INNER JOIN Language lg ON t.Title_Language_Code = lg.Language_Code
			WHERE 
			atd.Avail_Country_Code IN (
				SELECT Avail_Country_Code FROM #Country_Avail
			)
			AND atd.Avail_Platform_Code IN (
				SELECT Avail_Platform_Code FROM #Platform_Avail
			)
			--AND atd.Avail_Dates_Code IN (
			--	SELECT Avail_Dates_Code FROM #Avail_Dates
			--)
			--AND atd.IS_Exclusive IN(@EX_YES, @EX_NO) 
			--AND (
			--	t.Title_Language_Code IN (
			--		SELECT Language_Code FROM #TitleLanguage
			--	) OR @IsTitleLanguageFilter = 'N'
			--)
			--AND (
			--	atd.Avail_Dubbing_Code IN (
			--		SELECT Avail_Languages_Code FROM #Languages_Avail WHERE Lang_Type = 'D'
			--	) OR @IsDubbingFilter = 'N'
			--)
			--AND (
			--	atd.Avail_Subtitling_Code IN (
			--		SELECT Avail_Languages_Code FROM #Languages_Avail WHERE Lang_Type = 'S'
			--	) OR @IsSubtitlingFilter = 'N'
			--)
			--AND (
			--	ad.Vendor_Code IN (
			--		SELECT VendorCode FROM #Vendor
			--	) OR @IsVendorFilter = 'N'
			--)
			--AND (
			--	atd.Title_Code IN (
			--		SELECT Title_Code FROM #Talent
			--	) OR @IsTalentFilter = 'N'
			--)
			--AND (
			--	atd.Title_Code IN (
			--		SELECT Title_Code FROM #TitleCodes
			--	) OR @IsTitleFilter = 'N'
			--)
		) AS TitleOutput

	END
	
	IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
	IF OBJECT_ID('tempdb..#Languages_Avail') IS NOT NULL DROP TABLE #Languages_Avail
	IF OBJECT_ID('tempdb..#Platform_Avail') IS NOT NULL DROP TABLE #Platform_Avail
	IF OBJECT_ID('tempdb..#Country_Avail') IS NOT NULL DROP TABLE #Country_Avail
	IF OBJECT_ID('tempdb..#Sub_Language_Search') IS NOT NULL DROP TABLE #Sub_Language_Search
	IF OBJECT_ID('tempdb..#Dub_Language_Search') IS NOT NULL DROP TABLE #Dub_Language_Search
	IF OBJECT_ID('tempdb..#Country_Search') IS NOT NULL DROP TABLE #Country_Search
	IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
	IF OBJECT_ID('tempdb..#Avail_Dates') IS NOT NULL DROP TABLE #Avail_Dates
	IF OBJECT_ID('tempdb..#Vendor') IS NOT NULL DROP TABLE #Vendor
	IF OBJECT_ID('tempdb..#Talent') IS NOT NULL DROP TABLE #Talent
	IF OBJECT_ID('tempdb..#TitleLanguage') IS NOT NULL DROP TABLE #TitleLanguage
	IF OBJECT_ID('tempdb..#TitleCodes') IS NOT NULL DROP TABLE #TitleCodes

END
