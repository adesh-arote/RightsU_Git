CREATE FUNCTION [dbo].[UFN_Get_Title_Objection_Territory]    
(        
 @Title_Objection_Code AS INT    
)         
RETURNS NVARCHAR(max)         
AS        
-- =============================================    
-- Author:   Ayush Dubey    
-- Create DATE:  28-September-2021    
-- Description:  Get Territory/Country name depends on conditions    
-- =============================================    
BEGIN         
    
 DECLARE @CountryName AS NVARCHAR(MAX) -- ,  @Acq_Deal_Code  INT  = 11  
    
 DECLARE @Temp TABLE    
 (    
  Title_Objection_Code INT,    
  Territory_Type  CHAR(1),    
  Record_Count INT    
 )    
  
  INSERT INTO @Temp    
 SELECT Title_Objection_Code, A.Territory_Type, COUNT(Code) AS Record_Count FROM (    
  SELECT DISTINCT ADR.Title_Objection_Code AS Title_Objection_Code,     
  TOT.Territory_Type,     
  CASE WHEN Territory_Type = 'I' THEN Country_Code ELSE Territory_Code END AS Code    
  FROM Title_Objection ADR with(nolock)    
  INNER JOIN Title_Objection_Territory TOT with(nolock) ON ADR.Title_Objection_Code = TOT.Title_Objection_Code           
  WHERE ADR.Title_Objection_Code = @Title_Objection_Code  
 ) AS A    
 GROUP BY A.Title_Objection_Code, A.Territory_Type  
    
 IF( EXISTS( SELECT TOP 1 Record_Count FROM @Temp WHERE Territory_Type = 'G' AND Record_Count > 1 ) )    
  SET @CountryName = COALESCE(@CountryName + ' / ', '') + 'Multiple Territories'    
    
 IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Territory_Type = 'G' AND Record_Count = 1 ) )    
 BEGIN    
  SELECT TOP 1 @CountryName = COALESCE(@CountryName + ' / ', '') + TT.Territory_Name FROM Title_Objection T with(nolock)    
  INNER JOIN Title_Objection_Territory TOTY with(nolock) ON T.Title_Objection_Code = TOTY.Title_Objection_Code AND TOTY.Territory_Type = 'G'    
  INNER JOIN Territory TT with(nolock) ON TT.Territory_Code = TOTY.Territory_Code    
  Where  T.Title_Objection_Code = @Title_Objection_Code  --WHERE Territory_Type = 'G' AND Record_Count = 1    
 END    
  
 IF( EXISTS( SELECT TOP 1 Record_Count FROM @Temp WHERE Territory_Type = 'I' AND Record_Count = 1) )    
 BEGIN    
  SELECT TOP 1 @CountryName = COALESCE(@CountryName + ' / ', '') + C.Country_Name FROM Title_Objection T with(nolock)    
   INNER JOIN Title_Objection_Territory TOTY with(nolock) ON T.Title_Objection_Code = TOTY.Title_Objection_Code AND TOTY.Territory_Type = 'I'    
  INNER JOIN Country C with(nolock) ON C.Country_Code = TOTY.Country_Code    
  Where  T.Title_Objection_Code = @Title_Objection_Code  --WHERE Territory_Type = 'G' AND Record_Count = 1    
 END    
    
   IF( EXISTS( SELECT TOP 1 Record_Count FROM @Temp WHERE Territory_Type = 'I' AND Record_Count > 1 ) )    
  SET @CountryName =  COALESCE(@CountryName + ' / ', '')  + 'Multiple Countries'   
    
 RETURN @CountryName        
             
END    
/*    
SELECT [dbo].[UFN_Get_Title_Objection_Territory] (16)    
*/    