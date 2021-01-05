
CREATE Function [dbo].[UFN_Get_Blackout_Period](@Right_Code Int, @Right_Type CHAR(2))
Returns Varchar(Max)
As
Begin

	--DECLARE @Right_Code Int = 278 , @Right_Type CHAR(2) = 'AR'
	Declare @BlackoutPeriod Varchar(1000) = ''

	DECLARE @BLACKOUT_TEMP TABLE(
		Row_No INT IDENTITY(1,1) ,
		StartDate DATETIME,
		EndDate DATETIME
	)
	
	IF(@Right_Type = 'AR')
	BEGIN
		INSERT INTO @BLACKOUT_TEMP
		SELECT ADRB.Start_Date, ADRB.End_Date
		FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code
		WHERE ADR.Acq_Deal_Rights_Code = @Right_Code
	END
	ELSE IF(@Right_Type = 'SR')
	BEGIN
		INSERT INTO @BLACKOUT_TEMP
		SELECT SDRB.Start_Date, SDRB.End_Date
		FROM Syn_Deal_Rights SDR
		INNER JOIN Syn_Deal_Rights_Blackout SDRB ON SDR.Syn_Deal_Rights_Code = SDRB.Syn_Deal_Rights_Code
		WHERE SDR.Syn_Deal_Rights_Code = @Right_Code
	END

	Select @BlackoutPeriod = @BlackoutPeriod + Cast(Row_No as Varchar(5)) + ') ' + Blackout_Period  + '~'
	From (
				SELECT Row_No, CASE WHEN  StartDate IS NOT NULL AND EndDate IS NOT NULL  
									THEN CONVERT(varchar, StartDate, 103) + ' To ' + CONVERT(varchar, EndDate, 103)
								ELSE '' END as Blackout_Period
				FROM @BLACKOUT_TEMP
	) As B

	Return Substring(LTRIM(RTRIM(@BlackoutPeriod)), 0, Len(LTRIM(RTRIM(@BlackoutPeriod))))
	--SELECT SUBSTRING(LTRIM(RTRIM(@BlackoutPeriod)), 0, Len(LTRIM(RTRIM(@BlackoutPeriod))))
End
