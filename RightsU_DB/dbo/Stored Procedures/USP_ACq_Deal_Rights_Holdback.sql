CREATE PROCEDURE [dbo].[USP_ACq_Deal_Rights_Holdback]
(
	@AcqDealRightCode varchar(100)
)
AS
BEGIN
	Declare @Loglevel int;	  	  
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_ACq_Deal_Rights_Holdback]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		select distinct T.Title_Name, P.Platform_Name, C.Country_Name,  DATEADD(DAY,ADRH.HB_Run_After_Release_No,Tr.Release_Date) As Release_Date
		from Acq_Deal_Rights_Title ADRT (NOLOCK)
	
		INNER JOIN Acq_Deal_Rights_Holdback ADRH (NOLOCK) ON ADRH.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT (NOLOCK) ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
		INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
		INNER JOIN Title_Release TR (NOLOCK) ON TR.Title_Code = ADRT.Title_Code
		INNER JOIN Title_Release_Region TRR (NOLOCK) ON TRR.Title_Release_Code = TR.Title_Release_Code
		--Inner join Territory_Details TD ON TD.Territory_Code = TRR.Territory_Code
		Inner join Country C (NOLOCK) ON C.Country_Code = TRR.Country_Code
		INNER JOIN Title_Release_Platforms TRP (NOLOCK) ON TRP.Title_Release_Code = TR.Title_Release_Code 
		INNER JOIN Platform P (NOLOCK) ON P.Platform_Code = TRP.Platform_Code
		where ADRH.Acq_Deal_Rights_Holdback_Code = @AcqDealRightCode AND ADRH.Holdback_Type = 'R'
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_ACq_Deal_Rights_Holdback]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
