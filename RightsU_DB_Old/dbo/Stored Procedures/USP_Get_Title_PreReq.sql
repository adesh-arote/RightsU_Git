alter PROCEDURE [dbo].[USP_Get_Title_PreReq]  
--DECLARE  
 @Data_For VARCHAR(MAX) ,  
 @Deal_Type_Code INT,  
 @Business_Unit_Code INT ,  
 @Search_String NVARCHAR(MAX)   
  
AS  
BEGIN  
--DECLARE  
-- @Data_For VARCHAR(MAX) = 'TTO',  
-- @Deal_Type_Code INT = 0,  
-- @Business_Unit_Code INT = 0 ,  
-- @Search_String NVARCHAR(MAX) = 'frea'   
 SET NOCOUNT ON;  
 SET FMTONLY OFF;  
  
 IF(OBJECT_ID('TEMPDB..#PreReqData') IS NOT NULL)  
 DROP TABLE #PreReqData  
  
 CREATE TABLE #PreReqData  
 (  
  Display_Value INT,  
  Display_Text NVARCHAR(MAX),  
  Data_For VARCHAR(3)  
 )  
  
 DECLARE @Deal_Type_Code_Other INT = 17  
 SELECT TOP 1 @Deal_Type_Code_Other = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Other'  
  
 IF(CHARINDEX('DT', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT '0', 'Please Select', 'DT'  
  
  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT Deal_Type_Code, Deal_Type_Name, 'DT'  FROM DEAL_TYPE WHERE IS_ACTIVE = 'Y' AND Deal_Or_Title LIKE '%T%'  
  AND Deal_Type_Code <> @Deal_Type_Code_Other  
 END  
  
 IF(CHARINDEX('LA', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT '0', 'Please Select', 'LA'  
  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT Language_Code, Language_Name, 'LA'  FROM Language WHERE IS_ACTIVE = 'Y'   
 END  
  
 IF(CHARINDEX('C', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT Country_Code, Country_Name, 'C'  FROM Country WHERE IS_ACTIVE = 'Y' AND Is_Theatrical_Territory = 'N'  
 END  
  
 IF(CHARINDEX('G', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT Genres_Code, Genres_Name, 'G'  FROM Genres WHERE IS_ACTIVE = 'Y'   
 END  
  
 DECLARE @Role_code_Producer INT = 4  
 DECLARE @RoleCode_Director INT = 1  
 DECLARE @RoleCode_StarCast INT = 2  
  
 IF(CHARINDEX('P', @Data_For) > 0)  
 BEGIN  
    
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT T.Talent_Code, T.Talent_Name, 'P'  
  FROM Talent T   
  INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code  
  WHERE T.Is_Active = 'Y' AND tr.Role_Code = @Role_code_Producer  
 END  
  
 IF(CHARINDEX('DR', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT T.Talent_Code, T.Talent_Name, 'DR'  
  FROM Talent T   
  INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code  
  WHERE T.Is_Active = 'Y' AND tr.Role_Code = @RoleCode_Director  
  
 END  
  
 IF(CHARINDEX('S', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT T.Talent_Code, T.Talent_Name ,'S'  
  FROM Talent T   
  INNER JOIN Talent_Role TR ON TR.Talent_Code = T.Talent_Code  
  WHERE T.Is_Active = 'Y' AND tr.Role_Code = @RoleCode_StarCast  
 END  
  
 IF(CHARINDEX('RL', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT Role_Code, Role_Name, 'RL' FROM ROLE WHERE Role_Type = 'T'   
 END  
  
  IF( @Data_For ='TTA')  
 BEGIN  
  IF(@Business_Unit_Code > 0)  
  BEGIN  
   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
   SELECT t.Title_Code, Title_Name, 'TTA' FROM Title t  
   INNER JOIN Acq_Deal_Movie adm ON adm.Title_Code = t.Title_Code  
   INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adm.Acq_Deal_Code  
   WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND (t.Deal_Type_Code = @Deal_Type_Code OR @Deal_Type_Code =0)  AND t.Title_Name Like '%'+@Search_String+'%'  
   AND ad.Business_Unit_Code = @Business_Unit_Code   
   AND ISNULL(Reference_Flag,'')='' AND ISNULL(Reference_Key,'')=''  
  END  
  ELSE  
  BEGIN  
   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
   SELECT Title_Code, Title_Name, 'TTA' AS Data_For FROM Title  
   WHERE (Deal_Type_Code = 1 OR 0 =0) AND Title_Name Like '%'+@Search_String+'%' AND Is_Active = 'Y'  
   AND ISNULL(Reference_Flag,'')='' AND ISNULL(Reference_Key,'')=''  
  END  
 END  

 IF( @Data_For ='TTO')  
 BEGIN  
  IF(@Business_Unit_Code > 0)  
  BEGIN  
   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
   SELECT t.Title_Code, t.Original_Title, 'TTO' FROM Title t  
   INNER JOIN Acq_Deal_Movie adm ON adm.Title_Code = t.Title_Code  
   INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adm.Acq_Deal_Code  
   WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND (t.Deal_Type_Code = @Deal_Type_Code OR @Deal_Type_Code =0)  AND t.Original_Title Like '%'+@Search_String+'%'  
   AND ad.Business_Unit_Code = @Business_Unit_Code   AND t.Original_Title IS NOT NULL AND t.Original_Title <> ''
   AND ISNULL(Reference_Flag,'')='' AND ISNULL(Reference_Key,'')=''  
  END  
  ELSE  
  BEGIN  
   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
   SELECT Title_Code, Original_Title , 'TTO' AS Data_For FROM Title  
   WHERE (Deal_Type_Code = 1 OR 0 =0) AND Original_Title Like '%'+@Search_String+'%' AND Is_Active = 'Y'  
   AND ISNULL(Reference_Flag,'')='' AND ISNULL(Reference_Key,'')='' AND  Original_Title IS NOT NULL AND Original_Title <> ''
  END  
 END  

  
 ELSE IF(CHARINDEX('TT', @Data_For) > 0)  
 BEGIN  
  
  IF(@Business_Unit_Code > 0)  
  BEGIN  
   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
   SELECT t.Title_Code, Title_Name, 'TT' FROM Title t  
   INNER JOIN Acq_Deal_Movie adm ON adm.Title_Code = t.Title_Code  
   INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adm.Acq_Deal_Code  
   WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND (t.Deal_Type_Code = @Deal_Type_Code OR @Deal_Type_Code =0)  AND t.Title_Name Like '%'+@Search_String+'%'  
   AND ad.Business_Unit_Code = @Business_Unit_Code   
     
  END  
  ELSE  
  BEGIN  
   INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
   SELECT Title_Code, Title_Name, 'TT' FROM Title  
   WHERE (Deal_Type_Code = @Deal_Type_Code OR @Deal_Type_Code =0) AND Title_Name Like '%'+@Search_String+'%' AND Is_Active = 'Y'  
     
  END  
 END  

 IF(CHARINDEX('O', @Data_For) > 0)  
 BEGIN  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT '0', 'Please Select', 'O'  
  
  INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)  
  SELECT Program_Code, Program_Name, 'O'  FROM Program WHERE IS_ACTIVE = 'Y'   
 END  
  
 SELECT Display_Value, Display_Text, Data_For FROM #PreReqData ORDER BY Data_For, Display_Value, Display_Text  
END