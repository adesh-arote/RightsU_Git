CREATE PROCEDURE [dbo].[USP_Schedule_Process]      
(    
--DECLARE  
	@File_Code INT ,  
	@Channel_Code VARCHAR(10),  
	@Deal_Code INT = 0,     
	@CallFromDealApprove VARCHAR(10) = 'Y',  
	@CanProcessRun INT = 0,  
	@Deal_Type CHAR(1) = 'A'  
)       
AS      
BEGIN      
	IF(@CallFromDealApprove IS NULL)      
	SET @CallFromDealApprove = 'N'
	BEGIN------------------------------------------- GLOBAL VARIBALES -------------------------------------------
		DECLARE @ChannelCodes_Cnt INT = 0
		DECLARE @IsInRightPeriod_Cnt INT = 0
		DECLARE @IsInBlackOutPeriod_Cnt INT = 0
		DECLARE @title_code_HouseID INT = 0
		DECLARE @TempMaxDealCode Numeric(18,0)
		DECLARE @TempMinDealCode Numeric(18,0)
		DECLARE @TempMaxDealSignedDate DATETIME
		DECLARE @TempMinDealSignedDate DATETIME
		DECLARE @IsInvalidChannelRights CHAR(1) = 'N'
		DECLARE @Title_Content_Code INT = 0
	END
	BEGIN------------------------------------------- DELETE TEMP TABLES-------------------------------------------
		IF OBJECT_ID('tempdb..#DealRunData') IS NOT NULL
		BEGIN
			DROP TABLE #DealRunData
		END
		IF OBJECT_ID('tempdb..#DealRightsData_Final') IS NOT NULL
		BEGIN
			DROP TABLE #DealRightsData_Final
		END
		IF OBJECT_ID('tempdb..#BVScheduleTransaction') IS NOT NULL
		BEGIN
			DROP TABLE #BVScheduleTransaction
		END
		IF OBJECT_ID('tempdb..#DealRightsData') IS NOT NULL
		BEGIN
			DROP TABLE #DealRightsData
		END
	END
      
	BEGIN -----1.0------------------------------------------------ CREATE TEMP TABLES -------------------------------------------
       
		CREATE TABLE #DealRightsData
		(
			deal_right_end_date DATETIME, deal_right_start_date DATETIME, Deal_Code INT, Agreement_Date DATETIME, Title_Code INT, Deal_Type VARCHAR(1)
			--Right_Type CHAR(1), deal_right_blackout_start_date DATETIME, deal_right_blackout_end_date DATETIME, Deal_Rights_Code INT, 
		)
		CREATE TABLE #DealRunData
		(
			Deal_Code INT,-- Acq_deal_movie_code INT,-- ACQ_Deal_Rights_Code INT,
			Deal_Run_Code INT, Channel_Code INT, run_type VARCHAR(3),
			run_definition_type VARCHAR(10), DoNotConsume VARCHAR(10), is_yearwise_definition VARCHAR(10), no_of_runs INT, no_of_runs_sched INT,
			no_of_AsRuns INT, ChannelWise_NoOfRuns INT, ChannelWise_NoOfRuns_Schedule INT, ChannelWise_no_of_AsRuns INT, title_code INT,
			Agreement_Date DATETIME, RightEndDate DATETIME, MaxRightEndDate DATETIME, MaxDealCode INT, MinDealCode INT, IsInRightPerod VARCHAR(3),
			IsInBlackOutPeriod VARCHAR(3), RightPeriodFor VARCHAR(3), Deal_Type CHAR(1), Content_Channel_Run_Code INT
		)
      
		CREATE TABLE #DealRightsData_Final
		(
			Deal_Code INT, --Acq_deal_movie_code INT, ACQ_deal_movie_rights_code INT, 
			Deal_Run_code INT, ChannelCode INT, Run_Type CHAR(1),
			Run_Definition_Type VARCHAR(10), DoNotConsume VARCHAR(10),  -- DO NOT CONSUME RIGHTS
			RightPeriodFor VARCHAR(10),  --RUN BASED
			is_yearwise_definition CHAR(1), no_of_runs INT, no_of_runs_sched INT, no_of_AsRuns INT, -- ACTUAL RUN
			ChannelWise_NoOfRuns INT, ChannelWise_NoOfRuns_Schedule INT, ChannelWise_no_of_AsRuns INT,  -- CHANNEL WISE ACTUAL RUN
			title_code INT, Agreement_Date DATETIME, MinDealSignedDate DATETIME, MaxDealSignedDate DATETIME, MaxDealCode INT, MinDealCode INT,
			Deal_Type CHAR(1), Content_Channel_Run_Code INT
		)
      
		CREATE TABLE #BVScheduleTransaction  -- BV_Schedule_Transaction Data
		(
			BV_Schedule_Transaction_Code NUMERIC(18,0), Program_Episode_ID NVARCHAR(1000), Program_Version_ID NVARCHAR(1000), Program_Episode_Title NVARCHAR(250), 
			Program_Episode_Number VARCHAR(100), Program_Title NVARCHAR(250), Program_Category NVARCHAR(250), Schedule_Item_Log_Date VARCHAR(50), 
			Schedule_Item_Log_Time VARCHAR(50), Schedule_Item_Duration VARCHAR(100), Scheduled_Version_House_Number_List NVARCHAR(100), Found_Status CHAR(1),
			File_Code bigint, Title_Code NUMERIC(18,0), IsProcessed CHAR(1), IsException CHAR(1)    
		)
		-----1.0------------------------------------------------ END CREATE TEMP TABLES -------------------------------------------
	End      
        
	IF(@CallFromDealApprove = 'N')
	BEGIN
		PRINT '@CallFromDealApprove : '+@CallFromDealApprove
		-----2.0----- INSERT INTO TEMP Table Data which needs to be processed      
		INSERT INTO #BVScheduleTransaction
		(      
			BV_Schedule_Transaction_Code, Program_Episode_ID, Program_Version_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, 
			Program_Category, Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			Found_Status, File_Code, Title_Code, IsProcessed, IsException
		)      
		SELECT BV_Schedule_Transaction_Code, Program_Episode_ID, Program_Version_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, 
			Program_Category, Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			Found_Status, File_Code, Title_Code, IsProcessed, IsException
		FROM BV_Schedule_Transaction WHERE 1=1 AND File_Code = @File_Code AND ISNULL(IsProcessed, 'N') = 'N'
		AND ISNULL(Found_Status, 'N') = 'Y'
		-----2.0-----      
	END      
	ELSE IF(@CallFromDealApprove = 'Y')
	BEGIN
		PRINT '@CallFromDealApprove : '+@CallFromDealApprove
		INSERT INTO BV_Schedule_Transaction
		(
			Program_Episode_Title, Program_Episode_ID, Program_Version_ID, Program_Episode_Number, Program_Title,
			Program_Category, Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration,
			Scheduled_Version_House_Number_List, Found_Status,
			File_Code, Channel_Code, IsProcessed, Inserted_By, Inserted_On, Title_Code
		)      
		SELECT tbs.Program_Episode_Title, tbs.Program_Episode_ID, tbs.Program_Version_ID, tbs.Program_Episode_Number, tbs.Program_Title,
			tbs.Program_Category, tbs.Schedule_Item_Log_Date, tbs.Schedule_Item_Log_Time, tbs.Schedule_Item_Duration,
			tbs.Scheduled_Version_House_Number_List, 'Y', tbs.File_Code, tbs.Channel_Code, 'N', tbs.Inserted_By , GETDATE(), TitleCode
		FROM Temp_BV_Schedule tbs
		WHERE 1 = 1
		AND File_Code = @File_Code AND ISNULL(tbs.IsDealApproved, 'Y') = 'N' AND Deal_Code = @Deal_Code AND Deal_Type = @Deal_Type
          
		DELETE FROM Temp_BV_Schedule
		WHERE 1=1 AND File_Code = @File_Code AND ISNULL(IsDealApproved,'Y') = 'N'
		AND Deal_Code = @Deal_Code AND Deal_Type = @Deal_Type
        
		SELECT CCR.Title_Code,CCR.Channel_Code, MIN(CCR.Rights_Start_Date) AS Right_Start_Date, 
			MAX(ISNULL(CCR.Rights_End_Date,'31-DEC-9999')) AS Right_End_Date
		INTO #tempTitleStartEndDate
		FROm Content_Channel_Run CCR
			Where ((CCR.Acq_Deal_Code = @Deal_Code AND CCR.Deal_Type = 'A') OR (CCR.Provisional_Deal_Code = @Deal_Code AND CCR.Deal_Type = 'P'))
			Group BY CCR.Title_Code,CCR.Channel_Code

		INSERT INTO #BVScheduleTransaction 
		(
			BV_Schedule_Transaction_Code,Program_Episode_ID,Program_Version_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			Found_Status, File_Code, Title_Code, IsProcessed, IsException
		)
		SELECT  BV_Schedule_Transaction_Code,Program_Episode_ID,Program_Version_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category, 
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List, 
			Found_Status, File_Code, BST.Title_Code, IsProcessed, IsException
		FROM BV_Schedule_Transaction BST
		INNER JOIN #tempTitleStartEndDate T On BST.Title_Code = T.Title_Code AND BST.File_Code = @File_Code AND ISNUll(BST.IsProcessed,'N') = 'N' 
		AND (((Convert(DATE,BST.Schedule_Item_Log_Date,101) BETWEEN T.Right_Start_Date AND T.Right_End_Date) AND BST.Deal_Movie_Code IS NULL)
		OR
		(
			BST.Deal_Movie_Code IN(select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Acq_Deal_Code = @Deal_Code))
		)
		AND BST.Channel_Code = T.Channel_Code AND BST.Channel_Code = @Channel_Code  AND Deal_Type = @Deal_Type
	END
      
	BEGIN ------------------------------------ 3.0 MAIN_CURSOR_FOR_UPDATE_SCHEDULE_COUNT ------------------------------------      
		DECLARE @IncreaseCnt INT = 1 --- variables need to increse counter---
		DECLARE @BV_Schedule_Transaction_Code INT, @Program_Episode_ID_Cr NVARCHAR(1000), @Program_Episode_Title_Cr NVARCHAR(500), @Program_Episode_Number_Cr NVARCHAR(500),
		@Program_Title_Cr NVARCHAR(500), @Program_Category_Cr NVARCHAR(500), @Schedule_Item_Log_Date_Cr VARCHAR(500), @Schedule_Item_Log_TIME_Cr VARCHAR(500), 
		@Schedule_Item_Duration_Cr VARCHAR(500), @Scheduled_Version_House_Number_List_Cr VARCHAR(500), @FileCode_Cr INT, @TitleCode_Cr INT, 
		@Found_Status_Cr CHAR(1)

		PRINT 'Before Coursor'
		DECLARE CR_BV_Schedule_Transaction CURSOR
		FOR
			SELECT  BV_Schedule_Transaction_Code, Program_Episode_ID , ISNULL(Program_Episode_Title,''), Program_Episode_Number, Program_Title, Program_Category,
			CONVERT(DATE, Schedule_Item_Log_Date, 103), Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List, Found_Status,
			File_Code, Title_Code
			FROM #BVScheduleTransaction
			WHERE File_Code = @File_Code
			AND ISNULL(IsProcessed, 'N') = 'N'
			AND ISNULL(Found_Status, 'N') = 'Y'
			AND ISNULL(IsException, 'N') = 'N'
		OPEN CR_BV_Schedule_Transaction        
		FETCH NEXT FROM CR_BV_Schedule_Transaction INTO     
		@BV_Schedule_Transaction_Code, @Program_Episode_ID_Cr, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr, @Program_Title_Cr, @Program_Category_Cr,
		@Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr, @Scheduled_Version_House_Number_List_Cr, @Found_Status_Cr,
		@FileCode_Cr, @TitleCode_Cr
		WHILE @@FETCH_STATUS<>-1       
		BEGIN
		PRINT 'In Coursor'
			DECLARE @CanProcessRunCr INT = 0
			SET @IsInvalidChannelRights = 'N'
			BEGIN --Insert Temp_BV_Schedule Data into temporary #DealRunData table
				SET @title_code_HouseID = 0
				SET @Program_Episode_Number_Cr = (CASE WHEN LTRIM(RTRIM(@Program_Episode_Number_Cr)) = '' THEN '1' ELSE ISNULL(@Program_Episode_Number_Cr,'1') END)

				SELECT TOP 1 @title_code_HouseID = tc.Title_Code, @Title_Content_Code = tc.Title_Content_Code FROM Title_Content tc
				WHERE tc.Ref_BMS_Content_Code = @Program_Episode_ID_Cr

				UPDATE #BVScheduleTransaction SET Title_Code = @title_code_HouseID WHERE Program_Episode_ID = @Program_Episode_ID_Cr
          
				PRINT '@title_code_HouseID ' + CAST(@title_code_HouseID AS VARCHAR(100))
				DELETE FROM #DealRunData
				DELETE FROM #DealRightsData
  
				INSERT INTO #DealRightsData ( deal_right_end_date, deal_right_start_date, Deal_Code, 
				Agreement_Date, Title_Code, Deal_Type)
				SELECT  DISTINCT CONVERT(DATETIME, CCR.Rights_End_Date, 101), CONVERT(DATETIME, CCR.Rights_Start_Date, 101), CCR.Acq_Deal_Code, 
					AD.Agreement_Date, CCR.Title_Code, 'A' Deal_Type
				FROM Content_Channel_Run CCR
					INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
					WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND CCR.Title_Code IN (@title_code_HouseID) AND CCR.Title_Content_Code IN(@Title_Content_Code)
					GROUP BY CONVERT(DATETIME, CCR.Rights_End_Date, 101), CONVERT(DATETIME, CCR.Rights_Start_Date, 101), CCR.Acq_Deal_Code
					,AD.Agreement_Date, CCR.Title_Code
				UNION
				SELECT DISTINCT CONVERT(DATETIME, CCR.Rights_End_Date, 101), CONVERT(DATETIME, CCR.Rights_Start_Date, 101), CCR.Provisional_Deal_Code,
					pd.Agreement_Date, CCR.Title_Code, 'P' Deal_Type
				FROM Content_Channel_Run CCR
					INNER JOIN Provisional_Deal pd ON pd.Provisional_Deal_Code = CCR.Provisional_Deal_Code
					WHERE CCR.Title_Code IN (@title_code_HouseID) AND CCR.Title_Content_Code IN(@Title_Content_Code)
					GROUP BY CCR.Provisional_Deal_Code, CCR.Title_Code, pd.Agreement_Date, CCR.Rights_End_Date, CCR.Rights_Start_Date
             
				SELECT @IsInRightPeriod_Cnt = COUNT(*) FROM #DealRightsData drd
					WHERE CONVERT(DATETIME, @Schedule_Item_Log_Date_Cr, 101) BETWEEN CONVERT(DATETIME, drd.deal_right_start_date, 101)
					AND CONVERT(DATETIME, drd.deal_right_end_date, 101)

				SELECT @IsInBlackOutPeriod_Cnt = COUNT(*)
				FROM #DealRightsData drd
				INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = drd.Deal_Code AND drd.Deal_Type = 'A'
					AND (
							(drd.deal_right_start_date BETWEEN ADR.Right_Start_Date AND ADR.Right_End_Date)
							AND
							(drd.deal_right_end_date BETWEEN ADR.Right_Start_Date AND ADR.Right_End_Date)
						)
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				WHERE CONVERT(DATETIME, @Schedule_Item_Log_Date_Cr, 101)
					BETWEEN CONVERT(DATETIME, ADRB.[Start_Date], 101)  AND CONVERT(DATETIME, ADRB.End_Date, 101)
				--===============4.0 Insert Deal Data into #DealRightsData FROM both Acq and Provisional Deal filter===============--      
				--===============4.1 Insert Run Data into #DealRunData FROM Content Channel Run Table===============--      
				INSERT INTO #DealRunData  
				(       
					Deal_Code, Deal_Run_Code, Channel_Code, 
					run_type, run_definition_type, no_of_runs, no_of_runs_sched,      
					no_of_AsRuns, ChannelWise_NoOfRuns, ChannelWise_NoOfRuns_Schedule, ChannelWise_no_of_AsRuns, title_code,  
					RightEndDate, MaxRightEndDate, 
					MaxDealCode, 
					MinDealCode,      
					Deal_Type,  
					IsInRightPerod,  
					Agreement_Date, Content_Channel_Run_Code
				)      
				SELECT ISNULL(CCR.Acq_Deal_Code, Provisional_Deal_Code), ISNULL(Acq_Deal_Run_Code, Provisional_Deal_Run_Code), Channel_Code,      
					Run_Type, Run_Def_Type, SUM(Defined_Runs) OVER (PARTITION BY CCR.Title_Code), SUM(Schedule_Runs) OVER (PARTITION BY CCR.Title_Code),      
					SUM(AsRun_Runs) OVER (PARTITION BY CCR.Title_Code), Defined_Runs, Schedule_Runs, AsRun_Runs, CCR.Title_Code,      
					CAST(Rights_End_Date AS DATETIME) AS deal_right_end_date, MAX(Rights_End_Date) OVER (PARTITION BY CCR.Title_Code) AS MaxRightEndDate,      
					MAX(ISNULL(CCR.Acq_Deal_Code, Provisional_Deal_Code)) OVER (PARTITION BY CCR.Title_Code) AS MaxDealCode,      
					MIN(ISNULL(CCR.Acq_Deal_Code, Provisional_Deal_Code)) OVER (PARTITION BY CCR.Title_Code) AS MinDealCode,
					drd.Deal_Type, CASE WHEN (CONVERT(DATETIME, @Schedule_Item_Log_Date_Cr, 101)
					BETWEEN CONVERT(DATETIME, Rights_Start_Date, 101) AND CONVERT(DATETIME, Rights_End_Date, 101)) THEN 'Y' ELSE 'N' END AS IsInRightPerod,
					drd.Agreement_Date, Content_Channel_Run_Code
				FROM Content_Channel_Run CCR
				INNER JOIN #DealRightsData drd ON ((ccr.Acq_Deal_Code = drd.Deal_Code AND a.Deal_Type = 'A')
						OR (ccr.Provisional_Deal_Code = a.Deal_Code AND a.Deal_Type = 'P'))
				--LEFT JOIN Acq_Deal Acq ON Acq.Acq_Deal_Code = drd.Deal_Code AND drd.Deal_Type = 'A'
				--LEFT JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = drd.Deal_Code AND drd.Deal_Type = 'A'
				--AND (
				--		(drd.deal_right_start_date BETWEEN ADR.Right_Start_Date AND ADR.Right_End_Date)
				--		AND
				--		(drd.deal_right_end_date BETWEEN ADR.Right_Start_Date AND ADR.Right_End_Date)
				--	)
				--LEFT JOIN Provisional_Deal PD ON PD.Provisional_Deal = drd.Deal_Code AND drd.Deal_Type = 'P'
				--LEFT JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = Acq.Acq_Deal_Code
				WHERE CCR.Title_Code IN ( @title_code_HouseID ) AND CCR.Title_Content_Code IN(@Title_Content_Code) AND ISNULL(Is_Archive,'N') = 'N'
				ORDER BY ISNULL(CCR.Acq_Deal_Code, Provisional_Deal_Code), ISNULL(Acq_Deal_Run_Code, Provisional_Deal_Run_Code)
			--===============4.1 Insert Run Data into #DealRunData FROM Content Channel Run Table===============--      
			END       
        
			BEGIN --Validate Invalid Channel Data
			PRINT '--===============START SEND EXCEPTION EMAIL FOR CHANNEL NOT FOUND===============--'  
			SELECT @ChannelCodes_Cnt = COUNT(*) FROM #DealRunData WHERE ISNULL(Channel_Code,0) IN (@Channel_Code)      
              
			IF(@ChannelCodes_Cnt <= 0 AND @IsInRightPeriod_Cnt > 0)      
			BEGIN
				PRINT 'INVALID CHANNEL'           
				SET @IsInvalidChannelRights = 'Y'      
				SET @CanProcessRunCr = 1      
           
				EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
				@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
				@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Invalid_Channel', 'N' , 'Y', NULL, 0, 0
				----Remove this in second phase
				------- Start UPDATE Deal_movie_Code WHEN it is null IN above CASE
				--UPDATE BV_Schedule_Transaction SET Deal_Movie_Code = (SELECT TOP 1 a.ACQ_deal_movie_code FROM #DealRunData a)
				--WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code AND Deal_Movie_Code IS NULL
				----Remove this in second phase
				--UPDATE BV_Schedule_Transaction SET Deal_Movie_Rights_Code = (SELECT TOP 1 a.ACQ_deal_rights_code FROM #DealRunData a)
				--WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code AND Deal_Movie_Rights_Code IS NULL
				------- End
				UPDATE BV_Schedule_Transaction SET Content_Channel_Run_Code = (SELECT TOP 1 a.Content_Channel_Run_Code FROM #DealRunData a)
				WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code AND Content_Channel_Run_Code IS NULL
			END
			PRINT '--===============END SEND EXCEPTION EMAIL FOR CHANNEL NOT FOUND===============--'
			END
         
			BEGIN --===============6.0 Keep only those channel records which will be process now ===============--      
			DELETE FROM #DealRunData WHERE ISNULL(Channel_Code,0) NOT IN (@Channel_Code)      
			END--===============6.0 Keep only those channel records which will be process now ===============--      
         
			BEGIN--===============7.0 Insert Deal Data into #DealRightsData_Final FROM View with second filter (CREATE_FINAL_DEAL_RIGHTS_DATA)===============--      
			DELETE FROM #DealRightsData_Final      
			IF( (SELECT COUNT(*) FROM #DealRunData ) > 0)      
			BEGIN  
				IF(@IsInBlackOutPeriod_Cnt > 0 AND @IsInRightPeriod_Cnt > 0)
				BEGIN
					PRINT 'Its IN BlackOutRight_Period'
					EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
					@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
					@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Blackout_Right_Period', 'Y', 'Y', NULL, 0, 0

					SET @CanProcessRunCr = 1
				END
				PRINT '@IsInRightPeriod_Cnt ' + CAST(@IsInRightPeriod_Cnt AS VARCHAR)      
				IF(@IsInRightPeriod_Cnt > 0)
				BEGIN
					PRINT 'SCHEDULE WITHIN RIGHTS PERIOD'      
            
					INSERT INTO #DealRightsData_Final
					(
						Deal_Code,
						Deal_Run_code,
						ChannelCode, Run_Type, Run_Definition_Type, DoNotConsume, RightPeriodFor, is_yearwise_definition,
						no_of_runs, no_of_runs_sched, no_of_AsRuns,
						ChannelWise_NoOfRuns, ChannelWise_NoOfRuns_Schedule, ChannelWise_no_of_AsRuns,
						title_code, Agreement_Date, MinDealSignedDate, MaxDealSignedDate,
						MaxDealCode, MinDealCode, Content_Channel_Run_Code,
						Deal_Type
					)
					SELECT
						b.Deal_Code,
						b.Deal_Run_Code,
						b.Channel_Code, b.Run_Type, b.Run_Definition_Type, b.DoNotConsume,
						b.RightPeriodFor, b.is_yearwise_definition,
						b.no_of_runs, b.no_of_runs_sched, b.no_of_AsRuns,
						b.ChannelWise_NoOfRuns, b.ChannelWise_NoOfRuns_Schedule,
						b.ChannelWise_no_of_AsRuns, b.title_code, b.Agreement_Date,
						b.MinDealSignedDate, b.MaxDealSignedDate, b.MaxDealCode, b.MinDealCode, b.Content_Channel_Run_Code,
						b.Deal_Type
					FROM       
					(      
						SELECT a.Deal_Code,
						a.Deal_Run_Code,
						a.Channel_Code, a.Run_Type, a.Run_Definition_Type, a.DoNotConsume,
						a.RightPeriodFor , a.is_yearwise_definition,
						ISNULL(a.no_of_runs, 0) AS no_of_runs, ISNULL(a.no_of_runs_sched, 0) AS no_of_runs_sched, ISNULL(a.no_of_AsRuns, 0) AS no_of_AsRuns,
						ISNULL(a.ChannelWise_NoOfRuns, 0) AS ChannelWise_NoOfRuns, ISNULL(a.ChannelWise_NoOfRuns_Schedule, 0) AS ChannelWise_NoOfRuns_Schedule, 
						ISNULL(a.ChannelWise_no_of_AsRuns,0) AS ChannelWise_no_of_AsRuns, a.title_code, a.Agreement_Date AS Agreement_Date,
						MIN(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MinDealSignedDate,
						MAX(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MaxDealSignedDate,
						MAX(a.Deal_Code) OVER (PARTITION BY a.title_code) AS MaxDealCode,
						MIN(a.Deal_Code) OVER (PARTITION BY a.title_code) AS MinDealCode,
						a.Content_Channel_Run_Code,
						a.Deal_Type
						FROM #DealRunData a
						LEFT JOIN Content_Channel_Run ccr ON ((ccr.Acq_Deal_Run_Code = a.Deal_Run_Code AND a.Deal_Type = 'A')
						OR (ccr.Provisional_Deal_Run_Code = a.Deal_Run_Code AND a.Deal_Type = 'A')) AND
						(CONVERT(DATETIME,@Schedule_Item_Log_Date_Cr, 101) BETWEEN  CONVERT(DATETIME,ccr.Rights_Start_Date, 101) AND
						CONVERT(DATETIME,ccr.Rights_End_Date, 101)) AND ISNULL(ccr.Is_Archive,'N') = 'N'
						WHERE 1=1 AND a.IsInRightPerod = 'Y'
					) AS b
					WHERE 1=1
					AND
					((
						(
							(
								( b.no_of_runs > (b.no_of_runs_sched + b.no_of_AsRuns) OR b.Run_Type ='U' )
								OR
								(b.MaxDealSignedDate = b.Agreement_Date)
							)
							AND
							(
								(b.Run_Definition_Type = 'S')
								OR
								(b.Run_Definition_Type= 'N')
							)
						)
						OR
						(
							(
								(b.ChannelWise_NoOfRuns > ( b.ChannelWise_NoOfRuns_Schedule + b.ChannelWise_no_of_AsRuns ) OR b.Run_Type ='U')
								OR
								(b.MaxDealSignedDate = b.Agreement_Date)
							)
							AND
							(
								(b.Run_Definition_Type = 'C' OR b.Run_Definition_Type = 'CS' OR b.Run_Definition_Type= 'A')
								OR
								(b.MaxDealSignedDate = b.Agreement_Date)
							)
						)
					) AND a.Deal_Type = 'A')
					ORDER BY b.Agreement_Date, b.Deal_Code
					--===============7.1 IF FOUND MULTIPLE DEAL WITH SAME DEAL SIGNED DATE THEN USE DEAL_CODE FOR FIFO ORDER --===============      
					DECLARE @MultipleDealFound INT = 0
					SELECT @MultipleDealFound = COUNT(*) FROM
					(
						SELECT Deal_Code FROM #DealRightsData_Final GROUP BY Deal_Code
					) AS z
      
					IF(@MultipleDealFound > 1)
					BEGIN
						DELETE FROM #DealRightsData_Final WHERE NOT EXISTS
						(
						SELECT * FROM #DealRightsData_Final b WHERE 1 = 1
						AND
						(
							(
								(
									(b.no_of_runs > (b.no_of_runs_sched + b.no_of_AsRuns)  OR b.Run_Type = 'U')
									OR
									(b.MaxDealCode = b.Deal_Code)
								)
								AND ((b.Run_Definition_Type = 'S') OR (b.Run_Definition_Type = 'N'))
							)
							OR
							(
								(
									(b.ChannelWise_NoOfRuns > ( b.ChannelWise_NoOfRuns_Schedule + b.ChannelWise_no_of_AsRuns ) OR b.Run_Type = 'U')
									OR
									(b.MaxDealCode = b.Deal_Code)
								)
								AND
								(
									(b.Run_Definition_Type = 'C' OR b.Run_Definition_Type = 'CS' OR b.Run_Definition_Type = 'A')
									OR
									(b.MaxDealCode = b.Deal_Code)
								)
							)
						)
						AND #DealRightsData_Final.Content_Channel_Run_Code = b.Content_Channel_Run_Code
						)
					END      
				--===============7.1 END IF FOUND MULTIPLE DEAL WITH SAME DEAL SIGNED DATE THEN USE DEAL_CODE FOR FIFO ORDER --===============      
            
					SELECT
					TOP 1 @TempMaxDealCode = MAX(a.Deal_Code),
					@TempMinDealCode = MIN(a.Deal_Code),
					@TempMaxDealSignedDate = MAX(a.Agreement_Date),
					@TempMinDealSignedDate = MIN(a.Agreement_Date)
					FROM #DealRightsData_Final a
            
					UPDATE #DealRightsData_Final SET MaxDealCode = @TempMaxDealCode, MinDealCode = @TempMinDealCode,
					MaxDealSignedDate = @TempMaxDealSignedDate, MinDealSignedDate = @TempMinDealSignedDate
				END
				ELSE
				BEGIN--===============7.2 Get Deal data IF schedule out side the rights period ===============--
				PRINT 'SCHEDULE OUT SIDE RIGHTS PERIOD'        
					INSERT INTO #DealRightsData_Final      
					(      
						Deal_Code,
						Deal_Run_code,
						ChannelCode, Run_Type, Run_Definition_Type, DoNotConsume, RightPeriodFor, is_yearwise_definition,
						no_of_runs, no_of_runs_sched, no_of_AsRuns,
						ChannelWise_NoOfRuns, ChannelWise_NoOfRuns_Schedule, ChannelWise_no_of_AsRuns,
						title_code, Agreement_Date, MinDealSignedDate, MaxDealSignedDate,
						MaxDealCode, MinDealCode, Content_Channel_Run_Code
					)
					SELECT a.Acq_Deal_Code,
						a.Deal_Run_Code,
						a.Channel_Code, a.Run_Type, ISNULL(a.Run_Definition_Type,'N'), a.DoNotConsume, a.RightPeriodFor, a.is_yearwise_definition,
						a.no_of_runs, a.no_of_runs_sched, a.no_of_AsRuns,
						a.ChannelWise_NoOfRuns, a.ChannelWise_NoOfRuns_Schedule, a.ChannelWise_no_of_AsRuns,
						a.title_code, a.Agreement_Date,
						MIN(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MinDealSignedDate,
						MAX(a.Agreement_Date) OVER (PARTITION BY a.title_code) AS MaxDealSignedDate,
						MAX(a.Deal_Code) OVER (PARTITION BY a.title_code) AS MaxDealCode,
						MIN(a.Deal_Code) OVER (PARTITION BY a.title_code) AS MinDealCode,
						a.Content_Channel_Run_Code
					FROM #DealRunData a WHERE 1=1
						AND a.IsInRightPerod = 'N' AND a.RightEndDate IN (a.MaxRightEndDate)
					ORDER BY a.Agreement_Date, a.Deal_Code
            
					SELECT
						TOP 1 @TempMaxDealCode = MAX(a.Deal_Code),
						@TempMinDealCode = MIN(a.Deal_Code),
						@TempMaxDealSignedDate = MAX(a.Agreement_Date),
						@TempMinDealSignedDate = MIN(a.Agreement_Date)
					FROM #DealRightsData_Final a
            
					UPDATE #DealRightsData_Final SET MaxDealCode = @TempMaxDealCode, MinDealCode = @TempMinDealCode,
						MaxDealSignedDate = @TempMaxDealSignedDate, MinDealSignedDate = @TempMinDealSignedDate
					--===============7.2 Get Deal data IF schedule out side the rights period ===============--           
					PRINT '--===============7.3 Start send AND exception email IF schedule out side the rights period===============--'
					DECLARE @IsDealFoundCnt INT; SET @IsDealFoundCnt = 0
					SELECT @IsDealFoundCnt = COUNT(*) FROM #DealRightsData_Final
					print '@IsDealFoundCnt - '+ CAST(@IsDealFoundCnt AS VARCHAR)
					IF(@IsDealFoundCnt > 0 )
					BEGIN      
						PRINT 'Right_Period 1'
						EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
						@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
						@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Right_Period', 'Y' ,
						'N', NULL, 0, 0
					END
					ELSE
					BEGIN
					IF(@IsInvalidChannelRights = 'N')
					BEGIN
						PRINT 'Deal_Not_Found'
						EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
						@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
						@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Deal_Not_Found', 'N', 'Y', NULL, 0, 0
					END      
					END
					SET @CanProcessRunCr = 1
					PRINT '--===============7.3 Start send AND exception email IF schedule out side the rights period===============--'
				END
			END      
			ELSE
			BEGIN
				IF(@IsInvalidChannelRights <> 'Y')
				BEGIN
					PRINT 'Right_Period'
					EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
					@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
					@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Right_Period', 'Y', 'N', NULL, 0, 0      
					SET @CanProcessRunCr = 1
				END
			END
			END
         
			IF(@CanProcessRunCr = 0) -- Process RUN data only IF there is no Exception      
			BEGIN --===============8.0 INNER_CURSOR_FOR_UPDATE_SCHEDULE_RUN_IN_FIFO_ORDER ===============--      
				DECLARE @IsMailSent_ForOnePlatform CHAR(1)
				DECLARE @IsMailSent_ForOnePlatform_yearwise CHAR(1) = 'N'
				SET @IsMailSent_ForOnePlatform = 'N'
				--------------- THIS FLAG IS USED TO AVOID SEND SAME EXCEPTION EMAIL ON SAME PLATFORM FOR SAME MOVIE AND SAME DEAL  
				DECLARE @VW_DCode_Cr INT  = 0, @VW_DMCode_Cr INT = 0, @VW_DMRCode_Cr INT = 0, @VW_DMR_Run_Code_Cr INT = 0, @VW_Yearwise_Def_Cr CHAR(1) = 0,
				@VW_Run_Type_Cr CHAR(1), @VW_DealSignedDate_Cr DATETIME, @VW_MinDealSignedDate_Cr DATETIME, @VW_Run_Definition_Type_Cr VARCHAR(10),
				@VW_RightsPeriodFor_Cr VARCHAR(10), @BalanceRun INT = 0, @TempDealCode INT = 0, @VW_CCRCode_Cr INT = 0  
               
				SELECT DISTINCT @VW_DCode_Cr = Deal_Code,
					@VW_DMR_Run_Code_Cr = Deal_run_code, @VW_Yearwise_Def_Cr = is_yearwise_definition, @VW_DealSignedDate_Cr = Agreement_Date,
					@VW_MinDealSignedDate_Cr = MinDealSignedDate, @VW_Run_Definition_Type_Cr = Run_Definition_Type, @VW_RightsPeriodFor_Cr = RightPeriodFor,
					@VW_Run_Type_Cr = Run_Type, @VW_CCRCode_Cr = Content_Channel_Run_Code
				FROM #DealRightsData_Final WHERE ISNULL(DoNotConsume,'N') <> 'Y' AND ChannelCode = @Channel_Code
           
				DECLARE @PrimeStartTime DATETIME, @PrimeEndTime DATETIME, @Time_Lag_Simulcast DATETIME, @OffPrimeStartTime DATETIME, @OffPrimeEndTime DATETIME,
				@Schedule_Item_Log_Date DATETIME, @Todaysdate DATETIME = CONVERT(VARCHAR, GETDATE(), 106), @IsIgnoreUpdateRun CHAR(1) = 'N'
                 
				/*SIMULCAST LOGIC*/
				/*Check Cureent schedule record whether falls IN Prime time OR off prime time IF it is HD Channel*/
				IF((SELECT CASE WHEN ISNULL(MIN(CCR.Deal_Type), 'A') = 'A' THEN COUNT(Ad.Business_Unit_Code) ELSE  COUNT(PD.Business_Unit_Code) END
					FROM Content_Channel_Run CCR
					LEFT JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code AND ISNULL(CCR.Deal_Type, 'A') = 'A' AND CCR.Acq_Deal_Code = @VW_DCode_Cr
					LEFT JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND ISNULL(CCR.Deal_Type, 'A') = 'P'
					AND CCR.Provisional_Deal_Code = @VW_DCode_Cr
					WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ((AD.Business_Unit_Code IN ( SELECT Business_Unit_Code FROM Business_Unit WHERE  Business_Unit_Name LIKE '%English Movies%')
					AND ISNULL(CCR.Deal_Type, 'A') = 'A') OR (PD.Business_Unit_Code IN ( SELECT Business_Unit_Code FROM Business_Unit WHERE  Business_Unit_Name
					LIKE '%English Movies%') AND ISNULL(CCR.Deal_Type, 'A') = 'P')) AND ISNULL(CCR.Is_Archive,'N') = 'N') > 0
					AND
					(
						SELECT COUNT(Channel_Code) FROM Channel WHERE Order_For_schedule > 50 AND Channel_Code = @Channel_Code
					) > 0
				)/* Currently Prime & off Prime simulcast calculation for HD is availalbe for only English movies*/
				BEGIN
					DECLARE @d DATE, @t time,@Channel_Group_code INT
					SELECT @d =  CONVERT(DATE, Schedule_Item_Log_Date), @t = Schedule_Item_Log_Time  FROM BV_Schedule_Transaction
						WHERE BV_Schedule_Transaction_Code =  @BV_Schedule_Transaction_Code

					SELECT @PrimeStartTime = Prime_Start_Time, @Time_Lag_Simulcast = Time_Lag_Simulcast FROM Content_Channel_Run
						WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr AND ISNULL(Is_Archive,'N') = 'N'

					SELECT @PrimeStartTime = ( @d + CAST(@t AS DATETIME) - CAST(@Time_Lag_Simulcast AS DATETIME) )
					SELECT @PrimeEndTime = ( @d + CAST(@t AS DATETIME) + CAST(@Time_Lag_Simulcast AS DATETIME) )
					SELECT @Channel_Group_code = Channel_Group FROM Channel WHERE Channel_Code = @Channel_Code
					IF(
						(
							SELECT COUNT(BV_Schedule_Transaction_code) FROM BV_Schedule_Transaction
							WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr
							AND CAST( (Schedule_Item_Log_Date + ' '+ Schedule_Item_Log_Time) AS DATETIME) BETWEEN @PrimeStartTime AND @PrimeEndTime
							AND IsProcessed = 'Y' AND Channel_Code IN (SELECT ISNULL(Channel_Code,0) FROM Channel WHERE Channel_Code not IN (@Channel_Code)
							AND Channel_Group = @Channel_Group_code)
						) > 0      
					)      
					BEGIN
						/*Need to ignore the UPDATE of runs*/
						SET @IsIgnoreUpdateRun  = 'Y'
						UPDATE BV_Schedule_Transaction SET IsProcessed = 'Y', IsIgnore = 'Y',
						Deal_Type=@Deal_Type, Deal_Code = @VW_DCode_Cr,
						Content_Channel_Run_Code = @VW_CCRCode_Cr
						WHERE File_Code = @File_Code AND BV_Schedule_Transaction_Code =  @BV_Schedule_Transaction_Code
					END
				END
				/*RULE RIGHT CHECK*/      
				IF(
					(
						SELECT COUNT(BV_Schedule_Transaction_Code)  FROM BV_Schedule_Transaction WHERE
						Title_Code = @TitleCode_Cr
						AND ISNULL(IsProcessed, 'N') = 'Y'
						AND ISNULL(IsIgnore, 'N') = 'N'
						AND (CASE WHEN LTRIM(RTRIM(Program_Episode_Number)) = '' THEN '1' ELSE ISNULL(Program_Episode_Number, '1') END) IN (@Program_Episode_Number_Cr)
					) > 0
				)
				BEGIN
					IF(ISNULL(@IsIgnoreUpdateRun, 'N') <> 'Y')
					BEGIN
					PRINT 'Right_Rule'
						EXEC [dbo].[USPIsValidScheduleForRightRule] @BV_Schedule_Transaction_Code, --@VW_DMR_Run_Code_Cr, 
						@Schedule_Item_Log_Date_Cr,
						@Schedule_Item_Log_TIME_Cr, @TitleCode_Cr, --@VW_DMCode_CR,
						@Channel_Code, @Program_Episode_Number_Cr, @VW_CCRCode_Cr
						, @IsIgnoreUpdateRun OUT
					END
				END
			--IF(ISNULL(@IsIgnoreUpdateRun,'N') = 'N')
				BEGIN
					IF( (@VW_DealSignedDate_Cr = @VW_MinDealSignedDate_Cr) AND ((@TempDealCode = 0) OR (@TempDealCode = @VW_DCode_Cr)) )
					------- UPDATE ONLY FIRST DEAL FOR FIFO ORDER
					BEGIN
						SET @TempDealCode = @VW_DCode_Cr
						PRINT '--===============8.1 UPDATE RUNS ===============-- @IncreaseCnt ' +  CAST(@IncreaseCnt AS VARCHAR)
						IF(@VW_Run_Definition_Type_Cr = 'S' OR @VW_Run_Definition_Type_Cr = 'N')
						BEGIN
							UPDATE Content_Channel_Run SET Schedule_Runs =
							CASE WHEN ISNULL(@IsIgnoreUpdateRun,'N') = 'N' THEN ISNULL(Schedule_Runs, 0) + @IncreaseCnt
							ELSE ISNULL(Schedule_Runs, 0) END,
							Schedule_Utilized_Runs = ISNULL(Schedule_Utilized_Runs, 0) + @IncreaseCnt
							WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr
							AND ISNULL(Is_Archive,'N') = 'N' AND Title_Content_Code = @Title_Content_Code
							AND ----------Right Period Validation
							(                                    
								@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(Rights_Start_Date, @Schedule_Item_Log_Date_Cr) AS DATETIME)
								AND CAST(ISNULL(Rights_End_Date,@Schedule_Item_Log_Date_Cr) AS DATETIME)
							)
						END  
						ELSE  
						BEGIN  
							UPDATE Content_Channel_Run SET Schedule_Runs =
							CASE WHEN ISNULL(@IsIgnoreUpdateRun,'N') = 'N' THEN ISNULL(Schedule_Runs, 0) + @IncreaseCnt
							ELSE ISNULL(Schedule_Runs, 0) END,
							Schedule_Utilized_Runs = ISNULL(Schedule_Utilized_Runs, 0) + @IncreaseCnt
							WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND Channel_Code = @Channel_Code AND ISNULL(Is_Archive,'N') = 'N'
							AND Content_Channel_Run_Code =@VW_CCRCode_Cr
						END
						/*PRIME/OFF PRIME UPDATE Run*/
						/*Check Cureent schedule record whether falls IN Prime time OR off prime time */      
						IF(
							(
								SELECT
								CASE WHEN ISNULL(MIN(CCR.Deal_Type), 'A') = 'A' THEN COUNT(Ad.Business_Unit_Code)
								ELSE  COUNT(PD.Business_Unit_Code) END
								FROM Content_Channel_Run CCR
								LEFT JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code AND ISNULL(CCR.Deal_Type, 'A') = 'A' AND CCR.Acq_Deal_Code = @VW_DCode_Cr
								LEFT JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND ISNULL(CCR.Deal_Type, 'A') = 'P'
								AND CCR.Provisional_Deal_Code = @VW_DCode_Cr
								WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ((AD.Business_Unit_Code IN( SELECT Business_Unit_Code FROM Business_Unit WHERE  Business_Unit_Name LIKE '%English Movies%')
								AND ISNULL(CCR.Deal_Type, 'A') = 'A') OR (PD.Business_Unit_Code IN( SELECT Business_Unit_Code FROM Business_Unit WHERE  Business_Unit_Name
								LIKE '%English Movies%') AND ISNULL(CCR.Deal_Type, 'A') = 'P')) AND ISNULL(CCR.Is_Archive,'N') = 'N'
							) > 0
						)/* Currently Prime & off Prime calculation is availalbe for only English movies*/
						BEGIN
							SELECT @Todaysdate= CONVERT(DATETIME, (CONVERT(DATE, GETDATE())  + CAST(Schedule_Item_Log_Time AS DATETIME)),101)
							FROM BV_Schedule_Transaction WHERE BV_Schedule_Transaction_Code =  @BV_Schedule_Transaction_Code
               
							SELECT @Schedule_Item_Log_Date= CONVERT(DATETIME, (CONVERT(DATE, Schedule_Item_Log_Date)  + CAST(Schedule_Item_Log_Time AS DATETIME)),101)
							FROM BV_Schedule_Transaction WHERE BV_Schedule_Transaction_Code =  @BV_Schedule_Transaction_Code
							SELECT TOP 1
								@PrimeStartTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),
								CAST(Prime_Start_Time AS TIME),100)) AS DATETIME)) ,101)
								,@OffPrimeStartTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),
								CAST(OffPrime_Start_Time AS TIME),100)) AS DATETIME)) ,101)
								,@Time_Lag_Simulcast = Time_Lag_Simulcast
								,@PrimeEndTime =CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),
								CAST(Prime_End_Time  AS TIME),100)) AS DATETIME)) ,101)
								,@OffPrimeEndTime =CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),
								CAST(OffPrime_End_Time  AS TIME),100)) AS DATETIME)) ,101)
								FROM Content_Channel_Run  WHERE Acq_Deal_Run_Code = @VW_DMR_Run_Code_Cr AND Channel_Code = @Channel_Code
								AND ISNULL(Is_Archive,'N') = 'N'

							DECLARE @IsPrime CHAR(1) = 'X', @is_exception CHAR(1) = 'N', @ExceptionType CHAR(1) = 'N'

							IF((SELECT DATEDIFF(MI, @PrimeStartTime, @PrimeEndTime )) < 0)
							BEGIN
								SET  @PrimeEndTime =  DATEADD(DAY, 1, CAST(@PrimeEndTime AS DATETIME))
							END
							IF((SELECT DATEDIFF(MI, @OffPrimeStartTime, @OffPrimeEndTime)) < 0)
							BEGIN
								SET  @OffPrimeEndTime =  DATEADD(DAY,1,CAST(@OffPrimeEndTime AS DATETIME))
							END
							ELSE
							BEGIN
								SET @OffPrimeStartTime = DATEADD(DAY, -1, CAST(@OffPrimeStartTime AS DATETIME))
							END
              
							IF(ISNULL(@PrimeStartTime, '') != ''  AND ISNULL(@OffPrimeStartTime, '') != '' )       
							BEGIN
								SET @OffPrimeStartTime = CONVERT(DATETIME,  (CONVERT(DATE, @Schedule_Item_Log_Date) + CAST((SELECT CONVERT(VARCHAR(15),
								CAST('00:00:01.0000000' AS TIME), 100)) AS DATETIME)) ,101)
								IF( CAST(@Schedule_Item_Log_Date  AS DATETIME) BETWEEN CAST(@PrimeStartTime AS DATETIME) AND CAST(@PrimeEndTime AS DATETIME))
								BEGIN
									SET @IsPrime = 'Y'
								END
								ELSE IF(
									CAST(@Schedule_Item_Log_Date AS DATETIME) BETWEEN CAST ( DATEADD(DAY,-1,CAST(@OffPrimeStartTime AS DATETIME)) AS DATETIME)
									AND CAST((@OffPrimeEndTime) AS DATETIME)
								)
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
							ELSE IF(ISNULL(@PrimeStartTime, '') != ''  AND ISNULL(@OffPrimeStartTime, '') = '' )
							BEGIN
								IF( CAST(@Schedule_Item_Log_Date AS DATETIME) NOT BETWEEN CAST( @PrimeStartTime AS DATETIME) AND CAST(@PrimeEndTime AS DATETIME) )
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
								SET @PrimeStartTime = DATEADD(MINUTE, 1, @OffPrimeEndTime)
								SET @PrimeEndTime = DATEADD(MINUTE, -1, @OffPrimeStartTime)
								IF(CAST(@Schedule_Item_Log_Date AS DATETIME)  BETWEEN CAST(@PrimeStartTime AS DATETIME) AND CAST(@PrimeEndTime AS DATETIME) )
								BEGIN
									SET @is_exception = 'Y'
									SET @ExceptionType = 'O'
								END
								ELSE
									SET @IsPrime = 'N'
							END
							PRINT '@IsPrime' + CAST(@IsPrime AS VARCHAR)
							PRINT '@is_exception' + CAST(@is_exception AS VARCHAR)
              
							IF(@IsPrime = 'N' )
							BEGIN
								IF(@VW_Run_Definition_Type_Cr = 'S' OR @VW_Run_Definition_Type_Cr = 'N')
								BEGIN
									UPDATE Content_Channel_Run SET OffPrime_Schedule_Runs =
									CASE WHEN ISNULL(@IsIgnoreUpdateRun,'N') = 'N' THEN  ISNULL(OffPrime_Schedule_Runs,0) + @IncreaseCnt
									ELSE ISNULL(OffPrime_Schedule_Runs,0) END,
									OffPrime_Schedule_Utilized_Runs =  ISNULL(OffPrime_Schedule_Utilized_Runs,0) + @IncreaseCnt
									WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr --AND Channel_Code = @Channel_Code
									AND ISNULL(Is_Archive,'N') = 'N' AND Title_Content_Code = @Title_Content_Code
									--AND Content_Channel_Run_Code =@VW_CCRCode_Cr
									AND ----------Right Period Validation
									(                                    
										@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(Rights_Start_Date, @Schedule_Item_Log_Date_Cr) AS DATETIME)
										AND CAST(ISNULL(Rights_End_Date,@Schedule_Item_Log_Date_Cr) AS DATETIME)
									)
								END
								ELSE  
								BEGIN
									UPDATE Content_Channel_Run SET OffPrime_Schedule_Runs =
									CASE WHEN ISNULL(@IsIgnoreUpdateRun,'N') = 'N' THEN  ISNULL(OffPrime_Schedule_Runs,0) + @IncreaseCnt
									ELSE ISNULL(OffPrime_Schedule_Runs,0) END,
									OffPrime_Schedule_Utilized_Runs =  ISNULL(OffPrime_Schedule_Utilized_Runs,0) + @IncreaseCnt
									WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr AND ISNULL(Is_Archive,'N') = 'N'
								END

								SELECT @BalanceRun = ISNULL(OffPrime_Runs, 0) - ISNULL(OffPrime_Schedule_Runs, 0)
								FROM Content_Channel_Run WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND Channel_Code = @Channel_Code
								AND Content_Channel_Run_Code = @VW_CCRCode_Cr AND ISNULL(Is_Archive,'N') = 'N'
								
								IF(@BalanceRun < 0 AND ISNULL(@IsIgnoreUpdateRun,'N') = 'N')
								BEGIN
									UPDATE Upload_Files SET Err_YN = 'Y'  WHERE  File_Code = @File_Code AND ChannelCode = @Channel_Code
									EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
									@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
									@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'OffPrimeTime_Over_Run', 'Y',
									'Y', 'Y', 0, 0
								END
							END
							ELSE IF(@IsPrime = 'Y' )
							BEGIN
								IF(@VW_Run_Definition_Type_Cr = 'S' OR @VW_Run_Definition_Type_Cr = 'N')
								BEGIN
									UPDATE Content_Channel_Run SET Prime_Schedule_Runs =
									CASE WHEN ISNULL(@IsIgnoreUpdateRun,'N') = 'N' THEN ISNULL(Prime_Schedule_Runs,0) + @IncreaseCnt
									ELSE ISNULL(Prime_Schedule_Runs,0) END,
									Prime_Schedule_Utilized_Runs =  ISNULL(Prime_Schedule_Utilized_Runs,0) + @IncreaseCnt
									WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr --AND Channel_Code = @Channel_Code
									AND ISNULL(Is_Archive,'N') = 'N' AND Title_Content_Code = @Title_Content_Code
									--AND Content_Channel_Run_Code =@VW_CCRCode_Cr
									AND ----------Right Period Validation
									(
										@Schedule_Item_Log_Date_Cr BETWEEN CAST(ISNULL(Rights_Start_Date, @Schedule_Item_Log_Date_Cr) AS DATETIME)
										AND CAST(ISNULL(Rights_End_Date,@Schedule_Item_Log_Date_Cr) AS DATETIME)
									)
								END
								ELSE
								BEGIN
									UPDATE Content_Channel_Run SET Prime_Schedule_Runs =
									CASE WHEN ISNULL(@IsIgnoreUpdateRun,'N') = 'N' THEN ISNULL(Prime_Schedule_Runs,0) + @IncreaseCnt
									ELSE ISNULL(Prime_Schedule_Runs,0) END,
									Prime_Schedule_Utilized_Runs =  ISNULL(Prime_Schedule_Utilized_Runs,0) + @IncreaseCnt
									WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr  AND ISNULL(Is_Archive,'N') = 'N'
								END
  
								SELECT @BalanceRun = ISNULL(Prime_Runs,0) - (ISNULL(Prime_Schedule_Runs, 0))
								FROM Content_Channel_Run WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr  AND ISNULL(Is_Archive,'N') = 'N'

								IF(@BalanceRun < 0 AND ISNULL(@IsIgnoreUpdateRun,'N') = 'N')
								BEGIN
									UPDATE Upload_Files SET Err_YN = 'Y'  WHERE  File_Code = @File_Code AND ChannelCode = @Channel_Code
									EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
									@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
									@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'PrimeTime_Over_Run', 'Y', 'Y', 'Y', 0, 0
								END
							END
      
							IF(@is_exception = 'Y' AND ISNULL(@IsIgnoreUpdateRun,'N') = 'N')
							BEGIN
								DECLARE @Allocated_Runs_P NUMERIC(18, 0) = 0, @Consumed_Runs_P NUMERIC(18, 0) = 0
								IF(@ExceptionType = 'P')
								BEGIN
									SELECT @Allocated_Runs_P = 0, @Consumed_Runs_P = 0
                
									SELECT @Allocated_Runs_P= ISNULL(Prime_Runs, 0) , @Consumed_Runs_P = ISNULL(Prime_Schedule_Runs, 0)
									FROM Content_Channel_Run adr WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr AND ISNULL(Is_Archive,'N') = 'N'
								
									UPDATE Upload_Files SET Err_YN = 'Y'  WHERE  File_Code = @File_Code AND ChannelCode = @Channel_Code
                            
									EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
									@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
									@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Outside Prime Time', 'Y',
									'Y', 'Y', @Allocated_Runs_P, @Consumed_Runs_P
								END
								ELSE IF(@ExceptionType = 'O')
								BEGIN      
									SELECT @Allocated_Runs_P= 0, @Consumed_Runs_P = 0
                 
									SELECT @Allocated_Runs_P= ISNULL(OffPrime_Runs, 0) , @Consumed_Runs_P = ISNULL(OffPrime_Schedule_Runs, 0)
									FROM Content_Channel_Run adr WHERE
									Content_Channel_Run_Code = @VW_CCRCode_Cr AND ISNULL(Is_Archive,'N') = 'N' 
									
									UPDATE Upload_Files SET Err_YN = 'Y'  WHERE  File_Code = @File_Code AND ChannelCode = @Channel_Code      
      
									EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,        
									@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,      
									@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Outside Off Prime Time', 'Y' ,      
									'Y', 'Y', @Allocated_Runs_P, @Consumed_Runs_P      
								END  
								ELSE      
								BEGIN      
								PRINT 'Ignore the shcedule run'      
								END      
							END      
						END      
						/*Check Cureent schedule record whether falls IN Prime time OR off prime time */
						/*PRIME/OFF PRIME UPDATE Run*/      
						--UPDATE ACQ_Deal_Run_Channel SET no_of_runs_sched = ISNULL(no_of_runs_sched,0) + @IncreaseCnt      
						--WHERE ACQ_Deal_Run_code = @VW_DMR_Run_Code_Cr AND channel_code = @Channel_Code      
						PRINT '--===============8.1 UPDATE RUNS ===============--'         
						-- Note:- HERE Content_Channel_Code UPDATE to BV_Schedule_Transaction To show Channel_Wise Report
						IF(@IncreaseCnt > 0)
						BEGIN
							UPDATE BV_Schedule_Transaction SET 
							Content_Channel_Run_Code = @VW_CCRCode_Cr
							WHERE BV_Schedule_Transaction_Code =  @BV_Schedule_Transaction_Code
						END      
      
						DECLARE @Allocated_Runs NUMERIC(18, 0) = 0, @Consumed_Runs NUMERIC(18, 0) = 0   
						PRINT 'NOTE :- /*
						@VW_Run_Definition_Type_Cr
						1. C: Channel Wise     (ChannelWise)
						2. CS: Channel Wise (Min / Max)  (CHANNEL_WISE_SHARED)
						3. A: All Channel - 1 Run / Channel (CHANNEL_WISE_ALL)
						4. S: Shared      (CHANNEL_SHARED)
						5. N: Not Applicable    (CHANNEL_NA)*/'
              
						PRINT '--===============8.3 Send an exception email on OVER_RUN ===============--'
  
						--IF((@VW_Run_Definition_Type_Cr = 'S' OR @VW_Run_Definition_Type_Cr = 'N') AND 
						IF(@IsMailSent_ForOnePlatform = 'N')  
						BEGIN -----START ONLY IF Shared, Not Applicable
							SELECT @Allocated_Runs= 0, @Consumed_Runs = 0
							SELECT @BalanceRun =
							CASE WHEN Run_Type = 'U' THEN 1000 WHEN Run_Type = '' THEN 2000
							ELSE (ISNULL(Defined_Runs,0) - (ISNULL(Schedule_Runs,0))) END
							, @Allocated_Runs = ISNULL(Defined_Runs, 0) , @Consumed_Runs = ISNULL(Schedule_Runs, 0)
							FROM Content_Channel_Run WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr
							/*rk - need to make changes in Content Channel Run table*/
							IF(@BalanceRun < 0)
							BEGIN
								PRINT 'Total_Over_Run'
								SET @IsMailSent_ForOnePlatform = 'Y'
								EXEC USP_Schedule_Email_Notification @BV_Schedule_Transaction_Code, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr,
								@Program_Title_Cr ,@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr,
								@Scheduled_Version_House_Number_List_Cr, @FileCode_Cr, @TitleCode_Cr, @Channel_Code, 'Total_Over_Run', 'Y',
								'Y', NULL, @Allocated_Runs_P, @Consumed_Runs_P
							END
						END-----End ONLY IF Shared, Not Applicable
						PRINT '--===============8.3 Send an exception email on OVER_RUN ===============--'
						PRINT '--===============8.4 Send an exception email on CHANNELWISE_OVER_RUN ===============--'
						DECLARE @ChannelWise_BalanceRun INT; SET @ChannelWise_BalanceRun = 0
						BEGIN
							UPDATE BV_Schedule_Transaction SET IsProcessed = 'Y',IsIgnore = @IsIgnoreUpdateRun
							WHERE File_Code = @File_Code
							AND BV_Schedule_Transaction_Code =  @BV_Schedule_Transaction_Code
						END
					END
				END
			END
			--- MUSIC Schedule Process ---    
			PRINT   '--- MUSIC Schedule Process --- '  
			EXEC USP_Music_Schedule_Process      
				 @TitleCode = 0,       
				 @EpisodeNo = 0,       
				 @BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code,       
				 @MusicScheduleTransactionCode = 0,      
				 @CallFrom= 'SP'      
			--- MUSIC Schedule Process ---      
      
			FETCH NEXT FROM CR_BV_Schedule_Transaction INTO     
			@BV_Schedule_Transaction_Code, @Program_Episode_ID_Cr, @Program_Episode_Title_Cr, @Program_Episode_Number_Cr, @Program_Title_Cr, 
			@Program_Category_Cr, @Schedule_Item_Log_Date_Cr, @Schedule_Item_Log_TIME_Cr, @Schedule_Item_Duration_Cr, @Scheduled_Version_House_Number_List_Cr, 
			@Found_Status_Cr, @FileCode_Cr, @TitleCode_Cr
		END      
		CLOSE CR_BV_Schedule_Transaction
		DEALLOCATE CR_BV_Schedule_Transaction
	END
      
	BEGIN -- Drop temporary tables
		IF OBJECT_ID('tempdb..#DealRunData') IS NOT NULL
		BEGIN
			DROP TABLE #DealRunData
		END      
		IF OBJECT_ID('tempdb..#DealRightsData_Final') IS NOT NULL
		BEGIN
			DROP TABLE #DealRightsData_Final
		END
		IF OBJECT_ID('tempdb..#BVScheduleTransaction') IS NOT NULL
		BEGIN
			DROP TABLE #BVScheduleTransaction
		END
	END
       
	--UPDATE Email_Notification_Schedule
	--SET --Deal_Movie_Code = bv.Deal_Movie_Code,
	----Deal_Movie_Rights_Code = bv.Deal_Movie_Rights_Code,
	--Title_Name = (SELECT Title_Name FROM Title WHERE title_code = CCR.Title_Code),
	--Right_Start_Date = (SELECT MIN(Actual_Right_Start_Date) FROM Acq_Deal_Rights WHERE ACQ_deal_rights_code = bv.Deal_Movie_Rights_Code),
	--Right_End_Date = (SELECT MAX(Actual_Right_End_Date) FROM Acq_Deal_Rights WHERE ACQ_deal_rights_code = bv.Deal_Movie_Rights_Code),      
	--No_of_Runs_Across_beams = (SELECT dbo.UFN_Get_DataFor_RightsUsageReport (bv.Deal_Movie_Code, 'R') AS No_of_Runs_Across_beams),
	--Available_Channels = (SELECT dbo.UFN_Get_DataFor_RightsUsageReport (bv.Deal_Movie_Code, 'CH') AS Available_Channels),
	--Count_Of_Schedule = (SELECT dbo.UFN_Get_DataFor_RightsUsageReport (bv.Deal_Movie_Code, 'PAR') AS Count_Of_Schedule),
	--Channel_Name = (SELECT channel_name AS Channel_Name FROM Channel WHERE channel_code = bv.Channel_Code)
	--FROM Email_Notification_Schedule Email
	--INNER JOIN BV_Schedule_Transaction bv on bv.BV_Schedule_Transaction_Code = Email.BV_Schedule_Transaction_Code
	--INNER JOIN Content_Channel_Run CCR  ON CCR.Content_Channel_Run_Code = bv.Content_Channel_Run_Code
	--WHERE bv.File_Code = @File_Code

	UPDATE Email_Notification_Schedule
	SET 
	Title_Name = (SELECT Title_Name FROM Title WHERE title_code = CCR.Title_Code),
	Right_Start_Date = (SELECT MIN(CCR1.Rights_Start_Date) FROM Content_Channel_Run CCR1 WHERE CCR1.Title_Content_Code = CCR.Title_Content_Code 
	AND ((CCR1.Acq_Deal_Code = CCR.Acq_Deal_Code AND CCR.Deal_Type ='A') OR (CCR1.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND CCR.Deal_Type ='P'))),
	Right_End_Date = (SELECT MAX(CCR2.Rights_End_Date) FROM Content_Channel_Run CCR2 WHERE CCR2.Title_Content_Code = CCR.Title_Content_Code
	AND ((CCR2.Acq_Deal_Code = CCR.Acq_Deal_Code AND CCR.Deal_Type ='A') OR (CCR2.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND CCR.Deal_Type ='P'))),    
	No_of_Runs_Across_beams = 0,--Not in use
	Available_Channels = (
							STUFF
							(
								(
									SELECT DISTINCT ', ' + C.channel_name from Content_Channel_Run CCR1
									INNER JOIN Channel C on C.Channel_Code = CCR1.Channel_Code
									WHERE CCR1.Title_Content_Code = CCR.Title_Content_Code 
									AND ((CCR1.Acq_Deal_Code = CCR.Acq_Deal_Code AND CCR.Deal_Type ='A') 
									OR (CCR1.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND CCR.Deal_Type ='P'))
								FOR XML PATH('')
								),1,1,''
							) 
						),
	Count_Of_Schedule = CCR.Schedule_Runs,
	Channel_Name = (SELECT channel_name AS Channel_Name FROM Channel WHERE channel_code = bv.Channel_Code)
	FROM Email_Notification_Schedule Email
	INNER JOIN BV_Schedule_Transaction bv ON bv.BV_Schedule_Transaction_Code = Email.BV_Schedule_Transaction_Code
	INNER JOIN Content_Channel_Run CCR  ON CCR.Content_Channel_Run_Code = bv.Content_Channel_Run_Code
	WHERE bv.File_Code = @File_Code

	IF OBJECT_ID('tempdb..#BVScheduleTransaction') IS NOT NULL DROP TABLE #BVScheduleTransaction
	IF OBJECT_ID('tempdb..#DealRightsData') IS NOT NULL DROP TABLE #DealRightsData
	IF OBJECT_ID('tempdb..#DealRightsData_Final') IS NOT NULL DROP TABLE #DealRightsData_Final
	IF OBJECT_ID('tempdb..#DealRunData') IS NOT NULL DROP TABLE #DealRunData
	IF OBJECT_ID('tempdb..#tempTitleStartEndDate') IS NOT NULL DROP TABLE #tempTitleStartEndDate
END     
/*     
      
EXEC  [dbo].[USP_Schedule_Process] 15876,13      
    There is already an object named '#DealRightsData' in the database.  
  SELECT * FROM Channel WHERE ISNULL(isUseForAsRun,'N') = 'Y'      
  select * from Email_Notification_Schedule
*/