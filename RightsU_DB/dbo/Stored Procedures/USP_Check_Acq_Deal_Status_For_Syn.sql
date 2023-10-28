CREATE PROCEDURE [dbo].[USP_Check_Acq_Deal_Status_For_Syn]
	@Syn_Deal_Code INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Acq_Deal_Status_For_Syn]', 'Step 1', 0, 'Started Procedure', 0, ''
		Select COUNT(*) from Acq_Deal AD (NOLOCK)
		Inner Join Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		Where AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADM.Title_Code in (Select Title_Code from Syn_Deal_Movie (NOLOCK) Where Syn_Deal_Code = @Syn_Deal_Code)
		and AD.Deal_Workflow_Status <> 'A'

	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Acq_Deal_Status_For_Syn]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END