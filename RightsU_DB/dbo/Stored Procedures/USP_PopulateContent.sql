CREATE PROCEDURE [dbo].[USP_PopulateContent]
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
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_PopulateContent]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		DECLARE @dealTypeCodeForAllowAssignMusic VARCHAR(150) = ''
		SELECT TOP 1 @dealTypeCodeForAllowAssignMusic = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'DealTypeCodeFor_AllowAssignMusic'

		SELECT DISTINCT ISNULL(TC.Episode_Title, T.Title_Name) AS Content_Name , TC.Title_Code
		FROM Title_Content TC (NOLOCK)
		INNER JOIN Title T (NOLOCK) ON T.Title_Code = TC.Title_Code AND T.Deal_Type_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@dealTypeCodeForAllowAssignMusic, ','))
		WHERE TC.Episode_Title LIKE N'%' + @searchPrefix + '%' OR T.Title_Name LIKE N'%' + @searchPrefix + '%'
	 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_PopulateContent]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
