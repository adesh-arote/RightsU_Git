


CREATE VIEW [dbo].[SynTitleRights]
AS
Select DISTINCT sd.Syn_Deal_Code, sd.Deal_Type_Code, sd.Vendor_Code, sd.Business_Unit_Code, sdrt.Title_Code, sdrt.Episode_From, sdrt.Episode_To, sdr.Syn_Deal_Rights_Code, sdr.Right_Type, sdr.Actual_Right_Start_Date, 
	   sdr.Actual_Right_End_Date, sdr.Is_Exclusive, sdr.Is_Sub_License, 
	   sdrm.Syn_Deal_Movie_Code
	   ,sd.Remarks,
	   CASE WHEN sl.Sub_License_Name IS NULL THEN 'No' Else sl.Sub_License_Name End AS Sub_License_Name
FROM RightsU_Plus_Testing.dbo.Syn_Deal sd With (NOLOCK)
INNER JOIN RightsU_Plus_Testing.dbo.Syn_Deal_Rights sdr With (NOLOCK) ON sd.Syn_Deal_Code = sdr.Syn_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Syn_Deal_Rights_Title sdrt With (NOLOCK) ON sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code
INNER JOIN RightsU_Plus_Testing.dbo.Syn_Deal_Movie sdrm With (NOLOCK) ON  sdr.Syn_Deal_Code = sdrm.Syn_Deal_Code
LEFT JOIN RightsU_Plus_Testing.dbo.Sub_License sl ON sl.Sub_License_Code = sdr.Sub_License_Code
WHERE ISNULL(sdr.Right_Type, '') <> '';
