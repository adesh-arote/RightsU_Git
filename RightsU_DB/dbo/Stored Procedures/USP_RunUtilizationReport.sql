alter PROC USP_RunUtilizationReport
(
	@TitleCodes			VARCHAR(MAX), 
	@ChannelCodes		VARCHAR(MAX),
	@Run_Type			CHAR(1),
	@ExcludeExpiredDeal	CHAR(1) = 'N',
	@AllYears			CHAR(1) = 'N'
)
AS
BEGIN
	--DECLARE 
	--@TitleCodes			VARCHAR(MAX) = '28496', 
	--@ChannelCodes			VARCHAR(MAX) = '1', 
	--@Run_Type				CHAR(1),
	--@ExcludeExpiredDeal	CHAR(1) = 'N',
	--@AllYears				CHAR(1) = 'N'

	IF OBJECT_ID('TEMPDB..#TempTitles') IS NOT NULL
		DROP TABLE #TempTitles
	
	IF OBJECT_ID('TEMPDB..#TempChannels') IS NOT NULL
		DROP TABLE #TempChannels

	CREATE Table #TempTitles
	(
		Title_Code INT,
		Title_Name NVARCHAR(MAX)
	)
	CREATE Table #TempChannels
	(
		Channel_Code		INT,
		Channel_Name		NVARCHAR(MAX),
		Channel_Id			NVARCHAR(MAX),
		Order_For_schedule	INT
	)

	INSERT INTO #TempTitles(Title_Code)
	Select number AS TitleCode FROM fn_Split_withdelemiter(ISNULL(@TitleCodes, ''),',') where number <> ''

	UPDATE TT SET TT.Title_Name = T.Title_Name FROM #TempTitles TT
	INNER JOIN Title T ON T.Title_Code = TT.Title_Code

	IF (ISNULL(@ChannelCodes,'') <> '') 
	BEGIN
		INSERT INTO #TempChannels(Channel_Code)
		Select number AS Channel_Code from fn_Split_withdelemiter(ISNULL(@ChannelCodes,''),',') where number <> ''

		UPDATE TC SET  TC.Channel_Name = C.Channel_Name, TC.Channel_Id = C.Channel_Id, TC.Order_For_schedule = C.Order_For_schedule 
		FROM #TempChannels TC
		INNER JOIN Channel C ON C.Channel_Code = TC.Channel_Code
	END
	ELSE 
	BEGIN
		INSERT INTO #TempChannels(Channel_Code, Channel_Name, Channel_Id, Order_For_schedule)
		SELECT Channel_Code, Channel_Name, Channel_Id, Order_For_schedule FROM Channel
	END

	SELECT DISTINCT TC.Title_Code, CCR.Channel_Code,
	AD.Agreement_No, TT.Title_Name, ISNULL(RR.Right_Rule_Name, '') AS Right_Rule_Name, CCR.Rights_Start_Date, CCR.Rights_End_Date, TTC.Channel_Name, 
	CCR.Defined_Runs, ISNULL(CCR.Schedule_Runs, 0) AS Schedule_Runs, ISNULL(CCR.Schedule_Utilized_Runs, 0) AS Consumed_Runs,
	CCR.Defined_Runs - (ISNULL(CCR.Schedule_Runs, 0)) AS Balance_Run,
	CCR.Prime_Runs, ISNULL(CCR.Prime_Schedule_Runs, 0) AS Prime_Schedule_Runs, CCR.Prime_Runs - (ISNULL(CCR.Prime_Schedule_Runs, 0)) AS Prime_Balance_Run,
	CCR.OffPrime_Runs, ISNULL(CCR.OffPrime_Schedule_Runs, 0) AS OffPrime_Schedule_Runs, 
	CCR.OffPrime_Runs - (ISNULL(CCR.OffPrime_Schedule_Runs, 0)) AS OffPrime_Balance_Run
	FROM Content_Channel_Run CCR
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
	INNER JOIN Title_Content TC ON TC.Title_Content_Code = CCR.Title_Content_Code
	INNER JOIN #TempTitles TT ON TT.Title_Code = TC.Title_Code
	INNER JOIN #TempChannels TTC ON TTC.Channel_Code = CCR.Channel_Code
	--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
	--INNER JOIN Acq_Deal_Run_Yearwise_Run ADRY ON ADRY.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
	LEFT JOIN Right_Rule RR ON RR.Right_Rule_Code = CCR.Right_Rule_Code
	WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND (@ExcludeExpiredDeal = 'Y' AND ISNULL(CCR.Rights_End_Date, GETDATE()) >= GETDATE()) OR (@ExcludeExpiredDeal = 'N')
	AND (@AllYears = 'Y' OR (GETDATE() BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date))
	AND ((ISNULL(CCR.Run_Type,'') <> '' AND CCR.Run_Type = UPPER(@Run_Type)) OR (ISNULL(@Run_Type,'') = ''))
	ORDER BY TT.Title_Name, TTC.Channel_Name     
END