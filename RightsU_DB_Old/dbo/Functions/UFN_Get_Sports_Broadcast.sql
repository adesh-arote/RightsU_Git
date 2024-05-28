CREATE Function [dbo].[UFN_Get_Sports_Broadcast](@Acq_Deal_Sport_Code Int, @Mode VARCHAR(2),@Deal_Type VARCHAR(2))
Returns NVARCHAR(MAX)
As
-- =============================================
-- Author:		Rajesh Godse
-- Create DATE: 18-November-2015
-- Description:	Return BroadCast names
-- =============================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		If(@Mode = 'MO')
		Begin
			Select @RetVal = @RetVal + Broadcast_Mode_Name + ', ' From Broadcast_Mode Where Broadcast_Mode_Code In (
				Select Broadcast_Mode_Code From Acq_Deal_Sport_Broadcast Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'MO'
			)
			ORDER BY Broadcast_Mode_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Broadcast_Mode_Name + ', ' From Broadcast_Mode Where Broadcast_Mode_Code In (
				Select Broadcast_Mode_Code From Acq_Deal_Sport_Broadcast Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'OB'
			)
			ORDER BY Broadcast_Mode_Name
		End
	End
	Else If(@Deal_Type = 'AT')
	Begin
		If(@Mode = 'MO')
		Begin
			Select @RetVal = @RetVal + Broadcast_Mode_Name + ', ' From Broadcast_Mode Where Broadcast_Mode_Code In (
				Select Broadcast_Mode_Code From AT_Acq_Deal_Sport_Broadcast Where AT_Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'MO'
			)
			ORDER BY Broadcast_Mode_Name
		End
		Else
		Begin
			Select @RetVal = @RetVal + Broadcast_Mode_Name + ', ' From Broadcast_Mode Where Broadcast_Mode_Code In (
				Select Broadcast_Mode_Code From AT_Acq_Deal_Sport_Broadcast Where AT_Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND [Type] = 'OB'
			)
			ORDER BY Broadcast_Mode_Name
		End
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End
