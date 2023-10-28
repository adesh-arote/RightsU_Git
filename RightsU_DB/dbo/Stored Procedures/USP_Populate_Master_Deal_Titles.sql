CREATE PROCEDURE [dbo].[USP_Populate_Master_Deal_Titles]
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
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel <2)Exec [USPLogSQLSteps] '[USP_Populate_Master_Deal_Titles]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET FMTONLY OFF
	
		SELECT ADM.Acq_Deal_Movie_Code,
			dbo.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To)
			+ ' - ' + AD.Agreement_No AS 'Title_Name_WithAgreement_No'
		FROM Acq_Deal AD (NOLOCK)
		INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		INNER JOIN Title T (NOLOCK) ON ADM.Title_Code = T.Title_Code
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  ISNULL(AD.Is_Master_Deal, '') = 'Y' AND (Deal_Workflow_Status = 'A' OR ADM.Acq_Deal_Movie_Code = @Acq_Deal_Movie_Code )
		ORDER BY T.Title_Name
	 
	if(@Loglevel <2)Exec [USPLogSQLSteps] '[USP_Populate_Master_Deal_Titles]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END