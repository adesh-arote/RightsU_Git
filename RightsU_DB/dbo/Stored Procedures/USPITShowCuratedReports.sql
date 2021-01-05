CREATE PROCEDURE USPITShowCuratedReports
@Users_Code INT,
@DealFor VARCHAR(50)
AS
BEGIN
	DECLARE @SecurityCode INT;
	SET @SecurityCode = (select security_group_code from users where users_code = @Users_Code);

	SELECT ReportId, ReportName, Usr.First_Name + ' ' + Usr.Last_Name as UserName, Visibility, Criteria, FORMAT(CAST(CreatedOn as DATETIME), 'dd-MM-yyyy hh:mm tt') as CreatedOn, ITC.Users_Code as UsersCode FROM IT_CuratedReports ITC
	INNER JOIN Users Usr ON ITC.Users_Code = Usr.Users_Code
	WHERE ITC.DealFor = @DealFor AND (ITC.Users_Code = @Users_Code OR ITC.Visibility = 'PU' OR
	(ITC.Users_Code in (SELECT Users_Code FROM users WHERE users.security_group_code = @SecurityCode AND users.users_code <> @Users_Code) AND Visibility = 'GR'))
	ORDER BY 1 DESC
END
