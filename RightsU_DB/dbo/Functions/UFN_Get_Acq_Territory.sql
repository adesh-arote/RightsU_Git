CREATE FUNCTION [dbo].[UFN_Get_Acq_Territory]
(    
 @Acq_Deal_Code AS INT
)     
RETURNS NVARCHAR(max)     
AS    
-- =============================================
-- Author:			Pavitar Dua
-- Create DATE:		08-October-2014
-- Modified DATE:	24-March-2015
-- Modified By:		Abhaysingh N. Rajpurohit
-- Description:		Get Territory/Country/Circuit name depends on conditions
-- =============================================
BEGIN     

	DECLARE @CountryName AS NVARCHAR(MAX)

	DECLARE @Temp TABLE
	(
		Is_Theatrical_Right CHAR(1),
		Territory_Type  CHAR(1),
		Record_Count INT
	)

	INSERT INTO @Temp
	SELECT Is_Theatrical_Right, A.Territory_Type, COUNT(Code) AS Record_Count FROM (
		SELECT DISTINCT ISNULL(ADR.Is_Theatrical_Right, 'N') AS Is_Theatrical_Right, 
		ADRT.Territory_Type, 
		CASE WHEN Territory_Type = 'I' THEN Country_Code ELSE Territory_Code END AS Code
		FROM Acq_Deal_Rights ADR with(nolock)
		INNER JOIN Acq_Deal_Rights_Territory ADRT with(nolock) ON ADRT.Acq_Deal_rights_code = ADR.Acq_Deal_rights_code       
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code
	) AS A
	GROUP BY A.Is_Theatrical_Right, A.Territory_Type


	IF( EXISTS( SELECT TOP 1 Record_Count FROM @Temp WHERE Territory_Type = 'G' AND Record_Count > 1 ) )
		SET @CountryName = COALESCE(@CountryName + ' / ', '') + 'Multiple Territories'

	IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Territory_Type = 'G' AND Record_Count = 1 ) )
	BEGIN
		SELECT TOP 1 @CountryName = COALESCE(@CountryName + ' / ', '') + T.Territory_Name FROM Acq_Deal_Rights ADR with(nolock)
		INNER JOIN Acq_Deal_Rights_Territory ADRT with(nolock) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADRT.Territory_Type = 'G'
		INNER JOIN Territory T with(nolock) ON T.Territory_Code = ADRT.Territory_Code
		Where  ADR.Acq_Deal_Code = @Acq_Deal_Code And ISNULL(ADR.Is_Theatrical_Right, '') In (
			Select Is_Theatrical_Right From @Temp --WHERE Territory_Type = 'G' AND Record_Count = 1
		)
	END

	IF( EXISTS( SELECT TOP 1 Record_Count FROM @Temp WHERE Territory_Type = 'I' AND Record_Count = 1) )
	BEGIN
		SELECT TOP 1 @CountryName = COALESCE(@CountryName + ' / ', '') + C.Country_Name FROM Acq_Deal_Rights ADR with(nolock)
		INNER JOIN Acq_Deal_Rights_Territory ADRT with(nolock) ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code AND ADRT.Territory_Type = 'I'
		INNER JOIN Country C with(nolock) ON C.Country_Code= ADRT.Country_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code And ISNULL(ADR.Is_Theatrical_Right, '') In (
			Select Is_Theatrical_Right From @Temp
		)
	END

	IF( EXISTS( SELECT TOP 1 Record_Count FROM @Temp WHERE Is_Theatrical_Right = 'N' AND Territory_Type = 'I' AND Record_Count > 1 ) )
		SET @CountryName =  COALESCE(@CountryName + ' / ', '')  + 'Multiple Countries'

	IF( EXISTS( SELECT TOP 1 Record_Count FROM @Temp WHERE Is_Theatrical_Right = 'Y' AND Territory_Type = 'I' AND Record_Count > 1 ) )
		SET @CountryName =  COALESCE(@CountryName + ' / ', '')  + 'Multiple Circuits'

	RETURN @CountryName    
         
END
/*
SELECT [dbo].[UFN_Get_Acq_Territory] (70)
*/
