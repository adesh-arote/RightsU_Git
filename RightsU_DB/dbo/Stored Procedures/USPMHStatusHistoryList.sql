CREATE PROCEDURE [dbo].[USPMHStatusHistoryList]
		@MHRequestTypeCode INT=0,
		@TitleName NVARCHAR(50)='',
		@MHRequestStatusCode INT=0,
		@RequestID NVARCHAR(50)='',
		@FromDate VARCHAR(50)='',
		@ToDate VARCHAR(50)='',
		@PageNo INT=1,
		@PageSize INT=100,
		@RecordCount INT OUT
AS
BEGIN
	IF(OBJECT_ID('TEMPDB..#TempRightsPagingData') IS NOT NULL)
		DROP TABLE #TempRightsPagingData

		Create Table #TempRightsPagingData
		(
			Row_No INT IDENTITY(1,1),
			RequestTypeName NVARCHAR(MAX),
			ShowName NVARCHAR(MAX),
			[Status] NVARCHAR(MAX),
			RequestID NVARCHAR(50),
			TelecastFrom DateTime,
			TelecastTo DateTime,
		)
		if(@PageNo>1)
			set @PageNo=1
		
		INSERT INTO #TempRightsPagingData
		(
			RequestTypeName,ShowName,[Status],RequestID,TelecastFrom,TelecastTo
		)

		--Declare
		--@MHRequestTypeCode INT=1,
		--@MHRequestStatusCode INT=2,
		--@RequestID NVARCHAR(50)='',
		--@FromDate VARCHAR(50)='',
		--@ToDate VARCHAR(50)='',
		--@TitleName NVARCHAR(MAX)=''
		SELECT DISTINCT  MRT.RequestTypeName,T.Title_Name ,
		 MRS.RequestStatusName,MR.RequestID,MR.TelecastTo,MR.TelecastFrom
		From MHRequest MR
			Inner Join MHRequestType MRT on MR.MHRequestTypeCode=MRT.MHRequestTypeCode
			Inner Join  Title T on MR.TitleCode=T.Title_Code
			Left Join  MHRequestStatus MRS on MR.MHRequestStatusCode=MRS.MHRequestStatusCode

		Where(@MHRequestTypeCode = 0 OR MR.MHRequestTypeCode =@MHRequestTypeCode)
		AND (@FromDate='' OR (CONVERT(Date,@FromDate,103) <= CONVERT(Date,MR.TelecastFrom,103)))
		AND (@ToDate='' OR  (CONVERT(Date,@ToDate,103) >= CONVERT(Date,MR.TelecastTo,103)))
		--AND @FromDate <=MR.TelecastFrom 
		--AND @ToDate>=MR.TelecastTo
		AND (@MHRequestStatusCode = 0 OR MR.MHRequestStatusCode = @MHRequestStatusCode)
		AND (@RequestID='' OR MR.RequestID =@RequestID)
	  AND (@TitleName = '' OR (T.Title_Name IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@TitleName, '') +'',','))))
	 order by MR.RequestID desc

	SELECT @RecordCount = COUNT(*) FROM #TempRightsPagingData

	    DELETE from  #TempRightsPagingData
		     WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	Select RequestTypeName,ShowName,[Status],RequestID,TelecastFrom,TelecastTo from #TempRightsPagingData

	IF OBJECT_ID('tempdb..#TempRightsPagingData') IS NOT NULL DROP TABLE #TempRightsPagingData
END