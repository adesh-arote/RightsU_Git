




CREATE VIEW [dbo].[TitleSubtitling]
AS

SELECT DISTINCT a.Title_Code, CASE WHEN a.Language_Type = 'G' THEN lgd.Language_Code ELSE a.Language_Code END AS Language_Code, a.Language_Group_Code, a.Language_Type
FROM (
	SELECT DISTINCT adrs.Language_Group_Code, adrs.Language_Code, adrs.Language_Type, adr1.Acq_Deal_Rights_Code, adrt.Title_Code
	FROM RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr1
	INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code
	INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Subtitling adrs ON adrs.Acq_Deal_Rights_Code = adr1.Acq_Deal_Rights_Code AND ISNULL(adr1.Right_Type, '') <> '' AND ISNULL(adr1.Is_Tentative, 'N') = 'N'
) AS a 
LEFT JOIN RightsU_Plus_Testing.dbo.Language_Group_Details lgd ON a.Language_Group_Code = lgd.Language_Group_Code





