CREATE Function [dbo].[UFN_Get_Vendor_Roles](@VendorCode Int)
Returns NVARCHAR(600)
As
-- =============================================    
-- Author:  Adesh
-- Create date: 30-Sep-2014
-- Description: <Get stb number from sub id, ,>    
-- =============================================   
Begin
     
	Declare @VendorName As NVARCHAR(1000) = ''
    
	Select @VendorName = cast(r.Role_Name as NVARCHAR(50)) + ', ' + @VendorName From Vendor_Role vr
	Inner Join [Role] r on r.Role_Code=vr.Role_Code
	Where vr.Vendor_Code = @vendorCode

	If(Len(@VendorName) > 1)
		Return Left(@VendorName, len(@VendorName) - 1)

	return @VendorName
 
end
