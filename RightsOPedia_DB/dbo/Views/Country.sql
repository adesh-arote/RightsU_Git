


CREATE VIEW [dbo].[Country]
AS
SELECT Country_Code, Country_Name, Is_Theatrical_Territory AS [Is_Theatrical] FROM RightsU_Plus_Testing.dbo.Country WHERE Is_Active = 'Y'





