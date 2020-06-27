CREATE PROCEDURE USP_List_Content
(
	@searchText NVARCHAR(1000) = NULL, 
	@episodeFrom INT = NULL, 
	@episodeTo INT = NULL
)
AS
BEGIN
	DECLARE @dealTypeCodeForAllowAssignMusic VARCHAR(MAX) = ''

	SELECT TOP 1 @dealTypeCodeForAllowAssignMusic = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'DealTypeCodeFor_AllowAssignMusic'

	SELECT ADMC.Acq_Deal_Movie_Content_Code, COALESCE(ADMC.Episode_Title, T.Title_Name) AS Title_Name,  'Episode ' + CAST(ADMC.Episode_Id AS VARCHAR) AS Episode, ISNULL(ADMC.Duration, 0) AS Duration_In_Min 
	FROM Acq_Deal_Movie_Contents ADMC
	INNER JOIN Acq_Deal_Movie ADM ON ADMC.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
	INNER JOIN Acq_Deal AD ON ADMC.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Deal_Type_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@dealTypeCodeForAllowAssignMusic, ','))
	INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
	WHERE (T.Title_Name LIKE N'%'+ @searchText +'%' OR ADMC.Episode_Title LIKE N'%'+ @searchText +'%') AND Episode_No BETWEEN @episodeFrom AND @episodeTo
	ORDER BY T.Title_Name, ADMC.Episode_Id
END

select * from Deal_type