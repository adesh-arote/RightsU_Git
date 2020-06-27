CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Reprocess_Runs]
(
--DECLARE
	@Channel_Code INT ,
	@TimeLine_ID_Revert VARCHAR(MAX)='',
	@Content_Channel_Run_Code VARCHAR(MAX)
)
AS
---- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:       <08 Nov 2016>
-- Description:    (1 )RU BV Schedule Integration Reprocess Runs (2) This Procedure Call from USP_BMS_Schedule_Process and USP_BMS_Schedule_Revert

-- =============================================
BEGIN  
	SET NOCOUNT ON;
	BEGIN TRY
	--BEGIN TRAN
    PRINT '----------------------------Start Logic of BMS_Schedule_Reprocess_Runs ------------------------------------------------'           
    /************************DELETE TEMP TABLES *************************/   
    BEGIN

		PRINT '@Channel_Code = '+CAST(@Channel_Code AS VARCHAR)+', @TimeLine_ID_Revert = ' +@TimeLine_ID_Revert +', @Content_Channel_Run_Code = '+@Content_Channel_Run_Code

		IF OBJECT_ID('tempdb..#Acq_Deal_Run_Codes') IS NOT NULL
		BEGIN
			DROP TABLE #Acq_Deal_Run_Codes
		END

		IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Run') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_BMS_Schedule_Run
		END

		IF OBJECT_ID('tempdb..#TimeLine_ID') IS NOT NULL
		BEGIN
			DROP TABLE #TimeLine_ID
		END

		IF OBJECT_ID('tempdb..#Acq_Deal_Content_Schedule_Run') IS NOT NULL
		BEGIN
			DROP TABLE #Acq_Deal_Content_Schedule_Run
		END

		IF OBJECT_ID('tempdb..#Content_Channel_Run_Codes') IS NOT NULL
		BEGIN
			DROP TABLE #Content_Channel_Run_Codes
		END
       
	END
	
	/************************CREATE TEMP TABLES *********************/
	BEGIN

		CREATE TABLE #TimeLine_ID
		(
			TimeLine_ID INT
		)

		CREATE TABLE #Temp_BMS_Schedule_Run
		(
			Content_Channel_Run_Code INT,
			Channel_Code INT,
			Is_Prime CHAR(1),
			Schedule_Log_date DATE,
			BMS_Asset_Ref_Key INT,
			TimeLine_ID INT,
			Is_Ignore CHAR(1),
			Schedule_Item_Log_Time DateTime2,
			Is_Delete CHAR(1),
			Run_Def_Type CHAR(1),
			Title_Content_Code INT,
			Acq_Deal_Run_Code INT,
			Right_Start_Date Date,
			Right_End_Date Date
		)
		CREATE TABLE #Acq_Deal_Content_Schedule_Run
		(
			Content_Channel_Run_Code INT,
			Scheduled_Run INT,
			Scheduled_Utilized_Run INT,
			Is_Define_Off_Prime_Time CHAR(1),
			Is_Define_Prime_Time CHAR(1),    
			Off_Prime_Schedule_Run INT,
			Off_Prime_Schedule_Utilized_Run INT,
			Prime_Schedule_Utilized_Run INT,
			Prime_Schedule_Run INT,
			BMS_Asset_Ref_Key INT,
			D_Scheduled_Run INT,
			D_Scheduled_Utilized_Run INT,
			D_Off_Prime_Schedule_Run INT,
			D_Off_Prime_Schedule_Utilized_Run INT,
			D_Prime_Schedule_Utilized_Run INT,
			D_Prime_Schedule_Run INT,
			Run_Def_Type CHAR(1),
			Title_Content_Code INT,
			Acq_Deal_Run_Code INT,
			Right_Start_Date Date,
			Right_End_Date Date,
			TimeLine_ID INT
		)   
		CREATE TABLE #Content_Channel_Run_Codes
		(
			Content_Channel_Run_Code INT
		)
	END       

	PRINT ' Content_Channel_Run_Code : '+ISNULL(@Content_Channel_Run_Code,'0')+   ' TimeLine_ID_Revert : '+ISNULL(@TimeLine_ID_Revert,'0')
	/*********************************Declare global variables ******************/       

	DECLARE @Is_Revert CHAR(1) = 'N', @Is_Shared CHAR(1) = 'N'

	/*************************Insert TimeLine Id In #TimeLine_ID and Acq Deal Run Code in  #Acq_Deal_Run_Codes*********************************************/   
	INSERT INTO #TimeLine_ID(TimeLine_ID)
	SELECT number FROM fn_Split_withdelemiter(ISNULL(@TimeLine_ID_Revert,'0'),',')
	WHERE number !='' AND @TimeLine_ID_Revert != ''

	INSERT INTO #Content_Channel_Run_Codes(Content_Channel_Run_Code)
	SELECT number
	FROM fn_Split_withdelemiter(ISNULL(@Content_Channel_Run_Code,'0'),',') AS N where N.number != ''
	--select @Content_Channel_Run_Code AS '@Content_Channel_Run_Code'

	IF EXISTS(SELECT TOP 1 * FROM #TimeLine_ID TL WHERE ISNULL(TL.TimeLine_ID,0) > 0)
		SET @Is_Revert = 'Y'

	IF EXISTS (select * from Content_Channel_Run where Run_Def_Type = 'S' AND 
	Content_Channel_Run_Code IN(select Content_Channel_Run_Code from #Content_Channel_Run_Codes))
	BEGIN
		DECLARE @Ref_BMS_Content_Code INT, @Acq_Deal_Run_Code INT, @Right_Start_Date Date, @Right_End_Date Date
		select TOP 1 @Ref_BMS_Content_Code = TC.Ref_BMS_Content_Code,	@Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code, @Right_Start_Date = CCR.Rights_Start_Date,
		@Right_End_Date = CCR.Rights_End_Date
		from Content_Channel_Run CCR
		INNER JOIN Title_Content TC ON TC.Title_Content_Code =CCR.Title_Content_Code
		where Run_Def_Type = 'S' AND Content_Channel_Run_Code IN(select Content_Channel_Run_Code from #Content_Channel_Run_Codes)

		INSERT INTO  #Temp_BMS_Schedule_Run(Content_Channel_Run_Code, Channel_Code, Is_Prime, Schedule_Log_date, TimeLine_ID, BMS_Asset_Ref_Key,
					Schedule_Item_Log_Time, Is_Ignore, Run_Def_Type, Title_Content_Code, Acq_Deal_Run_Code, Right_Start_Date,	Right_End_Date)
		SELECT DISTINCT BST.Content_Channel_Run_Code, BST.Channel_Code, BST.IsPrime, BST.Schedule_Item_Log_Date, BST.Timeline_ID, BST.Program_Episode_ID,
						BST.Schedule_Item_Log_Time, BST.IsIgnore, t.Run_Def_Type, t.Title_Content_Code, t.Acq_Deal_Run_Code, t.Rights_Start_Date, t.Rights_End_Date
		FROM BV_Schedule_Transaction BST
		LEFT Join Content_Channel_Run t On BST.Content_Channel_Run_Code = t.Content_Channel_Run_Code AND ISNULL(t.Is_Archive, 'N') = 'N'
		WHERE BST.Program_Episode_ID = @Ref_BMS_Content_Code AND CAST(BST.Schedule_Item_Log_Time AS DATETIME) BETWEEN @Right_Start_Date AND @Right_End_Date

		INSERT INTO #Acq_Deal_Content_Schedule_Run(Content_Channel_Run_Code, Scheduled_Run, Scheduled_Utilized_Run, Prime_Schedule_Run, Prime_Schedule_Utilized_Run, 
		Off_Prime_Schedule_Run, Off_Prime_Schedule_Utilized_Run, Run_Def_Type, Title_Content_Code, Acq_Deal_Run_Code, Right_Start_Date,	Right_End_Date,TimeLine_ID)
		Select Distinct Content_Channel_Run_Code,0,0,0,0,0,0, Run_Def_Type, Title_Content_Code, Acq_Deal_Run_Code, Right_Start_Date, Right_End_Date,TimeLine_ID 
		From #Temp_BMS_Schedule_Run

		select '#Temp_BMS_Schedule_Run',* from #Temp_BMS_Schedule_Run
		select '#Acq_Deal_Content_Schedule_Run',* from #Acq_Deal_Content_Schedule_Run

		UPDATE ADCR SET ADCR.Is_Define_Prime_Time = CASE WHEN (ISNULL(CCR.Prime_Start_Time,'') <> '' OR ISNULL(CCR.Prime_End_Time,'') <> '') THEN 'Y' ELSE 'N' END,
		ADCR.Is_Define_Off_Prime_Time = CASE WHEN (ISNULL(CCR.OffPrime_Start_Time,'') <> '' OR ISNULL(CCR.OffPrime_End_Time,'') <> '') THEN 'Y' ELSE 'N' END
		FROM Content_Channel_Run CCR
		INNER JOIN 
		#Acq_Deal_Content_Schedule_Run ADCR ON 
		CCR.Content_Channel_Run_Code = ADCR.Content_Channel_Run_Code AND ISNULL(CCR.Is_Archive, 'N') = 'N'
	
		Update a
		Set a.Scheduled_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) FROM #Temp_BMS_Schedule_Run BSR WHERE ISNULL(BSR.Is_Ignore ,'N') = 'N' 
			AND BSR.Acq_Deal_Run_Code = a.Acq_Deal_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Scheduled_Utilized_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) FROM #Temp_BMS_Schedule_Run BSR WHERE BSR.Acq_Deal_Run_Code = a.Acq_Deal_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Prime_Schedule_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Acq_Deal_Run_Code = BSR.Acq_Deal_Run_Code
			WHERE ((ISNULL(BSR.Is_Prime,'N') = 'Y' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y')
			OR (ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'N')) AND BSR.Is_Ignore = 'N' 
			AND BSR.Acq_Deal_Run_Code = a.Acq_Deal_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Prime_Schedule_Utilized_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Acq_Deal_Run_Code = BSR.Acq_Deal_Run_Code
			WHERE ((ISNULL(BSR.Is_Prime,'N') = 'Y' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y')
			OR (ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'N')) AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Off_Prime_Schedule_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Acq_Deal_Run_Code = BSR.Acq_Deal_Run_Code           
			WHERE
			((ISNULL(BSR.Is_Prime,'N') = 'N' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y') 
			OR (ADSRI.Is_Define_Off_Prime_Time = 'Y' AND ADSRI.Is_Define_Prime_Time = 'N' )) 
			AND ISNULL(BSR.Is_Ignore ,'N') = 'N' AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Off_Prime_Schedule_Utilized_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Acq_Deal_Run_Code = BSR.Acq_Deal_Run_Code           
			WHERE
			((ISNULL(BSR.Is_Prime,'N') = 'N' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y') 
			OR (ADSRI.Is_Define_Off_Prime_Time = 'Y' AND ADSRI.Is_Define_Prime_Time = 'N' )) 
			AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		)
		From #Acq_Deal_Content_Schedule_Run a

		UPDATE CCR SET CCR.Schedule_Runs = ISNULL(ADSR.Scheduled_Run,0),
		CCR.Schedule_Utilized_Runs = ISNULL(ADSR.Scheduled_Utilized_Run,0),
		CCR.Prime_Schedule_Runs = ISNULL(ADSR.Prime_Schedule_Run,0),
		CCR.Prime_Schedule_Utilized_Runs = ISNULL(ADSR.Prime_Schedule_Utilized_Run,0),
		CCR.OffPrime_Schedule_Runs = ISNULL(ADSR.Off_Prime_Schedule_Run,0),
		CCR.OffPrime_Schedule_Utilized_Runs = ISNULL(ADSR.Off_Prime_Schedule_Utilized_Run,0)
		FROM Content_Channel_Run CCR
		INNER JOIN #Acq_Deal_Content_Schedule_Run ADSR ON --ADSR.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND 
		ISNULL(CCR.Is_Archive, 'N') = 'N' AND ADSR.Title_Content_Code = CCR.Title_Content_Code AND ADSR.Right_Start_Date = CCR.Rights_Start_Date
		AND ADSR.Right_End_Date = CCR.Rights_End_Date AND ADSR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
		AND ADSR.Run_Def_Type = 'S'
		--select * from #Acq_Deal_Content_Schedule_Run
		--select * from Content_Channel_Run where Acq_Deal_Code=3173
	END
	ELSE
	BEGIN
		INSERT INTO  #Temp_BMS_Schedule_Run(Content_Channel_Run_Code, Channel_Code, Is_Prime, Schedule_Log_date, TimeLine_ID, BMS_Asset_Ref_Key,
						Schedule_Item_Log_Time, Is_Ignore, Run_Def_Type, Title_Content_Code, Acq_Deal_Run_Code, Right_Start_Date,	Right_End_Date)
		SELECT DISTINCT BST.Content_Channel_Run_Code, BST.Channel_Code, BST.IsPrime, BST.Schedule_Item_Log_Date, BST.Timeline_ID, BST.Program_Episode_ID,
						BST.Schedule_Item_Log_Time, BST.IsIgnore, t.Run_Def_Type, t.Title_Content_Code, t.Acq_Deal_Run_Code, t.Rights_Start_Date, t.Rights_End_Date
		FROM BV_Schedule_Transaction BST
		Inner Join Content_Channel_Run t On BST.Content_Channel_Run_Code = t.Content_Channel_Run_Code AND ISNULL(t.Is_Archive, 'N') = 'N'
		WHERE BST.Channel_Code = @Channel_Code 
		AND t.Content_Channel_Run_Code IN( select Content_Channel_Run_Code from #Content_Channel_Run_Codes)
	
		

		INSERT INTO #Acq_Deal_Content_Schedule_Run(Content_Channel_Run_Code, Scheduled_Run, Scheduled_Utilized_Run, Prime_Schedule_Run, Prime_Schedule_Utilized_Run, 
		Off_Prime_Schedule_Run, Off_Prime_Schedule_Utilized_Run, Run_Def_Type, Title_Content_Code, Acq_Deal_Run_Code, Right_Start_Date,	Right_End_Date,TimeLine_ID)
		Select Distinct Content_Channel_Run_Code,0,0,0,0,0,0, Run_Def_Type, Title_Content_Code, Acq_Deal_Run_Code, Right_Start_Date, Right_End_Date,TimeLine_ID 
		From #Temp_BMS_Schedule_Run
		

		UPDATE ADCR SET ADCR.Is_Define_Prime_Time = CASE WHEN (ISNULL(CCR.Prime_Start_Time,'') <> '' OR ISNULL(CCR.Prime_End_Time,'') <> '') THEN 'Y' ELSE 'N' END,
			ADCR.Is_Define_Off_Prime_Time = CASE WHEN (ISNULL(CCR.OffPrime_Start_Time,'') <> '' OR ISNULL(CCR.OffPrime_End_Time,'') <> '') THEN 'Y' ELSE 'N' END
			FROM Content_Channel_Run CCR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADCR ON 
			CCR.Content_Channel_Run_Code = ADCR.Content_Channel_Run_Code AND ISNULL(CCR.Is_Archive, 'N') = 'N'
	
		Update a
		Set a.Scheduled_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) FROM #Temp_BMS_Schedule_Run BSR WHERE ISNULL(BSR.Is_Ignore ,'N') = 'N' AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Scheduled_Utilized_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) FROM #Temp_BMS_Schedule_Run BSR WHERE BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Prime_Schedule_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Content_Channel_Run_Code = BSR.Content_Channel_Run_Code
			WHERE ((ISNULL(BSR.Is_Prime,'N') = 'Y' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y')
			OR (ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'N')) AND BSR.Is_Ignore = 'N' AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Prime_Schedule_Utilized_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Content_Channel_Run_Code = BSR.Content_Channel_Run_Code
			WHERE ((ISNULL(BSR.Is_Prime,'N') = 'Y' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y')
			OR (ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'N')) AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Off_Prime_Schedule_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Content_Channel_Run_Code = BSR.Content_Channel_Run_Code           
			WHERE
			((ISNULL(BSR.Is_Prime,'N') = 'N' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y') OR (ADSRI.Is_Define_Off_Prime_Time = 'Y' AND ADSRI.Is_Define_Prime_Time = 'N' )) 
			AND ISNULL(BSR.Is_Ignore ,'N') = 'N' AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code
			AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		),
		a.Off_Prime_Schedule_Utilized_Run = (
			SELECT COUNT(DISTINCT BSR.TimeLine_ID) AS Prime_Run_Schedule_Count FROM #Temp_BMS_Schedule_Run BSR
			INNER JOIN #Acq_Deal_Content_Schedule_Run ADSRI ON ADSRI.Content_Channel_Run_Code = BSR.Content_Channel_Run_Code           
			WHERE
			((ISNULL(BSR.Is_Prime,'N') = 'N' AND ADSRI.Is_Define_Prime_Time = 'Y' AND ADSRI.Is_Define_Off_Prime_Time = 'Y') OR (ADSRI.Is_Define_Off_Prime_Time = 'Y' AND ADSRI.Is_Define_Prime_Time = 'N' )) 
			AND BSR.Content_Channel_Run_Code = a.Content_Channel_Run_Code AND BSR.TimeLine_ID NOT IN(select TimeLine_ID from #TimeLine_ID)
		)
		From #Acq_Deal_Content_Schedule_Run a

		UPDATE CCR SET CCR.Schedule_Runs = ISNULL(ADSR.Scheduled_Run,0),
		CCR.Schedule_Utilized_Runs = ISNULL(ADSR.Scheduled_Utilized_Run,0),
		CCR.Prime_Schedule_Runs = ISNULL(ADSR.Prime_Schedule_Run,0),
		CCR.Prime_Schedule_Utilized_Runs = ISNULL(ADSR.Prime_Schedule_Utilized_Run,0),
		CCR.OffPrime_Schedule_Runs = ISNULL(ADSR.Off_Prime_Schedule_Run,0),
		CCR.OffPrime_Schedule_Utilized_Runs = ISNULL(ADSR.Off_Prime_Schedule_Utilized_Run,0)
		FROM Content_Channel_Run CCR
		INNER JOIN #Acq_Deal_Content_Schedule_Run ADSR ON ADSR.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND 
		ISNULL(CCR.Is_Archive, 'N') = 'N' AND ADSR.Title_Content_Code = CCR.Title_Content_Code AND ADSR.Right_Start_Date = CCR.Rights_Start_Date
		AND ADSR.Right_End_Date = CCR.Rights_End_Date AND ADSR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
	END
	PRINT '----------------------------End Logic of BMS_Schedule_Reprocess_Runs ------------------------------------------------'           
	/*******************************/
	END TRY           
	BEGIN CATCH
		PRINT 'Catch Block in USP_BMS_Schedule_Reprocess_Runs'
		DECLARE @ErMessage NVARCHAR(MAX),@ErSeverity INT,@ErState INT
		SELECT @ErMessage = 'Error in USP_BMS_Schedule_Reprocess_Runs : - ' +  ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()
		RAISERROR (@ErMessage,@ErSeverity,@ErState) 
	END CATCH 
END
