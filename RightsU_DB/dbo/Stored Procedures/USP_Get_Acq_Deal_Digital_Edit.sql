CREATE Procedure [dbo].[USP_Get_Acq_Deal_Digital_Edit](@Acq_Deal_Digital_Code int, @Row_Num int, @Tab_SM varchar(20))
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Acq_Deal_Digital_Edit]', 'Step 1', 0, 'Started Procedure', 0, ''

		Declare @tab_code int
		select @tab_code = Digital_tab_code from Digital_Tab (NOLOCK) where Short_Name=@Tab_SM

		select Digital_Data_Code, User_Value, Row_Num, DSD.Digital_Config_Code, Digital_Code, 
		DSD.Digital_Tab_Code, Control_Type, Is_Mandatory, Is_Multiselect, Max_Length, Control_Field_Order, View_Name, Whr_Criteria 
		from [dbo].[Acq_Deal_Digital] DS (NOLOCK)
		inner Join [dbo].[Acq_Deal_Digital_detail] DSD (NOLOCK) on DSD.Acq_Deal_Digital_Code = DS.Acq_Deal_Digital_Code
		inner join [dbo].[Digital_Config] SC (NOLOCK) on SC.Digital_Config_Code = DSD.Digital_Config_Code
		where DSD.Row_Num = @Row_Num and DS.Acq_Deal_Digital_Code = @Acq_Deal_Digital_Code and DSD.Digital_Tab_Code = @Tab_code	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Acq_Deal_Digital_Edit]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End