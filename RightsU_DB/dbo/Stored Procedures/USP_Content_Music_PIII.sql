CREATE PROCEDURE [dbo].[USP_Content_Music_PIII]    
    @DM_Master_Import_Code Int,
	@StepCountIn INT,
	@StepCountOut INT OUT    
AS  
--declare
--@dm_master_import_code int = 99,
--@StepCountIn INT = 2,
--@StepCountOut INT 
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_PIII]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF OBJECT_ID('tempdb..#Temp_Music_Track') IS NOT NULL        
			DROP TABLE #Temp_Music_Track   

		IF OBJECT_ID('tempdb..#TempContentStatusHistory') IS NOT NULL        
			DROP TABLE #TempContentStatusHistory   

		Create Table #Temp_Music_Track    
		(   
			IntCode Int, 
			Music_Title_Code Int,    
			Music_Title_Name NVARCHAR(2000),
			Movie_Album NVARCHAR(2000)      
		) 

		DECLARE @User_Code INT
		DECLARE @Record_Code INT,
				@Record_Type CHAR = 'C',
				@Step_No INT = 0, 
				@Sub_Step_No INT = 1,
				@Loop_Counter INT = 0, 
				@Proc_Name VARCHAR(100),
				@Short_Status_Code VARCHAR(10),
				@Process_Error_Code VARCHAR(10),
				@Process_Error_MSG NVARCHAR(MAX) = ''

				SET @Step_No = @StepCountIn
		SELECT @User_Code =  Upoaded_By from DM_Master_Import (NOLOCK) where DM_Master_Import_Code = @DM_Master_Import_Code 

		--CM0010: Block 7 - Insert Into Temp Tables and Cursor for CUR_Content_Music

		SELECT @Record_Code = @DM_Master_Import_Code, @Step_No = @Step_No + 1, @Sub_Step_No = 1, @Short_Status_Code = 'CM0010', @Proc_Name = 'USP_Content_Music_PIII'
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  

		INSERT INTO #Temp_Music_Track (IntCode, Music_Title_Code, Music_Title_Name)    
		SELECT DM_Master_Log_Code AS IntCode, Master_Code, Name FROM DM_Master_Log (NOLOCK) WHERE Master_Type ='CM' AND ISNULL(Master_Code, 0) > 0      
		 UNION    
		SELECT 0 As IntCode,Music_Title_Code, Music_Title_Name FROM Music_Title (NOLOCK)   

		DECLARE @frameLimit INT = 0
		SELECT @frameLimit = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'FrameLimit'
		 PRINT 'Start Cursor'    
	   --Cursor    
   
	   BEGIN TRANSACTION
	   BEGIN TRY

		SELECT @Sub_Step_No = @Sub_Step_No + 1 
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG  		
		
	   DECLARE @TitleContentCode VARCHAR(100) = '',@IntCode VARCHAR(500), @TitleContentVersionCode VARCHAR(100) = '', @From VARCHAR(1000) = '', @From_Frame INT, @To VARCHAR(MAX) = '',     
	   @To_Frame INT, @Duration VARCHAR(500) = '', @Duration_Frame INT, @Music_Track NVARCHAR(2000) = ''
		DECLARE  @hh int = 0, @mm int = 0, @ss int = 0, @totalSec_T bigINT, @totalSec_F BIGINT, @diffSec BIGINT, @Version_Name NVARCHAR(1000),@Music_Code Int, @Excel_Line_No Int, @Loop_For_Excel VARCHAR(20)
    
		DECLARE CUR_Content_Music CURSOR LOCAL For 
	  
		SELECT LTRIM(RTRIM([IntCode])),LTRIM(RTRIM([Title_Content_Code])),LTRIM(RTRIM([Title_Content_Version_Code])), LTRIM(RTRIM([From])),     
			LTRIM(RTRIM([From_Frame])), LTRIM(RTRIM([To])), LTRIM(RTRIM([To_Frame])),    
			LTRIM(RTRIM(ISNULL([Duration], ''))), LTRIM(RTRIM(ISNULL([Duration_Frame], ''))), LTRIM(RTRIM(ISNULL([Music_Track], ''))),LTRIM(RTRIM([Version_Name])), LTRIM(RTRIM([Music_Title_Code])) ,CAST(LTRIM(RTRIM([Excel_Line_No])) AS INT)
			FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code  AND Is_Ignore = 'N'
			AND Movie_Album_Code IS NOT NULL AND Music_Title_Code IS NOT NUll

		OPEN CUR_Content_Music    
		FETCH NEXT FROM CUR_Content_Music InTo @IntCode, @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration,  @Duration_Frame, @Music_Track, @Version_Name, @Music_Code, @Excel_Line_No
	                                                  
		WHILE(@@FETCH_STATUS = 0)                                                  
		BEGIN                                  
		PRINT 'BEGIN Start'  
			DECLARE @Music_Title_Code INT = 0, @Version_Code INT;
			 SELECT Top 1 @Music_Title_Code = Music_Title_Code FROM #Temp_Music_Track WHERE LTRIM(RTRIM(Music_Title_Name)) collate SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(ISNULL(@Music_Track, '')))    collate SQL_Latin1_General_CP1_CI_AS Order by IntCode desc       
 	
			SELECT TOP 1 @Version_Code = Version_Code FROM [Version] (NOLOCK) WHERE Version_Name  collate SQL_Latin1_General_CP1_CI_AS = @Version_Name collate SQL_Latin1_General_CP1_CI_AS
		
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
				IF EXISTS (SELECT Duration FROM DM_Content_Music (NOLOCK) where DM_Master_Import_Code = @DM_Master_Import_Code AND IntCode = @IntCode AND (Duration != '' OR Duration != '00:00:00' ))
					BEgin
						select @duration =  Duration From DM_Content_Music (NOLOCK) where DM_Master_Import_Code = @DM_Master_Import_Code AND IntCode= @IntCode
					END
				END

				IF NOT EXISTS (SELECT * FROM Title_Content_Version (NOLOCK) WHERE Title_Content_Code = @TitleContentCode AND Version_Code = @Version_Code)
				BEGIN
					INSERT INTO Title_Content_Version (Title_Content_Code,Version_Code, Duration)
					SELECT Title_Content_Code,@Version_Code, Duration From Title_Content (NOLOCK) where Title_Content_Code = @TitleContentCode 
				END
				
			SELECT TOP 1 @TitleContentVersionCode = Title_Content_Version_Code FROM Title_Content_Version (NOLOCK) WHERE Title_Content_Code = @TitleContentCode AND Version_Code = @Version_Code
			IF EXISTS (SELECT Duration FROM DM_Content_Music (NOLOCK) where DM_Master_Import_Code = @DM_Master_Import_Code AND Title_Content_Code = @TitleContentCode AND IntCode = @IntCode AND (Duration= '' OR Duration = '00:00:00' ))
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
	 
		SELECT @Loop_Counter = @Loop_Counter + 1
		SELECT @Loop_For_Excel = CAST(@Loop_Counter AS VARCHAR(10) ) +'-'+ CAST(@Excel_Line_No AS VARCHAR(10) ) 
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_For_Excel, @Process_Error_MSG 
     
		 FETCH NEXT FROM CUR_Content_Music InTo @IntCode, @TitleContentCode, @TitleContentVersionCode, @From, @From_Frame, @To, @To_Frame, @Duration,  @Duration_Frame, @Music_Track  , @Version_Name,@Music_Code, @Excel_Line_No
		END   
      
		CLOSE CUR_Content_Music    
		DEALLOCATE CUR_Content_Music    
		--IF EXISTS(SELECT TOP 1 Record_Status='C' FROM DM_Content_Music WHERE DM_Master_Import_Code = @DM_Master_Import_Code)    
		-- BEGIN    
	 		SELECT Title_Content_Code, COUNT(*) AS RecordCount INTO #TempContentStatusHistory FROM (
					SELECT DISTINCT * FROM DM_Content_Music (NOLOCK) where DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N'
				) AS TMP
				GROUP BY Title_Content_Code

			INSERT INTO Content_Status_History(Title_Content_Code, User_Code, User_Action, Record_Count, Created_On)
			SELECT Title_Content_Code, @User_Code, 'B', RecordCount, GETDATE() FROM #TempContentStatusHistory 
		
			SELECT @Sub_Step_No = @Sub_Step_No + 1, @Loop_Counter = 0
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
		

		 UPDATE DM_Master_Import SET Status = 'S' where DM_Master_Import_Code = @DM_Master_Import_Code    

		SELECT @Sub_Step_No = @Sub_Step_No + 1, @Loop_Counter = 0
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
		
		--END
		COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK
			
			UPDATE DM_Master_Import SET Status = 'T' where DM_Master_Import_Code = @DM_Master_Import_Code
		    
			SELECT @Process_Error_MSG = ERROR_MESSAGE(), @Short_Status_Code = 'All03'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_For_Excel, @Process_Error_MSG 	

			--SELECT @Process_Error_MSG
		END CATCH

		IF OBJECT_ID('tempdb..#Temp_Music_Track') IS NOT NULL DROP TABLE #Temp_Music_Track
		IF OBJECT_ID('tempdb..#TempContentStatusHistory') IS NOT NULL DROP TABLE #TempContentStatusHistory
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_PIII]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END