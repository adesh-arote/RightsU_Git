      
CREATE PROC USP_GetSystem_Language_Message_ByModule          
(              
 @Module_Code INT,              
 @Form_ID VARCHAR(MAX),                    
 @System_Language_Code INT              
)              
AS              
/*=======================================================================================================================================              
Author  : Pooja Shinde              
Create date : 07 July 2017              
Description : Get System Message Key By Module Code and form Id              
=======================================================================================================================================*/              
BEGIN              
 SET FMTONLY OFF             
-- DECLARE           
 --@Module_Code INT = 163,          
 --@Form_ID VARCHAR(MAX) = '' ,--'Common,General,Rights,Pushback,Material,Ancillary_Test,AddEdit_Test',          
 --@System_Language_Code INT = 3          
          
 IF(OBJECT_ID('TEMPDB..#ResultData') IS NOT NULL)          
  DROP TABLE #ResultData          
          
 IF(OBJECT_ID('TEMPDB..#EmptyMessageDesc') IS NOT NULL)          
  DROP TABLE #EmptyMessageDesc          
          
 IF(OBJECT_ID('TEMPDB..#IntelligenceData') IS NOT NULL)          
  DROP TABLE #IntelligenceData          
          
 IF(OBJECT_ID('TEMPDB..#TempData') IS NOT NULL)          
  DROP TABLE #TempData          
          
 CREATE TABLE #ResultData                
 (                
  System_Message_Code    INT,          
  System_Language_Message_Code INT,          
  Module_Code      INT,          
  System_Module_Message_Code  INT,          
  Message_Key      VARCHAR(MAX),          
  Form_Id       VARCHAR(50),          
  Default_Message_Desc   NVARCHAR(MAX),          
  Message_Desc     NVARCHAR(MAX)          
 )          
          
 DECLARE @defalultSysLangCode INT = 0          
 SELECT TOP 1 @defalultSysLangCode = System_Language_Code FROM System_Language WHERE Is_Default = 'Y'          
          
 INSERT INTO #ResultData(          
  System_Message_Code, System_Language_Message_Code, System_Module_Message_Code, Module_Code,          
  Message_Key, Form_Id, Default_Message_Desc, Message_Desc          
 )          
          
 SELECT           
 SM.System_Message_Code,ISNULL(SLM.System_Language_Message_Code,0) AS System_Language_Message_Code, SMM.System_Module_Message_Code, SMM.Module_Code,          
 SM.Message_Key,ISNULL(SMM.Form_ID,'Common') AS Form_Id, SLM.Message_Desc, SLM.Message_Desc          
 FROM System_Message SM          
 LEFT JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code          
 LEFT JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code           
 AND SLM.System_Language_Code = @defalultSysLangCode          
 --WHERE (ISNULL(SMM.Module_Code, 0) = ISNULL(@Module_Code, 0) OR (SMM.Module_Code IS NULL AND @Form_ID = ''))          
 WHERE (ISNULL(SMM.Module_Code, 0) = ISNULL(@Module_Code, 0))          
 AND (ISNULL(SMM.Form_ID, 'Common') IN (select number from dbo.[fn_Split_withdelemiter] (@Form_ID,',')) OR @Form_ID = '')         
          
        
        
 IF(@System_Language_Code <> @defalultSysLangCode)          
 BEGIN          
  UPDATE #ResultData SET System_Language_Message_Code = 0, Message_Desc = ''          
          
  UPDATE RD SET RD.System_Language_Message_Code = SLM.System_Language_Message_Code, RD.Message_Desc = SLM.Message_Desc           
  FROM #ResultData RD          
  LEFT JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = RD.System_Module_Message_Code          
  WHERE SLM.System_Language_Code = @System_Language_Code          
 END          
          
 /* START : Intelligence */          
 SELECT System_Message_Code, Module_Code, Form_Id, Message_Key, Message_Desc INTO #EmptyMessageDesc FROM #ResultData          
 WHERE ISNULL(Message_Desc, '') = ''          
          
 SELECT ISNULL(SMM.Module_Code, 0) AS Module_Code, T.Message_Key, SLM.Message_Desc,SLM.Last_Updated_Time INTO #TempData          
 FROM #EmptyMessageDesc T          
 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = T.System_Message_Code          
 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code           
 AND SLM.System_Language_Code = @System_Language_Code AND ISNULL(SLM.Message_Desc, '') <> ''          
            
          
 DELETE FROM #TempData WHERE Message_Key IN (          
  SELECT Message_Key FROM #TempData WHERE Module_Code = @Module_Code          
 ) AND Module_Code <> @Module_Code          
          
          
           
 SELECT T.Message_Key, T.Message_Desc, COUNT(*) AS UsedCount, NULL AS [Rank], GETDATE() AS [Last_Updated_Time]          
 INTO #IntelligenceData FROM #TempData T          
 GROUP BY T.Message_Key, T.Message_Desc          
 ORDER BY UsedCount DESC          
          
 UPDATE ID SET ID.[Last_Updated_Time] = TD.Last_Updated_Time FROM #TempData TD          
 INNER JOIN #IntelligenceData ID ON TD.Message_Key = ID.Message_Key AND TD.Message_Desc = ID.Message_Desc          
          
 ;with RankData AS (          
  SELECT Message_Key,UsedCount, RANK() OVER(PARTITION BY Message_Key ORDER BY UsedCount DESC) [Message_Rank]          
  FROM #IntelligenceData          
 )          
          
 UPDATE ID SET ID.[Rank] = RD.Message_Rank FROM #IntelligenceData ID          
 INNER JOIN RankData RD ON  RD.Message_Key = ID.Message_Key AND RD.UsedCount = ID.UsedCount          
 DELETE FROM #IntelligenceData WHERE [Rank] <> 1          
          
 UPDATE #IntelligenceData SET [Rank] = NULL          
          
 ;with RankData AS (          
  SELECT Message_Key,[Last_Updated_Time], RANK() OVER(PARTITION BY Message_Key ORDER BY [Last_Updated_Time] DESC) [Message_Rank]          
  FROM #IntelligenceData          
 )          
 UPDATE ID SET ID.[Rank] = RD.Message_Rank FROM #IntelligenceData ID          
 INNER JOIN RankData RD ON  RD.Message_Key = ID.Message_Key AND RD.[Last_Updated_Time] = ID.[Last_Updated_Time]          
 DELETE FROM #IntelligenceData WHERE [Rank] <> 1          
          
 UPDATE RD SET Message_Desc = ID.Message_Desc FROM #ResultData RD          
 INNER JOIN #IntelligenceData ID ON RD.Message_Key = ID.Message_Key AND ISNULL(RD.Message_Desc, '') = ''          
          
 /* END : Intelligence */          
          
 SELECT System_Message_Code, System_Language_Message_Code, ISNULL(System_Module_Message_Code,0) AS System_Module_Message_Code, Message_Key, Form_Id,ISNULL(Default_Message_Desc,'') AS Default_Message_Desc,ISNULL(Message_Desc,'') AS Message_Desc          
 FROM #ResultData           
 ORDER BY Message_Desc            

	IF OBJECT_ID('tempdb..#EmptyMessageDesc') IS NOT NULL DROP TABLE #EmptyMessageDesc
	IF OBJECT_ID('tempdb..#IntelligenceData') IS NOT NULL DROP TABLE #IntelligenceData
	IF OBJECT_ID('tempdb..#ResultData') IS NOT NULL DROP TABLE #ResultData
	IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
END

--exec USP_GetSystem_Language_Message_ByModule 0,'',2