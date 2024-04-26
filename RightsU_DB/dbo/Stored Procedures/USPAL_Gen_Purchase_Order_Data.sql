CREATE PROCEDURE USPAL_Gen_Purchase_Order_Data
(
	@ALPurchaseOrderCode INT        
)
AS
BEGIN
	--DECLARE @ALPurchaseOrderCode INT = 1
	
	IF OBJECT_ID('tempdb..#TempBookingSheetDetail') IS NOT NULL DROP TABLE #TempBookingSheetDetail
	IF OBJECT_ID('tempdb..#TempCurrentCycleTitle') IS NOT NULL DROP TABLE #TempCurrentCycleTitle
	IF OBJECT_ID('tempdb..#TempBookingSheetDistributor') IS NOT NULL DROP TABLE #TempBookingSheetDistributor
	IF OBJECT_ID('tempdb..#tmpPONumber') IS NOT NULL DROP TABLE #tmpPONumber

	CREATE TABLE #TempBookingSheetDetail
	(
	    AL_Purchase_Order_Code INT,
		Title_Code INT,
		Title_Content_Code INT
	)
	
	CREATE TABLE #TempCurrentCycleTitle
	(	    
		Title_Code INT,
		Title_Content_Code INT
	)

	CREATE TABLE #TempBookingSheetDistributor
	(
	    AL_Purchase_Order_Code INT,
		Title_Code INT,
		Title_Content_Code INT,
		Columns_Code INT, 
		Columns_Value NVARCHAR(MAX),
		Vendor_Name NVARCHAR(MAX), 
		Vendor_Code INT,
		Short_Code NVARCHAR(100)
	)

	CREATE TABLE #tmpPONumber
	(
		[ID] [int] IDENTITY(1,1) NOT NULL,
		AL_Purchase_Order_Details_Code INT,
		MaxPOCount INT,
		RowNum INT
	)

	DECLARE @BookingSheetCode INT	= 0, @VendorCode INT = 0, @Vendor_Short_Code NVARCHAR(20) = '', @PO_NO NVARCHAR(MAX) = '', @PO_Max_Count NVARCHAR(10) = '0', @AL_Proposal_Code INT = 0, @RecommendationCode INT = 0

	SELECT @BookingSheetCode = AL_Booking_Sheet_Code, @AL_Proposal_Code = AL_Proposal_Code FROM AL_Purchase_Order WHERE AL_Purchase_Order_Code = @ALPurchaseOrderCode

	INSERT INTO #TempBookingSheetDetail (AL_Purchase_Order_Code, Title_Code, Title_Content_Code)	
	SELECT DISTINCT @ALPurchaseOrderCode, absd.Title_Code, absd.Title_Content_Code FROM AL_Booking_Sheet_Details absd
	INNER JOIN Title_Content tc ON tc.Title_Content_Code = absd.Title_Content_Code AND tc.Title_Code = absd.Title_Code
	WHERE AL_Booking_Sheet_Code = @BookingSheetCode;

	SELECT @VendorCode = Vendor_Code, @RecommendationCode = AL_Recommendation_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode

	SELECT @Vendor_Short_Code = Short_Code FROM Vendor WHERE Vendor_Code = @VendorCode
	
	SELECT @PO_Max_Count = MAX(AL_Purchase_Order_Details_Code) + 1 FROM AL_Purchase_Order_Details;

	IF EXISTS(SELECT TOP 1 * FROM AL_Purchase_Order_Details WHERE AL_Proposal_Code = @AL_Proposal_Code)
	BEGIN

		INSERT INTO #TempCurrentCycleTitle (Title_Code, Title_Content_Code)
		SELECT tbsd.Title_Code, tbsd.Title_Content_Code
		FROM AL_Purchase_Order apo 
		INNER JOIN #TempBookingSheetDetail tbsd ON apo.AL_Purchase_Order_Code = tbsd.AL_Purchase_Order_Code
		INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = apo.AL_Proposal_Code	
		WHERE tbsd.Title_Content_Code NOT IN (SELECT Title_Content_Code FROM AL_Purchase_Order_Details WHERE AL_Proposal_Code = @AL_Proposal_Code)
		AND tbsd.Title_Content_Code NOT IN (SELECT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @RecommendationCode AND Content_Status = 'D')

		INSERT INTO AL_Purchase_Order_Details (AL_Proposal_Code, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Generated_On)
		SELECT apo.AL_Proposal_Code, (Select Start_Date from AL_Recommendation where AL_Recommendation_Code = @RecommendationCode) AS LP_Start, ap.End_Date AS LP_End, tbsd.Title_Code, tbsd.Title_Content_Code, @VendorCode AS Vendor_Code, 'P' AS Status, GETDATE() AS Generated_On
		FROM AL_Purchase_Order apo 
		INNER JOIN #TempBookingSheetDetail tbsd ON apo.AL_Purchase_Order_Code = tbsd.AL_Purchase_Order_Code
		INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = apo.AL_Proposal_Code	
		WHERE tbsd.Title_Content_Code NOT IN (SELECT Title_Content_Code FROM AL_Purchase_Order_Details WHERE AL_Proposal_Code = @AL_Proposal_Code)
		AND tbsd.Title_Content_Code NOT IN (SELECT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @RecommendationCode AND Content_Status = 'D')

		INSERT INTO AL_Purchase_Order_Rel (AL_Purchase_Order_Code, AL_Purchase_Order_Details_Code, Status)
		SELECT @ALPurchaseOrderCode AS AL_Purchase_Order_Code, AL_Purchase_Order_Details_Code, 'H' FROM AL_Purchase_Order_Details WHERE AL_Proposal_Code = @AL_Proposal_Code

		UPDATE apor SET Status = 'N' FROM (SELECT * FROM AL_Purchase_Order_Rel WHERE AL_Purchase_Order_Code = @ALPurchaseOrderCode) apor 
		INNER JOIN AL_Purchase_Order_Details apod ON apor.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = apod.Title_Code AND tcct.Title_Content_Code = apod.Title_Content_Code 

		INSERT INTO #TempBookingSheetDistributor (AL_Purchase_Order_Code, Title_Code, Title_Content_Code, Columns_Code, Columns_Value, Vendor_Name, Vendor_Code, Short_Code )
		SELECT DISTINCT @ALPurchaseOrderCode AS AL_Purchase_Order_Code, absd.Title_Code, absd.Title_Content_Code, Columns_Code, Columns_Value, Validations, V.Vendor_Code, V.Short_Code
		FROM AL_Booking_Sheet_Details absd
		LEFT JOIN Vendor V ON absd.Columns_Value = V.Vendor_Name
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = absd.Title_Code AND tcct.Title_Content_Code = absd.Title_Content_Code
		WHERE absd.AL_Booking_Sheet_Code = @BookingSheetCode 
		AND Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Distributor_Value')

		INSERT INTO #tmpPONumber (AL_Purchase_Order_Details_Code, MaxPOCount, RowNum)
		SELECT apod.AL_Purchase_Order_Details_Code, (SELECT TOP 1 RunningNo FROM MHRequestIds WHERE RequestType = 'PO'), 1
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = apod.Title_Code AND tcct.Title_Content_Code = apod.Title_Content_Code
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		--UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST(apod.AL_Purchase_Order_Details_Code AS NVARCHAR(10)),
		UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST((SELECT tpo.MaxPOCount + ID FROM #tmpPONumber tpo WHERE tpo.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code) AS NVARCHAR(10)),
		Vendor_Code = ISNULL(tbsd.Vendor_Code,@VendorCode)
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = apod.Title_Code AND tcct.Title_Content_Code = apod.Title_Content_Code
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		IF EXISTS(SELECT TOP 1 * FROM #tmpPONumber tp)
		BEGIN
			UPDATE mri SET mri.RunningNo = (SELECT MAX(tpo.MaxPOCount + ID) FROM #tmpPONumber tpo) FROM  MHRequestIds mri WHERE mri.RequestType = 'PO'
			TRUNCATE TABLE #tmpPONumber
		END

		UPDATE apod SET Vendor_Code = ISNULL(tbsd.Vendor_Code,@VendorCode)
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = apod.Title_Code AND tcct.Title_Content_Code = apod.Title_Content_Code
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		INSERT INTO #tmpPONumber (AL_Purchase_Order_Details_Code, MaxPOCount, RowNum)
		SELECT AL_Purchase_Order_Details_Code, MaxPOCount, DENSE_RANK() OVER(Order By ALPurchaseOrderDetailCode) AS RowNum FROM
		(SELECT apod.AL_Purchase_Order_Details_Code AS AL_Purchase_Order_Details_Code, (SELECT TOP 1 RunningNo FROM MHRequestIds WHERE RequestType = 'PO') AS MaxPOCount, (SELECT TOP 1 apodt.AL_Purchase_Order_Details_Code FROM AL_Purchase_Order_Details apodt WHERE apodt.AL_Proposal_Code = @AL_Proposal_Code AND apodt.Vendor_Code = apod.Vendor_Code AND ISNULL(apodt.PO_Number,'') = '') AS ALPurchaseOrderDetailCode
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = apod.Title_Code AND tcct.Title_Content_Code = apod.Title_Content_Code
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code) AS T

		--UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST((SELECT TOP 1 apodt.AL_Purchase_Order_Details_Code FROM AL_Purchase_Order_Details apodt WHERE apodt.AL_Proposal_Code = @AL_Proposal_Code AND apodt.Vendor_Code = apod.Vendor_Code AND ISNULL(apodt.PO_Number,'') = '') AS NVARCHAR(10)), 
		UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST( (SELECT tpo.MaxPOCount + RowNum FROM #tmpPONumber tpo WHERE tpo.AL_Purchase_Order_Details_Code = (SELECT TOP 1 apodt.AL_Purchase_Order_Details_Code FROM AL_Purchase_Order_Details apodt WHERE apodt.AL_Proposal_Code = @AL_Proposal_Code AND apodt.Vendor_Code = apod.Vendor_Code AND ISNULL(apodt.PO_Number,'') = '')) AS NVARCHAR(10)), 
		Vendor_Code = ISNULL(tbsd.Vendor_Code,@VendorCode)
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = apod.Title_Code AND tcct.Title_Content_Code = apod.Title_Content_Code
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		IF EXISTS(SELECT TOP 1 * FROM #tmpPONumber tp)
		BEGIN
			UPDATE mri SET mri.RunningNo = (SELECT MAX(tpo.MaxPOCount + ID) FROM #tmpPONumber tpo) FROM  MHRequestIds mri WHERE mri.RequestType = 'PO'
			TRUNCATE TABLE #tmpPONumber
		END

		UPDATE absd SET  Columns_Value = apod.PO_Number
		FROM AL_Booking_Sheet_Details absd 
		INNER JOIN AL_Purchase_Order apo ON absd.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code
		INNER JOIN AL_Purchase_Order_Details apod ON apod.AL_Proposal_Code = apo.AL_Proposal_Code AND absd.Title_Code = apod.Title_Code AND absd.Title_Content_Code = apod.Title_Content_Code
		INNER JOIN #TempCurrentCycleTitle tcct ON tcct.Title_Code = absd.Title_Code AND tcct.Title_Content_Code = absd.Title_Content_Code
		WHERE absd.AL_Booking_Sheet_Code = @BookingSheetCode AND apo.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND absd.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_PO_Number_Value')

	END
	ELSE
	BEGIN

		INSERT INTO AL_Purchase_Order_Details (AL_Proposal_Code, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Generated_On)
		SELECT apo.AL_Proposal_Code, (Select Start_Date from AL_Recommendation where AL_Recommendation_Code = @RecommendationCode) AS LP_Start, ap.End_Date AS LP_End, tbsd.Title_Code, tbsd.Title_Content_Code, @VendorCode AS Vendor_Code, 'P' AS Status, GETDATE() AS Generated_On
		FROM AL_Purchase_Order apo 
		INNER JOIN #TempBookingSheetDetail tbsd ON apo.AL_Purchase_Order_Code = tbsd.AL_Purchase_Order_Code
		INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = apo.AL_Proposal_Code	
		
		INSERT INTO AL_Purchase_Order_Rel (AL_Purchase_Order_Code, AL_Purchase_Order_Details_Code, Status)
		SELECT @ALPurchaseOrderCode AS AL_Purchase_Order_Code, AL_Purchase_Order_Details_Code, 'N' FROM AL_Purchase_Order_Details WHERE AL_Proposal_Code = @AL_Proposal_Code

		INSERT INTO #TempBookingSheetDistributor (AL_Purchase_Order_Code, Title_Code, Title_Content_Code, Columns_Code, Columns_Value, Vendor_Name, Vendor_Code, Short_Code )
		SELECT DISTINCT @ALPurchaseOrderCode AS AL_Purchase_Order_Code, Title_Code, Title_Content_Code, Columns_Code, Columns_Value, Validations, V.Vendor_Code, V.Short_Code
		FROM AL_Booking_Sheet_Details absd
		LEFT JOIN Vendor V ON absd.Columns_Value = V.Vendor_Name
		WHERE absd.AL_Booking_Sheet_Code = @BookingSheetCode 
		AND Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Distributor_Value');

		INSERT INTO #tmpPONumber (AL_Purchase_Order_Details_Code, MaxPOCount, RowNum)
		SELECT apod.AL_Purchase_Order_Details_Code, (SELECT TOP 1 RunningNo FROM MHRequestIds WHERE RequestType = 'PO'), 1
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		--UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST(apod.AL_Purchase_Order_Details_Code AS NVARCHAR(10)),
		UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST((SELECT tpo.MaxPOCount + ID FROM #tmpPONumber tpo WHERE tpo.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code) AS NVARCHAR(10)),
		Vendor_Code = ISNULL(tbsd.Vendor_Code,@VendorCode)
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		IF EXISTS(SELECT TOP 1 * FROM #tmpPONumber tp)
		BEGIN
			UPDATE mri SET mri.RunningNo = (SELECT MAX(tpo.MaxPOCount + ID) FROM #tmpPONumber tpo) FROM  MHRequestIds mri WHERE mri.RequestType = 'PO'
			TRUNCATE TABLE #tmpPONumber
		END

		UPDATE apod SET Vendor_Code = ISNULL(tbsd.Vendor_Code,@VendorCode)
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		INSERT INTO #tmpPONumber (AL_Purchase_Order_Details_Code, MaxPOCount, RowNum)
		SELECT AL_Purchase_Order_Details_Code, MaxPOCount, DENSE_RANK() OVER(Order By ALPurchaseOrderDetailCode) AS RowNum FROM
		(SELECT apod.AL_Purchase_Order_Details_Code AS AL_Purchase_Order_Details_Code, (SELECT TOP 1 RunningNo FROM MHRequestIds WHERE RequestType = 'PO') AS MaxPOCount, (SELECT TOP 1 apodt.AL_Purchase_Order_Details_Code FROM AL_Purchase_Order_Details apodt WHERE apodt.AL_Proposal_Code = @AL_Proposal_Code AND apodt.Vendor_Code = apod.Vendor_Code AND ISNULL(apodt.PO_Number,'') = '') AS ALPurchaseOrderDetailCode
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code) AS T

		--UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST((SELECT TOP 1 apodt.AL_Purchase_Order_Details_Code FROM AL_Purchase_Order_Details apodt WHERE apodt.AL_Proposal_Code = @AL_Proposal_Code AND apodt.Vendor_Code = apod.Vendor_Code AND ISNULL(apodt.PO_Number,'') = '') AS NVARCHAR(10)),
		UPDATE apod SET PO_Number = CAST(ISNULL(@Vendor_Short_Code,0) AS VARCHAR) + '/Aeroplay/'+ CAST( (SELECT tpo.MaxPOCount + RowNum FROM #tmpPONumber tpo WHERE tpo.AL_Purchase_Order_Details_Code = (SELECT TOP 1 apodt.AL_Purchase_Order_Details_Code FROM AL_Purchase_Order_Details apodt WHERE apodt.AL_Proposal_Code = @AL_Proposal_Code AND apodt.Vendor_Code = apod.Vendor_Code AND ISNULL(apodt.PO_Number,'') = '')) AS NVARCHAR(10)), 
		Vendor_Code = ISNULL(tbsd.Vendor_Code,@VendorCode)
		FROM AL_Purchase_Order_Details apod 
		LEFT JOIN #TempBookingSheetDistributor tbsd ON tbsd.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND apod.Title_Code = tbsd.Title_Code AND apod.Title_Content_Code = tbsd.Title_Content_Code	
		INNER JOIN Title t ON t.Title_Code = apod.Title_Code 
		AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),','))
		WHERE apod.AL_Proposal_Code = @AL_Proposal_Code

		IF EXISTS(SELECT TOP 1 * FROM #tmpPONumber tp)
		BEGIN
			UPDATE mri SET mri.RunningNo = (SELECT MAX(tpo.MaxPOCount + ID) FROM #tmpPONumber tpo) FROM  MHRequestIds mri WHERE mri.RequestType = 'PO'
			TRUNCATE TABLE #tmpPONumber
		END

		UPDATE absd SET  Columns_Value = apod.PO_Number
		FROM AL_Booking_Sheet_Details absd 
		INNER JOIN AL_Purchase_Order apo ON absd.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code
		INNER JOIN AL_Purchase_Order_Details apod ON apod.AL_Proposal_Code = apo.AL_Proposal_Code AND absd.Title_Code = apod.Title_Code AND absd.Title_Content_Code = apod.Title_Content_Code
		WHERE absd.AL_Booking_Sheet_Code = @BookingSheetCode AND apo.AL_Purchase_Order_Code = @ALPurchaseOrderCode 
		AND absd.Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_PO_Number_Value')

	END

	UPDATE absh SET Record_Status = 'I', Last_Updated_Time = GETDATE() FROM AL_Booking_Sheet absh WHERE AL_Booking_Sheet_Code = @BookingSheetCode

	UPDATE AL_Purchase_Order SET Status = 'C' WHERE AL_Purchase_Order_Code = @ALPurchaseOrderCode

	IF OBJECT_ID('tempdb..#TempBookingSheetDetail') IS NOT NULL DROP TABLE #TempBookingSheetDetail
	IF OBJECT_ID('tempdb..#TempCurrentCycleTitle') IS NOT NULL DROP TABLE #TempCurrentCycleTitle
	IF OBJECT_ID('tempdb..#TempBookingSheetDistributor') IS NOT NULL DROP TABLE #TempBookingSheetDistributor
	IF OBJECT_ID('tempdb..#tmpPONumber') IS NOT NULL DROP TABLE #tmpPONumber

END