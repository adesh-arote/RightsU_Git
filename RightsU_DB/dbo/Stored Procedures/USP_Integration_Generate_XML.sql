alter PROCEDURE [dbo].[USP_Integration_Generate_XML]              
(            
 @Module_Name VARCHAR(100),               
 @Deal_Type_Code INT,              
 @BU_Code INT, --In FPC as Channel Category Code              
 @Title_Lang_Code INT,              
 @Channel_Codes VARCHAR(200),              
 @Foreign_System_Name VARCHAR(100)          
)              
AS              
-- =============================================              
-- Author:  <Sagar Mahajan>              
-- Create date: <20 Apr 2016>              
-- Description: <Call From RightsU Plus Web Api and Generate XML>              
-- =============================================         
--DECLARE             
-- @Module_Name VARCHAR(100)='Acq_Deal_Run',               
-- @Deal_Type_Code INT=1,              
-- @BU_Code INT=2, --In FPC as Channel Category Code              
-- @Title_Lang_Code INT=14,              
-- @Channel_Codes VARCHAR(200)='24,25',              
-- @Foreign_System_Name VARCHAR(100) ='FPC'              
--DECLARE @Module_Name VARCHAR(100) ='Acq_Deal_Run',               
-- @Deal_Type_Code INT = 1,              
-- @BU_Code INT = 2,               
-- @Title_Lang_Code INT = 14 ,              
-- @Channel_Codes VARCHAR(200) = '24',              
-- @Foreign_System_Name VARCHAR(100)='FPC'             
              
