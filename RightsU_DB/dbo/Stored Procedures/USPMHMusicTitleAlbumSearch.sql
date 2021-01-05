CREATE Proc USPMHMusicTitleAlbumSearch(
	@keyword NVARCHAR(100), @Type NVARCHAR(50)
)
--Created By: Anchal Sikarwar
--Created On: 13 July 2018
AS
BEGIN
	IF(@Type = 'Music')
	BEGIN
		SELECT TOP 50 Music_Title_Code AS Code, Music_Title_Name AS [Name] FROM Music_Title WHERE Music_Title_Name Like '%'+@keyword+'%' and Is_Active='Y'
	END
	ELSE
	BEGIN
		SELECT TOP 50 Music_Album_Code AS Code, Music_Album_Name AS [Name] FROM Music_Album WHERE Music_Album_Name Like '%'+@keyword+'%' and Is_Active='Y'
	END
END

--exec USPMHMusicTitleAlbumSearch 'only',' '