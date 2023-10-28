CREATE PROCEDURE [dbo].[USPPopulateTitleForMapping]
	@SearchKey NVARCHAR(MAX)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='Loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPPopulateTitleForMapping]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @Deal_Type_Code INT = 0
		select TOP 1 @Deal_Type_Code = Deal_Type_Code from Deal_Type (NOLOCK) where Deal_Type_Name = 'Movie' AND Is_Active = 'Y'

		SELECT DISTINCT Final.Title_Code, Final.Title_Name FROM
		(
			SELECT T.Title_Code, T.Title_Name FROM Title T (NOLOCK)
			INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Title_Code = T.Title_Code
			INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code AND AD.Deal_Type_Code = @Deal_Type_Code AND CCR.Deal_Type = 'A'
			WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND T.Title_Code LIKE '%'+ @SearchKey +'%'
			UNION
			SELECT T.Title_Code, T.Title_Name FROM Title T (NOLOCK)
			INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Title_Code = T.Title_Code
			INNER JOIN Provisional_Deal PD (NOLOCK) ON PD.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND PD.Deal_Type_Code = @Deal_Type_Code AND CCR.Deal_Type = 'P'
			WHERE  T.Title_Code LIKE '%'+ @SearchKey +'%'
		) AS Final Order By Final.Title_Name
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPPopulateTitleForMapping]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END