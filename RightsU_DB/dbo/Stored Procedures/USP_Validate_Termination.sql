
CREATE PROC USP_Validate_Termination
(
	@Deal_Code INT,
	@Type CHAR(1) -- 'A' for Acquisition, 'S' for Syndication
)
AS
BEGIN
	DECLARE @Err_Message VARCHAR(MAX) = '', @Val VARCHAR(MAX) = '', @Is_Error CHAR(1) = 'N'
	IF(@Type = 'A')
	BEGIN
		IF EXISTS (SELECT * FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Deal_Code AND Actual_Right_End_Date IS NULL AND Right_Type <> 'U')
		BEGIN
			SET @Is_Error = 'Y'
			SET @Err_Message = 'Please set Milestone Date first'
		END

		IF(@Is_Error = 'N')
		BEGIN
			IF EXISTS (SELECT * FROM Syn_Acq_Mapping SAM
				INNER JOIN Syn_Deal SD ON SAM.Syn_Deal_Code = SD.Syn_Deal_Code AND SD.Deal_Workflow_Status <> 'A' AND SAM.Deal_Code = @Deal_Code
			)
			BEGIN
				SET @Is_Error = 'Y'
				SELECT @Val = @Val + ', ' + A.Agreement_No FROM(
					SELECT DISTINCT SD.Agreement_No FROM Syn_Acq_Mapping SAM
					INNER JOIN Syn_Deal SD ON SAM.Syn_Deal_Code = SD.Syn_Deal_Code AND SD.Deal_Workflow_Status <> 'A' 
					AND SAM.Deal_Code = @Deal_Code
				) AS A

				SET @Val = RIGHT(@Val, (LEN(@Val) - 2))
				SET @Err_Message = 'Please approve Syndication deal ' + @Val
			END
		END
	END


	SELECT @Err_Message AS Err_Message
END
