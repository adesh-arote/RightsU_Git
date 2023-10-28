CREATE FUNCTION [dbo].[UFNAL_PO_Set_Button_Visibility]
(
	 @AL_Purchase_Order_Code INT
	,@Version FLOAT
	,@User_Code INT
	,@WorkFlowStatus VARCHAR(50)
) 
RETURNS VARCHAR(MAX)
AS

BEGIN
	-- DECLARE
	-- @AL_Recommendation_Code INT=1327
	--,@Version FLOAT=0001
	--,@User_Code INT=221
	--,@WorkFlowStatus VARCHAR(50)='A'
	--Declare @AL_Purchase_Order_Code INT = 3130
	--,@Version FLOAT = 1
	--,@User_Code INT = 121
	--,@WorkFlowStatus VARCHAR(50) = 'W'
	

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
	WHERE SR.Right_Code IN (7, 8, 11, 12) AND smr.Module_Code=265  
	ORDER BY SR.Right_Code


	DECLARE @View int = 7, @SEND_FOR_APPROVAL int =8, @APPROVE int = 11,@Reject int = 12
			
	Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](265,@AL_Purchase_Order_Code) 
	

	IF(@IsZeroWorkFlow = 'Y')
		UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code in( @SEND_FOR_APPROVAL)
	ELSE IF(@IsZeroWorkFlow != 'N')
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL,@APPROVE)

	Declare @GCode INT=0,@UGCode INT=0,@DBUCode INT=0
	SET @DBUCode= 1 --Business_Unit_Code from Acq_Deal With(NoLock) where Acq_Deal_Code=@Acq_Deal_Code
	select  @UGCode=Security_Group_Code from Users u With(NoLock) 
	INNER JOIN Users_Business_Unit bu With(NoLock) ON bu.Users_Code=u.Users_Code
	 where u.Users_Code=@User_Code and @DBUCode=bu.Business_Unit_Code
	select @GCode=ISNULL(dbo.UFN_Get_Current_Approver_Code(265,@AL_Purchase_Order_Code),0)

	IF( @UGCode != @GCode)
	BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code in( @Approve, @Reject)
	END	

	IF(@WorkFlowStatus = 'W')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL)
	END

	IF(@WorkFlowStatus = 'A')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @APPROVE, @Reject)
	END

	IF(@WorkFlowStatus = 'F')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL, @APPROVE, @Reject)
	END

	IF(@WorkFlowStatus = 'R')
	BEGIN
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@APPROVE, @Reject)
	END

	SELECT  @Is_Right_Available = (SELECT STUFF((SELECT ','+ Cast(Right_Code as Varchar(MAX)) FROM @Module_Rights WHERE Visible='Y' FOR XML PATH('')), 1, 1, '' ) )

		--Select * from @Module_Rights where Visible='Y'
	RETURN @Is_Right_Available --+',' 
	
END