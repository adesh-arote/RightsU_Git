CREATE PROCEDURE [dbo].[USPGetDrilDownExpiring]
@BUCode INT, 
@UsersCode INT, 
@DBNum NVARCHAR(MAX),
@DashboardType VARCHAR(20),
@Language NVARCHAR(50),
@ExpiringIn NVARCHAR(MAX)
AS
--DECLARE
--@BUCode INT = 0, @UsersCode INT = 168, @DBNum NVARCHAR(MAX) = 'DB5',@DashboardType VARCHAR(20) = 'Movies',@Language NVARCHAR(50) = 'Marathi', @ExpiringIn NVARCHAR(MAX) = 'APR-22'
BEGIN
	IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard
	IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
	IF OBJECT_ID('tempdb..#tpmTitleLinearDealType') IS NOT NULL DROP TABLE #tpmTitleLinearDealType
	IF OBJECT_ID('tempdb..#tmpLanguageTitleCode') IS NOT NULL DROP TABLE #tmpLanguageTitleCode
	IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard
	IF OBJECT_ID('tempdb..#TempBU') IS NOT NULL DROP TABLE #TempBU
	IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
	IF OBJECT_ID('tempdb..#tempLanguageWithOthers') IS NOT NULL Drop Table #tempLanguageWithOthers
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL Drop Table #temp


	DECLARE
	@LanguageNames NVARCHAR(MAX)

	SET @LanguageNames = (Select Parameter_Value from SystemParameterNew where Parameter_Name = 'DBLanguageNames_IT')
	DECLARE @LinearCode NVARCHAR(MAX)
	DECLARE @NonLinearCode NVARCHAR(MAX)

	SET @LinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] where Attrib_Group_Name = 'Linear')
	SET @NonLinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] where Attrib_Group_Name = 'Non-Linear')

	CREATE TABLE #TempDashboard
	(
		DBNum VARCHAR(10),
		Field1 NVARCHAR(100),
		Field2 NVARCHAR(100),
		Field3 NVARCHAR(100),
	)

	
	CREATE TABLE #TempBU
	(
		BUCode INT
	)

	CREATE TABLE #tempLanguage(
	Language_Codes INT
	)

	CREATE TABLE #tempLanguageWithOthers(
	Language_Codes INT,
	Language_Name Varchar(500)
	)

	CREATE TABLE #LinearRightCode(
		RightsCode INT
	)

	INSERT INTO #LinearRightCode(RightsCode)
	SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
	FROM Acq_Deal_Rights_Platform ADRP
	INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
	WHERE pag.Attrib_Group_Code IN (@LinearCode,@NonLinearCode)


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

	INSERT INTO #TempBU(BUCode)
	SELECT DISTINCT agbu.Business_Unit_Code FROM AttribGroupBU agbu  With (NOLOCK)
	INNER JOIN UsersBU ubu  With (NOLOCK) ON agbu.Business_Unit_Code = ubu.Business_Unit_Code
	WHERE agbu.Attrib_Group_Code IN (Select Distinct BU_Code from UsersBusinessUnit  With (NOLOCK) where Users_Code = @UsersCode) --@BUCode 
	AND ubu.Users_Code = @USersCode


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

	DECLARE @ActiveAssets INT = 0, @TotalAssets FLOAT = 0, @TotalAcqDeal INT = 0, @TotalSynDeal INT,@ActiveAssetsSyn INT

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
		Is_Sub_License VARCHAR(10)
	)

	CREATE TABLE #tmpLanguageTitleCode
	(
		Title_Code INT
	)

	INSERT INTO #tpmTitleLinearDealType
	SELECT DISTINCT tr.Title_Code, tr.Actual_Right_Start_Date, tr.Actual_Right_End_Date, tr.Is_Sub_License
	FROM TitleLinearDealType tr
	INNER JOIN @tblDealType dt ON dt.Deal_Type_Code = tr.Deal_Type_Code
	INNER JOIN #LinearRightCode lrc ON lrc.RightsCode = tr.Acq_Deal_Rights_Code

	INSERT INTO #tmpLanguageTitleCode
	SELECT DISTINCT t.Title_Code FROM Title t
	WHERE t.Title_Language_Code IN (SELECT Language_Codes FROM #tempLanguage)



	DECLARE @FNYearED DATE, @FNYearSD DATE, @Year INT, @YearEndDate DATE, @YearStartDate DATE = '01-' + DATENAME(MONTH, GETDATE()) + '-' +  DATENAME(YEAR,GETDATE())
			SET @YearEndDate = DATEADD(DAY, -1, DATEADD(YEAR, 1, @YearStartDate))
			SET @Year = DATEPART(YY, GETDATE())

			IF(DATEPART(MM, GETDATE()) > 3)
			BEGIN

			SET @Year = @Year + 1

			END

			SET @FNYearSD = '01-APR-' + CAST(@Year AS VARCHAR(5))
			SET @FNYearED = DATEADD(DAY, -1, DATEADD(YEAR, 1, @FNYearSD))
		
		DECLARE @ExpiringMonth INT, @ExpiringYear INT

		SET @ExpiringMonth =  (SELECT CASE WHEN LEFT(@ExpiringIn,3) = 'JAN' THEN 1
			WHEN LEFT(@ExpiringIn,3) = 'FEB' THEN 2
			WHEN LEFT(@ExpiringIn,3) = 'MAR' THEN 3
			WHEN LEFT(@ExpiringIn,3) = 'APR' THEN 4
			WHEN LEFT(@ExpiringIn,3) = 'MAY' THEN 5
			WHEN LEFT(@ExpiringIn,3) = 'JUN' THEN 6
			WHEN LEFT(@ExpiringIn,3) = 'JUL' THEN 7
			WHEN LEFT(@ExpiringIn,3) = 'AUG' THEN 8
			WHEN LEFT(@ExpiringIn,3) = 'SEP' THEN 9
			WHEN LEFT(@ExpiringIn,3) = 'OCT' THEN 10
			WHEN LEFT(@ExpiringIn,3) = 'NOV' THEN 11
			WHEN LEFT(@ExpiringIn,3) = 'DEC' THEN 12
			
		END)

		SET @ExpiringYear = (SELECT '20'+RIGHT(@ExpiringIn,2))

		IF(@DBNum = 'DB5')
		BEGIN
			--SELECT 'A-2012-0001' AS Agreement_No, 'Title1, Title2, Title3'AS Title_Name, 'Yash Raj Films' AS Licensor, '15 Days' AS Expiring, '01-Jan-2012' AS LP_EndDate
			--UNION
			--SELECT 'A-2012-0002' AS Agreement_No, 'Title1'AS Title_Name, 'Yash Raj Films' AS Licensor, '15 Days' AS Expiring, '01-Jan-2013' AS LP_EndDate
			--UNION
			--SELECT 'A-2012-0003' AS Agreement_No, 'Title2'AS Title_Name, 'Yash Raj Films' AS Licensor, '15 Days' AS Expiring, '01-Jan-2014' AS LP_EndDate


			SELECT
				--Row_number()
			 --         OVER( 
			 --           partition BY A.Agreement_No
			 --           ORDER BY A.Agreement_No Desc) AS RowNumber, 
				--		DENSE_RANK() OVER (order by Agreement_No) AS DenseRank, 
			Agreement_No, Title_Code, Vendor_Name AS Licensor, Expiring, Actual_Right_End_Date AS LP_EndDate
			INTO #temp
			FROM (
				Select Distinct ad.Agreement_No,T.Title_Code, v.Vendor_Name, (CASE WHEN (Actual_Right_End_Date < GETDATE() AND Actual_Right_End_Date IS NOT NULL) THEN 'EXPIRED' 
							--WHEN (DATEDIFF(day, GETDATE() ,Actual_Right_End_Date) < 30 ) THEN ' ~ (Expiring in ' + CAST(( DATEDIFF(day,GETDATE(), CAST(Actual_Right_End_Date AS int))) AS NVARCHAR(MAX)) + ' days)'
							ELSE CAST(DATEDIFF(day, GETDATE() ,Actual_Right_End_Date) AS NVARCHAR)
							END
					) AS Expiring,  Actual_Right_End_Date, MONTH(Actual_Right_End_Date) AS Month, YEAR(Actual_Right_End_Date) AS Year 
				--INTO #temp
				FROM TitleLinearDealType tr  With (NOLOCK)
				INNER JOIN Title T  With (NOLOCK) on T.Title_Code = tr.Title_Code
				INNER JOIN Language L  With (NOLOCK)  ON L.Language_Code = T.Title_Language_Code
				INNER JOIN #tempLanguage tl ON tl.Language_Codes = T.Title_Language_Code
				INNER JOIN #tempLanguageWithOthers t2  ON t2.Language_Codes = T.Title_Language_Code
				INNER JOIN BusinessUnit bu  With (NOLOCK) ON tr.Business_Unit_Code = bu.Business_Unit_Code --AND bu.Business_Unit_Name IN ('Hindi Movies', 'English Movies', 'Regional', 'Hindi Content', 'Digital', 'Sports')
				INNER JOIN #LinearRightCode lrc on lrc.RightsCode = tr.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = tr.ACq_Deal_Code
				INNER JOIN Vendor v on v.Vendor_Code = ad.Vendor_Code
				WHERE ISNULL(Actual_Right_End_Date, '31DEC9999') BETWEEN @YearStartDate AND @YearEndDate 
				AND tr.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')) 
				GROUP BY Actual_Right_End_Date, ad.Agreement_No,T.Title_Code, v.Vendor_Name
				) AS A
				WHERE A.Month = @ExpiringMonth AND A.Year = @ExpiringYear
				ORDER BY 2,A.Expiring

				--Select DISTINCT t.Agreement_No ,STUFF((SELECT Distinct ', '+ Title.Title_Name
				--			FROM #temp tl
				--			INNER JOIN Title ON Title.Title_Code = tl.Title_Code
				--			WHERE tl.Expiring = t.Expiring AND tl.Agreement_No = t.Agreement_No
				--	FOR XML PATH(''), TYPE)
				--	.value('.','NVARCHAR(MAX)'),1,2,' '
				--) AS Title_Name, t.Licensor, t.Expiring, Format(t.LP_EndDate,'dd-MMM-yyyy') AS LP_EndDate
				--from #temp t
				--order by 1

				Select DISTINCT t.Agreement_No, tit.Title_Name, t.Licensor, t.Expiring, Format(t.LP_EndDate,'dd-MMM-yyyy') AS LP_EndDate
				from #temp t
				INNER JOIN Title tit ON tit.Title_Code = t.Title_Code
				order by 1
			
		END

	
	IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard
	IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
	IF OBJECT_ID('tempdb..#tpmTitleLinearDealType') IS NOT NULL DROP TABLE #tpmTitleLinearDealType
	IF OBJECT_ID('tempdb..#tmpLanguageTitleCode') IS NOT NULL DROP TABLE #tmpLanguageTitleCode
	IF OBJECT_ID('tempdb..#TempDashboard') IS NOT NULL DROP TABLE #TempDashboard
	IF OBJECT_ID('tempdb..#TempBU') IS NOT NULL DROP TABLE #TempBU
	IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
	IF OBJECT_ID('tempdb..#tempLanguageWithOthers') IS NOT NULL Drop Table #tempLanguageWithOthers
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL Drop Table #temp

END
