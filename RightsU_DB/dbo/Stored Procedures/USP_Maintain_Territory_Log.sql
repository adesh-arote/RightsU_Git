
CREATE PROCEDURE USP_Maintain_Territory_Log
 @Territory_Code INT,
 @UserCode INT,
 @Country_Codes VARCHAR(MAX)
AS  
BEGIN

	SELECT DISTINCT Territory_Code, Country_Code
	INTO #TempTerritory
	FROM Territory_Details
	
	
	INSERT INTO Territory_Deal_Log (Affected_Date,Territory_Code,Deal_Rights_Code,Deal_Code,Deal_Type,User_Code,Country_Codes)
	SELECT GETDATE(), ADRT.Territory_Code, ADR.Acq_Deal_Rights_Code, ADR.Acq_Deal_Code, 'A' AS Deal_Type, 
		@UserCode AS Deal_Type,@Country_Codes AS Country_Codes
	FROM Acq_Deal_Rights ADR
	INNER JOIN Acq_Deal_Rights_Territory ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADRT.Territory_Type = 'G'
	WHERE ADR.Acq_Deal_Rights_Code IN (
		SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Territory WHERE Territory_Code = @Territory_Code
	) AND ADRT.Territory_Code = @Territory_Code


	INSERT INTO Territory_Deal_Log (Affected_Date,Territory_Code,Deal_Rights_Code,Deal_Code,Deal_Type,User_Code,Country_Codes)
	SELECT getdate(), SDRT.Territory_Code, SDR.Syn_Deal_Rights_Code, SDR.Syn_Deal_Code, 'S' AS Deal_Type, 
		@UserCode AS Deal_Type,@Country_Codes AS Country_Codes
	FROM Syn_Deal_Rights SDR
	INNER JOIN Syn_Deal_Rights_Territory SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDRT.Territory_Type = 'G'
	WHERE SDR.Syn_Deal_Rights_Code IN (
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Territory WHERE Territory_Code = @Territory_Code
	) AND SDRT.Territory_Code = @Territory_Code


	DROP TABLE #TempTerritory
END

/*
USP_Maintain_Territory_Log 24, 1
*/