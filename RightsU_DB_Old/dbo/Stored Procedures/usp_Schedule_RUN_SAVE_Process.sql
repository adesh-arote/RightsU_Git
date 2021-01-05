ALTER PROC [dbo].[usp_Schedule_RUN_SAVE_Process]
(
	@AcqDealCode INT
)
AS  
BEGIN

	--SELECT BST.BV_Schedule_Transaction_Code, BST.File_Code, BST.Channel_Code, ADR.Acq_Deal_Run_Code, ADRC.Acq_Deal_Run_Channel_Code
	--INTO #BV_Schedule_Transaction
	--FROM BV_Schedule_Transaction BST 
	--	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = @AcqDealCode AND BST.Title_Code = ADM.Title_Code AND BST.Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
	--	INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Code = @AcqDealCode
	--	INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRC.Channel_Code = BST.Channel_Code
	IF (OBJECT_ID('TEMPDB..#BV_Schedule_Transaction') IS NOT NULL)
			DROP TABLE #BV_Schedule_Transaction
	IF (OBJECT_ID('TEMPDB..#tempTitle') IS NOT NULL)
			DROP TABLE #tempTitle
	
	DECLARE @MinStartDate DATETIME, @MinEndDate DATETIME

	select CCR.Title_Code,CCR.Channel_Code, MIN(CCR.Rights_Start_Date) AS Right_Start_Date, 
	MAX(ISNULL(CCR.Rights_End_Date,'31-DEC-9999')) AS Right_End_Date
	INTO #tempTitle
	FROm Content_Channel_Run CCR
	Where CCR.Acq_Deal_Code = @AcqDealCode
	--from Acq_Deal_Rights ADR
	--INNER JOIN Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @AcqDealCode
	--AND ADR.Right_Type != 'M'
	--INNER JOIN Acq_Deal_Run ADR1 ON ADR1.Acq_Deal_Code = ADR.Acq_Deal_Code AND ADR1.Acq_Deal_Code = @AcqDealCode
	--INNER JOIN Acq_Deal_Run_Title ADRT1 ON ADRT1.Title_Code = ADRT.Title_Code AND ADRT1.Acq_Deal_Run_Code = ADR1.Acq_Deal_Run_Code 
	--INNER JOIN Acq_Deal_Run_Channel ADRC On ADRT1.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
	Group BY CCR.Title_Code,CCR.Channel_Code

	--SELECT DISTINCT  BST.BV_Schedule_Transaction_Code, BST.File_Code, BST.Channel_Code
	--INTO #BV_Schedule_Transaction
	--FROM BV_Schedule_Transaction BST 
	--INNER JOIN #tempTitle T ON BST.Title_Code = T.Title_Code 
	--AND (((Convert(DATE,BST.Schedule_Item_Log_Date,101) BETWEEN T.Right_Start_Date AND T.Right_End_Date) AND BST.Deal_Movie_Code IS NULL)
	--OR (BST.Deal_Movie_Code IN(select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Acq_Deal_Code = @AcqDealCode)))
	--AND BST.Channel_Code = T.Channel_Code

	SELECT DISTINCT  BST.BV_Schedule_Transaction_Code, BST.File_Code, BST.Channel_Code
	INTO #BV_Schedule_Transaction
	FROM BV_Schedule_Transaction BST 
	INNER JOIN #tempTitle T ON BST.Title_Code = T.Title_Code 
	AND (((Convert(DATE,BST.Schedule_Item_Log_Date,101) BETWEEN T.Right_Start_Date AND T.Right_End_Date) AND BST.Deal_Movie_Code IS NULL)
	OR (BST.Deal_Movie_Code IN(select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Acq_Deal_Code = @AcqDealCode)))
	AND BST.Channel_Code = T.Channel_Code

	IF EXISTS( SELECT BV_Schedule_Transaction_Code FROM #BV_Schedule_Transaction)
	BEGIN

		--UPDATE ADRYR SET ADRYR.No_Of_Runs_Sched = 0 FROM #BV_Schedule_Transaction BST 
		--INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON ADRYR.Acq_Deal_Run_Code = BST.Acq_Deal_Run_Code

		--UPDATE ADRC SET ADRC.No_Of_Runs_Sched = 0 FROM #BV_Schedule_Transaction BST 
		--INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Channel_Code = BST.Acq_Deal_Run_Channel_Code
		
		--UPDATE Acq_Deal_Run SET No_Of_Runs_Sched = 0, 
		--	Prime_Time_Provisional_Run_Count = 0, Prime_Time_Balance_Count = Prime_Run, 
		--	Off_Prime_Time_Provisional_Run_Count = 0, Off_Prime_Time_Balance_Count = Off_Prime_Run
		--WHERE Acq_Deal_Code = @AcqDealCode	
		
		UPDATE Content_Channel_Run SET Schedule_Runs = 0, Schedule_Utilized_Runs = 0, 
			Prime_Schedule_Runs = 0, Prime_Schedule_Utilized_Runs = 0, 
			OffPrime_Schedule_Runs = 0, OffPrime_Schedule_Utilized_Runs = 0
		WHERE Acq_Deal_Code = @AcqDealCode		

		UPDATE BST SET BST.IsProcessed = 'N', BST.IsIgnore = 'N'
		FROM BV_Schedule_Transaction BST 
		INNER JOIN #BV_Schedule_Transaction BST_T ON BST_T.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code

		DELETE ENS FROM #BV_Schedule_Transaction BST 
		INNER JOIN Email_Notification_Schedule ENS ON ENS.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code

		/* Process the schedule */
		DECLARE @FileCode INT, @ChannelCode INT
		DECLARE cursorRunSave CURSOR       
		FOR
		select X.File_Code, X.Channel_Code FROM
			(SELECT DISTINCT BST.File_Code, BST.Channel_Code, C.Order_For_schedule
			FROM #BV_Schedule_Transaction BST 
			INNER JOIN Channel C ON C.Channel_Code = BST.Channel_Code) AS X
			Order by X.Order_For_schedule, X.File_Code asc
		OPEN cursorRunSave  
		FETCH NEXT FROM cursorRunSave INTO @FileCode, @ChannelCode
		WHILE @@FETCH_STATUS<>-1
		BEGIN
			IF(@@FETCH_STATUS<>-2)
				EXEC [dbo].[USP_Schedule_Process] @FileCode, @ChannelCode , @AcqDealCode ,'Y'
			FETCH NEXT FROM cursorRunSave INTO @FileCode, @ChannelCode
		END
		CLOSE cursorRunSave
		DEALLOCATE cursorRunSave
	END

	DROP TABLE #BV_Schedule_Transaction
END


--ALTER PROC [dbo].[usp_Schedule_RUN_SAVE_Process]
--(
--	@AcqDealCode INT
--)
--AS  
--BEGIN

--	--SELECT BST.BV_Schedule_Transaction_Code, BST.File_Code, BST.Channel_Code, ADR.Acq_Deal_Run_Code, ADRC.Acq_Deal_Run_Channel_Code
--	--INTO #BV_Schedule_Transaction
--	--FROM BV_Schedule_Transaction BST 
--	--	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = @AcqDealCode AND BST.Title_Code = ADM.Title_Code AND BST.Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
--	--	INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Code = @AcqDealCode
--	--	INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRC.Channel_Code = BST.Channel_Code
--	IF (OBJECT_ID('TEMPDB..#BV_Schedule_Transaction') IS NOT NULL)
--			DROP TABLE #BV_Schedule_Transaction
--	IF (OBJECT_ID('TEMPDB..#tempTitle') IS NOT NULL)
--			DROP TABLE #tempTitle
	
--	DECLARE @MinStartDate DATETIME, @MinEndDate DATETIME

--	select CCR.Title_Code,CCR.Channel_Code, MIN(CCR.Rights_Start_Date) AS Right_Start_Date, 
--	MAX(ISNULL(CCR.Rights_End_Date,'31-DEC-9999')) AS Right_End_Date
--	INTO #tempTitle
--	FROm Content_Channel_Run CCR
--	Where CCR.Acq_Deal_Code = @AcqDealCode
--	--from Acq_Deal_Rights ADR
--	--INNER JOIN Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @AcqDealCode
--	--AND ADR.Right_Type != 'M'
--	--INNER JOIN Acq_Deal_Run ADR1 ON ADR1.Acq_Deal_Code = ADR.Acq_Deal_Code AND ADR1.Acq_Deal_Code = @AcqDealCode
--	--INNER JOIN Acq_Deal_Run_Title ADRT1 ON ADRT1.Title_Code = ADRT.Title_Code AND ADRT1.Acq_Deal_Run_Code = ADR1.Acq_Deal_Run_Code 
--	--INNER JOIN Acq_Deal_Run_Channel ADRC On ADRT1.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
--	Group BY CCR.Title_Code,CCR.Channel_Code

--	--SELECT DISTINCT  BST.BV_Schedule_Transaction_Code, BST.File_Code, BST.Channel_Code
--	--INTO #BV_Schedule_Transaction
--	--FROM BV_Schedule_Transaction BST 
--	--INNER JOIN #tempTitle T ON BST.Title_Code = T.Title_Code 
--	--AND (((Convert(DATE,BST.Schedule_Item_Log_Date,101) BETWEEN T.Right_Start_Date AND T.Right_End_Date) AND BST.Deal_Movie_Code IS NULL)
--	--OR (BST.Deal_Movie_Code IN(select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Acq_Deal_Code = @AcqDealCode)))
--	--AND BST.Channel_Code = T.Channel_Code

--	SELECT DISTINCT  BST.BV_Schedule_Transaction_Code, BST.File_Code, BST.Channel_Code
--	INTO #BV_Schedule_Transaction
--	FROM BV_Schedule_Transaction BST 
--	INNER JOIN #tempTitle T ON BST.Title_Code = T.Title_Code 
--	AND (((Convert(DATE,BST.Schedule_Item_Log_Date,101) BETWEEN T.Right_Start_Date AND T.Right_End_Date) AND BST.Deal_Movie_Code IS NULL)
--	OR (BST.Deal_Movie_Code IN(select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Acq_Deal_Code = @AcqDealCode)))
--	AND BST.Channel_Code = T.Channel_Code

--	IF EXISTS( SELECT BV_Schedule_Transaction_Code FROM #BV_Schedule_Transaction)
--	BEGIN
--		--UPDATE ADRYR SET ADRYR.No_Of_Runs_Sched = 0 FROM #BV_Schedule_Transaction BST 
--		--INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON ADRYR.Acq_Deal_Run_Code = BST.Acq_Deal_Run_Code

--		--UPDATE ADRC SET ADRC.No_Of_Runs_Sched = 0 FROM #BV_Schedule_Transaction BST 
--		--INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Channel_Code = BST.Acq_Deal_Run_Channel_Code
		
--		--UPDATE Acq_Deal_Run SET No_Of_Runs_Sched = 0, 
--		--	Prime_Time_Provisional_Run_Count = 0, Prime_Time_Balance_Count = Prime_Run, 
--		--	Off_Prime_Time_Provisional_Run_Count = 0, Off_Prime_Time_Balance_Count = Off_Prime_Run
--		--WHERE Acq_Deal_Code = @AcqDealCode	
		
--		UPDATE Content_Channel_Run SET Schedule_Runs = 0, Schedule_Utilized_Runs = 0, 
--			Prime_Schedule_Runs = 0, Prime_Schedule_Utilized_Runs = 0, 
--			OffPrime_Schedule_Runs = 0, OffPrime_Schedule_Utilized_Runs = 0
--		WHERE Acq_Deal_Code = @AcqDealCode		

--		UPDATE BST SET BST.IsProcessed = 'N', BST.IsIgnore = 'N'
--		FROM BV_Schedule_Transaction BST 
--		INNER JOIN #BV_Schedule_Transaction BST_T ON BST_T.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code

--		DELETE ENS FROM #BV_Schedule_Transaction BST 
--		INNER JOIN Email_Notification_Schedule ENS ON ENS.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code

--		/* Process the schedule */
--		DECLARE @FileCode INT, @ChannelCode INT
--		DECLARE cursorRunSave CURSOR       
--		FOR
--		select X.File_Code, X.Channel_Code FROM
--			(SELECT DISTINCT BST.File_Code, BST.Channel_Code, C.Order_For_schedule
--			FROM #BV_Schedule_Transaction BST 
--			INNER JOIN Channel C ON C.Channel_Code = BST.Channel_Code) AS X
--			Order by X.Order_For_schedule, X.File_Code asc
--		OPEN cursorRunSave  
--		FETCH NEXT FROM cursorRunSave INTO @FileCode, @ChannelCode
--		WHILE @@FETCH_STATUS<>-1
--		BEGIN
--			IF(@@FETCH_STATUS<>-2)
--				EXEC [dbo].[USP_Schedule_Process] @FileCode, @ChannelCode , @AcqDealCode ,'Y'
--			FETCH NEXT FROM cursorRunSave INTO @FileCode, @ChannelCode
--		END
--		CLOSE cursorRunSave
--		DEALLOCATE cursorRunSave
--	END

--	DROP TABLE #BV_Schedule_Transaction
--END