
CREATE FUNCTION [dbo].[UFN_GetDealTypeCondition](@Deal_Type_Code INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Deal_Type_Code_Program VARCHAR(MAX) = '', @Deal_Type_Code_Music VARCHAR(MAX) = '', @Deal_Type_Code_Movie VARCHAR(MAX) = '', 
	
	@Return_Value VARCHAR(MAX) = ''
	SELECT @Deal_Type_Code_Program = @Deal_Type_Code_Program + ',' + Parameter_Value FROM System_Parameter_New with(nolock) WHERE Parameter_Name IN ('Deal_Type_Content', 'Deal_Type_Sports', 'Deal_Type_Format_Program', 'Deal_Type_Documentary_Show', 'Deal_Type_Event','Deal_Type_Web-Series')
	SELECT @Deal_Type_Code_Music = @Deal_Type_Code_Music + ',' + Parameter_Value FROM System_Parameter_New with(nolock) WHERE Parameter_Name IN ('Deal_Type_Music')
	SELECT @Deal_Type_Code_Movie = @Deal_Type_Code_Movie + ',' + Parameter_Value FROM System_Parameter_New with(nolock) WHERE Parameter_Name IN ('Deal_Type_Movie','Deal_Type_Documentary_Film','Deal_Type_ShortFilm','Deal_Type_Featurette')
	IF(@Deal_Type_Code in (SELECT NUMBER FROM fn_Split_withdelemiter(@Deal_Type_Code_Program, ',')))
		SET @Return_Value = 'DEAL_PROGRAM'
	ELSE IF(@Deal_Type_Code in (SELECT NUMBER FROM fn_Split_withdelemiter(@Deal_Type_Code_Music, ',')))
		SET @Return_Value = 'DEAL_MUSIC'
	ELSE IF(@Deal_Type_Code in (SELECT NUMBER FROM fn_Split_withdelemiter(@Deal_Type_Code_Movie, ',')))
		SET @Return_Value = 'DEAL_MOVIE'
	ELSE
		SET @Return_Value = 'SUB_DEAL_TALENT'

	RETURN @Return_Value
END