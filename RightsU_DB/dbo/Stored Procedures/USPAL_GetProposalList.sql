
CREATE PROCEDURE [dbo].[USPAL_GetProposalList]
@ListFor VARCHAR(10),
@UsersCode INT,
@AL_Recommendation_Code INT = 0 
AS
BEGIN
--DECLARE @ListFor VARCHAR(10) = 'RE',
--@UsersCode INT =143

	DECLARE
	@AL_Proposal_Code INT
	
	SET @AL_Proposal_Code = (Select top 1 AL_Proposal_Code from AL_Recommendation WHERE AL_Recommendation_Code = @AL_Recommendation_Code)
	
	IF(@ListFor = 'PR' AND @AL_Recommendation_Code <> 0)
	BEGIN
		SET @ListFor = 'RE'
	END

	IF(@ListFor = 'PR')
	BEGIN
		SELECT DISTINCT al.AL_Proposal_Code,AL_Recommendation_Code, al.Refresh_Cycle AS CycleNo, AL.Proposal_No AS ProposalId, V.Vendor_Name AS Clients, 
				--CASE WHEN al.Workflow_Status = 'D' THEN 'Draft'
				--WHEN al.Workflow_status = 'A' THEN 'Approved' 
				--WHEN al.Workflow_status = 'W' THEN 'Waiting for Approval' 
				--WHEN al.Workflow_status = 'A' THEN 'Approved' END AS Status,
				dws.Deal_Workflow_Status_Name AS Status,
				 Format(al.Start_Date,'dd-MMM-yyyy') +' To '  +  Format(al.End_Date,'dd-MMM-yyyy') AS Period,
		Format(al.Inserted_On,'dd-MMM-yyyy hh:mm tt') AS CreatedOn, ISNULL(alrc.Excel_File,'') AS Excel_File, ISNULL(alrc.PDF_File,'') AS PDF_File,
		dbo.UFNAL_Recom_Set_Button_Visibility(alrc.AL_Recommendation_Code,alrc.Version_No,@UsersCode,alrc.Workflow_Status,'Y') AS ShowHideButtons,
		alrc.Last_Updated_Time
		FROM AL_Proposal al
		INNER JOIN AL_Recommendation alrc ON alrc.AL_Proposal_Code = al.AL_Proposal_Code
		INNER JOIN Vendor V ON v.Vendor_Code = al.Vendor_Code
		INNER JOIN Deal_Workflow_Status dws ON dws.Deal_WorkflowFlag = alrc.Workflow_Status AND dws.Deal_Type = 'R'
		WHERE alrc.Refresh_Cycle_No = 1 AND (al.AL_Proposal_Code = @AL_Proposal_Code OR 0 = @AL_Recommendation_Code )
		Order by alrc.Last_Updated_Time desc--al.AL_Proposal_Code DESC
	END
	ELSE
	BEGIN
		SELECT DISTINCT al.AL_Proposal_Code, AL_Recommendation_Code, alrc.Refresh_Cycle_No AS CycleNo ,AL.Proposal_No AS ProposalId, V.Vendor_Name AS Clients, 
				--CASE WHEN alrc.Workflow_Status = 'D' THEN 'Draft'
				--WHEN alrc.Workflow_status = 'A' THEN 'Approved' 
				--WHEN alrc.Workflow_status = 'W' THEN 'Waiting for Approval' 
				--WHEN alrc.Workflow_status = 'A' THEN 'Approved' END AS Status,
				dws.Deal_Workflow_Status_Name AS Status,
				--CAST(alrc.Start_Date AS NVARCHAR(MAX)) +' To '  + CAST(alrc.End_Date AS NVARCHAR) AS Period,
				 Format(alrc.Start_Date,'dd-MMM-yyyy') +' To '  + Format(alrc.End_Date,'dd-MMM-yyyy') AS Period,
		Format(alrc.Inserted_On,'dd-MMM-yyyy hh:mm tt') AS CreatedOn, ISNULL(alrc.Excel_File,'') AS Excel_File, ISNULL(alrc.PDF_File,'') AS PDF_File,
		dbo.UFNAL_Recom_Set_Button_Visibility(alrc.AL_Recommendation_Code, alrc.Version_No, @UsersCode,alrc.Workflow_Status,'N') AS ShowHideButtons,
		alrc.Last_Updated_Time 
		FROM AL_Proposal al
		INNER JOIN AL_Recommendation alrc ON alrc.AL_Proposal_Code = al.AL_Proposal_Code
		INNER JOIN Deal_Workflow_Status dws ON dws.Deal_WorkflowFlag = alrc.Workflow_Status AND dws.Deal_Type = 'R'
		INNER JOIN Vendor V ON v.Vendor_Code = al.Vendor_Code
		WHERE (al.AL_Proposal_Code = @AL_Proposal_Code OR 0 = @AL_Recommendation_Code )
		Order by alrc.Last_Updated_Time desc--al.AL_Proposal_Code DESC

	END
	

END