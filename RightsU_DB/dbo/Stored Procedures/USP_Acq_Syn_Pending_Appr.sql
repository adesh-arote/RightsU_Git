CREATE PROC USP_Acq_Syn_Pending_Appr
AS
--====================================
-- Created By : Akshay Rane
-- Created Date : 25 July 2019
--====================================
BEGIN
	SELECT A.Agreement_No, A.Deal_Rights_Code, A.MinuteDiff, A.ProcessName, A.Record_Status FROM (
		SELECT 
			AD.Agreement_No,
			'Pending' AS [Record_Status],
			0 AS Deal_Rights_Code, 
			DATEDIFF(MINUTE,DP.Inserted_On, GETDATE() + 1) AS MinuteDiff ,
			'Deal_Process' AS 'ProcessName'
		FROM Deal_Process DP INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = DP.Deal_Code
		WHERE DP.Record_Status = 'P'
		UNION
		SELECT DISTINCT 
			AD.Agreement_No, 
			'Pending' AS [Record_Status], 
			DRP.Deal_Rights_Code  ,
			DATEDIFF(MINUTE,DRP.Inserted_On, GETDATE() + 1) AS MinuteDiff , 
			'Deal_Rights_Process' AS 'ProcessName'
		FROM Deal_Rights_Process DRP INNER JOIN Acq_Deal AD ON  AD.Acq_Deal_Code = DRP.Deal_Code
		WHERE Record_Status = 'P'
		GROUP BY  AD.Agreement_No, DRP.Deal_Rights_Code, DRP.Inserted_On
	) AS A ORDER BY A.ProcessName, A.Agreement_No, A.Deal_Rights_Code, A.MinuteDiff
END
-- EXEC USP_TransactionLog
