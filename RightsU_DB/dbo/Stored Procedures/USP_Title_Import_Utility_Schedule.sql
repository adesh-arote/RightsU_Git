CREATE PROCEDURE [dbo].[USP_Title_Import_Utility_Schedule]
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_Utility_Schedule]', 'Step 1', 0, 'Started Procedure', 0, '' 
		DECLARE @DM_Master_Import_Code INT = 0

		DECLARE db_cursor CURSOR FOR 
		select DM_Master_Import_Code FROM DM_Master_Import (NOLOCK) WHERE FILE_Type = 'T' AND Status in ('N','I')

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @DM_Master_Import_Code
	
		WHILE @@FETCH_STATUS = 0  
		BEGIN 	
			EXEC USP_Title_Import_Utility_PIII @DM_Master_Import_Code
			FETCH NEXT FROM db_cursor INTO @DM_Master_Import_Code
		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor 
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_Utility_Schedule]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END