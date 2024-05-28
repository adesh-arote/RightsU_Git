CREATE PROC [dbo].[USPGetTitleForAvailRefresh]
AS
BEGIN

	DECLARE @TitleCode VARCHAR(MAX)
	SELECT @TitleCode = ''

	SELECT TOP 1 @TitleCode = TitleCodes FROM [Avail_Schedule] WHERE ProcessStatus = 'C' ORDER BY ProcessStartTime DESC
	
	IF(@TitleCode != '')
	BEGIN	
		SELECT convert(int,Number) AS Title_Code FROM DBO.fn_Split_withdelemiter(@TitleCode, ',') WHERE ISNULL(number, '') <> ''
	END
END
