ALTER PROCEDURE [dbo].[USP_Add_ACQ_Milestone]
(
	@Acq_Deal_Code Int, 
	@IsDebug CHAR(1)
)
AS
 --=============================================
 --Author:		Priti Phand / Abhaysingh N. Rajpurohit
 --Create DATE: 11 November 2014
 --Description:	Get Title name, Milestone name from combination of Rights and milestone 
 --=============================================
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	--- Select Cable Right Data ---
	SELECT DISTINCT AD.Agreement_No, 
	DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADRT.Episode_From, ADRT.Episode_To) AS Title_Name,
	T.Title_Code, MT.Milestone_Type_Name, ADR.Acq_Deal_Rights_Code, ADR.Milestone_No_Of_Unit, ADR.Milestone_Unit_Type, 
	ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
	dbo.UFN_Get_Syn_Rights_Mapping_Min_Date(@Acq_Deal_Code,ADR.Acq_Deal_Rights_Code) AS Syn_Rights_Min_Start_Date
	FROM Acq_Deal AD
	INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
	INNER JOIN [Platform] P ON P.Platform_Code = ADRP.Platform_Code AND ISNULL(P.Is_No_Of_Run, '') = 'Y'
	INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
	INNER JOIN Milestone_Type MT ON MT.Milestone_Type_Code = ADR.Milestone_Type_Code
	LEFT JOIN Acq_Deal_Run ADRun ON ADRun.Acq_Deal_Code = ADR.Acq_Deal_Code
	LEFT JOIN Acq_Deal_Run_Title ADRunT ON ADRun.Acq_Deal_Run_Code = ADRunT.Acq_Deal_Run_Code 
		AND ADRT.Title_Code = ADRunT.Title_Code AND ADRT.Episode_From = ADRunT.Episode_From AND ADRT.Episode_To = ADRunT.Episode_To
	WHERE 
	AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
	ADR.Right_Type = 'M' AND ADR.Right_Start_Date IS NULL AND ADR.Right_End_Date IS NULL 
	AND AD.Acq_Deal_Code = @Acq_Deal_Code 
	AND ISNULL( MT.Is_Automated,'N') = 'N'
	AND ISNULL(ADRun.No_Of_Runs_Sched, 0) <= 0
	AND AD.Deal_Workflow_Status = 'A'
	UNION
	--- Select Non Cable Right Data ---
	SELECT DISTINCT AD.Agreement_No, 
	DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADRT.Episode_From, ADRT.Episode_To) AS Title_Name,
	T.Title_Code, MT.Milestone_Type_Name, ADR.Acq_Deal_Rights_Code, ADR.Milestone_No_Of_Unit, ADR.Milestone_Unit_Type, 
	ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
	dbo.UFN_Get_Syn_Rights_Mapping_Min_Date(@Acq_Deal_Code,ADR.Acq_Deal_Rights_Code) AS Syn_Rights_Min_Start_Date
	FROM Acq_Deal AD
	INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
	INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
	INNER JOIN Milestone_Type MT ON MT.Milestone_Type_Code = ADR.Milestone_Type_Code
	WHERE
	AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
	ADR.Right_Type = 'M' AND ADR.Right_Start_Date IS NULL AND ADR.Right_End_Date IS NULL 
	AND AD.Acq_Deal_Code = @Acq_Deal_Code 
	AND ISNULL( MT.Is_Automated,'N') = 'N'
	AND AD.Deal_Workflow_Status = 'A' 
	AND ADR.Acq_Deal_Rights_Code NOT IN (
		SELECT DISTINCT ADRP.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform ADRP WHERE ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
		AND ADRP.Platform_Code IN (SELECT DISTINCT P.Platform_Code FROM [Platform] P WHERE ISNULL(P.Is_No_Of_Run, '') = 'Y')
	)
END