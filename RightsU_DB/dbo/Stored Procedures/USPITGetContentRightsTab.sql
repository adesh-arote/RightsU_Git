CREATE PROCEDURE [dbo].[USPITGetContentRightsTab]
@SecurityGroupCode varchar(10),
@IsSuperAdmin char(1),
@Users_Code INT
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetContentRightsTab]', 'Step 1', 0, 'Started Procedure', 0, ''

		SELECT DISTINCT sm.Module_Name + '_' + sr.Right_Name AS Module_Name
			FROM System_Right sr (NOLOCK)
				INNER JOIN System_Module_Right smr (NOLOCK) ON smr.Right_Code=sr.Right_Code 
				INNER JOIN Security_Group_Rel sgr (NOLOCK) ON sgr.System_Module_Rights_Code = smr.Module_Right_Code 
				INNER JOIN System_Module sm (NOLOCK) ON sm.Module_Code = smr.Module_Code 
			WHERE sr.Right_Code = smr.Right_Code 
				AND sm.Is_Active = 'Y'
				AND sr.Right_Name IN ('Supplementary','Digital','ACQ Ancillary Right')
				AND sgr.Security_Group_Code = @SecurityGroupCode
			ORDER BY 1
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetContentRightsTab]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END