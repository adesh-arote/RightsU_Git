CREATE PROCEDURE USPMHAutoApproveUsageRequest
@MHRequestCode INT,
@UserCode INT
AS
BEGIN
	DECLARE
	@CountDetails INT,
	@CountIsValid INT
	
	SELECT @CountDetails = COUNT(*)  FROM MHRequestDetails where MHRequestCode = @MHRequestCode
	Print @CountDetails
	SELECT @CountIsValid = COUNT(*) FROM MHRequestDetails where MHRequestCode = @MHRequestCode AND IsValid = 'Y'
	Print @CountIsValid

	IF(@CountDetails = @CountIsValid)
	BEGIN	
		UPDATE MHRequestDetails SET IsApprove = 'Y'
		WHERE MHRequestCode = @MHRequestCode

		UPDATE MHRequest SET MHRequestStatusCode = 1,ApprovedOn = GETDATE(),ApprovedBy = @UserCode
		WHERE MHRequestCode = @MHRequestCode

		EXEC USPMHMailNotification @MHRequestCode,1,0
	END
END
--Select * from  MHrequeststatus
--Select * from MHRequest where MHRequestCode = 236
--Select ISVAlid,* from MHRequestDetails where ISValid = 'N' --HRequestCode = 236