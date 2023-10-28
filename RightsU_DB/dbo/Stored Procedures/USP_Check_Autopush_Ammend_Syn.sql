CREATE PROCEDURE [dbo].[USP_Check_Autopush_Ammend_Syn]
(
	@SynDealCode INT
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Autopush_Ammend_Syn]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE
			--@syndealcode INT = 2861, 
			@StatusFlag CHAR(10) = '',
			@IsAutoPush CHAR(1) = '',
			@ISERROR CHAR(1),
			@NewAcqDealCode_S INT

			SELECT TOP 1 @NewAcqDealCode_S = SecondaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD (NOLOCK) WHERE MD.MappingFor = 'ACQDEAL' AND PrimaryDataCode = @SynDealCode
			SELECT @StatusFlag = Deal_Workflow_Status FROM RightsU_Plus_Testing.dbo.Acq_Deal (NOLOCK) Where Acq_Deal_Code =  @NewAcqDealCode_S
			SELECT @IsAutoPush = Is_Auto_Push FROM RightsU_Plus_Testing.dbo.Acq_Deal (NOLOCK) Where Acq_Deal_Code =  @NewAcqDealCode_S

		IF EXISTS(SELECT TOP 1  SecondaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD (NOLOCK) WHERE MD.MappingFor = 'ACQDEAL' AND PrimaryDataCode = @SynDealCode)
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
			
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Autopush_Ammend_Syn]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END