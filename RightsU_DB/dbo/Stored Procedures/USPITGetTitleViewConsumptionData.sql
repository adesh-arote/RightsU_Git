CREATE PROCEDURE USPITGetTitleViewConsumptionData 
@TitleCode INT
AS
BEGIN
		IF OBJECT_ID('TEMPDB..#TempTitles') IS NOT NULL
			DROP TABLE #TempTitles

		IF OBJECT_ID('TEMPDB..#TempChannels') IS NOT NULL
			DROP TABLE #TempChannels

		CREATE Table #TempChannels
		(
			Channel_Code		INT,
			Channel_Name		NVARCHAR(MAX),
			Channel_Id			NVARCHAR(MAX),
			Order_For_schedule	INT
		)

		SELECT Title_Code, Title_Name INTO #TempTitles FROM Title T (NOLOCK)
		WHERE Title_Code IN (Select number AS TitleCode FROM fn_Split_withdelemiter(@TitleCode,',') where number <> '')

		INSERT INTO #TempChannels(Channel_Code, Channel_Name, Channel_Id, Order_For_schedule)
		SELECT Channel_Code, Channel_Name, Channel_Id, Order_For_schedule FROM Channel (NOLOCK)


		SELECT X.Agreement_No AS [Deal_No], 
			X.Channel_Name, SUM(Defined_Runs) NoOfRuns, SUM(Provision_Runs) Provision_Runs,
			SUM(Defined_Runs) - SUM(Provision_Runs) - SUM(Consume_Runs) Balance_Runs, Consume_Runs
			FROM
			(
				SELECT DISTINCT 
				CASE WHEN ISNULL(CCR.Acq_Deal_Code,0) = 0 THEN
					(SELECT PD.Agreement_No FROM Provisional_Deal PD (NOLOCK) WHERE CCR.Provisional_Deal_Code = PD.Provisional_Deal_Code)
					ELSE (SELECT AD.Agreement_No FROM Acq_Deal AD (NOLOCK) WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND CCR.Acq_Deal_Code = AD.Acq_Deal_Code)
				END Agreement_No,
				(select l.Language_Name from Language l
				INNER JOIN Title t ON t.Title_Language_Code = l.Language_Code
				 where t.Title_Code = TT.Title_Code ) AS TitleLanguage,
				TempC.Channel_Name, 
				CCR.Defined_Runs,
				(
					SELECT COUNT(*) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE BV.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND
					CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
					> GETDATE() AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y' AND ISNULL(BV.IsException, 'N') <> 'Y'
				) AS Provision_Runs,
				(
					SELECT COUNT(*) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE BV.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND
					CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
					<= GETDATE() AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y' AND ISNULL(BV.IsException, 'N') <> 'Y'
				) AS Consume_Runs
				FROM Content_Channel_Run CCR (NOLOCK)
				INNER JOIN #TempTitles TT ON CCR.Title_Code = TT.Title_Code
				INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Content_Code = CCR.Title_Content_Code
				INNER JOIN #TempChannels TempC ON TempC.Channel_Code = CCR.Channel_Code
				LEFT  JOIN Right_Rule RR (NOLOCK) on RR.Right_Rule_Code = CCR.Right_Rule_Code 
				INNER JOIN Acq_Deal acqd (NOLOCK) ON acqd.Acq_Deal_Code = CCR.Acq_Deal_Code
				Where ISNULL(CCR.Is_Archive, 'N') = 'N'
			) AS X
			GROUP BY X.Agreement_No, 
			X.Channel_Name,Consume_Runs, x.TitleLanguage

END