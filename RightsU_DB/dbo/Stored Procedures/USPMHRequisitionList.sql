
CREATE PROCEDURE [dbo].[USPMHRequisitionList] 
--DECLARE
	@ProductionHouseCode VARCHAR(MAX) = '',
	@MusicLabel VARCHAR(500) = '',
	@MHRequestTypeCode INT=0,
	@FromDate VARCHAR(20) = '',
	@ToDate VARCHAR(20) = '',
	@StatusCode VARCHAR(MAX) = '',
	@TitleCode VARCHAR(500) = '',
	@BusinessUnitCode VARCHAR(MAX) = '',
	@DealTypeCode VARCHAR(MAX) = '',
	@PageNo INT = 1,
	@PageSize INT = 100,
	@UsersCode VARCHAR(50) ='',
    @RequestId NVARCHAR(40) ='', 
	@RecordCount INT OUT
--Created By : Anchal Sikarwar
--Created On : 11 June 2018
AS
BEGIN

	IF(OBJECT_ID('TEMPDB..#TempRightsPagingData') IS NOT NULL)
		DROP TABLE #TempRightsPagingData
	IF(OBJECT_ID('TEMPDB..#Label') IS NOT NULL)
		DROP TABLE #Label		

	CREATE TABLE #TempRightsPagingData
	(
		Row_No INT IDENTITY(1,1),
		MHRequestCode INT,
		MHRequestTypeCode INT,
		RequestID NVARCHAR(40),
		ShowName NVARCHAR(MAX),
		EpisodeNo NVARCHAR(MAX),
		ChannelName NVARCHAR(MAX),
		Songs NVARCHAR(MAX),
		MusicLabels NVARCHAR(MAX),
		[Status] NVARCHAR(50),
		RequestedBy NVARCHAR(500),
		RequestedDate Datetime,
		PendingSince VARCHAR(50),
		PendingCount INT,
		AuthorisedSongsCount INT 
	)

	if(@PageNo = 0)
        Set @PageNo = 1

	--select number AS MusicLabel INTO #Label from dbo.fn_Split_withdelemiter('' + @MusicLabel +'',',')

	INSERT INTO #TempRightsPagingData
	(
		MHRequestCode, MHRequestTypeCode, RequestID, ShowName, EpisodeNo, ChannelName, Songs, MusicLabels,[Status], RequestedBy, RequestedDate, PendingSince, PendingCount, AuthorisedSongsCount
	)
	SELECT DISTINCT MR.MHRequestCode, MR.MHRequestTypeCode, MR.RequestID, (select TOP 1 T.Title_Name from Title T Where T.Title_Code = MR.TitleCode)
		,CASE WHEN ISNULL(MR.EpisodeFrom,0)  < ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX)) +' - '+ CAST(MR.EpisodeTo AS VARCHAR(MAX))
			 WHEN ISNULL(MR.EpisodeFrom,0)  = ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX))
		ELSE '' END
		,C.Channel_Name
		,CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
		,STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS NVARCHAR) FROM MHRequestDetails MRD1
		INNER JOIN Music_Title_Label MTL ON MRD1.MusicTitleCode = MTL.Music_Title_Code 
		INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
		Where MRD1.MHRequestCode = MR.MHRequestCode
		FOR XML PATH('')), 1, 1, '')
		,MRS.RequestStatusName, V.Vendor_Name +' / '+ U.First_Name, MR.RequestedDate, 
		CASE WHEN MR.MHRequestStatusCode = 2 OR MR.MHRequestStatusCode = 4 THEN  [dbo].[UFNDateDifference](MR.RequestedDate)
		ELSE '' END
		,( SELECT COUNT(*) FROM MHRequestDetails mrd1 WHERE MR.MHRequestCode = mrd1.MHRequestCode AND ISNULL(mrd1.IsApprove, 'P') = 'P') AS PendingCount
		,( SELECT COUNT(*) FROM MHRequestDetails mrd1 WHERE MR.MHRequestCode = mrd1.MHRequestCode AND mrd1.IsApprove = 'Y') AS AuthorisedSongsCount
	 FROM MHRequest MR
		INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
		LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
		LEFT JOIN Channel c ON c.Channel_Code = MR.ChannelCode
		LEFT JOIN MHUsers MU ON MR.UsersCode = MU.Users_Code AND MR.VendorCode = MU.Vendor_Code
		LEFT JOIN Users U ON MU.Users_Code = U.Users_Code
		LEFT JOIN Vendor V ON V.Vendor_Code = MU.Vendor_Code
		LEFT JOIN Music_Deal_LinkShow MDL ON MDL.Title_Code = T.Title_Code
		LEFT JOIN Music_Deal MD ON MD.Music_Deal_Code = MDL.Music_Deal_Code
	Where 
	(@MusicLabel = '' OR ((select COUNT(*) from Music_Title_Label MTL
	INNER JOIN MHRequestDetails MRD ON MRD.MusicTitleCode = MTL.Music_Title_Code
	AND MRD.MHRequestCode = MR.MHRequestCode
	Where MTL.Music_Label_Code IN (
	select number from dbo.fn_Split_withdelemiter(@MusicLabel,',')
	))>0))
		AND 
		(@FromDate = '' OR (CONVERT(DATE,@FromDate,103) <= CONVERT(DATE,MR.RequestedDate,103)))
		AND (@ToDate = '' OR (CONVERT(DATE,@ToDate,103) >= CONVERT(DATE,MR.RequestedDate,103)))
		AND (@StatusCode = '' OR MR.MHRequestStatusCode in (select number from dbo.fn_Split_withdelemiter(''+@StatusCode+'',',')))
		AND (@ProductionHouseCode = '' OR MR.VendorCode in (select number from dbo.fn_Split_withdelemiter(''+@ProductionHouseCode+'',',')))
		AND
		(@MHRequestTypeCode = 0 OR MR.MHRequestTypeCode = @MHRequestTypeCode)
		AND (@UsersCode ='' OR (U.Login_Name IN (select number from dbo.fn_Split_withdelemiter('' + @UsersCode + '',','))))
        AND (@RequestId = '' OR MR.RequestID LIKE '%' + @RequestId + '%')
		AND (@TitleCode = '' OR (T.Title_Name IN (select number from dbo.fn_Split_withdelemiter('' + @TitleCode +'',','))))
		AND (@DealTypeCode = '' OR T.Deal_Type_Code in (select number from dbo.fn_Split_withdelemiter(''+@DealTypeCode+'',','))) 
		AND (@BusinessUnitCode = '' OR MD.Business_Unit_Code IN(select number from dbo.fn_Split_withdelemiter(''+@BusinessUnitCode+'',','))) 
	order by MR.RequestedDate desc

	SELECT @RecordCount = COUNT(*) FROM #TempRightsPagingData

	DELETE from  #TempRightsPagingData
	WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)

	SELECT MHRequestCode, MHRequestTypeCode , RequestID, ShowName, ChannelName, EpisodeNo, Songs , MusicLabels AS MusicLabel, [Status], RequestedBy, RequestedDate, PendingSince, PendingCount, AuthorisedSongsCount from #TempRightsPagingData

	IF OBJECT_ID('tempdb..#Label') IS NOT NULL DROP TABLE #Label
	IF OBJECT_ID('tempdb..#TempRightsPagingData') IS NOT NULL DROP TABLE #TempRightsPagingData
