CREATE PROCEDURE USPAL_SaveDeliveryTracking
@DeliveryTracking_UDT DeliveryTracking_UDT READONLY
AS
BEGIN
IF(OBJECT_ID('tempdb..#tempDeliveryTrackingData') IS NOT NULL) DROP TABLE #tempDeliveryTrackingData

	CREATE TABLE #tempDeliveryTrackingData(
		[AL_Material_Tracking_Code] [nvarchar](4000) NULL,
		[PO_Status] [nvarchar](4000) NULL,
		[Delivery_Date] [varchar](100) NULL,
		[Poster] [nvarchar](200) NULL,
		[Still] [nvarchar](200) NULL,
		[Trailer] [varchar](100) NULL,
		[Edited_Poster] [varchar](100) NULL,
		[Edited_Still] [nvarchar](2000) NULL
	)

	INSERT INTO #tempDeliveryTrackingData
	SELECT * FROM @DeliveryTracking_UDT

	UPDATE mt SET mt.Delivery_Date = CASE WHEN t.Delivery_Date IS NOT NULL OR t.Delivery_Date <> '' THEN t.Delivery_Date ELSE mt.Delivery_Date END,
	mt.PO_Status = CASE WHEN t.PO_Status IS NOT NULL OR t.PO_Status <> '' THEN t.PO_Status ELSE mt.PO_Status END,
	mt.Poster = t.Poster, mt.Still = t.Still, mt.Trailer = t.Trailer, mt.Edited_Poster = t.Edited_Poster, mt.Edited_Still = t.Edited_Still, mt.Status = 'C'
	FROM AL_Material_Tracking mt
	INNER JOIN #tempDeliveryTrackingData t ON t.AL_Material_Tracking_Code = mt.AL_Material_Tracking_Code
	
	IF(OBJECT_ID('tempdb..#tempDeliveryTrackingData') IS NOT NULL) DROP TABLE #tempDeliveryTrackingData
END