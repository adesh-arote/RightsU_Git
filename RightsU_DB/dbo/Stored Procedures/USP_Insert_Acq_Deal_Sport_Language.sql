
CREATE Proc [dbo].[USP_Insert_Acq_Deal_Sport_Language](@Acq_Deal_Sport_Code Int, @Language_Type Char(1), @Language_Code Int, @Language_Group_Code Int, @Flag Char(1))
As
Begin

	If(@Language_Type = 'G')
	Begin
		Delete From Acq_Deal_Sport_Language Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code And IsNull(Language_Group_Code, 0) = IsNull(@Language_Group_Code, 0)

		Insert InTo Acq_Deal_Sport_Language(Acq_Deal_Sport_Code, Language_Type, Language_Code, Language_Group_Code, Flag)
		Select @Acq_Deal_Sport_Code, @Language_Type, NULL, @Language_Group_Code, @Flag 
		--From Language_Group_Details
		--Where Language_Group_Code = @Language_Group_Code And Language_Code In (Select Language_Code From [Language] Where Is_Active = 'Y')
	End
	Else
	Begin
		Delete From Acq_Deal_Sport_Language Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code And IsNull(Language_Code, 0) = IsNull(@Language_Code, 0)
		Insert InTo Acq_Deal_Sport_Language(Acq_Deal_Sport_Code, Language_Type, Language_Code, Language_Group_Code, Flag)
		Select @Acq_Deal_Sport_Code, @Language_Type, @Language_Code, Null, @Flag
	End

	SELECT SCOPE_IDENTITY() AS Acq_Deal_Sport_Language_Code
End