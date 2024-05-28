CREATE FUNCTION [dbo].[UFN_Get_PO_WorkFlowStatus]
(
	@AL_Purchase_Order_Code INT, 
	@Workflow_Status VARCHAR(50),
	@User_Code INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Final_Status NVARCHAR(MAX) ='', @Security_Group_Name NVARCHAR(50) = '' , @ConcatName NVARCHAR(1000) = '', @Module_Code INT = 0

	SET @Module_Code = (SELECT Module_Code from System_Module where Module_Name = 'Purchase Order');

	IF (@Workflow_Status='A' )
	BEGIN
		SET @Final_Status ='Approved'
	END
	ELSE IF (@Workflow_Status='R' OR @Workflow_Status='W' )
	BEGIN
	
		Declare @IsZeroWorkFlow VARCHAR(1)
		Select @IsZeroWorkFlow = [dbo].[UFN_Check_Workflow](@Module_Code,@AL_Purchase_Order_Code) 

		IF(@Workflow_Status='R')
		BEGIN	
			SET @Final_Status='Rejected'
		END
		ELSE
			SET @Final_Status='Awaiting for Approval'
	
		SELECT @Security_Group_Name = sg.Security_Group_Name FROM
		(SELECT  TOP 1 primary_user_code = 
		CASE 
			WHEN role_level = 0  THEN 0 ELSE group_code  --primary_user_code --allowing security grup to approve PO
		END 
		FROM Module_Workflow_Detail  with(nolock)
		WHERE module_code = @Module_Code AND record_code = @AL_Purchase_Order_Code AND is_done='N' 
		ORDER BY role_level)tbl 
		--INNER JOIN Users u ON u.Users_Code = tbl.primary_user_code
		INNER JOIN Security_Group sg with(nolock) ON sg.Security_Group_Code = tbl.primary_user_code
	
		if(isnull(@Security_Group_Name,'')!='')
			set @ConcatName= ' from ' +@Security_Group_Name

		IF(@IsZeroWorkFlow='Y')
			SET @Final_Status = @Final_Status
		ELSE 
			SET @Final_Status = @Final_Status + @ConcatName
	END
	RETURN @Final_Status
END