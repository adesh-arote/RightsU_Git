
CREATE FUNCTION [dbo].[UFN_Deal_Set_Button_Visibility_AL]
(
 	 @Acq_Deal_Code INT 
	,@Version FLOAT
	,@User_Code INT
	,@WorkFlowStatus VARCHAR(50)
) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- DECLARE
	-- @Acq_Deal_Code INT=15523
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

	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(1)--@dealTypeCode)

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
	LEFT JOIN Security_Group_Rel sgr With(NoLock) ON smr.Module_Right_Code = sgr.System_Module_Rights_Code AND sgr.Security_Group_Code=1--@UserSecCode
	WHERE SR.Right_Code IN (1, 2, 6, 7, 8, 10, 11, 12, 18, 19, 71, 79, 88, 89, 116, 127, 130, 134, 135, 138, 164,166,185,187,188,189,121) AND smr.Module_Code=261  
	ORDER BY SR.Right_Code


	DECLARE @Edit int =2, @View int = 7, @Delete int = 6, @SEND_FOR_APPROVAL int =8, @APPROVE int = 11,@Reject int = 12,  @Clone int = 10
	 ,@ExportToExcel INT = 121 ,@ExportToPDF INT = 185,@ViewRecommendation INT =187, @FinallyClose INT = 188,@CreateNewRecommendation INT = 189,
	 
			 @Amendment int = 18, @Amort int = 19, @Content int = 71, @AMENDMENT_SYN int = 79, @CLOSE_DEAL int = 88, @RE_OPEN_DEAL int = 89, 
			@Rollback int =116 ,@Terminate int =127,  @MileStone varchar(1) = 'Y',@Edit_Without_Approval int=134,
			@RollbackWithoutApproval INT = 135, @ReleaseContent INT = 138, @ShowError CHAR(1) = 'N',
			@SEND_FOR_ARCHIVE INT = 166, @ARCHIVE INT = 164 
	
	Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](261,1) ,@IsCompleted = [dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code)
	

	IF(@IsZeroWorkFlow = 'Y')
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code in( @SEND_FOR_APPROVAL)
	ELSE IF(@IsZeroWorkFlow != 'N')
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL,@APPROVE)

	Declare @GCode INT=0,@UGCode INT=0,@DBUCode INT=0
	SET @DBUCode= 34 --Business_Unit_Code from Acq_Deal With(NoLock) where Acq_Deal_Code=@Acq_Deal_Code
	select  @UGCode=Security_Group_Code from Users u With(NoLock) 
	INNER JOIN Users_Business_Unit bu With(NoLock) ON bu.Users_Code=u.Users_Code
	 where u.Users_Code=@User_Code and @DBUCode=bu.Business_Unit_Code
	select @GCode=ISNULL(dbo.UFN_Get_Current_Approver_Code(30,@Acq_Deal_Code),0)

	IF( @UGCode != @GCode)
	BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code in( @Approve)
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
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Delete, @SEND_FOR_APPROVAL, @APPROVE, @Reject, @CreateNewRecommendation)
	END

	IF(@WorkFlowStatus = 'R')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Delete, @APPROVE, @Reject, @Clone, @ExportToExcel, @ExportToPDF, @ViewRecommendation, @FinallyClose, @CreateNewRecommendation)
	END

	SELECT  @Is_Right_Available = (SELECT STUFF((SELECT ','+ Cast(Right_Code as Varchar(MAX)) FROM @Module_Rights WHERE Visible='Y' FOR XML PATH('')), 1, 1, '' ) )

	--Select * from @Module_Rights where Visible='Y'
	RETURN ','+@Is_Right_Available +',' 
	

	
END