
CREATE PROCEDURE [dbo].[USP_Validate_Duplicate_Syn_Run]
	@TITLE_CODE VARCHAR(MAX),
	@PLATFORM_CODE VARCHAR(MAX),
	@SYN_DEAL_RUN_CODE int,
	@SYN_DEAL_CODE int
AS
-- =============================================
-- Author:		Rajesh Godse
-- Create DATE: 25 Feb 2015
-- Description:	Validating duplicate syndication run definition
-- =============================================
BEGIN			
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Syn_Deal WHERE Syn_Deal_Code = @SYN_DEAL_CODE
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	
	SELECT 
	dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, SDRUN.Episode_From, SDRUN.Episode_To) AS Title_Name,
	P.Platform_Hiearachy AS PLATFORM_NAME,
	'' AS Right_Start_Date,
	'' AS Right_End_Date
	FROM SYN_DEAL SD
	INNER JOIN Syn_Deal_Movie SDM ON SD.Syn_Deal_Code = SDM.Syn_Deal_Code
	INNER JOIN Syn_Deal_Run SDRUN ON SDRUN.Syn_Deal_Code = SD.Syn_Deal_Code  AND 
					SDRUN.Episode_From = SDM.Episode_From AND SDRUN.Episode_To = SDM.Episode_End_To AND SDRUN.Title_Code = SDM.Title_Code
	INNER JOIN Syn_Deal_Run_Platform SDRUNP ON SDRUNP.Syn_Deal_Run_Code = SDRUN.Syn_Deal_Run_Code 
	INNER JOIN TITLE T ON T.TITLE_CODE = SDRUN.TITLE_CODE AND T.Title_Code = SDM.Title_Code
	INNER JOIN [Platform] P ON P.PLATFORM_CODE = SDRUNP.PLATFORM_CODE
	WHERE ((SDRUN.TITLE_CODE IN (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@TITLE_CODE,',')) AND (@Deal_Type_Condition != 'DEAL_PROGRAM' OR @Deal_Type_Condition != 'DEAL_MUSIC')) OR
	(SDM.Syn_Deal_Movie_Code IN  (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@TITLE_CODE,','))) AND (@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC'))
	AND SDRUN.Syn_Deal_Run_Code not in (@SYN_DEAL_RUN_CODE) 
	AND SD.Syn_Deal_Code IN(@SYN_DEAL_CODE)
	AND SDRUNP.Platform_Code IN(SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@PLATFORM_CODE,','))
			
END