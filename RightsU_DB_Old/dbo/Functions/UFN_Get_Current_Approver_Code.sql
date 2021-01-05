
CREATE FUNCTION [dbo].[UFN_Get_Current_Approver_Code]
(@moduleCode int,@recordCode int)
-- =============================================
-- Author:		Pavitar (Moved from old system)
-- Create DATE: 08-October-2014
-- Description:	Gets Approver Name
-- =============================================
RETURNS int
BEGIN
	DECLARE @currApproverCode int

	SELECT @currApproverCode=primary_user_code FROM
	(SELECT  TOP 1 primary_user_code= CASE 
	WHEN role_level=0  THEN 0 ELSE group_code--primary_user_code --changed by anita for allowing security grup to approve deal
	END FROM Module_Workflow_Detail WITH(NOLOCK)
	WHERE module_code=@moduleCode AND record_code=@recordCode AND is_done='N' 
	ORDER BY role_level)tbl


RETURN @currApproverCode
--select dbo.fn_getCurrentApproverCode(30,23)
 
END