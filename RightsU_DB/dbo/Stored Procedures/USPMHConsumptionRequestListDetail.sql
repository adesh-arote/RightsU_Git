CREATE PROCEDURE [dbo].[USPMHConsumptionRequestListDetail]
@RequestTypeCode INT,
@UsersCode INT,
@RecordFor VARCHAR(2), 
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
SET FMTONLY OFF
	
	--BEGIN
	--DECLARE
	--@RequestTypeCode INT = 1,
	--@UsersCode INT = 293,
	--@RecordFor VARCHAR(2) = 'L', 
	--@RecordCount INT,-- OUT,
	--@RequestID NVARCHAR(MAX) = '',
	--@ChannelCode NVARCHAR(MAX) = '',
	--@ShowCode NVARCHAR(MAX) = '',
	--@StatusCode NVARCHAR(MAX) = '',
	--@FromDate NVARCHAR(50) = '',
	--@ToDate NVARCHAR(50)= '',
	--@SortBy NVARCHAR(50)= 'TelecastFrom',
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
	TelecastFrom DATE,
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
	TelecastFrom DATE,
	TelecastTo NVARCHAR(50),
	CountRequest INT,
	Status NVARCHAR(50),
	Login_Name NVARCHAR(50),
	ChannelName NVARCHAR(50),
	RequestDate NVARCHAR(50),
	ApprovedRequest INT,
	Music_Title NVARCHAR(MAX),
	MusicMovieAlbum NVARCHAR(MAX),
	LabelName NVARCHAR(MAX),
	Remarks NVARCHAR(MAX)
	)
	
	CREATE TABLE #tempApprovedCount
	(
	MHRequestCode INT,
	Approved INT
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

	INSERT INTO #tempApprovedCount(Approved,MHRequestCode)
	Select COUNT(MHRequestCode) AS ApprovedCount,MHRequestCode FROM MHRequestDetails WITH (NOLOCK)
	WHERE IsApprove = 'Y' 
	GROUP BY MHRequestCode 

	INSERT INTO #TempConsumptionList(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate)
	SELECT MR.RequestID,
	ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS VARCHAR(Max))[text()]
			 FROM MHRequestDetails MRD
			 --INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
			 LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
			 LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
			 Where MRD.MHRequestCode = MR.MHRequestCode
			 FOR XML PATH(''), TYPE)
			.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) MusicLabel,
	ISNULL(MR.MHRequestCode,0) AS RequestCode,ISNULL(T.Title_Name,'') AS Title_Name ,ISNULL(MR.EpisodeFrom,'') AS EpisodeFrom,ISNULL(MR.EpisodeTo,'') AS EpisodeTo,CONVERT(DATE, ISNULL(MR.TelecastFrom,'')) AS TelecastFrom,ISNULL(MR.TelecastTo,'') AS TelecastTo,COUNT(MRD.MHRequestCode) AS CountRequest,ISNULL(MRS.RequestStatusName,'') AS Status,ISNULL(U.Login_Name,'') AS Login_Name,ISNULL(C.Channel_Name,'') AS ChannelName,
	ISNULL(MR.RequestedDate,'') AS RequestDate--, MRD.MusicTitleCode
	--INTO #tempRequest
	FROM MHRequest MR WITH(NOLOCK)
	LEFT JOIN Title T WITH(NOLOCK) ON T.Title_Code = MR.TitleCode
	LEFT JOIN MHRequestStatus MRS WITH(NOLOCK) ON MRS.MHRequestStatusCode = MR.MHRequestStatusCode
	LEFT JOIN Users U WITH(NOLOCK) ON U.Users_Code = MR.UsersCode
	LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = MR.MHRequestCode
	LEFT JOIN Channel C WITH(NOLOCK) ON C.Channel_Code = MR.ChannelCode
	WHERE MR.MHRequestTypeCode = @RequestTypeCode AND MR.VendorCode In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode) AND
	(@RequestID = '' OR MR.RequestID like '%'+@RequestID+'%') AND (@ChannelCode = '' OR C.Channel_Code IN(select number from dbo.fn_Split_withdelemiter(@ChannelCode,',')) ) AND (@ShowCode = '' OR T.Title_Code IN(select number from dbo.fn_Split_withdelemiter(@ShowCode,','))) 
	AND (@StatusCode = '' OR MRS.MHRequestStatusCode IN(select number from dbo.fn_Split_withdelemiter(@StatusCode,',')))
	AND
	--((REPLACE(CONVERT(NVARCHAR,CreatedOn, 106),' ', '-') BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))
	((CAST(MR.RequestedDate AS DATE) BETWEEN @FromDate AND @ToDate))
	GROUP BY MRD.MHRequestCode,MR.RequestID,T.Title_Name ,MR.EpisodeFrom,MR.EpisodeTo,MR.TelecastFrom,MR.TelecastTo,MRS.RequestStatusName,MRS.RequestStatusName,U.Login_Name,MR.RequestedDate,MR.MHRequestCode,C.Channel_Name

	SELECT @RecordCount = COUNT(*) FROM #TempConsumptionList
	Print 'Recordcount= ' +CAST(@RecordCount AS NVARCHAR)

	BEGIN
		IF(@SortBy = 'RequestDate')
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest,Music_Title,MusicMovieAlbum,LabelName,Remarks )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest, ISNULL(MT.Music_Title_Name,'''') AS Music_Title ,MA.Music_Album_Name AS MusicMovieAlbum,ISNULL(ML.Music_Label_Name,'''') AS LabelName,ISNULL(MRD.Remarks,'''') AS Remarks  
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = tcl.RequestCode
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				ORDER BY CAST('+ @SortBy + ' AS DATETIME) ' + @Order)
			END
		ELSE
			BEGIN
				EXEC ('INSERT INTO #TempConsumptionListFinal(RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ApprovedRequest,Music_Title,MusicMovieAlbum,LabelName,Remarks )
				SELECT RequestID,MusicLabel,RequestCode,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,CountRequest,Status,Login_Name,ChannelName,RequestDate,ISNULL(tac.Approved,0) AS ApprovedRequest, ISNULL(MT.Music_Title_Name,'''') AS Music_Title ,MA.Music_Album_Name AS MusicMovieAlbum,ISNULL(ML.Music_Label_Name,'''') AS LabelName,ISNULL(MRD.Remarks,'''') AS Remarks 
				FROM #TempConsumptionList tcl
				LEFT JOIN #tempApprovedCount tac ON tac.MHRequestCode = tcl.RequestCode
				LEFT JOIN MHRequestDetails MRD WITH(NOLOCK) ON MRD.MHRequestCode = tcl.RequestCode
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				ORDER BY '+ @SortBy + ' ' + @Order)
			END
	END

	SELECT RequestID,ChannelName,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,Music_Title,MusicMovieAlbum,LabelName,Status,Login_Name,RequestDate,Remarks FROM #TempConsumptionListFinal


	IF OBJECT_ID('tempdb..#TempConsumptionList') IS NOT NULL DROP TABLE #TempConsumptionList
	IF OBJECT_ID('tempdb..#tempRequest') IS NOT NULL DROP TABLE #tempRequest
	IF OBJECT_ID('tempdb..#TempConsumptionListFinal') IS NOT NULL DROP TABLE #TempConsumptionListFinal
END

--DECLARE @RecordCount INT
--EXEC USPMHConsumptionRequestList 1,1287,'L','Y',10,1,@RecordCount OUTPUT,'','','','','',''
--PRINT 'RecordCount: '+CAST( @RecordCount AS NVARCHAR)
