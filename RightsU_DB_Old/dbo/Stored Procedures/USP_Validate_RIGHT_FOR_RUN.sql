
CREATE PROCEDURE [dbo].[USP_Validate_RIGHT_FOR_RUN]
	@ACQ_DEAL_CODE int
AS
-- =============================================
-- Author:		Bhavesh Desai
-- Create DATE: 29-October-2014
-- Description:	Validation  before adding Run ,check any rights have satellite platform right to add run definition
-- =============================================

BEGIN
	
	DECLARE @Result varchar(2)
	set @Result = 'N'
	IF(
		(
			select  Count(AD.Acq_Deal_Code) from Acq_Deal AD
			inner join Acq_Deal_Rights ADR on AD.Acq_Deal_Code = ADR.Acq_Deal_Code
			inner join Acq_Deal_Rights_Platform ADRP on ADRP.Acq_Deal_Rights_Code= ADR.Acq_Deal_Rights_Code
			inner join Platform P on P.Platform_Code = ADRP.Platform_Code AND p.Is_No_Of_Run = 'Y'
			where AD.Acq_Deal_Code = @ACQ_DEAL_CODE
		) > 0
	  )
	  BEGIN
		set @Result = 'Y'
	  END
	
	select @Result as Result
END