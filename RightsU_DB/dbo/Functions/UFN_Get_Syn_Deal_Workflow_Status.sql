
CREATE FUNCTION [dbo].[UFN_Get_Syn_Deal_Workflow_Status](@Syn_Deal_Code Int, @Deal_Workflow_Status varchar(50), @User_Code INT)
RETURNS NVARCHAR(MAX)
AS
--|==============================================================================
--| Author:		  RUSHABH V. GOHIL
--| Date Created: 21-Aug-2015
--| Description:  Return related dependencies added or not for Syndication Deals
--|==============================================================================
BEGIN

	DECLARE @Final_Status NVARCHAR(MAX) ='', @Is_Terminated VARCHAR(1) = '', @Security_Group_Name NVARCHAR(50) = '' , @ConcatName NVARCHAR(1000) =''

	Select @Is_Terminated = CASE WHEN ISNULL(UPPER([Status]), '') = 'T' THEN 'Y' ELSE 'N' END  FROM Syn_Deal WITH(NOLOCK) WHERE Syn_Deal_Code = @Syn_Deal_Code

	IF(@Is_Terminated ='Y' )
	BEGIN
		SET @Final_Status ='Terminated'
		IF(@Deal_Workflow_Status='W')
		BEGIN
			SET @Final_Status='Termination, Waiting for authorization'
	
			SELECT @Security_Group_Name = sg.Security_Group_Name 
			FROM (
				SELECT TOP 1 primary_user_code = CASE WHEN role_level=0 THEN 0 ELSE group_code END 
				FROM Module_Workflow_Detail WITH(NOLOCK)
				WHERE module_code=35 AND record_code = @Syn_Deal_Code AND is_done='N' 
				ORDER BY role_level
			) tbl 
			INNER JOIN Security_Group sg WITH(NOLOCK) ON sg.Security_Group_Code = tbl.primary_user_code
		
			if(isnull(@Security_Group_Name,'')!='')
			set @ConcatName= ' from ' +@Security_Group_Name

			SET @Final_Status = @Final_Status + @ConcatName
		END
		IF(@Deal_Workflow_Status='R')
		BEGIN
			SET @Final_Status='Termination Rejected'
		END
	END
	ELSE IF (@Deal_Workflow_Status='N' OR @Deal_Workflow_Status='AM' )
	BEGIN
		IF((SELECT [dbo].[UFN_Get_Syn_Deal_IsComplete](@Syn_Deal_Code))='Y')
		BEGIN
			SET @Final_Status ='Details Added'
		END
		ELSE
		BEGIN
			DECLARE @Deal_Complete_Flag NVARCHAR(50)
			SELECT @Deal_Complete_Flag =[dbo].[UFN_Get_Syn_Deal_IsComplete](@Syn_Deal_Code)
			
			IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='R')
				SET @Final_Status='Rights'
			
			IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='C')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=', '
				SET @Final_Status+='Revenue'
			END
			
			--IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='P')
			--BEGIN 
			--	IF(@Final_Status!='')
			--		SET @Final_Status+=','
			--	SET @Final_Status+='Pushback'
			--END
			
			IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='A')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Ancillary'
			END
			
			IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='D')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Run Defn'
			END
		
			IF(@Final_Status!='')
				SET @Final_Status+=' Pending'
		END
	END
	ELSE IF (@Deal_Workflow_Status='A' )
	BEGIN
		SET @Final_Status ='Approved'
	END
	ELSE IF (@Deal_Workflow_Status='R' OR @Deal_Workflow_Status='W' )
	BEGIN
		
		Declare @IsZeroWorkFlow VARCHAR(1)
		Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](35,@Syn_Deal_Code) 

		DECLARE @Deal_Complete_Flag_R VARCHAR(50)
			SELECT @Deal_Complete_Flag_R =[dbo].[UFN_Get_Syn_Deal_IsComplete](@Syn_Deal_Code)

		IF(@Deal_Workflow_Status='R' AND @Deal_Complete_Flag_R = 'Y')
		BEGIN
			--Declare @RetValue Int = 0
			--Select Top 1 @RetValue = Group_Code From Module_Workflow_Detail 
			--Where Record_Code = @Syn_Deal_Code And Module_Code = 30 And Role_Level = 0 Order By Module_Workflow_Detail_Code Desc

			SET @Final_Status='Rejected'
		END

		ELSE IF(@Deal_Complete_Flag_R <> 'Y')
		BEGIN
		IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='R')
				SET @Final_Status='Rights'
			
			IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='C')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=', '
				SET @Final_Status+='Revenue'
			END
			
			--IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@@Deal_Complete_Flag_R, ',') WHERE number='P')
			--BEGIN 
			--	IF(@Final_Status!='')
			--		SET @Final_Status+=','
			--	SET @Final_Status+='Pushback'
			--END
			
			IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='A')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Ancillary'
			END
			
			IF EXISTS(Select * From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='D')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Run Defn'
			END
		
			IF(@Final_Status!='')
				SET @Final_Status+=' Pending'
		END
		ELSE
			SET @Final_Status='Waiting for authorization'
		
		SELECT @Security_Group_Name = sg.Security_Group_Name 
		FROM (
			SELECT TOP 1 primary_user_code = CASE WHEN role_level=0 THEN 0 ELSE group_code END 
			FROM Module_Workflow_Detail WITH(NOLOCK)
			WHERE module_code=35 AND record_code = @Syn_Deal_Code AND is_done='N' 
			ORDER BY role_level
		) tbl 
		INNER JOIN Security_Group sg ON sg.Security_Group_Code = tbl.primary_user_code
		
		if(isnull(@Security_Group_Name,'')!='')
		set @ConcatName= ' from ' +@Security_Group_Name

		if(@IsZeroWorkFlow='Y')
			SET @Final_Status = @Final_Status
		else 
			SET @Final_Status = @Final_Status + @ConcatName
	END
	ELSE IF (@Deal_Workflow_Status='RO' )
	BEGIN
		SET @Final_Status ='Re-Open'
	END
	IF (@Deal_Workflow_Status='WA' )
	BEGIN
		SET @Final_Status ='Waiting (Archive)'

		SELECT @Security_Group_Name = sg.Security_Group_Name 
			FROM (
				SELECT TOP 1 primary_user_code = CASE WHEN role_level=0 THEN 0 ELSE group_code END 
				FROM Module_Workflow_Detail WITH(NOLOCK)
				WHERE module_code=35 AND record_code = @Syn_Deal_Code AND is_done='N' 
				ORDER BY role_level
			) tbl 
			INNER JOIN Security_Group sg WITH(NOLOCK) ON sg.Security_Group_Code = tbl.primary_user_code
		
			if(isnull(@Security_Group_Name,'')!='')
			set @ConcatName= ' from ' +@Security_Group_Name

			SET @Final_Status = @Final_Status + @ConcatName

	END
	IF (@Deal_Workflow_Status='AR' )
	BEGIN
		SET @Final_Status ='Archive'
	END
	Return @Final_Status
END