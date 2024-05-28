






CREATE VIEW [dbo].[TitleSynTerritory]
AS
SELECT DISTINCT Territory_Code, Country_Code, Territory_Type, adrc.Syn_Deal_Rights_Code
FROM RightsU_Plus_Testing.dbo.Syn_Deal_Rights_Territory adrc
INNER JOIN RightsU_Plus_Testing.dbo.Syn_Deal_Rights adr1 ON adrc.Syn_Deal_Rights_Code = adr1.Syn_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'





