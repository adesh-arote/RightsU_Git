CREATE Function [dbo].[UFN_Get_Rights_Territory](@Rights_Code Int, @Deal_Type Char(1))
Returns NVARCHAR(MAX)
As
-- =======================================================
-- Author:		Adesh P Arote
-- Create DATE: 14-October-2014
-- Description:	Returns the Territories added for Rights
-- =======================================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		Select @RetVal = @RetVal + Territory_Name + ', ' From Territory Where Territory_Code In (
			Select Distinct Territory_Code From Acq_Deal_Rights_Territory Where Acq_Deal_Rights_Code = @Rights_Code And Territory_Type = 'G'
		)
	End
	Else If(@Deal_Type = 'P')
	Begin
		Select @RetVal = @RetVal + Territory_Name + ', ' From Territory Where Territory_Code In (
			Select Distinct Territory_Code From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Rights_Code And Territory_Type = 'G'
		)
	End
	Else
	Begin
		Select @RetVal = @RetVal + Territory_Name + ', ' From Territory Where Territory_Code In (
			Select Distinct Territory_Code From Syn_Deal_Rights_Territory Where Syn_Deal_Rights_Code = @Rights_Code And Territory_Type = 'G'
		)
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End