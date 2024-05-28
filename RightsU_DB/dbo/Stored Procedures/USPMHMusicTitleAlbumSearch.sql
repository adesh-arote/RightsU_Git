CREATE Proc [dbo].[USPMHMusicTitleAlbumSearch]
(
	@keyword NVARCHAR(100), @Type NVARCHAR(50)
)
--Created By: Anchal Sikarwar
--Created On: 13 July 2018
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHMusicTitleAlbumSearch]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF(@Type = 'Music')
		BEGIN
			SELECT TOP 50 Music_Title_Code AS Code, Music_Title_Name AS [Name] FROM Music_Title (NOLOCK) WHERE Music_Title_Name Like '%'+@keyword+'%' and Is_Active='Y'
		END
		ELSE
		BEGIN
			SELECT TOP 50 Music_Album_Code AS Code, Music_Album_Name AS [Name] FROM Music_Album (NOLOCK) WHERE Music_Album_Name Like '%'+@keyword+'%' and Is_Active='Y'
		END
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHMusicTitleAlbumSearch]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END