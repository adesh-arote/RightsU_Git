ALTER FUNCTION [dbo].[UFN_Get_Deal_DealWorkFlowStaus](@Acq_Deal_Code INT, @Deal_Workflow_Status VARCHAR(50), @User_Code INT)
RETURNS NVARCHAR(MAX)
AS
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 27-October-2014
-- Description:	Return related dependencies added or not for a deal
-- =============================================
BEGIN

	DECLARE @Final_Status NVARCHAR(MAX) ='', @Is_Terminated VARCHAR(1) = '', @Security_Group_Name NVARCHAR(50) = '' , @ConcatName NVARCHAR(1000) =''

	Select @Is_Terminated = CASE WHEN ISNULL(UPPER([Status]), '') = 'T' THEN 'Y' ELSE 'N' END  FROM Acq_Deal with(nolock) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code

	IF(@Is_Terminated ='Y' )
	BEGIN
		SET @Final_Status ='Terminated'
		IF(@Deal_Workflow_Status='W')
		BEGIN
			SET @Final_Status='Termination, Waiting for authorization'
	
			SELECT @Security_Group_Name = sg.Security_Group_Name FROM
			(SELECT  TOP 1 primary_user_code= CASE 
			WHEN role_level=0  THEN 0 ELSE group_code--primary_user_code --changed by anita for allowing security grup to approve deal
			END FROM Module_Workflow_Detail with(nolock)
			WHERE module_code=30 AND record_code = @Acq_Deal_Code AND is_done='N' 
			ORDER BY role_level)tbl 
			--INNER JOIN Users u ON u.Users_Code = tbl.primary_user_code
			INNER JOIN Security_Group sg with(nolock) ON sg.Security_Group_Code = tbl.primary_user_code

			if(isnull(@Security_Group_Name,'')!='')
				set @ConcatName= ' from ' +@Security_Group_Name

			SET @Final_Status = @Final_Status + @ConcatName
		END
		IF(@Deal_Workflow_Status='R')
		BEGIN
			SET @Final_Status='Termination Rejected'
		END
	END
	ELSE IF(@Deal_Workflow_Status='N' OR @Deal_Workflow_Status='AM' )
	BEGIN
		IF((SELECT [dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code))='Y')
		BEGIN
			SET @Final_Status ='Details Added'
		END
		ELSE
		BEGIN
			DECLARE @Deal_Complete_Flag NVARCHAR(50)
			SELECT @Deal_Complete_Flag =[dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code)
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='R')
				SET @Final_Status='Rights'
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='C')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=', '
				SET @Final_Status+='Cost'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='P')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Pushback'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='A')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Ancillary'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='D')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Run Defn'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',') WHERE number='B')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=', '
				SET @Final_Status+='Budget'
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
		Select @IsZeroWorkFlow=[dbo].[UFN_Check_Workflow](30,@Acq_Deal_Code) 

		DECLARE @Deal_Complete_Flag_R NVARCHAR(50)
		SELECT @Deal_Complete_Flag_R =[dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code)

		IF(@Deal_Workflow_Status='R' AND @Deal_Complete_Flag_R = 'Y')
		BEGIN
			--Declare @RetValue INT = 0
			--Select Top 1 @RetValue = Group_Code From Module_Workflow_Detail 
			--Where Record_Code = @Acq_Deal_Code And Module_Code = 30 And Role_Level = 0 Order By Module_Workflow_Detail_Code Desc

			SET @Final_Status='Rejected'
		END
		ELSE IF (@Deal_Complete_Flag_R <> 'Y')
		Begin
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='R')
				SET @Final_Status='Rights'
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='C')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=', '
				SET @Final_Status+='Cost'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='P')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Pushback'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='A')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Ancillary'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='D')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=','
				SET @Final_Status+='Run Defn'
			END
		
			IF EXISTS(SELECT * FROM DBO.fn_Split_withdelemiter(@Deal_Complete_Flag_R, ',') WHERE number='B')
			BEGIN 
				IF(@Final_Status!='')
					SET @Final_Status+=', '
				SET @Final_Status+='Budget'
			END

			IF(@Final_Status!='')
				SET @Final_Status+=' Pending'
		End
		ELSE
			SET @Final_Status='Pending Verification'
	
		SELECT @Security_Group_Name = sg.Security_Group_Name FROM
		(SELECT  TOP 1 primary_user_code= CASE 
		WHEN role_level=0  THEN 0 ELSE group_code--primary_user_code --changed by anita for allowing security grup to approve deal
		END FROM Module_Workflow_Detail  with(nolock)
		WHERE module_code=30 AND record_code = @Acq_Deal_Code AND is_done='N' 
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
	ELSE IF (@Deal_Workflow_Status='RO' )
	BEGIN
		SET @Final_Status ='Re-Open'
	END
	IF (@Deal_Workflow_Status='EO' )
	BEGIN
		SET @Final_Status ='Approved (Override)'
	END
	IF (@Deal_Workflow_Status='RR' )
	BEGIN
		SET @Final_Status ='Runs, Rights Pending'
	END
	IF (@Deal_Workflow_Status='RP' )
	BEGIN
		SET @Final_Status ='Runs Pending'
	END
	IF (@Deal_Workflow_Status='WA' )
	BEGIN
		SET @Final_Status ='Waiting (Archive)'
	END
	IF (@Deal_Workflow_Status='AR' )
	BEGIN
		SET @Final_Status ='Archive'
	END
	RETURN @Final_Status
END
/*

Select [dbo].[UFN_Get_Deal_DealWorkFlowStaus](2098,'R',143)
Select Top 1  Group_Code From Module_Workflow_Detail 
Where Record_Code = 2098 And Module_Code = 30 Order By Module_Workflow_Detail_Code Desc

*/
