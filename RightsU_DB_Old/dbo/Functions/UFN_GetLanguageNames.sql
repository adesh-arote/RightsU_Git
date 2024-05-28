

CREATE FUNCTION UFN_GetLanguageNames
(
	@Languages VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- =============================================
	-- Author:		Faisal Khan
	-- Create date: 07 Jul, 2016
	-- Description:	Returns language names
	-- =============================================

	DECLARE @Result VARCHAR(MAX)
	
	DECLARE @Language_Names VARCHAR(MAX)
	SET @Language_Names = ''
	
	SELECT @Language_Names = ISNULL(tbl.Names, '') FROM (
		SELECT Distinct STUFF(
		   (SELECT ', ' + CAST(Language_Name AS VARCHAR(100)) [text()]
			FROM Language 
			WHERE CAST(Language_Code AS VARCHAR) IN (select number from fn_Split_withdelemiter(REPLACE(@Languages, 'L', ''), ',')) 
			ORDER BY Language_Name 
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'') Names
		FROM Language L
		GROUP BY Language_Name 
	) AS TBL
	
	DECLARE @Language_Group_Names VARCHAR(MAX)
	SET @Language_Group_Names = ''
	
	SELECT @Language_Group_Names = ISNULL(tbl.Names, '') FROM (
		SELECT Distinct STUFF(
		   (SELECT ', ' + CAST(Language_Group_Name AS VARCHAR(200)) [text()]
			FROM Language_Group 
			WHERE CAST(Language_Group_Code AS VARCHAR) IN (select number from fn_Split_withdelemiter(REPLACE(@Languages, 'G', ''), ',')) 
			ORDER BY Language_Group_Name 
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'') Names
		FROM Language_Group LG
		GROUP BY Language_Group_Name 
	) AS TBL
	
	SET @Result = @Language_Group_Names + ', ' + @Language_Names
	
	IF (LEFT(@Result, 1) = ',')
		SET @Result = SUBSTRING(@Result, 3, LEN(@Result))
	
	IF (RIGHT(LTRIM(RTRIM(@Result)), 1) = ', ')
		SET @Result = LEFT(@Result, LEN(@Result) - 1)

	RETURN @Result

END