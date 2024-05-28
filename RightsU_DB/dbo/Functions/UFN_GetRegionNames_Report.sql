CREATE FUNCTION [dbo].[UFN_GetRegionNames_Report]
(
	@Regions NVARCHAR(MAX),
	@Region_Type CHAR(1)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- =============================================
	-- Author:		Faisal Khan
	-- Create date: 07 Jul, 2016
	-- Description:	Returns region names
	-- =============================================

	DECLARE @Result NVARCHAR(MAX)
	
	DECLARE @Territory_Names NVARCHAR(MAX)
	SET @Territory_Names = ''
	
	IF(@Region_Type = 'T')
	BEGIN
		SELECT @Territory_Names = ISNULL(tbl.Names, '') FROM (
			SELECT Distinct STUFF(
			   (SELECT ', ' + CAST(Territory_Name AS NVARCHAR(1000)) [text()]
				FROM Territory 
				WHERE CAST(Territory_Code AS VARCHAR) IN (select number from fn_Split_withdelemiter(@Regions, ',')) 
				ORDER BY Territory_Name 
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'') Names
			FROM Territory T
			GROUP BY Territory_Name 
		) AS TBL
	END

	DECLARE @Country_Names NVARCHAR(MAX)
	SET @Country_Names = ''
	
	IF(@Region_Type = 'C')
	BEGIN
		SELECT @Country_Names = ISNULL(tbl.Names, '') FROM (
			SELECT Distinct STUFF(
			   (SELECT ', ' + CAST(Country_Name AS NVARCHAR(100)) [text()]
				FROM Country 
				WHERE CAST(Country_Code AS VARCHAR) IN (select number from fn_Split_withdelemiter(@Regions, ',')) 
				ORDER BY Country_Name 
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'') Names
			FROM Country C
			GROUP BY Country_Name 
		) AS TBL
	END
	SET @Result = @Territory_Names + ', ' + @Country_Names
	
	IF (LEFT(@Result, 1) = ',')
		SET @Result = SUBSTRING(@Result, 3, LEN(@Result))
	
	IF (RIGHT(LTRIM(RTRIM(@Result)), 1) = ', ')
		SET @Result = LEFT(@Result, LEN(@Result) - 1)

	RETURN @Result

END
