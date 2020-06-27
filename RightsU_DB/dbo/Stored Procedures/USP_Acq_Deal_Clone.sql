-- =============================================
CREATE PROCEDURE USP_Acq_Deal_Clone 
	@New_Acq_Deal_Code int,
	@Previous_Acq_Deal_Code int,
	@Deal_Rights_Title Deal_Rights_Title  READONLY
AS
-- =============================================
-- Author:		Rajesh Godse
-- Create date: 09 April 2015
-- Description:	This USP used to clone remaining deal tables
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @New_Acq_Deal_Rights_Code INT = 0, @Acq_Deal_Rights_Code int = 0

	--Declare cursor for Rights
			DECLARE rights_cursor CURSOR FOR 
				SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Previous_Acq_Deal_Code
			OPEN rights_cursor
			FETCH NEXT FROM rights_cursor INTO @Acq_Deal_Rights_Code
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO Acq_Deal_Rights(Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
					Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
					ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
					Last_Updated_Time, Last_Action_By,Promoter_Flag)
				Select @New_Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
					Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
					ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
					Last_Updated_Time, Last_Action_By,Promoter_Flag
				From Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				
				--VALUES(@CurrIdent_AT_Acq_Deal, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, @Is_Theatrical_Right,
				--@Right_Type,@Is_Tentative,@Term,@Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, @Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date,
				--@Restriction_Remarks,@Effective_Start_Date,@Actual_Right_Start_Date,@Actual_Right_End_Date,@Inserted_By,@Inserted_On,@Last_Updated_Time,@Last_Action_By)

				SELECT @New_Acq_Deal_Rights_Code = IDENT_CURRENT('AT_Acq_Deal_Rights')

				/**************** Insert into AT_Acq_Deal_Rights_Title ****************/ 
				INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
				SELECT @New_Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To
				FROM Acq_Deal_Rights_Title ADRT 
				INNER JOIN @Deal_Rights_Title DRT ON ADRT.Acq_Deal_Rights_Code = DRT.Deal_Rights_Code AND ADRT.Acq_Deal_Rights_Title_Code = DRT.Episode_From
				Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				/**************** Insert into AT_Acq_Deal_Rights_Title_Eps ****************/ 

				INSERT INTO Acq_Deal_Rights_Title_Eps (
					Acq_Deal_Rights_Title_Code, EPS_No)
				SELECT
					AtADRT.Acq_Deal_Rights_Title_Code, ADRTE.EPS_No
					FROM Acq_Deal_Rights_Title_EPS ADRTE 
					INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code
					INNER JOIN @Deal_Rights_Title DRT ON ADRT.Acq_Deal_Rights_Code = DRT.Deal_Rights_Code AND ADRT.Acq_Deal_Rights_Title_Code = DRT.Episode_From
					INNER JOIN Acq_Deal_Rights_Title AtADRT On 
						CAST(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_To, '') AS VARCHAR)
						=
						CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)
						WHERE ADRT.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRT.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

				/**************** Insert into AT_Acq_Deal_Rights_Platform ****************/ 

				INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)	
				SELECT @New_Acq_Deal_Rights_Code, ADRP.Platform_Code
				FROM Acq_Deal_Rights_Platform ADRP Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				/**************** Insert into AT_Acq_Deal_Rights_Territory ****************/ 

				INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)	
				SELECT @New_Acq_Deal_Rights_Code, ADRT.Territory_Code, ADRT.Territory_Type, ADRT.Country_Code
				FROM Acq_Deal_Rights_Territory ADRT Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				/**************** Insert into AT_Acq_Deal_Rights_Subtitling ****************/ 
				INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
				SELECT @New_Acq_Deal_Rights_Code, ADRS.Language_Code, ADRS.Language_Group_Code, ADRS.Language_Type
				FROM Acq_Deal_Rights_Subtitling ADRS Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				/**************** Insert into AT_Acq_Deal_Rights_Dubbing ****************/ 

				INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
				SELECT @New_Acq_Deal_Rights_Code, ADRD.Language_Code, ADRD.Language_Group_Code, ADRD.Language_Type
				FROM Acq_Deal_Rights_Dubbing ADRD Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				/**************** Insert into AT_Acq_Deal_Rights_Holdback ****************/ 

				INSERT INTO Acq_Deal_Rights_Holdback (Acq_Deal_Rights_Code, 
					Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
					Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right)
				SELECT @New_Acq_Deal_Rights_Code, 
					ADRH.Holdback_Type, ADRH.HB_Run_After_Release_No, ADRH.HB_Run_After_Release_Units, 
					ADRH.Holdback_On_Platform_Code, ADRH.Holdback_Release_Date, ADRH.Holdback_Comment, ADRH.Is_Title_Language_Right
				FROM Acq_Deal_Rights_Holdback ADRH Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				/******** Insert into AT_Acq_Deal_Rights_Holdback_Dubbing ********/ 

				INSERT INTO Acq_Deal_Rights_Holdback_Dubbing (
					Acq_Deal_Rights_Holdback_Code, Language_Code)
				SELECT
					AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHD.Language_Code
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


				/******** Insert into AT_Acq_Deal_Rights_Holdback_Platform ********/ 

				INSERT INTO Acq_Deal_Rights_Holdback_Platform (
					Acq_Deal_Rights_Holdback_Code, Platform_Code)
				SELECT
					AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHP.Platform_Code
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

				/******** Insert into AT_Acq_Deal_Rights_Holdback_Subtitling ********/ 
				INSERT INTO Acq_Deal_Rights_Holdback_Subtitling (
					Acq_Deal_Rights_Holdback_Code, Language_Code)
				SELECT
					AtADRH.Acq_Deal_Rights_Holdback_Code, ADRHS.Language_Code
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

				/******** Insert into AT_Acq_Deal_Rights_Holdback_Territory ********/ 

				INSERT INTO Acq_Deal_Rights_Holdback_Territory (
					Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)
				SELECT
					AtADRH.Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code
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

				/**************** Insert into AT_Acq_Deal_Rights_Blackout ****************/ 

				INSERT INTO Acq_Deal_Rights_Blackout (
					Acq_Deal_Rights_Code, 
					Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
				SELECT 
					@New_Acq_Deal_Rights_Code, 
					ADRB.Start_Date, ADRB.End_Date, ADRB.Inserted_By, ADRB.Inserted_On, ADRB.Last_Updated_Time, ADRB.Last_Action_By
				FROM Acq_Deal_Rights_Blackout ADRB WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

				/******** Insert into AT_Acq_Deal_Rights_Blackout_Dubbing ********/ 

				INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (
					Acq_Deal_Rights_Blackout_Code, Language_Code)
				SELECT
					AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBD.Language_Code
				FROM Acq_Deal_Rights_Blackout_Dubbing ADRBD INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
					INNER JOIN Acq_Deal_Rights_Blackout AtADRB ON
						CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
						CAST(ISNULL(AtADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRB.Last_Updated_Time, '') AS VARCHAR) 
						=
						CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +
						CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  + '~' + 
						CAST(ISNULL(ADRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRB.Last_Updated_Time, '') AS VARCHAR)
						WHERE ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

				/******** Insert into AT_Acq_Deal_Rights_Blackout_Platform ********/ 

				INSERT INTO Acq_Deal_Rights_Blackout_Platform (
					Acq_Deal_Rights_Blackout_Code, Platform_Code)
				SELECT
					AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBP.Platform_Code
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

				/******** Insert into AT_Acq_Deal_Rights_Blackout_Subtitling ********/ 

				INSERT INTO Acq_Deal_Rights_Blackout_Subtitling(
					Acq_Deal_Rights_Blackout_Code, Language_Code)
				SELECT
					AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBS.Language_Code
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

				/******** Insert into AT_Acq_Deal_Rights_Blackout_Territory ********/ 

				INSERT INTO Acq_Deal_Rights_Blackout_Territory(
					Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)
				SELECT
					AtADRB.Acq_Deal_Rights_Blackout_Code, ADRBT.Country_Code, ADRBT.Territory_Code, ADRBT.Territory_Type
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


	/**************** Insert into AT_Acq_Deal_Rights_Promoter****************/ 

				INSERT INTO Acq_Deal_Rights_Promoter (
					Acq_Deal_Rights_Code, 
					 Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
				SELECT 
					@New_Acq_Deal_Rights_Code,
					 ADRP.Inserted_By, ADRP.Inserted_On, ADRP.Last_Updated_Time, ADRP.Last_Action_By
				FROM Acq_Deal_Rights_Promoter ADRP WHERE ADRP.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

	/******** Insert into AT_Acq_Deal_Rights_Promoter_Group ********/ 

				INSERT INTO Acq_Deal_Rights_Promoter_Group (
					Acq_Deal_Rights_Promoter_Code, Promoter_Group_Code)
				SELECT
					AtADRP.Acq_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code
				FROM Acq_Deal_Rights_Promoter_Group ADRPG INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					INNER JOIN Acq_Deal_Rights_Promoter AtADRP ON
						CAST(ISNULL(AtADRP.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRP.Inserted_On, '') AS VARCHAR)  + '~' + 
						CAST(ISNULL(AtADRP.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtADRP.Last_Updated_Time, '') AS VARCHAR) 
						=
						CAST(ISNULL(ADRP.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRP.Inserted_On, '') AS VARCHAR)  + '~' + 
						CAST(ISNULL(ADRP.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(ADRP.Last_Updated_Time, '') AS VARCHAR)
						WHERE ADRP.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND AtADRP.Acq_Deal_Rights_Code = @New_Acq_Deal_Rights_Code

				FETCH NEXT FROM rights_cursor INTO @Acq_Deal_Rights_Code

			END
			CLOSE rights_cursor;
			DEALLOCATE rights_cursor;

			Select 'Success' As Result


END