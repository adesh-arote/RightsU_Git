CREATE VIEW [dbo].[VW_Acq_Deals]  
AS  
SELECT DISTINCT  T.Title_Code, T.Original_Title, T.Title_Name, ADM.No_Of_Episodes, 
ADRP.Platform_Code, P.Platform_Hiearachy AS Platform_Name, 
AD.Vendor_Code, V.Vendor_Name,
AD.Deal_Type_Code,ADT.Deal_Type_Name,
TT_Dir.Talent_Code AS Director_Code,  
DBO.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) AS Director_Names_Comma_Seperate, 
TT_SC.Talent_Code AS Start_Cast_Code, 
DBO.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) AS Star_Cast_Names_Comma_Seperate,
DBO.UFN_Get_Title_Genre(T.Title_Code) AS Genre_Names_Comma_Seperate,TG.Genres_Code AS Genres_Code,
ADR.Right_Start_Date, ADR.Right_End_Date, 
ADRTer.Country_Code, COU.Country_Name,
CASE 
	WHEN (SELECT COUNT(Acq_Deal_Rights_Holdback_Code) FROM Acq_Deal_Rights_Holdback WHERE Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' 
END AS Is_Holdback, AD.Currency_Code, CUR.Currency_Name, AD.Entity_Code, E.Entity_Name, 
ADC.Deal_Cost, ISNULL(ADC.Variable_Cost_Type, 'N') AS Variable_Cost_Type, 
AD.Agreement_No, ad.Deal_Desc, AD.Deal_Tag_Code, DT.Deal_Tag_Description, AD.Business_Unit_Code, BU.Business_Unit_Name,  ADR.Is_Sub_License, 
DBO.UFN_Get_Rights_Subtitling(ADR.Acq_Deal_Rights_Code, 'A') AS Subtitling_Languages, DBO.UFN_Get_Rights_Dubbing(ADR.Acq_Deal_Rights_Code, 'A') AS Dubbing_Languages, 
ADM.Acq_Deal_Movie_Code, NULL AS Holdback_Detail, 
CASE ISNULL(ADR.Is_ROFR, '') WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ROFR, ADR.Restriction_Remarks,
TA.Title_Name AS Alternate_Title_Name,
TA.Original_Title AS Alternate_Original_Title,
LG.Language_Name AS Alternate_Language,
GN.Genres_Name AS Alternate_Genres_Name,
TALENT_Dir.Talent_Name AS Title_Director,
TALENT_SC.Talent_Name AS Title_Star_Cast
from Acq_Deal AD
INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
INNER JOIN Deal_Type ADT ON ADT.Deal_Type_Code = AD.Deal_Type_Code
INNER JOIN Currency CUR ON CUR.Currency_Code = AD.Currency_Code
INNER JOIN Entity E ON E.Entity_Code = AD.Entity_Code
INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
INNER JOIN Deal_Tag DT ON DT.Deal_Tag_Code = AD.Deal_Tag_Code
INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
LEFT JOIN Title_Talent TT_Dir ON TT_Dir.Title_Code = T.Title_Code AND TT_Dir.Role_Code = 1
LEFT JOIN Talent Tal_Dir ON Tal_Dir.Talent_Code = TT_Dir.Talent_Code
LEFT JOIN Title_Talent TT_SC ON TT_SC.Title_Code = T.Title_Code AND TT_SC.Role_Code = 2
LEFT JOIN Talent Tal_SC ON Tal_SC.Talent_Code = TT_SC.Talent_Code
LEFT JOIN Title_Geners TG ON TG.Title_Code = T.Title_Code 
LEFT JOIN Title_Alternate TA ON TA.Title_Code = T.Title_Code 
LEFT JOIN LANGUAGE LG ON LG.Language_Code = TA.Title_Language_Code 
LEFT JOIN Title_Alternate_Genres TAG ON TAG.Title_Alternate_Code= TA.Title_Alternate_Code 
LEFT JOIN Genres GN ON GN.Genres_Code = TAG.Genres_Code 
LEFT JOIN Title_Alternate_Talent TAT_Dir ON TAT_Dir.Title_Alternate_Code = TA.Title_Alternate_Code AND TAT_Dir.Role_Code = 1
LEFT JOIN Talent TALENT_Dir ON TALENT_Dir.Talent_Code = TAT_Dir.Talent_Code
LEFT JOIN Title_Alternate_Talent TAT_SC ON TAT_SC.Title_Alternate_Code = TA.Title_Alternate_Code AND TAT_SC.Role_Code = 2
LEFT JOIN Talent TALENT_SC ON TALENT_SC.Talent_Code = TAT_SC.Talent_Code 
INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADRT.Title_Code = ADM.Title_Code
INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
INNER JOIN Platform P ON P.Platform_Code = ADRP.Platform_Code
INNER JOIN (
	Select srter.Acq_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code From (
		Select Acq_Deal_Rights_Code, Territory_Code, Country_Code, Territory_Type 
		From Acq_Deal_Rights_Territory  adrtr
	) As srter
	Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code
) ADRTer ON ADRTer.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
Inner JOIN Country COU ON COU.Country_Code = ADRTer.Country_Code
LEFT JOIN Acq_Deal_Cost ADC ON ADC.Acq_Deal_Code = AD.Acq_Deal_Code