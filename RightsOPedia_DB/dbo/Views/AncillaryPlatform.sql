


CREATE VIEW [dbo].[AncillaryPlatform]
AS
SELECT DISTINCT adr.Acq_Deal_Rights_Code, adrp.Platform_Code, p.Platform_Name FROM RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Platform adrp 
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
INNER JOIN RightsU_Plus_Testing.dbo.Platform p ON p.Platform_Code = adrp.Platform_Code
WHERE p.Platform_Name IN ('Promotional Clip Rights', 'Merchandising Rights', 'Right to use Images and Artworks', 'Advertising and Sponsorship Rights')


