CREATE PROCEDURE [dbo].[USPGetMediaPlatforms]
@Attrib_Group_Code NVARCHAR(20) 
AS
BEGIN
	SELECT Distinct Platform_Hiearachy,Platform_Code FROM MediaPlatforms where Attrib_Group_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Attrib_Group_Code+'',','))
END

