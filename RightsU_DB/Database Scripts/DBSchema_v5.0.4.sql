--///////////////// FILE DB SCHEMA v5.0.3.1

GO
PRINT N'Altering [dbo].[USP_Syndication_Deal_List_Report]...';


GO
ALTER Procedure [dbo].[USP_Syndication_Deal_List_Report]
(
	@Agreement_No Varchar(100), 
	@Start_Date Varchar(30), 
	@End_Date Varchar(30), 
	@Deal_Tag_Code Int, 
	@Title_Codes Varchar(100), 
	@Business_Unit_code VARCHAR(100), 
	@Is_Pushback Varchar(100),
	@IS_Expired Varchar(100),
	@IS_Theatrical varchar(100),
	@SysLanguageCode INT,
	@DealSegment INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date:	18 Feb 2015
-- Description:	Get Syndication Deal List Report Data
-- =============================================
BEGIN
	--DECLARE   
	--@Agreement_No Varchar(100)
	--, @Is_Master_Deal Varchar(2)
	--, @Start_Date Varchar(30)
	--, @End_Date Varchar(30)
	--, @Deal_Tag_Code Int
	--, @Title_Codes Varchar(100)
	--, @Business_Unit_code INT
	--, @Is_Pushback Varchar(100)
	--, @IS_Expired Varchar(100)
	--, @IS_Theatrical varchar(100)
	--, @SysLanguageCode INT
	--, @DealSegment INT
	
	--SET @Agreement_No = ''
	--SET @Start_Date= ''
	--SET @End_Date = ''
	--SET @Deal_Tag_Code = 0
	--SET @Title_Codes = ''
	--SET @Business_Unit_code = 5
	--SET @Is_Pushback = 'N'
	--SET @IS_Expired  = 'N'
	--SET @IS_Theatrical='N'
	--SET @SysLanguageCode = 1
	--SET @DealSegment = 0
	
	if CHARINDEX(',',@Business_Unit_code) > 0
	begin
	   set @Business_Unit_code = 0
	end
      
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
	@Col_Head50 NVARCHAR(MAX) = '',
	@Col_Head51 NVARCHAR(MAX) = ''

	BEGIN
		IF OBJECT_ID('tempdb..#TEMP_Syndication_Deal_List_Report') IS NOT NULL
		DROP TABLE #TEMP_Syndication_Deal_List_Report

		IF OBJECT_ID('tempdb..#TempSynDealListReport') IS NOT NULL
		DROP TABLE #TempSynDealListReport

		IF OBJECT_ID('tempdb..#AncData') IS NOT NULL
		DROP TABLE #AncData
		
		IF OBJECT_ID('tempdb..#RightTable') IS NOT NULL
		DROP TABLE #RightTable
		
		IF OBJECT_ID('tempdb..#PlatformTable') IS NOT NULL
		DROP TABLE #PlatformTable

		IF OBJECT_ID('tempdb..#RegionTable') IS NOT NULL
		DROP TABLE #RegionTable

		IF OBJECT_ID('tempdb..#LangTable') IS NOT NULL
		DROP TABLE #LangTable

		IF OBJECT_ID('tempdb..#RegionSubDubTable') IS NOT NULL
		DROP TABLE #RegionSubDubTable
		
		IF OBJECT_ID('tempdb..#TitleTable') IS NOT NULL
		DROP TABLE #TitleTable

		IF OBJECT_ID('tempdb..#DealTitleTable') IS NOT NULL
		DROP TABLE #DealTitleTable
	END

	BEGIN
		CREATE TABLE #RightTable(
			Syn_Deal_Code INT,
			Syn_Deal_Rights_Code INT,
			Platform_Codes NVARCHAR(MAX),
			Region_Codes NVARCHAR(MAX),
			SL_Codes NVARCHAR(MAX),
			DB_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX),
			Region_Name NVARCHAR(MAX),
			Subtitle NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			RunType NVARCHAR(MAX),
			RGType VARCHAR(10),
			SLType VARCHAR(10),
			DBType VARCHAR(10),
			Run_Type VARCHAR(100)
		)
		CREATE TABLE #PlatformTable(
			Platform_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX)
		)
		CREATE TABLE #RegionTable(
			Region_Codes NVARCHAR(MAX),
			Region_Names NVARCHAR(MAX),
			Region_Type NVARCHAR(10)
		)
		CREATE TABLE #LangTable(
			Lang_Codes NVARCHAR(MAX),
			Lang_Names NVARCHAR(MAX),
			Lang_Type NVARCHAR(10)
		)		
		CREATE TABLE #TitleTable(
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Director NVARCHAR(MAX),
			StarCast NVARCHAR(MAX),
			Genre NVARCHAR(MAX)
		)
		CREATE TABLE #DealTitleTable(
			Syn_Deal_Code INT,
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Run_Type VARCHAR(10)
		)
		CREATE TABLE #TEMP_Syndication_Deal_List_Report(
			Syn_Deal_Right_Code VARCHAR(100),
			Business_Unit_Name NVARCHAR(MAX),
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Episode_From INT,
			Episode_To INT,
			Deal_Type_Code INT,
			Director NVARCHAR(MAX),
			Star_Cast NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			Title_Language NVARCHAR(MAX),
			year_of_production INT,
			Syn_Deal_code INT,
			Agreement_No VARCHAR(MAX),
			Deal_Description NVARCHAR(MAX),
			Reference_No NVARCHAR(MAX),
			Agreement_Date DATETIME,
			Deal_Tag_Code INT,
			Deal_Tag_Description NVARCHAR(MAX),
			Party NVARCHAR(MAX),
			Party_Master NVARCHAR(MAX),
			Platform_Name NVARCHAR(MAX),
			Right_Start_Date DATETIME, 
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Territory_Name NVARCHAR(MAX),
			Is_Exclusive CHAR(1),
			Subtitling NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Sub_Licencing VARCHAR(MAX),
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
			Run_Type CHAR(9),
			Is_Attachment CHAR(3),
			[Program_Name] NVARCHAR(MAX),
			Promtoer_Group NVARCHAR(MAX),
			Promtoer_Remarks NVARCHAR(MAX),
			Deal_Segment NVARCHAR(MAX),
			Revenue_Vertical NVARCHAR(MAX),
			Category_Name VARCHAR(MAX)
			
		)
	END

	DECLARE @IsDealSegment VARCHAR(100), @IsRevenueVertical VARCHAR(100)
	SELECT @IsDealSegment = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Deal_Segment' 
	SELECT @IsRevenueVertical = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Revenue_Vertical' 

	BEGIN
		INSERT INTO #TEMP_Syndication_Deal_List_Report
		(
			Syn_Deal_Right_Code
			,Business_Unit_Name
			,Title_Code
			,Title_Name
			,Episode_From,Episode_To,Deal_Type_Code
			,Director, Star_Cast ,Genre
			, Title_Language, year_of_production, Syn_Deal_code 
			,Deal_Description, Reference_No, Agreement_No, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party, Party_Master
			,Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right
			,Country_Territory_Name
			,Is_Exclusive
			,Subtitling
			,Dubbing
			,Sub_Licencing
			,Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks
			,Holdback_Platform
			,Holdback_Rights 
			,Blackout
			,General_Remark, Rights_Remarks, Payment_Remarks, Right_Type
			,Right_Term
			,Deal_Workflow_Status
			,Is_Pushback
			,Run_Type
			,Is_Attachment
			,[Program_Name]
			,Promtoer_Group
			,Promtoer_Remarks
			,Category_Name
		)
		SELECT 
			SDR.Syn_Deal_Rights_Code
			,BU.Business_Unit_Name
			,T.Title_Code
			,T.Title_Name
			,CAST(SDRT.Episode_From AS INT),SDRT.Episode_To,SD.Deal_Type_Code 
			--, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director
			--, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast
			--, dbo.UFN_Get_Title_Genre(t.title_code) Genre
			,'' AS Director
			,'' AS Star_Cast
			,'' AS Genre
			, ISNULL(L.language_name, '') AS Title_Language, t.year_of_production, SD.Syn_Deal_Code
			, SD.Deal_Description, SD.Ref_No, SD.Agreement_No, CAST(SD.Agreement_Date as date), SD.Deal_Tag_Code, TG.Deal_Tag_Description, V.Vendor_Name,PG.Party_Group_Name
			--, [dbo].[UFN_Get_Platform_Name](SDR.Syn_Deal_Rights_Code, 'SR') Platform_Name
			,'' AS Platform_Name
			, CAST(SDR.Right_Start_Date as date), CAST(SDR.Right_End_Date as date), SDR.Is_Title_Language_Right
			--,CASE (DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '',''))
			--	WHEN '' THEN DBO.UFN_Get_Rights_Territory(SDR.Syn_Deal_Rights_Code, '')
			--	ELSE DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '','')
			-- END AS  Country_Territory_Name
			,'' AS  Country_Territory_Name
			,SDR.Is_Exclusive AS Is_Exclusive
			--, DBO.UFN_Get_Rights_Subtitling(SDR.Syn_Deal_Rights_Code, '') Subtitling
			--,DBO.UFN_Get_Rights_Dubbing(SDR.Syn_Deal_Rights_Code, '') Dubbing
			,'' AS Subtitling
			,'' AS Dubbing
			,CASE LTRIM(RTRIM(SDR.Is_Sub_License))
				WHEN 'Y' THEN SL.Sub_License_Name
				ELSE 'No Sub Licensing'
			 END SubLicencing
			, SDR.Is_Tentative, SDR.Is_ROFR, SDR.ROFR_Date AS First_Refusal_Date, SDR.Restriction_Remarks AS Restriction_Remarks
			, [dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](SDR.Syn_Deal_Rights_Code, 'SR','P') Holdback_Platform
			, [dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](SDR.Syn_Deal_Rights_Code, 'SR','R') Holdback_Right
			--, [dbo].[UFN_Get_Blackout_Period](SDR.Syn_Deal_Rights_Code, 'SR') Blackout
			--,'' as Holdback_Platform
			--,'' as Holdback_Right
			,'' as Blackout
			, SD.Remarks AS General_Remark, SD.Rights_Remarks AS Rights_Remarks, SD.Payment_Terms_Conditions AS Payment_Remarks, SDR.Right_Type
			, CASE SDR.Right_Type
				WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](SDR.Right_Start_Date, Right_End_Date, Term) 
				WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
				WHEN 'U' THEN 'Perpetuity'
			 END Right_Term
			,CASE UPPER(LTRIM(RTRIM(ISNULL(SD.Deal_Workflow_Status, '')))) 
				WHEN 'N' THEN 'Created'
				WHEN 'W' THEN 'Sent for authorization'
				WHEN 'A' THEN 'Approved' 
				WHEN 'R' THEN 'Declined'
				WHEN 'AM' THEN 'Amended'
				ELSE Deal_Workflow_Status 
			 END AS Deal_Workflow_Status
			,ISNULL(SDR.Is_Pushback, 'N')
			, '' AS Run_Type --[dbo].[UFN_Get_Run_Type] (SD.Syn_Deal_Code,@Title_Codes) AS Run_Type
			,CASE WHEN (SELECT count(*) FROM Syn_Deal_Attachment SDT WHERE SDT.Syn_Deal_Code = SD.Syn_Deal_Code) > 0 THEN 'Yes'
					   ELSE 'No'
			 END AS Is_Attachment
			, P.Program_Name as Program_Name
			, dBO.UFN_Get_Rights_Promoter_Group_Remarks(SDR.Syn_Deal_Rights_Code,'P','S') as Promoter_Group_Name
			, dBO.UFN_Get_Rights_Promoter_Group_Remarks(SDR.Syn_Deal_Rights_Code,'R','S') as Promoter_Remarks_Name
			, C.Category_Name AS Category_Name
		FROM Syn_Deal SD
			INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
			INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C'
			INNER JOIN Syn_Deal_Rights_Process_Validation SDRTV ON SDRTV.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND LTRIM(RTRIM(SDRTV.Status)) = 'D'
			INNER JOIN Syn_Deal_Rights_Title SDRT On SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code 
			INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
			LEFT JOIN Party_Group PG ON V.Party_Group_Code = PG.Party_Group_Code
			LEFT JOIN Sub_License SL ON SDR.Sub_License_Code = SL.Sub_License_Code
			INNER JOIN Deal_Tag TG On SD.Deal_Tag_Code = TG.Deal_Tag_Code
			INNER JOIN Title T On SDRT.Title_Code = T.title_code
			LEFT JOIN Program P on T.Program_Code = P.Program_Code
			LEFT JOIN Language L on T.Title_Language_Code = L.language_code
			INNER JOIN Category C ON SD.Category_Code = C.Category_Code
		WHERE  
			((@IS_Theatrical = 'Y' AND @IS_Theatrical = SDR.Is_Theatrical_Right) OR (@IS_Theatrical <> 'Y')) AND 
			--sdr.Is_Theatrical_Right = @IS_Theatrical  And
			(ISNULL(CONVERT(datetime,SDR.Right_Start_Date,1) , '') >= CONVERT(datetime,@Start_Date,1) OR CONVERT(datetime,@Start_Date,1) = '')		
			AND (ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), '') <= CONVERT(datetime,@End_Date,1) OR CONVERT(datetime,@End_Date,1) = '')
			AND SD.Agreement_No like '%' + @Agreement_No + '%' 
			AND (ISNULL(SDR.Is_Pushback, 'N') = @Is_Pushback OR @Is_Pushback = '')
			AND (SD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
			--AND(@Business_Unit_code = '' OR SD.Business_Unit_Code in(select number from fn_Split_withdelemiter(@Title_Codes,',')))
			AND (SD.Business_Unit_Code = CAST(@Business_Unit_code AS INT) OR CAST(@Business_Unit_code AS INT) = 0)
			AND (@Title_Codes = '' OR SDRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Codes,',')))
			AND (SDR.Syn_Deal_Rights_Code In 
			(SELECT SDRP.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Platform SDRP 
			Inner Join [Platform] P ON SDRP.Platform_Code = P.Platform_Code AND P.Applicable_For_Demestic_Territory = @IS_Theatrical 
			AND @IS_Theatrical = 'Y'
			) OR @IS_Theatrical = 'N')
			AND (@IS_Expired ='Y' OR (ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), GETDATE()) >= GETDATE() AND @IS_Expired ='N'))
	END

	BEGIN
		INSERT INTO #RightTable(Syn_Deal_Code,Syn_Deal_Rights_Code,Platform_Codes,Platform_Names,Region_Name,Subtitle,Dubbing,RunType)
		SELECT Syn_Deal_Code,Syn_Deal_Right_Code,null,null,null,null,null,null  FROM #TEMP_Syndication_Deal_List_Report

		INSERT INTO #TitleTable(Title_Code,Eps_From,Eps_To,Director,StarCast,Genre)
		Select DISTINCT Title_Code,Episode_From,Episode_To,null,null,null FROM #TEMP_Syndication_Deal_List_Report

		INSERT INTO #DealTitleTable(Syn_Deal_Code,Title_Code,Eps_From,Eps_To,Run_Type)
		SELECT DISTINCT Syn_Deal_code,Title_Code,Episode_From,Episode_To,null FROM #TEMP_Syndication_Deal_List_Report
	END


	
	BEGIN
		IF(@IsDealSegment = 'Y' )
		BEGIN
			DELETE tsdlr FROM #TEMP_Syndication_Deal_List_Report tsdlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tsdlr.Syn_Deal_Code
			WHERE AD.Deal_Segment_Code <> @DealSegment AND @DealSegment > 0

			UPDATE tadlr
			SET Deal_Segment = DS.Deal_Segment_Name
			FROM #TEMP_Syndication_Deal_List_Report tadlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tadlr.Syn_Deal_Code
			INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = AD.Deal_Segment_Code

		END

		IF(@IsRevenueVertical = 'Y')
		BEGIN
			UPDATE tadlr
			SET Revenue_Vertical = DS.Revenue_Vertical_Name
			FROM #TEMP_Syndication_Deal_List_Report tadlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tadlr.Syn_Deal_Code
			INNER JOIN Revenue_Vertical DS ON DS.Revenue_Vertical_Code = AD.Revenue_Vertical_Code
		END
		

		
		PRINT 'Director, StartCast Insert and update for Primary Rights'
			
		UPDATE TT SET TT.Director = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 1),TT.StarCast = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 2),TT.Genre = dbo.UFN_Get_Title_Genre(TT.TItle_Code)  
		FROM #TitleTable TT
	
		UPDATE TADLR SET TADLR.Director = TT.Director,TADLR.Star_Cast = TT.StarCast,TADLR.Genre = TT.Genre
		FROM #TEMP_Syndication_Deal_List_Report TADLR
		INNER JOIN #TitleTable TT ON TADLR.Title_Code = TT.Title_Code AND TADLR.Episode_From = TT.Eps_From AND TADLR.Episode_To = Eps_To
	
		PRINT 'Platform Insert and update for Primary Rights'
		
		UPDATE RT SET RT.Platform_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(AADRP.Platform_Code AS NVARCHAR(MAX)) from  Syn_Deal_Rights_Platform AADRP 
		WHERE  AADRP.Syn_Deal_Rights_Code = RT.Syn_Deal_Rights_Code  --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		INSERT INTO #PlatformTable(Platform_Codes,Platform_Names)
		SELECT DISTINCT Platform_Codes,Platform_Names FROM #RightTable
		
		UPDATE PT SET PT.Platform_Names = a.Platform_Hierarchy
		from #PlatformTable PT
		CROSS APPLY  [dbo].[UFN_Get_Platform_Hierarchy_WithNo](Platform_Codes) a
		WHERE Platform_Codes IS NOT NULL
	
		UPDATE RT SET RT.Platform_Names = PT.Platform_Names
		FROM #RightTable RT
		INNER JOIN #PlatformTable PT ON RT.Platform_Codes = PT.Platform_Codes
	
		UPDATE TADLR SET TADLR.Platform_Name = RT.Platform_Names
		FROM #TEMP_Syndication_Deal_List_Report TADLR 
		INNER JOIN #RightTable RT ON TADLR.Syn_Deal_Right_Code = RT.Syn_Deal_Rights_Code
	
		PRINT 'Region,Subtitle,Dubbing Insert and update for Primary Rights'
	
		UPDATE RT SET RT.Region_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRP.Country_Code IS NULL THEN AADRP.Territory_Code ELSE AADRP.Country_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Territory AADRP 
		WHERE RT.Syn_Deal_Rights_Code = AADRP.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		UPDATE RT SET RT.RGType = ADRT.Territory_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Territory ADRT ON RT.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code 

		UPDATE RT SET RT.SL_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRS.Language_Code IS NULL THEN AADRS.Language_Group_Code ELSE AADRS.Language_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Subtitling AADRS 
		WHERE RT.Syn_Deal_Rights_Code = AADRS.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,''),
		RT.DB_Codes =
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRD.Language_Code IS NULL THEN AADRD.Language_Group_Code ELSE AADRD.Language_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Dubbing AADRD 
		WHERE RT.Syn_Deal_Rights_Code = AADRD.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		UPDATE RT SET RT.SLType = ADRS.Language_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Subtitling ADRS ON RT.Syn_Deal_Rights_Code = ADRS.Syn_Deal_Rights_Code 
	
		UPDATE RT SET RT.DBType = ADRD.Language_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Dubbing ADRD ON RT.Syn_Deal_Rights_Code = ADRD.Syn_Deal_Rights_Code 
	
		INSERT INTO #RegionTable(Region_Codes,Region_Names,Region_Type)
		SELECT DISTINCT Region_Codes,NULL,RGType FROM #RightTable
	
		INSERT INTO #LangTable(Lang_Codes,Lang_Names,Lang_Type)
		SELECT DISTINCT SL_Codes,NULL,SLType FROM #RightTable
		UNION
		SELECT DISTINCT DB_Codes,NULL,DBType FROM #RightTable
	
		UPDATE RT SET RT.Region_Names = CT.Criteria_Name FROM #RegionTable RT
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](RT.Region_Codes,RT.Region_Type,'RG') CT
	
		UPDATE LTB SET LTB.Lang_Names = LT.Criteria_Name FROM #LangTable LTB
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](LTB.Lang_Codes,LTB.Lang_Type,'SL') LT
	
		UPDATE RT SET RT.Region_Name = RTG.Region_Names FROM #RightTable RT
		INNER JOIN #RegionTable RTG ON RT.Region_Codes = RTG.Region_Codes AND RT.RGType = RTG.Region_Type
	
		UPDATE RT SET RT.Subtitle = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.SL_Codes = LTG.Lang_Codes AND RT.SLType = LTG.Lang_Type
	
		UPDATE RT SET RT.Dubbing = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.DB_Codes = LTG.Lang_Codes AND RT.DBType = LTG.Lang_Type
	
		UPDATE TADLR SET TADLR.Country_Territory_Name = RT.Region_Name
		,TADLR.Subtitling = ISNULL(RT.Subtitle,''),TADLR.Dubbing = ISNULL(RT.Dubbing,'') FROM #TEMP_Syndication_Deal_List_Report TADLR
		INNER JOIN #RightTable RT ON TADLR.Syn_Deal_Right_Code = RT.Syn_Deal_Rights_Code
		
	
	END

	BEGIN
		SELECT DISTINCT 
		DBO.UFN_GetTitleNameInFormat( dbo.UFN_GetDealTypeCondition(TEMP_SDLR.Deal_Type_Code), TEMP_SDLR.Title_Name, TEMP_SDLR.Episode_From, TEMP_SDLR.Episode_To) AS Title_Name,
		TEMP_SDLR.Director AS Director,
		TEMP_SDLR.Star_Cast AS Star_Cast,
		TEMP_SDLR.Genre AS Genre,
		TEMP_SDLR.Title_Language AS Title_Language,
		TEMP_SDLR.year_of_production AS Year_Of_Production,
		TEMP_SDLR.Agreement_No AS Agreement_No, 
		TEMP_SDLR.Deal_Description AS Deal_Description, 
		TEMP_SDLR.Reference_No AS Reference_No, 
		TEMP_SDLR.Agreement_Date AS Agreement_Date, TEMP_SDLR.Deal_Tag_Description AS Deal_Tag_Description, 
		TEMP_SDLR.Deal_Segment,
		TEMP_SDLR.Revenue_Vertical,
		TEMP_SDLR.Party AS Party, TEMP_SDLR.Party_Master AS Party_Master,
		CASE WHEN Is_PushBack = 'N' THEN TEMP_SDLR.Platform_Name ELSE '--' END AS Platform_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Start_Date ELSE NULL END AS Rights_Start_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_End_Date ELSE NULL END AS Rights_End_Date, 
		TEMP_SDLR.Is_Title_Language_Right,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Country_Territory_Name ELSE '--' END AS Country_Territory_Name,
		TEMP_SDLR.Is_Exclusive AS Is_Exclusive, 
		CASE LTRIM(RTRIM(TEMP_SDLR.Subtitling)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_SDLR.Subtitling)) END AS Subtitling, 
		CASE LTRIM(RTRIM(TEMP_SDLR.Dubbing)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_SDLR.Dubbing)) END AS Dubbing, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Sub_Licencing ELSE '--' END AS Sub_Licencing,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Is_Tentative ELSE '--' END AS Is_Tentative,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' AND TEMP_SDLR.Is_ROFR = 'Y' THEN TEMP_SDLR.First_Refusal_Date ELSE NULL END AS First_Refusal_Date,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Restriction_Remarks ELSE '--' END AS Restriction_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Holdback_Platform ELSE '--' END AS Holdback_Platform,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Holdback_Rights ELSE '--' END AS Holdback_Rights,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Blackout ELSE '--' END AS Blackout,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.General_Remark ELSE '--' END AS General_Remark,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Rights_Remarks ELSE '--' END AS Rights_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Payment_Remarks ELSE '--' END AS Payment_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Type ELSE '--' END AS Right_Type,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Term ELSE '--' END AS Term,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Is_Tentative ELSE '--' END AS Pushback_Is_Tentative, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Platform_Name ELSE '--' END AS Pushback_Platform_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_Start_Date ELSE NULL END AS Pushback_Start_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_End_Date ELSE NULL END AS Pushback_End_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Country_Territory_Name ELSE '--' END AS Pushback_Country_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Restriction_Remarks ELSE '--' END AS Pushback_Remark, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_Term ELSE '--' END AS Pushback_Term,
		TEMP_SDLR.Deal_Workflow_Status AS Deal_Workflow_Status, 
		TEMP_SDLR.Is_PushBack AS Is_PushBack,
		TEMP_SDLR.Run_Type AS Run_Type,
		TEMP_SDLR.Is_Attachment AS Is_Attachment,
		TEMP_SDLR.[Program_Name] AS [Program_Name],
		(SELECT Deal_Type_Name FROM Deal_Type AS DT WHERE DT.Deal_Type_Code=TEMP_SDLR.Deal_Type_Code) AS Deal_Type,
		TEMP_SDLR.Promtoer_Group AS Promoter_Group_Name,
		TEMP_SDLR.Promtoer_Remarks AS Promoter_Remarks_Name,
		TEMP_SDLR.Category_Name,
		TEMP_SDLR.Business_Unit_Name
		INTO #TempSynDealListReport
		FROM #TEMP_Syndication_Deal_List_Report TEMP_SDLR
		ORDER BY TEMP_SDLR.Agreement_No, TEMP_SDLR.Is_Pushback
	END

	BEGIN
		SELECT 
			@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'ReferenceNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'Party' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'Director' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'starCast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'Genres' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			@Col_Head13 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			@Col_Head14 = CASE WHEN  SM.Message_Key = 'ReleaseYear' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			@Col_Head15 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			@Col_Head16 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			@Col_Head17 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			@Col_Head18 = CASE WHEN  SM.Message_Key = 'Tentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			@Col_Head19 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			@Col_Head20 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			@Col_Head21 = CASE WHEN  SM.Message_Key = 'Exclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			@Col_Head22 = CASE WHEN  SM.Message_Key = 'TitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			@Col_Head23 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			@Col_Head24 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			@Col_Head25 = CASE WHEN  SM.Message_Key = 'Sublicensing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
			@Col_Head26 = CASE WHEN  SM.Message_Key = 'ROFR' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
			@Col_Head27 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END,
			@Col_Head28 = CASE WHEN  SM.Message_Key = 'RightsHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head28 END,
			@Col_Head29 = CASE WHEN  SM.Message_Key = 'RightsHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head29 END,
			@Col_Head30 = CASE WHEN  SM.Message_Key = 'Blackout' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head30 END,
			@Col_Head31 = CASE WHEN  SM.Message_Key = 'RightsRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head31 END,
			@Col_Head32 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head32 END,
 			@Col_Head33 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head33 END,
			@Col_Head34 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head34 END,
			@Col_Head35 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head35 END,
			@Col_Head36 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head36 END,
			@Col_Head37 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackCountry' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head37 END,
			@Col_Head38 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head38 END,
			@Col_Head39 = CASE WHEN  SM.Message_Key = 'GeneralRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head39 END,
			@Col_Head40 = CASE WHEN  SM.Message_Key = 'Paymenttermsconditions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head40 END,
			@Col_Head41 = CASE WHEN  SM.Message_Key = 'WorkflowStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head41 END,
			@Col_Head42 = CASE WHEN  SM.Message_Key = 'RunType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head42 END,
			@Col_Head43 = CASE WHEN  SM.Message_Key = 'Attachment' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head43 END,
			@Col_Head44 = CASE WHEN  SM.Message_Key = 'SelfUtilizationGroup' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head44 END,
			@Col_Head45 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head45 END,
			@Col_Head47 = CASE WHEN  SM.Message_Key = 'PartyMasterName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head47 END,
			@Col_Head48 = 'Deal Segment',
			@Col_Head49 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head49 END,
			@Col_Head50 = 'Revenue Vertical',
			@Col_Head51 = 'Business Unit Name'

		 FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('AgreementNo','TitleType','DealDescription','ReferenceNo','AgreementDate','Status','Party','PartyMasterName','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
		 'Tentative','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
		 ,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks','CategoryName')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

		 IF EXISTS(SELECT TOP 1 * FROM #TempSynDealListReport)
		 BEGIN
			 SELECT 
					 [Agreement_No] , [Business Unit Name],
					 [Title Type], [Deal Description], [Reference No], [Agreement Date], [Status], [Deal Segment], [Revenue Vertical], [Party],[Party_Master], [Program], [Title], [Director]
					 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
					 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
					 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
					 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks],[Category_Name]
				FROM (
			 SELECT
					sorter = 1,
					CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], CAST(Business_Unit_Name AS VARCHAR(100))  AS [Business Unit Name] ,
					CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No],
					--CONVERT(VARCHAR(30),[Agreement_Date],103) As [Agreement Date],
					CONVERT(DATE, [Agreement_Date], 103) As [Agreement Date],
					CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status],
					CAST([Deal_Segment] AS NVARCHAR(MAX)) As [Deal Segment], CAST([Revenue_Vertical] AS NVARCHAR(MAX)) As [Revenue Vertical]
					, CAST([Party] AS NVARCHAR(MAX)) As [Party],CAST([Party_Master] AS NVARCHAR(MAX)) As [Party_Master], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
					CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(DATE,[Rights_Start_Date],103) AS [Rights Start Date], 
					CONVERT(DATE,[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
					CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CONVERT(DATE,[First_Refusal_Date] , 103) As [ROFR],
					CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
					CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], Convert(DATE,[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(DATE,[Pushback_End_Date],103) As [Reverse Holdback End Date],
					CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
					CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
					CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks], CAST([Category_Name] AS NVARCHAR(MAX)) AS [Category_Name]
				From #TempSynDealListReport
				UNION ALL
					SELECT CAST(0 AS Varchar(100)), @Col_Head01, @Col_Head51, 
					@Col_Head02, @Col_Head03, @Col_Head04, GETDATE() , @Col_Head06, @Col_Head48, @Col_Head50, @Col_Head07,@Col_Head47, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
					, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  GETDATE(), GETDATE(), @Col_Head18, 'Pushback', @Col_Head19, @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, GETDATE()
					, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, GETDATE(), GETDATE(), @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
					, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45,@Col_Head49
				) X   
			ORDER BY Sorter
		END
		ELSE
		BEGIN
			SELECT * FROM #TempSynDealListReport
		END

	END
END
GO
PRINT N'Altering [dbo].[USP_Title_Import_Utility_PIII]...';


GO
ALTER PROCEDURE [dbo].[USP_Title_Import_Utility_PIII]
(
	@DM_Master_Import_Code INT
)
AS 
BEGIN
	SET NOCOUNT ON
	--DECLARE @DM_Master_Import_Code INT = 49
	DECLARE @ISError CHAR(1) = 'N', @Error_Message NVARCHAR(MAX) = '', @ExcelCnt INT = 0

	IF(OBJECT_ID('tempdb..#TempTitle') IS NOT NULL) DROP TABLE #TempTitle
	IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
	IF(OBJECT_ID('tempdb..#TempExcelSrNo') IS NOT NULL) DROP TABLE #TempExcelSrNo
	IF(OBJECT_ID('tempdb..#TempHeaderWithMultiple') IS NOT NULL) DROP TABLE #TempHeaderWithMultiple
	IF(OBJECT_ID('tempdb..#TempTalent') IS NOT NULL) DROP TABLE #TempTalent
	IF(OBJECT_ID('tempdb..#TempExtentedMetaData') IS NOT NULL) DROP TABLE #TempExtentedMetaData
	IF(OBJECT_ID('tempdb..#TempResolveConflict') IS NOT NULL) DROP TABLE #TempResolveConflict
	IF(OBJECT_ID('tempdb..#TempDuplicateRows') IS NOT NULL) DROP TABLE #TempDuplicateRows
	IF(OBJECT_ID('tempdb..#TempDupTitleName') IS NOT NULL) DROP TABLE #TempDupTitleName
	
	CREATE TABLE #TempTitle(
		DM_Master_Import_Code INT,
		ExcelSrNo NVARCHAR(MAX),
		Col1 NVARCHAR(MAX),
		Col2 NVARCHAR(MAX),
		Col3 NVARCHAR(MAX),
		Col4 NVARCHAR(MAX),
		Col5 NVARCHAR(MAX),
		Col6 NVARCHAR(MAX),
		Col7 NVARCHAR(MAX),
		Col8 NVARCHAR(MAX),
		Col9 NVARCHAR(MAX),
		Col10 NVARCHAR(MAX),
		Col11 NVARCHAR(MAX),
		Col12 NVARCHAR(MAX),
		Col13 NVARCHAR(MAX),
		Col14 NVARCHAR(MAX),
		Col15 NVARCHAR(MAX),
		Col16 NVARCHAR(MAX),
		Col17 NVARCHAR(MAX),
		Col18 NVARCHAR(MAX),
		Col19 NVARCHAR(MAX),
		Col20 NVARCHAR(MAX),
		Col21 NVARCHAR(MAX),
		Col22 NVARCHAR(MAX),
		Col23 NVARCHAR(MAX),
		Col24 NVARCHAR(MAX),
		Col25 NVARCHAR(MAX),
		Col26 NVARCHAR(MAX),
		Col27 NVARCHAR(MAX),
		Col28 NVARCHAR(MAX),
		Col29 NVARCHAR(MAX),
		Col30 NVARCHAR(MAX),
		Col31 NVARCHAR(MAX),
		Col32 NVARCHAR(MAX),
		Col33 NVARCHAR(MAX),
		Col34 NVARCHAR(MAX),
		Col35 NVARCHAR(MAX),
		Col36 NVARCHAR(MAX),
		Col37 NVARCHAR(MAX),
		Col38 NVARCHAR(MAX),
		Col39 NVARCHAR(MAX),
		Col40 NVARCHAR(MAX),
		Col41 NVARCHAR(MAX),
		Col42 NVARCHAR(MAX),
		Col43 NVARCHAR(MAX),
		Col44 NVARCHAR(MAX),
		Col45 NVARCHAR(MAX),
		Col46 NVARCHAR(MAX),
		Col47 NVARCHAR(MAX),
		Col48 NVARCHAR(MAX),
		Col49 NVARCHAR(MAX),
		Col50 NVARCHAR(MAX),
		Col51 NVARCHAR(MAX),
		Col52 NVARCHAR(MAX),
		Col53 NVARCHAR(MAX),
		Col54 NVARCHAR(MAX),
		Col55 NVARCHAR(MAX),
		Col56 NVARCHAR(MAX),
		Col57 NVARCHAR(MAX),
		Col58 NVARCHAR(MAX),
		Col59 NVARCHAR(MAX),
		Col60 NVARCHAR(MAX),
		Col61 NVARCHAR(MAX),
		Col62 NVARCHAR(MAX),
		Col63 NVARCHAR(MAX),
		Col64 NVARCHAR(MAX),
		Col65 NVARCHAR(MAX),
		Col66 NVARCHAR(MAX),
		Col67 NVARCHAR(MAX),
		Col68 NVARCHAR(MAX),
		Col69 NVARCHAR(MAX),
		Col70 NVARCHAR(MAX),
		Col71 NVARCHAR(MAX),
		Col72 NVARCHAR(MAX),
		Col73 NVARCHAR(MAX),
		Col74 NVARCHAR(MAX),
		Col75 NVARCHAR(MAX),
		Col76 NVARCHAR(MAX),
		Col77 NVARCHAR(MAX),
		Col78 NVARCHAR(MAX),
		Col79 NVARCHAR(MAX),
		Col80 NVARCHAR(MAX),
		Col81 NVARCHAR(MAX),
		Col82 NVARCHAR(MAX),
		Col83 NVARCHAR(MAX),
		Col84 NVARCHAR(MAX),
		Col85 NVARCHAR(MAX),
		Col86 NVARCHAR(MAX),
		Col87 NVARCHAR(MAX),
		Col88 NVARCHAR(MAX),
		Col89 NVARCHAR(MAX),
		Col90 NVARCHAR(MAX),
		Col91 NVARCHAR(MAX),
		Col92 NVARCHAR(MAX),
		Col93 NVARCHAR(MAX),
		Col94 NVARCHAR(MAX),
		Col95 NVARCHAR(MAX),
		Col96 NVARCHAR(MAX),
		Col97 NVARCHAR(MAX),
		Col98 NVARCHAR(MAX),
		Col99 NVARCHAR(MAX),
		Col100 NVARCHAR(MAX)
	)

	CREATE TABLE #TempTitleUnPivot(
		ExcelSrNo NVARCHAR(MAX),
		ColumnHeader NVARCHAR(MAX),
		TitleData NVARCHAR(MAX),
		RefKey NVARCHAR(MAX),
		IsError CHAR(1),
		ErrorMessage NVARCHAR(MAX)
	)

	CREATE TABLE #TempExcelSrNo(
		ExcelSrNo NVARCHAR(MAX),
	)

	CREATE TABLE #TempHeaderWithMultiple(
		ExcelSrNo NVARCHAR(MAX),
		TitleCode INT,
		HeaderName NVARCHAR(MAX),
		PropName NVARCHAR(MAX),
		PropCode INT
	)

	CREATE TABLE #TempResolveConflict(
		[Name] NVARCHAR(MAX),
		Master_Type NVARCHAR(MAX),
		Master_Code INT,
		Roles NVARCHAR(MAX),
		Mapped_By CHAR(1)
	)

	CREATE TABLE #TempTalent(
		ExcelSrNo NVARCHAR(MAX),
		HeaderName NVARCHAR(MAX),
		TalentName NVARCHAR(MAX),
		TalentCode INT,
		RoleCode INT
	)

	CREATE TABLE #TempExtentedMetaData(
		ExcelSrNo NVARCHAR(MAX),
		Columns_Code INT,
		HeaderName NVARCHAR(MAX),
		EMDName NVARCHAR(MAX),
		EMDCode INT
	)

	CREATE TABLE #TempDupTitleName
	(
		ExcelSrNo NVARCHAR(MAX),
		Title_Name NVARCHAR(MAX),
		Title_Code INT,
		Title_Type NVARCHAR(MAX),
		Deal_Type_Code INT,
		IsError CHAR(1)
	)

	BEGIN TRY

	UPDATE DM_Title_Import_Utility_Data SET Error_Message = NULL, Is_Ignore = 'N', Record_Status = NULL 
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Col1 NOT LIKE '%Sr%' 

	PRINT 'Inserting Data into #TempTitle'
	INSERT INTO #TempTitle (DM_Master_Import_Code, ExcelSrNo, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99)  
	SELECT DM_Master_Import_Code, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100  
	FROM DM_Title_Import_Utility_Data  
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code

	PRINT 'Fetching duplicate EXCEL Sr No'
	UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Duplicate EXCEL Sr. No. Found', Is_Ignore = 'Y' --A.Record_Status = 'E', 
	FROM DM_Title_Import_Utility_Data A
	WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
	AND A.Col1 COLLATE Latin1_General_CI_AI in (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DELETE FROM #TempTitle WHERE 
	ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DECLARE @Mandatory_message NVARCHAR(MAX)
	SELECT @Mandatory_message = STUFF(( SELECT ', ' + Display_Name +' is Mandatory Field' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		

	SELECT B.Col1 as ExcelSrNo
	INTO #TempDuplicateRows
	FROM DM_Title_Import_Utility_Data B
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND B.Col1 NOT LIKE '%Sr%'
	AND B.Col1 IN (
		SELECT A.ExcelSrNo FROM
		(
			SELECT Col1 AS ExcelSrNo , CONCAT(Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50, Col51, Col52, Col53, Col54, Col55, Col56, Col57, Col58, Col59, Col60, Col61, Col62, Col63, Col64, Col65, Col66, Col67, Col68, Col69, Col70, Col71, Col72, Col73, Col74, Col75, Col76, Col77, Col78, Col79, Col80, Col81, Col82, Col83, Col84, Col85, Col86, Col87, Col88, Col89, Col90, Col91, Col92, Col93, Col94, Col95, Col96, Col97, Col98, Col99, Col100) AS Concatenate
			FROM DM_Title_Import_Utility_Data  
			WHERE DM_Master_Import_Code =  @DM_Master_Import_Code
			AND Col1 NOT LIKE '%Sr%'
		) AS A WHERE A.Concatenate = ''
	)

	UPDATE B SET  B.Error_Message= ISNULL(B.Error_Message,'') + '~'+@Mandatory_message , B.Record_Status = 'E'
	FROM DM_Title_Import_Utility_Data B WHERE B.Col1 IN (SELECT ExcelSrNo FROM #TempDuplicateRows ) AND B.DM_Master_Import_Code = @DM_Master_Import_Code

	PRINT 'Fetching duplicate rows'
	UPDATE A SET  Error_Message= ISNULL(Error_Message,'') + '~Duplicate Rows Found', Is_Ignore = 'Y' --,A.Record_Status = 'E'
	FROM DM_Title_Import_Utility_Data A 
	INNER JOIN 
	(
		SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
		FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' 
	) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
	WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' AND B.rank > 1 AND A.Col1 NOT IN (SELECT ExcelSrNo FROM #TempDuplicateRows)

	DELETE A FROM #TempTitle A 
	INNER JOIN (
	SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
	FROM #TempTitle
	WHERE ExcelSrNo NOT LIKE '%Sr%' ) AS B ON A.ExcelSrNo = B.ExcelSrNo
	WHERE  A.ExcelSrNo NOT LIKE '%Sr%' AND B.rank > 1	

	
	BEGIN
		PRINT 'Unpivoting Title data for further validation'
		INSERT INTO #TempTitleUnPivot(ExcelSrNo, ColumnHeader, TitleData)
		SELECT ExcelSrNo, LTRIM(RTRIM(ColumnHeader)), LTRIM(RTRIM(TitleData))
		FROM
		(
			SELECT * FROM #TempTitle
		) AS cp
		UNPIVOT 
		(
			TitleData FOR ColumnHeader IN (Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50)
		) AS up

		UPDATE T2 SET T2.ColumnHeader = T1.TitleData
		FROM (
			SELECT * FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		) AS T1
		INNER JOIN #TempTitleUnPivot T2 ON T1.ColumnHeader = T2.ColumnHeader

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		DELETE FROM #TempTitleUnPivot WHERE TitleData = ''

		INSERT INTO #TempExcelSrNo(ExcelSrNo)
		SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot

		SELECT @ExcelCnt = COUNT(DISTINCT ExcelSrNo) FROM #TempExcelSrNo

		UPDATE T1 SET T1.IsError = '', ErrorMessage = '' FROM #TempTitleUnPivot T1
	END

	DECLARE @Display_Name NVARCHAR(MAX), @Reference_Table NVARCHAR(MAX), @Reference_Text_Field NVARCHAR(MAX), @Reference_Value_Field NVARCHAR(MAX)
	, @Reference_Whr_Criteria NVARCHAR(MAX),  @Control_Type NVARCHAR(MAX), @Is_Allowed_For_Resolve_Conflict CHAR(1), @ShortName NVARCHAR(MAX),
	@Target_Column NVARCHAR(MAX)

	BEGIN
		PRINT 'Duplication'

		DECLARE db_cursor_Duplication CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%dup%'
		
		OPEN db_cursor_Duplication  
		FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') has duplicate data'
			WHERE ExcelSrNo IN(
				SELECT A.ExcelSrNo FROM ( SELECT excelSrNo, RANK() OVER(PARTITION BY TitleData ORDER BY excelSrNo) AS rank FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name ) AS A WHERE A.rank > 1
			)	
			--IF (@Display_Name = 'Title Name')
			--BEGIN
			--	UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Title Name is already existed'
			--	WHERE ExcelSrNo IN(
			--		SELECT EXCELSRNO FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name
			--		AND TitleData COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT DISTINCT ISNULL(Title_Name,'') FROM Title)
			--	)
			--END

			FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name 
		END 
		CLOSE db_cursor_Duplication  
		DEALLOCATE db_cursor_Duplication 
	END

	BEGIN
		PRINT 'Check INT Column'
		DECLARE @Value NVARCHAR(MAX)= '', @ExcelNo_IntDec NVARCHAR(MAX) = ''

		DECLARE db_cursor_Int CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND Colum_Type = 'INT'

		OPEN db_cursor_Int  
		FETCH NEXT FROM db_cursor_Int INTO @Display_Name 

		WHILE @@FETCH_STATUS = 0  
		BEGIN 
	
			DECLARE db_cursor_Int_dec CURSOR FOR 
			SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name	AND ISNULL(TitleData,'') <> ''

			OPEN db_cursor_Int_dec  
			FETCH NEXT FROM db_cursor_Int_dec INTO @ExcelNo_IntDec, @Value 
	
			WHILE @@FETCH_STATUS = 0  
			BEGIN 
					IF (ISNUMERIC(Replace(Replace(@Value,'+','A'),'-','A') + '.0e0') > 0)
					BEGIN
						UPDATE #TempTitleUnPivot SET RefKey = 1 WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value
					END
					ELSE IF (REPLACE(ISNUMERIC(REPLACE(REPLACE(@Value,'+','A'),'-','A') + 'e0'),1,CHARINDEX('.',@Value)) > 0 AND @Display_Name = 'Duration In Minute')
					BEGIN
						UPDATE #TempTitleUnPivot SET RefKey = 2  WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value

						IF (right(@Value, 1) = '.')
							UPDATE #TempTitleUnPivot SET TitleData = TitleData + '0'  WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value
					END
					ELSE
					BEGIN 
						UPDATE #TempTitleUnPivot SET RefKey = 0 FROM #TempTitleUnPivot WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value
					END

				FETCH NEXT FROM db_cursor_Int_dec INTO @ExcelNo_IntDec, @Value 
			END 

			CLOSE db_cursor_Int_dec  
			DEALLOCATE db_cursor_Int_dec 
	
			UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Not Numeric'
			WHERE ExcelSrNo IN (
				SELECT ExcelSrNo FROM #TempTitleUnPivot 
				WHERE  ColumnHeader = @Display_Name AND RefKey = 0
			)
		
			IF ('YEAR OF RELEASE' = UPPER(@Display_Name))
			BEGIN
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				WHERE ExcelSrNo IN (
				SELECT ExcelSrNo
				FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND  RefKey = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1950 AND 9999
				)

			END

			IF ('DURATION IN MINUTE' = UPPER(@Display_Name))
			BEGIN
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				WHERE ExcelSrNo IN (
					SELECT ExcelSrNo
					FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND RefKey = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1 AND 9999
				)

				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				WHERE ExcelSrNo IN (
					SELECT ExcelSrNo
					FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND RefKey = 2 AND CAST(TitleData AS DECIMAL(38,2)) NOT BETWEEN 1 AND 9999
				)
			END

			UPDATE #TempTitleUnPivot SET RefKey = NULL WHERE RefKey IN (0,1,2) AND ColumnHeader = @Display_Name

			FETCH NEXT FROM db_cursor_Int INTO @Display_Name 
		END 

		CLOSE db_cursor_Int  
		DEALLOCATE db_cursor_Int 
	END

	BEGIN
		PRINT 'Mandatory Validation'

		DECLARE db_cursor_Mandatory CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%'

		OPEN db_cursor_Mandatory  
		FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			 IF((SELECT COUNT(DISTINCT ExcelSrNo) FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name) < 2) --@ExcelCnt
				BEGIN
					UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Mandatory Field'
					WHERE ExcelSrNo NOT IN ( SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name)
				END
			  FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name 
		END 

		CLOSE db_cursor_Mandatory  
		DEALLOCATE db_cursor_Mandatory 
	END
	
	BEGIN
		PRINT 'Deleting IsError = Y and updating record status amd error message AND deleting existing title'

		INSERT INTO #TempDupTitleName (ExcelSrNo, Title_Name)
		SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError <> 'Y'

		UPDATE A SET A.Title_Type = B.TitleData
		FROM #TempDupTitleName A
		INNER JOIN #TempTitleUnPivot B ON A.ExcelSrNo = B.ExcelSrNo
		WHERE B.ColumnHeader = 'Title Type'

		UPDATE A SET A.Title_Code = B.Title_Code
		FROM #TempDupTitleName A
		INNER JOIN Title B ON A.Title_Name = B.Title_Name

		UPDATE A SET A.Deal_Type_Code = B.Deal_Type_Code
		FROM #TempDupTitleName A
		INNER JOIN Deal_Type B ON A.Title_Type = B.Deal_Type_Name
		WHERE  B.Is_Active = 'Y' AND Deal_Or_Title LIKE '%T%'

		UPDATE A SET A.Deal_Type_Code = B.Master_Code
		FROM #TempDupTitleName A
		INNER JOIN DM_Master_Log B ON A.Title_Type = B.Name
		WHERE Master_Type = 'TT' AND Is_Ignore = 'N' AND B.DM_Master_Import_Code = @DM_Master_Import_Code
	
		UPDATE A SET A.IsError = 'Y'
		FROM #TempDupTitleName A
		inner join Title B ON A.Title_Name = B.Title_Name AND A.Deal_Type_Code = B.Deal_Type_Code


		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + 'Title Name Already Existed'--, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		WHERE A.DM_Master_Import_Code =  @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%' and A.Col1 COLLATE Latin1_General_CI_AI IN 
		(
			SELECT ExcelSrNo FROM #TempDupTitleName where ISNULL(IsError, '') = 'Y'
		)
	
		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + B.ErrorMessage --, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		INNER JOIN (
			SELECT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y' GROUP BY ExcelSrNo, ErrorMessage
		) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
		WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%'

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo IN
		(
			SELECT ExcelSrNo FROM #TempDupTitleName where ISNULL(IsError, '') = 'Y'
		)

		DELETE FROM #TempTitleUnPivot WHERE IsError = 'Y'
	END
	
	BEGIN
		PRINT 'Referene check not available where Is_Multiple = ''N'''

		DECLARE db_cursor_Reference CURSOR FOR 
		SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'N'

		OPEN db_cursor_Reference  
		FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  

				EXEC ('UPDATE B SET B.RefKey = A.'+@Reference_Value_Field+' 
						FROM #TempTitleUnPivot B
						INNER JOIN '+@Reference_Table+' A ON A.'+@Reference_Text_Field+'  COLLATE Latin1_General_CI_AI = B.TitleData  COLLATE Latin1_General_CI_AI AND B.ColumnHeader = '''+@Display_Name+'''
						WHERE 1=1 '+@Reference_Whr_Criteria+'
				')

				IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
				BEGIN
					
					UPDATE B SET B.RefKey = A.Master_Code
					FROM DM_Master_Log A
					INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
					WHERE 
						A.DM_Master_Import_Code = @DM_Master_Import_Code 
						AND A.Master_Type   = @ShortName   
						AND B.ColumnHeader   = @Display_Name  
						AND B.RefKey IS NULL
						AND A.Master_Code IS NOT NULL
				END
				
				IF(@Is_Allowed_For_Resolve_Conflict = 'N')
					UPDATE A SET A.IsError = 'Y', A.ErrorMessage = ISNULL(A.ErrorMessage, '') + '~' + @Display_Name +' Not Available~'
					FROM #TempTitleUnPivot A WHERE  A.ExcelSrNo IN
					(
						SELECT DISTINCT  ExcelSrNo
						FROM #TempTitleUnPivot T1
						WHERE T1.ColumnHeader = @Display_Name AND T1.RefKey IS NULL AND T1.TitleData <> ''
					)

				FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		END 

		CLOSE db_cursor_Reference  
		DEALLOCATE db_cursor_Reference 
	END
	
	BEGIN
		PRINT 'Referene check where Is_Multiple = ''Y'''

		DECLARE db_cursor_Reference CURSOR FOR 
		SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'Y'

		OPEN db_cursor_Reference  
		FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria,  @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  		
	
			INSERT INTO #TempHeaderWithMultiple(ExcelSrNo,HeaderName, PropName)
				SELECT DISTINCT 
						ExcelSrNo, 
						@Display_Name,
						LTRIM(RTRIM(f.Number))
				FROM #TempTitleUnPivot upvot
				CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
				WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> '' 

			UPDATE A SET A.PropCode = B.Master_Code
			FROM #TempHeaderWithMultiple A
			INNER JOIN DM_Master_Log B ON A.PropName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName

			EXEC ('UPDATE A SET A.PropCode = B.'+@Reference_Value_Field+' 
			FROM #TempHeaderWithMultiple A
			INNER JOIN '+@Reference_Table+' B ON A.PropName COLLATE SQL_Latin1_General_CP1_CI_AS = B.'+@Reference_Text_Field+'
			WHERE 1=1 AND A.PropCode IS NULL AND A.HeaderName ='''+@Display_Name+'''  '+@Reference_Whr_Criteria+'
			')

			FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name,  @Reference_Table, @Reference_Text_Field, @Reference_Value_Field,  @Reference_Whr_Criteria , @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_Reference  
		DEALLOCATE db_cursor_Reference 
	END
	
	BEGIN
		PRINT 'Talent Referene check'

		DECLARE db_cursor_Talent_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName 
		FROM DM_Title_Import_Utility WHERE Reference_Table = 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y'

		OPEN db_cursor_Talent_Reference  
		FETCH NEXT FROM db_cursor_Talent_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  									 
				INSERT INTO #TempTalent(ExcelSrNo,HeaderName, TalentName, RoleCode)
				SELECT DISTINCT 
						ExcelSrNo, 
						upvot.ColumnHeader,
						LTRIM(RTRIM(f.Number)),
						r.Role_Code
				FROM #TempTitleUnPivot upvot
				inner join Role R ON R.Role_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
				CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
				WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''

				UPDATE A SET A.TalentCode = B.Master_Code FROM #TempTalent A
				INNER JOIN DM_Master_Log B ON A.TalentName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND Roles = @Display_Name

				FETCH NEXT FROM db_cursor_Talent_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_Talent_Reference  
		DEALLOCATE db_cursor_Talent_Reference 

		DELETE FROM #TempTalent WHERE TalentName in ('',' ','.')

		UPDATE tt SET tt.TalentCode = t.Talent_Code FROM Talent t
		INNER JOIN #TempTalent tt ON t.Talent_Name COLLATE Latin1_General_CI_AI = tt.TalentName COLLATE Latin1_General_CI_AI	
		WHERE TT.TalentCode IS NULL

	END

	BEGIN
		PRINT 'Extended metadata except talent Is_Multiple = ''N'''

		DECLARE db_cursor_EMD_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'N'
	
		OPEN db_cursor_EMD_Reference  
		FETCH NEXT FROM db_cursor_EMD_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
											 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
				-- if TXT then directly insert ie banner 
				IF (@Control_Type = 'DDL')
				BEGIN
					UPDATE upvot SET upvot.RefKey = ECV.Columns_Value_Code
					FROM #TempTitleUnPivot upvot
					INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
					INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Code = EC.Columns_Code AND UPVOT.TitleData COLLATE Latin1_General_CI_AI = ECV.Columns_Value COLLATE Latin1_General_CI_AI 
					WHERE upvot.ColumnHeader = @Display_Name -- 'Colour or B&W'
	
					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
					BEGIN
						UPDATE B SET B.RefKey = A.Master_Code
						FROM DM_Master_Log A
						INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
						WHERE 
							A.DM_Master_Import_Code = @DM_Master_Import_Code 
							AND A.Master_Type   = @ShortName   
							AND B.ColumnHeader   = @Display_Name  
							AND B.RefKey IS NULL
							AND A.Master_Code IS NOT NULL
					END

					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available~' 
						WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE RefKey is null AND ColumnHeader = @Display_Name )
					
				END
				FETCH NEXT FROM db_cursor_EMD_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 
	
		CLOSE db_cursor_EMD_Reference  
		DEALLOCATE db_cursor_EMD_Reference 
	END

	BEGIN
		PRINT 'Extended metadata except talent Is_Multiple = ''Y'''

		DECLARE db_cursor_EMDY_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'Y'

		OPEN db_cursor_EMDY_Reference  
		FETCH NEXT FROM db_cursor_EMDY_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
		
				IF (@Control_Type = 'DDL')
				BEGIN
					INSERT INTO #TempExtentedMetaData (ExcelSrNo, Columns_Code, HeaderName, EMDName)
					SELECT DISTINCT ExcelSrNo, EC.Columns_Code, upvot.ColumnHeader, LTRIM(RTRIM(f.Number))
					FROM #TempTitleUnPivot upvot
						INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
						CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
					WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''
					
					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
						UPDATE A SET A.EMDCode = B.Master_Code FROM #TempExtentedMetaData A
						INNER JOIN DM_Master_Log B ON A.EMDName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
						WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName

					UPDATE A SET A.EMDCode= ECV.Columns_Value_Code  FROM #TempExtentedMetaData A
					INNER JOIN Extended_Columns_Value ECV 
					ON ECV.Columns_Value COLLATE Latin1_General_CI_AI = A.EMDName COLLATE Latin1_General_CI_AI AND ECV.Columns_Code = A.Columns_Code 

					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available~' 
						WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempExtentedMetaData WHERE EMDCode is null AND HeaderName = @Display_Name )
				END
				FETCH NEXT FROM db_cursor_EMDY_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_EMDY_Reference  
		DEALLOCATE db_cursor_EMDY_Reference 
	END

	BEGIN
		PRINT 'Resolve Conflict'
		
		DELETE FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code and Master_Code IS NULL AND Is_Ignore = 'N'
		--UPDATE DM_Title_Import_Utility_Data SET Record_Status = NULL WHERE Record_Status = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code

		INSERT INTO #TempResolveConflict ([Name], Master_Type, Roles)
		SELECT DISTINCT A.[Name], A.Master_Type, A.Roles FROM (
				SELECT A.TitleData AS Name ,B.ShortName AS Master_Type ,'' AS Roles FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD
				SELECT A.PropName AS Name ,B.ShortName AS Master_Type,'' AS Roles
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD
				SELECT A.TitleData AS Name,B.ShortName AS Master_Type,''AS Roles
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD EXTENDED META DATA
				SELECT A.EMDName AS Name, B.ShortName AS Master_Type ,''AS Roles
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD EXTENDED META DATA
				SELECT A.TalentName AS Name, B.ShortName AS Master_Type, R.Role_Name AS Roles
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			--TITLE PROPERTIES WITH TALENT
		) AS A

		UPDATE A SET  A.Master_Code = B.Master_Code, A.Mapped_By = 'S' 
		FROM #TempResolveConflict A
		INNER JOIN DM_Master_Log B ON B.Name COLLATE Latin1_General_CI_AI = A.Name AND A.Master_Type COLLATE Latin1_General_CI_AI = B.Master_Type
		WHERE B.DM_Master_Log_Code IN ( SELECT  MAX(DM_Master_Log_Code) AS DM_Master_Log_Code FROM DM_Master_Log GROUP BY Name)

		UPDATE #TempResolveConflict SET Mapped_By = 'U' where Master_Code IS NULL 
	
		PRINT 'Delete from Temp table where is_ignore IS Y '
		BEGIN
			DELETE A
			FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
			WHERE A.RefKey IS NULL
				  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				  AND B.Reference_Table <> 'Talent' 
				  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				  AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempHeaderWithMultiple A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.PropName collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
			WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
			WHERE	A.RefKey IS NULL
					AND B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N'
					AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempExtentedMetaData A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.EMDName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
			WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempTalent A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN Role R ON R.Role_Code = A.RoleCode
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.TalentName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
												AND DML.Roles = R.Role_Name COLLATE Latin1_General_CI_AI
			WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A FROM #TempResolveConflict A 
				INNER JOIN DM_Master_Log B ON A.Name COLLATE SQL_Latin1_General_CP1_CI_AS = B.Name AND  B.Is_Ignore = 'Y'
			WHERE B.DM_Master_Import_Code = @DM_Master_Import_Code
		END

		IF EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
		BEGIN
			UPDATE TIU SET TIU.Record_Status = 'R' , TIU.Is_Ignore = 'N'
			FROM DM_Title_Import_Utility_Data AS TIU WHERE ISNULL(TIU.Record_Status,'') <> 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code 
			AND ISNUMERIC(TIU.Col1) = 1 AND TIU.Col1 COLLATE Latin1_General_CI_AI IN (
			SELECT DISTINCT A.ExcelSrNo FROM (
				SELECT A.ExcelSrNo
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION  
				SELECT A.ExcelSrNo
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			) AS A )

			IF EXISTS(SELECT TOP 1 * FROM DM_Title_Import_Utility_Data WHERE ISNULL(Record_Status,'') = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code )
				UPDATE DM_Master_Import SET Status = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
			
			INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By)
			SELECT @DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles,'N',Mapped_By FROM #TempResolveConflict
		END
	END

	BEGIN
		PRINT 'if error which cannot be resolved '

		UPDATE T SET T.IsError = 'Y' 
		FROM #TempTitleUnPivot T WHERE T.ExcelSrNo COLLATE SQL_Latin1_General_CP1_CI_AS IN
		(SELECT Col1 FROM DM_Title_Import_Utility_Data WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status = 'E')

		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE IsError = 'Y') 
		BEGIN

			UPDATE A SET A.Error_Message =ISNULL(A.Error_Message,'') + B.ErrorMessage, Record_Status = 'E'
			FROM DM_Title_Import_Utility_Data A
			INNER JOIN 
			(SELECT DISTINCT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y') as B on B.ExcelSrNo = A.Col1 COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' 
			
		END

		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE ISNULL(IsError,'') <> 'Y')
		BEGIN
			IF NOT EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
			BEGIN	
				DECLARE @cols_DisplayName AS NVARCHAR(MAX), @cols_TargetColumn AS NVARCHAR(MAX), @query AS NVARCHAR(MAX)
				UPDATE #TempTitleUnPivot SET IsError = '' WHERE IsError IS NULL

				-----------Title COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',[' + Display_Name +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',[' + Target_Column +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				
				EXEC ('
				INSERT INTO Title ( Is_Active, '+@cols_TargetColumn+')
				SELECT ''Y'', '+@cols_DisplayName+' FROM (SELECT ExcelSrNo, ColumnHeader, 
				CASE WHEN RefKey IS NULL THEN TitleData ELSE RefKey END
				TitleData FROM #TempTitleUnPivot WHERE ISError <> ''Y'') AS Tbl PIVOT( MAX(TitleData) FOR ColumnHeader IN ('+@cols_DisplayName+')) AS Pvt ')
			
				UPDATE A SET A.RefKey = B.Title_Code 
				FROM #TempTitleUnPivot A
				INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
				WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y'

				UPDATE B SET B.Inserted_By = 143, B.Inserted_On = GETDATE(), B.Last_UpDated_Time = GETDATE()
				FROM #TempTitleUnPivot A
				INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
				WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y'

				UPDATE B SET B.TitleCode = A.RefKey FROM  #TempTitleUnPivot A
				INNER JOIN #TempHeaderWithMultiple B ON A.ExcelSrNo = B.ExcelSrNo
				WHERE A.ColumnHeader = 'Title Name'  AND A.ISError <> 'Y'

				-----------Title_Country COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				EXEC ('
				INSERT INTO Title_Country (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE 
				HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Country'')
				')
				-----------Title_Geners COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')	
				EXEC ('
				INSERT INTO Title_Geners (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Geners'')
				')

				-----------Title_Talent COLUMN--------------------
				EXEC ('
				INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_Code)
				SELECT B.RefKey, A.TalentCode, A.RoleCode FROM #TempTalent A
				INNER JOIN #TempTitleUnPivot B ON B.ExcelSrNo = A.ExcelSrNo
				WHERE B.ColumnHeader = ''Title Name'' AND  A.TalentCode IS NOT NULL AND B.ISError <> ''Y''
				')

				-----------EXTENDED COLUMN IS Multiple = N With DDL AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.RefKey, 'N' 
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'DDL' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
					AND A.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = N With TXT AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Column_Value, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.TitleData, 'N'  
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'TXT' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y' 
					AND A.ISError <> 'Y'
	
				-----------EXTENDED COLUMN IS Multiple = Y AND Map_Extended_Column --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					 AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)	
				SELECT MEC.Map_Extended_Columns_Code, A.EMDCode
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = A.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'  
					AND AA.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = Y IN TALENT --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column_Values' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)
				SELECT MEC.Map_Extended_Columns_Code, A.TalentCode
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN extended_columns EC ON EC.Columns_Name = A.HeaderName COLLATE Latin1_General_CI_AI
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = EC.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
				
				UPDATE DM_Title_Import_Utility_Data SET Record_Status = 'C', Error_Message = NULL WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status IS NULL AND  ISNUMERIC(Col1) = 1 
				UPDATE DM_Master_Import SET Status = 'S' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
			END
		END
		ELSE 
		BEGIN 
			UPDATE DM_Master_Import SET Status = 'E' WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(Status,'') <> 'R'
		END
	END
	END TRY
	BEGIN CATCH
		UPDATE DM_Master_Import SET Status = 'T' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE A SET  A.Error_Message = ISNULL(Error_Message,'')  + '~' + ERROR_MESSAGE()
		FROM DM_Title_Import_Utility_Data A WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%'
	END CATCH
END
GO
PRINT N'Altering [dbo].[USPMHGetRequestDetails]...';


GO
ALTER PROCEDURE [dbo].[USPMHGetRequestDetails]
@RequestCode NVARCHAR(MAX),
@RequestTypeCode INT,
@IsCueSheet CHAR = 'N'
AS
BEGIN
	--DECLARE
	--@RequestCode NVARCHAR(MAX) = 10049,
	--@RequestTypeCode INT = 1,
	--@IsCueSheet CHAR = 'N'

	IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet

	IF(@RequestTypeCode = 1)
		BEGIN
		IF(@IsCueSheet = 'Y')
			BEGIN

				Select COUNT(*) AS Cnt, TitleCode,MusicTitleCode, ma.Music_Album_Name INTO #tempCueSheet
				from MHCuesheetsong mcs
				INNER JOIN Music_Title mt ON mt.Music_Title_Code = mcs.MusicTitleCode
				INNER JOIN Music_Album ma ON ma.Music_Album_Code = mt.Music_Album_Code
				GROUP BY TitleCode,MusicTitleCode, ma.Music_Album_Name

				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') + ' ('+CAST(ISNULL(tcs.Cnt, 0) AS NVARCHAR) +')' AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				LEFT  JOIN #tempCueSheet tcs ON tcs.MusicTitleCode = mrd.MusicTitleCode AND tcs.TitleCode = mr.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',','))) AND MRD.IsApprove = 'Y'
			END
		ELSE
			BEGIN
				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',',')))
			END
			
		END
	ELSE IF(@RequestTypeCode = 2)
		BEGIN
			SELECT ISNULL(MRD.MusicTrackName,'') AS RequestedMusicTitleName,ISNULL(MT.Music_Title_Name,'') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'') AS MusicMovieAlbumName,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
			ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove,
				 ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.Singers,'')),'') AS Singers,ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.StarCasts,'')),'') AS StarCasts
			FROM MHRequestDetails MRD
			LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
			LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
			WHERE MRD.MHRequestCode = @RequestCode
		END
	ELSE
		BEGIN
			SELECT ISNULL(MRD.TitleName,'') AS RequestedMovieAlbumName,ISNULL(MA.Music_Album_Name,'') AS ApprovedMovieAlbumName,
			CASE WHEN MRD.MovieAlbum = 'A' THEN 'Album' 
				 ELSE 'Movie' END AS MovieAlbum,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
				 ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove
			FROM MHRequestDetails MRD 
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode
			WHERE MRD.MHRequestCode = @RequestCode
		END

		IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet
