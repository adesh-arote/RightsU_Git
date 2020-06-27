ALTER PROCEDURE [dbo].[USP_Acq_Deal_Ancillary_Adv_Report]
(
	@Agreement_No VARCHAR(MAX),
	@Title_Codes VARCHAR(MAX),
	@Platform_Codes VARCHAR(MAX),
	@Ancillary_Type_Code INT,
	@Business_Unit_Code INT
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
	--@Ancillary_Type_Code INT,
	--@Business_Unit_Code INT

	--SELECT
	--@Agreement_No = 'A-2018-00137',
	--@Title_Codes = '',
	--@Platform_Codes = '',
	--@Ancillary_Type_Code = 1,
	--@Business_Unit_Code = 1

	DECLARE @Acq_Deal_Code int  = 0
	DECLARE @Ancillary_Deal TABLE( Acq_Deal_Ancillary_Code INT)

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

		INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)
		SELECT Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary_title WHERE Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))
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

		INSERT INTO @Ancillary_Deal (Acq_Deal_Ancillary_Code)
		SELECT ADT.Acq_Deal_Ancillary_Code FROM Acq_Deal_Ancillary ADA
		INNER JOIN Acq_Deal_Ancillary_title ADT ON ADT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		WHERE ADA.Acq_deal_Code = @Acq_Deal_Code AND 
		ADT.Title_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Title_Codes, ','))
	END
	
	SELECT DISTINCT 
		AD.Agreement_No, 
		ADT.Title_Code, 
		DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADT.Episode_From, ADT.Episode_To) AS Title_Name,
		CASE dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) WHEN 'DEAL_MOVIE' THEN 'Movie' WHEN 'DEAL_PROGRAM' THEN 'Program' END AS Title_Type,
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
		INNER JOIN Title T On ADT.Title_Code = T.Title_Code
		INNER JOIN Ancillary_Type AT ON AT.Ancillary_Type_Code = ADA.Ancillary_Type_Code
		
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
		ADA.Acq_Deal_Ancillary_Code  IN (SELECT Acq_Deal_Ancillary_Code FROM @Ancillary_Deal)
		AND (@Ancillary_Type_Code  = '' OR (ADA.Ancillary_Type_code = @Ancillary_Type_Code AND @Ancillary_Type_Code <> ''))
		AND (@Platform_Codes  = '' OR (P.Platform_Code IN (SELECT DISTINCT number FROM fn_Split_withdelemiter(@Platform_Codes, ','))AND @Platform_Codes <> ''))
END