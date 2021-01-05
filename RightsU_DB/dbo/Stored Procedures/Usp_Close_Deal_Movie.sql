CREATE PROCEDURE [dbo].[Usp_Close_Deal_Movie]
(
	@Acq_Deal_Code INT
)
AS
BEGIN

	/*
	Condition-1 : If Movie Closed Date is < Rights Start Date    
				Rights have one Title	=  Delete the Rights
				Rights have more than one Title	=  Remove the Title Rights
	Condition-2 : If Movie Closed Date is between Rights Period  
				Rights have one Title	=  Update the Rights End Date
				Rights have more than one Title	=  Create another Rights for the Title with Updated Rights end date

	Condition-3 : If Movie Closed Date is > Rights End Date    =  No Changes. --Condition Removed
	*/	

	--SET @Acq_Deal_Code = 1002
	DECLARE @New_Acq_Deal_Rights_Code INT

	SELECT Acq_Deal_Movie_Code, Title_Code, Movie_Closed_Date FROM Acq_Deal_Movie WHERE Is_Closed = 'X' AND Acq_Deal_Code = @Acq_Deal_Code
	DECLARE 
		@Acq_Deal_Movie_Code int, @Title_Code INT, @Movie_Closed_Date datetime, @Acq_Deal_Rights_Code INT, 
		@Right_Start_Date DATETIME, @Right_End_Date DATETIME, @Right_Type VARCHAR(2), @Original_Right_Type VARCHAR(2)

	Declare crTitle Cursor FOR 
	SELECT adm.Acq_Deal_Movie_Code, adm.Title_Code, adm.Movie_Closed_Date, adr.Acq_Deal_Rights_Code, 
		adr.Actual_Right_Start_Date, ISNULL(adr.Actual_Right_End_Date, adm.Movie_Closed_Date), adr.Right_Type, adr.Original_Right_Type
	FROM Acq_Deal_Rights adr
		INNER JOIN Acq_Deal_Rights_Title adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Movie adm ON adm.Title_Code = adrt.Title_Code AND adm.Episode_Starts_From = adrt.Episode_From AND adm.Episode_End_To = adrt.Episode_To AND adm.Acq_Deal_Code = adr.Acq_Deal_Code
	WHERE adr.Acq_Deal_Code = @Acq_Deal_Code AND Is_Closed = 'X'

	OPEN crTitle
	FETCH NEXT FROM crTitle INTO @Acq_Deal_Movie_Code, @Title_Code, @Movie_Closed_Date, @Acq_Deal_Rights_Code, @Right_Start_Date, @Right_End_Date, @Right_Type, @Original_Right_Type
	While(@@FETCH_STATUS=0)
	BEGIN	
		IF(@Movie_Closed_Date < @Right_Start_Date)
		BEGIN

			Print 'Less than Start Date'

			IF((SELECT COUNT(*) FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code <> @Title_Code ) > 0)
			BEGIN
				Print 'Less than Start Date- More than 1 Title'
				DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code 
			END
			ELSE
			BEGIN
				Print 'Less than Start Date - 1 Title'
				---------------------------------------Delete Rights for Title-------------
				--Holdback
				DELETE FROM Acq_Deal_Rights_Holdback_Platform WHERE Acq_Deal_Rights_Holdback_Code IN
				(
					SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				)
	 
				DELETE FROM Acq_Deal_Rights_Holdback_Territory WHERE Acq_Deal_Rights_Holdback_Code IN
				(
					SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				) 
				DELETE FROM Acq_Deal_Rights_Holdback_Dubbing WHERE Acq_Deal_Rights_Holdback_Code IN
				(
					SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				)
				DELETE FROM Acq_Deal_Rights_Holdback_Subtitling WHERE Acq_Deal_Rights_Holdback_Code IN
				(
					SELECT Acq_Deal_Rights_Holdback_Code FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				) 
				DELETE FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				--Blackout
				DELETE FROM Acq_Deal_Rights_Blackout_Platform WHERE Acq_Deal_Rights_Blackout_Code IN
				(
					SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				) 
				DELETE FROM Acq_Deal_Rights_Blackout_Territory WHERE Acq_Deal_Rights_Blackout_Code IN
				(
					SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				) 
				DELETE FROM Acq_Deal_Rights_Blackout_Dubbing WHERE Acq_Deal_Rights_Blackout_Code IN
				(
					SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout 	WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				)
				DELETE FROM Acq_Deal_Rights_Blackout_Subtitling WHERE Acq_Deal_Rights_Blackout_Code IN
				(
					SELECT Acq_Deal_Rights_Blackout_Code FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				) 
				DELETE FROM Acq_Deal_Rights_Blackout WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
	
				--Rights
				DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				DELETE FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
	
				DELETE FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				DELETE FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				DELETE FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				DELETE FROM Acq_Deal_Rights  WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				---------------------------------------------------Complete Rights----------------------------------	

			END
		
			---------------------------------------Delete Run Definition for Title-------------

			DELETE FROM Acq_Deal_Run_Yearwise_Run_Week WHERE Acq_Deal_Run_Code in (SELECT ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run_Title ADRT
			INNER JOIN Acq_Deal_Run ADR ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE Title_Code = @Title_Code 
			AND ADR.Acq_Deal_Code = @Acq_Deal_Code)

			DELETE FROM Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code in (SELECT ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run_Title ADRT
			INNER JOIN Acq_Deal_Run ADR ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE Title_Code = @Title_Code 
			AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			)
		
			DELETE FROM Acq_Deal_Run_Repeat_On_Day WHERE Acq_Deal_Run_Code in (SELECT ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run_Title ADRT
			INNER JOIN Acq_Deal_Run ADR ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE Title_Code = @Title_Code 
			AND ADR.Acq_Deal_Code = @Acq_Deal_Code)

			DELETE FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code in (SELECT ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run_Title ADRT
			INNER JOIN Acq_Deal_Run ADR ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE Title_Code = @Title_Code 
			AND ADR.Acq_Deal_Code = @Acq_Deal_Code)
				
			DELETE ADRT
			FROM Acq_Deal_Run_Title  ADRT
			INNER JOIN Acq_Deal_Run ADR ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code
			AND Title_Code = @Title_Code

			DELETE FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code IN (SELECT Acq_Deal_Run_Code FROM Acq_Deal_Run_Title WHERE Title_Code = @Title_Code)
			AND Acq_Deal_Code = @Acq_Deal_Code

		---------------------------------------Complete Run Definition-------------
		END
		ELSE IF(@Movie_Closed_Date >= @Right_Start_Date AND @Movie_Closed_Date <= @Right_End_Date)
		BEGIN
			Print 'Between Rights Period'
			IF((SELECT COUNT(*) FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code <> @Title_Code ) > 0)
			BEGIN
			
					Print 'Between Rights Period - More than 1 Title'
				
					INSERT INTO Acq_Deal_Rights(Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
						Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
						ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
						Last_Updated_Time, Last_Action_By)
					Select @Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
						'Y', Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
						ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
						Last_Updated_Time, Last_Action_By
					FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				
					SELECT @New_Acq_Deal_Rights_Code = IDENT_CURRENT('Acq_Deal_Rights')

					/**************** Insert into Acq_Deal_Rights_Title ****************/ 
					INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
					SELECT @New_Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To
					FROM Acq_Deal_Rights_Title ADRT 
					Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code

					/**************** Insert into Acq_Deal_Rights_Title_Eps ****************/ 

					INSERT INTO Acq_Deal_Rights_Title_Eps (Acq_Deal_Rights_Title_Code, EPS_No)
					SELECT 
						AtADRT.Acq_Deal_Rights_Title_Code, ADRTE.EPS_No
						FROM Acq_Deal_Rights_Title_EPS ADRTE 
						INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code
						INNER JOIN Acq_Deal_Rights_Title AtADRT On 
							CAST(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_To, '') AS VARCHAR)
							=
							CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)
							WHERE ADRT.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRT.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Platform ****************/ 

					INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)	
					SELECT @New_Acq_Deal_Rights_Code, ADRP.Platform_Code
					FROM Acq_Deal_Rights_Platform ADRP Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Territory ****************/ 

					INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)	
					SELECT @New_Acq_Deal_Rights_Code, ADRT.Territory_Code, ADRT.Territory_Type, ADRT.Country_Code
					FROM Acq_Deal_Rights_Territory ADRT Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Subtitling ****************/ 
					INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
					SELECT @New_Acq_Deal_Rights_Code, ADRS.Language_Code, ADRS.Language_Group_Code, ADRS.Language_Type
					FROM Acq_Deal_Rights_Subtitling ADRS Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Dubbing ****************/ 

					INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
					SELECT @New_Acq_Deal_Rights_Code, ADRD.Language_Code, ADRD.Language_Group_Code, ADRD.Language_Type
					FROM Acq_Deal_Rights_Dubbing ADRD Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Holdback ****************/ 

					INSERT INTO Acq_Deal_Rights_Holdback (Acq_Deal_Rights_Code, 
						Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
						Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right)
					SELECT @New_Acq_Deal_Rights_Code, 
						ADRH.Holdback_Type, ADRH.HB_Run_After_Release_No, ADRH.HB_Run_After_Release_Units, 
						ADRH.Holdback_On_Platform_Code, ADRH.Holdback_Release_Date, ADRH.Holdback_Comment, ADRH.Is_Title_Language_Right
					FROM Acq_Deal_Rights_Holdback ADRH Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Holdback_Dubbing ********/ 

					INSERT INTO Acq_Deal_Rights_Holdback_Dubbing (Acq_Deal_Rights_Holdback_Code, Language_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHD.Language_Code
					FROM Acq_Deal_Rights_Holdback_Dubbing ADRHD INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHD.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code


					/******** Insert into Acq_Deal_Rights_Holdback_Platform ********/ 

					INSERT INTO Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Code, Platform_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHP.Platform_Code
					FROM Acq_Deal_Rights_Holdback_Platform ADRHP INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON 
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '') 
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Holdback_Subtitling ********/ 
					INSERT INTO Acq_Deal_Rights_Holdback_Subtitling (Acq_Deal_Rights_Holdback_Code, Language_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHS.Language_Code
					FROM Acq_Deal_Rights_Holdback_Subtitling ADRHS INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Holdback_Territory ********/ 

					INSERT INTO Acq_Deal_Rights_Holdback_Territory (Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code
					FROM Acq_Deal_Rights_Holdback_Territory ADRHT INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '') 
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Blackout ****************/ 

					INSERT INTO Acq_Deal_Rights_Blackout (Acq_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
					SELECT @New_Acq_Deal_Rights_Code, ADRB.Start_Date, ADRB.End_Date, ADRB.Inserted_By, ADRB.Inserted_On, ADRB.Last_Updated_Time, ADRB.Last_Action_By
					FROM Acq_Deal_Rights_Blackout ADRB WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Dubbing ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Code, Language_Code)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBD.Language_Code
					FROM Acq_Deal_Rights_Blackout_Dubbing ADRBD 
						INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR)
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Platform ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Code, Platform_Code)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBP.Platform_Code
					FROM Acq_Deal_Rights_Blackout_Platform ADRBP INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBP.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON 
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Subtitling ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Subtitling(Acq_Deal_Rights_Blackout_Code, Language_Code)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBS.Language_Code
					FROM Acq_Deal_Rights_Blackout_Subtitling ADRBS INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBS.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON 
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Territory ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Territory(Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBT.Country_Code, ADRBT.Territory_Code, ADRBT.Territory_Type
					FROM Acq_Deal_Rights_Blackout_Territory ADRBT INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBT.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Delete Title From Old Acq_Deal_Rights_Title********/ 

					DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code 
			END
			ELSE
			BEGIN

				Print 'Between Rights Period - 1 Title'
				IF(@Right_Type = 'M')
				BEGIN
					UPDATE Acq_Deal_Rights SET Actual_Right_End_Date = @Movie_Closed_Date, 
					Milestone_No_Of_Unit = CAST(CAST([dbo].[UFN_Calculate_Term](Actual_Right_Start_Date,@Movie_Closed_Date) as float) as int), 
					Right_Type ='M', Original_Right_Type = @Original_Right_Type
					WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				END
				ELSE
				BEGIN
					UPDATE Acq_Deal_Rights SET Right_End_Date = @Movie_Closed_Date, Actual_Right_End_Date = @Movie_Closed_Date, 
					Term = [dbo].[UFN_Calculate_Term](Right_Start_Date,@Movie_Closed_Date), Right_Type ='Y', Original_Right_Type = @Original_Right_Type
					WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				END

			END

			---------------------------------------Delete Run Definition for Title-------------
			UPDATE Acq_Deal_Run_Yearwise_Run SET End_Date = @Movie_Closed_Date WHERE Acq_Deal_Run_Code in (SELECT ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run_Title ADRT
			INNER JOIN Acq_Deal_Run ADR ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE Title_Code = @Title_Code 
			AND ADR.Acq_Deal_Code = @Acq_Deal_Code)
			AND @Movie_Closed_Date BETWEEN Start_Date AND End_Date

			DELETE FROM Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code in (SELECT ADR.Acq_Deal_Run_Code FROM Acq_Deal_Run_Title ADRT
			INNER JOIN Acq_Deal_Run ADR ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE Title_Code = @Title_Code 
			AND ADR.Acq_Deal_Code = @Acq_Deal_Code)
			AND End_Date > @Movie_Closed_Date

			UPDATE ADR
			SET ADR.No_Of_Runs = A.No_Of_Runs
			FROM Acq_Deal_Run ADR
			INNER JOIN 
			(SELECT SUM(ADRYR.No_Of_Runs) No_Of_Runs, ADR.Acq_Deal_Run_Code
			FROM Acq_Deal_Run_Yearwise_Run ADRYR
			INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = ADRYR.Acq_Deal_Run_Code
			INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
			WHERE ADRT.Title_Code = @Title_Code 
			AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			GROUP BY ADR.Acq_Deal_Run_Code) AS A ON A.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code
		
			---------------------------------------Complete Run Definition-------------
		END
		ELSE IF(@Movie_Closed_Date > @Right_End_Date)
		BEGIN
			IF((SELECT COUNT(*) FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code <> @Title_Code ) > 0)
			BEGIN
			
					Print 'Greater Than Rights End Date - More than 1 Title'
				
					INSERT INTO Acq_Deal_Rights(Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
						Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
						ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
						Last_Updated_Time, Last_Action_By)
					Select @Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
						Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
						ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
						Last_Updated_Time, Last_Action_By
					FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				
					SELECT @New_Acq_Deal_Rights_Code = IDENT_CURRENT('Acq_Deal_Rights')

					/**************** Insert into Acq_Deal_Rights_Title ****************/ 
					INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
					SELECT @New_Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To
					FROM Acq_Deal_Rights_Title ADRT 
					Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code

					/**************** Insert into Acq_Deal_Rights_Title_Eps ****************/ 

					INSERT INTO Acq_Deal_Rights_Title_Eps (Acq_Deal_Rights_Title_Code, EPS_No)
					SELECT 
						AtADRT.Acq_Deal_Rights_Title_Code, ADRTE.EPS_No
						FROM Acq_Deal_Rights_Title_EPS ADRTE 
						INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code
						INNER JOIN Acq_Deal_Rights_Title AtADRT On 
							CAST(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_To, '') AS VARCHAR)
							=
							CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)
							WHERE ADRT.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRT.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Platform ****************/ 

					INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)	
					SELECT @New_Acq_Deal_Rights_Code, ADRP.Platform_Code
					FROM Acq_Deal_Rights_Platform ADRP Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Territory ****************/ 

					INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)	
					SELECT @New_Acq_Deal_Rights_Code, ADRT.Territory_Code, ADRT.Territory_Type, ADRT.Country_Code
					FROM Acq_Deal_Rights_Territory ADRT Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Subtitling ****************/ 
					INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
					SELECT @New_Acq_Deal_Rights_Code, ADRS.Language_Code, ADRS.Language_Group_Code, ADRS.Language_Type
					FROM Acq_Deal_Rights_Subtitling ADRS Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Dubbing ****************/ 

					INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
					SELECT @New_Acq_Deal_Rights_Code, ADRD.Language_Code, ADRD.Language_Group_Code, ADRD.Language_Type
					FROM Acq_Deal_Rights_Dubbing ADRD Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Holdback ****************/ 

					INSERT INTO Acq_Deal_Rights_Holdback (Acq_Deal_Rights_Code, 
						Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
						Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right)
					SELECT @New_Acq_Deal_Rights_Code, 
						ADRH.Holdback_Type, ADRH.HB_Run_After_Release_No, ADRH.HB_Run_After_Release_Units, 
						ADRH.Holdback_On_Platform_Code, ADRH.Holdback_Release_Date, ADRH.Holdback_Comment, ADRH.Is_Title_Language_Right
					FROM Acq_Deal_Rights_Holdback ADRH Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Holdback_Dubbing ********/ 

					INSERT INTO Acq_Deal_Rights_Holdback_Dubbing (Acq_Deal_Rights_Holdback_Code, Language_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHD.Language_Code
					FROM Acq_Deal_Rights_Holdback_Dubbing ADRHD INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHD.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code


					/******** Insert into Acq_Deal_Rights_Holdback_Platform ********/ 

					INSERT INTO Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Code, Platform_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHP.Platform_Code
					FROM Acq_Deal_Rights_Holdback_Platform ADRHP INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON 
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '') 
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Holdback_Subtitling ********/ 
					INSERT INTO Acq_Deal_Rights_Holdback_Subtitling (Acq_Deal_Rights_Holdback_Code, Language_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHS.Language_Code
					FROM Acq_Deal_Rights_Holdback_Subtitling ADRHS INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Holdback_Territory ********/ 

					INSERT INTO Acq_Deal_Rights_Holdback_Territory (Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)
					SELECT AtADRH.Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code
					FROM Acq_Deal_Rights_Holdback_Territory ADRHT INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
						INNER JOIN Acq_Deal_Rights_Holdback AtADRH ON
							CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '') 
							=
							CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
							ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '') 
							WHERE ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/**************** Insert into Acq_Deal_Rights_Blackout ****************/ 

					INSERT INTO Acq_Deal_Rights_Blackout (Acq_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
					SELECT @New_Acq_Deal_Rights_Code, ADRB.Start_Date, ADRB.End_Date, ADRB.Inserted_By, ADRB.Inserted_On, ADRB.Last_Updated_Time, ADRB.Last_Action_By
					FROM Acq_Deal_Rights_Blackout ADRB WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Dubbing ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Code, Language_Code)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBD.Language_Code
					FROM Acq_Deal_Rights_Blackout_Dubbing ADRBD 
						INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR)
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Platform ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Code, Platform_Code)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBP.Platform_Code
					FROM Acq_Deal_Rights_Blackout_Platform ADRBP INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBP.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON 
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Subtitling ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Subtitling(Acq_Deal_Rights_Blackout_Code, Language_Code)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBS.Language_Code
					FROM Acq_Deal_Rights_Blackout_Subtitling ADRBS INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBS.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON 
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Insert into Acq_Deal_Rights_Blackout_Territory ********/ 

					INSERT INTO Acq_Deal_Rights_Blackout_Territory(Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)
					SELECT AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBT.Country_Code, ADRBT.Territory_Code, ADRBT.Territory_Type
					FROM Acq_Deal_Rights_Blackout_Territory ADRBT INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBT.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
						INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON
							CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
							=
							CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
							CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
							CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR) 
							WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

					/******** Delete Title From Old Acq_Deal_Rights_Title********/ 

					DELETE FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND Title_Code = @Title_Code 
			END
		END

	FETCH NEXT FROM crTitle INTO @Acq_Deal_Movie_Code, @Title_Code, @Movie_Closed_Date, @Acq_Deal_Rights_Code, @Right_Start_Date, @Right_End_Date, @Right_Type, @Original_Right_Type
	END
	CLOSE crTitle
	DEALLOCATE crTitle
END


--SELECT * FROM Acq_Deal_Rights
