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
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Duplicate_Syn_Run]', 'Step 1', 0, 'Started Procedure', 0, ''  	
		SET FMTONLY OFF;
		SET NOCOUNT ON;

		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @SYN_DEAL_CODE
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	
		SELECT 
		dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, SDRUN.Episode_From, SDRUN.Episode_To) AS Title_Name,
		P.Platform_Hiearachy AS PLATFORM_NAME,
		'' AS Right_Start_Date,
		'' AS Right_End_Date
		FROM SYN_DEAL SD (NOLOCK)
		INNER JOIN Syn_Deal_Movie SDM (NOLOCK) ON SD.Syn_Deal_Code = SDM.Syn_Deal_Code
		INNER JOIN Syn_Deal_Run SDRUN (NOLOCK) ON SDRUN.Syn_Deal_Code = SD.Syn_Deal_Code  AND 
						SDRUN.Episode_From = SDM.Episode_From AND SDRUN.Episode_To = SDM.Episode_End_To AND SDRUN.Title_Code = SDM.Title_Code
		INNER JOIN Syn_Deal_Run_Platform SDRUNP (NOLOCK) ON SDRUNP.Syn_Deal_Run_Code = SDRUN.Syn_Deal_Run_Code 
		INNER JOIN TITLE T (NOLOCK) ON T.TITLE_CODE = SDRUN.TITLE_CODE AND T.Title_Code = SDM.Title_Code
		INNER JOIN [Platform] P (NOLOCK) ON P.PLATFORM_CODE = SDRUNP.PLATFORM_CODE
		WHERE ((SDRUN.TITLE_CODE IN (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@TITLE_CODE,',')) AND (@Deal_Type_Condition != 'DEAL_PROGRAM' OR @Deal_Type_Condition != 'DEAL_MUSIC')) OR
		(SDM.Syn_Deal_Movie_Code IN  (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@TITLE_CODE,','))) AND (@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC'))
		AND SDRUN.Syn_Deal_Run_Code not in (@SYN_DEAL_RUN_CODE) 
		AND SD.Syn_Deal_Code IN(@SYN_DEAL_CODE)
		AND SDRUNP.Platform_Code IN(SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@PLATFORM_CODE,','))
  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Duplicate_Syn_Run]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 			
END
