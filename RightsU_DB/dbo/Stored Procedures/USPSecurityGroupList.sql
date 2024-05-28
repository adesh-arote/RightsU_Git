CREATE PROCEDURE [dbo].[USPSecurityGroupList]
AS 
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPSecurityGroupList]', 'Step 1', 0, 'Started Procedure', 0, ''

	select * from Security_Group (NOLOCK)

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPSecurityGroupList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
