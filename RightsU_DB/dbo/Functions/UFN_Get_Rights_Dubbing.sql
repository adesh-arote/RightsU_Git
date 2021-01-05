

CREATE FUNCTION [dbo].[UFN_Get_Rights_Dubbing](@Rights_Code Int, @Deal_Type Char(1))
Returns NVARCHAR(MAX)
As
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 14-October-2014
-- Description:	Return Territories added for Rights
-- =============================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		If((Select Top 1 Language_Type From Acq_Deal_Rights_Dubbing WITH(NOLOCK) Where Acq_Deal_Rights_Code = @Rights_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group WITH(NOLOCK) Where Language_Group_Code In (
				Select Language_Group_Code From Acq_Deal_Rights_Dubbing WITH(NOLOCK) Where Acq_Deal_Rights_Code = @Rights_Code
			)
			ORDER BY Language_Group_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] WITH(NOLOCK) Where Language_Code In (
				Select Language_Code From Acq_Deal_Rights_Dubbing WITH(NOLOCK) Where Acq_Deal_Rights_Code = @Rights_Code
			)
			ORDER BY Language_Name
		End
	End
	Else If(@Deal_Type = 'P')
	Begin
		If((Select Top 1 Language_Type From Acq_Deal_Pushback_Dubbing WITH(NOLOCK) Where Acq_Deal_Pushback_Code = @Rights_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group WITH(NOLOCK) Where Language_Group_Code In (
				Select Language_Group_Code From Acq_Deal_Pushback_Dubbing WITH(NOLOCK) Where Acq_Deal_Pushback_Code = @Rights_Code
			)
			ORDER BY Language_Group_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] WITH(NOLOCK) Where Language_Code In (
				Select Language_Code From Acq_Deal_Pushback_Dubbing WITH(NOLOCK) Where Acq_Deal_Pushback_Code = @Rights_Code
			)
			ORDER BY Language_Name
		End
	End
	Else
	Begin
		If((Select Top 1 Language_Type From Syn_Deal_Rights_Dubbing WITH(NOLOCK) Where Syn_Deal_Rights_Code = @Rights_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group WITH(NOLOCK) Where Language_Group_Code In (
				Select Language_Group_Code From Syn_Deal_Rights_Dubbing WITH(NOLOCK) Where Syn_Deal_Rights_Code = @Rights_Code
			)
			ORDER BY Language_Group_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] WITH(NOLOCK) Where Language_Code In (
				Select Language_Code From Syn_Deal_Rights_Dubbing WITH(NOLOCK) Where Syn_Deal_Rights_Code = @Rights_Code
			)
			ORDER BY Language_Name
		End
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End


