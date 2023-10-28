
CREATE PROCEDURE [dbo].[USPComputeUserActivity]
AS
BEGIN

  DECLARE @ExecutionStartTime DATETIME;
  SET @ExecutionStartTime = GETDATE();
  
  PRINT 'START: Pre Processing' + ((CONVERT( VARCHAR(24), GETDATE(), 121)));
  EXEC USPComputeUserActivity_PreProcessing;
  PRINT 'END: Pre Processing' + ((CONVERT( VARCHAR(24), GETDATE(), 121)));

  PRINT 'START: Processing' + ((CONVERT( VARCHAR(24), GETDATE(), 121)));
  DECLARE @LastAddedResponseDateTime_Trace DATETIME;
  SET @LastAddedResponseDateTime_Trace = (SELECT MAX(ResponseDateTime_IST) from [RightsUngReportsLog_V18]..VWTrace as LastAddedResponseDateTime)
 
  DECLARE @LastComputedAt_DashboardReportParams DATETIME;
  SET @LastComputedAt_DashboardReportParams = (SELECT MAX(LastComputedAtUserActivity) from [RightsUngReports_V18]..DashboardReportParams as LastComputedAt)
 
  DECLARE @StartDate AS DATE
  DECLARE @EndDate AS DATE
  DECLARE @CurrentDate AS DATE

  SET @StartDate = @LastComputedAt_DashboardReportParams
  SET @EndDate = @LastAddedResponseDateTime_Trace

  --#TODO:
  --SET @StartDate = CAST('14 MAY 2020' AS DATE)
  --SET @EndDate = CAST('14 MAY 2020' AS DATE)
 
  SET @CurrentDate = @StartDate
 
  PRINT @CurrentDate;
  PRINT @EndDate;

  --START: @CurrentDate < @EndDate
  WHILE (@CurrentDate <= @EndDate)
  BEGIN

    PRINT @CurrentDate;

DECLARE @currentProcessing_Day INT;
DECLARE @currentProcessing_Month INT;
DECLARE @currentProcessing_Year INT;

SET @currentProcessing_Day = (SELECT DATEPART(day, @CurrentDate));
SET @currentProcessing_Month = (SELECT DATEPART(month, @CurrentDate));
SET @currentProcessing_Year = (SELECT DATEPART(year, @CurrentDate));

--START: Populate Fact_UserActivity for each user for current date
BEGIN
IF OBJECT_ID('tempdb..#DistinctUsersCurrentDateUserActivity') IS NOT NULL DROP TABLE #DistinctUsersCurrentDateUserActivity

DECLARE @currentUserId INT = 0;

--START: LoggedIn users today
BEGIN
SELECT DISTINCT(UserId)
INTO #DistinctUsersCurrentDateUserActivity
FROM [RightsUngReportsLog_V18]..VWTrace AS Trace WITH(NOLOCK)
INNER JOIN [RightsUngReportsLog_V18]..TraceExtended WITH(NOLOCK)
ON Trace.TraceId = TraceExtended.TraceId
  WHERE RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND
