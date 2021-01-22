CREATE PROCEDURE USPExportToExcelBulkImport
	@DM_Master_Import_Code INT = 0,
	@SearchCriteria VARCHAR(MAX) = '',
	@File_Type VARCHAR(1) = '',
	@AdvanceSearch NVARCHAR(MAX) = ''
	
AS
BEGIN
--DECLARE
--	@DM_Master_Import_Code INT = 6982,
--	@SearchCriteria VARCHAR(MAX) = '',
--	@File_Type VARCHAR(1) = 'C',
--	@AdvanceSearch NVARCHAR(MAX) = ''
	DECLARE 
	@Condition NVARCHAR(MAX) = '',
	@Record_Status VARCHAR(20) = '',
	@Is_Ignore VARCHAR(1) = ''

     SELECT @Record_Status = CASE WHEN @SearchCriteria = 'Success' THEN  'C'
								  WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict') THEN  'OR,MR,SM,MO,SO,R'
								  WHEN @SearchCriteria = 'Proceed' THEN  'P'
								  WHEN @SearchCriteria = 'No Error' THEN  'N'
								  WHEN @SearchCriteria = 'Error' THEN  'E'
								  ELSE '' END, 
			@Is_Ignore = CASE WHEN @SearchCriteria = 'Ignore' THEN 'Y'
								  ELSE '' END,	
			@SearchCriteria = CASE WHEN @SearchCriteria = 'Success' THEN  ''
								  WHEN (@SearchCriteria = 'Resolve Conflict' OR @SearchCriteria = 'Resolve' OR @SearchCriteria = 'Conflict') THEN  ''
								  WHEN @SearchCriteria = 'Proceed' THEN  ''
								  WHEN @SearchCriteria = 'No Error' THEN  ''
								  WHEN @SearchCriteria = 'Error' THEN  ''
								  WHEN @SearchCriteria = 'Ignore' THEN ''
								  ELSE @SearchCriteria END
   
     IF(@AdvanceSearch = '')
		set @AdvanceSearch += ''
	  IF(@SearchCriteria != '')
			set @SearchCriteria =  '%'+@SearchCriteria+'%'  
       		    
	--SELECT @Record_Status
	--SELECT @SearchCriteria
	--SELECT @Is_Ignore

	IF(OBJECT_ID('TEMPDB..#tempBulkImportExport_To_Excel') IS NOT NULL)
		DROP TABLE #tempBulkImportExport_To_Excel

	IF(OBJECT_ID('TEMPDB..#ExcelSrNo') IS NOT NULL)
		DROP TABLE #ExcelSrNo

	CREATE TABLE #tempBulkImportExport_To_Excel
	(
		COL01 NVARCHAR(MAX),
		COL02 NVARCHAR(MAX),
		COL03 NVARCHAR(MAX),
		COL04 NVARCHAR(MAX),
		COL05 NVARCHAR(MAX),
		COL06 NVARCHAR(MAX),
		COL07 NVARCHAR(MAX),
		COL08 NVARCHAR(MAX),
		COL09 NVARCHAR(MAX),
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
		COL45 NVARCHAR(MAX),
		COL46 NVARCHAR(MAX),
		COL47 NVARCHAR(MAX),
		COL48 NVARCHAR(MAX),
		COL49 NVARCHAR(MAX),
		COL50 NVARCHAR(MAX),
		COL51 NVARCHAR(MAX),
		COL52 NVARCHAR(MAX),
		COL53 NVARCHAR(MAX),
		COL54 NVARCHAR(MAX),
		COL55 NVARCHAR(MAX),
		COL56 NVARCHAR(MAX),
		COL57 NVARCHAR(MAX),
		COL58 NVARCHAR(MAX),
		COL59 NVARCHAR(MAX),
		COL60 NVARCHAR(MAX),
		COL61 NVARCHAR(MAX),
		COL62 NVARCHAR(MAX),
		COL63 NVARCHAR(MAX),
		COL64 NVARCHAR(MAX),
		COL65 NVARCHAR(MAX),
		COL66 NVARCHAR(MAX),
		COL67 NVARCHAR(MAX),
		COL68 NVARCHAR(MAX),
		COL69 NVARCHAR(MAX),
		COL70 NVARCHAR(MAX),
		COL71 NVARCHAR(MAX),
		COL72 NVARCHAR(MAX),
		COL73 NVARCHAR(MAX),
		COL74 NVARCHAR(MAX),
		COL75 NVARCHAR(MAX),
		COL76 NVARCHAR(MAX),
		COL77 NVARCHAR(MAX),
		COL78 NVARCHAR(MAX),
		COL79 NVARCHAR(MAX),
		COL80 NVARCHAR(MAX),
		COL81 NVARCHAR(MAX),
		COL82 NVARCHAR(MAX),
		COL83 NVARCHAR(MAX),
		COL84 NVARCHAR(MAX),
		COL85 NVARCHAR(MAX),
		COL86 NVARCHAR(MAX),
		COL87 NVARCHAR(MAX),
		COL88 NVARCHAR(MAX),
		COL89 NVARCHAR(MAX),
		COL90 NVARCHAR(MAX),
		COL91 NVARCHAR(MAX),
		COL92 NVARCHAR(MAX),
		COL93 NVARCHAR(MAX),
		COL94 NVARCHAR(MAX),
		COL95 NVARCHAR(MAX),
		COL96 NVARCHAR(MAX),
		COL97 NVARCHAR(MAX),
		COL98 NVARCHAR(MAX),
		COL99 NVARCHAR(MAX),
		COL100 NVARCHAR(MAX)
	)
	
	--- Title
	IF(@File_Type = 'T')
	BEGIN   
		DECLARE @Is_Advance_Title_Import NVARCHAR(MAX) = ''
		select @Is_Advance_Title_Import =  Parameter_Value from system_parameter_new  where parameter_name = 'Is_Advance_Title_Import'

		IF(@Is_Advance_Title_Import = 'N')
		BEGIN
	 		IF(@DM_Master_Import_Code > 0) 
				set @Condition  += ' AND DMT.DM_Master_Import_Code  ='+ cast( @DM_Master_Import_Code as varchar)+'' 		
			IF(@SearchCriteria != '')
			set @Condition += ' AND ([Original Title (Tanil/Telugu)] Like ''' + @SearchCriteria + ''' OR [Title Type] Like ''' + @SearchCriteria + ''' OR [Original Language (Hindi)] Like ''' + @SearchCriteria +
									  ''' OR [Key Star Cast] Like ''' + @SearchCriteria + ''' OR [Director Name] Like ''' + @SearchCriteria + ''' OR [Music_Label] Like ''' + @SearchCriteria +
									  ''' OR [Year of Release] Like ''' + @SearchCriteria +''')'	
			IF(@Record_Status != '')
				set @Condition += ' AND [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter('''+@Record_Status+''', '''+ ',' +''') WHERE number != '''')'						         
 			IF(@Is_Ignore != '')
				set @Condition += ' AND [Is_Ignore]  =''' + @Is_Ignore +''''
		
			IF(OBJECT_ID('TEMPDB..#TempKeyStarCast') IS NOT NULL)
			DROP TABLE #TempKeyStarCast
			IF(OBJECT_ID('TEMPDB..#TempTitleErrorMsg') IS NOT NULL)
			DROP TABLE #TempTitleErrorMsg
			IF(OBJECT_ID('TEMPDB..#TempDirector') IS NOT NULL)
				DROP TABLE #TempDirector
			IF(OBJECT_ID('TEMPDB..#TempMusicLabel') IS NOT NULL)
				DROP TABLE #TempMusicLabel
			
			CREATE TABLE #TempKeyStarCast
			(
				ID INT,	
				StarCast NVARCHAR(MAX)
			)
			CREATE TABLE #TempTitleErrorMsg
			(
				ID INT,
				ErrorMessage NVARCHAR(MAX)
			)
			CREATE TABLE #TempDirector
			(
				ID INT,
				Director NVARCHAR(MAX)
			)
			CREATE TABLE #TempMusicLabel
			(
				ID INT,
				MusicLabel NVARCHAR(MAX)
			)
			INSERT INTO #TempKeyStarCast(ID, StarCast)
			SELECT  DM_Title_Code, LTRIM(RTRIM(number)) AS StarCast from DM_Title DMT
			CROSS APPLY dbo.fn_Split_withdelemiter([Key Star Cast],',') 
			WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> '' 
	
			INSERT INTO #TempTitleErrorMsg(ID, ErrorMessage)
			SELECT DM_Title_Code,  LTRIM(RTRIM(number)) AS ErrorMsg from DM_Title DMT
			CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
			WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> '' 

			INSERT INTO #TempDirector(ID, Director)
			SELECT  DM_Title_Code, LTRIM(RTRIM(number)) AS Director from DM_Title DMT
			CROSS APPLY dbo.fn_Split_withdelemiter(DMT.[Director Name],',') 
			WHERE LTRIM(RTRIM(ISNULL(DMT.[Director Name], ''))) <> '' 
			AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code
	
			INSERT INTO #TempMusicLabel(ID, MusicLabel)
			SELECT  DM_Title_Code, LTRIM(RTRIM(number)) AS MusicLabel from DM_Title DMT
			CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Label,',') 
			WHERE LTRIM(RTRIM(ISNULL(DMT.Music_Label, ''))) <> '' 
			AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

			INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14)				  
			SELECT 'Excel Line No', 'Title','Original Title' ,'Title Type', 'Title Language','Original Language','Year of Release','Duration(Min)','Key Star Cast', 'Director', 'Music Label', 'Synopsis', 'Status', 'Error Message'

			Declare @Sql NVARCHAR(MAX)

			Set @Sql =  '	
				         INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14)	
						 Select [Excel_Line_No], [Original Title (Tanil/Telugu)], [Title/ Dubbed Title (Hindi)], [Title Type], [Original Language (Hindi)], [Original_Language]
				                  , [Year of Release], [Duration (Min)], [Key Star Cast], [Director Name], [Music_Label], [Synopsis], Status, [Error_Message]   From      
                            (      
                                select * from (      
                                    select distinct [DM_Title_Code], [Excel_Line_No],[Original Title (Tanil/Telugu)], [Title/ Dubbed Title (Hindi)], [Title Type], [Original Language (Hindi)],    
										    [Original_Language], [Year of Release],  [Duration (Min)], [Key Star Cast], [Director Name], [Music_Label], [Synopsis],
											CASE WHEN [Is_Ignore] = ''Y'' THEN ''Ignore''
												 WHEN [Record_Status] = ''C'' THEN ''Success''
											     WHEN [Record_Status] = ''E'' THEN ''Error''
											     WHEN [Record_Status] = ''N'' THEN ''No Error''
												 WHEN [Record_Status] = ''P'' THEN ''Proceed''
												 WHEN [Record_Status] = ''R'' THEN ''Resolve Conflict''
											END AS Status,
										    [Error_Message]						
											FROM DM_Title DMT 
											LEFT JOIN #TempKeyStarCast TKST ON DMT.DM_Title_Code = TKST.ID
											LEFT JOIN #TempTitleErrorMsg TCEM ON DMT.DM_Title_Code = TCEM.ID
											LEFT JOIN #TempDirector TD ON DMT.DM_Title_Code = TD.ID
											LEFT JOIN #TempMusicLabel TML ON DMT.DM_Title_Code = TML.ID
                                            where 1=1    										 
                                              '+ @Condition +'  '+@AdvanceSearch+' 
                                      )as XYZ  Where 1 = 1 
                             )as X  ' 
			                 
			Exec(@Sql)   
		 END
		 ELSE
		 BEGIN
			CREATE TABLE #ExcelSrNo (ExcelLineNo NVARCHAR(MAX))

			INSERT INTO #ExcelSrNo (ExcelLineNo)
			EXEC USP_Get_ExcelSrNo @DM_Master_Import_Code,@SearchCriteria,''
			
			DECLARE @Counter INT ,@TotalCounter INT, @ColNames NVARCHAR(MAX) = '', @BulkImp_ColNames NVARCHAR(MAX) = ''
			SELECT @TotalCounter = COUNT(*) + 1  FROM DM_Title_Import_Utility where Is_Active = 'Y'

			SET @Counter=1
			WHILE ( @Counter <= @TotalCounter)
			BEGIN
				SELECT @ColNames = @ColNames + 'COL'+ CAST(@Counter AS NVARCHAR(MAX))+', '
		  		SET @Counter  = @Counter  + 1
			END

			SELECT @ColNames = @ColNames + 'Record_Status, Error_Message'

			SET @Counter=1
			WHILE ( @Counter <= @TotalCounter + 2)
			BEGIN
				IF(@Counter < 10)
					SELECT @BulkImp_ColNames = @BulkImp_ColNames + 'COL0'+ CAST(@Counter AS NVARCHAR(MAX))+', '
				ELSE
					SELECT @BulkImp_ColNames = @BulkImp_ColNames + 'COL'+ CAST(@Counter AS NVARCHAR(MAX))+', '

		  		SET @Counter  = @Counter  + 1
			END

			SELECT @BulkImp_ColNames = LEFT(@BulkImp_ColNames, LEN(@BulkImp_ColNames) - 1)

			 EXEC ('
				  INSERT INTO #tempBulkImportExport_To_Excel('+ @BulkImp_ColNames +')				  
				  SELECT '+ @ColNames +'
				  FROM DM_Title_Import_Utility_Data WHERE DM_Master_Import_Code = '+@DM_Master_Import_Code+' 
				  AND (Col1 COLLATE Latin1_General_CI_AI IN (SELECT ExcelLineNo FROM #ExcelSrNo) OR COL1 = ''Excel Sr. No'')
			 ')

			DECLARE @Col1 INT= @TotalCounter + 1, @Col2 INT= @TotalCounter + 2
			EXEC ('
					UPDATE #tempBulkImportExport_To_Excel 
					SET COL'+ @Col1 +' = ''Record Status'', COL'+ @Col2 +' = ''Error Message'' where COL01 = ''Excel Sr. No''
			')

			 EXEC ('
				  UPDATE #tempBulkImportExport_To_Excel SET COL'+ @Col1 +' = 
				  CASE WHEN COL'+ @Col2 +' = ''Y'' THEN ''Ignore''
														 WHEN COL'+ @Col1 +' = ''C'' THEN ''Success''
														 WHEN COL'+ @Col1 +' = ''E'' THEN ''Error''
														 WHEN COL'+ @Col1 +' = ''N'' THEN ''No Error''
														 WHEN COL'+ @Col1 +' = ''P'' THEN ''Proceed''
														 WHEN COL'+ @Col1 +' = ''R'' THEN ''Resolve Conflict''
													END 
				   WHERE COL01 <> ''Excel Sr. No''
			')
		END

	    SELECT * FROM #tempBulkImportExport_To_Excel 
	END

	---- Music_Track
	IF(@File_Type = 'M')
	BEGIN
		IF(@DM_Master_Import_Code > 0) 
			set @Condition  += ' AND DMT.DM_Master_Import_Code  ='+ cast( @DM_Master_Import_Code as varchar)+'' 
		 IF(@SearchCriteria != '')
			set @Condition += ' AND ([Music_Title_Name]  Like ''' + @SearchCriteria + ''' OR [Movie_Album] Like ''' + @SearchCriteria + ''' OR [Music_Label] Like ''' + @SearchCriteria +
									  ''' OR [Title_Language] Like ''' + @SearchCriteria + ''' OR [Star_Cast] Like ''' + @SearchCriteria + ''' OR [Music_Album_Type] Like ''' + @SearchCriteria +
									  ''' OR [Singers] Like ''' + @SearchCriteria +''' OR [Genres] Like ''' + @SearchCriteria +''')'
		 IF(@Record_Status != '')
			set @Condition += ' AND [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter('''+@Record_Status+''', '''+ ',' +''') WHERE number != '''')'						         
		 IF(@Is_Ignore != '')
			set @Condition += ' AND [Is_Ignore] =''' + @Is_Ignore +''''
             
		IF(OBJECT_ID('TEMPDB..#TempSinger') IS NOT NULL)
			DROP TABLE #TempSinger
		IF(OBJECT_ID('TEMPDB..#TempStarCast') IS NOT NULL)
			DROP TABLE #TempStarCast
		IF(OBJECT_ID('TEMPDB..#TempErrorMsg') IS NOT NULL)
			DROP TABLE #TempErrorMsg
		IF(OBJECT_ID('TEMPDB..#TempLanguage') IS NOT NULL)
			DROP TABLE #TempLanguage 
         	
		CREATE TABLE #TempStarCast
		(
			ID INT,		
			StarCast NVARCHAR(MAX)			
		)
		CREATE TABLE #TempSinger
		(
			ID INT,
			Singer NVARCHAR(MAX)
		)
		CREATE TABLE #TempErrorMsg
		(
			ID INT,		
			ErrorMessage NVARCHAR(MAX)			
		)
		CREATE TABLE #TempLanguage
		(
			ID INT,
			Language NVARCHAR(MAX)
		)

		INSERT INTO #TempStarCast(ID, StarCast)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS StarCast from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Star_Cast],',') 
		WHERE LTRIM(RTRIM(ISNULL([Star_Cast], ''))) <> ''
			
		INSERT INTO #TempSinger(ID, Singer)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Singers from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Singers],',') 
		WHERE LTRIM(RTRIM(ISNULL([Singers], ''))) <> '' 
		
		INSERT INTO #TempErrorMsg(ID, ErrorMessage)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS ErrorMsg from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
		WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> '' 

		INSERT INTO #TempLanguage(ID, Language)
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Language from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Title_Language, ''))) <> '' 
		AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

		INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20)				  
		SELECT 'Excel Line No', 'Music Track', 'Length', 'Movie/Album', 'Singers', 'Lyricist', 'Music Composer',' Music Language', 'Music Label',
						   'Year of Release', 'Genres','Song Star Cast', 'Music Version', 'Effective Start Date', ' Music Theme', 'Music Tag', 'Movie Star Cast', 'Music Album Type',
						   'Status', 'Error Message'

		Declare @Sql1 NVARCHAR(MAX)

		Set @Sql1 =  '
			        INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18, COL19, COL20)				  
					SELECT [Excel_Line_No], [Music_Title_Name], [Duration], [Movie_Album], [Singers], [Lyricist], [Music_Director], [Title_Language], [Music_Label],
						   [Year_of_Release], [Genres], [Star_Cast], [Music_Version], [Effective_Start_Date], [Theme], [Music_Tag], [Movie_Star_Cast], [Music_Album_Type],
						   Status, [Error_Message] from
						   (
						      Select * FROM
							  (
								SELECT distinct [IntCode], [Excel_Line_No], [Music_Title_Name], [Duration], [Movie_Album], [Singers], [Lyricist], [Music_Director], [Title_Language], [Music_Label],
								[Year_of_Release], [Genres], [Star_Cast], [Music_Version], [Effective_Start_Date], [Theme], [Music_Tag], [Movie_Star_Cast], [Music_Album_Type],
									CASE WHEN [Is_Ignore] = ''Y'' THEN ''Ignore''
												 WHEN [Record_Status] = ''C'' THEN ''Success''
											     WHEN [Record_Status] = ''E'' THEN ''Error''
											     WHEN [Record_Status] = ''N'' THEN ''No Error''
												 WHEN [Record_Status] = ''P'' THEN ''Proceed''
												 WHEN [Record_Status] = ''R'' THEN ''Resolve Conflict''
											END AS Status,
											[Error_Message]
								            FROM DM_Music_Title DMT
										    LEFT JOIN #TempErrorMsg TEM ON DMT.IntCode = TEM.ID 
											LEFT JOIN #TempSinger TS ON DMT.IntCode = TS.ID
											LEFT JOIN #TempStarCast TST ON DMT.IntCode = TST.ID
											LEFT JOIN #TempLanguage TL ON DMT.IntCode = TL.ID
											where 1=1    										 
                                              '+ @Condition +'  '+@AdvanceSearch+' 
                                      )as XYZ  Where 1 = 1 
                             )as X   '			
		Exec(@Sql1)				
		SELECT *  FROM #tempBulkImportExport_To_Excel 
	END

	-- Content
	IF(@File_Type = 'C')
	BEGIN
		 IF(@DM_Master_Import_Code > 0) 
			set @Condition  += ' AND DCM.DM_Master_Import_Code  ='+ cast( @DM_Master_Import_Code as varchar)+'' 
         IF(@SearchCriteria != '')
			set @Condition += ' AND ([Content_Name] Like ''' + @SearchCriteria + ''' OR [Episode_No] Like ''' + @SearchCriteria + ''' OR [Music_Track] Like ''' + @SearchCriteria +''')'
		 IF(@Record_Status != '')
			set @Condition += ' AND [Record_Status] IN (Select LTRIM(RTRIM(number)) from dbo.fn_Split_withdelemiter('''+@Record_Status+''', '''+ ',' +''') WHERE number != '''')'						         
		 IF(@Is_Ignore != '')
			set @Condition += ' AND DCM.[Is_Ignore] =''' + @Is_Ignore +''''

	     IF(OBJECT_ID('TEMPDB..#TempContentErrorMsg') IS NOT NULL)
			 DROP TABLE #TempContentErrorMsg
		 IF(OBJECT_ID('TEMPDB..#TempMusicTitle') IS NOT NULL)
			 DROP TABLE #TempMusicTitle
        			  
		 CREATE TABLE #TempContentErrorMsg
		 (
			 ID INT,
			 ErrorMsg NVARCHAR(MAX)
		 )

		 IF(OBJECT_ID('TEMPDB..#TempMasterImportCode') IS NOT NULL)
			 DROP TABLE #TempMasterImportCode	
        			
		 INSERT INTO #TempContentErrorMsg(ID, ErrorMsg)
		 SELECT DCM.IntCode, LTRIM(RTRIM(number)) AS ErrorMsg from DM_Content_Music DCM
		 CROSS APPLY dbo.fn_Split_withdelemiter([Error_Message],'~') 
		 WHERE LTRIM(RTRIM(ISNULL([Error_Message], ''))) <> '' 

		 SELECT * INTO #TempMasterImportCode 
		 FROM(
		 SELECT @DM_Master_Import_Code as DM_Master_Import_Code ,Name ,Master_Type,Master_Code,User_Action,Action_By,Action_On,Roles,Is_Ignore,Mapped_By  FROM DM_Master_Log where DM_Master_Import_Code LIKE '~' + CAST(@DM_Master_Import_Code AS VARCHAR) + '~'
		 UNION
		 SELECT @DM_Master_Import_Code as DM_Master_Import_Code,Name,Master_Type,Master_Code,User_Action,Action_By,Action_On,Roles,Is_Ignore,Mapped_By  FROM DM_Master_Log where DM_Master_Import_Code = CAST(@DM_Master_Import_Code AS VARCHAR)
		 ) as a
			
		 SELECT Distinct DCM.IntCode, MT.Music_Title_Name Into #TempMusicTitle FROM DM_Content_Music DCM 
		 LEFT JOIN #TempMasterImportCode DML ON DCM.DM_Master_Import_Code = DML.DM_Master_Import_Code
		 LEFT JOIN Music_Title MT ON MT.Music_Title_Code = DML.Master_Code
		 Where DML.DM_Master_Import_Code = @DM_Master_Import_Code AND DCM.Music_Track IN (DML.Name)

         INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18)
		 Select  'Int Code', 'Excel Line No','Content Name','Episode No',' Version Name','Music Track', 'From',
				                'To', 'From Frame', 'To Frame', 'Duration', 'Duration Frame', 'Status', 'Error Message', 'Mapped To', 'Mapped By', 'Action By', 'Mapped Date'

		 Declare @SqlQuery NVARCHAR(MAX)

		 Set @SqlQuery =  '	
			            INSERT INTO #tempBulkImportExport_To_Excel(COL01, COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18)
						 Select  distinct [IntCode], [Excel_Line_No],[Content_Name],[Episode_No], [Version_Name], [Music_Track], [From]
				                  ,[To], [From_Frame], [To_Frame], [Duration], [Duration_Frame], Status, [Error_Message], [MappedTo], [MappedBy], [ActionBy], [MappedDate]   From      
                            (      
                                select distinct * from (      
                                    select distinct DCM.[IntCode], DCM.[Excel_Line_No], DCM.[Content_Name], DCM.[Episode_No], DCM.[Version_Name],  DCM.[Music_Track], DCM.[From]    
										     ,DCM.[To], DCM.[From_Frame], DCM.[To_Frame], DCM.[Duration], DCM.[Duration_Frame],
											CASE WHEN DCM.[Is_Ignore] = ''Y'' THEN ''Ignore''
												 WHEN DCM.[Record_Status] = ''C'' THEN ''Success''
											     WHEN DCM.[Record_Status] = ''E'' THEN ''Error''
											     WHEN DCM.[Record_Status] = ''N'' THEN ''No Error''
												 WHEN DCM.[Record_Status] = ''P'' THEN ''Proceed''
												 WHEN (DCM.[Record_Status] = ''OR'' OR DCM.[Record_Status] = ''MR'' OR DCM.[Record_Status] = ''SM'' OR DCM.[Record_Status] = ''MO'' OR DCM.[Record_Status] = ''SO'') THEN ''Resolve Conflict''  
											END AS Status,
											DCM.[Error_Message], T.Music_Title_Name as MappedTo, 
											CASE WHEN (DML.Mapped_By = ''U'' AND DML.Master_Code IS NOT NULL) THEN ''Users''
											WHEN ((DML.Mapped_By = ''S'' OR DML.Mapped_By = ''V'') AND DML.Master_Code IS NOT NULL) THEN ''System''
											END AS MappedBy,
											CASE WHEN (DML.Mapped_By = ''U'' AND DML.Master_Code IS NOT NULL) THEN U.First_Name
											ELSE '''' END as ActionBy,
											CASE WHEN DML.Master_Code IS NOT NULL THEN DML.Action_On
											ELSE NULL END as MappedDate
                                            FROM DM_Content_Music  DCM		
											LEFT JOIN #TempMasterImportCode DML ON  DCM.DM_Master_Import_Code  =  DML.DM_Master_Import_Code 
											LEFT Join Users U ON DML.Action_By  = U.Users_Code 
											LEFT JOIN #TempMusicTitle T ON T.IntCode = DCM.IntCode
											LEFT JOIN #TempContentErrorMsg TCEM ON DCM.IntCode = TCEM.ID																																
                                            where 1=1    										 
                                              '+ @Condition +'  '+@AdvanceSearch+' 											
                                      )as XYZ where 1=1
                             )as X '			 
		  Exec(@SqlQuery)   
		SELECT COL02, COL03, COL04, COL05, COL06, COL07, COL08, COL09, COL10, COL11, COL12, COL13, COL14, COL15, COL16, COL17, COL18 FROM #tempBulkImportExport_To_Excel 
	END

	IF OBJECT_ID('tempdb..#tempBulkImportExport_To_Excel') IS NOT NULL DROP TABLE #tempBulkImportExport_To_Excel
	IF OBJECT_ID('tempdb..#TempContentErrorMsg') IS NOT NULL DROP TABLE #TempContentErrorMsg
	IF OBJECT_ID('tempdb..#TempDirector') IS NOT NULL DROP TABLE #TempDirector
	IF OBJECT_ID('tempdb..#TempErrorMsg') IS NOT NULL DROP TABLE #TempErrorMsg
	IF OBJECT_ID('tempdb..#TempKeyStarCast') IS NOT NULL DROP TABLE #TempKeyStarCast
	IF OBJECT_ID('tempdb..#TempLanguage') IS NOT NULL DROP TABLE #TempLanguage
	IF OBJECT_ID('tempdb..#TempMasterImportCode') IS NOT NULL DROP TABLE #TempMasterImportCode
	IF OBJECT_ID('tempdb..#TempMusicLabel') IS NOT NULL DROP TABLE #TempMusicLabel
	IF OBJECT_ID('tempdb..#TempMusicTitle') IS NOT NULL DROP TABLE #TempMusicTitle
	IF OBJECT_ID('tempdb..#TempSinger') IS NOT NULL DROP TABLE #TempSinger
	IF OBJECT_ID('tempdb..#TempStarCast') IS NOT NULL DROP TABLE #TempStarCast
	IF OBJECT_ID('tempdb..#TempTitleErrorMsg') IS NOT NULL DROP TABLE #TempTitleErrorMsg
