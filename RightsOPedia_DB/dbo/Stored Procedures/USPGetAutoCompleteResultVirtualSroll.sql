CREATE PROCEDURE USPGetAutoCompleteResultVirtualSroll
@SqlString NVARCHAR(MAX),
--@PageSize INT,
--@PageNo INT,
@BufferValue INT,
@BufferIncrementValue INT,
@RecordCount INT OUT
AS
BEGIN

PRINT @SqlString
	
	IF OBJECT_ID('tempdb..#tempAutoCompleteResult') IS NOT NULL DROP TABLE #tempAutoCompleteResult

	CREATE TABLE #tempAutoCompleteResult
	(
		Row_No INT IDENTITY(1,1),
		ValueField INT,
		TextField NVARCHAR(MAX)
	)


	DECLARE @Sql NVARCHAR(MAX)

	SET @Sql = 'INSERT INTO #tempAutoCompleteResult(ValueField,TextField)' + @SqlString
	
	EXEC (@Sql)

	SET @RecordCount = (Select COUNT(*) from #tempAutoCompleteResult)

	
	--DELETE from  #tempAutoCompleteResult
	--WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	
	DECLARE @Start INT,@End INT

	SET @Start = @BufferValue + 1
	SET @End = @BufferValue + @BufferIncrementValue

	Select ValueField, TextField from #tempAutoCompleteResult WHERE Row_No BETWEEN @Start and @End order by 2

	IF OBJECT_ID('tempdb..#tempAutoCompleteResult') IS NOT NULL DROP TABLE #tempAutoCompleteResult
END
