
CREATE VIEW [dbo].[VW_Syn_Deals]  
AS  
	SELECT DISTINCT  T.Title_Code, T.Original_Title, T.Title_Name, SDM.No_Of_Episode, 
	SDRP.Platform_Code, P.Platform_Hiearachy AS Platform_Name, 
	SD.Vendor_Code, V.Vendor_Name,
	TT_Dir.Talent_Code AS Director_Code,  
	DBO.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) AS Director_Names_Comma_Seperate, 
	TT_SC.Talent_Code AS Start_Cast_Code, 
	DBO.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) AS Star_Cast_Names_Comma_Seperate,
	SDR.Right_Start_Date, SDR.Right_End_Date, 
	SDRTer.Country_Code, COU.Country_Name,
	CASE 
		WHEN (SELECT COUNT(Syn_Deal_Rights_Holdback_Code) FROM Syn_Deal_Rights_Holdback WHERE Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) > 0 THEN 'Y' ELSE 'N' 
	END AS Is_Holdback, SD.Currency_Code, CUR.Currency_Name, SD.Entity_Code, E.Entity_Name, 
	SDC.Deal_Cost, ISNULL(SDC.Variable_Cost_Type, 'N') AS Variable_Cost_Type, 
	SD.Agreement_No, SD.Deal_Description, SD.Deal_Tag_Code, DT.Deal_Tag_Description, SD.Business_Unit_Code, BU.Business_Unit_Name,  SDR.Is_Sub_License, 
	DBO.UFN_Get_Rights_Subtitling(SDR.Syn_Deal_Rights_Code, 'A') AS Subtitling_Languages, DBO.UFN_Get_Rights_Dubbing(SDR.Syn_Deal_Rights_Code, 'A') AS Dubbing_Languages, 
	SDM.Syn_Deal_Movie_Code, NULL AS Holdback_Detail, 
	CASE ISNULL(SDR.Is_ROFR, '') WHEN 'Y' THEN 'Yes' ELSE 'No' END AS ROFR, SDR.Restriction_Remarks
	FROM Syn_Deal SD
	INNER JOIN Vendor V ON V.Vendor_Code = SD.Vendor_Code
	INNER JOIN Currency CUR ON CUR.Currency_Code = SD.Currency_Code
	INNER JOIN Entity E ON E.Entity_Code = SD.Entity_Code
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
	INNER JOIN Deal_Tag DT ON DT.Deal_Tag_Code = SD.Deal_Tag_Code
	INNER JOIN Syn_Deal_Movie SDM ON SDM.Syn_Deal_Code = SD.Syn_Deal_Code
	INNER JOIN Title T ON T.Title_Code = SDM.Title_Code
	LEFT JOIN Title_Talent TT_Dir ON TT_Dir.Title_Code = T.Title_Code AND TT_Dir.Role_Code = 1
	LEFT JOIN Talent Tal_Dir ON Tal_Dir.Talent_Code = TT_Dir.Talent_Code
	LEFT JOIN Title_Talent TT_SC ON TT_SC.Title_Code = T.Title_Code AND TT_SC.Role_Code = 2
	LEFT JOIN Talent Tal_SC ON Tal_SC.Talent_Code = TT_SC.Talent_Code
	INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Code = SD.Syn_Deal_Code
	INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND SDRT.Title_Code = SDM.Title_Code
	INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
	INNER JOIN Platform P ON P.Platform_Code = SDRP.Platform_Code
	INNER JOIN Syn_Deal_Rights_Territory SDRTer ON SDRTer.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
	LEFT JOIN Country COU ON COU.Country_Code = SDRTer.Country_Code
	LEFT JOIN Territory_Details TD ON TD.Territory_Code = SDRTer.Territory_Code
	LEFT JOIN Syn_Deal_Revenue SDC ON SDC.Syn_Deal_Code = SD.Syn_Deal_Code

