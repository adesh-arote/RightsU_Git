CREATE PROCEDURE [dbo].[USP_Activity_Log_Users]
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Activity_Log_Users]', 'Step 1', 0, 'Started Procedure', 0, ''
		SELECT Distinct Login_Name AS 'User_Name' FROM Users U (NOLOCK)
		INNER JOIN Users_Activity_Log UAL (NOLOCK) ON UAL.Inserted_By = U.Users_Code

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Activity_Log_Users]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END