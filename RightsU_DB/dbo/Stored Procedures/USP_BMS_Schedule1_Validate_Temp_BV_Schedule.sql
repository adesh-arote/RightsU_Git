
ALTER PROCEDURE [dbo].[USP_BMS_Schedule1_Validate_Temp_BV_Schedule]	
(
	@File_Code BIGINT,
	@Channel_Code VARCHAR(10),
	@IsReprocess VARCHAR(10) = NULL,
	@BV_Episode_ID VARCHAR(1000) = NULL
)
AS
-- =============================================
-- Author:         <Jaydeep Parmar>
-- Create date:	   <16 Oct 2023>
-- Description:    <USP_BMS_Schedule1_Validate_Temp_BV_Schedule 16948,1>
-- =============================================
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY

		INSERT INTO ScheduleLog(USPName,File_Code,Channel_Code,IsProcess,BVID,STEPName,StepTime)
		SELECT 'USP_BMS_Schedule1_Validate_Temp_BV_Schedule',@File_Code,@Channel_Code,@IsReprocess,@BV_Episode_ID,'STEP 1 Begining',GETDATE()

		-------------------------------------------2.0 DELETE TEMP TABLES -------------------------------------------		
		
		IF OBJECT_ID('tempdb..#UnMatched_ProgramTitle') IS NOT NULL
		BEGIN
			DROP TABLE #UnMatched_ProgramTitle
		END
		
		IF OBJECT_ID('tempdb..#tmpDealNotApprove') IS NOT NULL
		BEGIN
			DROP TABLE #tmpDealNotApprove 
		END

		IF OBJECT_ID('tempdb..#BVScheduleTransaction_Revert') IS NOT NULL
		BEGIN
			DROP TABLE #BVScheduleTransaction_Revert
		END
		IF OBJECT_ID('tempdb..#RevertRightsDetails') IS NOT NULL
		BEGIN
			DROP TABLE #RevertRightsDetails
		END

		IF OBJECT_ID('tempdb..#RevertRightsDetails_Prime') IS NOT NULL
		BEGIN
			DROP TABLE #RevertRightsDetails_Prime
		END
	---------------------------------------------2.0 END DELETE TEMP TABLES -------------------------------------------

		CREATE TABLE #Temp_BV_Schedule		----- #Temp_BV_Schedule Data 
		(
			Temp_BV_Schedule_Code NUMERIC(18,0),
			Program_Episode_ID NVARCHAR(1000),			
			Program_Episode_Number NVARCHAR(100),
			Schedule_Item_Log_Date DATETIME, 
			Schedule_Item_Log_Time VARCHAR(50),
			Schedule_Item_Log_DateTime DATETIME,
			File_Code bigint,
			Channel_Code bigint,
			TitleCode NUMERIC(18,0),
			Deal_Code INT,
			DMCode INT,
			Deal_Count INT DEFAULT(0),
			IsDealApproved CHAR(1),
			BMS_Asset_Code INT,
			IsExceptionSent CHAR(1) DEFAULT('N')
		)

		CREATE TABLE #BVScheduleTransaction_Revert		----- BV_Schedule_Transaction Data 
		(
			BV_Schedule_Transaction_Code NUMERIC(18,0),				
			Schedule_Item_Log_DateTime DATETIME,
			File_Code bigint,
			Acq_Deal_Code INT,		
			BMS_Deal_Content_Rights_Code INT,
			Acq_Deal_Run_Code INT,
			IsPrime CHAR(1) DEFAULT('X')		
		)

		CREATE TABLE #RevertRightsDetails
		(
			BMS_Deal_Content_Rights_Code INT,
			Revert_Run_Count INT
		)

		CREATE TABLE #RevertRightsDetails_Prime
		(
			Acq_Deal_Run_Code INT,
			IsPrime CHAR(1) DEFAULT('X'),
			Revert_Run_Count INT
		)

		-----1.0----------------------------
		IF(@BV_Episode_ID = '')
		BEGIN
			set @BV_Episode_ID = 'N'
		END
		IF (@BV_Episode_ID IS NULL)
		BEGIN
			set @BV_Episode_ID = 'N'
		END

		/* Ignore Category other than movie   16 Dec 2014 Bhavesh */
		DELETE FROM Temp_BV_Schedule where Isnull(Program_Category,'') NOT IN ( select BV_Program_Category_Name from BV_Program_Category where Is_Active = 'Y')
		AND File_Code = @File_Code
		/* Ignore Category other than movie 16 Dec 2014 Bhavesh */

		DECLARE @CanProcessRun INT = 0
		IF(@IsReprocess IS NULL)
		BEGIN
			SET @IsReprocess = 'N'
		END
		-----1.0----------------------------		

		IF(@IsReprocess <> 'Y')
		BEGIN
			--===============3.0 REVERT_SCHEDULE_COUNT --===============
			--EXEC USP_Schedule_Revert_Count  @File_Code, @Channel_Code

			DECLARE @ScheStartDate DATETIME, @ScheEndDate DATETIME
			SELECT @ScheStartDate = StartDate, @ScheEndDate = EndDate FROM Upload_Files where File_code =  @File_Code

			INSERT INTO #BVScheduleTransaction_Revert 
			(
				BV_Schedule_Transaction_Code,Schedule_Item_Log_DateTime, File_Code, Acq_Deal_Code,IsPrime,BMS_Deal_Content_Rights_Code,Acq_Deal_Run_Code
			)
			SELECT  BV_Schedule_Transaction_Code,Schedule_Item_Log_DateTime, File_Code, Deal_Code,ISNULL(IsPrime,'X'),BMS_Deal_Content_Rights_Code,Acq_Deal_Run_Code
			FROM BV_Schedule_Transaction bst WHERE CAST(bst.Schedule_Item_Log_DateTime AS DATE) BETWEEN @ScheStartDate AND @ScheEndDate AND bst.Channel_Code = @Channel_Code AND bst.File_Code <> @File_Code
			AND ISNULL(bst.BMS_Deal_Content_Rights_Code,0) > 0

			INSERT INTO #RevertRightsDetails
			(
				Revert_Run_Count, BMS_Deal_Content_Rights_Code
			)
			SELECT COUNT(bst.BMS_Deal_Content_Rights_Code) Run_Count,bst.BMS_Deal_Content_Rights_Code
			FROM #BVScheduleTransaction_Revert bst 
			GROUP BY bst.BMS_Deal_Content_Rights_Code

			INSERT INTO #RevertRightsDetails_Prime
			(
				Revert_Run_Count, Acq_Deal_Run_Code, IsPrime
			)
			SELECT COUNT(*) Run_Count,BDRC.Acq_Deal_Run_Code,bst.IsPrime	
			FROM #BVScheduleTransaction_Revert bst 
			INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
			GROUP BY BDRC.Acq_Deal_Run_Code,bst.IsPrime

			UPDATE BDCR SET BDCR.Utilised_Run = ISNULL(BDCR.Utilised_Run,0) - RRD.Revert_Run_Count
			FROM BMS_Deal_Content_Rights BDCR
			INNER JOIN #RevertRightsDetails RRD ON RRD.BMS_Deal_Content_Rights_Code = BDCR.BMS_Deal_Content_Rights_Code
			WHERE ISNULL(BDCR.Utilised_Run,0) > 0 

			-- Revert Schedule Run Count for Run Definition Not in (C)
			UPDATE BDCR SET BDCR.Utilised_Run = ISNULL(BDCR.Utilised_Run,0) - T.Revert_Run_Count
			FROM BMS_Deal_Content_Rights BDCR
			INNER JOIN (
				SELECT COUNT(BDCR.BMS_Deal_Content_Rights_Code) Revert_Run_Count,BDCR.BMS_Deal_Content_Rights_Code
				FROM #BVScheduleTransaction_Revert BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.Acq_Deal_Run_Code=BVST.Acq_Deal_Run_Code AND BDCR.IS_Active='Y'
				INNER JOIN #RevertRightsDetails_Prime RRDP ON RRDP.Acq_Deal_Run_Code = BDCR.Acq_Deal_Run_Code
				INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = RRDP.Acq_Deal_Run_Code
				WHERE BDCR.RU_Channel_Code NOT IN (@Channel_Code) AND ADR.Run_Definition_Type NOT IN ('C')
				AND CAST(BVST.Schedule_Item_Log_DateTime as Date) BETWEEN BDCR.Start_Date AND BDCR.End_Date
				GROUP BY BDCR.BMS_Deal_Content_Rights_Code
			) T ON T.BMS_Deal_Content_Rights_Code = BDCR.BMS_Deal_Content_Rights_Code
			WHERE ISNULL(BDCR.Utilised_Run,0) > 0

			UPDATE ADR SET ADR.Prime_Time_Provisional_Run_Count = ISNULL(ADR.Prime_Time_Provisional_Run_Count,0) - RRDP.Revert_Run_Count
			FROM Acq_Deal_Run ADR
			INNER JOIN #RevertRightsDetails_Prime RRDP ON RRDP.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE RRDP.IsPrime = 'Y' AND ISNULL(ADR.Prime_Time_Provisional_Run_Count,0) > 0 

			UPDATE ADR SET ADR.Off_Prime_Time_Provisional_Run_Count = ISNULL(ADR.Off_Prime_Time_Provisional_Run_Count,0) - RRDP.Revert_Run_Count
			FROM Acq_Deal_Run ADR
			INNER JOIN #RevertRightsDetails_Prime RRDP ON RRDP.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE RRDP.IsPrime = 'N' AND ISNULL(ADR.Off_Prime_Time_Provisional_Run_Count,0) > 0

			-- Update No_OF_Runs_Sched of Acq_Deal_Run----------------------

			UPDATE ADR SET ADR.No_Of_Runs_Sched = T2.Run_Count
			FROM Acq_Deal_Run ADR
			INNER JOIN
			(
				SELECT SUM(Run_Count) Run_Count,Acq_Deal_Run_Code
				FROM (
					SELECT MAX(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
					FROM #BVScheduleTransaction_Revert bst 
					INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
					INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type <> 'C'
					GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
				) T1 Group by Acq_Deal_Run_Code
			) T2 ON T2.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code

			UPDATE ADR SET ADR.No_Of_Runs_Sched = T2.Run_Count
			FROM Acq_Deal_Run ADR
			INNER JOIN
			(
				SELECT SUM(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code
				FROM #BVScheduleTransaction_Revert bst 
				INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
				INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type = 'C'
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
					FROM #BVScheduleTransaction_Revert bst 
					INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
					INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type <> 'C'
					GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Acq_Deal_Run_Code,BDRC.RU_Channel_Code,BDRC.Start_Date,BDRC.End_Date
				) T1 Group by Acq_Deal_Run_Code,RU_Channel_Code
			) T2 ON T2.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code AND T2.RU_Channel_Code = ADRC.Channel_Code

			UPDATE ADRC SET ADRC.No_Of_Runs_Sched = T2.Run_Count
			FROM Acq_Deal_Run_Channel ADRC
			INNER JOIN
			(
				SELECT SUM(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,RU_Channel_Code
				FROM #BVScheduleTransaction_Revert bst 
				INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
				INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type = 'C'
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
					FROM #BVScheduleTransaction_Revert bst 
					INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
					INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type <> 'C'
					GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Acq_Deal_Run_Code,BDRC.RU_Channel_Code,BDRC.Start_Date,BDRC.End_Date
				) T1 Group by Acq_Deal_Run_Code,Start_Date,End_Date
			)T2 ON T2.Acq_Deal_Run_Code = ADRY.Acq_Deal_Run_Code AND T2.Start_Date = ADRY.Start_Date AND T2.End_Date = ADRY.End_Date

			UPDATE ADRY SET ADRY.No_Of_Runs_Sched = T2.Run_Count
			FROM Acq_Deal_Run_Yearwise_Run ADRY
			INNER JOIN
			(
				SELECT SUM(ISNULL(BDRC.Utilised_Run,0)) Run_Count,BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
				FROM #BVScheduleTransaction_Revert bst 
				INNER JOIN BMS_Deal_Content_Rights BDRC ON BDRC.BMS_Deal_Content_Rights_Code = bst.BMS_Deal_Content_Rights_Code 
				INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = BDRC.Acq_Deal_Run_Code AND ADR.Run_Definition_Type = 'C'
				GROUP BY BDRC.Acq_Deal_Run_Code,BDRC.Start_Date,BDRC.End_Date
			)T2 ON T2.Acq_Deal_Run_Code = ADRY.Acq_Deal_Run_Code AND T2.Start_Date = ADRY.Start_Date AND T2.End_Date = ADRY.End_Date
		
			DELETE FROM Email_Notification_Schedule
			WHERE (CONVERT(DATETIME,CONVERT(VARCHAR,Schedule_Item_Log_Date, 111), 111) + Schedule_Item_Log_Time) BETWEEN @ScheStartDate AND @ScheEndDate
					AND Channel_Code = @Channel_Code AND File_Code not in (@File_Code)
		
			DELETE BV
			FROM BV_Schedule_Transaction BV
			INNER JOIN #BVScheduleTransaction_Revert BVST ON BVST.BV_Schedule_Transaction_Code = BV.BV_Schedule_Transaction_Code

			PRINT '1 Revert Count'
		END

		PRINT '--===============4.0 PROCEES ALL MATCHED PROGRAMMIDS --==============='
--===================================================4.1 Inserting all matched PROGRAMMIDS records into BV_Schedule_Transaction --===============
			
			
			INSERT INTO #Temp_BV_Schedule
			(
				Temp_BV_Schedule_Code, Program_Episode_ID,Program_Episode_Number,Schedule_Item_Log_Date,Schedule_Item_Log_Time
				,File_Code,Channel_Code,TitleCode,Deal_Code,IsDealApproved
			)
			SELECT Temp_BV_Schedule_Code, Program_Episode_ID,Program_Episode_Number,Schedule_Item_Log_Date,Schedule_Item_Log_Time
			,File_Code,Channel_Code,TitleCode,Deal_Code,IsDealApproved
			FROM Temp_BV_Schedule TBV
			WHERE TBV.File_Code = @File_Code AND TBV.Channel_Code = @Channel_Code			

			select * from #Temp_BV_Schedule

			UPDATE tbs set TitleCode = BA.RU_Title_Code,BMS_Asset_Code=BA.BMS_Asset_Code --//UPDATE BMS_Asset_Code as well
			FROM #Temp_BV_Schedule tbs (NOLOCK)
			INNER JOIN BMS_Asset BA (NOLOCK) ON BA.BMS_Asset_Ref_Key COLLATE SQL_Latin1_General_CP1_CI_AS = tbs.Program_Episode_ID COLLATE SQL_Latin1_General_CP1_CI_AS
			where tbs.File_Code = @File_Code
			--select * from #Temp_BV_Schedule
			Update BV SET BV.Deal_Count=T.Deal_Count
			FROM #Temp_BV_Schedule BV
			INNER JOIN (
				SELECT COUNT(DISTINCT BD.Acq_Deal_Code) Deal_Count,BVST.BMS_Asset_Code,BVST.Program_Episode_ID, BVST.Schedule_Item_Log_Date
				FROM #Temp_BV_Schedule BVST
				INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Asset_Code = BVST.BMS_Asset_Code AND BDCR.RU_Channel_Code = @Channel_Code AND BDCR.IS_Active='Y'
				INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = BDCR.BMS_Deal_Content_Code AND BDC.IS_Active='Y'
				INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code AND BD.IS_Active='Y'
				WHERE BVST.Schedule_Item_Log_Date BETWEEN BDCR.Start_Date AND BDCR.End_Date
				GROUP BY BVST.BMS_Asset_Code,BVST.Program_Episode_ID, BVST.Schedule_Item_Log_Date
			) T ON T.BMS_Asset_Code=BV.BMS_Asset_Code AND T.Program_Episode_ID=BV.Program_Episode_ID AND T.Schedule_Item_Log_Date=BV.Schedule_Item_Log_Date

			UPDATE BVST SET BVST.Deal_Code = BD.Acq_Deal_Code
			FROM #Temp_BV_Schedule BVST
			INNER JOIN BMS_Deal_Content_Rights BDCR ON BDCR.BMS_Asset_Code = BVST.BMS_Asset_Code AND BDCR.RU_Channel_Code = @Channel_Code AND BDCR.IS_Active='Y'
			INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = BDCR.BMS_Deal_Content_Code AND BDC.IS_Active='Y'
			INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code AND BD.IS_Active='Y'			
			WHERE BVST.Schedule_Item_Log_Date BETWEEN BDCR.Start_Date AND BDCR.End_Date AND BVST.Deal_Count = 1

			UPDATE BVST SET BVST.Deal_Code = (
				SELECT TOP 1 AD.Acq_Deal_Code
				FROM BMS_Deal_Content_Rights BDCR 
				INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = BDCR.BMS_Deal_Content_Code AND BDC.IS_Active='Y' AND BDCR.IS_Active='Y'
				INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code AND BD.IS_Active='Y'
				INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = BD.Acq_Deal_Code AND AD.Is_Active='Y'
				WHERE BDCR.RU_Channel_Code = @Channel_Code AND BVST.Schedule_Item_Log_Date BETWEEN BDCR.Start_Date AND BDCR.End_Date 
				AND BDCR.Total_Runs > BDCR.Utilised_Run
				AND BVST.BMS_Asset_Code = BDCR.BMS_Asset_Code
				ORDER BY AD.Agreement_Date ASC
			)
			FROM #Temp_BV_Schedule BVST
			WHERE BVST.Deal_Count > 1

			UPDATE BVST SET BVST.Deal_Code = (
				SELECT TOP 1 AD.Acq_Deal_Code
				FROM BMS_Deal_Content_Rights BDCR 
				INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = BDCR.BMS_Deal_Content_Code AND BDC.IS_Active='Y' AND BDCR.IS_Active='Y'
				INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code AND BD.IS_Active='Y'
				INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = BD.Acq_Deal_Code AND AD.Is_Active='Y'
				WHERE BDCR.RU_Channel_Code = @Channel_Code AND BVST.Schedule_Item_Log_Date BETWEEN BDCR.Start_Date AND BDCR.End_Date
				AND BVST.BMS_Asset_Code = BDCR.BMS_Asset_Code
				ORDER BY AD.Agreement_Date DESC
			)
			FROM #Temp_BV_Schedule BVST
			WHERE BVST.Deal_Count > 1 AND ISNULL(BVST.Deal_Code, 0) = 0

			--//EXECUTE FIRST 4 STMT IN PROCESS2 to identify deal_code

			UPDATE tbs set DMCode = DM.ACQ_deal_movie_code,IsDealApproved = 'N'
			FROM #Temp_BV_Schedule tbs (NOLOCK)
			INNER JOIN ACQ_Deal D (NOLOCK) ON D.Acq_deal_code = tbs.Deal_Code
			INNER JOIN ACQ_Deal_Movie DM (NOLOCK) ON DM.Acq_deal_code = D.Acq_deal_code AND DM.Title_Code = tbs.TitleCode
					AND tbs.Program_Episode_Number BETWEEN DM.Episode_Starts_From AND DM.Episode_End_To
			where D.Is_Active = 'Y' 			
			AND tbs.File_Code = @File_Code

			select * from #Temp_BV_Schedule

			UPDATE tbs set DMCode = DM.ACQ_deal_movie_code, IsDealApproved = 'Y'
			FROM #Temp_BV_Schedule tbs (NOLOCK)
			INNER JOIN ACQ_Deal D (NOLOCK) ON D.Acq_deal_code = tbs.Deal_Code
			INNER JOIN ACQ_Deal_Movie DM (NOLOCK) ON DM.Acq_deal_code = D.Acq_deal_code AND DM.Title_Code = tbs.TitleCode
					AND tbs.Program_Episode_Number BETWEEN DM.Episode_Starts_From AND DM.Episode_End_To
			where D.is_active = 'Y' 
			and D.Deal_Workflow_Status = 'A' --AND ISNULL(d.status,'O') = 'O'
			AND tbs.File_Code = @File_Code 
			OR ((isnull(@BV_Episode_ID,'N') != 'N' AND @IsReprocess = 'N'  AND tbs.Program_Episode_ID = @BV_Episode_ID))

			select * from #Temp_BV_Schedule

			--//Basis on Deal_code identify ACQ_deal_movie_code,IsDealApproved = 'N'

			UPDATE tbs SET tbs.TitleCode = BVST.TitleCode,tbs.Deal_Code = BVST.Deal_Code ,tbs.DMCode = BVST.DMCode,tbs.IsDealApproved = BVST.IsDealApproved
			FROM Temp_BV_Schedule tbs 
			INNER JOIN #Temp_BV_Schedule BVST ON BVST.Temp_BV_Schedule_Code = tbs.Temp_BV_Schedule_Code


			select * from Temp_BV_Schedule Where File_Code=@File_Code and Channel_Code =@Channel_Code
			--//UPDATE TEMP_BV_SChedule table for Acq_Deal_Code, DMMovieCode, IsDealApproved basis on temp PK

			--//Identify TitleNotFound
			--//Identify DealNotFound
			--//Identify DealNotApprove


			--Current Procedure.
			--Process2 Proces.
			--Right Rule Process.
			--Revert Count.
			--Reprocess Schedule.

			--UPDATE Temp_BV_Schedule set DMCode = DM.ACQ_deal_movie_code,IsDealApproved = 'N'
			--		FROM Temp_BV_Schedule tbs (NOLOCK)
			--		INNER JOIN BMS_Asset BA (NOLOCK) ON BA.BMS_Asset_Ref_Key = tbs.Program_Episode_ID
			--		INNER JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Asset_Code = BA.BMS_Asset_Code					
			--		INNER JOIN BMS_Deal BD (NOLOCK) ON  BD.BMS_Deal_Code = BDC.BMS_Deal_Code
			--		INNER JOIN ACQ_Deal D (NOLOCK) ON D.Acq_deal_code = BD.Acq_Deal_Code
			--		INNER JOIN ACQ_Deal_Movie DM (NOLOCK) ON DM.Acq_deal_code = D.Acq_deal_code AND DM.Title_Code = BA.RU_Title_Code
			--				AND BA.Episode_Number BETWEEN DM.Episode_Starts_From AND DM.Episode_End_To
			--		where 1=1 
			--		AND d.is_active = 'Y' 
			--		--and d.deal_workflow_status = 'A' --AND ISNULL(d.status,'O') = 'O'
			--		AND tbs.File_Code = @File_Code
			
			--UPDATE Temp_BV_Schedule set DMCode = DM.ACQ_deal_movie_code, IsDealApproved = 'Y'
			--		FROM Temp_BV_Schedule tbs (NOLOCK)
			--		INNER JOIN BMS_Asset BA (NOLOCK) ON BA.BMS_Asset_Ref_Key = tbs.Program_Episode_ID AND (
			--						(isnull(@BV_Episode_ID,'N') != 'N' AND @IsReprocess = 'N'  AND BA.BMS_Asset_Ref_Key = @BV_Episode_ID) OR 1=1 )
			--		INNER JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Asset_Code = BA.BMS_Asset_Code					
			--		INNER JOIN BMS_Deal BD (NOLOCK) ON  BD.BMS_Deal_Code = BDC.BMS_Deal_Code
			--		INNER JOIN ACQ_Deal D (NOLOCK) ON D.Acq_deal_code = BD.Acq_Deal_Code
			--		INNER JOIN ACQ_Deal_Movie DM (NOLOCK) ON DM.Acq_deal_code = D.Acq_deal_code AND DM.Title_Code = BA.RU_Title_Code 
			--				AND BA.Episode_Number BETWEEN DM.Episode_Starts_From AND DM.Episode_End_To
			--		where 1=1 
			--		AND D.is_active = 'Y' 
			--		and D.deal_workflow_status = 'A' --AND ISNULL(d.status,'O') = 'O'
			--		AND tbs.File_Code = @File_Code

			
			PRINT '--===============4.0 PROCEES ALL MATCHED PROGRAMMIDS --==============='

			--DELETE FROM Temp_BV_Schedule  where Temp_BV_Schedule_Code in 
			--(
			--		SELECT DISTINCT Temp_BV_Schedule_Code from Temp_BV_Schedule TBS
			--		INNER JOIN BV_HouseId_Data BSD on BSD.Program_Episode_ID = TBS.Program_Episode_ID
			--		AND BSD.IsIgnore = 'Y' AND tbs.File_Code = @File_Code AND Channel_Code = @Channel_Code
			--)

			SELECT DISTINCT ISNULL(BA.BMS_Asset_Ref_Key,'') as [Program_Episode_ID] 
			INTO #TMP_Program_Episode_ID
			FROM ACQ_Deal D (NOLOCK) 
			INNER JOIN BMS_Deal BD ON BD.Acq_Deal_Code=D.Acq_Deal_Code
			INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Code=BD.BMS_Deal_Code
			INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code=BDC.BMS_Asset_Code
			WHERE 1=1 AND (D.is_active = 'Y') AND ((D.deal_workflow_status = 'A') OR CAST(D.[version] AS  NUMERIC(18, 2)) > 1)

			INSERT INTO BV_Schedule_Transaction 
			(	
				Program_Episode_ID,Program_Version_ID,Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category, 
				Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, 
				Scheduled_Version_House_Number_List, Found_Status, 
				File_Code, Channel_Code, IsProcessed, Inserted_By, Inserted_On,Title_Code,Schedule_Item_Log_DateTime,IsDealApproved,Deal_Movie_Code,Deal_Code
			)
			SELECT tbs.Program_Episode_ID,tbs.Program_Version_ID,tbs.Program_Episode_Title,CASE WHEN ISNULL(tbs.Program_Episode_Number,'') = '' THEN '1' ELSE tbs.Program_Episode_Number END,
				   tbs.Program_Title,tbs.Program_Category,tbs.Schedule_Item_Log_Date,tbs.Schedule_Item_Log_Time,tbs.Schedule_Item_Duration, 
				   '1' AS Scheduled_Version_House_Number_List,'Y', 
				   tbs.File_Code, tbs.Channel_Code, 'N', tbs.Inserted_By , GETDATE(),tbs.TitleCode,
				   CONVERT(datetime,(CONVERT(date,tbs.Schedule_Item_Log_Date)  + CAST(tbs.Schedule_Item_Log_Time as datetime)),101),tbs.IsDealApproved,tbs.DMCode,tbs.Deal_Code
			FROM Temp_BV_Schedule tbs (NOLOCK)			
			WHERE 1=1 
			AND 
			( 
				(
					isnull(@BV_Episode_ID,'N') != 'N' AND @IsReprocess = 'N' AND tbs.Program_Episode_ID in 
					(
						@BV_Episode_ID
					)
				)
				OR
				(
					@IsReprocess <> 'Y'
					AND
					isnull(@BV_Episode_ID,'N') = 'N'
					AND
					tbs.Program_Episode_ID in 
					(
						SELECT Program_Episode_ID FROM #TMP_Program_Episode_ID
					)
				)
			)
			AND TBS.File_Code = @File_Code  AND Tbs.Channel_Code = @Channel_Code 
			ORDER BY tbs.Temp_BV_Schedule_Code
			
			PRINT '2.1'

			IF(@IsReprocess <> 'Y' AND isnull(@BV_Episode_ID,'N') = 'N' )
			BEGIN

				PRINT '--===============8.0 Inserting all invalid houseds records into Upload_Err_Detail table --==============='		

				INSERT INTO Upload_Err_Detail 
				(
					file_code, Row_Num,Row_Delimed,Err_Cols, Upload_Type, Upload_Title_Type
				)
				SELECT DISTINCT @File_Code, 0, '~~' + UPT.Program_Title +' ~~~'+ '1' AS Scheduled_Version_House_Number_List ,'1HID_N','S','M'
				FROM Temp_BV_Schedule UPT (NOLOCK)				
				INNER JOIN #Temp_BV_Schedule BV ON BV.Temp_BV_Schedule_Code = UPT.Temp_BV_Schedule_Code
				WHERE 1=1 AND BV.File_Code = @File_Code AND BV.Channel_Code = @Channel_Code--AND ISNULL(UPT.IsDealApproved,'Y') = 'Y'
				AND ISNULL(BV.TitleCode, 0) = 0 AND BV.IsExceptionSent = 'N'

				----------------8.1 SEND EXCEPTION EMAIL HOUSEDID NOT FOUND------------
				DECLARE @EmailMsg_New NVARCHAR(MAX)
				SELECT @EmailMsg_New = Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'HouseIDNotFound' and [Type] = 'S'
			
				INSERT INTO Email_Notification_Schedule
				(
					BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
					Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
					File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
					Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code
				)
				select tbs.Temp_BV_Schedule_Code, tbs.Program_Episode_Title, tbs.Program_Episode_Number, tbs.Program_Title, tbs.Program_Category,
				tbs.Schedule_Item_Log_Date, tbs.Schedule_Item_Log_Time, tbs.Schedule_Item_Duration, '1'  as Scheduled_Version_House_Number_List,
				tbs.File_Code, tbs.Channel_Code, GETDATE(), NULL, NULL,
				@EmailMsg_New, 'N', 'N', NULL
				FROM Temp_BV_Schedule tbs (NOLOCK)				
				INNER JOIN #Temp_BV_Schedule BV ON BV.Temp_BV_Schedule_Code = tbs.Temp_BV_Schedule_Code
				WHERE 1=1 AND BV.File_Code = @File_Code AND BV.Channel_Code = @Channel_Code --AND ISNULL(UPT.IsDealApproved,'Y') = 'Y'
				AND ISNULL(BV.TitleCode, 0) = 0 AND BV.IsExceptionSent = 'N'	 

				UPDATE #Temp_BV_Schedule SET IsExceptionSent = 'Y'
				WHERE 1=1 AND File_Code = @File_Code AND Channel_Code = @Channel_Code --AND ISNULL(UPT.IsDealApproved,'Y') = 'Y'
				AND ISNULL(TitleCode, 0) = 0 AND IsExceptionSent = 'N'

				----------------8.1 SEND EXCEPTION EMAIL HOUSEDID NOT FOUND------------	

				PRINT '--===============8.0 Inserting all invalid houseds records into Upload_Err_Detail table --==============='
			END
			
			PRINT '----------  PROCESS THOSE TITLES WHOSE DEALS NOT FOUND ---------------'

			INSERT INTO Upload_Err_Detail 
			(
				file_code, Row_Num,Row_Delimed,Err_Cols, Upload_Type, Upload_Title_Type
			)
			SELECT DISTINCT @File_Code, 0, '~~' + BVST.Program_Title +' ~~~'+ '1' AS Scheduled_Version_House_Number_List ,'1DNF','S','M'
			FROM Temp_BV_Schedule BVST  			
			INNER JOIN #Temp_BV_Schedule BV ON BV.Temp_BV_Schedule_Code = BVST.Temp_BV_Schedule_Code
			WHERE 1=1 AND BV.File_Code = @File_Code AND BV.Channel_Code = @Channel_Code AND ISNULL(BV.Deal_Code,0)=0 AND BV.IsExceptionSent = 'N'

			DECLARE @EmailMsg_New_Deal NVARCHAR(MAX)
			SELECT @EmailMsg_New_Deal =  Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'Deal_Not_Found' and [Type] = 'S'
		
			INSERT INTO Email_Notification_Schedule 
			(
				BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
				Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
				File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
				Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code
			)
			SELECT BVST.Temp_BV_Schedule_Code,BVST.Program_Episode_Title,BVST.Program_Episode_Number,BVST.Program_Title,BVST.Program_Category,
			BVST.Schedule_Item_Log_Date,BVST.Schedule_Item_Log_Time,BVST.Schedule_Item_Duration,BVST.Scheduled_Version_House_Number_List,
			BVST.File_Code,@Channel_Code,GETDATE(),BVST.DMCode,null,
			@EmailMsg_New_Deal, 'N', 'N', BVST.TitleCode
			FROM Temp_BV_Schedule BVST 
			INNER JOIN #Temp_BV_Schedule BV ON BV.Temp_BV_Schedule_Code = BVST.Temp_BV_Schedule_Code
			WHERE 1=1 AND BV.File_Code = @File_Code AND BV.Channel_Code = @Channel_Code AND ISNULL(BV.Deal_Code,0)=0 AND BV.IsExceptionSent = 'N'

			UPDATE #Temp_BV_Schedule SET IsExceptionSent = 'Y'
			WHERE 1=1 AND File_Code = @File_Code AND Channel_Code = @Channel_Code AND ISNULL(Deal_Code,0)=0 AND IsExceptionSent = 'N'

			UPDATE BV_Schedule_Transaction SET IsException = 'Y' WHERE 1=1 AND File_Code = @File_Code AND Channel_Code = @Channel_Code AND ISNULL(Deal_Code,0)=0

			PRINT '----------  PROCESS THOSE TITLES WHOSE DEALS ARE NOT APPROVED ---------------'

			INSERT INTO Upload_Err_Detail 
			(
				file_code, Row_Num,Row_Delimed,Err_Cols, Upload_Type, Upload_Title_Type
			)
			SELECT DISTINCT @File_Code, 0, '~~' + Program_Title +' ~~~'+ '1' AS Scheduled_Version_House_Number_List ,'1DNA','S','M'
			FROM Temp_BV_Schedule UPT  
			INNER JOIN #Temp_BV_Schedule BV ON BV.Temp_BV_Schedule_Code = UPT.Temp_BV_Schedule_Code
			WHERE 1=1 AND BV.File_Code = @File_Code AND BV.Channel_Code = @Channel_Code AND ISNULL(BV.IsDealApproved,'Y') = 'N'	AND BV.IsExceptionSent = 'N'

			DECLARE @EmailMsg NVARCHAR(MAX)
			SELECT @EmailMsg =  Email_Msg FROM Email_Notification_Msg WHERE LTRIM(RTRIM(Email_Msg_For)) = 'Deal_Not_Approve' and [Type] = 'S'
		
			INSERT INTO Email_Notification_Schedule 
			(
				BV_Schedule_Transaction_Code, Program_Episode_Title, Program_Episode_Number, Program_Title, Program_Category,
				Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration, Scheduled_Version_House_Number_List,
				File_Code, Channel_Code, Inserted_On, Deal_Movie_Code, Deal_Movie_Rights_Code, 
				Email_Notification_Msg, IsMailSent, IsRunCountCalculate, Title_Code
			)
			SELECT tbs.Temp_BV_Schedule_Code, tbs.Program_Episode_Title, tbs.Program_Episode_Number, tbs.Program_Title, tbs.Program_Category,
			tbs.Schedule_Item_Log_Date, tbs.Schedule_Item_Log_Time, tbs.Schedule_Item_Duration, 1 AS Scheduled_Version_House_Number_List,
			tbs.File_Code, tbs.Channel_Code, GETDATE() Inserted_On, DM.Acq_Deal_Movie_Code AS Deal_Movie_Code, NULL AS Deal_Movie_Rights_Code,
			@EmailMsg + ' (Deal No:- '+ CAST (D.Agreement_No as VARCHAR(50)) + ') ' AS Email_Notification_Msg,'N' AS IsMailSent, 'N' AS IsRunCountCalculate, 
			NULL AS Title_Code			
			FROM Temp_BV_Schedule tbs (NOLOCK)
			INNER JOIN #Temp_BV_Schedule BV ON BV.Temp_BV_Schedule_Code = tbs.Temp_BV_Schedule_Code
			INNER JOIN ACQ_Deal D (NOLOCK) ON D.Acq_deal_code = tbs.Deal_Code
			INNER JOIN ACQ_Deal_Movie DM (NOLOCK) ON DM.Acq_deal_code = D.Acq_deal_code	AND tbs.Program_Episode_Number BETWEEN DM.Episode_Starts_From AND DM.Episode_End_To
			WHERE 1=1 AND BV.File_Code = @File_Code AND BV.Channel_Code = @Channel_Code AND ISNULL(BV.IsDealApproved,'Y') = 'N'	AND BV.IsExceptionSent = 'N'
			
			PRINT '1'

			UPDATE #Temp_BV_Schedule SET IsExceptionSent = 'Y'
			WHERE 1=1 AND File_Code = @File_Code AND Channel_Code = @Channel_Code AND ISNULL(IsDealApproved,'Y') = 'N'	AND IsExceptionSent = 'N'
			
			UPDATE BV_Schedule_Transaction SET IsException = 'Y' 
			WHERE ISNULL(IsDealApproved,'Y') = 'N' AND File_Code = @File_Code AND Channel_Code = @Channel_Code
			
			PRINT '2'
			--===============4.2 DELETING all matched PROGRAMMIDS records from Temp_BV_Schedule --===============
			DELETE FROM Temp_BV_Schedule WHERE File_Code = @File_Code AND Temp_BV_Schedule_Code IN
			(
				SELECT tbs.Temp_BV_Schedule_Code FROM Temp_BV_Schedule tbs (NOLOCK)				
				WHERE 1=1
				AND 
				(
					(
						ISNULL(@BV_Episode_ID,'N') != 'N' AND @IsReprocess = 'N' AND tbs.Program_Episode_ID in 
						(
							@BV_Episode_ID
						)
					)
					OR
					(
						ISNULL(@BV_Episode_ID,'N') = 'N' 
						AND
						@IsReprocess <> 'Y'	 
						AND tbs.Program_Episode_ID IN 
						(
							SELECT Program_Episode_ID FROM #TMP_Program_Episode_ID
						)
					)
				)
				AND TBS.File_Code = @File_Code
			)

			--------- Update Fileds ------------------------------
			UPDATE Email_Notification_Schedule
			SET Channel_Name = (SELECT channel_name AS Channel_Name FROM Channel WHERE channel_code = Email.Channel_Code)
			FROM Email_Notification_Schedule Email
			where Email.File_Code = @File_Code

			INSERT INTO ScheduleLog(USPName,File_Code,Channel_Code,IsProcess,BVID,CanProcess,STEPName,StepTime)
			SELECT 'USP_BMS_Schedule1_Validate_Temp_BV_Schedule',@File_Code,@Channel_Code,@IsReprocess,@BV_Episode_ID,@CanProcessRun,'STEP 2 Before Schedule Process',GETDATE()

			PRINT '--===============11.0 PROCESS_DATA --==============='
			--EXEC USP_BMS_Schedule2_Process  @File_Code , @Channel_Code,0,'N', @CanProcessRun--,@Called_FROM_JOB
		
			IF((select isnull(Parameter_Value,'N') from System_Parameter_New where Parameter_Name ='IS_Schedule_Mail_Channelwise')  = 'Y' )
			BEGIN
				EXEC usp_Schedule_SendException_Email @File_Code, @Channel_Code
			END

			IF(@IsReprocess <> 'Y')
			BEGIN
				PRINT '--===============13.0 PROCESS_SHOWS_DATA --==============='
				/*Need to uncomment this part Bhavesh */
				--EXEC [usp_Schedule_Validate_Temp_BV_Sche_Show] @File_Code, @Channel_Code, 'N', 'S'
				/*END OF Need to uncomment this part Bhavesh */
			END

			PRINT '--===============14.0 FINAL RETRUN RESULT --==============='		
			DECLARE @IsErrYN CHAR(1);	SET @IsErrYN = 'N'
			DECLARE @Count INT;			SET @Count = 0
			DECLARE @CountShows INT;	SET @CountShows = 0
			SELECT @CountShows = COUNT(*) FROM Temp_BV_Schedule WHERE File_Code = @File_Code
			SELECT @Count = COUNT(*) FROM Temp_BV_Schedule WHERE File_Code = @File_Code
			IF(@Count + @CountShows > 0)
			BEGIN
				SET @IsErrYN = 'Y'
			END
			ELSE 
			BEGIN
				SET @IsErrYN = 'N'
				DELETE FROM Upload_Err_Detail WHERE File_code = @File_Code
			END
			UPDATE Upload_Files SET Err_YN = @IsErrYN WHERE File_code = @File_Code
			PRINT '--===============14.0 END FINAL RETRUN RESULT --==============='

		--SELECT * FROM Temp_BV_Schedule WHERE File_Code = @File_Code


	END TRY
	BEGIN CATCH
		PRINT 'ERROR'
		PRINT ERROR_MESSAGE() 
	
		INSERT INTO	ErrorOn_AsRun_Schedule
		SELECT
		ERROR_NUMBER() AS ERRORNUMBER,
		ERROR_SEVERITY() AS ERRORSEVERITY,		
		ERROR_STATE() AS ERRORSTATE,
		ERROR_PROCEDURE() AS ERRORPROCEDURE,
		ERROR_LINE() AS ERRORLINE,
		ERROR_MESSAGE() AS ERRORMESSAGE,
		@File_Code, @Channel_Code, 'S', GETDATE() 
	
		UPDATE Upload_Files set Err_YN = 'Y' WHERE File_code = @File_Code
	END CATCH
END