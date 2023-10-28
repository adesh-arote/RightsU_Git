CREATE PROCEDURE [dbo].[USPAL_RecommendationExportToExcel_Show]
@AL_Recommendation_Code INT ,
@AL_Vendor_Rule_Code INT,
@Flag VARCHAR(3) = 'GRP'
AS
BEGIN
--DECLARE
--@AL_Recommendation_Code INT = 4130,
--@AL_Vendor_Rule_Code INT = 19
--Select top 1 AL_Vendor_Rule_Code from AL_Recommendation_Content WHERE Al_Recommendation_Code = 1450--@AL_Recommendation_Code
	IF(@Flag = 'GRP')
	BEGIN
		SELECT * FROM
			(SELECT ROW_NUMBER() OVER(PARTITION BY ISNULL(Title_Name,'') ORDER BY ISNULL(Title_Content_Code,'') ASC) AS RowNum, * FROM
			(SELECT DISTINCT alrc.AL_Recommendation_Code, vwal.Title_Content_Code , ISNULL(t.Title_Name,'') AS Title_Name,ISNULL(vwal.Year_Of_Production,'') AS YOR, ISNULL(vwale_mpaa.Column_Value, '') AS MPAARating,
			ISNULL(vwal.Genre,'') AS Genre, ISNULL(vwale_stud.Column_Value, '') AS Studio, ISNULL(vwale_seas.Column_Value, '') AS Season,
			(Select COUNT(tc.Episode_No) FROM Title_Content tc WHERE tc.Title_Code = t.Title_Code) AS TotalNumberOfEpisodes, 
			ISNULL(vwal.Episode_Title,'') AS Episode_Name, ISNULL(vwal.Episode_No,0) AS Episode_Number,
			ISNULL(vwal.Runtime,0) AS Episode_Duration, ISNULL(vwal.Episode_Synopsis,'') AS Episode_Synopsis, ISNULL(vwal.Synopsis,'') AS Synopsis, ISNULL(vwal.Language_Name,'') AS Title_Language,
			ISNULL(vwale_sub.Column_Value,'') AS Subtitles, ISNULL(vwal.Runtime,'') AS Duration, ISNULL(vwal.Director,'') AS Director, ISNULL(vwal.Star_Cast,'') AS Cast,
			ISNULL(vwale_rat.Column_Value, '') AS IMDB_Rating, '' AS GeneralRemarks, alrc.Content_Type, alrc.Content_Status, CASE WHEN alrc.Content_Type = 'H' THEN 'Holdover' WHEN  alrc.Content_Type = 'D' THEN 'Remove' ELSE 'New' END AS Content_Record_Status,
			(SELECT COUNT (Title_Content_Code) FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @AL_Recommendation_Code and Title_Code = t.Title_Code) AS NumberOfEpisodes	
		FROM AL_Proposal alp
			INNER JOIN AL_Recommendation  alr ON alp.AL_Proposal_Code = alr.AL_Proposal_Code
			INNER JOIN AL_Recommendation_Content alrc ON alrc.AL_Recommendation_Code = alrc.AL_Recommendation_Code 
			INNER JOIN Title t ON t.Title_Code = alrc.Title_Code
			INNER JOIN VWALTitleRecom vwal ON vwal.AL_Recommendation_Code = alrc.AL_Recommendation_Code AND vwal.Title_Code = t.Title_Code AND vwal.Title_Content_Code = alrc.Title_Content_Code
			LEFT JOIN VWALTitleRecomExt vwale ON vwale.Record_Code = t.Title_Code AND vwale.Table_Name = 'TITLE' AND vwale.Columns_Code = 69
			LEFT JOIN VWALTitleRecomExt vwale_sub ON vwale_sub.Record_Code = t.Title_Code AND vwale_sub.Table_Name = 'TITLE' AND vwale_sub.Columns_Code = 53
			LEFT JOIN VWALTitleRecomExt vwale_rat ON vwale_rat.Record_Code = t.Title_Code AND vwale_rat.Table_Name = 'TITLE' AND vwale_rat.Columns_Code = 38
			LEFT JOIN VWALTitleRecomExt vwale_mpaa ON vwale_mpaa.Record_Code = t.Title_Code AND vwale_mpaa.Table_Name = 'TITLE' AND vwale_mpaa.Columns_Code = 41
			LEFT JOIN VWALTitleRecomExt vwale_stud ON vwale_stud.Record_Code = t.Title_Code AND vwale_stud.Table_Name = 'TITLE' AND vwale_stud.Columns_Code = 32
			LEFT JOIN VWALTitleRecomExt vwale_seas ON vwale_seas.Record_Code = t.Title_Code AND vwale_seas.Table_Name = 'TITLE' AND vwale_seas.Columns_Code = 31
		WHERE alrc.AL_Recommendation_Code = @AL_Recommendation_Code AND alrc.AL_Vendor_Rule_Code = @AL_Vendor_Rule_Code) AS TT) AS TTT WHERE RowNum = 1;
	END
	ELSE
	BEGIN
		SELECT DISTINCT alrc.AL_Recommendation_Code, vwal.Title_Content_Code , ISNULL(t.Title_Name,'') AS Title_Name,ISNULL(vwal.Year_Of_Production,'') AS YOR, ISNULL(vwale_mpaa.Column_Value, '') AS MPAARating,
		ISNULL(vwal.Genre,'') AS Genre, ISNULL(vwale_stud.Column_Value, '') AS Studio, ISNULL(vwale_seas.Column_Value, '') AS Season,
		(Select COUNT(tc.Episode_No) FROM Title_Content tc WHERE tc.Title_Code = t.Title_Code) AS TotalNumberOfEpisodes, 
		ISNULL(vwal.Episode_Title,'') AS Episode_Name, ISNULL(vwal.Episode_No,0) AS Episode_Number,
		ISNULL(vwal.Runtime,0) AS Episode_Duration, ISNULL(vwal.Episode_Synopsis,'') AS Episode_Synopsis, ISNULL(vwal.Synopsis,'') AS Synopsis, ISNULL(vwal.Language_Name,'') AS Title_Language,
		ISNULL(vwale_sub.Column_Value,'') AS Subtitles, ISNULL(vwal.Runtime,'') AS Duration, ISNULL(vwal.Director,'') AS Director, ISNULL(vwal.Star_Cast,'') AS Cast,
		ISNULL(vwale_rat.Column_Value, '') AS IMDB_Rating, '' AS GeneralRemarks, alrc.Content_Type, alrc.Content_Status, CASE WHEN alrc.Content_Type = 'H' THEN 'Holdover' WHEN  alrc.Content_Type = 'D' THEN 'Remove' ELSE 'New' END AS Content_Record_Status 
		FROM AL_Proposal alp
		INNER JOIN AL_Recommendation  alr ON alp.AL_Proposal_Code = alr.AL_Proposal_Code
		INNER JOIN AL_Recommendation_Content alrc ON alrc.AL_Recommendation_Code = alrc.AL_Recommendation_Code 
		INNER JOIN Title t ON t.Title_Code = alrc.Title_Code
		INNER JOIN VWALTitleRecom vwal ON vwal.AL_Recommendation_Code = alrc.AL_Recommendation_Code AND vwal.Title_Code = t.Title_Code AND vwal.Title_Content_Code = alrc.Title_Content_Code
		--LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' AND mec.Columns_Code = 37
		--LEFT JOIN Map_Extended_Columns mec1 ON mec1.Record_Code = t.Title_Code AND mec1.Table_Name = 'TITLE' AND mec1.Columns_Code = 36
		LEFT JOIN VWALTitleRecomExt vwale ON vwale.Record_Code = t.Title_Code AND vwale.Table_Name = 'TITLE' AND vwale.Columns_Code = 69
		--LEFT JOIN VWALTitleRecomExt vwale_v ON vwale_v.Record_Code = t.Title_Code AND vwale_v.Table_Name = 'TITLE' AND vwale_v.Columns_Code = 86
		LEFT JOIN VWALTitleRecomExt vwale_sub ON vwale_sub.Record_Code = t.Title_Code AND vwale_sub.Table_Name = 'TITLE' AND vwale_sub.Columns_Code = 53
		LEFT JOIN VWALTitleRecomExt vwale_rat ON vwale_rat.Record_Code = t.Title_Code AND vwale_rat.Table_Name = 'TITLE' AND vwale_rat.Columns_Code = 38
		--LEFT JOIN VWALTitleRecomExt vwale_pop ON vwale_pop.Record_Code = t.Title_Code AND vwale_pop.Table_Name = 'TITLE' AND vwale_pop.Columns_Code = 39
		--LEFT JOIN VWALTitleRecomExt vwale_up ON vwale_up.Record_Code = t.Title_Code AND vwale_up.Table_Name = 'TITLE' AND vwale_up.Columns_Code = 40
		LEFT JOIN VWALTitleRecomExt vwale_mpaa ON vwale_mpaa.Record_Code = t.Title_Code AND vwale_mpaa.Table_Name = 'TITLE' AND vwale_mpaa.Columns_Code = 41
		LEFT JOIN VWALTitleRecomExt vwale_stud ON vwale_stud.Record_Code = t.Title_Code AND vwale_stud.Table_Name = 'TITLE' AND vwale_stud.Columns_Code = 32
		LEFT JOIN VWALTitleRecomExt vwale_seas ON vwale_seas.Record_Code = t.Title_Code AND vwale_seas.Table_Name = 'TITLE' AND vwale_seas.Columns_Code = 31
		WHERE alrc.AL_Recommendation_Code = @AL_Recommendation_Code AND alrc.AL_Vendor_Rule_Code = @AL_Vendor_Rule_Code
	END	

END