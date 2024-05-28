CREATE PROCEDURE [dbo].[USPIsValidScheduleForRightRule]
(
	@BV_Schedule_Transaction_Code INT,
	@VW_DMR_Run_Code_Cr INT,
	@Schedule_Item_Log_Date VARCHAR(500),
	@Schedule_Item_Log_Time VARCHAR(500),
	@Title_Code INT,
	@ACQ_DEAL_Movie_Code INT,
	@Channel_Code INT,
	@EpisodeNumber INT,
	@VW_CCRCode_Cr INT,
	@Result CHAR(1) OUTPUT
)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPIsValidScheduleForRightRule]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		DECLARE @Is_RULE_Right VARCHAR(100), @Right_Rule_Code INT, @Repeat_Within_Days_Hrs VARCHAR(100), @No_of_days_hrs VARCHAR(100), @IS_First_AIR VARCHAR(10)
	
		SET @Is_RULE_Right = 'N'
		SET @Result = 'N' 

		SELECT  @Is_RULE_Right =  CASE WHEN ISNULL(Right_Rule_Code, 0)  > 0  THEN 'Y' ELSE 'N' END 
				,@Right_Rule_Code = ISNULL(Right_Rule_Code , 0)
				--,@Repeat_Within_Days_Hrs = ISNULL(Repeat_Within_Days_Hrs, '')
				--,@No_of_days_hrs = ISNULL(No_Of_Days_Hrs, '')
		FROM Content_Channel_Run  (NOLOCK) WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr --ACq_Deal_RUN_Code = @VW_DMR_Run_Code_Cr

		DECLARE @Start_Time TIME, @Play_Per_Day INT, @Duration_Of_Day INT, @No_Of_Repeat INT
		
		SELECT @Start_Time = Start_Time
			,@Play_Per_Day = Play_Per_Day
			,@Duration_Of_Day = Duration_Of_Day 
			,@No_Of_Repeat = No_Of_Repeat
			,@IS_FIRST_AIR = CASE WHEN ISNULL(IS_FIRST_AIR, 0) > 0 THEN 'Y' ELSE 'N' END 
		FROM Right_Rule  (NOLOCK) WHERE Right_Rule_Code = @Right_Rule_Code
				
		IF(@Is_RULE_Right = 'Y')
		BEGIN
			DECLARE @Schedule_Item_Log_Time_Inner VARCHAR(50), @SCHEDULE_ITEM_LOG_DATE_Inner VARCHAR(500), @Schedule_DAY VARCHAR(100)
			DECLARE @Min_dt_time DATETIME, @Max_dt_Time DATETIME
			DECLARE @Count_schedule INT 

			SET @Schedule_Item_Log_Time_Inner = @Schedule_Item_Log_Date
			SET @SCHEDULE_ITEM_LOG_DATE_Inner = @Schedule_Item_Log_Time
				
			IF( @IS_FIRST_AIR = 'Y')
			BEGIN
				SELECT 
				--@SCHEDULE_ITEM_LOG_DATE_Inner = MAX(SCHEDULE_ITEM_LOG_DATE),
					--@Schedule_Item_Log_Time_Inner = MAX(Schedule_Item_Log_Time) 
					@Min_dt_time = MAX(CAST(CAST(SCHEDULE_ITEM_LOG_DATE AS DATETIME) + CAST(Schedule_Item_Log_Time AS DATETIME) AS DATETIME))
				FROM BV_SCHEDULE_TRANSACTION (NOLOCK)  WHERE 1=1
				AND Content_Channel_Run_Code = @VW_CCRCode_Cr 
				--AND DEAL_MOVIE_CODE IN (@ACQ_DEAL_MOVIE_CODE)
				AND Title_Code IN (@Title_Code)
				AND CHANNEL_CODE IN (@CHANNEL_CODE)
				AND ISNULL(IsProcessed,'N') = 'Y'
	 			AND (CASE WHEN LTRIM(RTRIM(Program_Episode_Number)) = '' THEN '1' ELSE ISNULL(Program_Episode_Number, '1') END) IN (@EpisodeNumber)
				AND ISNULL(IsIgnore,'N') = 'N'
					
				SET @Schedule_DAY = DATENAME(dw, @Schedule_Item_Log_Date)
				IF(@Min_dt_time IS NULL)
				BEGIN
					SET @Min_dt_time = CAST(@SCHEDULE_ITEM_LOG_DATE_Inner AS DATETIME) + CAST(@Schedule_Item_Log_Time_Inner AS DATETIME)
				END
			END
			ELSE 
			BEGIN
				SELECT TOP 1 @Min_dt_time =  CAST( Schedule_Item_Log_Date + ' ' + cast(@Start_Time AS VARCHAR(8)) AS DATETIME) 
				FROM BV_Schedule_Transaction BST (NOLOCK) 
				WHERE Content_Channel_Run_Code = @VW_CCRCode_Cr  --DEAL_MOVIE_CODE IN (@ACQ_DEAL_MOVIE_CODE)
				and Title_Code in(@Title_Code)
				AND ISNULL(Isprocessed,'N') = 'Y' 
				and ISNULL(isignore,'N') = 'N'
				AND Channel_Code in (@Channel_Code)
				AND (CASE WHEN LTRIM(RTRIM(Program_Episode_Number)) = '' THEN '1' ELSE ISNULL(Program_Episode_Number, '1') END) in (@EpisodeNumber)
				ORDER BY BV_Schedule_Transaction_Code DESC
			END
				
				
			--IF(@Repeat_Within_Days_Hrs = 'D')
			--BEGIN
			--	DECLARE @ISDateDefined CHAR(1)
			--	SET @ISDateDefined = 'N'
					
			--	SELECT  @ISDateDefined = CASE WHEN COUNT(ADRR.Day_Code) >  0 THEN 'Y' ELSE 'N' END FROM Acq_Deal_Run ADR 
			--	INNER JOIN Acq_Deal_Run_Repeat_On_Day ADRR ON ADRR.Day_Code = ADR.Acq_Deal_Run_Code 
			--	AND ADR.Acq_Deal_Run_Code = @VW_DMR_Run_Code_Cr	
					
			--	IF(@ISDateDefined = 'N')
			--	BEGIN
			--		SET @No_of_days_hrs = @No_of_days_hrs * 24
			--		GOTO HRS_Logic;
			--	END
			--	ELSE
			--	BEGIN
			--		set @Result = 'N' /*Currently we considering there will be no Days specification for any Run*/
			--	END
			
			--END
			--ELSE 
			--BEGIN
			--	HRS_Logic:
					
				SELECT @Max_dt_Time = DATEADD(SECOND, -1, DATEADD(HOUR, CAST(@Duration_Of_Day AS INT), @Min_dt_time))
					
					--PRINT ' ' + cast(@Min_dt_time as varchar) + '  ' + cast(@Max_dt_Time as varchar)
					set @Count_schedule = 0
				
				IF( (SELECT COUNT(BV_Schedule_Transaction_Code) FROM BV_Schedule_Transaction  (NOLOCK) 
						WHERE  Content_Channel_Run_Code = @VW_CCRCode_Cr -- Deal_Movie_Code IN (@ACQ_DEAL_Movie_Code)
						AND Title_Code IN (@Title_Code)
						AND ISNULL(IsProcessed, 'N') = 'Y' 
						AND ISNULL(IsIgnore, 'N') = 'N'
						AND Channel_Code IN (@Channel_Code)
						AND (CASE WHEN LTRIM(RTRIM(Program_Episode_Number)) = '' THEN '1' ELSE ISNULL(Program_Episode_Number, '1') END) IN (@EpisodeNumber)
						AND CAST( Schedule_Item_Log_Date AS DATETIME) + cast( Schedule_Item_Log_Time AS DATETIME) BETWEEN @Min_dt_time AND @Max_dt_Time) > 0
					)
				BEGIN
					IF(CAST((CAST(@Schedule_Item_Log_Date AS DATETIME) + CAST(@Schedule_Item_Log_Time AS DATETIME)) AS DATETIME ) BETWEEN  @Min_dt_time AND @Max_dt_Time)
					BEGIN
						SELECT @Count_schedule = COUNT(*) FROM BV_Schedule_Transaction BST  (NOLOCK) 
						WHERE CAST(BST.Schedule_Item_Log_Date AS DATETIME) + CAST(BST.Schedule_Item_Log_Time  AS DATETIME) 
								BETWEEN @Min_dt_time AND @Max_dt_Time
						AND BST.Title_Code IN (@Title_Code)
	 					AND BST.Channel_Code IN (@Channel_Code)
						AND (CASE WHEN LTRIM(RTRIM(Program_Episode_Number)) = '' THEN '1' ELSE ISNULL(Program_Episode_Number,'1') END) IN (@EpisodeNumber)
						AND ISNULL(IsProcessed,'N') = 'Y' and BST.BV_Schedule_Transaction_Code <= @BV_Schedule_Transaction_Code
						--PRINT '@Count_schedule ' + cast(@Count_schedule as varchar)
					END
					ELSE
					BEGIN
						SET @Result = 'N'
						RETURN
					END
				END
					ELSE
					BEGIN
						SET @Result = 'N'
						RETURN
					END
						
					--PRINT ' ' + cast(@Count_schedule as varchar) + cast(@No_Of_Repeat as varchar) + cast(@Play_Per_Day as varchar)
					IF( @Count_schedule > (@No_Of_Repeat + @Play_Per_Day) )
					BEGIN
						SET @Result = 'N'
					END
					ELSE 
					BEGIN
						SET @Result = 'Y'
						UPDATE BV_Schedule_Transaction SET IsIgnore = 'Y' WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code
					END
			--END
			
		END
			PRINT '@Result ' + cast(@Result as varchar(1000))
		
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPIsValidScheduleForRightRule]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END