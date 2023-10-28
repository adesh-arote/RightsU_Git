CREATE PROCEDURE [dbo].[USP_Content_Music_PII]
	@DM_Import_UDT DM_Import_UDT READONLY,
	@DM_Master_Import_Code Int,
	@Users_Code INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel' 

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_PII]', 'Step 1', 0, 'Started Procedure', 0, ''
		BEGIN TRY
				DECLARE @Record_Code INT,
							@Record_Type CHAR = 'C',
							@Step_No INT = 1, 
							@Sub_Step_No INT = 1,
							@Loop_Counter INT = 0, 
							@Proc_Name VARCHAR(100),
							@Short_Status_Code VARCHAR(10),
							@Process_Error_Code VARCHAR(10),
							@Process_Error_MSG VARCHAR(50) = '',
							@StepCountIn INT,
							@StepCountOut INT,
							@Import_Log_Code INT

					
						SELECT	@Record_Code = @DM_Master_Import_Code,
							@Short_Status_Code = 'All01', 
							@Proc_Name = 'USP_Content_Music_PII'

						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--DECLARE @DM_Master_Import_Code INT = 6171
				--DECLARE @DM_Import_UDT DM_Import_UDT, @UserCode INT = 143
				--INSERT INTO @DM_Import_UDT(
				--	[Key],[value], [DM_Master_Type]
				--)
				--VALUES
				--(6955,5062,'CM')
				--INSERT INTO @DM_Import_UDT(
				--	[Key],[value], [DM_Master_Type]
				--)
				--VALUES
				--(6941,'3842','CM')

				SET NOCOUNT ON;
			
				CREATE TABLE #Temp_DM
				(
					Master_Name NVARCHAR(2000),
					DM_Master_Log_Code BIGINT,
					DM_Master_Code NVARCHAR (100),
					Master_Type NVARCHAR (100),
					Movie_Album NVARCHAR (100)
				)

				INSERT INTO #Temp_DM(Master_Name, DM_Master_Log_Code, DM_Master_Code, Master_Type, Movie_Album)
				SELECT dm.[Name], udt.[Key], udt.[value], udt.[DM_Master_Type],dm.[Music_Album]
				FROM @DM_Import_UDT udt
				INNER JOIN DM_Master_Log dm (NOLOCK) on dm.DM_Master_Log_Code = udt.[Key]

				--CM0012: Block 9 - Call Procedure USP_Content_Music_PII

				SELECT @Sub_Step_No = @Sub_Step_No + 1,@Short_Status_Code = 'CM0012'
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				DECLARE @Record_Status VARCHAR(30)

				UPDATE D SET D.Master_Code = T.DM_Master_Code, D.Action_By = @Users_Code, D.Action_On = GETDATE()
				FROM DM_Master_Log D 
				INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code != 'Y'
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				UPDATE D SET D.Mapped_By = 'V', D.Action_By = @Users_Code, D.Action_On = GETDATE()
				FROM DM_Master_Log D 
				INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code > '0' AND D.Mapped_By = 'S'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--Automap Correct Music Track for mapped Album
				UPDATE D SET D.Master_Code = Coalesce(MT.Music_Title_Code,0), D.Action_By = @Users_Code, D.Action_On = GETDATE()
				FROM DM_Master_Log D 
				INNER JOIN #Temp_DM T ON T.Master_Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Album collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = CAST(@DM_Master_Import_Code AS VARCHAR(20))
				INNER JOIN Music_Title MT  ON MT.Music_Title_Name=D.Name AND T.DM_Master_Code=MT.Music_Album_Code
				WHERE T.DM_Master_Code != 'Y' AND T.Master_Type = 'MA' AND D.Master_Type='CM'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
				FROM DM_Master_Log D 
				INNER JOIN #Temp_DM T ON D.DM_Master_Log_Code = T.DM_Master_Log_Code AND T.DM_Master_Code = 'Y'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--Ignore Track for Unmapped Album (Excluded)
				UPDATE D SET D.Is_Ignore = 'Y'
				FROM DM_Master_Log D 
				WHERE D.DM_Master_Import_Code=CAST(@DM_Master_Import_Code AS VARCHAR(20))
				AND D.Music_Album COLLATE SQL_Latin1_General_CP1_CI_AS IN (Select T.Master_Name from #Temp_DM T where T.DM_Master_Code = 'Y' AND T.Master_Type='MA')
				AND D.Master_Type='CM'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--Ignore Music Track Records for Unmapped Album (Excluded) in DM_Content_Music
				UPDATE DCM SET DCM.Is_Ignore ='Y', DCM.Record_Status = 'N'
				FROM DM_Content_Music DCM 
				WHERE DCM.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS IN (Select T.Master_Name from #Temp_DM T where T.DM_Master_Code = 'Y' AND T.Master_Type='MA')
				AND DCM.DM_Master_Import_Code=@DM_Master_Import_Code

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--Ignore music track with IS_Ignore ='Y'(Excluded)
				UPDATE D SET D.Is_Ignore ='Y', D.Record_Status = 'N'
				FROM DM_Content_Music D 
				INNER JOIN #Temp_DM T ON T.Master_Name collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = @DM_Master_Import_Code
				AND T.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = D.Movie_Album collate SQL_Latin1_General_CP1_CI_AS
				WHERE T.DM_Master_Code = 'Y' AND T.Master_Type = 'CM'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				UPDATE D SET D.Is_Ignore = 'Y', D.Action_By = @Users_Code, D.Action_On = GETDATE()
				FROM DM_Master_Log D 
				INNER JOIN #Temp_DM T ON T.Movie_Album collate SQL_Latin1_General_CP1_CI_AS = D.Name collate SQL_Latin1_General_CP1_CI_AS 
				WHERE T.DM_Master_Code = 'Y' AND T.Master_Type = 'CM' AND D.DM_Master_Import_Code = CAST(@DM_Master_Import_Code AS VARCHAR(20))

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				UPDATE D SET D.Record_Status =  Case When D.Record_Status IN('MO','SO', 'OR') THEn 'OR' Else 'N'END
				FROM DM_Content_Music D 
				INNER JOIN #Temp_DM T ON T.Master_Name   collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND (T.DM_Master_Code != 'Y' OR D.Record_Status = 'SM')
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				UPDATE D SET D.Record_Status =  Case When D.Record_Status IN('MO','SO', 'OR') THEn 'OR'Else 'N'END
				FROM DM_Content_Music D 
				INNER JOIN #Temp_DM T ON T.Master_Name   collate SQL_Latin1_General_CP1_CI_AS = D.Music_Track  collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = @DM_Master_Import_Code AND T.DM_Master_Code = 'Y'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--Update DM_CONTENT_MUSIC for Mapped Album
				Update DCM SET DCM.Movie_Album_Code=T.DM_Master_Code
				FROM DM_Content_Music DCM 
				INNER JOIN #Temp_DM T ON T.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS = DCM.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS AND T.Master_Type = 'MA'  
				WHERE DCM.DM_Master_Import_Code = @DM_Master_Import_Code AND T.DM_Master_Code != 'Y'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--Update DM_CONTENT_MUSIC for Automap Correct Music Track for mapped Album
				UPDATE D SET D.Music_Title_Code = Coalesce(MT.Music_Title_Code,0), D.Record_Status =  Case When D.Record_Status IN('MO','SO','OR') THEn 'OR'Else 'N'END
				FROM DM_Content_Music D 
				INNER JOIN #Temp_DM T ON T.Master_Name collate SQL_Latin1_General_CP1_CI_AS = D.Movie_Album collate SQL_Latin1_General_CP1_CI_AS AND D.DM_Master_Import_Code = @DM_Master_Import_Code
				INNER JOIN Music_Title MT ON MT.Music_Title_Name=D.Music_Track AND D.Movie_Album_Code=MT.Music_Album_Code
				WHERE T.DM_Master_Code != 'Y' AND T.Master_Type = 'MA'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				--Update DM_CONTENT_MUSIC for Mapped Music_Track
				Update DCM SET DCM.Music_Title_Code=T.DM_Master_Code
				FROM DM_Content_Music DCM 
				INNER JOIN #Temp_DM T ON T.Master_Name COLLATE SQL_Latin1_General_CP1_CI_AS = DCM.Music_Track COLLATE SQL_Latin1_General_CP1_CI_AS 
				AND T.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS = DCM.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS 
				AND T.Master_Type = 'CM'  
				WHERE DCM.DM_Master_Import_Code = @DM_Master_Import_Code AND T.DM_Master_Code != 'Y'

				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

				DROP TABLE #Temp_DM
				DECLARE @Count  Int , @TotalCount INT
				SELECT @Count = COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE Record_Status  IN('N','SM')
					 AND DM_Master_Import_Code = @DM_Master_Import_Code
				SELECT @TotalCount = COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Music_Title_Code IS NOT NULL AND Movie_Album_Code IS NOT NULL
				IF(@Count = @TotalCount)
				BEGIN

				UPDATE DM_Content_Music SET [Error_Message] = '' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
				UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = @DM_Master_Import_Code 
			
				SELECT @Sub_Step_No = @Sub_Step_No + 1
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
 
				END
		END TRY
		BEGIN CATCH
			SELECT @Process_Error_MSG = ERROR_MESSAGE(), @Short_Status_Code = 'All03'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		END CATCH
		--EXEC [USP_Content_Music_PIV] @DM_Master_Import_Code

		-- DECLARE @COUNT INT , @TotalCount INT


		--  SELECT @COUNT = COUNT(*) FROM DM_Content_Music WHERE Is_Ignore = 'N' AND (Record_Status = 'N' OR Record_Status = 'SM')
		--	 AND DM_Master_Import_Code = @DM_Master_Import_Code
		--	select  @TotalCount = COUNT(*) FROM DM_Content_Music WHERE Is_Ignore = 'N'  AND DM_Master_Import_Code = @DM_Master_Import_Code

		--  IF( @COUNT > 0 AND @COUNT = @TotalCount)
		--   --IF (@COUNT > 0)   
		--   BEGIN
		--  	EXEC [USP_Content_Music_PIII] @DM_Master_Import_Code
		--   END
		--   ELSE
		--   BEGIN
		--	 DECLARE @StatusCount INT
		--	 SELECT @StatusCount = COUNT(*) FROM DM_Content_Music WHERE (Record_Status = 'MR' OR Record_Status = 'OR' OR Record_Status = 'MO' OR Record_Status = 'SO' ) AND IS_Ignore = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
		
		--	 IF(@StatusCount > 0)
		--	 BEGIN
		--	 	   UPDATE DM_Master_Import SET Status = 'R' where DM_Master_Import_Code = @DM_Master_Import_Code  
		--	 END
		--	 ELSE
		--	 BEGIN
		--	 	   UPDATE DM_Master_Import SET Status = 'S' where DM_Master_Import_Code = @DM_Master_Import_Code  
		--	 END
		--   END

		--IF((SELECT [Status] From DM_Master_Import Where DM_Master_Import_Code = @DM_Master_Import_Code) = 'P')
		--BEGIN
		--	EXEC [USP_Content_Music_PIII] @DM_Master_Import_Code
		--END

		IF OBJECT_ID('tempdb..#Temp_DM') IS NOT NULL DROP TABLE #Temp_DM
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_PII]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END