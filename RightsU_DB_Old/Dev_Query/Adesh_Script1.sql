USE [RightsU_BV_04May]
GO
/****** Object:  StoredProcedure [dbo].[USP_BMS_Schedule_Process]    Script Date: 7/25/2017 11:36:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_BMS_Schedule_Process]
(
	@BMS_Schedule_Process_Revert_UDT BMS_Schedule_Process_Revert_UDT READONLY
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
		IF OBJECT_ID('tempdb..#Temp_Acq_Run_YearWise_Data') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Acq_Run_YearWise_Data
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
	END
	/************************CREATE TEMP TABLES *********************/
	BEGIN
		CREATE TABLE #Acq_Deal_Right_Data
		(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Acq_Deal_Run_Code INT,
			BMS_Asset_Ref_Key INT
		)
		CREATE TABLE #Temp_BMS_Acq_Run_Process_Data
		(
			Acq_Deal_Run_Code INT ,BMS_Asset_Ref_Key INT ,BMS_Schedule_Process_Data_Code INT ,
			Channel_Code INT ,Date_Time DATETIME,Delete_Flag CHAR(1),Is_Ignore CHAR(1),Is_Prime_Time CHAR(1),
			Log_Date DATE,Timeline_ID INT
		) 
		CREATE TABLE #Temp_Email_Notification_Msg
		(
			Email_Notification_Msg_Code INT
		)

		CREATE TABLE #Temp_Acq_Run_Data
		(
			Acq_Deal_Run_Code INT,
			Is_Rule_Right CHAR(1),			
			Is_Yearwise_Definition CHAR(1),
			No_Of_Run INT,			
			No_Of_Days_Hrs INT,
			--No_Of_Run_Schedule INT,
			Off_Prime_Start_Time TIME,
			Off_Prime_End_Time TIME,
			--Off_Prime_Run_Schedule INT,
			Off_Prime_Run INT,
			Prime_Start_Time TIME,
			Prime_End_Time TIME,
			Prime_Run INT,			
			Repeat_Within_Days_Hrs  CHAR(1),
			Right_Rule_Code INT,
			Run_Definition_Type CHAR(1),
			--Prime_Run_Schedule INT,			
			Time_Lag_Simulcast TIME						 
		)			
		CREATE TABLE #Temp_BMS_Schedule_Runs
		(			
			Acq_Deal_Run_Code INT,
			BMS_Schedule_Runs_Code INT,
			Channel_Code INT,
			Is_Ignore CHAR(1),
			Is_Prime CHAR(1),
			Log_Date DATE,
			TimeLine_Id INT
		)	
		CREATE TABLE #Temp_Acq_Run_YearWise_Data
		(
			Acq_Deal_Run_Code INT,
			[Start_Date] DATETIME,
			End_date DATETIME,
			No_Of_Run INT			
		)		
		CREATE TABLE #Temp_Right_Rule
		(
			BMS_Schedule_Run_Code INT,
			Is_Ignore CHAR(1),
			Ref_TimeLine_ID INT,
			Schedule_DateTime DATETIME,
			TimeLine_ID INT,
			PlayDay INT,
			PlayRun INT
		)		
		
	END
	--select * from @BMS_Schedule_Process_Revert_UDT
	/************* Start Cursor*/
	BEGIN 		
		/*********************************Declare global variables ******************/		
		DECLARE @Channel_Code INT = 0,@BMS_Schedule_Log_Code INT  = 0
		DECLARE @BMS_Asset_Ref_Key_CV INT = 0,@Timeline_ID_CV INT = 0
		SELECT TOP 1 @Channel_Code = BSUDT.Channel_Code,@BMS_Schedule_Log_Code = BSUDT.BMS_Schedule_Log_Code 
		FROM @BMS_Schedule_Process_Revert_UDT BSUDT 

		DECLARE CR_RR_Validation CURSOR       
		FOR 
			SELECT DISTINCT BSUDT.BMS_Asset_Ref_Key,BSUDT.Timeline_ID
			FROM @BMS_Schedule_Process_Revert_UDT BSUDT
		OPEN CR_RR_Validation  
		FETCH NEXT FROM CR_RR_Validation INTO @BMS_Asset_Ref_Key_CV,@Timeline_ID_CV
		WHILE @@FETCH_STATUS<>-1 
		BEGIN                                              
			IF(@@FETCH_STATUS<>-2)    --if While Loop(CR_RR_Validation)                                          
			BEGIN
			--SELECT @Timeline_ID_CV Timeline_ID 
				PRINT '-------In Cursor CR_RR_Validation and TimeLine ID is : - '	+ CAST (@Timeline_ID_CV AS VARCHAR(10))		 
				--SELECT 'sagar',* FROM BMS_Schedule_Runs
				--SELECT 'sagar',* FROM BMS_Schedule_Process_Data
				--SET @Right_Rule_Code_CV = 3012
				/**********************************************Truncate Tables**********/
				TRUNCATE TABLE #Temp_BMS_Acq_Run_Process_Data
				TRUNCATE TABLE #Temp_Acq_Run_Data
				TRUNCATE TABLE #Temp_Email_Notification_Msg
				TRUNCATE TABLE #Temp_BMS_Schedule_Runs
				TRUNCATE TABLE #Temp_Acq_Run_YearWise_Data
				TRUNCATE TABLE #Acq_Deal_Right_Data
				TRUNCATE TABLE #Temp_Right_Rule
				/************************************************* Start FIFO logic***********/
				PRINT 'Start FIFO logic'
				DECLARE @Count_UDT INT = 0
				SELECT @Count_UDT = COUNT(BSPRU.Acq_Deal_Code) FROM @BMS_Schedule_Process_Revert_UDT BSPRU 
				WHERE ISNULL(BSPRU.Is_In_Right_Perod,'N') = 'Y' 
				AND BSPRU.Timeline_ID = @Timeline_ID_CV AND BSPRU.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code 
				 
				INSERT INTO #Acq_Deal_Right_Data(Acq_Deal_Code,Acq_Deal_Rights_Code,Acq_Deal_Run_Code,BMS_Asset_Ref_Key)
				SELECT DISTINCT 
					BSPDT.Acq_Deal_Code,BSPDT.Acq_Deal_Rights_Code,BSPDT.Acq_Deal_Run_Code,BSPDT.BMS_Asset_Ref_Key 
				FROM @BMS_Schedule_Process_Revert_UDT BSPDT				 
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
								ISNULL(BSPDT.No_Of_Runs,0) > --ISNULL(BSPDT.No_Of_Runs_Sched,0))						
								(
									SELECT ISNULL(COUNT(DISTINCT BSR.Timeline_ID),0)  AS No_Of_Runs_Sched
									FROM BMS_Schedule_Runs BSR 
									WHERE BSR.Acq_Deal_Run_Code = BSPDT.Acq_Deal_Run_Code AND ISNULL(BSR.Is_Ignore,'N') = 'N'
									AND ISNULL(BSR.Acq_Deal_Run_Code,0) > 0 AND ISNULL(BSR.Channel_Code,0) > 0 
								)
							)
						) --Shared/NA  Run Definaition Type
						AND 
						(
							(BSPDT.Run_Definition_Type = 'S' OR BSPDT.Run_Definition_Type= 'N')
						)
						OR 
						(
							(
								BSPDT.Run_Type ='U' 
								OR 
								(
									ISNULL(BSPDT.ChannelWise_NoOfRuns,0) >  --ISNULL(BSPDT.ChannelWise_NoOfRuns_Schedule,0))
									(
										SELECT ISNULL(COUNT(DISTINCT BSR.Timeline_ID),0)  AS ChannelWise_NoOfRuns_Schedule
										FROM BMS_Schedule_Runs BSR 
										WHERE BSR.Acq_Deal_Run_Code = BSPDT.Acq_Deal_Run_Code AND BSR.Channel_Code = BSPDT.Channel_Code
										AND ISNULL(BSR.Is_Ignore,'N') = 'N' AND ISNULL(BSR.Acq_Deal_Run_Code,0) > 0 
										AND ISNULL(BSR.Channel_Code,0) > 0
									)
								)
							) --Channel Wise Run Definaition Type
							AND 
							( 
									(BSPDT.Run_Definition_Type = 'C' OR BSPDT.Run_Definition_Type = 'CS')
							) 
						)
					)
				  )
				  --IF(@Timeline_ID_CV = 1052053545)
				  --BEGIN
					 -- SELECT 'sagar1',* FROM @BMS_Schedule_Process_Revert_UDT BSPDT  
					 -- SELECT 'sagar2',* FROM #Acq_Deal_Right_Data BSPDT 
				  --END
				IF EXISTS (SELECT TOP 1 Acq_Deal_Code FROM #Acq_Deal_Right_Data)
				BEGIN
					DECLARE @Multiple_Rights_Found INT = 0
											
					SELECT @Multiple_Rights_Found =COUNT(ADR.Acq_Deal_Rights_Code) 
					FROM #Acq_Deal_Right_Data ADR 

					IF(ISNULL(@Multiple_Rights_Found,0) > 1)
					BEGIN
						PRINT '---------------Multiple Rights Found----------------------'
						DELETE FROM #Acq_Deal_Right_Data WHERE Acq_Deal_Rights_Code NOT IN
						(
							SELECT MIN(ADR.Acq_Deal_Rights_Code) FROM #Acq_Deal_Right_Data ADR							
						)	
					END					

					UPDATE BSPDT SET BSPDT.Acq_Deal_Code = temp.Acq_Deal_Code,BSPDT.Acq_Deal_Run_Code =temp.Acq_Deal_Run_Code,			
					BSPDT.Is_Error = 'N',BSPDT.Is_Deal_Approved = 'Y'
					FROM BMS_Schedule_Process_Data_Temp BSPDT
					INNER JOIN #Acq_Deal_Right_Data temp ON BSPDT.Timeline_ID = @Timeline_ID_CV 
					AND BSPDT.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code AND BSPDT.BMS_Asset_Ref_Key = temp.BMS_Asset_Ref_Key

					PRINT 'Updated Acq Deal_Code ,Run Code in BMS_Schedule_Process_Data_Temp'

			     END						
				 --IF(@Timeline_ID_CV = 1052053545)
				 -- BEGIN					  
					--  SELECT 'sagar3',* FROM #Acq_Deal_Right_Data BSPDT 
				 -- END				 
				PRINT 'End FIFO logic'
				DECLARE @Email_Notification_Msg_Code VARCHAR(100) = '0'

				--SELECT 'sagar1', * FROM #Acq_Deal_Right_Data  ADR WHERE ISNULL(ADR.BMS_Asset_Ref_Key,0) > 0
				--SELECT 'sagar2', * FROM @BMS_Schedule_Process_Revert_UDT  
				
				/*************************************************Excpetion OutSide Rights Period***********/							
				DECLARE @Is_Error CHAR(1) = 'N'		
				IF NOT EXISTS(SELECT TOP  1 * FROM #Acq_Deal_Right_Data ADR WHERE ISNULL(ADR.BMS_Asset_Ref_Key,0) > 0)-- no record in #Acq_Deal_Right_Data
				BEGIN
						IF EXISTS(SELECT TOP 1 T.Timeline_ID FROM @BMS_Schedule_Process_Revert_UDT T 
									WHERE ISNULL(T.Is_In_Right_Perod,'N') = 'N' 
									AND T.Timeline_ID = @Timeline_ID_CV 								
								)
						BEGIN
							PRINT ' ----------Threw OutSide Right Period Exception------------' 							 
							SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code ,@Is_Error = 'Y'
							FROM Email_Notification_Msg WHERE  UPPER(Email_Msg_For) = 'Right_Period' AND [Type] = 'S'
						END					

						UPDATE BSPDT SET BSPDT.Acq_Deal_Code = temp.Acq_Deal_Code,BSPDT.Acq_Deal_Run_Code =temp.Acq_Deal_Run_Code,
						BSPDT.Is_Error = 'Y',BSPDT.Is_Deal_Approved = 'Y'							
						FROM BMS_Schedule_Process_Data_Temp BSPDT
						INNER JOIN @BMS_Schedule_Process_Revert_UDT temp ON BSPDT.Timeline_ID = @Timeline_ID_CV 
						AND BSPDT.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code AND BSPDT.BMS_Asset_Ref_Key = temp.BMS_Asset_Ref_Key 
						AND Is_In_Right_Perod = 'N'
										
						PRINT 'Updated Acq Deal_Code ,Run Code in BMS_Schedule_Process_Data_Temp (OutSide Rights Period)'			

				END
				/*************************************Insert Record BMS_Schedule_Process_Data_Temp*******/
							
				INSERT BMS_Schedule_Process_Data
				(
					Acq_Deal_Code,Acq_Deal_Run_Code,
					BMS_Asset_Ref_Key,BMS_Schedule_Log_Code ,								
					Date_Time,DealContent_RightId ,
					Delete_Flag ,
					Inserted_On ,Is_Error ,
					Is_Processed, 								
					Log_Date,Play_Day ,
					Play_Run ,Program_VersionId,Record_Type,
					SYSLookupId_PlayCountError,Title_Code ,								
					Timeline_ID 
				)
				SELECT Acq_Deal_Code,Acq_Deal_Run_Code,
					BMS_Asset_Ref_Key,BMS_Schedule_Log_Code ,								
					CAST(CAST(Date_Time AS DATETIME2) AS DATETIME),DealContent_RightId ,
					Delete_Flag ,
					Inserted_On ,Is_Error ,
					'D' AS Is_Processed,
					CAST(Log_Date AS DATE),Play_Day ,
					Play_Run ,Program_VersionId,'S' AS Record_Type,
					SYSLookupId_PlayCountError,Title_Code ,								
					Timeline_ID 
				FROM BMS_Schedule_Process_Data_Temp BSPDT
				WHERE BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code  AND BSPDT.Timeline_ID IN(
					@Timeline_ID_CV
				)
				AND 
				(
					(
						BSPDT.Acq_Deal_Run_Code IN(
							SELECT ADR.Acq_Deal_Run_Code FROM #Acq_Deal_Right_Data ADR	
						)
					)
					OR
					(
						0 = (SELECT ISNULL(COUNT(ADR.Acq_Deal_Run_Code),0) FROM #Acq_Deal_Right_Data ADR)	--IF OutSide Rights Period
					)
				)
				AND 
				(
					BSPDT.Timeline_ID NOT IN
					(
						SELECT ISNULL(BSP.Timeline_ID,0) 
						FROM BMS_Schedule_Process_Data BSP WHERE ISNULL(BSP.Timeline_ID,0) > 0 
						AND ISNULL(BSP.BMS_Schedule_Log_Code,0) > 0
						UNION 
						SELECT 0 AS Timeline_ID
					)
				)

				PRINT  'Inserted into BMS_Schedule_Process_Data'
				--SELECT 'sagar3', * FROM BMS_Schedule_Process_Data 
			
				IF EXISTS(SELECT TOP 1 T.Timeline_ID FROM @BMS_Schedule_Process_Revert_UDT T 
							WHERE ISNULL(T.Is_In_BlackOut_Period,'N') = 'Y' AND ISNULL(T.Is_In_Right_Perod,'N') = 'Y'
							AND T.Timeline_ID = @Timeline_ID_CV 								
							)
				BEGIN
						PRINT ' ----------Threw Black Right Period Exception------------' 						
						SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code ,@Is_Error = 'Y'
						FROM Email_Notification_Msg WHERE  UPPER(Email_Msg_For) = 'BLACKOUT_RIGHT_PERIOD' AND [Type] = 'S'												
						
				END				
				IF(ISNULL(@Email_Notification_Msg_Code,0) > 0 AND ISNULL(@Is_Error,'N') = 'Y')
				BEGIN					
					INSERT INTO BMS_Schedule_Exception
					(
						BMS_Schedule_Process_Data_Code,Email_Notification_Msg_Code
					)
					SELECT DISTINCT 
						BSPD.BMS_Schedule_Process_Data_Code,ISNULL(@Email_Notification_Msg_Code,0)
					FROM BMS_Schedule_Process_Data BSPD  					
					WHERE BSPD.Timeline_ID = @Timeline_ID_CV  AND BSPD.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code

					GOTO RunCode_Zero
				END
				/*****************/
				DECLARE @Acq_Deal_Run_Code_CV INT = 0
				
				SELECT @Acq_Deal_Run_Code_CV  = ISNULL(ADR.Acq_Deal_Run_Code,0) 
				FROM #Acq_Deal_Right_Data ADR

				IF(ISNULL(@Acq_Deal_Run_Code_CV,0) = 0)
				BEGIN
					GOTO RunCode_Zero
				END
				/***************************************Insert Acq Deal Run data into Temp_Acq_Run_Data**********/
				INSERT INTO  #Temp_Acq_Run_Data
					(
						Acq_Deal_Run_Code ,
						Is_Rule_Right,
						Is_Yearwise_Definition,
						No_Of_Run,			
						No_Of_Days_Hrs,			
						Off_Prime_Start_Time ,
						Off_Prime_End_Time ,
						Off_Prime_Run,
						Prime_Start_Time ,
						Prime_End_Time ,
						Prime_Run,
						Repeat_Within_Days_Hrs,
						Right_Rule_Code,
						Run_Definition_Type,
						Time_Lag_Simulcast						
					)
				SELECT	ADR.Acq_Deal_Run_Code ,
					ADR.Is_Rule_Right,
					ISNULL(ADR.Is_Yearwise_Definition,'N'), 
					ADR.No_Of_Runs,		
					ADR.No_Of_Days_Hrs,			
					ADR.Off_Prime_Start_Time ,
					ADR.Off_Prime_End_Time ,
					ADR.Off_Prime_Run,
					ADR.Prime_Start_Time ,
					ADR.Prime_End_Time ,
					ADR.Prime_Run,
					ADR.Repeat_Within_Days_Hrs,
					ADR.Right_Rule_Code,
					ISNULL(ADR.Run_Definition_Type,'N'),
					ADR.Time_Lag_Simulcast 
				FROM Acq_Deal_Run ADR 
				WHERE ADR.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV
				PRINT 'Inserted Records into #Temp_Acq_Run_Data'				
				/***********************************Insert into  #Temp_BMS_Acq_Run_Process_Data******/
					INSERT INTO #Temp_BMS_Acq_Run_Process_Data
					(
						Acq_Deal_Run_Code,BMS_Asset_Ref_Key,BMS_Schedule_Process_Data_Code,
						Channel_Code,Date_Time,Delete_Flag,Is_Ignore,Is_Prime_Time,
						Log_Date,Timeline_ID
					)
					SELECT DISTINCT @Acq_Deal_Run_Code_CV,BSPD.BMS_Asset_Ref_Key,BSPD.BMS_Schedule_Process_Data_Code,
						@Channel_Code AS Channel_Code,BSPD.Date_Time,'N' AS Delete_Flag,'N' AS Is_Ignore,
						'N' Is_Prime_Time,
						BSPD.Log_Date,BSPD.Timeline_ID
					FROM BMS_Schedule_Process_Data BSPD 
					INNER JOIN #Temp_Acq_Run_Data TARD ON BSPD.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
					WHERE BSPD.Timeline_ID = @Timeline_ID_CV AND BSPD.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code

					/*************Write Prime / off Prime Time Logic*****/
					DECLARE @Is_Prime_Time CHAR(1) = 'N'						
					--Case 1 When IF define only Prime Time
					IF EXISTS (SELECT TOP 1 TARD.Acq_Deal_Run_Code FROM #Temp_Acq_Run_Data TARD 
							WHERE ISNULL(TARD.Acq_Deal_Run_Code,0) > 0 AND ISNULL(TARD.Prime_Start_Time,'') <> '' 
							AND ISNULL(TARD.Off_Prime_Start_Time,'') = ''
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
							INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
							WHERE CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108) >  CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)

							SELECT 
							@Is_Prime_Time = CASE WHEN 							
							CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
							BETWEEN 
							CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108) AND CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)
							THEN 'Y' ELSE 'N'
							END 
							FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
							INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
							WHERE CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108) <  CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)
						END
						--Case 2 IF define only off Time
					ELSE IF EXISTS (SELECT TOP 1 TARD.Acq_Deal_Run_Code FROM #Temp_Acq_Run_Data TARD 
							WHERE ISNULL(TARD.Acq_Deal_Run_Code,0) > 0 AND ISNULL(TARD.Off_Prime_Start_Time,'') <> ''
							AND ISNULL(TARD.Prime_Start_Time,'') = '' 						)
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
							INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
							WHERE CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) >  CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)						

							SELECT 
							@Is_Prime_Time = CASE WHEN 							
							CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
							BETWEEN 
							CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) AND CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)
							THEN 'N' ELSE 'Y'
							END 
							FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
							INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
							WHERE CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) <  CONVERT(VARCHAR(8),TARD.Off_Prime_End_Time,108)
							--SELECT '2 When IF define only off Prime Time',@Is_Prime_Time AS Is_Prime_Time
						END
						--Case 3 Prime and Off Prime Time Both Not Define in Run Defination
					ELSE IF EXISTS (SELECT TOP 1 TARD.Acq_Deal_Run_Code FROM #Temp_Acq_Run_Data TARD 
							WHERE ISNULL(TARD.Acq_Deal_Run_Code,0) > 0 AND ISNULL(TARD.Off_Prime_Start_Time,'') = ''
							AND ISNULL(TARD.Prime_Start_Time,'') = '' )
						BEGIN						
							SELECT @Is_Prime_Time = 'N'							
						--	SELECT '3  Prime and Off Prime Time Both Not Define in Run Defination',@Is_Prime_Time AS Is_Prime_Time
						END
					--Case 4  Prime and Off Prime (both) Define in Run Defination
					ELSE IF EXISTS (SELECT TOP 1 TARD.Acq_Deal_Run_Code FROM #Temp_Acq_Run_Data TARD 
							WHERE ISNULL(TARD.Acq_Deal_Run_Code,0) > 0 AND ISNULL(TARD.Off_Prime_Start_Time,'') <> ''
							AND ISNULL(TARD.Prime_Start_Time,'') <> '' )
						BEGIN						
							---Case 4.1 Prime Start Time < Off Prime Start Time
							SELECT 
							@Is_Prime_Time = CASE WHEN 
							CONVERT(VARCHAR(8),CAST(TBARP.Date_Time AS DATETIME2),108)
							BETWEEN 
							CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108)  AND CONVERT(VARCHAR(8),TARD.Prime_End_Time,108)
							THEN 'Y' ELSE 'N'
							END 
							FROM #Temp_BMS_Acq_Run_Process_Data TBARP 
							INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
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
							INNER JOIN #Temp_Acq_Run_Data TARD ON TBARP.Acq_Deal_Run_Code = TARD.Acq_Deal_Run_Code
							AND CONVERT(VARCHAR(8),TARD.Off_Prime_Start_Time,108) <  CONVERT(VARCHAR(8),TARD.Prime_Start_Time,108)

							--SELECT '4  Prime and Off Prime Time Both are Define in Run Defination',@Is_Prime_Time AS Is_Prime_Time
						END
					
					IF(ISNULL(@Is_Prime_Time,'N') = 'Y')
					BEGIN
						UPDATE  #Temp_BMS_Acq_Run_Process_Data SET Is_Prime_Time = ISNULL(@Is_Prime_Time,'N') 
						WHERE Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV
					END
				--	SELECT @Is_Prime_Time AS Is_Prime_Time
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
							INNER JOIN #Temp_BMS_Acq_Run_Process_Data TD ON TARD.Acq_Deal_Run_Code = TD.Acq_Deal_Run_Code  
							AND TARD.Acq_Deal_Run_Code =@Acq_Deal_Run_Code_CV 

							SELECT @Parent_Channel_Code = ISNULL(C.Parent_Channel_Code,0) FROM Channel C WHERE C.Channel_Code = @Channel_Code

							IF EXISTS (SELECT TOP 1 BSR.Acq_Deal_Run_Code FROM BMS_Schedule_Runs BSR WHERE BSR.Channel_Code = @Parent_Channel_Code AND 
										BSR.Date_Time BETWEEN @TimeLag_StartTime AND @TimeLag_EndTime)
							BEGIN
								SET @Is_Ignore = 'Y'
							END																	
						END
					END -- End SimulCast
					PRINT 'End SimulCast'	
					
				IF EXISTS(SELECT TOP 1 * FROM  BMS_Schedule_Runs BSR WHERE ISNULL(BSR.Timeline_ID,0) = ISNULL(@Timeline_ID_CV,0))
				BEGIN
				--Update in Case of Deal Rollback
					UPDATE BSR SET BSR.Is_Prime = ISNULL(TBARP.Is_Prime_Time,'N')--,BSR.Is_Ignore = ISNULL(@Is_Ignore,'N')
					FROM BMS_Schedule_Runs BSR
					INNER JOIN #Temp_BMS_Acq_Run_Process_Data TBARP ON BSR.Timeline_ID = TBARP.Timeline_ID 
					AND BSR.Acq_Deal_Run_Code = TBARP.Acq_Deal_Run_Code AND BSR.BMS_Asset_Ref_Key = TBARP.BMS_Asset_Ref_Key 
				END
				/**********************************Insert BMS_Schedule_Runs ****************/									
				INSERT INTO BMS_Schedule_Runs
				(
					Acq_Deal_Run_Code,BMS_Asset_Ref_Key,BMS_Schedule_Process_Data_Code,
					Channel_Code,Date_Time,Delete_Flag,Inserted_On,Is_Ignore,Is_Prime,
					Log_Date,Record_Type,Timeline_ID
				)
				SELECT DISTINCT @Acq_Deal_Run_Code_CV,BSPD.BMS_Asset_Ref_Key,BSPD.BMS_Schedule_Process_Data_Code,
					@Channel_Code AS Channel_Code,BSPD.Date_Time,'N' AS Delete_Flag,GETDATE() AS Inserted_On,ISNULL(@Is_Ignore,'N') AS Is_Ignore,
					ISNULL(BSPD.Is_Prime_Time,'N'),BSPD.Log_Date,'S'  AS Record_Type,BSPD.Timeline_ID
				FROM #Temp_BMS_Acq_Run_Process_Data BSPD
				WHERE BSPD.Timeline_ID NOT IN
				(
					SELECT ISNULL(BSR.Timeline_ID,0) FROM BMS_Schedule_Runs BSR WHERE ISNULL(BSR.Timeline_ID,0) > 0
					UNION
					SELECT 0 AS Timeline_ID
				)		
							
				--select @Is_Ignore
				--SELECT bspd.Play_Day,* 
				--FROM BMS_Schedule_Process_Data bspd
				----INNER JOIN BMS_Schedule_Runs bsr ON bsr.BMS_Schedule_Process_Data_Code = bspd.BMS_Schedule_Process_Data_Code
				--WHERE bspd.Title_Code = 14586 AND bspd.Acq_Deal_Run_Code = 10987 --AND Channel_Code=24
					/*********************EXECUTE USP_BMS_Schedule_Right_Rule_Run_Process****************/				
					IF(@Is_Ignore = 'N')
					BEGIN
						IF EXISTS (SELECT TOP 1 T.Right_Rule_Code FROM #Temp_Acq_Run_Data T WHERE ISNULL(T.Is_Rule_Right,'N') = 'Y')					
						BEGIN		
						PRINT 'SELECT from BMS_Schedule_Runs'
						INSERT INTO #Temp_Right_Rule
						EXEC USP_BMS_Schedule_Right_Rule_Run_Process @Acq_Deal_Run_Code_CV,'P',@Channel_Code,@Timeline_ID_CV
						--select @Acq_Deal_Run_Code_CV,'P',@Channel_Code,@Timeline_ID_CV
						--SELECT 'sagar',* FROM #Temp_Right_Rule
						--SELECT 'After_Update_Delete',* FROM  #Temp_Right_Rule	
						--select * from #Temp_Right_Rule
						--select @Acq_Deal_Run_Code_CV,'P',@Channel_Code,@Timeline_ID_CV	
						--select * from BMS_Schedule_Runs where BMS_Schedule_Process_Data_Code IN(1026,1027)
						END--End if Right Rule
					ELSE
						BEGIN
						PRINT '@Is_Ignore = '+@Is_Ignore
							--DECLARE @Title_Code VARCHAR(1000),@PlayDay INT
							--SELECT TOP 1 @Title_Code=Title_Code FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code=@Acq_Deal_Run_Code_CV

							--INSERT INTO #Temp_Right_Rule(BMS_Schedule_Run_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,PlayDay,PlayRun)
							--SELECT bsr.BMS_Schedule_Runs_Code,'N',bspd.Date_Time,bspd.Timeline_ID,NULL,NULL,NULL FROM BMS_Schedule_Process_Data bspd
							--INNER JOIN BMS_Schedule_Runs bsr ON bsr.BMS_Schedule_Process_Data_Code = bspd.BMS_Schedule_Process_Data_Code
							--WHERE bspd.Title_Code = @Title_Code AND bspd.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV AND BSR.Channel_Code=@Channel_Code

							
							--SELECT TOP 1 @PlayDay=ISNULL(bspd.Play_Day,0)+1 
							--FROM BMS_Schedule_Process_Data bspd
							--INNER JOIN BMS_Schedule_Runs bsr ON bsr.BMS_Schedule_Process_Data_Code = bspd.BMS_Schedule_Process_Data_Code
							--WHERE bspd.Title_Code = @Title_Code AND bspd.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV 
							--AND Convert(DateTime,bspd.Date_Time,101) <= (
							--	SELECT MAX(Convert(DateTime,bspd1.Date_Time,101)) 
							--	FROM BMS_Schedule_Process_Data bspd1
							--	INNER JOIN BMS_Schedule_Runs bsr1 ON bsr1.BMS_Schedule_Process_Data_Code = bspd1.BMS_Schedule_Process_Data_Code
							--	WHERE bspd1.Title_Code = @Title_Code 
							--	AND bspd1.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV 
							--	AND bsr1.Channel_Code=@Channel_Code
							--	--AND Convert(DateTime,bspd1.Date_Time,101)!=Convert(DateTime,bspd.Date_Time,101)
							--)
							--AND BSR.Channel_Code=@Channel_Code order by Convert(DateTime,bspd.Date_Time,101) desc

							--update #Temp_Right_Rule SET PlayDay=@PlayDay,PlayRun=1

							DECLARE @Title_Code VARCHAR(1000),@PlayDay INT
							SELECT TOP 1 @Title_Code=Title_Code FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code=@Acq_Deal_Run_Code_CV
							IF OBJECT_ID('tempdb..#Temp_RR') IS NOT NULL
							BEGIN
								DROP TABLE #Temp_RR
							END	
							CREATE TABLE #Temp_RR
							(
								RowNum INT,
								BMS_Schedule_Run_Code INT,
								Is_Ignore CHAR(1),
								Ref_TimeLine_ID INT,
								Schedule_DateTime DATETIME,
								TimeLine_ID INT,
								PlayDay INT,
								PlayRun INT
							)	

							INSERT INTO #Temp_RR(RowNum,BMS_Schedule_Run_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,PlayDay,PlayRun)
							SELECT ROW_NUMBER() OVER(ORDER BY bspd.Date_Time) RowNumber,bsr.BMS_Schedule_Runs_Code,'N',bspd.Date_Time,bspd.Timeline_ID,NULL,NULL,NULL FROM BMS_Schedule_Process_Data bspd
							INNER JOIN BMS_Schedule_Runs bsr ON bsr.BMS_Schedule_Process_Data_Code = bspd.BMS_Schedule_Process_Data_Code
							WHERE bspd.Title_Code = @Title_Code AND bspd.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV AND BSR.Channel_Code=@Channel_Code
							ORDER BY bspd.Date_Time
							--SELECT TOP 1 @PlayDay=ISNULL(bspd.Play_Day,0)+1 
							--FROM BMS_Schedule_Process_Data bspd
							--INNER JOIN BMS_Schedule_Runs bsr ON bsr.BMS_Schedule_Process_Data_Code = bspd.BMS_Schedule_Process_Data_Code
							--WHERE bspd.Title_Code = @Title_Code AND bspd.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV 
							--AND Convert(DateTime,bspd.Date_Time,101) <= (
							--	SELECT MAX(Convert(DateTime,bspd1.Date_Time,101)) 
							--	FROM BMS_Schedule_Process_Data bspd1
							--	INNER JOIN BMS_Schedule_Runs bsr1 ON bsr1.BMS_Schedule_Process_Data_Code = bspd1.BMS_Schedule_Process_Data_Code
							--	WHERE bspd1.Title_Code = @Title_Code 
							--	AND bspd1.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV 
							--	AND bsr1.Channel_Code=@Channel_Code
							--	--AND Convert(DateTime,bspd1.Date_Time,101)!=Convert(DateTime,bspd.Date_Time,101)
							--)
							--AND BSR.Channel_Code=@Channel_Code order by Convert(DateTime,bspd.Date_Time,101) desc

							INSERT INTO #Temp_Right_Rule(BMS_Schedule_Run_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,PlayDay,PlayRun)
							select BMS_Schedule_Run_Code,'N',Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,RowNum,1 AS PlayRun
							from #Temp_RR
							--update #Temp_Right_Rule SET PlayDay=@PlayDay,PlayRun=1
							IF OBJECT_ID('tempdb..#Temp_RR') IS NOT NULL
							BEGIN
								DROP TABLE #Temp_RR
							END	
						END
						
					--SELECT 'sagar',* FROM #Temp_Acq_Run_Data								
					END

					--SELECT * FROM #Temp_Right_Rule
						
				--SELECT * 
				if EXISTS(SELECT * FROM #Temp_Right_Rule)
				BEGIN
					PRINT 'Update IsIgnore Flag BMS_Schedule_Runs'
					UPDATE BSR SET BSR.Is_Ignore = TRR.Is_Ignore,BSR.Ref_Timeline_ID = TRR.Ref_TimeLine_ID
					FROM BMS_Schedule_Runs BSR
					INNER JOIN #Temp_Right_Rule TRR 
					ON TRR.TimeLine_ID = BSR.Timeline_ID AND ISNULL(@Is_Ignore,'N') = 'N'	
							
					PRINT 'Update PlayDay PlayRun BMS_Schedule_Process_Data'
					UPDATE BSPD SET BSPD.Play_Day=TRR.PlayDay,BSPD.Play_Run=TRR.PlayRun,BSPD.Last_Updated_Time=GETDATE()
					FROM BMS_Schedule_Runs BSR
					INNER JOIN #Temp_Right_Rule TRR 
					ON TRR.TimeLine_ID = BSR.Timeline_ID 
					INNER JOIN BMS_Schedule_Process_Data BSPD 
					ON BSPD.Timeline_ID=BSR.Timeline_ID 
					AND BSPD.BMS_Schedule_Process_Data_Code=BSR.BMS_Schedule_Process_Data_Code
				END
				ELSE IF(@Is_Ignore = 'Y')
				BEGIN
					UPDATE BMS_Schedule_Runs  SET Is_Ignore = @Is_Ignore,Ref_Timeline_ID = NULL
					where Timeline_ID=@Timeline_ID_CV
							
					PRINT 'Update PlayDay PlayRun BMS_Schedule_Process_Data'
					UPDATE BSPD SET BSPD.Play_Day=0,BSPD.Play_Run=0,BSPD.Last_Updated_Time=GETDATE()
					FROM BMS_Schedule_Runs BSR
					INNER JOIN BMS_Schedule_Process_Data BSPD 
					ON BSPD.Timeline_ID=BSR.Timeline_ID AND BSPD.BMS_Schedule_Process_Data_Code=BSR.BMS_Schedule_Process_Data_Code
					where BSPD.Timeline_ID=@Timeline_ID_CV
				END
				ELSE
				BEGIN
					UPDATE BMS_Schedule_Runs  SET Is_Ignore = NULL,Ref_Timeline_ID = NULL
					where Timeline_ID=@Timeline_ID_CV
							
					PRINT 'Update PlayDay PlayRun BMS_Schedule_Process_Data'
					UPDATE BSPD SET BSPD.Play_Day=1,BSPD.Play_Run=1,BSPD.Last_Updated_Time=GETDATE()
					FROM BMS_Schedule_Runs BSR
					INNER JOIN BMS_Schedule_Process_Data BSPD 
					ON BSPD.Timeline_ID=BSR.Timeline_ID AND BSPD.BMS_Schedule_Process_Data_Code=BSR.BMS_Schedule_Process_Data_Code
					where BSPD.Timeline_ID=@Timeline_ID_CV
				END
				
				----In  Case of SimulCast
				--IF(ISNULL(@Is_Ignore,'N') = 'Y') 
				--BEGIN
				--	UPDATE BMS_Schedule_Runs SET Is_Ignore = 'Y' WHERE Timeline_ID = @Timeline_ID_CV
				--END
																
				PRINT 'Inserted Records into BMS_Schedule_Runs'	
					/**********Insert into #Temp_BMS_Schedule_Runs**************/
					INSERT INTO #Temp_BMS_Schedule_Runs
					(
						Acq_Deal_Run_Code,
						BMS_Schedule_Runs_Code,
						Channel_Code,
						Is_Ignore,
						Is_Prime,
						Log_Date ,
						Timeline_ID
					)
					SELECT BSR.Acq_Deal_Run_Code,
						BSR.BMS_Schedule_Runs_Code,
						BSR.Channel_Code,
						BSR.Is_Ignore,
						BSR.Is_Prime,
						BSR.Log_Date,
						BSR.Timeline_ID
					FROM BMS_Schedule_Runs BSR
					WHERE BSR.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV AND ISNULL(BSR.Is_Ignore,'N') = 'N' 
				PRINT 'Inserted Records into #Temp_BMS_Schedule_Runs'	
				/***********************************Exception Over Runs**************/													
				PRINT 'Start Exception Over Runs Logic'	
					--Total_Over_Run
					DECLARE @BMS_Schedule_Process_Data_Code INT = 0
					SET @Email_Notification_Msg_Code = 0
					SELECT  TOP 1 @BMS_Schedule_Process_Data_Code = ISNULL(TD.BMS_Schedule_Process_Data_Code,0)
					FROM #Temp_BMS_Acq_Run_Process_Data TD WHERE TD.Timeline_ID = @Timeline_ID_CV
					IF 
					(
						(
							SELECT ISNULL(COUNT(DISTINCT TBSR.TimeLine_Id),0) 
							FROM #Temp_BMS_Schedule_Runs TBSR
						)
						> 
						(
							SELECT ISNULL(T.No_Of_Run,0) FROM #Temp_Acq_Run_Data T 
							WHERE T.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV AND ISNULL(T.No_Of_Run,0) > 0
						)
					)					
					BEGIN											
						SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
						CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR),@Is_Error = 'Y' 
						FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'TOTAL_OVER_RUN' AND [Type] = 'S'
					END

					DECLARE @Is_Define_PrimeRun CHAR(1) = 'N',@Is_Define_OffPrimeRun CHAR(1) = 'N'
					SELECT @Is_Define_PrimeRun = CASE WHEN ISNULL(TARD.Prime_Start_Time,'') <> ''  THEN 'Y' ELSE 'N' END,
						 @Is_Define_OffPrimeRun = CASE WHEN ISNULL(TARD.Off_Prime_Start_Time,'') <> ''  THEN 'Y' ELSE 'N' END					 					
					FROM #Temp_Acq_Run_Data TARD 					
					PRINT ' Is_Define_PrimeRun : - ' + @Is_Define_PrimeRun 
					PRINT ' Is_Define_OffPrimeRun : - ' + @Is_Define_OffPrimeRun 
					/*********************************Start PrimeTime_Over_Run********************************/
					--Case --Prime over run  -- if Prime Time define and Prime Schedule Runs more then Allocated/Define Prime Runs then threw PRIMETIME_OVER_RUN Exception
					IF(ISNULL(@Is_Define_PrimeRun,'') = 'Y')
					BEGIN
						IF(	
							SELECT ISNULL(COUNT(DISTINCT TBSR.TimeLine_Id),0) 
							FROM #Temp_BMS_Schedule_Runs TBSR 
							WHERE 
							(
								(
								--Case if Prime and Off defination both are define
									(ISNULL(TBSR.Is_Prime,'N') = 'Y' AND ISNULL(@Is_Prime_Time,'N') = 'Y')
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
						(SELECT ISNULL(T.Prime_Run,0) FROM #Temp_Acq_Run_Data T WHERE T.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV)
						BEGIN
							SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +   ',' +
							CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR) ,@Is_Error = 'Y' 
							FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'PRIMETIME_OVER_RUN' AND [Type] = 'S'
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
						IF(	
							SELECT ISNULL(COUNT(DISTINCT TBSR.TimeLine_Id),0) 
							FROM #Temp_BMS_Schedule_Runs TBSR 
							WHERE 
							(
								(
									--Case if Prime and Off defination both are define
									(ISNULL(TBSR.Is_Prime,'N') = 'N' AND ISNULL(@Is_Prime_Time,'N') = 'N')
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
							(SELECT ISNULL(T.Off_Prime_Run,0) FROM #Temp_Acq_Run_Data T WHERE T.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV )
						BEGIN
							SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
							CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR),@Is_Error = 'Y'  
							FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'OFFPRIMETIME_OVER_RUN' AND [Type] = 'S'
						END
					END
					--SELECT 'sagar_Run',* FROM #Temp_Acq_Run_Data T 
					


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
				
					--ChannelWise_Over_Run					
					DECLARE @Run_Definition_Type CHAR(1) = 'N'
					SELECT TOP 1 @Run_Definition_Type = ISNULL(TARD.Run_Definition_Type,'N')
					FROM #Temp_Acq_Run_Data TARD WHERE TARD.Acq_Deal_Run_Code = @Acq_Deal_Run_Code_CV 

					IF(ISNULL(@Run_Definition_Type,'N') = 'C') --Only ChannelWise
					BEGIN
						IF(
							SELECT COUNT(DISTINCT TBSR.TimeLine_Id) 
							FROM #Temp_BMS_Schedule_Runs TBSR WHERE ISNULL(TBSR.Channel_Code,0) = @Channel_Code
						  )
							>
							(
							SELECT TOP 1 ADRC.Min_Runs 
							FROM Acq_Deal_Run_Channel ADRC WHERE ADRC.Acq_Deal_Run_Code =@Acq_Deal_Run_Code_CV AND ADRC.Channel_Code = @Channel_Code
							)
						BEGIN
							SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
							CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR) ,@Is_Error = 'Y' 
							FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'CHANNELWISE_OVER_RUN' AND [Type] = 'S'
						END	
				   END
										
					--Yearwise_Over_Run		
					DECLARE @Is_Yearwise_Definition CHAR(1) = 'N'					
					SELECT TOP 1 @Is_Yearwise_Definition = ISNULL(TADR.Is_Yearwise_Definition,'N')
					FROM #Temp_Acq_Run_Data TADR

					IF(ISNULL(@Is_Yearwise_Definition,'N') = 'Y') 
					BEGIN
						DECLARE @Schedule_Log_Date DATETIME
						SELECT TOP 1  @Schedule_Log_Date = CONVERT(DATETIME,TD.Log_Date,101) FROM #Temp_BMS_Acq_Run_Process_Data TD
						/***************************Insert into #Temp_Acq_Run_YearWise_Data**/
						INSERT INTO #Temp_Acq_Run_YearWise_Data
						(
							Acq_Deal_Run_Code,[Start_Date],End_date,No_Of_Run
						)
						SELECT DISTINCT  ADRY.Acq_Deal_Run_Code,ADRY.[Start_Date],ADRY.End_date,ADRY.No_Of_Runs 
						FROM Acq_Deal_Run_Yearwise_Run ADRY 
						WHERE ADRY.Acq_Deal_Run_Code =@Acq_Deal_Run_Code_CV 
						AND CONVERT(DATETIME,@Schedule_Log_Date,101)  BETWEEN  
						CONVERT(DATETIME,ADRY.[Start_Date] ,101) AND CONVERT(DATETIME,ADRY.End_Date ,101)
					
						IF EXISTS(SELECT TOP 1 T.Acq_Deal_Run_Code FROM #Temp_Acq_Run_YearWise_Data T)
						BEGIN
							IF(
								SELECT COUNT(DISTINCT TBSR.TimeLine_Id) 
								FROM #Temp_BMS_Schedule_Runs TBSR WHERE CONVERT(DATETIME,TBSR.Log_Date,101)  BETWEEN  
								(SELECT CONVERT(DATETIME,T1.[Start_Date],101) FROM #Temp_Acq_Run_YearWise_Data T1) AND 
								(SELECT CONVERT(DATETIME,T2.End_date,101) FROM #Temp_Acq_Run_YearWise_Data T2)
							  )
								>
								(
									SELECT TOP 1 TARYD.No_Of_Run
									FROM #Temp_Acq_Run_YearWise_Data TARYD 						
								)						
								SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,'') +  ',' +
								CAST(ISNULL(Email_Notification_Msg_Code,'') AS VARCHAR) ,@Is_Error = 'Y' 
								FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'YEARWISE_OVER_RUN' AND [Type] = 'S'						
						END
					END
					/***************Insert Exception Table *******************/
					PRINT 'End Exception Over Runs Logic'	

					INSERT INTO #Temp_Email_Notification_Msg(Email_Notification_Msg_Code)
					SELECT number FROM fn_Split_withdelemiter(ISNULL(@Email_Notification_Msg_Code,'0'),',')

					IF EXISTS(SELECT TOP 1 * FROM #Temp_Email_Notification_Msg E WHERE ISNULL(E.Email_Notification_Msg_Code,0) > 0)
					BEGIN
						INSERT INTO BMS_Schedule_Exception
						(
							BMS_Schedule_Process_Data_Code,Email_Notification_Msg_Code
						)
						SELECT  @BMS_Schedule_Process_Data_Code,E.Email_Notification_Msg_Code
						FROM #Temp_Email_Notification_Msg E WHERE ISNULL(E.Email_Notification_Msg_Code,0) > 0												
					PRINT 'Inserted into BMS_Schedule_Exception'	
					END				
					/******************************Update Is_Processed in BMS_Schedule_Process_Data*******/					
					UPDATE BMS_Schedule_Process_Data SET Is_Processed = 'D',Last_Updated_Time=GETDATE() WHERE BMS_Schedule_Process_Data_Code = @BMS_Schedule_Process_Data_Code

					/******************************Update Is Error in BMS_Schedule_Process_Data*******/


					IF(ISNULL(@Is_Error,'N') = 'Y')
					BEGIN
						UPDATE BMS_Schedule_Process_Data SET Is_Error = 'Y' ,Is_Processed = 'D'
						WHERE  BMS_Schedule_Process_Data_Code = @BMS_Schedule_Process_Data_Code
					END
					/******************Call BMS_Schedule_Reprocess_Runs******/
					EXEC USP_BMS_Schedule_Reprocess_Runs @Acq_Deal_Run_Code_CV,@Channel_Code,''
					PRINT 'Completed Reprocess of Runs USP_BMS_Schedule_Reprocess_Runs(call from USP_BMS_Schedule_Process)'
				/**************************************/
				--IF(@Timeline_ID_CV = 1052053545)
				--  BEGIN					  
				--	  SELECT 'sagar4',* FROM #Temp_BMS_Acq_Run_Process_Data
				--  END				 
				
				RunCode_Zero:
				PRINT 'Run Code :' + CAST(@Acq_Deal_Run_Code_CV AS VARCHAR(10))
				PRINT 'Is Error :' + CAST(@Is_Error AS VARCHAR(10))
			END  --   --End if While Loop(CR_RR_Validation)                                          

			FETCH NEXT FROM CR_RR_Validation INTO @BMS_Asset_Ref_Key_CV,@Timeline_ID_CV

		END -- -- While End(CR_RR_Validation)  
				                                        
		CLOSE CR_RR_Validation
		DEALLOCATE CR_RR_Validation
	END	
	PRINT '-----------------------End logic of USP_BMS_Schedule_Process-------------------------------'
	/*********************************Declare global variables ******************/
--	SELECT 'sagar1',* FROM @BMS_Schedule_Process_Revert_UDT
	/*****************/
	END TRY			 
	BEGIN CATCH				
		PRINT 'Catch Block in USP_BMS_Schedule_Process'
		DECLARE @ErMessage NVARCHAR(MAX),@ErSeverity INT,@ErState INT 
		SELECT @ErMessage = 'Error in USP_BMS_Schedule_Process : - ' +  ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE() 
		RAISERROR (@ErMessage,@ErSeverity,@ErState)  
	END CATCH		
END	
/*
UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'P'
EXEC  USP_BMS_Schedule
*/