END

--DECLARE @RC INT  
--exec USPMHRequisitionList '','',0,'','','','','','',1,10,'','', @RC  

--ALTER PROCEDURE [dbo].[USPMHRequisitionList]    
--	@ProductionHouseCode VARCHAR(MAX) = '',
--	@MusicLabel VARCHAR(500) = '',
--	@MHRequestTypeCode INT=0,
--	@FromDate VARCHAR(20) = '',
--	@ToDate VARCHAR(20) = '',
--	@StatusCode VARCHAR(MAX) = '',
--	@TitleCode VARCHAR(500) = '',
--	@PageNo INT = 1,
--	@PageSize INT = 100,
--	@UsersCode VARCHAR(50) ='',
--    @RequestId NVARCHAR(40) ='', 
--	@RecordCount INT OUT    
----Created By : Anchal Sikarwar    
----Created On : 11 June 2018    
--AS    
--BEGIN    
    
--DECLARE    
--  @MHRequestCode INT =1,     
--  -- @MHRequestTypeCode INT=0,   
--  --@RequestID NVARCHAR(40) ='',    
--  @ShowName NVARCHAR(MAX) ='',
--  @ChannelName  NVARCHAR(MAX) ='',
--  @EpisodeNo INT,
--  @Songs NVARCHAR(MAX) ='',    
--  @MusicLabels NVARCHAR(MAX)= '',    
--  @Status NVARCHAR(50) = '',    
--  @RequestedBy NVARCHAR(500)= '',    
--  @RequestedDate Datetime =GETDATE(),    
--  @PendingSince VARCHAR(50),  
--  @AuthorisedSongsCount INT,  
--  @PendingCount INT =0  
    
    
-- select @MHRequestCode MHRequestCode ,   
--  @MHRequestTypeCode MHRequestTypeCode,   
--  @RequestID RequestID ,    
--  @ShowName ShowName ,  
--  @ChannelName ChannelName, 
--  @EpisodeNo EpisodeNo,
--  @Songs Songs ,    
--  @MusicLabel MusicLabel ,    
--  @Status [Status]  ,    
--  @RequestedBy RequestedBy ,    
--  @RequestedDate RequestedDate  ,    
--  @PendingSince PendingSince,  
--  @AuthorisedSongsCount AuthorisedSongsCount,  
--  @PendingCount PendingCount  
  
--END 


--select * from MHUsers  
--select MHRequestSatusCode from MHRequestStatus  
--sp_Help  MHRequestStatus  
--select * from  MHRequest  where MHRequestTypeCode = 1
--select * from  MHRequestDetails  
--DECLARE @RC INT  
--exec USPMHRequisitionList 0,'',0,'','',0,'',1,10, @RC

--Select * From MHRequestDetails