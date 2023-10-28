CREATE PROCEDURE [dbo].[USPGetDashBoardNeoData] 
@DashboardType VARCHAR(50),
@PlatformType VARCHAR(10),
@Language NVARCHAR(50)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPGetDashBoardNeoData]', 'Step 1', 0, 'Started Procedure', 0, ''

	--DECLARE
	--@DashboardType VARCHAR(50) = 'P',
	--@PlatformType VARCHAR(10) = 'ALL',
	--@Language NVARCHAR(50) = 'ALL'

		IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
		IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
		IF OBJECT_ID('tempdb..#tempDealTypeCode') IS NOT NULL DROP TABLE #tempDealTypeCode
		IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1

		CREATE TABLE #LinearRightCode(
			RightsCode INT
		)

		CREATE TABLE #tempLanguage(
			Language_Codes INT
		)

		CREATE TABLE #tempDealTypeCode(
			Deal_Type_Code INT
		)

	--Dashboard Type : Movies/Program/Web Series --M/P/W
	--PlatformType : Linear/NonLinear/All -- L/NL/ALL 

		--CREATE TABLE #NonLinearRightCode(
		--RightsCode INT
		--) 

		DECLARE
		@Deal_Type_Code NVARCHAR(MAX),
		@LanguageNames NVARCHAR(MAX),
		@RoleName NVARCHAR(MAX)
	
		SET @LanguageNames = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DBLanguageNames_IT')
		SET @RoleName = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DBRoleName_IT')
		DECLARE @LinearCode NVARCHAR(MAX)
		DECLARE @NonLinearCode NVARCHAR(MAX)

		SET @LinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] (NOLOCK)  where Attrib_Group_Name = 'Linear')
		SET @NonLinearCode = (SELECT Attrib_Group_Code from [dbo].[Attrib_Group] (NOLOCK)  where Attrib_Group_Name = 'Non-Linear')
		IF(@Language = 'ALL')
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code FROM Language (NOLOCK) 
			END
		ELSE IF(@Language = 'Others')
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code  FROM Language (NOLOCK)  where Language_Name COLLATE DATABASE_DEFAULT NOT IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
			END
		ELSE
			BEGIN
				INSERT INTO #tempLanguage
				SELECT Language_Code FROM Language (NOLOCK)  where Language_Name = ''+@Language+''
			END


		IF(@DashboardType = 'M')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Movie_IT' )
			END
		ELSE IF(@DashboardType = 'p')
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Prog_IT' )
			END
		ELSE
			BEGIN
				SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Web_IT' )
			END


		INSERT INTO #tempDealTypeCode
		select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')

		IF(@PlatformType = 'ALL')
			BEGIN
				INSERT INTO #LinearRightCode(RightsCode)
				SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
				FROM Acq_Deal_Rights_Platform ADRP (NOLOCK) 
				INNER JOIN Platform_Attrib_Group pag (NOLOCK)  ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
				WHERE pag.Attrib_Group_Code IN (@LinearCode,@NonLinearCode)
			END
		ELSE IF(@PlatformType = 'L')
			BEGIN
				INSERT INTO #LinearRightCode(RightsCode)
				SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
				FROM Acq_Deal_Rights_Platform ADRP (NOLOCK) 
				INNER JOIN Platform_Attrib_Group pag (NOLOCK)  ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
				WHERE pag.Attrib_Group_Code = @LinearCode
			END
		ELSE
			BEGIN
				INSERT INTO #LinearRightCode(RightsCode)
				SELECT DISTINCT ADRP.Acq_Deal_Rights_Code
				FROM Acq_Deal_Rights_Platform ADRP (NOLOCK) 
				INNER JOIN Platform_Attrib_Group pag (NOLOCK)  ON pag.Platform_Code = ADRP.Platform_Code AND ADRP.Acq_Deal_Rights_Code IS NOT NULL
				WHERE pag.Attrib_Group_Code = @NonLinearCode
			END

		DECLARE @RoleCount INT = 0
		DECLARE @Role_Name NVARCHAR(MAX) = ''

		SELECT @RoleCount = COUNT(Role_Name)  FROM
			(SELECT DISTINCT Role_Name FROM(
				SELECT DISTINCT AD.Acq_Deal_Code,ADR.Acq_Deal_Rights_Code,adm.Title_Code,L.Language_Name, Role_Name
				FROM Acq_Deal AD (NOLOCK) 
				INNER JOIN Acq_Deal_Rights ADR (NOLOCK)  ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code --AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')))
				INNER JOIN #tempDealTypeCode dtc ON dtc.Deal_Type_Code = AD.Deal_Type_Code
				INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Title ADM  (NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Title t  (NOLOCK) ON t.Title_Code  = ADM.Title_Code
				INNER JOIN #tempLanguage tl ON t.Title_Language_Code = tl.Language_Codes
				INNER JOIN Language L (NOLOCK)  ON L.Language_Code = t.Title_Language_Code --AND L.Language_Name IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
				INNER JOIN Role R (NOLOCK)  ON R.Role_Code = AD.Role_Code 
				--INNER JOIN Acq_Deal_Movie adrm ON adr.Acq_Deal_Code = adrm.Acq_Deal_Code AND adrm.Title_Code = adm.Title_Code AND adrm.Episode_Starts_From = adm.Episode_From AND adrm.Episode_End_To = adm.Episode_To
				where --R.Role_Name IN (select number from dbo.fn_Split_withdelemiter(''+@RoleName+'',',')) AND 
				GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
				AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
			) AS A
				GROUP BY A.Language_Name,Role_Name) AS TT 
		WHERE TT.Role_Name IN ('Buy Back', 'Assignment')
		
		IF(@RoleCount = 1)
		BEGIN

			SELECT TOP 1 @Role_Name = Role_Name  FROM
				(SELECT DISTINCT Role_Name FROM(
					SELECT DISTINCT AD.Acq_Deal_Code,ADR.Acq_Deal_Rights_Code,adm.Title_Code,L.Language_Name, Role_Name
					FROM Acq_Deal AD (NOLOCK) 
					INNER JOIN Acq_Deal_Rights ADR (NOLOCK)  ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code --AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')))
					INNER JOIN #tempDealTypeCode dtc ON dtc.Deal_Type_Code = AD.Deal_Type_Code
					INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Title ADM  (NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					INNER JOIN Title t  (NOLOCK) ON t.Title_Code  = ADM.Title_Code
					INNER JOIN #tempLanguage tl ON t.Title_Language_Code = tl.Language_Codes
					INNER JOIN Language L (NOLOCK)  ON L.Language_Code = t.Title_Language_Code --AND L.Language_Name IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
					INNER JOIN Role R (NOLOCK)  ON R.Role_Code = AD.Role_Code 
					--INNER JOIN Acq_Deal_Movie adrm ON adr.Acq_Deal_Code = adrm.Acq_Deal_Code AND adrm.Title_Code = adm.Title_Code AND adrm.Episode_Starts_From = adm.Episode_From AND adrm.Episode_End_To = adm.Episode_To
					where --R.Role_Name IN (select number from dbo.fn_Split_withdelemiter(''+@RoleName+'',',')) AND 
					GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
					AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
				) AS A
					GROUP BY A.Language_Name,Role_Name) AS TT 
			WHERE TT.Role_Name IN ('Buy Back', 'Assignment')

			DECLARE @RoleNameWithoutSpace NVARCHAR(MAX) = ''
			SET @RoleNameWithoutSpace = (SELECT REPLACE(@Role_Name, ' ', ''))

			DECLARE @ColumnsRoleName NVARCHAR(MAX) = ''
			IF(@Role_Name = 'Buy Back')
			BEGIN
				SET @ColumnsRoleName = 'null AS Assignment,'
			END	
			ELSE IF(@Role_Name = 'Assignment')
			BEGIN
				SET @ColumnsRoleName = 'null AS BuyBack,'
			END

			SELECT * INTO #temp 
			FROM   
			(
				SELECT COUNT(DISTINCT A.Title_Code) AS TitleCount, A.Language_Name AS [TitleLanguage], Role_Name FROM(
				Select Distinct AD.Acq_Deal_Code,ADR.Acq_Deal_Rights_Code,adm.Title_Code,L.Language_Name, Role_Name
				FROM Acq_Deal AD (NOLOCK) 
				INNER JOIN Acq_Deal_Rights ADR (NOLOCK)  ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code --AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')))
				INNER JOIN #tempDealTypeCode dtc ON dtc.Deal_Type_Code = AD.Deal_Type_Code
				INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Title ADM  (NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Title t  (NOLOCK) ON t.Title_Code  = ADM.Title_Code
				INNER JOIN #tempLanguage tl ON t.Title_Language_Code = tl.Language_Codes
				INNER JOIN Language L (NOLOCK)  ON L.Language_Code = t.Title_Language_Code --AND L.Language_Name IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
				INNER JOIN Role R (NOLOCK)  ON R.Role_Code = AD.Role_Code 
				--INNER JOIN Acq_Deal_Movie adrm ON adr.Acq_Deal_Code = adrm.Acq_Deal_Code AND adrm.Title_Code = adm.Title_Code AND adrm.Episode_Starts_From = adm.Episode_From AND adrm.Episode_End_To = adm.Episode_To
				where --R.Role_Name IN (select number from dbo.fn_Split_withdelemiter(''+@RoleName+'',',')) AND 
				GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
				AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
			) AS A
				GROUP BY A.Language_Name,Role_Name
			) t 
			PIVOT(
				SUM(TitleCount) 
				FOR [Role_name] IN (
					[Acquisition],
					[License],
					[Own Production],
					[Buy Back],
					[Assignment]
					)
			) AS pivot_table;

			EXEC('Select [TitleLanguage], null AS Acquisition, ISNULL(Acquisition,0) AS License, ISNULL([Own Production],0) AS [OwnProduction], ISNULL(['+@Role_Name+'],0) AS ['+@RoleNameWithoutSpace+'], '+@ColumnsRoleName+' null AS Others,
			(ISNULL(Acquisition,0)+ISNULL([Own Production],0)+ISNULL([Buy Back],0)+ISNULL([Assignment],0)) AS Total FROM #temp')
		END		
		ELSE
		BEGIN
			SELECT * INTO #temp1 
			FROM   
			(
				SELECT COUNT(DISTINCT A.Title_Code) AS TitleCount, A.Language_Name AS [TitleLanguage], CASE WHEN Role_Name NOT IN ('Own Production', 'License', 'Acquisition') THEN 'Others' Else Role_Name END AS Role_Name FROM(
				Select Distinct AD.Acq_Deal_Code,ADR.Acq_Deal_Rights_Code,adm.Title_Code,L.Language_Name, Role_Name
				FROM Acq_Deal AD (NOLOCK) 
				INNER JOIN Acq_Deal_Rights ADR (NOLOCK)  ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code --AND AD.Deal_Type_Code IN ((select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',',')))
				INNER JOIN #tempDealTypeCode dtc ON dtc.Deal_Type_Code = AD.Deal_Type_Code
				INNER JOIN #LinearRightCode lrc on lrc.RightsCode = ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Rights_Title ADM  (NOLOCK) ON ADM.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Title t  (NOLOCK) ON t.Title_Code  = ADM.Title_Code
				INNER JOIN #tempLanguage tl ON t.Title_Language_Code = tl.Language_Codes
				INNER JOIN Language L (NOLOCK)  ON L.Language_Code = t.Title_Language_Code --AND L.Language_Name IN (select number from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',','))
				INNER JOIN Role R (NOLOCK)  ON R.Role_Code = AD.Role_Code 
				--INNER JOIN Acq_Deal_Movie adrm ON adr.Acq_Deal_Code = adrm.Acq_Deal_Code AND adrm.Title_Code = adm.Title_Code AND adrm.Episode_Starts_From = adm.Episode_From AND adrm.Episode_End_To = adm.Episode_To
				where --R.Role_Name IN (select number from dbo.fn_Split_withdelemiter(''+@RoleName+'',',')) AND 
				GETDATE() BETWEEN ADR.Actual_Right_Start_Date AND ISNULL(ADR.Actual_Right_End_Date,'31DEC9999')
				AND ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR'
			) AS A
				GROUP BY A.Language_Name,Role_Name
			) t 
			PIVOT(
				SUM(TitleCount) 
				FOR [Role_name] IN (
					[Acquisition],
					[License],
					[Own Production],
					[Others]
					)
			) AS pivot_table;

			Select [TitleLanguage], null AS Acquisition, ISNULL(Acquisition,0) AS License, ISNULL([Own Production],0) AS [OwnProduction], null AS [BuyBack], null AS [Assignment], ISNULL([Others],0) AS [Others],
			(ISNULL(Acquisition,0)+ISNULL([Own Production],0)+ISNULL([Others],0)) AS Total FROM #temp1
		END

		IF OBJECT_ID('tempdb..#LinearRightCode') IS NOT NULL DROP TABLE #LinearRightCode
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
		IF OBJECT_ID('tempdb..#tempLanguage') IS NOT NULL DROP TABLE #tempLanguage
		IF OBJECT_ID('tempdb..#tempDealTypeCode') IS NOT NULL DROP TABLE #tempDealTypeCode
		IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPGetDashBoardNeoData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
