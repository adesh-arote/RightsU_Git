


CREATE VIEW [dbo].[Users]
	AS 
	--Select 
	--	Users_Code, Login_Name, First_Name, Last_Name, Password, Email_Id, Security_Group_Code, Is_Active, Is_System_Password, IsProductionHouseUser,
	--	Password_Fail_Count ,Last_Updated_Time, Last_Action_By,User_Image, 0 Int_Department, '' HR_Department_Code, ChangePasswordLinkGUID
	--from RightsU_Plus_Testing.dbo.USERS

	select 
		x.Users_Code, x.Login_Name, x.First_Name, x.Last_Name, x.Password, x.Email_Id, x.Security_Group_Code, x.Is_Active, x.Is_System_Password, x.IsProductionHouseUser,
		x.Password_Fail_Count ,x.Last_Updated_Time, x.Last_Action_By,x.User_Image, 0 Int_Department,case x.HR_Department_Code when '' then isnull(y.HR_Department_Code,'') else x.HR_Department_Code end  HR_Department_Code, x.ChangePasswordLinkGUID from (
	Select 
		Users_Code, Login_Name, First_Name, Last_Name, Password, Email_Id, Security_Group_Code, Is_Active, Is_System_Password, IsProductionHouseUser,
		Password_Fail_Count ,Last_Updated_Time, Last_Action_By,User_Image, 0 Int_Department, '' HR_Department_Code, ChangePasswordLinkGUID
	from RightsU_Plus_Testing.dbo.USERS
	)x
	left join  
	(
	Select 
		Users_Code, Login_Name, First_Name, Last_Name, Password, Email_Id, Security_Group_Code, Is_Active, Is_System_Password, IsProductionHouseUser,
		Password_Fail_Count ,Last_Updated_Time, Last_Action_By,User_Image, 0 Int_Department,  0 AS HR_Department_Code
	from RightsU_Plus_Testing.dbo.USERS
	)y on upper(x.Login_Name)=upper(y.Login_Name);
