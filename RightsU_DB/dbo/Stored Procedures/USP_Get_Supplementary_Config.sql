CREATE PROCEDURE [dbo].[USP_Get_Supplementary_Config](@Supplementary_Tab_Code INT)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Supplementary_Config]', 'Step 1', 0, 'Started Procedure', 0, ''

		SELECT Supplementary_Name, Control_Type, Is_Mandatory, Is_Multiselect, Max_Length, Page_Control_Order, Control_Field_Order, Supplementary_Config_Code, sc.View_Name, Text_Field, Value_Field, Whr_Criteria 
		FROM Supplementary_Config sc (NOLOCK)
		INNER JOIN Supplementary_Tab st (NOLOCK) ON st.Supplementary_Tab_Code = sc.Supplementary_Tab_Code
		INNER JOIN Supplementary s (NOLOCK) ON s.Supplementary_Code = sc.Supplementary_Code
		WHERE sc.Supplementary_Tab_Code = @Supplementary_Tab_Code and Is_Active = 'Y'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Supplementary_Config]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END