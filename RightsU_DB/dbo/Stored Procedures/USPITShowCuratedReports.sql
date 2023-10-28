CREATE PROCEDURE [dbo].[USPITShowCuratedReports]
@Users_Code INT,
@DealFor VARCHAR(50)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITShowCuratedReports]', 'Step 1', 0, 'Started Procedure', 0, ''

		DECLARE @SecurityCode INT;
		SET @SecurityCode = (select security_group_code from users (NOLOCK) where users_code = @Users_Code);

		SELECT ReportId, ReportName, Usr.First_Name + ' ' + Usr.Last_Name as UserName, Visibility, Criteria, ITC.ShowCriteria, FORMAT(CAST(CreatedOn as DATETIME), 'dd-MM-yyyy hh:mm tt') as CreatedOn, ITC.Users_Code as UsersCode,
			   DealFor, DownloadFileName, RecordStatus, ErrorMessage
		FROM IT_CuratedReports ITC (NOLOCK)
		INNER JOIN Users Usr (NOLOCK) ON ITC.Users_Code = Usr.Users_Code
		WHERE ITC.DealFor LIKE '%' + @DealFor + '%' AND (ITC.Users_Code = @Users_Code OR ITC.Visibility = 'PU' OR
		(ITC.Users_Code in (SELECT Users_Code FROM users (NOLOCK) WHERE users.security_group_code = @SecurityCode AND users.users_code <> @Users_Code) AND Visibility = 'GR'))
		ORDER BY 1 DESC
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITShowCuratedReports]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
