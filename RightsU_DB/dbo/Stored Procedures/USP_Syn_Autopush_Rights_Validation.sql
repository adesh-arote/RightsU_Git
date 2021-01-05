CREATE PROCEDURE [dbo].[USP_Syn_Autopush_Rights_Validation]
(
	@SynDealRightsCode INT, 
	@Is_Error CHAR(1) OUTPUT
)
AS
BEGIN
	DECLARE
	--@SynDealRightsCode INT = 1674, 
    @AcqDealRightsCode  INT,
	@CallFrom VARCHAR(MAX),
	--@Is_Error CHAR(1) = 'N',
	@SynDealRightsCode_V18 VARCHAR(10),
	@Right_Start_Date DATETIME,
	@Right_End_Date DATETIME,
	@Right_Type CHAR(1),
	@Is_Exclusive CHAR(1),
	@Is_Title_Language_Right CHAR(1),
	@Is_Sub_License CHAR(1),
	@Is_Tentative CHAR(1),
	@Sub_License_Code Int,
	@Deal_Rights_Code Int,
	@Deal_Pushback_Code Int,
	@Deal_Code Int,
	@Title_Code Int,
	@Platform_Code Int,
	@Is_Theatrical_Right CHAR(1)

	BEGIN ------------------------------------------START DROP TEMP TABLE, IF EXISTS

		IF(OBJECT_ID('TEMPDB..#Dup_Records_Language_AP') IS NOT NULL)
		DROP TABLE #Dup_Records_Language_AP

		If OBJECT_ID('tempdb..#TempCombination_Session_AP') Is Not Null
		Drop Table #TempCombination_Session_AP

		IF OBJECT_ID('TEMPDB..#TempCombination_AP') IS NOT NULL
		DROP TABLE #TempCombination_AP

		If OBJECT_ID('tempdb..#Temp_Episode_No') Is Not Null
		Drop Table #Temp_Episode_No

		If OBJECT_ID('tempdb..#Deal_Right_Title_WithEpsNo') Is Not Null
		Drop Table #Deal_Right_Title_WithEpsNo


	END ----------------------------------------END DROP TEMP TABLE, IF EXISTS

	BEGIN-----------------------------------------------START CREATION OF TEMP TABLES
	PRINT 'CREATION OF TEMP TABLES'
		IF(OBJECT_ID('TEMPDB..#DstSynRights') IS NOT NULL)
		DROP TABLE #DstSynRights
		CREATE TABLE #DstSynRights ([Syn_Deal_Rights_Code_V18] INT)

		IF(OBJECT_ID('TEMPDB..#CurrentTitle_AP)') IS NOT NULL)
		DROP TABLE #CurrentTitle_AP
		CREATE TABLE #CurrentTitle_AP
		(
			SynDealRightsCode INT,
			Title_Code INT,
			Episode_From INT,
			Episode_To INT
		)

		IF(OBJECT_ID('TEMPDB..#CurrentPlatform_AP') IS NOT NULL)
		DROP TABLE #CurrentPlatform_AP
		CREATE TABLE #CurrentPlatform_AP
		(
			SynDealRightsCode INT,
			PlatformCode INT
		)

		IF(OBJECT_ID('TEMPDB..#CurrentRegion_AP') IS NOT NULL)
		DROP TABLE #CurrentRegion_AP
		CREATE TABLE #CurrentRegion_AP
		(   
			SynDealRightsCode INT,
			CountryCode INT
		)

		IF(OBJECT_ID('TEMPDB..#CurrentSubtitling_AP') IS NOT NULL)
		DROP TABLE #CurrentSubtitling_AP
		CREATE TABLE #CurrentSubtitling_AP
		(  
			SynDealRightsCode INT,
			SubLanguageCode INT
		)

		IF(OBJECT_ID('TEMPDB..#CurrentDubbing_AP') IS NOT NULL)
		DROP TABLE #CurrentDubbing_AP
		CREATE TABLE #CurrentDubbing_AP
		(
			SynDealRightsCode INT,
			DubLanguageCode INT
		)

		CREATE Table #Dup_Records_Language_AP
		(
			[id]						INT,
			[Title_Code]				INT,
			[Platform_Code]				INT,
			[Territory_Code]			INT,
			[Country_Code]				INT,
			[Right_Start_Date]			DATETIME,
			[Right_End_Date]			DATETIME,
			[Right_Type]				VARCHAR (50),
			[Territory_Type]			CHAR (1),
			[Is_Sub_License]			CHAR (1),
			[Is_Title_Language_Right]	CHAR (1),
			[Subtitling_Language]		INT,
			[Dubbing_Language]			INT,
			[Deal_Code]					INT,
			[Deal_Rights_Code]			INT,
			[Deal_Pushback_Code]		INT,
			[Agreement_No]				VARCHAR (MAX),
			[ErrorMSG]					VARCHAR (MAX),
			[Episode_From]				INT,
			[Episode_To]				INT,
			[IsPushback]				CHAR (1)      
		)

		CREATE Table #TempCombination_AP
		(
			ID Int IDENTITY(1,1),
			Agreement_No Varchar(1000),
			Title_Code Int,	
			Episode_From Int,
			Episode_To Int,
			Platform_Code Int,
			Right_Type  CHAR(1),
			Right_Start_Date DATETIME,
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Code Int,
			Terrirory_Type CHAR(1),
			Is_exclusive CHAR(1),
			Subtitling_Language_Code Int,
			Dubbing_Language_Code Int,
			Data_From CHAR(1),
			Is_Available CHAR(1),
			Error_Description NVARCHAR(MAX),
			Sum_of Int,
			Partition_Of Int
		)

		CREATE Table #TempCombination_Session_AP
		(
			ID Int IDENTITY(1,1),
			Agreement_No Varchar(1000),
			Title_Code Int,	
			Episode_From Int,
			Episode_To Int,
			Platform_Code Int,
			Right_Type  CHAR(1),
			Right_Start_Date DATETIME,
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Code Int,
			Terrirory_Type CHAR(1),
			Is_exclusive CHAR(1),
			Subtitling_Language_Code Int,
			Dubbing_Language_Code Int,
			Data_From CHAR(1),
			Is_Available CHAR(1),
			Error_Description NVARCHAR(MAX),
			Sum_of Int,
			Partition_Of Int,
			MessageUpadated CHAR(1) DEFAULT('N')
		)

		CREATE Table #Temp_Episode_No(Episode_No Int)

		CREATE Table #Deal_Right_Title_WithEpsNo
		(
			Deal_Rights_Code Int,
			Title_Code Int,
			Episode_No Int,
		)
	PRINT 'TEMP TABLES CREATED'
	END--------------------------------------------END CREATION OF TEMP TABLES

	BEGIN ------------------------------START IDENTIFYING SYNDICATION TARGET RIGHTS 
		PRINT 'Insertion of Table Variables'
		IF(@SynDealRightsCode > 0)
		BEGIN
			PRINT 'Get Acq Deal Code For Viacom18'
			SELECT TOP 1 @AcqDealRightsCode = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEALRIGHTS' AND PrimaryDataCode = @SynDealRightsCode 
		END

		INSERT INTO #DstSynRights (Syn_Deal_Rights_Code_V18)
		Select Syn_Deal_Rights_Code  FROM RightsU_Broadcast.dbo.Syn_Acq_Mapping Where Deal_Rights_Code = @AcqDealRightsCode
		--Select * from #DstSynRights 
	END ------------------------------END IDENTIFYING SYNDICATION TARGET RIGHTS
	


	DECLARE @SynDealRightsCodeV18 INT = 0
	DECLARE CUR_DestSynRights CURSOR For    
		SELECT Syn_Deal_Rights_Code_V18 FROM #DstSynRights     
	OPEN CUR_DestSynRights    
	FETCH NEXT FROM CUR_DestSynRights InTo @SynDealRightsCodeV18
	WHILE @@FETCH_STATUS = 0    
	

	BEGIN --------------------------START CURSOR FOR MULTIPLE SYNDICATION RIGHTS CODE 

		IF(OBJECT_ID('TEMPDB..#Syn_Deal_Rights_AP') IS NOT NULL)
		DROP TABLE #Syn_Deal_Rights_AP

		If OBJECT_ID('tempdb..#Temp_NA_Title') Is Not Null
		Drop Table #Temp_NA_Title

		IF(OBJECT_ID('TEMPDB..#Syn_Dub_AP') IS NOT NULL)
		DROP TABLE #Syn_Dub_AP
			
		IF(OBJECT_ID('TEMPDB..#Syn_Sub_AP') IS NOT NULL)
		DROP TABLE #Syn_Sub_AP

		IF(OBJECT_ID('TEMPDB..#Temp_Syn_Dubbing_AP') IS NOT NULL)
		DROP TABLE #Temp_Syn_Dubbing_AP
			
		IF(OBJECT_ID('TEMPDB..#Temp_Syn_Subtitling_AP') IS NOT NULL)
		DROP TABLE #Temp_Syn_Subtitling_AP

		IF(OBJECT_ID('TEMPDB..#Temp_Dubbing_AP') IS NOT NULL)
		DROP TABLE #Temp_Dubbing_AP

		IF(OBJECT_ID('TEMPDB..#Temp_Subtitling_AP') IS NOT NULL)
		DROP TABLE #Temp_Subtitling_AP

		IF(OBJECT_ID('TEMPDB..#Syn_Country_AP') IS NOT NULL)
		DROP TABLE #Syn_Country_AP

		IF(OBJECT_ID('TEMPDB..#Temp_Country_AP') IS NOT NULL)
		DROP TABLE #Temp_Country_AP

		IF(OBJECT_ID('TEMPDB..#NA_Dubbing_AP') IS NOT NULL)
		DROP TABLE #NA_Dubbing_AP

		IF(OBJECT_ID('TEMPDB..#NA_Subtitling_AP') IS NOT NULL)
		DROP TABLE #NA_Subtitling_AP

		IF(OBJECT_ID('TEMPDB..#NA_Country_AP') IS NOT NULL)
		DROP TABLE #NA_Country_AP

		IF(OBJECT_ID('TEMPDB..#NA_Platforms_AP') IS NOT NULL)
		DROP TABLE #NA_Platforms_AP

		IF(OBJECT_ID('TEMPDB..#Temp_Syn_Platform_AP') IS NOT NULL)
		DROP TABLE #Temp_Syn_Platform_AP

		IF(OBJECT_ID('TEMPDB..#Temp_Syn_Country_AP') IS NOT NULL)
		DROP TABLE #Temp_Syn_Country_AP

		IF(OBJECT_ID('TEMPDB..#Syn_Titles_AP') IS NOT NULL)
		DROP TABLE #Syn_Titles_AP

		IF(OBJECT_ID('TEMPDB..#Syn_Titles_With_Rights_AP') IS NOT NULL)
		DROP TABLE #Syn_Titles_With_Rights_AP

		IF(OBJECT_ID('TEMPDB..#Temp_Platforms_AP') IS NOT NULL)
		DROP TABLE #Temp_Platforms_AP

		If OBJECT_ID('tempdb..#Acq_Avail_Title_Eps') Is Not Null
		Drop Table #Syn_Avail_Title_Eps

		If OBJECT_ID('tempdb..#Title_Not_Acquire') Is Not Null
		Drop Table #Title_Not_Acquire

		

		BEGIN -------------------------------START ASSIGN VALUE TO VARIABLES
		PRINT '  @SynDealRightsCodeV18 : '  + CAST(@SynDealRightsCodeV18 AS VARCHAR)
		SELECT 
			@Deal_Code=dr.Syn_Deal_Code,
			@Deal_Rights_Code = Syn_Deal_Rights_Code, 
			@Deal_Pushback_Code = Case When @CallFrom = 'SP' Then dr.Syn_Deal_Rights_Code Else 0 End,
			@Right_Start_Date=dr.Right_Start_Date,
			@Right_End_Date=dr.Right_End_Date,
			@Right_Type=dr.Right_Type,
			@Is_Exclusive=dr.Is_Exclusive,
			@Is_Tentative=dr.Is_Tentative,
			@Is_Sub_License=dr.Is_Sub_License,
			@Sub_License_Code=dr.Sub_License_Code,
			@Is_Title_Language_Right=dr.Is_Title_Language_Right,	
			@Title_Code=0,
			@Platform_Code=0,
			@Is_Theatrical_Right=IsNull(dr.Is_Theatrical_Right,'N')
		FROM RightsU_Broadcast.dbo.Syn_Deal_Rights dr 
		INNER JOIN #DstSynRights DSR ON DSR.Syn_Deal_Rights_Code_V18 = dr.Syn_Deal_Rights_Code
		WHERE Syn_Deal_Rights_Code = @SynDealRightsCodeV18

	END-------------------------------------------------------END ASSIGN VALUE TO VARIABLES	

		BEGIN -------------------------------------- START CHECK DST SYNDICATION
		PRINT 'INSERTION OF CURRENT DATA WITH RESPECTED SYNDICATION DEAL RIGHTS'
			PRINT '  @SynDealRightsCodeV18 : '  + CAST(@SynDealRightsCodeV18 AS VARCHAR)

			Insert InTo #CurrentTitle_AP(SynDealRightsCode, Title_Code, Episode_From, Episode_To)
			Select  SDRT.Syn_Deal_Rights_Code, APRMD.PrimaryDataCode, SDRT.Episode_From, SDRT.Episode_To
			From RightsU_Broadcast.dbo.Syn_Deal_Rights_Title SDRT
			INNER JOIN AcqPreReqMappingData APRMD ON APRMD.SecondaryDataCode = SDRT.Title_Code
			INNER JOIN #DstSynRights DSR ON DSR.Syn_Deal_Rights_Code_V18 = SDRT.Syn_Deal_Rights_Code
			Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18  AND MappingFor = 'TITL'

			INSERT INTO #CurrentPlatform_AP(SynDealRightsCode, PlatformCode)
			Select  DISTINCT SDRP.Syn_Deal_Rights_Code, APRMD.PrimaryDataCode
			From RightsU_Broadcast.dbo.Syn_Deal_Rights_Platform SDRP
			INNER JOIN AcqPreReqMappingData APRMD ON APRMD.SecondaryDataCode = SDRP.Platform_Code
			--INNER JOIN #DstSynRights DSR ON DSR.Syn_Deal_Rights_Code_V18 = SDRP.Syn_Deal_Rights_Code
			Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18 AND MappingFor = 'PLAT'
			
			Insert InTo #CurrentRegion_AP(SynDealRightsCode, CountryCode)
			Select Distinct Syn_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code
			From (
				Select Syn_Deal_Rights_Code, APRMD.PrimaryDataCode AS [Territory_Code], APRMD.PrimaryDataCode AS [Country_Code],  Territory_Type , APRMD.MappingFor
				From RightsU_Broadcast.dbo.Syn_Deal_Rights_Territory  SDRT
				INNER JOIN AcqPreReqMappingData APRMD ON (APRMD.SecondaryDataCode = SDRT.Country_Code AND SDRT.Territory_Type = 'I') OR
				(APRMD.SecondaryDataCode = SDRT.Territory_Code AND SDRT.Territory_Type = 'G')
				INNER JOIN #DstSynRights DSR ON DSR.Syn_Deal_Rights_Code_V18 = SDRT.Syn_Deal_Rights_Code
				Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18 AND APRMD.MappingFor =  IIF(SDRT.Territory_Type = 'G','TERR','CONT')
			) As srter
			Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code

			INSERT INTO #CurrentSubtitling_AP(SynDealRightsCode, SubLanguageCode)
			SELECT DISTINCT Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				SELECT DISTINCT Syn_Deal_Rights_Code, APRMD.PrimaryDataCode AS [Language_Code], APRMD.PrimaryDataCode AS [Language_Group_Code], Language_Type
				FROM RightsU_Broadcast.dbo.Syn_Deal_Rights_Subtitling SDRS
				INNER JOIN AcqPreReqMappingData APRMD ON (APRMD.SecondaryDataCode = SDRS.Language_Code AND sdrs.Language_Type= 'I') OR
				(APRMD.SecondaryDataCode = SDRS.Language_Group_Code AND sdrs.Language_Type= 'G') OR (APRMD.SecondaryDataCode = SDRS.Language_Code AND sdrs.Language_Type= 'L') 
				INNER JOIN #DstSynRights DSR ON DSR.Syn_Deal_Rights_Code_V18 = SDRS.Syn_Deal_Rights_Code
				Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18 AND APRMD.MappingFor = IIF(sdrs.Language_Type= 'G','LAGR','LANG')
			) AS Srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			INSERT INTO #CurrentDubbing_AP(SynDealRightsCode, DubLanguageCode)
			SELECT DISTINCT Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				SELECT DISTINCT Syn_Deal_Rights_Code, APRMD.PrimaryDataCode AS [Language_Code], APRMD.PrimaryDataCode AS  [Language_Group_Code], Language_Type
				FROM RightsU_Broadcast.dbo.Syn_Deal_Rights_Dubbing SDRD
				INNER JOIN AcqPreReqMappingData APRMD ON (APRMD.SecondaryDataCode = SDRD.Language_Code AND SDRD.Language_Type= 'I') OR
				(APRMD.SecondaryDataCode = SDRD.Language_Group_Code AND SDRD.Language_Type= 'G') OR (APRMD.SecondaryDataCode = SDRD.Language_Code AND SDRD.Language_Type= 'L')
				INNER JOIN #DstSynRights DSR ON DSR.Syn_Deal_Rights_Code_V18 = SDRD.Syn_Deal_Rights_Code
				Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18 AND APRMD.MappingFor = IIF(SDRD.Language_Type= 'G','LAGR','LANG')
			) AS Srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code
			
	END ---------------------------------------------------- END CHECK DST SYNDICATION

		BEGIN-----------------------START INSERT DESTINATION RIGHTS DATA IN TABLE VARIABLE

			DECLARE @Deal_Rights_Title Deal_Rights_Title, @Deal_Rights_Platform Deal_Rights_Platform, @Deal_Rights_Territory Deal_Rights_Territory,
					@Deal_Rights_Subtitling Deal_Rights_Subtitling, @Deal_Rights_Dubbing Deal_Rights_Dubbing


			Insert InTo @Deal_Rights_Title(Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
			Select  SDRT.Syn_Deal_Rights_Code, APRMD.PrimaryDataCode, SDRT.Episode_From, SDRT.Episode_To
			From RightsU_Broadcast.dbo.Syn_Deal_Rights_Title SDRT
			INNER JOIN AcqPreReqMappingData APRMD ON APRMD.SecondaryDataCode = SDRT.Title_Code
			Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18 --And Title_Code = @Title_Code_Cur

			Insert InTo @Deal_Rights_Platform(Deal_Rights_Code,Platform_Code)
			Select DISTINCT Syn_Deal_Rights_Code,  Platform_Code
			From RightsU_Broadcast.dbo.Syn_Deal_Rights_Platform 
			Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18

			Insert InTo @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
			Select Syn_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code
			From (
				Select Syn_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
				From RightsU_Broadcast.dbo.Syn_Deal_Rights_Territory  
				Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18
			) As srter
			Left Join RightsU_Broadcast.dbo.Territory_Details td On srter.Territory_Code = td.Territory_Code

			Insert InTo @Deal_Rights_Subtitling(Deal_Rights_Code, Subtitling_Code)
			Select Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				Select Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				From RightsU_Broadcast.dbo.Syn_Deal_Rights_Subtitling
				Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18
			) As srlan
			Left Join RightsU_Broadcast.dbo.Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			Insert InTo @Deal_Rights_Dubbing(Deal_Rights_Code, Dubbing_Code)
			Select Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				Select Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				From RightsU_Broadcast.dbo.Syn_Deal_Rights_Dubbing
				Where Syn_Deal_Rights_Code = @SynDealRightsCodeV18
			) As srlan
			Left Join RightsU_Broadcast.dbo.Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

		END------------------END INSERT DESTINATION RIGHTS DATA IN TABLE VARIABLE
	
		BEGIN-----------------------START FETCHING DATA FOR EPISODE NUMBER FOR GIVEN TITLE

			Truncate Table #Temp_Episode_No
			Truncate Table #Deal_Right_Title_WithEpsNo
	
			Declare @StartNum Int, @EndNum Int
	
			Select @StartNum = MIN(Episode_FROM), @EndNum = MAX(Episode_To) From @Deal_Rights_Title;
					
			With gen As (
				Select @StartNum As num Union All
				Select num+1 From gen Where num + 1 <= @EndNum
			)
	
			Insert InTo #Temp_Episode_No
			Select * From gen
			Option (maxrecursion 10000)
	
			Insert InTo #Deal_Right_Title_WithEpsNo(Deal_Rights_Code, Title_Code, Episode_No)
			Select Deal_Rights_Code,Title_Code, Episode_No 
			From (
				Select Distinct t.Deal_Rights_Code,t.Title_Code, a.Episode_No 
				From #Temp_Episode_No A 
				Cross Apply @Deal_Rights_Title T 
				Where A.Episode_No Between T.Episode_FROM And T.Episode_To
			) As B 

		END------------------END FETCHING DATA FOR EPISODE NUMBER FOR GIVEN TITLE	

		BEGIN ----------------------------------------START FINDING DATE DIFFERENCE
		SELECT SDR.Syn_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,
		Is_Exclusive, SDR.Syn_Deal_Code, SD.Agreement_No,
		(Select Count(*) From Syn_Deal_Rights_Subtitling S Where S.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) SubCnt, 
		(Select Count(*) From Syn_Deal_Rights_Dubbing S Where S.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) DubCnt,
	   	Sum(                        
			Case 
				When (@Right_Start_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date) And (@Right_End_Date Not Between SDR.Actual_Right_Start_Date  And SDR.Actual_Right_End_Date)
					Then datediff(d,@Right_Start_Date, DATEADD(d,1, SDR.Actual_Right_End_Date ))
				When (@Right_Start_Date Not Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date) And (@Right_End_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date)
					Then datediff(d, SDR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
				When (@Right_Start_Date < SDR.Actual_Right_Start_Date) And (@Right_End_Date > SDR.Actual_Right_End_Date)
					Then datediff(d,SDR.Actual_Right_Start_Date, DATEADD(d,1, SDR.Actual_Right_End_Date))
				When (@Right_Start_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date) And (@Right_End_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date)
					Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
				Else 0 
			End
		)Sum_of,
		Sum(
			Case 
				When (@Right_Start_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date) And (@Right_End_Date Not Between SDR.Actual_Right_Start_Date  And SDR.Actual_Right_End_Date)
					Then datediff(d,@Right_Start_Date, DATEADD(d,1, SDR.Actual_Right_End_Date ))   
				When (@Right_Start_Date Not Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date) And (@Right_End_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date)
					Then datediff(d, SDR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
				When (@Right_Start_Date < SDR.Actual_Right_Start_Date) And (@Right_End_Date > SDR.Actual_Right_End_Date)
					Then datediff(d,SDR.Actual_Right_Start_Date, DATEADD(d,1, SDR.Actual_Right_End_Date ))
				When (@Right_Start_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date) And (@Right_End_Date Between SDR.Actual_Right_Start_Date And SDR.Actual_Right_End_Date)
					Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
				Else 0 
			End
		)
		OVER(
			PARTITION BY SDR.Syn_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, SDR.Syn_Deal_Code
		) Partition_Of
		InTo #Syn_Deal_Rights_AP
	From Syn_Deal_Rights SDR
	Inner Join Syn_Deal SD On SDR.Syn_Deal_Code = SD.Syn_Deal_Code --And IsNull(SD.Deal_Workflow_Status,'') = 'A'
	Where 
	SDR.Syn_Deal_Code Is Not Null
	And SDR.Is_Sub_License='Y'
	And SDR.Is_Tentative='N'
	And
	(
		(
			SDR.Right_Type ='Y' AND
			(
				(CONVERT(DATETIME, @Right_Start_Date, 103) Between CONVERT(DATETIME, SDR.Right_Start_Date, 103) And Convert(DATETIME, SDR.Right_End_Date, 103)) OR
				(CONVERT(DATETIME, @Right_End_Date, 103) Between CONVERT(DATETIME, SDR.Right_Start_Date, 103) And CONVERT(DATETIME, SDR.Right_End_Date, 103)) OR
				(CONVERT(DATETIME, SDR.Right_Start_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103)) OR
				(CONVERT(DATETIME, SDR.Right_End_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103))
			)
		)OR(SDR.Right_Type ='U'  OR SDR.Right_Type ='M')
	) AND (    
		(SDR.Is_Title_Language_Right = @Is_Title_Language_Right) OR 
		(@Is_Title_Language_Right <> 'Y' And SDR.Is_Title_Language_Right = 'Y') OR 
		(@Is_Title_Language_Right = 'Y' And SDR.Is_Title_Language_Right = 'N')
	) AND (
		(@Is_Exclusive = 'Y' And IsNull(SDR.Is_exclusive,'')='Y') OR @Is_Exclusive = 'N'
	) 
	GROUP BY SDR.Syn_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, SDR.Syn_Deal_Code, SD.Agreement_No
	END ------------------------------------------------END FINDING DATE DIFFERENCE
		
		BEGIN ----------------------------------START CHECKING TITLE WITH EPISODE EXIST OR NOT
	Select Distinct SDR.Syn_Deal_Rights_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To, SDR.SubCnt, SDR.DubCnt,SDR.Sum_of, SDR.Partition_Of
	InTo #Syn_Titles_With_Rights_AP From #Syn_Deal_Rights_AP SDR
	Inner Join dbo.Syn_Deal_Rights_Title SDRT On SDR.Syn_Deal_Rights_Code=SDRT.Syn_Deal_Rights_Code
	Inner Join @Deal_Rights_Title drt On SDRT.Title_Code = drt.Title_Code And 
	(
		(drt.Episode_From Between SDRT.Episode_From And SDRT.Episode_To)
		Or
		(drt.Episode_To Between SDRT.Episode_From And SDRT.Episode_To)
		Or
		(SDRT.Episode_From Between drt.Episode_From And drt.Episode_To)
		Or
		(SDRT.Episode_To Between drt.Episode_From And drt.Episode_To)
	)


	Select Distinct Title_Code, Episode_From, Episode_To InTo #Syn_Titles_AP From #Syn_Titles_With_Rights_AP
		
	Select Title_Code, Episode_No InTo #Syn_Avail_Title_Eps
	From (
	Select Distinct t.Title_Code, a.Episode_No 
	From #Temp_Episode_No A 
	Cross Apply #Syn_Titles_AP T 
	Where A.Episode_No Between T.Episode_FROM And T.Episode_To
	) As B 

	Select ROW_NUMBER() Over(Order By Title_Code, Episode_No Asc) RowId, * InTo #Title_Not_Acquire From #Deal_Right_Title_WithEpsNo deps
	Where deps.Episode_No Not In (Select Episode_No From #Syn_Avail_Title_Eps aeps Where deps.Title_Code = aeps.Title_Code)

	Drop Table #Syn_Avail_Title_Eps
				
	Create Table #Temp_NA_Title(
		Title_Code Int,
		Episode_From Int,
		Episode_To Int,
		Status Char(1)
	)

	Declare @Cur_Title_code Int = 0, @Cur_Episode_No Int = 0, @Prev_Title_Code Int = 0, @Prev_Episode_No Int

	Declare CUS_EPS Cursor For 
	Select Title_code, Episode_No From #Title_Not_Acquire Order By Title_code Asc, Episode_No  Asc
	Open CUS_EPS
	Fetch Next From CUS_EPS InTo @Cur_Title_code, @Cur_Episode_No
	While(@@FETCH_STATUS = 0)
	Begin
	
		If(@Cur_Title_code <> @Prev_Title_Code)
		Begin

			If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
			Begin
				Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
			End

			Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
			Select @Cur_Title_code, @Cur_Episode_No, 'U'
			Set @Prev_Title_Code = @Cur_Title_code
		End
		Else If(@Cur_Title_code = @Prev_Title_Code And @Cur_Episode_No <> (@Prev_Episode_No + 1))
		Begin
			If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Cur_Title_code)
			Begin
				Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Cur_Title_code
			End
	
			Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
			Select @Cur_Title_code, @Cur_Episode_No, 'U'
		End
	
		Set @Prev_Episode_No = @Cur_Episode_No

		Fetch Next From CUS_EPS InTo @Cur_Title_code, @Cur_Episode_No
	End
	Close CUS_EPS
	Deallocate CUS_EPS

	Drop Table #Title_Not_Acquire

	If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
	Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code

	If Exists(Select Top 1 * From #Temp_NA_Title)
	Begin
		Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
													Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Name, Subtitling_Language, 
													Dubbing_Language, Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On,IsPushback)
		Select @SynDealRightsCode, t.Title_Name, 'NA', Null, Null, 
				'NA', 'NA', 'NA', 'NA', 'NA', 
				'NA', 'NA', 'Title not acquired', Episode_From, Episode_To, GETDATE(), Null
		From #Temp_NA_Title tnt
		Inner Join Title t On tnt.Title_Code = t.Title_Code

		Drop Table #Temp_NA_Title

		Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @SynDealRightsCode
		Set @Is_Error = 'Y'
	End
	Else
		Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @SynDealRightsCode

	END----------------------END CHECKING TITLE WITH EPISODE EXIST OR NOT
			
		BEGIN ------------------------------------START CHECK PLATFORM SYNDICATED OR NOT
			Print 'Distinct Platform'
			Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRP.Platform_Code
			InTo #Temp_Platforms_AP
			From #Syn_Titles_AP DRT
			Inner Join @Deal_Rights_Platform DRP On 1 = 1

			Drop Table #Syn_Titles_AP

			Select DISTINCT srt.*, APRMD.SecondaryDataCode AS [Platform_Code]  InTo #Temp_Syn_Platform_AP From #Syn_Titles_With_Rights_AP srt
			Inner Join Syn_Deal_Rights_Platform sdrp On sdrp.Syn_Deal_Rights_Code = srt.Syn_Deal_Rights_Code
			Inner JOIN AcqPreReqMappingData APRMD ON APRMD.PrimaryDataCode = sdrp.Platform_Code
			--Inner Join @Deal_Rights_Platform drp On sdrp.Platform_Code = drp.Platform_Code
			
			Drop Table #Syn_Titles_With_Rights_AP

			Delete From #Temp_Syn_Platform_AP Where Platform_Code Not In (Select Platform_Code From #Temp_Platforms_AP)
			
			Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NA_Platforms_AP
			From #Temp_Platforms_AP DRT
			Where DRT.Platform_Code Not In (
				Select ap.Platform_Code From #Temp_Syn_Platform_AP ap
				Where DRT.Title_Code = ap.Title_Code And DRT.Episode_From = ap.Episode_From And DRT.Episode_To = ap.Episode_To
			)

			Delete From #Temp_Platforms_AP Where #Temp_Platforms_AP.Platform_Code In (
				Select np.Platform_Code From #NA_Platforms_AP np
				Where np.Title_Code = #Temp_Platforms_AP.Title_Code And np.Episode_From = #Temp_Platforms_AP.Episode_From And np.Episode_To = #Temp_Platforms_AP.Episode_To
			)

			--Select * from #Temp_Syn_Platform_AP
			If ((
			SELECT COUNT(DISTINCT PlatformCode) FROM #CurrentPlatform_AP  WHERE PlatformCode NOT IN (
			SELECT DISTINCT Platform_Code FROM Syn_Deal_Rights_Platform Where Syn_Deal_Rights_Code = @SynDealRightsCode
			)) > 0)					
			BEGIN
				Print 'Insertion of Removal Platform in #Dup_Records_Language_AP'
				Insert InTo #Dup_Records_Language_AP(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
				Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, 0, '', 
				@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'V18 Conflicts - Platforms Already Syndicated', @Is_Title_Language_Right 
				From #NA_Platforms_AP np
			
				Drop Table #NA_Platforms_AP
				SET @Is_Error = 'Y'
				PRINT 'Platform Already Syndicated'
			END
		END------------------------------------END CHECK PLATFORM SYNDICATED OR NOT

		BEGIN ------------------------------------START CHECK REGION SYNDICATED OR NOT
	    PRINT 'DISTINCT REGION'
			Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tc.Country_Code InTo #Temp_Country_AP
			From #Temp_Platforms_AP tp
			Inner Join @Deal_Rights_Territory TC On 1 = 1

			Drop Table #Temp_Platforms_AP

			Declare @Thetrical_Platform_Code Int = 0, @Domestic_Country Int = 0
			Select @Thetrical_Platform_Code = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'THEATRICAL_PLATFORM_CODE'
			Select @Domestic_Country = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'INDIA_COUNTRY_CODE'

			If Exists(Select Top 1 * From #Temp_Country_AP Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country)
			Begin	
				Insert InTo #Temp_Country_AP
				Select tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code
				From (
				Select * From #Temp_Country_AP Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
				) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

				Delete From #Temp_Country_AP Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
			End


			Select DISTINCT Syn_Deal_Rights_Code,srter.Territory_Type As [Territory_Type], Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code 
			InTo #Syn_Country_AP
			From (
				Select Syn_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type ,APRMD.SecondaryDataCode AS SecondaryDataCode
				From Syn_Deal_Rights_Territory SDRT
				INNER JOIN AcqPreReqMappingData APRMD ON (APRMD.PrimaryDataCode = SDRT.Territory_Code AND SDRT.Territory_Type = 'G') OR
				(APRMD.PrimaryDataCode = SDRT.Country_Code AND SDRT.Territory_Type = 'I')
				Where SDRT.Syn_Deal_Rights_Code  In (Select Syn_Deal_Rights_Code from #Syn_Deal_Rights_AP) 
				AND
				APRMD.MappingFor = IIF(SDRT.Territory_Type = 'G','TERR','CONT')
				) srter
			Left Join RightsU_Broadcast.dbo.Territory_Details td On srter.SecondaryDataCode = td.Territory_Code

			Select DISTINCT tap.*, sdc.Country_Code AS Country_Code InTo #Temp_Syn_Country_AP From #Temp_Syn_Platform_AP tap
			Inner Join #Syn_Country_AP sdc On tap.Syn_Deal_Rights_Code = sdc.Syn_Deal_Rights_Code

			Drop Table #Syn_Country_AP 
			Drop Table #Temp_Syn_Platform_AP

			If Exists(Select Top 1 * From #Temp_Syn_Country_AP Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country)
			Begin
			Insert InTo #Temp_Syn_Country_AP(Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Sum_of, partition_of)
			Select tp.Syn_Deal_Rights_Code, tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code,tp.Sum_of, tp.partition_of
			From (
				Select * From #Temp_Syn_Country_AP Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
			) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

			Delete From #Temp_Syn_Country_AP Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
			End
						
			Delete From #Temp_Syn_Country_AP Where Country_Code Not In (Select Country_Code From #Temp_Country_AP)

			Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code InTo #NA_Country_AP
			From #Temp_Country_AP DRC
			Where DRC.Country_Code Not In (
			Select ac.Country_Code From #Temp_Syn_Country_AP ac
			Where DRC.Title_Code = ac.Title_Code And DRC.Episode_From = ac.Episode_From And DRC.Episode_To = ac.Episode_To And DRC.Platform_Code = ac.Platform_Code
			)
				
			Delete From #Temp_Country_AP Where #Temp_Country_AP.Country_Code In (
			Select np.Country_Code From #NA_Country_AP np
			Where np.Title_Code = #Temp_Country_AP.Title_Code And np.Episode_From = #Temp_Country_AP.Episode_From 
			And np.Episode_To = #Temp_Country_AP.Episode_To And np.Platform_Code = #Temp_Country_AP.Platform_Code
			)
					
			IF ((
			SELECT COUNT(DISTINCT CountryCode) FROM #CurrentRegion_AP  WHERE CountryCode NOT IN (
			Select Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code 
			FROM (
				Select Territory_Code, Country_Code, Territory_Type 
				From Syn_Deal_Rights_Territory  
				Where Syn_Deal_Rights_Code = @SynDealRightsCode
			) As srter
			Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code
			)) > 0)
			BEGIN
				Insert InTo #Dup_Records_Language_AP(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
							 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
				@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'V18 Conflicts - Region Already Syndicated', @Is_Title_Language_Right 
				From #NA_Country_AP np

				    Drop Table #NA_Country_AP
				SET @Is_Error = 'Y'
				PRINT 'Region Already Syndicated'
			END

			If(@Is_Title_Language_Right = 'Y')
			Begin
				INSERT INTO #TempCombination_Session_AP(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
													 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
													 Data_From, Is_Available, Error_Description,
													 Sum_of,partition_of)
				SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
					T.Country_Code, 'I', @Is_Exclusive, 0, 0,
					'S', 'N', 'Session',
					Case 
						When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					End Sum_of,
					Case 
						When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					End partition_of
				From #Temp_Country_AP T
			END

			INSERT INTO #TempCombination_AP
			(
				Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
				Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
				Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
			)
			SELECT DISTINCT SDR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, SDR.Right_Type, 
				SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Is_Title_Language_Right, ac.Country_Code, 'I', SDR.Is_Exclusive, 
				0, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
			FROM #Temp_Syn_Country_AP ac 
			Inner Join #Syn_Deal_Rights_AP SDR On SDR.Syn_Deal_Rights_Code= ac.Syn_Deal_Rights_Code
			Where SDR.Is_Title_Language_Right = 'Y'
				
		END--------------------------------------START CHECK REGION SYNDICATED OR NOT

		BEGIN ------------------------------------START CHECK SUBTITLE SYNDICATED OR NOT
			Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Subtitling_Code
			InTo #Temp_Subtitling_AP From #Temp_Country_AP tp
			Inner Join @Deal_Rights_Subtitling ts On 1 = 1

			--Select * from #Temp_Country_AP
			If Exists(Select Top 1 * From @Deal_Rights_Subtitling)
			Begin
					Select Syn_Deal_Rights_Code, CASE WHEN sub.Language_Type = 'G' Then lgd.Language_Code Else sub.Language_Code End Language_Code 
					InTo #Syn_Sub_AP From (
						Select DISTINCT Syn_Deal_Rights_Code,Language_Group_Code, Language_Type, APRMD.SecondaryDataCode AS [Language_Code] 
						From Syn_Deal_Rights_Subtitling sdrs 
						INNER JOIN AcqPreReqMappingData APRMD ON (APRMD.PrimaryDataCode = sdrs.Language_Code AND sdrs.Language_Type = 'I') OR
						(APRMD.PrimaryDataCode = sdrs.Language_Group_Code AND sdrs.Language_Type = 'G')  OR (APRMD.PrimaryDataCode = sdrs.Language_Code AND sdrs.Language_Type = 'L')  
						Where Syn_Deal_Rights_Code In (Select Syn_Deal_Rights_Code from #Syn_Deal_Rights_AP) AND 
						APRMD.MappingFor = IIF(sdrs.Language_Type= 'G','LAGR','LANG')
					)As sub
					LEFT JOIN RightsU_Broadcast.dbo.Language_Group_Details lgd On sub.Language_Group_Code = lgd.Language_Group_Code 

					Delete From #Syn_Sub_AP Where Language_Code Not In (Select Subtitling_Code From @Deal_Rights_Subtitling)
					
					Select DISTINCT tac.*, sdrs.Language_Code  InTo #Temp_Syn_Subtitling_AP From #Temp_Syn_Country_AP tac
					Inner Join #Syn_Sub_AP sdrs On tac.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code 
					--INNER JOIN AcqPreReqMappingData APRMD ON APRMD.PrimaryDataCode = sdrs.Language_Code

					Drop Table #Syn_Sub_AP
					
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Subtitling_Code InTo #NA_Subtitling_AP
					From #Temp_Subtitling_AP DRC
					Where DRC.Subtitling_Code Not In (
						Select ssub.Language_Code From #Temp_Syn_Subtitling_AP ssub
						Where DRC.Title_Code = ssub.Title_Code And DRC.Episode_From = ssub.Episode_From And DRC.Episode_To = ssub.Episode_To 
						And DRC.Platform_Code = ssub.Platform_Code And DRC.Country_Code = ssub.Country_Code
					)
					
					Delete From #Temp_Subtitling_AP Where #Temp_Subtitling_AP.Subtitling_Code In (
						Select ssub.Subtitling_Code From #NA_Subtitling_AP ssub
						Where #Temp_Subtitling_AP.Title_Code = ssub.Title_Code And #Temp_Subtitling_AP.Episode_From = ssub.Episode_From And #Temp_Subtitling_AP.Episode_To = ssub.Episode_To 
						And #Temp_Subtitling_AP.Platform_Code = ssub.Platform_Code And #Temp_Subtitling_AP.Country_Code = ssub.Country_Code
					)
					 
					IF ((
						SELECT COUNT(DISTINCT SubLanguageCode) FROM #CurrentSubtitling_AP  WHERE SubLanguageCode NOT IN (
						SELECT DISTINCT  Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
						From (
							SELECT DISTINCT  Language_Code, Language_Group_Code, Language_Type
							FROM Syn_Deal_Rights_Subtitling SDRS
							Where Syn_Deal_Rights_Code = @SynDealRightsCode 
						) AS Srlan
						Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code
						)) > 0)
					BEGIN
						Insert InTo #Dup_Records_Language_AP(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
												 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
							)
							Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
							   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'V18 Conflicts - Subtitling Already Syndicated', @Is_Title_Language_Right, Subtitling_Code, 0
							From #NA_Subtitling_AP nsub
						
							Drop Table #NA_Subtitling_AP
						SET @Is_Error = 'Y'
						PRINT 'Subtitling Already Syndicated'
					End

					INSERT INTO #TempCombination_Session_AP(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
						 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
						 Data_From, Is_Available, Error_Description,
						 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
					T.Country_Code, 'I', @Is_Exclusive, Subtitling_Code, 0,
					'S', 'N', 'Session',
					Case 
						When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					End Sum_of,
					Case 
						When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					End partition_of
					From #Temp_Subtitling_AP T

					INSERT INTO #TempCombination_AP
					(
						Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
						Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
						Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
					)
					SELECT DISTINCT SDR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, SDR.Right_Type, 
						SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Is_Title_Language_Right, ac.Country_Code, 'I', SDR.Is_Exclusive, 
						Language_Code, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
					FROM #Temp_Syn_Subtitling_AP ac 
					Inner Join #Syn_Deal_Rights_AP SDR On SDR.Syn_Deal_Rights_Code= ac.Syn_Deal_Rights_Code
			END	
		END -----------------------------------END CHECK SUBTITLE SYNDICATED OR NOT

		BEGIN ------------------------------------START CHECk DUBBING SYNDICATED OR NOT
	
			Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Dubbing_Code
			InTo #Temp_Dubbing_AP From #Temp_Country_AP tp
			Inner Join @Deal_Rights_Dubbing ts On 1 = 1

			If Exists(Select Top 1 * From @Deal_Rights_Dubbing)
			Begin
					Print 'Dubbing Begins'
					Select Syn_Deal_Rights_Code, Case When dub.Language_Type = 'G' Then lgd.Language_Code Else dub.Language_Code End Language_Code InTo #Syn_Dub_AP
					From (
						Select DISTINCT Syn_Deal_Rights_Code,Language_Group_Code, Language_Type, APRMD.SecondaryDataCode AS [Language_Code] 
						From Syn_Deal_Rights_Dubbing SDRD
						INNER JOIN AcqPreReqMappingData APRMD ON (APRMD.PrimaryDataCode = SDRD.Language_Code AND SDRD.Language_Type = 'I') OR
						(APRMD.PrimaryDataCode = SDRD.Language_Group_Code AND SDRD.Language_Type = 'G') OR (APRMD.PrimaryDataCode = SDRD.Language_Code AND SDRD.Language_Type = 'L')
						Where Syn_Deal_Rights_Code In (Select Syn_Deal_Rights_Code from #Syn_Deal_Rights_AP) AND 
						APRMD.MappingFor = IIF(SDRD.Language_Type= 'G','LAGR','LANG')
					)As dub
					Left Join RightsU_Broadcast.dbo.Language_Group_Details lgd On dub.Language_Group_Code = lgd.Language_Group_Code 
					
					Delete From #Syn_Dub_AP Where Language_Code Not In (Select Dubbing_Code From @Deal_Rights_Dubbing)

					Select DISTINCT tac.*, sdrs.Language_Code InTo #Temp_Syn_Dubbing_AP From #Temp_Syn_Country_AP tac
					Inner Join #Syn_Dub_AP sdrs On tac.Syn_Deal_Rights_Code = sdrs.Syn_Deal_Rights_Code 

					Drop Table #Syn_Dub_AP
					
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Dubbing_Code InTo #NA_Dubbing_AP
					From #Temp_Dubbing_AP DRC
					Where DRC.Dubbing_Code Not In (
						Select sdub.Language_Code From #Temp_Syn_Dubbing_AP sdub
						Where DRC.Title_Code = sdub.Title_Code And DRC.Episode_From = sdub.Episode_From And DRC.Episode_To = sdub.Episode_To 
						And DRC.Platform_Code = sdub.Platform_Code And DRC.Country_Code = sdub.Country_Code
					)

					Delete From #Temp_Dubbing_AP Where #Temp_Dubbing_AP.Dubbing_Code In (
						Select sdub.Dubbing_Code From #NA_Dubbing_AP sdub
						Where #Temp_Dubbing_AP.Title_Code = sdub.Title_Code And #Temp_Dubbing_AP.Episode_From = sdub.Episode_From And #Temp_Dubbing_AP.Episode_To = sdub.Episode_To 
						And #Temp_Dubbing_AP.Platform_Code = sdub.Platform_Code And #Temp_Dubbing_AP.Country_Code = sdub.Country_Code
					)

					PRINT 'Dubbing Already Syndicated'

					IF ((
					SELECT COUNT(DISTINCT DubLanguageCode) FROM #CurrentDubbing_AP  WHERE DubLanguageCode NOT IN (
					SELECT DISTINCT Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
					From (
						SELECT DISTINCT Language_Code,Language_Group_Code, Language_Type
						FROM Syn_Deal_Rights_Dubbing SDRD
						Where Syn_Deal_Rights_Code = @SynDealRightsCode 
					) AS Srlan
					Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code
					)) > 0)
					BEGIN
						Insert InTo #Dup_Records_Language_AP(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
												 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
						)
						Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
							   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'V18 Conflicts - Dubbing Already Syndicated', @Is_Title_Language_Right, 0, Dubbing_Code
						From #NA_Dubbing_AP nsub
						
						Drop Table #NA_Dubbing_AP
						SET @Is_Error = 'Y'
						PRINT 'Dubbing Already Syndicated'
					END

					INSERT INTO #TempCombination_Session_AP(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
																 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
																 Data_From, Is_Available, Error_Description,
																 Sum_of,partition_of)

					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
					T.Country_Code, 'I', @Is_Exclusive, 0, Dubbing_Code,'S', 'N', 'Session',
					Case 
						When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					End Sum_of,
					Case 
						When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
					End partition_of
					From #Temp_Dubbing_AP T

					INSERT INTO #TempCombination_AP
					(
							Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
							Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
							Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
					)
					SELECT DISTINCT SDR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, SDR.Right_Type, 
						SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Is_Title_Language_Right, ac.Country_Code, 'I', SDR.Is_Exclusive, 
						0, ac.Language_Code, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
					FROM #Temp_Syn_Dubbing_AP ac 
					Inner Join #Syn_Deal_Rights_AP SDR On SDR.Syn_Deal_Rights_Code= ac.Syn_Deal_Rights_Code
			END
		END ------------------------------------START CHECk DUBBING SYNDICATED OR NOT
		
		BEGIN --------------------------------START Updation of #TempCombination_Session_AP
			UPDATE b SET b.Sum_of = (
					SELECT SUM(c.Sum_of) FROM(
						SELECT DISTINCT a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Subtitling_Language_Code, 
						a.Dubbing_Language_Code, a.Sum_of FROM #TempCombination_AP AS a
					) AS c WHERE c.Title_Code = b.Title_Code And c.Episode_From = b.Episode_From And c.Episode_To = b.Episode_To AND
					c.Platform_Code = b.Platform_Code And c.Country_Code = b.Country_Code And c.Subtitling_Language_Code = b.Subtitling_Language_Code AND 
					c.Dubbing_Language_Code = b.Dubbing_Language_Code 
				) From #TempCombination_AP b			

			CREATE TABLE #Min_Right_Start_Date_AP
				(
					Title_Code INT,
					Min_Start_Date DateTime
				)
			
			INSERT INTO #Min_Right_Start_Date_AP
			SELECT T1.Title_Code,MIN(T1.Right_Start_Date) FROM  #TempCombination_AP T1
			GROUP BY T1.Title_Code
			
			IF(@Right_Type ='U' AND EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination_AP WHERE Right_Type='U') AND NOT EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination_AP WHERE Right_Type='Y'))
			BEGIN				
				DELETE T1 				
				FROM #TempCombination_AP T1 
				INNER JOIN #Min_Right_Start_Date_AP MRSD ON T1.Title_Code = MRSD.Title_Code
				WHERE CONVERT(DATETIME, @Right_Start_Date, 103) <= CONVERT(DATETIME, IsNull(T1.Right_Start_Date,''), 103)				
			END
					
			UPDATE t2 Set t2.Is_Available = 'Y'
			FROM #TempCombination_Session_AP t2 
			LEFT join #Min_Right_Start_Date_AP MRSD on T2.Title_Code = MRSD.Title_Code
			Inner Join #TempCombination_AP t1 On 
			T1.Title_Code = T2.Title_Code And 
			T1.Episode_From = T2.Episode_From And 
			T1.Episode_To = T2.Episode_To And 
			T1.Platform_Code = T2.Platform_Code And 
			T1.Country_Code= T2.Country_Code And 
			T1.Subtitling_Language_Code = T2.Subtitling_Language_Code And 
			T1.Dubbing_Language_Code = T2.Dubbing_Language_Code  
			And 
			(
				(
					(t1.sum_of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End)) OR
					(
						(T1.Right_Type = 'U' OR T2.Right_Type = 'U') AND
						(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, IsNull(MRSD.MIN_Start_DATE,t1.Right_Start_Date), 103))
					)
				)OR
				(t1.Partition_Of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End))
			)AND 
			(
				((T1.Right_Type <> 'Y'  AND T1.Right_Type <> 'M') AND T2.Right_Type = 'U') OR
				((T1.Right_Type = 'Y' OR T1.Right_Type = 'M') AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M')) OR
				(T1.Right_Type = 'U' AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M'))
			)
			DROP TABLE #Min_Right_Start_Date_AP
					 	
			Update TCS Set TCS.Error_Description = (
			Case 
				When (
					Select Count(*) Title_Code From #TempCombination_AP TC Where TCS.Title_Code = TC.Title_Code
				) = 0 Then 'TITLE_MISMATCH' Else '' 
			End + 
			Case 
				When (
					Select Count(*) From #TempCombination_AP TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
				) = 0 Then 'PLATFORM_MISMATCH' Else '' 
			End +
			Case 
				When (
					Select Count(*) Title_Code From #TempCombination_AP TC Where TCS.Title_Code = TC.Title_Code 
					AND TC.Platform_Code = TCS.Platform_Code AND TC.Country_Code = TCS.Country_Code
				) = 0 Then 'COUNTRY_MISMATCH' Else '' 
			End +
			Case 
				When TCS.Is_Title_Language_Right = 'Y' AND TCS.Subtitling_Language_Code = 0 AND TCS.Dubbing_Language_Code = 0 AND (
					Select Count(*) Title_Code From #TempCombination_AP TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
					And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 And 0 = TCS.Dubbing_Language_Code 
					And TCS.Is_Title_Language_Right = TC.Is_Title_Language_Right
				) = 0 Then 'TITLE_LANGAUGE_RIGHT' Else '' 
			End +
			Case 
				When TCS.Dubbing_Language_Code > 0 AND (
					Select Count(*) Title_Code From #TempCombination_AP TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
					And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 
					And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code
				) = 0 Then 'DUBBING_LANGAUGE_RIGHT' Else '' 
			End +
			Case 
				When TCS.Subtitling_Language_Code > 0 And (Select Count(*) Title_Code From #TempCombination_AP TC 
							Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
								  And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
								  And 0 = TCS.Dubbing_Language_Code) = 0 
				Then 'SUBTITLING_LANGAUGE_RIGHT' Else '' 
			End +
			Case 
				When (Select Count(*) Title_Code From #TempCombination_AP TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
					And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
					And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code And (
						( 
							(TCS.sum_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END))OR
							(
								(TCS.Right_Type = 'U' OR TC.Right_Type = 'U') AND
								(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, ISNULL(TCS.Right_Start_Date,'') , 103))
							)
						)OR
						(TCS.partition_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END))           
					)
				) = 0 Then 'RIGHT_PERIOD' Else ''
			End
			) FROM #TempCombination_Session_AP TCS
			Where Is_Available='N'

			--Select Error_Description, * From #TempCombination_Session_AP Where Title_Code = 5159 And Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Title not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Dubbing Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Subtitling Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Title Language not acquired') Where Is_Available='N'
			
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Platform not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Platform not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'

			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCH', 'V18 - Title not acquired') Where Is_Available='N'

			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'COUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Region not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'SUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Subtitling Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'DUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Dubbing Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session_AP Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'V18 - Title Language not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session_AP Set Error_Description = 'V18 - Rights period mismatch' Where Is_Available='N' And Error_Description = ''

			Insert InTo #Dup_Records_Language_AP(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
			)
			Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					--Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, 'Rights Period Mismatch', Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
					Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, Error_Description, Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
			From #TempCombination_Session_AP nsub Where Is_Available='N'
		END --------------------------END Updation of #TempCombination_Session_AP
		
		BEGIN ----------------------------------START INSERTION OF DATA IN ERROR TABLE
			Declare @Deal_Type_Code Int = 0, @Deal_Type Varchar(20) = ''
			Select @Deal_Type_Code = Deal_Type_Code From Syn_Deal Where Syn_Deal_Code = @Deal_Code
			Select @Deal_Type = [dbo].[UFN_GetDealTypeCondition](@Deal_Type_Code)
			Print 'Initialize Data Insertion in error details'
			If Exists(Select Top 1 * From #Dup_Records_Language_AP)
			Begin
				Print 'Insertion of data in Error table'
				Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Name, 
															Subtitling_Language, 
															Dubbing_Language, 
															Agreement_No, 
															ErrorMsg, Episode_From, Episode_To, Inserted_On, IsPushback)
				Select @SynDealRightsCode, Title_Name, abcd.Platform_Hiearachy Platform_Name, Right_Start_Date as Right_Start_Date, Right_End_Date as Right_End_Date,
					CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
					CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
					CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
					Country_Name,
					CASE WHEN IsNull(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
					CASE WHEN IsNull(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
					Agreement_No,  
					IsNull(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, Getdate(), 'N'
				From(
					Select *,
					STUFF
					(
						(
						Select ', ' + C.Country_Name From RightsU_Broadcast.dbo.Country C 
						Where c.Country_Code In(
							Select Distinct Country_Code From #Dup_Records_Language_AP adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						) --And C.Country_Code in (select distinct Country_Code from #Deal_Rights_Territory)
						FOR XML PATH('')), 1, 1, ''
					) as Country_Name,
					STUFF
					(
						(
						Select ',' + CAST(P.Platform_Code as Varchar) 
						From Platform p Where p.Platform_Code In
						(
							Select Distinct Platform_Code From #Dup_Records_Language_AP adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Platform_Code,
					STUFF
					(
						(
						Select ', ' + l.Language_Name From RightsU_Broadcast.dbo.Language l 
						Where l.Language_Code In(
							Select Distinct Subtitling_Language From #Dup_Records_Language_AP adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Subtitling_Language,
					STUFF
					(
						(
						Select ', ' + l.Language_Name From RightsU_Broadcast.dbo.Language l 
						Where l.Language_Code In(
							Select Distinct Dubbing_Language From #Dup_Records_Language_AP adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Dubbing_Language,
					STUFF
					(
						(
						Select ', ' + t.Agreement_No From (
							Select Distinct Agreement_No From #Dup_Records_Language_AP adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						) As t
						FOR XML PATH('')), 1, 1, ''
					) as Agreement_No
					From (
						Select T.Title_Code,
							DBO.UFN_GetTitleNameInFormat(@Deal_Type, T.Title_Name, Episode_From, Episode_To) AS Title_Name,
							ADR.Right_Start_Date, ADR.Right_End_Date,
							Is_Sub_License, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To
						from (
							Select Distinct Title_Code, Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, ErrorMSG, Right_Type
							From #Dup_Records_Language_AP
						) ADR
						INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
					) as a
				) as MainOutput
				Cross Apply
				(
					Select * From RightsU_Broadcast.[dbo].[UFN_Get_Platform_With_Parent] (MainOutput.Platform_Code)
				) as abcd

				--Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @SynDealRightsCode

				Set @Is_Error = 'Y'
				PRINT 'Duplicate Already Syndicated'
			END	 
		END-------------------------------------START INSERTION OF DATA IN ERROR TABLE
		PRINT '  *****************************'
		FETCH NEXT FROM CUR_DestSynRights InTo @SynDealRightsCodeV18
	END ----------------------END CURSOR FOR MULTIPLE SYNDICATION RIGHTS CODE
	CLOSE CUR_DestSynRights    
	DEALLOCATE CUR_DestSynRights   
	Select @Is_Error

	IF OBJECT_ID('tempdb..#Acq_Avail_Title_Eps') IS NOT NULL DROP TABLE #Acq_Avail_Title_Eps
	IF OBJECT_ID('tempdb..#CurrentDubbing') IS NOT NULL DROP TABLE #CurrentDubbing
	IF OBJECT_ID('tempdb..#CurrentDubbing_AP') IS NOT NULL DROP TABLE #CurrentDubbing_AP
	IF OBJECT_ID('tempdb..#CurrentPlatform') IS NOT NULL DROP TABLE #CurrentPlatform
	IF OBJECT_ID('tempdb..#CurrentPlatform_AP') IS NOT NULL DROP TABLE #CurrentPlatform_AP
	IF OBJECT_ID('tempdb..#CurrentRegion') IS NOT NULL DROP TABLE #CurrentRegion
	IF OBJECT_ID('tempdb..#CurrentRegion_AP') IS NOT NULL DROP TABLE #CurrentRegion_AP
	IF OBJECT_ID('tempdb..#CurrentSubtitling') IS NOT NULL DROP TABLE #CurrentSubtitling
	IF OBJECT_ID('tempdb..#CurrentSubtitling_AP') IS NOT NULL DROP TABLE #CurrentSubtitling_AP
	IF OBJECT_ID('tempdb..#CurrentTitle_AP') IS NOT NULL DROP TABLE #CurrentTitle_AP
	IF OBJECT_ID('tempdb..#Deal_Right_Title_WithEpsNo') IS NOT NULL DROP TABLE #Deal_Right_Title_WithEpsNo
	IF OBJECT_ID('tempdb..#Deal_Rights_Territory') IS NOT NULL DROP TABLE #Deal_Rights_Territory
	IF OBJECT_ID('tempdb..#DstSynRights') IS NOT NULL DROP TABLE #DstSynRights
	IF OBJECT_ID('tempdb..#Dup_Records_Language_AP') IS NOT NULL DROP TABLE #Dup_Records_Language_AP
	IF OBJECT_ID('tempdb..#Min_Right_Start_Date_AP') IS NOT NULL DROP TABLE #Min_Right_Start_Date_AP
	IF OBJECT_ID('tempdb..#NA_Country_AP') IS NOT NULL DROP TABLE #NA_Country_AP
	IF OBJECT_ID('tempdb..#NA_Dubbing_AP') IS NOT NULL DROP TABLE #NA_Dubbing_AP
	IF OBJECT_ID('tempdb..#NA_Platforms_AP') IS NOT NULL DROP TABLE #NA_Platforms_AP
	IF OBJECT_ID('tempdb..#NA_Subtitling_AP') IS NOT NULL DROP TABLE #NA_Subtitling_AP
	IF OBJECT_ID('tempdb..#Syn_Avail_Title_Eps') IS NOT NULL DROP TABLE #Syn_Avail_Title_Eps
	IF OBJECT_ID('tempdb..#Syn_Country_AP') IS NOT NULL DROP TABLE #Syn_Country_AP
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_AP') IS NOT NULL DROP TABLE #Syn_Deal_Rights_AP
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_AP_Dubbing') IS NOT NULL DROP TABLE #Syn_Deal_Rights_AP_Dubbing
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_AP_Platform') IS NOT NULL DROP TABLE #Syn_Deal_Rights_AP_Platform
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_AP_Subtitling') IS NOT NULL DROP TABLE #Syn_Deal_Rights_AP_Subtitling
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_AP_Territory') IS NOT NULL DROP TABLE #Syn_Deal_Rights_AP_Territory
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_AP_Title') IS NOT NULL DROP TABLE #Syn_Deal_Rights_AP_Title
	IF OBJECT_ID('tempdb..#Syn_Dub_AP') IS NOT NULL DROP TABLE #Syn_Dub_AP
	IF OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') IS NOT NULL DROP TABLE #Syn_Rights_Code_Lang
	IF OBJECT_ID('tempdb..#Syn_Rights_New') IS NOT NULL DROP TABLE #Syn_Rights_New
	IF OBJECT_ID('tempdb..#Syn_Sub_AP') IS NOT NULL DROP TABLE #Syn_Sub_AP
	IF OBJECT_ID('tempdb..#Syn_Titles_AP') IS NOT NULL DROP TABLE #Syn_Titles_AP
	IF OBJECT_ID('tempdb..#Syn_Titles_With_Rights_AP') IS NOT NULL DROP TABLE #Syn_Titles_With_Rights_AP
	IF OBJECT_ID('tempdb..#Temp_Country_AP') IS NOT NULL DROP TABLE #Temp_Country_AP
	IF OBJECT_ID('tempdb..#Temp_Dubbing_AP') IS NOT NULL DROP TABLE #Temp_Dubbing_AP
	IF OBJECT_ID('tempdb..#Temp_Episode_No') IS NOT NULL DROP TABLE #Temp_Episode_No
	IF OBJECT_ID('tempdb..#Temp_NA_Title') IS NOT NULL DROP TABLE #Temp_NA_Title
	IF OBJECT_ID('tempdb..#Temp_Platforms_AP') IS NOT NULL DROP TABLE #Temp_Platforms_AP
	IF OBJECT_ID('tempdb..#Temp_Subtitling_AP') IS NOT NULL DROP TABLE #Temp_Subtitling_AP
	IF OBJECT_ID('tempdb..#Temp_Syn_Country_AP') IS NOT NULL DROP TABLE #Temp_Syn_Country_AP
	IF OBJECT_ID('tempdb..#Temp_Syn_Dubbing_AP') IS NOT NULL DROP TABLE #Temp_Syn_Dubbing_AP
	IF OBJECT_ID('tempdb..#Temp_Syn_Platform_AP') IS NOT NULL DROP TABLE #Temp_Syn_Platform_AP
	IF OBJECT_ID('tempdb..#Temp_Syn_Subtitling_AP') IS NOT NULL DROP TABLE #Temp_Syn_Subtitling_AP
	IF OBJECT_ID('tempdb..#TempCombination_AP') IS NOT NULL DROP TABLE #TempCombination_AP
	IF OBJECT_ID('tempdb..#TempCombination_Session_AP') IS NOT NULL DROP TABLE #TempCombination_Session_AP
	IF OBJECT_ID('tempdb..#Title_Not_Acquire') IS NOT NULL DROP TABLE #Title_Not_Acquire
END
--Select @Is_Error
--Select @AcqDealRightsCode
		
		--DROP TABLE #CurrentPlatform
		--DROP TABLE #CurrentRegion
		--DROP TABLE #CurrentSubtitling
		--DROP TABLE #CurrentDubbing
		--DROP TABLE #Dup_Records_Language_AP
		--DROP TABLE #Syn_Deal_Rights_AP
		--DROP TABLE #Temp_Platforms_AP
		--DROP TABLE #Syn_Titles_With_Rights_AP
		--DROP TABLE #Syn_Titles_AP
		--DROP TABLE #Temp_Syn_Platform_AP
		--DROP TABLE #NA_Platforms_AP
		--DROP TABLE #NA_Country_AP
		--DROP TABLE #NA_Subtitling_AP
		--DROP TABLE #NA_Dubbing_AP
		--DROP TABLE #Temp_Country_AP
		--DROP TABLE #Temp_Syn_Country_AP
		--DROP TABLE #Syn_Country_AP
		--DROP TABLE #Temp_Subtitling_AP
		--DROP TABLE #Temp_Dubbing_AP
		--DROP TABLE #Temp_Syn_Subtitling_AP
		--DROP TABLE #Temp_Syn_Dubbing_AP
		--DROP TABLE #Syn_Sub_AP
		--DROP TABLE #Syn_Dub_AP

		--Drop Table #Syn_Rights_New
		--Drop Table #Syn_Deal_Rights_AP
		--Drop Table #Syn_Deal_Rights_AP_Title
		--Drop Table #Syn_Deal_Rights_AP_Platform
		--Drop Table #Syn_Deal_Rights_AP_Territory
		--Drop Table #Syn_Deal_Rights_AP_Subtitling
		--Drop Table #Syn_Deal_Rights_AP_Dubbing
		--Drop Table #Syn_Rights_Code_Lang