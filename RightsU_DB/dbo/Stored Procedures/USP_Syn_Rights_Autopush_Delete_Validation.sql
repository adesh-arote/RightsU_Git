CREATE PROC [dbo].[USP_Syn_Rights_Autopush_Delete_Validation]
(
	@SynDealRightsCode INT
)
AS
BEGIN
	DECLARE
	--@SynDealRightsCode INT = 1674, 
	@ISERROR CHAR(1),
	@NewAcqDealRightsCode_S INT

	IF EXISTS(SELECT TOP 1 SecondaryDataCode FROM AcqPreReqMappingData WHERE PrimaryDataCode = @SynDealRightsCode)
	BEGIN
		PRINT 'CHECK FOR VALIDATION'
		SELECT TOP 1 @NewAcqDealRightsCode_S = SecondaryDataCode FROM RightsU_VMPL_26Mar.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEALRIGHTS' AND PrimaryDataCode = @SynDealRightsCode
		

		IF(OBJECT_ID('TEMPDB..#SynDealRights') IS NOT NULL)
		DROP TABLE #SynDealRights
		CREATE TABLE #SynDealRights(DestSynDealRightSCode INT)

		INSERT INTO #SynDealRights(DestSynDealRightSCode)
		SELECT Syn_Deal_Rights_Code
		FROM RightsU_Broadcast.dbo.Syn_Acq_Mapping WHERE Deal_Rights_Code = @NewAcqDealRightsCode_S

		
	
		IF EXISTS(SELECT *  FROM #SynDealRights)
		BEGIN
			SET @ISERROR = 'Y'
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
END
