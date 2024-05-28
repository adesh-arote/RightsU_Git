CREATE PROCEDURE [dbo].[USP_List_Territory]   
(
@SysLanguageCode INT
) 
AS      
BEGIN      
 SET FMTONLY OFF      
 DECLARE 
 @Yes NVARCHAR(200) = '',
 @No NVARCHAR(200) = ''

 SELECT @Yes = SLM.Message_Desc FROM System_Message SM
		  INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code 
		  AND SM.Message_Key =  'Yes'
		  INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

 SELECT @No = SLM.Message_Desc FROM System_Message SM
		  INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code 
		  AND SM.Message_Key =  'NO'
		  INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

 IF(OBJECT_ID('TEMPDB..#TempTerritory') IS NOT NULL)      
  DROP TABLE #TempTerritory    
    
  SELECT T.Territory_Code,T.Territory_Name, CASE ISNULL(T.Is_Thetrical, 'N') WHEN 'Y' THEN @Yes ELSE @No END AS Theatrical,    
  CAST('' AS NVARCHAR(MAX)) AS [Country_Names],     
   [dbo].[UFN_Get_Disable_Deactive_Message](T.Territory_Code, 59, @SysLanguageCode,'TERRITORY')  AS Disable_Message ,    
  CASE ISNULL(T.Is_Active, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END AS [Status],T.Last_Updated_Time    
 INTO #TempTerritory      
  FROM Territory T    
    
  UPDATE TT SET TT.Country_Names = STUFF((      
   SELECT ', ' + CAST(c.Country_Name AS NVARCHAR(1000)) FROM Territory_Details TD      
   INNER JOIN [Country] C ON C.Country_Code = TD.Country_Code     
   WHERE TD.Territory_Code = TT.Territory_Code     
   ORDER BY C.Country_Name      
   FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'')      
 FROM #TempTerritory TT      
    
  SELECT * FROM #TempTerritory ORDER BY Last_Updated_Time DESC  
  END
  