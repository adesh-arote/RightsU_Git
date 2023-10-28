CREATE FUNCTION [dbo].[UFN_Check_Workflow]
(
	@Module_Code INT, 
	@Record_Code INT
)
RETURNS VARCHAR(2)
AS
-- =============================================
-- Author:		Adesh/Pavitar Dua
-- Create DATE: 05-November-2014
-- Description:	Check Work Flow State
-- =============================================
Begin
	DECLARE @RetValue VARCHAR(2) = 'P', @BU_Code INT = 0, @Workflow_Code INT = 0--, @Record_Code Int=0

	IF(@Module_Code = 30)
	BEGIN
		SELECT @BU_Code = Business_Unit_Code FROM Acq_Deal WITH(NOLOCK) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Record_Code
	END
	ELSE IF(@Module_Code = 35)
	BEGIN
		SELECT @BU_Code = Business_Unit_Code FROM Syn_Deal WITH(NOLOCK) WHERE Syn_Deal_Code = @Record_Code
	END
	ELSE IF(@Module_Code = 154)
	BEGIN
		SELECT @BU_Code=AD.Business_Unit_Code from Music_Schedule_Transaction AS MST WITH(NOLOCK)
		INNER JOIN BV_Schedule_Transaction AS BST WITH(NOLOCK) ON BST.BV_Schedule_Transaction_Code= MST.BV_Schedule_Transaction_Code
		INNER JOIN Acq_Deal AS AD WITH(NOLOCK) ON AD.Acq_Deal_Code=BST.Deal_Movie_Code WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND MST.Music_Schedule_Transaction_Code=@Record_Code 
	END
	ELSE IF(@Module_Code = 163)
	BEGIN
		SELECT @BU_Code = Business_Unit_Code FROM Music_Deal WITH(NOLOCK) WHERE Music_Deal_Code = @Record_Code
	END
	ELSE IF(@Module_Code = 261 OR @Module_Code = 262)
	BEGIN
		--SELECT @BU_Code = Business_Unit_Code FROM Music_Deal WITH(NOLOCK) WHERE Music_Deal_Code = @Record_Code
		SELECT @Workflow_Code = Workflow_Code FROM Workflow_Module WITH(NOLOCK)
		WHERE Module_Code = 261 --@Module_Code 
		And cast(GetDate()AS Date ) Between Effective_Start_Date And ISNULL(System_End_Date, GETDATE())
	END	
	ELSE IF(@Module_Code = 265)
	BEGIN
		--SELECT @BU_Code = Business_Unit_Code FROM Music_Deal WITH(NOLOCK) WHERE Music_Deal_Code = @Record_Code
		SELECT @Workflow_Code = Workflow_Code FROM Workflow_Module WITH(NOLOCK)
		WHERE Module_Code = 265 --@Module_Code 
		And cast(GetDate()AS Date ) Between Effective_Start_Date And ISNULL(System_End_Date, GETDATE())
	END
		 
	IF(@Module_Code <> 261 OR @Module_Code <> 262)
	BEGIN
		SELECT @Workflow_Code = Workflow_Code FROM Workflow_Module WITH(NOLOCK)
		WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
		And cast(GetDate()AS Date ) Between Effective_Start_Date And ISNULL(System_End_Date, GETDATE())
	END

	IF(@Workflow_Code > 0)
	BEGIN
		IF((SELECT COUNT(*) FROM Workflow_Role WITH(NOLOCK) WHERE Workflow_Code = @Workflow_Code) = 0)
			SET @RetValue = 'Y'
		ELSE
			SET @RetValue = 'N'
	END
	ELSE
		SET @RetValue = 'NA'

	Return @RetValue 
End

