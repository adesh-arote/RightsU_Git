CREATE PROCEDURE [dbo].[USP_Acq_Deal_Rights_Holdback_Release]
(
	@AcqDealRightHoldbackCode varchar(100)
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Deal_Rights_Holdback_Release]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SELECT DISTINCT T.Title_Name As Title, P.Platform_Name As Platform, cou.Country_Name As Region,
		REPLACE(CONVERT(CHAR(11), TR.Release_Date, 106),' ','-') AS Release_Date, REPLACE(CONVERT(Char(11),
		 CASE 
		 WHEN ADRH.HB_Run_After_Release_Units = 1 THEN DATEADD(DAY,ADRH.HB_Run_After_Release_No,Tr.Release_Date) 
		  WHEN ADRH.HB_Run_After_Release_Units = 2 THEN DATEADD(WEEK,ADRH.HB_Run_After_Release_No,Tr.Release_Date) 
		   WHEN ADRH.HB_Run_After_Release_Units = 3 THEN DATEADD(MONTH,ADRH.HB_Run_After_Release_No,Tr.Release_Date)
		   ELSE   DATEADD(YEAR,ADRH.HB_Run_After_Release_No,Tr.Release_Date)
		 enD,106),' ','-')
		  As  Holdback_Release_Date
		from Acq_Deal_Rights_Holdback ADRH (NOLOCK)
		INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code
		INNER JOIN Title_Release TR (NOLOCK) ON TR.Title_Code = ADRT.Title_Code
		INNER JOIN Title_Release_Platforms TRP (NOLOCK) ON TRP.Platform_Code = ADRH.Holdback_On_Platform_Code AND Tr.Title_Release_Code = TRP.Title_Release_Code
		INNER JOIN Title_Release_Region TRR (NOLOCK) ON TRR.Title_Release_Code = TR.Title_Release_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT (NOLOCK) ON  ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code 
		INNER JOIN Country cou (NOLOCK) on cou.Country_Code = ADRHT.Country_Code
		INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
		INNER JOIN Platform P (NOLOCK) ON P.Platform_Code = ADRH.Holdback_On_Platform_Code
		where ADRH.Acq_Deal_Rights_Holdback_Code = @AcqDealRightHoldbackCode AND ADRH.Holdback_Type = 'R' 
		and ((TR.Release_Type = 'C'  AND ADRHT.Country_Code in (TRR.Country_Code)) OR 
		((Tr.Release_Type = 'T' OR Tr.Release_Type = 'W') AND ADRHT.Country_Code in (SELECT td.Country_Code FROM Territory_Details td (NOLOCK) where td.Territory_Code in (trr.Territory_Code))
		))
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Deal_Rights_Holdback_Release]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
