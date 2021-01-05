CREATE PROCEDURE [dbo].[USP_BMS_Schedule]
--DECLARE
@Is_Reprocess CHAR(1) = 'N'
AS
-- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:	   <09 Aug 2016>
-- Description:    <RU BV Schedule Integration>
-- =============================================
BEGIN   
    SET NOCOUNT ON;
	IF(@Is_Reprocess = 'Y')
	BEGIN
		UPDATE BSPDT SET BSPDT.Record_Status = 'P' FROM BMS_Schedule_Exception BSE
		INNER JOIN BMS_Schedule_Process_Data_Temp BSPDT ON BSPDT.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
		AND BSPDT.Is_Error = 'Y' 

		UPDATE BSPDT SET BSPDT.Record_Status = 'P' FROM BV_Schedule_Transaction BST
		INNER JOIN BMS_Schedule_Process_Data_Temp BSPDT ON 
		BST.Timeline_ID = BSPDT.Timeline_ID AND BST.File_Code = BSPDT.BMS_Schedule_Log_Code
		where IsException = 'Y' AND BST.Timeline_ID IS NOT NULL
	END

	PRINT '----------------------------Start Logic of USP_BMS_Schedule------------------------------------------------'
	/************************DELETE TEMP TABLES *************************/
	BEGIN

   		IF OBJECT_ID('tempdb..#UnMapped_Titles') IS NOT NULL
		BEGIN
			DROP TABLE #UnMapped_Titles
		END
		IF OBJECT_ID('tempdb..#BMS_Schedule_Process_Data_Temp') IS NOT NULL
		BEGIN
			DROP TABLE #BMS_Schedule_Process_Data_Temp
		END		
		IF OBJECT_ID('tempdb..#Revert_Titles') IS NOT NULL
		BEGIN
			DROP TABLE #Revert_Titles
		END
		IF OBJECT_ID('tempdb..#Process_Titles') IS NOT NULL
		BEGIN
			DROP TABLE #Process_Titles
		END
		IF OBJECT_ID('tempdb..#BMS_Schedule_Runs') IS NOT NULL
		BEGIN
			DROP TABLE #BMS_Schedule_Runs
		END
		IF OBJECT_ID('tempdb..#Delete_Titles') IS NOT NULL
		BEGIN
			DROP TABLE #Delete_Titles
		END
		IF OBJECT_ID('tempdb..#TempMinDate') IS NOT NULL
		BEGIN
			DROP TABLE #TempMinDate
		END
		IF OBJECT_ID('tempdb..#TempSchedule_Item_Log_Time') IS NOT NULL
		BEGIN
			DROP TABLE #TempSchedule_Item_Log_Time
		END
		IF OBJECT_ID('tempdb..#TEMP_BV_Schedule') IS NOT NULL
		BEGIN
			DROP TABLE #TEMP_BV_Schedule
		END
	END
	 /************************CREATE TEMP TABLES *********************/
	BEGIN
		CREATE TABLE #BMS_Schedule_Process_Data_Temp
		(
			BMS_Schedule_Process_Data_Temp_Code INT,
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Acq_Deal_Run_Code INT,
			Agreement_Date DATETIME,
			BMS_Asset_Ref_Key INT,
			BMS_Schedule_Log_Code INT,
			Channel_Code INT,
			Deal_Workflow_Status VARCHAR(2),
			Delete_Flag BIT,
			Do_Not_Consume VARCHAR(10),
			Is_In_BlackOut_Period VARCHAR(3),
			Is_In_Right_Perod VARCHAR(3),
			Is_Yearwise_Definition VARCHAR(10),
			No_Of_Runs INT,
			No_Of_Runs_Sched INT,
			Right_Start_Date DATETIME  NULL,
			Right_End_Date DATETIME NULL,
			Right_Type VARCHAR(3),
			Run_Definition_Type VARCHAR(3),
			Run_Type CHAR(1),
			Schedule_Log_Date DATE,
			Schedule_Log_Time DATETIME ,
			Timeline_ID INT,
			Title_Code INT,
			Content_Channel_Run_Code INT	
		)
		CREATE TABLE #UnMapped_Titles
		(
			BMS_Asset_Ref_Key INT,
			BMS_Schedule_Process_Data_Temp_Code INT,
			Timeline_ID INT
		)
		CREATE TABLE #Revert_Titles 
		(
			Timeline_ID INT
		)
		CREATE TABLE #Process_Titles
		(
			BMS_Asset_Ref_Key INT,
			Timeline_ID INT,
			Title_Code INT
		)
		CREATE TABLE #BMS_Schedule_Runs
		(
			Acq_Deal_Run_Code INT,
			Channel_Code INT,
			Is_Prime CHAR(1),
			Schedule_Log_date DATE,
			TimeLine_ID INT
		)
	END
	/*********************************Declare global variables */
	DECLARE @Is_Error CHAR(1) = 'N' ,@Error_Desc VARCHAR(MAX) = '',@Email_Notification_Msg_Code INT = 0, @BMS_Schedule_Log_Code_CV INT = 0, @Channel_Code_CV INT,
	@Order_For_schedule_CV INT = 0, @BMS_Process_UDT BMS_Process_UDT, @Date_Time DATETIME 	
	
	DECLARE CR_BMS_Schedule_Process_Data_Temp CURSOR FOR 
		SELECT DISTINCT BSPDT.Channel_Code, C.Order_For_schedule FROM BMS_Schedule_Process_Data_Temp BSPDT
		INNER JOIN Channel C ON C.Channel_Code = BSPDT.Channel_Code
		WHERE ISNULL(Record_Status,'P') = 'P' ORDER BY C.Order_For_schedule 
	OPEN CR_BMS_Schedule_Process_Data_Temp
	FETCH NEXT FROM CR_BMS_Schedule_Process_Data_Temp INTO 
	@Channel_Code_CV, @Order_For_schedule_CV
	WHILE @@FETCH_STATUS<>-1
	BEGIN
		IF(@@FETCH_STATUS<>-2)
		BEGIN
			BEGIN TRY
				BEGIN TRAN
				PRINT '-------------In Cursor CR_BMS_Schedule_Process_Data_Temp and Channel Code  is : - ' + CAST(@Channel_Code_CV AS VARCHAR(10))
				/******************TRUNCATE Tables */
				TRUNCATE TABLE #BMS_Schedule_Process_Data_Temp
				TRUNCATE TABLE #UnMapped_Titles
				TRUNCATE TABLE #Revert_Titles
				TRUNCATE TABLE #Process_Titles
				TRUNCATE TABLE #BMS_Schedule_Runs
				/************************Update Record Status Waiting BMS_Schedule_Process_Data_Temp  *************************/

				-- BV Send Log Date As a BroadCast Date and DateTime send as Calender Date ,As discused with Pratheh Sir We Should Consider Calender Date
				--So We Update LogDate

				UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'W',Log_Date = CASE WHEN  ISNULL(Date_Time,'') <> '' THEN  CAST(Date_Time AS DATE)  ELSE  Log_Date END
				WHERE Channel_Code  = @Channel_Code_CV AND ISNULL(Record_Status,'P') = 'P'

				/************************Update into BMS_Schedule_Process_Data_Temp  *************************/

				UPDATE BSPDT SET BSPDT.Title_Code = BA.RU_Title_Code
				FROM BMS_Schedule_Process_Data_Temp BSPDT
				INNER JOIN BMS_Asset BA ON BSPDT.BMS_Asset_Ref_Key = ISNULL(BA.BMS_Asset_Ref_Key,0)
				WHERE BSPDT.Channel_Code = @Channel_Code_CV AND BSPDT.Record_Status = 'W' AND ISNULL(BSPDT.BMS_Asset_Ref_Key,0) > 0

				UPDATE BSPDT SET BSPDT.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code
				FROM BMS_Schedule_Process_Data_Temp BSPDT
				INNER JOIN BMS_Asset BA ON BSPDT.BMS_Asset_Ref_Key = ISNULL(BA.BMS_Asset_Ref_Key,0)
				INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BSPDT.BMS_Asset_Ref_Key
				INNER JOIN Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code AND ISNULL(CCR.Is_Archive, 'N') = 'N'
				AND CCR.Channel_Code = @Channel_Code_CV AND (CAST(CAST(BSPDT.Date_Time AS DATETIME2) AS DATETIME) BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date)
				WHERE BSPDT.Channel_Code = @Channel_Code_CV AND BSPDT.Record_Status = 'W' AND ISNULL(BSPDT.BMS_Asset_Ref_Key,0) > 0

				
				

				--UPDATE BSPDT3 SET BSPDT3.Date_Time=
				--(SELECT BT.Date_Time FROm BMS_Schedule_Process_Data_Temp BT WHERE
				--BT.BMS_Schedule_Log_Code=BSPDT2.BMS_Schedule_Log_Code AND BT.Timeline_ID=BSPDT2.Timeline_ID)
				--FROM BMS_Schedule_Process_Data_Temp AS BSPDT3
				--INNER JOIN 
				--(
				--	select Timeline_ID,MAX(BSPDT1.BMS_Schedule_Log_Code) AS BMS_Schedule_Log_Code from BMS_Schedule_Process_Data_Temp BSPDT1
				--	where BSPDT1.Timeline_ID IN(
				--	select Timeline_ID from BMS_Schedule_Process_Data_Temp BSPDT where BSPDT.Channel_Code=@Channel_Code_CV 
				--	AND BSPDT.BMS_Schedule_Log_Code = @BMS_Schedule_Log_Code_CV 
				--	)
				--	AND BSPDT1.Record_Status = 'D'
				--	GROUP BY  BSPDT1.Timeline_ID
				--)
				--AS BSPDT2
				--ON BSPDT2.Timeline_ID= BSPDT3.Timeline_ID
				--WHERE BSPDT3.Record_Status = 'W' AND (BSPDT3.Date_Time IS NULL OR BSPDT3.Date_Time = '')

				
				-- TEST and Implement - Adesh
				UPDATE t1 SET t1.Date_Time=
				(
					Select Top 1 Date_Time From BMS_Schedule_Process_Data_Temp t2 Where t2.Timeline_ID = t1.Timeline_ID And t2.Record_Status <> 'W' 
					AND t2.Date_Time IS Not NULL 
					Order By BMS_Schedule_Process_Data_Temp_Code Desc
				)
				FROM BMS_Schedule_Process_Data_Temp AS t1
				WHERE t1.Record_Status = 'W' AND t1.Date_Time IS NULL 
				-- TEST and Implement - Adesh
				
				/***************************In Case of Revert/Delete Schedule Update We need to update Asset id ,Run Code and Deal Code ************/
				UPDATE BSPDT SET BSPDT.Title_Code = BSPD.Title_Code,BSPDT.BMS_Asset_Ref_Key = BSPD.BMS_Asset_Ref_Key
				,BSPDT.Content_Channel_Run_Code = BSPD.Content_Channel_Run_Code
				,BSPDT.Acq_Deal_Code= BSPD.Acq_Deal_Code
				FROM BMS_Schedule_Process_Data_Temp BSPDT
				INNER JOIN BMS_Schedule_Process_Data_Temp BSPD ON BSPD.Timeline_ID = BSPDT.Timeline_ID 
				AND (ISNULL(BSPDT.BMS_Asset_Ref_Key,0) <> ISNULL(BSPD.BMS_Asset_Ref_Key,0))
				AND 
				(
					ISNULL(BSPD.BMS_Asset_Ref_Key,0) > 0 OR  
					((ISNULL(BSPDT.BMS_Asset_Ref_Key,0) = 0) AND BSPDT.Delete_Flag = 'true' 
					AND BSPDT.Channel_Code = @Channel_Code_CV
					)
				)
				Where BSPD.BMS_Schedule_Process_Data_Temp_Code In (
					Select Max(BMS_Schedule_Process_Data_Temp_Code) From BMS_Schedule_Process_Data_Temp t2 Where t2.Timeline_ID = BSPDT.Timeline_ID 
					And t2.Record_Status <> 'W' AND t2.Date_Time IS Not NULL
				)
				------ Check and implement - Adesh

				UPDATE BSPDT SET BSPDT.Content_Channel_Run_Code = 
				( SELECT TOP 1 CCR.Content_Channel_Run_Code FROM Content_Channel_Run CCR WHERE CCR.Title_Content_Code = TC.Title_Content_Code 
				AND ISNULL(CCR.Is_Archive, 'N') = 'N' AND CCR.Channel_Code = @Channel_Code_CV )
				FROM BMS_Schedule_Process_Data_Temp BSPDT
				INNER JOIN BMS_Asset BA ON BSPDT.BMS_Asset_Ref_Key = ISNULL(BA.BMS_Asset_Ref_Key,0)
				INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BSPDT.BMS_Asset_Ref_Key
				WHERE BSPDT.Channel_Code = @Channel_Code_CV AND BSPDT.Record_Status = 'W' AND ISNULL(BSPDT.BMS_Asset_Ref_Key,0) > 0
				AND BSPDT.Content_Channel_Run_Code IS NULL

				/************************* Insert into #UnMapped_Titles***************************/				
				INSERT INTO  #UnMapped_Titles(BMS_Asset_Ref_Key, BMS_Schedule_Process_Data_Temp_Code, Timeline_ID)
				SELECT DISTINCT TBSPD.BMS_Asset_Ref_Key, TBSPD.BMS_Schedule_Process_Data_Temp_Code, TBSPD.Timeline_ID FROM BMS_Schedule_Process_Data_Temp TBSPD 
				WHERE ISNULL(TBSPD.Title_Code,0) = 0  AND Record_Status = 'W' AND ISNULL(BMS_Asset_Ref_Key,0) > 0
				AND TBSPD.Channel_Code = @Channel_Code_CV
				
				Delete From #UnMapped_Titles where Timeline_ID NOT IN 
				(
					select Timeline_ID from 
					(
						select BMS_Asset_Ref_Key, BMS_Schedule_Process_Data_Temp_Code, Timeline_ID, 
						row_number() over (partition by BMS_Asset_Ref_Key order by Timeline_ID desc ) rn from #UnMapped_Titles
					) AS a where a.rn = 1
				)

				-- check and confirm - Adesh

				INSERT INTO BV_HouseId_Data(
					BMS_Schedule_Process_Data_Temp_Code, InsertedOn,Is_Mapped, IsProcessed,Program_Episode_ID,
					[Type]
				)
				SELECT DISTINCT UT.BMS_Schedule_Process_Data_Temp_Code, GETDATE() AS InsertedOn, 'N' AS Is_Mapped, 'N' AS IsProcessed, UT.BMS_Asset_Ref_Key,
				 'S' AS Record_Type
				FROM #UnMapped_Titles UT WHERE ISNULL(UT.BMS_Asset_Ref_Key,0) NOT IN
				(
					SELECT BH.Program_Episode_ID FROM BV_HouseId_Data BH WHERE ISNULL(BH.Program_Episode_ID,0)  > 0
				)
				
				/*******************Insert into Exception Table (Asset id null or Empty)************/			
				IF EXISTS (SELECT TOP 1 TBSPD.BMS_Schedule_Process_Data_Temp_Code FROM BMS_Schedule_Process_Data_Temp TBSPD WHERE TBSPD.Record_Status = 'W' 
					AND ISNULL(TBSPD.BMS_Asset_Ref_Key,0) = 0 AND ISNULL(TBSPD.Delete_Flag,'false') = 'false')
				BEGIN
					PRINT '-------Threw Exception BMS_SCHEDULE_ASSET_ID_NULL---------'
					SET @Email_Notification_Msg_Code = 0					
					SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code 
					FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'BMS_SCHEDULE_ASSET_ID_NULL' AND [Type] = 'S' 
					
					UPDATE BSE SET BSE.IsMailSent='N', BSE.Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,0) FROM BMS_Schedule_Exception BSE 
					INNER JOIN BMS_Schedule_Process_Data_Temp BSPDT ON BSPDT.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
					AND BSE.Email_Notification_Msg_Code != ISNULL(@Email_Notification_Msg_Code,0) AND @Is_Reprocess = 'Y'

					INSERT INTO BMS_Schedule_Exception
					(
						BMS_Schedule_Process_Data_Temp_Code, Email_Notification_Msg_Code, IsMailSent
					)
					SELECT DISTINCT TBSPD.BMS_Schedule_Process_Data_Temp_Code, ISNULL(@Email_Notification_Msg_Code,0), 'N'
					FROM BMS_Schedule_Process_Data_Temp TBSPD 
					LEFT JOIN BMS_Schedule_Exception BSE ON TBSPD.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
					WHERE Record_Status = 'W' AND ISNULL(BMS_Asset_Ref_Key,0) = 0 
					AND ISNULL(TBSPD.Delete_Flag,'false') = 'false' AND BSE.BMS_Schedule_Process_Data_Temp_Code IS NULL
					
				END
				/*******************Insert into Exception Table (Asset id or Deal not Found)*********/
				IF EXISTS(SELECT TOP 1 BMS_Asset_Ref_Key FROM #UnMapped_Titles WHERE ISNULL(BMS_Asset_Ref_Key,0) > 0)
				BEGIN
					PRINT '---------Threw Exception PROGRAM_ASSET--------'
					SET @Email_Notification_Msg_Code = 0
					SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code 
					FROM Email_Notification_Msg WHERE UPPER(Email_Msg_For) = 'PROGRAM_ASSET' AND [Type] = 'S'

					UPDATE BSE SET BSE.IsMailSent='N', BSE.Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,0) FROM BMS_Schedule_Exception BSE 
					INNER JOIN BMS_Schedule_Process_Data_Temp BSPDT ON BSPDT.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
					AND BSE.Email_Notification_Msg_Code != ISNULL(@Email_Notification_Msg_Code,0) AND @Is_Reprocess = 'Y'

					INSERT INTO BMS_Schedule_Exception
					(
						BMS_Schedule_Process_Data_Temp_Code, Email_Notification_Msg_Code, IsMailSent
					)
					SELECT DISTINCT UT.BMS_Schedule_Process_Data_Temp_Code, ISNULL(@Email_Notification_Msg_Code,0), 'N'
					FROM #UnMapped_Titles UT
					LEFT JOIN BMS_Schedule_Exception BSE ON UT.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
					WHERE BSE.BMS_Schedule_Process_Data_Temp_Code IS NULL
				END				
				/*********************************Step 2 Check BMS Asset id exist or not (BMS_Asset Table)*/
				
				IF OBJECT_ID('tempdb..#TEMP_BV_Schedule') IS NOT NULL
				BEGIN
					DROP TABLE #TEMP_BV_Schedule
				END
				SELECT DISTINCT Timeline_ID INTO #TEMP_BV_Schedule FROM BMS_Schedule_Process_Data_Temp 
				WHERE Channel_Code  = @Channel_Code_CV AND ISNULL(Record_Status,'P') = 'P'

				UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'W'
				WHERE Channel_Code  = @Channel_Code_CV AND ISNULL(Record_Status,'P') = 'P'

				Update FinalUpdate SET FinalUpdate.Record_Status='W'  FROM BMS_Schedule_Process_Data_Temp AS FinalUpdate INNER JOIN 
				(
				SELECT BSPDT.Timeline_ID,MAX(BSPDT.BMS_Schedule_Process_Data_Temp_Code) BMS_Schedule_Process_Data_Temp_Code from BMS_Schedule_Process_Data_Temp BSPDT 
				INNER JOIN 		
				(select DISTINCT T.BMS_Asset_Ref_Key, ISNULL( (select MAX(CAST(A.Schedule_Item_Log_Time AS DATETIME)) From BV_Schedule_Transaction A 
				where A.Program_Episode_ID = T.BMS_Asset_Ref_Key AND A.Channel_Code = @Channel_Code_CV AND (ISNULL(A.IsIgnore,'') = 'N'  OR (A.Play_Day = 0 ANd A.Play_Run = 0))
				AND CAST(A.Schedule_Item_Log_Time AS DATETIME) < X.Date_Time 
				AND A.Timeline_ID NOT IN (select Timeline_ID from BMS_Schedule_Process_Data_Temp WHERE Record_Status='W')
				),X.Date_Time ) AS  Schedule_Item_Log_Time from BMS_Schedule_Process_Data_Temp T INNER JOIN

				(select BMS_Asset_Ref_Key, Min(CAST(CAST(Date_Time AS DATETIME2) AS DATETIME)) AS Date_Time from BMS_Schedule_Process_Data_Temp 
				where ISNULL(Record_Status,'')='W' AND Channel_Code  = @Channel_Code_CV
				Group By BMS_Asset_Ref_Key) AS X
					ON T.BMS_Asset_Ref_Key = X.BMS_Asset_Ref_Key AND X.Date_Time = CAST(CAST(T.Date_Time AS DATETIME2) AS DATETIME)
					) AS Y
				ON BSPDT.BMS_Asset_Ref_Key = Y.BMS_Asset_Ref_Key AND BSPDT.Channel_Code = @Channel_Code_CV 
				AND CAST(CAST(BSPDT.Date_Time AS DATETIME2) AS DATETIME) >= Y.Schedule_Item_Log_Time
				INNER JOIN BV_Schedule_Transaction BV 
				ON BV.Program_Episode_ID = Y.BMS_Asset_Ref_Key AND BV.Timeline_ID = BSPDT.Timeline_ID AND 
				CAST(BV.Schedule_Item_Log_Time AS DATETIME) = CAST(CAST(BSPDT.Date_Time AS DATETIME2) AS DATETIME)
				AND BSPDT.Timeline_ID NOT IN(select Timeline_ID from BMS_Schedule_Process_Data_Temp WHERE Record_Status='W')
				AND BV.Channel_Code = @Channel_Code_CV 
				GROUP by BSPDT.Timeline_ID) AS Final
				ON Final.BMS_Schedule_Process_Data_Temp_Code = FinalUpdate.BMS_Schedule_Process_Data_Temp_Code

				/*(2) Insert All Pending Records Into #BMS_Schedule_Process_Data_Temp */
				INSERT INTO #BMS_Schedule_Process_Data_Temp
				(
					BMS_Schedule_Process_Data_Temp_Code,
					BMS_Asset_Ref_Key, BMS_Schedule_Log_Code, 
					Channel_Code, 
					Delete_Flag,
					Is_In_Right_Perod, 
					No_Of_Runs, No_Of_Runs_Sched, Right_Start_Date, Right_End_Date, 
					Run_Type, Schedule_Log_Date, 
					Schedule_Log_Time, Timeline_ID, Title_Code, 
					Content_Channel_Run_Code
				)
				SELECT DISTINCT TBSPD.BMS_Schedule_Process_Data_Temp_Code, TBSPD.BMS_Asset_Ref_Key, TBSPD.BMS_Schedule_Log_Code, 
					VWB.Channel_Code, ISNULL(TBSPD.Delete_Flag,'false') AS Delete_Flag,
					CASE WHEN (CONVERT(DATETIME,TBSPD.Log_Date,101) BETWEEN CONVERT(DATETIME,VWB.Rights_Start_Date,101)  
					AND CONVERT(DATETIME,ISNULL(VWB.Rights_End_Date,'31DEC9999'),101))
					THEN 'Y' ELSE 'N' END Is_In_Right_Perod,
					VWB.Defined_Runs, VWB.Schedule_Runs, VWB.Rights_Start_Date, VWB.Rights_End_Date,
					ISNULL(VWB.Run_Type,'C'), CAST(TBSPD.Log_Date AS DATE) AS Schedule_Log_Date, 
					CAST(CAST(TBSPD.Date_Time AS DATETIME2) AS DATETIME) AS Schedule_Log_Time, TBSPD.Timeline_ID, VWB.Title_Code, 
					VWB.Content_Channel_Run_Code
				FROM Content_Channel_Run VWB
				INNER JOIN BMS_Schedule_Process_Data_Temp TBSPD ON 
				VWB.Content_Channel_Run_Code = TBSPD.Content_Channel_Run_Code -- Change
				--VWB.Title_Code = TBSPD.Title_Code AND ISNULL(TBSPD.Title_Code,0) > 0
				--AND VWB.Channel_Code = @Channel_Code_CV 
				AND TBSPD.Record_Status = 'W' 
				INNER JOIN BMS_Asset BA ON
				TBSPD.BMS_Asset_Ref_Key = BA.BMS_Asset_Ref_Key
				INNER JOIN Title_Content TC
				ON VWB.Title_Content_Code= TC.Title_Content_Code AND TC.Ref_BMS_Content_Code=TBSPD.BMS_Asset_Ref_Key
				--AND ((CAST(CAST(
				--TBSPD.Date_Time 
				--AS DATETIME2) AS DATETIME) 
				--BETWEEN VWB.Rights_Start_Date AND VWB.Rights_End_Date)
				--AND VWB.Channel_Code = @Channel_Code_CV
				--)
				WHERE TBSPD.Channel_Code = @Channel_Code_CV

				DELETE FROM #Revert_Titles

				/*******************Insert into Exception Table(Deal_Not_Approve)*/

				--PRINT 'Start logic of Excption(BMS_Schedule_Exception) :- Deal_Not_Approve'

				--IF EXISTS(SELECT TOP 1 Timeline_ID FROM #BMS_Schedule_Process_Data_Temp T WHERE ISNULL(T.Deal_Workflow_Status,'') <> 'A')
				--BEGIN
				--	PRINT '---------Threw  Excpetion Deal_Not_Approve---------------'
				--	SET  @Email_Notification_Msg_Code = 0
				--	SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code
				--	FROM Email_Notification_Msg WHERE  UPPER(Email_Msg_For) = 'Deal_Not_Approve' AND [Type] = 'S'

				--	UPDATE BSE SET BSE.IsMailSent='N', BSE.Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,0) FROM BMS_Schedule_Exception BSE 
				--	INNER JOIN BMS_Schedule_Process_Data_Temp BSPDT ON BSPDT.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
				--	AND BSE.Email_Notification_Msg_Code != ISNULL(@Email_Notification_Msg_Code,0) AND @Is_Reprocess = 'Y'

				--	INSERT INTO BMS_Schedule_Exception(BMS_Schedule_Process_Data_Temp_Code, Email_Notification_Msg_Code, IsMailSent)
				--	SELECT TBSPD.BMS_Schedule_Process_Data_Temp_Code,ISNULL(@Email_Notification_Msg_Code,0), 'N'
				--	FROM #BMS_Schedule_Process_Data_Temp TBSPD  
				--	LEFT JOIN BMS_Schedule_Exception BSE ON TBSPD.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
				--	WHERE BSE.BMS_Schedule_Process_Data_Temp_Code IS NULL
				--	AND ISNULL(TBSPD.Deal_Workflow_Status,'') <> 'A'		
						
				--	UPDATE BSPDT SET BSPDT.Is_Deal_Approved = 'N',BSPDT.Content_Channel_Run_Code = temp.Content_Channel_Run_Code
				--	FROM BMS_Schedule_Process_Data_Temp BSPDT
				--	INNER JOIN #BMS_Schedule_Process_Data_Temp temp ON BSPDT.BMS_Schedule_Process_Data_Temp_Code = temp.BMS_Schedule_Process_Data_Temp_Code
				--END
				/*******************Insert into Exception Table(Invalid_Channel)*/

				PRINT 'Start logic of Excption(BMS_Schedule_Exception) :- Invalid_Channel'

				IF NOT EXISTS(SELECT * FROM #BMS_Schedule_Process_Data_Temp T)
				BEGIN
					PRINT '-----------Threw  Excpetion Invalid_Channel-------------'
					SET  @Email_Notification_Msg_Code = 0
					SELECT TOP 1 @Email_Notification_Msg_Code = Email_Notification_Msg_Code
					FROM Email_Notification_Msg WHERE  UPPER(Email_Msg_For) = 'Invalid_Channel' AND [Type] = 'S'
					
					UPDATE BSE SET BSE.IsMailSent='N', BSE.Email_Notification_Msg_Code = ISNULL(@Email_Notification_Msg_Code,0) FROM BMS_Schedule_Exception BSE 
					INNER JOIN BMS_Schedule_Process_Data_Temp BSPDT ON BSPDT.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
					AND BSE.Email_Notification_Msg_Code != ISNULL(@Email_Notification_Msg_Code,0) AND @Is_Reprocess = 'Y'

					INSERT INTO BMS_Schedule_Exception
					(
						BMS_Schedule_Process_Data_Temp_Code,Email_Notification_Msg_Code, IsMailSent
					)
					SELECT T.BMS_Schedule_Process_Data_Temp_Code,@Email_Notification_Msg_Code,'N'
					FROM BMS_Schedule_Process_Data_Temp T
					LEFT JOIN BMS_Schedule_Exception BSE ON T.BMS_Schedule_Process_Data_Temp_Code = BSE.BMS_Schedule_Process_Data_Temp_Code
					WHERE Channel_Code = @Channel_Code_CV 
					AND Record_Status = 'W'
					AND ISNULL(Title_Code,0) > 0 AND ISNULL(BMS_Asset_Ref_Key,0) > 0
					AND ISNULL(Delete_Flag,'false') = 'false' AND BSE.BMS_Schedule_Process_Data_Temp_Code IS NULL
				END

				IF(ISNULL(@Email_Notification_Msg_Code,0) > 0)
				BEGIN
					UPDATE BMS_Schedule_Process_Data_Temp SET Is_Error = 'E',Record_Status = 'E'
					WHERE Record_Status = 'W' AND BMS_Schedule_Process_Data_Temp_Code IN(
						SELECT BMS_Schedule_Process_Data_Temp_Code FROM BMS_Schedule_Exception BSE WHERE ISNULL(BSE.BMS_Schedule_Process_Data_Temp_Code,0) > 0
					)
					PRINT 'Updated Is Exception Flag Yes in BMS_Schedule_Process_Data_Temp'
					-------------------Insert Error------------------------------------------------------------------------
					DECLARE @Count INT
					Select @Count = COUNT(*) from BMS_Schedule_Process_Data_Temp Where Record_Status = 'E'
					INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
					Select DISTINCT GETDATE(),null,null,'USP_BMS_Schedule', CAST(@Count AS VARCHAR)+' '+'Record''s are in error state for Channel'+' '+ C.Channel_Name,'NA','NA','DB' from BMS_Schedule_Process_Data_Temp BSPDT 
					INNER JOIN Channel C ON BSPDT.Channel_Code = C.Channel_Code 
					PRINT 'INSERT Record In UTO_Exception '
				END	
				/*******************************Step 3 : - We need to validate timeline id or Deleted Flag *****************************/
				/************(3.1)- if timeline id exist in BMS_Process_Schedule_Data(table) or Deleted Flag is true in BMS_Process_Schedule_Data_Temp(table) then Call USP_Revert_Count*/
				/************************* Insert into #Revert_Titles***************************/				
				INSERT INTO #Revert_Titles(Timeline_ID)
				SELECT DISTINCT TBSPD.Timeline_ID
				FROM #BMS_Schedule_Process_Data_Temp TBSPD 
				WHERE (TBSPD.Delete_Flag = 'true' OR  TBSPD.Timeline_ID IN
				(
					SELECT BST.Timeline_ID FROM BV_Schedule_Transaction BST WHERE BST.Channel_Code = @Channel_Code_CV
				)) AND TBSPD.Channel_Code = @Channel_Code_CV

				PRINT 'Data Inserted into #Revert_Titles'
				/*******************Call USP_Revert*/		
				DECLARE @TimeLine_ID_Revert VARCHAR(MAX) = ''
				SELECT  @TimeLine_ID_Revert = STUFF((SELECT DISTINCT  ',' +  CAST(ISNULL(RT.Timeline_ID,0) AS VARCHAR)
				FROM #Revert_Titles RT WHERE ISNULL(RT.Timeline_ID,0) > 0
				FOR XML PATH('')), 1, 1, '')					
					
				IF EXISTS(SELECT TOP 1 RT.Timeline_ID FROM #Revert_Titles RT)
				BEGIN
					EXEC USP_BMS_Schedule_Revert @Channel_Code_CV,@TimeLine_ID_Revert 	
				END
									
				/***********(3.2)if timeline id not exist or Deleted Flag is false then Call USP_Schedule_Process  *******/
				
				/************************* Insert into #Process_Titles & BMS_Process_UDT***************************/				
				INSERT INTO #Process_Titles(BMS_Asset_Ref_Key, Timeline_ID, Title_Code)
				SELECT DISTINCT TBSPD.BMS_Asset_Ref_Key, TBSPD.Timeline_ID, TBSPD.Title_Code
				FROM #BMS_Schedule_Process_Data_Temp TBSPD
				WHERE ISNULL(TBSPD.Delete_Flag,'false') = 'false'

				INSERT INTO #Process_Titles(BMS_Asset_Ref_Key, Timeline_ID, Title_Code)
				SELECT DISTINCT TBSPD.BMS_Asset_Ref_Key, TBSPD.Timeline_ID, TBSPD.Title_Code
				FROM #BMS_Schedule_Process_Data_Temp TBSPD
				WHERE ISNULL(TBSPD.Delete_Flag,'false') = 'false'

				PRINT 'Data Inserted into #Process_Titles' 			 	
				DELETE FROM @BMS_Process_UDT						 
						
				/******************Insert into @BMS_Process_UDT*/
						 
				INSERT INTO @BMS_Process_UDT
				(
					Acq_Deal_Code, Acq_Deal_Rights_Code, Acq_Deal_Run_Code, Agreement_Date, BMS_Asset_Ref_Key, 
					BMS_Schedule_Log_Code, Channel_Code, Delete_Flag, Is_In_BlackOut_Period, Is_In_Right_Perod, No_Of_Runs, 
					No_Of_Runs_Sched, Right_Start_Date,Right_End_Date, Right_Type,Run_Type, Schedule_Log_Date, 
					Schedule_Log_Time, Timeline_ID, Title_Code, Content_Channel_Run_Code					 
				)
				SELECT DISTINCT TBSPD.Acq_Deal_Code, TBSPD.Acq_Deal_Rights_Code, TBSPD.Acq_Deal_Run_Code, TBSPD.Agreement_Date, TBSPD.BMS_Asset_Ref_Key, 
				TBSPD.BMS_Schedule_Log_Code, TBSPD.Channel_Code, TBSPD.Delete_Flag ,TBSPD.Is_In_BlackOut_Period, TBSPD.Is_In_Right_Perod, TBSPD.No_Of_Runs, 
				TBSPD.No_Of_Runs_Sched, TBSPD.Right_Start_Date, ISNULL(TBSPD.Right_End_Date,'31DEC9999'), TBSPD.Right_Type, TBSPD.Run_Type, Schedule_Log_Date, 
				Schedule_Log_Time, TBSPD.Timeline_ID, TBSPD.Title_Code, Content_Channel_Run_Code
				FROM #BMS_Schedule_Process_Data_Temp TBSPD 
				WHERE TBSPD.Timeline_ID IN(
					SELECT PT.Timeline_ID FROM #Process_Titles PT
				)

				PRINT  'Inserted into @BMS_Process_UDT'
				/*******************Call USP_BMS_Schedule_Process*/						 						
				IF EXISTS(SELECT TOP 1 BSPRU.Timeline_ID FROM @BMS_Process_UDT BSPRU)
					EXEC USP_BMS_Schedule_Process  @BMS_Process_UDT,@Is_Reprocess	

				/*******************Update Record Status in  BMS_Schedule_Process_Data_Temp **********************/									
				PRINT 'Update Record Status BMS_Schedule_Process_Data_Temp'
				
					UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'D'
					WHERE Channel_Code  = @Channel_Code_CV AND Record_Status = 'W'
				/**************/
				COMMIT
			END TRY			
			BEGIN CATCH				
				ROLLBACK				
				SET @Is_Error   = 'Y'       	
				SET @Error_Desc = 'Error In USP_BMS_Schedule : Error_Desc : ' +  ERROR_MESSAGE() + ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)  + ' ;ERROR_Line: '  
									+ CAST(ERROR_Line() AS VARCHAR)
							
				PRINT 'In Catch block USP_BMS_Schedule'				
	
				SELECT TOP 1 @Email_Notification_Msg_Code = ISNULL(Email_Notification_Msg_Code,0) 
				FROM Email_Notification_Msg WHERE  UPPER(Email_Msg_For) = 'BMS_SCHEDULE_USP_FAIL' AND [Type] = 'S'

				INSERT INTO BMS_Schedule_Exception
				(
					BMS_Schedule_Process_Data_Temp_Code,Email_Notification_Msg_Code
				)
				SELECT DISTINCT BSPDT.BMS_Schedule_Process_Data_Temp_Code,ISNULL(@Email_Notification_Msg_Code,0)
				FROM BMS_Schedule_Process_Data_Temp BSPDT WHERE ISNULL(BSPDT.Record_Status,'N') = 'W'
	
				/*******************Update Record Status in  BMS_Schedule_Process_Data_Temp **********************/
				UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'E',Is_Error = 'E'--,Error_Description = @Error_Desc
				WHERE Channel_Code  = @Channel_Code_CV AND Record_Status = 'W'

				PRINT @Error_Desc					
					
			END CATCH		
		END  --   --End if While Loop(CR_BMS_Schedule_Process_Data_Temp)                                          
		FETCH NEXT FROM CR_BMS_Schedule_Process_Data_Temp INTO @Channel_Code_CV,@Order_For_schedule_CV--,@Date_Time
	END -- -- While End(CR_BMS_Schedule_Process_Data_Temp)  
		                                        
	CLOSE CR_BMS_Schedule_Process_Data_Temp
	DEALLOCATE CR_BMS_Schedule_Process_Data_Temp

	IF OBJECT_ID('tempdb..#BMS_Schedule_Process_Data_Temp') IS NOT NULL DROP TABLE #BMS_Schedule_Process_Data_Temp
	IF OBJECT_ID('tempdb..#BMS_Schedule_Runs') IS NOT NULL DROP TABLE #BMS_Schedule_Runs
	IF OBJECT_ID('tempdb..#Delete_Titles') IS NOT NULL DROP TABLE #Delete_Titles
	IF OBJECT_ID('tempdb..#Process_Titles') IS NOT NULL DROP TABLE #Process_Titles
	IF OBJECT_ID('tempdb..#Revert_Titles') IS NOT NULL DROP TABLE #Revert_Titles
	IF OBJECT_ID('tempdb..#TEMP_BV_Schedule') IS NOT NULL DROP TABLE #TEMP_BV_Schedule
	IF OBJECT_ID('tempdb..#TempMinDate') IS NOT NULL DROP TABLE #TempMinDate
	IF OBJECT_ID('tempdb..#TempSchedule_Item_Log_Time') IS NOT NULL DROP TABLE #TempSchedule_Item_Log_Time
	IF OBJECT_ID('tempdb..#UnMapped_Titles') IS NOT NULL DROP TABLE #UnMapped_Titles
		
END
/*                                        
CLOSE CR_BMS_Schedule_Process_Data_Temp
DEALLOCATE CR_BMS_Schedule_Process_Data_Temp
EXEC USP_BMS_Schedule
CLOSE CR_RR_Validation
DEALLOCATE CR_RR_Validation
exec USP_BMS_Schedule_Channel_For_PUSH
*/