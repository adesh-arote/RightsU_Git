CREATE PROCEDURE [dbo].[USP_Get_Syn_Deal_Supplementary_Edit](@Syn_Deal_Supplementary_Code INT, @Row_Num INT, @Tab_SM varchar(20))
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[[USP_Get_Syn_Deal_Supplementary_Edit]]', 'Step 1', 0, 'Started Procedure', 0, ''

		DECLARE @Tab_Code INT
		SELECT @Tab_Code = Supplementary_Tab_Code FROM Supplementary_Tab (NOLOCK) WHERE Short_Name = @Tab_SM

		SELECT Supplementary_Data_Code, User_Value, Row_Num, DSD.Supplementary_Config_Code, Supplementary_Code, DSD.Supplementary_Tab_Code, Control_Type, Is_Mandatory, Is_Multiselect, Max_Length, Control_Field_Order, View_Name, Whr_Criteria 
		FROM [dbo].[Syn_Deal_Supplementary] DS (NOLOCK)
		INNER JOIN [dbo].[Syn_Deal_Supplementary_detail] DSD (NOLOCK) ON DSD.Syn_Deal_Supplementary_Code = DS.Syn_Deal_Supplementary_Code
		INNER JOIN [dbo].[Supplementary_Config] SC (NOLOCK) ON SC.Supplementary_Config_Code = DSD.Supplementary_Config_Code
		WHERE DSD.Row_Num = @Row_Num and DS.Syn_Deal_Supplementary_Code = @Syn_Deal_Supplementary_Code and DSD.Supplementary_Tab_Code = @Tab_Code
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Syn_Deal_Supplementary_Edit]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End