CREATE PROCEDURE [dbo].[USPVWTitleList]  
	@searchString nvarchar(max),  
	@contentType nvarchar(max)   
AS  
BEGIN  
	SET FMTONLY OFF  
	BEGIN  
		SELECT Title_Code,Title_Name, 0  AS Title_Content_Code FROM VWTitle WHERE Title_Name like '%'+@searchString+'%'  
	END  
END  