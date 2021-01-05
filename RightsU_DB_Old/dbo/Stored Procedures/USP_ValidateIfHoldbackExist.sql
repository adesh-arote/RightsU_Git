--USP_ValidateIfHoldbackExist 6693,'12901','5','0,0,0,151,152,153,154,155,156,157,158,159,160,0,161,162,163,164,165,166,167,168,169,170,0,171,172,173,174,175,176,177,178,179,180,0,73,74,75,76,77,78,79,80,260,0,0,181,182,183,184,185,186,187,188,189,190,0,191,192,193,194,195,196,197,198,199,200,0,201,202,203,204,205,206,207,208,209,210,0,211,212,213,214,215,216,217,218,219,220,0,221,222,223,224,225,226,227,228,229,230,0,86,87,88,89,90,261','','','I','L','L','24/08/2016','23/08/2020','','Y'

CREATE PROC USP_ValidateIfHoldbackExist(
	@Syn_Deal_Rights_Code BIGINT,
	@Title_Code VARCHAR(MAX),
	@Region_Code VARCHAR(MAX),
	@Platform_Code VARCHAR(MAX),
	@SubTitling_Code VARCHAR(MAX),
	@Dubbing_Lang_Code VARCHAR(MAX),
	@Region_Type VARCHAR(3),
	@Sub_Lang_Type VARCHAR(3),
	@Dubbing_Lang_Type VARCHAR(3),
	@Right_Start_Date VARCHAR(20),
	@Right_End_Date VARCHAR(20),
	@Right_Type CHAR(1),			
	@Is_Title_Language_Right CHAR(1)
)
AS
SET FMTONLY OFF
IF EXISTS(Select TOP 1 * FROM Syn_Deal_Rights_Holdback WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Acq_Deal_Rights_Holdback_Code IS NOT NULL)
BEGIN
	Select 0 as Holdback_Code
	RETURN;
END


