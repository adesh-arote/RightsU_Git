
CREATE PROCEDURE [dbo].[USP_Attachment_Report]          
(          
  @Agreement_No varchar(50)='',          
  @Title_Codes Varchar(MAX)='',           
  @Document_Type_Code Varchar(MAX)='',    
  @Business_Unit_Code INT,    
  @Type CHAR(1),    
  @SysLanguageCode INT  
)          
AS          
BEGIN      
  
 DECLARE  
 --@Agreement_No varchar(50)='A-2018-00029',          
 --@Title_Codes Varchar(MAX)='',           
 --@Document_Type_Code Varchar(MAX)='',    
 --@Business_Unit_Code INT = 1,    
 --@Type CHAR(1) = 'A',  
 --@SysLanguageCode INT = 1,  
 @Col_Head01 NVARCHAR(MAX) = '',    
 @Col_Head02 NVARCHAR(MAX) = '',    
 @Col_Head03 NVARCHAR(MAX) = '',    
 @Col_Head04 NVARCHAR(MAX) = '',    
 @Col_Head05 NVARCHAR(MAX) = '',    
 @Col_Head06 NVARCHAR(MAX) = '',    
 @Col_Head07 NVARCHAR(MAX) = ''  
  
 IF OBJECT_ID('TEMPDB..#AcqAttachmentHeader') IS NOT NULL  
 DROP TABLE #AcqAttachmentHeader  
  
 IF OBJECT_ID('TEMPDB..#SynAttachmentHeader') IS NOT NULL  
 DROP TABLE #SynAttachmentHeader  
  
 SET @Agreement_No = ISNULL(@Agreement_No,' ')      
 SET @Title_Codes = ISNULL(@Title_Codes,' ')      
 SET @Document_Type_Code = ISNULL(@Document_Type_Code,' ')      
 SET @Business_Unit_Code = ISNULL(@Business_Unit_Code, 0)      
 SET @Type = ISNULL(@Type,' ')      
        
 IF(@Type = 'A')    
 BEGIN  
  SELECT DISTINCT     
  AD.Agreement_No    
  ,t.Title_Name    
  ,DT.Document_Type_Name    
  ,DTC.Deal_Type_Name      
  ,ADA.Attachment_File_Name        
  ,ADA.Attachment_Title    
  ,STUFF((  
   SELECT DISTINCT ',' +  CAST(v.Vendor_Name AS NVARCHAR(MAX))  FROM Vendor  v      
   INNER JOIN Acq_deal_Licensor ADL on ADA.Acq_Deal_Code = ADL.Acq_Deal_Code        
   WHERE ADL.Vendor_Code = V.Vendor_Code        
   FOR XML PATH(''),root('MyString'), type   
     ).value('/MyString[1]','nvarchar(max)')   
   , 1, 1, '') As [Vendor_Name]  
  
  INTO #AcqAttachmentHeader  
  FROM Acq_Deal AD        
  INNER JOIN Acq_Deal_Attachment ADA on AD.Acq_Deal_Code = ADA.Acq_Deal_Code        
  INNER JOIN Document_Type DT on ADA.Document_Type_Code = DT.Document_Type_Code          
  INNER JOIN Deal_Type DTC on AD.Deal_Type_Code = DTC.Deal_Type_Code     
  INNER JOIN Acq_Deal_Movie adm On adm.Acq_Deal_Code = ad.Acq_Deal_Code    
   AND (@Title_Codes = '' OR ISNULL(adm.Title_Code, 0) in (select number from fn_Split_withdelemiter(@Title_Codes,',')))  
  INNER JOIN Title t ON t.Title_Code = adm.Title_Code  AND   
  ((isnull(ada.Title_Code, 0) = 0) OR ((isnull(ada.Title_Code, 0) <> 0 AND adm.Title_Code = ada.Title_Code)))    
  WHERE  
  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
  AD.Agreement_No like '%' + @Agreement_No + '%'          
  AND (@Title_Codes = '' OR t.Title_Code in (SELECT number FROM fn_Split_withdelemiter(@Title_Codes,',')) OR ISNULL(ADA.Title_Code, 0) = 0)     
  AND (@Document_Type_Code = '' OR DT.Document_Type_Code in (SELECT number FROM fn_Split_withdelemiter(@Document_Type_Code,',')))       
  AND (AD.Business_Unit_Code = @Business_Unit_code OR @Business_Unit_code = 0)       
 END  
 ELSE IF(@Type = 'S')    
 BEGIN    
  SELECT DISTINCT     
  SD.Agreement_No    
  ,T.Title_Name    
  ,DT.Document_Type_Name    
  ,DTC.Deal_Type_Name      
  ,SDA.Attachment_File_Name        
  ,SDA.Attachment_Title    
  ,v.Vendor_Name    
  INTO #SynAttachmentHeader  
  FROM Syn_Deal SD    
  INNER JOIN Syn_Deal_Attachment SDA on SD.Syn_Deal_Code = SDA.Syn_Deal_Code    
  INNER JOIN Document_Type DT on SDA.Document_Type_Code = DT.Document_Type_Code     
  INNER JOIN Deal_Type DTC on SD.Deal_Type_Code = DTC.Deal_Type_Code          
  INNER JOIN Syn_Deal_Movie sdm On sdm.Syn_Deal_Code = sd.Syn_Deal_Code    
   AND (@Title_Codes = '' OR ISNULL(sdm.Title_Code, 0) in (select number from fn_Split_withdelemiter(@Title_Codes,',')))  
  INNER JOIN Title t on t.Title_Code = sdm.Title_Code  AND ((isnull(sda.Title_Code, 0) = 0) OR ((isnull(sda.Title_Code, 0) <> 0 AND sdm.Title_Code = sda.Title_Code)))    
  INNER JOIN Vendor v on SD.Vendor_Code = v.Vendor_Code          
  WHERE             
  SD.Agreement_No like '%' + @Agreement_No + '%'          
  AND (@Title_Codes = '' OR ISNULL(SDA.Title_Code, 0) in (select number from fn_Split_withdelemiter(@Title_Codes,',')) OR ISNULL(SDA.Title_Code, 0) = 0)     
  AND (@Document_Type_Code = '' OR DT.Document_Type_Code in (select number from fn_Split_withdelemiter(@Document_Type_Code,',')))       
  AND (SD.Business_Unit_Code = @Business_Unit_code OR @Business_Unit_code = 0)       
 END    
  
 SELECT   
  @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
     @Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,  
     @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,   
     @Col_Head04 = CASE WHEN  SM.Message_Key = 'PartyName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,  
     @Col_Head05 = CASE WHEN  SM.Message_Key = 'Description' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
     @Col_Head06 = CASE WHEN  SM.Message_Key = 'DocumentType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,  
     @Col_Head07 = CASE WHEN  SM.Message_Key = 'AttachmentName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END  
  
   FROM System_Message SM    
   INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code    
   AND SM.Message_Key IN ('AgreementNo','Title','TitleType','PartyName','Description','DocumentType','AttachmentName')    
   INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode    
  
   IF(@type = 'A')  
   BEGIN  
   IF EXISTS(SELECT TOP 1 * FROM #AcqAttachmentHeader)  
   BEGIN  
    SELECT [Agreement_No],[Title],[Title_Type],[Party_Name],[Description],[Document_Type],[Attachment_Name]  
    FROM (  
      
     SELECT  
     sorter = 1,  
     CAST(Agreement_No AS VARCHAR(100)) AS [Agreement_No],   
     CAST(Title_Name AS NVARCHAR(MAX)) AS [Title],   
     CAST(Deal_Type_Name AS NVARCHAR(MAX)) AS [Title_Type],  
     CAST(Vendor_Name AS NVARCHAR(MAX)) AS [Party_Name],   
     CAST(Attachment_Title AS NVARCHAR(MAX)) AS [Description],   
     CAST(Document_Type_Name AS NVARCHAR(MAX)) AS [Document_Type],   
     CAST(Attachment_File_Name AS NVARCHAR(MAX)) AS [Attachment_Name]  
     From #AcqAttachmentHeader  
     UNION ALL  
       SELECT 0,@Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07  
     ) X     
    ORDER BY Sorter  
   END  
   ELSE  
   BEGIN  
    SELECT * FROM #AcqAttachmentHeader  
   END  
   END  
  ELSE  
  BEGIN  
   IF EXISTS(SELECT TOP 1 * FROM #SynAttachmentHeader)  
   BEGIN  
    SELECT [Agreement_No],[Title],[Title_Type],[Party_Name],[Description],[Document_Type],[Attachment_Name]  
    FROM (  
     SELECT  
     sorter = 1,  
     CAST(Agreement_No AS VARCHAR(100)) AS [Agreement_No],   
     CAST(Title_Name AS NVARCHAR(MAX)) AS [Title],   
     CAST(Deal_Type_Name AS NVARCHAR(MAX)) AS [Title_Type],  
     CAST(Vendor_Name AS NVARCHAR(MAX)) AS [Party_Name],   
     CAST(Attachment_Title AS NVARCHAR(MAX)) AS [Description],   
     CAST(Document_Type_Name AS NVARCHAR(MAX)) AS [Document_Type],   
     CAST(Attachment_File_Name AS NVARCHAR(MAX)) AS [Attachment_Name]  
     From #SynAttachmentHeader  
     UNION ALL  
       SELECT 0,@Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07  
     ) X     
    ORDER BY Sorter  
   END  
   ELSE  
    BEGIN  
    SELECT * FROM #SynAttachmentHeader  
    END  
   END  

	IF OBJECT_ID('tempdb..#AcqAttachmentHeader') IS NOT NULL DROP TABLE #AcqAttachmentHeader
	IF OBJECT_ID('tempdb..#SynAttachmentHeader') IS NOT NULL DROP TABLE #SynAttachmentHeader
END    
  
--SELECT * FROM Syn_Deal WHERE Syn_Deal_Code = 1306  
--SELECT * FROM Syn_Deal_Movie WHERE Syn_Deal_Code = 1306  
--SELECT * FROM Syn_Deal_Attachment WHERE Syn_Deal_Code = 1306
