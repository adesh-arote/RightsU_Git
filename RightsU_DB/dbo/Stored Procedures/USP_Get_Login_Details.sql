CREATE PROCEDURE [dbo].[USP_Get_Login_Details]
(
   	@Data_For VARCHAR(MAX),
	@Entity_Code INT,
	@User_Code INT
)
AS
BEGIN
	
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	CREATE TABLE #PreReqData
	(
		Parameter_Value VARCHAR(MAX),
		Data_For VARCHAR(3)
	)
	
	IF(CHARINDEX('MLA',@Data_For) > 0)
	BEGIN
		
		INSERT INTO #PreReqData(Parameter_Value, Data_For)
		SELECT Parameter_Value, 'MLA' FROM System_Parameter_New WHERE Parameter_Name = 'MAXLOGINATTEMPTS'

	END

	IF(CHARINDEX('MLM',@Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Parameter_Value, Data_For)
		SELECT Parameter_Value, 'MLM' FROM System_Parameter_New WHERE Parameter_Name = 'MAXLOCKTIMEMINUTES'
	END

	IF(CHARINDEX('DEN',@Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Parameter_Value, Data_For)
		SELECT Entity_Name, 'DEN' FROM Entity Where Entity_Code = @Entity_Code
	END

	IF(CHARINDEX('DEL',@Data_For) > 0)
	BEGIN
		INSERT INTO #PreReqData(Parameter_Value, Data_For)
		SELECT Logo_Name, 'DEL' FROM Entity Where Entity_Code = @Entity_Code
	END

	IF(CHARINDEX('PVD',@Data_For) > 0)
	BEGIN
		DECLARE @LastPasswordChangeDate VARCHAR(50),@daydiff INT=0,@defaultdays INT=0
		SET @LastPasswordChangeDate=(SELECT TOP 1 Password_Change_Date FROM Users_Password_Detail WHERE Users_Code=@User_Code ORDER BY Password_Change_Date DESC )
		if(@LastPasswordChangeDate IS NULL)
		set @LastPasswordChangeDate='1900-01-01'
		SELECT @daydiff=DATEDIFF(day,@LastPasswordChangeDate,GETDATE())
		SELECT @defaultdays=Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'PASSWORDVALIDDAY'
		IF(@daydiff>@defaultdays)
			BEGIN
			INSERT INTO #PreReqData(Parameter_Value, Data_For)
			SELECT 'true', 'PVD'
			END
		ELSE
			BEGIN
			INSERT INTO #PreReqData(Parameter_Value, Data_For)
			SELECT 'false', 'PVD'
			END
	END

	SELECT Parameter_Value, Data_For FROM #PreReqData

	IF OBJECT_ID('tempdb..#PreReqData') IS NOT NULL DROP TABLE #PreReqData

END

--select * from (select * from system_module sm where  module_code in(
--         select module_code from Security_Group_Rel sgr inner join System_Module_Right smr 
--         on sgr.system_module_rights_code=smr.module_right_code  
--         where IS_ACTIVE='Y' and security_group_code in(1))

--         union 

--         select * from system_module sm where  module_code in(
--         select distinct parent_module_code from system_module where module_code in (
--         select module_code from Security_Group_Rel sgr inner join System_Module_Right smr 
--         on sgr.system_module_rights_code=smr.module_right_code  
--         where security_group_code in(1) and IS_ACTIVE='Y'))

--         union  
		 
--		 select *  from system_module sm where  module_code in( select distinct parent_module_code   
--         from 	system_module sm where  module_code in(select distinct parent_module_code from system_module where module_code in 
--	     (select module_code from Security_Group_Rel sgr inner join System_Module_Right smr on sgr.system_module_rights_code=smr.module_right_code 
--          where security_group_code in(1) and IS_ACTIVE='Y')) ) 
--         ) as a order by module_position 



--		 Module_Code int,
--	Module_Name varchar(100),
--	Module_Position varchar(10),
--	Parent_Module_Code	int,
--	Is_Sub_Module char(1),
--	Url varchar(1000),
--	Target varchar(50),
--	Css varchar(50),
--	Can_Workflow_Assign char(1),
--	Is_Active char(1),