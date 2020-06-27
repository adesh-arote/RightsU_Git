CREATE PROCEDURE [dbo].[USPGetTitleCode]  
 @titleName nvarchar(max)  
AS  
BEGIN  
SET FMTONLY OFF  
 SELECT Title_Code FROM VWTitle WHERE Title_Name = ''+@titleName+''  
END  
