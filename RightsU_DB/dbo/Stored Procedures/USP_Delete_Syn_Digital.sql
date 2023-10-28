
CREATE PROCEDURE [dbo].[USP_Delete_Syn_Digital](@Digital_Code INT)
AS
BEGIN
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Syn_Digital]', 'Step 1', 0, 'Started Procedure', 0, ''
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

		DELETE FROM [dbo].[Syn_Deal_Digital_detail] WHERE Syn_Deal_Digital_Code = @Digital_Code
		DELETE FROM [dbo].[Syn_Deal_Digital] WHERE Syn_Deal_Digital_Code = @Digital_Code

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Syn_Digital]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END