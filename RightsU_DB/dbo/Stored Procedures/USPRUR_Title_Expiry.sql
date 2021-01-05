



CREATE PROC [dbo].[USPRUR_Title_Expiry]
(
	@RightsDefination RightsDefination READONLY,
	@FirstFrom INT,
	@FirstTo INT,
	@SecondFrom INT,
	@SecondTo INT,
	@ThirdFrom INT,
	@ThirdTo INT
)
AS
BEGIN

	DECLARE @Deal_Rights_Title Deal_Rights_Title
	DECLARE @Deal_Rights_Platform Deal_Rights_Platform
	DECLARE @Deal_Rights_Territory Deal_Rights_Territory
	DECLARE @Deal_Rights_Subtitling Deal_Rights_Subtitling
	DECLARE @Deal_Rights_Dubbing Deal_Rights_Dubbing
	DECLARE @Syn_Deal_Code Int = 0

	CREATE TABLE #RigtsTitle
	(
		Acq_Deal_Rights_Code INT,  
		Title_Code INT, 
		Episode_From INT, 
		Episode_To INT, 
		Actual_Right_Start_Date DATE, 
		Actual_Right_End_Date DATE, 
		Is_Title_Language_Right CHAR(1)
	)
	
	CREATE TABLE #RightsCountry
	(
		Acq_Deal_Rights_Code INT,
		Country_Code INT
	)

	CREATE TABLE #ExpiryData(
		Title_Code INT,
		Country_Code INT,
		Platform_Code INT,
		Actual_Right_Start_Date DATE,
		Actual_Right_End_Date DATE,
		Expire_In_Days INT,
		Title_Name NVARCHAR(500),
		Country_Name NVARCHAR(500),
		Platform_Name NVARCHAR(500)
	);

	DECLARE @IntCode INT, @TitleCode INT, @EpisodeStart INT, @EpisodeEnd INT, @StartDate Date, @EndDate Date,
			@Is_Title_Language_Right Char(1) = 'Y', @Is_Exclusive Char(1) = 'N', @Is_Error Char(1) = 'N', @Right_Type Char(1) = 'Y',
			@CountryCodes VARCHAR(4000) = '', @PlatformCodes VARCHAR(4000) = ''--, @DubbingCodes VARCHAR(4000) = '', @SubtitlingCodes VARCHAR(4000) = ''

	DECLARE EUR_Rights CURSOR FOR 
		SELECT IntCode, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, CountryCodes, PlatformCodes
		FROM @RightsDefination ORDER BY TitleCode ASC, EpisodeStart ASC
	OPEN EUR_Rights
	FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
	
		TRUNCATE TABLE #RigtsTitle
		TRUNCATE TABLE #RightsCountry

		DELETE FROM @Deal_Rights_Title
		DELETE FROM @Deal_Rights_Territory
		DELETE FROM @Deal_Rights_Platform
		
		INSERT INTO @Deal_Rights_Title(Title_Code, Episode_From, Episode_To)
		SELECT @TitleCode, @EpisodeStart, @EpisodeEnd

		INSERT INTO @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
		SELECT 0, number FROM dbo.fn_Split_withdelemiter(@CountryCodes, ',') WHERE number <> ''

		INSERT INTO @Deal_Rights_Platform(Deal_Rights_Code, Platform_Code)
		SELECT 0, number FROM dbo.fn_Split_withdelemiter(@PlatformCodes, ',') WHERE number <> ''

		INSERT INTO #RigtsTitle(Acq_Deal_Rights_Code, Title_Code, 
			Episode_From, 
			Episode_To, 
			Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right)
		SELECT adr.Acq_Deal_Rights_Code, adrt.Title_Code,
			CASE WHEN adrt.Episode_From >= drt.Episode_From THEN adrt.Episode_From ELSE drt.Episode_From END AS Episode_From,
			CASE WHEN adrt.Episode_To <= drt.Episode_To THEN adrt.Episode_To ELSE drt.Episode_To END AS Episode_To,
			Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right
		FROM Acq_Deal_Rights adr 
		INNER JOIN Acq_Deal_Rights_Title adrt On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		INNER JOIN @Deal_Rights_Title drt ON adrt.Title_Code = drt.Title_Code AND 
		(
			adrt.Episode_From BETWEEN drt.Episode_From AND drt.Episode_To OR
			adrt.Episode_To BETWEEN drt.Episode_From AND drt.Episode_To OR
			drt.Episode_From BETWEEN adrt.Episode_From AND adrt.Episode_To OR
			drt.Episode_To BETWEEN adrt.Episode_From AND adrt.Episode_To 
		)
		WHERE ((Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or Right_Type <> 'M') AND Is_Title_Language_Right = 'Y'

		INSERT INTO #RightsCountry(Acq_Deal_Rights_Code, Country_Code)
		SELECT Acq_Deal_Rights_Code, Country_Code FROM (
			SELECT adr.Acq_Deal_Rights_Code, td.Country_Code 
			FROM #RigtsTitle adr
			INNER JOIN Acq_Deal_Rights_Territory tg ON adr.Acq_Deal_Rights_Code = tg.Acq_Deal_Rights_Code AND tg.Territory_Type = 'G'
			INNER JOIN Territory_Details td ON tg.Territory_Code = td.Territory_Code
			INNER JOIN @Deal_Rights_Territory drt ON td.Country_Code = drt.Country_Code
			UNION ALL
			SELECT adr.Acq_Deal_Rights_Code, tg.Country_Code 
			FROM #RigtsTitle adr
			INNER JOIN Acq_Deal_Rights_Territory tg ON adr.Acq_Deal_Rights_Code = tg.Acq_Deal_Rights_Code AND tg.Territory_Type = 'I'
			INNER JOIN @Deal_Rights_Territory drt ON tg.Country_Code = drt.Country_Code
		) AS a
		
		INSERT INTO #ExpiryData(Title_Code, Country_Code, Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days, Title_Name, Country_Name, Platform_Name)
		SELECT data.Title_Code, data.Country_Code, data.Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days, t.Title_Name, c.Country_Name, p.Platform_Hiearachy
		FROM (
			SELECT DISTINCT Title_Code, Country_Code, Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days 
			FROM
			(
				SELECT DISTINCT adr.Acq_Deal_Rights_Code, 
				ROW_NUMBER()OVER(PARTITION BY Title_Code, country_code, platform_code, adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] DESC) AS [row],
				Platform_Code, Title_Code, Country_Code, Actual_Right_Start_Date,Actual_Right_End_Date,
				DATEDIFF(dd,GETDATE(),IsNull(Actual_Right_End_Date, '31Dec9999')) AS Expire_In_Days
				From #RigtsTitle adr
				Inner Join Acq_Deal_Rights_Platform adrp On adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
				Inner Join #RightsCountry adrc On adr.Acq_Deal_Rights_Code = adrc.Acq_Deal_Rights_Code
			) b
			WHERE [row] = 1 And (
				Expire_In_Days BETWEEN @FirstFrom AND @FirstTo OR
				Expire_In_Days BETWEEN @SecondFrom AND @SecondTo OR
				Expire_In_Days BETWEEN @ThirdFrom AND @ThirdTo
			)
		) AS data
		INNER JOIN Title t On t.Title_Code = data.Title_Code
		INNER JOIN Country c On c.Country_Code = data.Country_Code
		INNER JOIN Platform p On p.Platform_Code = data.Platform_Code


		FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes
	END
	CLOSE EUR_Rights
	DEALLOCATE EUR_Rights

	SELECT DISTINCT Title_Code, Country_Code, Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days, Title_Name, Country_Name, Platform_Name
	FROM #ExpiryData
	
	DROP TABLE #RigtsTitle
	DROP TABLE #RightsCountry
	DROP TABLE #ExpiryData

END
