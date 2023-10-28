CREATE PROCEDURE [dbo].[USP_Insert_Language_Deal_Log]
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
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Insert_Language_Deal_Log]', 'Step 1', 0, 'Started Procedure', 0, ''
		INSERT INTO Language_Deal_Log(Affected_Date, Language_Codes, Language_Group_Code, Language_Type, Deal_Type,Deal_Code, Deal_Rights_Code, User_Code)
		SELECT DISTINCT 
		GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'S' AS Language_Type,  'A' AS Deal_Type, 
		AD.Acq_Deal_Code AS Deal_Code, ADR.Acq_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
		FROM Acq_Deal AD (NOLOCK)
		INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Subtitling ADRS (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code 
		AND ADRS.Language_Type = 'G' AND ADRS.Language_Group_Code = @LanguageGroupCode
		where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
		UNION 
		SELECT DISTINCT 
		GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'D' AS Language_Type,  'A' AS Deal_Type, 
		AD.Acq_Deal_Code AS Deal_Code, ADR.Acq_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
		FROM Acq_Deal AD (NOLOCK)
		INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Dubbing ADRD (NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code 
		AND ADRD.Language_Type = 'G' AND ADRD.Language_Group_Code = @LanguageGroupCode
		where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
		UNION
		SELECT DISTINCT 
		GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'S' AS Language_Type,  'S' AS Deal_Type, 
		SD.Syn_Deal_Code AS Deal_Code, SDR.Syn_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
		FROM Syn_Deal SD (NOLOCK)
		INNER JOIN Syn_Deal_Rights SDR (NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights_Subtitling SDRS (NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code 
		AND SDRS.Language_Type = 'G' AND SDRS.Language_Group_Code = @LanguageGroupCode
		UNION 
		SELECT DISTINCT 
		GETDATE() AS Affected_Date, @New_added_Language_Codes AS Language_Codes, @LanguageGroupCode AS Language_Group_Code, 'D' AS Language_Type,  'S' AS Deal_Type, 
		SD.Syn_Deal_Code AS Deal_Code, SDR.Syn_Deal_Rights_Code AS Deal_Rights_Code, @User_Code AS User_Code 
		FROM Syn_Deal SD (NOLOCK)
		INNER JOIN Syn_Deal_Rights SDR (NOLOCK) ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
		INNER JOIN Syn_Deal_Rights_Dubbing SDRD (NOLOCK) ON SDR.Syn_Deal_Rights_Code = SDRD.Syn_Deal_Rights_Code 
		AND SDRD.Language_Type = 'G' AND SDRD.Language_Group_Code = @LanguageGroupCode
	 
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Insert_Language_Deal_Log]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END