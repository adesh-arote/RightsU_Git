CREATE proc [dbo].[USP_Deal_Rights_Template] 
	@Deal_Code INT,
	@Deal_Movie_Codes VARCHAR(MAX),
	@User_Code INT,
	@Agreement_Date VARCHAR(100)
AS
 --=============================================
 --Author:  Akshay Rane
 --Create date: 26 May  2016
 --Description: Adds the rights to the movies which has been added in the general tab according to the given template
 --=============================================
BEGIN
	--DECLARE
	--@Deal_Code INT = 3667,
	--@Deal_Movie_Codes VARCHAR(MAX) = '12414',
	--@User_Code INT = 137,
	--@Agreement_Date date = '11/05/2017 00:00:00'
	SET FMTONLY OFF
	SET NOCOUNT OFF

	PRINT 'Process started for Template'

	PRINT '  Drop #Temp_Deal_Movie, if exists'
	IF(OBJECT_ID('TEMPDB..#Temp_Deal_Movie') IS NOT NULL)
		DROP TABLE #Temp_Deal_Movie

	PRINT '  Create #Temp_Deal_Movie'
	CREATE TABLE #Temp_Deal_Movie
	(
		Deal_Movie_Code	INT,
		Episode_From	INT,
		Episode_To		INT,
		Title_Code		INT
	)
	
	PRINT '  Declare variables'
	DECLARE 
		@Status	CHAR(1), @Error_Message VARCHAR(MAX), @Is_ROFR CHAR(1), @ROFR_Days INT, @ROFR_Date DATETIME,  @END_Date DATETIME, @Right_Start_Date DATETIME, 
		@Term FLOAT, @Right_Type CHAR(1), @Year INT, @Month INT, @Milestone_No_Of_Unit INT, @Milestone_Unit_Type INT, @Is_Tentetive CHAR(1), 
		@Acq_Deal_Rights_Code INT, @Syn_Deal_Rights_Code INT, @Type CHAR(1), @Is_Tentative CHAR(1), @Platform_Codes VARCHAR(1000), @Region_Type CHAR(1), 
		@Region_Codes VARCHAR(1000), @Subtitling_Type CHAR(1), @Subtitling_Codes VARCHAR(1000),  @Dubbing_Type CHAR(1), @Dubbing_Codes VARCHAR(1000)

	PRINT '  Select Data from Acq_Rights_Template and set in variables'
	SELECT 
		@Right_Type = Right_Type, 
		@ROFR_Days = ROFRDays , 
		@Right_Start_Date = ISNULL(CONVERT(date, @Agreement_Date,105),''),
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

	PRINT '  Calculation of Year Based / Milestone / Perpetuity'
	SELECT @Year = number FROM fn_Split_withdelemiter(@Term,'.') WHERE id = 1
	SELECT @Month = number FROM fn_Split_withdelemiter(@Term,'.') WHERE id = 2

	IF (@Right_Type = 'Y')
	BEGIN
		PRINT '    Calculation of Year Based'
		IF(@Year > 0)
		BEGIN
			SELECT @END_Date =  DATEADD(yy,@Year,@Right_Start_Date)
		END
		IF(@Month > 0)
		BEGIN
			SELECT @END_Date =  DATEADD(mm,@Month,@END_Date)
		END
		IF(@ROFR_Days > 0)
		BEGIN
			SELECT @ROFR_Date =	 DATEADD(dd,- @ROFR_Days,@END_Date), @Is_ROFR = 'Y'
		END
		ELSE
		BEGIN
			SELECT  @Is_ROFR = 'N'
		END
	END
	ELSE IF	 (@Right_Type = 'M')
	BEGIN	
		PRINT '    Calculation of Milestone'
		SELECT @END_Date =	
			CASE 
				WHEN @Milestone_Unit_Type = 1 THEN  DATEADD(DAY,@Milestone_No_Of_Unit,@Right_Start_Date) 
				WHEN @Milestone_Unit_Type = 2 THEN  DATEADD(WEEK,@Milestone_No_Of_Unit,@Right_Start_Date) 
				WHEN @Milestone_Unit_Type = 3 THEN DATEADD(MONTH,@Milestone_No_Of_Unit,@Right_Start_Date) 
				ELSE  DATEADD(YEAR,@Milestone_No_Of_Unit,@Right_Start_Date) 
			END

		IF(@ROFR_Days > 0)
		BEGIN
			SELECT @ROFR_Date =	 DATEADD(dd,- @ROFR_Days,@END_Date),  @Is_ROFR = 'Y'
		END
		ELSE
		BEGIN
			SELECT  @Is_ROFR = 'N'
		END	
	END
	ELSE IF	 (@Right_Type = 'U')
	BEGIN
		PRINT '    Calculation of Perpetuity'
		IF(@Year > 0)
		BEGIN
			SELECT @END_Date =  DATEADD(yy,@Year,@Right_Start_Date) , @Is_ROFR = 'N'
		END
	END

	BEGIN TRY 
		BEGIN TRANSACTION 
		PRINT '  Transaction started'
		IF (@Type = 'A')
		BEGIN
			PRINT '    Process started for Acquisition Deal'
			PRINT '    Insert data in #Temp_Deal_Movie'
			INSERT INTO #Temp_Deal_Movie (Deal_Movie_Code, Episode_From, Episode_To, Title_Code)
			SELECT ADM.Acq_Deal_Movie_Code, ADM.Episode_Starts_From, ADM.Episode_End_To, ADM.Title_Code 
			FROM Acq_Deal_Movie ADM 
			WHERE Acq_Deal_Movie_Code IN (SELECT number FROM fn_Split_withdelemiter(@Deal_Movie_Codes,','))

			PRINT '    Insert data in Acq_Deal_Rights'
			INSERT INTO Acq_Deal_Rights
			(
				Acq_Deal_Code, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, Right_Type, Is_Tentative, Is_Exclusive,
				Term, Right_Start_Date, 
				Right_End_Date, 
				Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date,
				Effective_Start_Date, Actual_Right_Start_Date, 
				Actual_Right_End_Date, 
				Inserted_By, Inserted_On, Is_Verified, Original_Right_Type
			)
			SELECT 
				@Deal_Code, Is_Title_Language, Is_Sublicense, SubLicense_Code, Is_Theatrical, Right_Type, Is_Tentative, Is_Exclusive,
				Term, @Right_Start_Date, 
				CASE WHEN @Is_Tentative = 'N' THEN @END_Date WHEN @Is_Tentative = 'Y' THEN NULL END AS Right_End_Date,
				Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, @Is_ROFR, @ROFR_Date,
				@Right_Start_Date, @Right_Start_Date,
				CASE WHEN @Is_Tentative = 'N' THEN @END_Date WHEN @Is_Tentative = 'Y' THEN NULL END AS Actual_Right_End_Date,
				@User_Code, GETDATE(), 'Y' AS Is_Verified, Right_Type
			FROM  Acq_Rights_Template

			PRINT '    Select newly instered @Acq_Deal_Rights_Code'
			SELECT @Acq_Deal_Rights_Code = IDENT_CURRENT ('Acq_Deal_Rights') 

			PRINT '    Insert data in Acq_Deal_Rights_Title'
			INSERT INTO Acq_Deal_Rights_Title
			(
				Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To
			)
			SELECT @Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To 
			FROM #Temp_Deal_Movie

			PRINT '    Insert data in Acq_Deal_Rights_Platform'
			IF (UPPER(@Platform_Codes) = 'ALL')
			BEGIN
				PRINT '      All Platforms'	
				INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)
				SELECT @Acq_Deal_Rights_Code , Platform_Code FROM Platform where Is_Last_Level = 'Y'
			END
			ELSE
			BEGIN
				PRINT '      Selected Platforms : ' + @Platform_Codes	
				INSERT INTO Acq_Deal_Rights_Platform(Acq_Deal_Rights_Code, Platform_Code)
				SELECT @Acq_Deal_Rights_Code, NUMBER AS Platform_Code FROM fn_Split_withdelemiter(@Platform_Codes,',') WHERE NUMBER <> ''
			END
				
			PRINT '    Insert data in Acq_Deal_Rights_Territory'
			INSERT INTO Acq_Deal_Rights_Territory
			(
				Acq_Deal_Rights_Code, Territory_Type, 
				Territory_Code, 
				Country_Code
			)
			SELECT @Acq_Deal_Rights_Code , @Region_Type,
				CASE WHEN @Region_Type = 'G' THEN NUMBER ELSE NULL END AS Territory_Code,
				CASE WHEN @Region_Type <> 'G' THEN NUMBER ELSE NULL END AS Country_Code
			FROM fn_Split_withdelemiter(@Region_Codes,',') WHERE NUMBER <> ''
			
			PRINT '    Insert data in Acq_Deal_Rights_Subtitling'
			INSERT INTO Acq_Deal_Rights_Subtitling
			(
				Acq_Deal_Rights_Code, Language_Type,
				Language_Group_Code,
				Language_Code
			)
			SELECT @Acq_Deal_Rights_Code, @Subtitling_Type,
				CASE WHEN @Subtitling_Type = 'G' THEN NUMBER ELSE NULL END AS Language_Group_Code,
				CASE WHEN @Subtitling_Type <> 'G' THEN NUMBER ELSE NULL END AS Language_Code
			FROM fn_Split_withdelemiter(@Subtitling_Codes,',') WHERE NUMBER <> ''

			PRINT '    Insert data in Acq_Deal_Rights_Dubbing'
			INSERT INTO Acq_Deal_Rights_Dubbing
			(
				Acq_Deal_Rights_Code, Language_Type,
				Language_Group_Code,
				Language_Code
			)
			SELECT @Acq_Deal_Rights_Code, @Dubbing_Type,
				CASE WHEN @Dubbing_Type = 'G' THEN NUMBER ELSE NULL END AS Language_Group_Code,
				CASE WHEN @Dubbing_Type <> 'G' THEN NUMBER ELSE NULL END AS Language_Code
			FROM fn_Split_withdelemiter(@Dubbing_Codes,',') WHERE NUMBER <> ''
		END
		ELSE IF (@Type = 'S')
		BEGIN
			PRINT '    Process started for Syndication Deal'
			PRINT '    Insert data in #Temp_Deal_Movie'
			INSERT INTO #Temp_Deal_Movie (Deal_Movie_Code, Episode_From, Episode_To, Title_Code)
			SELECT SDM.Syn_Deal_Movie_Code, SDM.Episode_From, SDM.Episode_End_To, SDM.Title_Code 
			FROM Syn_Deal_Movie SDM 
			WHERE Syn_Deal_Movie_Code IN (SELECT number FROM fn_Split_withdelemiter(@Deal_Movie_Codes,','))

			PRINT '    Insert data in Syn_Deal_Rights'
			INSERT INTO Syn_Deal_Rights
			(
				Syn_Deal_Code,Is_Exclusive,Is_Title_Language_Right,Is_Sub_License,Sub_License_Code,Is_Theatrical_Right,Right_Type,Is_Tentative,
				Term,Right_Start_Date,
				Right_End_Date,
				Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_ROFR,ROFR_Date,Effective_Start_Date,Actual_Right_Start_Date,
				Actual_Right_End_Date,
				Is_Pushback,Inserted_By,Inserted_On,Right_Status,Is_Verified,Original_Right_Type
			)
			SELECT 
				@Deal_Code, Is_Exclusive, Is_Title_Language, Is_Sublicense, SubLicense_Code, Is_Theatrical, Right_Type, Is_Tentative,
				Term,Right_Start_Date,
				CASE WHEN @Is_Tentative = 'N' THEN @END_Date WHEN @Is_Tentative = 'Y' THEN NULL END AS Right_End_Date,
				Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, @Is_ROFR,@ROFR_Date, Right_Start_Date, Right_Start_Date,
				CASE WHEN @Is_Tentative = 'N' THEN @END_Date WHEN @Is_Tentative = 'Y' THEN NULL END AS Actual_Right_End_Date,
				'N' AS Is_Pushback,@User_Code, GETDATE(), 'P' AS Right_Status, 'Y' AS Is_Verified, Right_Type
			FROM  Acq_Rights_Template 

			PRINT '    Select newly instered @Syn_Deal_Rights_Code'
			SELECT @Syn_Deal_Rights_Code = IDENT_CURRENT ('Syn_Deal_Rights') 

			PRINT '    Insert data in Syn_Deal_Rights_Title'
			INSERT INTO Syn_Deal_Rights_Title
			(Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
			SELECT @Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To FROM #Temp_Deal_Movie
			
			PRINT '    Insert data in Syn_Deal_Rights_Platform'
			IF (UPPER(@Platform_Codes) = 'ALL')
			BEGIN
				PRINT '      All Platforms'	
				INSERT INTO Syn_Deal_Rights_Platform (Syn_Deal_Rights_Code,Platform_Code)
				SELECT @Syn_Deal_Rights_Code , Platform_Code FROM Platform where Is_Last_Level = 'Y'
			END
			ELSE
			BEGIN
				PRINT '      Selected Platforms : ' + @Platform_Codes	
				INSERT INTO Syn_Deal_Rights_Platform (Syn_Deal_Rights_Code,Platform_Code)
				SELECT @Syn_Deal_Rights_Code , NUMBER AS Platform_Code FROM fn_Split_withdelemiter(@Platform_Codes,',') WHERE NUMBER <> ''
			END
				
			PRINT '    Insert data in Syn_Deal_Rights_Territory'
			INSERT INTO Syn_Deal_Rights_Territory
			(
				Syn_Deal_Rights_Code, Territory_Type,
				Territory_Code,
				Country_Code
			)
			SELECT @Syn_Deal_Rights_Code, @Region_Type,
				CASE WHEN @Region_Type = 'G' THEN NUMBER ELSE NULL END AS Territory_Code,
				CASE WHEN @Region_Type <> 'G' THEN NUMBER ELSE NULL END AS Country_Code
			FROM fn_Split_withdelemiter(@Region_Codes,',') WHERE NUMBER <> ''
			
			PRINT '    Insert data in Syn_Deal_Rights_Subtitling'					
			INSERT INTO Syn_Deal_Rights_Subtitling
			(
				Syn_Deal_Rights_Code,Language_Type,
				Language_Group_Code,
				Language_Code
			)
			SELECT @Syn_Deal_Rights_Code, @Subtitling_Type, 
				CASE WHEN @Subtitling_Type = 'G' THEN NUMBER ELSE NULL END AS Language_Group_Code,
				CASE WHEN @Subtitling_Type <> 'G' THEN NUMBER ELSE NULL END AS Language_Code
			FROM fn_Split_withdelemiter(@Subtitling_Codes,',') WHERE NUMBER <> ''
				
			PRINT '    Insert data in Syn_Deal_Rights_Dubbing'					
			INSERT INTO Syn_Deal_Rights_Dubbing
			(
				Syn_Deal_Rights_Code,Language_Type,
				Language_Group_Code,
				Language_Code
			)
			SELECT @Syn_Deal_Rights_Code, @Dubbing_Type,
				CASE WHEN @Dubbing_Type = 'G' THEN NUMBER ELSE NULL END AS Language_Group_Code,
				CASE WHEN @Dubbing_Type <> 'G' THEN NUMBER ELSE NULL END AS Language_Code
			FROM fn_Split_withdelemiter(@Dubbing_Codes,',') WHERE NUMBER <> ''
		END
		PRINT '  Transaction Commited'
		COMMIT
		SELECT @Status = 'Y',@Error_Message =''
		SELECT @Status AS Status ,@Error_Message AS [Error_Message]
	END TRY
	BEGIN CATCH  
		ROLLBACK
		PRINT '  Transaction Rollbacked'
		SELECT @Status = 'E',@Error_Message = ERROR_MESSAGE()
		SELECT @Status AS Status ,@Error_Message AS [Error_Message]
	END CATCH 
END
