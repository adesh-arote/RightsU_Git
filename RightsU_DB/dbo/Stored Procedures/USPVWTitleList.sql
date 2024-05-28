CREATE PROCEDURE [dbo].[USPVWTitleList]  
	@searchString nvarchar(max),  
	@contentType nvarchar(max)   
AS  
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPVWTitleList]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET FMTONLY OFF  
		BEGIN  
			SELECT Title_Code,Title_Name, 0  AS Title_Content_Code FROM VWTitle (NOLOCK) WHERE Title_Name like '%'+@searchString+'%'  
		END  
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPVWTitleList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END  
