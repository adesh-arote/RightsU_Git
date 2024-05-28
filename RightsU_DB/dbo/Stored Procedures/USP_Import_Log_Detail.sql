CREATE PROCEDURE [dbo].[USP_Import_Log_Detail]
@importLogCode int
AS
BEGIN 
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Import_Log_Detail]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;
		SELECT cast(id.process_step_no AS NVARCHAR) + '.' + cast(id.process_Sub_step_no AS NVARCHAR) + '.' + cast(id.loop_counter AS NVARCHAR) AS 'Step No', id.Proc_Name, si.Status_Desc ,
		id.Process_Start, id.Process_Error_MSG
		FROM Import_Log_Detail AS id (NOLOCK)
		INNER JOIN Import_Status AS si (NOLOCK) on id.Short_Status_Code = si.Status_Short_Code
		INNER JOIN Import_Log IL (NOLOCK) ON IL.Import_Log_Code = id.Import_Log_Code 
		WHERE IL.Record_Code IN (Select Record_Code from Import_Log (NOLOCK) where Import_Log_Code = @importLogCode)
		--WHERE id.Import_Log_Code = @importLogCode
		order by Process_Start DEsc, [Step No] Desc
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Import_Log_Detail]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END