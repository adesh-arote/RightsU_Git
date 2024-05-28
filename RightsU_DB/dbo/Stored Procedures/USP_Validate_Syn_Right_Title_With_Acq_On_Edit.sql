CREATE PROCEDURE [dbo].[USP_Validate_Syn_Right_Title_With_Acq_On_Edit]
	(
	@RCode int, 
	@TCode int, 
	@Episode_From int, 
	@Episode_To int
	)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Validate_Syn_Right_Title_With_Acq_On_Edit]', 'Step 1', 0, 'Started Procedure', 0, ''
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		IF(@TCode > 0)
		BEGIN
			Select COUNT(*)
			from Acq_Deal AD (NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
			WHERE ADM.Title_Code = @TCode AND AD.Deal_Workflow_Status <> 'A' AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
		END
		ELSE
		BEGIN
			Select COUNT(*)
			from Acq_Deal AD (NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
			INNER JOIN Syn_Deal_Rights_Title SDRT (NOLOCK) ON ADM.Title_Code = SDRT.Title_Code
			WHERE SDRT.Syn_Deal_Rights_Code = @RCode AND AD.Deal_Workflow_Status <> 'A' AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
		END   
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Validate_Syn_Right_Title_With_Acq_On_Edit]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
