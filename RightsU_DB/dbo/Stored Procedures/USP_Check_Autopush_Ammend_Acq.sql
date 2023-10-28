CREATE PROCEDURE [dbo].[USP_Check_Autopush_Ammend_Acq]
(
	@AcqDealCode INT
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel' 

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Autopush_Ammend_Acq]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE
			--@AcqDealCode INT = 25003, 
			@StatusFlag CHAR(10) = '',
			@ISERROR CHAR(1),
			@NewSynDealCode_S INT
			IF EXISTS(SELECT TOP 1 SecondaryDataCode FROM AcqPreReqMappingData (NOLOCK) WHERE PrimaryDataCode = @AcqDealCode)
			BEGIN
				SELECT TOP 1 @NewSynDealCode_S = PrimaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD (NOLOCK) WHERE MD.MappingFor = 'ACQDEAL' AND SecondaryDataCode = @AcqDealCode
				SELECT @StatusFlag = Deal_Workflow_Status FROM RightsU_Plus_Testing.dbo.Syn_Deal (NOLOCK) Where Syn_Deal_Code =  @NewSynDealCode_S
				IF EXISTS(SELECT TOP 1  PrimaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD (NOLOCK) WHERE MD.MappingFor = 'ACQDEAL' AND SecondaryDataCode = @AcqDealCode)
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
				END
			ELSE
			BEGIN
				PRINT 'NO VALIDATION'
				SET @ISERROR = 'N'
			END
				Select @ISERROR
			--Return @ISERROR
		
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Autopush_Ammend_Acq]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END