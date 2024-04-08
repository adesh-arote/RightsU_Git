


CREATE PROCEDURE [dbo].[USP_BMS_GetAssets]
(
	@since VARCHAR(50)
)
AS

BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetAssets]', 'Step 1', 0, 'Started Procedure', 0, ''
	
	
	SELECT 
		'RUBMSA'+CAST(BA.BMS_Asset_Code as VARCHAR) as 'AssetId',
		BA.Title,
		CASE WHEN BA.Episode_Title IS NULL THEN BA.Title ELSE CONCAT(BA.Title ,' ep',BA.Episode_Number)  END as 'EpisodeTitle',
		BA.Episode_Number as EpisodeNumber,
		DT.Deal_Type_Name as 'Category',
		L.Language_Name as 'Language',
		--LTRIM(DATEDIFF(MINUTE, 0, PARSE(BA.Duration as TIME))) as 'Duration',
		T.Duration_In_Min as 'Duration',
		FORMAT(DATEADD(MI, (DATEDIFF(MI, SYSDATETIME(), SYSUTCDATETIME())), ISNULL(BA.Updated_On,Created_On)),'yyyy-MM-ddTHH:mm') as 'LastUpdatedOn',		
		CASE WHEN BA.Is_Active='Y' THEN 'true' ELSE 'false' END as 'IsActive'
	FROM BMS_Asset BA (NOLOCK)
	INNER JOIN Title T (NOLOCK) ON T.Title_Code=BA.RU_Title_Code
	INNER JOIN Deal_Type DT (NOLOCK) ON T.Deal_Type_Code=DT.Deal_Type_Code
	INNER JOIN Language L (NOLOCK) ON BA.Language_Code=L.Language_Code
	WHERE ISNULL(Updated_On,Created_On) >= @since


	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_GetAssets]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END