CREATE PROCEDURE [dbo].[USP_List_Deal_Title_Content]
(
	@Title_Codes VARCHAR(2000) = '',
	@Acq_Deal_Code INT,
	@PageNo INT = 1,
	@IsPaging CHAR(1) = 'N',
	@PageSize INT = 10,
	@RecordCount INT OUT
)
AS
BEGIN
	SET FMTONLY OFF

	IF(@Title_Codes IS NULL)
		SET @Title_Codes = ''

	IF(OBJECT_ID('TEMPDB..#TempTitleContent') IS NOT NULL)
		DROP TABLE #TempTitleContent

	CREATE TABLE #TempTitleContent
	(
		Row_No INT IDENTITY(1,1),
		Acq_Deal_Code INT,
		Acq_Deal_Movie_Code INT,
		Title_Code INT,
		Title_Name NVARCHAR(MAX),
		Title_Content_Code INT,
		Episode_No INT,
		Ref_BMS_Content_Code VARCHAR(50), 
		Duration DECIMAL(18, 2),
		IsTerminate VARCHAR(5),
		Movie_Closed_Date DATETIME
	)

	INSERT INTO #TempTitleContent(
		Acq_Deal_Code, Acq_Deal_Movie_Code, Title_Code, Title_Name, 
		Title_Content_Code, Episode_No, Ref_BMS_Content_Code, 
		Duration,
		IsTerminate, Movie_Closed_Date
	)
	SELECT DISTINCT ADM.Acq_Deal_Code, ADM.Acq_Deal_Movie_Code, TC.Title_Code, COALESCE(TC.Episode_Title, T.Title_Name) AS Title_Name, 
	TC.Title_Content_Code, TC.Episode_No, ISNULL(TC.Ref_BMS_Content_Code, '') AS Ref_BMS_Content_Code, 
	ISNULL(COALESCE(TC.Duration, T.Duration_In_Min), 0) AS Duration ,
	CASE WHEN ISNULL(ADM.[Is_Closed], 'N') = 'Y' THEN 'Yes' ELSE 'No' END IsTerminate, ADM.Movie_Closed_Date
	FROM Acq_Deal_Movie ADM
	INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
	INNER JOIN Title_Content TC ON TC.Title_Content_Code = TCM.Title_Content_Code 
	INNER JOIN Title T ON T.Title_Code = TC.Title_Code
	WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code AND (
		TC.Title_Code IN (Select number From DBO.fn_Split_withdelemiter(@Title_Codes, ',')) OR @Title_Codes = ''
	)

	/* START : Logic For Paging*/
	SELECT @RecordCount  = MAX(Row_No) FROM #TempTitleContent

	IF(@RecordCount > 0 AND @IsPaging = 'Y')
	BEGIN
		DECLARE @cnt INT = 0
	
		IF(@PageSize > @RecordCount)
			SET @PageSize = @RecordCount

		SET @cnt = (@PageNo * @PageSize)
		IF(@cnt >= @RecordCount)
		BEGIN
			DECLARE @v1 INT = 0 
			SET @PageNo = @RecordCount / @PageSize
			IF ((@PageNo * @PageSize) < @RecordCount)
				SET @PageNo = @PageNo + 1
		END

		DELETE FROM #TempTitleContent WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	END
	/* END : Logic For Paging*/

	SELECT Acq_Deal_Code, Acq_Deal_Movie_Code, Title_Code, Title_Name, Title_Content_Code, 
		Episode_No, Ref_BMS_Content_Code,  Duration, IsTerminate, Movie_Closed_Date 
	FROM #TempTitleContent
END
