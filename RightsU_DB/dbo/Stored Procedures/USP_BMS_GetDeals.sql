


CREATE PROCEDURE [dbo].[USP_BMS_GetDeals]
(
	@since VARCHAR(50),
	@AssetId VARCHAR(50)
)
AS

BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetDeals]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	DECLARE @BMS_API_Deal_Prefix as VARCHAR(10)
	DECLARE @BMS_API_Since_Days INT

	SET @BMS_API_Deal_Prefix = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Deal_Prefix')
	SET @BMS_API_Since_Days = (SELECT top 1 Parameter_Value FROM System_Parameter_New Where Parameter_Name='BMS_API_Since_Days')

	IF(ISNULL(@since,'')='')
	BEGIN
		SET @since = CAST(DATEADD(day,-@BMS_API_Since_Days,GETDATE()) as DATE)
	END

	IF(ISNULL(@AssetId,'')<>'')
	BEGIN

		SELECT DISTINCT
			@BMS_API_Deal_Prefix+CAST(BD.BMS_Deal_Code as VARCHAR) as 'DealId',
			BD.Lic_Ref_No as 'AgreementNo',
			FORMAT(BD.Acquisition_Date,'dd-MMM-yyyy') as 'AcquisitionDate',
			BD.Description as 'Description',
			V.Vendor_Name as 'Licensor',
			C.Currency_Name as 'Currency',
			E.Entity_Name as 'Licensee',
			CT.Category_Name as 'DealCategory',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BD.Updated_On,BD.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BD.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal BD (NOLOCK)
		INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code=BD.RU_Licensor_Code
		INNER JOIN Currency C (NOLOCK) ON C.Currency_Code=BD.RU_Currency_Code
		INNER JOIN Entity E (NOLOCK) ON E.Entity_Code=BD.RU_Licensee_Code	
		INNER JOIN Category CT (NOLOCK) ON CT.Category_Code=BD.RU_Category_Code
		LEFT JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Deal_Code=BD.BMS_Deal_Code
		WHERE BDC.BMS_Asset_Code=@AssetId AND ISNULL(BD.Updated_On,BD.Created_On) >= @since

	END
	ELSE
	BEGIN

		SELECT DISTINCT
			@BMS_API_Deal_Prefix+CAST(BD.BMS_Deal_Code as VARCHAR) as 'DealId',
			BD.Lic_Ref_No as 'AgreementNo',
			FORMAT(BD.Acquisition_Date,'dd-MMM-yyyy') as 'AcquisitionDate',
			BD.Description as 'Description',
			V.Vendor_Name as 'Licensor',
			C.Currency_Name as 'Currency',
			E.Entity_Name as 'Licensee',
			CT.Category_Name as 'DealCategory',
			FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BD.Updated_On,BD.Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
			CASE WHEN BD.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
		FROM BMS_Deal BD (NOLOCK)
		INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code=BD.RU_Licensor_Code
		INNER JOIN Currency C (NOLOCK) ON C.Currency_Code=BD.RU_Currency_Code
		INNER JOIN Entity E (NOLOCK) ON E.Entity_Code=BD.RU_Licensee_Code	
		INNER JOIN Category CT (NOLOCK) ON CT.Category_Code=BD.RU_Category_Code
		LEFT JOIN BMS_Deal_Content BDC (NOLOCK) ON BDC.BMS_Deal_Code=BD.BMS_Deal_Code
		WHERE ISNULL(BD.Updated_On,BD.Created_On) >= @since

	END


	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetDeals]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END