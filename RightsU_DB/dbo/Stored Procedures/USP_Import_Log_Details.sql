CREATE PROCEDURE [dbo].[USP_Import_Log_Details]
(
	@Record_Code VARCHAR(20),
	@Record_Type CHAR,
	@Short_Status_Code VARCHAR(100),
	@Proc_Name VARCHAR(100),
	@Step_No VARCHAR(10),
	@Sub_Step_No VARCHAR(10),
	@Loop_Counter VARCHAR(10),
	@Process_Error_MSG VARCHAR(50)

)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Import_Log_Details]', 'Step 1', 0, 'Started Procedure', 0, ''
			DECLARE @Import_Log_Code INT,
					@Sub_Short_Status_Code VARCHAR(10)
	
			IF(@Short_Status_Code = 'All01') 
			BEGIN
				INSERT INTO Import_Log(Record_Code,Record_Type,Process_Start,Short_Status_Code,Last_Update_On)
				VALUES(@Record_Code, @Record_Type, GETDATE(), @Short_Status_Code, GETDATE())
			END
			ELSE IF(@Short_Status_Code = 'All02' AND @Step_No >0) 
			BEGIN
				SELECT @Import_Log_Code = IDENT_CURRENT('Import_Log');
				INSERT INTO Import_Log_Detail(Import_Log_Code,Short_Status_Code,Proc_Name,Process_Step_No,Process_Sub_Step_No,Loop_Counter,Process_Start,Process_Error_Code)
				VALUES(@Import_Log_Code, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, GETDATE(), '')
			END
			BEGIN
				SELECT @Import_Log_Code = IDENT_CURRENT('Import_Log');
				--SELECT @Sub_Short_Status_Code = Short_Status_Code FROM Import_Log_Detail WHERE Import_Log_Code = @Import_Log_Code
				SELECT TOP 1 @Sub_Short_Status_Code = Short_Status_Code FROM Import_Log_Detail (NOLOCK) WHERE Import_Log_Code = @Import_Log_Code ORDER BY Import_Log_Detail_Code DESC
				UPDATE Import_Log SET 	
					Process_End = GETDATE(),
					Short_Status_Code = @Short_Status_Code,
					Sub_Short_Status_Code = @Sub_Short_Status_Code,
					Last_Update_On = GETDATE()
					WHERE Import_Log_Code = @Import_Log_Code
			END
			IF(@Short_Status_Code <> 'All02')
			BEGIN
				SELECT @Import_Log_Code = IDENT_CURRENT('Import_Log');
				IF(@Short_Status_Code = 'All03')
				BEGIN
					SELECT TOP 1 @Short_Status_Code = Short_Status_Code FROM Import_Log_Detail (NOLOCK) WHERE Import_Log_Code = @Import_Log_Code ORDER BY Import_Log_Detail_Code DESC
				END 
				INSERT INTO Import_Log_Detail(Import_Log_Code,Short_Status_Code,Proc_Name,Process_Step_No,Process_Sub_Step_No,Loop_Counter,Process_Start,Process_Error_Code,Process_Error_MSG)
				VALUES(@Import_Log_Code, @Short_Status_Code, @Proc_Name, @Step_No, @Sub_Step_No, @Loop_Counter, GETDATE(), '', @Process_Error_MSG)
			END
		 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Import_Log_Details]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END