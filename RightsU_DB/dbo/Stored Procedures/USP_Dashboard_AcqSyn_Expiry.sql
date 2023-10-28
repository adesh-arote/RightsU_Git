CREATE PROCEDURE [dbo].[USP_Dashboard_AcqSyn_Expiry]
(
	@titleCodes	VARCHAR(MAX),
	@expiryDays	VARCHAR(MAX),
	@Deal_Type VARCHAR(100),
	@IncludeSubDeal Char(1),
	@Users_Code INT,
	@IsPushback CHAR(1)
)
AS
 --=============================================
 --Author:				Akshay Rane
 --Create DATE:			12-March-2018
 --Description:			Acquisition and Syndication Expiry Report				
 --=============================================
BEGIN
--DECLARE
--	@titleCodes	VARCHAR(MAX) = '',
--	@expiryDays	VARCHAR(MAX) = 30,
--	@Deal_Type VARCHAR(100)='AHB',
--	@IncludeSubDeal Char(1) = 'N',
--	@Users_Code INT = 137,
--	@IsPushback CHAR(1) = 'N'


Declare @Loglevel int;
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Dashboard_AcqSyn_Expiry]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	--DECLARE
	--@titleCodes	VARCHAR(MAX),
	--@expiryDays	VARCHAR(MAX),
	--@Deal_Type VARCHAR(1), --A-Acq, S-Syn
	--@IncludeSubDeal Char(1),
	--@Users_Code INT

	--SELECT
	--@titleCodes	= '',
	--@expiryDays	= '30',
	--@Deal_Type = 'S',
	--@IncludeSubDeal = 'N',
	--@Users_Code = 136

	IF OBJECT_ID('tempdb..#Temp_Right_Code') IS NOT NULL
		DROP TABLE #Temp_Right_Code

	IF OBJECT_ID('tempdb..#Temp_Country') IS NOT NULL
		DROP TABLE #Temp_Country
	IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL
		DROP TABLE #Temp_Title  
	IF OBJECT_ID('tempdb..#Temp_Title_Languages') IS NOT NULL
		DROP TABLE #Temp_Title_Languages
	IF OBJECT_ID('tempdb..#Temp_Platform') IS NOT NULL
		DROP TABLE #Temp_Platform
	IF OBJECT_ID('tempdb..#Temp_Territory') IS NOT NULL
		DROP TABLE #Temp_Territory
	IF OBJECT_ID('tempdb..#Temp_Rights') IS NOT NULL
		DROP TABLE #Temp_Rights
	IF OBJECT_ID('tempdb..#Rights_Combination') IS NOT NULL
		DROP TABLE #Rights_Combination
	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL
		DROP TABLE #TEMP
	IF OBJECT_ID('tempdb..#Temp_Group_Rights') IS NOT NULL
		DROP TABLE #Temp_Group_Rights
	IF OBJECT_ID('tempdb..#Temp_Group_Country') IS NOT NULL
		DROP TABLE #Temp_Group_Country
	IF OBJECT_ID('tempdb..#Final_Rights_Combination') IS NOT NULL
		DROP TABLE #Final_Rights_Combination

	DECLARE @sql VARCHAR(MAX)= '', @sql2 VARCHAR(MAX)= '',@sql3 VARCHAR(MAX)= '' 
    

	SELECT 0 AS number INTO #Temp_Title

	DECLARE @Deal_Type_Code_Music INT = 0, @Platform_For VARCHAR(2) = ''
	SELECT @Deal_Type_Code_Music = CAST(Parameter_Value AS INT) FROM System_Parameter_New WITH(NOLOCK) WHERE Parameter_Name IN ('Deal_Type_Music')
	
	CREATE TABLE #Temp_Right_Code(Right_Code INT, Deal_Code INT)
	
	SET @titleCodes = '0'

	IF(LTRIM(RTRIM(@IncludeSubDeal)) = 'Y')
	BEGIN
		INSERT INTO #Temp_Title(number)
		SELECT DISTINCT ADM.Title_Code FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN Acq_Deal_Movie ADM WITH(NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND AD.Is_Master_Deal = 'N' AND AD.Deal_Type_Code !=  @Deal_Type_Code_Music
		WHERE AD.Master_Deal_Movie_Code_ToLink IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie ADM1 WITH(NOLOCK) )
	END

	SELECT ADM.Acq_Deal_Movie_Code, ADM.Title_Code, L.Language_Name INTO #Temp_Title_Languages FROM Acq_Deal_Movie ADM WITH(NOLOCK)
	INNER JOIN Title T WITH(NOLOCK) ON ADM.Title_Code = T.Title_Code
	INNER JOIN Language L WITH(NOLOCK) ON T.Title_Language_Code = L.language_code
	


	CREATE TABLE #Temp_Rights
	(
		Agreement_No VARCHAR(MAX),
		Deal_Desc NVARCHAR(MAX),
		Is_Master_Deal CHAR(1),
		Vendor_Code INT,
		Deal_Type_Code INT,
		Master_Deal_Movie_Code_ToLink INT,
		Right_Type CHAR(1),
		Right_Start_Date DATETIME,
		Right_End_Date DATETIME,
		Term VARCHAR(12),
		Milestone_Type_Code INT,
		Milestone_No_Of_Unit INT,
		Milestone_Unit_Type INT,
		Is_Sub_License CHAR(1),
		Sub_License_Code INT,
		Is_Tentative CHAR(1),
		Is_Title_Language_Right CHAR(1),
		Is_Exclusive CHAR(1),
		Deal_Code INT,
		Deal_Right_Code INT,
		Title_Code INT,
		Eps_From INT,
		Eps_To INT,
		Platform_Code INT,
		Country_Code INT,
		expDays INT
	)
	
	IF(@Deal_Type = 'A')
	BEGIN
		Declare @Acq_Deals Table(
			Acq_Deal_Code Int
		)

		INSERT INTO @Acq_Deals
		SELECT Acq_Deal_Code FROM Acq_Deal WITH(NOLOCK) Where Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )

		INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code)
		SELECT DISTINCT ADR.Acq_Deal_Rights_Code , AD.Acq_Deal_Code 
		FROM Acq_Deal_Rights ADR WITH(NOLOCK) 
		INNER JOIN @Acq_Deals AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 
		WHERE Actual_Right_End_Date IS NOT NULL AND
		DATEDIFF(d, GETDATE(), ISNULL(Actual_Right_End_Date , GETDATE())) BETWEEN 0 AND @expiryDays

		SET @Platform_For = 'AR'
		INSERT INTO #Temp_Rights(
			Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink,
			Right_Type, Right_Start_Date, Right_End_Date, Term, Milestone_Type_Code, 
			Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative,
			Is_Title_Language_Right, Is_Exclusive,
			Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To,
			expDays
		)
		SELECT DISTINCT AD.Agreement_No, AD.Deal_Desc, AD.Is_Master_Deal, AD.Vendor_Code, AD.Deal_Type_Code, AD.Master_Deal_Movie_Code_ToLink
		, ADR.Right_Type, ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Term , ADR.Milestone_Type_Code
		, ADR.Milestone_No_Of_Unit, ADR.Milestone_Unit_Type, ADR.Is_Sub_License, ADR.Sub_License_Code, ADR.Is_Tentative
		, ADR.Is_Title_Language_Right, ADR.Is_Exclusive
		, AD.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To 
		,DATEDIFF(d, GETDATE(), ISNULL(ADR.Actual_Right_End_Date , GETDATE())) AS expDays
		FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN Acq_Deal_Movie ADM WITH(NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND AD.Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )
		INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON (ADM.Acq_Deal_Code = ADR.Acq_Deal_Code OR AD.Acq_Deal_Code = ADR.Acq_Deal_Code)
		INNER JOIN #Temp_Right_Code trc ON ADR.Acq_Deal_Rights_Code = trc.Right_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			AND ADM.Title_Code = ADRT.Title_Code AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
		WHERE AD.Deal_Workflow_Status = 'A'
	END
	ELSE IF(@Deal_Type = 'S')
	BEGIN
		Declare @Syn_Deals Table(
			Syn_Deal_Code Int
		)

		INSERT INTO @Syn_Deals
		SELECT Syn_Deal_Code FROM Syn_Deal WITH(NOLOCK) Where Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )

		
		INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code)
		SELECT DISTINCT SDR.Syn_Deal_Rights_Code , SD.Syn_Deal_Code 
		FROM Syn_Deal_Rights SDR WITH(NOLOCK)
		INNER JOIN @Syn_Deals SD ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code 
		WHERE Actual_Right_End_Date IS NOT NULL AND
		DATEDIFF(d, GETDATE(), ISNULL(SDR.Actual_Right_End_Date , GETDATE())) BETWEEN 0 AND @expiryDays
		AND SDR.Is_Pushback = @IsPushback


		Declare @CountryList_Syn TABLE(
			Country_Code INT,
			Syn_Deal_Code INT,
			Right_Code INT
		)

		SET @Platform_For = 'SR'
		INSERT INTO #Temp_Rights(
			Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink,
			Right_Type, Right_Start_Date, Right_End_Date, Term,Milestone_Type_Code, 
			Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative,
			Is_Title_Language_Right, Is_Exclusive,
			Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To,expDays
		)

		SELECT DISTINCT SD.Agreement_No, SD.Deal_Description, 'Y' AS Is_Master_Deal, SD.Vendor_Code, SD.Deal_Type_Code, NULL AS Master_Deal_Movie_Code_ToLink
		, SDR.Right_Type, SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Term , SDR.Milestone_Type_Code
		, SDR.Milestone_No_Of_Unit, SDR.Milestone_Unit_Type, SDR.Is_Sub_License, SDR.Sub_License_Code, SDR.Is_Tentative
		, SDR.Is_Title_Language_Right, SDR.Is_Exclusive
		, SD.Syn_Deal_Code, SDR.Syn_Deal_Rights_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To 
		,DATEDIFF(d, GETDATE(), ISNULL(SDR.Actual_Right_End_Date , GETDATE())) AS expDays
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND SD.Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
		INNER JOIN #Temp_Right_Code trc ON SDR.Syn_Deal_Rights_Code = trc.Right_Code
		WHERE ISNULL(SD.Is_Active, 'N') = 'Y' AND ISNULL(SDR.Right_Status, '') = 'C' AND SD.Deal_Workflow_Status = 'A'
	END
	ELSE IF(@Deal_Type = 'ARHB')
	BEGIN
		Declare @Acq_Deals_ARHB Table(
			Acq_Deal_Code Int
		)

		INSERT INTO @Acq_Deals_ARHB
		SELECT adp.Acq_Deal_Code 
		FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN Acq_Deal_Pushback adp ON adp.Acq_Deal_Code = ad.Acq_Deal_Code
		Where Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )

		INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code)
		SELECT DISTINCT ADR.Acq_Deal_Rights_Code , AD.Acq_Deal_Code 
		FROM Acq_Deal_Rights ADR WITH(NOLOCK) 
		INNER JOIN @Acq_Deals_ARHB AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Pushback adp ON adp.Acq_Deal_Code = ad.Acq_Deal_Code
		INNER JOIN Acq_Deal_Pushback_Title adpt ON adpt.Acq_Deal_Pushback_Code = adp.Acq_Deal_Pushback_Code
		--INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 
		WHERE adp.Right_End_Date IS NOT NULL AND
		DATEDIFF(d, GETDATE(), ISNULL(adp.Right_End_Date , GETDATE())) BETWEEN 0 AND @expiryDays


		
		SET @Platform_For = 'AR'
		INSERT INTO #Temp_Rights(
			Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink,
			Right_Type, Right_Start_Date, Right_End_Date, Term, Milestone_Type_Code, 
			Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative,
			Is_Title_Language_Right, Is_Exclusive,
			Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To,
			expDays
		)
		SELECT DISTINCT AD.Agreement_No, AD.Deal_Desc, AD.Is_Master_Deal, AD.Vendor_Code, AD.Deal_Type_Code, AD.Master_Deal_Movie_Code_ToLink
		, ADR.Right_Type, adp.Right_Start_Date, adp.Right_End_Date, ADR.Term , ADR.Milestone_Type_Code
		, ADR.Milestone_No_Of_Unit, ADR.Milestone_Unit_Type, ADR.Is_Sub_License, ADR.Sub_License_Code, ADR.Is_Tentative
		, ADR.Is_Title_Language_Right, ADR.Is_Exclusive
		, AD.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To 
		,DATEDIFF(d, GETDATE(), ISNULL(adp.Right_End_Date , GETDATE())) AS expDays
		FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN Acq_Deal_Movie ADM WITH(NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND AD.Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )
		INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON (ADM.Acq_Deal_Code = ADR.Acq_Deal_Code OR AD.Acq_Deal_Code = ADR.Acq_Deal_Code)
		INNER JOIN #Temp_Right_Code trc ON ADR.Acq_Deal_Rights_Code = trc.Right_Code
		INNER JOIN Acq_Deal_Pushback adp ON adp.Acq_Deal_Code = trc.Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			AND ADM.Title_Code = ADRT.Title_Code AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
		WHERE AD.Deal_Workflow_Status = 'A'

	END
	ELSE IF(@Deal_Type = 'SHB')
	BEGIN
		Declare @Syn_Deals_SHB Table(
			Syn_Deal_Code Int
		)

		INSERT INTO @Syn_Deals_SHB
		SELECT sd.Syn_Deal_Code 
		FROM Syn_Deal sd WITH(NOLOCK)
		INNER JOIN Syn_Deal_Rights sdr ON sdr.Syn_Deal_Code = sd.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights_Holdback sdrh ON sdrh.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
		 Where Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )

		
		INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code)
		SELECT DISTINCT SDR.Syn_Deal_Rights_Code , SD.Syn_Deal_Code 
		FROM Syn_Deal_Rights SDR WITH(NOLOCK)
		INNER JOIN @Syn_Deals_SHB SD ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights_Holdback srhb WITH(NOLOCK) ON srhb.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON srhb.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code 
		WHERE Actual_Right_End_Date IS NOT NULL AND
		DATEDIFF(d, GETDATE(), ISNULL(srhb.Holdback_Release_Date , GETDATE())) BETWEEN 0 AND @expiryDays


		SET @Platform_For = 'SR'
		INSERT INTO #Temp_Rights(
			Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink,
			Right_Type, Right_Start_Date, Right_End_Date, Term,Milestone_Type_Code, 
			Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative,
			Is_Title_Language_Right, Is_Exclusive,
			Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To,expDays
		)

		SELECT DISTINCT SD.Agreement_No, SD.Deal_Description, 'Y' AS Is_Master_Deal, SD.Vendor_Code, SD.Deal_Type_Code, NULL AS Master_Deal_Movie_Code_ToLink
		, SDR.Right_Type, SDR.Actual_Right_Start_Date, sdrh.Holdback_Release_Date, SDR.Term , SDR.Milestone_Type_Code
		, SDR.Milestone_No_Of_Unit, SDR.Milestone_Unit_Type, SDR.Is_Sub_License, SDR.Sub_License_Code, SDR.Is_Tentative
		, SDR.Is_Title_Language_Right, SDR.Is_Exclusive
		, SD.Syn_Deal_Code, SDR.Syn_Deal_Rights_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To 
		,DATEDIFF(d, GETDATE(), ISNULL(sdrh.Holdback_Release_Date , GETDATE())) AS expDays
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND SD.Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )
		INNER JOIN Syn_Deal_Rights_Holdback sdrh WITH(NOLOCK) ON sdrh.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
		INNER JOIN #Temp_Right_Code trc ON SDR.Syn_Deal_Rights_Code = trc.Right_Code
		WHERE ISNULL(SD.Is_Active, 'N') = 'Y' AND ISNULL(SDR.Right_Status, '') = 'C' AND SD.Deal_Workflow_Status = 'A'

	END
	ELSE IF(@Deal_Type = 'AHB')
	BEGIN
		Declare @Acq_Deals_AHB Table(
			Acq_Deal_Code Int
		)

		INSERT INTO @Acq_Deals_AHB
		SELECT ad.Acq_Deal_Code 
		FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN Acq_Deal_Rights adr WITH(NOLOCK) ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Holdback adrh WITH(NOLOCK) ON adrh.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		Where Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )



		INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code)
		SELECT DISTINCT ADR.Acq_Deal_Rights_Code , AD.Acq_Deal_Code 
		FROM Acq_Deal_Rights ADR WITH(NOLOCK) 
		INNER JOIN @Acq_Deals_AHB AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Holdback arhb ON arhb.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 
		WHERE Actual_Right_End_Date IS NOT NULL AND
		DATEDIFF(d, GETDATE(), ISNULL(arhb.Holdback_Release_Date , GETDATE())) BETWEEN 0 AND @expiryDays

		SET @Platform_For = 'AR'
		INSERT INTO #Temp_Rights(
			Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink,
			Right_Type, Right_Start_Date, Right_End_Date, Term, Milestone_Type_Code, 
			Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative,
			Is_Title_Language_Right, Is_Exclusive,
			Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To,
			expDays
		)
		SELECT DISTINCT AD.Agreement_No, AD.Deal_Desc, AD.Is_Master_Deal, AD.Vendor_Code, AD.Deal_Type_Code, AD.Master_Deal_Movie_Code_ToLink
		, ADR.Right_Type, ADR.Actual_Right_Start_Date, sdrh.Holdback_Release_Date, ADR.Term , ADR.Milestone_Type_Code
		, ADR.Milestone_No_Of_Unit, ADR.Milestone_Unit_Type, ADR.Is_Sub_License, ADR.Sub_License_Code, ADR.Is_Tentative
		, ADR.Is_Title_Language_Right, ADR.Is_Exclusive
		, AD.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To 
		,DATEDIFF(d, GETDATE(), ISNULL(sdrh.Holdback_Release_Date , GETDATE())) AS expDays
		FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN Acq_Deal_Movie ADM WITH(NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND AD.Business_Unit_Code IN (select Business_Unit_Code from Users_Business_Unit WITH(NOLOCK) where Users_Code = @Users_Code )
		INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON (ADM.Acq_Deal_Code = ADR.Acq_Deal_Code OR AD.Acq_Deal_Code = ADR.Acq_Deal_Code)
		INNER JOIN Acq_Deal_Rights_Holdback sdrh ON sdrh.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		INNER JOIN #Temp_Right_Code trc ON ADR.Acq_Deal_Rights_Code = trc.Right_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			AND ADM.Title_Code = ADRT.Title_Code AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
		WHERE AD.Deal_Workflow_Status = 'A'
	END

	SELECT DISTINCT 
	ROW_NUMBER() OVER (PARTITION BY Title_Code, Eps_From, Eps_To, Platform_Code, TR.Country_Code ORDER BY Right_End_Date DESC) AS Row_Num
	, Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink
	, Right_Type, Right_Start_Date, Right_End_Date, Term , Milestone_Type_Code, Milestone_No_Of_Unit
	, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative, Is_Exclusive, Is_Title_Language_Right
	, Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To
	, expDays
	INTO #Rights_Combination
	FROM #Temp_Rights TR

	DELETE FROM #Rights_Combination 
	WHERE Row_Num > 1

	SELECT DISTINCT 
	Deal_Code, Agreement_No, Deal_Desc, RC.Is_Master_Deal, V.Vendor_Name, TG.Deal_Type_Name, RC.Deal_Type_Code, Master_Deal_Movie_Code_ToLink
	, Right_Type, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type
	, CASE LTRIM(RTRIM(Is_Sub_License))
		WHEN 'Y' THEN SL.Sub_License_Name
		ELSE 'No Sub Licensing'
	END SubLicencing
	, Right_Start_Date, Right_End_Date, Term
	, Is_Tentative, Is_Exclusive
	, RC.Title_Code
	, Eps_From, Eps_To
	, CASE WHEN RC.Is_Title_Language_Right = 'Y' THEN ISNULL(TTL.language_name, '') ELSE 'No' END AS Title_Language
	, Deal_Right_Code
	, expDays
	INTO #TEMP
	FROM #Rights_Combination RC
	INNER JOIN Vendor V WITH(NOLOCK) ON RC.Vendor_Code = V.Vendor_Code
	INNER JOIN Deal_Type TG WITH(NOLOCK) ON RC.Deal_Type_Code = TG.Deal_Type_Code
	INNER JOIN #Temp_Title_Languages TTL ON 
		(TTL.Acq_Deal_Movie_Code = RC.Master_Deal_Movie_Code_ToLink AND RC.Is_Master_Deal = 'N' AND RC.Deal_Type_Code != @Deal_Type_Code_Music) 
		OR TTL.Title_Code = RC.Title_Code
	INNER JOIN Title T WITH(NOLOCK) ON RC.Title_Code = T.title_code
	LEFT JOIN Sub_License SL WITH(NOLOCK) ON RC.Sub_License_Code = SL.Sub_License_Code

	--- Select Distinct Rights Combination without Country
	SELECT DISTINCT Deal_Code, Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Name, Deal_Type_Name, Deal_Type_Code, SubLicencing, Right_Start_Date, Right_End_Date, Term
	, Right_Type, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type
	, Is_Tentative, Is_Exclusive, Eps_From, Eps_To, Title_Language, Deal_Right_Code, expDays
	INTO #Temp_Group_Rights
	FROM #TEMP

	--- Select Distinct Rights Combination and Coma Seperate Country for that combination using Combination_ID
	IF(@Deal_Type = 'SHB' OR @Deal_Type = 'AHB')
	BEGIN
		SET @sql = 'SELECT distinct  Agreement_No, Vendor_Name AS Customer, Deal_Code, Right_End_Date, 
					(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WITH(NOLOCK) WHERE Acq_Deal_Code = TGR.Deal_Code) AS Deal_Movie_Cost,
					CASE Right_Type
						WHEN ''U'' THEN ''Perpetuity'' 
						ELSE (Cast(Convert(VARCHAR(11),cast(Right_End_Date as datetime),103) as Varchar))
						END AS RightPeriod,'
	END
	ELSE
	BEGIN
		SET @sql = 'SELECT distinct  Agreement_No, Vendor_Name AS Customer, Deal_Code, Right_End_Date, 
					(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WITH(NOLOCK) WHERE Acq_Deal_Code = TGR.Deal_Code) AS Deal_Movie_Cost,
					CASE Right_Type
						WHEN ''U'' THEN ''Perpetuity'' 
						ELSE (Cast(Convert(VARCHAR(11),cast(Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(Right_End_Date as datetime),103) as Varchar))
						END AS RightPeriod,'

	END
	

	SET @sql2 = 'STUFF((SELECT Distinct '','' + ISNULL(Title_Name,Original_Title)
								FROM Acq_Deal_Movie ADM WITH(NOLOCK)
								INNER JOIN Title T WITH(NOLOCK) On T.title_code = ADM.Title_Code    
								WHERE ADM.Acq_Deal_Code =  TGR.Deal_Code
								FOR XML PATH('''')),1,1,'''') AS TitleName
				 FROM #Temp_Group_Rights TGR
				 Order by TGR.Right_End_Date ASC'

	SET @sql3 = 'STUFF((SELECT Distinct '','' + ISNULL(Title_Name,Original_Title)
								FROM Syn_Deal_Movie SDM WITH(NOLOCK)
								INNER JOIN Title T WITH(NOLOCK) On T.title_code = SDM.Title_Code    
								WHERE SDM.Syn_Deal_Code =  TGR.Deal_Code
								FOR XML PATH('''')),1,1,'''') AS TitleName
				FROM #Temp_Group_Rights TGR
				Order by TGR.Right_End_Date ASC'


	IF (@Deal_Type = 'A' OR @Deal_Type = 'ARHB' OR @Deal_Type = 'AHB')
		EXEC (@sql + @sql2)
	ELSE IF (@Deal_Type = 'S' OR @Deal_Type = 'SHB')
		EXEC (@sql + @sql3)

	IF OBJECT_ID('tempdb..#Final_Rights_Combination') IS NOT NULL DROP TABLE #Final_Rights_Combination
	IF OBJECT_ID('tempdb..#Rights_Combination') IS NOT NULL DROP TABLE #Rights_Combination
	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
	IF OBJECT_ID('tempdb..#Temp_Country') IS NOT NULL DROP TABLE #Temp_Country
	IF OBJECT_ID('tempdb..#Temp_Group_Country') IS NOT NULL DROP TABLE #Temp_Group_Country
	IF OBJECT_ID('tempdb..#Temp_Group_Rights') IS NOT NULL DROP TABLE #Temp_Group_Rights
	IF OBJECT_ID('tempdb..#Temp_Platform') IS NOT NULL DROP TABLE #Temp_Platform
	IF OBJECT_ID('tempdb..#Temp_Right_Code') IS NOT NULL DROP TABLE #Temp_Right_Code
	IF OBJECT_ID('tempdb..#Temp_Rights') IS NOT NULL DROP TABLE #Temp_Rights
	IF OBJECT_ID('tempdb..#Temp_Territory') IS NOT NULL DROP TABLE #Temp_Territory
	IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL DROP TABLE #Temp_Title
	IF OBJECT_ID('tempdb..#Temp_Title_Languages') IS NOT NULL DROP TABLE #Temp_Title_Languages
	
if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Dashboard_AcqSyn_Expiry]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END


