CREATE PROCEDURE [dbo].[USP_Syn_Acq_Mapping]
(
	@Syn_Deal_Code INT = 237, 
	@Debug CHAR(1)='N'
)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date:	24 March 2015
-- Description:	(1) Call From Syn Save Rights  (2) Insert Record Into Syn_Acq_Mapping
-- =============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Acq_Mapping]', 'Step 1', 0, 'Started Procedure', 0, ''      

		SET FMTONLY OFF
		SET NOCOUNT ON	
		/********************************Delete From Mapping Table************************/ 			
		INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
		SELECT DISTINCT Syn_Deal_Code, 'S', 'P', GETDATE(), 'D', Syn_Deal_Rights_Code FROM Syn_Rights_Code (NOLOCK)  WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'D'

		DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code IN
		(
			SELECT DISTINCT Syn_Deal_Rights_Code 
			FROM Syn_Rights_Code  (NOLOCK) WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'D'
		)	
		DELETE FROM AT_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code IN
		(
			SELECT DISTINCT Syn_Deal_Rights_Code 
			FROM Syn_Rights_Code (NOLOCK)  WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'D'
		)	

		/********************************Declare UDT *********************************************************/		
		DECLARE @Deal_Rights Deal_Rights
		DECLARE @Deal_Rights_Title Deal_Rights_Title			
		DECLARE @Deal_Rights_Territory Deal_Rights_Territory					
		DECLARE @Syn_Deal_Rights_Code INT			
		SET @Syn_Deal_Rights_Code = 0
 		/**********************************Cursor*******************************************************/		
		DECLARE rights_cursor CURSOR FOR 
		SELECT DISTINCT Syn_Deal_Rights_Code 
		FROM Syn_Rights_Code (NOLOCK)  WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'I'
		OPEN rights_cursor
		FETCH NEXT FROM rights_cursor INTO @Syn_Deal_Rights_Code
		WHILE @@FETCH_STATUS = 0
		BEGIN
			/************************************ Insert into UDT **********************************/ 
			INSERT INTO @Deal_Rights(Deal_Code,Deal_Rights_Code,Right_Start_Date,Right_End_Date
			,Is_Exclusive,Is_Title_Language_Right,Title_Code,Platform_Code,Right_Type,Is_Tentative,Term,Is_Theatrical_Right)
			SELECT Syn_Deal_Code,Syn_Deal_Rights_Code,Actual_Right_Start_Date,Actual_Right_End_Date,
			Is_Exclusive,Is_Title_Language_Right,0,0,Right_Type,Is_Tentative,Term,Is_Theatrical_Right
			FROM Syn_Deal_Rights (NOLOCK)  WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			DECLARE @IsPushback CHAR(1)
			SELECT TOP 1 @IsPushback = ISNULL(Is_Pushback, 'N') FROM Syn_Deal_Rights (NOLOCK)  WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			INSERT INTO @Deal_Rights_Title(Deal_Rights_Code,Title_Code, Episode_From, Episode_To)
			SELECT  Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To
			FROM Syn_Deal_Rights_Title  (NOLOCK) 
			WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

			INSERT INTO @Deal_Rights_Territory(Deal_Rights_Code,Territory_Code,Country_Code,Territory_Type)
			SELECT DISTINCT  Syn_Deal_Rights_Code, SDRT.Territory_Code,
				CASE WHEN SDRT.Territory_Type = 'G' THEN  TD.Country_Code ELSE SDRT.Country_Code END AS Country_Code
				,Territory_Type 
			FROM Syn_Deal_Rights_Territory SDRT  (NOLOCK)  
			LEFT JOIN Territory_Details TD (NOLOCK)  ON SDRT.Territory_Code = TD.Territory_Code
			WHERE SDRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		  
			/************************************Delete Temp Tables**********************************/

			IF OBJECT_ID('tempdb..#Temp_Acq_Rights_Title') IS NOT NULL DROP TABLE #Temp_Acq_Rights_Title
			IF OBJECT_ID('tempdb..#tmpAcqSynCombo') IS NOT NULL DROP TABLE #tmpAcqSynCombo

			/************************************Create Temp Tables s**********************************/
			CREATE TABLE #Temp_Acq_Rights_Title
			(
				Acq_Deal_Code INT,
				Acq_Deal_Movie_Code INT,
				Acq_Deal_Rights_Code INT,
				Is_Theatrical_Right CHAR(1),
				Title_Code INT,
				Episode_From INT,
				Episode_To INT,		
				Is_Title_Language_Right CHAR(1),
				Actual_Right_Start_Date DATETIME,
				Actual_Right_End_Date DATETIME,
				BuyBack_Code INT
			)				
			DECLARE @Count_SubTitle INT = 0,@Count_Dub INT = 0
	
		   /************************************Declare Local Variables(Rights) ************************************/						
			DECLARE @Right_Start_Date DATETIME,
					@Right_End_Date DATETIME,
					@Right_Type CHAR(1),			
					@Is_Title_Language_Right CHAR(1),						
					@Deal_Rights_Code INT,
					@Deal_Pushback_Code INT,						
					@Is_Theatrical_Right CHAR(1),
					@Deal_Code INT
			/************************************Assign Values To Local Variable  ************************************/
			SELECT 		
				@Deal_Code=dr.Deal_Code,
				@Deal_Rights_Code=dr.Deal_Rights_Code,
				@Right_Start_Date=dr.Right_Start_Date,
				@Right_End_Date=dr.Right_End_Date,
				@Right_Type=dr.Right_Type,				
				@Is_Title_Language_Right=dr.Is_Title_Language_Right,					
				@Is_Theatrical_Right=ISNULL(dr.Is_Theatrical_Right,'N'),		
				@Deal_Code =dr.Deal_Code
			FROM @Deal_Rights dr

			IF EXISTS(SELECT TOP 1 Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Subtitling (NOLOCK)  WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code)
				SET @Count_SubTitle = 1	  
			IF EXISTS(SELECT TOP 1 Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Dubbing (NOLOCK)  WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code)
				SET @Count_Dub = 1		

			/************************************ Insert Into Temp Tables ************************************/
			INSERT INTO  #Temp_Acq_Rights_Title(Acq_Deal_Code, Acq_Deal_Movie_Code, Acq_Deal_Rights_Code , Is_Theatrical_Right, Title_Code, Episode_From,
												Episode_To, Is_Title_Language_Right, BuyBack_Code, 
												Actual_Right_Start_Date, 
												Actual_Right_End_Date)
			SELECT DISTINCT ADR.Acq_Deal_Code, 0, ADR.Acq_Deal_Rights_Code, ADR.Is_Theatrical_Right, ADRT.Title_Code, ADRT.Episode_From, 
				ADRT.Episode_To, ADR.Is_Title_Language_Right, ADR.Buyback_Syn_Rights_Code,
				CASE WHEN ADR.Actual_Right_Start_Date < @Right_Start_Date THEN @Right_Start_Date ELSE ADR.Actual_Right_Start_Date  END AS Actual_Right_Start_Date,		
				CASE WHEN ISNULL(ADR.Actual_Right_End_Date, @Right_End_Date) > @Right_End_Date THEN @Right_End_Date ELSE ISNULL(ADR.Actual_Right_End_Date, @Right_End_Date)  END AS Actual_Right_End_Date
			FROM Acq_Deal AD (NOLOCK) 
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK)  ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ISNULL(ADR.Buyback_Syn_Rights_Code, 0) NOT IN (@Syn_Deal_Rights_Code)
			INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK)  ON  ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			WHERE 1 = 1 AND ADRT.Title_Code IN
			(
				Select DRT.Title_Code 
				FROM @Deal_Rights_Title DRT
				WHERE DRT.Episode_To BETWEEN ADRT.Episode_From AND ADRT.Episode_To
				Or DRT.Episode_To BETWEEN ADRT.Episode_From AND ADRT.Episode_To
				OR ADRT.Episode_From  BETWEEN DRT.Episode_From AND DRT.Episode_To
				Or ADRT.Episode_To BETWEEN DRT.Episode_From AND DRT.Episode_To
			)
			AND 
			( 	
				(
					(ADR.Right_Type ='Y' OR ADR.Right_Type ='M')
					AND
					(
						(CONVERT(DATETIME, @Right_Start_Date, 103) BETWEEN CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103) AND Convert(DATETIME, ADR.Actual_Right_End_Date, 103)) OR
						(CONVERT(DATETIME, @Right_End_Date, 103) BETWEEN CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103) AND CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103) BETWEEN CONVERT(DATETIME, @Right_Start_Date, 103) AND CONVERT(DATETIME, @Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103) BETWEEN CONVERT(DATETIME, @Right_Start_Date, 103) AND CONVERT(DATETIME, @Right_End_Date, 103))
					)
				)
				OR
				(
					ADR.Right_Type ='U'
				)
				OR(@IsPushback = 'Y' AND @Right_Start_Date IS NULL AND @Right_End_Date IS NULL)
			)

			DELETE TRT FROM  #Temp_Acq_Rights_Title TRT WHERE TRT.Acq_Deal_Rights_Code NOT IN
			(
				SELECT DISTINCT ADRP.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform ADRP (NOLOCK) 
				WHERE ADRP.Acq_Deal_Rights_Code = TRT.Acq_Deal_Rights_Code AND ADRP.Platform_Code IN
				(
					SELECT Platform_Code FROM Syn_Deal_Rights_Platform (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				)
			)

			DELETE TRT FROM #Temp_Acq_Rights_Title TRT WHERE TRT.Acq_Deal_Rights_Code NOT IN
			(
				SELECT DISTINCT ADRT.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory ADRT (NOLOCK) 
				INNER JOIN @Deal_Rights_Territory DRT ON ADRT.Country_Code = DRT.Country_Code
				OR
				(
					@Is_Theatrical_Right = 'Y' AND 
					(
						ADRT.Country_Code IN (SELECT C.Parent_Country_Code FROM Country C (NOLOCK)  WHERE C.Country_Code=DRT.Country_Code)
					)
				)
				OR
				DRT.Country_Code IN
				(
					SELECT CC.Country_Code FROM 
					(
						SELECT DISTINCT c.Country_Code FROM  Country C (NOLOCK)
						INNER JOIN Territory_Details TD (NOLOCK)  ON C.Country_Code = TD.Country_Code
						WHERE TD.Territory_Code = ADRT.Territory_Code AND ((C.Is_Domestic_Territory = 'Y' AND @Is_Theatrical_Right = 'Y') OR @Is_Theatrical_Right = 'N')
					) AS tbl
					INNER JOIN Country CC (NOLOCK)  ON CC.Country_Code = tbl.Country_Code OR (CC.Parent_Country_Code = tbl.Country_Code AND  @Is_Theatrical_Right = 'Y')
				)
				WHERE ADRT.Acq_Deal_Rights_Code = TRT.Acq_Deal_Rights_Code			
			)

			IF(@Count_Dub = 0 AND @Count_SubTitle = 0)
			BEGIN
				DELETE  FROM #Temp_Acq_Rights_Title WHERE Is_Title_Language_Right = 'N'		
			END
			ELSE
			BEGIN
				DELETE TRT FROM  #Temp_Acq_Rights_Title TRT
				WHERE TRT.Acq_Deal_Rights_Code NOT IN
				(
					SELECT Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title
					WHERE Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y'
					UNION
					SELECT tbl.Acq_Deal_Rights_Code FROM
					( 
						SELECT tblinner.Acq_Deal_Rights_Code, tblinner.Language_Code FROM 
						(
							SELECT DISTINCT ADRD.Acq_Deal_Rights_Code, CASE WHEN ADRD.Language_Type = 'G' THEN LGD.Language_Code ELSE ADRD.Language_Code END AS Language_Code
							FROM Acq_Deal_Rights_Dubbing ADRD (NOLOCK) 
							LEFT JOIN Language_Group_Details LGD (NOLOCK)  ON ADRD.Language_Group_Code = LGD.Language_Group_Code
							WHERE ADRD.Acq_Deal_Rights_Code =TRT.Acq_Deal_Rights_Code
						) AS tblinner
						WHERE tblinner.Language_Code IN (
							SELECT DISTINCT CASE WHEN SDRD.Language_Type = 'G' THEN LGDD.Language_Code ELSE SDRD.Language_Code END AS Language_Code 						
							FROM Syn_Deal_Rights_Dubbing SDRD  (NOLOCK) 
							LEFT JOIN Language_Group_Details LGDD (NOLOCK)  ON SDRD.Language_Group_Code = LGDD.Language_Group_Code
							WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						)
					) AS Tbl
					UNION
					SELECT tbl.Acq_Deal_Rights_Code FROM
					(
						SELECT tblinner.Acq_Deal_Rights_Code, tblinner.Language_Code FROM 
						(
							SELECT DISTINCT ADRS.Acq_Deal_Rights_Code, CASE WHEN ADRS.Language_Type = 'G' THEN LGD.Language_Code ELSE ADRS.Language_Code END AS Language_Code
							FROM Acq_Deal_Rights_Subtitling ADRS (NOLOCK) 
							LEFT JOIN Language_Group_Details LGD (NOLOCK)  ON ADRS.Language_Group_Code = LGD.Language_Group_Code
							WHERE ADRS.Acq_Deal_Rights_Code =TRT.Acq_Deal_Rights_Code
						) AS tblinner
						WHERE tblinner.Language_Code IN (
							SELECT DISTINCT CASE WHEN SDRS.Language_Type = 'G' THEN LGDD.Language_Code ELSE SDRS.Language_Code END AS Language_Code
							FROM Syn_Deal_Rights_Subtitling SDRS (NOLOCK) 
							LEFT JOIN Language_Group_Details LGDD (NOLOCK)  ON SDRS.Language_Group_Code = LGDD.Language_Group_Code
							WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
						)
					) AS Tbl
				)
			END

			--SELECT * FROM #Temp_Acq_Rights_Title
			IF EXISTS(SELECT TOP 1 * FROM #Temp_Acq_Rights_Title WHERE ISNULL(BuyBack_Code, 0) > 0)
			BEGIN
				IF EXISTS(SELECT TOP 1 * FROM #Temp_Acq_Rights_Title WHERE ISNULL(BuyBack_Code, 0) = 0)
				BEGIN

					--DROP TABLE #tmpAcqSynCombo
					CREATE TABLE #tmpAcqSynCombo
					(
						Acq_Deal_Rights_Code INT,
						Is_BuyBack CHAR(1),
						Is_Language_Right CHAR(1),
						All_LP_Exists CHAR(1),
						All_Platform_Exists CHAR(1),
						All_Country_Exists CHAR(1),
						All_Subtitling_Exists CHAR(1),
						All_Dubbing_Exists CHAR(1)
					)

					INSERT INTO #tmpAcqSynCombo(Acq_Deal_Rights_Code, All_LP_Exists, All_Platform_Exists, All_Country_Exists, All_Subtitling_Exists, All_Dubbing_Exists, Is_Language_Right)
					SELECT DISTINCT tart.Acq_Deal_Rights_Code, 'Y', 'Y', 'Y', 'Y', 'Y', Is_Title_Language_Right FROM #Temp_Acq_Rights_Title tart
					WHERE ISNULL(BuyBack_Code, 0) = 0

					--SELECT * FROM #tmpAcqSynCombo
					-------------//CHECK FOR PLATFORM
					IF EXISTS(
						SELECT TOP 1 * FROM Syn_Deal_Rights_Platform drt (NOLOCK) WHERE drt.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND drt.Platform_Code NOT IN (
							SELECT DISTINCT acq.Platform_Code FROM (
								SELECT DISTINCT Acq_Deal_Rights_Code, ADRT.Platform_Code FROM Acq_Deal_Rights_Platform ADRT (NOLOCK) 
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
								)
							) AS acq
						)
					)
					BEGIN

						UPDATE #tmpAcqSynCombo SET All_Platform_Exists = 'N' WHERE Acq_Deal_Rights_Code IN (
							SELECT DISTINCT acq1.Acq_Deal_Rights_Code FROM (
								SELECT DISTINCT Acq_Deal_Rights_Code, ADRT.Platform_Code FROM Acq_Deal_Rights_Platform ADRT (NOLOCK) 
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) = 0
								)
							) AS acq1
							WHERE acq1.Platform_Code IN (
								SELECT DISTINCT Platform_Code FROM Syn_Deal_Rights_Platform drt (NOLOCK)  WHERE drt.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND drt.Platform_Code NOT IN (
									SELECT DISTINCT acq.Platform_Code FROM (
										SELECT DISTINCT Acq_Deal_Rights_Code, ADRT.Platform_Code FROM Acq_Deal_Rights_Platform ADRT (NOLOCK) 
										WHERE ADRT.Acq_Deal_Rights_Code IN (
											SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
										)
									) AS acq
								)
							)
						)

					END

					-------------//CHECK FOR REGION
					IF EXISTS(
						SELECT TOP 1 * FROM @Deal_Rights_Territory drt WHERE drt.Country_Code NOT IN (
							SELECT DISTINCT acq.Country_Code FROM (
								SELECT DISTINCT  Acq_Deal_Rights_Code, CASE WHEN ADRT.Territory_Type = 'G' THEN  TD.Country_Code ELSE ADRT.Country_Code END AS Country_Code
								FROM Acq_Deal_Rights_Territory ADRT   (NOLOCK) 
								LEFT JOIN Territory_Details TD  (NOLOCK) ON ADRT.Territory_Code = TD.Territory_Code
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
								)
							) AS acq
						)
					)
					BEGIN

						UPDATE #tmpAcqSynCombo SET All_Country_Exists = 'N' WHERE Acq_Deal_Rights_Code IN (
							SELECT DISTINCT acq1.Acq_Deal_Rights_Code FROM (
								SELECT DISTINCT  Acq_Deal_Rights_Code, CASE WHEN ADRT.Territory_Type = 'G' THEN  TD.Country_Code ELSE ADRT.Country_Code END AS Country_Code
								FROM Acq_Deal_Rights_Territory ADRT  (NOLOCK)  
								LEFT JOIN Territory_Details TD (NOLOCK)  ON ADRT.Territory_Code = TD.Territory_Code
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) = 0
								)
							) AS acq1
							WHERE acq1.Country_Code IN (
								SELECT DISTINCT Country_Code FROM @Deal_Rights_Territory drt WHERE drt.Country_Code NOT IN (
									SELECT DISTINCT acq.Country_Code FROM (
										SELECT DISTINCT  Acq_Deal_Rights_Code, CASE WHEN ADRT.Territory_Type = 'G' THEN  TD.Country_Code ELSE ADRT.Country_Code END AS Country_Code
										FROM Acq_Deal_Rights_Territory ADRT (NOLOCK) 
										LEFT JOIN Territory_Details TD (NOLOCK)  ON ADRT.Territory_Code = TD.Territory_Code
										WHERE ADRT.Acq_Deal_Rights_Code IN (
											SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
										)
									) AS acq
								)
							)
						)

					END

					-------------//CHECK FOR Subtitling
					IF EXISTS(
						SELECT TOP 1 * FROM Syn_Deal_Rights_Subtitling drt (NOLOCK)  WHERE drt.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND drt.Language_Code NOT IN (
							SELECT DISTINCT acq.Language_Code FROM (
								SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code
								FROM Acq_Deal_Rights_Subtitling ADRT  (NOLOCK)  
								LEFT JOIN Language_Group_Details TD (NOLOCK)  ON ADRT.Language_Group_Code = TD.Language_Group_Code
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
								)
							) AS acq
						)
					)
					BEGIN

						UPDATE #tmpAcqSynCombo SET All_Subtitling_Exists = 'N' WHERE Acq_Deal_Rights_Code IN (
							SELECT DISTINCT acq1.Acq_Deal_Rights_Code FROM (
								SELECT DISTINCT  Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code
								FROM Acq_Deal_Rights_Subtitling ADRT  (NOLOCK)  
								LEFT JOIN Language_Group_Details TD (NOLOCK)  ON ADRT.Language_Group_Code = TD.Language_Group_Code
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) = 0
								)
							) AS acq1
							WHERE acq1.Language_Code IN (
								SELECT DISTINCT Language_Code FROM Syn_Deal_Rights_Subtitling drt (NOLOCK)  WHERE drt.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND drt.Language_Code NOT IN (
									SELECT DISTINCT acq.Language_Code FROM (
										SELECT DISTINCT  Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code
										FROM Acq_Deal_Rights_Subtitling ADRT  (NOLOCK)  
										LEFT JOIN Language_Group_Details TD (NOLOCK)  ON ADRT.Language_Group_Code = TD.Language_Group_Code
										WHERE ADRT.Acq_Deal_Rights_Code IN (
											SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
										)
									) AS acq
								)
							)
						)

					END

					-------------//CHECK FOR Dubbing
					IF EXISTS(
						SELECT TOP 1 * FROM Syn_Deal_Rights_Dubbing drt (NOLOCK)  WHERE drt.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND drt.Language_Code NOT IN (
							SELECT DISTINCT acq.Language_Code FROM (
								SELECT DISTINCT Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code
								FROM Acq_Deal_Rights_Dubbing ADRT  (NOLOCK)  
								LEFT JOIN Language_Group_Details TD (NOLOCK)  ON ADRT.Language_Group_Code = TD.Language_Group_Code
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
								)
							) AS acq
						)
					)
					BEGIN

						UPDATE #tmpAcqSynCombo SET All_Dubbing_Exists = 'N' WHERE Acq_Deal_Rights_Code IN (
							SELECT DISTINCT acq1.Acq_Deal_Rights_Code FROM (
								SELECT DISTINCT  Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code
								FROM Acq_Deal_Rights_Dubbing ADRT (NOLOCK)   
								LEFT JOIN Language_Group_Details TD (NOLOCK)  ON ADRT.Language_Group_Code = TD.Language_Group_Code
								WHERE ADRT.Acq_Deal_Rights_Code IN (
									SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) = 0
								)
							) AS acq1
							WHERE acq1.Language_Code IN (
								SELECT DISTINCT Language_Code FROM Syn_Deal_Rights_Dubbing drt (NOLOCK)  WHERE drt.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND drt.Language_Code NOT IN (
									SELECT DISTINCT acq.Language_Code FROM (
										SELECT DISTINCT  Acq_Deal_Rights_Code, CASE WHEN ADRT.Language_Type = 'G' THEN TD.Language_Code ELSE ADRT.Language_Code END AS Language_Code
										FROM Acq_Deal_Rights_Dubbing ADRT (NOLOCK)   
										LEFT JOIN Language_Group_Details TD (NOLOCK)  ON ADRT.Language_Group_Code = TD.Language_Group_Code
										WHERE ADRT.Acq_Deal_Rights_Code IN (
											SELECT tart.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title tart WHERE ISNULL(BuyBack_Code, 0) > 0
										)
									) AS acq
								)
							)
						)

					END

					-------------//CHECK FOR LP
					DECLARE @BBStartDate DATE, @BBEndDate DATE, @SynStartDate DATE, @SynEndDate DATE
					SELECT @BBStartDate = MIN(Actual_Right_Start_Date), @BBEndDate = MIN(Actual_Right_End_Date) FROM #Temp_Acq_Rights_Title WHERE ISNULL(BuyBack_Code, 0) > 0
					SELECT @SynStartDate = Actual_Right_Start_Date, @SynEndDate = Actual_Right_End_Date FROM Syn_Deal_Rights (NOLOCK)  WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				
					--SELECT * FROM #tmpAcqSynCombo

					IF (@SynStartDate < @BBStartDate OR @SynEndDate > @BBEndDate)
					BEGIN

						UPDATE tmp SET tmp.All_LP_Exists = 'N'
						FROM #tmpAcqSynCombo tmp
						INNER JOIN #Temp_Acq_Rights_Title acq ON tmp.Acq_Deal_Rights_Code = acq.Acq_Deal_Rights_Code AND (
							(acq.Actual_Right_Start_Date < @SynStartDate AND @SynStartDate BETWEEN acq.Actual_Right_Start_Date AND acq.Actual_Right_End_Date) OR
							(acq.Actual_Right_End_Date >= @SynEndDate AND @SynEndDate BETWEEN acq.Actual_Right_Start_Date AND acq.Actual_Right_End_Date)
						)

						UPDATE acq SET acq.Actual_Right_End_Date = DATEADD(D, -1, @BBStartDate)
						FROM #tmpAcqSynCombo tmp
						INNER JOIN #Temp_Acq_Rights_Title acq ON tmp.Acq_Deal_Rights_Code = acq.Acq_Deal_Rights_Code AND 
						acq.Actual_Right_Start_Date < @SynStartDate AND @SynStartDate BETWEEN acq.Actual_Right_Start_Date AND acq.Actual_Right_End_Date

						UPDATE acq SET acq.Actual_Right_Start_Date = DATEADD(D, 1, @BBEndDate)
						FROM #tmpAcqSynCombo tmp
						INNER JOIN #Temp_Acq_Rights_Title acq ON tmp.Acq_Deal_Rights_Code = acq.Acq_Deal_Rights_Code AND
						acq.Actual_Right_End_Date >= @SynEndDate AND @SynEndDate BETWEEN acq.Actual_Right_Start_Date AND acq.Actual_Right_End_Date

					END
				
					--SELECT @Is_Title_Language_Right, * FROM #tmpAcqSynCombo

					DELETE acq
					FROM #tmpAcqSynCombo tmp
					INNER JOIN #Temp_Acq_Rights_Title acq ON tmp.Acq_Deal_Rights_Code = acq.Acq_Deal_Rights_Code AND 
					All_LP_Exists + All_Platform_Exists + All_Country_Exists + All_Subtitling_Exists + All_Dubbing_Exists = 'YYYYY'
					WHERE tmp.Is_Language_Right <> @Is_Title_Language_Right
					--OR 
					--(@Is_Title_Language_Right = 'N' And tmp.Is_Language_Right = 'Y') OR 
					--(@Is_Title_Language_Right = 'Y' And tmp.Is_Language_Right = 'N')

					DELETE FROM #tmpAcqSynCombo WHERE All_LP_Exists + All_Platform_Exists + All_Country_Exists + All_Subtitling_Exists + All_Dubbing_Exists = 'YYYYY' AND Is_Language_Right <> @Is_Title_Language_Right

					--SELECT * FROM #tmpAcqSynCombo
					--SELECT * FROM #tmpAcqSynCombo

				END
			END

			--RETURN

			/***********************************Insert Records into Syn_Acq_Mapping and Approved_Deal*********************************/
			DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code
			DELETE FROM AT_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code

			INSERT INTO Syn_Acq_Mapping(Syn_Deal_Code, Syn_Deal_Rights_Code, Syn_Deal_Movie_Code, Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
			SELECT DISTINCT @Deal_Code, @Deal_Rights_Code, 0, TART.Acq_Deal_Code, TART.Acq_Deal_Movie_Code, TART.Acq_Deal_Rights_Code, TART.Actual_Right_Start_Date, TART.Actual_Right_End_Date
			FROM #Temp_Acq_Rights_Title TART 

			DECLARE @TART_Count INT = 0
			SELECT DISTINCT @TART_Count = COUNT(*) FROM #Temp_Acq_Rights_Title TART 
	
			INSERT INTO AT_Syn_Acq_Mapping(Syn_Acq_Mapping_Code, Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, 
										   AT_Acq_Deal_Code, 
										   Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
			 SELECT TOP (@TART_Count) Syn_Acq_Mapping_Code, Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, 
				Deal_Code = (SELECT MAX(AT_Acq_Deal_Code) FROM AT_Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = SAM.Deal_Code and Version = (SELECT MAX(Version) FROM AT_Acq_Deal (NOLOCK)  WHERE Acq_Deal_Code = SAM.Deal_Code )), 
				Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
			FROM Syn_Acq_Mapping SAM (NOLOCK)  ORDER BY Syn_Acq_Mapping_Code DESC

			INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
			VALUES(@Deal_Code, 'S', 'P', GETDATE(), 'Y', @Deal_Rights_Code)
		
			IF(@Debug='D')
			BEGIN								
				SELECT * FROM Syn_Acq_Mapping (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code	
			END
		
			/**********************************Drop Temp Tables **********************************/
			DELETE FROM @Deal_Rights
			DELETE FROM @Deal_Rights_Title		
			DELETE FROM @Deal_Rights_Territory		
			DROP TABLE #Temp_Acq_Rights_Title					
			/**************************** DELETE FROM Syn_Rights_Code ******************************/		
			DELETE SRC FROM Syn_Rights_Code SRC WHERE SRC.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			FETCH NEXT FROM rights_cursor INTO @Syn_Deal_Rights_Code
		END		
		CLOSE rights_cursor;
		DEALLOCATE rights_cursor;
		/**************************** DELETE FROM Syn_Rights_Code ******************************/	
		DELETE SRC FROM Syn_Rights_Code SRC WHERE Syn_Deal_Code = @Syn_Deal_Code

		SELECT 'S' AS Result

		IF OBJECT_ID('tempdb..#Temp_Acq_Rights_Title') IS NOT NULL DROP TABLE #Temp_Acq_Rights_Title
		IF OBJECT_ID('tempdb..#tmpAcqSynCombo') IS NOT NULL DROP TABLE #tmpAcqSynCombo
	
	IF(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Acq_Mapping]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END