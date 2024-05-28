CREATE PROCEDURE [dbo].[USP_Insert_Acq_Deal_Movie_Contents](
	@Acq_Deal_Code INT,
	@Title_Codes VARCHAR(MAX)
)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Acq_Deal_Movie_Contents]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SET NOCOUNT ON
		SET FMTONLY OFF
		DECLARE @ErrMessage NVARCHAR(MAX) = ''
		BEGIN TRY
			--DECLARE @Acq_Deal_Code INT = 3221, @Title_Codes VARCHAR(MAX) = ''
			DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = '', @Deal_Workflow_Status VARCHAR(50) = ''
			SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code, @Deal_Workflow_Status = Deal_Workflow_Status FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @ACQ_DEAL_CODE
			SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)


			IF(OBJECT_ID('TEMPDB..#TempAcqDealMovie') IS NOT NULL)
				DROP TABLE #TempAcqDealMovie

			IF(OBJECT_ID('TEMPDB..#TempTitleCodes') IS NOT NULL)
				DROP TABLE #TempTitleCodes

			SELECT number AS TitleCode INTO #TempTitleCodes FROM fn_Split_withdelemiter(ISNULL(@Title_Codes, ''), ',')

			SELECT Acq_Deal_Movie_Code, Title_Code, Episode_Starts_From AS Episode_From, Episode_End_To AS Episode_To, Ref_BMS_Movie_Code, 'N' AS Is_Processed
			INTO #TempAcqDealMovie FROM Acq_Deal_Movie ADM  (NOLOCK)
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

				DECLARE @MaxScheduledEpisodeNo INT = 0, @Episode_Id INT = 0, @Ref_BMS_Content_Code VARCHAR(50) = NULL
				IF(@AcqDealMovieCode > 0)
					PRINT '==========================================================='

				WHILE(@AcqDealMovieCode > 0 AND @TitleCode > 0 AND  @EpisodeFrom > 0 AND @EpisodeTo > 0)
				BEGIN
					PRINT 'Acq_Deal_Movie_Code : ' + CAST(@AcqDealMovieCode AS VARCHAR)
					PRINT 'Title_Code : ' + CAST(@TitleCode AS VARCHAR)
					PRINT 'Episode Range : ' + CAST(@EpisodeFrom AS VARCHAR) + ' To ' + CAST(@EpisodeTo AS VARCHAR)
					/* START : Logic For Insert/Update/Delete in content*/

					SELECT @MaxScheduledEpisodeNo = NULL, @Episode_Id = 0, @Ref_BMS_Content_Code = NULL
					SELECT @MaxScheduledEpisodeNo = MAX(MaxEpisode_Id) FROM 
					(
						SELECT MAX(Episode_Id) AS MaxEpisode_Id FROM Acq_Deal_Movie_Contents ADMC (NOLOCK) 
						INNER JOIN Content_Music_Link CML (NOLOCK) ON CML.Acq_Deal_Movie_Content_Code = ADMC.Acq_Deal_Movie_Content_Code
						WHERE ADMC.Acq_Deal_Movie_Code = @AcqDealMovieCode
						UNION
						SELECT MAX(Episode_Id) AS MaxEpisode_Id FROM Acq_Deal_Movie_Contents ADMC  (NOLOCK)
						WHERE ADMC.Acq_Deal_Movie_Code = @AcqDealMovieCode AND ISNULL(ADMC.Ref_BMS_Content_Code, '') <> ''
					) AS TBL

					PRINT 'Max Scheduled Episode No : ' + ISNULL(CAST(@MaxScheduledEpisodeNo AS VARCHAR), 'NULL')
					DELETE CSH FROM Acq_Deal_Movie_Contents ADMC
					INNER JOIN Content_Status_History CSH ON ADMC.Acq_Deal_Movie_Content_Code = CSH.Acq_Deal_Movie_Content_Code
					WHERE ADMC.Acq_Deal_Movie_Code = @AcqDealMovieCode AND 
					(
						(ADMC.Episode_Id > @EpisodeTo AND ADMC.Episode_Id > ISNULL(@MaxScheduledEpisodeNo, @EpisodeTo)) OR 
						(ADMC.Episode_Id < @EpisodeFrom AND ADMC.Episode_Id < ISNULL(@MaxScheduledEpisodeNo, @EpisodeFrom))
					)

					DELETE ADMC FROM Acq_Deal_Movie_Contents ADMC
					WHERE ADMC.Acq_Deal_Movie_Code = @AcqDealMovieCode AND 
					(
						(ADMC.Episode_Id > @EpisodeTo AND ADMC.Episode_Id > ISNULL(@MaxScheduledEpisodeNo, @EpisodeTo)) OR 
						(ADMC.Episode_Id < @EpisodeFrom AND ADMC.Episode_Id < ISNULL(@MaxScheduledEpisodeNo, @EpisodeFrom))
					)

					PRINT 'Deleted data of episodes which is greater than ' + CAST(CASE 
						WHEN ISNULL(@MaxScheduledEpisodeNo, @EpisodeTo) > @EpisodeTo THEN @MaxScheduledEpisodeNo  ELSE @EpisodeTo END AS VARCHAR)

					PRINT 'Deleted data of episodes which is lesser than ' + CAST(CASE 
						WHEN ISNULL(@MaxScheduledEpisodeNo, @EpisodeFrom) < @EpisodeFrom THEN @MaxScheduledEpisodeNo  ELSE @EpisodeFrom END AS VARCHAR)

					SET @Episode_Id = @EpisodeFrom
					IF(@Episode_Id <= @EpisodeTo)
						PRINT '  -------------------------------------'

					WHILE(@Episode_Id <= @EpisodeTo)
					BEGIN
						PRINT '  Episode No : ' + CAST(@Episode_Id AS VARCHAR)
						SET @Ref_BMS_Content_Code = NULL
						IF(@Deal_Workflow_Status = 'A')
						BEGIN
							--IF(@Deal_Type_Condition = 'DEAL_MOVIE')
							--BEGIN
							--	SELECT TOP 1 @Ref_BMS_Content_Code = Ref_BMS_Movie_Code FROM Acq_Deal_Movie
							--	WHERE Title_Code = @TitleCode AND Acq_Deal_Code NOT IN( @Acq_Deal_Code) 
							--	AND ISNULL(Ref_BMS_Movie_Code, '') <> ''
							--END
							--ELSE IF(@Deal_Type_Condition = 'DEAL_PROGRAM')
							--BEGIN
							--	SELECT TOP 1 @Ref_BMS_Content_Code = ADMC.Ref_BMS_Content_Code FROM Acq_Deal_Movie_Contents ADMC
							--	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = ADMC.Acq_Deal_Movie_Code
							--	WHERE ADM.Title_Code = @TitleCode AND ADMC.Episode_Id = @Episode_Id AND ADM.Acq_Deal_Code NOT IN(@Acq_Deal_Code)
							--	AND ISNULL(ADMC.Ref_BMS_Content_Code,'')  <> ''
							--END
							SELECT TOP 1 @Ref_BMS_Content_Code = ADMC.Ref_BMS_Content_Code FROM Acq_Deal_Movie_Contents ADMC (NOLOCK)
							INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADM.Acq_Deal_Movie_Code = ADMC.Acq_Deal_Movie_Code
							WHERE ADM.Title_Code = @TitleCode AND ADMC.Episode_Id = @Episode_Id AND ADM.Acq_Deal_Code NOT IN(@Acq_Deal_Code)
							AND ISNULL(ADMC.Ref_BMS_Content_Code,'')  <> ''
						END
						PRINT '  Ref_BMS_Content_Code : ' + CAST(ISNULL(@Ref_BMS_Content_Code, 'NULL') AS VARCHAR)
						IF NOT EXISTS (SELECT * FROM Acq_Deal_Movie_Contents (NOLOCK) WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode AND Episode_Id = @Episode_Id)
						BEGIN
							INSERT INTO Acq_Deal_Movie_Contents(Acq_Deal_Code, Acq_Deal_Movie_Code, Episode_No, Episode_Id, 
								Duration, Ref_BMS_Content_Code,Episode_Title)
							SELECT TOP 1 @Acq_Deal_Code, @AcqDealMovieCode, CAST(@Episode_Id AS VARCHAR), @Episode_Id, 
								T.Duration_In_Min, @Ref_BMS_Content_Code, T.Title_Name
							FROM Title T (NOLOCK) WHERE T.Title_Code = @TitleCode
							PRINT '  Data added successfully in Acq_Deal_Movie_Content table'
						END
						ELSE
						BEGIN
							IF(@Ref_BMS_Content_Code IS NOT NULL)
							BEGIN
								UPDATE Acq_Deal_Movie_Contents SET Ref_BMS_Content_Code = @Ref_BMS_Content_Code 
								WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode AND Episode_Id = @Episode_Id
							END
							PRINT '  Data already exists in Acq_Deal_Movie_Content table'
						END

						SET @Episode_Id = @Episode_Id + 1
						PRINT '  -------------------------------------'
					END
					/* END : Logic For Insert/Update/Delete in content*/

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
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Acq_Deal_Movie_Contents]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
