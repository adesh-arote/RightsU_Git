

ALTER PROC [dbo].[USP_Process_Workflow]
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

		IF (@User_Action != 'AR')
		BEGIN
			INSERT INTO Module_Status_History(Module_Code, Record_Code, [Status], Status_Changed_By, Status_Changed_On, Remarks)
			SELECT @Module_Code, @Record_Code, @User_Action, @Login_User, GetDate(), @Remarks
		END

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

				--EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT
				INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,35, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)

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
		ELSE IF(@User_Action = 'AR')
		BEGIN
			IF(@Next_Level_Group = 0)
				SET @User_Action = 'AR'
			ELSE
				SET @User_Action = 'WA'
	
			INSERT INTO Module_Status_History(Module_Code, Record_Code, [Status], Status_Changed_By, Status_Changed_On, Remarks)
			SELECT @Module_Code, @Record_Code, @User_Action, @Login_User, GetDate(), @Remarks

			IF(@Module_Code = 30)
			BEGIN
				DECLARE @AgreementNo NVARCHAR(MAX)
				UPDATE Acq_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code

				SELECT @AgreementNo = Agreement_No FROM Acq_Deal  WHERE Acq_Deal_Code = @Record_Code

				UPDATE AD SET AD.Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() 
				FROM Acq_Deal AD 
				WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'

				IF @User_Action = 'AR'
				BEGIN
				
					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT @Record_Code, 'A', 'P', GETDATE(), 'N', NULL

				END

			END
			IF(@Module_Code = 35)
			BEGIN
				UPDATE Syn_Deal Set Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() Where Syn_Deal_Code = @Record_Code

				IF @User_Action = 'AR'
				BEGIN
					
					DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Code = @Record_Code

					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT DISTINCT Syn_Deal_Code, 'S', 'P', GETDATE(), 'D', Syn_Deal_Rights_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @Record_Code

				END
			END
			
			IF(@Is_Email_Required = 'Y')
			BEGIN
				EXEC USP_SendMail_To_NextApprover_New @Record_Code, @Module_Code, 'Y', 'Y', @Is_Error Out
				EXEC USP_SendMail_Intimation_New @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, 'Y', @Login_User, @Is_Error Out
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
					--EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT
					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,35, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)


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
				EXEC USP_SendMail_Intimation_New @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, 'Y', @Login_User, @Is_Error Out
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
GO