END
GO
PRINT N'Altering [dbo].[USPMHMailNotification]...';


GO
ALTER PROCEDURE USPMHMailNotification
	@MHRequestCode INT,
	@MHRequestTypeCode INT = 0,
	@MHCueSheetCode INT = 0
AS
--=====================================================
-- Author:		<Akshay Rane>
-- Create date: <16 August 2018>
-- Description:	<Email Notification for music hub>
--=====================================================
BEGIN
	--DECLARE @MHRequestCode INT = 10466, @MHRequestTypeCode INT = 1, @MHCueSheetCode INT = 184

	IF OBJECT_ID('tempdb..#UsageRequest') IS NOT NULL
		DROP TABLE #UsageRequest

	IF OBJECT_ID('tempdb..#MusicTracksRequest') IS NOT NULL
		DROP TABLE #MusicTracksRequest
		
	IF OBJECT_ID('tempdb..#NewMovieRequest') IS NOT NULL
		DROP TABLE #NewMovieRequest

	DECLARE @Subject NVARCHAR(MAX), @MailSubjectCr NVARCHAR(MAX),@DatabaseEmail_Profile varchar(MAX), @EmailUser_Body NVARCHAR(MAX), @DefaultSiteUrl VARCHAR(MAX), @Email_Config_Code INT = 0

	DECLARE @ChannelName NVARCHAR(MAX),  @ShowName NVARCHAR(MAX), @EpisodeNo NVARCHAR(MAX), @TelecastDate NVARCHAR(MAX),@MusicLabel NVARCHAR(MAX), 
	@NoOfSongs NVARCHAR(MAX), @AuthorisedBy NVARCHAR(MAX) , @AuthorisedDate NVARCHAR(MAX), @RequestDate  NVARCHAR(MAX), @RequestID NVARCHAR(MAX),
	@RequestStatusName NVARCHAR(MAX), @SongsApproved NVARCHAR(MAX), @VendorCode INT

	DECLARE @ApprovedOn  NVARCHAR(MAX),  @FileName  NVARCHAR(MAX),  @SubmitBy  NVARCHAR(MAX), @SubmitOn  NVARCHAR(MAX) 

	DECLARE @DynamicTableName NVARCHAR(MAX) = ''

	BEGIN TRY
		IF(@MHCueSheetCode = 0)
		BEGIN
			IF(@MHRequestTypeCode = 1)
			BEGIN
				SELECT DISTINCT
					 @ChannelName = C.Channel_Name
					,@ShowName = (select TOP 1 T.Title_Name from Title T Where T.Title_Code = MR.TitleCode)
					,@EpisodeNo = CASE WHEN ISNULL(MR.EpisodeFrom,0)  < ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX)) +' - '+ CAST(MR.EpisodeTo AS VARCHAR(MAX))
						 WHEN ISNULL(MR.EpisodeFrom,0)  = ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX))
						 ELSE '' END
					,@TelecastDate = CASE WHEN CAST(MR.TelecastFrom AS DATE) =  CAST(MR.TelecastTo AS DATE) 
									THEN CONVERT(varchar(11),IsNull(MR.TelecastFrom,''), 106)
									ELSE
									CONVERT(varchar(11),IsNull(MR.TelecastFrom,''), 106)  + ' - ' + CONVERT(varchar(11),IsNull(MR.TelecastTo,''), 106)
									END
					,@MusicLabel = STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS NVARCHAR) FROM MHRequestDetails MRD1
						 INNER JOIN Music_Title_Label MTL ON MRD1.MusicTitleCode = MTL.Music_Title_Code 
						 INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
						 Where MRD1.MHRequestCode = MR.MHRequestCode
						 FOR XML PATH('')), 1, 1, '')
					,@NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
					LEFT JOIN Channel c ON c.Channel_Code = MR.ChannelCode
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr= @RequestID +' – Usage Request - is '+UPPER(@RequestStatusName)
				 --SELECT @ChannelName,@ShowName,@EpisodeNo,@TelecastDate,@MusicLabel,@NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved
	
				 DECLARE @PivotUR TABLE 
					(Channel_Name NVARCHAR(MAX),Show_Name  NVARCHAR(MAX), Episode_No  NVARCHAR(MAX),Telecast_Date  NVARCHAR(MAX),
					Music_Label  NVARCHAR(MAX),No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX) )

				INSERT INTO @PivotUR VALUES (@ChannelName, @ShowName, @EpisodeNo, @TelecastDate, @MusicLabel, @NoOfSongs, @SongsApproved)

				SELECT * INTO #UsageRequest FROM(
				SELECT 1 AS RowId, 'Channel Name: ' as ColName, Channel_Name as ColValue from @PivotUR UNION ALL
				SELECT 2 AS RowId, 'Show Name: ' as ColName, Show_Name as ColValue from @PivotUR UNION ALL
				SELECT 3 AS RowId, 'Episode No.: ' as ColName, Episode_No as ColValue from @PivotUR UNION ALL
				SELECT 4 AS RowId, 'Telecast Date: ' as ColName, Telecast_Date as ColValue from @PivotUR UNION ALL
				SELECT 5 AS RowId, 'Music Label: ' as ColName, Music_Label as ColValue from @PivotUR UNION ALL
				SELECT 6 AS RowId, 'Number of Songs: ' as ColName, No_Of_Songs as ColValue from @PivotUR UNION ALL
				SELECT 7 AS RowId, 'Songs Approved: ' as ColName, Songs_Approved as ColValue from @PivotUR) as tmp 
		
				IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED' )
				BEGIN
					DELETE FROM #UsageRequest WHERE RowId = 7
				END

				SET @DynamicTableName = '#UsageRequest'
				SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHCONSUMPTIONREQUEST'
			END
			ELSE IF(@MHRequestTypeCode = 2)
			BEGIN
				SELECT DISTINCT
					 @NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr=@RequestID +' – New Music Tracks Request - is '+UPPER(@RequestStatusName)

				 --SELECT @NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved

				 DECLARE @PivotMTR TABLE (No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX))

				 INSERT INTO @PivotMTR VALUES (@NoOfSongs, @SongsApproved)

				 SELECT * INTO #MusicTracksRequest FROM(
				 SELECT 1 AS RowId, 'Number of Songs: ' as ColName, No_Of_Songs as ColValue from @PivotMTR UNION ALL
				 SELECT 2 AS RowId, 'Approved Songs: ' as ColName, Songs_Approved as ColValue from @PivotMTR) as tmp 

				 IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED' )
				 BEGIN
		 			DELETE FROM #MusicTracksRequest WHERE RowId = 2
				 END

				 SET @DynamicTableName = '#MusicTracksRequest'
				 SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHMUSICREQUEST'
			END
			ELSE IF(@MHRequestTypeCode = 3)
			BEGIN
				 SELECT DISTINCT
					 @NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr=@RequestID +' – New Movie Request - is '+UPPER(@RequestStatusName)

				 --SELECT @NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved

				 DECLARE @PivotNMR TABLE (No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX))

				 INSERT INTO @PivotNMR VALUES (@NoOfSongs, @SongsApproved)

				 SELECT * INTO #NewMovieRequest FROM(
				 SELECT 1 AS RowId, 'Number of Movie/Album: ' as ColName, No_Of_Songs as ColValue from @PivotNMR UNION ALL
				 SELECT 2 AS RowId, 'Approved Movie/Album: ' as ColName, Songs_Approved as ColValue from @PivotNMR) as tmp 

				 IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED')
				 BEGIN
		 			DELETE FROM #NewMovieRequest WHERE RowId = 2
				 END

				 SET @DynamicTableName = '#NewMovieRequest'
				 SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHMOVIEREQUEST'
			END
		END
		ELSE
		BEGIN
			SELECT 
				@RequestID = MC.RequestID,
				@ApprovedOn =  CONVERT(VARCHAR(11),ISNULL(MC.ApprovedOn,''), 106),
				@FileName = MC.FileName, 
				@SubmitBy =V.Vendor_Name +' / ' + U.First_Name,
				@SubmitOn = CONVERT(VARCHAR(11),ISNULL(MC.SubmitOn,''), 106),
				@RequestStatusName = 'COMPLETED',
				@VendorCode = MC.VendorCode
			FROM MHCUESHEET MC
				INNER JOIN Vendor V ON V.Vendor_Code = MC.VendorCode
				INNER JOIN Users U ON U.Users_Code = MC.SubmitBy
			WHERE MC.MHCueSheetCode = @MHCueSheetCode 

			--SELECT @RequestID,@ApprovedOn,@FileName,@SubmitBy,@SubmitOn,@RequestStatusName

			SET @MailSubjectCr =  @RequestID +' – Music Assignment Request - is '+UPPER(@RequestStatusName)
			SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHCUESHEETUPLOAD'
		END
	 
		SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
		SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
		
		DECLARE @Email_Id NVARCHAR(MAX),  @Users_Code INT = 0, @UserName NVARCHAR(MAX) = '',
				@RowCount INT = 0, @Emailbody NVARCHAR(MAX), @EmailHead NVARCHAR(MAX), @EMailFooter NVARCHAR(MAX)

		DECLARE curOuter CURSOR FOR 
		SELECT MU.Users_Code,U.Email_Id, UPPER(LEFT(U.First_Name, 1))+LOWER(SUBSTRING(U.First_Name, 2, LEN(U.First_Name))) +' '+UPPER(LEFT(U.Last_Name, 1))+LOWER(SUBSTRING(U.Last_Name, 2, LEN(U.Last_Name))) AS UserName FROM MHUsers MU
		INNER JOIN Users U ON U.Users_Code = MU.Users_Code WHERE MU.Vendor_Code = @VendorCode AND U.Is_Active = 'Y'
		OPEN curOuter 
			
		FETCH NEXT FROM curOuter INTO @Users_Code, @Email_Id, @UserName

		SELECT  @EmailUser_Body='', @Emailbody = '', @EmailHead= '', @EMailFooter = ''

		WHILE @@Fetch_Status = 0 
		BEGIN	
				SET @Emailbody = '<table class="tblFormat" style="width:90%; border:1px solid black;border-collapse:collapse;">'
			
				IF(@RowCount = 0)
				BEGIN
					IF(@MHCueSheetCode = 0)
					BEGIN
						  SET @Emailbody=@Emailbody + '<tr><th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Date</th>
						  <th align="center" width="40%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Description</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Authorised By</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Authorised Date</th></tr>'
					 END
					 ELSE
					 BEGIN
						  SET @Emailbody=@Emailbody + '<tr><th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Date</th>
						  <th align="center" width="40%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Description</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Requested By</th>
						  <th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Uploaded On</th></tr>'
					 END
				END
				SET @RowCount  = @RowCount  + 1

				IF(@MHCueSheetCode = 0)
				BEGIN
					DECLARE @returnCount INT = 0,  @Sql NVARCHAR(MAX)=''

					SET @SQL = 'SELECT @Count= Count(*) FROM ' + @DynamicTableName 

					EXEC sp_executesql @SQL,N'@Count INT OUTPUT',@Count=@returnCount OUTPUT

					SELECT @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px" rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' >'+ CAST  (ISNULL(@RequestDate, '') as varchar(MAX))+' </td>		
								{{DYNAMIC}}
								<td align="center" class="tblData" rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (ISNULL(@AuthorisedBy,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (IsNull(@AuthorisedDate,'') AS NVARCHAR(MAX)) +' </td></tr>'

					DECLARE @i INT = 0

					WHILE (@i < @returnCount)
					BEGIN
						 DECLARE @ColName NVARCHAR(MAX)= '', @ColVal NVARCHAR(MAX)= ''
						 SET @i = @i + 1

						 DECLARE @temptable TABLE (ColName NVARCHAR(MAX), ColVal NVARCHAR(MAX))
						 SET @Sql = 'SELECT ColName, ColValue  FROM '+ @DynamicTableName +' WHERE  RowId = '+ Cast(@i as varchar(10))
						 INSERT @temptable EXEC(@Sql) 		 
						 SELECT @ColName = ColName, @ColVal= ColVal FROM @temptable	 

						 IF	(@i = 1)
						 BEGIN
							SELECT @Emailbody = REPLACE(@Emailbody, '{{DYNAMIC}}', '<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>'+@ColName +'</b> '+ @ColVal+'</td>');
						 END
						 ELSE
						 BEGIN
							SELECT @Emailbody=@Emailbody+ '<tr><td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>'+@ColName +'</b> '+ @ColVal+'</td></tr>'
						 END
						 DELETE FROM @temptable	
					END
				END
				ELSE
				BEGIN
					SELECT @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px" >'+ CAST  (ISNULL(@ApprovedOn, '') as varchar(MAX))+' </td>		
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (ISNULL(@FileName,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (ISNULL(@SubmitBy,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST (IsNull(@SubmitOn,'') AS NVARCHAR(MAX)) +' </td></tr>'
				END
				IF(@Emailbody!='')
					SET @Emailbody = @Emailbody + '</table>'

				SET @EmailHead= '<html><head></head><body>
				<p>Dear '+@UserName+',</p>
				<p>The Request No: '+ @RequestID +' is <b>'+ UPPER(@RequestStatusName) +'</b>. </p>
				<p>Please click <a href="'+@DefaultSiteUrl+'">here</a> to access Music Hub to view the request.</p>
				<p>The details are as follows: </p>'

				SET @EMailFooter ='</br>
				</body></html>'

				--SET @EMailFooter ='</br>
				--If you have any questions or need assistance, please feel free to reach us at 
				--<a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>
				--<p>Regards,</br>
				--RightsU Support</br>
				--U-TO Solutions</p>
				--</body></html>'

				SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
		
				IF(@RowCount <> 0)
				BEGIN
					--select @EmailUser_Body, @Users_Code, @Email_Id, @UserName

					EXEC msdb.dbo.sp_send_dbmail 
					@profile_name = @DatabaseEmail_Profile,
					@recipients =  @Email_Id,
					@subject = @MailSubjectCr,
					@body = @EmailUser_Body, 
					@body_format = 'HTML';

					INSERT INTO MHNotificationLog(Email_Config_Code, Created_Time, Is_Read, Email_Body,	User_Code, Vendor_Code, [Subject], Email_Id, MHRequestCode, MHRequestTypeCode)
					SELECT @Email_Config_Code,GETDATE(),'N', @Emailbody, @Users_Code, @VendorCode, @MailSubjectCr, @Email_Id, @MHRequestCode, @MHRequestTypeCode
					
					SET @RowCount = 0
				END
				SET @EmailUser_Body=''	
		
				FETCH NEXT FROM curOuter INTO @Users_Code, @Email_Id, @UserName
		END	
		CLOSE curOuter
		DEALLOCATE curOuter
		SELECT 'Y' as Result  
	END TRY
	BEGIN CATCH
			IF CURSOR_STATUS('global','curOuter')>=-1
			BEGIN
				CLOSE curOuter
				DEALLOCATE curOuter
			END
			
			SELECT ERROR_MESSAGE() as Result  
	END CATCH
	IF OBJECT_ID('tempdb..#MusicTracksRequest') IS NOT NULL DROP TABLE #MusicTracksRequest
	IF OBJECT_ID('tempdb..#NewMovieRequest') IS NOT NULL DROP TABLE #NewMovieRequest
	IF OBJECT_ID('tempdb..#UsageRequest') IS NOT NULL DROP TABLE #UsageRequest
END

--exec USPMHMailNotification 10466,1,0
--select * from MHNotificationLog
--select * from email_config order by 1 desc

--CREATE PROCEDURE USPMHMailNotification
--	@MHRequestCode INT,
--	@MHRequestTypeCode INT,
--	@MHCueSheetCode INT = 0
--AS
----=====================================================
---- Author:		<Akshay Rane>
---- Create date: <16 August 2018>
---- Description:	<Email Notification for music hub>
----=====================================================
--BEGIN
--	SELECT '' as Result  
--END
GO
PRINT N'Altering [dbo].[USPMHNotificationList]...';


GO
ALTER PROCEDURE USPMHNotificationList 
@UsersCode INT,
@RecordFor NVARCHAR(2),
@UnReadCount INT OUT
AS
BEGIN
	--DECLARE
	--@UsersCode INT = 1284,
	--@RecordFor NVARCHAR(2) = 'L',
	--@UnReadCount INT-- OUT

	DECLARE @Count INT;
	DECLARE @VendorCode INt;

	SET @VendorCode = (Select Vendor_Code from MHUsers where Users_Code = @UsersCode)
	Print 'Vendor Code: '+CAST(@VendorCode AS NVARCHAR)

	IF(@RecordFor = 'N')
		BEGIN
			SET @Count = 5
		END
	ELSE
		BEGIN
			SET @Count = (SELECT COUNT(MHNotificationLogCode) FROM MHNotificationLog WHERE Vendor_Code = @VendorCode)
		END
	
	SET @UnReadCount = (SELECT COUNT(MHNotificationLogCode) FROM MHNotificationLog WHERE Vendor_Code = @VendorCode AND User_Code = @UsersCode AND Is_Read = 'N')
	print 'Unread Count: ' +CAST(@UnReadCount AS NVARCHAR)

	--SELECT TOP(@Count) MHNotificationLogCode,Subject,U.Login_Name AS UserName,CAST(REPLACE(CONVERT(NVARCHAR,Created_Time, 106),' ', '-') + ' ' +convert(char(5), Created_Time, 108) AS NVARCHAR)  AS CreatedTime,
	--Is_Read AS IsRead, MHRequestCode, MHRequestTypeCode  
	--FROM MHNotificationLog MNL
	--INNER JOIN Users U ON U.Users_Code = MNL.User_Code
	--Where Vendor_Code = @VendorCode AND User_Code = @UsersCode
	--Order BY MNL.Created_Time desc

	SELECT TOP(@Count) MHNotificationLogCode,Subject,UserName, CreatedTime, IsRead, MHRequestCode, MHRequestTypeCode FROM
	(
		SELECT DISTINCT MHNotificationLogCode,Subject,U.Login_Name AS UserName,CAST(REPLACE(CONVERT(NVARCHAR,Created_Time, 106),' ', '-') + ' ' +convert(char(5), Created_Time, 108) AS NVARCHAR)  AS CreatedTime,
		Is_Read AS IsRead, MHRequestCode, MHRequestTypeCode  
		FROM MHNotificationLog MNL
		INNER JOIN Users U ON U.Users_Code = MNL.User_Code
		Where Vendor_Code = @VendorCode AND User_Code = @UsersCode
	)
	AS A
	Order BY A.MHNotificationLogCode desc

END

--DECLARE @UnReadCount INT
--EXEC USPMHNotificationList 1280,'A',@UnReadCount OUTPUT
--PRINT 'RecordCount: '+CAST( @UnReadCount AS NVARCHAR)
GO
PRINT N'Creating [dbo].[USPMHMovieAlbumMusicDetailsList]...';


GO
CREATE PROCEDURE [dbo].[USPMHMovieAlbumMusicDetailsList] (
	@RequestTypeCode INT, 
	@UsersCode INT
	)
AS
BEGIN
SET FMTONLY OFF
	
	--DECLARE 
	--@RequestTypeCode INT = 3,
	--@UsersCode INT = 293

	IF(@RequestTypeCode = 2)
	BEGIN
		EXEC ('SELECT MR.RequestID,ISNULL(MRD.MusicTrackName,'''') AS RequestedMusicTitleName,ISNULL(MT.Music_Title_Name,'''') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'''') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'''') AS MusicAlbum,
		CASE WHEN MRD.MovieAlbum = ''A'' THEN ''Album'' ELSE ''Movie'' END AS MovieAlbum,
		CASE 
			WHEN MRD.CreateMap = ''C'' THEN ''Create'' WHEN MRD.CreateMap = ''M'' THEN ''Map'' ELSE ''Pending'' 
		END AS CreateMap,ISNULL(MRS.RequestStatusName,'''') AS Status,ISNULL(U.Login_Name,'''') AS RequestedBy,ISNULL(MR.RequestedDate,'''') AS RequestDate, MRD.Remarks
		FROM MHRequest MR
		LEFT JOIN MHRequestStatus MRS ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
		LEFT JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
		LEFT JOIN Users U ON U.Users_Code = MR.UsersCode
		LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
		LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
		LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
		WHERE MR.MHRequestTypeCode = '+ @RequestTypeCode +' AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = '+ @UsersCode +') ORDER BY CAST(RequestedDate AS DATETIME) DESC')
	END	
	ELSE 
	BEGIN
		EXEC ('SELECT MR.RequestID,ISNULL(MRD.TitleName,'''') AS RequestedMusicTitleName,ISNULL(MA.Music_Album_Name,'''') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'''') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'''') AS MusicAlbum,
		CASE WHEN MRD.MovieAlbum = ''A'' THEN ''Album'' ELSE ''Movie'' END AS MovieAlbum,
		CASE 
			WHEN MRD.CreateMap = ''C'' THEN ''Create'' WHEN MRD.CreateMap = ''M'' THEN ''Map'' ELSE ''Pending'' 
		END AS CreateMap,ISNULL(MRS.RequestStatusName,'''') AS Status,ISNULL(U.Login_Name,'''') AS RequestedBy,ISNULL(MR.RequestedDate,'''') AS RequestDate, MRD.Remarks
		FROM MHRequest MR
		LEFT JOIN MHRequestStatus MRS ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
		LEFT JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
		LEFT JOIN Users U ON U.Users_Code = MR.UsersCode
		LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
		LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
		LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
		WHERE MR.MHRequestTypeCode = '+ @RequestTypeCode +' AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = '+ @UsersCode +') ORDER BY CAST(RequestedDate AS DATETIME) DESC')
	END
END

--SELECT * FROM MHRequest
GO
PRINT N'Refreshing [dbo].[USP_Title_Import_Utility_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Import_Utility_Schedule]';


GO
PRINT N'Refreshing [dbo].[USPMHAutoApproveUsageRequest]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPMHAutoApproveUsageRequest]';


GO
PRINT N'Update complete.';


GO

--///////////////// FILE DB SCHEMA v5.0.3.2

GO
PRINT N'Altering [dbo].[USP_List_DM_Master_Import]...';


GO
ALTER  PROCEDURE [dbo].[USP_List_DM_Master_Import]  
(  
	@strSearch  NVARCHAR(2000),  
	@PageNo INT=1,  
	@OrderByCndition NVARCHAR(100),  
	@IsPaging VARCHAR(2),  
	@PageSize INT,
	@RecordCount INT OUT,  
	@User_Code INT
)   
AS  
BEGIN  
	SET FMTONLY OFF  
  
	DECLARE @SqlPageNo NVARCHAR(MAX),@Sql NVARCHAR(MAX)  
	SET NOCOUNT ON;   
	IF(@PageNo=0)  
		Set @PageNo = 1   
	CREATE TABLE #Temp  
	(  
		DM_Master_Import_Code INT,  
		RowId VARCHAR(200)
	);  

		DECLARE @Is_Advance_Title_Import NVARCHAR(MAX) = ''
		select @Is_Advance_Title_Import =  Parameter_Value from system_parameter_new  where parameter_name = 'Is_Advance_Title_Import'

		IF (@strSearch LIKE '%DM.File_Type = ''T''%')	
		BEGIN
			IF(@Is_Advance_Title_Import = 'N')
			BEGIN
					SET @SqlPageNo = '  
					WITH Y AS   
					(  
						SELECT ISNULL(DM.DM_Master_Import_Code, 0) AS DM_Master_Import_Code, RowId = ROW_NUMBER() OVER (ORDER BY DM.DM_Master_Import_Code desc)
						FROM DM_Master_Import DM  
						Where  DM.DM_Master_Import_Code NOT IN (
							 SELECT DISTINCT DM_Master_Import_Code FROM DM_TITLE_IMPORT_Utility_data
							) AND 1= 1  '+@StrSearch+'  
						GROUP BY DM.DM_Master_Import_Code  
					)  
					INSERT INTO #Temp Select DM_Master_Import_Code,RowId From Y'  
			END
			ELSE
			BEGIN
					SET @SqlPageNo = '  
					WITH Y AS   
					(  
						SELECT ISNULL(DM.DM_Master_Import_Code, 0) AS DM_Master_Import_Code, RowId = ROW_NUMBER() OVER (ORDER BY DM.DM_Master_Import_Code desc)
						FROM DM_Master_Import DM  
						INNER JOIN DM_Title_Import_Utility_DATA B ON B.DM_Master_Import_Code = DM.DM_Master_Import_Code
						Where 1= 1  '+@StrSearch+'  
						GROUP BY DM.DM_Master_Import_Code  
					)  
					INSERT INTO #Temp Select DM_Master_Import_Code,RowId From Y'  
			END
		END
		ELSE
		BEGIN
				SET @SqlPageNo = '  
					WITH Y AS   
					(  
						SELECT ISNULL(DM.DM_Master_Import_Code, 0) AS DM_Master_Import_Code, RowId = ROW_NUMBER() OVER (ORDER BY DM.DM_Master_Import_Code desc)
						FROM DM_Master_Import DM  
						Where 1= 1  '+@StrSearch+'  
						GROUP BY DM.DM_Master_Import_Code  
					)  
					INSERT INTO #Temp Select DM_Master_Import_Code,RowId From Y'
		END

		PRINT @SqlPageNo  
		EXEC(@SqlPageNo)  

		SELECT @RecordCount = ISNULL(COUNT(DM_Master_Import_Code),0) FROM #Temp  
  
	IF(@IsPaging = 'Y')  
	BEGIN   
		DELETE FROM #Temp WHERE RowId < (((@PageNo - 1) * @PageSize) + 1) OR RowId > @PageNo * @PageSize   
	END   
	ALTER TABLE #Temp ADD FileType CHAR(1)
	ALTER TABLE #Temp ADD TotalCount INT
	ALTER TABLE #Temp ADD SuccessCount INT
	ALTER TABLE #Temp ADD ConflictCount INT
	ALTER TABLE #Temp ADD IgnoreCount INT
	ALTER TABLE #Temp ADD ErrorCount INT
	ALTER TABLE #Temp ADD WaitingCount INT

	UPDATE T SET T.FileType = (SELECT File_Type FROM DM_Master_Import WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
	FROM #Temp T

	DECLARE @FileType CHAR(1)
	SELECT @FileType = FileType FROM #Temp
	IF(@FileType = 'M')
	BEGIN
		UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
		FROM #Temp T

		UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
		FROM #Temp T

		UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND Is_Ignore ='N')
		FROM #Temp T

		UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
		FROM #Temp T

		UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
		FROM #Temp T

		UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Music_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
		FROM #Temp T
	END
	ELSE IF(@FileType= 'T')
	BEGIN 
		
		IF(@Is_Advance_Title_Import = 'N')
		BEGIN
			UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
			FROM #Temp T

			UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
			FROM #Temp T

			UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND Is_Ignore ='N')
			FROM #Temp T

			UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
			FROM #Temp T

			UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
			FROM #Temp T

			UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Title WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
			FROM #Temp T
		END
		ELSE
		BEGIN
			UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 and DM_Master_Import_Code = T.DM_Master_Import_Code)
			FROM #Temp T

			UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
			FROM #Temp T

			UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'R' AND ISNULL(Is_Ignore,'') ='N')
			FROM #Temp T

			UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND ISNULL(Is_Ignore,'') = 'Y')
			FROM #Temp T

			UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E' AND ISNULL(Is_Ignore,'') <> 'Y')
			FROM #Temp T

			UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Title_Import_Utility_Data WHERE ISNUMERIC(Col1) = 1 AND DM_Master_Import_Code = T.DM_Master_Import_Code AND ISNULL(Record_Status,'') = '' AND ISNULL(Is_Ignore,'') <> 'Y')
			FROM #Temp T
		END
		
	END
	ELSE
	BEGIN
		UPDATE T SET T.TotalCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code)
		FROM #Temp T

		UPDATE T SET T.SuccessCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'C')
		FROM #Temp T

		UPDATE T SET T.ConflictCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND (Record_Status = 'OR' 
			OR Record_Status = 'MR' OR Record_Status = 'SM' OR Record_Status = 'MO' OR Record_Status = 'SO') ANd Is_Ignore = 'N')
		FROM #Temp T

		UPDATE T SET T.IgnoreCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Is_Ignore = 'Y')
		FROM #Temp T

		UPDATE T SET T.ErrorCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'E')
		FROM #Temp T

		UPDATE T SET T.WaitingCount = (SELECT COUNT(*) FROM DM_Content_Music WHERE DM_Master_Import_Code = T.DM_Master_Import_Code AND Record_Status = 'N' AND Is_Ignore <> 'Y')
		FROM #Temp T
	END

	SET @Sql = 'SELECT DM.DM_Master_Import_Code As DM_Master_Import_Code, DM.File_Name As File_Name, U.Login_Name AS UserName, 
	REPLACE(CONVERT(char(11), DM.Uploaded_Date, 106),'' '',''-'') + right(convert(varchar(32),DM.Uploaded_Date,100),8) AS Uploaded_Date, 
	DM.Status AS Status, T.TotalCount As TotalCount, T.SuccessCount As SuccessCount, T.ConflictCount AS ConflictCount, T.IgnoreCount AS IgnoreCount,
	T.ErrorCount As ErrorCount, T.WaitingCount As WaitingCount
	FROM DM_Master_Import DM  
	INNER JOIN USers U  
	ON DM.Upoaded_By = U.Users_Code  
	INNER JOIN #Temp T ON DM.DM_Master_Import_Code = T.DM_Master_Import_Code ORDER BY ' +@OrderByCndition  
  
	PRINT @sql  
	EXEC (@Sql)  
   

	--DROP TABLE #Temp  
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
END
GO
PRINT N'Altering [dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]...';


