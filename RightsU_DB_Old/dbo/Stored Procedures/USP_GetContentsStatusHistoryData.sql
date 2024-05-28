CREATE PROC USP_GetContentsStatusHistoryData
(
	@Title_Content_Code BIGINT
)
AS
/*==============================================
Author:			Abhaysingh N. Rajpurohit
Create date:	02 Sep, 2016
Description:	Get Content Status History data
===============================================*/
BEGIN
	SELECT CSH.Content_Status_History_Code,
	CASE CSH.User_Action 
		WHEN 'C' THEN 'Updated'
		WHEN 'U' THEN 'Updated'
		WHEN 'I' THEN 'Added'
		WHEN 'D' THEN 'Deleted'
	END AS [Status],  
	CSH.Created_On AS Created_On, 
	LTRIM(RTRIM(ISNULL(U.First_Name, '') + ISNULL(' ' + U.Last_Name, '')))+ ' (' + SG.Security_Group_Name + ')'  AS Created_By, 
	(
		CASE WHEN CSH.User_Action = 'C' THEN 'Content updated' ELSE CAST(CSH.Record_Count AS VARCHAR) + ' Music track' END + 
		CASE WHEN CSH.User_Action != 'C' AND CSH.Record_Count > 1 THEN 's' ELSE '' END + ' ' +
		CASE CSH.User_Action 
			WHEN 'I' THEN 'added'
			WHEN 'U' THEN 'updated'
			WHEN 'D' THEN 'deleted'
			WHEN 'B' THEN 'imported'
			ELSE ''
		END
	) AS Remarks 
	FROM Content_Status_History CSH
	INNER JOIN Users U ON CSH.User_Code  = u.Users_Code
	INNER JOIN Security_Group SG ON U.Security_Group_Code = SG.Security_Group_Code
	WHERE CSH.Title_Content_Code = @Title_Content_Code
	ORDER BY CSH.Content_Status_History_Code DESC
END
