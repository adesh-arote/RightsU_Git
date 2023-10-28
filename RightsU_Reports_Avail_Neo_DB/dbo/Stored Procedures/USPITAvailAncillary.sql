CREATE PROCEDURE [dbo].[USPITAvailAncillary]
(
	@UDT TitleCriteria READONLY	
)
AS
BEGIN
	--DECLARE
	--@UDT TitleCriteria
	--INSERT INTO @UDT VALUES('PlatformCodes','15,9,7,13,17,8,16,14,10,14,16')
	--INSERT INTO @UDT VALUES('PeriodType','FL')
	--INSERT INTO @UDT VALUES('Start Date','6-Feb-2020')
	--INSERT INTO @UDT VALUES('End Date','24-Feb-2020')
	--INSERT INTO @UDT VALUES('Exclusivity','Both')
	--INSERT INTO @UDT VALUES('AvailTitleCode','26800')
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
		@PlatformCodes VARCHAR(MAX),
		@Exclusivity VARCHAR(1)
	
		INSERT INTO #tempCriteria
		SELECT * FROM @UDT

		SET @Title_Code =  (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'AvailTitleCode')
		SET @Date_Type = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'DateType')
		SET @StartDate = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'Start Date')
		SET @EndDate = (SELECT ISNULL(TextField,'') FROM #tempCriteria WHERE ValueField  = 'End Date')
		SET @PlatformCodes = (SELECT TextField FROM #tempCriteria WHERE ValueField = 'PlatformCodes')
		--SET @Exclusivity  = (SELECT TextField FROM #tempCriteria WHERE ValueField  = 'Exclusivity')

		IF(@Exclusivity = 'Y')
			SET @Exclusivity = 'E'
		ELSE IF(@Exclusivity = 'N')
			SET @Exclusivity = 'N'
		ELSE
			SET @Exclusivity = 'B'
	END
	BEGIN ---------- DECLARE SECTION

		IF OBJECT_ID('tempdb..#Title_Avail') IS NOT NULL DROP TABLE #Title_Avail
		IF OBJECT_ID('tempdb..#Platform_Avail') IS NOT NULL DROP TABLE #Platform_Avail
		IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
		IF OBJECT_ID('tempdb..#Dates_Avail') IS NOT NULL DROP TABLE #Dates_Avail
	
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

		Create Table #Platform_Avail(
			Avail_Platform_Code NUMERIC(38,0),
			Platform_Codes VARCHAR(MAX),
			Platform_Names NVARCHAR(MAX)
		)
		
		CREATE TABLE #Platform_Search(
			Platform_Code INT
		)
	
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

	END

	BEGIN ---------- TITLE FILTER

		INSERT INTO #Title_Avail(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Avail_Dates_Code, Is_Exclusive, 
								 Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code)
		SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Avail_Dates_Code, Is_Exclusive, 
								 Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code
		FROM Avail_Title_Data WHERE Title_Code IN (
			SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@Title_Code,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
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

	END

	BEGIN ---------- PLATFORM PROCESSING

		INSERT INTO #Platform_Search(Platform_Code)
		SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@PlatformCodes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

		DECLARE @Platform_Code VARCHAR(10) = ''
		DECLARE Cur_Platform CURSOR FOR SELECT Platform_Code FROM #Platform_Search ORDER BY CAST(Platform_Code AS VARCHAR(10)) ASC
		OPEN Cur_Platform
		FETCH NEXT FROM Cur_Platform INTO @Platform_Code
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			MERGE INTO #Platform_Avail AS tmp
			USING (
				SELECT * FROM Avail_Platforms ap
				WHERE ap.Avail_Platform_Code IN(SELECT DISTINCT a.Avail_Platform_Code FROM #Title_Avail a)
			) al On tmp.Avail_Platform_Code = al.Avail_Platform_Code AND al.Platform_Codes Like '%,' + @Platform_Code + ',%' 
			WHEN MATCHED THEN
				UPDATE SET tmp.Platform_Codes = tmp.Platform_Codes + ',' + @Platform_Code
			WHEN NOT MATCHED AND al.Platform_Codes Like '%,' + @Platform_Code + ',%' THEN
				INSERT VALUES (al.Avail_Platform_Code, @Platform_Code, '')
			;

			FETCH NEXT FROM Cur_Platform INTO @Platform_Code	
		END
		CLOSE Cur_Platform
		DEALLOCATE Cur_Platform

		UPDATE tp SET tp.Platform_Names = STUFF
			(
				(
					SELECT DISTINCT ', ' + Platform_Name FROM Platform
					WHERE Platform_Code IN (
						SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(tp.Platform_Codes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
					)
					FOR XML PATH('')
				), 1, 1, ''
			)
		FROM #Platform_Avail tp

	END

	--SELECT * FROM #Title_Avail
	--SELECT * FROM #Dates_Avail
	--SELECT * FROM #Languages_Avail
	--SELECT * FROM #Country_Avail
	--SELECT * FROM #Platform_Avail

	SELECT DISTINCT atd.Title_Code, t.Title_Name, atd.Episode_From, atd.Episode_To, pa.Platform_Names AS Platforms,
		   UPPER(REPLACE(CONVERT(VARCHAR(30), da.Start_Date, 106), ' ', '-')) AS Start_Date, UPPER(REPLACE(CONVERT(VARCHAR(30), da.End_Date, 106), ' ', '-')) AS End_Date, 
	       CASE WHEN atd.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non-Exclusive' END AS Is_Exclusive, 
		   CASE WHEN atd.Is_Title_Language = 1 THEN l.Language_Name ELSE '' END AS Is_Title_Language, sl.Sub_License_Name AS Sublicensing
	FROM #Title_Avail atd
	INNER JOIN Title t ON atd.Title_Code = t.Title_Code
	INNER JOIN Language l ON t.Title_Language_Code = l.Language_Code
	INNER JOIN #Platform_Avail pa ON pa.Avail_Platform_Code = atd.Avail_Platform_Code
	INNER JOIN #Dates_Avail da ON da.Avail_Dates_Code = atd.Avail_Dates_Code
	INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = atd.Acq_Deal_Rights_Code
	INNER JOIN Sub_License sl ON sl.Sub_License_Code = adr.Sub_License_Code
	WHERE atd.Is_Exclusive IN (@Ex_YES, @Ex_NO)


	IF OBJECT_ID('tempdb..#Title_Avail') IS NOT NULL DROP TABLE #Title_Avail
	IF OBJECT_ID('tempdb..#Platform_Avail') IS NOT NULL DROP TABLE #Platform_Avail
	IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
	IF OBJECT_ID('tempdb..#Dates_Avail') IS NOT NULL DROP TABLE #Dates_Avail
	
END
