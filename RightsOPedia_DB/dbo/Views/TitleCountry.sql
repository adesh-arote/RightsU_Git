




CREATE VIEW [dbo].[TitleCountry]
AS



SELECT DISTINCT a.Title_Code, CASE WHEN a.Territory_Type = 'G' THEN td.Country_Code ELSE a.Country_Code END AS Country_Code, a.Territory_Code, a.Territory_Type
FROM (
	SELECT DISTINCT Territory_Code, Country_Code, Territory_Type, adrc.Acq_Deal_Rights_Code, adrt.Title_Code
	FROM RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr1
	INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code
	INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Territory adrc ON adrc.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
) AS a
LEFT JOIN RightsU_Plus_Testing.dbo.Territory_Details td ON a.Territory_Code = td.Territory_Code





