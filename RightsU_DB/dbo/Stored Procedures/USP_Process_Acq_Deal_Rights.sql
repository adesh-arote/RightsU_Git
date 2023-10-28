CREATE PROCEDURE [dbo].[USP_Process_Acq_Deal_Rights]
As
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Process_Acq_Deal_Rights]', 'Step 1', 0, 'Started Procedure', 0, ''

		IF OBJECT_ID('tempdb..#Tmp_Validate_Rights_Duplication') IS NOT NULL 
			DROP TABLE #Tmp_Validate_Rights_Duplication

		IF OBJECT_ID('tempdb..#Tmp_Linear_Title_Status') IS NOT NULL 
			DROP TABLE #Tmp_Linear_Title_Status

	   DECLARE 
   		@Deal_Rights Deal_Rights ,
		@Deal_Rights_Title Deal_Rights_Title  ,
		@Deal_Rights_Platform Deal_Rights_Platform ,
		@Deal_Rights_Territory Deal_Rights_Territory ,
		@Deal_Rights_Subtitling Deal_Rights_Subtitling ,
		@Deal_Rights_Dubbing Deal_Rights_Dubbing 

		CREATE TABLE #Tmp_Linear_Title_Status
		(
			Id INT IDENTITY(1,1),
			Title_Name NVARCHAR(MAX),
			Title_Added NVARCHAR(MAX),
			Runs_Added NVARCHAR(MAX)
		)

		CREATE TABLE #Tmp_Validate_Rights_Duplication
		(
			Acq_Deal_Rights_Code INT,
			Title_Name NVARCHAR(MAX),
			Platform_Name NVARCHAR(MAX),
			Right_Start_Date DATETIME,
			Right_End_Date DATETIME,
			Right_Type NVARCHAR(MAX),
			Is_Sub_License NVARCHAR(MAX),
			Is_Title_Language_Right NVARCHAR(MAX),
			Country_Name NVARCHAR(MAX),
			Subtitling_Language NVARCHAR(MAX),
			Dubbing_Language NVARCHAR(MAX),
			Agreement_No NVARCHAR(MAX),
			ErrorMSG NVARCHAR(MAX),
			Episode_From INT,
			Episode_To INT
		)

   		DECLARE @Acq_Deal_Rights_Code INT = 0, @Deal_Rights_Process_Code INT = 0, @ErrorCount INT = 0, @Deal_Code INT = 0
		DECLARE @RunPending INT, @RightsPending INT ,@DealCompleteFlag NVARCHAR(MAX)=''

		DECLARE db_cursor CURSOR FOR 
		SELECT distinct Acq_Deal_Rights_Code, Acq_Deal_Code FROM Acq_Deal_Rights (NOLOCK) WHERE Right_Status = 'P'
	
		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Code
	
		WHILE @@FETCH_STATUS = 0  
		BEGIN 	
			SELECT  @ErrorCount = 0, @RunPending = 0, @RightsPending = 0
		
			TRUNCATE TABLE #Tmp_Validate_Rights_Duplication 
			DELETE FROM #Tmp_Linear_Title_Status
			DELETE FROM Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			DELETE FROM @Deal_Rights
			DELETE FROM @Deal_Rights_Dubbing
			DELETE FROM @Deal_Rights_Platform
			DELETE FROM @Deal_Rights_Subtitling
			DELETE FROM @Deal_Rights_Territory
			DELETE FROM @Deal_Rights_Title

			INSERT INTO @Deal_Rights (
				Deal_Rights_Code, Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, Right_Type,Is_Tentative,
				Term, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Right_Start_Date, Right_End_Date,
				BuyBack_Syn_Rights_Code
				)
			SELECT 
				Acq_Deal_Rights_Code, Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, Right_Type,Is_Tentative,
				Term, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Right_Start_Date, Right_End_Date,
				BuyBack_Syn_Rights_Code
			FROM Acq_Deal_Rights (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			------------------------------------
			INSERT INTO @Deal_Rights_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To )
			SELECT @Acq_Deal_Rights_Code,Title_Code,Episode_From,Episode_To
			FROM Acq_Deal_Rights_Title (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			------------------------------------
			INSERT INTO @Deal_Rights_Platform (Deal_Rights_Code, Platform_Code)
			SELECT @Acq_Deal_Rights_Code, Platform_Code FROM Acq_Deal_Rights_Platform (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			------------------------------------
			INSERT INTO @Deal_Rights_Territory (Deal_Rights_Code, Territory_Type, Territory_Code, Country_Code)
			SELECT @Acq_Deal_Rights_Code, Territory_Type, Territory_Code, Country_Code
			FROM Acq_Deal_Rights_Territory (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			------------------------------------
			INSERT INTO @Deal_Rights_Subtitling (Deal_Rights_Code, Language_Type, Language_Group_Code, Subtitling_Code)
			SELECT @Acq_Deal_Rights_Code, Language_Type, Language_Group_Code, Language_Code
			FROM Acq_Deal_Rights_Subtitling (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			------------------------------------
			INSERT INTO @Deal_Rights_Dubbing (Deal_Rights_Code, Language_Type, Language_Group_Code, Dubbing_Code)
			SELECT @Acq_Deal_Rights_Code, Language_Type, Language_Group_Code, Language_Code
			FROM Acq_Deal_Rights_Dubbing (NOLOCK) WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
			------------------------------------
			IF((SELECT COUNT(*) From Deal_Rights_Process (NOLOCK) WHERE ISNULL(Rights_Bulk_Update_Code , 0) = 0 AND Record_Status = 'W') = 0)
			BEGIN

				UPDATE Acq_Deal_Rights SET Right_Status = 'W' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				BEGIN TRY
				BEGIN TRANSACTION 
					INSERT INTO #Tmp_Validate_Rights_Duplication
					(
						Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
						Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To 
					)
					EXECUTE USP_Validate_Rights_Duplication_UDT_ACQ
						 @Deal_Rights ,@Deal_Rights_Title ,@Deal_Rights_Platform ,@Deal_Rights_Territory ,@Deal_Rights_Subtitling ,@Deal_Rights_Dubbing ,'AR','N',@Deal_Rights_Process_Code
				COMMIT
				END TRY
				BEGIN CATCH
						ROLLBACK

						 UPDATE Acq_Deal_Rights set Right_Status = 'E' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				END CATCH
			
				SELECT @ErrorCount = COUNT(*) FROM #Tmp_Validate_Rights_Duplication

				IF (@ErrorCount = 0)
				BEGIN
					UPDATE Acq_Deal_Rights SET Right_Status = 'C' WHERE Right_Status = 'W' AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				END
				ELSE IF (@ErrorCount > 0)
				BEGIN
				
					 UPDATE #Tmp_Validate_Rights_Duplication SET Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				 
					 INSERT INTO Acq_Deal_Rights_Error_Details
					 (
				 		 Acq_Deal_Rights_Code, Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
				 		Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To, Is_Updated , Inserted_On 
					 )
					 SELECT DISTINCT  Acq_Deal_Rights_Code, Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
				 		Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To,'N', GETDATE() 
					 FROM #Tmp_Validate_Rights_Duplication

					 UPDATE Acq_Deal_Rights SET Right_Status = 'E' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
				END		
			END

			FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Code
		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor 

		DROP TABLE #Tmp_Validate_Rights_Duplication

		DROP TABLE #Tmp_Linear_Title_Status

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Process_Acq_Deal_Rights]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END