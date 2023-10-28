CREATE PROCEDURE [dbo].[USPGetTitleCode]  
 @titleName nvarchar(max)  
AS  
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPGetTitleCode]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET FMTONLY OFF  
	 SELECT Title_Code FROM VWTitle(NOLOCK) WHERE Title_Name = ''+@titleName+''  
 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPGetTitleCode]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END  

  