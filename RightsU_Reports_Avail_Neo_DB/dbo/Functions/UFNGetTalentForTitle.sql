CREATE FUNCTION [dbo].[UFNGetTalentForTitle](@Title_Code AS INT, @Role_Code INT) RETURNS NVARCHAR(500)
AS
BEGIN
	DECLARE @retStr NVARCHAR(500)

	SELECT @retStr = COALESCE(@retStr + ', ', '') + (SELECT Talent_Name FROM Talent tstar WHERE tstar.Talent_Code = tst.Talent_Code)  
	FROM Title
	INNER JOIN Title_Talent tst on tst.Title_Code = title.Title_Code AND Role_Code = @Role_Code
	WHERE title.Title_Code = @Title_Code

	RETURN ISNULL(@retStr,'')

END
