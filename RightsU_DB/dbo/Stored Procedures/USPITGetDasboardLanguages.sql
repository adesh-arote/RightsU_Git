CREATE PROCEDURE [dbo].[USPITGetDasboardLanguages]
AS
BEGIN	
	
	DECLARE @LanguageNames NVARCHAR(MAX)
	SET @LanguageNames = (SELECT Parameter_Value FROM System_Parameter_New WITH(NOLOCK) WHERE Parameter_Name like '%DBLanguageNames_IT%')

	SELECT A.Language FROM (
	SELECT 'a' AS Sort,'ALL' AS Language
	UNION
	select 'b' AS Sort,number AS Language from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',',') 
	UNION
	Select 'c' AS Sort,'Others'
	) AS A
	Order by A.Sort
	
END
