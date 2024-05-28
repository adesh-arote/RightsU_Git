
ALTER PROCEDURE USPExportToExcelBulkImport
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
		COL25 NVARCHAR(MAX)
	)
	
	--- Title
	IF(@File_Type = 'T')
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