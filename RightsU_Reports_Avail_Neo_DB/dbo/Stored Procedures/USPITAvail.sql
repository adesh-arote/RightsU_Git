CREATE PROCEDURE [dbo].[USPITAvail]
(
	@UDT TitleCriteria READONLY	
)
AS
BEGIN

	--declare
	--@udt titlecriteria
	--insert into @udt values('country','1,2,3,4,5,6,8,10,12,13,14,15,16,17,18,19,20,22,23,24,26,27,28,30,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,47,48,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,87,88,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,188,189,190,191,192,193,195,196,197,198,199,200,201,202,204,205,206,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,255,256,257,258,260,261,262,264,265,266,267,268,269,270,271,272,273,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,293,294,295,296,299,300,301,302,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,345,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361')
	--insert into @udt values('territory','')
	----insert into @udt values('media platform','cable-hits,dth-smatv-mmds,iptv,ott transmission,analog terrestrial,digital terrestrial')
	----insert into @udt values('mode of exploitation','avod,channel in loop,est-dto,everywhere tv,free,fvod,linear channel in loop,nvod,pay,ppv,premium pay,push svod,svod,tvod-dtr' )
	----insert into @udt values('media platform','cable-hits,dth-smatv-mmds')
	----insert into @udt values('mode of exploitation','ppv,push svod')
	
	--insert into @udt values('platform','1,35,58,59,60,258,61,62,259,63,64,65,66,67,69,70,71,72,73,74,262,263,75,76,144,145,146,265,78,79,147,152,154,36,37,38,256,39,40,257,41,42,43,44,45,47,48,49,50,51,52,260,261,53,54,148,149,150,264,56,57,151,155,157,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,290,291,292,293,288,289,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,321,322,323,324,319,320,325,326,327') 
	--insert into @udt values('periodtype','fl')
	--insert into @udt values('start date','7-Apr-2021')
	--insert into @udt values('end date','14-apr-2021')
	--insert into @udt values('exclusivity','"both"')
	--insert into @udt values('Title Language','1')--1
	--insert into @udt values('Subtitling Language','24')--25
	--insert into @udt values('dubbing language','135')
	--insert into @udt values('subtitling language group','')
	--insert into @udt values('dubbing language group','')
	--insert into @udt values('availtitlecode','36463')--37449,37450
	--insert into @udt values('language type','TDS')
	----EXEC USPITAvail @UDT

	IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria

	CREATE TABLE #tempCriteria(
		ValueField NVARCHAR(MAX),
		TextField NVARCHAR(MAX)
	)

	BEGIN /*--------Data from UDT------------*/
		DECLARE 
		@Title_Code VARCHAR(MAX),
		@Date_Type VARCHAR(2),
		@StartDate VARCHAR(20),
		@EndDate VARCHAR(20),
		@Media_Platform VARCHAR(MAX),
		@Mode_Of_Exploitation VARCHAR(MAX),
		@Language_Type VARCHAR(5) = 'TSD',
		@Territory_Codes VARCHAR(max),
		@Country_Codes VARCHAR(MAX), 
		@Subtitle_Codes VARCHAR(MAX),
		@Subtitle_Group_Codes VARCHAR(MAX),
		@Dubbing_Codes VARCHAR(MAX),
		@Dubbing_Group_Codes VARCHAR(MAX),
		@Exclusivity VARCHAR(1),
		@Platform NVARCHAR(MAX)
	
		INSERT INTO #tempCriteria
		SELECT * FROM @UDT

		SET @Title_Code =  (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'AvailTitleCode')
		SET @Date_Type = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'DateType')
		SET @StartDate = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'Start Date')
		SET @EndDate = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'End Date')
		SET @Platform = (SELECT TextField FROM #tempCriteria WHERE ValueField = 'Platform')
		--SET @Media_Platform = (SELECT TextField FROM #tempCriteria WHERE ValueField = 'Media Platform')
		--SET @Mode_Of_Exploitation = (SELECT TextField FROM #tempCriteria WHERE ValueField = 'Mode of Exploitation')
		SET @Language_Type = (SELECT TextField FROM #tempCriteria WHERE ValueField = 'Language Type')
		SET @Territory_Codes  = (SELECT TextField FROM #tempCriteria WHERE ValueField  = 'Territory')
		SET @Country_Codes =   (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'Country')
		SET @Subtitle_Codes  = (SELECT TextField FROM #tempCriteria WHERE ValueField  = 'Subtitling Language')
		SET @Subtitle_Group_Codes = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'Subtitling Language Group')
		SET @Dubbing_Codes = (SELECT TextField FROM #tempCriteria WHERE ValueField  = 'Dubbing Language')
		SET @Dubbing_Group_Codes  = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'Dubbing Language Group')
		SET @Exclusivity  = (SELECT TextField FROM #tempCriteria WHERE ValueField  = 'Exclusivity')

		IF(ISNULL(@Subtitle_Group_Codes, '') IN ('', '0') AND ISNULL(@Subtitle_Codes, '') IN ('', '0'))
		BEGIN
			PRINT 'AD'
			SET @Subtitle_Group_Codes = 2
		END

		IF(ISNULL(@Dubbing_Group_Codes, '') IN ('', '0') AND ISNULL(@Dubbing_Codes, '') IN ('', '0'))
		BEGIN
			PRINT 'AD'
			SET @Dubbing_Group_Codes = 2
		END

		IF(@Language_Type IS NULL OR @Language_Type = '')
		BEGIN
			SET @Language_Type = 'T'
		END
		
		IF(@Exclusivity = 'Y')
			SET @Exclusivity = 'E'
		ELSE IF(@Exclusivity = 'N')
			SET @Exclusivity = 'N'
		ELSE
			SET @Exclusivity = 'B'
	END

	BEGIN ---------- DECLARE SECTION

		IF OBJECT_ID('tempdb..#Title_Avail') IS NOT NULL DROP TABLE #Title_Avail
		IF OBJECT_ID('tempdb..#Languages_Avail') IS NOT NULL DROP TABLE #Languages_Avail
		IF OBJECT_ID('tempdb..#tmpPlatform') IS NOT NULL DROP TABLE #tmpPlatform
		IF OBJECT_ID('tempdb..#Sub_Language_Search') IS NOT NULL DROP TABLE #Sub_Language_Search
		IF OBJECT_ID('tempdb..#Dub_Language_Search') IS NOT NULL DROP TABLE #Dub_Language_Search
		IF OBJECT_ID('tempdb..#Country_Search') IS NOT NULL DROP TABLE #Country_Search
		IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
		IF OBJECT_ID('tempdb..#Dates_Avail') IS NOT NULL DROP TABLE #Dates_Avail
		IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
		IF OBJECT_ID('tempdb..#TempOutputCnt') IS NOT NULL DROP TABLE #TempOutputCnt
		IF OBJECT_ID('tempdb..#TempOutputPlat') IS NOT NULL DROP TABLE #TempOutputPlat
		IF OBJECT_ID('tempdb..#TempOutputFinal') IS NOT NULL DROP TABLE #TempOutputFinal
		IF OBJECT_ID('tempdb..#tmpCountry') IS NOT NULL DROP TABLE #tmpCountry
		
		CREATE TABLE #Title_Avail(
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

		CREATE TABLE #Dates_Avail(
			Avail_Dates_Code INT,
			Start_Date DATE,
			End_Date DATE
		)
			
		Create Table #Languages_Avail(
			Avail_Languages_Code NUMERIC(38,0),
			Languages_Code VARCHAR(MAX),
			Languages_Name VARCHAR(MAx),
			Lang_Type CHAR(1),
		)
	
		CREATE TABLE #Sub_Language_Search(
			Language_Code INT
		)

		CREATE TABLE #Dub_Language_Search(
			Language_Code INT
		)

		CREATE TABLE #Country_Search(
			Country_Code INT
		)
	
		CREATE TABLE #Platform_Search(
			Platform_Code INT
		)
	
		Create Table #tmpPlatform(
			Avail_Platform_Code NUMERIC(38,0),
			Platform_Code INT
		)
		
		Create Table #tmpCountry(
			Avail_Country_Code NUMERIC(38,0),
			Country_Code INT
		)

		CREATE TABLE #TempOutput(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT,
			Episode_From INT, 
			Episode_To INT,
			Start_Date DATE,
			End_Date DATE,
			Is_Exclusive INT,
			Country_Code INT,
			Platform_Code INT,
			Language_Type CHAR(1),
			Language_Codes VARCHAR(MAX),
		)

		CREATE TABLE #TempOutputPlat(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT,
			Episode_From INT, 
			Episode_To INT,
			Start_Date DATE,
			End_Date DATE,
			Is_Exclusive INT,
			Platform_Code INT,
			Language_Type CHAR(1),
			Language_Codes VARCHAR(MAX),
			Country_Codes VARCHAR(MAX),
		)
	
		CREATE TABLE #TempOutputCnt(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT,
			Episode_From INT, 
			Episode_To INT,
			Start_Date DATE,
			End_Date DATE,
			Is_Exclusive INT,
			Language_Type CHAR(1),
			Language_Codes VARCHAR(MAX),
			Country_Codes VARCHAR(MAX),
			Platform_Codes VARCHAR(MAX),
		)
	
		CREATE TABLE #TempOutputFinal(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Title_Code INT,
			Episode_From INT, 
			Episode_To INT,
			Start_Date DATE,
			End_Date DATE,
			Is_Exclusive INT,
			Country_Codes VARCHAR(MAX),
			Platform_Codes VARCHAR(MAX),
			Is_TItle_Language INT,
			Subtitling_Language VARCHAR(MAX),
			Dubbing_Language VARCHAR(MAX),
		)

		DECLARE @EX_YES CHAR = 2, @EX_NO CHAR = 2
		IF(UPPER(@Exclusivity) = 'E')
		BEGIN
			SET @EX_YES = 1
		END
		ELSE IF(UPPER(@Exclusivity) = 'N')
		BEGIN
			SET @EX_NO = 0
		END
		ELSE IF(UPPER(@Exclusivity) = 'B')
		BEGIN
			SET @EX_YES = 1
			SET @EX_NO = 0
		END

		
	END

	
	BEGIN ---------- TITLE FILTER

		INSERT INTO #Title_Avail(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Avail_Dates_Code, Is_Exclusive, 
								 Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code)
		SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Avail_Dates_Code, Is_Exclusive, 
								 Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code
		FROM Avail_Title_Data WHERE Title_Code IN (
			SELECT Number COLLATE DATABASE_DEFAULT FROM DBO.fn_Split_withdelemiter(ISNULL(@Title_Code,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
		)

	END

	BEGIN ---------- DATE PROCESSING

		IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
		BEGIN

			INSERT INTO #Dates_Avail(Avail_Dates_Code, Start_Date, End_Date)
			SELECT ad.Avail_Dates_Code, Start_Date, End_Date 
			FROM Avail_Dates ad 
			INNER JOIN #Title_Avail ta ON ad.Avail_Dates_Code = ta.Avail_Dates_Code
			WHERE (ISNULL(Start_Date, '9999-12-31') <= @StartDate AND ISNULL(End_Date, '9999-12-31') >= @EndDate)
	
		END
		Else
		BEGIN
	
			INSERT INTO #Dates_Avail(Avail_Dates_Code, Start_Date, End_Date)
			SELECT ad.Avail_Dates_Code, Start_Date, End_Date 
			FROM Avail_Dates ad
			INNER JOIN #Title_Avail ta ON ad.Avail_Dates_Code = ta.Avail_Dates_Code
			WHERE (
				(ISNULL(Start_Date, '9999-12-31') BETWEEN @StartDate AND  @EndDate)
				OR (ISNULL(End_Date, '9999-12-31') BETWEEN @StartDate AND @EndDate)
				OR (@StartDate BETWEEN  ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
				OR (@EndDate BETWEEN ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
			)
		END

		UPDATE #Dates_Avail SET Start_Date = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE Start_Date < GETDATE()
		--UPDATE #Dates_Avail SET Start_Date = '01-Jun-2020' WHERE Start_Date < '01-Jun-2020'

	END

	BEGIN ---------- PLATFORM PROCESSING
		
		DECLARE @tempPlatform AS TABLE 
		(
			Platform_Code INT
		)

		DECLARE @tempParentPlatform AS TABLE
		(
			Parent_Platform_Code INT,
			Child_Count INT,
			Module_Position VARCHAR(MAX)
		)

		INSERT INTO @tempPlatform(Platform_Code)
		SELECT Number COLLATE DATABASE_DEFAULT FROM DBO.fn_Split_withdelemiter(ISNULL(@Platform,''), ',') 

		INSERT INTO @tempParentPlatform (Parent_Platform_Code, Module_Position)
		(SELECT p.Platform_Code, P.Module_Position FROM Platform p
		INNER JOIN @tempPlatform tp ON tp.Platform_Code = p.Platform_Code AND p.Is_Last_Level = 'N')
		
		--UPDATE @tempParentPlatform
		--SET Child_Count = ( SELECT COUNT(p.Platform_Code)
		--FROM @tempParentPlatform tpp
		--INNER JOIN Platform p ON p.Parent_Platform_Code = tpp.Parent_Platform_Code)
		

		DECLARE @Parent_Platform_Code VARCHAR(10) = ''
		DECLARE Cur_Platform CURSOR FOR SELECT Parent_Platform_Code FROM @tempParentPlatform 
		OPEN Cur_Platform
		FETCH NEXT FROM Cur_Platform INTO @Parent_Platform_Code
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			UPDATE @tempParentPlatform
			SET Child_Count = ( SELECT COUNT(Platform_Code) FROM Platform 
			WHERE Parent_Platform_Code = @Parent_Platform_Code) 
			WHERE Parent_Platform_Code = @Parent_Platform_Code
				
			FETCH NEXT FROM Cur_Platform INTO @Parent_Platform_Code	
		END
		CLOSE Cur_Platform
		DEALLOCATE Cur_Platform


		DECLARE @Platform_Code VARCHAR(10) = ''
		DECLARE Cur_Platform CURSOR FOR SELECT Platform_Code FROM @tempPlatform ORDER BY CAST(Platform_Code AS VARCHAR(10)) ASC
		OPEN Cur_Platform
		FETCH NEXT FROM Cur_Platform INTO @Platform_Code
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			INSERT INTO #tmpPlatform(Avail_Platform_Code, Platform_Code)
			SELECT DISTINCT ap.Avail_Platform_Code, @Platform_Code 
			FROM Avail_Platforms ap
			INNER JOIN (SELECT DISTINCT ta1.Avail_Platform_Code FROM #Title_Avail ta1) ta ON ap.Avail_Platform_Code = ta.Avail_Platform_Code
			WHERE Platform_Codes Like '%,' + @Platform_Code + ',%'
				
			FETCH NEXT FROM Cur_Platform INTO @Platform_Code	
		END
		CLOSE Cur_Platform
		DEALLOCATE Cur_Platform

	END

	BEGIN ---------- COUNTRY FILTER PROCESSING

		INSERT INTO #Country_Search(Country_Code)
		SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Country_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

		INSERT INTO #Country_Search(Country_Code)
		SELECT DISTINCT Country_Code FROM Territory_Details WHERE Territory_Code IN (
			SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Territory_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
		)
	
		DECLARE @Country_Code VARCHAR(10) = ''
		DECLARE Cur_Country CURSOR FOR SELECT Country_Code FROM #Country_Search ORDER BY CAST(Country_Code AS VARCHAR(10)) ASC
		OPEN Cur_Country
		FETCH NEXT FROM Cur_Country INTO @Country_Code
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
			INSERT INTO #tmpCountry(Avail_Country_Code, Country_Code)
			SELECT DISTINCT ac.Avail_Country_Code, @Country_Code 
			FROM Avail_Countries ac
			INNER JOIN (SELECT DISTINCT ta1.Avail_Country_Code FROM #Title_Avail ta1) ta ON ac.Avail_Country_Code = ta.Avail_Country_Code
			WHERE ac.Country_Codes Like '%,' + @Country_Code + ',%'
				
			FETCH NEXT FROM Cur_Country INTO @Country_Code	
		END
		CLOSE Cur_Country
		DEALLOCATE Cur_Country

	END

	BEGIN ---------- SUBTITLE LNAGUAGE FILTER PROCESSING

		IF(@Language_Type LIKE '%S%')
		BEGIN

			INSERT INTO #Sub_Language_Search(Language_Code)
			SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Subtitle_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

			INSERT INTO #Sub_Language_Search(Language_Code)
			SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN (
				SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Subtitle_Group_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
			)
			
			IF NOT EXISTS(SELECT TOP 1 * FROM #Sub_Language_Search)
			BEGIN

				INSERT INTO #Languages_Avail
				SELECT DISTINCT al.Avail_Languages_Code, Language_Codes, '', 'S' 
				FROM Avail_Languages al
				INNER JOIN #Title_Avail ta ON al.Avail_Languages_Code = ta.Avail_Subtitling_Code

			END
			ELSE
			BEGIN

				DECLARE @Language_Code VARCHAR(10) = ''
				DECLARE Cur_Sub_Language CURSOR FOR SELECT Language_Code FROM #Sub_Language_Search ORDER BY CAST(Language_Code AS VARCHAR(10)) ASC
				OPEN Cur_Sub_Language
				FETCH NEXT FROM Cur_Sub_Language INTO @Language_Code
				WHILE (@@FETCH_STATUS = 0)
				BEGIN

					MERGE INTO #Languages_Avail AS tmp
					USING (
						SELECT * FROM Avail_Languages al1
						WHERE al1.Avail_Languages_Code IN (SELECT DISTINCT a.Avail_Subtitling_Code FROM #Title_Avail a)
					) al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @Language_Code + ',%'
					WHEN MATCHED THEN
						UPDATE SET tmp.Languages_Code = tmp.Languages_Code + ',' + @Language_Code
					WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @Language_Code + ',%' THEN
						INSERT VALUES (al.Avail_Languages_Code, @Language_Code, '', 'S')
					;

					FETCH NEXT FROM Cur_Sub_Language INTO @Language_Code	
				END
				CLOSE Cur_Sub_Language
				DEALLOCATE Cur_Sub_Language

			END

		END
	END

	BEGIN ---------- DUBBING LNAGUAGE FILTER PROCESSING
	
		IF(@Language_Type LIKE '%D%')
		BEGIN

			INSERT INTO #Dub_Language_Search(Language_Code)
			SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Dubbing_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

			INSERT INTO #Dub_Language_Search(Language_Code)
			SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN (
				SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Dubbing_Group_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
			)
			--SELECT TOP 1 * FROM #Dub_Language_Search
			IF NOT EXISTS(SELECT TOP 1 * FROM #Dub_Language_Search)
			BEGIN

				INSERT INTO #Languages_Avail
				SELECT DISTINCT al.Avail_Languages_Code, Language_Codes, '', 'D' 
				FROM Avail_Languages al
				INNER JOIN #Title_Avail ta ON al.Avail_Languages_Code = ta.Avail_Subtitling_Code

			END
			ELSE
			BEGIN

				SET @Language_Code = ''
				DECLARE Cur_Dub_Language CURSOR FOR SELECT Language_Code FROM #Dub_Language_Search ORDER BY CAST(Language_Code AS VARCHAR(10)) ASC
				OPEN Cur_Dub_Language
				FETCH NEXT FROM Cur_Dub_Language INTO @Language_Code
				WHILE (@@FETCH_STATUS = 0)
				BEGIN

					MERGE INTO #Languages_Avail AS tmp
					USING (
						SELECT * FROM Avail_Languages al1
						WHERE al1.Avail_Languages_Code IN (SELECT DISTINCT a.Avail_Dubbing_Code FROM #Title_Avail a)
					) al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @Language_Code + ',%' AND tmp.Lang_Type = 'D'
					WHEN MATCHED THEN
						UPDATE SET tmp.Languages_Code = tmp.Languages_Code + ',' + @Language_Code
					WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @Language_Code + ',%' THEN
						INSERT VALUES (al.Avail_Languages_Code, @Language_Code, '', 'D')
					;

					FETCH NEXT FROM Cur_Dub_Language INTO @Language_Code	
				END
				CLOSE Cur_Dub_Language
				DEALLOCATE Cur_Dub_Language

			END
		END
	END

	BEGIN ---------- LNAGUAGE NAME PROCESSING

		DECLARE @tmpLanguages AS TABLE
		(
			Language_Codes VARCHAR(MAX),
			Language_Names VARCHAR(MAX)
		)

		INSERT INTO @tmpLanguages(Language_Codes)
		SELECT DISTINCT Languages_Code FROM #Languages_Avail
	
		UPDATE @tmpLanguages SET Language_Names = [dbo].[UFN_Get_Language_With_Parent](Language_Codes)

		--UPDATE tm SET tm.Languages_Name = tml.Language_Names 
		--FROM #Languages_Avail tm 
		--INNER JOIN @tmpLanguages tml ON tm.Languages_Code = tml.Language_Codes

	END


	IF(@Language_Type LIKE '%T%')
	BEGIN

		INSERT INTO #TempOutput(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Country_Code, Platform_Code, Language_Type, Language_Codes)
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, da.Start_Date, da.End_Date, Is_Exclusive, ca.Country_Code, pa.Platform_Code, 'T', 1
		FROM #Title_Avail atd
		INNER JOIN #Dates_Avail da ON da.Avail_Dates_Code = atd.Avail_Dates_Code
		INNER JOIN #tmpPlatform pa ON pa.Avail_Platform_Code = atd.Avail_Platform_Code
		INNER JOIN #tmpCountry ca ON ca.Avail_Country_Code = atd.Avail_Country_Code
		WHERE atd.Is_Title_Language = 1 AND atd.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	IF(@Language_Type LIKE '%S%')
	BEGIN
		
		INSERT INTO #TempOutput(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Country_Code, Platform_Code, Language_Type, Language_Codes)
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, da.Start_Date, da.End_Date, Is_Exclusive, ca.Country_Code, pa.Platform_Code, 'S', Languages_Code
		FROM #Title_Avail atd
		INNER JOIN #Dates_Avail da ON da.Avail_Dates_Code = atd.Avail_Dates_Code
		INNER JOIN #tmpPlatform pa ON pa.Avail_Platform_Code = atd.Avail_Platform_Code
		INNER JOIN #tmpCountry ca ON ca.Avail_Country_Code = atd.Avail_Country_Code
		INNER JOIN #Languages_Avail las ON atd.Avail_Subtitling_Code = las.Avail_Languages_Code AND las.Lang_Type = 'S'
		WHERE atd.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	IF(@Language_Type LIKE '%D%')
	BEGIN
		
		INSERT INTO #TempOutput(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Country_Code, Platform_Code, Language_Type, Language_Codes)
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, da.Start_Date, da.End_Date, Is_Exclusive, ca.Country_Code, pa.Platform_Code, 'D', Languages_Code
		FROM #Title_Avail atd
		INNER JOIN #Dates_Avail da ON da.Avail_Dates_Code = atd.Avail_Dates_Code
		INNER JOIN #tmpPlatform pa ON pa.Avail_Platform_Code = atd.Avail_Platform_Code
		INNER JOIN #tmpCountry ca ON ca.Avail_Country_Code = atd.Avail_Country_Code
		INNER JOIN #Languages_Avail las ON atd.Avail_Dubbing_Code = las.Avail_Languages_Code AND las.Lang_Type = 'D'
		WHERE atd.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END

	INSERT INTO #TempOutputPlat(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Platform_Code, Language_Type, Language_Codes, Country_Codes)
	SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Platform_Code, Language_Type, Language_Codes,
			STUFF
			(
				(
					SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR(20)) 
					FROM #TempOutput t2
					WHERE t1.Acq_Deal_Code = t2.Acq_Deal_Code AND
						  t1.Acq_Deal_Rights_Code = t2.Acq_Deal_Rights_Code AND
						  t1.Title_Code = t2.Title_Code AND
						  t1.Episode_From = t2.Episode_From AND
						  t1.Episode_To = t2.Episode_To AND
						  t1.Start_Date = t2.Start_Date AND
						  ISNULL(t1.End_Date, '9999-12-31') = ISNULL(t2.End_Date, '9999-12-31') AND
						  t1.Platform_Code = t2.Platform_Code AND
						  t1.Is_Exclusive = t2.Is_Exclusive AND
						  t1.Language_Type = t2.Language_Type AND
						  t1.Language_Codes = t2.Language_Codes
					FOR XML PATH('')
				), 1, 1, ''
			) AS Country_Codes
	FROM (
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Platform_Code, Is_Exclusive, Language_Type, Language_Codes
		FROM #TempOutput tp
	) AS t1


	INSERT INTO #TempOutputCnt(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Language_Type, Language_Codes, Country_Codes, Platform_Codes)
	SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Language_Type, Language_Codes, Country_Codes, 
			STUFF
			(
				(
					SELECT DISTINCT ',' + CAST(Platform_Code AS VARCHAR(20)) 
					FROM #TempOutputPlat t2
					WHERE t1.Acq_Deal_Code = t2.Acq_Deal_Code AND
						  t1.Acq_Deal_Rights_Code = t2.Acq_Deal_Rights_Code AND
						  t1.Title_Code = t2.Title_Code AND
						  t1.Episode_From = t2.Episode_From AND
						  t1.Episode_To = t2.Episode_To AND
						  t1.Start_Date = t2.Start_Date AND
						  ISNULL(t1.End_Date, '9999-12-31') = ISNULL(t2.End_Date, '9999-12-31') AND
						  t1.Country_Codes = t2.Country_Codes AND
						  t1.Is_Exclusive = t2.Is_Exclusive AND
						  t1.Language_Type = t2.Language_Type AND
						  t1.Language_Codes = t2.Language_Codes
					FOR XML PATH('')
				), 1, 1, ''
			) AS Platform_Codes
	FROM (
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Country_Codes, Is_Exclusive, Language_Type, Language_Codes
		FROM #TempOutputPlat tp
	) AS t1

	INSERT INTO #TempOutputFinal(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Country_Codes, Platform_Codes, 
								 Is_TItle_Language, 
								 Subtitling_Language, 
								 Dubbing_Language)
	SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Country_Codes, Platform_Codes,
	(
		SELECT Language_Codes FROM #TempOutputCnt t1
		WHERE t1.Acq_Deal_Code = t2.Acq_Deal_Code AND
			  t1.Acq_Deal_Rights_Code = t2.Acq_Deal_Rights_Code AND
		      t1.Language_Type = 'T' AND 
			  t1.Title_Code = t2.Title_Code AND
			  t1.Episode_From = t2.Episode_From AND
			  t1.Episode_To = t2.Episode_To AND
			  t1.Start_Date = t2.Start_Date AND
			  ISNULL(t1.End_Date, '9999-12-31') = ISNULL(t2.End_Date, '9999-12-31') AND
			  t1.Country_Codes = t2.Country_Codes AND
			  t1.Platform_Codes = t2.Platform_Codes AND
			  t1.Is_Exclusive = t2.Is_Exclusive
	) Title_Lnguage,
	--STUFF
	--(
		(
			--SELECT DISTINCT ',' + Language_Codes FROM #TempOutputCnt t1
			SELECT Language_Codes FROM #TempOutputCnt t1
			WHERE t1.Acq_Deal_Code = t2.Acq_Deal_Code AND
				  t1.Acq_Deal_Rights_Code = t2.Acq_Deal_Rights_Code AND
				  t1.Language_Type = 'S' AND 
				  t1.Title_Code = t2.Title_Code AND
				  t1.Episode_From = t2.Episode_From AND
				  t1.Episode_To = t2.Episode_To AND
				  t1.Start_Date = t2.Start_Date AND
				  ISNULL(t1.End_Date, '9999-12-31') = ISNULL(t2.End_Date, '9999-12-31') AND
				  t1.Country_Codes = t2.Country_Codes AND
				  t1.Platform_Codes = t2.Platform_Codes AND
				  t1.Is_Exclusive = t2.Is_Exclusive
		--	FOR XML PATH('')
		--), 1, 1, ''
	) AS Subtitling_Codes,
	--STUFF
	--(
		(
			--SELECT  DISTINCT ',' + Language_Codes FROM #TempOutputCnt t1
			SELECT  Language_Codes FROM #TempOutputCnt t1
			WHERE t1.Acq_Deal_Code = t2.Acq_Deal_Code AND
				  t1.Acq_Deal_Rights_Code = t2.Acq_Deal_Rights_Code AND
				  t1.Language_Type = 'D' AND 
				  t1.Title_Code = t2.Title_Code AND
				  t1.Episode_From = t2.Episode_From AND
				  t1.Episode_To = t2.Episode_To AND
				  t1.Start_Date = t2.Start_Date AND
				  ISNULL(t1.End_Date, '9999-12-31') = ISNULL(t2.End_Date, '9999-12-31') AND
				  t1.Country_Codes = t2.Country_Codes AND
				  t1.Platform_Codes = t2.Platform_Codes AND
				  t1.Is_Exclusive = t2.Is_Exclusive
		--	FOR XML PATH('')
		--), 1, 1, ''
	) AS Dubbing_Codes
	FROM (
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Start_Date, End_Date, Is_Exclusive, Country_Codes, Platform_Codes 
		FROM #TempOutputCnt
	) AS t2


	BEGIN --------------- COUNTRY GROUPING

		DECLARE @tmpCountry AS TABLE
		(
			Country_Codes VARCHAR(MAX),
			Territory_Name NVARCHAR(MAX),
			Country_Name NVARCHAR(MAX)
		)

		INSERT INTO @tmpCountry(Country_Codes, Territory_Name, Country_Name)
		SELECT tc.Country_Codes, ISNULL(c.Cluster_Name, ''), c.Region_Name
		FROM (
			SELECT DISTINCT Country_Codes FROM #TempOutputFinal
		) tc
		CROSS APPLY DBO.UFN_Get_Report_Territory(tc.Country_Codes, 0) c

	END
	
	BEGIN --------------- PLATFORM GROUPING

		DECLARE @tmpPlat AS TABLE
		(
			Platform_Codes VARCHAR(MAX),
			Platform_Hierarchy NVARCHAR(MAX)
		)

		DECLARE @tmpChildPlatform AS TABLE
		(
			Platform_Code INT,
			Parent_Platform_Code VARCHAR(MAX)
		)

		DECLARE @tempChildPlat AS TABLE
		(
			Platform_Code INT
		)

		DECLARE 
		@tmpPlatform_Codes NVARCHAR(MAX) = '',
		@tmp_Acq_Deal_Rights_Code INT

		DECLARE Cur_Platform CURSOR FOR SELECT Acq_Deal_Rights_Code, Platform_Codes FROM #TempOutputFinal 
		OPEN Cur_Platform
		FETCH NEXT FROM Cur_Platform INTO @tmp_Acq_Deal_Rights_Code, @tmpPlatform_Codes
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			INSERT INTO @tempChildPlat(Platform_Code)
			SELECT Number COLLATE DATABASE_DEFAULT FROM DBO.fn_Split_withdelemiter(ISNULL(@tmpPlatform_Codes,''), ',') 
			

			INSERT INTO @tmpChildPlatform(Platform_Code, Parent_Platform_Code)
			SELECT p.Platform_Code, p.Parent_Platform_Code
			FROM @tempChildPlat tp
			INNER JOIN Platform p ON p.Platform_Code = tp.Platform_Code

			--SELECT * FROM @tempParentPlatform
			--SELECT * FROM @tmpChildPlatform

			DECLARE @Child_Count INT, @tempChildCount INT
			DECLARE Cur_ParentPlatform CURSOR FOR SELECT Parent_Platform_Code, Child_Count FROM @tempParentPlatform ORDER BY Module_Position DESC
			OPEN Cur_ParentPlatform
			FETCH NEXT FROM Cur_ParentPlatform INTO @Parent_Platform_Code, @Child_Count
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SELECT @tempChildCount = COUNT(*) FROM @tmpChildPlatform WHERE Parent_Platform_Code = @Parent_Platform_Code

				IF( @Child_Count = @tempChildcount)
				BEGIN
					INSERT INTO @tmpChildPlatform(Platform_Code,Parent_Platform_Code)
					SELECT @Parent_Platform_Code, Parent_Platform_Code FROM Platform 
					WHERE  Platform_Code = @Parent_Platform_Code
				END
								
				FETCH NEXT FROM Cur_ParentPlatform INTO @Parent_Platform_Code, @Child_Count
			END
			CLOSE Cur_ParentPlatform
			DEALLOCATE Cur_ParentPlatform

			DELETE FROM #Platform_Search

			INSERT INTO #Platform_Search(Platform_Code)
			SELECT tp.Platform_Code
			FROM Platform p
			INNER JOIN @tmpChildPlatform tp ON tp.Platform_Code = p.Platform_Code
			WHERE p.Parent_Platform_Code NOT IN ( SELECT Platform_Code FROM @tmpChildPlatform ) OR ISNULL(p.Parent_Platform_Code,0) = 0
			
			UPDATE #TempOutputFinal
			SET Platform_Codes = (
				STUFF((
			SELECT ',' + CAST(Platform_Code AS VARCHAR(MAX))  FROM #Platform_Search
			FOR XML PATH('')), 1, 1, ''))
			WHERE Acq_Deal_Rights_Code = @tmp_Acq_Deal_Rights_Code

			DELETE FROM @tmpChildPlatform
			DELETE FROM @tempChildPlat
				
			FETCH NEXT FROM Cur_Platform INTO @tmp_Acq_Deal_Rights_Code, @tmpPlatform_Codes	
		END
		CLOSE Cur_Platform
		DEALLOCATE Cur_Platform


		INSERT INTO @tmpPlat(Platform_Codes, Platform_Hierarchy)
		SELECT tp.Platform_Codes,
		STUFF((
			SELECT '~', ROW_NUMBER() OVER (ORDER BY p.Platform_Code), ') '+ p.Platform_Hiearachy FROM Platform p
			WHERE p.Platform_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(ISNULL(tp.Platform_Codes,''), ','))
			ORDER BY p.Platform_Code
			FOR XML PATH('')), 1, 1, ''
		) AS Platform_Hierarchy
		FROM (
			SELECT DISTINCT Platform_Codes FROM #TempOutputFinal
		) tp
	END

	SELECT DISTINCT ta.Acq_Deal_Code AS DealCode ,atd.Title_Code, t.Title_Name, atd.Episode_From, atd.Episode_To, pl.Platform_Hierarchy AS Platform, ISNULL(cn.Territory_Name,'') AS Territory_Name, ISNULL(cn.Country_Name,'') AS Country_Name, 
		   UPPER(REPLACE(CONVERT(VARCHAR(30), atd.Start_Date, 106), ' ', '-')) AS Start_Date, UPPER(REPLACE(CONVERT(VARCHAR(30), ISNULL(atd.End_Date,'31DEC9999'), 106), ' ', '-')) AS End_Date, 
	       CASE WHEN atd.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non-Exclusive' END AS Is_Exclusive, 
		   CASE WHEN atd.Is_Title_Language = 1 THEN l.Language_Name ELSE 'NA' END AS Is_Title_Language,
		   CASE WHEN ISNULL(lns.Language_Names,'') = '' THEN 'NA' ELSE ISNULL(lns.Language_Names,'') END AS Subtitling_Language,
		   CASE WHEN ISNULL(lnd.Language_Names,'') = '' THEN 'NA' ELSE ISNULL(lnd.Language_Names,'') END AS Dubbing_Language, sl.Sub_License_Name AS Sublicensing
	FROM #TempOutputFinal atd
	INNER JOIN Title t ON atd.Title_Code = t.Title_Code
	LEFT JOIN Language l ON t.Title_Language_Code  = l.Language_Code
	INNER JOIN @tmpPlat pl ON CASt(atd.Platform_Codes AS VARCHAR) COLLATE DATABASE_DEFAULT = CASt(pl.Platform_Codes AS VARCHAR) COLLATE DATABASE_DEFAULT
	INNER JOIN @tmpCountry cn ON cn.Country_Codes COLLATE DATABASE_DEFAULT = atd.Country_Codes COLLATE DATABASE_DEFAULT
	LEFT JOIN @tmpLanguages lns ON lns.Language_Codes COLLATE DATABASE_DEFAULT = atd.Subtitling_Language COLLATE DATABASE_DEFAULT
	LEFT JOIN @tmpLanguages lnd ON lnd.Language_Codes COLLATE DATABASE_DEFAULT = atd.Dubbing_Language COLLATE DATABASE_DEFAULT
	INNER JOIN #Title_Avail ta ON CAST(ta.Title_Code AS VARCHAR) COLLATE DATABASE_DEFAULT = CAST(atd.Title_Code AS VARCHAR) COLLATE DATABASE_DEFAULT AND CAST(ta.Acq_Deal_Code AS VARCHAR) COLLATE DATABASE_DEFAULT = CAST(atd.Acq_Deal_Code AS VARCHAR) COLLATE DATABASE_DEFAULT
	INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = atd.Acq_Deal_Rights_Code 
	INNER JOIN Sub_License sl ON sl.Sub_License_Code  = adr.Sub_License_Code 
	AND atd.Is_Exclusive IN (@EX_YES,@EX_NO)
	
	IF OBJECT_ID('tempdb..#Title_Avail') IS NOT NULL DROP TABLE #Title_Avail
	IF OBJECT_ID('tempdb..#Languages_Avail') IS NOT NULL DROP TABLE #Languages_Avail
	IF OBJECT_ID('tempdb..#tmpPlatform') IS NOT NULL DROP TABLE #tmpPlatform
	IF OBJECT_ID('tempdb..#Sub_Language_Search') IS NOT NULL DROP TABLE #Sub_Language_Search
	IF OBJECT_ID('tempdb..#Dub_Language_Search') IS NOT NULL DROP TABLE #Dub_Language_Search
	IF OBJECT_ID('tempdb..#Country_Search') IS NOT NULL DROP TABLE #Country_Search
	IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
	IF OBJECT_ID('tempdb..#Dates_Avail') IS NOT NULL DROP TABLE #Dates_Avail
	IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput
	IF OBJECT_ID('tempdb..#TempOutputCnt') IS NOT NULL DROP TABLE #TempOutputCnt
	IF OBJECT_ID('tempdb..#TempOutputPlat') IS NOT NULL DROP TABLE #TempOutputPlat
	IF OBJECT_ID('tempdb..#TempOutputFinal') IS NOT NULL DROP TABLE #TempOutputFinal
	IF OBJECT_ID('tempdb..#tmpCountry') IS NOT NULL DROP TABLE #tmpCountry

END
