




CREATE VIEW [dbo].[TitleTalent]
AS
SELECT TItle_Code, Talent_Code, Role_Code FROM RightsU_Plus_Testing.dbo.Title_Talent tr WHERE tr.Role_Code IN (4,2,1)





