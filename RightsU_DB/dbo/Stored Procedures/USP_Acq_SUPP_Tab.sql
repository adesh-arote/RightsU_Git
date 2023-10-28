CREATE Procedure [dbo].[USP_Acq_SUPP_Tab](@Supplementary_Tab_Code INT)
As
Begin
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_SUPP_Tab]', 'Step 1', 0, 'Started Procedure', 0, ''

	select supplementary_name, Control_Type,Is_Mandatory,Is_Multiselect,Max_Length,Page_Control_Order,Control_Field_Order,Supplementary_Config_Code, 
	sc.View_Name,Text_Field, Value_Field, Whr_Criteria from supplementary_config sc
	inner join Supplementary_Tab st on st.Supplementary_Tab_Code = sc.Supplementary_Tab_Code
	inner join supplementary s on s.Supplementary_Code = sc.Supplementary_Code
	where sc.Supplementary_Tab_Code = @Supplementary_Tab_Code and Is_Active='Y'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_SUPP_Tab]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End