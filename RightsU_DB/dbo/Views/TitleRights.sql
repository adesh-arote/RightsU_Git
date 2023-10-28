CREATE VIEW [dbo].[TitleRights]
AS
SELECT DISTINCT ad.Acq_Deal_Code, ad.Deal_Type_Code, ad.Vendor_Code, ad.Business_Unit_Code, adrt.Title_Code, adrt.Episode_From, adrt.Episode_To, adr.Acq_Deal_Rights_Code, adr.Right_Type, adr.Actual_Right_Start_Date, 
	   adr.Actual_Right_End_Date, adr.Is_Exclusive, adr.Is_Sub_License,adrm.Acq_Deal_Movie_Code,ad.Remarks,CASE WHEN sl.Sub_License_Name IS NULL THEN 'No' Else sl.Sub_License_Name End AS Sub_License_Name
FROM Acq_Deal ad With (NOLOCK)
INNER JOIN Acq_Deal_Rights adr With (NOLOCK) ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
INNER JOIN Acq_Deal_Rights_Title adrt With (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
INNER JOIN Acq_Deal_Movie adrm With (NOLOCK) ON  adr.Acq_Deal_Code = adrm.Acq_Deal_Code
LEFT JOIN Sub_License sl ON sl.Sub_License_Code = adr.Sub_License_Code
WHERE ISNULL(adr.Right_Type, '') <> ''