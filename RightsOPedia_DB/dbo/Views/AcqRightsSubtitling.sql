


CREATE VIEW [dbo].[AcqRightsSubtitling]
AS
SELECT DISTINCT adrs.Language_Group_Code, adrs.Language_Code, adrs.Language_Type, adr1.Acq_Deal_Rights_Code
FROM RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr1
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Subtitling adrs ON adrs.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'





