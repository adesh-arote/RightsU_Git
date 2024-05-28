CREATE PROCEDURE [dbo].[USPITCuratedNewReportCriteria]
@UsersCode INT
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITCuratedNewReportCriteria]', 'Step 1', 0, 'Started Procedure', 0, ''
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
			FROM Users_Detail ud (NOLOCK)
			INNER JOIN Attrib_Group ag (NOLOCK) ON ag.Attrib_Group_Code = ud.Attrib_Group_Code AND AG.Attrib_Type = 'BV'
			WHERE ud.Users_Code = @UsersCode
			UNION
			SELECT Distinct 'Acquisition' AS Deal,dt.Deal_Type_Name,BUD.Deal_Type_Code,'DT' FROM Users ud (NOLOCK)
			INNER JOIN Users_Business_Unit ubu (NOLOCK) ON ubu.Users_Code = ud.Users_Code
			INNER JOIN Business_Unit_Detail BUD (NOLOCK) on BUD.Business_Unit_Code = ubu.Business_Unit_Code
			INNER JOIN Deal_Type dt  (NOLOCK) ON dt.Deal_Type_Code = bud.Deal_Type_Code AND dt.Deal_Type_Code IN (Select Distinct Deal_Type_Code From Acq_Deal (NOLOCK) WHERE Is_Master_Deal = 'Y')
			WHERE ud.Users_Code = @UsersCode
			UNION
			SELECT Distinct 'Syndication' AS Deal,ag.Attrib_Group_Name AS [Key],ag.Attrib_Group_Code AS [Value],'BV' FROM Users_Detail ud (NOLOCK)
			INNER JOIN Attrib_Group ag (NOLOCK) ON ag.Attrib_Group_Code = ud.Attrib_Group_Code AND AG.Attrib_Type = 'BV'
			WHERE ud.Users_Code = @UsersCode
			UNION
			SELECT Distinct 'Syndication' AS Deal,dt.Deal_Type_Name,BUD.Deal_Type_Code,'DT' FROM Users ud (NOLOCK)
			INNER JOIN Users_Business_Unit ubu (NOLOCK) ON ubu.Users_Code = ud.Users_Code
			INNER JOIN Business_Unit_Detail BUD (NOLOCK) on BUD.Business_Unit_Code = ubu.Business_Unit_Code
			INNER JOIN Deal_Type dt (NOLOCK) ON dt.Deal_Type_Code = bud.Deal_Type_Code AND dt.Deal_Type_Code IN (Select Distinct Deal_Type_Code From Syn_Deal (NOLOCK))
			WHERE ud.Users_Code = @UsersCode
		) AS A
		ORDER by A.TypeOfDeal,A.CriteriaType

		Select * From #tempCriteria

		IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITCuratedNewReportCriteria]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
