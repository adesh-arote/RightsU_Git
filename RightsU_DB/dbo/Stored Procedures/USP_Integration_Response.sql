CREATE PROCEDURE [dbo].[USP_Integration_Response]      
(      
 @Error_Details VARCHAR(MAX),      
 @Is_Error VARCHAR(1),       
 @Module_Name VARCHAR(MAX),         
 @StrXml VARCHAR(MAX)      
)       
AS      
-- =============================================      
-- Author:  <Sagar Mahajan>      
-- Create date: <21 Apr 2016>      
-- Description: <Call From RightsU Plus Web Api and Deserialize XML>      
-- =============================================      
BEGIN       
 SET NOCOUNT ON;       
 DECLARE @Integration_Config_Code INT = 0,@Integration_Log_Code INT = 0 ,@xmlData VARCHAR(MAX) = '', @Result VARCHAR(20)=''       
 BEGIN TRY        
  SELECT @Integration_Config_Code = IC.Integration_Config_Code FROM Integration_Config IC WHERE IC.Module_Name =@Module_Name AND IC.Foreign_System_Name='FPC'        
  IF OBJECT_ID('TEMPDB..#Temp_Updated_Keys') IS NOT NULL      
  BEGIN      
   DROP TABLE #Temp_Updated_Keys      
  END       
  CREATE TABLE #Temp_Updated_Keys      
  (      
   Integration_Key INT,       
   RU_Code INT      
  )        
  --/************************Update Log **********************************/  
  SELECT TOP 1 @Integration_Log_Code = IL.Integration_Log_Code       
  FROM Integration_Log IL WHERE IL.Intergration_Config_Code = @Integration_Config_Code AND IL.Record_Status = 'W'       
  ORDER BY IL.Integration_Log_Code DESC       
      
  IF(ISNULL(@Is_Error,'N') = 'N')      
  BEGIN      
   DECLARE @XML XML      
   SET @XML = CAST(@StrXml AS XML)      
   INSERT INTO #Temp_Updated_Keys(Integration_Key, RU_Code)      
   SELECT Node.Data.value('(FPCCode)[1]', 'VARCHAR(MAX)') AS Integration_Key      
    ,Node.Data.value('(RUCode)[1]', 'VARCHAR(MAX)')   AS RU_Code                    
   FROM         
   @XML.nodes('/Response_Module_Names/Response_Module_Name') Node(Data)      
  
   UPDATE ID SET ID.Processing_Date = GETDATE()    
   FROM #Temp_Updated_Keys TUK    
   INNER JOIN  Integration_Data ID ON TUK.RU_Code = ID.RU_Record_Code  AND TUK.Integration_Key = ID.Foreign_System_Code    
   AND ID.Integration_Config_Code = @Integration_Config_Code AND ISNULL(ID.Foreign_System_Code,0) > 0    
       
   INSERT INTO Integration_Data(Integration_Config_Code, RU_Record_Code,Foreign_System_Code,Creation_Date,      
   Record_Status,Processing_Date)      
   SELECT DISTINCT @Integration_Config_Code,RU_Code,Integration_Key,Getdate(),'D',GETDATE() AS Processing_Date    
   FROM #Temp_Updated_Keys TUK      
   WHERE TUk.RU_Code NOT IN      
   (      
   SELECT ISNULL(ID.RU_Record_Code,0) FROM Integration_Data ID WHERE ID.Integration_Config_Code = @Integration_Config_Code      
   )      
   AND ISNULL(TUK.RU_Code,0) > 0 AND ISNULL(TUK.Integration_Key,0) > 0   
  END     
  IF(UPPER(@Module_Name) = 'INTEGRATION_RUNS')        
  BEGIN      
   UPDATE Integration_Runs SET IsRead = 'Y' WHERE Integration_Runs_Code IN(  
   SELECT TUK.RU_Code FROM #Temp_Updated_Keys TUK)  
  END  
      
  IF(UPPER(@Module_Name) = 'TITLE')        
  BEGIN          
   UPDATE IT SET IT.Foreign_System_Code=TUK.Integration_Key,IT.Record_Status='D',IT.Process_Date=GETDATE() from Integration_Title IT  
   INNER JOIN #Temp_Updated_Keys TUK ON TUK.RU_Code = IT.Title_Code  
  END  
  IF(UPPER(@Module_Name) = 'ACQ_DEAL_RUN')        
  BEGIN  
   UPDATE IAR SET IAR.Foreign_System_Code=TUK.Integration_Key,IAR.Record_Status='D',IAR.Process_Date=GETDATE() from Integration_Acq_Run IAR  
   INNER JOIN #Temp_Updated_Keys TUK ON TUK.RU_Code = IAR.Acq_Deal_Run_Code  
  END  
  IF(UPPER(@Module_Name) = 'ACQ_DEAL_RUN_CHANNEL')        
  BEGIN  
   UPDATE IC SET IC.Record_Status='D',IC.Process_Date=GETDATE() from Acq_Deal_Run_Channel AC   
   INNER JOIN Integration_Acq_Run IR ON IR.Acq_Deal_Run_Code=AC.Acq_Deal_Run_Code   
   INNER JOIN Integration_Acq_Run_Channel IC ON IC.Integration_Acq_Run_Code=IR.Integration_Acq_Run_Code  
   AND IC.Channel_Code=AC.Channel_Code   
   AND ISNULL(IC.Is_Archive,'N')='N'  
   INNER JOIN #Temp_Updated_Keys TUK ON TUK.RU_Code = AC.Acq_Deal_Run_Code  
  END  
  IF(UPPER(@Module_Name) = 'ACQ_DEAL_RUN_YEARWISE')        
  BEGIN  
   UPDATE IY SET IY.Record_Status='D',IY.Process_Date=GETDATE() from Acq_Deal_Run_Yearwise_Run AY   
   INNER JOIN Integration_Acq_Run IR ON IR.Acq_Deal_Run_Code=AY.Acq_Deal_Run_Code   
   INNER JOIN Integration_Acq_Run_Yearwise IY ON IY.Integration_Acq_Run_Code=IR.Integration_Acq_Run_Code  
   AND IY.Start_Date =AY.Start_Date AND IY.End_Date=AY.End_Date AND ISNULL(IY.Is_Archive,'N')='N'  
   INNER JOIN #Temp_Updated_Keys TUK ON TUK.RU_Code = AY.Acq_Deal_Run_Code  
  END  
  
  UPDATE Integration_Log SET      
  Response_DateTime = GETDATE(),      
  Response_XML = CASE WHEN UPPER(@Is_Error) = 'Y' THEN '' ELSE @StrXml END,      
  Record_Status = CASE WHEN UPPER(@Is_Error) = 'Y' THEN 'E' ELSE 'D' END,      
  [Error_Message] = @Error_Details      
  WHERE  Integration_Log_Code = @Integration_Log_Code     
  SET @Result =  'Success'      
 END TRY      
 BEGIN CATCH          
  SET @Is_Error   = 'Y'       
  SET @Result = 'Failed'      
  SET @Error_Details = 'Error In USP_Integration_Response : Error_Details : ' +  ERROR_MESSAGE() + ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)      
  SET @Error_Details =  @Error_Details + ';ErrorLine : '+ CAST(ERROR_LINE() AS VARCHAR) + ' ;'       
  SET @Error_Details =  @Error_Details + ' ;USP Input Parameters : ' +';Error_Details : ' +@Error_Details + ';Is_Error : ' + CAST(@Is_Error AS VARCHAR)      
   + ' ;Module_Name : ' +@Module_Name + ' ;StrXml : ' + @StrXml;      
 END CATCH      
 --SELECT 'Success' AS Result,@Is_Error as Is_Error,@Error_Details AS Error_Details       
       
 SET  @xmlData ='<Response><Result>'+@Result+'</Result><Is_Error>'+@Is_Error+'</Is_Error><Error_Details>'+@Error_Details+'</Error_Details></Response>'       
 SELECT @xmlData AS  ResultXML,@Is_Error as Is_Error,@Error_Details AS Error_Details      
      
END      
   
 /********************************************************1 Role*-**************************************/    
     
    
    
/*    
DECLARE @XML VARCHAR(MAX) = ''    
SET @XML =    
'<Response_Module_Names>    
    <Response_Module_Name>    
       <FPCCode>111</FPCCode>    
       <RUCode>111</RUCode>           
    </Response_Module_Name>    
    <Response_Module_Name>    
        <FPCCode>22222</FPCCode>    
       <RUCode>2</RUCode>      
    </Response_Module_Name>    
</Response_Module_Names>'    
    
EXEC  [dbo].[USP_Integration_Response] '','N','TITLE',@XML    
--SELECT * FROM Integration_Data    
--DELETE FROM Integration_Data    
--SELECT * FROM Integration_Log    
--EXEC  [dbo].[USP_Integration_Response] 'asagar','Y','TITLE',''    
/*    
EXEC [dbo].[USP_Integration_Response] '<?xml version="1.0" ?><Roles><Role><Role_Code>0</Role_Code>  
<Foreign_Code>2</Foreign_Code><Role_Name>Star Cast</Role_Name><Is_Active>Y</Is_Active></Role></Roles>'    
,'N','',2    
*/    
*/  
  
  