
-- =============================================
-- Author:		Abhaysingh Rajpurohit
-- ALTER DATE: 10-October-2014
-- Description:	Acq Deal Pushback Milestone in Wording Format 
-- =============================================

CREATE FUNCTION [dbo].[UFN_Get_Rights_Milestone]
(
	@Milestone_Type_Code INT, @Milestone_No_Of_Unit INT, @Milestone_Unit_Type INT
) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @RetVal VARCHAR(MAX) = ''
	
	IF(@Milestone_Type_Code = 1)
		SET @RetVal = 'From 1st Run To :'
	ELSE IF(@Milestone_Type_Code = 2)
		SET @RetVal = 'From TC / QC Ok To :'
	ELSE IF(@Milestone_Type_Code = 3)
		SET @RetVal = 'From Material Delivery To :'

	SET @RetVal += ' ' + CAST(@Milestone_No_Of_Unit AS VARCHAR)

	IF(@Milestone_Unit_Type = 1)
		SET @RetVal += ' Day'
	IF(@Milestone_Unit_Type = 2)
		SET @RetVal += ' Week'
	IF(@Milestone_Unit_Type = 3)
		SET @RetVal += ' Month'
	IF(@Milestone_Unit_Type = 4)
		SET @RetVal += ' Year'

	IF(@Milestone_No_Of_Unit > 1)
		SET @RetVal += 's'

	RETURN @RetVal
END
