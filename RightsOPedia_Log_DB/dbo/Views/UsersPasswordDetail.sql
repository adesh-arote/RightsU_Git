

CREATE VIEW [dbo].[UsersPasswordDetail]
	AS 
	Select Users_Password_Detail_Code, Users_Code, Users_Passwords, Password_Change_Date
	from RightsU_Plus_Testing.DBO.Users_Password_Detail
