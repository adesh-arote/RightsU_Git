
--ALTER Procedure [dbo].[USP_Acquition_Deal_List_Report](
--	@Agreement_No VARCHAR(100), 
--	@Is_Master_Deal VARCHAR(2), 
--	@Start_Date VARCHAR(30), 
--	@End_Date VARCHAR(30), 
--	@Deal_Tag_Code Int, 
--	@Title_Name NVARCHAR(100), 
--	@Business_Unit_code VARCHAR(100), 
--	@Is_Pushback VARCHAR(100), 
--	@SysLanguageCode INT,
--	@DealSegment INT)
--As
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date:	18 Feb 2015
-- Description:	Get Acquisition Deal List Report Data
-- =============================================
BEGIN
	DECLARE 
	@Agreement_No Varchar(100), 
	@Is_Master_Deal Varchar(2), 
	@Start_Date Varchar(30), 
	@End_Date Varchar(30), 
	@Deal_Tag_Code Int, 
	@Title_Name Varchar(100), 
	@Business_Unit_code VARCHAR(100), 
	@Is_Pushback Varchar(100),
	@SysLanguageCode INT,
	@DealSegment INT

	SET @Agreement_No = ''
	set @Is_Master_Deal = 'Y'
	SET @Start_Date= ''
	SET @End_Date = ''
	SET @Deal_Tag_Code = 0
	SET @Title_Name = ''
	SET @Business_Unit_code = '9'
	SET @Is_Pushback = 'N'
	SET @SysLanguageCode = 1
	SET @DealSegment = 0
	--EXEC USP_Acquition_Deal_List_Report 'A-2015-00002','','01-Dec-2015','','0','','1','N'
	--EXEC USP_Acquition_Deal_List_Report 'A-2017-00002', '', '', '', '', '', '','N'

