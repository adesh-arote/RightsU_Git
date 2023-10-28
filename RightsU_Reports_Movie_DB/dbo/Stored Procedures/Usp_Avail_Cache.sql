--USE [RightsUExcelUAT_Avail_Movies]
--GO
--/****** Object:  StoredProcedure [dbo].[Usp_Avail_Cache]    Script Date: 06-10-2022 23:43:47 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
----/****** Object:  StoredProcedure [dbo].[Usp_Avail_Cache]    Script Date: 14-06-2022 23:44:48 ******/
----SET ANSI_NULLS ON
----GO
----SET QUOTED_IDENTIFIER ON
----GO
CREATE PROCEDURE [dbo].[Usp_Avail_Cache]
	@Record_Code INT = 416,
	@Record_Type CHAR(1) = 'A'
AS
BEGIN
-- =============================================
-- Author:		Reshma Kunjal / ADESH AROTE
-- Create DATE: 07-April-2015
-- Description:	Cache Acquisition ON deal approval for availability
-- Last Updated By : Reshma Kunjal (FROM PRINT 'AD 1 ') -- 02-May-2016
-- =============================================

	IF OBJECT_ID('tempdb..#Temp_Batch_N') IS NOT NULL DROP TABLE #Temp_Batch_N
	IF OBJECT_ID('tempdb..#Temp_Session_Raw') IS NOT NULL DROP TABLE #Temp_Session_Raw
	IF OBJECT_ID('tempdb..#Temp_Session_Raw_Lang') IS NOT NULL DROP TABLE #Temp_Session_Raw_Lang
	IF OBJECT_ID('tempdb..#Process_Rights') IS NOT NULL DROP TABLE #Process_Rights
	IF OBJECT_ID('tempdb..#Acq_Contry') IS NOT NULL DROP TABLE #Acq_Contry
	IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS_V1') IS NOT NULL DROP TABLE #TMP_ACQ_DETAILS_V1
	IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
	IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
	IF OBJECT_ID('tempdb..#Temp_Session_Raw_Distinct') IS NOT NULL DROP TABLE #Temp_Session_Raw_Distinct
	IF OBJECT_ID('tempdb..#Syn_Territory') IS NOT NULL DROP TABLE #Syn_Territory
	IF OBJECT_ID('tempdb..#Syn_Subtitling') IS NOT NULL DROP TABLE #Syn_Subtitling
	IF OBJECT_ID('tempdb..#Syn_Dubbing') IS NOT NULL DROP TABLE #Syn_Dubbing
	IF OBJECT_ID('tempdb..#Syn_Data') IS NOT NULL DROP TABLE #Syn_Data
	IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data
	IF OBJECT_ID('tempdb..#Syn_Sub_Avail_Data') IS NOT NULL DROP TABLE #Syn_Sub_Avail_Data
	IF OBJECT_ID('tempdb..#Syn_Dub_Avail_Data') IS NOT NULL DROP TABLE #Syn_Dub_Avail_Data
	IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data_SDRC') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data_SDRC
	IF OBJECT_ID('tempdb..#Syn_Sub_Avail_Data_SDRC') IS NOT NULL DROP TABLE #Syn_Sub_Avail_Data_SDRC
	IF OBJECT_ID('tempdb..#Syn_Dub_Avail_Data_SDRC') IS NOT NULL DROP TABLE #Syn_Dub_Avail_Data_SDRC
	IF OBJECT_ID('tempdb..#Temp_Session_Raw_Dist') IS NOT NULL DROP TABLE #Temp_Session_Raw_Dist
	IF OBJECT_ID('tempdb..#Temp_Sub_New') IS NOT NULL DROP TABLE #Temp_Sub_New
	IF OBJECT_ID('tempdb..#Temp_Dub_New') IS NOT NULL DROP TABLE #Temp_Dub_New
	IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL DROP TABLE #Temp_Syndication
	IF OBJECT_ID('tempdb..#Temp_Syndication_Main') IS NOT NULL DROP TABLE #Temp_Syndication_Main
	IF OBJECT_ID('tempdb..#Temp_Syndication_NE') IS NOT NULL DROP TABLE #Temp_Syndication_NE
	IF OBJECT_ID('tempdb..#Temp_Avail_Dates') IS NOT NULL DROP TABLE #Temp_Avail_Dates
	IF OBJECT_ID('tempdb..#Temp_Batch') IS NOT NULL DROP TABLE #Temp_Batch
	IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL DROP TABLE #TMP_ACQ_DETAILS
	IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL DROP TABLE #TMP_Acq_SUBTITLING
	IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL DROP TABLE #TMP_Acq_DUBBING
	IF OBJECT_ID('tempdb..#Temp_Syndication_CE') IS NOT NULL DROP TABLE #Temp_Syndication_CE
	IF OBJECT_ID('tempdb..#Temp_Date_CE') IS NOT NULL DROP TABLE #Temp_Date_CE
	IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL DROP TABLE #Temp_Syndication

	CREATE TABLE #Process_Rights(
		Acq_Deal_Code INT,
		Acq_Deal_Rights_Code INT,
		Sub_License_Code INT,
		Actual_Right_Start_Date DateTime,
		Actual_Right_End_Date DateTime,
		Is_Title_Language_Right CHAR(1), 
		Is_Exclusive CHAR(1), 
		Is_Theatrical_Right CHAR(1)
	)
	
	CREATE TABLE #Temp_Session_Raw(
		Avail_Acq_Code NUMERIC(38, 0),
		Avail_Raw_Code NUMERIC(38, 0),
		Acq_Deal_Code INT,
		Acq_Deal_Rights_Code INT,
		Avail_Dates_Code NUMERIC(38, 0),
		Is_Exclusive INT,
		Episode_From INT,
		Episode_To INT,
		Is_Title_Lang CHAR(1),
		Sub_Languages_Code NUMERIC(38, 0),
		Dub_Languages_Code NUMERIC(38, 0),
		Is_Theatrical_Right CHAR(1)
	)
	
	CREATE TABLE #Temp_Session_Raw_Lang(
		Avail_Acq_Code NUMERIC(38, 0),
		Avail_Raw_Code NUMERIC(38, 0),
		Acq_Deal_Code INT,
		Acq_Deal_Rights_Code INT,
		Avail_Dates_Code NUMERIC(38, 0),
		Is_Exclusive INT,
		Episode_From INT,
		Episode_To INT,
		Language_Codes VARCHAR(Max),
		Rec_Type CHAR(1),
		Avail_Languages_Code NUMERIC(38, 0),
		Is_Theatrical_Right CHAR(1)
	)
	
	CREATE TABLE #Temp_Batch_N(
		Avail_Acq_Code NUMERIC(38,0), 
		Avail_Raw_Code NUMERIC(38,0), 
		Is_Title_Language bit, 
		Sub_Language_Codes VARCHAR(Max), 
		Dub_Language_Codes VARCHAR(Max),
		Sub_Avail_Lang_Code NUMERIC(38, 0), 
		Dub_Avail_Lang_Code NUMERIC(38, 0),
		Is_Theatrical_Right CHAR(1)
	)

	IF(@Record_Type = 'A')
	BEGIN

		INSERT INTO #Process_Rights(Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
									Is_Exclusive, Is_Theatrical_Right)
		SELECT ad.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code,adr.Sub_License_Code,ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,adr.Is_Title_Language_Right
			, adr.Is_Exclusive, adr.Is_Theatrical_Right
			FROM Acq_Deal_Rights adr
			INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code=adr.Acq_Deal_Code
			WHERE ad.Is_Master_Deal='Y'
			AND IsNull(adr.Is_Tentative, 'N')='N'
			AND adr.Is_Sub_License='Y'
			AND adr.Actual_Right_Start_Date Is Not Null --AND adr.Actual_Right_End_Date is not null
			AND adr.Acq_Deal_Code = @Record_Code
			AND (adr.Actual_Right_End_Date is null OR adr.Actual_Right_End_Date > GetDate())
	
	END
	Else
	BEGIN
	
		INSERT INTO #Process_Rights(Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
									Is_Exclusive, Is_Theatrical_Right)
		SELECT ad.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code,adr.Sub_License_Code,ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,adr.Is_Title_Language_Right
			, adr.Is_Exclusive, adr.Is_Theatrical_Right
			FROM Acq_Deal_Rights adr
			INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code=adr.Acq_Deal_Code
			WHERE ad.Is_Master_Deal='Y'
			AND IsNull(adr.Is_Tentative, 'N')='N'
			AND adr.Is_Sub_License='Y'
			AND adr.Actual_Right_Start_Date Is Not Null
			AND (adr.Actual_Right_End_Date is null OR adr.Actual_Right_End_Date > GetDate())
			AND ADR.Acq_Deal_Rights_Code In (
				SELECT Deal_Rights_Code FROM Avail_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Record_Code
				Union
				SELECT Deal_Rights_Code FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Record_Code 
			)

	END

	DECLARE @Theatrical_Code INT = 0, @India_Code INT = 0, @Acq_Deal_Code INT = 0
	SELECT @Theatrical_Code = Cast(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name='THEATRICAL_PLATFORM_CODE'
	SELECT @India_Code = Cast(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name='INDIA_COUNTRY_CODE'

	DECLARE @Acq_Deal_Rights_Code INT = 0, @Sub_License_Code INT = 0, 
			@Actual_Right_Start_Date DateTime, @Actual_Right_End_Date DateTime,
			@Is_Title_Language_Right CHAR(1) = '',
			@Is_Exclusive CHAR(1) = '', @Is_Theatrical_Right CHAR(1)
	
	DELETE FROM Avail_Acq_Details WHERE Avail_Raw_Code In (
		SELECT Avail_Raw_Code FROM Avail_Raw WHERE Acq_Deal_Rights_Code In(
			SELECT Acq_Deal_Rights_Code FROM #Process_Rights
		)
	)

	DELETE FROM Avail_Acq_Theatrical_Details WHERE Avail_Raw_Code In (
		SELECT Avail_Raw_Code FROM Avail_Raw WHERE Acq_Deal_Rights_Code In (
			SELECT Acq_Deal_Rights_Code FROM #Process_Rights
		)
	)

	DECLARE CUR_Rights CURSOR FOR
		SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
			   Is_Exclusive, Is_Theatrical_Right
		FROM #Process_Rights --AND Acq_Deal_Rights_Code = 778
	OPEN CUR_Rights
	FETCH FROM CUR_Rights INTO @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		
		IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL DROP TABLE #TMP_ACQ_DETAILS
		IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL DROP TABLE #TMP_Acq_SUBTITLING
		IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL DROP TABLE #TMP_Acq_DUBBING

		SELECT DISTINCT Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code END Country_Code INTO #Acq_Contry FROM (
			SELECT Acq_Deal_Rights_Code, Territory_Code, Country_Code, Territory_Type 
			FROM Acq_Deal_Rights_Territory  
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS srter
		Left Join Territory_Details td ON srter.Territory_Code = td.Territory_Code
		
		PRINT 'AD 0 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		--INSERT INTO #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Is_Theatrical_Right)
		SELECT DISTINCT ADR.Acq_Deal_Rights_Code, adrt.Title_Code, adrp.Platform_Code, con.Country_Code, @Is_Theatrical_Right Is_Theatrical_Right, 0 Avail_Acq_Code, 'N' Is_Syn
		INTO #TMP_ACQ_DETAILS
		FROM (
			SELECT @Acq_Deal_Rights_Code Acq_Deal_Rights_Code
		) AS adr
		INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Platform adrp ON adrp.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN #Acq_Contry con ON 1 = 1
		
		PRINT 'AD 0.1 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		IF(@Record_Type = 'S')
		BEGIN

			DELETE FROM #TMP_ACQ_DETAILS WHERE Title_Code NOT IN (
				SELECT Title_Code FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code = @Record_Code
			)
			
			DELETE FROM #TMP_ACQ_DETAILS WHERE Platform_Code NOT IN (
				SELECT Platform_Code FROM Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code = @Record_Code
			)
			
			DELETE FROM #TMP_ACQ_DETAILS WHERE Country_Code NOT IN (
				SELECT DISTINCT Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code END FROM (
					SELECT Syn_Deal_Rights_Code, Territory_Code, Country_Code, Territory_Type 
					FROM Syn_Deal_Rights_Territory  
					WHERE Syn_Deal_Rights_Code = @Record_Code
				) AS srter
				Left Join Territory_Details td ON srter.Territory_Code = td.Territory_Code
			)

		END

		Alter Table #TMP_ACQ_DETAILS Add Syn_Rights_Codes VARCHAR(2000)

		PRINT 'AD 1 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		DROP TABLE #Acq_Contry
			
		IF(@Is_Theatrical_Right = 'N')
		BEGIN
			
			--Below query Commented By Reshma
			--Encountered Error : Attempt to FETCH logical page (1:340272) in database 2 failed. It belongs to allocation unit 3026423061692153856 not to 3026418977488633856.
						
			--INSERT INTO #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Is_Theatrical_Right, Avail_Acq_Code, Is_Syn)
			--SELECT adr.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, c.Country_Code, 'Y', 0, 'N'
			--FROM #TMP_ACQ_DETAILS adr
			--INNER JOIN Country c ON adr.Country_Code = c.Parent_Country_Code AND adr.Country_Code = @India_Code
			--AND Platform_Code = @Theatrical_Code
			
			--Below query Added By Reshma till PRINT 'AD 2.1 '
			SELECT adr.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, c.Country_Code, 'Y' AS Is_Theatrical_Right, 0 AS Avail_Acq_Code, 'N' AS Is_Syn
			INTO #TMP_ACQ_DETAILS_V1
			FROM #TMP_ACQ_DETAILS adr
			INNER JOIN Country c ON adr.Country_Code = c.Parent_Country_Code AND adr.Country_Code = @India_Code
			AND Platform_Code = @Theatrical_Code

			INSERT INTO #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Is_Theatrical_Right, Avail_Acq_Code, Is_Syn)
			SELECT adr.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, adr.Country_Code, Is_Theatrical_Right, Avail_Acq_Code, Is_Syn
			FROM #TMP_ACQ_DETAILS_V1 adr

			DROP TABLE #TMP_ACQ_DETAILS_V1

			PRINT 'AD 2.1 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			DELETE FROM #TMP_ACQ_DETAILS WHERE Platform_Code = @Theatrical_Code AND Country_Code = @India_Code

			PRINT 'AD 2.2 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
		END

		CREATE NONCLUSTERED INDEX IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code ON #TMP_ACQ_DETAILS(Acq_Deal_Rights_Code)

		--------- CHECK INTERNATIONAL AVAILABILITY

		UPDATE t Set t.Avail_Acq_Code = a.Avail_Acq_Code FROM #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq a ON t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code AND t.Is_Theatrical_Right = 'N'

		PRINT 'AD 3 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		INSERT INTO Avail_Acq(Title_Code, Platform_Code, Country_Code)
		SELECT Title_Code, Platform_Code, Country_Code FROM #TMP_ACQ_DETAILS WHERE IsNull(Avail_Acq_Code, 0) = 0 AND Is_Theatrical_Right = 'N'

		PRINT 'AD 4 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		UPDATE t Set t.Avail_Acq_Code = a.Avail_Acq_Code FROM #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq a ON t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code  AND IsNull(t.Avail_Acq_Code, 0) = 0 AND t.Is_Theatrical_Right = 'N'

		PRINT 'AD 5 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		---------- END

		--------- CHECK THEATRICAL AVAILABILITY

		UPDATE t Set t.Avail_Acq_Code = a.Avail_Acq_Theatrical_Code FROM #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Theatrical a ON t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code AND t.Is_Theatrical_Right = 'Y'

		PRINT 'AD 6 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		INSERT INTO Avail_Acq_Theatrical(Title_Code, Platform_Code, Country_Code)
		SELECT Title_Code, Platform_Code, Country_Code FROM #TMP_ACQ_DETAILS WHERE IsNull(Avail_Acq_Code, 0) = 0 AND Is_Theatrical_Right = 'Y'

		PRINT 'AD 7 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		UPDATE t Set t.Avail_Acq_Code = a.Avail_Acq_Theatrical_Code FROM #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Theatrical a ON t.Title_Code = a.Title_Code AND t.Platform_Code = a.Platform_Code 
			AND t.Country_Code = a.Country_Code  AND IsNull(t.Avail_Acq_Code, 0) = 0 AND t.Is_Theatrical_Right = 'Y'

		PRINT 'AD 8 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		----------- END

		SELECT DISTINCT CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code END Language_Code, Acq_Deal_Rights_Code INTO #Acq_Sub
		FROM(
			SELECT DISTINCT Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Subtitling
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		PRINT 'AD 9 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		SELECT ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Code, Is_Theatrical_Right, 'N' Is_Syn
		INTO #TMP_Acq_SUBTITLING
		FROM #TMP_ACQ_DETAILS ADR WITH (INDEX(IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code)) 
		INNER JOIN #Acq_Sub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Is_Theatrical_Right = 'N'
		
		Alter Table #TMP_Acq_SUBTITLING Add Syn_Rights_Codes VARCHAR(2000)

		PRINT 'AD 10 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		DROP TABLE #Acq_Sub
		
		SELECT DISTINCT CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code Else adrs.Language_Code END Language_Code, Acq_Deal_Rights_Code INTO #Acq_Dub
		FROM(
			SELECT DISTINCT Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Dubbing
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		PRINT 'AD 12 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		SELECT ADR.Acq_Deal_Rights_Code, adr.Title_Code, adr.Platform_Code, adr.Country_Code, CON.Language_Code, Avail_Acq_Code, Is_Theatrical_Right, 'N' Is_Syn
		INTO #TMP_Acq_DUBBING
		FROM #TMP_ACQ_DETAILS ADR WITH (INDEX(IX_TMP_ACQ_DETAILS_Acq_Deal_Rights_Code)) 
		INNER JOIN #Acq_Dub CON ON CON.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Is_Theatrical_Right = 'N'
		
		Alter Table #TMP_Acq_DUBBING Add Syn_Rights_Codes VARCHAR(2000)

		PRINT 'AD 13 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		--SELECT Getdate()

		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Title_Code ON #TMP_Acq_DUBBING(Title_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Platform_Code ON #TMP_Acq_DUBBING(Platform_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Country_Code ON #TMP_Acq_DUBBING(Country_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_Acq_DUB_Language_Code ON #TMP_Acq_DUBBING(Language_Code)
		CREATE NONCLUSTERED INDEX IX_TMP_Acq_SUBTITLING_DUB_Combine ON #TMP_Acq_DUBBING(Title_Code, Platform_Code, Country_Code, Language_Code)

		PRINT 'AD 14 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

		DROP TABLE #Acq_Dub

		DECLARE @Is_Exclusive_Bit INT = CASE WHEN @Is_Exclusive = 'N' THEN 0 WHEN @Is_Exclusive = 'Y' THEN 1 ELSE 2 END, @Avial_Dates_Code INT = 0

		IF(@Is_Exclusive = 'N')------------ CATCHE THE RECORDS WHICH ARE ACQUIRED EXCLUSIVE NO
		BEGIN

			SELECT @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) FROM [dbo].[Avail_Dates] WHERE [Start_Date] = @Actual_Right_Start_Date AND IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')
			
			IF(@Avial_Dates_Code Is Null OR @Avial_Dates_Code = 0)
			BEGIN
				INSERT INTO [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
				SELECT @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
			END

			TRUNCATE TABLE #Temp_Session_Raw
			TRUNCATE TABLE #Temp_Session_Raw_Lang

			INSERT INTO #Temp_Session_Raw_Lang(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Language_Codes, Rec_Type, Is_Theatrical_Right)
			SELECT DISTINCT Avail_Acq_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Lang, Rec_Type, Is_Theatrical_Right FROM (
				SELECT DISTINCT Avail_Acq_Code, '' Lang, 'T' Rec_Type, Is_Theatrical_Right FROM #TMP_ACQ_DETAILS 
				WHERE @Is_Title_Language_Right = 'Y'
				Union
				SELECT Avail_Acq_Code, ',' + STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT DISTINCT Language_Code FROM #TMP_Acq_SUBTITLING subIn
							WHERE subIn.Avail_Acq_Code = sub.Avail_Acq_Code
								  AND subIn.Is_Theatrical_Right = sub.Is_Theatrical_Right
						) AS a
						FOR XML PATH('')
					), 1, 1, ''
				) + ','
				, 'S', Is_Theatrical_Right FROM (SELECT DISTINCT Avail_Acq_Code, Is_Theatrical_Right FROM #TMP_Acq_SUBTITLING) sub
				Union
				SELECT Avail_Acq_Code, ',' + STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
							SELECT DISTINCT Language_Code FROM #TMP_Acq_DUBBING dubIn
							WHERE dubIn.Avail_Acq_Code = dub.Avail_Acq_Code
								  AND dubIn.Is_Theatrical_Right = dub.Is_Theatrical_Right
						) AS a
						FOR XML PATH('')
					), 1, 1, ''
				) + ','
				, 'D', Is_Theatrical_Right FROM (SELECT DISTINCT Avail_Acq_Code, Is_Theatrical_Right FROM #TMP_Acq_DUBBING) dub
			) AS a
			
			PRINT 'AD 14.2 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			INSERT INTO #Temp_Session_Raw(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right)
			SELECT DISTINCT Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right FROM #Temp_Session_Raw_Lang
			
			INSERT INTO Avail_Languages(Language_Codes)
			SELECT DISTINCT Language_Codes FROM #Temp_Session_Raw_Lang WHERE Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  Not In (
				SELECT a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  FROM Avail_Languages a
			) AND Language_Codes <> ''

			UPDATE temp set temp.Avail_Languages_Code = al.Avail_Languages_Code FROM #Temp_Session_Raw_Lang temp 
			INNER JOIN Avail_Languages al ON temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  
			
			PRINT 'AD 14.3 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			UPDATE t1 Set t1.Is_Title_Lang = 1
			FROM #Temp_Session_Raw t1
			INNER JOIN #Temp_Session_Raw_Lang t2 ON
			t1.Avail_Acq_Code = t2.Avail_Acq_Code AND
			t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
			t1.Is_Exclusive = t2.Is_Exclusive AND
			t1.Is_Theatrical_Right = t2.Is_Theatrical_Right AND
			t2.Rec_Type = 'T'

			PRINT 'AD 14.4 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			UPDATE t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
			FROM #Temp_Session_Raw t1
			INNER JOIN #Temp_Session_Raw_Lang t2 ON
			t1.Avail_Acq_Code = t2.Avail_Acq_Code AND
			t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
			t1.Is_Exclusive = t2.Is_Exclusive AND
			t1.Is_Theatrical_Right = t2.Is_Theatrical_Right AND
			t2.Rec_Type = 'S'

			PRINT 'AD 14.5 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			UPDATE t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
			FROM #Temp_Session_Raw t1
			INNER JOIN #Temp_Session_Raw_Lang t2 ON
			t1.Avail_Acq_Code = t2.Avail_Acq_Code AND
			t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
			t1.Is_Exclusive = t2.Is_Exclusive AND
			t1.Is_Theatrical_Right = t2.Is_Theatrical_Right AND
			t2.Rec_Type = 'D'

			PRINT 'AD 14.6 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			TRUNCATE TABLE #Temp_Session_Raw_Lang

			SELECT DISTINCT traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive
			INTO #Temp_Session_Raw_Distinct
			FROM #Temp_Session_Raw traw

			MERGE INTO Avail_Raw AS araw
			USING #Temp_Session_Raw_Distinct AS traw ON 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
			traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
			traw.Is_Exclusive = araw.Is_Exclusive
			WHEN NOT MATCHED THEN
				INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive)
			;

			DROP TABLE #Temp_Session_Raw_Distinct
				
			PRINT 'AD 14.7 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
			UPDATE traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
			INNER JOIN Avail_Raw araw ON 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
			traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
			traw.Is_Exclusive = araw.Is_Exclusive
			
			PRINT 'AD 14.8 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
	
			INSERT INTO Avail_Acq_Details(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
			SELECT Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code FROM #Temp_Session_Raw WHERE Is_Theatrical_Right = 'N'
			
			PRINT 'AD 14.9 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
	
			INSERT INTO Avail_Acq_Theatrical_Details(Avail_Acq_Theatrical_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
			SELECT Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code FROM #Temp_Session_Raw WHERE Is_Theatrical_Right = 'Y'
			
			PRINT 'AD 14.10 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
	
			TRUNCATE TABLE #Temp_Session_Raw

		END
		Else
		BEGIN
	
			CREATE TABLE #Syn_Title_Avail_Data
			(
				Syn_Deal_Rights_Code INT,
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT
			)

			CREATE TABLE #Syn_Sub_Avail_Data
			(
				Syn_Deal_Rights_Code INT,
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code INT
			)
				
			CREATE TABLE #Syn_Dub_Avail_Data
			(
				Syn_Deal_Rights_Code INT,
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code INT
			)
			
			CREATE TABLE #Syn_Title_Avail_Data_SDRC
			(
				Syn_Deal_Rights_Codes VARCHAR(2000),
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT
			)

			CREATE TABLE #Syn_Sub_Avail_Data_SDRC
			(
				Syn_Deal_Rights_Codes VARCHAR(2000),
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code INT
			)
				
			CREATE TABLE #Syn_Dub_Avail_Data_SDRC
			(
				Syn_Deal_Rights_Codes VARCHAR(2000),
				Title_Code INT, 
				Platform_Code INT, 
				Country_Code INT,
				Language_Code INT
			)

			BEGIN ------------ GENERATE SYNDICATION DATA FOR CURRENT COMBINATION

				SELECT DISTINCT srter.Syn_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code END Country_Code INTO #Syn_Territory 
				FROM (
					SELECT sdrtr.Syn_Deal_Rights_Code, sdrtr.Territory_Code, sdrtr.Country_Code, sdrtr.Territory_Type 
					FROM Syn_Deal_Rights_Territory sdrtr
					WHERE sdrtr.Syn_Deal_Rights_Code In (
						SELECT samIn.Syn_Deal_Rights_Code FROM Syn_Acq_Mapping samIn WHERE samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) AS srter
				Left Join Territory_Details td ON srter.Territory_Code = td.Territory_Code

				PRINT 'AD 15 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				SELECT DISTINCT srsub.Syn_Deal_Rights_Code, Case When srsub.Language_Type = 'G' Then lgd.Language_Code Else srsub.Language_Code END Language_Code INTO #Syn_Subtitling
				FROM (
					SELECT sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					FROM Syn_Deal_Rights_Subtitling sdrs
					WHERE sdrs.Syn_Deal_Rights_Code In (
						SELECT samIn.Syn_Deal_Rights_Code FROM Syn_Acq_Mapping samIn WHERE samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) AS srsub
				Left Join Language_Group_Details lgd ON srsub.Language_Group_Code = lgd.Language_Group_Code

				PRINT 'AD 16 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
		
				SELECT DISTINCT srsub.Syn_Deal_Rights_Code, Case When srsub.Language_Type = 'G' Then lgd.Language_Code Else srsub.Language_Code END Language_Code INTO #Syn_Dubbing
				FROM (
					SELECT sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					FROM Syn_Deal_Rights_Dubbing sdrs
					WHERE sdrs.Syn_Deal_Rights_Code In (
						SELECT samIn.Syn_Deal_Rights_Code FROM Syn_Acq_Mapping samIn WHERE samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) AS srsub
				Left Join Language_Group_Details lgd ON srsub.Language_Group_Code = lgd.Language_Group_Code

				PRINT 'AD 17 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				SELECT DISTINCT sdr.Syn_Deal_Rights_Code, sdr.Is_Exclusive, sdr.Is_Title_Language_Right, sdr.Is_Theatrical_Right, sdr.Actual_Right_Start_Date, 
								sdr.Actual_Right_End_Date, sdrt.Title_Code, sdrp.Platform_Code, synter.Country_Code 
				INTO #Syn_Data
				FROM Syn_Deal_Rights sdr 
				INNER JOIN Syn_Acq_Mapping sam ON sam.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code AND Deal_Rights_Code = @Acq_Deal_Rights_Code AND sdr.Actual_Right_Start_Date Is Not Null AND ISNULL(sdr.Actual_Right_End_Date,'31-DEC-9999') >= Cast(GetDate() AS Date)
				INNER JOIN Syn_Deal_Rights_Title sdrt ON sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				INNER JOIN Syn_Deal_Rights_Platform sdrp ON sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
				INNER JOIN #Syn_Territory synter ON sdr.Syn_Deal_Rights_Code = synter.Syn_Deal_Rights_Code
				INNER JOIN #TMP_ACQ_DETAILS adr ON sdrt.Title_Code = adr.Title_Code AND adr.Platform_Code = sdrp.Platform_Code AND adr.Country_Code = synter.Country_Code
				--WHERE Actual_Right_Start_Date Is Not Null --AND Is_Title_Language_Right = 'Y' --AND Is_Theatrical_Right = 'N'
				--AND sdrt.Title_Code In (
				--	SELECT adr.Title_Code FROM #TMP_ACQ_DETAILS adr WHERE adr.Platform_Code = sdrp.Platform_Code AND adr.Country_Code = synter.Country_Code
				--)

				PRINT 'AD 18 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				DROP TABLE #Syn_Territory

				INSERT INTO #Syn_Title_Avail_Data(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code)
				SELECT DISTINCT Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code 
				FROM #Syn_Data WHERE Is_Title_Language_Right = 'Y'
		
				PRINT 'AD 19 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				INSERT INTO #Syn_Sub_Avail_Data(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Language_Code)
				SELECT DISTINCT syn.Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, sdrs.Language_Code
				FROM #Syn_Data syn
				INNER JOIN #Syn_Subtitling sdrs ON syn.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code

				DROP TABLE #Syn_Subtitling

				INSERT INTO #Syn_Dub_Avail_Data(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, Language_Code)
				SELECT DISTINCT syn.Syn_Deal_Rights_Code, Title_Code, Platform_Code, Country_Code, sdrd.Language_Code
				FROM #Syn_Data syn
				INNER JOIN #Syn_Dubbing sdrd ON syn.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code

				PRINT 'AD 21 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				DROP TABLE #Syn_Dubbing
				DROP TABLE #Syn_Data

			END ------------ END
		
			INSERT INTO #Syn_Title_Avail_Data_SDRC(Syn_Deal_Rights_Codes, Title_Code, Platform_Code, Country_Code)
			SELECT STUFF
			(
				(
					SELECT DISTINCT ',' + CAST(Syn_Deal_Rights_Code AS VARCHAR) FROM #Syn_Title_Avail_Data b
					WHERE tmp.Title_Code = b.Title_Code 
						AND tmp.Country_Code = b.Country_Code 
						AND tmp.Platform_Code = b.Platform_Code
					FOR XML PATH('')
				), 1, 1, ''
			) SCodes, Title_Code, Platform_Code, Country_Code 
			FROM (
				SELECT DISTINCT Title_Code, Platform_Code, Country_Code FROM #Syn_Title_Avail_Data
			) AS tmp
			
			INSERT INTO #Syn_Sub_Avail_Data_SDRC(Syn_Deal_Rights_Codes, Title_Code, Platform_Code, Country_Code, Language_Code)
			SELECT STUFF
			(
				(
					SELECT DISTINCT ',' + CAST(Syn_Deal_Rights_Code AS VARCHAR) FROM #Syn_Sub_Avail_Data b
					WHERE tmp.Title_Code = b.Title_Code 
						AND tmp.Country_Code = b.Country_Code 
						AND tmp.Platform_Code = b.Platform_Code
						AND b.Language_Code = tmp.Language_Code
					FOR XML PATH('')
				), 1, 1, ''
			) SCodes, Title_Code, Platform_Code, Country_Code, Language_Code
			FROM (
				SELECT DISTINCT Title_Code, Platform_Code, Country_Code, Language_Code FROM #Syn_Sub_Avail_Data
			) AS tmp
			
			INSERT INTO #Syn_Dub_Avail_Data_SDRC(Syn_Deal_Rights_Codes, Title_Code, Platform_Code, Country_Code, Language_Code)
			SELECT STUFF
			(
				(
					SELECT DISTINCT ',' + CAST(Syn_Deal_Rights_Code AS VARCHAR) FROM #Syn_Dub_Avail_Data b
					WHERE tmp.Title_Code = b.Title_Code 
						AND tmp.Country_Code = b.Country_Code 
						AND tmp.Platform_Code = b.Platform_Code
						AND b.Language_Code = tmp.Language_Code
					FOR XML PATH('')
				), 1, 1, ''
			) SCodes, Title_Code, Platform_Code, Country_Code, Language_Code
			FROM (
				SELECT DISTINCT Title_Code, Platform_Code, Country_Code, Language_Code FROM #Syn_Dub_Avail_Data
			) AS tmp
			
			DROP TABLE #Syn_Title_Avail_Data
			DROP TABLE #Syn_Sub_Avail_Data
			DROP TABLE #Syn_Dub_Avail_Data

			UPDATE tmp Set Is_Syn = 'Y', Syn_Rights_Codes = Syn_Deal_Rights_Codes
			FROM #TMP_ACQ_DETAILS tmp
			INNER JOIN #Syn_Title_Avail_Data_SDRC syn ON syn.Title_Code = tmp.Title_Code AND 
					   syn.Platform_Code = tmp.Platform_Code AND
					   syn.Country_Code = tmp.Country_Code
					   --AND syn.Is_Title_Language_Right = 'Y'
					   
			PRINT 'AD 22 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			--SELECT * FROM #TMP_ACQ_DETAILS WHERE Platform_Code IN (22, 23)

			UPDATE tmp Set Is_Syn = 'Y', Syn_Rights_Codes = Syn_Deal_Rights_Codes
			FROM #TMP_Acq_SUBTITLING tmp
			INNER JOIN #Syn_Sub_Avail_Data_SDRC syn ON syn.Title_Code = tmp.Title_Code AND 
					   syn.Platform_Code = tmp.Platform_Code AND
					   syn.Country_Code = tmp.Country_Code AND 
					   syn.Language_Code = tmp.Language_Code

			PRINT 'AD 23 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
			UPDATE tmp Set Is_Syn = 'Y', Syn_Rights_Codes = Syn_Deal_Rights_Codes
			FROM #TMP_Acq_DUBBING tmp
			INNER JOIN #Syn_Dub_Avail_Data_SDRC syn ON syn.Title_Code = tmp.Title_Code AND 
					   syn.Platform_Code = tmp.Platform_Code AND
					   syn.Country_Code = tmp.Country_Code AND 
					   syn.Language_Code = tmp.Language_Code

			DROP TABLE #Syn_Title_Avail_Data_SDRC
			DROP TABLE #Syn_Sub_Avail_Data_SDRC
			DROP TABLE #Syn_Dub_Avail_Data_SDRC

			PRINT 'AD 24 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
			CREATE TABLE #Temp_Batch
			(
				Syn_Rights_Codes VARCHAR(2000),
				Rec_Type CHAR(1)
			)

			INSERT INTO #Temp_Batch
			SELECT DISTINCT Syn_Rights_Codes, 'T' FROM #TMP_ACQ_DETAILS WHERE Is_Syn = 'Y'
			
			INSERT INTO #Temp_Batch
			SELECT DISTINCT Syn_Rights_Codes, 'S' FROM #TMP_Acq_SUBTITLING WHERE Is_Syn = 'Y'
			
			INSERT INTO #Temp_Batch
			SELECT DISTINCT Syn_Rights_Codes, 'D' FROM #TMP_Acq_DUBBING WHERE Is_Syn = 'Y'

			PRINT 'AD 25 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

			IF(IsNull(@Actual_Right_End_Date, '31Dec9999') > GetDate()) ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED
			BEGIN
			
				SELECT @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) FROM [dbo].[Avail_Dates] WHERE [Start_Date] = @Actual_Right_Start_Date AND IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')
			
				IF(@Avial_Dates_Code Is Null OR @Avial_Dates_Code = 0)
				BEGIN
					INSERT INTO [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
					SELECT @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
				END

				TRUNCATE TABLE #Temp_Session_Raw
				TRUNCATE TABLE #Temp_Session_Raw_Lang
				
				PRINT 'AD 25.1 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				INSERT INTO #Temp_Session_Raw_Lang(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Language_Codes, Rec_Type, Is_Theatrical_Right)
				SELECT DISTINCT Avail_Acq_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Lang, Rec_Type, Is_Theatrical_Right FROM (
					SELECT DISTINCT Avail_Acq_Code, '' Lang, 'T' Rec_Type, Is_Theatrical_Right FROM #TMP_ACQ_DETAILS 
					WHERE @Is_Title_Language_Right = 'Y' AND Is_Syn <> 'Y'
					Union
					SELECT Avail_Acq_Code, ',' + STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT DISTINCT Language_Code FROM #TMP_Acq_SUBTITLING subIn
								WHERE subIn.Avail_Acq_Code = sub.Avail_Acq_Code
									  AND subIn.Is_Theatrical_Right = sub.Is_Theatrical_Right
									  AND subIn.Is_Syn <> 'Y'
							) AS a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'S', Is_Theatrical_Right FROM (SELECT DISTINCT Avail_Acq_Code, Is_Theatrical_Right FROM #TMP_Acq_SUBTITLING WHERE Is_Syn <> 'Y') sub
					Union
					SELECT Avail_Acq_Code, ',' + STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT DISTINCT Language_Code FROM #TMP_Acq_DUBBING dubIn
								WHERE dubIn.Avail_Acq_Code = dub.Avail_Acq_Code
									  AND dubIn.Is_Theatrical_Right = dub.Is_Theatrical_Right
									  AND dubIn.Is_Syn <> 'Y'
							) AS a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'D', Is_Theatrical_Right FROM (SELECT DISTINCT Avail_Acq_Code, Is_Theatrical_Right FROM #TMP_Acq_DUBBING WHERE Is_Syn <> 'Y') dub
				) AS a
				
				INSERT INTO #Temp_Session_Raw(Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right)
				SELECT DISTINCT Avail_Acq_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Is_Theatrical_Right FROM #Temp_Session_Raw_Lang
			
				PRINT 'AD 25.2 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				--UPDATE #Temp_Session_Raw_Lang Set Language_Codes = ',' + Language_Codes + ',' WHERE IsNull(Language_Codes, '') <> ''
				
				INSERT INTO Avail_Languages(Language_Codes)
				SELECT DISTINCT Language_Codes FROM #Temp_Session_Raw_Lang WHERE Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS Not In (
					SELECT a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS FROM Avail_Languages a
				) AND Language_Codes <> ''

				PRINT 'ad 25.2.1'

				UPDATE temp set temp.Avail_Languages_Code  = al.Avail_Languages_Code FROM #Temp_Session_Raw_Lang temp 
				INNER JOIN Avail_Languages al ON temp.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS= al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS

				PRINT 'AD 25.3 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
				UPDATE t1 Set t1.Is_Title_Lang = 1
				FROM #Temp_Session_Raw t1
				INNER JOIN #Temp_Session_Raw_Lang t2 ON
				t1.Avail_Acq_Code = t2.Avail_Acq_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Is_Theatrical_Right = t2.Is_Theatrical_Right AND
				t2.Rec_Type = 'T'

				PRINT 'AD 25.4 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
				UPDATE t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
				FROM #Temp_Session_Raw t1
				INNER JOIN #Temp_Session_Raw_Lang t2 ON
				t1.Avail_Acq_Code = t2.Avail_Acq_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Is_Theatrical_Right = t2.Is_Theatrical_Right AND
				t2.Rec_Type = 'S'


				PRINT 'AD 25.5 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
				UPDATE t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
				FROM #Temp_Session_Raw t1
				INNER JOIN #Temp_Session_Raw_Lang t2 ON
				t1.Avail_Acq_Code = t2.Avail_Acq_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Is_Theatrical_Right = t2.Is_Theatrical_Right AND
				t2.Rec_Type = 'D'

				PRINT 'AD 25.6 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

				TRUNCATE TABLE #Temp_Session_Raw_Lang
				
				DELETE FROM #Temp_Session_Raw WHERE Avail_Dates_Code = 0

				SELECT DISTINCT traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive
				INTO #Temp_Session_Raw_Dist
				FROM #Temp_Session_Raw traw

				MERGE INTO Avail_Raw AS araw
				USING #Temp_Session_Raw_Dist AS traw ON 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
				traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
				traw.Is_Exclusive = araw.Is_Exclusive
				WHEN NOT MATCHED THEN
					INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive)
				;

				DROP TABLE #Temp_Session_Raw_Dist
				
				PRINT 'AD 25.7 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
				UPDATE traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
				INNER JOIN Avail_Raw araw ON 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
				traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
				traw.Is_Exclusive = araw.Is_Exclusive
			
				PRINT 'AD 25.8 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
				INSERT INTO Avail_Acq_Details(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
				SELECT Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code FROM #Temp_Session_Raw WHERE Is_Theatrical_Right = 'N'
			

				PRINT 'AD 25.9 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
				
				INSERT INTO Avail_Acq_Theatrical_Details(Avail_Acq_Theatrical_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
				SELECT Avail_Acq_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code FROM #Temp_Session_Raw WHERE Is_Theatrical_Right = 'Y'
			
				PRINT 'AD 26 ' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
	
				--SELECT * FROM #Temp_Session_Raw WHERE Avail_Acq_Code = 954581

				TRUNCATE TABLE #Temp_Session_Raw
				--return
			END

			CREATE TABLE #Temp_Syndication_Main
			(
				INTCode INT Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive CHAR(1)
			)

			CREATE TABLE #Temp_Syndication_NE
			(
				INTCode INT Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive CHAR(1),
				Group_Code DateTime
			)

			CREATE TABLE #Temp_Syndication
			(
				INTCode INT Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive CHAR(1)
			)

			CREATE TABLE #Temp_Avail_Dates
			(
				INTCode INT Identity,
				AvailStartDate DateTime,
				AvailEndDate DateTime,
				Is_Exclusive CHAR(1),
				Avial_Dates_Code INT
			)

			CREATE TABLE #Temp_Syndication_CE
			(
				INTCode INT Identity,
				Start_Date DateTime,
				End_Date DateTime,
				CECounter INT
			)

			CREATE TABLE #Temp_Date_CE
			(
				INTCode INT Identity,
				CEDate DateTime,
			)

			BEGIN ------------- EXECUTION FOR SYNDICATION AVAILABLE RECORDS FOR EXCLUSIVE & NON-EXCLUSIVE
			
				DECLARE @Syn_Rights_Codes VARCHAR(2000) = '', @IsCoExDeleted CHAR(1) = 'N'
				DECLARE Cur_Batch CURSOR FOR SELECT DISTINCT Syn_Rights_Codes FROM #Temp_Batch
				OPEN Cur_Batch
				FETCH NEXT FROM Cur_Batch INTO @Syn_Rights_Codes
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
					
					TRUNCATE TABLE #Temp_Batch_N
					TRUNCATE TABLE #Temp_Syndication
					TRUNCATE TABLE #Temp_Syndication_Main
					TRUNCATE TABLE #Temp_Syndication_NE
					TRUNCATE TABLE #Temp_Avail_Dates
					TRUNCATE TABLE #Temp_Date_CE
					TRUNCATE TABLE #Temp_Syndication_CE
					SET @IsCoExDeleted = 'N'
					
					INSERT INTO #Temp_Syndication_Main
					SELECT Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive
					FROM Syn_Deal_Rights sdr
					INNER JOIN DBO.fn_Split_withdelemiter(@Syn_Rights_Codes, ',') d ON sdr.Syn_Deal_Rights_Code = d.number
					ORDER BY Actual_Right_Start_Date ASC

					BEGIN -------NON - EXCLUSIVE DATE CALCULATION

						INSERT INTO #Temp_Syndication_NE(Start_Date, End_Date, Is_Exclusive)
						SELECT Start_Date, End_Date, Is_Exclusive FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'N' ORDER BY Start_Date ASC
	
						UPDATE t2 Set t2.Group_Code = (
							SELECT MIN(t1.Start_Date) FROM #Temp_Syndication_NE t1 
							WHERE 
							t1.Start_Date BETWEEN t2.Start_Date AND t2.End_Date OR
							t1.End_Date BETWEEN t2.Start_Date AND t2.End_Date OR 
							t2.Start_Date BETWEEN t1.Start_Date AND t1.End_Date OR
							t2.End_Date BETWEEN t1.Start_Date AND t1.End_Date
						) FROM #Temp_Syndication_NE t2

					END

					BEGIN -------CO - EXCLUSIVE DATE CALCULATION

						INSERT INTO #Temp_Date_CE(CEDate)
						SELECT Start_Date FROM (
							SELECT Start_Date FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'C'
							UNION
							SELECT CASE WHEN End_Date IS NULL OR End_Date = '31-DEC-9999' THEN '31-DEC-9999' ELSE DATEADD(d, 1, End_Date) END FROM #Temp_Syndication_Main 
							WHERE Is_Exclusive = 'C'
						) AS a ORDER BY Start_Date

						INSERT INTO #Temp_Syndication_CE(Start_Date, End_Date, CECounter)
						SELECT * FROM (
							SELECT t1.CEDate [Start_Date], DATEADD(d, -1, t2.CEDate) [End_Date], 0 [Cnt]
							FROM #Temp_Date_CE t1 
							LEFT JOIN #Temp_Date_CE t2 ON t1.INTCode = (t2.INTCode - 1) 
						) AS a WHERE [End_Date] IS NOT NULL

						DECLARE @CEINTCode INT = 0
						DECLARE Cur_CE CURSOR FOR SELECT INTCode FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'C' --FROM #Temp_Syndication_CE
						OPEN Cur_CE
						FETCH NEXT FROM Cur_CE INTO @CEINTCode
						WHILE (@@FETCH_STATUS = 0)
						BEGIN

							UPDATE ce SET ce.CECounter = ce.CECounter + 1
							FROM #Temp_Syndication_CE ce
							INNER JOIN #Temp_Syndication_Main tm ON 
									   ce.Start_Date BETWEEN tm.Start_Date AND tm.End_Date OR
									   ce.End_Date BETWEEN tm.Start_Date AND tm.End_Date OR
									   tm.Start_Date BETWEEN ce.Start_Date AND ce.End_Date OR
									   tm.End_Date BETWEEN ce.Start_Date AND ce.End_Date
							WHERE tm.Is_Exclusive = 'C' AND tm.INTCode = @CEINTCode

							FETCH NEXT FROM Cur_CE INTO @CEINTCode
						END
						CLOSE Cur_CE
						DEALLOCATE Cur_CE
						
						DELETE FROM #Temp_Syndication_CE WHERE CECounter = 0
						
						DECLARE @MaxCoExclusiveSynAllowed INT = 10000
						SELECT @MaxCoExclusiveSynAllowed = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'MaxCoExclusiveSynAllowed'

						DELETE FROM #Temp_Syndication_CE WHERE CECounter > @MaxCoExclusiveSynAllowed

						IF(
							(SELECT COUNT(*) FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'C') > 0 AND
							(SELECT COUNT(*) FROM #Temp_Syndication_CE) = 0
						)
						BEGIN
							SET @IsCoExDeleted = 'Y'
						END
					END
					
					--SELECT @Syn_Rights_Codes, * FROM #Temp_Syndication_Main
					--SELECT Start_Date, End_Date FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'C'
					--SELECT MIN(Start_Date), MAX(End_Date) FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'C'

					INSERT INTO #Temp_Syndication
					SELECT * FROM (
						SELECT Start_Date, End_Date, Is_Exclusive FROM #Temp_Syndication_Main WHERE Is_Exclusive IN ('Y')
						UNION ALL
						SELECT MIN(Start_Date) Start_Date, MAX(End_Date) End_Date, 'C' FROM #Temp_Syndication_Main WHERE Is_Exclusive IN ('C')
						UNION ALL
						SELECT MIN(Start_Date) Start_Date, Max(End_Date) End_Date, 'N' FROM #Temp_Syndication_NE Group By Group_Code
					) AS a WHERE Start_Date IS NOT NULL
					ORDER BY Start_Date ASC
					
					--SELECT @Syn_Rights_Codes, * FROM #Temp_Syndication

					IF((SELECT count(*) FROM #Temp_Syndication) = 0)
					BEGIN
						IF(@IsCoExDeleted = 'N')
						BEGIN
							INSERT INTO #Temp_Avail_Dates
							SELECT @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Exclusive, 0 
						END
						ELSE IF EXISTS(SELECT TOP 1 * FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'C')
						BEGIN

							DECLARE @MinCEDate DATE, @MaxCEDate DATE
							SELECT @MinCEDate = MIN(Start_Date), @MaxCEDate = MAX(End_Date) FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'C'
							
							INSERT INTO #Temp_Avail_Dates
							SELECT @Actual_Right_Start_Date, DATEADD(D, -1, @MinCEDate), @Is_Exclusive, 0 
							UNION
							SELECT DATEADD(D, 1, @MaxCEDate), @Actual_Right_End_Date, @Is_Exclusive, 0 
			
						END
					END
					Else
					BEGIN
						INSERT INTO #Temp_Avail_Dates
						SELECT *, 'Y', 0 FROM (
							SELECT 
								Case When t2.Start_Date Is Null Then @Actual_Right_Start_Date Else DateAdd(d, 1, t2.End_Date) END AvailStartDate,
								DateAdd(d, -1, t1.Start_Date) AvailEndDate
							FROM #Temp_Syndication t1 Left Join #Temp_Syndication t2 ON t1.INTCode = (t2.INTCode + 1) 
						) AS a WHERE datediff(d, AvailStartDate, AvailEndDate) >= 0

						DECLARE @MaxEndDate DateTime = Null
						SELECT TOP 1 @MaxEndDate = End_Date FROM #Temp_Syndication ORDER BY [Start_Date] Desc
						IF((datediff(d, @MaxEndDate, @Actual_Right_End_Date)  < 0 OR @MaxEndDate Is Not Null) AND (@MaxEndDate <> isnull(@Actual_Right_End_Date,'')))
						BEGIN
							INSERT INTO #Temp_Avail_Dates
							SELECT DATEADD(d, 1, @MaxEndDate), @Actual_Right_End_Date, 'Y', 0
						END
		
						INSERT INTO #Temp_Avail_Dates
						SELECT Start_Date, End_Date, 'N', 0 FROM #Temp_Syndication WHERE Is_Exclusive = 'N'

						INSERT INTO #Temp_Avail_Dates
						SELECT Start_Date, End_Date, 'C', 0 FROM #Temp_Syndication_CE
					END
					
					DELETE FROM #Temp_Avail_Dates WHERE AvailStartDate > AvailEndDate

					PRINT 'AD 31 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
					UPDATE tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code FROM #Temp_Avail_Dates tad
					INNER JOIN Avail_Dates ad ON tad.AvailStartDate = ad.Start_Date AND IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

					INSERT INTO Avail_Dates
					SELECT DISTINCT AvailStartDate, AvailEndDate FROM #Temp_Avail_Dates WHERE IsNull(Avial_Dates_Code, 0) = 0
					AND (AvailEndDate is null OR AvailEndDate > GetDate())
					
					UPDATE tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code FROM #Temp_Avail_Dates tad
					INNER JOIN Avail_Dates ad ON tad.AvailStartDate = ad.Start_Date AND IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

					DELETE FROM #Temp_Avail_Dates WHERE Avial_Dates_Code Is Null

					TRUNCATE TABLE #Temp_Session_Raw

					INSERT INTO #Temp_Session_Raw(Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive)
					SELECT @Acq_Deal_Code, @Acq_Deal_Rights_Code, a.Avial_Dates_Code, Case When a.Is_Exclusive = 'N' Then 0 When a.Is_Exclusive = 'Y' Then 1 Else 2 END 
					FROM #Temp_Avail_Dates a

					UPDATE traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
					INNER JOIN Avail_Raw araw ON 
					traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
					traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
					traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
					traw.Is_Exclusive = araw.Is_Exclusive
						
					DELETE FROM #Temp_Session_Raw WHERE Avail_Dates_Code = 0

					INSERT INTO Avail_Raw
					SELECT DISTINCT Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive FROM #Temp_Session_Raw 
					WHERE IsNull(Avail_Raw_Code, 0) = 0

					UPDATE traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
					INNER JOIN Avail_Raw araw ON 
					traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
					traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
					traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
					traw.Is_Exclusive = araw.Is_Exclusive AND 
					IsNull(traw.Avail_Raw_Code, 0) = 0

					--SELECT * FROM #Temp_Avail_Dates
					TRUNCATE TABLE #Temp_Batch_N
					IF EXISTS(SELECT TOP 1 * FROM #Temp_Avail_Dates)
					BEGIN

						DECLARE @Is_Tit_Language bit = 0, @Sub_Lang VARCHAR(Max) = '', @Dub_Lung VARCHAR(Max) = ''

						IF EXISTS(SELECT TOP 1 * FROM #Temp_Batch WHERE Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'T')
						BEGIN

							IF(@Is_Title_Language_Right = 'Y')
							BEGIN
								--------------- INTERNATIONAL
			
								INSERT INTO #Temp_Batch_N(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Is_Theatrical_Right)
								SELECT t.Avail_Acq_Code, a.Avail_Raw_Code, 1, t.Is_Theatrical_Right
								FROM #TMP_ACQ_DETAILS t 
								INNER JOIN #Temp_Session_Raw AS a ON 1 = 1
								WHERE t.Is_Syn = 'Y' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 

								PRINT 'AD 32 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

								--------------- END
							END
						END
					
						IF EXISTS(SELECT TOP 1 * FROM #Temp_Batch WHERE Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'S')
						BEGIN
							--------------- INTERNATIONAL

							SELECT t.Avail_Acq_Code, a.Avail_Raw_Code, 
									t.Language_Code, t.Is_Theatrical_Right INTO #Temp_Sub_New
							FROM #TMP_Acq_SUBTITLING t
							INNER JOIN #Temp_Session_Raw AS a ON 1 = 1
							WHERE t.Is_Syn = 'Y' AND t.Syn_Rights_Codes = @Syn_Rights_Codes

							PRINT '32.1'
							MERGE INTO #Temp_Batch_N AS tb
							USING (
								SELECT *, 
								STUFF(
									(
										SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
											SELECT DISTINCT Language_Code FROM #Temp_Sub_New subIn
											WHERE subIn.Avail_Acq_Code = a.Avail_Acq_Code AND subIn.Avail_Raw_Code = a.Avail_Raw_Code
												  AND subIn.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  = a.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  
										) AS a
										FOR XML PATH('')
									), 1, 1, ''
								) AS Sub_Lang
								FROM(
									SELECT DISTINCT tsn.Avail_Acq_Code, tsn.Avail_Raw_Code, tsn.Is_Theatrical_Right FROM #Temp_Sub_New tsn
								) AS a
							) AS temp ON tb.Avail_Acq_Code = temp.Avail_Acq_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code AND tb.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  = temp.Is_Theatrical_Right COLLATE SQL_Latin1_General_CP1_CI_AS  
							When MATCHED THEN
								UPDATE SET tb.Sub_Language_Codes = temp.Sub_Lang
							When NOT MATCHED THEN
								INSERT VALUES (temp.Avail_Acq_Code, temp.Avail_Raw_Code, 0, temp.Sub_Lang, Null, Null, Null, temp.Is_Theatrical_Right)
							;

							DROP TABLE #Temp_Sub_New

							PRINT 'AD 34 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

							--------------- END
						
						END
					
						IF EXISTS(SELECT TOP 1 * FROM #Temp_Batch WHERE Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'D')
						BEGIN
						
							SELECT t.Avail_Acq_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									t.Language_Code, t.Is_Theatrical_Right INTO #Temp_Dub_New
							FROM #TMP_Acq_DUBBING t
							INNER JOIN #Temp_Session_Raw AS a ON 1 = 1
							WHERE t.Is_Syn = 'Y' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 

							MERGE INTO #Temp_Batch_N AS tb
							USING (
								SELECT *, 
								STUFF(
									(
										SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
											SELECT DISTINCT Language_Code FROM #Temp_Dub_New subIn
											WHERE subIn.Avail_Acq_Code = a.Avail_Acq_Code AND subIn.Avail_Raw_Code = a.Avail_Raw_Code
												  AND subIn.Is_Theatrical_Right = a.Is_Theatrical_Right
										) AS a
										FOR XML PATH('')
									), 1, 1, ''
								) AS Dub_Lang
								FROM(
									SELECT DISTINCT tsn.Avail_Acq_Code, tsn.Avail_Raw_Code, tsn.Is_Theatrical_Right FROM #Temp_Dub_New tsn
								) AS a
							) AS temp ON tb.Avail_Acq_Code = temp.Avail_Acq_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code
							When MATCHED THEN
								UPDATE SET tb.Dub_Language_Codes = temp.Dub_Lang
							When NOT MATCHED THEN
								INSERT VALUES (temp.Avail_Acq_Code, temp.Avail_Raw_Code, 0, Null, temp.Dub_Lang, Null, Null, temp.Is_Theatrical_Right)
							;

							DROP TABLE #Temp_Dub_New
							PRINT 'AD 36 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)

							-------------- END
		
						END

						UPDATE #Temp_Batch_N Set Sub_Language_Codes = ',' + Sub_Language_Codes + ',' WHERE IsNull(Sub_Language_Codes, '') <> ''
						UPDATE #Temp_Batch_N Set Dub_Language_Codes = ',' + Dub_Language_Codes + ',' WHERE IsNull(Dub_Language_Codes, '') <> ''

						INSERT INTO Avail_Languages(Language_Codes)
						SELECT DISTINCT Sub_Language_Codes FROM #Temp_Batch_N WHERE Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   Not In (
							SELECT a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   FROM Avail_Languages a
						) AND IsNull(Sub_Language_Codes, '') <> ''

						UPDATE temp set temp.Sub_Avail_Lang_Code = al.Avail_Languages_Code FROM #Temp_Batch_N temp 
						INNER JOIN Avail_Languages al ON temp.Sub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

						INSERT INTO Avail_Languages(Language_Codes)
						SELECT DISTINCT Dub_Language_Codes FROM #Temp_Batch_N WHERE Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   Not In (
							SELECT a.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   FROM Avail_Languages a
						) AND IsNull(Dub_Language_Codes, '') <> ''

						UPDATE temp set temp.Dub_Avail_Lang_Code = al.Avail_Languages_Code FROM #Temp_Batch_N temp 
						INNER JOIN Avail_Languages al ON temp.Dub_Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = al.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

						--SELECT * FROM #Temp_Batch_N

						INSERT INTO Avail_Acq_Details(Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
						SELECT Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Avail_Lang_Code, Dub_Avail_Lang_Code FROM #Temp_Batch_N WHERE Is_Theatrical_Right = 'N'

						INSERT INTO Avail_Acq_Theatrical_Details(Avail_Acq_Theatrical_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
						SELECT Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Avail_Lang_Code, Dub_Avail_Lang_Code FROM #Temp_Batch_N WHERE Is_Theatrical_Right = 'Y'
						
						TRUNCATE TABLE #Temp_Batch_N
						TRUNCATE TABLE #Temp_Syndication
						TRUNCATE TABLE #Temp_Syndication_Main
						TRUNCATE TABLE #Temp_Syndication_NE
						TRUNCATE TABLE #Temp_Avail_Dates
						--TRUNCATE TABLE #Temp_Syndication_CE
						--TRUNCATE TABLE #Temp_Date_CE
					END
					FETCH NEXT FROM Cur_Batch INTO @Syn_Rights_Codes
				END
				CLOSE Cur_Batch
				DEALLOCATE Cur_Batch

			END

			PRINT 'AD 38 -' + @Syn_Rights_Codes + '-' + Cast(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + Convert(VARCHAR(100), Getdate(), 109)
			
		END
		
		TRUNCATE TABLE #Temp_Batch_N
		TRUNCATE TABLE #Temp_Session_Raw
		TRUNCATE TABLE #Temp_Session_Raw_Lang

		IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL DROP TABLE #Temp_Syndication
		IF OBJECT_ID('tempdb..#Temp_Syndication_Main') IS NOT NULL DROP TABLE #Temp_Syndication_Main
		IF OBJECT_ID('tempdb..#Temp_Syndication_NE') IS NOT NULL DROP TABLE #Temp_Syndication_NE
		IF OBJECT_ID('tempdb..#Temp_Avail_Dates') IS NOT NULL DROP TABLE #Temp_Avail_Dates
		IF OBJECT_ID('tempdb..#Temp_Batch') IS NOT NULL DROP TABLE #Temp_Batch
		IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL DROP TABLE #TMP_ACQ_DETAILS
		IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL DROP TABLE #TMP_Acq_SUBTITLING
		IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL DROP TABLE #TMP_Acq_DUBBING
		IF OBJECT_ID('tempdb..#Temp_Syndication_CE') IS NOT NULL DROP TABLE #Temp_Syndication_CE
		IF OBJECT_ID('tempdb..#Temp_Date_CE') IS NOT NULL DROP TABLE #Temp_Date_CE

		--Return

		FETCH FROM CUR_Rights INTO @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	END
	CLOSE CUR_Rights
	DEALLOCATE CUR_Rights

	IF(@Record_Type = 'S')
	BEGIN

		DELETE FROM Avail_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Record_Code

		INSERT INTO Avail_Syn_Acq_Mapping(Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
		SELECT Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
		FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Record_Code

	END
	
	IF OBJECT_ID('tempdb..#Temp_Batch_N') IS NOT NULL DROP TABLE #Temp_Batch_N
	IF OBJECT_ID('tempdb..#Temp_Session_Raw') IS NOT NULL DROP TABLE #Temp_Session_Raw
	IF OBJECT_ID('tempdb..#Temp_Session_Raw_Lang') IS NOT NULL DROP TABLE #Temp_Session_Raw_Lang
	IF OBJECT_ID('tempdb..#Process_Rights') IS NOT NULL DROP TABLE #Process_Rights
	IF OBJECT_ID('tempdb..#Acq_Contry') IS NOT NULL DROP TABLE #Acq_Contry
	IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS_V1') IS NOT NULL DROP TABLE #TMP_ACQ_DETAILS_V1
	IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
	IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
	IF OBJECT_ID('tempdb..#Temp_Session_Raw_Distinct') IS NOT NULL DROP TABLE #Temp_Session_Raw_Distinct
	IF OBJECT_ID('tempdb..#Syn_Territory') IS NOT NULL DROP TABLE #Syn_Territory
	IF OBJECT_ID('tempdb..#Syn_Subtitling') IS NOT NULL DROP TABLE #Syn_Subtitling
	IF OBJECT_ID('tempdb..#Syn_Dubbing') IS NOT NULL DROP TABLE #Syn_Dubbing
	IF OBJECT_ID('tempdb..#Syn_Data') IS NOT NULL DROP TABLE #Syn_Data
	IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data
	IF OBJECT_ID('tempdb..#Syn_Sub_Avail_Data') IS NOT NULL DROP TABLE #Syn_Sub_Avail_Data
	IF OBJECT_ID('tempdb..#Syn_Dub_Avail_Data') IS NOT NULL DROP TABLE #Syn_Dub_Avail_Data
	IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data_SDRC') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data_SDRC
	IF OBJECT_ID('tempdb..#Syn_Sub_Avail_Data_SDRC') IS NOT NULL DROP TABLE #Syn_Sub_Avail_Data_SDRC
	IF OBJECT_ID('tempdb..#Syn_Dub_Avail_Data_SDRC') IS NOT NULL DROP TABLE #Syn_Dub_Avail_Data_SDRC
	IF OBJECT_ID('tempdb..#Temp_Session_Raw_Dist') IS NOT NULL DROP TABLE #Temp_Session_Raw_Dist
	IF OBJECT_ID('tempdb..#Temp_Sub_New') IS NOT NULL DROP TABLE #Temp_Sub_New
	IF OBJECT_ID('tempdb..#Temp_Dub_New') IS NOT NULL DROP TABLE #Temp_Dub_New
	IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL DROP TABLE #Temp_Syndication
	IF OBJECT_ID('tempdb..#Temp_Syndication_Main') IS NOT NULL DROP TABLE #Temp_Syndication_Main
	IF OBJECT_ID('tempdb..#Temp_Syndication_NE') IS NOT NULL DROP TABLE #Temp_Syndication_NE
	IF OBJECT_ID('tempdb..#Temp_Avail_Dates') IS NOT NULL DROP TABLE #Temp_Avail_Dates
	IF OBJECT_ID('tempdb..#Temp_Batch') IS NOT NULL DROP TABLE #Temp_Batch
	IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL DROP TABLE #TMP_ACQ_DETAILS
	IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL DROP TABLE #TMP_Acq_SUBTITLING
	IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL DROP TABLE #TMP_Acq_DUBBING
	IF OBJECT_ID('tempdb..#Temp_Syndication_CE') IS NOT NULL DROP TABLE #Temp_Syndication_CE
	IF OBJECT_ID('tempdb..#Temp_Date_CE') IS NOT NULL DROP TABLE #Temp_Date_CE
	IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL DROP TABLE #Temp_Syndication

END

