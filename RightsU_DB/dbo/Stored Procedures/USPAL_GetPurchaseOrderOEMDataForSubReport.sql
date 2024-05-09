CREATE PROCEDURE [dbo].[USPAL_GetPurchaseOrderOEMDataForSubReport]
(
	@AL_Purchase_Order_Details_Code INT,
	@AL_OEM_Code INT
)
AS
BEGIN

    SET FMTONLY OFF 
	SET NOCOUNT ON  

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

	DECLARE @AL_Proposal_Code INT = 0
	SELECT TOP 1 @AL_Proposal_Code = AL_Proposal_Code FROM AL_Purchase_Order_Details WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code

	INSERT INTO #TempALPurchaseOrderDetails (AL_Purchase_Order_Details_Code, AL_Purchase_Order_Code, AL_Proposal_Code, PO_Number, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Excel_File_Name, PDF_File_Name, Generated_On)
	SELECT AL_Purchase_Order_Details_Code, AL_Purchase_Order_Code, AL_Proposal_Code, PO_Number, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Excel_File_Name, PDF_File_Name, CONVERT(VARCHAR(11), Generated_On,106) FROM
		(SELECT apor.AL_Purchase_Order_Code, apod.*, ROW_NUMBER() OVER ( PARTITION BY apod.AL_Purchase_Order_Details_Code ORDER BY apor.AL_Purchase_Order_Code ) AS RowNum  FROM AL_Purchase_Order_Details apod 
		INNER JOIN AL_Purchase_Order_Rel apor ON apor.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code) AS T WHERE RowNum = 1 AND AL_Proposal_Code = @AL_Proposal_Code

	DECLARE @RecommendationCode INT = 0, @BookingSheetCode INT = 0, @Display_For CHAR(1) = 'B', @OEM_Code INT = 0, @OEM_Company_Name NVARCHAR(MAX) = '', @OEM_Company_Short_Name NVARCHAR(MAX) = '', @VendorCode INT = 0

	SELECT @BookingSheetCode = AL_Booking_Sheet_Code FROM AL_Purchase_Order WHERE AL_Purchase_Order_Code IN (SELECT DISTINCT AL_Purchase_Order_Code FROM #TempALPurchaseOrderDetails WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code)	

	SELECT @RecommendationCode = AL_Recommendation_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode

	SELECT @VendorCode = Vendor_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode

	SET @OEM_Code = @AL_OEM_Code;

	SELECT @OEM_Company_Name = Company_Name, @OEM_Company_Short_Name = Company_Short_Name FROM AL_OEM WHERE AL_OEM_Code = @OEM_Code;

	DECLARE @MovieCodes VARCHAR(100) = '', @ShowCodes VARCHAR(100) = '', @DealTypeCode NVARCHAR(100) = '';

	SET @MovieCodes = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_DealType_Movies');
	SET @ShowCodes = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_DealType_Show');

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

	INSERT INTO #TempBookingData(TitleName, Columns_Name, Columns_Value, Columns_Code, Title_Code, AL_Booking_Sheet_Code)
	SELECT 
		CASE WHEN @Display_For = 'S' THEN tc.Episode_Title + '(' + CAST(tc.Episode_No AS VARCHAR) + ')' ELSE t.Title_Name END TITLE, 
		ec.Columns_Name, absd.Columns_Value, ec.Columns_Code, t.Title_Code, absd.AL_Booking_Sheet_Code
	 FROM AL_Recommendation_Content arc
		INNER JOIN AL_Booking_Sheet_Details absd ON arc.Title_Code = absd.Title_Code AND ISNULL(arc.Title_Content_Code, 0) = ISNULL(absd.Title_Content_Code, 0)
		INNER JOIN Extended_Columns ec ON absd.Columns_Code = ec.Columns_Code
		INNER JOIN Title t ON absd.Title_Code = t.Title_Code
		LEFT JOIN Title_Content tc ON absd.Title_Content_Code = tc.Title_Content_Code
	 WHERE arc.AL_Recommendation_Code = @RecommendationCode AND absd.AL_Booking_Sheet_Code = @BookingSheetCode 
	    AND absd.Title_Code IN (SELECT Title_Code FROM AL_Purchase_Order_Details WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code) 
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
	
	DECLARE @AL_PAC_OEM_Value INT = 0, @AL_ZII_OEM_Value INT = 0, @AL_MOM_OEM_Value INT = 0, @AL_THA_OEM_Value INT = 0, @AL_BB_OEM_Value INT = 0, @PODelivaryText NVARCHAR(MAX) = '', @AL_Viasat_OEM_Value NVARCHAR(MAX) = '';

	SET @AL_PAC_OEM_Value = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_PAC_OEM_Value');
	SET @AL_ZII_OEM_Value = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_ZII_OEM_Value');
	SET @AL_MOM_OEM_Value = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_MOM_OEM_Value');
	SET @AL_THA_OEM_Value = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_THA_OEM_Value');
	SET @AL_BB_OEM_Value = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_BB_OEM_Value');
	SET @AL_Viasat_OEM_Value = (SELECT sp.Parameter_Value FROM System_Parameter_New sp WHERE sp.Parameter_Name = 'AL_Viasat_OEM_Value');

	SELECT @PODelivaryText = Column_Value FROM Map_Extended_Columns WHERE Table_Name = 'AL_OEM' AND Record_Code = @AL_OEM_Code AND Columns_Code = 229

	IF(@AL_OEM_Code = @AL_PAC_OEM_Value)
	BEGIN
		Select [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST(ISNULL([Period_Month],0) AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], (LEFT([Lang 1], 3) + CASE WHEN ISNULL(LEFT([Lang 2], 3),'') <> '' THEN ', ' + LEFT([Lang 2], 3) ELSE '' END  
                          + CASE WHEN ISNULL(LEFT([Lang 3], 3),'') <> '' THEN ', ' + LEFT([Lang 3], 3) ELSE '' END  
						  + CASE WHEN ISNULL(LEFT([Lang 4], 3),'') <> '' THEN ', ' + LEFT([Lang 4], 3) ELSE '' END ) AS [Lang1], LEFT([Embedded Subs], 3) AS [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @OEM_Company_Name [OEM_Company_Name], @OEM_Company_Short_Name [OEM_Company_Short_Name], [Lab],
		   (SELECT TOP 1 ISNULL(Contact_Person, '') FROM AL_Lab WHERE AL_Lab_Name COLLATE SQL_Latin1_General_CP1_CI_AS = [Lab]) AS [Lab_Contact_Name], [PAC MPEG] AS [MPEG], [PAC Aspect Ratio] AS [AspectRatio], [PAC Filename] AS [FileName], 
		   CASE WHEN ISNULL([PAC ex 1],'0') = '1' THEN 'eX1,' ELSE '' END + CASE WHEN ISNULL([PAC ex 2],'0') = '1' THEN 'eX2,' ELSE '' END + CASE WHEN ISNULL([PAC ex 3],'0') = '1' THEN 'eX3,' ELSE '' END AS [System], @PODelivaryText AS [PODelivaryText],
		   (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New]
		From #TempPurchaseOrderData tpod 
			INNER JOIN
		(Select * from ( Select tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code  from #TempBookingData tb ) a
			pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang 1],[Lang 2],[Lang 3],[Lang 4],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Lab], [PAC MPEG], [PAC Aspect Ratio], [PAC Filename], [PAC ex 1], [PAC ex 2], [PAC ex 3])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code
	END
	ELSE IF(@AL_OEM_Code = @AL_ZII_OEM_Value)
	BEGIN
		Select [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST(ISNULL([Period_Month],0) AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], LEFT([Lang 1], 3) AS [Lang1], LEFT([Embedded Subs], 3) AS [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @OEM_Company_Name [OEM_Company_Name], @OEM_Company_Short_Name [OEM_Company_Short_Name], [Lab],
		   (SELECT TOP 1 ISNULL(Contact_Person, '') FROM AL_Lab WHERE AL_Lab_Name COLLATE SQL_Latin1_General_CP1_CI_AS = [Lab]) AS [Lab_Contact_Name], [Zii MPEG] AS [MPEG], [Zii Aspect Ratio] AS [AspectRatio], [Zii Filename] AS [FileName], CASE WHEN ISNULL([Zodiac (Rave)],'0') = '1' THEN 'Rave' ELSE '' END AS [System], @PODelivaryText AS [PODelivaryText],
		   (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New]
		From #TempPurchaseOrderData tpod 
			INNER JOIN
		(Select * from ( Select tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code  from #TempBookingData tb ) a
			pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang 1],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Lab], [Zodiac (Rave)], [Zii MPEG], [Zii Aspect Ratio], [Zii Filename])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code
	END
	ELSE IF(@AL_OEM_Code = @AL_MOM_OEM_Value)
	BEGIN
		Select [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST(ISNULL([Period_Month],0) AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], (LEFT([Lang 1], 3) + CASE WHEN ISNULL(LEFT([Lang 2], 3),'') <> '' THEN ', ' + LEFT([Lang 2], 3) ELSE '' END  
                          + CASE WHEN ISNULL(LEFT([Lang 3], 3),'') <> '' THEN ', ' + LEFT([Lang 3], 3) ELSE '' END  
						  + CASE WHEN ISNULL(LEFT([Lang 4], 3),'') <> '' THEN ', ' + LEFT([Lang 4], 3) ELSE '' END ) AS [Lang1], LEFT([Embedded Subs], 3) AS [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @OEM_Company_Name [OEM_Company_Name], @OEM_Company_Short_Name [OEM_Company_Short_Name], [Lab],
		   (SELECT TOP 1 ISNULL(Contact_Person, '') FROM AL_Lab WHERE AL_Lab_Name COLLATE SQL_Latin1_General_CP1_CI_AS = [Lab]) AS [Lab_Contact_Name], [Moment MPEG] AS [MPEG], [Moment Aspect Ratio] AS [AspectRatio], [Moment Filename] AS [FileName], CASE WHEN ISNULL([Moment (Wireless IFE)],'0') = '1' THEN 'Wireless IFE' ELSE '' END AS [System], @PODelivaryText AS [PODelivaryText],
		   (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New]
		From #TempPurchaseOrderData tpod 
			INNER JOIN
		(Select * from ( Select tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code  from #TempBookingData tb ) a
			pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang 1],[Lang 2],[Lang 3],[Lang 4],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Lab], [Moment (Wireless IFE)], [Moment MPEG], [Moment Aspect Ratio], [Moment Filename])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code
	END		
	ELSE IF(@AL_OEM_Code = @AL_THA_OEM_Value)
	BEGIN
		Select [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST(ISNULL([Period_Month],0) AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], (LEFT([Lang 1], 3) + CASE WHEN ISNULL(LEFT([Lang 2], 3),'') <> '' THEN ', ' + LEFT([Lang 2], 3) ELSE '' END  
                          + CASE WHEN ISNULL(LEFT([Lang 3], 3),'') <> '' THEN ', ' + LEFT([Lang 3], 3) ELSE '' END  
						  + CASE WHEN ISNULL(LEFT([Lang 4], 3),'') <> '' THEN ', ' + LEFT([Lang 4], 3) ELSE '' END ) AS [Lang1], LEFT([Embedded Subs], 3) AS [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @OEM_Company_Name [OEM_Company_Name], @OEM_Company_Short_Name [OEM_Company_Short_Name], [Lab],
		   (SELECT TOP 1 ISNULL(Contact_Person, '') FROM AL_Lab WHERE AL_Lab_Name COLLATE SQL_Latin1_General_CP1_CI_AS = [Lab]) AS [Lab_Contact_Name], [Thales MPEG] AS [MPEG], [Thales Aspect Ratio] AS [AspectRatio], [Thales Filename] AS [FileName], 
		   CASE WHEN ISNULL([Thales Avant],'0') = '1' THEN 'Avant,' ELSE '' END + CASE WHEN ISNULL([Thales i4000],'0') = '1' THEN 'i4000,' ELSE '' END + CASE WHEN ISNULL([Thales i5000],'0') = '1' THEN 'i5000,' ELSE '' END + CASE WHEN ISNULL([Thales i8000],'0') = '1' THEN 'i8000,' ELSE '' END AS [System], @PODelivaryText AS [PODelivaryText],
		   (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New]
		From #TempPurchaseOrderData tpod 
			INNER JOIN
		(Select * from ( Select tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code  from #TempBookingData tb ) a
			pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang 1],[Lang 2],[Lang 3],[Lang 4],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Lab], [Moment (Wireless IFE)], [Thales MPEG], [Thales Aspect Ratio], [Thales Filename], [Thales Avant], [Thales i4000], [Thales i5000], [Thales i8000] )) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code
	END
	ELSE IF(@AL_OEM_Code = @AL_BB_OEM_Value)
	BEGIN
		Select [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST(ISNULL([Period_Month],0) AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], (LEFT([Lang 1], 3) + CASE WHEN ISNULL(LEFT([Lang 2], 3),'') <> '' THEN ', ' + LEFT([Lang 2], 3) ELSE '' END  
                          + CASE WHEN ISNULL(LEFT([Lang 3], 3),'') <> '' THEN ', ' + LEFT([Lang 3], 3) ELSE '' END  
						  + CASE WHEN ISNULL(LEFT([Lang 4], 3),'') <> '' THEN ', ' + LEFT([Lang 4], 3) ELSE '' END ) AS [Lang1], LEFT([Embedded Subs], 3) AS [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @OEM_Company_Name [OEM_Company_Name], @OEM_Company_Short_Name [OEM_Company_Short_Name], [Lab],
		   (SELECT TOP 1 ISNULL(Contact_Person, '') FROM AL_Lab WHERE AL_Lab_Name COLLATE SQL_Latin1_General_CP1_CI_AS = [Lab]) AS [Lab_Contact_Name], '' AS [MPEG], '' AS [AspectRatio], '' AS [FileName], '' AS [System], @PODelivaryText AS [PODelivaryText],
		   (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New]
		From #TempPurchaseOrderData tpod 
			INNER JOIN
		(Select * from ( Select tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code  from #TempBookingData tb ) a
			pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang 1],[Lang 2],[Lang 3],[Lang 4],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Lab], [Moment (Wireless IFE)], [Moment MPEG], [Moment Aspect Ratio], [Moment Filename])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code
	END
	ELSE IF(@AL_OEM_Code = @AL_Viasat_OEM_Value)
	BEGIN
		Select [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST(ISNULL([Period_Month],0) AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], (LEFT([Lang 1], 3) + CASE WHEN ISNULL(LEFT([Lang 2], 3),'') <> '' THEN ', ' + LEFT([Lang 2], 3) ELSE '' END  
                          + CASE WHEN ISNULL(LEFT([Lang 3], 3),'') <> '' THEN ', ' + LEFT([Lang 3], 3) ELSE '' END  
						  + CASE WHEN ISNULL(LEFT([Lang 4], 3),'') <> '' THEN ', ' + LEFT([Lang 4], 3) ELSE '' END ) AS [Lang1], LEFT([Embedded Subs], 3) AS [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @OEM_Company_Name [OEM_Company_Name], @OEM_Company_Short_Name [OEM_Company_Short_Name], [Lab],
		   (SELECT TOP 1 ISNULL(Contact_Person, '') FROM AL_Lab WHERE AL_Lab_Name COLLATE SQL_Latin1_General_CP1_CI_AS = [Lab]) AS [Lab_Contact_Name], [Viasat MPEG] AS [MPEG], [Viasat Aspect Ratio] AS [AspectRatio], [Viasat Filename] AS [FileName], CASE WHEN ISNULL([Viasat],'0') = '1' THEN 'Viasat' ELSE '' END AS [System], @PODelivaryText AS [PODelivaryText],
		   (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New]
		From #TempPurchaseOrderData tpod 
			INNER JOIN
		(Select * from ( Select tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code  from #TempBookingData tb ) a
			pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang 1],[Lang 2],[Lang 3],[Lang 4],[Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Lab], [Viasat], [Viasat MPEG], [Viasat Aspect Ratio], [Viasat Filename])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code
	END
	ELSE 
	BEGIN
		Select [Client_Name], [Vendor_Name], [Vendor_Address], [Vendor_Phone_No], [Vendor_Email], [Period], CAST(ISNULL([Period_Month],0) AS INT) + 1 AS [Period_Month], CONVERT(VARCHAR(11), [PO_Generate_Date], 106) AS [PO_Generate_Date], [Purchase_Order_No], 
	       [TitleName], [Airline], [Version], (LEFT([Lang 1], 3) + CASE WHEN ISNULL(LEFT([Lang 2], 3),'') <> '' THEN ', ' + LEFT([Lang 2], 3) ELSE '' END  
                          + CASE WHEN ISNULL(LEFT([Lang 3], 3),'') <> '' THEN ', ' + LEFT([Lang 3], 3) ELSE '' END  
						  + CASE WHEN ISNULL(LEFT([Lang 4], 3),'') <> '' THEN ', ' + LEFT([Lang 4], 3) ELSE '' END ) AS [Lang1], LEFT([Embedded Subs], 3) AS [Embedded Subs], [Remarks], [File details], [PO Booking], [Estimated Screening Cost per flight USD],
		   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges], [Master delivery date],
		   [Trailer delivery date],[Delivery and Payment remarks], @OEM_Company_Name [OEM_Company_Name], @OEM_Company_Short_Name [OEM_Company_Short_Name], [Lab],
		   (SELECT TOP 1 ISNULL(Contact_Person, '') FROM AL_Lab WHERE AL_Lab_Name COLLATE SQL_Latin1_General_CP1_CI_AS = [Lab]) AS [Lab_Contact_Name],  '' AS [MPEG], '' AS [AspectRatio], '' AS [FileName], '' AS [System], @PODelivaryText AS [PODelivaryText],
		   (SELECT Vendor_Name FROM Vendor WHERE Vendor_Code = @VendorCode) AS [Client_Name_New], [Client_Name] AS [Vendor_Name_New]
		From #TempPurchaseOrderData tpod 
			INNER JOIN
		(Select * from ( Select tb.AL_Booking_Sheet_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.Title_Code  from #TempBookingData tb ) a
			pivot (max(Columns_Value) for Columns_Name in ([Airline],[Version],[Lang 1],[Lang 2],[Lang 3],[Lang 4], [Embedded Subs],[Remarks],[File details],[PO Booking],[Estimated Screening Cost per flight USD],
												   [Estimated Screening Total USD],[Duplication Cost per flight USD],[Duplication Total USD],[Miscellaneous Items],[Miscellaneous Charges],
												   [Master delivery date],[Trailer delivery date],[Delivery and Payment remarks], [Lab], [Moment (Wireless IFE)], [Moment MPEG], [Moment Aspect Ratio], [Moment Filename])) p) AS T
		ON tpod.AL_Booking_Sheet_Code = T.AL_Booking_Sheet_Code
	END
	
	IF OBJECT_ID('tempdb..#TempBookingData') IS NOT NULL DROP TABLE #TempBookingData
	IF OBJECT_ID('tempdb..#TempPurchaseOrderData') IS NOT NULL DROP TABLE #TempPurchaseOrderData
	IF OBJECT_ID('tempdb..#TempALPurchaseOrderDetails') IS NOT NULL DROP TABLE #TempALPurchaseOrderDetails

END