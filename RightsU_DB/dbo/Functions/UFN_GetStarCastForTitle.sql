CREATE FUNCTION [dbo].[UFN_GetStarCastForTitle](@title_code AS INT) RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @retStr NVARCHAR(1000)
	SELECT  @retStr = coalesce(@retStr + ', ', '') + 
	(SELECT talent_name FROM talent tstar WHERE tstar.talent_code = tst.talent_code)  
	FROM title inner join Title_Talent tst ON tst.title_code = title.title_code  and Role_Code=2
	WHERE  title.title_code = @title_code
	RETURN ISNULL(@retStr,'')
END