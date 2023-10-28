CREATE FUNCTION [dbo].[UFN_Get_Indiacast_Report_Country](@Country_Code VARCHAR(4000), @RowId INT)  
	RETURNS @Tbl_Ret TABLE (  
	 Region_Code INT,  
	 Region_Name NVARCHAR(MAX)  
)
 AS  
BEGIN                                   
 --Declare @Country_Code_Str Varchar(2000) = '1,12,15,17,2,36,48'  
 --DECLARE @Country_Code VARCHAR(2000) = '1,15,2,36,48,17,15,12,56,89,45248,589,698'  
 --Declare @RowId Int = 1  
   
 --Declare @Tbl_Ret TABLE (  
 -- Region_Code Int,  
 -- Region_Name_In NVarchar(MAX),  
 -- Region_Name_NOTIn NVarchar(MAX)  
 --)  
	DECLARE @Temp_Country AS TABLE(  
		Country_Code INT  
	)  
	DECLARE @Indiacast_Avail_India_Code varchar(5)
	SELECT  @Indiacast_Avail_India_Code = Parameter_Value FROM System_Parameter_New where Parameter_Name ='India_Avail'

	INSERT INTO @Temp_Country(Country_Code)  
	SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code,',') WHERE number NOT IN('0', '')  
  
	DELETE FROM @Temp_Country WHERE Country_Code = 0  
  
	DECLARE @Country_Name NVARCHAR(MAX),  @Country_Name_Not_IN NVARCHAR(MAX)  
  
	set @Country_Name =  Ltrim(STUFF((  
		Select Distinct ', ' + C.Country_Name From @Temp_Country TC  
		INNER JOIN Country C ON C.Country_Code = TC.Country_Code  
		WHERE TC.Country_Code IN(SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code,','))  AND TC.Country_Code NOT IN(@Indiacast_Avail_India_Code)
		FOR XML PATH('')  
	), 1, 1, ''))  
  

  
	Insert InTo @Tbl_Ret(Region_Code, Region_Name)  
	Select @RowId, @Country_Name  
	RETURN  
END  
  
--SELECT * FROM DBO.UFN_Get_Report_Country('1,12,15,17,2,36,48', '1,15,2,36,48,17,15,12,56,89,45248,589,698', 1)    