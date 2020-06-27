

ALTER FUNCTION [dbo].[UFN_Deal_Set_Button_Visibility]
(
	--DECLARE
 	 @Acq_Deal_Code INT=2729 
	,@Version FLOAT=0003
	,@User_Code INT=143
	,@WorkFlowStatus VARCHAR(50)='A'
) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- DECLARE
	-- @Acq_Deal_Code INT=15523--14971--15344 
	--,@Version FLOAT=0001
	--,@User_Code INT=203
	--,@WorkFlowStatus VARCHAR(50)='WA'

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

	Declare @UserSecCode  INT = 0, @dealTypeCode INT = 0, @dealTypeCode_Music INT = 0, @Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @dealTypeCode = Deal_Type_Code FROM Acq_Deal With(NoLock) WHERE Acq_Deal_Code = @Acq_Deal_Code
	IF EXISTS (SELECT * FROM System_Parameter_New With(NoLock) WHERE Parameter_Name = 'Deal_Type_Music')
		SELECT TOP 1 @dealTypeCode_Music = CAST(Parameter_Value AS INT) FROM System_Parameter_New With(NoLock) WHERE Parameter_Name = 'Deal_Type_Music'

	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@dealTypeCode)

	SELECT @UserSecCode = Security_Group_Code FROM Users With(NoLock) WHERE Users_Code = @User_Code  

	DECLARE @Module_Rights Table
	(
		Right_Code INT,
		Right_Name  NVARCHAR(100),
		Visible varchar(1)
	)

	INSERT INTO @Module_Rights (Right_Code, Right_Name,Visible)
	SELECT DISTINCT sr.Right_Code, sr.Right_Name ,CASE WHEN ISNULL(sgr.Security_Group_Code,0)=0 THEN  'N' ELSE 'Y' END
	FROM System_Module_Right smr With(NoLock) 
	INNER JOIN System_Right sr With(NoLock) ON sr.Right_Code = smr.Right_Code
	LEFT JOIN Security_Group_Rel sgr With(NoLock) ON smr.Module_Right_Code = sgr.System_Module_Rights_Code AND sgr.Security_Group_Code=@UserSecCode
	WHERE SR.Right_Code IN (1, 2, 6, 7, 8, 10, 11, 12, 18, 19, 71, 79, 88, 89, 116, 127, 130, 134, 135, 138, 164,166) AND smr.Module_Code=30  
	ORDER BY SR.Right_Code

	DECLARE @Edit int =2, @Delete int = 6 , @View int = 7, @Clone int = 10, @SEND_FOR_APPROVAL int =8, @APPROVE int = 11, 
			@Reject int = 12, @Amendment int = 18, @Amort int = 19, @Content int = 71, @AMENDMENT_SYN int = 79, @CLOSE_DEAL int = 88, @RE_OPEN_DEAL int = 89, 
			@Rollback int =116 ,@Terminate int =127, @AssignMusic_List INT = 130 , @MileStone varchar(1) = 'Y',@Edit_Without_Approval int=134,
			@RollbackWithoutApproval INT = 135, @ReleaseContent INT = 138, @ShowError CHAR(1) = 'N',
			@SEND_FOR_ARCHIVE INT = 166, @ARCHIVE INT = 164

	Select @Is_Terminated = CASE WHEN ISNULL(UPPER([Status]), '') = 'T' THEN 'Y' ELSE 'N' END  FROM Acq_Deal With(NoLock) WHERE Acq_Deal_Code = @Acq_Deal_Code

	IF(@Deal_Type_Condition NOT IN ('DEAL_MOVIE', 'DEAL_PROGRAM'))
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@ReleaseContent)
	IF EXISTS(
		SELECT TCM.Title_Content_Mapping_Code FROM Acq_Deal_Movie ADM With(NoLock) 
		INNER JOIN Title_Content_Mapping TCM With(NoLock) ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
		WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code
	)
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Delete)
	END
	
	IF(@WorkFlowStatus <> 'A')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Amort)
	END

	IF(@Is_Terminated = 'Y')
	BEGIN
	
		-- Terminated Deal, Show Only View Button
		IF(@WorkFlowStatus = 'R')
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View, @Rollback, @SEND_FOR_APPROVAL, @APPROVE, 1)
		END
		ELSE
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View, 1, @AssignMusic_List,@APPROVE)
		END
	END
	--select @WorkFlowStatus
	--select * from @Module_Rights where Right_Name='APPROVE'
	/*ZeroWorkFlow*/
	Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](30,@Acq_Deal_Code) ,@IsCompleted = [dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code)
	Select @ParentDealCode = COUNT(AT_Acq_Deal_Code) from AT_Acq_Deal With(NoLock) where Acq_Deal_Code = @Acq_Deal_Code
	select @DealtagDescription = Deal_Tag_Description from Deal_Tag With(NoLock) where Deal_Tag_Code = @Acq_Deal_Code 
	Select @TotalMilestoneCount = dbo.[UFN_Get_MIlestone_Count](@Acq_Deal_Code) 
	SELECT @CountMovieClosed = COUNT(*) from Acq_Deal_Movie With(NoLock) where Acq_Deal_Code in (@Acq_Deal_Code)  and ISNULL(is_closed,'N')='Y' 
	SELECT @IsMasterDeal=Is_Master_Deal from Acq_Deal With(NoLock) where Acq_Deal_Code=@Acq_Deal_Code
	IF(@IsZeroWorkFlow = 'Y')
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code in( @SEND_FOR_APPROVAL, @SEND_FOR_ARCHIVE)
	ELSE IF(@IsZeroWorkFlow != 'N')
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL,@APPROVE, @SEND_FOR_ARCHIVE, @ARCHIVE)

	--If Approved , Waiting for Authorization , Rejected
	IF(@WorkFlowStatus = 'A' OR @WorkFlowStatus = 'W' OR @WorkFlowStatus = 'R' OR @WorkFlowStatus='EO')
		SET @IsCompleted ='Y'

	--Not Completed
	IF(@IsCompleted!='Y')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @Clone,@SEND_FOR_ARCHIVE, @ARCHIVE, @Amendment, @Content, @AMENDMENT_SYN, @APPROVE, @CLOSE_DEAL, @Terminate, @AssignMusic_List)
		SET @MileStone ='N'
	END
	--select * from @Module_Rights
	--select @WorkFlowStatus
	IF(@WorkFlowStatus = 'A' AND EXISTS(select * from @Module_Rights WHERE Right_Code IN (@Edit_Without_Approval) AND Visible='Y'))
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@Edit_Without_Approval)
	ELSE IF(@WorkFlowStatus != 'EO' )
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Edit_Without_Approval)
	IF(@WorkFlowStatus = 'EO')
	BEGIN
		IF(EXISTS(select * from @Module_Rights WHERE Right_Code IN (@RollbackWithoutApproval) AND Visible='Y'))
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@RollbackWithoutApproval)
		IF(EXISTS(select * from @Module_Rights WHERE Right_Code IN (@Edit_Without_Approval) AND Visible='Y'))
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@Edit_Without_Approval)
	END
	ELSE 
	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@RollbackWithoutApproval)
	
	DECLARE @Parameter_Value VARCHAR(MAX)
	SELECT @Parameter_Value=Parameter_Value FROM System_Parameter_New With(NoLock) where Parameter_Name='Edit_WO_Approval_Tabs'
	if(@Parameter_Value='RU')
	BEGIN
		DECLARE @Result varchar(2)
		set @Result = 'N'
		IF(
			(
				select  Count(AD.Acq_Deal_Code) from Acq_Deal AD With(NoLock) 
				inner join Acq_Deal_Rights ADR With(NoLock) on AD.Acq_Deal_Code = ADR.Acq_Deal_Code
				inner join Acq_Deal_Rights_Platform ADRP With(NoLock) on ADRP.Acq_Deal_Rights_Code= ADR.Acq_Deal_Rights_Code
				inner join Platform P With(NoLock) on P.Platform_Code = ADRP.Platform_Code AND p.Is_No_Of_Run = 'Y'
				where AD.Acq_Deal_Code = @Acq_Deal_Code
			) > 0
		  )
		  BEGIN
			set @Result = 'Y'
		  END
		  IF(@Result = 'N')
		  UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Edit_Without_Approval)
	END
	
	--New Version
	IF(@Version < 1)
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @Rollback 
	END
	--ELSE
	--	SEND THE VERSION NO> BUTTON NAME

	--Waiting for Authorization
	IF(@WorkFlowStatus = 'W')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SEND_FOR_APPROVAL, @SEND_FOR_ARCHIVE, @ARCHIVE, @Amendment, @Content,  @AMENDMENT_SYN, 
				 @Rollback, @Terminate, @AssignMusic_List, @ReleaseContent)

		SET @MileStone ='N'
	END

	--Not Approved
	IF(@WorkFlowStatus != 'A' AND @WorkFlowStatus !='EO')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Amendment ,@Content,  @AMENDMENT_SYN , @Clone , @CLOSE_DEAL, @Terminate, @AssignMusic_List)
		SET @MileStone = 'N'
	END
	
	IF EXISTS (SELECT * FROM System_Parameter_New With(NoLock) WHERE Parameter_Name = 'AssignMusic_DealType')
	BEGIN
		DECLARE @Codes VARCHAR(MAX) = ''
		SELECT TOP 1 @Codes = Parameter_Value FROM System_Parameter_New With(NoLock) WHERE Parameter_Name = 'AssignMusic_DealType'

		IF NOT EXISTS (SELECT * FROM DBO.fn_Split_withdelemiter(@Codes, ',') WHERE number = @dealTypeCode AND number <> @dealTypeCode_Music)
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@AssignMusic_List)
		END
	END
	ELSE
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@AssignMusic_List)


		--Approved
	IF(@WorkFlowStatus = 'A' OR @WorkFlowStatus ='EO')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SEND_FOR_APPROVAL, @AMENDMENT_SYN, @APPROVE, @Rollback, @ReleaseContent)
		Select @IsShowAmmendment = COUNT(Deal_Code) from Syn_Acq_Mapping With(NoLock) where Deal_Code = @Acq_Deal_Code

		IF(@IsShowAmmendment > 0)
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_ARCHIVE, @ARCHIVE, @Amendment)

			IF NOT EXISTS (SELECT * FROM Acq_Deal_Rights ADR With(NoLock) WHERE Acq_Deal_Code = @Acq_Deal_Code 
				AND ADR.Acq_Deal_Rights_Code NOT IN (SELECT DISTINCT Deal_Rights_Code FROM Syn_Acq_Mapping With(NoLock) where Deal_Code = @Acq_Deal_Code))
			BEGIN
				SET @MileStone = 'N'
			END


			IF(@CountMovieClosed <= 0  AND @Is_Terminated = 'N')
			BEGIN
				UPDATE B 
					SET B.Visible = A.SHOW
				FROM 
				@Module_Rights B
				INNER JOIn 
				(Select SR.Right_Code,CASE WHEN ISNULL(sgr.Security_Group_Code,0)=0 THEN  'N' ELSE 'Y' END SHOW
				FROM System_Module_Right smr With(NoLock) 
				INNER JOIN System_Right sr With(NoLock) on sr.Right_Code = smr.Right_Code
				LEFT JOIN Security_Group_Rel sgr With(NoLock) on smr.Module_Right_Code = sgr.System_Module_Rights_Code and sgr.Security_Group_Code=@UserSecCode
				WHERE SR.Right_Code IN (@AMENDMENT_SYN) AND smr.Module_Code=30 )
				AS A ON A.Right_Code=b.Right_Code
			END
		END
	END
	
	IF(@WorkFlowStatus = 'R')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_ARCHIVE, @ARCHIVE, @Amendment, @Delete, @AMENDMENT_SYN, @Terminate, @AssignMusic_List)
		SET @MileStone = 'N'

		Declare @hdnAllow_Edit_All_On_Rejection VARCHAR(1), @RetValue Int = 0
		SELECT @hdnAllow_Edit_All_On_Rejection = Parameter_value FROM System_Parameter_New With(NoLock) 
		WHERE Parameter_Name = 'Allow_Edit_All_On_Rejection' AND IsActive = 'Y'

		Select Top 1 @RetValue = Group_Code From Module_Workflow_Detail With(NoLock) 
		Where Record_Code = @Acq_Deal_Code And Module_Code = 30 And Role_Level = 0 Order By Module_Workflow_Detail_Code Desc
		

		IF (@UserSecCode = @RetValue OR @hdnAllow_Edit_All_On_Rejection = 'Y') 
		BEGIN
			IF(@IsZeroWorkFlow = 'N')
			BEGIN
			UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code = @SEND_FOR_APPROVAL
			END
		END
		ELSE
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Edit, @SEND_FOR_APPROVAL,@APPROVE)
		END
		IF(@Is_Terminated = 'Y')
		BEGIN
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@Rollback)
		END
	END
	--ELSE
	--UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Rollback)

	--For Approve
	Declare @GCode INT=0,@UGCode INT=0,@DBUCode INT=0
	select @DBUCode=Business_Unit_Code from Acq_Deal With(NoLock) where Acq_Deal_Code=@Acq_Deal_Code
	select  @UGCode=Security_Group_Code from Users u With(NoLock) 
	INNER JOIN Users_Business_Unit bu With(NoLock) ON bu.Users_Code=u.Users_Code
	 where u.Users_Code=@User_Code and @DBUCode=bu.Business_Unit_Code
	select @GCode=ISNULL(dbo.UFN_Get_Current_Approver_Code(30,@Acq_Deal_Code),0)

	IF( @UGCode != @GCode)
	BEGIN
		IF (select Deal_Workflow_Status from Acq_Deal where Acq_Deal_Code = @Acq_Deal_Code) = 'WA'
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code in( @Approve)
		ELSE
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code in( @Approve, @ARCHIVE)
	END
	ELSE
	BEGIN
			DECLARE @MSC INT = 0 , @ST VARCHAR(MAX)= ''
			SELECT TOP 1  @MSC = A.Module_Status_Code, @ST = A.Status FROM (SELECT TOP 2 * from Module_Status_History WHERE Record_Code = @Acq_Deal_Code ORDER BY Status_Changed_On DESC ) AS A ORDER BY 1 

			IF @ST = 'WA'
				UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code in( @Approve, @ARCHIVE)

	END

	--select Top 1 Is_Done from Module_Workflow_detail where Record_Code=@Acq_Deal_Code order By Module_Workflow_detail_Code desc
	--else
	--UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @Approve
	--For Pending Rights
	DECLARE @IsCompleted_R VARCHAR(50)
			SELECT @IsCompleted_R =[dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code)
	IF(@WorkFlowStatus = 'R' AND @IsCompleted_R <>'Y')
	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @SEND_FOR_APPROVAL

	IF(@WorkFlowStatus = 'RS')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SEND_FOR_APPROVAL, @AMENDMENT_SYN, @Close_Deal, @Clone, @SEND_FOR_ARCHIVE, @ARCHIVE, @Amendment, @Terminate, @AssignMusic_List)
		SET @MileStone = 'N'
	END

	DECLARE @cntE INT
	SELECT @cntE = COUNT(Acq_Deal_Code) from Acq_Deal_Rights With(NoLock) where Acq_Deal_Code = @Acq_Deal_Code and ISNULL(Right_Status,'C') in ('E')
	
	IF (@cntE > 0)
	BEGIN
		SET @ShowError = 'Y'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @APPROVE)
	END
	ELSE
	BEGIN
		DECLARE @cntP INT
		SELECT @cntP = COUNT(Acq_Deal_Code) from Acq_Deal_Rights With(NoLock) where Acq_Deal_Code = @Acq_Deal_Code and ISNULL(Right_Status,'C') in ('P')
		
		IF (@cntP > 0)
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @APPROVE)
	END

	-- Re-Open
	IF(@WorkFlowStatus = 'RO')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@EDIT,@View)
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Delete,@Clone,@SEND_FOR_APPROVAL,@APPROVE,@Reject,@SEND_FOR_ARCHIVE, @ARCHIVE, @Amendment,@CLOSE_DEAL,@RE_OPEN_DEAL,@Rollback,@Terminate)
	END
	IF(@WorkFlowStatus = 'EO')
	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@Edit_Without_Approval,@RollbackWithoutApproval,@View)
	IF(@ParentDealCode > 0)
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code = @Delete

	-- Waiting for archive
	IF(@WorkFlowStatus = 'WA')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View, @ARCHIVE) 
	END
	ELSE IF(@WorkFlowStatus = 'AR')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View) 
	END
	ELSE IF(@WorkFlowStatus <> 'A')
	BEGIN 
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN ( @SEND_FOR_ARCHIVE, @ARCHIVE)
	END
	
	IF(@DealtagDescription = 'Close')
	BEGIn
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL,@SEND_FOR_ARCHIVE, @ARCHIVE, @Amendment, @AMENDMENT_SYN, @Terminate, @AssignMusic_List)
		SET @MileStone = 'N'
	END

	IF(@IsMasterDeal='N')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Content, @ARCHIVE, @SEND_FOR_ARCHIVE)
	END

	IF(@TotalMilestoneCount = 0)
	BEGIn
		SET @MileStone = 'N'
	END	

  	SELECT  @Is_Right_Available = (SELECT STUFF((SELECT ','+ Cast(Right_Code as Varchar(MAX)) FROM @Module_Rights WHERE Visible='Y' FOR XML PATH('')), 1, 1, '' ) )
    	
	if(@MileStone='Y' AND @Is_Terminated = 'N')
		RETURN  @Is_Right_Available + ',' + @MileStone +','

	IF (@ShowError = 'Y' AND @Is_Terminated = 'N')
		RETURN  @Is_Right_Available + ',' +'E,'

	RETURN   ','+@Is_Right_Available +','
	--select ','+@Is_Right_Available +','+ @MileStone +','
END