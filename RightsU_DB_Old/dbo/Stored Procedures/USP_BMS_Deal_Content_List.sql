CREATE PROCEDURE [dbo].[USP_BMS_Deal_Content_List]
	@Asset_Code INT
AS
BEGIN
	SELECT (SELECT Agreement_No FROM Acq_Deal WHERE Acq_Deal_Code IN (SELECT Acq_Deal_Code from BMS_Deal AS BD WHERE BD.BMS_Deal_Code=BDC.BMS_Deal_Code) ) 
	as Agreement_No,
	Start_Date,
	End_Date,
	Record_Status AS Status ,
	Error_Description AS Error
FROM BMS_Deal_Content BDC

END

