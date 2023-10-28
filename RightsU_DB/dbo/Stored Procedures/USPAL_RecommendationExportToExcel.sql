CREATE PROCEDURE USPAL_RecommendationExportToExcel
AS
BEGIN
	
	SELECT DISTINCT alrc.AL_Recommendation_Code, t.Title_Name	
	FROM AL_Proposal alp
	INNER JOIN AL_Recommendation  alr ON alp.AL_Proposal_Code = alr.AL_Proposal_Code
	INNER JOIN AL_Recommendation_Content alrc ON alrc.AL_Recommendation_Code = alrc.AL_Recommendation_Code
	INNER JOIN Title t ON t.Title_Code = alrc.Title_Code
	WHERE alrc.AL_Recommendation_Code = 1450

END