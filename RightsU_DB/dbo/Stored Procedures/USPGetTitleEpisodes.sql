CREATE PROCEDURE [dbo].[USPGetTitleEpisodes]  
 @titleCode INT  
AS  
BEGIN  
SET FMTONLY OFF  
 SELECT Title_Content_Code,Episode_No FROM VWTitleContent where Title_Code IN (@titleCode) ORDER BY Episode_No  
END 