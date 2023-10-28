
CREATE PROCEDURE [dbo].[USPDashboardSummary_PreProcessing] 
AS 
BEGIN

	INSERT INTO RightsUngReportsLog_V18..TraceExtended(TraceId , RequestId , IsLoginSuccessful)
        SELECT t.TraceId, t.RequestId, 1
        FROM RightsUngReportsLog_V18..Trace t
        WHERE t.RequestUri LIKE '%Login/GetLoginDetails%'
        AND t.ResponseContent LIKE '%Login Successful%'
        AND t.TraceId NOT IN(SELECT TraceId FROM RightsUngReportsLog_V18..TraceExtended);

        INSERT INTO RightsUngReportsLog_V18..TraceExtended(TraceId , RequestId , IsLoginSuccessful)
        SELECT t.TraceId, t.RequestId, 0
        FROM RightsUngReportsLog_V18..Trace t
        WHERE t.ResponseContent NOT LIKE '%Login Successful%'
        AND t.TraceId NOT IN(SELECT TraceId FROM RightsUngReportsLog_V18..TraceExtended);

        UPDATE RightsUngReportsLog_V18..Trace SET RequestContent = (REPLACE(RequestContent, ' ', ''))
        WHERE RequestUri LIKE '%Login/GetLoginDetails%'
        AND ResponseContent LIKE '%Login Successful%'
		AND UserId IS NULL;

        UPDATE [RightsUngReportsLog_V18]..Trace SET UserId = (SELECT Users_Code
        FROM [RightsUngReports_V18]..Users
        WHERE Login_Name COLLATE DATABASE_DEFAULT =
        (SELECT SUBSTRING(REPLACE(RequestContent, ' ', ''), (SELECT CHARINDEX('Login_Name', REPLACE(RequestContent, ' ', ''))) + 13, (LEN(REPLACE(RequestContent, ' ', ''))) - 19))
        )
        where RequestUri LIKE '%Login/GetLoginDetails%'
        AND ResponseContent LIKE '%Login Successful%'
        AND UserId IS NULL;

        UPDATE [RightsUngReportsLog_V18]..Trace SET UserId = (SELECT Users_Code
        FROM [RightsUngReports_V18]..Users
        WHERE Login_Name COLLATE DATABASE_DEFAULT =
        (SELECT SUBSTRING(REPLACE(RequestContent, ' ', ''), (SELECT CHARINDEX('Login_Name', REPLACE(RequestContent, ' ', ''))) + 13, (LEN(REPLACE(RequestContent, ' ', ''))) - 17))
        )
        where RequestUri LIKE '%Login/GetLoginDetails%'
        AND ResponseContent LIKE '%Login Successful%'
        AND UserId IS NULL;

        UPDATE [RightsUngReportsLog_V18]..Trace SET RequestMethod = (SELECT SUBSTRING(RequestUri, (SELECT CHARINDEX('/api/', RequestUri)) + 5, (LEN(RequestUri))));
 
END
