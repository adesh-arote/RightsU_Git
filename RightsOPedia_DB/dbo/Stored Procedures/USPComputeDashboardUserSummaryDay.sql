
CREATE PROCEDURE [dbo].[USPComputeDashboardUserSummaryDay] 
AS 
BEGIN 

  PRINT 'START: PRE PROCESSING'
  --EXEC USPDashboardSummary_PreProcessing;
  EXEC USPComputeUserActivity_PreProcessing;
  PRINT 'END: PRE PROCESSING'

  PRINT	'START: STEP 0'
  DECLARE	@LastAddedResponseDateTime_Trace DATETIME;
  SET @LastAddedResponseDateTime_Trace = (SELECT MAX(ResponseDateTime_IST) from [RightsUngReportsLog_V18]..VWTrace as LastAddedResponseDateTime)
  
  DECLARE	@LastComputedAt_DashboardReportParams DATETIME;
  SET @LastComputedAt_DashboardReportParams = (SELECT MAX(LastComputedAtUser) from [RightsUngReports_V18]..DashboardReportParams as LastComputedAt)
  
  IF(@LastAddedResponseDateTime_Trace > @LastComputedAt_DashboardReportParams)
  BEGIN
  PRINT 'START: STEP 1'
  INSERT INTO [RightsUngReports_V18]..DashboardUserInfo(UserId) 
  SELECT DISTINCT(UserId) from [RightsUngReportsLog_V18]..VWTrace AS Trace WHERE UserId NOT IN(SELECT DISTINCT(UserId) from [RightsUngReports_V18]..DashboardUserInfo)
  AND UserId > 0
  PRINT 'END: STEP 1'
  END

  PRINT 'START: STEP 2'

  DECLARE @StartDate AS DATETIME
  DECLARE @EndDate AS DATETIME
  DECLARE @CurrentDate AS DATETIME

  SET @StartDate = @LastComputedAt_DashboardReportParams
  SET @EndDate = @LastAddedResponseDateTime_Trace

  --#TODO:
  --SET @StartDate = CAST('03 FEB 2020' AS DATE)
  --SET @EndDate = CAST('03 FEB 2020' AS DATE)
  
  SET @CurrentDate = @StartDate
  
  DECLARE @previousProcessingMonth INT;
  DECLARE @currentProcessingMonth INT;

  DECLARE @previousDurationStartDate DATE;
  DECLARE @currentDurationStartDate DATE;
  DECLARE @currentDurationEndDate DATE
  
  SET @previousProcessingMonth = (SELECT DATEPART(month, (convert(varchar(30), dateadd(MONTH,-1, @CurrentDate), 101))));
  SET @currentProcessingMonth = (SELECT DATEPART(month, @CurrentDate));
  
  SET @previousDurationStartDate = convert(varchar(30), dateadd(day,-1, ((SELECT StartDate FROM [RightsUngReports_V18]..DurationDefinition WHERE (CAST(@CurrentDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE))))), 101)
  SET @currentDurationStartDate = (SELECT StartDate FROM [RightsUngReports_V18]..DurationDefinition WHERE (CAST(@CurrentDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE)));
  SET @currentDurationEndDate = (SELECT EndDate FROM [RightsUngReports_V18]..DurationDefinition WHERE (CAST(@CurrentDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE)));
  
  --START: @CurrentDate < @EndDate
  WHILE (@CurrentDate <= @EndDate)
  BEGIN

	DECLARE @currentProcessing_Day INT;
	DECLARE @currentProcessing_Month INT;
	DECLARE @currentProcessing_Year INT;
	SET @currentProcessing_Day = (SELECT DATEPART(day, @CurrentDate));
	SET @currentProcessing_Month = (SELECT DATEPART(month, @CurrentDate));
	SET @currentProcessing_Year = (SELECT DATEPART(year, @CurrentDate));

	--START: Populate DashboardUserSummary for each user for current date D
	BEGIN
		IF OBJECT_ID('tempdb..#DistinctUsersCurrentDate') IS NOT NULL DROP TABLE #DistinctUsersCurrentDate 

		DECLARE @currentUserId INT = 0;

		--START: LoggedIn users today
		BEGIN
		SELECT DISTINCT(UserId)
		INTO #DistinctUsersCurrentDate
		FROM [RightsUngReportsLog_V18]..VWTrace AS Trace WITH(NOLOCK) 
		INNER JOIN [RightsUngReportsLog_V18]..TraceExtended WITH(NOLOCK)
		ON Trace.TraceId = TraceExtended.TraceId
  		WHERE RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND 
		--ResponseContent LIKE '%Login Successful%' AND
		TraceExtended.IsLoginSuccessful = 1 AND
  		(CAST(RequestDateTime_IST AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
		AND UserId > 0
		END
		--END: LoggedIn users today

		SELECT @currentUserId = MIN(UserId) from #DistinctUsersCurrentDate

		DECLARE @CurrentReportType VARCHAR(1);
		DECLARE @CurrentYear INT;
		DECLARE @CurrentMonth INT;
		DECLARE @CurrentUnitNumber INT;
		DECLARE @CurrentNumberOfLogins INT;
		DECLARE @CurrentNumberOfUniqueLogins INT;
		DECLARE @CurrentLastLoggedInAt DATETIME;
		DECLARE @CurrentNumberOfThumbsUp INT;
		DECLARE @CurrentNumberOfThumbsDown INT;
		DECLARE @CurrentNumberOfFeedbackMessages INT;

		WHILE(@currentUserId > 0)
		BEGIN
			--start: do processing
			
			SET @CurrentReportType = 'D';
			SET @CurrentYear = @currentProcessing_Year;
			SET @CurrentMonth = @currentProcessing_Month;
			SET @CurrentUnitNumber = @currentProcessing_Day;

			SET @CurrentNumberOfLogins = 0;
			SET @CurrentNumberOfLogins = (
										SELECT COUNT(UserId) FROM [RightsUngReportsLog_V18]..VWTrace AS Trace WITH(NOLOCK)
										INNER JOIN [RightsUngReportsLog_V18]..TraceExtended WITH(NOLOCK)
										ON Trace.TraceId = TraceExtended.TraceId
										WHERE RequestMethod = 'Login/GetLoginDetails' AND IsSuccess = 1 AND ResponseLength > 0 AND 
										--ResponseContent LIKE '%Login Successful%' AND
										TraceExtended.IsLoginSuccessful = 1 AND
										(CAST(RequestDateTime_IST AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
										AND UserId = @currentUserId
										)
			
			IF(@CurrentNumberOfLogins > 0)
			BEGIN
				SET @CurrentNumberOfUniqueLogins = 1;
			END

			SET @CurrentLastLoggedInAt = (
										SELECT MAX(RequestDateTime_IST) FROM [RightsUngReportsLog_V18]..VWTrace AS Trace WITH(NOLOCK)
										INNER JOIN [RightsUngReportsLog_V18]..TraceExtended WITH(NOLOCK)
										ON Trace.TraceId = TraceExtended.TraceId
										WHERE RequestMethod = 'Login/GetLoginDetails' AND IsSuccess = 1 AND ResponseLength > 0 AND 
										--ResponseContent LIKE '%Login Successful%' AND
										TraceExtended.IsLoginSuccessful = 1 AND
										(CAST(RequestDateTime_IST AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
										AND UserId = @currentUserId
										 )
			
			SET @CurrentNumberOfThumbsUp = (
											SELECT COUNT(IsSatisfied) from ReportFeedback WITH(NOLOCK) 
											WHERE IsSatisfied = 'Y' AND
											(CAST(RequestTime AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
											AND UsersCode = @currentUserId
											)

			SET @CurrentNumberOfThumbsDown = (
											SELECT COUNT(IsSatisfied) from ReportFeedback WITH(NOLOCK) 
											WHERE IsSatisfied = 'N' AND
											(CAST(RequestTime AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
											AND UsersCode = @currentUserId
											)

			SET @CurrentNumberOfFeedbackMessages = (
													SELECT COUNT(UserComments) FROM ReportFeedback WITH(NOLOCK) 
													WHERE UserComments  <> '' AND
													(CAST(RequestTime AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
													AND UsersCode = @currentUserId
													)

			IF EXISTS (
						SELECT * FROM [RightsUngReports_V18]..DashboardUserSummary 
						WHERE UserId = @currentUserId AND 
						ReportType = 'D' AND
						Year = @CurrentYear AND
						Month = @CurrentMonth AND
						UnitNumber = @CurrentUnitNumber
						)
			BEGIN
			   UPDATE [RightsUngReports_V18]..DashboardUserSummary 
			   SET	NumberOfLogins = @CurrentNumberOfLogins,
					NumberOfUniqueLogins = @CurrentNumberOfUniqueLogins,
					LastLoggedInAt = @CurrentLastLoggedInAt,
					NumberOfThumbsUp = @CurrentNumberOfThumbsUp,
					NumberOfThumbsDown = @CurrentNumberOfThumbsDown,
					NumberOfFeedbackMessages = @CurrentNumberOfFeedbackMessages
			   WHERE	UserId = @currentUserId AND 
						ReportType = @CurrentReportType AND
						Year = @CurrentYear AND
						Month = @CurrentMonth AND
						UnitNumber = @CurrentUnitNumber
			END
			ELSE
			BEGIN
				INSERT INTO [RightsUngReports_V18]..DashboardUserSummary(UserId, ReportType, Year, Month, UnitNumber, NumberOfLogins, NumberOfUniqueLogins, LastLoggedInAt, NumberOfThumbsUp, NumberOfThumbsDown, NumberOfFeedbackMessages)
				VALUES(@currentUserId, @CurrentReportType, @CurrentYear, @CurrentMonth, @CurrentUnitNumber, @CurrentNumberOfLogins, @CurrentNumberOfUniqueLogins, @CurrentLastLoggedInAt, @CurrentNumberOfThumbsUp, @CurrentNumberOfThumbsDown, @CurrentNumberOfFeedbackMessages);
			END

			--end:  do processing

			DELETE #DistinctUsersCurrentDate where UserId = @currentUserId
			SELECT @currentUserId = MIN(UserId) from #DistinctUsersCurrentDate
		END

	END
	--END: Populate DashboardUserSummary for each user for current date D
	
	SET @CurrentDate = convert(varchar(30), dateadd(day,1, @CurrentDate), 101); /*increment current date*/

  END
  --END: @CurrentDate < @EndDate

  --START: after processing is complete from StartDate to EndDate update LastComputedAtUser column in DashboardReportParams table
  UPDATE [RightsUngReports_V18]..DashboardReportParams SET LastComputedAtUser = @EndDate
  --END: after processing is complete from StartDate to EndDate update LastComputedAtUser column in DashboardReportParams table

  PRINT 'END: STEP 2'

  PRINT 'END: STEP 0'

END
