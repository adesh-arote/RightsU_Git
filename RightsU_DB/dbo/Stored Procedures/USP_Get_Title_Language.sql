CREATE PROC [dbo].[USP_Get_Title_Language]
(    
 @Title_Codes  VARCHAR(MAX)
)     
AS 
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 19-December-2014
-- Description:	Get title language name of selected titles.
--				If Title Language is more than one for seleted titles so return title language name as "Multiple Language" else Language name 
-- =============================================       
BEGIN  
	--DECLARE @Title_Codes VARCHAR(MAX)
	--SET @Title_Codes = '6415,6416'

	DECLARE @Count INT = 0, @ReturnString NVARCHAR(200) = ''
	select @Count = COUNT(Distinct T.Title_Language_Code) from Title T 
	where T.Title_Code in (SELECT number FROM fn_Split_withdelemiter(@Title_Codes, ','))
	IF(@Count = 0)
		SET @ReturnString = ''
	ELSE IF(@Count = 1)
		select TOP 1 @ReturnString = l.Language_Name from Title T 
		INNER JOIN Language L on L.Language_Code = T.Title_Language_Code
		where T.Title_Code in (SELECT number FROM fn_Split_withdelemiter(@Title_Codes, ','))
	ELSE
		SET @ReturnString = 'Multiple Language'

	SELECT @ReturnString  AS 'Language_Name'
END  

--EXEC [USP_Get_Title_Language] '1,2,3,4'
