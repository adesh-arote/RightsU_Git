CREATE PROCEDURE [dbo].[USPGetDepartmentWiseUserActivity]
(
@HRDepartment NVARCHAR(100),
@SecurityGroup NVARCHAR(100),
@RefreshData NVARCHAR(100)
)
AS
  BEGIN

IF @RefreshData = 'Y'
BEGIN
EXEC USPComputeUserActivity
END
 
DECLARE @CurrentDay INT;
DECLARE @CurrentYear INT;
DECLARE @CurrentMonth INT;
DECLARE @CurrentTimeId INT;

SET @CurrentDay = (SELECT DATEPART(day, GETDATE()));
SET @CurrentYear = (SELECT DATEPART(year, GETDATE()));
SET @CurrentMonth = (SELECT DATEPART(month, GETDATE()));

SET @CurrentTimeId = (SELECT TimeId FROM Dim_Time WHERE Day = @CurrentDay AND MonthId = @CurrentMonth AND Year = @CurrentYear);

PRINT @CurrentTimeId;

DECLARE @IgnoredSecurityGrp NVARCHAR(MAX)
DECLARE @ConsideredSecurityGrp NVARCHAR(MAX)

SET @IgnoredSecurityGrp = (Select Parameter_Value FROM SystemParameterNew where Parameter_Name = 'IgnoreSecurityGroups_IT')
SET @ConsideredSecurityGrp = (Select Parameter_Value FROM SystemParameterNew where Parameter_Name = 'ConsiderSecurityGroups_IT')

DECLARE @VisitsSinceLaunch_TableVariable TABLE (
    HRDepartment VARCHAR(100) NOT NULL,
    VisitsSinceLaunch INT NOT NULL DEFAULT(0)
);

DECLARE @VisitsinLast7Days_TableVariable TABLE (
    HRDepartment VARCHAR(100) NOT NULL,
    VisitsInLast7Days INT NOT NULL DEFAULT(0)
);

DECLARE @VisitsInLast24Hours_TableVariable TABLE (
    HRDepartment VARCHAR(100) NOT NULL,
    VisitsInLast24Hours INT NOT NULL DEFAULT(0)
);

IF @HRDepartment = 'Y'
BEGIN

--START: HR Department

DELETE FROM @VisitsSinceLaunch_TableVariable;
DELETE FROM @VisitsinLast7Days_TableVariable;
DELETE FROM @VisitsInLast24Hours_TableVariable;

INSERT INTO @VisitsSinceLaunch_TableVariable
SELECT HR_Department_Name HRDepartment, SUM(SiteVisits) VisitsSinceLaunch
FROM Fact_UserActivity
INNER JOIN HRDepartment
ON HRDepartment.HR_Department_Code = Fact_UserActivity.DepartmentId
WHERE HR_Department_Name <> 'NA'
AND Fact_UserActivity.DepartmentId > 0
AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
GROUP BY HR_Department_Name
ORDER BY SUM(SiteVisits) DESC;

INSERT INTO @VisitsinLast7Days_TableVariable
SELECT HR_Department_Name HRDepartment, SUM(SiteVisits) VisitsInLast7Days
FROM Fact_UserActivity
INNER JOIN HRDepartment
ON HRDepartment.HR_Department_Code = Fact_UserActivity.DepartmentId
WHERE HR_Department_Name <> 'NA'
AND Fact_UserActivity.DepartmentId > 0
AND TimeId <= @CurrentTimeId - 1 AND TimeId >= @CurrentTimeId - 7
AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
GROUP BY HR_Department_Name
ORDER BY SUM(SiteVisits) DESC;

INSERT INTO @VisitsInLast24Hours_TableVariable
SELECT HR_Department_Name HRDepartment, SUM(SiteVisits) VisitsInLast24Hours
FROM Fact_UserActivity
INNER JOIN HRDepartment
ON HRDepartment.HR_Department_Code = Fact_UserActivity.DepartmentId
WHERE HR_Department_Name <> 'NA'
AND TimeId = @CurrentTimeId
AND Fact_UserActivity.DepartmentId > 0
AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT NOT IN (select number from dbo.fn_Split_withdelemiter(''+@IgnoredSecurityGrp+'',',')))
GROUP BY HR_Department_Name
ORDER BY SUM(SiteVisits) DESC;

