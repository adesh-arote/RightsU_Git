

CREATE VIEW [dbo].[Users]
	AS 
	Select 
		Users_Code, Login_Name, First_Name, Last_Name, Password, Email_Id, Security_Group_Code, Is_Active, Is_System_Password, IsProductionHouseUser,
		Password_Fail_Count ,Last_Updated_Time, Last_Action_By,User_Image,'' AS Int_Department, 0 AS HR_Department_Code
	from RightsU_Plus_Testing.DBO.USERS
