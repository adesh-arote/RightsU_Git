
CREATE Proc [dbo].[USP_Delete_Acq_Deal_Pushback_Territory](@Acq_Deal_Pushback_Code Int, @Country_Code Int, @Territory_Code Int, @Territory_Type Char(1))
As
Begin

	If(@Territory_Type = 'G')
		Delete From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Territory_Code, 0) = IsNull(@Territory_Code, 0)
	Else
		Delete From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Country_Code, 0) = IsNull(@Country_Code, 0)
End