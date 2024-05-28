ALTER PROCEDURE [dbo].[USP_Gen_Pro_Title_Content]
(
--DECLARE
	@Pro_Deal_Code INT,
	@User_Code INT = 143
)
AS
BEGIN
	SET NOCOUNT ON
	SET FMTONLY OFF
	DECLARE @ErrMessage NVARCHAR(MAX) = ''
	BEGIN TRY
		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = '', @Deal_Workflow_Status VARCHAR(50) = '', @DefaultVersionCode INT = 1

		SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code, @Deal_Workflow_Status = Deal_Workflow_Status FROM Provisional_Deal 
		WHERE Provisional_Deal_Code = @Pro_Deal_Code

		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

		SELECT TOP 1 @DefaultVersionCode = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'DefaultVersionCode'

		IF(OBJECT_ID('TEMPDB..#TempProDealTitle') IS NOT NULL)
			DROP TABLE #TempProDealTitle

		IF(OBJECT_ID('TEMPDB..#TempTitleCodes') IS NOT NULL)
			DROP TABLE #TempTitleCodes

		--SELECT number AS TitleCode INTO #TempTitleCodes FROM fn_Split_withdelemiter(ISNULL(@Title_Codes, ''), ',')

		SELECT Provisional_Deal_Title_Code, Title_Code, Episode_From, Episode_To, 'N' AS Is_Processed
		INTO #TempProDealTitle FROM Provisional_Deal_Title PDT 
		WHERE PDT.Provisional_Deal_Code = @Pro_Deal_Code
		--AND (PDT.Title_Code IN (SELECT TitleCode FROM #TempTitleCodes) OR ISNULL(@Title_Codes, '') = '')

		PRINT '********************* PROCESS STARTED *********************'
		PRINT 'Pro_Deal_Code : ' + CAST(@Pro_Deal_Code AS VARCHAR)
		PRINT 'Deal Type : ' + @Deal_Type_Condition
		PRINT 'Deal Workflow Status : ' + @Deal_Workflow_Status
		IF(@Deal_Type_Condition IN ('DEAL_MOVIE', 'DEAL_PROGRAM'))
		BEGIN
			DECLARE @ProDealTitleCode INT = 0, @TitleCode INT = 0, @EpisodeFrom INT = 0, @EpisodeTo INT = 0
			SELECT TOP 1 @ProDealTitleCode = Provisional_Deal_Title_Code, @TitleCode = Title_Code, @EpisodeFrom = Episode_From, @EpisodeTo = Episode_To
			FROM #TempProDealTitle WHERE Is_Processed = 'N'

			DECLARE @MaxScheduledEpisodeNo INT = 0, @Episode_No INT = 0, @Title_Content_Code INT = 0, @Content_Status CHAR(1) = 'R'
			IF EXISTS (SELECT * FROM Provisional_Deal WHERE Provisional_Deal_Code = @Pro_Deal_Code AND LTRIM(RTRIM(Deal_Workflow_Status)) = 'A')
			BEGIN
				SET @Content_Status = 'P'
			END
			IF(@ProDealTitleCode > 0)
			PRINT '==========================================================='

			WHILE(@ProDealTitleCode > 0 AND @TitleCode > 0) --AND  @EpisodeFrom > 0 AND @EpisodeTo > 0)
			BEGIN
				PRINT 'Provisional_Deal_Title_Code : ' + CAST(@ProDealTitleCode AS VARCHAR)
				PRINT 'Title_Code : ' + CAST(@TitleCode AS VARCHAR)
				PRINT 'Episode Range : ' + CAST(@EpisodeFrom AS VARCHAR) + ' To ' + CAST(@EpisodeTo AS VARCHAR)
				/* START : Logic For Insert/Update/Delete in Title_Content and in Title_Content_Mapping */

				SELECT @MaxScheduledEpisodeNo = NULL, @Episode_No = 0
				SELECT @MaxScheduledEpisodeNo = MAX(MaxEpisode_Id) FROM 
				(
					SELECT  MAX(TC.Episode_No) AS MaxEpisode_Id FROM Title_Content TC 
					INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
					AND TCM.Provisional_Deal_Title_Code = @ProDealTitleCode
					--??UNION
					--??SELECT  MAX(TC.Episode_No) AS MaxEpisode_Id FROM Title_Content TC 
					--??INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
					--??AND TCM.Provisional_Deal_Title_Code = @ProDealTitleCode
					--??INNER JOIN BV_Schedule_Transaction BST ON BST.Deal_Movie_Code = ADMCM.Acq_Deal_Movie_Code 
					--??AND BST.Program_Episode_ID = TC.Ref_BMS_Content_Code
				) AS TBL

				PRINT 'Max Scheduled Episode No : ' + ISNULL(CAST(@MaxScheduledEpisodeNo AS VARCHAR), 'NULL')

				DELETE TCM FROM Title_Content TC
				INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
				WHERE TCM.Provisional_Deal_Title_Code = @ProDealTitleCode AND 
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
						WHERE Provisional_Deal_Title_Code = @ProDealTitleCode AND Title_Content_Code = @Title_Content_Code
					)
					BEGIN
						INSERT INTO Title_Content_Mapping(Provisional_Deal_Title_Code, Title_Content_Code)
						VALUES(@ProDealTitleCode, @Title_Content_Code)
						PRINT '  Data added successfully in Title_Content_Mapping table'
					END
					--ELSE
					--	PRINT '  Data already exists in Title_Content_Mapping table'

					SET @Episode_No = @Episode_No + 1
					PRINT '  -------------------------------------'
				END

				PRINT 'SAYALI 1'

				DELETE CSH FROM Title_Content TC
				INNER JOIN Content_Status_History CSH ON CSH.Title_Content_Code = TC.Title_Content_Code
				WHERE ISNULL(TC.Ref_BMS_Content_Code, '') = '' AND TC.Title_Content_Code NOT IN (
					SELECT DISTINCT Title_Content_Code FROM Title_Content_Mapping
				) 
				--AND Title_Code IN (SELECT TitleCode FROM #TempTitleCodes)
				PRINT 'SAYALI 2'

				Create Table #TempCodes
				(
					Title_Content_Code Int
				)

				Insert InTo #TempCodes
				Select Distinct Title_Content_Code From Title_Content Where ISNULL(Ref_BMS_Content_Code, '') = '' AND Title_Content_Code NOT IN (
					SELECT DISTINCT Title_Content_Code FROM Title_Content_Mapping 
				) AND Title_Content_Code NOT IN (
					SELECT DISTINCT Title_Content_Code FROM Content_Music_Link
				) And Title_Code = @TitleCode

				DELETE FROM Title_Content_Version
				WHERE Title_Content_Code IN (SELECT Title_Content_Code FROM #TempCodes) 

				PRINT 'SAYALI 3'
				DELETE FROM Title_Content 
				WHERE Title_Content_Code IN (SELECT DISTINCT Title_Content_Code FROM #TempCodes ) 

				Drop Table #TempCodes

				/* END : Logic For Insert/Update/Delete in Title_Content and in Title_Content_Mapping */
				PRINT 'SAYALI 4'
				/*Fetch Next Row*/
				UPDATE #TempProDealTitle SET Is_Processed = 'Y' WHERE Provisional_Deal_Title_Code = @ProDealTitleCode
				SELECT  @ProDealTitleCode = 0, @EpisodeFrom = 0, @EpisodeTo = 0, @TitleCode = 0
				SELECT TOP 1 @ProDealTitleCode = Provisional_Deal_Title_Code, @TitleCode = Title_Code, @EpisodeFrom = Episode_From, @EpisodeTo = Episode_To
				FROM #TempProDealTitle WHERE Is_Processed = 'N'
				PRINT 'SAYALI 5'

				PRINT '==========================================================='
			END
		END
		PRINT '*********************** PROCESS END ***********************'
	END TRY
	BEGIN CATCH
		SET @ErrMessage = ERROR_MESSAGE()
	END CATCH
	SELECT @ErrMessage AS ErrorMessage
END

--EXEC [USP_Gen_Pro_Title_Content] 2088
--select TOp 10 * from Title order by 1 desc
--select * from Title_Content where Title_Code=33866
