CREATE PROCEDURE USP_ACq_Deal_Rights_Holdback
(
	@AcqDealRightCode varchar(100)
)
AS
	BEGIN
	
	select distinct T.Title_Name, P.Platform_Name, C.Country_Name,  DATEADD(DAY,ADRH.HB_Run_After_Release_No,Tr.Release_Date) As Release_Date
	from Acq_Deal_Rights_Title ADRT 
	
	INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
	INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
	INNER JOIN Title_Release TR ON TR.Title_Code = ADRT.Title_Code
	INNER JOIN Title_Release_Region TRR ON TRR.Title_Release_Code = TR.Title_Release_Code
	--Inner join Territory_Details TD ON TD.Territory_Code = TRR.Territory_Code
	Inner join Country C ON C.Country_Code = TRR.Country_Code
		INNER JOIN Title_Release_Platforms TRP ON TRP.Title_Release_Code = TR.Title_Release_Code 
	INNER JOIN Platform P ON P.Platform_Code = TRP.Platform_Code
	where ADRH.Acq_Deal_Rights_Holdback_Code = @AcqDealRightCode AND ADRH.Holdback_Type = 'R'
	
	END
