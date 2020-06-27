USE [RightsU_BV_04May]
GO
/****** Object:  StoredProcedure [dbo].[USP_BMS_Schedule_Right_Rule_Run_Process]    Script Date: 6/27/2017 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_BMS_Schedule_Right_Rule_Run_Process]
(
--DECLARE
	@Acq_Deal_RunCode INT = 0,
	@Call_from  CHAR(1)= '',
	@ChannelCode INT = 0,
	@TimelineID INT = 0
)
AS
---- =============================================
---- Author :		<Sagar Mahajan>
---- Create date :  <09 Aug 2016>
---- Description :  <Call FROM USP_BMS_Schedule_Process and USP_BMS_Schedule_Revert>
---- Edited By :    <Anchal Sikarwar>
---- ============================================= 
BEGIN
	SET NOCOUNT ON;	
	BEGIN TRY	
	PRINT '--------------------Start logic of USP_BMS_Schedule_Right_Rule_Run_Process-----------------------------'
	--DECLARE @Acq_Deal_RunCode INT = 0,@TimelineID INT = 0,@Call_from  CHAR(1)= 'R',@ChannelCode INT = 0
	--Here if @Call_from = 'P' THEN Call FROM USP_BMS_Schedule_Process 
	--if @Call_from  = 'R' THEN call from USP_BMS_Schedule_Revert 
	/************************DROP TEMP TABLES *********************/
	IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Right_Rule_data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_BMS_Schedule_Right_Rule_data
	END		
	/************************CREATE TEMP TABLES *********************/
	--SELECT @Acq_Deal_RunCode ,@Call_from ,@ChannelCode ,@TimelineID 

	CREATE TABLE #Temp_BMS_Schedule_Right_Rule_data
	(
		BMS_Schedule_Run_Code INT,
		Is_Ignore CHAR(1),
		Ref_TimeLine_ID INT,
		Schedule_DateTime DATETIME,
		TimeLine_ID INT,
		PlayDay INT,
		PlayRun INT
	)
	/*************Declare Variables*******************************************/						
	DECLARE @Duration_Of_Day INT,@IS_First_AIR CHAR(10),@No_of_days_hrs INT,@No_Of_Repeat INT
	,@Play_Per_Day INT,@Repeat_Within_Days_Hrs VARCHAR(100),@Start_Time TIME,@Is_Ignore CHAR(1) = 'N',@Right_RuleCode INT = 0
	,@Title_Code INT

	DECLARE @Schedule_Item_Log_Date_Time DATETIME,@Schedule_Start_Time DATETIME,
	@Schedule_End_Time DATETIME,@Schedule_Start_Time_Is_First_Air DATETIME

	SELECT TOP 1 @Title_Code=Title_Code FROM Acq_Deal_Run_Title WHERE Acq_Deal_Run_Code=@Acq_Deal_RunCode
	SELECT TOP 1  @No_of_days_hrs = 
		CASE 
			WHEN ADR.Repeat_Within_Days_Hrs = 'H'   
			THEN ISNULL(ADR.No_Of_Days_Hrs,0) ELSE (ISNULL(ADR.No_Of_Days_Hrs,1)*24)
		END ,@Right_RuleCode = ISNULL(ADR.Right_Rule_Code,0) 
	FROM Acq_Deal_Run ADR WHERE ADR.Acq_Deal_Run_Code = @Acq_Deal_RunCode
						 
	SELECT @Start_Time=Start_Time,
		@Play_Per_Day = ISNULL(Play_Per_Day,1),
		--@Duration_Of_Day = Duration_Of_Day, 
		@No_Of_Repeat = No_Of_Repeat,
		@IS_FIRST_AIR = CASE WHEN ISNULL(IS_FIRST_AIR,0) > 0 THEN 'Y' ELSE 'N' END 
	FROM Right_Rule 
	WHERE Right_Rule_Code = @Right_RuleCode

	SELECT TOP 1 @Schedule_Item_Log_Date_Time = BSPD.Date_Time 
	FROM BMS_Schedule_Process_Data BSPD WHERE ISNULL(BSPD.Timeline_ID,0) = @TimelineID
	ORDER BY BSPD.Inserted_On DESC

	--SELECT @Schedule_Start_Time = 
	--CASE 
	--	WHEN ISNULL(@Is_First_Air,'N') = 'N' THEN   
	--	CAST(CAST(CAST(@Schedule_Item_Log_Date_Time AS DATE) AS VARCHAR)  + ' ' + CAST(@Start_Time as VARCHAR(8)) AS DATETIME)
	--	ELSE @Schedule_Item_Log_Date_Time
	--END
	--,@Schedule_End_Time = 
	--CASE 
	--	WHEN ISNULL(@Is_First_Air,'N') = 'N' 
	--	--CAST(CAST(CAST(@Schedule_Item_Log_Date_Time AS DATE) AS VARCHAR) + ' ' + '23:59:59' AS DATETIME)
	--	THEN DATEADD(SECOND,-1,DATEADD(HOUR,ISNULL(@No_of_days_hrs,24),CAST(CONVERT(varchar,@Schedule_Item_Log_Date_Time,106) AS DATETIME)))
	--	ELSE DATEADD(SECOND ,-1 ,(DATEADD(HOUR,ISNULL(@No_of_days_hrs,ISNULL(@No_of_days_hrs,24)),@Schedule_Item_Log_Date_Time)))
	--END
	--,@Schedule_Start_Time_Is_First_Air = DATEADD(SECOND ,-1 ,(DATEADD(HOUR,-(ISNULL(@No_of_days_hrs,24)),@Schedule_Item_Log_Date_Time)))
						
	----SELECT @Schedule_Start_Time AS Schedule_Start_Time,@Schedule_End_Time AS Schedule_End_Time,@Schedule_Start_Time_Is_First_Air AS Schedule_End_Time_Is_First_Air,@IS_First_AIR AS IS_First_AIR 
	--PRINT  ' No_of_days_hrs : - ' + CAST(@No_of_days_hrs AS VARCHAR(100)) +' Schedule_Item_Log_Date_Time : - ' +  CAST(@Schedule_Item_Log_Date_Time AS VARCHAR(100)) +' Schedule_Start_Time : - ' + CAST(@Schedule_Start_Time AS VARCHAR(100)) 
	--+ ' Schedule_End_Time : - ' + CAST(@Schedule_End_Time AS VARCHAR(100)) + ' Schedule_End_Time_Is_First_Air : - ' +  
	--+ ' Schedule_End_Time_Is_First_Air : - ' + CAST(@Schedule_Start_Time_Is_First_Air AS VARCHAR(100)) 
	--+ ' IS_First_AIR  : - ' + CAST(@IS_First_AIR AS VARCHAR(100))

	/***Added By Anchal For Play Day Play Run***/

	INSERT INTO #Temp_BMS_Schedule_Right_Rule_data(BMS_Schedule_Run_Code, Is_Ignore,Schedule_DateTime,
	TimeLine_ID,Ref_TimeLine_ID,PlayDay,PlayRun) 

	SELECT bsr.BMS_Schedule_Runs_Code,bsr.Is_Ignore,bsr.Date_Time,bsr.Timeline_ID,bsr.Ref_Timeline_ID,
	ISNULL(bspd.Play_Day,1),ISNULL(BSPD.Play_Run,1)
	--,Convert(DateTime,bspd.Date_Time,120) AS Date_Time,
	--(

	--	SELECT MAX(Convert(DateTime,bspd1.Date_Time,120)) 
	--	FROM BMS_Schedule_Process_Data bspd1
	--	INNER JOIN BMS_Schedule_Runs bsr1 ON bsr1.BMS_Schedule_Process_Data_Code = bspd1.BMS_Schedule_Process_Data_Code
	--	WHERE 
	--	bspd1.Title_Code = @Title_Code 
	--	AND bspd1.Acq_Deal_Run_Code = @Acq_Deal_RunCode
	--	AND bsr1.Channel_Code=@ChannelCode
	--	AND Convert(DateTime,bspd1.Date_Time,120) < @Schedule_Item_Log_Date_Time 
	--	AND bsr1.Is_Ignore='N'

	--)
	--AS date 
	FROM BMS_Schedule_Process_Data bspd
	INNER JOIN BMS_Schedule_Runs bsr ON bsr.BMS_Schedule_Process_Data_Code = bspd.BMS_Schedule_Process_Data_Code
	WHERE bspd.Title_Code = @Title_Code AND bspd.Acq_Deal_Run_Code = @Acq_Deal_RunCode 
	AND Convert(DateTime,bspd.Date_Time,120) >= ISNULL((

		SELECT MAX(Convert(DateTime,bspd1.Date_Time,120)) 
		FROM BMS_Schedule_Process_Data bspd1
		INNER JOIN BMS_Schedule_Runs bsr1 ON bsr1.BMS_Schedule_Process_Data_Code = bspd1.BMS_Schedule_Process_Data_Code
		WHERE 
		bspd1.Title_Code = @Title_Code 
		AND bspd1.Acq_Deal_Run_Code = @Acq_Deal_RunCode
		AND bsr1.Channel_Code=@ChannelCode
		AND Convert(DateTime,bspd1.Date_Time,120) < @Schedule_Item_Log_Date_Time 
		AND ISNULL(bsr1.Is_Ignore,'N')='N'

	),Convert(DateTime,bspd.Date_Time,120))
	AND BSR.Channel_Code=@ChannelCode order by Convert(DateTime,bspd.Date_Time,120)
	
	DELETE FROM #Temp_BMS_Schedule_Right_Rule_data WHERE @Call_from = 'R' AND TimeLine_ID = @TimelineID		
	
	Update #Temp_BMS_Schedule_Right_Rule_data SET Is_Ignore=NULL 
	where BMS_Schedule_Run_Code NOT IN(select Top 1 BMS_Schedule_Run_Code from #Temp_BMS_Schedule_Right_Rule_data)

	Update #Temp_BMS_Schedule_Right_Rule_data SET PlayDay=1,PlayRun=1 
	where 
	BMS_Schedule_Run_Code IN(select Top 1 BMS_Schedule_Run_Code from #Temp_BMS_Schedule_Right_Rule_data)
	And 
	(PlayDay IS NULL AND PlayRun IS NULL)

	DECLARE @BMS_Schedule_Run_Code INT,@Schedule_DateTime DateTime, @TimeLine_ID INT, @Ref_TimeLine_ID INT, @PlayDay INT=1, @PlayRun INT=1,
	@LastPlayDay INT,@LastPlayRun INT,@LastTimeLine_ID INT,@LastIsIgnore CHAR(1), @LSchedule_Item_Log_Date_Time DATETIME,@LSchedule_Start_Time DATETIME,
	@LSchedule_End_Time DATETIME,@LSchedule_Start_Time_Is_First_Air DATETIME,@RepeatCount INT=0

	DECLARE CR_BMS_Schedule_Run_Temp CURSOR       
	FOR SELECT DISTINCT BMS_Schedule_Run_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,ISNULL(PlayDay,1),PlayRun FROM #Temp_BMS_Schedule_Right_Rule_data 
			order by Schedule_DateTime			
	OPEN CR_BMS_Schedule_Run_Temp  
	FETCH NEXT FROM CR_BMS_Schedule_Run_Temp INTO @BMS_Schedule_Run_Code, @Is_Ignore,@Schedule_DateTime,@TimeLine_ID,@Ref_TimeLine_ID,@PlayDay,@PlayRun
	WHILE @@FETCH_STATUS<>-1 
	BEGIN 
		IF(@@FETCH_STATUS<>-2)                                        
		BEGIN
			--SELECT @Is_Ignore
			--select @LastIsIgnore
			DECLARE @Is_Ignore1 CHAR(1) = 'N', @Acq_Deal_Run_Code INT
			select @Acq_Deal_Run_Code=Acq_Deal_Run_Code from BMS_Schedule_Runs where BMS_Schedule_Runs_Code=@BMS_Schedule_Run_Code
		
			PRINT 'Start SimulCast'
			BEGIN -- Start SimulCast					
				IF EXISTS(SELECT Channel_Code FROM Channel WHERE Channel_Code = @ChannelCode AND ISNULL(Is_Parent_Child,'') = 'C')					
				BEGIN
					PRINT '-------SimulCast Logic Define---------'

					DECLARE @TimeLag_StartTime DATETIME,@TimeLag_EndTime DATETIME,@Time_Lag_Simulcast DATETIME,@Parent_Channel_Code INT = 0

					SELECT TOP 1 @TimeLag_StartTime = ((@Schedule_DateTime) - CAST(ADR.Time_Lag_Simulcast as DATETIME))
						,@TimeLag_EndTime =((@Schedule_DateTime) + CAST(ADR.Time_Lag_Simulcast as DATETIME))
					FROM Acq_Deal_Run ADR where ADR.Acq_Deal_Run_Code =@Acq_Deal_Run_Code
					--INNER JOIN #Temp_BMS_Acq_Run_Process_Data TD ON TARD.Acq_Deal_Run_Code = TD.Acq_Deal_Run_Code  
					--AND TARD.Acq_Deal_Run_Code =@Acq_Deal_Run_Code 

					SELECT @Parent_Channel_Code = ISNULL(C.Parent_Channel_Code,0) FROM Channel C WHERE C.Channel_Code = @ChannelCode

					IF EXISTS (SELECT TOP 1 BSR.Acq_Deal_Run_Code FROM BMS_Schedule_Runs BSR WHERE BSR.Channel_Code = @Parent_Channel_Code AND 
								BSR.Date_Time BETWEEN @TimeLag_StartTime AND @TimeLag_EndTime)
					BEGIN
						SET @Is_Ignore1 = 'Y'
					END																	
				END
			END -- End SimulCast
			PRINT 'End SimulCast'

			IF(@Is_Ignore1='N')
			BEGIN
				IF(@Is_Ignore='N')
				BEGIN
					SET @LastPlayDay=@PlayDay
					SET @LastPlayRun=@PlayRun
					SET @LastTimeLine_ID =@TimeLine_ID
					SET @LastIsIgnore=@Is_Ignore
				END
				else
				BEGIN
					IF(
						(@LastIsIgnore='N' OR @RepeatCount<@No_Of_Repeat) 
						AND
						(
							((@Schedule_DateTime BETWEEN  @LSchedule_Start_Time AND @LSchedule_End_Time) AND (@Is_First_Air = 'N'))
							OR
							((@Schedule_DateTime BETWEEN  @LSchedule_Start_Time_Is_First_Air AND @LSchedule_End_Time) AND (@Is_First_Air = 'Y'))
						)
					)
					BEGIN
						Update #Temp_BMS_Schedule_Right_Rule_data 
						SET PlayDay=@LastPlayDay,PlayRun=@LastPlayRun+1,Is_Ignore='Y',Ref_TimeLine_ID=@LastTimeLine_ID
						Where TimeLine_ID=@TimeLine_ID 

						--SET @PlayRun=@LastPlayRun+1
						SET @Is_Ignore='Y'
						SET @PlayDay=@LastPlayDay

						SET @RepeatCount=@RepeatCount+1
						SET @LastPlayRun=@LastPlayRun+1
						SET @LastIsIgnore='Y'
					
					END
					ELSE
					BEGIN
					Update #Temp_BMS_Schedule_Right_Rule_data 
						SET PlayDay=ISNULL(@LastPlayDay,0)+1,PlayRun=1,Is_Ignore='N'
						Where TimeLine_ID=@TimeLine_ID 
						SET @Is_Ignore='N'
						SET @RepeatCount=0
						SET @LastPlayDay=@LastPlayDay+1
						SET @PlayDay=@LastPlayDay+1
						SET @LastPlayRun=1
						SET @LastTimeLine_ID =@TimeLine_ID
						SET @LastIsIgnore='N'
					END
				END
				IF(@Is_Ignore='N')
				BEGIN
			
					SELECT TOP 1 @LSchedule_Item_Log_Date_Time = Convert(DateTime,BSPD.Date_Time,101) 
					FROM BMS_Schedule_Process_Data BSPD WHERE ISNULL(BSPD.Timeline_ID,0) = @TimeLine_ID
					ORDER BY BSPD.Inserted_On DESC

					SELECT @LSchedule_Start_Time = 
					CASE 
						WHEN ISNULL(@Is_First_Air,'N') = 'N' THEN   
						CAST(CAST(CAST(@LSchedule_Item_Log_Date_Time AS DATE) AS VARCHAR)  + ' ' + CAST(@Start_Time as VARCHAR(8)) AS DATETIME)
						ELSE @LSchedule_Item_Log_Date_Time
					END
					,@LSchedule_End_Time = 
					CASE 
						WHEN ISNULL(@Is_First_Air,'N') = 'N' 
						--CAST(CAST(CAST(@Schedule_Item_Log_Date_Time AS DATE) AS VARCHAR) + ' ' + '23:59:59' AS DATETIME)
						THEN DATEADD(SECOND,-1,DATEADD(HOUR,ISNULL(@No_of_days_hrs,24),CAST(CONVERT(varchar,@LSchedule_Item_Log_Date_Time,106) AS DATETIME)))
						ELSE DATEADD(SECOND ,-1 ,(DATEADD(HOUR,ISNULL(@No_of_days_hrs,ISNULL(@No_of_days_hrs,24)),@LSchedule_Item_Log_Date_Time)))
					END
					,@LSchedule_Start_Time_Is_First_Air = DATEADD(SECOND ,-1 ,(DATEADD(HOUR,-(ISNULL(@No_of_days_hrs,24)),@LSchedule_Item_Log_Date_Time)))

				END
			END
			ELSE
			BEGIN
				Update #Temp_BMS_Schedule_Right_Rule_data 
				SET PlayDay=0,PlayRun=0,Is_Ignore='Y'
				Where TimeLine_ID=@TimeLine_ID 
			END
			--	select @LastPlayDay
			--select @LastPlayRun
			--select @PlayDay
			--select @PlayRun
		END
		
	FETCH NEXT FROM CR_BMS_Schedule_Run_Temp INTO @BMS_Schedule_Run_Code, @Is_Ignore,@Schedule_DateTime,@TimeLine_ID,@Ref_TimeLine_ID,@PlayDay,@PlayRun
	END
	CLOSE CR_BMS_Schedule_Run_Temp
	DEALLOCATE CR_BMS_Schedule_Run_Temp

	/***Added By Anchal For Play Day Play Run***/

	--INSERT INTO #Temp_BMS_Schedule_Right_Rule_data(BMS_Schedule_Run_Code, Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID) 
	--SELECT TBL.BMS_Schedule_Runs_Code, TBL.Is_Ignore AS Is_Ignore,TBL.Date_Time,TBL.Timeline_ID,TBL.Ref_Timeline_ID 
	--FROM
	--(
	--	SELECT BSR.BMS_Schedule_Runs_Code, BSR.Is_Ignore AS Is_Ignore,BSR.Date_Time,BSR.Timeline_ID,BSR.Ref_Timeline_ID
	--	FROM BMS_Schedule_Runs BSR
	--	WHERE 1 = 1  
	--	AND BSR.Acq_Deal_Run_Code = @Acq_Deal_RunCode 
	--	AND BSR.Channel_Code = @ChannelCode						
	--	AND 
	--	(
	--		(
	--			(BSR.Date_Time BETWEEN  @Schedule_Start_Time AND @Schedule_End_Time) 
	--			AND 
	--			(@Is_First_Air = 'N')
	--		)
	--		OR
	--		(
	--			(BSR.Date_Time BETWEEN  @Schedule_Start_Time_Is_First_Air AND @Schedule_End_Time)
	--			AND (@Is_First_Air = 'Y')
	--		)
	--	)
	--	UNION 
	--	SELECT 0 AS BMS_Schedule_Runs_Code, 'N' AS Is_Ignore,@Schedule_Item_Log_Date_Time,@TimelineID AS Timeline_ID_CV,0 AS Ref_TimeLine_ID
	--) AS TBL
	--WHERE (ISNULL(TBL.BMS_Schedule_Runs_Code,0) > 0 AND @Call_from = 'R')
	--OR (@Call_from = 'P')


	--DELETE FROM #Temp_BMS_Schedule_Right_Rule_data 
	--WHERE 
	--1 = 1 
	--AND	ISNULL(Ref_TimeLine_ID,0) > 0 AND Ref_TimeLine_ID NOT IN
	--(
	--	SELECT TP.TimeLine_ID FROM #Temp_BMS_Schedule_Right_Rule_data TP
	--) --AND @Call_from = 'P'


					


	--UPDATE #Temp_BMS_Schedule_Right_Rule_data SET Is_Ignore = 'N',Ref_TimeLine_ID = NULL

	--DECLARE @Ref_TimeLine_ID INT = 0							
	--SELECT TOP (ISNULL(@Play_Per_Day,1)) @Ref_TimeLine_ID  = TRR.TimeLine_ID 
	--FROM #Temp_BMS_Schedule_Right_Rule_data  TRR
	--ORDER BY TRR.Schedule_DateTime ASC
			

	--IF(ISNULL(@No_Of_Repeat,0) > 0)
	--BEGIN
	--	UPDATE #Temp_BMS_Schedule_Right_Rule_data SET Is_Ignore = 'Y',Ref_TimeLine_ID = @Ref_TimeLine_ID WHERE TimeLine_ID IN
	--	(
	--		SELECT TOP (@No_Of_Repeat) TRR.TimeLine_ID 
	--		FROM #Temp_BMS_Schedule_Right_Rule_data TRR
	--		WHERE TRR.TimeLine_ID <> @Ref_TimeLine_ID
	--		ORDER BY  TRR.Schedule_DateTime ASC
	--	)	
	--END


	PRINT 'Update IsIgnore Flag BMS_Schedule_Runs'
	IF(ISNULL(@Call_from,'P') = 'R')
	BEGIN
		UPDATE BSR SET BSR.Is_Ignore = TRR.Is_Ignore,BSR.Ref_Timeline_ID = TRR.Ref_TimeLine_ID
		FROM BMS_Schedule_Runs BSR
		INNER JOIN #Temp_BMS_Schedule_Right_Rule_data TRR 
		ON TRR.TimeLine_ID = BSR.Timeline_ID  AND BSR.Channel_Code = @ChannelCode

		UPDATE BSPD SET BSPD.Play_Day=TRR.PlayDay,BSPD.Play_Run=TRR.PlayRun ,BSPD.Last_Updated_Time=GETDATE()
		FROM BMS_Schedule_Runs BSR
		INNER JOIN #Temp_BMS_Schedule_Right_Rule_data TRR 
		ON TRR.TimeLine_ID = BSR.Timeline_ID  AND BSR.Channel_Code = @ChannelCode
		INNER JOIN BMS_Schedule_Process_Data BSPD ON BSPD.Timeline_ID=BSR.Timeline_ID AND BSPD.BMS_Schedule_Process_Data_Code=BSR.BMS_Schedule_Process_Data_Code
	END

	IF(@Call_from = 'P')
	BEGIN
		SELECT * FROM #Temp_BMS_Schedule_Right_Rule_data
	END


	/************************DROP TEMP TABLES *********************/
	IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Right_Rule_data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_BMS_Schedule_Right_Rule_data
	END		
	PRINT '-----------------------End logic of USP_BMS_Schedule_Right_Rule_Run_Process-------------------------------'
		/*********************************Declare global variables ******************/
	--	SELECT 'sagar1',* FROM @BMS_Schedule_Process_Revert_UDT
		/*****************/
	END TRY			 
	BEGIN CATCH				
		PRINT 'Catch Block in USP_BMS_Schedule_Right_Rule_Run_Process'
		DECLARE @ErMessage NVARCHAR(MAX),@ErSeverity INT,@ErState INT 
		SELECT @ErMessage = 'Error in USP_BMS_Schedule_Right_Rule_Run_Process : - ' +  ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE() 
		RAISERROR (@ErMessage,@ErSeverity,@ErState)  
	END CATCH		
END
