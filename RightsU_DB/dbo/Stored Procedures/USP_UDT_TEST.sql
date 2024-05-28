CREATE PROCEDURE [dbo].[USP_UDT_TEST]
 (
	@ds_Acq_Deal Acq_Deal_Code_Rights_Title_UDT READONLY
 )
 AS 
 -- Pavitar Test Proc 
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_UDT_TEST]', 'Step 1', 0, 'Started Procedure', 0, ''  
		SET FMTONLY OFF
	
		SELECT T.Title_Code, Title_Name  	
		 FROM Title T (NOLOCK)
		 INNER JOIN @ds_Acq_Deal Temp ON T.Title_Code=Temp.TItle_Code
     
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_UDT_TEST]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END
