
CREATE PROCEDURE [dbo].[USP_Title_List]      
(       
--DECLARE      
    @Deal_Type_code int ,      
    @TitleName NVARCHAR(2000), 
	@OriginalTitleName NVARCHAR(MAX) ,    
    @BUCode INT,      
    @PageNo INT,      
    @RecordCount Int out,      
    @IsPaging Varchar(2),      
    @PageSize Int,      
 @AdvanceSearch NVARCHAR(max),  
 @ExactMatch varchar(max) = ''  
)      
AS      
--DECLARE  
-- @Deal_Type_code int ,      
--    @TitleName NVARCHAR(2000),      
--    @BUCode INT,      
--    @PageNo INT,      
--    @RecordCount Int ,      
--    @IsPaging Varchar(2),      
--    @PageSize Int,      
-- @AdvanceSearch NVARCHAR(max),  
-- @ExactMatch varchar(max) = ''  
  
--set @Deal_Type_code = 1      
--set @TitleName = ''      
--set @PageNo =  1      
--set  @RecordCount = 10      
--set @IsPaging = 'Y'      
--set @PageSize = 10  
--SET @AdvanceSearch = ''  
--SET @ExactMatch = ''      
  
BEGIN        
    
 DECLARE @Condition NVARCHAR(MAX) = ' AND ISNULL(T.Reference_Key,'''') = '''' AND  ISNULL(T.Reference_Flag,'''') = '''' '      
 DECLARE @delimt NVARCHAR(2) = N'﹐'      
      
    if(@TitleName != '')      
        set @Condition  += ' AND T.Title_code in (select Title_Code from Title where Title_Name IN (SELECT number FROM fn_Split_withdelemiter(N'''+@TitleName+''', N'''+ @delimt +''') where number != ''''))'      
     print @Condition  
         
		 IF(@OriginalTitleName != '')      
        SET @Condition  += ' AND T.Title_code in (select Title_Code FROM Title WHERE Original_Title IN (SELECT number FROM fn_Split_withdelemiter(N'''+@OriginalTitleName+''', N'''+ @delimt +''') WHERE number != '''')) '      
  

    if (@Deal_Type_code > 0)      
        set @Condition  += ' AND DT.Deal_Type_code in('+ cast(@Deal_Type_code as varchar)+')'      
    --else if (@Deal_Type_code > 0 AND @TitleName = '')      
    --    set @Condition  += ' AND DT.Deal_Type_Name  LIKE ''%'+ ISNULL(@TitleName,'') + '%'''      
      
    IF(@AdvanceSearch ='')  
  SET @AdvanceSearch =''  
  
        set @Condition  += ' '      
    if(@PageNo = 0)      
        Set @PageNo = 1      
      
 IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
    Create Table #Temp(      
        Id Int Identity(1,1),      
        RowId Varchar(200),  
  Title_Name  Varchar(200),  
  Language_Name  Varchar(200),  
  Sort varchar(10),  
  Row_Num Int,  
  Last_Updated_Time datetime  
    );      
      
    Declare @SqlPageNo NVARCHAR(MAX)      
        
    set @SqlPageNo = '      
            WITH Y AS (      
                            Select distinct X.Title_Code,X.Title_Name,X.Language_Name,X.Last_UpDated_Time From      
                            (      
                                select * from (      
                                    select distinct Title_Code, T.Original_Title, T.Title_Name, T.Title_Code_Id, T.Synopsis, T.Original_Language_Code, T.Title_Language_Code      
                                            ,T.Year_Of_Production,P.Program_Name, T.Duration_In_Min, T.Deal_Type_Code, T.Grade_Code, T.Reference_Key, T.Reference_Flag, T.Is_Active      
                                            ,T.Inserted_By, T.Inserted_On, T.Last_UpDated_Time, T.Last_Action_By, T.Lock_Time, T.Title_Image, L.Language_Name   
                                            from Title T      
                                            INNER join Deal_Type DT on DT.Deal_Type_Code = T.Deal_Type_Code  
           INNER join Language L on T.Title_Language_Code = L.Language_Code  
           LEFT JOIN Program P ON T.Program_Code = P.Program_Code  
                                            where 1=1       
                                            '+ @Condition +'  '+@AdvanceSearch+'  
                                      )as XYZ Where 1 = 1      
                             )as X      
                        )      
        Insert InTo #Temp Select Title_Code,Title_Name,Language_Name,''1'','' '',Last_UpDated_Time From Y'      
         
    --PRINT (@SqlPageNo)      
    EXEC (@SqlPageNo)      
    --select * from #Temp  
 Set @ExactMatch = '%'+@ExactMatch+'%'  
 Update #Temp Set Sort = '0' Where Title_name like @ExactMatch OR Language_Name like @ExactMatch  
  
    delete from T From #Temp T Inner Join  
 (  
  Select ROW_NUMBER()Over(Partition By RowId Order By Sort asc) RowNum, Id, RowId, Sort From #Temp  
 )a On T.Id = a.Id and a.RowNum <> 1  
 Select @RecordCount = Count(distinct (RowId )) From #Temp     
     Update a   
  Set a.Row_Num = b.Row_Num  
  From #Temp a  
  Inner Join (  
   --Select Rank() over(order by Sort Asc, Last_Updated_Time desc, ID ASC) Row_Num, ID From #Temp  
   Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, RowId ASC) Row_Num, ID From #Temp  
  ) As b On a.Id = b.Id  
 --select * from #Temp order by Row_Num   
  
    If(@IsPaging = 'Y')      
    Begin         
        Delete From #Temp Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize     
    End         
     -- select * from #Temp order by Row_Num    
    --Select @RecordCount = Count(*) From #Temp      
         
         
    Declare @Sql NVARCHAR(MAX)      
    Set @Sql = '      
        SELECT Title_Name, Original_Title, Title_Code, Language_Name, Year_Of_Production, Program_Name, CountryName, Original_Language, TalentName, Producer, Director, Title_Image      
    ,Is_Active, Deal_Type_Code, Deal_Type_Name, Synopsis, Genre      
        FROM (      
            select distinct T.Title_Name,T.Original_Title,T.Title_Code,T.Synopsis ,L.Language_Name , OL.Language_Name AS ''Original_Language''    
           ,T.Year_Of_Production,p.Program_Name      
           ,REVERSE(stuff(reverse(stuff(      
                        (         
                            select cast(C.Country_Name  as NVARCHAR(MAX)) + '', '' from Title_Country TC      
                            inner join Country C on C.Country_Code = TC.Country_Code      
                            where TC.Title_Code = T.Title_Code      
                            FOR XML PATH(''''), root(''CountryName''), type      
     ).value(''/CountryName[1]'',''Nvarchar(max)''      
                        ),2,0, ''''      
                    )      
           ),1,2,'''')) as CountryName      
           ,REVERSE(stuff(reverse(  stuff(      
                        (         
                            select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
                            inner join Role R on R.Role_Code = TT.Role_Code      
                            inner join Talent Tal on tal.talent_Code = TT.Talent_code      
                            where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
      
                            FOR XML PATH(''''), root(''TalentName''), type      
     ).value(''/TalentName[1]'',''NVARCHAR(max)''      
                        ),1,0, ''''      
                    )      
           ),1,2,'''')) as TalentName      
            ,REVERSE(stuff(reverse(  stuff(      
                        (         
                            select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
                            inner join Role R on R.Role_Code = TT.Role_Code      
                            inner join Talent Tal on tal.talent_Code = TT.Talent_code      
                            where TT.Title_Code = T.Title_Code AND R.Role_Code in (4)      
      
                            FOR XML PATH(''''), root(''Producer''), type      
     ).value(''/Producer[1]'',''NVARCHAR(max)''      
                        ),1,0, ''''      
                    )      
           ),1,2,'''')) as Producer      
           ,REVERSE(stuff(reverse(  stuff(      
                        (         
                            select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
                            inner join Role R on R.Role_Code = TT.Role_Code      
                            inner join Talent Tal on tal.talent_Code = TT.Talent_code      
                            where TT.Title_Code = T.Title_Code AND R.Role_Code in (1)      
      
                            FOR XML PATH(''''), root(''Director''), type      
     ).value(''/Director[1]'',''NVARCHAR(max)''      
                        ),1,0, ''''      
                    )      
           ),1,2,'''')) as Director      
           , [dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genre, ISNULL(T.Title_Image,'' '') As Title_Image, T.Last_UpDated_Time, T.Inserted_On      
           ,Case When T.Is_Active=''Y'' then ''Active'' Else ''Deactive'' END AS Is_Active, T.Deal_Type_Code, DT.Deal_Type_Name Tmp.Row_Num        
    from Title T      
    INNER join Deal_Type DT on DT.Deal_Type_Code = T.Deal_Type_Code     
    LEFT join [Language] L on T.Title_Language_Code  = L.Language_Code   
	LEFT join [Language] OL on T.Original_Language_Code  = OL.Language_Code    
    LEFT join Title_Country TC on T.Title_Code = TC.Title_Code   
 INNER JOIN #Temp Tmp on T.Title_Code = Tmp.RowId    
 left join Program P on T.Program_code = P.Program_Code   
      where 1=1  '+ @Condition +'  '+@AdvanceSearch+'    
          ) tbl  
        WHERE tbl.Title_Code in (Select RowId From #Temp)      
        ORDER BY tbl.Row_Num   
    '      
 --order by ISNULL(tbl.Last_UpDated_Time,tbl.Inserted_On) DESC      
    PRINT @Sql      
    Exec(@Sql)      
    Drop Table #Temp      
  
    --SELECT Title_Name ,      
    --          Original_Title      
    --            ,Title_Code      
    --            ,'asfsafsaf' as Language_Name      
    --          ,Year_Of_Production      
    --            ,'asfgsdhsfdhj' as CountryName      
    --            ,'asfgasgfhfgjfgjkghkgkgk' as TalentName      
    --          ,'jhsdgjhgdf' as Producer      
    --   ,'asfgasgfhfgjfgjkghkgkgk' as Director      
    --            ,Title_Image      
    --            ,Is_Active      
    --            ,Deal_Type_Code   
	--			  ,'asdfdasdf' as Deal_Type_Name  
    --          ,Synopsis      
    --            ,'asadsd' as Genre      
    --            from Titlea      
         
END

