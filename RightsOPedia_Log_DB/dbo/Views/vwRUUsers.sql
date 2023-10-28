
CREATE VIEW [dbo].[vwRUUsers]
AS
SELECT u.Users_Code, u.Login_Name, sg.Security_Group_Code, sg.Security_Group_Name, bu.Business_Unit_Code, bu.Business_Unit_Name, ud.Attrib_Group_Code, ag.Attrib_Group_Name
FROM RightsU_16Mar..Users u
INNER JOIN RightsU_16Mar..Users_Business_Unit ubu ON u.Users_Code = ubu.Users_Code
INNER JOIN RightsU_16Mar..Users_Detail ud ON ud.Users_Code = u.Users_Code AND ud.Attrib_Type = 'BV'
INNER JOIN RightsU_16Mar..Security_Group sg ON u.Security_Group_Code = sg.Security_Group_Code
INNER JOIN RightsU_16Mar..Business_Unit bu ON ubu.Business_Unit_Code = bu.Business_Unit_Code
INNER JOIN RightsU_16Mar..Attrib_Group ag ON ag.Attrib_Group_Code = ud.Attrib_Group_Code
WHERE u.Users_Code IN (
SELECT TOP 25 Users_Code FROM RightsU_16Mar..Users WHERE Is_Active = 'Y'
)