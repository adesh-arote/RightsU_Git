CREATE PROCEDURE [dbo].[USPGetTitleEpisodes]  
 @titleCode INT  
AS  
BEGIN  
Declare @Loglevel int;

select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPGetTitleEpisodes]', 'Step 1', 0, 'Started Procedure', 0, ''
SET FMTONLY OFF  
 SELECT Title_Content_Code,Episode_No FROM VWTitleContent(NOLOCK) where Title_Code IN (@titleCode) ORDER BY Episode_No 

if(@Loglevel< 2) Exec [USPLogSQLSteps] '[USPGetTitleEpisodes]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END  
  
