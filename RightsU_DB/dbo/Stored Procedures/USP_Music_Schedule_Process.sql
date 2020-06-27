CREATE PROC [dbo].[USP_Music_Schedule_Process]
(
	@TitleCode BIGINT = 12921, 
	@EpisodeNo INT = 1, 
	@BV_Schedule_Transaction_Code BIGINT = 0, 
	@MusicScheduleTransactionCode BIGINT = 0,
	@CallFrom VARCHAR(10) = ''
)
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	20 October 2016
Description:	Music Schedule Process and Email Exception
Value for @CallFrom :
	'AM'	= Called from Assign Music Page
	'SR'	= Called from USP_Schedule_Revert_Count
	'AR'	= Called from USP_Music_Schedule_Exception_AutoResolver
	'SP'	= Called from USP_Schedule_Process
=======================================================================================================================================*/
BEGIN
	SET NOCOUNT ON
	--DECLARE
	--@TitleCode BIGINT = 31640,
	--@EpisodeNo INT = 1, 
	--@BV_Schedule_Transaction_Code BIGINT = 0, 
	--@MusicScheduleTransactionCode BIGINT = 0,
	--@CallFrom VARCHAR(10) = 'AM'

	DECLARE @stepNo INT = 1;
	PRINT 'Music Schedule Process Started'

	IF(OBJECT_ID('TEMPDB..#TempScheduleData') IS NOT NULL)
		DROP TABLE #TempScheduleData

	IF(OBJECT_ID('TEMPDB..#TempMusicScheduleTransaction') IS NOT NULL)
		DROP TABLE #TempMusicScheduleTransaction

	IF(OBJECT_ID('TEMPDB..#AllMusicLabelDealData') IS NOT NULL)
		DROP TABLE #AllMusicLabelDealData

	IF(OBJECT_ID('TEMPDB..#CurrentMusicLabelDealData') IS NOT NULL)
		DROP TABLE #CurrentMusicLabelDealData

	IF(OBJECT_ID('TEMPDB..#ExistingException') IS NOT NULL)
		DROP TABLE #ExistingException

	CREATE TABLE #TempMusicScheduleTransaction
	(
		MusicScheduleTransactionCode	BIGINT, 
		BV_Schedule_Transaction_Code	BIGINT, 
		Schedule_Date					DATETIME, 
		Schedule_Item_Log_Time			VARCHAR(50), 
		Content_Music_Link_Code			BIGINT, 
		Music_Title_Code					BIGINT, 
		Channel_Code					BIGINT, 
		Music_Label_Code				BIGINT, 
		Is_Processed					CHAR(1) DEFAULT('N')
	)

	CREATE TABLE #CurrentMusicLabelDealData
	(
		Music_Deal_Code			INT,
		Agreement_No			VARCHAR(50),
		Deal_Workflow_Status	VARCHAR(5),
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
		Is_Active_Deal			VARCHAR(1)
	)

	CREATE TABLE #ExistingException
	(
		MusicScheduleTransactionCode	INT,
		Error_Code						INT,
		Error_Key						VARCHAR(10)
	)

	DECLARE @DefaultVersionCode INT = 1, @Users_Code INT,  @Email_Config_Code INT
	SELECT TOP 1 @DefaultVersionCode = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'DefaultVersionCode'
	
	SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config where [Key]='MSE'
	--EXEC SP_HELP BV_Schedule_Transaction
	PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select Title_Code and Episode_No, If Parameter @BV_Schedule_Transaction_Code has value' 
	SET @stepNo += 1
	IF(@BV_Schedule_Transaction_Code > 0)
	BEGIN
		PRINT ' Selecting Title_Code and Episode_No for @BV_Schedule_Transaction_Code = ' + CAST(@BV_Schedule_Transaction_Code AS VARCHAR) 
		SELECT TOP 1 @TitleCode = TC.Title_Code, @EpisodeNo = TC.Episode_No
		FROM BV_Schedule_Transaction BST
		INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
		WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code
	END

	/* Revert Schedule*/
	IF(@CallFrom = 'SR')
	BEGIN
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete data from Music_Schedule_Exception table for Revert'
		DELETE MSE FROM Music_Schedule_Transaction MST
		INNER JOIN Music_Schedule_Exception MSE ON MST.Music_Schedule_Transaction_Code = MSE.Music_Schedule_Transaction_Code
		AND MST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code

		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(B) : Delete data from Music_Schedule_Transaction table for Revert'
		DELETE FROM Music_Schedule_Transaction WHERE BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code
	END

	/* Get Schedule Data for Title*/
	PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Get Schedule Data for Title'
	SET @stepNo += 1
	SELECT BST.BV_Schedule_Transaction_Code, TC.Title_Code, TC.Episode_No, CONVERT(DATETIME, BST.Schedule_Item_Log_Date, 121) AS Schedule_Date,
	BST.Schedule_Item_Log_Time, BST.Channel_Code, CAST('' AS VARCHAR(3)) AS Valid_Flag
	INTO #TempScheduleData
	FROM BV_Schedule_Transaction BST
	INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
	WHERE TC.Title_Code = @TitleCode AND TC.Episode_No = @EpisodeNo
		AND (BST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code OR @BV_Schedule_Transaction_Code = 0)

	IF EXISTS (SELECT * FROM #TempScheduleData)
	BEGIN
		PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Got Schedule Data'
		IF(@CallFrom = 'AR' AND ISNULL(@MusicScheduleTransactionCode, 0) > 0)
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data from Music_Schedule_Transaction table and Insert in #TempMusicScheduleTransaction in case of Auto Resolve'	
			INSERT INTO #TempMusicScheduleTransaction(MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT MST.Music_Schedule_Transaction_Code, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, MST.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MST.Music_Label_Code, 'N' AS Is_Processed
			FROM Music_Schedule_Transaction MST
			INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
			INNER JOIN #TempScheduleData TSD ON MST.BV_Schedule_Transaction_Code = TSD.BV_Schedule_Transaction_Code
			WHERE MST.Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode
		END
		
		IF(ISNULL(@MusicScheduleTransactionCode, 0) = 0)
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for Music_Schedule_Transaction insertion'	
			INSERT INTO #TempMusicScheduleTransaction(MusicScheduleTransactionCode, BV_Schedule_Transaction_Code, Schedule_Date, 
				Schedule_Item_Log_Time, Content_Music_Link_Code, Music_Title_Code, Channel_Code, Music_Label_Code, Is_Processed)
			SELECT DISTINCT 0 AS MusicScheduleTransactionCode, TSD.BV_Schedule_Transaction_Code, TSD.Schedule_Date, 
				TSD.Schedule_Item_Log_Time, CML.Content_Music_Link_Code, CML.Music_Title_Code, TSD.Channel_Code, MTL.Music_Label_Code, 'N' AS Is_Processed
			FROM Title_Content TC
			INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
			INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code AND TCV.Version_Code = @DefaultVersionCode
			INNER JOIN #TempScheduleData TSD ON TSD.Title_Code = TC.Title_Code AND TSD.Episode_No =  TC.Episode_No
			LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = CML.Music_Title_Code 
				AND TSD.Schedule_Date BETWEEN MTL.Effective_From AND ISNULL(MTL.Effective_To, TSD.Schedule_Date)
			WHERE TC.Title_Code = @TitleCode AND TC.Episode_No = @EpisodeNo 
		END

		SET @stepNo += 1

		/*	GET Deal Data
			AS : All Show, AF : All Fiction, AN : All Non Fiction, AE : All Event, SP : Specific
		*/

		DECLARE @CurrentTitleDealType INT = 0, @DealType_Fiction INT = 0, @DealType_NonFiction INT = 0, @DealType_Event INT = 22
		SELECT TOP 1 @DealType_Fiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Content'
		SELECT TOP 1 @DealType_NonFiction = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Format_Program'
		SELECT TOP 1 @DealType_Event = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Event'
		SELECT TOP 1 @CurrentTitleDealType = Deal_Type_Code FROM Title T WHERE T.Title_Code = @TitleCode

		PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Select data for #AllMusicLabelDealData '	
		SET @stepNo += 1
		SELECT TMST.Music_Label_Code, MD.Music_Deal_Code, MD.Agreement_No, MD.Deal_Workflow_Status, 
		MD.Rights_Start_Date, MD.Rights_End_Date, MD.Run_Type, 
		MD.Right_Rule_Code,
		MD.Channel_Type, MDC.Channel_Code, MD.No_Of_Songs,
		CASE WHEN MD.Channel_Type = 'S' THEN MD.No_Of_Songs ELSE MDC.Defined_Runs END AS Defined_Runs, 
		MDC.Scheduled_Runs,
		CASE 
			WHEN MD.Link_Show_Type = 'AS' THEN 'Y'
			WHEN MD.Link_Show_Type = 'AF' AND @CurrentTitleDealType = @DealType_Fiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AN' AND @CurrentTitleDealType = @DealType_NonFiction THEN 'Y'
			WHEN MD.Link_Show_Type = 'AE' AND @CurrentTitleDealType = @DealType_Event THEN 'Y'
			WHEN MD.Link_Show_Type = 'SP' AND MDLS.Title_Code = @TitleCode THEN 'Y'
			ELSE 'N'
		END AS Show_Linked, MDLS.Title_Code, MD.Inserted_On AS DealCreatedOn, 'N' AS [Is_Active_Deal]
		INTO #AllMusicLabelDealData
		FROM #TempMusicScheduleTransaction TMST
		INNER JOIN Music_Deal MD ON MD.Music_Label_Code = TMST.Music_Label_Code
		INNER JOIN Music_Deal_Channel MDC ON MDC.Music_Deal_Code = MD.Music_Deal_Code
		LEFT JOIN Music_Deal_LinkShow MDLS ON MDLS.Music_Deal_Code = MD.Music_Deal_Code 
				
		IF(@CallFrom <> 'AR')
		BEGIN
			/* Delete the Data, If data already exist, which we are going to Insert */
			PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(A) : Delete the data from Music_Schedule_Exception, If data already exist, which we are going to Insert'
			DELETE MSE FROM Music_Schedule_Transaction MST
			INNER JOIN Music_Schedule_Exception MSE ON MSE.Music_Schedule_Transaction_Code = MST.Music_Schedule_Transaction_Code
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code 

			PRINT ' STEP ' + CAST((@stepNo - 1) AS VARCHAR) + '(B) : Delete the data from Music_Schedule_Transaction, If data already exist, which we are going to Insert'
			DELETE MST FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code 

			/* Insert data in Music Schedule Transaction Table */
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Insert data into Music_Schedule_Transaction'
			SET @stepNo += 1
			INSERT INTO Music_Schedule_Transaction(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, 
				Is_Processed, Is_Ignore, Inserted_On)
			SELECT BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Label_Code, Channel_Code, Is_Processed, 
				NULL AS IsIgnore, GETDATE()
			FROM #TempMusicScheduleTransaction
			ORDER BY CAST(Schedule_Date + ' ' + Schedule_Item_Log_Time AS DATETIME)
		END

		IF(ISNULL(@MusicScheduleTransactionCode, 0) = 0)
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Update MusicScheduleTransactionCode column of #TempMusicScheduleTransaction table'
			SET @stepNo += 1
			UPDATE TMST SET TMST.MusicScheduleTransactionCode = MST.Music_Schedule_Transaction_Code FROM Music_Schedule_Transaction MST
			INNER JOIN #TempMusicScheduleTransaction TMST ON TMST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
				AND TMST.Content_Music_Link_Code = MST.Content_Music_Link_Code AND TMST.Channel_Code = MST.Channel_Code 
				AND (
					(TMST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS = MST.Is_Processed COLLATE SQL_Latin1_General_CP1_CI_AS AND @CallFrom <> 'AR') OR 
					@CallFrom = 'AR'
				)
		END

		IF EXISTS (SELECT TOP 1 * FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N')
		BEGIN
			PRINT ' STEP ' + CAST(@stepNo AS VARCHAR) + ' : Loop on #TempMusicScheduleTransaction table'
			SET @stepNo += 1
			DECLARE @MusicLabelCode BIGINT = 0, @MusicTitleCode BIGINT = 0, @IsError CHAR(1) = 'N',  @MusicDealCode BIGINT = 0, @lastMDCode BIGINT = 0,
					@ErrorCode BIGINT = 0, @RightRuleCode BIGINT = 0,  
					@NoOfSongs INT = 0,  @IsIgnore CHAR(1) = 'N', @RunType CHAR(1) = '', @ChannelType CHAR(1) = '', 
					@Schedule_Date DATETIME = NULL, @ChannelCode BIGINT = 0, @isValid CHAR(1) = 'Y', 
					@AutoResolvedErrCodes VARCHAR(MAX) = '', @NewRaisedErrCodes VARCHAR(MAX) = '',
					@ShowLinked CHAR(1) = 'Y', @isApprovedDeal CHAR(1) = 'Y'

			PRINT ' ---------------------------------------------------------'
			SET @MusicScheduleTransactionCode  = 0
			SELECT TOP 1 @MusicScheduleTransactionCode = MusicScheduleTransactionCode, @BV_Schedule_Transaction_Code = BV_Schedule_Transaction_Code,
			@MusicLabelCode = ISNULL(Music_Label_Code, 0), @MusicTitleCode = ISNULL(Music_Title_Code ,0) 
			FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N'
			ORDER BY MusicScheduleTransactionCode

			INSERT INTO #ExistingException(MusicScheduleTransactionCode, Error_Code, Error_Key)
			SELECT DISTINCT MSE.Music_Schedule_Transaction_Code, ECM.Error_Code, ECM.Upload_Error_Code FROM Music_Schedule_Exception MSE
			INNER JOIN #TempMusicScheduleTransaction MST ON MST.MusicScheduleTransactionCode = MSE.Music_Schedule_Transaction_Code
			INNER JOIN Error_Code_Master ECM ON ECM.Error_Code = MSE.Error_Code

			WHILE(@MusicScheduleTransactionCode > 0)
			BEGIN
				PRINT ' Process Started For @MusicScheduleTransactionCode = ' + CAST(@MusicScheduleTransactionCode AS VARCHAR) 
					+ ', @MusicLabelCode = ' + CAST(@MusicLabelCode AS VARCHAR)

				SELECT  @MusicDealCode = 0, @lastMDCode = 0, @ErrorCode = 0, @Schedule_Date = NULL, @ChannelCode = 0, @isValid  = 'Y', 
				@AutoResolvedErrCodes = '', @NewRaisedErrCodes = '', @ShowLinked = 'Y', @isApprovedDeal = 'Y'

				SELECT TOP 1 @Schedule_Date = BST.Schedule_Date, @ChannelCode = BST.Channel_Code
				FROM #TempScheduleData BST WHERE BST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code

				PRINT '  MESSAGE : @Schedule_Date : ' + CAST(@Schedule_Date AS VARCHAR) + ', @ChannelCode : ' + CAST(@ChannelCode AS VARCHAR)


				/* START : VALIDATION */
				IF(@MusicLabelCode = 0)
				BEGIN
					PRINT '  ERROR : Music Label Not Found'
					SELECT @IsError  = 'Y', @isValid = 'N'
					SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',MLBLNF'
				END
				ELSE
				BEGIN
					SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',MLBLNF'

					DELETE FROM #CurrentMusicLabelDealData
					INSERT INTO #CurrentMusicLabelDealData(
						Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
						Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
					)
					SELECT 
						Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
						Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
					FROM #AllMusicLabelDealData 
					WHERE ISNULL(Music_Deal_Code, 0) > 0 AND ISNULL(Music_Label_Code, 0) = @MusicLabelCode AND ISNULL(Title_Code, 0) = @TitleCode

					IF NOT EXISTS (SELECT * FROM #CurrentMusicLabelDealData)
					BEGIN
						INSERT INTO #CurrentMusicLabelDealData(
							Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
							Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
						)
						SELECT 
							Music_Deal_Code, Agreement_No, Deal_Workflow_Status, Rights_Start_Date, Rights_End_Date, Run_Type, Right_Rule_Code, Channel_Type, 
							Channel_Code, No_Of_Songs, Defined_Runs, Scheduled_Runs, Show_Linked, Title_Code, DealCreatedOn, Is_Active_Deal
						FROM #AllMusicLabelDealData 
						WHERE ISNULL(Music_Deal_Code, 0) > 0 AND ISNULL(Music_Label_Code, 0) = @MusicLabelCode 
					END
				END

				IF(@isValid = 'Y')
				BEGIN
					IF NOT EXISTS(SELECT * FROM #CurrentMusicLabelDealData)
					BEGIN
						PRINT '  ERROR : Deal Not Found'
						SELECT @IsError  = 'Y', @isValid = 'N'
						SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',DNF'
					END
					ELSE
						SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',DNF'
				END
			
				IF(@isValid = 'Y')
				BEGIN
					SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
					WHERE Deal_Workflow_Status = 'A' AND Channel_Code = @ChannelCode AND Show_Linked = 'Y'
					AND @Schedule_Date BETWEEN Rights_Start_Date  AND Rights_End_Date
					ORDER BY DealCreatedOn ASC

					IF(@MusicDealCode = 0)
					BEGIN
						SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
						WHERE Deal_Workflow_Status = 'A' AND Show_Linked = 'Y' 
						ORDER BY DealCreatedOn ASC

						IF (@MusicDealCode > 0)
						BEGIN
							SELECT @ShowLinked = 'Y'
							PRINT '  MSG : Show Linked with approved deal'
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',SNL,DNA'
						END

						IF (@MusicDealCode = 0)
						BEGIN
							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
							WHERE Show_Linked = 'Y'
							ORDER BY DealCreatedOn ASC

							IF (@MusicDealCode > 0)
							BEGIN
								SELECT @ShowLinked = 'Y', @isApprovedDeal = 'N', @IsError  = 'Y', @isValid = 'N'
								PRINT '  MSG : Show Linked with non - approved deal'
								PRINT '  ERROR : Deal not approved'
								SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',SNL'
								SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',DNA'
							END
						END

						IF (@MusicDealCode = 0)
						BEGIN
							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
							WHERE Deal_Workflow_Status = 'A'

							IF (@MusicDealCode > 0)
							BEGIN
								SELECT @ShowLinked = 'N', @isApprovedDeal = 'Y', @IsError  = 'Y', @isValid = 'N'
								PRINT '  MSG : Found approved deal'
								PRINT '  ERROR : Show not linked'
								SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',DNA'
								SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',SNL'
							END
						END

						IF (@MusicDealCode = 0)
						BEGIN
							SELECT @ShowLinked = 'N', @isApprovedDeal = 'N', @IsError  = 'Y', @isValid = 'N'
							PRINT '  ERROR : Show not linked'
							PRINT '  ERROR : Deal not approved'
							SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',SNL,DNA'

							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData 
							ORDER BY DealCreatedOn ASC
						END

						SELECT @lastMDCode = @MusicDealCode, @MusicDealCode = 0

						SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData WHERE 
						((Deal_Workflow_Status = 'A' AND @isApprovedDeal = 'Y') OR @isApprovedDeal = 'N')
						AND Show_Linked = @ShowLinked
						AND @Schedule_Date BETWEEN Rights_Start_Date  AND Rights_End_Date
						AND Channel_Code = @ChannelCode 
						ORDER BY DealCreatedOn

						IF(@MusicDealCode = 0)
						BEGIN
							PRINT '  ERROR : Deal not found with valid channel and valid right period'
							SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData WHERE 
							((Deal_Workflow_Status = 'A' AND @isApprovedDeal = 'Y') OR @isApprovedDeal = 'N')
							AND Show_Linked = @ShowLinked
							AND @Schedule_Date BETWEEN Rights_Start_Date  AND Rights_End_Date
							ORDER BY DealCreatedOn

							IF(@MusicDealCode > 0)
							BEGIN
								PRINT '  ERROR : Channel not found in current deal'
								SELECT	@lastMDCode = @MusicDealCode, 
										@IsError  = 'Y', @isValid = 'N',
										@AutoResolvedErrCodes = @AutoResolvedErrCodes + ',IRP', 
										@NewRaisedErrCodes = @NewRaisedErrCodes + ',CNF'
							END
							ELSE
							BEGIN
								PRINT '  ERROR : Schedule date is out of right period'
								SELECT @IsError  = 'Y', @isValid = 'N', @NewRaisedErrCodes = @NewRaisedErrCodes + ',IRP'

								SELECT TOP 1 @MusicDealCode = Music_Deal_Code FROM #CurrentMusicLabelDealData WHERE 
								((Deal_Workflow_Status = 'A' AND @isApprovedDeal = 'Y') OR @isApprovedDeal = 'N')
								AND Show_Linked = @ShowLinked AND Channel_Code = @ChannelCode 
								ORDER BY DealCreatedOn

								IF(@MusicDealCode = 0)
								BEGIN
									PRINT '  ERROR : Channel not found in current deal'	
									SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',CNF'
								END
								ELSE
								BEGIN
									SELECT	@lastMDCode = @MusicDealCode, 
											@AutoResolvedErrCodes = @AutoResolvedErrCodes + ',CNF'
								END
							END

							SET @MusicDealCode = @lastMDCode
						END
						ELSE
						BEGIN
							PRINT '  ERROR : Deal found with valid channel and valid right period'
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',IRP,CNF'
						END
					END
					ELSE
					BEGIN
						SELECT	@IsError  = 'N', @isValid = 'Y',
								@AutoResolvedErrCodes = @AutoResolvedErrCodes + ',SNL,DNA,IRP,CNF'
					END
					
				END

				IF(@isValid = 'Y')
				BEGIN
					PRINT '  MESSAGE : Found Valid Deal (Deal Code : ' + CAST(@MusicDealCode AS VARCHAR) + ')'
					DELETE FROM #CurrentMusicLabelDealData WHERE Music_Deal_Code <> @MusicDealCode

					PRINT '  Process Started For Run Validation'
					SELECT @RightRuleCode = 0, @NoOfSongs = 0,  @IsIgnore = 'N', @RunType = '', @ChannelType = ''

					SELECT TOP 1 @RightRuleCode = ISNULL(Right_Rule_Code, 0), @NoOfSongs = ISNULL(No_Of_Songs, 0), @RunType = Run_Type, @ChannelType = Channel_Type
					FROM #CurrentMusicLabelDealData WHERE Channel_Code = @ChannelCode
					ORDER BY DealCreatedOn

					IF(@RightRuleCode > 0)
					BEGIN
						PRINT '   Found Right Rule Code : ' + CAST(@RightRuleCode AS VARCHAR)
						DECLARE @DurationOfDay INT, @IsFirstAir CHAR(10), @NoOfRepeat INT, @PlayPerDay INT, @StartTime TIME, 
						@ScheduleItemLogDateTime VARCHAR(50), @MinDateTime DATETIME,@MaxDateTime DATETIME, @CountSchedule INT

						SELECT @StartTime=Start_Time, @PlayPerDay = Play_Per_Day, @DurationOfDay = Duration_Of_Day,
							@NoOfRepeat = No_Of_Repeat ,@IsFirstAir = CASE WHEN ISNULL(IS_First_Air,0) > 0 THEN 'Y' ELSE 'N' END
						FROM Right_Rule
						WHERE Right_Rule_Code = @RightRuleCode

						PRINT '    Start Time : ' + CAST(@StartTime AS VARCHAR)
						PRINT '    Play Per Day : ' + CAST(@PlayPerDay AS VARCHAR)
						PRINT '    Duration Of Day : ' + CAST(@DurationOfDay AS VARCHAR)
						PRINT '    No Of Repeat : ' + CAST(@NoOfRepeat AS VARCHAR)
						PRINT '    Is First Air : ' + CASE WHEN @IsFirstAir = 'Y' THEN 'Yes' ELSE 'No' END

						PRINT '    Timing Calculation For Repeat Run Duration'
						SELECT TOP 1 @MinDateTime = CASE 
								WHEN @IsFirstAir = 'Y' THEN	MAX(CAST(TSD.Schedule_Date + ' ' + CAST(TSD.Schedule_Item_Log_Time AS VARCHAR(8)) AS DATETIME))
								ELSE MAX(CAST(TSD.Schedule_Date + ' ' + CAST(@StartTime as VARCHAR(8)) AS DATETIME))
							END
						FROM Music_Schedule_Transaction MST
						INNER JOIN #TempScheduleData TSD ON MST.BV_Schedule_Transaction_Code = TSD.BV_Schedule_Transaction_Code
						WHERE MST.Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode AND MST.Is_Ignore = 'N'

						SELECT @MaxDateTime = DATEADD(SECOND,-1,DATEADD(HOUR,ISNULL(@DurationOfDay,24),@MinDateTime)) 
						PRINT '    Min Date Time : ' + CAST(@MinDateTime AS VARCHAR)
						PRINT '    Max Date Time : ' + CAST(@MaxDateTime AS VARCHAR)

						SET @CountSchedule = 0
						SELECT @CountSchedule = COUNT(Music_Schedule_Transaction_Code)
						FROM Music_Schedule_Transaction MST
						INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
						INNER JOIN BV_Schedule_Transaction BST  ON MST.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code 
						WHERE CML.Music_Title_Code = @MusicTitleCode 
						AND MST.Music_Label_Code = @MusicLabelCode
						AND MST.Music_Deal_Code = @MusicDealCode
						AND MST.Channel_Code = @ChannelCode
						AND MST.Music_Schedule_Transaction_Code < @MusicScheduleTransactionCode
						AND CAST(BST.Schedule_Item_Log_Date + ' ' + BST.Schedule_Item_Log_Time AS DATETIME) BETWEEN @MinDateTime AND @MaxDateTime

						PRINT '    Count of Total Scheduled Run Before Current MusicScheduleTransactionCode (' + CAST(@MusicScheduleTransactionCode AS VARCHAR) 
							+ ') : ' + CAST(@CountSchedule AS VARCHAR)
						PRINT '    Execute logic to set value of ''IsIgnore'' flag'
						IF((@CountSchedule + 1) BETWEEN (@PlayPerDay + 1) AND  (@NoOfRepeat + @PlayPerDay))
						BEGIN
							SET @IsIgnore = 'Y'
							PRINT '   Ignore This Run'
						END
						IF((@CountSchedule + 1) > (@NoOfRepeat + @PlayPerDay))
						BEGIN
							PRINT '   ERROR : Exceeds Allocated Repeat run'
							SELECT @IsError  = 'Y'
							SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',EARR'
						END
						ELSE
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',EARR'
					END

					UPDATE Music_Schedule_Transaction SET Is_Ignore = @IsIgnore, Music_Deal_Code = @MusicDealCode
					WHERE Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode

					PRINT '   Update Scheduled_Runs in Music_Deal_Channel table'
					SET @CountSchedule = 0
					SELECT @CountSchedule = COUNT(Music_Schedule_Transaction_Code) 
					FROM Music_Schedule_Transaction WHERE  Music_Deal_Code = @MusicDealCode AND Is_Ignore = 'N' AND Channel_Code = @ChannelCode

					UPDATE Music_Deal_Channel SET Scheduled_Runs = @CountSchedule 
					WHERE Music_Deal_Code = @MusicDealCode AND Channel_Code = @ChannelCode

					IF(@RunType = 'L')
					BEGIN
						DECLARE @Scheduled_Runs INT = 0
						SELECT @Scheduled_Runs = ISNULL(SUM(Scheduled_Runs), 0) FROM Music_Deal_Channel WHERE Music_Deal_Code = @MusicDealCode

						IF (@Scheduled_Runs > @NoOfSongs)
						BEGIN
							PRINT '   Scheduled_Runs : ' +  CAST(@Scheduled_Runs AS VARCHAR)
							PRINT '   NoOfSongs : ' +  CAST(@NoOfSongs AS VARCHAR)
							PRINT '   ERROR : Exceeds Allocated Runs'
							SELECT @IsError  = 'Y'
							SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',EAR'
						END
						ELSE
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',EAR'

						IF(@ChannelType = 'C')
						BEGIN
							IF EXISTS (
								SELECT * FROM Music_Deal_Channel 
								WHERE Music_Deal_Code = @MusicDealCode AND Channel_Code = @ChannelCode  AND 
									ISNULL(Scheduled_Runs, 0) > ISNULL(Defined_Runs, 0)
							)
							BEGIN
								PRINT '   ERROR : Exceeds Channel Wise Allocated Runs'
								SELECT @IsError  = 'Y'
								SET @NewRaisedErrCodes = @NewRaisedErrCodes + ',ECAR'
							END
							ELSE
								SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',ECAR'
						END
						ELSE
							SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',ECAR'
					END
					ELSE
						SET @AutoResolvedErrCodes = @AutoResolvedErrCodes + ',EAR,ECAR'
					
					PRINT '  Process End For Run Validation'
				END

				IF(@AutoResolvedErrCodes <> '')
				BEGIN
					PRINT '  MESSAGE : Set Status = ''AR'' for Upload_Error_Code ' + @AutoResolvedErrCodes
					UPDATE MSE SET MSE.[Status] = 'AR' FROM Music_Schedule_Exception MSE
					INNER JOIN Error_Code_Master ECM ON ECM.Error_Code = MSE.Error_Code
					WHERE MSE.Music_schedule_Transaction_Code = @MusicScheduleTransactionCode AND ISNULL(MSE.[Status], 'E') = 'E'
					AND ECM.Error_For = 'MSE' AND ECM.Upload_Error_Code IN (
						SELECT number FROM fn_Split_withdelemiter(@AutoResolvedErrCodes, ',') WHERE LTRIM(number) <> ''
					)
				END

				IF(@NewRaisedErrCodes <> '')
				BEGIN
					PRINT '  MESSAGE : Add Exception or Set Status = ''E'' for Upload_Error_Code ' + @NewRaisedErrCodes
					INSERT INTO Music_Schedule_Exception(Music_Schedule_Transaction_Code, Error_Code, [Status], Is_Mail_Sent)
					SELECT @MusicScheduleTransactionCode, ECM.Error_Code, 'E', 'N' FROM Error_Code_Master ECM 
					INNER JOIN (
						SELECT number AS Error_Key FROM fn_Split_withdelemiter(@NewRaisedErrCodes, ',') WHERE LTRIM(number) <> ''
					) NRE ON NRE.Error_Key = ECM.Upload_Error_Code
					WHERE ECM.Error_For = 'MSE' AND
					NOT EXISTS(
						SELECT * FROM #ExistingException EE WHERE EE.Error_Code = ECM.Error_Code AND 
						EE.MusicScheduleTransactionCode = @MusicScheduleTransactionCode 
					)

					UPDATE MSE SET MSE.[Status] = 'E' FROM #ExistingException EE
					INNER JOIN (
						SELECT number AS Error_Key FROM fn_Split_withdelemiter(@NewRaisedErrCodes, ',') WHERE LTRIM(number) <> ''
					) NRE ON NRE.Error_Key COLLATE SQL_Latin1_General_CP1_CI_AS = EE.Error_Key COLLATE SQL_Latin1_General_CP1_CI_AS
					INNER JOIN Music_Schedule_Exception MSE ON MSE.Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode
						AND EE.Error_Code = MSE.Error_Code AND MSE.[Status] <> 'E'
				END

				PRINT '  @MusicDealCode = ' + CAST(@MusicDealCode AS VARCHAR)
				PRINT '  @IsError = ' + @IsError

				UPDATE Music_Schedule_Transaction SET Music_Deal_Code = @MusicDealCode, 
					Is_Exception = @IsError, Is_Processed = 'Y'
				WHERE Music_Schedule_Transaction_Code = @MusicScheduleTransactionCode
				/* END : VALIDATION */

				UPDATE #TempMusicScheduleTransaction SET Is_Processed = 'Y' WHERE MusicScheduleTransactionCode = @MusicScheduleTransactionCode
				PRINT ' Process End For @MusicScheduleTransactionCode = ' + CAST(@MusicScheduleTransactionCode AS VARCHAR)
				PRINT ' ---------------------------------------------------------'
				SELECT @MusicScheduleTransactionCode = 0, @BV_Schedule_Transaction_Code = 0, @MusicLabelCode = 0, @IsError  = 'N', @MusicTitleCode = 0

				SELECT TOP 1 @MusicScheduleTransactionCode = MusicScheduleTransactionCode, @BV_Schedule_Transaction_Code = BV_Schedule_Transaction_Code,
				@MusicLabelCode = ISNULL(Music_Label_Code, 0), @MusicTitleCode = ISNULL(Music_Title_Code ,0) 
				FROM #TempMusicScheduleTransaction WHERE Is_Processed = 'N'
				ORDER BY MusicScheduleTransactionCode
			END

			IF(@MusicDealCode > 0 AND @isValid = 'Y')
			BEGIN
				SELECT @RunType = Run_Type FROM Music_Deal MD WHERE Music_Deal_Code = @MusicDealCode

			END
		END
		ELSE
		BEGIN
			PRINT ' ERROR : Music Track has not assigned to Title'
		END
	END
	ELSE
	BEGIN
		PRINT ' Did not get Schedule Data'
	END
	PRINT 'Music Schedule Process Ended'
	PRINT '==============================================================================================================================================='	
	
	BEGIN
		PRINT 'Music Schedule Exception Mail Process Started'
		DECLARE @IsChannelwiseMail VARCHAR(1) = 'N'
		SELECT TOP 1 @IsChannelwiseMail = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'IS_Schedule_Mail_Channelwise'

		IF(OBJECT_ID('TEMPDB..#TempMailData') IS NOT NULL)
			DROP TABLE #TempMailData

		CREATE TABLE #TempMailData
		(
			RowNo INT IDENTITY(1,1),
			Channel_Codes VARCHAR(MAX),
			User_Email_Id VARCHAR(MAX),
			Record_Count INT,
			Email_Data NVARCHAR(MAX),
			IsMailSent CHAR(1) DEFAULT('N'),
			User_Code INT
		)

		IF(@IsChannelwiseMail = 'Y')
		BEGIN
			PRINT ' Send seperate mail for every channel'
			INSERT INTO #TempMailData(Channel_Codes, User_Email_Id, Record_Count, Email_Data, User_Code)
			SELECT distinct	','+ cast(c.Channel_Code as varchar(10)) + ',',
			U.email_id, 0, '' , u.Users_Code
			from [dbo].[UFN_Get_Bu_Wise_User]('MSE') buUsers
			INNER JOIN Users u on u.Users_Code = buUsers.Users_Code
			INNER JOIN Security_Group SG ON SG.security_group_code = U.security_group_code
			inner join Channel c on ','+buUsers.Channel_Codes+ ',' like '%,'+ cast(c.Channel_Code as varchar(20)) +',%'
		END
		ELSE
		BEGIN
			PRINT ' Send single mail for All Channel'
			INSERT INTO #TempMailData(Channel_Codes, User_Email_Id, Record_Count, Email_Data, User_Code)
			SELECT distinct
			','+ buUsers.Channel_Codes + ',',
			U.email_id, 0, '' , u.Users_Code
			from [dbo].[UFN_Get_Bu_Wise_User]('MSE') buUsers
			INNER JOIN Users u on u.Users_Code = buUsers.Users_Code
			INNER JOIN Security_Group SG ON SG.security_group_code = U.security_group_code
		END

		DECLARE @Music_Schedule_Transaction_Code INT = 0, @Exception VARCHAR(250), @Content NVARCHAR(1000), @Episode_No INT, @Airing_Date VARCHAR(50), @Airing_Time VARCHAR(50),
		@Channel_Code BIGINT, @Channel_Name NVARCHAR(200), @Music_Title_Name NVARCHAR(2000), @Movie_Album NVARCHAR(1000), @Music_Label_Name VARCHAR(100)

		DECLARE @trTable NVARCHAR(MAX) = '', @RowNo INT = 0, @User_Email_Id VARCHAR(MAX) = '', @totalException BIGINT = 0
		SET @trTable = '<tr>      
			<th align="center" width="15%" class="tblHead"><b>Exception<b></th>    
			<th align="center" width="15%" class="tblHead"><b>Content<b></th>      
			<th align="center" width="5%" class="tblHead"><b>Episode No<b></th>      
			<th align="center" width="10%" class="tblHead"><b>Airing Date<b></th>      
			<th align="center" width="10%" class="tblHead"><b>Airing Time<b></th>      
			<th align="center" width="10%" class="tblHead"><b>Channel Name<b></th>
			<th align="center" width="15%" class="tblHead"><b>Music Track<b></th>
			<th align="center" width="10%" class="tblHead"><b>Movie / Album<b></th>
			<th align="center" width="10%" class="tblHead"><b>Music Label<b></th>
		</tr>'

		UPDATE #TempMailData SET Email_Data = @trTable

		PRINT ' Fetch Exceptional Data for TitleCode : ' + CAST(ISNULL(@TitleCode, 0) AS VARCHAR) + ', Episode_No : ' + CAST(ISNULL(@EpisodeNo, 0) AS VARCHAR)
		DECLARE curMailData CURSOR FOR
			SELECT DISTINCT MST.Music_Schedule_Transaction_Code,
			CASE WHEN ISNULL(MD.Agreement_No, '') <> '' THEN ECM.Error_Description +' (' + MD.Agreement_No  +')' ELSE ECM.Error_Description END AS Exception , ISNULL(T.Title_Name, '') AS Content, 
			ISNULL(TC.Episode_No, 0) AS Episode_No, BST.Schedule_Item_Log_Date AS Airing_Date, BST.Schedule_Item_Log_Time AS Airing_Time, 
			ISNULL(MST.Channel_Code, 0) AS Channel_Code, ISNULL(C.Channel_Name, '') AS Channel_Name , ISNULL(MT.Music_Title_Name, '') AS Music_Title_Name,
			ISNULL(MA.Music_Album_Name, MT.Movie_Album) AS Movie_Album, ISNULL(ML.Music_Label_Name, '') AS Music_Label_Name
			FROM Music_Schedule_Transaction MST
			INNER JOIN Music_Schedule_Exception MSE ON MSE.Music_Schedule_Transaction_Code = MST.Music_Schedule_Transaction_Code
			INNER JOIN Error_Code_Master ECM ON ECM.Error_Code = MSE.Error_Code
			INNER JOIN Content_Music_Link CML ON CML.Content_Music_Link_Code = MST.Content_Music_Link_Code
			INNER JOIN BV_Schedule_Transaction BST ON BST.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
			INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
				AND TC.Title_Content_Code =  CML.Title_Content_Code
			INNER JOIN Title T ON T.Title_Code = BST.Title_Code AND T.Title_Code = TC.Title_Code
			INNER JOIN Music_Title MT ON MT.Music_Title_Code = CML.Music_Title_Code
			LEFT JOIN Channel C ON C.Channel_Code = MST.Channel_Code
			LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MST.Music_Label_Code
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
			LEFT JOIN Music_Deal MD ON MD.Music_Deal_Code = MST.Music_Deal_Code
			WHERE ISNULL(MSE.Is_Mail_Sent, 'N') = 'N' AND ISNULL(MST.Is_Exception, 'N') = 'Y'
			AND TC.Title_Code = @TitleCode AND TC.Episode_No = @EpisodeNo
		OPEN curMailData
		FETCH NEXT FROM curMailData INTO @Music_Schedule_Transaction_Code, @Exception, @Content, @Episode_No, 
			@Airing_Date, @Airing_Time, @Channel_Code, @Channel_Name, @Music_Title_Name, 
			@Movie_Album, @Music_Label_Name
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @totalException = (@totalException + 1)
			SELECT @RowNo = 0, @trTable = ''
			SELECT TOP 1 @RowNo = RowNo FROM #TempMailData WHERE Channel_Codes LIKE '%,' + CAST(@Channel_Code AS VARCHAR) + ',%'
			PRINT '  Generate HTML Row for @Channel_Code : ' + CAST(@Channel_Code AS VARCHAR) + ',  @RowNo : ' + CAST(@RowNo AS VARCHAR)

			IF(@RowNo > 0)
			BEGIN
				SET @trTable = @trTable + '<tr>'
				SET @trTable = @trTable + '<td align="center" class="tblData">' + @Exception + '</td>
					<td align="center" class="tblData">' + @Content + '</td>
					<td align="center" class="tblData">' + CAST(@Episode_No AS VARCHAR) + '</td>
					<td align="center" class="tblData">' + @Airing_Date + '</td>
					<td align="center" class="tblData">' + @Airing_Time + '</td>
					<td align="center" class="tblData">' + @Channel_Name + '</td>
					<td align="center" class="tblData">' + @Music_Title_Name + '</td>
					<td align="center" class="tblData">' + @Movie_Album + '</td>
					<td align="center" class="tblData">' + @Music_Label_Name + '</td>'
				SET @trTable = @trTable + '</tr>'

				IF NOT EXISTS (SELECT * FROM #TempMailData WHERE Email_Data LIKE '%'+ @trTable +'%')
					UPDATE #TempMailData SET Email_Data = (Email_Data +  @trTable), Record_Count = (Record_Count + 1)  
					WHERE Channel_Codes LIKE '%,' + CAST(@Channel_Code AS VARCHAR) + ',%'

				UPDATE Music_Schedule_Transaction SET Is_Mail_Sent = 'Q' WHERE Music_Schedule_Transaction_Code = @Music_Schedule_Transaction_Code

				UPDATE Music_Schedule_Exception SET Is_Mail_Sent = 'Q' WHERE Music_Schedule_Transaction_Code = @Music_Schedule_Transaction_Code
				AND Is_Mail_Sent = 'N'
			END

			FETCH NEXT FROM curMailData INTO @Music_Schedule_Transaction_Code, @Exception, @Content, @Episode_No, 
			@Airing_Date, @Airing_Time, @Channel_Code, @Channel_Name, @Music_Title_Name, 
			@Movie_Album, @Music_Label_Name
		END
		CLOSE curMailData
		DEALLOCATE curMailData

		IF(@totalException > 0)
		BEGIN
			IF EXISTS (SELECT * FROM #TempMailData WHERE Record_Count > 0)
			BEGIN
				PRINT ' Fetch Mail Body and Email Profile'
				DECLARE @mailBody NVARCHAR(MAX), @mailBodyWithData NVARCHAR(MAX), @dbEmail_Profile VARCHAR(100) = '', @DefaultSiteUrl VARCHAR(500) = ''
				SELECT top 1 @dbEmail_Profile = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile'
				SELECT TOP 1 @mailBody = Template_Desc FROM Email_Template WHERE Template_For = 'MS'
				
			
				SELECT TOP 1 @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
				SET @mailBody = REPLACE(@mailBody, '{Link}', @DefaultSiteUrl)
				
				SELECT @RowNo = 0, @trTable = '', @User_Email_Id = ''
				SELECT TOP 1 @RowNo =  RowNo, @trTable = Email_Data, @User_Email_Id = User_Email_Id, @Users_Code = User_Code
				FROM #TempMailData WHERE IsMailSent = 'N' AND Record_Count > 0
				
				WHILE(@RowNo > 0 AND @trTable <> '' AND @User_Email_Id <> '')
				BEGIN	
					SET @mailBodyWithData = ''
					SET @mailBodyWithData = REPLACE(@mailBody, '{TABLE_DATA}', @trTable)

					PRINT '  @User_Email_Id : ' + @User_Email_Id
					PRINT '  @mailBodyWithData : ' + @mailBodyWithData

					EXEC msdb.dbo.sp_send_dbmail 
					@profile_name=@dbEmail_Profile, @recipients=@User_Email_Id,
					@subject='Music Schedule Exception', @body_format = 'HTML', @body=@mailBodyWithData

					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code,GETDATE(),'N','<table class="tblFormat" >'+@trTable+'</table>',@Users_Code,'Music Schedule Exception',@User_Email_Id

					UPDATE #TempMailData SET IsMailSent = 'Y' WHERE RowNo = @RowNo
					SELECT @RowNo = 0, @trTable = '', @User_Email_Id = ''
					SELECT TOP 1 @RowNo =  RowNo, @trTable = Email_Data, @User_Email_Id = User_Email_Id FROM #TempMailData WHERE IsMailSent = 'N' AND Record_Count > 0
					print 'End - @RowNo - '+cast(@RowNo as varchar(50))
				END
				PRINT ' All Mail Sent'
				UPDATE Music_Schedule_Transaction SET Is_Mail_Sent = 'Y' WHERE Is_Mail_Sent = 'Q' AND Is_Exception = 'Y'
				UPDATE Music_Schedule_Exception SET Is_Mail_Sent = 'Y' WHERE Is_Mail_Sent = 'Q'
			END
			ELSE
			BEGIN
				PRINT ' Exceptional Data Not Found for Configured Channel'
			END
		END
		ELSE
		BEGIN
			PRINT ' Exceptional Data Not Found '
		END
		PRINT 'Music Schedule Exception Mail Process Ended'
		PRINT '==============================================================================================================================================='	
	END
END




