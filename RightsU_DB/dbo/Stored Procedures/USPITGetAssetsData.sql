CREATE PROCEDURE [dbo].[USPITGetAssetsData]
@DashboardType VARCHAR(50),
@Language NVARCHAR(50)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USPITGetAssetsData]', 'Step 1', 0, 'Started Procedure', 0, ''
	--DECLARE
	--@DashboardType VARCHAR(50) = 'M',
	--@Language NVARCHAR(50) = 'ALL'

			IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
			IF OBJECT_ID('tempdb..#Active') IS NOT NULL DROP TABLE #Active
			IF OBJECT_ID('tempdb..#tempCountLinear') IS NOT NULL DROP TABLE #tempCountLinear
			IF OBJECT_ID('tempdb..#tempNonLinear') IS NOT NULL DROP TABLE #tempNonLinear
			IF OBJECT_ID('tempdb..#tempLanguageAD') IS NOT NULL DROP TABLE #tempLanguageAD
			IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode

		CREATE TAble #tempCountLinear
		(
			TitleLanguage NVARCHAR(100),
			Acquisition INT,
			License INT,			
			OwnProduction INT,
			BuyBack INT,
			Assignment INT,
			Others INT,
			Total INT
		)

		CREATE TAble #tempNonLinear
		(
			TitleLanguage NVARCHAR(100),
			Acquisition INT,
			License int,
			OwnProduction int,
			BuyBack INT,
			Assignment INT,
			Others INT,
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


			/************New Logic For Linear and Non Linear Count*****************/
			DECLARE @Linear INT ,@NonLinear INT

			IF(@DashboardType = 'Movies' OR @DashboardType = 'M')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New  With(NOLOCK) where Parameter_Name = 'DashboardType_Movie_IT' )
			END
			ELSE IF(@DashboardType = 'Program' OR @DashboardType = 'P')
				BEGIN
					SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New  With (NOLOCK) where Parameter_Name = 'DashboardType_Prog_IT' )
				END
			ELSE
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New  With (NOLOCK) where Parameter_Name = 'DashboardType_Web_IT' )
			END

			DECLARE @tblDealType AS TABLE
			(
				Deal_Type_Code INT
			)

			INSERT INTO @tblDealType
			select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')
		
			CREATE TABLE #LinearRightCode(
				RightsCode INT,
				Attrib_Group_Code INT
			)

			INSERT INTO #LinearRightCode(RightsCode, Attrib_Group_Code)
			SELECT DISTINCT ADRP.Acq_Deal_Rights_Code, pag.Attrib_Group_Code
			FROM Acq_Deal_Rights_Platform ADRP (NOLOCK)
			INNER JOIN Platform_Attrib_Group pag (NOLOCK) ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
			WHERE pag.Attrib_Group_Code IN (3,4)

			SET @Linear =  (SELECT SUM(A.NoOfTitles)
							FROM (
									SELECT ISNULL(CAST(t.Year_Of_Production AS NVARCHAR(MAX)),0) AS YOR, dt.Deal_Type_Name AS TitleType,COUNT(Distinct adm.Title_Code) AS NoOfTitles
									FROM Acq_Deal AD (NOLOCK)
									INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
									INNER JOIN @tblDealType  dtc ON dtc.Deal_Type_Code = AD.Deal_Type_Code
									INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code AND lrc.Attrib_Group_Code = 3
									INNER JOIN Acq_Deal_Rights_Title ADM (NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
									INNER JOIN Title t (NOLOCK) ON t.Title_Code  = ADM.Title_Code
									INNER JOIN Role R (NOLOCK) ON R.Role_Code = AD.Role_Code 
									INNER JOIN Deal_Type dt (NOLOCK) ON dt.Deal_Type_Code = dtc.Deal_Type_Code
									where 
									GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
									AND ISNULL(adr.Right_Type, '') <> '' 
									AND t.Title_Language_Code IN (SELECT Language_Codes FROM #tempLanguageAD)
									GROUP BY  dt.Deal_Type_Name, t.Year_Of_Production
							) AS A)

			SET @NonLinear =  (SELECT SUM(A.NoOfTitles)
						FROM (
								SELECT ISNULL(CAST(t.Year_Of_Production AS NVARCHAR(MAX)),0) AS YOR, dt.Deal_Type_Name AS TitleType,COUNT(Distinct adm.Title_Code) AS NoOfTitles
								FROM Acq_Deal AD (NOLOCK)
								INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
								INNER JOIN @tblDealType  dtc ON dtc.Deal_Type_Code = AD.Deal_Type_Code
								INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code AND lrc.Attrib_Group_Code = 4
								INNER JOIN Acq_Deal_Rights_Title ADM  (NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
								INNER JOIN Title t (NOLOCK) ON t.Title_Code  = ADM.Title_Code
								INNER JOIN Role R  (NOLOCK) ON R.Role_Code = AD.Role_Code 
								INNER JOIN Deal_Type dt (NOLOCK) ON dt.Deal_Type_Code = dtc.Deal_Type_Code
								where 
								GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
								AND ISNULL(adr.Right_Type, '') <> '' 
								AND t.Title_Language_Code IN (SELECT Language_Codes FROM #tempLanguageAD)
								GROUP BY  dt.Deal_Type_Name, t.Year_Of_Production
						) AS A)

		
			--SELECT	ISNULL((Select @ActiveCount),0) AS Active,
			--		ISNULL((Select SUM(Total) AS Linear from #tempCountLinear),0) Linear,
			--		ISNULL((Select SUM(Total) AS NonLinear from #tempNonLinear),0) NonLinear,
			--		ISNULL((Select @ALLCount),0) AS Total

			SELECT	ISNULL((Select @ActiveCount),0) AS Active,
					ISNULL(@Linear,0) Linear,
					ISNULL(@NonLinear,0) NonLinear,
					ISNULL((Select @ALLCount),0) AS Total

			IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
			IF OBJECT_ID('tempdb..#Active') IS NOT NULL DROP TABLE #Active
			IF OBJECT_ID('tempdb..#tempCountLinear') IS NOT NULL DROP TABLE #tempCountLinear
			IF OBJECT_ID('tempdb..#tempNonLinear') IS NOT NULL DROP TABLE #tempNonLinear
			IF OBJECT_ID('tempdb..#tempLanguageAD') IS NOT NULL DROP TABLE #tempLanguageAD
			IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPITGetAssetsData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''	
END
