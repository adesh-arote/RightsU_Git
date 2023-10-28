CREATE PROCEDURE [dbo].[USPAL_GetRuleCriteria]
@AL_Vendor_Rule_Code INT
AS
BEGIN
	SELECT DISTINCT ec.Columns_Code, ec.Columns_Name AS RuleCriteria 
	FROM AL_Vendor_Rule vr
	INNER JOIN AL_Vendor_Rule_Criteria vrc ON vrc.AL_Vendor_Rule_Code = vr.AL_Vendor_Rule_Code
	INNER JOIN Extended_Columns ec ON ec.Columns_Code = vrc.Columns_Code
	WHERE --vr.Vendor_Code = 2470 AND
	vr.AL_Vendor_Rule_Code = @AL_Vendor_Rule_Code
END