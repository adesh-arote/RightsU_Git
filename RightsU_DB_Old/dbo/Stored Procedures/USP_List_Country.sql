CREATE PROCEDURE USP_List_Country
(
@SysLanguageCode INT
)
AS
BEGIN
	SET FMTONLY OFF
	DECLARE
		@Active NVARCHAR(500) = '',
		@Deactive NVARCHAR(500) = '',
		@Yes NVARCHAR(200) = '',
		@No NVARCHAR(200) = ''

		
 SELECT @Deactive = SLM.Message_Desc FROM System_Message SM
		  INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code 
		  AND SM.Message_Key =  'Deactive'
		  INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

 SELECT @Active= SLM.Message_Desc FROM System_Message SM
		  INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code 
		  AND SM.Message_Key =  'Active'
		  INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

		  
 SELECT @Yes = SLM.Message_Desc FROM System_Message SM
		  INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code 
		  AND SM.Message_Key =  'Yes'
		  INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

 SELECT @No = SLM.Message_Desc FROM System_Message SM
		  INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code 
		  AND SM.Message_Key =  'NO'
		  INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode

	IF(OBJECT_ID('TEMPDB..#TempCountry') IS NOT NULL)
		DROP TABLE #TempCountry

	SELECT C1.Country_Code, C1.Country_Name, 
	CASE ISNULL(C1.Is_Theatrical_Territory, 'N') WHEN 'Y' THEN @Yes ELSE @No END AS Theatrical_Territory,
	CAST('' AS NVARCHAR(MAX)) AS [Language_Names], 
	CASE WHEN ISNULL(C1.Is_Domestic_Territory, 'N') = 'Y' THEN @Yes
		 WHEN ISNULL(C1.Parent_Country_Code, 0) > 0 THEN C2.Country_Name
		 ELSE @No
	END AS Base_Country, 
	CASE ISNULL(C1.Is_Active, 'N') WHEN 'Y' THEN @Active ELSE @Deactive END AS [Status],
	ISNULL(C1.Is_Theatrical_Territory, 'N') AS Is_Theatrical_Territory, ISNULL(C1.Is_Active, 'N') AS Is_Active,
	[dbo].[UFN_Get_Disable_Deactive_Message](C1.Country_Code, 6, @SysLanguageCode, 'COUNTRY')  AS Disable_Message, C1.Last_Updated_Time
	INTO #TempCountry 
	FROM Country C1
	LEFT JOIN Country C2 ON C1.Parent_Country_Code = C2.Country_Code

	DECLARE @CountryCode INT = 0


	UPDATE TC SET TC.Language_Names = STUFF((
			SELECT ', ' + CAST(l.Language_Name AS NVARCHAR(1000)) FROM Country_Language CL
			INNER JOIN [Language] L ON L.Language_Code = CL.Language_Code
			WHERE cl.Country_Code = TC.Country_Code
			ORDER BY l.Language_Name
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'')
	FROM #TempCountry TC

	SELECT Country_Code, Country_Name, Theatrical_Territory, ISNULL(Language_Names, '') AS Language_Names, ISNULL(Base_Country, 'No') AS Base_Country, [Status],
	Is_Theatrical_Territory, Is_Active, Disable_Message,Last_Updated_Time
	FROM #TempCountry ORDER BY Last_Updated_Time desc
END