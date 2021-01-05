CREATE PROC [dbo].[USPMHGetRequestID](@VendorCode INT,@RequestType VARCHAR(2))
AS
BEGIN
	
	DECLARE @Year VARCHAR(10), @ShortCode VARCHAR(20) = '', @RunningNo INT = 0--, @RequestID VARCHAR(50) = ''

	SELECT @Year = CAST(YEAR(GETDATE()) AS VARCHAR(10))
	--SELECT @Year
	
	SELECT @ShortCode = ISNULL(Short_Code, 'RQ') FROM Vendor WHERE Vendor_Code = @VendorCode
	
	IF(@ShortCode = '')
	BEGIN
		SET @ShortCode = 'RQ'
	END

	BEGIN TRAN

	IF NOT EXISTS(SELECT * FROM MHRequestIds WHERE VendorCode = @VendorCode AND FinYear = @Year AND RequestType = @RequestType)
	BEGIN
		INSERT INTO MHRequestIds(VendorCode, FinYear, RunningNo,RequestType)
		SELECT @VendorCode, @Year, 1,@RequestType

		SELECT @ShortCode + '-' + @RequestType + '-' + @Year + '-' + '00001' AS RequestID

	END
	ELSE
	BEGIN

		UPDATE MHRequestIds SET RunningNo = RunningNo + 1  WHERE VendorCode = @VendorCode AND FinYear = @Year AND RequestType = @RequestType
		SELECT @RunningNo = RunningNo FROM MHRequestIds  WHERE VendorCode = @VendorCode AND FinYear = @Year AND RequestType = @RequestType

		SELECT @ShortCode + '-' + @RequestType + '-' + @Year + '-' + RIGHT('0000' + CAST(@RunningNo AS VARCHAR(10)), 5) AS RequestID

	END

	COMMIT TRAN
	
END

/*
--USPMHGetRequestID ,'CS'
Select * From MHRequestIds
*/
