CREATE PROCEDURE [dbo].[USP_Validate_Cost_Duplication_Colors]
	@DealType VARCHAR(100), @TitleCodes VARCHAR(MAX), @Cost_Type_Code INT, @Acq_Deal_Cost_Code INT, @Acq_Deal_Code INT
AS
--|==========================================================================================
--| Author:		  RUSHABH GOHIL
--| Date Created: 15-Apr-2015
--| Description:  Validation to check duplicate combination of Title and Cost Type
--|==========================================================================================
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON
	
	DECLARE @Result INT
	--DECLARE @DealType VARCHAR(10) = 'MOVIE'
	--DECLARE @TitleCodes VARCHAR(MAX) = '5764,6069'
	--DECLARE @Cost_Type_Code INT = 2
	--DECLARE @Acq_Deal_Cost_Code INT = 1219

	IF( UPPER(@DealType) = 'DEAL_MUSIC' OR UPPER(@DealType) = 'DEAL_PROGRAM' )
	BEGIN
		SELECT @result = COUNT(adc.Acq_Deal_Cost_Code) FROM Acq_Deal_Cost adc
		INNER JOIN Acq_Deal_Movie adm ON adm.Acq_Deal_Code = adc.Acq_Deal_Code
		INNER JOIN Acq_Deal_Cost_Title adct ON adct.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code 
			AND adct.Title_Code = adm.Title_Code 
			AND adct.Episode_FROM = adm.Episode_Starts_FROM 
			AND adct.Episode_To = adm.Episode_END_To
		INNER JOIN Acq_Deal_Cost_Costtype adcc ON adcc.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
		WHERE CAST(adm.Acq_Deal_Movie_Code AS VARCHAR) IN (SELECT number FROM DBO.fn_Split_withdelemiter(@TitleCodes, ',')) 
			AND Cost_Type_Code=@Cost_Type_Code 
			AND adc.Acq_Deal_Cost_Code NOT IN (@Acq_Deal_Cost_Code)
			AND adc.Acq_Deal_Code IN (@Acq_Deal_Code)
	END
	ELSE BEGIN
		SELECT @result = COUNT(adc.Acq_Deal_Cost_Code) FROM Acq_Deal_Cost adc
		INNER JOIN Acq_Deal_Cost_Title adct ON adct.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
		INNER JOIN Acq_Deal_Cost_Costtype adcc ON adcc.Acq_Deal_Cost_Code = adc.Acq_Deal_Cost_Code
		WHERE CAST(Title_Code AS VARCHAR) IN (SELECT number FROM DBO.fn_Split_withdelemiter(@TitleCodes, ',')) 
			AND Cost_Type_Code=@Cost_Type_Code 
			AND adc.Acq_Deal_Cost_Code NOT IN (@Acq_Deal_Cost_Code)
			AND adc.Acq_Deal_Code IN (@Acq_Deal_Code)
	END
	
	IF (@Result > 0)
		SELECT 'N' AS Result
	ELSE
		SELECT 'Y' AS Result
END

/*
USP_Validate_Cost_Duplication_Colors 'Deal_Movie', '6069', 6, 1222
USP_Validate_Cost_Duplication_Colors 'Deal_Program', '8046', 6, 1302
*/