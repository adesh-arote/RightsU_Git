
CREATE PROCEDURE [dbo].[USPComputeDashboardUserSummaryBiweekly_CurrentBiweek] 
(
	@currentProcessing_Day INT,
	@currentProcessing_Month INT,
	@currentProcessing_Year INT
)
AS 
BEGIN 

        PRINT 'START: PRE PROCESSING'
  	EXEC USPDashboardSummary_PreProcessing;
  	PRINT 'END: PRE PROCESSING'

	DECLARE @currentProcessing_Biweek INT;
	DECLARE @IsEvenBiweek BIT;

	IF(@currentProcessing_Day <= 15)
	BEGIN
		SET @currentProcessing_Biweek = ((@currentProcessing_Month - 1) * 2) + 1;
		SET @IsEvenBiweek = 0;
	END
	ELSE
	BEGIN
		SET @currentProcessing_Biweek = (@currentProcessing_Month * 2);
		SET @IsEvenBiweek = 1;
	END

	IF OBJECT_ID('tempdb..##CurrentBiweekData') IS NOT NULL DROP TABLE ##CurrentBiweekData 

	DECLARE @SQL_CurrentBiweekData NVARCHAR(2000);

	IF(@IsEvenBiweek = 0)
	BEGIN
		SET @SQL_CurrentBiweekData = 
									'
			SELECT	UserId,
			SUM([NumberOfLogins]) NumberOfLogins
			,SUM([NumberOfUniqueLogins]) NumberOfUniqueLogins
			,MAX(LastLoggedInAt) LastLoggedInAt
			,SUM([NumberOfThumbsUp]) NumberOfThumbsUp
			,SUM([NumberOfThumbsDown]) NumberOfThumbsDown
			,SUM([NumberOfFeedbackMessages] ) NumberOfFeedbackMessages
		INTO ##CurrentBiweekData
		FROM Users
		INNER JOIN DashboardUserSummary
		ON Users.Users_Code = DashboardUserSummary.UserId
		WHERE ReportType = ''D''
		AND Year = ' + CAST(@currentProcessing_Year AS VARCHAR) + 
		'AND Month = ' + CAST(@currentProcessing_Month AS VARCHAR) +
		'AND UnitNumber <= 15 
		GROUP BY UserId, ReportType, Year, Month
		ORDER BY UserId ASC;
									';
	END
	ELSE
	BEGIN
		SET @SQL_CurrentBiweekData = '
			SELECT	UserId,
			SUM([NumberOfLogins]) NumberOfLogins
			,SUM([NumberOfUniqueLogins]) NumberOfUniqueLogins
			,MAX(LastLoggedInAt) LastLoggedInAt
			,SUM([NumberOfThumbsUp]) NumberOfThumbsUp
			,SUM([NumberOfThumbsDown]) NumberOfThumbsDown
			,SUM([NumberOfFeedbackMessages] ) NumberOfFeedbackMessages
		INTO ##CurrentBiweekData
		FROM Users
		INNER JOIN DashboardUserSummary
		ON Users.Users_Code = DashboardUserSummary.UserId
		WHERE ReportType = ''D''
		AND Year = ' + CAST(@currentProcessing_Year AS VARCHAR) + 
		'AND Month = ' + CAST(@currentProcessing_Month AS VARCHAR) +
		'AND UnitNumber > 15 
		GROUP BY UserId, ReportType, Year, Month
		ORDER BY UserId ASC;
		';
	END

	exec sp_executesql @SQL_CurrentBiweekData;

	DECLARE @currentUserId INT;
	SELECT @currentUserId = MIN(UserId) from ##CurrentBiweekData

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

		SET @CurrentReportType = 'B';
		SET @CurrentYear = @currentProcessing_Year;
		SET @CurrentMonth = @currentProcessing_Month;
		SET @CurrentUnitNumber = @currentProcessing_Biweek;
		SET @CurrentNumberOfLogins = (SELECT NumberOfLogins FROM ##CurrentBiweekData WHERE UserId = @currentUserId)
		SET @CurrentNumberOfUniqueLogins = (SELECT NumberOfUniqueLogins FROM ##CurrentBiweekData WHERE UserId = @currentUserId)
		SET @CurrentLastLoggedInAt = (SELECT LastLoggedInAt FROM ##CurrentBiweekData WHERE UserId = @currentUserId)
		SET @CurrentNumberOfThumbsUp = (SELECT NumberOfThumbsUp FROM ##CurrentBiweekData WHERE UserId = @currentUserId)
		SET @CurrentNumberOfThumbsDown = (SELECT NumberOfThumbsDown FROM ##CurrentBiweekData WHERE UserId = @currentUserId)
		SET @CurrentNumberOfFeedbackMessages = (SELECT NumberOfFeedbackMessages FROM ##CurrentBiweekData WHERE UserId = @currentUserId)

		IF EXISTS (
					SELECT * FROM DashboardUserSummary 
					WHERE UserId = @currentUserId AND 
					ReportType = @CurrentReportType AND
					Year = @CurrentYear AND
					Month = @CurrentMonth AND
					UnitNumber = @CurrentUnitNumber
					)
		BEGIN
			UPDATE DashboardUserSummary 
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
			INSERT INTO DashboardUserSummary(UserId, ReportType, Year, Month, UnitNumber, NumberOfLogins, NumberOfUniqueLogins, LastLoggedInAt, NumberOfThumbsUp, NumberOfThumbsDown, NumberOfFeedbackMessages)
			VALUES(@currentUserId, @CurrentReportType, @CurrentYear, @CurrentMonth, @CurrentUnitNumber, @CurrentNumberOfLogins, @CurrentNumberOfUniqueLogins, @CurrentLastLoggedInAt, @CurrentNumberOfThumbsUp, @CurrentNumberOfThumbsDown, @CurrentNumberOfFeedbackMessages);
		END
	
		DELETE ##CurrentBiweekData where UserId = @currentUserId
		SELECT @currentUserId = MIN(UserId) from ##CurrentBiweekData

	END

END
