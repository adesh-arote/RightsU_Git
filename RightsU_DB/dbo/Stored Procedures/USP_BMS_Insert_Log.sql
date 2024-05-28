



CREATE PROCEDURE [dbo].[USP_BMS_Insert_Log]
(
	@moduleName VARCHAR(100),
	@methodType VARCHAR(50),
	@requestTime DATETIME,
	@responseTime DATETIME,
	@requestXML NVARCHAR(MAX),
	@responseXML NVARCHAR(MAX),
	@recordStatus CHAR(1),
	@errorDescription NVARCHAR(MAX)
)
AS

BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Insert_Log]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	INSERT INTO BMS_Log (Module_Name,Method_Type,Request_Time,Response_Time,Request_Xml,Response_Xml,Record_Status,Error_Description)
	VALUES (@moduleName,@methodType,@requestTime,@responseTime,@requestXML,@responseXML,@recordStatus,@errorDescription)

	SELECT SCOPE_IDENTITY()


	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Insert_Log]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END