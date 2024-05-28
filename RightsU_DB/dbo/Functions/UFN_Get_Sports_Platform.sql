
Create Function [dbo].[UFN_Get_Sports_Platform](@Acq_Deal_Sport_Code Int, @Mode VARCHAR(2),@Deal_Type VARCHAR(2))
Returns Varchar(MAX)
As
-- =============================================
-- Author:		Rajesh Godse
-- Create DATE: 18-November-2015
-- Description:	Return Platform Names
-- =============================================
Begin

	Declare @RetVal Varchar(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		If(@Mode = 'SM')
		Begin
			Select @RetVal = @RetVal + Platform_Hiearachy + ', ' From Platform Where Platform_Code In (
				Select Platform_Code From Acq_Deal_Sport_Platform Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'SM'
			)
			ORDER BY Platform_Hiearachy
		End
		Else
		Begin
			Select @RetVal = @RetVal + Platform_Hiearachy + ', ' From Platform Where Platform_Code In (
				Select Platform_Code From Acq_Deal_Sport_Platform Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'ST'
			)
			ORDER BY Platform_Hiearachy
		End
	End
	Else If(@Deal_Type = 'AT')
	Begin
		If(@Mode = 'SM')
		Begin
			Select @RetVal = @RetVal + Platform_Hiearachy + ', ' From Platform Where Platform_Code In (
				Select Platform_Code From AT_Acq_Deal_Sport_Platform Where AT_Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'SM'
			)
			ORDER BY Platform_Hiearachy
		End
		Else
		Begin
			Select @RetVal = @RetVal + Platform_Hiearachy + ', ' From Platform Where Platform_Code In (
				Select Platform_Code From AT_Acq_Deal_Sport_Platform Where AT_Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'ST'
			)
			ORDER BY Platform_Hiearachy
		End
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End
