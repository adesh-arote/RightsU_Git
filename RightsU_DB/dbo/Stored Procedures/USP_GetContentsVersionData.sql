CREATE PROC [dbo].[USP_GetContentsVersionData]
(
	@Title_Content_Code BIGINT
)
AS
/*==============================================
Author:			Sayali Surve
Create date:	03 Apr 2017
Description:	Get Content Version data
===============================================*/
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsVersionData]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SELECT TCV.Title_Content_Version_Code,V.Version_Code,V.Version_Name, 
		(SELECT TOP 1 isnull(House_id,'') FROM Title_Content_Version_Details TCVD (NOLOCK) WHERE TCVD.Title_Content_Version_Code = TCV.Title_Content_Version_Code) AS [House_Id], TCV.Duration, TCV.StatusCode
		FROM Title_Content_Version TCV (NOLOCK) 
		INNER JOIN [Version] V (NOLOCK) ON V.Version_Code = TCV.Version_Code AND TCV.Title_Content_Code = @Title_Content_Code
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsVersionData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END