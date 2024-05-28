CREATE VIEW [dbo].[UsersBusinessUnit]
AS 
SELECT DISTINCT ubu.Users_Business_Unit_Code ,ubu.Users_Code, agb.Attrib_Group_Code AS BU_Code, ag.Attrib_Group_Name AS BU_Name 
FROM RightsU_16Mar..Users_Business_Unit ubu
INNER JOIN RightsU_16Mar..Attrib_Group_BU agb ON ubu.Business_Unit_Code = agb.Business_Unit_Code
INNER JOIN RightsU_16Mar..Attrib_Group ag ON agb.Attrib_Group_Code = ag.Attrib_Group_Code