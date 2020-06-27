
ALTER PROCEDURE [dbo].[USP_GetMenu]
@SecurityGroupCode varchar(10),
@IsSuperAdmin char(1),
@Users_Code INT
AS
BEGIN
  --declare @SecurityGroupCode varchar(10)=281, @IsSuperAdmin char(1)='Y', @Users_Code INT = 222
SET FMTONLY OFF
	CREATE TABLE #Temp
	(
		Module_Code int,
		Module_Name NVARCHAR(100),
		Module_Position varchar(10),
		Parent_Module_Code	int,
		Is_Sub_Module char(1),
		Url NVARCHAR(1000),
		Target NVARCHAR(50),
		Css varchar(50),
		Can_Workflow_Assign char(1),
		Is_Active char(1),
	)
		
   DECLARE @Sql varchar(Max)
   SET @Sql = ''
   
    IF (len(@IsSuperAdmin)>0)
	BEGIN    
		SET @Sql = 'SELECT * from (select * from system_module sm where  module_code in( ' +
                     'select module_code from Security_Group_Rel sgr inner join System_Module_Right smr ' +
                     'on sgr.system_module_rights_code=smr.module_right_code  ' +
                     'where IS_ACTIVE=''Y'' and security_group_code in(''' + @SecurityGroupCode + ''') and smr.Module_Right_Code NOT IN(
					 SELECT Module_Right_Code From Users_Exclusion_Rights where Users_Code = '+CAST(@Users_Code AS VARCHAR)+'))' +
                     'union ' +
                     'select * from system_module sm where  module_code in(' +
                     'select distinct parent_module_code from system_module where module_code in (' +
                     'select module_code from Security_Group_Rel sgr inner join System_Module_Right smr ' +
                     'on sgr.system_module_rights_code=smr.module_right_code  ' +
                     'where security_group_code in(''' + @SecurityGroupCode + ''')
					 and smr.Module_Right_Code NOT IN(
					 SELECT Module_Right_Code From Users_Exclusion_Rights where Users_Code  ='+CAST(@Users_Code AS VARCHAR)+')
					 and IS_ACTIVE=''Y''))'+
                     'union  select *  from system_module sm where  module_code in( select distinct parent_module_code   '+
                     'from 	system_module sm where  module_code in(select distinct parent_module_code from system_module where module_code in '+
	                 '(select module_code from Security_Group_Rel sgr inner join System_Module_Right smr1 on sgr.system_module_rights_code=smr1.module_right_code '+
                     ' where security_group_code in(''' + @SecurityGroupCode + ''') and IS_ACTIVE=''Y''
					 and smr1.Module_Right_Code NOT IN(
					 SELECT Module_Right_Code From Users_Exclusion_Rights where Users_Code ='+CAST(@Users_Code AS VARCHAR)+'))))' +
                     ') as a order by module_position' 
	END 
	ELSE
	BEGIN    
		SET @Sql = 'SELECT * from system_module where Is_Active = ''Y'' order by module_position' 
	END 
      insert into #temp 
	  exec(@Sql)

      select * from #temp 		
	  Drop table #temp
  
  END
  
  -- Exec [dbo].[USP_GetMenu] 1,'',1