TraceExtended.IsLoginSuccessful = 1 AND
  (CAST(RequestDateTime_IST AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
AND UserId > 0
END
--END: LoggedIn users today

SELECT @currentUserId = MIN(UserId) from #DistinctUsersCurrentDateUserActivity

PRINT '@currentUserId';
PRINT @currentUserId;

DECLARE @CurrentDay INT;
DECLARE @CurrentYear INT;
DECLARE @CurrentMonth INT;
DECLARE @CurrentTimeId INT;
DECLARE @CurrentSecurityGroupId INT;
DECLARE @CurrentDepartmentId INT;
DECLARE @CurrentNumberOfLogins INT;
DECLARE @CurrentNumberOfThumbsUp INT;
DECLARE @CurrentNumberOfThumbsDown INT;
DECLARE @CurrentNumberOfFeedbackMessages INT;

WHILE(@currentUserId > 0)
BEGIN
--start: do processing

PRINT '@currentUserId';
PRINT @currentUserId;

SET @CurrentDay = @currentProcessing_Day;
SET @CurrentYear = @currentProcessing_Year;
SET @CurrentMonth = @currentProcessing_Month;
SET @CurrentTimeId = (SELECT TimeId FROM Dim_Time WHERE Day = @CurrentDay AND MonthId = @CurrentMonth AND Year = @CurrentYear);
SET @CurrentSecurityGroupId = (SELECT Security_Group_Code FROM Users WHERE Users_Code = @currentUserId);
SET @CurrentDepartmentId = (SELECT HR_Department_Code FROM Users WHERE Users_Code = @currentUserId);

IF @CurrentDepartmentId IS NULL
BEGIN
	SET @CurrentDepartmentId = 0
END

PRINT '@CurrentDepartmentId';
PRINT @CurrentDepartmentId;

PRINT @CurrentTimeId;

SET @CurrentNumberOfLogins = 0;
SET @CurrentNumberOfLogins = (
SELECT COUNT(UserId) FROM [RightsUngReportsLog_V18]..VWTrace AS Trace WITH(NOLOCK)
INNER JOIN [RightsUngReportsLog_V18]..TraceExtended WITH(NOLOCK)
ON Trace.TraceId = TraceExtended.TraceId
  WHERE RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND
TraceExtended.IsLoginSuccessful = 1 AND
(CAST(RequestDateTime_IST AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
AND UserId = @currentUserId
);

SET @CurrentNumberOfThumbsUp = (
SELECT COUNT(IsSatisfied) from ReportFeedback WITH(NOLOCK)
WHERE IsSatisfied = 'Y' AND
(CAST(RequestTime AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
AND UsersCode = @currentUserId
);

SET @CurrentNumberOfThumbsDown = (
SELECT COUNT(IsSatisfied) from ReportFeedback WITH(NOLOCK)
WHERE IsSatisfied = 'N' AND
(CAST(RequestTime AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
AND UsersCode = @currentUserId
);

SET @CurrentNumberOfFeedbackMessages = (
SELECT COUNT(UserComments) FROM ReportFeedback WITH(NOLOCK)
WHERE UserComments  <> '' AND
(CAST(RequestTime AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
AND UsersCode = @currentUserId
);

IF EXISTS (
SELECT * FROM [RightsUngReports_V18]..Fact_UserActivity
WHERE UserId = @currentUserId AND
TimeId = @CurrentTimeId
)
BEGIN
  UPDATE [RightsUngReports_V18]..Fact_UserActivity
  SET SecurityGroupId = @CurrentSecurityGroupId,
DepartmentId = @CurrentDepartmentId,
SiteVisits = @CurrentNumberOfLogins,
NumberOfThumbsUp = @CurrentNumberOfThumbsUp,
NumberOfThumbsDown = @CurrentNumberOfThumbsDown,
NumberOfFeedbackMessages = @CurrentNumberOfFeedbackMessages
  WHERE UserId = @currentUserId AND
TimeId = @CurrentTimeId
END
ELSE
BEGIN
INSERT INTO [RightsUngReports_V18]..Fact_UserActivity(TimeId, UserId, DepartmentId, SecurityGroupId, SiteVisits, NumberOfThumbsUp, NumberOfThumbsDown, NumberOfFeedbackMessages)
VALUES(@CurrentTimeId, @currentUserId, @CurrentDepartmentId, @CurrentSecurityGroupId, @CurrentNumberOfLogins, @CurrentNumberOfThumbsUp, @CurrentNumberOfThumbsDown, @CurrentNumberOfFeedbackMessages);
END

--end:  do processing

DELETE #DistinctUsersCurrentDateUserActivity where UserId = @currentUserId
SELECT @currentUserId = MIN(UserId) from #DistinctUsersCurrentDateUserActivity
END

END
--END: Populate Fact_UserActivity for each user for current date

SET @CurrentDate = convert(varchar(30), dateadd(day,1, @CurrentDate), 101); /*increment current date*/

  END
  --END: @CurrentDate < @EndDate
  PRINT @EndDate
  --START: after processing is complete from StartDate to EndDate update LastComputedAtUserActivity column in DashboardReportParams table
  --UPDATE [RightsUngReports_V18]..DashboardReportParams SET LastComputedAtUserActivity = @EndDate
  UPDATE [RightsUngReports_V18]..DashboardReportParams SET LastComputedAtUserActivity = (SELECT GETDATE())
  --END: after processing is complete from StartDate to EndDate update LastComputedAtUserActivity column in DashboardReportParams table

PRINT 'END: Processing' + ((CONVERT( VARCHAR(24), GETDATE(), 121)));

DECLARE @ExecutionEndTime DATETIME;
SET @ExecutionEndTime = GETDATE();

UPDATE [RightsUngReports_V18]..DashboardReportParams SET LastComputationTimeInMilliseconds = (SELECT DATEDIFF( millisecond, @ExecutionStartTime, @ExecutionEndTime) AS Milliseconds);
	
END
