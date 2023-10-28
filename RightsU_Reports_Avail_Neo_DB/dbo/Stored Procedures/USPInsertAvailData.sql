CREATE PROCEDURE [dbo].[USPInsertAvailData](@Avail_Data_UDT [Avail_Data_UDT] READONLY)
AS
BEGIN 	


	Insert into AvailData(Acq_Deal_Rights_Code,Acq_Deal_Code,[Start_Date],End_Date,Is_Exclusive,Title_Code,Platform_Codes,Country_Codes
						,Is_Title_Language,Sub_Language_Codes,Dub_Language_Codes,Episode_From,Episode_To,Is_Theatrical,Is_Processed) 

	Select Distinct U.Acq_Deal_Rights_Code,R.Acq_Deal_Code,CASE WHEN  CONVERT(varchar(10),[Start_Date],101) = '01/01/0001' THEN NULL ELSE [Start_Date] END [Start_Date],
	CASE WHEN  CONVERT(varchar(10),End_Date,101) = '01/01/0001' THEN NULL ELSE End_Date END End_Date,U.Is_Exclusive,Title_Code,Platform_Codes,Country_Codes
						,Is_Title_Language,Sub_Language_Codes,Dub_Language_Codes,Episode_From,Episode_To,Is_Theatrical,'N' From @Avail_Data_UDT U
     Left Join Acq_Deal_Rights R on U.Acq_Deal_Rights_Code = R.Acq_Deal_Rights_Code

END
