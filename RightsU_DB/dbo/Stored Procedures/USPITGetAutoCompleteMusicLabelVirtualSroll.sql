CREATE PROCEDURE [dbo].[USPITGetAutoCompleteMusicLabelVirtualSroll]
@SqlString NVARCHAR(MAX),
@BufferValue INT,
@BufferIncrementValue INT,
@RecordCount INT OUT
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USPITGetAutoCompleteMusicLabelVirtualSroll]', 'Step 1', 0, 'Started Procedure', 0, ''

	PRINT @SqlString
	
		IF OBJECT_ID('tempdb..#tempAutoCompleteResult') IS NOT NULL DROP TABLE #tempAutoCompleteResult

		CREATE TABLE #tempAutoCompleteResult
		(
			Row_No INT IDENTITY(1,1),
			Program_Code INT,
			[Program_Name] NVARCHAR(MAX)
		)


		DECLARE @Sql NVARCHAR(MAX)

		SET @Sql = 'INSERT INTO #tempAutoCompleteResult(Program_Code,[Program_Name])' + @SqlString
	
		EXEC (@Sql)

		SET @RecordCount = (Select COUNT(*) from #tempAutoCompleteResult)
	
		DECLARE @Start INT,@End INT

		SET @Start = @BufferValue + 1
		SET @End = @BufferValue + @BufferIncrementValue

		Select Program_Code, [Program_Name] from #tempAutoCompleteResult WHERE Row_No BETWEEN @Start and @End order by 2

		IF OBJECT_ID('tempdb..#tempAutoCompleteResult') IS NOT NULL DROP TABLE #tempAutoCompleteResult
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPITGetAutoCompleteMusicLabelVirtualSroll]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END