BEGIN
	--DECLARE @Syn_Deal_Rights_Code BIGINT
	--DECLARE @Title_Code VARCHAR(500)
	--DECLARE @Region_Code VARCHAR(1000)
	--DECLARE @Platform_Code VARCHAR(1000)
	--DECLARE @SubTitling_Code VARCHAR(200)
	--DECLARE @Dubbing_Lang_Code VARCHAR(200)
	--DECLARE @Region_Type VARCHAR(3)
	--DECLARE @Sub_Lang_Type VARCHAR(3)
	--DECLARE @Dubbing_Lang_Type VARCHAR(3)
	--DECLARE @Right_Start_Date DATETIME,
	--		@Right_End_Date DATETIME,
	--		@Right_Type CHAR(1),			
	--		@Is_Title_Language_Right CHAR(1)
	--		--@Deal_Rights_Code INT,		
	--		--@Is_Theatrical_Right CHAR(1),
	--		--@Deal_Code INT
			
	--SET @Syn_Deal_Rights_Code = 0
	--SET @Title_Code = '2963' --,5520
	--SET @Region_Code = '143'
	--SET @Platform_Code = '0,0,16,17,0,20,21,0,22,23,24,29,181'
	--SET @SubTitling_Code = ''
	--SET @Dubbing_Lang_Code = ''
	--SET @Region_Type = 'I'
	--SET @Sub_Lang_Type = 'L'
	--SET @Dubbing_Lang_Type = 'L'
	--SET @Right_Start_Date = '01 Jul 2014'
	--SET @Right_End_Date = '31 Jul 2018'
	--SET @Is_Title_Language_Right = 'Y'

	BEGIN /*Delete Temp Tables*/
	IF OBJECT_ID('tempdb..#Temp_Acq_Rights_Title') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Acq_Rights_Title
	END
	IF OBJECT_ID('tempdb..#Selected_Titles') IS NOT NULL
	BEGIN
		DROP TABLE #Selected_Titles
	END
	IF OBJECT_ID('tempdb..#Selected_Platform') IS NOT NULL
	BEGIN
		DROP TABLE #Selected_Platform
	END
	IF OBJECT_ID('tempdb..#Selected_Region') IS NOT NULL
	BEGIN
		DROP TABLE #Selected_Region
	END
	IF OBJECT_ID('tempdb..#Acq_Rights_Holdback') IS NOT NULL
	BEGIN
		DROP TABLE #Acq_Rights_Holdback
	END
	IF OBJECT_ID('tempdb..#Selected_Subtitling_Lang') IS NOT NULL
	BEGIN
		DROP TABLE #Selected_Subtitling_Lang
	END
	IF OBJECT_ID('tempdb..#Selected_Dubbing_Lang') IS NOT NULL
	BEGIN
		DROP TABLE #Selected_Dubbing_Lang
	END

	IF OBJECT_ID('tempdb..#Temp_Count') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Count
	END
	END
	
	BEGIN /*Create Temp Tables s*/
	CREATE TABLE #Temp_Acq_Rights_Title
	(
		Acq_Deal_Code INT,	
		Acq_Deal_Rights_Code INT,
		Is_Theatrical_Right CHAR(1),
		Title_Code INT,	
		Is_Title_Language_Right CHAR(1),
		Actual_Right_Start_Date DATETIME,
		Actual_Right_End_Date DATETIME
	)
	CREATE TABLE #Selected_Titles
	(
		Title_Code INT
	)
	CREATE TABLE #Selected_Platform
	(
		Platform_Code INT
	)

	CREATE TABLE #Selected_Region
	(
		Region_Code INT
	)

	CREATE TABLE #Selected_Subtitling_Lang
	(
		Language_Code INT
	)

	CREATE TABLE #Selected_Dubbing_Lang
	(
		Language_Code INT
	)

	CREATE TABLE #Acq_Rights_Holdback
	(
		Rights_Code INT,
		Holdback_Code INT,
		Holdback_Type VARCHAR(2)
	)
	END
	
	BEGIN /*Insert into Temp Tables*/
		INSERT INTO #Selected_Titles(Title_Code)
		SELECT number from fn_Split_WithDelemiter(@Title_Code,',')			

		INSERT INTO #Selected_Platform(Platform_Code)
		SELECT number from fn_Split_WithDelemiter(@Platform_Code,',')		
		IF (@Region_Type = 'G')	
		BEGIN
		INSERT INTO #Selected_Region(Region_Code)
			SELECT TD.Country_Code FROM Territory_Details TD 
			WHERE Territory_Code IN(SELECT number from fn_Split_WithDelemiter(@Region_Code,','))
		END
		ELSE
		BEGIN
			INSERT INTO #Selected_Region(Region_Code)
			SELECT number from fn_Split_WithDelemiter(@Region_Code,',')			
		END	

		IF (@Sub_Lang_Type = 'G')	
		BEGIN
		INSERT INTO #Selected_Subtitling_Lang(Language_Code)
			SELECT LGD.Language_Code FROM Language_Group_Details LGD 
			WHERE LGD.Language_Group_Code IN(SELECT number from fn_Split_WithDelemiter(@SubTitling_Code,','))
		END
		ELSE
		BEGIN
			INSERT INTO #Selected_Subtitling_Lang(Language_Code)
			SELECT number from fn_Split_WithDelemiter(@SubTitling_Code,',')			
		END	

		IF (@Dubbing_Lang_Type = 'G')	
		BEGIN
		INSERT INTO #Selected_Dubbing_Lang(Language_Code)
			SELECT LGD.Language_Code FROM Language_Group_Details LGD 
			WHERE LGD.Language_Group_Code IN(SELECT number from fn_Split_WithDelemiter(@Dubbing_Lang_Code,','))
		END
		ELSE
		BEGIN
			INSERT INTO #Selected_Dubbing_Lang(Language_Code)
			SELECT number from fn_Split_WithDelemiter(@Dubbing_Lang_Code,',')			
		END	

		INSERT INTO  #Temp_Acq_Rights_Title
		(
			Acq_Deal_Code,		
			Acq_Deal_Rights_Code ,
			Is_Theatrical_Right,
			Title_Code ,	
			Is_Title_Language_Right,
			Actual_Right_Start_Date,
			Actual_Right_End_Date 
		)
		SELECT DISTINCT
			ADR.Acq_Deal_Code,			
			ADR.Acq_Deal_Rights_Code ,
			ADR.Is_Theatrical_Right,
			ADRT.Title_Code ,	
			ADR.Is_Title_Language_Right ,
			ADR.Actual_Right_Start_Date ,
			ADR.Actual_Right_End_Date
		FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Title ADRT ON  ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 						
		WHERE 1 =1 		
		AND
		ADRT.Title_Code IN
		(
			SELECT Title_Code from #Selected_Titles
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
		)
		AND
		(
			@Is_Title_Language_Right = 'Y' AND ADR.Is_Title_Language_Right = 'Y'
			OR 
			@Is_Title_Language_Right = 'N' 
		)
	END
	/************************************Select**********************************/

	IF EXISTS(SELECT TOP 1 ST.Title_Code FROM #Selected_Titles ST WHERE Title_Code NOT IN(SELECT Title_Code FROM #Temp_Acq_Rights_Title))
	BEGIN
		--RETURN FALSE  -- no need to copy holdback  
		--PRINT 'NS'
		DELETE FROM #Temp_Acq_Rights_Title
	END
	IF NOT EXISTS(SELECT TOP 1 * FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code IN(
					SELECT T.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title T)
				 )
	BEGIN
		--RETURN FALSE  -- no need to copy holdback  
		--PRINT 'NP'
		SELECT 0 as Holdback_Code --FROM #Acq_Rights_Holdback
		RETURN;
	END
	ELSE
	BEGIN
		--SELECT * FROM #Temp_Acq_Rights_Title
		INSERT INTO #Acq_Rights_Holdback(Rights_Code,Holdback_Code,Holdback_Type)
		SELECT DISTINCT  ADRH.Acq_Deal_Rights_Code,ADRH.Acq_Deal_Rights_Holdback_Code,ADRH.Holdback_Type 
		FROM Acq_Deal_Rights_Holdback ADRH
		WHERE ADRH.Acq_Deal_Rights_Code IN(
			SELECT T.Acq_Deal_Rights_Code FROM #Temp_Acq_Rights_Title T
		)

		--SELECT * FROM #Acq_Rights_Holdback
	END

	--SELECT * FROM #Acq_Rights_Holdback
	/*************************Check Platform**/
	DELETE ARH 
	FROM  #Acq_Rights_Holdback ARH
	WHERE ARH.Holdback_Code NOT IN		
	(
		SELECT DISTINCT ADRP.Acq_Deal_Rights_Holdback_Code
		FROM Acq_Deal_Rights_Holdback_Platform ADRP
		WHERE ADRP.Platform_Code IN
		(
			SELECT T.Platform_Code FROM #Selected_Platform T
		) AND ARH.Holdback_Code = ADRP.Acq_Deal_Rights_Holdback_Code
	)

	/*************Check Region*/
	--SELECT * FROM #Acq_Rights_Holdback

	DELETE ARH 
	FROM  #Acq_Rights_Holdback ARH
	WHERE ARH.Holdback_Code NOT IN		
	(
		SELECT DISTINCT ADRT.Acq_Deal_Rights_Holdback_Code
		FROM Acq_Deal_Rights_Holdback_Territory ADRT
		WHERE ADRT.Country_Code IN
		(
			SELECT T.Region_Code FROM #Selected_Region T
		) AND ARH.Holdback_Code = ADRT.Acq_Deal_Rights_Holdback_Code
	)

	--SELECT * FROM #Acq_Rights_Holdback
	/*************Check Subtitling*/
	IF EXISTS(SELECT Language_Code FROM #Selected_Subtitling_Lang WHERE Language_Code != 0)
	BEGIN
		DELETE ARH FROM  #Acq_Rights_Holdback ARH
		WHERE ARH.Holdback_Code NOT IN		
		(
			SELECT DISTINCT ADRS.Acq_Deal_Rights_Holdback_Code
			FROM Acq_Deal_Rights_Holdback_Subtitling ADRS
			WHERE ADRS.Language_Code IN
			(
				SELECT T.Language_Code FROM #Selected_Subtitling_Lang T
			) AND ARH.Holdback_Code = ADRS.Acq_Deal_Rights_Holdback_Code
		)
	END
	/*************Check Dubbing Lang*/
	IF EXISTS(SELECT Language_Code FROM #Selected_Dubbing_Lang WHERE Language_Code != 0)
	BEGIN
		DELETE ARH FROM  #Acq_Rights_Holdback ARH
		WHERE ARH.Holdback_Code NOT IN		
		(
			SELECT DISTINCT ADRHD.Acq_Deal_Rights_Holdback_Code
			FROM Acq_Deal_Rights_Holdback_Dubbing ADRHD
			WHERE ADRHD.Language_Code IN
			(
				SELECT T.Language_Code FROM #Selected_Dubbing_Lang T
			) AND ARH.Holdback_Code = ADRHD.Acq_Deal_Rights_Holdback_Code
		)
	END

	IF EXISTS(SELECT TOP 1 Holdback_Code FROM #Acq_Rights_Holdback)
	BEGIN
		--PRINT 'Im'

		SELECT DISTINCT ADRH.Acq_Deal_Rights_Holdback_Code AS Holdback_Code FROM Acq_Deal_Rights_Holdback ADRH 
		INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRHP ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRHP.Acq_Deal_Rights_Holdback_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRHT.Acq_Deal_Rights_Holdback_Code
		LEFT JOIN Acq_Deal_Rights_Holdback_Subtitling ADRHS ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRHS.Acq_Deal_Rights_Holdback_Code
		LEFT JOIN Acq_Deal_Rights_Holdback_Dubbing ADRHD ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRHD.Acq_Deal_Rights_Holdback_Code
		WHERE ADRH.Acq_Deal_Rights_Holdback_Code IN (
		SELECT Holdback_Code FROM #Acq_Rights_Holdback)
		----AND 
		----ADRH.Holdback_Type = 'R' 
		AND ADRHT.Country_Code IN (select Region_Code from #Selected_Region)
		AND ADRHP.Platform_Code IN (select Platform_Code from #Selected_Platform)
		AND 
		(
			ADRH.Is_Title_Language_Right = 'Y' 
			OR ADRHS.Language_Code IN (Select Language_Code from #Selected_Subtitling_Lang)
			OR ADRHD.Language_Code IN (Select Language_Code from #Selected_Dubbing_Lang)
		)

		--SELECT Holdback_Code FROM #Acq_Rights_Holdback
	END
	ELSE
	BEGIN
		--RETURN FALSE
		--PRINT 'NS3'
		SELECT 0 as Holdback_Code --FROM #Acq_Rights_Holdback
		RETURN;

		--CREATE TABLE #Temp_Count
		--(
		--	[Count] INT
		--)
		--DECLARE @Country_Code VARCHAR(1000),@Platform_Code_HB VARCHAR(1000)
		--SELECT @Country_Code = COALESCE(@Country_Code + ',','') + CAST(Country_Code as VARCHAR)  FROM Acq_Deal_Rights_Holdback_Territory where Acq_Deal_Rights_Holdback_Code IN (
		--SELECT Holdback_Code FROM #Acq_Rights_Holdback ADR)

		--SELECT @Platform_Code_HB = COALESCE(@Platform_Code_HB + ',','') + CAST(Platform_Code as VARCHAR)  
		--FROM Acq_Deal_Rights_Holdback_Platform where Acq_Deal_Rights_Holdback_Code IN (
		--SELECT Holdback_Code FROM #Acq_Rights_Holdback ADR)
	
		--INSERT INTO #Temp_Count([Count])
		--EXEC USP_CheckIfTitleReleaseDateExist @Title_Code,@Country_Code,@Platform_Code_HB

		--SELECT * FROM #Temp_Count
		--SELECT * FROM Acq_Deal_Rights_Holdback ADRH
		--INNER JOIN Acq_Deal_Rights_Platform ADRP on ADRH.Acq_Deal_Rights_Holdback_Code = ADRP.Acq_Deal_Rights_Platform_Code
		--where ADRH.Acq_Deal_Rights_Holdback_Code IN (
		--SELECT Holdback_Code FROM #Acq_Rights_Holdback ARH ) and 
		--WHERE ARH.Holdback_Type = 'D'
		--UNION
		----Release Holdback Type
		--SELECT Holdback_Code FROM #Acq_Rights_Holdback ARH WHERE ARH.Holdback_Type = 'R'
	END
END


--select * from Acq_Deal_Rights_Holdback_Territory where Acq_Deal_Rights_Holdback_Code = 1704