alter FUNCTION [dbo].[UFN_Music_Exception_Button_Visibility]
(
	--DECLARE
 	 @Music_Schedule_Transaction_Code INT=1193 
	,@User_Code INT=143
	,@WorkFlowStatus VARCHAR(50)='R'
) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @Is_Right_Available VARCHAR(MAX) , @IsZeroWorkFlow VARCHAR(2), @BU_Code INT,@tmpCount INT
	/*
	7. View
	8. SEND FOR APPROVAL
	11. APPROVE
	12. Reject
	*/
	Declare @UserSecCode  INT = 0 --, @dealTypeCode INT = 0, @dealTypeCode_Music INT = 0
	--SELECT TOP 1 @dealTypeCode = Deal_Type_Code FROM Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code
	--IF EXISTS (SELECT * FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Music')
	--	SELECT TOP 1 @dealTypeCode_Music = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Music'

	SELECT @UserSecCode = Security_Group_Code FROM Users WHERE Users_Code = @User_Code  

	DECLARE @Module_Rights Table
	(
		Right_Code INT,
		Right_Name  NVARCHAR(100),
		Visible varchar(1)
	)
	declare @Security_Group_Code INT, @Right_Code INT
	select @Security_Group_Code = Security_Group_Code From Users where Users_Code = @User_Code

	INSERT INTO @Module_Rights (Right_Code, Right_Name,Visible)
	SELECT DISTINCT sr.Right_Code, sr.Right_Name ,CASE WHEN ISNULL(sgr.Security_Group_Code,0)=0 THEN  'N' ELSE 'Y' END
	FROM System_Module_Right smr 
	INNER JOIN System_Right sr ON sr.Right_Code = smr.Right_Code
	LEFT JOIN Security_Group_Rel sgr ON smr.Module_Right_Code = sgr.System_Module_Rights_Code AND sgr.Security_Group_Code=@Security_Group_Code
	WHERE SR.Right_Code IN (1, 2, 6, 7, 8, 10, 11, 12, 18, 71, 79, 88, 89, 116, 127, 130, 134, 135) AND smr.Module_Code=154  
	ORDER BY SR.Right_Code
	
	DECLARE @View int = 7, 
			@SEND_FOR_APPROVAL int =8, 
			@APPROVE int = 11, 
			@Reject int = 12

		IF(@WorkFlowStatus = 'O' OR @WorkFlowStatus IS NULL)
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@APPROVE,@View)
		END

		IF(@WorkFlowStatus = 'R')
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@APPROVE,@View)
		END
		
		
	/*ZeroWorkFlow*/

	--Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](154,@Music_Schedule_Transaction_Code) 

	--IF(@IsZeroWorkFlow = 'Y')
	--	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@APPROVE,@View)

	--IF(@WorkFlowStatus = 'W')
	--BEGIN
	--	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@APPROVE,@View)
	--END
	--ELSE IF(@IsZeroWorkFlow != 'N')
	--	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SEND_FOR_APPROVAL)

	--Waiting for Authorization
	
	
	IF(@WorkFlowStatus = 'R')
	BEGIN

		Declare @RetValue Int = 0
		--SELECT @hdnAllow_Edit_All_On_Rejection = Parameter_value FROM System_Parameter_New 
		--WHERE Parameter_Name = 'Allow_Edit_All_On_Rejection' AND IsActive = 'Y'

		--select @UserSecCode
		--select @RetValue
	

		SELECT @Right_Code =sr.Right_Code 	FROM 
		System_Module_Right smr 
		INNER JOIN System_Right sr on sr.Right_Code = smr.Right_Code
		INNER JOIN Security_Group_Rel sgr on smr.Module_Right_Code = sgr.System_Module_Rights_Code and sgr.Security_Group_Code = @Security_Group_Code
		WHERE smr.Module_Code=154  and sgr.Security_Group_Code=@Security_Group_Code and sr.Right_Code = @APPROVE

		IF (@Right_Code = @APPROVE) 
		BEGIN
			--IF(@IsZeroWorkFlow = 'N')
			--BEGIN
			UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code = @APPROVE
			--END
		END
		ELSE
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@APPROVE)
		END
	END
	
	--select @IsZeroWorkFlow
	--select * from @Module_Rights
	--For Approve
	select @Security_Group_Code = Security_Group_Code From Users where Users_Code = 143

	SELECT @Right_Code =sr.Right_Code 	FROM 
	System_Module_Right smr 
	INNER JOIN System_Right sr on sr.Right_Code = smr.Right_Code
	INNER JOIN Security_Group_Rel sgr on smr.Module_Right_Code = sgr.System_Module_Rights_Code and sgr.Security_Group_Code = @Security_Group_Code
	WHERE smr.Module_Code=154  and sgr.Security_Group_Code=@Security_Group_Code and sr.Right_Code = @APPROVE

	IF( @Right_Code != @APPROVE)
	UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @Approve

	

	--Select  @BU_Code=AD.Business_Unit_Code
	--			From Music_Schedule_Transaction AS MST
	--			INNER JOIN BV_Schedule_Transaction AS BST ON BST.BV_Schedule_Transaction_Code= MST.BV_Schedule_Transaction_Code
	--			INNER JOIN Acq_Deal_Movie AS ADM ON ADM.Acq_Deal_Movie_Code = BST.Deal_Movie_Code
	--			INNER JOIN Acq_Deal AS AD ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	--			 WHERE MST.Music_Schedule_Transaction_Code=@Music_Schedule_Transaction_Code

				 
	--		Select @tmpCount=count(*)
	--		From Workflow_Module_Role Where Workflow_Module_Code In (
	--			Select Workflow_Module_Code From Workflow_Module 
	--			Where Module_Code = 154 And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
	--			And cast(GetDate()AS Date ) Between Effective_Start_Date And IsNull(System_End_Date, GetDate())
	--		)

	--IF(@tmpCount=0)
	--BEGIN
	--UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code NOT IN (@View)
	--END
	--IF(@WorkFlowStatus = 'R')
	--UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @SEND_FOR_APPROVAL
	--select * from @Module_Rights
  	SELECT  @Is_Right_Available = (SELECT STUFF((SELECT ','+ Cast(Right_Code as Varchar(MAX)) FROM @Module_Rights WHERE Visible='Y' FOR XML PATH('')), 1, 1, '' ) )
    	
		--select @Is_Right_Available
	RETURN  ','+@Is_Right_Available +','
END