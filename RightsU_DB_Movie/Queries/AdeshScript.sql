USE [RightsU_Reports_Movie]
GO

Exec [dbo].[USP_Get_Title_Availability_LanguageWise_3_V1]
	@Title_Code='19799', 
	@Is_Original_Language=1, 
	@Title_Language_Code='',
	@Date_Type ='FL',
	@StartDate ='23-Sep-2015',
	@EndDate ='23-Sep-2020',
	@Platform_Code='0', 
	@Platform_ExactMatch='false', 
	@MustHave_Platform='0', 

	@Is_IFTA_Cluster = 'N',
    @Country_Code='0', 
	@Region_ExactMatch='false',
	@Region_MustHave='0',
	@Region_Exclusion='0',

	@Dubbing_Subtitling='D',
	@Subtit_Language_Code='7,5',--'1,10,100,101,102,103,104,105,106,107,108,109,11,110,111,112,113,114,115,116,12,13,14,15,17,18,19,2,20,21,22,23,24,25,26,27,28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,41,42,43,45,46,47,48,49,5,50,51,52,53,54,55,56,57,58,59,6,60,61,62,63,64,65,66,67,68,69,7,70,71,72,73,74,75,76,77,78,79,8,80,81,82,83,84,85,86,87,88,89,9,90,91,92,93,94,95,96,97,98,99', 
	@Subtitling_ExactMatch = 'MH', --MH/EM/false
	@Subtitling_MustHave = '5',
	@Subtitling_Exclusion = '0',
	
	@Dubbing_Language_Code='9,6,8', 
	@Dubbing_ExactMatch = 'MH',
	@Dubbing_MustHave = '8',
	@Dubbing_Exclusion = '0',

	@Exclusivity='B',
	@SubLicense_Code='0', --Comma   Separated SubLicensing Code. 0-No Sub Licensing ,
	@RestrictionRemarks='N',
	@OthersRemarks='false',
	@BU_Code=1,
	@Is_Digital= 'false'



	--Select * From Avail_Languages
	--Drop Table #Temp
	--Create Table #Temp
	--( Codes Int	)

	--Insert InTO #Temp
	--Select 1
	--Union
	--Select 5
	--	Union
	--Select 2
	--	Union
	--Select 3
	--	Union
	--Select 4
	--	Union
	--Select 5
	--	Union
	--Select 10
	--	Union
	--Select 7
	--	Union
	--Select 34
	--	Union
	--Select 45
	--	Union
	--Select 0
	--	Union
	--Select 8
	--	Union
	--Select 9


	--SELECT 
	--	STUFF
	--	(
	--		(
	--			SELECT ',' + CAST(Codes AS VARCHAR) FROM #Temp
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	)

	--	SELECT Codes FROM #Temp