
CREATE PROCEDURE [dbo].[USP_Validate_RIGHT_FOR_SYN_RUN]
	@SYN_DEAL_CODE int
AS
-- =============================================
-- Author:		Rajesh Godse
-- Create DATE: 24-Feb-2015
-- Description:	Validation  before adding Run ,check any rights have satellite platform right to add run definition
-- =============================================

BEGIN
	
	DECLARE @Result varchar(2)
	set @Result = 'N'
	IF(
		(
			select  Count(SD.Syn_Deal_Code) from Syn_Deal SD
			inner join Syn_Deal_Rights SDR on SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Is_Pushback,'') = 'N'
			inner join Syn_Deal_Rights_Platform SDRP on SDRP.Syn_Deal_Rights_Code= SDR.Syn_Deal_Rights_Code
			inner join Platform P on P.Platform_Code = SDRP.Platform_Code AND P.Is_Applicable_Syn_Run = 'Y'
			
			where SD.Syn_Deal_Code = @SYN_DEAL_CODE
		) > 0
	  )
	  BEGIN
		set @Result = 'Y'
	  END
	
	select @Result as Result
END