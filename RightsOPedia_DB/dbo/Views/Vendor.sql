


CREATE VIEW [dbo].[Vendor]
AS
SELECT Vendor_Code, Vendor_Name FROM RightsU_Plus_Testing.dbo.Vendor WHERE Is_Active = 'Y' AND Party_Type = 'V'





