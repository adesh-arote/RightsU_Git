

CREATE FUNCTION [dbo].[UFN_Is_Deal_Tentative](@DealCode int,@ModuleCode int)
RETURNS VARCHAR(10)
AS 
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 05-November-2014
-- Description:	AcqDeal List - Tentative Column
-- =============================================
BEGIN
	Declare @count INT
	SET @count = 0
	IF(@ModuleCode=30)
	BEGIN
		IF EXISTS
		(
			 select TOP 1 Acq_Deal_Code FROM Acq_Deal_Rights ADR  WITH(NOLOCK)
					WHERE ADR.Acq_Deal_Code = @DealCode		
		)
		BEGIN	
			SELECT @count = COUNT(ADR.Acq_Deal_Rights_code) 		
			FROM Acq_Deal_Rights ADR WITH(NOLOCK) 
			WHERE UPPER(LTRIM(RTRIM(ADR.Is_Tentative))) = 'Y' 
			AND UPPER(LTRIM(RTRIM(ADR.Right_Type))) = 'Y'
			AND ADR.Acq_Deal_Code = @DealCode
		END		
	END
	ELSE 
	BEGIN
		IF EXISTS
		(
			 select TOP 1 Syn_Deal_Code FROM Syn_Deal_Rights SDR  WITH(NOLOCK)
					WHERE SDR.Syn_Deal_Code = @DealCode		
		)
		BEGIN	
			SELECT @count = COUNT(SDR.Syn_Deal_Rights_code) 		
			FROM Syn_Deal_Rights SDR  WITH(NOLOCK)
			WHERE UPPER(LTRIM(RTRIM(ISNULL(SDR.Is_Tentative,'N')))) = 'Y' 
			AND UPPER(LTRIM(RTRIM(SDR.Right_Type))) = 'Y'
			AND SDR.Syn_Deal_Code = @DealCode
		END		
	END
	IF(@count > 0)RETURN 'Yes'
	
	RETURN 'No'
END;