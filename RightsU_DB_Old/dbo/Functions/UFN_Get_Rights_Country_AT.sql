CREATE Function [dbo].[UFN_Get_Rights_Country_AT](@Rights_Code Int, @Deal_Type Char(1))
Returns NVARCHAR(MAX)
As
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 14-October-2014
-- Description:	Return Countrys added for right
-- =============================================
Begin

	Declare @RetVal NVARCHAR(MAX) = ''
	If(@Deal_Type = 'A')
	Begin
		Select @RetVal = @RetVal + c.Country_Name + ', ' From AT_Acq_Deal_Rights_Territory adrt
		Inner Join Country c On adrt.Country_Code = c.Country_Code
		Where AT_Acq_Deal_Rights_Code = @Rights_Code And Territory_Type = 'I'
		ORDER BY c.Country_Name
	End
	Else If(@Deal_Type = 'P')
	Begin
		Select @RetVal = @RetVal + c.Country_Name + ', ' From AT_Acq_Deal_Pushback_Territory adrt
		Inner Join Country c On adrt.Country_Code = c.Country_Code
		Where AT_Acq_Deal_Pushback_Code = @Rights_Code And Territory_Type = 'I'
		ORDER BY c.Country_Name
	End
	Else
	Begin
		Select @RetVal = @RetVal + c.Country_Name + ', ' From AT_Syn_Deal_Rights_Territory adrt
		Inner Join Country c On adrt.Country_Code = c.Country_Code
		Where AT_Syn_Deal_Rights_Code = @Rights_Code And Territory_Type = 'I'
		ORDER BY c.Country_Name
	End

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End
