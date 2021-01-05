CREATE Function [dbo].[UFN_Get_Rights_Country_Query](@Rights_Code Int, @Deal_Type Char(1))
Returns NVARCHAR(MAX)
As
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 16-December-2014
-- Description:	Return Countrys added for right
-- =============================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		Select @RetVal = @RetVal + c.Country_Name + ', ' From Acq_Deal_Rights_Territory adrt
		Inner Join Country c On adrt.Country_Code = c.Country_Code
		Where Acq_Deal_Rights_Code = @Rights_Code --And Territory_Type = 'I'
	End
	Else
	Begin
		Select @RetVal = @RetVal + c.Country_Name + ', ' From Syn_Deal_Rights_Territory adrt
		Inner Join Country c On adrt.Country_Code = c.Country_Code
		Where Syn_Deal_Rights_Code = @Rights_Code --And Territory_Type = 'I'
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End