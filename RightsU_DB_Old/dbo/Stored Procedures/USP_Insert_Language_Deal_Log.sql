
alter PROCEDURE USP_Insert_Language_Deal_Log
(
	@LanguageGroupCode INT,
	@New_added_Language_Codes VARCHAR(MAX),
	@User_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 15 May 2015
-- Description:	Insert log of Current Languge Group into Language_Deal_Log table
-- =============================================
BEGIN
	INSERT INTO Language_Deal_Log(Affected_Date, Language_Codes, Language_Group_Code, Language_Type, Deal_Type,Deal_Code, Deal_Rights_Code, User_Code)
	SELECT DISTINCT 
	GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'S' AS Language_Type,  'A' AS Deal_Type, 
	AD.Acq_Deal_Code AS Deal_Code, ADR.Acq_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
	FROM Acq_Deal AD 
	INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Subtitling ADRS ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code 
	AND ADRS.Language_Type = 'G' AND ADRS.Language_Group_Code = @LanguageGroupCode
	where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	UNION 
	SELECT DISTINCT 
	GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'D' AS Language_Type,  'A' AS Deal_Type, 
	AD.Acq_Deal_Code AS Deal_Code, ADR.Acq_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
	FROM Acq_Deal AD 
	INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Dubbing ADRD ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code 
	AND ADRD.Language_Type = 'G' AND ADRD.Language_Group_Code = @LanguageGroupCode
	where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	UNION
	SELECT DISTINCT 
	GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'S' AS Language_Type,  'S' AS Deal_Type, 
	SD.Syn_Deal_Code AS Deal_Code, SDR.Syn_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
	FROM Syn_Deal SD 
	INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Subtitling SDRS ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code 
	AND SDRS.Language_Type = 'G' AND SDRS.Language_Group_Code = @LanguageGroupCode
	UNION 
	SELECT DISTINCT 
	GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'D' AS Language_Type,  'S' AS Deal_Type, 
	SD.Syn_Deal_Code AS Deal_Code, SDR.Syn_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
	FROM Syn_Deal SD 
	INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Dubbing SDRD ON SDR.Syn_Deal_Rights_Code = SDRD.Syn_Deal_Rights_Code 
	AND SDRD.Language_Type = 'G' AND SDRD.Language_Group_Code = @LanguageGroupCode
END