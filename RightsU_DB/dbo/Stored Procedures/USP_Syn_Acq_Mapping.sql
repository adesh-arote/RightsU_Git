CREATE PROCEDURE [dbo].[USP_Syn_Acq_Mapping]
(	
	@Syn_Deal_Code INT, 
	@Debug CHAR(1)='N'
)
As
-- =============================================
-- Author:		Sagar Mahajan
-- Create date:	24 March 2015
-- Description:	(1) Call From Syn Save Rights  (2) Insert Record Into Syn_Acq_Mapping
-- =============================================
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON	
	/********************************Delete From Mapping Table************************/ 			
	INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
	SELECT DISTINCT Syn_Deal_Code, 'S', 'P', GETDATE(), 'D', Syn_Deal_Rights_Code FROM Syn_Rights_Code WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'D'

	DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code IN
	(
		SELECT DISTINCT Syn_Deal_Rights_Code 
		FROM Syn_Rights_Code WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'D'
	)	
	DELETE FROM AT_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code IN
	(
		SELECT DISTINCT Syn_Deal_Rights_Code 
		FROM Syn_Rights_Code WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'D'
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
	FROM Syn_Rights_Code WHERE Syn_Deal_Code = @Syn_Deal_Code AND [Action] = 'I'
	OPEN rights_cursor
	FETCH NEXT FROM rights_cursor INTO @Syn_Deal_Rights_Code
	WHILE @@FETCH_STATUS = 0
	BEGIN
		/************************************ Insert into UDT **********************************/ 
		INSERT INTO @Deal_Rights(Deal_Code,Deal_Rights_Code,Right_Start_Date,Right_End_Date
		,Is_Exclusive,Is_Title_Language_Right,Title_Code,Platform_Code,Right_Type,Is_Tentative,Term,Is_Theatrical_Right)
		SELECT Syn_Deal_Code,Syn_Deal_Rights_Code,Actual_Right_Start_Date,Actual_Right_End_Date,
		Is_Exclusive,Is_Title_Language_Right,0,0,Right_Type,Is_Tentative,Term,Is_Theatrical_Right
		FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

		DECLARE @IsPushback CHAR(1)
		SELECT TOP 1 @IsPushback = ISNULL(Is_Pushback, 'N') FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

		INSERT INTO @Deal_Rights_Title(Deal_Rights_Code,Title_Code, Episode_From, Episode_To)
		SELECT  Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To
		FROM Syn_Deal_Rights_Title 
		WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

		INSERT INTO @Deal_Rights_Territory(Deal_Rights_Code,Territory_Code,Country_Code,Territory_Type)
		SELECT DISTINCT  Syn_Deal_Rights_Code, SDRT.Territory_Code,
			CASE WHEN SDRT.Territory_Type = 'G' THEN  TD.Country_Code ELSE SDRT.Country_Code END AS Country_Code
			,Territory_Type 
		FROM Syn_Deal_Rights_Territory SDRT  
		LEFT JOIN Territory_Details TD ON SDRT.Territory_Code = TD.Territory_Code
		WHERE SDRT.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		  
		/************************************Delete Temp Tables**********************************/

		IF OBJECT_ID('tempdb..#Temp_Acq_Rights_Title') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Acq_Rights_Title
		END
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
			Actual_Right_End_Date DATETIME
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

		IF EXISTS(SELECT TOP 1 Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code)
			SET @Count_SubTitle = 1	  
		IF EXISTS(SELECT TOP 1 Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code)
			SET @Count_Dub = 1		

		/************************************ Insert Into Temp Tables ************************************/
		INSERT INTO  #Temp_Acq_Rights_Title
		(
			Acq_Deal_Code,
			Acq_Deal_Movie_Code,
			Acq_Deal_Rights_Code ,
			Is_Theatrical_Right,
			Title_Code ,
			Episode_From ,
			Episode_To ,			
			Is_Title_Language_Right,
			Actual_Right_Start_Date,
			Actual_Right_End_Date 
		)
		SELECT DISTINCT
			ADR.Acq_Deal_Code,
			0,
		    ADR.Acq_Deal_Rights_Code ,
			ADR.Is_Theatrical_Right,
			ADRT.Title_Code ,
			ADRT.Episode_From ,
			ADRT.Episode_To ,			
			ADR.Is_Title_Language_Right ,
		CASE WHEN ADR.Actual_Right_Start_Date < @Right_Start_Date THEN @Right_Start_Date ELSE ADR.Actual_Right_Start_Date  END AS Actual_Right_Start_Date,		
		CASE WHEN ISNULL(ADR.Actual_Right_End_Date, @Right_End_Date) > @Right_End_Date THEN @Right_End_Date ELSE ISNULL(ADR.Actual_Right_End_Date, @Right_End_Date)  END AS Actual_Right_End_Date
		FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code 
		INNER JOIN Acq_Deal_Rights_Title ADRT ON  ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 						
		WHERE 1 =1 		
		AND
		ADRT.Title_Code IN
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
					(
					CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN 
					CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103) 
					AND Convert(DATETIME, ADR.Actual_Right_End_Date, 103)										
					)			
					AND
					(
					CONVERT(DATETIME, @Right_End_Date, 103)   BETWEEN 
					CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103) 
					AND CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103)
					)
					OR
					(
					CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103)   BETWEEN 
					CONVERT(DATETIME, @Right_Start_Date, 103) 
					AND CONVERT(DATETIME, @Right_End_Date, 103)
					)
					OR
					(
					CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103)    BETWEEN 
					CONVERT(DATETIME, @Right_Start_Date, 103) 
					AND CONVERT(DATETIME, @Right_End_Date, 103)
					)
				)
			)
			OR
			(
				ADR.Right_Type ='U' 							
			)
			OR(@IsPushback = 'Y' AND @Right_Start_Date IS NULL AND @Right_End_Date IS NULL)
		)
		
		DELETE TRT FROM  #Temp_Acq_Rights_Title TRT  
		WHERE TRT.Acq_Deal_Rights_Code NOT IN		
		(
			SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights_Platform ADRP
			WHERE ADRP.Platform_Code IN
			(
				SELECT Platform_Code
				FROM Syn_Deal_Rights_Platform
				WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			)
			AND ADRP.Acq_Deal_Rights_Code = TRT.Acq_Deal_Rights_Code
		)

		DELETE TRT FROM  #Temp_Acq_Rights_Title TRT  
		WHERE TRT.Acq_Deal_Rights_Code NOT IN		
		(
			SELECT DISTINCT
			ADRT.Acq_Deal_Rights_Code		
			FROM Acq_Deal_Rights_Territory  ADRT			
			INNER JOIN @Deal_Rights_Territory DRT ON 
			ADRT.Country_Code = DRT.Country_Code 
			OR 
			(
				@Is_Theatrical_Right = 'Y' AND 
				(
					ADRT.Country_Code IN
					(
						SELECT C.Parent_Country_Code FROM Country C WHERE C.Country_Code=DRT.Country_Code
					)
				)
			)
			OR
			DRT.Country_Code IN
			(
				SELECT CC.Country_Code FROM 
				(
					SELECT DISTINCT c.Country_Code	
					FROM  Country C
					INNER JOIN Territory_Details TD ON C.Country_Code = TD.Country_Code
					WHERE TD.Territory_Code = ADRT.Territory_Code 
						AND ((C.Is_Domestic_Territory = 'Y' AND @Is_Theatrical_Right = 'Y') OR @Is_Theatrical_Right = 'N')
				) AS tbl 
				INNER JOIN Country CC ON CC.Country_Code = tbl.Country_Code OR (CC.Parent_Country_Code = tbl.Country_Code AND  @Is_Theatrical_Right = 'Y')
			)
			WHERE ADRT.Acq_Deal_Rights_Code = TRT.Acq_Deal_Rights_Code			
		)
		IF(@Count_Dub = 0 AND @Count_SubTitle = 0)
		BEGIN
			DELETE  FROM #Temp_Acq_Rights_Title WHERE Is_Title_Language_Right = 'N'		
		END
		ELSE --means IF(@Count_Dub > 0 OR @Count_SubTitle > 0)
		BEGIN				
			DELETE TRT FROM  #Temp_Acq_Rights_Title TRT  
			WHERE TRT.Acq_Deal_Rights_Code NOT IN
			(
				SELECT Acq_Deal_Rights_Code 
				FROM #Temp_Acq_Rights_Title
				WHERE Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y'
				UNION
				SELECT tbl.Acq_Deal_Rights_Code FROM
				( 
					SELECT tblinner.Acq_Deal_Rights_Code,tblinner.Language_Code FROM 
					(
						SELECT DISTINCT ADRD.Acq_Deal_Rights_Code,
							CASE WHEN ADRD.Language_Type = 'G' THEN LGD.Language_Code ELSE ADRD.Language_Code END AS Language_Code 						
						FROM Acq_Deal_Rights_Dubbing ADRD 					
						LEFT JOIN Language_Group_Details LGD ON ADRD.Language_Group_Code = LGD.Language_Group_Code
						WHERE ADRD.Acq_Deal_Rights_Code =TRT.Acq_Deal_Rights_Code 				
					) AS tblinner
					WHERE tblinner.Language_Code
					IN
					(
						SELECT DISTINCT 
							CASE WHEN SDRD.Language_Type = 'G' THEN LGDD.Language_Code ELSE SDRD.Language_Code END AS Language_Code 						
						FROM Syn_Deal_Rights_Dubbing SDRD 
						LEFT JOIN Language_Group_Details LGDD ON SDRD.Language_Group_Code = LGDD.Language_Group_Code
						WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					)
				) AS Tbl
				UNION
				SELECT tbl.Acq_Deal_Rights_Code FROM
				( 
					SELECT tblinner.Acq_Deal_Rights_Code,tblinner.Language_Code FROM 
					(
						SELECT DISTINCT ADRS.Acq_Deal_Rights_Code,
							CASE WHEN ADRS.Language_Type = 'G' THEN LGD.Language_Code ELSE ADRS.Language_Code END AS Language_Code 						
						FROM Acq_Deal_Rights_Subtitling ADRS 					
						LEFT JOIN Language_Group_Details LGD ON ADRS.Language_Group_Code = LGD.Language_Group_Code
						WHERE ADRS.Acq_Deal_Rights_Code =TRT.Acq_Deal_Rights_Code 				
					) AS tblinner
					WHERE tblinner.Language_Code
					IN
					(
						SELECT DISTINCT 
							CASE WHEN SDRS.Language_Type = 'G' THEN LGDD.Language_Code ELSE SDRS.Language_Code END AS Language_Code 						
						FROM Syn_Deal_Rights_Subtitling SDRS 
						LEFT JOIN Language_Group_Details LGDD ON SDRS.Language_Group_Code = LGDD.Language_Group_Code
						WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					)
				) AS Tbl
			)
		END

		/***********************************Insert Records into Syn_Acq_Mapping and Approved_Deal*********************************/
		DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code
		DELETE FROM AT_Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Deal_Rights_Code

		INSERT INTO Syn_Acq_Mapping
		(
			Syn_Deal_Code,
			Syn_Deal_Rights_Code,
			Syn_Deal_Movie_Code,
			Deal_Code,
			Deal_Movie_Code,
			Deal_Rights_Code,
			Right_Start_Date,
			Right_End_Date
		)
		SELECT DISTINCT
			@Deal_Code,@Deal_Rights_Code,0,TART.Acq_Deal_Code,TART.Acq_Deal_Movie_Code,
			TART.Acq_Deal_Rights_Code,TART.Actual_Right_Start_Date,TART.Actual_Right_End_Date
		FROM #Temp_Acq_Rights_Title TART 

		DECLARE @TART_Count INT = 0
		SELECT DISTINCT @TART_Count = COUNT(*) FROM #Temp_Acq_Rights_Title TART 
	
		INSERT INTO AT_Syn_Acq_Mapping
		(	
			Syn_Acq_Mapping_Code, 
			Syn_Deal_Code, 
			Syn_Deal_Movie_Code, 
			Syn_Deal_Rights_Code, 
			AT_Acq_Deal_Code, 
			Deal_Movie_Code, 
			Deal_Rights_Code, 
			Right_Start_Date, 
			Right_End_Date
		)
		 SELECT TOP (@TART_Count)
			Syn_Acq_Mapping_Code, 
			Syn_Deal_Code, 
			Syn_Deal_Movie_Code, 
			Syn_Deal_Rights_Code, 
			Deal_Code = (SELECT MAX(AT_Acq_Deal_Code) FROM AT_Acq_Deal WHERE Acq_Deal_Code =  SAM.Deal_Code and Version = (SELECT MAX(Version) FROM AT_Acq_Deal WHERE Acq_Deal_Code =  SAM.Deal_Code )), 
			Deal_Movie_Code, 
			Deal_Rights_Code, 
			Right_Start_Date, 
			Right_End_Date FROM Syn_Acq_Mapping SAM ORDER BY Syn_Acq_Mapping_Code DESC



		INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
		VALUES(@Deal_Code, 'S', 'P', GETDATE(), 'Y', @Deal_Rights_Code)
		
		IF(@Debug='D')
		BEGIN								
			SELECT * FROM Syn_Acq_Mapping WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code	
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
END