GO
ALTER PROCEDURE [dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]
(
	@Title_Code VARCHAR(MAX) = '0', 
	@Platform_Code VARCHAR(MAX) = '0', 
    @Country_Code VARCHAR(MAX) = '0', 
	@Is_Original_Language bit, 
	@Title_Language_Code VARCHAR(MAX),
	@Date_Type VARCHAR(2),
	@StartDate VARCHAR(20),
	@EndDate VARCHAR(20),
	@StartMonth VARCHAR(20),
	@EndYear VARCHAR(20),
	@RestrictionRemarks VARCHAR(10),
	@OthersRemarks VARCHAR(10),
	@Platform_ExactMatch VARCHAR(10), 
	@MustHave_Platform VARCHAR(MAX)='0', 
	@Exclusivity VARCHAR(1) ,   --B-Both, E-Exclusive,N-NonExclusive 
	@SubLicense_Code VARCHAR(MAX), --Comma   Separated SubLicensing Code. 0-No Sub Licensing ,
	@Region_ExactMatch VARCHAR(10),
	@Region_MustHave VARCHAR(MAX) = '0',
	@Region_Exclusion VARCHAR(MAX) = '0',
	@Subtit_Language_Code VARCHAR(MAX) = '0', 
	@Dubbing_Language_Code VARCHAR(MAX) = '0', 
	@Dubbing_Subtitling VARCHAR(20),
	@BU_Code VARCHAR(20),
	@Is_SubLicense VARCHAR(1) = 'N',
	@Is_Approved  VARCHAR(1) = 'A',
	@Deal_Type_Code INT = 1 ,
	@Episode_From INT=1,
	@Episode_To INT=1,
	@Is_IFTA_Cluster CHAR(1) = 'N'
)
AS
-- =============================================
-- Author :	RESHMA KUNJAL
-- Create date: 08 MARCH 2016
-- Description:	This Procedure is to generate Platform wise Acquisition data With "Availability Report" paramters and @Is_SubLicense parameter
-- And Deals which are Approved
-- =============================================
BEGIN
	Set @Episode_From = Case When IsNull(@Episode_From, 0) < 1 Then 1 Else @Episode_From End
	Set @Episode_To = Case When IsNull(@Episode_To, 0) < 1 Then 100000 Else @Episode_To End

	-- SET NOCOUNT ON added to prevent extra result sets FROM interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	PRINT 'PA-STEP-1 Filter Criteria  ' + convert(varchar(30),getdate() ,109)
	BEGIN

		IF(UPPER(@RestrictionRemarks) = 'TRUE')
			SET @RestrictionRemarks = 'Y'
		ELSE
			SET @RestrictionRemarks = 'N'

		IF(UPPER(@OthersRemarks) = 'TRUE')
			SET @OthersRemarks = 'Y'
		ELSE
			SET @OthersRemarks = 'N'

		DECLARE @EX_YES CHAR(1)='',@EX_NO CHAR(1) =''

		IF(UPPER(@Exclusivity) = 'E')
			SET @EX_YES = 'Y'
		ELSE IF(UPPER(@Exclusivity) = 'N')
			SET @EX_NO = 'N'
		ELSE IF(UPPER(@Exclusivity) = 'B')
		BEGIN
			SET @EX_YES = 'Y'
			SET @EX_NO = 'N'
		END
	
	----------------- Title AND Platform Population
	SELECT number AS Title_Code INTO #Temp_Title_Neo FROM dbo.fn_Split_withdelemiter(@Title_Code, ',') WHERE number NOT IN('0', '')
	SELECT CAST(number AS INT) number INTO #Temp_Platform_Neo FROM dbo.fn_Split_withdelemiter(@Platform_Code,',') WHERE number NOT IN('0', '')
	
	------------------ END
			
	----------------- Country Population 
	CREATE TABLE #Temp_Country_Neo(
		Country_Code INT
	)

	INSERT INTO #Temp_Country_Neo
	SELECT DISTINCT number FROM fn_Split_withdelemiter(@Country_Code , ',') WHERE number NOT LIKE 'T%' AND number NOT IN('0')
	
	IF(@Is_IFTA_Cluster = 'N')
	BEGIn
		INSERT INTO #Temp_Country_Neo
		SELECT DISTINCT Country_Code FROM Territory_Details td WHERE td.Territory_Code IN (
			SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Code, ',') WHERE number LIKE 'T%' AND number NOT IN('0')
		) AND td.Country_Code NOT IN (
			SELECT tc.Country_Code FROM #Temp_Country_Neo tc
		)
		AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
		AND td.Country_Code NOT IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion, ',') WHERE number NOT IN ( '0', ''))
	END
	ELSE IF(@Is_IFTA_Cluster = 'Y')
	BEGIn
		INSERT INTO #Temp_Country_Neo
		SELECT DISTINCT Country_Code FROM Report_Territory_Country td WHERE td.Report_Territory_Code IN (
			SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Code, ',') WHERE number LIKE 'T%' AND number NOT IN('0')
		) AND td.Country_Code NOT IN (
			SELECT tc.Country_Code FROM #Temp_Country_Neo tc
		)
		AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
		AND td.Country_Code NOT IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion, ',') WHERE number NOT IN ( '0', ''))
	END

	------------------ END
	
	----------------- Language Population 
	SELECT @Subtit_Language_Code = LTRIM(RTRIM(@Subtit_Language_Code)), @Title_Language_Code = LTRIM(RTRIM(@Title_Language_Code)), @Dubbing_Language_Code = LTRIM(RTRIM(@Dubbing_Language_Code))
		
	SELECT number INTO #Temp_Title_Language_Neo FROM dbo.fn_Split_withdelemiter(@Title_Language_Code,',') WHERE number NOT IN('0', '')
			
	CREATE TABLE #Temp_Language_Neo(
		Language_Code INT,
		Language_Type CHAR(1)
	)

	INSERT INTO #Temp_Language_Neo
	SELECT REPLACE(number, 'L', ''), 'S'  FROM fn_Split_withdelemiter(@Subtit_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	INSERT INTO #Temp_Language_Neo
	SELECT REPLACE(number, 'L', ''), 'D'  FROM fn_Split_withdelemiter(@Dubbing_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	SELECT CAST(number AS INT) SubLicense_Code INTO #Tmp_SL_Neo FROM fn_Split_withdelemiter(@SubLicense_Code, ',') WHERE number NOT IN('0', '')

	------------------ END

	DELETE FROM #Temp_Country_Neo WHERE Country_Code = 0
	DELETE FROM #Temp_Language_Neo WHERE Language_Code = 0
	DELETE FROM #Temp_Title_Neo WHERE Title_Code = 0
	DELETE FROM #Temp_Platform_Neo WHERE number = 0
	DELETE FROM #Temp_Title_Language_Neo WHERE number = 0
		
	IF NOT EXISTS(SELECT * FROM #Temp_Country_Neo)
	BEGIN
		INSERT INTO #Temp_Country_Neo
		SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active, 'N') = 'Y' and c.Country_Code <> 3
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Language_Neo WHERE Language_Type = 'S')
	BEGIN
		INSERT INTO #Temp_Language_Neo
		SELECT Language_Code, 'S' FROM Language
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Language_Neo WHERE Language_Type = 'D')
	BEGIN
		INSERT INTO #Temp_Language_Neo
		SELECT Language_Code, 'D' FROM Language 
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Title_Neo)
	BEGIN
		INSERT INTO #Temp_Title_Neo
		SELECT DISTINCT Title_Code FROM Acq_Deal_Movie
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Title_Language_Neo)
	BEGIN
		INSERT INTO #Temp_Title_Language_Neo
		SELECT Language_Code FROM Language
	END
		
	IF NOT EXISTS(SELECT * FROM #Temp_Platform_Neo)
	BEGIN
		INSERT INTO #Temp_Platform_Neo (number)
		SELECT Platform_Code FROM Platform WHERE Is_Last_Level = 'Y'
	END
	
	IF NOT EXISTS(SELECT * FROM #Tmp_SL_Neo)
	BEGIN
		INSERT INTO #Tmp_SL_Neo
		SELECT Sub_License_Code FROM Sub_License
	END
	END

	PRINT 'PA-STEP-2 Populate @Temp_Right ' + convert(varchar(30),getdate() ,109)
	BEGIN
	-----------------Query to get rights information related to title
	CREATE TABLE #Temp_Right_Neo 
	(
		Acq_Deal_Code INT, 
		Acq_Deal_Rights_Code INT, 
		Restriction_Remarks NVARCHAR(MAX), 
		Platform_Code INT, 
		Title_Code INT,
		Is_Master_Deal CHAR(1), 
		Remarks NVARCHAR(4000), 
		Rights_Remarks NVARCHAR(4000),
		Sub_Deal_Restriction_Remark NVARCHAR(MAX), 
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Is_Exclusive CHAR(1),
		Sub_License_Code INT,
		Episode_From INT,
		Episode_To INT,
		Is_Title_Language_Right CHAR(1)

	)

	
	INSERT INTO #Temp_Right_Neo(Acq_Deal_Code, Acq_Deal_Rights_Code, Restriction_Remarks, Platform_Code, Title_Code,
		   Is_Master_Deal, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From, Episode_To, Is_Title_Language_Right)
	SELECT ar.Acq_Deal_Code, ar.Acq_Deal_Rights_Code, ar.Restriction_Remarks, adrp.Platform_Code, ADRT.Title_Code,
		   ad.Is_Master_Deal, ad.Remarks, ad.Rights_Remarks, 
		   (STUFF((
			SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
			FROM Acq_Deal AD_Tmp
			INNER JOIN Acq_Deal_Rights ADR_Tmp ON adr_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
			WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
			(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = ad.Acq_Deal_Code)
			FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,'')) 
			, ar.Actual_Right_Start_Date, ar.Actual_Right_End_Date
			,ar.Is_Exclusive, ISNULL(ar.Sub_License_Code, 0)
			, adrt.Episode_From, adrt.Episode_To, ar.Is_Title_Language_Right
	FROM Acq_Deal_Rights AS ar
	INNER JOIN Acq_Deal_Rights_Platform AS adrp ON adrp.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights_Title AS adrt ON adrt.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal ad ON ar.Acq_Deal_Code = ad.Acq_Deal_Code
	WHERE 
	ad.Is_Master_Deal = 'Y'
	AND ar.Is_Tentative = 'N'
	AND (ar.Is_Sub_License = @Is_SubLicense OR @Is_SubLicense = '')
	AND adrt.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title_Neo tt)
	AND adrp.Platform_Code IN (SELECT number FROM #Temp_Platform_Neo) 
	AND ((ar.Sub_License_Code IN (SELECT SubLicense_Code  FROM #Tmp_SL_Neo) AND @Is_SubLicense = 'Y') OR @Is_SubLicense = 'N' OR @Is_SubLicense = '')
	AND (ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0)
	AND ((ad.Deal_Workflow_Status = @Is_Approved) OR @Is_Approved = '')
	AND (ad.Deal_Type_Code = @Deal_Type_Code OR (ad.Deal_Type_Code <> 1 AND @Deal_Type_Code <> 1) OR @Deal_Type_Code=0)
	AND (
		adrt.Episode_From Between @Episode_From And @Episode_To Or
		adrt.Episode_To Between @Episode_From And @Episode_To Or
		@Episode_From Between adrt.Episode_From And adrt.Episode_To Or
		@Episode_To Between adrt                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                .Episode_From And adrt.Episode_To
	)
	------------------ END
	END

	PRINT 'PA-STEP-3 Populate #Avail_Acq_Neo  ' + convert(varchar(30),getdate() ,109)
	BEGIN
	                                                                                                                                                                                                                                                                                                                                                                                                   
	-----------------Query to get Avail information related to Title ,Platform AND Country
	CREATE TABLE #Avail_Acq_Neo 
	(
		Acq_Deal_Rights_Code INT, 
		Title_Code INT,
		Platform_Code INT, 
		Country_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Is_Exclusive CHAR(1),
		Sub_License_Code INT,
		Episode_From INT,
		Episode_To INT,
		Is_Title_Language_Right CHAR(1)
	)
		
	------------------ END
	END
	
	IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
	BEGIN
		
		INSERT INTO #Avail_Acq_Neo(Acq_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code, Episode_From, Episode_To, Is_Title_Language_Right)
		SELECT DISTINCT tr.Acq_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
					   CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
					   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0)
					   , Episode_From, Episode_To, tr.Is_Title_Language_Right
		FROM 
		#Temp_Right_Neo tr 
		INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title_Neo tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform_Neo) )
		AND ((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)))
		AND (ISNULL(tr.Rights_Start_Date, '9999-12-31')  <= @StartDate AND ISNULL(tr.Rights_End_Date, '9999-12-31') >=  @EndDate)
		AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	ELSE
	BEGIN

		INSERT INTO #Avail_Acq_Neo(Acq_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code, Episode_From, Episode_To, Is_Title_Language_Right)
		SELECT DISTINCT tr.Acq_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
			   CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
			   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0), Episode_From, Episode_To, tr.Is_Title_Language_Right
		FROM 
		#Temp_Right_Neo tr 
		INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title_Neo tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform_Neo) )
		AND ((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)))
		AND ((ISNULL(tr.Rights_End_Date, '9999-12-31') BETWEEN @StartDate AND  @EndDate)
			OR (ISNULL(tr.Rights_Start_Date, '9999-12-31') BETWEEN @StartDate AND @EndDate)
			OR (@StartDate BETWEEN  ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31'))
			OR (@EndDate BETWEEN ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31')))
		AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	

	PRINT 'PA-STEP-4 Populate #Avail_TitLang_Neo' + convert(varchar(30),getdate() ,109)
	BEGIN
	CREATE TABLE #Avail_TitLang_Neo 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code INT,
		Sub_License_Code INT,
		Is_Exclusive CHAR(1),
		Title_Language_Names NVARCHAR(400),
		Episode_From INT,
		Episode_To INT
	)

	CREATE TABLE #Avail_Sub_Neo 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code VARCHAR(MAX),
		Sub_License_Code INT,
		Is_Exclusive CHAR(1),
		Episode_From INT,
		Episode_To INT,
		Sub_Language_Names NVARCHAR(MAX)
	)

	CREATE TABLE #Avail_Dubb_Neo 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code VARCHAR(MAX),
		Sub_License_Code INT,
		Is_Exclusive CHAR(1),
		Episode_From INT,
		Episode_To INT,
		Dubb_Language_Names NVARCHAR(MAX)
	)
	-----------------Populate Title Avail for Title Languages
	
	CREATE INDEX IX_TMP_Avail_Acq ON #Avail_Acq_Neo(Acq_Deal_Rights_Code)
	CREATE INDEX IX_Temp_Language ON #Temp_Language_Neo(Language_Code)
		
	IF(@Is_Original_Language = 1) 
	BEGIN
			
		INSERT INTO #Avail_TitLang_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, tit.Title_Language_Code
			, AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To
		FROM #Avail_Acq_Neo AA
		INNER JOIN Title tit ON AA.Title_Code = tit.Title_Code
		INNER JOIN #Temp_Title_Language_Neo TTL ON TTL.number = tit.Title_Language_Code
		WHERE AA.Is_Title_Language_Right = 'Y'
		
	END

	PRINT 'PA-STEP-4.1 Populate #Avail_Sub_Neo  ' + convert(varchar(30),getdate() ,109)
	-----------------Populate Title Avail for Subtitling Languages
	IF EXISTS(SELECT * WHERE 'S' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))
	BEGIN
		
		Select Distinct Acq_Deal_Rights_Code, STUFF((
			Select Distinct ',' + 
			CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrs.Language_Code End AS VARCHAR) From Acq_Deal_Rights_Subtitling adrs
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code
			WHERE adrs.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
			And (
				(
					Language_Type = 'G' And lgd.Language_Code IN (
						Select tl.Language_Code From #Temp_Language_Neo TL Where TL.Language_Type = 'S'
					)
				) OR
				(
					Language_Type <> 'G' And adrs.Language_Code IN (
						Select TL1.Language_Code From #Temp_Language_Neo TL1 Where TL1.Language_Type = 'S'
					)
				)
			)
			FOR XML PATH(''),type).value('.', 'NVARCHAR(max)'),1,1,''
		)Sub_Langs InTo #Temp_Subs
		From (
			Select Distinct Acq_Deal_Rights_Code From #Avail_Acq_Neo 
		) As a
		
		print '1'
		
		INSERT INTO #Avail_Sub_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Sub_Language_Names)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		--CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
		AAS.Sub_Langs,
		AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
		FROM 
		#Temp_Subs AAS
		INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = AAS.Acq_Deal_Rights_Code
		WHERE ISNULL(AAS.Sub_Langs,'') <>''
			
		print '2'	
		Drop Table #Temp_Subs
	END

	-----------------Populate Title Avail for Dubbing Languages
	PRINT 'PA-STEP-4.2 Populate #Avail_Dubb_Neo  ' + convert(varchar(30),getdate() ,109)
	--RETURN
	IF(EXISTS(SELECT * WHERE 'D' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling,','))))
	BEGIN
				
		Select Distinct Acq_Deal_Rights_Code, STUFF((
			Select Distinct ',' + 
			CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrd.Language_Code End AS VARCHAR) From Acq_Deal_Rights_Dubbing adrd
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrd.Language_Group_Code
			WHERE adrd.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
			And (
				(
					Language_Type = 'G' And lgd.Language_Code IN (
						Select tl.Language_Code From #Temp_Language_Neo TL Where TL.Language_Type = 'D'
					)
				) OR
				(
					Language_Type <> 'G' And adrd.Language_Code IN (
						Select TL1.Language_Code From #Temp_Language_Neo TL1 Where TL1.Language_Type = 'D'
					)
				)
			)
			FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
		)Dub_Langs InTo #Temp_Dubs
		From (
			Select Distinct Acq_Deal_Rights_Code From #Avail_Acq_Neo 
		) As a		
		
		INSERT INTO #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Dubb_Language_Names)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		--CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
		AAD.Dub_Langs,
		AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
		FROM 
		#Temp_Dubs AAD
		INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = AAD.Acq_Deal_Rights_Code
		WHERE ISNULL(AAD.Dub_Langs,'') <>''
			
		print '2'	
		Drop Table #Temp_Dubs		
				
		--INSERT INTO #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To)
		--SELECT DISTINCT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		--CASE WHEN aaD.Language_Type= 'G' THEN lgd.Language_Code ELSE AAD.Language_Code END ,
		--AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To
		--FROM 
		--Acq_Deal_Rights_Dubbing AAD
		--INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = AAD.Acq_Deal_Rights_Code
		--LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = aad.Language_Group_Code AND AAD.Language_Type= 'G' 
		--INNER JOIN #Temp_Language_Neo TL ON 
		--((TL.Language_Code = AAD.Language_Code AND AAD.Language_Type = 'L') OR (TL.Language_Code = lgd.Language_Code AND aaD.Language_Type = 'G'))
		--AND TL.Language_Type = 'D'

	END
	

	CREATE INDEX IX_Avail_TitLang ON #Avail_TitLang_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Dubb ON #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Sub ON #Avail_Sub_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)

	PRINT 'PA-STEP-5 UPDATE Subtitling Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1_Neo, #Avail_Dubb_V1_Neo ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	--SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Sub_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Sub_Language_Names,
	--Episode_From, Episode_To
	--INTO #Avail_Sub_V1_Neo
	--FROM (
	--	SELECT a.* ,
	--	STUFF
	--	(
	--		(
	--			SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Sub_Neo b
	--			WHERE a.Acq_Deal_Rights_Code = b.Acq_Deal_Rights_Code
	--				AND a.Rights_Start_Date = b.Rights_Start_Date 
	--				AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
	--				AND a.Is_Exclusive = b.Is_Exclusive
	--				AND ISNULL(a.Sub_License_Code, 0) = ISNULL(b.Sub_License_Code, 0)
	--				AND ISNULL(a.Episode_From, 0) = ISNULL(b.Episode_From, 0)
	--				AND ISNULL(a.Episode_To, 0) = ISNULL(b.Episode_To, 0)
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	) Sub_Language_Codes
	--	FROM (
	--		SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From,  Episode_To
	--		FROM #Avail_Sub_Neo
	--	) AS a
	--) AS MainOutput

	--DROP TABLE #Avail_Sub_Neo

	PRINT 'PA-STEP-5 UPDATE Dubbing Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1_Neo, #Avail_Dubb_V1_Neo ' + convert(varchar(30),getdate() ,109)
	--SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Dubb_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Dubb_Language_Names
	--,Episode_From, Episode_To
	--INTO #Avail_Dubb_V1_Neo
	--FROM (
	--	SELECT a.* ,
	--	STUFF
	--	(
	--		(
	--			SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Dubb_Neo b
	--			WHERE a.Acq_Deal_Rights_Code = b.Acq_Deal_Rights_Code
	--				AND a.Rights_Start_Date = b.Rights_Start_Date 
	--				AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
	--				AND a.Is_Exclusive = b.Is_Exclusive
	--				AND ISNULL(a.Sub_License_Code, 0) = ISNULL(b.Sub_License_Code, 0)
	--				AND ISNULL(a.Episode_From, 0) = ISNULL(b.Episode_From, 0)
	--				AND ISNULL(a.Episode_To, 0) = ISNULL(b.Episode_To, 0)
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	) Dubb_Language_Codes
	--	FROM (
	--		SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From,  Episode_To
	--		FROM #Avail_Dubb_Neo
	--	) AS a
	--) AS MainOutput
	
	END

	--DROP TABLE #Avail_Dubb_Neo

	print 'PA-STEP-6 UPDATE Language Names in  in #Avail_TitLang_V1, #Avail_Sub_V1_Neo, #Avail_Dubb_V1_Neo  ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		-----------------Get Language Names for #Temp_Main
		CREATE TABLE #Temp_Language_Names_Neo(
			Language_Codes VARCHAR(MAX),
			Language_Names NVARCHAR(MAX)
		)

		--INSERT INTO #Temp_Language_Names_Neo(Language_Codes)
		--SELECT DISTINCT Language_Code FROM #Avail_TitLang_Neo
	
		INSERT INTO #Temp_Language_Names_Neo(Language_Codes)
		SELECT DISTINCT Language_Code FROM #Avail_Sub_Neo
		
	
		INSERT INTO #Temp_Language_Names_Neo(Language_Codes)
		SELECT DISTINCT Language_Code FROM #Avail_Dubb_Neo WHERE Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  NOT IN (
			SELECT Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  FROM #Temp_Language_Names_Neo
		)

		UPDATE #Temp_Language_Names_Neo SET Language_Names = [dbo].[UFN_Get_Language_With_Parent](Language_Codes)
	
		UPDATE tm SET tm.Title_Language_Names = lang.Language_Name
		FROM #Avail_TitLang_Neo tm 
		INNER JOIN Language lang ON tm.Language_Code = lang.Language_Code

		UPDATE tm SET tm.Sub_Language_Names = tml.Language_Names FROM #Avail_Sub_Neo tm 
		INNER JOIN #Temp_Language_Names_Neo tml ON tm.Language_Code  COLLATE SQL_Latin1_General_CP1_CI_AS = tml.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

		UPDATE tm SET tm.Dubb_Language_Names = tml.Language_Names FROM #Avail_Dubb_Neo tm 
		INNER JOIN #Temp_Language_Names_Neo tml ON tm.Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  = tml.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

	END
	
	PRINT 'PA-STEP-7 Populate #Temp_Dates ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	CREATE INDEX IX_Avail_Dubb_V1 ON #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Sub_V1 ON #Avail_Sub_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	
	CREATE TABLE #Temp_Dates
	(
		Acq_Deal_Rights_Code INT, 
		Right_Start_Date DATETIME, 
		Rights_End_Date DATETIME, 
		Is_Exclusive  CHAR(1),
		Sub_License_Code INT,
		Episode_From INT,
		Episode_To INT
	)

	INSERT INTO #Temp_Dates (Acq_Deal_Rights_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code ,Episode_From, Episode_To)
	SELECT AT.Acq_Deal_Rights_Code, AT.Rights_Start_Date, AT.Rights_End_Date, At.Is_Exclusive, AT.Sub_License_Code , AT.Episode_From, AT.Episode_To
	FROM #Avail_TitLang_Neo AT
	UNION 
	SELECT ASUB.Acq_Deal_Rights_Code, ASUB.Rights_Start_Date, ASUB.Rights_End_Date, ASUB.Is_Exclusive, ASUB.Sub_License_Code , ASUB.Episode_From, ASUB.Episode_To
	FROM #Avail_Sub_Neo ASUB 
	UNION
	SELECT ADUB.Acq_Deal_Rights_Code, ADUB.Rights_Start_Date, ADUB.Rights_End_Date, ADUB.Is_Exclusive, ADUB.Sub_License_Code , ADUB.Episode_From, ADUB.Episode_To
	FROM #Avail_Dubb_Neo ADUB 
	END
		
	PRINT 'PA-STEP-8 Populate #Temp_Main ' + convert(varchar(30),getdate() ,109)
	BEGIN

	CREATE INDEX IX_Temp_Dates ON #Temp_Dates(Acq_Deal_Rights_Code)

	SELECT AA.Acq_Deal_Rights_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code, TD.Right_Start_Date, TD.Rights_End_Date, TD.Is_Exclusive, TD.Sub_License_Code
	,AA.Episode_From, AA.Episode_To, CAST('' AS VARCHAR(2000)) AS Country_Cd_Str ,
	CAST('' AS CHAR(1)) AS Region_Type , CAST('' AS VARCHAR(2000)) AS Country_Names 
	INTO #TMP_MAIN
	FROM #Temp_Dates TD
	INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = TD.Acq_Deal_Rights_Code
	END

	DROP TABLE #Temp_Dates

	PRINT 'PA-STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	--ALTER TABLE #TMP_MAIN ADD Country_Cd_Str VARCHAR(2000),
	--					  Region_Type CHAR(1),
	--					  Country_Names VARCHAR(2000)
	
	
	UPDATE t2
	SET t2.Country_Cd_Str =  STUFF
	(
		(
			SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #TMP_MAIN t1 
			WHERE t1.Title_Code = t2.Title_Code
				  AND t1.Platform_Code = t2.Platform_Code
				  AND t1.Right_Start_Date = t2.Right_Start_Date
				  AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')
				  AND t1.Is_Exclusive = t2.Is_Exclusive
				  AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
				  AND ISNULL(t1.Episode_From, 0) = ISNULL(t2.Episode_From, 0)
				  AND ISNULL(t1.Episode_To, 0) = ISNULL(t2.Episode_To, 0)
			FOR XML PATH('')
		), 1, 1, ''
	)
	FROM #TMP_MAIN t2
	

	CREATE TABLE #Temp_Country_Names_Neo(
		Territory_Code INT,
		Country_Cd INT,
		Country_Codes VARCHAR(2000),
		Country_Names NVARCHAR(MAX)
	)
	
	INSERT INTO #Temp_Country_Names_Neo(Country_Codes, Country_Names)
	SELECT DISTINCT Country_Cd_Str, NULL FROM #TMP_MAIN
	
	
	--SELECT * FROM #Temp_Country_Names_Neo
	PRINT 'PA-STEP-9.1- Country Exact Match ' + convert(varchar(30),getdate() ,109)
	-----------------IF Country = Exact Match
	IF(UPPER(@Region_ExactMatch) = 'EM')
	BEGIN
			
		DECLARE @CntryStr VARCHAR(1000) = ''
		SELECT @CntryStr = 
		STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #Temp_Country_Neo
				FOR XML PATH('')
			), 1, 1, ''
		)
			
		DELETE FROM #TMP_MAIN WHERE Country_Cd_Str <> @CntryStr
				
	END
	
	PRINT 'PA-STEP-9.2- Country Must Have ' + convert(varchar(30),getdate() ,109)
	-----------------IF Country = Must Have
	IF(UPPER(@Region_ExactMatch) = 'MH')
	BEGIN
		
		TRUNCATE TABLE #Temp_Country_Neo

		DECLARE @Cntry_MustHaveCnt INT = 0
		
		INSERT INTO #Temp_Country_Neo
		SELECT number FROM dbo.fn_Split_withdelemiter(@Region_MustHave, ',') WHERE number NOT IN ('', '0')
		
		SELECT @Cntry_MustHaveCnt = COUNT(*) FROM #Temp_Country_Neo
				
		DELETE TM 
		FROM 
		#Temp_Country_Names_Neo TM WHERE TM.Country_Codes NOT IN
		(SELECT DISTINCT 
			Country_Codes  
		FROM #Temp_Country_Names_Neo tm
		WHERE 
			(SELECT COUNT(number) 
			FROM dbo.fn_Split_withdelemiter(Country_Codes, ',') 
			WHERE number NOT IN ('', '0') 
			AND number IN (SELECT c.Country_Code FROM #Temp_Country_Neo c)) >= @Cntry_MustHaveCnt	
		)
		
		DELETE FROM #TMP_MAIN WHERE Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS FROM #Temp_Country_Names_Neo)
	END
	
	PRINT 'PA-STEP-9.3- Country Names ' + convert(NVARCHAR(30),getdate() ,109)
	-----------------UPDATE Country / Territory Names
	
	UPDATE #Temp_Country_Names_Neo SET Country_Names = [dbo].[UFN_Get_Territory](Country_Codes)
	
	print '1'
	UPDATE tmc SET tmc.Territory_Code = ter.Territory_Code FROM Territory ter 
	INNER JOIN #Temp_Country_Names_Neo tmc ON ter.Territory_Name COLLATE SQL_Latin1_General_CP1_CI_AS = tmc.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS  AND ISNULL(tmc.Country_Names, '') <> ''

	UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'T', tm.Country_Code = tmc.Territory_Code
	FROM #TMP_MAIN tm 
	INNER JOIN #Temp_Country_Names_Neo tmc ON tm.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS = tmc.Country_Codes  COLLATE SQL_Latin1_General_CP1_CI_AS  AND ISNULL(tmc.Country_Names, '') <> ''

	print '2'
	TRUNCATE TABLE #Temp_Country_Names_Neo
	
	INSERT INTO #Temp_Country_Names_Neo(Country_Cd)
	SELECT DISTINCT Country_Code FROM #TMP_MAIN Where ISNULL(Country_Names, '') = ''
	
	UPDATE tmc SET tmc.Country_Names = cur.Country_Name FROM Country cur
	INNER JOIN #Temp_Country_Names_Neo tmc ON cur.Country_Code = tmc.Country_Cd

	UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'C' FROM #TMP_MAIN tm 
	INNER JOIN #Temp_Country_Names_Neo tmc ON tm.Country_Code = tmc.Country_Cd AND ISNULL(tm.Country_Names, '') = '' AND ISNULL(Region_Type, '') <> 'T' 
	
	PRINT 'PA-STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
	---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS

	SELECT Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, 
						   Platform_Code, Country_Cd_Str, Country_Names, Region_Type , Episode_From, Episode_To
	INTO #Temp_Main_Ctr_Neo
	FROM (
		SELECT ROW_NUMBER() OVER(
									PARTITION BY Acq_Deal_Rights_Code ,Title_Code, Platform_Code, Country_Code, Region_Type, 
									Right_Start_Date, Rights_End_Date
									, Is_Exclusive, Sub_License_Code
									ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type DESC
								) RowId, * 
		FROM #TMP_MAIN tm
	) AS a WHERE RowId = 1
	
	---------- END

	--DROP TABLE #TMP_MAIN
	
	END
	
	ALTER TABLE #Temp_Main_Ctr_Neo ADD Platform_Str VARCHAR(2000)
	
	PRINT 'PA-STEP-10- Platform Must Have / Exact Match ' + convert(varchar(30),getdate() ,109)
	BEGIN
	IF(UPPER(@Platform_ExactMatch) = 'EM' OR UPPER(@Platform_ExactMatch) = 'MH')
	BEGIN
		UPDATE t2
		SET t2.Platform_Str =  STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Platform_Code As Varchar) FROM #Temp_Main_Ctr_Neo t1 
				Where t1.Right_Start_Date = t2.Right_Start_Date
					AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')		
					AND t1.Title_Code = t2.Title_Code
					AND ISNULL(t1.Country_Cd_Str, 0) = ISNULL(t2.Country_Cd_Str, 0)
					AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
					AND t1.Is_Exclusive = t2.Is_Exclusive
					--AND t1.Country_Code = t2.Country_Code
					AND ISNULL(t1.Episode_From, 0) = ISNULL(t2.Episode_From, 0)
				    AND ISNULL(t1.Episode_To, 0) = ISNULL(t2.Episode_To, 0)
				FOR XML PATH('')
			), 1, 1, ''
		)
		FROM #Temp_Main_Ctr_Neo t2
	
		IF(UPPER(@Platform_ExactMatch) = 'EM')
		BEGIN
			
			DECLARE @PlStr VARCHAR(1000) = ''
			SELECT @PlStr = 
				STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(number AS VARCHAR) FROM #Temp_Platform_Neo
						FOR XML PATH('')
					), 1, 1, ''
			   ) 

			DELETE FROM #Temp_Main_Ctr_Neo WHERE Platform_Str <> @PlStr
			--UPDATE #Temp_Main_Ctr_Neo SET Platform_Code = 0
		END

		-----------------IF Platform = Must Have
		IF(UPPER(@Platform_ExactMatch) = 'MH')
		BEGIN
	
			TRUNCATE TABLE #Temp_Platform_Neo
			DECLARE @MustHaveCnt INT = 0

			INSERT INTO #Temp_Platform_Neo
			SELECT number FROM dbo.fn_Split_withdelemiter(@MustHave_Platform, ',') WHERE number NOT IN ('', '0')

			print '--------------1'
			SELECT @MustHaveCnt = COUNT(*) FROM #Temp_Platform_Neo
				
			SELECT DISTINCT Platform_Str
			INTO #Temp_Plt_Names
			FROM #Temp_Main_Ctr_Neo tm
				

			DELETE TM 
			FROM 
			#Temp_Plt_Names TM
			WHERE TM.Platform_Str NOT IN
			(SELECT DISTINCT Platform_Str
			FROM #Temp_Plt_Names tm
			WHERE 
				(SELECT COUNT(number) 
				FROM dbo.fn_Split_withdelemiter(Platform_Str, ',') 
				WHERE number NOT IN ('', '0') 
				AND number IN (SELECT p.number FROM #Temp_Platform_Neo p))>= @MustHaveCnt	
			)
		
			DELETE FROM #Temp_Main_Ctr_Neo WHERE Platform_Str NOT IN (SELECT tpn.Platform_Str FROM #Temp_Plt_Names tpn)
		print '--------------2'
		END
		END
	END

	print 'PA-STEP-11 UPDATE LANGUAGE Names in #Temp_Main_Ctr_Neo' + convert(varchar(30),getdate() ,109)	
	BEGIN		

	ALTER TABLE #Temp_Main_Ctr_Neo 
	ADD Title_Language_Names NVARCHAR(2000),
		Sub_Language_Names NVARCHAR(2000),
		Dub_Language_Names NVARCHAR(2000)
	
	
	UPDATE tms
	SET tms.Title_Language_Names = at.Title_Language_Names
	FROM #Temp_Main_Ctr_Neo tms
	INNER JOIN #Avail_TitLang_Neo at ON at.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND at.Rights_Start_Date  = tms.Right_Start_Date
		AND IsNull(at.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND at.Is_Exclusive  = tms.Is_Exclusive
		AND at.Sub_License_Code  = tms.Sub_License_Code
				
	

	UPDATE tms
	SET tms.Sub_Language_Names = asub.Sub_Language_Names
	FROM #Temp_Main_Ctr_Neo tms
	INNER JOIN #Avail_Sub_Neo asub ON asub.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND asub.Rights_Start_Date  = tms.Right_Start_Date
		AND IsNull(asub.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND asub.Is_Exclusive  = tms.Is_Exclusive
		AND asub.Sub_License_Code  = tms.Sub_License_Code

	UPDATE tms
	SET tms.Dub_Language_Names = ad.Dubb_Language_Names
	FROM #Temp_Main_Ctr_Neo tms
	INNER JOIN #Avail_Dubb_Neo ad ON ad.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND ad.Rights_Start_Date  = tms.Right_Start_Date
		AND IsNull(ad.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND ad.Is_Exclusive  = tms.Is_Exclusive
		AND ad.Sub_License_Code  = tms.Sub_License_Code
   END		
   
   DROP TABLE #Avail_Sub_Neo
   DROP TABLE #Avail_Dubb_Neo
	print 'PA-STEP-12 Query to get title details' + convert(varchar(30),getdate() ,109)	
	BEGIN
		-----------------Query to get title details
		SELECT t.Title_Code, t.Title_Language_Code, 
		--t.Title_Name
		CASE WHEN ISNULL(Year_Of_Production, '') = '' THEN Title_Name ELSE Title_Name + ' ('+ CAST(Year_Of_Production AS VARCHAR(10)) + ')' END Title_Name
		,
			Genres_Name = [dbo].[UFN_GetGenresForTitle](t.Title_Code),
			Star_Cast = [dbo].[UFN_GetStarCastForTitle](t.Title_Code),
			Director = [dbo].[UFN_GetDirectorForTitle](t.Title_Code),
			COALESCE(t.Duration_In_Min, '0') Duration_In_Min, COALESCE(t.Year_Of_Production, '') Year_Of_Production 
		INTO #Temp_Titles_Neo
		FROM Title t 
		WHERE(t.Title_Code IN (SELECT tm.Title_Code FROM #Temp_Main_Ctr_Neo tm))
		------------------END
	END

	print 'PA-STEP-13 Restrication Remarks' + convert(varchar(30),getdate() ,109)	
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN
		SELECT DISTINCT Acq_Deal_Rights_Code, Remarks, Rights_Remarks, 
				Restriction_Remarks,
				Sub_Deal_Restriction_Remark
		INTO #Temp_Right_Remarks
		FROM #Temp_Right_Neo

		--Select * from #Temp_Right_Remarks
	END

	DROP TABLE #Temp_Country_Names_Neo
	DROP TABLE #Temp_Language_Names_Neo
		
	UPDATE #Temp_Main_Ctr_Neo SET Right_Start_Date = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE Right_Start_Date < GETDATE()

	print 'PA-STEP-13 .1'
	------------------ Final Output
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN

	print 'PA-STEP-13 .1.1'
	SELECT DISTINCT 
			trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Country_Names AS Country_Name, 
			CAST(tm.Right_Start_Date AS DATETIME) Rights_Start_Date, 
			CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Title_Language_Names, Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark,
			trr.Remarks, trr.Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
			--,tm.Episode_From, tm.Episode_To
			,Case When tm.Episode_From < @Episode_From Then @Episode_From  Else tm.Episode_From End As Episode_From, 
			Case When tm.Episode_To > @Episode_To Then @Episode_To Else tm.Episode_To End As Episode_To

		FROM 
			#Temp_Main_Ctr_Neo tm
			INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = tm.Acq_Deal_Rights_Code
			INNER JOIN #Temp_Titles_Neo trt ON trt.Title_Code = tm.Title_Code
			INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
			LEFT JOIN Sub_License sl ON tm.Sub_License_Code = sl.Sub_License_Code

		DROP TABLE #Temp_Right_Remarks
	END
	ELSE
	BEGIN
	
	print 'PA-STEP-13 .1.2'
		SELECT DISTINCT 
			trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Country_Names AS Country_Name, 
			CAST(tm.Right_Start_Date AS DATETIME) Rights_Start_Date, 
			CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Title_Language_Names , Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			'' Restriction_Remark, '' Sub_Deal_Restriction_Remark,
			'' Remarks, '' Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
			--,tm.Episode_From
			--, tm.Episode_To
			,Case When tm.Episode_From < @Episode_From Then @Episode_From  Else tm.Episode_From End As Episode_From, 
			Case When tm.Episode_To > @Episode_To Then @Episode_To Else tm.Episode_To End As Episode_To
		FROM #Temp_Main_Ctr_Neo tm
		INNER JOIN #Temp_Titles_Neo trt ON trt.Title_Code = tm.Title_Code
		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		LEFT JOIN Sub_License sl ON ISNULL(tm.Sub_License_Code, 0) = ISNULL(sl.Sub_License_Code, 0)
	END
	------------------ END
	
	print 'PA-STEP-14 Proc Exceuted'

	DROP TABLE #Temp_Title_Neo
	DROP TABLE #Temp_Main_Ctr_Neo
	DROP TABLE #Temp_Titles_Neo
	DROP TABLE #Temp_Right_Neo
	DROP TABLE #Temp_Country_Neo
	DROP TABLE #Temp_Platform_Neo
	DROP TABLE #Temp_Title_Language_Neo
	DROP TABLE #Temp_Language_Neo
	DROP TABLE #Avail_Acq_Neo
	DROP TABLE #Avail_TitLang_Neo
END


	IF OBJECT_ID('tempdb..#Avail_Acq_Neo') IS NOT NULL DROP TABLE #Avail_Acq_Neo
	IF OBJECT_ID('tempdb..#Avail_Dubb_Neo') IS NOT NULL DROP TABLE #Avail_Dubb_Neo
	IF OBJECT_ID('tempdb..#Avail_Dubb_V1_Neo') IS NOT NULL DROP TABLE #Avail_Dubb_V1_Neo
	IF OBJECT_ID('tempdb..#Avail_Sub_Neo') IS NOT NULL DROP TABLE #Avail_Sub_Neo
	IF OBJECT_ID('tempdb..#Avail_Sub_V1_Neo') IS NOT NULL DROP TABLE #Avail_Sub_V1_Neo
	IF OBJECT_ID('tempdb..#Avail_Sub_V1_Neo') IS NOT NULL DROP TABLE #Avail_Sub_V1_Neo
	IF OBJECT_ID('tempdb..#Avail_TitLang_Neo') IS NOT NULL DROP TABLE #Avail_TitLang_Neo
	IF OBJECT_ID('tempdb..#Avail_TitLang_V1') IS NOT NULL DROP TABLE #Avail_TitLang_V1
	IF OBJECT_ID('tempdb..#Temp_Country_Names_Neo') IS NOT NULL DROP TABLE #Temp_Country_Names_Neo
	IF OBJECT_ID('tempdb..#Temp_Country_Neo') IS NOT NULL DROP TABLE #Temp_Country_Neo
	IF OBJECT_ID('tempdb..#Temp_Dates') IS NOT NULL DROP TABLE #Temp_Dates
	IF OBJECT_ID('tempdb..#Temp_Dubs') IS NOT NULL DROP TABLE #Temp_Dubs
	IF OBJECT_ID('tempdb..#Temp_Language_Names_Neo') IS NOT NULL DROP TABLE #Temp_Language_Names_Neo
	IF OBJECT_ID('tempdb..#Temp_Language_Neo') IS NOT NULL DROP TABLE #Temp_Language_Neo
	IF OBJECT_ID('tempdb..#Temp_Main') IS NOT NULL DROP TABLE #Temp_Main
	IF OBJECT_ID('tempdb..#Temp_Main_Ctr_Neo') IS NOT NULL DROP TABLE #Temp_Main_Ctr_Neo
	IF OBJECT_ID('tempdb..#Temp_Platform_Neo') IS NOT NULL DROP TABLE #Temp_Platform_Neo
	IF OBJECT_ID('tempdb..#Temp_Plt_Names') IS NOT NULL DROP TABLE #Temp_Plt_Names
	IF OBJECT_ID('tempdb..#Temp_Right_Neo') IS NOT NULL DROP TABLE #Temp_Right_Neo
	IF OBJECT_ID('tempdb..#Temp_Right_Remarks') IS NOT NULL DROP TABLE #Temp_Right_Remarks
	IF OBJECT_ID('tempdb..#Temp_Subs') IS NOT NULL DROP TABLE #Temp_Subs
	IF OBJECT_ID('tempdb..#Temp_Title_Language_Neo') IS NOT NULL DROP TABLE #Temp_Title_Language_Neo
	IF OBJECT_ID('tempdb..#Temp_Title_Neo') IS NOT NULL DROP TABLE #Temp_Title_Neo
	IF OBJECT_ID('tempdb..#Temp_Titles_Neo') IS NOT NULL DROP TABLE #Temp_Titles_Neo
	IF OBJECT_ID('tempdb..#TMP_MAIN') IS NOT NULL DROP TABLE #TMP_MAIN
	IF OBJECT_ID('tempdb..#Tmp_SL_Neo') IS NOT NULL DROP TABLE #Tmp_SL_Neo
END
GO
PRINT N'Altering [dbo].[USP_SendMail_Intimation_New]...';


GO
ALTER PROCEDURE [dbo].[USP_SendMail_Intimation_New]
	@RecordCode INT,
	@module_workflow_detail_code INT,
	@module_code INT,
	@RedirectToApprovalList VARCHAR(100),
	@AutoLoginUser VARCHAR(100),
	@Is_Error CHAR(1) OUTPUT
AS  
-- =============================================  
-- Author:  Dadasaheb G. Karande  
-- Create date: 03-FEB-2011  
-- Description: To Send mail to a Last All approver after the Aquisition Or Syndication deal   
--    is approve from user  
-- =============================================  
BEGIN  

	--DECLARE 
	--@RecordCode INT =21617,
	--@module_workflow_detail_code INT = 37243,
	--@module_code INT = 30,
	--@RedirectToApprovalList VARCHAR(100)='',
	--@AutoLoginUser VARCHAR(100) = 203,
	--@Is_Error CHAR(1) = 'N'

	SET NOCOUNT ON; 
	SET @Is_Error='N'  

	IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

	BEGIN TRY
		DECLARE @Approved_by VARCHAR(MAX) SET @Approved_by=''
		DECLARE @cur_first_name NVARCHAR(500)
		DECLARE @cur_security_group_name NVARCHAR(500)
		DECLARE @cur_email_id VARCHAR(500)
		DECLARE @cur_security_group_code VARCHAR(500)
		DECLARE @cur_user_code INT
		DECLARE @cur_next_level_group INT

		DECLARE @DealType VARCHAR(100) = ''
		DECLARE @DealNo VARCHAR(500) = 0
		DECLARE @body1 NVARCHAR(MAX) = ''
		DECLARE @MailSubjectCr NVARCHAR(500)  
		DECLARE @CC VARCHAR(MAX) = ''  
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)  
		DECLARE @BU_Code Int = 0
		DECLARE  @DefaultSiteUrl_Param NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl VARCHAR(500) SET @DefaultSiteUrl = ''  
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='AIN'

		SELECT @Approved_by = --ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') 
		ISNULL(UPPER(LEFT(U.First_Name,1))+LOWER(SUBSTRING(U.First_Name,2,LEN(U.First_Name))), '') 
		+ ' ' + ISNULL(UPPER(LEFT(U.Middle_Name,1))+LOWER(SUBSTRING(U.Middle_Name,2,LEN(U.Middle_Name))), '') 
		+ ' ' + ISNULL(UPPER(LEFT(U.Last_Name,1))+LOWER(SUBSTRING(U.Last_Name,2,LEN(U.Last_Name))), '') 
		+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
		FROM Users U  
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U.Security_Group_Code  
		WHERE Users_Code   = @AutoLoginUser 

		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param --// SET A FLAG FOR SEND MAIL TO INDIVIDUAL PERSON OR SECURITY GROUP //--  

		IF(@module_code = 30)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 35)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal  WHERE Syn_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 163)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal  WHERE Music_Deal_Code = @RecordCode 
		END

		DECLARE 
			@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', @Primary_Licensor NVARCHAR(MAX) = '', 
			@Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0 ,@BU_Name VARCHAR(MAX) = ''

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''

		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New 
			WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106),
					@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name, @BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
				WHERE Acq_Deal_Code = @RecordCode

			
				SELECT @Title_Count = COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
				WHERE Syn_Deal_Code = @RecordCode
			
				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name,@BU_Name = BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
  
		/* CHECK THAT DEAL IS APPROVED THROUGH ALL WORKFLOW LEVEL OR NOT */
		DECLARE @Is_Deal_Approved INT  = 0  
		SELECT @Is_Deal_Approved = COUNT(*) FROM Module_Workflow_Detail MWD 
		WHERE  Module_Workflow_Detail_Code IN (  
			SELECT Module_Workflow_Detail_Code FROM Module_Workflow_Detail 
			WHERE Record_Code = @RecordCode  AND Module_Code = @module_code  AND Is_Done = 'N'  
		)
   
		/* GET NEXT APPROVAL NAME */
		DECLARE @NextApprovalName NVARCHAR(500) = ''  
		SELECT @NextApprovalName = Security_Group_Name FROM Security_Group   
		WHERE Security_Group_Code IN (
			SELECT ISNULL(Next_Level_Group, 0) FROM Module_Workflow_Detail WHERE Module_Workflow_Detail_Code = @module_workflow_detail_code
		)    
    
		/* SELECT SITE URL */
		DECLARE @DefaultSiteUrlHold VARCHAR(500)
		SELECT  @DefaultSiteUrl_Param = DefaultSiteUrl , @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  

		IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

		CREATE TABLE #TempCursorOnRej (
			Email_id NVARCHAR(500),
			First_name NVARCHAR(MAX),
			Security_group_name NVARCHAR(500),
			Next_level_group INT,
			Security_group_code INT,
			User_code INT 
		)

		IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
		BEGIN
			INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
			SELECT DISTINCT U1.Email_Id, 
			ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, 
			MWD.Next_Level_Group, 
			U1.Security_Group_Code, 
			U1.Users_Code 
			FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			WHERE MWD.Is_Done = 'Y' AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode 
				  AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code
		END
		ELSE
		BEGIN
			INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
			SELECT DISTINCT U1.Email_Id, 
			ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, 
			MWD.Next_Level_Group, 
			U1.Security_Group_Code, 
			U1.Users_Code 
			FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			WHERE MWD.Is_Done = 'Y' AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode 
				  AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code
		END

		/* CURSOR START */
		DECLARE cur_on_rejection CURSOR KEYSET FOR 
		SELECT Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code FROM #TempCursorOnRej
		OPEN cur_on_rejection  
		FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, @cur_next_level_group, @cur_security_group_code, @cur_user_code  
		WHILE (@@fetch_status <> -1)  
		BEGIN  
			IF (@@fetch_status <> -2)  
			BEGIN  
				SELECT @DefaultSiteUrl  = @DefaultSiteUrlHold

				IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
				BEGIN
					SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=Y&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'
				
					select @body1 = template_desc FROM Email_template WHERE Template_For='AR'
					SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
					set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
					set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
					set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
					set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
					SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 
					
					IF (@RedirectToApprovalList = 'WA')
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Sent For Archive' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Sent For Archive by') 
					END
					ELSE IF @RedirectToApprovalList = 'AR'
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Archived' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Approved For Archived by') 
					END
					ELSE IF @RedirectToApprovalList = 'A'
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Rejected For Archive' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Rejected For Archive by') 
					END
				END
				ELSE
				BEGIN
					SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'

					IF(@Is_Deal_Approved > 0)  /* IF DEAL IS NOT APPROVED BY ALL WORKFLOW */
					BEGIN  
						print '1'
						--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) + 
						--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
						select @body1 = template_desc FROM Email_template WHERE Template_For='I'
						SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
						set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
						set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
						set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
						set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
						SET @body1 = REPLACE(@body1, '{next_approval}',@NextApprovalName) 		
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is sent for approve to next approval'   
					END  
					ELSE IF(@Is_Deal_Approved = 0) /* IF DEAL APPROVED BY ALL WORKFLOW */
					BEGIN  
						print '2'
						--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) + 
						--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
						select @body1 = template_desc FROM Email_template WHERE Template_For='D'
						SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
						set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
						set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
						set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
						set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
						SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is approved'   
					END  
				END

				DECLARE @Email_Table NVARCHAR(MAX) = '' , @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'

				SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

				IF(@Is_RU_Content_Category = 'Y')
					SET  @BU_CC= 'Content Category'

				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
					SET @Email_Table = '
					<table class="tblFormat" style="width:100%">    
						<tr>      
							<th align="center" width="14%" class="tblHead">Agreement No.</th>      
							<th align="center" width="14%" class="tblHead">Agreement Date</th>      
							<th align="center" width="19%" class="tblHead">Deal Description</th>      
							<th align="center" width="19%" class="tblHead">Primary Licensor</th>      
							<th align="center" width="25%" class="tblHead">Title(s)</th>  
							<th align="center" width="10%" class="tblHead">'+@BU_CC+'</th>
						</tr>     
						<tr>      
							<td align="center" class="tblData">{Agreement_No}</td>      
							<td align="center" class="tblData">{Agreement_Date}</td>      
							<td align="center" class="tblData">{Deal_Desc}</td>      
							<td align="center" class="tblData">{Primary_Licensor}</td>      
							<td align="center" class="tblData">{Titles}</td>     
							<td align="center" class="tblData">{BU_Name}</td>     
						</tr>   
					</table>'
				END
				ELSE
				BEGIN 
					SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
										<th align="center" width="10%" class="tblHead">Agreement No.</th>    
										<th align="center" width="10%" class="tblHead">Agreement Date</th> 
										<th align="center" width="10%" class="tblHead">Created By</th> 
										<th align="center" width="10%" class="tblHead">Creation Date</th> 
										<th align="center" width="10%" class="tblHead">Deal Description</th> 
										<th align="center" width="10%" class="tblHead">Primary Licensor</th>   
										<th align="center" width="10%" class="tblHead">Title(s)</th>
										<th align="center" width="10%" class="tblHead">'+@BU_CC+'</th>
										<th align="center" width="10%" class="tblHead">Last Actioned By</th>
										<th align="center" width="10%" class="tblHead">Last Actioned Date</th>
						 </tr>  
						 <tr>
										<td align="center" class="tblData">{Agreement_No}</td>   
										<td align="center" class="tblData">{Agreement_Date}</td>    
										<td align="center" class="tblData">{Created_By}</td>    
										<td align="center" class="tblData">{Creation_Date}</td>    
										<td align="center" class="tblData">{Deal_Desc}</td>    
										<td align="center" class="tblData">{Primary_Licensor}</td>   
										<td align="center" class="tblData">{Titles}</td> 
										<td align="center" class="tblData">{BU_Name}</td> 
										<td align="center" class="tblData">{Last_Actioned_By}</td> 
										<td align="center" class="tblData">{Last_Actioned_Date}</td> 
						</tr>  
					</table>'
				END


				print @DefaultSiteUrl
				IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
				BEGIN
					SET @body1 = replace(@body1,'{Agreement_No}',@Agreement_No)  
					SET @body1 = REPLACE(@body1,'{Agreement_Date}',@Agreement_Date)  
					SET @body1 = REPLACE(@body1,'{Deal_Desc}',@Deal_Desc)  
					SET @body1 = replace(@body1,'{Primary_Licensor}',@Primary_Licensor)  
					SET @body1 = replace(@body1,'{Titles}',@Titles)  
					SET @body1 = replace(@body1,'{BU_Name}',@BU_Name)
					SET @CC=''  
					--SET @body1 = replace(@body1,'{table}',@Email_Table)
				END
				ELSE
				BEGIN
					SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
					SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
					SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
					SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
					SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
					SET @Email_Table = replace(@Email_Table,'{BU_Name}',@BU_Name)

					IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
					BEGIN
						SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
						SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
						SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
						SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
					END

					SET @CC=''  
					SET @body1 = replace(@body1,'{table}',@Email_Table)
				END

				DECLARE @DatabaseEmail_Profile varchar(200)	= ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile  
				,@recipients =  @cur_email_id    
				,@copy_recipients = @CC  
				,@subject = @MailSubjectCr  
				,@body = @body1,@body_format = 'HTML';    

				IF (@RedirectToApprovalList = 'WA')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Waiting for Archive', @Cur_email_id
				ELSE IF (@RedirectToApprovalList = 'AR')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Archived', @Cur_email_id
				ELSE IF (@RedirectToApprovalList = 'A')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Rejected For Archive', @Cur_email_id
				ELSE
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id
				
			END  
			FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, 
			@cur_next_level_group ,@cur_security_group_code ,@cur_user_code  
		END
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
		/* CURSOR END */

    	IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

		SET @Is_Error='N'
	END TRY  	
	BEGIN CATCH  
		SET @Is_Error='Y'  
		PRINT ERROR_MESSAGE()   
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
   
		 INSERT INTO ERRORON_SENDMAIL_FOR_WORKFLOW   
		 SELECT  
			 ERROR_NUMBER() AS ERRORNUMBER,  
			 ERROR_SEVERITY() AS ERRORSEVERITY,    
			 ERROR_STATE() AS ERRORSTATE,  
			 ERROR_PROCEDURE() AS ERRORPROCEDURE,  
			 ERROR_LINE() AS ERRORLINE,  
			 ERROR_MESSAGE() AS ERRORMESSAGE;  
	END CATCH
