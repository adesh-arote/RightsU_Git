CREATE PROCEDURE [dbo].[USPAcquisitionAncillaryTabData]
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
--	@TitleCode VARCHAR(MAX) = 27816,
--	@AcqDealCode VARCHAR(1000) = 15250, --25970,
--	@TabName NVARCHAR(MAX)	= 'Acquisition Ancillary Tab'

BEGIN
	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempAcqAncillaryCursor') IS NOT NULL DROP TABLE #TempAcqAncillaryCursor
	IF OBJECT_ID('tempdb..#TempAcqAncillaryData') IS NOT NULL DROP TABLE #TempAcqAncillaryData

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
		Acq_Deal_Ancillary_Code INT,
		Ancillary_Type_Name NVARCHAR(MAX),
		Duration NVARCHAR(MAX),
		Day NVARCHAR(MAX),
		Remarks NVARCHAR(MAX),
		Catch_Up_From  NVARCHAR(MAX)
	)	

	CREATE TABLE #TempAcqAncillaryData
	(
	    Title_Code INT,
		Acq_Deal_Code INT,
		Ancillary_Type_code INT,
		Ancillary_Type_Name NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Data_Value NVARCHAR(MAX)
	)	

	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Acquisition Ancillary') AND ValidOpList = 'Acquisition Ancillary Tab' )
	BEGIN
	
		PRINT 'Acquisition Ancillary - Start'		

		DECLARE @Durationsec NVARCHAR(MAX) = '', @PeriodDay NVARCHAR(MAX) = '', @Remarks NVARCHAR(MAX) = ''

		SELECT TOP 1 @Durationsec = Message_Desc FROM System_Language_Message WHERE System_Module_Message_code IN 
			(SELECT System_Module_Message_code FROM System_Module_Message WHERE System_Message_Code IN 
			(SELECT System_Message_Code FROM System_Message WHERE Message_Key = 'Durationsec') AND Module_Code IN 
			(SELECT Module_Code FROM System_Module WHERE Module_Name = 'Acquisition Deals')) AND System_Language_Code = 1

		SELECT TOP 1 @PeriodDay = Message_Desc FROM System_Language_Message WHERE System_Module_Message_code IN 
			(SELECT System_Module_Message_code FROM System_Module_Message WHERE System_Message_Code IN 
			(SELECT System_Message_Code FROM System_Message WHERE Message_Key = 'PeriodDay') AND Module_Code IN 
			(SELECT Module_Code FROM System_Module WHERE Module_Name = 'Acquisition Deals')) AND System_Language_Code = 1

		SELECT TOP 1 @Remarks = Message_Desc FROM System_Language_Message WHERE System_Module_Message_code IN 
			(SELECT System_Module_Message_code FROM System_Module_Message WHERE System_Message_Code IN 
			(SELECT System_Message_Code FROM System_Message WHERE Message_Key = 'Remarks') AND Module_Code IN 
			(SELECT Module_Code FROM System_Module WHERE Module_Name = 'Acquisition Deals')) AND System_Language_Code = 1


		INSERT INTO #TempAcqAncillaryCursor (Title_Code, Acq_Deal_Code, Ancillary_Type_code, Acq_Deal_Ancillary_Code, Ancillary_Type_Name, Duration, Day, Remarks, Catch_Up_From)
		
		SELECT ADAT.Title_Code, ADA.Acq_Deal_Code, ADA.Ancillary_Type_code, ADA.Acq_Deal_Ancillary_Code, AT.Ancillary_Type_Name, ADA.Duration, ADA.Day, ADA.Remarks, ADA.Catch_Up_From 
		FROM Acq_Deal_Ancillary ADA 
			INNER JOIN Acq_Deal_Ancillary_Title ADAT ON ADAT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
			INNER JOIN AncillaryType AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_Code 
		WHERE ADAT.Title_Code = @TitleCode AND ADA.Acq_Deal_Code = @AcqDealCode
		
		IF EXISTS (SELECT TOP 1 * FROM #TempAcqAncillaryCursor)
		BEGIN
			DECLARE @AcqDealAncillaryCode NVARCHAR(MAX), @AncillaryTypeCode NVARCHAR(MAX), @AncillaryTypeName NVARCHAR(MAX), @AncillaryDuration NVARCHAR(MAX), @AncillaryDay NVARCHAR(MAX), @AncillaryRemarks NVARCHAR(MAX), @AncillaryCatchUpFrom NVARCHAR(MAX), @Cur_AcqDealCode NVARCHAR(MAX), @Cur_TitleCode NVARCHAR(MAX),
					@DataValue NVARCHAR(MAX), @DataDesc NVARCHAR(MAX)

			DECLARE CUR_Ancillary_Data CURSOR FOR SELECT  Acq_Deal_Ancillary_Code, Title_Code, Acq_Deal_Code, Ancillary_Type_code FROM #TempAcqAncillaryCursor

			OPEN CUR_Ancillary_Data
			FETCH FROM CUR_Ancillary_Data INTO @AcqDealAncillaryCode, @Cur_TitleCode, @Cur_AcqDealCode, @AncillaryTypeCode

			WHILE(@@FETCH_STATUS = 0)
			BEGIN
			
				SELECT @DataValue = COALESCE(@DataValue +' ~ ' ,'') + 
					CASE WHEN ISNULL(CONVERT(VARCHAR,Duration),'')!='' THEN @Durationsec + ' - ' + ISNULL(CONVERT(VARCHAR,Duration),'') ELSE '' END +
					CASE WHEN ISNULL(CONVERT(VARCHAR,Day),'')!='' THEN ' ~' + @PeriodDay + ' - ' + ISNULL(CONVERT(VARCHAR,Day),'') ELSE '' END +
					CASE WHEN ISNULL(Catch_Up_From, '') != '' THEN
						CASE WHEN ISNULL(Catch_Up_From, '') = 'E' THEN  ' ~'+ Ancillary_Type_Name +' - Each Broadcast' WHEN ISNULL(Catch_Up_From, '') = 'F' THEN  ' ~'+ Ancillary_Type_Name +' - First Broadcast' ELSE '' END ELSE ''
					END +
					CASE WHEN ISNULL(Remarks,'')!='' THEN ' ~' + @Remarks + ' - ' + Remarks ELSE '' END, 
					@DataDesc = Ancillary_Type_Name FROM #TempAcqAncillaryCursor 
				WHERE Ancillary_Type_code = @AncillaryTypeCode AND Title_Code = @Cur_TitleCode AND Acq_Deal_Code = @Cur_AcqDealCode AND Acq_Deal_Ancillary_Code = @AcqDealAncillaryCode
			   
			   INSERT INTO #TempAcqAncillaryData (Title_Code, Acq_Deal_Code, Ancillary_Type_code, Data_Desc, Data_Value)
			   SELECT @Cur_TitleCode, @Cur_AcqDealCode, @AncillaryTypeCode, @DataDesc, @DataValue
			  
			   SET @DataValue = NULL

			   FETCH FROM CUR_Ancillary_Data INTO @AcqDealAncillaryCode, @Cur_TitleCode, @Cur_AcqDealCode, @AncillaryTypeCode
			END
			CLOSE CUR_Ancillary_Data
			DEALLOCATE CUR_Ancillary_Data;
		END
		
		PRINT 'Acquisition Ancillary - End'

	END		
	
	SELECT 1 AS GroupOrder, taad.Title_Code AS TitleCode, taad.Acq_Deal_Code AS Deal_Code, taad.Data_Desc AS KeyField,
	       ISNULL(taad.Data_Value,'NA') AS ValueField, 'NA' AS DataValue, taad.Ancillary_Type_code AS FieldOrder, t.Title_Name AS TitleName, 
		   ad.Agreement_No AS AgreementNo, bu.Business_Unit_Name AS BusinessUnitName, dt.Deal_Type_Name AS DealType, ad.Deal_Desc AS DealDescription
	FROM #TempAcqAncillaryData taad
	INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = taad.Acq_Deal_Code
	INNER JOIN Title t ON t.Title_Code= taad.Title_Code
	INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = ad.Business_Unit_Code
	INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = ad.Deal_Type_Code

	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempAcqAncillaryCursor') IS NOT NULL DROP TABLE #TempAcqAncillaryCursor
	IF OBJECT_ID('tempdb..#TempAcqAncillaryData') IS NOT NULL DROP TABLE #TempAcqAncillaryData

END
