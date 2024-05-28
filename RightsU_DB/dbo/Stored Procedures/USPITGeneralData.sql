CREATE PROCEDURE [dbo].[USPITGeneralData](@TitleCodes NVARCHAR(MAX))
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGeneralData]', 'Step 1', 0, 'Started Procedure', 0, ''

	--DECLARE @TitleCodes NVARCHAR(MAX) = '5069,5101,5102,9974,6307'
		CREATE TABLE #tempGeneral
		(
			Title_Code INT,
			Title_Name NVARCHAR(200),
			Acq_Deal_Code INT,
			OpeningOfPromotionalWindow NVARCHAR(MAX),
			OpeningOfSyndicationWindow NVARCHAR(MAX),
			GeneralRemarks NVARCHAR(MAX) DEFAULT(''),
			RightsRemarks NVARCHAR(MAX) DEFAULT(''),
			Syn_GeneralRemarks NVARCHAR(MAX) DEFAULT('')
		)


		INSERT INTO #tempGeneral(Acq_Deal_Code, Title_Code, GeneralRemarks, RightsRemarks, OpeningOfPromotionalWindow, OpeningOfSyndicationWindow)
		SELECT DISTINCT ad.Acq_Deal_Code, ADRT.Title_Code, ad.Remarks, ad.Rights_Remarks, '', ''
		FROM Acq_Deal ad WITH (NOLOCK)
		INNER JOIN Acq_Deal_Rights adr WITH (NOLOCK) ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		WHERE GETDATE() BETWEEN adr.Actual_Right_Start_Date AND ISNULL(adr.Actual_Right_End_Date, '31DEC9999') AND ADRT.Title_Code IN (
			SELECT Number From DBO.fn_Split_withdelemiter(ISNULL(@TitleCodes, ''), ',') WHERE ISNULL(Number, '') NOT IN ('', '0')
		)

		UPDATE tg SET tg.Syn_GeneralRemarks = ad.Remarks
		from #tempGeneral tg
		INNER JOIN Syn_Acq_Mapping sam ON Sam.Deal_Code = tg.Acq_Deal_Code
		INNER JOIN Syn_Deal ad ON ad.Syn_DEal_COde = sam.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights sdr ON sdr.Syn_Deal_Code = ad.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights_Title sdrt ON sdrt.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code AND sdrt.Title_Code = tg.Title_Code

		UPDATE tmp SET tmp.Title_Name = t.Title_Name
		FROM #tempGeneral tmp
		INNER JOIN Title t ON tmp.Title_Code = t.Title_Code
	
		--UPDATE tgOut SET tgOut.OpeningOfPromotionalWindow = anc.Values1
		--FROM (
		--	SELECT DISTINCT adra.Values1, tg.Title_Code, tg.Acq_Deal_Code
		--	FROM #tempGeneral tg WITH (NOLOCK)
		--	INNER JOIN Acq_Deal_Rights adr WITH (NOLOCK) ON tg.Acq_Deal_Code = adr.Acq_Deal_Code
		--	INNER JOIN Acq_Deal_Rights_Title ADRT WITH (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code AND adrt.Title_Code = tg.Title_Code
		--	INNER JOIN Acq_Deal_Rights_Ancillary adra WITH (NOLOCK) ON adr.Acq_Deal_Rights_Code = adra.Acq_Deal_Rights_Code
		--	INNER JOIN Ancillary a WITH (NOLOCK) ON adra.Ancillary_Code = a.Ancillary_Code
		--	WHERE a.Ancillary_Name IN ('Opening of Promotional Window')
		--) AS anc
		--INNER JOIN #tempGeneral tgOut ON anc.Acq_Deal_Code = tgOut.Acq_Deal_Code AND anc.Title_Code = tgOut.Title_Code
	
		--UPDATE tgOut SET tgOut.OpeningOfSyndicationWindow = anc.Values1
		--FROM (
		--	SELECT DISTINCT adra.Values1, tg.Title_Code, tg.Acq_Deal_Code
		--	FROM #tempGeneral tg WITH (NOLOCK)
		--	INNER JOIN Acq_Deal_Rights adr WITH (NOLOCK) ON tg.Acq_Deal_Code = adr.Acq_Deal_Code
		--	INNER JOIN Acq_Deal_Rights_Title ADRT WITH (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code AND adrt.Title_Code = tg.Title_Code
		--	--INNER JOIN Acq_Deal_Rights_Ancillary adra WITH (NOLOCK) ON adr.Acq_Deal_Rights_Code = adra.Acq_Deal_Rights_Code
		--	--INNER JOIN Ancillary a WITH (NOLOCK) ON adra.Ancillary_Code = a.Ancillary_Code
		--	--WHERE a.Ancillary_Name IN ('Opening of Syndication Window')
		--) AS anc
		--INNER JOIN #tempGeneral tgOut ON anc.Acq_Deal_Code = tgOut.Acq_Deal_Code AND anc.Title_Code = tgOut.Title_Code

		-----------------------------------------------------------------------------------------------------------------------------------------

		--UPDATE #tempGeneral SET OpeningOfSyndicationWindow = (SELECT  DISTINCT adra.Values1
		--FROM Ancillary a
		--INNER JOIN Acq_Deal_Rights_Ancillary adra ON adra.Ancillary_Code = a.Ancillary_Code
		--INNER JOIN Acq_Deal_Rights_Title ADRT ON adrt.Acq_Deal_Rights_Code = adra.Acq_Deal_Rights_Code
		--INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		--INNER JOIN Acq_Deal ad on ad.Acq_Deal_Code = adr.Acq_Deal_Code
		--WHERE a.Ancillary_Name IN ('Opening of Syndication Window')
		--AND ADRT.Title_Code IN (@TitleCodes))--(Select Distinct Title_Code FROM RightsU_Avail_Neo..Avail_Title_Data))

		--UPDATE #tempGeneral SET GeneralRemarks = (SELECT  DISTINCT top 1 ad.Remarks
		--FROM Ancillary a
		--INNER JOIN Acq_Deal_Rights_Ancillary adra ON adra.Ancillary_Code = a.Ancillary_Code
		--INNER JOIN Acq_Deal_Rights_Title ADRT ON adrt.Acq_Deal_Rights_Code = adra.Acq_Deal_Rights_Code
		--INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		--INNER JOIN Acq_Deal ad on ad.Acq_Deal_Code = adr.Acq_Deal_Code
		--WHERE 
		--ADRT.Title_Code IN (@TitleCodes))--(Select Distinct Title_Code FROM RightsU_Avail_Neo..Avail_Title_Data))

		--UPDATE #tempGeneral SET GeneralRemarks = (SELECT  DISTINCT top 1 ad.Rights_Remarks
		--FROM Ancillary a
		--INNER JOIN Acq_Deal_Rights_Ancillary adra ON adra.Ancillary_Code = a.Ancillary_Code
		--INNER JOIN Acq_Deal_Rights_Title ADRT ON adrt.Acq_Deal_Rights_Code = adra.Acq_Deal_Rights_Code
		--INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		--INNER JOIN Acq_Deal ad on ad.Acq_Deal_Code = adr.Acq_Deal_Code
		--WHERE 
		--ADRT.Title_Code IN (@TitleCodes))--(Select Distinct Title_Code FROM RightsU_Avail_Neo..Avail_Title_Data))
	
		SELECT Acq_Deal_Code AS DealCode, RTRIM(LTRIM(ISNULL(OpeningOfPromotionalWindow,''))) AS OpeningOfPromotionalWindow , RTRIM(LTRIM(ISNULL(OpeningOfSyndicationWindow,''))) AS OpeningOfSyndicationWindow,
		RTRIM(LTRIM(ISNULL(GeneralRemarks,''))) AS GeneralRemarks, RTRIM(LTRIM(ISNULL(RightsRemarks,''))) AS RightsRemarks,RTRIM(LTRIM(ISNULL(Syn_GeneralRemarks,''))) AS Syn_GeneralRemarks 
		FROM #tempGeneral

		DROP TABLE #tempGeneral
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGeneralData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END