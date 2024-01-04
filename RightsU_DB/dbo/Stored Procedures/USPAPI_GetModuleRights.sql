CREATE PROCEDURE [dbo].[USPAPI_GetModuleRights]
	@SecurityGroupCode int
AS
BEGIN

	SELECT SM.Module_Code,SM.Module_Name,SM.Url,SR.Right_Code,SR.Right_Name 
	FROM System_Module SM
	INNER JOIN System_Module_Right SMR ON SMR.Module_Code=SM.Module_Code
	INNER JOIN Security_Group_Rel SGR ON SGR.System_Module_Rights_Code=SMR.Module_Right_Code
	INNER JOIN System_Right SR ON SR.Right_Code=SMR.Right_Code
	Where SGR.Security_Group_Code=@SecurityGroupCode AND SM.Is_Active='Y'
	Order by SM.Module_Position

END

