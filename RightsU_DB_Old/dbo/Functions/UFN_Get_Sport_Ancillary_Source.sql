CREATE FUNCTION [dbo].[UFN_Get_Sport_Ancillary_Source]
(@Acq_Deal_Sport_Ancillary_Code Int,@Deal_Type VARCHAR(2))
Returns NVARCHAR(MAX)
As
-- =============================================
-- Author:		Rajesh Godse
-- Create DATE: 18-November-2015
-- Description:	Return Sport ancillary source names
-- =============================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
			Select @RetVal = @RetVal + Name + ', ' From Sport_Ancillary_Source Where Sport_Ancillary_Source_Code In (
				Select Sport_Ancillary_Source_Code From Acq_Deal_Sport_Ancillary_Source Where Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
			)
			ORDER BY Name
	End
	Else If(@Deal_Type = 'AT')
	Begin
		Select @RetVal = @RetVal + Name + ', ' From Sport_Ancillary_Source Where Sport_Ancillary_Source_Code In (
				Select Sport_Ancillary_Source_Code From AT_Acq_Deal_Sport_Ancillary_Source Where AT_Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
			)
			ORDER BY Name
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End