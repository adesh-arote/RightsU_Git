CREATE PROCEDURE USPGetRURContentMappedData
	@MappedContentReportUDT MappedContentReportUDT READONLY 
AS
BEGIN
--DECLARE @TitleCode INT = 6310
	BEGIN
	--DECLARE @MappedContentReportUDT MappedContentReportUDT
	--INSERT INTO @MappedContentReportUDT(
	--	RUTitleCode, RUTitleContentCode, PlatformCode, CountryCode, EpisodeFrom, EpisodeTo, DBSource, SubtitlingCode, ExpireDays, MHReportCode, ExpiredDeal
	--)
	--VALUES
	--	('639','0','111,123,182,191','1,10,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,12,120,121,122,123,124,125,127,128,13,130,131,132,133,134,135,137,138,139,14,140,141,142,143,145,146,147,148,149,15,16,160,164,166,167,168,169,17,170,18,182,183,184,188,189,19,190,191,192,193,2,20,200,204,205,206,209,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,23,230,231,232,235,236,237,238,239,24,246,247,248,249,250,251,252,255,256,257,258,264,265,266,267,268,269,27,270,271,272,273,275,276,277,278,279,28,280,281,282,283,284,285,286,287,288,289,293,294,295,296,299,3,30,300,301,302,304,305,306,307,308,309,31,310,311,312,313,314,315,316,317,318,319,32,320,321,322,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,341,35,36,37,38,39,4,40,41,42,44,47,48,5,50,51,52,53,54,55,57,58,59,6,60,61,62,65,66,67,73,74,75,76,77,8,82,83,84,85,93,94,95,96,97,98,99',
	--	'0','0','V18','6','0','2','N')
	--DECLARE @MappedContentReportUDT MappedContentReportUDT
	--INSERT INTO @MappedContentReportUDT(
	--	RUTitleCode, RUTitleContentCode, PlatformCode, CountryCode, EpisodeFrom, EpisodeTo, DBSource, SubtitlingCode, ExpireDays, MHReportCode, ExpiredDeal
	--)
	--VALUES
	--	(566,0,'111,123,182,191','1,10,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,12,120,121,122,123,124,125,127,128,13,130,131,132,133,134,135,137,138,139,14,140,141,142,143,145,146,147,148,149,15,16,160,164,166,167,168,169,17,170,18,182,183,184,188,189,19,190,191,192,193,2,20,200,204,205,206,209,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,23,230,231,232,235,236,237,238,239,24,246,247,248,249,250,251,252,255,256,257,258,264,265,266,267,268,269,27,270,271,272,273,275,276,277,278,279,28,280,281,282,283,284,285,286,287,288,289,293,294,295,296,299,3,30,300,301,302,304,305,306,307,308,309,31,310,311,312,313,314,315,316,317,318,319,32,320,321,322,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,341,35,36,37,38,39,4,40,41,42,44,47,48,5,50,51,52,53,54,55,57,58,59,6,60,61,62,65,66,67,73,74,75,76,77,8,82,83,84,85,93,94,95,96,97,98,99',null,null,'V18','6','1113',3,'Y')

		DECLARE @AVODPlatformCodes VARCHAR(100),@SVODPlatformCodes VARCHAR(100)
		SELECT @AVODPlatformCodes = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'DIAVODPlatformCodes'
		SELECT @SVODPlatformCodes = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'DISVODPlatformCodes'

		IF OBJECT_ID('TEMPDB..#TempAvodPlatform') IS NOT NULL
			DROP TABLE #TempAvodPlatform

		IF OBJECT_ID('TEMPDB..#TempSvodPlatform') IS NOT NULL
			DROP TABLE #TempSvodPlatform
		
		IF OBJECT_ID('TEMPDB..#TempRightsCodes') IS NOT NULL
			DROP TABLE #TempRightsCodes

		IF OBJECT_ID('TEMPDB..#TempData') IS NOT NULL
			DROP TABLE #TempData

		IF OBJECT_ID('TEMPDB..#TempSplitCountry') IS NOT NULL
			DROP TABLE #TempSplitCountry

		IF OBJECT_ID('TEMPDB..#TempLanguage') IS NOT NULL
			DROP TABLE #TempLanguage

		IF OBJECT_ID('TEMPDB..#TempMappedContentData') IS NOT NULL
			DROP TABLE #TempMappedContentData

		IF OBJECT_ID('TEMPDB..#tempCountry') IS NOT NULL
			DROP TABLE #tempCountry
			
		IF OBJECT_ID('TEMPDB..#TempCountryData') IS NOT NULL
			DROP TABLE #TempCountryData

		IF OBJECT_ID('TEMPDB..#TempPlatform') IS NOT NULL
			DROP TABLE #TempPlatform

		IF OBJECT_ID('TEMPDB..#TempFinalPlatformData') IS NOT NULL
			DROP TABLE #TempFinalPlatformData

		IF OBJECT_ID('TEMPDB..#TempSplitPlatform') IS NOT NULL
			DROP TABLE #TempSplitPlatform

		IF OBJECT_ID('TEMPDB..#TempPlatformData') IS NOT NULL
			DROP TABLE #TempPlatformData

		IF OBJECT_ID('TEMPDB..#TempTitleData') IS NOT NULL
			DROP TABLE #TempTitleData
		
		CREATE TABLE #TempRightsCodes(
			Acq_Deal_Rights_Code INT,
			CountryNames NVARCHAR(MAX),
			PlatformCodes VARCHAR(50),
		)
		CREATE TABLE #TempAvodPlatform
		(
			PlatformCodes INT
		)
		CREATE TABLE #TempSvodPlatform
		(
			PlatformCodes INT
		)
		CREATE TABLE #TempSplitCountry
		(
			CountryCodes INT,
			TitleCode INT
		)
		CREATE TABLE #TempSplitPlatform
		(
			PlatformCodes INT,
			TitleCode INT
		)
		CREATE TABLE #TempTitleData
		(
			Acq_Deal_Rights_code INT,
			Title_Code INT,
			Episode_From INT,
			Episode_To INT
		)


		CREATE Table #TempData
		(
			ID INT IDENTITY(1,1),
			RUTitleCode INT,
			RUTitleContentCode INT,
			PlatformCode VARCHAR(4000),
			CountryCode VARCHAR(4000),
			EpisodeFrom INT ,
			EpisodeTo INT ,
			DBSource VARCHAR(10) NULL,
			SubtitlingCode VARCHAR(100),
			ExpireDays Int NULL,
			MHReportCode INT NULL,
			ExpiredDeal VARCHAR(1) NULL
		)

		DECLARE @Episode_From INT, @Episode_To INT, @ExpiredDeal CHAR(1), @ExpireDays INT
		INSERT INTO #TempData(RUTitleCode, RUTitleContentCode, PlatformCode, CountryCode, EpisodeFrom, EpisodeTo, DBSource, SubtitlingCode, ExpireDays, MHReportCode, ExpiredDeal)
		SELECT RUTitleCode, RUTitleContentCode, PlatformCode, CountryCode, EpisodeFrom, EpisodeTo, DBSource, SubtitlingCode, ExpireDays, MHReportCode, ExpiredDeal FROM @MappedContentReportUDT
				
		SELECT @Episode_From = CASE WHEN EpisodeFrom = 0 THEN 1 ELSe EpisodeFrom END FROM #TempData
		SELECT @Episode_To = CASE WHEN EpisodeTo = 0 THEN 10000 ELSE EpisodeTo END FROM #TempData
		SELECT @ExpiredDeal = ExpiredDeal FROM #TempData
		SELECT @ExpireDays = ExpireDays FROM #TempData

		INSERT INTO #TempSplitPlatform(PlatformCodes)
		SELECT Distinct number AS PlatformCodes
		FROM #TempData TD
		CROSS APPLY dbo.fn_Split_withdelemiter(TD.PlatformCode,',')
		
		INSERT INTO #TempAvodPlatform(PlatformCodes)
		SELECT number FROM dbo.fn_Split_withdelemiter(@AVODPlatformCodes, ',') WHERE number NOT IN ( '0', '')

		INSERT INTO #TempSvodPlatform(PlatformCodes)
		SELECT number FROM dbo.fn_Split_withdelemiter(@SVODPlatformCodes, ',') WHERE number NOT IN ( '0', '')

		DELETE FROM #TempAvodPlatform WHERE PlatformCodes NOT IN (
			SELECT PlatformCodes FROM #TempSplitPlatform 
		)
		
		DELETE FROM #TempSvodPlatform WHERE PlatformCodes NOT IN (
			SELECT PlatformCodes FROM #TempSplitPlatform 
		)

		INSERT INTO #TempRightsCodes(Acq_Deal_Rights_Code)
		select distinct a.Acq_Deal_Rights_Code
		FROM 
		(
			SELECT Distinct ADRP.Acq_Deal_Rights_Code 
			FROM Acq_Deal_Rights_Platform ADRP
			INNER JOIN #TempAvodPlatform pl ON ADRP.Platform_Code = pl.PlatformCodes
			GROUP BY ADRP.Acq_Deal_Rights_Code
			HAVING COUNT(*) = 2
			UNION ALL
			SELECT Distinct ADRP.Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights_Platform ADRP
			INNER JOIN #TempSvodPlatform pl ON ADRP.Platform_Code = pl.PlatformCodes
			GROUP BY ADRP.Acq_Deal_Rights_Code
			HAVING COUNT(*) = 2
		) as a

		INSERT INTO #TempSplitCountry(CountryCodes)
		SELECT Distinct number AS CountryCodes
		FROM #TempData TD
		CROSS APPLY dbo.fn_Split_withdelemiter(TD.CountryCode,',')
		
		INSERT INTO #TempTitleData(Acq_Deal_Rights_code, Title_Code, Episode_From, Episode_To)
		SELECT ADRT.Acq_Deal_Rights_Code, ADRT.Title_Code,
		CASE WHEN @Episode_From >= ADRT.Episode_From THEN @Episode_From	ELSE ADRT.Episode_From END AS Epsiode_From,
		CASE WHEN @Episode_To >= ADRT.Episode_To THEN ADRT.Episode_To ELSE @Episode_To END AS Episode_To
		FROM Acq_Deal_Rights_Title ADRT
		INNER JOIN #TempData TD ON TD.RUTitleCode = ADRT.Title_Code AND
		(
			@Episode_From BETWEEN ADRT.Episode_From AND ADRT.Episode_To OR
			@Episode_To BETWEEN ADRT.Episode_From AND ADRT.Episode_To OR
			ADRT.Episode_From BETWEEN @Episode_From AND @Episode_To OR
			ADRT.Episode_To BETWEEN @Episode_From AND @Episode_To
		)

		DELETE FROM #TempRightsCodes WHERE Acq_Deal_Rights_Code NOT IN (
			SELECT DISTINCT TTD.Acq_Deal_Rights_Code FROM #TempTitleData TTD
		)

		SELECT Distinct Acq_Deal_Rights_Code, a.Country_Code, c.Country_Name INTO #TempCountry
		FROM (
			SELECT  ADRT.Acq_Deal_Rights_Code, TD.Country_Code 
			FROM Acq_Deal_Rights_Territory ADRT
			INNER JOIN Territory_Details TD ON ADRT.Territory_Code = TD.Territory_Code AND ADRT.Territory_Type = 'G'
			INNER JOIN #TempRightsCodes TRC ON TRC.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN #TempSplitCountry TSC ON TSC.CountryCodes = Td.Country_Code
			UNION ALL
			SELECT ADRT.Acq_Deal_Rights_Code, ADRT.Country_Code 
			FROM Acq_Deal_Rights_Territory ADRT
			INNER JOIN #TempRightsCodes TRC ON TRC.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADRT.Territory_Type = 'I'
			INNER JOIN #TempSplitCountry TSC ON TSC.CountryCodes = ADRT.Country_Code
		) AS a
		INNER JOIN Country c ON c.Country_Code = a.Country_Code
		
	
		DELETE FROM #TempRightsCodes WHERE Acq_Deal_Rights_Code NOT IN (
			SELECT DISTINCT tc.Acq_Deal_Rights_Code FROM #TempCountry tc
		)

		SELECT Acq_Deal_Rights_Code, a.Language_Code, c.Language_Name INTO #TempLanguage
		FROM (
			SELECT ADRS.Acq_Deal_Rights_Code, lg.Language_Code 
			FROM Acq_Deal_Rights_Subtitling ADRS
			INNER JOIN Language_Group_Details LG ON ADRS.Language_Group_Code = LG.Language_Group_Code AND LG.Language_Code = 6
			INNER JOIN #TempRightsCodes TRC ON TRC.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code
			UNION ALL
			SELECT ADRS.Acq_Deal_Rights_Code, ADRS.Language_Code 
			FROM Acq_Deal_Rights_Subtitling ADRS
			INNER JOIN #TempRightsCodes TRC ON TRC.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code AND ADRS.Language_Code = 6
		) AS a
		INNER JOIN Language c ON c.Language_Code = a.Language_Code
		
		DELETE FROM #TempRightsCodes WHERE Acq_Deal_Rights_Code NOT IN (
			SELECT DISTINCT tl.Acq_Deal_Rights_Code FROM #TempLanguage tl
		)

		SELECT Distinct Acq_Deal_Rights_Code, a.PlatformCodes INTO #TempFinalPlatformData
		FROM (
			SELECT Distinct ADRP.Acq_Deal_Rights_Code, TSP.PlatformCodes
			FROM Acq_Deal_Rights_Platform ADRP
			INNER JOIN #TempRightsCodes TRC ON TRC.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			INNER JOIN #TempSplitPlatform TSP ON TSP.PlatformCodes = ADRP.Platform_Code
			UNION ALL
			SELECT Distinct ADRP.Acq_Deal_Rights_Code, TSPP.PlatformCodes
			FROM Acq_Deal_Rights_Platform ADRP
			INNER JOIN #TempRightsCodes TRC ON TRC.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			INNER JOIN #TempSplitPlatform TSPP ON TSPP.PlatformCodes = ADRP.Platform_Code
		) AS a
		ORDER BY a.Acq_Deal_Rights_Code

		DELETE FROM #TempRightsCodes WHERE Acq_Deal_Rights_Code NOT IN (
			SELECT DISTINCT tT.Acq_Deal_Rights_Code FROM #TempTitleData tT
		)

		UPDATE #TempRightsCodes 
		SET CountryNames = STUFF((
			SELECT DISTINCT ',' + CAST(TC1.Country_Name AS VARCHAR)
			FROM #TempCountry TC1
			WHERE TC1.Acq_Deal_Rights_code = #TempRightsCodes.Acq_Deal_Rights_code
			FOR XML PATH('')
		), 1, 1, '')

		UPDATE #TempRightsCodes 
		SET PlatformCodes = STUFF((
			SELECT DISTINCT ',' + CAST(TFPD1.PlatformCodes AS VARCHAR)
			FROM #TempFinalPlatformData TFPD1
			WHERE TFPD1.Acq_Deal_Rights_code = #TempRightsCodes.Acq_Deal_Rights_code
			FOR XML PATH('')
		), 1, 1, '') 

		SELECT DISTINCT TTD.Title_Code AS Title_Code, TCT.Title_Content_Code,
		CASE WHEN  ADR.Right_Type= 'U' THEN 'Perpetuity' ELSE 'Yearwise' END AS Right_Type ,
		ADR.Right_Start_Date AS RightsStartPeriod, CASE When ADR.Right_Type = 'Y' THEN ADR.Actual_Right_End_Date ELSE CAST('31 Dec 9999' AS DATETIME)  END AS RightsEndPeriod, 
		TRC.PlatformCodes AS PlatformCodes,  TC.Country_Name AS CountryName ,--TRC.CountryNames AS CountryName,
		CASE WHEN ISNULL(TL.Language_Name, '') = '' THEN 'No' Else 'Yes' END AS Subtilting		
		INTO #TempMappedContentData
		FROM #TempRightsCodes TRC
		INNER JOIN #TempTitleData TTD ON TRC.Acq_Deal_Rights_Code = TTD.Acq_Deal_Rights_code
		INNER JOIN #TempCountry TC ON TC.Acq_Deal_Rights_Code = TRC.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = TRC.Acq_Deal_Rights_Code AND ISNULL(adr.Actual_Right_End_Date, '31DEC2099') > GETDATE()
		INNER JOIN Title_Content TCT ON TCT.Title_Code = TTD.Title_Code
		LEFT JOIN #TempLanguage TL ON TL.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		WHERE 
		((TTD.Episode_From <> '' AND TTD.Episode_To <> '' AND TCT.Episode_No between TTD.Episode_From AND TTD.Episode_To) OR ISNULL(TTD.Episode_From,'') = '' OR ISNULL(TTD.Episode_To, '') = '')
		--AND (@ExpiredDeal ='Y' OR ((CONVERT(datetime,ADR.Right_End_Date,1) >= GETDATE() AND @ExpiredDeal ='N')))    
		AND ((ADR.Actual_Right_End_Date IS NOT NULL AND
		DATEDIFF(d, GETDATE(), ISNULL(ADR.Actual_Right_End_Date , GETDATE())) BETWEEN 0 AND @ExpireDays
		AND  ISNULL(@ExpireDays, '') <> '' AND @ExpireDays <> '0') OR @ExpireDays = '0' OR ISNULL(@ExpireDays,'') = '' )

		select * from #TempMappedContentData
	END

	IF OBJECT_ID('tempdb..#TempAvodPlatform') IS NOT NULL DROP TABLE #TempAvodPlatform
	IF OBJECT_ID('tempdb..#TempCountry') IS NOT NULL DROP TABLE #TempCountry
	IF OBJECT_ID('tempdb..#TempCountryData') IS NOT NULL DROP TABLE #TempCountryData
	IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
	IF OBJECT_ID('tempdb..#TempFinalPlatformData') IS NOT NULL DROP TABLE #TempFinalPlatformData
	IF OBJECT_ID('tempdb..#TempLanguage') IS NOT NULL DROP TABLE #TempLanguage
	IF OBJECT_ID('tempdb..#TempMappedContentData') IS NOT NULL DROP TABLE #TempMappedContentData
	IF OBJECT_ID('tempdb..#TempPlatform') IS NOT NULL DROP TABLE #TempPlatform
	IF OBJECT_ID('tempdb..#TempPlatformData') IS NOT NULL DROP TABLE #TempPlatformData
	IF OBJECT_ID('tempdb..#TempRightsCodes') IS NOT NULL DROP TABLE #TempRightsCodes
	IF OBJECT_ID('tempdb..#TempSplitCountry') IS NOT NULL DROP TABLE #TempSplitCountry
	IF OBJECT_ID('tempdb..#TempSplitPlatform') IS NOT NULL DROP TABLE #TempSplitPlatform
	IF OBJECT_ID('tempdb..#TempSvodPlatform') IS NOT NULL DROP TABLE #TempSvodPlatform
	IF OBJECT_ID('tempdb..#TempTitleData') IS NOT NULL DROP TABLE #TempTitleData
END

--select * from Acq_Deal_Rights_Title where title_Code = 639