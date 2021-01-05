CREATE PROCEDURE [dbo].[USP_Syn_Deal_Rights_Holdback_Validation]            
(
	@Syn_Deal_Right_Code varchar(100),     
	@Platform_Code VARCHAR(500),            
	@TerritoryCountry_Code VARCHAR(500),    
	@Title_Code VARCHAR(500),
	@Deal_Type_Code INT,
	@IsTitleLangRight VARCHAR(1),
	@LanguageCode_Dub  VARCHAR(100),
    @LanguageCode_Sub VARCHAR(100),
	@Is_Exclusive CHAR(1)
)
AS
BEGIN
	IF OBJECT_ID('TEMPDB..#TempTitle') IS NOT NULL
		DROP TABLE #TempTitle

	IF OBJECT_ID('TEMPDB..#TempHoldbackCodes') IS NOT NULL
		DROP TABLE #TempHoldbackCodes

	IF OBJECT_ID('TEMPDB..#TempHoldback') IS NOT NULL
		DROP TABLE #TempHoldback

	IF OBJECT_ID('TEMPDB..#TempHoldback_TL') IS NOT NULL
		DROP TABLE #TempHoldback_TL

	IF OBJECT_ID('TEMPDB..#Lang_Sub') IS NOT NULL
		DROP TABLE #Lang_Sub

	IF OBJECT_ID('TEMPDB..#Lang_Dub') IS NOT NULL
		DROP TABLE #Lang_Dub

	DECLARE @Deal_Type_Condition VARCHAR(MAX) = '', @Rec_Count INT = 0
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)
	
	IF(@Is_Exclusive = 'Y')
	BEGIN
		CREATE TABLE #TempTitle(
			Title_Code VARCHAR(MAX),
			Episode_FROM INT,
			Episode_To INT
		)

		IF(@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'Deal_Music')
		BEGIN
			insert into #TempTitle(Title_Code,Episode_From,Episode_To)
			select Title_Code , Episode_From, Episode_End_To
			FROM Syn_Deal_Movie WHERE Syn_Deal_Movie_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Title_Code, ','))
		END
		ELSE 
		BEGIN
			insert into #TempTitle(Title_Code,Episode_From,Episode_To)
			select Title_Code , 1 , 1
			FROM Title WHERE Title_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Title_Code, ','))
		END
		

		SELECT Syn_Deal_Rights_Holdback_Code INTO #TempHoldbackCodes FROM (
			SELECT DISTINCT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback_Platform
			WHERE Platform_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Platform_Code, ','))
			INTERSECT
			SELECT DISTINCT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback_Territory 
			WHERE Country_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@TerritoryCountry_Code, ','))
		) AS a WHERE Syn_Deal_Rights_Holdback_Code IS NOT NULL AND Syn_Deal_Rights_Holdback_Code NOT IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Syn_Deal_Right_Code, ','))
		
		

		SELECT HB.Syn_Deal_Rights_Code, HB.Syn_Deal_Rights_Holdback_Code, HB.Is_Original_Language INTO #TempHoldback FROM #TempHoldbackCodes T
		INNER JOIN Syn_Deal_Rights_Holdback HB On T.Syn_Deal_Rights_Holdback_Code = HB.Syn_Deal_Rights_Holdback_Code


		SELECT HB.Syn_Deal_Rights_Code, HB.Syn_Deal_Rights_Holdback_Code, HB.Is_Original_Language INTO  #TempHoldback_TL FROM #TempHoldbackCodes T
		INNER JOIN #TempHoldback HB On T.Syn_Deal_Rights_Holdback_Code = HB.Syn_Deal_Rights_Holdback_Code
		INNER JOIN Syn_Deal_Rights_Title RT On HB.Syn_Deal_Rights_Code = RT.Syn_Deal_Rights_Code
		INNER JOIN #TempTitle THB ON THB.Title_Code = RT.Title_Code AND (
			(THB.Episode_FROM BETWEEN RT.Episode_FROM AND RT.Episode_To) OR 
			(THB.Episode_To BETWEEN RT.Episode_FROM AND RT.Episode_To) OR
			(RT.Episode_FROM BETWEEN THB.Episode_FROM AND THB.Episode_To) OR
			(RT.Episode_To BETWEEN THB.Episode_FROM AND THB.Episode_To)
		)


		IF EXISTS (SELECT Syn_Deal_Rights_Code FROM #TempHoldback_TL )
		BEGIN
			IF(@IsTitleLangRight = 'Y')
			BEGIN
				PRINT 'Check Title Language Rights Duplication'
				SELECT @Rec_Count = COUNT(Syn_Deal_Rights_Code) FROM #TempHoldback_TL WHERE Is_Original_Language = 'Y'
			END

			IF(@Rec_Count = 0 AND @LanguageCode_Sub <> '')
			BEGIN
				PRINT 'Check Subtitle Language Duplication'

				SELECT number AS LangaugeCode INTO #Lang_Sub FROM fn_Split_withdelemiter(@LanguageCode_Sub, ',') where number <> ''

				SELECT @Rec_Count = COUNT(THB.Syn_Deal_Rights_Code) FROM #TempHoldback_TL THB
				INNER JOIN Syn_Deal_Rights_Holdback_Subtitling SDRHS ON SDRHS.Syn_Deal_Rights_Holdback_Code = THB.Syn_Deal_Rights_Holdback_Code
				INNER JOIN #Lang_Sub LS ON CAST(LS.LangaugeCode AS INT) = SDRHS.Language_Code
				Where SDRHS.Syn_Deal_Rights_Holdback_Code IS NOT NULL

				DROP TABLE #Lang_Sub
			END

			IF(@Rec_Count = 0 AND @LanguageCode_Dub <> '')
			BEGIN
				PRINT 'Check Dubbing Language Duplication'

				SELECT number AS LangaugeCode INTO #Lang_Dub FROM fn_Split_withdelemiter(@LanguageCode_Dub, ',') where number <> ''

				SELECT @Rec_Count = COUNT(THB.Syn_Deal_Rights_Code) FROM #TempHoldback_TL THB
				INNER JOIN Syn_Deal_Rights_Holdback_Dubbing SDRHD ON SDRHD.Syn_Deal_Rights_Holdback_Code = THB.Syn_Deal_Rights_Holdback_Code
				INNER JOIN #Lang_Dub DS ON CAST(DS.LangaugeCode AS INT) = SDRHD.Language_Code
				Where SDRHD.Syn_Deal_Rights_Holdback_Code IS NOT NULL
				
				DROP TABLE #Lang_Dub
			END
		END
		ELSE
		BEGIN
			SET @Rec_Count = 0
		END
	END
	ELSE
	BEGIN
		SET @Rec_Count = 0 
	END

	SELECT @Rec_Count AS Rec_Count

	DROP TABLE #TempTitle
	DROP TABLE #TempHoldbackCodes
	DROP TABLE #TempHoldback
	DROP TABLE #TempHoldback_TL

	IF OBJECT_ID('tempdb..#Lang_Dub') IS NOT NULL DROP TABLE #Lang_Dub
	IF OBJECT_ID('tempdb..#Lang_Sub') IS NOT NULL DROP TABLE #Lang_Sub
	IF OBJECT_ID('tempdb..#TempHoldback') IS NOT NULL DROP TABLE #TempHoldback
	IF OBJECT_ID('tempdb..#TempHoldback_TL') IS NOT NULL DROP TABLE #TempHoldback_TL
	IF OBJECT_ID('tempdb..#TempHoldbackCodes') IS NOT NULL DROP TABLE #TempHoldbackCodes
	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
END