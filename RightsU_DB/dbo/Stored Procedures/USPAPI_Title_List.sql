CREATE PROCEDURE [dbo].[USPAPI_Title_List]
	@order VARCHAR(10) = NULL,
	@page INT = NULL,
	@search_value NVARCHAR(MAX) = NULL,
	@size INT = NULL,
	@sort VARCHAR (100) = NULL,
	@date_gt VARCHAR(50) = NULL,
	@date_lt VARCHAR(50) = NULL,
	@RecordCount INT = NULL OUT,
	@id INT = NULL
AS
	
BEGIN
print @size

	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_API_Title_List]', 'Step 1', 0, 'Started Procedure', 0, '' 

	--IF(ISNULL(@id,0)>0)
	--BEGIN
	--	IF(ISNULL(@order,'')='')
	--		SET @order = 'DESC'
	--	IF(ISNULL(@page,'')='')
	--		SET @page = 1
	--	IF(ISNULL(@size,'')='')
	--		SET @size = 50
	--	IF(ISNULL(@sort,'')='')
	--		SET @sort = 'Last_UpDated_Time'		
	--END
	--ELSE
	--BEGIN
	--	IF(ISNULL(@id,0)=0)
	--		SET @id = 0
	--END
	

	PRINT 'Order : '+@order
	PRINT 'Page : '+CAST(@page as VARCHAR)
	PRINT 'Size : '+CAST(@size as VARCHAR)
	PRINT 'Sort : '+@sort
	PRINT 'ID : '+CAST(@id as VARCHAR)


	DECLARE @Condition NVARCHAR(MAX) = ' AND ISNULL(T.Reference_Key,'''') = '''' AND  ISNULL(T.Reference_Flag,'''') = '''' '      
	DECLARE @delimt NVARCHAR(2) = N'﹐'      

	SET @Condition  += ' '
	if(@page = 0)
	BEGIN
		SET @page = 1      
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
	CREATE TABLE #Temp (      
		Id Int Identity(1,1),      
		RowId Varchar(200),  
		Title_Name  Varchar(200),  
		Language_Name  Varchar(200),  
		Sort varchar(10),  
		Row_Num Int,  
		Last_Updated_Time datetime,
		Inserted_On datetime  
	);  
	
	DECLARE @SQL_Condition NVARCHAR(MAX)
	SET @SQL_Condition =''
	
	IF(ISNULL(@id,0) = 0)
	BEGIN
		
		IF(ISNULL(@search_value,'')<>'')
		BEGIN
			SET @SQL_Condition ='AND (T.Deal_Type_Code IN (SELECT DT.Deal_Type_Code FROM Deal_Type DT WHERE Deal_Type_Name LIKE N''%' + @search_value+ '%'') OR T.Title_Language_Code IN(SELECT L.Language_Code FROM [Language] L WHERE Language_Name Like N''%' + @search_value + '%'') OR T.Title_Name Like N''%' + @search_value + '%'' OR T.Program_Code IN (SELECT P.Program_Code FROM [Program] P WHERE P.Program_Name Like N''%' + @search_value + '%'') OR T.Original_Title Like N''%' + @search_value +'%'')'
		END

		IF(ISNULL(@date_gt,'')<>'' AND ISNULL(@date_lt,'')<>'')
		BEGIN
			SET @SQL_Condition +=' AND CAST(T.Inserted_On AS DATE) BETWEEN '''+@date_gt+''' AND '''+@date_lt+''''
		END
		ELSE IF(ISNULL(@date_gt,'')<>'')
		BEGIN
			SET @SQL_Condition +=' AND CAST(T.Inserted_On AS DATE) >= '''+@date_gt+''''
		END
		ELSE IF(ISNULL(@date_lt,'')<>'')
		BEGIN
			SET @SQL_Condition +=' AND CAST(T.Inserted_On AS DATE) <= '''+@date_lt+''''
		END
		
	END
	ELSE
	BEGIN
		SET @SQL_Condition +=' AND T.Title_Code = '+CAST(@id as VARCHAR(20))
		PRINT @SQL_Condition
	END

	Declare @SqlPageNo NVARCHAR(MAX)      

	SET @SqlPageNo = '      
					WITH Y AS (      
								Select distinct X.Title_Code,X.Title_Name,X.Language_Name,X.Last_UpDated_Time,X.Inserted_On From      
								(      
									select * from (      
										select distinct Title_Code, T.Original_Title, T.Title_Name, T.Title_Code_Id, T.Synopsis, T.Original_Language_Code, T.Title_Language_Code      
												,T.Year_Of_Production,P.Program_Name, T.Duration_In_Min, T.Deal_Type_Code, T.Grade_Code, T.Reference_Key, T.Reference_Flag, T.Is_Active      
												,T.Inserted_By, T.Inserted_On, T.Last_UpDated_Time, T.Last_Action_By, T.Lock_Time, T.Title_Image, L.Language_Name   
												from Title T    (NOLOCK)   
												INNER join Deal_Type DT (NOLOCK) on DT.Deal_Type_Code = T.Deal_Type_Code  
												INNER join Language L  (NOLOCK) on T.Title_Language_Code = L.Language_Code  
												LEFT JOIN MAP_Extended_Columns MEC (NOLOCK) ON T.Title_Code = MEC.Record_Code
												LEFT JOIN  Extended_Columns_Value ECV (NOLOCK) ON MEC.Columns_Code = ECV.Columns_Code
												LEFT JOIN Program P  (NOLOCK) ON T.Program_Code = P.Program_Code  
												where 1=1       
												'+ @Condition +'  '+@SQL_Condition+'   
											)as XYZ Where 1 = 1      
									)as X      
								)      
					Insert InTo #Temp Select Title_Code,Title_Name,Language_Name,''1'','' '',Last_UpDated_Time,Inserted_On From Y'      
    
	EXEC (@SqlPageNo)

	

	SET @search_value = '%'+@search_value+'%'  
	UPDATE #Temp SET Sort = '0' WHERE Title_name LIKE @search_value OR Language_Name LIKE @search_value
	
	DELETE FROM T FROM #Temp T INNER JOIN  
	(  
		SELECT ROW_NUMBER()OVER(PARTITION BY RowId ORDER BY Sort ASC) RowNum, Id, RowId, Sort FROM #Temp  
	)a On T.Id = a.Id and a.RowNum <> 1  
	Select @RecordCount = Count(DISTINCT (RowId )) FROM #Temp
	
	SET @sort = @sort+' '+@order
	
	DECLARE @UpdateRowNum NVARCHAR(MAX)=''
	SET @UpdateRowNum ='
	UPDATE a   
		SET a.Row_Num = b.Row_Num  
	FROM #Temp a  
	INNER JOIN (  		   
		SELECT DENSE_RANK() OVER(ORDER BY Sort ASC,'+ @sort+', RowId ASC) Row_Num, ID FROM #Temp  
	) AS b ON a.Id = b.Id  
	'
	EXEC(@UpdateRowNum)
	
	DELETE FROM #Temp WHERE Row_Num < (((@page - 1) * @size) + 1) Or Row_Num > @page * @size     

	Declare @Sql_1  NVARCHAR(MAX) ,@Sql_2 NVARCHAR(MAX)      
		
	Set @Sql_1 = '      
				SELECT Title_Name as Name, Original_Title as OriginalName, Title_Code as Id, Language_Name as Language, Year_Of_Production as ProductionYear, Program_Name as Program1, CountryName as Country1, Original_Language as OriginalLanguage1,TitleTalent1, TalentName as StarCast1, Producer as Producer1, Director as Director1, Title_Image      
				,Is_Active, Deal_Type_Code, Deal_Type_Name as AssetType1, Synopsis, Genre as Genre1,Duration_In_Min as DurationInMin      
				FROM (      
					SELECT distinct T.Title_Name,T.Original_Title,T.Title_Code,T.Synopsis ,CONCAT(CAST(L.Language_Code AS VARCHAR),'':'',L.Language_Name) as Language_Name ,CONCAT(CAST(OL.Language_Code AS VARCHAR),'':'',OL.Language_Name) as Original_Language    
				   ,T.Year_Of_Production
				   ,CONCAT(CAST(p.Program_Code AS VARCHAR),'':'',p.Program_Name) as Program_Name
				   ,T.Duration_In_Min      
				   ,REVERSE(stuff(reverse(stuff(      
								(         
									select cast(CONCAT(CAST(TC.Title_Country_Code AS VARCHAR),'':'',CAST(C.Country_Code AS VARCHAR),'':'', C.Country_Name)  as NVARCHAR(MAX)) + ''@ '' from Title_Country TC  (NOLOCK)     
									inner join Country C (NOLOCK) on C.Country_Code = TC.Country_Code      
									where TC.Title_Code = T.Title_Code      
									FOR XML PATH(''''), root(''CountryName''), type      
								).value(''/CountryName[1]'',''Nvarchar(max)''      
								),2,0, ''''      
							)      
				   ),1,2,'''')) as CountryName
				   ,REVERSE(stuff(reverse(  stuff(      
								(         
									select cast(CONCAT(CAST(TT.Title_Talent_Code AS VARCHAR),'':'',Tal.Talent_Name,'':'',R.Role_Name,'':'',CAST(Tal.Talent_Code AS VARCHAR),'':'',CAST(TT.Role_Code AS VARCHAR))  as NVARCHAR(MAX)) + ''@ '' from Title_Talent TT    (NOLOCK)   
									inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
									inner join Talent Tal  (NOLOCK) on tal.talent_Code = TT.Talent_code      
									where TT.Title_Code = T.Title_Code --AND R.Role_Code in (2)      
      
									FOR XML PATH(''''), root(''TalentName''), type      
								).value(''/TalentName[1]'',''NVARCHAR(max)''      
								),2,0, ''''      
							)      
				   ),1,2,'''')) as TitleTalent1
				   ,REVERSE(stuff(reverse(  stuff(      
								(         
									select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT    (NOLOCK)   
									inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
									inner join Talent Tal  (NOLOCK) on tal.talent_Code = TT.Talent_code      
									where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
      
									FOR XML PATH(''''), root(''TalentName''), type      
								).value(''/TalentName[1]'',''NVARCHAR(max)''      
								),1,0, ''''      
							)      
				   ),1,2,'''')) as TalentName      
				   ,REVERSE(stuff(reverse(  stuff(      
								(         
									select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT   (NOLOCK)    
									inner join Role R (NOLOCK) on R.Role_Code = TT.Role_Code      
									inner join Talent Tal  (NOLOCK) on tal.talent_Code = TT.Talent_code      
									where TT.Title_Code = T.Title_Code AND R.Role_Code in (4)      
      
									FOR XML PATH(''''), root(''Producer''), type      
								).value(''/Producer[1]'',''NVARCHAR(max)''      
								),1,0, ''''      
							)      
				   ),1,2,'''')) as Producer      
				   ,REVERSE(stuff(reverse(  stuff(      
								(         
									select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT    (NOLOCK)   
									inner join Role R (NOLOCK) on R.Role_Code = TT.Role_Code      
									inner join Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
									where TT.Title_Code = T.Title_Code AND R.Role_Code in (1)      
      
									FOR XML PATH(''''), root(''Director''), type      
								).value(''/Director[1]'',''NVARCHAR(max)''      
								),1,0, ''''      
							)      
				   ),1,2,'''')) as Director      
				   --, [dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genre
				   ,REVERSE(stuff(reverse(stuff(      
								(         
									select cast(CONCAT(CAST(TG.Title_Geners_Code AS VARCHAR),'':'',CAST(G.Genres_Code AS VARCHAR),'':'', G.Genres_Name)  as NVARCHAR(MAX)) + ''@ '' from Title_Geners TG  (NOLOCK)     
									inner join Genres G (NOLOCK) on G.Genres_Code = TG.Genres_Code      
									where TG.Title_Code = T.Title_Code      
									FOR XML PATH(''''), root(''GenresName''), type      
								).value(''/GenresName[1]'',''Nvarchar(max)''      
								),2,0, ''''      
							)      
				   ),1,2,'''')) as Genre
				   
				   , ISNULL(T.Title_Image,'' '') As Title_Image, T.Last_UpDated_Time, T.Inserted_On      
				   ,Case When T.Is_Active=''Y'' then ''Active'' Else ''Deactive'' END AS Is_Active, T.Deal_Type_Code
				   ,CONCAT(CAST(DT.Deal_Type_Code AS VARCHAR),'':'',DT.Deal_Type_Name) as Deal_Type_Name				   
				   , Tmp.Row_Num'
	SET @Sql_2 ='	        
			from Title T   (NOLOCK)  
			INNER join Deal_Type DT (NOLOCK) on DT.Deal_Type_Code = T.Deal_Type_Code     
			LEFT join [Language] L (NOLOCK) on T.Title_Language_Code  = L.Language_Code   
			LEFT join [Language] OL (NOLOCK) on T.Original_Language_Code  = OL.Language_Code    
			LEFT JOIN MAP_Extended_Columns MEC  (NOLOCK) ON T.Title_Code = MEC.Record_Code
			LEFT JOIN  Extended_Columns_Value ECV  (NOLOCK) ON MEC.Columns_Code = ECV.Columns_Code
			LEFT join Title_Country TC (NOLOCK) on T.Title_Code = TC.Title_Code   
		 INNER JOIN #Temp Tmp on T.Title_Code = Tmp.RowId    
		 left join Program P on T.Program_code = P.Program_Code   
			  where 1=1  '+ @Condition +'  '+@SQL_Condition+' 
				  ) tbl  
				WHERE tbl.Title_Code in (Select RowId From #Temp)      
				ORDER BY tbl.'+@sort+' 
			'
			--+' '+@order+			

	Exec(@Sql_1 + @Sql_2)      

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp         

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_API_Title_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END
