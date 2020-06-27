CREATE FUNCTION [dbo].[UFN_GetGenresForTitle](@title_code AS INT) RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @retStr NVARCHAR(1000)

	SELECT  @retStr = coalesce(@retStr + ', ', '') + 
	(SELECT Genres_Name FROM Genres g WHERE g.Genres_Code = tg.Genres_Code)  
	FROM Title t
	LEFT OUTER JOIN Title_Geners AS tg ON t.Title_Code =tg.Title_Code
	WHERE t.Title_Code = @title_code
--select ISNULL(@retStr,'')
	RETURN ISNULL(@retStr,'')
 -- select dbo.f_GetStarCastForTitle(22)
END