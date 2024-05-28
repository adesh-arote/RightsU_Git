CREATE Proc [dbo].[USP_Insert_Acq_Deal_Pushback_Territory](@Acq_Deal_Pushback_Code Int, @Territory_Type Char(1), @Country_Code Int, @Territory_Code Int)
As
Begin
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Acq_Deal_Pushback_Territory]', 'Step 1', 0, 'Started Procedure', 0, ''
		If(@Territory_Type = 'G')
		Begin
			Delete From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Territory_Code, 0) = IsNull(@Territory_Code, 0)

			Insert InTo Acq_Deal_Pushback_Territory(Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code)
			Select @Acq_Deal_Pushback_Code, @Territory_Type, Null, @Territory_Code
			--From Territory_Details 
			--Where Territory_Code = @Territory_Code And Country_Code In (Select Country_Code From Country Where Is_Active = 'Y')
		End
		Else
		Begin
			Delete From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code And IsNull(Country_Code, 0) = IsNull(@Country_Code, 0)
			Insert InTo Acq_Deal_Pushback_Territory(Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code)
			Select @Acq_Deal_Pushback_Code, @Territory_Type, @Country_Code, Null 
		End

		SELECT SCOPE_IDENTITY() AS Acq_Deal_Pushback_Territory_Code
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Acq_Deal_Pushback_Territory]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End
