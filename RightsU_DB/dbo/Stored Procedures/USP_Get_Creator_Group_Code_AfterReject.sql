CREATE Proc [dbo].[USP_Get_Creator_Group_Code_AfterReject](@Module_Code Int, @Record_Code Int)
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Creator_Group_Code_AfterReject]', 'Step 1', 0, 'Started Procedure', 0, '' 
		Declare @RetValue Int = 0
		Select Top 1 @RetValue = Group_Code From Module_Workflow_Detail (NOLOCK) 
		Where Record_Code = @Record_Code And Module_Code = @Module_Code And Role_Level = 0 Order By Module_Workflow_Detail_Code Desc

		Select @RetValue RetValue
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Creator_Group_Code_AfterReject]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
End
