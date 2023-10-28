



CREATE VIEW [dbo].[Talent]
AS
SELECT DISTINCT t.Talent_Code, t.Talent_Name, tr.Role_Code 
FROM RightsU_Plus_Testing.dbo.Talent t
INNER JOIN RightsU_Plus_Testing.dbo.Talent_Role tr ON t.Talent_Code = tr.Talent_Code AND tr.Role_Code IN (4,2,1)
WHERE Is_Active = 'Y'





