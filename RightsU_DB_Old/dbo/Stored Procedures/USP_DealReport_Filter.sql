ALTER PROCEDURE [dbo].[USP_DealReport_Filter]      
(      
 @Title_Code VARCHAR(MAX),       
 @Platform_Code VARCHAR(MAX),      
 @Country_Code VARCHAR(MAX),      
 @Subtit_Language_Code VARCHAR(MAX),      
 @BussinessUnit_Code VARCHAR(MAX),      
 @Dubbing_Language_Code VARCHAR(MAX),      
 @Deal_Tag_Code VARCHAR(MAX),      
 @Platform_MustHave Varchar(Max)='0',      
 @Dubbing_Subtitling Varchar(20),      
 @Region_MustHave Varchar(Max)='0',      
 @Region_Exclusion Varchar(Max)='0',      
 @Title_Language_Code Varchar(Max)='0',  
 @User_Code VARCHAR(MAX)='0',  
 @Acq_Deal_Code INT = 0,
 @Syn_Deal_Code Varchar(Max)='0',   
 @Channel_Code VARCHAR(MAX)='0',  
 @Music_Label_Code VARCHAR(MAX)='0',   
 @Content_Code VARCHAR(MAX)='0',  
 @Content_Code_ID VARCHAR(MAX)='0',
 @Music_Type_Code VARCHAR(MAX)='0',
 @Genres_Code VARCHAR(MAX)='0',
 @Music_Theme_Code VARCHAR(MAX)= '0',
 @Talent_Code VARCHAR(MAX)='0',
 @Music_Title_Code Varchar(MAX)='0',
 @Document_Type_Code VARCHAR(MAX)='0',
 @Deal_Type_Code VARCHAR(MAX) = '0',
 @MHProduction_House_Code VARCHAR(MAX) = '0',
 @MHStatus_Code VARCHAR(MAX) = '0',
 @MilestoneNatureCode VARCHAR(MAX) = '0'
)      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
 SET FMTONLY OFF;      
      
 SET @Title_Code = ISNULL(@Title_Code,' ')  
 SET @Platform_Code = ISNULL(@Platform_Code,' ')  
 SET @Country_Code = ISNULL(@Country_Code,' ')  
 SET @Subtit_Language_Code = ISNULL(@Subtit_Language_Code,' ')  
 SET @BussinessUnit_Code = ISNULL(@BussinessUnit_Code,' ')  
 SET @Dubbing_Language_Code = ISNULL(@Dubbing_Language_Code,' ')  
 SET @Deal_Tag_Code = ISNULL(@Deal_Tag_Code,' ')  
 SET @Platform_MustHave = ISNULL(@Platform_MustHave,' ')  
 SET @Dubbing_Subtitling = ISNULL(@Dubbing_Subtitling,' ')  
 SET @Region_MustHave = ISNULL(@Region_MustHave,' ')  
 SET @Title_Language_Code = ISNULL(@Title_Language_Code,' ')  
 SET @Region_Exclusion = ISNULL(@Region_Exclusion,' ')  
 SET @User_Code = ISNULL(@User_Code,' ')  
 SET @Acq_Deal_Code = ISNULL(@Acq_Deal_Code,0)
 SET @Syn_Deal_Code = ISNULL(@Syn_Deal_Code,'0')    
 SET @Channel_Code = ISNULL(@Channel_Code,' ')  
 SET @Music_Label_Code = ISNULL(@Music_Label_Code,' ')  
 SET @Content_Code = ISNULL(@Content_Code, ' ')  
 SET @Content_Code_ID = ISNULL(@Content_Code_ID, ' ') 
 SET @Music_Type_Code = ISNULL(@Music_Type_Code,' ' )
 SET @Genres_Code = ISNULL(@Genres_Code,' ')
 SET @Music_Theme_Code = ISNULL(@Music_Theme_Code,' ')
 SET @Talent_Code = ISNULL(@Talent_Code,' ')
 SET @Music_Title_Code = ISNULL(@Music_Title_Code,' ')
 SET @Document_Type_Code = ISNULL(@Document_Type_Code,' ')
 SET @Deal_Type_Code = ISNULL(@Deal_Type_Code,' ')
 SET @MHProduction_House_Code = ISNULL(@MHProduction_House_Code,' ')
 SET @MHStatus_Code = ISNULL(@MHStatus_Code,' ')
 SET @MilestoneNatureCode = ISNULL(@MilestoneNatureCode ,' ')
  
