CREATE Function [dbo].[UFN_Get_Acq_Ancillary_Platform_AT]
(
	@AT_Acq_Deal_Ancillary_Code INT
)
RETURNS NVARCHAR(max)       
AS      
BEGIN       
	DECLARE @PlatformName NVARCHAR(3000)
	SET @PlatformName = ''
	SELECT @PlatformName = STUFF ((SELECT DISTINCT ', '+ISNULL(AP.Platform_Name,'') 
	FROM AT_Acq_Deal_Ancillary_Platform AADAP
	INNER JOIN Ancillary_Platform AP On AADAP.Ancillary_Platform_code = AP.Ancillary_Platform_code
	WHERE AADAP.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code                   
	FOR XML PATH(''))                   
	, 1, 1, '')                    

	RETURN @PlatformName                       

END
