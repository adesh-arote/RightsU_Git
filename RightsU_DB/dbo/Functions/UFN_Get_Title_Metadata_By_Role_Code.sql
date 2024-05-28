CREATE Function [dbo].[UFN_Get_Title_Metadata_By_Role_Code]
(
	@Title_Code AS INT,
	@Role_Code AS INT
) 
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @metaData NVARCHAR(MAX)
	SET @metaData = ''

	SELECT @metaData = @metaData + ISNULL(TAT.talent_name, '') + ', ' FROM Title_Talent TT 
	INNER JOIN Talent TAT ON TAT.talent_code = TT.talent_code
	WHERE TT.title_code = @Title_Code AND TT.role_code = @Role_Code
	
	IF(LEN(@metaData) >= 1)
		SET @metaData = LEFT(@metaData, LEN(@metaData) - 1)

	Return @metaData
END
