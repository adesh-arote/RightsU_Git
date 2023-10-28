CREATE PROCEDURE USP_Music_Schedule
AS
BEGIN --------------------- MUSIC SCHEDULE PROCESS START

			CREATE TABLE #DELMusicSchCodes
			(
				Music_Schedule_Transaction_Code INT,	
			)

			CREATE TABLE #TempSchedule
			(
				BV_Schedule_Transaction_Code INT,
				Content_Music_Link_Code INT,
				Music_Title_Code INT,
				Title_Code INT,
				Program_Episode_Number VARCHAR(100),
				Channel_Code INT
			)

			CREATE TABLE #CMLCode
			(
				BV_Schedule_Transaction_Code INT,
				Content_Music_Link_Code INT
			)
			
			CREATE TABLE #ProcessingBVSchCodes
			(
				BV_Schedule_Transaction_Code INT,	
			)

			INSERT INTO #DELMusicSchCodes(Music_Schedule_Transaction_Code)
			SELECT Music_Schedule_Transaction_Code FROM Music_Schedule_Transaction WHERE BV_Schedule_Transaction_Code NOT IN (
				SELECT BV_Schedule_Transaction_Code FROM BV_Schedule_Transaction
			)

			DELETE FROM Music_Schedule_Exception WHERE Music_Schedule_Transaction_Code IN (
				SELECT Music_Schedule_Transaction_Code FROM #DELMusicSchCodes
			)
	
			DELETE FROM Music_Schedule_Transaction WHERE Music_Schedule_Transaction_Code IN (
				SELECT Music_Schedule_Transaction_Code FROM #DELMusicSchCodes
			)

			INSERT INTO #TempSchedule(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Title_Code, Program_Episode_Number, Channel_Code, Music_Title_Code)
			SELECT DISTINCT BV_Schedule_Transaction_Code, cml.Content_Music_Link_Code, tc.Title_Code, bst.Program_Episode_Number AS Program_Episode_Number, Channel_Code, Music_Title_Code
			FROM Title_Content tc
			INNER JOIN Content_Music_Link cml ON cml.Title_Content_Code = tc.Title_Content_Code
			INNER JOIN BV_Schedule_Transaction bst ON tc.Ref_BMS_Content_Code = bst.Program_Episode_ID
			--WHERE tc.Title_Code = 27522

			INSERT INTO #CMLCode(Content_Music_Link_Code, BV_Schedule_Transaction_Code)
			SELECT DISTINCT mct.Content_Music_Link_Code, mct.BV_Schedule_Transaction_Code FROM Music_Schedule_Transaction mct
			INNER JOIN (SELECT DISTINCT BV_Schedule_Transaction_Code FROM #TempSchedule) sch ON mct.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code

			INSERT INTO #ProcessingBVSchCodes(BV_Schedule_Transaction_Code)
			SELECT DISTINCT sch.BV_Schedule_Transaction_Code
			FROM #TempSchedule sch
			INNER JOIN VW_Music_Track_Label mtl ON mtl.Music_Title_Code = sch.Music_Title_Code AND GETDATE() > mtl.Effective_From
			WHERE sch.Content_Music_Link_Code NOT IN (
				SELECT cml.Content_Music_Link_Code FROM #CMLCode cml WHERE cml.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code
			)

			
			DECLARE @MusicScheduleProcess MusicScheduleProcess

			WHILE ((SELECT COUNT(*) FROM #ProcessingBVSchCodes) > 0)
			BEGIN

				INSERT INTO @MusicScheduleProcess(BV_Schedule_Transaction_Code)
				SELECT DISTINCT TOP 1000 BV_Schedule_Transaction_Code FROM #ProcessingBVSchCodes

				EXEC [dbo].[USP_Music_Schedule_Process_Neo] @MusicScheduleProcess, 'SP'

				DELETE FROM #ProcessingBVSchCodes WHERE BV_Schedule_Transaction_Code IN (
					SELECT BV_Schedule_Transaction_Code FROM @MusicScheduleProcess
				)

				DELETE FROM @MusicScheduleProcess

			END

			--DECLARE @BV_Schedule_Transaction_Code INT = 0

			--DECLARE CUR_BVMusicProcess CURSOR FOR SELECT BV_Schedule_Transaction_Code FROM #ProcessingBVSchCodes
			--OPEN CUR_BVMusicProcess  
			--FETCH NEXT FROM CUR_BVMusicProcess INTO @BV_Schedule_Transaction_Code
			--WHILE @@FETCH_STATUS<>-1 
			--BEGIN                                              
			--	IF(@@FETCH_STATUS<>-2)                                              
			--	BEGIN

			--		INSERT INTO MusicScheduleLog VALUES(@BV_Schedule_Transaction_Code, GETDATE())

			--		PRINT 'START USP_Music_Schedule_Process'

			--		EXEC USP_Music_Schedule_Process
			--		@TitleCode = 0, 
			--		@EpisodeNo = 0, 
			--		@BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code, 
			--		@MusicScheduleTransactionCode = 0,
			--		@CallFrom= 'SP'

			--		PRINT 'END USP_Music_Schedule_Process'
		
			--	END
			--	FETCH NEXT FROM CUR_BVMusicProcess INTO @BV_Schedule_Transaction_Code
			--END                                           
			--CLOSE CUR_BVMusicProcess                                               
			--DEALLOCATE CUR_BVMusicProcess  
			
			IF(OBJECT_ID('TEMPDB..#DELMusicSchCodes') IS NOT NULL) DROP TABLE #DELMusicSchCodes
			IF(OBJECT_ID('TEMPDB..#TempSchedule') IS NOT NULL) DROP TABLE #TempSchedule
			IF(OBJECT_ID('TEMPDB..#CMLCode') IS NOT NULL) DROP TABLE #CMLCode
			IF(OBJECT_ID('TEMPDB..#ProcessingBVSchCodes') IS NOT NULL) DROP TABLE #ProcessingBVSchCodes

END