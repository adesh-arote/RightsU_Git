--DROP PROCEDURE [dbo].[USPPopulateTitleForMapping]
CREATE PROCEDURE [dbo].[USPPopulateTitleForMapping]
	@SearchKey NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Deal_Type_Code INT = 0
	select TOP 1 @Deal_Type_Code = Deal_Type_Code from Deal_Type where Deal_Type_Name = 'Movie' AND Is_Active = 'Y'

	SELECT DISTINCT Final.Title_Code, Final.Title_Name FROM
	(
		SELECT T.Title_Code, T.Title_Name FROM Title T
		INNER JOIN Content_Channel_Run CCR ON CCR.Title_Code = T.Title_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code AND AD.Deal_Type_Code = @Deal_Type_Code AND CCR.Deal_Type = 'A'
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND T.Title_Code LIKE '%'+ @SearchKey +'%'
		UNION
		SELECT T.Title_Code, T.Title_Name FROM Title T
		INNER JOIN Content_Channel_Run CCR ON CCR.Title_Code = T.Title_Code
		INNER JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = CCR.Provisional_Deal_Code AND PD.Deal_Type_Code = @Deal_Type_Code AND CCR.Deal_Type = 'P'
		WHERE  T.Title_Code LIKE '%'+ @SearchKey +'%'
	) AS Final Order By Final.Title_Name
END