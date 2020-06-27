ALTER PROCEDURE [dbo].[USP_Acq_Assets_Model] 
(
	@callFor CHAR(1),
	@BatchSize INT
)
AS 
  -- ============================================= 
  -- Author:    Akshay Rane
  -- Create date: 04 April 2019 
  -- Description:  
  -- ============================================= 
BEGIN 
	SET NOCOUNT ON; 
	CREATE TABLE #TempAssetId
	(	
		assetId INT
	)

	INSERT INTO #TempAssetId (assetId) 
	SELECT assetId FROM SchedulerRights WHERE RecordStatus = 'P'

	IF(@callFor = 'P')
	BEGIN
		SELECT 
			T.Duration_In_Min AS Title_Duration
			,T.Title_Code AS Title_Code
			,TC.Title_Content_Code AS _id 
			,TC.Episode_Title AS title
			,T.Title_Name AS seasonName
			,'' AS seasonNo
			,1 as programType
			,TC.Episode_No AS episodeNo
			,(SELECT TOP 1 G.Genres_Name FROM Genres G INNER JOIN Title_Geners TG ON TG.Genres_Code = G.Genres_Code AND TG.Title_Code = T.Title_Code) AS genre
			,IIF (TC.Duration = 0.00,T.Duration_In_Min, TC.Duration) AS duration
			,L.Language_Name AS 'language'
			,TC.Title_Content_Code AS medaiId
			,'Ready To Air' AS mediaStatus
			,'' AS censorship
			,'' AS banner
			,2 AS contentType
			,DT.Deal_Type_Name AS subType
			,'' AS trp
		FROM Title_Content TC
			INNER JOIN Title T ON TC.Title_Code = T.Title_Code
			INNER JOIN Language L ON L.Language_Code = T.Title_Language_Code
			INNER JOIN Deal_Type DT ON DT.Deal_Type_Code = T.Deal_Type_Code
		WHERE TC.Title_Content_Code IN (select assetId from #TempAssetId)
	END
	ELSE IF(@callFor = 'M')
	BEGIN
		SELECT 
			T.Duration_In_Min AS Title_Duration
			,T.Title_Code AS Title_Code
			,TC.Title_Content_Code AS _id 
			,TC.Episode_Title AS title
			,T.Title_Name AS seasonName
			,'' AS seasonNo
			,2 as programType
			,1 AS episodeNo
			,(SELECT TOP 1 G.Genres_Name FROM Genres G INNER JOIN Title_Geners TG ON TG.Genres_Code = G.Genres_Code AND TG.Title_Code = T.Title_Code) AS genre
			,IIF (TC.Duration = 0.00,T.Duration_In_Min, TC.Duration) AS duration
			,L.Language_Name AS 'language'
			,TC.Title_Content_Code AS medaiId
			,'Ready To Air' AS mediaStatus
			,'' AS censorship
			,'' AS banner
			,2 AS contentType
			,'' AS subType
			,'' AS trp
		FROM Title_Content TC
			INNER JOIN Title T ON TC.Title_Code = T.Title_Code
			INNER JOIN Language L ON L.Language_Code = T.Title_Language_Code
			INNER JOIN Deal_Type DT ON DT.Deal_Type_Code = T.Deal_Type_Code
		WHERE TC.Title_Content_Code IN (select assetId from #TempAssetId)
	END

	DROP TABLE #TempAssetId
END


--EXEC [USP_Acq_Assets_Model] 'M'
/*
SELECT 
			Cast(0.00 as decimal) AS Title_Duration
			,1 AS Title_Code
			,1 AS _id 
			,CAST(''AS NVARCHAR(MAX)) AS title
			,CAST(''AS NVARCHAR(MAX)) AS seasonName
			,CAST(''AS NVARCHAR(MAX)) AS seasonNo
			,1 as programType
			,1 AS episodeNo
			,CAST(''AS NVARCHAR(MAX)) AS genre
			,Cast(0.00 as decimal) AS duration
			,CAST(''AS NVARCHAR(MAX)) AS 'language'
			,1 AS medaiId
			,CAST(''AS NVARCHAR(MAX)) AS mediaStatus
			,CAST(''AS NVARCHAR(MAX)) AS censorship
			,CAST(''AS NVARCHAR(MAX)) AS banner
			,2 AS contentType
			,CAST(''AS NVARCHAR(MAX)) AS subType
			,CAST(CAST(''AS NVARCHAR(MAX))AS NVARCHAR(MAX)) AS trp
*/