END

--change script
--select  template_desc FROM Email_template WHERE Template_For='D'
--<html>   <head>    <style>     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     
--td.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
--font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
--font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          
--#divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />
--The {deal_type} Deal No: <b>{deal_no}</b> is approved.<br /><br />     Please <a href='{link}' target='_blank'><b>click here</b>
--</a> for more details.<br /><br /><br />    </div>    
--<table class="tblFormat" >     <tr>      
--<th align="center" width="15%" class="tblHead"><b>Agreement No.<b></th>      
--<th align="center" width="15%" class="tblHead"><b>Agreement Date<b></th>      
--<th align="center" width="20%" class="tblHead"><b>Deal Description<b></th>      
--<th align="center" width="20%" class="tblHead"><b>Primary Licensor<b></th>      
--<th align="center" width="30%" class="tblHead"><b>Title(s)<b></th>     </tr>     
--<tr>      <td align="center" class="tblData">{Agreement_No}</td>      
--<td align="center" class="tblData">{Agreement_Date}</td>      
--<td align="center" class="tblData">{Deal_Desc}</td>      
--<td align="center" class="tblData">{Primary_Licensor}</td>      
--<td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
--<br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>


--select  template_desc FROM Email_template WHERE Template_For='D'
--UPDATE Email_template SET template_desc=
--'<html><head><style>table.tblFormat{border:1px solid black;border-collapse:collapse;} th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;      font-family:verdana; font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     } #divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is approved.<br /><br />     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> for more details.<br /><br /><br />    </div>{table} <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>'
--WHERE Template_For='D'

