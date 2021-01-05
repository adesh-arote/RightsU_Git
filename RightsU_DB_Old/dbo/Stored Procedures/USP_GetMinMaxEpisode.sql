CREATE PROC USP_GetMinMaxEpisode
(
	@DealCode INT,
	@DealType CHAR(1)
)
AS
BEGIN
	--DECLARE @DealCode INT = 2484, @DealType CHAR(1) = 'A'
	SET FMTONLY OFF

	IF(OBJECT_ID('TEMPDB..#TempDealMovie') IS NOT NULL)
		DROP TABLE #TempDealMovie

	CREATE TABLE #TempDealMovie
	(
		DealMovieCode	INT,
		TitleCode		INT,
		EpisodeFrom		INT,
		EpisodeTo		INT,
		MaxEpisodeFrom	INT DEFAULT(0),
		MinEpisodeTo	INT DEFAULT(0)
	)

	IF(@DealType = 'A')
	BEGIN
		INSERT INTO #TempDealMovie(DealMovieCode, TitleCode, EpisodeFrom, EpisodeTo)
		SELECT Acq_Deal_Movie_Code, Title_Code, Episode_Starts_From, Episode_End_To FROM Acq_Deal_Movie WITH(NOLOCK)
		WHERE Acq_Deal_Code = @DealCode

		/* Scheduled Title */
		UPDATE TDM SET TDM.MaxEpisodeFrom = A.MaxEpisodeFrom, TDM.MinEpisodeTo = a.MinEpisodeTo FROM (
			SELECT TDM.TitleCode, MIN(CAST(BST.Program_Episode_Number AS INT)) AS MaxEpisodeFrom , 
				MAX(CAST(BST.Program_Episode_Number AS INT)) AS MinEpisodeTo
			FROM #TempDealMovie TDM
			INNER JOIN BV_Schedule_Transaction BST WITH(NOLOCK) ON CAST(BST.Title_Code AS INT) = TDM.TitleCode 
				AND CAST(BST.Program_Episode_Number AS INT) BETWEEN TDM.EpisodeFrom AND TDM.EpisodeTo
			GROUP BY TDM.TitleCode
		) AS A
		INNER JOIN #TempDealMovie TDM ON TDM.TitleCode = A.TitleCode

		/* Linked Music */
		UPDATE TDM SET TDM.MaxEpisodeFrom = CASE WHEN A.MaxEpisodeFrom < TDM.MaxEpisodeFrom THEN A.MaxEpisodeFrom ELSE TDM.MaxEpisodeFrom END,
		TDM.MinEpisodeTo = CASE WHEN A.MinEpisodeTo > TDM.MinEpisodeTo THEN A.MinEpisodeTo ELSE TDM.MinEpisodeTo END
		FROM (
			SELECT TDM.TitleCode, MIN(TC.Episode_No) AS MaxEpisodeFrom, MAX(TC.Episode_No) AS MinEpisodeTo
			FROM #TempDealMovie TDM
			INNER JOIN Title_Content TC WITH(NOLOCK) ON TC.Title_Code = TDM.TitleCode AND 
				TC.Episode_No BETWEEN TDM.EpisodeFrom AND TDM.EpisodeTo
			INNER JOIN Content_Music_Link CML WITH(NOLOCK) ON CML.Title_Content_Code = TC.Title_Content_Code
			GROUP BY TDM.TitleCode
		) AS A 
		INNER JOIN #TempDealMovie TDM ON TDM.TitleCode = A.TitleCode

		/* Syn Acq Mapping */
		UPDATE TDM SET TDM.MaxEpisodeFrom = CASE WHEN A.MaxEpisodeFrom < TDM.MaxEpisodeFrom THEN A.MaxEpisodeFrom ELSE TDM.MaxEpisodeFrom END,
		TDM.MinEpisodeTo = CASE WHEN A.MinEpisodeTo > TDM.MinEpisodeTo THEN A.MinEpisodeTo ELSE TDM.MinEpisodeTo END
		FROM (
			SELECT SDM.Title_Code, MIN(Episode_From) AS MaxEpisodeFrom, MAX(SDM.Episode_End_To) AS MinEpisodeTo 
			FROM Syn_Acq_Mapping SAM WITH(NOLOCK)
			INNER JOIN Syn_Deal SD WITH(NOLOCK) ON SD.Syn_Deal_Code = SAM.Syn_Deal_Code AND SAM.Deal_Code = @DealCode
			INNER JOIN Syn_Deal_Movie SDM WITH(NOLOCK) ON SDM.Syn_Deal_Code = SD.Syn_Deal_Code
			GROUP BY SDM.Title_Code
		) AS A
		INNER JOIN #TempDealMovie TDM ON TDM.TitleCode = A.Title_Code

	END
	SELECT DealMovieCode, TitleCode, EpisodeFrom, EpisodeTo, MaxEpisodeFrom, MinEpisodeTo FROM #TempDealMovie
END