CREATE PROCEDURE [dbo].[USPAL_RecommendationExportToPDF_Movie]
@AL_Recommendation_Code INT,
@AL_Vendor_Rule_Code INT
AS
BEGIN
--Select top 1 AL_Vendor_Rule_Code from AL_Recommendation_Content WHERE Al_Recommendation_Code = 1450--@AL_Recommendation_Code
	SELECT * FROM
	(SELECT DISTINCT alrc.AL_Recommendation_Code, ISNULL(t.Title_Name,'') AS Title_Name, ISNULL(mec.Column_Value,'') AS ARD, ISNULL(mec1.Column_Value,'') AS TheatricalRelease, ISNULL(vwale_mpaa.Column_Value, '') AS MPAARating,
	ISNULL(vwal.Genre,'') AS Genre, ISNULL(vwale_stud.Column_Value, '') AS Studio, ISNULL(vwale_v.Column_Value, '') AS Version, ISNULL(vwal.Language_Name,'') AS Title_Language, ISNULL(vwale_sub.Column_Value,'') AS Subtitles,
	ISNULL(vwal.Runtime,'') AS Duration, ISNULL(vwal.Director,'') AS Director, ISNULL(vwal.Star_Cast,'') AS Cast, ISNULL(vwal.Synopsis,'') AS Synopsis, ISNULL(vwale_rat.Column_Value, '') AS IMDB_Rating, 
	ISNULL(vwale_pop.Column_Value,'') AS IMDB_Popularity, ISNULL(vwale_up.Column_Value,'') AS IMDB_UpDown, ISNULL(vwale_Tom1.Column_Value,'') AS RottenTomatoes_Tamotmeter, 
	ISNULL(vwale_Tom2.Column_Value,'') AS RottenTomatoes_Rating, '' AS Rights, ISNULL(vwale_aw.Column_Value,'') AS Awards, ISNULL(vwale_nom.Column_Value,'') AS Nominations, 
	ISNULL(vwale_box.Column_Value,'') AS BoxOffice, '' AS GeneralRemarks, alrc.Content_Type, alrc.Content_Status, alrc.AL_Recommendation_Content_Code 
	FROM AL_Proposal alp
	INNER JOIN AL_Recommendation  alr ON alp.AL_Proposal_Code = alr.AL_Proposal_Code
	INNER JOIN AL_Recommendation_Content alrc ON alrc.AL_Recommendation_Code = alrc.AL_Recommendation_Code 
	INNER JOIN Title t ON t.Title_Code = alrc.Title_Code
	INNER JOIN VWALTitleRecom vwal ON vwal.AL_Recommendation_Code = alrc.AL_Recommendation_Code AND vwal.Title_Code = t.Title_Code 
	LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' AND mec.Columns_Code = 37
	LEFT JOIN Map_Extended_Columns mec1 ON mec1.Record_Code = t.Title_Code AND mec1.Table_Name = 'TITLE' AND mec1.Columns_Code = 36
	LEFT JOIN VWALTitleRecomExt vwale ON vwale.Record_Code = t.Title_Code AND vwale.Table_Name = 'TITLE' AND vwale.Columns_Code = 69
	LEFT JOIN VWALTitleRecomExt vwale_v ON vwale_v.Record_Code = t.Title_Code AND vwale_v.Table_Name = 'TITLE' AND vwale_v.Columns_Code = 86
	LEFT JOIN VWALTitleRecomExt vwale_sub ON vwale_sub.Record_Code = t.Title_Code AND vwale_sub.Table_Name = 'TITLE' AND vwale_sub.Columns_Code = 53
	LEFT JOIN VWALTitleRecomExt vwale_rat ON vwale_rat.Record_Code = t.Title_Code AND vwale_rat.Table_Name = 'TITLE' AND vwale_rat.Columns_Code = 38
	LEFT JOIN VWALTitleRecomExt vwale_pop ON vwale_pop.Record_Code = t.Title_Code AND vwale_pop.Table_Name = 'TITLE' AND vwale_pop.Columns_Code = 39
	LEFT JOIN VWALTitleRecomExt vwale_up ON vwale_up.Record_Code = t.Title_Code AND vwale_up.Table_Name = 'TITLE' AND vwale_up.Columns_Code = 40
	LEFT JOIN VWALTitleRecomExt vwale_Tom1 ON vwale_Tom1.Record_Code = t.Title_Code AND vwale_Tom1.Table_Name = 'TITLE' AND vwale_Tom1.Columns_Code = 42
	LEFT JOIN VWALTitleRecomExt vwale_Tom2 ON vwale_Tom2.Record_Code = t.Title_Code AND vwale_Tom2.Table_Name = 'TITLE' AND vwale_Tom2.Columns_Code = 43
	LEFT JOIN VWALTitleRecomExt vwale_aw ON vwale_aw.Record_Code = t.Title_Code AND vwale_aw.Table_Name = 'TITLE' AND vwale_aw.Columns_Code IN (44)
	LEFT JOIN VWALTitleRecomExt vwale_nom ON vwale_nom.Record_Code = t.Title_Code AND vwale_nom.Table_Name = 'TITLE' AND vwale_nom.Columns_Code = 45
	LEFT JOIN VWALTitleRecomExt vwale_box ON vwale_box.Record_Code = t.Title_Code AND vwale_box.Table_Name = 'TITLE' AND vwale_box.Columns_Code = 49
	LEFT JOIN VWALTitleRecomExt vwale_mpaa ON vwale_mpaa.Record_Code = t.Title_Code AND vwale_mpaa.Table_Name = 'TITLE' AND vwale_mpaa.Columns_Code = 41
	LEFT JOIN VWALTitleRecomExt vwale_stud ON vwale_stud.Record_Code = t.Title_Code AND vwale_stud.Table_Name = 'TITLE' AND vwale_stud.Columns_Code = 32
	WHERE alrc.AL_Recommendation_Code = @AL_Recommendation_Code AND alrc.AL_Vendor_Rule_Code = @AL_Vendor_Rule_Code) AS TT
	ORDER BY TT.AL_Recommendation_Content_Code ASC

END