--select template_desc FROM Email_template WHERE Template_For='I'

--<html>   <head>    <style type="text/css">     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     
--td.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
--font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
--font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          
--#divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />    
-- The {deal_type} Deal No: <b>{deal_no}</b> is sent to {next_approval} for approval.<br /><br />     Please <a href='{link}' target='_blank'>
-- <b>click here</b></a> for more details.<br /><br /><br /><br />    </div>    
 
-- <table class="tblFormat" >     <tr>      
-- <td align="center" width="15%" class="tblHead"><b>Agreement No.<b></td>      
-- <td align="center" width="15%" class="tblHead"><b>Agreement Date<b></td>      
-- <td align="center" width="20%" class="tblHead"><b>Deal Description<b></td>      
-- <td align="center" width="20%" class="tblHead"><b>Primary Licensor<b></td>      
-- <td align="center" width="30%" class="tblHead"><b>Title(s)<b></td>     </tr>     
-- <tr>      
-- <td align="center" class="tblData">{Agreement_No}</td>      
-- <td align="center" class="tblData">{Agreement_Date}</td>      
-- <td align="center" class="tblData">{Deal_Desc}</td>      
-- <td align="center" class="tblData">{Primary_Licensor}</td>      
-- <td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
 
-- <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>

--UPDATE Email_template SET template_desc =
--'<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px; font-weight:bold}td.tblData{border:1px solid black;vertical-align:top;font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head><body><div class="textFont">Dear &nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is sent to {next_approval} for approval.<br /><br />Please <a href=''{link}'' target=''_blank''> <b>click here</b></a> for more details.<br /><br /><br /><br />    </div> {table}  <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU</div></body></html>'
--WHERE Template_For='I'
--change script
GO
PRINT N'Altering [dbo].[USP_SendMail_On_Rejection]...';


