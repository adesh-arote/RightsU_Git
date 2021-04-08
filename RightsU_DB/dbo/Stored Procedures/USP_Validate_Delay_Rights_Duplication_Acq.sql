CREATE PROCEDURE [dbo].[USP_Validate_Delay_Rights_Duplication_Acq]
AS
-- =============================================
-- Author:		Akshay Rane
-- Create DATE: 19-Februrary-2021
-- Description:	
-- =============================================
BEGIN
   SET NOCOUNT ON

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

	SELECT @DealCompleteFlag = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Deal_Complete_Flag'
	SET  @DealCompleteFlag = REPLACE(@DealCompleteFlag,' ','')

	DECLARE db_cursor CURSOR FOR 
	SELECT DISTINCT Deal_Rights_Code, Deal_Rights_Process_Code, Deal_Code FROM Deal_Rights_Process WHERE Record_Status = 'P' AND ISNULL(Rights_Bulk_Update_Code , 0) = 0

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Rights_Process_Code, @Deal_Code
	
	WHILE @@FETCH_STATUS = 0  
	BEGIN 	
		SELECT  @ErrorCount = 0, @RunPending = 0, @RightsPending = 0

		DELETE FROM #Tmp_Linear_Title_Status
		DELETE FROM Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

		INSERT INTO @Deal_Rights (
			Deal_Rights_Code, Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, Right_Type,Is_Tentative,
			Term, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Right_Start_Date, Right_End_Date
			)
		SELECT 
			0,Acq_Deal_Code,Is_Exclusive,Is_Title_Language_Right,Is_Sub_License,Sub_License_Code,Is_Theatrical_Right,Right_Type,Is_Tentative,
			Term,Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_ROFR,ROFR_Date,Restriction_Remarks,Right_Start_Date, Right_End_Date
		FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To )
		SELECT 0,Title_Code,Episode_From,Episode_To
		FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Platform (Deal_Rights_Code, Platform_Code)
		SELECT 0, Platform_Code FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Territory (Deal_Rights_Code, Territory_Type, Territory_Code, Country_Code)
		SELECT 0, Territory_Type, Territory_Code, Country_Code
		FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Subtitling (Deal_Rights_Code, Language_Type, Language_Group_Code, Subtitling_Code)
		SELECT 0, Language_Type, Language_Group_Code, Language_Code
		FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Dubbing (Deal_Rights_Code, Language_Type, Language_Group_Code, Dubbing_Code)
		SELECT 0, Language_Type, Language_Group_Code, Language_Code
		FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		IF((SELECT COUNT(*) From Deal_Rights_Process WHERE ISNULL(Rights_Bulk_Update_Code , 0) = 0 AND Record_Status = 'W') = 0)
		BEGIN

			UPDATE Deal_Rights_Process SET Record_Status = 'W', Process_Start = GETDATE(), Porcess_End = NULL, Error_Messages= NULL WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code
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

				IF((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_Acq_rights_delay_validation') = 'Y')
				BEGIN
					 UPDATE Deal_Rights_Process SET Porcess_End = GETDATE(), Error_Messages = ERROR_MESSAGE(), Record_Status = 'E'
					 WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code AND Record_Status = 'W'

					 UPDATE Acq_Deal_Rights set Right_Status = 'E' WHERE Acq_Deal_Rights_Code = (SELECT Deal_Rights_Code FROM Deal_Rights_Process WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code)
				 END

			END CATCH
			
			SELECT @ErrorCount = COUNT(*) FROM #Tmp_Validate_Rights_Duplication

			IF (@ErrorCount = 0)
			BEGIN
					IF(SELECT Record_Status FROM Deal_Rights_Process  WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code ) <> 'E'
					BEGIN
						UPDATE Deal_Rights_Process SET Record_Status = 'D', Porcess_End = GETDATE() WHERE Record_Status = 'W' AND Deal_Rights_Process_Code = @Deal_Rights_Process_Code
						UPDATE Acq_Deal_Rights SET Right_Status = 'C' WHERE Right_Status = 'W' AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
						--Check Linear Status
						BEGIN

							INSERT INTO #Tmp_Linear_Title_Status (Title_Name, Title_Added, Runs_Added)
							EXEC USP_List_Acq_Linear_Title_Status @Deal_Code

							SELECT @RunPending = COUNT(*) FROM #Tmp_Linear_Title_Status WHERE Title_Added = 'Yes~'
							SELECT @RightsPending =  COUNT(*) FROM #Tmp_Linear_Title_Status WHERE Title_Added = 'No'
							SELECT @RunPending = CASE WHEN @DealCompleteFlag = 'R,R' OR @DealCompleteFlag = 'R,R,C' THEN @RunPending ELSE 0 END

							UPDATE Acq_Deal SET Deal_Workflow_Status = 
							CASE WHEN @RunPending > 0 AND @RightsPending > 0 THEN 'RR' 
								 WHEN @RunPending > 0 AND @RightsPending = 0 THEN 'RP' 
								 ELSE 'N' END
							WHERE  Acq_Deal_Code = @Deal_Code 

						END
					END
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

				 UPDATE Deal_Rights_Process SET Record_Status = 'E', Porcess_End = GETDATE() WHERE Record_Status = 'W' AND Deal_Rights_Process_Code = @Deal_Rights_Process_Code
				 UPDATE Acq_Deal_Rights SET Right_Status = 'E' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
			END		
		END

		FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Rights_Process_Code, @Deal_Code
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 
END


--select * from @Deal_Rights 
--select * from @Deal_Rights_Title 
--select * from @Deal_Rights_Platform
--select * from @Deal_Rights_Territory 
--select * from @Deal_Rights_Subtitling
--select * from @Deal_Rights_Dubbing 
--select * from Deal_Rights_Process
