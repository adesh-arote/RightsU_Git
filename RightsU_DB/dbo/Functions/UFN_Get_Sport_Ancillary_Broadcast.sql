CREATE FUNCTION [dbo].[UFN_Get_Sport_Ancillary_Broadcast]
(@Acq_Deal_Sport_Ancillary_Code Int,@Deal_Type VARCHAR(2))
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
			Select @RetVal = @RetVal + Name + ', ' From Sport_Ancillary_Broadcast Where Sport_Ancillary_Broadcast_Code In (
				Select Sport_Ancillary_Broadcast_Code From Acq_Deal_Sport_Ancillary_Broadcast Where Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
			)
			ORDER BY Name
	End
	Else If(@Deal_Type = 'AT')
	Begin
		Select @RetVal = @RetVal + Name + ', ' From Sport_Ancillary_Broadcast Where Sport_Ancillary_Broadcast_Code In (
				Select Sport_Ancillary_Broadcast_Code From AT_Acq_Deal_Sport_Ancillary_Broadcast Where AT_Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
			)
			ORDER BY Name
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End
