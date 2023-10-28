CREATE PROCEDURE [dbo].[USPAL_GetContentCountForRecommendation]
@AL_Recommendation_Code INT,
@IsNewCycle CHAR(1)
AS
BEGIN
	IF(@IsNewCycle = 'N')
	BEGIN
		SELECT alrc.AL_Vendor_Rule_Code, 1 AS isContentPresent, COUNT(alrc.Title_Code) AS Title_Count
		from AL_Recommendation alr
		INNER JOIN AL_Recommendation_Content alrc ON alr.AL_Recommendation_Code = alrc.AL_Recommendation_Code
		--INNER JOIN AL_Proposal_Rule alpr ON alpr.AL_Proposal_Code = alr.AL_Proposal_Code
		WHERE alr.AL_Recommendation_Code = @AL_Recommendation_Code
		GROUP BY alrc.AL_Vendor_Rule_Code
	END
	ELSE
	BEGIN
		IF((Select Refresh_Cycle_No from AL_Recommendation where AL_Recommendation_Code = @AL_Recommendation_Code) > 1)
		BEGIN
			SELECT alrc.AL_Vendor_Rule_Code, 1 AS isContentPresent, COUNT(alrc.Title_Code) AS Title_Count
			from AL_Recommendation alr
			INNER JOIN AL_Recommendation_Content alrc ON alr.AL_Recommendation_Code = alrc.AL_Recommendation_Code
			--INNER JOIN AL_Proposal_Rule alpr ON alpr.AL_Proposal_Code = alr.AL_Proposal_Code
			WHERE alr.AL_Recommendation_Code = @AL_Recommendation_Code
			AND  alrc.Content_Status <> 'D'
			GROUP BY alrc.AL_Vendor_Rule_Code
		END
		ELSE
		BEGIN
			SELECT alrc.AL_Vendor_Rule_Code, 1 AS isContentPresent, COUNT(alrc.Title_Code) AS Title_Count
			from AL_Recommendation alr
			INNER JOIN AL_Recommendation_Content alrc ON alr.AL_Recommendation_Code = alrc.AL_Recommendation_Code
			--INNER JOIN AL_Proposal_Rule alpr ON alpr.AL_Proposal_Code = alr.AL_Proposal_Code
			WHERE alr.AL_Recommendation_Code = @AL_Recommendation_Code
			GROUP BY alrc.AL_Vendor_Rule_Code
		END
	END
END