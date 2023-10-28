CREATE PROCEDURE [dbo].[USP_Validate_RIGHT_FOR_SYN_RUN]
	@SYN_DEAL_CODE int
AS
-- =============================================
-- Author:		Rajesh Godse
-- Create DATE: 24-Feb-2015
-- Description:	Validation  before adding Run ,check any rights have satellite platform right to add run definition
-- =============================================

BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_RIGHT_FOR_SYN_RUN]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @Result varchar(2)
		set @Result = 'N'
		IF(
			(
				select  Count(SD.Syn_Deal_Code) from Syn_Deal SD (NOLOCK)
				inner join Syn_Deal_Rights SDR (NOLOCK) on SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Is_Pushback,'') = 'N'
				inner join Syn_Deal_Rights_Platform SDRP (NOLOCK) on SDRP.Syn_Deal_Rights_Code= SDR.Syn_Deal_Rights_Code
				inner join Platform P (NOLOCK) on P.Platform_Code = SDRP.Platform_Code AND P.Is_Applicable_Syn_Run = 'Y'
			
				where SD.Syn_Deal_Code = @SYN_DEAL_CODE
			) > 0
		  )
		  BEGIN
			set @Result = 'Y'
		  END
	
		select @Result as Result
	  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_RIGHT_FOR_SYN_RUN]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
