-- =============================================
-- Author:		Rajesh Godse
-- Create date: 28 Feb 2015
-- Description:	Checking acquisition deal status for syndication deal editing and amendment
-- =============================================
ALTER PROCEDURE [dbo].[USP_Check_Acq_Deal_Status_For_Syn]
	@Syn_Deal_Code INT
AS
BEGIN

	Select COUNT(*) from Acq_Deal AD
	Inner Join Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	Where AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADM.Title_Code in (Select Title_Code from Syn_Deal_Movie Where Syn_Deal_Code = @Syn_Deal_Code)
	and AD.Deal_Workflow_Status <> 'A'


END