CREATE PROCEDURE [dbo].[USPMHGetMenu]
@SecurityGroupCode INT
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetMenu]', 'Step 1', 0, 'Started Procedure', 0, ''
		Select Module_Code AS ModuleCode, Module_Name AS ModuleName from System_Module Where Module_Code IN (
		Select Module_Code from System_Module_Right (NOLOCK) where Module_Right_Code IN(
		Select System_Module_Rights_Code from Security_Group_Rel (NOLOCK) where Security_Group_Code = @SecurityGroupCode
		)) AND Is_Active = 'Y'
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetMenu]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END

