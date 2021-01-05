CREATE PROCEDURE [dbo].[USPMHGetCueSheetList]
@MHCueSheetCode INT,
@UsersCode INT,
@PagingRequired NVARCHAR(2),
@PageSize INT,
@PageNo INT,
@RecordCount INT OUT,
@StatusCode NVARCHAR(MAX),
@FromDate NVARCHAR(50),
@ToDate NVARCHAR(50)
AS
BEGIN
	--BEGIN
	--DECLARE
	--@MHCueSheetCode INT= 0,
	--@UsersCode INT = 1280,
	--@PagingRequired NVARCHAR(2) = 'N',
	--@PageSize INT = 10,
	--@PageNo INT = 1,
	--@RecordCount INT,-- OUT,
	--@StatusCode NVARCHAR(MAX)='C',
	--@FromDate NVARCHAR(50)='23-Jul-2018',
	--@ToDate NVARCHAR(50)='26-Jul-2018'
	
	IF(OBJECT_ID('TEMPDB..#TempCueSheetList') IS NOT NULL)
		DROP TABLE #TempCueSheetList

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
	(SELECT COUNT(*) FROM MHCueSheetSong cmsi WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'E') AS ErrorRecords,
	(SELECT COUNT(*) FROM MHCueSheetSong cmsi WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'W') AS WarningRecords,
	(SELECT COUNT(*) FROM MHCueSheetSong cmsi WHERE cmsi.MHCueSheetCode = mcs.MHCueSheetCode AND cmsi.RecordStatus = 'S') AS SuccessRecords
	FROM MHCueSheet MCS
	INNER JOIN Users U ON U.Users_Code = MCS.CreatedBy
	WHERE MCS.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
	AND (@StatusCode = '' OR UploadStatus IN (select number from dbo.fn_Split_withdelemiter(@StatusCode,','))) AND
	--(MCS.CreatedOn BETWEEN @FromDate AND @ToDate)
	 (@MHCueSheetCode = 0 OR MCS.MHCueSheetCode = @MHCueSheetCode)
	AND ((CAST(MCS.CreatedOn AS DATE) BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
	ORDER BY CreatedOn DESC

	SELECT @RecordCount = COUNT(*) FROM #TempCueSheetList
	Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	IF(@PagingRequired  = 'Y')
		BEGIN
			DELETE from  #TempCueSheetList
			WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
		END

	SELECT MHCueSheetCode,RequestID,FileName,RequestedBy,RequestedDate,RecordStatus,
	CASE WHEN TotalRecords = SuccessRecords THEN 'Success'
		WHEN ErrorRecords > 0 THEN 'Error'
		WHEN (ErrorRecords = 0 AND WarningRecords > 0) THEN 'Data Error'
		WHEN (RecordStatus = 'P') Then 'Pending'
		--ELSE 'Pending'
	END AS
	Status,TotalRecords,ErrorRecords,WarningRecords,SuccessRecords FROM #TempCueSheetList

	IF OBJECT_ID('tempdb..#TempCueSheetList') IS NOT NULL DROP TABLE #TempCueSheetList
END

--DECLARE @RecordCount INT
--EXEC USPMHGetCueSheetList 110,1287,'Y',10,1,@RecordCount OUTPUT,'','',''
--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)
--select REPLACE(CONVERT(NVARCHAR,GETDATE(), 106), ' ', '-')
