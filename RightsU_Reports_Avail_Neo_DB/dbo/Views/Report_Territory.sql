CREATE VIEW [dbo].[Report_Territory]
AS
SELECT Territory_Code AS Report_Territory_Code, Territory_Name AS Report_Territory_Name, NULL AS Parent_Territory_Code, 'N' AS Is_language_Cluster, Is_Active FROM Territory
