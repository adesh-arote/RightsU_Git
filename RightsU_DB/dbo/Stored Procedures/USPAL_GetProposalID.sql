CREATE PROC [dbo].[USPAL_GetProposalID](@VendorCode INT,@RequestType VARCHAR(2))
AS
BEGIN
--DECLARE
--@VendorCode INT = 4,@RequestType VARCHAR(2) = 'P'

	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetProposalID]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @Year VARCHAR(10), @ShortCode VARCHAR(20) = '', @RunningNo INT = 0, @Month VARCHAR(10), @MonthYear VARCHAR(10)--, @RequestID VARCHAR(50) = '', 

		SELECT @Year = RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR(10)), LEN(CAST(YEAR(GETDATE()) AS VARCHAR(10))) - 2) 

		--SET @Month = CAST(MONTH(GETDATE()) AS VARCHAR(10))
		
		SELECT @Month = RIGHT('0' + CAST(CAST(MONTH(GETDATE()) AS VARCHAR(10)) AS VARCHAR(10)), 2)

		SET @MonthYear = @Month+@Year
	
		SELECT @ShortCode = ISNULL(Short_Code, '') FROM Vendor (NOLOCK) WHERE Vendor_Code = @VendorCode
	
		--IF(@ShortCode = '')
		--BEGIN
		--	SET @ShortCode = 'RQ'
		--END

		BEGIN TRAN

		IF NOT EXISTS(SELECT * FROM MHRequestIds (NOLOCK) WHERE VendorCode = @VendorCode AND FinYear = @MonthYear AND RequestType = @RequestType)
		BEGIN
			INSERT INTO MHRequestIds(VendorCode, FinYear, RunningNo,RequestType)
			SELECT @VendorCode, @MonthYear, 1,@RequestType
			SELECT @RequestType +'-' + @ShortCode + '-' + @MonthYear + '-' + '00001' AS RequestID

		END
		ELSE
		BEGIN

			UPDATE MHRequestIds SET RunningNo = RunningNo + 1  WHERE VendorCode = @VendorCode AND FinYear = @MonthYear AND RequestType = @RequestType
			SELECT @RunningNo = RunningNo FROM MHRequestIds (NOLOCK)  WHERE VendorCode = @VendorCode AND FinYear = @MonthYear AND RequestType = @RequestType

			SELECT  @RequestType + '-' + @ShortCode + '-' + @MonthYear + '-' + RIGHT('0000' + CAST(@RunningNo AS VARCHAR(10)), 5) AS RequestID
		END

		COMMIT TRAN
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetProposalID]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END