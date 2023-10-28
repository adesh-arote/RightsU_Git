CREATE PROCEDURE [dbo].[USPITGetStarCastVirtualScroll]
@SearchString NVARCHAR(MAX),
@BufferValue INT,
@BufferIncrementValue INT,
@RecordCount INT OUT
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetStarCastVirtualScroll]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF OBJECT_ID('tempdb..#tempTalent') IS NOT NULL DROP TABLE #tempTalent
	
		CREATE TABLE #tempTalent
		(
			Row_No INT IDENTITY(1,1),
			ValueField INT,
			TextField NVARCHAR(MAX)
		)

		INSERT INTO #tempTalent(ValueField, TextField)
		SELECT Talent_Code, Talent_Name FROM Talent (NOLOCK) WHERE (@SearchString = '' OR Talent_Name like '%'+@SearchString+'%' ) order by 2
	
		SET @RecordCount = (Select COUNT(*) from #tempTalent)

		DECLARE @Start INT,@End INT

		SET @Start = @BufferValue + 1
		SET @End = @BufferValue + @BufferIncrementValue

		Select ValueField, TextField from #tempTalent WHERE Row_No BETWEEN @Start and @End order by 2

		IF OBJECT_ID('tempdb..#tempTalent') IS NOT NULL DROP TABLE #tempTalent
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetStarCastVirtualScroll]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END