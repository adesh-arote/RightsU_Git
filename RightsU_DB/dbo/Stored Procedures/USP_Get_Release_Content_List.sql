CREATE PROCEDURE [dbo].[USP_Get_Release_Content_List](
	@Acq_Deal_Code INT
)
AS
BEGIN
	SET NOCOUNT ON
	--DECLARE @Acq_Deal_Code INT = 13484

	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal WHERE Acq_Deal_Code = @ACQ_DEAL_CODE
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	IF(OBJECT_ID('TEMPDB..#TempAcqDealMovie') IS NOT NULL)
		DROP TABLE #TempAcqDealMovie

	CREATE TABLE #TempAcqDealMovie
	(
		Acq_Deal_Movie_Code BIGINT,
		Title_Code BIGINT,
		Episode_From BIGINT,
		Episode_To BIGINT,
		Delete_Episode_From BIGINT,
		Delete_Episode_To BIGINT,
		Is_Processed CHAR(1) DEFAULT('N'),
		Added_In_Loop CHAR(1) DEFAULT('N')
	)

	IF(OBJECT_ID('TEMPDB..#TempResultData') IS NOT NULL)
		DROP TABLE #TempResultData

	CREATE TABLE #TempResultData
	(
		Title_Code BIGINT, 
		Title_Name NVARCHAR(MAX), 
		Release_Episode_Range VARCHAR(MAX), 
		Delete_Episode_Range VARCHAR(MAX)
	)

	INSERT INTO #TempAcqDealMovie(Acq_Deal_Movie_Code, Title_Code, Episode_From, Episode_To)
	SELECT Acq_Deal_Movie_Code, Title_Code, Episode_Starts_From, Episode_End_To
	FROM Acq_Deal_Movie WHERE Acq_Deal_Code = @Acq_Deal_Code
	PRINT '********************* PROCESS STARTED *********************'
	PRINT 'Acq_Deal_Code : ' + CAST(@Acq_Deal_Code AS VARCHAR)
	PRINT 'Deal Type : ' + @Deal_Type_Condition
	IF(@Deal_Type_Condition IN ('DEAL_MOVIE', 'DEAL_PROGRAM'))
	BEGIN
		DECLARE @AcqDealMovieCode INT = 0, @TitleCode INT = 0, @EpisodeFrom INT = 0, @EpisodeTo INT = 0
		DECLARE @MinEpisodeNo INT = 0, @MaxEpisodeNo INT = 0
		DECLARE @MaxScheduledEpisodeNo INT = 0
		SELECT TOP 1 @AcqDealMovieCode = Acq_Deal_Movie_Code, @TitleCode = Title_Code, @EpisodeFrom = Episode_From, @EpisodeTo = Episode_To
		FROM #TempAcqDealMovie WHERE Is_Processed = 'N'

		IF(@AcqDealMovieCode > 0)
			PRINT '==========================================================='

		WHILE(@AcqDealMovieCode > 0 AND @EpisodeFrom > 0 AND @EpisodeTo > 0)
		BEGIN
			PRINT 'Acq_Deal_Movie_Code : ' + CAST(@AcqDealMovieCode AS VARCHAR)
			PRINT 'Episode Range : ' + CAST(@EpisodeFrom AS VARCHAR) + ' To ' + CAST(@EpisodeTo AS VARCHAR)
			/* START : Set Release/Delete Episode Range */
			IF(@Deal_Type_Condition IN ('DEAL_MOVIE'))
			BEGIN
				
				IF EXISTS (
					SELECT * FROM Title_Content TC 
					INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
					AND TCM.Acq_Deal_Movie_Code = @AcqDealMovieCode AND TC.Episode_No = @EpisodeFrom
				)
				BEGIN
					PRINT 'Delete already released content'
					DELETE FROM #TempAcqDealMovie WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode	AND Title_Code = @TitleCode
				END
			END
			ELSE IF(@Deal_Type_Condition IN ('DEAL_PROGRAM'))
			BEGIN
				SELECT @MaxScheduledEpisodeNo = NULL
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

				SELECT @MinEpisodeNo = NULL, @MaxEpisodeNo = NULL
				SELECT @MinEpisodeNo = Min(TC.Episode_No), @MaxEpisodeNo = Max(TC.Episode_No) FROM Title_Content TC 
				INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
				AND TCM.Acq_Deal_Movie_Code = @AcqDealMovieCode AND TC.Episode_No < @EpisodeFrom 
				AND TC.Episode_No < ISNULL(@MaxScheduledEpisodeNo, @EpisodeFrom)

				IF(@MinEpisodeNo IS NOT NULL AND @MaxEpisodeNo IS NOT NULL)
				BEGIN
					UPDATE #TempAcqDealMovie SET Delete_Episode_From = @MinEpisodeNo, Delete_Episode_To = @MaxEpisodeNo 
					WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode AND Added_In_Loop = 'N'
				END
				PRINT 'Delete Episode Range Before Episode No ' + CAST(@EpisodeFrom AS VARCHAR) + ' : ' + ISNULL(CAST(@MinEpisodeNo AS VARCHAR), 'NULL') + ' To ' + ISNULL(CAST(@MaxEpisodeNo AS VARCHAR), 'NULL')

				SELECT @MinEpisodeNo = NULL, @MaxEpisodeNo = NULL
				SELECT @MinEpisodeNo = Min(TC.Episode_No), @MaxEpisodeNo = Max(TC.Episode_No) FROM Title_Content TC 
				INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
				AND TCM.Acq_Deal_Movie_Code = @AcqDealMovieCode AND TC.Episode_No > @EpisodeTo 
				AND TC.Episode_No > ISNULL(@MaxScheduledEpisodeNo, @EpisodeTo)

				IF(@MinEpisodeNo IS NOT NULL AND @MaxEpisodeNo IS NOT NULL)
				BEGIN
					INSERT INTO #TempAcqDealMovie (Acq_Deal_Movie_Code, Title_Code, Delete_Episode_From, Delete_Episode_To, Is_Processed, Added_In_Loop)
					SELECT @AcqDealMovieCode, @TitleCode, @MinEpisodeNo, @MaxEpisodeNo, 'Y', 'Y'
				END
				PRINT 'Delete Episode Range After Episode No ' + CAST(@EpisodeTo AS VARCHAR) + ' : ' + ISNULL(CAST(@MinEpisodeNo AS VARCHAR), 'NULL') + ' To ' + ISNULL(CAST(@MaxEpisodeNo AS VARCHAR), 'NULL')

				SELECT @MinEpisodeNo = NULL, @MaxEpisodeNo = NULL
				SELECT @MinEpisodeNo = Min(TC.Episode_No), @MaxEpisodeNo = Max(TC.Episode_No) FROM Title_Content TC 
				INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
				AND TCM.Acq_Deal_Movie_Code = @AcqDealMovieCode AND TC.Episode_No BETWEEN @EpisodeFrom AND @EpisodeTo

				IF(@MinEpisodeNo IS NOT NULL and @MaxEpisodeNo IS NOT NULL)
				BEGIN
					IF(@MinEpisodeNo = @EpisodeFrom AND @MaxEpisodeNo = @EpisodeTo)
					BEGIN
						PRINT 'Content already released for Episode Range : ' + CAST(@EpisodeFrom AS VARCHAR) + ' To ' + CAST(@EpisodeTo AS VARCHAR)
						SELECT @EpisodeFrom = NULL, @EpisodeTo = NULL 
					END
					ELSE IF(@MinEpisodeNo = @EpisodeFrom AND @MaxEpisodeNo < @EpisodeTo)
					BEGIN
						PRINT 'Content already released for Episode Range : ' + CAST(@EpisodeFrom AS VARCHAR) + ' To ' + CAST(@MaxEpisodeNo AS VARCHAR)
						SET @EpisodeFrom = (@MaxEpisodeNo + 1)
					END
					ELSE IF(@MinEpisodeNo > @EpisodeFrom AND @MaxEpisodeNo = @EpisodeTo)
					BEGIN
						PRINT 'Content already released for Episode Range : ' + CAST(@MinEpisodeNo AS VARCHAR) + ' To ' + CAST(@EpisodeTo AS VARCHAR)
						SET @EpisodeTo = (@MinEpisodeNo - 1)
					END
					ELSE IF(@MinEpisodeNo > @EpisodeFrom AND @MaxEpisodeNo < @EpisodeTo)
					BEGIN
						INSERT INTO #TempAcqDealMovie (Acq_Deal_Movie_Code, Title_Code, Episode_From, Episode_To, Is_Processed, Added_In_Loop)
						SELECT @AcqDealMovieCode, @TitleCode, @EpisodeFrom, (@MinEpisodeNo - 1), 'Y', 'Y'
						PRINT 'Added Episode Range : ' + ISNULL(CAST(@EpisodeFrom AS VARCHAR), 'NULL') + ' To ' + ISNULL(CAST((@MinEpisodeNo - 1) AS VARCHAR), 'NULL')
						SET @EpisodeFrom = (@MaxEpisodeNo + 1)
					END
				END

				UPDATE #TempAcqDealMovie SET Episode_From = @EpisodeFrom, Episode_To = @EpisodeTo 
				WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode AND Added_In_Loop = 'N'
				PRINT 'Changed Episode Range : ' + ISNULL(CAST(@EpisodeFrom AS VARCHAR), 'NULL') + ' To ' + ISNULL(CAST(@EpisodeTo AS VARCHAR), 'NULL')
			END
			/* END : Set Release/Delete Episode Range */

			/*Fetch Next Row*/
			UPDATE #TempAcqDealMovie SET Is_Processed = 'Y' WHERE Acq_Deal_Movie_Code = @AcqDealMovieCode AND Added_In_Loop = 'N'
			SELECT  @AcqDealMovieCode = 0, @TitleCode = 0, @EpisodeFrom = 0, @EpisodeTo = 0
			SELECT TOP 1 @AcqDealMovieCode = Acq_Deal_Movie_Code, @TitleCode = Title_Code, @EpisodeFrom = Episode_From, @EpisodeTo = Episode_To
			FROM #TempAcqDealMovie WHERE Is_Processed = 'N'
			PRINT '==========================================================='
		END
	END

	IF(@Deal_Type_Condition IN ('DEAL_MOVIE'))
	BEGIN
		INSERT INTO #TempResultData(Title_Code, Title_Name, Release_Episode_Range, Delete_Episode_Range)
		SELECT T.Title_Code, T.Title_Name, '' AS Release_Episode_Range,'' AS Delete_Episode_Range
		FROM #TempAcqDealMovie TADM
		INNER JOIN Title T ON T.Title_Code = TADM.Title_Code
		ORDER BY T.Title_Name
	END
	IF(@Deal_Type_Condition IN ('DEAL_PROGRAM'))
	BEGIN
		PRINT 'Delete already released content episode range'
		DELETE FROM #TempAcqDealMovie
		WHERE Episode_From IS NULL AND Episode_To IS NULL AND Delete_Episode_From IS NULL AND Delete_Episode_To IS NULL

		INSERT INTO #TempResultData(Title_Code, Title_Name, Release_Episode_Range, Delete_Episode_Range)
		SELECT DISTINCT T.Title_Code, T.Title_Name, 
		STUFF((
			SELECT  ', ( ' +  CAST(Episode_From AS VARCHAR) + ' - ' + CAST(Episode_To AS VARCHAR) + ' )' FROM #TempAcqDealMovie 
			WHERE Title_Code = T.Title_Code AND Episode_From IS NOT NULL AND Episode_To IS NOT NULL
			ORDER BY Episode_From
			FOR XML PATH('')
		), 1, 1, '') AS Release_Episode_Range,
		STUFF((
			SELECT  ', ( ' +  CAST(Delete_Episode_From AS VARCHAR) + ' - ' + CAST(Delete_Episode_To AS VARCHAR) + ' )' FROM #TempAcqDealMovie 
			WHERE Title_Code = T.Title_Code AND Delete_Episode_From IS NOT NULL AND Delete_Episode_To IS NOT NULL
			ORDER BY Delete_Episode_From
			FOR XML PATH('')
		), 1, 1, '') AS Delete_Episode_Range
		FROM #TempAcqDealMovie TADM
		INNER JOIN Title T ON T.Title_Code = TADM.Title_Code
		ORDER BY T.Title_Name
	END
	SELECT Title_Code, Title_Name, 
		CASE WHEN ISNULL(Release_Episode_Range, '') = '' THEN 'NA' ELSE Release_Episode_Range END AS Release_Episode_Range, 
		CASE WHEN ISNULL(Delete_Episode_Range, '') = '' THEN 'NA' ELSE Delete_Episode_Range END AS Delete_Episode_Range
	FROM #TempResultData
	PRINT '*********************** PROCESS END ***********************'
END
