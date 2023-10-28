CREATE PROCEDURE USPAL_GetDeliveryTrackingListMovies
@Client INT,
@Cycle VARCHAR(100),
@AL_Lab_Code INT,
@Distributor INT,
@Display VARCHAR
AS
BEGIN
	
	SELECT DISTINCT mt.AL_Material_Tracking_Code, t.Title_Name, V.Vendor_Name, l.AL_Lab_Name--, pod.PO_Number
	, mt.PO_Status, mt.Poster, mt.Still, mt.Trailer, mt.Embedded_Subs, mt.Edited_Poster, Edited_Still, 'A' AS COL1, 'B' AS COL2, 'C' AS COL3, 'D' AS COL4, 'E' AS COL5
	FROM AL_Material_Tracking mt
	INNER JOIN AL_Material_Tracking_OEM mto ON mto.AL_Material_Tracking_Code = mt.AL_Material_Tracking_Code
	--INNER JOIN AL_Load_Sheet ls ON ls.AL_Load_Sheet_Code = mt.AL_Load_Sheet_Code
	--INNER JOIN AL_Booking_Sheet bs ON bs.AL_Booking_Sheet_Code = mt.AL_Booking_Sheet_Code
	--INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = bs.AL_Booking_Sheet_Code
	----INNER JOIN AL_Booking_Sheet_Details bsd_Lab ON bsd_Lab.AL_Booking_Sheet_Code = bsd.AL_Booking_Sheet_Code AND bsd_Lab.Columns_Code = 70
	--INNER JOIN AL_Lab l ON l.AL_Lab_Name = bsd_Lab.Columns_Value
	INNER JOIN Title t ON t.Title_Code = mt.Title_Code
	INNER JOIN Vendor v ON v.Vendor_Code = mt.Vendor_Code
	INNER JOIN AL_Lab l ON l.AL_Lab_Code = mt.AL_Lab_Code
	INNER JOIN AL_Booking_Sheet bs ON bs.AL_Booking_Sheet_Code = mt.AL_Booking_Sheet_Code
	INNER JOIN AL_Purchase_Order po ON po.AL_Booking_Sheet_Code = bs.AL_Booking_Sheet_Code
	INNER JOIN AL_Purchase_Order_Details pod ON pod.AL_Purchase_Order_Code = po.AL_Purchase_Order_Code

 --   SELECT mt.AL_Material_Tracking_Code, CASE WHEN mto.Data_For = 'E' THEN 'Edited' ELSE 'Master' END +' '+ oe.Company_Short_Name, mto.Column_Value +' '+ CAST(ISNULL(mto.Delivery_Date,'') AS NVARCHAR)
	--FROM AL_Material_Tracking mt
	--INNER JOIN AL_Material_Tracking_OEM mto ON mto.AL_Material_Tracking_Code = mt.AL_Material_Tracking_Code
	--INNER JOIN AL_OEM oe ON oe.AL_OEM_Code = mto.AL_OEM_Code

END