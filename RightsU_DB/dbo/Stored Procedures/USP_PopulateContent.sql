CREATE PROCEDURE USP_PopulateContent
(
	@searchPrefix NVARCHAR(200) = N''
)
AS

/*==============================================
Author:			Abhaysingh N. Rajpurohit
Create date:	29 Aug, 2016
Description:	This is for Autocomplete Content
===============================================*/

BEGIN
	DECLARE @dealTypeCodeForAllowAssignMusic VARCHAR(150) = ''
	SELECT TOP 1 @dealTypeCodeForAllowAssignMusic = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'DealTypeCodeFor_AllowAssignMusic'

	SELECT DISTINCT ISNULL(TC.Episode_Title, T.Title_Name) AS Content_Name , TC.Title_Code
	FROM Title_Content TC
	INNER JOIN Title T ON T.Title_Code = TC.Title_Code AND T.Deal_Type_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@dealTypeCodeForAllowAssignMusic, ','))
	WHERE TC.Episode_Title LIKE N'%' + @searchPrefix + '%' OR T.Title_Name LIKE N'%' + @searchPrefix + '%'
END
