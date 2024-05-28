CREATE PROCEDURE [dbo].[USPAL_RecommendationExportToPDF]
	@AL_Recommendation_Code INT,
	@Title_Code INT
AS
BEGIN

	DECLARE @TitleType CHAR(1) = 'M'

	IF EXISTS(SELECT Title_Code from Title WHERE Title_Code = @Title_Code AND Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),',')))
	BEGIN
		SET @TitleType = 'S'
	END

	SELECT TOP 1 t.Title_Name, CASE WHEN (@TitleType = 'M' AND ISNULL(t.Title_Image,'') = '') THEN CAST(((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_Title_Default_Image_Path') + 'movieIcon.png') AS NVARCHAR(MAX))
		WHEN (@TitleType = 'S' AND ISNULL(t.Title_Image,'') = '') THEN CAST(((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_Title_Default_Image_Path') + 'program.png') AS NVARCHAR(MAX)) ELSE CAST(((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_Title_Image_Path') + ISNULL(t.Title_Image,'')) AS NVARCHAR(MAX)) END AS Title_Image,
		ISNULL(avr.Rule_Name,'') AS Category, 
		CAST(STUFF((SELECT DISTINCT ', ' + CAST(cn.Genres_Name as NVARCHAR) FROM Title_Geners TC1 (NOLOCK)  
			INNER JOIN Genres cn (NOLOCK) ON TC1.Genres_Code = cn.Genres_Code  
		WHERE TC1.Title_Code = t.Title_Code  
		FOR XML PATH('')), 1, 2, '') AS NVARCHAR(MAX)) AS Geners, 
		ISNULL((SELECT TOP 1 Column_Value FROM Map_Extended_Columns WHERE Record_Code = t.Title_Code AND Table_Name = 'TITLE' AND Columns_Code = 37),'') AS [Airline_Release_Date],
		LTRIM(replace(CAST(STUFF((SELECT DISTINCT ', ' + CAST(TL.Talent_Name as NVARCHAR) FROM Title_Talent TC1 (NOLOCK)  
			INNER JOIN Talent TL (NOLOCK) ON TC1.Talent_Code = TL.Talent_Code  
		WHERE TC1.Title_Code = t.Title_Code AND TC1.Role_Code = 1 
		FOR XML PATH('')), 1, 2, '') AS NVARCHAR(MAX)),char(10),'')) AS Director, 
		CAST(ISNULL(t.Duration_In_Min,'0') AS NVARCHAR(MAX)) AS Runtime, 
		ISNULL((SELECT TOP 1 Column_Value FROM VWALTitleRecomExt WHERE Table_Name = 'TITLE' AND Record_Code = t.Title_Code AND Columns_Code = 41), '') AS Rating,
		ISNULL((SELECT TOP 1 Column_Value FROM VWALTitleRecomExt WHERE Table_Name = 'TITLE' AND Record_Code = t.Title_Code AND Columns_Code = 38), '') AS IMDB_Rating, 
		CAST(STUFF((SELECT DISTINCT ', ' + CAST(TL.Talent_Name as NVARCHAR) FROM Title_Talent TC1 (NOLOCK)  
			INNER JOIN Talent TL (NOLOCK) ON TC1.Talent_Code = TL.Talent_Code  
		WHERE TC1.Title_Code = t.Title_Code AND TC1.Role_Code = 2  
		FOR XML PATH('')), 1, 2, '') AS NVARCHAR(MAX)) AS Cast, 
		CAST(ISNULL(t.Synopsis,'') AS NVARCHAR(MAX)) AS Synopsis,
		(SELECT COUNT(tc.Episode_No) FROM Title_Content tc WHERE tc.Title_Code = @Title_Code) AS TotalNumberOfEpisodes,
		(SELECT COUNT (Title_Content_Code) FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @AL_Recommendation_Code and Title_Code = @Title_Code) AS NumberOfEpisodes,
		CAST(ISNULL(l.Language_Name,'') AS NVARCHAR(MAX)) AS Title_Language,
		ISNULL((SELECT TOP 1 Column_Value FROM VWALTitleRecomExt WHERE Table_Name = 'TITLE' AND Record_Code = t.Title_Code AND Columns_Code = 31), '') AS Season,
		CAST(((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_Client_Logo_Path') + 'Logo_'+ ISNULL((SELECT TOP 1 Short_Code FROM Vendor WHERE Vendor_Code = alp.Vendor_Code),'') + '.png') AS NVARCHAR(MAX)) AS Client_Logo,
		@TitleType AS TitleType
	FROM AL_Proposal alp
		INNER JOIN AL_Recommendation  alr ON alp.AL_Proposal_Code = alr.AL_Proposal_Code
		INNER JOIN AL_Recommendation_Content alrc ON alrc.AL_Recommendation_Code = alr.AL_Recommendation_Code 
		INNER JOIN Title t ON t.Title_Code = alrc.Title_Code
		LEFT JOIN AL_Vendor_Rule avr ON alrc.AL_Vendor_Rule_Code = avr.AL_Vendor_Rule_Code	
		LEFT JOIN Language l ON t.Title_Language_Code = l.Language_Code
	WHERE alrc.AL_Recommendation_Code = @AL_Recommendation_Code AND t.Title_Code = @Title_Code
END