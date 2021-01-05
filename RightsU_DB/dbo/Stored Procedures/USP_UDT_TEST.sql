
CREATE PROCEDURE [dbo].[USP_UDT_TEST]
 (
	@ds_Acq_Deal Acq_Deal_Code_Rights_Title_UDT READONLY
 )
 AS 
 -- Pavitar Test Proc 
BEGIN
	SET FMTONLY OFF
	
	SELECT T.Title_Code, Title_Name  	
     FROM Title T
     INNER JOIN @ds_Acq_Deal Temp ON T.Title_Code=Temp.TItle_Code
     
END
