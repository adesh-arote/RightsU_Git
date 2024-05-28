CREATE PROCEDURE [dbo].[USPComputeUserActivity_PreProcessing]
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
        AND ResponseContent LIKE '%Login Successful%';

        BEGIN

        IF OBJECT_ID('tempdb..#DistinctTraceId') IS NOT NULL DROP TABLE #DistinctTraceId
        
        DECLARE @currentTraceId INT = 0;
        
        SELECT TraceId
        INTO #DistinctTraceId
        FROM [RightsUngReportsLog_V18]..Trace WITH(NOLOCK)
         WHERE RequestMethod = 'Login/GetLoginDetails' AND ResponseLength > 0 AND
        ResponseContent LIKE '%Login Successful%'
        AND (UserId IS NULL OR UserId = 0);
        
        SELECT @currentTraceId = MIN(TraceId) from #DistinctTraceId
        
        WHILE(@currentTraceId > 0)
        BEGIN
        --start: do processing
        DECLARE @Login_Name_Custom VARCHAR(200);
        SET @Login_Name_Custom = (Select StringValue from parseJSON((select RequestContent from [RightsUngReportsLog_V18]..Trace
        WHERE TraceId = @currentTraceId)) where Name = 'Login_Name');
        
        UPDATE [RightsUngReportsLog_V18]..Trace SET UserId = (SELECT Users_Code
        FROM Users
        WHERE Login_Name = @Login_Name_Custom)
        where TraceId = @currentTraceId;
        
        --end:  do processing
        
        DELETE FROM #DistinctTraceId where TraceId = @currentTraceId
        SELECT @currentTraceId = MIN(TraceId) from #DistinctTraceId
        END
        
        END

        --UPDATE [RightsUngReportsLog_V18]..Trace SET UserId = (SELECT Users_Code
        --FROM [RightsUngReports_Temp]..Users
        --WHERE Login_Name COLLATE DATABASE_DEFAULT =
        --(SELECT SUBSTRING(REPLACE(RequestContent, ' ', ''), (SELECT CHARINDEX('Login_Name', REPLACE(RequestContent, ' ', ''))) + 13, (LEN(REPLACE(RequestContent, ' ', ''))) - 19))
        --)
        --where RequestUri LIKE '%Login/GetLoginDetails%'
        --AND ResponseContent LIKE '%Login Successful%'
        --AND UserId IS NULL;

        --UPDATE [RightsUngReportsLog_V18]..Trace SET UserId = (SELECT Users_Code
        --FROM [RightsUngReports_Temp]..Users
        --WHERE Login_Name COLLATE DATABASE_DEFAULT =
        --(SELECT SUBSTRING(REPLACE(RequestContent, ' ', ''), (SELECT CHARINDEX('Login_Name', REPLACE(RequestContent, ' ', ''))) + 13, (LEN(REPLACE(RequestContent, ' ', ''))) - 17))
        --)
        --where RequestUri LIKE '%Login/GetLoginDetails%'
        --AND ResponseContent LIKE '%Login Successful%'
        --AND UserId IS NULL;

        UPDATE [RightsUngReportsLog_V18]..Trace SET RequestMethod = (SELECT SUBSTRING(RequestUri, (SELECT CHARINDEX('/api/', RequestUri)) + 5, (LEN(RequestUri))));
 
END
