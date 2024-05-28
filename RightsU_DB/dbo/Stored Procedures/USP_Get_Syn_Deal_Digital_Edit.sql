

CREATE PROCEDURE [dbo].[USP_Get_Syn_Deal_Digital_Edit](@Syn_Deal_Digital_Code INT, @Row_Num INT, @Tab_SM varchar(20))
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[[USP_Get_Syn_Deal_Digital_Edit]]', 'Step 1', 0, 'Started Procedure', 0, ''

		DECLARE @Tab_Code INT
		SELECT @Tab_Code = Digital_Tab_Code FROM Digital_Tab (NOLOCK) WHERE Short_Name = @Tab_SM

		SELECT Digital_Data_Code, User_Value, Row_Num, DSD.Digital_Config_Code, Digital_Code, DSD.Digital_Tab_Code, Control_Type, Is_Mandatory, Is_Multiselect, Max_Length, Control_Field_Order, View_Name, Whr_Criteria,Default_Values 
		FROM [dbo].[Syn_Deal_Digital] DS (NOLOCK)
		INNER JOIN [dbo].[Syn_Deal_Digital_detail] DSD (NOLOCK) ON DSD.Syn_Deal_Digital_Code = DS.Syn_Deal_Digital_Code
		INNER JOIN [dbo].[Digital_Config] SC (NOLOCK) ON SC.Digital_Config_Code = DSD.Digital_Config_Code
		WHERE DSD.Row_Num = @Row_Num and DS.Syn_Deal_Digital_Code = @Syn_Deal_Digital_Code and DSD.Digital_Tab_Code = @Tab_Code
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Syn_Deal_Digital_Edit]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End