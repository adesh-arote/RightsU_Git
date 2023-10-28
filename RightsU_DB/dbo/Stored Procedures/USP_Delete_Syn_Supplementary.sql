CREATE PROCEDURE [dbo].[USP_Delete_Syn_Supplementary](@Supplementary_Code INT)
AS
BEGIN
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Syn_Supplementary]', 'Step 1', 0, 'Started Procedure', 0, ''
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

		DELETE FROM [dbo].[Syn_Deal_Supplementary_detail] WHERE Syn_Deal_Supplementary_Code = @Supplementary_Code
		DELETE FROM [dbo].[Syn_Deal_Supplementary] WHERE Syn_Deal_Supplementary_Code = @Supplementary_Code

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Syn_Supplementary]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END