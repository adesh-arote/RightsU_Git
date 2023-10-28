CREATE Procedure [USP_Delete_Acq_Digital](@DigitalCode int)
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Digital]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		delete from [dbo].[Acq_Deal_Digital_detail] where Acq_Deal_Digital_Code = @DigitalCode
		delete from [dbo].[Acq_Deal_Digital] where Acq_Deal_Digital_Code = @DigitalCode
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Digital]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End