CREATE PROCEDURE [dbo].[USPMHGetTitleEpisode]    
@TitleCode INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetTitleEpisode]', 'Step 1', 0, 'Started Procedure', 0, ''
		SELECT ISNULL(MIN(Episode_No),'') AS MinEpisode, ISNULL(MAX(Episode_No),'') AS MaxEpisode
		FROM Title_Content (NOLOCK)
		WHERE Title_Code = @TitleCode
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetTitleEpisode]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END

