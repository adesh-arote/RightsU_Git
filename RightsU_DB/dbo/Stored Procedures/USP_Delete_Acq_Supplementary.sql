CREATE Procedure [USP_Delete_Acq_Supplementary](@SupplementaryCode int)
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Supplementary]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		delete from [dbo].[Acq_Deal_Supplementary_detail] where Acq_Deal_Supplementary_Code = @SupplementaryCode
		delete from [dbo].[Acq_Deal_Supplementary] where Acq_Deal_Supplementary_Code = @SupplementaryCode
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Supplementary]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End