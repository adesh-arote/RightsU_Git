CREATE PROCEDURE [dbo].[USPMHAutoApproveUsageRequest]
@MHRequestCode INT,
@UserCode INT
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHAutoApproveUsageRequest]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE
		@CountDetails INT,
		@CountIsValid INT
	
		SELECT @CountDetails = COUNT(*)  FROM MHRequestDetails (NOLOCK) where MHRequestCode = @MHRequestCode
		Print @CountDetails
		SELECT @CountIsValid = COUNT(*) FROM MHRequestDetails (NOLOCK) where MHRequestCode = @MHRequestCode AND IsValid = 'Y'
		Print @CountIsValid

		IF(@CountDetails = @CountIsValid)
		BEGIN	
			UPDATE MHRequestDetails SET IsApprove = 'Y'
			WHERE MHRequestCode = @MHRequestCode

			UPDATE MHRequest SET MHRequestStatusCode = 1,ApprovedOn = GETDATE(),ApprovedBy = @UserCode
			WHERE MHRequestCode = @MHRequestCode

			EXEC USPMHMailNotification @MHRequestCode,1,0
		END
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHAutoApproveUsageRequest]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END