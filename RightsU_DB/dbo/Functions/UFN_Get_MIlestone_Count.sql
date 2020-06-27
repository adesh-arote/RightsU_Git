ALTER FUNCTION [dbo].[UFN_Get_MIlestone_Count] 
(
	@ACQ_DEAL_CODE INT
)
RETURNS INT
AS
-- =============================================
-- Author:		Priti D Phand / Abhaysingh N. Rajpurohit
-- Create date: 17 Nov 2014
-- Description:	 Get count of milestones on deal code
-- =============================================
BEGIN

	DECLARE @TotalCount INT = 0
	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal WITH(NOLOCK) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	--- Select Cable Right Data ---
	SELECT  @TotalCount = COUNT(DISTINCT A.Agreement_No) FROM (
		SELECT DISTINCT AD.Agreement_No
		FROM Acq_Deal AD WITH(NOLOCK) 
		INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Platform ADRP WITH(NOLOCK) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
		INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = ADRP.Platform_Code AND ISNULL(P.Is_No_Of_Run, '') = 'Y'
		INNER JOIN Milestone_Type MT WITH(NOLOCK) ON MT.Milestone_Type_Code = ADR.Milestone_Type_Code
		LEFT JOIN Acq_Deal_Run ADRun WITH(NOLOCK) ON ADRun.Acq_Deal_Code = ADR.Acq_Deal_Code
		LEFT JOIN Acq_Deal_Run_Title ADRunT WITH(NOLOCK) ON ADRun.Acq_Deal_Run_Code = ADRunT.Acq_Deal_Run_Code 
			AND ADRT.Title_Code = ADRunT.Title_Code AND ADRT.Episode_From = ADRunT.Episode_From AND ADRT.Episode_To = ADRunT.Episode_To
		WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADR.Right_Type = 'M' AND ADR.Right_Start_Date IS NULL AND ADR.Right_End_Date IS NULL 
		AND AD.Acq_Deal_Code = @Acq_Deal_Code 
		AND ISNULL( MT.Is_Automated,'N') = 'N'
		AND ISNULL(ADRun.No_Of_Runs_Sched, 0) <= 0
		AND AD.Deal_Workflow_Status = 'A'
		UNION
		--- Select Non Cable Right Data ---
		SELECT DISTINCT AD.Agreement_No
		FROM Acq_Deal AD WITH(NOLOCK) 
		INNER JOIN Acq_Deal_Rights ADR WITH(NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
		INNER JOIN Milestone_Type MT WITH(NOLOCK) ON MT.Milestone_Type_Code = ADR.Milestone_Type_Code
		WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADR.Right_Type = 'M' AND ADR.Right_Start_Date IS NULL AND ADR.Right_End_Date IS NULL 
		AND AD.Acq_Deal_Code = @Acq_Deal_Code 
		AND ISNULL( MT.Is_Automated,'N') = 'N'
		AND AD.Deal_Workflow_Status = 'A' 
		AND ADR.Acq_Deal_Rights_Code NOT IN (
			SELECT DISTINCT ADRP.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform ADRP WITH(NOLOCK) WHERE ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			AND ADRP.Platform_Code IN (SELECT DISTINCT P.Platform_Code FROM [Platform] P WITH(NOLOCK) WHERE ISNULL(P.Is_No_Of_Run, '') = 'Y')
		)
	) AS A 
	-- Return the result of the function
	RETURN @TotalCount
END