CREATE PROCEDURE USP_Title_Import_Utility_Schedule
AS
BEGIN
	DECLARE @DM_Master_Import_Code INT = 0

	DECLARE db_cursor CURSOR FOR 
	select DM_Master_Import_Code FROM DM_Master_Import WHERE FILE_Type = 'T' AND Status in ('N','I')

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @DM_Master_Import_Code
	
	WHILE @@FETCH_STATUS = 0  
	BEGIN 	
		EXEC USP_Title_Import_Utility_PIII @DM_Master_Import_Code
		FETCH NEXT FROM db_cursor INTO @DM_Master_Import_Code
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 
END