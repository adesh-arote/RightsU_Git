
CREATE PROC [dbo].[USP_Music_Schedule_Process_Neo]
(
	@MusicScheduleProcess MusicScheduleProcess READONLY,
	@CallFrom VARCHAR(10) = ''
)
AS
/*=======================================================================================================================================
Author:			ADESH AROTE
Create date:	03 MAY 2020
Description:	Music Schedule Process and Email Exception
Value for @CallFrom :
	'AM'	= Called from Assign Music Page
	'SR'	= Called from USP_Schedule_Revert_Count
	'AR'	= Called from USP_Music_Schedule_Exception_AutoResolver
	'SP'	= Called from USP_Schedule_Process
=======================================================================================================================================*/
BEGIN
	SET NOCOUNT ON
	--DECLARE @MusicScheduleProcess MusicScheduleProcess, @CallFrom VARCHAR(10) = 'SP'
	
	--@TitleCode BIGINT = 27521,
	--@EpisodeNo INT = 70, 
	--@BV_Schedule_Transaction_Code BIGINT = 3275689, 
	--@MusicScheduleTransactionCode BIGINT = 5409103,
	--
	--INSERT INTO @MusicScheduleProcess(BV_Schedule_Transaction_Code)
	--SELECT DISTINCT BV_Schedule_Transaction_Code
	--FROM Title_Content tc
	--INNER JOIN (
	--	SELECT DISTINCT LTRIM(RTRIM([Title_Content_Code])) AS [Title_Content_Code] FROM DM_Content_Music WHERE DM_Master_Import_Code = 2603 AND Is_Ignore = 'N'
	--) AS dm ON tc.Title_Content_Code = dm.Title_Content_Code
	--INNER JOIN Content_Music_Link cml ON cml.Title_Content_Code = tc.Title_Content_Code
	--INNER JOIN BV_Schedule_Transaction bst ON tc.Ref_BMS_Content_Code = bst.Program_Episode_ID


	DECLARE @stepNo INT = 1;
	PRINT 'Music Schedule Process Started - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		
	IF(OBJECT_ID('TEMPDB..#TempScheduleData') IS NOT NULL) DROP TABLE #TempScheduleData
	IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransaction') IS NOT NULL) DROP TABLE #TempMusicScheduleTransaction
	IF(OBJECT_ID('TEMPDB..#AllMusicLabelDealData') IS NOT NULL) DROP TABLE #AllMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#CurrentMusicLabelDealData') IS NOT NULL) DROP TABLE #CurrentMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#ExistingException') IS NOT NULL) DROP TABLE #ExistingException
	IF(OBJECT_ID('TEMPDB..#tmpMDC') IS NOT NULL) DROP TABLE #tmpMDC

	CREATE TABLE #TempMusicScheduleTransaction
	(
		IntCode							INT IDENTITY(1,1),
		Title_Code						INT,
		Episode_No						INT,
		MusicScheduleTransactionCode	BIGINT, 
		BV_Schedule_Transaction_Code	BIGINT, 
		Schedule_Date					DATETIME, 
		Schedule_Item_Log_Time			VARCHAR(50), 
		Content_Music_Link_Code			BIGINT, 
		Music_Title_Code					BIGINT, 
		Channel_Code					BIGINT, 
		Music_Label_Code				BIGINT, 
		Is_Processed					CHAR(1) DEFAULT('N'),
			   
		Music_Deal_Code					INT, 
		lastMDCode						INT, 
		ErrorCode						INT, 
		isValid							CHAR(1) DEFAULT('Y'),
		isError							CHAR(1) DEFAULT('N'),
		AutoResolvedErrCodes			VARCHAR(MAX), 
		NewRaisedErrCodes				VARCHAR(MAX), 
		ShowLinked						CHAR(1) DEFAULT('Y'), 
		isApprovedDeal					CHAR(1) DEFAULT('Y'),

		RightRuleCode					INT,
		NoOfSongs						INT,
		isIgnore						CHAR(1) DEFAULT('N'),
		RunType							CHAR(1),
		ChannelType						CHAR(1),
		MinDateTime						DATETIME,
		MaxDateTime						DATETIME,
		CountSchedule					INT
	)

	--SELECT @RightRuleCode = 0, @NoOfSongs = 0,  @IsIgnore = 'N', @RunType = '', @ChannelType = ''

	CREATE TABLE #CurrentMusicLabelDealData
	(
		Music_Deal_Code			INT,
		Music_Label_Code		INT,
		Agreement_No			VARCHAR(50),
		Deal_Workflow_Status	VARCHAR(5),
		Deal_Version			INT,
		Rights_Start_Date		DATETIME,
		Rights_End_Date			DATETIME,
		Run_Type				CHAR(4),
		Right_Rule_Code			INT,
		Channel_Type			CHAR(1),
		Channel_Code			INT,
		No_Of_Songs				INT,
		Defined_Runs			INT,
		Scheduled_Runs			INT,
		Show_Linked				VARCHAR(1),
		Title_Code				INT,
		DealCreatedOn			DATETIME,
		Show_Linked_No			INT,
		Is_Active_Deal			VARCHAR(1)
	)

	CREATE TABLE #ExistingException
	(
		MusicScheduleTransactionCode	INT,
		Error_Code						INT,
		Error_Key						VARCHAR(10)
	)
	
	CREATE TABLE #TempScheduleData
	(
		BV_Schedule_Transaction_Code INT,
		Title_Code INT,
		Episode_No INT,
		Schedule_Date DATETIME,
		Schedule_Item_Log_Time VARCHAR(50),
		Channel_Code INT,
		Valid_Flag VARCHAR(3)
	)

	DECLARE @DefaultVersionCode INT = 1, @Users_Code INT --,  @Email_Config_Code INT
	SELECT TOP 1 @DefaultVersionCode = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'DefaultVersionCode'
	
	PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select Title_Code and Episode_No, If Parameter @BV_Schedule_Transaction_Code has value - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
	SET @stepNo += 1
		
	/* Revert Schedule*/
	IF(@CallFrom = 'SR')
	BEGIN
	
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete data from Music_Schedule_Exception table for Revert - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		DELETE MSE FROM Music_Schedule_Transaction MST
		INNER JOIN Music_Schedule_Exception MSE ON MST.Music_Schedule_Transaction_Code = MSE.Music_Schedule_Transaction_Code
		INNER JOIN @MusicScheduleProcess msp ON MST.BV_Schedule_Transaction_Code = msp.BV_Schedule_Transaction_Code
		--AND MST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code

		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(B) : Delete data from Music_Schedule_Transaction table for Revert - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		DELETE MST FROM Music_Schedule_Transaction MST
		INNER JOIN @MusicScheduleProcess msp ON MST.BV_Schedule_Transaction_Code = msp.BV_Schedule_Transaction_Code
		
		--------------- RECALCULATE SCHEDULE RUN ON DEAL AND CHANNEL LEVEL --- Need to implement
	END
	ELSE
	BEGIN
	
		/* Get Schedule Data for Title*/
		PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Get Schedule Data for Title - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		SET @stepNo += 1

		INSERT INTO #TempScheduleData(BV_Schedule_Transaction_Code, Title_Code, Episode_No, Schedule_Date,
									  Schedule_Item_Log_Time, Channel_Code, Valid_Flag)
		SELECT BST.BV_Schedule_Transaction_Code, TC.Title_Code, TC.Episode_No, CONVERT(DATETIME, BST.Schedule_Item_Log_Date, 121) AS Schedule_Date,
			   BST.Schedule_Item_Log_Time, BST.Channel_Code, CAST('' AS VARCHAR(3)) AS Valid_Flag
		FROM BV_Schedule_Transaction BST  WITH(NOLOCK)
		INNER JOIN Title_Content TC  WITH(NOLOCK) ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
		INNER JOIN @MusicScheduleProcess MSP ON ((TC.Title_Code = MSP.Title_Code AND TC.Episode_No = MSP.Episode_No) OR (BST.BV_Schedule_Transaction_Code = MSP.BV_Schedule_Transaction_Code))
	
	END

	IF EXISTS (SELECT TOP 1 * FROM #TempScheduleData)
	BEGIN
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Got Schedule Data - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		SET @stepNo += 1

		IF(@CallFrom = 'AR')
		BEGIN

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data from Music_Schedule_Transaction table and Insert in #TempMusicScheduleTransaction in case of Auto Resolve - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1

			INSERT INTO #TempMusicScheduleTransaction(Title_Code, Episode_No, MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT TSD.Title_Code, TSD.Episode_No, MST.Music_Schedule_Transaction_Code, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, MST.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MST.Music_Label_Code, 'N' AS Is_Processed
			FROM Music_Schedule_Transaction MST
			INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
			INNER JOIN #TempScheduleData TSD ON MST.BV_Schedule_Transaction_Code = TSD.BV_Schedule_Transaction_Code
			INNER JOIN @MusicScheduleProcess MSP ON MST.Music_Schedule_Transaction_Code = MSP.Music_Schedule_Transaction_Code 
			WHERE MSP.Music_Schedule_Transaction_Code IS NOT NULL

		END
		
		IF NOT EXISTS(SELECT TOP 1 * FROM @MusicScheduleProcess WHERE Music_Schedule_Transaction_Code IS NOT NULL)
		BEGIN
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for Music_Schedule_Transaction insertion - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
			
			INSERT INTO #TempMusicScheduleTransaction(Title_Code, Episode_No, MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT TSD.Title_Code, TSD.Episode_No, ISNULL(MST.Music_Schedule_Transaction_Code, 0) AS MusicScheduleTransactionCode, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, CML.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MTL.Music_Label_Code, 'N' AS Is_Processed
			FROM Title_Content TC
			INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
			INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code AND TCV.Version_Code = @DefaultVersionCode
			INNER JOIN #TempScheduleData TSD ON TSD.Title_Code = TC.Title_Code AND TSD.Episode_No =  TC.Episode_No
			INNER JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = CML.Music_Title_Code 
			AND TSD.Schedule_Date BETWEEN MTL.Effective_From AND ISNULL(MTL.Effective_To, TSD.Schedule_Date)
			LEFT JOIN Music_Schedule_Transaction MST ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code AND TSD.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
			
				

		END

		/*
			GET Deal Data
			AS : All Show, AF : All Fiction, AN : All Non Fiction, AE : All Event, SP : Specific
		*/
		
		DECLARE @CurrentTitleDealType INT = 0, @DealType_Fiction INT = 0, @DealType_NonFiction INT = 0, @DealType_Event INT = 22
		SELECT TOP 1 @DealType_Fiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Content'
		SELECT TOP 1 @DealType_NonFiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Format_Program'
		SELECT TOP 1 @DealType_Event = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Event'
		--SELECT TOP 1 @CurrentTitleDealType = Deal_Type_Code FROM Title T WHERE T.Title_Code = @TitleCode

		PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for #AllMusicLabelDealData - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		SET @stepNo += 1

		SELECT DISTINCT TMST.Music_Label_Code, MD.Music_Deal_Code, MD.Agreement_No, MD.Deal_Workflow_Status,
		MD.Rights_Start_Date, MD.Rights_End_Date, MD.Run_Type,
		MD.Right_Rule_Code,
		MD.Channel_Type, MDC.Channel_Code, MD.No_Of_Songs,
		CASE WHEN MD.Channel_Type = 'S' THEN MD.No_Of_Songs ELSE MDC.Defined_Runs END AS Defined_Runs,
		MDC.Scheduled_Runs,
		CASE 
			WHEN MD.Link_Show_Type = 'AS' THEN 'Y'
			WHEN MD.Link_Show_Type = 'AF' AND t.Deal_Type_Code = @DealType_Fiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AN' AND t.Deal_Type_Code = @DealType_NonFiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AE' AND t.Deal_Type_Code = @DealType_Event THEN 'Y'
			WHEN MD.Link_Show_Type = 'SP' AND MDLS.Title_Code = TMST.Title_Code  THEN 'Y'
			ELSE 'N'
		END AS Show_Linked,
		CASE 
			WHEN MD.Link_Show_Type = 'AS' THEN 3
			WHEN MD.Link_Show_Type = 'AF' AND t.Deal_Type_Code = @DealType_Fiction THEN 2
			WHEN MD.Link_Show_Type = 'AN' AND t.Deal_Type_Code = @DealType_NonFiction THEN 2
			WHEN MD.Link_Show_Type = 'AE' AND t.Deal_Type_Code = @DealType_Event THEN 2
			WHEN MD.Link_Show_Type = 'SP' AND MDLS.Title_Code = TMST.Title_Code  THEN 1
			ELSE 4
		END AS Show_Linked_No, MDLS.Title_Code, MD.Inserted_On AS DealCreatedOn, 'N' AS [Is_Active_Deal], CAST(md.Version AS INT) Deal_Version
		INTO #AllMusicLabelDealData
		FROM #TempMusicScheduleTransaction TMST
		INNER JOIN Title t ON t.Title_Code = TMST.Title_Code 
		INNER JOIN Music_Deal MD ON MD.Music_Label_Code = TMST.Music_Label_Code
		INNER JOIN Music_Deal_Channel MDC ON MDC.Music_Deal_Code = MD.Music_Deal_Code
		LEFT JOIN Music_Deal_LinkShow MDLS ON MDLS.Music_Deal_Code = MD.Music_Deal_Code 
		
		IF(@CallFrom <> 'AR')
		BEGIN
			/* Delete the Data, If data already exist, which we are going to Insert */
			PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete the data from Music_Schedule_Exception, If data already exist, which we are going to Insert - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
			
			DELETE MSE FROM Music_Schedule_Exception MSE
			INNER JOIN #TempMusicScheduleTransaction TMST ON MSE.Music_Schedule_Transaction_Code = TMST.MusicScheduleTransactionCode

			/* Insert data in Music Schedule Transaction Table */
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Insert data into Music_Schedule_Transaction - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1

			INSERT INTO Music_Schedule_Transaction(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, Is_Processed, Is_Ignore)
			SELECT BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, Is_Processed, NULL AS IsIgnore
			FROM #TempMusicScheduleTransaction
			WHERE ISNULL(MusicScheduleTransactionCode, 0) = 0
			ORDER BY CAST(Schedule_Date + ' ' + Schedule_Item_Log_Time AS DATETIME)

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : UPDATE DATA OF MUSIC_SCHEDULE_TRANSACTION - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1

			UPDATE TMST SET TMST.MusicScheduleTransactionCode = MST.Music_Schedule_Transaction_Code 
			FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
			AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code AND TMST.Channel_Code = MST.Channel_Code 
			AND ( 
				(TMST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS = MST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS AND @CallFrom <> 'AR') OR @CallFrom = 'AR'
			)
			WHERE ISNULL(MusicScheduleTransactionCode, 0) = 0

		END
		
		IF EXISTS (SELECT TOP 1 * FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N')
		BEGIN

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : UPDATE SCHEDULE DATE AND CHANNEL IN #TempMusicScheduleTransaction TABLE - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
			
			UPDATE TMST SET TMST.Schedule_Date = BST.Schedule_Date, TMST.Channel_Code = BST.Channel_Code
			FROM #TempMusicScheduleTransaction TMST
			INNER JOIN #TempScheduleData BST ON BST.BV_Schedule_Transaction_Code = TMST.BV_Schedule_Transaction_Code

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' ERROR : MUSIC LABEL NOT FOUND - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
						
			BEGIN --------------- CHECKS FOR MUSIC LABEL NOT FOUND VALIDATION

				UPDATE #TempMusicScheduleTransaction SET isError = 'Y', isValid = 'N', NewRaisedErrCodes = ',MLBLNF' WHERE ISNULL(Music_Label_Code, 0) = 0

			END

			BEGIN --------------- CHECKS FOR MUSIC DEAL NOT FOUND VALIDATION ON THE BASIS OF MUSIC LABEL

				-------- CHECK for only valid deal on the basis of schedule date

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' POPULATE TABLE #CurrentMusicLabelDealData - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				TRUNCATE TABLE #CurrentMusicLabelDealData

				INSERT INTO #CurrentMusicLabelDealData(Music_Deal_Code, Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					Run_Type, Right_Rule_Code, Channel_Type, Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, 
					DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				)
				SELECT DISTINCT amdd.Music_Deal_Code, amdd.Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					   Run_Type, Right_Rule_Code, Channel_Type, amdd.Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, amdd.Title_Code, 
					   DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				FROM #AllMusicLabelDealData amdd
				INNER JOIN #TempMusicScheduleTransaction tsmt ON amdd.Music_Label_Code = tsmt.Music_Label_Code AND (amdd.Title_Code = tsmt.Title_Code OR amdd.Show_Linked = 'Y')
				WHERE ISNULL(amdd.Music_Deal_Code, 0) > 0 -- AND ISNULL(Music_Label_Code, 0) = @MusicLabelCode AND (ISNULL(Title_Code, 0) = @TitleCode OR Show_Linked = 'Y')

				INSERT INTO #CurrentMusicLabelDealData(Music_Deal_Code, Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					Run_Type, Right_Rule_Code, Channel_Type, Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, 
					DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				)
				SELECT DISTINCT Music_Deal_Code, amdd.Music_Label_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, 
					   Run_Type, Right_Rule_Code, Channel_Type, amdd.Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, amdd.Title_Code, 
					   DealCreatedOn, Is_Active_Deal, Show_Linked_No, Deal_Version
				FROM #AllMusicLabelDealData amdd
				WHERE ISNULL(amdd.Music_Deal_Code, 0) > 0 
				AND amdd.Music_Label_Code IN (
					SELECT DISTINCT tsmt.Music_Label_Code FROM #TempMusicScheduleTransaction tsmt
				)
				AND amdd.Music_Label_Code NOT IN (
					SELECT amdd1.Music_Label_Code FROM #AllMusicLabelDealData amdd1 WHERE ISNULL(amdd1.Title_Code, 0) = ISNULL(amdd.Title_Code, 0)
				)

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATIOLN - DEAL NOT FOUND - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				UPDATE #TempMusicScheduleTransaction SET isError = 'Y', isValid = 'N', NewRaisedErrCodes = ',DNF'
				WHERE Music_Label_Code NOT IN (
					SELECT DISTINCT tsmt.Music_Label_Code FROM #AllMusicLabelDealData tsmt
				) AND isValid = 'Y'

				--UPDATE #TempMusicScheduleTransaction SET AutoResolvedErrCodes = ',MLBLNF' WHERE ISNULL(Music_Label_Code, 0) > 0

			END

			BEGIN --------------- IDENTIFY THE MUSIC DEAL

				--SELECT TOP 1 @MusicDealCode = Music_Deal_Code 
				
				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' IDENTIFY THE MUSIC DEAL - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				UPDATE tmst SET tmst.Music_Deal_Code = a.Music_Deal_Code
				FROM (
					SELECT ROW_NUMBER() OVER(PARTITION BY tmst1.IntCode, cml.Music_Label_Code, cml.Channel_Code--, Rights_Start_Date, Rights_End_Date
						ORDER BY cml.DealCreatedOn ASC, cml.Show_Linked_No ASC) AS RowNum, tmst1.IntCode, cml.Music_Deal_Code
					FROM #TempMusicScheduleTransaction tmst1
					INNER JOIN #CurrentMusicLabelDealData cml ON tmst1.Music_Label_Code = cml.Music_Label_Code --AND tmst1.Title_Code = cml.Title_Code 
																  AND cml.Channel_Code = tmst1.Channel_Code AND tmst1.Schedule_Date BETWEEN cml.Rights_Start_Date AND cml.Rights_End_Date
					WHERE cml.Show_Linked = 'Y' --(cml.Deal_Workflow_Status = 'A' OR cml.Deal_Version > 1 )AND 
				) AS a
				INNER JOIN #TempMusicScheduleTransaction tmst ON a.IntCode = tmst.IntCode AND a.RowNum = 1
				WHERE isValid = 'Y' AND isError = 'N'

			END

			BEGIN --------------- EXCEPTION  - MUSIC DEAL NOT APPROVE ONLY WHEN DEAL VERSION IS 1
	
				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - DEAL NOT APPROVE VALIDATION - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',DNA'
				FROM #TempMusicScheduleTransaction tmst
				INNER JOIN Music_Deal md ON tmst.Music_Deal_Code = md.Music_Deal_Code AND md.Deal_Workflow_Status <> 'A' AND CAST(md.Version AS INT) = 1

			END
			
			BEGIN --------------- EXCEPTION  - CHANNEL NOT FOUND IN MUSIC DEAL

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - CHANNEL NOT FOUND IN MUSIC DEAL - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1

				--SELECT *
				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',CNF'
				FROM #TempMusicScheduleTransaction tmst WHERE tmst.Music_Label_Code NOT IN (
					SELECT cml.Music_Label_Code FROM #AllMusicLabelDealData cml WHERE tmst.Channel_Code = cml.Channel_Code
				) AND isValid = 'Y' AND isError = 'N'

			END
			
			BEGIN --------------- EXCEPTION - SCHEDULE OUTSIDE RIGHTS PERIOD

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - SCHEDULE OUTSIDE RIGHTS PERIOD - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',IRP'
				FROM #TempMusicScheduleTransaction tmst WHERE tmst.Music_Label_Code NOT IN (
					SELECT cml.Music_Label_Code FROM #AllMusicLabelDealData cml WHERE tmst.Schedule_Date BETWEEN cml.Rights_Start_Date AND cml.Rights_End_Date
				) AND isValid = 'Y' AND isError = 'N'

			END
			
			BEGIN --------------- EXCEPTION - SHOW NOT LINK

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - SHOW NOT LINK - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET tmst.Music_Deal_Code = NULL, isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',SNL'
				FROM #TempMusicScheduleTransaction tmst
				WHERE Music_Deal_Code IS NULL AND isValid = 'Y' AND isError = 'N'

			END

			BEGIN --------------- EXCEPTION - Music Track is Deactive

				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - Music Track is Deactive - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET isValid = 'N', isError = 'Y', NewRaisedErrCodes = ISNULL(NewRaisedErrCodes, '') + ',MTID'
				FROM #TempMusicScheduleTransaction tmst
				INNER JOIN Music_Title MT ON tmst.Music_Title_Code = MT.Music_Title_Code
				WHERE  isValid = 'Y' AND isError = 'N' AND MT.Is_Active = 'N'

			END

			BEGIN --------------- RIGHT RULE PROCESSING
			
				PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' RIGHT RULE PROCESS FOR VALID ENTRIES - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
				SET @stepNo += 1
				
				UPDATE tmst SET tmst.RightRuleCode = md.Right_Rule_Code, tmst.NoOfSongs = md.No_Of_Songs, tmst.RunType = md.Run_Type, tmst.ChannelType = md.Channel_Type
				FROM #TempMusicScheduleTransaction tmst
				INNER JOIN Music_Deal md ON tmst.Music_Deal_Code = md.Music_Deal_Code
				WHERE isValid = 'Y' AND isError = 'N'

				--SELECT 
				UPDATE TMST1 SET TMST1.MinDateTime = a.MinDate
				FROM (
					SELECT IntCode, 
						CASE 
							WHEN ISNULL(rr.IS_First_Air,0) > 0 THEN	MAX(CAST(TSD.Schedule_Date + ' ' + CAST(TSD.Schedule_Item_Log_Time AS VARCHAR(8)) AS DATETIME))
							ELSE MAX(CAST(TSD.Schedule_Date + ' ' + CAST(rr.Start_Time as VARCHAR(8)) AS DATETIME))
						END MinDate
					FROM #TempMusicScheduleTransaction TMST
					INNER JOIN #TempScheduleData TSD ON TSD.BV_Schedule_Transaction_Code = TMST.BV_Schedule_Transaction_Code
					INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
					WHERE isError = 'N' AND isValid = 'Y' AND TMST.RightRuleCode IS NOT NULL
					GROUP BY IntCode, rr.IS_First_Air
				) AS a 
				INNER JOIN #TempMusicScheduleTransaction TMST1 ON a.IntCode = TMST1.IntCode
				
				UPDATE TMST SET TMST.MaxDateTime = DATEADD(SECOND,-1,DATEADD(HOUR,ISNULL(rr.Duration_Of_Day,24), TMST.MinDateTime)) 
				FROM #TempMusicScheduleTransaction TMST
				INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
				WHERE isError = 'N' AND isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL

				--SELECT * FROM 
				UPDATE TMST1 SET TMST1.CountSchedule = a.ScheduleCount
				FROM (
					SELECT TMST.IntCode, COUNT(DISTINCT MST.Music_Schedule_Transaction_Code) ScheduleCount
					FROM Music_Schedule_Transaction MST WITH(NOLOCK)
					INNER JOIN Content_Music_Link CML WITH(NOLOCK) ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
					INNER JOIN BV_Schedule_Transaction BST WITH(NOLOCK) ON MST.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code 
					INNER JOIN #TempMusicScheduleTransaction TMST ON CML.Music_Title_Code = TMST.Music_Title_Code
						AND MST.Music_Label_Code = TMST.Music_Label_Code AND MST.Music_Deal_Code = TMST.Music_Deal_Code
						AND MST.Channel_Code = TMST.Channel_Code AND MST.Music_Schedule_Transaction_Code < TMST.MusicScheduleTransactionCode
						AND CAST(BST.Schedule_Item_Log_Date + ' ' + BST.Schedule_Item_Log_Time AS DATETIME) BETWEEN TMST.MinDateTime AND TMST.MaxDateTime
					WHERE TMST.isError = 'N' AND TMST.isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL
					GROUP BY TMST.IntCode
				) AS a 
				INNER JOIN #TempMusicScheduleTransaction TMST1 ON a.IntCode = TMST1.IntCode

				--SELECT * 
				UPDATE TMST SET TMST.isIgnore = 'Y'
				FROM #TempMusicScheduleTransaction TMST
				INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
				WHERE ((TMST.CountSchedule + 1) BETWEEN (rr.Play_Per_Day + 1) AND  (rr.No_Of_Repeat + rr.Play_Per_Day))
					  AND isError = 'N' AND isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL

				UPDATE TMST SET TMST.isValid = 'N', TMST.isError = 'Y', TMST.NewRaisedErrCodes = ISNULL(tmst.NewRaisedErrCodes, '') + ',EARR'
				FROM #TempMusicScheduleTransaction TMST
				INNER JOIN Right_Rule rr ON TMST.RightRuleCode = rr.Right_Rule_Code
				WHERE ((TMST.CountSchedule + 1) > (rr.No_Of_Repeat + rr.Play_Per_Day))
					  AND isError = 'N' AND isValid = 'Y' AND TMST.MinDateTime IS NOT NULL AND TMST.RightRuleCode IS NOT NULL

			END
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' UPDATE ISIGNORE AND MUSIC DEAL CODE - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE MST SET MST.Is_Ignore = TMST.isIgnore, MST.Music_Deal_Code = TMST.Music_Deal_Code
			FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON MST.Music_Schedule_Transaction_Code = TMST.MusicScheduleTransactionCode

			SELECT DISTINCT TMST.Music_Deal_Code, TMST.Channel_Code INTO #tmpMDC FROM #TempMusicScheduleTransaction TMST WHERE TMST.isValid = 'Y' AND TMST.isError = 'N'
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' UPDATE SCHEDULE RUNS IN MUSIC DEAL CHANNEL - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE mdc SET mdc.Scheduled_Runs = mtran.ScheduleCount
			FROM Music_Deal_Channel mdc
			INNER JOIN (
				SELECT MST.Music_Deal_Code, MST.Channel_Code, COUNT(Music_Schedule_Transaction_Code) ScheduleCount
				FROM Music_Schedule_Transaction MST
				INNER JOIN (
					SELECT DISTINCT TMST.Music_Deal_Code, TMST.Channel_Code FROM #tmpMDC TMST
				) AS a ON MST.Music_Deal_Code = a.Music_Deal_Code AND MST.Channel_Code = a.Channel_Code 
				WHERE MST.Is_Ignore = 'N'
				GROUP BY MST.Music_Deal_Code, MST.Channel_Code
			) mtran ON mdc.Music_Deal_Code = mtran.Music_Deal_Code AND mdc.Channel_Code = mtran.Channel_Code

			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - EXCEEDS ALLOCATED RUNS - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE tmst SET tmst.isError = 'Y', tmst.isValid = 'N', tmst.NewRaisedErrCodes = ISNULL(tmst.NewRaisedErrCodes, '') + ',EAR'
			FROM (
				SELECT Music_Deal_Code, ISNULL(SUM(Scheduled_Runs), 0) ScheduleRuns
				FROM Music_Deal_Channel WHERE Music_Deal_Code IN (
					SELECT DISTINCT Music_Deal_Code FROM #tmpMDC
				) 
				GROUP BY Music_Deal_Code
			) AS tmp 
			INNER JOIN #TempMusicScheduleTransaction tmst ON tmp.Music_Deal_Code = tmst.Music_Deal_Code AND tmp.ScheduleRuns > tmst.NoOfSongs
			WHERE tmst.isValid = 'Y' AND tmst.isError = 'N' AND tmst.RunType = 'L'
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' VALIDATION - EXCEEDS CHANNEL WISE ALLOCATED RUNS - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE tmst SET tmst.isError = 'Y', tmst.isValid = 'N', tmst.NewRaisedErrCodes = ISNULL(tmst.NewRaisedErrCodes, '') + ',ECAR'
			FROM (
				SELECT mdc.Music_Deal_Code, mdc.Channel_Code
				FROM Music_Deal_Channel mdc
				INNER JOIN #tmpMDC tmdc ON tmdc.Music_Deal_Code = mdc.Music_Deal_Code AND tmdc.Channel_Code = mdc.Channel_Code 
				WHERE ISNULL(mdc.Scheduled_Runs, 0) > ISNULL(mdc.Defined_Runs, 0)
			) AS tmp 
			INNER JOIN #TempMusicScheduleTransaction tmst ON tmp.Music_Deal_Code = tmst.Music_Deal_Code AND tmp.Channel_Code = tmst.Channel_Code
			WHERE tmst.RunType = 'L' AND tmst.ChannelType = 'C' AND tmst.isValid = 'Y' AND tmst.isError = 'N'
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' UPDATE EXCEPTIOLN, PROCESS AND MUSIC DEAL CODE FLAG - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
				
			UPDATE MST SET MST.Is_Exception = TMST.isError, MST.Music_Deal_Code = TMST.Music_Deal_Code, MST.Is_Processed = 'Y'
			FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON MST.Music_Schedule_Transaction_Code = TMST.MusicScheduleTransactionCode
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' INSERT MUSIC SCHEDULE TRANSACTION - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			SET @stepNo += 1
	
			INSERT INTO Music_Schedule_Exception(Music_Schedule_Transaction_Code, Error_Code, [Status], Is_Mail_Sent)
			SELECT NRE.MusicScheduleTransactionCode, ECM.Error_Code, 'E', 'N' FROM Error_Code_Master ECM 
			INNER JOIN (
				SELECT tmst.MusicScheduleTransactionCode, number AS Error_Key FROM #TempMusicScheduleTransaction tmst
				CROSS APPLY fn_Split_withdelemiter(ISNULL(tmst.NewRaisedErrCodes, ''), ',') 
				WHERE RTRIM(LTRIM(number)) <> '' AND tmst.isValid = 'N' AND tmst.isError = 'Y'
			) AS NRE ON NRE.Error_Key = ECM.Upload_Error_Code
			
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' END - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
			
		END
		ELSE
		BEGIN
			PRINT ' ERROR : Music Track has not assigned to Title  - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
		END
	END
	ELSE
	BEGIN
		PRINT ' Did not get Schedule Data - ' +  CONVERT(VARCHAR(100), GETDATE(), 109)
	END
	PRINT 'Music Schedule Process Ended'
	PRINT '==============================================================================================================================================='	
	
	IF(OBJECT_ID('TEMPDB..#TempScheduleData') IS NOT NULL) DROP TABLE #TempScheduleData
	IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransaction') IS NOT NULL) DROP TABLE #TempMusicScheduleTransaction
	IF(OBJECT_ID('TEMPDB..#AllMusicLabelDealData') IS NOT NULL) DROP TABLE #AllMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#CurrentMusicLabelDealData') IS NOT NULL) DROP TABLE #CurrentMusicLabelDealData
	IF(OBJECT_ID('TEMPDB..#ExistingException') IS NOT NULL) DROP TABLE #ExistingException
	IF(OBJECT_ID('TEMPDB..#tmpMDC') IS NOT NULL) DROP TABLE #tmpMDC

END
