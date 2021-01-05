

CREATE PROCEDURE [dbo].[USP_List_IPR_Status_History]
(
	@IPR_Rep_Code Int
)	
AS
BEGIN
SET FMTONLY OFF
	select 
	CASE ISNULL(IPRSH.IPR_Status, '')
		WHEN 'N' THEN 'Created'
		WHEN 'E' THEN 'Modified'
		WHEN 'A' THEN 'Approved'
		else ''
	END AS IPR_Status , 
	CONVERT(varchar, IPRSH.Changed_On, 103) AS Changed_On, 
	U.first_name + ' ' + U.last_name AS UserName 
	FROM IPR_REP_STATUS_HISTORY IPRSH
	INNER JOIN USERS U ON U.USERS_CODE = IPRSH.Changed_By
	WHERE IPRSH.IPR_Rep_Code = @IPR_Rep_Code
END