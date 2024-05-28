
CREATE PROCEDURE [dbo].[USPGetDrillDownData]
@BUCode INT, 
@UsersCode INT,
@Widget NVARCHAR(MAX),
@DashboardType VARCHAR(20),
@Language NVARCHAR(50)
AS

BEGIN

--DECLARE
--@BUCode INT = 0, @UsersCode INT = 143, @DBNum NVARCHAR(MAX) = 'DB1,DB2,DB3,DB4',@DashboardType VARCHAR(20) = 'Movies',@Language NVARCHAR(50) = 'ALL',@Widget NVARCHAR(50)= 'L'

IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard
IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
IF OBJECT_ID('tempdb..#tpmTitleLinearDealType') IS NOT NULL DROP TABLE #tpmTitleLinearDealType
IF OBJECT_ID('tempdb..#tmpLanguageTitleCode') IS NOT NULL DROP TABLE #tmpLanguageTitleCode
--IF OBJECT_ID('tempdb..#TempBU') IS NOT NULL DROP TABLE #TempBU
IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
IF OBJECT_ID('tempdb..#tempLanguageWithOthers') IS NOT NULL DROP TABLE #tempLanguageWithOthers



	CREATE TABLE #LinearRightCode(
		RightsCode INT
	)
	
	--CREATE TABLE #TempBU
	--(
	--	BUCode INT
	--)

	CREATE TABLE #tempLanguage(
	Language_Codes INT
	)

	CREATE TABLE #tempLanguageWithOthers(
	Language_Codes INT,
	Language_Name Varchar(500)
	)

	DECLARE
	@LanguageNames NVARCHAR(MAX)

	SET @LanguageNames = (Select Parameter_Value from SystemParameterNew where Parameter_Name = 'DBLanguageNames_IT')

	DECLARE @LinearCode NVARCHAR(MAX)
	DECLARE @NonLinearCode NVARCHAR(MAX)

	SET @LinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] where Attrib_Group_Name = 'Linear')
	SET @NonLinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] where Attrib_Group_Name = 'Non-Linear')

	IF(@Widget = 'L')
		BEGIN
			INSERT INTO #LinearRightCode(RightsCode)
			SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights_Platform ADRP
			INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
			WHERE pag.Attrib_Group_Code = @LinearCode

		END
	ELSE IF (@Widget = 'NL')
		BEGIN
			INSERT INTO #LinearRightCode(RightsCode)
			SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights_Platform ADRP
			INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
			WHERE pag.Attrib_Group_Code = @NonLinearCode
		END
	ELSE
		BEGIN
			INSERT INTO #LinearRightCode(RightsCode)
			SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights_Platform ADRP
			INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
			WHERE pag.Attrib_Group_Code IN (@LinearCode,@NonLinearCode)
		END

	


	IF(@Language = 'ALL')
		BEGIN
			INSERT INTO #tempLanguage
			SELECT Language_Code FROM [Language] With (NOLOCK)

			INSERT INTO #tempLanguageWithOthers
			SELECT Language_Code,Language_Name FROM [Language] With (NOLOCK) WHERE Language_Name COLLATE DATABASE_DEFAULT 
							     IN (SELECT number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
            UNION ALL
			SELECT Language_Code,'Others' FROM [Language] With (NOLOCK) WHERE Language_Name COLLATE DATABASE_DEFAULT 
							NOT IN (SELECT number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))

		END
	ELSE IF(@Language = 'Others')
		BEGIN
			INSERT INTO #tempLanguage
			SELECT Language_Code  FROM [Language] With (NOLOCK) WHERE Language_Name COLLATE DATABASE_DEFAULT 
							NOT IN (SELECT number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))

			Insert Into #tempLanguageWithOthers
			Select Language_Codes,'Others' From #tempLanguage
		END
	ELSE
		BEGIN
			INSERT INTO #tempLanguage
			SELECT Language_Code FROM Language where Language_Name = ''+@Language+''

			Insert Into #tempLanguageWithOthers
			SELECT Language_Code,Language_Name FROM [Language] With (NOLOCK) WHERE Language_Name = ''+@Language+''

		END

	--INSERT INTO #TempBU(BUCode)
	--SELECT DISTINCT agbu.Business_Unit_Code FROM AttribGroupBU agbu  With (NOLOCK)
	--INNER JOIN UsersBU ubu  With (NOLOCK) ON agbu.Business_Unit_Code = ubu.Business_Unit_Code
	--WHERE agbu.Attrib_Group_Code IN (Select Distinct BU_Code from UsersBusinessUnit  With (NOLOCK) where Users_Code = @UsersCode) --@BUCode 
	--AND ubu.Users_Code = @USersCode

	DECLARE @Deal_Type_Code NVARCHAR(100)

	IF(@DashboardType = 'Movies')
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from SystemParameterNew  With (NOLOCK) where Parameter_Name = 'DashboardType_Movie_IT' )
		END
	ELSE IF(@DashboardType = 'Program')
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from SystemParameterNew  With (NOLOCK) where Parameter_Name = 'DashboardType_Prog_IT' )
		END
	ELSE
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from SystemParameterNew  With (NOLOCK) where Parameter_Name = 'DashboardType_Web_IT' )
		END

	DECLARE @tblDealType AS TABLE
	(
		Deal_Type_Code INT
	)

	INSERT INTO @tblDealType
	select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')

	CREATE TABLE #tpmTitleLinearDealType
	(
		Title_Code INT,
		Actual_Right_Start_Date DATETIME,
		Actual_Right_End_Date DATETIME,
		Is_Sub_License VARCHAR(10),
		Deal_Type_Code INT
	)

	CREATE TABLE #tmpLanguageTitleCode
	(
		Title_Code INT
	)
	
	INSERT INTO #tpmTitleLinearDealType
	SELECT DISTINCT tr.Title_Code, tr.Actual_Right_Start_Date, tr.Actual_Right_End_Date, tr.Is_Sub_License, dt.Deal_Type_Code
	FROM TitleLinearDealType tr
	INNER JOIN @tblDealType dt ON dt.Deal_Type_Code = tr.Deal_Type_Code
	INNER JOIN #LinearRightCode lrc ON lrc.RightsCode = tr.Acq_Deal_Rights_Code

	INSERT INTO #tmpLanguageTitleCode
	SELECT DISTINCT t.Title_Code FROM Title t
	WHERE t.Title_Language_Code IN (SELECT Language_Codes FROM #tempLanguage)

	IF(@Widget = 'Acq')
	BEGIN
		SELECT  ISNULL(CAST(t.Year_Of_Production AS NVARCHAR(MAX)),'NA') AS YOR, dt.Deal_Type_Name AS TitleType, COUNT(DISTINCT CAST(ttldt.TItle_Code AS VARCHAR(10))) As NoOfTitles
		FROM #tpmTitleLinearDealType ttldt  With (NOLOCK)
		INNER JOIN DealType dt ON dt.Deal_Type_Code = ttldt.Deal_Type_Code
		INNER JOIN Title t on t.Title_Code = ttldt.Title_Code
		WHERE
		GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') AND ttldt.Title_Code IN (SELECT Title_Code FROM #tmpLanguageTitleCode)
		GROUP BY dt.Deal_Type_Name,t.Year_Of_Production
		order by Year_Of_Production desc

	--	Select ISNULL(t.Year_Of_Production,0) AS YOR,  dt.Deal_Type_Name AS TitleType, COUNT(ttldt.Title_Code) As NoOfTitles
	--	FROM #tpmTitleLinearDealType ttldt  With (NOLOCK)
	--	INNER JOIN DealType dt ON dt.Deal_Type_Code = ttldt.Deal_Type_Code
	--	INNER JOIN Title t on t.Title_Code = ttldt.Title_Code
	--	WHERE
	--	GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999') AND ttldt.Title_Code IN (SELECT Title_Code FROM #tmpLanguageTitleCode)
	--	GROUP BY ttldt.Deal_Type_Code, dt.Deal_Type_Name, t.Year_Of_Production
	--	order by 1 desc
	END

	IF(@Widget = 'Syn')
	BEGIN
		SELECT ISNULL(CAST(t.Year_Of_Production AS NVARCHAR(MAX)),0) AS YOR, dt.Deal_Type_Name AS TitleType,COUNT(DISTINCT tr.TItle_Code) AS NoOfTitles
		FROM TitleSynRights tr  With (NOLOCK)
		INNER JOIN DealType dt ON dt.Deal_Type_Code = tr.Deal_Type_Code
		INNER JOIN Title t on t.Title_Code = tr.Title_Code
		WHERE GETDATE() BETWEEN Actual_Right_Start_Date AND ISNULL(Actual_Right_End_Date, '31DEC9999')
		AND tr.Deal_Type_Code IN (select Deal_Type_Code from @tblDealType) AND tr.Title_Code IN (SELECT Title_Code FROM #tmpLanguageTitleCode)
		GROUP BY dt.Deal_Type_Name, t.Year_Of_Production
		order by Year_Of_Production desc

	END
	
	IF(@Widget = 'L' OR @Widget = 'NL')
	BEGIN
		
			SELECT ISNULL(CAST(t.Year_Of_Production AS NVARCHAR(MAX)),'NA') AS YOR, dt.Deal_Type_Name AS TitleType,COUNT(Distinct adm.Title_Code) AS NoOfTitles
			FROM Acq_Deal AD
			INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN @tblDealType dtc ON dtc.Deal_Type_Code = AD.Deal_Type_Code
			INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Title ADM ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN Title t ON t.Title_Code  = ADM.Title_Code
			INNER JOIN Role R ON R.Role_Code = AD.Role_Code 
			INNER JOIN DealType dt ON dt.Deal_Type_Code = dtc.Deal_Type_Code
			where 
			GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
			AND ISNULL(adr.Right_Type, '') <> '' AND t.Title_Code IN  (SELECT Title_Code FROM #tmpLanguageTitleCode)
			--AND Role_Name = 'Acquisition'
			GROUP BY  dt.Deal_Type_Name, t.Year_Of_Production
			order by Year_Of_Production desc
	END
	

END
