

CREATE PROCEDURE [dbo].[USP_Get_Digital_Config](@Digital_Tab_Code INT)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Digital_Config]', 'Step 1', 0, 'Started Procedure', 0, ''

		SELECT Digital_Name, Control_Type, Is_Mandatory, Is_Multiselect, Max_Length, Page_Control_Order, Control_Field_Order, Digital_Config_Code, dc.View_Name, Text_Field, Value_Field, Whr_Criteria,Default_Values 
		FROM Digital_Config dc (NOLOCK)
		INNER JOIN Digital_Tab dt (NOLOCK) ON dt.Digital_Tab_Code = dc.Digital_Tab_Code
		INNER JOIN Digital d (NOLOCK) ON d.Digital_Code = dc.Digital_Code
		WHERE dc.Digital_Tab_Code = @Digital_Tab_Code and Is_Active = 'Y'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Digital_Config]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END