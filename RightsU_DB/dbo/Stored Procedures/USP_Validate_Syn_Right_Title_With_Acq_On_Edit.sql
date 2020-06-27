-- =============================================
-- Author:		Rajesh	Godse
-- Create date: 5-Oct-2015
-- Description:	Syndication Right Titles With Acquisition
-- =============================================
alter PROCEDURE USP_Validate_Syn_Right_Title_With_Acq_On_Edit
	(
	@RCode int, 
	@TCode int, 
	@Episode_From int, 
	@Episode_To int
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF(@TCode > 0)
	BEGIN
		Select COUNT(*)
		from Acq_Deal AD
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		WHERE ADM.Title_Code = @TCode AND AD.Deal_Workflow_Status <> 'A' AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
	END
	ELSE
	BEGIN
		Select COUNT(*)
		from Acq_Deal AD
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		INNER JOIN Syn_Deal_Rights_Title SDRT ON ADM.Title_Code = SDRT.Title_Code
		WHERE SDRT.Syn_Deal_Rights_Code = @RCode AND AD.Deal_Workflow_Status <> 'A' AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
	END
   
END