--  use rightsU_plus
--EXEC [USP_DEALREPORT_FILTER]    
-- @TITLE_CODE = NULL,     
-- @PLATFORM_CODE = NULL,    
-- @COUNTRY_CODE = '',    
-- @SUBTIT_LANGUAGE_CODE = '',    
-- @DUBBING_LANGUAGE_CODE = '',    
-- @PLATFORM_MUSTHAVE ='',    
-- @DUBBING_SUBTITLING = '',    
-- @REGION_MUSTHAVE ='',    
-- @REGION_EXCLUSION ='',    
-- @TITLE_LANGUAGE_CODE ='',    
-- @BUSSINESSUNIT_CODE = '',    
-- @DEAL_TAG_CODE = '' ,   
-- @USER_CODE = '' ,   
-- @CHANNEL_CODE = '',  
-- @MUSIC_LABEL_CODE = '',  
-- @CONTENT_CODE = '',
-- @MUSIC_TYPE_CODE ='',
--@GENRES_CODE ='',
--@MUSIC_THEME_CODE= '',
--@TALENT_CODE=NULL,
--@MUSIC_TITLE_CODE ='59086,62562' ,
--@Acq_Deal_Code = 0,
--@Syn_Deal_Code = 44
--@Document_Type_Code = '6',
--@MilestoneNatureCode  = '0'
      
 Declare @territoryCodes varchar(max),@countryCodes varchar(max),@languageGroupCodes varchar(max),@subtiti_languageCodes varchar(max),@dubbing_languageCodes varchar(max) ,@userCodes varchar(max),@channelCodes varchar(max), @musicLabelCodes varchar(max), @contentCodes varchar(max)     
 DECLARE @MusicTitleNames NVARCHAR(MAX), @TitleNames NVARCHAR(MAX), @PlatformNames NVARCHAR(MAX),@BussinessUnitNames NVARCHAR(MAX), @DealTag_Names NVARCHAR(MAX), @TerritoryNames NVARCHAR(MAX), @CountryNames NVARCHAR(MAX), @Platform_MustHavesNames NVARCHAR(MAX) ,@UserNames NVARCHAR(MAX) ,
 @MusicTypeName NVARCHAR(MAX),@GenreName NVARCHAR(MAX),@MusicThemeName NVARCHAR(MAX),@TalentName NVARCHAR(MAX),@DocumentTypeNames NVARCHAR(MAX)
    
 , @LanguageGroupNames NVARCHAR(MAX), @Subtit_LanguageNames NVARCHAR(MAX), @MustHaveCountryNames NVARCHAR(MAX), @Dubbing_LanguageNames NVARCHAR(MAX)    
 DECLARE @TitleLanguage_Names NVARCHAR(MAX)='', @ExclusionCountryNames NVARCHAR(MAX)='', @Tmp_MustHaveCountryNames NVARCHAR(MAX)='', @SubDub NVARCHAR(MAX) ='',@Agreement_No NVARCHAR(MAX) = '',@Channel_Names NVARCHAR(MAX), @Music_Label_Names NVARCHAR(MAX),
 @Content_Names NVARCHAR(MAX),@Content_Names_ID NVARCHAR(MAX) ,@Deal_Type_Name NVARCHAR(MAX) = '', @Production_House_Name NVARCHAR(MAX) = '' , @MHStatus_Name NVARCHAR(MAX) = '',@MilestoneNatureName NVARCHAR(MAX)='' 
 /*---Start Title---*/      
       
 --select number INTO #Temp_Title from dbo.fn_Split_withdelemiter(@Title_Code,',') Where number Not In('0', '')      
 --Delete From #Temp_Title Where number = 0      
  IF @Acq_Deal_Code > 0  
    BEGIN  
 SET @Agreement_No = (SELECT AD.Agreement_No from Acq_Deal AD where AD.Acq_Deal_Code = @Acq_Deal_Code)  
 END  
  
