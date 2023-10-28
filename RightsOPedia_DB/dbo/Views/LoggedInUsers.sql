


CREATE VIEW [dbo].[LoggedInUsers]
	AS 
	Select LoggedInUsersCode, LoginName, HostIP, BrowserDetails, AccessToken, RefreshToken, LoggedInUrl, LoggedinTime, LastUpdatedTime
	from RightsU_Plus_Testing.dbo.LoggedInUsers





