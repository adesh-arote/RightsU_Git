CREATE PROCEDURE [dbo].[USP_Get_Title_For_Acq_Digital]
	@ACQ_DEAL_CODE int, @title_Code int = 0
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Title_For_Acq_Digital]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		DECLARE @Deal_Type_Code INT;
		SELECT @Deal_Type_Code = Deal_Type_Code FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @ACQ_DEAL_CODE
		DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)

		if(@title_Code = 0 )
		Begin
			SELECT  DISTINCT CASE WHEN @Deal_Type_Condition IN ('DEAL_PROGRAM', 'DEAL_MUSIC') THEN ADM.Acq_Deal_Movie_Code ELSE T.Title_Code END AS Title_Code, 
					dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name
			FROM Acq_Deal AD (NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code 
			INNER JOIN Title T (NOLOCK) ON T.Title_Code =  ADM.Title_Code
			WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code = @ACQ_DEAL_CODE
			And T.Title_code NOT IN (
				SELECT ads.Title_code FROM Acq_Deal_Digital ads (NOLOCK) 
				WHERE ads.Acq_Deal_code = @ACQ_DEAL_CODE AND ads.Episode_From = ADM.Episode_Starts_From AND ads.Episode_To = ADM.Episode_End_To
			)
		End
		ELSE
		Begin
			SELECT DISTINCT CASE WHEN @Deal_Type_Condition IN ('DEAL_PROGRAM', 'DEAL_MUSIC') THEN ADM.Acq_Deal_Movie_Code ELSE T.Title_Code END AS Title_Code, 
				   dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name
			FROM Acq_Deal AD (NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code 
			INNER JOIN Title T (NOLOCK) ON T.Title_Code =  ADM.Title_Code
			WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code = @ACQ_DEAL_CODE
				  AND (
						(@Deal_Type_Condition IN ('DEAL_PROGRAM', 'DEAL_MUSIC') AND ADM.Acq_Deal_Movie_Code = @title_Code)
						OR (@Deal_Type_Condition NOT IN ('DEAL_PROGRAM', 'DEAL_MUSIC') AND T.Title_code = @title_Code)
				  )
		End
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Title_For_Acq_Digital]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END