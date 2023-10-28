CREATE FUNCTION [dbo].[UFNAL_Recom_Set_Button_Visibility]
(
	 @AL_Recommendation_Code INT
	,@Version FLOAT
	,@User_Code INT
	,@WorkFlowStatus VARCHAR(50)
	,@IsProposalList CHAR(1)

) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- DECLARE
	-- @AL_Recommendation_Code INT=1327
	--,@Version FLOAT=0001
	--,@User_Code INT=221
	--,@WorkFlowStatus VARCHAR(50)='A'

	

	DECLARE @Is_Right_Available VARCHAR(MAX) , @IsZeroWorkFlow VARCHAR(2), @IsShowAmmendment INT, @ParentDealCode INT ,
			@DealtagDescription NVARCHAR(50), @TotalMilestoneCount INT, @CountMovieClosed INT, @IsCompleted VARCHAR(2),
			@Is_Terminated VARCHAR(2),@IsMasterDeal VARCHAR(2)
	--,@WorkFlowStatus VARCHAR(50)='A'
	/*
	2. Edit
	6. Delete
	7. View
	10. Clone
	8. SEND FOR APPROVAL
	11. APPROVE
	12. Reject
	18. Amendment
	71.Content
	79. AMENDMENT AFTER SYNDICATION
	88. CLOSE DEAL
	89. RE-OPEN DEAL
	116. Rollback
	127. Terminate
	130. Assign Music (List) -- It will come for Configured Deal_Type (in System_Parameter_New table)
	138. Release Content
	164 Deal Archive
	166 Send for deal archive
	*/

	Declare @UserSecCode  INT = 0, @dealTypeCode INT = 0, @dealTypeCode_Music INT = 0
	--SELECT TOP 1 @dealTypeCode = Deal_Type_Code FROM Acq_Deal With(NoLock) WHERE Acq_Deal_Code = @Acq_Deal_Code
	IF EXISTS (SELECT * FROM System_Parameter_New With(NoLock) WHERE Parameter_Name = 'Deal_Type_Music')
		SELECT TOP 1 @dealTypeCode_Music = CAST(Parameter_Value AS INT) FROM System_Parameter_New With(NoLock) WHERE Parameter_Name = 'Deal_Type_Music'

	SELECT @UserSecCode = Security_Group_Code FROM Users With(NoLock) WHERE Users_Code = @User_Code  

	DECLARE @Module_Rights Table
	(
		Right_Code INT,
		Right_Name  NVARCHAR(100),
		Visible varchar(1)
	)

	INSERT INTO @Module_Rights (Right_Code, Right_Name,Visible)
	SELECT DISTINCT sr.Right_Code, sr.Right_Name, CASE WHEN ISNULL(sgr.Security_Group_Code,0)=0 THEN  'N' ELSE 'Y' END
	FROM System_Module_Right smr With(NoLock) 
	INNER JOIN System_Right sr With(NoLock) ON sr.Right_Code = smr.Right_Code
	LEFT JOIN Security_Group_Rel sgr With(NoLock) ON smr.Module_Right_Code = sgr.System_Module_Rights_Code AND sgr.Security_Group_Code = @UserSecCode
	WHERE SR.Right_Code IN (1, 2, 6, 7, 8, 10, 11, 12, 18, 19, 71, 79, 88, 89, 116, 127, 130, 134, 135, 138, 164,166,185,187,188,189,121) AND smr.Module_Code=262  
	ORDER BY SR.Right_Code


	DECLARE @Edit int =2, @View int = 7, @Delete int = 6, @SEND_FOR_APPROVAL int =8, @APPROVE int = 11,@Reject int = 12,  @Clone int = 10
	 ,@ExportToExcel INT = 121 ,@ExportToPDF INT = 185,@ViewRecommendation INT =187, @FinallyClose INT = 188,@CreateNewRecommendation INT = 189
			
	Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](262,@AL_Recommendation_Code) --,@IsCompleted = [dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code)
	

	IF(@IsZeroWorkFlow = 'Y')
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code in( @SEND_FOR_APPROVAL)
	ELSE IF(@IsZeroWorkFlow != 'N')
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL,@APPROVE)

	Declare @GCode INT=0,@UGCode INT=0,@DBUCode INT=0
	SET @DBUCode= 1 --Business_Unit_Code from Acq_Deal With(NoLock) where Acq_Deal_Code=@Acq_Deal_Code
	select  @UGCode=Security_Group_Code from Users u With(NoLock) 
	INNER JOIN Users_Business_Unit bu With(NoLock) ON bu.Users_Code=u.Users_Code
	 where u.Users_Code=@User_Code and @DBUCode=bu.Business_Unit_Code
	select @GCode=ISNULL(dbo.UFN_Get_Current_Approver_Code(262,@AL_Recommendation_Code),0)

	IF( @UGCode != @GCode)
	BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code in( @Approve, @Reject)
	END

	IF(@WorkFlowStatus = 'D')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@APPROVE,@Reject, @Clone, @ExportToExcel, @ExportToPDF, @ViewRecommendation, @FinallyClose, @CreateNewRecommendation)
	END

	IF(@WorkFlowStatus = 'W')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Edit, @Delete, @SEND_FOR_APPROVAL, @Clone, @ExportToExcel, @ExportToPDF, @ViewRecommendation, @FinallyClose, @CreateNewRecommendation)
	END

	IF(@WorkFlowStatus = 'A')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Clone,@Delete, @SEND_FOR_APPROVAL, @APPROVE, @Reject, @CreateNewRecommendation)
	END

	IF(@WorkFlowStatus = 'F')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Edit, @FinallyClose, @Clone, @Delete, @SEND_FOR_APPROVAL, @APPROVE, @Reject)
	END

	IF(@WorkFlowStatus = 'R')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Delete, @APPROVE, @Reject, @Clone, @ExportToExcel, @ExportToPDF, @ViewRecommendation, @FinallyClose, @CreateNewRecommendation)
	END

	DECLARE @IsFinalChecked CHAR(1) = 'N', @Excel_File VARCHAR(MAX), @Pdf_File VARCHAR(MAX)

	Select @Excel_File= Excel_File, @Pdf_File = PDF_File from AL_Recommendation WHERE AL_Recommendation_Code = @AL_Recommendation_Code
	
	IF(ISNULL(@Excel_File,'') = '') 
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@ExportToExcel)
	END

	IF(ISNULL(@Pdf_File,'') = '') 
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@ExportToPDF)
	END

	--{Need to get finaly column value}
	SET @IsFinalChecked = (Select Finally_Closed from AL_Recommendation WHERE AL_Recommendation_Code = @AL_Recommendation_Code)

	
	IF(@WorkFlowStatus = 'A' AND @IsFinalChecked = 'Y' )
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Edit, @Delete, @SEND_FOR_APPROVAL, @APPROVE, @Reject, @FinallyClose, @CreateNewRecommendation)
	END

	DECLARE @NextCycleCount INT = -1, @IsLastCycleClosed CHAR(1)

	SET @IsLastCycleClosed  = (SELECT Finally_Closed FROM (
								SELECT ROW_NUMBER() OVER (ORDER BY AL_Recommendation_Code DESC) RowNum , AL_Recommendation_Code, Finally_Closed FROM AL_Recommendation 
								WHERE AL_Proposal_Code IN (SELECT AL_Proposal_Code FROM AL_Recommendation WHERE AL_Recommendation_Code = @AL_Recommendation_Code) 
								) AS A WHERE A.RowNum = 2
							)

	DECLARE @CurrentCycleCount INT, @LastCycleCount int, @CurrentCycleEndDate DATETIME, @ProposalEndDate DATETIME,@VersionNo INT
		
		SELECT @CurrentCycleCount = Refresh_Cycle_No , @CurrentCycleEndDate = End_Date, @VersionNo = Version_No  from AL_Recommendation WHERE AL_Recommendation_Code = @AL_Recommendation_Code

		SELECT @ProposalEndDate = (SELECT End_Date FROM AL_Proposal
								WHERE AL_Proposal_Code IN (SELECT AL_Proposal_Code FROM AL_Recommendation WHERE AL_Recommendation_Code = @AL_Recommendation_Code))

		SET @LastCycleCount = ( SELECT top 1 Refresh_Cycle_No FROM AL_Recommendation 
								WHERE AL_Proposal_Code IN (SELECT AL_Proposal_Code FROM AL_Recommendation WHERE AL_Recommendation_Code = @AL_Recommendation_Code) 
								order by 1 desc)


		IF(@CurrentCycleCount < @LastCycleCount)
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@CreateNewRecommendation)
		END

		IF(@CurrentCycleEndDate = @ProposalEndDate)
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@CreateNewRecommendation)
		END
		--order by AL_Recommendation_Code DESC
	

		IF(@WorkFlowStatus = 'A' AND @IsLastCycleClosed = 'Y' AND @IsFinalChecked = 'Y')--AND @NextCycleCount = 0 )
		BEGIN
			UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@CreateNewRecommendation)
		END

		IF(@CurrentCycleCount =1 AND @IsProposalList = 'N')
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View)
		END

		IF(@VersionNo > 1 )
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Delete)
		END

		SELECT  @Is_Right_Available = (SELECT STUFF((SELECT ','+ Cast(Right_Code as Varchar(MAX)) FROM @Module_Rights WHERE Visible='Y' FOR XML PATH('')), 1, 1, '' ) )

		--Select * from @Module_Rights where Visible='Y'
		RETURN @Is_Right_Available --+',' 
	
	
END