CREATE PROCEDURE [dbo].[Avail_GetAcquisitionModelMaster]
     
AS       
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetAcquisitionModelMaster]', 'Step 1', 0, 'Started Procedure', 0, ''
		SELECT Country_Code CountryCode, Country_Name CountryName from Country;
		SELECT Platform_Code PlatformCode, Platform_Hiearachy PlatformName from Platform where Is_Last_Level = 'Y';
		--SELECT Platform_Code PlatformCode, Platform_Name PlatformName, Platform_Hiearachy PlatformHiearachy from Platform;
		SELECT Language_Code SubTitleCode, Language_Name SubTitleName from Language;
		SELECT Language_Code DubbingCode, Language_Name DubbingName from Language;

		SELECT TD.Territory_Code TerritoryCode, T.Territory_Name TerritoryName, C.Country_Code CountryCode, C.Country_Name CountryName
		FROM Country C (NOLOCK)
		INNER JOIN Territory_Details TD (NOLOCK)
		ON TD.Country_Code = C.Country_Code
		INNER JOIN Territory T (NOLOCK)
		ON T.Territory_Code = TD.Territory_Code
		GROUP BY TD.Territory_Code, T.Territory_Name, C.Country_Code, C.Country_Name
		ORDER BY TD.Territory_Code;

		--SELECT TID.Territory_Ifta_Code TerritoryCodeIFTA, TI.Territory_Ifta_Name TerritoryNameIFTA, C.Country_Code CountryCodeIFTA, C.Country_Name CountryNameIFTA
		--FROM Country C
		--INNER JOIN Territory_Ifta_Details TID
		--ON TID.Country_Code = C.Country_Code
		--INNER JOIN Territory_Ifta TI
		--ON TI.Territory_Ifta_Code = TID.Territory_Ifta_Code
		--GROUP BY TID.Territory_Ifta_Code, TI.Territory_Ifta_Name, C.Country_Code, C.Country_Name
		--ORDER BY TID.Territory_Ifta_Code;

		SELECT LGD.Language_Group_Code LanguageGroupCode, LG.Language_Group_Name LanguageGroupName, L.Language_Code LanguageCode, L.Language_Name LanguageName 
		FROM Language L (NOLOCK)
		INNER JOIN Language_Group_Details LGD (NOLOCK)
		ON LGD.Language_Code = L.Language_Code
		INNER JOIN Language_Group LG (NOLOCK)
		ON LG.Language_Group_Code = LGD.Language_Group_Code
		GROUP BY LGD.Language_Group_Code, LG.Language_Group_Name, L.Language_Code, L.Language_Name
		ORDER BY LGD.Language_Group_Code;

		SELECT P.Platform_Code PlatformGroupCode, P.Platform_Hiearachy PlatformGroupName, P.Platform_Code PlatformCode, P.Platform_Hiearachy PlatformName, P.Is_Last_Level IsLastLevel 
		FROM Platform P (NOLOCK)
		WHERE P.Parent_Platform_Code = 0
		UNION ALL
		SELECT PG.Platform_Code PlatformGroupCode, PG.Platform_Hiearachy PlatformGroupName, P.Platform_Code PlatformCode, P.Platform_Hiearachy PlatformName, P.Is_Last_Level IsLastLevel
		FROM Platform P (NOLOCK)
		INNER JOIN Platform PG (NOLOCK)
		ON PG.Platform_Code = P.Parent_Platform_Code
		GROUP BY PG.Platform_Code, PG.Platform_Hiearachy, P.Platform_Code, P.Platform_Hiearachy, P.Is_Last_Level
		ORDER BY P.Platform_Code

		SELECT Sub_License_Code SubLicenseCode, Sub_License_Name SubLicenseName
		FROM Sub_License
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetAcquisitionModelMaster]', 'Step 2', 0, 'Procedure Execution Completed', 0, ''
END