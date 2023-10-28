CREATE Procedure [dbo].[USP_Validate_Run_Udt]	
	@Deal_Run_Title [Deal_Run_Title] READONLY,
	@Deal_Run_Yearwise_Run [Deal_Run_Yearwise_Run] READONLY,
	@Deal_Run_Channel [Deal_Run_Channel] READONLY	,
	@Acq_Deal_Code INT
AS
-- =============================================
-- Author:		Rajesh
-- Create DATE: 18-August-2015
-- Description:	Validating Acq run with schedule run
-- =============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Validate_Run_Udt]', 'Step 1', 0, 'Started Procedure', 0, ''	
		CREATE TABLE #TEMP(	
			Title_Name NVARCHAR(MAX),
			Episode_No INT,
			StartDate VARCHAR(12),
			EndDate VARCHAR(12),
			Channel_Name NVARCHAR(100),
			No_Of_Runs INT,
			No_Of_Schd_Run INT
		)
		--DECLARE @Acq_Deal_Movie_Code INT = 0
		--DECLARE deal_run_Cursor CURSOR FOR
		--Select Acq_Deal_Movie_Code from Acq_Deal_Movie ADM
		--inner join @Deal_Run_Title DRT ON ADM.Title_Code = DRT.Title_Code AND ADM.Episode_Starts_From = DRT.Episode_From AND ADM.Episode_End_To = DRT.Episode_To
		--WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code
		--OPEN deal_run_Cursor

		DECLARE @Title_Code INT = 0, @Ref_BMS_Content_Code VARCHAR(50), @Episode_No INT
		DECLARE deal_run_Cursor CURSOR FOR
			SELECT DISTINCT CCR.Title_Code, TC.Ref_BMS_Content_Code, TC.Episode_No from Content_Channel_Run CCR (NOLOCK)
			INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Content_Code = CCR.Title_Content_Code
			inner join @Deal_Run_Title DRT  ON CCR.Acq_Deal_Run_Code = DRT.Deal_Run_Code AND CCR.Title_Code = DRT.Title_Code 
			AND (TC.Episode_No BETWEEN DRT.Episode_From AND DRT.Episode_To)
			WHERE CCR.Acq_Deal_Code = @Acq_Deal_Code
		OPEN deal_run_Cursor

			--FETCH NEXT FROM deal_run_Cursor INTO @Acq_Deal_Movie_Code
		FETCH NEXT FROM deal_run_Cursor INTO @Title_Code, @Ref_BMS_Content_Code, @Episode_No
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO #TEMP(Title_Name, Episode_No, StartDate, EndDate, Channel_Name, No_Of_Runs, No_Of_Schd_Run)
			SELECT tl.Title_Name, @Episode_No, CONVERT(VARCHAR(12),y.Start_Date,106) AS StartDate , CONVERT(VARCHAR(12),y.End_Date,106) AS EndDate, 'NA' AS Channel_Name,y.No_Of_Runs, 
			COUNT(t.BV_Schedule_Transaction_Code) as No_Of_Schd_Run 
			FROM BV_Schedule_Transaction t (NOLOCK)
			INNER JOIN @Deal_Run_Yearwise_Run y  ON t.Schedule_Item_Log_Date BETWEEN y.Start_Date and y.End_Date
			INNER JOIN Title tl (NOLOCK) ON tl.Title_Code = t.Title_Code 
			INNER JOIN @Deal_Run_Channel c  ON c.Channel_Code = t.Channel_Code
			WHERE t.Title_Code = @Title_Code AND c.Deal_Run_Code = y.Deal_Run_Code AND t.Program_Episode_ID = @Ref_BMS_Content_Code 
			AND CAST(t.Program_Episode_Number AS INT) = @Episode_No
			AND ISNULL(t.IsIgnore,'N') = 'N'
			AND ISNULL(t.IsProcessed,'N') = 'Y'
			GROUP BY  y.Start_Date ,y.End_Date,y.No_Of_Runs,tl.Title_Name
			HAVING count(t.BV_Schedule_Transaction_Code) > y.No_Of_Runs

			IF((SELECT TOP 1 Run_Definition_Type FROM Acq_Deal_Run (NOLOCK)	WHERE Acq_Deal_Run_Code in (SELECT Deal_Run_Code FROM @Deal_Run_Channel )) = 'C')
			BEGIN

			-----------------Consider Title With Rights Code---------------------------------------------------
				DECLARE @RightsStartDate DATE, @RightsEndDate DATE
				SELECT @RightsStartDate = MIN(adr.Actual_Right_Start_Date),
						@RightsEndDate = MAX(adr.Actual_Right_End_Date)
				FROM Acq_Deal_Rights adr (NOLOCK) WHERE adr.Acq_Deal_Code = @Acq_Deal_Code AND adr.Acq_Deal_Rights_Code IN (
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Title (NOLOCK) WHERE Title_Code = @Title_Code AND @Episode_No between Episode_From AND Episode_To
				) AND adr.Acq_Deal_Rights_Code IN (
					SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform  (NOLOCK) WHERE Platform_Code IN(Select Platform_Code from Platform Where Is_No_Of_Run = 'Y') AND Acq_Deal_Rights_Code IS NOT NULL
				) AND Actual_Right_Start_Date IS NOT NULL -----1 min--perprtuity asel tar ohhhhh sorry start date kar

				INSERT INTO #TEMP(Title_Name, Episode_No, StartDate, EndDate, Channel_Name, No_Of_Runs, No_Of_Schd_Run)
				SELECT tl.Title_Name, @Episode_No, 'NA' AS StartDate ,'NA' AS EndDate, cn.Channel_Name, c.Min_Runs AS No_Of_Runs ,count(t.BV_Schedule_Transaction_Code) AS No_Of_Schd_Run 
				FROM BV_Schedule_Transaction t (NOLOCK)
				INNER JOIN @Deal_Run_Channel c ON c.Channel_Code = t.Channel_Code
				INNER JOIN Title tl (NOLOCK) ON tl.Title_Code = t.Title_Code
				INNER JOIN Channel cn (NOLOCK) ON cn.Channel_Code = c.Channel_Code
				--INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = t.Deal_Movie_Rights_Code AND adr.Acq_Deal_Code = @Acq_Deal_Code
				WHERE t.Title_Code = @Title_Code AND t.Program_Episode_ID = @Ref_BMS_Content_Code
				AND CAST(t.Program_Episode_Number AS INT) = @Episode_No
				AND ISNULL(t.IsIgnore,'N') = 'N'
				AND ISNULL(t.IsProcessed,'N') = 'Y'
				AND t.Schedule_Item_Log_Date BETWEEN @RightsStartDate and @RightsEndDate
				GROUP BY c.Channel_Code,c.Min_Runs,tl.Title_Name,cn.Channel_Name
				HAVING  COUNT(t.BV_Schedule_Transaction_Code) > c.Min_Runs
			END
			--ELSE
			--BEGIN
			--	DECLARE @No_OF_RUNS INT 
			--	set @No_OF_RUNS= 0 
					
			--	select top 1 @No_OF_RUNS = No_Of_Runs from Acq_Deal_Run	where Acq_Deal_Run_Code in (select Deal_Run_Code from @Deal_Run_Channel )
					
			--	INSERT INTO #TEMP(Title_Name,StartDate,EndDate,Channel_Name,No_Of_Runs,No_Of_Schd_Run)
			--	Select tl.Title_Name,'NA' as StartDate ,'NA' as EndDate, cn.Channel_Name, c.Min_Runs as No_Of_Runs ,count(t.BV_Schedule_Transaction_Code) as No_Of_Schd_Run from BV_Schedule_Transaction t
			--	INNER JOIN @Deal_Run_Channel c ON c.Channel_Code = t.Channel_Code
			--	INNER JOIN Title tl ON tl.Title_Code = t.Title_Code
			--	INNER JOIN Channel cn ON cn.Channel_Code = c.Channel_Code
			--	WHERE t.Deal_Movie_Code = @Acq_Deal_Movie_Code
			--	group by  c.Channel_Code,c.Min_Runs,tl.Title_Name,cn.Channel_Name
			--	having  count(t.BV_Schedule_Transaction_Code) > @No_OF_RUNS
			--END

			--FETCH NEXT FROM deal_run_Cursor INTO @Acq_Deal_Movie_Code
			FETCH NEXT FROM deal_run_Cursor INTO @Title_Code, @Ref_BMS_Content_Code, @Episode_No

		END

		CLOSE deal_run_Cursor;
		DEALLOCATE deal_run_Cursor;


		SELECT Title_Name, Episode_No, StartDate, EndDate, Channel_Name, No_Of_Runs, No_Of_Schd_Run FROM #TEMP

		IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Run_Udt]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END