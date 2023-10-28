CREATE PROCEDURE [dbo].[USPMHGetCueSheetSongDetails]
@CueSheetCode INT,
@ViewOn VARCHAR(2)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetCueSheetSongDetails]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF(@ViewOn = 'E')
			BEGIN
				SELECT ISNULL(TitleName,'') AS [ShowName],ISNULL(EpisodeNo,'') AS Episode, ISNULL(MusicTrackName,'') AS MusicTrack,ISNULL(MovieAlbum,'') AS MovieAlbum,ISNULL(SongType,'') AS SongType,ISNULL(FromTime,'') AS TCIn,ISNULL(FromFrame,'') AS TCInFrame,
				ISNULL(ToTime,'') AS TCOut,ISNULL(ToFrame,'') AS TCOutFrame,ISNULL(DurationTime,'') AS Duration,ISNULL(DurationFrame,'') AS DurationFrame,ISNULL([dbo].[UFNGetErrorList](ISNULL(ErrorMessage,'')),'')AS ErrorMessage  
				FROM MHCueSheetSong (NOLOCK) WHERE MHCueSheetCode = @CueSheetCode AND RecordStatus = 'E'
			END
		ELSE IF(@ViewOn = 'W')
			BEGIN
				SELECT ISNULL(TitleName,'') AS [ShowName],ISNULL(EpisodeNo,'') AS Episode, ISNULL(MusicTrackName,'') AS MusicTrack,ISNULL(MovieAlbum,'') AS MovieAlbum,ISNULL(SongType,'') AS SongType,ISNULL(FromTime,'') AS TCIn,ISNULL(FromFrame,'') AS TCInFrame,
				ISNULL(ToTime,'') AS TCOut,ISNULL(ToFrame,'') AS TCOutFrame,ISNULL(DurationTime,'') AS Duration,ISNULL(DurationFrame,'') AS DurationFrame,ISNULL([dbo].[UFNGetErrorList](ISNULL(ErrorMessage,'')),'') AS ErrorMessage  
				FROM MHCueSheetSong (NOLOCK) WHERE MHCueSheetCode = @CueSheetCode AND RecordStatus = 'W'
			END
		ELSE
			BEGIN	
				SELECT ISNULL(TitleName,'') AS [ShowName],ISNULL(EpisodeNo,'') AS Episode, ISNULL(MusicTrackName,'') AS MusicTrack,ISNULL(MovieAlbum,'') AS MovieAlbum,ISNULL(SongType,'') AS SongType,ISNULL(FromTime,'') AS TCIn,ISNULL(FromFrame,'') AS TCInFrame,
				ISNULL(ToTime,'') AS TCOut,ISNULL(ToFrame,'') AS TCOutFrame,ISNULL(DurationTime,'') AS Duration,ISNULL(DurationFrame,'') AS DurationFrame,ISNULL([dbo].[UFNGetErrorList](ISNULL(ErrorMessage,'')),'') AS ErrorMessage  
				FROM MHCueSheetSong (NOLOCK) WHERE MHCueSheetCode = @CueSheetCode 
			END
		
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetCueSheetSongDetails]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END

