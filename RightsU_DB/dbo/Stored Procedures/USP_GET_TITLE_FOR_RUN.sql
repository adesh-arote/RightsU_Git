CREATE PROCEDURE [dbo].[USP_GET_TITLE_FOR_RUN]
	@ACQ_DEAL_CODE int
AS
-- =============================================
-- Author:		Bhavesh Desai
-- Create DATE: 29-October-2014
-- Description:	GET those titles from acquisition rights that has satellite platform right
-- =============================================

BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[]', 'Step 1', 0, 'Started Procedure', 0, ''

	Exec [USPLogSQLSteps] '[USP_GET_TITLE_FOR_RUN]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE @ACQ_DEAL_CODE INT = 504
		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @ACQ_DEAL_CODE
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)
		IF(@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC')
		BEGIN
			SELECT  DISTINCT ADM.Acq_Deal_Movie_Code AS 'Title_Code', 
			dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADRT.Episode_From, ADRT.Episode_To) AS Title_Name
			FROM Acq_Deal AD (NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code= ADR.Acq_Deal_Rights_Code AND ADM.Title_Code = ADRT.Title_Code
				AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
			INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADRP.Acq_Deal_Rights_Code= ADR.Acq_Deal_Rights_Code
			INNER JOIN Platform P (NOLOCK) ON P.Platform_Code = ADRP.Platform_Code AND p.Is_No_Of_Run = 'Y'
			INNER JOIN Title T (NOLOCK) ON T.Title_Code =  ADRT.Title_Code
			--LEFT JOIN Acq_Deal_Run ADRU ON ADRU.Acq_Deal_Code = AD.Acq_Deal_Code
			--LEFT JOIN Acq_Deal_Run_Shows ADRS ON ADRS.Acq_deal_Run_Code = ADRU.Acq_deal_Run_Code
			WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code = @ACQ_DEAL_CODE
			--AND ADM.Is_Closed != 'Y' AND ADM.Is_Closed != 'X'
		END
		ELSE
		BEGIN
			SELECT  DISTINCT ADRT.Title_Code,T.Title_Name   FROM Acq_Deal AD (NOLOCK)
			INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code= ADR.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) ON ADRP.Acq_Deal_Rights_Code= ADR.Acq_Deal_Rights_Code
			INNER JOIN Platform P (NOLOCK) ON P.Platform_Code = ADRP.Platform_Code AND p.Is_No_Of_Run = 'Y'
			INNER JOIN Title T (NOLOCK) ON T.Title_Code =  ADRT.Title_Code
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Title_Code = T.Title_Code
			WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code =@ACQ_DEAL_CODE
			--AND ADM.Is_Closed != 'Y' AND ADM.Is_Closed != 'X'
		END
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GET_TITLE_FOR_RUN]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END