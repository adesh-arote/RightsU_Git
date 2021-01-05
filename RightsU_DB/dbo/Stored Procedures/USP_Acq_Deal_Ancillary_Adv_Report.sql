
CREATE PROCEDURE [dbo].[USP_Acq_Deal_Ancillary_Adv_Report]
(
	@Agreement_No VARCHAR(MAX),
	@Title_Codes VARCHAR(MAX),
	@Platform_Codes VARCHAR(MAX),
	@Ancillary_Type_Code VARCHAR(MAX),
	@Business_Unit_Code INT,
	@IncludeExpired VARCHAR(MAX)
)
AS
 --=============================================
 --Author:		Akshay Rane
 --Create DATE:	16-April-2018
 --Description:	Show Platform wise Ancillary Advance report
 --=============================================
BEGIN

	--DECLARE
	--@Agreement_No VARCHAR(MAX),
	--@Title_Codes VARCHAR(MAX),
	--@Platform_Codes VARCHAR(MAX),
	--@Ancillary_Type_Code VARCHAR(MAX),
	--@Business_Unit_Code INT,
	--@IncludeExpired VARCHAR(MAX)

	--SELECT
	--@Agreement_No = '',
	--@Title_Codes = '0',
	--@Platform_Codes = '0',
	--@Ancillary_Type_Code = '1,2' ,
	--@Business_Unit_Code = 1,
	--@IncludeExpired = 'N'


	IF(OBJECT_ID('tempdb..#GetDealTypeCondition') IS NOT NULL) DROP TABLE #GetDealTypeCondition
	IF(OBJECT_ID('tempdb..#AncillaryTypeCode') IS NOT NULL) DROP TABLE #AncillaryTypeCode
	IF(OBJECT_ID('tempdb..#PlatformCode') IS NOT NULL) DROP TABLE #PlatformCode

	DECLARE @Acq_Deal_Code int  = 0
	DECLARE @Ancillary_Deal TABLE( Acq_Deal_Ancillary_Code INT, Title_Code INT)

	create table #GetDealTypeCondition(
		DealType VARCHAR(MAX),
		Deal_Type_Code INT
	)

	CREATE TABLE #AncillaryTypeCode
	(
		Ancillary_Type_Code INT
	)

	CREATE TABLE #PlatformCode
	(
		Platform_Code INT
	)

	IF(@Title_Codes = '0')
	BEGIN
		SET @Title_Codes = ''
	END

	IF(@Platform_Codes = '0')
	BEGIN
		SET @Platform_Codes = ''
	END

	IF(@Ancillary_Type_Code = '0')
	BEGIN
		SET @Ancillary_Type_Code = ''
	END

	INSERT INTO #AncillaryTypeCode
	SELECT number FROM fn_Split_withdelemiter(@Ancillary_Type_Code, ',')

	INSERT INTO #PlatformCode
	SELECT number FROM fn_Split_withdelemiter(@Platform_Codes, ',')

	IF (@Agreement_No <> '' AND @Title_Codes = '') -- Agreement No = A-2018-00129 /  Title Codes = ''
	BEGIN
		PRINT 'STEP 1 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes

		SELECT @Acq_Deal_Code = Acq_Deal_Code FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No = @Agreement_No AND Business_Unit_Code = @Business_Unit_Code

		INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)
		SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary WHERE Acq_deal_Code = @Acq_Deal_Code 
	END
	ELSE IF (@Title_Codes <> '' AND @Agreement_No = '') --  Agreement No = '' /  Title Codes = '12,13,14,5'
	BEGIN
		PRINT 'STEP 2 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes

		INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code, Title_Code)
		SELECT ADAT.Acq_Deal_Ancillary_Code, ADAT.Title_Code FROM Acq_Deal_Ancillary_title ADAT 
		INNER JOIN Acq_Deal_Ancillary ADA ON ADA.Acq_Deal_Ancillary_Code = ADAT.Acq_Deal_Ancillary_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADA.Acq_Deal_Code AND Business_Unit_Code = @Business_Unit_Code
		WHERE ADAT.Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))
	END
	ELSE IF (@Title_Codes = '' AND @AGREEMENT_NO = '') -- Agreement No = '' / Title Codes = ''
	BEGIN
		PRINT 'STEP 3 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes

		DECLARE @AcqDeal TABLE ( Acq_Deal_Code INT)

		INSERT INTO @AcqDeal (Acq_Deal_Code)
		SELECT  Acq_Deal_Code  FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Business_Unit_Code = @Business_Unit_Code

		INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)
		SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary WHERE Acq_deal_Code IN (SELECT Acq_Deal_Code FROM @AcqDeal)
	END
	ELSE IF (@Title_Codes <> '' AND @Agreement_No <> '') -- Agreement No = A-2018-00129 / Title Codes = '12,13,14,5'
	BEGIN
		PRINT 'STEP 4 : Agreement No - ' + @Agreement_No + ' /  Title Codes - ' + @Title_Codes

		SELECT @Acq_Deal_Code = Acq_Deal_Code FROM Acq_deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No = @Agreement_No AND Business_Unit_Code = @Business_Unit_Code

		INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code, Title_Code)
		SELECT ADT.Acq_Deal_Ancillary_Code, ADT.Title_Code FROM Acq_Deal_Ancillary ADA
		INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		WHERE ADA.Acq_deal_Code = @Acq_Deal_Code AND 
		ADT.Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))
	END

	INSERT INTO #GetDealTypeCondition(Deal_Type_Code)
	SELECT DISTINCT ad.Deal_Type_Code
	FROM Acq_Deal_Ancillary ada
	INNER JOIN Acq_Deal ad ON ada.Acq_Deal_Code = ad.Acq_Deal_Code
	WHERE Business_Unit_Code = @Business_Unit_Code

	UPDATE #GetDealTypeCondition SET DealType = DBO.UFN_GetDealTypeCondition(Deal_Type_Code)

	SELECT DISTINCT 
		AD.Agreement_No, 
		ADT.Title_Code, 
		DBO.UFN_GetTitleNameInFormat(GDTC.DealType, 
		T.Title_Name, ADT.Episode_From, ADT.Episode_To) AS Title_Name,
		CASE GDTC.DealType WHEN 'DEAL_MOVIE' THEN 'Movie' WHEN 'DEAL_PROGRAM' THEN 'Program' END  AS Title_Type,
		AT.Ancillary_Type_Name,
		ISNULL(CAST(ADA.Duration AS VARCHAR(MAX)),'') AS Duration,
		ISNULL(CAST(ADA.Day AS VARCHAR(MAX)),'')  AS Day,
		ADA.Remarks,
		P.Platform_Hiearachy,
		P.Platform_Code,
		'YES' Available
	FROM Acq_Deal_Ancillary ADA 
		INNER JOIN Acq_Deal_Ancillary_Platform ADP ON ADA.Acq_Deal_Ancillary_Code = ADP.Acq_Deal_Ancillary_Code
		INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		INNER JOIN Platform P On P.Platform_Code = ADP.Platform_Code
		INNER JOIN Acq_Deal AD ON  ADA.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Business_Unit_Code = @Business_Unit_Code
		INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code 
		INNER JOIN Title T On ADT.Title_Code = T.Title_Code
		INNER JOIN Ancillary_Type AT ON AT.Ancillary_Type_Code = ADA.Ancillary_Type_Code
		INNER JOIN #GetDealTypeCondition GDTC ON AD.Deal_Type_Code = GDTC.Deal_Type_Code
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
		AND ADA.Acq_Deal_Ancillary_Code  IN (SELECT Acq_Deal_Ancillary_Code FROM @Ancillary_Deal)
		AND ( @Title_Codes = '' OR (ADT.Title_Code  IN (SELECT Title_Code FROM @Ancillary_Deal)))
		AND (@Ancillary_Type_Code  = '' OR (ADA.Ancillary_Type_code IN (SELECT DISTINCT Ancillary_Type_code FROM #AncillaryTypeCode) AND @Ancillary_Type_Code <> ''))
		AND (@Platform_Codes  = '' OR (P.Platform_Code IN (SELECT DISTINCT Platform_Code FROM #PlatformCode )AND @Platform_Codes <> ''))
		AND (ADR.Actual_Right_Start_Date IS NOT NULL AND ISNULL(ADR.Actual_Right_End_Date, '31DEC9999') >= GETDATE() OR @IncludeExpired = 'Y')

		IF(OBJECT_ID('tempdb..#GetDealTypeCondition') IS NOT NULL) DROP TABLE #GetDealTypeCondition
		IF(OBJECT_ID('tempdb..#AncillaryTypeCode') IS NOT NULL) DROP TABLE #AncillaryTypeCode
		IF(OBJECT_ID('tempdb..#PlatformCode') IS NOT NULL) DROP TABLE #PlatformCode
END
