ALTER proc [dbo].[USP_Deal_Rights_Template] 
	@Acq_Syn_Deal_Code INT,
	@Acq_Syn_Deal_Movie_Codes VARCHAR(MAX),
	@User_Code INT
AS
 --=============================================
 --Author:  Akshay Rane
 --Create date: 26 May  2016
 --Description: Adds the rights to the movies which has been added in the general tab according to the given template
 --=============================================
BEGIN

	--DECLARE
	--@Acq_Syn_Deal_Code			INT,
	--@Acq_Syn_Deal_Movie_Codes	VARCHAR(MAX),
	--@User_Code					INT

	--SET		@Acq_Syn_Deal_Code = 12357
	--SET		@Acq_Syn_Deal_Movie_Codes = '13019 , 16359, 16386'
	--SET		@User_Code = 143

	-------------------------------- TEMP TABLE TO DELETE IF EXIST IN TEMPDB --------------------------------
	IF(OBJECT_ID('TEMPDB..#Temp_Acq_Deal_Movie') IS NOT NULL)
		DROP TABLE #Temp_Acq_Deal_Movie

	IF(OBJECT_ID('TEMPDB..#Temp_Syn_Deal_Movie') IS NOT NULL)
		DROP TABLE #Temp_Syn_Deal_Movie

	-------------------------------- CREATION OF TEMP TABLE --------------------------------
	CREATE TABLE #Temp_Acq_Deal_Movie
	(
		Acq_Deal_Movie_Code		INT,
		Episode_Starts_From		INT,
		Episode_Ends_To			INT,
		Title_Code				INT
	)

	CREATE TABLE #Temp_Syn_Deal_Movie
	(
		Syn_Deal_Movie_Code		INT,
		Episode_Starts_From		INT,
		Episode_Ends_To			INT,
		Title_Code				INT
	)
	-------------------------------- BODY --------------------------------
	
	DECLARE 
		@Status					CHAR(1),
		@Error_Message			VARCHAR(MAX),
		@Is_ROFR				CHAR(1),
		@ROFR_Days				INT,
		@ROFR_Date				DATETIME, 
		@END_Date				DATETIME, 
		@Right_Start_Date		DATETIME, 
		@Term					FLOAT, 
		@Right_Type				CHAR(1), 
		@Year					INT, 
		@Month					INT,
		@Milestone_No_Of_Unit	INT,
		@Milestone_Unit_Type	INT,
		@Is_Tentetive			CHAR(1),
		@Acq_Deal_Rights_Code   INT,
		@Syn_Deal_Rights_Code   INT,
		@Type					CHAR(1),
		@Is_Tentative			CHAR(1),
		@Platform_Codes			VARCHAR(1000), 
		@Region_Type			CHAR(1),
		@Region_Codes			VARCHAR(1000), 
		@Subtitling_Type		CHAR(1),
		@Subtitling_Codes		VARCHAR(1000), 
		@Dubbing_Type			CHAR(1),
		@Dubbing_Codes			VARCHAR(1000)

	SELECT 
		@Right_Type = Right_Type, 
		@ROFR_Days = ROFRDays , 
		@Right_Start_Date = Right_Start_Date,
		@Term = Term , 
		@Milestone_No_Of_Unit = Milestone_No_Of_Unit,
		@Milestone_Unit_Type = Milestone_Unit_Type,
		@Platform_Codes = Platform_Codes, 
		@Region_Type = Region_Type,
		@Region_Codes = Region_Codes,
		@Subtitling_Type = Subtitling_Type,
		@Subtitling_Codes = Subtitling_Codes,
		@Dubbing_Type = Dubbing_Type,
		@Dubbing_Codes = Dubbing_Codes,
		@Type = [Type],
		@Is_Tentative = Is_Tentative
	FROM Acq_Rights_Template 
	WHERE UPPER(Template_Name) = 'OWN'

	-------------------------------- CALCULATION OF YEAR , MILESTONE AND PERPETUITY --------------------------------
	SELECT @Year = number FROM fn_Split_withdelemiter(@Term,'.') WHERE id = 1
	SELECT @Month = number FROM fn_Split_withdelemiter(@Term,'.') WHERE id = 2

	IF (@Right_Type = 'Y')
		BEGIN
			SELECT @END_Date =  DATEADD(yy,@Year,@Right_Start_Date)
			SELECT @END_Date =  DATEADD(mm,@Month,@END_Date) -- IF IS TENTETIVE DEN ADD END DATE
			SELECT @ROFR_Date =	 DATEADD(dd,- @ROFR_Days,@END_Date), @Is_ROFR = 'Y'
		END
	ELSE IF	 (@Right_Type = 'M')
		BEGIN	
			SELECT @END_Date =	CASE WHEN @Milestone_Unit_Type = 1 THEN  DATEADD(DAY,@Milestone_No_Of_Unit,@Right_Start_Date) 
								WHEN @Milestone_Unit_Type = 2 THEN  DATEADD(WEEK,@Milestone_No_Of_Unit,@Right_Start_Date) 
								WHEN @Milestone_Unit_Type = 3 THEN DATEADD(MONTH,@Milestone_No_Of_Unit,@Right_Start_Date) 
								ELSE  DATEADD(YEAR,@Milestone_No_Of_Unit,@Right_Start_Date) END

			SELECT @ROFR_Date =	 DATEADD(dd,- @ROFR_Days,@END_Date),  @Is_ROFR = 'Y'
		END
	ELSE IF	 (@Right_Type = 'U')
		BEGIN
			SELECT @END_Date =  DATEADD(yy,@Year,@Right_Start_Date) , @Is_ROFR = 'N'
		END
	
	-------------------------------- END CALCULATION OF YEAR , MILESTONE AND PERPETUITY --------------------------------

	IF (@Type = 'A')
		BEGIN
			BEGIN TRY 
				BEGIN TRANSACTION 

					INSERT INTO #Temp_Acq_Deal_Movie 
					(	
						Acq_Deal_Movie_Code,
						Episode_Starts_From,
						Episode_Ends_To,
						Title_Code
					)
					SELECT ADM.Acq_Deal_Movie_Code, ADM.Episode_Starts_From, ADM.Episode_End_To, ADM.Title_Code 
					FROM Acq_Deal_Movie ADM 
					WHERE Acq_Deal_Movie_Code IN (SELECT number FROM fn_Split_withdelemiter(@Acq_Syn_Deal_Movie_Codes,','))

					INSERT INTO Acq_Deal_Rights
					(
						Acq_Deal_Code,
						Is_Title_Language_Right,
						Is_Sub_License,
						Sub_License_Code,
						Is_Theatrical_Right,
						Right_Type,
						Is_Tentative,
						Is_Exclusive,
						Term,
						Right_Start_Date,
						Right_End_Date,
						Milestone_Type_Code,
						Milestone_No_Of_Unit,
						Milestone_Unit_Type,
						Is_ROFR,
						ROFR_Date,
						Effective_Start_Date,
						Actual_Right_Start_Date,
						Actual_Right_End_Date,
						Inserted_By,
						Inserted_On,
						Is_Verified,
						Original_Right_Type
					)
					SELECT 
						@Acq_Syn_Deal_Code,
						Is_Title_Language,
						Is_Sublicense,
						SubLicense_Code,
						Is_Theatrical,
						Right_Type,
						Is_Tentative,
						Is_Exclusive,
						Term,
						Right_Start_Date,
						CASE WHEN @Is_Tentative = 'N' THEN @END_Date 
							 WHEN @Is_Tentative = 'Y' THEN NULL END AS Right_Start_Date,
						Milestone_Type_Code,
						Milestone_No_Of_Unit,
						Milestone_Unit_Type,
						@Is_ROFR,
						@ROFR_Date,
						Right_Start_Date,
						Right_Start_Date,
						CASE WHEN @Is_Tentative = 'N' THEN @END_Date
							 WHEN @Is_Tentative = 'Y' THEN NULL END AS Actual_Right_End_Date,
						@User_Code,
						GETDATE(),
						'Y',
						Right_Type
					FROM  Acq_Rights_Template

					SELECT @Acq_Deal_Rights_Code = IDENT_CURRENT ('Acq_Deal_Rights') 

					INSERT INTO Acq_Deal_Rights_Title
					(
						Acq_Deal_Rights_Code,
						Title_Code,
						Episode_From,
						Episode_To
					)
					SELECT @Acq_Deal_Rights_Code, Title_Code, Episode_Starts_From, Episode_Ends_To 
					FROM #Temp_Acq_Deal_Movie

					IF (UPPER(@Platform_Codes) = 'ALL')
						BEGIN
							INSERT INTO Acq_Deal_Rights_Platform
							(
								Acq_Deal_Rights_Code,
								Platform_Code
							)
							SELECT @Acq_Deal_Rights_Code , Platform_Code FROM Platform where Is_Last_Level = 'Y'
						END
					ELSE
						BEGIN
							INSERT INTO Acq_Deal_Rights_Platform
							(
								Acq_Deal_Rights_Code,
								Platform_Code
							)
							SELECT @Acq_Deal_Rights_Code , NUMBER FROM fn_Split_withdelemiter(@Platform_Codes,',')
						END
				
				    INSERT INTO Acq_Deal_Rights_Territory
						(
							Acq_Deal_Rights_Code,
							Territory_Type,
							Territory_Code,
							Country_Code			
						)
						SELECT
							@Acq_Deal_Rights_Code , 
							@Region_Type,
							CASE WHEN @Region_Type = 'G' THEN NUMBER ELSE NULL END,
							CASE WHEN @Region_Type = 'I' THEN NUMBER ELSE NULL END
						FROM fn_Split_withdelemiter(@Region_Codes,',')
				    
				    INSERT INTO Acq_Deal_Rights_Subtitling
						(
							Acq_Deal_Rights_Code,
							Language_Type,
							Language_Group_Code,
							Language_Code
						)
						SELECT 
							@Acq_Deal_Rights_Code,
							@Subtitling_Type,
							CASE WHEN @Subtitling_Type = 'G' THEN NUMBER ELSE NULL END,
							CASE WHEN @Subtitling_Type = 'I' THEN NUMBER ELSE NULL END
						FROM fn_Split_withdelemiter(@Subtitling_Codes,',')
				    
				    INSERT INTO Acq_Deal_Rights_Dubbing
						(
							Acq_Deal_Rights_Code,
							Language_Type,
							Language_Group_Code,
							Language_Code
						)
						SELECT 
							@Acq_Deal_Rights_Code,
							@Dubbing_Type,
							CASE WHEN @Dubbing_Type = 'G' THEN NUMBER ELSE NULL END,
							CASE WHEN @Dubbing_Type = 'I' THEN NUMBER ELSE NULL END
						FROM fn_Split_withdelemiter(@Dubbing_Codes,',')
					
					SELECT @Status = 'Y',@Error_Message =''
					SELECT @Status AS Status ,@Error_Message AS [Error_Message]

				COMMIT
			END TRY
			BEGIN CATCH  
				SELECT @Status = 'E',@Error_Message = ERROR_MESSAGE()
				SELECT @Status AS Status ,@Error_Message AS [Error_Message]
				ROLLBACK
			END CATCH 
		END
	ELSE IF (@Type = 'S')
		BEGIN
			BEGIN TRY 
				BEGIN TRANSACTION 

					INSERT INTO #Temp_Syn_Deal_Movie 
					(	
						Syn_Deal_Movie_Code,
						Episode_Starts_From,
						Episode_Ends_To,
						Title_Code
					)
					SELECT SDM.Syn_Deal_Movie_Code, SDM.Episode_From, SDM.Episode_End_To, SDM.Title_Code 
					FROM Syn_Deal_Movie SDM 
					WHERE Syn_Deal_Movie_Code IN (SELECT number FROM fn_Split_withdelemiter(@Acq_Syn_Deal_Movie_Codes,','))

					INSERT INTO Syn_Deal_Rights
					(
						Syn_Deal_Code,
						Is_Exclusive,
						Is_Title_Language_Right,
						Is_Sub_License,
						Sub_License_Code,
						Is_Theatrical_Right,
						Right_Type,
						Is_Tentative,
						Term,
						Right_Start_Date,
						Right_End_Date,
						Milestone_Type_Code,
						Milestone_No_Of_Unit,
						Milestone_Unit_Type,
						Is_ROFR,
						ROFR_Date,
						Effective_Start_Date,
						Actual_Right_Start_Date,
						Actual_Right_End_Date,
						Is_Pushback,
						Inserted_By,
						Inserted_On,
						Right_Status,
						Is_Verified,
						Original_Right_Type
					)
					SELECT 
						@Acq_Syn_Deal_Code,
						Is_Exclusive,
						Is_Title_Language,
						Is_Sublicense,
						SubLicense_Code,
						Is_Theatrical,
						Right_Type,
						Is_Tentative,
						Term,
						Right_Start_Date,
						CASE WHEN @Is_Tentative = 'N' THEN @END_Date
							 WHEN @Is_Tentative = 'Y' THEN NULL END AS Right_Start_Date,
						Milestone_Type_Code,
						Milestone_No_Of_Unit,
						Milestone_Unit_Type,
						@Is_ROFR,
						@ROFR_Date,
						Right_Start_Date,
						Right_Start_Date,
						CASE WHEN @Is_Tentative = 'N' THEN @END_Date
							 WHEN @Is_Tentative = 'Y' THEN NULL END AS Actual_Right_End_Date,
						'N',
						@User_Code,
						GETDATE(),
						'P',
						'Y',
						Right_Type
					FROM  Acq_Rights_Template 

					SELECT @Syn_Deal_Rights_Code = IDENT_CURRENT ('Syn_Deal_Rights') 

					INSERT INTO Syn_Deal_Rights_Title
					(
						Syn_Deal_Rights_Code,
						Title_Code,
						Episode_From,
						Episode_To
					)
					SELECT @Syn_Deal_Rights_Code, Title_Code, Episode_Starts_From, Episode_Ends_To 
					FROM #Temp_Syn_Deal_Movie

					IF (UPPER(@Platform_Codes) = 'ALL')
						BEGIN
							INSERT INTO Syn_Deal_Rights_Platform
							(
								Syn_Deal_Rights_Code,
								Platform_Code
							)
							SELECT @Syn_Deal_Rights_Code , Platform_Code FROM Platform where Is_Last_Level = 'Y'
						END
					ELSE
						BEGIN
							INSERT INTO Syn_Deal_Rights_Platform
							(
								Syn_Deal_Rights_Code,
								Platform_Code
							)
							SELECT @Syn_Deal_Rights_Code , NUMBER FROM fn_Split_withdelemiter(@Platform_Codes,',')
						END
				
					INSERT INTO Syn_Deal_Rights_Territory
					(
						Syn_Deal_Rights_Code,
						Territory_Type,
						Territory_Code,
						Country_Code			
					)
					SELECT
						@Syn_Deal_Rights_Code,
						@Region_Type,
						CASE WHEN @Region_Type = 'G' THEN NUMBER ELSE NULL END,
						CASE WHEN @Region_Type = 'I' THEN NUMBER ELSE NULL END
					FROM fn_Split_withdelemiter(@Region_Codes,',')
								
					INSERT INTO Syn_Deal_Rights_Subtitling
					(
						Syn_Deal_Rights_Code,
						Language_Type,
						Language_Group_Code,
						Language_Code
					)
					SELECT
						@Syn_Deal_Rights_Code,
						@Subtitling_Type, 
						CASE WHEN @Subtitling_Type = 'G' THEN NUMBER ELSE NULL END,
						CASE WHEN @Subtitling_Type = 'I' THEN NUMBER ELSE NULL END
					FROM fn_Split_withdelemiter(@Subtitling_Codes,',')
							
					INSERT INTO Syn_Deal_Rights_Dubbing
					(
						Syn_Deal_Rights_Code,
						Language_Type,
						Language_Group_Code,
						Language_Code
					)
					SELECT
						@Syn_Deal_Rights_Code,
						@Dubbing_Type,
						CASE WHEN @Dubbing_Type = 'G' THEN NUMBER ELSE NULL END,
						CASE WHEN @Dubbing_Type = 'I' THEN NUMBER ELSE NULL END
					FROM fn_Split_withdelemiter(@Dubbing_Codes,',')
					
					SELECT @Status = 'Y',@Error_Message =''
					SELECT @Status AS Status ,@Error_Message AS [Error_Message]

				COMMIT
			END TRY
			BEGIN CATCH  
				SELECT @Status = 'E',@Error_Message = ERROR_MESSAGE()
				SELECT @Status AS Status ,@Error_Message AS [Error_Message]
				ROLLBACK
			END CATCH 
		END
	-------------------------------- END BODY --------------------------------
END
--exec [usp_rt] 0,'18499 , 21597 , 20562',1,16,5
 --update Acq_Rights_Template set Region_Type = 'I' WHERE Acq_Rights_Template_Code = 1

 --SELECT * FROM Syn_Deal_Rights_Dubbing
