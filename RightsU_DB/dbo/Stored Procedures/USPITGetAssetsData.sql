CREATE PROCEDURE [dbo].[USPITGetAssetsData]
@DashboardType VARCHAR(50),
@Language NVARCHAR(50)
AS
BEGIN
		IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
		IF OBJECT_ID('tempdb..#Active') IS NOT NULL DROP TABLE #Active
		IF OBJECT_ID('tempdb..#tempCountLinear') IS NOT NULL DROP TABLE #tempCountLinear
		IF OBJECT_ID('tempdb..#tempNonLinear') IS NOT NULL DROP TABLE #tempNonLinear
		IF OBJECT_ID('tempdb..#tempLanguageAD') IS NOT NULL DROP TABLE #tempLanguageAD

	CREATE TAble #tempCountLinear
	(
		TitleLanguage NVARCHAR(100),
		License int,
		OwnProduction int,
		Total INT
	)

	CREATE TAble #tempNonLinear
	(
		TitleLanguage NVARCHAR(100),
		License int,
		OwnProduction int,
		Total INT
	)


	DECLARE
	@Deal_Type_Code NVARCHAR(MAX),
	@LanguageNames NVARCHAR(MAX),
	@ALLCount INT,
	@ActiveCount INT
	
	CREATE TABLE #tempLanguageAD(
	Language_Codes INT
	)

	SET @LanguageNames = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DBLanguageNames_IT')

	IF(@Language = 'ALL')
		BEGIN
			INSERT INTO #tempLanguageAD
			SELECT Language_Code FROM Language WITH(NOLOCK)
		END
	ELSE IF(@Language = 'Others')
		BEGIN
			INSERT INTO #tempLanguageAD
			SELECT Language_Code  FROM Language WITH(NOLOCK) where Language_Name COLLATE DATABASE_DEFAULT NOT IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
		END
	ELSE
		BEGIN
			INSERT INTO #tempLanguageAD
			SELECT Language_Code FROM Language WITH(NOLOCK) where Language_Name = ''+@Language+''
		END



	INSERT INTO #tempCountLinear
	EXEC USPGetDashBoardNeoData @DashboardType,'L',@Language

	INSERT INTO #tempNonLinear
	EXEC USPGetDashBoardNeoData @DashboardType,'NL',@Language


	SET @LanguageNames = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DBLanguageNames_IT')

	IF(@DashboardType = 'M')
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Movie_IT' )
		END
	ELSE IF(@DashboardType = 'p')
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Prog_IT' )
		END
	ELSE
		BEGIN
			SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Web_IT' )
		END

		SET @ALLCount = (
							Select Count(Distinct adm.Title_Code)
							FROM Acq_Deal AD WITH(NOLOCK)
							INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')))
							INNER JOIN Acq_Deal_Rights_Title ADM WITH(NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
							INNER JOIN Title t WITH(NOLOCK)  ON t.Title_Code = ADM.Title_Code
							INNER JOIN #tempLanguageAD l WITH(NOLOCK) ON t.Title_Language_Code = l.Language_Codes
							WHERE ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
							--WHERE GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ADR.Actual_Right_End_Date
						)
		
		SET @ActiveCount = (
								Select Count(Distinct adm.Title_Code) AS Active
								FROM Acq_Deal AD WITH(NOLOCK)
								INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')))
								INNER JOIN Acq_Deal_Rights_Title ADM WITH(NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
								INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADM.Title_Code
								INNER JOIN #tempLanguageAD l WITH(NOLOCK) ON t.Title_Language_Code = l.Language_Codes
								WHERE GETDATE() BETWEEN Actual_Right_Start_Date AND Actual_Right_End_Date
								AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
							)
		

		
		SELECT	ISNULL((Select @ActiveCount),0) AS Active,
				ISNULL((Select SUM(Total) AS Linear from #tempCountLinear),0) Linear,
				ISNULL((Select SUM(Total) AS NonLinear from #tempNonLinear),0) NonLinear,
				ISNULL((Select @ALLCount),0) AS Total

		IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
		IF OBJECT_ID('tempdb..#Active') IS NOT NULL DROP TABLE #Active
		IF OBJECT_ID('tempdb..#tempCountLinear') IS NOT NULL DROP TABLE #tempCountLinear
		IF OBJECT_ID('tempdb..#tempNonLinear') IS NOT NULL DROP TABLE #tempNonLinear
	    IF OBJECT_ID('tempdb..#tempLanguageAD') IS NOT NULL DROP TABLE #tempLanguageAD
END
