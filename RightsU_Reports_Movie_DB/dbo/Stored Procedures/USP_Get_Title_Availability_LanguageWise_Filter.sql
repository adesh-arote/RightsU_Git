
--sp_helptext USP_Get_Title_Availability_LanguageWise_Filter      
      
 --use RightsU_Reports_Movie        
-- Select * from Language        
--Select * from Language_Group        
--select * from Language_Group_Details        
 --exec USP_Get_Title_Availability_LanguageWise_Filter '','1',1,'1,2,3','','1,2,3','','','','',3,'N',1,'1,2,3','5,6',2,'7,8','9,10,11',1,'1,2,3',T1         
 --select * from Platform_Group        
 --select * from Platform        
 --select * from Report_Territory_Country        
         
        
CREATE PROCEDURE [dbo].[USP_Get_Title_Availability_LanguageWise_Filter]          
(          
 @Title_Code VARCHAR(MAX),           
 @Platform_Code VARCHAR(MAX),          
 @Country_Code VARCHAR(MAX),          
 @Subtit_Language_Code VARCHAR(MAX),          
 @Dubbing_Language_Code VARCHAR(MAX),          
 @MustHavePlatform Varchar(Max)='0',          
 @Dubbing_Subtitling Varchar(20),          
 @MustHaveRegion Varchar(Max)='0',          
 @Region_Exclusion Varchar(Max)='0',          
 @Title_Language_Code Varchar(Max)='0',          
 @CallFrom INT ,          
 @Is_IFTA_Cluster CHAR(1) = 'N' ,        
 @Subtitling_Group_Code varchar(max),        
 @Subtitling_MustHave varchar(max),        
 @Subtitling_Exclusion varchar(max),        
 @Dubbing_Group_Code varchar(max),        
 @Dubbing_MustHave varchar(max),        
 @Dubbing_Exclusion varchar(max),        
 @Platform_Group_Code varchar(max),        
 @MustHave_Platform varchar(max),      
 @Territory_Code  varchar(max)        
         
)          
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;          
 SET FMTONLY OFF;          
    

	Insert InTo TestParam(Params, ProcType)
	Select '@Title_Code=''' + CAST(@Title_Code AS VARCHAR(MAX)) +
	''', @Platform_Code=''' + CAST(ISNULL(@Platform_Code, '') AS VARCHAR(MAX)) +
	''', @Country_Code=''' + CAST(ISNULL(@Country_Code, '') AS VARCHAR(MAX)) +
	''', @Subtit_Language_Code=''' + CAST(ISNULL(@Subtit_Language_Code, '') AS VARCHAR(MAX)) +
	''', @Dubbing_Language_Code=''' + CAST(ISNULL(@Dubbing_Language_Code, '') AS VARCHAR(MAX)) +
	''', @MustHavePlatform=''' + CAST(ISNULL(@MustHavePlatform, '') AS VARCHAR(MAX)) +
	''', @Dubbing_Subtitling=''' + CAST(ISNULL(@Dubbing_Subtitling, '') AS VARCHAR(MAX)) +
	''', @MustHaveRegion=''' + CAST(ISNULL(@MustHaveRegion, '') AS VARCHAR(MAX)) +
	''', @Region_Exclusion=''' + CAST(ISNULL(@Region_Exclusion, '') AS VARCHAR(MAX)) +
	''', @Title_Language_Code=''' + CAST(ISNULL(@Title_Language_Code, '') AS VARCHAR(MAX)) +
	''', @CallFrom=''' + CAST(ISNULL(@CallFrom, '') AS VARCHAR(MAX)) +
	''', @Is_IFTA_Cluster=''' + CAST(ISNULL(@Is_IFTA_Cluster, '') AS VARCHAR(MAX)) +
	''', @Subtitling_Group_Code=''' + CAST(ISNULL(@Subtitling_Group_Code, '') AS VARCHAR(MAX)) +
	''', @Subtitling_MustHave=''' + CAST(ISNULL(@Subtitling_MustHave, '') AS VARCHAR(MAX)) +
	''', @Subtitling_Exclusion=''' + CAST(ISNULL(@Subtitling_Exclusion, '') AS VARCHAR(MAX)) +
	''', @Dubbing_Group_Code=''' + CAST(ISNULL(@Dubbing_Group_Code, '') AS VARCHAR(MAX)) +
	''', @Dubbing_MustHave=''' + CAST(ISNULL(@Dubbing_MustHave, '') AS VARCHAR(MAX)) +
	''', @Dubbing_Exclusion=''' + CAST(ISNULL(@Dubbing_Exclusion, '') AS VARCHAR(MAX)) +
	''', @Platform_Group_Code=''' + CAST(ISNULL(@Platform_Group_Code, '') AS VARCHAR(MAX)) +
	''', @MustHave_Platform=''' + CAST(ISNULL(@MustHave_Platform, '') AS VARCHAR(MAX)) +
	''', @Territory_Code=''' + CAST(ISNULL(@Territory_Code, '') AS VARCHAR(MAX)), 'Filter'
          
 Declare @territoryCodes varchar(max),@countryCodes varchar(max),@languageGroupCodes varchar(max),@subtiti_languageCodes varchar(max),@dubbing_languageCodes varchar(max),        
   @subtitlingGroupCode varchar(max),@subtitlingMustHave varchar(max), @subtitlingExclusion varchar(max),@dubbingGroupCode varchar(max)        
 DECLARE @TitleNames NVARCHAR(MAX), @PlatformNames NVARCHAR(MAX), @TerritoryNames NVARCHAR(MAX), @CountryNames NVARCHAR(MAX), @MustHavePlatformsNames NVARCHAR(MAX)          
 , @LanguageGroupNames NVARCHAR(MAX), @Subtit_LanguageNames NVARCHAR(MAX), @MustHaveCountryNames NVARCHAR(MAX), @Dubbing_LanguageNames NVARCHAR(MAX)          
 DECLARE @TitleLanguage_Names NVARCHAR(MAX)='', @ExclusionCountryNames NVARCHAR(MAX)='', @Tmp_MustHaveCountryNames NVARCHAR(MAX)='', @SubDub NVARCHAR(MAX) ='',        
 @SubtitlingGroupName NVARCHAR(MAX),@subtitlingMustHaveNames nvarchar(max),@subtitlingExclusionNames nvarchar(max),        
 @DubbingGroupName NVARCHAR(MAX),@dubbingMustHaveNames nvarchar(max),@dubbingExclusionNames nvarchar(max),        
 @PlatformGroupName nVarchar(MAX),@PlatformMustHaveNames nvarchar(max),      
 @RegionMustHaveNames nvarchar(max),@RegionExclusionNames nvarchar(max)        
 /*---Start Title---*/          
           
 --select number INTO #Temp_Title from dbo.fn_Split_withdelemiter(@Title_Code,',') Where number Not In('0', '')          
 --Delete From #Temp_Title Where number = 0          
          
 SET @TitleNAmes =ISNULL(STUFF((SELECT DISTINCT ',' + t.Title_Name           
 FROM Title t           
 WHERE t.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Code,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
           
 /*---End Title---*/          
        
        
 ------------------New Added Parameters------------------        
     
  SET @subtitlingGroupCode =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'G','') FROM fn_Split_withdelemiter(@Subtitling_Group_Code,',') WHERE number LIKE 'G%' AND number NOT IN('0')          
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        , 1, 1, ''), '')    
     
     
  SET @SubtitlingGroupName =ISNULL(STUFF((SELECT DISTINCT ',' + lg.Language_Group_Name        
 FROM Language_Group LG           
 WHERE lg.Language_Group_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@subtitlingGroupCode,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')        
         
 SET @subtitlingMustHaveNames =ISNULL(STUFF((SELECT DISTINCT ',' + L.Language_Name        
 FROM Language L           
 WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Subtitling_MustHave,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
        
 SET @subtitlingExclusionNames =ISNULL(STUFF((SELECT DISTINCT ',' + L.Language_Name        
 FROM Language L           
 WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Subtitling_Exclusion,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
        
---------------------------------------------------------------------------------------------------        
        
 SET @dubbingGroupCode =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'G','') FROM fn_Split_withdelemiter(@Dubbing_Group_Code,',') WHERE number LIKE 'G%' AND number NOT IN('0')          
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        , 1, 1, ''), '')    
    
 SET @DubbingGroupName =ISNULL(STUFF((SELECT DISTINCT ',' + lg.Language_Group_Name        
 FROM Language_Group LG           
 WHERE lg.Language_Group_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@dubbingGroupCode,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')        
         
 SET @dubbingMustHaveNames =ISNULL(STUFF((SELECT DISTINCT ',' + L.Language_Name        
 FROM Language L           
 WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_MustHave,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
        
 SET @dubbingExclusionNames =ISNULL(STUFF((SELECT DISTINCT ',' + L.Language_Name        
 FROM Language L           
 WHERE L.Language_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Exclusion,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
        
 SET @PlatformGroupName =ISNULL(STUFF((SELECT DISTINCT ',' + PG.Platform_Group_Name        
 FROM Platform_Group PG           
 WHERE PG.Platform_Group_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Platform_Group_Code,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
        
 SET @PlatformMustHaveNames =ISNULL(STUFF((SELECT DISTINCT ',' + P.Platform_Name        
 FROM Platform P           
 WHERE P.Platform_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@MustHave_Platform,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
         
      
   SET @RegionMustHaveNames =ISNULL(STUFF((SELECT DISTINCT ',' +  C.Country_Name        
 FROM Country C           
 WHERE C.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@MustHaveRegion,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
      
 SET @RegionExclusionNames =ISNULL(STUFF((SELECT DISTINCT ',' +  C.Country_Name        
 FROM Country C           
 WHERE C.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion,',') WHERE number NOT IN('0', ''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')        
      
 --------------------------------------------------------           
 /*---Start Platform---*/          
           
 --select Cast(number As Int) number INTO #Temp_Platform from dbo.fn_Split_withdelemiter(@Platform_Code,',') Where number Not In('0', '')          
 --Delete From #Temp_Platform Where number = 0          
          
 SET @PlatformNames =ISNULL(STUFF((SELECT DISTINCT ',' + p.Platform_Hiearachy          
 FROM Platform p           
 WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Platform_Code,',') WHERE number NOT IN('0', ''))          
 AND p.Is_Last_Level = 'Y'          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
          
 /*---End Platform---*/          
           
 /*---Start Country---*/          
 IF(@CallFrom = 3)          
 BEGIN          
  SET @countryCodes =  IsNull(STUFF((SELECT DISTINCT ',' + number FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number NOT LIKE 'T%'           
  AND number NOT IN('0')          
  --OR number = '0'          
   FOR XML PATH(''), TYPE          
   ).value('.', 'NVARCHAR(MAX)')          
  , 1, 1, ''), '')          
 END          
 ELSE IF(@CallFrom = 4)          
 BEGIN          
  SET @countryCodes =  IsNull(STUFF((SELECT DISTINCT ',' + number FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number NOT LIKE 'T%'           
  AND number NOT IN('0')          
  --OR number = '0'          
   FOR XML PATH(''), TYPE          
   ).value('.', 'NVARCHAR(MAX)')          
  , 1, 1, ''), '')          
 END     
 ELSE            
 BEGIN          
  SET @countryCodes =  IsNull(STUFF((SELECT DISTINCT ',' + REPLACE(number,'C','') FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number LIKE 'C%'           
  AND number NOT IN('0')          
  --OR number = '0'          
   FOR XML PATH(''), TYPE          
   ).value('.', 'NVARCHAR(MAX)')          
  , 1, 1, ''), '')          
 END          
 --Create Table #Temp_Country(          
 -- Country_Code Int          
 --)          
          
 --Insert InTo #Temp_Country          
 --select number from dbo.fn_Split_withdelemiter(@countryCodes,',') Where number <> '0'          
          
 --Delete From #Temp_Country Where Country_Code = 0          
          
 SET @CountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name          
 FROM Country c           
 WHERE c.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@countryCodes,',') WHERE number  NOT IN ( '0',''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
          
 /*---End Country---*/          
           
 /*---Start Territory---*/          
           
 SET @territoryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number LIKE 'T%' AND number NOT IN('0')          
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        , 1, 1, ''), '')          
           
 --Create Table #Temp_Territory(          
 -- Territory_Code Int          
 --)          
          
 --Insert InTo #Temp_Territory          
 --select number from dbo.fn_Split_withdelemiter(@territoryCodes,',') Where number <> '0'          
          
 --Delete From #Temp_Territory Where Territory_Code = 0          
          
  IF(@CallFrom = 3)            
  Begin          
          
  IF(@Is_IFTA_Cluster = 'N')          
  BEGIN       
  SET @territoryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@Territory_Code,',') WHERE number LIKE 'T%' AND number NOT IN('0')          
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        , 1, 1, ''), '')    
print @territoryCodes    
         
    SET @TerritoryNames =ISNULL(STUFF((SELECT DISTINCT ',' + t.Territory_Name           
    FROM Territory t             
    WHERE t.Territory_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCodes,',') WHERE number NOT IN ('0',''))            
    FOR XML PATH(''), TYPE            
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')            
        END          
  ELSE IF(@Is_IFTA_Cluster = 'Y')          
  BEGIN     
  SET @territoryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@Territory_Code,',') WHERE number LIKE 'T%' AND number NOT IN('0')          
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        , 1, 1, ''), '')    
           
    SET @TerritoryNames =ISNULL(STUFF((SELECT DISTINCT ',' + t.Report_Territory_Name           
    FROM Report_Territory t             
    WHERE t.Report_Territory_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCodes,',') WHERE number NOT IN ('0',''))            
    FOR XML PATH(''), TYPE            
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')            
        END          
          
 End          
 else IF(@CallFrom = 4)          

  BEGIN       
  SET @territoryCodes =  ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number,'T','') FROM fn_Split_withdelemiter(@Territory_Code,',') WHERE number LIKE 'T%' AND number NOT IN('0')          
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        , 1, 1, ''), '')    
print @territoryCodes    
         
    SET @TerritoryNames =ISNULL(STUFF((SELECT DISTINCT ',' + C.Country_Name           
    FROM Country C             
    WHERE C.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCodes,',') WHERE number NOT IN ('0',''))            
    FOR XML PATH(''), TYPE            
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')            
        END        
 
 
    
 -- SET @TerritoryNames =ISNULL(STUFF((SELECT DISTINCT ',' + t.Country_Name            
 --  FROM Country t             
 --  WHERE t.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCodes,',') WHERE number NOT IN ('0',''))            
 --  FOR XML PATH(''), TYPE            
 --  ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')            
 --end          
 /*---End Territory---*/          
           
 /*---Start Must Have Platform---*/          
           
 --select Cast(number As Int) number INTO #Temp_MustHave from dbo.fn_Split_withdelemiter(@MustHavePlatform,',') Where number Not In('0', '')          
 --Delete From #Temp_MustHave Where number = 0          
          
 SET @MustHavePlatformsNames =ISNULL(STUFF((SELECT DISTINCT ',' + p.Platform_Hiearachy          
 FROM Platform p           
 WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number from dbo.fn_Split_withdelemiter(@MustHavePlatform,',') Where number Not In('0', ''))          
 AND p.Is_Last_Level = 'Y'          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')          
          
 /*---End Must Have  Platform---*/          
           
 Select @SubTit_Language_Code = LTRIM(Rtrim(@SubTit_Language_Code))          
 Select @Dubbing_Language_Code = LTRIM(Rtrim(@Dubbing_Language_Code))          
          
             
  IF(@CallFrom = 2)          
  BEGIN          
 /*---Start Language Group---*/            
          
  SET @languageGroupCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'G','') from fn_Split_withdelemiter(@SubTit_Language_Code,',') Where number like 'G%' And number Not In('0')          
   --OR number = '0'          
    FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)')          
   ,1,1,''), '')          
          
  Create Table #Temp_LanguageGroup(          
   Language_Code Int          
  )          
          
  Insert InTo #Temp_LanguageGroup          
  select number from dbo.fn_Split_withdelemiter(@languageGroupCodes,',') Where number <> '0'          
          
  Delete From #Temp_LanguageGroup Where Language_Code = 0          
          
  SET @LanguageGroupNames =ISNULL(STUFF((SELECT DISTINCT ',' + lg.Language_Group_Name          
  FROM Language_Group lg           
  WHERE lg.Language_Group_Code IN (select number from dbo.fn_Split_withdelemiter(@languageGroupCodes,',') Where number NOT IN ('0',''))          
  FOR XML PATH(''), TYPE          
  ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')          
          
  /*---End Language Group---*/            
          
  IF Exists(Select * where 'S' in (select number from dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))          
  BEGIN           
   SET @SubDub ='Subtitling'          
  END          
  IF Exists(Select * where 'D' in (select number from dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))          
  BEGIN           
   IF(@SubDub ='Subtitling')          
    SET @SubDub =@SubDub +', Dubbing'          
   ELSE          
    SET @SubDub ='Dubbing'          
  END          
 END           
 /*---Start Language ---*/            
          
 SET @subtiti_languageCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'L','') from fn_Split_withdelemiter(@SubTit_Language_Code,',') -- Where number like 'L%' And number Not In('0')   
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        ,1,1,''), '')          
          
 SET @dubbing_languageCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'L','') from fn_Split_withdelemiter(@Dubbing_Language_Code,',') --Where number like 'L%' And number Not In('0')          
  --OR number = '0'          
            FOR XML PATH(''), TYPE          
            ).value('.', 'NVARCHAR(MAX)')          
        ,1,1,''), '')          
          
 --Create Table #Temp_Language(          
 -- Language_Code Int          
 --)          
           
 --Insert InTo #Temp_Language          
 --select number from dbo.fn_Split_withdelemiter(@languageCodes,',') Where number <> '0'          
            
 --Delete From #Temp_Language Where Language_Code = 0          
          
 SET @Subtit_LanguageNames =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name          
 FROM Language l           
 WHERE l.language_code IN (select number from dbo.fn_Split_withdelemiter(@subtiti_languageCodes,',') Where number NOT IN ('0',''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
          
          
 SET @Dubbing_LanguageNames =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name          
 FROM Language l           
 WHERE l.language_code IN (select number from dbo.fn_Split_withdelemiter(@dubbing_languageCodes,',') Where number NOT IN ('0',''))          
 FOR XML PATH(''), TYPE          
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')          
          
            
 /*---End Language ---*/            
          
 /*---Start Must Have Country---*/          
           
 --select Cast(number As Int) number INTO #Temp_MustHave_Region from dbo.fn_Split_withdelemiter(@MustHaveRegion,',') Where number Not In('0', '')          
 --Delete From #Temp_MustHave_Region Where number = 0          
          
 --SET @MustHaveCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name          
 --FROM Country c           
 --WHERE c.Country_Code IN (select Cast(number As Int) number FROM dbo.fn_Split_withdelemiter(@MustHaveRegion,',') Where number Not In('0', ''))          
 --FOR XML PATH(''), TYPE          
 --   ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')          
          
           
            
            
          
 SELECT @TitleNames TitleNames, @PlatformNames PlatformNames, @CountryNames CountryNames, @TerritoryNames TerritoryNames, @MustHavePlatformsNames MustHavePlatformsNames          
 , @Subtit_LanguageNames Subtit_LanguageNames, @Dubbing_LanguageNames Dubbing_LanguageNames, getdate() Created_On, @RegionMustHaveNames MustHaveCountryNames          
 ,@RegionExclusionNames ExclusionCountryNames, @TitleLanguage_Names TitleLanguage_Names, @LanguageGroupNames LanguageGroupNames, @SubDub SubtitlingDubbing ,        
 @SubtitlingGroupName Subtitling_Group_Name,@subtitlingMustHaveNames Subtitling_Must_Have_Names,@subtitlingExclusionNames Subtitling_Exclusion_Names,        
 @DubbingGroupName Dubbing_Group_Name,@dubbingMustHaveNames Dubbing_Must_Have_Names,@dubbingExclusionNames Duubing_Exclusion_Names,        
 @PlatformGroupName Platform_Group_Name,@PlatformMustHaveNames Platform_Must_Have_Names        
          
 --DROP TABLE #Temp_Country          
 --DROP TABLE #Temp_Language          
 --DROP TABLE #Temp_Title          
 --DROP TABLE #Temp_Platform          
 --DROP TABLE #Temp_LanguageGroup          
 --DROP TABLE #Temp_Territory          
 --DROP TABLE #Temp_MustHave          
          
          
END          
          
/*          
          
*/

