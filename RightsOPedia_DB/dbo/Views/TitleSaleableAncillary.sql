



CREATE VIEW [dbo].[TitleSaleableAncillary]
AS
SELECT DISTINCT adrt.Title_Code, adr.Acq_Deal_Code, adrt.Episode_From, adrt.Episode_To, adra.Platform_Code, p.Platform_Hiearachy, 
CASE WHEN Config_Details = 'SDED' THEN 'Period' ELSE Config_Details END Config_Details, 
CASE WHEN Config_Details = 'SDED' THEN UPPER(REPLACE(CONVERT(VARCHAR(20), StartDate, 106), ' ', '-')  + ' TO ' + REPLACE(CONVERT(VARCHAR(20), EndDate, 106), ' ', '-')) ELSE Values1 END Config_Value
FROM RightsU_16Mar.dbo.Acq_Deal_Rights_Ancillary adra
INNER JOIN RightsU_16Mar.dbo.Platform p ON adra.Platform_Code = p.Platform_Code
INNER JOIN RightsU_16Mar.dbo.Platform_Config pc ON pc.Platform_Config_Code = adra.Config_Code
INNER JOIN RightsU_16Mar.dbo.Acq_Deal_Rights_Title adrt ON adra.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
INNER JOIN RightsU_16Mar.dbo.Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code




