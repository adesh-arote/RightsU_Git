CREATE PROC [dbo].[USP_Acq_Syn_Pending_Appr]
AS
--====================================
-- Created By : Akshay Rane
-- Created Date : 25 July 2019
--====================================
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Syn_Pending_Appr]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SELECT A.Agreement_No, A.Deal_Rights_Code, A.MinuteDiff, A.ProcessName, A.Record_Status FROM (
			SELECT 
				AD.Agreement_No,
				'Pending' AS [Record_Status],
				0 AS Deal_Rights_Code, 
				DATEDIFF(MINUTE,DP.Inserted_On, GETDATE() + 1) AS MinuteDiff ,
				'Deal_Process' AS 'ProcessName'
			FROM Deal_Process DP (NOLOCK) INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = DP.Deal_Code
			WHERE DP.Record_Status = 'P'
			UNION
			SELECT DISTINCT 
				AD.Agreement_No, 
				'Pending' AS [Record_Status], 
				DRP.Deal_Rights_Code  ,
				DATEDIFF(MINUTE,DRP.Inserted_On, GETDATE() + 1) AS MinuteDiff , 
				'Deal_Rights_Process' AS 'ProcessName'
			FROM Deal_Rights_Process DRP (NOLOCK) INNER JOIN Acq_Deal AD (NOLOCK) ON  AD.Acq_Deal_Code = DRP.Deal_Code
			WHERE Record_Status = 'P'
			GROUP BY  AD.Agreement_No, DRP.Deal_Rights_Code, DRP.Inserted_On
		) AS A ORDER BY A.ProcessName, A.Agreement_No, A.Deal_Rights_Code, A.MinuteDiff

	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Syn_Pending_Appr]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
-- EXEC USP_TransactionLog
