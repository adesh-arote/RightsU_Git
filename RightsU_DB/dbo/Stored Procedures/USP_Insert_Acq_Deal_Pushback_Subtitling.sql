
CREATE Proc [dbo].[USP_Insert_Acq_Deal_Pushback_Subtitling](@Acq_Deal_Pushback_Code Int, @Language_Type Char(1), @Language_Code Int, @Language_Group_Code Int)
As
Begin

	If(@Language_Type = 'G')
	Begin
		Delete From Acq_Deal_Pushback_Subtitling Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Language_Group_Code, 0) = IsNull(@Language_Group_Code, 0)

		Insert InTo Acq_Deal_Pushback_Subtitling(Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code)
		Select @Acq_Deal_Pushback_Code, @Language_Type, Null, @Language_Group_Code 
		--From Language_Group_Details
		--Where Language_Group_Code = @Language_Group_Code And Language_Code In (Select Language_Code From [Language] Where Is_Active = 'Y')
	End
	Else
	Begin
		Delete From Acq_Deal_Pushback_Subtitling Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Language_Code, 0) = IsNull(@Language_Code, 0)
		Insert InTo Acq_Deal_Pushback_Subtitling(Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code)
		Select @Acq_Deal_Pushback_Code, @Language_Type, @Language_Code, Null 
	End

	SELECT SCOPE_IDENTITY() AS Acq_Deal_Pushback_Subtitling_Code
End
