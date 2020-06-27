

CREATE PROCEDURE [dbo].[USP_Acq_Deal_Title_Platform_Report]
(
	@Business_Unit_Code INT,
	@Title_Codes VARCHAR(MAX),
	@Platform_Codes VARCHAR(MAX),
	@Show_Expired CHAR(1),
	@Include_Sub_Deal CHAR(1),
	@Module_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N Rajpurohit
-- Create DATE: 16-April-2015
-- Description:	Show Platform wise report
-- =============================================
BEGIN
	PRINT 'Show Platform wise report'

	--DECLARE
	--@Business_Unit_Code INT,
	--@Title_Codes VARCHAR(MAX),
	--@Platform_Codes VARCHAR(MAX),
	--@Show_Expired CHAR(1),
	--@Include_Sub_Deal CHAR(1),
	--@Module_Code INT

	--SELECT
	--@Business_Unit_Code = 1,
	--@Title_Codes = '30080',
	--@Platform_Codes = '152,155',
	--@Show_Expired = 'N',
	--@Include_Sub_Deal = 'N',
	--@Module_Code = 119
	
	IF(@Module_Code <> 119 AND LTRIM(RTRIM(@Platform_Codes)) = '')
	BEGIN
		SELECT @Platform_Codes = ISNULL(STUFF((Select DISTINCT ', ' + CAST(Platform_Code AS VARCHAR) FROM Platform_Module_Config WHERE System_Module_Code = @Module_Code FOR XML PATH('')), 1, 1, ''), '0')
		IF(LTRIM(RTRIM(@Title_Codes)) = '')
		BEGIN
			SELECT @Title_Codes = ISNULL(STUFF((Select DISTINCT ', ' + CAST(ADRT.Title_Code AS varchar) FROM Acq_Deal_Rights ADR
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			INNER JOIN Platform_Module_Config PRC ON PRC.System_Module_Code = @Module_Code AND ADRP.Platform_Code = PRC.Platform_Code
			 FOR XML PATH('')), 1, 1, ''), '0')
		END
	END

	create table #Temp_Platforms
	(
		Agreement_No VARCHAR(MAX)
		,Agreement_Date DATETIME
		,Deal_Desc NVARCHAR(MAX)
		,Licensor NVARCHAR(MAX)
		,Title_Name NVARCHAR(MAX)
		,Right_Type VARCHAR(MAX)
		,Acq_Deal_Rights_Code INT
		,Sub_License NVARCHAR(MAX)
		,Is_Exclusive VARCHAR(10)
		,Term VARCHAR(MAX)
		,Actual_Right_Start_Date DATETIME
		,Actual_Right_End_Date DATETIME
		,Title_Language NVARCHAR(MAX)
		,Platform_Hiearachy NVARCHAR(MAX)
		,Platform_Code INT
		,Available NVARCHAR(MAX)
		,Restriction_Remarks NVARCHAR(MAX)
		,Due_Diligence VARCHAR(10)
		,Category_Name VARCHAR(MAX)
	)

	DECLARE @Deal_Type_Code_Music INT = 0
	select top 1 @Deal_Type_Code_Music = CAST(Parameter_Value AS INT) from System_Parameter_New where Parameter_Name = 'Deal_Type_Music'

	PRINT 'Spliting value of @Platform_Codes...'
	SELECT DISTINCT number AS Platform_Code INTO #Selected_Platforms FROM fn_Split_withdelemiter(@Platform_Codes, ',') Where IsNull(number, '') <> '';
	If((Select Count(*) From #Selected_Platforms) = 0)
	Begin
		Insert InTo #Selected_Platforms(Platform_Code)
		Select Platform_Code From Platform Where Is_Last_Level = 'Y'
	End
	PRINT 'Splited and inserted in #Selected_Platforms table'

	PRINT 'Spliting value of @Title_Codes...'
	SELECT DISTINCT number AS Title_Code INTO #Selected_Titles FROM fn_Split_withdelemiter(@Title_Codes, ',');
	PRINT 'Splited and inserted in #Selected_Titles table'
	PRINT 'Fetching data...'
	--Select * From #Selected_Platforms
	
	INSERT INTO #Temp_Platforms
	Select --*
			Distinct ad.Agreement_No, 
			CAST(ad.Agreement_Date as date),ad.Deal_Desc,V.Vendor_Name AS Licensor,
			DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), t.Title_Name, adrt.Episode_From, adrt.Episode_To) AS Title_Name
			, adr.Right_Type, 
			adr.Acq_Deal_Rights_Code
			,ISNULL(SL.Sub_License_Name, '') AS Sub_License
			,CASE ISNULL(ADR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END AS Is_Exclusive
			,Case adr.Right_Type
						   When 'Y' Then [dbo].[UFN_Get_Rights_Term](adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date, adr.Term) 
						   When 'M' Then [dbo].[UFN_Get_Rights_Milestone](adr.Milestone_Type_Code, adr.Milestone_No_Of_Unit, adr.Milestone_Unit_Type)
						   When 'U' Then 'Perpetuity'
					   End as Term
			, CAST(adr.Actual_Right_Start_Date as date)
			, CAST(adr.Actual_Right_End_Date as date)
			, CASE WHEN adr.Is_Title_Language_Right = 'Y' THEN  ISNULL(L.Language_Name, 'No') ELSE 'No' END  AS Language_Name  
			, Platform_Hiearachy
			, p.Platform_Code
			, 'YES' Available
			,ISNULL(adr.Restriction_Remarks, '') AS [Restriction Remarks]
			,CASE UPPER(LTRIM(RTRIM(ISNULL(ADM.Due_Diligence, '')))) 
			WHEN 'N' THEN 'No'
			WHEN 'Y' THEN 'Yes'
			ELSE 'No' 
		END AS Due_Diligence,
		C.Category_Name AS Category_Name
	From Acq_Deal AD
	INNER JOIN Acq_Deal_Movie ADM On ad.Acq_Deal_Code = ADM.Acq_Deal_Code AND AD.Business_Unit_Code = @Business_Unit_Code 
	AND (Title_Code IN (SELECT Title_Code FROM #Selected_Titles) Or @Title_Codes = '')
	OR(	
		@Include_Sub_Deal = 'Y' AND AD.Master_Deal_Movie_Code_ToLink IN (
			Select Acq_Deal_Movie_Code From Acq_Deal_Movie Where (Title_Code IN (SELECT Title_Code FROM #Selected_Titles) Or @Title_Codes = '')
		)
	)
	Inner Join Acq_Deal_Rights adr On ad.Acq_Deal_Code = adr.Acq_Deal_Code 
	Inner Join Acq_Deal_Rights_Platform adrp On adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code AND 
	(@Show_Expired = 'Y' OR ISNULL(ADR.Actual_Right_End_Date, GETDATE()) >= GETDATE()) 
	Inner Join Acq_Deal_Rights_Title adrt On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code AND ADM.Title_Code = adrt.Title_Code
	Inner Join Title t On adrt.Title_Code = t.Title_Code
	Inner Join Platform p On p.Platform_Code = adrp.Platform_Code
	INNER JOIN #Selected_Platforms pTEMP ON pTEMP.Platform_Code = P.Platform_Code
	INNER JOIN Vendor V ON AD.Vendor_Code = v.Vendor_Code
	LEFT JOIN Language L ON L.Language_Code = T.Title_Language_Code 
	LEFT JOIN Sub_License SL ON adr.Sub_License_Code = sl.Sub_License_Code
	INNER JOIN Category C ON AD.Category_Code = C.Category_Code
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND (AD.Is_Master_Deal != @Include_Sub_Deal OR @Include_Sub_Deal = 'Y' OR AD.Deal_Type_Code = @Deal_Type_Code_Music)
	PRINT 'Fetched data'

	PRINT 'Altering #Temp_Platforms table...'
	ALTER TABLE #Temp_Platforms
	ADD Region_Names NVARCHAR(Max), 
		Subtitling_Names NVARCHAR(Max),
		Dubbing_Names NVARCHAR(Max)

	PRINT 'Altered #Temp_Platforms table'

	PRINT 'updating value of newly added column in #Temp_Platforms table...'
	Update #Temp_Platforms Set 
	Region_Names = DBO.UFN_Get_Rights_Country(Acq_Deal_Rights_Code, 'A',''),
	Subtitling_Names = DBO.UFN_Get_Rights_Subtitling(Acq_Deal_Rights_Code, 'A'),
	Dubbing_Names = DBO.UFN_Get_Rights_Dubbing(Acq_Deal_Rights_Code, 'A')

	UPDATE #Temp_Platforms SET Region_Names = DBO.UFN_Get_Rights_Territory(Acq_Deal_Rights_Code, 'A') WHERE LTRIM(RTRIM(Region_Names)) = ''
	UPDATE #Temp_Platforms SET Subtitling_Names = 'No' WHERE LTRIM(RTRIM(Subtitling_Names)) = ''
	UPDATE #Temp_Platforms SET Dubbing_Names = 'No' WHERE LTRIM(RTRIM(Dubbing_Names)) = ''
	PRINT 'Updated'
	
	SELECT * FROM #Temp_Platforms
	
	IF OBJECT_ID('tempdb..#Selected_Platforms') IS NOT NULL DROP TABLE #Selected_Platforms
	IF OBJECT_ID('tempdb..#Selected_Titles') IS NOT NULL DROP TABLE #Selected_Titles
	IF OBJECT_ID('tempdb..#Temp_Platforms') IS NOT NULL DROP TABLE #Temp_Platforms
END

--EXEC USP_Acq_Deal_Title_Platform_Report 1, '', '', 'Y', 'Y', 30

--Select * from Acq_Deal ORDER BY 1 DESC
--Select * from Acq_Deal where Acq_Deal_Code = 24974
--Select * from Acq_Deal_Rights where Acq_Deal_Code = 24974
--Select * from Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code = 39752
--Select * from Title where title_name like '%haid%'
--Select * from Acq_Deal_Rights_Title where Acq_Deal_Rights_Code = 39752