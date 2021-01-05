

CREATE PROC [dbo].[USP_Get_Dashboard_Data]
(
	@DataFor VARCHAR(MAX) = '',
	@BusinessUnitCodes VARCHAR(MAX) = '0'
)
AS
BEGIN

	SET FMTONLY OFF
	--DECLARE @DataFor VARCHAR(MAX) = 'TITLE_REGION'
	--DECLARE @BusinessUnitCodes VARCHAR(MAX) = '1'

	DECLARE 
	@topTerritoryCodeForDashboard VARCHAR(MAX) = '1,3,4,6,13,15',
	@topLanguageCodeForDashboard VARCHAR(MAX) = '1,2,24,37,45',
	@Only_ApprovedDeal_GraphicalDashboard_Acq VARCHAR(1) = 'N', 
	@Only_ApprovedDeal_GraphicalDashboard_Syn VARCHAR(1) = 'N'

	SELECT TOP 1 @topTerritoryCodeForDashboard = ISNULL(Parameter_Value, '') FROM System_Parameter_New  WITH(NOLOCK)
		WHERE Parameter_Name = 'TopTerritoryCodeForDashboard'

	SELECT TOP 1 @topLanguageCodeForDashboard = ISNULL(Parameter_Value, '') FROM System_Parameter_New  WITH(NOLOCK)
		WHERE Parameter_Name = 'TopLanguageCodeForDashboard'
		
	SELECT TOP 1 @Only_ApprovedDeal_GraphicalDashboard_Acq = ISNULL(Parameter_Value, '') FROM System_Parameter_New  WITH(NOLOCK)
		WHERE Parameter_Name = 'Only_ApprovedDeal_GraphicalDashboard_Acq'

	SELECT TOP 1 @Only_ApprovedDeal_GraphicalDashboard_Syn = ISNULL(Parameter_Value, '') FROM System_Parameter_New  WITH(NOLOCK)
		WHERE Parameter_Name = 'Only_ApprovedDeal_GraphicalDashboard_Syn'
	
	IF(OBJECT_ID('TEMPDB..#TempBusinessUnit') IS NOT NULL)
		DROP TABLE #TempBusinessUnit

	IF(OBJECT_ID('TEMPDB..#TempTerritory') IS NOT NULL)
		DROP TABLE #TempTerritory

	IF(OBJECT_ID('TEMPDB..#TempLanguage') IS NOT NULL)
		DROP TABLE #TempLanguage

	IF(OBJECT_ID('TEMPDB..#TempFinalData') IS NOT NULL)
		DROP TABLE #TempFinalData

	IF(OBJECT_ID('TEMPDB..#TempGroupCount') IS NOT NULL)
		DROP TABLE #TempGroupCount

	CREATE TABLE #TempBusinessUnit
	(
		BusinessUnit_Code INT
	)

	CREATE TABLE #TempGroupCount
	(
		Group_Code INT,
		Group_Total_Count INT,
		Group_Sold_Count INT
	)

	CREATE TABLE #TempTerritory
	(
		Territory_Code INT,
		Territory_Name NVARCHAR(MAX),
	)

	CREATE TABLE #TempLanguage
	(
		Language_Code INT,
		Language_Name NVARCHAR(MAX),
	)

	CREATE TABLE #TempFinalData
	(
		Col_Values NVARCHAR(MAX),
		Row_Codes VARCHAR(50)
	)

	INSERT INTO #TempBusinessUnit(BusinessUnit_Code)
	SELECT DISTINCT number AS BusinessUnit_Code FROM DBO.fn_Split_withdelemiter(@BusinessUnitCodes, ',')

	INSERT INTO #TempTerritory(Territory_Code)
	SELECT DISTINCT number AS Territory_Code FROM DBO.fn_Split_withdelemiter(@topTerritoryCodeForDashboard, ',')

	INSERT INTO #TempLanguage(Language_Code)
	SELECT DISTINCT number AS Language_Code FROM DBO.fn_Split_withdelemiter(@topLanguageCodeForDashboard, ',')

	DECLARE @DynamicPivotQuery AS NVARCHAR(MAX), @HeaderCodes_Cols AS NVARCHAR(MAX) = '', @HeaderCodes_Rows AS NVARCHAR(MAX) = '',
	@ColumnName_Pivot AS NVARCHAR(MAX), @ColumnName_Select AS NVARCHAR(MAX), @ColumnName_Graph AS NVARCHAR(MAX)

	IF(@DataFor = 'REGION_WISE_DEAL_EXPIRY')
	BEGIN
		PRINT 'In this show count of syndicated deals which are getting expired in particular month region wise'

		IF(OBJECT_ID('TEMPDB..#TempExpiryData') IS NOT NULL)
			DROP TABLE #TempExpiryData

		IF(OBJECT_ID('TEMPDB..#TempMonth') IS NOT NULL)
			DROP TABLE #TempMonth

		CREATE TABLE #TempExpiryData
		(
			Expiry_Year INT,
			Expiry_Month INT,
			Territory_Code INT, 
			Deal_Count INT,
			Month_Name NVARCHAR(3)
		)

		CREATE TABLE #TempMonth
		(
			Expiry_Month INT,
			Expiry_Year INT,
		)

		DECLARE @newDate DATETIME = DATEADD(mm, 12, GETDATE())
		DECLARE @month_NewDate INT = 0, @year_NewDate INT = 0

		DECLARE @myDateDate DATETIME = GETDATE()
		WHILE(@myDateDate < @newDate)
		BEGIN
			SELECT @month_NewDate = MONTH(@myDateDate) , @year_NewDate = YEAR(@myDateDate)
			INSERT INTO #TempMonth(Expiry_Month, Expiry_Year) VALUES (@month_NewDate, @year_NewDate)
			SET @myDateDate = DATEADD(mm, 1, @myDateDate)
		END
	
		INSERT INTO #TempExpiryData(Expiry_Year, Expiry_Month, Territory_Code, Deal_Count)
		SELECT DISTINCT 
		YEAR(SDR.Actual_Right_End_Date) AS Expiry_Year, MONTH(SDR.Actual_Right_End_Date) AS Expiry_Month,
		ISNULL(TMP.Territory_Code, 0) AS Territory_Code, COUNT(DISTINCT SDR.Syn_Deal_Code) AS Deal_Count 
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON SD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C' AND 
			((@Only_ApprovedDeal_GraphicalDashboard_Syn <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Syn = 'Y' AND SD.Deal_Workflow_Status = 'A'))
		INNER JOIN Syn_Deal_Rights_Territory SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
		INNER JOIN Territory_Details TD WITH(NOLOCK) ON (TD.Territory_Code = SDRT.Territory_Code AND SDRT.Territory_Type = 'G' AND SDRT.Country_Code IS NULL) OR
			(TD.Country_Code = SDRT.Country_Code AND SDRT.Territory_Type <> 'G' AND SDRT.Territory_Code IS NULL)
		LEFT JOIN #TempTerritory AS TMP ON TMP.Territory_Code = TD.Territory_Code
		WHERE SDR.Actual_Right_End_Date IS NOT NULL AND 
			SDR.Actual_Right_End_Date >= GETDATE() AND YEAR(SDR.Actual_Right_End_Date) <= @year_NewDate 
			AND (
				(MONTH(SDR.Actual_Right_End_Date) < @month_NewDate AND YEAR(SDR.Actual_Right_End_Date) = @year_NewDate) OR 
				YEAR(SDR.Actual_Right_End_Date) < @year_NewDate
			)
		GROUP BY YEAR(SDR.Actual_Right_End_Date), MONTH(SDR.Actual_Right_End_Date), ISNULL(TMP.Territory_Code, 0)
		ORDER BY YEAR(SDR.Actual_Right_End_Date), MONTH(SDR.Actual_Right_End_Date), ISNULL(TMP.Territory_Code, 0)

		DELETE FROM #TempTerritory
		INSERT INTO #TempTerritory(Territory_Code, Territory_Name)
		SELECT DISTINCT TED.Territory_Code, T.Territory_Name FROM #TempExpiryData TED
		INNER JOIN Territory T WITH(NOLOCK) ON T.Territory_Code = TED.Territory_Code
		ORDER BY T.Territory_Name

		IF EXISTS (SELECT * FROM #TempExpiryData WHERE Territory_Code  = 0)
		BEGIN
			IF NOT EXISTS (SELECT * FROM #TempTerritory WHERE Territory_Code  = 0)
			BEGIN
				INSERT INTO #TempTerritory(Territory_Code, Territory_Name)
				VALUES(0, 'Others')
			END
		END
		
		INSERT INTO #TempExpiryData(Expiry_Year, Expiry_Month, Territory_Code, Deal_Count)
		SELECT DISTINCT T.Expiry_Year, T.Expiry_Month, T.Territory_Code, 0 AS Deal_Count FROM #TempExpiryData TED
		RIGHT JOIN (
			SELECT TM.Expiry_Year, TM.Expiry_Month, TT.Territory_Code FROM #TempTerritory TT, #TempMonth TM
		) AS T ON T.Expiry_Year = TED.Expiry_Year AND T.Expiry_Month = TED.Expiry_Month AND T.Territory_Code = TED.Territory_Code
		WHERE TED.Expiry_Year IS NULL AND TED.Expiry_Month IS NULL AND TED.Territory_Code IS NULL
	
		UPDATE #TempExpiryData SET Month_Name = CAST(DATENAME(MONTH, CAST(('9999/' +  CAST(Expiry_Month AS NVARCHAR) + '/1') AS DATETIME)) AS NVARCHAR(3))
			
		SELECT @ColumnName_Pivot= ISNULL(@ColumnName_Pivot + ', ','')  + QUOTENAME(Territory_Code) FROM #TempTerritory
		SELECT @ColumnName_Select= ISNULL(@ColumnName_Select + ' + ''~''+ ','')  + 'CAST(ISNULL(' + QUOTENAME(Territory_Code) + ', 0) AS VARCHAR)' FROM #TempTerritory
		SELECT @ColumnName_Graph = ISNULL(@ColumnName_Graph + '~','')  + Territory_Name  FROM #TempTerritory

		INSERT INTO #TempFinalData(Col_Values)
		select '~' + ISNULL(@ColumnName_Graph, '')

		SET @DynamicPivotQuery = 
		  N'SELECT Month_Name + ''~'' +  ' + @ColumnName_Select + ' AS Col_Value, (CAST(Expiry_Month AS VARCHAR) + ''-'' + CAST(Expiry_Year AS VARCHAR)) As Month_Year
			FROM #TempExpiryData 
			PIVOT(SUM(Deal_Count) 
				  FOR Territory_Code IN (' + @ColumnName_Pivot + ')) AS PVT_Table'

		PRINT @DynamicPivotQuery
		INSERT INTO #TempFinalData(Col_Values, Row_Codes)
		EXEC sp_executesql @DynamicPivotQuery

		SELECT @HeaderCodes_Cols= ISNULL(@HeaderCodes_Cols + ',','')  + CAST(Territory_Code AS VARCHAR) FROM #TempTerritory
		SELECT @HeaderCodes_Rows= ISNULL(@HeaderCodes_Rows + ',','')  + CAST(Row_Codes AS VARCHAR) FROM #TempFinalData WHERE Row_Codes IS NOT NULL
	END
	ELSE IF(@DataFor = 'PLATFORM_WISE_SALES_DISTRIBUTION')
	BEGIN
		PRINT 'In this show count of syndicated titles for particular platform region wise'

		IF(OBJECT_ID('TEMPDB..#TempPlatformWiseData') IS NOT NULL)
			DROP TABLE #TempPlatformWiseData

		CREATE TABLE #TempPlatformWiseData
		(
			Platform_Group_Code INT,
			Territory_Code INT, 
			Title_Count INT,
			Platform_Group_Name NVARCHAR(MAX)
		)

		INSERT INTO #TempPlatformWiseData(Platform_Group_Code, Territory_Code, Title_Count)
		SELECT DISTINCT 
		ISNULL(PGD.Platform_Group_Code, 0) AS Platform_Group_Code, ISNULL(TMP.Territory_Code, 0) AS Territory_Code, COUNT(DISTINCT SDRT.Title_Code) AS Title_Count 
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON SD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C'
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Platform SDRP WITH(NOLOCK) ON SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Territory SDRC WITH(NOLOCK) ON SDRC.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
		INNER JOIN Territory_Details TD WITH(NOLOCK) ON (TD.Territory_Code = SDRC.Territory_Code AND SDRC.Territory_Type = 'G' AND SDRC.Country_Code IS NULL) OR
			(TD.Country_Code = SDRC.Country_Code AND SDRC.Territory_Type <> 'G' AND SDRC.Territory_Code IS NULL)
		LEFT JOIN #TempTerritory AS TMP ON TMP.Territory_Code = TD.Territory_Code
		LEFT JOIN (
			SELECT PGD_I.Platform_Code, PGD_I.Platform_Group_Code FROM Platform_Group PG_I WITH(NOLOCK)
			INNER JOIN Platform_Group_Details PGD_I WITH(NOLOCK) ON PGD_I.Platform_Group_Code = PG_I.Platform_Group_Code AND ISNULL(PG_I.Group_For, '') = 'D'
		) AS PGD ON PGD.Platform_Code = SDRP.Platform_Code
		WHERE ((@Only_ApprovedDeal_GraphicalDashboard_Syn <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Syn = 'Y' AND SD.Deal_Workflow_Status = 'A'))

		GROUP BY ISNULL(PGD.Platform_Group_Code, 0), ISNULL(TMP.Territory_Code, 0)
		ORDER BY ISNULL(PGD.Platform_Group_Code, 0), ISNULL(TMP.Territory_Code, 0)

		DELETE FROM #TempTerritory
		INSERT INTO #TempTerritory(Territory_Code, Territory_Name)
		SELECT DISTINCT TPD.Territory_Code, T.Territory_Name FROM #TempPlatformWiseData TPD
		INNER JOIN Territory T WITH(NOLOCK) ON T.Territory_Code = TPD.Territory_Code
		ORDER BY T.Territory_Name

		IF EXISTS (SELECT * FROM #TempPlatformWiseData WHERE Territory_Code  = 0)
		BEGIN
			IF NOT EXISTS (SELECT * FROM #TempTerritory WHERE Territory_Code  = 0)
			BEGIN
				INSERT INTO #TempTerritory(Territory_Code, Territory_Name)
				VALUES(0, 'Others')
			END
		END
	
		
		INSERT INTO #TempPlatformWiseData(Platform_Group_Code, Territory_Code, Title_Count)
		SELECT DISTINCT T.Platform_Group_Code, T.Territory_Code, 0 AS Title_Count FROM #TempPlatformWiseData TPD
		RIGHT JOIN (
			SELECT PG.Platform_Group_Code, TT.Territory_Code FROM #TempTerritory TT, Platform_Group PG
			WHERE ISNULL(PG.Group_For, '') = 'D'
		) AS T ON T.Territory_Code = TPD.Territory_Code AND T.Platform_Group_Code = TPD.Platform_Group_Code
		WHERE TPD.Platform_Group_Code IS NULL AND TPD.Territory_Code IS NULL

		UPDATE TPD SET TPD.Platform_Group_Name = ISNULL(PG.Platform_Group_Name, 'Others') FROM #TempPlatformWiseData TPD
		LEFT JOIN Platform_Group PG WITH(NOLOCK) ON TPD.Platform_Group_Code = PG.Platform_Group_Code
			
		SELECT @ColumnName_Pivot= ISNULL(@ColumnName_Pivot + ', ','')  + QUOTENAME(Territory_Code) FROM #TempTerritory
		SELECT @ColumnName_Select= ISNULL(@ColumnName_Select + ' + ''~''+ ','')  + 'CAST(ISNULL(' + QUOTENAME(Territory_Code) + ', 0) AS VARCHAR)' FROM #TempTerritory
		SELECT @ColumnName_Graph = ISNULL(@ColumnName_Graph + '~','')  + Territory_Name  FROM #TempTerritory

		INSERT INTO #TempFinalData(Col_Values)
		select '~' + ISNULL(@ColumnName_Graph, '')

		SET @DynamicPivotQuery = 
		  N'SELECT Platform_Group_Name + ''~'' +  ' + @ColumnName_Select + ' AS Col_Value, Platform_Group_Code
			FROM #TempPlatformWiseData 
			PIVOT(SUM(Title_Count) 
				  FOR Territory_Code IN (' + @ColumnName_Pivot + ')) AS PVT_Table'

		PRINT @DynamicPivotQuery
		INSERT INTO #TempFinalData(Col_Values, Row_Codes)
		EXEC sp_executesql @DynamicPivotQuery

		SELECT @HeaderCodes_Cols= ISNULL(@HeaderCodes_Cols + ',','')  + CAST(Territory_Code AS VARCHAR) FROM #TempTerritory
		SELECT @HeaderCodes_Rows= ISNULL(@HeaderCodes_Rows + ',','')  + CAST(Row_Codes AS VARCHAR) FROM #TempFinalData WHERE Row_Codes IS NOT NULL
	END
	ELSE IF(@DataFor = 'REGION_WISE_SALES_DISTRIBUTION')
	BEGIN
		PRINT 'In this show count of syndicated titles region wise'
		INSERT INTO #TempGroupCount(Group_Code, Group_Total_Count)
		SELECT ISNULL(TMP.Territory_Code, 0) AS Group_Code, COUNT(DISTINCT SDRT.Title_Code) AS Group_Total_Count
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON SD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C'
		INNER JOIN Syn_Deal_Rights_Territory SDRC WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRC.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
		INNER JOIN Territory_Details TD WITH(NOLOCK) ON (TD.Territory_Code = SDRC.Territory_Code AND SDRC.Territory_Type = 'G' AND SDRC.Country_Code IS NULL) OR
			(TD.Country_Code = SDRC.Country_Code AND SDRC.Territory_Type <> 'G' AND SDRC.Territory_Code IS NULL)
		LEFT JOIN #TempTerritory AS TMP ON TMP.Territory_Code = TD.Territory_Code
		WHERE ((@Only_ApprovedDeal_GraphicalDashboard_Syn <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Syn = 'Y' AND SD.Deal_Workflow_Status = 'A'))
		GROUP BY ISNULL(TMP.Territory_Code, 0)
		ORDER BY ISNULL(TMP.Territory_Code, 0)

		INSERT INTO #TempFinalData(Col_Values)
		SELECT 'Region~Count'

		INSERT INTO #TempFinalData(Col_Values, Row_Codes)
		SELECT T.Territory_Name + '~' + CAST(Group_Total_Count AS VARCHAR), TGC.Group_Code FROM #TempGroupCount TGC
		INNER JOIN Territory T WITH(NOLOCK) ON T.Territory_Code = TGC.Group_Code
		ORDER BY T.Territory_Name

		SELECT @HeaderCodes_Rows= ISNULL(@HeaderCodes_Rows + ',','')  + CAST(Row_Codes AS VARCHAR) FROM #TempFinalData WHERE Row_Codes IS NOT NULL
		IF EXISTS (SELECT * FROM #TempGroupCount WHERE Group_Code = 0)
		BEGIN
			INSERT INTO #TempFinalData(Col_Values)
			SELECT 'Others~' + CAST(Group_Total_Count AS VARCHAR) FROM #TempGroupCount WHERE Group_Code = 0
			SET @HeaderCodes_Rows = @HeaderCodes_Rows + ',0'
		END
	END
	ELSE IF(@DataFor = 'ACQUISITION_VS_SYNDICATION')
	BEGIN
		PRINT 'In this show count of Total Acquired titles vs total syndicated titles'
		DECLARE @totalAcqTitleCount INT = 0, @totalSynTitleCount INT = 0
		DECLARE @percentageForRed INT = 49, @percentageForYellow INT = 21 -- Remaining (30) for Green 
		DECLARE @redFrom INT = 0, @redTo INT = 0, @yellowFrom INT = 0, @yellowTo INT = 0, @greenFrom INT = 0, @greenTo INT = 0

		SELECT @totalAcqTitleCount = COUNT(DISTINCT Title_Code) FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU WITH(NOLOCK) ON AD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ISNULL(Is_Master_Deal, '') = 'Y' AND ISNULL(ADR.Is_Sub_License, 'N') = 'Y' AND
			((@Only_ApprovedDeal_GraphicalDashboard_Acq <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Acq = 'Y' AND AD.Deal_Workflow_Status = 'A'))
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		
		SELECT @totalSynTitleCount = COUNT(DISTINCT Title_Code) FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON SD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND
			((@Only_ApprovedDeal_GraphicalDashboard_Syn <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Syn = 'Y' AND SD.Deal_Workflow_Status = 'A'))
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code

		SET @redTo = (@totalAcqTitleCount * @percentageForRed / 100)
		SET @yellowFrom = @redTo
		SET @yellowTo =  @redTo + (@totalAcqTitleCount * @percentageForYellow / 100)
		SET @greenFrom = @yellowTo
		SET @greenTo = @totalAcqTitleCount

		-- NOTE : Please do not change order of Inserting
		INSERT INTO #TempFinalData(Col_Values) VALUES 
		('ColorName~Total~Consumption')

		IF( @totalAcqTitleCount > 0)
		BEGIN
			INSERT INTO #TempFinalData(Col_Values) VALUES 
			('Data~' + CAST(@totalAcqTitleCount AS VARCHAR) + '~' + CAST(@totalSynTitleCount AS VARCHAR)),
			('Red~' + CAST(@redFrom AS VARCHAR) + '~' + CAST(@redTo AS VARCHAR)),
			('Yellow~' + CAST(@yellowFrom AS VARCHAR) + '~' + CAST(@yellowTo AS VARCHAR)),
			('Green~' + CAST(@greenFrom AS VARCHAR) + '~' + CAST(@greenTo AS VARCHAR))
		END
	END
	ELSE IF(@DataFor = 'LANGUAGE_WISE_SYNDICATION_SUBTITLE')
	BEGIN
		PRINT 'In this show count of syndicated titles language wise subtitling'

		INSERT INTO #TempGroupCount(Group_Code, Group_Total_Count)
		SELECT ISNULL(TMP.Language_Code, 0) AS Group_Code, COUNT(DISTINCT SDRT.Title_Code) AS Group_Total_Count
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON SD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND
			((@Only_ApprovedDeal_GraphicalDashboard_Syn <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Syn = 'Y' AND SD.Deal_Workflow_Status = 'A'))
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
		INNER JOIN  Syn_Deal_Rights_Subtitling SDRS WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code
		INNER JOIN Language_Group_Details LGD WITH(NOLOCK) ON (LGD.Language_Group_Code = SDRS.Language_Group_Code AND SDRS.Language_Type = 'G' AND SDRS.Language_Code IS NULL) OR
			(LGD.Language_Code = SDRS.Language_Code AND SDRS.Language_Type <> 'G' AND SDRS.Language_Group_Code IS NULL)
		LEFT JOIN #TempLanguage AS TMP ON TMP.Language_Code = LGD.Language_Code
		GROUP BY ISNULL(TMP.Language_Code, 0)
		ORDER BY ISNULL(TMP.Language_Code, 0)
		

		INSERT INTO #TempFinalData(Col_Values)
		SELECT 'Language~Count'

		INSERT INTO #TempFinalData(Col_Values, Row_Codes)
		SELECT L.Language_Name + '~' + CAST(Group_Total_Count AS VARCHAR), TGC.Group_Code FROM #TempGroupCount TGC
		INNER JOIN [Language] L WITH(NOLOCK) ON L.Language_Code = TGC.Group_Code
		ORDER BY L.Language_Name

		SELECT @HeaderCodes_Rows= ISNULL(@HeaderCodes_Rows + ',','')  + CAST(Row_Codes AS VARCHAR) FROM #TempFinalData WHERE Row_Codes IS NOT NULL
		IF EXISTS (SELECT * FROM #TempGroupCount WHERE Group_Code = 0)
		BEGIN
			INSERT INTO #TempFinalData(Col_Values)
			SELECT 'Others~' + CAST(Group_Total_Count AS VARCHAR) FROM #TempGroupCount WHERE Group_Code = 0
			SET @HeaderCodes_Rows = @HeaderCodes_Rows + ',0'
		END
	END
	ELSE IF(@DataFor = 'LANGUAGE_WISE_SYNDICATION_DUBBING')
	BEGIN
		PRINT 'In this show count of syndicated titles language wise dubbing'
		INSERT INTO #TempGroupCount(Group_Code, Group_Total_Count)
		SELECT ISNULL(TMP.Language_Code, 0) AS Group_Code, COUNT(DISTINCT SDRT.Title_Code) AS Group_Total_Count
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON SD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C' AND 
			((@Only_ApprovedDeal_GraphicalDashboard_Syn <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Syn = 'Y' AND SD.Deal_Workflow_Status = 'A'))
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
		INNER JOIN  Syn_Deal_Rights_Dubbing SDRD WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRD.Syn_Deal_Rights_Code
		INNER JOIN Language_Group_Details LGD WITH(NOLOCK) ON (LGD.Language_Group_Code = SDRD.Language_Group_Code AND SDRD.Language_Type = 'G' AND SDRD.Language_Code IS NULL) OR
			(LGD.Language_Code = SDRD.Language_Code AND SDRD.Language_Type <> 'G' AND SDRD.Language_Group_Code IS NULL)
		LEFT JOIN #TempLanguage AS TMP ON TMP.Language_Code = LGD.Language_Code
		GROUP BY ISNULL(TMP.Language_Code, 0)
		ORDER BY ISNULL(TMP.Language_Code, 0)

		INSERT INTO #TempFinalData(Col_Values)
		SELECT 'Language~Count'

		INSERT INTO #TempFinalData(Col_Values, Row_Codes)
		SELECT L.Language_Name + '~' + CAST(Group_Total_Count AS VARCHAR), TGC.Group_Code  FROM #TempGroupCount TGC
		INNER JOIN [Language] L WITH(NOLOCK) ON L.Language_Code = TGC.Group_Code
		ORDER BY L.Language_Name

		SELECT @HeaderCodes_Rows= ISNULL(@HeaderCodes_Rows + ',','')  + CAST(Row_Codes AS VARCHAR) FROM #TempFinalData WHERE Row_Codes IS NOT NULL
		IF EXISTS (SELECT * FROM #TempGroupCount WHERE Group_Code = 0)
		BEGIN
			INSERT INTO #TempFinalData(Col_Values)
			SELECT 'Others~' + CAST(Group_Total_Count AS VARCHAR) FROM #TempGroupCount WHERE Group_Code = 0
			SET @HeaderCodes_Rows = @HeaderCodes_Rows + ',0'
		END
	END
	ELSE IF(@DataFor = 'TITLE_REGION')
	BEGIN
		PRINT 'In this show count of total titles and syndicated titles region wise'

		INSERT INTO #TempGroupCount(Group_Code, Group_Total_Count, Group_Sold_Count)
		SELECT Territory_Code, COUNT(DISTINCT Acq_Title_Code) AS Group_Total_Count, COUNT(DISTINCT Syn_Title_Code) AS Group_Sold_Count FROM (
		SELECT DISTINCT ISNULL(TMP.Territory_Code, 0) AS Territory_Code, ADRT.Title_Code AS Acq_Title_Code, NULL AS Syn_Title_Code
		FROM Acq_Deal AD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON AD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ISNULL(Is_Master_Deal, '') = 'Y' AND ISNULL(ADR.Is_Sub_License, 'N') = 'Y' AND 
			((@Only_ApprovedDeal_GraphicalDashboard_Acq <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Acq = 'Y' AND AD.Deal_Workflow_Status = 'A'))
		INNER JOIN Acq_Deal_Rights_Territory ADRC WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRC.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		INNER JOIN Territory_Details TD WITH(NOLOCK) ON (TD.Territory_Code = ADRC.Territory_Code AND ADRC.Territory_Type = 'G' AND ADRC.Country_Code IS NULL) OR
			(TD.Country_Code = ADRC.Country_Code AND ADRC.Territory_Type <> 'G' AND ADRC.Territory_Code IS NULL)
		LEFT JOIN #TempTerritory AS TMP ON TMP.Territory_Code = TD.Territory_Code
		UNION 
		SELECT DISTINCT ISNULL(TMP.Territory_Code, 0) AS Territory_Code, NULL AS Acq_Title_Code, SDRT.Title_Code AS Syn_Title_Code
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN #TempBusinessUnit TBU ON SD.Business_Unit_Code = TBU.BusinessUnit_Code
		INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C' AND
			((@Only_ApprovedDeal_GraphicalDashboard_Syn <> 'Y') OR (@Only_ApprovedDeal_GraphicalDashboard_Syn = 'Y' AND SD.Deal_Workflow_Status = 'A'))
		INNER JOIN Syn_Deal_Rights_Territory SDRC WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRC.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
		INNER JOIN Territory_Details TD WITH(NOLOCK) ON (TD.Territory_Code = SDRC.Territory_Code AND SDRC.Territory_Type = 'G' AND SDRC.Country_Code IS NULL) OR
			(TD.Country_Code = SDRC.Country_Code AND SDRC.Territory_Type <> 'G' AND SDRC.Territory_Code IS NULL)
		LEFT JOIN #TempTerritory AS TMP ON TMP.Territory_Code = TD.Territory_Code
		) AS A
		GROUP BY Territory_Code
		ORDER BY Territory_Code

		INSERT INTO #TempFinalData(Col_Values)
		SELECT 'Region~Total~{ANN_NUM}~Sold~{ANN_NUM}'

		INSERT INTO #TempFinalData(Col_Values, Row_Codes)
		SELECT T.Territory_Name + '~' + CAST(Group_Total_Count AS VARCHAR) + '~' + CAST(Group_Total_Count AS VARCHAR) + 
			'~' + CAST(Group_Sold_Count AS VARCHAR) + '~' + CAST(Group_Sold_Count AS VARCHAR), TGC.Group_Code FROM #TempGroupCount TGC
		INNER JOIN Territory T WITH(NOLOCK) ON T.Territory_Code = TGC.Group_Code
		ORDER BY T.Territory_Name

		SELECT @HeaderCodes_Cols = ',T,S'
		SELECT @HeaderCodes_Rows= ISNULL(@HeaderCodes_Rows + ',','')  + CAST(Row_Codes AS VARCHAR) FROM #TempFinalData WHERE Row_Codes IS NOT NULL
		IF EXISTS (SELECT * FROM #TempGroupCount WHERE Group_Code = 0)
		BEGIN
			INSERT INTO #TempFinalData(Col_Values)
			SELECT 'Others~' +  CAST(Group_Total_Count AS VARCHAR) + '~' + CAST(Group_Total_Count AS VARCHAR) + 
			 '~' + CAST(Group_Sold_Count AS VARCHAR) + '~' + CAST(Group_Sold_Count AS VARCHAR) FROM #TempGroupCount WHERE Group_Code = 0
			 SET @HeaderCodes_Rows = @HeaderCodes_Rows + ',0'
		END

	END

	IF((SELECT count(*) FROM #TempFinalData) <= 1)
	BEGIN
		DELETE FROM #TempFinalData
	END
	ELSE
	BEGIN
		IF(LEN(@HeaderCodes_Cols) > 1)
			SET @HeaderCodes_Cols = RIGHT(@HeaderCodes_Cols, LEN(@HeaderCodes_Cols) - 1)
		IF(LEN(@HeaderCodes_Rows) > 1)
			SET @HeaderCodes_Rows = RIGHT(@HeaderCodes_Rows, LEN(@HeaderCodes_Rows) - 1)

		INSERT INTO #TempFinalData(Col_Values)
		SELECT @HeaderCodes_Rows + '^' + @HeaderCodes_Cols
	END

	SELECT Col_Values FROM #TempFinalData
	
	IF OBJECT_ID('tempdb..#TempBusinessUnit') IS NOT NULL DROP TABLE #TempBusinessUnit
	IF OBJECT_ID('tempdb..#TempExpiryData') IS NOT NULL DROP TABLE #TempExpiryData
	IF OBJECT_ID('tempdb..#TempFinalData') IS NOT NULL DROP TABLE #TempFinalData
	IF OBJECT_ID('tempdb..#TempGroupCount') IS NOT NULL DROP TABLE #TempGroupCount
	IF OBJECT_ID('tempdb..#TempLanguage') IS NOT NULL DROP TABLE #TempLanguage
	IF OBJECT_ID('tempdb..#TempMonth') IS NOT NULL DROP TABLE #TempMonth
	IF OBJECT_ID('tempdb..#TempPlatformWiseData') IS NOT NULL DROP TABLE #TempPlatformWiseData
	IF OBJECT_ID('tempdb..#TempTerritory') IS NOT NULL DROP TABLE #TempTerritory
END


