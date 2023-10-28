CREATE Proc [dbo].[USP_Delete_Acq_Deal_Pushback_Subtitling](@Acq_Deal_Pushback_Code Int, @Language_Code Int, @Language_Group_Code Int, @Language_Type Char(1))
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Deal_Pushback_Subtitling]', 'Step 1', 0, 'Started Procedure', 0, ''
		
		If(@Language_Type = 'G')
			Delete From Acq_Deal_Pushback_Subtitling Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Language_Group_Code, 0) = IsNull(@Language_Group_Code, 0)
		Else
			Delete From Acq_Deal_Pushback_Subtitling Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Language_Code, 0) = IsNull(@Language_Code, 0)

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Deal_Pushback_Subtitling]', 'Step 2', 0, 'Procedure Excution Completetd', 0, ''
End

