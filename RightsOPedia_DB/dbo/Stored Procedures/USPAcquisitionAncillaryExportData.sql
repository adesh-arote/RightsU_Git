CREATE PROCEDURE [dbo].[USPAcquisitionAncillaryExportData]
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@AcqDealCode VARCHAR(1000),
	@TabName NVARCHAR(MAX)	
)
AS
--Declare
--	@DepartmentCode NVARCHAR(1000) = 7,
--	@BVCode NVARCHAR(1000) = 19,
--	@TitleCode VARCHAR(MAX) = 42811,
--	@AcqDealCode VARCHAR(1000) = 25983, --25970,
--	@TabName NVARCHAR(MAX)	= 'Acquisition Ancillary Tab'

BEGIN
	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempAcqAncillaryCursor') IS NOT NULL DROP TABLE #TempAcqAncillaryCursor

	CREATE TABLE #TempFields(
		ViewName VARCHAR(100),
		DisplayName VARCHAR(100),
		FieldOrder INT,
		ValidOpList VARCHAR(100)
	)	

	INSERT INTO #TempFields(ViewName, DisplayName, FieldOrder, ValidOpList)
	SELECT View_Name, Display_Name, Display_Order, ValidOpList FROM Report_Setup WHERE Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode AND IsPartofSelectOnly IN ('Y', 'B') AND ValidOpList = @TabName

	CREATE TABLE #TempAcqAncillaryCursor
	(
	    Title_Code INT,
		Acq_Deal_Code INT,
		Ancillary_Type_code INT,
		Ancillary_Type_Name NVARCHAR(MAX),
		Duration NVARCHAR(MAX),
		Day NVARCHAR(MAX),
		Remarks NVARCHAR(MAX),
		Catch_Up_From  NVARCHAR(MAX)
	)	

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Acquisition Ancillary') AND ValidOpList = 'Acquisition Ancillary Tab' )
	BEGIN
	
		PRINT 'Acquisition Ancillary - Start'		

		INSERT INTO #TempAcqAncillaryCursor (Title_Code, Acq_Deal_Code, Ancillary_Type_code, Ancillary_Type_Name, Duration, Day, Remarks, Catch_Up_From)
		
		SELECT ADAT.Title_Code, ADA.Acq_Deal_Code, ADA.Ancillary_Type_code, 
			   AT.Ancillary_Type_Name 
			   + CASE WHEN ISNULL(Catch_Up_From, '') != '' THEN
					CASE WHEN ISNULL(Catch_Up_From, '') = 'E' THEN  ' (Each Broadcast)' WHEN ISNULL(Catch_Up_From, '') = 'F' THEN  ' (First Broadcast)' ELSE '' END ELSE ''
				END AS Ancillary_Type_Name
			   , ADA.Duration, ADA.Day, ADA.Remarks, ADA.Catch_Up_From 
		FROM Acq_Deal_Ancillary ADA 
			INNER JOIN Acq_Deal_Ancillary_Title ADAT ON ADAT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
			INNER JOIN AncillaryType AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_Code 
		WHERE ADAT.Title_Code = @TitleCode AND ADA.Acq_Deal_Code = @AcqDealCode
		
		PRINT 'Acquisition Ancillary - End'

	END		
	
	SELECT 1 AS GroupOrder, taac.Title_Code AS TitleCode, taac.Acq_Deal_Code AS Deal_Code, ISNULL(taac.Ancillary_Type_Name,'NA') AS Ancillary_Type_Name, ISNULL(taac.Duration,'NA') AS Duration, ISNULL(taac.Day,'NA') AS Day, ISNULL(taac.Remarks,'NA') AS Remark, taac.Ancillary_Type_code AS FieldOrder, 
			t.Title_Name AS TitleName, ad.Agreement_No AS AgreementNo, bu.Business_Unit_Name AS BusinessUnitName, dt.Deal_Type_Name AS DealType, ad.Deal_Desc AS DealDescription
	FROM #TempAcqAncillaryCursor taac
	INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = taac.Acq_Deal_Code
	INNER JOIN Title t ON t.Title_Code= taac.Title_Code
	INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
	INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = ad.Deal_Type_Code

	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempAcqAncillaryCursor') IS NOT NULL DROP TABLE #TempAcqAncillaryCursor

END