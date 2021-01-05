CREATE Function [dbo].[UFN_Get_Sport_Language](@Acq_Deal_Sport_Code Int, @Deal_Type VarChar(2))
Returns NVARCHAR(MAX)
As
-- =============================================
-- Author:		Rajesh J Godse
-- Create DATE: 18-November-2015
-- Description:	Return Language for Sport
-- =============================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		If((Select Top 1 Language_Type From Acq_Deal_Sport_Language Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group Where Language_Group_Code In (
				Select Language_Group_Code From Acq_Deal_Sport_Language Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
			)
			ORDER BY Language_Group_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] Where Language_Code In (
				Select Language_Code From Acq_Deal_Sport_Language Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
			)
			ORDER BY Language_Name
		End
	End
	Else If(@Deal_Type = 'AT')
	Begin
		If((Select Top 1 Language_Type From AT_Acq_Deal_Sport_Language Where AT_Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code) = 'G')
		Begin
			Select @RetVal = @RetVal + Language_Group_Name + ', ' From Language_Group Where Language_Group_Code In (
				Select Language_Group_Code From AT_Acq_Deal_Sport_Language Where AT_Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
			)
			ORDER BY Language_Group_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Language_Name + ', ' From [Language] Where Language_Code In (
				Select Language_Code From AT_Acq_Deal_Sport_Language Where AT_Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
			)
			ORDER BY Language_Name
		End
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End
