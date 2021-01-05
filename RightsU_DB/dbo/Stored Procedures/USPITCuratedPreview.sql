CREATE PROCEDURE USPITCuratedPreview
@BVCode NVARCHAR(MAX),
@DealType NVARCHAR(MAX),
@IncludeExpired CHAR(1),
@UsersCode INT,
@UDT CuratedPreview_UDT READONLY
AS
BEGIN
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
	--INSERT INTO @UDT VALUES('Mode of Acquisition','25','IN','AND','N','1','GRP1') 
	--INSERT INTO @UDT VALUES('Holdback','Y','','','N','1','GRP1')

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
	

	/*
	The output of the stored procedure is dynamic i.e. we don’t know the number of Columns, 
	so the idea is to create a temp table with maximum number of columns , we created a table with 30 Columns and Column names are named as Col1,Col2,………,Col30 
	with DataType as Nvarchar(max) for each column.
	*/
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
		COL31 NVARCHAR(MAX),
		COL32 NVARCHAR(MAX),
		COL33 NVARCHAR(MAX),
		COL34 NVARCHAR(MAX),
		COL35 NVARCHAR(MAX),
		COL36 NVARCHAR(MAX),
		COL37 NVARCHAR(MAX)
		--IsEmpty AS COALESCE(COL1, COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20, COL21, COL22, COL23, COL24, COL25, COL26, COL27, COL28, COL29, COL30)
	)


	/*Buckets were made on the basis of Title, Deal, Rights, Run Definition.
	The temp tables how we bucketed the Criteria. With all the Conditions and the Type of that criteria.*/

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
		Title_Language NVARCHAR(MAX)
	)

	CREATE TABLE #tempDeal(
		Acq_Deal_Code INT,
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
		Role_Code INT,
		ModeOfAcquisition NVARCHAR(MAX)

	)

	CREATE TABLE #tempRights(
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
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
		Media_Platform NVARCHAR(MAX),
		Mode_Of_Exploitation NVARCHAR(MAX),
		Milestone_Type_Code INT,
		Is_HoldBack NVARCHAR(MAX)
	)

	CREATE TABLE #tempRunDef(
		Acq_Deal_Code INT,
		Title_Code INT,
		[Channel] NVARCHAR(MAX),
		Run_Limitation VARCHAR(MAX)

	)

	CREATE TABLE #dummyCriteria(
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
		Title_Code INT
	)

	CREATE TABLE #dummyRights(
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
		Title_Code INT
	)

	DECLARE @tblRights TABLE (
		Acq_Deal_Rights_Code INT
	)

	CREATE TABLE #Platform_Search(
			Platform_Code INT
		)

	CREATE TABLE #TempLang
	(
		Acq_Deal_Rights_Code INT,
		Language_Name NVARCHAR(200)
	)

	CREATE TABLE #TempTerritory
	(
		Acq_Deal_Rights_Code INT,
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
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
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
	Select Attrib_Group_Code from Users_Detail where Users_Code = @UsersCode AND Attrib_Type = 'BV'
	--------------------------------------------------------------------------------------------------------------------------------------------------
	/*First of all we need to select all the Business Units according to UsersCode and and Business vertical assigned to the User. 
	Below is the steps shown we have inserted the Business Units in a temptable i.e. #tempBusinessUnit.*/

	INSERT INTO #tempBusinessUnit(Business_Unit_Code)
	Select Distinct adt.Business_Unit_Code 
	FROM Attrib_Deal_Type adt
	INNER JOIN @tblAttribGroupCode agc ON agc.Attrib_Group_Code = adt.Attrib_Group_Code
	INNER JOIN @tblDealTypes tdt ON tdt.Deal_Type_Code = adt.Deal_Type_Code
	--WHERE Deal_Type_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@DealType, ''), ',') WHERE number <> '')
	--------------------------------------------------------------------------------------------------------------------------------------------------
	/*Insert the data in the #tempTitle according according to the DealTypes from the input parameter, the dealTypes are Inserted in
	a table variable @tblDealTypes. Here the idea is to bring all the Titles from Title table which have the Selected deal types.*/

	INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
	SELECT Title_Code, Original_Title, ISNULL(Year_Of_Production,''), Title_Language_Code FROM Title t
	INNER JOIN @tblDealTypes tdt ON tdt.Deal_Type_Code = t.Deal_Type_Code
	--WHERE Deal_Type_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@DealType, ''), ',') WHERE number <> '') AND Reference_Flag IS NULL
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	/*Insert the data in #tempRights. We will insert only those titles which have been inserted in the above #tempTitle tables. 
	Include Expired will also be check while inserting in this temp table.*/

	INSERT INTO #tempRights(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
	SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
	CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
	CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
	CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
	FROM Acq_Deal ad
	INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code --AND adr.PA_Right_Type = 'PR'
	INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
	INNER JOIN #tempTitle tt ON tt.Title_Code = adrt.Title_Code
	INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
	WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
	--------------------------------------------------------------------------------------------------------------------------------------------------
	DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)

	/*Insert the data in #tempDeal from Acq_Deal table which corresponds to the business units present in the #tempBusinessUnit temp table.*/

	INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
	SELECT Acq_Deal_Code, convert(varchar, Agreement_Date, 23) , Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
	FROM Acq_Deal ad
	INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
	--WHERE ACq_Deal_Code IN (SELECT DISTINCT Acq_Deal_Code FROM #dummyRights)
	--------------------------------------------------------------------------------------------------------------------------------------------------

	/*Insert the data in #tempRunDef from the #tempRights table with the distinct records as shown*/

	INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
	Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights

	--------------------------------------------------------------------------------------------------------------------------------------------------



	--SELECT DISTINCT adr.Acq_Deal_Code,adrt.Title_Code,c.Channel_Name,Run_Type
	--FROM Acq_Deal_Run adr 
	--INNER JOIN Acq_Deal_Run_Channel adrc ON adrc.Acq_Deal_Run_Code = adrc.Acq_Deal_Run_Code
	--INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adr.Acq_deal_run_Code 
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

	--	INSERT INTO #dummyCriteria(Acq_Deal_Rights_Code,Acq_Deal_Code,Title_Code)
	--	SELECT Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_deal_code,adrt.Title_Code FROM Acq_Deal_Rights_Title adrt
	--	INNER JOIN Acq_Deal_Rights adr on adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
	--	WHERE Title_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@Title_Codes, ''), ',') WHERE number <> '')
		
	
	--END
	

	/*
	We have used a cursor to iterate through all the records that are present in the UDT.
	Inside If condition is used, this if condition is compared with Key from the UDT.
	We will only take those number of records from UDT to process in cursor whose IsDisplay = ‘N’ i.e. these records are considered for the Criteria.
	So the number of If conditions inside the cursor will be always equal to the no of records in UDT with IsDisplay = ‘N’.
	*/

	DECLARE @Key NVARCHAR(MAX),@Value NVARCHAR(MAX),@Condition NVARCHAR(MAX),@Operator NVARCHAR(MAX),
	@IsDisplay NVARCHAR(MAX),@OrderBy INT,@Group NVARCHAR(MAX)
	
	DECLARE db_cursor CURSOR FOR
		Select * from @UDT udt WHERE IsDisplay = 'N'  ORDER BY [Group], [Operator]
	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @Key,@Value,@Condition,@Operator,@IsDisplay,@OrderBy,@Group
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DECLARE @tblTitle TABLE(Title_Code INT, Original_Title NVARCHAR(MAX), Year_of_Release INT,Title_Language_Code INT)

	DECLARE @tblDeal TABLE (
		Acq_Deal_Code INT,
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
		Role_Code INT
	)

	DECLARE @tblRights_New TABLE(
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
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
		Acq_Deal_Code INT,
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

		 IF(@Condition = 'EQ' AND (@Key = 'Right Start Date' OR @Key = 'Right End Date' OR @Key = 'Deal Description' OR @Key = 'Deal Description' 
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
		
		/*
		Now if the Operator is AND. The approach we have used here is to narrow down the result which we have already filled inside the temp tables which are 
		#tempTitle, #tempDeal, #tempRights, #tempRunDefinition.
		We will narrow down the result by deleting the records from corresponding tempTables.
		*/

		/*
		While deleteing the records we will reverse the condition from the UDT when inside AND Block. Suppose UDT has IN as condition, 
		So will delete the record from the corresponding temptable with NOT IN condition. Below image shows the execution of the above logic.
		
		*/

		BEGIN---------------Title Related Criteria Start--------------
		/* AND Operator
		When we compare the key of the UDT, and if it is from the Title bucket then we first delete the records from the #tempTitle, 
		and the we will follow the deletion of records from the #tempRights, #tempDeal and #tempRunDefinition.
		*/

		/* OR Operator
		Now if the operator is OR. Then instead of deleting the records from temp tables , 
		we insert the records into the corresponding temp tables as required.

		We will first insert the Records in a table variable with the all the conditions and without reversing the IN or NOT IN condition.
		
		Once all the records according to the condition are inserted in table variable,
		we delete duplicate records/ title. We delete those title which are already present in the #tempTitle table.

		Now we will insert the records in #tempRights for the titles corresponding to the table variable i.e. @tblTitle.

		And then we will insert the records in #tempDeal with the Acq_deal_code present in the #tempRights. 
		But while inserting we will avoid the duplicate records by not inserting the Acq_Deal_Code which are already present inside the #tempDeal.
		*/

			IF(@Key = 'Title')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN

					-- If user select IN from UI apply NOT IN and vice versa
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' ('+@Value+')')
					
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
					
					INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
					EXEC ('Select Distinct t.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
						   FROM Title t 
						   WHERE t.Title_Code '+@Condition+' ('+@Value+')
						   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad 
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)

					
					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
					--TRUNCATE TABLE #tempRunDef
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
					
					INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
					EXEC ('Select Distinct t.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code
						   FROM Title t 
						   WHERE t.Title_Code '+@Condition+' ('+@Value+')
						   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad 
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)

					
					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
					--TRUNCATE TABLE #tempRunDef
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblTitle

				END
				
				--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ('+@Value+') '
				
			END

			IF(@Key = 'Genre')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' (SELECT Title_Code FROM Title_Geners WHERE Genres_Code IN ('+@Value+'))')

					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)

					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE IF(@Operator = 'OR')
				BEGIN
					DELETE FROM @tblTitle
					
					INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Geners tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code
						   WHERE tg.Genres_Code IN ('+@Value+')
						   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad 
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)

					
					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
					--TRUNCATE TABLE #tempRunDef
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblTitle
				END
			
				--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ( SELECT Title_Code FROM Title_Geners WHERE Genres_Code IN ('+@Value+')) '
			END

			IF(@Key = 'Director')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+'))')
				
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
					
					INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code
						   WHERE tg.Talent_Code IN ('+@Value+')
						   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
					
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad 
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
					
					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
					
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblTitle
				END
				

				--SET @whTitle = @whTitle + ' AND Title_Code '+@Condition+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+'))'
			END
			
			IF(@Key = 'Star Cast')
			BEGIN
				
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@Condition+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+'))')
				
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					DELETE FROM @tblTitle
					
					INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code
						   WHERE tg.Talent_Code IN ('+@Value+')
						   AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL')
					
					
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad 
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
					
					SET @SQLStmt =  'Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg 
					INNER JOIN Title t ON t.Title_Code = tg.Title_Code
					WHERE t.Original_Title {txtCondition}
					AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL'
					
					SELECT @SQLStmt =  REPLACE(@SQLStmt, '{txtCondition}', ''+@txtCondition+'')
					
					INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
					EXEC (@SQLStmt)
					
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad 
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
					
					SET @SQLStmt =  'Select Distinct tg.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM Title_Talent tg 
					INNER JOIN Title t ON t.Title_Code = tg.Title_Code
					WHERE t.Year_Of_Production {txtCondition}
					AND Deal_Type_Code IN ('+@DealType+') AND Reference_Flag IS NULL'
					
					SELECT @SQLStmt =  REPLACE(@SQLStmt, '{txtCondition}', ''+@YOR_Condition+'')
					
					INSERT INTO @tblTitle(Title_Code,Original_Title,Year_of_Release, Title_Language_Code)
					EXEC (@SQLStmt)
					
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad 
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Title_Code,Original_Title,Year_of_Release, Title_Language_Code FROM @tblTitle
										
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblTitle

				END

				

				--SET @whTitle = @whTitle + ' AND Year_Of_Production '+@Condition+' ' +@Value+' '
			END

		END---------------Title Related Criteria END--------------

		BEGIN---------------Deal Related Criteria Start--------------
		/*
		If the Key from the UDT is from Deal bucket , then we will first delete the records from #tempDeal and after that from the remaining temptabes. 
		*/

			IF(@Key = 'Agreement No')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN
					-- If user select IN from UI apply NOT IN and vice versa
					EXEC ('DELETE FROM #tempDeal WHERE Acq_Deal_Code '+@Condition+' ('+@Value+')')
					
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (SELECT Acq_Deal_Code FROM #tempDeal)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE Acq_Deal_Code '+@Condition+' ('+@Value+')')
					
					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code 
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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
					
					EXEC (@SQLStmt_DealDesc)
					
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (SELECT Acq_Deal_Code FROM #tempDeal)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal

					SET @SQLStmt_DealDesc =  'SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad 
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE  Deal_Desc {txtCondition}'
				
					SELECT @SQLStmt_DealDesc =  REPLACE(@SQLStmt_DealDesc, '{txtCondition}', ''+@DealDescription_Condition+'')
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC (@SQLStmt_DealDesc)

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblDeal

				END
				
				
				--SET @whDeal = @whDeal + ' AND Deal_Desc '+@Condition+' '''+@Value+''''
			END
			
			IF(@Key = 'Licensor')
			BEGIN

				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Vendor_Code '+@Condition+' ('+@Value+')')

					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN

					DELETE FROM @tblDeal

					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad 
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE Vendor_Code '+@Condition+' ('+@Value+')')

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblDeal


				END
				
				--SET @whDeal = @whDeal + ' AND Vendor_Code '+@Condition+' ('+@Value+')'
			END

			IF(@Key = 'Currency')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Currency_Code '+@Condition+' ('+@Value+') ')

					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal

					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad 
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE Currency_Code '+@Condition+' ('+@Value+')')

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblDeal
				END


				
				
				--SET @whDeal = @whDeal + ' AND Currency_Code '+@Condition+' ('+@Value+') '
			END

			IF(@Key = 'Entity')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Entity_Code '+@Condition+' ('+@Value+') ')
				
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					DELETE FROM @tblDeal

					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad 
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE Entity_Code '+@Condition+' ('+@Value+')')

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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
						EXEC ('DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal WHERE ISNULL(Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate_Agr+''', 103) AND convert(DATE, '''+@EndDate_Agr+''', 103))')
					END
					ELSE
					BEGIN
						EXEC ('DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal WHERE ISNULL(Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103))')
					END
					
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal

					IF(@Condition = 'BETWEEN')
					BEGIN
						INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
						EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						FROM Acq_Deal ad 
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ISNULL(ad.Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate_Agr+''', 103) AND convert(DATE, '''+@EndDate_Agr+''', 103)')
					END
					ELSE
					BEGIN
						INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
						EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
						FROM Acq_Deal ad 
						INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						WHERE ISNULL(ad.Agreement_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103)')
					END
					

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblDeal
				END

				--SET @whDeal = @whDeal + ' AND Agreement_Date '+@Condition+' (CAST('''+@Value+''' AS DATE)) '
			END

			IF(@Key = 'Deal Category')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Deal_Category_Code '+@Condition+' ('+@Value+') ')
					
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal

					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad 
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE Category_Code '+@Condition+' ('+@Value+')')

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblDeal
				END
				--SET @whDeal = @whDeal + ' AND Category_Code '+@Condition+' ('+@Value+')'
			END

			IF(@Key = 'Mode of Acquisition')
			BEGIN
				
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Role_Code '+@Condition+' ('+@Value+') ')
					
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal

					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad 
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE Role_Code '+@Condition+' ('+@Value+')')

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblDeal
				END
				--SET @whDeal = @whDeal + ' AND Category_Code '+@Condition+' ('+@Value+')'
			END

			IF(@Key = 'Status')
			BEGIN
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Deal_Tag_Code '+@Condition+' ('+@Value+')')

					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal

					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					EXEC ('SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
						   FROM Acq_Deal ad 
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE Deal_Tag_Code '+@Condition+' ('+@Value+')')

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code 
					FROM @tblDeal

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblDeal
				END
				
				--SET @whDeal = @whDeal + ' AND Category_Code '+@Condition+' ('+@Value+')'
			END

		END---------------Deal Related Criteria END--------------

		BEGIN---------------RIghts Related Criteria Start--------------
		/*If the Key from the UDT is from Rights bucket , then we will first delete the records from #tempRights and after that from the remaining temp tables.*/


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
						
						EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code NOT IN (Select Acq_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_Start_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate+''', 103) AND convert(DATE, '''+@EndDate+''', 103))')
					END
					ELSE
					BEGIN
						EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code NOT IN (Select Acq_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_Start_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103))')
					END
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
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
						

						INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					       CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Acq_Deal ad
						   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
						   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND convert(DATE, adr.Actual_Right_Start_Date, 103) '+@Condition+' convert(DATE, '''+@StartDate_New+''', 103) AND convert(DATE, '''+@EndDate_New+''', 103)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')

						-- INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code AND adr.PA_Right_Type = ''PR''
						
					END
					ELSE
					BEGIN
					
						INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
						   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Acq_Deal ad
						   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
						   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND  convert(DATE, adr.Actual_Right_Start_Date, 103) '+@Condition+' convert(DATE, '''+@Value+''', 103)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')

						-- INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code AND adr.PA_Right_Type = ''PR''
					END

					--SELECT * FROM @tblRights_New
					--SELECT * FROM #tempRights

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production,Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				

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

						EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code NOT IN (Select Acq_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_End_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@StartDate_EN+''', 103) AND convert(DATE, '''+@EndDate_EN+''', 103))')
					END
					ELSE
					BEGIN

						EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code NOT IN (Select Acq_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_End_Date, ''9999-12-31'') '+@Condition+' convert(DATE, '''+@Value+''', 103))')

					END
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New

					IF(@Condition = 'BETWEEN')
					BEGIN
						INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					       CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Acq_Deal ad
						   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
						   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND convert(DATE, adr.Actual_Right_End_Date, 103) '+@Condition+' convert(DATE, '''+@StartDate_EN+''', 103) AND convert(DATE, '''+@EndDate_EN+''', 103)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						--AND adr.PA_Right_Type = ''PR''
					END
					ELSE
					BEGIN

						INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
						EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					       CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
						   FROM Acq_Deal ad
						   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
						   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
						   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
						   AND  convert(DATE, adr.Actual_Right_End_Date, 103) '+@Condition+' convert(DATE, '''+@Value+''', 103)
						   AND ad.Deal_Type_Code IN ('+@DealType+')
						')
						--AND adr.PA_Right_Type = ''PR''
					END


					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND [Is_Sub_License] IN ('''+@Value+''')
					   AND ad.Deal_Type_Code IN ('+@DealType+')
					')
					--AND adr.PA_Right_Type = ''PR''
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Milestone_Type_Code '+@Condition+' ('+@Value+')
					   AND ad.Deal_Type_Code IN ('+@DealType+')
					')
					--AND adr.PA_Right_Type = ''PR''
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

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

					EXEC ('DELETE FROM #tempRights WHERE  Is_Holdback NOT IN ('''+@Value+''')' )
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New

					INSERT INTO #tblRights_NewHoldback(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND ad.Deal_Type_Code IN ('+@DealType+')
					')
					--AND adr.PA_Right_Type = ''PR''

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
						  FROM #tblRights_NewHoldback WHERE Is_Holdback IN ('''+@Value+''')'
					)

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblRights_New

				END
				
				--SET @whRights = @whRights + '  AND Is_Sub_License = '''+@Value+''' '
			END

			IF(@Key = 'Country' OR @Key = 'Territory')
			BEGIN
				INSERT INTO @tblRights(Acq_Deal_Rights_Code)
				Select DISTINCT Acq_Deal_Rights_Code FROM #tempRights
				
				TRUNCATE TABLE #dummyCriteria

				DECLARE @Country TABLE (Country_Code INT)

				DECLARE @Territory TABLE (Territory_Code INT)
				
				INSERT INTO @Country
				SELECT number from dbo.fn_Split_withdelemiter(ISNULL(@Value, ''), ',') WHERE number <> ''
				
				INSERT INTO @Territory
				Select DISTINCT td.Territory_Code 
				FROM Territory_Details td
				INNER JOIN @Country cn ON cn.Country_Code = td.Country_Code
				
				--SELECT  @Value = (	SELECT STUFF(
				--(
				INSERT INTO #dummyCriteria(Acq_Deal_Rights_Code)
				SELECT DISTINCT adrc.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code 
				FROM Acq_Deal_Rights adr1
				INNER JOIN @tblRights tr ON adr1.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
				INNER JOIN Acq_Deal_Rights_Territory adrc ON adrc.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code --AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
				INNER JOIN @Country cn ON cn.Country_Code = adrc.Country_Code AND adrc.Territory_Type = 'I'
				UNION
				SELECT DISTINCT  adrc.Acq_Deal_Rights_Code 
				FROM Acq_Deal_Rights adr1
				INNER JOIN @tblRights tr ON adr1.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
				INNER JOIN Acq_Deal_Rights_Territory adrc ON adrc.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code --AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
				INNER JOIN @Territory trr ON trr.Territory_Code = adrc.Territory_Code AND adrc.Territory_Type = 'G'
				
				IF(@Operator = 'AND')
				BEGIN

					EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code '+@Condition+' (Select Acq_Deal_Rights_Code FROM #dummyCriteria)')
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Acq_Deal_Rights_Code '+@Condition+' (Select Acq_Deal_Rights_Code FROM #dummyCriteria)
					   AND ad.Deal_Type_Code IN ('+@DealType+')
					')
					--AND adr.PA_Right_Type = ''PR''
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblRights_New
				END

				DELETE FROM @tblRights

				TRUNCATE TABLE #dummyCriteria

			END

			IF(@Key = 'Subtitling')
			BEGIN
				INSERT INTO @tblRights(Acq_Deal_Rights_Code)
				Select DISTINCT Acq_Deal_Rights_Code FROM #tempRights
				
				TRUNCATE TABLE #dummyCriteria

				DECLARE @Language TABLE (Language_Code INT)

				DECLARE @Language_Group TABLE (Language_Group_Code INT)

				INSERT INTO @Language
				SELECT number from dbo.fn_Split_withdelemiter(''+@Value+'',',')

				INSERT INTO @Language_Group
				Select lgd.Language_Group_Code FROM Language_Group_Details lgd
				INNER JOIN @Language l ON l.Language_Code = lgd.Language_Code
				
				INSERT INTO #dummyCriteria(Acq_Deal_Rights_Code)
				SELECT DISTINCT  adrs.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code 
				FROM Acq_Deal_Rights adr1
				INNER JOIN @tblRights tr ON adr1.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
				INNER JOIN Acq_Deal_Rights_Subtitling adrs ON adrs.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
				INNER JOIN @Language l ON l.Language_Code = adrs.Language_Code AND adrs.Language_Type = 'L'
				UNION
				SELECT DISTINCT  adrs.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code 
				FROM Acq_Deal_Rights adr1
				INNER JOIN @tblRights tr ON adr1.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
				INNER JOIN Acq_Deal_Rights_Subtitling adrs ON adrs.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
				INNER JOIN @Language_Group lg ON lg.Language_Group_Code = adrs.Language_Group_Code AND adrs.Language_Type = 'G'
				
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code '+@Condition+' (Select Acq_Deal_Rights_Code FROM #dummyCriteria)')

					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)

					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

					DELETE FROM @tblRights

				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Acq_Deal_Rights_Code '+@Condition+' (Select Acq_Deal_Rights_Code FROM #dummyCriteria)
					   AND ad.Deal_Type_Code IN ('+@DealType+')
					')
					--AND adr.PA_Right_Type = ''PR''
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblRights_New

				END



				
				TRUNCATE TABLE #dummyCriteria
				
				--SET @whRights = @whRights + '  AND adr.Acq_Deal_Rights_Code '+@Condition+' ('+@Value+') '
				
			END

			IF(@Key = 'Dubbing')
			BEGIN
				INSERT INTO @tblRights(Acq_Deal_Rights_Code)
				Select DISTINCT Acq_Deal_Rights_Code FROM #tempRights
				
				TRUNCATE TABLE #dummyCriteria

				DECLARE @Language_Dub TABLE (Language_Code INT)

				DECLARE @Language_Group_Dub TABLE (Language_Group_Code INT)

				INSERT INTO @Language_Dub
				SELECT number from dbo.fn_Split_withdelemiter(''+@Value+'',',')

				INSERT INTO @Language_Group_Dub
				Select lgd.Language_Group_Code FROM Language_Group_Details lgd
				INNER JOIN @Language l ON l.Language_Code = lgd.Language_Code
				
				INSERT INTO #dummyCriteria(Acq_Deal_Rights_Code)
				SELECT DISTINCT  adrs.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code 
				FROM Acq_Deal_Rights adr1
				INNER JOIN @tblRights tr ON adr1.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
				INNER JOIN Acq_Deal_Rights_Dubbing adrs ON adrs.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
				INNER JOIN @Language_Dub l ON l.Language_Code = adrs.Language_Code AND adrs.Language_Type = 'L'
				UNION
				SELECT DISTINCT  adrs.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code 
				FROM Acq_Deal_Rights adr1
				INNER JOIN @tblRights tr ON adr1.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code --AND adr1.PA_Right_Type = 'PR'
				INNER JOIN Acq_Deal_Rights_Dubbing adrs ON adrs.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
				INNER JOIN @Language_Group_Dub lg ON lg.Language_Group_Code = adrs.Language_Group_Code AND adrs.Language_Type = 'G'

				IF(@Operator = 'AND')
				BEGIN

					EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code '+@Condition+' (Select Acq_Deal_Rights_Code FROM #dummyCriteria)')
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					
					DELETE FROM @tblRights_New

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Acq_Deal_Rights_Code '+@Condition+' (Select Acq_Deal_Rights_Code FROM #dummyCriteria)
					   AND ad.Deal_Type_Code IN ('+@DealType+')
					')
					--AND adr.PA_Right_Type = ''PR''
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblRights_New


				END
				

				DELETE FROM @tblRights

				TRUNCATE TABLE #dummyCriteria
							
				
				--SET @whRights = @whRights + '  AND adr.Acq_Deal_Rights_Code '+@Condition+' ('+@Value+') '
			END

			IF(@Key = 'Media Platform' )--OR @Key = 'Mode Of Exploitation')
			BEGIN
			--Select 'a'
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
					Acq_Deal_Rights_Code INT
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
				
				INSERT INTO #PlatformRightsCode(Acq_Deal_Rights_Code)
				SELECT DISTINCT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform adrp 
				INNER JOIN #Platform_Search ps ON adrp.Platform_Code = ps.Platform_Code

				IF(@Operator = 'AND')
				BEGIN

					EXEC('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code '+@Condition+' (SELECT Acq_Deal_Rights_Code FROM #PlatformRightsCode)')
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term, adr.Milestone_Type_Code,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Yes'' ELSE ''No'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')
					   AND adr.Acq_Deal_Rights_Code '+@Condition+' (SELECT Acq_Deal_Rights_Code FROM #PlatformRightsCode)
					   AND ad.Deal_Type_Code IN ('+@DealType+')
					')
					--AND adr.PA_Right_Type = ''PR''
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback
					FROM @tblRights_New

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)

					DELETE FROM @tblRights_New

				END
				
				DROP TABLE #PlatformRightsCode
				DELETE FROM @ChildPlatform
				DELETE FROM @ParentPlatform


			END

			
		END---------------Rights Related Criteria Start--------------

		BEGIN --- Run Def Start---------------------------------

		/*If the Key from the UDT is from Run Definition bucket , then we will first delete the records from #tempRunDef and after that from the remaining temp tables.*/

			IF(@Key = 'Channel')
			BEGIN
				CREATE TABLE #RunDef(Acq_Deal_Code INT, Title_Code INT)
				

				EXEC ('INSERT INTO #RunDef(Acq_Deal_Code,Title_Code)
				SELECT DISTINCT trd.Acq_Deal_Code,trd.Title_Code FROM Acq_Deal_Run_Channel adrc
				INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adrc.Acq_Deal_Run_Code
				INNER JOIN #tempRunDef trd ON trd.Title_Code = adrt.Title_Code
				INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Code = trd.Acq_Deal_Code
				WHERE adrc.Channel_Code IN ('''+@Value+''')')

				--Run def
				--rights AND Condition
				-- title
				--deal
				IF(@Operator = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempRunDef WHERE Acq_Deal_Code '+@Condition+' (Select Acq_Deal_Code FROM #RunDef) AND Title_Code '+@Condition+' (Select Title_Code FROM #RunDef)')
					
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRunDef) AND Title_Code NOT IN (Select Title_Code FROM #tempRunDef)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblRunDef

					INSERT INTO @tblRunDef(Acq_Deal_Code, Title_Code)
					Select Distinct Acq_Deal_Code,Title_Code from #RunDef

					DELETE FROM @tblRunDef WHERE Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRunDef) AND Title_Code IN (Select Title_Code FROM #tempRunDef)

					INSERT INTO #tempRunDef(Acq_Deal_Code,Title_Code)
					Select Acq_Deal_Code,Title_Code FROM @tblRunDef

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Milestone_Type_Code, Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term, adr.Milestone_Type_Code,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Yes' ELSE 'No' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblRunDef tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code AND tbld.Title_Code = adrt.Title_Code
					INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y')

					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code,Role_Code)
					SELECT DISTINCT ad.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code,Role_Code
					FROM Acq_Deal ad
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN #tempBusinessUnit tbu ON tbu.Business_Unit_Code = ad.Business_Unit_Code
					AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					INSERT INTO #tempTitle(Title_Code, Original_Title, Year_of_Release, Title_Language_Code)
					SELECT Distinct tr.Title_Code,t.Original_Title,t.Year_Of_Production, Title_Language_Code 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)

					DELETE FROM @tblRunDef
				END

			END

		END

	FETCH NEXT FROM db_cursor INTO  @Key,@Value,@Condition,@Operator,@IsDisplay,@OrderBy,@Group
	END
	CLOSE db_cursor
	DEALLOCATE db_cursor
	
	/*Insert Into Temp Tables for Criteria*/

	--Print @whTitle
	--EXEC ('INSERT INTO #tempTitle(Title_Code) SELECT Title_Code FROM Title WHERE' +@whTitle)

	--PRINT @whDeal
	--EXEC ('INSERT INTO #tempDeal(Acq_Deal_Code) SELECT Acq_Deal_Code FROM Acq_Deal WHERE' +@whDeal)

	--PRINT @whRights
	--Select @whRights

	--EXEC ('INSERT INTO #tempRights(Acq_Deal_Rights_Code,Acq_Deal_Code,Title_Code) 
	--SELECT adr.Acq_Deal_Rights_Code,Acq_Deal_Code,adrt.Title_Code FROM Acq_Deal_Rights adr
	--INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
	--WHERE '+ @whRights)
	
	--select * FROM #tempTitle
	--Select * FROM #tempDeal
	--Select * FROM #tempRights



	/*Here we will have to consider the records of the UDT which has IsDisplay = ‘Y’, 
	that means these records will be used for the Display I.e. as Output Columns. 48.
	Now Here the Order of the Display columns plays an important role. We have to display the Output according to the order no.
	So we have checked for the records to match the key of the UDT. */

	CREATE TABLE #tmpDisplay(
		[Key] VARCHAR(1000),
		[Order] INT
	)

	INSERT INTO #tmpDisplay
	SELECT [Key], [Order] FROM @UDT WHERE IsDisplay = 'Y'

	IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Platform')
	BEGIN
		
		DECLARE @OrderPlatform INT = 0
		SELECT @OrderPlatform = [Order] FROM #tmpDisplay WHERE [Key] = 'Platform' --AND IsDisplay = 'Y'

		UPDATE #tmpDisplay SET [Order] = [Order] + 1 WHERE [Order] > @OrderPlatform

	END

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
		IF(@DealType = 27)
			BEGIN
				
				UPDATE tt SET tt.TiTle =  t.Title_Name + ' - '+sp.Sport_Brand_Name 
				from #tempTitle tt
				INNER JOIN Acq_Deal_Movie adm ON adm.Title_Code = tt.Title_Code
				INNER JOIN Sport_Brand sp ON sp.Sport_Brand_Code = adm.Sport_Brand_Code
				INNER JOIN Title t on t.Title_Code = tt.Title_Code

			END
		ELSE
			BEGIN
				UPDATE tt SET tt.TiTle = t.Title_Name
				from #tempTitle tt
				INNER JOIN Title t ON t.Title_COde = tt.Title_Code
			END


		PRINT 'Title - End'

	END

	IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Title Language')
	BEGIN
		PRINT 'Title - Start'

		--SELECT TOP 1 @GroupDetail = 'GROUP' + CAST(GroupOrder AS VARCHAR), @FieldOrder = FieldOrder, @ColName = DisplayName FROM #TempFields WHERE DisplayName = 'Title'
		 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Title Language')
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Title_Language'
		
		--SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		--Select 
		UPDATE tt SET tt.Title_Language = l.Language_Name
		from #tempTitle tt
		INNER JOIN Language l ON l.Language_Code = tt.Title_Language_Code


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
		INNER JOIN Map_Extended_Columns mec ON mec.Record_Code = tt.Title_Code
		INNER JOIN Extended_Columns_Value ecv ON ecv.Columns_Value_Code = mec.Columns_Value_Code
		INNER JOIN Extended_Columns ec ON ec.Columns_Code = mec.Columns_Code AND ec.Columns_Name = 'CBFC Rating'

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
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
		
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
		
		UPDATE td SET td.Agreement_Date = REPLACE(CONVERT(NVARCHAR,CAST(td.Agreement_Date AS DATETIME), 106), ' ', '-')
		FROM #tempDeal td

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
		INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
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
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
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
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
		INNER JOIN Category c ON c.Category_Code = td.Deal_Category_Code
		
		--Select * from #tempDeal
		PRINT 'Deal Category - End'
	END

	IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Mode of Acquisition')
	BEGIN
		PRINT 'Deal Category --Start'
	
		 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Mode of Acquisition')
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'ModeOfAcquisition'
		
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		--Select c.Category_Name
		UPDATE td SET td.ModeOfAcquisition = R.Role_Name
		from #tempDeal td
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
		INNER JOIN Role r ON r.Role_Code = td.Role_Code
		
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
		
		--UPDATE td SET td.Deal_Description = ad.Deal_Desc
		--from #tempDeal td
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
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
		INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
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
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
		INNER JOIN Entity e ON e.Entity_Code = td.Entity_Code
		--Select * from #tempDeal
		PRINT 'Entity - End'
	END

	IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Licensor')
	BEGIN
		PRINT 'Entity--Start'
	
		 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Licensor')
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '
		SET @TableColumns = @TableColumns + 'Licensor'
		
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		UPDATE td SET td.Licensor = v.Vendor_Name
		from #tempDeal td
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
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
	--				FROM Acq_Deal_Rights_Territory adrt
	--				INNER JOIN Country c ON C.Country_Code = adrt.Country_Code
	--				WHERE adrt.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
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
	--				FROM Acq_Deal_Rights_Territory adrt
	--				INNER JOIN Territory t ON t.Territory_Code = adrt.Territory_Code
	--				WHERE adrt.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
	--		FOR XML PATH('')), 1, 1, '')
	--	FROM #tempRights tr
	--	--Select * FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code IN (Select Acq_Deal_Rights_Code FROm #tempRights)
		
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
		SELECT DISTINCT tmd.Acq_Deal_Rights_Code, cn.Country_Name 
		FROM #TempRights tmd
		INNER JOIN Acq_Deal_Rights_Territory tt ON tmd.Acq_Deal_Rights_Code = tt.Acq_Deal_Rights_Code AND tt.Territory_Type = 'I'
		INNER JOIN Country cn ON tt.Country_Code = cn.Country_Code
		
		INSERT INTO #TempTerritory
		SELECT DISTINCT tmd.Acq_Deal_Rights_Code, cn.Territory_Name 
		FROM #TempRights tmd
		INNER JOIN Acq_Deal_Rights_Territory tt ON tmd.Acq_Deal_Rights_Code = tt.Acq_Deal_Rights_Code AND tt.Territory_Type = 'G'
		INNER JOIN Territory cn ON tt.Territory_Code = cn.Territory_Code
		
		UPDATE tr Set tr.Region = STUFF(( SELECT Distinct ', '+ t.Territory_Name
					FROM Acq_Deal_Rights_Territory adrt
					INNER JOIN #TempTerritory t ON t.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
					WHERE adrt.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
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
		
		
		--Select tr.Acq_Deal_Rights_Code,adrs.Language_Code,adrs.Language_Group_Code FROM #tempRights tr
		--INNER JOIN Acq_Deal_Rights_Subtitling adrs ON adrs.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code

		TRUNCATE TABLE #TempLang
		
		INSERT INTO #TempLang
		SELECT DISTINCT  tmd.Acq_Deal_Rights_Code, l.Language_Name 
		FROM #tempRights tmd
		INNER JOIN Acq_Deal_Rights_Subtitling tb ON tmd.Acq_Deal_Rights_Code= tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'L'
		INNER JOIN Language l ON tb.Language_Code = l.Language_Code
		
		INSERT INTO #TempLang
		SELECT DISTINCT  tmd.Acq_Deal_Rights_Code, l.Language_Group_Name 
		FROM #tempRights tmd
		INNER JOIN Acq_Deal_Rights_Subtitling tb ON tmd.Acq_Deal_Rights_Code = tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'G'
		INNER JOIN Language_Group l ON tb.Language_Group_Code = l.Language_Group_Code
		
		--MERGE #TempRights AS T
		--USING (
		--	SELECT --'Language - ' + 
		--		(STUFF ((
		--		Select ', ' + tl.Language_Name 
		--		FROM  #TempLang tl WHERE tl.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
		--		ORDER BY tl.Language_Name
		--		FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
		--	) AS Subtitling, Acq_Deal_Rights_Code
		--	FROM (
		--		SELECT DISTINCT Acq_Deal_Rights_Code FROM #TempLang
		--	) a
		--) AS S ON s.Acq_Deal_Rights_Code = T.Acq_Deal_Rights_Code 
		--WHEN MATCHED THEN
		--UPDATE SET T.Subtitling = S.Subtitling;

		UPDATE tr Set tr.Subtitling = STUFF((SELECT Distinct ', '+ t.Language_Name
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN #TempLang t ON t.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
					WHERE adrt.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
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
		
		
		--Select tr.Acq_Deal_Rights_Code,adrs.Language_Code,adrs.Language_Group_Code FROM #tempRights tr
		--INNER JOIN Acq_Deal_Rights_Dubbing adrs ON adrs.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code

		TRUNCATE TABLE #TempLang
		
		INSERT INTO #TempLang
		SELECT DISTINCT tmd.Acq_Deal_Rights_Code, l.Language_Name 
		FROM #tempRights tmd
		INNER JOIN Acq_Deal_Rights_Dubbing tb ON tmd.Acq_Deal_Rights_Code= tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'L'
		INNER JOIN Language l ON tb.Language_Code = l.Language_Code
		
		INSERT INTO #TempLang
		SELECT DISTINCT tmd.Acq_Deal_Rights_Code, l.Language_Group_Name 
		FROM #tempRights tmd
		INNER JOIN Acq_Deal_Rights_Dubbing tb ON tmd.Acq_Deal_Rights_Code = tb.Acq_Deal_Rights_Code AND tb.Language_Type = 'G'
		INNER JOIN Language_Group l ON tb.Language_Group_Code = l.Language_Group_Code
		
		--MERGE #TempRights AS T
		--USING (
		--	SELECT --'Language - ' + 
		--		(STUFF ((
		--		Select ', ' + tl.Language_Name 
		--		FROM  #TempLang tl WHERE tl.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
		--		ORDER BY tl.Language_Name
		--		FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
		--	) AS Dubbing, Acq_Deal_Rights_Code
		--	FROM (
		--		SELECT DISTINCT Acq_Deal_Rights_Code FROM #TempLang
		--	) a
		--) AS S ON s.Acq_Deal_Rights_Code = T.Acq_Deal_Rights_Code 
		--WHEN MATCHED THEN
		--UPDATE SET T.Dubbing = S.Dubbing;
		UPDATE tr Set tr.Dubbing = STUFF(( SELECT Distinct ', '+ t.Language_Name
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN #TempLang t ON t.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
					WHERE adrt.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
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
		SET @TableColumns = @TableColumns + 'Media_Platform, Mode_Of_Exploitation'
		
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)

		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST((@OutputCounter + 1) AS VARCHAR)
		

		CREATE TABLE #TempPlatforms
		(
			Acq_Deal_Rights_Code INT,
			Platform_Code INT,
		)
		
		CREATE TABLE #TempPlatformsHL
		(
			Acq_Deal_Rights_Code INT,
			MediaPlatforms NVARCHAR(2000),
			ExploitationPlatforms NVARCHAR(2000),
		)

		

		INSERT INTO #TempPlatforms
		SELECT DISTINCT tmd.Acq_Deal_Rights_Code, tp.Platform_Code 
		FROM #tempRights tmd
		INNER JOIN Acq_Deal_Rights_Platform tp ON tmd.Acq_Deal_Rights_Code = tp.Acq_Deal_Rights_Code
		
		INSERT INTO #TempPlatformsHL(Acq_Deal_Rights_Code, MediaPlatforms, ExploitationPlatforms)
		SELECT DISTINCT Acq_Deal_Rights_Code, Media_Platform, ExploitatiON_Platform FROM (
			SELECT Acq_Deal_Rights_Code, (STUFF ((
				SELECT ',' + CAST(tl.Platform_Code AS VARCHAR)
				FROM  #TempPlatforms tl WHERE a.Acq_Deal_Rights_Code = tl.Acq_Deal_Rights_Code
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 1, '')
			) AS PlatformCodes
			FROM (
				SELECT DISTINCT Acq_Deal_Rights_Code FROM #TempPlatforms
			) AS a
		) AS b
		CROSS APPLY DBO.[UFN_Get_Platform_Group_WithNo](b.PlatformCodes)

		
		UPDATE tr SET tr.Media_Platform = tmpPl.MediaPlatforms, tr.Mode_Of_Exploitation = tmpPl.ExploitationPlatforms
		FROM #TempPlatformsHL tmpPl
		INNER JOIN #tempRights tr ON tmpPl.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code

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
		
		--UPDATE td SET td.Deal_Description = ad.Deal_Desc
		--from #tempDeal td
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
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
		
		--UPDATE td SET td.Deal_Description = ad.Deal_Desc
		--from #tempDeal td
		--INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
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
		
		--UPDATE tr SET tr.Term = (LEFT(tr.term, CHARINDEX('.', tr.term)-1) + ' Year ' + 
		--SUBSTRING(tr.term, CHARINDEX('.', tr.term)+1, LEN(tr.term)-CHARINDEX('.', tr.term)-CHARINDEX('.',REVERSE(tr.term ))) + ' Month '+
		--RIGHT(tr.term, CHARINDEX('.', REVERSE(tr.term))-1) + ' Days'  )
		--FROM #tempRights tr

		PRINT 'Right End Date - End'
	END

	IF EXISTS(SELECT TOP 1 * FROM #tmpDisplay WHERE [Key] = 'Channel')
	BEGIN
		PRINT 'Channel - Start'
	
		 SET @OutputCounter = (SELECT TOP 1 [Order] FROM #tmpDisplay WHERE [Key] = 'Channel')
		
		IF(@TableColumns <> '')
			SET @TableColumns = @TableColumns + ', '

		SET @TableColumns = @TableColumns + '[Channel]'
		
		----SET @OutputCounter = @OutputCounter + 1
		IF(@OutputCols <> '')
			SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@OutputCounter AS VARCHAR)
		
		UPDATE trd SET trd.Channel =  STUFF(
			(  SELECT Distinct ', '+ c.Channel_Name
					FROM Acq_Deal_Run_Channel adrc
					INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Run_Code = Adrc.Acq_Deal_Run_Code
					INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adr.Acq_Deal_Run_Code
					INNER JOIN Channel c ON c.Channel_Code = adrc.Channel_Code
					WHERE adr.Acq_Deal_Code = trd.Acq_Deal_Code AND adrt.Title_Code = trd.Title_Code
			FOR XML PATH('')), 1, 1, '')
		from #tempRunDef trd

		--Select * from #tempTitle
		PRINT 'Title - End'

	END

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
		INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Code = trd.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adr.Acq_Deal_Run_Code AND adrt.Title_Code = trd.Title_Code

		--Select * from #tempTitle
		PRINT 'Run_Limitation - End'

	END

	--IF NOT EXISTS (Select top 1 * from #tempRights )
	--BEGIN
	--	PRINT 'Inside IF Not Exists'
	--	INSERT INTO #tempRights(Acq_Deal_Code,Title_Code)
	--	Select Distinct adr.Acq_Deal_Code,tt.Title_Code from #tempTitle tt
	--	INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Title_Code = tt.Title_Code
	--	INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code

	--END

	--SELECT * FROM #tempTitle tt
	--INNER JOIN #tempRights tr ON tr.Title_Code = tt.Title_Code
	--INNER JOIN #tempDeal td ON td.Acq_Deal_Code = tr.Acq_Deal_Code

	EXEC ('INSERT INTO #tempOutput( '+@OutputCols+')
		   Select Distinct '+@TableColumns+' FROM #tempTitle tt
		   INNER JOIN #tempRights tr ON tr.Title_Code = tt.Title_Code
		   INNER JOIN #tempDeal td ON td.Acq_Deal_Code = tr.Acq_Deal_Code
		   INNER JOIN #tempRunDef trd ON trd.Acq_Deal_Code = td.Acq_Deal_Code AND trd.Title_Code = tr.Title_Code
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
	IF(OBJECT_ID('tempdb..#tblRights_NewHoldback') IS NOT NULL) DROP TABLE #tblRights_NewHoldback

	--RETURN
END
