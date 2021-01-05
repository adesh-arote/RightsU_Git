
CREATE PROCEDURE [dbo].[USP_Get_Title_Avail_Language_Data_Show]      
	 @Mode CHAR(1),                  
	 @UserCode INT,                  
	 @StrCriteria NVARCHAR(MAX),                  
	 @PageNo INT,                  
	 @OrderByCndition VARCHAR(100),                  
	 @IsPaging VARCHAR(2),                  
	 @PageSize INT,                  
	 --@RecordCount INT OUT,                  
	 @Avail_Report_Schedule_Data Avail_Report_Schedule_Data READONLY    
AS      
BEGIN      
      
 --=============================================      
 --Author:  Faisal Khan      
 --Create date: 06th July, 2016      
 --Description: Fetch Title_Avail_Language Report data from "rightsu_Reports" DB      
 --=============================================      
      
 SET NOCOUNT ON;      
 Set FMTONLY OFF;      
        
 DECLARE @SqlQuery NVARCHAR(MAX)      
       
 --SELECT 0 AS RowNum, 0 AS Avail_Report_Schedule_Code, Title_Code, Platform_Code, Country_Code, Is_Original_Language,       
 -- Dubbing_Subtitling, GroupBy, Node, Language_Code, Date_Type, StartDate, EndDate, User_Code,       
 -- Inserted_On, Report_Status, Report_File_Name, ShowRemark, Email_Status      
 --INTO #Temp  From  rightsu_Reports..Avail_Report_Schedule WHERE 1=2      
       
      
      --drop table #Temp
 CREATE TABLE #Temp(      
	RowNum [int],      
	Avail_Report_Schedule_Code INT,      
	[Title_Code] [varchar](max) NULL,      
	[Platform_Code] [varchar](max) NULL,      
	[Country_Code] [varchar](max) NULL,      
	[Is_Original_Language] [bit] NULL,      
	[Dubbing_Subtitling] [varchar](20) NULL,      
	[GroupBy] [varchar](1) NULL,      
	[Node] [varchar](1) NULL,      
	[Language_Code] [varchar](max) NULL,      
	[Date_Type] [varchar](2) NULL,      
	[StartDate] [varchar](20) NULL,      
	[EndDate] [varchar](20) NULL,      
	[User_Code] [int] NULL,      
	[Inserted_On] [datetime] NULL,      
	[Report_Status] [char](1) NULL,      
	[Report_File_Name] [varchar](500) NULL,      
	[ShowRemark] [varchar](10) NULL,      
	[Email_Status] [char](1) NULL,      
	Visibility [char](2) NULL,      
	ReportName [nvarchar](1000) NULL,      
	RestrictionRemarks [varchar](max) NULL         
	,OthersRemark [varchar](max) NULL         
	,Platform_ExactMatch [char] (10)       
	,MustHave_Platform [varchar](max) NULL         
	,Exclusivity [char]  (1)      
	,SubLicense_Code [varchar](max) NULL        
	,Region_ExactMatch [char] (10)      
	,Region_MustHave [varchar](max) NULL       
	,Region_Exclusion [varchar](max) NULL       
	,Subtit_Language_Code [varchar](max) NULL       
	,Dubbing_Language_Code [varchar](max) NULL        
	,BU_Code INT      
	,Report_Type Char(2)      
	,Episode_From INT      
	,Episode_To INT      
	,Digital bit      
	,IncludeMetadata varchar(50)  
	,Is_IFTA_Cluster char(1)  
	,Platform_Group_Code varchar(max)  
	,Subtitling_Group_Code varchar(max)  
	,Subtitling_ExactMatch char(10)  
	,Subtitling_MustHave varchar(max)  
	,Subtitling_Exclusion varchar(max)  
	,Dubbing_Group_Code varchar(max)  
	,Dubbing_ExactMatch char(10)  
	,Dubbing_MustHave varchar(max)  
	,Dubbing_Exclusion varchar(max)  
	,Territory_Code varchar(max)
	,Indiacast CHAR(2)    
	,Region_On CHAR(2)
	,Include_Ancillary CHAR(1)  
	,Promoter_Code VARCHAR(MAX) NULL
	,MustHave_Promoter VARCHAR(MAX) NULL
	,Promoter_ExactMatch char (10),
	Module_Code INT,
	RecordCount INT
 )      
 DECLARE @ReportDB VARCHAR(50), @Indiacast_Security_group_code INT,  @Security_group_code INT 
 SET @ReportDB = ''      
 SELECT  @ReportDB = Parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'Reports_DB_Show'      
    
 IF @Mode = 'F'      
 BEGIN      
  IF(@PageNo = 0)      
   SET @PageNo = 1      
        
  SET @SqlQuery = '      
    WITH Y AS (      
     Select *  From       
     (      
      select Row_Num = ROW_NUMBER() OVER (ORDER BY Avail_Report_Schedule_Code desc),* from (      
       select * From ' + @ReportDB + '..Avail_Report_Schedule      
      )as XYZ Where 1 = 1 '+ @StrCriteria + '      
      )as X      
    )      
		INSERT INTO #Temp(RowNum, Avail_Report_Schedule_Code, Title_Code, Platform_Code, Country_Code, Is_Original_Language, Dubbing_Subtitling, GroupBy, Node, 
		Language_Code, Date_Type, StartDate,  EndDate, User_Code,  Inserted_On, Report_Status, Report_File_Name,  ShowRemark, Email_Status,  Visibility , ReportName, RestrictionRemarks,         
		OthersRemark, Platform_ExactMatch, MustHave_Platform, Exclusivity, SubLicense_Code, Region_ExactMatch, Region_MustHave, Region_Exclusion, Subtit_Language_Code  
		,Dubbing_Language_Code,BU_Code ,Report_Type,Digital ,IncludeMetadata,Is_IFTA_Cluster,Platform_Group_Code ,Subtitling_Group_Code ,Subtitling_ExactMatch,
		Subtitling_MustHave, Subtitling_Exclusion, Dubbing_Group_Code, Dubbing_ExactMatch, Dubbing_MustHave, Dubbing_Exclusion,Territory_Code, Indiacast, Region_On, 
		Include_Ancillary, Promoter_Code, MustHave_Promoter, Promoter_ExactMatch, Module_Code, Episode_From, Episode_To) 
		SELECT
		Row_Num, Avail_Report_Schedule_code, Title_Code, Platform_Code, Country_Code, Is_Original_Language, Dubbing_Subtitling, GroupBy, Node, Language_Code, Date_Type, StartDate, EndDate, User_Code
		, Inserted_On, Report_Status, Report_File_Name, ShowRemark, Email_Status, Visibility, ReportName, RestrictionRemarks, OthersRemark, Platform_ExactMatch, MustHave_Platform, Exclusivity, SubLicense_Code
		, Region_ExactMatch, Region_MustHave, Region_Exclusion, Subtit_Language_Code, Dubbing_Language_Code, BU_Code, Report_Type, Digital, IncludeMetadata, Is_IFTA_Cluster, Platform_Group_Code
		, Subtitling_Group_Code, Subtitling_ExactMatch, Subtitling_MustHave, Subtitling_Exclusion, Dubbing_Group_Code, Dubbing_ExactMatch, Dubbing_MustHave, Dubbing_Exclusion, Territory_Code
		, IndiaCast, Region_On, Include_Ancillary, Promoter_Code, MustHave_Promoter, Promoter_ExactMatch, Module_Code, Episode_From, Episode_To
      FROM Y'
  print @SqlQuery        
  EXEC(@SqlQuery)        
  DEclare @RecCount INT 
	DECLARE @ModuleCode INT
		SELECT @ModuleCode =  [Module_Code] FROM @Avail_Report_Schedule_Data
	SELECT @RecCount = COUNT(*) FROM #Temp where Module_Code = @ModuleCode
	UPDATE #Temp set Recordcount = @RecCount

        
  IF @IsPaging = 'Y'      
  BEGIN       
   DELETE FROM #Temp WHERE RowNum < (((@PageNo - 1) * @PageSize) + 1) OR RowNum > @PageNo * @PageSize       
  END       
        
  SET @SqlQuery = '      
      SELECT Cast(0 AS INT) AS RowNum,       
   Avail_Report_Schedule_Code, Title_Code, Platform_Code, Country_Code, CASE Is_Original_Language WHEN ''1'' THEN ''Yes'' ELSE ''No''  END Is_Original_Language,       
      Dubbing_Subtitling, CASE GroupBy WHEN ''C'' THEN ''Country''  WHEN ''L'' THEN ''Language'' ELSE '''' END GroupBy,       
      CASE Node  WHEN ''P'' THEN ''Parent''  WHEN ''C'' THEN ''Child''  ELSE '''' END Node,       
      Language_Code,  CASE Date_Type  WHEN ''FL'' THEN ''Flexi''  WHEN ''FI'' THEN ''Fixed'' ELSE ''MI'' END Date_Type,       
      CONVERT(VARCHAR, CAST(StartDate AS DATE), 105) StartDate,       
      CASE       
       WHEN EndDate = ''9999-12-31'' OR EndDate = ''31-Dec-9999'' OR EndDate='''' OR EndDate=null THEN ''''      
       ELSE CONVERT(VARCHAR, CAST(EndDate AS DATE), 105)      
      END EndDate,       
      User_Code, Inserted_On,       
      CASE        
       --WHEN Report_Status = ''D'' AND Email_Status = ''N'' THEN ''Sending Mail''       
       WHEN Report_Status = ''P'' THEN ''Pending''       
       WHEN Report_Status = ''W'' OR (Report_Status = ''D'' AND Email_Status = ''N'') THEN ''Work in progress''      
       WHEN Report_Status = ''X'' THEN ''Deleted''       
       WHEN Report_Status = ''D'' AND Email_Status = ''Y'' THEN ''Done''      
       WHEN Report_Status = ''C'' THEN ''Completed''      
       ELSE '''' END Report_Status,       
      Report_File_Name, ShowRemark,      
      ISNULL((      
       SELECT Distinct STUFF(      
          (SELECT '', '' + CAST(Title_Name AS NVARCHAR(250)) [text()]      
        FROM Title       
        WHERE Title_Code IN (select number from fn_Split_withdelemiter(ISNULL(tbl.Title_Code,''''), '',''))      
        ORDER BY Title_Name       
        FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '') List_Output      
       FROM Title T      
       GROUP BY Title_Name       
      ), '''') AS Title_Names,   
      ISNULL((      
       SELECT Distinct STUFF(      
          (SELECT '', '' + CAST(Platform_Hiearachy AS NVARCHAR(100)) [text()]          
         From dbo.UFN_Get_Platform_With_Parent (tbl.Platform_Code)      
        FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,2,'' '') List_Output      
       FROM Platform P      
       GROUP BY Platform_Hiearachy      
      ), '''') AS Platform_Names,      
      (select dbo.UFN_GetRegionNames(Country_Code)) Country_Names,      
      (select dbo.UFN_GetLanguageNames(Language_Code)) Language_Names,      
      CASE WHEN Dubbing_Subtitling LIKE ''%D%'' THEN ''Yes'' ELSE ''No'' END Is_Dubbing,      
      CASE WHEN Dubbing_Subtitling LIKE ''%S%'' THEN ''Yes'' ELSE ''No'' END Is_Subtitling,      
      CASE WHEN Email_Status LIKE ''Y'' THEN ''Yes'' ELSE ''No'' END Email_Status      
      ,ISNULL(Visibility, '''') AS [Visibility], ISNULL(ReportName, '''') AS [ReportName]      
      , RestrictionRemarks, OthersRemark, Platform_ExactMatch, MustHave_Platform, Exclusivity, SubLicense_Code, Region_ExactMatch      
      , Region_MustHave ,Region_Exclusion ,Subtit_Language_Code ,Dubbing_Language_Code ,Cast(BU_Code AS VARCHAR(10)) AS BU_Code ,Report_Type,      
      First_NAme+ '' '' + Last_Name  UserName,
	  Episode_From,Episode_To,
	 CASE Digital WHEN ''1'' THEN ''true'' ELSE ''false''  END Digital ,IncludeMetadata, Is_IFTA_Cluster, Platform_Group_Code, Subtitling_Group_Code  
	 , Subtitling_ExactMatch, Subtitling_MustHave, Subtitling_Exclusion, Dubbing_Group_Code, Dubbing_ExactMatch, Dubbing_MustHave, Dubbing_Exclusion,Territory_Code, Include_Ancillary ,Indiacast   ,Region_On  
	 ,Promoter_Code, Promoter_ExactMatch, MustHave_Promoter, Module_Code, '+CAST(@RecCount as varchar(10))+' As Recordcount, Episode_From, Episode_To
    
   FROM ' + @ReportDB + '..Avail_Report_Schedule as tbl      
      INNER JOIN Users u ON u.Users_Code = tbl.User_Code      
      WHERE 1=1 AND Avail_Report_Schedule_Code IN (SELECT Avail_Report_Schedule_Code FROM #Temp)      
      ORDER BY Avail_Report_Schedule_Code DESC '      
      --
  EXEC(@SqlQuery)      
  Print @SqlQuery      
 END      
       ELSE IF @Mode <> 'D'    
	BEGIN    
	SELECT * INTO #tempVariable FROM @Avail_Report_Schedule_Data

	EXEC ('INSERT INTO  ' + @ReportDB +' ..Avail_Report_Schedule(
		Title_Code, Country_code, Platform_Code, Is_Original_Language, Dubbing_Subtitling, Language_Code, Date_Type,  StartDate, EndDate, User_Code, Inserted_ON, Report_Status,
		Visibility, ReportName, RestrictionRemarks,OthersRemark, Platform_ExactMatch, MustHave_Platform, Exclusivity, SubLicense_Code, Region_ExactMatch, Region_MustHave, Region_Exclusion,
		Subtit_Language_Code, Dubbing_Language_Code, BU_Code, Report_Type, Digital, IncludeMetadata,   Is_IFTA_Cluster, Platform_Group_Code, Subtitling_Group_Code  
		,Subtitling_ExactMatch, Subtitling_MustHave, Subtitling_Exclusion, Dubbing_Group_Code, Dubbing_ExactMatch, Dubbing_MustHave, Dubbing_Exclusion, Territory_Code, Indiacast, Region_On, Include_Ancillary, Promoter_Code, MustHave_Promoter,  Promoter_ExactMatch, Module_Code 
		,Episode_From, Episode_To)
		select		
		[Title_Code], [Country_Code], [Platform_Code], [Is_Original_Language], [Dubbing_Subtitling], [Language_Code], [Date_Type],[StartDate],	
		[EndDate], [UserCode], [Inserted_On], [Report_Status], [Visibility], [ReportName], [RestrictionRemark], [OtherRemark], 
		[Platform_ExactMatch], [MustHave_Platform], [Exclusivity], [SubLicenseCode], [Region_ExactMatch], [Region_MustHave], [Region_Exclusion], [Subtit_Language_Code],
		[Dubbing_Language_Code], [BU_Code], [Report_Type], [Digital], [IncludeMetadata], [Is_IFTA_Cluster], [Platform_Group_Code], [Subtitling_Group_Code],
		[Subtitling_ExactMatch], [Subtitling_MustHave], [Subtitling_Exclusion], [Dubbing_Group_Code], [Dubbing_ExactMatch], [Dubbing_MustHave], [Dubbing_Exclusion], [Territory_Code],	
		[IndiaCast], [Region_On], [Include_Ancillary], [Promoter_Code], [MustHave_Promoter], [Promoter_ExactMatch],[Module_Code], [Episode_From], [Episode_To]
		FROM #tempVariable' )

		drop table #tempVariable
			 
		SELECT     
			0 AS RowNum, Avail_Report_Schedule_Code, Title_Code, Platform_Code, Country_Code,CAST('' AS VARCHAR(5)) Is_Original_Language,     
			Dubbing_Subtitling, CAST('' AS VARCHAR(20)) GroupBy, CAST('' AS VARCHAR(10)) Node, Language_Code, CAST('' AS VARCHAR(10)) Date_Type,     
			StartDate, EndDate, User_Code, Inserted_On, CAST('' AS VARCHAR(20)) Report_Status, Report_File_Name, ShowRemark,CAST('' AS VARCHAR(MAX)) Title_Names,    
			CAST('' AS VARCHAR(MAX)) Platform_Names,CAST('' AS VARCHAR(MAX)) Country_Names,CAST('' AS VARCHAR(MAX)) Language_Names,    
			CAST('' AS VARCHAR(5)) Is_Dubbing, CAST('' AS VARCHAR(5)) Is_Subtitling, CAST('' AS VARCHAR(5)) Email_Status    
			, ISNULL(Visibility, '') Visibility, ISNULL(ReportName, '') ReportName, RestrictionRemarks, OthersRemark, Platform_ExactMatch, MustHave_Platform, Exclusivity, SubLicense_Code, Region_ExactMatch    
			, Region_MustHave ,Region_Exclusion ,Subtit_Language_Code ,Dubbing_Language_Code ,Cast(BU_Code AS VARCHAR(10)) AS BU_Code,Report_Type,    
			CAST('' AS VARCHAR(200)) UserName  ,CAST('' AS VARCHAR(5))  Digital,CAST('' AS VARCHAR(5))  IncludeMetadata, Visibility, Is_IFTA_Cluster, Platform_Group_Code, Subtitling_Group_Code  
			, Subtitling_ExactMatch, Subtitling_MustHave, Subtitling_Exclusion, Dubbing_Group_Code, Dubbing_ExactMatch, Dubbing_MustHave, Dubbing_Exclusion, Territory_Code, Include_Ancillary, Promoter_Code,  Promoter_ExactMatch, MustHave_Promoter, Indiacast , Region_On, Recordcount
			,Episode_From, Episode_To FROM #Temp where 1=2  
		END    
     
	ELSE IF @Mode = 'D'    
	BEGIN   
		SET @SqlQuery = 'UPDATE ' + @ReportDB + '..Avail_Report_Schedule SET Report_Status = ''X'' WHERE Avail_Report_Schedule_Code = ' + @StrCriteria    
		EXEC(@SqlQuery)    
    
		print @SqlQuery    
		SELECT     
			0 AS RowNum, Avail_Report_Schedule_Code, Title_Code, Platform_Code, Country_Code,CAST('' AS VARCHAR(5)) Is_Original_Language,     
			Dubbing_Subtitling, CAST('' AS VARCHAR(20)) GroupBy, CAST('' AS VARCHAR(10)) Node, Language_Code, CAST('' AS VARCHAR(10)) Date_Type,     
			StartDate, EndDate, User_Code, Inserted_On, CAST('' AS VARCHAR(20)) Report_Status, Report_File_Name, ShowRemark,CAST('' AS VARCHAR(MAX)) Title_Names,    
			CAST('' AS VARCHAR(MAX)) Platform_Names,CAST('' AS VARCHAR(MAX)) Country_Names,CAST('' AS VARCHAR(MAX)) Language_Names,    
			CAST('' AS VARCHAR(5)) Is_Dubbing, CAST('' AS VARCHAR(5)) Is_Subtitling, CAST('' AS VARCHAR(5)) Email_Status    
			, ISNULL(Visibility, '') Visibility, ISNULL(ReportName, '') ReportName, RestrictionRemarks, OthersRemark, Platform_ExactMatch, MustHave_Platform, Exclusivity, SubLicense_Code, Region_ExactMatch    
			, Region_MustHave ,Region_Exclusion ,Subtit_Language_Code ,Dubbing_Language_Code ,Cast(BU_Code AS VARCHAR(10)) AS BU_Code ,Report_Type,    
			CAST('' AS VARCHAR(200)) UserName  ,CAST('' AS VARCHAR(5))  Digital,CAST('' AS VARCHAR(5))  IncludeMetadata,Is_IFTA_Cluster, Platform_Group_Code, Subtitling_Group_Code  
			, Subtitling_ExactMatch, Subtitling_MustHave, Subtitling_Exclusion, Dubbing_Group_Code, Dubbing_ExactMatch, Dubbing_MustHave, Dubbing_Exclusion, Territory_Code, Include_Ancillary, Promoter_Code,  Promoter_ExactMatch, MustHave_Promoter, Indiacast , Region_On, Recordcount
		, Episode_From, Episode_To FROM #Temp where 1=2    
	END    

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#tempVariable') IS NOT NULL DROP TABLE #tempVariable
END