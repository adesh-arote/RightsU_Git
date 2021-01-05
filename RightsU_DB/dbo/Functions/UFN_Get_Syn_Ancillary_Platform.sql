
CREATE FUNCTION [dbo].[UFN_Get_Syn_Ancillary_Platform]
(
	@Syn_Deal_Ancillary_Code INT
)
RETURNS NVARCHAR(max)       
AS      
BEGIN       
	DECLARE @PlatformName NVARCHAR(3000)
	SET @PlatformName = ''
	SELECT @PlatformName = STUFF ((SELECT DISTINCT ', '+ISNULL(AP.Platform_Name,'') 
	FROM Syn_Deal_Ancillary_Platform ADAP
	INNER JOIN Ancillary_Platform AP On ADAP.Ancillary_Platform_code = AP.Ancillary_Platform_code
	WHERE ADAP.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code                   
	FOR XML PATH(''))                   
	, 1, 1, '')                    

	RETURN @PlatformName                       
END      
