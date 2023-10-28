CREATE PROCEDURE [dbo].[USPAL_GetPurchaseOrderDataForShowExport]
(
	@AL_Purchase_Order_Details_Code INT
)
AS
BEGIN

    SET FMTONLY OFF 
	SET NOCOUNT ON  

	IF OBJECT_ID('tempdb..#TempBookingData') IS NOT NULL DROP TABLE #TempBookingData
	IF OBJECT_ID('tempdb..#TempPurchaseOrderData') IS NOT NULL DROP TABLE #TempPurchaseOrderData
	IF OBJECT_ID('tempdb..#TempALPurchaseOrderDetails') IS NOT NULL DROP TABLE #TempALPurchaseOrderDetails

	CREATE TABLE #TempBookingData
	(
		TitleName	NVARCHAR(MAX),
		Columns_Name NVARCHAR(MAX),	
		Columns_Value NVARCHAR(MAX),	
		Columns_Code INT,
		Title_Code INT,
		Title_Content_Code INT,
		EpisodeNo NVARCHAR(MAX),
		EpisodeTitle NVARCHAR(MAX),
		AL_Booking_Sheet_Code INT
	)

	CREATE TABLE #TempPurchaseOrderData
	(
		Client_Name NVARCHAR(MAX),
		Vendor_Name NVARCHAR(MAX),
		Vendor_Address NVARCHAR(MAX),
		Vendor_Phone_No NVARCHAR(MAX),
		Vendor_Email NVARCHAR(MAX),
		Period NVARCHAR(MAX),
		Period_Month NVARCHAR(MAX),
		PO_Generate_Date NVARCHAR(MAX),
		Purchase_Order_No NVARCHAR(MAX),
		AL_Booking_Sheet_Code INT
	)

	CREATE TABLE #TempALPurchaseOrderDetails
	(
		AL_Purchase_Order_Details_Code INT, 
		AL_Purchase_Order_Code INT,
		AL_Proposal_Code INT, 
		PO_Number NVARCHAR(MAX), 
		LP_Start DATE, 
		LP_End DATE, 
		Title_Code INT, 
		Title_Content_Code INT, 
		Vendor_Code INT, 
		Status CHAR(1), 
		Excel_File_Name NVARCHAR(MAX), 
		PDF_File_Name NVARCHAR(MAX), 
		Generated_On Varchar(11)
	)

	DECLARE @AL_Proposal_Code INT = 0, @PO_Number NVARCHAR(MAX) = '';
	SELECT TOP 1 @AL_Proposal_Code = AL_Proposal_Code, @PO_Number = PO_Number  FROM AL_Purchase_Order_Details WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code

	INSERT INTO #TempALPurchaseOrderDetails (AL_Purchase_Order_Details_Code, AL_Purchase_Order_Code, AL_Proposal_Code, PO_Number, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Excel_File_Name, PDF_File_Name, Generated_On)
	SELECT AL_Purchase_Order_Details_Code, AL_Purchase_Order_Code, AL_Proposal_Code, PO_Number, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Excel_File_Name, PDF_File_Name, CONVERT(VARCHAR(11), Generated_On,106) FROM
		(SELECT apor.AL_Purchase_Order_Code, apod.*, ROW_NUMBER() OVER ( PARTITION BY apod.AL_Purchase_Order_Details_Code ORDER BY apor.AL_Purchase_Order_Code ) AS RowNum  FROM AL_Purchase_Order_Details apod 
		INNER JOIN AL_Purchase_Order_Rel apor ON apor.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code) AS T WHERE RowNum = 1 AND AL_Proposal_Code = @AL_Proposal_Code AND PO_Number = @PO_Number

	DECLARE @RecommendationCode INT = 0, @BookingSheetCode INT = 0, @Display_For CHAR(1) = 'B', @VendorCode INT = 0

	SELECT @BookingSheetCode = AL_Booking_Sheet_Code FROM AL_Purchase_Order WHERE AL_Purchase_Order_Code IN (SELECT DISTINCT AL_Purchase_Order_Code FROM #TempALPurchaseOrderDetails WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code)	

	SELECT @RecommendationCode = AL_Recommendation_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode

	SELECT @VendorCode = Vendor_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode

	DECLARE @MovieCodes VARCHAR(100) = '', @ShowCodes VARCHAR(100) = '', @DealTypeCode NVARCHAR(100) = '';

	SET @MovieCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies');
	SET @ShowCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show');

	IF EXISTS(SELECT * FROM AL_Purchase_Order_Details apod INNER JOIN Title t ON apod.Title_Code = t.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter](@MovieCodes,','))
														   LEFT JOIN Title_Content tc ON apod.Title_Content_Code = tc.Title_Content_Code WHERE apod.AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code)
    BEGIN
        SET @Display_For = 'M'
	END
	ELSE IF EXISTS(SELECT * FROM AL_Purchase_Order_Details apod INNER JOIN Title t ON apod.Title_Code = t.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter](@ShowCodes,','))
														   LEFT JOIN Title_Content tc ON apod.Title_Content_Code = tc.Title_Content_Code WHERE apod.AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code)
	BEGIN
		SET @Display_For = 'S'
	END

	DECLARE @AL_Booking_Sheet_Code INT = 0, @Title_Code INT = 0, @Title_Content_Code INT = 0 , @Total_OEM_Count INT = 0, @Total_Purchase_Order_Value INT = 0 ;

	SELECT @Title_Code = Title_Code, @Title_Content_Code = Title_Content_Code FROM AL_Purchase_Order_Details WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code
	SELECT @AL_Booking_Sheet_Code = AL_Booking_Sheet_Code FROM AL_Purchase_Order WHERE AL_Purchase_Order_Code IN (SELECT AL_Purchase_Order_Code FROM #TempALPurchaseOrderDetails WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code)

	INSERT INTO #TempBookingData(TitleName, Columns_Name, Columns_Value, Columns_Code, Title_Code, Title_Content_Code, EpisodeNo, EpisodeTitle, AL_Booking_Sheet_Code)
	SELECT 
		CASE WHEN @Display_For = 'S' THEN tc.Episode_Title + '(' + CAST(tc.Episode_No AS VARCHAR) + ')' ELSE t.Title_Name END TITLE, 
		ec.Columns_Name, absd.Columns_Value, ec.Columns_Code, t.Title_Code, absd.Title_Content_Code, tc.Episode_No, tc.Episode_Title, absd.AL_Booking_Sheet_Code
	 FROM AL_Recommendation_Content arc
		INNER JOIN AL_Booking_Sheet_Details absd ON arc.Title_Code = absd.Title_Code AND ISNULL(arc.Title_Content_Code, 0) = ISNULL(absd.Title_Content_Code, 0)
		INNER JOIN #TempALPurchaseOrderDetails apod ON apod.Title_Code = absd.Title_Code AND ISNULL(apod.Title_Content_Code, 0) = ISNULL(absd.Title_Content_Code, 0)
		INNER JOIN Extended_Columns ec ON absd.Columns_Code = ec.Columns_Code
		INNER JOIN Title t ON absd.Title_Code = t.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter](@ShowCodes,','))
		LEFT JOIN Title_Content tc ON absd.Title_Content_Code = tc.Title_Content_Code
	 WHERE arc.AL_Recommendation_Code = @RecommendationCode AND absd.AL_Booking_Sheet_Code = @BookingSheetCode 
	    --AND absd.Title_Code IN (SELECT Title_Code FROM AL_Purchase_Order_Details WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code) 
		AND absd.Display_Name IN(@Display_For,'B') 

    INSERT INTO #TempPurchaseOrderData (Client_Name, Vendor_Name, Vendor_Address, Vendor_Phone_No, Vendor_Email, Period, Period_Month, PO_Generate_Date, Purchase_Order_No, AL_Booking_Sheet_Code)
    SELECT v.Vendor_Name AS [Client_Name], vc.Contact_Name AS [Vendor_Name], v.Address AS [Vendor_Address], vc.Phone_No AS [Vendor_Phone_No], vc.Email AS [Vendor_Email], 
		(format(LP_Start, 'MMy') + ' - ' + format(LP_End, 'MMy')) AS [Period], DATEDIFF(month, LP_Start, LP_End) AS [Period_Month], apod.Generated_On AS [PO_Generate_Date], 
		apod.PO_Number AS [Purchase_Order_No], apo.AL_Booking_Sheet_Code
	FROM #TempALPurchaseOrderDetails apod 
	    INNER JOIN AL_Purchase_Order apo ON apo.AL_Purchase_Order_Code = apod.AL_Purchase_Order_Code
		INNER JOIN Vendor v ON apod.Vendor_Code=v.Vendor_Code
		LEFT JOIN Vendor_Contacts vc ON vc.Vendor_Code = v.Vendor_Code
	WHERE apod.AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code;	

	--SELECT @Total_OEM_Count = COUNT(*) FROM
	--(SELECT DISTINCT Record_Code AS 'AL_OEM_Code' FROM Map_Extended_Columns WHERE Table_Name = 'AL_OEM' 
	--	AND Columns_Code IN 
	--(SELECT DISTINCT absd.Columns_Code
	--FROM #TempALPurchaseOrderDetails apod 
	--	INNER JOIN AL_Purchase_Order apo ON apod.AL_Purchase_Order_Code = apo.AL_Purchase_Order_Code
	--	INNER JOIN (Select * from AL_Booking_Sheet_Details where AL_Booking_Sheet_Code = @AL_Booking_Sheet_Code and Columns_Value=1 and Validations like '%0%') absd ON apo.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code
	--	AND apod.Title_Code = absd.Title_Code AND apod.Title_Content_Code = absd.Title_Content_Code
	--WHERE apod.AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code AND apod.Title_Code = @Title_Code AND apod.Title_Content_Code = @Title_Content_Code)) AS T 

		DECLARE @Distributor NVARCHAR(MAX) = ''

		SELECT @Distributor = [Distributor]
		FROM #TempPurchaseOrderData tpod 
		INNER JOIN
		(SELECT * FROM ( SELECT tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code, tb.Title_Content_Code, tb.EpisodeNo, tb.EpisodeTitle FROM #TempBookingData tb ) a
		pivot (max(Columns_Value) for Columns_Name in ([Distributor])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code AND T.Title_Content_Code = @Title_Content_Code

	SELECT @Total_Purchase_Order_Value = SUM([Total Purchase Order Value])
	FROM
		(SELECT [TitleName],[Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD], CAST(ISNULL([Estimated Screening Total USD],0) AS DECIMAL(10,2)) AS [Total Purchase Order Value],
		   T.Title_Content_Code AS [Title_Content_Code], T.EpisodeNo AS [EpisodeNo], T.EpisodeTitle AS [EpisodeTitle]
		FROM #TempPurchaseOrderData tpod 
		INNER JOIN
		(SELECT * FROM ( SELECT tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code, tb.Title_Content_Code, tb.EpisodeNo, tb.EpisodeTitle FROM #TempBookingData tb ) a
		pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang1],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
													   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
													   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Distributor])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code --AND T.Distributor = @Distributor
		WHERE tpod.Purchase_Order_No = @PO_Number) AS TT 

	SELECT [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST([Period_Month] AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], [Lang1], [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @Total_Purchase_Order_Value AS [Total Purchase Order Value],
		   @Total_OEM_Count AS [Total_OEM_Count], T.Title_Content_Code AS [Title_Content_Code], [Delivery Fees], (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New], [Distributor / Studio] AS [Distributor],
		   @AL_Purchase_Order_Details_Code AS [AL_Purchase_Order_Details_Code]
	FROM #TempPurchaseOrderData tpod 
	INNER JOIN
	(SELECT * FROM ( SELECT tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code, tb.Title_Content_Code FROM #TempBookingData tb ) a
	pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang1],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Delivery Fees], [Distributor / Studio])) p) AS T
	ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code AND T.Title_Content_Code = @Title_Content_Code

	IF OBJECT_ID('tempdb..#TempBookingData') IS NOT NULL DROP TABLE #TempBookingData
	IF OBJECT_ID('tempdb..#TempPurchaseOrderData') IS NOT NULL DROP TABLE #TempPurchaseOrderData
	IF OBJECT_ID('tempdb..#TempALPurchaseOrderDetails') IS NOT NULL DROP TABLE #TempALPurchaseOrderDetails

END