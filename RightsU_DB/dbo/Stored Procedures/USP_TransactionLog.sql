CREATE PROC USP_TransactionLog
AS
--====================================
-- Created By : Akshay Rane
-- Created Date : 25 July 2019
--====================================
BEGIN
	CREATE TABLE #TmpLogSpace(
		DatabaseName VARCHAR(100)
	  , [Log Size (MB)] DECIMAL(18,5)
	  , [Log Space Used (%)] DECIMAL(18, 5)
	  , [Status] DECIMAL(18, 5)
	 ) 

	 INSERT #TmpLogSpace(DatabaseName, [Log Size (MB)], [Log Space Used (%)], Status) 
	 EXEC('DBCC SQLPERF(LOGSPACE);')

	 SELECT A.name AS 'Database_Name', CAST(A.[Total disk space] AS NVARCHAR(MAX)) AS 'Total_Disk_Space', ISNULL(B.[Log Size (MB)] , 0.00000 ) AS 'Log_Size_MB' FROM (
	 	SELECT sys.databases.name,CONVERT(VARCHAR, SUM(size) *8/1024)+' MB' AS[Total disk space]
	 	  FROM sys.databases
	 	  JOIN sys.master_files ON  sys.databases.database_id=sys.master_files.database_id GROUP BY sys.databases.name
	   ) AS A
	 LEFT JOIN #TmpLogSpace B ON A.name = B.DatabaseName
	 ORDER BY A.name

	 DROP TABLE #TmpLogSpace
END
-- EXEC USP_TransactionLog
