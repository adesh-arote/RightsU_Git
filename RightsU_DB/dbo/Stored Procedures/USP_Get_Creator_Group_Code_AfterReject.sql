Create Proc USP_Get_Creator_Group_Code_AfterReject(@Module_Code Int, @Record_Code Int)
As
Begin
	Declare @RetValue Int = 0
	Select Top 1 @RetValue = Group_Code From Module_Workflow_Detail 
	Where Record_Code = @Record_Code And Module_Code = @Module_Code And Role_Level = 0 Order By Module_Workflow_Detail_Code Desc

	Select @RetValue RetValue
End
