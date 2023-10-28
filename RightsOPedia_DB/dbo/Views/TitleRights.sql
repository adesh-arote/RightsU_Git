





CREATE VIEW [dbo].[TitleRights]
AS
SELECT DISTINCT ad.Acq_Deal_Code, ad.Deal_Type_Code, ad.Vendor_Code, ad.Business_Unit_Code, adrt.Title_Code, adrt.Episode_From, adrt.Episode_To, adr.Acq_Deal_Rights_Code, adr.Right_Type, adr.Actual_Right_Start_Date, 
	   adr.Actual_Right_End_Date, adr.Is_Exclusive, adr.Is_Sub_License, --adrm.Linear_Nuance,
	   adrm.Acq_Deal_Movie_Code--,adrm.Sport_Brand_Code
	   ,ad.Remarks,
	   CASE WHEN sl.Sub_License_Name IS NULL THEN 'No' Else sl.Sub_License_Name End AS Sub_License_Name--, r.ROFR_Type,adr.ROFR_Date,adr.Is_ROFR
FROM RightsU_Plus_Testing.dbo.Acq_Deal ad With (NOLOCK)
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr With (NOLOCK) ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Title adrt With (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Movie adrm With (NOLOCK) ON  adr.Acq_Deal_Code = adrm.Acq_Deal_Code --AND ((ad.Deal_Type_Code <> 27 
--AND adrm.Title_Code = adrt.Title_Code AND adrm.Episode_Starts_From = adrt.Episode_From AND adrm.Episode_End_To = adrt.Episode_To) OR (ad.Deal_Type_Code = 27 AND adrm.Acq_Deal_Movie_Code = adrt.Acq_Deal_Movie_Code))
LEFT JOIN RightsU_Plus_Testing.dbo.Sub_License sl ON sl.Sub_License_Code = adr.Sub_License_Code
--LEFT JOIN RightsU_Plus_Testing.dbo.ROFR r ON r.ROFR_Code = adr.ROFR_Code
WHERE ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(adr.PA_Right_Type, '') <> 'AR' --AND ISNULL(Is_Tentative, 'N') = 'N'

--AND adr.Acq_Deal_Rights_Code IN (
--	SELECT DISTINCT Acq_Deal_Rights_Code FROM RightsU_29SEP..Acq_Deal_Rights_Platform
--	--UNION
--	--SELECT DISTINCT Acq_Deal_Rights_Code FROM RightsU_29SEP..Acq_Deal_Rights_Ancillary
--)
