






CREATE VIEW [dbo].[TitlePlatform]
AS
SELECT DISTINCT adrp.Platform_Code, adrp.Acq_Deal_Rights_Code, adrt.Title_Code
FROM RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Platform adrp
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr ON adrp.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code AND ISNULL(adr.Right_Type, '') <> '' AND ISNULL(Is_Tentative, 'N') = 'N'
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
