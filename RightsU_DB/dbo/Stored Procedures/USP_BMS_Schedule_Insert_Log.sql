CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Insert_Log]	
(
	@ModuleName VARCHAR(100)
)
AS
-- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:	   <31 Aug 2016>
-- Description:    <Call from BMS_Schedule_Get SSIS Package>
-- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Insert_Log]', 'Step 1', 0, 'Started Procedure', 0, ''
		/*************************Start BV Log Code****/	
		DECLARE @BMS_Log_Code INT = 0    
		
		INSERT INTO BMS_Log(Module_Name, Method_Type, Request_Time, Request_Xml,Record_Status)    
		SELECT @ModuleName ,'GET',GETDATE(),NULL AS Request_Xml,'W' AS Record_Status

		SELECT @BMS_Log_Code = SCOPE_IDENTITY()

		SELECT @BMS_Log_Code AS BMS_Log_Code
		  
		/*************************/

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Insert_Log]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
