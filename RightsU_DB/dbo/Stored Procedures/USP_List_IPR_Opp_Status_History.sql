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
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_IPR_Opp_Status_History]', 'Step 1', 0, 'Started Procedure', 0, ''
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
		FROM IPR_Opp_Status_History IPOSH (NOLOCK)
		INNER JOIN USERS U (NOLOCK) ON U.USERS_CODE = IPOSH.Changed_By
		WHERE IPOSH.IPR_Opp_Code = @IPR_Opp_Code
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_IPR_Opp_Status_History]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
