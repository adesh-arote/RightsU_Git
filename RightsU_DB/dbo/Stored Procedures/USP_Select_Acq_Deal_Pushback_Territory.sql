CREATE Proc [dbo].[USP_Select_Acq_Deal_Pushback_Territory](@Acq_Deal_Pushback_Code Int)
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Select_Acq_Deal_Pushback_Territory]', 'Step 1', 0, 'Started Procedure', 0, ''
		Set FMTONLY OFF
	
		Select Distinct Acq_Deal_Pushback_Territory_Code, Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code
		From Acq_Deal_Pushback_Territory (NOLOCK) Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code

		--Create Table #Temp(
		--	Acq_Deal_Pushback_Territory_Code Int,
		--	Acq_Deal_Pushback_Code Int,
		--	Territory_Type Char(1),
		--	Country_Code Int,
		--	Territory_Code Int
		--)


		--If((Select Top 1 Territory_Type From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code) = 'G')
		--Begin
		--	Insert InTo #Temp(Acq_Deal_Pushback_Territory_Code, Acq_Deal_Pushback_Code, Territory_Type, Territory_Code, Country_Code)
		--	Select Max(Acq_Deal_Pushback_Territory_Code) Acq_Deal_Pushback_Territory_Code, Acq_Deal_Pushback_Code, Territory_Type, Territory_Code, Null
		--	From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code
		--	Group By Acq_Deal_Pushback_Code, Territory_Type, Territory_Code
		--End
		--Else
		--Begin
		--	Insert InTo #Temp(Acq_Deal_Pushback_Territory_Code, Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code)
		--	Select Distinct Acq_Deal_Pushback_Territory_Code, Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Null
		--	From Acq_Deal_Pushback_Territory Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code
		--End

		--Select * From #temp 
		--Drop Table #temp

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Select_Acq_Deal_Pushback_Territory]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
End