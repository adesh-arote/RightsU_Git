


CREATE VIEW [dbo].[TitleNonSaleableAncillary]  
AS
SELECT DISTINCT adrt.Title_Code, adr.Acq_Deal_Code, adrt.Episode_From, adrt.Episode_To, adra.Ancillary_Code, an.Ancillary_Name, ac.Label_Name,  
(CASE WHEN Label_Name <> '' THEN Label_Name + ' - ' ELSE '' END) + 
CASE  
	WHEN Control_Type = 'SDED' 
	THEN UPPER(REPLACE(CONVERT(VARCHAR(20), StartDate, 106), ' ', '-')  + ' TO ' + REPLACE(CONVERT(VARCHAR(20), EndDate, 106), ' ', '-')) 
	ELSE Values1 
END Config_Value  
FROM RightsU_16Mar.dbo.Acq_Deal_Rights_Ancillary adra  
INNER JOIN RightsU_16Mar.dbo.Ancillary an ON adra.Ancillary_Code = an.Ancillary_Code  
INNER JOIN RightsU_16Mar.dbo.Ancillary_Config ac ON ac.Ancillary_Config_Code = adra.Ancillary_Config_Code  
INNER JOIN RightsU_16Mar.dbo.Acq_Deal_Rights_Title adrt ON adra.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code  
INNER JOIN RightsU_16Mar.dbo.Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code


