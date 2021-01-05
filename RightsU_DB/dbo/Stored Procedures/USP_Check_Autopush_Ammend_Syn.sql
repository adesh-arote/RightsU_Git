CREATE PROC [dbo].[USP_Check_Autopush_Ammend_Syn]
(
	@SynDealCode INT
)
AS
BEGIN
	DECLARE
		--@syndealcode INT = 2861, 
	    @StatusFlag CHAR(10) = '',
	    @IsAutoPush CHAR(1) = '',
		@ISERROR CHAR(1),
		@NewAcqDealCode_S INT

		SELECT TOP 1 @NewAcqDealCode_S = SecondaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND PrimaryDataCode = @SynDealCode
		SELECT @StatusFlag = Deal_Workflow_Status FROM RightsU_Plus_Testing.dbo.Acq_Deal Where Acq_Deal_Code =  @NewAcqDealCode_S
	    SELECT @IsAutoPush = Is_Auto_Push FROM RightsU_Plus_Testing.dbo.Acq_Deal Where Acq_Deal_Code =  @NewAcqDealCode_S

	IF EXISTS(SELECT TOP 1  SecondaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND PrimaryDataCode = @SynDealCode)
	BEGIN
		IF(@StatusFlag = 'A')
		BEGIN
			SET @ISERROR = 'N'
		END
		ELSE
		BEGIN
			SET @ISERROR = 'Y'
		END
	END
	ELSE
	BEGIN
		SET @ISERROR = 'N'
	END
			Select @ISERROR
			--SELECT @StatusFlag
			--SELECT @IsAutoPush
			--Return @ISERROR
END