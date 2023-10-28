CREATE PROCEDURE [dbo].[USPMHGetRequestDetails]
@RequestCode NVARCHAR(MAX),
@RequestTypeCode INT,
@IsCueSheet CHAR = 'N'
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetRequestDetails]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE
		--@RequestCode NVARCHAR(MAX) = 10049,
		--@RequestTypeCode INT = 1,
		--@IsCueSheet CHAR = 'N'

		IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet

		IF(@RequestTypeCode = 1)
			BEGIN
			IF(@IsCueSheet = 'Y')
				BEGIN

					Select COUNT(*) AS Cnt, TitleCode,MusicTitleCode, ma.Music_Album_Name INTO #tempCueSheet
					from MHCuesheetsong mcs (NOLOCK)
					INNER JOIN Music_Title mt (NOLOCK) ON mt.Music_Title_Code = mcs.MusicTitleCode
					INNER JOIN Music_Album ma (NOLOCK) ON ma.Music_Album_Code = mt.Music_Album_Code
					GROUP BY TitleCode,MusicTitleCode, ma.Music_Album_Name

					SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') 
					--+ ' ('+CAST(ISNULL(tcs.Cnt, 0) AS NVARCHAR) +')' 
					AS RequestedMusicTitle, 
					CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
						 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
						 ELSE 'Pending' END AS IsValid,
						 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
					CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
						 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
						 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks,ISNULL(tcs.Cnt, 0) AS SongUsedCount
					FROM MHRequestDetails MRD (NOLOCK)
					INNER JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = MRD.MusicTitleCode
					LEFT JOIN Music_Title_Label MTL (NOLOCK) ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
					LEFT JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MTL.Music_Label_Code
					LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
					INNER JOIN MHRequest MR (NOLOCK) ON MR.MHRequestCode = MRD.MHRequestCode
					LEFT JOIN Title T (NOLOCK) ON T.Title_Code = MR.TitleCode
					LEFT  JOIN #tempCueSheet tcs ON tcs.MusicTitleCode = mrd.MusicTitleCode AND tcs.TitleCode = mr.TitleCode
					WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',','))) AND MRD.IsApprove = 'Y'
				END
			ELSE
				BEGIN
					SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') AS RequestedMusicTitle, 
					CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
						 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
						 ELSE 'Pending' END AS IsValid,
						 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
					CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
						 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
						 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks
					FROM MHRequestDetails MRD (NOLOCK)
					INNER JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = MRD.MusicTitleCode
					LEFT JOIN Music_Title_Label MTL (NOLOCK) ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
					LEFT JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MTL.Music_Label_Code
					LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
					INNER JOIN MHRequest MR (NOLOCK) ON MR.MHRequestCode = MRD.MHRequestCode
					LEFT JOIN Title T (NOLOCK) ON T.Title_Code = MR.TitleCode
					WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',',')))
				END
			
			END
		ELSE IF(@RequestTypeCode = 2)
			BEGIN
				SELECT ISNULL(MRD.MusicTrackName,'') AS RequestedMusicTitleName,ISNULL(MT.Music_Title_Name,'') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'') AS MusicMovieAlbumName,
				CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
					WHEN MRD.CreateMap = 'M' THEN 'Map' 
					 ELSE 'Pending' END AS CreateMap,
				ISNULL(MRD.Remarks,'') AS Remarks,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,
					 ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.Singers,'')),'') AS Singers,ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.StarCasts,'')),'') AS StarCasts
				FROM MHRequestDetails MRD (NOLOCK)
				LEFT JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MRD.MusicLabelCode
				LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MRD.MovieAlbumCode 
				WHERE MRD.MHRequestCode = @RequestCode
			END
		ELSE
			BEGIN
				SELECT ISNULL(MRD.TitleName,'') AS RequestedMovieAlbumName,ISNULL(MA.Music_Album_Name,'') AS ApprovedMovieAlbumName,
				CASE WHEN MRD.MovieAlbum = 'A' THEN 'Album' 
					 ELSE 'Movie' END AS MovieAlbum,
				CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
					WHEN MRD.CreateMap = 'M' THEN 'Map' 
					 ELSE 'Pending' END AS CreateMap,
					 ISNULL(MRD.Remarks,'') AS Remarks,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove
				FROM MHRequestDetails MRD  (NOLOCK)
				LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MRD.MovieAlbumCode
				WHERE MRD.MHRequestCode = @RequestCode
			END

			IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet
		
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetRequestDetails]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
