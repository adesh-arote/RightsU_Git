CREATE PROCEDURE  [dbo].[USPMHGetChartPopupList]
	@MHRequestCode  VARCHAR(MAX) = '',
	@ProdHouseCode VARCHAR(MAX) = '',
	@DealTypeCode VARCHAR(MAX) = '',
	@BusinessUnitCode VARCHAR(MAX) = '',
	@StatusCode VARCHAR(MAX) = '',  
	@CallFor VARCHAR(MAX) = '',
	@PageNo INT = 1,
	@PageSize INT = 99,
	@RecordCount INT  OUT

--Created By : Darshana
--Created On : 30 July 2018
 AS  
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetChartPopupList]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF(OBJECT_ID('TEMPDB..#TempMHRequestCode') IS NOT NULL)  
			DROP TABLE #TempMHRequestCode

		IF(OBJECT_ID('TEMPDB..#TempRightsPagingData') IS NOT NULL)  
			DROP TABLE #TempRightsPagingData  

		CREATE TABLE #TempRightsPagingData  
		(
			Row_No INT IDENTITY(1,1), 
			ShowName NVARCHAR(MAX),  
			EpisodeNo VARCHAR(MAX) ,
			MusicTrackName  NVARCHAR(MAX),
			MovieAlbumName  NVARCHAR(MAX),
			Remarks NVARCHAR(MAX),
			MovieLanguage VARCHAR(MAX) ,
			YearOfRelease VARCHAR(MAX) 
		)

		SELECT distinct MRD.MHRequestCode INTO #TempMHRequestCode
		FROM MHRequestDetails MRD (NOLOCK)
		WHERE  MRD.MHRequestCode IN(
		select MHRequestCode
		From MHRequest MR  (NOLOCK)
		LEFT Join Title T (NOLOCK) ON MR.TitleCode = T.Title_Code
		LEFT Join Music_Deal_LinkShow MDL (NOLOCK) ON T.Title_Code = MDL.Title_Code 
		LEFT Join Music_Deal MD (NOLOCK) ON MD.Music_Deal_Code = MDL.Music_Deal_Code
		Where  
		(@BusinessUnitCode = '' OR MD.Business_Unit_Code IN(select number from dbo.fn_Split_withdelemiter(''+@BusinessUnitCode+'',','))) 
		 and  MR.MHRequestTypeCode = 1	
		)  
	 
		If (@PageNo = 0)
			Set @PageNo = 1

		Declare 
		@LastRequiredDate VARCHAR(20) = '',
		@RequestCode VARCHAR(20) = ''
		select @RequestCode = number from dbo.fn_Split_withdelemiter(@MHRequestCode,'~') where id = 1
		select @LastRequiredDate = number from dbo.fn_Split_withdelemiter(@MHRequestCode,'~') where id = 2
 	
		INSERT INTO #TempRightsPagingData  
		(  
			ShowName, EpisodeNo, MusicTrackName, MovieAlbumName, Remarks
		) 
	
		SELECT 
			T.Title_Name 
			,CASE WHEN ISNULL(MR.EpisodeFrom,0)  < ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX)) +' - '+ CAST(MR.EpisodeTo AS VARCHAR(MAX))
				 WHEN ISNULL(MR.EpisodeFrom,0)  = ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX))
			ELSE '' END
			,MT.Music_Title_Name
			,MA.Music_Album_Name
			,MR.Remarks	
		FROM MHRequest MR  (NOLOCK)
		Inner JOIN #TempMHRequestCode TMHR ON TMHR.MHRequestCode = MR.MHRequestCode
		Inner JOIN MHRequestDetails MRD (NOLOCK) ON MRD.MHRequestCode = TMHR.MHRequestCode 
		LEFT JOIN Title T (NOLOCK) ON T.Title_Code = MR.TitleCode
		LEFT JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = MRD.MusicTitleCode
		LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
		LEFT JOIN Vendor V  (NOLOCK) ON V.Vendor_Code = MR.VendorCode
		WHERE  MR.MHRequestTypeCode = 1 
		AND (@RequestCode = '' OR MR.MHRequestCode IN(CAST (@RequestCode as INT)))
		AND (CONVERT(DATE,MR.RequestedDate,103)  >= (CONVERT(DATE,@LastRequiredDate,103)))
		AND (@ProdHouseCode='' OR MR.VendorCode  IN( select number from dbo.fn_Split_withdelemiter(@ProdHouseCode,',')))
		AND (@StatusCode = '' OR MR.MHRequestStatusCode in (select number from dbo.fn_Split_withdelemiter(''+@StatusCode+'',',')))
		AND (@DealTypeCode = '' OR T.Deal_Type_Code in (select number from dbo.fn_Split_withdelemiter(''+@DealTypeCode+'',','))) 
	
		SELECT @RecordCount = COUNT(*) FROM #TempRightsPagingData  
  
		DELETE from  #TempRightsPagingData  
		WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)  

		SELECT ShowName, EpisodeNo , MusicTrackName, MovieAlbumName, Remarks, MovieLanguage, YearOfRelease  from #TempRightsPagingData  
	
		IF OBJECT_ID('tempdb..#TempMHRequestCode') IS NOT NULL DROP TABLE #TempMHRequestCode
		IF OBJECT_ID('tempdb..#TempRightsPagingData') IS NOT NULL DROP TABLE #TempRightsPagingData
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetChartPopupList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END