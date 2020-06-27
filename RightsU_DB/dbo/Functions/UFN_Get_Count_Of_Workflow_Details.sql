
CREATE FUNCTION [dbo].[UFN_Get_Count_Of_Workflow_Details]    
(         
 @ModuleCode int,
 @RecordCode int   
)    
RETURNS int    
-- =============================================    
-- Author:  Pavitar (Moved From Old System) 
-- Create date: 8-Oct-2014
-- Description: Gets Count of levels in workflow
-- =============================================    
AS    
BEGIN    
    
 declare @cnt as int     
 set @cnt=0    
 
 select @cnt=max(role_level) from Module_Workflow_Detail with(nolock) where record_code=@RecordCode  and module_code=@ModuleCode
   
 return @cnt     
     
    
END