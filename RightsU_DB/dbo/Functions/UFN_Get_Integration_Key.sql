CREATE FUNCTION [dbo].[UFN_Get_Integration_Key]  
(  
 @Module_Name NVARCHAR(100),   
 @RU_Record_Code VARCHAR(100),  
 @Foreign_System_Name NVARCHAR(100)  
)  
RETURNS VARCHAR(MAX)  
AS  
BEGIN  
 DECLARE @Integration_key VARCHAR(1000) = '0'  
 SELECT DISTINCT @Integration_key  =    
 (  
  SELECT STUFF((SELECT DISTINCT  ',' + CAST(ISNULL(Foreign_System_Code,0) AS VARCHAR(MAX))   
  FROM Integration_Data ID WHERE ID.Integration_Config_Code IN  
  (  
   SELECT TOP 1 Integration_Config_Code FROM Integration_Config IC  
   WHERE  Foreign_System_Name = @Foreign_System_Name AND(  
    IC.Module_Name =@Module_Name  --OR (IC.Module_Code = @Module_Code OR ISNULL(@Module_Code,0) > 0)  
   )  
  )  
  AND   
  (  
   ID.RU_Record_Code IN(SELECT Number FROM fn_Split_withdelemiter(ISNULL(@RU_Record_Code,0),',')) --OR ISNULL(@RU_Record_Code,0) = 0  
  )  
  FOR XML PATH('')), 1, 1, '') AS Integration_key  
 )  
 RETURN  ISNULL(@Integration_key,'0')   
END  
/*  
SELECT [dbo].[UFN_Get_Integration_Key] ('Role',4,'FPC')  
SELECT * FROM Integration_Config  
INSERT INTO Integration_Config(Module_Name,Module_Code,Foreign_System_Name,Is_Active)  
SELECT 'Genres',0,'FPC','Y'  
SELECT [dbo].[UFN_Get_Integration_Key] ('Genres',Genres_Code,'FPC') AS Talent_Roles     
FROm Title_Geners TG WHERE TG.Title_Code = 682  
*/  
  
  
--SELECT [dbo].[UFN_Get_Integration_Key] ('Genres',(Genres_Code),'FPC') AS Talent_Roles     
--FROm Title_Geners TG WHERE TG.Title_Code = 682  
  
--SELECT  [dbo].[UFN_Get_Integration_Key] ('Genres',  
--(  
--SELECT STUFF((SELECT DISTINCT  ',' + CAST(ISNULL(TG.Genres_Code,0) AS VARCHAR(MAX))   
--FROM Title_Geners TG  
--WHERE TG.Title_Code = 685  
--FOR XML PATH('')), 1, 1, '')   
--),'FPC')  
