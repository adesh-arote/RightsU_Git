CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Right_Rule_Run_Process]
(
	@Call_from  CHAR(1),
	@ChannelCode INT,
	@TimelineID INT,
	@Content_Channel_Run_Code INT
)
AS
---- =============================================
-- Author :		<Sagar Mahajan>
-- Create date :  <09 Aug 2016>
-- Description :  <Call FROM USP_BMS_Schedule_Process and USP_BMS_Schedule_Revert>
-- Edited By :    <Anchal Sikarwar>
-- ============================================= 
BEGIN
	PRINT '@Call_from = '+@Call_from+',@ChannelCode = '+CAST(@ChannelCode AS VARCHAR)+',@TimelineID = '+CAST(@TimelineID AS VARCHAR)+',@Content_Channel_Run_Code = '+CAST(@Content_Channel_Run_Code AS VARCHAR) 
	SET NOCOUNT ON;	
	BEGIN TRY	
		PRINT '--------------------Start logic of USP_BMS_Schedule_Right_Rule_Run_Process-----------------------------'
		/************************DROP TEMP TABLES *********************/
		IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Right_Rule_data') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_BMS_Schedule_Right_Rule_data
		END		
		/************************CREATE TEMP TABLES *********************/

		CREATE TABLE #Temp_BMS_Schedule_Right_Rule_data
		(
			BV_Schedule_Transaction_Code INT,
			Is_Ignore CHAR(1),
			Ref_TimeLine_ID INT,
			Schedule_DateTime DATETIME,
			TimeLine_ID INT,
			PlayDay INT,
			PlayRun INT,
			Is_Right_Rule_Exceeds CHAR(1)
		)
		/*************Declare Variables*******************************************/						
		DECLARE @Duration_Of_Day INT, @IS_FIRST_AIR CHAR(10), @No_of_days_hrs INT, @No_Of_Repeat INT, @Play_Per_Day INT, @Repeat_Within_Days_Hrs VARCHAR(100),
		@Start_Time TIME, @Is_Ignore CHAR(1) = 'N', @Right_RuleCode INT = 0, @Title_Code INT, @Schedule_Item_Log_Date_Time DATETIME, @Schedule_Start_Time DATETIME,
		@Schedule_End_Time DATETIME, @Schedule_Start_Time_Is_First_Air DATETIME
		,@PreviousSchedule_Item_Log_Date_Time DATETIME, @BV_Schedule_Transaction_Code INT,@Schedule_DateTime DateTime, @TimeLine_ID INT, @Ref_TimeLine_ID INT, @PlayDay INT = 0, @PlayRun INT = 0,
		@LastPlayDay INT = 0,@LastPlayRun INT = 0,@LastTimeLine_ID INT,@LastIsIgnore CHAR(1), @LSchedule_Item_Log_Date_Time DATETIME,@LSchedule_Start_Time DATETIME,
		@LSchedule_End_Time DATETIME,@LSchedule_Start_Time_Is_First_Air DATETIME,@RepeatCount INT = 0

		SELECT TOP 1  @Right_RuleCode = ISNULL(CCR.Right_Rule_Code,0) 
		FROM Content_Channel_Run CCR WHERE CCR.Content_Channel_Run_Code = @Content_Channel_Run_Code AND ISNULL(CCR.Is_Archive, 'N') = 'N'
						 
		SELECT @Start_Time=Start_Time, @Play_Per_Day = ISNULL(Play_Per_Day,1), @No_of_days_hrs = Duration_Of_Day, @No_Of_Repeat = No_Of_Repeat
		--,@IS_FIRST_AIR = CASE WHEN ISNULL(IS_FIRST_AIR,0) > 0 THEN 'Y' ELSE 'N' END 
		FROM Right_Rule WHERE Right_Rule_Code = @Right_RuleCode
		--select @No_of_days_hrs
		SET @IS_FIRST_AIR = 'Y'

		SELECT TOP 1 @Schedule_Item_Log_Date_Time = CAST(BST.Schedule_Item_Log_Time AS DATETIME)
		FROM BV_Schedule_Transaction BST WHERE ISNULL(BST.Timeline_ID,0) = @TimelineID
		ORDER BY BST.Inserted_On DESC

		SELECT TOP 1 @PreviousSchedule_Item_Log_Date_Time = CAST(BST.Schedule_Item_Log_Time AS DATETIME)
		FROM BV_Schedule_Transaction BST WHERE BST.Content_Channel_Run_Code = @Content_Channel_Run_Code
		AND BST.Schedule_Item_Log_Time < @Schedule_Item_Log_Date_Time AND ISNULL(BST.IsIgnore,'') = 'N'
		ORDER BY CAST(BST.Schedule_Item_Log_Time AS DATETIME) DESC

		SEt @PreviousSchedule_Item_Log_Date_Time =ISNULL(@PreviousSchedule_Item_Log_Date_Time,@Schedule_Item_Log_Date_Time)

		INSERT INTO #Temp_BMS_Schedule_Right_Rule_data(BV_Schedule_Transaction_Code,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,PlayDay,PlayRun,Is_Ignore) 
		SELECT BST.BV_Schedule_Transaction_Code, BST.Schedule_Item_Log_Time, BST.Timeline_ID, BST.Ref_Timeline_ID, ISNULL(BST.Play_Day,1), ISNULL(BST.Play_Run,1),
		BST.IsIgnore
		FROM BV_Schedule_Transaction BST
		WHERE BST.Content_Channel_Run_Code=@Content_Channel_Run_Code
		AND BST.Schedule_Item_Log_Time >= @PreviousSchedule_Item_Log_Date_Time
		AND BST.Channel_Code=@ChannelCode order by Convert(DateTime,BST.Schedule_Item_Log_Time,120)

		Delete T from #Temp_BMS_Schedule_Right_Rule_data T
		INNER JOIN BMS_Schedule_Exception E ON T.BV_Schedule_Transaction_Code = E.BV_Schedule_Transaction_Code
		INNER JOIN Email_Notification_Msg M ON M.Email_Notification_Msg_Code = E.Email_Notification_Msg_Code
		Where ISNULL(M.Error_Warning, '') = 'E'

		PRINT '@Call_from : ' + @Call_from +' @TimelineID : '+ CAST(@TimelineID AS VARCHAR)

		DELETE T1 FROM #Temp_BMS_Schedule_Right_Rule_data T1
		INNER JOIN BMS_Schedule_Process_Data_Temp T2 ON T1.TimeLine_ID = T2.Timeline_ID AND ISNULL(T2.Delete_Flag,0)=1
	 
		Update #Temp_BMS_Schedule_Right_Rule_data SET Is_Ignore=NULL 
		where BV_Schedule_Transaction_Code NOT IN(select Top 1 BV_Schedule_Transaction_Code from #Temp_BMS_Schedule_Right_Rule_data)

		Update #Temp_BMS_Schedule_Right_Rule_data SET PlayRun=1 
		where BV_Schedule_Transaction_Code IN(select Top 1 BV_Schedule_Transaction_Code from #Temp_BMS_Schedule_Right_Rule_data) 

		IF EXISTS(SELECT * fROM BV_Schedule_Transaction BST WHERE BST.Content_Channel_Run_Code = @Content_Channel_Run_Code
		AND BST.Timeline_ID NOT IN (SELECT Timeline_ID FROM #Temp_BMS_Schedule_Right_Rule_data))
		BEGIN
			Update #Temp_BMS_Schedule_Right_Rule_data SET PlayDay=
			(SELECT MAX(BST.Play_Day) fROM BV_Schedule_Transaction BST WHERE BST.Content_Channel_Run_Code = @Content_Channel_Run_Code
			AND BST.Timeline_ID NOT IN (SELECT Timeline_ID FROM #Temp_BMS_Schedule_Right_Rule_data))+1
			where BV_Schedule_Transaction_Code IN(select Top 1 BV_Schedule_Transaction_Code from #Temp_BMS_Schedule_Right_Rule_data) 
			And (PlayDay IS NULL)
		END
		ELSE
			Update #Temp_BMS_Schedule_Right_Rule_data SET PlayDay=1
			where BV_Schedule_Transaction_Code IN(select Top 1 BV_Schedule_Transaction_Code from #Temp_BMS_Schedule_Right_Rule_data) 
			And (PlayDay IS NULL)

		DECLARE CR_BMS_Schedule_Run_Temp CURSOR       
		FOR SELECT DISTINCT BV_Schedule_Transaction_Code,Is_Ignore,Schedule_DateTime,TimeLine_ID,Ref_TimeLine_ID,ISNULL(PlayDay,1),PlayRun 
		FROM #Temp_BMS_Schedule_Right_Rule_data order by Schedule_DateTime			
		OPEN CR_BMS_Schedule_Run_Temp  
		FETCH NEXT FROM CR_BMS_Schedule_Run_Temp INTO @BV_Schedule_Transaction_Code, @Is_Ignore,@Schedule_DateTime,@TimeLine_ID,@Ref_TimeLine_ID,@PlayDay,@PlayRun
		WHILE @@FETCH_STATUS<>-1 
		BEGIN
			Print 'IN RR : ' + Cast(@TimeLine_ID AS VARCHAR)
			IF(@@FETCH_STATUS<>-2)                                        
			BEGIN
				DECLARE @Is_Ignore1 CHAR(1) = 'N', @Content_Channel_Run_Code_CV INT
				select @Content_Channel_Run_Code_CV = BST.Content_Channel_Run_Code
				from BV_Schedule_Transaction BST where BST.BV_Schedule_Transaction_Code=@BV_Schedule_Transaction_Code
		
				PRINT 'Start SimulCast'
				BEGIN				
					IF EXISTS(SELECT Channel_Code FROM Channel WHERE Channel_Code = @ChannelCode AND ISNULL(Is_Parent_Child,'') = 'C')					
					BEGIN
						PRINT '-------SimulCast Logic Define---------'

						DECLARE @TimeLag_StartTime DATETIME,@TimeLag_EndTime DATETIME,@Time_Lag_Simulcast DATETIME,@Parent_Channel_Code INT = 0
						SELECT TOP 1 @TimeLag_StartTime = ((@Schedule_DateTime) - CAST(CCR.Time_Lag_Simulcast as DATETIME))
						,@TimeLag_EndTime =((@Schedule_DateTime) + CAST(CCR.Time_Lag_Simulcast as DATETIME))
						FROM Content_Channel_Run CCR where CCR.Content_Channel_Run_Code = @Content_Channel_Run_Code_CV AND ISNULL(CCR.Is_Archive, 'N') = 'N'

						SELECT @Parent_Channel_Code = ISNULL(C.Parent_Channel_Code,0) FROM Channel C WHERE C.Channel_Code = @ChannelCode

						IF EXISTS (SELECT TOP 1 BST.Content_Channel_Run_Code FROM BV_Schedule_Transaction BST WHERE BST.Channel_Code = @Parent_Channel_Code AND 
									BST.Schedule_Item_Log_Time BETWEEN @TimeLag_StartTime AND @TimeLag_EndTime)
						BEGIN
						PRINT '-------SimulCast Logic Define---------@Is_Ignore1 = Y'
							SET @Is_Ignore1 = 'Y'
						END																	
					END
				END
				PRINT 'End SimulCast'
				IF(@Is_Ignore1='N')
				BEGIN
					IF(@Is_Ignore='N')
					BEGIN
						SET @LastPlayDay = @PlayDay
						SET @LastPlayRun = @PlayRun
						SET @LastTimeLine_ID = @TimeLine_ID
						SET @LastIsIgnore = @Is_Ignore

						
					END
					else
					BEGIN
					

						IF(
							(@LastIsIgnore='N' OR @RepeatCount< ISNULL(@No_Of_Repeat,0)) 
							AND
							(
								((@Schedule_DateTime BETWEEN  @LSchedule_Start_Time AND @LSchedule_End_Time) AND (@IS_FIRST_AIR = 'N'))
								OR
								((@Schedule_DateTime BETWEEN  @LSchedule_Start_Time_Is_First_Air AND @LSchedule_End_Time) AND (@IS_FIRST_AIR = 'Y'))
							)
							AND ISNULL(@No_Of_Repeat,0) != 0
						)
						BEGIN
						PRINT 'Ignore AA'
							Update #Temp_BMS_Schedule_Right_Rule_data 
							SET PlayDay = @LastPlayDay, PlayRun = @LastPlayRun + 1, Is_Ignore='Y', Ref_TimeLine_ID = @LastTimeLine_ID, Is_Right_Rule_Exceeds ='N'
							Where TimeLine_ID = @TimeLine_ID 

							SET @Is_Ignore = 'Y'
							SET @PlayDay = @LastPlayDay
							SET @RepeatCount = @RepeatCount + 1
							SET @LastPlayRun = @LastPlayRun + 1
							SET @LastIsIgnore = 'Y'

						END
						ELSE
						BEGIN
						Update #Temp_BMS_Schedule_Right_Rule_data 
							SET PlayDay = ISNULL(@LastPlayDay,0) + 1, PlayRun = 1, Is_Ignore = 'N'
							Where TimeLine_ID = @TimeLine_ID 
							SET @Is_Ignore = 'N'
							SET @RepeatCount = 0
							SET @LastPlayDay = @LastPlayDay + 1
							SET @PlayDay = @LastPlayDay + 1
							SET @LastPlayRun = 1
							SET @LastTimeLine_ID = @TimeLine_ID
							SET @LastIsIgnore = 'N'

							DECLARE @Schedule_DateTimeVRightRule DATETIME
							
							select @Schedule_DateTimeVRightRule = Schedule_DateTime from #Temp_BMS_Schedule_Right_Rule_data Where TimeLine_ID=@TimeLine_ID 

							IF((Select  COUNT(*) from #Temp_BMS_Schedule_Right_Rule_data WHERE 
							(Schedule_DateTime BETWEEN  
							DATEADD(MINUTE ,1 ,(DATEADD(HOUR,-(ISNULL(@No_of_days_hrs,24)),@Schedule_DateTimeVRightRule)))
								AND @Schedule_DateTimeVRightRule)
								
							AND Is_Ignore='N') > ISNULL(@Play_Per_Day,0))
							BEGIN
								Update #Temp_BMS_Schedule_Right_Rule_data 
								SET Is_Right_Rule_Exceeds ='Y'
								Where TimeLine_ID=@TimeLine_ID AND Is_Ignore = 'N'
							END
							ELSE
							BEGIN
								Update #Temp_BMS_Schedule_Right_Rule_data 
								SET Is_Right_Rule_Exceeds ='N'
								Where TimeLine_ID=@TimeLine_ID 
							END
						END
					END
					IF(@Is_Ignore='N')
					BEGIN
						SELECT TOP 1 @LSchedule_Item_Log_Date_Time = Convert(DateTime,BST.Schedule_Item_Log_Time,101) 
						FROM BV_Schedule_Transaction BST WHERE ISNULL(BST.Timeline_ID,0) = @TimeLine_ID
						ORDER BY BST.Inserted_On DESC

						SELECT @LSchedule_Start_Time = 
						CASE 
							WHEN ISNULL(@IS_FIRST_AIR,'N') = 'N' THEN   
							CAST(CAST(CAST(@LSchedule_Item_Log_Date_Time AS DATE) AS VARCHAR)  + ' ' + CAST(@Start_Time as VARCHAR(8)) AS DATETIME)
							ELSE @LSchedule_Item_Log_Date_Time
							END
						,@LSchedule_End_Time = 
						CASE 
							WHEN ISNULL(@IS_FIRST_AIR,'N') = 'N' 
							THEN DATEADD(MINUTE,-1,DATEADD(HOUR,ISNULL(@No_of_days_hrs,24),CAST(CONVERT(varchar,@LSchedule_Item_Log_Date_Time,106) AS DATETIME)))
							ELSE DATEADD(MINUTE ,-1 ,(DATEADD(HOUR,ISNULL(@No_of_days_hrs,ISNULL(@No_of_days_hrs,24)),@LSchedule_Item_Log_Date_Time)))
							END
						,@LSchedule_Start_Time_Is_First_Air = DATEADD(MINUTE ,-1 ,(DATEADD(HOUR,-(ISNULL(@No_of_days_hrs,24)),@LSchedule_Item_Log_Date_Time)))

					END
				END
				ELSE
				BEGIN
					Update #Temp_BMS_Schedule_Right_Rule_data SET PlayDay=0,PlayRun=0,Is_Ignore='Y' Where TimeLine_ID=@TimeLine_ID 
				END
			END
		
		FETCH NEXT FROM CR_BMS_Schedule_Run_Temp INTO @BV_Schedule_Transaction_Code, @Is_Ignore,@Schedule_DateTime,@TimeLine_ID,@Ref_TimeLine_ID,@PlayDay,@PlayRun
		END
		CLOSE CR_BMS_Schedule_Run_Temp
		DEALLOCATE CR_BMS_Schedule_Run_Temp

		/***Added By Anchal For Play Day Play Run***/


		PRINT 'Update BV_Schedule_Transaction'
		IF(ISNULL(@Call_from,'P') = 'R')
		BEGIN
			UPDATE BST SET BST.Play_Day=TRR.PlayDay, BST.Play_Run=TRR.PlayRun, BST.Last_Updated_Time=GETDATE(),	BST.IsIgnore = TRR.Is_Ignore, 
			BST.Ref_Timeline_ID = TRR.Ref_TimeLine_ID
			FROM #Temp_BMS_Schedule_Right_Rule_data TRR 
			INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code=TRR.BV_Schedule_Transaction_Code AND	TRR.TimeLine_ID = BST.Timeline_ID 
			AND BST.Channel_Code = @ChannelCode AND (ISNULL(BST.Play_Day,0) != ISNULL(TRR.PlayDay,0) OR  ISNULL(BST.Play_Run,0) !=  ISNULL(TRR.PlayRun,0) OR ISNULL(BST.IsIgnore,'') != TRR.Is_Ignore)
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
	END TRY			 
	BEGIN CATCH				
		PRINT 'Catch Block in USP_BMS_Schedule_Right_Rule_Run_Process'
		DECLARE @ErMessage NVARCHAR(MAX),@ErSeverity INT,@ErState INT 
		SELECT @ErMessage = 'Error in USP_BMS_Schedule_Right_Rule_Run_Process : - ' +  ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE() 
		RAISERROR (@ErMessage,@ErSeverity,@ErState)  
	END CATCH		
	IF OBJECT_ID('tempdb..#Temp_BMS_Schedule_Right_Rule_data') IS NOT NULL DROP TABLE #Temp_BMS_Schedule_Right_Rule_data
END