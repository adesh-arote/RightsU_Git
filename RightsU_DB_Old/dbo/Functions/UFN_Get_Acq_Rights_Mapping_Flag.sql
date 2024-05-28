
-- =============================================
-- Author:		Rajesh Godse
-- Create date: 13 Oct 2015
-- Description:	 Get count of mapped right based on deal code and rights code
-- =============================================
CREATE FUNCTION [dbo].[UFN_Get_Acq_Rights_Mapping_Flag] 
(
	@ACQ_DEAL_CODE INT,
	@ACQ_DEAL_RIGHTS_CODE INT
)
RETURNS INT
AS
BEGIN

	DECLARE @TOTALCOUNT INT = 0

	SELECT @TOTALCOUNT = COUNT(Deal_Code)
	FROM Syn_Acq_Mapping 
	WHERE Deal_Code = @ACQ_DEAL_CODE AND Deal_Rights_Code = @ACQ_DEAL_RIGHTS_CODE

	IF(@TOTALCOUNT <> 0)
	 RETURN 'Y'

	RETURN 'N'

END




