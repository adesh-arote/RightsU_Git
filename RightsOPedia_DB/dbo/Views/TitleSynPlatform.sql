




CREATE VIEW [dbo].[TitleSynPlatform]
AS
SELECT DISTINCT adrp.Platform_Code, adrp.Syn_Deal_Rights_Code
FROM RightsU_Plus_Testing.dbo.Syn_Deal_Rights_Platform adrp
INNER JOIN RightsU_Plus_Testing.dbo.Syn_Deal_Rights adr ON adrp.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code AND ISNULL(adr.Right_Type, '') <> '' AND ISNULL(Is_Tentative, 'N') = 'N'





