
CREATE PROCEDURE USP_Validate_Country_Territory
 @Country_Codes VARCHAR(MAX),
 @Territory_Code INT
AS  
BEGIN

	--DECLARE @currentCountries VARCHAR(MAX)=''
	
	--SELECT DISTINCT @currentCountries = STUFF(( SELECT DISTINCT ',' + CAST(TD.Country_Code AS VARCHAR)
	--FROM Territory_Details TD WHERE TD.Territory_Code = @Territory_Code
	--FOR XML PATH('')), 1, 1, '')
	
	--PRINT @currentCountries
	
	
	DECLARE @cntCountry INT
	DECLARE @cntDeal INT
	
	SELECT @cntCountry = COUNT(*)
	FROM Acq_Deal_Rights ADR
	INNER JOIN Acq_Deal_Rights_Territory ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADRT.Territory_Type = 'G'
	INNER JOIN Territory_Details TD ON TD.Territory_Code = ADRT.Territory_Code
	WHERE ADR.Acq_Deal_Rights_Code IN (
		SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory WHERE Territory_Code = @Territory_Code
	)
	AND ADRT.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Country_Codes,','))

	SELECT @cntDeal = COUNT(*)
	FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code IS NOT NULL AND Territory_Code=@Territory_Code

	SELECT CAST(@cntCountry AS VARCHAR) + '~' + CAST(@cntDeal AS VARCHAR)
END