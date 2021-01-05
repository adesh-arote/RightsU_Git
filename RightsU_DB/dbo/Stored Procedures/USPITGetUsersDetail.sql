CREATE PROCEDURE USPITGetUsersDetail
@Users_Code INT
AS
BEGIN
	Select u.First_Name, ISNULL(u.Middle_Name,'') AS Middle_Name, ISNULL(u.Last_Name,'') AS Last_Name, ISNULL(u.Email_Id,'') AS Email_Id,
	STUFF((SELECT Distinct ', '+ bu.Business_Unit_Name
						FROM Business_Unit bu
						INNER JOIN Users_Business_Unit ubu ON ubu.Business_Unit_Code = bu.Business_Unit_Code
						WHERE ubu.Users_Code = u.Users_Code
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '
			) AS BusinessUnit, sg.Security_Group_Name
	from 
	Users u
	INNER JOIN Security_Group sg ON sg.Security_Group_Code = u.Security_Group_Code
	WHERE u.Users_Code = @Users_Code
END
