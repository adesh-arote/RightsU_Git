CREATE PROCEDURE [dbo].[USPGetPlatformTreeView]
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPGetPlatformTreeView]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SELECT Platform_Code, Platform_Name, 
		IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position, 
		(SELECT COUNT(*) FROM Platform TP (NOLOCK)  WHERE TP.Parent_Platform_Code = p.Platform_Code) ChildCount
		FROM PLATFORM p  (NOLOCK) 
		ORDER BY Module_Position
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPGetPlatformTreeView]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END