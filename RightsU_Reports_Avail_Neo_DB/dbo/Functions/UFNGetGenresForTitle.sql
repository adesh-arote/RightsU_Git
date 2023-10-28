CREATE FUNCTION [dbo].[UFNGetGenresForTitle](@Title_Code AS INT) RETURNS NVARCHAR(500)
AS
BEGIN

	DECLARE @retStr NVARCHAR(500)

	SELECT  @retStr = COALESCE(@retStr + ', ', '') + (SELECT Genres_Name FROM Genres g WHERE g.Genres_Code = tg.Genres_Code)  
	FROM Title t
	LEFT OUTER JOIN Title_Geners AS tg ON t.Title_Code = tg.Title_Code
	WHERE  t.Title_Code = @Title_Code

	RETURN ISNULL(@retStr,'')
 
END
