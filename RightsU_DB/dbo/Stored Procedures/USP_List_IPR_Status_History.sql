CREATE PROCEDURE [dbo].[USP_List_IPR_Status_History]
(
	@IPR_Rep_Code Int
)	
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_IPR_Status_History]', 'Step 1', 0, 'Started Procedure', 0, ''
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
		FROM IPR_REP_STATUS_HISTORY IPRSH  (NOLOCK)
		INNER JOIN USERS U (NOLOCK) ON U.USERS_CODE = IPRSH.Changed_By
		WHERE IPRSH.IPR_Rep_Code = @IPR_Rep_Code
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_IPR_Status_History]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
