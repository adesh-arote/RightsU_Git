CREATE PROC [USP_Get_Deal_DealWorkFlowStatus]
(
	@Acq_Deal_Code Int, 
	@Deal_Workflow_Status varchar(50), 
	@User_Code INT,
	@Deal_Type varchar(1)
)
AS
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 27-October-2014
-- Description:	Return related dependencies added or not for a deal
-- =============================================
BEGIN
	IF(@Deal_Type='A')
	Begin
	SELECT dbo.UFN_Get_Deal_DealWorkFlowStaus(@Acq_Deal_Code, @Deal_Workflow_Status, @User_Code) AS Workflow_Status
	--SELECT dbo.UFN_Get_Deal_DealWorkFlowStaus(@Acq_Deal_Code, @Deal_Workflow_Status, @User_Code) AS Workflow_Status
	END
	ELSE IF(@Deal_Type='S')
	Begin
	SELECT dbo.UFN_Get_Syn_Deal_Workflow_Status(@Acq_Deal_Code, @Deal_Workflow_Status, @User_Code) AS Workflow_Status
	END
	ELSE IF(@Deal_Type='M')
	Begin
	SELECT dbo.UFN_Get_Music_Deal_Workflow_Status(@Acq_Deal_Code, @Deal_Workflow_Status, @User_Code) AS Workflow_Status
	END
END