END

--Select * from DM_Title where [Title Type] = 'Program'
--Select * from DM_Music_Title
--Select * from DM_Content_Music
--AND [Content_Name] IN (SELECT LTRIM(RTRIM(number)) AS MusicTrack from dbo.fn_Split_withdelemiter(''William Brent Bell,GOT'','','') WHERE LTRIM(RTRIM(ISNULL(''William Brent Bell,GOT'',''''))) <> '''')
--AND [Music_Track] collate SQL_Latin1_General_CP1_CI_AS IN (SELECT LTRIM(RTRIM(number)) AS MusicTrack from dbo.fn_Split_withdelemiter(''Rani Padmavati'','','') WHERE LTRIM(RTRIM(ISNULL(''Rani Padmavati'',''''))) <> '''')
--AND TCEM.ErrorMsg IN (''Sr. No cannot be blank'',''Music Track cannot be blank'')
--AND [Music_Title_Name] IN(''Malamaal2'',''Rabba12'')

--exec USPExportToExcelBulkImport 7476,'','T',''
--select * from DM_Master_Log 

--select * from DM_Content_Music where DM_Master_Import_Code = 6272

--SELECT DCM.IntCode, DCM.Music_Track, MT.Music_Title_Name FROM DM_Content_Music DCM 
--INNER JOIN DM_Master_Log DML ON DCM.DM_Master_Import_Code = DML.DM_Master_Import_Code
--INNER JOIN Music_Title MT ON MT.Music_Title_Code = DML.Master_Code
--Where DML.DM_Master_Import_Code = 8091 AND DCM.Music_Track IN (DML.Name)

--SELECT * FROM DM_Master_Log DML Where DML.DM_Master_Import_Code = 8078
--SELECT * FROM DM_Content_Music DCM Where DCM.DM_Master_Import_Code = 6960