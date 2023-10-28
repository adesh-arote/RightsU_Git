CREATE PROCEDURE [dbo].[USPAL_GetRecommendationTitleDetails]
@AL_Recommendation_Code INT
AS
BEGIN

	SELECT DISTINCT AL_Recommendation_Code, AL_Vendor_Rule_Code, Title_Code 
		FROM AL_Recommendation_Content alrc 
		WHERE alrc.AL_Recommendation_Code = @AL_Recommendation_Code

END