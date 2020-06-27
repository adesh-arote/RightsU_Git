CREATE FUNCTION [dbo].[UFN_Get_Country_Names](@Country_Codes Varchar(2000), @RowId Int)
RETURNS @Tbl_Ret TABLE (
	Region_Code Int,
	Region_Name NVarchar(MAX)
) AS
BEGIN
	DECLARE @Country_Names NVARCHAR(MAX), @India_Country_Code INT
	SELECT @India_Country_Code = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'INDIA_COUNTRY_CODE'
	SELECT @Country_Names =	STUFF((
		SELECT DISTINCT  ', ' + (C.Country_Name) FROM Country C
		WHERE C.Country_Code IN(SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Codes,',')) AND C.Is_Active = 'Y'
		AND C.Country_Code != @India_Country_Code
		FOR XML PATH('')), 1, 1, ''
	) 

	INSERT INTO @Tbl_Ret(Region_Code, Region_Name)
	SELECT @RowId, @Country_Names
	RETURN
END