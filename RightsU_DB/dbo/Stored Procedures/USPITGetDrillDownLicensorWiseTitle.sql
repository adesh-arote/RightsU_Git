CREATE PROCEDURE [dbo].[USPITGetDrillDownLicensorWiseTitle]
@DashboardType VARCHAR(50),-- = 'M',
@Language NVARCHAR(50),--  = 'ALL'
@SearchText NVARCHAR(MAX)
AS 
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetDrillDownLicensorWiseTitle]', 'Step 1', 0, 'Started Procedure', 0, ''
		
			IF OBJECT_ID('tempdb..#TempMain') IS NOT NULL DROP TABLE #TempMain
			IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
			IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
			IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
			IF OBJECT_ID('tempdb..#tempRightsStart') IS NOT NULL DROP TABLE #tempRightsStart
			IF OBJECT_ID('tempdb..#tempRightsEnd') IS NOT NULL DROP TABLE #tempRightsEnd
			IF OBJECT_ID('tempdb..#tempExpiring') IS NOT NULL DROP TABLE #tempExpiring
			IF OBJECT_ID('tempdb..#tempVendors') IS NOT NULL DROP TABLE #tempVendors

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

		SET @LinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] (NOLOCK)  where Attrib_Group_Name = 'Linear')
		SET @NonLinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] (NOLOCK)  where Attrib_Group_Name = 'Non-Linear')

		INSERT INTO #LinearRightCode(RightsCode)
		SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
		FROM Acq_Deal_Rights_Platform ADRP (NOLOCK) 
		INNER JOIN Platform_Attrib_Group pag (NOLOCK)  ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
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

		IF(@DashboardType = 'M' OR @DashboardType = 'Movies')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Movie_IT' )
			END
		ELSE IF(@DashboardType = 'p' OR @DashboardType = 'Program')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Prog_IT' )
			END
		ELSE
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'DashboardType_Web_IT' )
			END

				SELECT A.Vendor_Name, COUNT(A.Title_Code) AS RighstStartDate INTO #tempRightsStart 
				 FROM (
					SELECT  distinct 
					ADRT.Title_Code, V.Vendor_Name, -- ADR.Actual_Right_Start_Date, 
					MIN(DATEDIFF(DAY,  ADR.Actual_Right_Start_Date, GETDATE())) AS days
					FROM Acq_Deal AD WITH(NOLOCK)
					INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
					INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADRT.Title_Code
					INNER JOIN #tempLanguage l  ON t.Title_Language_Code = l.Language_Codes
					INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
					INNER JOIN #LinearRightCode lrc on lrc.RightsCode = adr.Acq_Deal_Rights_Code
					WHERE (GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')) AND ADR.Actual_Right_Start_Date < GETDATE()
					AND ISNULL(adr.Right_Type, '') <> ''
					GROUP BY  AD.Vendor_Code, V.Vendor_Name,ADRT.Title_Code, AD.Acq_Deal_Code
				--order by 2,1
				) AS A
				GROUP BY A.Vendor_Name
				Order by 1 desc

			
				SELECT  A.Vendor_Name, COUNT(A.Title_Code) AS RightsEndDate INTO #tempRightsEnd
				FROM (
					SELECT  distinct
					ADRT.Title_Code, V.Vendor_Name, MIN(DATEDIFF(DAY, GETDATE(), ISNULL(ADR.Actual_Right_End_Date,'31DEC9999'))) AS days
					FROM Acq_Deal AD WITH(NOLOCK)
					INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
					INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADRT.Title_Code
					INNER JOIN #tempLanguage l  ON t.Title_Language_Code = l.Language_Codes
					INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
					INNER JOIN #LinearRightCode lrc on lrc.RightsCode = adr.Acq_Deal_Rights_Code
					WHERE (GETDATE() < ADR.Actual_Right_Start_Date AND  GETDATE() < ISNULL(ADR.Actual_Right_End_Date,'31DEC9999'))
					AND ISNULL(adr.Right_Type, '') <> ''
					GROUP BY  AD.Vendor_Code, V.Vendor_Name,ADRT.Title_Code, AD.Acq_Deal_Code
			
				) AS A
				GROUP BY A.Vendor_Name
				Order by 1 desc



				SELECT  A.Vendor_Name, COUNT(A.Title_Code) AS Expiring INTO #tempExpiring
				 FROM (
					SELECT  distinct
					ADRT.Title_Code, V.Vendor_Name, MIN(DATEDIFF(DAY, GETDATE(), ISNULL(ADR.Actual_Right_End_Date,'31DEC9999'))) AS days
					FROM Acq_Deal AD WITH(NOLOCK)
					INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
					INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = ADRT.Title_Code
					INNER JOIN #tempLanguage l  ON t.Title_Language_Code = l.Language_Codes
					INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
					INNER JOIN #LinearRightCode lrc on lrc.RightsCode = adr.Acq_Deal_Rights_Code
					WHERE (GETDATE() > ADR.Actual_Right_Start_Date AND  GETDATE() < ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')) 
					--MIN(DATEDIFF(DAY, GETDATE(), ADR.Actual_Right_End_Date)) < 180
					AND ISNULL(adr.Right_Type, '') <> ''
					GROUP BY  AD.Vendor_Code, V.Vendor_Name,ADRT.Title_Code, AD.Acq_Deal_Code
			
				) AS A
				WHERE A.days <180
				GROUP BY A.Vendor_Name
				Order by 1 desc

		
			SELECT DISTINCT A.Vendor_Name INTO #tempVendors
			FROM (
				SELECT Vendor_Name FROM #tempRightsStart
				UNION
				SELECT Vendor_Name FROM #tempRightsEnd
				UNION
				SELECT Vendor_Name FROM #tempExpiring
			) AS A

			SELECT V.Vendor_Name AS Licensor, ISNULL(rs.RighstStartDate,0) AS RighstStartDate, ISNULL(rn.RightsEndDate,0) AS FutureEndDate, ISNULL(ex.Expiring,0) AS Expiring
			FROM #tempVendors V
			LEFT JOIN #tempRightsStart rs ON rs.Vendor_Name COLLATE DATABASE_DEFAULT = V.Vendor_Name COLLATE DATABASE_DEFAULT
			LEFT JOIN #tempRightsEnd rn ON rn.Vendor_Name COLLATE DATABASE_DEFAULT = V.Vendor_Name COLLATE DATABASE_DEFAULT
			LEFT JOIN #tempExpiring ex ON ex.Vendor_Name COLLATE DATABASE_DEFAULT = V.Vendor_Name COLLATE DATABASE_DEFAULT
			order by 2 desc
		

			IF OBJECT_ID('tempdb..#TempMain') IS NOT NULL DROP TABLE #TempMain
			IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
			IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
			IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
			IF OBJECT_ID('tempdb..#tempRightsStart') IS NOT NULL DROP TABLE #tempRightsStart
			IF OBJECT_ID('tempdb..#tempRightsEnd') IS NOT NULL DROP TABLE #tempRightsEnd
			IF OBJECT_ID('tempdb..#tempRightsEXpiring') IS NOT NULL DROP TABLE #tempRightsEXpiring
			IF OBJECT_ID('tempdb..#tempVendors') IS NOT NULL DROP TABLE #tempVendors
					
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetDrillDownLicensorWiseTitle]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''	
END