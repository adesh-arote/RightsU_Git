CREATE PROCEDURE [dbo].[USPAL_GetBookingsheetDataForLoadsheet]
(
	@LoadsheetMonth VARCHAR(50),
	@LoadSheetCode INT
)
AS
BEGIN

	IF OBJECT_ID('tempdb..#tempDate') IS NOT NULL DROP TABLE #tempDate

	CREATE TABLE #tempDate
	(
		RowNum INT,
		number INT
	)
	
	INSERT INTO #tempDate(RowNum, number)
	SELECT ROW_NUMBER() OVER (
		ORDER BY number
	  ) row_num, number From dbo.fn_Split_withdelemiter(@LoadsheetMonth,'-')

	  
	DECLARE @tblBS AS TABLE(
	AL_Booking_Sheet_Code INT
	)
	
	DECLARE @tblIncompleteBS AS TABLE(
		AL_Booking_Sheet_Code INT
	)

	INSERT INTO @tblBS
	SELECT AL_Booking_Sheet_Code from AL_Load_Sheet_Details WHERE AL_Load_Sheet_Code = @LoadSheetCode

	INSERT INTO @tblIncompleteBS
	Select DISTINCT AL_Booking_Sheet_Code from AL_Booking_Sheet_Details where Validations like '%man%'AND ISNULL(Columns_Value,'') = ''

	SELECT DISTINCT bs.AL_Booking_Sheet_Code, V.Vendor_Name, bs.Booking_Sheet_No, ap.Proposal_No + ' - CY ' + cast((ar.Refresh_Cycle_No) as varchar ) as 'Proposal_Cycle', (format(ar.Start_Date, 'MMy') + ' - ' + format(ar.End_Date, 'MMy')) as Cycle,
	ISNULL((SELECT Top 1 AL_Load_Sheet_Code from AL_Load_Sheet WHERE AL_Load_Sheet_Code = @LoadSheetCode), 0) AS AL_Load_Sheet_Code
	FROM AL_Booking_Sheet bs
	INNER JOIN AL_Recommendation ar on ar.AL_Recommendation_Code = bs.AL_Recommendation_Code
	INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = ar.AL_Proposal_Code
	INNER JOIN Vendor v ON v.Vendor_Code = bs.Vendor_Code
	WHERE (@LoadsheetMonth = '' OR 
	(MONTH(ar.Start_Date) = (select number from #tempDate where RowNum = 1) AND YEAR(ar.Start_Date) = (select number from #tempDate where RowNum = 2)))
	AND (@LoadSheetCode = 0 OR bs.AL_Booking_Sheet_Code IN (Select AL_Booking_Sheet_Code from @tblBS)) AND
	(@LoadsheetMonth = '' OR bs.AL_Booking_Sheet_Code NOT IN (Select distinct AL_Booking_Sheet_Code from AL_Load_Sheet_Details))
	AND bs.Record_Status = 'C' AND bs.AL_Booking_Sheet_Code NOT IN (Select AL_Booking_Sheet_Code from @tblIncompleteBS)
	ORDER BY bs.AL_Booking_Sheet_Code DESC

	IF OBJECT_ID('tempdb..#tempDate') IS NOT NULL DROP TABLE #tempDate
END