IF @Syn_Deal_Code > 0  
    BEGIN  
 SET @Agreement_No = (SELECT AD.Agreement_No from Syn_Deal AD where AD.Syn_Deal_Code = @Syn_Deal_Code)  
 END
  -----Music Title------------------------------------
 SET @MusicTitleNames =ISNULL(STUFF((SELECT DISTINCT ',' + mt.Music_Title_Name
 FROM Music_Title mt       
 WHERE mt.Music_Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Music_Title_Code,',') WHERE number NOT IN('0', ''))      
 FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  

	SET @MusicTitleNames = Case when @Music_Title_Code = '' Then 'NA' ELSE @MusicTitleNames END
	
------------------------------------------------------------------------------------

 SET @TitleNAmes =ISNULL(STUFF((SELECT DISTINCT ',' + t.Title_Name       
 FROM Title t       
 WHERE t.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Code,',') WHERE number NOT IN('0', ''))      
 FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '') 
SET @TitleNames = Case when @Title_Code = '' Then 'NA' ELSE @TitleNames END
	
   
 /*---End Title---*/      
        
 /*---Start Platform---*/      
       
 --select Cast(number As Int) number INTO #Temp_Platform from dbo.fn_Split_withdelemiter(@Platform_Code,',') Where number Not In('0', '')      
 --Delete From #Temp_Platform Where number = 0      
      
 SET @PlatformNames =ISNULL(STUFF((SELECT DISTINCT ',' + p.Platform_Hiearachy      
 FROM Platform p       
 WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Platform_Code,',') WHERE number NOT IN('0', ''))      
 AND p.Is_Last_Level = 'Y'      
 FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')      		
 SET @PlatformNames = Case when @Platform_Code = '' Then 'NA' ELSE @PlatformNames END
	
      
      
 SET @BussinessUnitNames =ISNULL(STUFF((SELECT DISTINCT ',' + b.Business_Unit_Name      
 FROM Business_Unit b       
 WHERE b.Business_Unit_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@BussinessUnit_Code,',') WHERE number NOT IN('0', ''))      
 AND b.Is_Active = 'Y'      
 FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  
	IF(@BussinessUnit_Code = 0)
	BEGIN
		SET @BussinessUnitNames = 'All Business Unit'
	END
	ELSE
	BEGIN
		SET @BussinessUnitNames= Case when @BussinessUnit_Code = '' Then 'NA' ELSE @BussinessUnitNames END
	END

 /*---End Platform---*/      
       
 /*---Start Country---*/      
       
 SET @countryCodes =  IsNull(STUFF((SELECT DISTINCT ',' + number FROM fn_Split_withdelemiter(@Country_Code,',') WHERE number NOT LIKE 'T%'       
 AND number NOT IN('0')      
 --OR number = '0'      
  FOR XML PATH(''), TYPE      
  ).value('.', 'NVARCHAR(MAX)')      
 , 1, 1, ''), '')   
 
 
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
SET @CountryNames = Case when @countryCodes = '' Then 'NA' ELSE @CountryNames END
      
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
      
 SET @TerritoryNames =ISNULL(STUFF((SELECT DISTINCT ',' + t.Territory_Name      
 FROM Territory t       
 WHERE t.Territory_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@territoryCodes,',') WHERE number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')   
SET @TerritoryNames = Case when @territoryCodes = '' Then 'NA' ELSE @TerritoryNames END
	
      
 /*---End Territory---*/      
       
 /*---Start Must Have Platform---*/      
       
 --select Cast(number As Int) number INTO #Temp_MustHave from dbo.fn_Split_withdelemiter(@Platform_MustHave,',') Where number Not In('0', '')      
 --Delete From #Temp_MustHave Where number = 0      
      
 SET @Platform_MustHavesNames =ISNULL(STUFF((SELECT DISTINCT ',' + p.Platform_Hiearachy      
 FROM Platform p       
 WHERE p.Platform_Code IN (SELECT CAST(number AS INT) number from dbo.fn_Split_withdelemiter(@Platform_MustHave,',') Where number Not In('0', ''))      
 AND p.Is_Last_Level = 'Y'      
 FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')   

	  
 /*---End Must Have  Platform---*/      
       
 --Select @SubTit_Language_Code = LTRIM(Rtrim(@SubTit_Language_Code))      
 --Select @Dubbing_Language_Code = LTRIM(Rtrim(@Dubbing_Language_Code))      
 --/*---Start Language ---*/        
      
 SET @subtiti_languageCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'L','') from fn_Split_withdelemiter(@SubTit_Language_Code,',') Where number like 'L%' And number Not In('0')      
  --OR number = '0'      
            FOR XML PATH(''), TYPE      
            ).value('.', 'NVARCHAR(MAX)')      
        ,1,1,''), '')      
      
 SET @dubbing_languageCodes =  IsNull(STUFF((SELECT distinct ',' + REPLACE(number,'L','') from fn_Split_withdelemiter(@Dubbing_Language_Code,',') Where number like 'L%' And number Not In('0')      
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
	
	SET @Subtit_LanguageNames = Case when @subtiti_languageCodes = '' Then 'NA' ELSE @Subtit_LanguageNames END
	
      
      
 SET @Dubbing_LanguageNames =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name      
 FROM Language l       
 WHERE l.language_code IN (select number from dbo.fn_Split_withdelemiter(@dubbing_languageCodes,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')   
	
	SET @Dubbing_LanguageNames = Case when @dubbing_languageCodes = '' Then 'NA' ELSE @Dubbing_LanguageNames END
        
 /*---End Language ---*/        
      
 /*---Start Must Have Country---*/      
       
 --select Cast(number As Int) number INTO #Temp_MustHave_Region from dbo.fn_Split_withdelemiter(@Region_MustHave,',') Where number Not In('0', '')      
 --Delete From #Temp_MustHave_Region Where number = 0      
      
 --SET @MustHaveCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name      
 --FROM Country c       
 --WHERE c.Country_Code IN (select Cast(number As Int) number FROM dbo.fn_Split_withdelemiter(@Region_MustHave,',') Where number Not In('0', ''))      
 --FOR XML PATH(''), TYPE      
 --   ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      
      
       
        
 SELECT @Tmp_MustHaveCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + REPLACE(number, 'C', '') FROM fn_Split_withdelemiter(@Region_MustHave, ',') WHERE number NOT IN('0','')      
   FOR XML PATH(''), TYPE      
   ).value('.', 'NVARCHAR(MAX)')      
  , 1, 1, ''), '')      
      
        
 SET @MustHaveCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name      
 FROM Country c       
 WHERE c.Country_Code IN (select Cast(number As Int) number FROM dbo.fn_Split_withdelemiter(@Tmp_MustHaveCountryNames,',') Where number Not In('0', ''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      
 /*---End Must Have  Country---*/      
      
 /*---Country Exclusion---*/      
       
 --select Cast(number As Int) number INTO #Temp_MustHave_Region from dbo.fn_Split_withdelemiter(@Region_MustHave,',') Where number Not In('0', '')      
 --Delete From #Temp_MustHave_Region Where number = 0      
       
      
 SET @ExclusionCountryNames =ISNULL(STUFF((SELECT DISTINCT ',' + c.Country_Name      
 FROM Country c       
 WHERE c.Country_Code IN (select Cast(number As Int) number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion,',') Where number Not In('0', ''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      
      
 /*---End Country Exclusion---*/      
        
      
      
  /*---Title Language---*/      
        
  SET @TitleLanguage_Names =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name      
 FROM Language l      
 WHERE l.Language_Code IN (select number from dbo.fn_Split_withdelemiter(@Title_Language_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')     
 
 SET @TitleLanguage_Names = Case when @Title_Language_Code = '' Then 'NA' ELSE @TitleLanguage_Names END
      
 SET @DealTag_Names =ISNULL(STUFF((SELECT DISTINCT ',' + Dl.Deal_Tag_Description      
 FROM Deal_Tag Dl      
 WHERE Dl.Deal_Tag_Code IN (select number from dbo.fn_Split_withdelemiter(@Deal_Tag_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')  
 
 SET @DealTag_Names = Case when @Deal_Tag_Code = '' Then 'NA' ELSE @DealTag_Names END
 
 /*---End Title Language---*/      
      
/*--User Names...*/  
SET @UserNames =ISNULL(STUFF((SELECT DISTINCT ',' + U.Login_Name      
 FROM Users U      
 WHERE U.Users_Code IN (select number from dbo.fn_Split_withdelemiter(@User_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      

 SET @UserNames = Case when @User_Code = '' Then 'NA' ELSE @UserNames END
/*....End User Names....*/  
  
 /*....Document Type Names....*/
 SET @DocumentTypeNames =ISNULL(STUFF((SELECT DISTINCT ',' + DT.Document_Type_Name
 FROM Document_Type DT
 WHERE DT.Document_Type_Code IN (Select number from dbo.fn_Split_withdelemiter(@Document_Type_Code, ',')Where number NOT IN('0',''))
 FOR XML PATH(''), TYPE  
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')   

 SET @DocumentTypeNames = Case when @Document_Type_Code = '' Then 'NA' ELSE @DocumentTypeNames END
 /*....End Document Type Names....*/


/*--Channel Names...*/  
SET @Channel_Names =ISNULL(STUFF((SELECT DISTINCT ',' + C.Channel_Name      
 FROM Channel C      
 WHERE C.Channel_Code IN (select number from dbo.fn_Split_withdelemiter(@Channel_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      

SET @Channel_Names = Case when @Channel_Code = '' Then 'NA' ELSE @Channel_Names END
 
/*....End Channel Names....*/  
    
  /*--Music Label Names...*/  
SET @Music_Label_Names =ISNULL(STUFF((SELECT DISTINCT ',' + M.Music_Label_Name      
 FROM Music_Label M      
 WHERE M.Music_Label_Code IN (select number from dbo.fn_Split_withdelemiter(@Music_Label_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      

 SET @Music_Label_Names = Case when @Music_Label_Code = '' Then 'NA' ELSE @Music_Label_Names END
 
/*....End Music Label Names....*/  
  
/*--Content Names...*/  
SET @Content_Names =ISNULL(STUFF((SELECT DISTINCT ',' + Co.Episode_Title      
 FROM Title_Content Co     
 WHERE Co.Title_Code IN (select number from dbo.fn_Split_withdelemiter(@Content_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      

 SET @Content_Names = Case when @Content_Code = '' Then 'NA' ELSE @Content_Names END
 
/*....End Content Names....*/  
  
SET @Content_Names_ID =ISNULL(STUFF((SELECT DISTINCT ',' + Co.Episode_Title      
 FROM Title_Content Co     
 WHERE Co.Title_Content_Code IN (select number from dbo.fn_Split_withdelemiter(@Content_Code_ID,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    
  

  SET @MusicTypeName =ISNULL(STUFF((SELECT DISTINCT ',' + mt.Music_Type_Name
 FROM Music_Type Mt     
 WHERE mt.Music_Type_Code IN (select number from dbo.fn_Split_withdelemiter(@Music_Type_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '') 
 
 SET @MusicTypeName = Case when @Music_Type_Code = '' Then 'NA' ELSE @MusicTypeName END
 

 SET @GenreName =ISNULL(STUFF((SELECT DISTINCT ',' + g.Genres_Name
 FROM Genres g     
 WHERE g.Genres_Code IN (select number from dbo.fn_Split_withdelemiter(@Genres_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

 SET @GenreName = Case when @Genres_Code = '' Then 'NA' ELSE @GenreName END
 

 SET @MusicThemeName =ISNULL(STUFF((SELECT DISTINCT ',' + mth.Music_Theme_Name
 FROM Music_Theme mth     
 WHERE mth.Music_Theme_Code IN (select number from dbo.fn_Split_withdelemiter(@Music_Theme_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

 SET @MusicThemeName = Case when @Music_Theme_Code = '' Then 'NA' ELSE @MusicThemeName END
 

 
 SET @TalentName =ISNULL(STUFF((SELECT DISTINCT ',' + t.Talent_Name
 FROM Talent t     
 WHERE t.Talent_Code IN (select number from dbo.fn_Split_withdelemiter(@Talent_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

 SET @TalentName = Case when @Talent_Code = '' Then 'NA' ELSE @TalentName END
 

 SET @Deal_Type_Name =ISNULL(STUFF((SELECT DISTINCT ',' + DT.Deal_Type_Name 
 FROM Deal_Type DT     
 WHERE DT.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(@Deal_Type_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

 SET @Deal_Type_Name = Case when @Deal_Type_Code = '' Then 'NA' ELSE @Deal_Type_Name END


 SET @Production_House_Name = ISNULL(STUFF((SELECT DISTINCT ',' + V.Vendor_Name 
 FROM Vendor V  WHERE V.Vendor_Code IN (select number from dbo.fn_Split_withdelemiter(@MHProduction_House_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

 SET @Production_House_Name = Case when @MHProduction_House_Code = '' Then 'NA' ELSE @Production_House_Name END
 

  SET @MHStatus_Name = ISNULL(STUFF((SELECT DISTINCT ',' + S.RequestStatusName
 FROM MHRequestStatus S  WHERE S.MHRequestStatusCode IN (select number from dbo.fn_Split_withdelemiter(@MHStatus_Code,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

 SET @MHStatus_Name = Case when @MHStatus_Code = '' Then 'NA' ELSE @MHStatus_Name END
 
 SET @MilestoneNatureName =ISNULL(STUFF((SELECT DISTINCT ',' + MN.Milestone_Nature_Name
 FROM Milestone_Nature MN     
 WHERE MN.Milestone_Nature_Code IN (select number from dbo.fn_Split_withdelemiter(@MilestoneNatureCode,',') Where number NOT IN ('0',''))      
 FOR XML PATH(''), TYPE      
 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

 SET @MilestoneNatureName =  Case when @MilestoneNatureCode = '' Then 'NA' ELSE @MilestoneNatureName END
 

 SELECT @Production_House_Name Production_House_Name,@MHStatus_Name MHStatus_Name, @MusicTypeName Music_Type_Name,@GenreName Genres_Name,@MusicThemeName Music_Theme_Name,@TalentName Talent_Name, @Content_Names_ID ContentNameID,@Content_Names ContentNames,@Music_Label_Names MusicLabelNames,@Channel_Names ChannelNames,@Agreement_No AgreementNo,@DocumentTypeNames DocumentTypeNames,@UserNames UserNames,@TitleNames TitleNames, @PlatformNames PlatformNames,@BussinessUnitNames BussinessUnitNames,@DealTag_Names DealTagName, @CountryNames CountryNames, @TerritoryNames TerritoryNames, @MusicTitleNames MusicTitleNames,@Platform_MustHavesNames MustHavePlatformsNames      
 , @Subtit_LanguageNames Subtit_LanguageNames, @Dubbing_LanguageNames Dubbing_LanguageNames, getdate() Created_On, @MustHaveCountryNames MustHaveCountryNames,@Deal_Type_Name DealTypeName     
 ,@ExclusionCountryNames ExclusionCountryNames, @TitleLanguage_Names TitleLanguage_Names, @LanguageGroupNames LanguageGroupNames, @SubDub SubtitlingDubbing,@MilestoneNatureName Milestone_Nature_Name, Parameter_Value AS 'BGColor', GETDATE() AS CreatedOn,    
                             (SELECT        TOP (1) Parameter_Value    
                               FROM            System_Parameter_New    
                               WHERE        (Parameter_Name = 'FontColor')) AS 'FontColor'    
FROM            System_Parameter_New AS System_Parameter_New_1    
WHERE        (Parameter_Name = 'ReportBGColor')    
      
 --DROP TABLE #Temp_Country      
 --DROP TABLE #Temp_Language      
 --DROP TABLE #Temp_Title      
 --DROP TABLE #Temp_Platform      
 --DROP TABLE #Temp_LanguageGroup      
 --DROP TABLE #Temp_Territory      
 --DROP TABLE #Temp_MustHave      
          
      
END   
  
 EXEC USP_DealReport_Filter '','','','','','','','','','','','','',0,'','','','','','','','','','','','','','',''