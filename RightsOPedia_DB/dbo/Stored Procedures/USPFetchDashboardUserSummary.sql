
CREATE PROCEDURE [dbo].[USPFetchDashboardUserSummary] 
AS 
BEGIN

	SELECT	Login_Name LoginName, 
		First_Name FirstName, 
		Last_Name LastName,
		Security_Group_Name SecurityGroup,
		STUFF((SELECT ', ' + Attrib_Group_Name 
		FROM UsersDetail 
		WHERE UsersDetail.Users_Code = DashboardUserSummary.UserId
		AND Attrib_Type = 'DP'
		FOR XML PATH('')), 1, 1, '') [IntuitiveDepartmentAccess],
		STUFF((SELECT ', ' + Attrib_Group_Name 
		FROM UsersDetail 
		WHERE UsersDetail.Users_Code = DashboardUserSummary.UserId
		AND Attrib_Type = 'BV'
		FOR XML PATH('')), 1, 1, '') [BusinessVerticalAccess]
		,Int_Department Department
		,SUM([NumberOfLogins]) NumberOfLogins
		,SUM([NumberOfUniqueLogins]) NumberOfUniqueLogins
		,MAX(LastLoggedInAt) LastLoggedInAt
		,SUM([NumberOfThumbsUp]) NumberOfThumbsUp
		,SUM([NumberOfThumbsDown]) NumberOfThumbsDown
		,SUM([NumberOfFeedbackMessages] ) NumberOfFeedbackMessages
		FROM Users
		INNER JOIN DashboardUserSummary
		ON Users.Users_Code = DashboardUserSummary.UserId
		INNER JOIN SecurityGroup 
		ON SecurityGroup.Security_Group_Code = Users.Security_Group_Code
		WHERE ReportType = 'D'
		GROUP BY UserId,Login_Name,First_Name,Last_Name, Security_Group_Name, Int_Department, ReportType, Year, Month
		ORDER BY UserId ASC;

END
