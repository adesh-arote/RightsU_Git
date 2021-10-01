CREATE PROCEDURE [dbo].[USP_Title_Objection_ADV_List]      
(      
	 @StrSearch NVARCHAR(Max),      
	 @Type NVARCHAR(100),      
	 @PageNo Int=1,      
	 @OrderByCndition Varchar(100)='Title_Objection_Code desc',      
	 @IsPaging Varchar(2)='Y',      
	 @PageSize Int=50,      
	 @RecordCount Int Out,      
	 @User_Code INT=143,      
	 @ExactMatch varchar(max) = ''      
)      
As    
BEGIN      
 --SET @OrderByCndition = N'Last_Updated_Time DESC'      
      
	 IF(@PageNo = 0)      
	  SET @PageNo = 1      
      
	 IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp      
	 IF OBJECT_ID('tempdb..#Filter') IS NOT NULL DROP TABLE #Filter    
	 IF OBJECT_ID('tempdb..#AcqSynData') IS NOT NULL DROP TABLE #AcqSynData    
	 IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData      
	 IF OBJECT_ID('tempdb..#Type') IS NOT NULL DROP TABLE #Type    
      
	 Create Table #Temp(      
		  Id INT IDENTITY(1,1),      
		  Record_Code INT,    
		  Title_Objection_Code VARCHAR(200),       
		  Title_name  VARCHAR(200),      
		  Sort VARCHAR(10),      
		  Row_Num INT,      
		  Last_Updated_Time DATETIME      
	 );      
    
	 Create Table #TempData(      
		  Id INT IDENTITY(1,1),      
		  Record_Code INT,    
		  Agreement_No NVARCHAR(MAX),    
		  Vendor_Name VARCHAR(200),    
		  Title_Objection_Code VARCHAR(200),       
		  Title_name  VARCHAR(200),      
		  Sort VARCHAR(10),      
		  Row_Num INT,      
		  Last_Updated_Time DATETIME      
	  );      
    
	 Create Table #Type(    
		 Deal_Type VARCHAR(100),    
	 )    
    
	 Create table #AcqSynData(    
		  Title_Objection_Code INT,    
		  Deal_Code INT,    
		  Title_Code INT,    
		  Agreement_No VARCHAR(MAX),    
		  Title_Name VARCHAR(MAX),    
		  Deal_Desc NVARCHAR(MAX),    
		  Vendor_Name VARCHAR(200),    
		  Objection_Type_Name VARCHAR(MAX),    
		  Agreement_Date DATETIME,    
		  CountryDetails VARCHAR(MAX),    
		  Objection_Status VARCHAR(MAX),    
		  SORT INT,    
		  Last_Updated_Time Datetime    
	 )    
    
	 Create table #Filter(    
		  Title_Objection_Code INT,    
		  Deal_Code INT,    
		  Title_Code INT,    
		  Agreement_No VARCHAR(MAX),    
		  Title_Name VARCHAR(MAX),    
		  Deal_Desc NVARCHAR(MAX),    
		  Vendor_Name VARCHAR(200),    
		  Objection_Type_Name VARCHAR(MAX),    
		  Agreement_Date DATETIME,    
		  CountryDetails VARCHAR(MAX),    
		  Objection_Status VARCHAR(MAX),    
		  SORT INT,    
		  Last_Updated_Time Datetime    
	 )    
      
	  Declare @SqlPageNo NVARCHAR(MAX),@SqlPageNo1 NVARCHAR(MAX)--,@Type Varchar(100)= 'A,S',@ExactMatch varchar(max) = '',@RecordCount Int = 10,@IsPaging VARCHAR(10)= 'Y',@PageNo Int=1,@PageSize Int=14  
	  --,@StrSearch NVARCHAR(Max) = 'AND T.Title_Code IN(2297)' --AND V.Vendor_Code IN(527)AND TOS.Title_Objection_Status_Code IN(2)AND Objection_Type_Code IN(7)    
    
	  INSERT INTO #Type(Deal_Type)    
	  SELECT number FROM dbo.fn_Split_withdelemiter(@Type,',')    
    
	  set @SqlPageNo = N'      
				WITH Y AS (      
				Select distinct x.Title_Objection_Code,X.Record_Code,X.Title_Name,X.Last_Updated_Time From       
				(      
				select * from (      
				Select distinct TOB.Title_Objection_Code      
				,TOB.Objection_Start_Date      
				,TOB.Record_Code    
				,TOB.[last_updated_time]                
				,TOS.Objection_Status_Name               
				,T.Title_Name      
				FROM Title_Objection TOB WITH(NOLOCK)      
				INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code       
				Inner Join Title T WITH(NOLOCK) On TOB.Title_Code = T.Title_Code      
				)as XYZ Where 1=1       
				)as X      
			)      
			Insert InTo #Temp Select Title_Objection_Code,Record_Code,Title_name,''1'','' '',Last_Updated_Time From Y'      
    
	 PRINT (@SqlPageNo)      
	 EXEC (@SqlPageNo)      
    
	  IF(@Type = 'A')    
	  BEGIN    
		  set @SqlPageNo = N'      
				WITH Y AS (      
				Select distinct x.Title_Objection_Code,X.Record_Code,X.Title_Name,X.Last_Updated_Time,X.Agreement_No,X.Vendor_Name From       
				(      
				select * from (      
				Select distinct TOB.Title_Objection_Code      
				,TOB.Objection_Start_Date      
				,TOB.Record_Code    
				,AD.Acq_Deal_Code    
				,AD.Agreement_No    
				,V.Vendor_Name    
				,TOB.[last_updated_time]  
				,TOS.Objection_Status_Name          
				,T.Title_Name      
				FROM Title_Objection TOB WITH(NOLOCK)      
				INNER JOIN Acq_Deal AD ON TOB.Record_Code =  AD.Acq_Deal_Code    
				INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code    
				INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code 
				Inner Join Title T WITH(NOLOCK) On TOB.Title_Code = T.Title_Code     
				WHERE TOB.Record_Type = ''A''
				)as XYZ Where 1=1       
			   )as X      
			   )      
			  Insert InTo #TempData Select Record_Code,Agreement_No,Vendor_Name,Title_Objection_Code,Title_name,''1'','' '',Last_Updated_Time From Y'      
    
		PRINT (@SqlPageNo)      
		EXEC (@SqlPageNo)    
		PRINT '1'    

		Set @ExactMatch = '%'+@ExactMatch+'%'    
		Update #TempData Set Sort = '0' Where Title_name like @ExactMatch OR Vendor_Name like @ExactMatch  OR Agreement_no like @ExactMatch     
		 
		 IF(@ExactMatch IS NOT NULL OR @ExactMatch != '')
		 BEGIN
			DELETE FROM #TempData WHERE (Title_name NOT like @ExactMatch) AND (Vendor_Name NOT like @ExactMatch)  AND (Agreement_no NOT like @ExactMatch)
		 END
    
		PRINT '2'    
		--delete from T From #TempData T Inner Join    
		--(    
		-- Select ROW_NUMBER()Over(Partition By AgreeMent_No Order By Sort asc) RowNum, Id, Agreement_No, Sort From #TempData    
		--)a On T.Id = a.Id and a.RowNum <> 1    
     
		PRINT '3'    
		if(@StrSearch = '' OR @StrSearch IS NULL)
		BEGIN
		  Select @RecordCount = Count( (AgreeMent_No )) From #TempData 
		END
		Update a     
		Set a.Row_Num = b.Row_Num From #TempData a    
		Inner Join (Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, agreement_no ASC) Row_Num, ID From #TempData    
		) As b On a.Id = b.Id    
       
		 If(@IsPaging = 'Y')    
		 Begin    
		  Delete From #TempData Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize     
		 End     
    
		  SET @SqlPageNo1=  'INSERT INTO #AcqSynData(Title_Objection_Code,Deal_Code,Title_Code,Agreement_No,Title_Name,Deal_Desc,Vendor_Name,Objection_Type_Name,Agreement_Date,CountryDetails,Objection_Status,SORT,Last_Updated_Time)    
		  SELECT DISTINCT TOB.Title_Objection_Code,AD.Acq_Deal_Code AS Deal_Code,T.Title_Code,AD.Agreement_No,T.Title_Name,AD.Deal_Desc,V.Vendor_Name,TOT.Objection_Type_Name,AD.Agreement_Date      
		  ,dbo.UFN_Get_Title_Objection_Territory(TOB.Title_Objection_Code) CountryDetails,TOS.Objection_Status_Name Status,Tm.Sort,TOB.Last_Updated_Time    
		  FROM Title_Objection TOB         
		  INNER JOIN Title_Objection_Type TOT ON TOB.Title_Objection_Type_Code = TOT.Objection_Type_Code         
		  INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code        
		  INNER JOIN Title T ON TOB.Title_Code = T.Title_Code        
		  INNER JOIN Acq_Deal AD ON TOB.Record_Code = AD.Acq_Deal_Code        
		  INNER JOIN Vendor v WITH(NOLOCK) on AD.Vendor_Code = v.vendor_code        
		  INNER JOIN #TempData Tm on TOB.Title_Objection_Code = Tm.Title_Objection_Code        
		  WHERE TOB.Record_Type Collate Latin1_General_CI_AI IN(SELECT Deal_Type FROM #Type) '+@StrSearch+' ORDER BY Sort,TOB.Last_Updated_Time    
		  '     
		  PRINT(@SqlPageNo1)    
		  EXEC (@SqlPageNo1)    
    
		  INSERT INTO #Filter    
		  SELECT DISTINCT * FROM #AcqSynData  

		  if(@StrSearch != '' OR @StrSearch IS NOT NULL)
		  BEGIN
			Select @RecordCount = Count( (Title_Objection_Code )) From #AcqSynData  
		  END
 

		  SELECT Title_Objection_Code,Deal_Code AS Deal_Code,Title_Code,Agreement_No,Title_Name,Deal_Desc,Vendor_Name As Vendor_Name,Objection_Type_Name,Agreement_Date,      
		  CountryDetails,Objection_Status AS Status  FROM #Filter ORDER By SORT , Last_Updated_Time  DESC  
     
	  END    
	 ELSE IF(@Type = 'S')    
	  BEGIN    
		  set @SqlPageNo = N'      
				WITH Y AS (      
				Select distinct x.Title_Objection_Code,X.Record_Code,X.Title_Name,X.Last_Updated_Time,X.Agreement_No,X.Vendor_Name From       
				(      
				select * from (      
				Select distinct TOB.Title_Objection_Code      
				,TOB.Objection_Start_Date      
				,TOB.Record_Code    
				,SD.Syn_Deal_Code    
				,SD.Agreement_No    
				,V.Vendor_Name    
				,TOB.[last_updated_time]                
				,TOS.Objection_Status_Name               
				,T.Title_Name      
				FROM Title_Objection TOB WITH(NOLOCK)      
				INNER JOIN Syn_Deal SD ON TOB.Record_Code =  SD.Syn_Deal_Code    
				INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code    
				INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code       
				Inner Join Title T WITH(NOLOCK) On TOB.Title_Code = T.Title_Code   
				WHERE TOB.Record_Type = ''S''
				)as XYZ Where 1=1       
			   )as X      
			   )      
			  Insert InTo #TempData Select Record_Code,Agreement_No,Vendor_Name,Title_Objection_Code,Title_name,''1'','' '',Last_Updated_Time From Y'      
    
		  PRINT (@SqlPageNo)      
		  EXEC (@SqlPageNo)     
	  
		  PRINT '1'    

		 Set @ExactMatch = '%'+@ExactMatch+'%'    
		 Update #TempData Set Sort = '0' Where Title_name like @ExactMatch OR Vendor_Name like @ExactMatch  OR Agreement_no like @ExactMatch     
		
		IF(@ExactMatch IS NOT NULL OR @ExactMatch != '')
		 BEGIN
			DELETE FROM #TempData WHERE (Title_name NOT like @ExactMatch) AND (Vendor_Name NOT like @ExactMatch)  AND (Agreement_no NOT like @ExactMatch)
		 END

		 PRINT '2'    
		 --delete from T From #TempData T Inner Join    
		 --(    
		 -- Select ROW_NUMBER()Over(Partition By AgreeMent_No Order By Sort asc) RowNum, Id, Agreement_No, Sort From #TempData    
		 --)a On T.Id = a.Id and a.RowNum <> 1    
     
		 PRINT '3'    
		 if(@StrSearch = '' OR @StrSearch IS NULL)
		BEGIN
		 Select @RecordCount = Count((AgreeMent_No )) From #TempData   
		 END
		 Update a Set a.Row_Num = b.Row_Num From #TempData a    
		  Inner Join (Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, agreement_no ASC) Row_Num, ID From #TempData) As b On a.Id = b.Id    

		 If(@IsPaging = 'Y')    
		 Begin    
		  Delete From #TempData Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize     
		 End     
    
		 SET @SqlPageNo1 ='INSERT INTO #AcqSynData(Title_Objection_Code,Deal_Code,Title_Code,Agreement_No,Title_Name,Deal_Desc,Vendor_Name,Objection_Type_Name,Agreement_Date,CountryDetails,Objection_Status,SORT,Last_Updated_Time)    
		 SELECT DISTINCT TOB.Title_Objection_Code,AD.Syn_Deal_Code AS Deal_Code,T.Title_Code,AD.Agreement_No,T.Title_Name,AD.Deal_Description AS Deal_Desc,V.Vendor_Name,TOT.Objection_Type_Name,AD.Agreement_Date,        
		 dbo.UFN_Get_Title_Objection_Territory(TOB.Title_Objection_Code) CountryDetails,TOS.Objection_Status_Name Status ,Tm.Sort,TOB.Last_Updated_Time      
		  FROM Title_Objection TOB        
		  INNER JOIN Title_Objection_Type TOT ON TOB.Title_Objection_Type_Code = TOT.Objection_Type_Code         
		  INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code        
		  INNER JOIN Title T ON TOB.Title_Code = T.Title_Code        
		  INNER JOIN Syn_Deal AD ON TOB.Record_Code = AD.Syn_Deal_Code        
		  INNER JOIN Vendor v WITH(NOLOCK) on AD.Vendor_Code = v.vendor_code        
		  INNER JOIN #TempData Tm on TOB.Title_Objection_Code = Tm.Title_Objection_Code        
		  WHERE TOB.Record_Type Collate Latin1_General_CI_AI IN(SELECT Deal_Type FROM #Type) '+@StrSearch+' ORDER BY Sort,TOB.Last_Updated_Time'     
    
		PRINT(@SqlPageNo1)    
		EXEC(@SqlPageNo1)    
    
		INSERT INTO #Filter    
		SELECT DISTINCT * FROM #AcqSynData  

		if(@StrSearch != '' OR @StrSearch IS NOT NULL)
		  BEGIN
			Select @RecordCount = Count( (Title_Objection_Code )) From #AcqSynData  
		  END
		
		SELECT Title_Objection_Code,Deal_Code AS Deal_Code,Title_Code,Agreement_No,Title_Name,Deal_Desc,Vendor_Name As Vendor_Name,Objection_Type_Name,Agreement_Date,    
		CountryDetails,Objection_Status AS Status  FROM #Filter ORDER By SORT ,Last_Updated_Time  DESC  
	END    
	 ELSE IF(@Type = 'A,S' OR @Type = 'S,A')    
	  BEGIN    
		  set @SqlPageNo = N'      
				WITH Y AS (    
				Select distinct x.Title_Objection_Code,X.Record_Code,X.Title_Name,X.Last_Updated_Time,X.Agreement_No,X.Vendor_Name From       
				(      
				select * from (      
				Select distinct TOB.Title_Objection_Code      
				,TOB.Objection_Start_Date      
				,TOB.Record_Code    
				,SD.Syn_Deal_Code    
				,SD.Agreement_No    
				,V.Vendor_Name    
				,TOB.[last_updated_time]                
				,TOS.Objection_Status_Name               
				,T.Title_Name      
				FROM Title_Objection TOB WITH(NOLOCK)      
				INNER JOIN Syn_Deal SD ON TOB.Record_Code =  SD.Syn_Deal_Code    
				INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code     
				INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code       
				Inner Join Title T WITH(NOLOCK) On TOB.Title_Code = T.Title_Code      
				WHERE TOB.Record_Type = ''S''
				)as XYZ Where 1=1 
			   )as X
			   )      
			  Insert InTo #TempData Select Record_Code,Agreement_No,Vendor_Name,Title_Objection_Code,Title_name,''1'','' '',Last_Updated_Time From Y'      
    
		  PRINT (@SqlPageNo)      
		  EXEC (@SqlPageNo)      
		   SET @SqlPageNo = ''    
    
	   set @SqlPageNo = N'      
				WITH Y AS (      
				Select distinct x.Title_Objection_Code,X.Record_Code,X.Title_Name,X.Last_Updated_Time,X.Agreement_No,X.Vendor_Name From       
				(      
				select * from (      
				Select distinct TOB.Title_Objection_Code      
				,TOB.Objection_Start_Date      
				,TOB.Record_Code    
				,AD.Acq_Deal_Code    
				,AD.Agreement_No    
				,V.Vendor_Name    
				,TOB.[last_updated_time]                
				,TOS.Objection_Status_Name               
				,T.Title_Name      
				FROM Title_Objection TOB WITH(NOLOCK)      
				INNER JOIN Acq_Deal AD ON TOB.Record_Code = AD.Acq_Deal_Code    
				INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code     
				INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code       
				Inner Join Title T WITH(NOLOCK) On TOB.Title_Code = T.Title_Code  
				WHERE TOB.Record_Type = ''A''
				)as XYZ Where 1=1       
			   )as X      
			   )      
			  Insert InTo #TempData Select Record_Code,Agreement_No,Vendor_Name,Title_Objection_Code,Title_name,''1'','' '',Last_Updated_Time From Y'      
    
		  PRINT (@SqlPageNo)      
		  EXEC (@SqlPageNo)     
    
		  PRINT '1'    
		 Set @ExactMatch = '%'+@ExactMatch+'%'    
		 Update #TempData Set Sort = '0' Where Title_name like @ExactMatch OR Vendor_Name like @ExactMatch  OR Agreement_no like @ExactMatch 
		 
		IF(@ExactMatch IS NOT NULL OR @ExactMatch != '')
		 BEGIN
			DELETE FROM #TempData WHERE (Title_name NOT like @ExactMatch) AND (Vendor_Name NOT like @ExactMatch)  AND (Agreement_no NOT like @ExactMatch)
		 END
		 PRINT '2'    
		 --delete from t from #tempdata t inner join    
		 --(    
		 -- select row_number()over(partition by agreement_no order by sort asc) rownum, id, agreement_no, sort from #tempdata    
		 --)a on t.id = a.id and a.rownum <> 1    
		 PRINT '3'    
		 if(@StrSearch = '' OR @StrSearch IS  NULL)
		  BEGIN
		 Select @RecordCount = Count((agreement_no )) From #TempData   
		 END
		Update a Set a.Row_Num = b.Row_Num From #TempData a Inner Join (Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, agreement_no ASC) Row_Num, ID From #TempData) As b On a.Id = b.Id  
		
		 If(@IsPaging = 'Y')    
		 Begin    
		 Delete From #TempData Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize    
		 End     

			SET @SqlPageNo1=  'INSERT INTO #AcqSynData(Title_Objection_Code,Deal_Code,Title_Code,Agreement_No,Title_Name,Deal_Desc,Vendor_Name,Objection_Type_Name,Agreement_Date,CountryDetails,Objection_Status,SORT,Last_Updated_Time)    
		  SELECT DISTINCT TOB.Title_Objection_Code,AD.Acq_Deal_Code AS Deal_Code,T.Title_Code,AD.Agreement_No,T.Title_Name,AD.Deal_Desc,V.Vendor_Name,TOT.Objection_Type_Name,AD.Agreement_Date      
		  ,dbo.UFN_Get_Title_Objection_Territory(TOB.Title_Objection_Code) CountryDetails,TOS.Objection_Status_Name Status,Tm.Sort,TOB.Last_Updated_Time    
		  FROM Title_Objection TOB         
		  INNER JOIN Title_Objection_Type TOT ON TOB.Title_Objection_Type_Code = TOT.Objection_Type_Code         
		  INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code        
		  INNER JOIN Title T ON TOB.Title_Code = T.Title_Code        
		  INNER JOIN Acq_Deal AD ON TOB.Record_Code = AD.Acq_Deal_Code        
		  INNER JOIN Vendor v WITH(NOLOCK) on AD.Vendor_Code = v.vendor_code        
		  INNER JOIN #TempData Tm on TOB.Title_Objection_Code = Tm.Title_Objection_Code        
		  WHERE TOB.Record_Type Collate Latin1_General_CI_AI IN(''A'') '+@StrSearch+''  

		 PRINT(@SqlPageNo1)    
		 EXEC(@SqlPageNo1)    
		 
		 SET @SqlPageNo1 = ''    
    
		 SET @SqlPageNo1 ='INSERT INTO #AcqSynData(Title_Objection_Code,Deal_Code,Title_Code,Agreement_No,Title_Name,Deal_Desc,Vendor_Name,Objection_Type_Name,Agreement_Date,CountryDetails,Objection_Status,Sort,Last_Updated_Time)    
		 SELECT DISTINCT TOB.Title_Objection_Code,SD.Syn_Deal_Code AS Deal_Code,T.Title_Code,SD.Agreement_No,T.Title_Name,SD.Deal_Description,CAST(V.Vendor_Name AS varchar(MAX)),TOT.Objection_Type_Name,SD.Agreement_Date,      
		 dbo.UFN_Get_Title_Objection_Territory(TOB.Title_Objection_Code) CountryDetails,TOS.Objection_Status_Name Status,Tm.Sort,TOB.Last_Updated_Time    
		 FROM Title_Objection TOB         
		 INNER JOIN Title_Objection_Type TOT ON TOB.Title_Objection_Type_Code = TOT.Objection_Type_Code       
		 INNER JOIN Title_Objection_Status TOS ON TOB.Title_Objection_Status_Code = TOS.Title_Objection_Status_Code      
		 INNER JOIN Title T ON TOB.Title_Code = T.Title_Code      
		 INNER JOIN Syn_Deal SD  WITH(NOLOCK)  ON TOB.Record_Code = SD.Syn_Deal_Code      
		 INNER JOIN Vendor v WITH(NOLOCK) on SD.Vendor_Code = v.vendor_code      
		 INNER JOIN #TempData Tm on TOB.Title_Objection_Code = Tm.Title_Objection_Code      
		 WHERE TOB.Record_Type  Collate Latin1_General_CI_AI  IN(''S'')'+@StrSearch+''    
    
		 PRINT(@SqlPageNo1)    
		 EXEC(@SqlPageNo1)    

		 INSERT INTO #Filter    
		 SELECT DISTINCT * FROM #AcqSynData    

		 if(@StrSearch != '' OR @StrSearch IS NOT NULL)
		  BEGIN
			Select @RecordCount = Count( (Title_Objection_Code )) From #AcqSynData  
		  END
    
		  SELECT Title_Objection_Code,Deal_Code AS Deal_Code,Title_Code,Agreement_No,Title_Name,Deal_Desc,Vendor_Name As Vendor_Name,Objection_Type_Name,Agreement_Date,    
		  CountryDetails,Objection_Status AS Status  FROM #Filter ORDER By SORT ,Last_Updated_Time  DESC  
	  END    
	 IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp      
	 IF OBJECT_ID('tempdb..#AcqSynData') IS NOT NULL DROP TABLE #AcqSynData    
	 IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData      
	 IF OBJECT_ID('tempdb..#Type') IS NOT NULL DROP TABLE #Type    
END
