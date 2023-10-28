CREATE PROCEDURE [dbo].[USP_Import_Log]
AS

BEGIN 
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Import_Log]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET NOCOUNT ON;

		SELECT IL.Import_Log_Code, DM.File_Name, 
		CASE
			WHEN IL.Record_Type = 'T' THEN 'Title'
			WHEN IL.Record_Type = 'M' THEN 'Music'
			WHEN IL.Record_Type = 'C' THEN 'Content Music'
		END
		AS Record_Type, 
		CASE 
			WHEN DM.Status = 'S' THEN 'Success'
			WHEN DM.Status = 'N' THEN 'No Change'
			WHEN DM.Status = 'Q' THEN 'It is in queuing'
			WHEN DM.Status = 'R' THEN 'Resolve Conflict'
			WHEN DM.Status = 'SR' THEN 'System Mapped Conflict'
			WHEN DM.Status = 'T' THEN 'Transaction Error(Contact to administator)'
			WHEN DM.Status = 'W' THEN 'Waiting'
			WHEN DM.Status = 'E' THEN 'Error'
		END
		AS Status,
		IL.Process_Start, IL.Process_End
		FROM Import_Log IL (NOLOCK)
		INNER JOIN DM_Master_Import DM (NOLOCK) ON IL.Record_Code = DM.DM_Master_Import_code;
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Import_Log]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END