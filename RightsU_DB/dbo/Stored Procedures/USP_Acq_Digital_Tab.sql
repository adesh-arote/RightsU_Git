CREATE Procedure [dbo].[USP_Acq_Digital_Tab](@Digital_Tab_Code INT)
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Digital_Tab]', 'Step 1', 0, 'Started Procedure', 0, ''

		select Digital_name, Control_Type,Is_Mandatory,Is_Multiselect,Max_Length,Page_Control_Order,Control_Field_Order,Digital_Config_Code, 
		sc.View_Name,Text_Field, Value_Field, Whr_Criteria from Digital_config sc (NOLOCK)
		inner join Digital_Tab st (NOLOCK) on st.Digital_Tab_Code = sc.Digital_Tab_Code
		inner join Digital s (NOLOCK) on s.Digital_Code = sc.Digital_Code
		where sc.Digital_Tab_Code = @Digital_Tab_Code and Is_Active='Y'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Digital_Tab]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End