CREATE Proc [dbo].[USP_Get_Territory_ForDDL]
(
	@Is_Theatrical Char(1)
 )
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Territory_ForDDL]', 'Step 1', 0, 'Started Procedure', 0, ''

		Select Territory_Code, Territory_Name From Territory (NOLOCK) Where Territory_Code In (Select Territory_Code From Territory_Details (NOLOCK)) and Is_Active = 'Y' And IsNull(Is_Thetrical, 'N') = @Is_Theatrical
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Territory_ForDDL]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End
