
ALTER FUNCTION [dbo].[UFN_Syn_Deal_Set_Button_Visibility]
(
	@Syn_Deal_Code INT,
	@Version FLOAT = 001,
	@User_Code INT,
	@WorkFlowStatus VARCHAR(50) = 'Y'
) 
RETURNS VARCHAR(MAX)
AS
--|========================================================================
--| Author:		  RUSHABH V. GOHIL
--| Date Created: 19-Aug-2015
--| Description:  Defines Button Visibility based on Rights for Syn Deals
--|========================================================================
BEGIN
	--SELECT * FROM Users WHERE Login_Name = 'admin'
	--select * from Syn_Deal where Agreement_No = 'S-2018-00147'
	--declare
	--@Syn_Deal_Code INT = 1422,
	--@Version FLOAT = 0001,
	--@User_Code INT = 203,
	--@WorkFlowStatus VARCHAR(50) = 'WA'

	--select @Syn_Deal_Code = Syn_Deal_Code, @WorkFlowStatus = Deal_Workflow_Status, @Version = [Version] 
	--from Syn_Deal where Agreement_No = 'S-2018-00147'



	DECLARE @Is_Right_Available VARCHAR(MAX), @IsZeroWorkFlow VARCHAR(2), @IsShowAmendment INT, @ParentDealCode INT, 
			@DealtagDescription NVARCHAR(MAX), @TotalMilestoneCount INT, @CountMovieClosed INT, @IsCompleted VARCHAR(2),
			@Is_Terminated VARCHAR(2)
	
	/*		2 - Edit, 6 - Delete, 7 - View, 10 - Clone, 8 - SEND FOR APPROVAL, 11 - APPROVE, 
			12 - Reject, 18 - Amendment, 88 - CLOSE DEAL, 89 - RE-OPEN DEAL, 116 - Rollback	,
			127 - Terminate	
			164 Deal Archive
			166 Send for deal archive
	*/

	DECLARE @UserSecCode INT = 0, @strReturnString VARCHAR(500)
	
	SELECT @UserSecCode = Security_Group_Code 
	FROM Users 
	WHERE Users_Code = @User_Code  

	DECLARE @Module_Rights Table
	(
		Right_Code INT,
		Right_Name NVARCHAR(100),
		Visible VARCHAR(1)
	)

	INSERT INTO @Module_Rights (Right_Code, Right_Name,Visible)
	SELECT DISTINCT sr.Right_Code, sr.Right_Name, CASE WHEN ISNULL(sgr.Security_Group_Code,0) = 0 THEN 'N' ELSE 'Y' END
	FROM System_Module_Right smr WITH(NOLOCK)
	INNER JOIN System_Right sr WITH(NOLOCK) ON sr.Right_Code = smr.Right_Code
	LEFT JOIN Security_Group_Rel sgr WITH(NOLOCK) ON smr.Module_Right_Code = sgr.System_Module_Rights_Code AND sgr.Security_Group_Code=@UserSecCode
	WHERE SR.Right_Code IN (1, 2, 6, 7, 8, 10, 11, 12, 18, 88, 89, 116, 127, 164, 166) AND smr.Module_Code=35  
	ORDER BY SR.Right_Code


	DECLARE @Edit INT =2, @Delete INT = 6 , @View INT = 7, @Clone INT = 10, @SEND_FOR_APPROVAL INT =8, @APPROVE INT = 11, 
			@Reject INT = 12, @Amendment INT = 18, @CLOSE_DEAL INT = 88, @RE_OPEN_DEAL INT = 89,
			@Rollback INT =116 ,@Terminate int =127 , @MileStone VARCHAR(1) = 'Y', @ShowError CHAR(1) = 'N',
			@SEND_FOR_ARCHIVE INT = 166, @ARCHIVE INT = 164

	Select @Is_Terminated = CASE WHEN ISNULL(UPPER([Status]), '') = 'T' THEN 'Y' ELSE 'N' END  FROM Syn_Deal WHERE Syn_Deal_Code = @Syn_Deal_Code

	IF(@Is_Terminated = 'Y')
	BEGIN
		-- Terminated Deal, Show Only View Button
		IF(@WorkFlowStatus = 'R')
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View, @Rollback, @SEND_FOR_APPROVAL, @APPROVE, 1)
		END
		ELSE
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View, 1,@APPROVE)
		END
	END
	/* Zero Workflow */
	SELECT @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](35,@Syn_Deal_Code), @IsCompleted = [dbo].[UFN_Get_Syn_Deal_IsComplete](@Syn_Deal_Code)
	SELECT @ParentDealCode = COUNT(AT_Syn_Deal_Code) FROM AT_Syn_Deal WITH(NOLOCK) WHERE Syn_Deal_Code = @Syn_Deal_Code
	SELECT @DealtagDescription = Deal_Tag_Description FROM Deal_Tag WITH(NOLOCK) WHERE Deal_Tag_Code = @Syn_Deal_Code 
	SELECT @TotalMilestoneCount = dbo.[UFN_Get_MIlestone_Count](@Syn_Deal_Code) 
	SELECT @CountMovieClosed = COUNT(*) FROM Syn_Deal_Movie WITH(NOLOCK) WHERE Syn_Deal_Code IN (@Syn_Deal_Code) AND ISNULL(is_closed,'N') = 'Y' 

	IF(@IsZeroWorkFlow = 'Y')
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code in( @SEND_FOR_APPROVAL, @SEND_FOR_ARCHIVE)
	ELSE IF(@IsZeroWorkFlow != 'N')
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL,@APPROVE, @SEND_FOR_ARCHIVE,@ARCHIVE)

	--IF Approved, Waiting for Authorization , Rejected
	IF(@WorkFlowStatus = 'A' OR @WorkFlowStatus = 'W' OR @WorkFlowStatus = 'R')
		SET @IsCompleted ='Y'
	
	--Not Completed
	IF(@IsCompleted!='Y')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @Clone, @Amendment, @APPROVE, @CLOSE_DEAL, @Terminate)
		SET @MileStone ='N'
	END
	--New Version
	IF(@Version < 1)
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  IN( @Rollback)
	END
	 
	IF(@Version = 1 AND @WorkFlowStatus <> 'R')
	BEGIN
		IF @WorkFlowStatus <> 'A'
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  IN( @SEND_FOR_ARCHIVE)

		IF @WorkFlowStatus = 'N'
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  IN( @ARCHIVE)
	END



	--Waiting for Authorization
	IF(@WorkFlowStatus = 'W')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SEND_FOR_APPROVAL,@SEND_FOR_ARCHIVE,@ARCHIVE, @Amendment, @Rollback, @Terminate)
			
		SET @MileStone ='N'
	END

	--Waiting for ARCHIVE
	IF(@WorkFlowStatus = 'WA')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SEND_FOR_APPROVAL,@RE_OPEN_DEAL,@Reject, @APPROVE ,@SEND_FOR_ARCHIVE, @Amendment, @Rollback, @Terminate)

		SET @MileStone ='N'
	END

	--Not Approved
	IF(@WorkFlowStatus != 'A')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Amendment, @Clone, @CLOSE_DEAL, @Terminate)
		SET @MileStone = 'N'
	END

	--Approved
	IF(@WorkFlowStatus = 'A')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SEND_FOR_APPROVAL, @APPROVE,@ARCHIVE, @Rollback)
	END

	IF(@WorkFlowStatus = 'R')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Amendment, @Delete, @Terminate)
		SET @MileStone = 'N'

		DECLARE @hdnAllow_Edit_All_On_Rejection VARCHAR(1), @RetValue INT = 0
		SELECT @hdnAllow_Edit_All_On_Rejection = Parameter_value FROM System_Parameter_New WITH(NOLOCK)
		WHERE Parameter_Name = 'Allow_Edit_All_On_Rejection' AND IsActive = 'Y'

		SELECT Top 1 @RetValue = Group_Code FROM Module_Workflow_Detail WITH(NOLOCK)
		WHERE Record_Code = @Syn_Deal_Code AND Module_Code = 35 AND Role_Level = 0 Order By Module_Workflow_Detail_Code Desc

		IF (@UserSecCode = @RetValue OR @hdnAllow_Edit_All_On_Rejection = 'Y') 
		BEGIN
			UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code = @SEND_FOR_APPROVAL
		END
		ELSE
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Edit, @SEND_FOR_APPROVAL, @Approve,@Rollback)
		END
		IF(@Is_Terminated = 'Y')
		BEGIN
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@Rollback)
		END
	END
	--ELSE
	--UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Rollback)

	IF(@WorkFlowStatus = 'RS')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SEND_FOR_APPROVAL,  @Close_Deal, @Clone, @Amendment, @Terminate)
		SET @MileStone = 'N'
	END

	IF(@WorkFlowStatus = 'AR')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View)
		SET @MileStone ='N'
	END

	IF(@ParentDealCode > 0)
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code = @Delete

	IF(@DealtagDescription = 'Close')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @Amendment, @Terminate)
		SET @MileStone = 'N'
	END

	IF(@TotalMilestoneCount = 0)
	BEGIN
		SET @MileStone = 'N'
	END

	--For Pending Rights
	DECLARE @IsCompleted_R VARCHAR(50)
			SELECT @IsCompleted_R =[dbo].[UFN_Get_Syn_Deal_IsComplete](@Syn_Deal_Code)
	IF(@WorkFlowStatus = 'R' AND @IsCompleted_R <>'Y')
	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @SEND_FOR_APPROVAL
	

	-- SHOW ERROR
	DECLARE @cntE INT
	SELECT @cntE = COUNT(Syn_Deal_Code) from Syn_Deal_Rights where Syn_Deal_Code = @Syn_Deal_Code and ISNULL(Right_Status,'P') in ('E')
	
	IF (@cntE > 0)
	BEGIN
		SET @ShowError = 'Y'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @APPROVE)
	END
	ELSE
	BEGIN
		DECLARE @cntP INT
		SELECT @cntP = COUNT(Syn_Deal_Code) from Syn_Deal_Rights where Syn_Deal_Code = @Syn_Deal_Code and ISNULL(Right_Status,'P') in ('P','W')
		
		IF (@cntP > 0)
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @APPROVE)
	END

	--For Approve
	Declare @GCode INT=0,@UGCode INT=0,@DBUCode INT=0
	select @DBUCode=Business_Unit_Code from Syn_Deal WITH(NOLOCK) where Syn_Deal_Code=@Syn_Deal_Code
	select  @UGCode=Security_Group_Code from Users u WITH(NOLOCK)
	INNER JOIN Users_Business_Unit bu WITH(NOLOCK) ON bu.Users_Code=u.Users_Code
	 where u.Users_Code=@User_Code and @DBUCode=bu.Business_Unit_Code
	select @GCode=ISNULL(dbo.UFN_Get_Current_Approver_Code(35, @Syn_Deal_Code),0)
	--IF( @UGCode = @GCode)
	--UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code  = @Approve
	IF( @UGCode != @GCode)
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN(@Approve,@ARCHIVE,@Reject,@RE_OPEN_DEAL)



	
	-- Re-Open
	IF(@WorkFlowStatus = 'RO')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code IN (@EDIT,@View)
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Delete,@Clone,@SEND_FOR_APPROVAL,@APPROVE,@Reject, @Amendment,@CLOSE_DEAL,@RE_OPEN_DEAL,@Rollback,@Terminate)
	END


	-- SHOW ERROR END
	SELECT  @Is_Right_Available = (SELECT STUFF((SELECT ',' + Cast(Right_Code as VARCHAR(MAX)) 
	FROM @Module_Rights 
	WHERE Visible='Y' 
	FOR XML PATH('')), 1, 1, '' ) )

	SET @strReturnString = ',' + @Is_Right_Available + ','

	IF(@MileStone = 'Y' AND @Is_Terminated = 'N')
		SET @strReturnString = @strReturnString + @MileStone +','
		--RETURN  @Is_Right_Available + ',' + @MileStone +','

	IF (@ShowError = 'Y' AND @Is_Terminated = 'N')
		SET @strReturnString = @strReturnString + 'E,'

		

--	RETURN  ','+@Is_Right_Available +','
	RETURN  ',' + @strReturnString +','
	--SELECT @strReturnString
END

/*
SELECT Dbo.[UFN_SYN_DEAL_SET_BUTTON_VISIBILITY](54,0001,143,'Y')
*/