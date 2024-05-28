CREATE Proc [dbo].[USP_Delete_Acq_Deal_Rights_Territory](@Acq_Deal_Rights_Code Int, @Country_Code Int, @Territory_Code Int, @Territory_Type Char(1))
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Deal_Rights_Territory]', 'Step 1', 0, 'Started Procedure', 0, ''
		
		If(@Territory_Type = 'G')
			Delete From Acq_Deal_Rights_Territory Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code And IsNull(Territory_Code, 0) = IsNull(@Territory_Code, 0)
		Else
			Delete From Acq_Deal_Rights_Territory Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code And IsNull(Country_Code, 0) = IsNull(@Country_Code, 0)

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Deal_Rights_Territory]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End