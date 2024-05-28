CREATE PROCEDURE [dbo].[USPAL_GetRecommendationTitleDetails]
@AL_Recommendation_Code INT
AS
BEGIN
	--SELECT DISTINCT alrc.AL_Recommendation_Code, alrc.AL_Vendor_Rule_Code, alrc.Title_Code, V.Vendor_Name, 
	--	CASE WHEN DATENAME(MONTH, ar.Start_Date) = DATENAME(MONTH, ar.End_Date) 
	--			THEN DATENAME(MONTH, ar.Start_Date) + ' ' + DATENAME(YEAR, ar.Start_Date)
	--		ELSE CONCAT(DATENAME(MONTH, ar.Start_Date), ' - ', DATENAME(MONTH, ar.End_Date)) + ' ' + DATENAME(YEAR, ar.Start_Date)
	--	END AS Cycle
	--	FROM AL_Recommendation_Content alrc
	--	INNER JOIN AL_Recommendation  ar ON ar.AL_Recommendation_Code = alrc.AL_Recommendation_Code
	--	INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = ar.AL_Proposal_Code
	--	INNER JOIN Vendor v ON v.Vendor_Code = ap.Vendor_Code
	--	WHERE alrc.AL_Recommendation_Code = @AL_Recommendation_Code

	SELECT AL_Recommendation_Code, AL_Vendor_Rule_Code, Title_Code, Vendor_Name, Cycle FROM
	(SELECT DISTINCT alrc.AL_Recommendation_Code, alrc.AL_Vendor_Rule_Code, alrc.Title_Code, V.Vendor_Name, 
		CASE WHEN DATENAME(MONTH, ar.Start_Date) = DATENAME(MONTH, ar.End_Date) 
				THEN DATENAME(MONTH, ar.Start_Date) + ' ' + DATENAME(YEAR, ar.Start_Date)
			ELSE CONCAT(DATENAME(MONTH, ar.Start_Date), ' - ', DATENAME(MONTH, ar.End_Date)) + ' ' + DATENAME(YEAR, ar.Start_Date)
		END AS Cycle, alrc.AL_Recommendation_Content_Code
		FROM AL_Recommendation_Content alrc
		INNER JOIN AL_Recommendation  ar ON ar.AL_Recommendation_Code = alrc.AL_Recommendation_Code
		INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = ar.AL_Proposal_Code
		INNER JOIN Vendor v ON v.Vendor_Code = ap.Vendor_Code
		WHERE alrc.AL_Recommendation_Code = @AL_Recommendation_Code) AS T ORDER BY T.AL_Vendor_Rule_Code, T.AL_Recommendation_Content_Code
END