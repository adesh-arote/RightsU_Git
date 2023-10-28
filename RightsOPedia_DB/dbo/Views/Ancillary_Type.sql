


CREATE VIEW [dbo].[Ancillary_Type]
AS
SELECT DISTINCT ad.Acq_Deal_Code, adat.Title_Code, ada.Ancillary_Type_code, anct.Ancillary_Type_Name,
CASE 
	WHEN anct.Ancillary_Type_code = 1 THEN 
		CASE WHEN ISNULL(CAST([Day] AS NVARCHAR(max)), '') <> '' THEN CAST([Day] AS NVARCHAR(MAX)) + ' Day with ' ELSE '' END + 
		CASE WHEN ISNULL(Catch_Up_From, '') = 'E' THEN  'Each Broadcast' ELSE 'First Broadcast' END + 
		CASE WHEN ISNULL(ada.Remarks, '') <> '' THEN 'and Remark is ' + ada.Remarks ELSE '' END
	WHEN anct.Ancillary_Type_code = 8 THEN 
		CASE WHEN ISNULL(CAST(ada.Duration AS nvarchar),'') <> '' THEN '; ' + ISNULL(CAST(ada.Duration AS nvarchar),'') + ' Sec' ELSE '' END 
	ELSE ISNULL(ada.Remarks, '')
END	
AS AncillaryValue
FROM RightsU_Plus_Testing.dbo.Acq_Deal ad
--INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Ancillary ada ON ada.Acq_Deal_Code = ad.Acq_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Ancillary_Title adat ON adat.Acq_Deal_Ancillary_Code = ada.Acq_Deal_Ancillary_Code
INNER JOIN RightsU_Plus_Testing.dbo.Ancillary_Type anct ON anct.Ancillary_Type_Code = ada.Ancillary_Type_code