GO
ALTER Procedure [dbo].[USP_SendMail_On_Rejection]   
	 @RecordCode INT,
	 @module_workflow_detail_code INT,
	 @module_code INT,
	 @RedirectToApprovalList VARCHAR(100),
	 @AutoLoginUser VARCHAR(100),
	 @Login_User INT,
	 @Is_Error CHAR(1) OUTPUT  
AS  
-- =============================================  
-- Author:		<Adesh P Arote>
-- Create date: 02-FEB-2011
-- Description: SEND MAIL TO ALL LAST APPROVER IF DEAL IS REJECT FORM ANY USER  
-- =============================================  
BEGIN  

--DECLARE 
--	 @RecordCode INT = 21617,
--	 @module_workflow_detail_code INT = 37243,
--	 @module_code INT = 30,
--	 @RedirectToApprovalList VARCHAR(100) ='N',
--	 @AutoLoginUser VARCHAR(100) ='',
--	 @Login_User INT=136,
--	 @Is_Error CHAR(1)='N'  

	SET @Is_Error='N'  
	BEGIN TRY  
		DECLARE @Rejected_by NVARCHAR(500) SET @Rejected_by=''  
		DECLARE @cur_first_name NVARCHAR(500)  
		DECLARE @cur_security_group_name NVARCHAR(500)   
		DECLARE @cur_email_id NVARCHAR(500)   
		DECLARE @cur_security_group_code VARCHAR(500)   
		DECLARE @cur_user_code INT  
		DECLARE @DealType VARCHAR(100)   
		DECLARE @DealNo VARCHAR(500) SET @DealNo=0  
		DECLARE @body1 NVARCHAR(MAX)  SET @body1 =''  
		DECLARE @MailSubjectCr NVARCHAR(500)  
		DECLARE @CC NVARCHAR(MAX)SET @CC =''  
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)
	    DECLARE	@DefaultSiteUrl_Param  NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl NVARCHAR(500) SET @DefaultSiteUrl = ''  
		DECLARE @BUCode INT = 0 
		DECLARE @Email_Table NVARCHAR(MAX) = ''
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='ARJ'
 
		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param  
  
		SELECT @Rejected_by = ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
		FROM Users U  
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U.Security_Group_Code  
		WHERE Users_Code   = @Login_User 

		IF(@module_code = 30)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 35)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal  WHERE Syn_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 163)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal  WHERE Music_Deal_Code = @RecordCode 
		END

		DECLARE 
			@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
			@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0, @BU_Name VARCHAR(MAX) = ''

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''


		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No,
					@Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Desc,
					@Primary_Licensor = V.Vendor_Name,
					@BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
				WHERE Acq_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(varchar(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
				WHERE Syn_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name, @BU_Name =BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
   
		DECLARE @DefaultSiteUrlHold NVARCHAR(500), @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'
		SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  
		SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is rejected'   

		SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

		IF(@Is_RU_Content_Category = 'Y')
			SET  @BU_CC= 'Content Category'

		/* CURSOR START */
		
		DECLARE cur_on_rejection CURSOR KEYSET FOR 
		SELECT DISTINCT ISNULL(U1.First_Name,'') + ' ' + ISNULL(U1.Middle_Name,'') + ' ' + ISNULL(U1.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')', 
			SG.Security_Group_Name, U1.Email_Id, U1.Security_Group_Code, U1.Users_Code  
		FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BUCode)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		WHERE MWD.Module_Code = @module_code 
			AND MWD.Record_Code = @RecordCode 
			AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code


		OPEN cur_on_rejection  
		FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
		WHILE (@@fetch_status <> -1)  
		BEGIN  
			IF (@@fetch_status <> -2)  
			BEGIN  
				SELECT @DefaultSiteUrl = @DefaultSiteUrlHold
				--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) +
				--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
				SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=R'
		
				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
				SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>     
										<td align="center" width="14%" class="tblHead">Agreement No.</td>    
										<td align="center" width="14%" class="tblHead">Agreement Date</td>   
										<td align="center" width="19%" class="tblHead">Deal Description</td> 
										<td align="center" width="19%" class="tblHead">Primary Licensor</td>   
										<td align="center" width="25%" class="tblHead">Title(s)</td>
										<td align="center" width="10%" class="tblHead">'+@BU_CC+'</td>
						 </tr>  
						 <tr>
										<td align="center" class="tblData">{Agreement_No}</td>   
										<td align="center" class="tblData">{Agreement_Date}</td>     
										<td align="center" class="tblData">{Deal_Desc}</td>    
										<td align="center" class="tblData">{Primary_Licensor}</td>   
										<td align="center" class="tblData">{Titles}</td> 
										<td align="center" class="tblData">{BU_Name}</td> 
						</tr>  
					</table>'
				END
				ELSE
				BEGIN 
				SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
										<td align="center" width="10%" class="tblHead">Agreement No.</td>    
										<td align="center" width="10%" class="tblHead">Agreement Date</td> 
										<td align="center" width="10%" class="tblHead">Created By</td> 
										<td align="center" width="10%" class="tblHead">Creation Date</td> 
										<td align="center" width="10%" class="tblHead">Deal Description</td> 
										<td align="center" width="10%" class="tblHead">Primary Licensor</td>   
										<td align="center" width="10%" class="tblHead">Title(s)</td>
										<td align="center" width="10%" class="tblHead">'+@BU_CC+'</td>
										<td align="center" width="10%" class="tblHead">Last Actioned By</td>
										<td align="center" width="10%" class="tblHead">Last Actioned Date</td>
						 </tr>  
						 <tr>
										<td align="center" class="tblData">{Agreement_No}</td>   
										<td align="center" class="tblData">{Agreement_Date}</td>    
										<td align="center" class="tblData">{Created_By}</td>    
										<td align="center" class="tblData">{Creation_Date}</td>    
										<td align="center" class="tblData">{Deal_Desc}</td>    
										<td align="center" class="tblData">{Primary_Licensor}</td>   
										<td align="center" class="tblData">{Titles}</td> 
										<td align="center" class="tblData">{BU_Name}</td> 
										<td align="center" class="tblData">{Last_Actioned_By}</td> 
										<td align="center" class="tblData">{Last_Actioned_Date}</td> 
						</tr>  
					</table>'
				END

				SELECT @body1 = template_desc FROM Email_Template WHERE Template_For='R'
				PRINT @DealNo  
				--REPLACE ALL THE PARAMETER VALUE  
				SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
				SET @body1 = replace(@body1,'{deal_no}',@DealNo)  
				SET @body1 = replace(@body1,'{deal_type}',@DealType)  
				SET @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
				SET @body1 = replace(@body1,'{rejected_by}',@Rejected_by) 
				 
				SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
				SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
				SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
				SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
				SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
				SET @Email_Table = replace(@Email_Table,'{BU_Name}', @BU_Name)
			
				IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
				BEGIN
					SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
					SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
				END

				SET @CC = ''  
				SET @body1 = replace(@body1,'{table}',@Email_Table)
				--IF(@Is_Mail_Send_To_Group='Y')  
				--BEGIN  
				--	SELECT @CC = @CC + ';' + Email_Id FROM Users WHERE security_group_code IN (@cur_security_group_code)   
				--	AND Users_Code NOT IN (@cur_user_code)  
				--END
  
				DECLARE @DatabaseEmail_Profile varchar(200)	= ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile, 
				@recipients =  @cur_email_id, 
				@copy_recipients = @CC, 
				@subject = @MailSubjectCr, 
				@body = @body1,@body_format = 'HTML';

				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id
			END  
			FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
		END  
  
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
		/* CURSOR END */
    
		SET @Is_Error='N'  
	END TRY  
	BEGIN CATCH		
		SET @Is_Error='Y'
		PRINT ERROR_MESSAGE()   
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
   
		INSERT INTO ERRORON_SENDMAIL_FOR_WORKFLOW   
		SELECT  
			ERROR_NUMBER() AS ERRORNUMBER,  
			ERROR_SEVERITY() AS ERRORSEVERITY,    
			ERROR_STATE() AS ERRORSTATE,  
			ERROR_PROCEDURE() AS ERRORPROCEDURE,  
			ERROR_LINE() AS ERRORLINE,  
			ERROR_MESSAGE() AS ERRORMESSAGE;  
	END CATCH  
END  

--SELECT template_desc FROM Email_Template WHERE Template_For='R'  
--<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}td.tblHead{border:1px solid black;
--color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px;}td.tblData{border:1px solid black;vertical-align:top;
--font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head>
--<body><div class="textFont">Dear&nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is rejected by <b>{rejected_by}</b>.
--<br /><br />     Please <a href='{link}' target='_blank'><b>click here</b></a> for more details.<br /><br /><br /><br />
--</div>   
-- <table class="tblFormat" >     <tr>      
-- <td align="center" width="15%" class="tblHead"><b>Agreement No.<b></td>
-- <td align="center" width="15%" class="tblHead"><b>Agreement Date<b></td>
-- <td align="center" width="20%" class="tblHead"><b>Deal Description<b></td>
-- <td align="center" width="20%" class="tblHead"><b>Primary Licensor<b></td>
-- <td align="center" width="30%" class="tblHead"><b>Title(s)<b></td>     </tr>     
-- <tr>
-- <td align="center" class="tblData">{Agreement_No}</td>
-- <td align="center" class="tblData">{Agreement_Date}</td>
-- <td align="center" class="tblData">{Deal_Desc}</td>
-- <td align="center" class="tblData">{Primary_Licensor}</td>
-- <td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
 
-- <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>

-- UPDATE Email_Template SET template_desc =
-- '<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold}td.tblData{border:1px solid black;vertical-align:top;font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head><body><div class="textFont">Dear&nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is rejected by <b>{rejected_by}</b>.<br /><br />     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> for more details.<br /><br /><br /><br /></div> {table} <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>'
--WHERE Template_For='R'
GO
PRINT N'Altering [dbo].[USP_SendMail_To_NextApprover_New]...';


GO
ALTER PROCEDURE [dbo].[USP_SendMail_To_NextApprover_New]
(
	@RecordCode Int=3
	,@Module_code Int=30
	,@RedirectToApprovalList Varchar(100)='N'
	,@AutoLoginUser Varchar(100)=143
	,@Is_Error Char(1) 	Output
)
AS
BEGIN	
	--declare
	--@RecordCode Int=21617
	--,@Module_code Int=30
	--,@RedirectToApprovalList Varchar(100)='N'
	--,@AutoLoginUser Varchar(100)=143
	--,@Is_Error Char(1) ='N'

	SET NOCOUNT ON;
	--DECLARE @Module_code INT --//--This  is a module code for Acquisition Deal	
	--SET @Module_code =30
	-- =============================================
	-- Declare and using a KEYSET cursor
	-- =============================================
	SET @Is_Error = 'N'
	BEGIN TRY

		DECLARE @Cur_first_name NVARCHAR(500)
		DECLARE @Cur_security_group_name NVARCHAR(500) 
		DECLARE @Cur_email_id NVARCHAR(500) 
		DECLARE @Cur_security_group_code NVARCHAR(500) 
		DECLARE @Cur_user_code INT

		DECLARE @DealType VARCHAR(100) 
		DECLARE @DealNo VARCHAR(500) = 0
		DECLARE @body1 NVARCHAR(MAX) = ''
		DECLARE @MailSubjectCr NVARCHAR(500)
		DECLARE @CC NVARCHAR(MAX) = ''
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)
		DECLARE @DefaultSiteUrl_Param NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl NVARCHAR(500) = ''
		DECLARE @BU_Code Int = 0
		DECLARE @Email_Table NVARCHAR(MAX) = ''
		DECLARE @Email_Config_Code INT
		DECLARE @Acq_Deal_Rights_Code varchar(max)=''
		DECLARE @Promoter_Count int
		DECLARE @Promoter_Message varchar(max) =''
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='SFA'

		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param	--// FLAG FOR SEND MAIL TO INDIVIDUAL PERSON ON GROUP //--

		SET @DealType = ''
		IF(@Module_code = 30)
		BEGIN
			SELECT TOP 1  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode
			SELECT @Acq_Deal_Rights_Code   =  @Acq_Deal_Rights_Code + CAST(acq_deal_rights_Code AS varchar)+ ', '  FROM acq_deal_Rights WHERE Acq_Deal_Code = @RecordCode
			select @Promoter_Count = count(*) from Acq_Deal_Rights_Promoter where Acq_Deal_Rights_Code in (SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Code,',')) 
			IF(@Promoter_Count > 0)
			BEGIN
			 SET @Promoter_Message = 'Self Utilization Group details are  added for the deal'
			END
			ELSE
			BEGIN
			SET @Promoter_Message = 'Self Utilization Group details are not added for the deal'
			END

		END
		ELSE IF(@Module_code = 35)
		BEGIN
			SELECT  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal WHERE Syn_Deal_Code = @RecordCode
		END
		ELSE IF(@Module_code = 163)
		BEGIN
			SELECT  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal WHERE Music_Deal_Code = @RecordCode
		END

		DECLARE 
		@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
		@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0,@BU_Name VARCHAR(MAX) = ''

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''

		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) 
			FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@Module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By = U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
				WHERE Acq_Deal_Code = @RecordCode
			
				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT  @Titles += CASE  WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@Module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name, @BU_Name = BU.Business_Unit_Name,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By = U2.Login_Name,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
				WHERE Syn_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name,@BU_Name = BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
	
		/* SELECT SITE URL */
		DECLARE @DefaultSiteUrlHold NVARCHAR(500) ,  @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'
		SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param
		SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is waiting for approval' 

		SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

		IF(@Is_RU_Content_Category = 'Y')
			SET  @BU_CC= 'Content Category'

		--@Primary_User_Code is nothing by group code 
		/* TO SEND EMAIL TO INDIVIDUAL USER */
		DECLARE @Primary_User_Code INT = 0
		SELECT TOP 1 @Primary_User_Code = Group_Code  
		FROM Module_Workflow_Detail 
		WHERE Is_Done = 'N' AND Module_Code = @Module_code AND Record_Code = @RecordCode 
		ORDER BY Module_Workflow_Detail_Code

		/* CURSOR START */
		DECLARE Cur_On_Rejection CURSOR KEYSET FOR 
		SELECT DISTINCT U2.Email_Id ,ISNULL(U2.First_Name,'') + ' ' + ISNULL(U2.Middle_Name,'') + ' ' + ISNULL(U2.Last_Name,'') + 
		'   ('+ ISNULL(SG.Security_Group_Name,'') + ')', SG.Security_Group_Name, U2.Security_Group_Code, U2.Users_Code 
		FROM Users U1
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		WHERE U1.Security_Group_Code = @Primary_User_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'


		OPEN Cur_On_Rejection
		FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
				
				SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=SA'
				
				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
					SET @Email_Table =	'<table class="tblFormat" >
					<tr>
						<td align="center" width="12%" class="tblHead">Agreement No.</td>      
						<td align="center" width="12%" class="tblHead">Agreement Date</td>      
						<td align="center" width="17%" class="tblHead">Deal Description</td>      
						<td align="center" width="12%" class="tblHead">Primary Licensor</td>      
						<td align="center" width="20%" class="tblHead">Title(s)</td>
						<td align="center" width="12%"  class="tblHead">'+@BU_CC+'</td>
					'
				END
				ELSE
				BEGIN 
					SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
							<td align="center" width="9%" class="tblHead">Agreement No.</td>    
							<td align="center" width="9%" class="tblHead">Agreement Date</td> 
							<td align="center" width="9%" class="tblHead">Created By</td> 
							<td align="center" width="9%" class="tblHead">Creation Date</td> 
							<td align="center" width="9%" class="tblHead">Deal Description</td> 
							<td align="center" width="9%" class="tblHead">Primary Licensor</td>   
							<td align="center" width="9%" class="tblHead">Title(s)</td>
							<td align="center" width="9%" class="tblHead">'+@BU_CC+'</td>
							<td align="center" width="9%" class="tblHead">Last Actioned By</td>
							<td align="center" width="9%" class="tblHead">Last Actioned Date</td>
					'
				END


			   IF(@DealType = 'Acquisition')
			   BEGIN
					SET @Email_Table += '<td align="center" width="10%" class="tblHead">Self Utilization</td>'
			   END   

			   SET @Email_Table += '</tr>'
			   
			   IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
				 SET @Email_Table += '<tr>      
						<td align="center" class="tblData">{Agreement_No}</td>     
						<td align="center" class="tblData">{Agreement_Date}</td>     
						<td align="center" class="tblData">{Deal_Desc}</td>     
						<td align="center" class="tblData">{Primary_Licensor}</td>  
						<td align="center" class="tblData">{Titles}</td>
						<td align="center" class="tblData">{BU_Name}</td>
				'
				END
				ELSE
				BEGIN
					 SET @Email_Table += ' <tr>
						<td align="center" class="tblData">{Agreement_No}</td>   
						<td align="center" class="tblData">{Agreement_Date}</td>    
						<td align="center" class="tblData">{Created_By}</td>    
						<td align="center" class="tblData">{Creation_Date}</td>    
						<td align="center" class="tblData">{Deal_Desc}</td>    
						<td align="center" class="tblData">{Primary_Licensor}</td>   
						<td align="center" class="tblData">{Titles}</td> 
						<td align="center" class="tblData">{BU_Name}</td> 
						<td align="center" class="tblData">{Last_Actioned_By}</td> 
						<td align="center" class="tblData">{Last_Actioned_Date}</td> 
					'
				END
			   IF(@DealType = 'Acquisition')
			   BEGIN
					SET @Email_Table += '<td align="center" class="tblData">{Promoter}</td>'
				END   
			
			SET @Email_Table += '</tr></table>'

				
				--REPLACE ALL THE PARAMETER VALUE
				SELECT @body1 = template_desc FROM Email_Template WHERE Template_For='A' 
				SET @body1 = replace(@body1,'{login_name}',@Cur_first_name)
				SET @body1 = replace(@body1,'{deal_no}',@DealNo)
				SET @body1 = replace(@body1,'{deal_type}',@DealType)
				set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)
				SET @body1 = replace(@body1,'{link}',@DefaultSiteUrl)

				SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
				SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
				SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
				SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
				SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
				SET @Email_Table = replace(@Email_Table,'{BU_Name}',@BU_Name)  
				IF(@DealType = 'Acquisition')
				BEGIN
					SET @Email_Table = replace(@Email_Table,'{Promoter}',@Promoter_Message)  
				END   

				IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
				BEGIN
					SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
					SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
				END

				SET @CC = ''
				--IF(@Is_Mail_Send_To_Group='Y')
				--BEGIN
				--	SELECT @CC = @CC + ';' + email_id FROM Users U
				--	INNER JOIN Users_Business_Unit UBU ON U.Users_Code =UBU.Users_Code AND 
				--	UBU.Business_Unit_Code IN (@BU_Code)
				--	WHERE security_group_code IN (@Cur_security_group_code) 
				--	AND UBU.Users_Code NOT IN(@Cur_user_code)
				--END
				
				SET @body1 = replace(@body1,'{table}',@Email_Table)

				DECLARE @DatabaseEmail_Profile varchar(200)	
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
				
				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile,
				@Recipients =  @Cur_email_id,
				@Copy_recipients = @CC,
				@subject = @MailSubjectCr,
				@body = @body1,@body_format = 'HTML';  

				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id

				--select @body1

			END
			FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
		END

		CLOSE Cur_On_Rejection
		DEALLOCATE Cur_On_Rejection
		/* CURSOR END */
					 --select @DefaultSiteUrl
		SET @Is_Error='N'
	END TRY
	BEGIN CATCH
		SET @Is_Error='Y'
		CLOSE Cur_On_Rejection
		DEALLOCATE Cur_On_Rejection

		INSERT INTO	ERRORON_SENDMAIL_FOR_WORKFLOW 
		SELECT 
			ERROR_NUMBER() AS ERRORNUMBER,
			ERROR_SEVERITY() AS ERRORSEVERITY,		
			ERROR_STATE() AS ERRORSTATE,
			ERROR_PROCEDURE() AS ERRORPROCEDURE,
			ERROR_LINE() AS ERRORLINE,
			ERROR_MESSAGE() AS ERRORMESSAGE;
	END CATCH							
END



--update Email_Template SET template_desc =
--'<html>   <head>    <style>     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }    
-- th.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
-- font-size:12px; font-weight:bold    }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
-- font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }    
--       #divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear&nbsp;{login_name},<br />
--	   <br />     The {deal_type} Deal No: <b>{deal_no}</b> is waiting for approval.<br /><br />   
--	     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> to approve {deal_type} deal<br /><br />    </div>    
--		 {table}
--		 <br /><br /><br /><br /> 
--				     <div id="divFooter" class="textFont">    
--					  This email is generated by RightsU    </div>   </body>  </html>' WHERE Template_For='A'
GO
PRINT N'Altering [dbo].[USP_Title_Import_Utility_PIII]...';


