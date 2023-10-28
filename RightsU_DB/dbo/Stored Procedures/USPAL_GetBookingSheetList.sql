CREATE PROCEDURE USPAL_GetBookingSheetList
AS
BEGIN
/*---------------------------
Author          : Sachin S. Shelar
Created On      : 30/Mar/2023
Description     : Returns the List for BookingSheet
Last Modified On: 26/Apr/2023
Last Change     : Change in Column name Proposal_CY
---------------------------*/


	SET FMTONLY OFF 
	SET NOCOUNT ON
	
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetBookingSheetList]', 'Step 1', 0, 'Started Procedure', 0, ''

	SELECT bs.AL_Booking_Sheet_Code, ar.AL_Recommendation_Code, v.Vendor_Code, ap.AL_Proposal_Code, v.Vendor_Name, ap.Proposal_No, bs.Booking_Sheet_No, bs.Record_Status, bs.Excel_File,
		bs.Movie_Content_Count, bs.Show_Content_Count, bs.Last_Action_By, bs.Last_Updated_Time, ap.Proposal_No + ' - CY ' + cast((ar.Refresh_Cycle_No) as varchar ) as Proposal_CY,
		(format(ar.Start_Date, 'MMy') + ' - ' + format(ar.End_Date, 'MMy')) as Cycle
	FROM AL_Booking_Sheet bs
	INNER JOIN AL_Recommendation ar ON ar.AL_Recommendation_Code = bs.AL_Recommendation_Code
	INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = ar.AL_Proposal_Code
	INNER JOIN Vendor v ON v.Vendor_Code = ap.Vendor_Code
		
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetBookingSheetList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END