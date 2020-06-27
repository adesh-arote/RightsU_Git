CREATE FUNCTION [dbo].[UFN_Get_Acq_Ancillary_Medium_BaseOn_AncillaryCode_AT]
(
	@AT_Acq_Deal_Ancillary_Code INT
)
RETURNS NVARCHAR(MAX)       
AS      
BEGIN       
	DECLARE @MediumName NVARCHAR(1000)
	SET @MediumName = ''
	SELECT @MediumName = STUFF ((SELECT DISTINCT ', '+ISNULL(AM.Ancillary_Medium_Name,'') FROM AT_Acq_Deal_Ancillary_Platform_Medium ADAPM
	Inner Join AT_Acq_Deal_Ancillary_Platform ADAP ON ADAPM.AT_Acq_Deal_Ancillary_Platform_Code=ADAP.AT_Acq_Deal_Ancillary_Platform_Code
	Inner join Ancillary_Platform_Medium APM ON ADAPM.Ancillary_Platform_Medium_Code = APM.Ancillary_Platform_Medium_Code
	INNER JOIN Ancillary_Medium AM ON APM.Ancillary_Medium_Code = AM.Ancillary_Medium_Code 
	INNER JOIN AT_Acq_Deal_Ancillary ADA ON ADA.AT_Acq_Deal_Ancillary_Code = ADAP.AT_Acq_Deal_Ancillary_Code
	WHERE ADA.AT_Acq_Deal_Ancillary_Code= @AT_Acq_Deal_Ancillary_Code                   
	FOR XML PATH(''))                   
	, 1, 1, '')                    
	RETURN @MediumName                       
END 