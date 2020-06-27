CREATE PROC [dbo].[USP_Process_Workflow]
(
	@Module_Code Int,
	@Record_Code Int,
	@Login_User Int,
	@User_Action VARCHAR(2),
	@Remarks NVARCHAR(MAX)
)
As
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;		

		DECLARE 
		@Next_Level_Group Int = 0, @Module_Workflow_Detail_Code Int = 0, @Role_Level Int = 0, @Is_Email_Required Varchar(5) = '', 
		@Is_Error Varchar(10) = 'N'

		SELECT @Is_Email_Required = ISNULL(Is_Email_Required, 'N') FROM System_Param

		SELECT TOP 1 @Next_Level_Group = ISNULL(Next_Level_Group, 0), @Module_Workflow_Detail_Code = Module_Workflow_Detail_Code, @Role_Level = Role_Level
		FROM Module_Workflow_Detail WHERE Module_Code = @Module_Code AND Record_Code = @Record_Code And Is_Done = 'N' 
		ORDER By Role_Level

		IF (@User_Action != 'RO')
		BEGIN
			Update Module_Workflow_Detail Set Is_Done = 'Y' Where Module_Workflow_Detail_Code = @Module_Workflow_Detail_Code
		END

		INSERT INTO Module_Status_History(Module_Code, Record_Code, [Status], Status_Changed_By, Status_Changed_On, Remarks)
		SELECT @Module_Code, @Record_Code, @User_Action, @Login_User, GetDate(), @Remarks

		IF(@User_Action = 'R')
		BEGIN
			IF(@Module_Code = 30)
				UPDATE Acq_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code
			ELSE IF(@Module_Code = 35)
				UPDATE Syn_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() WHERE Syn_Deal_Code = @Record_Code
			ELSE IF(@Module_Code = 154)
				UPDATE Music_Schedule_Transaction Set Workflow_Status = @User_Action WHERE Music_Schedule_Transaction_Code = @Record_Code
			ELSE IF(@Module_Code = 163)
				UPDATE Music_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() WHERE Music_Deal_Code = @Record_Code

			DELETE FROM Module_Workflow_Detail Where Module_Code = @Module_Code And Record_Code = @Record_Code And Is_Done = 'N'

			IF(@Is_Email_Required = 'Y')
				EXEC USP_SendMail_On_Rejection @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, 'Y', 'Y',@Login_User, @Is_Error OUT
		END
		ELSE IF(@User_Action = 'RO')
		BEGIN
			IF(@Module_Code = 30)
			BEGIN
				UPDATE Acq_Deal Set Deal_Workflow_Status = 'A' WHERE Acq_Deal_Code = @Record_Code

				INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,30, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)
				--EXEC DBO.USP_AT_Acq_Deal @Record_Code, @Is_Error OUT

				Update Acq_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE(),
				[Version] =  REPLICATE('0', 6 - LEN(CONVERT(VARCHAR(50),(CONVERT(FLOAT,[Version]) + 0.1)))) + 
					CONVERT(VARCHAR(50), (CONVERT(FLOAT,[Version]) + 0.1) )
				WHERE Acq_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 35)
			BEGIN
				UPDATE Syn_Deal SET Deal_Workflow_Status = 'A' WHERE Syn_Deal_Code = @Record_Code

				EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT

				Update Syn_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE(), 
				[Version] =  REPLICATE('0', 6 - LEN(CONVERT(VARCHAR(50),(CONVERT(FLOAT,[Version]) + 0.1)))) + 
					CONVERT(VARCHAR(50), (CONVERT(FLOAT,[Version]) + 0.1) )
				WHERE Syn_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 163)
			BEGIN
				UPDATE Music_Deal SET Deal_Workflow_Status = 'A' WHERE Music_Deal_Code = @Record_Code

				EXEC DBO.USP_AT_Music_Deal @Record_Code, @Is_Error OUT

				Update Music_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE(), 
				[Version] =  REPLICATE('0', 6 - LEN(CONVERT(VARCHAR(50),(CONVERT(FLOAT,[Version]) + 0.1)))) + 
					CONVERT(VARCHAR(50), (CONVERT(FLOAT,[Version]) + 0.1) )
				WHERE Music_Deal_Code = @Record_Code
			END
		END
		ELSE
		BEGIN
			IF(@Next_Level_Group = 0)
				SET @User_Action = 'A'
			ELSE
				SET @User_Action = 'W'

			IF(@Module_Code = 30)
			BEGIN
			DECLARE @Version VARCHAR(15)
				Update Acq_Deal Set Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() Where Acq_Deal_Code = @Record_Code
				SELECT @Version=[Version] from Acq_Deal WHERE Acq_Deal_Code=@Record_Code
				IF(@User_Action = 'A')
				BEGIN
					INSERT INTO Acq_Deal_Tab_Version([Version],Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By)
					VALUES(@Version,'',@Record_Code,GETDATE(),@Login_User,GETDATE(),@Login_User)
				END
			END
			ELSE IF(@Module_Code = 35)
				UPDATE Syn_Deal Set Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() Where Syn_Deal_Code = @Record_Code
			ELSE IF(@Module_Code = 154)
				UPDATE Music_Schedule_Transaction Set Workflow_Status = @User_Action Where Music_Schedule_Transaction_Code = @Record_Code
			ELSE IF(@Module_Code = 163)
				UPDATE Music_Deal Set Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() Where Music_Deal_Code = @Record_Code

			IF(@Next_Level_Group = 0)
			BEGIN
				IF(@Module_Code = 30)
				BEGIN
					UPDATE Acq_Deal_Movie SET Is_Closed = 'Y' WHERE Is_Closed = 'X' AND Acq_Deal_Code = @Record_Code
					--EXEC DBO.USP_Generate_Title_Content @Record_Code, '', @Login_User

					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,30, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)

					--EXEC DBO.USP_AT_Acq_Deal @Record_Code, @Is_Error OUT
				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT

					DECLARE @StatusFlag VARCHAR(1), @ErrMessage VARCHAR(1)
					--EXEC DBO.USP_AutoPushAcqDeal @Record_Code, @Login_User, @StatusFlag OUT, @ErrMessage OUT
				END
				ELSE IF(@Module_Code = 154)
					UPDATE Music_Schedule_Transaction Set Workflow_Status = @User_Action Where Music_Schedule_Transaction_Code = @Record_Code
				ELSE IF(@Module_Code = 163)
					EXEC DBO.USP_AT_Music_Deal @Record_Code, @Is_Error OUT
			END
			IF(@Is_Email_Required = 'Y')
			BEGIN
				EXEC USP_SendMail_To_NextApprover_New @Record_Code, @Module_Code, 'Y', 'Y', @Is_Error Out
				EXEC USP_SendMail_Intimation_New  @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, 'Y', @Login_User, @Is_Error Out
			END
		END
		SELECT @Is_Error Is_Error
		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH				
		ROLLBACK TRANSACTION;
		SET @Is_Error = 'Y'
		DECLARE @ErrorMessage NVARCHAR(4000), @Error_Line NVARCHAR(4000)		
		SELECT @ErrorMessage  = ERROR_MESSAGE() ,@Error_Line = ERROR_LINE() 		
			SELECT  @ErrorMessage + ' ' + @Error_Line + '~' + IsNull(@Is_Error, '') AS  Is_Error
	END CATCH
END