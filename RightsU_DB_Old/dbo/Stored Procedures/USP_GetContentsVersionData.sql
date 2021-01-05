CREATE PROC USP_GetContentsVersionData
(
	@Title_Content_Code BIGINT
)
AS
/*==============================================
Author:			Sayali Surve
Create date:	03 Apr 2017
Description:	Get Content Version data
===============================================*/
BEGIN
	--Declare @Title_Content_Code BIGINT = 7013
	SELECT TCV.Title_Content_Version_Code, V.Version_Code, V.Version_Name, CAST(TCVD.House_Id AS NVARCHAR(MAX)) AS [House_Id], TCV.Duration
	FROM Title_Content_Version TCV 
	INNER JOIN [Version] V ON V.Version_Code = TCV.Version_Code AND TCV.Title_Content_Code = @Title_Content_Code
	INNER JOIN Title_Content_Version_Details TCVD ON TCV.Title_Content_Version_Code = TCVD.Title_Content_Version_Code
END
