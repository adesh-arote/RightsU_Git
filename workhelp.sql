select * from promoter_group
select * from promoter_remarks

INNER JOIN Syndication_Deal_Rights_Promoter
INNER JOIN Promoter_group ON PG.Promoter_Group_Code =

select * from Syn_Deal_Rights_Promoter_Group

select * from Syn_Deal_Rights_Promoter WHERe Syn_deal_rights_Code IN(7098,7097,7096,7095,7094,7093,7089,7086,7085,7084,7082,7080,7079,7076,7064,7060,7059)


select sdr.syn_deal_code, sdr.milestone_type_code, sd.business_unit_code from syn_deal_Rights sdr
inner join syn_deal sd on sd.syn_deal_code = sdr.syn_Deal_code
where sdr.milestone_type_code = 1 and sd.business_unit_code = 1 AND sdr.Actual_Right_End_Date > GETDATE()

select top 10 * from syn_deal

select * from business_unit

select * from Milestone_type
select * from acq_Deal
select * from title where title_name like '%????'

select * from role

select * from Syn_Deal_Rights_Holdback

select * from syn_deal

BUSINESS_UNIT_CODE~AND~=~1|EXPIRED~AND~=~N|IS_THEATRICAL_RIGHT~=~N|TIT.TITLE_CODE~AND~IN~29782|


Create Table QueryTest(
Sql_SELECT VARCHAR(MAX),
Sql_WHERE NVARCHAR(MAX),
Column_Count INT,
Column_Names VARCHAR(MAX),
Report_Query_Code INT,
Subtitling_Codes VARCHAR(MAX),
Dubbing_Codes VARCHAR(MAX),
Country_Codes VARCHAR(MAX),
Category_Codes VARCHAR(MAX),
Is_Debug CHAR(1)
)

Insert into QueryTest(Sql_SELECT,Sql_WHERE,Column_Count,Column_Names,Report_Query_Code,Subtitling_Codes,Dubbing_Codes,Country_Codes,Category_Codes,Is_Debug)
	VALUES ('Title_Name [Title], Deal_Tag_Description [Status], Vendor_Name [Licensee], CONVERT(VARCHAR,Actual_Right_Start_Date,103) [Right Start Date], CONVERT(VARCHAR,Agreement_Date,103) [Agreement Date], CONVERT(VARCHAR,Actual_Right_End_Date,103) [Right End Date]','BUSINESS_UNIT_CODE~AND~=~1|SD.AGREEMENT_DATE~AND~>~01/09/2018|',7,'Title,Status,Licensee,Right Start Date,Agreement Date,Right End Date,',0,'','','','','N')
	

	select * from QueryTest

	Sql_SELECT,Sql_WHERE,Column_Count,Column_Names,Report_Query_Code,Subtitling_Codes,Dubbing_Codes,Country_Codes,Category_Codes,Is_Debug

	truncate table querytest

select * from report_column_setup where display_name like '%mile%'    IsPartofSelectOnly in ('Y','B') AND View_Name = 'VW_Syn_DEALS' and Alternate_Config_Code is null
select * from report_column_setup where IsPartofSelectOnly in ('N','B') AND View_Name = 'VW_Syn_DEALS'
01/09/2018
select * from title where title_code=11884

select * from Syn_deal_rights where Milestone_type_code is not null

select Distinct Business_UNIT_code  from Syn_deal where agreement_date > 01/09/2018
233
1293
1294
1342
1375
s

select * from report_Query where Query

2094
select * from report_condition where Query_code=2094

UPDATE #tempRights SET Subtitling = DBO.UFN_Get_Rights_Subtitling(Syn_Deal_Rights_Code, 'A')

select * from Title_Talent where Role_Code=2

select * from Platform

-----backupo------

-- ALTER PROCEDURE [dbo].[USP_Syn_Query_Report]
--	@Sql_SELECT VARCHAR(MAX),
--	@Sql_WHERE NVARCHAR(MAX),
--	@Column_Count INT,
--	@Column_Names VARCHAR(MAX),
--	@Report_Query_Code INT=0,
--	@Subtitling_Codes VARCHAR(MAX),
--	@Dubbing_Codes VARCHAR(MAX),
--	@Country_Codes VARCHAR(MAX),
--	@Category_Codes VARCHAR(MAX),
--	@Is_Debug CHAR(1)
--	@CBFCRating_Codes VARCHAR(MAX)
--AS


