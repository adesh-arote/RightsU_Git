CREATE PROC [dbo].[USP_Check_Autopush_Ammend_Acq]
(
	@AcqDealCode INT
)
AS
BEGIN
	DECLARE
		--@AcqDealCode INT = 25003, 
	    @StatusFlag CHAR(10) = '',
		@ISERROR CHAR(1),
		@NewSynDealCode_S INT

		SELECT TOP 1 @NewSynDealCode_S = PrimaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND SecondaryDataCode = @AcqDealCode
		SELECT @StatusFlag = Deal_Workflow_Status FROM RightsU_Plus_Testing.dbo.Syn_Deal Where Syn_Deal_Code =  @NewSynDealCode_S
	IF EXISTS(SELECT TOP 1  PrimaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND SecondaryDataCode = @AcqDealCode)
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
			--Return @ISERROR
END