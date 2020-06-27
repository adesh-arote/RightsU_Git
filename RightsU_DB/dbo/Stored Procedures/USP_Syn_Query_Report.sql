CREATE PROCEDURE [dbo].[USP_Syn_Query_Report]
	@Sql_SELECT VARCHAR(MAX),
	@Sql_WHERE NVARCHAR(MAX),
	@Column_Count INT,
	@Column_Names VARCHAR(MAX),
	@Report_Query_Code INT=0,
	@Subtitling_Codes VARCHAR(MAX),
	@Dubbing_Codes VARCHAR(MAX),
	@Country_Codes VARCHAR(MAX),
	@Category_Codes VARCHAR(MAX),
	@Is_Debug CHAR(1),
	@CBFCRating_Codes VARCHAR(MAX)
AS
BEGIN 
	--DECLARE @Sql_SELECT VARCHAR(MAX),
	--@Sql_WHERE VARCHAR(MAX),
	--@Column_Count INT,
	--@Column_Names VARCHAR(MAX),
	--@Report_Query_Code INT=0,
	--@Subtitling_Codes VARCHAR(MAX),
	--@Dubbing_Codes VARCHAR(MAX),
	--@Country_Codes VARCHAR(MAX),
	--@Is_Debug CHAR(1),
	--@Category_Codes VARCHAR(MAX),
	-- @CBFCRating_Codes VARCHAR(MAX)



	--SELECT @Sql_SELECT = 'Title_Name [Title], Agreement_No [Agreement No], Deal_Description [Deal Description], Deal_Tag_Description [Status], Original_Title [Original Title], Platform_Name [Platform], Vendor_Name [Licensee], CONVERT(VARCHAR,Actual_Right_Start_Date,103) [Right Start Date], CONVERT(VARCHAR,Actual_Right_End_Date,103) [Right End Date], Country_Name [Country], Director_Names_Comma_Seperate [Director], Star_Cast_Names_Comma_Seperate [Star Cast], Is_Holdback [Holdback], Currency_Name [Currency], Entity_Name [Entity], Subtitling_Languages [Subtitling], Dubbing_Languages [Dubbing], Variable_Cost_Type [Variable Cost], CONVERT(VARCHAR,ROFR,103) [ROFR], Restriction_Remarks [Restriction Remarks], Business_Unit_Name [Business Unit], CONVERT(VARCHAR,Agreement_Date,103) [Agreement Date], CONVERT(VARCHAR,Year_Of_Production,103) [Year of Release], Is_Exclusive [Exclusive], Territory_Name [Territory], Term [Term], Role_Name [Customer Type], Sub_Licensing [Sub-Licensing], Original_Dubbed [Original/Dubbed], Deal_Type_Name [Deal Type], Deal_Workflow_Status_Name [Deal Workflow Status], Sales_Agent [Sales Agent], Genre_Names_Comma_Seperate [Genre], Promoter_Group_Name [Self Utilization Group], Promoter_Remark_Desc [Self Utilization Remarks], Cat_Name [Deal Category], CBFC_Rating [CBFC Rating]',
	--@Sql_WHERE = ' AND (  P.Platform_Code  in  (''72'')) AND Business_Unit_Code = 1 AND Expired=''N'' AND Is_Theatrical_Right=''N''',
	--@Column_Count = 38,  
	--@Column_Names = 'Title,Agreement No,Deal Description,Status,Original Title,Platform,Licensee,Right Start Date,Right End Date,Country,Director,Star Cast,Holdback,Currency,Entity,Subtitling,Dubbing,Variable Cost,ROFR,Restriction Remarks,Business Unit,Agreement Date,Year of Release,Exclusive,Territory,Term,Customer Type,Sub-Licensing,Original/Dubbed,Deal Type,Deal Workflow Status,Sales Agent,Genre,Self Utilization Group,Self Utilization Remarks,Deal Category,CBFC Rating,',
	--@Subtitling_Codes = '',
	--@Dubbing_Codes = '',
	--@Country_Codes = '',
	--@Is_Debug = '',
	--@Category_Codes = '',
	--@CBFCRating_Codes = 'IN~7'

	-- AND (  SD.Deal_Workflow_Status  in  ('N'))  AND Business_Unit_Code = 1 AND Expired='N' AND Is_Theatrical_Right='N'

	--Hnadle for deal critical report aditya
	SELECT @Sql_SELECT = 'Cat_Name [CategoryName], '+ @Sql_SELECT
	--SELECT @Column_Count = @Column_Count+ 1
	SELECT @Column_Names = 'CategoryName,' + @Column_Names

	DECLARE @Counter INT 
	DECLARE @Country_Not_In_Where VARCHAR(2000) = '' , @Category_Not_In_Where VARCHAR(2000) = '', @CBFCRating_Not_In_Where  VARCHAR(2000) = ''
	SET @Counter=2  /* set counter = 2 bcoz we are already creating temp table with single column */ 
	DECLARE @Script_Alter_TempTable VARCHAR(MAX)

	/* Create temp table with single column */

	CREATE TABLE #TEMPVIEW(COL1 NVARCHAR(MAX))
	
	IF(@Report_Query_Code>0)
	BEGIN
		SELECT @Column_Count=COUNT(RC.Column_Code)
		FROM Report_Column RC
		INNER JOIN Report_Column_Setup RCS ON RC.Column_Code=RCS.Column_Code
		WHERE RC.Query_Code=@Report_Query_Code AND Is_Select='Y'
	END
	
	/* Alter temp table and add more column (like col1, col2, col3) */
	IF(@Column_Count > 1 )  
	BEGIN  
		SET @Script_Alter_TempTable = 'ALTER TABLE #TEMPVIEW ADD'  
		
		WHILE(@Counter <= @Column_Count)  
		BEGIN  
			SET @Script_Alter_TempTable += ' COL' + CAST(@counter AS NVARCHAR(100)) + ' NVARCHAR(MAX) NULL'  
			
			IF(@Counter <> @Column_Count)
				SET @Script_Alter_TempTable += ','

			SET @Counter += 1
		END
		
		IF(@Is_Debug = 'Y')
			PRINT 'Script of Alter TempTable :- ' + @Script_Alter_TempTable 
		
		EXEC (@Script_Alter_TempTable)  
	END

	/* Create SQL for Insert actual column name in first row */
	DECLARE @Script_Insert_Column_Names VARCHAR(MAX)  
	SET @Script_Insert_Column_Names = 'INSERT INTO #TEMPVIEW SELECT '


	IF(@Report_Query_Code>0)
	BEGIN
			SELECT @Column_Names = STUFF(
			(  
				SELECT ',' + A.Display_Name 
				FROM (
					SELECT RCS.Display_Name,Sort_Ord
					FROM Report_Column RC
					INNER JOIN Report_Column_Setup RCS ON RC.Column_Code=RCS.Column_Code
					where RC.Query_Code=@Report_Query_Code and Is_Select='Y'
				) A order by Sort_Ord	
			FOR XML PATH('')), 1, 1, '') + ','
		 	
		SET @Column_Names = LEFT(@Column_Names,LEN(@Column_Names)-1)  
		SELECT @Script_Insert_Column_Names = @Script_Insert_Column_Names + ' ''' + CONVERT(NVARCHAR(100),NUMBER) + ''',' FROM DBO.FN_SPLIT_WITHDELEMITER(@Column_Names,',')    
	END
	ELSE BEGIN
		SET @Column_Names = LEFT(@Column_Names,LEN(@Column_Names)-1)  
		SELECT @Script_Insert_Column_Names = @Script_Insert_Column_Names + ' ''' + CONVERT(NVARCHAR(100),NUMBER) + ''',' FROM DBO.FN_SPLIT_WITHDELEMITER(@Column_Names,',')    
	END

	SET @Script_Insert_Column_Names = LEFT(@Script_Insert_Column_Names,LEN(@Script_Insert_Column_Names)-1)  
	
	/* Execute SQL for Insert actual column name in first row */
	PRINT 'Script of Insert Column Names in TempTable :- ' + @Script_Insert_Column_Names
	EXEC (@Script_Insert_Column_Names)  

	Set @Subtitling_Codes = IsNull(@Subtitling_Codes, '')
	Set @Dubbing_Codes = IsNull(@Dubbing_Codes, '')
	Set @Country_Codes = IsNull(@Country_Codes, '')
	Set @Category_Codes = IsNull(@Category_Codes, '')

	Declare @RightsSql Varchar(Max) = '', @InNotIn Varchar(20) = ''

	Set @RightsSql = 'SELECT 
		CASE LEN(Subtitling_Lang) WHEN 0 THEN ''No'' ELSE Subtitling_Lang END AS Subtitling_Languages,
		CASE LEN(Dubbing_Lang) WHEN 0 THEN ''No'' ELSE Dubbing_Lang END AS Dubbing_Languages, 
		CASE LEN(Countries) WHEN 0 THEN ''No'' ELSE Countries END AS Country_Name, 
		CASE LEN(Territories) WHEN 0 THEN ''No'' ELSE Territories END AS Territory_Name, *
		INTO #Syn_Deal_Rights
		FROM
		(
			SELECT SDR.*,
			DBO.UFN_Get_Rights_Subtitling(Syn_Deal_Rights_Code, ''S'') AS Subtitling_Lang, 
			DBO.UFN_Get_Rights_Dubbing(Syn_Deal_Rights_Code, ''S'') AS Dubbing_Lang,
			DBO.UFN_Get_Rights_Country_Query(Syn_Deal_Rights_Code, ''S'') AS Countries,
			DBO.UFN_Get_Rights_Territory(Syn_Deal_Rights_Code, ''S'') AS Territories,
			CASE WHEN (GETDATE() > Right_END_date) THEN ''Y'' ELSE ''N'' END AS Expired,
			CASE Is_Exclusive WHEN ''Y'' THEN ''Yes'' ELSE ''No'' END AS Exclusive,
			CASE
				WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback SDRH WHERE SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' 
			END AS Is_Holdback ,	
			CASE Right_Type
			   WHEN ''Y'' THEN [dbo].[UFN_Get_Rights_Term](SDR.Actual_Right_Start_Date, SDR.Actual_Right_END_Date, Term) 
			   WHEN ''M'' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
			   WHEN ''U'' THEN ''Perpetuity''
			END AS Deal_Term,
			CASE SDR.Is_ROFR WHEN ''Y'' THEN CONVERT(VARCHAR,SDR.ROFR_Date,103) ELSE ''No'' END AS ROFR
			FROM Syn_Deal_Rights SDR Where 1=1 {SQLSUB}{SQLDUB}{SQLCOUN} 
			AND ISNULL(SDR.Right_Status, '''') = ''C''
		) AS A
		'
		--Print 'sql1'
	If(@Subtitling_Codes <> '')
	Begin
		--Select * From @InNotIn
		Select @InNotIn = number From DBO.fn_Split_withdelemiter(@Subtitling_Codes, '~') Where Id=1
		Select @Subtitling_Codes = number From DBO.fn_Split_withdelemiter(@Subtitling_Codes, '~') Where Id=2
		Declare @SubTit Varchar(5000) = ' And Syn_Deal_Rights_Code In (Select Syn_Deal_Rights_Code From Syn_Deal_Rights_Subtitling Where Syn_Deal_Rights_Code Is Not Null And Language_Code ' + @InNotIn + ' (
				Select number From DBO.fn_Split_withdelemiter(''' + @Subtitling_Codes + ''', '','') Where number <> ''''
			))'
		Set @RightsSql = Replace(@RightsSql, '{SQLSUB}', @SubTit)
	End
	
	if(@Dubbing_Codes <> '')
	Begin
		Select @InNotIn = number From DBO.fn_Split_withdelemiter(@Dubbing_Codes, '~') Where Id=1
		Select @Dubbing_Codes = number From DBO.fn_Split_withdelemiter(@Dubbing_Codes, '~') Where Id=2
		Declare @Dubb Varchar(5000) = ' And Syn_Deal_Rights_Code In (Select Syn_Deal_Rights_Code From Syn_Deal_Rights_Dubbing Where Syn_Deal_Rights_Code Is Not Null And Language_Code ' + @InNotIn + ' (
				Select number From DBO.fn_Split_withdelemiter(''' + @Dubbing_Codes + ''', '','') Where number <> '',''
			))'
		Set @RightsSql = Replace(@RightsSql, '{SQLDUB}', @Dubb)
	End
	
	if(@Country_Codes <> '')
	Begin
		Select @InNotIn = number From DBO.fn_Split_withdelemiter(@Country_Codes, '~') Where Id=1
		Select @Country_Codes = number From DBO.fn_Split_withdelemiter(@Country_Codes, '~') Where Id=2
		IF(LTRIM(RTRIM(UPPER(@InNotIn))) ='NOT IN')
		BEGIN			
			SET @Country_Not_In_Where=' AND SDM.Title_Code NOT IN
										(											
											SELECT SADRT.Title_Code FROM Syn_Deal_Rights_Title SADRT WHERE SADRT.Syn_Deal_Rights_Code IN
											(
												SELECT ISDRT.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Territory ISDRT 
												WHERE ISDRT.Country_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Country_Codes + ''', '','') 
												WHERE number <> '','') AND ISDRT.Territory_Type=''I''
												OR
												(
													Territory_Code in 
													(
														SELECT  Territory_Code FROM Territory_Details WHERE 
														Country_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Country_Codes + ''', '','') 
														WHERE number <> '','') AND Territory_Type=''G''
													)
												)
											)
										)'
		END
		ELSE
		BEGIN
		Declare @Count NVARCHAR(MAX) = ' And Syn_Deal_Rights_Code In (Select Syn_Deal_Rights_Code From Syn_Deal_Rights_Territory Where Syn_Deal_Rights_Code Is Not Null 
		And (( 
				Country_Code ' + @InNotIn + ' (Select number From DBO.fn_Split_withdelemiter(''' + @Country_Codes + ''', '','') Where number <> '','')
				AND Territory_Type=''I''
				)
		OR 
			(
				Territory_Code in (SELECT  Territory_Code FROM Territory_Details WHERE 
				Country_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Country_Codes + ''', '','') WHERE number <> '',''))  
				AND Territory_Type=''G''
			))
		)'
		Set @RightsSql = Replace(@RightsSql, '{SQLCOUN}', @Count)
		END
	End

	IF(@Category_Codes <> '')
	BEGIN
		SELECT @InNotIn = number FROM DBO.fn_Split_withdelemiter(@Category_Codes, '~') WHERE Id=1
		SELECT @Category_Codes = number FROM DBO.fn_Split_withdelemiter(@Category_Codes, '~') WHERE Id=2
		
		SET @Category_Not_In_Where=' AND SD.Cat_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter
			(''' + @Category_Codes + ''', '','') WHERE number <> '','') '
		
	END

	Set @RightsSql = Replace(@RightsSql, '{SQLSUB}', '')
	Set @RightsSql = Replace(@RightsSql, '{SQLDUB}', '')
	Set @RightsSql = Replace(@RightsSql, '{SQLCOUN}', '')

		--Print 'sql2'
	--DECLARE @Sql_Query NVARCHAR(MAX) = ''

	DECLARE @Sql_Query NVARCHAR(MAX) = @RightsSql
	DECLARE @Sql_Query_1 NVARCHAR(MAX) = ''
	DECLARE @Sql_Query_2 NVARCHAR(MAX) = ''
	DECLARE @Sql_Query_3 NVARCHAR(MAX) = ''
	DECLARE @Sql_Query_4 NVARCHAR(MAX) = ''

	DECLARE @CBFCRating_InNotIn NVARCHAR(MAX) = ' IN ',  @LogicalConnect NVARCHAR(MAX) = ' AND '

	IF(@CBFCRating_Codes = '')
	BEGIN
			SELECT @CBFCRating_Codes = '0,' + STUFF((SELECT DISTINCT ',' +  CAST(Columns_Value_Code AS NVARCHAR) 
			FROM Extended_Columns_Value where Columns_Code in (SELECT Columns_Code FROM  Extended_Columns WHERE Columns_Name = 'CBFC Rating')
			FOR XML PATH('')),1,1,'')

			SET @CBFCRating_Not_In_Where=  'IN  ('+ @CBFCRating_Codes +') '
	END
	ELSE IF (@CBFCRating_Codes <> '')
	BEGIN
			SELECT @LogicalConnect = number FROM DBO.fn_Split_withdelemiter(@CBFCRating_Codes, '~') WHERE Id=1
			SELECT @CBFCRating_InNotIn = number FROM DBO.fn_Split_withdelemiter(@CBFCRating_Codes, '~') WHERE Id=2
			SELECT @CBFCRating_Codes = number FROM DBO.fn_Split_withdelemiter(@CBFCRating_Codes, '~') WHERE Id=3
		
			SET @CBFCRating_Not_In_Where= ' IN ('+ @CBFCRating_Codes +') '
	END

	--print 'sql 3'
	SET @Sql_Query_1 = '	

	SELECT DISTINCT T.Title_Code
	INTO #Filtered_Title 
	FROM Title T 
		LEFT JOIN Map_Extended_Columns MEC ON MEC.Record_Code = T.Title_Code and MEC.Columns_Code in (select Columns_Code from  Extended_Columns where Columns_Name = ''CBFC Rating'')
		LEFT JOIN Map_Extended_Columns_Details MECD ON MECD.Map_Extended_Columns_Code = MEC.Map_Extended_Columns_Code 
		LEFT JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MECD.Columns_Value_Code
	WHERE IsNull(T.Reference_Flag, '''') <> ''T''
	AND ISNULL(MECD.Columns_Value_Code,0) '+ @CBFCRating_Not_In_Where + ' 

	
	SELECT T.Title_Code, T.Original_Title, T.Title_Name, T.Year_Of_Production, DBO.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) AS Director_Names_Comma_Seperate, 
		DBO.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) AS Star_Cast_Names_Comma_Seperate
		, DBO.UFN_Get_Title_Genre(T.Title_Code) AS Genre_Names_Comma_Seperate
		--,0 AS Genres_Code
		, 0 AS Director_Code
		, 0 AS Start_Cast_Code, dbo.UFN_Get_Title_Original_Or_Dubbed(T.Title_Code) AS Original_Dubbed
		, STUFF((SELECT DISTINCT '','' + CAST(ECV.Columns_Value AS NVARCHAR) 
			FROM title Tit  
			LEFT JOIN Map_Extended_Columns MEC ON MEC.Record_Code = Tit.Title_Code and MEC.Columns_Code in (select Columns_Code from  Extended_Columns where Columns_Name = ''CBFC Rating'')
			LEFT JOIN Map_Extended_Columns_Details MECD ON MECD.Map_Extended_Columns_Code = MEC.Map_Extended_Columns_Code 
			LEFT JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MECD.Columns_Value_Code
			WHERE Tit.Title_Code =  T.Title_Code
		FOR XML PATH('''')),1,1,'''') AS ''CBFC_Rating''
		INTO #TmpTitle 
	FROM Title T 
	WHERE IsNull(T.Reference_Flag, '''') <> ''T'' 
	'+@LogicalConnect+' T.Title_Code '+ @CBFCRating_InNotIn +' ( SELECT Title_Code FROM #Filtered_Title)

	SELECT SD.Syn_Deal_Code, SD.Vendor_Code, V.Vendor_Name, SD.Currency_Code, CUR.Currency_Name, SD.Entity_Code, E.Entity_Name,SD.Deal_Type_Code,
	SD.Agreement_No, SD.Agreement_Date, SD.Deal_Description, SD.Deal_Tag_Code, DT.Deal_Tag_Description, SD.Business_Unit_Code, 
	BU.Business_Unit_Name, RO.Role_Code,RO.Role_Name, dbo.UFN_GetDealTypeCondition(SD.Deal_Type_Code) As DEAL_TYPE_NAMES,
	SDT.Deal_Type_Name,SD.Deal_Workflow_Status,SD.Sales_Agent_Code,

	TA.Title_Name AS Alternate_Title_Name,
	TA.Original_Title AS Alternate_Original_Title,
	LG.Language_Name AS Alternate_Language,
	GN.Genres_Name AS Alternate_Genres_Name,
	TALENT_Dir.Talent_Name AS Title_Director,
	TALENT_SC.Talent_Name AS Title_Star_Cast,
	Spa_TA.Title_Name AS Spanish_Title_Name,
	Spa_TA.Original_Title AS Spanish_Original_Title,
	Spa_LG.Language_Name AS Spanish_Language,
	Spa_GN.Genres_Name AS Spanish_Genres_Name,
	Spa_TALENT_Dir.Talent_Name AS Spanish_Director,
	Spa_TALENT_SC.Talent_Name AS Spanish_Star_Cast,
	T.Title_Code,
	SD.Category_Code AS Cat_Code,
	C.Category_Name AS Cat_Name

	INTO #TmpDeal
	FROM Syn_Deal SD
	INNER JOIN Vendor V ON V.Vendor_Code = SD.Vendor_Code
	INNER JOIN Deal_Type SDT ON SDT.Deal_Type_Code = SD.Deal_Type_Code
	INNER JOIN Currency CUR ON CUR.Currency_Code = SD.Currency_Code
	INNER JOIN Entity E ON E.Entity_Code = SD.Entity_Code
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
	INNER JOIN Deal_Tag DT ON DT.Deal_Tag_Code = SD.Deal_Tag_Code
	INNER JOIN Role RO on SD.Customer_Type = RO.Role_Code

	INNER JOIN Syn_Deal_Movie SDM ON SDM.Syn_Deal_Code = SD.Syn_Deal_Code
	INNER JOIN Title T ON T.Title_Code = SDM.Title_Code
	INNER JOIN Category C ON C.Category_Code = SD.Category_Code
	LEFT JOIN Title_Alternate TA ON TA.Title_Code = T.Title_Code AND TA.Alternate_Config_Code = 1
	LEFT JOIN LANGUAGE LG ON LG.Language_Code = TA.Title_Language_Code 
	LEFT JOIN Title_Alternate_Genres TAG ON TAG.Title_Alternate_Code= TA.Title_Alternate_Code 
	LEFT JOIN Genres GN ON GN.Genres_Code = TAG.Genres_Code 
	LEFT JOIN Title_Alternate_Talent TAT_Dir ON TAT_Dir.Title_Alternate_Code = TA.Title_Alternate_Code AND TAT_Dir.Role_Code = 1
	LEFT JOIN Talent TALENT_Dir ON TALENT_Dir.Talent_Code = TAT_Dir.Talent_Code
	LEFT JOIN Title_Alternate_Talent TAT_SC ON TAT_SC.Title_Alternate_Code = TA.Title_Alternate_Code AND TAT_SC.Role_Code = 2
	LEFT JOIN Talent TALENT_SC ON TALENT_SC.Talent_Code = TAT_SC.Talent_Code
	LEFT JOIN Title_Alternate Spa_TA ON Spa_TA.Title_Code = T.Title_Code AND Spa_TA.Alternate_Config_Code = 2
	LEFT JOIN LANGUAGE Spa_LG ON Spa_LG.Language_Code = Spa_TA.Title_Language_Code 
	LEFT JOIN Title_Alternate_Genres Spa_TAG ON Spa_TAG.Title_Alternate_Code= Spa_TA.Title_Alternate_Code 
	LEFT JOIN Genres Spa_GN ON Spa_GN.Genres_Code = Spa_TAG.Genres_Code 
	LEFT JOIN Title_Alternate_Talent Spa_TAT_Dir ON Spa_TAT_Dir.Title_Alternate_Code = Spa_TA.Title_Alternate_Code AND Spa_TAT_Dir.Role_Code = 1
	LEFT JOIN Talent Spa_TALENT_Dir ON Spa_TALENT_Dir.Talent_Code = Spa_TAT_Dir.Talent_Code
	LEFT JOIN Title_Alternate_Talent Spa_TAT_SC ON Spa_TAT_SC.Title_Alternate_Code = Spa_TA.Title_Alternate_Code AND Spa_TAT_SC.Role_Code = 2
	LEFT JOIN Talent Spa_TALENT_SC ON Spa_TALENT_SC.Talent_Code = Spa_TAT_SC.Talent_Code;'
	
	SET @Sql_Query_2 = ' 

	SELECT DISTINCT tit.Title_Code, tit.Original_Title, 	
	DBO.UFN_GetTitleNameInFormat(DEAL_TYPE_NAMES, tit.Title_Name, SDRT.Episode_From, SDRT.Episode_To) AS Title_Name,
	tit.Year_Of_Production, SDM.No_Of_Episode, 
	P.Platform_Code, SDR.Syn_Deal_Rights_Code,
	SD.Vendor_Code, SD.Vendor_Name, SD.Role_Name,
	tit.Director_Code, tit.Director_Names_Comma_Seperate, 
	tit.Start_Cast_Code, tit.Star_Cast_Names_Comma_Seperate,tit.Genre_Names_Comma_Seperate,
	--tit.Genres_Code,
	tit.Original_Dubbed,
	CASE tit.Original_Dubbed WHEN ''Original'' THEN ''O'' ELSE ''D'' END AS Orig_Dub,
	SDR.Actual_Right_Start_Date AS Actual_Right_Start_Date, SDR.Actual_Right_End_Date AS Actual_Right_End_Date, 
	SDR.Exclusive AS Is_Exclusive,SDR.Restriction_Remarks,SDR.Expired,
	0 Country_Code, SDR.Country_Name, SDR.Territory_Name,
	CASE Is_Holdback WHEN ''Y'' THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
	SD.Currency_Code, SD.Currency_Name, SD.Entity_Code, SD.Entity_Name, 
	SDC.Deal_Cost, 
	CASE
		WHEN SDC.Variable_Cost_Type = ''P'' THEN ''Profit-Sharing''
		WHEN SDC.Variable_Cost_Type = ''R'' THEN ''Revenue-Sharing''
		ELSE ''NA''
	END AS Variable_Cost_Type,
	--ISNULL(SDC.Variable_Cost_Type, ''No'') AS Variable_Cost_Type,
	SD.Agreement_No, SD.Agreement_Date, SD.Deal_Description, SD.Deal_Tag_Code, SD.Deal_Tag_Description, SD.Business_Unit_Code, SD.Business_Unit_Name,
	Subtitling_Languages,
	Dubbing_Languages,
	SDR.Is_Sub_License,
	CASE 
		WHEN SDR.Is_Sub_License =''Y'' THEN SL.Sub_License_Name
		ELSE ''No Sub Licensing''
	END AS Sub_Licensing,
	SDM.Syn_Deal_Movie_Code, NULL AS Holdback_Detail,ROFR,SDR.Deal_Term AS Term,SD.Deal_Type_Name,SD.Deal_Type_Code,DWS.Deal_Workflow_Status_Name,
	ISNULL(VS.Vendor_Name,''NA'') AS Sales_Agent,

	SD.Alternate_Title_Name,
	SD.Alternate_Original_Title,
	SD.Alternate_Language,
	SD.Alternate_Genres_Name,
	SD.Title_Director,
	SD.Title_Star_Cast,
	SD.Spanish_Title_Name,
	SD.Spanish_Original_Title,
	SD.Spanish_Language,
	SD.Spanish_Genres_Name,
	SD.Spanish_Director,
	SD.Spanish_Star_Cast,
	SD.Cat_Name,
	tit.CBFC_Rating

	INTO #Actual_Data_WOP
	FROM #Syn_Deal_Rights SDR
	INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
	INNER JOIN Syn_Deal_Rights_Platform P ON P.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
	INNER JOIN #TmpDeal SD On SDR.Syn_Deal_Code = SD.Syn_Deal_Code AND  SDRT.Title_Code = SD.Title_Code	
	INNER JOIN Syn_Deal_Movie SDM ON SDM.Syn_Deal_Code = SD.Syn_Deal_Code AND SDRT.Title_Code = SDM.Title_Code
	INNER JOIN #TmpTitle tit On tit.Title_Code = SDRT.Title_Code
	LEFT JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = SD.Syn_Deal_Code
	LEFT JOIN Sub_License SL ON SL.Sub_License_Code = SDR.Sub_License_Code
	LEFT JOIN Vendor VS ON VS.Vendor_Code=SD.Sales_Agent_Code
	INNER JOIN Deal_Workflow_Status DWS ON SD.Deal_Workflow_Status=DWS.Deal_WorkflowFlag AND DWS.Deal_Type=''S''
	WHERE 1 = 1' + @Sql_WHERE + @Country_Not_In_Where  + @Category_Not_In_Where + ';'
	
	SET @Sql_Query_3 = ' 
	SELECT *,
	TP.Platform_Hiearachy AS Platform_Name INTO #Actual_Data
	From (
	Select 
	STUFF((SELECT Distinct '','' + CAST(tp2.Platform_Code AS VARCHAR) FROM #Actual_Data_WOP tp2
    WHERE  tp1.Syn_Deal_Rights_Code = tp2.Syn_Deal_Rights_Code
    FOR XML PATH('''')),1,1,'''') AS Platform_Codes,
	Title_Code, Original_Title, Title_Name,
	Year_Of_Production, No_Of_Episode, 
	Syn_Deal_Rights_Code,
	Vendor_Code, Vendor_Name, Role_Name,
	Director_Code, Director_Names_Comma_Seperate, 
	Start_Cast_Code, Star_Cast_Names_Comma_Seperate,Genre_Names_Comma_Seperate,
	--Genres_Code, 
	Original_Dubbed,
	Orig_Dub, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive,
	Restriction_Remarks,Expired,Country_Code, Country_Name, 
	Territory_Name, Is_Holdback, Currency_Code, Currency_Name, 
	Entity_Code, Entity_Name, Deal_Cost, Variable_Cost_Type,
	Agreement_No, Agreement_Date, Deal_Description, Deal_Tag_Code, 
	Deal_Tag_Description, Business_Unit_Code, Business_Unit_Name,
	Subtitling_Languages,Dubbing_Languages, Is_Sub_License, Sub_Licensing,
	Syn_Deal_Movie_Code, Holdback_Detail, ROFR,Term,Deal_Type_Name,
	CASE
		  WHEN Deal_Workflow_Status_Name = ''Waiting'' THEN ''Waiting For Authorization''
		  WHEN Deal_Workflow_Status_Name = ''Amended'' OR Deal_Workflow_Status_Name = ''Opened'' OR   Deal_Workflow_Status_Name = ''Re-Open'' THEN ''Open''
		  WHEN Deal_Workflow_Status_Name = ''Approved'' THEN  Deal_Workflow_Status_Name
		  WHEN Deal_Workflow_Status_Name = ''Rejected'' THEN  Deal_Workflow_Status_Name
		  ELSE ''All''
	END Deal_Workflow_Status_Name,
	Sales_Agent,
	Alternate_Title_Name,
	Alternate_Original_Title,
	Alternate_Language,
	
	STUFF((SELECT Distinct '','' + CAST(Alternate_Genres_Name AS NVARCHAR) FROM #Actual_Data_WOP tp5
	WHERE  tp1.Syn_Deal_Rights_Code = tp5.Syn_Deal_Rights_Code
	FOR XML PATH('''')),1,1,'''') AS Alternate_Genres_Name,

	STUFF((SELECT Distinct '','' + CAST(Title_Director AS NVARCHAR) FROM #Actual_Data_WOP tp4
	WHERE  tp1.Syn_Deal_Rights_Code = tp4.Syn_Deal_Rights_Code
	FOR XML PATH('''')),1,1,'''') AS Title_Director,

	STUFF((SELECT Distinct '','' + CAST(Title_Star_Cast AS NVARCHAR) FROM #Actual_Data_WOP tp3
	WHERE  tp1.Syn_Deal_Rights_Code = tp3.Syn_Deal_Rights_Code
	FOR XML PATH(''''),root(''MyString''),type).value(''/MyString[1]'',''varchar(max)''),1,1,'''') AS Title_Star_Cast,
	dBO.UFN_Get_Rights_Promoter_Group_Remarks(Syn_Deal_Rights_Code,''P'',''S'') as Promoter_Group_Name,
	dBO.UFN_Get_Rights_Promoter_Group_Remarks(Syn_Deal_Rights_Code,''R'',''S'') as Promoter_Remark_Desc,

	Spanish_Title_Name,
	Spanish_Original_Title,
	Spanish_Language,

	STUFF((SELECT Distinct '','' + CAST(Spanish_Genres_Name AS NVARCHAR) FROM #Actual_Data_WOP tp6
	WHERE  tp1.Syn_Deal_Rights_Code = tp6.Syn_Deal_Rights_Code
	FOR XML PATH('''')),1,1,'''') AS Spanish_Genres_Name,

	STUFF((SELECT Distinct '','' + CAST(Spanish_Director AS NVARCHAR) FROM #Actual_Data_WOP tp7
	WHERE  tp1.Syn_Deal_Rights_Code = tp7.Syn_Deal_Rights_Code
	FOR XML PATH('''')),1,1,'''') AS Spanish_Director,

 	STUFF((SELECT Distinct '','' + CAST(Spanish_Star_Cast AS NVARCHAR) FROM #Actual_Data_WOP tp8
	WHERE  tp1.Syn_Deal_Rights_Code = tp8.Syn_Deal_Rights_Code
	FOR XML PATH(''''),root(''MyString''),type).value(''/MyString[1]'',''varchar(max)''),1,1,'''') AS Spanish_Star_Cast,

	Cat_Name,
	CBFC_Rating

	From #Actual_Data_WOP tp1
	Group By Title_Code, Original_Title, Title_Name,tp1.Deal_Workflow_Status_Name,tp1.Sales_Agent,
	Year_Of_Production, No_Of_Episode, 
	Syn_Deal_Rights_Code,
	Vendor_Code, Vendor_Name, Role_Name,
	Director_Code, Director_Names_Comma_Seperate, 
	Start_Cast_Code, Star_Cast_Names_Comma_Seperate,Genre_Names_Comma_Seperate,
	--Genres_Code,
	Original_Dubbed,
	Orig_Dub, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive,
	Restriction_Remarks,Expired,Country_Code, Country_Name, 
	Territory_Name, Is_Holdback, Currency_Code, Currency_Name, 
	Entity_Code, Entity_Name, Deal_Cost, Variable_Cost_Type,
	Agreement_No, Agreement_Date, Deal_Description, Deal_Tag_Code, 
	Deal_Tag_Description, Business_Unit_Code, Business_Unit_Name,
	Subtitling_Languages,Dubbing_Languages, Is_Sub_License, Sub_Licensing,
	Syn_Deal_Movie_Code, Holdback_Detail, ROFR,Term,Deal_Type_Name,
	Alternate_Title_Name,
	Alternate_Original_Title,
	Alternate_Language,
	Alternate_Genres_Name,
	Title_Director,
	Title_Star_Cast,
	Spanish_Title_Name,Spanish_Original_Title,Spanish_Language,Spanish_Genres_Name,Spanish_Director,Spanish_Star_Cast,
	Cat_Name, CBFC_Rating
	) mainouput
	cross apply dbo.UFN_Get_Platform_With_Parent(mainouput.Platform_Codes) tp
	'

		--Print 'sql3'
		--select @Report_Query_Code
	IF(@Report_Query_Code>0)
	BEGIN
		SELECT @Sql_SELECT = STUFF(
		(
			Select  ',' + A.Name_In_DB
			FROM (
				SELECT
				CASE WHEN CHARINDEX('Date',Name_In_DB) > 0 
				THEN
					'CONVERT(VARCHAR,' + RIGHT(Name_In_DB,LEN(Name_In_DB)-CHARINDEX('.',Name_In_DB)) + ',103)'
				ELSE
					RIGHT(Name_In_DB,LEN(Name_In_DB)-CHARINDEX('.',Name_In_DB))
				END AS Name_In_DB,
				Sort_Ord
				FROM Report_Column RC
				INNER JOIN Report_Column_Setup RCS ON RC.Column_Code=RCS.Column_Code
				where RC.Query_Code=@Report_Query_Code and Is_Select='Y'
		) A order by Sort_Ord

		FOR XML PATH('')), 1, 1, '')
	END



	--ELSE
	--	SET @Sql_Query += ' SELECT DISTINCT '+ @Sql_SELECT + ' FROM #Actual_Data '

	SET @Sql_Query_4 = ' SELECT DISTINCT '+ @Sql_SELECT + ' FROM #Actual_Data;
	DROP TABLE #Actual_Data 
	DROP TABLE #Syn_Deal_Rights 
	DROP TABLE #TmpDeal 
	DROP TABLE #Actual_Data_WOP
	DROP TABLE #TmpTitle
	DROP TABLE #Filtered_Title'

	/* Insert actual query result in Temp table */
	PRINT @Sql_Query
	INSERT INTO #TEMPVIEW  
	EXEC (@Sql_Query + @Sql_Query_1 +@Sql_Query_2 +@Sql_Query_3 +@Sql_Query_4)     
   
	/* Get Actual Result*/
	SELECT * FROM #TEMPVIEW
	DROP TABLE #TEMPVIEW
END

----------------------------------------------------------------------------------------------------------------
/*
EXEC USP_Syn_Query_Report 'Title_Name [Title], CONVERT(VARCHAR,Year_Of_Production,103) [Year of Release], Agreement_No [Agreement No], Deal_Description [Deal Description], Deal_Tag_Description [Status], Original_Title [Original Title], Platform_Name [Platform], Vendor_Name [Acquire Licensor], CONVERT(VARCHAR,Right_Start_Date,103) [Right Start Date], CONVERT(VARCHAR,Right_End_Date,103) [Right End Date], Country_Name [Country], Director_Names_Comma_Seperate [Director], Star_Cast_Names_Comma_Seperate [Star Cast], Is_Holdback [Is Holdback], Currency_Name [Currency], Entity_Name [Entity], Subtitling_Languages [Subtitling], Dubbing_Languages [Dubbing], Variable_Cost_Type [Variable Cost], CONVERT(VARCHAR,ROFR,103) [ROFR], Restriction_Remarks [Restriction Remarks], Business_Unit_Name [Business Unit], CONVERT(VARCHAR,Agreement_Date,103) [Agreement Date], Is_Exclusive [Exclusive], Territory_Name [Territory], Term [Term], Role_Name [Customer Type], Sub_Licensing [Sub-Licensing], Original_Dubbed [Original/Dubbed]'

, ' and (  Convert(datetime,SDR.Right_Start_Date,103)  >  ''01-Jan-2015'' AND Expired=''N'' ) AND SD.Business_Unit_Code = 1 AND SD.Entity_Code = 1'
, 29
, 'Title,Year of Release,Agreement No,Deal Description,Status,Original Title,Platform,Acquire Licensor,Right Start Date,Right End Date,Country,Director,Star Cast,Is Holdback,Currency,Entity,Subtitling,Dubbing,Variable Cost,ROFR,Restriction Remarks,Business Unit,Agreement Date,Exclusive,Territory,Term,Customer Type,Sub-Licensing,Original/Dubbed,'
,0,'','','','Y'
*/
----------------------------------------------------------------------------------------------------------------
/*
EXEC USP_Syn_Query_Report 'Title_Name [Title], Agreement_No [Agreement No], Deal_Description [Deal Description], CONVERT(VARCHAR,Year_Of_Production,103) [Year of Release]',
' and (  Convert(datetime,SDR.Right_Start_Date,103)  >  ''01-Jan-2015'' AND Expired=''N'' ) AND SD.Business_Unit_Code = 2 AND SD.Entity_Code = 1',
4,
'Title,Agreement No,Deal Description,Year of Release,',
0,'','','','Y'
*/

--select * from Report_Column_Setup
--(SELECT Vendor_Name from Vendor where Vendor_Code=Sales_Agent_Code) AS [Sales_Agent]

--UPDATE Report_Column_Setup SET Name_In_DB='Sales_Agent' where Column_Code=1239
--select Vendor_Name,Vendor_Code from Vendor where 
----Vendor.Is_Active = 'Y' 
----AND
-- Vendor.Vendor_Code IN(select Vendor_Code from Vendor_Role where Role_Code=8)

--SP_HELPTEXT USP_Syn_Query_Report