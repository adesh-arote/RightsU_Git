ALTER PROC USP_ProjectMilestone_Report
(
--DECLARE
	@ProjectMilestoneCodes NVARCHAR(100) = '',
	@MilestoneNatureCode VARCHAR(100) = 0,
	@ExpiryInDay INT = 0
)
AS
BEGIN
	SELECT AgreementNo, CONVERT(VARCHAR(12),AgreementDate,103) AgreementDate, ProjectName, MN.Milestone_Nature_Name, T.Talent_Name, PM.PeriodType, 
		CONVERT(VARCHAR(12),PM.StartDate,103) StartDate, CONVERT(VARCHAR(12), PM.EndDate,103) EndDate,
		CASE PM.PeriodType WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](PM.StartDate, PM.EndDate, PM.Term) 
			WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](PM.Milestone_Type_Code, PM.Milestone_No_Of_Unit, PM.Milestone_Unit_Type)
		End Term,
		CASE WHEN ISNULL(PM.IsTentitive, 'N') = 'Y' THEN 'Yes' ELSE 'No' END Tentitive, 
		CASE WHEN ISNULL(PM.IsClosed, 'N') = 'Y' THEN 'Yes' ELSE 'No' END Closed
	FROM ProjectMilestone PM 
		INNER JOIN Milestone_Nature MN ON PM.MileStone_Nature_Code = MN.MileStone_Nature_Code
		INNER JOIN Talent T ON T.Talent_Code = PM.TalentCode
	WHERE (@ProjectMilestoneCodes = '' OR  PM.ProjectMilestoneCode IN(Select number from fn_Split_withdelemiter(@ProjectMilestoneCodes,',')))
		AND (@MileStoneNatureCode = '' OR PM.MileStone_Nature_Code IN(Select number from fn_Split_withdelemiter(@MileStoneNatureCode,',')))
		AND (@ExpiryInDay = 0 OR DATEDIFF(DAY, GETDATE(), EndDate) = @ExpiryInDay)
END
