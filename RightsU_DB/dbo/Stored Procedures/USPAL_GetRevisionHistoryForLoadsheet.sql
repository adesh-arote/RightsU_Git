CREATE Procedure [dbo].[USPAL_GetRevisionHistoryForLoadsheet]
@Record_Code INT
AS
BEGIN
	SELECT MSH.Module_Status_Code, MSH.status_changed_on AS [Last_Action_On], U.First_Name +' '+ U.Last_Name AS [Last_Action_By], MSH.Remarks AS [Remark]
	FROM Module_Status_History MSH 
	INNER JOIN Users U ON MSH.status_changed_by = U.users_code
	WHERE record_code = @Record_Code AND module_code = 264
END