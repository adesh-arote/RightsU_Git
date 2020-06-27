CREATE PROCEDURE USP_SAP_Export_Detail
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
	SELECT SAP_Export_Code, WBS_Code, File_Code, WBS_Start_Date, WBS_End_Date, Acknowledgement_Status, Error_Details FROM SAP_Export WHERE File_Code = @File_Code
END