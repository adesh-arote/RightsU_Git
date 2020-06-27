alter PROCEDURE [dbo].[USP_Schedule_Revert_Count]      
(
	 @File_Code BIGINT = 0,      
	 @Channel_Code VARCHAR(10) = 0,      
	 @Deal_Code INT = null,      
	 @CallFromDealApprove VARCHAR(10) = null,      
	 @Deal_Type CHAR(1) = 'A'      
)       
AS      
BEGIN      
-- =============================================
/*       
Steps:- Revert the Schedule Count if same DATE file is reloaded.      
1.0 Define global variables AND create temp tables.      
2.0 Get schedule data which need to be process into #BVScheduleTransaction table.      
3.0 Looping through schedule data fot UPDATE_SCHEDULE_COUNT.      
4.0 Insert Deal Data into #AcqRightsData FROM View with first filter.      
5.0 ----------------------------------------------------------------      
6.0 Keep only those channel records which will be process now.      
7.0 Insert Deal Data into #AcqRightsData_Final FROM View with second filter (CREATE_FINAL_DEAL_RIGHTS_DATA).      
 7.1 Get Deal data if schedule within the rights period.      
 7.2 Get Deal data if schedule out side the rights period.      
 7.3 ----------------------------------------------------------------      
8.0 Looping through Deal Data (i.e #AcqRightsData_Final) for UPDATE schedule count. (INNER_CURSOR_FOR_UPDATE_SCHEDULE_RUN_IN_FIFO_ORDER).      
 8.1 UPDATE schedule runs to Deal_Movie_Rights_Run AND Deal_Movie_Rights_Run_Channel.      
 8.2 UPDATE schedule runs to Yearwise Run Definition.      
 8.3 ----------------------------------------------------------------      
 8.4 ----------------------------------------------------------------      
 8.5 ----------------------------------------------------------------      
9.0 Delete Temp tables.      
10.0 ----------------------------------------------------------------      
 10.1 ----------------------------------------------------------------      
       
 Note:- Run_Definition_Type Flags      
  1. C: Channel Wise     (Channel_Wise)      
  2. CS: Channel Wise (Min / Max)  (CHANNEL_WISE_SHARED)      
  3. A: All Channel - 1 Run / Channel (CHANNEL_WISE_ALL)      
  4. S: Shared      (CHANNEL_SHARED)      
  5. N: NOT Applicable    (CHANNEL_NA)      
 This SP consider all above run definition type.      
*/      
-- =============================================      
	SET NOCOUNT ON;
	-----1.0-----      
	IF(@CallFromDealApprove IS NULL)
		SET @CallFromDealApprove = 'N'  
		    
	BEGIN ------------------------------------------- GLOBAL VARIBALES -------------------------------------------
		DECLARE @IsInRightPeriod_Cnt INT; SET @IsInRightPeriod_Cnt = 0
		DECLARE @title_code_HouseID INT; SET @title_code_HouseID = 0  --USE FAST FOR OPTIMIZATION	
		DECLARE @DMR_RunYearwiseRun_Code INT; SET @DMR_RunYearwiseRun_Code = 0  --USE FAST FOR OPTIMIZATION      
		DECLARE @ScheStartDate DATETIME; SET @ScheStartDate = ''
		DECLARE @ScheEndDate DATETIME; SET @ScheEndDate = ''
		SELECT @ScheStartDate = StartDate, @ScheEndDate = EndDate FROM Upload_Files WHERE File_code =  @File_Code

		DECLARE @TempMaxDealCode Numeric(18, 0)
		DECLARE @TempMinDealCode Numeric(18, 0)
		DECLARE @TempMaxDealSignedDate Datetime
		DECLARE @TempMinDealSignedDate Datetime
	END 
	------------------------------------------- END GLOBAL VARIBALES -------------------------------------------
	       
	BEGIN ------------------------------------------- DELETE TEMP TABLES -------------------------------------------
		IF OBJECT_ID('tempdb..#AcqRightsData_Revert') IS NOT NULL
		BEGIN
			DROP TABLE #AcqRightsData_Revert
		END      
		IF OBJECT_ID('tempdb..#AcqRightsData_Final_Revert') IS NOT NULL
		BEGIN
			DROP TABLE #AcqRightsData_Final_Revert
		END       
		IF OBJECT_ID('tempdb..#BVScheduleTransaction_Revert') IS NOT NULL
		BEGIN
			DROP TABLE #BVScheduleTransaction_Revert
		END
		IF OBJECT_ID('tempdb..#DealRightsData') IS NOT NULL
		BEGIN
			DROP TABLE #DealRightsData
		END
	END
	------------------------------------------- END DELETE TEMP TABLES -------------------------------------------       
       
	BEGIN ------------------------------------------- CREATE TEMP TABLES -------------------------------------------
		CREATE TABLE #DealRightsData
		(
			deal_right_end_date DATETIME, deal_right_start_date DATETIME, Right_Type CHAR(1), deal_right_blackout_start_date DATETIME,
			deal_right_blackout_end_date DATETIME, Deal_Rights_Code INT, Deal_Code INT, Agreement_Date DATETIME, Title_Code INT,
			Deal_Type VARCHAR(1)
		)
       
		CREATE TABLE #AcqRightsData_Revert
		(      
			ACQ_DEAL_Code INT, ACQ_Deal_Movie_code INT, ACQ_Deal_Rights_Code INT, ACQ_Deal_Run_Code INT, Channel_Code INT, run_type VARCHAR(3),
			run_definition_type VARCHAR(10), DoNotConsume VARCHAR(10), is_yearwise_definition VARCHAR(10), no_of_runs INT, no_of_runs_sched INT,
			no_of_AsRuns INT, ChannelWise_NoOfRuns INT, ChannelWise_NoOfRuns_Schedule INT, ChannelWise_no_of_AsRuns INT, title_code INT,
			Agreement_Date DATETIME, RightEndDate DATETIME, MaxRightEndDate DATETIME, MaxDealCode INT, MinDealCode INT, IsInRightPerod VARCHAR(3),
			RightPeriodFor VARCHAR(3), RightStartDate DATETIME, Deal_Type CHAR(1), Content_Channel_Run_Code INT 
		)
       
		CREATE TABLE #AcqRightsData_Final_Revert
		(      
			ACQ_deal_code INT, ACQ_deal_movie_code INT, ACQ_deal_movie_rights_code INT, ACQ_deal_run_code INT, ChannelCode INT, 
			Run_Type CHAR(1), Run_Definition_Type VARCHAR(10), is_yearwise_definition CHAR(1), no_of_runs INT, no_of_runs_sched INT, 
			title_code INT,
			DoNotConsume VARCHAR(10),  ------------------ DO NOT CONSUME RIGHTS
			RightPeriodFor VARCHAR(10),  ------------------ RUN BASED
			no_of_AsRuns INT, ------------------ ACTUAL RUN
			ChannelWise_NoOfRuns INT, ChannelWise_NoOfRuns_Schedule INT,Content_Channel_Run_Code INT,
			ChannelWise_no_of_AsRuns INT,  ------------------ CHANNEL WISE ACTUAL RUN
			Agreement_Date DATETIME, MinDealSignedDate DATETIME, MaxDealSignedDate DATETIME, MaxDealCode INT, MinDealCode INT,
			Deal_Type CHAR(1),
		)
      
		CREATE TABLE #BVScheduleTransaction_Revert  ----- BV_Schedule_Transaction Data
		(
			BV_Schedule_Transaction_Code NUMERIC(18, 0), Program_Episode_ID NVARCHAR(1000), Program_Version_ID NVARCHAR(1000),
			Program_Episode_Title NVARCHAR(250), Program_Episode_Number NVARCHAR(100), Program_Title NVARCHAR(250), 
			Program_Category NVARCHAR(250),	Schedule_Item_Log_Date VARCHAR(50), Schedule_Item_Log_Time VARCHAR(50), 
			Schedule_Item_Duration VARCHAR(100), Scheduled_Version_House_Number_List NVARCHAR(100), Found_Status CHAR(1), 
			File_Code bigint, Title_Code NUMERIC(18, 0), IsProcessed CHAR(1), ACQ_Deal_Movie_Code INT, Is_Ignore CHAR(1)
			--Program_Episode_ID NUMERIC(38, 0),   
		)
	END
	------------------------------------------- End CREATE TEMP TABLES -------------------------------------------
    PRINT 'RA'
	-----2.0-----      
	IF(@CallFromDealApprove = 'N')
	BEGIN
	PRINT 'RN'
		INSERT INTO #BVScheduleTransaction_Revert
		(      
			BV_Schedule_Transaction_Code, Program_Episode_ID, Program_Version_ID, Program_Episode_Title, 
			Program_Episode_Number, Program_Title, Program_Category, Schedule_Item_Log_Date, 
			Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List, Found_Status, 
			File_Code, Title_Code, IsProcessed, ACQ_Deal_Movie_Code, Is_Ignore
		)
		SELECT  bst.BV_Schedule_Transaction_Code, bst.Program_Episode_ID, bst.Program_Version_ID, bst.Program_Episode_Title, 
			bst.Program_Episode_Number, bst.Program_Title, bst.Program_Category, CONVERT(DATE, bst.Schedule_Item_Log_Date, 103), 
			bst.Schedule_Item_Log_Time, bst.Schedule_Item_Duration, ISNULL(bst.Scheduled_Version_House_Number_List, ''), bst.Found_Status, 
			bst.File_Code, bst.Title_Code, bst.IsProcessed, bst.Deal_Movie_Code, ISNULL(bst.IsIgnore, 'N')
		FROM BV_Schedule_Transaction bst WHERE 1=1
			AND ( CONVERT(DATETIME, CONVERT (VARCHAR, bst.Schedule_Item_Log_Date, 111), 111)+bst.Schedule_Item_Log_Time)
			--Convert(DATETIME, bst.Schedule_Item_Log_Date, 101)
			BETWEEN @ScheStartDate AND @ScheEndDate AND bst.Channel_Code = @Channel_Code 
			AND bst.File_Code < @File_Code
	END      
	ELSE IF(@CallFromDealApprove = 'Y')
	BEGIN
	PRINT 'RY'
		INSERT INTO #BVScheduleTransaction_Revert
		(      
			BV_Schedule_Transaction_Code, Program_Episode_ID, Program_Version_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, 
			Program_Category, Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,      
			Found_Status, File_Code, Title_Code, IsProcessed, ACQ_Deal_Movie_Code, Is_Ignore      
		)      
		SELECT  bst.BV_Schedule_Transaction_Code, Program_Episode_ID, Program_Version_ID, bst.Program_Episode_Title, bst.Program_Episode_Number, 
			bst.Program_Title, bst.Program_Category, CONVERT(DATE, bst.Schedule_Item_Log_Date, 103), bst.Schedule_Item_Log_Time, 
			bst.Schedule_Item_Duration, ISNULL(bst.Scheduled_Version_House_Number_List, ''), bst.Found_Status, bst.File_Code, bst.Title_Code, 
			bst.IsProcessed, bst.Deal_Movie_Code, ISNULL(bst.IsIgnore, 'N')      
		FROM BV_Schedule_Transaction bst WHERE 1=1 AND bst.Deal_Code = @Deal_Code AND Deal_Type = @Deal_Type      
			AND Channel_Code = @Channel_Code
	END  

	--IF OBJECT_ID('tempdb..TempBVScheduleTransaction_Revert') IS NULL
	--BEGIN
	--select * INTo TempBVScheduleTransaction_Revert FROM	#BVScheduleTransaction_Revert
	--END
	------------------------------------ 3.0 MAIN_CURSOR_FOR_UPDATE_SCHEDULE_COUNT ------------------------------------  
	PRINT 'RB'    
	DECLARE @RevertCnt INT = 1 --- variables need to increse counter---      
	DECLARE @BV_Schedule_Transaction_Code NUMERIC(18, 0), @Program_Episode_ID NVARCHAR(1000), @Program_Episode_Title_Cr NVARCHAR(500),
	@Program_Episode_Number_Cr NVARCHAR(500), @Program_Title_Cr NVARCHAR(500), @Program_Category_Cr NVARCHAR(500), 
	@Schedule_Item_Log_Date_Cr VARCHAR(500), @Schedule_Item_Log_TIME_Cr VARCHAR(500), @Schedule_Item_Duration_Cr VARCHAR(500), @FileCode_Cr INT, 
	@DMCode_Cr INT, @IsIgnore_Cr VARCHAR(1), @Title_Content_Code INT,	@Scheduled_Version_House_Number_List_Cr NVARCHAR(500), 
	@Found_Status_Cr VARCHAR(500) 
    

	DECLARE CR_BV_Schedule_Transaction CURSOR
	FOR

	SELECT DISTINCT BV_Schedule_Transaction_Code, Program_Episode_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, 
	Program_Category, Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,       
	Found_Status, File_Code, ISNULL(ACQ_Deal_Movie_Code, 0), bst.Is_Ignore  
	FROM #BVScheduleTransaction_Revert bst

	OPEN CR_BV_Schedule_Transaction        
	FETCH NEXT FROM CR_BV_Schedule_Transaction INTO @BV_Schedule_Transaction_Code, @Program_Episode_ID, @Program_Episode_Title_Cr, 
	@Program_Episode_Number_Cr, @Program_Title_Cr, @Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, 
	@Schedule_Item_Duration_Cr, @Scheduled_Version_House_Number_List_Cr, @Found_Status_Cr, @FileCode_Cr, @DMCode_Cr, @IsIgnore_Cr
	WHILE @@FETCH_STATUS<>-1
	BEGIN
		IF(@@FETCH_STATUS<>-2)
		BEGIN
			PRINT 'RC'
			SET @title_code_HouseID = 0
			SELECT TOP 1 @title_code_HouseID = tc.Title_Code, @Title_Content_Code = tc.Title_Content_Code
			FROM Title_Content tc
			INNER JOIN Content_Channel_Run ccr ON ccr.Title_Content_Code = tc.Title_Content_Code AND ISNULL(ccr.Is_Archive,'N') = 'N'  
			WHERE tc.Ref_BMS_Content_Code = @Program_Episode_ID
			AND ((ccr.Run_Type = 'C' AND
			( CONVERT(DATETIME, CONVERT (VARCHAR, @Schedule_Item_Log_Date_Cr, 111), 111)+@Schedule_Item_Log_TIME_Cr)
			BETWEEN CONVERT(DATETIME, ccr.Rights_Start_Date, 101) AND CONVERT(DATETIME, ccr.Rights_End_Date, 101) )
			OR (ccr.Run_Type  = 'U'))
			PRINT 'RD'

			--IF OBJECT_ID('tempdb..##anchaltemp') IS NULL
			--BEGIN
			--	--select * into  from #BVScheduleTransaction_Revert
			--	SELECT TOP 1 tc.Title_Code, tc.Title_Content_Code  
			--	INTO ##anchaltemp     
			--	FROM Title_Content tc      
			--	INNER JOIN Content_Channel_Run ccr ON ccr.Title_Content_Code = tc.Title_Content_Code AND ISNULL(ccr.Is_Archive,'N') = 'N'  
			--	WHERE tc.Ref_BMS_Content_Code = @Program_Episode_ID      
			--	AND (      
			--	(ccr.Run_Type = 'C' AND       
			--	( CONVERT(DATETIME, CONVERT (VARCHAR, @Schedule_Item_Log_Date_Cr, 111), 111)+@Schedule_Item_Log_TIME_Cr)   
			--	BETWEEN CONVERT(DATETIME, ccr.Rights_Start_Date, 101) AND CONVERT(DATETIME, ccr.Rights_End_Date, 101) )      
			--	OR (ccr.Run_Type  = 'U') )
			--END  
			--===============4.0 Insert Deal Data into #AcqRightsData FROM View with first filter===============--      
			PRINT 'Insert into temp #AcqRightsData_Revert'
			DELETE FROM #AcqRightsData_Revert
			DELETE FROM #DealRightsData
         
		--===============4.0 Insert Deal Data into #DealRightsData FROM both Acq and Provisional Deal filter===============--
          
		--INSERT INTO #DealRightsData ( deal_right_end_date, deal_right_start_date, Right_Type, deal_right_blackout_start_date, deal_right_blackout_end_date      
		--,Deal_Rights_Code, Deal_Code, Agreement_Date, Title_Code, Deal_Type)      
		--SELECT       
		-- CONVERT(DATETIME, MAX(adr.Actual_Right_End_Date), 101) AS  deal_right_end_date      
		-- ,CONVERT(DATETIME, MIN(adr.Actual_Right_Start_Date), 101) AS deal_right_start_date      
		-- ,adr.Right_Type      
		-- ,CONVERT(DATETIME, MIN(adrb.Start_Date), 101) AS deal_right_blackout_start_date      
		-- ,CONVERT(DATETIME, MAX(adrb.End_Date), 101) AS  deal_right_blackout_end_date      
		-- ,adr.Acq_Deal_Rights_Code      
		-- ,ad.Acq_Deal_Code      
		-- ,ad.Agreement_Date      
		-- ,adrrt.Title_Code      
		-- ,'A' Deal_Type      
		--FROM       
		-- Acq_Deal ad      
		-- INNER JOIN Acq_Deal_Rights adr ON ad.Acq_Deal_Code = adr.Acq_Deal_Code      
		-- INNER JOIN Acq_Deal_Movie adm ON ad.Acq_Deal_Code = adm.Acq_Deal_Code      
		-- INNER JOIN Acq_Deal_Rights_Title adrrt ON adrrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code AND adrrt.Title_Code = adm.Title_Code      
		-- INNER JOIN Acq_Deal_Rights_Platform adrp ON adrp.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code      
		-- LEFT OUTER  JOIN Acq_Deal_Rights_Blackout adrb ON adr.Acq_Deal_Rights_Code = adrb.Acq_Deal_Rights_Code      
		--WHERE adrrt.Title_Code IN ( @title_code_HouseID )      
		-- AND adrp.Platform_Code IN (SELECT Platform_Code FROM Platform WHERE ISNULL(Is_No_Of_Run, 'N') = 'Y')      
		--GROUP BY       
		--  adr.Actual_Right_End_Date      
		-- ,adr.Actual_Right_Start_Date      
		-- ,adr.Right_Type      
		-- ,adr.Acq_Deal_Rights_Code      
		-- ,ad.Acq_Deal_Code      
		-- ,ad.Agreement_Date      
		-- ,adrrt.Title_Code      
		--UNION      
		--SELECT      
		--  CONVERT(DATETIME, MAX(pd.Right_End_Date), 101) AS  deal_right_end_date      
		-- ,CONVERT(DATETIME, MIN(pd.Right_Start_Date), 101) AS deal_right_start_date      
		-- ,'Y' AS Right_Type      
		-- ,NULL AS deal_right_blackout_start_date      
		-- ,NULL AS  deal_right_blackout_end_date      
		-- ,0 AS Acq_Deal_Rights_Code      
		-- ,pd.Provisional_Deal_Code      
		-- ,pd.Agreement_Date      
		-- ,pdt.Title_Code      
		-- ,'P' Deal_Type      
		--FROM       
		-- Provisional_Deal pd      
		-- INNER JOIN Provisional_Deal_Title pdt ON pd.Provisional_Deal_Code = pdt.Provisional_Deal_Code      
		--WHERE      
		-- pdt.Title_Code IN ( @title_code_HouseID )      
		--GROUP BY       
		--  pd.Provisional_Deal_Code      
		-- ,pdt.Title_Code      
		-- ,pd.Agreement_Date      
		-- ,pd.Right_End_Date      
		-- ,pd.Right_Start_Date
	
			INSERT INTO #DealRightsData ( deal_right_end_date, deal_right_start_date, Deal_Code, 
			Agreement_Date, Title_Code, Deal_Type)      
			SELECT DISTINCT CONVERT(DATETIME, CCR.Rights_End_Date, 101), CONVERT(DATETIME, CCR.Rights_Start_Date, 101), CCR.Acq_Deal_Code,
			AD.Agreement_Date, CCR.Title_Code, 'A' Deal_Type      
			FROM Content_Channel_Run CCR
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
			WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND CCR.Title_Code IN (@title_code_HouseID)
			AND CCR.Title_Content_Code IN(@Title_Content_Code)
			AND CCR.Is_Archive = 'N'
			--AND adrp.Platform_Code IN (SELECT Platform_Code FROM Platform WHERE ISNULL(Is_No_Of_Run, 'N') = 'Y')      
			GROUP BY
			CONVERT(DATETIME, CCR.Rights_End_Date, 101), CONVERT(DATETIME, CCR.Rights_Start_Date, 101), CCR.Acq_Deal_Code,
			AD.Agreement_Date, CCR.Title_Code
			UNION
			SELECT DISTINCT CONVERT(DATETIME, CCR.Rights_End_Date, 101), CONVERT(DATETIME, CCR.Rights_Start_Date, 101), CCR.Provisional_Deal_Code,
			pd.Agreement_Date, CCR.Title_Code, 'P' Deal_Type
			FROM Content_Channel_Run CCR
			INNER JOIN Provisional_Deal pd ON pd.Provisional_Deal_Code = CCR.Provisional_Deal_Code WHERE      
			CCR.Title_Code IN (@title_code_HouseID) AND CCR.Title_Content_Code IN(@Title_Content_Code) AND CCR.Is_Archive = 'N'
			GROUP BY  CCR.Provisional_Deal_Code, CCR.Title_Code, pd.Agreement_Date, CCR.Rights_End_Date, CCR.Rights_Start_Date  
			PRINT 'RE'
			SELECT @IsInRightPeriod_Cnt = COUNT(*) FROM #DealRightsData drd
			WHERE CONVERT(DATETIME, @Schedule_Item_Log_Date_Cr, 101)       
			BETWEEN CONVERT(DATETIME, drd.deal_right_start_date, 101) AND CONVERT(DATETIME, drd.deal_right_end_date, 101)        
			OR ( drd.right_type = 'U' OR drd.right_type = 'R' OR drd.right_type = 'M' )

			--===============4.1 Insert Run Data into #AcqRightsData FROM Content Channel Run Table===============--      
			PRINT 'RF'
			INSERT INTO #AcqRightsData_Revert
			(       
				Acq_Deal_Code, ACQ_Deal_Run_Code, Channel_Code,       
				run_type, run_definition_type, no_of_runs, no_of_runs_sched,      
				no_of_AsRuns, ChannelWise_NoOfRuns, ChannelWise_NoOfRuns_Schedule, ChannelWise_no_of_AsRuns, title_code,       
				RightEndDate, MaxRightEndDate,       
				MaxDealCode,       
				MinDealCode,      
				Deal_Type, RightStartDate, Content_Channel_Run_Code     
			)      
			SELECT ISNULL(Acq_Deal_Code, Provisional_Deal_Code), ISNULL(Acq_Deal_Run_Code, Provisional_Deal_Run_Code), Channel_Code, 
			Run_Type, Run_Def_Type, SUM(Defined_Runs) OVER (PARTITION BY Title_Code), SUM(Schedule_Runs) OVER (PARTITION BY Title_Code),      
			SUM(AsRun_Runs) OVER (PARTITION BY Title_Code), Defined_Runs, Schedule_Runs, AsRun_Runs, Title_Code,      
			CAST(Rights_End_Date AS DATETIME) AS deal_right_end_date, MAX(Rights_End_Date) OVER (PARTITION BY Title_Code) AS MaxRightEndDate,      
			MAX(ISNULL(Acq_Deal_Code, Provisional_Deal_Code)) OVER (PARTITION BY Title_Code) AS MaxDealCode,      
			MIN(ISNULL(Acq_Deal_Code, Provisional_Deal_Code)) OVER (PARTITION BY Title_Code) AS MinDealCode,      
			ISNULL(Deal_Type,''), CAST(Rights_Start_Date AS DATETIME), Content_Channel_Run_Code  
			FROM Content_Channel_Run       
			WHERE Title_Code IN ( @title_code_HouseID ) AND Is_Archive = 'N'
			ORDER BY ISNULL(Acq_Deal_Code, Provisional_Deal_Code), ISNULL(Acq_Deal_Run_Code, Provisional_Deal_Run_Code)      
			PRINT 'RG'
			--===============4.1 Insert Run Data into #AcqRightsData FROM Content Channel Run Table===============--      
        
			print 'End Insert into temp #AcqRightsData_Revert'      
			--===============4.0 End Insert Deal Data into #AcqRightsData FROM View with first filter===============--

			BEGIN --===============6.0 Keep only those channel records which will be process now ===============--
				DELETE FROM #AcqRightsData_Revert WHERE ISNULL(Channel_Code, 0) NOT IN (@Channel_Code)      
			END
			--===============6.0 Keep only those channel records which will be process now ===============--

			--====7.0 Insert Deal Data into #AcqRightsData_Final FROM View with second filter (CREATE_FINAL_DEAL_RIGHTS_DATA)======--      
			DELETE FROM #AcqRightsData_Final_Revert
         
			IF(@IsInRightPeriod_Cnt > 0)
			BEGIN
			--===============7.1 Get Deal data if schedule within rights period ===============--      
				PRINT 'SCHEDULE WITHIN RIGHTS PERIOD...... Note:- For revert check also equal count i.e.'+
						+'(a.no_of_runs >= a.no_of_runs_sched OR a.Run_Type =U )'
		      
				INSERT INTO #AcqRightsData_Final_Revert
				(      
					ACQ_deal_code, ACQ_deal_movie_code, ACQ_deal_movie_rights_code, ACQ_deal_run_code,
					ChannelCode, Run_Type, Run_Definition_Type, DoNotConsume, RightPeriodFor, is_yearwise_definition,
					no_of_runs, no_of_runs_sched, no_of_AsRuns,
					ChannelWise_NoOfRuns, ChannelWise_NoOfRuns_Schedule, ChannelWise_no_of_AsRuns,
					title_code, Agreement_Date, MinDealSignedDate, MaxDealSignedDate,
					MaxDealCode, MinDealCode , Deal_Type, Content_Channel_Run_Code
				)      
				SELECT b.ACQ_deal_code, b.ACQ_deal_movie_code, b.ACQ_Deal_Rights_Code, b.ACQ_Deal_Run_Code,
					b.Channel_Code, b.Run_Type, b.Run_Definition_Type, b.DoNotConsume,
					b.RightPeriodFor, b.is_yearwise_definition,
					b.no_of_runs, b.no_of_runs_sched, b.no_of_AsRuns,
					b.ChannelWise_NoOfRuns, b.ChannelWise_NoOfRuns_Schedule, b.ChannelWise_no_of_AsRuns,
					b.title_code, b.Agreement_Date,
					b.MinDealSignedDate, b.MaxDealSignedDate, b.MaxDealCode, b.MinDealCode, Deal_Type, b.Content_Channel_Run_Code
				FROM
				(
					SELECT a.Acq_Deal_Code, a.ACQ_deal_movie_code, a.ACQ_Deal_Rights_Code, a.ACQ_Deal_Run_Code,
					a.Channel_Code, a.Run_Type, a.Run_Definition_Type, a.DoNotConsume,
					a.RightPeriodFor , a.is_yearwise_definition,
					a.no_of_runs, a.no_of_runs_sched, a.no_of_AsRuns,
					a.ChannelWise_NoOfRuns, a.ChannelWise_NoOfRuns_Schedule, a.ChannelWise_no_of_AsRuns,
					a.title_code, a.Agreement_Date AS Agreement_Date,
					MIN(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MinDealSignedDate,
					MAX(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MaxDealSignedDate,
					MAX(a.Acq_Deal_Code) OVER (PARTITION BY a.title_code) AS MaxDealCode,
					MIN(a.Acq_Deal_Code) OVER (PARTITION BY a.title_code) AS MinDealCode, Deal_Type,
					a.Content_Channel_Run_Code
					FROM #AcqRightsData_Revert a
					WHERE 1=1 AND  CONVERT(DATETIME, @Schedule_Item_Log_Date_Cr, 101)
					BETWEEN CONVERT(DATETIME, a.RightStartDate, 101) AND CONVERT(DATETIME, a.RightEndDate, 101)
				) AS b
				WHERE  1=1 --AND b.ACQ_deal_movie_code = @DMCode_Cr  
				AND b.title_code = @title_code_HouseID
				ORDER BY b.Agreement_Date, b.ACQ_deal_code, b.ACQ_Deal_Rights_Code

				SELECT TOP 1 @TempMaxDealCode = MAX(a.ACQ_deal_code), @TempMinDealCode = MIN(a.ACQ_deal_code),
				@TempMaxDealSignedDate = MAX(a.Agreement_Date), @TempMinDealSignedDate = MIN(a.Agreement_Date)
				FROM #AcqRightsData_Final_Revert a
          
				UPDATE #AcqRightsData_Final_Revert SET MaxDealCode= @TempMaxDealCode, MinDealCode = @TempMinDealCode,
				MaxDealSignedDate = @TempMaxDealSignedDate, MinDealSignedDate = @TempMinDealSignedDate
          
			--===============7.1 Get Deal data if schedule within the rights period ===============--
			END
			ELSE
			BEGIN
			--===============7.2 Get Deal data if schedule out side the rights period ===============-- 
				PRINT 'SCHEDULE OUT SIDE RIGHTS PERIOD'
          
				INSERT INTO #AcqRightsData_Final_Revert
				(      
					ACQ_deal_code, ACQ_deal_movie_code, ACQ_deal_movie_rights_code, ACQ_deal_run_code,
					ChannelCode, Run_Type, Run_Definition_Type, DoNotConsume, RightPeriodFor, is_yearwise_definition,
					no_of_runs, no_of_runs_sched, no_of_AsRuns, ChannelWise_NoOfRuns, ChannelWise_NoOfRuns_Schedule, 
					ChannelWise_no_of_AsRuns, title_code, Agreement_Date, 
					MinDealSignedDate, 
					MaxDealSignedDate,
					MaxDealCode, 
					MinDealCode, Deal_Type, Content_Channel_Run_Code
				)      
				SELECT a.ACQ_deal_code, a.ACQ_deal_movie_code, a.ACQ_Deal_Rights_Code, a.ACQ_deal_run_code,
					a.Channel_Code, a.Run_Type, ISNULL(a.Run_Definition_Type,'N'), a.DoNotConsume, a.RightPeriodFor, a.is_yearwise_definition,
					a.no_of_runs, a.no_of_runs_sched, a.no_of_AsRuns, a.ChannelWise_NoOfRuns, a.ChannelWise_NoOfRuns_Schedule, 
					a.ChannelWise_no_of_AsRuns, a.title_code, a.Agreement_Date, 
					MIN(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MinDealSignedDate,
					MAX(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MaxDealSignedDate, 
					MAX(a.ACQ_deal_code) OVER (PARTITION BY a.title_code) AS MaxDealCode,
					MIN(a.ACQ_deal_code) OVER (PARTITION BY a.title_code) AS MinDealCode, Deal_Type, a.Content_Channel_Run_Code
				FROM #AcqRightsData_Revert a       
				--LEFT JOIN Acq_Deal_Run_Yearwise_Run adry ON a.ACQ_Deal_Run_Code = adry.Acq_Deal_Run_Code AND
				--@Schedule_Item_Log_Date_Cr >= adry.Start_Date AND @Schedule_Item_Log_Date_Cr <= adry.End_Date
				WHERE-- a.IsInRightPerod = 'N'       
				CONVERT(DATETIME, @Schedule_Item_Log_Date_Cr, 101) 
				BETWEEN CONVERT(DATETIME, a.RightStartDate, 101) AND CONVERT(DATETIME, a.RightEndDate, 101)
				AND a.title_code = @title_code_HouseID ORDER BY a.Agreement_Date, a.ACQ_deal_code, a.ACQ_Deal_Rights_Code
      
				SELECT TOP 1 @TempMaxDealCode =MAX(a.ACQ_deal_code), @TempMinDealCode = MIN(a.ACQ_deal_code),
				@TempMaxDealSignedDate = MAX(a.Agreement_Date), @TempMinDealSignedDate = MIN(a.Agreement_Date)
				FROM #AcqRightsData_Final_Revert a
          
				UPDATE #AcqRightsData_Final_Revert SET MaxDealCode= @TempMaxDealCode, MinDealCode = @TempMinDealCode,
				MaxDealSignedDate = @TempMaxDealSignedDate, MinDealSignedDate = @TempMinDealSignedDate
			--===============7.2 Get Deal data if schedule out side the rights period ===============--          
			END
			--===7.0 Insert Deal Data into #AcqRightsData_Final FROM View with second filter (CREATE_FINAL_DEAL_RIGHTS_DATA)====--
		      
			--===============8.0 INNER_CURSOR_FOR_UPDATE_SCHEDULE_RUN_IN_FIFO_ORDER ===============--
			DECLARE @VW_DCode_Cr INT = 0, @VW_DMCode_Cr INT = 0, @VW_DMRCode_Cr INT = 0, @VW_DMR_Run_Code_Cr INT = 0,
			@VW_Yearwise_Def_Cr CHAR(1) = 0, @VW_DealSignedDate_Cr DATETIME, @VW_MinDealSignedDate_Cr DATETIME,
			@VW_Run_Definition_Type_Cr VARCHAR(10), @PrimeStartTime DATETIME, @PrimeEndTime DATETIME, @Time_Lag_Simulcast DATETIME, 
			@OffPrimeStartTime DATETIME, @OffPrimeEndTime DATETIME, @Schedule_Item_Log_Date  DATETIME, @BalanceRun INT = 0, @VW_Deal_Type CHAR(1),
			@VW_CCR_Code INT = 0

			----------- TEMP DEAL_CODE IN CONDITION IF MULTIPLE DEAL HAS SAME DEAL SIGNED DATE      
			DECLARE @TempDealCode INT = 0, @Schedule_date_time DATETIME
         
			SELECT DISTINCT @VW_DCode_Cr = ACQ_deal_code, @VW_DMCode_CR = ACQ_deal_movie_code, @VW_DMRCode_Cr = ACQ_deal_movie_rights_code,
				@VW_DMR_Run_Code_Cr= ACQ_deal_run_code, @VW_Yearwise_Def_Cr= is_yearwise_definition,
				@VW_DealSignedDate_Cr = Agreement_Date, @VW_MinDealSignedDate_Cr = MinDealSignedDate, 
				@VW_Run_Definition_Type_Cr = Run_Definition_Type, @VW_Deal_Type = Deal_Type, @VW_CCR_Code = Content_Channel_Run_Code
			FROM #AcqRightsData_Final_Revert
	
			--IF( ISNULL(@IsIgnore_Cr,'N') = 'N' ) ------- UPDATE ONLY FIRST DEAL FOR FIFO ORDER      
			--BEGIN      
			SET @TempDealCode = @VW_DCode_Cr      
			PRINT '--===============8.1 UPDATE RUNS ===============--'      
				--UPDATE ACQ_Deal_Run SET No_Of_Runs_Sched = ISNULL(No_Of_Runs_Sched, 0) - @RevertCnt      
				--WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND ISNULL(No_Of_Runs_Sched, 0) > 0      
          		--UPDATE Content_Channel_Run SET Schedule_Runs = ISNULL(Schedule_Runs, 0) - @RevertCnt      
				--WHERE Content_Channel_Run_Code = @VW_CCR_Code AND ISNULL(Schedule_Runs, 0) > 0

			IF(@VW_Run_Definition_Type_Cr = 'S' OR @VW_Run_Definition_Type_Cr = 'N')  
			BEGIN  
				UPDATE Content_Channel_Run SET Schedule_Runs =
					CASE WHEN ISNULL(@IsIgnore_Cr,'N') = 'N' THEN ISNULL(Schedule_Runs, 0) - @RevertCnt
					ELSE ISNULL(Schedule_Runs, 0) END,
					Schedule_Utilized_Runs = ISNULL(Schedule_Utilized_Runs, 0)  - @RevertCnt
					WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr 
					AND ISNULL(Is_Archive,'N') = 'N' AND Title_Content_Code = @Title_Content_Code  
					AND ----------Right Period Validation                                              
					(
						@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(Rights_Start_Date, @Schedule_Item_Log_Date_Cr) AS DATETIME)
						AND CAST(ISNULL(Rights_End_Date,@Schedule_Item_Log_Date_Cr) AS DATETIME)
					) AND ISNULL(Schedule_Runs, 0) > 0
			END  
			ELSE  
			BEGIN  
				UPDATE Content_Channel_Run SET Schedule_Runs =   
				CASE WHEN ISNULL(@IsIgnore_Cr,'N') = 'N' THEN ISNULL(Schedule_Runs, 0) - @RevertCnt  
				ELSE ISNULL(Schedule_Runs, 0) END,  
				Schedule_Utilized_Runs = ISNULL(Schedule_Utilized_Runs, 0) - @RevertCnt
				WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND Channel_Code = @Channel_Code AND ISNULL(Is_Archive,'N') = 'N'   
				AND Content_Channel_Run_Code =@VW_CCR_Code AND ISNULL(Schedule_Runs, 0) > 0
			END  
    
				/*Check Current schedule record whether falls IN Prime time or off prime time */      
			IF((SELECT
					CASE WHEN ISNULL(MIN(CCR.Deal_Type), 'A') = 'A' THEN COUNT(Ad.Business_Unit_Code)
					ELSE  COUNT(PD.Business_Unit_Code) END
					FROM Content_Channel_Run CCR
					LEFT JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code AND ISNULL(CCR.Deal_Type, 'A') = 'A'
					AND CCR.Acq_Deal_Code = @VW_DCode_Cr
					LEFT JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND ISNULL(CCR.Deal_Type, 'A') = 'P' 
					AND CCR.Provisional_Deal_Code = @VW_DCode_Cr
					WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ((AD.Business_Unit_Code IN ( SELECT Business_Unit_Code FROM Business_Unit WHERE  
					Business_Unit_Name LIKE '%English Movies%') AND ISNULL(CCR.Deal_Type, 'A') = 'A')
					OR (PD.Business_Unit_Code IN ( SELECT Business_Unit_Code FROM Business_Unit WHERE  Business_Unit_Name LIKE '%English Movies%')
					AND ISNULL(CCR.Deal_Type, 'A') = 'P'))) > 0      
			   )/* Currently Prime & off Prime calculation is availalbe for only English movies*/      
			BEGIN
				--PRINT '@VW_DMR_Run_Code_Cr ' + CAST(@VW_DMR_Run_Code_Cr AS VARCHAR)      
				SELECT @Schedule_Item_Log_Date = CONVERT(DATETIME, ( @Schedule_Item_Log_Date_Cr + CAST(@Schedule_Item_Log_TIME_Cr AS DATETIME)), 101)      
				SELECT
					@PrimeStartTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15), 
					CAST(Prime_Start_Time AS TIME),100)) AS DATETIME)) ,101)
					,@OffPrimeStartTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15), 
					CAST(OffPrime_Start_Time AS TIME),100)) AS DATETIME)) ,101)
					,@Time_Lag_Simulcast = Time_Lag_Simulcast
					,@PrimeEndTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),
					CAST(Prime_End_Time  AS TIME),100)) AS DATETIME)) ,101)
					,@OffPrimeEndTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),
					CAST(OffPrime_End_Time  AS TIME),100)) AS DATETIME)) ,101)
					FROM Content_Channel_Run WHERE Acq_Deal_Run_Code = @VW_DMR_Run_Code_Cr AND Is_Archive = 'N' AND Channel_Code = @Channel_Code
           
				--PRINT 'BEFORE PRIME '      
				--PRINT '@Schedule_Item_Log_Date ' + CAST(@Schedule_Item_Log_Date AS VARCHAR)
				--PRINT ' @PrimeStartTime' + CAST(ISNULL(@PrimeStartTime,'NULL') AS VARCHAR)
				--PRINT ' @PrimeEndTime' + CAST(ISNULL(@PrimeEndTime,'NUll') AS VARCHAR)
				      
				DECLARE @IsPrime CHAR(1) = 'X', @is_exception CHAR(1) = 'N', @ExceptionType CHAR(1) = 'N'      
				DECLARE @Currently_Added_ID INT SET @Currently_Added_ID = 0
              
				IF((SELECT DATEDIFF(MI, @PrimeStartTime, @PrimeEndTime ) ) < 0)
				BEGIN
					SET  @PrimeEndTime =  DATEADD(DAY, 1, CAST(@PrimeEndTime AS DATETIME))
				END
              
				IF((SELECT DATEDIFF(MI, @OffPrimeStartTime, @OffPrimeEndTime ) ) < 0)
				BEGIN
					SET  @OffPrimeEndTime =  DATEADD(DAY, 1, CAST(@OffPrimeEndTime AS DATETIME))
				END
				ELSE
				BEGIN
					SET @OffPrimeStartTime = DATEADD(DAY, -1, CAST(@OffPrimeStartTime AS DATETIME))
				END
                      
				--PRINT '@Schedule_Item_Log_Date' + CAST(@Schedule_Item_Log_Date AS VARCHAR)
				--PRINT '@PrimeStartTime' + CAST(@PrimeStartTime AS VARCHAR)
				--PRINT '@@PrimeEndTime' + CAST(@PrimeEndTime AS VARCHAR)
				--PRINT '@VW_DMCode_CR' + CAST(@VW_DMCode_CR AS VARCHAR)
				--PRINT '@OffPrimeStartTime' + CAST(@OffPrimeStartTime AS VARCHAR)      
				--PRINT '@OffPrimeEndTime' + CAST(@OffPrimeEndTime AS VARCHAR)       

				IF(ISNULL(@PrimeStartTime,'') != ''  AND ISNULL(@OffPrimeStartTime, '') != '' )
				BEGIN
					SET @OffPrimeStartTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),   
					CAST('00:00:01.0000000' AS TIME), 100)) AS DATETIME)) ,101)     
					--set @OffPrimeStartTime = convert(datetime,  (@Schedule_Item_Log_Date + CAST((select CONVERT(varchar(15),CAST('00:00:01' AS TIME),100)) 
											 --as datetime)) ,101)
					IF(CAST(@Schedule_Item_Log_Date  AS DATETIME) BETWEEN CAST(@PrimeStartTime AS DATETIME) AND CAST(@PrimeEndTime AS DATETIME))
					BEGIN      
						SET @IsPrime = 'Y'                
					END      
					ELSE IF(CAST(@Schedule_Item_Log_Date AS DATETIME) BETWEEN CAST(@OffPrimeStartTime AS DATETIME) AND CAST((@OffPrimeEndTime) AS DATETIME))
					BEGIN       
						SET @IsPrime = 'N'      
					END      
					ELSE      
					BEGIN       
						SET @is_exception = 'Y'      
						SET @ExceptionType = 'X'      
					END      
				END      
				/*Only Prime Time Defined */      
				ELSE IF(ISNULL(@PrimeStartTime,'') != ''  AND ISNULL(@OffPrimeStartTime,'') = '' )
				BEGIN
					IF(CAST(@Schedule_Item_Log_Date AS DATETIME) NOT BETWEEN CAST( @PrimeStartTime AS DATETIME) AND CAST(@PrimeEndTime AS DATETIME))
					BEGIN
						SET @is_exception = 'Y'
						SET @ExceptionType = 'P'
					END
					ELSE
						SET @IsPrime = 'Y'
				END      
				/*Only OFF Prime Time Defined */      
				ELSE IF(ISNULL(@PrimeStartTime,'') = ''  AND ISNULL(@OffPrimeStartTime,'') != '' )       
				BEGIN
					SET @PrimeStartTime = dateadd(MINUTE,1,@OffPrimeEndTime)
					SET @PrimeEndTime = dateadd(MINUTE,-1,@OffPrimeStartTime)
               
					IF(CAST(@Schedule_Item_Log_Date AS DATETIME)  BETWEEN CAST(@PrimeStartTime AS DATETIME) AND CAST(@PrimeEndTime AS DATETIME))
					BEGIN
						SET @is_exception = 'Y'
						SET @ExceptionType = 'O'
					END
					ELSE
						SET @IsPrime = 'N'
				END      
           
				--PRINT '@IsPrime' + CAST(@IsPrime AS VARCHAR)      
				IF(@IsPrime = 'N')
				BEGIN
					--UPDATE ACQ_Deal_Run SET  Off_Prime_Time_Provisional_Run_Count = ISNULL(Off_Prime_Time_Provisional_Run_Count, 0) - @RevertCnt,      
					--Off_Prime_Time_Balance_Count = ISNULL(Off_Prime_Run, 0) - ((ISNULL(Off_Prime_Time_Provisional_Run_Count, 0) - @RevertCnt) + ISNULL(Off_Prime_Time_AsRun_Count, 0) )       
					--WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr        
					--UPDATE Content_Channel_Run SET OffPrime_Schedule_Runs =  ISNULL(OffPrime_Schedule_Runs,0) - @RevertCnt      
					--WHERE Content_Channel_Run_Code = @VW_CCR_Code AND ISNULL(OffPrime_Schedule_Runs, 0) > 0

	  				IF(@VW_Run_Definition_Type_Cr = 'S' OR @VW_Run_Definition_Type_Cr = 'N')
					BEGIN
						UPDATE Content_Channel_Run SET OffPrime_Schedule_Runs =
						CASE WHEN ISNULL(@IsIgnore_Cr,'N') = 'N' THEN ISNULL(OffPrime_Schedule_Runs, 0) - @RevertCnt
						ELSE ISNULL(OffPrime_Schedule_Runs, 0) END,
						OffPrime_Schedule_Utilized_Runs = ISNULL(OffPrime_Schedule_Utilized_Runs, 0)  - @RevertCnt
						WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr 
						AND ISNULL(Is_Archive,'N') = 'N' AND Title_Content_Code = @Title_Content_Code
						AND ----------Right Period Validation
						(
							@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(Rights_Start_Date, @Schedule_Item_Log_Date_Cr) AS DATETIME)
							AND CAST(ISNULL(Rights_End_Date,@Schedule_Item_Log_Date_Cr) AS DATETIME)
						) AND ISNULL(OffPrime_Schedule_Runs, 0) > 0
					END  
					ELSE  
					BEGIN
						UPDATE Content_Channel_Run SET OffPrime_Schedule_Runs =
						CASE WHEN ISNULL(@IsIgnore_Cr,'N') = 'N' THEN ISNULL(OffPrime_Schedule_Runs, 0) - @RevertCnt  
						ELSE ISNULL(OffPrime_Schedule_Runs, 0) END,
						OffPrime_Schedule_Utilized_Runs = ISNULL(OffPrime_Schedule_Utilized_Runs, 0) - @RevertCnt
						WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND Channel_Code = @Channel_Code AND ISNULL(Is_Archive,'N') = 'N'
						AND Content_Channel_Run_Code =@VW_CCR_Code AND ISNULL(OffPrime_Schedule_Runs, 0) > 0
					END  

					--ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND Channel_Code = @Channel_Code      
					--AND ----------Right Period Validation                                              
					--(                                              
					--@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(Rights_Start_Date, @Schedule_Item_Log_Date_Cr) AS DATETIME)                                 
					--AND CAST(ISNULL(Rights_End_Date,@Schedule_Item_Log_Date_Cr) AS DATETIME)      
					--)----------/Right Period Validation       
      
				END      
				ELSE IF(@IsPrime = 'Y')
				BEGIN
					--UPDATE ACQ_Deal_Run SET Prime_Time_Provisional_Run_Count = ISNULL(Prime_Time_Provisional_Run_Count, 0) - @RevertCnt,
					--Prime_Time_Balance_Count = ISNULL(Prime_Run, 0) - ((ISNULL(Prime_Time_Provisional_Run_Count, 0) - @RevertCnt) + ISNULL(Prime_Time_AsRun_Count, 0) )       
					--WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr
				      
					--UPDATE Content_Channel_Run SET Prime_Schedule_Runs =  ISNULL(Prime_Schedule_Runs,0) - @RevertCnt      
					--WHERE Content_Channel_Run_Code = @VW_CCR_Code AND ISNULL(Prime_Schedule_Runs, 0) > 0 
					IF(@VW_Run_Definition_Type_Cr = 'S' OR @VW_Run_Definition_Type_Cr = 'N')  
					BEGIN
						UPDATE Content_Channel_Run SET Prime_Schedule_Runs =
						CASE WHEN ISNULL(@IsIgnore_Cr,'N') = 'N' THEN ISNULL(Prime_Schedule_Runs, 0) - @RevertCnt  
						ELSE ISNULL(Prime_Schedule_Runs, 0) END,  
						Prime_Schedule_Utilized_Runs = ISNULL(Prime_Schedule_Utilized_Runs, 0)  - @RevertCnt
						WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr --AND Channel_Code = @Channel_Code   
						AND ISNULL(Is_Archive,'N') = 'N' AND Title_Content_Code = @Title_Content_Code
						--AND Content_Channel_Run_Code = @VW_CCR_Code
						AND ----------Right Period Validation
						(
							@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(Rights_Start_Date, @Schedule_Item_Log_Date_Cr) AS DATETIME)
							AND CAST(ISNULL(Rights_End_Date,@Schedule_Item_Log_Date_Cr) AS DATETIME)
						) AND ISNULL(Prime_Schedule_Runs, 0) > 0
					END  
					ELSE  
					BEGIN
						UPDATE Content_Channel_Run SET Prime_Schedule_Runs =
						CASE WHEN ISNULL(@IsIgnore_Cr,'N') = 'N' THEN ISNULL(Prime_Schedule_Runs, 0) - @RevertCnt
						ELSE ISNULL(Prime_Schedule_Runs, 0) END,
						Prime_Schedule_Utilized_Runs = ISNULL(Prime_Schedule_Utilized_Runs, 0) - @RevertCnt
						WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND Channel_Code = @Channel_Code AND ISNULL(Is_Archive,'N') = 'N'
						AND Content_Channel_Run_Code =@VW_CCR_Code AND ISNULL(Prime_Schedule_Runs, 0) > 0
					END  
				END      
			END      
          
			--/*Check Cureent schedule record whether falls IN Prime time or off prime time */      
			--UPDATE ACQ_Deal_Run_Channel SET no_of_runs_sched = ISNULL(no_of_runs_sched, 0) - @RevertCnt      
			--WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND channel_code = @Channel_Code       
			--AND ISNULL(no_of_runs_sched, 0) > 0      
          
			PRINT '--===============8.1 END UPDATE RUNS ===============--'      
            
			-- Note:- HERE Deal_Movie_Code UPDATE to BV_Schedule_Transaction To show Channel_Wise Report      
			IF(@RevertCnt > 0)
			BEGIN
				UPDATE BV_Schedule_Transaction SET Deal_Movie_Code = @VW_DMCode_CR, Deal_Movie_Rights_Code = @VW_DMRCode_CR
				,Acq_Deal_Run_Code = @VW_DMR_Run_Code_Cr, Deal_Code = @VW_DCode_Cr , Deal_Type = @Vw_Deal_Type
				WHERE BV_Schedule_Transaction_Code =  @BV_Schedule_Transaction_Code
			END
            
			--PRINT '--===============8.2 Yearwise Run Definition ===============--'
			--IF( (@VW_Yearwise_Def_Cr = 'Y') AND ( @IsInRightPeriod_Cnt > 0) )      
			--BEGIN      
			--UPDATE DMRRYR SET DMRRYR.no_of_runs_sched = ISNULL(DMRRYR.no_of_runs_sched, 0) - @RevertCnt      
			--FROM Acq_Deal_Run_Yearwise_Run DMRRYR      
			--WHERE DMRRYR.ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr      
			--AND ----------Right Period Validation                                              
			--(                                              
			--@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(DMRRYR.start_date, @Schedule_Item_Log_Date_Cr) AS DATETIME)                                 
			--AND CAST(ISNULL(DMRRYR.end_date, @Schedule_Item_Log_Date_Cr) AS DATETIME)      
			--)----------/Right Period Validation        
			--AND (ISNULL(DMRRYR.no_of_runs_sched, 0)  - @RevertCnt ) >= 0      
             
			--END      
            
			------------------- IF VALID RIGHT PERIOD NOT FOUND -----------------      
			--IF((@VW_Yearwise_Def_Cr = 'Y') AND (@IsInRightPeriod_Cnt <= 0) )      
			--BEGIN      
			--SELECT @DMR_RunYearwiseRun_Code = Acq_Deal_Run_Yearwise_Run_Code      
			--FROM       
			--(      
			--SELECT *, MAX(DMRRYR.end_date) OVER (PARTITION BY DMRRYR.Acq_Deal_Run_Code) AS MaxEndDate      
			--FROM Acq_Deal_Run_Yearwise_Run DMRRYR      
			--WHERE DMRRYR.Acq_Deal_Run_Code = @VW_DMR_Run_Code_Cr      
			--) AS a WHERE a.end_date IN (a.MaxEndDate)      
             
			--UPDATE DMRRYR SET DMRRYR.no_of_runs_sched = ISNULL(DMRRYR.no_of_runs_sched, 0) - @RevertCnt      
			--FROM Acq_Deal_Run_Yearwise_Run DMRRYR      
			--WHERE DMRRYR.Acq_Deal_Run_Yearwise_Run_Code      
			--IN (@DMR_RunYearwiseRun_Code)  --AND ISNULL(DMRRYR.no_of_runs_sched, 0) > 0      
			--AND (ISNULL(DMRRYR.no_of_runs_sched, 0)  - @RevertCnt) >= 0      
			--END              
            
			----------------- END IF VALID RIGHT PERIOD NOT FOUND -----------------      
			--PRINT '===============8.2 End Yearwise Run Definition ==============='      
            
		--END      
           
			DELETE FROM Email_Notification_Schedule WHERE
			--( CONVERT(DATETIME, CONVERT (VARCHAR, Schedule_Item_Log_Date, 111), 111) + Schedule_Item_Log_Time )
			Convert(DATETIME, Schedule_Item_Log_Date, 101) BETWEEN @ScheStartDate AND @ScheEndDate      
			AND Channel_Code = @Channel_Code AND File_Code NOT IN (@File_Code)      

			EXEC USP_Music_Schedule_Process
			@TitleCode = 0,
			@EpisodeNo = 0,
			@BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code,
			@MusicScheduleTransactionCode = 0,
			@CallFrom= 'SR'
      
			DELETE FROM BV_Schedule_Transaction WHERE BV_Schedule_Transaction_Code IN (@BV_Schedule_Transaction_Code)
		END
		FETCH NEXT FROM CR_BV_Schedule_Transaction INTO @BV_Schedule_Transaction_Code, @Program_Episode_ID, @Program_Episode_Title_Cr, 
		@Program_Episode_Number_Cr, @Program_Title_Cr, @Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, 
		@Schedule_Item_Duration_Cr, @Scheduled_Version_House_Number_List_Cr, @Found_Status_Cr, @FileCode_Cr, @DMCode_Cr, @IsIgnore_Cr
	END
	CLOSE CR_BV_Schedule_Transaction
	DEALLOCATE CR_BV_Schedule_Transaction
	------------------------------------ 3.0 END_CURSOR_FOR_UPDATE_SCHEDULE_COUNT------------------------------------              
END      
      
/*      
EXEC [USP_Schedule_Revert_Count] 152, 17      
*/