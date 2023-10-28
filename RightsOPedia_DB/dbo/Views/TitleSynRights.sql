







CREATE VIEW [dbo].[TitleSynRights]
AS
SELECT DISTINCT ad.Syn_Deal_Code, ad.Deal_Type_Code, ad.Vendor_Code, ad.Business_Unit_Code, adrt.Title_Code, adrt.Episode_From, adrt.Episode_To, adr.Syn_Deal_Rights_Code, adr.Right_Type, adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date, adr.Is_Exclusive, adr.Is_Sub_License
FROM RightsU_Plus_Testing.dbo.Syn_Deal ad
INNER JOIN RightsU_Plus_Testing.dbo.Syn_Deal_Rights adr ON ad.Syn_Deal_Code = adr.Syn_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Syn_Deal_Rights_Title adrt ON adr.Syn_Deal_Rights_Code = adrt.Syn_Deal_Rights_Code
WHERE ISNULL(adr.Right_Type, '') <> '' --AND ISNULL(Is_Tentative, 'N') = 'N'
AND adr.Syn_Deal_Rights_Code IN (
	SELECT DISTINCT Syn_Deal_Rights_Code FROM RightsU_Plus_Testing.dbo.Syn_Deal_Rights_Platform
	--UNION
	--SELECT DISTINCT Syn_Deal_Rights_Code FROM RightsU_Plus_Testing.dbo.Syn_Deal_Rights_Ancillary
)





