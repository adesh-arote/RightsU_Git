CREATE PROCEDURE [dbo].[USP_Syndication_Sales_Report]
(
	@Business_Unit_Code INT,
	@Title_Codes VARCHAR(MAX),
	@Platform_Codes VARCHAR(MAX),
	@Show_Expired CHAR(1),
	@Country_Codes VARCHAR(MAX),
	@Start_Date VARCHAR(20),
	@End_Date VARCHAR(20),
	@IncludeDomestic Char(1)
)
AS
--Date / Country
-- =============================================
-- Author:		RESHMA KUNJAL
-- Create DATE: 16-April-2015
-- Description:	Show Platform wise report for Syndciation
-- =============================================
BEGIN
		
	CREATE TABLE #Temp_Platforms
	(
		Agreement_No VARCHAR(MAX),
		Agreement_Date DATETIME
		,Deal_Desc NVARCHAR(MAX)
		,Title_Name NVARCHAR(MAX)
		,Right_Type NVARCHAR(MAX)
		,Syn_Deal_Rights_Code INT
		,Term VARCHAR(MAX)
		,Actual_Right_Start_Date DATETIME
		,Actual_Right_End_Date DATETIME
		,Title_Language NVARCHAR(MAX)
		,Platform_Hiearachy NVARCHAR(MAX)
		,Platform_Code INT
		,Available NVARCHAR(MAX)
		,Revenue Decimal(18, 2)
		,Deal_Status VARCHAR(100)
	)
		
	----------------- Platform Population 
	SELECT DISTINCT number AS Platform_Code INTO #Temp_Selected_Platforms FROM fn_Split_withdelemiter(@Platform_Codes, ',') WHERE ISNULL(number, '') <> '';
	IF((SELECT COUNT(*) FROM #Temp_Selected_Platforms) = 0)
	BEGIN
		INSERT INTO #Temp_Selected_Platforms(Platform_Code)
		SELECT Platform_Code FROM Platform WHERE Is_Last_Level = 'Y'
	END

	----------------- Country Population 
	DECLARE @countryCodes VARCHAR(MAX), @territoryCodes VARCHAR(MAX) , @cntryCnt int = 0
	SET @countryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number, 'C', '') FROM fn_Split_withdelemiter(@Country_Codes, ',') WHERE number LIKE 'C%' 
	AND number NOT IN('0')
	    FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)')
    , 1, 1, ''), '')

	SELECT DISTINCT number AS Country_Code INTO #Temp_Countrys FROM fn_Split_withdelemiter(@countryCodes, ',') WHERE ISNULL(number, '') <> '';
	
	SET @territoryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Codes, ',') WHERE number LIKE 'T%' 
	AND number NOT IN('0')
	    FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)')
    , 1, 1, ''), '')
	
	SELECT DISTINCT number AS Territory_Code INTO #Temp_Territorys FROM fn_Split_withdelemiter(@territoryCodes, ',') WHERE ISNULL(number, '') <> '';

	IF NOT EXISTS (SELECT * FROM #Temp_Territorys) AND @Country_Codes != '-1'
	BEGIN
			INSERT INTO #Temp_Territorys
			SELECT Territory_Code FROM Territory WHERE ISNULL(Is_Active, 'Y') ='Y' AND ISNULL(Is_Thetrical, 'N') = @IncludeDomestic
		
	END
	IF NOT EXISTS (SELECT * FROM #Temp_Countrys) AND @Country_Codes != '-1'
	BEGIN
		INSERT INTO #Temp_Countrys
		SELECT Country_Code FROM Country WHERE ISNULL(Is_Theatrical_Territory, 'N') = @IncludeDomestic AND ISNULL(Is_Active, 'Y') ='Y'
	END

	----------------- Title Population 
	SELECT DISTINCT number AS Title_Code INTO #Temp_Selected_Titles FROM fn_Split_withdelemiter(@Title_Codes, ',') WHERE ISNULL(number, '') <> '';

	----------------- Fetch Population 
	INSERT INTO #Temp_Platforms
	SELECT 
			DISTINCT sd.Agreement_No, sd.Agreement_Date, sd.Deal_Description, 
			DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(sd.Deal_Type_Code), t.Title_Name, sdrt.Episode_From, sdrt.Episode_To) AS Title_Name
			, sdr.Right_Type, sdr.Syn_Deal_Rights_Code
			,CASE sdr.Right_Type
						   WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](sdr.Actual_Right_Start_Date, sdr.Actual_Right_End_Date, sdr.Term) 
						   WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](sdr.Milestone_Type_Code, sdr.Milestone_No_Of_Unit, sdr.Milestone_Unit_Type)
						   WHEN 'U' THEN 'Perpetuity'
					   END AS Term
			, sdr.Actual_Right_Start_Date
			, ISNULL(sdr.Actual_Right_End_Date, '9999-12-31')
			, CASE WHEN Is_Title_Language_Right = 'Y' THEN ISNULL(L.Language_Name, 'No') ELSE '' END AS Language_Name
			, Platform_Hiearachy
			, p.Platform_Code
			, 'YES' Available
			, sd_Revenue.Revenue
			, CASE sd.Deal_Workflow_Status
				WHEN 'A' THEN 'Approved'
				WHEN 'AM' THEN 'Ammend'
				WHEN 'N' THEN 'Pending'
				WHEN 'R' THEN 'Rejected'
				WHEN 'W' THEN 'Waiting for Authorization'
			END AS Deal_Status
	FROM Syn_Deal sd
	INNER JOIN Syn_Deal_Movie sdm ON sd.Syn_Deal_Code = sdm.Syn_Deal_Code AND sd.Business_Unit_Code = @Business_Unit_Code 
		AND (Title_Code IN (SELECT Title_Code FROM #Temp_Selected_Titles) OR @Title_Codes = '')
	INNER JOIN Syn_Deal_Rights sdr ON sd.Syn_Deal_Code = sdr.Syn_Deal_Code 
	INNER JOIN Syn_Deal_Rights_Platform sdrp ON sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code AND 
		(@Show_Expired = 'Y' OR ISNULL(sdr.Actual_Right_End_Date, GETDATE()) >= GETDATE()) 
	INNER JOIN Syn_Deal_Rights_Title sdrt ON sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code AND sdm.Title_Code = sdrt.Title_Code
	INNER JOIN Title t ON sdrt.Title_Code = t.Title_Code
	INNER JOIN Platform p ON p.Platform_Code = sdrp.Platform_Code
	INNER JOIN #Temp_Selected_Platforms pTEMP ON pTEMP.Platform_Code = P.Platform_Code
	LEFT JOIN Language L ON L.Language_Code = T.Title_Language_Code 
	LEFT JOIN 
	(SELECT convert(decimal(18, 2), SUM(ISNULL(sdRev.DEAL_COST, 0))) Revenue, sdRev.Syn_Deal_Code  FROM Syn_Deal_Revenue sdRev GROUP BY sdRev.Syn_Deal_Code) sd_Revenue
	ON sd_Revenue.Syn_Deal_Code = sd.Syn_Deal_Code
	WHERE sdr.Right_Status = 'C' AND ISNULL(sd.Agreement_Date, '9999-12-31') >= @Start_Date
		  AND ISNULL(sd.Agreement_Date, '9999-12-31') <=  @End_Date
		  AND (
				(sdr.Syn_Deal_Rights_Code IN 
					(SELECT sdrt.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Territory sdrt 
					WHERE (sdrt.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Countrys tc 
						INNER JOIN Country c ON c.Country_Code = tc.Country_Code
						WHERE ISNULL(c.Is_Theatrical_Territory, 'N') = @IncludeDomestic) AND sdrt.Territory_Type = 'I')
					OR (sdrt.Territory_Code IN (SELECT tmpTT.Territory_Code FROM #Temp_Territorys tmpTT INNER JOIN Territory tmpT on 
						tmpT.Territory_Code= tmpTT.Territory_Code  WHERE ISNULL(TmpT.Is_Thetrical, 'N') = @IncludeDomestic
					) AND sdrt.Territory_Type = 'G'))
				) 
		  )

		 
	------------------- #Temp_Platforms Alter 
	ALTER TABLE #Temp_Platforms
	ADD Region_Names NVARCHAR(MAX), 
		Subtitling_Names NVARCHAR(MAX),
		Dubbing_Names NVARCHAR(MAX)
			
	UPDATE #Temp_Platforms SET 
	Region_Names = DBO.[UFN_Get_Rights_Country_IsDomestic](Syn_Deal_Rights_Code, 'S', @IncludeDomestic),
	Subtitling_Names = DBO.UFN_Get_Rights_Subtitling(Syn_Deal_Rights_Code, 'S'),
	Dubbing_Names = DBO.UFN_Get_Rights_Dubbing(Syn_Deal_Rights_Code, 'S')

	UPDATE #Temp_Platforms SET Region_Names = DBO.UFN_Get_Rights_Territory(Syn_Deal_Rights_Code, 'S') WHERE LTRIM(RTRIM(Region_Names)) = ''
	UPDATE #Temp_Platforms SET Subtitling_Names = 'No' WHERE LTRIM(RTRIM(Subtitling_Names)) = ''
	UPDATE #Temp_Platforms SET Dubbing_Names = 'No' WHERE LTRIM(RTRIM(Dubbing_Names)) = ''
	
	SELECT * FROM #Temp_Platforms

	DROP TABLE #Temp_Platforms
	DROP TABLE #Temp_Selected_Platforms
	DROP TABLE #Temp_Selected_Titles
	DROP TABLE #Temp_Countrys
	DROP TABLE #Temp_Territorys
END

/*
EXEC [USP_Syndication_Sales_Report]
	@Business_Unit_Code =1,
	@Title_Codes ='',
	@Platform_Codes ='12',
	@Show_Expired ='Y',
	@Country_Codes ='',
	@Start_Date = '23-Sep-2010',
	@End_Date = '23-Sep-2017',
	@IncludeDomestic ='N'
*/
--select distinct deal_workflow_status from Syn_Deal