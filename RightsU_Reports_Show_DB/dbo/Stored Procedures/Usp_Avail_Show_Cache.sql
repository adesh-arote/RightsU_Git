CREATE PROCEDURE [dbo].[Usp_Avail_Show_Cache]
	@RecORd_Code INT = 4501,
	@RecORd_Type Char(1) = 'A'
AS
Begin
-- =============================================
-- AuthOR:		ADESH AROTE
-- Create DATE: 19-Feb-2016
-- Description:	Cache Acquisition on deal approval fOR availability
-- =============================================

	--BEGIN TRY
		
	Create Table #Process_Rights(
		Acq_Deal_Code INT,
		Acq_Deal_Rights_Code INT,
		Sub_License_Code INT,
		Actual_Right_Start_Date DateTime,
		Actual_Right_End_Date DateTime,
		Is_Title_Language_Right Char(1), 
		Is_Exclusive Char(1), 
		Is_Theatrical_Right Char(1)
	)

	If(@RecORd_Type = 'A')
	Begin
	
		DELETE FROM Avail_Acq_Show_Details WHERE Avail_Raw_Code In (
			SELECT Avail_Raw_Code FROM Avail_Raw WHERE Acq_Deal_Code = @Record_Code
		)

		DELETE FROM Avail_Raw WHERE Acq_Deal_Code = @Record_Code

		INSERT INTO #Process_Rights(Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
									Is_Exclusive, Is_Theatrical_Right)
		SELECT ad.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code,adr.Sub_License_Code,ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,adr.Is_Title_Language_Right
			, adr.Is_Exclusive, adr.Is_Theatrical_Right
			FROM Acq_Deal_Rights adr
			INNER JOIN Acq_Deal ad on ad.Acq_Deal_Code=adr.Acq_Deal_Code
			WHERE ad.Is_Master_Deal='Y'
			AND IsNull(adr.Is_Tentative, 'N')='N'
			AND adr.Is_Sub_License='Y'
			AND adr.Actual_Right_Start_Date Is Not Null --AND adr.Actual_Right_End_Date is not null
			AND adr.Acq_Deal_Code = @RecORd_Code --AND Acq_Deal_Rights_Code = 778
			AND IsNull(adr.Is_Theatrical_Right, 'N') = 'N'
			AND (adr.Actual_Right_End_Date is null OR adr.Actual_Right_End_Date > GETDATE())
			AND ad.Deal_Workflow_Status <> 'AR'
			--AND adr.Is_Exclusive = 'N'
	END
	ELSE
	Begin
	
		INSERT INTO #Process_Rights(Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
									Is_Exclusive, Is_Theatrical_Right)
		SELECT ad.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code,adr.Sub_License_Code,ADR.Actual_Right_Start_Date,ADR.Actual_Right_End_Date,adr.Is_Title_Language_Right
			, adr.Is_Exclusive, adr.Is_Theatrical_Right
			FROM Acq_Deal_Rights adr
			INNER JOIN Acq_Deal ad on ad.Acq_Deal_Code=adr.Acq_Deal_Code
			WHERE ad.Is_Master_Deal='Y'
			AND IsNull(adr.Is_Tentative, 'N')='N'
			AND adr.Is_Sub_License='Y'
			AND adr.Actual_Right_Start_Date Is Not Null
			AND IsNull(adr.Is_Theatrical_Right, 'N') = 'N'
			AND (adr.Actual_Right_End_Date is null OR adr.Actual_Right_End_Date > GETDATE())
			AND ADR.Acq_Deal_Rights_Code In (
				SELECT Deal_Rights_Code FROM Avail_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @RecORd_Code
				UNION
				SELECT Deal_Rights_Code FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @RecORd_Code 
			)

	END

	DECLARE @Theatrical_Code INT = 0, @India_Code INT = 0, @Acq_Deal_Code INT = 0
	SELECT @Theatrical_Code = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name='THEATRICAL_PLATFORM_CODE'
	SELECT @India_Code = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name='INDIA_COUNTRY_CODE'

	DECLARE @Acq_Deal_Rights_Code INT = 0, @Sub_License_Code INT = 0, 
			@Actual_Right_Start_Date DateTime, @Actual_Right_End_Date DateTime,
			@Is_Title_Language_Right Char(1) = '',
			@Is_Exclusive Char(1) = '', @Is_Theatrical_Right Char(1)
	
	
	Create Table #Temp_Session_Raw(
		Avail_Acq_Show_Code numeric(38, 0),
		Avail_Raw_Code numeric(38, 0),
		Acq_Deal_Code INT,
		Acq_Deal_Rights_Code INT,
		Avail_Dates_Code numeric(38, 0),
		Is_Exclusive BIT,
		Episode_From INT,
		Episode_To INT,
		Is_Title_Lang Char(1),
		Sub_Languages_Code numeric(38, 0),
		Dub_Languages_Code numeric(38, 0),
		Is_Same Char(1)
	)
	
	Create Table #Temp_Session_Raw_Lang(
		Avail_Acq_Show_Code numeric(38, 0),
		Avail_Raw_Code numeric(38, 0),
		Acq_Deal_Code INT,
		Acq_Deal_Rights_Code INT,
		Avail_Dates_Code numeric(38, 0),
		Is_Exclusive BIT,
		Episode_From INT,
		Episode_To INT,
		Language_Codes VARCHAR(Max),
		Rec_Type Char(1),
		Avail_Languages_Code numeric(38, 0)
	)

	Delete FROM Avail_Acq_Show_Details WHERE Avail_Raw_Code In (
		SELECT Avail_Raw_Code FROM Avail_Raw WHERE Acq_Deal_Rights_Code In (
			SELECT Acq_Deal_Rights_Code FROM #Process_Rights
		)
	)

	DECLARE CUR_Rights CursOR FOR
			SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Sub_License_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right, 
				   Is_Exclusive, Is_Theatrical_Right
			FROM #Process_Rights
	Open CUR_Rights
	Fetch FROM CUR_Rights INTO @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	While(@@FETCH_STATUS = 0)
	Begin
		
		If OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL
		Begin
			Drop TABLE #TMP_ACQ_DETAILS
		END

		If OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL
		Begin
			Drop TABLE #TMP_Acq_SUBTITLING
		END

		If OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL
		Begin
			Drop TABLE #TMP_Acq_DUBBING
		END

		CREATE TABLE #TMP_Acq_SUBTITLING
		(
			Acq_Deal_Rights_Code INT, 
			Title_Code INT, 
			Episode_From INT, 
			Episode_To INT, 
			PlatfORm_Code INT, 
			Country_Code INT, 
			Language_Code INT,
			Avail_Acq_Show_Code INT,
			Is_Syn CHAR(1),
			Syn_Rights_Codes VARCHAR(2000),
			--[SubValues] AS (CAST(Avail_Acq_Show_Code AS VARCHAR) + '-' + CAST(Episode_From AS VARCHAR) + '-' + CAST(Episode_To AS VARCHAR) + '-' + CAST(ISNULL(Is_Syn, '') AS VARCHAR))
		)
			
		CREATE TABLE #TMP_Acq_DUBBING
		(
			Acq_Deal_Rights_Code INT, 
			Title_Code INT, 
			Episode_From INT, 
			Episode_To INT, 
			PlatfORm_Code INT, 
			Country_Code INT, 
			Language_Code INT,
			Avail_Acq_Show_Code INT,
			Is_Syn CHAR(1),
			Syn_Rights_Codes VARCHAR(2000),
			--[DubValues] AS (CAST(Avail_Acq_Show_Code AS VARCHAR) + '-' + CAST(Episode_From AS VARCHAR) + '-' + CAST(Episode_To AS VARCHAR) + '-' + CAST(ISNULL(Is_Syn, '') AS VARCHAR))
		)

		SELECT DISTINCT CASE WHEN srter.TerritORy_Type = 'G' THEN td.Country_Code ELSE srter.Country_Code END Country_Code INTO #Acq_Contry FROM (
			SELECT Acq_Deal_Rights_Code, TerritORy_Code, Country_Code, TerritORy_Type 
			FROM Acq_Deal_Rights_TerritORy  
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS srter
		LEFT JOIN TerritORy_Details td On srter.TerritORy_Code = td.TerritORy_Code
		
		PRINT 'AD 0 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		SELECT DISTINCT ADR.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_From, adrt.Episode_To, adrp.PlatfORm_Code, con.Country_Code, 
						@Is_Theatrical_Right Is_Theatrical_Right, 0 Avail_Acq_Show_Code, 'N' Is_Syn
		INTO #TMP_ACQ_DETAILS
		FROM (
			SELECT @Acq_Deal_Rights_Code Acq_Deal_Rights_Code
		) AS adr
		INNER JOIN Acq_Deal_Rights_Title adrt on adrt.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_PlatfORm adrp on adrp.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		INNER JOIN #Acq_Contry con On 1 = 1

		Alter Table #TMP_ACQ_DETAILS Add Syn_Rights_Codes VARCHAR(2000)

		PRINT 'AD 1 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		Drop Table #Acq_Contry
			
		If(@Is_Theatrical_Right = 'N')
		Begin
			
			PRINT 'AD 2.1 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			Delete FROM #TMP_ACQ_DETAILS WHERE PlatfORm_Code = @Theatrical_Code AND Country_Code = @India_Code

			PRINT 'AD 2.2 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		END

		--------- CHECK INTERNATIONAL AVAILABILITY

		Update t Set t.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code FROM #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Show a On t.Title_Code = a.Title_Code AND t.PlatfORm_Code = a.PlatfORm_Code 
			AND t.Country_Code = a.Country_Code AND t.Is_Theatrical_Right = 'N'

		PRINT 'AD 3 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		INSERT INTO Avail_Acq_Show(Title_Code, PlatfORm_Code, Country_Code)
		SELECT Title_Code, PlatfORm_Code, Country_Code FROM #TMP_ACQ_DETAILS WHERE IsNull(Avail_Acq_Show_Code, 0) = 0 AND Is_Theatrical_Right = 'N'

		PRINT 'AD 4 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		Update t Set t.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code FROM #TMP_ACQ_DETAILS t 
		INNER JOIN Avail_Acq_Show a On t.Title_Code = a.Title_Code AND t.PlatfORm_Code = a.PlatfORm_Code 
			AND t.Country_Code = a.Country_Code  AND IsNull(t.Avail_Acq_Show_Code, 0) = 0 AND t.Is_Theatrical_Right = 'N'

		PRINT 'AD 5 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		
		---------- END

		SELECT DISTINCT CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code ELSE adrs.Language_Code END Language_Code, Acq_Deal_Rights_Code INTO #Acq_Sub
		FROM(
			SELECT DISTINCT Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Subtitling
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		PRINT 'AD 9 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		
		PRINT 'AD 10 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		PRINT 'AD 11 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		SELECT DISTINCT CASE WHEN adrs.Language_Type = 'G' THEN lgd.Language_Code ELSE adrs.Language_Code END Language_Code, Acq_Deal_Rights_Code INTO #Acq_Dub
		FROM(
			SELECT DISTINCT Acq_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type  FROM Acq_Deal_Rights_Dubbing
			WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		) AS adrs
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code

		PRINT 'AD 12 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		PRINT 'AD 13 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		PRINT 'AD 14 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		
		DECLARE @Is_Exclusive_Bit BIT = CASE WHEN @Is_Exclusive = 'N' THEN 0 ELSE 1 END
		
		DECLARE @Avial_Dates_Code INT = 0, @SynCount INT = 0
		SELECT @SynCount = COUNT(*) FROM Syn_Acq_Mapping WHERE Deal_Rights_Code = @Acq_Deal_Rights_Code

		If(@Is_Exclusive = 'N' OR @SynCount = 0)------------ CATCHE THE RECORDS WHICH ARE ACQUIRED EXCLUSIVE NO
		Begin
			
			PRINT 'AD 14.1 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			DECLARE @SubLanguageCodes VARCHAR(MAX) = '', @DubLanguageCodes VARCHAR(MAX) = '', @SubLangCode INT = NULL, @DubLangCode INT = NULL
			IF EXISTS(SELECT TOP 1 * FROM #Acq_Sub)
			BEGIN

				SELECT @SubLanguageCodes = ',' + STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (SELECT DISTINCT Language_Code FROM #Acq_Sub) AS a
						FOR XML PATH('')
					), 1, 1, ''
				) + ','

				IF NOT EXISTS(SELECT TOP 1 * FROM Avail_Languages WHERE Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = @SubLanguageCodes COLLATE SQL_Latin1_General_CP1_CI_AS AND Language_Codes <> '')
				BEGIN
					INSERT INTO Avail_Languages(Language_Codes)
					SELECT @SubLanguageCodes
				END
				
				SELECT @SubLangCode = Avail_Languages_Code FROM Avail_Languages WHERE Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = @SubLanguageCodes COLLATE SQL_Latin1_General_CP1_CI_AS AND Language_Codes <> ''

			END
			
			PRINT 'AD 14.2 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			IF EXISTS(SELECT TOP 1 * FROM #Acq_Dub)
			BEGIN
				
				SELECT @DubLanguageCodes = ',' + STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (SELECT DISTINCT Language_Code FROM #Acq_Dub) AS a
						FOR XML PATH('')
					), 1, 1, ''
				) + ','
				
				IF NOT EXISTS(SELECT TOP 1 * FROM Avail_Languages WHERE Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = @DubLanguageCodes COLLATE SQL_Latin1_General_CP1_CI_AS AND Language_Codes <> '')
				BEGIN
					INSERT INTO Avail_Languages(Language_Codes)
					SELECT @DubLanguageCodes
				END
				
				SELECT @DubLangCode = Avail_Languages_Code FROM Avail_Languages WHERE Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS = @DubLanguageCodes COLLATE SQL_Latin1_General_CP1_CI_AS AND Language_Codes <> ''

			END
			
			PRINT 'AD 14.3 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			SELECT @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) FROM [dbo].[Avail_Dates] WHERE [Start_Date] = @Actual_Right_Start_Date AND IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')
			
			if(@Avial_Dates_Code Is Null OR @Avial_Dates_Code = 0)
			Begin
				INSERT INTO [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
				SELECT @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
			END

			Truncate Table #Temp_Session_Raw
			Truncate Table #Temp_Session_Raw_Lang
			PRINT 'AD 14.4 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			INSERT INTO #Temp_Session_Raw(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Is_Same, 
			Is_Title_Lang, Sub_Languages_Code, Dub_Languages_Code)
			SELECT DISTINCT Avail_Acq_Show_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Episode_From, Episode_To, 'N',
			CASE WHEN @Is_Title_Language_Right = 'Y' THEN 1 ELSE 0 END, @SubLangCode, @DubLangCode
			FROM #TMP_ACQ_DETAILS
			
			PRINT 'AD 14.5 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			SELECT DISTINCT traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To 
			INTO #Temp_Session_Raw_Distinct
			FROM #Temp_Session_Raw traw

			PRINT 'AD 14.6 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			MERGE INTO Avail_Raw AS araw
			USING #Temp_Session_Raw_Distinct AS traw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
			traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
			traw.Is_Exclusive = araw.Is_Exclusive AND
			traw.Episode_From = araw.Episode_From AND
			traw.Episode_To = araw.Episode_To
			WHEN NOT MATCHED THEN
				INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To, 0)
			;

			Drop Table #Temp_Session_Raw_Distinct
				
			PRINT 'AD 14.7 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
			Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
			Inner Join Avail_Raw araw On 
			traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
			traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
			traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
			traw.Is_Exclusive = araw.Is_Exclusive AND
			traw.Episode_From = araw.Episode_From AND
			traw.Episode_To = araw.Episode_To
			
			PRINT 'AD 14.8 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
	
			INSERT INTO Avail_Acq_Show_Details(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
			SELECT Avail_Acq_Show_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code FROM #Temp_Session_Raw

			Truncate Table #Temp_Session_Raw
			
			PRINT 'AD 14.9 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

		END
		ELSE
		Begin
	
			Begin ------------ GENERATE SYNDICATION DATA FOR CURRENT COMBINATION

				SELECT DISTINCT srter.Syn_Deal_Rights_Code, CASE WHEN srter.TerritORy_Type = 'G' THEN td.Country_Code ELSE srter.Country_Code END Country_Code INTO #Syn_TerritORy 
				FROM (
					SELECT sdrtr.Syn_Deal_Rights_Code, sdrtr.TerritORy_Code, sdrtr.Country_Code, sdrtr.TerritORy_Type 
					FROM Syn_Deal_Rights_TerritORy sdrtr
					WHERE sdrtr.Syn_Deal_Rights_Code In (
						SELECT samIn.Syn_Deal_Rights_Code FROM Syn_Acq_Mapping samIn WHERE samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) AS srter
				Left Join TerritORy_Details td On srter.TerritORy_Code = td.TerritORy_Code

				PRINT 'AD 15 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				SELECT DISTINCT srsub.Syn_Deal_Rights_Code, CASE WHEN srsub.Language_Type = 'G' THEN lgd.Language_Code ELSE srsub.Language_Code END Language_Code INTO #Syn_Subtitling
				FROM (
					SELECT sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					FROM Syn_Deal_Rights_Subtitling sdrs
					WHERE sdrs.Syn_Deal_Rights_Code In (
						SELECT samIn.Syn_Deal_Rights_Code FROM Syn_Acq_Mapping samIn WHERE samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) AS srsub
				Left Join Language_Group_Details lgd On srsub.Language_Group_Code = lgd.Language_Group_Code

				PRINT 'AD 16 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
		
				SELECT DISTINCT srsub.Syn_Deal_Rights_Code, CASE WHEN srsub.Language_Type = 'G' THEN lgd.Language_Code ELSE srsub.Language_Code END Language_Code INTO #Syn_Dubbing
				FROM (
					SELECT sdrs.Syn_Deal_Rights_Code, sdrs.Language_Group_Code, sdrs.Language_Code, sdrs.Language_Type 
					FROM Syn_Deal_Rights_Dubbing sdrs
					WHERE sdrs.Syn_Deal_Rights_Code In (
						SELECT samIn.Syn_Deal_Rights_Code FROM Syn_Acq_Mapping samIn WHERE samIn.Deal_Rights_Code = @Acq_Deal_Rights_Code
					)
				) AS srsub
				Left Join Language_Group_Details lgd On srsub.Language_Group_Code = lgd.Language_Group_Code

				PRINT 'AD 17 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				SELECT DISTINCT sdr.Syn_Deal_Rights_Code, sdr.Is_Exclusive, sdr.Is_Title_Language_Right, sdr.Is_Theatrical_Right, sdr.Actual_Right_Start_Date, 
								sdr.Actual_Right_End_Date, sdrt.Title_Code, sdrt.Episode_From, sdrt.Episode_To, sdrp.PlatfORm_Code, synter.Country_Code 
				INTO #Syn_Data
				FROM Syn_Deal_Rights sdr 
				INNER JOIN Syn_Deal sd ON sdr.Syn_Deal_Code = sd.Syn_Deal_Code
				Inner Join Syn_Acq_Mapping sam On sam.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code AND Deal_Rights_Code = @Acq_Deal_Rights_Code
				Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
				Inner Join Syn_Deal_Rights_PlatfORm sdrp On sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code
				Inner Join #Syn_TerritORy synter On sdr.Syn_Deal_Rights_Code = synter.Syn_Deal_Rights_Code
				WHERE sd.Deal_Workflow_Status <> 'AR' AND Actual_Right_Start_Date Is Not Null
				AND sdrt.Title_Code In (
					SELECT adr.Title_Code FROM #TMP_ACQ_DETAILS adr WHERE adr.PlatfORm_Code = sdrp.PlatfORm_Code AND adr.Country_Code = synter.Country_Code
					AND (
						(adr.Episode_From BETWEEN sdrt.Episode_From AND sdrt.Episode_To) OR
						(adr.Episode_To BETWEEN sdrt.Episode_From AND sdrt.Episode_To) OR
						(sdrt.Episode_From BETWEEN adr.Episode_From AND adr.Episode_To) OR
						(sdrt.Episode_To BETWEEN adr.Episode_From AND adr.Episode_To)
					)
				)

				PRINT 'AD 18 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				Drop Table #Syn_TerritORy

				Create table #Syn_Title_Avail_Data
				(
					Syn_Deal_Rights_Code INT,
					Is_Exclusive CHAR(1), 
					Is_Title_Language_Right CHAR(1),  
					Is_Theatrical_Right CHAR(1), 
					Actual_Right_Start_Date DATETIME,
					Actual_Right_End_Date DATETIME, 
					Title_Code INT, 
					Episode_From INT,
					Episode_To INT,
					PlatfORm_Code INT, 
					Country_Code INT
				)

				INSERT INTO #Syn_Title_Avail_Data(Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date, Actual_Right_End_Date, 
					Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code)
				SELECT DISTINCT Syn_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code
				FROM #Syn_Data WHERE Is_Title_Language_Right = 'Y'
		
				PRINT 'AD 19 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				/*

				SELECT DISTINCT syn.Syn_Deal_Rights_Code, Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, sdrs.Language_Code
				INTO #Syn_Sub_Avail_Data
				FROM #Syn_Data syn
				Inner Join #Syn_Subtitling sdrs On syn.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code
		
				SELECT DISTINCT syn.Syn_Deal_Rights_Code, Is_Exclusive, Is_Theatrical_Right, Actual_Right_Start_Date,
					   Actual_Right_End_Date, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, sdrd.Language_Code
				INTO #Syn_Dub_Avail_Data
				FROM #Syn_Data syn
				Inner Join #Syn_Dubbing sdrd On syn.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code
				
				*/

				PRINT 'AD 21 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			END ------------ END
			
			SELECT * INTO #TEMPAcqDetNew
			FROM #TMP_ACQ_DETAILS a WHERE a.Title_Code NOT IN (
				SELECT Title_Code FROM #Syn_Data s 
				WHERE a.PlatfORm_Code = s.PlatfORm_Code AND a.Country_Code = s.Country_Code AND (
					(s.Episode_From BETWEEN a.Episode_From AND a.Episode_To) OR
					(s.Episode_To BETWEEN a.Episode_From AND a.Episode_To) OR
					(a.Episode_From BETWEEN s.Episode_From AND s.Episode_To) OR
					(a.Episode_To BETWEEN s.Episode_From AND s.Episode_To)
				)
			)

			INSERT INTO #TMP_Acq_SUBTITLING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn)
			SELECT temp.Acq_Deal_Rights_Code, temp.Title_Code, temp.Episode_From, temp.Episode_To, temp.PlatfORm_Code, temp.Country_Code, sub.Language_Code, Avail_Acq_Show_Code, 'N' Is_Syn
			FROM #TEMPAcqDetNew temp
			INNER JOIN #Acq_Sub sub ON sub.Acq_Deal_Rights_Code = temp.Acq_Deal_Rights_Code AND temp.Is_Theatrical_Right = 'N'

			INSERT INTO #TMP_Acq_DUBBING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn)
			SELECT temp.Acq_Deal_Rights_Code, temp.Title_Code, temp.Episode_From, temp.Episode_To, temp.PlatfORm_Code, temp.Country_Code, sub.Language_Code, Avail_Acq_Show_Code, 'N' Is_Syn
			FROM #TEMPAcqDetNew temp
			INNER JOIN #Acq_Dub sub ON sub.Acq_Deal_Rights_Code = temp.Acq_Deal_Rights_Code AND temp.Is_Theatrical_Right = 'N'

			IF EXISTS(SELECT TOP 1 * FROM #Syn_Data)
			BEGIN
			
				CREATE TABLE #TempLangData
				(
					Episode_From INT,
					Episode_To INT,
					Language_Code INT,
					Syn_Deal_Rights_Code INT
				)

				PRINT 'AD 22 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				DECLARE @TitCode INT, @CntryCode INT, @PlatCode INT, @AvailShowCode INT, @Counter INT = 0, @EpsFrm INT, @EpsTo INT
				DECLARE CURAvailSyns CURSOR FOR 
							SELECT DISTINCT Title_Code, Country_Code, PlatfORm_Code, Avail_Acq_Show_Code, Episode_From, Episode_To 
							FROM #TMP_ACQ_DETAILS 
							WHERE Is_Theatrical_Right = 'N' AND Avail_Acq_Show_Code NOT IN (
								SELECT Avail_Acq_Show_Code FROM #TEMPAcqDetNew
							)
				OPEN CURAvailSyns
				FETCH NEXT FROM CURAvailSyns INTO @TitCode, @CntryCode, @PlatCode, @AvailShowCode, @EpsFrm, @EpsTo
				WHILE(@@FETCH_STATUS = 0)
				BEGIN

					SET @Counter = @Counter + 1
					PRINT 'AD CNT -- ' + CAST(@Counter AS VARCHAR(10))

					BEGIN ------------- TITLE LANGUAGE START

						UPDATE tmp SET tmp.Syn_Rights_Codes = STUFF(
							(
								SELECT DISTINCT ',' + CAST(Syn_Deal_Rights_Code AS VARCHAR) FROM #Syn_Title_Avail_Data b
								WHERE @TitCode = b.Title_Code 
									AND @CntryCode = b.Country_Code 
									AND @PlatCode = b.PlatfORm_Code
									AND (
										(b.Episode_From BETWEEN @EpsFrm AND @EpsTo) OR
										(b.Episode_To BETWEEN @EpsFrm AND @EpsTo) OR
										(@EpsFrm BETWEEN b.Episode_From AND b.Episode_To) OR
										(@EpsTo BETWEEN b.Episode_From AND b.Episode_To)
									)
								FOR XML PATH('')
							), 1, 1, ''
						)
						FROM #TMP_ACQ_DETAILS tmp
						WHERE tmp.Avail_Acq_Show_Code = @AvailShowCode
						
						UPDATE #TMP_ACQ_DETAILS SET Is_Syn = 'Y' WHERE Avail_Acq_Show_Code = @AvailShowCode AND ISNULL(Syn_Rights_Codes, '') <> ''
						
					END --------------- TITLE LANGUAGE END

					BEGIN ------------- SUB LANGUAGE START

						TRUNCATE TABLE #TempLangData

						INSERT INTO #TempLangData(Episode_From, Episode_To, Syn_Deal_Rights_Code, Language_Code)
						SELECT syn.Episode_From, syn.Episode_To, syn.Syn_Deal_Rights_Code, Language_Code FROM (
							SELECT DISTINCT Episode_From, Episode_To, Syn_Deal_Rights_Code
							FROM #Syn_Data b
							WHERE b.Title_Code = @TitCode
							AND b.Country_Code = @CntryCode
							AND b.PlatfORm_Code = @PlatCode
						) AS syn
						INNER JOIN #Syn_Subtitling sdrs ON syn.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code

						--SELECT COUNT(*) FROM #TempLangData

						INSERT INTO #TMP_Acq_SUBTITLING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn, 
														Syn_Rights_Codes)
						SELECT Acq_Deal_Rights_Code, @TitCode, @EpsFrm, @EpsTo, @PlatCode, @CntryCode, Language_Code, @AvailShowCode, 'N',
							   STUFF(
							   		(
							   			SELECT DISTINCT ',' + CAST(Syn_Deal_Rights_Code AS VARCHAR) FROM #TempLangData b
							   			WHERE (
							   					(b.Episode_From BETWEEN @EpsFrm AND @EpsTo) OR
							   					(b.Episode_To BETWEEN @EpsFrm AND @EpsTo) OR
							   					(@EpsFrm BETWEEN b.Episode_From AND b.Episode_To) OR
							   					(@EpsTo BETWEEN b.Episode_From AND b.Episode_To)
							   				)
							   				AND b.Language_Code = tmp.Language_Code
							   			FOR XML PATH('')
							   		), 1, 1, ''
							   )
						FROM #Acq_Sub tmp

					END --------------- SUB LANGUAGE END

					BEGIN ------------- DUB LANGUAGE START

						TRUNCATE TABLE #TempLangData
						
						INSERT INTO #TempLangData(Episode_From, Episode_To, Syn_Deal_Rights_Code, Language_Code)
						SELECT syn.Episode_From, syn.Episode_To, syn.Syn_Deal_Rights_Code, Language_Code FROM (
							SELECT DISTINCT Episode_From, Episode_To, Syn_Deal_Rights_Code
							FROM #Syn_Data b
							WHERE b.Title_Code = @TitCode
							AND b.Country_Code = @CntryCode
							AND b.PlatfORm_Code = @PlatCode
						) AS syn
						INNER JOIN #Syn_Dubbing sdrd ON syn.Syn_Deal_Rights_Code = sdrd.Syn_Deal_Rights_Code

						INSERT INTO #TMP_Acq_DUBBING(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, PlatfORm_Code, Country_Code, Language_Code, Avail_Acq_Show_Code, Is_Syn, 
														Syn_Rights_Codes)
						SELECT Acq_Deal_Rights_Code, @TitCode, @EpsFrm, @EpsTo, @PlatCode, @CntryCode, Language_Code, @AvailShowCode, 'N',
							   STUFF(
							   		(
							   			SELECT DISTINCT ',' + CAST(Syn_Deal_Rights_Code AS VARCHAR) FROM #TempLangData b
							   			WHERE (
							   					(b.Episode_From BETWEEN @EpsFrm AND @EpsTo) OR
							   					(b.Episode_To BETWEEN @EpsFrm AND @EpsTo) OR
							   					(@EpsFrm BETWEEN b.Episode_From AND b.Episode_To) OR
							   					(@EpsTo BETWEEN b.Episode_From AND b.Episode_To)
							   				)
							   				AND b.Language_Code = tmp.Language_Code
							   			FOR XML PATH('')
							   		), 1, 1, ''
							   )
						FROM #Acq_Dub tmp

					END --------------- DUB LANGUAGE END

					FETCH NEXT FROM CURAvailSyns INTO @TitCode, @CntryCode, @PlatCode, @AvailShowCode, @EpsFrm, @EpsTo
				END
				CLOSE CURAvailSyns
				DEALLOCATE CURAvailSyns

				DROP TABLE #TempLangData

				PRINT 'AD 22.1 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			END
			
			UPDATE #TMP_Acq_SUBTITLING SET Is_Syn = 'Y' WHERE ISNULL(Syn_Rights_Codes, '') <> ''
			UPDATE #TMP_Acq_DUBBING SET Is_Syn = 'Y' WHERE ISNULL(Syn_Rights_Codes, '') <> ''


			PRINT 'AD 23 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
			PRINT 'AD 23.1 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			PRINT 'AD 24 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
			PRINT 'AD 24.1 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
			Create Table #Temp_Batch
			(
				Syn_Rights_Codes VARCHAR(2000),
				Rec_Type char(1)
			)

			INSERT INTO #Temp_Batch
			SELECT DISTINCT Syn_Rights_Codes, 'T' FROM #TMP_ACQ_DETAILS WHERE Is_Syn = 'Y'
			
			INSERT INTO #Temp_Batch
			SELECT DISTINCT Syn_Rights_Codes, 'S' FROM #TMP_Acq_SUBTITLING WHERE Is_Syn = 'Y'
			
			INSERT INTO #Temp_Batch
			SELECT DISTINCT Syn_Rights_Codes, 'D' FROM #TMP_Acq_DUBBING WHERE Is_Syn = 'Y'

			PRINT 'AD 25 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

			If(IsNull(@Actual_Right_End_Date, '31Dec9999') > GETDATE()) ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED
			Begin ------------- EXECUTION FOR RECORDS WHICH ARE NOT SYNDICATED

				SET @Avial_Dates_Code = 0

				SELECT @Avial_Dates_Code = IsNull(Avail_Dates_Code, 0) FROM [dbo].[Avail_Dates] 
				WHERE [Start_Date] = @Actual_Right_Start_Date AND IsNull(End_Date, '') = IsNull(@Actual_Right_End_Date, '')

				if(@Avial_Dates_Code Is Null OR @Avial_Dates_Code = 0)
				Begin
					INSERT INTO [Avail_Dates](Start_Date, End_Date) Values(@Actual_Right_Start_Date, @Actual_Right_End_Date)
					SELECT @Avial_Dates_Code = IDENT_CURRENT('Avail_Dates')
				END
				
				Truncate Table #Temp_Session_Raw
				Truncate Table #Temp_Session_Raw_Lang
				
				PRINT 'AD 25.1 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				INSERT INTO #Temp_Session_Raw_Lang(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Language_Codes, Rec_Type)
				SELECT DISTINCT Avail_Acq_Show_Code, @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Avial_Dates_Code, @Is_Exclusive_Bit, Episode_From, Episode_To, Lang, Rec_Type 
				FROM (
					SELECT DISTINCT Avail_Acq_Show_Code, Episode_From, Episode_To, '' Lang, 'T' Rec_Type FROM #TMP_ACQ_DETAILS 
					WHERE Is_Theatrical_Right = 'N' AND Is_Syn <> 'Y' AND @Is_Title_Language_Right = 'Y'
					UNION ALL
					SELECT Avail_Acq_Show_Code, Episode_From, Episode_To, ',' + STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code FROM #TMP_Acq_SUBTITLING subIn
								WHERE subIn.Episode_From = sub.Episode_From AND subIn.Episode_To = sub.Episode_To
									  AND subIn.Is_Syn = sub.Is_Syn
									  AND subIn.Avail_Acq_Show_Code = sub.Avail_Acq_Show_Code
							) AS a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'S' FROM (SELECT DISTINCT Avail_Acq_Show_Code, Episode_From, Episode_To, Is_Syn FROM #TMP_Acq_SUBTITLING WHERE Is_Syn <> 'Y') sub
					UNION
					SELECT Avail_Acq_Show_Code, Episode_From, Episode_To, ',' + STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
								SELECT Distinct Language_Code FROM #TMP_Acq_DUBBING dubIn
								WHERE dubIn.Episode_From = dub.Episode_From AND dubIn.Episode_To = dub.Episode_To
									  AND dubIn.Is_Syn = dub.Is_Syn
									  AND dubIn.Avail_Acq_Show_Code = dub.Avail_Acq_Show_Code
							) AS a
							FOR XML PATH('')
						), 1, 1, ''
					) + ','
					, 'D' FROM (SELECT DISTINCT Avail_Acq_Show_Code, Episode_From, Episode_To, Is_Syn FROM #TMP_Acq_DUBBING WHERE Is_Syn <> 'Y') dub
				) AS a

					--SELECT Avail_Acq_Show_Code, Episode_From, Episode_To, ',' + STUFF
					--(
					--	(
					--		SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
					--			SELECT DISTINCT Language_Code FROM #TMP_Acq_DUBBING dubIn
					--			WHERE dubIn.[DubValues] = dub.[DubValues]
					--		) AS a
					--		FOR XML PATH('')
					--	), 1, 1, ''
					--) + ','
					--, 'D' FROM (SELECT DISTINCT Avail_Acq_Show_Code, Episode_From, Episode_To, Is_Syn, [DubValues] FROM #TMP_Acq_DUBBING WHERE Is_Syn <> 'Y') dub
				
				INSERT INTO #Temp_Session_Raw(Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, Is_Same)
				SELECT DISTINCT Avail_Acq_Show_Code, Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 'N' FROM #Temp_Session_Raw_Lang
				
				PRINT 'AD 25.2 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				--Update #Temp_Session_Raw_Lang Set Language_Codes = ',' + Language_Codes + ',' WHERE IsNull(Language_Codes, '') <> ''

				INSERT INTO Avail_Languages(Language_Codes)
				SELECT DISTINCT Language_Codes FROM #Temp_Session_Raw_Lang WHERE Language_Codes Not In (
					SELECT a.Language_Codes FROM Avail_Languages a
				) AND Language_Codes <> ''

				Update temp set temp.Avail_Languages_Code = al.Avail_Languages_Code FROM #Temp_Session_Raw_Lang temp 
				Inner Join Avail_Languages al On temp.Language_Codes = al.Language_Codes

				PRINT 'AD 25.3 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				Update t1 Set t1.Is_Title_Lang = 1
				FROM #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Episode_From = t2.Episode_From AND 
				t1.Episode_To = t2.Episode_To AND
				t2.Rec_Type = 'T'

				PRINT 'AD 25.4 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				Update t1 Set t1.Sub_Languages_Code = Avail_Languages_Code
				FROM #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Episode_From = t2.Episode_From AND 
				t1.Episode_To = t2.Episode_To AND
				t2.Rec_Type = 'S'

				PRINT 'AD 25.5 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				Update t1 Set t1.Dub_Languages_Code = Avail_Languages_Code
				FROM #Temp_Session_Raw t1
				Inner Join #Temp_Session_Raw_Lang t2 On
				t1.Avail_Acq_Show_Code = t2.Avail_Acq_Show_Code AND
				t1.Avail_Dates_Code = t2.Avail_Dates_Code AND
				t1.Is_Exclusive = t2.Is_Exclusive AND
				t1.Episode_From = t2.Episode_From AND 
				t1.Episode_To = t2.Episode_To AND
				t2.Rec_Type = 'D'

				PRINT 'AD 25.6 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				Truncate Table #Temp_Session_Raw_Lang

				SELECT DISTINCT traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To 
				INTO #Temp_Session_Raw_Dist
				FROM #Temp_Session_Raw traw

				MERGE INTO Avail_Raw AS araw
				USING #Temp_Session_Raw_Dist AS traw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
				traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
				traw.Is_Exclusive = araw.Is_Exclusive AND
				traw.Episode_From = araw.Episode_From AND
				traw.Episode_To = araw.Episode_To
				WHEN NOT MATCHED THEN
					INSERT VALUES (traw.Acq_Deal_Code, traw.Acq_Deal_Rights_Code, traw.Avail_Dates_Code, traw.Is_Exclusive, traw.Episode_From, traw.Episode_To, 0)
				;

				Drop Table #Temp_Session_Raw_Dist
				
				PRINT 'AD 25.7 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
				
				Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
				Inner Join Avail_Raw araw On 
				traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
				traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
				traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
				traw.Is_Exclusive = araw.Is_Exclusive AND
				traw.Episode_From = araw.Episode_From AND
				traw.Episode_To = araw.Episode_To
			
				PRINT 'AD 25.8 ' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

				INSERT INTO Avail_Acq_Show_Details(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
				SELECT Avail_Acq_Show_Code, Avail_Raw_Code, IsNull(Is_Title_Lang, 0), Sub_Languages_Code, Dub_Languages_Code FROM #Temp_Session_Raw

				Truncate Table #Temp_Session_Raw

			END

			PRINT 'adesh 321'

			Create Table #Syn_Rights(
				IntCode INT Identity(1, 1),
				Title_Code INT,
				Episode_From INT,
				Episode_To INT,
				Start_DT DateTime,
				End_DT DateTime,
				Is_Exclusive Char(1)
			)

			Create Table #Temp_Syndication_Main
			(
				IntCode INT Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive Char(1)
			)

			Create Table #Temp_Syndication_NE
			(
				IntCode INT Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive Char(1),
				Group_Code DateTime
			)

			Create Table #Temp_Syndication
			(
				IntCode INT Identity,
				Start_Date DateTime,
				End_Date DateTime,
				Is_Exclusive Char(1)
			)

			Create Table #Temp_Avail_Dates
			(
				IntCode INT Identity,
				Episode_From INT,
				Episode_To INT,
				AvailStartDate DateTime,
				AvailEndDate DateTime,
				Is_Exclusive Char(1),
				Avial_Dates_Code INT
			)

			Begin ------------- EXECUTION FOR SYNDICATION AVAILABLE RECORDS

				DECLARE @Syn_Rights_Codes VARCHAR(2000) = ''
				DECLARE Cur_Batch CursOR FOR SELECT DISTINCT Syn_Rights_Codes FROM #Temp_Batch WHERE ISNULL(Syn_Rights_Codes, '') <> ''
				Open Cur_Batch
				Fetch Next FROM Cur_Batch INTO @Syn_Rights_Codes
				While (@@FETCH_STATUS = 0)
				Begin
					PRINT 'Testing 1 - ' + @Syn_Rights_Codes
					Truncate Table #Syn_Rights

					INSERT INTO #Syn_Rights(Title_Code, Episode_From, Episode_To, Start_DT, End_DT, Is_Exclusive)
					SELECT Title_Code, Episode_From, Episode_To, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive
					FROM Syn_Deal_Rights sdr
					Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
					WHERE sdr.Syn_Deal_Rights_Code In 
					(
						SELECT number FROM DBO.fn_Split_withdelemiter(@Syn_Rights_Codes, ',')
					) ORder BY Actual_Right_Start_Date ASC

					SELECT * INTO #Temp_Episode FROM (
						SELECT DISTINCT Title_Code, Episode_From, Episode_To FROM #TMP_ACQ_DETAILS WHERE Syn_Rights_Codes = @Syn_Rights_Codes
						UNION
						SELECT DISTINCT Title_Code, Episode_From, Episode_To FROM #TMP_Acq_SUBTITLING WHERE Syn_Rights_Codes = @Syn_Rights_Codes
						UNION
						SELECT DISTINCT Title_Code, Episode_From, Episode_To FROM #TMP_Acq_DUBBING WHERE Syn_Rights_Codes = @Syn_Rights_Codes
					) AS a

					--SELECT 'ad', * FROM #Syn_Rights

					DECLARE @Process_Title_Code INT = 0, @Episode_From INT = 0, @Episode_To INT = 0
					DECLARE Cur_Process_Title CursOR FOR SELECT DISTINCT Title_Code, Episode_From, Episode_To FROM #Temp_Episode
					Open Cur_Process_Title
					Fetch Next FROM Cur_Process_Title INTO @Process_Title_Code, @Episode_From, @Episode_To
					While (@@FETCH_STATUS = 0)
					Begin
	
						Create Table #Eps_Nos(
							Eps_Nos INT
						)

						INSERT INTO #Eps_Nos Values(@Episode_From)

						INSERT INTO #Eps_Nos
						SELECT Eps_No FROM (
							SELECT CASE WHEN Episode_From - 1 < @Episode_From THEN 0 ELSE Episode_From - 1 END Eps_No FROM #Syn_Rights
							WHERE Title_Code = @Process_Title_Code AND (
								  Episode_From BETWEEN @Episode_From AND @Episode_To OR
								  Episode_To BETWEEN @Episode_From AND @Episode_To
							)
							UNION
							SELECT CASE WHEN Episode_To > @Episode_To THEN 0 ELSE Episode_To END Eps_No FROM #Syn_Rights
							WHERE Title_Code = @Process_Title_Code AND (
								  Episode_From BETWEEN @Episode_From AND @Episode_To OR
								  Episode_To BETWEEN @Episode_From AND @Episode_To
							)
						) AS a ORder By Eps_No

						INSERT INTO #Eps_Nos Values(@Episode_To)
						
						Delete FROM #Eps_Nos WHERE Eps_Nos = 0

						Alter Table #Eps_Nos Add IntCode INT Identity(1,1)
						
						--Create Table #Eps_Nos(
						--	IntCode INT Identity(1, 1),
						--	Eps_Nos INT
						--)
						
						--Create Table #Temp_Eps_Nos(
						--	Eps_Nos INT
						--)

						--INSERT INTO #Temp_Eps_Nos Values(@Episode_From)

						--INSERT INTO #Temp_Eps_Nos
						--SELECT Eps_No FROM (
						--	SELECT CASE WHEN Episode_From - 1 < @Episode_From THEN 0 ELSE Episode_From - 1 END Eps_No FROM #Syn_Rights
						--	WHERE Title_Code = @Process_Title_Code AND (
						--		  Episode_From BETWEEN @Episode_From AND @Episode_To OR
						--		  Episode_To BETWEEN @Episode_From AND @Episode_To
						--	)
						--	UNION
						--	SELECT CASE WHEN Episode_To > @Episode_To THEN 0 ELSE Episode_To END Eps_No FROM #Syn_Rights
						--	WHERE Title_Code = @Process_Title_Code AND (
						--		  Episode_From BETWEEN @Episode_From AND @Episode_To OR
						--		  Episode_To BETWEEN @Episode_From AND @Episode_To
						--	)
						--) AS a ORder By Eps_No

						--INSERT INTO #Temp_Eps_Nos Values(@Episode_To)
						
						--INSERT INTO #Eps_Nos(Eps_Nos)
						--SELECT DISTINCT Eps_Nos FROM #Temp_Eps_Nos WHERE Eps_Nos > 0 ORder By Eps_Nos

						DECLARE @IntCode INT, @Cur_Episode_From INT, @Cur_Episode_To INT, @Cur_Start_DT DateTime, @Cur_End_DT DateTime,
								@Prev_Episode_From INT = @Episode_From

						--DECLARE Cur_Process_Eps CursOR FOR 
						--	SELECT CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END, Eps_To FROM (
						--		SELECT CASE WHEN Eps_Nos = @Episode_From THEN Eps_Nos ELSE Eps_Nos + 1 END Eps_From, 
						--		LEAD(Eps_Nos) OVER (ORDER BY IntCode ASC) Eps_To,
						--		LAG(Eps_Nos) OVER (ORDER BY IntCode ASC) LagValue 
						--		FROM #Eps_Nos
						--	) AS a WHERE IsNull(Eps_To, 0) > 0 AND CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END <= Eps_To

						--SELECT * FROM #Temp_Eps_Nos

						--SELECT CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END, Eps_To FROM (
						--	SELECT CASE WHEN Eps_Nos = @Episode_From THEN Eps_Nos ELSE Eps_Nos + 1 END Eps_From, 
						--	LEAD(Eps_Nos) OVER (ORDER BY IntCode ASC) Eps_To,
						--	LAG(Eps_Nos) OVER (ORDER BY IntCode ASC) LagValue 
						--	FROM #Eps_Nos
						--) AS a WHERE IsNull(Eps_To, 0) > 0 AND CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END <= Eps_To

						--SELECT CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END, Eps_To FROM (
						--	SELECT CASE WHEN Eps_Nos = @Episode_From THEN Eps_Nos ELSE Eps_Nos + 1 END Eps_From, 
						--	(SELECT lead.Eps_Nos FROM #Eps_Nos lead WHERE lead.IntCode = (tmp.IntCode + 1)) Eps_To,
						--	(SELECT lag.Eps_Nos FROM #Eps_Nos lag WHERE lag.IntCode = (tmp.IntCode - 1)) LagValue
						--	FROM #Eps_Nos tmp
						--) AS a WHERE IsNull(Eps_To, 0) > 0 AND CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END <= Eps_To

						--SELECT CASE WHEN t1.Eps_Nos = @Episode_From THEN t1.Eps_Nos ELSE t1.Eps_Nos + 1 END Eps_From, t2.Eps_Nos Eps_To 
						--FROM #Eps_Nos t1 
						--Inner Join #Eps_Nos t2 On t1.IntCode = (t2.IntCode - 1)

						--SELECT CASE WHEN t1.Eps_Nos = @Episode_From THEN t1.Eps_Nos ELSE t1.Eps_Nos + 1 END Eps_From, t2.Eps_Nos Eps_To 
						--FROM #Eps_Nos t1 
						--Left Join #Eps_Nos t2 On t1.IntCode = (t2.IntCode - 1)

						DECLARE Cur_Process_Eps CursOR FOR 
							SELECT CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END, Eps_To FROM (
								SELECT CASE WHEN Eps_Nos = @Episode_From THEN Eps_Nos ELSE Eps_Nos + 1 END Eps_From, 
								(SELECT lead.Eps_Nos FROM #Eps_Nos lead WHERE lead.IntCode = (tmp.IntCode + 1)) Eps_To,
								(SELECT lag.Eps_Nos FROM #Eps_Nos lag WHERE lag.IntCode = (tmp.IntCode - 1)) LagValue
								FROM #Eps_Nos tmp
							) AS a WHERE IsNull(Eps_To, 0) > 0 AND CASE WHEN Eps_From = IsNull(LagValue, 0) THEN Eps_From + 1 ELSE Eps_From END <= Eps_To

						Open Cur_Process_Eps
						Fetch Next FROM Cur_Process_Eps INTO @Cur_Episode_From, @Cur_Episode_To
						While (@@FETCH_STATUS = 0)
						Begin

							Truncate Table #Temp_Syndication_Main
							Truncate Table #Temp_Syndication_NE
							Truncate Table #Temp_Syndication
							--Truncate Table #Temp_Avail_Dates

							INSERT INTO #Temp_Syndication_Main
							SELECT Start_DT, End_DT, Is_Exclusive FROM #Syn_Rights
							WHERE Title_Code = @Process_Title_Code AND @Cur_Episode_From BETWEEN Episode_From AND Episode_To

							INSERT INTO #Temp_Syndication_NE(Start_Date, End_Date, Is_Exclusive)
							SELECT Start_Date, End_Date, Is_Exclusive FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'N' ORder By Start_Date ASC
	
							Update t2 Set t2.Group_Code = (
								SELECT Min(t1.Start_Date) FROM #Temp_Syndication_NE t1 
								WHERE 
								t1.Start_Date BETWEEN t2.Start_Date AND t2.End_Date OR
								t1.End_Date BETWEEN t2.Start_Date AND t2.End_Date OR 
								t2.Start_Date BETWEEN t1.Start_Date AND t1.End_Date OR
								t2.End_Date BETWEEN t1.Start_Date AND t1.End_Date
							) FROM #Temp_Syndication_NE t2

							INSERT INTO #Temp_Syndication
							SELECT * FROM (
								SELECT Start_Date, End_Date, Is_Exclusive FROM #Temp_Syndication_Main WHERE Is_Exclusive = 'Y'
								UNION 
								SELECT Min(Start_Date) Start_Date, Max(End_Date) End_Date, 'N' FROM #Temp_Syndication_NE Group By Group_Code
							) AS a ORder By Start_Date ASC

							If((SELECT count(*) FROM #Temp_Syndication)=0)
							Begin
								INSERT INTO #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate, Is_Exclusive, Avial_Dates_Code)
								SELECT @Cur_Episode_From, @Cur_Episode_To, @Actual_Right_Start_Date, @Actual_Right_End_Date, 'Y', @Avial_Dates_Code
							END
							ELSE
							Begin
								INSERT INTO #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate, Is_Exclusive)
								SELECT @Cur_Episode_From, @Cur_Episode_To, *, 'Y' FROM (
									SELECT 
										CASE WHEN t2.Start_Date Is Null THEN @Actual_Right_Start_Date ELSE DateAdd(d, 1, t2.End_Date) END AvailStartDate,
										DateAdd(d, -1, t1.Start_Date) AvailEndDate
									FROM #Temp_Syndication t1 Left Join #Temp_Syndication t2 On t1.IntCode = (t2.IntCode + 1) 
								) AS a WHERE datediff(d, AvailStartDate, AvailEndDate) >= 0

								DECLARE @MaxEndDate DateTime = Null
								SELECT Top 1 @MaxEndDate = End_Date FROM #Temp_Syndication ORder By [Start_Date] Desc
								If((datediff(d, @MaxEndDate, @Actual_Right_End_Date)  < 0 OR @MaxEndDate Is Not Null) AND (@MaxEndDate <> isnull(@Actual_Right_End_Date,'')))
								Begin
									INSERT INTO #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate, Is_Exclusive)
									SELECT @Cur_Episode_From, @Cur_Episode_To, DATEADD(d, 1, @MaxEndDate), @Actual_Right_End_Date, 'Y'
								END
		
								INSERT INTO #Temp_Avail_Dates(Episode_From, Episode_To, AvailStartDate, AvailEndDate,Is_Exclusive)
								SELECT @Cur_Episode_From, @Cur_Episode_To, Start_Date, End_Date, 'N' FROM #Temp_Syndication WHERE Is_Exclusive = 'N'
							END
							
							Delete FROM #Temp_Avail_Dates WHERE AvailStartDate > AvailEndDate
							
							Fetch Next FROM Cur_Process_Eps INTO @Cur_Episode_From, @Cur_Episode_To
						END
						Close Cur_Process_Eps
						Deallocate Cur_Process_Eps

						Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code FROM #Temp_Avail_Dates tad
						Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date AND IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

						INSERT INTO Avail_Dates
						SELECT DISTINCT AvailStartDate, AvailEndDate FROM #Temp_Avail_Dates WHERE IsNull(Avial_Dates_Code, 0) = 0
						AND (AvailEndDate is null OR AvailEndDate > GETDATE())
						
						Update tad Set tad.Avial_Dates_Code = ad.Avail_Dates_Code FROM #Temp_Avail_Dates tad
						Inner Join Avail_Dates ad On tad.AvailStartDate = ad.Start_Date AND IsNull(tad.AvailEndDate, '') = IsNull(ad.End_Date, '')

						Delete FROM #Temp_Avail_Dates WHERE Avial_Dates_Code Is Null

						Truncate Table #Temp_Session_Raw
						INSERT INTO #Temp_Session_Raw(Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To)
						SELECT @Acq_Deal_Code, @Acq_Deal_Rights_Code, a.Avial_Dates_Code, CASE WHEN a.Is_Exclusive = 'N' THEN 0 ELSE 1 END, a.Episode_From, a.Episode_To 
						FROM #Temp_Avail_Dates a WHERE a.Avial_Dates_Code Not In (
							SELECT Avial_Dates_Code FROM #Temp_Session_Raw tsr WHERE a.Episode_From = tsr.Episode_From AND a.Episode_To = tsr.Episode_To
						)

						Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
						Inner Join Avail_Raw araw On 
						traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
						traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
						traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
						traw.Is_Exclusive = araw.Is_Exclusive AND
						traw.Episode_From = araw.Episode_From AND
						traw.Episode_To = araw.Episode_To
						
						INSERT INTO Avail_Raw 
						SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Avail_Dates_Code, Is_Exclusive, Episode_From, Episode_To, 0 FROM #Temp_Session_Raw 
						WHERE IsNull(Avail_Raw_Code, 0) = 0

						Update traw Set traw.Avail_Raw_Code = araw.Avail_Raw_Code FROM #Temp_Session_Raw traw
						Inner Join Avail_Raw araw On 
						traw.Acq_Deal_Code = araw.Acq_Deal_Code AND
						traw.Acq_Deal_Rights_Code = araw.Acq_Deal_Rights_Code AND
						traw.Avail_Dates_Code = araw.Avail_Dates_Code AND
						traw.Is_Exclusive = araw.Is_Exclusive AND
						traw.Episode_From = araw.Episode_From AND
						traw.Episode_To = araw.Episode_To AND 
						IsNull(traw.Avail_Raw_Code, 0) = 0
						
						Create Table #Temp_Batch_N(
							Avail_Acq_Show_Code Numeric(38,0), 
							Avail_Raw_Code Numeric(38,0), 
							Is_Title_Language BIT, 
							Sub_Language_Codes VARCHAR(Max), 
							Dub_Language_Codes VARCHAR(Max),
							Sub_Avail_Lang_Code Numeric(38, 0), 
							Dub_Avail_Lang_Code Numeric(38, 0)
						)

						--SELECT * FROM #Temp_Avail_Dates
						If Exists(SELECT Top 1 * FROM #Temp_Avail_Dates)
						Begin

							DECLARE @Is_Tit_Language BIT = 0, @Sub_Lang VARCHAR(Max) = '', @Dub_Lung VARCHAR(Max) = ''

							If Exists(SELECT Top 1 * FROM #Temp_Batch WHERE Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'T')
							Begin

								If(@Is_Title_Language_Right = 'Y')
								Begin
									--------------- INTERNATIONAL
			
									--INSERT INTO Avail_Acq_Show_Det(Avail_Acq_Show_Code, Avail_Raw_Code)
									INSERT INTO #Temp_Batch_N(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language)
									SELECT t.Avail_Acq_Show_Code, a.Avail_Raw_Code, 1
									FROM #TMP_ACQ_DETAILS t 
									Inner Join #Temp_Session_Raw AS a On 1 = 1
									WHERE t.Is_Syn = 'Y' AND Is_Theatrical_Right = 'N' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
										  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To
										  --AND t.Avail_Acq_Show_Code = 1010659
				--return
									PRINT 'AD 32 -' + @Syn_Rights_Codes + '-' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

									--------------- END
								END
							END
					
							If Exists(SELECT Top 1 * FROM #Temp_Batch WHERE Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'S')
							Begin
								--------------- INTERNATIONAL

								--INSERT INTO Avail_Acq_Show_Lang(Avail_Acq_Show_Code, Avail_Raw_Code, Language_Code)
								SELECT t.Avail_Acq_Show_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									   t.Language_Code INTO #Temp_Sub_New
								FROM #TMP_Acq_SUBTITLING t
								Inner Join #Temp_Session_Raw AS a On 1 = 1
								WHERE t.Is_Syn = 'Y' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
									  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To

								MERGE INTO #Temp_Batch_N AS tb
								USING (
									SELECT *, 
									STUFF(
										(
											SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
												SELECT DISTINCT Language_Code FROM #Temp_Sub_New subIn
												WHERE subIn.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code AND subIn.Avail_Raw_Code = a.Avail_Raw_Code
											) AS a
											FOR XML PATH('')
										), 1, 1, ''
									) AS Sub_Lang
									FROM(
										SELECT DISTINCT tsn.Avail_Acq_Show_Code, tsn.Avail_Raw_Code FROM #Temp_Sub_New tsn
									) AS a
								) AS temp On tb.Avail_Acq_Show_Code = temp.Avail_Acq_Show_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code
								WHEN MATCHED THEN
									UPDATE SET tb.Sub_Language_Codes = temp.Sub_Lang
								WHEN NOT MATCHED THEN
									INSERT VALUES (temp.Avail_Acq_Show_Code, temp.Avail_Raw_Code, 0, temp.Sub_Lang, Null, Null, Null)
								;

								Drop Table #Temp_Sub_New

								PRINT 'AD 34 -' + @Syn_Rights_Codes + '-' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

								--------------- END
						
							END
					
							If Exists(SELECT Top 1 * FROM #Temp_Batch WHERE Syn_Rights_Codes = @Syn_Rights_Codes AND Rec_Type = 'D')
							Begin
						
								-------------- INTERNATIONAL

								--INSERT INTO Avail_Acq_Show_Dub(Avail_Acq_Show_Code, Avail_Raw_Code, Language_Code)
								--SELECT t.Avail_Acq_Show_Code, a.Avail_Raw_Code, t.Language_Code
								--FROM #TMP_Acq_DUBBING t 
								--Inner Join #Temp_Session_Raw AS a On 1 = 1
								--WHERE t.Is_Syn = 'Y' AND Is_Theatrical_Right = 'N' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
								--	  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To

								SELECT t.Avail_Acq_Show_Code, a.Avail_Raw_Code, --a.Episode_From, a.Episode_To, 
									   t.Language_Code INTO #Temp_Dub_New
								FROM #TMP_Acq_DUBBING t
								Inner Join #Temp_Session_Raw AS a On 1 = 1
								WHERE t.Is_Syn = 'Y' AND t.Syn_Rights_Codes = @Syn_Rights_Codes 
									  AND t.Title_Code = @Process_Title_Code AND t.Episode_From = @Episode_From AND t.Episode_To = @Episode_To

								MERGE INTO #Temp_Batch_N AS tb
								USING (
									SELECT *, 
									STUFF(
										(
											SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM (
												SELECT DISTINCT Language_Code FROM #Temp_Dub_New subIn
												WHERE --subIn.Episode_From = a.Episode_From AND subIn.Episode_To = a.Episode_To AND
												subIn.Avail_Acq_Show_Code = a.Avail_Acq_Show_Code AND subIn.Avail_Raw_Code = a.Avail_Raw_Code
											) AS a
											FOR XML PATH('')
										), 1, 1, ''
									) AS Dub_Lang
									FROM(
										SELECT DISTINCT tsn.Avail_Acq_Show_Code, tsn.Avail_Raw_Code FROM #Temp_Dub_New tsn
									) AS a
								) AS temp On tb.Avail_Acq_Show_Code = temp.Avail_Acq_Show_Code AND tb.Avail_Raw_Code = temp.Avail_Raw_Code
								WHEN MATCHED THEN
									UPDATE SET tb.Dub_Language_Codes = temp.Dub_Lang
								WHEN NOT MATCHED THEN
									INSERT VALUES (temp.Avail_Acq_Show_Code, temp.Avail_Raw_Code, 0, Null, temp.Dub_Lang, Null, Null)
								;

								Drop Table #Temp_Dub_New
								PRINT 'AD 36 -' + @Syn_Rights_Codes + '-' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)

								-------------- END
		
							END

							Update #Temp_Batch_N Set Sub_Language_Codes = ',' + Sub_Language_Codes + ',' WHERE IsNull(Sub_Language_Codes, '') <> ''
							Update #Temp_Batch_N Set Dub_Language_Codes = ',' + Dub_Language_Codes + ',' WHERE IsNull(Dub_Language_Codes, '') <> ''

							INSERT INTO Avail_Languages(Language_Codes)
							SELECT DISTINCT Sub_Language_Codes FROM #Temp_Batch_N WHERE Sub_Language_Codes Not In (
								SELECT a.Language_Codes FROM Avail_Languages a
							) AND IsNull(Sub_Language_Codes, '') <> ''

							Update temp set temp.Sub_Avail_Lang_Code = al.Avail_Languages_Code FROM #Temp_Batch_N temp 
							Inner Join Avail_Languages al On temp.Sub_Language_Codes = al.Language_Codes

							
							INSERT INTO Avail_Languages(Language_Codes)
							SELECT DISTINCT Dub_Language_Codes FROM #Temp_Batch_N WHERE Dub_Language_Codes Not In (
								SELECT a.Language_Codes FROM Avail_Languages a
							) AND IsNull(Dub_Language_Codes, '') <> ''

							Update temp set temp.Dub_Avail_Lang_Code = al.Avail_Languages_Code FROM #Temp_Batch_N temp 
							Inner Join Avail_Languages al On temp.Dub_Language_Codes = al.Language_Codes

							--SELECT * FROM #Temp_Batch_N

							INSERT INTO Avail_Acq_Show_Details(Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
							SELECT Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Avail_Lang_Code, Dub_Avail_Lang_Code FROM #Temp_Batch_N

						END
						PRINT 'ad142'
						Drop Table #Temp_Batch_N
						Drop Table #Eps_Nos
						--Drop Table #Temp_Eps_Nos
						PRINT 'ad143'
						Truncate Table #Temp_Syndication
						Truncate Table #Temp_Syndication_Main
						Truncate Table #Temp_Syndication_NE
						Truncate Table #Temp_Avail_Dates

						Fetch Next FROM Cur_Process_Title INTO @Process_Title_Code, @Episode_From, @Episode_To
					END
					Close Cur_Process_Title
					Deallocate Cur_Process_Title

					Drop Table #Temp_Episode

					Fetch Next FROM Cur_Batch INTO @Syn_Rights_Codes
				END
				Close Cur_Batch
				Deallocate Cur_Batch

			END

			PRINT 'AD 38 -' + @Syn_Rights_Codes + '-' + CAST(@Acq_Deal_Rights_Code AS VARCHAR(10)) + ' - ' + CONVERT(VARCHAR(100), GETDATE(), 109)
			
			IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
			IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
			IF OBJECT_ID('tempdb..#TEMPAcqDetNew') IS NOT NULL DROP TABLE #TEMPAcqDetNew
			IF OBJECT_ID('tempdb..#Syn_Subtitling') IS NOT NULL DROP TABLE #Syn_Subtitling
			IF OBJECT_ID('tempdb..#Syn_Dubbing') IS NOT NULL DROP TABLE #Syn_Dubbing
			IF OBJECT_ID('tempdb..#Syn_Data') IS NOT NULL DROP TABLE #Syn_Data
			IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data
			--DROP TABLE #Syn_Sub_Avail_Data
			--DROP TABLE #Syn_Dub_Avail_Data

			IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL Drop Table #Temp_Syndication
			IF OBJECT_ID('tempdb..#Temp_Syndication_Main') IS NOT NULL Drop Table #Temp_Syndication_Main
			IF OBJECT_ID('tempdb..#Temp_Syndication_NE') IS NOT NULL Drop Table #Temp_Syndication_NE
			IF OBJECT_ID('tempdb..#Temp_Avail_Dates') IS NOT NULL Drop Table #Temp_Avail_Dates
			IF OBJECT_ID('tempdb..#Temp_Batch') IS NOT NULL Drop Table #Temp_Batch
			IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL Drop Table #TMP_ACQ_DETAILS
			IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL Drop Table #TMP_Acq_SUBTITLING
			IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL Drop Table #TMP_Acq_DUBBING
			IF OBJECT_ID('tempdb..#Syn_Rights') IS NOT NULL Drop Table #Syn_Rights
			--Drop Table #Eps_Nos

		END
		
		IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
		IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
		IF OBJECT_ID('tempdb..#TEMPAcqDetNew') IS NOT NULL DROP TABLE #TEMPAcqDetNew
		IF OBJECT_ID('tempdb..#Syn_Subtitling') IS NOT NULL DROP TABLE #Syn_Subtitling
		IF OBJECT_ID('tempdb..#Syn_Dubbing') IS NOT NULL DROP TABLE #Syn_Dubbing
		IF OBJECT_ID('tempdb..#Syn_Data') IS NOT NULL DROP TABLE #Syn_Data
		IF OBJECT_ID('tempdb..#Syn_Title_Avail_Data') IS NOT NULL DROP TABLE #Syn_Title_Avail_Data
		--DROP TABLE #Syn_Sub_Avail_Data
		--DROP TABLE #Syn_Dub_Avail_Data

		IF OBJECT_ID('tempdb..#Temp_Syndication') IS NOT NULL Drop Table #Temp_Syndication
		IF OBJECT_ID('tempdb..#Temp_Syndication_Main') IS NOT NULL Drop Table #Temp_Syndication_Main
		IF OBJECT_ID('tempdb..#Temp_Syndication_NE') IS NOT NULL Drop Table #Temp_Syndication_NE
		IF OBJECT_ID('tempdb..#Temp_Avail_Dates') IS NOT NULL Drop Table #Temp_Avail_Dates
		IF OBJECT_ID('tempdb..#Temp_Batch') IS NOT NULL Drop Table #Temp_Batch
		IF OBJECT_ID('tempdb..#TMP_ACQ_DETAILS') IS NOT NULL Drop Table #TMP_ACQ_DETAILS
		IF OBJECT_ID('tempdb..#TMP_Acq_SUBTITLING') IS NOT NULL Drop Table #TMP_Acq_SUBTITLING
		IF OBJECT_ID('tempdb..#TMP_Acq_DUBBING') IS NOT NULL Drop Table #TMP_Acq_DUBBING
		IF OBJECT_ID('tempdb..#Syn_Rights') IS NOT NULL Drop Table #Syn_Rights
		--Drop Table #Eps_Nos

		Truncate Table #Temp_Session_Raw
		Truncate Table #Temp_Session_Raw_Lang

		Fetch FROM CUR_Rights INTO @Acq_Deal_Code, @Acq_Deal_Rights_Code, @Sub_License_Code, @Actual_Right_Start_Date, @Actual_Right_End_Date, @Is_Title_Language_Right, @Is_Exclusive, @Is_Theatrical_Right
	END
	Close CUR_Rights
	Deallocate CUR_Rights

	Drop Table #Temp_Session_Raw
	Drop Table #Temp_Session_Raw_Lang
	Drop Table #Process_Rights

	If(@RecORd_Type = 'S')
	Begin

		PRINT 'AD SYN 1'

		Delete FROM Avail_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @RecORd_Code
		
		PRINT 'AD SYN 2'

		INSERT INTO Avail_Syn_Acq_Mapping(Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
		SELECT Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
		FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @RecORd_Code

		PRINT 'AD SYN 3'

	END

	--END TRY  
	--BEGIN CATCH

	--	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;

	--END CATCH
END