BEGIN
	SET NOCOUNT ON 
	
	--DECLARE @Condition NVARCHAR(MAX) = 'BUSINESS_UNIT_CODE~AND~=~1|EXPIRED~AND~=~N|TIT.TITLE_CODE~AND~IN~10179|SD.AGREEMENT_NO~AND~=~S-2009|SD.DEAL_DESCRIPTION~AND~=~JKCVNF|SD.DEAL_TAG_CODE~AND~=~2|TIT.ORIGINAL_TITLE~AND~=~HELLO|P.PLATFORM_CODE~AND~NOT IN~10,19|SD.VENDOR_CODE~AND~IN~703,959|SDR.ACTUAL_RIGHT_START_DATE~AND~=~19/08/2020|SDR.ACTUAL_RIGHT_END_DATE~AND~BETWEEN~19/08/2020 AND 21/08/2020|COU.COUNTRY_CODE~AND~IN~2,182|DIRECTOR_CODE~AND~NOT IN~57524,57528|STARCAST_CODE~AND~IN~57525,57527|SD.CURRENCY_CODE~AND~=~5|SD.ENTITY_CODE~AND~=~1|SD.AGREEMENT_DATE~AND~=~14/08/2020|TIT.YEAR_OF_PRODUCTION~AND~=~22/08/2020|SDR.IS_SUB_LICENSE~AND~IN~N|SDR.EXPIRED~AND~IN~Y,N|SD.ROLE_CODE~AND~=~12|S_LANG~AND~IN~24,46|D_LANG~AND~NOT IN~54,24|ORIGINAL_DUBBED~AND~IN~DUBBED|SD.DEAL_TYPE_CODE~AND~IN~13,11|SD.SALES_AGENT_CODE~AND~IN~455,936|GENRES_CODE~AND~NOT IN~72,134|'--AD.CATEGORY_TYPE~AND~=~C|CHANNELNAMES~AND~IN~31,38,29,19|P.PLATFORM_CODE~AND~IN~10,7,43,11
	--DECLARE @ColNames NVARCHAR(MAX) = 'Title,Agreement No,Deal Description,Status,Original Title,Platform,Licensee,Right Start Date,Right End Date,Country,Director,Star Cast,Currency,Entity,Subtitling,Dubbing,Business Unit,Agreement Date,Year of Release,Exclusive,Territory,Term,Customer Type,Sub-Licensing,Original/Dubbed,Deal Type,Deal Workflow Status,Genre,Sales Agent,'
	
	--DECLARE @Condition NVARCHAR(MAX) = 'BUSINESS_UNIT_CODE~AND~=~1|EXPIRED~AND~=~Y|TIT.TITLE_CODE~AND~NOT IN~11884|'
	--DECLARE @ColNames NVARCHAR(MAX) = 'Title,agreement no,Deal workflow status'

	DECLARE @Condition NVARCHAR(MAX) = 'BUSINESS_UNIT_CODE~AND~=~1|SD.AGREEMENT_DATE~AND~>~01/09/2018|'
	DECLARE @ColNames NVARCHAR(MAX) = 'Title,Agreement No,Deal Description,Status,Original Title,Platform,Licensee,Right Start Date,Right End Date,Country,Director,Star Cast,Currency,Entity,Subtitling,Dubbing,Business Unit,Agreement Date,Year of Release,Exclusive,Territory,Term,Customer Type,Sub-Licensing,Original/Dubbed,Deal Type,Deal Workflow Status,Genre,Sales Agent,Holdback,Self Utilization Remarks,Restriction Remarks,CBFC Rating,Self Utilization Group'



	--DECLARE @Condition NVARCHAR(MAX) = @Sql_Where
	--DECLARE @ColNames NVARCHAR(MAX) = @Column_Names

	IF(OBJECT_ID('tempdb..#buwiseSyn_deal_code') IS NOT NULL) DROP TABLE #buwiseSyn_deal_code
	IF(OBJECT_ID('tempdb..#Temp_Condition') IS NOT NULL) DROP TABLE #Temp_Condition
	IF(OBJECT_ID('tempdb..#TempOutput') IS NOT NULL) DROP TABLE #TempOutput
	IF(OBJECT_ID('tempdb..#tempTitle') IS NOT NULL) DROP TABLE #tempTitle
	IF(OBJECT_ID('tempdb..#tempDeal') IS NOT NULL) DROP TABLE #tempDeal
	IF(OBJECT_ID('tempdb..#tempRights') IS NOT NULL) DROP TABLE #tempRights
	IF(OBJECT_ID('tempdb..#dummyRights') IS NOT NULL) DROP TABLE #dummyRights
	IF(OBJECT_ID('tempdb..#dummyCriteria') IS NOT NULL) DROP TABLE #dummyCriteria
	IF(OBJECT_ID('tempdb..#tmpDisplay') IS NOT NULL) DROP TABLE #tmpDisplay
	IF(OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL) DROP TABLE #Platform_Search
	IF(OBJECT_ID('tempdb..#TempLang') IS NOT NULL) DROP TABLE #TempLang
	IF(OBJECT_ID('tempdb..#tempRunDef') IS NOT NULL) DROP TABLE #tempRunDef
	IF(OBJECT_ID('tempdb..#RunDef') IS NOT NULL) DROP TABLE #RunDef
	IF(OBJECT_ID('tempdb..#TempTerritory') IS NOT NULL) DROP TABLE #TempTerritory
	IF(OBJECT_ID('tempdb..#tempBusinessUnit') IS NOT NULL) DROP TABLE #tempBusinessUnit
	IF(OBJECT_ID('tempdb..#tbl_Platform_RightCodes') IS NOT NULL) DROP TABLE #tbl_Platform_RightCodes
	IF(OBJECT_ID('tempdb..#Temp_ColNames') IS NOT NULL) DROP TABLE #Temp_ColNames
	IF(OBJECT_ID('tempdb..#OriDub_Title_Code') IS NOT NULL) DROP TABLE #OriDub_Title_Code
	IF(OBJECT_ID('tempdb..#tblRights_Newholdback') IS NOT NULL) DROP TABLE #tblRights_Newholdback
	
	CREATE TABLE #TempOutput
	(
		COL1 NVARCHAR(MAX),
		COL2 NVARCHAR(MAX),
		COL3 NVARCHAR(MAX),
		COL4 NVARCHAR(MAX),
		COL5 NVARCHAR(MAX),
		COL6 NVARCHAR(MAX),
		COL7 NVARCHAR(MAX),
		COL8 NVARCHAR(MAX),
		COL9 NVARCHAR(MAX),
		COL10 NVARCHAR(MAX),
		COL11 NVARCHAR(MAX),
		COL12 NVARCHAR(MAX),
		COL13 NVARCHAR(MAX),
		COL14 NVARCHAR(MAX),
		COL15 NVARCHAR(MAX),
		COL16 NVARCHAR(MAX),
		COL17 NVARCHAR(MAX),
		COL18 NVARCHAR(MAX),
		COL19 NVARCHAR(MAX),
		COL20 NVARCHAR(MAX),
		COL21 NVARCHAR(MAX),
		COL22 NVARCHAR(MAX),
		COL23 NVARCHAR(MAX),
		COL24 NVARCHAR(MAX),
		COL25 NVARCHAR(MAX),
		COL26 NVARCHAR(MAX),
		COL27 NVARCHAR(MAX),
		COL28 NVARCHAR(MAX),
		COL29 NVARCHAR(MAX),
		COL30 NVARCHAR(MAX),
		COL31 NVARCHAR(MAX),
		COL32 NVARCHAR(MAX),
		COL33 NVARCHAR(MAX),
		COL34 NVARCHAR(MAX),
		COL35 NVARCHAR(MAX),
		COL36 NVARCHAR(MAX),
		COL37 NVARCHAR(MAX),
		COL38 NVARCHAR(MAX),
	)
	
	CREATE TABLE #BUWiseSyn_Deal_Code (Syn_Deal_Code INT)
	CREATE TABLE #tbl_Platform_RightCodes (Syn_Deal_Code INT, Syn_Deal_Rights_Code INT)
	CREATE TABLE #tempTitle(
		Title_Code INT,
		Title NVARCHAR(MAX),
		[Original_Title] NVARCHAR(MAX),
		Original_Dubbed NVARCHAR(MAX),
		Genre NVARCHAR(MAX),
		Year_of_Release VARCHAR(100),
		Director NVARCHAR(MAX),
		Star_Cast NVARCHAR(MAX),
		CBFC_Rating INT,
		CoLumn_Value VARCHAR(MAX)
	)
	
	CREATE TABLE #tempDeal(
		Syn_Deal_Code INT,
		Agreement_Date NVARCHAR(MAX),
		Agreement_No NVARCHAR(MAX),
		Business_Unit NVARCHAR(MAX),
		Currency NVARCHAR(MAX),
		Deal_Category NVARCHAR(MAX),
		Deal_Description NVARCHAR(MAX),
		Deal_Type NVARCHAR(MAX),
		Deal_Workflow_Status NVARCHAR(MAX),
		Entity NVARCHAR(MAX),
		[Licensor] NVARCHAR(MAX),
		Status NVARCHAR(MAX),
		Currency_Code INT,
		Deal_Category_Code INT,
		Entity_Code INT,
		Vendor_Code INT,
		Deal_Tag_Code INT,
		Deal_Type_Code INT,
		Customer_Type NVARCHAR(4000),
		Sales_Agent_Code INT,
		Sales_Agent NVARCHAR(MAX),
		Variable_Cost_Type  NVARChar(MAX),
		Restriction_Remarks NVARChar(MAX),
		ROFR NVARChar(MAX)

	)
	
	CREATE TABLE #tempRights(
		Syn_Deal_Rights_Code INT,
		Syn_Deal_Code INT,
		Title_Code INT,
		Country NVARCHAR(MAX),
		Dubbing NVARCHAR(MAX),
		Exclusive NVARCHAR(MAX),
		[Platform] NVARCHAR(MAX),
		Right_End_Date DATE,
		Right_Start_Date DATE,
		[Sub-Licensing] NVARCHAR(MAX),
		Subtitling NVARCHAR(MAX),
		Term NVARCHAR(MAX),
		Territory NVARCHAR(MAX),
		Episode_From INT,
		Episode_To INT,
		Title_Name NVARCHAR(MAX),
		Milestone_Type_Code INT,
		Milestone_Type_Name VARCHAR(MAX),
		Self_Utilization_Group VARCHAR(MAX),
		Is_holdback varchar(max),
		Self_Utilization_Remark VArchar(MAx),
		Expired_deal VArchar(MAX)
		
	)
	
	CREATE TABLE #tempRunDef(
		Syn_Deal_Code INT,
		Title_Code INT,
		[Channel] NVARCHAR(MAX),
		Run_Limitation VARCHAR(MAX)
		
	)
	
	DECLARE @tblTitle TABLE(Title_Code INT, Original_Title NVARCHAR(MAX), Original_Dubbed NVARCHAR(MAX), Year_of_Release INT,CBFC_Rating INT,CoLumn_Value VARCHAR(MAX))
	
	DECLARE @tblDeal TABLE (
		Syn_Deal_Code INT,
		Agreement_Date NVARCHAR(MAX),
		Agreement_No NVARCHAR(MAX),
		Business_Unit NVARCHAR(MAX),
		Currency NVARCHAR(MAX),
		Deal_Category NVARCHAR(MAX),
		Deal_Description NVARCHAR(MAX),
		Deal_Type NVARCHAR(MAX),
		Deal_Workflow_Status NVARCHAR(MAX),
		Entity NVARCHAR(MAX),
		[Licensor] NVARCHAR(MAX),
		Status NVARCHAR(MAX),
		Currency_Code INT,
		Deal_Category_Code INT,
		Entity_Code INT,
		Vendor_Code INT,
		Deal_Tag_Code INT,
		Deal_Type_Code INT,
		Customer_Type NVARCHAR(4000),
		Role_Code INT,
		Sales_Agent_Code INT,
		Sales_Agent NVARCHAR(MAX),
		Variable_Cost_Type  NVARChar(MAX),
		Restriction_Remarks NVARChar(MAX),
		ROFR NVARChar(MAX)
	)
	
	DECLARE @tblRights_New TABLE(
		Syn_Deal_Rights_Code INT,
		Syn_Deal_Code INT,
		Title_Code INT,
		Country NVARCHAR(MAX),
		Dubbing NVARCHAR(MAX),
		Exclusive NVARCHAR(MAX),
		Platform NVARCHAR(MAX),
		Right_End_Date DATE,
		Right_Start_Date DATE,
		[Sub-Licensing] NVARCHAR(MAX),
		Subtitling NVARCHAR(MAX),
		Term NVARCHAR(MAX),
		Territory NVARCHAR(MAX),
		Episode_From INT,
		Episode_To INT,
		Title_Name NVARCHAR(MAX),
		Milestone_Type_Code INT,
		Milestone_Type_Name VARCHAR(MAX),
		Self_Utilization_Group VARCHAR(MAX),
		Is_holdback varchar(max),
		Self_Utilization_Remark VArchar(MAx),
		Expired_deal VArchar(MAX)
	)

	Create TABLE #tblRights_Newholdback (
		Syn_Deal_Rights_Code INT,
		Syn_Deal_Code INT,
		Title_Code INT,
		Country NVARCHAR(MAX),
		Dubbing NVARCHAR(MAX),
		Exclusive NVARCHAR(MAX),
		Platform NVARCHAR(MAX),
		Right_End_Date DATE,
		Right_Start_Date DATE,
		[Sub-Licensing] NVARCHAR(MAX),
		Subtitling NVARCHAR(MAX),
		Term NVARCHAR(MAX),
		Territory NVARCHAR(MAX),
		Episode_From INT,
		Episode_To INT,
		Title_Name NVARCHAR(MAX),
		Milestone_Type_Code INT,
		Milestone_Type_Name VARCHAR(MAX),
		Self_Utilization_Group VARCHAR(MAX),
		Is_holdback varchar(MAX),
		Self_Utilization_Remark VArchar(MAX)
	)
	
	DECLARE @tblRunDef TABLE(
		Syn_Deal_Code INT,
		Title_Code INT,
		[Channel] NVARCHAR(MAX),
		Run_Limitation VARCHAR(MAX)
	)

	SELECT 
		ECV.Columns_Value,
		Record_Code
	INTO #OriDub_Title_Code
	FROM Map_Extended_Columns MEC
		INNER JOIN Title T ON T.Title_Code = MEC.Record_Code
		LEFT JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
	WHERE 
		MEC.Table_Name='TITLE' 
		AND MEC.Columns_Code IN (SELECT Columns_Code FROM Extended_Columns WHERE Columns_Name = 'Type of Film')

	DECLARE @tblCriteria TABLE(Id INT, ColCriteria NVARCHAR(MAX))
	
	DECLARE --Conditions
		@whTitle  NVARCHAR(MAX) = ' 1=1 ',
		@whDeal	  NVARCHAR(MAX) = ' 1=1 ',
		@whRights VARCHAR(MAX) = ' 1=1 ',
		@whRunDef NVARCHAR(MAX) = ' 1=1 '
	----------------------------------------------------
	
	
	PRINT'INSERTING INTO #TEMP TABLE'
	SELECT id as SrNo, number as Operation INTO #Temp_Condition FROM DBO.fn_Split_withdelemiter(@Condition,'|') WHERE number <> ''
	
	PRINT'DECLARATION'
	DECLARE @Counter INT = 1, @Cnt_TempCond INT = 0, @Operation NVARCHAR(MAX), @IncludeExpired CHAR(1) = 'Y'
	DECLARE @LeftColDbname NVARCHAR(MAX),
			@logicalConnect NVARCHAR(MAX),
			@theOp NVARCHAR(MAX),
			@Value NVARCHAR(MAX)
	DECLARE @Start_Date varchar(10), @End_Date varchar(10)
	
	SELECT @Cnt_TempCond = COUNT(*) FROM #Temp_Condition

	IF EXISTS(SELECT * FROM #Temp_Condition where Operation ='EXPIRED~AND~=~N')
		SET @IncludeExpired = 'N'

	PRINT'LOOPING THROUGHOUT CONDITION'
	PRINT'TITLE_RELATED CRITERIA STARTS'
	WHILE ( @Counter <= @Cnt_TempCond)
	BEGIN
		SELECT @Operation = '', @LeftColDbname = '', @logicalConnect = '', @theOp = '', @Value = '',@Start_Date ='', @End_Date =''
		DELETE FROM @tblCriteria
	
		SELECT @Operation = Operation FROM #Temp_Condition WHERE SrNo = @Counter
	
		INSERT INTO @tblCriteria (Id, ColCriteria)
		SELECT id, number  FROM DBO.fn_Split_withdelemiter(@Operation,'~')
	
		SELECT  @LeftColDbname = ColCriteria  FROM @tblCriteria  where id = 1
		SELECT  @logicalConnect = ColCriteria  FROM @tblCriteria where id = 2
		SELECT  @theOp = ColCriteria  FROM @tblCriteria where id = 3
		SELECT  @Value = ColCriteria  FROM @tblCriteria where id = 4
	
		PRINT '	'+ @Operation

		IF(@LeftColDbname = 'BUSINESS_UNIT_CODE')
		BEGIN
			INSERT INTO #BUWiseSyn_Deal_Code(Syn_Deal_code)
			EXEC('SELECT Syn_Deal_code FROM Syn_Deal WHERE Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND Business_Unit_Code '+@theOp+' '+@Value )
	
			INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed, Year_of_Release,CBFC_Rating)
			SELECT Title_Code, Original_Title, ISNULL(OD.Columns_Value,'NA'), Year_Of_Production,mec.Columns_Value_Code FROM Title t 
			INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
			LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
			
			INSERT INTO #tempRights(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
			SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
				CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
				CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.MileStone_Type_Code,
				dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','S')  
				as Promoter_Group_Name,
				dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','S')  
				as Promoter_Remark_Desc,
				CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
				CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
				FROM Syn_Deal ad
				INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
				INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code --AND adr.PA_Right_Type = 'PR'
				INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
				INNER JOIN #tempTitle tt ON tt.Title_Code = adrt.Title_Code
				--INNER JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
				LEFT JOIN Milestone_Type M On M.Milestone_type_code=adr.Milestone_type_code
				WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

				select * from #temprights

			--select top 20 * from #tempRights order by 1
			--select distinct self_utilization_group from #tempRights
	
			DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
	
			INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
			SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
			FROM Syn_Deal ad
			INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
			LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
			LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
			LEFT JOIN Category C On C.Category_Code=ad.Category_Code

			--select * from #tempDeal
			

	
			INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
			SELECT DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights
		END
	
		IF(@logicalConnect = 'AND')
		BEGIN
			IF(@theOp = 'IN')
				SET @theOp = 'NOT IN '
			ELSE IF(@theOp = 'NOT IN')
				SET @theOp = 'IN'
		END
		PRINT'TITLE CRITERIA START'
		BEGIN
			IF(@LeftColDbname = 'TIT.TITLE_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
			
				--Select distinct title_code from #tempTitle
				
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' ('+@Value+')')
				--Select distinct title_code from #tempTitle
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
				--select distinct title_code from #tempRights

					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
						
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release,CbFc_rating)
					EXEC ('Select Distinct t.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production,mec.Columns_Value_Code
						   FROM Title t 
						   INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
						   WHERE t.Title_Code '+@theOp+' ('+@Value+')
						   AND Reference_Flag IS NULL')
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
	
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					--INNER JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
	
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_rating FROM @tblTitle T
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END			
			END

			IF(@LeftColDbname = 'Columns_Value')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' ('+@Value+') OR CBFC_Rating IS NULL')
	
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
						
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release,CBFC_Rating)
					EXEC ('Select Distinct t.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production,mec.Columns_Value_Code  AS CBFC_Rating
						   FROM Title t 
						   INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
						   WHERE mec.Columns_Value_Code '+@theOp+' ('+@Value+')')
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
	
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					LEFT JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--INNER JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
	
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code

									
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END			
			END--CBFC_Rating end

			IF(@LeftColDbname = 'ORIGINAL_DUBBED')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Original_Dubbed '+@theOp+' ('''+@Value+''')')
	
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
						
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release,Cbfc_rating)
					EXEC ('Select Distinct t.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production,MEc.Columns_Value_Code
						   FROM Title t 
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
						   WHERE ISNULL(OD.Columns_Value,''NA'') '+@theOp+' ('''+@Value+''')
						   AND T.Reference_Flag IS NULL')
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
	
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
	
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END			
			END
	
			IF(@LeftColDbname = 'DIRECTOR_CODE')
			BEGIN
	
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+'))')
			
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production,mec.Columns_Value_Code FROM Title_Talent tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
						   WHERE tg.Talent_Code IN ('+@Value+')
						   AND Reference_Flag IS NULL')
				
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_Rating 
					FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END
			END
	
			IF(@LeftColDbname = 'STARCAST_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+'))')
			
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release,cbfc_rating)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production,mec.Columns_Value_Code FROM Title_Talent tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
						   WHERE tg.Talent_Code IN ('+@Value+')
						   AND Reference_Flag IS NULL')
				
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					INNER JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblTitle
				END
			
			END
	
			IF(@LeftColDbname = 'GENRES_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' (SELECT Title_Code FROM Title_Geners WHERE Genres_Code IN ('+@Value+'))')
	
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
	
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE IF(@logicalConnect = 'OR')
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release,CBFC_rating)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production,mec.Columns_Value_Code FROM Title_Geners tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code
						   INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
						   WHERE tg.Genres_Code IN ('+@Value+')
						   AND Reference_Flag IS NULL')
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
	
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					LEFT JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
	
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					--TRUNCATE TABLE #tempRunDef
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END
			END
	
			IF(@LeftColDbname = 'TIT.ORIGINAL_TITLE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE title_code NOT IN ( SELECT title_code FROM #tempTitle WHERE Original_Title '+@theOp +' '''+  @Value +''')')
				
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle (Title_Code, Original_Title,Original_Dubbed, Year_of_Release,cbfc_rating)
					EXEC ('SELECT DISTINCT t.Title_Code, t.Original_Title,ISNULL(OD.Columns_Value,''NA''), t.Year_Of_Production,mec.Columns_Value_Code FROM Title T
							INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
							LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
							WHERE t.Original_Title '+@theOp +' '''+  @Value +''' AND Reference_Flag IS NULL')
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblTitle
			
				END
			END
	
			IF(@LeftColDbname = 'TIT.YEAR_OF_PRODUCTION')
			BEGIN
				IF @theOp = 'BETWEEN'
				BEGIN
					SELECT @Start_Date  = SUBSTRING(@Value,1,10) 
					SELECT @End_Date	= SUBSTRING(@Value,lEN(@Value) -9,11) 	
					SELECT @Value =  CAST(YEAR(CONVERT(DATE,@Start_Date,103)) AS VARCHAR)  + ' AND ' + CAST( YEAR(CONVERT(DATE,@End_Date,103)) AS VARCHAR)
				END
				ELSE
					SELECT @Value =  CAST(YEAR(CONVERT(DATE,@Value,103)) AS VARCHAR)
	
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC (' DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempTitle WHERE Year_Of_Release '+@theOp +' '+  @Value +')')
	
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle (Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					EXEC ('SELECT DISTINCT t.Title_Code, t.Original_Title,ISNULL(OD.Columns_Value,''NA''), t.Year_Of_Production,mec.Columns_Value_Code FROM Title T
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE t.Year_Of_Production '+@theOp +' '+  @Value )
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = AD.Syn_Deal_code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
					AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release,CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblTitle
			
				END
			END
		END
		PRINT'Syn DEAL CRITERIA START'
		BEGIN
			IF(@LeftColDbname = 'SD.AGREEMENT_NO')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF(@theOp = '=')
						EXEC ('DELETE FROM #tempDeal WHERE Agreement_No <> '''+@Value+''' ')
					ELSE
						EXEC ('DELETE FROM #tempDeal WHERE Agreement_No NOT '+@theOp+' '''+@Value+''' ')
					
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (SELECT Syn_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
					
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
						   FROM Syn_Deal ad
						   INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
						   LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
						   LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
						   LEFT JOIN Category C On C.Category_Code=ad.Category_Code

	
						   WHERE Agreement_No '+@theOp+' '''+@Value+''' ')
					
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
	
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,ad.Variable_Cost_Type,ad.Restriction_Remarks,ad.Deal_Category,aD.ROFR
					FROM @tblDeal AD
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				END
			END
	
			IF(@LeftColDbname = 'SD.DEAL_DESCRIPTION')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF(@theOp = '=')
						EXEC ('DELETE FROM #tempDeal WHERE Deal_Description <> '''+@Value+''' ')
					ELSE
						EXEC ('DELETE FROM #tempDeal WHERE Deal_Description NOT '+@theOp+' '''+@Value+''' ')
	
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (SELECT Syn_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE Deal_Description '+@theOp+' '''+@Value+''' ')
				
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_Category,AD.ROFR
					FROM @tblDeal AD
					
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				END
			END
	
			IF(@LeftColDbname = 'SD.VENDOR_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
			
					EXEC ('DELETE FROM #tempDeal WHERE Vendor_Code '+@theOp+' ('+@Value+')')
				
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
				
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
						   
					WHERE Vendor_Code '+@theOp+' ('+@Value+') ')
				
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_Category,AD.ROFR
					FROM @tblDeal AD
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					--INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					--Select DISTINCT Syn_Deal_Code, Title_Code 
					--FROM #tempRights tr
					--WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				
				END
			END

			IF(@LeftColDbname = 'Cat_Name')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
				print 'enter category'
					EXEC ('DELETE FROM #tempDeal WHERE Deal_Category_Code '+@theOp+' ('+@Value+')')
					print 'DELETE FROM #tempDeal WHERE Deal_Category_Code '+@theOp+' ('+@Value+')'
				
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
				
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
						   
					WHERE ad.Category_Code '+@theOp+' ('+@Value+') ')
					--select * from @tblDeal
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_Category,AD.ROFR
					FROM @tblDeal AD
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				
				END
			END

			IF(@LeftColDbname = 'SD.SALES_AGENT_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE SALES_AGENT_CODE '+@theOp+' ('+@Value+')')
				
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
				
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
						   
					WHERE ad.SALES_AGENT_CODE '+@theOp+' ('+@Value+') ')
				
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_category,AD.ROFR
					FROM @tblDeal AD
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				
				END
			END
	
			IF(@LeftColDbname = 'SD.CURRENCY_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'
	
					EXEC ('DELETE FROM #tempDeal WHERE Currency_Code '+@theOp+' ('+@Value+') ')
				
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
						   
					 WHERE CURRENCY_CODE '+@theOp+' '''+@Value+''' ')
				
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_category,AD.ROFR
					FROM @tblDeal AD
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				END
			END
	
			IF(@LeftColDbname = 'SD.ENTITY_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'
	
					EXEC ('DELETE FROM #tempDeal WHERE Entity_Code '+@theOp+' '''+@Value+'''')
				
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
						   
					WHERE ENTITY_CODE '+@theOp+' '''+@Value+''' ')
				
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback,
					CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_Category,AD.ROFR
					FROM @tblDeal AD
					
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				END
			END
	
			IF(@LeftColDbname = 'SD.AGREEMENT_DATE')
			BEGIN
				IF @theOp = 'BETWEEN'
				BEGIN
					SELECT @Start_Date  = SUBSTRING(@Value,1,10) 
					SELECT @End_Date	= SUBSTRING(@Value,lEN(@Value) -9,11) 	
					SELECT @Value =  ' CONVERT(DATE,'''+@Start_Date+''',103) AND CONVERT(DATE,'''+@End_Date+''',103)'
				END
				ELSE
					SELECT @Value =  ' CONVERT(DATE,'''+@Value+''',103)'
	
				IF(@logicalConnect = 'AND')
				BEGIN				
					EXEC (' DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal WHERE AGREEMENT_DATE '+@theOp +' '+  @Value +')')
	
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
	
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
	
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
						   
					WHERE  ad.AGREEMENT_DATE '+@theOp+' '+@Value)
					
	
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
	
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback
					,CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
	
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_Category,AD.ROFR
					FROM @tblDeal AD
					
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblDeal
				END
			END

			IF(@LeftColDbname = 'SD.ROLE_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'
	
					EXEC ('DELETE FROM #tempDeal WHERE Customer_Type '+@theOp+' '''+@Value+''' ')

					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE Customer_Type '+@theOp+' '''+@Value+''' ')
				
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback
					,CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_Category,AD.ROFR
					FROM @tblDeal AD
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				END
			END
			
			IF(@LeftColDbname = 'SD.DEAL_TAG_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'
	
					EXEC ('DELETE FROM #tempDeal WHERE DEAL_TAG_CODE '+@theOp+' '''+@Value+''' ')
				
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE DEAL_TAG_CODE '+@theOp+' '''+@Value+''' ')
				
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback
					,CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_Category,AD.ROFR
					FROM @tblDeal AD
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				END
			END
	
			IF(@LeftColDbname = 'SD.DEAL_TYPE_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE DEAL_TYPE_CODE '+@theOp+' ('+@Value+') ')
			
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
			
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
			
					INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					EXEC ('SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code tbu ON tbu.Syn_deal_Code = ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					   WHERE DEAL_TYPE_CODE '+@theOp+' ('+@Value+') ')
			
					Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)
			
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,M.Milestone_Type_code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc,
					CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback
					,CASE WHEN adr.Actual_Right_End_Date > getdate() then 'Active' Else 'Expired' END AS Expired_Deals
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = adr.Syn_Deal_code
					--LEFT JOIN Syn_Deal_Rights_Error_Details sdred ON sdred.syn_deal_rights_code=adr.Syn_Deal_Rights_Code
					INNER JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
			
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,AD.Variable_Cost_Type,AD.Restriction_Remarks,AD.Deal_category,AD.ROFR
					FROM @tblDeal AD
					
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
			
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblDeal
				END
			END
		END
		PRINT'Syn DEAL RIGHTS CRITERIA START'
		BEGIN
			IF(@LeftColDbname = 'SDR.ACTUAL_RIGHT_START_DATE')
			BEGIN
				IF @theOp = 'BETWEEN'
				BEGIN
					SELECT @Start_Date  = SUBSTRING(@Value,1,10) 
					SELECT @End_Date	= SUBSTRING(@Value,lEN(@Value) -9,11) 	
					SELECT @Value =  'CONVERT(DATE,''' + @Start_Date + ''',103) AND CONVERT(DATE,''' + @End_Date + ''',103)'
				END
				ELSE
					SELECT @Value =  'CONVERT(DATE,'''+ @Value +''',103)'
	
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code NOT IN (Select Syn_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_Start_Date, ''9999-12-31'')  '+@theOp +' '+  @Value +')')
	
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
	
					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND ISNULL(adr.Actual_Right_Start_Date, ''9999-12-31'')  '+@theOp +' '+  @Value 
					)
	
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_deal
					FROM @tblRights_New
	
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					wherE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
				END
			END
	
			IF(@LeftColDbname = 'SDR.ACTUAL_RIGHT_END_DATE')
			BEGIN
				IF @theOp = 'BETWEEN'
				BEGIN
					SELECT @Start_Date  = SUBSTRING(@Value,1,10) 
					SELECT @End_Date	= SUBSTRING(@Value,lEN(@Value) -9,11) 	
					SELECT @Value =  'CONVERT(DATE,''' + @Start_Date + ''',103) AND CONVERT(DATE,''' + @End_Date + ''',103)'
				END
				ELSE
					SELECT @Value =  'CONVERT(DATE,'''+ @Value +''',103)'
	
					IF(@logicalConnect = 'AND')
					BEGIN
						EXEC('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code NOT IN (Select Syn_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_End_Date, ''9999-12-31'')  '+@theOp +' '+  @Value +')')
						
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)
	
						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New
	
							INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND ISNULL(adr.Actual_Right_Start_Date, ''9999-12-31'')  '+@theOp +' '+  @Value 
					)
						
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
						
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
						FROM @tblRights_New
	
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
						SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
						FROM Syn_Deal ad
						INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
						LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
						LEFT JOIN Category C On C.Category_Code=ad.Category_Code
						
						WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
	
						INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
						SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
						INNER JOIN Title t ON t.Title_Code = tr.Title_Code
						INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					END
	
					DELETE FROM @tblRights_New
			END
	
			IF(@LeftColDbname = 'SDR.IS_SUB_LICENSE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
	
					SELECT @Value = CASE WHEN @Value = 'Y' THEN 'Yes' ELSE 'No' END
				
					EXEC ('DELETE FROM #tempRights WHERE [Sub-Licensing] '+@theOp+' ('''+@Value+''') ')
					
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
	
						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND ISNULL(adr.Actual_Right_Start_Date, ''9999-12-31'')  '+@theOp +' '+  @Value 
					)
	
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
	
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
	
				END
			END
	
			IF(@LeftColDbname = 'COU.COUNTRY_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
				
					EXEC ('DELETE FROM #tempRights WHERE
					Syn_Deal_Rights_Code
							' + @theOp + ' (SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code Is Not Null 
					AND (( 
							Country_Code IN ('+@Value+')
							AND Territory_Type=''I''
						) 
					OR 
						(
							Territory_Code IN (SELECT DISTINCT Territory_Code FROM Territory_Details WHERE 
							Country_Code  IN ('+@Value+') )  
							AND Territory_Type=''G''
						))
					)')
					
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
				INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Syn_Deal_Rights_Code 
						'+@theOp+' (SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code Is Not Null 
							AND (( 
									Country_Code IN ('+@Value+')
									AND Territory_Type=''I''
								) OR (
									Territory_Code IN (SELECT DISTINCT Territory_Code FROM Territory_Details WHERE 
									Country_Code  IN ('+@Value+') )  
									AND Territory_Type=''G''
								))
						)')

				
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblRights_New
				END
			END
	
			IF(@LeftColDbname = 'S_LANG')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code
							' + @theOp + ' (SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code Is Not Null 
						AND (( 
								Language_Code IN ('+@Value+')
								AND Language_Type = ''L''
							) 
						OR 
							(
								Language_Group_Code IN (SELECT DISTINCT Language_Group_Code FROM Language_Group_Details WHERE 
								Language_Code  IN ('+ @Value +') )  
								AND Language_Type = ''G''
							))
						)')
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
				
					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Syn_Deal_Rights_Code 
					   ' + @theOp + ' (SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code Is Not Null 
							AND (( 
									Language_Code IN ('+@Value+')
									AND Language_Type = ''L''
								) 
							OR 
								(
									Language_Group_Code IN (SELECT DISTINCT Language_Group_Code FROM Language_Group_Details WHERE 
									Language_Code  IN ('+ @Value +') )  
									AND Language_Type = ''G''
								))
						)')
				
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblRights_New
				END
			END
	
			IF(@LeftColDbname = 'D_LANG')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
				
					EXEC ('DELETE FROM #tempRights WHERE 
					Syn_Deal_Rights_Code 
							 '+@theOp+' (SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code Is Not Null 
						AND (( 
								Language_Code IN ('+@Value+')
								AND Language_Type = ''L''
							) 
						OR 
							(
								Language_Group_Code IN (SELECT DISTINCT Language_Group_Code FROM Language_Group_Details WHERE 
								Language_Code IN ('+ @Value +') )  
								AND Language_Type = ''G''
							))
						)')
					
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				
				END
				ELSE
				BEGIN
					
					DELETE FROM @tblRights_New
				
					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Syn_Deal_Rights_Code
					   '+@theOp+' (SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code Is Not Null 
							AND (( 
									Language_Code IN ('+@Value+')
									AND Language_Type = ''L''
								) 
							OR 
								(
									Language_Group_Code IN (SELECT DISTINCT  Language_Group_Code FROM Language_Group_Details WHERE 
									Language_Code IN ('+ @Value +') )  
									AND Language_Type = ''G''
								))
							)')
				
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
				
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblRights_New
				END
			END
	
			IF(@LeftColDbname = 'P.PLATFORM_CODE')
			BEGIN
	
				INSERT INTO #tbl_Platform_RightCodes(Syn_Deal_Code, Syn_Deal_Rights_Code)
				EXEC ('SELECT DISTINCT ADR.Syn_Deal_Code, P.Syn_Deal_Rights_Code 
				FROM Syn_Deal ad
				INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
				INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
				INNER JOIN Syn_Deal_Rights_Platform P ON P.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
				WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND
				PLATFORM_CODE IN ('+@Value+')')
	
				--INSERT INTO #tbl_Platform_RightCodes(Syn_Deal_Code, Syn_Deal_Rights_Code)
				--EXEC ('SELECT DISTINCT ADR.Syn_Deal_Code, P.Syn_Deal_Rights_Code 
				--FROM Syn_Deal ad
				--INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
				--INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
				--INNER JOIN Syn_Deal_Rights_Ancillary P ON P.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code AND P.Platform_Code IS NOT NULL
				--WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND
				--PLATFORM_CODE IN ('+@Value+')')
			
				IF(@logicalConnect = 'AND')
				BEGIN
			
					EXEC('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code '+@theOp+' ( SELECT Syn_Deal_Rights_Code FROM #tbl_Platform_RightCodes )')
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
				
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
			
				END
				ELSE 
				BEGIN
					DELETE FROM @tblRights_New
			
					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Syn_Deal_Rights_Code  '+@theOp+' ( SELECT Syn_Deal_Rights_Code FROM #tbl_Platform_RightCodes )
					')
			
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
				
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
			
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
			
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblRights_New
				END
			END
			IF(@LeftColDbname = 'SDR.Milestone_Type_Code')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
	
					SELECT @Value = CASE WHEN @Value = 'Y' THEN 'Yes' ELSE 'No' END
				
					EXEC ('DELETE FROM #tempRights WHERE Milestone_Type_Code '+@theOp+' ('''+@Value+''') ')
					
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_deal)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
						,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND [Sub-Licensing] '+@theOp+' ('''+@Value+''')'
					)
	
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
					--INNER JOIN Syn_Deal_rights SDR ON SDR.Syn_Deal_Code=TRN.Syn_deal_code
					--INNER JOIN Milestone_Type M On SDR.Milestone_type_code=SDR.Milestone_type_code


					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,
					CASE WHEN ISNULL(SDR.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
	
				END
			END

			--IF(@LeftColDbname = 'SDR.Expired')
			--BEGIN
			--	IF(@logicalConnect = 'AND')
			--	BEGIN
	
			--		SELECT @Value = CASE WHEN @Value = 'Y' THEN 'Expired' ELSE 'Active' END
				
			--		EXEC ('DELETE FROM #tempRights WHERE Expired_Deal '+@theOp+' ('''+@Value+''') ')
					
			--		DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
			--		DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
			--		DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
			--	END
			--	ELSE
			--	BEGIN
			--		DELETE FROM @tblRights_New
			--		INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_deal)
			--		EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
			--		   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
			--		   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
			--		   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
			--			as Promoter_Group_Name,
			--			dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
			--			as Promoter_Remark_Desc,
			--			CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
			--			,CASE WHEN adr.Actual_Right_End_Date > getdate() then ''Active'' Else ''Expired'' END AS Expired_Deals
			--		   FROM Syn_Deal ad
			--		   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
			--		   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
			--		   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
			--		   INNER JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
			--		   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
			--		   AND [Sub-Licensing] '+@theOp+' ('''+@Value+''')'
			--		)
	
			--		DELETE trn
			--		FROM @tblRights_New trn 
			--		WHERE trn.Syn_Deal_Rights_Code IN ( 
			--			SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
			--			WHERE tr.Title_Code = trn.Title_Code
			--		)
					
			--		INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
			--		SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
			--		FROM @tblRights_New
			--		--INNER JOIN Syn_Deal_rights SDR ON SDR.Syn_Deal_Code=TRN.Syn_deal_code
			--		--INNER JOIN Milestone_Type M On SDR.Milestone_type_code=SDR.Milestone_type_code


			--		INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
			--		SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
			--		FROM Syn_Deal ad
			--		INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
			--		INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
			--		LEFT JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
			--		LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
			--		LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					
			--		WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
	
			--		INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_rating)
			--		SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production ,CBFC_rating
			--		FROM #tempRights tr
			--		INNER JOIN Title t ON t.Title_Code = tr.Title_Code
			--		LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
			--		WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
			--		INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
			--		Select DISTINCT Syn_Deal_Code, Title_Code 
			--		FROM #tempRights tr
			--		WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
			--		DELETE FROM @tblRights_New
	
			--	END
			--END

			IF(@LeftColDbname = 'SDR.IS_HOLDBACK')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
				PRINT 'ENTER IS_HOLDBACK'
					--select * from #tempRights
					EXEC ('DELETE FROM #tempRights WHERE Is_Holdback '+@theOp+' ('''+@Value+''') OR Is_Holdback IS NULL')
				
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
					DELETE FROM #tblRights_NewHoldback

					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   LEFT JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')'
					)
					
					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Self_Utilization_Group,Self_Utilization_Remark,Is_Holdback)
					EXEC ('SELECT Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback FROM #tblRights_NewHoldback
						   WHERE Is_Holdback '+@theOp+' ('''+@Value+''')'
					)
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
	
					
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,
					CASE WHEN ISNULL(SDR.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					INNER JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					LEFT JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					--INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					--Select DISTINCT Syn_Deal_Code, Title_Code 
					--FROM #tempRights tr
					--WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
					DELETE FROM #tblRights_NewHoldback
				END
			END--HOLDBACK END

			IF(@LeftColDbname = 'SD.Deal_Workflow_Status')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
	
					SELECT @Value = CASE WHEN @Value = 'Y' THEN 'Yes' ELSE 'No' END
				
					EXEC ('DELETE FROM #tempRights WHERE Deal_Workflow_status '+@theOp+' ('''+@Value+''') ')
					
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
					DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
	
					INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback)
					EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,M.MileStone_Type_Code
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''P'',''A'')  
						as Promoter_Group_Name,
						dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Syn_Deal_Rights_Code,''R'',''A'')  
						as Promoter_Remark_Desc,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback
					   FROM Syn_Deal ad
					   INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					   INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
					   INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
					   INNER JOIN Milestone_Type M On M.Milestone_type_code=aDR.Milestone_type_code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND [Sub-Licensing] '+@theOp+' ('''+@Value+''')'
					)
	
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Syn_Deal_Rights_Code IN ( 
						SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal)
					SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal
					FROM @tblRights_New
					--INNER JOIN Syn_Deal_rights SDR ON SDR.Syn_Deal_Code=TRN.Syn_deal_code
					--INNER JOIN Milestone_Type M On SDR.Milestone_type_code=SDR.Milestone_type_code
					

					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type,Variable_Cost_Type,Restriction_Remarks,Deal_Category,ROFR)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type,SDR.Variable_Cost_Type,SD.Restriction_Remarks,C.Category_Name,SD.Is_ROFR
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					INNER JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=ad.Syn_deal_Code
					INNER JOIN Syn_Deal_Rights SD ON SD.Syn_deal_Code=ad.Syn_deal_code
					LEFT JOIN Category C On C.Category_Code=ad.Category_Code
					WHERE tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release,CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production,mec.Columns_Value_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					INNER JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
					Select DISTINCT Syn_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
	
				END
			END

		END


		/*PRINT'RUN DEFINATION CRITERIA START'
		BEGIN
			IF(@LeftColDbname = 'CHANNELNAMES')
			BEGIN
				CREATE TABLE #RunDef(Syn_Deal_Code INT, Title_Code INT)
	
				EXEC ('INSERT INTO #RunDef(Syn_Deal_Code, Title_Code)
				SELECT DISTINCT trd.Syn_Deal_Code,trd.Title_Code FROM Syn_Deal_Run_Channel adrc
				INNER JOIN Syn_Deal_Run_Title adrt ON adrt.Syn_Deal_Run_Code = adrc.Syn_Deal_Run_Code
				INNER JOIN #tempRunDef trd ON trd.Title_Code = adrt.Title_Code
				INNER JOIN Syn_Deal_Run adr ON adr.Syn_Deal_Code = trd.Syn_Deal_Code
				WHERE adrc.Channel_Code IN ('+@Value+')')
	
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempRunDef WHERE Syn_Deal_Code '+@theOp+' (Select Syn_Deal_Code FROM #RunDef) AND Title_Code '+@theOp+' (Select Title_Code FROM #RunDef)')
					
					DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRunDef) AND Title_Code NOT IN (Select Title_Code FROM #tempRunDef)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
					
					DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRunDef
	
					INSERT INTO @tblRunDef(Syn_Deal_Code, Title_Code)
					Select Distinct Syn_Deal_Code,Title_Code from #RunDef
	
					DELETE FROM @tblRunDef WHERE Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRunDef) AND Title_Code IN (Select Title_Code FROM #tempRunDef)
	
					INSERT INTO #tempRunDef(Syn_Deal_Code,Title_Code)
					Select Syn_Deal_Code,Title_Code FROM @tblRunDef
	
					INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To)
					Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To
					FROM Syn_Deal_Rights_Title adrt
					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblRunDef tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code AND tbld.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
	
					INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Sales_Agent_Code,Deal_Tag_Code, Deal_Type_Code, Customer_Type)
					SELECT AD.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Sales_Agent_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, ad.Customer_Type
					FROM Syn_Deal ad
					INNER JOIN #BUWiseSyn_Deal_Code BUAD ON BUAD.Syn_Deal_code = ad.Syn_Deal_code
					INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
					
					AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
			
	
					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed,Year_of_Release)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					DELETE FROM @tblRunDef
				END
			END
		END
		*/
	
		SET @Counter  = @Counter  + 1
	END
	
	SELECT id as SrNo, LTRIM(RTRIM(number)) as ColNames INTO #Temp_ColNames FROM DBO.fn_Split_withdelemiter(@ColNames,',') WHERE LTRIM(RTRIM(number)) <> ''
	
	DECLARE @TableColumns NVARCHAR(MAX) = '' , @OutputCols NVARCHAR(MAX) = '',@OutputColsNames NVARCHAR(MAX) = '', @UnionColumns NVARCHAR(MAX) = ''
	SELECT @Counter=1, @Cnt_TempCond = COUNT(*) FROM #Temp_ColNames
	WHILE ( @Counter <= @Cnt_TempCond)
	BEGIN
		IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@Counter AS VARCHAR)
	
		SELECT @OutputColsNames = ColNames from #Temp_ColNames where SrNo = @Counter
	
		IF(@UnionColumns <> '')
			SET @UnionColumns = @UnionColumns + ', '
		SET @UnionColumns = @UnionColumns + ''''+ CAST(@OutputColsNames AS VARCHAR)+ ''''
	
		--PRINT 'ENTER '+ @OutputCols
		BEGIN
			IF (UPPER(@OutputColsNames) =  'RIGHT START DATE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'CONVERT(VARCHAR,tr.Right_Start_Date,103) [Right Start Date]'
			END
	
			IF (UPPER(@OutputColsNames) =  'RIGHT END DATE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'CONVERT(VARCHAR,tr.Right_End_Date,103) [Right End Date]'
			END
	
			IF (UPPER(@OutputColsNames) =  'EXCLUSIVE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Exclusive [Exclusive]'
			END
	
			IF (UPPER(@OutputColsNames) =  'SUB-LICENSING')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.[Sub-Licensing] [Sub-Licensing]'
			END
	
			IF (UPPER(@OutputColsNames) =  'TERM')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Term [Term]'
	
				UPDATE #tempRights SET TERM = [dbo].[UFN_Get_Rights_Term](Right_Start_Date, Right_End_Date, Term) 
			END
	
			IF (UPPER(@OutputColsNames) =  'SUBTITLING')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Subtitling [Subtitling]'
	
				UPDATE #tempRights SET Subtitling = DBO.UFN_Get_Rights_Subtitling(Syn_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'DUBBING')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Dubbing [Dubbing]'
	
				UPDATE #tempRights SET Dubbing = DBO.UFN_Get_Rights_Dubbing(Syn_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'COUNTRY')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Country [Country]'
	
				UPDATE #tempRights SET Country = DBO.UFN_Get_Rights_Country_Query(Syn_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'TERRITORY')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Territory [Territory]'
	
				UPDATE #tempRights SET Territory = DBO.UFN_Get_Rights_Territory(Syn_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'PLATFORM')
			BEGIN 
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Platform [Platform]'
	
				DELETE FROM @tblRights_New
			
				INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code,Country, Dubbing, Subtitling, Territory , Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, [Platform], Episode_From, Episode_To, Title_Name)
				SELECT DISTINCT TR.Syn_Deal_Code,TR.Syn_Deal_Rights_Code, TR.Title_Code, TR.Country, TR.Dubbing, TR.Subtitling, TR.Territory ,TR.Right_Start_Date, TR.Right_End_Date, TR.[Sub-Licensing],TR.Exclusive,TR.Term ,P.Platform_Hiearachy, TR.Episode_From, tr.Episode_To	, tr.Title_Name			
				FROM #tempRights TR
				INNER JOIN Syn_Deal_Rights_Platform ADRP ON ADRP.Syn_Deal_Rights_Code = TR.Syn_Deal_Rights_Code
				LEFT JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code

				--select * from #tempRights
				--UNION ALL 
				--SELECT DISTINCT TR.Syn_Deal_Code,TR.Syn_Deal_Rights_Code, TR.Title_Code, TR.Country, TR.Dubbing, TR.Subtitling, TR.Territory, TR.Right_Start_Date, TR.Right_End_Date, TR.[Sub-Licensing], TR.Exclusive, TR.Term ,P.Platform_Hiearachy, TR.Episode_From, tr.Episode_To, tr.Title_Name
				--FROM #tempRights TR
				--INNER JOIN Syn_Deal_Rights_Ancillary ADRA ON ADRA.Syn_Deal_Rights_Code = TR.Syn_Deal_Rights_Code AND ADRA.Platform_Code IS NOT NULL
				--LEFT JOIN Platform P ON P.Platform_Code = ADRA.Platform_Code
	
				DELETE FROM #tempRights
			
				INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive,[Platform], Term, Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal,Title_Name)
				SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, [Platform], Term ,Episode_From ,Episode_To,MileStone_Type_Code,Self_Utilization_Group,Self_utilization_remark,Is_Holdback,Expired_Deal,Title_Name
				FROM @tblRights_New

			END
		END
	
		BEGIN
			IF (UPPER(@OutputColsNames) =  'YEAR OF RELEASE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Year_of_Release [Year of Release]'
			END
		
			IF (UPPER(@OutputColsNames) =  'DIRECTOR')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Director [Director]'
		
				UPDATE #tempTitle SET Director = DBO.UFN_Get_Title_Metadata_By_Role_Code(Title_Code, 1)
			END
		
			IF (UPPER(@OutputColsNames) =  'STAR CAST')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Star_Cast [Star Cast]'
		
				UPDATE #tempTitle SET Star_Cast = DBO.UFN_Get_Title_Metadata_By_Role_Code(Title_Code, 2)
			END
		
			IF (UPPER(@OutputColsNames) =  'GENRE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Genre [Genre]'
		
				UPDATE #tempTitle SET Genre = DBO.UFN_Get_Title_Genre(Title_Code)
			END

			IF (UPPER(@OutputColsNames) =  'CBFC Rating')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Column_Value [CBFC Rating]'
				
				UPDATE tt SET tt.Column_Value = ECV.Columns_Value
				FROM #tempTitle tt
				INNER JOIN EXTENDED_COLUMNS_VALUE ECV ON ECV.COLUMNS_VALUE_CODE = tt.CBfC_RATING
			END

			IF (UPPER(@OutputColsNames) =  'TITLE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Title_Name [Title]'

				UPDATE tt SET tt.Title = t.Title_Name
				FROM #tempTitle tt
				INNER JOIN Title t ON t.Title_COde = tt.Title_Code

				UPDATE TR SET TR.Title_Name = T.Title_Name
				FROM  #tempRights TR
				INNER JOIN Syn_Deal AD on AD.Syn_Deal_Code = TR.Syn_Deal_code
				inner join Title T on T.title_code = tr.title_Code

				UPDATE TR SET TR.Title_Name =  T.Title_Name + ' ( '+ CAST(TR.Episode_From AS VARCHAR)+' - '+ CAST(TR.Episode_To AS VARCHAR) +' )'
				FROM  #tempRights TR
				INNER JOIN Syn_Deal AD on AD.Syn_Deal_Code = TR.Syn_Deal_code
				INNER join Title T on T.title_code = tr.title_Code
				WHERE ad.Deal_Type_Code IN (11,32,22)
				--WHERE ad.Deal_Type_Code NOT IN (1,27)

			END

			IF (UPPER(@OutputColsNames) =  'Original/Dubbed')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Original_Dubbed [Original/Dubbed]'
		
			END

			IF (UPPER(@OutputColsNames) =  'ORIGINAL TITLE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Original_Title [Original Title]'
		
				UPDATE tt SET tt.Original_Title = t.Original_Title
				FROM #tempTitle tt
				INNER JOIN Title t ON t.Title_COde = tt.Title_Code
			END
		END
	
		BEGIN
			IF (UPPER(@OutputColsNames) =  'AGREEMENT NO')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Agreement_No [Agreement No]'
			END
		
			IF (UPPER(@OutputColsNames) =  'DEAL DESCRIPTION')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Description [Deal Description]'
			END
		
			IF (UPPER(@OutputColsNames) =  'AGREEMENT DATE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'CONVERT(VARCHAR(11),td.Agreement_Date,103) [Agreement Date]'
			END
		
			IF (UPPER(@OutputColsNames) =  'BUSINESS UNIT')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Business_Unit [Business Unit]'
		
				UPDATE td SET td.Business_Unit = bu.Business_Unit_Name
				from #tempDeal td
				INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
				INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
			END
		
			IF (UPPER(@OutputColsNames) =  'CURRENCY')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Currency [Currency]'
		
				UPDATE td SET td.Currency = c.Currency_Name
				from #tempDeal td
				INNER JOIN Currency c ON c.Currency_Code = td.Currency_Code
			END

			IF (UPPER(@OutputColsNames) =  'Variable Cost')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Variable_Cost_Type [Variable Cost]'
		
				UPDATE td SET td.Variable_Cost_Type= SDR.Variable_Cost_Type
				from #tempDeal td
				INNER JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=td.Syn_deal_Code

				UPDATE  td 
				SET td.Variable_Cost_Type = CASE td.Variable_Cost_Type 
				WHEN 'N' THEN 'No'  
				WHEN 'Y' THEN 'Yes'  
				ELSE NULL  
				END  
				from #tempDeal td
				INNER JOIN Syn_Deal_Revenue SDR ON SDR.Syn_deal_Code=td.Syn_deal_Code
				--INNER JOIN Currency c ON c.Currency_Code = td.Currency_Code
			END

			IF (UPPER(@OutputColsNames) =  'ROFR')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.ROFR [ROFR]'
		
				UPDATE td SET td.ROFR= SDR.IS_ROFR
				from #tempDeal td
				INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_deal_Code=td.Syn_deal_Code

				UPDATE  td 
				SET td.ROFR = CASE td.ROFR 
				WHEN 'N' THEN 'No'  
				WHEN 'Y' THEN 'Yes'  
				ELSE NULL  
				END  
				from #tempDeal td
				INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_deal_Code=td.Syn_deal_Code
				--INNER JOIN Currency c ON c.Currency_Code = td.Currency_Code
			END

			IF (UPPER(@OutputColsNames) =  'Restriction Remarks')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Restriction_Remarks [Restriction Remarks]'
		
				UPDATE td SET td.Restriction_Remarks= SDR.Restriction_Remarks
				from #tempDeal td
				INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_deal_Code=td.Syn_deal_Code
				--INNER JOIN Currency c ON c.Currency_Code = td.Currency_Code
			END

			IF (UPPER(@OutputColsNames) =  'Deal Category')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Category [Deal Category]'
			
				UPDATE td SET td.Deal_Category= C.Category_Name
				from #tempDeal td
				INNER JOIN Syn_Deal SD ON SD.Syn_deal_Code=td.Syn_deal_Code
				INNER JOIN Category C ON C.Category_Code=SD.Category_Code
				--inner join #temptitle tt on tt.title_code = tr.Title_code
				
								--
				--INNER JOIN Currency c ON c.Currency_Code = td.Currency_Code
			END

			IF (UPPER(@OutputColsNames) =  'Self Utilization Group')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Self_Utilization_Group [Self Utilization Group]'

				UPDATE TR SET TR.Self_Utilization_Group = SDRED.Promoter_Group_Name
				FROM  #tempRights TR
				LEFT JOIN Syn_Deal_Rights_Error_Details SDRED on SDRED.Syn_Deal_Rights_Code = TR.Syn_Deal_Rights_code
			END

			IF (UPPER(@OutputColsNames) =  'Self Utilization Remarks')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Self_Utilization_Remark [Self Utilization Remarks]'

				UPDATE TR SET TR.Self_Utilization_Remark= SDRED.Promoter_Remark_Desc
				FROM  #tempRights TR
				INNER JOIN Syn_Deal_Rights_Error_Details SDRED on SDRED.Syn_Deal_Rights_Code = TR.Syn_Deal_Rights_code
			END

			IF (UPPER(@OutputColsNames) =  'Holdback')
			BEGIN
		
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Is_Holdback [Holdback]'
				
				UPDATE tr SET tr.Is_Holdback = 'Yes'
				FROM #tempRights tr
				INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = Tr.Syn_Deal_Rights_Code
				WHERE (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 AND tr.Is_Holdback IS NULL

				UPDATE tr SET tr.Is_Holdback = 'No'
				FROM #tempRights tr
				INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = Tr.Syn_Deal_Rights_Code
				WHERE (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) < 0 AND tr.Is_Holdback IS NULL

				
				--INNER JOIN Syn_Deal_Rights_Error_Details SDRED on SDRED.Syn_Deal_Rights_Code = TR.Syn_Deal_Rights_code
				
				--UPDATE TR SET TR.Is_Holdback= SDRH.Holdback_Type
				--FROM  #tempRights TR
				-- CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback 
				----INNER JOIN Syn_Deal_Rights_Holdback  SDRH ON SDRH.Syn_Deal_Rights_Code=TR.Syn_Deal_Rights_Code
				--INNER JOIN Syn_Deal_Rights_Error_Details SDRED on SDRED.Syn_Deal_Rights_Code = TR.Syn_Deal_Rights_code
			END


		
			IF (UPPER(@OutputColsNames) =  'CUSTOMER TYPE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Customer_Type [Customer Type,]'
		
				UPDATE td SET td.Customer_Type = DC.Role_Name
				from #tempDeal td
				INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = td.Syn_Deal_Code
				INNER JOIN Role DC on AD.Customer_Type = DC.Role_Code

			END
		
			IF (UPPER(@OutputColsNames) =  'STATUS')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Status [Status]'
		
				UPDATE td SET td.Status = dt.Deal_Tag_Description
				from #tempDeal td
				INNER JOIN Deal_Tag dt ON dt.Deal_Tag_Code = td.Deal_Tag_Code
			END
		
			IF (UPPER(@OutputColsNames) =  'DEAL WORKFLOW STATUS')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Workflow_Status [Deal Workflow Status]'
		
				UPDATE td SET td.Deal_Workflow_Status = dws.Deal_Workflow_Status_Name
				from #tempDeal td
				INNER JOIN Deal_Workflow_Status dws ON dws.Deal_WorkflowFlag COLLATE DATABASE_DEFAULT = td.Deal_Workflow_Status COLLATE DATABASE_DEFAULT AND dws.Deal_Type = 'A' 
			END
		
			IF (UPPER(@OutputColsNames) =  'DEAL TYPE')
			BEGIN
		
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Type [Deal Type]'
		
				UPDATE td SET td.Deal_Type = dt.Deal_Type_Name
				from #tempDeal td
				INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = td.Deal_Type_Code	
			END
		
			IF (UPPER(@OutputColsNames) =  'ENTITY')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Entity [Entity]'
		
				UPDATE td SET td.Entity = e.Entity_Name
				FROM #tempDeal td
				INNER JOIN Entity e ON e.Entity_Code = td.Entity_Code
			END
		
			IF (UPPER(@OutputColsNames) =  'LICENSEE')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Licensor [Licensor]'
		
				UPDATE td SET td.Licensor = v.Vendor_Name
				FROM #tempDeal td
				INNER JOIN Vendor v ON v.Vendor_Code = td.Vendor_Code
			END

			IF (UPPER(@OutputColsNames) =  'SALES AGENT')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Sales_Agent [Sales Agent]'
		
				UPDATE td SET td.Sales_Agent = v.Vendor_Name
				FROM #tempDeal td
				INNER JOIN Vendor v ON v.Vendor_Code = td.Vendor_Code
			END
		END
	
		/*BEGIN
			IF (UPPER(@OutputColsNames) =  'CHANNEL')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'trd.Channel [Channel]'
	
				UPDATE trd SET trd.Channel =  STUFF(
					(  SELECT Distinct ', '+ c.Channel_Name
							FROM Syn_Deal_Run_Channel adrc
							INNER JOIN Syn_Deal_Run adr ON adr.Syn_Deal_Run_Code = Adrc.Syn_Deal_Run_Code
							INNER JOIN Syn_Deal_Run_Title adrt ON adrt.Syn_Deal_Run_Code = adr.Syn_Deal_Run_Code
							INNER JOIN Channel c ON c.Channel_Code = adrc.Channel_Code
							WHERE adr.Syn_Deal_Code = trd.Syn_Deal_Code AND adrt.Title_Code = trd.Title_Code
					FOR XML PATH('')), 1, 1, '')
				from #tempRunDef trd
			END
	
			IF (UPPER(@OutputColsNames) =  'RUN LIMITATION')
			BEGIN
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'trd.Run_Limitation [Run Limitation]'
	
				UPDATE trd SET trd.Run_Limitation = CASE WHEN adr.Run_Type = 'U' THEN 'Unlimited' ELSE 'Limited' END
				from #tempRunDef trd
				INNER JOIN Syn_Deal_Run adr ON adr.Syn_Deal_Code = trd.Syn_Deal_Code
				INNER JOIN Syn_Deal_Run_Title adrt ON adrt.Syn_Deal_Run_Code = adr.Syn_Deal_Run_Code AND adrt.Title_Code = trd.Title_Code
			END
		END
		*/
	
	    SET @Counter  = @Counter  + 1
	END

	EXEC ('	INSERT INTO #tempOutput( '+@OutputCols+')
			SELECT '+@UnionColumns+'
			UNION ALL
			Select Distinct '+@TableColumns+' FROM #tempTitle tt
			INNER JOIN #tempRights tr ON tr.Title_Code = tt.Title_Code
			INNER JOIN #tempDeal td ON td.Syn_Deal_Code = tr.Syn_Deal_Code
			INNER JOIN #tempRunDef trd ON trd.Syn_Deal_Code = td.Syn_Deal_Code AND trd.Title_Code = tr.Title_Code
		')


	--EXEC ('SELECT '+@OutputCols+' FROM #tempOutput')

	DECLARE @ColumnOne VARCHAR(MAX) = ''

	SELECT  @ColumnOne = number FROM DBO.FN_SPLIT_WITHDELEMITER(@ColNames,',')  WHERE id = 1

	EXEC('	SELECT TOP 1 '+@OutputCols+'  FROM #tempOutput   WHERE COL1 = '''+@ColumnOne+'''
			UNION ALL
			SELECT '+@OutputCols+' FROM #tempOutput WHERE COL1 <> '''+@ColumnOne+'''')

	IF(OBJECT_ID('tempdb..#buwiseSyn_deal_code') IS NOT NULL) DROP TABLE #buwiseSyn_deal_code
	IF(OBJECT_ID('tempdb..#Temp_Condition') IS NOT NULL) DROP TABLE #Temp_Condition
	IF(OBJECT_ID('tempdb..#TempOutput') IS NOT NULL) DROP TABLE #TempOutput
	IF(OBJECT_ID('tempdb..#tempTitle') IS NOT NULL) DROP TABLE #tempTitle
	IF(OBJECT_ID('tempdb..#tempDeal') IS NOT NULL) DROP TABLE #tempDeal
	IF(OBJECT_ID('tempdb..#tempRights') IS NOT NULL) DROP TABLE #tempRights
	IF(OBJECT_ID('tempdb..#dummyRights') IS NOT NULL) DROP TABLE #dummyRights
	IF(OBJECT_ID('tempdb..#dummyCriteria') IS NOT NULL) DROP TABLE #dummyCriteria
	IF(OBJECT_ID('tempdb..#tmpDisplay') IS NOT NULL) DROP TABLE #tmpDisplay
	IF(OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL) DROP TABLE #Platform_Search
	IF(OBJECT_ID('tempdb..#TempLang') IS NOT NULL) DROP TABLE #TempLang
	IF(OBJECT_ID('tempdb..#tempRunDef') IS NOT NULL) DROP TABLE #tempRunDef
	IF(OBJECT_ID('tempdb..#RunDef') IS NOT NULL) DROP TABLE #RunDef
	IF(OBJECT_ID('tempdb..#TempTerritory') IS NOT NULL) DROP TABLE #TempTerritory
	IF(OBJECT_ID('tempdb..#tempBusinessUnit') IS NOT NULL) DROP TABLE #tempBusinessUnit
	IF(OBJECT_ID('tempdb..#tbl_Platform_RightCodes') IS NOT NULL) DROP TABLE #tbl_Platform_RightCodes
	IF(OBJECT_ID('tempdb..#Temp_ColNames') IS NOT NULL) DROP TABLE #Temp_ColNames
	IF(OBJECT_ID('tempdb..#OriDub_Title_Code') IS NOT NULL) DROP TABLE #OriDub_Title_Code
	IF(OBJECT_ID('tempdb..#tblRights_Newholdback') IS NOT NULL) DROP TABLE #tblRights_Newholdback
	
END
---------------------------------------------------------------BAckUp--------------


				Title
				Deal Description
				Status
				Original Title
				Platform
				Licensee
				Right Start Date
				Right End Date
				Country
				Director
				Star Cast
				Holdback
				Currency
				Entity
				Agreement Date
				Year of Release
				Sub-Licensing
				Expired Deals
				Customer Type
				Milestone
				Subtitling
				Dubbing
				Original/Dubbed
				Deal Type
				Deal Workflow Status
			    Sales Agent
			    Genre
			    Deal Category
			    CBFC Rating
			    Agreement No















-----------------------------------------------------------------------------------------