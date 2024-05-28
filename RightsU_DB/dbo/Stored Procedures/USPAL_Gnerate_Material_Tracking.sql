CREATE PROCEDURE [dbo].[USPAL_Gnerate_Material_Tracking](@AL_Load_Sheet_Code INT)
AS
BEGIN

	--DECLARE @AL_Load_Sheet_Code INT = 1070

	IF OBJECT_ID('tempdb..#tmpTrackingData') IS NOT NULL DROP TABLE #tmpTrackingData
	IF OBJECT_ID('tempdb..#temp_OEM') IS NOT NULL DROP TABLE #temp_OEM
	IF OBJECT_ID('tempdb..#TempBookingSheetDetail') IS NOT NULL DROP TABLE #TempBookingSheetDetail
	IF OBJECT_ID('tempdb..#TempCurrentCycleTitle') IS NOT NULL DROP TABLE #TempCurrentCycleTitle
	IF OBJECT_ID('tempdb..#tmpMain') IS NOT NULL DROP TABLE #tmpMain
	
	

	--CREATE TABLE #tmpTrackingData
	--(
	--	AL_Load_Sheet_Code INT,
	--	AL_Booking_Sheet_Code INT,
	--	Title_Code INT,
	--	Title_Content_Code INT,
	--	Vendor_Code INT,
	--	AL_Lab_Code INT,
	--	PO_Number VARCHAR(100),
	--	Master_In_House VARCHAR(1000),
	--	AL_OEM_Code INT,
	--	OEM_File_Name VARCHAR(1000),
	--	Due_Date VARCHAR(1000),
	--	AL_Proposal_Code INT
	--)

	

	CREATE TABLE #tmpMain(
		AL_Booking_Sheet_Code INT,
		Title_Code INT,
		Title_Content_Code INT,
		AL_Proposal_Code INT,
		AL_Material_Tracking_Code INT,
		Content_Status CHAR(1),
		AL_OEM_Code INT
	)

	CREATE TABLE #temp_OEM(
		AL_Booking_Sheet_Code INT,
		Title_Content_Code INT,
		AL_OEM_Code INT,
		Company_Name VARCHAR(100),
		Company_Short_Name VARCHAR(100)
	)

	CREATE TABLE #TempBookingSheetDetail
	(
	    AL_Load_Sheet_Code INT,
		Title_Code INT,
		Title_Content_Code INT
	)
	
	--INSERT INTO #temp_OEM(AL_Booking_Sheet_Code, Title_Content_Code, AL_OEM_Code, Company_Name, Company_Short_Name) 
	--SELECT DISTINCT bsd.AL_Booking_Sheet_Code, bsd.Title_Content_Code, om.AL_OEM_Code, om.Company_Name, om.Company_Short_Name
	--FROM AL_Load_Sheet_Details lsd
	--INNER JOIN AL_Booking_Sheet_Details bsd ON lsd.AL_Booking_Sheet_Code = bsd.AL_Booking_Sheet_Code
	--INNER JOIN Map_Extended_Columns mec ON mec.Columns_Code = bsd.Columns_Code AND mec.Table_Name = 'AL_OEM'
	--INNER JOIN AL_OEM om ON om.AL_OEM_Code = mec.Record_Code
	--WHERE AL_Load_Sheet_Code = 1070 AND Validations like '%&%' AND Columns_Value = '1'

	INSERT INTO #tmpMain
	SELECT DISTINCT absd.AL_Booking_Sheet_Code, absd.Title_Code, absd.Title_Content_Code, r.AL_Proposal_Code, 0, 'N', om.AL_OEM_Code 
	FROM AL_Load_Sheet_Details als
	INNER JOIN AL_Booking_Sheet_Details absd ON als.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code
	INNER JOIN AL_Booking_Sheet bs ON bs.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code
	INNER JOIN AL_Recommendation r ON r.AL_Recommendation_Code = bs.AL_Recommendation_Code 
	INNER JOIN Map_Extended_Columns mec ON mec.Columns_Code = absd.Columns_Code AND mec.Table_Name = 'AL_OEM'
	INNER JOIN AL_OEM om ON om.AL_OEM_Code = mec.Record_Code
	WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code
	AND Validations like '%&%' AND Columns_Value = '1'

	--Select * from #tmpMain
	UPDATE tm SET tm.AL_Material_Tracking_Code = mt.AL_Material_Tracking_Code, tm.Content_Status = 'H'
	FROM #tmpMain tm
	INNER JOIN AL_Material_Tracking mt ON mt.AL_Proposal_Code = tm.AL_Proposal_Code AND tm.Title_Content_Code = mt.Title_Content_Code AND mt.AL_OEM_Code = tm.AL_OEM_Code

	--INSERT new records in MT table basis on #tempMain where WHERE tm.Content_Status = 'N'
	INSERT INTO AL_Material_Tracking(Title_Code, Title_Content_Code, AL_OEM_Code, AL_Proposal_Code)
	SELECT DISTINCT Title_Code, Title_Content_Code, AL_OEM_Code, AL_Proposal_Code 
	FROM #tmpMain tm WHERE tm.Content_Status = 'N' 

	UPDATE tm SET tm.AL_Material_Tracking_Code = mt.AL_Material_Tracking_Code
	FROM #tmpMain tm
	INNER JOIN AL_Material_Tracking mt ON mt.AL_Proposal_Code = tm.AL_Proposal_Code AND tm.Title_Content_Code = mt.Title_Content_Code AND mt.AL_OEM_Code = tm.AL_OEM_Code
	WHERE tm.Content_Status = 'N'

	INSERT INTO AL_Load_Sheet_MT_Rel(AL_Load_Sheet_Code, AL_Booking_Sheet_Code, AL_Material_Tracking_Code, Content_Status, AL_OEM_Code)
	SELECT DISTINCT @AL_Load_Sheet_Code, AL_Booking_Sheet_Code, AL_Material_Tracking_Code, Content_Status, AL_OEM_Code
	FROM #tmpMain

	--INSERT INTO #TempBookingSheetDetail
	--SELECT DISTINCT 1070, absd.Title_Code, absd.Title_Content_Code
	--FROM AL_Booking_Sheet_Details absd
	--INNER JOIN Title_Content tc ON tc.Title_Content_Code = absd.Title_Content_Code AND tc.Title_Code = absd.Title_Code
	--WHERE absd.AL_Booking_Sheet_Code IN( Select * from @BookingSheetCodes);

	UPDATE tmp SET tmp.AL_Lab_Code = al.AL_Lab_Code
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code AND Columns_Code = 70 --LAB
	INNER JOIN AL_Lab al ON al.AL_Lab_Name = absd.Columns_Value
	
	

	UPDATE tmp SET tmp.Vendor_Code = vn.Vendor_Code
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code AND Columns_Code = 204 --Dist
	INNER JOIN Vendor vn ON vn.Vendor_Name = absd.Columns_Value
	

	UPDATE tmp SET tmp.PO_Number = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code AND Columns_Code = 82 --PO
	

	UPDATE tmp SET tmp.Master_In_House = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code AND Columns_Code = 84 --Master-In-House
	
	UPDATE tmp SET tmp.Due_Date = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code AND Columns_Code = 214 --Master Delivery Date
	
	UPDATE tmp SET tmp.Embedded_Subs = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code AND Columns_Code = 87 --Embedded Subs
	
	DECLARE @AL_BB_OEM_Value VARCHAR(100) = '', @AL_THA_OEM_Value VARCHAR(100) = '', @AL_MOM_OEM_Value VARCHAR(100) = '', @AL_ZII_OEM_Value VARCHAR(100) = '', 
			@AL_PAC_OEM_Value VARCHAR(100) = '', @AL_Viasat_OEM_Value VARCHAR(100) = ''

	SELECT @AL_BB_OEM_Value = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_BB_OEM_Value'
	SELECT @AL_THA_OEM_Value = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_THA_OEM_Value'
	SELECT @AL_MOM_OEM_Value = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_MOM_OEM_Value'
	SELECT @AL_ZII_OEM_Value = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_ZII_OEM_Value'
	SELECT @AL_PAC_OEM_Value = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_PAC_OEM_Value'
	SELECT @AL_Viasat_OEM_Value = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AL_Viasat_OEM_Value'

	UPDATE tmp SET tmp.OEM_File_Name = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code 
	WHERE Columns_Code = 142 AND tmp.AL_OEM_Code = @AL_PAC_OEM_Value


	UPDATE tmp SET tmp.OEM_File_Name = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code 
	WHERE Columns_Code = 168 AND tmp.AL_OEM_Code = @AL_ZII_OEM_Value

	UPDATE tmp SET tmp.OEM_File_Name = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code 
	WHERE Columns_Code = 176 AND tmp.AL_OEM_Code = @AL_MOM_OEM_Value

	UPDATE tmp SET tmp.OEM_File_Name = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code 
	WHERE Columns_Code = 182 AND tmp.AL_OEM_Code = @AL_THA_OEM_Value

	UPDATE tmp SET tmp.OEM_File_Name = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code 
	WHERE Columns_Code = 200 AND tmp.AL_OEM_Code = @AL_BB_OEM_Value
	
	UPDATE tmp SET tmp.OEM_File_Name = absd.Columns_Value
	--FROM #tmpTrackingData tmp
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'
	INNER JOIN AL_Booking_Sheet_Details absd ON main.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code AND 
	main.Title_Code = absd.Title_Code AND main.Title_Content_Code = absd.Title_Content_Code 
	WHERE Columns_Code = 237 AND tmp.AL_OEM_Code = @AL_Viasat_OEM_Value

	UPDATE tmp SET tmp.Status = 'P'
	FROM AL_Material_Tracking tmp
	INNER JOIN #tmpMain main ON main.AL_Material_Tracking_Code = tmp.AL_Material_Tracking_Code AND main.Content_Status = 'N'

	IF OBJECT_ID('tempdb..#tmpTrackingData') IS NOT NULL DROP TABLE #tmpTrackingData
	IF OBJECT_ID('tempdb..#temp_OEM') IS NOT NULL DROP TABLE #temp_OEM

END