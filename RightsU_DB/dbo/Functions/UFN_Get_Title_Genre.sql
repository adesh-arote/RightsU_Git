CREATE Function [dbo].[UFN_Get_Title_Genre]
(
	@Title_Code AS INT
) 
RETURNS NVARCHAR(4000)
AS
BEGIN
	DECLARE @genre NVARCHAR(4000)
	SET @genre = ''

	SELECT @genre = @genre + g.genres_name + ', ' FROM Title_Geners tg
	INNER JOIN Genres g on tg.genres_code = g.genres_code
	WHERE tg.title_code = @title_code

	if(LEN(@genre) >= 1)
		SET @genre = LEFT(@genre, LEN(@genre) - 1);

	Return @genre
END
