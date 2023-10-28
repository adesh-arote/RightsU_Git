CREATE PROCEDURE [dbo].[USPMHRequistionTrackList]
	@MHRequestCode INT
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHRequistionTrackList]', 'Step 1', 0, 'Started Procedure', 0, ''
	--DECLARE
	--	@MHRequestCode INT = 10542

			BEGIN
				SELECT
				ISNULL(CAST(MRD.MHRequestDetailsCode as INT), 0) AS MHRequestDetailsCode,
				ISNULL(MT.Music_Title_Code, 0) AS MusicTitleCode,
				ISNULL(ML.Music_Label_Code, 0) AS MusicLabelCode,
				ISNULL(MA.Music_Album_Code, 0) AS MusicAlbumCode,
				ISNULL(MR.MHRequestStatusCode, 0) AS MHRequestStatusCode,
				ISNULL(MRD.MusicTrackName,'') AS RequestedMusicTitleName,
				ISNULL(ML.Music_Label_Name,'') AS MusicLabelName,
				ISNULL(MA.Music_Album_Name,'') AS MusicMovieAlbumName,
				ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.Singers,'')),'') AS Singers,
				ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.StarCasts,'')),'') AS StarCasts,
				ISNULL(MT.Music_Title_Name,'') AS ApprovedMusicTitleName,
				ISNULL(MRD.CreateMAP, '') AS CreateMap,
				ISNULL(MRD.IsApprove, '') AS IsApprove,
				ISNULL(MRD.Remarks,'') AS Remarks	
				FROM MHRequestDetails MRD (NOLOCK)
				INNER JOIN MHRequest MR (NOLOCK) ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MRD.MusicLabelCode
				LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MRD.MovieAlbumCode 
				WHERE MRD.MHRequestCode = @MHRequestCode
			END

			--Select
			--0 AS MHRequestDetailsCode,
			--0 AS MusicTitleCode,
			--0 AS MusicLabelCode,
			--0 AS MusicAlbumCode,
			--0 AS MHRequestStatusCode,
			--'' AS RequestedMusicTitleName,
			--'' AS MusicLabelName,
			--'' AS MusicMovieAlbumName,
			--'' AS Singers,
			--'' AS StarCasts,
			--'' AS ApprovedMusicTitleName,
			--'' AS CreateMap,
			--'' AS IsApprove,
			--'' AS Remarks
		
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHRequistionTrackList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END