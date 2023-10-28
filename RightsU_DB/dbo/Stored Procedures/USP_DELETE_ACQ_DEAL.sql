CREATE PROCEDURE [dbo].[USP_DELETE_ACQ_DEAL]
(
	@Acq_Deal_Code INT
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 08-October-2014
-- Description:	DELETE Acq Deal Call From EF Table Mapping
-- =============================================
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DELETE_ACQ_DEAL]', 'Step 1', 0, 'Started Procedure', 0, ''
		DELETE FROM Acq_Deal WHERE Acq_Deal_Code=@Acq_Deal_Code
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_DELETE_ACQ_DEAL]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
