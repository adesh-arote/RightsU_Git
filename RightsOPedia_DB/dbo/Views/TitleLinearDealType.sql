



CREATE VIEW [dbo].[TitleLinearDealType]
AS
SELECT DISTINCT ad.Acq_Deal_Code, ad.Deal_Type_Code, adrt.Title_Code, adr.Acq_Deal_Rights_Code, adr.Actual_Right_Start_Date, 
	   adr.Actual_Right_End_Date, adr.Is_Sub_License, adrt.Episode_From, adrt.Episode_To, ad.Business_Unit_Code
FROM RightsU_Plus_Testing.dbo.Acq_Deal ad With (NOLOCK)
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights adr With (NOLOCK) ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Title adrt With (NOLOCK) ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
WHERE ISNULL(adr.Right_Type, '') <> ''
