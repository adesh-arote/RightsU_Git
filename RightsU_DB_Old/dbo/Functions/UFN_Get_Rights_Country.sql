CREATE Function [dbo].[UFN_Get_Rights_Country](@Rights_Code Int, @Deal_Type Char(1), @Is_Theatrical char(1) = '')
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
		Select @RetVal = @RetVal + c.Country_Name + ', ' From Acq_Deal_Rights_Territory adrt
		Inner Join Country c On adrt.Country_Code = c.Country_Code
		Where Acq_Deal_Rights_Code = @Rights_Code And Territory_Type = 'I' 
		AND (C.Is_Theatrical_Territory = @Is_Theatrical OR @Is_Theatrical = '')
		ORDER BY c.Country_Name
	End
	Else If(@Deal_Type = 'P')
	Begin
		Select @RetVal = @RetVal + c.Country_Name + ', ' From Acq_Deal_Pushback_Territory adrt
		Inner Join Country c On adrt.Country_Code = c.Country_Code
		Where Acq_Deal_Pushback_Code = @Rights_Code And Territory_Type = 'I' 
		AND (C.Is_Theatrical_Territory = @Is_Theatrical OR @Is_Theatrical = '')
		ORDER BY c.Country_Name
	End
	ELSE
	BEGIN
		IF(@Is_Theatrical = 'Y')
		BEGIN
			Select @RetVal = @RetVal + c.Country_Name + ', ' From Syn_Deal_Rights_Territory adrt
			Inner Join Country c On adrt.Country_Code = c.Country_Code
			Where Syn_Deal_Rights_Code = @Rights_Code And Territory_Type = 'I' 
			AND (C.Is_Theatrical_Territory = @Is_Theatrical OR @Is_Theatrical = '')
			ORDER BY c.Country_Name
		END
		ELSE
			Select @RetVal = @RetVal + c.Country_Name + ', ' From Syn_Deal_Rights_Territory adrt
			Inner Join Country c On adrt.Country_Code = c.Country_Code
			Where Syn_Deal_Rights_Code = @Rights_Code And Territory_Type = 'I'
			ORDER BY c.Country_Name
		END
	Return Substring(@RetVal, 0, Len(@RetVal))
End

--Select * from Syn_Deal
--Select * from Syn_Deal_Rights
--Select * from Country

--EXEC USP_Syndication_Deal_List_Report '', '', '', 0, '', 0, 'N','N','Y'