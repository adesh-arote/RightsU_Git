alter PROCEDURE [dbo].[USP_Acq_Bulk_Update_Process]
(
	@Deal_Code INT,
	@User_Code INT,
	@Deal_Process_RBU_Code INT,
	@IsValid CHAR(1) OUTPUT
)
AS
-- =============================================
-- Author:		Akshay Rane
-- Create Date:	02-Feb-2019
-- Description:	Acquisition Deal Rights Bulk Update Optimization
-- =============================================
BEGIN
	SET NOCOUNT ON

	IF OBJECT_ID('tempdb..#Temp_Bulk_Update_Validation') IS NOT NULL
		DROP TABLE #Temp_Bulk_Update_Validation

	IF OBJECT_ID('tempdb..#Temp_Rights_Bulk_Update') IS NOT NULL
		DROP TABLE #Temp_Rights_Bulk_Update

	IF OBJECT_ID('tempdb..#Merge_Rights_Title_Map') IS NOT NULL
		DROP TABLE #Merge_Rights_Title_Map

	IF OBJECT_ID('tempdb..#Right_Title_Code') IS NOT NULL
		DROP TABLE #Right_Title_Code
	
	BEGIN TRY
	BEGIN TRANSACTION 
		DECLARE @Page_View CHAR(1), @RightCodes NVARCHAR(MAX), @TitleNames NVARCHAR(MAX), @TitleCodes NVARCHAR(MAX),@ErrorMSG NVARCHAR(MAX),
				@ChangeFor NVARCHAR(MAX), @IsTitleLanguage NVARCHAR(MAX)
		DECLARE @Right_Code INT, @Title_Code INT, @Is_Error CHAR(1)
		DECLARE @Rights_Bulk_Update_Code INT --, @Deal_Code INT
		DECLARE @Rights_Bulk_Update Rights_Bulk_Update_UDT
		DECLARE @NewAcq_Deal_Rights_Code INT

		CREATE TABLE #Merge_Rights_Title_Map(  Right_Code INT, Title_Code INT, Title_Name NVARCHAR(MAX), IsError CHAR(1) )
		CREATE TABLE #Temp_Bulk_Update_Validation (
		TBUV_Code INT IDENTITY(1,1),
		Rights_Code INT,
		Title_Name NVARCHAR(MAX),
		Platform_Name VARCHAR(MAX), 
		Right_Start_Date DateTime, 
		Right_End_Date DateTime,
		Right_Type VARCHAR(MAX),
		Is_Sub_License VARCHAR(MAX),
		Is_Title_Language_Right VARCHAR(MAX),
		Country_Name NVARCHAR(MAX),
		Subtitling_Language NVARCHAR(MAX),
		Dubbing_Language NVARCHAR(MAX),
		Agreement_No VARCHAR(MAX), 
		ErrorMSG VARCHAR(MAX), 
		Episode_From INT, 
		Episode_To INT,
		Is_Updated VARCHAR(2)
	)	
		CREATE TABLE #Right_Title_Code(Right_Code INT, New_Right_Code INT, Title_Code INT)
		CREATE TABLE #Temp_Rights_Bulk_Update( Rights_Bulk_Update_Code INT, Deal_Code INT )

		INSERT INTO #Temp_Rights_Bulk_Update (Rights_Bulk_Update_Code, Deal_Code)
		SELECT Rights_Bulk_Update_Code, Deal_Code FROM Rights_Bulk_Update WHERE Is_Processed = 'N' AND Deal_Code = @Deal_Code AND Rights_Bulk_Update_Code = @Deal_Process_RBU_Code

		PRINT 'Started 1st For Loop'
		DECLARE db_RBU_cursor CURSOR FOR 
		SELECT Rights_Bulk_Update_Code FROM #Temp_Rights_Bulk_Update

		OPEN db_RBU_cursor  
		FETCH NEXT FROM db_RBU_cursor INTO @Rights_Bulk_Update_Code

		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			 PRINT 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
			 PRINT 'Rights_Bulk_Update_Code = '+ CAST(@Rights_Bulk_Update_Code AS VARCHAR(MAX)) + ' Deal_Code = '+ CAST(@Deal_Code AS VARCHAR(MAX))
			 TRUNCATE TABLE #Temp_Bulk_Update_Validation
			 TRUNCATE TABLE #Merge_Rights_Title_Map
			 TRUNCATE TABLE #Right_Title_Code
			 DELETE FROM @Rights_Bulk_Update

			 --SELECT * FROM Rights_Bulk_Update  WHERE Rights_Bulk_Update_Code = @Rights_Bulk_Update_Code AND Deal_Code = @Deal_Code

			 SELECT @ChangeFor = Change_For,
					@IsTitleLanguage = Is_Title_Language,
					@Page_View = Page_View, 
					@RightCodes = Right_Codes, 
					@TitleNames = SelectedTitleNames, 
					@TitleCodes = SelectedTitleCodes
			 FROM Rights_Bulk_Update WHERE Rights_Bulk_Update_Code = @Rights_Bulk_Update_Code AND Deal_Code = @Deal_Code

			 PRINT 'Fill #Merge_Rights_Title_Map'
			 INSERT INTO #Merge_Rights_Title_Map (Right_Code, Title_Code, Title_Name, IsError)
			 SELECT A.number, B.number, C.number, 'N'
			 FROM		(SELECT id, number FROM dbo.[fn_Split_withdelemiter](@RightCodes,',') WHERE number!='') AS A
			 INNER JOIN	(SELECT  id, number FROM dbo.[fn_Split_withdelemiter](@TitleCodes,',') WHERE number!='') AS B ON B.id = A.id
			 INNER JOIN	(SELECT  id, number FROM dbo.[fn_Split_withdelemiter](@TitleNames,',') WHERE number!='') AS C ON A.id = C.id

			 UPDATE Deal_Rights_Process SET Record_Status = 'W', Process_Start = GETDATE()
			 WHERE Deal_Rights_Code IN (SELECT Right_Code FROM #Merge_Rights_Title_Map) AND Deal_Code = @Deal_Code AND Rights_Bulk_Update_Code = @Deal_Process_RBU_Code

			 UPDATE Acq_Deal_Rights SET Right_Status = 'W'
			 WHERE Acq_Deal_Rights_Code IN (SELECT Right_Code FROM #Merge_Rights_Title_Map) AND Acq_Deal_Code = @Deal_Code AND Right_Status = 'P'

			 
			 PRINT 'Page View Working for Both G and S ie Group and Summary'
				
			 --DELETE FROM @Rights_Bulk_Update
			 --TRUNCATE TABLE #Temp_Bulk_Update_Validation

			 INSERT INTO @Rights_Bulk_Update([Right_Codes], [Change_For], [Action_For], [Start_Date], [End_Date], [Term], [Milestone_Type_Code],
					[Milestone_No_Of_Unit], [Milestone_Unit_Type], [Rights_Type], [Codes], [Is_Exclusive], [Is_Title_Language], [Is_Tentative])
			 SELECT	Right_Codes + Is_Syn_Acq_Mapp, Change_For, Action_For, [Start_Date], End_Date, Term, Milestone_Type_Code,
					Milestone_No_Of_Unit, Milestone_Unit_Type, Rights_Type, Codes, Is_Exclusive, Is_Title_Language, Is_Tentative
			 FROM Rights_Bulk_Update WHERE Rights_Bulk_Update_Code = @Rights_Bulk_Update_Code AND Deal_Code = @Deal_Code

			 PRINT 'Executing USP_Acq_Bulk_Update procedure (Anchal)'
			 EXEC USP_Acq_Bulk_Update_Final @Rights_Bulk_Update, @User_Code

			 PRINT 'Inserting Error Record into #Temp_Bulk_Update_Validation'
			 IF @Page_View = 'S'
			 BEGIN
				INSERT INTO #Temp_Bulk_Update_Validation 
						(Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License,
						Is_Title_Language_Right, Country_Name, Subtitling_Language, Dubbing_Language, Agreement_No, ErrorMSG, Episode_From, Episode_To, Is_Updated)
				SELECT	Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License,
						Is_Title_Language_Right, Country_Name, Subtitling_Language, Dubbing_Language, Agreement_No, ErrorMSG, Episode_From, Episode_To, Is_Updated
				FROM 
						##Error_Record 
				WHERE  
						ISNULL(ErrorMSG,'') <> '' 
						AND Rights_Code  IN (SELECT Right_Code from #Merge_Rights_Title_Map) 
						AND Title_Name COLLATE DATABASE_DEFAULT	IN (SELECT Title_Name COLLATE DATABASE_DEFAULT FROM #Merge_Rights_Title_Map)
			 END
			 ELSE
			 BEGIN
				INSERT INTO #Temp_Bulk_Update_Validation 
						(Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License,
						Is_Title_Language_Right, Country_Name, Subtitling_Language, Dubbing_Language, Agreement_No, ErrorMSG, Episode_From, Episode_To, Is_Updated)
				SELECT	Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License,
						Is_Title_Language_Right, Country_Name, Subtitling_Language, Dubbing_Language, Agreement_No, ErrorMSG, Episode_From, Episode_To, Is_Updated
				FROM 
						##Error_Record 
				WHERE  
						ISNULL(ErrorMSG,'') <> '' 
			 END

			 IF OBJECT_ID('tempdb..##Error_Record') IS NOT NULL
					DROP TABLE ##Error_Record

			 PRINT 'Updating Is_Processed = Y'
			 UPDATE A SET A.Is_Processed = 'Y' FROM Rights_Bulk_Update A WHERE A.Rights_Bulk_Update_Code = @Rights_Bulk_Update_Code AND A.Deal_Code = @Deal_Code

			 PRINT 'Looping through Final error cursor'
			 DECLARE @TBUV_Code INT, @Message NVARCHAR(MAX) = ''
			 DECLARE db_ErrorMsgcursor CURSOR FOR 
			 SELECT DISTINCT TBUV_Code, ErrorMSG FROM #Temp_Bulk_Update_Validation
			 
			 OPEN db_ErrorMsgcursor  
			 FETCH NEXT FROM db_ErrorMsgcursor INTO @TBUV_Code, @ErrorMSG  
			 
			 WHILE @@FETCH_STATUS = 0  
			 BEGIN  
			 	  SET @Message = ''
			 
			 	  IF @ErrorMSG = 'GV'
			 	  BEGIN
			 			IF @ChangeFor = 'SG' OR @ChangeFor = 'DG'
			 				SET @Message = 'Duplicate Languages are not allowed across groups'
			 			ELSE
			 				SET @Message = 'Duplicate Countries are not allowed across groups'
			 	  END
			 
			 	  IF @ErrorMSG = 'AO'
			 	  BEGIN
			 			IF @ChangeFor = 'P'
			                 SET @Message = 'Rights Should have atleast one Platform'
			             ELSE IF (@ChangeFor = 'I' OR @ChangeFor = 'T')
			                 SET @Message = 'Rights Should have atleast one Territory Or Country'
			             ELSE IF ((@ChangeFor = 'SL' OR @ChangeFor = 'SG' OR @ChangeFor = 'DL' OR @ChangeFor = 'DG' OR @ChangeFor = 'TL') OR @IsTitleLanguage = 'N')
			                 SET @Message = 'Rights Should have atleast one Language'
			 	  END
			 
			 	  IF @ErrorMSG = 'SM'
			 	  BEGIN
			 			IF (@ChangeFor = 'P')
			                 SET @Message = 'Can not remove Platform as it is already Syndicated'
			             ELSE IF (@ChangeFor = 'I' OR @ChangeFor = 'T')
			                 SET @Message = 'Can not remove region as it is already syndicated'
			             ELSE IF (@ChangeFor = 'DL' OR @ChangeFor = 'DG')
			                 SET @Message = 'Can not remove dubbing as it is already syndicated'
			             ELSE IF (@ChangeFor = 'SL' OR @ChangeFor = 'SG')
			                 SET @Message = 'Can not remove subtitling as it is already syndicated'
			             ELSE IF (@ChangeFor = 'TL' AND @IsTitleLanguage = 'N')
			                 SET @Message = 'Title Language is already syndicated'
			             ELSE IF (@ChangeFor = 'E' OR @ChangeFor = 'S')
			                 SET @Message = 'Title is already syndicated'
			 	  END
			 
			 	  IF @ErrorMSG = 'HB'
			 	  BEGIN
			 			IF (@ChangeFor = 'TL')
			                 SET @Message = 'Holdback is already added for Title Language' 
			             IF (@ChangeFor = 'P')
			                 SET @ChangeFor = 'Can not remove Platform as Holdback is already added' 
			             ELSE IF (@ChangeFor = 'I' OR @ChangeFor = 'T')
			                 SET @Message = 'Can not remove region as Holdback is already added' 
			             ELSE IF (@ChangeFor = 'DL' OR @ChangeFor = 'DG')
			                 SET @Message = 'Can not remove dubbing as Holdback is already added' 
			             ELSE IF (@ChangeFor = 'SL' OR @ChangeFor = 'SG')
			                 SET @Message = 'Can not remove subtitling as Holdback is already added' 	
			 	  END
			 
			 	  IF @ErrorMSG = 'RD'
			 	  BEGIN
			 			IF @ChangeFor = 'RP'
			                 SET @Message = 'Can not change rights period as Run Definition is already added. To change rights period, delete Run Definition first.'
			             ELSE
			                 SET @Message = 'Run Definition Already Exist For This Combination'
			 	  END
			 	  
			 	  IF @Message <> ''
			 	  BEGIN
			 			 UPDATE #Temp_Bulk_Update_Validation SET ErrorMSG = @Message WHERE TBUV_Code = @TBUV_Code
			 	  END
			 		
			 	  FETCH NEXT FROM db_ErrorMsgcursor INTO @TBUV_Code, @ErrorMSG   
			 END 
			 CLOSE db_ErrorMsgcursor  
			 DEALLOCATE db_ErrorMsgcursor 

			 /*Coppying error records in table*/

			 PRINT 'Inserting error records into Acq_Deal_Rights_Error_Details'

			 DELETE FROM Acq_Deal_Rights_Error_Details  WHERE Acq_Deal_Rights_Code IN ( SELECT DISTINCT Rights_Code FROM #Temp_Bulk_Update_Validation)

			 INSERT INTO Acq_Deal_Rights_Error_Details
			 (Acq_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License,Is_Title_Language_Right, Country_Name,
			 Subtitling_Language, Dubbing_Language, Agreement_No, ErrorMSG, Episode_From, Episode_To, Is_Updated, Inserted_On)
			 SELECT DISTINCT Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License,Is_Title_Language_Right, Country_Name,
					Subtitling_Language, Dubbing_Language, Agreement_No, ErrorMSG, Episode_From, Episode_To, Is_Updated, GETDATE()
			 FROM #Temp_Bulk_Update_Validation

			 --Updating Record Status to E, D, Y
			 UPDATE Deal_Rights_Process SET Record_Status = 'E', Porcess_End = GETDATE()
			 WHERE Deal_Rights_Code IN (SELECT DISTINCT Rights_Code FROM #Temp_Bulk_Update_Validation) AND Deal_Code = @Deal_Code AND Rights_Bulk_Update_Code = @Deal_Process_RBU_Code

			 UPDATE Acq_Deal_Rights SET Right_Status = 'E' 
			 WHERE Acq_Deal_Rights_Code IN (SELECT DISTINCT Rights_Code FROM #Temp_Bulk_Update_Validation) AND Acq_Deal_Code = @Deal_Code

			 UPDATE Deal_Rights_Process SET Record_Status = 'D', Porcess_End = GETDATE() WHERE Record_Status = 'W' AND Deal_Code = @Deal_Code AND Rights_Bulk_Update_Code = @Deal_Process_RBU_Code

			 UPDATE Acq_Deal_Rights SET Right_Status = 'C' WHERE Right_Status = 'W' AND Acq_Deal_Code = @Deal_Code

			 /*UPDATE Deal_Rights_Process SET Record_Status = 'D', Process_End = GETDATE()
			 WHERE  Deal_Code = @Deal_Code AND Deal_Rights_Code IN (
				 SELECT Right_Code FROM #Merge_Rights_Title_Map
				 EXCEPT
				 SELECT DISTINCT Rights_Code FROM #Temp_Bulk_Update_Validation
			 ) */

			 PRINT 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
			 FETCH NEXT FROM db_RBU_cursor INTO @Rights_Bulk_Update_Code
		END 

		CLOSE db_RBU_cursor  
		DEALLOCATE db_RBU_cursor 
		PRINT 'Ended 1st For Loop'
		
		SET @IsValid = 'Y'
	COMMIT
	END TRY
	BEGIN CATCH
		SET @IsValid = 'N'
		IF @@TRANCOUNT > 0
			ROLLBACK

		 UPDATE Deal_Rights_Process SET Error_Messages = ERROR_MESSAGE(), Record_Status = 'E' WHERE Rights_Bulk_Update_Code =  @Deal_Process_RBU_Code
		 UPDATE Rights_Bulk_Update SET Is_Processed = 'Y' WHERE Rights_Bulk_Update_Code =  @Deal_Process_RBU_Code

	END CATCH
	IF OBJECT_ID('tempdb..#Temp_Bulk_Update_Validation') IS NOT NULL
		DROP TABLE #Temp_Bulk_Update_Validation

	IF OBJECT_ID('tempdb..#Temp_Rights_Bulk_Update') IS NOT NULL
		DROP TABLE #Temp_Rights_Bulk_Update

	IF OBJECT_ID('tempdb..#Merge_Rights_Title_Map') IS NOT NULL
		DROP TABLE #Merge_Rights_Title_Map

	IF OBJECT_ID('tempdb..#Right_Title_Code') IS NOT NULL
		DROP TABLE #Right_Title_Code
END


--select * from deal_rights_process
--select * from Rights_Bulk_Update

--truncate table Rights_Bulk_Update
--Exec usp_deal_process