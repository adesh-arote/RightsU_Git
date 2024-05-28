CREATE PROCEDURE [dbo].[USPAL_GetBookingSheetData]
(
	@BookingSheetCode INT,
	@Display_For CHAR(1)
)
AS
BEGIN

	INSERT INTO TestParam(ModuleCode, AgreementNo) VALUES(213, CAST(@BookingSheetCode AS VARCHAR) + '-' + @Display_For)

	IF OBJECT_ID('tempdb..#TempBookingData') IS NOT NULL DROP TABLE #TempBookingData
	IF OBJECT_ID('tempdb..#TempBookingSheetDetail') IS NOT NULL DROP TABLE #TempBookingSheetDetail
	IF OBJECT_ID('tempdb..#TempBookingSheetDet') IS NOT NULL DROP TABLE #TempBookingSheetDet

	CREATE TABLE #TempBookingData
	(
		Title_Content_Code INT,
		TitleName	NVARCHAR(MAX),
		Columns_Name NVARCHAR(MAX),	
		Columns_Value NVARCHAR(MAX),	
		Columns_Code INT,
		AL_Recommendation_Content_Code INT
	)
	 
	CREATE TABLE #TempBookingSheetDetail
	(
		Extended_Group_Code NVARCHAR(MAX), 
		Columns_Code INT,
		Column_Name NVARCHAR(MAX),
		Group_Control_Order INT
	)

	CREATE TABLE #TempBookingSheetDet
	(
		AL_Booking_Sheet_Code INT, 
		Title_Code INT,
		Title_Content_Code INT,
		Columns_Code INT,
		Columns_Value NVARCHAR(MAX),
		Display_Name NVARCHAR(MAX),
		Extended_Group_Code INT,
		Group_Control_Order INT

	)

	 DECLARE @ColNames NVARCHAR(MAX) = '', @query NVARCHAR(MAX) = '';
	 DECLARE @RecommendationCode INT = 0, @VendorCode INT = 0, @Extended_Group_ForBookingSheet INT = 0
	 DECLARE @MovieCodes VARCHAR(100) = '', @ShowCodes VARCHAR(100) = '', @DealTypeCode NVARCHAR(100) = '';

	 SET @MovieCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies');
	 SET @ShowCodes = (SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show');

	 IF(@Display_For = 'M')
	 BEGIN
		SET @DealTypeCode = @MovieCodes
	 END
	 ELSE
	 BEGIN
		SET @DealTypeCode = @ShowCodes
	 END

	 SELECT @VendorCode = Vendor_Code, @RecommendationCode = AL_Recommendation_Code FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = @BookingSheetCode
	 SELECT @Extended_Group_ForBookingSheet = Extended_Group_Code_Booking FROM AL_Vendor_Details WHERE Vendor_Code = @VendorCode

	 INSERT INTO #TempBookingSheetDet (AL_Booking_Sheet_Code, Title_Code, Title_Content_Code, Columns_Code, Columns_Value, Display_Name, Extended_Group_Code, Group_Control_Order)
	 SELECT AL_Booking_Sheet_Code, Title_Code, Title_Content_Code, Columns_Code, Columns_Value, Display_Name, Extended_Group_Code, Group_Control_Order 
	 FROM AL_Booking_Sheet_Details
	 WHERE AL_Booking_Sheet_Code = @BookingSheetCode

	 INSERT INTO #TempBookingData(Title_Content_Code, TitleName, Columns_Name, Columns_Value, Columns_Code, AL_Recommendation_Content_Code)
	 SELECT absd.Title_Content_Code,
		CASE WHEN @Display_For = 'S' THEN tc.Episode_Title + '(' + CAST(tc.Episode_No AS VARCHAR) + ')' ELSE t.Title_Name END TITLE, 
		ec.Columns_Name, absd.Columns_Value, ec.Columns_Code, arc.AL_Recommendation_Content_Code
	 FROM AL_Recommendation_Content arc
		INNER JOIN #TempBookingSheetDet absd ON arc.Title_Code = absd.Title_Code AND ISNULL(arc.Title_Content_Code, 0) = ISNULL(absd.Title_Content_Code, 0)
		INNER JOIN Extended_Columns ec ON absd.Columns_Code = ec.Columns_Code
		INNER JOIN Title t ON absd.Title_Code = t.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter](@DealTypeCode,','))
		LEFT JOIN Title_Content tc ON absd.Title_Content_Code = tc.Title_Content_Code
	 WHERE arc.AL_Recommendation_Code = @RecommendationCode AND absd.AL_Booking_Sheet_Code = @BookingSheetCode AND 
		absd.Display_Name IN(@Display_For, 'B') 

	 INSERT INTO #TempBookingSheetDetail(Extended_Group_Code, Columns_Code, Group_Control_Order, Column_Name)
	 SELECT absd.Extended_Group_Code, absd.Columns_Code, absd.Group_Control_Order, ec.Columns_Name
	 FROM AL_Recommendation_Content arc
		INNER JOIN #TempBookingSheetDet absd ON arc.Title_Code = absd.Title_Code AND ISNULL(arc.Title_Content_Code, 0) = ISNULL(absd.Title_Content_Code, 0)
		INNER JOIN Extended_Columns ec ON absd.Columns_Code = ec.Columns_Code
		INNER JOIN Title t ON absd.Title_Code = t.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter](@DealTypeCode,','))
		LEFT JOIN Title_Content tc ON absd.Title_Content_Code = tc.Title_Content_Code
	 WHERE arc.AL_Recommendation_Code = @RecommendationCode AND absd.AL_Booking_Sheet_Code = @BookingSheetCode AND 
		absd.Display_Name IN(@Display_For, 'B') 

	IF EXISTS(SELECT TOP 1 * FROM #TempBookingSheetDetail)
		BEGIN
			SELECT @ColNames = STUFF((
			SELECT ', [' + intbl.Column_Name + ']' FROM (
				SELECT DISTINCT Column_Name, Group_Control_Order FROM #TempBookingSheetDetail
			) AS intbl ORDER BY Group_Control_Order ASC
			FOR XML PATH('')), 1, 2, '')			
		END
	ELSE
		BEGIN
			SELECT  @ColNames = STUFF((
			SELECT ', [' + intbl.Columns_Name + ']' FROM (
				SELECT ec.Columns_Name, egc.Group_Control_Order FROM Extended_Group_Config egc 
				INNER JOIN Extended_Columns ec ON ec.Columns_Code = egc.Columns_Code
				WHERE egc.Extended_Group_Code = @Extended_Group_ForBookingSheet AND egc.Display_Name IN(@Display_For, 'B') 
			) AS intbl ORDER BY Group_Control_Order ASC
			FOR XML PATH('')), 1, 2, '')
		END

    --SELECT @query = 'SELECT * INTO #TempFinalResult FROM (SELECT (SELECT TOP 1 ISNULL(Rule_Short_Name,'''') FROM AL_Vendor_Rule WHERE Rule_Name COLLATE SQL_Latin1_General_CP1_CI_AS = neo.[Title Category]) AS OrderByShortName, ' + @ColNames + ' FROM (Select Title_Content_Code, '+@ColNames+' from ( Select tb.Title_Content_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value from #TempBookingData tb ) a
				--	pivot (max(Columns_Value) for Columns_Name in ('+@ColNames+')) p) AS neo ) AS T ORDER BY OrderByShortName, [TITLE] ALTER TABLE #TempFinalResult DROP COLUMN OrderByShortName SELECT * FROM #TempFinalResult'

	--SELECT @query = 'SELECT ' + @ColNames + ' FROM (Select Title_Content_Code, '+@ColNames+' from ( Select tb.Title_Content_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value from #TempBookingData tb ) a
	--				pivot (max(Columns_Value) for Columns_Name in ('+@ColNames+')) p) AS neo'

	--SELECT @query = 'Select '+@ColNames+' from ( Select tb.TitleName, tb.Columns_Name, tb.Columns_Value  from #TempBookingData tb ) a
	--					 pivot (max(Columns_Value) for Columns_Name in ('+@ColNames+')) p'

	IF (NOT EXISTS(Select TOP 1 * from #TempBookingData where Columns_Name = 'Title Category')) -- OR NOT EXISTS(Select TOP 1 * from #TempBookingData where Columns_Name = 'Display Order')
	BEGIN
		--SELECT @query = 'SELECT '+@ColNames+' from ( SELECT tb.TitleName, tb.Columns_Name, tb.Columns_Value  from #TempBookingData tb ) a
		--				 pivot (max(Columns_Value) for Columns_Name in ('+@ColNames+')) p'
		SELECT @query = 'SELECT '+@ColNames+' FROM (SELECT '+@ColNames+', AL_Recommendation_Content_Code from ( SELECT tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.AL_Recommendation_Content_Code  from #TempBookingData tb ) a
						 pivot (max(Columns_Value) for Columns_Name in ('+@ColNames+')) p) AS T ORDER BY AL_Recommendation_Content_Code'
	END
	ELSE
	BEGIN
		--SELECT @query = 'SELECT * INTO #TempFinalResult FROM (SELECT (SELECT TOP 1 ISNULL(Rule_Short_Name,'''') FROM AL_Vendor_Rule WHERE Rule_Name COLLATE SQL_Latin1_General_CP1_CI_AS = neo.[Title Category]) AS OrderByShortName, ' + @ColNames + ' FROM (Select Title_Content_Code, '+@ColNames+' from ( Select tb.Title_Content_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value from #TempBookingData tb ) a
		--			pivot (max(Columns_Value) for Columns_Name in ('+@ColNames+')) p) AS neo ) AS T ORDER BY OrderByShortName, [TITLE] ALTER TABLE #TempFinalResult DROP COLUMN OrderByShortName SELECT * FROM #TempFinalResult'
		SELECT @query = 'SELECT * INTO #TempFinalResult FROM (SELECT (SELECT TOP 1 ISNULL(Rule_Short_Name,'''') FROM AL_Vendor_Rule WHERE Rule_Name COLLATE SQL_Latin1_General_CP1_CI_AS = neo.[Title Category]) AS OrderByShortName, ' + @ColNames + ', AL_Recommendation_Content_Code FROM (Select Title_Content_Code, '+@ColNames+', AL_Recommendation_Content_Code from ( Select tb.Title_Content_Code, tb.TitleName, tb.Columns_Name, tb.Columns_Value, tb.AL_Recommendation_Content_Code from #TempBookingData tb ) a
					pivot (max(Columns_Value) for Columns_Name in ('+@ColNames+')) p) AS neo ) AS T ORDER BY OrderByShortName, AL_Recommendation_Content_Code  ALTER TABLE #TempFinalResult DROP COLUMN OrderByShortName ALTER TABLE #TempFinalResult DROP COLUMN AL_Recommendation_Content_Code SELECT * FROM #TempFinalResult'
	END

	EXEC (@query)

	IF OBJECT_ID('tempdb..#TempBookingData') IS NOT NULL DROP TABLE #TempBookingData
	IF OBJECT_ID('tempdb..#TempBookingSheetDetail') IS NOT NULL DROP TABLE #TempBookingSheetDetail
	IF OBJECT_ID('tempdb..#TempBookingSheetDet') IS NOT NULL DROP TABLE #TempBookingSheetDet

END