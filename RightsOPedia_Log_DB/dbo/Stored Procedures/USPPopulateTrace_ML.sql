CREATE PROCEDURE USPPopulateTrace_ML
AS 
BEGIN

	DECLARE @LastTraceID BIGINT
	SET @LastTraceID = (SELECT top 1 TraceId FROM Trace_ML order by 1 desc)
	
	INSERT INTO Trace_ML
	SELECT * FROM Trace WHERE TraceId > @LastTraceID

END

