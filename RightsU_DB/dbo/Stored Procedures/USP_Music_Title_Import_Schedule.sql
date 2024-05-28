CREATE PROCEDURE [dbo].[USP_Music_Title_Import_Schedule]  
AS   
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Music_Title_Import_Schedule]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		BEGIN TRY
	   			DECLARE @Record_Code INT,
					@Record_Type VARCHAR = 'M',
					@Step_No INT = 0, 
					@Sub_Step_No INT = 0,
					@Loop_Counter INT = 0, 
					@Proc_Name VARCHAR(100),
					@Short_Status_Code VARCHAR(10),
					@Process_Error_Code VARCHAR(10),
					@Process_Error_MSG VARCHAR(50) = '',
					@StepCountIn INT,
					@StepCountOut INT

				DECLARE @DM_Master_Import_Code INT = 0, @RowCounter INT = 0
				SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import (NOLOCK) WHERE [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'M' ORDER BY DM_Master_Import_Code DESC
				--select @DM_Master_Import_Code = 6179
				DECLARE @COUNT INT, @TotalCount INT,@StatusCount INT, @Status VARCHAR(2), @RsolveStatus VARCHAR(1)
			
				WHILE(@DM_Master_Import_Code > 0)
				BEGIN
					SELECT	@Record_Code = @DM_Master_Import_Code,
										@Step_No = @Step_No + 1,
										@Sub_Step_No = 1 ,
										@Short_Status_Code = 'All01', 
										@Proc_Name = 'USP_Music_Import_Schedule'
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG

					SELECT @RsolveStatus = status FROM DM_Master_Import (NOLOCK) WHERE DM_Master_Import_Code = @DM_Master_Import_Code
					IF(@RsolveStatus = 'N')
					BEGIN
						--M0014: Block 1- Update DM_Master_Import if ResolveStatus = N and Call USP_DM_Title_PIV Procedure
					
						SELECT @Step_No = @Step_No, @Sub_Step_No = 0,  @Short_Status_Code = 'M0014'
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

						UPDATE DM_Master_Import set Status = 'W' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

						SELECT @Sub_Step_No = @Sub_Step_No + 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					END
		
					EXEC USP_DM_Music_Title_PIV @DM_Master_Import_Code,143,2,@StepCountOut OUT
			
					SELECT @COUNT = COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE Is_Ignore = 'N' AND Record_Status = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
					SELECT  @TotalCount = COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE Is_Ignore = 'N'  AND DM_Master_Import_Code = @DM_Master_Import_Code
			
					SELECT @Status = Status FROM DM_Master_Import (NOLOCK) WHERE DM_Master_Import_Code  = @DM_Master_Import_Code
				
					IF(@Status != 'R')
					BEGIN
					
						IF(@COUNT > 0 AND @COUNT = @TotalCount) 
						BEGIN 

						--M0019: Block 6 Call Procedure USP_DM_Music_Title_PIII
						SELECT @Step_No = @Step_No + 1, @Sub_Step_No =1,  @Short_Status_Code = 'M0019'
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 		

						EXEC USP_DM_Music_Title_PIII @DM_Master_Import_Code,@Step_No,@StepCountOut OUT

						SET @Step_No = @StepCountOut + 1
							
						SELECT @Sub_Step_No = 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

						END
				
					ELSE
						BEGIN
						SELECT @StatusCount = COUNT(*) FROM DM_Music_Title (NOLOCK) WHERE (Record_Status = 'R') AND IS_Ignore = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code
					
						SELECT @Sub_Step_No = @Sub_Step_No + 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG 
						--M0021: Block 8 Update Status S or R using some conditions
						SELECT @Step_No = @Step_No + 1, @Sub_Step_No = 0, @Short_Status_Code = 'M0021'
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter , @Process_Error_MSG
						
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
					--declare @DM_MasterCode INT
					--M0022: Block 9 -Select DM_Master_Import_Code IF [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'M' 
					SELECT @Step_No = @Step_No + 1,@Sub_Step_No = 1 ,@Short_Status_Code = 'M0021'
					EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No,@Sub_Step_No, @Loop_Counter, @Process_Error_MSG 

					IF EXISTS (SELECT TOP 1 DM_Master_Import_Code FROM DM_Master_Import (NOLOCK)
						WHERE [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'M'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code)
					)
					BEGIN
						SELECT TOP 1 @DM_Master_Import_Code = DM_Master_Import_Code FROM DM_Master_Import (NOLOCK) 
						WHERE [Status] NOT IN('S','E','W','N','R','T') AND File_Type = 'M'  AND DM_Master_Import_Code NOT IN(@DM_Master_Import_Code) Order by DM_Master_Import_Code desc
						SELECT @Sub_Step_No = @Sub_Step_No + 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter , @Process_Error_MSG

					END
					ELSE
						SELECT @DM_Master_Import_Code = 0
						SELECT @Sub_Step_No = @Sub_Step_No + 1
						EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter , @Process_Error_MSG

		
				END
		SELECT @Sub_Step_No = @Sub_Step_No + 1 ,@Short_Status_Code = 'All02'
		EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
	
		END TRY
		BEGIN CATCH
			SELECT @Process_Error_MSG = ERROR_MESSAGE(), @Short_Status_Code = 'All03'
			EXEC USP_Import_log_Details @Record_Code, @Record_Type, @Short_Status_Code,@Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, @Process_Error_MSG
		END CATCH
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Music_Title_Import_Schedule]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END