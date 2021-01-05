 ALTER PROCEDURE [dbo].[USP_Query_Report]
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
	 @Category_Codes VARCHAR(MAX),
	 @CBFCRating_Codes VARCHAR(MAX)
AS
-- --=============================================
-- --Author			: <Abhaysingh Rajpurohit>
-- --Contributors		: <Adesh Arote, Rushabh Gohil, Pavitar Dua>
-- --Create Date		: <14 Nov 2014>
-- --Description		: <Query Report>
-- --Last Updated By	: <Akshay Rane>
-- --=============================================
BEGIN 
	
	--DECLARE @Sql_SELECT VARCHAR(MAX),
	--@Sql_WHERE VARCHAR(MAX),
	--@Column_Count INT,
	--@Column_Names VARCHAR(MAX),
	--@Is_Debug CHAR(1),
	--@Report_Query_Code INT,
	--@Subtitling_Codes VARCHAR(MAX),
	--@Dubbing_Codes VARCHAR(MAX),
	--@Country_Codes VARCHAR(MAX)	,
	--@Channel_Codes VARCHAR(MAX),
	--@Category_Codes VARCHAR(MAX),
	--@CBFCRating_Codes  VARCHAR(MAX)

	--SELECT @Sql_SELECT = 'Title_Name [Title], Agreement_No [Agreement No], Deal_Desc [Deal Description], Deal_Tag_Description [Status], Original_Title [Original Title], Platform_Name [Platform], Vendor_Name [Licensor], CONVERT(VARCHAR,Actual_Right_Start_Date,103) [Right Start Date], CONVERT(VARCHAR,Actual_Right_End_Date,103) [Right End Date], Country_Name [Country], Director_Names_Comma_Seperate [Director], Star_Cast_Names_Comma_Seperate [Star Cast], Is_Holdback [Holdback], Currency_Name [Currency], Entity_Name [Entity], Subtitling_Languages [Subtitling], Dubbing_Languages [Dubbing], Variable_Cost_Type [Variable Cost], CONVERT(VARCHAR,ROFR,103) [ROFR], Restriction_Remarks [Restriction Remarks], Business_Unit_Name [Business Unit], CONVERT(VARCHAR,Agreement_Date,103) [Agreement Date], CONVERT(VARCHAR,Year_Of_Production,103) [Year of Release], Is_Exclusive [Exclusive], Territory_Name [Territory], Term [Term], Category_Name [Mode of Acquisition], Sub_Licensing [Sub-Licensing], Original_Dubbed [Original/Dubbed], Channel_Name [Channel], NoOfRuns [Run Limitation], Deal_Type_Name [Deal Type], Genre_Names_Comma_Seperate [Genre], Promoter_Group_Name [Self Utilization Group], Promoter_Remark_Desc [Self Utilization Remarks], Deal_Workflow_Status_Name [Deal Workflow Status], Cat_Name [Deal Category], Due_Diligence [Due Diligence], CBFC_Rating [CBFC Rating]',
	--@Sql_WHERE = ' AND (  P.Platform_Code  in  (''72''))  AND Business_Unit_Code = 1 AND Expired=''N'' AND Is_Theatrical_Right=''N''',
	--@Column_Count = 40,
	--@Column_Names ='Title,Agreement No,Deal Description,Status,Original Title,Platform,Licensor,Right Start Date,Right End Date,Country,Director,Star Cast,Holdback,Currency,Entity,Subtitling,Dubbing,Variable Cost,ROFR,Restriction Remarks,Business Unit,Agreement Date,Year of Release,Exclusive,Territory,Term,Mode of Acquisition,Sub-Licensing,Original/Dubbed,Channel,Run Limitation,Deal Type,Genre,Self Utilization Group,Self Utilization Remarks,Deal Workflow Status,Deal Category,Due Diligence,CBFC Rating,',
	--@Is_Debug = 'N',
	--@Report_Query_Code = 0,
	--@Subtitling_Codes = '',
	--@Dubbing_Codes = '',
	--@Country_Codes = '',
	--@Channel_Codes = ''	,
	--@CBFCRating_Codes = '~IN~8,9'

	--SELECT @Sql_SELECT = 'Due_Diligence [Due Diligence], Title_Name [Title], Agreement_No [Agreement No], CBFC_Rating [CBFC Rating] ',
	--@Sql_WHERE = ' AND (  P.Platform_Code  in  (''72'')) AND Business_Unit_Code = 1 AND Expired=''N'' AND Is_Theatrical_Right=''N''',
	--@Column_Count = 5,
	--@Column_Names ='Due Diligence,Title,Agreement No,CBFC Rating,',
	--@Is_Debug = 'N',
	--@Report_Query_Code = 0,
	--@Subtitling_Codes = '',
	--@Dubbing_Codes = '',
	--@Country_Codes = '',
	--@Channel_Codes = '',
	--@Category_Codes = '',
	--@CBFCRating_Codes = 'NOT IN~7'

	--Hnadle for deal critical report aditya
	SELECT @Sql_SELECT = 'Cat_Name [CategoryName], '+ @Sql_SELECT
	--SELECT @Column_Count = @Column_Count + 1
	SELECT @Column_Names = 'CategoryName,' + @Column_Names

			
	DECLARE @Counter INT
	DECLARE @Country_Not_In_Where VARCHAR(2000) = '' , @Category_Not_In_Where VARCHAR(2000) = '', @CBFCRating_Not_In_Where  VARCHAR(2000) = ''
	SET @Counter=2  /* SET counter = 2 bcoz we are already creating temp table with single column */ 
	DECLARE @Script_Alter_TempTable VARCHAR(MAX)

	IF(OBJECT_ID('tempdb..#TEMPVIEW') IS NOT NULL)
		DROP TABLE #TEMPVIEW

	/* Create temp table with single column */
	CREATE TABLE #TEMPVIEW(COL1 NVARCHAR(MAX))
	
	IF(@Report_Query_Code>0)
	BEGIN
		SELECT @Column_Count=COUNT(RC.Column_Code)
		FROM Report_Column RC
		INNER JOIN Report_Column_Setup RCS ON RC.Column_Code=RCS.Column_Code
		WHERE RC.Query_Code=@Report_Query_Code AND Is_Select='Y'
	END
	
	/* Alter temp table AND add more column (like col1, col2, col3) */
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
		
		--PRINT 'Script of Alter TempTable :- ' + @Script_Alter_TempTable 
		--PRINT 'sagar1'
		EXEC (@Script_Alter_TempTable)  
	END

	/* Create SQL for Insert actual column name in first row */
	DECLARE @Script_Insert_Column_Names VARCHAR(MAX)  
	SET @Script_Insert_Column_Names = 'INSERT INTO #TEMPVIEW SELECT '

	IF(@Report_Query_Code>0)
	BEGIN
			SELECT @Column_Names = STUFF(
			(  
				SELECT  ',' + A.Display_Name 
				FROM (
					SELECT RCS.Display_Name,Sort_Ord
					FROM Report_Column RC
					INNER JOIN Report_Column_Setup RCS ON RC.Column_Code=RCS.Column_Code
					WHERE RC.Query_Code=@Report_Query_Code AND Is_Select='Y'
				) A order by Sort_Ord	
			FOR XML PATH('')), 1, 1, '') +','
		 	
		SET @Column_Names = LEFT(@Column_Names,LEN(@Column_Names)-1)  
		SELECT @Script_Insert_Column_Names = @Script_Insert_Column_Names + ' ''' + CONVERT(NVARCHAR(100),NUMBER) + ''',' FROM DBO.FN_SPLIT_WITHDELEMITER(@Column_Names,',')    
	END
	ELSE BEGIN
		SET @Column_Names = LEFT(@Column_Names,LEN(@Column_Names)-1)  
		SELECT @Script_Insert_Column_Names = @Script_Insert_Column_Names + ' ''' + CONVERT(NVARCHAR(100),NUMBER) + ''',' FROM DBO.FN_SPLIT_WITHDELEMITER(@Column_Names,',')    
	END
	SET @Script_Insert_Column_Names = LEFT(@Script_Insert_Column_Names,LEN(@Script_Insert_Column_Names)-1)  
	/* Execute SQL for Insert actual column name in first row */
	--PRINT 'Script of Insert Column Names in TempTable :- ' + @Script_Insert_Column_Names
	EXEC (@Script_Insert_Column_Names)  

	SET @Subtitling_Codes = IsNull(@Subtitling_Codes, '')
	SET @Dubbing_Codes = IsNull(@Dubbing_Codes, '')
	SET @Country_Codes = IsNull(@Country_Codes, '')
	SET @Channel_Codes = IsNull(@Channel_Codes, '')
	SET @Category_Codes = IsNull(@Category_Codes, '')

	DECLARE @RightsSql VARCHAR(MAX) = '', @InNotIn VARCHAR(10) = ''
	IF(@Channel_Codes <> '')
	BEGIN
		SELECT @InNotIn = number FROM DBO.fn_Split_withdelemiter(@Channel_Codes, '~') WHERE Id=1
		SELECT @Channel_Codes = number FROM DBO.fn_Split_withdelemiter(@Channel_Codes, '~') WHERE Id=2
	END

	SET @RightsSql = 'SELECT 
		CASE LEN(Subtitling_Lang) WHEN 0 THEN ''No'' ELSE Subtitling_Lang END AS Subtitling_Languages,
		CASE LEN(Dubbing_Lang) WHEN 0 THEN ''No'' ELSE Dubbing_Lang END AS Dubbing_Languages, 
		CASE LEN(Countrys) WHEN 0 THEN ''No'' ELSE Countrys END AS Country_Name, 
		CASE LEN(Territorys) WHEN 0 THEN ''No'' ELSE Territorys END AS Territory_Name,	
		LEFT(Runs_Channels, CHARINDEX(''~'',Runs_Channels) - 1) AS Channel_Names,
		RIGHT(Runs_Channels ,LEN(Runs_Channels)-CHARINDEX(''~'',Runs_Channels)) AS No_of_Runs, 	
		 *
		INTO #Acq_Deal_Rights
		FROM
		(
			SELECT ADR.*, adrt.Acq_Deal_Rights_Title_Code,
			DBO.UFN_Get_Rights_Subtitling(ADR.Acq_Deal_Rights_Code, ''A'') AS Subtitling_Lang, 
			DBO.UFN_Get_Rights_Dubbing(ADR.Acq_Deal_Rights_Code, ''A'') AS Dubbing_Lang,
			DBO.UFN_Get_Rights_Country_Query(ADR.Acq_Deal_Rights_Code, ''A'') AS Countrys,
			DBO.UFN_Get_Rights_Territory(ADR.Acq_Deal_Rights_Code, ''A'') AS Territorys,
			--DBO.[UFN_Get_Rights_NoOfRuns](ADR.Acq_Deal_Rights_Code) AS Runs,
			dbo.UFN_Get_Rights_Channel(adrt.Title_Code, ADR.Acq_Deal_Code, ''' + @Channel_Codes + ''', ''' + @InNotIn + ''') AS Runs_Channels,
			CASE WHEN (GETDATE() > right_END_date) THEN ''Y'' ELSE ''N'' END AS Expired,
			CASE Is_Exclusive WHEN ''Y'' THEN ''Yes'' ELSE ''No'' END AS Exclusive,
			CASE
				WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback ADRH WHERE ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN ''Y'' ELSE ''N'' 
			END AS Is_Holdback, 
			CASE Right_Type
			   WHEN ''Y'' THEN [dbo].[UFN_Get_Rights_Term](ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, Term) 
			   WHEN ''M'' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
			   WHEN ''U'' THEN ''Perpetuity''
			END AS Deal_Term,
			CASE ADR.Is_ROFR WHEN ''Y'' THEN CONVERT(VARCHAR,ADR.ROFR_Date,103) ELSE ''No'' END AS ROFR
			FROM Acq_Deal_Rights ADR 
			INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
			WHERE 1=1 {SQLSUB}{SQLDUB}{SQLCOUN}{SQLCHANL} 
		) AS A
		'
	IF(@Subtitling_Codes <> '')
	BEGIN		
		SELECT @InNotIn = number FROM DBO.fn_Split_withdelemiter(@Subtitling_Codes, '~') WHERE Id=1
		SELECT @Subtitling_Codes = number FROM DBO.fn_Split_withdelemiter(@Subtitling_Codes, '~') WHERE Id=2		
		DECLARE @SubTit VARCHAR(MAX) = ' AND ADR.Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code Is Not Null 
		AND (( 
				Language_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Subtitling_Codes + ''', '','') WHERE number <> '','') 
				AND Language_Type = ''L''
			) 
		OR 
			(
				Language_Group_Code in (SELECT  Language_Group_Code FROM Language_Group_Details WHERE 
				Language_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Subtitling_Codes + ''', '','') WHERE number <> '',''))  
				AND Language_Type = ''G''
			))
		)'
		SET @RightsSql = Replace(@RightsSql, '{SQLSUB}', @SubTit)
	END
	
	IF(@Dubbing_Codes <> '')
	BEGIN
		SELECT @InNotIn = number FROM DBO.fn_Split_withdelemiter(@Dubbing_Codes, '~') WHERE Id=1
		SELECT @Dubbing_Codes = number FROM DBO.fn_Split_withdelemiter(@Dubbing_Codes, '~') WHERE Id=2
		DECLARE @Dubb VARCHAR(MAX) = ' AND ADR.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code Is Not Null 
		AND (( 
				Language_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Dubbing_Codes + ''', '','') WHERE number <> '','') 
				AND Language_Type = ''L''
			) 
		OR 
			(
				Language_Group_Code in (SELECT  Language_Group_Code FROM Language_Group_Details WHERE 
				Language_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Dubbing_Codes + ''', '','') WHERE number <> '',''))  
				AND Language_Type = ''G''
			))
		)'
		SET @RightsSql = Replace(@RightsSql, '{SQLDUB}', @Dubb)
	END

	IF(@Country_Codes <> '')
	BEGIN
		SELECT @InNotIn = number FROM DBO.fn_Split_withdelemiter(@Country_Codes, '~') WHERE Id=1
		SELECT @Country_Codes = number FROM DBO.fn_Split_withdelemiter(@Country_Codes, '~') WHERE Id=2		
		IF(LTRIM(RTRIM(UPPER(@InNotIn))) ='NOT IN')
		BEGIN			
			SET @Country_Not_In_Where=' AND ADM.Title_Code NOT IN
										(											
											SELECT AADRT.Title_Code FROM Acq_Deal_Rights_Title AADRT WHERE AADRT.Acq_Deal_Rights_Code IN
											(
												SELECT IADRT.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory IADRT 
												WHERE IADRT.Country_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Country_Codes + ''', '','') 
												WHERE number <> '','') AND IADRT.Territory_Type=''I''
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
		DECLARE @Count NVARCHAR(MAX) = N' AND ADR.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code Is Not Null 
		AND (( 
				Country_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Country_Codes + ''', '','') WHERE number <> '','') 
				AND Territory_Type=''I''
			) 
		OR 
			(
				Territory_Code in (SELECT  Territory_Code FROM Territory_Details WHERE 
				Country_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Country_Codes + ''', '','') WHERE number <> '',''))  
				AND Territory_Type=''G''
			))
		)'
		SET @RightsSql = Replace(@RightsSql, '{SQLCOUN}', @Count)
		END
	END
		
	IF(@Channel_Codes <> '')
	BEGIN
		DECLARE @Chanl VARCHAR(5000) = 'AND adrt.Acq_Deal_Rights_Title_Code In (SELECT DISTINCT adrt1.Acq_Deal_Rights_Title_Code FROM Acq_Deal_Run ADRun
					INNER JOIN Acq_Deal_Run_Channel adrc ON ADRun.Acq_Deal_Run_Code = adrc.Acq_Deal_Run_Code 
					INNER JOIN Acq_Deal_Run_Title adrunt ON adrunt.Acq_Deal_Run_Code = adrc.Acq_Deal_Run_Code 
					INNER JOIN Acq_Deal_Rights_Title adrt1 ON adrt1.Title_Code = adrunt.Title_Code
					WHERE  adrc.Channel_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter(''' + @Channel_Codes + ''', '','') WHERE number <> '','')
					AND ADRun.Acq_Deal_Code = ADR.Acq_Deal_Code
					)'			
		SET @RightsSql = Replace(@RightsSql, '{SQLCHANL}', @Chanl)
		SET @Sql_WHERE += ' AND p.Platform_Code IN (SELECT Platform_Code FROM Platform WHERE Is_No_Of_Run = ''Y'' )'
	END

	IF(@Category_Codes <> '')
	BEGIN
		SELECT @InNotIn = number FROM DBO.fn_Split_withdelemiter(@Category_Codes, '~') WHERE Id=1
		SELECT @Category_Codes = number FROM DBO.fn_Split_withdelemiter(@Category_Codes, '~') WHERE Id=2
		
		SET @Category_Not_In_Where=' AND AD.Cat_Code ' + @InNotIn + ' (SELECT number FROM DBO.fn_Split_withdelemiter
			(''' + @Category_Codes + ''', '','') WHERE number <> '','') '
		
	END

	SET @RightsSql = Replace(@RightsSql, '{SQLSUB}', '')
	SET @RightsSql = Replace(@RightsSql, '{SQLDUB}', '')
	SET @RightsSql = Replace(@RightsSql, '{SQLCOUN}', '')
	SET @RightsSql = Replace(@RightsSql, '{SQLCHANL}', '')	

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

			IF (@LogicalConnect = '') SET @LogicalConnect = 'AND'
	END

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
		--, CASE ECV.Columns_Value WHEN ''Original'' THEN ''O'' ELSE ''D'' END AS Orig_Dub
		,STUFF((SELECT DISTINCT '','' + CAST(ECV.Columns_Value AS NVARCHAR) 
			FROM title Tit  
			LEFT JOIN Map_Extended_Columns MEC ON MEC.Record_Code = Tit.Title_Code and MEC.Columns_Code in (select Columns_Code from  Extended_Columns where Columns_Name = ''CBFC Rating'')
			LEFT JOIN Map_Extended_Columns_Details MECD ON MECD.Map_Extended_Columns_Code = MEC.Map_Extended_Columns_Code 
			LEFT JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MECD.Columns_Value_Code
			WHERE Tit.Title_Code =  T.Title_Code
		FOR XML PATH('''')),1,1,'''') AS ''CBFC_Rating''
		INTO #TmpTitle 
	FROM Title T 
	WHERE IsNull(T.Reference_Flag, '''') <> ''T'' 
	'+ @LogicalConnect +' T.Title_Code '+@CBFCRating_InNotIn+' ( SELECT Title_Code FROM #Filtered_Title)

	SELECT AD.Acq_Deal_Code, AD.Vendor_Code, V.Vendor_Name, AD.Currency_Code, CUR.Currency_Name, AD.Entity_Code, E.Entity_Name,AD.Deal_Type_Code,
	AD.Agreement_No, AD.Agreement_Date, AD.Content_Type, AD.Deal_Desc, AD.Deal_Tag_Code, DT.Deal_Tag_Description, AD.Business_Unit_Code, 
	BU.Business_Unit_Name, DC.Role_Name As Category_Name, LEFT(DC.Role_Name, 1) AS Category_Type, dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) As DEAL_TYPE_NAMES,
	ADT.Deal_Type_Name,AD.Deal_Workflow_Status,
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
	AD.Category_Code AS Cat_Code,
	C.Category_Name AS Cat_Name
	INTO #TmpDeal
	FROM Acq_Deal AD
	INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
	INNER JOIN Deal_Type ADT ON ADT.Deal_Type_Code = AD.Deal_Type_Code
	INNER JOIN Currency CUR ON CUR.Currency_Code = AD.Currency_Code
	INNER JOIN Entity E ON E.Entity_Code = AD.Entity_Code
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
	INNER JOIN Deal_Tag DT ON DT.Deal_Tag_Code = AD.Deal_Tag_Code
	INNER JOIN Role DC on AD.Role_Code = DC.Role_Code
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
	INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
	INNER JOIN Category C ON C.Category_Code = AD.Category_Code
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
	LEFT JOIN Talent Spa_TALENT_SC ON Spa_TALENT_SC.Talent_Code = Spa_TAT_SC.Talent_Code
	where  AD.Deal_Workflow_Status NOT IN (''AR'', ''WA'');'
	
	SET @Sql_Query_2 = ' 
	SELECT DISTINCT tit.Title_Code, tit.Original_Title, 	
	dbo.UFN_GetTitleNameInFormat(DEAL_TYPE_NAMES, tit.Title_Name, ADRT.Episode_From, ADRT.Episode_To) AS Title_Name,
	tit.Year_Of_Production, ADM.No_Of_Episodes, 
	P.Platform_Code, ADR.Acq_Deal_Rights_Code,
	AD.Vendor_Code, AD.Vendor_Name, AD.Category_Name,
	tit.Director_Code, tit.Director_Names_Comma_Seperate, 
	tit.Start_Cast_Code, tit.Star_Cast_Names_Comma_Seperate,tit.Genre_Names_Comma_Seperate,
	--tit.Genres_Code,
	tit.Original_Dubbed,
	CASE tit.Original_Dubbed WHEN ''Original'' THEN ''O'' ELSE ''D'' END AS Orig_Dub,
	ADR.Actual_Right_Start_Date AS Actual_Right_Start_Date, ADR.Actual_Right_End_Date AS Actual_Right_End_Date, 
	ADR.Exclusive AS Is_Exclusive,ADR.Restriction_Remarks,ADR.Expired,
	--Sub_License AS Is_Sub_License,
	0 Country_Code, ADR.Country_Name, ADR.Territory_Name,
	CASE Is_Holdback WHEN ''Y'' THEN ''Yes'' ELSE ''No'' END AS Is_Holdback,
	AD.Currency_Code, AD.Currency_Name, AD.Entity_Code, AD.Entity_Name, 
	ADC.Deal_Cost, 
	CASE
		WHEN ADC.Variable_Cost_Type = ''P'' THEN ''Profit-Sharing''
		WHEN ADC.Variable_Cost_Type = ''R'' THEN ''Revenue-Sharing''
		ELSE ''NA''
	END AS Variable_Cost_Type,
	--ISNULL(ADC.Variable_Cost_Type, ''No'') AS Variable_Cost_Type,
	AD.Agreement_No, AD.Agreement_Date, AD.Deal_Desc, AD.Deal_Tag_Code, AD.Deal_Tag_Description, AD.Business_Unit_Code, AD.Business_Unit_Name,
	Subtitling_Languages,
	Dubbing_Languages,
	ADR.Is_Sub_License,
	CASE 
		WHEN ADR.Is_Sub_License =''Y'' THEN SL.Sub_License_Name
		ELSE ''No Sub Licensing''
	END AS Sub_Licensing,
	--ADR.Is_Sub_License,SL.Sub_License_Name AS Sub_Licensing,
	ADM.Acq_Deal_Movie_Code, NULL AS Holdback_Detail,ROFR,ADR.Deal_Term AS Term,
	Channel_Names, No_of_Runs,
	AD.Deal_Type_Name,AD.Deal_Type_Code,
	DWS.Deal_Workflow_Status_Name,
	AD.Alternate_Title_Name,
	AD.Alternate_Original_Title,
	AD.Alternate_Language,
	AD.Alternate_Genres_Name,
	AD.Title_Director,
	AD.Title_Star_Cast,
	AD.Spanish_Title_Name,
	AD.Spanish_Original_Title,
	AD.Spanish_Language,
	AD.Spanish_Genres_Name,
	AD.Spanish_Director,
	AD.Spanish_Star_Cast,
	AD.Cat_Name,
	ADM.Due_Diligence,
	tit.CBFC_Rating

	INTO #Actual_Data_WOP
	FROM #Acq_Deal_Rights ADR

	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Title_Code = ADR.Acq_Deal_Rights_Title_Code
	INNER JOIN Acq_Deal_Rights_Platform P ON P.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
	INNER JOIN #TmpDeal AD On ADR.Acq_Deal_Code = AD.Acq_Deal_Code	AND ADRT.Title_Code = AD.Title_Code
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code AND ADRT.Title_Code = ADM.Title_Code
	INNER JOIN #TmpTitle tit On tit.Title_Code = ADRT.Title_Code	
	LEFT JOIN Acq_Deal_Cost ADC ON ADC.Acq_Deal_Code = AD.Acq_Deal_Code
	LEFT JOIN Sub_License SL ON SL.Sub_License_Code = ADR.Sub_License_Code
	INNER JOIN Deal_Workflow_Status DWS ON AD.Deal_Workflow_Status=DWS.Deal_WorkflowFlag AND DWS.Deal_Type=''A'' 
	WHERE 1 = 1' + @Sql_WHERE  + @Country_Not_In_Where + @Category_Not_In_Where + ';'
	
	SET @Sql_Query_3 = ' 
	SELECT *,
	CASE WHEN (SELECT Count(*) FROM [Platform] WHERE platform_code in (tp.Platform_Code)) > 0 AND Channel_Names<>''''
	THEN Channel_Names ELSE  '''' END Channel_Name,CASE WHEN (SELECT Count(*) FROM [Platform] WHERE platform_code in (tp.Platform_Code) ) > 0 AND No_Of_Runs<>''''
	THEN No_Of_Runs ELSE  '''' END NoOfRuns
	,TP.Platform_Hiearachy AS Platform_Name INTO #Actual_Data
	FROM (
		SELECT 
		STUFF((SELECT Distinct '','' + CAST(tp2.Platform_Code AS VARCHAR) FROM #Actual_Data_WOP tp2
		WHERE  tp1.Acq_Deal_Rights_Code = tp2.Acq_Deal_Rights_Code
		FOR XML PATH('''')),1,1,'''') AS Platform_Codes,
		Title_Code, Original_Title, Title_Name,
		Year_Of_Production, No_Of_Episodes, 
		Acq_Deal_Rights_Code,
		Vendor_Code, Vendor_Name, Category_Name,
		Director_Code, Director_Names_Comma_Seperate, 
		Start_Cast_Code, Star_Cast_Names_Comma_Seperate,Genre_Names_Comma_Seperate,
		--Genres_Code, 
		Original_Dubbed,
		Orig_Dub, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive, Restriction_Remarks, Expired,
		Country_Code, Country_Name, Territory_Name, Is_Holdback,
		Currency_Code, Currency_Name, Entity_Code, Entity_Name, 
		Deal_Cost, Variable_Cost_Type,
		Agreement_No, Agreement_Date, Deal_Desc, Deal_Tag_Code, Deal_Tag_Description, Business_Unit_Code, Business_Unit_Name,
		Subtitling_Languages,
		Dubbing_Languages,
		Is_Sub_License, Sub_Licensing,
		Acq_Deal_Movie_Code, Holdback_Detail, ROFR, Term, Channel_Names, No_Of_Runs,Deal_Type_Name,
		--Deal_Workflow_Status_Name,
		CASE
		  WHEN Deal_Workflow_Status_Name = ''Waiting'' THEN ''Waiting For Authorization''
		  WHEN Deal_Workflow_Status_Name = ''Amended'' OR Deal_Workflow_Status_Name = ''Opened'' OR   Deal_Workflow_Status_Name = ''Re-Open'' THEN ''Open''
		  WHEN Deal_Workflow_Status_Name = ''Approved'' OR Deal_Workflow_Status_Name = ''Approved (Override)''  THEN ''Approved''
		  WHEN Deal_Workflow_Status_Name = ''Rejected'' THEN  Deal_Workflow_Status_Name
		  ELSE ''All''
		END Deal_Workflow_Status_Name,
		Alternate_Title_Name,
		Alternate_Original_Title,
		Alternate_Language,
		
		STUFF((SELECT Distinct '','' + CAST(Alternate_Genres_Name AS NVARCHAR) FROM #Actual_Data_WOP tp5
		WHERE  tp1.Acq_Deal_Rights_Code = tp5.Acq_Deal_Rights_Code
		FOR XML PATH('''')),1,1,'''') AS Alternate_Genres_Name,

		STUFF((SELECT Distinct '','' + CAST(Title_Director AS NVARCHAR) FROM #Actual_Data_WOP tp4
		WHERE  tp1.Acq_Deal_Rights_Code = tp4.Acq_Deal_Rights_Code
		FOR XML PATH('''')),1,1,'''') AS Title_Director,

		STUFF((SELECT Distinct '','' + CAST(Title_Star_Cast AS NVARCHAR) FROM #Actual_Data_WOP tp3
		WHERE  tp1.Acq_Deal_Rights_Code = tp3.Acq_Deal_Rights_Code
		FOR XML PATH(''''),root(''MyString''),type).value(''/MyString[1]'',''varchar(max)''),1,1,'''') AS Title_Star_Cast,
		dBO.UFN_Get_Rights_Promoter_Group_Remarks(Acq_Deal_Rights_Code,''P'',''A'')
			as Promoter_Group_Name,
			dBO.UFN_Get_Rights_Promoter_Group_Remarks(Acq_Deal_Rights_Code,''R'',''A'')
			as Promoter_Remark_Desc,
		Spanish_Title_Name,
		Spanish_Original_Title,
		Spanish_Language,

		STUFF((SELECT Distinct '','' + CAST(Spanish_Genres_Name AS NVARCHAR) FROM #Actual_Data_WOP tp6
		WHERE  tp1.Acq_Deal_Rights_Code = tp6.Acq_Deal_Rights_Code
		FOR XML PATH('''')),1,1,'''') AS Spanish_Genres_Name,

		STUFF((SELECT Distinct '','' + CAST(Spanish_Director AS NVARCHAR) FROM #Actual_Data_WOP tp7
		WHERE  tp1.Acq_Deal_Rights_Code = tp7.Acq_Deal_Rights_Code
		FOR XML PATH('''')),1,1,'''') AS Spanish_Director,

		STUFF((SELECT Distinct '','' + CAST(Spanish_Star_Cast AS NVARCHAR) FROM #Actual_Data_WOP tp8
		WHERE  tp1.Acq_Deal_Rights_Code = tp8.Acq_Deal_Rights_Code
		FOR XML PATH(''''),root(''MyString''),type).value(''/MyString[1]'',''varchar(max)''),1,1,'''') AS Spanish_Star_Cast,

		Cat_Name,
		CASE 
			WHEN Due_Diligence = ''Y'' THEN ''Yes''
			ELSE ''No''
		END AS Due_Diligence,
		CBFC_Rating

		FROM 
		#Actual_Data_WOP tp1
		Group By Title_Code, Original_Title, Title_Name,tp1.Deal_Workflow_Status_Name,
		Year_Of_Production, No_Of_Episodes, 
		Acq_Deal_Rights_Code,
		Vendor_Code, Vendor_Name, Category_Name,
		Director_Code, Director_Names_Comma_Seperate,  
		Start_Cast_Code, Star_Cast_Names_Comma_Seperate,Genre_Names_Comma_Seperate,
		--Genres_Code,
		 Original_Dubbed,
		Orig_Dub, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Exclusive, Restriction_Remarks, Expired,
		Country_Code, Country_Name, Territory_Name, Is_Holdback,
		Currency_Code, Currency_Name, Entity_Code, Entity_Name, 
		Deal_Cost, Variable_Cost_Type,
		Agreement_No, Agreement_Date, Deal_Desc, Deal_Tag_Code, Deal_Tag_Description, Business_Unit_Code, Business_Unit_Name,
		Subtitling_Languages,
		Dubbing_Languages,
		Is_Sub_License, Sub_Licensing,
		Acq_Deal_Movie_Code, Holdback_Detail, ROFR, Term, Channel_Names, No_Of_Runs,Deal_Type_Name,
		Alternate_Title_Name,
		Alternate_Original_Title,
		Alternate_Language,
		Alternate_Genres_Name,
		Title_Director,
		Title_Star_Cast,
		Spanish_Title_Name,Spanish_Original_Title,Spanish_Language,Spanish_Genres_Name,Spanish_Director,Spanish_Star_Cast,
		Cat_Name, Due_Diligence, CBFC_Rating
	) mainouput
	cross apply dbo.UFN_Get_Platform_With_Parent(mainouput.Platform_Codes) tp;'
	IF(@Report_Query_Code>0)
	BEGIN
		SELECT @Sql_SELECT = STUFF(
		(
			SELECT  ',' + A.Name_In_DB
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
				WHERE RC.Query_Code=@Report_Query_Code AND Is_Select='Y'
		) A order by Sort_Ord

		FOR XML PATH('')), 1, 1, '')
	END

	SET @Sql_Query_4 = ' SELECT DISTINCT '+ @Sql_SELECT + ' FROM #Actual_Data;
	DROP TABLE #Actual_Data 
	DROP TABLE #Acq_Deal_Rights 
	DROP TABLE #TmpDeal 
	DROP TABLE #Actual_Data_WOP
	DROP TABLE #TmpTitle
	DROP TABLE #Filtered_Title
	'
	
	/* Insert actual query result in Temp table */
	PRINT '@Sql_Query : '  + @Sql_Query 
	PRINT '@Sql_Query_1 : ' + @Sql_Query_1  
	PRINT '@Sql_Query_2 : ' + @Sql_Query_2
	PRINT '@Sql_Query_3 : ' + @Sql_Query_3
	PRINT '@Sql_Query_4 : ' + @Sql_Query_4
	

	INSERT INTO #TEMPVIEW  
	EXEC (@Sql_Query + @Sql_Query_1 +@Sql_Query_2 + @Sql_Query_3 + @Sql_Query_4)     
	/* Get Actual Result*/
	SELECT * FROM #TEMPVIEW
END