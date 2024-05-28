

CREATE VIEW [dbo].[UsersDetail]
AS
SELECT u.Login_Name, ud.*, ag.Attrib_Group_Name, ag.Icon
FROM RightsU_Plus_Testing.dbo.[Users_Detail] ud
INNER JOIN RightsU_Plus_Testing.dbo.[Users] u ON ud.Users_Code = u.Users_Code
INNER JOIN RightsU_Plus_Testing.dbo.[Attrib_Group] ag ON ud.Attrib_Group_Code = ag.Attrib_Group_Code