GO
ALTER PROCEDURE [dbo].[USP_Title_Import_Utility_PIII]
(
	@DM_Master_Import_Code INT
)
AS 
BEGIN
	SET NOCOUNT ON
	--DECLARE @DM_Master_Import_Code INT = 1105
	DECLARE @ISError CHAR(1) = 'N', @Error_Message NVARCHAR(MAX) = '', @ExcelCnt INT = 0

	IF(OBJECT_ID('tempdb..#TempTitle') IS NOT NULL) DROP TABLE #TempTitle
	IF(OBJECT_ID('tempdb..#TempTitleUnPivot') IS NOT NULL) DROP TABLE #TempTitleUnPivot
	IF(OBJECT_ID('tempdb..#TempExcelSrNo') IS NOT NULL) DROP TABLE #TempExcelSrNo
	IF(OBJECT_ID('tempdb..#TempHeaderWithMultiple') IS NOT NULL) DROP TABLE #TempHeaderWithMultiple
	IF(OBJECT_ID('tempdb..#TempTalent') IS NOT NULL) DROP TABLE #TempTalent
	IF(OBJECT_ID('tempdb..#TempExtentedMetaData') IS NOT NULL) DROP TABLE #TempExtentedMetaData
	IF(OBJECT_ID('tempdb..#TempResolveConflict') IS NOT NULL) DROP TABLE #TempResolveConflict
	IF(OBJECT_ID('tempdb..#TempDuplicateRows') IS NOT NULL) DROP TABLE #TempDuplicateRows
	IF(OBJECT_ID('tempdb..#TempDupTitleName') IS NOT NULL) DROP TABLE #TempDupTitleName
	
	CREATE TABLE #TempTitle(
		DM_Master_Import_Code INT,
		ExcelSrNo NVARCHAR(MAX),
		Col1 NVARCHAR(MAX),
		Col2 NVARCHAR(MAX),
		Col3 NVARCHAR(MAX),
		Col4 NVARCHAR(MAX),
		Col5 NVARCHAR(MAX),
		Col6 NVARCHAR(MAX),
		Col7 NVARCHAR(MAX),
		Col8 NVARCHAR(MAX),
		Col9 NVARCHAR(MAX),
		Col10 NVARCHAR(MAX),
		Col11 NVARCHAR(MAX),
		Col12 NVARCHAR(MAX),
		Col13 NVARCHAR(MAX),
		Col14 NVARCHAR(MAX),
		Col15 NVARCHAR(MAX),
		Col16 NVARCHAR(MAX),
		Col17 NVARCHAR(MAX),
		Col18 NVARCHAR(MAX),
		Col19 NVARCHAR(MAX),
		Col20 NVARCHAR(MAX),
		Col21 NVARCHAR(MAX),
		Col22 NVARCHAR(MAX),
		Col23 NVARCHAR(MAX),
		Col24 NVARCHAR(MAX),
		Col25 NVARCHAR(MAX),
		Col26 NVARCHAR(MAX),
		Col27 NVARCHAR(MAX),
		Col28 NVARCHAR(MAX),
		Col29 NVARCHAR(MAX),
		Col30 NVARCHAR(MAX),
		Col31 NVARCHAR(MAX),
		Col32 NVARCHAR(MAX),
		Col33 NVARCHAR(MAX),
		Col34 NVARCHAR(MAX),
		Col35 NVARCHAR(MAX),
		Col36 NVARCHAR(MAX),
		Col37 NVARCHAR(MAX),
		Col38 NVARCHAR(MAX),
		Col39 NVARCHAR(MAX),
		Col40 NVARCHAR(MAX),
		Col41 NVARCHAR(MAX),
		Col42 NVARCHAR(MAX),
		Col43 NVARCHAR(MAX),
		Col44 NVARCHAR(MAX),
		Col45 NVARCHAR(MAX),
		Col46 NVARCHAR(MAX),
		Col47 NVARCHAR(MAX),
		Col48 NVARCHAR(MAX),
		Col49 NVARCHAR(MAX),
		Col50 NVARCHAR(MAX),
		Col51 NVARCHAR(MAX),
		Col52 NVARCHAR(MAX),
		Col53 NVARCHAR(MAX),
		Col54 NVARCHAR(MAX),
		Col55 NVARCHAR(MAX),
		Col56 NVARCHAR(MAX),
		Col57 NVARCHAR(MAX),
		Col58 NVARCHAR(MAX),
		Col59 NVARCHAR(MAX),
		Col60 NVARCHAR(MAX),
		Col61 NVARCHAR(MAX),
		Col62 NVARCHAR(MAX),
		Col63 NVARCHAR(MAX),
		Col64 NVARCHAR(MAX),
		Col65 NVARCHAR(MAX),
		Col66 NVARCHAR(MAX),
		Col67 NVARCHAR(MAX),
		Col68 NVARCHAR(MAX),
		Col69 NVARCHAR(MAX),
		Col70 NVARCHAR(MAX),
		Col71 NVARCHAR(MAX),
		Col72 NVARCHAR(MAX),
		Col73 NVARCHAR(MAX),
		Col74 NVARCHAR(MAX),
		Col75 NVARCHAR(MAX),
		Col76 NVARCHAR(MAX),
		Col77 NVARCHAR(MAX),
		Col78 NVARCHAR(MAX),
		Col79 NVARCHAR(MAX),
		Col80 NVARCHAR(MAX),
		Col81 NVARCHAR(MAX),
		Col82 NVARCHAR(MAX),
		Col83 NVARCHAR(MAX),
		Col84 NVARCHAR(MAX),
		Col85 NVARCHAR(MAX),
		Col86 NVARCHAR(MAX),
		Col87 NVARCHAR(MAX),
		Col88 NVARCHAR(MAX),
		Col89 NVARCHAR(MAX),
		Col90 NVARCHAR(MAX),
		Col91 NVARCHAR(MAX),
		Col92 NVARCHAR(MAX),
		Col93 NVARCHAR(MAX),
		Col94 NVARCHAR(MAX),
		Col95 NVARCHAR(MAX),
		Col96 NVARCHAR(MAX),
		Col97 NVARCHAR(MAX),
		Col98 NVARCHAR(MAX),
		Col99 NVARCHAR(MAX),
		Col100 NVARCHAR(MAX)
	)

	CREATE TABLE #TempTitleUnPivot(
		ExcelSrNo NVARCHAR(MAX),
		ColumnHeader NVARCHAR(MAX),
		TitleData NVARCHAR(MAX),
		RefKey NVARCHAR(MAX),
		IsError CHAR(1),
		ErrorMessage NVARCHAR(MAX)
	)

	CREATE TABLE #TempExcelSrNo(
		ExcelSrNo NVARCHAR(MAX),
	)

	CREATE TABLE #TempHeaderWithMultiple(
		ExcelSrNo NVARCHAR(MAX),
		TitleCode INT,
		HeaderName NVARCHAR(MAX),
		PropName NVARCHAR(MAX),
		PropCode INT
	)

	CREATE TABLE #TempResolveConflict(
		[Name] NVARCHAR(MAX),
		Master_Type NVARCHAR(MAX),
		Master_Code INT,
		Roles NVARCHAR(MAX),
		Mapped_By CHAR(1)
	)

	CREATE TABLE #TempTalent(
		ExcelSrNo NVARCHAR(MAX),
		HeaderName NVARCHAR(MAX),
		TalentName NVARCHAR(MAX),
		TalentCode INT,
		RoleCode INT
	)

	CREATE TABLE #TempExtentedMetaData(
		ExcelSrNo NVARCHAR(MAX),
		Columns_Code INT,
		HeaderName NVARCHAR(MAX),
		EMDName NVARCHAR(MAX),
		EMDCode INT
	)

	CREATE TABLE #TempDupTitleName
	(
		ExcelSrNo NVARCHAR(MAX),
		Title_Name NVARCHAR(MAX),
		Title_Code INT,
		Title_Type NVARCHAR(MAX),
		Deal_Type_Code INT,
		IsError CHAR(1)
	)

	BEGIN TRY

	UPDATE DM_Title_Import_Utility_Data SET Error_Message = NULL, Is_Ignore = 'N', Record_Status = NULL 
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Col1 NOT LIKE '%Sr%' 

	PRINT 'Inserting Data into #TempTitle'
	INSERT INTO #TempTitle (DM_Master_Import_Code, ExcelSrNo, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99)  
	SELECT DM_Master_Import_Code, Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ,Col100  
	FROM DM_Title_Import_Utility_Data  
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code

	PRINT 'Fetching duplicate EXCEL Sr No'
	UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Duplicate EXCEL Sr. No. Found', Is_Ignore = 'Y' --A.Record_Status = 'E', 
	FROM DM_Title_Import_Utility_Data A
	WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code
	AND A.Col1 COLLATE Latin1_General_CI_AI in (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DELETE FROM #TempTitle WHERE 
	ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' GROUP BY ExcelSrNo HAVING ( COUNT(ExcelSrNo) > 1 ))

	DECLARE @Mandatory_message NVARCHAR(MAX)
	SELECT @Mandatory_message = STUFF(( SELECT ', ' + Display_Name +' is Mandatory Field' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		

	SELECT B.Col1 as ExcelSrNo
	INTO #TempDuplicateRows
	FROM DM_Title_Import_Utility_Data B
	WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND B.Col1 NOT LIKE '%Sr%'
	AND B.Col1 IN (
		SELECT A.ExcelSrNo FROM
		(
			SELECT Col1 AS ExcelSrNo , CONCAT(Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50, Col51, Col52, Col53, Col54, Col55, Col56, Col57, Col58, Col59, Col60, Col61, Col62, Col63, Col64, Col65, Col66, Col67, Col68, Col69, Col70, Col71, Col72, Col73, Col74, Col75, Col76, Col77, Col78, Col79, Col80, Col81, Col82, Col83, Col84, Col85, Col86, Col87, Col88, Col89, Col90, Col91, Col92, Col93, Col94, Col95, Col96, Col97, Col98, Col99, Col100) AS Concatenate
			FROM DM_Title_Import_Utility_Data  
			WHERE DM_Master_Import_Code =  @DM_Master_Import_Code
			AND Col1 NOT LIKE '%Sr%'
		) AS A WHERE A.Concatenate = ''
	)

	UPDATE B SET  B.Error_Message= ISNULL(B.Error_Message,'') + '~'+@Mandatory_message , B.Record_Status = 'E'
	FROM DM_Title_Import_Utility_Data B WHERE B.Col1 IN (SELECT ExcelSrNo FROM #TempDuplicateRows ) AND B.DM_Master_Import_Code = @DM_Master_Import_Code

	PRINT 'Fetching duplicate rows'
	UPDATE A SET  Error_Message= ISNULL(Error_Message,'') + '~Duplicate Rows Found', Is_Ignore = 'Y' --,A.Record_Status = 'E'
	FROM DM_Title_Import_Utility_Data A 
	INNER JOIN 
	(
		SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
		FROM #TempTitle WHERE ExcelSrNo NOT LIKE '%Sr%' 
	) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
	WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' AND B.rank > 1 AND A.Col1 NOT IN (SELECT ExcelSrNo FROM #TempDuplicateRows)

	DELETE A FROM #TempTitle A 
	INNER JOIN (
	SELECT ExcelSrNo, RANK() OVER(PARTITION BY  Col1 ,Col2 ,Col3 ,Col4 ,Col5 ,Col6 ,Col7 ,Col8 ,Col9 ,Col10 ,Col11 ,Col12 ,Col13 ,Col14 ,Col15 ,Col16 ,Col17 ,Col18 ,Col19 ,Col20 ,Col21 ,Col22 ,Col23 ,Col24 ,Col25 ,Col26 ,Col27 ,Col28 ,Col29 ,Col30 ,Col31 ,Col32 ,Col33 ,Col34 ,Col35 ,Col36 ,Col37 ,Col38 ,Col39 ,Col40 ,Col41 ,Col42 ,Col43 ,Col44 ,Col45 ,Col46 ,Col47 ,Col48 ,Col49 ,Col50 ,Col51 ,Col52 ,Col53 ,Col54 ,Col55 ,Col56 ,Col57 ,Col58 ,Col59 ,Col60 ,Col61 ,Col62 ,Col63 ,Col64 ,Col65 ,Col66 ,Col67 ,Col68 ,Col69 ,Col70 ,Col71 ,Col72 ,Col73 ,Col74 ,Col75 ,Col76 ,Col77 ,Col78 ,Col79 ,Col80 ,Col81 ,Col82 ,Col83 ,Col84 ,Col85 ,Col86 ,Col87 ,Col88 ,Col89 ,Col90 ,Col91 ,Col92 ,Col93 ,Col94 ,Col95 ,Col96 ,Col97 ,Col98 ,Col99 ORDER BY ExcelSrNo) rank
	FROM #TempTitle
	WHERE ExcelSrNo NOT LIKE '%Sr%' ) AS B ON A.ExcelSrNo = B.ExcelSrNo
	WHERE  A.ExcelSrNo NOT LIKE '%Sr%' AND B.rank > 1	

	
	BEGIN
		PRINT 'Unpivoting Title data for further validation'
		INSERT INTO #TempTitleUnPivot(ExcelSrNo, ColumnHeader, TitleData)
		SELECT ExcelSrNo, LTRIM(RTRIM(ColumnHeader)), LTRIM(RTRIM(TitleData))
		FROM
		(
			SELECT * FROM #TempTitle
		) AS cp
		UNPIVOT 
		(
			TitleData FOR ColumnHeader IN (Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18, Col19, Col20, Col21, Col22, Col23, Col24, Col25, Col26, Col27, Col28, Col29, Col30, Col31, Col32, Col33, Col34, Col35, Col36, Col37, Col38, Col39, Col40, Col41, Col42, Col43, Col44, Col45, Col46, Col47, Col48, Col49, Col50)
		) AS up

		UPDATE T2 SET T2.ColumnHeader = T1.TitleData
		FROM (
			SELECT * FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		) AS T1
		INNER JOIN #TempTitleUnPivot T2 ON T1.ColumnHeader = T2.ColumnHeader

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo LIKE '%Sr%'
		DELETE FROM #TempTitleUnPivot WHERE TitleData = ''

		INSERT INTO #TempExcelSrNo(ExcelSrNo)
		SELECT DISTINCT ExcelSrNo FROM #TempTitleUnPivot

		SELECT @ExcelCnt = COUNT(DISTINCT ExcelSrNo) FROM #TempExcelSrNo

		UPDATE T1 SET T1.IsError = '', ErrorMessage = '' FROM #TempTitleUnPivot T1
	END

	DECLARE @Display_Name NVARCHAR(MAX), @Reference_Table NVARCHAR(MAX), @Reference_Text_Field NVARCHAR(MAX), @Reference_Value_Field NVARCHAR(MAX)
	, @Reference_Whr_Criteria NVARCHAR(MAX),  @Control_Type NVARCHAR(MAX), @Is_Allowed_For_Resolve_Conflict CHAR(1), @ShortName NVARCHAR(MAX),
	@Target_Column NVARCHAR(MAX)

	BEGIN
		PRINT 'Duplication'

		DECLARE db_cursor_Duplication CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%dup%'
		
		OPEN db_cursor_Duplication  
		FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') has duplicate data'
			WHERE ExcelSrNo IN(
				SELECT A.ExcelSrNo FROM ( SELECT excelSrNo, RANK() OVER(PARTITION BY TitleData ORDER BY excelSrNo) AS rank FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name ) AS A WHERE A.rank > 1
			)	
			--IF (@Display_Name = 'Title Name')
			--BEGIN
			--	UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Title Name is already existed'
			--	WHERE ExcelSrNo IN(
			--		SELECT EXCELSRNO FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name
			--		AND TitleData COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT DISTINCT ISNULL(Title_Name,'') FROM Title)
			--	)
			--END

			FETCH NEXT FROM db_cursor_Duplication INTO @Display_Name 
		END 
		CLOSE db_cursor_Duplication  
		DEALLOCATE db_cursor_Duplication 
	END

	BEGIN
		PRINT 'Check INT Column'
		DECLARE @Value NVARCHAR(MAX)= '', @ExcelNo_IntDec NVARCHAR(MAX) = ''

		DECLARE db_cursor_Int CURSOR FOR 
		SELECT Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND Colum_Type = 'INT'

		OPEN db_cursor_Int  
		FETCH NEXT FROM db_cursor_Int INTO @Display_Name 

		WHILE @@FETCH_STATUS = 0  
		BEGIN 
	
			DECLARE db_cursor_Int_dec CURSOR FOR 
			SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name	AND ISNULL(TitleData,'') <> ''

			OPEN db_cursor_Int_dec  
			FETCH NEXT FROM db_cursor_Int_dec INTO @ExcelNo_IntDec, @Value 
	
			WHILE @@FETCH_STATUS = 0  
			BEGIN 
					IF (ISNUMERIC(Replace(Replace(@Value,'+','A'),'-','A') + '.0e0') > 0)
					BEGIN
						UPDATE #TempTitleUnPivot SET RefKey = 1 WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value
					END
					ELSE IF (REPLACE(ISNUMERIC(REPLACE(REPLACE(@Value,'+','A'),'-','A') + 'e0'),1,CHARINDEX('.',@Value)) > 0 AND @Display_Name = 'Duration In Minute')
					BEGIN
						UPDATE #TempTitleUnPivot SET RefKey = 2  WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value

						IF (right(@Value, 1) = '.')
							UPDATE #TempTitleUnPivot SET TitleData = TitleData + '0'  WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value
					END
					ELSE
					BEGIN 
						UPDATE #TempTitleUnPivot SET RefKey = 0 FROM #TempTitleUnPivot WHERE ExcelSrNo = @ExcelNo_IntDec AND TitleData = @Value
					END

				FETCH NEXT FROM db_cursor_Int_dec INTO @ExcelNo_IntDec, @Value 
			END 

			CLOSE db_cursor_Int_dec  
			DEALLOCATE db_cursor_Int_dec 
	
			UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Not Numeric'
			WHERE ExcelSrNo IN (
				SELECT ExcelSrNo FROM #TempTitleUnPivot 
				WHERE  ColumnHeader = @Display_Name AND RefKey = 0
			)
		
			IF ('YEAR OF RELEASE' = UPPER(@Display_Name))
			BEGIN
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				WHERE ExcelSrNo IN (
				SELECT ExcelSrNo
				FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND  RefKey = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1950 AND 9999
				)

			END

			IF ('DURATION IN MINUTE' = UPPER(@Display_Name))
			BEGIN
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				WHERE ExcelSrNo IN (
					SELECT ExcelSrNo
					FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND RefKey = 1 AND CAST(TitleData AS INT) NOT BETWEEN 1 AND 9999
				)

				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') should be between 1950 and 9999'
				WHERE ExcelSrNo IN (
					SELECT ExcelSrNo
					FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name AND RefKey = 2 AND CAST(TitleData AS DECIMAL(38,2)) NOT BETWEEN 1 AND 9999
				)
			END

			UPDATE #TempTitleUnPivot SET RefKey = NULL WHERE RefKey IN (0,1,2) AND ColumnHeader = @Display_Name

			FETCH NEXT FROM db_cursor_Int INTO @Display_Name 
		END 

		CLOSE db_cursor_Int  
		DEALLOCATE db_cursor_Int 
	END

	BEGIN
		PRINT 'Mandatory Validation'

		DECLARE db_cursor_Mandatory CURSOR FOR 
			SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' AND [validation] like '%man%'

		OPEN db_cursor_Mandatory  
		FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name , @Is_Allowed_For_Resolve_Conflict, @ShortName

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

			IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
			BEGIN
					UPDATE A SET Error_Message= ISNULL(Error_Message,'') + '~Mandatory Columns are Ignored while Mapping', A.Is_Ignore = 'Y'  
					FROM DM_Title_Import_Utility_Data A
					WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 COLLATE Latin1_General_CI_AI IN (
						SELECT ExcelSrNo FROM #TempTitleUnPivot T
						INNER JOIN DM_Master_Log B ON T.TitleData = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
						WHERE B.DM_Master_Import_Code = @DM_Master_Import_Code
						AND  B.Is_Ignore = 'Y'
						AND  B.Master_Type = @ShortName
						AND T.ColumnHeader = @Display_Name )

					DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo IN (
					SELECT ExcelSrNo FROM #TempTitleUnPivot A
						INNER JOIN DM_Master_Log B ON A.TitleData = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
						WHERE DM_Master_Import_Code = @DM_Master_Import_Code
						AND  B.Is_Ignore = 'Y'
						AND  B.Master_Type = @ShortName
						AND A.ColumnHeader = @Display_Name			
					)
			END

			IF((SELECT COUNT(DISTINCT ExcelSrNo) FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name) < 2) --@ExcelCnt
			BEGIN
				UPDATE #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~Column ('+ @Display_Name +') is Mandatory Field'
				WHERE ExcelSrNo NOT IN ( SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE ColumnHeader = @Display_Name)
			END

			  FETCH NEXT FROM db_cursor_Mandatory INTO @Display_Name , @Is_Allowed_For_Resolve_Conflict, @ShortName 
		END 

		CLOSE db_cursor_Mandatory  
		DEALLOCATE db_cursor_Mandatory 
	END
	
	BEGIN
		PRINT 'Deleting IsError = Y and updating record status amd error message AND deleting existing title'

		INSERT INTO #TempDupTitleName (ExcelSrNo, Title_Name)
		SELECT ExcelSrNo, TitleData FROM #TempTitleUnPivot WHERE ColumnHeader = 'Title Name' AND IsError <> 'Y'

		UPDATE A SET A.Title_Type = B.TitleData
		FROM #TempDupTitleName A
		INNER JOIN #TempTitleUnPivot B ON A.ExcelSrNo COLLATE Latin1_General_CI_AI = B.ExcelSrNo
		WHERE B.ColumnHeader = 'Title Type'

		UPDATE A SET A.Title_Code = B.Title_Code
		FROM #TempDupTitleName A
		INNER JOIN Title B ON A.Title_Name  COLLATE Latin1_General_CI_AI  = B.Title_Name

		UPDATE A SET A.Deal_Type_Code = B.Deal_Type_Code
		FROM #TempDupTitleName A
		INNER JOIN Deal_Type B ON A.Title_Type  COLLATE Latin1_General_CI_AI  = B.Deal_Type_Name
		WHERE  B.Is_Active = 'Y'

		UPDATE A SET A.Deal_Type_Code = B.Master_Code
		FROM #TempDupTitleName A
		INNER JOIN DM_Master_Log B ON A.Title_Type COLLATE Latin1_General_CI_AI  = B.Name
		WHERE Master_Type = 'TT' AND Is_Ignore = 'N' AND B.DM_Master_Import_Code = @DM_Master_Import_Code
	
		UPDATE A SET A.IsError = 'Y'
		FROM #TempDupTitleName A
		inner join Title B ON A.Title_Name COLLATE Latin1_General_CI_AI  = B.Title_Name AND A.Deal_Type_Code = B.Deal_Type_Code


		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + 'Title Name Already Existed'--, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		WHERE A.DM_Master_Import_Code =  @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%' and A.Col1 COLLATE Latin1_General_CI_AI IN 
		(
			SELECT ExcelSrNo FROM #TempDupTitleName where ISNULL(IsError, '') = 'Y'
		)
	
		UPDATE A SET A.Record_Status = 'E', Error_Message= ISNULL(Error_Message,'') + B.ErrorMessage --, Is_Ignore = 'Y'
		FROM DM_Title_Import_Utility_Data A
		INNER JOIN (
			SELECT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y' GROUP BY ExcelSrNo, ErrorMessage
		) AS B ON A.Col1 = B.ExcelSrNo COLLATE Latin1_General_CI_AI
		WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code 
		AND A.Col1 NOT LIKE '%Sr%'

		DELETE FROM #TempTitleUnPivot WHERE ExcelSrNo COLLATE Latin1_General_CI_AI IN
		(
			SELECT ExcelSrNo FROM #TempDupTitleName where ISNULL(IsError, '') = 'Y'
		)

		DELETE FROM #TempTitleUnPivot WHERE IsError = 'Y'
	END
	
	BEGIN
		PRINT 'Referene check not available where Is_Multiple = ''N'''

		DECLARE db_cursor_Reference CURSOR FOR 
		SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'N'

		OPEN db_cursor_Reference  
		FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  

				EXEC ('UPDATE B SET B.RefKey = A.'+@Reference_Value_Field+' 
						FROM #TempTitleUnPivot B
						INNER JOIN '+@Reference_Table+' A ON A.'+@Reference_Text_Field+'  COLLATE Latin1_General_CI_AI = B.TitleData  COLLATE Latin1_General_CI_AI AND B.ColumnHeader = '''+@Display_Name+'''
						WHERE 1=1 '+@Reference_Whr_Criteria+'
				')

				IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
				BEGIN
					
					UPDATE B SET B.RefKey = A.Master_Code
					FROM DM_Master_Log A
					INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
					WHERE 
						A.DM_Master_Import_Code = @DM_Master_Import_Code 
						AND A.Master_Type   = @ShortName   
						AND B.ColumnHeader   = @Display_Name  
						AND B.RefKey IS NULL
						AND A.Master_Code IS NOT NULL
						AND A.Is_Ignore = 'N'
				END
				
				IF(@Is_Allowed_For_Resolve_Conflict = 'N')
					UPDATE A SET A.IsError = 'Y', A.ErrorMessage = ISNULL(A.ErrorMessage, '') + '~' + @Display_Name +' Not Available~'
					FROM #TempTitleUnPivot A WHERE  A.ExcelSrNo IN
					(
						SELECT DISTINCT  ExcelSrNo
						FROM #TempTitleUnPivot T1
						WHERE T1.ColumnHeader = @Display_Name AND T1.RefKey IS NULL AND T1.TitleData <> ''
					)

				FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		END 

		CLOSE db_cursor_Reference  
		DEALLOCATE db_cursor_Reference 
	END
	
	BEGIN
		PRINT 'Referene check where Is_Multiple = ''Y'''

		DECLARE db_cursor_Reference CURSOR FOR 
		SELECT Display_Name, Reference_Table, Reference_Text_Field, Reference_Value_Field, Reference_Whr_Criteria, Is_Allowed_For_Resolve_Conflict, ShortName
		FROM DM_Title_Import_Utility
		WHERE Reference_Table <> 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y' AND Is_Multiple = 'Y'

		OPEN db_cursor_Reference  
		FETCH NEXT FROM db_cursor_Reference INTO @Display_Name, @Reference_Table, @Reference_Text_Field, @Reference_Value_Field, @Reference_Whr_Criteria,  @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  		
	
			INSERT INTO #TempHeaderWithMultiple(ExcelSrNo,HeaderName, PropName)
				SELECT DISTINCT 
						ExcelSrNo, 
						@Display_Name,
						LTRIM(RTRIM(f.Number))
				FROM #TempTitleUnPivot upvot
				CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
				WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> '' 

			UPDATE A SET A.PropCode = B.Master_Code
			FROM #TempHeaderWithMultiple A
			INNER JOIN DM_Master_Log B ON A.PropName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND B.Is_Ignore = 'N'

			EXEC ('UPDATE A SET A.PropCode = B.'+@Reference_Value_Field+' 
			FROM #TempHeaderWithMultiple A
			INNER JOIN '+@Reference_Table+' B ON A.PropName COLLATE SQL_Latin1_General_CP1_CI_AS = B.'+@Reference_Text_Field+'
			WHERE 1=1 AND A.PropCode IS NULL AND A.HeaderName ='''+@Display_Name+'''  '+@Reference_Whr_Criteria+'
			')

			FETCH NEXT FROM db_cursor_Reference INTO  @Display_Name,  @Reference_Table, @Reference_Text_Field, @Reference_Value_Field,  @Reference_Whr_Criteria , @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_Reference  
		DEALLOCATE db_cursor_Reference 
	END
	
	BEGIN
		PRINT 'Talent Referene check'

		DECLARE db_cursor_Talent_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName 
		FROM DM_Title_Import_Utility WHERE Reference_Table = 'Talent' AND Reference_Table <> '' AND Is_Active = 'Y'

		OPEN db_cursor_Talent_Reference  
		FETCH NEXT FROM db_cursor_Talent_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  									 
				INSERT INTO #TempTalent(ExcelSrNo,HeaderName, TalentName, RoleCode)
				SELECT DISTINCT 
						ExcelSrNo, 
						upvot.ColumnHeader,
						LTRIM(RTRIM(f.Number)),
						r.Role_Code
				FROM #TempTitleUnPivot upvot
				inner join Role R ON R.Role_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
				CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
				WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''

				UPDATE A SET A.TalentCode = B.Master_Code FROM #TempTalent A
				INNER JOIN DM_Master_Log B ON A.TalentName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND Roles = @Display_Name AND B.Is_Ignore = 'N'

				FETCH NEXT FROM db_cursor_Talent_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_Talent_Reference  
		DEALLOCATE db_cursor_Talent_Reference 

		DELETE FROM #TempTalent WHERE TalentName in ('',' ','.')

		UPDATE tt SET tt.TalentCode = t.Talent_Code FROM Talent t
		INNER JOIN #TempTalent tt ON t.Talent_Name COLLATE Latin1_General_CI_AI = tt.TalentName COLLATE Latin1_General_CI_AI	
		WHERE TT.TalentCode IS NULL

	END

	BEGIN
		PRINT 'Extended metadata except talent Is_Multiple = ''N'''

		DECLARE db_cursor_EMD_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'N'
	
		OPEN db_cursor_EMD_Reference  
		FETCH NEXT FROM db_cursor_EMD_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
											 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
				-- if TXT then directly insert ie banner 
				IF (@Control_Type = 'DDL')
				BEGIN
					UPDATE upvot SET upvot.RefKey = ECV.Columns_Value_Code
					FROM #TempTitleUnPivot upvot
					INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
					INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Code = EC.Columns_Code AND UPVOT.TitleData COLLATE Latin1_General_CI_AI = ECV.Columns_Value COLLATE Latin1_General_CI_AI 
					WHERE upvot.ColumnHeader = @Display_Name -- 'Colour or B&W'
	
					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
					BEGIN
						UPDATE B SET B.RefKey = A.Master_Code
						FROM DM_Master_Log A
						INNER JOIN #TempTitleUnPivot B on A.Name  COLLATE Latin1_General_CI_AI = B.TitleData
						WHERE 
							A.DM_Master_Import_Code = @DM_Master_Import_Code 
							AND A.Master_Type   = @ShortName   
							AND B.ColumnHeader   = @Display_Name  
							AND B.RefKey IS NULL
							AND A.Master_Code IS NOT NULL
							AND A.Is_Ignore = 'N'
					END

					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available~' 
						WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempTitleUnPivot WHERE RefKey is null AND ColumnHeader = @Display_Name )
					
				END
				FETCH NEXT FROM db_cursor_EMD_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 
	
		CLOSE db_cursor_EMD_Reference  
		DEALLOCATE db_cursor_EMD_Reference 
	END

	BEGIN
		PRINT 'Extended metadata except talent Is_Multiple = ''Y'''

		DECLARE db_cursor_EMDY_Reference CURSOR FOR 
		SELECT Display_Name, Is_Allowed_For_Resolve_Conflict, ShortName FROM DM_Title_Import_Utility WHERE Target_Table = 'Map_Extended_Column' AND Is_Multiple = 'Y'

		OPEN db_cursor_EMDY_Reference  
		FETCH NEXT FROM db_cursor_EMDY_Reference INTO @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
										 
		WHILE @@FETCH_STATUS = 0  				 
		BEGIN  	
				SELECT @Control_Type = Control_Type FROM extended_columns WHERE Columns_Name = @Display_Name
		
				IF (@Control_Type = 'DDL')
				BEGIN
					INSERT INTO #TempExtentedMetaData (ExcelSrNo, Columns_Code, HeaderName, EMDName)
					SELECT DISTINCT ExcelSrNo, EC.Columns_Code, upvot.ColumnHeader, LTRIM(RTRIM(f.Number))
					FROM #TempTitleUnPivot upvot
						INNER JOIN extended_columns EC ON EC.Columns_Name COLLATE Latin1_General_CI_AI = upvot.ColumnHeader COLLATE Latin1_General_CI_AI
						CROSS APPLY DBO.FN_Split_WithDelemiter(upvot.TitleData, ',') as f
					WHERE upvot.ColumnHeader = @Display_Name AND ISNULL(f.Number, '') <> ''
					
					IF(@Is_Allowed_For_Resolve_Conflict = 'Y')
						UPDATE A SET A.EMDCode = B.Master_Code FROM #TempExtentedMetaData A
						INNER JOIN DM_Master_Log B ON A.EMDName = B.Name COLLATE SQL_Latin1_General_CP1_CI_AS
						WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Master_Type = @ShortName AND B.Is_Ignore = 'N'

					UPDATE A SET A.EMDCode= ECV.Columns_Value_Code  FROM #TempExtentedMetaData A
					INNER JOIN Extended_Columns_Value ECV 
					ON ECV.Columns_Value COLLATE Latin1_General_CI_AI = A.EMDName COLLATE Latin1_General_CI_AI AND ECV.Columns_Code = A.Columns_Code 

					IF(@Is_Allowed_For_Resolve_Conflict = 'N')
						UPDATE  #TempTitleUnPivot SET IsError = 'Y', ErrorMessage = ISNULL(ErrorMessage, '') + '~' + @Display_Name +' Not Available~' 
						WHERE  ExcelSrNo IN (SELECT ExcelSrNo FROM #TempExtentedMetaData WHERE EMDCode is null AND HeaderName = @Display_Name )
				END
				FETCH NEXT FROM db_cursor_EMDY_Reference INTO  @Display_Name, @Is_Allowed_For_Resolve_Conflict, @ShortName
		END 

		CLOSE db_cursor_EMDY_Reference  
		DEALLOCATE db_cursor_EMDY_Reference 
	END

	BEGIN
		PRINT 'Resolve Conflict'
		
		DELETE FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code and Master_Code IS NULL AND Is_Ignore = 'N'
		--UPDATE DM_Title_Import_Utility_Data SET Record_Status = NULL WHERE Record_Status = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code

		INSERT INTO #TempResolveConflict ([Name], Master_Type, Roles)
		SELECT DISTINCT A.[Name], A.Master_Type, A.Roles FROM (
				SELECT A.TitleData AS Name ,B.ShortName AS Master_Type ,'' AS Roles FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD
				SELECT A.PropName AS Name ,B.ShortName AS Master_Type,'' AS Roles
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD
				SELECT A.TitleData AS Name,B.ShortName AS Master_Type,''AS Roles
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION ALL --TITLE PROPERTIES WITH SINGLE FIELD EXTENDED META DATA
				SELECT A.EMDName AS Name, B.ShortName AS Master_Type ,''AS Roles
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION ALL --TITLE PROPERTIES WITH MULTIPLE FIELD EXTENDED META DATA
				SELECT A.TalentName AS Name, B.ShortName AS Master_Type, R.Role_Name AS Roles
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			--TITLE PROPERTIES WITH TALENT
		) AS A

		UPDATE A SET  A.Master_Code = B.Master_Code, A.Mapped_By = 'S' 
		FROM #TempResolveConflict A
		INNER JOIN DM_Master_Log B ON B.Name COLLATE Latin1_General_CI_AI = A.Name AND A.Master_Type COLLATE Latin1_General_CI_AI = B.Master_Type
		WHERE B.DM_Master_Log_Code IN ( SELECT  MAX(DM_Master_Log_Code) AS DM_Master_Log_Code FROM DM_Master_Log GROUP BY Name)

		UPDATE #TempResolveConflict SET Mapped_By = 'U' where Master_Code IS NULL 
	
		PRINT 'Delete from Temp table where is_ignore IS Y '
		BEGIN
			DELETE A
			FROM #TempTitleUnPivot A
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
			WHERE A.RefKey IS NULL
				  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				  AND B.Reference_Table <> 'Talent' 
				  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				  AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempHeaderWithMultiple A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.PropName collate Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName collate Latin1_General_CI_AI
			WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.TitleData COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
			WHERE	A.RefKey IS NULL
					AND B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N'
					AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempExtentedMetaData A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.EMDName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
			WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A
			FROM #TempTalent A
				INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				INNER JOIN Role R ON R.Role_Code = A.RoleCode
				INNER JOIN DM_Master_Log DML ON DML.NAME = A.TalentName COLLATE Latin1_General_CI_AI AND DML.Master_Type  = B.ShortName COLLATE Latin1_General_CI_AI
												AND DML.Roles = R.Role_Name COLLATE Latin1_General_CI_AI
			WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				AND DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DML.Is_Ignore = 'Y'

			DELETE A FROM #TempResolveConflict A 
				INNER JOIN DM_Master_Log B ON A.Name COLLATE SQL_Latin1_General_CP1_CI_AS = B.Name AND  B.Is_Ignore = 'Y'
			WHERE B.DM_Master_Import_Code = @DM_Master_Import_Code
		END

		IF EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
		BEGIN
			UPDATE TIU SET TIU.Record_Status = 'R' , TIU.Is_Ignore = 'N'
			FROM DM_Title_Import_Utility_Data AS TIU WHERE ISNULL(TIU.Record_Status,'') <> 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code 
			AND ISNUMERIC(TIU.Col1) = 1 AND TIU.Col1 COLLATE Latin1_General_CI_AI IN (
			SELECT DISTINCT A.ExcelSrNo FROM (
				SELECT A.ExcelSrNo
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.RefKey IS NULL
					  AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
					  AND B.Reference_Table <> 'Talent' 
					  AND B.Reference_Table <> '' AND B.Is_Active = 'Y' AND B.Is_Multiple = 'N'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempHeaderWithMultiple A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.PropCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempTitleUnPivot A
				INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE	A.RefKey IS NULL
						AND B.Target_Table = 'Map_Extended_Column' 
						AND Is_Multiple = 'N'
						AND B.Is_Allowed_For_Resolve_Conflict = 'Y' 
				UNION 
				SELECT A.ExcelSrNo
				FROM #TempExtentedMetaData A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
				WHERE A.EMDCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
				UNION  
				SELECT A.ExcelSrNo
				FROM #TempTalent A
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN Role R ON R.Role_Code = A.RoleCode
				WHERE A.TalentCode IS NULL AND B.Is_Allowed_For_Resolve_Conflict = 'Y' AND B.Is_Active = 'Y'
			) AS A )

			INSERT INTO DM_Master_Log (DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles, Is_Ignore, Mapped_By)
			SELECT @DM_Master_Import_Code, Name, Master_Type, Master_Code, Roles,'N',Mapped_By FROM #TempResolveConflict

			IF EXISTS(SELECT TOP 1 * FROM DM_Title_Import_Utility_Data WHERE ISNULL(Record_Status,'') = 'R' AND DM_Master_Import_Code = @DM_Master_Import_Code )
			BEGIN
				DECLARE @SystemCount INT = 0, @OverAllCount INT = 0

				SELECT @SystemCount = COUNT(*) FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N' AND Mapped_By = 'S'
				SELECT @OverAllCount = COUNT(*) FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Is_Ignore = 'N' 

				IF (@SystemCount = @OverAllCount)
					UPDATE DM_Master_Import SET Status = 'SR' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
				ELSE
					UPDATE DM_Master_Import SET Status = 'R' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
			END
			
			
		END
	END

	BEGIN
		PRINT 'if error which cannot be resolved '

		UPDATE T SET T.IsError = 'Y' 
		FROM #TempTitleUnPivot T WHERE T.ExcelSrNo COLLATE SQL_Latin1_General_CP1_CI_AS IN
		(SELECT Col1 FROM DM_Title_Import_Utility_Data WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status = 'E')

		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE IsError = 'Y') 
		BEGIN

			UPDATE A SET A.Error_Message =ISNULL(A.Error_Message,'') + B.ErrorMessage, Record_Status = 'E'
			FROM DM_Title_Import_Utility_Data A
			INNER JOIN 
			(SELECT DISTINCT ExcelSrNo, ErrorMessage FROM #TempTitleUnPivot WHERE IsError = 'Y') as B on B.ExcelSrNo = A.Col1 COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%' 
			
		END

		IF EXISTS(SELECT * FROM #TempTitleUnPivot WHERE ISNULL(IsError,'') <> 'Y')
		BEGIN
			IF NOT EXISTS (SELECT TOP 1 * FROM #TempResolveConflict)
			BEGIN	
				DECLARE @cols_DisplayName AS NVARCHAR(MAX), @cols_TargetColumn AS NVARCHAR(MAX), @query AS NVARCHAR(MAX)
				UPDATE #TempTitleUnPivot SET IsError = '' WHERE IsError IS NULL

				-----------Title COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',[' + Display_Name +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',[' + Target_Column +']' FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				
				EXEC ('
				INSERT INTO Title ( Is_Active, '+@cols_TargetColumn+')
				SELECT ''Y'', '+@cols_DisplayName+' FROM (SELECT ExcelSrNo, ColumnHeader, 
				CASE WHEN RefKey IS NULL THEN TitleData ELSE RefKey END
				TitleData FROM #TempTitleUnPivot WHERE ISError <> ''Y'') AS Tbl PIVOT( MAX(TitleData) FOR ColumnHeader IN ('+@cols_DisplayName+')) AS Pvt ')
			
				UPDATE A SET A.RefKey = B.Title_Code 
				FROM #TempTitleUnPivot A
				INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
				WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y'

				UPDATE B SET B.Inserted_By = 143, B.Inserted_On = GETDATE(), B.Last_UpDated_Time = GETDATE()
				FROM #TempTitleUnPivot A
				INNER JOIN Title B ON A.TitleData COLLATE SQL_Latin1_General_CP1_CI_AS = B.Title_Name
				WHERE A.ColumnHeader = 'Title Name' AND A.ISError <> 'Y'

				UPDATE B SET B.TitleCode = A.RefKey FROM  #TempTitleUnPivot A
				INNER JOIN #TempHeaderWithMultiple B ON A.ExcelSrNo = B.ExcelSrNo
				WHERE A.ColumnHeader = 'Title Name'  AND A.ISError <> 'Y'

				-----------Title_Country COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Country' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')
				EXEC ('
				INSERT INTO Title_Country (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE 
				HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Country'')
				')
				-----------Title_Geners COLUMN--------------------
				SELECT @cols_DisplayName = STUFF(( SELECT ',' + Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')		
				SELECT @cols_TargetColumn = STUFF(( SELECT ',' + Target_Column FROM DM_Title_Import_Utility WHERE Is_Active = 'Y' and Target_Table = 'Title_Geners' ORDER BY Display_Name FOR XML PATH('') ), 1, 1, '')	
				EXEC ('
				INSERT INTO Title_Geners (Title_Code, '+@cols_TargetColumn+')
				SELECT TitleCode, PropCode from #TempHeaderWithMultiple WHERE HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT  Display_Name FROM DM_Title_Import_Utility WHERE Is_Active = ''Y'' and Target_Table = ''Title_Geners'')
				')

				-----------Title_Talent COLUMN--------------------
				INSERT INTO Talent_Role (Talent_Code, Role_Code)
				SELECT A.TalentCode, A.RoleCode
				FROM #TempTalent A
				LEFT JOIN TALENT_ROLE TR ON TR.Talent_Code = A.TalentCode AND TR.Role_Code = A.RoleCode
				WHERE tr.Role_Code IS NULL and TR.Talent_Code IS NULL

				EXEC ('
				INSERT INTO Title_Talent(Title_Code, Talent_Code, Role_Code)
				SELECT B.RefKey, A.TalentCode, A.RoleCode FROM #TempTalent A
				INNER JOIN #TempTitleUnPivot B ON B.ExcelSrNo = A.ExcelSrNo
				WHERE B.ColumnHeader = ''Title Name'' AND  A.TalentCode IS NOT NULL AND B.ISError <> ''Y''
				')

				-----------EXTENDED COLUMN IS Multiple = N With DDL AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.RefKey, 'N' 
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'DDL' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
					AND A.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = N With TXT AND Map_Extended_Column--------------------
				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Column_Value, Is_Multiple_Select)
				SELECT AA.RefKey,'TITLE', EC.Columns_Code, A.TitleData, 'N'  
				FROM #TempTitleUnPivot A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.ColumnHeader COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'N' 
					AND EC.Control_Type = 'TXT' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y' 
					AND A.ISError <> 'Y'
	
				-----------EXTENDED COLUMN IS Multiple = Y AND Map_Extended_Column --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					 AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)	
				SELECT MEC.Map_Extended_Columns_Code, A.EMDCode
				FROM #TempExtentedMetaData A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = A.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'  
					AND AA.ISError <> 'Y'

				-----------EXTENDED COLUMN IS Multiple = Y IN TALENT --------------------

				INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Is_Multiple_Select)
				SELECT DISTINCT AA.RefKey,'TITLE', EC.Columns_Code, 'Y'  
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN DM_Title_Import_Utility B ON A.HeaderName COLLATE SQL_Latin1_General_CP1_CI_AS = B.Display_Name
					INNER JOIN extended_columns EC ON EC.Columns_Name = B.Display_Name
				WHERE B.Target_Table = 'Map_Extended_Column_Values' 
					AND Is_Multiple = 'Y' 
					AND AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'

				INSERT INTO Map_Extended_Columns_Details (Map_Extended_Columns_Code, Columns_Value_Code)
				SELECT MEC.Map_Extended_Columns_Code, A.TalentCode
				FROM #TempTalent A
					INNER JOIN #TempTitleUnPivot AA ON AA.ExcelSrNo = A.ExcelSrNo 
					INNER JOIN extended_columns EC ON EC.Columns_Name = A.HeaderName COLLATE Latin1_General_CI_AI
					INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code = AA.RefKey AND MEC.Columns_Code = EC.Columns_Code
				WHERE AA.ColumnHeader = 'Title Name'
					AND AA.ISError <> 'Y'
				
				UPDATE DM_Title_Import_Utility_Data SET Record_Status = 'C', Error_Message = NULL WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND Record_Status IS NULL
				AND  ISNUMERIC(Col1) = 1 AND Is_Ignore = 'N'

				UPDATE DM_Master_Import SET Status = 'S' WHERE DM_Master_Import_Code = @DM_Master_Import_Code
			END
		END
		ELSE 
		BEGIN 
			UPDATE DM_Master_Import SET Status = 'E' WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(Status,'') <> 'R'
		END
	END
	END TRY
	BEGIN CATCH
		UPDATE DM_Master_Import SET Status = 'T' WHERE DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE A SET  A.Error_Message = ISNULL(Error_Message,'')  + '~' + ERROR_MESSAGE()
		FROM DM_Title_Import_Utility_Data A WHERE A.DM_Master_Import_Code = @DM_Master_Import_Code AND A.Col1 NOT LIKE '%Sr%'
	END CATCH
END
GO
PRINT N'Refreshing [dbo].[USP_Title_Import_Utility_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Import_Utility_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_Assign_Workflow]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Assign_Workflow]';


GO
PRINT N'Refreshing [dbo].[USP_Process_Workflow]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Process_Workflow]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Termination_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Termination_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Termination_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Termination_UDT]';


GO
PRINT N'Update complete.';


GO



GO
PRINT N'Dropping [dbo].[USPMHSaveCueSheetSongs]...';


GO
DROP PROCEDURE [dbo].[USPMHSaveCueSheetSongs];


GO
PRINT N'Dropping [dbo].[CueSheetSongsUDT]...';


GO
DROP TYPE [dbo].[CueSheetSongsUDT];


GO
PRINT N'Creating [dbo].[CueSheetSongsUDT]...';


GO
CREATE TYPE [dbo].[CueSheetSongsUDT] AS TABLE (
    [SrNo]           NVARCHAR (100) NULL,
    [Show Name]      NVARCHAR (100) NULL,
    [Episode]        NVARCHAR (10)  NULL,
    [Music Track]    NVARCHAR (100) NULL,
    [Movie/Album]    NVARCHAR (100) NULL,
    [Usage Type]     NVARCHAR (100) NULL,
    [TC IN]          NVARCHAR (100) NULL,
    [TC IN Frame]    NVARCHAR (100) NULL,
    [TC OUT]         NVARCHAR (100) NULL,
    [TC OUT Frame]   NVARCHAR (50)  NULL,
    [Duration]       NVARCHAR (100) NULL,
    [Duration Frame] NVARCHAR (100) NULL);


GO
PRINT N'Altering [dbo].[USPMHConsumptionRequestListDetail]...';


GO
ALTER PROCEDURE [dbo].[USPMHConsumptionRequestListDetail]
@RequestTypeCode INT,
@UsersCode INT,
@RecordFor VARCHAR(2), 
@RecordCount INT OUT,
@RequestID NVARCHAR(MAX),
@ChannelCode NVARCHAR(MAX),
@ShowCode NVARCHAR(MAX),
@StatusCode NVARCHAR(MAX),
@FromDate NVARCHAR(50) = '',
@ToDate NVARCHAR(50)= '',
@SortBy NVARCHAR(50)= '',
@Order NVARCHAR(50)= ''
AS
BEGIN
SET FMTONLY OFF
	
	--BEGIN
	--DECLARE
	--@RequestTypeCode INT = 1,
	--@UsersCode INT = 293,
	--@RecordFor VARCHAR(2) = 'L', 
	--@RecordCount INT,-- OUT,
	--@RequestID NVARCHAR(MAX) = '',
	--@ChannelCode NVARCHAR(MAX) = '',
	--@ShowCode NVARCHAR(MAX) = '',
	--@StatusCode NVARCHAR(MAX) = '',
	--@FromDate NVARCHAR(50) = '',
	--@ToDate NVARCHAR(50)= '',
	--@SortBy NVARCHAR(50)= 'TelecastFrom',
	--@Order NVARCHAR(50)= 'DESC'

	IF(OBJECT_ID('TEMPDB..#TempConsumptionList') IS NOT NULL)
		DROP TABLE #TempConsumptionList
	IF(OBJECT_ID('TEMPDB..#tempApprovedCount') IS NOT NULL)
		DROP TABLE #tempApprovedCount
	IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal

	CREATE TABLE #TempConsumptionList(
	Row_No INT IDENTITY(1,1),
	RequestID NVARCHAR(50),
	MusicLabel NVARCHAR(MAX),
	RequestCode INT,
	Title_Name NVARCHAR(100),
	EpisodeFrom INT,
	EpisodeTo INT,
	TelecastFrom DATE,
	TelecastTo NVARCHAR(50),
	CountRequest INT,
	Status NVARCHAR(50),
	Login_Name NVARCHAR(50),
	ChannelName NVARCHAR(50),
	RequestDate NVARCHAR(50)
	)

	CREATE TABLE #TempConsumptionListFinal(
	Row_No INT IDENTITY(1,1),
	RequestID NVARCHAR(50),
	MusicLabel NVARCHAR(MAX),
	RequestCode INT,
	Title_Name NVARCHAR(100),
	EpisodeFrom INT,
	EpisodeTo INT,
	TelecastFrom DATE,
	TelecastTo NVARCHAR(50),
	CountRequest INT,
	Status NVARCHAR(50),
	Login_Name NVARCHAR(50),
	ChannelName NVARCHAR(50),
	RequestDate NVARCHAR(50),
	ApprovedRequest INT,
	Music_Title NVARCHAR(MAX),
	MusicMovieAlbum NVARCHAR(MAX),
	LabelName NVARCHAR(MAX),
	Remarks NVARCHAR(MAX)
	)
	
	CREATE TABLE #tempApprovedCount
	(
	MHRequestCode INT,
	Approved INT
	)


	IF(@FromDate = '' AND @ToDate <> '')
		SET @FromDate = '01-Jan-1970'
	ELSE IF(@ToDate = '' AND @FromDate <> '')
		Set @ToDate = '31-Dec-9999'
	ELSE IF(@FromDate = '' AND @ToDate = '')
		BEGIN
			SET @FromDate = '01-Jan-1970'
			Set @ToDate = '31-Dec-9999'
		END
	
	Print @FromDate
	Print @ToDate

	INSERT INTO #tempApprovedCount(Approved,MHRequestCode)
	Select COUNT(MHRequestCode) AS ApprovedCount,MHRequestCode FROM MHRequestDetails WITH (NOLOCK)
	WHERE IsApprove = 'Y' 
	GROUP BY MHRequestCode 

	INSERT INTO #TempConsumptionList(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate)
	SELECT MR.RequestID,
	ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS VARCHAR(Max))[text()]
			 FROM MHRequestDetails MRD
			 --INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
			 LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
			 LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
			 Where MRD.MHRequestCode = MR.MHRequestCode
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) MusicLabel,
	ISNULL(MR.MHRequestCode,0) AS RequestCode,ISNULL(T.Title_Name,'') AS Title_Name ,ISNULL(MR.EpisodeFrom,'') AS EpisodeFrom,ISNULL(MR.EpisodeTo,'') AS EpisodeTo,CONVERT(DATE, ISNULL(MR.TelecastFrom,'')) AS TelecastFrom,ISNULL(MR.TelecastTo,'') AS TelecastTo,COUNT(MRD.MHRequestCode) AS CountRequest,ISNULL(MRS.RequestStatusName,'') AS Status,ISNULL(U.Login_Name,'') AS Login_Name,ISNULL(C.Channel_Name,'') AS ChannelName,
	ISNULL(MR.RequestedDate,'') AS RequestDate--, MRD.MusicTitleCode
	--INTO #tempRequest
	FROM MHRequest MR WITH(NOLOCK)
	LEFT JOIN Title T WITH(NOLOCK) ON T.Title_Code = MR.TitleCode
	LEFT JOIN MHRequestStatus MRS WITH(NOLOCK) ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
	LEFT JOIN Users U WITH(NOLOCK) ON U.Users_Code = MR.UsersCode
	LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = MR.MHRequestCode
	LEFT JOIN Channel C WITH(NOLOCK) ON C.Channel_Code = MR.ChannelCode
	WHERE MR.MHRequestTypeCode = @RequestTypeCode AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode) AND
	(@RequestID = '' OR MR.RequestID like '%'+@RequestID+'%') AND (@ChannelCode = '' OR C.Channel_Code IN(select number from dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) AND (@ShowCode = '' OR T.Title_Code IN(select number from dbo.fn_Split_withdelemiter(@ShowCode,','))) 
	AND (@StatusCode = '' OR MRS.MHRequestStatusCode IN(select number from dbo.fn_Split_withdelemiter(@StatusCode,',')))
	AND
	--((REPLACE(CONVERT(NVARCHAR,CreatedOn, 106),' ', '-') BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
	((CAST(MR.RequestedDate AS DATE) BETWEEN @FromDate AND @ToDate))
	GROUP BY MRD.MHRequestCode,MR.RequestID,T.Title_Name ,MR.EpisodeFrom,MR.EpisodeTo,MR.TelecastFrom,MR.TelecastTo,MRS.RequestStatusName,MRS.RequestStatusName,U.Login_Name,MR.RequestedDate,MR.MHRequestCode,C.Channel_Name

	SELECT @RecordCount = COUNT(*) FROM #TempConsumptionList
	Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	BEGIN
		IF(@SortBy = 'RequestDate')
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest,Music_Title,MusicMovieAlbum,LabelName,Remarks )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest, ISNULL(MT.Music_Title_Name,'''') AS Music_Title ,MA.Music_Album_Name AS MusicMovieAlbum,ISNULL(ML.Music_Label_Name,'''') AS LabelName,ISNULL(MRD.Remarks,'''') AS Remarks  
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = tcl.RequestCode
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				ORDER BY CAST('+ @SortBy + ' AS DATETIME) ' + @Order)
			END
		ELSE
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest,Music_Title,MusicMovieAlbum,LabelName,Remarks )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest, ISNULL(MT.Music_Title_Name,'''') AS Music_Title ,MA.Music_Album_Name AS MusicMovieAlbum,ISNULL(ML.Music_Label_Name,'''') AS LabelName,ISNULL(MRD.Remarks,'''') AS Remarks 
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = tcl.RequestCode
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				ORDER BY '+ @SortBy + ' ' + @Order)
			END
	END

	SELECT RequestID,ChannelName,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,Music_Title,MusicMovieAlbum,LabelName,Status,Login_Name,RequestDate,Remarks FROM #TempConsumptionListFinal


	IF OBJECT_ID('tempdb..#TempConsumptionList') IS NOT NULL DROP TABLE #TempConsumptionList
	IF OBJECT_ID('tempdb..#tempRequest') IS NOT NULL DROP TABLE #tempRequest
	IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal
END

--DECLARE @RecordCount INT
--EXEC USPMHConsumptionRequestList 1,1287,'L','Y',10,1,@RecordCount OUTPUT,'','','','','',''
--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)
GO
PRINT N'Creating [dbo].[USPMHSaveCueSheetSongs]...';


GO
CREATE PROCEDURE [dbo].[USPMHSaveCueSheetSongs](
	@udt CueSheetSongsUDT READONLY,
	@CueSheetCode INT,
	@FileName NVARCHAR(MAX),
	@UsersCode INT,
	@CueSheetCodeOut INT OUT
)
AS
BEGIN
---- Your logic
	DECLARE @VendorCode INT, @RequestID NVARCHAR(MAX), @RecordsCount INT = 0
	Select @VendorCode = Vendor_Code from MHUsers WHERE Users_Code = @UsersCode
		
	SELECT @RecordsCount = COUNT(*) FROM @udt
			
	IF(@CueSheetCode = 0)
	BEGIN

		DECLARE @Temp TABLE (
			RequestID NVARCHAR(MAX)
		)
		INSERT INTO @Temp (RequestID) 
		EXEC USPMHGetRequestID @VendorCode,'CS'

		SET @RequestID = (SELECT * FROM @Temp)
			
		INSERT INTO MHCueSheet(RequestID, [FileName], UploadStatus, VendorCode, TotalRecords, ErrorRecords, CreatedBy, CreatedOn,SubmitBy,SubmitOn)
		VALUES(@RequestID, @FileName, 'P', @VendorCode, @RecordsCount, 0, @UsersCode, GETDATE(),@UsersCode, GETDATE())

		SET @CueSheetCode =  IDENT_CURRENT('MHCueSheet');
		SET @CueSheetCodeOut = @CueSheetCode

	END
	ELSE
	BEGIN

		DELETE FROM MHCueSheetSong WHERE MHCueSheetCode = @CueSheetCode

		UPDATE MHCueSheet SET FileName = @FileName, UploadStatus = 'P', TotalRecords = @RecordsCount, CreatedOn = GETDATE() WHERE MHCueSheetCode = @CueSheetCode

		SET @CueSheetCodeOut = @CueSheetCode
	END

	INSERT INTO [dbo].[MHCueSheetSong](MHCueSheetCode, TitleName, EpisodeNo, MusicTrackName,MovieAlbum,SongType, FromTime, FromFrame, ToTime, ToFrame, DurationTime, DurationFrame)
	SELECT @CueSheetCode, [Show Name], [Episode], [Music Track],[Movie/Album],[Usage Type], [TC IN], [TC IN Frame], [TC OUT], [TC OUT Frame], [Duration], [Duration Frame]
	FROM @udt

	--Select @CueSheetCode AS CueSheetCode
END
GO
PRINT N'Update complete.';


GO
