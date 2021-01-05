
CREATE PROCEDURE [dbo].[USP_Query_Report]  
  @Sql_Select VARCHAR(MAX),  
  @Sql_Where NVARCHAR(MAX),  
  @Column_Count INT,  
  @Column_Names VARCHAR(MAX),  
  @Report_Query_Code INT=0,  
  @Subtitling_Codes VARCHAR(MAX),  
  @Dubbing_Codes VARCHAR(MAX),  
  @Country_Codes VARCHAR(MAX),  
  @Is_Debug CHAR(1),  
  @Channel_Codes VARCHAR(MAX),  
  @Category_Codes VARCHAR(MAX) 
AS 
BEGIN
	SET NOCOUNT ON 
	--DECLARE @Condition NVARCHAR(MAX) = 'BUSINESS_UNIT_CODE~AND~IN~1|EXPIRED~AND~=~N|IS_THEATRICAL_RIGHT~=~N|AD.VENDOR_CODE~AND~IN~270|'
	--DECLARE @ColNames NVARCHAR(MAX) = 'Agreement No,Title,Deal Description,'

	DECLARE @Condition NVARCHAR(MAX) = @Sql_Where
	DECLARE @ColNames NVARCHAR(MAX) = @Column_Names

	DECLARE @PlatformCriteria NVARCHAR(MAX) = ''

	IF(OBJECT_ID('tempdb..#buwiseacq_deal_code') IS NOT NULL) DROP TABLE #buwiseacq_deal_code
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
	IF(OBJECT_ID('tempdb..#tblRights_NewHoldback') IS NOT NULL) DROP TABLE #tblRights_NewHoldback
	IF(OBJECT_ID('tempdb..#tblRightsPlatforms') IS NOT NULL) DROP TABLE #tblRightsPlatforms
	IF(OBJECT_ID('tempdb..#RunDef_Junk') IS NOT NULL) DROP TABLE #RunDef_Junk
	IF(OBJECT_ID('tempdb..#tblORRightCode') IS NOT NULL) DROP TABLE #tblORRightCode

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
		COL39 NVARCHAR(MAX),
		COL40 NVARCHAR(MAX),
		COL41 NVARCHAR(MAX),
		COL42 NVARCHAR(MAX),
		COL43 NVARCHAR(MAX),
		COL44 NVARCHAR(MAX),
		COL45 NVARCHAR(MAX)
	)
	
	CREATE TABLE #tblORRightCode (Acq_Deal_Rights_Code INT)
	CREATE TABLE #BUWiseAcq_Deal_Code (Acq_Deal_Code INT)
	CREATE TABLE #tbl_Platform_RightCodes (Acq_Deal_Code INT, Acq_Deal_Rights_Code INT)
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
		Column_Value VARCHAR(MAX)
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
		Deal_Type_Code INT,
		Category_Type NVARCHAR(4000),
		Mode_Of_Acquisition INT,
		Role_Name VARCHAR(MAX),
		Due_Diligence VARCHAR(MAX),
		Variable_Cost_Type VARCHAR(10),
		Deal_Segment_Name VARCHAR(MAX),
		Deal_Segment_Code INT,
		Revenue_Vertical_Name  VARCHAR(MAX),
		Revenue_Vertical_Code INT
	)

	CREATE TABLE #tempRights(
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
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
		Promoter_Group_Name NVARCHAR(MAX),
		Promoter_Remark_Desc NVARCHAR(MAX),
		Is_ROFR VARCHAR(10),
		Restriction_Remarks NVARCHAR(MAX),
		Is_Holdback VARCHAR(30),
		Comb_Acq_Title_Code VARCHAR(MAX)
	)

	CREATE TABLE #tempRunDef(
		Acq_Deal_Code INT,
		Title_Code INT,
		[Channel] NVARCHAR(MAX),
		Run_Limitation VARCHAR(MAX),
		Due_Deligence VARCHAR(MAX),
		Comb_Acq_Title_Code VARCHAR(MAX)
	)
	
	DECLARE @tblTitle TABLE(Title_Code INT, Original_Title NVARCHAR(MAX), Original_Dubbed NVARCHAR(MAX), Year_of_Release INT,CBFC_Rating INT)
	
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
		Deal_Type_Code INT,
		Category_Type NVARCHAR(4000),
		Role_Code INT,
		Mode_Of_Acquisition INT,
		Role_Name VARCHAR(MAX),
		Due_Diligence VARCHAR(MAX),
		Variable_Cost_Type VARCHAR(10),
		Deal_Segment_Name VARCHAR(MAX),
		Deal_Segment_Code INT,
		Revenue_Vertical_Name  VARCHAR(MAX),
		Revenue_Vertical_Code INT
	)
	
	DECLARE @tblRights_New TABLE(
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
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
		Promoter_Group_Name NVARCHAR(MAX),
		Promoter_Remark_Desc NVARCHAR(MAX),
		Is_ROFR VARCHAR(10),
		Restriction_Remarks NVARCHAR(MAX),
		Is_Holdback VARCHAR(30) 
	)

	CREATE TABLE #tblRightsPlatforms(
		Acq_Deal_Rights_Code INT,
		PlatformName NVARCHAR(MAX),
	)

	CREATE TABLE #tblRights_NewHoldback(
		Acq_Deal_Rights_Code INT,
		Acq_Deal_Code INT,
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
		Promoter_Group_Name NVARCHAR(MAX),
		Promoter_Remark_Desc NVARCHAR(MAX),
		Is_ROFR VARCHAR(10),
		Restriction_Remarks NVARCHAR(MAX),
		Is_Holdback VARCHAR(30) 
	)
	
	DECLARE @tblRunDef TABLE(
		Acq_Deal_Code INT,
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
		INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
	WHERE 
		MEC.Table_Name='TITLE' 
		AND MEC.Columns_Code IN (SELECT Columns_Code FROM Extended_Columns WHERE Columns_Name = 'Type of Film')

	DECLARE @tblCriteria TABLE(Id INT, ColCriteria NVARCHAR(MAX))
	
	
	PRINT'INSERTING INTO #TEMP TABLE'
	SELECT id as SrNo, number as Operation INTO #Temp_Condition FROM DBO.fn_Split_withdelemiter(@Condition,'|') WHERE number <> ''
	
	PRINT'DECLARATION'
	DECLARE @Counter INT = 1, @Cnt_TempCond INT = 0, @Operation NVARCHAR(MAX), @IncludeExpired CHAR(1) = 'Y', @TheatricalTerritory CHAR(1) = 'Y'
	DECLARE @LeftColDbname NVARCHAR(MAX),
			@logicalConnect NVARCHAR(MAX),
			@theOp NVARCHAR(MAX),
			@Value NVARCHAR(MAX)
	DECLARE @Start_Date varchar(10), @End_Date varchar(10)
	
	SELECT @Cnt_TempCond = COUNT(*) FROM #Temp_Condition

	IF EXISTS(SELECT * FROM #Temp_Condition where Operation ='EXPIRED~AND~=~N')
		SET @IncludeExpired = 'N'

	IF EXISTS(SELECT * FROM #Temp_Condition where Operation ='IS_THEATRICAL_RIGHT~=~N')
		SET @TheatricalTerritory = 'N'

	print @TheatricalTerritory

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
		PRINT ' '+ @LeftColDbname  
		print convert(varchar, getdate(), 114)

		IF(@LeftColDbname = 'BUSINESS_UNIT_CODE')
		BEGIN
			INSERT INTO #BUWiseAcq_Deal_Code(Acq_Deal_code)
			EXEC('SELECT Acq_Deal_code FROM Acq_Deal WHERE  Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND Business_Unit_Code '+@theOp+' ('+@Value+')' )
			
			INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed, Year_of_Release, CBFC_Rating)
			SELECT Title_Code, Original_Title, ISNULL(OD.Columns_Value,'NA'), Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM Title t 
			LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
			LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code and mec.Columns_Code = 5

			INSERT INTO #tempRights(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
			SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
				CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
				CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
				dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
				as Promoter_Group_Name,
				dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
				as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
				CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback
			FROM Acq_Deal ad
				INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = AD.Acq_Deal_code
				INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code --AND adr.PA_Right_Type = 'PR'
				INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
				INNER JOIN #tempTitle tt ON tt.Title_Code = adrt.Title_Code
			WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
	
			DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
	
			INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
			SELECT distinct AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
			CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END, AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
			FROM Acq_Deal ad
			INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = AD.Acq_Deal_code
			INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
			LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
			LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code

			

			INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
			SELECT DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights
			
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
				
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' ('+@Value+')')

					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle

					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release,CBFC_Rating)
					EXEC ('Select Distinct t.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
						   FROM Title t 
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
						   WHERE t.Title_Code '+@theOp+' ('+@Value+')
						   AND Reference_Flag IS NULL')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory


					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)

					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
	
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END			
			END--if title end

			IF(@LeftColDbname = 'ORIGINAL_DUBBED')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Original_Dubbed '+@theOp+' ('''+@Value+''')')
	
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
						
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release, CBFC_Rating)
					EXEC ('Select Distinct t.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
						   FROM Title t 
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
						   WHERE ISNULL(OD.Columns_Value,''NA'') '+@theOp+' ('''+@Value+''')
						   AND T.Reference_Flag IS NULL')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
	
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
	
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END			
			END -- original dubbed end

			IF(@LeftColDbname = 'DIRECTOR_CODE')
			BEGIN	
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+') AND Role_Code = 1)')
					
					DELETE FROM #tempTitle WHERE DBO.UFN_Get_Title_Metadata_By_Role_Code(Title_Code, 1) = ''
					
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle

					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release, CBFC_Rating)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM Title_Talent tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code AND tg.Role_Code = 1
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
						   WHERE tg.Talent_Code '+@theOp+' ('+@Value+')
						   AND Reference_Flag IS NULL')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END
			END-- director end

			IF(@LeftColDbname = 'STARCAST_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' ( Select Title_Code FROM Title_Talent WHERE Talent_Code IN ('+@Value+') AND Role_Code = 2)')
			
					DELETE FROM #tempTitle WHERE DBO.UFN_Get_Title_Metadata_By_Role_Code(Title_Code, 2) = ''
										
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release, CBFC_Rating)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM Title_Talent tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code AND tg.Role_Code = 2
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
						   WHERE tg.Talent_Code '+@theOp+' ('+@Value+')
						   AND Reference_Flag IS NULL')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory
				
					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblTitle
				END
			
			END--starcast end

			IF(@LeftColDbname = 'GENRES_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE Title_Code '+@theOp+' (SELECT Title_Code FROM Title_Geners WHERE Genres_Code IN ('+@Value+'))')
					
					DELETE FROM #tempTitle WHERE DBO.UFN_Get_Title_Genre(Title_Code) = ''

					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
	
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE IF(@logicalConnect = 'OR')
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle(Title_Code,Original_Title,Original_Dubbed,Year_of_Release, CBFC_Rating)
					EXEC ('Select Distinct tg.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,''NA''),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM Title_Geners tg 
						   INNER JOIN Title t ON t.Title_Code = tg.Title_Code
						   LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						   LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
						   WHERE tg.Genres_Code '+@theOp+' ('+@Value+')
						   AND Reference_Flag IS NULL')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
	
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
	
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					--TRUNCATE TABLE #tempRunDef
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblTitle
				END
			END--genre end

			IF(@LeftColDbname = 'TIT.ORIGINAL_TITLE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempTitle WHERE title_code NOT IN ( SELECT title_code FROM #tempTitle WHERE Original_Title '+@theOp +' '''+  @Value +''')')
				
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
				
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle (Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					EXEC ('SELECT DISTINCT t.Title_Code, t.Original_Title,ISNULL(OD.Columns_Value,''NA''), t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM Title T
							LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
							LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
								WHERE t.Original_Title '+@theOp +' '''+  @Value +''' AND Reference_Flag IS NULL')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblTitle
			
				END
			END--original title end

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
				
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle
				
					INSERT INTO @tblTitle (Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					EXEC ('SELECT DISTINCT t.Title_Code, t.Original_Title,ISNULL(OD.Columns_Value,''NA''), t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM Title T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE t.Year_Of_Production '+@theOp +' '+  @Value )
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblTitle
			
				END
			END -- year of production end

			IF(@LeftColDbname = 'COLUMNS_VALUE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					
					EXEC (' DELETE FROM #tempTitle WHERE CBFC_Rating '+@theOp +' ('+  @Value +')  OR CBFC_Rating IS NULL' )
					
					DELETE FROM #tempRights WHERE Title_Code NOT IN (Select Title_Code from #tempTitle)
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblTitle

					INSERT INTO @tblTitle (Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					EXEC ('SELECT DISTINCT t.Title_Code, t.Original_Title,ISNULL(OD.Columns_Value,''NA''), t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM Title T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE mec.Columns_Value_Code '+@theOp +' ('+  @Value + ')')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblTitle WHERE Title_Code IN (Select Title_Code from #tempTitle)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,tblT.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad 
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					WHERE ad.Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRights)
					AND ad.Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempDeal)
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Title_Code,Original_Title,ISNULL(OD.Columns_Value,'NA'),Year_of_Release, CBFC_Rating FROM @tblTitle T
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
									
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblTitle
			
				END
			END -- CBFC RATING end
		END --TITLE CRITERIA END

		PRINT'ACQ DEAL CRITERIA START'
		BEGIN
			IF(@LeftColDbname = 'AD.AGREEMENT_NO')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF(@theOp = '=')
						EXEC ('DELETE FROM #tempDeal WHERE Agreement_No <> '''+@Value+''' ')
					ELSE
						EXEC ('DELETE FROM #tempDeal WHERE Agreement_No NOT '+@theOp+' '''+@Value+''' ')
					
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (SELECT Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE Agreement_No '+@theOp+' '''+@Value+''' ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
	
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type,  Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				END
			END--agreement no end



			IF(@LeftColDbname = 'AD.DEAL_DESC')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF(@theOp = '=')
						EXEC ('DELETE FROM #tempDeal WHERE Deal_Description <> '''+@Value+''' ')
					ELSE
						EXEC ('DELETE FROM #tempDeal WHERE Deal_Description NOT '+@theOp+' '''+@Value+''' ')
	
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (SELECT Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE ad.Deal_Desc '+@theOp+' '''+@Value+''' ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code-- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed,Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				END
			END -- deal desc end

			IF(@LeftColDbname = 'CAT_NAME')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Deal_Category_Code '+@theOp+' ('+@Value+')')
	
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (SELECT Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE ad.Category_Code '+@theOp+' ('+@Value+')')

					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code-- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed,Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				END
			END -- deal Category end



			IF(@LeftColDbname = 'ADM.DUE_DILIGENCE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
				PRINT 'ENTER DUE DILIGENCE'
					EXEC ('DELETE FROM #tempDeal WHERE Due_Diligence '+@theOp+' ('''+@Value+''') OR Due_Diligence IS NULL ')
	
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (SELECT Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						       CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
							   FROM Acq_Deal ad
							   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
							   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
							   INNER JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
							   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
							   WHERE adm.Due_Diligence '+@theOp+' ('''+@Value+''') ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code-- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed,Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				END
			END -- Due Diligence end
			IF(@LeftColDbname = 'AD.VENDOR_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Vendor_Code '+@theOp+' ('+@Value+')')
				
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
				
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE Vendor_Code '+@theOp+' ('+@Value+') ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				
				END
			END--vendor code end

			IF(@LeftColDbname = 'Revenue_Vertical')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Revenue_Vertical_Code '+@theOp+' ('+@Value+')')
				
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
				
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE Revenue_Vertical_Code '+@theOp+' ('+@Value+') ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				
				END
			END--vendor code end

			IF(@LeftColDbname = 'DEAL_SEGMENT')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Deal_Segment_Code '+@theOp+' ('+@Value+')')
				
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
				
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE Deal_Segment_Code '+@theOp+' ('+@Value+') ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				
				END
			END--vendor code end

			IF(@LeftColDbname = 'AD.CURRENCY_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'
	
					EXEC ('DELETE FROM #tempDeal WHERE Currency_Code '+@theOp+' ('+@Value+') ')
				
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE ad.Currency_Code '+@theOp+' '''+@Value+''' ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed,Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				END
			END--currency code end
			IF(@LeftColDbname = 'AD.ENTITY_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'
	
					EXEC ('DELETE FROM #tempDeal WHERE Entity_Code '+@theOp+' '''+@Value+'''')
				
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE ENTITY_CODE '+@theOp+' '''+@Value+''' ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				
				END
			END--entity code end

			IF(@LeftColDbname = 'AD.AGREEMENT_DATE')
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
					EXEC (' DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal WHERE AGREEMENT_DATE '+@theOp +' '+  @Value +')')
	
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
	
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
	
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE  ad.AGREEMENT_DATE '+@theOp+' '+@Value)
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

	
					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'NO' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code,Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code

					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed,Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblDeal
				END
			END--egreement date end

			IF(@LeftColDbname = 'AD.DEAL_TAG_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'

					EXEC ('DELETE FROM #tempDeal WHERE DEAL_TAG_CODE '+@theOp+' '+@Value)

					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)

				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
				
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,Ad.Deal_Segment_Code,AD.Revenue_Vertical_Code
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
						   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
						   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						   WHERE ad.DEAL_TAG_CODE '+@theOp+' '+@Value)
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback  
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
				
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblDeal
				END
			END--Deal Tag Code end

			IF(@LeftColDbname = 'AD.DEAL_TYPE_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE DEAL_TYPE_CODE '+@theOp+' ('+@Value+') ')
			
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
			
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
					   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					   WHERE ad.DEAL_TYPE_CODE '+@theOp+' ('+@Value+') ')
				
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
			
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
			
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
			
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblDeal
				END
			END--deal type code end

			IF(@LeftColDbname = 'AD.CATEGORY_TYPE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					IF (@theOp = '<>')
						SET @theOp = '='
					ELSE IF (@theOp = '=')
						SET @theOp = '<>'
					
					EXEC ('DELETE FROM #tempDeal WHERE Mode_Of_Acquisition '+@theOp+' '+@Value)
			
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
			
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type,DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
					   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					  WHERE ad.Role_Code '+@theOp+' '+@Value)
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
			
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
			
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
			
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblDeal
				END
			END--mode of acq end

			IF(@LeftColDbname = 'AD.DEAL_WORKFLOW_STATUS')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempDeal WHERE Deal_Workflow_Status '+@theOp+' ('''+@Value+''') ')
				
					DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)

					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
			
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
					DELETE FROM @tblDeal
					
					INSERT INTO @tblDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					EXEC ('SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type,DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						   CASE WHEN ISNULL(adc.Variable_Cost_Type, ''N'') = ''Y'' THEN ''Yes'' ELSE ''No'' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code tbu ON tbu.Acq_deal_Code = ad.Acq_deal_Code
					   INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
					   LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					   LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					   WHERE ad.Deal_Workflow_Status '+@theOp+' ('''+@Value+''') ')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adrt.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code -- AND adr.PA_Right_Type = 'PR'
					INNER Join @tblTitle tblT on tblT.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory

					Delete from @tblDeal WHERE Acq_Deal_Code IN (Select Acq_Deal_Code from #tempDeal)
			
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblDeal tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = adr.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory 
			
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, ad.Currency_Code, ad.Deal_Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code
					FROM @tblDeal AD
					--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
			
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblDeal
				END
			END--Deal Workflow Status end


		END--acq deal criteria end 

		PRINT'ACQ DEAL RIGHTS CRITERIA START'
		BEGIN
			IF(@LeftColDbname = 'ADR.ACTUAL_RIGHT_START_DATE')
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
					EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code NOT IN (Select Acq_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_Start_Date, ''9999-12-31'')  '+@theOp +' '+  @Value +')')
	
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				END
				ELSE
				BEGIN
	
					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To ,adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'')  AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
					   AND ISNULL(adr.Actual_Right_Start_Date, ''9999-12-31'')  '+@theOp +' '+  @Value 
					)
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
	
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production , mec.Columns_Value_Code as CBFC_Rating
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
				END
			END --ACTUAL_RIGHT_RIGHT_DATE end

			IF(@LeftColDbname = 'ADR.ACTUAL_RIGHT_END_DATE')
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
						EXEC('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code NOT IN (Select Acq_Deal_Rights_Code FROM #tempRights WHERE ISNULL(Right_End_Date, ''9999-12-31'')  '+@theOp +' '+  @Value +')')
						
						DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
	
						DELETE FROM #tempTitle WHERE Title_Code NOT IN (SELECT Title_Code FROM #tempRights)
	
						DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
					END
					ELSE
					BEGIN
						DELETE FROM @tblRights_New
	
						INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
						EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
						   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
						   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					       dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					       as Promoter_Group_Name,
					       dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					       as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
						   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback
						   FROM Acq_Deal ad
						   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
						   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
						   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
						   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
						   AND  ISNULL(adr.Actual_Right_End_Date, ''9999-12-31'')  '+@theOp +' '+  @Value
						)
						
						INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
						SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New

						DELETE trn
						FROM @tblRights_New trn 
						WHERE trn.Acq_Deal_Rights_Code IN ( 
							SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
							WHERE tr.Title_Code = trn.Title_Code
						)
						
						INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
						SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
						FROM @tblRights_New
	
						INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
						SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
						CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
						FROM Acq_Deal ad
						INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
						INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
						INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
						LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
						LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
						
	
						INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
						SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
						FROM #tempRights tr
						INNER JOIN Title t ON t.Title_Code = tr.Title_Code
						LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
						LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
						WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
						INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
						Select DISTINCT Acq_Deal_Code, Title_Code 
						FROM #tempRights tr
						WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					END
	
					DELETE FROM @tblRights_New
			END --right end date end

			IF(@LeftColDbname = 'ADR.IS_SUB_LICENSE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
	
					SELECT @Value = CASE WHEN @Value = 'Y' THEN 'Yes' ELSE 'No' END
				
					EXEC ('DELETE FROM #tempRights WHERE [Sub-Licensing] '+@theOp+' ('''+@Value+''') ')
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
					
					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback 
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
					   AND adr.Is_Sub_License '+@theOp+' ('''+@Value+''')'
					)
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New	

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
	
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
	
				END
			END--IS_SUB_LICENSE END

			IF(@LeftColDbname = 'ADR.MILESTONE_TYPE_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					
					EXEC ('DELETE FROM #tempRights WHERE Milestone_Type_Code '+@theOp+' ('+@Value+') OR Milestone_Type_Code IS NULL ')
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
	
					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To, adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback 
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
					   AND adr.Milestone_Type_Code '+@theOp+' ('+@Value+') and adr.Milestone_Type_Code IS NOT NULL'
					)

					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
	
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
	
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
	
				END
			END--MILESTONE END

			IF(@LeftColDbname = 'ADR.IS_HOLDBACK')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN					
					EXEC ('DELETE FROM #tempRights WHERE Is_Holdback '+@theOp+' ('''+@Value+''') OR Is_Holdback IS NULL')
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
	
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights) 
	
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
					
					INSERT INTO #tblRights_NewHoldback(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To, adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback 
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' '
					)
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New

					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback FROM #tblRights_NewHoldback
						   WHERE Is_Holdback '+@theOp+' ('''+@Value+''')'
					)
					
					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
	
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code

					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
	
					DELETE FROM @tblRights_New
					
				END
			END--HOLDBACK END

			IF(@LeftColDbname = 'COU.COUNTRY_CODE')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
				
					EXEC ('DELETE FROM #tempRights WHERE
					Acq_Deal_Rights_Code
							' + @theOp + ' (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code Is Not Null 
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
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
				
					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback 
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
					   AND adr.Acq_Deal_Rights_Code 
						'+@theOp+' (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code Is Not Null 
							AND (( 
									Country_Code IN ('+@Value+')
									AND Territory_Type=''I''
								) OR (
									Territory_Code IN (SELECT DISTINCT Territory_Code FROM Territory_Details WHERE 
									Country_Code  IN ('+@Value+') )  
									AND Territory_Type=''G''
								))
						)')
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblRights_New
				END
			END--Country code end

			IF(@LeftColDbname = 'S_LANG')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
					EXEC ('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code
							' + @theOp + ' (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code Is Not Null 
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
					
					DELETE FROM #tempRights WHERE DBO.UFN_Get_Rights_Subtitling(Acq_Deal_Rights_Code, 'A') = ''

					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)
				
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				
				END
				ELSE
				BEGIN
					DELETE FROM @tblRights_New
				
					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback 
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
					   AND adr.Acq_Deal_Rights_Code 
					   ' + @theOp + ' (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code Is Not Null 
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
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblRights_New
				END
			END--subtitle end

			IF(@LeftColDbname = 'D_LANG')
			BEGIN
				IF(@logicalConnect = 'AND')
				BEGIN
				
					EXEC ('DELETE FROM #tempRights WHERE 
					Acq_Deal_Rights_Code 
							 '+@theOp+' (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code Is Not Null 
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

					DELETE FROM #tempRights WHERE DBO.UFN_Get_Rights_Dubbing(Acq_Deal_Rights_Code, 'A') = ''
					
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code FROM #tempRights)
					
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
				
				END
				ELSE
				BEGIN
					
					DELETE FROM @tblRights_New
				
					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback  
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
					   AND adr.Acq_Deal_Rights_Code
					   '+@theOp+' (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code Is Not Null 
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
					
					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT Acq_Deal_Rights_Code FROM @tblRights_New

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
					
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
				
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
				
					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
				
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
				
					DELETE FROM @tblRights_New
				END
			END --dubbing end

			IF(@LeftColDbname = 'P.PLATFORM_CODE')
			BEGIN
				
				INSERT INTO #tbl_Platform_RightCodes(Acq_Deal_Code, Acq_Deal_Rights_Code)
				EXEC ('SELECT DISTINCT ADR.Acq_Deal_Code, P.Acq_Deal_Rights_Code 
				FROM Acq_Deal ad
				INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
				INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
				INNER JOIN Acq_Deal_Rights_Platform P ON P.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+'''  AND
				P.PLATFORM_CODE IN ('+@Value+')')

				IF(@logicalConnect = 'AND')
				BEGIN
					SET @PlatformCriteria = CASE WHEN @theOp = 'IN' THEN 'NOT IN' ELSE 'IN' END + ' (' +@Value+ ')'
					
					EXEC('DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code '+@theOp+' ( SELECT Acq_Deal_Rights_Code FROM #tbl_Platform_RightCodes )')

					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRights)
					
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
				
					DELETE FROM #tempRunDef WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights) AND Title_Code NOT IN (Select Title_Code from #tempRights)
			
				END
				ELSE 
				BEGIN

					SET @PlatformCriteria = @theOp + ' (' +@Value+ ')'
					
					DELETE FROM @tblRights_New
					
					INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					EXEC ('SELECT distinct ad.Acq_Deal_Code, adr.Acq_Deal_Rights_Code, adrt.Title_Code, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date,
					   CASE WHEN adr.Is_Sub_License = ''Y'' THEN ''Yes'' ELSE ''No'' END, 
					   CASE WHEN adr.Is_Exclusive = ''Y'' THEN ''Exclusive'' WHEN adr.Is_Exclusive = ''N'' THEN ''Non-Exclusive'' ELSE ''Co-Exclusive'' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''P'',''A'')  
					   as Promoter_Group_Name,
					   dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,''R'',''A'')  
					   as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					   CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' END AS Is_Holdback 
					   FROM Acq_Deal ad
					   INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					   INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
					   INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
					   WHERE (adr.Actual_Right_End_Date > GETDATE() OR '''+@IncludeExpired+''' = ''Y'') AND adr.Is_Theatrical_Right = '''+@TheatricalTerritory+''' 
					   AND adr.Acq_Deal_Rights_Code  '+@theOp+' ( SELECT Acq_Deal_Rights_Code FROM #tbl_Platform_RightCodes )
					')

					DELETE trn
					FROM @tblRights_New trn 
					WHERE trn.Acq_Deal_Rights_Code IN ( 
						SELECT tr.Acq_Deal_Rights_Code FROM #tempRights tr
						WHERE tr.Title_Code = trn.Title_Code
					)
				
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback)
					SELECT Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term ,Episode_From ,Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks, Is_Holdback
					FROM @tblRights_New
					
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
			
					INSERT INTO #tempTitle(Title_Code, Original_Title,Original_Dubbed, Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
			
			
					INSERT INTO #tempRunDef(Acq_Deal_Code, Title_Code)
					Select DISTINCT Acq_Deal_Code, Title_Code 
					FROM #tempRights tr
					WHERE Acq_Deal_Code NOT IN (Select trd.Acq_Deal_Code from #tempRunDef trd WHERE trd.Title_Code = tr.Title_Code) --AND TItle_Code NOT IN (Select Title_Code FROM #tempRunDef)
			
					DELETE FROM @tblRights_New
				END
			END--platform end

		END -- ACQ DEAL RIGHTS CRITERIA END
		
		PRINT'RUN DEFINATION CRITERIA START'
		BEGIN
			
			IF(@LeftColDbname = 'CHANNELNAMES')
			BEGIN
				CREATE TABLE #RunDef_Junk(Acq_Deal_Code INT, Title_Code INT , Comb_Acq_Title_Code VARCHAR(MAX))
				CREATE TABLE #RunDef(Acq_Deal_Code INT, Title_Code INT , Comb_Acq_Title_Code VARCHAR(MAX))
				UPDATE #tempRunDef SET Comb_Acq_Title_Code = CAST(Acq_Deal_Code AS VARCHAR) + '~' + CAST(Title_Code AS VARCHAR)

				--PRINT ('INSERT INTO #RunDef(Acq_Deal_Code, Title_Code)
				--SELECT DISTINCT trd.Acq_Deal_Code,trd.Title_Code FROM Acq_Deal_Run_Channel adrc
				--INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adrc.Acq_Deal_Run_Code
				--INNER JOIN #tempRunDef trd ON trd.Title_Code = adrt.Title_Code
				--INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Code = trd.Acq_Deal_Code
				--WHERE adrc.Channel_Code IN ('+@Value+')')

				EXEC ('INSERT INTO #RunDef_Junk(Acq_Deal_Code, Title_Code)
				SELECT DISTINCT adr.Acq_Deal_Code,adrt.Title_Code FROM Acq_Deal_Run_Channel adrc
				INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adrc.Acq_Deal_Run_Code
				INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Run_Code = adrt.Acq_Deal_Run_Code
				WHERE adrc.Channel_Code IN ('+@Value+')')

				UPDATE #RunDef_Junk SET Comb_Acq_Title_Code = CAST(Acq_Deal_Code AS VARCHAR) + '~' + CAST(Title_Code AS VARCHAR)

				INSERT INTO #RunDef(Acq_Deal_Code, Title_Code, Comb_Acq_Title_Code)
				SELECT A.Acq_Deal_Code, A.Title_Code, A.Comb_Acq_Title_Code
				FROM #RunDef_Junk A
				INNER JOIN #tempRunDef B ON A.Comb_Acq_Title_Code = B.Comb_Acq_Title_Code

				IF(@logicalConnect = 'AND')
				BEGIN
					UPDATE #tempRights SET Comb_Acq_Title_Code = CAST(Acq_Deal_Code AS VARCHAR) + '~' + CAST(Title_Code AS VARCHAR)

					EXEC ('DELETE FROM #tempRunDef WHERE Comb_Acq_Title_Code '+@theOp+' (SELECT Comb_Acq_Title_Code FROM #RunDef )')
					DELETE FROM #tempRights WHERE Comb_Acq_Title_Code NOT IN (SELECT Comb_Acq_Title_Code FROM #tempRunDef )
					--EXEC ('DELETE FROM #tempRunDef WHERE Acq_Deal_Code '+@theOp+' (Select Acq_Deal_Code FROM #RunDef) AND Title_Code '+@theOp+' (Select Title_Code FROM #RunDef)')
					--DELETE FROM #tempRights WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempRunDef) AND Title_Code NOT IN (Select Title_Code FROM #tempRunDef)
					DELETE FROM #tempTitle WHERE Title_Code NOT IN (Select Title_Code from #tempRights)
					DELETE FROM #tempDeal WHERE Acq_Deal_Code NOT IN (Select Acq_Deal_Code from #tempRights)
	
				END
				ELSE
				BEGIN
					DELETE FROM @tblRunDef
	
					INSERT INTO @tblRunDef(Acq_Deal_Code, Title_Code)
					Select Distinct Acq_Deal_Code,Title_Code from #RunDef

					INSERT INTO #tblORRightCode (Acq_Deal_Rights_Code)
					SELECT DISTINCT adr.Acq_Deal_Rights_Code 
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblRunDef tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code AND tbld.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = tblD.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory
	
					DELETE FROM @tblRunDef WHERE Acq_Deal_Code IN (Select Acq_Deal_Code FROM #tempRunDef) AND Title_Code IN (Select Title_Code FROM #tempRunDef)
	
					INSERT INTO #tempRunDef(Acq_Deal_Code,Title_Code)
					Select Acq_Deal_Code,Title_Code FROM @tblRunDef
	
					INSERT INTO #tempRights(Acq_Deal_Rights_Code, Acq_Deal_Code, Title_Code, Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, Episode_From, Episode_To,Milestone_Type_Code,Promoter_Group_Name,Promoter_Remark_Desc,Is_ROFR,Restriction_Remarks,Is_Holdback)
					Select Distinct adrt.Acq_Deal_Rights_Code,adr.Acq_Deal_Code,adrt.Title_Code,adr.Right_Start_Date,adr.Right_End_Date,
					CASE WHEN adr.Is_Sub_License = 'Y' THEN 'Yes' ELSE 'No' END, 
					CASE WHEN adr.Is_Exclusive = 'Y' THEN 'Exclusive' WHEN adr.Is_Exclusive = 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END, adr.Term  ,adrt.Episode_From ,adrt.Episode_To,adr.Milestone_Type_Code,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'P','A')  
					as Promoter_Group_Name,
					dBO.UFN_Get_Rights_Promoter_Group_Remarks(adr.Acq_Deal_Rights_Code,'R','A')  
					as Promoter_Remark_Desc, adr.Is_ROFR, adr.Restriction_Remarks,
					CASE WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' END AS Is_Holdback
					FROM Acq_Deal_Rights_Title adrt
					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code --AND adr.PA_Right_Type = 'PR'
					INNER Join @tblRunDef tblD ON tblD.Acq_Deal_Code = adr.Acq_Deal_Code AND tbld.Title_Code = adrt.Title_Code
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = tblD.Acq_Deal_code
					WHERE (adr.Actual_Right_End_Date > GETDATE() OR @IncludeExpired = 'Y') AND adr.Is_Theatrical_Right = @TheatricalTerritory
	
					INSERT INTO #tempDeal(Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Description, Deal_Workflow_Status, Currency_Code, Deal_Category_Code, Entity_Code, Vendor_Code,Deal_Tag_Code, Deal_Type_Code, Category_Type, Mode_Of_Acquisition, Due_Diligence, Variable_Cost_Type,Deal_Segment_Code,Revenue_Vertical_Code)
					SELECT DISTINCT AD.Acq_Deal_Code, Agreement_Date, Agreement_No, Deal_Desc, Deal_Workflow_Status, ad.Currency_Code, ad.Category_Code, ad.Entity_Code, ad.Vendor_Code,ad.Deal_Tag_Code, ad.Deal_Type_Code, LEFT(DC.Role_Name, 1) AS Category_Type, DC.Role_Code as Mode_Of_Acquisition, adm.Due_Diligence,
					CASE WHEN ISNULL(adc.Variable_Cost_Type, 'N') = 'Y' THEN 'Yes' ELSE 'No' END,AD.Deal_Segment_Code,AD.Revenue_Vertical_Code
					FROM Acq_Deal ad
					INNER JOIN #BUWiseAcq_Deal_Code BUAD ON BUAD.Acq_Deal_code = ad.Acq_Deal_code
					INNER JOIN #tempRights tr ON tr.Acq_Deal_Code = ad.Acq_Deal_Code
					INNER JOIN Role DC on AD.Role_Code = DC.Role_Code AND tr.Acq_Deal_Code NOT IN (Select Acq_Deal_Code FROM #tempDeal)
					LEFT JOIN Acq_Deal_Movie adm on adm.Acq_Deal_Code = ad.Acq_Deal_Code
					LEFT JOIN Acq_Deal_Cost adc on adc.Acq_Deal_Code = ad.Acq_Deal_Code
					
			
	
					INSERT INTO #tempTitle(Title_Code, Original_Title, Original_Dubbed,Year_of_Release, CBFC_Rating)
					SELECT Distinct tr.Title_Code,t.Original_Title,ISNULL(OD.Columns_Value,'NA'),t.Year_Of_Production, mec.Columns_Value_Code as CBFC_Rating 
					FROM #tempRights tr
					INNER JOIN Title t ON t.Title_Code = tr.Title_Code
					LEFT JOIN #OriDub_Title_Code OD ON OD.Record_Code = T.Title_Code
					LEFT JOIN Map_Extended_Columns mec on mec.Record_Code = t.Title_Code
					WHERE tr.Title_Code NOT IN (Select Distinct Title_Code from #tempTitle)
	
					DELETE FROM @tblRunDef
				END
			END -- channel end

		END

		SET @Counter = @Counter + 1
	END -- while loop end

	SELECT id as SrNo, LTRIM(RTRIM(number)) as ColNames INTO #Temp_ColNames FROM DBO.fn_Split_withdelemiter(@ColNames,',') WHERE LTRIM(RTRIM(number)) <> ''

	DECLARE @TableColumns NVARCHAR(MAX) = '' , @OutputCols NVARCHAR(MAX) = '',@OutputColsNames NVARCHAR(MAX) = '', @UnionColumns NVARCHAR(MAX) = ''
	SELECT @Counter=1, @Cnt_TempCond = COUNT(*) FROM #Temp_ColNames
	WHILE ( @Counter <= @Cnt_TempCond)
	BEGIN
		IF(@OutputCols <> '')
				SET @OutputCols = @OutputCols + ', '
		SET @OutputCols = @OutputCols + 'COL' + CAST(@Counter AS VARCHAR)
		--print 'OutputCols->'+@OutputCols
		SELECT @OutputColsNames = ColNames from #Temp_ColNames where SrNo = @Counter
		--Print 'OutputColsNames->'+@OutputColsNames
		IF(@UnionColumns <> '')
			SET @UnionColumns = @UnionColumns + ', '
		SET @UnionColumns = @UnionColumns + ''''+ CAST(@OutputColsNames AS VARCHAR)+ ''''
		--Print 'UnionsColumns->'+@UnionColumns

		BEGIN
			IF (UPPER(@OutputColsNames) =  'RIGHT START DATE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'CONVERT(VARCHAR,tr.Right_Start_Date,103) [Right Start Date]'
			END
	
			IF (UPPER(@OutputColsNames) =  'RIGHT END DATE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'CONVERT(VARCHAR,tr.Right_End_Date,103) [Right End Date]'
			END
	
			IF (UPPER(@OutputColsNames) =  'EXCLUSIVE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Exclusive [Exclusive]'
			END
	
			IF (UPPER(@OutputColsNames) =  'SUB-LICENSING')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.[Sub-Licensing] [Sub-Licensing]'
			END
	
			IF (UPPER(@OutputColsNames) =  'TERM')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Term [Term]'
	
				UPDATE #tempRights SET TERM = [dbo].[UFN_Get_Rights_Term](Right_Start_Date, Right_End_Date, Term) 
			END
	
			IF (UPPER(@OutputColsNames) =  'SUBTITLING')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Subtitling [Subtitling]'
	
				UPDATE #tempRights SET Subtitling = DBO.UFN_Get_Rights_Subtitling(Acq_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'DUBBING')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Dubbing [Dubbing]'
	
				UPDATE #tempRights SET Dubbing = DBO.UFN_Get_Rights_Dubbing(Acq_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'COUNTRY')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Country [Country]'
	
				UPDATE #tempRights SET Country = DBO.UFN_Get_Rights_Country_Query(Acq_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'TERRITORY')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Territory [Territory]'
	
				UPDATE #tempRights SET Territory = DBO.UFN_Get_Rights_Territory(Acq_Deal_Rights_Code, 'A')
			END
	
			IF (UPPER(@OutputColsNames) =  'PLATFORM')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114) 
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'trp.PlatformName [Platform]'
				
				IF(@PlatformCriteria = '')
				BEGIN	
			
					--INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code,Country, Dubbing, Subtitling, Territory , Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, [Platform], Episode_From, Episode_To, Title_Name)
					--SELECT DISTINCT TR.Acq_Deal_Code,TR.Acq_Deal_Rights_Code, TR.Title_Code, TR.Country, TR.Dubbing, TR.Subtitling, TR.Territory ,TR.Right_Start_Date, TR.Right_End_Date, TR.[Sub-Licensing],TR.Exclusive,TR.Term ,P.Platform_Hiearachy, TR.Episode_From, tr.Episode_To	, tr.Title_Name			
					--FROM #tempRights TR
					--INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					--LEFT JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
					--UNION ALL 
					--SELECT DISTINCT TR.Acq_Deal_Code,TR.Acq_Deal_Rights_Code, TR.Title_Code, TR.Country, TR.Dubbing, TR.Subtitling, TR.Territory, TR.Right_Start_Date, TR.Right_End_Date, TR.[Sub-Licensing], TR.Exclusive, TR.Term ,P.Platform_Hiearachy, TR.Episode_From, tr.Episode_To, tr.Title_Name
					--FROM #tempRights TR
					--INNER JOIN Acq_Deal_Rights_Ancillary ADRA ON ADRA.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code AND ADRA.Platform_Code IS NOT NULL
					--LEFT JOIN Platform P ON P.Platform_Code = ADRA.Platform_Code

					INSERT INTO #tblRightsPlatforms(Acq_Deal_Rights_Code, PlatformName)
					SELECT DISTINCT TR.Acq_Deal_Rights_Code, P.Platform_Hiearachy
					FROM #tempRights TR
					INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code

				END
				ELSE
				BEGIN
					--INSERT INTO @tblRights_New(Acq_Deal_Code, Acq_Deal_Rights_Code, Title_Code,Country, Dubbing, Subtitling, Territory , Right_Start_Date, Right_End_Date, [Sub-Licensing], Exclusive, Term, [Platform], Episode_From, Episode_To, Title_Name)
					--EXEC ('SELECT DISTINCT TR.Acq_Deal_Code,TR.Acq_Deal_Rights_Code, TR.Title_Code, TR.Country, TR.Dubbing, TR.Subtitling, TR.Territory ,TR.Right_Start_Date, TR.Right_End_Date, TR.[Sub-Licensing],TR.Exclusive,TR.Term ,P.Platform_Hiearachy, TR.Episode_From, tr.Episode_To	, tr.Title_Name		
					--FROM #tempRights TR
					--INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					--LEFT JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
					--WHERE ADRP.Platform_Code '+@PlatformCriteria+'
					--UNION ALL 
					--SELECT DISTINCT TR.Acq_Deal_Code,TR.Acq_Deal_Rights_Code, TR.Title_Code, TR.Country, TR.Dubbing, TR.Subtitling, TR.Territory, TR.Right_Start_Date, TR.Right_End_Date, TR.[Sub-Licensing], TR.Exclusive, TR.Term ,P.Platform_Hiearachy, TR.Episode_From, tr.Episode_To, tr.Title_Name
					--FROM #tempRights TR
					--INNER JOIN Acq_Deal_Rights_Ancillary ADRA ON ADRA.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code AND ADRA.Platform_Code IS NOT NULL
					--LEFT JOIN Platform P ON P.Platform_Code = ADRA.Platform_Code
					--WHERE ADRA.Platform_Code '+@PlatformCriteria+'')
					
					--INSERT INTO #tblRightsPlatforms(Acq_Deal_Rights_Code, PlatformName)
					--SELECT DISTINCT TR.Acq_Deal_Rights_Code, P.Platform_Hiearachy
					--FROM #tempRights TR
					--INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					--INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
				
					INSERT INTO #tblRightsPlatforms(Acq_Deal_Rights_Code, PlatformName)
					EXEC('SELECT DISTINCT TR.Acq_Deal_Rights_Code, P.Platform_Hiearachy
					FROM #tempRights TR
					INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
					WHERE ADRP.Platform_Code '+@PlatformCriteria+'
					AND TR.Acq_Deal_Rights_Code NOT IN (SELECT DISTINCT Acq_Deal_Rights_Code FROM #tblORRightCode)')

					print 'SELECT DISTINCT TR.Acq_Deal_Rights_Code, P.Platform_Hiearachy
					FROM #tempRights TR
					INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
					WHERE ADRP.Platform_Code '+@PlatformCriteria+'
					AND TR.Acq_Deal_Rights_Code NOT IN (SELECT DISTINCT Acq_Deal_Rights_Code FROM #tblORRightCode)'
					INSERT INTO #tblRightsPlatforms(Acq_Deal_Rights_Code, PlatformName)
					SELECT DISTINCT TR.Acq_Deal_Rights_Code, P.Platform_Hiearachy
					FROM #tempRights TR 
					INNER JOIN #tblORRightCode TORC ON TORC.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code

					--INSERT INTO #tblRightsPlatforms(Acq_Deal_Rights_Code, PlatformName)
					--SELECT DISTINCT TR.Acq_Deal_Rights_Code, P.Platform_Hiearachy
					--FROM #tempRights TR 
					--	INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
					--	INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
					--WHERE TR.Acq_Deal_Rights_Code NOT IN (SELECT DISTINCT Acq_Deal_Rights_Code FROM #tblRightsPlatforms )

				END
				------------------------------------------------------------------
				--DELETE FROM #tempRights WHERE Acq_Deal_Rights_Code NOT IN (
				--	SELECT DISTINCT Acq_Deal_Rights_Code FROM #tblRightsPlatforms 
				--)
				-----------------------------------------------------

			END
		END
	
		BEGIN
			IF (UPPER(@OutputColsNames) =  'YEAR OF RELEASE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Year_of_Release [Year of Release]'

				Update tt SET tt.Year_Of_Release = ''
				FROM #tempTitle tt
				WHERE tt.Year_Of_Release IS NULL
			END
		
			IF (UPPER(@OutputColsNames) =  'DIRECTOR')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Director [Director]'
		
				UPDATE #tempTitle SET Director = DBO.UFN_Get_Title_Metadata_By_Role_Code(Title_Code, 1)
			END
		
			IF (UPPER(@OutputColsNames) =  'STAR CAST')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Star_Cast [Star Cast]'
		
				UPDATE #tempTitle SET Star_Cast = DBO.UFN_Get_Title_Metadata_By_Role_Code(Title_Code, 2)
			END
		
			IF (UPPER(@OutputColsNames) =  'GENRE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Genre [Genre]'
		
				UPDATE #tempTitle SET Genre = DBO.UFN_Get_Title_Genre(Title_Code)
			END
		
			IF (UPPER(@OutputColsNames) =  'TITLE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Title_Name [Title]'

				UPDATE tt SET tt.Title = t.Title_Name
				FROM #tempTitle tt
				INNER JOIN Title t ON t.Title_COde = tt.Title_Code
			
				UPDATE TR SET TR.Title_Name = T.Title_Name
				FROM  #tempRights TR
				INNER JOIN Acq_Deal AD on AD.Acq_Deal_Code = TR.Acq_Deal_code
				inner join Title T on T.title_code = tr.title_Code
				
				UPDATE TR SET TR.Title_Name =  T.Title_Name + ' ( '+ CAST(TR.Episode_From AS VARCHAR)+' - '+ CAST(TR.Episode_To AS VARCHAR) +' )'
				FROM  #tempRights TR
				INNER JOIN Acq_Deal AD on AD.Acq_Deal_Code = TR.Acq_Deal_code
				inner join Title T on T.title_code = tr.title_Code
				WHERE ad.Deal_Type_Code IN (11,32,22)
				--WHERE ad.Deal_Type_Code NOT IN (1,27)
				
			END

			IF (UPPER(@OutputColsNames) =  'Original/Dubbed')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Original_Dubbed [Original/Dubbed]'
		
			END

			IF (UPPER(@OutputColsNames) =  'ORIGINAL TITLE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Original_Title [Original Title]'
		
				UPDATE tt SET tt.Original_Title = CASE WHEN t.Original_Title IS NULL THEN '' ELSE t.Original_Title END
				FROM #tempTitle tt
				LEFT JOIN Title t ON t.Title_Code = tt.Title_Code
			END
		END
	
		BEGIN
			IF (UPPER(@OutputColsNames) =  'AGREEMENT NO')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Agreement_No [Agreement No]'
				
				
			END
		
			IF (UPPER(@OutputColsNames) =  'DEAL DESCRIPTION')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Description [Deal Description]'
				
			END
		
			IF (UPPER(@OutputColsNames) =  'AGREEMENT DATE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'CONVERT(VARCHAR(11),td.Agreement_Date,103) [Agreement Date]'
				
			END
		
			IF (UPPER(@OutputColsNames) =  'BUSINESS UNIT')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Business_Unit [Business Unit]'
		
				UPDATE td SET td.Business_Unit = bu.Business_Unit_Name
				from #tempDeal td
				INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = td.Acq_Deal_Code
				INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
			END
		
			IF (UPPER(@OutputColsNames) =  'CURRENCY')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Currency [Currency]'
				
		
				UPDATE td SET td.Currency = c.Currency_Name
				from #tempDeal td
				INNER JOIN Currency c ON c.Currency_Code = td.Currency_Code
			END

			IF (UPPER(@OutputColsNames) =  'DUE DILIGENCE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Due_Diligence [Due_Diligence]'
				
				UPDATE TD SET TD.Due_Diligence = 
				CASE 
					WHEN TD.Due_Diligence = 'Y' THEN 'Yes'
					WHEN TD.Due_Diligence IS NULL THEN ''
					ELSE 'No'
				END 
				FROM  #tempDeal TD
				print 'end due'
			END
		
			IF (UPPER(@OutputColsNames) =  'DEAL CATEGORY')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Category [Deal Category]'
				
				UPDATE td SET td.Deal_Category = c.Category_Name
				from #tempDeal td
				INNER JOIN Category c ON c.Category_Code = td.Deal_Category_Code

				--UPDATE td SET td.Deal_Category = DC.Role_Name
				--from #tempDeal td
				--INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = td.Acq_Deal_Code
				--INNER JOIN Role DC on AD.Role_Code = DC.Role_Code

			END
		
			IF (UPPER(@OutputColsNames) =  'STATUS')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Status [Status]'
			
				UPDATE td SET td.Status = dt.Deal_Tag_Description
				from #tempDeal td
				INNER JOIN Deal_Tag dt ON dt.Deal_Tag_Code = td.Deal_Tag_Code
			
			END
		
			IF (UPPER(@OutputColsNames) =  'DEAL WORKFLOW STATUS')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Workflow_Status [Deal Workflow Status]'
		
				UPDATE td SET td.Deal_Workflow_Status = dws.Deal_Workflow_Status_Name
				from #tempDeal td
				INNER JOIN Deal_Workflow_Status dws ON dws.Deal_WorkflowFlag COLLATE DATABASE_DEFAULT = td.Deal_Workflow_Status COLLATE DATABASE_DEFAULT-- AND dws.Deal_Type = 'A' 
			END

			IF (UPPER(@OutputColsNames) =  'SELF UTILIZATION GROUP')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Promoter_Group_Name [Self Utilization Group]'

				UPDATE TR SET TR.Promoter_Group_Name = ''
				FROM #tempRights TR
				WHERE TR.Promoter_Group_Name IS NULL
			END

			IF (UPPER(@OutputColsNames) =  'SELF UTILIZATION REMARKS')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Promoter_Remark_Desc [Self Utilization Remarks]'

				UPDATE TR SET TR.Promoter_Remark_Desc = ''
				FROM #tempRights TR
				WHERE TR.Promoter_Remark_Desc IS NULL
			END

			IF (UPPER(@OutputColsNames) =  'HOLDBACK')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Is_Holdback [Holdback]'

				UPDATE tr SET tr.Is_Holdback = 
				CASE 
					WHEN tr.Is_Holdback = 'Y' THEN 'Yes'
					WHEN tr.Is_Holdback IS NULL THEN ''
					ELSE 'No'
				END 
				FROM #tempRights tr

			END

			IF (UPPER(@OutputColsNames) =  'RESTRICTION REMARKS')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Restriction_Remarks [Restriction Remarks]'

				UPDATE tr SET tr.Restriction_Remarks = ''
				from #tempRights tr
				WHERE tr.Restriction_Remarks IS NULL
			END

			IF (UPPER(@OutputColsNames) =  'VARIABLE COST')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Variable_Cost_Type [Variable Cost]'
			END

			IF (UPPER(@OutputColsNames) =  'ROFR')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Is_ROFR [ROFR]'

				UPDATE tr SET tr.IS_ROFR = 
				CASE 
					WHEN tr.IS_ROFR = 'Y' THEN 'Yes' 
					WHEN tr.IS_ROFR = 'N' THEN 'No'
					WHEN tr.IS_ROFR IS NULL THEN ''
				END
				FROM #tempRights tr

			END
		
			IF (UPPER(@OutputColsNames) =  'DEAL TYPE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Type [Deal Type]'
			
				UPDATE td SET td.Deal_Type = dt.Deal_Type_Name
				from #tempDeal td
				INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = td.Deal_Type_Code	
			END

			IF (UPPER(@OutputColsNames) =  'MODE OF ACQUISITION')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Role_Name [Mode Of Acquisition]'
			
				UPDATE td SET td.Role_Name = dt.Role_Name
				from #tempDeal td
				INNER JOIN Role dt ON dt.Role_Code = td.Mode_Of_Acquisition	
			END

			IF (UPPER(@OutputColsNames) =  'CBFC RATING')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tt.Column_Value [CBFC Rating]'

				UPDATE tt SET tt.Column_Value = CASE WHEN tt.CBFC_Rating IS NULL THEN ' ' ELSE ecv.Columns_Value END
				From #tempTitle tt
				LEFT JOIN Extended_Columns_Value ecv ON ecv.Columns_Value_Code = tt.CBFC_Rating

			END
			
			IF (UPPER(@OutputColsNames) =  'MILESTONE')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'tr.Milestone_Type_Name [Milestone]'
			
				UPDATE tr SET tr.Milestone_Type_Name = 
				CASE
					WHEN mt.Milestone_Type_Code IS NULL THEN '' ELSE mt.Milestone_Type_Name
				END
				from #tempRights tr
				LEFT JOIN Milestone_Type mt ON mt.Milestone_Type_Code = tr.Milestone_Type_Code
				
			END

			IF (UPPER(@OutputColsNames) =  'ENTITY')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Entity [Entity]'
			
				UPDATE td SET td.Entity = e.Entity_Name
				FROM #tempDeal td
				INNER JOIN Entity e ON e.Entity_Code = td.Entity_Code
			END
		
			IF (UPPER(@OutputColsNames) =  'LICENSOR')
			BEGIN	
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Licensor [Licensor]'
			
				UPDATE td SET td.Licensor = v.Vendor_Name
				FROM #tempDeal td
				INNER JOIN Vendor v ON v.Vendor_Code = td.Vendor_Code
			END

			IF (UPPER(@OutputColsNames) =  'Revenue Vertical')
			BEGIN	
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Revenue_Vertical_Name [Revenue Vertical]'
			
				UPDATE td SET td.Revenue_Vertical_Name = RV.Revenue_Vertical_Name
				FROM #tempDeal td
				INNER JOIN Revenue_Vertical RV ON RV.Revenue_Vertical_Code = td.Revenue_Vertical_Code
			END

			IF (UPPER(@OutputColsNames) =  'Deal Segment')
			BEGIN	
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'td.Deal_Segment_Name [Deal Segment]'
			
				UPDATE td SET td.Deal_Segment_Name = DS.Deal_Segment_Name
				FROM #tempDeal td
				INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = td.Deal_Segment_Code
			END
		END
	
		BEGIN
			IF (UPPER(@OutputColsNames) =  'CHANNEL')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'trd.Channel [Channel]'
	
				UPDATE trd SET trd.Channel =  STUFF(
					(  SELECT Distinct ', '+ c.Channel_Name
							FROM Acq_Deal_Run_Channel adrc
							INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Run_Code = Adrc.Acq_Deal_Run_Code
							INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adr.Acq_Deal_Run_Code
							INNER JOIN Channel c ON c.Channel_Code = adrc.Channel_Code
							WHERE adr.Acq_Deal_Code = trd.Acq_Deal_Code AND adrt.Title_Code = trd.Title_Code
					FOR XML PATH('')), 1, 1, '')
				from #tempRunDef trd

				UPDATE trd SET trd.Channel = ''
				FROM #tempRunDef trd 
				WHERE trd.Channel IS NULL
			END
	
			IF (UPPER(@OutputColsNames) =  'RUN LIMITATION')
			BEGIN
				Print 'Executing Column ->' + @OutputColsNames
				Print convert(varchar, getdate(), 114)
				IF(@TableColumns <> '')
					SET @TableColumns = @TableColumns + ', '
				SET @TableColumns = @TableColumns + 'trd.Run_Limitation [Run Limitation]'
	
				UPDATE trd SET trd.Run_Limitation = 
				CASE 
					WHEN adr.Run_Type = 'U' THEN 'Unlimited' 
					WHEN adr.Run_Type IS NULL THEN ''
					ELSE 'Limited'
				END
				from #tempRunDef trd
				LEFT JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Code = trd.Acq_Deal_Code
				LEFT JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adr.Acq_Deal_Run_Code AND adrt.Title_Code = trd.Title_Code
			END
		END
	
	    SET @Counter  = @Counter  + 1
	END

	IF((SELECT COUNT(*) from #Temp_ColNames WHERE ColNames = 'PLATFORM') > 0)
	BEGIN

			EXEC ('	INSERT INTO #tempOutput( '+@OutputCols+')
				SELECT '+@UnionColumns+'
				UNION ALL
				Select Distinct '+@TableColumns+' FROM #tempTitle tt
				INNER JOIN #tempRights tr ON tr.Title_Code = tt.Title_Code
				INNER JOIN #tblRightsPlatforms trp ON tr.Acq_Deal_Rights_Code = trp.Acq_Deal_Rights_Code
				INNER JOIN #tempDeal td ON td.Acq_Deal_Code = tr.Acq_Deal_Code
				INNER JOIN #tempRunDef trd ON trd.Acq_Deal_Code = td.Acq_Deal_Code AND trd.Title_Code = tr.Title_Code
				 ')

	END
	ELSE
	BEGIN

		EXEC ('	INSERT INTO #tempOutput( '+@OutputCols+')
				SELECT '+@UnionColumns+'
				UNION ALL
				Select Distinct '+@TableColumns+' FROM #tempTitle tt
				INNER JOIN #tempRights tr ON tr.Title_Code = tt.Title_Code
				INNER JOIN #tempDeal td ON td.Acq_Deal_Code = tr.Acq_Deal_Code
				INNER JOIN #tempRunDef trd ON trd.Acq_Deal_Code = td.Acq_Deal_Code AND trd.Title_Code = tr.Title_Code
				 ')
	END

	--EXEC ('SELECT '+@OutputCols+' FROM #tempOutput')
	
	DECLARE @ColumnOne VARCHAR(MAX) = ''

	SELECT  @ColumnOne = number FROM DBO.FN_SPLIT_WITHDELEMITER(@ColNames,',')  WHERE id = 1

	EXEC('	SELECT TOP 1 '+@OutputCols+'  FROM #tempOutput   WHERE COL1 = '''+@ColumnOne+'''
			UNION ALL
			SELECT '+@OutputCols+' FROM #tempOutput WHERE COL1 <> '''+@ColumnOne+'''')

	IF(OBJECT_ID('tempdb..#buwiseacq_deal_code') IS NOT NULL) DROP TABLE #buwiseacq_deal_code
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
	IF(OBJECT_ID('tempdb..#tblRights_NewHoldback') IS NOT NULL) DROP TABLE #tblRights_NewHoldback
	IF(OBJECT_ID('tempdb..#tblRightsPlatforms') IS NOT NULL) DROP TABLE #tblRightsPlatforms
	IF(OBJECT_ID('tempdb..#RunDef_Junk') IS NOT NULL) DROP TABLE #RunDef_Junk
	IF(OBJECT_ID('tempdb..#tblORRightCode') IS NOT NULL) DROP TABLE #tblORRightCode

	
END