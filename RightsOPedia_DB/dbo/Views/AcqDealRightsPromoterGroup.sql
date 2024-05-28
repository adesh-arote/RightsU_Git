


CREATE VIEW [dbo].[AcqDealRightsPromoterGroup]
AS
SELECT adr.Acq_Deal_Rights_Code, adrpg.Promoter_Group_Code, pg.Promoter_Group_Name
FROM RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Promoter adrp ON adrp.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Promoter_Group adrpg ON adrpg.Acq_Deal_Rights_Promoter_Code = adrp.Acq_Deal_Rights_Promoter_Code
INNER JOIN RightsU_Plus_Testing.dbo.Promoter_Group pg ON pg.Promoter_Group_Code = adrpg.Promoter_Group_Code
WHERE pg.Promoter_Group_Name IN ('Jio','Voot')





