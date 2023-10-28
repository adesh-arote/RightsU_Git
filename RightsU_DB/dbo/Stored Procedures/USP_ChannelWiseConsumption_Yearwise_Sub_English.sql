CREATE PROCEDURE [dbo].[USP_ChannelWiseConsumption_Yearwise_Sub_English]
(
	@Title_Content_Code INT,
	@Deal_Code INT,
	@Deal_Type CHAR(1),
	@ChannelCode VARCHAR(MAX),
	@AllYears CHAR(1)='N',
	@IsDisplay_Date CHAR(1) ='N',
	@PrimeOrYearWise CHAR(1) ='Y',
	@dBug CHAR(1)='N'
)
AS
-- =============================================
-- Author: Pavitar Dua & Bhavesh Desai
-- Create date: 30-Dec-2014
-- Description:	This SP used for ChannelWise Yearwise Prime/OffPrime wise Consumption Reports
 --EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English] '96','24','Y','N','Y','N'
 --EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English] '96','','Y','Y','P','N'
-- EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English] '3','','Y','Y','P','N'
-- Updated By : Anchal Sikarwar
-- Updated On : 04 June 2018
-- =============================================
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_ChannelWiseConsumption_Yearwise_Sub_English]', 'Step 1', 0, 'Started Procedure', 0, ''

		--DECLARE @Title_Content_Code INT = 20508,
		-- @Deal_Code INT = 15112,
		-- @Deal_Type CHAR(1) = 'A',
		-- @ChannelCode VARCHAR(MAX) = '1,3',
		-- @AllYears CHAR(1)='N',
		-- @IsDisplay_Date CHAR(1) ='N',
		-- @PrimeOrYearWise CHAR(1) ='Y',
		-- @dBug CHAR(1)='N'
		SET NOCOUNT ON;

		IF OBJECT_ID('TEMPDB..#Temp') IS NOT NULL
		BEGIN
			DROP TABLE #Temp
		END
		IF OBJECT_ID('TEMPDB..#TempHD') IS NOT NULL
		BEGIN
			DROP TABLE #TempHD
		END

		--DECLARE @ChannelCode CHAR(50)='24,25',@DealMovieCode INT=2577,@Start_Date DATETIME,@End_Date DATETIME
		DECLARE @Today DATETIME=CONVERT(DATE,GETDATE(),103)

		SELECT DISTINCT CCR.Acq_Deal_Run_Code AS Acq_Deal_Run_Code, CCR.Rights_Start_Date AS Start_Date, CCR.Rights_End_Date AS End_Date, CCR.Channel_Code AS channel_Code,
		CCR.Defined_Runs As Total_runs /*Sum*/,
		CCR.Defined_Runs As No_Of_Runs, 
		(
			SELECT COUNT(*) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE BV.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND
			CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
			> @Today AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
		) AS Provision_BV_Transaction,
		(
			SELECT COUNT(*) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE BV.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND 
			CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
			<= @Today AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
		) AS Consume, 
		(CCR.Defined_Runs - CCR.Schedule_Runs) Balance, 
		CCR.Prime_Runs AS Total_Prime_Runs, 
		CCR.Prime_Runs Prime_No_Of_Runs, 
			(
				SELECT COUNT(BV.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE 
				CONVERT(DATETIME, CONVERT(CHAR(12), BV.Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), BV.Schedule_Item_Log_Time, 108), 103)
				> @Today
				AND	CAST(BV.Schedule_Item_Log_Time AS TIME) BETWEEN CCR.Prime_Start_Time and CCR.Prime_End_Time 
				AND	CCR.Content_Channel_Run_Code = BV.Content_Channel_Run_Code AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
			)
			AS
		Prime_Provision_BV_Transaction, 
		(	
			SELECT COUNT(BV.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE 
			CONVERT(DATETIME, CONVERT(CHAR(12), BV.Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), BV.Schedule_Item_Log_Time, 108), 103)
			<= @Today 
			AND	CAST(BV.Schedule_Item_Log_Time AS TIME) BETWEEN CCR.Prime_Start_Time and CCR.Prime_End_Time 
			AND	CCR.Content_Channel_Run_Code = BV.Content_Channel_Run_Code AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
		)
		AS
		Prime_Consume, 
		(CCR.Prime_Runs - CCR.Prime_Schedule_Runs) AS Prime_Time_Balance_Count, 
		CCR.OffPrime_Runs AS Total_Off_Prime_Runs, 
		CCR.OffPrime_Runs AS Off_Prime_No_Of_Runs,
		(	
			SELECT COUNT(BV.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE 
			CONVERT(DATETIME, CONVERT(CHAR(12), BV.Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), BV.Schedule_Item_Log_Time, 108), 103)
			> @Today
			AND	CAST(BV.Schedule_Item_Log_Time AS TIME) BETWEEN CCR.OffPrime_Start_Time AND CCR.OffPrime_End_Time 
			AND	CCR.Content_Channel_Run_Code = BV.Content_Channel_Run_Code AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
		)
		AS
		Off_Prime_Provision_BV_Transaction,
		(	
			SELECT COUNT(BV.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE 
			CONVERT(DATETIME, CONVERT(CHAR(12), BV.Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), BV.Schedule_Item_Log_Time, 108), 103)
			<= @Today
			AND	CAST(BV.Schedule_Item_Log_Time AS Time) between CCR.OffPrime_Start_Time and CCR.OffPrime_End_Time 
			AND	CCR.Content_Channel_Run_Code = BV.Content_Channel_Run_Code AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
		)
		AS
		Off_Prime_Consume,
		ISNULL(CCR.OffPrime_Runs, 0) - ISNULL(CCR.OffPrime_Schedule_Runs,0)
		Off_Prime_Time_Balance_Count
		INTO #Temp
		FROM Content_Channel_Run CCR (NOLOCK)
		INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Content_Code = CCR.Title_Content_Code AND CCR.Title_Content_Code = @Title_Content_Code
		AND ((@Deal_Type ='A' AND CCR.Acq_Deal_Code = @Deal_Code) OR (@Deal_Type ='P' AND CCR.Provisional_Deal_Code = @Deal_Code))
		AND CCR.Deal_Type = @Deal_Type
		LEFT JOIN Right_Rule RR (NOLOCK) on RR.Right_Rule_Code = CCR.Right_Rule_Code 
		Where ISNULL(CCR.Is_Archive, 'N') = 'N' AND ((@AllYears = 'N' AND GETDATE() BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date) OR (@AllYears = 'Y') )
		AND ((@AllYears = 'N' AND GETDATE() BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date )  OR (@AllYears = 'Y') )
		ORDER BY CCR.Channel_Code

		Update T SET T.Total_runs = ADR.No_Of_Runs, T.Total_Prime_Runs = ISNULL(ADR.Prime_Run, 0), T.Total_Off_Prime_Runs = ISNULL(ADR.Off_Prime_Run, 0)
		FROM  #Temp T INNER JOIN Acq_Deal_Run ADR ON T.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND @Deal_Type = 'A'

			--UPDATE #Temp SET No_Of_Runs = Provision_BV_Transaction  WHERE Provision_BV_Transaction > 0 AND No_Of_Runs<=0  -- TO BE DONE THRU UI
			--UPDATE #Temp SET Prime_No_Of_Runs= isnull(No_Of_Runs,0) WHERE Prime_Provision_BV_Transaction > 0 AND Prime_No_Of_Runs<=0
			--UPDATE #Temp SET off_Prime_No_Of_Runs= isnull(No_Of_Runs,0) WHERE Off_Prime_Provision_BV_Transaction > 0 AND Off_Prime_No_Of_Runs<=0

			--SELECT No_Of_Runs,Start_Date,Channel_Code INTO #TEMPHD FROM #Temp WHERE Channel_Code=
			--(SELECT TOP 1 Channel_Code FROM Channel WHERE Channel_Group=1 ORDER BY Order_For_schedule DESC)



			/*
				Is_Beam_HD
				Is_Parent_Child
				Parent_Code

				1-Pixindia P S -
				2-Pix  HD  C H 1 
				3-PIXUS    C B 1
				4-PIXUSHD  C H 3
			*/

	--UPDATE T SET T.No_Of_Runs = T.No_Of_Runs - THD.No_Of_Runs, T.Off_Prime_No_Of_Runs = T.Off_Prime_No_Of_Runs - THD.No_Of_Runs
	--FROM #Temp T
	--INNER JOIN #TEMPHD  THD ON T.Channel_Code<>THD.Channel_Code AND T.Start_Date=THD.Start_Date
	--AND T.Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) 
	--UPDATE #Temp SET off_Prime_No_Of_Runs=off_Prime_Provision_BV_Transaction WHERE Off_Prime_Time_Balance_Count < 0
	
		UPDATE #Temp SET
		BALANCE = No_Of_Runs - (Provision_BV_Transaction + Consume)
		,Prime_Time_Balance_Count = Prime_No_Of_Runs - (Prime_Provision_BV_Transaction + Prime_Consume)
		,Off_Prime_Time_Balance_Count = Off_Prime_No_Of_Runs - (off_Prime_Provision_BV_Transaction + Off_Prime_Consume)

		IF(@dBug='D') 
		BEGIN
			SELECT * FROM #Temp
			select * from #Temp T where T.Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,','))
		END

		IF(@PrimeOrYearWise='Y')
		BEGIN
			SELECT 
			CONVERT(VARCHAR(25), Start_Date,106) YearWise_Start_Date,
			CONVERT(VARCHAR(25), End_Date, 106) AS YearWise_End_Date,
			SUM(No_Of_Runs) AS No_Of_Runs,
			SUM(Provision_BV_Transaction) AS Provision,
			SUM(Consume) Consume,SUM(Balance) AS Balance,
			CASE WHEN (GETDATE() BETWEEN CONVERT(VARCHAR(25), Start_Date,106) AND CONVERT(VARCHAR(25), End_Date,106))
				 THEN 'Y' ELSE 'N' END isCurrentYear
			FROM #Temp
			WHERE (( @ChannelCode <>'' AND Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) 
			OR @ChannelCode ='' ) AND Start_Date <> '' AND End_Date <> ''
			AND ((  @AllYears = 'N' AND GETDATE() BETWEEN Start_Date AND End_Date )  OR (@AllYears = 'Y') )
			GROUP BY CONVERT(VARCHAR(25), Start_Date,106),CONVERT(VARCHAR(25), End_Date,106)
		END

		IF(@PrimeOrYearWise = 'P')
		BEGIN
			IF NOT EXISTS(SELECT * FROM #Temp T WHERE T.Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')))
			BEGIN
				SELECT * FROM
				(
					SELECT 'Prime Time Runs' Description
							,@ChannelCode AS Channel_Code
							,(SELECT  CHANNEL_NAME FROM CHANNEL C (NOLOCK) WHERE C.Channel_Code = @ChannelCode) CHANNEL_NAME
							,0 Prime_No_Of_Runs
							,0 Prime_Provision
							,0 Prime_Consume
							,0 Prime_Balance 
					UNION
					SELECT 'Off Prime Time Runs'
							,@ChannelCode AS Channel_Code
							,(SELECT  CHANNEL_NAME FROM CHANNEL C (NOLOCK) WHERE C.Channel_Code = @ChannelCode) CHANNEL_NAME
							,0 Off_Prime_No_Of_Runs
							,0 Off_Prime_Provision
							,0 Off_Prime_Consume
							,0 Off_Prime_Balance 
			
				) A
				ORDER BY A.Description DESC
				RETURN


			END
	
			SELECT * FROM
				(
					SELECT 'Prime Time Runs' Description, Channel_Code,
							CHANNEL_NAME,
							ISNULL(MIN(Prime_No_Of_Runs), 0) Prime_No_Of_Runs
							,SUM(Prime_Provision_BV_Transaction) Prime_Provision
							,SUM(Prime_Consume) Prime_Consume
							,MIN(Prime_No_Of_Runs) - SUM(Prime_Provision_BV_Transaction) Prime_Balance  
					FROM (
					SELECT DISTINCT Channel_Code,
							(SELECT  CHANNEL_NAME FROM CHANNEL C (NOLOCK) WHERE C.Channel_Code = T.Channel_Code) CHANNEL_NAME,
							isnull(Prime_No_Of_Runs,0)  AS Prime_No_Of_Runs 
							,Prime_Provision_BV_Transaction 
							,Prime_Consume
							,Prime_Time_Balance_Count
					FROM #Temp T WHERE 1=1
					--AND Provision_BV_Transaction>0 
					AND ((@ChannelCode <>'' AND Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) or @ChannelCode ='' )
					) AS tmpPrime 
					GROUP BY tmpPrime.Channel_Code, tmpPrime.CHANNEL_NAME
					UNION
						SELECT 'Off Prime Time Runs', Channel_Code, 	
							CHANNEL_NAME,
							MIN(off_Prime_No_Of_Runs) Off_Prime_No_Of_Runs
							,SUM(Off_Prime_Provision_BV_Transaction) Off_Prime_Provision
							,SUM(Off_Prime_Consume) Off_Prime_Consume
							,MIN(off_Prime_No_Of_Runs) - SUM(Off_Prime_Provision_BV_Transaction) Off_Prime_Balance 
					FROM (
						SELECT DISTINCT Channel_Code, 	
							(SELECT  CHANNEL_NAME FROM CHANNEL C (NOLOCK) WHERE C.Channel_Code = T.Channel_Code) CHANNEL_NAME,
							off_Prime_No_Of_Runs
							,Off_Prime_Provision_BV_Transaction
							,Off_Prime_Consume
							,Off_Prime_Time_Balance_Count
					FROM #Temp T 
					WHERE 1=1 
					--AND Provision_BV_Transaction>0 
					AND ((@ChannelCode <> '' AND Channel_Code in (SELECT NUMBER FROM dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) OR @ChannelCode ='' )
					AND ((@AllYears = 'N' AND GETDATE() BETWEEN Start_Date AND End_Date )  OR (@AllYears = 'Y') )
					) AS tmpOffPrime 
					GROUP BY tmpOffPrime.Channel_Code, tmpOffPrime.CHANNEL_NAME
			
				) A
			 ORDER BY A.Description DESC
		END

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
		IF OBJECT_ID('tempdb..#TEMPHD') IS NOT NULL DROP TABLE #TEMPHD
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_ChannelWiseConsumption_Yearwise_Sub_English]', 'Step 2', 0, 'Procedure Excution COmpleted', 0, ''
END



/*
EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '4155','24,25','Y','Y','P','D'

EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '3','','Y','Y','P','D'
EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '41','','Y','Y','P','N'

EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '96','24','Y','N','Y','N'


EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '4155','24','Y','N','P','D'
EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '4155','25','Y','N','P','D'
select * from ACQ_deal_movie where Title_Code in (10060)

EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '96','24','Y','Y','Y','N'
EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  '96','24','Y','Y','P','Y'


EXEC [USP_ChannelWiseConsumption_Yearwise_Sub_English]  527,31,'Y','N','P','D'
*/

--SELECT DISTINCT ADYR.Start_Date,ADYR.End_Date,ADRC.channel_Code, ADR.No_Of_Runs Total_runs,

--CASE WHEN ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 
--           AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 
--           THEN 0 
--     ELSE  
--	 CASE WHEN ADRC.Min_Runs>0 
--		  THEN ADYR.No_Of_Runs 
--		  ELSE 0 
--	  END
--END 
--as No_Of_Runs,

--CASE WHEN ADR.Is_Yearwise_Definition = 'Y' THEN 
--(	
--	SELECT COUNT(BST.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BST WHERE BST.Schedule_Item_Log_Date 
--	between ADYR.Start_Date and ADYR.End_Date 
--	AND Channel_Code=ADRC.Channel_Code AND BST.IsProcessed='Y' AND BST.Deal_Movie_Code = @DealMovieCode AND ISNULL(IsIgnore,'N')<>'Y'
--)
--ELSE 
--CASE WHEN  ADR.Is_Yearwise_Definition = 'N' THEN
--(	
--	SELECT COUNT(BST.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BST WHERE 1=1
--	AND Channel_Code=ADRC.Channel_Code AND BST.IsProcessed='Y' AND BST.Deal_Movie_Code = @DealMovieCode AND ISNULL(IsIgnore,'N')<>'Y'
--)
--END
--END		
--AS Provision_BV_Transaction,

--CASE WHEN ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 
--		   AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 
--		   THEN 0 
--		   ELSE 
--		   ISNULL(ADYR.No_Of_AsRuns,0) 
--END as Consume,

--CASE WHEN ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 
--			AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 
--			THEN 
--			0 
--			ELSE 
--			(  (ISNULL(ADYR.No_Of_Runs,0) - ISNULL(ADRC.Min_Runs,0) ) - (ISNULL(ADRC.No_Of_Runs_Sched,0) + ISNULL(ADRC.No_Of_AsRuns,0)) ) 
--END  AS Balance,

--ISNULL(ADR.Prime_Run,0) AS Total_Prime_Runs,
 
--CASE WHEN ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 
--				AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 
--		  THEN 0 
--	 ELSE  
--	 CASE WHEN ADRC.Min_Runs>0 
--		  THEN ISNULL(ADR.Prime_Run,0) 
--	 ELSE 0 
--	 END 
--END AS Prime_No_Of_Runs,

--CASE WHEN ADR.Is_Yearwise_Definition = 'Y' THEN 
--(	
--	SELECT COUNT(BST.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BST WHERE BST.Schedule_Item_Log_Time 
--	between ADR.Prime_Start_Time and ADR.Prime_End_Time 
--	AND BST.Schedule_Item_Log_Date BETWEEN ADYR.Start_Date and ADYR.End_Date 
--	AND Channel_Code=ADRC.Channel_Code AND BST.IsProcessed='Y' 
--	AND BST.Deal_Movie_Code = @DealMovieCode AND ISNULL(IsIgnore,'N')<>'Y'
--)
--ELSE 
--CASE WHEN  ADR.Is_Yearwise_Definition = 'N' THEN
--(	
--	SELECT COUNT(BST.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BST WHERE BST.Schedule_Item_Log_Time 
--	between ADR.Prime_Start_Time and ADR.Prime_End_Time  
--	AND Channel_Code=ADRC.Channel_Code AND BST.IsProcessed='Y' 
--	AND BST.Deal_Movie_Code = @DealMovieCode AND ISNULL(IsIgnore,'N')<>'Y'
--)
--END
--END
--AS Prime_Provision_BV_Transaction,

--CASE WHEN ISNULL(ADRC.No_Of_AsRuns,0) = 0 
--			AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 
--			AND ISNULL(ADRC.Min_Runs,0)<=0 
--			AND ISNULL(ADRC.Max_Runs,0)<=0 
--	  THEN 0 
--	  ELSE 
--			ISNULL(ADR.Prime_Time_AsRun_Count ,0) 
--     END as Prime_Consume,
     
--Prime_Time_Balance_Count, ISNULL(ADR.Off_Prime_Run,0) AS Total_Off_Prime_Runs,
--CASE WHEN ISNULL(ADRC.No_Of_AsRuns,0) = 0 AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 
--		  AND ISNULL(ADRC.Min_Runs,0)<=0 AND ISNULL(ADRC.Max_Runs,0)<=0 
--		  THEN 0 
		  
--		  ELSE  
		  
--			  CASE WHEN ADRC.Min_Runs>0 
--			  THEN ISNULL(ADR.Off_Prime_Run,0) 
--			  ELSE 0 
--			  END
--END AS Off_Prime_No_Of_Runs,

--CASE WHEN ADR.Is_Yearwise_Definition = 'Y' THEN 
--(	
--	SELECT COUNT(BST.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BST
--	WHERE 1=1 
--	AND BST.Schedule_Item_Log_Date BETWEEN ADYR.Start_Date and ADYR.End_Date 
--	AND Channel_Code = ADRC.Channel_Code AND BST.IsProcessed='Y' 
--	AND BST.Deal_Movie_Code = @DealMovieCode AND ISNULL(IsIgnore,'N')<>'Y'
--	AND (
--			(Off_Prime_Start_Time > Off_Prime_End_Time AND 
--				((BST.Schedule_Item_Log_Time BETWEEN Off_Prime_Start_Time AND '23:59:59')
--				OR 
--				(BST.Schedule_Item_Log_Time BETWEEN '00:00:00' AND Off_Prime_End_Time))
--			)
--			OR
--			(Off_Prime_Start_Time < Off_Prime_End_Time AND BST.Schedule_Item_Log_Time BETWEEN Off_Prime_Start_Time AND Off_Prime_End_Time
--			)
--		)
--)
--ELSE
--CASE WHEN  ADR.Is_Yearwise_Definition = 'N' THEN
--(
--		SELECT COUNT(BST.BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction BST 
--		 WHERE 1=1 
--		AND Channel_Code =ADRC.Channel_Code AND BST.IsProcessed='Y' 
--		AND (
--			(Off_Prime_Start_Time > Off_Prime_End_Time AND 
--				((BST.Schedule_Item_Log_Time BETWEEN Off_Prime_Start_Time AND '23:59:59')
--				OR 
--				(BST.Schedule_Item_Log_Time BETWEEN '00:00:00' AND Off_Prime_End_Time))
--			)
--			OR
--			(Off_Prime_Start_Time < Off_Prime_End_Time AND BST.Schedule_Item_Log_Time BETWEEN Off_Prime_Start_Time AND Off_Prime_End_Time
--			)
--		)
--		AND BST.Deal_Movie_Code = @DealMovieCode AND ISNULL(IsIgnore,'N')<>'Y'
--)End 
--END
--AS Off_Prime_Provision_BV_Transaction,

--CASE WHEN ISNULL(ADRC.No_Of_AsRuns,0) = 0 
--		AND ISNULL(ADRC.No_Of_Runs_Sched,0) = 0 
--		AND ISNULL(ADRC.Min_Runs,0)<=0 
--		AND ISNULL(ADRC.Max_Runs,0)<=0 		
--		THEN 0 
--		ELSE ISNULL(ADR.Off_Prime_Time_AsRun_Count ,0) 
--END as Off_Prime_Consume,

--Off_Prime_Time_Balance_Count
--INTO #Temp
--from Acq_Deal_Movie ADM 
--INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @DealMovieCode		
--INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Title_Code = ADM.Title_Code
--INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code= ADRT.Acq_Deal_Run_Code and AD.Acq_Deal_Code = ADR.Acq_Deal_Code
--LEFT JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
--LEFT JOIN Acq_Deal_Run_Yearwise_Run ADYR ON ADYR.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
--INNER JOIN Channel C ON C.Channel_Code=ADRC.Channel_Code and isnull(C.Channel_Group,0) <> 0

--where 1=1 
--AND ( (  @AllYears = 'N' AND GETDATE() BETWEEN ADYR.Start_Date AND ADYR.End_Date )  OR (@AllYears = 'Y') )
----ORDER BY ADRC.Channel_Code