CREATE PROCEDURE [dbo].[USPMHGetTitleEpisode]    
@TitleCode INT
AS
BEGIN
	SELECT ISNULL(MIN(Episode_No),'') AS MinEpisode, ISNULL(MAX(Episode_No),'') AS MaxEpisode
	FROM Title_Content
	WHERE Title_Code = @TitleCode
END

