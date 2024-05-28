CREATE FUNCTION  [dbo].[UFN_Is_Deal_Added_For_Language_Group]
(
	@Language_Group_Code INT
)
RETURNS CHAR(1)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 15 May 2015
-- Description:	Check if Deal is added for selected Language Group
-- =============================================
BEGIN
	DECLARE @Deal_Count INT, @ReturnVal CHAR(1) = ''


	SELECT @Deal_Count = COUNT(Deal_Code) FROM (
	SELECT DISTINCT AD.Acq_Deal_Code AS Deal_Code FROM Acq_Deal AD 
	INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Subtitling ADRS ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code 
	AND ADRS.Language_Type = 'G' AND ADRS.Language_Group_Code = @Language_Group_Code
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	UNION 
	SELECT DISTINCT AD.Acq_Deal_Code AS Deal_Codec FROM Acq_Deal AD 
	INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Dubbing ADRD ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code 
	AND ADRD.Language_Type = 'G' AND ADRD.Language_Group_Code = @Language_Group_Code
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	UNION
	SELECT DISTINCT SD.Syn_Deal_Code AS Deal_Code FROM Syn_Deal SD 
	INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Subtitling SDRS ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code 
	AND SDRS.Language_Type = 'G' AND SDRS.Language_Group_Code = @Language_Group_Code
	UNION 
	SELECT DISTINCT SD.Syn_Deal_Code AS Deal_Code FROM Syn_Deal SD 
	INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Dubbing SDRD ON SDR.Syn_Deal_Rights_Code = SDRD.Syn_Deal_Rights_Code 
	AND SDRD.Language_Type = 'G' AND SDRD.Language_Group_Code = @Language_Group_Code
	) AS TMP

	IF @Deal_Count > 0
		SET @ReturnVal = 'Y'
	ELSE
		SET @ReturnVal = 'N'

	--SELECT @ReturnVal

	RETURN @ReturnVal
END

--SELECT [dbo].[UFN_Is_Deal_Added_For_Language_Group](25)