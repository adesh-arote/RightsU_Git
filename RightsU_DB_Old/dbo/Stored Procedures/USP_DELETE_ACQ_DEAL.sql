
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
	DELETE FROM Acq_Deal WHERE Acq_Deal_Code=@Acq_Deal_Code
END