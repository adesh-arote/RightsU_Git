CREATE Proc [dbo].[USP_Select_Acq_Deal_Sport_Language](@Acq_Deal_Sport_Code Int)
As
Begin
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Select_Acq_Deal_Sport_Language]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		Set FMTONLY OFF
	
		Create Table #Temp(
			Acq_Deal_Sport_Language_Code Int,
			Acq_Deal_Sport_Code Int,
			Language_Type Char(1),
			Language_Code Int,
			Language_Group_Code Int,
			Flag Char(1)
		)


		If((Select Top 1 Language_Type From Acq_Deal_Sport_Language (NOLOCK)  Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code) = 'G')
		Begin
			Insert InTo #Temp(Acq_Deal_Sport_Language_Code, Acq_Deal_Sport_Code, Language_Type, Language_Group_Code, Language_Code, Flag)
			Select Max(Acq_Deal_Sport_Language_Code) Acq_Deal_Sport_Language_Code, Acq_Deal_Sport_Code, Language_Type, Language_Group_Code, Null, Flag
			From Acq_Deal_Sport_Language (NOLOCK)  Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
			Group By Acq_Deal_Sport_Code, Language_Type, Language_Group_Code, Flag
		End
		Else
		Begin
			Insert InTo #Temp(Acq_Deal_Sport_Language_Code, Acq_Deal_Sport_Code, Language_Type, Language_Code, Language_Group_Code, Flag)
			Select Distinct Acq_Deal_Sport_Language_Code, Acq_Deal_Sport_Code, Language_Type, Language_Code, Null, Flag
			From Acq_Deal_Sport_Language (NOLOCK)  Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
		End

		Select * From #temp 
		--Drop Table #temp

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Select_Acq_Deal_Sport_Language]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
End