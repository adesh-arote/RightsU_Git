CREATE PROCEDURE [dbo].[USPGenerateAvailTitleData](@Title_Code INT)
AS
BEGIN

	--DECLARE @Title_Code INT = 277

	IF OBJECT_ID('tempdb..#AvailTitlesTemp') IS NOT NULL DROP TABLE #AvailTitlesTemp
	IF OBJECT_ID('tempdb..#AvailTitlesDetailsTemp') IS NOT NULL DROP TABLE #AvailTitlesDetailsTemp
	
	PRINT 'STEP 1'
	
	BEGIN ------------- TABLE CREATION

		CREATE TABLE #AvailTitlesTemp(
			IntCode INT IDENTITY(1 ,1),
			Title_Code INT, 
			Avail_Raw_Code INT,
			Avail_Country_Code INT, 
			Avail_Platform_Code INT,
			Is_Title_Language BIT, 
			Sub_Language_Code INT, 
			Dub_Language_Code INT,
			Country_Codes NVARCHAR(MAX),
			Platform_Codes NVARCHAR(MAX),
		)

		CREATE TABLE #AvailTitlesDetailsTemp(
			IntCode INT,
			Country_Code INT, 
			Platform_Code INT
		)

	END
	
	PRINT 'STEP 2'
	
	BEGIN -------------- DATA POPULATION

		INSERT INTO #AvailTitlesTemp(Title_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code)
		SELECT DISTINCT aa.Title_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code
		FROM Avail_Acq aa
		INNER JOIN Avail_Acq_Details aad ON aa.Avail_Acq_Code = aad.Avail_Acq_Code
		WHERE aa.Title_Code = @Title_Code

		INSERT INTO #AvailTitlesDetailsTemp(IntCode, Country_Code, Platform_Code)
		SELECT DISTINCT tmp.IntCode, Country_Code, Platform_Code
		FROM Avail_Acq aa
		INNER JOIN Avail_Acq_Details aad ON aa.Avail_Acq_Code = aad.Avail_Acq_Code
		INNER JOIN #AvailTitlesTemp tmp ON aa.Title_Code = tmp.Title_Code AND aad.Avail_Raw_Code = tmp.Avail_Raw_Code
										   AND ISNULL(aad.Is_Title_Language, -1) = ISNULL(tmp.Is_Title_Language, -1)
										   AND ISNULL(aad.Sub_Language_Code, 0) = ISNULL(tmp.Sub_Language_Code, 0)
										   AND ISNULL(aad.Dub_Language_Code, 0) = ISNULL(tmp.Dub_Language_Code, 0)
		WHERE aa.Title_Code = @Title_Code

		UPDATE t1 
		SET Platform_Codes =  ',' + STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Platform_Code AS VARCHAR(20)) 
				FROM #AvailTitlesDetailsTemp t2
				WHERE t1.IntCode = t2.IntCode
				FOR XML PATH('')
			), 1, 1, ''
		) + ',',
		Country_Codes = ',' + STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR(20)) 
				FROM #AvailTitlesDetailsTemp t2
				WHERE t1.IntCode = t2.IntCode
				FOR XML PATH('')
			), 1, 1, ''
		) + ','
		FROM #AvailTitlesTemp t1

	END
	
	PRINT 'STEP 3'
	
	/*
	SELECT *, STUFF
	(
		(
			SELECT DISTINCT ',' + CAST(Platform_Code AS VARCHAR(20)) 
			FROM #AvailTitlesDetailsTemp t2
			WHERE t1.IntCode = t2.IntCode
			FOR XML PATH('')
		), 1, 1, ''
	) AS Platform_Codes,
	STUFF
	(
		(
			SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR(20)) 
			FROM #AvailTitlesDetailsTemp t2
			WHERE t1.IntCode = t2.IntCode
			FOR XML PATH('')
		), 1, 1, ''
	) AS Country_Codes
	FROM #AvailTitlesTemp t1
	*/
	
	PRINT 'STEP 4'
	
	BEGIN ------------ PLATFORM CONVERSION

		Update tmp SET tmp.Avail_Platform_Code  = main.Avail_Platform_Code 
		FROM #AvailTitlesTemp tmp 
		INNER JOIN Avail_Platforms main On tmp.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

		INSERT INTO Avail_Platforms(Platform_Codes)
		SELECT DISTINCT Platform_Codes FROM #AvailTitlesTemp 
		WHERE Avail_Platform_Code IS NULL

		Update tmp SET tmp.Avail_Platform_Code  = main.Avail_Platform_Code 
		FROM #AvailTitlesTemp tmp 
		INNER JOIN Avail_Platforms main On tmp.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE tmp.Avail_Platform_Code IS NULL

	END
	
	PRINT 'STEP 5'
	
	BEGIN ------------ COUNTRY CONVERSION

		Update tmp SET tmp.Avail_Country_Code  = main.Avail_Country_Code 
		FROM #AvailTitlesTemp tmp 
		INNER JOIN Avail_Countries main On tmp.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

		INSERT INTO Avail_Countries(Country_Codes)
		SELECT DISTINCT Country_Codes FROM #AvailTitlesTemp 
		WHERE Avail_Country_Code IS NULL

		Update tmp SET tmp.Avail_Country_Code  = main.Avail_Country_Code 
		FROM #AvailTitlesTemp tmp 
		INNER JOIN Avail_Countries main On tmp.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE tmp.Avail_Country_Code IS NULL

	END
	
	PRINT 'STEP 6'
	
	DELETE FROM Avail_Title_Data WHERE Title_Code = @Title_Code

	INSERT INTO Avail_Title_Data(Title_Code, Avail_Raw_Code, Avail_Country_Code, Avail_Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code)
	SELECT Title_Code, Avail_Raw_Code, Avail_Country_Code, Avail_Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code FROM #AvailTitlesTemp
	
	IF OBJECT_ID('tempdb..#AvailTitlesTemp') IS NOT NULL DROP TABLE #AvailTitlesTemp
	IF OBJECT_ID('tempdb..#AvailTitlesDetailsTemp') IS NOT NULL DROP TABLE #AvailTitlesDetailsTemp
	IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData

	PRINT 'Final Step 7 - Calling [USPMaintainAvailData]'
	
	BEGIN ------- TRANSFER DATA FOR AVAIL DATABASE

		CREATE TABLE #TempData
		(
			Acq_Deal_Code INT, 
			Acq_Deal_Rights_Code INT, 
			[Start_Date] DATE, 
			End_Date DATE, 
			Is_Exclusive BIT, 
			Title_Code INT, 
			Episode_From INT,
			Episode_To INT,
			Is_Theatrical BIT,
			Platform_Codes NVARCHAR(MAX), 
			Country_Codes NVARCHAR(MAX), 
			Is_Title_Language BIT, 
			Sub_Language_Codes NVARCHAR(MAX), 
			Dub_Language_Codes NVARCHAR(MAX),
		)
		
		INSERT INTO #TempData(Acq_Deal_Code, Acq_Deal_Rights_Code, Start_Date, End_Date, Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, 
									Is_Title_Language, Sub_Language_Codes, Dub_Language_Codes, Episode_From, Episode_To, Is_Theatrical)
		SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Start_Date, End_Date, Is_Exclusive, atd.Title_Code, Platform_Codes, Country_Codes, 
			   Is_Title_Language, sl.Language_Codes AS Sub_Language_Codes, dl.Language_Codes AS Dub_Language_Codes, 1, 1, 0
		FROM Avail_Title_Data atd
		INNER JOIN Avail_Raw ar ON atd.Avail_Raw_Code =	 ar.Avail_Raw_Code
		INNER JOIN Avail_Dates ad ON ar.Avail_Dates_Code = ad.Avail_Dates_Code
		INNER JOIN Avail_Platforms ap ON atd.Avail_Platform_Code = ap.Avail_Platform_Code
		INNER JOIN Avail_Countries ac ON atd.Avail_Country_Code = ac.Avail_Country_Code
		LEFT JOIN Avail_Languages sl ON atd.Sub_Language_Code = sl.Avail_Languages_Code
		LEFT JOIN Avail_Languages dl ON atd.Dub_Language_Code = dl.Avail_Languages_Code
		WHERE atd.Title_Code = @Title_Code
		
		PRINT 'Final Step 7.1 - Calling [USPMaintainAvailData]'
	
		DECLARE @EXECSQLAVAIL NVARCHAR(MAX) = N'
		USE RightsU_Avail_Neo_V18
		
		DECLARE @Avail_Data_UDT [Avail_Data_UDT]

		INSERT INTO @Avail_Data_UDT(Acq_Deal_Code, Acq_Deal_Rights_Code, Start_Date, End_Date, Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, 
									Is_Title_Language, Sub_Language_Codes, Dub_Language_Codes, Episode_From, Episode_To, Is_Theatrical)
		SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Start_Date, End_Date, Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, 
			   Is_Title_Language, Sub_Language_Codes, Dub_Language_Codes, Episode_From, Episode_To, Is_Theatrical
		FROM #TempData

		EXEC [USPMaintainAvailData] @Avail_Data_UDT, ''' + CAST(@Title_Code AS VARCHAR) + ''' '

		EXEC sp_executesql @EXECSQLAVAIL

		IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
		--EXEC [RightsU_Avail_Neo].[DBO].[USPMaintainAvailData] @Avail_Data_UDT, @Title_Code

	END

END

