﻿CREATE PROCEDURE [dbo].[USP_Syn_Termination_UDT] 
	@Termination_Deals Termination_Deals  READONLY,
	@Login_User_Code INT
AS
---- =============================================
---- Author:		Abhaysingh N. Rajpurohit
---- Create date:	17 November 2015
---- Description:	This USP used to clone remaining deal tables
---- =============================================
---- Modification
---- =============================================
---- Task id         |     Updated By            |     Updated On       |    Description
---- 4215				 Navin Sapalya				   01 Dec 2015         Modified if condition for termination date less than Rights start date
---- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Termination_UDT]', 'Step 1', 0, 'Started Procedure', 0, '' 
		/*

		Condition-1 :	If Movie Termination Date is < Syn Rights Start Date    
							Rights have one Title	=  Delete the Rights
							Rights have more than one Title	=  Remove the Title Rights

		Condition-2 :	If Movie Termination Date is between Syn Rights Period  
							Rights have one Title	=  Update the Rights End Date
							Rights have more than one Title	=  Create another Rights for that Title with Updated Rights end date and remove that title from original right

		Condition-3 :	If Movie Closed Date is > Syn Rights End Date 
							Remove Title Whose Episode From greater then Termination Episode No.

		*/

		SET NOCOUNT ON;

		--DECLARE @Termination_Deals Termination_Deals, @Login_User_Code INT = 143
		--INSERT INTO @Termination_Deals(Deal_Code, Title_Code, Termination_Episode_No, Termination_Date)
		--VALUES(46, 6517, 90, NULL),
		--(46, 6521, NULL, '2016-03-21 00:00:00.000'),
		--(46, 8423, 90, NULL)

		IF(OBJECT_ID('TEMPDB..#Termination_Deals_Status') IS NOT NULL)
			DROP TABLE #Termination_Deals_Status

		CREATE TABLE #Termination_Deals_Status
		(
			Deal_Code INT,
			Title_Code INT,
			Episode_No INT,
			Termination_Date DATETIME,
			Is_Error CHAR(1),
			Error_Details NVARCHAR(MAX)
		)

		INSERT INTO #Termination_Deals_Status(Deal_Code, Title_Code, Episode_No, Termination_Date)
		SELECT ISNULL(Deal_Code,0) AS Deal_Code, ISNULL(Title_Code, 0) AS Title_Code, ISNULL(Termination_Episode_No, 0) AS Termination_Episode_No, Termination_Date 
		FROM @Termination_Deals

		DECLARE @Deal_Code INT, @Title_Code INT, @Episode_No INT, @Termination_Date DATETIME

		DECLARE @lastDealCode INT = 0
		DECLARE cursorTermination_Deals CURSOR FOR
		SELECT Deal_Code, Title_Code, Episode_No, Termination_Date  FROM #Termination_Deals_Status

		OPEN cursorTermination_Deals
		FETCH NEXT FROM cursorTermination_Deals INTO @Deal_Code, @Title_Code, @Episode_No, @Termination_Date

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT '@Deal_Code : ' + CAST(@Deal_Code AS VARCHAR)
			PRINT '@Title_Code : ' + CAST(@Title_Code AS VARCHAR)
			PRINT '@Episode_No : ' + CAST(@Episode_No AS VARCHAR)
			PRINT '@Termination_Date : ' + CAST(@Termination_Date AS VARCHAR)
			DECLARE @Syn_Deal_Rights_Code INT, @Right_Start_Date DATETIME, @Right_End_Date DATETIME, @Right_Type varchar(2), @SDRun_Code VARCHAR(MAX) = ''
			DECLARE @New_Syn_Deal_Rights_Code INT, @SDRTCode INT = 0
		
			DECLARE cursorRights CURSOR FOR
			SELECT SDR.Syn_Deal_Rights_Code, SDR.Actual_Right_Start_Date, ISNULL(SDR.Actual_Right_End_Date, '9999-12-31'), SDR.Right_Type FROM Syn_Deal_Rights SDR (NOLOCK)
			INNER JOIN Syn_Deal_Rights_Title SDRT (NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
				AND SDR.Syn_Deal_Code = @Deal_Code AND (SDRT.Title_Code = @Title_Code Or @Title_Code = 0)
			WHERE (Right_Type IN ('Y', 'U') OR (Right_Type = 'M' AND SDR.Actual_Right_End_Date IS NOT NULL)) 
				AND ((@Episode_No < SDRT.Episode_To AND @Episode_No > 0) OR  @Termination_Date < ISNULL(SDR.Actual_Right_End_Date, '9999-12-31'))
			OPEN cursorRights
			FETCH NEXT FROM cursorRights INTO @Syn_Deal_Rights_Code, @Right_Start_Date, @Right_End_Date, @Right_Type
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @titleCount INT = 0, @minEpisodeFrom INT = 0, @maxEpisodeTo INT = 0
				
				SELECT @titleCount = COUNT( DISTINCT Title_Code) FROM Syn_Deal_Rights_Title (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
				AND Title_Code <> @Title_Code

				SELECT @minEpisodeFrom  = MIN(Episode_From) FROM Syn_Deal_Rights_Title (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
				AND (Title_Code = @Title_Code OR @Title_Code = 0)

				SELECT @maxEpisodeTo  = MAX(Episode_To) FROM Syn_Deal_Rights_Title (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
				AND (Title_Code = @Title_Code OR @Title_Code = 0)

				PRINT '@Syn_Deal_Rights_Code : ' + CAST(@Syn_Deal_Rights_Code AS VARCHAR)
				PRINT '@titleCount : ' + CAST(@titleCount AS VARCHAR)
				PRINT '@minEpisodeFrom : ' + CAST(@minEpisodeFrom AS VARCHAR)
				PRINT '@@maxEpisodeTo : ' + CAST(@maxEpisodeTo AS VARCHAR)
				PRINT '@Right_Start_Date : ' + CAST(@Right_Start_Date AS VARCHAR)
				PRINT '@Right_End_Date : ' + CAST(@Right_End_Date AS VARCHAR)

				IF(	
					(@Termination_Date < @Right_Start_Date AND @Termination_Date IS NOT NULL) OR 
					(@minEpisodeFrom > @Episode_No AND @Episode_No > 0)
				)
				BEGIN
					IF(@Title_Code = 0 OR @titleCount = 0)
					BEGIN
						PRINT 'Condition A(1) :-
								Delete this Rights because,
								1. We are termination All titles (when @Title_Code = 0) or 
								2. This Rights contains only one title (when @titleCount = 0) which we are terminating'
						
						--- Holdback ---
						DELETE FROM Syn_Deal_Rights_Holdback_Platform WHERE Syn_Deal_Rights_Holdback_Code IN
						(
							SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						)
						DELETE FROM Syn_Deal_Rights_Holdback_Territory WHERE Syn_Deal_Rights_Holdback_Code IN
						(
							SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						) 
						DELETE FROM Syn_Deal_Rights_Holdback_Dubbing WHERE Syn_Deal_Rights_Holdback_Code IN
						(
							SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						)
						DELETE FROM Syn_Deal_Rights_Holdback_Subtitling WHERE Syn_Deal_Rights_Holdback_Code IN
						(
							SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						) 
						DELETE FROM Syn_Deal_Rights_Holdback WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

						--- Blackout ---
						DELETE FROM Syn_Deal_Rights_Blackout_Platform WHERE Syn_Deal_Rights_Blackout_Code IN
						(
							SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						) 
						DELETE FROM Syn_Deal_Rights_Blackout_Territory WHERE Syn_Deal_Rights_Blackout_Code IN
						(
							SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						) 
						DELETE FROM Syn_Deal_Rights_Blackout_Dubbing WHERE Syn_Deal_Rights_Blackout_Code IN
						(
							SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout (NOLOCK) 	WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						)
						DELETE FROM Syn_Deal_Rights_Blackout_Subtitling WHERE Syn_Deal_Rights_Blackout_Code IN
						(
							SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						) 
						DELETE FROM Syn_Deal_Rights_Blackout WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
	
						--- Rights ---
						DELETE FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						DELETE FROM Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						DELETE FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						DELETE FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						DELETE FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						DELETE FROM Syn_Deal_Rights  WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

						--- Complete Rights ---

					END
					ELSE
					BEGIN
						PRINT 'Condition A(2) :-
							Delete current title from this rights because,
							1. This Rights contains more then one title (when @titleCount > 0)'
							
						DELETE FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Title_Code = @Title_Code 
						
					END
				END
				ELSE IF(
					(@Termination_Date >= @Right_Start_Date AND @Termination_Date <= @Right_End_Date) OR 
					(@minEpisodeFrom < @Episode_No AND  @maxEpisodeTo > @Episode_No AND @Episode_No > 0)
				)
				BEGIN
					IF(@Termination_Date IS NULL OR (@Termination_Date >= @Right_End_Date AND @Termination_Date IS NOT NULL))
					BEGIN
						PRINT 'Condition B(1) :-
										Change Only Episode No,'

						UPDATE Syn_Deal_Rights_Title SET Episode_To = @Episode_No
						Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
						AND Title_Code = @Title_Code AND @Episode_No BETWEEN Episode_From AND Episode_To

						DELETE SDRTE FROM Syn_Deal_Rights_Title_EPS SDRTE 
						INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRTE.Syn_Deal_Rights_Title_Code = SDRT.Syn_Deal_Rights_Title_Code AND
						SDRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND SDRTE.EPS_No > @Episode_No
						AND SDRT.Title_Code = @Title_Code AND @Episode_No BETWEEN SDRT.Episode_From AND SDRT.Episode_To
					END
					ELSE
					BEGIN
						IF(@Title_Code = 0 OR @titleCount = 0)
						BEGIN
							PRINT 'Condition B(2) :-
									Change Rights End Date,
									1. We are termination All titles (when @Title_Code = 0) or 
									2. This Rights contains only one title (when @titleCount = 0) which we are terminating'

							IF(@Right_Type = 'M')
							BEGIN
								--UPDATE Syn_Deal_Rights SET Actual_Right_End_Date = @Termination_Date, 
								--Milestone_No_Of_Unit = CAST(CAST([dbo].[UFN_Calculate_Term](Actual_Right_Start_Date,@Termination_Date) as float) as int), Right_Type ='M'
								--WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

								UPDATE Syn_Deal_Rights SET Actual_Right_End_Date = @Termination_Date, 
								Term = [dbo].[UFN_Calculate_Term](Right_Start_Date,@Termination_Date), Right_Type ='M'
								WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
							END
							ELSE
							BEGIN
								UPDATE Syn_Deal_Rights SET Right_End_Date = @Termination_Date, Actual_Right_End_Date = @Termination_Date, 
								Term = [dbo].[UFN_Calculate_Term](Right_Start_Date,@Termination_Date), Right_Type ='Y'
								WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
							END

							UPDATE Syn_Deal_Rights_Title SET Episode_To = @Episode_No
							Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
							AND @Episode_No BETWEEN Episode_From AND Episode_To AND @Episode_No > 0

							DELETE SDRTE FROM Syn_Deal_Rights_Title_EPS SDRTE
							INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRTE.Syn_Deal_Rights_Title_Code = SDRT.Syn_Deal_Rights_Title_Code AND
							SDRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND SDRTE.EPS_No > @Episode_No
							AND @Episode_No BETWEEN SDRT.Episode_From AND SDRT.Episode_To AND @Episode_No > 0
						END
						ELSE
						BEGIN
							PRINT 'Condition B(3) :-
									Added New Rights for Current Title'
						
							PRINT 'Inserting in Syn_Deal_Rights'
							INSERT INTO Syn_Deal_Rights(Syn_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
								Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
								ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, 
								Last_Updated_Time, Last_Action_By)
							Select @Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right,
								'Y', Is_Tentative, Term, Right_Start_Date, @Termination_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR,
								ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, @Termination_Date, Inserted_By, Inserted_On, 
								Last_Updated_Time, Last_Action_By
							FROM Syn_Deal_Rights (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
							PRINT 'Inserted in Syn_Deal_Rights'
				
							SELECT @New_Syn_Deal_Rights_Code = IDENT_CURRENT('Syn_Deal_Rights')

							/**************** Insert into Syn_Deal_Rights_Title ****************/ 
							PRINT 'Inserting in Syn_Deal_Rights_Title'
							INSERT INTO Syn_Deal_Rights_Title (Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
							SELECT @New_Syn_Deal_Rights_Code, SDRT.Title_Code, SDRT.Episode_From, 
							CASE WHEN @Episode_No < SDRT.Episode_To AND @Episode_No > 0 THEN @Episode_No ELSE SDRT.Episode_To END AS Episode_To
							FROM Syn_Deal_Rights_Title SDRT  (NOLOCK)
							Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Title_Code = @Title_Code AND (Episode_To <= @Episode_No OR @Episode_No = 0)
							PRINT 'Inserted in Syn_Deal_Rights_Title'
							/**************** Insert into Syn_Deal_Rights_Title_Eps ****************/ 
							PRINT 'Inserting in Syn_Deal_Rights_Title_Eps'
							INSERT INTO Syn_Deal_Rights_Title_Eps (Syn_Deal_Rights_Title_Code, EPS_No)
							SELECT 
								AtSDRT.Syn_Deal_Rights_Title_Code, SDRTE.EPS_No
								FROM Syn_Deal_Rights_Title_EPS SDRTE  (NOLOCK)
								INNER JOIN Syn_Deal_Rights_Title SDRT (NOLOCK) ON SDRTE.Syn_Deal_Rights_Title_Code = SDRT.Syn_Deal_Rights_Title_Code
								INNER JOIN Syn_Deal_Rights_Title AtSDRT  (NOLOCK) On 
									CAST(ISNULL(AtSDRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtSDRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtSDRT.Episode_To, '') AS VARCHAR)
									=
									CAST(ISNULL(SDRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(SDRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(SDRT.Episode_To, '') AS VARCHAR)
									WHERE SDRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRT.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code
									AND SDRTE.EPS_No <= @Episode_No
							PRINT 'Inserted in Syn_Deal_Rights_Title_Eps'
							/**************** Insert into Syn_Deal_Rights_Platform ****************/ 

							INSERT INTO Syn_Deal_Rights_Platform (Syn_Deal_Rights_Code, Platform_Code)	
							SELECT @New_Syn_Deal_Rights_Code, SDRP.Platform_Code
							FROM Syn_Deal_Rights_Platform SDRP (NOLOCK) Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

							/**************** Insert into Syn_Deal_Rights_Territory ****************/ 

							INSERT INTO Syn_Deal_Rights_Territory (Syn_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)	
							SELECT @New_Syn_Deal_Rights_Code, SDRT.Territory_Code, SDRT.Territory_Type, SDRT.Country_Code
							FROM Syn_Deal_Rights_Territory SDRT (NOLOCK) Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

							/**************** Insert into Syn_Deal_Rights_Subtitling ****************/ 
							INSERT INTO Syn_Deal_Rights_Subtitling (Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
							SELECT @New_Syn_Deal_Rights_Code, SDRS.Language_Code, SDRS.Language_Group_Code, SDRS.Language_Type
							FROM Syn_Deal_Rights_Subtitling SDRS (NOLOCK) Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

							/**************** Insert into Syn_Deal_Rights_Dubbing ****************/ 

							INSERT INTO Syn_Deal_Rights_Dubbing (Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)	
							SELECT @New_Syn_Deal_Rights_Code, SDRD.Language_Code, SDRD.Language_Group_Code, SDRD.Language_Type
							FROM Syn_Deal_Rights_Dubbing SDRD (NOLOCK) Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

							/**************** Insert into Syn_Deal_Rights_Holdback ****************/ 

							INSERT INTO Syn_Deal_Rights_Holdback (Syn_Deal_Rights_Code, 
								Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
								Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment)
							SELECT @New_Syn_Deal_Rights_Code, 
								SDRH.Holdback_Type, SDRH.HB_Run_After_Release_No, SDRH.HB_Run_After_Release_Units, 
								SDRH.Holdback_On_Platform_Code, SDRH.Holdback_Release_Date, SDRH.Holdback_Comment
							FROM Syn_Deal_Rights_Holdback SDRH (NOLOCK) Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

							/******** Insert into Syn_Deal_Rights_Holdback_Dubbing ********/ 

							INSERT INTO Syn_Deal_Rights_Holdback_Dubbing (Syn_Deal_Rights_Holdback_Code, Language_Code)
							SELECT AtSDRH.Syn_Deal_Rights_Holdback_Code, SDRHD.Language_Code
							FROM Syn_Deal_Rights_Holdback_Dubbing SDRHD (NOLOCK) INNER JOIN Syn_Deal_Rights_Holdback SDRH (NOLOCK) ON SDRHD.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
								INNER JOIN Syn_Deal_Rights_Holdback AtSDRH (NOLOCK) ON
									CAST(ISNULL(AtSDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(AtSDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtSDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.Holdback_Type, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(SDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '')
									WHERE SDRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRH.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code


							/******** Insert into Syn_Deal_Rights_Holdback_Platform ********/ 

							INSERT INTO Syn_Deal_Rights_Holdback_Platform (Syn_Deal_Rights_Holdback_Code, Platform_Code)
							SELECT AtSDRH.Syn_Deal_Rights_Holdback_Code, SDRHP.Platform_Code
							FROM Syn_Deal_Rights_Holdback_Platform SDRHP (NOLOCK) INNER JOIN Syn_Deal_Rights_Holdback SDRH (NOLOCK) ON SDRHP.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
								INNER JOIN Syn_Deal_Rights_Holdback AtSDRH (NOLOCK) ON 
									CAST(ISNULL(AtSDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(AtSDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtSDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.Holdback_Type, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(SDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '')
									WHERE SDRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRH.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code

							/******** Insert into Syn_Deal_Rights_Holdback_Subtitling ********/ 
							INSERT INTO Syn_Deal_Rights_Holdback_Subtitling (Syn_Deal_Rights_Holdback_Code, Language_Code)
							SELECT AtSDRH.Syn_Deal_Rights_Holdback_Code, SDRHS.Language_Code
							FROM Syn_Deal_Rights_Holdback_Subtitling SDRHS (NOLOCK) INNER JOIN Syn_Deal_Rights_Holdback SDRH (NOLOCK) ON SDRHS.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
								INNER JOIN Syn_Deal_Rights_Holdback AtSDRH  (NOLOCK) ON
									CAST(ISNULL(AtSDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(AtSDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtSDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.Holdback_Type, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(SDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '')
									WHERE SDRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRH.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code

							/******** Insert into Syn_Deal_Rights_Holdback_Territory ********/ 

							INSERT INTO Syn_Deal_Rights_Holdback_Territory (Syn_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)
							SELECT AtSDRH.Syn_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code
							FROM Syn_Deal_Rights_Holdback_Territory SDRHT (NOLOCK) INNER JOIN Syn_Deal_Rights_Holdback SDRH (NOLOCK) ON SDRHT.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
								INNER JOIN Syn_Deal_Rights_Holdback AtSDRH (NOLOCK) ON
									CAST(ISNULL(AtSDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(AtSDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtSDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtSDRH.Holdback_Type, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(SDRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '')
									WHERE SDRH.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRH.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code

							/**************** Insert into Syn_Deal_Rights_Blackout ****************/ 

							INSERT INTO Syn_Deal_Rights_Blackout (Syn_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
							SELECT @New_Syn_Deal_Rights_Code, SDRB.Start_Date, SDRB.End_Date, SDRB.Inserted_By, SDRB.Inserted_On, SDRB.Last_Updated_Time, SDRB.Last_Action_By
							FROM Syn_Deal_Rights_Blackout SDRB (NOLOCK) WHERE SDRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

							/******** Insert into Syn_Deal_Rights_Blackout_Dubbing ********/ 

							INSERT INTO Syn_Deal_Rights_Blackout_Dubbing (Syn_Deal_Rights_Blackout_Code, Language_Code)
							SELECT AtSDRB.Syn_Deal_Rights_Blackout_Code, SDRBD.Language_Code
							FROM Syn_Deal_Rights_Blackout_Dubbing SDRBD  (NOLOCK)
								INNER JOIN Syn_Deal_Rights_Blackout SDRB (NOLOCK) ON SDRBD.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code
								INNER JOIN Syn_Deal_Rights_Blackout AtSDRB (NOLOCK) ON
									CAST(ISNULL(AtSDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(AtSDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtSDRB.Last_Updated_Time, '') AS VARCHAR) 
									=
									CAST(ISNULL(SDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(SDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(SDRB.Last_Updated_Time, '') AS VARCHAR)
									WHERE SDRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRB.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code

							/******** Insert into Syn_Deal_Rights_Blackout_Platform ********/ 

							INSERT INTO Syn_Deal_Rights_Blackout_Platform (Syn_Deal_Rights_Blackout_Code, Platform_Code)
							SELECT AtSDRB.Syn_Deal_Rights_Blackout_Code, SDRBP.Platform_Code
							FROM Syn_Deal_Rights_Blackout_Platform SDRBP (NOLOCK) INNER JOIN Syn_Deal_Rights_Blackout SDRB (NOLOCK) ON SDRBP.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code
								INNER JOIN Syn_Deal_Rights_Blackout AtSDRB (NOLOCK) ON 
									CAST(ISNULL(AtSDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(AtSDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtSDRB.Last_Updated_Time, '') AS VARCHAR) 
									=
									CAST(ISNULL(SDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(SDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(SDRB.Last_Updated_Time, '') AS VARCHAR) 
									WHERE SDRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRB.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code

							/******** Insert into Syn_Deal_Rights_Blackout_Subtitling ********/ 

							INSERT INTO Syn_Deal_Rights_Blackout_Subtitling(Syn_Deal_Rights_Blackout_Code, Language_Code)
							SELECT AtSDRB.Syn_Deal_Rights_Blackout_Code, SDRBS.Language_Code
							FROM Syn_Deal_Rights_Blackout_Subtitling SDRBS (NOLOCK) INNER JOIN Syn_Deal_Rights_Blackout SDRB (NOLOCK) ON SDRBS.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code
								INNER JOIN Syn_Deal_Rights_Blackout AtSDRB (NOLOCK) ON 
									CAST(ISNULL(AtSDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(AtSDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtSDRB.Last_Updated_Time, '') AS VARCHAR) 
									=
									CAST(ISNULL(SDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(SDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(SDRB.Last_Updated_Time, '') AS VARCHAR) 
									WHERE SDRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRB.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code

							/******** Insert into Syn_Deal_Rights_Blackout_Territory ********/ 

							INSERT INTO Syn_Deal_Rights_Blackout_Territory(Syn_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)
							SELECT AtSDRB.Syn_Deal_Rights_Blackout_Code, SDRBT.Country_Code, SDRBT.Territory_Code, SDRBT.Territory_Type
							FROM Syn_Deal_Rights_Blackout_Territory SDRBT (NOLOCK) INNER JOIN Syn_Deal_Rights_Blackout SDRB (NOLOCK) ON SDRBT.Syn_Deal_Rights_Blackout_Code = SDRB.Syn_Deal_Rights_Blackout_Code
								INNER JOIN Syn_Deal_Rights_Blackout AtSDRB (NOLOCK) ON
									CAST(ISNULL(AtSDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(AtSDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtSDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(AtSDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(AtSDRB.Last_Updated_Time, '') AS VARCHAR) 
									=
									CAST(ISNULL(SDRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.End_Date, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(SDRB.Inserted_On, '') AS VARCHAR)  + '~' + 
									CAST(ISNULL(SDRB.Last_Action_By, '') AS VARCHAR)  + '~' + CAST(ISNULL(SDRB.Last_Updated_Time, '') AS VARCHAR) 
									WHERE SDRB.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND AtSDRB.Syn_Deal_Rights_Code = @New_Syn_Deal_Rights_Code

							/******** Delete Title From Old Syn_Deal_Rights_Title********/ 

							DELETE FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Title_Code = @Title_Code 
						
						END
					END
				END
				--- *** Delete/ Update Run Definition for Title ***
				IF (@Title_Code > 0)
				BEGIN
					---* If Run Def is added for that title whose Episode_From is greater then Termination_Episode No.
					SET @SDRun_Code = ''
					SELECT @SDRun_Code = @SDRun_Code + CAST(SDR.Syn_Deal_Run_Code AS VARCHAR) + ',' FROM Syn_Deal_Run SDR (NOLOCK)
					WHERE SDR.Syn_Deal_Code = @Deal_Code AND SDR.Title_Code = @Title_Code AND SDR.Episode_From > @Episode_No AND @Episode_No > 0
					
					DELETE FROM Syn_Deal_Run_Repeat_On_Day WHERE Syn_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@SDRun_Code, ','))
					DELETE FROM Syn_Deal_Run_Yearwise_Run WHERE Syn_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@SDRun_Code, ','))
					DELETE FROM Syn_Deal_Run_Platform WHERE Syn_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@SDRun_Code, ','))
					DELETE FROM Syn_Deal_Run WHERE Syn_Deal_Run_Code IN (SELECT DISTINCT number from dbo.fn_Split_withdelemiter(@SDRun_Code, ','))
				END

				IF(OBJECT_ID('TEMPDB..#TEMP_Run_Def') IS NOT NULL)
					DROP TABLE #TEMP_Run_Def

				SELECT DISTINCT SDRun.Syn_Deal_Run_Code, ISNULL(No_Of_Runs, 0) AS No_Of_Runs, ISNULL(Is_Yearwise_Definition, 'N') AS Is_Year_Based, 
				'N' AS Process_Done INTO #TEMP_Run_Def FROM Syn_Deal_Run SDRun (NOLOCK)
				WHERE SDRun.Syn_Deal_Code =@Deal_Code AND (SDRun.Title_Code = @Title_Code OR @Title_Code = 0)

				DECLARE @Syn_Deal_Run_Code INT = 0, @No_Of_Run_Old INT = 0, @No_Of_Run_New INT = 0, @isYearBased CHAR(1)

				WHILE(@Syn_Deal_Run_Code > 0)
				BEGIN
					IF(@Termination_Date IS NULL OR (@Termination_Date >= @Right_End_Date AND @Termination_Date IS NOT NULL))
					BEGIN
						UPDATE Syn_Deal_Run SET Episode_To =  @Episode_No
						WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code
						AND Title_Code = @Title_Code AND (@Episode_No BETWEEN Episode_From AND Episode_To)
						AND @Episode_No > 0
					END
					ELSE
					BEGIN
						IF(@isYearBased = 'Y' AND @isYearBased <> '')
						BEGIN
							DELETE FROM Syn_Deal_Run_Yearwise_Run 
							WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code AND [Start_Date] > @Termination_Date

							IF NOT EXISTS (SELECT * FROM Syn_Deal_Run_Yearwise_Run WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code)
							BEGIN
								DELETE FROM Syn_Deal_Run_Repeat_On_Day WHERE Syn_Deal_Run_Code IN (@Syn_Deal_Run_Code)
								DELETE FROM Syn_Deal_Run_Yearwise_Run WHERE Syn_Deal_Run_Code IN (@Syn_Deal_Run_Code)
								DELETE FROM Syn_Deal_Run_Platform WHERE Syn_Deal_Run_Code IN (@Syn_Deal_Run_Code)
								DELETE FROM Syn_Deal_Run WHERE Syn_Deal_Run_Code IN (@Syn_Deal_Run_Code)
							END
							ELSE
							BEGIN
								UPDATE Syn_Deal_Run SET Episode_To =  @Episode_No
								WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code
								AND Title_Code = @Title_Code AND (@Episode_No BETWEEN Episode_From AND Episode_To)
								AND @Episode_No > 0

								UPDATE Syn_Deal_Run_Yearwise_Run SET End_Date = @Termination_Date WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code
								AND @Termination_Date BETWEEN Start_Date AND End_Date

								SELECT @No_Of_Run_New = SUM(ISNULL(No_Of_Runs, 0)) FROM Syn_Deal_Run_Yearwise_Run (NOLOCK) WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code
								IF(@No_Of_Run_New <> @No_Of_Run_Old)
								BEGIN
									UPDATE Syn_Deal_Run SET No_Of_Runs = @No_Of_Run_New WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code
								END
							END
						END
					END

					----- Loop Syntax ----
					UPDATE #TEMP_Run_Def SET Process_Done = 'Y' WHERE Syn_Deal_Run_Code = @Syn_Deal_Run_Code
					SELECT @Syn_Deal_Run_Code = 0, @No_Of_Run_Old =0, @isYearBased = ''

					SELECT TOP 1 @Syn_Deal_Run_Code = Syn_Deal_Run_Code, @No_Of_Run_Old = No_Of_Runs, @isYearBased = Is_Year_Based
					FROM #TEMP_Run_Def WHERE Process_Done = 'N'
				END

				FETCH NEXT FROM cursorRights INTO @Syn_Deal_Rights_Code, @Right_Start_Date, @Right_End_Date, @Right_Type
			END
			CLOSE cursorRights
			DEALLOCATE cursorRights

			IF(@Title_Code <> 0)
			BEGIN
				DELETE FROM Syn_Deal_Movie WHERE Syn_Deal_Code = @Deal_Code AND Title_Code = @Title_Code AND Episode_From > @Episode_No AND @Episode_No > 0

				UPDATE Syn_Deal_Movie SET Episode_End_To = @Episode_No WHERE Syn_Deal_Code = @Deal_Code AND Title_Code = @Title_Code
				AND (@Episode_No  BETWEEN Episode_From AND Episode_End_To) AND @Episode_No > 0
			END
			

			UPDATE #Termination_Deals_Status SET Is_Error = 'N'
			WHERE Deal_Code = @Deal_Code AND Title_Code = @Title_Code

			UPDATE Syn_Deal SET Deal_Workflow_Status = 'N', [Status] = 'T', [Version] = RIGHT( '000' + CAST(Cast([Version] AS INT) + 1 AS VARCHAR), 4),
			Last_Action_By = @Login_User_Code, Last_Updated_Time=GETDATE() 
			 WHERE Syn_Deal_Code = @Deal_Code

			IF(@lastDealCode != @Deal_Code OR @lastDealCode = 0)
			BEGIN
				IF(@lastDealCode <> 0)
				BEGIN
					EXEC USP_Assign_Workflow @lastDealCode, 35, @Login_User_Code
				END

				SET @lastDealCode = @Deal_Code
			END

			IF(OBJECT_ID('TEMPDB..#RunDef') IS NOT NULL)
					DROP TABLE #RunDef

			IF(OBJECT_ID('TEMPDB..#RunDef_Delete') IS NOT NULL)
					DROP TABLE #RunDef_Delete

			SELECT DISTINCT SDRun.Syn_Deal_Run_Code INTO #RunDef FROM Syn_Deal_Run SDRun (NOLOCK)
			INNER JOIN Syn_Deal_Run_Platform SDRunP (NOLOCK) ON SDRun.Syn_Deal_Run_Code = SDRunP.Syn_Deal_Run_Code 
			AND SDRun.Syn_Deal_Code = @Deal_Code
			INNER JOIN Syn_Deal_Rights SDR (NOLOCK) ON SDR.Syn_Deal_Code = SDRun.Syn_Deal_Code
			INNER JOIN Syn_Deal_Rights_Title SDRT (NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code AND 
				SDRun.Title_Code = SDRT.Title_Code AND SDRun.Episode_From = SDRT.Episode_From  AND SDRun.Episode_To = SDRT.Episode_To
			INNER JOIN Syn_Deal_Rights_Platform SDRP (NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code AND
				SDRunP.Platform_Code = SDRP.Platform_Code

			SELECT Syn_Deal_Run_Code INTO #RunDef_Delete 
			FROM Syn_Deal_Run (NOLOCK) WHERE Syn_Deal_Code = @Deal_Code AND Syn_Deal_Run_Code NOT IN (SELECT Syn_Deal_Run_Code from #RunDef)

			DELETE FROM Syn_Deal_Run_Yearwise_Run
			WHERE Syn_Deal_Run_Code IN (SELECT Syn_Deal_Run_Code from #RunDef)

			DELETE FROM Syn_Deal_Run_Repeat_On_Day
			WHERE Syn_Deal_Run_Code IN (SELECT Syn_Deal_Run_Code from #RunDef)

			DELETE FROM Syn_Deal_Run_Platform
			WHERE Syn_Deal_Run_Code IN (SELECT Syn_Deal_Run_Code from #RunDef)

			DELETE FROM Syn_Deal_Run
			WHERE Syn_Deal_Run_Code IN (SELECT Syn_Deal_Run_Code from #RunDef)

			FETCH NEXT FROM cursorTermination_Deals INTO @Deal_Code, @Title_Code, @Episode_No, @Termination_Date
		END 

		CLOSE cursorTermination_Deals;
		DEALLOCATE cursorTermination_Deals;

		EXEC USP_Assign_Workflow @lastDealCode, 35, @Login_User_Code , ''

		SELECT Deal_Code, Title_Code, Episode_No, Termination_Date, Is_Error, Error_Details FROM #Termination_Deals_Status

		IF OBJECT_ID('tempdb..#RunDef') IS NOT NULL DROP TABLE #RunDef
		IF OBJECT_ID('tempdb..#RunDef_Delete') IS NOT NULL DROP TABLE #RunDef_Delete
		IF OBJECT_ID('tempdb..#TEMP_Run_Def') IS NOT NULL DROP TABLE #TEMP_Run_Def
		IF OBJECT_ID('tempdb..#Termination_Deals_Status') IS NOT NULL DROP TABLE #Termination_Deals_Status
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Termination_UDT]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END