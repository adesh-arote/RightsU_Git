






CREATE PROCEDURE [dbo].[USP_BMS_GetDealContentsRights]
(
	@since VARCHAR(50),
	@AssetId VARCHAR(50),
	@DealId VARCHAR(50)
)
AS

BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetDealContentsRights]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	DECLARE @BMS_API_Deal_Prefix as VARCHAR(10),@BMS_API_Asset_Prefix VARCHAR(50),@BMS_API_DealContent_Prefix VARCHAR(50),@BMS_API_DealContentRights_Prefix VARCHAR(50),@BMS_API_Channel_Prefix VARCHAR(50)
	DECLARE @BMS_API_Since_Days INT
	SET @BMS_API_Deal_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Deal_Prefix')
	SET @BMS_API_Asset_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Asset_Prefix')
	SET @BMS_API_DealContent_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_DealContent_Prefix')
	SET @BMS_API_DealContentRights_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_DealContentRights_Prefix')
	SET @BMS_API_Channel_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Channel_Prefix')
	SET @BMS_API_Since_Days = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Since_Days')

	IF(ISNULL(@since,'')='')
	BEGIN
		SET @since = CAST(DATEADD(day,-@BMS_API_Since_Days,GETDATE()) as DATE)
	END
	

	DECLARE @Params NVARCHAR(MAX) = '';
	IF(ISNULL(@AssetId,'')<>'' AND ISNULL(@DealId,'')<>'')
	BEGIN
		SELECT DISTINCT 
			@BMS_API_DealContentRights_Prefix+CAST(BDCR.BMS_Deal_Content_Rights_Code as VARCHAR) as 'DealContentRightsId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Channel_Prefix+CAST(BDCR.RU_Channel_Code as VARCHAR) as 'ChannelId',
			ISNULL(RR.Right_Rule_Name,'') as 'RightRule',
			RR.Play_Per_Day as 'RRPlayPerDay',
			RR.No_Of_Repeat as 'RRNoOfRepeats',
			RR.Duration_of_Day as 'RRDuration',
			@BMS_API_Asset_Prefix+CAST(BDCR.BMS_Asset_Code as VARCHAR) as 'AssetId',
			BDCR.Total_Runs as 'DaysAvailable',
			FORMAT(BDCR.Start_Date,'yyyy-MM-dd') as 'LicenseStartDate',
			FORMAT(BDCR.End_Date,'yyyy-MM-dd') as 'LicenseEndDate',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDCR.Updated_On,BDCR.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDCR.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content_Rights BDCR (NOLOCK)
		INNER JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Deal_Content_Code=BDCR.BMS_Deal_Content_Code		
		LEFT JOIN Right_Rule RR (NOLOCK) ON BDCR.RU_Right_Rule_Code=RR.Right_Rule_Code
		WHERE ISNULL(BDCR.Updated_On,BDCR.Created_On) >= CONVERT(Datetime,@since, 120) AND BDCR.BMS_Asset_Code =@AssetId AND BDC.BMS_Deal_Code =@DealId

		--SET @Params += ' AND BDC.BMS_Asset_Code ='+@AssetId+' AND BDC.BMS_Deal_Code ='+@DealId
	END
	ELSE IF(ISNULL(@AssetId,'')<>'')
	BEGIN

		SELECT DISTINCT 
			@BMS_API_DealContentRights_Prefix+CAST(BDCR.BMS_Deal_Content_Rights_Code as VARCHAR) as 'DealContentRightsId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Channel_Prefix+CAST(BDCR.RU_Channel_Code as VARCHAR) as 'ChannelId',
			ISNULL(RR.Right_Rule_Name,'') as 'RightRule',
			RR.Play_Per_Day as 'RRPlayPerDay',
			RR.No_Of_Repeat as 'RRNoOfRepeats',
			RR.Duration_of_Day as 'RRDuration',
			@BMS_API_Asset_Prefix+CAST(BDCR.BMS_Asset_Code as VARCHAR) as 'AssetId',
			BDCR.Total_Runs as 'DaysAvailable',
			FORMAT(BDCR.Start_Date,'yyyy-MM-dd') as 'LicenseStartDate',
			FORMAT(BDCR.End_Date,'yyyy-MM-dd') as 'LicenseEndDate',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDCR.Updated_On,BDCR.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDCR.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content_Rights BDCR (NOLOCK)
		INNER JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Deal_Content_Code=BDCR.BMS_Deal_Content_Code		
		LEFT JOIN Right_Rule RR (NOLOCK) ON BDCR.RU_Right_Rule_Code=RR.Right_Rule_Code
		WHERE ISNULL(BDCR.Updated_On,BDCR.Created_On) >= CONVERT(Datetime,@since, 120) AND BDCR.BMS_Asset_Code =@AssetId
		--SET @Params += ' AND BDC.BMS_Asset_Code ='+@AssetId
	END
	ELSE IF(ISNULL(@DealId,'')<>'')
	BEGIN
		SELECT DISTINCT 
			@BMS_API_DealContentRights_Prefix+CAST(BDCR.BMS_Deal_Content_Rights_Code as VARCHAR) as 'DealContentRightsId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Channel_Prefix+CAST(BDCR.RU_Channel_Code as VARCHAR) as 'ChannelId',
			ISNULL(RR.Right_Rule_Name,'') as 'RightRule',
			RR.Play_Per_Day as 'RRPlayPerDay',
			RR.No_Of_Repeat as 'RRNoOfRepeats',
			RR.Duration_of_Day as 'RRDuration',
			@BMS_API_Asset_Prefix+CAST(BDCR.BMS_Asset_Code as VARCHAR) as 'AssetId',
			BDCR.Total_Runs as 'DaysAvailable',
			FORMAT(BDCR.Start_Date,'yyyy-MM-dd') as 'LicenseStartDate',
			FORMAT(BDCR.End_Date,'yyyy-MM-dd') as 'LicenseEndDate',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDCR.Updated_On,BDCR.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDCR.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content_Rights BDCR (NOLOCK)
		INNER JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Deal_Content_Code=BDCR.BMS_Deal_Content_Code		
		LEFT JOIN Right_Rule RR (NOLOCK) ON BDCR.RU_Right_Rule_Code=RR.Right_Rule_Code
		WHERE ISNULL(BDCR.Updated_On,BDCR.Created_On) >= CONVERT(Datetime,@since, 120) AND BDC.BMS_Deal_Code =@DealId

		--SET @Params += ' AND BDC.BMS_Deal_Code ='+@DealId
	END
	ELSE
	BEGIN
		SELECT DISTINCT 
			@BMS_API_DealContentRights_Prefix+CAST(BDCR.BMS_Deal_Content_Rights_Code as VARCHAR) as 'DealContentRightsId',
			@BMS_API_Deal_Prefix+CAST(BDC.BMS_Deal_Code as VARCHAR) as 'DealId',
			@BMS_API_DealContent_Prefix+CAST(BDC.BMS_Deal_Content_Code as VARCHAR) as 'DealContentId',
			@BMS_API_Channel_Prefix+CAST(BDCR.RU_Channel_Code as VARCHAR) as 'ChannelId',
			ISNULL(RR.Right_Rule_Name,'') as 'RightRule',
			RR.Play_Per_Day as 'RRPlayPerDay',
			RR.No_Of_Repeat as 'RRNoOfRepeats',
			RR.Duration_of_Day as 'RRDuration',
			@BMS_API_Asset_Prefix+CAST(BDCR.BMS_Asset_Code as VARCHAR) as 'AssetId',
			BDCR.Total_Runs as 'DaysAvailable',
			FORMAT(BDCR.Start_Date,'yyyy-MM-dd') as 'LicenseStartDate',
			FORMAT(BDCR.End_Date,'yyyy-MM-dd') as 'LicenseEndDate',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BDCR.Updated_On,BDCR.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BDCR.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal_Content_Rights BDCR (NOLOCK)
		INNER JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Deal_Content_Code=BDCR.BMS_Deal_Content_Code		
		LEFT JOIN Right_Rule RR (NOLOCK) ON BDCR.RU_Right_Rule_Code=RR.Right_Rule_Code
		WHERE ISNULL(BDCR.Updated_On,BDCR.Created_On) >= CONVERT(Datetime,@since, 120)

		--SET @Params += ' ISNULL(BDC.Updated_On,BDC.Created_On) ='+@since
	END

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetDealContentsRights]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END