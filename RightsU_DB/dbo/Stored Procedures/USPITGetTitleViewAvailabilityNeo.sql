CREATE PROCEDURE [dbo].[USPITGetTitleViewAvailabilityNeo]
@TitleCode VARCHAR(MAX)
AS
BEGIN
Declare @Loglevel int;
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewAvailabilityNeo]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	DECLARE @EXECSQLUDT NVARCHAR(MAX) = N'
		USE RightsU_Avail_Neo_V18		
		EXEC [USPITGetTitleViewAvailability] '+@TitleCode+''

		EXEC sp_executesql @EXECSQLUDT
	
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleViewAvailabilityNeo]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END