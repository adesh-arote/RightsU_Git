CREATE PROCEDURE USPITCuratedNewReportCriteria
@UsersCode INT
AS
BEGIN
IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria

CREATE TABLE #tempCriteria(
	TypeOfDeal NVARCHAR(20),
	[Key] NVARCHAR(100),
	[Value] NVARCHAR(100),
	[CriteriaType] NVARCHAR(10) 
)


	INSERT INTO #tempCriteria
	SELECT * FROM (
		SELECT Distinct 'Acquisition' AS TypeOfDeal,ag.Attrib_Group_Name AS [Key],ag.Attrib_Group_Code AS [Value],'BV' AS CriteriaType
		FROM Users_Detail ud
		INNER JOIN Attrib_Group ag ON ag.Attrib_Group_Code = ud.Attrib_Group_Code AND AG.Attrib_Type = 'BV'
		WHERE ud.Users_Code = @UsersCode
		UNION
		SELECT Distinct 'Acquisition' AS Deal,dt.Deal_Type_Name,BUD.Deal_Type_Code,'DT' FROM Users ud
		INNER JOIN Users_Business_Unit ubu ON ubu.Users_Code = ud.Users_Code
		INNER JOIN Business_Unit_Detail BUD on BUD.Business_Unit_Code = ubu.Business_Unit_Code
		INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = bud.Deal_Type_Code AND dt.Deal_Type_Code IN (Select Distinct Deal_Type_Code From Acq_Deal WHERE Is_Master_Deal = 'Y')
		WHERE ud.Users_Code = @UsersCode
		UNION
		SELECT Distinct 'Syndication' AS Deal,ag.Attrib_Group_Name AS [Key],ag.Attrib_Group_Code AS [Value],'BV' FROM Users_Detail ud
		INNER JOIN Attrib_Group ag ON ag.Attrib_Group_Code = ud.Attrib_Group_Code AND AG.Attrib_Type = 'BV'
		WHERE ud.Users_Code = @UsersCode
		UNION
		SELECT Distinct 'Syndication' AS Deal,dt.Deal_Type_Name,BUD.Deal_Type_Code,'DT' FROM Users ud
		INNER JOIN Users_Business_Unit ubu ON ubu.Users_Code = ud.Users_Code
		INNER JOIN Business_Unit_Detail BUD on BUD.Business_Unit_Code = ubu.Business_Unit_Code
		INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = bud.Deal_Type_Code AND dt.Deal_Type_Code IN (Select Distinct Deal_Type_Code From Syn_Deal)
		WHERE ud.Users_Code = @UsersCode
	) AS A
	ORDER by A.TypeOfDeal,A.CriteriaType

	Select * From #tempCriteria

	IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
END
