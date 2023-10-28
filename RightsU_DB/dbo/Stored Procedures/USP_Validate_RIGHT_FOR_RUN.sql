CREATE PROCEDURE [dbo].[USP_Validate_RIGHT_FOR_RUN]
	@ACQ_DEAL_CODE int
AS
-- =============================================
-- Author:		Bhavesh Desai
-- Create DATE: 29-October-2014
-- Description:	Validation  before adding Run ,check any rights have satellite platform right to add run definition
-- =============================================
BEGIN
	Declare @Loglevel int  
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_RIGHT_FOR_RUN]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		DECLARE @Result varchar(2)
		set @Result = 'N'
		IF(
			(
				select  Count(AD.Acq_Deal_Code) from Acq_Deal AD (NOLOCK) 
				inner join Acq_Deal_Rights ADR (NOLOCK)  on AD.Acq_Deal_Code = ADR.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP  (NOLOCK) on ADRP.Acq_Deal_Rights_Code= ADR.Acq_Deal_Rights_Code
				inner join Platform P (NOLOCK)  on P.Platform_Code = ADRP.Platform_Code AND p.Is_No_Of_Run = 'Y'
				where AD.Acq_Deal_Code = @ACQ_DEAL_CODE
			) > 0
		  )
		  BEGIN
			set @Result = 'Y'
		  END
	
		select @Result as Result
	   
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_RIGHT_FOR_RUN]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
