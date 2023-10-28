CREATE PROCEDURE [dbo].[USPITGetLicensorVirtualScroll]
@SearchString NVARCHAR(MAX),
@BufferValue INT,
@BufferIncrementValue INT,
@RecordCount INT OUT
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetLicensorVirtualScroll]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF OBJECT_ID('tempdb..#tempLicensor') IS NOT NULL DROP TABLE #tempLicensor
	
		CREATE TABLE #tempLicensor
		(
			Row_No INT IDENTITY(1,1),
			ValueField INT,
			TextField NVARCHAR(MAX)
		)

		INSERT INTO #tempLicensor(ValueField, TextField)
		SELECT Vendor_Code, Vendor_Name FROM Vendor (NOLOCK) WHERE (@SearchString = '' OR Vendor_Name like '%'+@SearchString+'%' ) order by 2
	
		SET @RecordCount = (Select COUNT(*) from #tempLicensor)

		DECLARE @Start INT,@End INT

		SET @Start = @BufferValue + 1
		SET @End = @BufferValue + @BufferIncrementValue

		Select ValueField, TextField from #tempLicensor WHERE Row_No BETWEEN @Start and @End order by 2

		IF OBJECT_ID('tempdb..#tempLicensor') IS NOT NULL DROP TABLE #tempLicensor
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetLicensorVirtualScroll]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END