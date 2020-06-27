CREATE FUNCTION [dbo].[UFN_Get_Music_Deal_Workflow_Status]
(
	@Music_Deal_Code Int, @Deal_Workflow_Status varchar(50), @User_Code INT
)
RETURNS NVARCHAR(MAX)
AS
/*==============================================================================
Author			: Abhaysingh N. Rajpurohit
Date Created	: 07 Mar 2017
Description		: Return final Workflow status in string with proper message
==============================================================================*/
BEGIN

	DECLARE @Final_Status NVARCHAR(MAX) = '', @Security_Group_Name NVARCHAR(50) = '', @ConcatName NVARCHAR(1000) = ''

	IF (@Deal_Workflow_Status = 'N' OR @Deal_Workflow_Status = 'AM')
	BEGIN
		SET @Final_Status ='Details Added'
	END
	ELSE IF (@Deal_Workflow_Status='A' )
	BEGIN
		SET @Final_Status ='Approved'
	END
	ELSE IF(@Deal_Workflow_Status='R')
		BEGIN
			SET @Final_Status='Rejected'
		END
	ELSE IF (@Deal_Workflow_Status = 'W' )
	BEGIN
		SET @Final_Status='Waiting for authorization'

		Declare @IsZeroWorkFlow VARCHAR(1)
		Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](163, @Music_Deal_Code) 
		
		SELECT @Security_Group_Name = sg.Security_Group_Name 
		FROM (
			SELECT TOP 1 primary_user_code = CASE WHEN role_level = 0 THEN 0 ELSE group_code END 
			FROM Module_Workflow_Detail 
			WHERE module_code = 163 AND record_code = @Music_Deal_Code AND is_done = 'N' 
			ORDER BY role_level
		) tbl 
		INNER JOIN Security_Group sg ON sg.Security_Group_Code = tbl.primary_user_code
		
		IF(ISNULL(@Security_Group_Name, '') != '')
			SET @ConcatName= ' from ' + @Security_Group_Name

		if(@IsZeroWorkFlow = 'Y')
			SET @Final_Status = @Final_Status
		else 
			SET @Final_Status = @Final_Status + @ConcatName
	END
	ELSE IF (@Deal_Workflow_Status = 'RO')
	BEGIN
		SET @Final_Status ='Re-Open'
	END
	Return @Final_Status
END
