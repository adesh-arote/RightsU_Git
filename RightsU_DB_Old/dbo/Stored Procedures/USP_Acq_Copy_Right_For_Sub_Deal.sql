CREATE PROCEDURE USP_Acq_Copy_Right_For_Sub_Deal
(
	@Acq_Deal_Code INT, 
	@Master_Deal_Movie_Code INT, 
	@User_Code INT, 
	@Selected_Title_Codes VARCHAR(MAX)
)
AS
-- =============================================
-- Author:		Abhaysingh N Rajpurohit
-- Create date: 13 March 2015
-- Description:	Copy all rights of Master deal which related to selected Titles
-- =============================================
BEGIN

	SET NOCOUNT ON 	
	SET FMTONLY OFF

	BEGIN TRY
		BEGIN TRAN
		--DECLARE @Acq_Deal_Code INT = 1619, @Master_Deal_Movie_Code INT = 879, @User_Code INT = 143, @Selected_Title_Codes VARCHAR(MAX) = '4231'
		--DECLARE @Acq_Deal_Code INT = 1619, @Master_Deal_Movie_Code INT = 879, @User_Code INT = 143, @Selected_Title_Codes VARCHAR(MAX) = '4231,4589,4637'
		DECLARE @Error_Message VARCHAR(MAX) = ''

		IF OBJECT_ID('tempdb..#Title') IS NOT NULL
		BEGIN
			DROP TABLE #Title
		END

		IF OBJECT_ID('tempdb..#Rights') IS NOT NULL
		BEGIN
			DROP TABLE #Rights
		END
		
		IF OBJECT_ID('tempdb..#Rights_Holdback') IS NOT NULL
		BEGIN
			DROP TABLE #Rights_Holdback
		END
		
		IF OBJECT_ID('tempdb..#Rights_Blackout') IS NOT NULL
		BEGIN
			DROP TABLE #Rights_Blackout
		END

		IF OBJECT_ID('tempdb..#Rights_Promoter') IS NOT NULL
		BEGIN
			DROP TABLE #Rights_Promoter
		END

		CREATE TABLE #Title
		(
			Title_Code INT
		)

		CREATE TABLE #Rights
		(
			Right_Code INT, 
			Is_Done CHAR(1)
		)

		CREATE TABLE #Rights_Holdback
		(
			Right_Holdback_Code INT, 
			Is_Done CHAR(1)
		)

		CREATE TABLE #Rights_Blackout
		(
			Right_Blackout_Code INT, 
			Is_Done CHAR(1)
		)
			CREATE TABLE #Rights_Promoter
		(
			Right_Promoter_Code INT, 
			Is_Done CHAR(1)
		)

		INSERT INTO #Title
		SELECT number AS Title_Code FROM DBO.fn_Split_withdelemiter(@Selected_Title_Codes, ',')

		DELETE FROM #Title WHERE Title_Code IN (
			SELECT DISTINCT ADRT.Title_Code FROM Acq_Deal_Rights ADR 
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code
		)

		IF(@Master_Deal_Movie_Code > 0 AND (SELECT COUNT(Title_Code) FROM #Title) > 0)
		BEGIN
			DECLARE @Title_Code INT = 0, @Master_Deal_Code INT = 0, @Right_Code INT = 0, @Right_Holdback_Code INT = 0, @Right_Blackout_Code INT = 0,@Right_Promoter_Code INT
			SELECT TOP 1 @Title_Code = Title_Code, @Master_Deal_Code = Acq_Deal_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code = @Master_Deal_Movie_Code

			PRINT 'Master_Deal_Code : ' + CAST(@Master_Deal_Code AS VARCHAR)
			PRINT 'Master Title_Code : ' + CAST(@Title_Code AS VARCHAR)

			INSERT INTO #Rights
			SELECT DISTINCT ADR.Acq_Deal_Rights_Code, 'N' FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Master_Deal_Code
			AND ADRT.Title_Code = @Title_Code

			SELECT TOP 1 @Right_Code = Right_Code FROM #Rights WHERE Is_Done = 'N'
			PRINT 'Acq_Deal_Right_Code : ' + CAST(@Right_Code AS VARCHAR)
			WHILE(@Right_Code > 0)
			BEGIN
				---------- Insert data in Acq_Deal_Rights ----------
				PRINT 'Inserting data in Acq_Deal_Rights_Title....'
				INSERT INTO Acq_Deal_Rights (Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right
				, Right_Type, Original_Right_Type, Is_Tentative,Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type
				, Is_ROFR,ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On
				, Last_Updated_Time,Last_Action_By)

				SELECT @Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right
				, Right_Type, Original_Right_Type, Is_Tentative,Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type
				, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, @User_Code, GETDATE()
				, GETDATE(), @User_Code
				FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Right_Code

				---------- Insert data in Acq_Deal_Rights_Title ----------
				PRINT 'Inserting data in Acq_Deal_Rights_Title....'
				INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
				SELECT IDENT_CURRENT('Acq_Deal_Rights'), Title_Code, 1, 1 FROM #Title

				---------- Insert data in Acq_Deal_Rights_Platform ----------
				PRINT 'Inserting data in Acq_Deal_Rights_Platform....'
				INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)
				SELECT IDENT_CURRENT('Acq_Deal_Rights'), Platform_Code FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = @Right_Code

				---------- Insert data in Acq_Deal_Rights_Territory ----------
				PRINT 'Inserting data in Acq_Deal_Rights_Territory....'
				INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Type, Country_Code, Territory_Code)
				SELECT IDENT_CURRENT('Acq_Deal_Rights'), Territory_Type, Country_Code, Territory_Code 
				FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code = @Right_Code

				---------- Insert data in Acq_Deal_Rights_Subtitling ----------
				PRINT 'Inserting data in Acq_Deal_Rights_Subtitling....'
				INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code )
				SELECT IDENT_CURRENT('Acq_Deal_Rights'), Language_Type, Language_Code, Language_Group_Code 
				FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code = @Right_Code

				---------- Insert data in Acq_Deal_Rights_Dubbing ----------
				PRINT 'Inserting data in Acq_Deal_Rights_Dubbing....'
				INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code )
				SELECT IDENT_CURRENT('Acq_Deal_Rights'), Language_Type, Language_Code, Language_Group_Code 
				FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code = @Right_Code

				---------- Insert data in Acq_Deal_Rights_Blackout ----------
				SET @Right_Blackout_Code = 0
				INSERT INTO #Rights_Blackout(Right_Blackout_Code, Is_Done)
				SELECT DISTINCT Acq_Deal_Rights_Blackout_Code, 'N'
				FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Right_Code

				SELECT TOP 1 @Right_Blackout_Code = Right_Blackout_Code FROM #Rights_Blackout WHERE Is_Done = 'N'
				PRINT 'Right_Blackout_Code : ' + CAST(@Right_Blackout_Code AS VARCHAR)
				WHILE(@Right_Blackout_Code > 0)
				BEGIN
					PRINT 'Inserting data in Acq_Deal_Rights_Blackout....'
					INSERT INTO Acq_Deal_Rights_Blackout (Acq_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
					SELECT IDENT_CURRENT('Acq_Deal_Rights'), Start_Date, End_Date, @User_Code, GETDATE(), GETDATE(), @User_Code
					FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Blackout_Code = @Right_Blackout_Code
					
					---------- Insert data in Acq_Deal_Rights_Blackout_Platform ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Blackout_Platform....'
					INSERT INTO Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Code, Platform_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Blackout'), Platform_Code 
					FROM Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code = @Right_Blackout_Code

					---------- Insert data in Acq_Deal_Rights_Blackout_Territory ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Blackout_Territory....'
					INSERT INTO Acq_Deal_Rights_Blackout_Territory (Acq_Deal_Rights_Blackout_Code, Territory_Type, Country_Code, Territory_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Blackout'), Territory_Type, Country_Code, Territory_Code 
					FROM Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code = @Right_Blackout_Code

					---------- Insert data in Acq_Deal_Rights_Blackout_Subtitling ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Blackout_Subtitling....'
					INSERT INTO Acq_Deal_Rights_Blackout_Subtitling (Acq_Deal_Rights_Blackout_Code, Language_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Blackout'), Language_Code FROM Acq_Deal_Rights_Blackout_Subtitling 
					WHERE Acq_Deal_Rights_Blackout_Code = @Right_Blackout_Code

					---------- Insert data in Acq_Deal_Rights_Blackout_Dubbing ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Blackout_Dubbing....'
					INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Code, Language_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Blackout'), Language_Code FROM Acq_Deal_Rights_Blackout_Dubbing 
					WHERE Acq_Deal_Rights_Blackout_Code = @Right_Blackout_Code

					---------- Jump to Next Right Blackout ----------
					PRINT 'Updating #Rights_Blackout for Right_Blackout_Code = ' + CAST(@Right_Blackout_Code AS VARCHAR) + '....'
					UPDATE #Rights_Blackout SET Is_Done = 'Y' WHERE Right_Blackout_Code = @Right_Blackout_Code
					SET @Right_Blackout_Code = 0
					SELECT TOP 1 @Right_Blackout_Code = Right_Blackout_Code FROM #Rights_Blackout WHERE Is_Done = 'N'
					PRINT 'Right_Blackout_Code : ' + CAST(@Right_Blackout_Code AS VARCHAR)
				END

					---------- Insert data in Acq_Deal_Rights_Promoter ----------
				SET @Right_Promoter_Code = 0
				INSERT INTO #Rights_Promoter(Right_Promoter_Code, Is_Done)
				SELECT DISTINCT Acq_Deal_Rights_Promoter_Code, 'N'
				FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code = @Right_Code

				SELECT TOP 1 @Right_Promoter_Code = Right_Promoter_Code FROM #Rights_Promoter WHERE Is_Done = 'N'
				PRINT 'Right_Promoter_Code : ' + CAST(@Right_Promoter_Code AS VARCHAR)
				WHILE(@Right_Promoter_Code > 0)
				BEGIN
					PRINT 'Inserting data in Acq_Deal_Rights_Promoter....'
					INSERT INTO Acq_Deal_Rights_Promoter (Acq_Deal_Rights_Code, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
					SELECT IDENT_CURRENT('Acq_Deal_Rights'), @User_Code, GETDATE(), GETDATE(), @User_Code
					FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Promoter_Code = @Right_Promoter_Code
					
					---------- Insert data in Acq_Deal_Rights_Promoter_Group ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Promoter_Group....'
					INSERT INTO Acq_Deal_Rights_Promoter_Group (Acq_Deal_Rights_Promoter_Code, Promoter_Group_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Promoter'), Promoter_Group_Code 
					FROM Acq_Deal_Rights_Promoter_Group WHERE Acq_Deal_Rights_Promoter_Code = @Right_Promoter_Code

					---------- Insert data in Acq_Deal_Rights_Promoter_Remarks ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Promoter_Remarks....'
					INSERT INTO Acq_Deal_Rights_Promoter_Remarks (Acq_Deal_Rights_Promoter_Code, Promoter_Remarks_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Promoter'), Promoter_Remarks_Code
					FROM Acq_Deal_Rights_Promoter_Remarks WHERE Acq_Deal_Rights_Promoter_Code = @Right_Promoter_Code
				
					---------- Jump to Next Right Promoter ----------
					PRINT 'Updating #Rights_Promoter for Right_Promoter_Code = ' + CAST(@Right_Promoter_Code AS VARCHAR) + '....'
					UPDATE #Rights_Promoter SET Is_Done = 'Y' WHERE Right_Promoter_Code = @Right_Promoter_Code
					SET @Right_Promoter_Code = 0
					SELECT TOP 1 @Right_Promoter_Code = Right_Promoter_Code FROM #Rights_Promoter WHERE Is_Done = 'N'
					PRINT 'Right_Promoter_Code : ' + CAST(@Right_Promoter_Code AS VARCHAR)
				END


				---------- Insert data in Acq_Deal_Rights_Holdback ----------
				SET @Right_Holdback_Code = 0
				INSERT INTO #Rights_Holdback(Right_Holdback_Code, Is_Done)
				SELECT DISTINCT Acq_Deal_Rights_Holdback_Code, 'N'
				FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Right_Code

				SELECT TOP 1 @Right_Holdback_Code = Right_Holdback_Code FROM #Rights_Holdback WHERE Is_Done = 'N'
				PRINT 'Right_Holdback_Code : ' + CAST(@Right_Holdback_Code AS VARCHAR)
				WHILE(@Right_Holdback_Code > 0)
				BEGIN
					PRINT 'Inserting data in Acq_Deal_Rights_Holdback....'
					INSERT INTO Acq_Deal_Rights_Holdback (Acq_Deal_Rights_Code, Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units
					, Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right)
					SELECT IDENT_CURRENT('Acq_Deal_Rights'), Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units
					, Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right
					FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Holdback_Code = @Right_Holdback_Code
					
					---------- Insert data in Acq_Deal_Rights_Platform ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Holdback_Platform....'
					INSERT INTO Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Code, Platform_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Holdback'), Platform_Code 
					FROM Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code = @Right_Holdback_Code

					---------- Insert data in Acq_Deal_Rights_Territory ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Holdback_Territory....'
					INSERT INTO Acq_Deal_Rights_Holdback_Territory (Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Holdback'), Territory_Type, Country_Code, Territory_Code 
					FROM Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code = @Right_Holdback_Code

					---------- Insert data in Acq_Deal_Rights_Subtitling ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Holdback_Subtitling....'
					INSERT INTO Acq_Deal_Rights_Holdback_Subtitling (Acq_Deal_Rights_Holdback_Code, Language_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Holdback'), Language_Code FROM Acq_Deal_Rights_Holdback_Subtitling 
					WHERE Acq_Deal_Rights_Holdback_Code = @Right_Holdback_Code

					---------- Insert data in Acq_Deal_Rights_Dubbing ----------
					PRINT 'Inserting data in Acq_Deal_Rights_Holdback_Dubbing....'
					INSERT INTO Acq_Deal_Rights_Holdback_Dubbing (Acq_Deal_Rights_Holdback_Code, Language_Code)
					SELECT IDENT_CURRENT('Acq_Deal_Rights_Holdback'), Language_Code FROM Acq_Deal_Rights_Holdback_Dubbing 
					WHERE Acq_Deal_Rights_Holdback_Code = @Right_Holdback_Code

					---------- Jump to Next Right Holdback ----------
					PRINT 'Updating #Rights_Holdback for Right_Holdback_Code = ' + CAST(@Right_Holdback_Code AS VARCHAR) + '....'
					UPDATE #Rights_Holdback SET Is_Done = 'Y' WHERE Right_Holdback_Code = @Right_Holdback_Code
					SET @Right_Holdback_Code = 0
					SELECT TOP 1 @Right_Holdback_Code = Right_Holdback_Code FROM #Rights_Holdback WHERE Is_Done = 'N'
					PRINT 'Right_Holdback_Code : ' + CAST(@Right_Holdback_Code AS VARCHAR)
				END

				---------- Jump to Next Right ----------
				PRINT 'Updating #Rights for Right_Code = ' + CAST(@Right_Code AS VARCHAR) + '....'
				UPDATE #Rights SET Is_Done = 'Y' WHERE Right_Code = @Right_Code
				SET @Right_Code = 0
				SELECT TOP 1 @Right_Code = Right_Code FROM #Rights WHERE Is_Done = 'N'
				PRINT 'Acq_Deal_Right_Code : ' + CAST(@Right_Code AS VARCHAR)
			END
		END
		ELSE
			PRINT 'MESSAGE : Rights has been already copy for all selected titles'
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		SET @Error_Message  = 'ERROR : ' + ISNULL(ERROR_MESSAGE(), '') + ' In USP_ ERROR_LINE : ' + ISNULL(CAST(ERROR_LINE() AS VARCHAR), '')
	END CATCH

	SELECT @Error_Message AS 'Error_Message'
END