ALTER  PROCEDURE [dbo].[USP_Assign_Workflow](
	@Record_Code Int,
	@Module_Code Int,
	@Login_User Int, 
	@Remarks_Approval NVARCHAR(MAX) = Null
)
AS
BEGIN	
	SET FMTONLY OFF	

	DECLARE 
			@BU_Code INT = 0, @Remarks NVARCHAR(MAX) = '', @Is_Email_Required VARCHAR(5) = '', @Error_Desc NVARCHAR(1000) = '',
			@Created_By INT= 0, @Created_Date DATETIME = '' ,@Last_Action_By INT = 0, @Last_Updated_Date DATETIME = '', @Is_Error CHAR(1) =''

	DECLARE @Waiting_Archive CHAR(2) = NULL, @AgreementNo NVARCHAR(MAX) = ''


	SELECT @Is_Email_Required = ISNULL(Is_Email_Required, 'N') FROM System_Param

	IF(@Module_Code = 30)
	BEGIN
		SELECT 
			@BU_Code = Business_Unit_Code, @Remarks = Remarks, 
			@Created_By = Inserted_By, @Created_Date = Inserted_On,
			@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
		FROM Acq_Deal WHERE Acq_Deal_Code = @Record_Code
	END
	ELSE IF(@Module_Code = 35)
	BEGIN
		SELECT 
			@BU_Code = Business_Unit_Code, @Remarks = Remarks,
			@Created_By = Inserted_By, @Created_Date = Inserted_On,
			@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
		FROM Syn_Deal WHERE Syn_Deal_Code = @Record_Code
	END
	ELSE IF(@Module_Code = 154)
	BEGIN
		SELECT DISTINCT
			@Remarks = MST.Remarks, @BU_Code = AD.Business_Unit_Code,
			@Created_By=MST.Inserted_By,@Created_Date=MST.Inserted_On
		FROM Music_Schedule_Transaction AS MST
			INNER JOIN BV_Schedule_Transaction AS BST ON BST.BV_Schedule_Transaction_Code= MST.BV_Schedule_Transaction_Code
			--INNER JOIN Acq_Deal_Movie AS ADM ON ADM.Acq_Deal_Movie_Code = BST.Deal_Movie_Code
			INNER JOIN Content_Channel_Run CCR ON CCR.Content_Channel_Run_Code = BST.Content_Channel_Run_Code
			INNER JOIN Acq_Deal AS AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
		WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND MST.Music_Schedule_Transaction_Code=@Record_Code
	END
	ELSE IF(@Module_Code = 163)
	BEGIN
		SELECT 
			@BU_Code = Business_Unit_Code, @Remarks = Remarks,
			@Created_By = Inserted_By, @Created_Date = Inserted_On,
			@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
		FROM Music_Deal WHERE Music_Deal_Code = @Record_Code
	END

	CREATE TABLE #Temp
	(
		Id INT IDENTITY(1, 1),
		Module_Code INT,
		Record_Code INT,
		Group_Code INT,
		Primary_User_Code INT,
		Role_Level INT,
		Is_Done VARCHAR(10) DEFAULT 'N'
	)

	INSERT INTO #Temp
	SELECT @Module_Code, @Record_Code, Security_Group_Code, Users_Code, 0, 'Y' FROM Users WHERE Users_Code = @Login_User

	INSERT INTO #Temp
	SELECT 
		@Module_Code, @Record_Code, Group_Code, (SELECT TOP 1 U.Users_Code FROM Users U WHERE U.Security_Group_Code = Group_Code), 
		ROW_NUMBER() OVER(ORDER BY Group_Level), 'N'
	FROM Workflow_Module_Role 
	WHERE Workflow_Module_Code IN (
		SELECT Workflow_Module_Code FROM Workflow_Module 
		WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
		AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
	)

	-- CHECKING IF REMARKS APROVAL STARTS WITH 'WA~'
	IF (SELECT COUNT(*) FROM DBO.fn_Split_withdelemiter(@Remarks_Approval, '~')) > 1
		SELECT top 1 @Waiting_Archive = number FROM DBO.fn_Split_withdelemiter(@Remarks_Approval, '~')
	
	IF(ISNULL(@Waiting_Archive,'') = 'WA' OR ISNULL(@Waiting_Archive,'') = 'AR' )
	BEGIN
		

		--Create level wise rows in MWD
		DELETE FROM Module_Workflow_Detail WHERE Module_Code = @Module_Code And Record_Code = @Record_Code

		INSERT INTO Module_Workflow_Detail(Module_Code, Record_Code, Group_Code, Primary_User_Code, Role_Level, Is_Done, Next_Level_Group, Entry_Date)
		SELECT T1.Module_Code, T1.Record_Code, T1.Group_Code, T1.Primary_User_Code, T1.Id - 1, T1.Is_Done, T2.Group_Code, GETDATE() Entry_Date
		FROM #Temp T1
		LEFT OUTER JOIN #Temp T2 ON T1.Id + 1 = T2.Id

		DECLARE @Is_Active CHAR(1) = 'Y'

		DECLARE @Is_Error1 CHAR(1), @Module_Workflow_Detail_Code INT = 0

		DECLARE @IsZeroLevel INT = 0
		SELECT @IsZeroLevel = COUNT(*) FROM #Temp

		DECLARE @Workflow_Code_AR_WA INT = 0
		SELECT @Workflow_Code_AR_WA = Workflow_Code FROM Workflow_Module 
		WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
		AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
		
		IF(@IsZeroLevel = 1)
		BEGIN
			IF(@Workflow_Code_AR_WA = 0)
					SET @Workflow_Code_AR_WA = Null

			IF @Waiting_Archive = 'AR'
					SET @Is_Active = 'N' 

			INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks)
			SELECT @Module_Code, @Record_Code, @Waiting_Archive, @Login_User, GETDATE(), RIGHT(@Remarks_Approval, LEN(@Remarks_Approval) - 3)

			IF(@Module_Code = 30)
			BEGIN
					UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA ,Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code

					SELECT @AgreementNo = Agreement_No FROM Acq_Deal  WHERE Acq_Deal_Code = @Record_Code

					UPDATE AD SET AD.Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() FROM Acq_Deal AD WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'
				
					SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 30

					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT @Record_Code, 'A', 'P', GETDATE(), 'N', NULL

				END
			IF(@Module_Code = 35)
			BEGIN
					UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE()
					WHERE Syn_Deal_Code = @Record_Code

					SELECT @AgreementNo = Agreement_No FROM Syn_Deal  WHERE Syn_Deal_Code = @Record_Code

				
					SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 35
					
					DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Code = @Record_Code

					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT DISTINCT Syn_Deal_Code, 'S', 'P', GETDATE(), 'D', Syn_Deal_Rights_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @Record_Code

		
				END
		END
		ELSE 
		BEGIN
			--INSERT INTO MSH TABLE
			INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks)
			SELECT @Module_Code, @Record_Code, @Waiting_Archive, @Login_User, GETDATE(), RIGHT(@Remarks_Approval, LEN(@Remarks_Approval) - 3)

			--UPDATE DEAL WORKFLOW STATUS OF ACQ DEAL TABLE
		
			IF @Module_Code = 30
			BEGIN
				
				UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code
				SELECT @AgreementNo = Agreement_No FROM Acq_Deal  WHERE Acq_Deal_Code = @Record_Code
				UPDATE AD SET Work_Flow_Code = @Workflow_Code_AR_WA, AD.Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() FROM Acq_Deal AD WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'
				SELECT @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 30

			END
			ELSE IF @Module_Code = 35
			BEGIN
				
				UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Syn_Deal_Code = @Record_Code
				SELECT @AgreementNo = Agreement_No FROM Syn_Deal  WHERE Syn_Deal_Code = @Record_Code
				SELECT @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 35
			
			END

			--EXEC USP_SendMail_Intimation_New  @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, @Waiting_Archive, @Login_User , @Is_Error1 Out
			IF(@Is_Email_Required = 'Y')
				EXEC DBO.USP_SendMail_To_NextApprover_New @Record_Code, @Module_Code, 'Y', 'Y', @Is_Error 

		END

		SELECT 'N' Is_Error	
	END
	ELSE
	BEGIN
		BEGIN TRY	
			BEGIN TRAN				

			DELETE FROM Module_Workflow_Detail WHERE Module_Code = @Module_Code And Record_Code = @Record_Code

			INSERT INTO Module_Workflow_Detail
			(
				Module_Code, Record_Code, Group_Code, Primary_User_Code, Role_Level, Is_Done, Next_Level_Group, Entry_Date
			)

			SELECT T1.Module_Code, T1.Record_Code, T1.Group_Code, T1.Primary_User_Code, T1.Id - 1, T1.Is_Done, T2.Group_Code, GETDATE() Entry_Date
			FROM #Temp T1
			LEFT OUTER JOIN #Temp T2 ON T1.Id + 1 = T2.Id

			IF(@Module_Code IN (30, 35, 163))
			BEGIN
				DECLARE @Status VARCHAR(2) = '', @Module_Status_History_Code INT = 0		
				SELECT TOP 1 @Status  = ISNULL([Status],''), @Module_Status_History_Code = ISNULL(Record_Code, 0)
				FROM Module_Status_History 
				WHERE Record_Code = @Record_Code AND Module_Code = @Module_Code
				ORDER BY Status_Changed_On DESC
	
				IF(@Module_Status_History_Code = 0)
				BEGIN
					INSERT INTO Module_Status_History
					SELECT @Module_Code, @Record_Code, 'C', @Created_By, @Created_Date, @Remarks
				END
				ELSE IF(@Status  = 'A')
				BEGIN
					INSERT INTO Module_Status_History
					SELECT @Module_Code, @Record_Code, 'AM', @Last_Action_By, @Last_Updated_Date, @Remarks
				END		
				ELSE IF(@Status  = 'R')
				BEGIN
					INSERT INTO Module_Status_History
					SELECT @Module_Code, @Record_Code, 'E', @Last_Action_By, @Last_Updated_Date, @Remarks
				END	
			END

			DECLARE @Cnt INT = 0
			SELECT @Cnt = COUNT(*) FROM #Temp

			DECLARE @Workflow_Code INT = 0
			SELECT @Workflow_Code = Workflow_Code FROM Workflow_Module 
			WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
			AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
		
			IF(@Cnt = 1)
			BEGIN
				IF(@Workflow_Code = 0)
					SET @Workflow_Code = Null
		
				IF(@Module_Code = 30)
				BEGIN
					UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A', Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code													
					--EXEC DBO.USP_Generate_Title_Content @Record_Code, '', @Login_User

					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,30, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)
					--EXEC DBO.USP_AT_Acq_Deal @Record_Code, @Is_Error 		
					SET @Is_Error = 'Y'		
				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					Update Syn_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A', Last_Updated_Time = GETDATE() 
					WHERE Syn_Deal_Code = @Record_Code
					--EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT

					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,35, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)

					DECLARE @StatusFlag VARCHAR(1), @ErrMessage VARCHAR(1)
					--EXEC DBO.USP_AutoPushAcqDeal @Record_Code, @Login_User, @StatusFlag OUT, @ErrMessage OUT
				END	
				ELSE IF(@Module_Code = 163)
				BEGIN
					Update Music_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A', Last_Updated_Time = GETDATE() 
					WHERE Music_Deal_Code = @Record_Code
					EXEC DBO.USP_AT_Music_Deal @Record_Code, @Is_Error OUT
				END	

				IF(@Module_Code IN (30, 35, 163))
				BEGIN    
					INSERT INTO Module_Status_History    
					SELECT @Module_Code, @Record_Code, 'A', @Login_User, GetDate(), @Remarks_Approval  
					SET @Is_Error = 'N'    
				END   

				IF(@Module_Code = 154)
				BEGIN
					UPDATE Music_Schedule_Transaction SET Workflow_Status = 'A' 
					WHERE Music_Schedule_Transaction_Code = @Record_Code

					INSERT INTO Module_Status_History
					SELECT @Module_Code, @Record_Code, 'A', @Login_User, GetDate(), @Remarks
					SET @Is_Error = 'N'	
				END
			END
			ELSE
			BEGIN
				IF(@Module_Code = 30)
				BEGIN
					UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'W' WHERE Acq_Deal_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'W' WHERE Syn_Deal_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 154)
				BEGIN
					UPDATE Music_Schedule_Transaction SET Workflow_Status = 'W' WHERE Music_Schedule_Transaction_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 163)
				BEGIN
					UPDATE Music_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'W' WHERE Music_Deal_Code = @Record_Code
				END

				IF(@Module_Code IN (30, 35, 163))
				BEGIN    
					INSERT INTO Module_Status_History    
					Select @Module_Code, @Record_Code, 'W', @Login_User, GetDate(), @Remarks_Approval  
					SET @Is_Error = 'N'    
				END    
    
				IF(@Module_Code = 154)    
				BEGIN
					UPDATE Music_Schedule_Transaction SET Workflow_Status = 'W' 
					WHERE Music_Schedule_Transaction_Code = @Record_Code    
    
					INSERT INTO Module_Status_History    
					SELECT @Module_Code, @Record_Code, 'W', @Login_User, GetDate(), @Remarks    
					SET @Is_Error = 'N'     
				END
				IF(@Is_Email_Required = 'Y')
					EXEC DBO.USP_SendMail_To_NextApprover_New @Record_Code, @Module_Code, 'Y', 'Y', @Is_Error 
			END		
			SELECT CAST(@Cnt AS VARCHAR) + '~' + ISNULL(@Is_Error, '') Is_Error		
			DROP TABLE #Temp
			COMMIT
		END TRY
		BEGIN CATCH				
			ROLLBACK;
			SET @Is_Error = 'Y'
			DECLARE @ErrorMessage NVARCHAR(4000),@Error_Line NVARCHAR(4000)		
			SELECT @ErrorMessage  = ERROR_MESSAGE() ,@Error_Line = ERROR_LINE() 		
			SELECT  @ErrorMessage + ' ' + @Error_Line + '~' + ISNULL(@Is_Error, '') Is_Error
		END CATCH	
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
END
GO

