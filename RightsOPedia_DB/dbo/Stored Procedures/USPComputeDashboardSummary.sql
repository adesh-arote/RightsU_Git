
CREATE PROCEDURE [dbo].[USPComputeDashboardSummary] 
AS 
BEGIN 

  PRINT 'START: PRE PROCESSING'
  EXEC USPDashboardSummary_PreProcessing;
  PRINT 'END: PRE PROCESSING'

  PRINT	'START: STEP 0'
  DECLARE	@LastAddedResponseDateTime_Trace DATETIME;
  SET @LastAddedResponseDateTime_Trace = (SELECT MAX(ResponseDateTime_IST) from [RightsUngReportsLog_V18]..VWTrace as LastAddedResponseDateTime)
  
  DECLARE	@LastComputedAt_DashboardReportParams DATETIME;
  SET @LastComputedAt_DashboardReportParams = (SELECT MAX(LastComputedAt) from [RightsUngReports_V18]..DashboardReportParams as LastComputedAt)
  
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

	--START: RESET if MonthBoundary changes
	BEGIN
	--PRINT 'RESET if MonthBoundary changes';
	--PRINT @previousProcessingMonth;
	--PRINT @currentProcessingMonth;
		SET @currentProcessingMonth = (SELECT DATEPART(month, @CurrentDate));
	
		IF(@previousProcessingMonth <> @currentProcessingMonth)
		BEGIN
			UPDATE [RightsUngReports_V18]..DashboardUserInfo SET UniqueForMonth = 0
		END

		SET @previousProcessingMonth = (SELECT DATEPART(month, @CurrentDate));
	END
	--END: RESET if MonthBoundary changes

	--START: RESET if DurationBoundary changes
	BEGIN
	--PRINT 'RESET if DurationBoundary changes';
	--PRINT @previousDurationStartDate;
	--PRINT @currentDurationStartDate;
		SET @currentDurationStartDate = (SELECT StartDate FROM [RightsUngReports_V18]..DurationDefinition WHERE (CAST(@CurrentDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE)));
		
		IF(@previousDurationStartDate <> @currentDurationStartDate)
		BEGIN
			UPDATE [RightsUngReports_V18]..DashboardUserInfo SET UniqueForDuration = 0
		END

		SET @previousDurationStartDate = (SELECT StartDate FROM [RightsUngReports_V18]..DurationDefinition WHERE (CAST(@CurrentDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE)));
	END
	--END: RESET if DurationBoundary changes

	--START: Populate DashboardUserInfo for each user for current date
	BEGIN
		IF OBJECT_ID('tempdb..#DistinctUsersCurrentDate') IS NOT NULL DROP TABLE #DistinctUsersCurrentDate 

		DECLARE @currentUserId INT = 0;
		DECLARE @currentFirstLoggedInAt DATETIME;
		DECLARE @currentFirstLoggedInAtDept DATETIME;
		DECLARE @currentUniqueForMonth int;

		--START: LoggedIn users today
		BEGIN
		SELECT DISTINCT(UserId)
		INTO #DistinctUsersCurrentDate
		FROM [RightsUngReportsLog_V18]..VWTrace AS Trace WITH(NOLOCK) 
		INNER JOIN Users
		ON Users.Users_Code = Trace.UserId
		INNER JOIN SecurityGroup
		ON SecurityGroup.Security_Group_Code = Users.Security_Group_Code
		INNER JOIN [RightsUngReportsLog_V18]..TraceExtended WITH(NOLOCK) 
		ON Trace.TraceId = TraceExtended.TraceId
  		WHERE RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND 
		--ResponseContent LIKE '%Login Successful%' AND
		TraceExtended.IsLoginSuccessful = 1 AND
  		(CAST(RequestDateTime_IST AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
		AND UserId > 0
		AND Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
		END
		--END: LoggedIn users today

		SELECT @currentUserId = MIN(UserId) from #DistinctUsersCurrentDate

		--PRINT '@currentUserId';
		--PRINT @currentUserId;

		WHILE(@currentUserId > 0)
		BEGIN
			--start: do processing
			--PRINT 'Populate DashboardUserInfo for each user for current date';
			--PRINT @currentUserId;
			--BEGIN: Find all departments that user is in
			BEGIN
			IF OBJECT_ID('tempdb..#DistinctDepartmentsForCurrentUser') IS NOT NULL DROP TABLE #DistinctDepartmentsForCurrentUser 
		
			SELECT Attrib_Group_Code 
			INTO #DistinctDepartmentsForCurrentUser
			FROM UsersDetail 
			WHERE Users_Code = @currentUserId AND Attrib_Type = 'DP'
			END
			--END: Find all departments that user is in

			DECLARE @currentDepartmentId INT = 0;
			SELECT @currentDepartmentId = MIN(Attrib_Group_Code) from #DistinctDepartmentsForCurrentUser

			WHILE(@currentDepartmentId > 0)
			BEGIN
			--PRINT @currentDepartmentId;
				SET @currentFirstLoggedInAtDept = (
												SELECT FirstLoggedInAt 
												FROM [RightsUngReports_V18]..DashboardUserInfo 
												WHERE UserId = @currentUserId AND
												DepartmentId = @currentDepartmentId);

				IF(@currentFirstLoggedInAtDept IS NULL)
				BEGIN
					IF EXISTS (SELECT * FROM [RightsUngReports_V18]..DashboardUserInfo WHERE UserId = @currentUserId AND DepartmentId = @currentDepartmentId) 
					BEGIN
						   UPDATE [RightsUngReports_V18]..DashboardUserInfo SET	UniqueForMonth = 1, 
														FirstLoggedInAt = @CurrentDate, 
														LastLoggedInAt = @CurrentDate,
														UniqueForDuration = 1,
														UniqueForAllTime = 1
							WHERE UserId = @currentUserId AND DepartmentId = @currentDepartmentId
					END
					ELSE
					BEGIN
						INSERT INTO [RightsUngReports_V18]..DashboardUserInfo(UserId, UniqueForMonth, FirstLoggedInAt, LastLoggedInAt, UniqueForDuration, DepartmentId, UniqueForAllTime)
						VALUES(@currentUserId, 1, @CurrentDate, @CurrentDate, 1, @currentDepartmentId, 1);
					END
				END
				ELSE
				BEGIN
					IF EXISTS (SELECT * FROM [RightsUngReports_V18]..DashboardUserInfo WHERE UserId = @currentUserId AND DepartmentId = @currentDepartmentId) 
					BEGIN
						   UPDATE [RightsUngReports_V18]..DashboardUserInfo SET	UniqueForMonth = 1, 
														LastLoggedInAt = @CurrentDate,
														UniqueForDuration = 1,
														UniqueForAllTime = 1
							WHERE UserId = @currentUserId AND DepartmentId = @currentDepartmentId
					END
				END

				DELETE #DistinctDepartmentsForCurrentUser where Attrib_Group_Code = @currentDepartmentId
				SELECT @currentDepartmentId = MIN(Attrib_Group_Code) from #DistinctDepartmentsForCurrentUser

			END
		
			--START: processing for all departments
			BEGIN
			SET @currentFirstLoggedInAt = (
												SELECT FirstLoggedInAt 
												FROM [RightsUngReports_V18]..DashboardUserInfo 
												WHERE UserId = @currentUserId AND
												DepartmentId = 0);

			IF(@currentFirstLoggedInAt IS NULL)
			BEGIN
					IF EXISTS (SELECT * FROM [RightsUngReports_V18]..DashboardUserInfo WHERE UserId = @currentUserId AND DepartmentId = 0) 
					BEGIN
							UPDATE [RightsUngReports_V18]..DashboardUserInfo SET	UniqueForMonth = 1, 
															FirstLoggedInAt = @CurrentDate, 
															LastLoggedInAt = @CurrentDate,
															UniqueForDuration = 1,
															UniqueForAllTime = 1
							WHERE UserId = @currentUserId AND DepartmentId = 0
					END
					ELSE
					BEGIN
						INSERT INTO [RightsUngReports_V18]..DashboardUserInfo(UserId, UniqueForMonth, FirstLoggedInAt, LastLoggedInAt, UniqueForDuration, DepartmentId, UniqueForAllTime)
						VALUES(@currentUserId, 1, @CurrentDate, @CurrentDate, 1, 0, 1);
					END
			END
			ELSE
			BEGIN
					IF EXISTS (SELECT * FROM [RightsUngReports_V18]..DashboardUserInfo WHERE UserId = @currentUserId AND DepartmentId = 0) 
					BEGIN
						   UPDATE [RightsUngReports_V18]..DashboardUserInfo SET	UniqueForMonth = 1, 
														LastLoggedInAt = @CurrentDate,
														UniqueForDuration = 1,
														UniqueForAllTime = 1
							WHERE UserId = @currentUserId AND DepartmentId = 0
					END
			END
			END
			--END: processing for all departments 
		
			--end:  do processing

			DELETE #DistinctUsersCurrentDate where UserId = @currentUserId
			SELECT @currentUserId = MIN(UserId) from #DistinctUsersCurrentDate
		END

	END
	--END: Populate DashboardUserInfo for each user for current date
	
	--START: Period 'B' 'A' DepartmentId Unique
	BEGIN
		IF OBJECT_ID('tempdb..#DistinctAttribGroupCodeList') IS NOT NULL DROP TABLE #DistinctAttribGroupCodeList 

		DECLARE @CurrentNumberOfVisits INT;
		DECLARE @CurrentNumberOfNewVisits INT;
		DECLARE @CurrentNumberOfUniqueVisitsMonthWise INT; 
		DECLARE @CurrentNumberOfUniqueVisitsDurationWise INT; 
		DECLARE @CurrentNumberOfUniqueVisitsSinceLaunch INT; 
	
		select DISTINCT(Attrib_Group_Code) 
		INTO #DistinctAttribGroupCodeList
		FROM Attrib_Group
		WHERE Attrib_Type = 'DP'

		DECLARE @currentAttribGroupCode INT;
		SET @currentAttribGroupCode = (SELECT MIN(Attrib_Group_Code) from #DistinctAttribGroupCodeList)

		WHILE(@currentAttribGroupCode > 0)
		BEGIN
		
			--start: do processing
			--department wise
			SET @CurrentNumberOfUniqueVisitsDurationWise = (
												SELECT COUNT(UserId) FROM [RightsUngReports_V18]..DashboardUserInfo WITH(NOLOCK) 
												WHERE UniqueForDuration = 1 AND
												DepartmentId = @currentAttribGroupCode
												)

			--department wise
			SET @CurrentNumberOfUniqueVisitsSinceLaunch = (
												SELECT COUNT(UserId) FROM [RightsUngReports_V18]..DashboardUserInfo WITH(NOLOCK) 
												WHERE UniqueForAllTime = 1 AND
												DepartmentId = @currentAttribGroupCode
												)

			DECLARE @SetDateOfDuration INT;
			IF(@currentProcessing_Day <= 15)
			BEGIN
				SET @SetDateOfDuration = 1;
			END
			ELSE
			BEGIN
				SET @SetDateOfDuration = 16;
			END
		
			DECLARE @SetDateOfLauch DATE;
			SET @SetDateOfLauch = CAST('01-01-2019' AS DATE)

			IF EXISTS (
						SELECT * FROM [RightsUngReports_V18]..DashboardSummary 
						WHERE Period = 'B' AND 
						DepartmentId = @currentAttribGroupCode AND
						DAY(ReportDate) = @SetDateOfDuration AND
						MONTH(ReportDate) = @currentProcessing_Month AND 
						YEAR(ReportDate) = @currentProcessing_Year
						)
			BEGIN
			   UPDATE [RightsUngReports_V18]..DashboardSummary SET NumberOfUniqueVisits = @CurrentNumberOfUniqueVisitsDurationWise
			   WHERE Period = 'B' AND 
						DepartmentId = @currentAttribGroupCode AND
						DAY(ReportDate) = @SetDateOfDuration AND
						MONTH(ReportDate) = @currentProcessing_Month AND 
						YEAR(ReportDate) = @currentProcessing_Year
			END
			ELSE
			BEGIN
				INSERT INTO [RightsUngReports_V18]..DashboardSummary(Period, ReportDate, DepartmentId, NumberOfVisits, NumberOfUniqueVisits, NumberOfNewVisits)
				VALUES('B', CAST(RTRIM(@currentProcessing_Year * 10000 + '-' + @currentProcessing_Month * 100 + '-' + @SetDateOfDuration) AS DATE), @currentAttribGroupCode, 0, @CurrentNumberOfUniqueVisitsDurationWise, 0);
				--CAST((@currentProcessing_Month + '-' + @SetDateOfDuration + '-' + @currentProcessing_Year) AS DATE)
				--CAST(RTRIM(@YEAR * 10000 + @MONTH * 100 + @DAY) AS DATETIME)
			END

			IF EXISTS (
						SELECT * FROM [RightsUngReports_V18]..DashboardSummary 
						WHERE Period = 'A' AND 
						DepartmentId = @currentAttribGroupCode AND
						DAY(ReportDate) = (SELECT DATEPART(DAY, @SetDateOfLauch)) AND
						MONTH(ReportDate) = (SELECT DATEPART(MONTH, @SetDateOfLauch)) AND 
						YEAR(ReportDate) = (SELECT DATEPART(YEAR, @SetDateOfLauch))
						)
			BEGIN
			   UPDATE [RightsUngReports_V18]..DashboardSummary SET NumberOfUniqueVisits = @CurrentNumberOfUniqueVisitsSinceLaunch
			   WHERE Period = 'A' AND 
						DepartmentId = @currentAttribGroupCode AND
						DAY(ReportDate) = (SELECT DATEPART(DAY, @SetDateOfLauch)) AND
						MONTH(ReportDate) = (SELECT DATEPART(MONTH, @SetDateOfLauch)) AND 
						YEAR(ReportDate) = (SELECT DATEPART(YEAR, @SetDateOfLauch))
			END
			ELSE
			BEGIN
				INSERT INTO [RightsUngReports_V18]..DashboardSummary(Period, ReportDate, DepartmentId, NumberOfVisits, NumberOfUniqueVisits, NumberOfNewVisits)
				VALUES('A', @SetDateOfLauch, @currentAttribGroupCode, 0, @CurrentNumberOfUniqueVisitsSinceLaunch, 0);
			END
			--end:  do processing

			--start: remove that id from temp table
			DELETE #DistinctAttribGroupCodeList where Attrib_Group_Code = @currentAttribGroupCode
			--end: remove that id from temp table

			SELECT @currentAttribGroupCode = MIN(Attrib_Group_Code) from #DistinctAttribGroupCodeList
		END
	END
	--END: Period 'B' 'A' DepartmentId Unique
	
	--START: Period 'M' DepartmentId 0 All Unique
	BEGIN
		SET @CurrentNumberOfUniqueVisitsMonthWise =	(
												SELECT COUNT(UserId) FROM [RightsUngReports_V18]..DashboardUserInfo WITH(NOLOCK) 
												WHERE UniqueForMonth = 1 AND
												DepartmentId = 0
												)
	
		IF EXISTS (
							SELECT * FROM [RightsUngReports_V18]..DashboardSummary WHERE Period = 'M' AND 
							DAY(ReportDate) = 1 AND
							MONTH(ReportDate) = @currentProcessing_Month AND 
							YEAR(ReportDate) = @currentProcessing_Year AND 
							DepartmentId = 0
							)
		BEGIN
			UPDATE [RightsUngReports_V18]..DashboardSummary SET NumberOfUniqueVisits = @CurrentNumberOfUniqueVisitsMonthWise
			WHERE Period = 'M' AND 
					DAY(ReportDate) = 1 AND
					MONTH(ReportDate) = @currentProcessing_Month AND 
					YEAR(ReportDate) = @currentProcessing_Year AND 
					DepartmentId = 0
		END
		ELSE
		BEGIN
			INSERT INTO [RightsUngReports_V18]..DashboardSummary(Period, ReportDate, DepartmentId, NumberOfVisits, NumberOfUniqueVisits, NumberOfNewVisits)
			VALUES('M', CAST(RTRIM(@currentProcessing_Year * 10000 + '-' + @currentProcessing_Month * 100 + '-' + 1) AS DATE), 0, 0, @CurrentNumberOfUniqueVisitsMonthWise, 0);
		END
	END
	--END: Period 'M' DepartmentId 0 All Unique

	--START: Period 'D' DepartmentId 0 All
	BEGIN
	--PRINT '@CurrentDate';
	--PRINT @CurrentDate;
		SET @CurrentNumberOfVisits = (
										SELECT COUNT(UserId) FROM [RightsUngReportsLog_V18]..VWTrace AS Trace WITH(NOLOCK)
										INNER JOIN Users
										ON Users.Users_Code = Trace.UserId
										INNER JOIN SecurityGroup
										ON SecurityGroup.Security_Group_Code = Users.Security_Group_Code
										INNER JOIN [RightsUngReportsLog_V18]..TraceExtended WITH(NOLOCK)
										ON Trace.TraceId = TraceExtended.TraceId
										WHERE RequestMethod = 'Login/GetLoginDetails' AND IsSuccess = 1 AND ResponseLength > 0 AND 
										--ResponseContent LIKE '%Login Successful%' AND
										TraceExtended.IsLoginSuccessful = 1 AND
										Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
										AND (CAST(RequestDateTime_IST AS DATE) BETWEEN CAST(@CurrentDate AS DATE) AND CAST(@CurrentDate AS DATE))
										)
		--PRINT '@CurrentNumberOfVisits';
		--PRINT @CurrentNumberOfVisits;
		SET @CurrentNumberOfNewVisits = (
										SELECT COUNT(DISTINCT UserId) FROM [RightsUngReports_V18]..DashboardUserInfo WITH(NOLOCK) 
										--INNER JOIN UsersDetail
										--ON DashboardUserInfo.UserId = UsersDetail.Users_Code
										--WHERE Attrib_Group_Code = @currentAttribGroupCode AND
										WHERE CAST(FirstLoggedInAt AS DATE) = CAST(@CurrentDate AS DATE)
										)
		--PRINT '@CurrentNumberOfNewVisits';
		--PRINT @CurrentNumberOfNewVisits;					
		IF EXISTS (
						SELECT * FROM [RightsUngReports_V18]..DashboardSummary WHERE Period = 'D' AND 
						DAY(ReportDate) = @currentProcessing_Day AND
						MONTH(ReportDate) = @currentProcessing_Month AND 
						YEAR(ReportDate) = @currentProcessing_Year AND 
						DepartmentId = 0
						)
		BEGIN
		--PRINT 'UPDATE';
			UPDATE [RightsUngReports_V18]..DashboardSummary SET NumberOfVisits = @CurrentNumberOfVisits, 
			NumberOfNewVisits = @CurrentNumberOfNewVisits
			WHERE Period = 'D' AND 
					DAY(ReportDate) = @currentProcessing_Day AND
					MONTH(ReportDate) = @currentProcessing_Month AND 
					YEAR(ReportDate) = @currentProcessing_Year AND 
					DepartmentId = 0
		END
		ELSE
		BEGIN
		--PRINT 'INSERT';
			INSERT INTO [RightsUngReports_V18]..DashboardSummary(Period, ReportDate, DepartmentId, NumberOfVisits, NumberOfUniqueVisits, NumberOfNewVisits)
			VALUES('D', CAST(@CurrentDate AS DATE), 0, @CurrentNumberOfVisits, 0, @CurrentNumberOfNewVisits);
		END
	END
	--END: Period 'D' DepartmentId 0 All

	SET @CurrentDate = convert(varchar(30), dateadd(day,1, @CurrentDate), 101); /*increment current date*/

  END
  --END: @CurrentDate < @EndDate

  --START: after processing is complete from StartDate to EndDate update LastComputedAt column in DashboardReportParams table
  UPDATE [RightsUngReports_V18]..DashboardReportParams SET LastComputedAt = @EndDate
  --END: after processing is complete from StartDate to EndDate update LastComputedAt column in DashboardReportParams table

  PRINT 'END: STEP 2'

  PRINT 'END: STEP 0'

END
