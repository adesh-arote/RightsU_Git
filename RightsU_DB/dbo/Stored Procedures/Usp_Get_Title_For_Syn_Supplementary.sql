CREATE PROCEDURE [dbo].[Usp_Get_Title_For_Syn_Supplementary](@Syn_Deal_Code INT, @Title_Code INT = 0)
AS
BEGIN	
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[Usp_Get_Title_For_Syn_Supplementary]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		DECLARE @Deal_Type_Code INT;
		SELECT @Deal_Type_Code = Deal_Type_Code FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @Syn_DEAL_CODE
		DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)

		if(@title_Code = 0 )
		Begin
			SELECT  DISTINCT CASE WHEN @Deal_Type_Condition IN ('DEAL_PROGRAM', 'DEAL_MUSIC') THEN ADM.Syn_Deal_Movie_Code ELSE T.Title_Code END AS Title_Code, 
					dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_From, ADM.Episode_End_To) AS Title_Name
			FROM Syn_Deal AD (NOLOCK)
			INNER JOIN Syn_Deal_Movie ADM (NOLOCK) ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code 
			INNER JOIN Title T (NOLOCK) ON T.Title_Code =  ADM.Title_Code
			WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Syn_Deal_Code = @Syn_DEAL_CODE
			And T.Title_code NOT IN (
				SELECT ads.Title_code FROM Syn_Deal_Supplementary ads  (NOLOCK)
				WHERE ads.Syn_Deal_code = @Syn_DEAL_CODE AND ads.Episode_From = ADM.Episode_From AND ads.Episode_To = ADM.Episode_End_To
			)
		End
		ELSE
		Begin
			SELECT DISTINCT CASE WHEN @Deal_Type_Condition IN ('DEAL_PROGRAM', 'DEAL_MUSIC') THEN ADM.Syn_Deal_Movie_Code ELSE T.Title_Code END AS Title_Code, 
				   dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_From, ADM.Episode_End_To) AS Title_Name
			FROM Syn_Deal AD (NOLOCK)
			INNER JOIN Syn_Deal_Movie ADM (NOLOCK) ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code 
			INNER JOIN Title T (NOLOCK) ON T.Title_Code =  ADM.Title_Code
			WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Syn_Deal_Code = @Syn_DEAL_CODE
				  AND (
						(@Deal_Type_Condition IN ('DEAL_PROGRAM', 'DEAL_MUSIC') AND ADM.Syn_Deal_Movie_Code = @title_Code)
						OR (@Deal_Type_Condition NOT IN ('DEAL_PROGRAM', 'DEAL_MUSIC') AND T.Title_code = @title_Code)
				  )
		End
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Usp_Get_Title_For_Syn_Supplementary]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END