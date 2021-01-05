CREATE PROCEDURE [dbo].[USP_Report_AcqSyn_Expiry]
(
	@platformCodes	VARCHAR(MAX),
	@titleCodes	VARCHAR(MAX),
	@countryCodes VARCHAR(MAX),
	@Deal_Type VARCHAR(MAX), --A-Acq, S-Syn
	@IncludeDomestic Char(1),
	@IncludeSubDeal Char(1),
	@BusinessUnit_Code INT,
	@StartDate varchar(20),
	@EndDate varchar(20),
	@expiryDays	VARCHAR(MAX),
	@SysLanguageCode INT
)
AS

-- =============================================
-- Author:				Reshma Kunjal / Akshay Rane
-- Create DATE:			21-August-2015
-- Description:			Acquisition and Syndication Expiry Report
-- Last Updated DATE:	09-March-2018

-- *** Modification Desc ***
--	Abhaysingh N. Rajpurohit on (09 September 2015)
--		Added 'Partition by' Clause beacuse while renew the deal, we create new entry so we must take letest Right_End_Date
--					
-- =============================================
BEGIN
	 --DECLARE
	 --@platformCodes	VARCHAR(MAX) ='1',
	 --@titleCodes	VARCHAR(MAX) = '24007',
	 --@countryCodes VARCHAR(MAX) = '',
	 --@Deal_Type VARCHAR(MAX) = 'A', --A-Acq, S-Syn
	 --@IncludeDomestic Char(1)='N',
	 --@IncludeSubDeal Char(1)='N',
	 --@BusinessUnit_Code INT = 1,
	 --@StartDate varchar(20) = '',
	 --@EndDate varchar(20) = '',
	 --@expiryDays	VARCHAR(MAX) = '90E',
	 --@SysLanguageCode INT = 1

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

	IF OBJECT_ID('tempdb..#TempDealExpiryData') IS NOT NULL
		DROP TABLE #TempDealExpiryData


	DECLARE 
	@Col_Head01 NVARCHAR(MAX) = '',  
	@Col_Head02 NVARCHAR(MAX) = '',  
	@Col_Head03 NVARCHAR(MAX) = '',	
	@Col_Head04 NVARCHAR(MAX) = '',  
	@Col_Head05 NVARCHAR(MAX) = '',  
	@Col_Head06 NVARCHAR(MAX) = '',	
	@Col_Head07 NVARCHAR(MAX) = '',  
	@Col_Head08 NVARCHAR(MAX) = '',  
	@Col_Head09 NVARCHAR(MAX) = '',	
	@Col_Head10 NVARCHAR(MAX) = '',  
	@Col_Head11 NVARCHAR(MAX) = '',  
	@Col_Head12 NVARCHAR(MAX) = '',	
	@Col_Head13 NVARCHAR(MAX) = '',  
	@Col_Head14 NVARCHAR(MAX) = '',  
	@Col_Head15 NVARCHAR(MAX) = '',	
	@Col_Head16 NVARCHAR(MAX) = '',  
	@Col_Head17 NVARCHAR(MAX) = '',  
	@Col_Head18 NVARCHAR(MAX) = '',	
	@Col_Head19 NVARCHAR(MAX) = '',  
	@Col_Head20 NVARCHAR(MAX) = '',  
	@Col_Head21 NVARCHAR(MAX) = '',	
	@Col_Head22 NVARCHAR(MAX) = '',
	@Col_Head23 NVARCHAR(MAX) = '',
	@Col_Head24 NVARCHAR(MAX) = ''

	DECLARE @sql VARCHAR(MAX)= '' , @Range CHAR(1) = 'E'     
	SET @Range = RIGHT(@expiryDays,1)
	SET @expiryDays = STUFF(@expiryDays, LEN(@expiryDays), 1,'')



	SELECT number INTO #Temp_Title FROM dbo.fn_Split_withdelemiter(@titleCodes,',') WHERE number NOT IN('0', '')
	SELECT number INTO #Temp_Platform FROM dbo.fn_Split_withdelemiter(@platformCodes,',') WHERE number NOT IN('0', '')

	DECLARE @Deal_Type_Code_Music INT = 0, @Platform_For VARCHAR(2) = ''
	SELECT @Deal_Type_Code_Music = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name IN ('Deal_Type_Music')

	---Start Country Population ---

	DECLARE @territoryCodes VARCHAR(MAX), @country_Codes VARCHAR(MAX)
	SET @country_Codes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'C','') FROM fn_Split_withdelemiter(@countryCodes, ',') 
		WHERE number like 'C%' And number Not In('0')
	FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
		
	SET @territoryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@countryCodes, ',') 
		WHERE number like 'T%' And number Not In('0')
	FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

	IF(@countryCodes = '-1')
	BEGIN
		SET @country_Codes = '-1'
		SET @territoryCodes = '-1'
	END
		
	CREATE TABLE #Temp_Right_Code(Right_Code INT, Deal_Code INT, Status_Changed_On DATETIME)
	CREATE TABLE #Temp_Country(Country_Code INT)
	CREATE TABLE #Temp_Territory(Territory_Code INT)
	
	INSERT INTO #Temp_Country
	SELECT number FROM dbo.fn_Split_withdelemiter(@country_Codes,',') WHERE number <> '0'
	
	INSERT INTO #Temp_Territory
	SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCodes,',') WHERE number <> '0'

	---End Country Population ---

	DELETE FROM #Temp_Title WHERE number = 0
	DELETE FROM #Temp_Platform WHERE number = 0
	DELETE FROM #Temp_Territory WHERE Territory_Code = 0
	DELETE FROM #Temp_Country WHERE Country_Code = 0

	IF ((SELECT Count(*) FROM #Temp_Title) = 0)
		SET @titleCodes = '0'

	IF(LTRIM(RTRIM(@IncludeSubDeal)) = 'Y')
	BEGIN
		INSERT INTO #Temp_Title(number)
		SELECT DISTINCT ADM.Title_Code FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND AD.Is_Master_Deal = 'N' AND AD.Deal_Type_Code !=  @Deal_Type_Code_Music
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Master_Deal_Movie_Code_ToLink IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie ADM1 WHERE ADM1.Title_Code IN (Select number from #Temp_Title) OR @titleCodes = '0')
	END

	SELECT ADM.Acq_Deal_Movie_Code, ADM.Title_Code, L.Language_Name INTO #Temp_Title_Languages FROM Acq_Deal_Movie ADM
	INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
	INNER JOIN Language L ON T.Title_Language_Code = L.language_code
	WHERE ADM.Title_Code IN (Select number from #Temp_Title) OR @titleCodes = '0'

	IF ((SELECT Count(*) FROM #Temp_Platform) = 0)
		SET @platformCodes = '0'

	
	IF ((SELECT Count(*) FROM #Temp_Country) = 0)
		SET @countryCodes = '0'

	IF ((SELECT Count(*) FROM #Temp_Territory) = 0)
		SET @territoryCodes = '0'
	ELSE
	BEGIN
		INSERT INTO #Temp_Country(Country_Code)
		SELECT DISTINCT Country_Code FROM Territory_Details WHERE Territory_Code in (SELECT Territory_Code FROM #Temp_Territory)
	END


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
		ROFR_Date DATETIME,
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
		expDays INT,
		Status_Changed_On DATETIME,
		Due_Diligence  VARCHAR(12),
		Category_Name VARCHAR(MAX)
	)

	--DECLARE @StartDate AS date
	--DECLARE @EndDate AS date
	
	IF (@Range = 'P')
	BEGIN
		SET @StartDate = (SELECT CONVERT(date,@StartDate,103))
		SET @EndDate = (SELECT CONVERT(date,@EndDate,103))	
	END
	ELSE IF (@Range = 'E')
	BEGIN
		IF(@Deal_Type = 'AA' OR @Deal_Type = 'SA')
		BEGIN
			SET @StartDate = (SELECT CONVERT(date,GETDATE() - CAST(@expiryDays AS INT),103))
			SET @EndDate = (SELECT CONVERT(date,GETDATE(),103))	
		END
		ELSE
		BEGIN
			SET @StartDate = (SELECT CONVERT(date,GETDATE(),103))
			SET @EndDate = (SELECT CONVERT(date,GETDATE() + CAST(@expiryDays AS INT),103))	
		END
	END
	 
	--SELECT @StartDate ,@EndDate

	IF(LEFT(@Deal_Type, 1) = 'A')
	BEGIN

		IF OBJECT_ID('tempdb..#Acq_Deals') IS NOT NULL
			DROP TABLE #Acq_Deals

		CREATE  Table #Acq_Deals(
			Acq_Deal_Code INT,
			Status_Changed_On DATETIME
		)

		IF(@Deal_Type = 'AA')
		BEGIN
			
			DECLARE @ModuleStatusHistory TABLE(
				Record_Code INT,
				Status_Changed_On DATETIME
			)

			INSERT INTO @ModuleStatusHistory(Record_Code , Status_Changed_On)
			SELECT MD.Record_Code, MAX(MD.Status_Changed_On)
			FROM   Module_Status_History MD 
			WHERE  MD.Module_Code = 30  AND  MD.Status = 'A' 
			AND CONVERT(date,MD.Status_Changed_On,103) BETWEEN  cast(@StartDate as varchar(50))  AND  cast(@EndDate as varchar(50))
			GROUP BY  MD.Record_Code 
			
			INSERT INTO #Acq_Deals (Acq_Deal_Code,Status_Changed_On)
			SELECT  MD.Record_Code,MD.Status_Changed_On FROM Acq_Deal AD
			INNER JOIN @ModuleStatusHistory MD ON MD.Record_Code = AD.Acq_Deal_Code 
			WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Business_Unit_Code = @BusinessUnit_Code
		
		END
		ELSE
		BEGIN 
			INSERT INTO #Acq_Deals (Acq_Deal_Code)
			SELECT Acq_Deal_Code FROM Acq_Deal Where  Deal_Workflow_Status NOT IN ('AR', 'WA') AND Business_Unit_Code = @BusinessUnit_Code
		END

		Declare @SQL_Acq AS NVARCHAR(MAX) = '',  @Acq_Cond AS NVARCHAR(MAX) = ''

		IF(@Deal_Type = 'AA')
		BEGIN
			SET @SQL_Acq = 'INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code,Status_Changed_On)
				SELECT DISTINCT ADR.Acq_Deal_Rights_Code , AD.Acq_Deal_Code, AD.Status_Changed_On
				FROM Acq_Deal_Rights ADR 
				INNER JOIN #Acq_Deals AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
				INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code '
		END
		ELSE
		BEGIN
			SET @SQL_Acq = 'INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code)
				SELECT DISTINCT ADR.Acq_Deal_Rights_Code , AD.Acq_Deal_Code
				FROM Acq_Deal_Rights ADR 
				INNER JOIN #Acq_Deals AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
				INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code '
		END

		IF(@Deal_Type = 'AE')
		BEGIN
			SET @Acq_Cond ='WHERE Actual_Right_End_Date IS NOT NULL AND 
							CONVERT(date,Actual_Right_End_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''					
		END
		ELSE IF(@Deal_Type = 'AS')
		BEGIN
			SET @Acq_Cond ='WHERE Actual_Right_Start_Date IS NOT NULL AND
							CONVERT(date,Actual_Right_Start_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''					
		END
		ELSE IF(@Deal_Type = 'AT')
		BEGIN
			SET @Acq_Cond ='WHERE Actual_Right_Start_Date IS NOT NULL AND ADR.Is_Tentative = ''Y'' AND
							CONVERT(date,Actual_Right_Start_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''					
		END
		ELSE IF(@Deal_Type = 'AR')
		BEGIN
			SET @Acq_Cond ='WHERE ROFR_Date IS NOT NULL AND
							CONVERT(date,ROFR_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''					
		END
		--ELSE IF(@Deal_Type = 'AA')
		--BEGIN
		--	SET @Acq_Cond ='WHERE AD.Status_Changed_On IS NOT NULL AND 
		--					CONVERT(date,AD.Status_Changed_On,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''	
		--END

		PRINT @SQL_Acq + @Acq_Cond
		EXEC(@SQL_Acq + @Acq_Cond)

		Declare @CountryList_Acq TABLE(
			Country_Code INT,
			Acq_Deal_Code INT,
			Right_Code INT
		)

		INSERT INTO @CountryList_Acq (Country_Code, Acq_Deal_Code, Right_Code)
		SELECT DISTINCT		CASE ADRC.Territory_Type
							WHEN 'I' THEN ADRC.Country_Code
							ELSE TD.Country_Code
							END AS Country_Code 
							, AD.Acq_Deal_Code, ADR.Right_Code
		FROM #Acq_Deals AD
		INNER JOIN #Temp_Right_Code ADR ON ADR.Deal_Code = AD.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Territory ADRC ON ADR.Right_Code = ADRC.Acq_Deal_Rights_Code
		LEFT JOIN Territory_Details TD ON 
		(ADRC.Territory_Code = TD.Territory_Code AND ADRC.Territory_Type = 'G') OR 
		(ADRC.Country_Code = TD.Country_Code	AND ADRC.Territory_Type = 'I')
		WHERE ((TD.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (TD.Territory_Code IN (SELECT tt.Territory_Code FROM #Temp_Territory tt)))
		OR (@countryCodes = '0' AND @territoryCodes = '0')

		SET @Platform_For = 'AR'
		
		INSERT INTO #Temp_Rights(
			Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink,
			Right_Type, Right_Start_Date, Right_End_Date, ROFR_Date, Term, Milestone_Type_Code, 
			Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative,
			Is_Title_Language_Right, Is_Exclusive,
			Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To, Platform_Code,
			Country_Code, Status_Changed_On, Due_Diligence, Category_Name
			--, expDays
		)
		SELECT DISTINCT AD.Agreement_No, AD.Deal_Desc, AD.Is_Master_Deal, AD.Vendor_Code, AD.Deal_Type_Code, AD.Master_Deal_Movie_Code_ToLink
		, ADR.Right_Type, ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.ROFR_Date, ADR.Term , ADR.Milestone_Type_Code
		, ADR.Milestone_No_Of_Unit, ADR.Milestone_Unit_Type, ADR.Is_Sub_License, ADR.Sub_License_Code, ADR.Is_Tentative
		, ADR.Is_Title_Language_Right, ADR.Is_Exclusive
		, AD.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To , ADRP.Platform_Code
		, ADRC.Country_Code, trc.Status_Changed_On, ADM.Due_Diligence,C.Category_Name
		--,DATEDIFF(d, GETDATE(), ISNULL(ADR.Actual_Right_End_Date , GETDATE())) AS expDays
		FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND AD.Business_Unit_Code = @BusinessUnit_Code
		INNER JOIN Acq_Deal_Rights ADR ON (ADM.Acq_Deal_Code = ADR.Acq_Deal_Code OR AD.Acq_Deal_Code = ADR.Acq_Deal_Code)
		INNER JOIN #Temp_Right_Code trc ON ADR.Acq_Deal_Rights_Code = trc.Right_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			AND ADM.Title_Code = ADRT.Title_Code AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
		INNER JOIN @CountryList_Acq ADRC ON ADR.Acq_Deal_Rights_Code = ADRC.Right_Code
		INNER JOIN Category C ON AD.Category_Code = C.Category_Code
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND (ADRP.Platform_Code in (SELECT number FROM #Temp_Platform) OR @platformCodes = '0')

		Declare @Acq_Right_sql AS NVARCHAR(MAX) = ''

		IF(@Deal_Type = 'AE')
		BEGIN
			SET @Acq_Right_sql = 'UPDATE #Temp_Rights SET expDays = DATEDIFF(d, GETDATE(), ISNULL(Right_End_Date , GETDATE()))'
		END
		ELSE IF(@Deal_Type = 'AS' OR @Deal_Type = 'AT')
		BEGIN
			SET @Acq_Right_sql = 'UPDATE #Temp_Rights SET expDays = DATEDIFF(d, GETDATE(), ISNULL(Right_Start_Date , GETDATE()))'
		END
		ELSE IF(@Deal_Type = 'AR')
		BEGIN
			SET @Acq_Right_sql = 'UPDATE #Temp_Rights SET expDays = DATEDIFF(d, GETDATE(), ISNULL(ROFR_Date , GETDATE()))'
		END

		EXEC(@Acq_Right_sql)
	END
	ELSE IF(LEFT(@Deal_Type, 1) = 'S')
	BEGIN
		IF OBJECT_ID('tempdb..#Syn_Deals') IS NOT NULL
			DROP TABLE #Syn_Deals

		CREATE  Table #Syn_Deals(
			Syn_Deal_Code INT,
			Status_Changed_On DATETIME
		)
	
		IF(@Deal_Type = 'SA')
		BEGIN

			DECLARE @ModuleStatusHistory_Syn TABLE(
				Record_Code INT,
				Status_Changed_On DATETIME
			)

			INSERT INTO @ModuleStatusHistory_Syn(Record_Code , Status_Changed_On)
			SELECT MD.Record_Code, MAX(MD.Status_Changed_On)
			FROM   Module_Status_History MD 
			WHERE  MD.Module_Code = 35  AND  MD.Status = 'A' 
			AND CONVERT(date,MD.Status_Changed_On,103) BETWEEN  cast(@StartDate as varchar(50))  AND  cast(@EndDate as varchar(50))
			GROUP BY  MD.Record_Code 

			INSERT INTO #Syn_Deals (Syn_Deal_Code, Status_Changed_On)
			SELECT  MD.Record_Code, MD.Status_Changed_On FROM Syn_Deal SD
			INNER JOIN @ModuleStatusHistory_Syn MD ON MD.Record_Code = SD.Syn_Deal_Code 
			WHERE SD.Business_Unit_Code = @BusinessUnit_Code
	
		END
		ELSE
		BEGIN 
			INSERT INTO #Syn_Deals (Syn_Deal_Code)
			SELECT Syn_Deal_Code FROM Syn_Deal Where Business_Unit_Code = @BusinessUnit_Code
		END
		

		Declare @SQL_Syn AS NVARCHAR(MAX) = '',  @Syn_Cond AS NVARCHAR(MAX) = ''

		IF(@Deal_Type = 'SA')
		BEGIN
			SET @SQL_Syn = 'INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code,Status_Changed_On)
				SELECT DISTINCT SDR.Syn_Deal_Rights_Code , SD.Syn_Deal_Code , SD.Status_Changed_On
				FROM Syn_Deal_Rights SDR
				INNER JOIN #Syn_Deals SD ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code '
		END
		ELSE
		BEGIN
			SET @SQL_Syn = 'INSERT INTO #Temp_Right_Code (Right_Code,Deal_Code)
			SELECT DISTINCT SDR.Syn_Deal_Rights_Code , SD.Syn_Deal_Code
			FROM Syn_Deal_Rights SDR
			INNER JOIN #Syn_Deals SD ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
			INNER JOIN Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code '
		END

		IF(@Deal_Type = 'SE')
		BEGIN
			SET @Syn_Cond ='WHERE Actual_Right_End_Date IS NOT NULL AND
							CONVERT(date,SDR.Actual_Right_End_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''					
		END
		ELSE IF(@Deal_Type = 'SS')
		BEGIN
			SET @Syn_Cond ='WHERE Actual_Right_Start_Date IS NOT NULL AND
							CONVERT(date,SDR.Actual_Right_Start_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''					
		END	
		--ELSE IF(@Deal_Type = 'SA')
		--BEGIN
		--	SET @Acq_Cond ='WHERE SD.Status_Changed_On IS NOT NULL AND 
		--					CONVERT(date,SD.Status_Changed_On,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' AND '''+ cast(@EndDate as varchar(50))+''''	
		--END
			
		EXEC(@SQL_Syn + @Syn_Cond)

		DECLARE @CountryList_Syn TABLE(
			Country_Code INT,
			Syn_Deal_Code INT,
			Right_Code INT
		)

		INSERT INTO @CountryList_Syn (Country_Code, Syn_Deal_Code, Right_Code)
		SELECT DISTINCT		CASE SDRC.Territory_Type
							WHEN 'I' THEN SDRC.Country_Code
							ELSE TD.Country_Code
							END AS Country_Code 
							, SD.Syn_Deal_Code, SDR.Right_Code
		FROM #Syn_Deals SD
		INNER JOIN #Temp_Right_Code SDR ON SDR.Deal_Code = SD.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights_Territory SDRC ON SDR.Right_Code = SDRC.Syn_Deal_Rights_Code
		LEFT JOIN Territory_Details TD ON 
		(SDRC.Territory_Code = TD.Territory_Code AND SDRC.Territory_Type = 'G') OR 
		(SDRC.Country_Code = TD.Country_Code	AND SDRC.Territory_Type = 'I')
		WHERE ((TD.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (TD.Territory_Code IN (SELECT tt.Territory_Code FROM #Temp_Territory tt)))
		OR (@countryCodes = '0' AND @territoryCodes = '0')
		
		SET @Platform_For = 'SR'
		INSERT INTO #Temp_Rights (
			Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink,
			Right_Type, Right_Start_Date, Right_End_Date, Term,Milestone_Type_Code, 
			Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative,
			Is_Title_Language_Right, Is_Exclusive,
			Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To, Platform_Code,
			Country_Code, Status_Changed_On
			--, expDays
		)

		SELECT DISTINCT SD.Agreement_No, SD.Deal_Description, 'Y' AS Is_Master_Deal, SD.Vendor_Code, SD.Deal_Type_Code, NULL AS Master_Deal_Movie_Code_ToLink
		, SDR.Right_Type, SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Term , SDR.Milestone_Type_Code
		, SDR.Milestone_No_Of_Unit, SDR.Milestone_Unit_Type, SDR.Is_Sub_License, SDR.Sub_License_Code, SDR.Is_Tentative
		, SDR.Is_Title_Language_Right, SDR.Is_Exclusive
		, SD.Syn_Deal_Code, SDR.Syn_Deal_Rights_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To , SDRP.Platform_Code
		, SDRC.Country_Code, trc.Status_Changed_On
		--,DATEDIFF(d, GETDATE(), ISNULL(SDR.Actual_Right_End_Date , GETDATE())) AS expDays
		FROM Syn_Deal SD
		INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND SD.Business_Unit_Code = @BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
		INNER JOIN #Temp_Right_Code trc ON SDR.Syn_Deal_Rights_Code = trc.Right_Code
		INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code
		INNER JOIN @CountryList_Syn SDRC ON SDR.Syn_Deal_Rights_Code = SDRC.Right_Code
		WHERE --ISNULL(SD.Is_Active, 'N') = 'Y' AND ISNULL(SDR.Right_Status, '') = 'C' AND
		(SDRP.Platform_Code in (SELECT number FROM #Temp_Platform) OR @platformCodes = '0')

		Declare @Syn_Right_sql AS NVARCHAR(MAX) = ''

		IF(@Deal_Type = 'SE')
		BEGIN
			SET @Syn_Right_sql = 'UPDATE #Temp_Rights SET expDays = DATEDIFF(d, GETDATE(), ISNULL(Right_End_Date , GETDATE()))'
		END
		ELSE IF(@Deal_Type = 'SS')
		BEGIN
			SET @Syn_Right_sql = 'UPDATE #Temp_Rights SET expDays = DATEDIFF(d, GETDATE(), ISNULL(Right_Start_Date , GETDATE()))'
		END

		EXEC(@Syn_Right_sql)

	END

	SELECT DISTINCT 
	ROW_NUMBER() OVER (PARTITION BY Title_Code, Eps_From, Eps_To, Platform_Code, TR.Country_Code ORDER BY Right_End_Date DESC) AS Row_Num
	, Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Code, Deal_Type_Code, Master_Deal_Movie_Code_ToLink
	, Right_Type, Right_Start_Date, Right_End_Date, ROFR_Date, Term , Milestone_Type_Code, Milestone_No_Of_Unit
	, Milestone_Unit_Type, Is_Sub_License, Sub_License_Code, Is_Tentative, Is_Exclusive, Is_Title_Language_Right
	, Deal_Code, Deal_Right_Code, Title_Code, Eps_From, Eps_To
	, C.Country_Name, TR.Country_Code, TR.Status_Changed_On
	, expDays, TR.Due_Diligence,TR.Category_Name
	INTO #Rights_Combination
	FROM #Temp_Rights TR
	INNER JOIN Country C ON C.Country_Code = TR.Country_Code
	WHERE ISNULL(C.Is_Theatrical_Territory, 'N') = @IncludeDomestic


	DELETE FROM #Rights_Combination 
	WHERE Row_Num > 1

	SELECT DISTINCT 
	Agreement_No, Deal_Desc, RC.Is_Master_Deal, V.Vendor_Name, TG.Deal_Type_Name, RC.Deal_Type_Code, Master_Deal_Movie_Code_ToLink
	, Right_Type, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type
	, CASE LTRIM(RTRIM(Is_Sub_License))
		WHEN 'Y' THEN SL.Sub_License_Name
		ELSE 'No Sub Licensing'
	END SubLicencing
	, Right_Start_Date, Right_End_Date, ROFR_Date , Term
	, Is_Tentative, Is_Exclusive
	, T.Title_Name, RC.Title_Code
	, Eps_From, Eps_To
	, CASE WHEN RC.Is_Title_Language_Right = 'Y' THEN ISNULL(TTL.language_name, '') ELSE 'No' END AS Title_Language
	, Deal_Right_Code
	, RC.Country_Name, RC.Country_Code, RC.Status_Changed_On
	, expDays
	, RC.Due_Diligence
	, RC.Category_Name
	INTO #TEMP
	FROM #Rights_Combination RC
	INNER JOIN Vendor V ON RC.Vendor_Code = V.Vendor_Code
	INNER JOIN Deal_Type TG ON RC.Deal_Type_Code = TG.Deal_Type_Code
	INNER JOIN #Temp_Title_Languages TTL ON 
		(TTL.Acq_Deal_Movie_Code = RC.Master_Deal_Movie_Code_ToLink AND RC.Is_Master_Deal = 'N' AND RC.Deal_Type_Code != @Deal_Type_Code_Music) 
		OR TTL.Title_Code = RC.Title_Code
	INNER JOIN Title T ON RC.Title_Code = T.title_code
	LEFT JOIN Sub_License SL ON RC.Sub_License_Code = SL.Sub_License_Code

	--- Select Distinct Rights Combination without Country
	SELECT DISTINCT Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Name, Deal_Type_Name, Deal_Type_Code, SubLicencing, Right_Start_Date, Right_End_Date, ROFR_Date, Term
	, Right_Type, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type
	, Is_Tentative, Is_Exclusive, Title_Name, Eps_From, Eps_To, Title_Language, Deal_Right_Code, Status_Changed_On, expDays, Due_Diligence, Category_Name
	INTO #Temp_Group_Rights
	FROM #TEMP

	--- Select Distinct Country againts Rights Combination
	SELECT DISTINCT Deal_Right_Code, Country_Name, Country_Code
	INTO #Temp_Group_Country
	FROM #TEMP
	-------------------------------------------

	DECLARE @Temp_Rights_Details TABLE(
		Deal_Right_Code INT,
		Platform_Codes NVARCHAR(MAX),
		Platform_Name NVARCHAR(MAX),
		Sub NVARCHAR(MAX),
		Dub NVARCHAR(MAX)
	)

	DECLARE @Temp_Platforms TABLE(
		Platform_Codes NVARCHAR(MAX),
		Platform_Name NVARCHAR(MAX)
	)

	INSERT INTO @Temp_Rights_Details (Deal_Right_Code)
	SELECT Distinct Deal_Right_Code 
	FROM #Temp_Group_Rights TGR

	Update @Temp_Rights_Details SET Platform_Codes = DBO.[UFN_Get_Platform_Name_Selected_Expiry](Deal_Right_Code, @Platform_For, @platformCodes), 
							  Sub = DBO.UFN_Get_Rights_Subtitling(Deal_Right_Code, @Deal_Type),
							  Dub = DBO.UFN_Get_Rights_Dubbing(Deal_Right_Code, @Deal_Type)

	INSERT INTO @Temp_Platforms(Platform_Codes)
	SELECT DISTINCT Platform_Codes FROM @Temp_Rights_Details

	UPDATE @Temp_Platforms SET  Platform_Name  = STUFF(
				(
					SELECT ', ' + Platform_Hiearachy from DBO.UFN_Get_Platform_With_Parent(Platform_Codes)
					FOR XML PATH('')
				),1,1,''
			)
	UPDATE trd SET trd.Platform_Name = a.Platform_Name
	FROM @Temp_Platforms a
	INNER JOIN @Temp_Rights_Details trd ON a.Platform_Codes = trd.Platform_Codes
	-------------------------------------------------------------------------------

	--- Select Distinct Rights Combination and Coma Seperate Country for that combination using Combination_ID
	SELECT 
	Agreement_No, Deal_Desc, Is_Master_Deal, Vendor_Name, Deal_Type_Name, SubLicencing, 
	Right_Start_Date, Right_End_Date , Status_Changed_On as 'Approved_On'
	--CASE 
	--	WHEN  @Deal_Type = 'AR' THEN CONVERT(DATETIME,ROFR_Date,103) --ISNULL(CAST(ROFR_Date AS VARCHAR(MAX)),'')
	--	ELSE '-'
	--END AS 'ROFR Date'
	, Term
	, Is_Tentative, Is_Exclusive, Title_Name
	,CASE Right_Type
		WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](Right_Start_Date, Right_End_Date, Term) 
		WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
		WHEN 'U' THEN 'Perpetuity'
	END Right_Term
	, CASE dbo.UFN_GetDealTypeCondition(Deal_Type_Code)
		WHEN 'DEAL_MUSIC' THEN '1'
		WHEN 'DEAL_PROGRAM' THEN CAST(Eps_From AS VARCHAR)
		ELSE '-'
	  END AS Episode_From
	, CASE dbo.UFN_GetDealTypeCondition(Deal_Type_Code)
		WHEN 'DEAL_MUSIC' THEN 
			CASE 
				WHEN Eps_From = 0 AND Eps_To = 0 THEN 'Unlimited' 
				ELSE CAST(Eps_To AS VARCHAR)
			END
		WHEN 'DEAL_PROGRAM' THEN CAST(Eps_To AS VARCHAR)
		ELSE '-'
	  END AS Episode_To, Title_Language
	  ,Tp.Platform_Name,Tp.Sub,Tp.Dub, expDays
	,STUFF(
			(
				--- Select Coma Seperate Country For Particular Rights Combination 
				SELECT ', ' + TGC.Country_Name FROM #Temp_Group_Country TGC WHERE TGC.Deal_Right_Code = TGR.Deal_Right_Code
				FOR XML PATH('')
            ),1,1,''
		) AS Country_Name
	, CASE UPPER(LTRIM(RTRIM(ISNULL(TGR.Due_Diligence, '')))) 
			WHEN 'N' THEN 'No'
			WHEN 'Y' THEN 'Yes'
			ELSE 'No' 
		END AS Due_Diligence,
		TGR.Category_Name AS Category_Name
		INTO #TempDealExpiryData
	FROM #Temp_Group_Rights TGR
	INNER JOIN  @Temp_Rights_Details Tp on Tp.Deal_Right_Code = TGR.Deal_Right_Code

	SELECT 
	@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
	@Col_Head02 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
	@Col_Head03 = CASE WHEN  SM.Message_Key = 'DealType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
	@Col_Head04 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
	@Col_Head05 = CASE WHEN  SM.Message_Key = 'EpisodeFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
	@Col_Head06 = CASE WHEN  SM.Message_Key = 'EpisodeTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
	@Col_Head07 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
	@Col_Head08 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
	@Col_Head09 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
	@Col_Head10 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
	@Col_Head11 = CASE WHEN  SM.Message_Key = 'ApprovedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
	@Col_Head12 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
	@Col_Head13 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
	@Col_Head14 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
	@Col_Head15 = CASE WHEN  SM.Message_Key = 'Exclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
	@Col_Head16 = CASE WHEN  SM.Message_Key = 'Sublicensing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
	@Col_Head17 = CASE WHEN  SM.Message_Key = 'Tentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
	@Col_Head18 = CASE WHEN  SM.Message_Key = 'RightTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
	@Col_Head19 = CASE WHEN  SM.Message_Key = 'ExpireInDays' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
	@Col_Head20 = CASE WHEN  SM.Message_Key = 'MasterDeal' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
	@Col_Head21 = CASE WHEN  SM.Message_Key = 'Vendor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
	@Col_Head22 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
	@Col_Head23 = CASE WHEN  SM.Message_Key = 'DueDiligence' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
	@Col_Head24 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END
	FROM System_Message SM  
	INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
	AND SM.Message_Key IN ('AgreementNo','DealDescription','DealType','Title','EpisodeFrom','EpisodeTo','Platform','Region','StartDate',
	'EndDate','ApprovedOn','TitleLanguage','Subtitling','Dubbing','Exclusive','Sublicensing','Tentative','RightTerm','ExpireInDays','MasterDeal','Vendor','Term','DueDiligence','CategoryName')  
	INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

	IF EXISTS(SELECT TOP 1 * FROM #TempDealExpiryData)
	BEGIN
		SELECT [Agreement No], [Deal Description], [Deal Type], [Title], [Episode From], [Episode To], [Platform], [Region], [Start Date],
		[End Date], [Approved On], [Title Language], [subtitling], [Dubbing], [Exclusive], [SubLicencing], [Tentative], [Right Term], [Expire In Days],
		[Master Deal], [Vendor Name], [Term], [Due Diligence],[Category Name]
			FROM (
				SELECT
				sorter = 1,
				CAST([Agreement_No] AS NVARCHAR(MAX)) AS [Agreement No], 
				CAST([Deal_Desc] AS VARCHAR(100)) AS [Deal Description], 
				CAST([Deal_Type_Name] AS VARCHAR(100)) AS [Deal Type],
				CAST([Title_Name] AS NVARCHAR(MAX)) AS [Title], 
				CAST([Episode_From] AS VARCHAR(100)) AS [Episode From], 
				CAST([Episode_To] AS VARCHAR(100)) AS [Episode To],
				CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], 
				CAST([Country_Name] AS VARCHAR(100)) AS [Region], 
				CAST([Right_Start_Date] AS VARCHAR(100)) AS [Start Date],
				CAST([Right_End_Date] AS NVARCHAR(MAX)) AS [End Date], 
				CAST([Approved_On] AS VARCHAR(100)) AS [Approved On], 
				CAST([Title_Language] AS VARCHAR(100)) AS [Title Language],
				CAST([Sub] AS NVARCHAR(MAX)) AS [subtitling], 
				CAST([Dub] AS VARCHAR(100)) AS [Dubbing], 
				CAST([Is_Exclusive] AS VARCHAR(100)) AS [Exclusive],
				CAST([SubLicencing] AS NVARCHAR(MAX)) AS [SubLicencing], 
				CAST([Is_Tentative] AS VARCHAR(100)) AS [Tentative], 
				CAST([Right_Term] AS VARCHAR(100)) AS [Right Term],
				CAST([expDays] AS NVARCHAR(MAX)) AS [Expire In Days], 
				CAST([Is_Master_Deal] AS VARCHAR(100)) AS [Master Deal], 
				CAST([Vendor_Name] AS VARCHAR(100)) AS [Vendor Name],
				CAST([Term] AS VARCHAR(100)) AS [Term],
				CAST([Due_Diligence] AS VARCHAR(100)) AS [Due Diligence],
				CAST([Category_Name] AS VARCHAR(MAX)) AS [Category Name]
				From #TempDealExpiryData
				UNION ALL
					SELECT 0, @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11, @Col_Head12
					, @Col_Head13, @Col_Head14, @Col_Head15, @Col_Head16, @Col_Head17, @Col_Head18, @Col_Head19, @Col_Head20, @Col_Head21, @Col_Head22, @col_Head23,@Col_Head24
				) X   
		ORDER BY Sorter
	END
	ELSE
	BEGIN
		SELECT * FROM #TempDealExpiryData
	END

	IF OBJECT_ID('tempdb..#Acq_Deals') IS NOT NULL DROP TABLE #Acq_Deals
	IF OBJECT_ID('tempdb..#Final_Rights_Combination') IS NOT NULL DROP TABLE #Final_Rights_Combination
	IF OBJECT_ID('tempdb..#Rights_Combination') IS NOT NULL DROP TABLE #Rights_Combination
	IF OBJECT_ID('tempdb..#Syn_Deals') IS NOT NULL DROP TABLE #Syn_Deals
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
	IF OBJECT_ID('tempdb..#TempDealExpiryData') IS NOT NULL DROP TABLE #TempDealExpiryData

END
/*
EXEC USP_Report_AcqSyn_Expiry 
@platformCodes = '0',
@titleCodes	= '',
@countryCodes = '',
@Deal_Type = 'AE',
@IncludeDomestic = 'N',
@IncludeSubDeal = 'N',
@BusinessUnit_Code = 7,
@StartDate = '14-03-2018',
@EndDate = '13-03-2019',
@expiryDays = '90E',
@SysLanguageCode = 1

*/