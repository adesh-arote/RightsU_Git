CREATE  PROCEDURE [dbo].[USP_Assign_Workflow](
	@Record_Code Int,
	@Module_Code Int,
	@Login_User Int, 
	@Remarks_Approval NVARCHAR(MAX)  = Null
)
AS
BEGIN	
--DECLARE
--	@Record_Code Int,
--	@Module_Code Int,
--	@Login_User Int, 
--	@Remarks_Approval NVARCHAR(MAX)  = Null


	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Assign_Workflow]', 'Step 1', 0, 'Started Procedure', 0, ''
	INSERT INTO QueryTest(Sql_SELECT)
	SELECT 'USP_Assign_Workflow: RecordCode: '+CAST(@Record_Code AS VARCHAR)+ ' ModuleCode: '+ CAST(@Module_Code AS varchar)+ ' Login: '+CAST(@Login_User AS VARCHAR)
	--DECLARE
	--	@Record_Code Int =  19606,
	--	@Module_Code Int = 30,
	--	@Login_User Int = 136,
	--	@Remarks_Approval NVARCHAR(MAX)  = 'ok'

		SET FMTONLY OFF	

		DECLARE 
				@BU_Code INT = 0, @Remarks NVARCHAR(MAX) = '', @Is_Email_Required VARCHAR(5) = '', @Error_Desc NVARCHAR(1000) = '',
				@Created_By INT= 0, @Created_Date DATETIME = '' ,@Last_Action_By INT = 0, @Last_Updated_Date DATETIME = '',@Version_No INT=1

		DECLARE @Waiting_Archive CHAR(2) = NULL, @AgreementNo NVARCHAR(MAX) = ''


		SELECT @Is_Email_Required = ISNULL(Is_Email_Required, 'N') FROM System_Param (NOLOCK)
				IF(@Module_Code = 30)
				BEGIN
					SELECT 
					@Version_No=CAST  ([Version] as INT)
					FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					SELECT 
					@Version_No=CAST  ([Version] as INT)
					FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 163)
				BEGIN
					SELECT 
					@Version_No=CAST  ([Version] as INT)
					FROM Music_Deal (NOLOCK) WHERE Music_Deal_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 262)
				BEGIN
					SELECT 
					@Version_No=CAST  ([Version_No] as INT)
					FROM AL_Recommendation (NOLOCK) WHERE AL_Recommendation_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 265)
				BEGIN
					SELECT 
					@Version_No= 1
					FROM AL_Purchase_Order (NOLOCK) WHERE AL_Purchase_Order_Code = @Record_Code
				END

		IF(@Module_Code = 30)
		BEGIN
			SELECT 
				@BU_Code = Business_Unit_Code, @Remarks = Remarks, 
				@Created_By = Inserted_By, @Created_Date = Inserted_On,
				@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
			FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @Record_Code
		END
		ELSE IF(@Module_Code = 35)
		BEGIN
			SELECT 
				@BU_Code = Business_Unit_Code, @Remarks = Remarks,
				@Created_By = Inserted_By, @Created_Date = Inserted_On,
				@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
			FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @Record_Code
		END
		ELSE IF(@Module_Code = 154)
		BEGIN
			SELECT DISTINCT
				@Remarks = MST.Remarks, @BU_Code = AD.Business_Unit_Code,
				@Created_By=MST.Inserted_By,@Created_Date=MST.Inserted_On
			FROM Music_Schedule_Transaction AS MST (NOLOCK)
				INNER JOIN BV_Schedule_Transaction AS BST (NOLOCK) ON BST.BV_Schedule_Transaction_Code= MST.BV_Schedule_Transaction_Code
				--INNER JOIN Acq_Deal_Movie AS ADM ON ADM.Acq_Deal_Movie_Code = BST.Deal_Movie_Code
				INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Content_Channel_Run_Code = BST.Content_Channel_Run_Code
				INNER JOIN Acq_Deal AS AD (NOLOCK) ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
			WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND MST.Music_Schedule_Transaction_Code=@Record_Code
		END
		ELSE IF(@Module_Code = 163)
		BEGIN
			SELECT 
				@BU_Code = Business_Unit_Code, @Remarks = Remarks,
				@Created_By = Inserted_By, @Created_Date = Inserted_On,
				@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
			FROM Music_Deal (NOLOCK) WHERE Music_Deal_Code = @Record_Code
		END
		ELSE IF(@Module_Code = 262)
		BEGIN
			SELECT 
				@BU_Code = 1,--Business_Unit_Code, 
				@Remarks = Remarks,
				@Created_By = Inserted_By, @Created_Date = Inserted_On,
				@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
			FROM AL_Recommendation (NOLOCK) WHERE AL_Recommendation_Code = @Record_Code
		END
		ELSE IF(@Module_Code = 265)
		BEGIN
			SELECT 
				@BU_Code = 1,--Business_Unit_Code, 
				@Remarks = Remarks,
				@Created_By = Inserted_By, @Created_Date = Inserted_On,
				@Last_Action_By = ISNULL(Inserted_By, 0), @Last_Updated_Date = ISNULL(Inserted_On, '') 
			FROM AL_Purchase_Order (NOLOCK) WHERE AL_Purchase_Order_Code = @Record_Code
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
		SELECT @Module_Code, @Record_Code, Security_Group_Code, Users_Code, 0, 'Y' FROM Users (NOLOCK) WHERE Users_Code = @Login_User

		INSERT INTO #Temp
		SELECT 
			@Module_Code, @Record_Code, Group_Code, (SELECT TOP 1 U.Users_Code FROM Users U (NOLOCK) WHERE U.Security_Group_Code = Group_Code), 
			ROW_NUMBER() OVER(ORDER BY Group_Level), 'N'
		FROM Workflow_Module_Role  (NOLOCK)
		WHERE Workflow_Module_Code IN (
			SELECT Workflow_Module_Code FROM Workflow_Module (NOLOCK) 
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

			INSERT INTO Module_Workflow_Detail
			(
				Module_Code, Record_Code, Group_Code, Primary_User_Code, Role_Level, Is_Done, Next_Level_Group, Entry_Date
			)

			SELECT T1.Module_Code, T1.Record_Code, T1.Group_Code, T1.Primary_User_Code, T1.Id - 1, T1.Is_Done, T2.Group_Code, GETDATE() Entry_Date
			FROM #Temp T1
			LEFT OUTER JOIN #Temp T2 ON T1.Id + 1 = T2.Id

			DECLARE @Is_Active CHAR(1) = 'Y'

			DECLARE @Is_Error1 CHAR(1), @Module_Workflow_Detail_Code INT = 0

			DECLARE @IsZeroLevel INT = 0
			SELECT @IsZeroLevel = COUNT(*) FROM #Temp

			DECLARE @Workflow_Code_AR_WA INT = 0
			SELECT @Workflow_Code_AR_WA = Workflow_Code FROM Workflow_Module  (NOLOCK)
			WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
			AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
	
			IF(@IsZeroLevel = 1)
			BEGIN
				IF(@Workflow_Code_AR_WA = 0)
						SET @Workflow_Code_AR_WA = Null

				IF @Waiting_Archive = 'AR'
						SET @Is_Active = 'N' 

				INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
				SELECT @Module_Code, @Record_Code, @Waiting_Archive, @Login_User, GETDATE(), RIGHT(@Remarks_Approval, LEN(@Remarks_Approval) - 3),@Version_No

				IF(@Module_Code = 30)
				BEGIN
						UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA ,Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code

						SELECT @AgreementNo = Agreement_No FROM Acq_Deal (NOLOCK)  WHERE Acq_Deal_Code = @Record_Code

						UPDATE AD SET AD.Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() FROM Acq_Deal AD WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'
			
						SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail (NOLOCK) WHERE Record_Code = @Record_Code and Module_Code = 30

						INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
						SELECT @Record_Code, 'A', 'P', GETDATE(), 'N', NULL

					END
				IF(@Module_Code = 35)
				BEGIN
						UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE()
						WHERE Syn_Deal_Code = @Record_Code

						SELECT @AgreementNo = Agreement_No FROM Syn_Deal (NOLOCK)  WHERE Syn_Deal_Code = @Record_Code

			
						SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail (NOLOCK) WHERE Record_Code = @Record_Code and Module_Code = 35
				
						DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Code = @Record_Code

						INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
						SELECT DISTINCT Syn_Deal_Code, 'S', 'P', GETDATE(), 'D', Syn_Deal_Rights_Code FROM Syn_Deal_Rights (NOLOCK) WHERE Syn_Deal_Code = @Record_Code

	
					END
			END
			ELSE 
			BEGIN
				--INSERT INTO MSH TABLE
				INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
				SELECT @Module_Code, @Record_Code, @Waiting_Archive, @Login_User, GETDATE(), RIGHT(@Remarks_Approval, LEN(@Remarks_Approval) - 3),@Version_No

				--UPDATE DEAL WORKFLOW STATUS OF ACQ DEAL TABLE
	
				IF @Module_Code = 30
				BEGIN
						UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code
						SELECT @AgreementNo = Agreement_No FROM Acq_Deal (NOLOCK)  WHERE Acq_Deal_Code = @Record_Code
						UPDATE AD SET Work_Flow_Code = @Workflow_Code_AR_WA, AD.Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() FROM Acq_Deal AD WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'
						SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail (NOLOCK) WHERE Record_Code = @Record_Code and Module_Code = 30
					END
				ELSE IF @Module_Code = 35
				BEGIN
						UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Syn_Deal_Code = @Record_Code
						SELECT @AgreementNo = Agreement_No FROM Syn_Deal (NOLOCK)  WHERE Syn_Deal_Code = @Record_Code
						SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail (NOLOCK) WHERE Record_Code = @Record_Code and Module_Code = 35
		
					END
			END

			EXEC USP_SendMail_Intimation_New  @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, @Waiting_Archive, @Login_User , @Is_Error1 Out

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
					FROM Module_Status_History (NOLOCK) 
					WHERE Record_Code = @Record_Code AND Module_Code = @Module_Code
					ORDER BY Status_Changed_On DESC

					IF(@Module_Status_History_Code = 0)
					BEGIN
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'C', @Created_By, @Created_Date, '' ,@Version_No
					END
					ELSE IF(@Status  = 'A')
					BEGIN
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'AM', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
					END		
					ELSE IF(@Status  = 'R')
					BEGIN
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'E', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
					END	
				END

				IF(@Module_Code IN (262))
				BEGIN
					DECLARE @Status_AL VARCHAR(2) = '', @Module_Status_History_Code_AL INT = 0		
					SELECT TOP 1 @Status_AL  = ISNULL([Status],''), @Module_Status_History_Code_AL = ISNULL(Record_Code, 0)
					FROM Module_Status_History (NOLOCK) 
					WHERE Record_Code = @Record_Code AND Module_Code = @Module_Code
					ORDER BY Status_Changed_On DESC

					--IF(@Module_Status_History_Code_AL = 0)
					--BEGIN
					--	INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
					--	SELECT @Module_Code, @Record_Code, 'C', @Created_By, @Created_Date, '' ,@Version_No
					--END
					--ELSE 
					IF(@Status_AL  = 'A')
					BEGIN
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'E', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
					END		
					ELSE IF(@Status_AL  = 'R')
					BEGIN
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'E', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
					END	
				END

				IF(@Module_Code IN (265))
				BEGIN
					DECLARE @Status_AL_PO VARCHAR(2) = '', @Module_Status_History_Code_AL_PO INT = 0		
					SELECT TOP 1 @Status_AL_PO  = ISNULL([Status],''), @Module_Status_History_Code_AL_PO = ISNULL(Record_Code, 0)
					FROM Module_Status_History (NOLOCK) 
					WHERE Record_Code = @Record_Code AND Module_Code = @Module_Code
					ORDER BY Status_Changed_On DESC

					--IF(@Module_Status_History_Code_AL = 0)
					--BEGIN
					--	INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
					--	SELECT @Module_Code, @Record_Code, 'C', @Created_By, @Created_Date, '' ,@Version_No
					--END
					--ELSE 
					IF(@Status_AL_PO  = 'A')
					BEGIN
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'E', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
					END		
					ELSE IF(@Status_AL_PO  = 'R')
					BEGIN
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'E', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
					END	
				END

				DECLARE @Cnt INT = 0
				SELECT @Cnt = COUNT(*) FROM #Temp

				DECLARE @Workflow_Code INT = 0
				SELECT @Workflow_Code = Workflow_Code FROM Workflow_Module (NOLOCK) 
				WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
				AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
	
				DECLARE @Is_Error CHAR(1) =''
				IF(@Cnt = 1)
				BEGIN
					IF(@Workflow_Code = 0)
						SET @Workflow_Code = Null
	
					IF(@Module_Code = 30)
					BEGIN
						UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A'--, Last_Updated_Time = GETDATE()
						WHERE Acq_Deal_Code = @Record_Code													
						--EXEC DBO.USP_Generate_Title_Content @Record_Code, '', @Login_User

						INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
						VALUES (@Record_Code,30, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)
						--EXEC DBO.USP_AT_Acq_Deal @Record_Code, @Is_Error 		
						SET @Is_Error = 'Y'		
					END
					ELSE IF(@Module_Code = 35)
					BEGIN
						Update Syn_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A'--, Last_Updated_Time = GETDATE() 
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
					ELSE IF(@Module_Code = 262)
					BEGIN
						Update AL_Recommendation SET Workflow_Code = @Workflow_Code, Workflow_Status = 'A', Last_Action_By = @Login_User--, Last_Updated_Time = GETDATE() 
						WHERE AL_Recommendation_Code = @Record_Code
						
					END	
					ELSE IF(@Module_Code = 265)
					BEGIN
						Update AL_Purchase_Order SET Workflow_Code = @Workflow_Code, Workflow_Status = 'A'--, Last_Updated_Time = GETDATE() 
						WHERE AL_Purchase_Order_Code = @Record_Code
						
					END	

					IF(@Module_Code IN (30, 35, 163, 262, 265))
					BEGIN    
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)    
						SELECT @Module_Code, @Record_Code, 'A', @Login_User, GetDate(), @Remarks_Approval ,@Version_No 
						SET @Is_Error = 'N'    
					END   

					IF(@Module_Code = 154)
					BEGIN
						UPDATE Music_Schedule_Transaction SET Workflow_Status = 'A' 
						WHERE Music_Schedule_Transaction_Code = @Record_Code

						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
						SELECT @Module_Code, @Record_Code, 'A', @Login_User, GetDate(), @Remarks,@Version_No
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
					ELSE IF(@Module_Code = 262)
					BEGIN
						UPDATE AL_Recommendation SET Workflow_Code = @Workflow_Code, Workflow_Status = 'W', Last_Action_By = @Login_User WHERE AL_Recommendation_Code = @Record_Code
					END
					ELSE IF(@Module_Code = 265)
					BEGIN
						UPDATE AL_Purchase_Order SET Workflow_Code = @Workflow_Code, Workflow_Status = 'W' WHERE AL_Purchase_Order_Code = @Record_Code
					END

					IF(@Module_Code IN (30, 35, 163, 262, 265))
					BEGIN    
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)    
						Select @Module_Code, @Record_Code, 'W', @Login_User, GetDate(), @Remarks_Approval ,@Version_No 
						SET @Is_Error = 'N'    
					END    
   
					IF(@Module_Code = 154)    
					BEGIN
						UPDATE Music_Schedule_Transaction SET Workflow_Status = 'W' 
						WHERE Music_Schedule_Transaction_Code = @Record_Code    
   
						INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)    
						SELECT @Module_Code, @Record_Code, 'W', @Login_User, GetDate(), @Remarks,@Version_No 
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

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Assign_Workflow]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END