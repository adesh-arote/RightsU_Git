-- =============================================
-- Author:		<Reshma Kunjal>
-- Create date: <19-Jan-2015>
-- Description:	<Update Acq_Mass_Territory_Update Can_Process="Y">
-- =============================================
CREATE PROCEDURE [dbo].[USP_Update_Mass_Territory_Update]
	@acqDealMassCodes varchar(1000),
	@DealFor Varchar(1)
AS
BEGIN
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
END

/*
	exec [USP_Update_Mass_Territory_Update] '287~286~285~284~283~282~281~280~279~278~'
*/