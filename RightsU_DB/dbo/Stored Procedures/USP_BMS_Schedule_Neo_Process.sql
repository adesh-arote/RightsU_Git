CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Neo_Process]	
(
	@File_Code INT,
	@Channel_Code VARCHAR(10),
	@Deal_Code INT = null,
	@CallFromDealApprove VARCHAR(10) = null,	
	@CanProcessRun INT = 0
)
AS
-- =============================================
-- Author:         <Jaydeep Parmar>
-- Create date:	   <17 Oct 2023>
-- Description:    <USP_BMS_Schedule2_Process 16815,1>
-- =============================================
BEGIN
	--SET NOCOUNT ON;

	IF(@CallFromDealApprove IS NULL)
	BEGIN
		SET @CallFromDealApprove = 'N'
	END

	INSERT INTO ScheduleLog(USPName,File_Code,Channel_Code,IsProcess,BVID,CanProcess,STEPName,StepTime)
	SELECT 'USP_BMS_Schedule2_Process',@File_Code,@Channel_Code,@CallFromDealApprove,0,@CanProcessRun,'STEP 4 Begining of schedule process',GETDATE()

	BEGIN------------------------------------------- GLOBAL VARIBALES -------------------------------------------
		DECLARE @ChannelCodes_Cnt INT;	SET @ChannelCodes_Cnt = 0
		DECLARE @IsInRightPeriod_Cnt INT;	SET @IsInRightPeriod_Cnt = 0
		DECLARE @IsInBlackOutPeriod_Cnt INT;	SET @IsInBlackOutPeriod_Cnt = 0
		DECLARE @title_code_HouseID INT;	SET @title_code_HouseID = 0							--USE FAST FOR OPTIMIZATION 		
		DECLARE @TempMaxDealCode Numeric(18,0)
		DECLARE @TempMinDealCode Numeric(18,0)
		DECLARE @TempMaxDealSignedDate Datetime
		DECLARE @TempMinDealSignedDate Datetime
		DECLARE @EmailMsg NVARCHAR(MAX)
		DECLARE @IsInvalidChannelRights CHAR(1);	SET @IsInvalidChannelRights = 'N'
	END ------------------------------------------- END GLOBAL VARIBALES -------------------------------------------
	
	BEGIN------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
   		IF OBJECT_ID('tempdb..#PtCode_N_TerrCode') IS NOT NULL
		BEGIN
			DROP TABLE #PtCode_N_TerrCode
		END
		IF OBJECT_ID('tempdb..#AcqRightsData') IS NOT NULL
		BEGIN
			DROP TABLE #AcqRightsData
		END
		IF OBJECT_ID('tempdb..#AcqRightsData_Final') IS NOT NULL
		BEGIN
			DROP TABLE #AcqRightsData_Final
		END	
		IF OBJECT_ID('tempdb..#BVScheduleTransaction') IS NOT NULL
		BEGIN
			DROP TABLE #BVScheduleTransaction
		END
		IF OBJECT_ID('tempdb..#Temp_Acq_Channel_YearWise') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Acq_Channel_YearWise
		END		
		IF OBJECT_ID('tempdb..#Temp_RU_FPC_Channel_Codes') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_RU_FPC_Channel_Codes
		END		
	END

	BEGIN ------------------------------------------- CREATE TEMP TABLES -------------------------------------------
		create table #PtCode_N_TerrCode ----- PLTFORMS APPLICABLES FOR  RUNS
		(
			PtCode INT
		)
		CREATE TABLE #Temp_Acq_Channel_YearWise
		(
			 Acq_Deal_Run_Channel_Code INT,
			 Acq_Deal_Run_Yearwise_Run_Code INT
		)
		CREATE TABLE #Temp_RU_FPC_Channel_Codes
		(
			 Channel_Code INT
		)
		DECLARE @RU_FPC_ChannelCodes VARCHAR(100) = '0'		
		SELECT  @RU_FPC_ChannelCodes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'RU_FPC_Channel_Codes'

		IF(ISNULL(@RU_FPC_ChannelCodes,'0') <> '0')
		BEGIN
			INSERT INTO #Temp_RU_FPC_Channel_Codes(Channel_Code)		
			SELECT number FROM fn_Split_withdelemiter(@RU_FPC_ChannelCodes,',')
		END

		INSERT INTO #PtCode_N_TerrCode (PtCode)
		SELECT Platform_Code FROM Platform WHERE ISNULL(applicable_for_asrun_schedule,'N') = 'Y'	
		
		CREATE TABLE #BVScheduleTransaction		----- BV_Schedule_Transaction Data 
		(
			RowNo NUMERIC(18,0),
			BV_Schedule_Transaction_Code NUMERIC(18,0),
			Program_Episode_ID NVARCHAR(1000),
			Program_Episode_Title NVARCHAR(250),
			Program_Episode_Number NVARCHAR(100),
			Program_Title NVARCHAR(250),
			Program_Category NVARCHAR(250),
			Schedule_Item_Log_Date DATETIME, 
			Schedule_Item_Log_Time VARCHAR(50),
			Schedule_Item_Log_DateTime DATETIME,
			Schedule_Item_Duration VARCHAR(100),
			Scheduled_Version_House_Number_List NVARCHAR(100),
			Found_Status CHAR(1),
			File_Code bigint,
			Title_Code NUMERIC(18,0),
			IsProcessed CHAR(1),
			IsException CHAR(1),
			Acq_Deal_Code INT,
			Deal_Count INT DEFAULT(0),
			BMS_Deal_Content_Rights_Code INT,
			Acq_Deal_Run_Code INT,
			BMS_Asset_Code INT,
			IsIgnoreUpdateRun CHAR(1) DEFAULT('N'),
			Business_Unit_Code INT,
			PrimeStartTime DATETIME,
			PrimeEndTime DATETIME,
			OffPrimeStartTime DATETIME,
			OffPrimeEndTime DATETIME,
			IsPrime CHAR(1) DEFAULT('X'),
			Prime_is_exception CHAR(1) DEFAULT('N'),
			Prime_ExceptionType CHAR(1) DEFAULT('N'),
			Schedule_Run INT,
			Allocated_Run INT,
			Balance_Run INT,
			Email_Msg_For NVARCHAR(250),
			Is_Yearwise_Definition CHAR(1),
			Run_Type CHAR(1),
			Run_Definition_Type VARCHAR(10),
			IsExceedingYearWiseDef CHAR(1),
			IsMailSent_ForOnePlatform_yearwise CHAR(1) DEFAULT('N'),
			IsMailSent_ForOnePlatform CHAR(1) DEFAULT('N'),
			Deal_Movie_Code INT,
			IsDealApproved CHAR(1),
			IsInRightsPeriod CHAR(1) DEFAULT('N'),
			IsInvalidChannel CHAR(1) DEFAULT('N'),
			IsRuleRight CHAR(1) DEFAULT('N'),
			Right_Rule_Code INT,
			RR_Start_Time TIME,
			RR_Play_Per_Day INT,
			RR_Duration_Of_Day INT,
			RR_No_Of_Repeat INT,
			RR_Is_First_AIR VARCHAR(10),
			RR_Min_DT_Time DATETIME,
			RR_Max_DT_Time DATETIME,
			RR_Count_Schedule INT DEFAULT(0)
		)
				
		------------------------------------------- END CREATE TEMP TABLES -------------------------------------------
		-----1.0-----
	End

	IF(@CallFromDealApprove = 'N')
	BEGIN

			PRINT '@CallFromDealApprove : '+@CallFromDealApprove
			-----2.0-----
			INSERT INTO #BVScheduleTransaction 
			(
				RowNo,BV_Schedule_Transaction_Code,Program_Episode_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
				Schedule_Item_Log_Date, Schedule_Item_Log_Time,Schedule_Item_Log_DateTime, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
				Found_Status, File_Code, Title_Code, IsProcessed, IsException,IsDealApproved,Deal_Movie_Code,Acq_Deal_Code
			)
			SELECT  ROW_NUMBER() OVER (Partition by Program_Episode_ID ORDER BY CONVERT(datetime,(CONVERT(DATE,Schedule_Item_Log_Date)+CAST(Schedule_Item_Log_Time as datetime)),101) asc),
			BV_Schedule_Transaction_Code,Program_Episode_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category, 
			CONVERT(date, Schedule_Item_Log_Date, 103), Schedule_Item_Log_Time,CONVERT(datetime,(CONVERT(DATE,Schedule_Item_Log_Date)+CAST(Schedule_Item_Log_Time as datetime)),101), Schedule_Item_Duration, Scheduled_Version_House_Number_List, 
			Found_Status, File_Code, Title_Code, IsProcessed, IsException,IsDealApproved,Deal_Movie_Code,Deal_Code
			FROM BV_Schedule_Transaction WHERE File_Code = @File_Code AND ISNULL(IsProcessed,'N') = 'N' AND ISNULL(Found_Status,'N') = 'Y' AND ISNULL(IsException,'N') = 'N'		
			-----2.0-----

	END
	ELSE IF(@CallFromDealApprove = 'Y')
	BEGIN

			INSERT INTO BV_Schedule_Transaction 
			(	
				Program_Episode_Title,Program_Episode_ID,Program_Version_ID, Program_Episode_Number, Program_Title, Program_Category, 
				Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Schedule_Item_Log_DateTime,
				Scheduled_Version_House_Number_List, Found_Status, 
				File_Code, Channel_Code, IsProcessed, Inserted_By, Inserted_On, Title_Code,Deal_Code
			)
			select 
			tbs.Program_Episode_Title,tbs.Program_Episode_ID,tbs.Program_Version_ID, tbs.Program_Episode_Number, tbs.Program_Title, tbs.Program_Category,
			tbs.Schedule_Item_Log_Date, tbs.Schedule_Item_Log_Time, tbs.Schedule_Item_Duration,CONVERT(DATETIME,(CONVERT(DATE,tbs.Schedule_Item_Log_Date)  + CAST(tbs.Schedule_Item_Log_Time AS DATETIME)),101),
			tbs.Scheduled_Version_House_Number_List, 'Y', 
			tbs.File_Code, tbs.Channel_Code, 'N', tbs.Inserted_By , GETDATE(), tbs.TitleCode,@Deal_Code
			from Temp_BV_Schedule tbs 
			WHERE File_Code = @File_Code
			AND ISNULL(tbs.IsDealApproved,'Y') = 'N'
			AND DMCode IN (select ACQ_deal_movie_code FROM ACQ_Deal_Movie WHERE ACQ_deal_code in (@Deal_Code))
			

			DELETE FROM Temp_BV_Schedule 
			WHERE File_Code = @File_Code AND ISNULL(IsDealApproved,'Y') = 'N'
			AND DMCode IN (select ACQ_deal_movie_code FROM ACQ_Deal_Movie WHERE ACQ_deal_code in (@Deal_Code))

			PRINT '---------------------- ONLY FOR REPROCESS ----------------------'
				PRINT '-- NOTE -- While Reprocessing Schedule data do not reprocess that channels data whose AsRun was already excecuted.
				For this we set here BV_Schedule_Transaction set IsProcessed = Y, IsRevertCnt_OnAsRunLoad = Y'
			
				DECLARE @MaxAsRunStartDate Datetime  ---------- get max asrun date
				SET @MaxAsRunStartDate = ''
				SELECT @MaxAsRunStartDate = MAX(StartDate) FROM Upload_Files WHERE Upload_Type = 'A' and Err_YN <> 'N'
				AND ChannelCode = @Channel_Code
			
				UPDATE BV_Schedule_Transaction set IsProcessed = 'Y', IsRevertCnt_OnAsRunLoad = 'Y'
				WHERE CONVERT(DATETIME, Schedule_Item_Log_Date,1) <= @MaxAsRunStartDate
				AND Channel_Code = @Channel_Code AND File_Code = @File_Code
			PRINT '---------------------- END ONLY FOR REPROCESS ----------------------'

			IF OBJECT_ID('tempdb..#tempTitleStartEndDate') IS NOT NULL
			BEGIN
				DROP TABLE #tempTitleStartEndDate
			END

			SELECT DISTINCT BDCR.Acq_Deal_Run_Code, BA.RU_Title_Code as 'Title_Code',BDCR.RU_Channel_Code as 'Channel_Code',
				   MIN(CAST(BDCR.Start_Date AS DATE)) AS Right_Start_Date,MAX(CAST(ISNULL(BDCR.End_Date,'31-DEC-9999') AS DATE)) AS Right_End_Date		
			INTO #tempTitleStartEndDate
			FROM BMS_Deal_Content_Rights BDCR 
			INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code=BDCR.BMS_Deal_Content_Code AND BDC.Is_Active='Y'
			INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code=BDC.BMS_Deal_Code  AND BD.Is_Active='Y'
			INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = @Deal_Code AND ADR.Right_Type != 'M'
			INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code=BDCR.BMS_Asset_Code
			WHERE BD.Acq_Deal_Code = @Deal_Code AND BDCR.RU_Channel_Code= @Channel_Code AND BDCR.Is_Active='Y'
			GROUP BY BA.RU_Title_Code,BDCR.RU_Channel_Code,BDCR.Acq_Deal_Run_Code


			PRINT CAST(@File_Code AS VARCHAR)

			INSERT INTO #BVScheduleTransaction 
			(
				BV_Schedule_Transaction_Code,Program_Episode_ID, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
				Schedule_Item_Log_Date, Schedule_Item_Log_Time,Schedule_Item_Log_DateTime, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
				Found_Status, File_Code, Title_Code, IsProcessed, IsException,Acq_Deal_Code,Deal_Movie_Code
			)
			SELECT  BV_Schedule_Transaction_Code,Program_Episode_ID,Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category, 
			CONVERT(date, Schedule_Item_Log_Date, 103), Schedule_Item_Log_Time,Schedule_Item_Log_DateTime,
			Schedule_Item_Duration, Scheduled_Version_House_Number_List, 
			Found_Status, File_Code, BST.Title_Code, IsProcessed, IsException,@Deal_Code,BST.Deal_Movie_Code
			FROM BV_Schedule_Transaction BST
			INNER JOIN #tempTitleStartEndDate T On BST.Title_Code = T.Title_Code AND BST.File_Code = @File_Code AND ISNUll(BST.IsProcessed,'N') = 'N' AND ISNUll(BST.IsException,'N') = 'N'
			AND ISNUll(BST.Found_Status,'N') = 'Y'
			AND (((Convert(DATE,BST.Schedule_Item_Log_Date,101) BETWEEN T.Right_Start_Date AND T.Right_End_Date) AND BST.Deal_Movie_Code IS NULL)
			OR
			(BST.Deal_Movie_Code IN(select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Acq_Deal_Code = @Deal_Code))
			)
			AND BST.Channel_Code = T.Channel_Code
			AND BST.Channel_Code = @Channel_Code

	END
				
		--select * from #BVScheduleTransaction
		------------Update Title_Code_HouseID----------------------------------------------------
		
		--- ADD BMS_Asset_Code
		UPDATE BVST SET BVST.BMS_Asset_Code=BA.BMS_Asset_Code
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Asset BA ON BA.BMS_Asset_ref_Key collate SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID collate SQL_Latin1_General_CP1_CI_AS	
		
		--UPDATE BVST SET BVST.IsInRightsPeriod = CASE WHEN BVST.Schedule_Item_Log_Date BETWEEN BDCR.[Start_Date] AND BDCR.End_Date 
		--										OR (ADRS.Right_Type = 'U' OR ADRS.Right_Type = 'R' OR ADRS.Right_Type = 'M') THEN 'Y' ELSE 'N' END
		--FROM #BVScheduleTransaction BVST
		--INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Asset_Code = BVST.BMS_Asset_Code AND BDCR.RU_Channel_Code = @Channel_Code AND BDCR.IS_Active='Y'
		--INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = BDCR.BMS_Deal_Content_Code AND BDC.Is_Active ='Y'
		--INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code	AND BD.Is_Active ='Y'	
		--INNER JOIN Acq_Deal_Rights ADRS ON ADRS.Acq_Deal_Code = BD.Acq_Deal_Code

		UPDATE #BVScheduleTransaction SET IsInvalidChannel = CASE WHEN 
		(SELECT COUNT(BV_Schedule_Transaction_Code) FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Asset_Code = BVST.BMS_Asset_Code AND BDCR.RU_Channel_Code = @Channel_Code AND BDCR.IS_Active='Y'
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = BVST.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDCR.Acq_Deal_Run_Code
		WHERE BVST.Schedule_Item_Log_Date BETWEEN BDCR.Start_Date AND BDCR.End_Date ) >0 THEN 'N' ELSE 'Y' END

		UPDATE BVST SET BVST.BMS_Deal_Content_Rights_Code=BDCR.BMS_Deal_Content_Rights_Code,BVST.Acq_Deal_Run_Code = BDCR.Acq_Deal_Run_Code,
		BVST.Business_Unit_Code = AD.Business_Unit_Code,
		BVST.Is_Yearwise_Definition = ADR.Is_Yearwise_Definition,BVST.Run_Type = ADR.Run_Type,BVST.Run_Definition_Type = ADR.Run_Definition_Type,
		BVST.IsRuleRight = CASE WHEN ISNULL(BDCR.RU_Right_Rule_Code,0)>0 THEN 'Y' ELSE 'N' END,
		BVST.Right_Rule_Code = ISNULL(BDCR.RU_Right_Rule_Code,0),BVST.RR_Start_Time = RR.Start_Time,BVST.RR_Play_Per_Day = RR.Play_Per_Day,
		BVST.RR_Duration_Of_Day = RR.Duration_Of_Day,BVST.RR_No_Of_Repeat = RR.No_Of_Repeat,BVST.RR_Is_First_AIR = CASE WHEN ISNULL(RR.IS_First_Air,0)>0 THEN 'Y' ELSE 'N' END
		,BVST.IsInRightsPeriod = CASE WHEN BVST.Schedule_Item_Log_Date BETWEEN BDCR.[Start_Date] AND BDCR.End_Date 
												OR (ADRS.Right_Type = 'U' OR ADRS.Right_Type = 'R' OR ADRS.Right_Type = 'M') THEN 'Y' ELSE 'N' END
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Asset_Code = BVST.BMS_Asset_Code AND BDCR.RU_Channel_Code = @Channel_Code AND BDCR.IS_Active='Y'
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = BVST.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDCR.Acq_Deal_Run_Code		
		LEFT JOIN Right_Rule RR ON BDCR.RU_Right_Rule_Code = RR.Right_Rule_Code
		INNER JOIN Acq_Deal_Rights ADRS ON ADRS.Acq_Deal_Code = BVST.Acq_Deal_Code
		WHERE BVST.Schedule_Item_Log_Date BETWEEN BDCR.Start_Date AND BDCR.End_Date --AND BVST.Deal_Count = 1
		
		UPDATE BVST SET BVST.RowNo = BVdata.RowNum
		FROM #BVScheduleTransaction BVST
		INNER JOIN (
			SELECT BV_Schedule_Transaction_Code, ROW_NUMBER() OVER (Partition by Program_Episode_ID, BMS_Deal_Content_Rights_Code ORDER BY CONVERT(datetime,(CONVERT(DATE,Schedule_Item_Log_Date)+CAST(Schedule_Item_Log_Time as datetime)),101) asc) RowNum
			FROM #BVScheduleTransaction
		) AS BVdata ON BVST.BV_Schedule_Transaction_Code = BVdata.BV_Schedule_Transaction_Code

		--UPDATE BVST SET BVST.Acq_Deal_Code = BD1.Acq_Deal_Code,BVST.BMS_Deal_Content_Rights_Code=BDCR1.BMS_Deal_Content_Rights_Code
		--,BVST.Acq_Deal_Run_Code = BDCR1.Acq_Deal_Run_Code,BVST.Business_Unit_Code = AD.Business_Unit_Code,
		--BVST.Is_Yearwise_Definition = ADR.Is_Yearwise_Definition,BVST.Run_Type = ADR.Run_Type,BVST.Run_Definition_Type = ADR.Run_Definition_Type 
		--FROM #BVScheduleTransaction BVST
		--INNER JOIN (
		--	SELECT MIN(BD.BMS_Deal_Code) BMS_Deal_Code, BVST1.Program_Episode_ID, BVST1.Schedule_Item_Log_Date FROM #BVScheduleTransaction BVST1
		--	INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Asset_Code = BVST1.BMS_Asset_Code AND BDCR.IS_Active='Y'
		--	INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = BDCR.BMS_Deal_Content_Code AND BDC.IS_Active='Y'
		--	INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code AND BD.IS_Active='Y'
		--	WHERE BDCR.RU_Channel_Code = @Channel_Code AND BVST1.Schedule_Item_Log_Date BETWEEN BDCR.Start_Date AND BDCR.End_Date 
		--	AND BVST1.Deal_Count > 1 AND BDCR.Total_Runs > BDCR.Utilised_Run
		--	GROUP BY BVST1.Program_Episode_ID, BVST1.Schedule_Item_Log_Date
		--) AS iq ON iq.Program_Episode_ID = BVST.Program_Episode_ID AND iq.Schedule_Item_Log_Date = BVST.Schedule_Item_Log_Date AND BVST.Deal_Count > 1
		--INNER JOIN BMS_Deal BD1 ON BD1.BMS_Deal_Code = iq.BMS_Deal_Code AND BD1.IS_Active='Y'
		--INNER JOIN BMS_Deal_Content BDC1 ON BDC1.BMS_Deal_Code = iq.BMS_Deal_Code AND BDC1.BMS_Deal_Code = BD1.BMS_Deal_Code AND BDC1.IS_Active='Y'
		--INNER JOIN BMS_Deal_Content_Rights BDCR1 ON BDC1.BMS_Deal_Content_Code = BDCR1.BMS_Deal_Content_Code AND BDCR1.IS_Active='Y'
		--INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = BD1.Acq_Deal_Code
		--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDCR1.Acq_Deal_Run_Code
		--WHERE BDCR1.RU_Channel_Code = @Channel_Code AND BVST.BMS_Asset_Code = BDCR1.BMS_Asset_Code
				

		------------Update Title_Code_HouseID----------------------------------------------------

		------------ SimulCast Calculation ------------------------------------------------------
		Declare @Channel_Group_code int
		select @Channel_Group_code = Channel_Group from Channel where Channel_Code = @Channel_Code


		IF((SELECT COUNT(Channel_Code) FROM Channel WHERE Order_For_schedule > 50 AND Channel_Code = @Channel_Code)>0)
		BEGIN
			UPDATE BV SET BV.IsIgnoreUpdateRun='Y'		
			FROM #BVScheduleTransaction BV
			INNER JOIN (
				SELECT 
					BVST.Schedule_Item_Log_DateTime - cast(ADR.Time_Lag_Simulcast as datetime) as SimulcastStartTime,		
					BVST.Schedule_Item_Log_DateTime + cast(ADR.Time_Lag_Simulcast as datetime) as SimulcastEndTime,BVST.*
				FROM #BVScheduleTransaction BVST				
				INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code=BVST.Acq_Deal_Run_Code
				WHERE BVST.Business_Unit_Code in (select Business_Unit_Code from Business_Unit where  Business_Unit_Name like '%English Movies%')				
			) T ON T.BV_Schedule_Transaction_Code=BV.BV_Schedule_Transaction_Code
			INNER JOIN BV_Schedule_Transaction BVT ON BVT.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS=T.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS AND T.Schedule_Item_Log_DateTime BETWEEN T.SimulcastStartTime AND T.SimulcastEndTime
			AND BVT.IsProcessed = 'Y' AND BVT.Channel_Code in (select isnull(Channel_Code,0) from Channel where Channel_Code not in (@Channel_Code) AND Channel_Group = @Channel_Group_code)
			PRINT 'Simulcast'			
		END

		UPDATE BV SET IsProcessed = 'Y',IsIgnore = 'Y'
		FROM BV_Schedule_Transaction BV  
		INNER JOIN #BVScheduleTransaction BVST ON BVST.BV_Schedule_Transaction_Code=BV.BV_Schedule_Transaction_Code		
		WHERE BV.File_Code = @File_Code AND BVST.IsIgnoreUpdateRun ='Y'

		------------------------------RULE RIGHT CHECK ------------------------------------------------------------

		IF OBJECT_ID('tempdb..#Temp_Min_RightRule') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Min_RightRule
		END

		CREATE TABLE #Temp_Min_RightRule
		(
			 BV_Schedule_Transaction_Code INT
		)

		INSERT INTO #Temp_Min_RightRule(BV_Schedule_Transaction_Code)		
		select Min(BV_Schedule_Transaction_Code) FROM #BVScheduleTransaction Where IsRuleRight='Y' Group by Program_Episode_ID

		DECLARE @BV_Schedule_Transaction_Code_Cr INT

		PRINT 'Before Coursor'
		DECLARE CR_BV_Schedule_Transaction CURSOR
		FOR 
			SELECT BV_Schedule_Transaction_Code 
			FROM #BVScheduleTransaction
			WHERE File_Code = @File_Code
			AND ISNULL(IsProcessed, 'N') = 'N'
			AND ISNULL(Found_Status, 'N') = 'Y'
			AND ISNULL(IsException, 'N') = 'N'
			AND ISNULL(IsRuleRight,'N') = 'Y'
			ORDER BY BV_Schedule_Transaction_Code ASC
		OPEN CR_BV_Schedule_Transaction        
		FETCH NEXT FROM CR_BV_Schedule_Transaction INTO 
		@BV_Schedule_Transaction_Code_Cr
		WHILE @@FETCH_STATUS<>-1 
		BEGIN
			DECLARE @Min_dt_time DATETIME, @Max_dt_Time DATETIME
			DECLARE @Count_schedule INT 

			IF((SELECT COUNT(BV_Schedule_Transaction_Code) FROM #Temp_Min_RightRule WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr) > 0)
			BEGIN
				PRINT 'Process only Min or First Instance of Program Id from DB'

				-- Find Min_Dt_Time for Is_First_AIR ='Y'

				UPDATE BVST SET BVST.RR_Min_DT_Time = (
					SELECT MAX(BV.Schedule_Item_Log_DateTime)
					FROM BV_Schedule_Transaction BV				
					WHERE ISNULL(BV.IsProcessed,'N') ='Y' AND ISNULL(BV.IsIgnore,'N') = 'N' AND BV.Channel_Code IN (@Channel_Code)
					AND BV.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
					AND BV.BV_Schedule_Transaction_Code < BVST.BV_Schedule_Transaction_Code
				)
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.RR_Is_First_AIR ='Y' AND BVST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr

				UPDATE BVST SET BVST.RR_Min_DT_Time = BVST.Schedule_Item_Log_DateTime
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.RR_Is_First_AIR ='Y' AND BVST.RR_Min_DT_Time IS NULL AND BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

				-- Find Min_Dt_Time for Is_First_AIR ='N'

				UPDATE BVST SET BVST.RR_Min_DT_Time = (			
					SELECT TOP 1 CAST(BV.Schedule_Item_Log_Date+' '+CAST(BVST.RR_Start_Time AS VARCHAR(8)) AS DATETIME)
					FROM BV_Schedule_Transaction BV				
					WHERE ISNULL(BV.IsProcessed,'N') ='Y' AND ISNULL(BV.IsIgnore,'N') = 'N' AND BV.Channel_Code IN (@Channel_Code)	
					AND BV.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
					AND BV.BV_Schedule_Transaction_Code < BVST.BV_Schedule_Transaction_Code
					ORDER BY BV.BV_Schedule_Transaction_Code DESC
				)
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.RR_Is_First_AIR ='N' AND BVST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr

				UPDATE BVST SET BVST.RR_Min_DT_Time = CAST(BVST.Schedule_Item_Log_Date+' '+CAST(BVST.RR_Start_Time AS VARCHAR(8)) AS DATETIME)
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.RR_Is_First_AIR ='N' AND BVST.RR_Min_DT_Time IS NULL AND BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr
				
				-- Find Max_Dt_Time for all records

				UPDATE BVST SET BVST.RR_Max_DT_Time = DATEADD(SECOND,-1,DATEADD(HOUR, BVST.RR_Duration_Of_Day, BVST.RR_Min_DT_Time))
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr

				SELECT @Min_dt_time = (BV.RR_Min_DT_Time) FROM #BVScheduleTransaction BV WHERE BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr
				SELECT @Max_dt_Time = (BV.RR_Max_DT_Time) FROM #BVScheduleTransaction BV WHERE BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr
				SET @Count_schedule = 0

				IF((SELECT COUNT(BVST.BV_Schedule_Transaction_Code) 
				FROM BV_Schedule_Transaction BVST
				INNER JOIN #BVScheduleTransaction BV ON BV.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BV.BMS_Deal_Content_Rights_Code
				WHERE ISNULL(BVST.IsProcessed,'N') ='Y' AND ISNULL(BVST.IsIgnore,'N') = 'N' AND BVST.Channel_Code IN (@Channel_Code)
				AND BV.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr
				AND BVST.Schedule_Item_Log_DateTime BETWEEN @Min_dt_time AND @Max_dt_Time) > 0)
				BEGIN					
					IF((SELECT COUNT(BV_Schedule_Transaction_Code) FROM #BVScheduleTransaction BVST
					INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
					WHERE IsRuleRight = 'Y' AND BVST.IsIgnoreUpdateRun='N' AND Schedule_Item_Log_DateTime BETWEEN BVST.RR_Min_DT_Time AND BVST.RR_Max_DT_Time 
					AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr) > 0)
					BEGIN
						PRINT 'BV_Schedule_Transaction : Found Data 1.1'
						UPDATE BVST SET BVST.RR_Count_Schedule = (			
							SELECT COUNT(*)
							FROM BV_Schedule_Transaction BV				
							WHERE ISNULL(BV.IsProcessed,'N') ='Y' AND ISNULL(BV.IsIgnore,'N')='N' AND BV.Channel_Code IN (@Channel_Code)	
							AND BV.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
							AND BV.Schedule_Item_Log_DateTime BETWEEN BVST.RR_Min_DT_Time AND BVST.RR_Max_DT_Time
							AND BV.BV_Schedule_Transaction_Code <= BVST.BV_Schedule_Transaction_Code
						)
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE BVST.IsRuleRight = 'Y' AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

						UPDATE BVST SET IsIgnoreUpdateRun = 'N'
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE IsRuleRight = 'Y' AND (RR_Count_Schedule > (RR_No_Of_Repeat + RR_Play_Per_Day))
						AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

						UPDATE BVST SET IsIgnoreUpdateRun = 'Y'
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE IsRuleRight = 'Y' AND (RR_Count_Schedule <= (RR_No_Of_Repeat + RR_Play_Per_Day))
						AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

					END
					ELSE
					BEGIN
						PRINT 'BV_Schedule_Transaction : Found Data 1.2'
						UPDATE BVST SET IsIgnoreUpdateRun = 'N' 
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE IsRuleRight = 'Y' AND Schedule_Item_Log_DateTime BETWEEN RR_Min_DT_Time AND RR_Max_DT_Time AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

					END
				END
				ELSE
				BEGIN
					PRINT 'BV_Schedule_Transaction : Found Data 2'
					UPDATE BVST SET IsIgnoreUpdateRun = 'N' 
					FROM #BVScheduleTransaction BVST
					INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
					WHERE IsRuleRight = 'Y' AND Schedule_Item_Log_DateTime BETWEEN RR_Min_DT_Time AND RR_Max_DT_Time AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr
					
				END
			END
			ELSE
			BEGIN

				PRINT 'Process Remaining or Repeated Instance of Program Id from #BVScheduleTransaction'

				-- Find Min_Dt_Time for Is_First_AIR ='Y'

				UPDATE BVST SET BVST.RR_Min_DT_Time = (
					SELECT TOP 1 BV.Schedule_Item_Log_DateTime
					FROM #BVScheduleTransaction BV				
					WHERE BV.IsRuleRight = 'Y'
					AND BV.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
					AND BV.BV_Schedule_Transaction_Code < BVST.BV_Schedule_Transaction_Code
					ORder by BV_Schedule_Transaction_Code desc
				)
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.RR_Is_First_AIR ='Y' AND BVST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr


				-- Find Min_Dt_Time for Is_First_AIR ='N'

				UPDATE BVST SET BVST.RR_Min_DT_Time = (
					SELECT TOP 1 CAST(BV.Schedule_Item_Log_Date+' '+CAST(BVST.RR_Start_Time AS VARCHAR(8)) AS DATETIME)
					FROM #BVScheduleTransaction BV				
					WHERE BV.IsRuleRight = 'Y'
					AND BV.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
					AND BV.BV_Schedule_Transaction_Code < BVST.BV_Schedule_Transaction_Code
					ORDER BY BV.BV_Schedule_Transaction_Code DESC
				)
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.RR_Is_First_AIR ='N' AND BVST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr

				UPDATE BVST SET BVST.RR_Min_DT_Time = CAST(BVST.Schedule_Item_Log_Date+' '+CAST(BVST.RR_Start_Time AS VARCHAR(8)) AS DATETIME)
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.RR_Is_First_AIR ='N' AND BVST.RR_Min_DT_Time IS NULL AND BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

				UPDATE BVST SET BVST.RR_Max_DT_Time = DATEADD(SECOND,-1,DATEADD(HOUR, BVST.RR_Duration_Of_Day, BVST.RR_Min_DT_Time))
				FROM #BVScheduleTransaction BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
				WHERE BVST.IsRuleRight = 'Y' AND BVST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code_Cr

				SELECT @Min_dt_time = (BV.RR_Min_DT_Time) FROM #BVScheduleTransaction BV WHERE BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr
				SELECT @Max_dt_Time = (BV.RR_Max_DT_Time) FROM #BVScheduleTransaction BV WHERE BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr
				SET @Count_schedule = 0

				IF((SELECT COUNT(BV.BV_Schedule_Transaction_Code) 
				FROM #BVScheduleTransaction BV
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BV.BMS_Deal_Content_Rights_Code
				WHERE BV.BV_Schedule_Transaction_Code < @BV_Schedule_Transaction_Code_Cr
				AND BV.Schedule_Item_Log_DateTime BETWEEN @Min_dt_time AND @Max_dt_Time AND BV.IsIgnoreUpdateRun='N') > 0)
				BEGIN

					IF((SELECT COUNT(BV_Schedule_Transaction_Code) FROM #BVScheduleTransaction BVST
					INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
					WHERE IsRuleRight = 'Y' AND BVST.IsIgnoreUpdateRun='N' AND Schedule_Item_Log_DateTime BETWEEN RR_Min_DT_Time AND RR_Max_DT_Time AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr) > 0)
					BEGIN
						
						PRINT 'BV_Schedule_Transaction : Found Data 1.1'
						UPDATE BVST SET BVST.RR_Count_Schedule = (			
							SELECT COUNT(*)
							FROM #BVScheduleTransaction BV				
							WHERE BV.IsRuleRight = 'Y' AND BV.IsIgnoreUpdateRun='N'
							AND BV.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS = BVST.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
							AND BV.Schedule_Item_Log_DateTime BETWEEN BVST.RR_Min_DT_Time AND BVST.RR_Max_DT_Time
							AND BV.BV_Schedule_Transaction_Code < BVST.BV_Schedule_Transaction_Code
						)
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE BVST.IsRuleRight = 'Y' AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

						UPDATE BVST SET IsIgnoreUpdateRun = 'N'
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE IsRuleRight = 'Y' AND (RR_Count_Schedule > (RR_No_Of_Repeat + RR_Play_Per_Day))
						AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

						UPDATE BVST SET IsIgnoreUpdateRun = 'Y'
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE IsRuleRight = 'Y' AND (RR_Count_Schedule <= (RR_No_Of_Repeat + RR_Play_Per_Day))
						AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

					END
					ELSE
					BEGIN
						PRINT 'BV_Schedule_Transaction : Found Data 2'
						UPDATE BVST SET IsIgnoreUpdateRun = 'N' 
						FROM #BVScheduleTransaction BVST
						INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
						WHERE IsRuleRight = 'Y' AND Schedule_Item_Log_DateTime NOT BETWEEN RR_Min_DT_Time AND RR_Max_DT_Time AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

					END
				END
				ELSE
				BEGIN
					PRINT 'BV_Schedule_Transaction : Found Data 2'
					UPDATE BVST SET IsIgnoreUpdateRun = 'N' 
					FROM #BVScheduleTransaction BVST
					INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
					WHERE IsRuleRight = 'Y' AND Schedule_Item_Log_DateTime BETWEEN RR_Min_DT_Time AND RR_Max_DT_Time AND BVST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code_Cr

				END

			END

			FETCH NEXT FROM CR_BV_Schedule_Transaction INTO     
			@BV_Schedule_Transaction_Code_Cr
		END
		CLOSE CR_BV_Schedule_Transaction
		DEALLOCATE CR_BV_Schedule_Transaction


		------------------------------RULE RIGHT CHECK ------------------------------------------------------------

		-----SET PrimeStartTime,PrimeEndTime,OffPrimeStartTime,OffPrimeEndTime-------------------START--------------------------------
		PRINT '-----SET PrimeStartTime,PrimeEndTime,OffPrimeStartTime,OffPrimeEndTime------------START---------------------------------------'

		UPDATE BVST 
		SET BVST.PrimeStartTime = CONVERT(DATETIME,(CONVERT(DATE,BVST.Schedule_Item_Log_DateTime) + CAST((SELECT CONVERT(VARCHAR(15),CAST(ADR.Prime_Start_Time AS TIME),100)) AS DATETIME)) ,101),
		BVST.PrimeEndTime = CONVERT(DATETIME,(CONVERT(DATE,BVST.Schedule_Item_Log_DateTime) + CAST((SELECT CONVERT(VARCHAR(15),CAST(ADR.Prime_End_Time AS TIME),100)) AS DATETIME)) ,101),
		BVST.OffPrimeStartTime = CONVERT(DATETIME,(CONVERT(DATE,BVST.Schedule_Item_Log_DateTime) + CAST((SELECT CONVERT(VARCHAR(15),CAST(ADR.Off_Prime_Start_Time AS TIME),100)) AS DATETIME)) ,101),		
		BVST.OffPrimeEndTime = CONVERT(DATETIME,(CONVERT(DATE,BVST.Schedule_Item_Log_DateTime) + CAST((SELECT CONVERT(VARCHAR(15),CAST(ADR.Off_Prime_End_Time AS TIME),100)) AS DATETIME)) ,101)
		FROM #BVScheduleTransaction BVST
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BVST.Acq_Deal_Run_Code
		WHERE BVST.IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		
		UPDATE #BVScheduleTransaction 
			SET PrimeEndTime = CASE WHEN (DATEDIFF(MI,PrimeStartTime,PrimeEndTime )) < 0 THEN DATEADD(DAY,1,CAST(PrimeEndTime AS DATETIME)) ELSE PrimeEndTime END,
			OffPrimeEndTime = CASE WHEN (DATEDIFF(MI,OffPrimeStartTime,OffPrimeEndTime )) < 0 THEN DATEADD(DAY,1,CAST(OffPrimeEndTime AS DATETIME)) ELSE OffPrimeEndTime END, 		
			OffPrimeStartTime = CASE WHEN (DATEDIFF(MI,OffPrimeStartTime,OffPrimeEndTime )) > 0 THEN DATEADD(DAY,-1,CAST(OffPrimeStartTime as datetime)) ELSE OffPrimeStartTime END
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')

		-----SET PrimeStartTime,PrimeEndTime,OffPrimeStartTime,OffPrimeEndTime--------------END-------------------------------------

		PRINT '-----SET PrimeStartTime,PrimeEndTime,OffPrimeStartTime,OffPrimeEndTime------------END---------------------------------------'

		-----SET IsPrime,Prime_is_exception,Prime_ExceptionType----------------START-----------------------------------

		PRINT '-----SET IsPrime,Prime_is_exception,Prime_ExceptionType------------START---------------------------------------'

		-----SET Prime & OffPrime Both Defined--------------------------START-------------------------

		PRINT '-----SET Prime & OffPrime Both Defined--------------------------START-------------------------'

		--SELECT * From #BVScheduleTransaction
		UPDATE #BVScheduleTransaction 			
			SET OffPrimeStartTime = CONVERT(DATETIME,(CONVERT(DATE,Schedule_Item_Log_DateTime) + CAST((SELECT CONVERT(VARCHAR(15),CAST('00:00:01.0000000' AS TIME),100)) AS DATETIME)) ,101)
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND ISNULL(PrimeStartTime,'')<>'' AND ISNULL(OffPrimeStartTime,'')<>''

		UPDATE #BVScheduleTransaction 			
			SET IsPrime = 'N' 
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND ISNULL(PrimeStartTime,'')<>'' AND ISNULL(OffPrimeStartTime,'')<>''
		AND Schedule_Item_Log_DateTime BETWEEN CAST(DATEADD(DAY,-1,OffPrimeStartTime) as datetime) AND OffPrimeEndTime

		--select * from #BVScheduleTransaction

		UPDATE #BVScheduleTransaction 			
			SET IsPrime = 'Y' 
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND ISNULL(PrimeStartTime,'')<>'' AND ISNULL(OffPrimeStartTime,'')<>''
		AND Schedule_Item_Log_DateTime BETWEEN PrimeStartTime AND PrimeEndTime

		UPDATE #BVScheduleTransaction 			
			SET Prime_is_exception = 'Y' ,Prime_ExceptionType='X'
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND ISNULL(PrimeStartTime,'')<>'' AND ISNULL(OffPrimeStartTime,'')<>''
		AND Schedule_Item_Log_DateTime NOT BETWEEN PrimeStartTime AND PrimeEndTime
		AND Schedule_Item_Log_DateTime NOT BETWEEN CAST(DATEADD(DAY,-1,OffPrimeStartTime) as datetime) AND OffPrimeEndTime

		-----SET Prime & OffPrime Both Defined--------------------------END-------------------------

		PRINT '-----SET Prime & OffPrime Both Defined--------------------------END-------------------------'

		-----Only Prime Time Defined--------------------------START-------------------------

		PRINT '-----Only Prime Time Defined--------------------------START-------------------------'

		UPDATE #BVScheduleTransaction 			
			SET Prime_is_exception = CASE WHEN Schedule_Item_Log_DateTime NOT BETWEEN PrimeStartTime AND PrimeEndTime THEN 'Y' ELSE Prime_is_exception END ,
			Prime_ExceptionType = CASE WHEN Schedule_Item_Log_DateTime NOT BETWEEN PrimeStartTime AND PrimeEndTime THEN 'P' ELSE Prime_ExceptionType END ,
			IsPrime = CASE WHEN Schedule_Item_Log_DateTime BETWEEN PrimeStartTime AND PrimeEndTime THEN 'Y' ELSE IsPrime END
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND ISNULL(PrimeStartTime,'')<>'' AND ISNULL(OffPrimeStartTime,'')=''		

		-----Only Prime Time Defined--------------------------END-------------------------

		PRINT '-----Only Prime Time Defined--------------------------END-------------------------'

		-----Only OFF Prime Time Defined--------------------------START-------------------------

		PRINT '-----Only OFF Prime Time Defined--------------------------START-------------------------'

		UPDATE BVST SET BVST.Prime_is_exception = CASE WHEN BVST.Schedule_Item_Log_DateTime BETWEEN T.PrimeStartTime AND T.PrimeEndTime THEN 'Y' ELSE BVST.Prime_is_exception END,
		BVST.Prime_ExceptionType = CASE WHEN BVST.Schedule_Item_Log_DateTime BETWEEN T.PrimeStartTime AND T.PrimeEndTime THEN 'O' ELSE BVST.Prime_ExceptionType END,
		BVST.IsPrime = CASE WHEN Schedule_Item_Log_DateTime NOT BETWEEN T.PrimeStartTime AND T.PrimeEndTime THEN 'N' ELSE BVST.IsPrime END
		FROM #BVScheduleTransaction BVST
		INNER JOIN
		(SELECT PrimeStartTime = DATEADD(MINUTE,1,OffPrimeEndTime),PrimeEndTime = DATEADD(MINUTE,-1,OffPrimeStartTime), BV_Schedule_Transaction_Code
		FROM #BVScheduleTransaction
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND ISNULL(PrimeStartTime,'')='' AND ISNULL(OffPrimeStartTime,'')<>'') T ON T.BV_Schedule_Transaction_Code = BVST.BV_Schedule_Transaction_Code

		-----Only OFF Prime Time Defined--------------------------END-------------------------

		PRINT '-----Only OFF Prime Time Defined--------------------------START-------------------------'


		-----SET IsPrime,Prime_is_exception,Prime_ExceptionType------------------END---------------------------------

		PRINT '-----SET IsPrime,Prime_is_exception,Prime_ExceptionType------------------END---------------------------------'

		-------------------- Update Prime/Off Prime Schedule Count --------------------START----------------------------
		PRINT '-------------------- Update Prime/Off Prime Schedule Count --------------------START----------------------------'

		-------------------- IsPrime = N --------------------START----------------------------

		UPDATE BVST SET BVST.Schedule_Run =ISNULL(ADR.Off_Prime_Time_Provisional_Run_Count,0),BVST.Allocated_Run = ISNULL(ADR.Off_Prime_Run,0),
		BVST.Balance_Run = ISNULL(ADR.Off_Prime_Run,0) - ISNULL(ADR.Off_Prime_Time_Provisional_Run_Count,0) 
		FROM #BVScheduleTransaction BVST
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code=BVST.Acq_Deal_Run_Code
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code AND BDCR.IS_Active='Y'
		WHERE BVST.IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.IsPrime = 'N'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		UPDATE BVST SET BVST.Email_Msg_For = 'OffPrimeTime_Over_Run',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.IsPrime = 'N'
		--AND BVST.Balance_Run < 0
		AND BVST.RowNo > BVST.Balance_Run
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for OffPrimeTime_Over_Run -------------------------------
		INSERT INTO Email_Notification_Schedule 
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
			Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, Allocated_Runs, Consumed_Runs,IsPrimeException
		)
		SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code,
		BVST.Allocated_Run,BVST.Schedule_Run,'Y'
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.IsPrime = 'N'
		--AND BVST.Balance_Run < 0
		AND BVST.Email_Msg_For = 'OffPrimeTime_Over_Run'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		/* Update Off_Prime_Time_Provisional_Run_Count */
		UPDATE ADR SET ADR.Off_Prime_Time_Provisional_Run_Count = ISNULL(ADR.Off_Prime_Time_Provisional_Run_Count,0) + New_Utilised_Run
		FROM (
			SELECT BDCRin.Acq_Deal_Run_Code, COUNT(*) New_Utilised_Run 
			FROM #BVScheduleTransaction BVSTin
			INNER JOIN BMS_Deal_Content_Rights BDCRin ON BDCRin.BMS_Deal_Content_Rights_Code = BVSTin.BMS_Deal_Content_Rights_Code AND BDCRin.Is_Active = 'Y'
			WHERE IsIgnoreUpdateRun='N' AND IsPrime = 'N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
			AND CAST(BVSTin.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCRin.Start_Date AND BDCRin.End_Date		
			GROUP BY BDCRin.Acq_Deal_Run_Code
		) BVST
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BVST.Acq_Deal_Run_Code
		--INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code AND BDCR.IS_Active='Y'
		--WHERE --BVST.IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		--AND BVST.IsPrime = 'N' AND 
		--CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		


		----- Insert Email Notification for OffPrimeTime_Over_Run -------------------------------

		-------------------- IsPrime = N --------------------END----------------------------

		-------------------- IsPrime = Y --------------------START----------------------------

		UPDATE BVST SET BVST.Schedule_Run =ISNULL(ADR.Prime_Time_Provisional_Run_Count,0),BVST.Allocated_Run = ISNULL(ADR.Prime_Run,0),
		BVST.Balance_Run = ISNULL(ADR.Prime_Run,0) - ISNULL(ADR.Prime_Time_Provisional_Run_Count,0) 
		FROM #BVScheduleTransaction BVST
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code=BVST.Acq_Deal_Run_Code
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code AND BDCR.IS_Active='Y'
		WHERE BVST.IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.IsPrime = 'Y'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		UPDATE BVST SET BVST.Email_Msg_For = 'PrimeTime_Over_Run',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.IsPrime = 'Y'
		--AND BVST.Balance_Run < 0
		AND BVST.RowNo > BVST.Balance_Run
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for OffPrimeTime_Over_Run -------------------------------
		INSERT INTO Email_Notification_Schedule 
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
			Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, Allocated_Runs, Consumed_Runs,IsPrimeException
		)
		SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code,
		BVST.Allocated_Run,BVST.Schedule_Run,'Y'
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.IsPrime = 'Y'
		--AND BVST.Balance_Run < 0		
		AND BVST.Email_Msg_For = 'PrimeTime_Over_Run'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		/*Update Prime_Time_Provisional_Run_Count */
		UPDATE ADR SET ADR.Prime_Time_Provisional_Run_Count =ISNULL(ADR.Prime_Time_Provisional_Run_Count,0) + New_Utilised_Run
		FROM (
			SELECT BDCRin.Acq_Deal_Run_Code, COUNT(*) New_Utilised_Run 
			FROM #BVScheduleTransaction BVSTin
			INNER JOIN BMS_Deal_Content_Rights BDCRin ON BDCRin.BMS_Deal_Content_Rights_Code = BVSTin.BMS_Deal_Content_Rights_Code AND BDCRin.Is_Active = 'Y'
			WHERE IsIgnoreUpdateRun='N' AND IsPrime = 'Y' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
			AND CAST(BVSTin.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCRin.Start_Date AND BDCRin.End_Date		
			GROUP BY BDCRin.Acq_Deal_Run_Code

		) BVST
		INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code=BVST.Acq_Deal_Run_Code
		--INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code AND BDCR.IS_Active='Y'
		--WHERE --BVST.IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		--AND BVST.IsPrime = 'Y' AND
		--CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for OffPrimeTime_Over_Run -------------------------------

		-------------------- IsPrime = Y --------------------END----------------------------

		-------------------- Prime_is_exception = Y --------------------START----------------------------

		-------------------- Prime_exceptionType = P --------------------START----------------------------

		UPDATE BVST SET BVST.Email_Msg_For = 'Outside Prime Time',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.Prime_is_exception = 'Y'
		AND BVST.Prime_ExceptionType = 'P'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for Outside Prime Time -------------------------------
		INSERT INTO Email_Notification_Schedule 
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
			Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, Allocated_Runs, Consumed_Runs,IsPrimeException
		)
		SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code,
		BVST.Allocated_Run,BVST.Schedule_Run,'Y'
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.Prime_is_exception = 'Y'
		AND BVST.Prime_ExceptionType = 'P'
		AND BVST.Email_Msg_For = 'Outside Prime Time'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for Outside Prime Time -------------------------------

		-------------------- Prime_exceptionType = P --------------------END----------------------------

		-------------------- Prime_exceptionType = O --------------------START----------------------------

		UPDATE BVST SET BVST.Email_Msg_For = 'Outside Off Prime Time',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.Prime_is_exception = 'Y'
		AND BVST.Prime_ExceptionType = 'O'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for Outside Prime Time -------------------------------
		INSERT INTO Email_Notification_Schedule 
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
			Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, Allocated_Runs, Consumed_Runs,IsPrimeException
		)
		SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code,
		BVST.Allocated_Run,BVST.Schedule_Run,'Y'
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		WHERE IsIgnoreUpdateRun='N' AND Business_Unit_Code IN (SELECT Business_Unit_Code FROM Business_Unit WHERE Business_Unit_Name like '%English Movies%')
		AND BVST.Prime_is_exception = 'Y'
		AND BVST.Prime_ExceptionType = 'O'
		AND BVST.Email_Msg_For = 'Outside Off Prime Time'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for Outside Prime Time -------------------------------

		-------------------- Prime_exceptionType = O --------------------END----------------------------

		-------------------- Prime_is_exception = Y --------------------END----------------------------

		PRINT '-------------------- Update Prime/Off Prime Schedule Count --------------------END----------------------------'
		-------------------- Update Prime/Off Prime Schedule Count --------------------END----------------------------

		------------------------ Year Wise - Channelwise Definition Check -----------------START------------------------------------------

		UPDATE BVST SET BVST.Schedule_Run =ISNULL(BDCR.Utilised_Run,0),BVST.Allocated_Run = ISNULL(BDCR.Total_Runs,0),
		BVST.Balance_Run = CASE WHEN BVST.Run_Type = 'U' THEN 1000 WHEN BVST.Run_Type = '' THEN 2000 ELSE (ISNULL(BDCR.Total_Runs,0) - ISNULL(BDCR.Utilised_Run,0)) END
		FROM #BVScheduleTransaction BVST		
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Is_Yearwise_Definition = 'Y'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		UPDATE BVST SET BVST.Email_Msg_For = 'Yearwise_Channelwise_Over_Run',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Is_Yearwise_Definition = 'Y' AND BVST.Run_Definition_Type = 'C'		
		AND BVST.RowNo > BVST.Balance_Run
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		UPDATE BVST SET BVST.Email_Msg_For = 'Yearwise_Over_Run',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Is_Yearwise_Definition = 'Y' AND BVST.Run_Definition_Type <> 'C'
		AND BVST.RowNo > BVST.Balance_Run
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for Yearwise_Over_Run -------------------------------
		INSERT INTO Email_Notification_Schedule 
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
			Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, Allocated_Runs, Consumed_Runs
		)
		SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code,
		BVST.Allocated_Run,BVST.Schedule_Run
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		WHERE IsIgnoreUpdateRun='N' AND BVST.Is_Yearwise_Definition = 'Y'
		AND BVST.Email_Msg_For IN ('Yearwise_Channelwise_Over_Run','Yearwise_Over_Run')		
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		----- Insert Email Notification for Yearwise_Over_Run -------------------------------

		UPDATE BVST SET BVST.IsMailSent_ForOnePlatform = 'Y'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND BVST.Is_Yearwise_Definition = 'Y'		
		AND BVST.RowNo > BVST.Balance_Run
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date		

		------------------------ Year Wise - Channelwise Definition Check -----------------END------------------------------------------
		
		------------------------------START ONLY IF Shared, Not Applicable -----------------START--------------------------------
		-------===============8.3 Send an exception email on OVER_RUN ===============--


		UPDATE BVST SET BVST.Schedule_Run =ISNULL(BDCR.Utilised_Run,0),BVST.Allocated_Run = ISNULL(BDCR.Total_Runs,0),
		BVST.Balance_Run = CASE WHEN BVST.Run_Type = 'U' THEN 1000 WHEN BVST.Run_Type = '' THEN 2000 ELSE (ISNULL(BDCR.Total_Runs,0) - ISNULL(BDCR.Utilised_Run,0)) END
		FROM #BVScheduleTransaction BVST		
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'S' OR BVST.Run_Definition_Type = 'N')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date

		UPDATE BVST SET BVST.Email_Msg_For = 'Total_Over_Run',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'S' OR BVST.Run_Definition_Type = 'N')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.Balance_Run < 0
		AND BVST.RowNo > BVST.Balance_Run
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date

		INSERT INTO Email_Notification_Schedule 
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
			Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, Allocated_Runs, Consumed_Runs
		)
		SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code,
		BVST.Allocated_Run,BVST.Schedule_Run
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'S' OR BVST.Run_Definition_Type = 'N')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.Balance_Run < 0
		AND BVST.Email_Msg_For = 'Total_Over_Run'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date

		UPDATE BVST SET BVST.IsMailSent_ForOnePlatform = 'Y'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'S' OR BVST.Run_Definition_Type = 'N')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND BVST.Email_Msg_For = 'Total_Over_Run'
		--AND BVST.Balance_Run < 0
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date

		-------===============8.3 Send an exception email on OVER_RUN ===============--

		------------------------------START ONLY IF Shared, Not Applicable -----------------END--------------------------------

		--===============8.4 Send an exception email on CHANNELWISE_OVER_RUN ===============--

		UPDATE BVST SET BVST.Schedule_Run =ISNULL(BDCR.Utilised_Run,0),BVST.Allocated_Run = ISNULL(BDCR.Total_Runs,0),
		BVST.Balance_Run = CASE WHEN BVST.Run_Type = 'U' THEN 1000 WHEN BVST.Run_Type = '' THEN 2000 ELSE (ISNULL(BDCR.Total_Runs,0) - ISNULL(BDCR.Utilised_Run,0)) END
		FROM #BVScheduleTransaction BVST		
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'C' OR BVST.Run_Definition_Type = 'CS' OR BVST.Run_Definition_Type = 'A')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date

		UPDATE BVST SET BVST.Email_Msg_For = 'ChannelWise_Over_Run',BVST.IsException = 'Y',BVST.IsIgnoreUpdateRun = 'N'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'C' OR BVST.Run_Definition_Type = 'CS' OR BVST.Run_Definition_Type = 'A')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.Balance_Run < 0
		AND BVST.RowNo > BVST.Balance_Run
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date

		INSERT INTO Email_Notification_Schedule 
		(
			BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
			Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
			File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
			Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code, Allocated_Runs, Consumed_Runs
		)
		SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code,
		BVST.Allocated_Run,BVST.Schedule_Run
		FROM #BVScheduleTransaction BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code=BVST.BMS_Deal_Content_Rights_Code
		INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'C' OR BVST.Run_Definition_Type = 'CS' OR BVST.Run_Definition_Type = 'A')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.Balance_Run < 0
		AND BVST.Email_Msg_For = 'ChannelWise_Over_Run'
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date

		UPDATE BVST SET BVST.IsMailSent_ForOnePlatform = 'Y'			
		FROM #BVScheduleTransaction BVST 			
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		WHERE IsIgnoreUpdateRun='N' AND (BVST.Run_Definition_Type = 'C' OR BVST.Run_Definition_Type = 'CS' OR BVST.Run_Definition_Type = 'A')
		AND BVST.IsMailSent_ForOnePlatform = 'N'
		AND BVST.Email_Msg_For = 'ChannelWise_Over_Run'
		--AND BVST.Balance_Run < 0
		AND CAST(BVST.Schedule_Item_Log_DateTime AS DATE) BETWEEN BDCR.Start_Date AND BDCR.End_Date


		--select * FROM #BVScheduleTransaction

		--===============8.4 Send an exception email on CHANNELWISE_OVER_RUN ===============--

		--===============8.5 Send an exception email on Schedule outside the right period ===============--

		--UPDATE BVST SET BVST.Email_Msg_For = 'Right_Period',BVST.IsException = 'Y'			
		--FROM #BVScheduleTransaction BVST 					
		--WHERE IsIgnoreUpdateRun='N' 
		--AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.IsInRightsPeriod = 'N'		

		--INSERT INTO Email_Notification_Schedule 
		--(
		--	BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
		--	Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
		--	File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
		--	Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code
		--)
		--SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		--Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code		
		--FROM #BVScheduleTransaction BVST		
		--INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		--WHERE IsIgnoreUpdateRun='N' 
		--AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.IsInRightsPeriod = 'N'		
		--AND BVST.Email_Msg_For = 'Right_Period'

		--UPDATE BVST SET BVST.IsMailSent_ForOnePlatform = 'Y'			
		--FROM #BVScheduleTransaction BVST 					
		--WHERE IsIgnoreUpdateRun='N' 
		--AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.IsInRightsPeriod = 'N'		

		--===============8.5 Send an exception email on Schedule outside the right period ===============--

		--===============8.5 Send an exception email on INVALID_CHANNEL ===============--

		--UPDATE BVST SET BVST.Email_Msg_For = 'Invalid_Channel',BVST.IsException = 'Y'			
		--FROM #BVScheduleTransaction BVST 					
		--WHERE IsIgnoreUpdateRun='N' 
		--AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.IsInvalidChannel = 'Y'	
		--AND BVST.IsInRightsPeriod = 'Y'

		--INSERT INTO Email_Notification_Schedule 
		--(
		--	BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
		--	Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
		--	File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
		--	Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code
		--)
		--SELECT BV_Schedule_Transaction_Code,Program_Episode_Title,Program_Episode_Number,Program_Title,Program_Category,Schedule_Item_Log_Date,Schedule_Item_Log_Time,
		--Schedule_Item_Duration,Scheduled_Version_House_Number_List,File_Code,@Channel_Code,GETDATE(), NULL, NULL,ENM.Email_Msg,'N','Y',BVST.Title_Code		
		--FROM #BVScheduleTransaction BVST		
		--INNER JOIN Email_Notification_Msg ENM ON LTRIM(RTRIM(ENM.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(BVST.Email_Msg_For)) COLLATE SQL_Latin1_General_CP1_CI_AS AND [Type] = 'S'
		--WHERE IsIgnoreUpdateRun='N' 
		--AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.IsInvalidChannel = 'Y'	
		--AND BVST.IsInRightsPeriod = 'Y'
		--AND BVST.Email_Msg_For = 'Invalid_Channel'

		--UPDATE BVST SET BVST.IsMailSent_ForOnePlatform = 'Y'			
		--FROM #BVScheduleTransaction BVST 					
		--WHERE IsIgnoreUpdateRun='N' 
		--AND BVST.IsMailSent_ForOnePlatform = 'N'
		--AND BVST.IsInvalidChannel = 'Y'	
		--AND BVST.IsInRightsPeriod = 'Y'

		--===============8.5 Send an exception email on INVALID_CHANNEL ===============--		

		---------------------- Update Schedule Count for IsIgnoreUpdateRun ='N' ------------------------------------
		
		UPDATE BDCR SET BDCR.Utilised_Run = (ISNULL(BDCR.Utilised_Run,0) + New_Utilised_Run)
		FROM (
			SELECT BMS_Deal_Content_Rights_Code, COUNT(*) New_Utilised_Run 
			FROM #BVScheduleTransaction WHERE IsIgnoreUpdateRun='N'
			GROUP BY BMS_Deal_Content_Rights_Code
		) BVST
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code
		--WHERE BVST.IsIgnoreUpdateRun='N'

		----------------------Update Schedule Count for Non Channel wise Run definition--------------------------------

		--UPDATE BDCR SET BDCR.Utilised_Run = (ISNULL(BDCR.Utilised_Run,0) + BVST.New_Utilised_Run)
		--FROM (
		--	SELECT bvin.Acq_Deal_Run_Code, COUNT(*) New_Utilised_Run 
		--	FROM #BVScheduleTransaction bvin
		--	INNER JOIN BMS_Deal_Content_Rights BDCRin ON BDCRin.Acq_Deal_Run_Code = bvin.Acq_Deal_Run_Code AND BDCRin.Is_Active='Y'
		--	WHERE IsIgnoreUpdateRun='N' AND Run_Definition_Type NOT IN ('C')
		--	AND CAST(bvin.Schedule_Item_Log_DateTime as Date) BETWEEN BDCRin.Start_Date AND BDCRin.End_Date
		--	GROUP BY bvin.Acq_Deal_Run_Code, Schedule_Item_Log_DateTime
		--) BVST
		--INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.Acq_Deal_Run_Code = BVST.Acq_Deal_Run_Code AND BDCR.IS_Active='Y'
		--WHERE BDCR.RU_Channel_Code NOT IN (@Channel_Code)
		
		
		UPDATE BDCR SET BDCR.Utilised_Run = (ISNULL(BDCR.Utilised_Run,0) + BVST.New_Utilised_Run)
		FROM (
			SELECT bvin.Acq_Deal_Run_Code, bvin.Program_Episode_ID, BDCRin.RU_Channel_Code,BDCRin.Start_Date,BDCRin.End_Date, COUNT(*) New_Utilised_Run
			FROM #BVScheduleTransaction bvin
			INNER JOIN BMS_Deal_Content_Rights BDCRin ON BDCRin.Acq_Deal_Run_Code = bvin.Acq_Deal_Run_Code AND bvin.Program_Episode_ID = BDCRin.BMS_Asset_Ref_Key AND BDCRin.Is_Active='Y'
			WHERE IsIgnoreUpdateRun='N' AND Run_Definition_Type NOT IN ('C')
				  AND CAST(bvin.Schedule_Item_Log_DateTime as Date) BETWEEN BDCRin.Start_Date AND BDCRin.End_Date	
			GROUP BY bvin.Acq_Deal_Run_Code,bvin.Program_Episode_ID, BDCRin.RU_Channel_Code,BDCRin.Start_Date,BDCRin.End_Date
		) BVST		
		INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.Acq_Deal_Run_Code = BVST.Acq_Deal_Run_Code
				   AND BDCR.BMS_Asset_Ref_Key = BVST.Program_Episode_ID AND BDCR.RU_Channel_Code = BVST.RU_Channel_Code AND BDCR.IS_Active='Y'
				   AND BDCR.Start_Date=BVST.Start_Date AND BDCR.End_Date=BVST.End_Date
		WHERE BDCR.RU_Channel_Code NOT IN (@Channel_Code)
		
		----------------------Update Schedule Count for Non Channel wise Run definition--------------------------------


		-- Update No_OF_Runs_Sched of Acq_Deal_Run----------------------

		UPDATE ADR SET ADR.No_Of_Runs_Sched = T2.Run_Count		
		FROM Acq_Deal_Run ADR
		INNER JOIN
		(
			SELECT SUM(Run_Count) Run_Count,Acq_Deal_Run_Code
			FROM (
				SELECT MAX(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
				FROM #BVScheduleTransaction bst 
				INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
				--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type <> 'C'
				WHERE bst.IsIgnoreUpdateRun='N' AND bst.Run_Definition_Type <> 'C'
				GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
			) T1 Group by Acq_Deal_Run_Code
		) T2 ON T2.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code

		UPDATE ADR SET ADR.No_Of_Runs_Sched = T2.Run_Count
		FROM Acq_Deal_Run ADR
		INNER JOIN
		(
			SELECT SUM(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code
			--SELECT MAX(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code
			FROM #BVScheduleTransaction bst 
			INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
			--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type = 'C'
			WHERE bst.IsIgnoreUpdateRun='N' AND bst.Run_Definition_Type = 'C'
			GROUP BY BDRC.Acq_Deal_Run_Code
		) T2 ON T2.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code

		-- Update No_OF_Runs_Sched of Acq_Deal_Run_Channel----------------------

		UPDATE ADRC SET ADRC.No_Of_Runs_Sched = T2.Run_Count
		FROM Acq_Deal_Run_Channel ADRC
		INNER JOIN
		(
			SELECT SUM(Run_Count) Run_Count,Acq_Deal_Run_Code,RU_Channel_Code
			FROM (
				SELECT MAX(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,BDRC.RU_Channel_Code,BDRC.Start_Date,BDRC.End_Date
				FROM #BVScheduleTransaction bst 
				INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
				--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type <> 'C'
				WHERE bst.IsIgnoreUpdateRun='N' AND bst.Run_Definition_Type <> 'C'
				GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Acq_Deal_Run_Code,BDRC.RU_Channel_Code,BDRC.Start_Date,BDRC.End_Date
			) T1 Group by Acq_Deal_Run_Code,RU_Channel_Code
		) T2 ON T2.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code AND T2.RU_Channel_Code = ADRC.Channel_Code

		UPDATE ADRC SET ADRC.No_Of_Runs_Sched = T2.Run_Count
		FROM Acq_Deal_Run_Channel ADRC
		INNER JOIN
		(
			SELECT SUM(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,RU_Channel_Code
			--SELECT MAX(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,RU_Channel_Code
			FROM #BVScheduleTransaction bst 
			INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
			--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type = 'C'
			WHERE bst.IsIgnoreUpdateRun='N' AND bst.Run_Definition_Type = 'C'
			GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.RU_Channel_Code
		) T2 ON T2.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code AND T2.RU_Channel_Code = ADRC.Channel_Code		

		-- Update No_OF_Runs_Sched of Acq_Deal_Run_Yearwise_Run----------------------

		UPDATE ADRY SET ADRY.No_Of_Runs_Sched = T2.Run_Count
		FROM Acq_Deal_Run_Yearwise_Run ADRY
		INNER JOIN
		(
			SELECT SUM(Run_Count) Run_Count,Acq_Deal_Run_Code,Start_Date,End_Date
			FROM (
				SELECT MAX(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,BDRC.RU_Channel_Code,BDRC.Start_Date,BDRC.End_Date
				FROM #BVScheduleTransaction bst 
				INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
				--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type <> 'C'
				WHERE bst.IsIgnoreUpdateRun='N' AND bst.Run_Definition_Type <> 'C'
				GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Acq_Deal_Run_Code,BDRC.RU_Channel_Code,BDRC.Start_Date,BDRC.End_Date
			) T1 Group by Acq_Deal_Run_Code,Start_Date,End_Date
		)T2 ON T2.Acq_Deal_Run_Code = ADRY.Acq_Deal_Run_Code AND T2.Start_Date = ADRY.Start_Date AND T2.End_Date = ADRY.End_Date

		UPDATE ADRY SET ADRY.No_Of_Runs_Sched = T2.Run_Count
		FROM Acq_Deal_Run_Yearwise_Run ADRY
		INNER JOIN
		(
			SELECT SUM(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
			--SELECT MAX(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
			FROM #BVScheduleTransaction bst 
			INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
			--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type = 'C'
			WHERE bst.IsIgnoreUpdateRun='N' AND bst.Run_Definition_Type = 'C'
			GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
		)T2 ON T2.Acq_Deal_Run_Code = ADRY.Acq_Deal_Run_Code AND T2.Start_Date = ADRY.Start_Date AND T2.End_Date = ADRY.End_Date


		UPDATE BV SET BV.IsProcessed = 'Y',IsIgnore = BVST.IsIgnoreUpdateRun,BV.IsException = CASE WHEN BVST.IsException = 'Y' THEN 'Y' ELSE BV.IsException END,
		BV.IsPrime = BVST.IsPrime,BV.BMS_Deal_Content_Rights_Code = BVST.BMS_Deal_Content_Rights_Code,BV.Acq_Deal_Run_Code = BVST.Acq_Deal_Run_Code
		FROM BV_Schedule_Transaction BV 			
		INNER JOIN #BVScheduleTransaction BVST ON BVST.BV_Schedule_Transaction_Code = BV.BV_Schedule_Transaction_Code		

		UPDATE UF SET UF.Err_YN = 'Y'			
		FROM Upload_Files UF 			
		INNER JOIN #BVScheduleTransaction BVST ON BVST.File_Code = UF.File_Code
		WHERE UF.ChannelCode = @Channel_Code AND BVST.IsException = 'Y'

		---------------------- Update Schedule Count for IsIgnoreUpdateRun ='N' ------------------------------------
		

	--SELECT * From #BVScheduleTransaction
	
END