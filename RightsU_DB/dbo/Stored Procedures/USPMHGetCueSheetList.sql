CREATE PROCEDURE [dbo].[USPMHGetCueSheetList]
@MHCueSheetCode INT,
@UsersCode INT,
@PagingRequired NVARCHAR(2),
@PageSize INT,
@PageNo INT,
@RecordCount INT OUT,
@StatusCode NVARCHAR(MAX),
@FromDate NVARCHAR(50),
@ToDate NVARCHAR(50),
@SortBy NVARCHAR(50)= '',
@Order NVARCHAR(50)= ''
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetCueSheetList]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE
		--@MHCueSheetCode INT= 0,
		--@UsersCode INT = 293,
		--@PagingRequired NVARCHAR(2) = 'Y',
		--@PageSize INT = 10,
		--@PageNo INT = 1,
		--@RecordCount INT,-- OUT,
		--@StatusCode NVARCHAR(MAX)='C',
		--@FromDate NVARCHAR(50)='',
		--@ToDate NVARCHAR(50)='',
		--@SortBy NVARCHAR(50)= 'TotalRecords',
		--@Order NVARCHAR(50)= 'DESC'
	
		IF(OBJECT_ID('TEMPDB..#TempCueSheetList') IS NOT NULL)
			DROP TABLE #TempCueSheetList
		IF OBJECT_ID('tempdb..#TempCueSheetListFinal') IS NOT NULL DROP TABLE #TempCueSheetListFinal

		CREATE TABLE #TempCueSheetList(
		Row_No INT IDENTITY(1,1),
		MHCueSheetCode INT,
		RequestID NVARCHAR(50),
		FileName NVARCHAR(MAX),
		RequestedBy NVARCHAR(MAX),
		RequestedDate NVARCHAR(50),
		RecordStatus NVARCHAR(20),
		Status NVARCHAR(MAX),
		TotalRecords INT,
		ErrorRecords INT,
		WarningRecords INT,
		SuccessRecords INT
		)

		CREATE TABLE #TempCueSheetListFinal(
		Row_No INT IDENTITY(1,1),
		MHCueSheetCode INT,
		RequestID NVARCHAR(50),
		FileName NVARCHAR(MAX),
		RequestedBy NVARCHAR(MAX),
		RequestedDate NVARCHAR(50),
		RecordStatus NVARCHAR(20),
		Status NVARCHAR(MAX),
		TotalRecords INT,
		ErrorRecords INT,
		WarningRecords INT,
		SuccessRecords INT
		)
	
		IF(@FromDate = '' AND @ToDate <> '')
			SET @FromDate = '01-Jan-1970'
		ELSE IF(@ToDate = '' AND @FromDate <> '')
			Set @ToDate = '31-Dec-9999'
		ELSE IF(@FromDate = '' AND @ToDate = '')
			BEGIN
				SET @FromDate = '01-Jan-1970'
				Set @ToDate = '31-Dec-9999'
			END
	
		Print @FromDate
		Print @ToDate

		if(@PageNo = 0)
			Set @PageNo = 1
	
		IF(@StatusCode = 'D')
			SET @StatusCode = 'E,W'
		ELSE IF(@StatusCode = 'S')
			SET @StatusCode = 'C'

		INSERT INTO #TempCueSheetList(MHCueSheetCode,RequestID,FileName,RequestedBy,RequestedDate,RecordStatus,Status,TotalRecords,ErrorRecords,WarningRecords,SuccessRecords)
		SELECT MHCueSheetCode,RequestID,ISNULL(FileName,'') AS FileName,ISNULL(U.Login_Name,'') AS RequestedBy,CAST(CreatedOn AS DATE) AS RequestedDate,ISNULL(UploadStatus,'') AS RecordStatus,
		CASE 
			WHEN UploadStatus = 'P' THEN 'Pending' 
			WHEN UploadStatus IN ('E', 'W') THEN 'Data Error'
			ELSE 'Submit' END AS Status,
		ISNULL(TotalRecords,0) AS TotalRecords,--ISNULL(ErrorRecords,0) AS ErrorRecords  
		(SELECT COUNT(*) FROM MHCueSheetSong cmsi (NOLOCK) WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'E') AS ErrorRecords,
		(SELECT COUNT(*) FROM MHCueSheetSong cmsi (NOLOCK) WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'W') AS WarningRecords,
		(SELECT COUNT(*) FROM MHCueSheetSong cmsi (NOLOCK) WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'S') AS SuccessRecords
		FROM MHCueSheet MCS (NOLOCK)
		INNER JOIN Users U  (NOLOCK) ON U.Users_Code = MCS.CreatedBy
		WHERE MCS.VendorCode In (Select Vendor_Code From MHUsers (NOLOCK) Where Users_Code = @UsersCode)
		AND (@StatusCode = '' OR UploadStatus IN (select number from dbo.fn_Split_withdelemiter(@StatusCode,','))) AND
		--(MCS.CreatedOn BETWEEN @FromDate AND @ToDate)
		 (@MHCueSheetCode = 0 OR MCS.MHCueSheetCode = @MHCueSheetCode)
		AND ((CAST(MCS.CreatedOn AS DATE) BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
		ORDER BY CreatedOn DESC

		SELECT @RecordCount = COUNT(*) FROM #TempCueSheetList
		Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

		EXEC ('INSERT INTO #TempCueSheetListFinal
		SELECT MHCueSheetCode,RequestID,FileName,RequestedBy,RequestedDate,RecordStatus,
		CASE WHEN TotalRecords = SuccessRecords THEN ''Success''
			WHEN ErrorRecords > 0 THEN ''Error''
			WHEN (ErrorRecords = 0 AND WarningRecords > 0) THEN ''Data Error''
			WHEN (RecordStatus = ''P'') Then ''Pending''
			--ELSE ''Pending''
		END AS
		Status,TotalRecords,ErrorRecords,WarningRecords,SuccessRecords FROM #TempCueSheetList ORDER BY '+ @SortBy + ' ' + @Order)

		IF(@PagingRequired  = 'Y')
			BEGIN
				DELETE from  #TempCueSheetListFinal
				WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
			END

		SELECT * FROM #TempCueSheetListFinal

		IF OBJECT_ID('tempdb..#TempCueSheetList') IS NOT NULL DROP TABLE #TempCueSheetList
		IF OBJECT_ID('tempdb..#TempCueSheetListFinal') IS NOT NULL DROP TABLE #TempCueSheetListFinal
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetCueSheetList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO

