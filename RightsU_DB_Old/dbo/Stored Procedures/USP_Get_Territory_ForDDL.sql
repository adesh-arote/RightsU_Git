CREATE Proc [dbo].[USP_Get_Territory_ForDDL]
(
	@Is_Theatrical Char(1)
 )
As
Begin
	Select Territory_Code, Territory_Name From Territory Where Territory_Code In (Select Territory_Code From Territory_Details) and Is_Active = 'Y' And IsNull(Is_Thetrical, 'N') = @Is_Theatrical
End