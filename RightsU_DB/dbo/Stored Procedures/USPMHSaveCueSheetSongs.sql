CREATE PROCEDURE [dbo].[USPMHSaveCueSheetSongs](
	@udt CueSheetSongsUDT READONLY,
	@CueSheetCode INT,
	@FileName NVARCHAR(MAX),
	@UsersCode INT,
	@CueSheetCodeOut INT OUT
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHSaveCueSheetSongs]', 'Step 1', 0, 'Started Procedure', 0, ''
	---- Your logic
		DECLARE @VendorCode INT, @RequestID NVARCHAR(MAX), @RecordsCount INT = 0
		Select @VendorCode = Vendor_Code from MHUsers (NOLOCK) WHERE Users_Code = @UsersCode
		
		SELECT @RecordsCount = COUNT(*) FROM @udt
			
		IF(@CueSheetCode = 0)
		BEGIN

			DECLARE @Temp TABLE (
				RequestID NVARCHAR(MAX)
			)
			INSERT INTO @Temp (RequestID) 
			EXEC USPMHGetRequestID @VendorCode,'CS'

			SET @RequestID = (SELECT * FROM @Temp)
			
			INSERT INTO MHCueSheet(RequestID, [FileName], UploadStatus, VendorCode, TotalRecords, ErrorRecords, CreatedBy, CreatedOn,SubmitBy,SubmitOn)
			VALUES(@RequestID, @FileName, 'P', @VendorCode, @RecordsCount, 0, @UsersCode, GETDATE(),@UsersCode, GETDATE())

			SET @CueSheetCode =  IDENT_CURRENT('MHCueSheet');
			SET @CueSheetCodeOut = @CueSheetCode

		END
		ELSE
		BEGIN

			DELETE FROM MHCueSheetSong WHERE MHCueSheetCode = @CueSheetCode

			UPDATE MHCueSheet SET FileName = @FileName, UploadStatus = 'P', TotalRecords = @RecordsCount, CreatedOn = GETDATE() WHERE MHCueSheetCode = @CueSheetCode

			SET @CueSheetCodeOut = @CueSheetCode
		END

		INSERT INTO [dbo].[MHCueSheetSong](MHCueSheetCode, TitleName, EpisodeNo, MusicTrackName,MovieAlbum,SongType, FromTime, FromFrame, ToTime, ToFrame, DurationTime, DurationFrame)
		SELECT @CueSheetCode, [Show Name], [Episode], [Music Track],[Movie/Album],[Usage Type], [TC IN], [TC IN Frame], [TC OUT], [TC OUT Frame], [Duration], [Duration Frame]
		FROM @udt

		--Select @CueSheetCode AS CueSheetCode
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHSaveCueSheetSongs]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
