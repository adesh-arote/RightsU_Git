

CREATE FUNCTION UFN_GetRegionNames
(
	@Regions VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- =============================================
	-- Author:		Faisal Khan
	-- Create date: 07 Jul, 2016
	-- Description:	Returns region names
	-- =============================================

	DECLARE @Result VARCHAR(MAX)
	
	DECLARE @Territory_Names VARCHAR(MAX)
	SET @Territory_Names = ''
	
	SELECT @Territory_Names = ISNULL(tbl.Names, '') FROM (
		SELECT Distinct STUFF(
		   (SELECT ', ' + CAST(Territory_Name AS VARCHAR(1000)) [text()]
			FROM Territory 
			WHERE CAST(Territory_Code AS VARCHAR) IN (select number from fn_Split_withdelemiter(REPLACE(@Regions, 'T', ''), ',')) 
			ORDER BY Territory_Name 
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'') Names
		FROM Territory T
		GROUP BY Territory_Name 
	) AS TBL
	
	DECLARE @Country_Names VARCHAR(MAX)
	SET @Country_Names = ''
	
	SELECT @Country_Names = ISNULL(tbl.Names, '') FROM (
		SELECT Distinct STUFF(
		   (SELECT ', ' + CAST(Country_Name AS VARCHAR(100)) [text()]
			FROM Country 
			WHERE CAST(Country_Code AS VARCHAR) IN (select number from fn_Split_withdelemiter(REPLACE(@Regions, 'C', ''), ',')) 
			ORDER BY Country_Name 
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'') Names
		FROM Country C
		GROUP BY Country_Name 
	) AS TBL
	
	SET @Result = @Territory_Names + ', ' + @Country_Names
	
	IF (LEFT(@Result, 1) = ',')
		SET @Result = SUBSTRING(@Result, 3, LEN(@Result))
	
	IF (RIGHT(LTRIM(RTRIM(@Result)), 1) = ', ')
		SET @Result = LEFT(@Result, LEN(@Result) - 1)

	RETURN @Result

END