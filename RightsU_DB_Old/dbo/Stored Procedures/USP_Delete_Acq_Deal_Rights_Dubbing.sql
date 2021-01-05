Create Proc [dbo].[USP_Delete_Acq_Deal_Rights_Dubbing](@Acq_Deal_Rights_Code Int, @Language_Code Int, @Language_Group_Code Int, @Language_Type Char(1))
As
Begin

	If(@Language_Type = 'G')
		Delete From Acq_Deal_Rights_Dubbing Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code And IsNull(Language_Group_Code, 0) = IsNull(@Language_Group_Code, 0)
	Else
		Delete From Acq_Deal_Rights_Dubbing Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code And IsNull(Language_Code, 0) = IsNull(@Language_Code, 0)
End