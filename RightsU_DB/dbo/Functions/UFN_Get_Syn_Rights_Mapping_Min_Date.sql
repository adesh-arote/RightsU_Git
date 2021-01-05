
-- =============================================
-- Author:		Rajesh Godse
-- Create date: 13 Oct 2015
-- Description:	 Get Syndication minimum start date based on Acq deal code and Syn rights code
-- =============================================
CREATE FUNCTION [dbo].[UFN_Get_Syn_Rights_Mapping_Min_Date] 
(
	@ACQ_DEAL_CODE INT,
	@ACQ_DEAL_RIGHTS_CODE INT
)
RETURNS DATETIME
AS
BEGIN

	DECLARE @TOTALCOUNT INT = 0
	Declare @MinStartDate Datetime
	Select @MinStartDate = MIN(SDR.Right_Start_Date)
	FROM Syn_Deal_Rights SDR
	Where Syn_Deal_RIghts_Code in
	(
		SELECT distinct Syn_Deal_Rights_Code
		FROM Syn_Acq_Mapping 
		WHERE Deal_Code = @ACQ_DEAL_CODE AND Deal_Rights_Code = @ACQ_DEAL_RIGHTS_CODE
	)

	RETURN @MinStartDate

END
