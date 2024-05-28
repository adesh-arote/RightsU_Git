


CREATE VIEW [dbo].[TitleRights_AutoComplete]
AS
SELECT DISTINCT adrt.Title_Code,
       ad.Deal_Type_Code, 
	   adr.Actual_Right_End_Date, 
	   adr.Is_Sub_License,
	   ad.Business_Unit_Code
FROM RightsU_Plus_Testing.dbo.Acq_Deal ad 
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Title adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
--INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Movie adrm ON  adr.Acq_Deal_Code = adrm.Acq_Deal_Code
WHERE ISNULL(adr.Right_Type, '') <> ''
