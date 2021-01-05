CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Process]
(
	@BMS_Process_UDT BMS_Process_UDT READONLY,
	@Is_Reprocess CHAR(1) = 'N'
)
AS
-- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:	   <09 Aug 2016>
-- Description:    <RU BV Schedule Integration>
-- =============================================
  

BEGIN
SET NOCOUNT ON;	
BEGIN TRY	
	PRINT '--------------------Start logic of USP_BMS_Schedule_Process-----------------------------'
	/************************DELETE TEMP TABLES *************************/	
	BEGIN

   		IF OBJECT_ID('tempdb..#Temp_BMS_Acq_Run_Process_Data') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_BMS_Acq_Run_Process_Data
		END
		IF OBJECT_ID('tempdb..#Temp_Acq_Run_Data') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Acq_Run_Data
		END
		IF OBJECT_ID('tempdb..#Temp_Email_Notification_Msg') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Email_Notification_Msg
		END		
		IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Runs') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_BMS_Schedule_Runs
		END			
		IF OBJECT_ID('tempdb..#Acq_Dup_Rights') IS NOT NULL
		BEGIN
			DROP TABLE #Acq_Dup_Rights
		END		
		IF OBJECT_ID('tempdb..#Acq_Deal_Right_Data') IS NOT NULL
		BEGIN
			DROP TABLE #Acq_Deal_Right_Data
		END		
		IF OBJECT_ID('tempdb..#Temp_Right_Rule') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Right_Rule
		END		
		IF OBJECT_ID('tempdb..#Temp_RR') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_RR
		END
		IF OBJECT_ID('tempdb..#ErrorList') IS NOT NULL
		BEGIN
			DROP TABLE #ErrorList
		END
	END

	/************************CREATE TEMP TABLES *********************/
	BEGIN
		CREATE TABLE #ErrorList
		(
		BMS_Schedule_Process_Data_Temp_Code INT,
		BV_Schedule_Transaction_Code INT,
		Email_Notification_Msg_Code INT,
		IsMailSent CHAR(1)
		)
		CREATE TABLE #Acq_Deal_Right_Data
		(
			Acq_Deal_Code INT, 
			Acq_Deal_Rights_Code INT, 
			Right_Start_Date DATE, 
			Right_End_Date DATE,
			 BMS_Asset_Ref_Key INT, Content_Channel_Run_Code INT
		)
		CREATE TABLE #Temp_BMS_Acq_Run_Process_Data
		(
			BMS_Asset_Ref_Key INT, BV_Schedule_Transaction_Code INT, Channel_Code INT, Date_Time DATETIME, Delete_Flag CHAR(1), Is_Ignore CHAR(1),
			Is_Prime_Time CHAR(1), Log_Date DATE, Timeline_ID INT, Content_Channel_Run_Code INT
		) 
		CREATE TABLE #Temp_Email_Notification_Msg
		(
			Email_Notification_Msg_Code INT
		)

		CREATE TABLE #Temp_Acq_Run_Data
		(
			Content_Channel_Run_Code INT, Is_Rule_Right CHAR(1), No_Of_Run INT, Off_Prime_Start_Time TIME, 
			Off_Prime_End_Time TIME, Off_Prime_Run INT, Prime_Start_Time TIME, Prime_End_Time TIME, Prime_Run INT, Right_Rule_Code INT,
			Time_Lag_Simulcast TIME					 
		)			
		CREATE TABLE #Temp_BV_Schedule_Transaction
		(			
			Acq_Deal_Run_Code INT, BV_Schedule_Transaction_Code INT, Channel_Code INT, Is_Ignore CHAR(1), Is_Prime CHAR(1), Log_Date DATE,
			 TimeLine_Id INT, Content_Channel_Run_Code INT
		)
		CREATE TABLE #Temp_Right_Rule
		(
			BV_Schedule_Transaction_Code INT, Is_Ignore CHAR(1), Ref_TimeLine_ID INT, Schedule_DateTime DATETIME, TimeLine_ID INT, PlayDay INT, 
			PlayRun INT, Is_Right_Rule_Exceeds CHAR(1)
		)
		
	END

	/************* Start Cursor*/
	BEGIN

		/*********************************Declare global variables ******************/		
		DECLARE @Channel_Code INT = 0,@BMS_Schedule_Log_Code INT  = 0
		DECLARE @BMS_Asset_Ref_Key_CV INT = 0,@Timeline_ID_CV INT = 0, @Schedule_Log_Date DateTime
		SELECT TOP 1 @Channel_Code = BSUDT.Channel_Code 
		FROM @BMS_Process_UDT BSUDT 
		DECLARE CR_RR_Validation CURSOR FOR SELECT BMS_Asset_Ref_Key, Timeline_ID, Schedule_Log_Date, BMS_Schedule_Log_Code FROM(
			SELECT DISTINCT BSUDT.BMS_Asset_Ref_Key, BSUDT.Timeline_ID, BSUDT.Schedule_Log_Date, BSUDT.Schedule_Log_Time, BSUDT.BMS_Schedule_Log_Code
			FROM @BMS_Process_UDT BSUDT
		) AS A ORDER BY Schedule_Log_Time
		OPEN CR_RR_Validation  
		FETCH NEXT FROM CR_RR_Validation INTO @BMS_Asset_Ref_Key_CV, @Timeline_ID_CV, @Schedule_Log_Date, @BMS_Schedule_Log_Code
		WHILE @@FETCH_STATUS<>-1
		BEGIN
			IF(@@FETCH_STATUS<>-2)
			BEGIN
				PRINT '-------In Cursor CR_RR_Validation and TimeLine ID is : - '	+ CAST (@Timeline_ID_CV AS VARCHAR(10))
				/**********************************************Truncate Tables**********/
				TRUNCATE TABLE #Temp_BMS_Acq_Run_Process_Data
				TRUNCATE TABLE #Temp_Acq_Run_Data
				TRUNCATE TABLE #Temp_Email_Notification_Msg
				TRUNCATE TABLE #Temp_BV_Schedule_Transaction
				TRUNCATE TABLE #Acq_Deal_Right_Data
				TRUNCATE TABLE #Temp_Right_Rule
				IF OBJECT_ID('tempdb..#ErrorList') IS NOT NULL
				BEGIN
					TRUNCATE TABLE #ErrorList
				END

				/************************************************* Start FIFO logic***********/
				PRINT 'Start FIFO logic'
				DECLARE @Count_UDT INT = 0
				SELECT @Count_UDT = COUNT(*) FROM @BMS_Process_UDT BSPRU
				WHERE ISNULL(BSPRU.Is_In_Right_Perod, 'N') = 'Y'
				AND BSPRU.Timeline_ID = @Timeline_ID_CV AND BSPRU.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code
				
				-------- -Adesh Check and Changes
				INSERT INTO #Acq_Deal_Right_Data(Acq_Deal_Code, Right_Start_Date, Right_End_Date, 
				BMS_Asset_Ref_Key, Content_Channel_Run_Code)
				SELECT DISTINCT BSPDT.Acq_Deal_Code, BSPDT.Right_Start_Date, BSPDT.Right_End_Date,  
				BSPDT.BMS_Asset_Ref_Key, BSPDT.Content_Channel_Run_Code
				FROM @BMS_Process_UDT BSPDT				 
				WHERE BSPDT.Timeline_ID = @Timeline_ID_CV AND BSPDT.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code 
				AND ISNULL(BSPDT.Is_In_Right_Perod,'N') = 'Y' 
				AND
				(
					@Count_UDT = 1 --if only Single Deal
					OR
					(					
						(
							BSPDT.Run_Type = 'U'  
							OR
							(
								ISNULL(BSPDT.No_Of_Runs,0) > 						
								(
									SELECT ISNULL(COUNT(DISTINCT BST.Timeline_ID),0)  AS No_Of_Runs_Sched
									FROM BV_Schedule_Transaction BST 
									WHERE BST.Content_Channel_Run_Code = BSPDT.Content_Channel_Run_Code AND ISNULL(BST.IsIgnore,'N') = 'N'
									AND ISNULL(BST.Content_Channel_Run_Code,0) > 0 
									AND ISNULL(BST.Channel_Code,0) > 0 
								)
							)
						)
					)
				  )

				-------- -Adesh Check and Changes
				IF EXISTS (SELECT TOP 1 Acq_Deal_Code FROM #Acq_Deal_Right_Data)
				BEGIN
					DECLARE @Multiple_Rights_Found INT = 0
											
					SELECT @Multiple_Rights_Found = COUNT(*) FROM #Acq_Deal_Right_Data ADR 

					IF(ISNULL(@Multiple_Rights_Found,0) > 1)
					BEGIN
						PRINT '---------------Multiple Rights Found----------------------'
						DELETE FROM #Acq_Deal_Right_Data WHERE Content_Channel_Run_Code NOT IN
						(
							SELECT MIN(ADR.Content_Channel_Run_Code) FROM #Acq_Deal_Right_Data ADR							
						)	
					END					

					UPDATE BSPDT SET
					BSPDT.Content_Channel_Run_Code = temp.Content_Channel_Run_Code, BSPDT.Is_Error = 'N',BSPDT.Is_Deal_Approved = 'Y'
					FROM BMS_Schedule_Process_Data_Temp BSPDT
					INNER JOIN #Acq_Deal_Right_Data temp ON BSPDT.Timeline_ID = @Timeline_ID_CV 
					AND BSPDT.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code AND BSPDT.BMS_Asset_Ref_Key = temp.BMS_Asset_Ref_Key

					PRINT 'Updated Acq Deal_Code ,Run Code in BMS_Schedule_Process_Data_Temp'
			     END
				 								 
				PRINT 'End FIFO logic'
				DECLARE @Email_Notification_Msg_Code VARCHAR(100) = '0'
				
				/*************************************************Excpetion OutSide Rights Period***********/							
				DECLARE @Is_Error CHAR(1) = 'N'		
				IF NOT EXISTS(SELECT TOP  1 * FROM #Acq_Deal_Right_Data ADR WHERE ISNULL(ADR.BMS_Asset_Ref_Key,0) > 0)-- no record in #Acq_Deal_Right_Data
				BEGIN
					IF EXISTS(SELECT TOP 1 T.Timeline_ID FROM @BMS_Process_UDT T  WHERE ISNULL(T.Is_In_Right_Perod,'N') = 'N'  AND T.Timeline_ID = @Timeline_ID_CV)
					BEGIN
						PRINT ' ----------Threw OutSide Right Period Exception------------' 							 
						SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code ,@Is_Error = 'Y'
						FROM Email_Notification_Msg WHERE  UPPER(Email_Msg_For) = 'Right_Period' AND [Type] = 'S'
					END					

					UPDATE BSPDT SET BSPDT.Content_Channel_Run_Code = temp.Content_Channel_Run_Code, BSPDT.Is_Error = 'Y',BSPDT.Is_Deal_Approved = 'Y'							
					FROM BMS_Schedule_Process_Data_Temp BSPDT
					INNER JOIN @BMS_Process_UDT temp ON BSPDT.Timeline_ID = @Timeline_ID_CV 
					AND BSPDT.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code AND BSPDT.BMS_Asset_Ref_Key = temp.BMS_Asset_Ref_Key 
					AND Is_In_Right_Perod = 'N'
										
					PRINT 'Updated Acq Deal_Code ,Run Code in BMS_Schedule_Process_Data_Temp (OutSide Rights Period)'			

				END
				/*************************************Insert Record BMS_Schedule_Process_Data_Temp*******/
				
				INSERT INTO BV_Schedule_Transaction
				(
					Acq_Deal_Code, Acq_Deal_Run_Code, Program_Episode_ID, File_Code ,								
					Schedule_Item_Log_Time, DealContent_RightId, Delete_Flag, Inserted_On, IsException, IsProcessed, 								
					Schedule_Item_Log_Date, Play_Day, Play_Run, Program_Version_ID, Record_Type, SYSLookupId_PlayCountError,Title_Code,								
					Timeline_ID, Program_Episode_Number, Channel_Code, Content_Channel_Run_Code, Deal_Movie_Rights_Code
				)
				SELECT DISTINCT CCR.Acq_Deal_Code, CCR.Acq_Deal_Run_Code, BSPDT.BMS_Asset_Ref_Key, BMS_Schedule_Log_Code,								
					CAST(CAST(Date_Time AS DATETIME2) AS DATETIME), DealContent_RightId, Delete_Flag, GETDATE(), Is_Error, 'D' AS Is_Processed,
					CAST(Log_Date AS DATE), null, null, BSPDT.Program_VersionId, 'S' AS Record_Type, SYSLookupId_PlayCountError, BSPDT.Title_Code,								
					Timeline_ID, BA.Episode_Number, BSPDT.Channel_Code, CCR.Content_Channel_Run_Code, (SELECT TOP 1 Acq_Deal_Rights_Code 
					from #Acq_Deal_Right_Data ADR WHERE CCR.Content_Channel_Run_Code = ADR.Content_Channel_Run_Code) AS Rights_Code
				FROM BMS_Schedule_Process_Data_Temp BSPDT 
				INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Ref_Key = BSPDT.BMS_Asset_Ref_Key AND BSPDT.Channel_Code=@Channel_Code
				INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BSPDT.BMS_Asset_Ref_Key
				INNER JOIN Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code AND ISNULL(CCR.Is_Archive, 'N') = 'N' 
				AND (BSPDT.Log_Date BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date) AND CCR.Channel_Code=@Channel_Code
				WHERE BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code  AND BSPDT.Timeline_ID IN(
					@Timeline_ID_CV
				)
				AND 
				(
					(
						CCR.Content_Channel_Run_Code IN(
							SELECT ADR.Content_Channel_Run_Code FROM #Acq_Deal_Right_Data ADR	
						)
					)
					OR
					(
						0 = (SELECT ISNULL(COUNT(ADR.Content_Channel_Run_Code),0) FROM #Acq_Deal_Right_Data ADR)	--IF OutSide Rights Period
					)
				)
				AND 
				(
					BSPDT.Timeline_ID NOT IN
					(
						SELECT ISNULL(BSP.Timeline_ID,0) FROM BV_Schedule_Transaction BSP WHERE ISNULL(BSP.Timeline_ID,0) > 0 AND ISNULL(BSP.File_Code,0) > 0
						UNION 
						SELECT 0 AS Timeline_ID
					)
				)

				PRINT  'Inserted into BMS_Schedule_Process_Data'

				IF EXISTS(	
							select TOP 1 UDT.Timeline_ID from @BMS_Process_UDT UDT 
							INNER JOIN Content_Channel_Run CCR ON CCR.Content_Channel_Run_Code = UDT.Content_Channel_Run_Code
							INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = CCR.Acq_Deal_Code AND (CCR.Rights_Start_Date BETWEEN ADR.Right_Start_Date 
							AND ADR.Right_End_Date) AND (CCR.Rights_End_Date BETWEEN ADR.Right_Start_Date AND ADR.Right_End_Date)
							INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADRT.Title_Code = UDT.Title_Code
							INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
							AND @Schedule_Log_Date BETWEEN ADRB.Start_Date AND ADRB.End_Date AND UDT.Timeline_ID = @Timeline_ID_CV 
							AND UDT.BMS_Asset_Ref_Key = @BMS_Asset_Ref_Key_CV
						 )
				BEGIN
					PRINT ' ----------Threw Black Right Period Exception------------' 						
					SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code ,@Is_Error = 'Y'
					FROM Email_Notification_Msg WHERE  UPPER(Email_Msg_For) = 'BLACKOUT_RIGHT_PERIOD' AND [Type] = 'S'													
				END

				IF(ISNULL(@Email_Notification_Msg_Code,0) > 0 AND ISNULL(@Is_Error,'N') = 'Y')
				BEGIN	
					PRINT ' ----------Update In BMS_Schedule_Exception ------------'
					UPDATE BSE SET BSE.IsMailSent='N', BSE.Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,0) FROM BMS_Schedule_Exception BSE 
					INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = BSE.BV_Schedule_Transaction_Code
					AND BSE.Email_Notification_Msg_Code != ISNULL(@Email_Notification_Msg_Code,0) AND @Is_Reprocess = 'Y'
					WHERE BST.Timeline_ID = @Timeline_ID_CV  AND BST.Channel_Code = @Channel_Code

					INSERT INTO #ErrorList(BV_Schedule_Transaction_Code, Email_Notification_Msg_Code, IsMailSent)
					SELECT DISTINCT BST.BV_Schedule_Transaction_Code AS BV_Schedule_Transaction_Code,
					ISNULL(@Email_Notification_Msg_Code,0) AS Email_Notification_Msg_Code, 'N' IsMailSent
					FROM BV_Schedule_Transaction BST
					LEFT JOIN BMS_Schedule_Exception BSE ON BST.BV_Schedule_Transaction_Code = BSE.BV_Schedule_Transaction_Code
					WHERE BST.Timeline_ID = @Timeline_ID_CV  AND BST.File_Code = @BMS_Schedule_Log_Code AND BSE.BV_Schedule_Transaction_Code IS NULL

					If NOT EXISTS(SELECT * FROM #ErrorList)
					BEGIN
						INSERT INTO #ErrorList(BMS_Schedule_Process_Data_Temp_Code, Email_Notification_Msg_Code, IsMailSent)
						SELECT DISTINCT BST.BMS_Schedule_Process_Data_Temp_Code AS BV_Schedule_Transaction_Code,
						ISNULL(@Email_Notification_Msg_Code,0) AS Email_Notification_Msg_Code, 'N' IsMailSent
						FROM BMS_Schedule_Process_Data_Temp BST
						LEFT JOIN BMS_Schedule_Exception BSE ON BST.BMS_Schedule_Process_Data_Temp_Code = BSE.BV_Schedule_Transaction_Code
						WHERE BST.Timeline_ID = @Timeline_ID_CV  AND BST.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code 
						AND BSE.BMS_Schedule_Process_Data_Temp_Code IS NULL
					END
					If EXISTS(SELECT * FROM #ErrorList)
					BEGIN
						INSERT INTO BMS_Schedule_Exception(BMS_Schedule_Process_Data_Temp_Code,BV_Schedule_Transaction_Code, Email_Notification_Msg_Code, IsMailSent)
						select BMS_Schedule_Process_Data_Temp_Code,BV_Schedule_Transaction_Code, Email_Notification_Msg_Code, IsMailSent FROM #ErrorList
					END

					Update BST SET BST.Play_Day=0, BST.Play_Run=0,BST.IsIgnore='', BST.IsException='Y' from BV_Schedule_Transaction BST 
					INNER JOIN BMS_Schedule_Exception E ON BST.BV_Schedule_Transaction_Code = E.BV_Schedule_Transaction_Code
					INNER JOIN Email_Notification_Msg M ON M.Email_Notification_Msg_Code = E.Email_Notification_Msg_Code
					Where ISNULL(M.Error_Warning, '') = 'E' AND BST.Timeline_ID=@Timeline_ID_CV

					GOTO RunCode_Zero
				END

				DECLARE @Content_Channel_Run_Code_CV INT = 0
				SELECT TOP 1 @Content_Channel_Run_Code_CV  = ISNULL(ADR.Content_Channel_Run_Code,0) 
				FROM #Acq_Deal_Right_Data ADR		

				IF(ISNULL(@Content_Channel_Run_Code_CV,0) = 0)
				BEGIN
					GOTO RunCode_Zero
				END

				/***************************************Insert Acq Deal Run data into Temp_Acq_Run_Data**********/
				INSERT INTO  #Temp_Acq_Run_Data
				(
					Content_Channel_Run_Code, Is_Rule_Right,
					No_Of_Run, Off_Prime_Start_Time, Off_Prime_End_Time, Off_Prime_Run, Prime_Start_Time, Prime_End_Time ,
					Prime_Run, Right_Rule_Code, Time_Lag_Simulcast						
				)
				SELECT DISTINCT	
				    CCR.Content_Channel_Run_Code, CASE WHEN ISNULL(CCR.Right_Rule_Code,0) != 0 THEN 'Y' ELSE 'N' END AS Is_Rule_Right,
					CCR.Defined_Runs, CCR.OffPrime_Start_Time, CCR.OffPrime_End_Time, CCR.OffPrime_Runs, CCR.Prime_Start_Time, CCR.Prime_End_Time,
					CCR.Prime_Runs, CCR.Right_Rule_Code, Time_Lag_Simulcast AS Time_Lag_Simulcast
				FROM 
				Content_Channel_Run CCR
				INNER JOIN Title_Content TC ON TC.Title_Content_Code=CCR.Title_Content_Code AND TC.Ref_BMS_Content_Code=CAST(@BMS_Asset_Ref_Key_CV AS VARCHAR)
				AND ISNULL(CCR.Is_Archive, 'N') = 'N'
				WHERE CCR.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV AND CCR.Channel_Code=@Channel_Code 
				AND CONVERT(DATETIME,@Schedule_Log_Date,101) BETWEEN CONVERT(DATETIME,CCR.Rights_Start_Date,101) 
				AND CONVERT(DATETIME,CCR.Rights_End_Date ,101)	
				PRINT 'Inserted Records into #Temp_Acq_Run_Data'	

				/*********************************** Insert into #Temp_BMS_Acq_Run_Process_Data ***********************************/
				INSERT INTO #Temp_BMS_Acq_Run_Process_Data
				(
					BMS_Asset_Ref_Key, BV_Schedule_Transaction_Code,
					Channel_Code, Date_Time, Delete_Flag, Is_Ignore, 
					Is_Prime_Time, Log_Date, Timeline_ID, Content_Channel_Run_Code
				)
				SELECT DISTINCT	BST.Program_Episode_ID,BST.BV_Schedule_Transaction_Code,
					@Channel_Code AS Channel_Code,BST.Schedule_Item_Log_Time,'N' AS Delete_Flag,'N' AS Is_Ignore,
					'N' Is_Prime_Time, BST.Schedule_Item_Log_Date,BST.Timeline_ID, BST.Content_Channel_Run_Code
				FROM BV_Schedule_Transaction BST 
				INNER JOIN #Temp_Acq_Run_Data TARD ON BST.Content_Channel_Run_Code = TARD.Content_Channel_Run_Code
				WHERE BST.Timeline_ID = @Timeline_ID_CV AND BST.File_Code = @BMS_Schedule_Log_Code

				--Select '#Temp_BMS_Acq_Run_Process_Data',* FROM #Temp_BMS_Acq_Run_Process_Data
				/************* Write Prime / off Prime Time Logic *****/
				DECLARE @Is_Prime_Time CHAR(1) = 'N'

				IF EXISTS (SELECT TOP 1 TARD.Content_Channel_Run_Code FROM #Temp_Acq_Run_Data TARD 
					WHERE ISNULL(TARD.Content_Channel_Run_Code,0) > 0 AND (ISNULL(TARD.Prime_Start_Time,'') <> '' OR ISNULL(TARD.Prime_End_Time,'') <> '')
					AND (ISNULL(TARD.Off_Prime_Start_Time,'') = '' AND ISNULL(TARD.Off_Prime_End_Time,'') = '')
				)
				BEGIN	
					SELECT 
					@Is_Prime_Time = CASE WHEN 							
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108)  AND '23:59:59'
					OR
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					'00:00:00' AND CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)
					THEN 'Y' ELSE 'N'
					END 
					FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
					INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Content_Channel_Run_Code = TARD.Content_Channel_Run_Code
					WHERE CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108) >  CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)

					SELECT 
					@Is_Prime_Time = CASE WHEN 							
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108) AND CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)
					THEN 'Y' ELSE 'N'
					END 
					FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
					INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Content_Channel_Run_Code = TARD.Content_Channel_Run_Code
					WHERE CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108) <  CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)
				END
				--Case 2 IF define only off Time
				ELSE IF EXISTS (
					SELECT TOP 1 TARD.Content_Channel_Run_Code FROM #Temp_Acq_Run_Data TARD 
					WHERE ISNULL(TARD.Content_Channel_Run_Code,0) > 0 AND (ISNULL(TARD.Off_Prime_Start_Time,'') <> '' OR ISNULL(TARD.Off_Prime_End_Time,'') <> '')
					AND (ISNULL(TARD.Prime_Start_Time,'') = '' AND ISNULL(TARD.Prime_End_Time,'') = ''))
				BEGIN						
					SELECT 
					@Is_Prime_Time = CASE WHEN 							
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108)  AND '23:59:59'
					OR
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					'00:00:00' AND CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)
					THEN 'N' ELSE 'Y'
					END 
					FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
					INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Content_Channel_Run_Code = TARD.Content_Channel_Run_Code --TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
					WHERE CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) >  CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)						

					SELECT 
					@Is_Prime_Time = CASE WHEN 							
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) AND CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)
					THEN 'N' ELSE 'Y'
					END 
					FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
					INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Content_Channel_Run_Code = TARD.Content_Channel_Run_Code --TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
					WHERE CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) <  CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)
				END
				--Case 3 Prime and Off Prime Time Both Not Define in Run Defination
			ELSE IF EXISTS (
					--SELECT TOP 1 TARD.Acq_Deal_Run_Code FROM #Temp_Acq_Run_Data TARD 
					--WHERE ISNULL(TARD.Acq_Deal_Run_Code,0) > 0 AND ISNULL(TARD.Off_Prime_Start_Time,'') = ''
					SELECT TOP 1 TARD.Content_Channel_Run_Code FROM #Temp_Acq_Run_Data TARD 
					WHERE ISNULL(TARD.Content_Channel_Run_Code,0) > 0 AND (ISNULL(TARD.Off_Prime_Start_Time,'') = '' AND ISNULL(TARD.Off_Prime_End_Time,'') = '')
					AND (ISNULL(TARD.Prime_Start_Time,'') = '' AND ISNULL(TARD.Prime_End_Time,'') = '') )
				BEGIN
					SELECT @Is_Prime_Time = 'N'
				--	SELECT '3  Prime and Off Prime Time Both Not Define in Run Defination',@Is_Prime_Time AS Is_Prime_Time
				END
			--Case 4  Prime and Off Prime (both) Define in Run Defination
			ELSE IF EXISTS (
					SELECT TOP 1 TARD.Content_Channel_Run_Code FROM #Temp_Acq_Run_Data TARD 
					WHERE ISNULL(TARD.Content_Channel_Run_Code,0) > 0 AND (ISNULL(TARD.Off_Prime_Start_Time,'') <> '' OR ISNULL(TARD.Off_Prime_End_Time,'') <> '')
					AND (ISNULL(TARD.Prime_Start_Time,'') <> '' AND ISNULL(TARD.Prime_End_Time,'') <> ''))
				BEGIN						
					Print 'Case 4.1 Prime Start Time < Off Prime Start Time'
					SELECT 
					@Is_Prime_Time = CASE WHEN 
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108)  AND CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)
					THEN 'Y' ELSE 'N'
					END 
					FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
					INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Content_Channel_Run_Code = TARD.Content_Channel_Run_Code --TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
					AND CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108) <  CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108)

					---Case 4.2 Off Prime Start Time  < Prime Start Time
					SELECT 
					@Is_Prime_Time = CASE WHEN 
					CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
					BETWEEN 
					CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108)  AND CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)
					THEN 'N' ELSE 'Y'
					END 
					FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
					INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Content_Channel_Run_Code = TARD.Content_Channel_Run_Code --TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
					AND CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) <  CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108)

					print @Is_Prime_Time
					--SELECT '4  Prime and Off Prime Time Both are Define in Run Defination',@Is_Prime_Time AS Is_Prime_Time
				END
					
				IF(ISNULL(@Is_Prime_Time,'N') = 'Y')
				BEGIN
					UPDATE  #Temp_BMS_Acq_Run_Process_Data SET Is_Prime_Time = ISNULL(@Is_Prime_Time,'N') 
					WHERE  Content_Channel_Run_Code = @Content_Channel_Run_Code_CV	
				END

				/**********************************Start TimeLag****************/
				DECLARE @Is_Ignore CHAR(1) = 'N'
				PRINT 'Start SimulCast'
				BEGIN -- Start SimulCast
					IF EXISTS(SELECT Channel_Code FROM Channel WHERE Channel_Code = @Channel_Code AND ISNULL(Is_Parent_Child,'') = 'C')
					BEGIN
						PRINT '-------SimulCast Logic Define---------'
						DECLARE @TimeLag_StartTime DATETIME,@TimeLag_EndTime DATETIME,@Time_Lag_Simulcast DATETIME,@Parent_Channel_Code INT = 0

						SELECT TOP 1 @TimeLag_StartTime = ((TD.Date_Time) - CAST(TARD.Time_Lag_Simulcast as DATETIME))
							,@TimeLag_EndTime =((TD.Date_Time) + CAST(TARD.Time_Lag_Simulcast as DATETIME))												 
						FROM #Temp_Acq_Run_Data TARD 
						INNER JOIN #Temp_BMS_Acq_Run_Process_Data TD ON TARD.Content_Channel_Run_Code = TD.Content_Channel_Run_Code
						AND TARD.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV
						
						SELECT @Parent_Channel_Code = ISNULL(C.Parent_Channel_Code,0) FROM Channel C WHERE C.Channel_Code = @Channel_Code

						Print ' @TimeLag_StartTime = '+CAST(@TimeLag_StartTime AS VARCHAR) + ', @TimeLag_EndTime = '+CAST(@TimeLag_EndTime AS VARCHAR)+ ', @Parent_Channel_Code= '+ CAST(@Parent_Channel_Code AS VARCHAR)
						+ ', @Content_Channel_Run_Code_CV= ' + CAST(@Content_Channel_Run_Code_CV AS VARCHAR)+', @Channel_Code= ' + CAST(@Channel_Code AS VARCHAR)

						IF EXISTS (SELECT TOP 1 * FROM BV_Schedule_Transaction BST WHERE BST.Channel_Code = @Parent_Channel_Code AND 
									BST.Schedule_Item_Log_Time BETWEEN @TimeLag_StartTime AND @TimeLag_EndTime)
						BEGIN
							Print 'SimulCast @Is_Ignore = Y'
							SET @Is_Ignore = 'Y'
						END									
					END
				END
				PRINT 'End SimulCast'	
					
				IF EXISTS(SELECT TOP 1 * FROM  BV_Schedule_Transaction BST WHERE ISNULL(BST.Timeline_ID,0) = ISNULL(@Timeline_ID_CV,0))
				BEGIN
					UPDATE BST SET BST.IsPrime = ISNULL(TBARP.Is_Prime_Time,'N')
					FROM BV_Schedule_Transaction BST
					INNER JOIN #Temp_BMS_Acq_Run_Process_Data TBARP ON BST.Timeline_ID = TBARP.Timeline_ID 
					AND BST.Content_Channel_Run_Code = TBARP.Content_Channel_Run_Code AND BST.Program_Episode_ID = TBARP.BMS_Asset_Ref_Key 
				END
				/**********************************Insert BMS_Schedule_Runs ****************/
				UPDATE BST SET BST.IsIgnore = ISNULL(@Is_Ignore,'N'), Delete_Flag = 0
				FROM #Temp_BMS_Acq_Run_Process_Data BSPD
				INNER JOIN BV_Schedule_Transaction BST ON BST.Timeline_ID=BSPD.Timeline_ID
				/*********************EXECUTE USP_BMS_Schedule_Right_Rule_Run_Process****************/		
				IF(@Is_Ignore = 'N')
				BEGIN
					IF EXISTS (SELECT TOP 1 T.Right_Rule_Code FROM #Temp_Acq_Run_Data T WHERE ISNULL(T.Is_Rule_Right,'N') = 'Y')					
					BEGIN
						PRINT 'SELECT from BMS_Schedule_Runs'
						
						INSERT INTO #Temp_Right_Rule
						EXEC USP_BMS_Schedule_Right_Rule_Run_Process 'P',@Channel_Code,@Timeline_ID_CV,@Content_Channel_Run_Code_CV
					END
					ELSE
					BEGIN
					PRINT '@Is_Ignore = '+@Is_Ignore
						IF OBJECT_ID('tempdb..#Temp_RR') IS NOT NULL
						BEGIN
							DROP TABLE #Temp_RR
						END	
						CREATE TABLE #Temp_RR
						(
							RowNum INT,
							BV_Schedule_Transaction_Code INT,
							Is_Ignore CHAR(1),
							Ref_TimeLine_ID INT,
							Schedule_DateTime DATETIME,
							TimeLine_ID INT,
							PlayDay INT,
							PlayRun INT
						)	

						INSERT INTO #Temp_RR(RowNum,BV_Schedule_Transaction_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,PlayDay,PlayRun)
						SELECT ROW_NUMBER() OVER(ORDER BY BST.Schedule_Item_Log_Date) RowNumber,BST.BV_Schedule_Transaction_Code, 
						CASE WHEN ISNULL(BST.IsIgnore,'N') = 'N' THEN 'N' ELSE 'Y' END, 
						BST.Schedule_Item_Log_Date,BST.Timeline_ID,NULL,NULL,NULL 
						FROM BV_Schedule_Transaction BST
						WHERE BST.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV	AND BST.Channel_Code=@Channel_Code
						ORDER BY BST.Schedule_Item_Log_Date

						INSERT INTO #Temp_Right_Rule(BV_Schedule_Transaction_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,PlayDay,PlayRun)
						select BV_Schedule_Transaction_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,RowNum,1 AS PlayRun
						from #Temp_RR
						IF OBJECT_ID('tempdb..#Temp_RR') IS NOT NULL
						BEGIN
							DROP TABLE #Temp_RR
						END	
					END					
				END

				SET @Email_Notification_Msg_Code = 0

				if EXISTS(SELECT * FROM #Temp_Right_Rule)
				BEGIN
					PRINT 'Update PlayDay PlayRun BV_Schedule_Transaction'
					UPDATE BST SET BST.Play_Day=TRR.PlayDay, BST.Play_Run=TRR.PlayRun, BST.Last_Updated_Time=GETDATE(), BST.IsIgnore = TRR.Is_Ignore, 
					BST.Ref_Timeline_ID = TRR.Ref_TimeLine_ID
					FROM BV_Schedule_Transaction BST
					INNER JOIN #Temp_Right_Rule TRR  
					ON BST.Timeline_ID=TRR.Timeline_ID 
					AND BST.BV_Schedule_Transaction_Code=TRR.BV_Schedule_Transaction_Code
					AND BST.Channel_Code = @Channel_Code
					AND( ISNULL(BST.Play_Day,0) != ISNULL(TRR.PlayDay,0)
					OR  ISNULL(BST.Play_Run,0) !=  ISNULL(TRR.PlayRun,0)
					OR ISNULL(BST.IsIgnore,'') != TRR.Is_Ignore)

					/***********************************Exception Right Rule Exceeeds**************/
					if EXISTS(SELECT * FROM #Temp_Right_Rule WHERE TimeLine_ID = @Timeline_ID_CV AND ISNULL(Is_Right_Rule_Exceeds,'') = 'Y' AND ISNULL(Is_Ignore,'') = 'N')
					BEGIN
						PRINT 'In BMS_Schedule_Process Is_Right_Rule_Exceeds = Y'

						SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
						CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR),@Is_Error = 'Y' 
						FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'Right_Rule_Exceeeds' AND [Type] = 'S'
					END
					/***********************************Exception Right Rule Exceeeds**************/
				END
				ELSE 
				BEGIN
					PRINT 'Update PlayDay PlayRun BV_Schedule_Transaction'
					UPDATE BST SET BST.Play_Day=
					CASE WHEN @Is_Ignore = 'Y' THEN 0 ELSE 1 END, BST.Play_Run = CASE WHEN @Is_Ignore = 'Y' THEN 0 ELSE 1 END, BST.Last_Updated_Time = GETDATE(), 
					IsIgnore = ISNULL(@Is_Ignore,'N'), Ref_Timeline_ID = NULL
					FROM BV_Schedule_Transaction BST where BST.Timeline_ID = @Timeline_ID_CV
				END
															
				PRINT 'Inserted Records into BMS_Schedule_Runs'	

				INSERT INTO #Temp_BV_Schedule_Transaction
				(
					BV_Schedule_Transaction_Code, Channel_Code, Is_Ignore, Is_Prime, Log_Date, Timeline_ID,
					Content_Channel_Run_Code
				)
				SELECT BST.BV_Schedule_Transaction_Code, BST.Channel_Code, BST.IsIgnore, BST.IsPrime, BST.Schedule_Item_Log_Date, BST.Timeline_ID,
					BST.Content_Channel_Run_Code
				FROM BV_Schedule_Transaction BST
				WHERE BST.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV AND ISNULL(BST.IsIgnore,'N') = 'N' 
				PRINT 'Inserted Records into #Temp_BV_Schedule_Transaction'	
				/***********************************Exception Over Runs**************/													
				PRINT 'Start Exception Over Runs Logic'	
					--Total_Over_Run
				DECLARE @BMS_Schedule_Process_Data_Code INT = 0
				
				SELECT  TOP 1 @BMS_Schedule_Process_Data_Code = ISNULL(TD.BV_Schedule_Transaction_Code,0)
				FROM #Temp_BMS_Acq_Run_Process_Data TD WHERE TD.Timeline_ID = @Timeline_ID_CV
				IF 
				(
					(
						SELECT ISNULL(COUNT(DISTINCT TBST.TimeLine_Id),0)
						FROM #Temp_BV_Schedule_Transaction TBST
					)
					> 
					(
						SELECT ISNULL(T.No_Of_Run,0) FROM #Temp_Acq_Run_Data T 
						WHERE T.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV AND ISNULL(T.No_Of_Run,0) > 0 
					)
				)					
				BEGIN											
					SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
					CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR),@Is_Error = 'Y' 
					FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'TOTAL_OVER_RUN' AND [Type] = 'S'
				END

				DECLARE @Is_Define_PrimeRun CHAR(1) = 'N',@Is_Define_OffPrimeRun CHAR(1) = 'N'
				SELECT @Is_Define_PrimeRun = CASE WHEN (ISNULL(TARD.Prime_Start_Time,'') <> '' OR ISNULL(TARD.Prime_End_Time,'') <> '')  THEN 'Y' ELSE 'N' END,
						@Is_Define_OffPrimeRun = CASE WHEN (ISNULL(TARD.Off_Prime_Start_Time,'') <> '' OR ISNULL(TARD.Off_Prime_End_Time,'') <> '')  THEN 'Y' ELSE 'N' END					 					
				FROM #Temp_Acq_Run_Data TARD 	
									
				PRINT ' Is_Define_PrimeRun : - ' + @Is_Define_PrimeRun 
				PRINT ' Is_Define_OffPrimeRun : - ' + @Is_Define_OffPrimeRun 
				/*********************************Start PrimeTime_Over_Run********************************/
				--Case --Prime over run  -- if Prime Time define and Prime Schedule Runs more then Allocated/Define Prime Runs then threw PRIMETIME_OVER_RUN Exception
				IF(ISNULL(@Is_Define_PrimeRun,'') = 'Y')
				BEGIN
					IF(	
						SELECT ISNULL(COUNT(DISTINCT TBST.TimeLine_Id),0) 
						FROM #Temp_BV_Schedule_Transaction TBST 
						WHERE 
						(
							(
							--Case if Prime and Off defination both are define
								(ISNULL(TBST.Is_Prime,'N') = 'Y' AND ISNULL(@Is_Prime_Time,'N') = 'Y')
								AND 
								(ISNULL(@Is_Define_PrimeRun,'') = 'Y' AND ISNULL(@Is_Define_OffPrimeRun,'') = 'Y')									
							)
							OR 
							(
								--Case only Prime defination are define
									((ISNULL(@Is_Define_PrimeRun,'') = 'Y' AND ISNULL(@Is_Define_OffPrimeRun,'') = 'N'))
							)
						)
						)
					>
					(SELECT ISNULL(T.Prime_Run,0) FROM #Temp_Acq_Run_Data T WHERE T.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV)
					BEGIN
					PRINT 'START PRIMETIME_OVER_RUN'
						SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +   ',' +
						CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR) ,@Is_Error = 'Y' 
						FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'PRIMETIME_OVER_RUN' AND [Type] = 'S'

						PRINT 'END PRIMETIME_OVER_RUN'
					END								 
				END
				/*********************************Start Outside Off Prime Time********************************/
				--OutSide Prime Time   - if only off Prime Time define and user schedule title in Prime Time 
				--then Threw Excpetion OUTSIDE OFF PRIME TIME**/
				IF(ISNULL(@Is_Define_OffPrimeRun,'N') = 'Y' AND ISNULL(@Is_Define_PrimeRun,'N') = 'N')
				BEGIN
					IF EXISTS(SELECT TOP 1 ISNULL(T.Is_Prime_Time,'N') FROM #Temp_BMS_Acq_Run_Process_Data T 
							WHERE ISNULL(T.Is_Prime_Time,'N') = 'Y')						 
					SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
					CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR) 
					FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'OUTSIDE OFF PRIME TIME' AND [Type] = 'S'
				END					
				/********************************Start OFFPRIMETIME_OVER_RUN********************************/
				--OffPrimeTime_Over_Run						
				--Case --Off Prime over run  -- if off Prime Time define and off Prime Schedule Runs more 
				--then Allocated/Define off Prime Runs then threw OFFPRIMETIME_OVER_RUN Exception
				IF(ISNULL(@Is_Define_OffPrimeRun,'') = 'Y')
				BEGIN						
					IF(SELECT ISNULL(COUNT(DISTINCT TBST.TimeLine_Id),0) FROM #Temp_BV_Schedule_Transaction TBST
						WHERE 
						(
							(
								--Case if Prime and Off defination both are define
								--(ISNULL(TBSR.Is_Prime,'N') = 'N' 
								(ISNULL(TBST.Is_Prime,'N') = 'N' AND ISNULL(@Is_Prime_Time,'N') = 'N')
								AND 
								(ISNULL(@Is_Define_OffPrimeRun,'') = 'Y' AND ISNULL(@Is_Define_PrimeRun,'') = 'Y')									
							) 
							OR 
							(
								--Case only Off defination are define 
									(( ISNULL(@Is_Define_OffPrimeRun,'') = 'Y' AND ISNULL(@Is_Define_PrimeRun,'') = 'N'))
							)
						)
						)
						> 
						(SELECT ISNULL(T.Off_Prime_Run,0) FROM #Temp_Acq_Run_Data T WHERE T.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV)--T.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV )
					BEGIN
						SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
						CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR),@Is_Error = 'Y'  
						FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'OFFPRIMETIME_OVER_RUN' AND [Type] = 'S'
					END
				END
					/*********************************Start Outside Prime Time********************************/
					--OutSide Prime Time   - if only Prime Time define and user schedule title in off Prime Time 
					--then Threw Excpetion OUTSIDE OFF PRIME TIME**/
					--Outside Prime Time
					IF(ISNULL(@Is_Define_PrimeRun,'N') = 'Y' AND ISNULL(@Is_Define_OffPrimeRun,'N') = 'N')
					BEGIN
					IF EXISTS(SELECT TOP 1 ISNULL(T.Is_Prime_Time,'N') FROM #Temp_BMS_Acq_Run_Process_Data T 
								WHERE ISNULL(T.Is_Prime_Time,'N') = 'N')						 
						SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
						CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR) 
						FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'OUTSIDE PRIME TIME' AND [Type] = 'S'												
					END					

					/***************Insert Exception Table *******************/
					--PRINT 'End Exception Over Runs Logic'	
					INSERT INTO #Temp_Email_Notification_Msg(Email_Notification_Msg_Code)
					SELECT number FROM fn_Split_withdelemiter(ISNULL(@Email_Notification_Msg_Code,'0'),',') WHERE number !=0

					IF EXISTS(SELECT TOP 1 * FROM #Temp_Email_Notification_Msg E WHERE ISNULL(E.Email_Notification_Msg_Code,0) > 0)
					BEGIN
						UPDATE BSE SET BSE.IsMailSent='N', BSE.Email_Notification_Msg_Code = ISNULL(T.Email_Notification_Msg_Code,0) FROM BMS_Schedule_Exception BSE 
						INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = BSE.BV_Schedule_Transaction_Code
						INNER JOIN #Temp_Email_Notification_Msg T ON 1=1
						AND BSE.Email_Notification_Msg_Code != ISNULL(T.Email_Notification_Msg_Code,0) AND @Is_Reprocess = 'Y'
						AND BST.BV_Schedule_Transaction_Code = @BMS_Schedule_Process_Data_Code AND BST.Timeline_ID = @Timeline_ID_CV  
						AND BST.File_Code = @BMS_Schedule_Log_Code

						IF NOT EXISTS(select * from BMS_Schedule_Exception WHERE BV_Schedule_Transaction_Code = @BMS_Schedule_Process_Data_Code)
						BEGIN
							INSERT INTO BMS_Schedule_Exception
							(
								BV_Schedule_Transaction_Code, Email_Notification_Msg_Code, IsMailSent
							)
							SELECT  @BMS_Schedule_Process_Data_Code, E.Email_Notification_Msg_Code, 'N'
							FROM #Temp_Email_Notification_Msg E WHERE ISNULL(E.Email_Notification_Msg_Code,0) > 0
						END											
					PRINT 'Inserted into BMS_Schedule_Exception'	
					END				
					/******************************Update Is_Processed in BMS_Schedule_Process_Data*******/					
					UPDATE BV_Schedule_Transaction SET IsProcessed = 'D',Last_Updated_Time=GETDATE() WHERE BV_Schedule_Transaction_Code = @BMS_Schedule_Process_Data_Code

					/******************************Update Is Error in BMS_Schedule_Process_Data*******/
					IF(ISNULL(@Is_Error,'N') = 'Y')
					BEGIN
						UPDATE BV_Schedule_Transaction SET IsException = 'Y' ,IsProcessed = 'D'
						WHERE  BV_Schedule_Transaction_Code = @BMS_Schedule_Process_Data_Code
					END

					/******************Call BMS_Schedule_Reprocess_Runs******/
					EXEC USP_BMS_Schedule_Reprocess_Runs @Channel_Code,'',@Content_Channel_Run_Code_CV
					PRINT 'Completed Reprocess of Runs USP_BMS_Schedule_Reprocess_Runs(call from USP_BMS_Schedule_Process)'

				RunCode_Zero:
				PRINT 'Content_Channel_Run_Code_CV :' + CAST(@Content_Channel_Run_Code_CV AS VARCHAR(10))
				PRINT 'Is Error :' + CAST(@Is_Error AS VARCHAR(10))
			END  --   --End if While Loop(CR_RR_Validation)

			FETCH NEXT FROM CR_RR_Validation INTO @BMS_Asset_Ref_Key_CV, @Timeline_ID_CV, @Schedule_Log_Date, @BMS_Schedule_Log_Code

		END -- -- While End(CR_RR_Validation)  
				                                        
		CLOSE CR_RR_Validation
		DEALLOCATE CR_RR_Validation
	END	
	PRINT '-----------------------End logic of USP_BMS_Schedule_Process-------------------------------'
	/*********************************Declare global variables ******************/
	END TRY			 
	BEGIN CATCH				
		PRINT 'Catch Block in USP_BMS_Schedule_Process'
		DECLARE @ErMessage NVARCHAR(MAX),@ErSeverity INT,@ErState INT 
		SELECT @ErMessage = 'Error in USP_BMS_Schedule_Process : - ' +  ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE() 
		RAISERROR (@ErMessage,@ErSeverity,@ErState)  
	END CATCH		

	IF OBJECT_ID('tempdb..#Acq_Deal_Right_Data') IS NOT NULL DROP TABLE #Acq_Deal_Right_Data
	IF OBJECT_ID('tempdb..#Acq_Dup_Rights') IS NOT NULL DROP TABLE #Acq_Dup_Rights
	IF OBJECT_ID('tempdb..#ErrorList') IS NOT NULL DROP TABLE #ErrorList
	IF OBJECT_ID('tempdb..#Temp_Acq_Run_Data') IS NOT NULL DROP TABLE #Temp_Acq_Run_Data
	IF OBJECT_ID('tempdb..#Temp_BMS_Acq_Run_Process_Data') IS NOT NULL DROP TABLE #Temp_BMS_Acq_Run_Process_Data
	IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Runs') IS NOT NULL DROP TABLE #Temp_BMS_Schedule_Runs
	IF OBJECT_ID('tempdb..#Temp_BV_Schedule_Transaction') IS NOT NULL DROP TABLE #Temp_BV_Schedule_Transaction
	IF OBJECT_ID('tempdb..#Temp_Email_Notification_Msg') IS NOT NULL DROP TABLE #Temp_Email_Notification_Msg
	IF OBJECT_ID('tempdb..#Temp_Right_Rule') IS NOT NULL DROP TABLE #Temp_Right_Rule
	IF OBJECT_ID('tempdb..#Temp_RR') IS NOT NULL DROP TABLE #Temp_RR
END	
/*
UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'P'
EXEC  USP_BMS_Schedule
*/