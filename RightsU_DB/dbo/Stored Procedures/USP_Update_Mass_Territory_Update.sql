CREATE PROCEDURE [dbo].[USP_Update_Mass_Territory_Update]
	@acqDealMassCodes varchar(1000),
	@DealFor Varchar(1)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Update_Mass_Territory_Update]', 'Step 1', 0, 'Started Procedure', 0, ''  
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Insert statements for procedure here
	--	SELECT * from Acq_Deal_Mass_Territory_Update where Acq_Deal_Mass_Update_Code in (select number from dbo.[fn_Split_withdelemiter](@acqDealMassCodes,'~'))
	
		IF(@DealFor = 'A')
		BEGIN
    
		update 
			Acq_Deal_Mass_Territory_Update 
		set Can_Process='Y' 
		where 
			Acq_Deal_Mass_Update_Code in (select number from dbo.[fn_Split_withdelemiter](@acqDealMassCodes,'~'))
		
		END
		ELSE
		BEGIN
	
		update 
			Syn_Deal_Mass_Territory_Update 
		set Can_Process='Y' 
		where 
			Syn_Deal_Mass_Update_Code in (select number from dbo.[fn_Split_withdelemiter](@acqDealMassCodes,'~'))
		
		END
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Update_Mass_Territory_Update]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END
