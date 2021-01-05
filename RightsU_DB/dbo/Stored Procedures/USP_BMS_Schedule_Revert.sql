CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Revert]
(
	--@BMS_Schedule_Log_Code INT ,
	@Channel_Code INT,
	@TimeLine_ID_Revert VARCHAR(MAX)=''
)
-- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:	   <19 Aug 2016>
-- Description:    <RU BV Schedule Integration, Call FROM USP_BMS_Schedule>
-- =============================================
AS
BEGIN
	BEGIN TRY	
		PRINT '--------------------Start logic of USP_BMS_Schedule_Revert-----------------------------'
		PRINT '@Channel_Code : '+ CAST(@Channel_Code AS VARCHAR)+',@TimeLine_ID_Revert : '+ @TimeLine_ID_Revert

		DECLARE @AD_Run_Code_CV INT = 0,@Ch_Code_CV INT = 0,@RR_Code_CV INT = 0,@Time_LineID_CV INT = 0, @Content_Channel_Run_Code_CV INT = 0,
		@Acq_Deal_Run_Codes VARCHAR(MAX) = '', @Channel_Content_Run_Codes VARCHAR(MAX) = '', @Parent_ChannelCode INT = 0
			
		/************************DELETE TEMP TABLES *************************/	
		BEGIN
			IF OBJECT_ID('tempdb..#Temp_TimeLine_ID') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_TimeLine_ID
			END		
			IF OBJECT_ID('tempdb..#Temp_Acq_Run_Right_Rule_Code') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_Acq_Run_Right_Rule_Code
			END		
			IF OBJECT_ID('tempdb..#Temp_Acq_Run_No_Right_Rule_Code') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_Acq_Run_No_Right_Rule_Code
			END
			IF OBJECT_ID('tempdb..#Temp_R') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_R
			END	
			IF OBJECT_ID('tempdb..#Temp_No_Right_Rule') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_No_Right_Rule
			END
			IF OBJECT_ID('tempdb..#Temp_TimeLine_ID') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_TimeLine_ID
			END
		END
		/************************CREATE TEMP TABLES *********************/
		PRINT '@TimeLine_ID_Revert : ' + @TimeLine_ID_Revert
		BEGIN
			CREATE TABLE #Temp_TimeLine_ID 
			(
				TimeLine_ID INT
			)
			CREATE TABLE #Temp_Acq_Run_Right_Rule_Code
			(
				Channel_Code INT, Is_Ignore CHAR(1), Right_Rule_Code INT, TimeLine_ID INT, Content_Channel_Run_Code INT	
			)
			CREATE TABLE #Temp_Acq_Run_No_Right_Rule_Code
			(
				Channel_Code INT, Is_Ignore CHAR(1), Right_Rule_Code INT, TimeLine_ID INT, Content_Channel_Run_Code INT		
			)
			CREATE TABLE #Temp_No_Right_Rule
			(
				BV_Schedule_Transaction_Code INT, Is_Ignore CHAR(1), Schedule_DateTime DATETIME, TimeLine_ID INT, Ref_TimeLine_ID INT, PlayDay INT, PlayRun INT
			)
			CREATE TABLE #Temp_R
			(
				RowNum INT, BV_Schedule_Transaction_Code INT, Is_Ignore CHAR(1), Ref_TimeLine_ID INT, Schedule_DateTime DATETIME, TimeLine_ID INT, PlayDay INT, PlayRun INT
			)
			CREATE TABLE #Revert
			(
				TimeLine_ID VARCHAR(MAX), Content_Channel_Run_Code INT
			)
		END	

		/*************************Insert TimeLine Id In #Temp_TimeLine_ID *********************************************/	
		INSERT INTO #Temp_TimeLine_ID(TimeLine_ID)
		SELECT number FROM fn_Split_withdelemiter(ISNULL(@TimeLine_ID_Revert,'0'),',')	

		INSERT INTO #Temp_Acq_Run_Right_Rule_Code(Channel_Code, Is_Ignore, Right_Rule_Code, TimeLine_ID, Content_Channel_Run_Code)
		SELECT DISTINCT BST.Channel_Code, BST.IsIgnore, CCR.Right_Rule_Code, BST.Timeline_ID, CCR.Content_Channel_Run_Code
			FROM BV_Schedule_Transaction BST
		INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID
		INNER JOIN Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code AND CCR.Channel_Code=@Channel_Code
		AND (BST.Schedule_Item_Log_Time BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date) AND ISNULL(CCR.Is_Archive, 'N') = 'N'
		WHERE BST.Timeline_ID IN(SELECT TT.TimeLine_ID FROM #Temp_TimeLine_ID TT) 
		AND ISNULL(CCR.Right_Rule_Code,0) > 0

		INSERT INTO #Temp_Acq_Run_No_Right_Rule_Code(Channel_Code, Is_Ignore, Right_Rule_Code, TimeLine_ID, Content_Channel_Run_Code)
		SELECT DISTINCT BST.Channel_Code, BST.IsIgnore, CCR.Right_Rule_Code, BST.Timeline_ID, CCR.Content_Channel_Run_Code
			FROM BV_Schedule_Transaction BST
		INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID
		INNER JOIN Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code AND CCR.Channel_Code = @Channel_Code
		AND (BST.Schedule_Item_Log_Time BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date) AND ISNULL(CCR.Is_Archive, 'N') = 'N'
		WHERE BST.Timeline_ID IN(SELECT TT.TimeLine_ID FROM #Temp_TimeLine_ID TT) 
		AND ISNULL(CCR.Right_Rule_Code,0) = 0

		SELECT  @Acq_Deal_Run_Codes = STUFF((SELECT DISTINCT  ',' +  CAST(ISNULL(Acq_Deal_Run_Code,0) AS VARCHAR)
			FROM BV_Schedule_Transaction WHERE Timeline_ID IN(SELECT DISTINCT TimeLine_ID FROM #Temp_TimeLine_ID) FOR XML PATH('')), 1, 1, '')

		SELECT @Channel_Content_Run_Codes = STUFF((SELECT DISTINCT  ',' +  CAST(ISNULL(CCR.Content_Channel_Run_Code,0) AS VARCHAR)
			FROM BV_Schedule_Transaction BST
		INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID
		INNER JOIN Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code
		AND(BST.Schedule_Item_Log_Date BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date) AND ISNULL(CCR.Is_Archive, 'N') = 'N'
		WHERE Timeline_ID IN(SELECT DISTINCT TimeLine_ID FROM #Temp_TimeLine_ID)
		AND CCR.Channel_Code = @Channel_Code
		FOR XML PATH('')), 1, 1, '')
		
		SELECT @Parent_ChannelCode = ISNULL(C.Parent_Channel_Code,0) FROM Channel C WHERE C.Channel_Code = @Channel_Code
		IF (ISNULL(@Parent_ChannelCode,0) > 0)
		BEGIN
			DELETE #Temp_Acq_Run_Right_Rule_Code FROM #Temp_Acq_Run_Right_Rule_Code T
			INNER JOIN BV_Schedule_Transaction BV ON BV.Timeline_ID=T.TimeLine_ID
			WHERE T.Is_Ignore='Y' AND T.Channel_Code=25 AND BV.Play_Day=0 AND BV.Play_Run=0
		END

		INSERT INTO #Revert(Content_Channel_Run_Code,TimeLine_ID)
		select T1.Content_Channel_Run_Code,
		(SELECT STUFF((SELECT DISTINCT  ',' +  CAST(ISNULL(T2.Timeline_ID,0) AS VARCHAR)
		FROM BV_Schedule_Transaction T2 WHERE T2.Content_Channel_Run_Code = T1.Content_Channel_Run_Code
		AND T2.Timeline_ID IN(SELECT DISTINCT TimeLine_ID FROM #Temp_TimeLine_ID)
		FOR XML PATH('')), 1, 1, ''))  AS Content_Channel_Run_Code
		 from BV_Schedule_Transaction T1 where T1.Timeline_ID IN(SELECT DISTINCT TimeLine_ID FROM #Temp_TimeLine_ID)
		GROUP BY T1.Content_Channel_Run_Code

		
	--select '#Temp_Acq_Run_Right_Rule_Code',* from #Temp_Acq_Run_Right_Rule_Code
	--select '#Temp_Acq_Run_No_Right_Rule_Code',* from #Temp_Acq_Run_No_Right_Rule_Code
		/****************************************Start Cursor***/
	
		IF EXISTS(SELECT TOP 1 TAR.Content_Channel_Run_Code FROM #Temp_Acq_Run_Right_Rule_Code TAR)
		BEGIN
			DECLARE CR_Right_Rule_Run_Process CURSOR       
			FOR SELECT DISTINCT TT.Channel_Code, TT.Right_Rule_Code, TT.TimeLine_ID, TT.Content_Channel_Run_Code
				FROM #Temp_Acq_Run_Right_Rule_Code TT
			OPEN CR_Right_Rule_Run_Process  
			FETCH NEXT FROM CR_Right_Rule_Run_Process INTO @Ch_Code_CV, @RR_Code_CV, @Time_LineID_CV, @Content_Channel_Run_Code_CV
			WHILE @@FETCH_STATUS<>-1
			BEGIN
				IF(@@FETCH_STATUS<>-2)                                         
				BEGIN
					PRINT 'In Cursor CR_Right_Rule_Run_Process'
					IF EXISTS (SELECT TOP 1 T.Right_Rule_Code FROM Content_Channel_Run T WHERE T.Right_Rule_Code IS NOT NULL AND ISNULL(T.Is_Archive, 'N') = 'N')				
					BEGIN
						PRINT ' --------- Right Rule Define--------------'
						EXEC USP_BMS_Schedule_Right_Rule_Run_Process 'R',@Ch_Code_CV,@Time_LineID_CV,@Content_Channel_Run_Code_CV
					END
				END
				FETCH NEXT FROM CR_Right_Rule_Run_Process INTO @Ch_Code_CV,@RR_Code_CV,@Time_LineID_CV,@Content_Channel_Run_Code_CV
			END
			CLOSE CR_Right_Rule_Run_Process
			DEALLOCATE CR_Right_Rule_Run_Process
		END

		--IF EXISTS(SELECT TOP 1 TR.Content_Channel_Run_Code FROM #Temp_Acq_Run_No_Right_Rule_Code TR)
		--BEGIN
		--	DECLARE CR_No_Right_Rule_Run_Process CURSOR       
		--	FOR SELECT DISTINCT TT.Channel_Code,TT.Right_Rule_Code,TT.TimeLine_ID,TT.Content_Channel_Run_Code
		--		FROM #Temp_Acq_Run_No_Right_Rule_Code TT
		--	OPEN CR_No_Right_Rule_Run_Process  
		--	FETCH NEXT FROM CR_No_Right_Rule_Run_Process INTO @Ch_Code_CV,@RR_Code_CV,@Time_LineID_CV,@Content_Channel_Run_Code_CV
		--	WHILE @@FETCH_STATUS<>-1 
		--	BEGIN
		--		IF(@@FETCH_STATUS<>-2)
		--		BEGIN
		--			PRINT 'In Cursor CR_No_Right_Rule_Run_Process'
		--			/** Added by Anchal***/
		--			--DECLARE @Title_Code VARCHAR(1000),@PlayDay INT
		--			--SELECT TOP 1 @Title_Code=Title_Code FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code=@AD_Run_Code_CV

		--			--select @Title_Code,@Channel_Code
					
		--			INSERT INTO #Temp_R(RowNum,BV_Schedule_Transaction_Code, Is_Ignore, 
		--				Schedule_DateTime, TimeLine_ID)
		--			SELECT ROW_NUMBER() OVER(ORDER BY BST.Schedule_Item_Log_Date) RowNumber, BST.BV_Schedule_Transaction_Code, 'N', 
		--			BST.Schedule_Item_Log_Date, BST.Timeline_ID
		--				FROM BV_Schedule_Transaction BST
		--			WHERE --BST.Title_Code = @Title_Code AND 
		--			BST.Channel_Code = @Channel_Code
		--			AND BST.Timeline_ID NOT IN(@Time_LineID_CV) 
		--			AND BST.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV 
		--			ORDER BY BST.Schedule_Item_Log_Date

		--			IF EXISTS (SELECT * from #Temp_R)
		--			BEGIN
		--				INSERT INTO #Temp_No_Right_Rule(BV_Schedule_Transaction_Code, Is_Ignore, Schedule_DateTime, TimeLine_ID, Ref_TimeLine_ID, 
		--				PlayDay, PlayRun)
		--				select BV_Schedule_Transaction_Code, 'N' AS Is_Ignore, Schedule_DateTime, TimeLine_ID, Ref_TimeLine_ID, 
		--				RowNum AS PlayDay,1 AS PlayRun from #Temp_R
		--				PRINT 'Update BV_Schedule_Transaction'	
							
		--				UPDATE BST SET BST.IsIgnore = TRR.Is_Ignore, BST.Ref_Timeline_ID = TRR.Ref_TimeLine_ID,
		--				BST.Play_Day=TRR.PlayDay, BST.Play_Run=TRR.PlayRun, BST.Last_Updated_Time=GETDATE()
		--				FROM BV_Schedule_Transaction BST INNER JOIN #Temp_No_Right_Rule TRR ON TRR.TimeLine_ID = BST.Timeline_ID 
		--				AND BST.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV AND BST.BV_Schedule_Transaction_Code = TRR.BV_Schedule_Transaction_Code

		--				IF OBJECT_ID('tempdb..#Temp_R') IS NOT NULL
		--				BEGIN
		--					TRUNCATE TABLE #Temp_R
		--				END
		--				IF OBJECT_ID('tempdb..#Temp_No_Right_Rule') IS NOT NULL
		--				BEGIN
		--					TRUNCATE TABLE #Temp_No_Right_Rule
		--				END
		--			END
		--		END
		--		FETCH NEXT FROM CR_No_Right_Rule_Run_Process INTO @Ch_Code_CV,@RR_Code_CV,@Time_LineID_CV,@Content_Channel_Run_Code_CV
		--	END
		--	CLOSE CR_No_Right_Rule_Run_Process
		--	DEALLOCATE CR_No_Right_Rule_Run_Process
		--END	

		/******************Call BMS_Schedule_Reprocess_Runs******/
		PRINT 'BMS_Schedule_Reprocess_Runs :- Completed Revert Runs '

		--select @Channel_Code '@Channel_Code', @TimeLine_ID_Revert '@TimeLine_ID_Revert', @Channel_Content_Run_Codes '@Channel_Content_Run_Codes'
		--IF(ISNULL(@TimeLine_ID_Revert,'') <> '')

		--select '#Revert',* FROM #Revert
		DECLARE @Content_Channel_Run_Code_Rev INT, @TimeLine_ID_Rev VARCHAR(MAX)
		DECLARE CR_Revert CURSOR       
		FOR SELECT DISTINCT Content_Channel_Run_Code,TimeLine_ID FROM #Revert
		OPEN CR_Revert 
		FETCH NEXT FROM CR_Revert INTO @Content_Channel_Run_Code_Rev,@TimeLine_ID_Rev
		WHILE @@FETCH_STATUS<>-1 
		BEGIN
			--SELECT @Channel_Code '@Channel_Code', @TimeLine_ID_Rev '@TimeLine_ID_Rev', @Content_Channel_Run_Code_Rev '@Content_Channel_Run_Code_Rev'
			EXEC USP_BMS_Schedule_Reprocess_Runs @Channel_Code, @TimeLine_ID_Rev, @Content_Channel_Run_Code_Rev
			FETCH NEXT FROM CR_Revert INTO @Content_Channel_Run_Code_Rev,@TimeLine_ID_Rev
		END
		CLOSE CR_Revert
		DEALLOCATE CR_Revert
		--EXEC USP_BMS_Schedule_Reprocess_Runs @Channel_Code, @TimeLine_ID_Revert, @Channel_Content_Run_Codes
			
		PRINT '--------------------Inserted into #Temp_TimeLine_ID -----------------------------'
			
		DELETE FROM BMS_Schedule_Exception WHERE BV_Schedule_Transaction_Code IN(
			SELECT BST.BV_Schedule_Transaction_Code 
			FROM #Temp_TimeLine_ID T 
			INNER JOIN BV_Schedule_Transaction BST ON T.TimeLine_ID = BST.Timeline_ID
			WHERE ISNULL(T.TimeLine_ID,0) > 0
		)
		DELETE FROM BMS_Schedule_Exception WHERE BMS_Schedule_Process_Data_Temp_Code IN(
			SELECT BSD.BMS_Schedule_Process_Data_Temp_Code 
			FROM #Temp_TimeLine_ID T 
			INNER JOIN BMS_Schedule_Process_Data_Temp BSD ON T.TimeLine_ID = BSD.Timeline_ID
			WHERE ISNULL(T.TimeLine_ID,0) > 0
		) 
		DELETE FROM BV_Schedule_Transaction WHERE Timeline_ID IN(
			SELECT Timeline_ID FROM #Temp_TimeLine_ID T WHERE ISNULL(T.TimeLine_ID,0) > 0
		)

		PRINT '--------------------End logic of USP_BMS_Schedule_Revert-----------------------------'
	END TRY			
	BEGIN CATCH
		PRINT 'Catch Block in USP_BMS_Schedule_Revert'
		DECLARE @ErMessage NVARCHAR(MAX),@ErSeverity INT,@ErState INT
		SELECT @ErMessage = 'Error in USP_BMS_Schedule_Revert : - ' +  ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()
		RAISERROR (@ErMessage,@ErSeverity,@ErState)
	END CATCH

	IF OBJECT_ID('tempdb..#Revert') IS NOT NULL DROP TABLE #Revert
	IF OBJECT_ID('tempdb..#Temp_Acq_Run_No_Right_Rule_Code') IS NOT NULL DROP TABLE #Temp_Acq_Run_No_Right_Rule_Code
	IF OBJECT_ID('tempdb..#Temp_Acq_Run_Right_Rule_Code') IS NOT NULL DROP TABLE #Temp_Acq_Run_Right_Rule_Code
	IF OBJECT_ID('tempdb..#Temp_No_Right_Rule') IS NOT NULL DROP TABLE #Temp_No_Right_Rule
	IF OBJECT_ID('tempdb..#Temp_R') IS NOT NULL DROP TABLE #Temp_R
	IF OBJECT_ID('tempdb..#Temp_TimeLine_ID') IS NOT NULL DROP TABLE #Temp_TimeLine_ID
END