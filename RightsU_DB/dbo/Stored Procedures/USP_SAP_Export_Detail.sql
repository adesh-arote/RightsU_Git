CREATE PROCEDURE [dbo].[USP_SAP_Export_Detail]
(
	@File_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 21 May 2015
-- Description:	SAP Export Detail
-- =============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_SAP_Export_Detail]', 'Step 1', 0, 'Started Procedure', 0, ''

		SELECT SAP_Export_Code, WBS_Code, File_Code, WBS_Start_Date, WBS_End_Date, Acknowledgement_Status, Error_Details FROM SAP_Export (NOLOCK)  WHERE File_Code = @File_Code
 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_SAP_Export_Detail]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
