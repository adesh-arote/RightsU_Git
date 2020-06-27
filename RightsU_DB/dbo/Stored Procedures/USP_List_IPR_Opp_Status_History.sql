CREATE PROCEDURE [dbo].[USP_List_IPR_Opp_Status_History]
(
	@IPR_Opp_Code Int
)	
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 19 AUG 2015
-- Description:	IPR Opposition Status History
-- =============================================
BEGIN
	SET FMTONLY OFF
	select 
	CASE ISNULL(IPOSH.IPR_Status, '')
		WHEN 'N' THEN 'Created'
		WHEN 'E' THEN 'Modified'
		WHEN 'A' THEN 'Approved'
		else ''
	END AS IPR_Status , 
	CONVERT(varchar, IPOSH.Changed_On, 103) AS Changed_On, 
	U.first_name + ' ' + U.last_name AS UserName 
	FROM IPR_Opp_Status_History IPOSH
	INNER JOIN USERS U ON U.USERS_CODE = IPOSH.Changed_By
	WHERE IPOSH.IPR_Opp_Code = @IPR_Opp_Code
END