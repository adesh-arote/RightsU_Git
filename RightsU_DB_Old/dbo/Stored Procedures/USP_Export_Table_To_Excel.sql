ALTER PROCEDURE [dbo].[USP_Export_Table_To_Excel]                         
   @Module_Code INT,                                
   @Column_Count INT OUT,              
   @Sort_Column VARCHAR(100),              
   @Sort_Order VARCHAR(3),    
   @SysLanguageCode INT,  
   @StrSearchCriteria NVARCHAR(MAX)
AS                                   
  --=============================================                                
  --Author:  Reshma Kunjal / Aditya                              
  --Create date: 21-OCT-2015                                
  --Description: Return Result set for provided Table      
  --Multi-Language Change: 20-SEP-2017 By Aditya Bandivadekar.                               
  --=============================================     
                               
BEGIN               
 SET FMTONLY OFF      
    DECLARE    
   --@Module_Code INT = 203,                                
   --@Column_Count INT = 0,              
   --@Sort_Column VARCHAR(100)= 'TIME',              
   --@Sort_Order VARCHAR(3) = 'DSC',    
   --@SysLanguageCode INT = 1,     
   --@StrSearchCriteria NVARCHAR(MAX) = '',  
    @sql_String VARCHAR(MAX) = '',    
    @Col_Head01 NVARCHAR(MAX) = '',    
    @Col_Head02 NVARCHAR(MAX) = '',    
    @Col_Head03 NVARCHAR(MAX) = '',    
    @Col_Head04 NVARCHAR(MAX) = '',    
    @Col_Head05 NVARCHAR(MAX) = '',    
    @Col_Head06 NVARCHAR(MAX) = '',    
    @Col_Head07 NVARCHAR(MAX) = '',    
    @Col_Head08 NVARCHAR(MAX) = '',    
    @Deactive NVARCHAR(MAX) = '',    
    @Active NVARCHAR(MAX) = '',  
    @Yes NVARCHAR(200) = '',  
    @No NVARCHAR(200) = '',  
    @Own NVARCHAR(200) = '',  
    @Others NVARCHAR(200) = '',  
    @Male NVARCHAR(200)   = '',  
    @Female NVARCHAR(200) = '',  
    @NA NVARCHAR(200) = '',  
    @FromFirstAir NVARCHAR(MAX) = '',  
    @AsRun NVARCHAR(200) = '',  
    @Schedule NVARCHAR(200) = ''  
  
  
    
    /*                                
   3 Users                                
  4 Security Group                                
  10 Party                                
  11 Channel                                
  12 Language                                
  13 Talent                                
  14 Cost Type                                
  15 Platform                                
  16 Payment Terms                                
  17 Material Medium                                
  18 Material Type                                
  19 Penalty                                
  20 CBFC Agent                                
  23 Amort Rule                                
  27 Title List                                
  31 Right Rule                                
  44 Document Type                                
  48 Additional Expense                                
  53 Revenue Data Theatre                                
  56 Grade Master                                
  58 Commercial                                
  59 Territory                                
  60 Rights Category                                
  63 User Mgmt                                
  76 Royalty Commission                                
  79 Royalty Recoupment                                
  84 Format                                
  94 Exception                                
  106 Language Group                                
  114 IPR Application                                
  118 SAP WBS                                
  123 Music Titles                                
  130 Platform Group      
  162 Program               
  115 Login Details Report                   
   */                       
  IF OBJECT_ID('TEMPDB..#tmpMulExportToExcel') IS NOT NULL  
  DROP TABLE #tmpMulExportToExcel  
  
  IF OBJECT_ID('TEMPDB..#tmpExportToExcel') IS NOT NULL  
  DROP TABLE #tmpExportToExcel  
  
 CREATE TABLE #tmpExportToExcel                                
   (                                
     Col01 NVARCHAR(500),                                
     Col02 NVARCHAR(500),                                
     Col03 NVARCHAR(MAX),                                
     Col04 NVARCHAR(MAX),                                
     Col05 NVARCHAR(MAX),                                
     Col06 NVARCHAR(500),                                
     Col07 NVARCHAR(500),                                
     Col08 NVARCHAR(500),                                
     Col09 NVARCHAR(500),                                
     Col10 NVARCHAR(500),                                
     Col11 NVARCHAR(500),                                
     Col12 NVARCHAR(500),                                
     Col13 NVARCHAR(500),                                
     Col14 NVARCHAR(500),                                
     Col15 NVARCHAR(500),                                
     Col16 NVARCHAR(500),                                
     Col17 NVARCHAR(500),                                
     Col18 NVARCHAR(500),                           
     Col19 NVARCHAR(500),                                
     Col20 NVARCHAR(500),                                
     Col21 NVARCHAR(500),                                
     Col22 NVARCHAR(500),                                
     Col23 NVARCHAR(500),                                
     Col24 NVARCHAR(500),                                
     Col25 NVARCHAR(500),                                
     Col26 NVARCHAR(500),                                
     Col27 NVARCHAR(500),                                
     Col28 NVARCHAR(500),                                
     Col29 NVARCHAR(500),                                
     Col30 NVARCHAR(500)                                                          
   )                
   CREATE TABLE #tmpMulExportToExcel                                
   (                                
     Col01 NVARCHAR(500),                                
     Col02 NVARCHAR(500),                                
     Col03 NVARCHAR(MAX),                                
     Col04 NVARCHAR(MAX),                                
     Col05 NVARCHAR(MAX),                                
     Col06 NVARCHAR(500),                                
     Col07 NVARCHAR(500),                                
     Col08 NVARCHAR(500),                                
     Col09 NVARCHAR(500),                                
     Col10 NVARCHAR(500),                                
     Col11 NVARCHAR(500),                                
     Col12 NVARCHAR(500),                                
     Col13 NVARCHAR(500),                                
     Col14 NVARCHAR(500),                                
     Col15 NVARCHAR(500),                                
     Col16 NVARCHAR(500),                                
     Col17 NVARCHAR(500),                                
     Col18 NVARCHAR(500),                           
     Col19 NVARCHAR(500),                                
     Col20 NVARCHAR(500),                                
     Col21 NVARCHAR(500),                                
     Col22 NVARCHAR(500),                                
     Col23 NVARCHAR(500),                                
     Col24 NVARCHAR(500),                                
     Col25 NVARCHAR(500),                                
     Col26 NVARCHAR(500),                                
     Col27 NVARCHAR(500),                                
     Col28 NVARCHAR(500),                                
     Col29 NVARCHAR(500),                                
     Col30 NVARCHAR(500)                                                          
   )                   
   SELECT @Deactive = SLM.Message_Desc FROM System_Message SM     
    INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code     
    AND SM.Message_Key =  'Deactive'    
    INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
    
   SELECT @Active = SLM.Message_Desc FROM System_Message SM    
    INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code     
    AND SM.Message_Key =  'Active'    
    INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  
   SELECT @Yes = SLM.Message_Desc FROM System_Message SM  
    INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
    AND SM.Message_Key =  'Yes'  
    INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
   SELECT @No = SLM.Message_Desc FROM System_Message SM  
    INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
    AND SM.Message_Key =  'NO'  
    INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
   SELECT @Own= SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'Own'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
   SELECT @Others = SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'Others'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
   SELECT @Male= SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'Male'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
   SELECT @Female = SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'Female'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
     
   SELECT @NA= SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'NA'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
  SELECT @FromFirstAir= SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'FromFirstAir'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
  SELECT @AsRun= SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'AsRun'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
 SELECT @Schedule= SLM.Message_Desc FROM System_Message SM  
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code   
   AND SM.Message_Key =  'Schedule'  
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
  
  
   --CURRENCY-----------------------------------------------------------------------------------------------------------------------------------------------------------    
  IF(@Module_Code = 5)    
    BEGIN    
  --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)                                
  --SELECT 'Currency Code', 'Currency Name', 'Currency Sign', 'Base Currency', 'Status'              
   
  
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)             
   SELECT [Currency Code],[Currency_Name], [Currency Sign],[Base Currency],[Status] FROM(    
    SELECT     
    Sorter = 1,    
    CAST(Currency_Code  AS VARCHAR(100)) AS [Currency Code], Currency_Name AS [Currency_Name], Currency_Sign AS [Currency Sign],CASE WHEN Is_Base_Currency = 'N' THEN @No ELSE @Yes                                
    END  AS [Base Currency], CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END  AS [Status],Last_Updated_Time    
    FROM Currency WHERE 1=1  AND (@StrSearchCriteria = '' OR Currency_Name LIKE '%'+@StrSearchCriteria+'%' OR Currency_Sign LIKE '%'+@StrSearchCriteria+'%')
    ) X                              
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Currency_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Currency_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC    
  
      SELECT     
  @Col_Head01 = CASE WHEN  SM.Message_Key = 'CurrencyCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
  @Col_Head02 = CASE WHEN  SM.Message_Key = 'CurrencyName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
  @Col_Head03 = CASE WHEN  SM.Message_Key = 'CurrencySign' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
  @Col_Head04 = CASE WHEN  SM.Message_Key = 'BaseCurrency' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
  @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('CurrencyCode','CurrencyName','CurrencySign','BaseCurrency','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,@Col_Head04 as Col04,@Col_Head05 as Col05,''as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END       
  --END CURRENCY-------------------------------------------------------------------------------------------------------------------------------------------------------   
  
   --COUNTRY------------------------------------------------------------------------------------------------------------------------------------------------------------    
  IF(@Module_Code = 6)                                
    BEGIN             
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05, Col06)                                
    --SELECT 'Country Code', 'Country Name', 'Theatrical Territory', 'Language', 'Base Territory', 'Status'    
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'CountryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'CountryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'TheatricalTerritory' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Language' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'BaseTerritory' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('CountryCode','CountryName','TheatricalTerritory','Language','BaseTerritory','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05, Col06)      
   SELECT [Country Code],[Country_Name], [Theatrical Territory],[Language],[Base Territory],[Status] FROM(    
   SELECT     
   Sorter = 1,    
   CAST(Country_Code AS VARCHAR(500)) AS [Country Code], Country_Name AS [Country_Name], CASE WHEN Is_Theatrical_Territory = 'Y' THEN @Yes ELSE @No END [Theatrical Territory],                                
   STUFF((SELECT ', '+l.Language_Name FROM [Language] l INNER JOIN Country_Language cl ON cl.Country_Code=c.Country_Code WHERE                                
   cl.Language_Code=l.Language_Code FOR XML PATH('')), 1, 1, '') AS [Language] ,CASE WHEN Is_Domestic_Territory = 'N' THEN @No ELSE @Yes END AS [Base Territory],                                
   CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time     
   FROM Country c WHERE 1=1 AND (@StrSearchCriteria = '' OR c.Country_Name LIKE '%'+@StrSearchCriteria+'%')          
    ) X    
    
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order= 'ASC' THEN Country_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Country_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC     
      
    INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,@Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
  --END COUNTRY--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
   --GENRES------------------------------------------------------------------------------------------------------------------------------------------------------------    
   IF(@Module_Code = 7)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)                                
    --SELECT 'Genres Code', 'Genres Name', 'Status'                             
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'GenresCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'GenresName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('GenresCode','GenresName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)    
  SELECT [Genres Code],GENRES_NAME,[Status] FROM(    
  SELECT     
  Sorter = 1,    
  CAST(Genres_Code AS VARCHAR(500)) AS [Genres Code], Genres_Name AS GENRES_NAME,             
  CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time     
  FROM Genres G Where @StrSearchCriteria = '' OR G.Genres_Name LIKE '%'+@StrSearchCriteria+'%'          
    ) X                         
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order  = 'ASC' THEN GENRES_NAME END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN GENRES_NAME END DESC,            
  CASE WHEN @Sort_Column= 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,'' as Col04,'' as Col05,'' as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
   --END GENRES--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
   --ENTITY------------------------------------------------------------------------------------------------------------------------------------------------------------                                
   IF(@Module_Code = 8)                                
   BEGIN                          
   --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)                                
   --SELECT 'Entity Code', 'Entity Name', 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'EntityCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'EntityName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('EntityCode','EntityName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)      
  SELECT [Entity Code],[Entity_Name],[Status] FROM(    
  SELECT     
    Sorter = 1,    
    CAST(Entity_Code AS VARCHAR(200)) AS [Entity Code], Entity_Name AS [Entity_Name], CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status] ,Last_Updated_Time     
    FROM Entity                                
  ) X    
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Entity_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Entity_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC            
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,'' as Col04,'' as Col05,'' as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
   --END ENTITY--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
   --CATEGORY----------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 9)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04)                                
   --SELECT 'Category Code', 'Category Name', 'Is System Generated' , 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'CategoryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'IsSystemGenerated' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,     
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('CategoryCode','CategoryName','IsSystemGenerated','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
    INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04)                       
  SELECT [Category Code],[Category_Name],[Is System Generated],[Status] FROM(    
   SELECT    
   Sorter = 1,    
    CAST(Category_Code  AS VARCHAR(100)) AS [Category Code], Category_Name AS [Category_Name],CASE WHEN Is_System_Generated= 'N' THEN @No ELSE @Yes END AS [Is System Generated],                                 
   CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status],Last_Updated_Time     
   FROM Category C Where @StrSearchCriteria = '' OR C.Category_Name LIKE '%'+@StrSearchCriteria+'%'                           
   ) X    
   ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order= 'ASC' THEN Category_Name END ASC,            
   CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Category_Name END DESC,            
   CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
     
   INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,'' as Col05,'' as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
   --END CATEGORY------------------------------------------------------------------------------------------------------------------------------------------------------    
    
   --MATERIAL_MEDIUM---------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 17)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05)                                
   --SELECT 'Material Medium Code', 'Material Medium Name', 'Duration' , 'Is_Qc_Required', 'Status'       
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'MaterialMediumCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MaterialMediumName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Duration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,     
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'IsQcRequired' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,       
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('MaterialMediumCode','MaterialMediumName','Duration','IsQcRequired','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05)      
  SELECT [Material Medium Code],[Material_Medium_Name],[Duration],[Is Qc Required],[Status] FROM    
  (    
  SELECT    
  1 Sorter,    
  CAST(Material_Medium_Code AS VARCHAR(100)) AS [Material Medium Code], Material_Medium_Name AS [Material_Medium_Name],     
  CAST(Duration AS VARCHAR(10)) Duration, Is_Qc_Required AS [Is Qc Required],                                 
  CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time    
  FROM Material_Medium Where @StrSearchCriteria = '' OR Material_Medium_Name LIKE '%'+@StrSearchCriteria+'%'                              
  ) X    
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Material_Medium_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Material_Medium_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC     
    
   INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,'' as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
     
    END    
  --END MATERIAL MEDIUM------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --USERS--------------------------------------------------------------------------------------------------------------------------------------------------------------    
  IF(@Module_Code = 3)   
  BEGIN                                                   
   --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05, Col06, Col07)                                
   --SELECT 'Users Code', 'Login Name', 'First Name' , 'Middle Name', 'Last Name', 'Security Group', 'Status' 
   
   	Declare 
	@UserName VARCHAR(50) = '',
	@status VARCHAR(50) = '',
	@VendorCode INT = 0,
	@SecGroupCode INT = 0,
	@SearchIsLDAPUser VARCHAR(50) = ''

	select @UserName = number from dbo.fn_Split_withdelemiter(@StrSearchCriteria,'~') where id = 1
	select @SecGroupCode = number from dbo.fn_Split_withdelemiter(@StrSearchCriteria,'~') where id = 2
	select @status = number from dbo.fn_Split_withdelemiter(@StrSearchCriteria,'~') where id = 3
    select @VendorCode = number from dbo.fn_Split_withdelemiter(@StrSearchCriteria,'~') where id = 4 
	select @SearchIsLDAPUser = number from dbo.fn_Split_withdelemiter(@StrSearchCriteria,'~') where id = 5
      
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'UsersCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'LoginName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'FirstName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,     
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'MiddleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'LastName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'SecurityGroup' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,    
   @Col_Head07 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('UsersCode','LoginName','FirstName','MiddleName','LastName','SecurityGroup','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
     INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05, Col06, Col07)    
  SELECT [Users Code],[Login_Name],[First Name],[Middle Name],[Last Name],[Security Group],[Status] FROM(    
  SELECT  DISTINCT  
  Sorter = 1,    
  CAST(u.Users_Code AS VARCHAR(100)) AS [Users Code],u.Login_Name As [Login_Name],u.First_Name AS [First Name],u.Middle_Name AS [Middle Name],u.Last_Name As [Last Name],                                
  (SELECT Security_Group_Name from Security_Group WHERE Security_Group_Code = u.Security_Group_Code) AS [Security Group],                                
  CASE WHEN u.Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time     
  FROM Users u LEFT JOIN MHUsers MU ON u.Users_Code = MU.Users_Code
  WHERE (@UserName = '' OR u.First_Name LIKE '%'+@UserName+'%' OR u.Last_Name LIKE '%'+@UserName+'%') 
						AND (@SecGroupCode = 0 OR u.Security_Group_Code = @SecGroupCode) AND (@status = '' OR u.Is_Active = @status) 
						AND (@VendorCode = 0 OR MU.Vendor_Code = @VendorCode)  AND (@SearchIsLDAPUser = '' OR u.IsLDAPUser = @SearchIsLDAPUser)  
  ) X                   
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Login_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Login_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC     
    
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,@Col_Head07 as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
         
   END    
  --END USERS----------------------------------------------------------------------------------------------------------------------------------------------------------      
    
    
  --SECURITY GROUP-----------------------------------------------------------------------------------------------------------------------------------------------------                                
   IF(@Module_Code = 4)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04)                                
    --SELECT 'Security Group Code', 'Security Group I.D.', 'Security Group Name' , 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'SecurityGroupCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'SecurityGroupID' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'SecurityGroupName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,     
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('SecurityGroupCode','SecurityGroupID','SecurityGroupName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04)                                
  SELECT [Security Group Code],[Security Group ID],[Security_Group_Name],[Status] FROM(    
   SELECT     
   Sorter = 1,    
   CAST(Security_Group_Code AS VARCHAR(10)) AS [Security Group Code], 'SG' + CONVERT(VARCHAR(10),Security_Group_Code) AS [Security Group Id],Security_Group_Name AS [Security_Group_Name],          
   CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time     
   FROM Security_Group Where @StrSearchCriteria = '' OR Security_Group_Name LIKE '%'+@StrSearchCriteria+'%'     
   ) X                             
   ORDER BY CASE WHEN @Sort_Column  = 'NAME' AND  @Sort_Order  = 'ASC' THEN Security_Group_Name END ASC,            
   CASE WHEN @Sort_Column  = 'NAME' AND @Sort_Order  = 'DSC' THEN Security_Group_Name END DESC,            
   CASE WHEN @Sort_Column  = 'TIME' AND @Sort_Order  = 'DSC' THEN Last_Updated_Time END DESC        
     
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
  --END SECURITY GROUP------------------------------------------------------------------------------------------------------------------------------------------------    
    
   --PARTY                                
   IF(@Module_Code = 10)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05,  Col06, Col07, Col08)                                
    --SELECT 'Party Code', 'Party Name', 'Address' , 'Phone No', 'Party Type', 'CST No', 'Status', 'PartyCategory'                                
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'PartyCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'PartyName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END, 
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'PartyCategory' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,       
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Address' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,     
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'PhoneNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'PartyType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,    
   @Col_Head07 = CASE WHEN  SM.Message_Key = 'CSTNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07	END,    
   @Col_Head08 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END
  
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('PartyCode','PartyName', 'PartyCategory', 'Address','PhoneNo','PartyType','CSTNo','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
     INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05,  Col06, Col07, Col08)     
  SELECT [Party Code],[Vendor_Name],[Party Category],[Address],[Phone No],[Party Type],[CST No],[Status] FROM(    
   SELECT     
   Sorter = 1,    
   CAST(v.Vendor_Code AS VARCHAR(10)) AS [Party Code],Vendor_Name AS [Vendor_Name],
    (Select TOP 1 p.Party_Category_Name from Party_Category p where v.Party_Category_Code = p.Party_Category_Code) AS [Party Category],            
   [Address],Phone_No As [Phone No],                                
   Stuff ((SELECT ', '+r.Role_Name from [Role] r INNER JOIN Vendor_Role vr ON v.Vendor_Code=vr.Vendor_Code where r.Role_Code=vr.Role_Code FOR XML PATH('')), 1, 1, '')                                
   AS [Party Type],CST_No AS [CST No],                                
   CASE WHEN v.Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time
   FROM Vendor v where v.Party_Type = 'V' AND (@StrSearchCriteria = '' OR v.Vendor_Name Like '%'+@StrSearchCriteria+'%')                            
   ) X    
   ORDER BY CASE WHEN @Sort_Column= 'NAME' AND  @Sort_Order = 'ASC' THEN Vendor_Name END ASC,            
   CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Vendor_Name END DESC,            
   CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,@Col_Head07 as Col07,@Col_Head08 as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
  --END PARTY----------------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --CHANNEL------------------------------------------------------------------------------------------------------------------------------------------------------------                                
   IF(@Module_Code = 11)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05,  Col06)                                
    --SELECT 'Channel Code', 'Channel Name', 'Entity Type' , 'Entity / Broadcaster', 'Country', 'Status'                                   
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'ChannelCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'ChannelName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'EntityType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,     
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'EntityBroadcaster' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'Country' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('ChannelCode','ChannelName','EntityType','EntityBroadcaster','Country','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
    INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05,  Col06)      
    SELECT [Channel Code],[Channel_Name],[Entity Type],[Entity / Broadcaster],[Country],[Status] FROM(    
  SELECT     
    Sorter =1,    
    CAST(c.Channel_Code AS VARCHAR(10)) AS [Channel Code],     
    Channel_Name AS [Channel_Name],-- Channel_Id AS [Channel Beam],g.Genres_Name AS Genres,                                
    CASE WHEN Entity_Type='O' THEN @Own WHEN Entity_Type='C' THEN @Others ELSE '' END AS [Entity Type],    
    e.[Entity_Name] AS [Entity / Broadcaster],      
    Stuff ((SELECT ', '+co.Country_Name from Country co                               
   INNER JOIN Channel_Territory ct ON ct.Channel_Code= c.Channel_Code WHERE ct.Country_Code=co.Country_Code FOR XML PATH('')), 1, 1, '') AS Country,                                 
    CASE WHEN c.Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status],    
    c.Last_Updated_Time     
   FROM Channel c                                 
  LEFT JOIN Entity e ON c.Entity_Code=e.Entity_Code  
  Where @StrSearchCriteria = '' OR c.Channel_Name LIKE '%'+@StrSearchCriteria+'%'                          
  --INNER JOIN Genres g ON c.Genres_Code=g.Genres_Code                             
  ) X       
  ORDER BY CASE WHEN @Sort_Column= 'NAME' AND  @Sort_Order = 'ASC' THEN Channel_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Channel_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
  --END CHANNEL--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --Language                                
    IF(@Module_Code = 12)                                
    BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)                                
    --SELECT 'Language Code', 'Language Name', 'Status'                                 
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'LanguageCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'LanguageName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('LanguageCode','LanguageName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  
     INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)     
  SELECT [Language_Code], Language_Name , [Status] FROM (    
    SELECT     
    Sorter = 1,     
    CAST(Language_Code AS VARCHAR(10)) as [Language_Code],     
    Language_Name, Last_Updated_Time,    
    CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status]    
   FROM [Language] Where @StrSearchCriteria = '' OR Language_Name LIKE '%'+@StrSearchCriteria+'%'  
   ) X    
    ORDER BY Sorter, CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Language_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Language_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
     INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  
     
  --END LANGUAGE-------------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --TALENT-------------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 13)                                
    BEGIN                                
    --SELECT t.Talent_Code,Talent_Name,Gender,r.Role_Name,CASE WHEN Is_Active = 'N' THEN 'No' ELSE 'YES' END AS Status FROM Talent t                                
    --INNER JOIN Talent_Role tr ON tr.Talent_Code=t.Talent_Code                                
    --INNER JOIN [Role] r ON tr.Role_Code=r.Role_Code       
                     
    --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)                                
    --SELECT 'Talent Code', 'Talent Name', 'Gender', 'Role', 'Status' 
	Declare 
	@TalentName VARCHAR(50) = '',
	@TalentRole INT = 0
	select @TalentName = number from dbo.fn_Split_withdelemiter(@StrSearchCriteria,'~') where id = 1
    select @TalentRole = number from dbo.fn_Split_withdelemiter(@StrSearchCriteria,'~') where id = 2 
	                                     
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'TalentCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'TalentName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Gender' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Role' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('TalentCode','TalentName','Gender','Role','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
     INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)          
   SELECT [Talent Code], [Talent_Name],[Gender],[Role],[Status] FROM (    
   SELECT distinct    
   Sorter = 1,    
   CAST(t.Talent_Code AS VARCHAR(10)) AS [Talent Code],                     
   Talent_Name AS [Talent_Name], CASE WHEN Gender='M' THEN @Male WHEN Gender='F' THEN @Female ELSE @NA END AS Gender,                    
   STUFF((SELECT ', '+r.Role_Name from [Role] r INNER JOIN Talent_Role tr ON tr.Talent_Code=t.Talent_Code                                
   WHERE tr.Role_Code=r.Role_Code FOR XML PATH('')), 1, 1, '') AS [Role],CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time    
   FROM Talent t LEFT JOIN Talent_Role tr ON t.Talent_Code = tr.Talent_Code  
   Where (@TalentName = '' OR t.Talent_Name LIKE '%'+@TalentName+'%') AND (@TalentRole = 0 OR tr.Role_Code = @TalentRole)                    
  -- UNION ALL    
  --SELECT 0,@Col_Head01, @Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,GETDATE()    
   ) X    
   ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Talent_Name END ASC,            
   CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Talent_Name END DESC,            
   CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC     
  
   INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
  END    
   --END TALENT--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
   --Cost Type                                
    IF(@Module_Code = 14)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)                                
   --SELECT 'Cost Type Code', 'Cost Type Name', 'Status', 'Is System Generated'                     
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'CostTypeCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'CostTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'IsSystemGenerated' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('CostTypeCode','CostTypeName','Status','IsSystemGenerated')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)        
   SELECT [Cost type Code], [Cost_type_Name],[Status],[Is System Generated] FROM (    
  SELECT    
  Sorter = 1,    
  CAST(Cost_Type_Code AS VARCHAR(10)) AS [Cost type Code], Cost_Type_Name AS [Cost_type_Name],CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS Status,                                
  CASE WHEN  Is_System_Generated= 'Y' THEN @Yes ELSE @No END AS [Is System Generated] ,Last_Updated_Time     
  FROM Cost_Type CT WHERE @StrSearchCriteria = '' OR CT.Cost_Type_Name LIKE '%'+@StrSearchCriteria+'%'                              
  ) X    
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order= 'ASC' THEN Cost_Type_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order= 'DSC' THEN Cost_Type_Name END DESC,            
  CASE WHEN @Sort_Column= 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
    
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END COST TYPE------------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --PAYMENT TERMS------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code=16)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
   --SELECT 'Payment Terms Code', 'Payment Term Name', 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'PaymentTermsCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'PaymentTermName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('PaymentTermsCode','PaymentTermName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
    INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)     
   SELECT [Payment Terms Code], [Payment_Terms_Name],[Status] FROM (    
  SELECT    
  Sorter = 1,    
  CAST(Payment_Terms_Code AS VARCHAR(10)) AS [Payment Terms Code], Payment_Terms AS [Payment_Terms_Name],CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END                                 
  AS [Status],Last_Updated_Time      
  FROM Payment_Terms Where @StrSearchCriteria = '' OR Payment_Terms LIKE '%'+@StrSearchCriteria+'%'                             
  ) X    
  ORDER BY CASE WHEN @Sort_Column  = 'NAME' AND  @Sort_Order = 'ASC' THEN Payment_Terms_Name END ASC,            
  CASE WHEN @Sort_Column  = 'NAME' AND @Sort_Order = 'DSC' THEN Payment_Terms_Name END DESC,            
  CASE WHEN @Sort_Column  = 'TIME' AND @Sort_Order= 'DSC' THEN Last_Updated_Time END DESC            
  
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END PAYMENT TERM---------------------------------------------------------------------------------------------------------------------------------------------------     
    
    
  --MATERIAL TYPE------------------------------------------------------------------------------------------------------------------------------------------------------                                
   IF(@Module_Code = 18)                                
   BEGIN                         
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
   --SELECT 'Material Type Code', 'Material Type Name', 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'MaterialTypeCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MaterialTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('MaterialTypeCode','MaterialTypeName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
    INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)       
   SELECT [Material Type Code], [Material_Type_Name],[Status] FROM (    
    SELECT    
    Sorter = 1,     
    CAST(Material_Type_Code AS VARCHAR(10)) AS [Material Type Code], Material_Type_Name AS [Material_Type_Name],CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active                                 
    END AS [Status], Last_Updated_Time    
    FROM Material_Type Where @StrSearchCriteria = '' OR Material_Type_Name LIKE '%'+@StrSearchCriteria+'%'    
    ) X                              
    ORDER BY CASE WHEN @Sort_Column= 'NAME' AND  @Sort_Order= 'ASC' THEN Material_Type_Name END ASC,            
    CASE WHEN @Sort_Column= 'NAME' AND @Sort_Order = 'DSC' THEN Material_Type_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order= 'DSC' THEN Last_Updated_Time END DESC     
  
     INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
  --END MATERIAL TYPE--------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --RIGHT RULE---------------------------------------------------------------------------------------------------------------------------------------------------------    
    IF(@Module_Code = 31)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05, Col06, Col07)                                
   --SELECT 'Right Rule Code', 'Right Rule Name', 'Start Time', 'Play Per Day', 'Duration Of Day', 'No. Of Repeat', 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'RightRuleCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'RightRuleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'StartTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'PlayPerDay' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'DurationOfDay' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'NoOfRepeat' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,    
   @Col_Head07 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('RightRuleCode','RightRuleName','StartTime','PlayPerDay','DurationOfDay','NoOfRepeat','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
     INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05, Col06, Col07)     
   SELECT [Right Rule Code], [Right_Rule_Name],[Start Time],[Play Per Day],[Duration Of Day],[No. Of Repeat],[Status] FROM (    
  SELECT     
  Sorter = 1,    
  CAST(Right_Rule_Code AS VARCHAR(10)) AS [Right Rule Code],Right_Rule_Name AS [Right_Rule_Name],    
  CASE WHEN IS_First_Air='1' THEN @FromFirstAir ELSE Start_Time END AS [Start Time], CAST(Play_Per_Day AS VARCHAR(10)) AS [Play Per Day],                
  CAST(Duration_Of_Day AS VARCHAR(10)) AS [Duration Of Day], CAST(No_Of_Repeat AS VARCHAR(10)) AS [No. Of Repeat],    
  CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status],Last_Updated_Time     
  FROM Right_Rule WHERE @StrSearchCriteria = '' OR Right_Rule_Name LIKE '%'+@StrSearchCriteria+'%'                               
  ) X    
  ORDER BY CASE WHEN @Sort_Column= 'NAME' AND  @Sort_Order= 'ASC' THEN Right_Rule_Name END ASC,            
  CASE WHEN @Sort_Column= 'NAME' AND @Sort_Order = 'DSC' THEN Right_Rule_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order= 'DSC' THEN Last_Updated_Time END DESC        
    
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,@Col_Head07 as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END RIGHT RULE-----------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --DOCUMENT TYPE------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 44)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
   --SELECT 'Document Type Code', 'Document Type Name', 'Status'             
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'DocumentTypeCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'DocumentTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('DocumentTypeCode','DocumentTypeName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)     
   SELECT [Document Type Code], [Document_Type_Name],[Status] FROM (    
  SELECT    
  Sorter = 1,    
  CAST(Document_Type_Code AS VARCHAR(10)) AS [Document Type Code],Document_Type_Name [Document_Type_Name],    
  CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status],Last_Updated_Time                            
  FROM Document_Type DT WHERE @StrSearchCriteria = '' OR DT.Document_Type_Name LIKE '%'+@StrSearchCriteria+'%'                               
  ) X    
  ORDER BY CASE WHEN @Sort_Column= 'NAME' AND  @Sort_Order= 'ASC' THEN Document_Type_Name END ASC,            
  CASE WHEN @Sort_Column= 'NAME' AND @Sort_Order = 'DSC' THEN Document_Type_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order= 'DSC' THEN Last_Updated_Time END DESC   
    
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
  --END DOCUMENT TYPE--------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --ADDITIONAL EXPENSE-------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 48)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)                                
   --SELECT 'Additional Expense Code', 'Additional Expense Name', 'SAP GL Group Code', 'Status'                                              
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'AdditionalExpenseCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'AdditionalExpenseName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'SAPGLGroupCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('AdditionalExpenseCode','AdditionalExpenseName','SAPGLGroupCode','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)     
   SELECT [Additional Expense Code], [Additional_Expense_Name],[SAP GL Group Code],[Status] FROM (    
  SELECT    
  Sorter =1,    
  CAST(Additional_Expense_Code AS VARCHAR(10)) AS [Additional Expense Code], Additional_Expense_Name AS [Additional_Expense_Name], SAP_GL_Group_Code AS [SAP GL Group Code],    
  CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time    
  FROM Additional_Expense AE Where @StrSearchCriteria = '' OR AE.Additional_Expense_Name LIKE '%'+@StrSearchCriteria+'%'   
  ) X                                
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Additional_Expense_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Additional_Expense_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC        
  
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END ADDITIONAL EXPENSE --------------------------------------------------------------------------------------------------------------------------------------------    
    
   --GRADE MASTER------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code=56)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
   --SELECT 'Grade Code', 'Grade Name', 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'GradeCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'GradeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('GradeCode','GradeName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)     
   SELECT [Grade Code], [Grade_Name],[Status] FROM (    
  SELECT    
  Sorter = 1,    
  CAST(Grade_Code AS VARCHAR(10))  AS [Grade Code], Grade_Name AS [Grade_Name],CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status],Last_Updated_Time    
  FROM Grade_Master Where @StrSearchCriteria = '' OR Grade_Name LIKE '%'+@StrSearchCriteria+'%'                              
  ) X    
  ORDER BY CASE WHEN @Sort_Column= 'NAME' AND  @Sort_Order= 'ASC' THEN Grade_Name END ASC,            
  CASE WHEN @Sort_Column= 'NAME' AND @Sort_Order= 'DSC' THEN Grade_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC    
  
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
   --END GRADE MASTER--------------------------------------------------------------------------------------------------------------------------------------------------     
    
    
   --TERRITORY---------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 59)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)                                
   --SELECT 'Territory Code', 'Territory Name', 'Theatrical', 'Countries', 'Status'                                
       
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'TerritoryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'TerritoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Theatrical' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Countries' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('TerritoryCode','TerritoryName','Theatrical','Countries','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)      
   SELECT [Territory Code], [Territory_Name],[Thetrical],[Countries],[Status] FROM (    
    SELECT     
    Sorter = 1,    
    CAST(t.Territory_Code AS VARCHAR(10)) AS [Territory Code], Territory_Name AS [Territory_Name],     
    CASE WHEN Is_Thetrical= 'Y' THEN @Yes ELSE @No END AS Thetrical,                                
    Stuff ((SELECT ', '+c.Country_Name from Country c INNER JOIN Territory_Details td ON c.Country_Code=td.Country_Code Where t.Territory_Code=td.Territory_Code                                
    FOR XML PATH('')), 1, 1, '') AS Countries,CASE WHEN t.Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time     
    FROM Territory t Where @StrSearchCriteria = '' OR t.Territory_Name LIKE '%'+@StrSearchCriteria+'%'  
    ) X     
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND   @Sort_Order = 'ASC' THEN Territory_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'DSC' THEN Territory_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND  @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC       
  
     INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  -- END TERRITORY-----------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --ROYALTY RECOUPMENT-------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 79)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
   --SELECT 'Royalty Recoupment Code', 'Royalty Recoupment Name', 'Status'                                 
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'RoyaltyRecoupmentCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'RoyaltyRecoupmentName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('RoyaltyRecoupmentCode','RoyaltyRecoupmentName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)     
   SELECT [Royalty Recoupment Code], [Royalty_Recoupment_Name],[Status] FROM (    
  SELECT    
  Sorter = 1,    
  CAST(Royalty_Recoupment_Code AS VARCHAR(10)) AS [Royalty Recoupment Code], Royalty_Recoupment_Name AS [Royalty_Recoupment_Name], CASE WHEN Is_Active = 'N'                                 
  THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time    
  FROM Royalty_Recoupment WHERE @StrSearchCriteria = '' OR Royalty_Recoupment_Name LIKE '%'+@StrSearchCriteria+'%'                               
  ) X    
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Royalty_Recoupment_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Royalty_Recoupment_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END ROYALTY RECOUPMENT---------------------------------------------------------------------------------------------------------------------------------------------    
    
  --Exception----------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 94)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)                                
   --SELECT 'BV Exception Code', 'Exception Type', 'Channel', 'Users', 'Status'                                
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'BVExceptionCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'ExceptionType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Channel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'User' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('BVExceptionCode','ExceptionType','Channel','User','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
    INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)     
   SELECT [Bv Exception Code], [Bv_Exception_Type],[Channel],[Users],[Status] FROM (    
    SELECT distinct  
    Sorter =1,    
    CAST(BE.Bv_Exception_Code AS VARCHAR(10)) AS [Bv Exception Code], CASE WHEN BV_Exception_Type = 'R' THEN @AsRun ELSE @Schedule END AS [Bv_Exception_Type],                                
    Stuff ((SELECT ', '+                                
    c.Channel_Name from Channel c                                
    INNER JOIN BVException_Channel bec ON c.Channel_Code=bec.Channel_Code                                
    Where bec.Bv_Exception_Code=be.Bv_Exception_Code                                
    FOR XML PATH('')), 1, 1, '') AS Channel,                                
    Stuff ((SELECT ', '+                                
    u.First_Name+' '+ u.Last_Name from Users u                                
    INNER JOIN BVException_Users beu ON u.Users_Code=beu.Users_Code                                
    Where beu.Bv_Exception_Code=be.Bv_Exception_Code                                
    FOR XML PATH('')), 1, 1, '') AS Users,                                
    CASE WHEN be.Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], be.Last_Updated_Time     
    FROM BVException be 
	INNER JOIN BVException_Channel bec ON be.Bv_Exception_Code = bec.Bv_Exception_Code 
	INNER JOIN Channel c ON c.Channel_Code = bec.Channel_Code
	INNER JOIN BVException_Users beu ON be.Bv_Exception_Code = beu.Bv_Exception_Code 
	INNER JOIN Users u ON u.Users_Code = beu.Users_Code
	WHERE @StrSearchCriteria = '' OR c.Channel_Name LIKE '%'+@StrSearchCriteria+'%' OR u.First_Name LIKE '%'+@StrSearchCriteria+'%' OR u.Last_Name LIKE '%'+@StrSearchCriteria+'%'
    ) X                       
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Bv_Exception_Type END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Bv_Exception_Type END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC       
  
     INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END EXCEPTION------------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --LANGUAGE GROUP-----------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 106)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)                                
   --SELECT 'Language Group Code', 'Language Group Name', 'Languages', 'Status'                                
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'LanguageGroupCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'LanguageGroupName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Language' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('LanguageGroupCode','LanguageGroupName','Language','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)    
   SELECT [Language Group Code], [Language_Group_Name],[Languages],[Status] FROM (    
    SELECT    
    Sorter = 1,    
    CAST(lg.Language_Group_Code AS VARCHAR(10)) AS [Language Group Code], lg.Language_Group_Name AS [Language_Group_Name], Stuff ((SELECT ', '+l.Language_Name from [Language] l                                
    INNER JOIN Language_Group_Details lgd ON l.Language_Code = lgd.Language_Code WHERE lgd.Language_Group_Code = lg.Language_Group_Code                                
    FOR XML PATH('')), 1, 1, '') AS Languages, CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time                                
    From Language_Group lg Where @StrSearchCriteria = '' OR lg.Language_Group_Name LIKE '%'+@StrSearchCriteria+'%'      
    ) X                            
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Language_Group_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Language_Group_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
     INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,'' as Col05,'' as Col06,'' as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END LANGUAGE GROUP-------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --SAP WBS------------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 118)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05, Col06, Col07,Col08)                                
   --SELECT 'SAP WBS Code', 'WBS Code', 'WBS Description', 'Studio/Vendor', 'Original/Dubbed','Short ID', 'Status', 'Sport Type'                                
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'SAPWBSCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'WBSCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'WBSDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'StudioVendor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'OriginalDubbed' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'ShortID' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,    
   @Col_Head07 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,    
   @Col_Head08 = CASE WHEN  SM.Message_Key = 'SportType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('SAPWBSCode','WBSCode','WBSDescription','StudioVendor','OriginalDubbed','ShortID','Status','SportType')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05, Col06, Col07,Col08)    
   SELECT [SAP WBS Code], [WBS Code],[WBS Description],[Studio/Vendor],[Original/Dubbed],[Short ID],[Status],[Sport Type] FROM (    
  SELECT    
  Sorter = 1,    
  CAST(SAP_WBS_Code AS VARCHAR(10)) AS [SAP WBS Code], WBS_Code AS [WBS Code], WBS_Description AS [WBS Description],     
  Studio_Vendor AS [Studio/Vendor], Original_Dubbed AS [Original/Dubbed], Short_ID as [Short ID] ,[Status], Sport_Type AS [Sport Type],Insert_On     
  From SAP_WBS where @StrSearchCriteria = '' OR WBS_Code LIKE '%'+@StrSearchCriteria+'%' OR WBS_Description like '%'+@StrSearchCriteria+'%' OR Studio_Vendor like '%'+@StrSearchCriteria+'%'   
											 OR Short_ID like '%'+@StrSearchCriteria+'%' OR [Status] like '%'+@StrSearchCriteria+'%'  
											 OR Sport_Type like '%'+@StrSearchCriteria+'%'  
  ) X                     
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN [WBS Description] END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN [WBS Description] END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Insert_On END DESC      
  
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,@Col_Head07 as Col07,@Col_Head08 as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END SAP WBS--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
    
  --PLATFORM GROUP-----------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 130)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)                    
   --SELECT 'Platform Group Code','Platform Group Name','Platforms','Status'                     
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'PlatformGroupCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'PlatformGroupName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('PlatformGroupCode','PlatformGroupName','Platform','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04)    
   SELECT [Platform Group Code], [Platform_Group_Name],[Platforms],[Status] FROM (    
   SELECT    
   Sorter = 1,    
   CAST(Platform_Group_Code AS VARCHAR(10)) AS [Platform Group Code], Platform_Group_Name AS [Platform_Group_Name],REVERSE(stuff(reverse(  stuff(                      
   (                    
    SELECT '-> '+                                  
    p.Platform_Name from [Platform] p                                  
    INNER JOIN Platform_Group_Details pgd ON p.Platform_Code=pgd.Platform_Code                                  
    Where pgd.Platform_Group_Code=pg.Platform_Group_Code                    
    FOR XML PATH('') , root('Platform'), type                      
    ).value('/Platform[1]','NVARCHAR(max)'                      
     ),1,2, ''                      
    )                      
    ),1,2,'')) AS Platforms,                                  
    CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time    
    From Platform_Group pg WHERE @StrSearchCriteria = '' OR pg.Platform_Group_Name LIKE '%'+@StrSearchCriteria+'%'      
    ) X                             
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Platform_Group_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Platform_Group_Name END DESC,            
  CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC  
    
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,'' as Col05,'' as Col06,'' as Col07,'' as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
  --END PLATFORM GROUP-------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --SYSTEM PARAM-------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 98)                                
    BEGIN                              
    --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03,Col04)                                
    --SELECT 'System Parameter Code','Parameter Name', 'Parameter Value', 'Status'                                        
   SELECT     
  @Col_Head01 = CASE WHEN  SM.Message_Key = 'SystemParameterCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
  @Col_Head02 = CASE WHEN  SM.Message_Key = 'ParameterName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
  @Col_Head03 = CASE WHEN  SM.Message_Key = 'ParameterValue' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
  @Col_Head04 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END    
     
  FROM System_Message SM    
     INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
     AND SM.Message_Key IN ('SystemParameterCode','ParameterName', 'ParameterValue','Status')    
     INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  INSERT INTO #tmpExportToExcel (Col01, Col02, Col03,Col04)    
  SELECT [System Parameter Code], [Parameter Name],[Parameter Value],[Status] FROM (    
   SELECT    
   Sorter = 1,    
   CAST(Id AS VARCHAR(10)) AS [System Parameter Code],Parameter_Name as [Parameter Name],    
   Parameter_Value as [Parameter Value], CASE WHEN IsActive = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time    
   FROM System_Parameter_New SPN WHERE @StrSearchCriteria = '' OR SPN.Parameter_Name LIKE '%'+@StrSearchCriteria+'%'     
   ) X                          
  ORDER BY Last_Updated_Time DESC       
  
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,'' as Col05,'' as Col06,'' as Col07,'' as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END SYSTEM PARAM---------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --MUSIC LABEL                                
    IF(@Module_Code = 155)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
   --SELECT 'Music Label Code', 'Music Label Name', 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'MusicLabelCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicLabelName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('MusicLabelCode','MusicLabelName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)     
   SELECT [Music Label Code], [Music_Label_Name],[Status] FROM (    
    SELECT    
    Sorter = 1,    
    CAST(Music_Label_Code AS VARCHAR(10)) AS [Music Label Code], Music_Label_Name AS [Music_Label_Name],CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active                                 
    END AS [Status], Last_Updated_Time    
    FROM Music_Label ML WHERE @StrSearchCriteria = '' OR ML.Music_Label_Name LIKE '%'+@StrSearchCriteria+'%'    
    ) X                              
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Music_Label_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Music_Label_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
     INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04,'' as Col05,'' as Col06,'' as Col07,'' as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
    END    
  --END MUSIC LABEL----------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --MUSIC ALBUM--------------------------------------------------------------------------------------------------------------------------------------------------------                                
   IF(@Module_Code = 156)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)                                
    --SELECT 'Music Album Code', 'Music Album Name', 'Album Type', 'Talent', 'Status'                                     
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'MusicAlbumCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicAlbumName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'AlbumType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Talent' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('MusicAlbumCode','MusicAlbumName','AlbumType','Talent','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05)    
   SELECT [Music Album Code], [Music_Album_Name],[Album Type],[Talent],[Status] FROM (    
    SELECT    
    Sorter = 1,     
    CAST(ma.Music_Album_Code AS VARCHAR(10)) AS [Music Album Code], Music_Album_Name AS [Music_Album_Name],    
    CASE WHEN Album_Type = 'M' THEN 'Movie' WHEN Album_Type = 'A' THEN 'Album' WHEN Album_Type IS NULL  THEN ''  END AS [Album Type],              
    Stuff ((SELECT ', '+c.Talent_Name from Talent c INNER JOIN Music_Album_Talent td ON c.Talent_Code=td.Talent_Code Where ma.Music_Album_Code=td.Music_Album_Code                                
    FOR XML PATH('')), 1, 1, '') AS Talent,CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active                                 
    END AS [Status], Last_Updated_Time     
    FROM Music_Album ma WHERE @StrSearchCriteria = '' OR MA.Music_Album_Name LIKE '%'+@StrSearchCriteria+'%'    
    ) X                
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Music_Album_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Music_Album_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC     
  
      INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04, @Col_Head05 as Col05,'' as Col06,'' as Col07,'' as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
   SELECT * FROM #tmpExportToExcel   
   END    
  --END MUSIC ALBUM----------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --MUSIC THEME--------------------------------------------------------------------------------------------------------------------------------------------------------                                
    IF(@Module_Code = 152)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
   --SELECT 'Music Theme Code', 'Music Theme Name', 'Status'                                
   SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'MusicThemeCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicThemeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('MusicThemeCode','MusicThemeName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)     
      
   SELECT [Music Theme Code], [Music_Theme_Name],[Status] FROM (    
    SELECT     
    Sorter =1,    
    CAST(Music_Theme_Code AS VARCHAR(10)) AS [Music Theme Code], Music_Theme_Name AS [Music_Theme_Name],    
    CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active                                 
    END AS [Status], Last_Updated_Time     
    FROM Music_Theme MT WHERE @StrSearchCriteria = '' OR MT.Music_Theme_Name LIKE '%'+@StrSearchCriteria+'%'                               
    ) X    
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Music_Theme_Name END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Music_Theme_Name END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC       
  
     INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04, '' as Col05,'' as Col06,'' as Col07,'' as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
   SELECT * FROM #tmpExportToExcel   
    END    
  --END MUSIC THEME----------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --MUSIC LANGUAGE-----------------------------------------------------------------------------------------------------------------------------------------------------                                
   IF(@Module_Code = 151)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)                                
    --SELECT 'Music Language Code', 'Music Language Name', 'Status'                                
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'MusicLanguageCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicLanguageName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('MusicLanguageCode','MusicLanguageName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)      
        
   SELECT [Music Language Code], [Language_Name],[Status] FROM (    
   SELECT    
   Sorter = 1,    
   CAST(Music_Language_Code AS VARCHAR(10)) AS [Music Language Code], Language_Name AS [Language_Name],CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active                                 
   END AS [Status], Last_Updated_Time     
   FROM Music_Language ML WHERE @StrSearchCriteria = '' OR ML.Language_Name LIKE '%'+@StrSearchCriteria+'%'                              
   UNION ALL    
   SELECT 0,@Col_Head01,@Col_Head02,@Col_Head03,GETDATE()    
   ) X    
   ORDER BY CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'ASC' THEN Language_Name END ASC,            
   CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Language_Name END DESC,            
   CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC    
     
   INSERT INTO #tmpMulExportToExcel   
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, '' as Col04, '' as Col05,'' as Col06,'' as Col07,'' as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
   SELECT * FROM #tmpExportToExcel   
   END    
  --END MUSIC LANGUAGE-------------------------------------------------------------------------------------------------------------------------------------------------    
  
  --PROGRAM------------------------------------------------------------------------------------------------------------------------------------------------------------                               
    IF(@Module_Code = 162)                                
    BEGIN                                
   --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)                                
   --SELECT 'Program Code', 'Program Name', 'Status'                             
      
   INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05)     
   SELECT [Program Code], [Program_Name],Genres_Name, Deal_Type_Name, [status]FROM (    
   SELECT    
   sorter = 1,    
   CAST(Program_Code AS VARCHAR(500)) AS [Program Code], [Program_Name] ,Last_Updated_Time,    
   STUFF ((SELECT ', '+                                
   G.Genres_Name FROM Genres G where G.Genres_Code = p.Genres_Code                                
   --INNER JOIN Genres ON P.Genres_Code = G.Genres_Code                               
   FOR XML PATH('')), 1, 1, '') AS Genres_Name,    
   STUFF ((SELECT ', '+                                
   D.Deal_Type_Name FROM Deal_Type D  where d.Deal_Type_Code = p.Deal_Type_Code    
   --INNER JOIN Deal_Type ON P.Deal_Type_Code = D.Deal_Type_Code                             
   FOR XML PATH('')), 1, 1, '') AS Deal_Type_Name,    
   CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status]     
    FROM Program P WHERE @StrSearchCriteria = '' OR P.Program_Name LIKE '%'+@StrSearchCriteria+'%'    
   -- UNION ALL    
   --SELECT 0,@Col_Head01,@Col_Head02,GETDATE(),@Col_Head03,@Col_Head04,@Col_Head05    
    ) X       
                        
    ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN PROGRAM_NAME END ASC,            
    CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN PROGRAM_NAME END DESC,            
    CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC     
   
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'ProgramCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'ProgramName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Genres' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'DealType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('ProgramCode','ProgramName', 'Genres','DealType','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  
  INSERT INTO #tmpMulExportToExcel    
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,@Col_Head04 as Col04,@Col_Head05 as Col05,''as Col06,''as Col07,''as Col08,''as Col09  
    ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
    ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
     UNION ALL  
    SELECT * FROM #tmpExportToExcel   
    
    END    
  --END PROGRAM--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
  --LOGIN DETAILS REPORT-----------------------------------------------------------------------------------------------------------------------------------------------    
    IF(@Module_Code = 115)                      
    BEGIN     
     DECLARE @SQL NVARCHAR(4000)  
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'FirstName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MiddleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'LastName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,    
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'LoginName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,    
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'LoginTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'LogoutTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,    
   @Col_Head07 = CASE WHEN  SM.Message_Key = 'SecurityGroupName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,    
   @Col_Head08 = CASE WHEN  SM.Message_Key = 'Duration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END    
        
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('FirstName','MiddleName', 'LastName','LoginName','LoginTime','LogoutTime','SecurityGroupName','Duration')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
     
   SET @SQL = 'INSERT INTO #tmpExportToExcel (Col01, Col02, Col03, Col04, Col05,Col06,Col07,Col08)    
  SELECT [first_name], [middle_Name],[last_name],[login_name], [LoginTime],[LogoutTime],[Security Group Name], [duration] FROM (    
  SELECT    
  Sorter = 1,     
  first_name,middle_Name,last_name    
  ,login_name,CONVERT(VARCHAR,LD.Login_Time,113) AS LoginTime, CONVERT(VARCHAR,LD.Logout_Time,113) AS LogoutTime,SG.security_group_name AS [Security Group Name]    
  ,CAST(DATEDIFF(MI,Login_Time,Logout_Time) AS NVARCHAR(500)) AS duration, Login_Time    
  FROM Login_Details LD    
  INNER JOIN Users U ON U.users_code = LD.Users_Code    
  INNER JOIN Security_Group SG ON U.security_group_code = SG.security_group_code      
  WHERE 1 =1 '+ @StrSearchCriteria + '  
  ) X               
  ORDER BY  Login_Time DESC'       
  
  EXEC (@SQL)  
  
  INSERT INTO #tmpMulExportToExcel    
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,@Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,@Col_Head07 as Col07,@Col_Head08 as Col08,''as Col09  
    ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
    ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
     UNION ALL  
    SELECT * FROM #tmpExportToExcel   
    END    
  --END LOGIN DETAILS REPORT-------------------------------------------------------------------------------------------------------------------------------------------      
    
  --PROMOTER REMARKS-----------------------------------------------------------------------------------------------------------------------------------------------    
  IF(@Module_Code = 178)                      
  BEGIN       
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'PromoterRemarksCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'PromoterRemarksDesc' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
     
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('PromoterRemarksCode','PromoterRemarksDesc','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  INSERT INTO #tmpExportToExcel (Col01, Col02, Col03)    
   SELECT [Promoter Remarks Code], [Promoter_Remarks_Desc],[Status] FROM (    
    
   SELECT    
   Sorter = 1,    
   CAST(Promoter_Remarks_Code AS VARCHAR(200)) AS [Promoter Remarks Code], Promoter_Remark_Desc AS [Promoter_Remarks_Desc],     
   CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time     
   FROM Promoter_Remarks  WHERE @StrSearchCriteria = '' OR Promoter_Remark_Desc LIKE '%'+@StrSearchCriteria+'%'  
   ) X                                 
   ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order = 'ASC' THEN Promoter_Remarks_Desc END ASC,            
   CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Promoter_Remarks_Desc END DESC,            
   CASE WHEN @Sort_Column= 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC     
  
   INSERT INTO #tmpMulExportToExcel    
   SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,'' as Col04,'' as Col05,'' as Col06,'' as Col07,'' as Col08,''as Col09  
    ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
    ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
     UNION ALL  
    SELECT * FROM #tmpExportToExcel   
  END    
  --END PROMOTER REMARKS-------------------------------------------------------------------------------------------------------------------------------------------     
  
  --Party Category-------------------------------------------------------------------------------------------------------------------------------------------------
    IF(@Module_Code = 209)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)                                
    --SELECT 'Party Category Code', 'Party Category Name', 'Status'                             
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'PartyCategoryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'PartyCategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('PartyCategoryCode','PartyCategoryName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)    
  SELECT [Party_Category_Code],Party_Category_Name,[Status] FROM(    
  SELECT     
  Sorter = 1,    
  CAST(Party_Category_Code AS VARCHAR(500)) AS [Party_Category_Code], Party_Category_Name AS Party_Category_Name,             
  CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_On     
  FROM Party_Category WHERE @StrSearchCriteria = '' OR Party_Category_Name LIKE '%'+@StrSearchCriteria+'%'        
    ) X                         
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order  = 'ASC' THEN Party_Category_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Party_Category_Name END DESC,            
  CASE WHEN @Sort_Column= 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_On END DESC      
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,'' as Col04,'' as Col05,'' as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END     

  --END Party Category----------------------------------------------------------------------------------------------------------------------------------------------------------

   --Milestone Nature------------------------------------------------------------------------------------------------------------------------------------------------------------                               
    IF(@Module_Code = 203)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)                                
    --SELECT 'Genres Code', 'Genres Name', 'Status'                             
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'MilestoneNatureCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'MilestoneNatureName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,    
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END    
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('MilestoneNatureCode','MilestoneNatureName','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
   INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03)    
  SELECT [Milestone Nature Code],Milestone_Nature_Name,[Status] FROM(    
  SELECT     
  Sorter = 1,    
  CAST(Milestone_Nature_Code AS VARCHAR(500)) AS [Milestone Nature Code], Milestone_Nature_Name AS Milestone_Nature_Name,             
  CASE WHEN Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time     
  FROM Milestone_Nature WHERE @StrSearchCriteria = '' OR Milestone_Nature_Name LIKE '%'+@StrSearchCriteria+'%'            
    ) X                         
  ORDER BY CASE WHEN @Sort_Column = 'NAME' AND  @Sort_Order  = 'ASC' THEN Milestone_Nature_Name END ASC,            
  CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Milestone_Nature_Name END DESC,            
  CASE WHEN @Sort_Column= 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03,'' as Col04,'' as Col05,'' as Col06,''as Col07,''as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END  
   --------------------------------------------------------------------------------------------------------------------------------------------------------------------
   --Customer----------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF(@Module_Code = 211)                                
   BEGIN                                
    --INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05,  Col06, Col07, Col08)                                
    --SELECT 'Party Code', 'Party Name', 'Address' , 'Phone No', 'Party Type', 'CST No', 'Status', 'PartyCategory'                                
    SELECT     
   @Col_Head01 = CASE WHEN  SM.Message_Key = 'PartyCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,    
   @Col_Head02 = CASE WHEN  SM.Message_Key = 'PartyName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END, 
   @Col_Head03 = CASE WHEN  SM.Message_Key = 'PartyCategory' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,       
   @Col_Head04 = CASE WHEN  SM.Message_Key = 'Address' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,     
   @Col_Head05 = CASE WHEN  SM.Message_Key = 'PhoneNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,    
   @Col_Head06 = CASE WHEN  SM.Message_Key = 'PartyType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,    
   @Col_Head07 = CASE WHEN  SM.Message_Key = 'CSTNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07	END,    
   @Col_Head08 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END
  
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)    
   AND SM.Message_Key IN ('PartyCode','PartyName', 'PartyCategory', 'Address','PhoneNo','PartyType','CSTNo','Status')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
     INSERT INTO #tmpExportToExcel (Col01, Col02,  Col03, Col04, Col05,  Col06, Col07, Col08)     
  SELECT [Party Code],[Vendor_Name],[Party Category],[Address],[Phone No],[Party Type],[CST No],[Status] FROM(    
   SELECT     
   Sorter = 1,    
   CAST(v.Vendor_Code AS VARCHAR(10)) AS [Party Code],Vendor_Name AS [Vendor_Name],
    (Select TOP 1 p.Party_Category_Name from Party_Category p where v.Party_Category_Code = p.Party_Category_Code) AS [Party Category],            
   [Address],Phone_No As [Phone No],                                
   Stuff ((SELECT ', '+r.Role_Name from [Role] r INNER JOIN Vendor_Role vr ON v.Vendor_Code=vr.Vendor_Code where r.Role_Code=vr.Role_Code FOR XML PATH('')), 1, 1, '')                                
   AS [Party Type],CST_No AS [CST No],                                
   CASE WHEN v.Is_Active = 'N' THEN @Deactive ELSE @Active END AS [Status], Last_Updated_Time
   FROM Vendor v where v.Party_Type = 'C' AND (@StrSearchCriteria = '' OR v.Vendor_Name Like '%'+@StrSearchCriteria+'%')                            
   ) X    
   ORDER BY CASE WHEN @Sort_Column= 'NAME' AND  @Sort_Order = 'ASC' THEN Vendor_Name END ASC,            
   CASE WHEN @Sort_Column = 'NAME' AND @Sort_Order = 'DSC' THEN Vendor_Name END DESC,            
   CASE WHEN @Sort_Column = 'TIME' AND @Sort_Order = 'DSC' THEN Last_Updated_Time END DESC      
  
  INSERT INTO #tmpMulExportToExcel   
  SELECT  @Col_Head01 as Col01 ,@Col_Head02 as Col02 ,@Col_Head03 as Col03, @Col_Head04 as Col04,@Col_Head05 as Col05,@Col_Head06 as Col06,@Col_Head07 as Col07,@Col_Head08 as Col08,''as Col09  
   ,''as Col10,''as Col11,''as Col12,''as Col13,''as Col14,''as Col15,''as Col16,''as Col17,''as Col18,''as Col19,''as Col20,''as Col21,''as Col22,''as Col23,''as Col24,  
   ''as Col25,''as Col26,''as Col27,''as Col28,''as Col29,''as Col30  
    UNION ALL  
  SELECT * FROM #tmpExportToExcel   
   END    
      
  --END PROGRAM--------------------------------------------------------------------------------------------------------------------------------------------------------    
    
  
  
  SELECT @Column_Count =                               
    LEN(COALESCE(LEFT(Col01,1),''))   + LEN(COALESCE(LEFT(Col02,1),''))  + LEN(COALESCE(LEFT(Col03,1),''))                               
    + LEN(COALESCE(LEFT(Col04,1),''))                              
    + LEN(COALESCE(LEFT(Col05,1),''))                              
    + LEN(COALESCE(LEFT(Col06,1),''))                              
    + LEN(COALESCE(LEFT(Col07,1),''))                              
    + LEN(COALESCE(LEFT(Col08,1),''))                              
    + LEN(COALESCE(LEFT(Col09,1),''))                              
    + LEN(COALESCE(LEFT(Col10,1),''))                              
    + LEN(COALESCE(LEFT(Col11,1),''))                              
    + LEN(COALESCE(LEFT(Col12,1),''))                              
    + LEN(COALESCE(LEFT(Col13,1),''))                              
    + LEN(COALESCE(LEFT(Col14,1),''))                              
    + LEN(COALESCE(LEFT(Col15,1),''))                              
    + LEN(COALESCE(LEFT(Col16,1),''))                              
    + LEN(COALESCE(LEFT(Col17,1),''))                              
    + LEN(COALESCE(LEFT(Col18,1),''))                              
    + LEN(COALESCE(LEFT(Col19,1),''))                              
    + LEN(COALESCE(LEFT(Col20,1),''))                              
    + LEN(COALESCE(LEFT(Col21,1),''))                              
    + LEN(COALESCE(LEFT(Col22,1),''))                              
    + LEN(COALESCE(LEFT(Col23,1),''))                              
    + LEN(COALESCE(LEFT(Col24,1),''))                              
    + LEN(COALESCE(LEFT(Col25,1),''))                              
    + LEN(COALESCE(LEFT(Col26,1),''))                              
    + LEN(COALESCE(LEFT(Col27,1),''))                              
    + LEN(COALESCE(LEFT(Col28,1),''))                              
    + LEN(COALESCE(LEFT(Col29,1),''))                              
    + LEN(COALESCE(LEFT(Col30,1),''))                              
    FROM                               
    (                              
    SELECT top 1 * FROM #tmpExportToExcel                                
    ) AS A                              
  SELECT * FROM #tmpMulExportToExcel  
   --DROP TABLE #tmpExportToExcel     
   -- DROP TABLE #tmpMulExportToExcel     
   --PRINT @SqlString                                
   --EXEC(@SqlString)                                                               
 END

--DECLARE @Count INT = 0
--exec USP_Export_Table_To_Excel 3,@Count,'TIME','DSC',1,''