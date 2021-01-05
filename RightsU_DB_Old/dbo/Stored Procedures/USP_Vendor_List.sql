CREATE PROCEDURE [dbo].[USP_Vendor_List]
@Vendor_Code INT
AS
BEGIN
	Select Vendor_Name AS LicensorName, Ref_Vendor_Key AS RefKey, (select Count(*) FROM Acq_Deal A Where A.Vendor_Code = V.Vendor_Code) AS Ref_Count,
	V.Record_Status AS Status FROM Vendor V
END


