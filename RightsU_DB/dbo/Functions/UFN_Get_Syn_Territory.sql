
CREATE FUNCTION [dbo].[UFN_Get_Syn_Territory]    
(    
 @Syn_Deal_Code AS INT    
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
		SELECT DISTINCT ISNULL(SDR.Is_Theatrical_Right, 'N') AS Is_Theatrical_Right, 
		SDRT.Territory_Type, 
		CASE WHEN Territory_Type = 'I' THEN Country_Code ELSE Territory_Code END AS Code
		FROM Syn_Deal_Rights SDR WITH(NOLOCK)
		INNER JOIN Syn_Deal_Rights_Territory SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_rights_code = SDR.Syn_Deal_rights_code       
		WHERE SDR.Syn_Deal_Code = @Syn_Deal_Code AND ISNULL(SDR.Is_Pushback, 'N') = 'N'
	) AS A
	GROUP BY A.Is_Theatrical_Right, A.Territory_Type


	IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Territory_Type = 'G' AND Record_Count > 1 ) )
		SET @CountryName = COALESCE(@CountryName + ' / ', '') + 'Multiple Territories'

	IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Territory_Type = 'G' AND Record_Count = 1 ) )
	BEGIN
		SELECT TOP 1 @CountryName = COALESCE(@CountryName + ' / ', '') + T.Territory_Name FROM Syn_Deal_Rights SDR WITH(NOLOCK)
		INNER JOIN Syn_Deal_Rights_Territory SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code AND SDRT.Territory_Type = 'G'
		INNER JOIN Territory T WITH(NOLOCK) ON T.Territory_Code = SDRT.Territory_Code
		WHERE ISNULL(SDR.Is_Pushback, 'N') = 'N' AND SDR.Syn_Deal_Code = @Syn_Deal_Code And ISNULL(SDR.Is_Theatrical_Right, '') In (
			Select Is_Theatrical_Right From @Temp --WHERE Territory_Type = 'G' AND Record_Count = 1
		)
	END

	IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Territory_Type = 'I' AND Record_Count = 1) )
	BEGIN
		SELECT TOP 1 @CountryName = COALESCE(@CountryName + ' / ', '') + C.Country_Name FROM Syn_Deal_Rights SDR WITH(NOLOCK)
		INNER JOIN Syn_Deal_Rights_Territory SDRT WITH(NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code AND SDRT.Territory_Type = 'I'
		INNER JOIN Country C WITH(NOLOCK) ON C.Country_Code= SDRT.Country_Code
		WHERE SDR.Syn_Deal_Code = @Syn_Deal_Code AND ISNULL(SDR.Is_Pushback, 'N') = 'N' And ISNULL(SDR.Is_Theatrical_Right, '') In (
			Select Is_Theatrical_Right From @Temp --WHERE Territory_Type = 'G' AND Record_Count = 1
		)
	END

	--IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Territory_Type = 'I' AND Record_Count = 1 AND Is_Theatrical_Right = 'N' ) )
	--BEGIN
	--	SELECT TOP 1 @CountryName = COALESCE(@CountryName + ' / ', '') + C.Country_Name FROM Syn_Deal_Rights SDR
	--	INNER JOIN Syn_Deal_Rights_Territory SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code AND SDRT.Territory_Type = 'I'
	--	INNER JOIN Country C ON C.Country_Code= SDRT.Country_Code
	--	WHERE ISNULL(SDR.Is_Theatrical_Right, '') = 'N' AND SDR.Syn_Deal_Code = @Syn_Deal_Code AND ISNULL(SDR.Is_Pushback, 'N') = 'N'
	--END


	IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Is_Theatrical_Right = 'N' AND Territory_Type = 'I' AND Record_Count > 1 ) )
		SET @CountryName =  COALESCE(@CountryName + ' / ', '')  + 'Multiple Countries'

	IF( EXISTS( SELECT TOP 1 * FROM @Temp WHERE Is_Theatrical_Right = 'Y' AND Territory_Type = 'I' AND Record_Count > 1 ) )
		SET @CountryName =  COALESCE(@CountryName + ' / ', '')  + 'Multiple Circuits'

	RETURN @CountryName      
END