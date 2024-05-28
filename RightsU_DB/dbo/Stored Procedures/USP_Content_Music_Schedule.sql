CREATE PROCEDURE [dbo].[USP_Content_Music_Schedule]  
AS   
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_Schedule]', 'Step 1', 0, 'Started Procedure', 0, ''  
		BEGIN TRY
  
				DECLARE @Record_Code INT,
						@Record_Type CHAR = 'C',
						@Step_No INT = 0, 
						@Sub_Step_No INT = 1,
						@Loop_Counter INT = 0, 
						@Proc_Name VARCHAR(100),
						@Short_Status_Code VARCHAR(10),
						@Process_Error_Code VARCHAR(10),
						@Process_Error_MSG VARCHAR(50) = '',
						@StepCountIn INT,
						@StepCountOut INT
			 
				DECLARE @DM_Master_Import_Code INT = 0, @RowCounter INT = 0
		
				SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import (NOLOCK) WHERE [Status] NOT IN('S','E','W','R','T','SR') AND File_Type = 'C' Order by DM_Master_Import_Code desc
				--select @DM_Master_Import_Code = 6179
			
				DECLARE @COUNT INT, @TotalCount INT,@StatusCount INT, @Status VARCHAR(2), @RsolveStatus VARCHAR(1)
		
				WHILE(@DM_Master_Import_Code > 0)
				BEGIN
				SELECT	@Record_Code = @DM_Master_Import_Code,
									@Step_No = @Step_No + 1,
									@Sub_Step_No = 1 ,
									@Short_Status_Code = 'All01', 
									@Proc_Name = 'USP_Content_Music_Schedule'
				EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
					select @RsolveStatus = status from DM_Master_Import (NOLOCK) where DM_Master_Import_Code = @DM_Master_Import_Code
			
					IF(@RsolveStatus = 'N')
					BEGIN
					
						--CM0004: Block 1-Update DM_Master_Import if ResolveStatus = N Call Procedure USP_Validate_Content_Music_Import And then Call USP_DM_Title_PIV Procedure
					
						SELECT @Step_No = @Step_No, @Sub_Step_No = @Sub_Step_No , @Short_Status_Code = 'CM0004'
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
						UPDATE DM_Master_Import set Status = 'W' where DM_Master_Import_Code = @DM_Master_Import_Code
		
						EXEC USP_Validate_Content_Music_Import @DM_Master_Import_Code,@Step_No,@StepCountOut OUT
		
						SET @Step_No = @StepCountOut
		
					END
					--ELSE
					--BEGIN
					--	EXEC USP_Validate_Content_Music_Import @DM_Master_Import_Code
					--END
		
					--CM0006: Block 3- Call USP_Content_Music_Schedule
		
					SELECT	@Record_Code = @DM_Master_Import_Code,
										@Step_No = 3,
										@Sub_Step_No = 1 ,
										@Short_Status_Code = 'CM0006', 
										@Proc_Name = 'USP_Content_Music_Schedule'
		
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
					EXEC USP_Content_Music_PIV @DM_Master_Import_Code,143,2,@StepCountOut OUT
			
					SELECT @Status = Status FROM DM_Master_Import (NOLOCK) where DM_Master_Import_Code  = @DM_Master_Import_Code
				
					SELECT @COUNT = COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE Is_Ignore = 'N' AND (Record_Status = 'N' OR Record_Status = 'SM')
					AND DM_Master_Import_Code = @DM_Master_Import_Code
					SELECT  @TotalCount = COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE Is_Ignore = 'N'  AND DM_Master_Import_Code = @DM_Master_Import_Code
			
					SELECT @Status = Status FROM DM_Master_Import (NOLOCK) where DM_Master_Import_Code  = @DM_Master_Import_Code
				
					--CM0009: Block 6 Call Procedure USP_Content_Music_PIII
					IF(@Status != 'R' AND @Status != 'SR')
					BEGIN
		
						SELECT @Step_No = @Step_No + 1, @Sub_Step_No = 1,  @Short_Status_Code = 'CM0009'
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
						IF(((Select [Status] From DM_Master_Import (NOLOCK) Where DM_Master_Import_Code = @DM_Master_Import_Code) = 'P') OR (@COUNT > 0 AND @COUNT = @TotalCount) )
						BEGIN 
							EXEC USP_Content_Music_PIII @DM_Master_Import_Code,@Step_No,@StepCountOut OUT
						
							SET @Step_No = @StepCountOut + 1
							
							SELECT @Sub_Step_No = 0
							EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No , @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
					
						END	
						ELSE
						BEGIN
							SELECT @StatusCount = COUNT(*) FROM DM_Content_Music (NOLOCK) WHERE (Record_Status = 'MR' OR Record_Status = 'OR' OR Record_Status = 'MO' OR Record_Status = 'SO' OR Record_Status = 'SM' ) AND IS_Ignore = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
					
							SELECT @Sub_Step_No = @Sub_Step_No + 1
							EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
							IF(@StatusCount > 0)
							BEGIN
							UPDATE DM_Master_Import SET Status = 'R' where DM_Master_Import_Code = @DM_Master_Import_Code  
							SELECT @Sub_Step_No = @Sub_Step_No + 1
							EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
							END
							ELSE
							BEGIN
								UPDATE DM_Master_Import SET Status = 'S' where DM_Master_Import_Code = @DM_Master_Import_Code  
								SELECT @Sub_Step_No = @Sub_Step_No + 1
								EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
							END
						END
					END
			  
				/*Fetch Next Record*/
				--CM0011: Block 8 -Select DM_Master_Import_Code IF [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'C' 
				
					SELECT @Step_No = @Step_No + 1, @Sub_Step_No = 1 , @Short_Status_Code = 'CM0011'
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
					IF EXISTS (SELECT TOP 1 DM_Master_Import_Code FROM DM_Master_Import  (NOLOCK)
						WHERE [Status] NOT IN('S','E','W','R','T','SR') AND File_Type = 'C'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code)
					)
					BEGIN
						SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import  (NOLOCK)
						WHERE [Status] NOT IN('S','E','W','R','T','SR') AND File_Type = 'C'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code) Order by DM_Master_Import_Code desc
					
						SELECT @Sub_Step_No = @Sub_Step_No + 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		
					END
					ELSE
					BEGIN
						SELECT @DM_Master_Import_Code = 0
				--SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import WHERE [Status] NOT IN('S','E','W','R') AND File_Type = 'C' Order by DM_Master_Import_Code desc
						SELECT @Sub_Step_No = @Sub_Step_No + 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 	
					END
				END

		SELECT @Sub_Step_No = @Sub_Step_No + 1 ,@Short_Status_Code = 'All02'
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
	
		END TRY
		BEGIN CATCH
			SELECT @Process_Error_MSG = ERROR_MESSAGE(), @Short_Status_Code = 'All03'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		END CATCH
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Content_Music_Schedule]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END