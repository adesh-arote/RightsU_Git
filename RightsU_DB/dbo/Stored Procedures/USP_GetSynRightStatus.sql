CREATE PROCEDURE USP_GetSynRightStatus
(
	@rightCode INT,
	@dealCode INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 26 July 2016
-- Description:	Get Syndication Rights Status to show or hide ShowError Button and Loading 
-- =============================================
BEGIN
	SET FMTONLY OFF
	DECLARE @recordStatus VARCHAR(1) = ''
	DECLARE @recCount INT  = 0
	IF(@rightCode > 0)
	BEGIN
		SELECT @recordStatus = Right_Status FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @rightCode
	END
	ELSE
	BEGIN
		Select @recCount = COUNT(Syn_Deal_Code) from Syn_Deal_Rights  where Syn_Deal_Code = @dealCode AND ISNULL( Right_Status,'P') in ('E')
		IF(@recCount > 0)
			SET @recordStatus  = 'E';

		IF(@recordStatus = '')
		BEGIN
			SET @recCount = 0
			Select @recCount = COUNT(Syn_Deal_Code) from Syn_Deal_Rights  where Syn_Deal_Code = @dealCode AND ISNULL( Right_Status,'P') in ('P','W')
			IF(@recCount > 0)
				SET @recordStatus  = 'P';
		END

		IF(@recordStatus = '')
		BEGIN
			SET @recCount = 0
			Select @recCount = count(Syn_Deal_Rights_Code) From Syn_Deal_Rights_Process_Validation Where Status IN ('P', 'W') AND 
				Syn_Deal_Rights_Code IN (SELECT sdr.Syn_Deal_Rights_Code FROM Syn_Deal_Rights sdr WHERE sdr.Syn_Deal_Code = @dealCode)

			IF(@recCount > 0)
				SET @recordStatus  = 'P';
			ELSE
				SET @recordStatus  = 'C';
		END
	END

	SELECT @recordStatus AS Record_Status
END
