CREATE PROCEDURE [dbo].[USP_Validate_Country_Territory]
 @Country_Codes VARCHAR(MAX),
 @Territory_Code INT
AS  
BEGIN
	Declare @Loglevel  int; 

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Validate_Country_Territory]', 'Step 1', 0, 'Started Procedure', 0, ''  
		--DECLARE @currentCountries VARCHAR(MAX)=''
	
		--SELECT DISTINCT @currentCountries = STUFF(( SELECT DISTINCT ',' + CAST(TD.Country_Code AS VARCHAR)
		--FROM Territory_Details TD WHERE TD.Territory_Code = @Territory_Code
		--FOR XML PATH('')), 1, 1, '')
	
		--PRINT @currentCountries
	
	
		DECLARE @cntCountry INT
		DECLARE @cntDeal INT
	
		SELECT @cntCountry = COUNT(*)
		FROM Acq_Deal_Rights ADR (NOLOCK)
		INNER JOIN Acq_Deal_Rights_Territory ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADRT.Territory_Type = 'G'
		INNER JOIN Territory_Details TD (NOLOCK) ON TD.Territory_Code = ADRT.Territory_Code
		WHERE ADR.Acq_Deal_Rights_Code IN (
			SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory (NOLOCK) WHERE Territory_Code = @Territory_Code
		)
		AND ADRT.Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Country_Codes,','))

		SELECT @cntDeal = COUNT(*)
		FROM Acq_Deal_Rights_Territory (NOLOCK) WHERE Acq_Deal_Rights_Code IS NOT NULL AND Territory_Code=@Territory_Code

		SELECT CAST(@cntCountry AS VARCHAR) + '~' + CAST(@cntDeal AS VARCHAR)
	   
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Validate_Country_Territory]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
