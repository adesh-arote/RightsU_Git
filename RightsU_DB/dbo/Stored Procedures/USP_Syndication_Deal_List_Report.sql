﻿CREATE Procedure [dbo].[USP_Syndication_Deal_List_Report]
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
	@DealSegment INT,
	@TypeOfFilm INT
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
	--, @Business_Unit_code VARCHAR(100)
	--, @Is_Pushback Varchar(100)
	--, @IS_Expired Varchar(100)
	--, @IS_Theatrical varchar(100)
	--, @SysLanguageCode INT
	--, @DealSegment INT
	--,@TypeOfFilm INT 
	
	--SET @Agreement_No = ''
	--SET @Start_Date= ''
	--SET @End_Date = ''
	--SET @Deal_Tag_Code = 0
	--SET @Title_Codes = '703'
	--SET @Business_Unit_code = '1,5'
	--SET @Is_Pushback = 'N'
	--SET @IS_Expired  = 'N'
	--SET @IS_Theatrical='N'
	--SET @SysLanguageCode = 1
	--SET @DealSegment = ''
	--SET @TypeOfFilm = ''
	
	--if CHARINDEX(',',@Business_Unit_code) > 0
	--begin
	--   set @Business_Unit_code = 0
	--end
      
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
			Category_Name VARCHAR(MAX),
			Columns_Value_Code INT
			
		)
	END

	DECLARE @IsDealSegment VARCHAR(100), @IsRevenueVertical VARCHAR(100), @IsTypeOfFilm VARCHAR(MAX), @Columns_Code INT
	SELECT @IsDealSegment = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Deal_Segment' 
	SELECT @IsRevenueVertical = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Revenue_Vertical' 
	SELECT @IsTypeOfFilm = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Type_Of_Film' 
	SELECT @Columns_Code = Columns_Code FROM Extended_Columns WHERE UPPER(Columns_Name) = 'TYPE OF FILM'

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
			,Columns_Value_Code
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
			, C.Category_Name AS Category_Name,MEC.Columns_Value_Code
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
			LEFT JOIN Map_Extended_columns MEC ON MEC.Record_Code = T.Title_Code AND MEC.Columns_Code = @Columns_Code
		WHERE  
			((@IS_Theatrical = 'Y' AND @IS_Theatrical = SDR.Is_Theatrical_Right) OR (@IS_Theatrical <> 'Y')) AND 
			--sdr.Is_Theatrical_Right = @IS_Theatrical  And
			(ISNULL(CONVERT(datetime,SDR.Right_Start_Date,1) , '') >= CONVERT(datetime,@Start_Date,1) OR CONVERT(datetime,@Start_Date,1) = '')		
			AND (ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), '') <= CONVERT(datetime,@End_Date,1) OR CONVERT(datetime,@End_Date,1) = '')
			AND SD.Agreement_No like '%' + @Agreement_No + '%' 
			AND (ISNULL(SDR.Is_Pushback, 'N') = @Is_Pushback OR @Is_Pushback = '')
			AND (SD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
			--AND(@Business_Unit_code = '' OR SD.Business_Unit_Code in(select number from fn_Split_withdelemiter(@Title_Codes,',')))
			--AND (SD.Business_Unit_Code = CAST(@Business_Unit_code AS INT) OR CAST(@Business_Unit_code AS INT) = 0)
			AND (SD.Business_Unit_Code IN (select number from fn_Split_withdelemiter(@Business_Unit_code,',')))
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

		IF(@IsTypeOfFilm = 'Y' AND @TypeOfFilm > 0)
		BEGIN
			DELETE FROM #TEMP_Syndication_Deal_List_Report
			WHERE (Columns_Value_Code <> @TypeOfFilm ) OR Columns_Value_Code IS NULL
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
		ORDER BY TEMP_SDLR.Business_Unit_Name, TEMP_SDLR.Agreement_No, TEMP_SDLR.Is_Pushback
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
			ORDER BY Sorter, [Business Unit Name], [Agreement_No]
		END
		ELSE
		BEGIN
			SELECT * FROM #TempSynDealListReport order by Business_Unit_Name, Agreement_No
		END

	END
END
