CREATE PROCEDURE [dbo].[USPAL_GetRevisionHistoryForModule]
@Record_Code INT,
@Module_Code INT
AS
BEGIN
	SELECT MSH.Module_Status_Code, MSH.status_changed_on AS [Last_Action_On], U.First_Name +' '+ U.Last_Name AS [Last_Action_By], MSH.Remarks AS [Remark],
	CASE
		WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'W' THEN 'Sent for approval'
		WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'A' THEN 'Approved'
		WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'R' THEN 'Rejected'
		WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'E' THEN 'Updated'
		ELSE '' 
	END AS [Workflow Status]
	--MSH.Status AS [Workflow Status]
	FROM Module_Status_History MSH 
	INNER JOIN Users U ON MSH.status_changed_by = U.users_code
	WHERE MSH.Record_Code = @Record_Code AND MSH.Module_Code = @Module_Code
END