BEGIN               
 SET NOCOUNT ON;              
 DECLARE @Error_Desc VARCHAR(5000) = '',@Is_Error CHAR(1) = 'N' ,@Record_Status VARCHAR(5) = 'W'          
 DECLARE @Integration_Config_Code INT,@xmlData NVARCHAR(MAX)              
 /********************************Change Record  Status****************/              
 --IF(UPPER(@Module_Name)='LICENSOR')          
 --BEGIN          
 --SET @Record_Status = 'W,D'          
 --UPDATE Integration_Deal SET Record_Status = 'W' WHERE Record_Status = 'P'          
 --END          
 --ELSE IF(UPPER(@Module_Name)='TALENT' OR UPPER(@Module_Name)='Right_Rule' OR UPPER(@Module_Name)='TITLE' OR UPPER(@Module_Name)='TITLE_TALENT')          
 --BEGIN          
 --SET @Record_Status = 'W,D'          
 --END             
 /********************************End****************/              
          
 /********************************Check Module Name****************/              
 BEGIN TRY                
 IF EXISTS(SELECT TOP 1 IC.Module_Code FROM Integration_Config IC WHERE IC.IS_Active = 'Y' AND (IC.Module_Name = @Module_Name) AND IC.Foreign_System_Name=@Foreign_System_Name)              
 BEGIN                  
  SELECT TOP 1 @Integration_Config_Code = ISNULL(ID.Integration_Config_Code,0)                
  FROM Integration_Data ID WHERE ID.Integration_Config_Code IN(              
   SELECT TOP 1 Integration_Config_Code FROM Integration_Config IC              
   WHERE 1 =1  AND UPPER(IC.Module_Name) = UPPER(@Module_Name) AND IC.Foreign_System_Name='FPC'           
  )                
  --SELECT @Integration_Config_Code AS Integration_Config_Code              
   IF(UPPER(@Module_Name) = 'INTEGRATION_RUNS')        
   BEGIN        
 GOTO INTEGRATION_RUNS;        
   END        
  /********************************DELETE Temp Table if Exists ****************/              
 IF OBJECT_ID('tempdb..#Temp_Deal_Data') IS NOT NULL              
 BEGIN              
 DROP TABLE #Temp_Deal_Data              
 END              
 IF OBJECT_ID('tempdb..#Temp_Deal_Rights_data') IS NOT NULL              
 BEGIN              
 DROP TABLE #Temp_Deal_Rights_data              
 END              
 IF OBJECT_ID('tempdb..#Temp_Min_Max_Rights_Date') IS NOT NULL              
 BEGIN              
 DROP TABLE #Temp_Min_Max_Rights_Date              
 END              
 IF OBJECT_ID('tempdb..#TempTalent') IS NOT NULL              
 BEGIN              
 DROP TABLE #TempTalent          
 END              
  /***************************************************Insert Record*********************************************************************/                
   CREATE TABLE #Temp_Deal_Data              
   (              
    Acq_Deal_Code INT,                  
    Deal_Type_Code INT,          
    Title_Code INT,              
    Acq_Deal_Rights_Code INT,              
    Rights_Start_Date DATETIME,              
    Rights_End_Date DATETIME,      
    HB_Start_Date DATETIME,              
    HB_End_Date DATETIME,              
    Acq_Deal_Run_Code INT,              
    Right_Rule_Code INT,              
    Channel_Code INT,      
 Licensor_Code INT,      
 Deal_Desc NVARCHAR(500),      
 Integration_Acq_Run_Code INT,      
 Integration_Title_Code INT      
   )              
   CREATE TABLE #Temp_Min_Max_Rights_Date              
   (               
    Acq_Deal_Code INT,                  
    Title_Code INT,              
    Rights_Start_Date DATETIME,              
    Rights_End_Date DATETIME              
   )       
   INSERT INTO #Temp_Deal_Data(Acq_Deal_Code,Deal_Type_Code,Title_Code,Acq_Deal_Rights_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Run_Code,Right_Rule_Code,      
   Channel_Code, Deal_Desc,Licensor_Code,Integration_Acq_Run_Code,Integration_Title_Code)              
   SELECT DISTINCT  AD.Acq_Deal_Code,AD.Deal_Type_Code,ADRT.Title_Code,              
   ADRTitle.Acq_Deal_Rights_Code,ADRight.Actual_Right_Start_Date,ADRight.Actual_Right_End_Date,              
   ADR.Acq_Deal_Run_Code,ISNULL(ADR.Right_Rule_Code,0),ADRC.Channel_Code, ad.Deal_Desc,AD.Vendor_Code,      
   IAR.Integration_Acq_Run_Code,IT.Integration_Title_Code      
   FROM Acq_Deal AD               
   INNER JOIN Acq_Deal_Rights ADRight ON AD.Acq_Deal_Code = ADRight.Acq_Deal_Code               
   AND ISNULL(ADRight.Actual_Right_Start_Date,'') <> ''              
   --AND ISNULL(ADRight.Actual_Right_End_Date,'31DEC9999') > GETDATE()              
   INNER JOIN Acq_Deal_Rights_Title ADRTitle ON  ADRight.Acq_Deal_Rights_Code =ADRTitle.Acq_Deal_Rights_Code              
   INNER JOIN Acq_Deal_Run ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code              
   INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code= ADRT.Acq_Deal_Run_Code AND ADRTitle.Title_Code = ADRT.Title_Code              
   INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRT.Acq_Deal_Run_Code= ADRC.Acq_Deal_Run_Code AND ADRC.Channel_Code IN              
    (               
     SELECT number FROM fn_Split_withdelemiter(@Channel_Codes,',')              
    )              
   INNER JOIN Title T ON T.Title_Code= ADRT.Title_Code       
   AND T.Title_Language_Code = @Title_Lang_Code AND T.Deal_Type_Code = @Deal_Type_Code      
   INNER JOIN Integration_Acq_Run IAR ON IAR.Acq_Deal_Run_Code=ADR.Acq_Deal_Run_Code      
   INNER JOIN Integration_Title IT ON IT.Title_Code=T.Title_Code         
   WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Business_Unit_Code = @BU_Code AND AD.Deal_Type_Code = @Deal_Type_Code                   
            
   --AND AD.Acq_Deal_Code IN              
   --(              
   --SELECT ID.Acq_Deal_Code               
   --FROM Integration_Deal ID                    
   --WHERE ID.Record_Status IN(SELECT number FROM fn_Split_withdelemiter(@Record_Status,','))          
   --)      
   DECLARE @CountryCodes varchar(500) = ''        
   SELECT TOP 1 @CountryCodes = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'RU_FPC_Country_Codes' AND IsActive = 'Y'        
   --select * from #Temp_Deal_Data      
   DELETE FROM #Temp_Deal_Data WHERE Acq_Deal_Rights_Code NOT IN        
   (        
    SELECT DISTINCT TDD.Acq_Deal_Rights_Code            
    FROM #Temp_Deal_Data TDD        
    INNER JOIN Acq_Deal_Rights_Territory ADRT ON TDD.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code        
    AND         
    (        
     ADRT.Country_Code IN        
     (        
     SELECT number FROM fn_Split_withdelemiter(@CountryCodes,',')              
     )        
     OR        
     ADRT.Territory_Code IN        
     (        
    SELECT DISTINCT TD.Territory_Code  FROM Territory_Details TD         
    WHERE TD.Country_Code IN(SELECT number FROM fn_Split_withdelemiter(@CountryCodes,','))        
     )        
  )                    
   )      
   --select * from #Temp_Deal_Data        
      
  /*************************************************** 1 Start Role*********************************************************************/              
  IF(UPPER(@Module_Name) = 'ROLE')              
  BEGIN                      
   SELECT @xmlData =               
   (              
    SELECT              
    (              
     SELECT DISTINCT          
     ISNULL([dbo].[UFN_Get_Integration_Key] ('ROLE',R.Role_Code,'FPC'),0) AS Role_Code,R.Role_Code AS Foreign_Code,              
     R.Role_Name,'Y' AS Is_Active              
     FROM [Role] R              
     WHERE 1 = 1               
     AND R.Deal_Type_Code =@Deal_Type_Code              
     AND R.Role_Type IN('T')              
     AND               
     (              
  R.Last_Updated_Time >=       
  (      
   SELECT TOP 1 Processing_Date      
   FROM       
   (      
    SELECT TOP 1 ID.Processing_Date AS Processing_Date FROM Integration_Data ID               
    WHERE ID.Integration_Config_Code = @Integration_Config_Code AND ID.RU_Record_Code = R.Role_Code ORDER BY Processing_Date DESC      
    UNION      
    SELECT CAST('01Jan1900' AS DATETIME) AS Processing_Date         
   ) AS A      
   ORDER BY Processing_Date DESC      
   )      
       OR               
      ISNULL(@Integration_Config_Code,0) = 0              
     )              
     FOR XML PATH('Role'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Roles')               
   )              
  END              
  /*************************************************** 2 Talent*********************************************************************/              
  IF(UPPER(@Module_Name) = 'TALENT')              
  BEGIN                          
   SELECT @xmlData =               
   (              
    SELECT              
    (              
     SELECT DISTINCT              
     ISNULL([dbo].[UFN_Get_Integration_Key] ('TALENT',T.Talent_Code,'FPC'),0) AS Talent_Code,              
     T.Talent_Code AS Foreign_Code,           
     ISNULL(Talent_Name,'') AS Talent_Name,              
     ISNULL(T.Gender,'') AS Gender,                   
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Role',              
     (              
      SELECT STUFF((SELECT DISTINCT  ',' + CAST(ISNULL(TR.Role_Code,0) AS VARCHAR(MAX))               
      FROM Talent_Role TR              
      WHERE T.Talent_Code = TR.Talent_Code              
      AND TR.Role_Code IN(1,2)              
      FOR XML PATH('')), 1, 1, '')               
     ),'FPC'),'0') AS Talent_Roles,              
     T.Is_Active              
     FROM Talent T                  
     INNER JOIN Title_Talent TT ON ISNULL(TT.Talent_Code,0)= T.Talent_Code                
     INNER JOIN Talent_Role TR ON TR.Talent_Code= T.Talent_Code   AND TR.Role_Code IN(1,2)       
     WHERE 1 = 1                   
     AND T.Is_Active = 'Y'              
     AND TT.Title_Code IN(              
      SELECT DISTINCT TDD.Title_Code FROM #Temp_Deal_Data TDD              
     )                  
     AND               
     (              
    ISNULL(T.Last_UpDated_Time,ISNULL(T.Inserted_On,GETDATE())) >=       
    (      
   SELECT TOP 1 Processing_Date      
   FROM       
   (      
    SELECT TOP 1 ID.Processing_Date AS Processing_Date FROM Integration_Data ID               
    WHERE ID.Integration_Config_Code = @Integration_Config_Code AND ID.RU_Record_Code = T.Talent_Code ORDER BY Processing_Date DESC      
    UNION      
    SELECT CAST('01Jan1900' AS DATETIME) AS Processing_Date         
   ) AS A      
   ORDER BY Processing_Date DESC      
   )      
    OR               
    ISNULL(@Integration_Config_Code,0) = 0              
     )      
     FOR XML PATH('Talent'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Talents')               
   )              
  END              
  /***************************************************3 Right_Rule*********************************************************************/              
  IF(UPPER(@Module_Name) = 'RIGHT_RULE')              
  BEGIN                  
   SELECT @xmlData =               
   (              
    SELECT              
    (              
     SELECT DISTINCT              
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Right_Rule',RR.Right_Rule_Code,'FPC'),0) AS Right_Rule_Code,              
     RR.Right_Rule_Code AS Foreign_Code,              
     RR.Right_Rule_Name,              
     ISNULL(RR.Start_Time,'0') AS Start_Time,              
     ISNULL(Play_Per_Day,0) AS Play_Per_Day,              
     ISNULL(Duration_Of_Day,0) AS Duration_Of_Day,              
     ISNULL(No_Of_Repeat,0) AS No_Of_Repeat,              
     ISNULL(Is_First_Air,'0') AS Is_First_Air,              
     ISNULL(Short_Key,'0') AS Short_Key,              
     RR.Is_Active                   
     FROM Right_Rule RR              
     WHERE RR.Is_Active = 'Y'              
     AND RR.Right_Rule_Code IN(              
      SELECT DISTINCT TDD.Right_Rule_Code FROM #Temp_Deal_Data TDD              
     )              
  AND             
     (              
       ISNULL(RR.Last_UpDated_Time,ISNULL(RR.Inserted_On,GETDATE())) >=       
    (      
   SELECT TOP 1 Processing_Date      
   FROM       
   (      
    SELECT TOP 1 ID.Processing_Date AS Processing_Date FROM Integration_Data ID               
    WHERE ID.Integration_Config_Code = @Integration_Config_Code AND ID.RU_Record_Code = RR.Right_Rule_Code ORDER BY Processing_Date DESC      
    UNION      
    SELECT CAST('01Jan1900' AS DATETIME) AS Processing_Date         
   ) AS A      
   ORDER BY Processing_Date DESC      
    )      
    OR               
  ISNULL(@Integration_Config_Code,0) = 0              
     )                   
     FOR XML PATH('RIGHT_RULE'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Right_Rules')               
   )              
  END              
  /***************************************************4 Genre*********************************************************************/              
  IF(UPPER(@Module_Name) = 'GENRE')              
  BEGIN                   
   SELECT @xmlData =               
   (              
  SELECT              
  (              
   SELECT DISTINCT              
   ISNULL([dbo].[UFN_Get_Integration_Key] ('GENRE',G.Genres_Code,'FPC'),0) AS Genres_Code,              
   G.Genres_Code AS Foreign_Code,              
   G.Genres_Name,              
   G.Is_Active                  
   FROM Genres G              
   WHERE G.Is_Active = 'Y'              
   AND G.Genres_Code IN          
   (              
    SELECT DISTINCT TG.Genres_Code              
    FROM #Temp_Deal_Data TDD              
    INNER JOIN Title_Geners TG ON TG.Title_Code = TDD.Title_Code              
   )              
   AND               
   (              
    ISNULL(G.Last_UpDated_Time,ISNULL(G.Inserted_On,GETDATE())) >=       
 (      
   SELECT TOP 1 Processing_Date      
   FROM       
   (      
    SELECT TOP 1 ID.Processing_Date AS Processing_Date FROM Integration_Data ID               
    WHERE ID.Integration_Config_Code = @Integration_Config_Code AND ID.RU_Record_Code = G.Genres_Code ORDER BY Processing_Date DESC      
    UNION      
    SELECT CAST('01Jan1900' AS DATETIME) AS Processing_Date         
   ) AS A      
   ORDER BY Processing_Date DESC      
 )      
    OR               
    ISNULL(@Integration_Config_Code,0) = 0              
   )              
   FOR XML PATH('Genre'),TYPE              
   )              
 FOR XML PATH(''),              
 ROOT('Genres')               
  )              
  END              
  /***************************************************5 Title*********************************************************************/              
  IF(UPPER(@Module_Name) = 'TITLE')              
  BEGIN            
 IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL              
 BEGIN              
  DROP TABLE #Temp_Title              
 END           
 --select * from #Temp_Deal_Data            
 SELECT DISTINCT T.Title_Code      
 ,T.Original_Title      
 ,T.Title_Name      
 --,T.Synopsis      
 --,T.Original_Language_Code      
 ,T.Title_Language_Code      
 ,T.Year_Of_Production      
 --,T.Duration_In_Min      
 ,T.Deal_Type_Code      
 --,T.Is_Active      
 ,T.Last_UpDated_Time       
 INTO #Temp_Title          
 FROM Title T              
 INNER JOIN #Temp_Deal_Data temp ON T.Title_Code= temp.Title_Code         
 INNER JOIN Integration_Title IT ON T.Title_Code=IT.Title_Code                 
 WHERE 1 = 1              
 AND               
 (              
  ISNULL(T.Last_UpDated_Time,ISNULL(T.Inserted_On,GETDATE())) >=       
  (      
   SELECT TOP 1 Processing_Date      
   FROM       
   (      
    SELECT TOP 1 ID.Processing_Date AS Processing_Date FROM Integration_Data ID               
    WHERE ID.Integration_Config_Code = @Integration_Config_Code AND ID.RU_Record_Code = T.Title_Code ORDER BY Processing_Date DESC      
    UNION      
    SELECT CAST('01Jan1900' AS DATETIME) AS Processing_Date         
   ) AS A      
   ORDER BY Processing_Date DESC      
  )      
  OR               
  ISNULL(@Integration_Config_Code,0) = 0              
 )          
 AND IT.Record_Status='P'      
          
 --DELETE FROM  ID           
 --FROM Integration_Data ID            
 --INNER JOIN Title_Talent TT ON TT.Title_Talent_Code = ID.RU_Record_Code          
 --INNER JOIN #Temp_Title temp ON TT.Title_Code = temp.Title_Code          
 --WHERE ID.Integration_Config_Code IN              
 --(              
 -- SELECT TOP 1 IC.Integration_Config_Code              
 -- FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'TITLE_TALENT'              
 --)             
             
   SELECT @xmlData =               
   (              
    SELECT              
    (              
     SELECT DISTINCT       
  ISNULL([dbo].[UFN_Get_Integration_Key] ('TITLE',T.Title_Code,'FPC'),0) AS Title_Code       
  ,T.Title_Code AS Foreign_Code       
  ,T.Title_Name AS Title_Name      
  --,IsNull(T.Synopsis, ' ') AS Synopsis      
  --,ISNULL([dbo].[UFN_Get_Integration_Key] ('Original_Language',T.Original_Language_Code,'FPC'),0) AS Original_Language_Code      
  ,[dbo].[UFN_Get_Integration_Key] ('Title_Language',T.Title_Language_Code,'FPC') AS Title_Language_Code      
  ,ISNULL(T.Year_Of_Production, 0) AS Year_Of_Production      
  --,ISNULL(T.Duration_In_Min,0) AS Duration_In_Min      
  ,ISNULL([dbo].[UFN_Get_Integration_Key] ('Deal_Type',T.Deal_Type_Code,'FPC'),1) AS Deal_Type_Code      
  --,ISNULL([dbo].[UFN_Get_Integration_Key] ('Genre',              
  -- (              
  --  SELECT STUFF((SELECT DISTINCT  ',' + CAST(ISNULL(TG.Genres_Code,0) AS VARCHAR(MAX))               
  --  FROM Title_Geners TG              
  --  WHERE TG.Title_Code = T.Title_Code              
  --  FOR XML PATH('')), 1, 1, '')               
  -- ),'FPC'),'0')              
  --AS Genre_Codes      
  --,ISNULL(              
  -- (              
  --  SELECT ISNULL(MEC.Column_Value,'')  FROM Map_Extended_Columns MEC WHERE MEC.Columns_Code IN(              
  --   SELECT TOP 1 EC.Columns_Code FROM Extended_Columns EC WHERE EC.Columns_Name = 'Banner'              
  -- AND MEC.Table_Name = 'TITLE' AND MEC.Record_Code = T.Title_Code)              
  -- ),' ')AS Banner_Name      
  --,ISNULL((              
  --  [dbo].[UFN_Get_Integration_Key] ('CBFC_Rating',              
  --  (              
  --   SELECT MEC.Columns_Value_Code FROM Map_Extended_Columns MEC WHERE Columns_Value_Code IN              
  --   (              
  --  SELECT Columns_Value_Code FROM Extended_Columns_Value  WHERE Columns_Code IN(              
  --    SELECT Columns_Code FROM Extended_Columns WHERE Columns_Name like 'CBFC Rating'              
  --   )                    
  --   )              
  --   AND MEC.Table_Name = 'TITLE' AND MEC.Record_Code = T.Title_Code              
  --  ),'FPC')              
              
  -- ),' ') AS CBFC_Rating       
   ,ISNULL((            
    SELECT Case When MEC.Columns_Value_Code = 3 Then 'O' When MEC.Columns_Value_Code = 4 Then 'D' Else '' End             
    FROM Map_Extended_Columns MEC WHERE Columns_Value_Code IN     
    (              
   SELECT Columns_Value_Code FROM Extended_Columns_Value  WHERE Columns_Code IN(              
    SELECT Columns_Code FROM Extended_Columns WHERE Columns_Name like 'Type of Film')          
    )              
    AND MEC.Table_Name = 'TITLE' AND MEC.Record_Code = T.Title_Code            
    ), '') AS  Original_Dub      
   --,T.Is_Active AS Is_Active      
   --,ISNULL([dbo].[UFN_Get_Integration_Key] ('BU_Code_English',@BU_Code,'FPC'),0) AS BU_Code                   
     FROM #Temp_Title T                   
     FOR XML PATH('Title')      
  ,TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Titles')               
   )            
  IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL              
  BEGIN              
   DROP TABLE #Temp_Title              
  END         
  UPDATE Integration_Title SET Record_Status='W' WHERE Record_Status='P'      
END                 
              
  /***************************************************6 Talent_Role*********************************************************************/              
  IF(UPPER(@Module_Name) = 'TITLE_TALENT')      
  BEGIN                    
   --SELECT Title_Talent_Code INTO #TempTalent From Title_Talent WHERE Title_Talent_Code NOT IN(              
   -- SELECT ID.RU_Record_Code              
   -- FROM Integration_Data ID              
   -- WHERE ID.Integration_Config_Code = ISNULL(@Integration_Config_Code,0)              
   --) AND Role_Code IN(1,2)           
               
    DECLARE @RequestTime DATETIME , @ResponseTime DATETIME,@Title_Int_Config_Code INT = 0       
       
 SELECT TOP 1 @RequestTime = IL.Request_DateTime ,@ResponseTime = IL.Response_DateTime,@Title_Int_Config_Code = IL.Intergration_Config_Code       
 FROM Integration_Log IL WHERE IL.Intergration_Config_Code IN      
 (      
  SELECT IC.Integration_Config_Code      
  FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'TITLE' AND IC.Foreign_System_Name=@Foreign_System_Name      
 ) AND  IL.Response_DateTime  IS NOT NULL ORDER BY IL.Request_DateTime DESC      
      
 SELECT ID.RU_Record_Code AS Title_Code INTO #Temp_Title_Code       
 FROM  #Temp_Deal_Data TDD      
 INNER JOIN Title T ON T.Title_Code = TDD.Title_Code      
 INNER JOIN Integration_Data ID ON ID.RU_Record_Code = T.Title_Code AND ID.Integration_Config_Code = ISNULL(@Title_Int_Config_Code,0)       
 AND ID.Processing_Date BETWEEN  @RequestTime AND @ResponseTime      
 AND ISNULL(ID.Foreign_System_Code,0) > 0      
      
      
   SELECT @xmlData =               
   (              
    SELECT              
    (                      
  SELECT DISTINCT 0 AS Title_Talent_Code,           
  TT.Title_Talent_Code As Foreign_Code,               
  IDT.Foreign_System_Code AS Title_Code, IDTL.Foreign_System_Code AS Talent_Code,               
  IDR.Foreign_System_Code AS Role_Code              
  FROM Title_Talent TT                   
  INNER JOIN  #Temp_Title_Code TDD  ON TDD.Title_Code  = TT.Title_Code              
  INNER JOIN Integration_Data IDT On IDT.RU_Record_Code = TT.Title_Code AND IDT.Integration_Config_Code = (              
   SELECT TOP 1 IC.Integration_Config_Code              
   FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'TITLE' AND IC.Foreign_System_Name=@Foreign_System_Name)              
  INNER JOIN Integration_Data IDTL On IDTL.RU_Record_Code = TT.Talent_Code AND IDTL.Integration_Config_Code = (              
   SELECT TOP 1 IC.Integration_Config_Code              
   FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'TALENT' AND IC.Foreign_System_Name=@Foreign_System_Name)              
  INNER JOIN Integration_Data IDR On IDR.RU_Record_Code = TT.Role_Code AND IDR.Integration_Config_Code = (              
   SELECT TOP 1 IC.Integration_Config_Code              
   FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'ROLE' AND IC.Foreign_System_Name=@Foreign_System_Name)               
  --INNER JOIN #TempTalent ttl On ttl.Title_Talent_Code = TT.Title_Talent_Code          
 INNER JOIN Integration_Title IT ON IT.Title_Code=TT.Title_Code          
  WHERE 1 = 1 AND TT.Role_Code IN(1,2) AND IT.Record_Status='P'      
  FOR XML PATH('Title_Talent'),TYPE              
 )              
  FOR XML PATH(''),              
  ROOT('Title_Talents')               
   )              
              
   --DROP TABLE #TempTalent              
   DROP TABLE #Temp_Deal_Data      
  END              
  /***************************************************7 Deal*********************************************************************/                 
      
  IF(UPPER(@Module_Name) = 'ACQ_DEAL_RUN')              
  BEGIN         
        
                  
    UPDATE TDRD SET TDRD.Rights_Start_Date = ADRH.Holdback_Release_Date              
    FROM Acq_Deal_Rights_Holdback ADRH              
    INNER JOIN #Temp_Deal_Data TDRD ON ADRH.Acq_Deal_Rights_Code = TDRD.Acq_Deal_Rights_Code              
    INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRP ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRP.Acq_Deal_Rights_Holdback_Code              
    AND ADRP.Platform_Code IN(SELECT P.Platform_Code FROM [Platform] P   WHERE P.Applicable_For_Asrun_Schedule = 'Y')              
    WHERE  1 = 1              
    AND ISNULL(ADRH.Holdback_Type,'') = 'D'  AND ISNULL(ADRH.Holdback_Release_Date,'') <> ''              
              
    INSERT INTO #Temp_Min_Max_Rights_Date(Acq_Deal_Code,Title_Code,Rights_Start_Date,Rights_End_Date)              
    SELECT DISTINCT TDRD.Acq_Deal_Code,TDRD.Title_Code,MIN(TDRD.Rights_Start_Date),MAX(TDRD.Rights_End_Date)              
    FROM #Temp_Deal_Data TDRD              
    GROUP BY TDRD.Acq_Deal_Code,TDRD.Title_Code        
          
    /*****************************************/              
   SELECT @xmlData =               
   (              
    SELECT              
    (              
     SELECT DISTINCT              
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Acq_Deal_Run',TDD.Acq_Deal_Run_Code,'FPC'),0) AS Acq_Deal_Run_Code,              
     ADR.Acq_Deal_Run_Code AS Foreign_Code,                   
     ISNULL([dbo].[UFN_Get_Integration_Key] ('TITLE',TDD.Title_Code,'FPC'),0) AS Title_Code,              
     ISNULL(ADR.Run_Type,'N') Run_Type,              
     ISNULL(ADR.No_Of_Runs,0) No_Of_Runs,              
     --ISNULL(ADR.No_Of_Runs_Sched,0) No_Of_Runs_Sched,              
     --ISNULL(ADR.No_Of_AsRuns,0) No_Of_AsRuns,              
     ISNULL(ADR.Is_Yearwise_Definition,'N') Is_Yearwise_Definition,              
     ISNULL(ADR.Is_Rule_Right,'N') AS Is_Rule_Right,              
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Right_Rule',ADR.Right_Rule_Code,'FPC'),0) AS Right_Rule_Code,                   
     ISNULL(ADR.Repeat_Within_Days_Hrs,' ') AS Repeat_Within_Days_Hrs,              
     ISNULL(ADR.No_Of_Days_Hrs,0) AS No_Of_Days_Hrs,              
     ISNULL(ADR.Is_Channel_Definition_Rights,'N') AS Is_Channel_Definition_Rights,              
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Channel',ADR.Primary_Channel_Code,'FPC'),0) AS Primary_Channel_Code,              
     ISNULL(ADR.Run_Definition_Type,'N') Run_Definition_Type,              
     ISNULL(ADR.Prime_Start_Time,'00:00:00') Prime_Start_Time,               
     ISNULL(ADR.Prime_End_Time,'00:00:00') Prime_End_Time,              
     ISNULL(ADR.Off_Prime_Start_Time,'01Jan1900') Off_Prime_Start_Time,              
     ISNULL(ADR.Off_Prime_End_Time,'01Jan1900') Off_Prime_End_Time,              
     ISNULL(ADR.Time_Lag_Simulcast,'00:00:00') Time_Lag_Simulcast,              
     ISNULL(ADR.Prime_Run,0) Prime_Run,              
     ISNULL(ADR.Off_Prime_Run,0) Off_Prime_Run,              
     ISNULL(ADR.Prime_Time_Provisional_Run_Count,0) AS Prime_Time_Provisional_Run_Count,              
     --ISNULL(ADR.Prime_Time_AsRun_Count,0) AS Prime_Time_AsRun_Count,              
     --ISNULL(ADR.Prime_Time_Balance_Count,0) AS Prime_Time_Balance_Count,              
     ISNULL(ADR.Off_Prime_Time_Provisional_Run_Count,0) AS Off_Prime_Time_Provisional_Run_Count,       
     --ISNULL(ADR.Off_Prime_Time_AsRun_Count,0) AS Off_Prime_Time_AsRun_Count,              
     --ISNULL(ADR.Off_Prime_Time_Balance_Count,0) AS Off_Prime_Time_Balance_Count,                   
     ISNULL((              
      SELECT STUFF((SELECT DISTINCT ', '+  CAST(ADRRD.Day_Code AS VARCHAR)              
      FROM Acq_Deal_Run_Repeat_On_Day ADRRD              
      WHERE ADRRD.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code                    
      AND ADRRD.Day_Code is NOT NULL              
      FOR XML PATH('')), 1, 1, '')              
     ),'NA') AS Repeat_On_Day,              
     CAST(ISNULL((              
      SELECT DISTINCT TOP 1 Temp.Rights_Start_Date                 
      FROM #Temp_Min_Max_Rights_Date Temp                           
      WHERE Temp.Acq_Deal_Code =ADR.Acq_Deal_Code              
      AND Temp.Title_Code = ADRT.Title_Code              
     ),'01Jan1900') AS DATETIME) AS Rights_Start_Date,              
     CAST(ISNULL((                   
      SELECT DISTINCT TOP 1 Temp.Rights_End_Date              
      FROM #Temp_Min_Max_Rights_Date Temp                           
      WHERE Temp.Acq_Deal_Code =ADR.Acq_Deal_Code              
      AND  Temp.Title_Code = ADRT.Title_Code              
     ),'31DEC9999') AS DATETIME) AS Rights_End_Date,          
   ADR.Acq_Deal_Code AS Acq_Deal_Code,      
  ISNULL(TDD.Deal_Desc,'NA') AS Deal_Description,      
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Licensor',TDD.Licensor_Code,'FPC'),0) AS Licensor_Code      
  ,(Case When ADM.Title_Type='P' THEN 'P' ELSE 'L' END) AS Title_Type      
  ,ISNULL(IAR.Is_Archive,'N') AS Is_Archive      
     FROM Acq_Deal_Run ADR              
     INNER JOIN #Temp_Deal_Data TDD ON ADR.Acq_Deal_Code = TDD.Acq_Deal_Code       
     INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code AND TDD.Title_Code = ADRT.Title_Code              
     AND TDD.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code              
     AND TDD.Title_Code IN              
     (              
      SELECT ID.RU_Record_Code              
      FROM Integration_Data ID              
      WHERE ID.Integration_Config_Code IN              
      (              
       SELECT TOP 1 IC.Integration_Config_Code              
       FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'TITLE'  AND IC.Foreign_System_Name=@Foreign_System_Name          
      )              
     )      
  INNER JOIN Acq_Deal_Movie ADM ON ADM.Title_Code=ADRT.Title_Code       
  AND ADM.Acq_Deal_Code=ADR.Acq_Deal_Code       
  AND ADM.Episode_Starts_From=ADRT.Episode_From       
  AND ADM.Episode_End_To=ADRT.Episode_To      
  INNER JOIN Integration_Acq_Run IAR ON TDD.Integration_Acq_Run_Code = IAR.Integration_Acq_Run_Code       
        
    -- --AND TDD.Acq_Deal_Run_Code NOT IN--Need To Comment              
    -- --(              
    -- -- SELECT ID.RU_Record_Code              
    -- -- FROM Integration_Data ID              
    -- -- WHERE ID.Integration_Config_Code IN              
    ---- (              
    -- --  SELECT TOP 1 IC.Integration_Config_Code              
    -- --  FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'ACQ_DEAL_RUN'              
    -- -- )              
    -- --)              
     WHERE 1 = 1 AND IAR.Record_Status='P'      
     FOR XML PATH('Acq_Deal_Run'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Acq_Deal_Runs')               
   )          
   --SELECT 'sagar' ,* FROM  #Temp_Deal_Data          
   --SELECT @xmlData AS @xmlData         
   UPDATE Integration_Acq_Run SET Record_Status='W' WHERE Record_Status='P'         
   Print @xmlData        
  END              
              
  /***************************************************8 ACQ DEAL RUN CHANNEL*********************************************************************/                
          
  IF(UPPER(@Module_Name) = 'ACQ_DEAL_RUN_CHANNEL')              
  BEGIN                      
   SELECT @xmlData =               
   (              
  SELECT              
    (              
     SELECT DISTINCT              
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Acq_Deal_Run_Channel',ADRC.Acq_Deal_Run_Channel_Code,'FPC'),0) AS Acq_Deal_Run_Channel_Code,              
  --0 AS Acq_Deal_Run_Channel_Code,          
     ADRC.Acq_Deal_Run_Channel_Code AS Foreign_Code,              
     [dbo].[UFN_Get_Integration_Key] ('Acq_Deal_Run',ADRC.Acq_Deal_Run_Code,'FPC') AS Acq_Deal_Run_Code,              
     [dbo].[UFN_Get_Integration_Key] ('Channel',ADRC.Channel_Code,'FPC') AS Channel_Code,              
     ISNULL(ADRC.Min_Runs,0) AS Min_Runs,              
     ISNULL(ADRC.Max_Runs,0) AS Max_Runs             
     --ISNULL(ADRC.No_Of_Runs_Sched,0) AS No_Of_Runs_Sched,              
     --ISNULL(ADRC.No_Of_AsRuns,0) AS No_Of_AsRuns      
 , ISNULL(IRC.Is_Archive,'N') AS Is_Archive              
     FROM Acq_Deal_Run_Channel ADRC              
     INNER JOIN #Temp_Deal_Data TDD ON ADRC.Acq_Deal_Run_Code =TDD.Acq_Deal_Run_Code               
    AND ADRC.Channel_Code = TDD.Channel_Code                   
     AND TDD.Acq_Deal_Run_Code  IN              
     (              
      SELECT ID.RU_Record_Code              
      FROM Integration_Data ID              
      WHERE ID.Integration_Config_Code IN              
      (              
       SELECT TOP 1 IC.Integration_Config_Code              
       FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'ACQ_DEAL_RUN'   AND IC.Foreign_System_Name=@Foreign_System_Name          
      )              
     )       
   --INNER JOIN Integration_Acq_Run IAR ON ADRC.Acq_Deal_Run_Code = IAR.Acq_Deal_Run_Code      
   INNER JOIN Integration_Acq_Run_Channel IRC ON IRC.Channel_Code=ADRC.Channel_Code       
   AND TDD.Integration_Acq_Run_Code=IRC.Integration_Acq_Run_Code      
   AND IRC.Record_Status='P'      
       ----Comment Below line              
     --AND ADRC.Acq_Deal_Run_Channel_Code NOT IN              
     --(              
     -- SELECT ISNULL(ID.RU_Record_Code,0)              
     -- FROM Integration_Data ID              
     -- WHERE ID.Integration_Config_Code = ISNULL(@Integration_Config_Code,0)                    
     --)              
     --WHERE 1 = 1 AND TDD.Acq_Deal_Code IN              
     --(                   
     -- SELECT ID.Acq_Deal_Code               
     -- FROM Integration_Deal ID               
     -- WHERE ID.Process_End >= (SELECT TOP 1 Processing_Date FROM Integration_Data               
     --   WHERE Integration_Config_Code = @Integration_Config_Code ORDER BY Processing_Date DESC)                          
     --)                   
     FOR XML PATH('Acq_Deal_Run_Channel'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Acq_Deal_Run_Channel')               
   )        
         
   UPDATE Integration_Acq_Run_Channel SET Record_Status='W' WHERE Record_Status='P'        
  END              
 /***************************************************9 Acq_Deal_Run_Yearwise_Run*********************************************************************/               
  IF(UPPER(@Module_Name) = 'ACQ_DEAL_RUN_YEARWISE_RUN')              
  BEGIN                      
   SELECT @xmlData =               
   (              
  SELECT              
  (          
    SELECT DISTINCT              
    --ISNULL([dbo].[UFN_Get_Integration_Key] ('Acq_Deal_Run_Yearwise_Run',ADRYR.Acq_Deal_Run_Yearwise_Run_Code,'FPC'),0) AS Acq_Deal_Run_Yearwise_Run_Code,              
    0 AS Acq_Deal_Run_Yearwise_Run_Code,          
    ADRYR.Acq_Deal_Run_Yearwise_Run_Code AS Foreign_Code,              
    [dbo].[UFN_Get_Integration_Key] ('Acq_Deal_Run',ADRYR.Acq_Deal_Run_Code,'FPC') AS Acq_Deal_Run_Code,              
    ADRYR.[Start_Date] AS Start_Date,              
    ADRYR.End_Date AS End_Date,              
    ISNULL(ADRYR.No_Of_Runs,0) AS No_Of_Runs               
    --ISNULL(ADRYR.No_Of_Runs_Sched,0) AS No_Of_Runs_Sched,               
    --ISNULL(ADRYR.No_Of_AsRuns,0) AS No_Of_AsRuns        
 ,ISNULL(IRY.Is_Archive,'N') AS Is_Archive              
    FROM Acq_Deal_Run_Yearwise_Run ADRYR                    
    INNER JOIN #Temp_Deal_Data TDD ON ADRYR.Acq_Deal_Run_Code =TDD.Acq_Deal_Run_Code       
 --INNER JOIN Integration_Acq_Run IAR ON ADRYR.Acq_Deal_Run_Code = IAR.Acq_Deal_Run_Code      
 INNER JOIN Integration_Acq_Run_Yearwise IRY ON IRY.[Start_Date]=ADRYR.[Start_Date] AND IRY.End_Date=ADRYR.End_Date       
 AND TDD.Integration_Acq_Run_Code=IRY.Integration_Acq_Run_Code      
 AND IRY.Record_Status='P'                
    WHERE 1 = 1              
    AND TDD.Acq_Deal_Run_Code  IN              
    (              
     SELECT ID.RU_Record_Code              
     FROM Integration_Data ID              
     WHERE ID.Integration_Config_Code IN              
     (              
      SELECT TOP 1 IC.Integration_Config_Code              
      FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'ACQ_DEAL_RUN'  AND IC.Foreign_System_Name=@Foreign_System_Name                
     )              
    )              
    AND ISNULL(ADRYR.[Start_Date],'') <> '' AND ISNULL(ADRYR.End_Date,'') <> ''                    
    FOR XML PATH('Acq_Deal_Run_YearWise_Run'),TYPE              
  )              
    FOR XML PATH(''),              
    ROOT('Acq_Deal_Run_YearWise_Runs')               
   )            
   UPDATE Integration_Acq_Run_Yearwise SET Record_Status='W' WHERE Record_Status='P'          
  END       
        
  --/***************************************************10 Content_Channel_Run*********************************************************************/      
  --IF(UPPER(@Module_Name) = 'Content_Channel_Run')              
  --BEGIN         
        
                   
  --  --UPDATE TDRD SET TDRD.Rights_Start_Date = ADRH.Holdback_Release_Date              
  --  --FROM Acq_Deal_Rights_Holdback ADRH              
  --  --INNER JOIN #Temp_Deal_Data TDRD ON ADRH.Acq_Deal_Rights_Code = TDRD.Acq_Deal_Rights_Code              
  --  --INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRP ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRP.Acq_Deal_Rights_Holdback_Code              
  --  --AND ADRP.Platform_Code IN(SELECT P.Platform_Code FROM [Platform] P   WHERE P.Applicable_For_Asrun_Schedule = 'Y')              
  --  --WHERE  1 = 1              
  --  --AND ISNULL(ADRH.Holdback_Type,'') = 'D'  AND ISNULL(ADRH.Holdback_Release_Date,'') <> ''              
              
  --  --INSERT INTO #Temp_Min_Max_Rights_Date(Acq_Deal_Code,Title_Code,Rights_Start_Date,Rights_End_Date)              
  --  --SELECT DISTINCT TDRD.Acq_Deal_Code,TDRD.Title_Code,MIN(TDRD.Rights_Start_Date),MAX(TDRD.Rights_End_Date)              
  --  --FROM #Temp_Deal_Data TDRD              
  --  --GROUP BY TDRD.Acq_Deal_Code,TDRD.Title_Code              
                  
  --  /*****************************************/              
  -- SELECT @xmlData =               
  -- (              
  --  SELECT              
  --  (              
  --   SELECT DISTINCT      
  --Content_Channel_Run_Code      
  --   ,Acq_Deal_Code      
  --   ,Acq_Deal_Run_Code      
  --   ,Title_Content_Code      
  --   ,Title_Code      
  --   ,Channel_Code      
  --   ,Run_Type      
  --   ,Rights_Start_Date      
  --   ,Rights_End_Date      
  --   ,Right_Rule_Code      
  --   ,Defined_Runs      
  --   ,Schedule_Runs      
  --   ,Schedule_Utilized_Runs      
  --   ,AsRun_Runs      
  --   ,AsRun_Utilized_Runs      
  --   ,Prime_Start_Time      
  --   ,Prime_End_Time      
  --   ,OffPrime_Start_Time      
  --   ,OffPrime_End_Time      
  --   ,Prime_Runs      
  --   ,Prime_Schedule_Runs      
  --   ,Prime_Schedule_Utilized_Runs      
  --   ,Prime_AsRun_Runs      
  --   ,Prime_AsRun_Utilized_Runs      
  --   ,OffPrime_Runs      
  --   ,OffPrime_Schedule_Runs      
  --   ,OffPrime_Schedule_Utilized_Runs      
  --   ,OffPrime_AsRun_Runs      
  --   ,OffPrime_AsRun_Utilized_Runs      
  --FROM Content_Channel_Run      
  --   WHERE 1 = 1 AND Record_Status='P'               
  --   FOR XML PATH('Content_Channel_Run'),TYPE              
  --  )              
  --  FOR XML PATH(''),              
  --  ROOT('Content_Channel_Runs')               
  -- )         
  --END            
          
IF(UPPER(@Module_Name) = 'LICENSOR')              
  BEGIN                   
   SELECT @xmlData =               
   (              
    SELECT              
    (              
     SELECT DISTINCT              
     ISNULL([dbo].[UFN_Get_Integration_Key] ('Licensor',V.Vendor_Code,'FPC'),0) AS Licensor_Code              
     ,V.Vendor_Code AS Foreign_Code              
     ,V.Vendor_Name AS Licensor_Name           
     ,V.Is_Active                   
     FROM Vendor V              
     WHERE V.Is_Active = 'Y'              
     AND V.Vendor_Code IN(              
      SELECT DISTINCT TDD.Licensor_Code FROM #Temp_Deal_Data TDD              
     )              
  AND               
     (              
       ISNULL(V.Last_UpDated_Time,ISNULL(V.Inserted_On,GETDATE())) >=       
    (      
   SELECT TOP 1 Processing_Date      
   FROM       
   (      
    SELECT TOP 1 ID.Processing_Date AS Processing_Date FROM Integration_Data ID               
    WHERE ID.Integration_Config_Code = @Integration_Config_Code AND ID.RU_Record_Code = V.Vendor_Code ORDER BY Processing_Date DESC      
    UNION      
    SELECT CAST('01Jan1900' AS DATETIME) AS Processing_Date         
   ) AS A      
   ORDER BY Processing_Date DESC      
    )      
    OR               
  ISNULL(@Integration_Config_Code,0) = 0              
     )                   
     FOR XML PATH('LICENSOR'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('LICENSOR')               
   )              
  END                     
      
      
      
      
            
/***************************************************11 ACQ DEAL RUN CHANNEL*********************************************************************/              
 /*          
  IF(UPPER(@Module_Name) = 'ACQ_DEAL_RUN_BLACKOUTS')              
  BEGIN                
   PRINT @Module_Name                    
   SELECT @xmlData =               
   (              
    SELECT              
    (              
     SELECT DISTINCT              
     [dbo].[UFN_Get_Integration_Key] ('ACQ_DEAL_RUN_BLACKOUT',ADRYR.Acq_Deal_Run_Code,'FPC') AS Acq_Deal_Run_Blackout_Code,              
     ADRYR.Acq_Deal_Run_Yearwise_Run_Code AS Foreign_Code,              
     [dbo].[UFN_Get_Integration_Key] ('Acq_Deal_Run',ADRYR.Acq_Deal_Run_Code,'FPC') AS Acq_Deal_Run_Code,              
     ADRYR.[Start_Date] AS Start_Date,              
     ADRYR.End_Date AS End_Date,              
     ISNULL(ADRYR.No_Of_Runs,0) AS No_Of_Runs,               
     ISNULL(ADRYR.No_Of_Runs_Sched,0) AS No_Of_Runs_Sched              
     FROM Acq_Deal_Run_Yearwise_Run ADRYR                    
     INNER JOIN #Temp_Deal_Data TDD ON ADRYR.Acq_Deal_Run_Code =TDD.Acq_Deal_Run_Code               
     WHERE 1 = 1                        
     AND TDD.Acq_Deal_Run_Code  IN              
     (              
      SELECT ID.RU_Record_Code              
      FROM Integration_Data ID              
      WHERE ID.Integration_Config_Code IN              
      (              
       SELECT TOP 1 IC.Integration_Config_Code              
       FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'ACQ_DEAL_RUN'              
      )              
     )              
     --AND ADRYR.Acq_Deal_Run_Yearwise_Run_Code NOT IN              
     --(              
     -- SELECT ISNULL(ID.RU_Record_Code,0)              
     -- FROM Integration_Data ID              
     -- WHERE ID.Integration_Config_Code = ISNULL(@Integration_Config_Code,0)                    
     --)                    
     AND ISNULL(ADRYR.[Start_Date],'') <> '' AND ISNULL(ADRYR.End_Date,'') <> ''                    
     FOR XML PATH('Acq_Deal_Run_Blackout'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Acq_Deal_Run_Blackouts')               
   )              
  END              
  */          
 /***************************************************11 ACQ DEAL RUN Blackout*********************************************************************/               
        
/***************************************************12 Integration Runs********************************************************************/               
  ;INTEGRATION_RUNS:        
  IF(UPPER(@Module_Name) = 'INTEGRATION_RUNS')              
  BEGIN                       
 PRINT 'Integration_Runs'        
   SELECT @xmlData =               
   (              
    SELECT              
    (              
   SELECT DISTINCT         
    0 AS Integration_Runs_Code ,             
    IR.Integration_Runs_Code AS  Foreign_Code,        
    [dbo].[UFN_Get_Integration_Key] ('Acq_Deal_Run',IR.Acq_Deal_Run_Code,'FPC') AS Acq_Deal_Run_Code,              
    [dbo].[UFN_Get_Integration_Key] ('Title',IR.Title_Code,'FPC') AS Title_Code,              
    ISNULL([dbo].[UFN_Get_Integration_Key] ('Channel',IR.Channel_Code,'FPC'),'0') AS Channel_Code,              
    ISNULL(IR.[Start_Date],'01Jan1900') AS Start_Date,              
    ISNULL(IR.End_Date,'01Jan1900') AS End_Date,                   
    ISNULL(IR.Schedule_Run,0) AS Schedule_Run ,        
    ISNULL(IR.Prime_Runs_Sched,0) AS Prime_Runs_Sched,        
    ISNULL(IR.Off_Prime_Runs_Sched,0) AS Off_Prime_Runs_Sched                        
   FROM Integration_Runs IR        
   WHERE 1 = 1         
   AND IR.IsRead = 'N'        
   AND IR.Acq_Deal_Run_Code IN        
   (        
   SELECT  ID.RU_Record_Code FROM Integration_Data ID WHERE ID.RU_Record_Code = IR.Acq_Deal_Run_Code         
   AND ID.Integration_Config_Code IN              
   (              
    SELECT TOP 1 IC.Integration_Config_Code              
    FROM Integration_Config IC WHERE UPPER(IC.Module_Name) = 'ACQ_DEAL_RUN'  AND IC.Foreign_System_Name=@Foreign_System_Name             
   )             
   )        
   FOR XML PATH('Integration_Run'),TYPE              
    )              
    FOR XML PATH(''),              
    ROOT('Integration_Runs')               
   )              
  END          
 END              
 /***************************************************Drop Tables *******************************/              
  IF OBJECT_ID('tempdb..#Temp_Deal_Data') IS NOT NULL              
   BEGIN              
    DROP TABLE #Temp_Deal_Data              
   END                 
   IF OBJECT_ID('tempdb..#Temp_Min_Max_Rights_Date') IS NOT NULL              
   BEGIN              
    DROP TABLE #Temp_Min_Max_Rights_Date              
   END                 
   /*****************/      
 --  IF(UPPER(@Module_Name)='ACQ_DEAL_RUN_YEARWISE_RUN')          
 --  BEGIN           
 -- UPDATE Integration_Deal SET Record_Status = 'D' WHERE Record_Status = 'W'          
 --END          
 /***************************************************Result******************************/                 
SET @xmlData = '<?xml version="1.0" ?>' + ISNULL(@xmlData,'')  + ''               
              
END TRY              
BEGIN CATCH                  
 SET @Is_Error   = 'Y'               
 SET @Error_Desc = 'Error In USP_Integration_Generate_XML : Error_Desc : ' +  ERROR_MESSAGE() + ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)              
 SET @Error_Desc =  @Error_Desc + ';ErrorLine : '+ CAST(ERROR_LINE() AS VARCHAR) + ' ;'               
 SET @Error_Desc =  @Error_Desc + ' ;USP Input Parameters : ' +';@Module_Name : ' +@Module_Name + ';Deal_Type_Code : ' + CAST(@Deal_Type_Code AS VARCHAR)              
      + ' ;Channel_Code : ' +@Channel_Codes + ' ;BU_Code : ' + CAST(@BU_Code AS varchar) + ' ;Title_Lang_Code : ' + CAST(@Title_Lang_Code AS VARCHAR)              
      + ' ;Foreign_System_Name : ' + @Foreign_System_Name + ' ; '              
              
END CATCH              
/********************************Log File Code ****************/              
 IF(ISNULL(@Integration_Config_Code,0) = 0)              
  SELECT @Integration_Config_Code = Integration_Config_Code FROM Integration_Config WHERE UPPER(Module_Name) = @Module_Name  AND Foreign_System_Name=@Foreign_System_Name            
              
 INSERT INTO Integration_Log(Intergration_Config_Code,Request_XML,Request_Type,Request_DateTime,Response_DateTime,Response_XML,[Error_Message],              
   [Record_Status] ,[Deal_Type_Code],[BU_Code],[Title_Lang_Code],[Channel_Code]                    
 )              
       
 SELECT ISNULL(@Integration_Config_Code,0),@xmlData,'G',GETDATE(),NULL,NULL,@Error_Desc,'W',@Deal_Type_Code,@BU_Code,@Title_Lang_Code,@Channel_Codes              
 DECLARE @CurrIdent_Integration_Log INT = 0               
 SELECT @CurrIdent_Integration_Log = IDENT_CURRENT('Integration_Log')              
              
/********************************Result****************/              
SELECT @xmlData AS XML_Data, @Error_Desc AS Error_Desc,@Is_Error AS IS_Error,@CurrIdent_Integration_Log AS Integration_Log_Code,@Integration_Config_Code AS Integration_Config_Code              
END          

/*        
SELECT ISNULL([dbo].[UFN_Get_Integration_Key] ('Role',0,'FPC'),0)        
--UPDATE Integration_Deal SET Record_Status = 'D' WHERE Record_Status = 'P'    
/*        
UPDATE Integration_Data SET Processing_Date = GETDATE()        
UPDATE Talent SET Last_Updated_Time = GETDATE()         
UPDATE Role SET Last_Updated_Time = GETDATE()         
UPDATE Right_Rule SET Last_Updated_Time = GETDATE()         
UPDATE Genres SET Last_Updated_Time = GETDATE()         
UPDATE Title SET Last_Updated_Time = GETDATE()             
Step 2         
EXEC [dbo].[USP_Integration_Generate_XML] 'Title','1',2,14,24,'FPC' ---Title        
EXEC [dbo].[USP_Integration_Generate_XML] 'Role','1',1,2,14,'FPC' ---Role        
EXEC [dbo].[USP_Integration_Generate_XML] 'Right_Rule','1',1,2,14,'FPC' - ---TITLE_TALENT        
EXEC [dbo].[USP_Integration_Generate_XML] 'Talent','1',2,14,24,'FPC' ---Talent        
EXEC [dbo].[USP_Integration_Generate_XML] 'Genre','1',1,1,1,'FPC' ---Genre        
EXEC [dbo].[USP_Integration_Generate_XML] 'TITLE_TALENT','1',1,1,1,'FPC' ---TITLE_TALENT        
EXEC [dbo].[USP_Integration_Generate_XML] 'Acq_Deal_Run','1',2,14,24,'FPC'  ---Acq_Deal_Run        
EXEC [dbo].[USP_Integration_Generate_XML] 'ACQ_DEAL_RUN_CHANNEL','1',2,14,24,'FPC'   ---ACQ_DEAL_RUN_CHANNEL        
EXEC [dbo].[USP_Integration_Generate_XML] 'Acq_Deal_Run_Yearwise_Run','1',2,14,24,'FPC'   ---Acq_Deal_Run_Yearwise_Run        
EXEC [dbo].[USP_Integration_Generate_XML] 'INTEGRATION_RUNS','1',2,14,24,'FPC'   ---INTEGRATION_RUNS      
        
--SELECT * FROM Integration_Config       
        
Step 3        
        
--INSERT INTO Integration_Config(Module_Code,Module_Name,Foreign_System_Name,IS_Active)        
--SELECT 0, 'BU_Code_English','FPC','Y'         
        
--INSERT INTO Integration_Data(Integration_Config_Code,RU_Record_Code,Foreign_System_Code,Creation_Date)        
--SELECT 23 AS Integration_Config_Code, 2,1067,GETDATE()            
*/        
*/