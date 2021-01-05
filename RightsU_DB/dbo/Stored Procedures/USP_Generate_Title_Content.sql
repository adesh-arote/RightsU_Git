CREATE PROCEDURE [dbo].[USP_Generate_Title_Content]
(
	@Acq_Deal_Code INT,
	@Title_Codes VARCHAR(MAX),
	@User_Code INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET FMTONLY OFF
	DECLARE @ErrMessage NVARCHAR(MAX) = ''
	BEGIN TRY
		
		--DECLARE @Acq_Deal_Code INT = 3310, @Title_Codes VARCHAR(MAX) = '13499', @User_Code INT = 143

		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = '', @Deal_Workflow_Status VARCHAR(50) = '', @DefaultVersionCode INT = 1
		SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code, @Deal_Workflow_Status = Deal_Workflow_Status FROM Acq_Deal WHERE Acq_Deal_Code = @ACQ_DEAL_CODE
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)
		SELECT TOP 1 @DefaultVersionCode = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'DefaultVersionCode'

		IF(OBJECT_ID('TEMPDB..#TempAcqDealMovie') IS NOT NULL)
			DROP TABLE #TempAcqDealMovie

		IF(OBJECT_ID('TEMPDB..#TempTitleCodes') IS NOT NULL)
			DROP TABLE #TempTitleCodes

		SELECT number AS TitleCode INTO #TempTitleCodes FROM fn_Split_withdelemiter(ISNULL(@Title_Codes, ''), ',')

		SELECT Acq_Deal_Movie_Code, Title_Code, Episode_Starts_From AS Episode_From, Episode_End_To AS Episode_To, Ref_BMS_Movie_Code, 'N' AS Is_Processed
		INTO #TempAcqDealMovie FROM Acq_Deal_Movie ADM 
		WHERE adm.Acq_Deal_Code = @Acq_Deal_Code AND (ADM.Title_Code IN (SELECT TitleCode FROM #TempTitleCodes) OR ISNULL(@Title_Codes, '') = '')

		PRINT '********************* PROCESS STARTED *********************'
		PRINT 'Acq_Deal_Code : ' + CAST(@Acq_Deal_Code AS VARCHAR)
		PRINT 'Deal Type : ' + @Deal_Type_Condition
		PRINT 'Deal Workflow Status : ' + @Deal_Workflow_Status
		IF(@Deal_Type_Condition IN ('DEAL_MOVIE', 'DEAL_PROGRAM'))
		BEGIN
			DECLARE @AcqDealMovieCode INT = 0, @TitleCode INT = 0, @EpisodeFrom INT = 0, @EpisodeTo INT = 0
			SELECT TOP 1 @AcqDealMovieCode = Acq_Deal_Movie_Code, @TitleCode = Title_Code, @EpisodeFrom = Episode_From, @EpisodeTo = Episode_To
			FROM #TempAcqDealMovie WHERE Is_Processed = 'N'

			DECLARE @MaxScheduledEpisodeNo INT = 0, @Episode_No INT = 0, @Title_Content_Code INT = 0, @Content_Status CHAR(1) = 'R'
			IF EXISTS (SELECT * FROM Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code AND LTRIM(RTRIM(Deal_Workflow_Status)) = 'A')
			BEGIN
				SET @Content_Status = 'P'
			END
			IF(@AcqDealMovieCode > 0)
				PRINT '==========================================================='

			WHILE(@AcqDealMovieCode > 0 AND @TitleCode > 0 AND  @EpisodeFrom > 0 AND @EpisodeTo > 0)
			BEGIN
				PRINT 'Acq_Deal_Movie_Code : ' + CAST(@AcqDealMovieCode AS VARCHAR)
				PRINT 'Title_Code : ' + CAST(@TitleCode AS VARCHAR)
				PRINT 'Episode Range : ' + CAST(@EpisodeFrom AS VARCHAR) + ' To ' + CAST(@EpisodeTo AS VARCHAR)
				/* START : Logic For Insert/Update/Delete in Title_Content and in Title_Content_Mapping */

				SELECT @MaxScheduledEpisodeNo = NULL, @Episode_No = 0
				SELECT @MaxScheduledEpisodeNo = MAX(MaxEpisode_Id) FROM 
				(
					SELECT  MAX(TC.Episode_No) AS MaxEpisode_Id FROM Title_Content TC 
					INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
					AND TCM.Acq_Deal_Movie_Code = @AcqDealMovieCode
					INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
					UNION
					SELECT  MAX(TC.Episode_No) AS MaxEpisode_Id FROM Title_Content TC 
					INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
					AND TCM.Acq_Deal_Movie_Code = @AcqDealMovieCode
					INNER JOIN BV_Schedule_Transaction BST ON BST.Deal_Movie_Code = TCM.Acq_Deal_Movie_Code 
					AND BST.Program_Episode_ID = TC.Ref_BMS_Content_Code
				) AS TBL

				PRINT 'Max Scheduled Episode No : ' + ISNULL(CAST(@MaxScheduledEpisodeNo AS VARCHAR), 'NULL')
				DELETE TCM FROM Title_Content TC
				INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
				WHERE TCM.Acq_Deal_Movie_Code = @AcqDealMovieCode AND 
				(
					(TC.Episode_No > @EpisodeTo AND TC.Episode_No > ISNULL(@MaxScheduledEpisodeNo, @EpisodeTo)) OR 
					(TC.Episode_No < @EpisodeFrom AND TC.Episode_No < ISNULL(@MaxScheduledEpisodeNo, @EpisodeFrom))
				)

				PRINT 'Deleted data of episodes which is greater than ' + CAST(CASE 
					WHEN ISNULL(@MaxScheduledEpisodeNo, @EpisodeTo) > @EpisodeTo THEN @MaxScheduledEpisodeNo  ELSE @EpisodeTo END AS VARCHAR)

				PRINT 'Deleted data of episodes which is lesser than ' + CAST(CASE 
					WHEN ISNULL(@MaxScheduledEpisodeNo, @EpisodeFrom) < @EpisodeFrom THEN @MaxScheduledEpisodeNo  ELSE @EpisodeFrom END AS VARCHAR)

				SET @Episode_No = @EpisodeFrom
				IF(@Episode_No <= @EpisodeTo)
					PRINT '  -------------------------------------'

				WHILE(@Episode_No <= @EpisodeTo)
				BEGIN
					SET @Title_Content_Code = NULL
					IF NOT EXISTS(SELECT Title_Content_Code FROM Title_Content WHERE Title_Code = @TitleCode AND Episode_No = @Episode_No)
					BEGIN
						INSERT INTO Title_Content(Title_Code, Episode_No, Duration, Episode_Title, Content_Status, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
						SELECT T.Title_Code, @Episode_No, T.Duration_In_Min, T.Title_Name, @Content_Status, GETDATE(), @User_Code, GETDATE(), @User_Code 
						FROM Title T WHERE T.Title_Code = @TitleCode
						PRINT '  Data added successfully in Title_Content table'
						INSERT INTO Title_Content_Version(Title_Content_Code, Version_Code, Duration)
						SELECT Title_Content_Code, @DefaultVersionCode, Duration FROM Title_Content WHERE Title_Code = @TitleCode AND Episode_No = @Episode_No
						PRINT '  Data added successfully in Title_Content_Version table'
					END
					ELSE
					BEGIN
						IF(@Content_Status = 'P')
							UPDATE Title_Content SET Content_Status = @Content_Status WHERE Title_Code = @TitleCode AND Episode_No = @Episode_No
						PRINT '  Data already exists in Title_Content table'
					END

					SELECT TOP 1 @Title_Content_Code = Title_Content_Code FROM Title_Content WHERE Title_Code = @TitleCode AND Episode_No = @Episode_No

					PRINT '  Episode No : ' + CAST(@Episode_No AS VARCHAR)
					PRINT '  Title_Content_Code : ' + CAST(@Title_Content_Code AS VARCHAR)
					IF NOT EXISTS (
						SELECT * FROM Title_Content_Mapping 
						WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode AND Title_Content_Code = @Title_Content_Code
					)
					BEGIN
						INSERT INTO Title_Content_Mapping(Acq_Deal_Movie_Code, Title_Content_Code)
						VALUES(@AcqDealMovieCode, @Title_Content_Code)
						PRINT '  Data added successfully in Title_Content_Mapping table'
					END
					ELSE
						PRINT '  Data already exists in Title_Content_Mapping table'

					SET @Episode_No = @Episode_No + 1
					PRINT '  -------------------------------------'
				END

				DELETE CSH FROM Title_Content TC
				INNER JOIN Content_Status_History CSH ON CSH.Title_Content_Code = TC.Title_Content_Code
				WHERE ISNULL(TC.Ref_BMS_Content_Code, '') = '' AND TC.Title_Content_Code NOT IN (
					SELECT DISTINCT Title_Content_Code FROM Title_Content_Mapping
				) AND Title_Code IN (SELECT TitleCode FROM #TempTitleCodes)

				DELETE TCV FROM Title_Content TC
				INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Code = TC.Title_Content_Code
				WHERE ISNULL(TC.Ref_BMS_Content_Code, '') = '' AND TC.Title_Content_Code NOT IN (
					SELECT DISTINCT Title_Content_Code FROM Title_Content_Mapping
				) AND Title_Code IN (SELECT TitleCode FROM #TempTitleCodes)

				DELETE FROM Title_Content WHERE ISNULL(Ref_BMS_Content_Code, '') = '' AND Title_Content_Code NOT IN (
					SELECT DISTINCT Title_Content_Code FROM Title_Content_Mapping 
				) AND Title_Code IN (SELECT TitleCode FROM #TempTitleCodes)

				/* END : Logic For Insert/Update/Delete in Title_Content and in Title_Content_Mapping */

				/*Fetch Next Row*/
				UPDATE #TempAcqDealMovie SET Is_Processed = 'Y' WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode
				SELECT  @AcqDealMovieCode = 0, @EpisodeFrom = 0, @EpisodeTo = 0, @TitleCode = 0
				SELECT TOP 1 @AcqDealMovieCode = Acq_Deal_Movie_Code, @TitleCode = Title_Code, @EpisodeFrom = Episode_From, @EpisodeTo = Episode_To
				FROM #TempAcqDealMovie WHERE Is_Processed = 'N'
				PRINT '==========================================================='
			END
		END
		PRINT '*********************** PROCESS END ***********************'
	END TRY
	BEGIN CATCH
		SET @ErrMessage = ERROR_MESSAGE()
	END CATCH
	SELECT @ErrMessage AS ErrorMessage

	IF OBJECT_ID('tempdb..#TempAcqDealMovie') IS NOT NULL DROP TABLE #TempAcqDealMovie
	IF OBJECT_ID('tempdb..#TempTitleCodes') IS NOT NULL DROP TABLE #TempTitleCodes
END