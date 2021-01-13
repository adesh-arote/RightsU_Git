CREATE PROCEDURE [dbo].[USP_Content_Music_PIII]    
    @DM_Master_Import_Code Int    
AS  
--declare
--@dm_master_import_code int = 6281
BEGIN
	IF OBJECT_ID('tempdb..#Temp_Music_Track') IS NOT NULL DROP TABLE #Temp_Music_Track
	IF OBJECT_ID('tempdb..#TempContentStatusHistory') IS NOT NULL DROP TABLE #TempContentStatusHistory
	IF OBJECT_ID('tempdb..#TempSchedule') IS NOT NULL DROP TABLE #TempSchedule
	IF OBJECT_ID('tempdb..#CMLCode') IS NOT NULL DROP TABLE #CMLCode 

	Create Table #Temp_Music_Track    
	(   
		IntCode Int, 
		Music_Title_Code Int,    
		Music_Title_Name NVARCHAR(2000)      
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

	DECLARE @User_Code INT
    SELECT @User_Code =  Upoaded_By from DM_Master_Import where DM_Master_Import_Code = @DM_Master_Import_Code 
	
	INSERT INTO #Temp_Music_Track (IntCode, Music_Title_Code, Music_Title_Name)    
	SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log WHERE Master_Type ='CM' AND ISNULL(Master_Code, 0) > 0      
     UNION    
	SELECT 0 As IntCode,Music_Title_Code, Music_Title_Name FROM Music_Title    

	DECLARE @frameLimit INT = 0
	SELECT @frameLimit = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'FrameLimit'
	 PRINT 'Start Cursor'    
   --Cursor    
   
   BEGIN TRANSACTION
   BEGIN TRY

   DECLARE @TitleContentCode VARCHAR(100) = '',@IntCode VARCHAR(500), @TitleContentVersionCode VARCHAR(100) = '', @From VARCHAR(1000) = '', @From_Frame INT, @To VARCHAR(MAX) = '',     
   @To_Frame INT, @Duration VARCHAR(500) = '', @Duration_Frame INT, @Music_Track NVARCHAR(2000) = ''
	DECLARE  @hh int = 0, @mm int = 0, @ss int = 0, @totalSec_T bigINT, @totalSec_F BIGINT, @diffSec BIGINT, @Version_Name NVARCHAR(1000)
    DECLARE CUR_Content_Music CURSOR For    
    SELECT LTRIM(RTRIM([IntCode])),LTRIM(RTRIM([Title_Content_Code])),LTRIM(RTRIM([Title_Content_Version_Code])), LTRIM(RTRIM([From])),     
        LTRIM(RTRIM([From_Frame])), LTRIM(RTRIM([To])), LTRIM(RTRIM([To_Frame])),    
        LTRIM(RTRIM(ISNULL([Duration], ''))), LTRIM(RTRIM(ISNULL([Duration_Frame], ''))), LTRIM(RTRIM(ISNULL([Music_Track], ''))),LTRIM(RTRIM([Version_Name])) 
	    FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code  AND Is_Ignore = 'N'

	OPEN CUR_Content_Music    
	FETCH NEXT FROM CUR_Content_Music InTo @IntCode, @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration,  @Duration_Frame, @Music_Track, @Version_Name
	                                                  
	WHILE(@@FETCH_STATUS = 0)                                                  
	BEGIN                                  
    PRINT 'BEGIN Start'  
		DECLARE @Music_Title_Code INT = 0, @Version_Code INT;
	     SELECT Top 1 @Music_Title_Code = Music_Title_Code FROM #Temp_Music_Track WHERE LTRIM(RTRIM(Music_Title_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Music_Track, '')))    collate SQL_Latin1_General_CP1_CI_AS Order by IntCode desc       
 	
		SELECT TOP 1 @Version_Code = Version_Code FROM [Version] WHERE Version_Name  collate SQL_Latin1_General_CP1_CI_AS = @Version_Name collate SQL_Latin1_General_CP1_CI_AS
		
		-- IF(@To_Frame < @From_Frame)
		-- BEGIN
		--	SET @diffSec = (@diffSec - 1)
		--	SET	@Duration_Frame = (@frameLimit - @From_Frame)
		--	SET @Duration_Frame = (@Duration_Frame + @To_Frame)
		-- END
		-- ELSE  IF(@To_Frame > @From_Frame)
		-- BEGIN
		--	SET @Duration_Frame = (@To_Frame - @From_Frame)
		--END
		--ELSE
		--BEGIN
		--	SET @Duration_Frame = @Duration_Frame	
		--END
		
		--IF(@Duration_Frame < 0)
		--	SET @Duration_Frame = 0

			SELECT TOP 1 @hh = CAST(number AS INT) FROM fn_Split_withdelemiter(@To, ':') WHERE id = 1
			SELECT TOP 1 @mm = CAST(number AS INT) FROM fn_Split_withdelemiter(@To, ':') WHERE id = 2
			SELECT TOP 1 @ss = CAST(number AS INT) FROM fn_Split_withdelemiter(@To, ':') WHERE id = 3
			
			SET @totalSec_T = ((@hh * 3600) + (@mm * 60) + @ss)

			SELECT TOP 1 @hh = CAST(number AS INT) FROM fn_Split_withdelemiter(@From, ':') WHERE id = 1
			SELECT TOP 1 @mm = CAST(number AS INT) FROM fn_Split_withdelemiter(@From, ':') WHERE id = 2
			SELECT TOP 1 @ss = CAST(number AS INT) FROM fn_Split_withdelemiter(@From, ':') WHERE id = 3
			
			SET @totalSec_F = ((@hh * 3600) + (@mm * 60) + @ss)

			SET @diffSec = (@totalSec_T - @totalSec_F)

			 IF(@To_Frame < @From_Frame)
			BEGIN
				SET @diffSec = (@diffSec - 1)
				SET	@Duration_Frame = (@frameLimit - @From_Frame)
				SET @Duration_Frame = (@Duration_Frame + @To_Frame)
			END
			ELSE  IF(@To_Frame > @From_Frame)
			BEGIN
				SET @Duration_Frame = (@To_Frame - @From_Frame)
			END
			ELSE
			BEGIN
				SET @Duration_Frame = @Duration_Frame	
			END
		
			IF(@Duration_Frame < 0)
				SET @Duration_Frame = 0

			IF(@diffSec > 0)
			BEGIN
			SELECT @hh = 0, @mm = 0, @ss = 0
				SET @ss= @diffSec
				IF(@ss >= 3600)
				BEGIN
					SET @hh = (@ss / 3600)
					set @ss = (@ss - (@hh * 3600))
				END

				IF(@ss >= 60)
				BEGIN
					SET @mm = (@ss / 60)
					set @ss= (@ss- (@mm * 60))
				END

				SET @duration = (RIGHT('00' + CAST(@hh AS VARCHAR), 2)  + ':' + RIGHT('00' + CAST(@mm AS VARCHAR), 2) + ':' + RIGHT('00' + CAST(@ss AS VARCHAR), 2))
			END
			ELSE
			BEGIN
			IF EXISTS (SELECT Duration FROM DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND IntCode = @IntCode AND (Duration != '' OR Duration != '00:00:00' ))
				BEgin
					select @duration =  Duration From DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND IntCode= @IntCode
				END
			END

			IF NOT EXISTS (SELECT * FROM Title_Content_Version WHERE Title_Content_Code = @TitleContentCode AND Version_Code = @Version_Code)
			BEGIN
				INSERT INTO Title_Content_Version (Title_Content_Code,Version_Code, Duration)
				SELECT Title_Content_Code,@Version_Code, Duration From Title_Content where Title_Content_Code = @TitleContentCode 
			END
				
		SELECT TOP 1 @TitleContentVersionCode = Title_Content_Version_Code FROM Title_Content_Version WHERE Title_Content_Code = @TitleContentCode AND Version_Code = @Version_Code
		IF EXISTS (SELECT Duration FROM DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND Title_Content_Code = @TitleContentCode AND IntCode = @IntCode AND (Duration= '' OR Duration = '00:00:00' ))
		BEgin
			
			update DM_Content_Music SET Duration = @Duration where DM_Master_Import_Code = @DM_Master_Import_Code AND Title_Content_Code = @TitleContentCode AND IntCode = @IntCode AND (Duration= '' OR Duration = '00:00:00' )
		END
		
	 INSERT INTO Content_Music_Link    
	 (    
		  Title_Content_Code, Title_Content_Version_Code, [From], From_Frame, [To], To_Frame, Duration, Duration_Frame, Music_Title_Code,
		  Inserted_On, Inserted_By, Last_UpDated_Time, Last_Action_By    
     )    
     VALUES    
     (    
		 @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration , @Duration_Frame, @Music_Title_Code
		 , GETDATE(), @User_Code, GETDATE(), @User_Code
     )    
	
	
	 UPDATE DM_Content_Music SET Record_Status = 'C'  WHERE Title_Content_Code = @TitleContentCode AND DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
     PRINT  'UPDATE DM_Content_Music '       
     FETCH NEXT FROM CUR_Content_Music InTo @IntCode, @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration,  @Duration_Frame, @Music_Track  , @Version_Name  
	END   
       
    CLOSE CUR_Content_Music    
    Deallocate CUR_Content_Music   
	
	BEGIN -------------- MUSIC SCHEDULE EXECUTE ---------

			INSERT INTO #TempSchedule(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Title_Code, Program_Episode_Number, Channel_Code, Music_Title_Code)
			SELECT DISTINCT BV_Schedule_Transaction_Code, cml.Content_Music_Link_Code, tc.Title_Code, bst.Program_Episode_Number AS Program_Episode_Number, Channel_Code, Music_Title_Code
			FROM Title_Content tc
			INNER JOIN (
				SELECT DISTINCT LTRIM(RTRIM([Title_Content_Code])) AS [Title_Content_Code] FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
			) AS dm ON tc.Title_Content_Code = dm.Title_Content_Code
			INNER JOIN Content_Music_Link cml ON cml.Title_Content_Code = tc.Title_Content_Code
			INNER JOIN BV_Schedule_Transaction bst ON tc.Ref_BMS_Content_Code = bst.Program_Episode_ID

			INSERT INTO #CMLCode(Content_Music_Link_Code, BV_Schedule_Transaction_Code)
			SELECT DISTINCT mct.Content_Music_Link_Code, mct.BV_Schedule_Transaction_Code FROM Music_Schedule_Transaction mct
			INNER JOIN (SELECT DISTINCT BV_Schedule_Transaction_Code FROM #TempSchedule) sch ON mct.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code

			INSERT INTO Music_Schedule_Transaction(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Music_Deal_Code, Channel_Code, Music_Label_Code, Is_Exception, Is_Processed)
			SELECT DISTINCT sch.BV_Schedule_Transaction_Code, sch.Content_Music_Link_Code, 0 Music_Deal_Code, sch.Channel_Code, mtl.Music_Label_Code, 'N', 'N'
			FROM #TempSchedule sch
			INNER JOIN VW_Music_Track_Label mtl ON mtl.Music_Title_Code = sch.Music_Title_Code AND GETDATE() > mtl.Effective_From
			WHERE sch.Content_Music_Link_Code NOT IN (
				SELECT cml.Content_Music_Link_Code FROM #CMLCode cml WHERE cml.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code
			)

			DECLARE @MusicScheduleProcess MusicScheduleProcess

			WHILE ((
				SELECT COUNT(*) FROM Music_Schedule_Transaction mst 
				INNER JOIN BV_Schedule_Transaction bv ON mst.BV_Schedule_Transaction_Code = bv.BV_Schedule_Transaction_Code 
				WHERE Is_Processed = 'N'
				) > 0
			)
			BEGIN

				INSERT INTO @MusicScheduleProcess(BV_Schedule_Transaction_Code)
				SELECT DISTINCT TOP 1000 bv.BV_Schedule_Transaction_Code
				FROM Music_Schedule_Transaction mst 
				INNER JOIN BV_Schedule_Transaction bv ON mst.BV_Schedule_Transaction_Code = bv.BV_Schedule_Transaction_Code
				WHERE mst.Is_Processed = 'N'

				EXEC [dbo].[USP_Music_Schedule_Process_Neo] @MusicScheduleProcess, 'SP'

				DELETE FROM @MusicScheduleProcess

			END

		END
    --IF EXISTS(SELECT TOP 1 Record_Status='C' FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code)    
    -- BEGIN    
	 	SELECT Title_Content_Code, COUNT(*) AS RecordCount INTO #TempContentStatusHistory FROM (
				SELECT DISTINCT * FROM DM_Content_Music where DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
			) AS TMP
			GROUP BY Title_Content_Code

		INSERT INTO Content_Status_History(Title_Content_Code, User_Code, User_Action, Record_Count, Created_On)
		SELECT Title_Content_Code, @User_Code, 'B', RecordCount, GETDATE() FROM #TempContentStatusHistory

     UPDATE DM_Master_Import SET Status = 'S' where DM_Master_Import_Code = @DM_Master_Import_Code    
    --END
	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		UPDATE DM_Master_Import SET Status = 'T' where DM_Master_Import_Code = @DM_Master_Import_Code    
	END CATCH

	IF OBJECT_ID('tempdb..#Temp_Music_Track') IS NOT NULL DROP TABLE #Temp_Music_Track
	IF OBJECT_ID('tempdb..#TempContentStatusHistory') IS NOT NULL DROP TABLE #TempContentStatusHistory
	IF OBJECT_ID('tempdb..#TempSchedule') IS NOT NULL DROP TABLE #TempSchedule
	IF OBJECT_ID('tempdb..#CMLCode') IS NOT NULL DROP TABLE #CMLCode
END