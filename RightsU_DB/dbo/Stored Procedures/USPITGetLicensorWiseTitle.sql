CREATE PROCEDURE [dbo].[USPITGetLicensorWiseTitle]
@DashboardType VARCHAR(50), -- = 'M',
@Language NVARCHAR(50) -- = 'ALL'
AS 
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetLicensorWiseTitle]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE 
		@Deal_Type_Code NVARCHAR(100),
		@LanguageNames NVARCHAR(MAX)
	
		CREATE TABLE #tempLanguage(
		Language_Codes INT
		)

		CREATE TABLE #LinearRightCode(
			RightsCode INT
		)
		DECLARE @LinearCode NVARCHAR(MAX)
		DECLARE @NonLinearCode NVARCHAR(MAX)

		SET @LinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] (NOLOCK) where Attrib_Group_Name = 'Linear')
		SET @NonLinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] (NOLOCK) where Attrib_Group_Name = 'Non-Linear')
		INSERT INTO #LinearRightCode(RightsCode)
		SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
		FROM Acq_Deal_Rights_Platform ADRP (NOLOCK)
		INNER JOIN Platform_Attrib_Group pag (NOLOCK) ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
		WHERE pag.Attrib_Group_Code IN (@LinearCode,@NonLinearCode)

		SET @LanguageNames = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DBLanguageNames_IT')
	

		IF(@Language = 'ALL')
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code FROM Language (NOLOCK)
			END
		ELSE IF(@Language = 'Others')
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code FROM Language WITH(NOLOCK) where Language_Name NOT IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
			END
		ELSE
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code FROM Language WITH(NOLOCK) where Language_Name = ''+@Language+''
			END

		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

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

			--SELECT A.Cnt, A.Vendor_Code, A.Vendor_Name INTO #temp
			--FROM (
				SELECT COUNT(DISTINCT ADRT.Title_Code) AS Cnt, AD.Vendor_Code, V.Vendor_Name INTO #temp
				FROM Acq_Deal AD WITH(NOLOCK)
				INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
				INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADRT.Title_Code
				INNER JOIN #tempLanguage l  ON t.Title_Language_Code = l.Language_Codes
				INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN #LinearRightCode lrc on lrc.RightsCode = adr.Acq_Deal_Rights_Code
				WHERE GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
				AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
				GROUP BY AD.Vendor_Code, V.Vendor_Name
			--) AS A
			--ORDER BY A.Cnt DESC

			Select TOP 5 Cnt, Vendor_Code, Vendor_Name INTO #TempMain FROM #temp ORDER BY Cnt DESC

			SELECT Final.Vendor_Name AS Name, Final.Cnt AS Count, Final.Total,ISNULL(CAST(ROUND(Cnt * 100.0 / Total, 1)  as numeric(36,2)),0) AS Percentage FROM (
				SELECT Sort, Cnt,Vendor_Name, (Select SUM(Cnt) from #temp) AS Total FROM (
					Select 'a' AS Sort, Cnt, Vendor_Name FROM #TempMain
					UNION
					SELECT 'b' AS Sort, COUNT(DISTINCT ADRT.Title_Code) AS Cnt, 'Others'
					FROM Acq_Deal AD (NOLOCK)
					INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
					INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADRT.Title_Code
					INNER JOIN #tempLanguage l ON t.Title_Language_Code = l.Language_Codes
					INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code
					WHERE GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
					AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR' 
					AND AD.Vendor_Code NOT IN (
						SELECT Vendor_Code FROM #TempMain
					)

				) AS A
			) AS Final
			WHERE Final.Cnt > 0
			ORDER BY Final.SORT, Cnt Desc

			IF OBJECT_ID('tempdb..#TempMain') IS NOT NULL DROP TABLE #TempMain
			IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
			IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
			IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
		
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetLicensorWiseTitle]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
