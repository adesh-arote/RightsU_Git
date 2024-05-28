CREATE Procedure [dbo].[USP_Validate_Run_Udt]	
	@Deal_Run_Title [Deal_Run_Title] READONLY,
	@Deal_Run_Yearwise_Run [Deal_Run_Yearwise_Run] READONLY,
	@Deal_Run_Channel [Deal_Run_Channel] READONLY	,
	@Acq_Deal_Code INT
AS
-- =============================================
-- Author:		Rajesh
-- Create DATE: 18-August-2015
-- Description:	Validating Acq run with schedule run
-- =============================================
BEGIN
	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
	IF OBJECT_ID('tempdb..#tempDCR') IS NOT NULL DROP TABLE #tempDCR

	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Validate_Run_Udt]', 'Step 1', 0, 'Started Procedure', 0, ''	

	--INSERT INTO @Deal_Run_Title (Deal_Run_Code, Title_Code, Episode_From, Episode_To) VALUES (6411, 64865, 1, 10)
	--INSERT INTO @Deal_Run_Channel (Deal_Run_Code, Channel_Code, Min_Runs) VALUES (6411, 1012, 1)

	--INSERT INTO @Deal_Run_Title (Deal_Run_Code, Title_Code, Episode_From, Episode_To) VALUES (7411, 65869, 1, 1)
	--INSERT INTO @Deal_Run_Channel (Deal_Run_Code, Channel_Code, Min_Runs) VALUES (7411, 1012, 1)
	--INSERT INTO @Deal_Run_Channel (Deal_Run_Code, Channel_Code, Min_Runs) VALUES (7411, 1013, 1)

	--select * from @Deal_Run_Title
	--select * from @Deal_Run_Channel

	CREATE TABLE #TEMP(	
		Title_Name NVARCHAR(MAX),
		Episode_No INT,
		StartDate VARCHAR(12),
		EndDate VARCHAR(12),
		Channel_Name NVARCHAR(100),
		No_Of_Runs INT,
		No_Of_Schd_Run INT
	)

	DECLARE @AL_DealType_Show VARCHAR(100) = '', @AL_DealType_Movies VARCHAR(100) = '', @DealType VARCHAR(100),  @Title_Code INT = 0, @Ref_BMS_Content_Code VARCHAR(50), @Episode_No INT, @Episode_From INT, @Episode_To INT

	SELECT @AL_DealType_Movies = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_DealType_Movies'
	SELECT @AL_DealType_Show = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_DealType_Show'

	IF EXISTS(SELECT number FROM [dbo].[fn_Split_withdelemiter](@AL_DealType_Show,',') WHERE number IN (select Deal_Type_Code from Acq_Deal where Acq_Deal_Code = @Acq_Deal_Code))
	BEGIN 
		SET @DealType =  'SHOW'
	END
	ELSE IF EXISTS(SELECT number FROM [dbo].[fn_Split_withdelemiter](@AL_DealType_Movies,',') WHERE number IN (select Deal_Type_Code from Acq_Deal where Acq_Deal_Code = @Acq_Deal_Code))
	BEGIN
		SET @DealType =  'MOVIE'
	END

	SELECT DCR.*, DRT.Title_Code, BMA.Episode_Number, DRC.Channel_Code INTO #tempDCR
		FROM BMS_Deal_Content_Rights DCR (NOLOCK)
		INNER JOIN BMS_Asset BMA (NOLOCK) ON BMA.BMS_Asset_Code = DCR.BMS_Asset_Code
		INNER JOIN @Deal_Run_Title DRT ON DRT.Deal_Run_Code = DCR.Acq_Deal_Run_Code AND BMA.RU_Title_Code = DRT.Title_Code AND ((CAST(BMA.Episode_Number AS INT) BETWEEN DRT.Episode_From AND DRT.Episode_To) OR @DealType =  'MOVIE')
		INNER JOIN @Deal_Run_Channel DRC ON DCR.RU_Channel_Code = DRC.Channel_Code

		INSERT INTO #TEMP(Title_Name, Episode_No, StartDate, EndDate, Channel_Name, No_Of_Runs, No_Of_Schd_Run)
		SELECT tl.Title_Name, DCR.Episode_Number, CONVERT(VARCHAR(12),DYR.Start_Date,106) AS StartDate, CONVERT(VARCHAR(12),DYR.End_Date,106) AS EndDate, 'NA' AS Channel_Name, 
		DYR.No_Of_Runs, SUM(ISNULL(DCR.Utilised_Run, 0)) AS No_Of_Schd_Run
		FROM #tempDCR DCR
		INNER JOIN @Deal_Run_Yearwise_Run DYR ON DCR.Start_Date = DYR.Start_Date AND DCR.End_Date = DYR.End_Date
		INNER JOIN Title tl (NOLOCK) ON tl.Title_Code = DCR.Title_Code
		GROUP BY DCR.Episode_Number, DYR.Start_Date, DYR.End_Date, DYR.No_Of_Runs, tl.Title_Name
		HAVING SUM(ISNULL(DCR.Utilised_Run, 0)) > DYR.No_Of_Runs

		--IF((SELECT TOP 1 Run_Definition_Type FROM Acq_Deal_Run (NOLOCK)	WHERE Acq_Deal_Run_Code in (SELECT Deal_Run_Code FROM @Deal_Run_Channel )) = 'C')
		--BEGIN
		INSERT INTO #TEMP(Title_Name, Episode_No, StartDate, EndDate, Channel_Name, No_Of_Runs, No_Of_Schd_Run)
		SELECT tl.Title_Name, DCR.Episode_Number, 'NA' AS StartDate ,'NA' AS EndDate, Chnl.Channel_Name, DRC.Min_Runs AS No_Of_Runs, SUM(ISNULL(DCR.Utilised_Run, 0)) AS No_Of_Schd_Run 
		FROM #tempDCR DCR
		INNER JOIN @Deal_Run_Channel DRC ON DRC.Channel_Code = DCR.RU_Channel_Code
		INNER JOIN Title tl (NOLOCK) ON tl.Title_Code = DCR.Title_Code
		INNER JOIN Channel Chnl (NOLOCK) ON Chnl.Channel_Code = DCR.Channel_Code
		GROUP BY DCR.Episode_Number, DRC.Channel_Code, DRC.Min_Runs, tl.Title_Name, Chnl.Channel_Name
		HAVING  SUM(ISNULL(DCR.Utilised_Run, 0)) > DRC.Min_Runs
		--END


	SELECT Title_Name, Episode_No, StartDate, EndDate, Channel_Name, No_Of_Runs, No_Of_Schd_Run FROM #TEMP

	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
	IF OBJECT_ID('tempdb..#tempDCR') IS NOT NULL DROP TABLE #tempDCR

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Run_Udt]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END