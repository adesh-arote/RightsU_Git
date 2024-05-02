


CREATE PROCEDURE [dbo].[USP_BMS_GetDealContents]
(
	@since VARCHAR(50),
	@AssetId VARCHAR(50),
	@DealId VARCHAR(50)
)
AS

BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetDealContents]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	DECLARE @BMS_API_Deal_Prefix as VARCHAR(10),@BMS_API_Asset_Prefix VARCHAR(50),@BMS_API_DealContent_Prefix VARCHAR(50)
	DECLARE @BMS_API_Since_Days INT

	SET @BMS_API_Deal_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Deal_Prefix')
	SET @BMS_API_Asset_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Asset_Prefix')
	SET @BMS_API_DealContent_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_DealContent_Prefix')
	SET @BMS_API_Since_Days = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Since_Days')

	IF(ISNULL(@since,'')='')
	BEGIN
		SET @since = CAST(DATEADD(day,-@BMS_API_Since_Days,GETDATE()) as DATE)
	END

	DECLARE @Params NVARCHAR(MAX) = '';
	IF(ISNULL(@AssetId,'')<>'' AND ISNULL(@DealId,'')<>'')
	BEGIN
		SELECT DISTINCT 
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_Asset_Prefix+CAST(BDC.BMS_Asset_Code as VARCHAR) as 'AssetId',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDC.Updated_On,BDC.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDC.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content BDC (NOLOCK)
		INNER JOIN BMS_Deal BD (NOLOCK) ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code		
		WHERE ISNULL(BDC.Updated_On,BDC.Created_On) >=@since AND BDC.BMS_Asset_Code =@AssetId AND BDC.BMS_Deal_Code =@DealId

		--SET @Params += ' AND BDC.BMS_Asset_Code ='+@AssetId+' AND BDC.BMS_Deal_Code ='+@DealId
	END
	ELSE IF(ISNULL(@AssetId,'')<>'')
	BEGIN

		SELECT DISTINCT 
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_Asset_Prefix+CAST(BDC.BMS_Asset_Code as VARCHAR) as 'AssetId',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDC.Updated_On,BDC.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDC.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content BDC (NOLOCK)
		INNER JOIN BMS_Deal BD (NOLOCK) ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code		
		WHERE ISNULL(BDC.Updated_On,BDC.Created_On) >=@since AND BDC.BMS_Asset_Code =@AssetId
		--SET @Params += ' AND BDC.BMS_Asset_Code ='+@AssetId
	END
	ELSE IF(ISNULL(@DealId,'')<>'')
	BEGIN
		SELECT DISTINCT 
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_Asset_Prefix+CAST(BDC.BMS_Asset_Code as VARCHAR) as 'AssetId',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDC.Updated_On,BDC.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDC.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content BDC (NOLOCK)
		INNER JOIN BMS_Deal BD (NOLOCK) ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code		
		WHERE ISNULL(BDC.Updated_On,BDC.Created_On) >=@since AND BDC.BMS_Deal_Code =@DealId

		--SET @Params += ' AND BDC.BMS_Deal_Code ='+@DealId
	END
	ELSE
	BEGIN
		SELECT DISTINCT 
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_Asset_Prefix+CAST(BDC.BMS_Asset_Code as VARCHAR) as 'AssetId',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDC.Updated_On,BDC.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDC.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content BDC (NOLOCK)
		INNER JOIN BMS_Deal BD (NOLOCK) ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code		
		WHERE ISNULL(BDC.Updated_On,BDC.Created_On) >=@since

		--SET @Params += ' ISNULL(BDC.Updated_On,BDC.Created_On) ='+@since
	END

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetDealContents]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END