CREATE PROCEDURE USPAL_CheckBookingSheeDataValidation
(
	@Booking_Sheet_Code INT
)
AS
BEGIN
    DECLARE @TotalCount INT = 0, @CompletTotalCount INT = 0, @ValidationFlag CHAR(1) = 'N'

    SELECT @TotalCount = COUNT(*)  FROM AL_Booking_Sheet_Details WHERE Validations like '%man%' AND AL_Booking_Sheet_Code = @Booking_Sheet_Code ; 
	SELECT @CompletTotalCount = COUNT(*)  FROM AL_Booking_Sheet_Details WHERE Validations like '%man%' AND Cell_Status='C' AND AL_Booking_Sheet_Code = @Booking_Sheet_Code ;

	IF(@TotalCount = @CompletTotalCount)
	BEGIN
		SET @ValidationFlag = 'Y'
	END
	ELSE
	BEGIN
		SET @ValidationFlag = 'N'
	END

	SELECT @ValidationFlag;
END