CREATE Procedure USPMHGetTalents
@RoleCode INT,
@StrSearch NVARCHAR(MAX)
AS
BEGIN
	Select TOP 25 TR.Talent_Code AS TalentCode,T.Talent_Name AS TalentName from Talent_Role TR
	INNER JOIN Talent T On T.Talent_Code = TR.Talent_Code
	INNER JOIN ROLE R ON R.Role_Code = TR.Role_Code
	WHERE T.Talent_Name like '%'+@StrSearch+'%' AND TR.Role_Code = @RoleCode
	ORDER BY TR.Talent_Role_Code
END