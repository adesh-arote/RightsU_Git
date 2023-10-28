CREATE PROCEDURE [dbo].[USPGetUserActivityLastRefreshedTime]
AS
  BEGIN

 --to convert utc time to local fetched from db
 --SELECT CONVERT(datetime,
 --              SWITCHOFFSET(CONVERT(datetimeoffset,
 --                                   (SELECT LastComputedAtUserActivity FROM DashboardReportParams)),
 --                           DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS LastComputedAtUserActivity;

SELECT LastComputedAtUserActivity FROM DashboardReportParams;

  END
