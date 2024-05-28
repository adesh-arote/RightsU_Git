




CREATE VIEW [dbo].[TitleSchedule]
AS
SELECT bv.Title_Code, Schedule_Item_Log_Date, Schedule_Item_Log_Time, CAST(CONVERT(DATETIME, CONVERT(CHAR(8), CAST(Schedule_Item_Log_Date AS DATE), 112)  + ' ' + CONVERT(CHAR(8), CAST(Schedule_Item_Log_Time AS TIME), 108)) AS DATETIME) LastAirDate, Channel_Name
FROM RightsU_Plus_Testing.dbo.BV_Schedule_Transaction bv
INNER JOIN (
	SELECT Title_Code, 
	MAX(CONVERT(DATETIME, CONVERT(CHAR(8), CAST(Schedule_Item_Log_Date AS DATE), 112)  + ' ' + CONVERT(CHAR(8), CAST(Schedule_Item_Log_Time AS TIME), 108))) LastAirDate 
	FROM RightsU_Plus_Testing.dbo.BV_Schedule_Transaction
	WHERE Title_Code IS NOT NULL AND Schedule_Item_Log_Date <> '' AND Schedule_Item_Log_Time <> ''
	GROUP BY Title_Code
) AS air ON bv.Title_Code = air.Title_Code AND CAST(CONVERT(DATETIME, CONVERT(CHAR(8), CAST(Schedule_Item_Log_Date AS DATE), 112)  + ' ' + CONVERT(CHAR(8), CAST(Schedule_Item_Log_Time AS TIME), 108)) AS DATETIME) = air.LastAirDate
INNER JOIN RightsU_Plus_Testing.dbo.Channel c ON bv.Channel_Code = c.Channel_Code





