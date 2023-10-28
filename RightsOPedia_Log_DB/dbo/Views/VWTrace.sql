CREATE VIEW [dbo].[VWTrace]
AS
SELECT *, CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,RequestDateTime),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS RequestDateTime_IST,
 CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,ResponseDateTime),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS ResponseDateTime_IST
FROM Trace
