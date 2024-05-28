CREATE PROCEDURE [dbo].[USP_DELETE_IPR_REP]
(
	@IPR_Rep_Code INT
)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create DATE: 31-October-2014
-- Description:	DELETE IPR Call From EF 
-- =============================================
BEGIN
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DELETE_IPR_REP]', 'Step 1', 0, 'Started Procedure', 0, ''
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

		DELETE FROM IPR_REP WHERE IPR_Rep_Code=@IPR_Rep_Code

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DELETE_IPR_REP]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
