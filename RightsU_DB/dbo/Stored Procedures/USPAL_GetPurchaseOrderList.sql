CREATE PROCEDURE USPAL_GetPurchaseOrderList
@UsersCode INT 
AS
BEGIN
/*---------------------------
Author          : Sachin S. Shelar
Created On      : 25/Apr/2023
Description     : Returns the List for PurchaseOrder
Last Modified On: 09/Aug/2023
Last Change     : Added parameter, and output columns for workflow approval
---------------------------*/


	SET FMTONLY OFF 
	SET NOCOUNT ON 
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetPurchaseOrderList]', 'Step 1', 0, 'Started Procedure', 0, ''

	select v.Vendor_Code, v.Vendor_Name, ap.Proposal_No + ' - CY ' + cast((ar.Refresh_Cycle_No) as varchar ) as Proposal_CY, bs.Booking_Sheet_No, po.Inserted_On,
	u.First_Name +' '+ u.Last_Name AS CreatedBy, po.Inserted_By, po.Status, po.AL_Purchase_Order_Code, po.AL_Booking_Sheet_Code, po.AL_Proposal_Code, po.Remarks, po.Workflow_Status,
		dbo.UFNAL_PO_Set_Button_Visibility(po.AL_Purchase_Order_Code, 1, @UsersCode, po.Workflow_Status) AS ShowHideButtons,
		dbo.[UFN_Get_PO_WorkFlowStatus](po.AL_Purchase_Order_Code, po.Workflow_Status, CAST(@UsersCode AS VARCHAR(50))) AS Final_PO_Workflow_Status
	from AL_Purchase_Order po
	INNER JOIN AL_Booking_Sheet bs on po.AL_Booking_Sheet_Code = bs.AL_Booking_Sheet_Code
	INNER JOIN AL_Recommendation ar on ar.AL_Recommendation_Code = bs.AL_Recommendation_Code
	INNER JOIN AL_Proposal ap on ap.AL_Proposal_Code = ar.AL_Proposal_Code
	INNER JOIN Vendor v on v.Vendor_Code = bs.Vendor_Code
	INNER JOIN Users u ON u.Users_Code = po.Inserted_By

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAL_GetPurchaseOrderList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END