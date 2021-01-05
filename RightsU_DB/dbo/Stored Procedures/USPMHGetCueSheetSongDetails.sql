CREATE PROCEDURE USPMHGetCueSheetSongDetails
@CueSheetCode INT,
@ViewOn VARCHAR(2)
AS
BEGIN
	IF(@ViewOn = 'E')
		BEGIN
			SELECT ISNULL(TitleName,'') AS [ShowName],ISNULL(EpisodeNo,'') AS Episode, ISNULL(MusicTrackName,'') AS MusicTrack,ISNULL(MovieAlbum,'') AS MovieAlbum,ISNULL(SongType,'') AS SongType,ISNULL(FromTime,'') AS TCIn,ISNULL(FromFrame,'') AS TCInFrame,
			ISNULL(ToTime,'') AS TCOut,ISNULL(ToFrame,'') AS TCOutFrame,ISNULL(DurationTime,'') AS Duration,ISNULL(DurationFrame,'') AS DurationFrame,ISNULL([dbo].[UFNGetErrorList](ISNULL(ErrorMessage,'')),'')AS ErrorMessage  
			FROM MHCueSheetSong WHERE MHCueSheetCode = @CueSheetCode AND RecordStatus = 'E'
		END
	ELSE IF(@ViewOn = 'W')
		BEGIN
			SELECT ISNULL(TitleName,'') AS [ShowName],ISNULL(EpisodeNo,'') AS Episode, ISNULL(MusicTrackName,'') AS MusicTrack,ISNULL(MovieAlbum,'') AS MovieAlbum,ISNULL(SongType,'') AS SongType,ISNULL(FromTime,'') AS TCIn,ISNULL(FromFrame,'') AS TCInFrame,
			ISNULL(ToTime,'') AS TCOut,ISNULL(ToFrame,'') AS TCOutFrame,ISNULL(DurationTime,'') AS Duration,ISNULL(DurationFrame,'') AS DurationFrame,ISNULL([dbo].[UFNGetErrorList](ISNULL(ErrorMessage,'')),'') AS ErrorMessage  
			FROM MHCueSheetSong WHERE MHCueSheetCode = @CueSheetCode AND RecordStatus = 'W'
		END
	ELSE
		BEGIN	
			SELECT ISNULL(TitleName,'') AS [ShowName],ISNULL(EpisodeNo,'') AS Episode, ISNULL(MusicTrackName,'') AS MusicTrack,ISNULL(MovieAlbum,'') AS MovieAlbum,ISNULL(SongType,'') AS SongType,ISNULL(FromTime,'') AS TCIn,ISNULL(FromFrame,'') AS TCInFrame,
			ISNULL(ToTime,'') AS TCOut,ISNULL(ToFrame,'') AS TCOutFrame,ISNULL(DurationTime,'') AS Duration,ISNULL(DurationFrame,'') AS DurationFrame,ISNULL([dbo].[UFNGetErrorList](ISNULL(ErrorMessage,'')),'') AS ErrorMessage  
			FROM MHCueSheetSong WHERE MHCueSheetCode = @CueSheetCode 
		END
END

