CREATE PROCEDURE USPMHGetMenu
@SecurityGroupCode INT
AS
BEGIN
	Select Module_Code AS ModuleCode, Module_Name AS ModuleName from System_Module Where Module_Code IN (
	Select Module_Code from System_Module_Right where Module_Right_Code IN(
	Select System_Module_Rights_Code from Security_Group_Rel where Security_Group_Code = @SecurityGroupCode
	)) AND Is_Active = 'Y'
END