SELECT T1.HRDepartment DepartmentName, ISNULL(VisitsInLast24Hours,0) VisitsInLast24Hours, ISNULL(VisitsInLast7Days,0) VisitsInLast7Days, ISNULL(VisitsSinceLaunch,0) VisitsSinceLaunch
FROM @VisitsSinceLaunch_TableVariable T1
LEFT JOIN @VisitsInLast24Hours_TableVariable T2
ON T1.HRDepartment = T2.HRDepartment
LEFT JOIN @VisitsinLast7Days_TableVariable T3
ON T1.HRDepartment = T3.HRDepartment
ORDER BY VisitsSinceLaunch DESC;

--END: HR Department

END

IF @SecurityGroup = 'Y'
BEGIN

--START: Security Group UI Department

DELETE FROM @VisitsSinceLaunch_TableVariable;
DELETE FROM @VisitsinLast7Days_TableVariable;
DELETE FROM @VisitsInLast24Hours_TableVariable;

INSERT INTO @VisitsSinceLaunch_TableVariable
SELECT Security_Group_Name HRDepartment, SUM(SiteVisits) VisitsSinceLaunch
FROM Fact_UserActivity
INNER JOIN SecurityGroup
ON SecurityGroup.Security_Group_Code = Fact_UserActivity.SecurityGroupId
WHERE Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT  IN (select number from dbo.fn_Split_withdelemiter(''+@ConsideredSecurityGrp+'',',')))
GROUP BY Security_Group_Name
ORDER BY SUM(SiteVisits) DESC;

INSERT INTO @VisitsinLast7Days_TableVariable
SELECT Security_Group_Name HRDepartment, SUM(SiteVisits) VisitsInLast7Days
FROM Fact_UserActivity
INNER JOIN SecurityGroup
ON SecurityGroup.Security_Group_Code = Fact_UserActivity.SecurityGroupId
WHERE TimeId <= @CurrentTimeId - 1 AND TimeId >= @CurrentTimeId - 7
AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT  IN (select number from dbo.fn_Split_withdelemiter(''+@ConsideredSecurityGrp+'',',')))
GROUP BY Security_Group_Name
ORDER BY SUM(SiteVisits) DESC;

INSERT INTO @VisitsInLast24Hours_TableVariable
SELECT Security_Group_Name HRDepartment, SUM(SiteVisits) VisitsInLast24Hours
FROM Fact_UserActivity
INNER JOIN SecurityGroup
ON SecurityGroup.Security_Group_Code = Fact_UserActivity.SecurityGroupId
WHERE TimeId = @CurrentTimeId
AND Fact_UserActivity.SecurityGroupId IN(Select Security_Group_Code FROM SecurityGroup where Security_Group_Name COLLATE DATABASE_DEFAULT  IN (select number from dbo.fn_Split_withdelemiter(''+@ConsideredSecurityGrp+'',',')))
GROUP BY Security_Group_Name
ORDER BY SUM(SiteVisits) DESC;

SELECT T1.HRDepartment DepartmentName, ISNULL(VisitsInLast24Hours,0) VisitsInLast24Hours, ISNULL(VisitsInLast7Days,0) VisitsInLast7Days, ISNULL(VisitsSinceLaunch,0) VisitsSinceLaunch
FROM @VisitsSinceLaunch_TableVariable T1
LEFT JOIN @VisitsInLast24Hours_TableVariable T2
ON T1.HRDepartment = T2.HRDepartment
LEFT JOIN @VisitsinLast7Days_TableVariable T3
ON T1.HRDepartment = T3.HRDepartment
ORDER BY VisitsSinceLaunch DESC;

--END: Security Group UI Department

END



END
