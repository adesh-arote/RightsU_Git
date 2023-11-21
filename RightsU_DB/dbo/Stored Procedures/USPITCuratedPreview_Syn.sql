CREATE PROCEDURE [dbo].[USPITCuratedPreview_Syn]
@BVCode NVARCHAR(MAX),
@DealType NVARCHAR(MAX),
@IncludeExpired CHAR(1),
@UsersCode INT,
@UDT CuratedPreview_UDT READONLY
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USPITCuratedPreview_Syn]', 'Step 1', 0, 'Started Procedure', 0, ''
	/*===========================================
	Author			 : <Rahul Kembhavi>
	Contributors	 : <Rahul Kembhavi,Adesh Arote>
	Create Date		 : <14 June 2020>
	Description		 : <Intuitive: Curated Report>
	Last Updated By  : <Rahul Kembhavi>
	=============================================*/
		--DECLARE
		--@BVCode NVARCHAR(MAX) = '19',
		--@DealType NVARCHAR(MAX) ='1',
		--@IncludeExpired CHAR(1) = 'Y',
		--@UsersCode INT = 307,
		--@UDT CuratedPreview_UDT --READONLY

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
		IF(OBJECT_ID('tempdb..#tblRights_NewHoldback') IS NOT NULL) DROP TABLE #tblRights_NewHoldback
	
	
		--INSERT INTO @UDT VALUES('Title','6312,6313,17964,34344','IN','','N','1','GRP1')
		--INSERT INTO @UDT VALUES('Genre','10,14,26','IN','OR','N','2','GRP1')
		--INSERT INTO @UDT VALUES('Director','2203','IN','OR','N','3','GRP1')
		--INSERT INTO @UDT VALUES('Star Cast','2771','IN','OR','N','3','GRP1')
		--INSERT INTO @UDT VALUES('Year of Release','19','ST','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Original Title','A','ST','OR','N','4','GRP1')
	 --   INSERT INTO @UDT VALUES('Agreement No','A-2013-00045','EQ','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Deal Description','V','ST','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Licensor','13','IN','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Currency','1','NEQ','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Entity','1','EQ','AND','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Agreement Date','2013-11-14 00:00:00.000','EQ','AND','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Deal Category','1','EQ','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Right Start Date','01/05/2018 ','GT','OR','N','4','GRP1') ----Rights Start
		--INSERT INTO @UDT VALUES('Right End Date','18/09/2019','LT','OR','N','4','GRP1') ----Rights Start
		--INSERT INTO @UDT VALUES('Country','10','IN','OR','N','4','GRP1') 
		--INSERT INTO @UDT VALUES('Territory','1','IN','AND','N','4','GRP1') 
		--INSERT INTO @UDT VALUES('Sub-Licensing','Y','','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Subtitling','122','NI','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Dubbing','122','NI','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Media Platform','1) Cable-HITS','NOT IN','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Mode Of Exploitation','Free,Pay','NOT IN','OR','N','4','GRP1')
		--INSERT INTO @UDT VALUES('Status','2','IN','','N','1','GRP1')
		--INSERT INTO @UDT VALUES('Channel','1','IN','AND','N','4','GRP1') 
		--INSERT INTO @UDT VALUES('Holdback','Y','','','N','1','GRP1')
		--INSERT INTO @UDT VALUES('Milestone','2','NI','','N','1','GRP1')
	
	

		--INSERT INTO @UDT VALUES('Title','','','','Y','1','')
		--INSERT INTO @UDT VALUES('Star Cast','','','','Y','2','')
		--INSERT INTO @UDT VALUES('Director','','','','Y','3','')
		--INSERT INTO @UDT VALUES('Genre','','','','Y','4','')
		--INSERT INTO @UDT VALUES('Original Title','','','','Y','5','')
		--INSERT INTO @UDT VALUES('Year of Release','','','','Y','6','')
		--INSERT INTO @UDT VALUES('Agreement No','','','','Y','7','')
		--INSERT INTO @UDT VALUES('Agreement Date','','','','Y','8','')
		--INSERT INTO @UDT VALUES('Business Unit','','','','Y','9','')
		--INSERT INTO @UDT VALUES('Currency','','','','Y','10','')
		--INSERT INTO @UDT VALUES('Deal Category','','','','Y','11','')
		--INSERT INTO @UDT VALUES('Deal Description','','','','Y','12','')
		--INSERT INTO @UDT VALUES('Deal Type','','','','Y','13','')
		--INSERT INTO @UDT VALUES('Entity','','','','Y','14','')
		--INSERT INTO @UDT VALUES('Licensor','','','','Y','15','')
		--INSERT INTO @UDT VALUES('Platform','','','','Y','16','')
		----INSERT INTO @UDT VALUES('Country','','','','Y','17','')
		--INSERT INTO @UDT VALUES('Region','','','','Y','17','')
		--INSERT INTO @UDT VALUES('Subtitling','','','','Y','18','')
		--INSERT INTO @UDT VALUES('Dubbing','','','','Y','19','')
		--INSERT INTO @UDT VALUES('Exclusive','','','','Y','20','')
		--INSERT INTO @UDT VALUES('Right End Date','','','','Y','21','')
		--INSERT INTO @UDT VALUES('Right Start Date','','','','Y','22','')
		--INSERT INTO @UDT VALUES('Sub-Licensing','','','','Y','23','')
		--INSERT INTO @UDT VALUES('Term','','','','Y','24','')
		--INSERT INTO @UDT VALUES('Status','','','','Y','25','')
		--INSERT INTO @UDT VALUES('Deal Workflow Status','','','','Y','26','')
		--INSERT INTO @UDT VALUES('Channel','','','','Y','27','')
		--INSERT INTO @UDT VALUES('Run Limitation','','','','Y','28','')
		--INSERT INTO @UDT VALUES('Mode of Acquisition','','','','Y','29','')
		--INSERT INTO @UDT VALUES('Holdback','','','','Y','2','')


		CREATE TABLE #TempOutput
		(
			--ColumnGroup INT,
			--TitleName NVARCHAR(1000),
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
			COL31 NVARCHAR(MAX)
			--IsEmpty AS COALESCE(COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20, COL21, COL22, COL23, COL24, COL25, COL26, COL27, COL28, COL29, COL30)
		)

		CREATE TABLE #tempTitle(
			Title_Code INT,
			Title NVARCHAR(MAX),
			[Original_Title] NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			Year_of_Release VARCHAR(100),
			Director NVARCHAR(MAX),
			Star_Cast NVARCHAR(MAX),
			CBFC_Rating NVARCHAR(MAX),
			Title_Language_Code INT,
			Title_Language NVARCHAR(MAX),
			Duration_In_Min NVARCHAR(20)
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
			Deal_Tag_Code INT

		)

		CREATE TABLE #tempRights(
			Syn_Deal_Rights_Code INT,
			Syn_Deal_Code INT,
			Title_Code INT,
			Region NVARCHAR(MAX),
			--Country NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Exclusive NVARCHAR(MAX),
			--Platform NVARCHAR(MAX),
			Right_End_Date NVARCHAR(MAX),
			Right_Start_Date NVARCHAR(MAX),
			[Sub-Licensing] NVARCHAR(MAX),
			Subtitling NVARCHAR(MAX),
			Term NVARCHAR(MAX),
			Territory NVARCHAR(MAX),
			Platforms NVARCHAR(MAX),
			--Media_Platform NVARCHAR(MAX),
			--Mode_Of_Exploitation NVARCHAR(MAX),
			Milestone_Type_Code INT,
			Is_HoldBack NVARCHAR(MAX),
			Right_Expiry_Status NVARCHAR(MAX)
		)

		CREATE TABLE #tempRunDef(
			Syn_Deal_Code INT,
			Title_Code INT,
			[Channel] NVARCHAR(MAX),
			Run_Limitation VARCHAR(MAX)

		)

		CREATE TABLE #dummyCriteria(
			Syn_Deal_Rights_Code INT,
			Syn_Deal_Code INT,
			Title_Code INT
		)

		CREATE TABLE #dummyRights(
			Syn_Deal_Rights_Code INT,
			Syn_Deal_Code INT,
			Title_Code INT
		)

		DECLARE @tblRights TABLE (
			Syn_Deal_Rights_Code INT
		)

		CREATE TABLE #Platform_Search(
				Platform_Code INT
			)

		CREATE TABLE #TempLang
		(
			Syn_Deal_Rights_Code INT,
			Language_Name NVARCHAR(200)
		)

		CREATE TABLE #TempTerritory
		(
			Syn_Deal_Rights_Code INT,
			Territory_Name NVARCHAR(200)
		)

		CREATE TABLE #tempBusinessUnit(
			Business_Unit_Code INT
		)

		DECLARE @tblAttribGroupCode AS TABLE( 
			Attrib_Group_Code INT 
		)

		DECLARE @tblDealTypes AS TABLE( 
			Deal_Type_Code INT
		)

		Create TABLE #tblRights_NewHoldback(
			Syn_Deal_Rights_Code INT,
			Syn_Deal_Code INT,
			Title_Code INT,
			Region NVARCHAR(MAX),
			--Country NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Exclusive NVARCHAR(MAX),
			--Platform NVARCHAR(MAX),
			Right_End_Date DATE,
			Right_Start_Date DATE,
			[Sub-Licensing] NVARCHAR(MAX),
			Subtitling NVARCHAR(MAX),
			Term NVARCHAR(MAX),
			Territory NVARCHAR(MAX),
			Media_Platform NVARCHAR(MAX),
			Mode_Of_Exploitation NVARCHAR(MAX),
			Milestone_Type_Code INT,
			Is_HoldBack NVARCHAR(MAX)
		)

		INSERT INTO @tblDealTypes(Deal_Type_Code)
		SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@DealType, ''), ',') WHERE number <> ''
	
		INSERT INTO @tblAttribGroupCode
		Select Attrib_Group_Code from Users_Detail (NOLOCK) where Users_Code = @UsersCode AND Attrib_Type = 'BV'
	


		INSERT INTO #tempBusinessUnit(Business_Unit_Code)
		Select Distinct adt.Business_Unit_Code 
		FROM Attrib_Deal_Type adt (NOLOCK)
		INNER JOIN @tblAttribGroupCode agc ON agc.Attrib_Group_Code = adt.Attrib_Group_Code
		INNER JOIN @tblDealTypes tdt ON tdt.Deal_Type_Code = adt.Deal_Type_Code
		--WHERE Deal_Type_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@DealType, ''), ',') WHERE number <> '')

		INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
		SELECT Title_Code, Original_Title, ISNULL(Year_Of_Production,''), Title_Language_Code FROM Title t (NOLOCK)
		INNER JOIN @tblDealTypes tdt ON tdt.Deal_Type_Code = t.Deal_Type_Code
		--WHERE Deal_Type_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@DealType, ''), ',') WHERE number <> '') AND Reference_Flag IS NULL

		INSERT INTO #tempRights(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
		SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
		CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
		CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
		CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
		FROM Syn_Deal ad (NOLOCK)
		INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code --AND adr.PA_Right_Type = 'PR'
		INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
		INNER JOIN #tempTitle tt ON tt.Title_Code = adrt.Title_Code
		INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
		WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

		DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)

		INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
		SELECT Syn_Deal_Code, convert(varchar, Agreement_Date, 23), Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
		FROM Syn_Deal ad (NOLOCK)
		INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
		--WHERE Syn_Deal_Code IN (SELECT DISTINCT Syn_Deal_Code FROM #dummyRights)
	
		INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
		Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights


		--SELECT DISTINCT adr.Syn_Deal_Code,adrt.Title_Code,c.Channel_Name,Run_Type
		--FROM Syn_Deal_Run adr 
		--INNER JOIN Syn_Deal_Run_Channel adrc ON adrc.Syn_Deal_Run_Code = adrc.Syn_Deal_Run_Code
		--INNER JOIN Syn_Deal_Run_Title adrt ON adrt.Syn_Deal_Run_Code = adr.Syn_Deal_run_Code 
		--INNER JOIN Channel c ON c.Channel_Code = adrc.Channel_Code
	
		DECLARE --Conditions
		@whTitle  NVARCHAR(MAX) = ' 1=1 ',
		@whDeal	  NVARCHAR(MAX) = ' 1=1 ',
		@whRights VARCHAR(MAX) = ' 1=1 ',
		@whRunDef NVARCHAR(MAX) = ' 1=1 '


	

		--print 'a'
		--IF EXISTS(Select * from @UDT udt WHERE IsDisplay = 'N'  AND [Key] = 'Title')
		--BEGIN
		--print 'Inside'
		--	DECLARE
		--	@Title_Codes NVARCHAR(MAX) = (Select [Value] from @UDT udt WHERE IsDisplay = 'N'  AND [Key] = 'Title')

		--	INSERT INTO #dummyCriteria(Syn_Deal_Rights_Code,Syn_Deal_Code,Title_Code)
		--	SELECT Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_code,adrt.Title_Code FROM Syn_Deal_Rights_Title adrt
		--	INNER JOIN Syn_Deal_Rights adr on adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
		--	WHERE Title_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@Title_Codes, ''), ',') WHERE number <> '')
		
	
		--END
	
		DECLARE @Key NVARCHAR(MAX),@Value NVARCHAR(MAX),@Condition NVARCHAR(MAX),@Operator NVARCHAR(MAX),
		@IsDisplay NVARCHAR(MAX),@OrderBy INT,@Group NVARCHAR(MAX), @OptCond NVARCHAR(MAX) = ''
	
		DECLARE db_cursor CURSOR FOR
			Select * from @UDT udt WHERE IsDisplay = 'N'  ORDER BY [Group], [Operator]
		OPEN db_cursor
		FETCH NEXT FROM db_cursor INTO @Key,@Value,@Condition,@Operator,@IsDisplay,@OrderBy,@Group
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			DECLARE @tblTitle TABLE(Title_Code INT, Original_Title NVARCHAR(MAX), Year_of_Release INT, Title_Language_Code INT)

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
			Deal_Tag_Code INT
		)

		DECLARE @tblRights_New TABLE(
			Syn_Deal_Rights_Code INT,
			Syn_Deal_Code INT,
			Title_Code INT,
			Region NVARCHAR(MAX),
			--Country NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Exclusive NVARCHAR(MAX),
			--Platform NVARCHAR(MAX),
			Right_End_Date DATE,
			Right_Start_Date DATE,
			[Sub-Licensing] NVARCHAR(MAX),
			Subtitling NVARCHAR(MAX),
			Term NVARCHAR(MAX),
			Territory NVARCHAR(MAX),
			Media_Platform NVARCHAR(MAX),
			Mode_Of_Exploitation NVARCHAR(MAX),
			Milestone_Type_Code INT,
			Is_HoldBack NVARCHAR(MAX)
		)


		DECLARE @tblRunDef TABLE(
			Syn_Deal_Code INT,
			Title_Code INT,
			[Channel] NVARCHAR(MAX),
			Run_Limitation VARCHAR(MAX)

		)

			/*-----Conditions Short Form-----
			IN - IN
			NI = Not IN
			EQ = Equals
			NEQ = Not Equals
			GT = Greater Than
			LT = Less Than
			BT = Between
			ST = Starts with
			CT = Contains
			Y = Yes
			N = No
			*/
		
			DELETE FROM @tblRights

			SET @OptCond = @Condition

			 IF(@Condition = 'EQ' AND (@Key = 'Right Start Date' OR @Key = 'Right End Date' --OR @Key = 'Deal Description' OR @Key = 'Deal Description' 
			 OR @Key = 'Original Title' OR @Key = 'Year of Release' OR @Key = 'Agreement Date'))
				SET @Condition = ' = '
			--ELSE IF(@Condition = 'NEQ')
			--	SET @Condition = ' <> '
			IF(@Condition = 'GT')
				SET @Condition = ' > '
			ELSE IF(@Condition = 'LT')
				SET @Condition = ' < '
			ELSE IF(@Condition = 'BT')
				SET @Condition = 'BETWEEN'

			IF(@Operator = 'AND' OR @OrderBy = '1')
			BEGIN
				IF(@Condition = 'IN' OR @Condition = 'EQ')
					SET @Condition = ' NOT IN '
				ELSE IF(@Condition = 'NI' OR @Condition = 'NEQ')
					SET @Condition = ' IN '
			END
			ELSE
			BEGIN
				IF(@Condition = 'IN' OR @Condition = 'EQ')
					SET @Condition = ' IN '
				ELSE IF(@Condition = 'NI' OR @Condition = 'NEQ')
					SET @Condition = ' NOT IN '
			END

			IF(@OrderBy = '1')
				SET @Operator = 'AND'
		

			BEGIN---------------Title Related Criteria Start--------------
		
				IF(@Key = 'Title')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN

						-- If user select IN from UI apply NOT IN and vice versa
						EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' ('+@Value+')')
					
						DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
					
						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblTitle
					
						INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
						EXEC ('Select Distinct t.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
							   FROM Title t  (NOLOCK)
							   WHERE t.Title_Code '+@Condition+' ('+@Value+')
							   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
						Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad  (NOLOCK)
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
						AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)

					
						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
						--TRUNCATE TABLE #tempRunDef
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblTitle

					END
				
					--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ('+@Value+') '
				
				END

				IF(@Key = 'Title Language')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN

						-- If user select IN from UI apply NOT IN and vice versa
						EXEC ('DELETE FROM #tempTitle WHERE Title_Language_Code '+@Condition+' ('+@Value+')')
					
						DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
					
						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblTitle
					
						INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
						EXEC ('Select Distinct t.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code
							   FROM Title t   (NOLOCK)
							   WHERE t.Title_Code '+@Condition+' ('+@Value+')
							   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
						Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH  (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						FROM Syn_Deal ad  (NOLOCK)
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
						AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)

					
						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
						--TRUNCATE TABLE #tempRunDef
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblTitle

					END
				
					--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ('+@Value+') '
				
				END

				IF(@Key = 'Genre')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' (SELECT Title_Code FROM Title_Geners (NOLOCK) WHERE Genres_Code IN ('+@Value+'))')

						DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)

						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE IF(@Operator = 'OR')
					BEGIN
						DELETE FROM @tblTitle
					
						INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
						EXEC ('Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Geners tg  (NOLOCK)
							   INNER JOIN Title t (NOLOCK) ON t.Title_Code = tg.Title_Code
							   WHERE tg.Genres_Code IN ('+@Value+')
							   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
						Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad  (NOLOCK)
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
						AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)

					
						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
						--TRUNCATE TABLE #tempRunDef
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblTitle
					END
			
					--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ( SELECT Title_Code FROM Title_Geners WHERE Genres_Code IN ('+@Value+')) '
				END

				IF(@Key = 'Director')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' ( Select Title_Code FROM Title_Talent (NOLOCK) WHERE Talent_Code IN ('+@Value+'))')
				
						DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblTitle
					
						INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
						EXEC ('Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg  (NOLOCK)
							   INNER JOIN Title t (NOLOCK) ON t.Title_Code = tg.Title_Code
							   WHERE tg.Talent_Code IN ('+@Value+')
							   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
					
						Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad  (NOLOCK)
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
						AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)
					
						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
					
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblTitle
					END
				

					--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+'))'
				END
			
				IF(@Key = 'Star Cast')
				BEGIN
				
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' ( Select Title_Code FROM Title_Talent (NOLOCK) WHERE Talent_Code IN ('+@Value+'))')
				
						DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
					
						DELETE FROM @tblTitle
					
						INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
						EXEC ('Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg  (NOLOCK)
							   INNER JOIN Title t (NOLOCK) ON t.Title_Code = tg.Title_Code
							   WHERE tg.Talent_Code IN ('+@Value+')
							   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
					
						Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad  (NOLOCK)
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
						AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblTitle
					
					END

				

					--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+'))'
				END
			
				IF(@Key = 'Original Title')
				BEGIN
				
					DECLARE @txtCondition NVARCHAR(MAX),@SQLStmt NVARCHAR(MAX)
				

					SELECT @txtCondition = CASE WHEN @Condition = ' = ' THEN ' IN ('''+@Value+''') '
												WHEN @Condition = 'ST' THEN ' LIKE '''+@Value+'%'' '
												WHEN @Condition = 'CT' THEN ' LIKE ''%'+@Value+'%'' '
												END
					IF(@Operator = 'AND')
					BEGIN
						SET @SQLStmt =  'DELETE FROM #tempTitle WHERE [Original_Title] NOT {txtCondition}'

						SELECT @SQLStmt =  REPLACE(@SQLStmt, '{txtCondition}', ''+@txtCondition+'')
					
						EXEC (@SQLStmt)
					
						DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblTitle
					
						SET @SQLStmt =  'Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg  (NOLOCK)
						INNER JOIN Title t  (NOLOCK) ON t.Title_Code = tg.Title_Code
						WHERE t.Original_Title {txtCondition}
						AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL'
					
						SELECT @SQLStmt =  REPLACE(@SQLStmt, '{txtCondition}', ''+@txtCondition+'')
					
						INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
						EXEC (@SQLStmt)
					
						Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad  (NOLOCK)
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
						AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblTitle

					END

				

					--SET @whTitle = @whTitle + ' AND Original_Title '+@Condition+' ' +@Value+' '
				END

				IF(@Key = 'Year of Release')
				BEGIN
					DECLARE @YOR_Condition NVARCHAR(MAX),@SQLStmt_YOR NVARCHAR(MAX)
				

					SELECT @YOR_Condition = CASE WHEN @Condition = ' = ' THEN ' IN ('''+@Value+''') '
												WHEN @Condition = 'ST' THEN ' LIKE '''+@Value+'%'' '
												WHEN @Condition = 'CT' THEN ' LIKE ''%'+@Value+'%'' '
												END
					IF(@Operator = 'AND')
					BEGIN
						SET @SQLStmt_YOR =  'DELETE FROM #tempTitle WHERE Year_of_Release NOT {txtCondition}'
				
						SELECT @SQLStmt_YOR =  REPLACE(@SQLStmt_YOR, '{txtCondition}', ''+@YOR_Condition+'')
					
						EXEC (@SQLStmt_YOR)

						DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblTitle
					
						SET @SQLStmt =  'Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg  (NOLOCK)
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tg.Title_Code
						WHERE t.Year_Of_Production {txtCondition}
						AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL'
					
						SELECT @SQLStmt =  REPLACE(@SQLStmt, '{txtCondition}', ''+@YOR_Condition+'')
					
						INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
						EXEC (@SQLStmt)
					
						Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad  (NOLOCK)
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ad.Syn_Deal_Code IN (Select Syn_Deal_Code FROM #tempRights)
						AND ad.Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblTitle

					END

				

					--SET @whTitle = @whTitle + ' AND Year_Of_Production '+@Condition+' ' +@Value+' '
				END

			END---------------Title Related Criteria END--------------

			BEGIN---------------Deal Related Criteria Start--------------

				IF(@Key = 'Agreement No')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
						-- If user select IN from UI apply NOT IN and vice versa
						EXEC ('DELETE FROM #tempDeal WHERE Syn_Deal_Code '+@Condition+' ('+@Value+')')
					
						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (SELECT Syn_Deal_Code FROM #tempDeal)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblDeal
					
						INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							   FROM Syn_Deal ad (NOLOCK)
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE Syn_Deal_Code '+@Condition+' ('+@Value+')')
					
						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code 
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal

					END
				
					--SET @whDeal = @whDeal + ' AND Agreement_No '+@Condition+' '''+@Value+''''
				END

				IF(@Key = 'Deal Description')
				BEGIN
						
					DECLARE @DealDescription_Condition NVARCHAR(MAX),@SQLStmt_DealDesc NVARCHAR(MAX)

					SELECT @DealDescription_Condition = CASE WHEN @Condition = ' = ' THEN ' IN ('''+@Value+''') '
												WHEN @Condition = 'ST' THEN ' LIKE '''+@Value+'%'' '
												WHEN @Condition = 'CT' THEN ' LIKE ''%'+@Value+'%'' '
												END
				
					IF(@Operator = 'AND')
					BEGIN
					
						SET @SQLStmt_DealDesc =  'DELETE FROM #tempDeal WHERE Deal_Description NOT {txtCondition}'
				
						SELECT @SQLStmt_DealDesc =  REPLACE(@SQLStmt_DealDesc, '{txtCondition}', ''+@DealDescription_Condition+'')
					
						--EXEC (@SQLStmt_DealDesc)

						if(@OptCond = 'EQ')
						begin
						DELETE FROM #tempDeal WHERE Deal_Description NOT IN (SELECT Deal_Desc_Name FROM Deal_Description WHERE Deal_Desc_Code = @Value)
						end
						if(@OptCond = 'NEQ')
						begin
						DELETE FROM #tempDeal WHERE Deal_Description IN (SELECT Deal_Desc_Name FROM Deal_Description WHERE Deal_Desc_Code = @Value)
						end
					
						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (SELECT Syn_Deal_Code FROM #tempDeal)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblDeal

						SET @SQLStmt_DealDesc =  'SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							   FROM Syn_Deal ad  (NOLOCK)
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE  Deal_Description {txtCondition}'
				
						SELECT @SQLStmt_DealDesc =  REPLACE(@SQLStmt_DealDesc, '{txtCondition}', ''+@DealDescription_Condition+'')
					
						INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC (@SQLStmt_DealDesc)

						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad  (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal

					END
				
				
					--SET @whDeal = @whDeal + ' AND Deal_Description '+@Condition+' '''+@Value+''''
				END
			
				IF(@Key = 'Licensee')
				BEGIN

					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempDeal WHERE Vendor_Code '+@Condition+' ('+@Value+')')

						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN

						DELETE FROM @tblDeal

						INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							   FROM Syn_Deal ad  (NOLOCK)
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE Vendor_Code '+@Condition+' ('+@Value+')')

						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal


					END
				
					--SET @whDeal = @whDeal + ' AND Vendor_Code '+@Condition+' ('+@Value+')'
				END

				IF(@Key = 'Currency')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempDeal WHERE Currency_Code '+@Condition+' ('+@Value+') ')

						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblDeal

						INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							   FROM Syn_Deal ad  (NOLOCK)
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE Currency_Code '+@Condition+' ('+@Value+')')

						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal
					END


				
				
					--SET @whDeal = @whDeal + ' AND Currency_Code '+@Condition+' ('+@Value+') '
				END

				IF(@Key = 'Entity')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempDeal WHERE Entity_Code '+@Condition+' ('+@Value+') ')
				
						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
					
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
					
						DELETE FROM @tblDeal

						INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							   FROM Syn_Deal ad  (NOLOCK)
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE Entity_Code '+@Condition+' ('+@Value+')')

						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal

					END

				
					--SET @whDeal = @whDeal + ' AND Entity_Code '+@Condition+' ('+@Value+') '
				END

				IF(@Key = 'Agreement Date')
				BEGIN
					DECLARE @StartDate_Agr NVARCHAR(50),@EndDate_Agr NVARCHAR(50)

					IF(@Condition = 'BETWEEN')
					BEGIN
					
						DECLARE @tblDate_Agr TABLE(
							Num int IDENTITY(1,1),
							[Date] NVARCHAR(50)
						)

						INSERT INTO @tblDate_Agr(Date)
						SELECT  number from dbo.fn_Split_withdelemiter(''+@Value+'',',')

						SET @StartDate_Agr = (Select Date FROM @tblDate_Agr WHERE Num = 1)
						SET @EndDate_Agr = (Select Date FROM @tblDate_Agr WHERE Num = 2)
					END


					IF(@Operator = 'AND')
					BEGIN
					
						IF(@Condition = 'BETWEEN')
						BEGIN
							EXEC ('DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal WHERE ISNULL(Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate_Agr+''', 103) AND convert(DATE, '''+@EndDate_Agr+''', 103))')
						END
						ELSE
						BEGIN
							EXEC ('DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal WHERE ISNULL(Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103))')
						END
					
						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
					
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblDeal

						IF(@Condition = 'BETWEEN')
						BEGIN
							INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
							EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							FROM Syn_Deal ad  (NOLOCK)
							INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							WHERE ISNULL(ad.Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate_Agr+''', 103) AND convert(DATE, '''+@EndDate_Agr+''', 103)')
						END
						ELSE
						BEGIN
							INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
							EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							FROM Syn_Deal ad  (NOLOCK)
							INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							WHERE ISNULL(ad.Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103)')
						END
					

						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal
					END

					--SET @whDeal = @whDeal + ' AND Agreement_Date '+@Condition+' (CAST('''+@Value+''' AS DATE)) '
				END

				IF(@Key = 'Deal Category')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempDeal WHERE Deal_Category_Code '+@Condition+' ('+@Value+') ')
					
						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)
					
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblDeal

						INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							   FROM Syn_Deal ad  (NOLOCK)
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE Category_Code '+@Condition+' ('+@Value+')')

						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal
					END
					--SET @whDeal = @whDeal + ' AND Category_Code '+@Condition+' ('+@Value+')'
				END

				IF(@Key = 'Status')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempDeal WHERE Deal_Tag_Code '+@Condition+' ('+@Value+')')

						DELETE FROM #tempRights WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblDeal

						INSERT INTO @tblDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC ('SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
							   FROM Syn_Deal ad  (NOLOCK)
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE Deal_Tag_Code '+@Condition+' ('+@Value+')')

						Delete from @tblDeal WHERE Syn_Deal_Code IN (Select Syn_Deal_Code from #tempDeal)

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt (NOLOCK)
						INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblDeal tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN Syn_Deal ad  (NOLOCK) ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code 
						FROM @tblDeal

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblDeal
					END
				
					--SET @whDeal = @whDeal + ' AND Category_Code '+@Condition+' ('+@Value+')'
				END

			END---------------Deal Related Criteria END--------------

			BEGIN---------------RIghts Related Criteria Start--------------

				If(@Key = 'Right Start Date')
				BEGIN
					IF(@Operator = 'AND')
					BEGIN
				
						IF(@Condition = 'BETWEEN')
						BEGIN
							DECLARE @StartDate NVARCHAR(50),@EndDate NVARCHAR(50)
							DECLARE @tblDate TABLE(
								Num int IDENTITY(1,1),
								[Date] NVARCHAR(50)
							)

							INSERT INTO @tblDate(Date)
							SELECT  number from dbo.fn_Split_withdelemiter(''+@Value+'',',')

							SET @StartDate = (Select Date FROM @tblDate WHERE Num = 1)
							SET @EndDate = (Select Date FROM @tblDate WHERE Num = 2)
						
							EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code NOT IN (Select Syn_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_Start_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate+''', 103) AND convert(DATE, '''+@EndDate+''', 103))')
						END
						ELSE
						BEGIN
							EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code NOT IN (Select Syn_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_Start_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103))')
						END
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)
					
						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						IF(@Condition = 'BETWEEN')
						BEGIN
							DECLARE @StartDate_New NVARCHAR(50),@EndDate_New NVARCHAR(50)
							DECLARE @tblDate_New TABLE(
								Num int IDENTITY(1,1),
								[Date] NVARCHAR(50)
							)

							INSERT INTO @tblDate_New(Date)
							SELECT  number from dbo.fn_Split_withdelemiter(''+@Value+'',',')
						
							SET @StartDate_New = (Select Date FROM @tblDate_New WHERE Num = 1)
							SET @EndDate_New = (Select Date FROM @tblDate_New WHERE Num = 2)
						

							INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
							EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
							   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
							   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
							   FROM Syn_Deal ad (NOLOCK)
							   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
							   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
							   AND convert(DATE, adr.Actual_Right_Start_Date, 103) '+@Condition+' convert(DATE, '''+@StartDate_New+''', 103) AND convert(DATE, '''+@EndDate_New+''', 103)
							   AND ad.Deal_Type_Code IN ('+@DealType+')
							')
							--AND adr.PA_Right_Type = ''PR''
						END
						ELSE
						BEGIN
					
							INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
							EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
							   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
							   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
							   FROM Syn_Deal ad (NOLOCK)
							   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
							   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
							   AND  convert(DATE, adr.Actual_Right_Start_Date, 103) '+@Condition+' convert(DATE, '''+@Value+''', 103)
							   AND ad.Deal_Type_Code IN ('+@DealType+')
							')
							--AND adr.PA_Right_Type = ''PR''
						END

						--SELECT * FROM @tblRights_New
						--SELECT * FROM #tempRights

						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				

					END

				
					--	SET @whRights = @whRights + '  AND Actual_Right_Start_Date '+@Condition+' (CAST('''+@Value+''' AS DATE)) '
				
				END

				If(@Key = 'Right End Date')
				BEGIN
					IF(@Condition = 'BETWEEN')
					BEGIN
						DECLARE @StartDate_EN NVARCHAR(50),@EndDate_EN NVARCHAR(50)
						DECLARE @tblDate_EN TABLE(
							Num int IDENTITY(1,1),
							[Date] NVARCHAR(50)
						)

						INSERT INTO @tblDate_EN(Date)
						SELECT  number from dbo.fn_Split_withdelemiter(''+@Value+'',',')

						SET @StartDate_EN = (Select Date FROM @tblDate_EN WHERE Num = 1)
						SET @EndDate_EN = (Select Date FROM @tblDate_EN WHERE Num = 2)
					END
				
					IF(@Operator = 'AND')
					BEGIN
					
						IF(@Condition = 'BETWEEN')
						BEGIN

							EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code NOT IN (Select Syn_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_End_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate_EN+''', 103) AND convert(DATE, '''+@EndDate_EN+''', 103))')
						END
						ELSE
						BEGIN

							EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code NOT IN (Select Syn_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_End_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103))')

						END
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New

						IF(@Condition = 'BETWEEN')
						BEGIN
							INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
							EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
							   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
							   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
							   FROM Syn_Deal ad (NOLOCK)
							   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
							   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
							   AND convert(DATE, adr.Actual_Right_End_Date, 103) '+@Condition+' convert(DATE, '''+@StartDate_EN+''', 103) AND convert(DATE, '''+@EndDate_EN+''', 103)
							   AND ad.Deal_Type_Code IN ('+@DealType+')
							')
							--AND adr.PA_Right_Type = ''PR''
						END
						ELSE
						BEGIN

							INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
							EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
							   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
							   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
							   FROM Syn_Deal ad (NOLOCK)
							   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code
							   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
							   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
							   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
							   AND  convert(DATE, adr.Actual_Right_End_Date, 103) '+@Condition+' convert(DATE, '''+@Value+''', 103)
							   AND ad.Deal_Type_Code IN ('+@DealType+')
							')
							-- AND adr.PA_Right_Type = ''PR''
						END


						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					END

				
					DELETE FROM @tblRights_New
					--	SET @whRights = @whRights + '  AND Actual_Right_End_Date '+@Condition+' (CAST('''+@Value+''' AS DATE)) '
				
				END

				IF(@Key = 'Sub-Licensing')
				BEGIN
					--Pre defined
					IF(@Operator = 'AND')
					BEGIN
					
						SELECT @Value = CASE WHEN @Value = 'Y' THEN 'Yes' ELSE 'NO' END
				
						EXEC ('DELETE FROM #tempRights WHERE [Sub-Licensing] NOT IN ('''+@Value+''')' )
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New

						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Syn_Deal ad (NOLOCK)
						   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
						   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND [Is_Sub_License] IN ('''+@Value+''')
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						--AND adr.PA_Right_Type = ''PR''
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblRights_New

					END
				

					--SET @whRights = @whRights + '  AND Is_Sub_License = '''+@Value+''' '
				END

				IF(@Key = 'Milestone')
				BEGIN
					--Pre defined
					IF(@Operator = 'AND')
					BEGIN
					
						EXEC ('DELETE FROM #tempRights WHERE Milestone_Type_Code '+@Condition+' ('+@Value+') OR Milestone_Type_Code IS NULL')
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New

						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback
						   FROM Syn_Deal ad (NOLOCK)
						   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
						   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND adr.Milestone_Type_Code '+@Condition+' ('+@Value+')
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						--AND adr.PA_Right_Type = ''PR''
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblRights_New

					END
				

					--SET @whRights = @whRights + '  AND Is_Sub_License = '''+@Value+''' '
				END

				IF(@Key = 'Holdback')
				BEGIN
					SELECT @Value = CASE WHEN @Value = 'Y' THEN 'Yes' ELSE 'No' END
					--Pre defined
					IF(@Operator = 'AND')
					BEGIN
					
						EXEC ('DELETE FROM #tempRights WHERE Is_Holdback NOT IN ('''+@Value+''')' )
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New

						INSERT INTO #tblRights_NewHoldback(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback
						   FROM Syn_Deal ad (NOLOCK)
						   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
						   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')

						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
							  FROM #tblRights_NewHoldback WHERE Is_Holdback IN ('''+@Value+''')'
						)
						--AND adr.PA_Right_Type = ''PR''
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblRights_New

					END
				

					--SET @whRights = @whRights + '  AND Is_Sub_License = '''+@Value+''' '
				END

				IF(@Key = 'Country' OR @Key = 'Territory')
				BEGIN
					INSERT INTO @tblRights(Syn_Deal_Rights_Code)
					Select DISTINCT Syn_Deal_Rights_Code FROM #tempRights
				
					TRUNCATE TABLE #dummyCriteria

					DECLARE @Country TABLE (Country_Code INT)

					DECLARE @Territory TABLE (Territory_Code INT)
				
					INSERT INTO @Country
					SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@Value, ''), ',') WHERE number <> ''
				
					INSERT INTO @Territory
					Select DISTINCT td.Territory_Code 
					FROM Territory_Details td (NOLOCK)
					INNER JOIN @Country cn ON cn.Country_Code = td.Country_Code
				
					--SELECT  @Value = (	SELECT STUFF(
					--(
					INSERT INTO #dummyCriteria(Syn_Deal_Rights_Code)
					SELECT DISTINCT adrc.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights adr1 (NOLOCK)
					INNER JOIN @tblRights tr ON adr1.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
					INNER JOIN Syn_Deal_Rights_Territory adrc (NOLOCK) ON adrc.Syn_Deal_Rights_Code = adr1.Syn_Deal_Rights_Code --AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
					INNER JOIN @Country cn ON cn.Country_Code = adrc.Country_Code AND adrc.Territory_Type = 'I'
					UNION
					SELECT DISTINCT  adrc.Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights adr1 (NOLOCK)
					INNER JOIN @tblRights tr ON adr1.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
					INNER JOIN Syn_Deal_Rights_Territory adrc (NOLOCK) ON adrc.Syn_Deal_Rights_Code = adr1.Syn_Deal_Rights_Code --AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
					INNER JOIN @Territory trr ON trr.Territory_Code = adrc.Territory_Code AND adrc.Territory_Type = 'G'
				
					IF(@Operator = 'AND')
					BEGIN

						EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code '+@Condition+' (Select Syn_Deal_Rights_Code FROM #dummyCriteria)')
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights)
					
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New

						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Syn_Deal ad (NOLOCK)
						   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
						   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND adr.Syn_Deal_Rights_Code '+@Condition+' (Select Syn_Deal_Rights_Code FROM #dummyCriteria)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						--AND adr.PA_Right_Type = ''PR''
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblRights_New
					END

					DELETE FROM @tblRights

					TRUNCATE TABLE #dummyCriteria

				END

				IF(@Key = 'Subtitling')
				BEGIN
					INSERT INTO @tblRights(Syn_Deal_Rights_Code)
					Select DISTINCT Syn_Deal_Rights_Code FROM #tempRights
				
					TRUNCATE TABLE #dummyCriteria

					DECLARE @Language TABLE (Language_Code INT)

					DECLARE @Language_Group TABLE (Language_Group_Code INT)

					INSERT INTO @Language
					SELECT number from dbo.fn_Split_withdelemiter(''+@Value+'',',')

					INSERT INTO @Language_Group
					Select lgd.Language_Group_Code FROM Language_Group_Details lgd (NOLOCK)
					INNER JOIN @Language l ON l.Language_Code = lgd.Language_Code
				
					INSERT INTO #dummyCriteria(Syn_Deal_Rights_Code)
					SELECT DISTINCT  adrs.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights adr1 (NOLOCK)
					INNER JOIN @tblRights tr ON adr1.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
					INNER JOIN Syn_Deal_Rights_Subtitling adrs (NOLOCK) ON adrs.Syn_Deal_Rights_Code = adr1.Syn_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
					INNER JOIN @Language l ON l.Language_Code = adrs.Language_Code AND adrs.Language_Type = 'L'
					UNION
					SELECT DISTINCT  adrs.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights adr1 (NOLOCK)
					INNER JOIN @tblRights tr ON adr1.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
					INNER JOIN Syn_Deal_Rights_Subtitling adrs (NOLOCK) ON adrs.Syn_Deal_Rights_Code = adr1.Syn_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
					INNER JOIN @Language_Group lg ON lg.Language_Group_Code = adrs.Language_Group_Code AND adrs.Language_Type = 'G'
				
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code '+@Condition+' (Select Syn_Deal_Rights_Code FROM #dummyCriteria)')

						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights)

						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

						DELETE FROM @tblRights

					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New

						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Syn_Deal ad (NOLOCK)
						   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
						   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND adr.Syn_Deal_Rights_Code '+@Condition+' (Select Syn_Deal_Rights_Code FROM #dummyCriteria)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						--AND adr.PA_Right_Type = ''PR''
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblRights_New

					END



				
					TRUNCATE TABLE #dummyCriteria
				
					--SET @whRights = @whRights + '  AND adr.Syn_Deal_Rights_Code '+@Condition+' ('+@Value+') '
				
				END

				IF(@Key = 'Dubbing')
				BEGIN
					INSERT INTO @tblRights(Syn_Deal_Rights_Code)
					Select DISTINCT Syn_Deal_Rights_Code FROM #tempRights
				
					TRUNCATE TABLE #dummyCriteria

					DECLARE @Language_Dub TABLE (Language_Code INT)

					DECLARE @Language_Group_Dub TABLE (Language_Group_Code INT)

					INSERT INTO @Language_Dub
					SELECT number from dbo.fn_Split_withdelemiter(''+@Value+'',',')

					INSERT INTO @Language_Group_Dub
					Select lgd.Language_Group_Code FROM Language_Group_Details lgd (NOLOCK)
					INNER JOIN @Language l ON l.Language_Code = lgd.Language_Code
				
					INSERT INTO #dummyCriteria(Syn_Deal_Rights_Code)
					SELECT DISTINCT  adrs.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights adr1 (NOLOCK)
					INNER JOIN @tblRights tr ON adr1.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
					INNER JOIN Syn_Deal_Rights_Dubbing adrs (NOLOCK) ON adrs.Syn_Deal_Rights_Code = adr1.Syn_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
					INNER JOIN @Language_Dub l ON l.Language_Code = adrs.Language_Code AND adrs.Language_Type = 'L'
					UNION
					SELECT DISTINCT  adrs.Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code 
					FROM Syn_Deal_Rights adr1 (NOLOCK)
					INNER JOIN @tblRights tr ON adr1.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
					INNER JOIN Syn_Deal_Rights_Dubbing adrs (NOLOCK) ON adrs.Syn_Deal_Rights_Code = adr1.Syn_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
					INNER JOIN @Language_Group_Dub lg ON lg.Language_Group_Code = adrs.Language_Group_Code AND adrs.Language_Type = 'G'

					IF(@Operator = 'AND')
					BEGIN

						EXEC ('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code '+@Condition+' (Select Syn_Deal_Rights_Code FROM #dummyCriteria)')
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights)
					
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
					
						DELETE FROM @tblRights_New

						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Syn_Deal ad (NOLOCK)
						   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code
						   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND adr.Syn_Deal_Rights_Code '+@Condition+' (Select Syn_Deal_Rights_Code FROM #dummyCriteria)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						-- AND adr.PA_Right_Type = ''PR''
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblRights_New


					END
				

					DELETE FROM @tblRights

					TRUNCATE TABLE #dummyCriteria
							
				
					--SET @whRights = @whRights + '  AND adr.Syn_Deal_Rights_Code '+@Condition+' ('+@Value+') '
				END

				IF(@Key = 'Platform' )--OR @Key = 'Mode Of Exploitation')
				BEGIN
				--Select 'a'
					/*
					DECLARE @Media_Platform NVARCHAR(MAX),@Mode_Of_Exploitation NVARCHAR(MAX)
					SET @Media_Platform = (Select Value FROM @UDT WHERE [Key] = 'Media Platform')
					SET @Mode_Of_Exploitation = (Select Value FROM @UDT WHERE [Key] = 'Mode Of Exploitation')

					DECLARE @ParentPlatform AS TABLE 
					(
						Parent_Platform_Code INT
					)

					DECLARE @ChildPlatform AS TABLE 
					(
						Platform_Code INT
					)

					CREATE TABLE #PlatformRightsCode
					(
						Syn_Deal_Rights_Code INT
					)

					INSERT INTO @ParentPlatform(Parent_Platform_Code)
					SELECT Platform_Code FROM Platform WHERE Platform_Name COLLATE Latin1_General_CI_AI IN (
						SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@Media_Platform,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
					)
	
					INSERT INTO @ChildPlatform(Platform_Code)
					SELECT Platform_Code FROM Platform WHERE Platform_Name COLLATE Latin1_General_CI_AI IN (
						SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@Mode_Of_Exploitation,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')
					)

					IF NOT EXISTS(SELECT TOP 1 * FROM @ParentPlatform)
					BEGIN
	
						INSERT INTO @ParentPlatform(Parent_Platform_Code)
						SELECT DISTINCT Parent_Platform_Code FROM Platform WHERE IS_Last_Level = 'Y' AND ISNULL(Parent_Platform_Code, 0) > 0

					END

					IF NOT EXISTS(SELECT TOP 1 * FROM @ChildPlatform)
					BEGIN
	
						INSERT INTO @ChildPlatform(Platform_Code)
						SELECT DISTINCT Platform_Code FROM Platform WHERE IS_Last_Level = 'Y' AND ISNULL(Parent_Platform_Code, 0) > 0

					END

					INSERT INTO #Platform_Search(Platform_Code)
					SELECT DISTINCT p.Platform_Code
					FROM (
						SELECT cl.Platform_Code, pl.Parent_Platform_Code
						FROM @ParentPlatform pl
						INNER JOIN @ChildPlatform cl ON 1 = 1
					) AS tmp
					INNER JOIN Platform p ON p.Platform_Code = tmp.Platform_Code AND p.Parent_Platform_Code = tmp.Parent_Platform_Code AND IS_Last_Level = 'Y'

					DELETE FROM @ChildPlatform
					DELETE FROM @ParentPlatform

					*/
					
					CREATE TABLE #PlatformRightsCode
					(
						Syn_Deal_Rights_Code INT
					)
					DECLARE @PlatformCodes NVARCHAR(MAX)
					--SET @PlatformCodes = (Select Value FROM @UDT WHERE [Key] = 'Platform')
					--SET @Mode_Of_Exploitation = (Select Value FROM @UDT WHERE [Key] = 'Mode Of Exploitation')
				
					INSERT INTO #Platform_Search(Platform_Code)
					SELECT LTRIM(RTRIM(Number)) COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@Value,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

					INSERT INTO #PlatformRightsCode(Syn_Deal_Rights_Code)
					SELECT DISTINCT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Platform adrp  (NOLOCK)
					INNER JOIN #Platform_Search ps ON adrp.Platform_Code = ps.Platform_Code

					IF(@Operator = 'AND')
					BEGIN

						EXEC('DELETE FROM #tempRights WHERE Syn_Deal_Rights_Code '+@Condition+' (SELECT Syn_Deal_Rights_Code FROM #PlatformRightsCode)')
					
						DELETE FROM #tempDeal WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempRights)
					
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
					
						DELETE FROM #tempRunDef WHERE Syn_Deal_Code NOT IN (Select Syn_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New

						INSERT INTO @tblRights_New(Syn_Deal_Code, Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Syn_Deal_Code, adr.Syn_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH (NOLOCK) WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Syn_Deal ad (NOLOCK)
						   INNER JOIN Syn_Deal_Rights adr (NOLOCK) ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
						   INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND adr.Syn_Deal_Rights_Code '+@Condition+' (SELECT Syn_Deal_Rights_Code FROM #PlatformRightsCode)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						--AND adr.PA_Right_Type = ''PR''
						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Syn_Deal_Rights_Code IN ( 
							SELECT tr.Syn_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
					
						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						SELECT Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						FROM @tblRights_New

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad (NOLOCK)
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t (NOLOCK) ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						INSERT INTO #tempRunDef(Syn_Deal_Code, Title_Code)
						Select DISTINCT Syn_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Syn_Deal_Code NOT IN (Select trd.Syn_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

						DELETE FROM @tblRights_New

					END
				
					DROP TABLE #PlatformRightsCode
				

				END

			
			END---------------Rights Related Criteria Start--------------
			/*
			BEGIN --- Run Def Start
			
				IF(@Key = 'Channel')
				BEGIN
					CREATE TABLE #RunDef(Syn_Deal_Code INT, Title_Code INT)
				

					EXEC ('INSERT INTO #RunDef(Syn_Deal_Code,Title_Code)
					SELECT DISTINCT trd.Syn_Deal_Code,trd.Title_Code FROM Syn_Deal_Run_Channel adrc
					INNER JOIN Syn_Deal_Run_Title adrt ON adrt.Syn_Deal_Run_Code = adrc.Syn_Deal_Run_Code
					INNER JOIN #tempRunDef trd ON trd.Title_Code = adrt.Title_Code
					INNER JOIN Syn_Deal_Run adr ON adr.Syn_Deal_Code = trd.Syn_Deal_Code
					WHERE adrc.Channel_Code IN ('''+@Value+''')')

					--Run def
					--rights AND Condition
					-- title
					--deal
					IF(@Operator = 'AND')
					BEGIN
						EXEC ('DELETE FROM #tempRunDef WHERE Syn_Deal_Code '+@Condition+' (Select Syn_Deal_Code FROM #RunDef) AND Title_Code '+@Condition+' (Select Title_Code FROM #RunDef)')
					
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

						INSERT INTO #tempRights(Syn_Deal_Rights_Code, Syn_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						Select Distinct adrt.Syn_Deal_Rights_Code,adr.Syn_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
						CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
						CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
						CASE WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback ADRH WHERE ADRH.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
						FROM Syn_Deal_Rights_Title adrt
						INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
						INNER Join @tblRunDef tblD ON tblD.Syn_Deal_Code = adr.Syn_Deal_Code AND tbld.Title_Code = adrt.Title_Code
						INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

						INSERT INTO #tempDeal(Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						SELECT DISTINCT ad.Syn_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Syn_Deal ad
						INNER JOIN #tempRights tr ON tr.Syn_Deal_Code = ad.Syn_Deal_Code
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						AND tr.Syn_Deal_Code NOT IN (Select Syn_Deal_Code FROM #tempDeal)

						INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
						SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						FROM #tempRights tr
						INNER JOIN Title t ON t.Title_Code = tr.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

						DELETE FROM @tblRunDef
					END

				END
			END
			*/

		FETCH NEXT FROM db_cursor INTO  @Key,@Value,@Condition,@Operator,@IsDisplay,@OrderBy,@Group
		END
		CLOSE db_cursor
		DEALLOCATE db_cursor
	
		/*Insert Into Temp Tables for Criteria*/

		--Print @whTitle
		--EXEC ('INSERT INTO #tempTitle(Title_Code) SELECT Title_Code FROM Title WHERE' +@whTitle)

		--PRINT @whDeal
		--EXEC ('INSERT INTO #tempDeal(Syn_Deal_Code) SELECT Syn_Deal_Code FROM Syn_Deal WHERE' +@whDeal)

		--PRINT @whRights
		--Select @whRights

		--EXEC ('INSERT INTO #tempRights(Syn_Deal_Rights_Code,Syn_Deal_Code,Title_Code) 
		--SELECT adr.Syn_Deal_Rights_Code,Syn_Deal_Code,adrt.Title_Code FROM Syn_Deal_Rights adr
		--INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
		--WHERE '+ @whRights)
	
		--select * FROM #tempTitle
		--Select * FROM #tempDeal
		--Select * FROM #tempRights

		CREATE TABLE #tmpDisplay(
			[Key] VARCHAR(1000),
			[Order] INT
		)

		INSERT INTO #tmpDisplay
		SELECT [Key], [Order] FROM @UDT WHERE IsDisplay = 'Y'

		--IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Platform')
		--BEGIN
		
		--	DECLARE @OrderPlatform INT = 0
		--	SELECT @OrderPlatform = [Order] FROM #tmpDisplay WHERE [Key] = 'Platform' --AND IsDisplay = 'Y'

		--	UPDATE #tmpDisplay SET [Order] = [Order] + 1 WHERE [Order] > @OrderPlatform

		--END

		DECLARE @GroupOrder INT = 0, @FieldOrder VARCHAR(3) = 0, @GroupDetail VARCHAR(10) = '', @ColumnGroup NVARCHAR(1000) = '', @ColumnName NVARCHAR(1000) = '', 
				@ColumnSequence NVARCHAR(1000) = '', @ColName NVARCHAR(100) = '', @TableColumns VARCHAR(1000) = '', @OutputCounter INT = 0, @OutputCols NVARCHAR(MAX) = ''

	
		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Title')
		BEGIN
			PRINT 'Title - Start'

			--SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Title'
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Title')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Title'
		
			--SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--Select 
			UPDATE tt SET tt.TiTle = t.Title_Name
			from #tempTitle tt
			INNER JOIN Title t ON t.Title_COde = tt.Title_Code


			PRINT 'Title - End'

		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'CBFC Rating')
		BEGIN
			PRINT 'CBFC Rating - Start'

			--SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Title'
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'CBFC Rating')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'CBFC_Rating'
		
			--SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--Select 
			UPDATE tt SET tt.CBFC_Rating = ecv.Columns_Value
			from #tempTitle tt
			--INNER JOIN Map_Extended_Columns mec ON mec.Record_Code = tt.Title_Code
			--INNER JOIN Extended_Columns_Value ecv ON ecv.Columns_Value_Code = mec.Columns_Value_Code
			--INNER JOIN Extended_Columns ec ON ec.Columns_Code = mec.Columns_Code AND ec.Columns_Name = 'CBFC Rating'

			INNER JOIN Map_Extended_Columns mec ON mec.Record_Code = tt.Title_Code
			INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code AND EC.Columns_Name = 'CBFC Rating'
            INNER JOIN Map_Extended_Columns_Details MACD ON MACD.Map_Extended_Columns_Code = MEC.Map_Extended_Columns_Code
            INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MACD.Columns_Value_Code

			PRINT 'CBFC Rating - End'

		END


		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Star Cast')
		BEGIN
			PRINT 'Title - Start'

			--SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Title'
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Star Cast')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Star_Cast'
		
			--SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE tt SET tt.Star_Cast = STUFF((SELECT ', '+ tl.Talent_Name
						FROM Title_Talent tt1
						INNER JOIN Talent tl ON tl.Talent_Code =tt1.Talent_Code AND Role_Code = 2
						WHERE tt1.Title_Code = tt.Title_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			from #tempTitle tt

			PRINT 'Title - End'

		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Director')
		BEGIN
			PRINT 'Title - Start'

	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Director')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Director'
		
			--SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--Select 

			UPDATE tt SET tt.Director =STUFF((SELECT ', '+ tl.Talent_Name
						FROM Title_Talent tt1
						INNER JOIN Talent tl ON tl.Talent_Code =tt1.Talent_Code AND Role_Code = 1
						WHERE tt1.Title_Code = tt.Title_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			from #tempTitle tt
		
			--Select * from #tempTitle

			PRINT 'Title - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Genre')
		BEGIN
			PRINT 'Title - Genre'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Genre')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Genre'
		
			--SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE tt SET tt.Genre =  STUFF((SELECT ', '+ g.Genres_Name
						FROM Title_Geners tg
						INNER JOIN Genres g ON g.Genres_Code = tg.Genres_Code
						WHERE tg.Title_Code = tt.Title_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			from #tempTitle tt

			--Select * from #tempTitle
			PRINT 'Title - End'

		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Original Title')
		BEGIN
			PRINT 'Title - Genre'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Original Title')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + '[Original_Title]'
		
			--SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--Select 


			UPDATE tt SET tt.Original_Title = t.Original_Title  
			from #tempTitle tt
			INNER JOIN Title t ON t.Title_Code = tt.Title_Code
		
		

			--Select * from #tempTitle


			PRINT 'Title - End'

		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Year of Release')
		BEGIN
			PRINT 'Title - Genre'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Year of Release')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Year_of_Release'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE tt SET tt.Year_of_Release = t.Year_Of_Production  
			from #tempTitle tt
			INNER JOIN Title t ON t.Title_Code = tt.Title_Code
		
			--Select * from #tempTitle
			PRINT 'Title - End'
		END
	
		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Agreement No')
		BEGIN
			PRINT 'Agreement No --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Agreement No')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Agreement_No'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--UPDATE td SET td.Agreement_No = ad.Agreement_No  
			--from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
		
			--Select * from #tempDeal
			PRINT 'Agreement No - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Agreement Date')
		BEGIN
			PRINT 'Agreement No --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Agreement Date')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Agreement_Date'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--UPDATE td SET td.Agreement_Date = CAST(ad.Agreement_Date AS DATE)
			--from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code

			UPDATE td SET td.Agreement_Date = REPLACE(CONVERT(NVARCHAR,CAST(td.Agreement_Date AS DATETIME), 106), ' ', '-')
			FROM #tempDeal td

			--Select * from #tempDeal
			PRINT 'Agreement No - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Business Unit')
		BEGIN
			PRINT 'Business Unit --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Business Unit')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Business_Unit'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE td SET td.Business_Unit = bu.Business_Unit_Name
			from #tempDeal td
			INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
		
			PRINT 'Business Unit - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Currency')
		BEGIN
			PRINT 'Currency --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Currency')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Currency'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE td SET td.Currency = c.Currency_Name
			from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			INNER JOIN Currency c ON c.Currency_Code = td.Currency_Code
		
			--Select * from #tempDeal
			PRINT 'Currency - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Deal Category')
		BEGIN
			PRINT 'Deal Category --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Deal Category')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Deal_Category'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
			--Select c.Category_Name
			UPDATE td SET td.Deal_Category = c.Category_Name
			from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			INNER JOIN Category c ON c.Category_Code = td.Deal_Category_Code
		
			--Select * from #tempDeal
			PRINT 'Deal Category - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Status')
		BEGIN
			PRINT 'Status--Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Status')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Status'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE td SET td.Status = dt.Deal_Tag_Description
			from #tempDeal td
			INNER JOIN Deal_Tag dt ON dt.Deal_Tag_Code = td.Deal_Tag_Code
			--Select * from #tempRights
			PRINT 'Entity - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Deal Workflow Status')
		BEGIN
			PRINT 'Deal Workflow Status--Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Deal Workflow Status')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Deal_Workflow_Status'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE td SET td.Deal_Workflow_Status = dws.Deal_Workflow_Status_Name
			from #tempDeal td
			INNER JOIN Deal_Workflow_Status dws ON dws.Deal_WorkflowFlag COLLATE DATABASE_DEFAULT = td.Deal_Workflow_Status COLLATE DATABASE_DEFAULT AND dws.Deal_Type = 'A' 
			--Select * from #tempRights
			PRINT 'Entity - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Deal Description')
		BEGIN
			PRINT 'Deal Description --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Deal Description')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Deal_Description'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--UPDATE td SET td.Deal_Description = ad.Deal_Description
			--from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			--Select * from #tempDeal
			PRINT 'Deal Description - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Deal Type')
		BEGIN
			PRINT 'Deal Type --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Deal Type')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Deal_Type'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE td SET td.Deal_Type = dt.Deal_Type_Name
			from #tempDeal td
			INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = ad.Deal_Type_Code
			--Select * from #tempDeal
			PRINT 'Deal Type - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Entity')
		BEGIN
			PRINT 'Entity--Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Entity')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Entity'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE td SET td.Entity = e.Entity_Name
			from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			INNER JOIN Entity e ON e.Entity_Code = td.Entity_Code
			--Select * from #tempDeal
			PRINT 'Entity - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Licensee')
		BEGIN
			PRINT 'Entity--Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Licensee')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Licensor'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE td SET td.Licensor = v.Vendor_Name
			from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			INNER JOIN Vendor v ON v.Vendor_Code = td.Vendor_Code
			--Select * from #tempRights
			PRINT 'Entity - End'
		END
	
		--IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Country')
		--BEGIN
		--	PRINT 'Country--Start'
	
		--	 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Country')
		
		--	IF(@TableColumns <> '')
		--		SET @TableColumns = @TableColumns + ', '
		--	SET @TableColumns = @TableColumns + 'Country'
		
		--	IF(@OutputCols <> '')
		--		SET @OutputCols = @OutputCols + ', '
		--	SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		--	UPDATE tr Set tr.Country =  STUFF(
		--		(  SELECT ', '+ C.Country_Name
		--				FROM Syn_Deal_Rights_Territory adrt
		--				INNER JOIN Country c ON C.Country_Code = adrt.Country_Code
		--				WHERE adrt.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code
		--		FOR XML PATH('')), 1, 1, '')
		--	FROM #tempRights tr
		
		--	PRINT 'Country - End'
		--END

		--IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Territory')
		--BEGIN
		--	PRINT 'Territory -- Start'
	
		--	 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Territory')
		
		--	IF(@TableColumns <> '')
		--		SET @TableColumns = @TableColumns + ', '
		--	SET @TableColumns = @TableColumns + 'Territory'
		
		--	IF(@OutputCols <> '')
		--		SET @OutputCols = @OutputCols + ', '
		--	SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		--	UPDATE tr Set tr.Territory = STUFF(
		--		(  SELECT ', '+ t.Territory_Name
		--				FROM Syn_Deal_Rights_Territory adrt
		--				INNER JOIN Territory t ON t.Territory_Code = adrt.Territory_Code
		--				WHERE adrt.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code
		--		FOR XML PATH('')), 1, 1, '')
		--	FROM #tempRights tr
		--	--Select * FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code IN (Select Syn_Deal_Rights_Code FROm #tempRights)
		
		--	PRINT 'Territory - End'
		--END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Region')
		BEGIN
			PRINT 'Region--Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Region')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Region'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			TRUNCATE TABLE #TempTerritory

			INSERT INTO #TempTerritory
			SELECT DISTINCT tmd.Syn_Deal_Rights_Code, cn.Country_Name 
			FROM #TempRights tmd
			INNER JOIN Syn_Deal_Rights_Territory tt  (NOLOCK) ON tmd.Syn_Deal_Rights_Code = tt.Syn_Deal_Rights_Code AND tt.Territory_Type = 'I'
			INNER JOIN Country cn  (NOLOCK) ON tt.Country_Code = cn.Country_Code
		
			INSERT INTO #TempTerritory
			SELECT DISTINCT tmd.Syn_Deal_Rights_Code, cn.Territory_Name 
			FROM #TempRights tmd
			INNER JOIN Syn_Deal_Rights_Territory tt (NOLOCK) ON tmd.Syn_Deal_Rights_Code = tt.Syn_Deal_Rights_Code AND tt.Territory_Type = 'G'
			INNER JOIN Territory cn (NOLOCK) ON tt.Territory_Code = cn.Territory_Code
		
			UPDATE tr Set tr.Region = STUFF(( SELECT Distinct ', '+ t.Territory_Name
						FROM Syn_Deal_Rights_Territory adrt
						INNER JOIN #TempTerritory t ON t.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
						WHERE adrt.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			FROM #tempRights tr

			TRUNCATE TABLE #TempTerritory
		
			PRINT 'Region - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Subtitling')
		BEGIN
			PRINT 'Subtitling -- Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Subtitling')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Subtitling'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		
			--Select tr.Syn_Deal_Rights_Code,adrs.Language_Code,adrs.Language_Group_Code FROM #tempRights tr
			--INNER JOIN Syn_Deal_Rights_Subtitling adrs ON adrs.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code

			TRUNCATE TABLE #TempLang
		
			INSERT INTO #TempLang
			SELECT DISTINCT  tmd.Syn_Deal_Rights_Code, l.Language_Name 
			FROM #tempRights tmd
			INNER JOIN Syn_Deal_Rights_Subtitling tb (NOLOCK) ON tmd.Syn_Deal_Rights_Code= tb.Syn_Deal_Rights_Code AND tb.Language_Type = 'L'
			INNER JOIN Language l (NOLOCK) ON tb.Language_Code = l.Language_Code
		
			INSERT INTO #TempLang
			SELECT DISTINCT  tmd.Syn_Deal_Rights_Code, l.Language_Group_Name 
			FROM #tempRights tmd
			INNER JOIN Syn_Deal_Rights_Subtitling tb (NOLOCK) ON tmd.Syn_Deal_Rights_Code = tb.Syn_Deal_Rights_Code AND tb.Language_Type = 'G'
			INNER JOIN Language_Group l (NOLOCK) ON tb.Language_Group_Code = l.Language_Group_Code
		
			--MERGE #TempRights AS T
			--USING (
			--	SELECT --'Language - ' + 
			--		(STUFF ((
			--		Select ', ' + tl.Language_Name 
			--		FROM  #TempLang tl WHERE tl.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			--		ORDER BY tl.Language_Name
			--		FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
			--	) AS Subtitling, Syn_Deal_Rights_Code
			--	FROM (
			--		SELECT DISTINCT Syn_Deal_Rights_Code FROM #TempLang
			--	) a
			--) AS S ON s.Syn_Deal_Rights_Code = T.Syn_Deal_Rights_Code 
			--WHEN MATCHED THEN
			--UPDATE SET T.Subtitling = S.Subtitling;
				
			UPDATE tr Set tr.Subtitling = STUFF((SELECT Distinct ', '+ t.Language_Name
						FROM Syn_Deal_Rights_Title adrt
						INNER JOIN #TempLang t ON t.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
						WHERE adrt.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			FROM #tempRights tr

			TRUNCATE TABLE #TempLang
		
	
			PRINT 'Subtitling - End'
		END


		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Dubbing')
		BEGIN
			PRINT 'Dubbing -- Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Dubbing')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Dubbing'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		
			--Select tr.Syn_Deal_Rights_Code,adrs.Language_Code,adrs.Language_Group_Code FROM #tempRights tr
			--INNER JOIN Syn_Deal_Rights_Dubbing adrs ON adrs.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code

			TRUNCATE TABLE #TempLang
		
			INSERT INTO #TempLang
			SELECT DISTINCT tmd.Syn_Deal_Rights_Code, l.Language_Name 
			FROM #tempRights tmd
			INNER JOIN Syn_Deal_Rights_Dubbing tb (NOLOCK) ON tmd.Syn_Deal_Rights_Code= tb.Syn_Deal_Rights_Code AND tb.Language_Type = 'L'
			INNER JOIN Language l (NOLOCK) ON tb.Language_Code = l.Language_Code
		
			INSERT INTO #TempLang
			SELECT DISTINCT tmd.Syn_Deal_Rights_Code, l.Language_Group_Name 
			FROM #tempRights tmd
			INNER JOIN Syn_Deal_Rights_Dubbing tb (NOLOCK) ON tmd.Syn_Deal_Rights_Code = tb.Syn_Deal_Rights_Code AND tb.Language_Type = 'G'
			INNER JOIN Language_Group l (NOLOCK) ON tb.Language_Group_Code = l.Language_Group_Code
		
			--MERGE #TempRights AS T
			--USING (
			--	SELECT --'Language - ' + 
			--		(STUFF ((
			--		Select ', ' + tl.Language_Name 
			--		FROM  #TempLang tl WHERE tl.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			--		ORDER BY tl.Language_Name
			--		FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
			--	) AS Dubbing, Syn_Deal_Rights_Code
			--	FROM (
			--		SELECT DISTINCT Syn_Deal_Rights_Code FROM #TempLang
			--	) a
			--) AS S ON s.Syn_Deal_Rights_Code = T.Syn_Deal_Rights_Code 
			--WHEN MATCHED THEN
			--UPDATE SET T.Dubbing = S.Dubbing;
		
			UPDATE tr Set tr.Dubbing = STUFF(( SELECT Distinct ', '+ t.Language_Name
						FROM Syn_Deal_Rights_Title adrt
						INNER JOIN #TempLang t ON t.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
						WHERE adrt.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) 
			FROM #tempRights tr

			TRUNCATE TABLE #TempLang
		
	
			PRINT 'Dubbing - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Platform')
		BEGIN --------Platform start

			IF(OBJECT_ID('tempdb..#TempPlatformsHL') IS NOT NULL) DROP TABLE #TempPlatformsHL
			IF(OBJECT_ID('tempdb..#TempPlatforms') IS NOT NULL) DROP TABLE #TempPlatforms

			SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Platform')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Platforms'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)

			--IF(@OutputCols <> '')
			--	SET @OutputCols = @OutputCols + ', '
			--SET @OutputCols = @OutputCols + 'COL' + CAST((@OutputCounter + 1) AS VARCHAR)
		

			CREATE TABLE #TempPlatforms
			(
				Syn_Deal_Rights_Code INT,
				Platform_Code INT,
			)
		
			CREATE TABLE #TempPlatformsHL
			(
				Syn_Deal_Rights_Code INT,
				Platforms NVARCHAR(MAX)
				--MediaPlatforms NVARCHAR(2000),
				--ExploitationPlatforms NVARCHAR(2000),
			)
		
			IF EXISTS(SELECT TOP 1 * FROM #Platform_Search)
			BEGIN
		
				INSERT INTO #TempPlatforms
				SELECT DISTINCT tmd.Syn_Deal_Rights_Code, tp.Platform_Code 
				FROM #tempRights tmd
				INNER JOIN Syn_Deal_Rights_Platform tp (NOLOCK) ON tmd.Syn_Deal_Rights_Code = tp.Syn_Deal_Rights_Code
				INNER JOIN #Platform_Search ps ON tp.Platform_Code = ps.Platform_Code

			END
			ELSE
			BEGIN
		
				INSERT INTO #TempPlatforms
				SELECT DISTINCT tmd.Syn_Deal_Rights_Code, tp.Platform_Code 
				FROM #tempRights tmd
				INNER JOIN Syn_Deal_Rights_Platform tp (NOLOCK) ON tmd.Syn_Deal_Rights_Code = tp.Syn_Deal_Rights_Code

			END
		
			INSERT INTO #TempPlatformsHL(Syn_Deal_Rights_Code, Platforms)
			SELECT DISTINCT Syn_Deal_Rights_Code, Platform_Hierarchy FROM (
				SELECT Syn_Deal_Rights_Code, (STUFF ((
					SELECT ',' + CAST(tl.Platform_Code AS VARCHAR)
					FROM  #TempPlatforms tl WHERE a.Syn_Deal_Rights_Code = tl.Syn_Deal_Rights_Code
					FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 1, '')
				) AS PlatformCodes
				FROM (
					SELECT DISTINCT Syn_Deal_Rights_Code FROM #TempPlatforms
				) AS a
			) AS b
			CROSS APPLY DBO.[UFN_Get_Platform_Hierarchy_WithNo](b.PlatformCodes)

		
			UPDATE tr SET tr.Platforms = tmpPl.Platforms
			FROM #TempPlatformsHL tmpPl
			INNER JOIN #tempRights tr ON tmpPl.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code

			IF(OBJECT_ID('tempdb..#TempPlatformsHL') IS NOT NULL) DROP TABLE #TempPlatformsHL
			IF(OBJECT_ID('tempdb..#TempPlatforms') IS NOT NULL) DROP TABLE #TempPlatforms

		END
	
		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Exclusive')
		BEGIN
			PRINT 'Exclusive --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Exclusive')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Exclusive'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--UPDATE td SET td.Deal_Description = ad.Deal_Description
			--from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			--Select * from #tempDeal
			PRINT 'Deal Description - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Right Start Date')
		BEGIN
			PRINT 'Right Start Date --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Right Start Date')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Right_Start_Date'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE tr SET tr.Right_Start_Date = REPLACE(CONVERT(NVARCHAR,CAST(tr.Right_Start_Date AS DATETIME), 106), ' ', '-')
			FROM #tempRights tr

			PRINT 'Right Start Date - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Right End Date')
		BEGIN
			PRINT 'Right End Date --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Right End Date')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Right_End_Date'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE tr SET tr.Right_End_Date = REPLACE(CONVERT(NVARCHAR,CAST(tr.Right_End_Date AS DATE), 106), ' ', '-')
			FROM #tempRights tr

			PRINT 'Right End Date - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Sub-Licensing')
		BEGIN
			PRINT 'Sub-Licensing --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Sub-Licensing')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + '[Sub-Licensing]'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--UPDATE td SET td.Deal_Description = ad.Deal_Description
			--from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			--Select * from #tempDeal
			PRINT 'Right End Date - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Holdback')
		BEGIN
			PRINT 'Holdback --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Holdback')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Is_Holdback'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--UPDATE td SET td.Deal_Description = ad.Deal_Desc
			--from #tempDeal td
			--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
			--Select * from #tempDeal
			PRINT 'Holdback - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Term')
		BEGIN
			PRINT 'Term --Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Term')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Term'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			--UPDATE td SET td.Deal_Description = ad.Deal_Description
			--from #tempDeal td
			--INNER JOIN Syn_Deal ad ON ad.Syn_Deal_Code = td.Syn_Deal_Code
			--Select * from #tempDeal
			PRINT 'Right End Date - End'
		END

		--IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Channel')
		--BEGIN
		--	PRINT 'Channel - Start'
	
		--	 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Channel')
		
		--	IF(@TableColumns <> '')
		--		SET @TableColumns = @TableColumns + ', '

		--	SET @TableColumns = @TableColumns + '[Channel]'
		
		--	----SET @OutputCounter = @OutputCounter + 1
		--	IF(@OutputCols <> '')
		--		SET @OutputCols = @OutputCols + ', '
		--	SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		--	UPDATE trd SET trd.Channel =  STUFF(
		--		(  SELECT Distinct ', '+ c.Channel_Name
		--				FROM Syn_Deal_Run_Channel adrc
		--				INNER JOIN Syn_Deal_Run adr ON adr.Syn_Deal_Run_Code = Adrc.Syn_Deal_Run_Code
		--				INNER JOIN Syn_Deal_Run_Title adrt ON adrt.Syn_Deal_Run_Code = adr.Syn_Deal_Run_Code
		--				INNER JOIN Channel c ON c.Channel_Code = adrc.Channel_Code
		--				WHERE adr.Syn_Deal_Code = trd.Syn_Deal_Code AND adrt.Title_Code = trd.Title_Code
		--		FOR XML PATH('')), 1, 1, '')
		--	from #tempRunDef trd

		--	--Select * from #tempTitle
		--	PRINT 'Title - End'

		--END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Run Limitation')
		BEGIN
			PRINT 'Run Limitation - Start'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Run Limitation')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '

			SET @TableColumns = @TableColumns + '[Run_Limitation]'
		
			----SET @OutputCounter = @OutputCounter + 1
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE trd SET trd.Run_Limitation = CASE WHEN adr.Run_Type = 'U' THEN 'Unlimited' ELSE 'Limited' END
			from #tempRunDef trd
			INNER JOIN Syn_Deal_Run adr ON adr.Syn_Deal_Code = trd.Syn_Deal_Code AND adr.Title_Code = trd.Title_Code

			--Select * from #tempTitle
			PRINT 'Run_Limitation - End'

		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Duration')
		BEGIN
			PRINT 'Title - Duration'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Duration')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Duration_In_Min'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE tt SET tt.Duration_In_Min = t.Duration_In_Min  
			from #tempTitle tt
			INNER JOIN Title t ON t.Title_Code = tt.Title_Code
		
			--Select * from #tempTitle
			PRINT 'Title - Duration - End'
		END

		IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Rights Expiry Status')
		BEGIN
			PRINT 'Rights Expiry Status'
	
			 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Rights Expiry Status')
		
			IF(@TableColumns <> '')
				SET @TableColumns = @TableColumns + ', '
			SET @TableColumns = @TableColumns + 'Right_Expiry_Status'
		
			IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
			SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
			UPDATE tr SET tr.Right_Expiry_Status = CASE WHEN ISNULL(tr.Right_End_Date,'31DEC9999') < GETDATE() THEN 'Expired' ELSE 'Active' END
			FROM #tempRights tr
		
			--Select * from #tempTitle
			PRINT 'Rights Expiry Status'
		END

		--IF NOT EXISTS (Select top 1 * from #tempRights )
		--BEGIN
		--	PRINT 'Inside IF Not Exists'
		--	INSERT INTO #tempRights(Syn_Deal_Code,Title_Code)
		--	Select Distinct adr.Syn_Deal_Code,tt.Title_Code from #tempTitle tt
		--	INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Title_Code = tt.Title_Code
		--	INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code

		--END

		--SELECT * FROM #tempTitle tt
		--INNER JOIN #tempRights tr ON tr.Title_Code = tt.Title_Code
		--INNER JOIN #tempDeal td ON td.Syn_Deal_Code = tr.Syn_Deal_Code

		EXEC ('INSERT INTO #tempOutput( '+@OutputCols+')
			   Select Distinct '+@TableColumns+' FROM #tempTitle tt
			   INNER JOIN #tempRights tr ON tr.Title_Code = tt.Title_Code
			   INNER JOIN #tempDeal td ON td.Syn_Deal_Code = tr.Syn_Deal_Code
			   INNER JOIN #tempRunDef trd ON trd.Syn_Deal_Code = td.Syn_Deal_Code AND trd.Title_Code = tr.Title_Code
			 ')

		Select * from #TempOutput
	

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
		IF(OBJECT_ID('tempdb..#TempTerritory') IS NOT NULL) DROP TABLE #TempTerritory
		IF(OBJECT_ID('tempdb..#tempBusinessUnit') IS NOT NULL) DROP TABLE #tempBusinessUnit
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPITCuratedPreview_Syn]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
