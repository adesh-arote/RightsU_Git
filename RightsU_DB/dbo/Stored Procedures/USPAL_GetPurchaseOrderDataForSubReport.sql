CREATE PROCEDURE [dbo].[USPAL_GetPurchaseOrderDataForSubReport]
(
	@AL_Purchase_Order_Details_Code INT
)
AS
BEGIN

    SET FMTONLY OFF 
	SET NOCOUNT ON  

	IF OBJECT_ID('tempdb..#TempALPurchaseOrderDetails') IS NOT NULL DROP TABLE #TempALPurchaseOrderDetails

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
		Generated_On DATE
	)

	DECLARE @AL_Proposal_Code INT = 0
	SELECT TOP 1 @AL_Proposal_Code = AL_Proposal_Code FROM AL_Purchase_Order_Details WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code

	INSERT INTO #TempALPurchaseOrderDetails (AL_Purchase_Order_Details_Code, AL_Purchase_Order_Code, AL_Proposal_Code, PO_Number, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Excel_File_Name, PDF_File_Name, Generated_On)
	SELECT AL_Purchase_Order_Details_Code, AL_Purchase_Order_Code, AL_Proposal_Code, PO_Number, LP_Start, LP_End, Title_Code, Title_Content_Code, Vendor_Code, Status, Excel_File_Name, PDF_File_Name, Generated_On FROM
		(SELECT apor.AL_Purchase_Order_Code, apod.*, ROW_NUMBER() OVER ( PARTITION BY apod.AL_Purchase_Order_Details_Code ORDER BY apor.AL_Purchase_Order_Code ) AS RowNum  FROM AL_Purchase_Order_Details apod 
		INNER JOIN AL_Purchase_Order_Rel apor ON apor.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code) AS T WHERE RowNum = 1 AND AL_Proposal_Code = @AL_Proposal_Code
	
	DECLARE @AL_Booking_Sheet_Code INT = 0, @Title_Code INT = 0, @Title_Content_Code INT = 0;

	SELECT @Title_Code = Title_Code, @Title_Content_Code = Title_Content_Code FROM AL_Purchase_Order_Details WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code
	SELECT @AL_Booking_Sheet_Code = AL_Booking_Sheet_Code FROM AL_Purchase_Order WHERE AL_Purchase_Order_Code IN (SELECT AL_Purchase_Order_Code FROM #TempALPurchaseOrderDetails WHERE AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code)

	SELECT DISTINCT @AL_Purchase_Order_Details_Code AS 'AL_Purchase_Detail_Code', Record_Code AS 'AL_OEM_Code' FROM Map_Extended_Columns WHERE Table_Name = 'AL_OEM' 
		AND Columns_Code IN 
	(SELECT DISTINCT absd.Columns_Code
	FROM #TempALPurchaseOrderDetails apod 
		INNER JOIN AL_Purchase_Order apo ON apod.AL_Purchase_Order_Code = apo.AL_Purchase_Order_Code
		INNER JOIN (Select * from AL_Booking_Sheet_Details where AL_Booking_Sheet_Code = @AL_Booking_Sheet_Code and Columns_Value=1 and Validations like '%0%') absd ON apo.AL_Booking_Sheet_Code = absd.AL_Booking_Sheet_Code
		AND apod.Title_Code = absd.Title_Code AND apod.Title_Content_Code = absd.Title_Content_Code
	WHERE apod.AL_Purchase_Order_Details_Code = @AL_Purchase_Order_Details_Code AND apod.Title_Code = @Title_Code AND apod.Title_Content_Code = @Title_Content_Code) 

	IF OBJECT_ID('tempdb..#TempALPurchaseOrderDetails') IS NOT NULL DROP TABLE #TempALPurchaseOrderDetails

END