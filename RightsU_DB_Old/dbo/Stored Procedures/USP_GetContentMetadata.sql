CREATE PROC USP_GetContentMetadata
(
	@Title_Content_Code BIGINT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 11 January 2017
-- Description:	Get Content Metadata
-- =============================================
BEGIN
	SELECT TC.Title_Content_Code, TC.Title_Code, COALESCE(TC.Episode_Title, T.Title_Name) AS Title_Name, DT.Deal_Type_Name Title_Type, TC.Episode_No,
	COALESCE(TC.Duration, T.Duration_In_Min) AS Duration
	FROM Title_Content TC
	INNER JOIN Title T ON T.Title_Code = TC.Title_Code
	INNER JOIN Deal_Type DT ON DT.Deal_Type_Code = T.Deal_Type_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code
END