CREATE Function [dbo].[UFN_Get_Music_Title_Metadata_By_Role_Code]
(
	@Music_Title_Code AS INT,
	@Role_Code AS INT
) 
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @metaData nVARCHAR(MAX)
	SET @metaData = ''

	SELECT @metaData = @metaData + ISNULL(T.Talent_Name, '') + ', ' FROM Music_Title_Talent MTT 
	INNER JOIN Talent T ON T.Talent_Code = MTT.Talent_Code
	WHERE MTT.Music_Title_Code = @Music_Title_Code AND MTT.Role_Code = @Role_Code
	
	IF(LEN(@metaData) >= 1)
		SET @metaData = LEFT(@metaData, LEN(@metaData) - 1)

	Return @metaData
END
