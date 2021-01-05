alter PROCEDURE [dbo].[USP_Populate_Master_Deal_Titles]
(
	@Acq_Deal_Movie_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 31-March-2015
-- Description:	Get Master Deal Titles for Acq Sub Deal
-- =============================================
BEGIN
	SET FMTONLY OFF
	
	SELECT ADM.Acq_Deal_Movie_Code,
		dbo.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To)
		+ ' - ' + AD.Agreement_No AS 'Title_Name_WithAgreement_No'
	FROM Acq_Deal AD
	INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
	WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  ISNULL(AD.Is_Master_Deal, '') = 'Y' AND (Deal_Workflow_Status = 'A' OR ADM.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code )
	ORDER BY T.Title_Name
END