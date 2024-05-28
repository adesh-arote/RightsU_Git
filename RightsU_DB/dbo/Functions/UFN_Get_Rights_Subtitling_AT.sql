CREATE Function [dbo].[UFN_Get_Rights_Subtitling_AT](@Rights_Code Int, @Deal_Type Char(1))
Returns NVARCHAR(MAX)
As
-- =======================================================
-- Author:		Adesh P Arote
-- Create DATE: 14-October-2014
-- Description:	Return the Territories added for Rights
-- =======================================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		If((Select Top 1 Language_Type From AT_Acq_Deal_Rights_Subtitling Where AT_Acq_Deal_Rights_Code = @Rights_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group Where Language_Group_Code In (
				Select Language_Group_Code From AT_Acq_Deal_Rights_Subtitling Where AT_Acq_Deal_Rights_Code = @Rights_Code
			) ORDER BY Language_Group_Name 
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] Where Language_Code In (
				Select Language_Code From AT_Acq_Deal_Rights_Subtitling Where AT_Acq_Deal_Rights_Code = @Rights_Code
			)
			ORDER BY Language_Name 
		End
	End
	Else If(@Deal_Type = 'P')
	Begin
		If((Select Top 1 Language_Type From AT_Acq_Deal_Pushback_Subtitling Where AT_Acq_Deal_Pushback_Code = @Rights_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group Where Language_Group_Code In (
				Select Language_Group_Code From AT_Acq_Deal_Pushback_Subtitling Where AT_Acq_Deal_Pushback_Code = @Rights_Code
			)
			ORDER BY Language_Group_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] Where Language_Code In (
				Select Language_Code From AT_Acq_Deal_Pushback_Subtitling Where AT_Acq_Deal_Pushback_Code = @Rights_Code
			)
			ORDER BY Language_Name 
		End
	End
	Else
	Begin
		If((Select Top 1 Language_Type From AT_Syn_Deal_Rights_Subtitling Where AT_Syn_Deal_Rights_Code = @Rights_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group Where Language_Group_Code In (
				Select Language_Group_Code From AT_Syn_Deal_Rights_Subtitling Where AT_Syn_Deal_Rights_Code = @Rights_Code
			)
			ORDER BY Language_Group_Name 
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] Where Language_Code In (
				Select Language_Code From AT_Syn_Deal_Rights_Subtitling Where AT_Syn_Deal_Rights_Code = @Rights_Code
			)
			ORDER BY Language_Name 
		End
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End
