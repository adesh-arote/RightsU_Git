CREATE PROCEDURE [dbo].[USPMHConsumptionRequestList]
@RequestTypeCode INT,
@UsersCode INT,
@RecordFor VARCHAR(2), 
@PagingRequired NVARCHAR(2),
@PageSize INT,
@PageNo INT,
@RecordCount INT OUT,
@RequestID NVARCHAR(MAX),
@ChannelCode NVARCHAR(MAX),
@ShowCode NVARCHAR(MAX),
@StatusCode NVARCHAR(MAX),
@FromDate NVARCHAR(50) = '',
@ToDate NVARCHAR(50)= '',
@SortBy NVARCHAR(50)= '',
@Order NVARCHAR(50)= ''
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHConsumptionRequestList]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET FMTONLY OFF
	
		--BEGIN
		--DECLARE
		--@RequestTypeCode INT = 1,
		--@UsersCode INT = 293,
		--@RecordFor VARCHAR(2) = 'L', 
		--@PagingRequired NVARCHAR(2) = 'Y',
		--@PageSize INT = 10,
		--@PageNo INT = 1,
		--@RecordCount INT,-- OUT,
		--@RequestID NVARCHAR(MAX) = '',
		--@ChannelCode NVARCHAR(MAX) = '',
		--@ShowCode NVARCHAR(MAX) = '',
		--@StatusCode NVARCHAR(MAX) = '',
		--@FromDate NVARCHAR(50) = '',
		--@ToDate NVARCHAR(50)= '',
		--@SortBy NVARCHAR(50)= 'RequestDate',
		--@Order NVARCHAR(50)= 'DESC'

		IF(OBJECT_ID('TEMPDB..#TempConsumptionList') IS NOT NULL)
			DROP TABLE #TempConsumptionList
		IF(OBJECT_ID('TEMPDB..#tempApprovedCount') IS NOT NULL)
			DROP TABLE #tempApprovedCount
		IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal

		CREATE TABLE #TempConsumptionList(
		Row_No INT IDENTITY(1,1),
		RequestID NVARCHAR(50),
		MusicLabel NVARCHAR(MAX),
		RequestCode INT,
		Title_Name NVARCHAR(100),
		EpisodeFrom INT,
		EpisodeTo INT,
		TelecastFrom NVARCHAR(50),
		TelecastTo NVARCHAR(50),
		CountRequest INT,
		Status NVARCHAR(50),
		Login_Name NVARCHAR(50),
		ChannelName NVARCHAR(50),
		RequestDate NVARCHAR(50)
		)

		CREATE TABLE #TempConsumptionListFinal(
		Row_No INT IDENTITY(1,1),
		RequestID NVARCHAR(50),
		MusicLabel NVARCHAR(MAX),
		RequestCode INT,
		Title_Name NVARCHAR(100),
		EpisodeFrom INT,
		EpisodeTo INT,
		TelecastFrom NVARCHAR(50),
		TelecastTo NVARCHAR(50),
		CountRequest INT,
		Status NVARCHAR(50),
		Login_Name NVARCHAR(50),
		ChannelName NVARCHAR(50),
		RequestDate NVARCHAR(50),
		ApprovedRequest INT
		)
	
		CREATE TABLE #tempApprovedCount
		(
		MHRequestCode INT,
		Approved INT
		)

		if(@PageNo = 0)
			Set @PageNo = 1

		DECLARE @Count INT;
		IF(@RecordFor = 'D')
			BEGIN
				SET @Count = 5
			END
		ELSE
			BEGIN
				SET @Count = (SELECT COUNT(MHRequestCode) FROM MHRequest (NOLOCK) WHERE MHRequestTypeCode = @RequestTypeCode AND VendorCode In (Select Vendor_Code From MHUsers (NOLOCK) Where Users_Code = @UsersCode))
			END

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

		INSERT INTO #tempApprovedCount(Approved,MHRequestCode)
		Select COUNT(MHRequestCode) AS ApprovedCount,MHRequestCode FROM MHRequestDetails WITH (NOLOCK)
		WHERE IsApprove = 'Y' 
		GROUP BY MHRequestCode 

		INSERT INTO #TempConsumptionList(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate)
		SELECT TOP(@Count) MR.RequestID,
		ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS VARCHAR(Max))[text()]
				 FROM MHRequestDetails MRD (NOLOCK)
				 --INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				 LEFT JOIN Music_Title_Label MTL (NOLOCK) ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				 LEFT JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MTL.Music_Label_Code
				 Where MRD.MHRequestCode = MR.MHRequestCode
				 FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) MusicLabel,
		ISNULL(MR.MHRequestCode,0) AS RequestCode,ISNULL(T.Title_Name,'') AS Title_Name ,ISNULL(MR.EpisodeFrom,'') AS EpisodeFrom,ISNULL(MR.EpisodeTo,'') AS EpisodeTo,ISNULL(MR.TelecastFrom,'') AS TelecastFrom,ISNULL(MR.TelecastTo,'') AS TelecastTo,COUNT(MRD.MHRequestCode) AS CountRequest,ISNULL(MRS.RequestStatusName,'') AS Status,ISNULL(U.Login_Name,'') AS Login_Name,ISNULL(C.Channel_Name,'') AS ChannelName,
		ISNULL(MR.RequestedDate,'') AS RequestDate
		--INTO #tempRequest
		FROM MHRequest MR WITH (NOLOCK)
		LEFT JOIN Title T WITH(NOLOCK) ON T.Title_Code = MR.TitleCode
		LEFT JOIN MHRequestStatus MRS WITH(NOLOCK) ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
		LEFT JOIN Users U WITH(NOLOCK) ON U.Users_Code = MR.UsersCode
		LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = MR.MHRequestCode
		LEFT JOIN Channel C WITH(NOLOCK) ON C.Channel_Code = MR.ChannelCode
		WHERE MR.MHRequestTypeCode = @RequestTypeCode AND MR.VendorCode In (Select Vendor_Code From MHUsers (NOLOCK) Where Users_Code = @UsersCode) AND
		(@RequestID = '' OR MR.RequestID like '%'+@RequestID+'%') AND (@ChannelCode = '' OR C.Channel_Code IN(select number from dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) AND (@ShowCode = '' OR T.Title_Code IN(select number from dbo.fn_Split_withdelemiter(@ShowCode,','))) 
		AND (@StatusCode = '' OR MRS.MHRequestStatusCode IN(select number from dbo.fn_Split_withdelemiter(@StatusCode,',')))
		AND
		--((REPLACE(CONVERT(NVARCHAR,CreatedOn, 106),' ', '-') BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
		((CAST(MR.RequestedDate AS DATE) BETWEEN @FromDate AND @ToDate))
		GROUP BY MRD.MHRequestCode,MR.RequestID,T.Title_Name ,MR.EpisodeFrom,MR.EpisodeTo,MR.TelecastFrom,MR.TelecastTo,MRS.RequestStatusName,MRS.RequestStatusName,U.Login_Name,MR.RequestedDate,MR.MHRequestCode,C.Channel_Name
		ORDER BY MR.RequestedDate DESC

		SELECT @RecordCount = COUNT(*) FROM #TempConsumptionList
		Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	
		BEGIN
			IF(@SortBy = 'RequestDate')
				BEGIN
					EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest )
					SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest 
					FROM #TempConsumptionList tcl
					LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
					ORDER BY CAST('+ @SortBy + ' AS DATETIME) ' + @Order)
				END
			ELSE
				BEGIN
					EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest )
					SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest 
					FROM #TempConsumptionList tcl
					LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
					ORDER BY '+ @SortBy + ' ' + @Order)
				END
		END

		IF(@PagingRequired  = 'Y')
			BEGIN
				DELETE from  #TempConsumptionListFinal
				WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
			END

		SELECT * FROM #TempConsumptionListFinal


		IF OBJECT_ID('tempdb..#TempConsumptionList') IS NOT NULL DROP TABLE #TempConsumptionList
		IF OBJECT_ID('tempdb..#tempRequest') IS NOT NULL DROP TABLE #tempRequest
		IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHConsumptionRequestList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO

