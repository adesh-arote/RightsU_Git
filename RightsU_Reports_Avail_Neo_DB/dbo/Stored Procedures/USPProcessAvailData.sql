CREATE PROCEDURE [dbo].[USPProcessAvailData](@IntCode INT)
AS
BEGIN

	/*
	
	IF OBJECT_ID('tempdb..#TitleCodes') IS NOT NULL DROP TABLE #TitleCodes
 
	CREATE TABLE #TitleCodes
	(
		TitleCode INT NULL
	)

	BEGIN
		INSERT INTO #TitleCodes (TitleCode)
		SELECT DISTINCT Title_Code From AvailData (NOLOCK) WHERE ISNULL(Is_Processed,'N') = 'N'
	END

	BEGIN

	    DECLARE @TitleCode INT 
		DECLARE Cur_Title CURSOR FOR SELECT TitleCode FROM #TitleCodes 
		OPEN Cur_Title
		FETCH NEXT FROM Cur_Title INTO @TitleCode
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			DELETE FROM @Avail_Data_UDT

			INSERT INTO @Avail_Data_UDT(Acq_Deal_Rights_Code,
				[Start_Date],
				End_Date,
				Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, Is_Title_Language,
				Sub_Language_Codes, Dub_Language_Codes, Episode_From, Episode_To, Is_Theatrical) 
			SELECT DISTINCT Acq_Deal_Rights_Code, 
				CASE WHEN  CONVERT(varchar(10),[Start_Date],101) = '01/01/0001' THEN NULL ELSE [Start_Date] END  [Start_Date],
				CASE WHEN  CONVERT(varchar(10),End_Date,101) = '01/01/0001' THEN NULL ELSE End_Date END  End_Date,
				Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, Is_Title_Language, 
				Sub_Language_Codes, Dub_Language_Codes, Episode_From, Episode_To, Is_Theatrical 
			FROM AvailData (NOLOCK) WHERE ISNULL(Is_Processed,'N') = 'N' AND Title_Code = @TitleCode

			UPDATE AvailData SET Is_Processed = 'P' WHERE ISNULL(Is_Processed,'N') = 'N' AND Title_Code = @TitleCode

			--Exec USPMaintainAvailData @Avail_Data_UDT , @TitleCode

			UPDATE AvailData SET Is_Processed = 'C' WHERE ISNULL(Is_Processed,'N') = 'P' AND Title_Code = @TitleCode
			FETCH NEXT FROM Cur_Title INTO @TitleCode

		END
		CLOSE Cur_Title
		DEALLOCATE Cur_Title

	END

	IF OBJECT_ID('tempdb..#TitleCodes') IS NOT NULL DROP TABLE #TitleCodes

	*/

	DECLARE @Avail_Data_UDT [Avail_Data_UDT]

	INSERT INTO @Avail_Data_UDT(Acq_Deal_Rights_Code,
		[Start_Date],
		End_Date,
		Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, Is_Title_Language,
		Sub_Language_Codes, Dub_Language_Codes, Episode_From, Episode_To, Is_Theatrical) 
	SELECT DISTINCT Acq_Deal_Rights_Code, 
		CASE WHEN  CONVERT(varchar(10),[Start_Date],101) = '01/01/0001' THEN NULL ELSE [Start_Date] END  [Start_Date],
		CASE WHEN  CONVERT(varchar(10),End_Date,101) = '01/01/0001' THEN NULL ELSE End_Date END  End_Date,
		Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, Is_Title_Language,
		Sub_Language_Codes, Dub_Language_Codes, Episode_From, Episode_To, Is_Theatrical
	FROM AvailData (NOLOCK)
	WHERE ISNULL([End_Date], '31-DEC-9999') >= CAST(GETDATE() AS DATE)
	--WHERE Title_Code = 5382

	PRINT 'USPMaintainAvailData - STEP 1'
	
	BEGIN --------------- TABLE DECLARATION

		IF OBJECT_ID('tempdb..#AvailTitlesData') IS NOT NULL DROP TABLE #AvailTitlesData

		CREATE TABLE #AvailTitlesData
		(
			[Acq_Deal_Code] INT,
			[Acq_Deal_Rights_Code] INT,
			[Start_Date] DATE,
			[End_Date] DATE,
			[Is_Exclusive] BIT,
			[Title_Code] INT,
			Episode_FROM int,
			Episode_To int,
			Is_Theatrical bit,
			[Platform_Codes] NVARCHAR(max),
			[Country_Codes] NVARCHAR(max),
			[Is_Title_Language] BIT,
			[Sub_Language_Codes] NVARCHAR(max),
			[Dub_Language_Codes] NVARCHAR(max),
			Avail_Dates_Code INT,
			Avail_Country_Code INT,
			Avail_Platform_Code INT,
			Avail_Subtitling_Code INT,
			Avail_Dubbing_Code INT,
		)

	END

	INSERT INTO #AvailTitlesData(Acq_Deal_Code, Acq_Deal_Rights_Code, [Start_Date], [End_Date], Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, 
										Is_Title_Language, Sub_Language_Codes, Dub_Language_Codes, Episode_FROM, Episode_To, Is_Theatrical)
	SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, [Start_Date], [End_Date], Is_Exclusive, Title_Code, Platform_Codes, Country_Codes, 
		   Is_Title_Language, Sub_Language_Codes, Dub_Language_Codes, Episode_FROM, Episode_To, Is_Theatrical
	FROM @Avail_Data_UDT
	
	PRINT 'USPMaintainAvailData - STEP 2'

	UPDATE #AvailTitlesData SET Platform_Codes = DBO.[UFN_Arrange_Codes](Platform_Codes)
	UPDATE #AvailTitlesData SET Country_Codes = DBO.[UFN_Arrange_Codes](Country_Codes)
	UPDATE #AvailTitlesData SET Sub_Language_Codes = DBO.[UFN_Arrange_Codes](Sub_Language_Codes) WHERE Sub_Language_Codes IS NOT NULL
	UPDATE #AvailTitlesData SET Dub_Language_Codes = DBO.[UFN_Arrange_Codes](Dub_Language_Codes) WHERE Dub_Language_Codes IS NOT NULL

	PRINT 'USPMaintainAvailData - STEP 2.1'
	
	BEGIN ------------ PLATFORM CONVERSION

		UPDATE tmp SET tmp.Avail_Platform_Code = main.Avail_Platform_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Platforms main ON tmp.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

		INSERT INTO Avail_Platforms(Platform_Codes)
		SELECT DISTINCT Platform_Codes FROM #AvailTitlesData 
		WHERE Avail_Platform_Code IS NULL

		UPDATE tmp SET tmp.Avail_Platform_Code  = main.Avail_Platform_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Platforms main ON tmp.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Platform_Codes COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE tmp.Avail_Platform_Code IS NULL

	END
	
	PRINT 'USPMaintainAvailData - STEP 3'
	
	BEGIN ------------ COUNTRY CONVERSION

		UPDATE tmp SET tmp.Avail_Country_Code = main.Avail_Country_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Countries main ON tmp.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

		INSERT INTO Avail_Countries(Country_Codes)
		SELECT DISTINCT Country_Codes FROM #AvailTitlesData 
		WHERE Avail_Country_Code IS NULL

		UPDATE tmp SET tmp.Avail_Country_Code  = main.Avail_Country_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Countries main ON tmp.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE tmp.Avail_Country_Code IS NULL

	END
	
	PRINT 'USPMaintainAvailData - STEP 4'
	
	BEGIN ------------ SUBTITLE LANGUAGE CONVERSION

		UPDATE tmp SET tmp.Avail_Subtitling_Code = main.Avail_Languages_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Languages main ON tmp.Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

		INSERT INTO Avail_Languages(Language_Codes)
		SELECT DISTINCT Sub_Language_Codes FROM #AvailTitlesData 
		WHERE Avail_Subtitling_Code IS NULL AND ISNULL(Sub_Language_Codes, '') <> ''
	
		UPDATE tmp SET tmp.Avail_Subtitling_Code = main.Avail_Languages_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Languages main ON tmp.Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

	END
	
	PRINT 'USPMaintainAvailData - STEP 5'
	
	BEGIN ------------ DUBBING LANGUAGE CONVERSION

		UPDATE tmp SET tmp.Avail_Dubbing_Code = main.Avail_Languages_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Languages main ON tmp.Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

		INSERT INTO Avail_Languages(Language_Codes)
		SELECT DISTINCT Dub_Language_Codes FROM #AvailTitlesData 
		WHERE Avail_Dubbing_Code IS NULL AND ISNULL(Dub_Language_Codes, '') <> ''
	
		UPDATE tmp SET tmp.Avail_Dubbing_Code = main.Avail_Languages_Code 
		FROM #AvailTitlesData tmp 
		INNER JOIN Avail_Languages main ON tmp.Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = main.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

	END
	
	PRINT 'USPMaintainAvailData - STEP 6'
	
	BEGIN ------------ DATE CODE CONVERSION

		UPDATE tad SET tad.Avail_Dates_Code = ad.Avail_Dates_Code 
		FROM #AvailTitlesData tad
		INNER JOIN Avail_Dates ad ON tad.[Start_Date] = ad.[Start_Date] AND ISNULL(tad.[End_Date], '31-DEC-9999') = ISNULL(ad.[End_Date], '31-DEC-9999')
		
		INSERT INTO Avail_Dates
		SELECT DISTINCT [Start_Date], [End_Date] FROM #AvailTitlesData Where ISNULL(Avail_Dates_Code, 0) = 0
		AND ISNULL([End_Date], '31-DEC-9999') >= CAST(GETDATE() AS DATE)
		--AND ([End_Date] IS NULL OR [End_Date] > GETDATE())
					
		UPDATE tad SET tad.Avail_Dates_Code = ad.Avail_Dates_Code 
		FROM #AvailTitlesData tad
		INNER JOIN Avail_Dates ad ON tad.[Start_Date] = ad.[Start_Date] AND ISNULL(tad.[End_Date], '31-DEC-9999') = ISNULL(ad.[End_Date], '31-DEC-9999')

	END
	
	PRINT 'USPMaintainAvailData - Final STEP'
	
	DELETE FROM [dbo].[Avail_Title_Data] WHERE Title_Code IN (
		SELECT Title_Code FROM #AvailTitlesData
	)

	--DELETE FROM [dbo].[Avail_Title_Data] WHERE Acq_Deal_Rights_Code IN (
	--	SELECT Acq_Deal_Rights_Code FROM #AvailTitlesData
	--)

	INSERT INTO [Avail_Title_Data](Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Avail_Dates_Code, Is_Exclusive, 
								   Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code)
	SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Avail_Dates_Code, Is_Exclusive, 
		   Avail_Platform_Code, Avail_Country_Code, Is_Theatrical, Is_Title_Language, Avail_Subtitling_Code, Avail_Dubbing_Code
	FROM #AvailTitlesData
	
	UPDATE atd SET atd.Acq_Deal_Code = adr.Acq_Deal_Code
	FROM Avail_Title_Data atd
	INNER JOIN Acq_Deal_Rights adr ON atd.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
	WHERE ISNULL(atd.Acq_Deal_Code, 0) = 0

	TRUNCATE TABLE AvailData
	
	UPDATE [Avail_Schedule] SET ProcessStatus = 'D', ProcessEndTime = GETDATE() WHERE IntCode = @IntCode

	IF OBJECT_ID('tempdb..#AvailTitlesData') IS NOT NULL DROP TABLE #AvailTitlesData

END

/*

[USPProcessAvailData] 2

*/
