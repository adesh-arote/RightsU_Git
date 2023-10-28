CREATE PROCEDURE [dbo].[USPAL_GetBookingSheetMandatoryFieldNames]
(
	@BookingSheetCode INT,
	@Display_For CHAR(1)
)
AS
BEGIN
	
	DECLARE @MovieCodes VARCHAR(100) = '', @ShowCodes VARCHAR(100) = '', @DealTypeCode NVARCHAR(100) = '';
	SET @MovieCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies');
	SET @ShowCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show');

	IF(@Display_For = 'M')
	 BEGIN
		SET @DealTypeCode = @MovieCodes
	 END
	ELSE
	 BEGIN
		SET @DealTypeCode = @ShowCodes
	 END
	
	SELECT DISTINCT bsd.Validations AS Validation_Type, ec.Columns_Name AS Mandatory_Field_Name
	FROM AL_Booking_Sheet_Details bsd
	INNER JOIN Extended_Columns ec ON ec.Columns_Code = bsd.Columns_Code
	INNER JOIN Title t ON bsd.Title_Code = t.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter](@DealTypeCode,','))
	LEFT JOIN Title_Content tc ON bsd.Title_Content_Code = tc.Title_Content_Code
	WHERE (UPPER(bsd.Validations) like '%MAN%' OR UPPER(bsd.Validations) like '%PO%')
	AND bsd.AL_Booking_Sheet_Code = @BookingSheetCode AND bsd.Display_Name IN(@Display_For, 'B')

END