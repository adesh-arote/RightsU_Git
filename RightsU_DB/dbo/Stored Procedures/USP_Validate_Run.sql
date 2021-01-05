CREATE PROCEDURE [dbo].[USP_Validate_Run]
	@TITLE_CODE VARCHAR(MAX),
	@RUN_TYPE VARCHAR(2),
	@ISYEARWISE VARCHAR(2),
	@ISRULERIGHT VARCHAR(2),
	@ISCHANNELWISE VARCHAR(2),
	@CHANNEL_CODES VARCHAR(MAX),
	@ACQ_DEAL_RUN_CODE int,
	@ACQ_DEAL_CODE int
AS
-- =============================================
-- Author:		Bhavesh Desai
-- Create DATE: 28-October-2014
-- Description:	Validating duplicate run definition
-- =============================================
BEGIN			
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	IF(OBJECT_ID('TEMPDB..#TempData') IS NOT NULL)
		DROP TABLE #TempData

	CREATE TABLE #TempData
	(
		Title_Code INT,
		Episode_From INT,
		Episode_To INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Channel_Name NVARCHAR(1000)
	)
	
	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal WHERE Acq_Deal_Code = @ACQ_DEAL_CODE
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	IF(@ISCHANNELWISE = 'Y')
	BEGIN
		PRINT 'Channalwise'
		INSERT INTO #TempData(Title_Code, Episode_From, Episode_To, Rights_Start_Date, Rights_End_Date, Channel_Name)
		SELECT ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To,
		CONVERT(VARCHAR(10), ADR.Actual_Right_Start_Date, 101) AS Rights_Start_Date,
		CONVERT(VARCHAR(10), ADR.Actual_Right_End_Date, 101) AS Rights_End_Date,
		C.Channel_Name
		FROM Acq_Deal_Movie ADM
		INNER JOIN Acq_Deal_Run ADRun ON ADM.Acq_Deal_Code = ADRun.Acq_Deal_Code AND 
			ADRun.Acq_Deal_Run_Code NOT IN (@ACQ_DEAL_RUN_CODE) AND ADM.Acq_Deal_Code IN (@ACQ_DEAL_CODE)
		INNER JOIN Acq_Deal_Run_Title ADRunT ON ADRunT.Acq_Deal_Run_Code = ADRun.Acq_Deal_Run_Code AND
			ADRunT.Episode_From = ADM.Episode_Starts_From AND ADRunT.Episode_To = ADM.Episode_End_To AND ADRunT.Title_Code = ADM.Title_Code
			AND (
					(
						ADRunT.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@TITLE_CODE,',')) 
						AND @Deal_Type_Condition != 'DEAL_PROGRAM' AND @Deal_Type_Condition != 'DEAL_MUSIC'
					) OR 
					(
						ADM.Acq_Deal_Movie_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@TITLE_CODE,',')) 
						AND (@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC') 
					)
				)
		INNER JOIN Acq_Deal_Run_Channel ADRunC ON ADRunC.Acq_Deal_Run_Code = ADRun.Acq_Deal_Run_Code AND
			ADRunC.Channel_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@CHANNEL_CODES, ','))
		INNER JOIN Channel C ON C.Channel_Code = ADRunC.Channel_Code
		INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = ADM.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
			AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To AND ADRT.Title_Code = ADM.Title_Code
	END
	ELSE
	BEGIN
		PRINT 'NO CHANNEL DEFINITION'
		INSERT INTO #TempData(Title_Code, Episode_From, Episode_To, Rights_Start_Date, Rights_End_Date, Channel_Name)
		SELECT ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To,
		CONVERT(VARCHAR(10), ADR.Actual_Right_Start_Date, 101) AS Rights_Start_Date,
		CONVERT(VARCHAR(10), ADR.Actual_Right_End_Date, 101) AS Rights_End_Date,
		CASE WHEN  ISNULL(C.Channel_Name,'') = '' THEN 'NO CHANNEL DEFINITION' END AS Channel_Name
		FROM Acq_Deal_Movie ADM
		INNER JOIN Acq_Deal_Run ADRun ON ADM.Acq_Deal_Code = ADRun.Acq_Deal_Code AND 
			ADRun.Acq_Deal_Run_Code NOT IN (@ACQ_DEAL_RUN_CODE) AND ADM.Acq_Deal_Code IN (@ACQ_DEAL_CODE)
			AND ISNULL(ADRun.Is_Channel_Definition_Rights, 'N') = 'N'
		INNER JOIN Acq_Deal_Run_Title ADRunT ON ADRunT.Acq_Deal_Run_Code = ADRun.Acq_Deal_Run_Code AND
			ADRunT.Episode_From = ADM.Episode_Starts_From AND ADRunT.Episode_To = ADM.Episode_End_To AND ADRunT.Title_Code = ADM.Title_Code
			AND (
					(
						ADRunT.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@TITLE_CODE,',')) 
						AND @Deal_Type_Condition != 'DEAL_PROGRAM' AND @Deal_Type_Condition != 'DEAL_MUSIC'
					) OR 
					(
						ADM.Acq_Deal_Movie_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@TITLE_CODE,',')) 
						AND (@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC') 
					)
				)
		INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = ADM.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
			AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To AND ADRT.Title_Code = ADM.Title_Code
		LEFT JOIN Acq_Deal_Run_Channel ADRunC ON ADRunC.Acq_Deal_Run_Code = ADRun.Acq_Deal_Run_Code
		LEFT JOIN Channel C ON C.Channel_Code = ADRunC.Channel_Code
	END

	SELECT 
	dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, TD.Episode_From, TD.Episode_To) AS Title_Name, '' as Platform_Name,
	TD.Rights_Start_Date, TD.Rights_End_Date, TD.Channel_Name
	FROM #TempData TD
	INNER JOIN Title T ON T.Title_Code = TD.Title_Code

	--DROP TABLE #TempData

	IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
END