DECLARE 
	
	@Col_Head01 NVARCHAR(MAX) = '',  
	@Col_Head02 NVARCHAR(MAX) = '',  
	@Col_Head03 NVARCHAR(MAX) = '',
	@Col_Head04 NVARCHAR(MAX) = '', 
	@Col_Head05 NVARCHAR(MAX) = '', 
	@Col_Head06 NVARCHAR(MAX) = '', 
	@Col_Head07 NVARCHAR(MAX) = '', 
	@Col_Head08 NVARCHAR(MAX) = '', 
	@Col_Head09 NVARCHAR(MAX) = '', 
	@Col_Head10 NVARCHAR(MAX) = '', 
	@Col_Head11 NVARCHAR(MAX) = '', 
	@Col_Head12 NVARCHAR(MAX) = '', 
	@Col_Head13 NVARCHAR(MAX) = '', 
	@Col_Head14 NVARCHAR(MAX) = '', 
	@Col_Head15 NVARCHAR(MAX) = '', 
	@Col_Head16 NVARCHAR(MAX) = '', 
	@Col_Head17 NVARCHAR(MAX) = '', 
	@Col_Head18 NVARCHAR(MAX) = '', 
	@Col_Head19 NVARCHAR(MAX) = '', 
	@Col_Head20 NVARCHAR(MAX) = '', 
	@Col_Head21 NVARCHAR(MAX) = '', 
	@Col_Head22 NVARCHAR(MAX) = '', 
	@Col_Head23 NVARCHAR(MAX) = '', 
	@Col_Head24 NVARCHAR(MAX) = '', 
	@Col_Head25 NVARCHAR(MAX) = '', 
	@Col_Head26 NVARCHAR(MAX) = '', 
	@Col_Head27 NVARCHAR(MAX) = '', 
	@Col_Head28 NVARCHAR(MAX) = '', 
	@Col_Head29 NVARCHAR(MAX) = '', 
	@Col_Head30 NVARCHAR(MAX) = '', 
	@Col_Head31 NVARCHAR(MAX) = '', 
	@Col_Head32 NVARCHAR(MAX) = '', 
	@Col_Head33 NVARCHAR(MAX) = '', 
	@Col_Head34 NVARCHAR(MAX) = '', 
	@Col_Head35 NVARCHAR(MAX) = '', 
	@Col_Head36 NVARCHAR(MAX) = '', 
	@Col_Head37 NVARCHAR(MAX) = '', 
	@Col_Head38 NVARCHAR(MAX) = '',
	@Col_Head39 NVARCHAR(MAX) = '',
	@Col_Head40 NVARCHAR(MAX) = '',
	@Col_Head41 NVARCHAR(MAX) = '',
	@Col_Head42 NVARCHAR(MAX) = '',
	@Col_Head43 NVARCHAR(MAX) = '',
	@Col_Head44 NVARCHAR(MAX) = '',
	@Col_Head45 NVARCHAR(MAX) = '',
	@Col_Head46 NVARCHAR(MAX) = '',
	@Col_Head47 NVARCHAR(MAX) = '',
	@Col_Head48 NVARCHAR(MAX) = '',
	@Col_Head49 NVARCHAR(MAX) = '',
	@Col_Head50 NVARCHAR(MAX) = ''

	IF OBJECT_ID('tempdb..#TempAcqDealListReport') IS NOT NULL
		DROP TABLE #TempAcqDealListReport

	IF OBJECT_ID('tempdb..#TEMP_Acquition_Deal_List_Report') IS NOT NULL
		DROP TABLE #TEMP_Acquition_Deal_List_Report
		
	CREATE TABLE #TEMP_Acquition_Deal_List_Report(
		Title_Name NVARCHAR(MAX),
		Episode_From INT,
		Episode_To INT,
		Deal_Type_Code INT,
		Director NVARCHAR(MAX),
		Star_Cast NVARCHAR(MAX),
		Genre NVARCHAR(MAX),
		Title_Language NVARCHAR(MAX),
		year_of_production INT,
		Acq_Deal_code INT,
		Agreement_No VARCHAR(MAX),
		Deal_Description NVARCHAR(MAX),
		Reference_No NVARCHAR(MAX),
		Is_Master_Deal CHAR(1),
		Agreement_Date DATETIME,
		Deal_Tag_Code INT,
		Deal_Tag_Description NVARCHAR(MAX),
		Party NVARCHAR(MAX),
		Party_Master NVARCHAR(MAX),
		Platform_Name VARCHAR(MAX),
		Right_Start_Date DATETIME, 
		Right_End_Date DATETIME,
		Is_Title_Language_Right CHAR(1),
		Country_Territory_Name NVARCHAR(MAX),
		Is_Exclusive CHAR(1),
		Subtitling NVARCHAR(MAX),
		Dubbing NVARCHAR(MAX),
		Sub_Licencing NVARCHAR(MAX),
		Is_Tentative CHAR(1),
		Is_ROFR CHAR(1),
		First_Refusal_Date DATETIME,
		Restriction_Remarks NVARCHAR(MAX),
		Holdback_Platform NVARCHAR(MAX),
		Holdback_Rights NVARCHAR(MAX),
		Blackout NVARCHAR(MAX),
		General_Remark NVARCHAR(MAX),
		Rights_Remarks NVARCHAR(MAX),
		Payment_Remarks NVARCHAR(MAX),
		Right_Type VARCHAR(MAX),
		Right_Term VARCHAR(MAX),
		Deal_Workflow_Status VARCHAR(MAX),
		Is_Pushback CHAR(1),
		Master_Deal_Movie_Code_ToLink INT,
		Run_Type CHAR(9),
		Is_Attachment CHAR(3),
		[Program_Name] NVARCHAR(MAX),
		Promtoer_Group NVARCHAR(MAX),
		Promtoer_Remarks NVARCHAR(MAX),
		Due_Diligence VARCHAR(MAX),
		Category_Name VARCHAR(MAX),
		Deal_Segment NVARCHAR(MAX)
	)

	DECLARE @IsDealSegment AS VARCHAR(100)
	SELECT @IsDealSegment = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Deal_Segment' 

	--IF(@Is_Pushback != 'Y' )
	BEGIN
		PRINT 'Select all data of Right'
		---- Tnsert Right in #TEMP_Acquition_Deal_List_Report table ---
		INSERT INTO #TEMP_Acquition_Deal_List_Report
		(
			Title_Name
			,Episode_From,Episode_To,Deal_Type_Code
			,Director, Star_Cast
			,Genre, Title_Language, year_of_production, Acq_Deal_code 
			,Deal_Description, Reference_No, Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party,Party_Master
			,Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right
			,Country_Territory_Name
			,Is_Exclusive, Subtitling
			,Dubbing
			,Sub_Licencing
			,Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks
			,Holdback_Platform
			,Holdback_Rights 
			,Blackout
			,General_Remark, Rights_Remarks, Payment_Remarks, Right_Type
			,Right_Term
			,Deal_Workflow_Status
			,Is_Pushback, Master_Deal_Movie_Code_ToLink
			,Run_Type
			,Is_Attachment
			,[Program_Name]
			,Promtoer_Group
			,Promtoer_Remarks
			,Due_Diligence
			,Category_Name
		)

		Select 
		T.Title_Name
		,CAST(ADRT.Episode_From AS INT)
		,ADRT.Episode_To,AD.Deal_Type_Code 
		,dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast
		,dbo.UFN_Get_Title_Genre(t.title_code) Genre, ISNULL(L.language_name, '') AS Title_Language, t.year_of_production, AD.Acq_Deal_Code
		,AD.Deal_Desc, AD.Ref_No, AD.Agreement_No, AD.Is_Master_Deal, CAST(AD.Agreement_Date as date), AD.Deal_Tag_Code, TG.Deal_Tag_Description, V.Vendor_Name,PG.Party_Group_Name
		,[dbo].[UFN_Get_Platform_Name](ADR.Acq_Deal_Rights_Code, 'AR') Platform_Name, ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right
		,CASE (DBO.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'A',''))
			WHEN '' THEN DBO.UFN_Get_Rights_Territory(ADR.Acq_Deal_Rights_Code, 'A')
			ELSE DBO.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'A','')
		 END AS  Country_Territory_Name
		,ADR.Is_Exclusive AS Is_Exclusive, DBO.UFN_Get_Rights_Subtitling(ADR.Acq_Deal_Rights_Code, 'A') Subtitling
		,DBO.UFN_Get_Rights_Dubbing(ADR.Acq_Deal_Rights_Code, 'A') Dubbing
		,CASE LTRIM(RTRIM(ADR.Is_Sub_License))
			WHEN 'Y' THEN SL.Sub_License_Name
			ELSE 'No Sub Licensing'
		END SubLicencing
		,ADR.Is_Tentative, ADR.Is_ROFR, ADR.ROFR_Date AS First_Refusal_Date, ADR.Restriction_Remarks AS Restriction_Remarks, 
		[dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](ADR.Acq_Deal_Rights_Code, 'AR','P') Holdback_Platform,
		[dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](ADR.Acq_Deal_Rights_Code, 'AR','R') Holdback_Right,  
		[dbo].[UFN_Get_Blackout_Period](ADR.Acq_Deal_Rights_Code, 'AR') Blackout,
		AD.Remarks AS General_Remark, AD.Rights_Remarks AS Rights_Remarks, AD.Payment_Terms_Conditions AS Payment_Remarks, ADR.Right_Type,
		CASE ADR.Right_Type
			WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, Term) 
			WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
			WHEN 'U' THEN 'Perpetuity'
		End Right_Term,
		CASE UPPER(LTRIM(RTRIM(ISNULL(AD.Deal_Workflow_Status, '')))) 
			WHEN 'N' THEN 'Created'
			WHEN 'W' THEN 'Sent for authorization'
			WHEN 'A' THEN 'Approved' 
			WHEN 'R' THEN 'Declined'
			WHEN 'AM' THEN 'Amended'
			ELSE Deal_Workflow_Status 
		END AS Deal_Workflow_Status,
		'N' as Is_Pushback, AD.Master_Deal_Movie_Code_ToLink
		,[dbo].[UFN_Get_Run_Type] (AD.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code ,@Title_Name) AS Run_Type,
		CASE WHEN (SELECT count(*) FROM Acq_Deal_Attachment ADT WHERE ADT.Acq_Deal_Code = AD.Acq_Deal_Code) > 0 THEN 'Yes'
                   ELSE 'No'
		END AS Is_Attachment,
		P.Program_Name as Program_Name,
		dBO.UFN_Get_Rights_Promoter_Group_Remarks(ADR.Acq_Deal_Rights_Code,'P','A')
			as Promoter_Group_Name,
			dBO.UFN_Get_Rights_Promoter_Group_Remarks(ADR.Acq_Deal_Rights_Code,'R','A')
			as Promoter_Remarks_Name,
		CASE UPPER(LTRIM(RTRIM(ISNULL(ADM.Due_Diligence, '')))) 
			WHEN 'N' THEN 'No'
			WHEN 'Y' THEN 'Yes'
			ELSE 'No' 
		END AS Due_Diligence,
		C.Category_Name AS Category_Name
		
		From Acq_Deal AD
		INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
		LEFT JOIN Party_Group PG ON v.Party_Group_Code = PG.Party_Group_Code
		LEFT JOIN Sub_License SL ON ADR.Sub_License_Code = SL.Sub_License_Code
		INNER JOIN Deal_Tag TG On AD.Deal_Tag_Code = TG.Deal_Tag_Code
		INNER JOIN Title T On ADRT.Title_Code = T.title_code
		LEFT JOIN Program P on T.Program_Code = P.Program_Code
		LEFT JOIN Language L on T.Title_Language_Code = L.language_code
		LEFT JOIN Acq_Deal_Movie ADM on ADRT.Title_Code = ADM.Title_Code AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To AND ADM.Acq_Deal_Code = AD.Acq_Deal_Code
		INNER JOIN Category C ON AD.Category_Code = C.Category_Code
		WHERE  
		AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
		(((ISNULL(CONVERT(date,ADR.Actual_Right_Start_Date ,103),'') >= CONVERT(date,@Start_Date,103)  OR @Start_Date = '' )AND (ISNULL(CONVERT(date,ADR.Actual_Right_Start_Date,103),'') <= CONVERT(date,@End_Date,103) OR @End_Date = '' ))
		AND ((CONVERT(date,ISNULL(ADR.Actual_Right_End_Date,'9999-12-31'),103) <=  CONVERT(date,@End_Date,103) OR @End_Date = '') AND (CONVERT(date,ISNULL(ADR.Actual_Right_End_Date,'9999-12-31'),103)>= CONVERT(date,@Start_Date,103) OR @Start_Date = '' )))
		AND AD.Agreement_No like '%' + @Agreement_No + '%' 
		AND (AD.Is_Master_Deal = @Is_Master_Deal Or @Is_Master_Deal = '')
		AND (AD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
		AND (AD.Business_Unit_Code = CAST(@Business_Unit_code AS INT) OR CAST(@Business_Unit_code AS INT) = 0)
		AND (@Title_Name = '' OR ADRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Name,','))
		OR ad.Master_Deal_Movie_Code_ToLink IN (SELECT admT.Acq_Deal_Movie_Code FROM Acq_Deal_Movie admT where admT.Title_Code IN (select number from fn_Split_withdelemiter(@Title_Name,','))
		)
		)
	END


	IF(@Is_Pushback != 'N' )
	BEGIN
		---- Tnsert Right in #TEMP_Acquition_Deal_List_Report table ---
		INSERT INTO #TEMP_Acquition_Deal_List_Report
		(
			Title_Name 
			,Episode_From,Episode_To,Deal_Type_Code
			,Director, Star_Cast, 
			Genre, Title_Language, year_of_production, Acq_Deal_code, Deal_Description, Reference_No, 
			Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party,Party_Master,
			Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right, 
			Country_Territory_Name, Is_Exclusive, 
			Subtitling, Dubbing, Sub_Licencing, 
			Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks, 
			Holdback_Platform,Holdback_Rights
			,Blackout, 
			General_Remark, Rights_Remarks, Payment_Remarks, 
			Right_Type, Right_Term,
			Deal_Workflow_Status, Is_Pushback, Master_Deal_Movie_Code_ToLink, Run_Type,Is_Attachment,[Program_Name],
			Due_Diligence,
			Category_Name
		)
		Select T.Title_Name,
		CAST(ADPT.Episode_From AS INT),ADPT.Episode_To,AD.Deal_Type_Code,
		dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast,
		dbo.UFN_Get_Title_Genre(t.title_code) Genre, ISNULL(L.language_name, '') AS Title_Language, t.year_of_production, AD.Acq_Deal_Code, AD.Deal_Desc, AD.Ref_No,
		AD.Agreement_No, AD.Is_Master_Deal, CAST(AD.Agreement_Date as date), ad.Deal_Tag_Code, tg.Deal_Tag_Description, V.Vendor_Name, pg.Party_Group_Name,
		[dbo].[UFN_Get_Platform_Name](ADP.Acq_Deal_Pushback_Code, 'AP') Platform_Name, ADP.Right_Start_Date, ADP.Right_End_Date, ADP.Is_Title_Language_Right, 
		--DBO.UFN_Get_Rights_Country(ADP.Acq_Deal_Pushback_Code, 'p','')
		--AS  Country_Territory_Name,
		CASE (DBO.UFN_Get_Rights_Country(ADP.Acq_Deal_Pushback_Code, 'P',''))
			WHEN '' THEN DBO.UFN_Get_Rights_Territory(ADP.Acq_Deal_Pushback_Code, 'P')
			ELSE DBO.UFN_Get_Rights_Country(ADP.Acq_Deal_Pushback_Code, 'P','')
		 END AS  Country_Territory_Name,

		'' Is_Exclusive,
		DBO.UFN_Get_Rights_Subtitling(ADP.Acq_Deal_Pushback_Code, 'P') Subtitling, DBO.UFN_Get_Rights_Dubbing(ADP.Acq_Deal_Pushback_Code, 'P') Dubbing,
		'' SubLicencing, ADP.Is_Tentative, 'N' Is_ROFR, NULL First_Refusal_Date, '' Restriction_Remarks, 
		'' Holdback_Platform,'' Holdback_Rights, 
		'' Blackout, '' General_Remark ,ADP.Remarks Rights_Remarks,
		'' Payment_Remarks, ADP.Right_Type,
		CASE ADP.Right_Type
			WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](ADP.Right_Start_Date, Right_End_Date, Term) 
			WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
			WHEN 'U' THEN 'Perpetuity'
		End Right_Term,
		CASE UPPER(LTRIM(RTRIM(ISNULL(AD.Deal_Workflow_Status, '')))) 
			WHEN 'N' THEN 'Created'
			WHEN 'W' THEN 'Sent for authorization'
			WHEN 'A' THEN 'Approved' 
			WHEN 'R' THEN 'Declined'
			WHEN 'AM' THEN 'Ammended'
			ELSE Deal_Workflow_Status 
		END AS Deal_Workflow_Status, 'Y' as Is_Pushback, AD.Master_Deal_Movie_Code_ToLink, '--',
		CASE WHEN (SELECT count(*) from Acq_Deal_Attachment ADT WHERE ADT.Acq_Deal_Code = AD.Acq_Deal_Code) > 0 THEN 'Yes'
                   ELSE 'No'
		END AS Is_Attachment,
		P.Program_Name as 'Program_Name',
		CASE UPPER(LTRIM(RTRIM(ISNULL(ADM.Due_Diligence, '')))) 
			WHEN 'N' THEN 'No'
			WHEN 'Y' THEN 'Yes'
			ELSE 'No' 
		END AS Due_Diligence,
		C.Category_Name
		
		FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Pushback ADP On AD.Acq_Deal_Code = ADP.Acq_Deal_Code
		INNER JOIN Acq_Deal_Pushback_Title ADPT On ADP.Acq_Deal_Pushback_Code = ADPT.Acq_Deal_Pushback_Code 
		INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
		LEFT JOIN Party_Group PG ON v.Party_Group_Code = PG.Party_Group_Code
		INNER JOIN Deal_Tag TG On AD.Deal_Tag_Code = TG.Deal_Tag_Code
		INNER JOIN Title T On ADPT.Title_Code = T.title_code
		LEFT JOIN Program P on T.Program_Code = P.Program_Code
		LEFT JOIN Language L on T.Title_Language_Code = L.language_code
		LEFT JOIN Acq_Deal_Movie ADM on ADPT.Title_Code = ADM.Title_Code AND ADPT.Episode_From = ADM.Episode_Starts_From AND ADPT.Episode_To = ADM.Episode_End_To AND ADM.Acq_Deal_Code = AD.Acq_Deal_Code
		INNER JOIN Category C ON AD.Category_Code = C.Category_Code
		WHERE  
		AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
		(((ISNULL(CONVERT(date,ADP.Right_Start_Date,103),'') >= CONVERT(date,@Start_Date,103)OR @Start_Date = ''  )AND (ISNULL(CONVERT(date,ADP.Right_Start_Date,103),'') <= CONVERT(date,@End_Date,103)OR @End_Date = ''))
		AND ((CONVERT(date,ISNULL(ADP.Right_End_Date,'9999-12-31'),103)<=  CONVERT(date,@End_Date,103) OR @End_Date = ''  ) AND (CONVERT(date,ISNULL(ADP.Right_End_Date,'9999-12-31'),103) >= CONVERT(date,@Start_Date,103)OR @Start_Date = ''  )))
		AND AD.Agreement_No like '%' + @Agreement_No + '%' 
		AND (AD.Is_Master_Deal = @Is_Master_Deal Or @Is_Master_Deal = '')
		AND (AD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
		AND (AD.Business_Unit_Code = CAST(@Business_Unit_code AS INT)OR CAST(@Business_Unit_code AS INT) = 0)
		AND (@Title_Name = '' OR ADPT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Name,',')))
	END

	IF(@IsDealSegment = 'Y')
		BEGIN
			
			DELETE tadlr FROM #TEMP_Acquition_Deal_List_Report tadlr
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
			WHERE AD.Deal_Segment_Code <> @DealSegment AND @DealSegment > 0
				
			UPDATE tadlr
			SET Deal_Segment = DS.Deal_Segment_Name
			FROM #TEMP_Acquition_Deal_List_Report tadlr
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
			INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = AD.Deal_Segment_Code
		END


	SELECT DISTINCT 
	CASE
		WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'Y' THEN  TEMP_ADLR.Title_Name
		ELSE DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(TEMP_ADLR.Deal_Type_Code), TEMP_ADLR.Title_Name, TEMP_ADLR.Episode_From, TEMP_ADLR.Episode_To)		
	END AS Title_Name,

	CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Director END AS Director,
	CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Star_Cast END AS Star_Cast,
	CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Genre END AS Genre,
	CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Title_Language END AS Title_Language,
	CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN NULL ELSE TEMP_ADLR.year_of_production END AS Year_Of_Production,
	TEMP_ADLR.Agreement_No AS Agreement_No, 
	TEMP_ADLR.Deal_Description AS Deal_Description, 
	TEMP_ADLR.Reference_No AS Reference_No, 
	TEMP_ADLR.Is_Master_Deal, 
	TEMP_ADLR.Agreement_Date AS Agreement_Date, TEMP_ADLR.Deal_Tag_Description AS Deal_Tag_Description, 
	TEMP_ADLR.Deal_Segment, 
	TEMP_ADLR.Party AS Party, Temp_ADLR.Party_Master,
	CASE WHEN Is_PushBack = 'N' THEN TEMP_ADLR.Platform_Name ELSE '--' END AS Platform_Name, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_Start_Date ELSE NULL END AS Rights_Start_Date, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_End_Date ELSE NULL END AS Rights_End_Date, 
	TEMP_ADLR.Is_Title_Language_Right,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Country_Territory_Name ELSE '--' END AS Country_Territory_Name,
	TEMP_ADLR.Is_Exclusive AS Is_Exclusive, 
	CASE LTRIM(RTRIM(TEMP_ADLR.Subtitling)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_ADLR.Subtitling)) END AS Subtitling, 
	CASE LTRIM(RTRIM(TEMP_ADLR.Dubbing)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_ADLR.Dubbing)) END AS Dubbing, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Sub_Licencing ELSE '--' END AS Sub_Licencing,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Is_Tentative ELSE '--' END AS Is_Tentative,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' AND TEMP_ADLR.Is_ROFR = 'Y' THEN TEMP_ADLR.First_Refusal_Date ELSE NULL END AS First_Refusal_Date,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Restriction_Remarks ELSE '--' END AS Restriction_Remarks,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Holdback_Platform ELSE '--' END AS Holdback_Platform,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Holdback_Rights ELSE '--' END AS Holdback_Rights,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Blackout ELSE '--' END AS Blackout,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.General_Remark ELSE '--' END AS General_Remark,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Rights_Remarks ELSE '--' END AS Rights_Remarks,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Payment_Remarks ELSE '--' END AS Payment_Remarks,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_Type ELSE '--' END AS Right_Type,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_Term ELSE '--' END AS Term,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Is_Tentative ELSE '--' END AS Pushback_Is_Tentative, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Platform_Name ELSE '--' END AS Pushback_Platform_Name, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Right_Start_Date ELSE NULL END AS Pushback_Start_Date, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Right_End_Date ELSE NULL END AS Pushback_End_Date, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Country_Territory_Name ELSE '--' END AS Pushback_Country_Name, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Rights_Remarks ELSE '--' END AS Pushback_Remark, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Right_Term ELSE '--' END AS Pushback_Term,
	TEMP_ADLR.Deal_Workflow_Status AS Deal_Workflow_Status, 
	TEMP_ADLR.Is_PushBack AS Is_PushBack,
	TEMP_ADLR.Run_Type AS Run_Type,
	TEMP_ADLR.Is_Attachment As Is_Attachment,
	TEMP_ADLR.[Program_Name] As [Program_Name],
	(SELECT Deal_Type_Name FROM Deal_Type AS DT WHERE DT.Deal_Type_Code=TEMP_ADLR.Deal_Type_Code) AS Deal_Type,
	TEMP_ADLR.Promtoer_Group AS Promoter_Group_Name,
	TEMP_ADLR.Promtoer_Remarks AS Promoter_Remarks_Name,
	TEMP_ADLR.Due_Diligence,
	TEMP_ADLR.Category_Name
	INTO #TempAcqDealListReport
	FROM #TEMP_Acquition_Deal_List_Report TEMP_ADLR
	LEFT JOIN Acq_Deal_Movie ADM ON TEMP_ADLR.Master_Deal_Movie_Code_ToLink = ADM.Acq_Deal_Movie_Code
	--LEFT JOIN Title T on ADM.Title_Code = T.Title_Code
	ORDER BY TEMP_ADLR.Agreement_No, TEMP_ADLR.Is_Pushback


		SELECT 
			@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'ReferenceNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'DealType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'Party' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'Director' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'starCast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			@Col_Head13 = CASE WHEN  SM.Message_Key = 'Genres' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			@Col_Head14 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			@Col_Head15 = CASE WHEN  SM.Message_Key = 'ReleaseYear' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			@Col_Head16 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			@Col_Head17 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			@Col_Head18 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			@Col_Head19 = CASE WHEN  SM.Message_Key = 'Tentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			@Col_Head20 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			@Col_Head21 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			@Col_Head22 = CASE WHEN  SM.Message_Key = 'Exclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			@Col_Head23 = CASE WHEN  SM.Message_Key = 'TitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			@Col_Head24 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			@Col_Head25 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
			@Col_Head26 = CASE WHEN  SM.Message_Key = 'Sublicensing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
			@Col_Head27 = CASE WHEN  SM.Message_Key = 'ROFR' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END,
			@Col_Head28 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head28 END,
			@Col_Head29 = CASE WHEN  SM.Message_Key = 'RightsHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head29 END,
			@Col_Head30 = CASE WHEN  SM.Message_Key = 'RightsHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head30 END,
			@Col_Head31 = CASE WHEN  SM.Message_Key = 'Blackout' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head31 END,
			@Col_Head32 = CASE WHEN  SM.Message_Key = 'RightsRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head32 END,
			@Col_Head33 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head33 END,
 			@Col_Head34 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head34 END,
			@Col_Head35 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head35 END,
			@Col_Head36 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head36 END,
			@Col_Head37 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head37 END,
			@Col_Head38 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackCountry' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head38 END,
			@Col_Head39 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head39 END,
			@Col_Head40 = CASE WHEN  SM.Message_Key = 'GeneralRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head40 END,
			@Col_Head41 = CASE WHEN  SM.Message_Key = 'Paymenttermsconditions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head41 END,
			@Col_Head42 = CASE WHEN  SM.Message_Key = 'WorkflowStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head42 END,
			@Col_Head43 = CASE WHEN  SM.Message_Key = 'RunType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head43 END,
			@Col_Head44 = CASE WHEN  SM.Message_Key = 'Attachment' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head44 END,
			@Col_Head45 = CASE WHEN  SM.Message_Key = 'SelfUtilizationGroup' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head45 END,
			@Col_Head46 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head46 END,
			@Col_Head47 = CASE WHEN  SM.Message_Key = 'DueDiligence' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head47 END,
			@Col_Head48 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head48 END,
			@Col_Head49 = CASE WHEN  SM.Message_Key = 'PartyMasterName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head49 END,
			@Col_Head50 = 'Deal Segment'

		 FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('AgreementNo','TitleType','DealDescription','ReferenceNo','DealType','AgreementDate','Status','Party','PartyMasterName','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
		 'Tentative','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
		 ,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks','DueDiligence','CategoryName')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

		IF EXISTS(SELECT TOP 1 * FROM #TempAcqDealListReport)
		BEGIN
			SELECT 
				 [Agreement_No] ,
				 [Title Type], [Deal Description], [Reference No], [Deal Type]
				 , [Agreement Date], [Status], [Deal Segment], [Party],[Party_Master], [Program], [Title], [Director]
				 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
				 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
				 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
				 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks], [Due Diligence],[Category_Name]
			FROM (
			    
			SELECT
				sorter = 1,
				CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], 
				CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No], CAST([Is_Master_Deal] AS NVARCHAR(MAX)) As [Deal Type],
				CONVERT(VARCHAR(12),[Agreement_Date],103) As [Agreement Date], CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status], CAST([Deal_Segment] AS NVARCHAR(MAX)) As [Deal Segment], CAST([Party] AS NVARCHAR(MAX)) As [Party], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
				CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(VARCHAR(12),[Rights_Start_Date],103) AS [Rights Start Date], 
				CONVERT(VARCHAR(12),[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
				CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CAST([First_Refusal_Date] AS NVARCHAR(MAX)) As [ROFR],
				CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
				CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], CONVERT(VARCHAR(12),[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(VARCHAR(12),[Pushback_End_Date],103) As [Reverse Holdback End Date],
				CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
				CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
				CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks],  CAST([Due_Diligence] AS NVARCHAR(MAX)) As [Due Diligence], CAST([Category_Name] AS NVARCHAR(MAX)) AS [Category_Name],Cast([Party_Master] AS NVARCHAR(MAX)) AS Party_Master
			From #TempAcqDealListReport
			UNION ALL
				SELECT CAST(0 AS Varchar(100)), @Col_Head01, 
				@Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head50, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
				, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  @Col_Head16, @Col_Head17, @Col_Head18, @Col_Head19,'', @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, @Col_Head26
				, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, @Col_Head33, @Col_Head34, @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
				, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45, @Col_Head46, @Col_Head47,@Col_Head48,@Col_Head49
			) X   
			ORDER BY Sorter
		END
		ELSE 
		BEGIN
			SELECT * FROM #TempAcqDealListReport
		END

	IF OBJECT_ID('tempdb..#TEMP_Acquition_Deal_List_Report') IS NOT NULL DROP TABLE #TEMP_Acquition_Deal_List_Report
	IF OBJECT_ID('tempdb..#TempAcqDealListReport') IS NOT NULL DROP TABLE #TempAcqDealListReport
END
