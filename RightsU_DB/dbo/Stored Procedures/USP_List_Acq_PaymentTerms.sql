CREATE PROCEDURE [dbo].[USP_List_Acq_PaymentTerms]
	@Acq_Deal_Code INT 
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_PaymentTerms]', 'Step 1', 0, 'Started Procedure', 0, ''

	--DECLARE 
	--@Acq_Deal_Code INT = 14587
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SET FMTONLY OFF

		SELECT adpt.Acq_Deal_Payment_Terms_Code, adpt.Acq_Deal_Code, adpt.Cost_Type_Code, adpt.Payment_Term_Code, adpt.Days_After, adpt.Percentage, adpt.Amount,
		adpt.Due_Date, pt.Payment_Terms, ct.Cost_Type_Name
		FROM Acq_Deal_Payment_Terms adpt (NOLOCK)
		INNER JOIN Payment_Terms pt (NOLOCK) ON pt.Payment_Terms_Code =  adpt.Payment_Term_Code
		INNER JOIN Cost_Type ct (NOLOCK) ON ct.Cost_Type_Code = adpt.Cost_Type_Code
		WHERE adpt.Acq_Deal_Code = @Acq_Deal_Code 
		ORDER by adpt.Acq_Deal_Payment_Terms_Code
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_PaymentTerms]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
