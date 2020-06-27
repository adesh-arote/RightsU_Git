CREATE PROCEDURE [dbo].[USP_Acq_Licensor_List]
@Vendor_code int
as
begin
	SELECT * from Acq_Deal
end