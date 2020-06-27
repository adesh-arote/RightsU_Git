-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [USP_List_Acq_PaymentTerms]
	@Acq_Deal_Code INT = 2046
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF

    SELECT adpt.Acq_Deal_Payment_Terms_Code, adpt.Acq_Deal_Code, adpt.Cost_Type_Code, adpt.Payment_Term_Code, adpt.Days_After, adpt.Percentage, Amount,
	adpt.Due_Date, pt.Payment_Terms, ct.Cost_Type_Name
	FROM Acq_Deal_Payment_Terms adpt
	INNER JOIN Payment_Terms pt ON pt.Payment_Terms_Code = adpt.Payment_Term_Code
	INNER JOIN Cost_Type ct ON ct.Cost_Type_Code = adpt.Cost_Type_Code
	WHERE adpt.Acq_Deal_Code = @Acq_Deal_Code
	ORDER by adpt.Acq_Deal_Payment_Terms_Code
END