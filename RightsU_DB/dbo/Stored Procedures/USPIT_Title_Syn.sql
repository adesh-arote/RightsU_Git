CREATE PROCEDURE [dbo].[USPIT_Title_Syn] 
@TitleCode INT 
AS
-- =============================================
-- Author:         <Sachin Karande>
-- Create date:	   <04 Feb 2020>
-- Description:    <Title Syndicated active rights with respect to todays date>
-- =============================================
BEGIN 
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPIT_Title_Syn]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--30184,30185,30186,30187,30188,394,1714,1798,3272,30113
		--DECLARE @TitleCode INT = 36458
	  
		SET FMTONLY OFF;
		SET NOCOUNT ON;
	
		PRINT '----------------------------Start Logic------------------------------------------------'
		/************************DELETE TEMP TABLES *************************/
		BEGIN

   			IF OBJECT_ID('tempdb..#TitleDetails') IS NOT NULL
			BEGIN
				DROP TABLE #TitleDetails
			END
			IF OBJECT_ID('tempdb..#RightsPlatformDetails') IS NOT NULL
			BEGIN
				DROP TABLE #RightsPlatformDetails
			END
			IF OBJECT_ID('tempdb..#PlatformDetails') IS NOT NULL
			BEGIN
				DROP TABLE #PlatformDetails
			END
			IF OBJECT_ID('tempdb..#tmpPlat') IS NOT NULL
			BEGIN
				DROP TABLE #tmpPlat
			END
			IF OBJECT_ID('tempdb..#tmpParentPlatformWithChildCount') IS NOT NULL DROP TABLE #tmpParentPlatformWithChildCount
			IF OBJECT_ID('tempdb..#tmpChildPlatformWithParentCode') IS NOT NULL DROP TABLE #tmpChildPlatformWithParentCode
		
		END
		 /************************CREATE TEMP TABLES *********************/
		BEGIN
			CREATE TABLE #TitleDetails
			(
				AgreementNo NVARCHAR(MAX),
				VendorName 	NVARCHAR(MAX),
				Exclusivity Varchar(50),
				TitleLanguage NVARCHAR(MAX),
				Syn_Deal_Code INT,
				PlatformCodes NVARCHAR(MAX),
				RightStartDate NVArchar(20),
				RightEndDate NVArchar(20),
				Country NVARCHAR(MAX),
				GeographicalBlock NVARCHAR(MAX),
				Subtitling NVARCHAR(MAX),
				Dubbing NVARCHAR(MAX),
				Title_Code INT,
				Syn_Deal_Rights_Code INT,
				Episode_From NVARCHAR(100),
				Episode_To NVARCHAR(100)
			)

			CREATE TABLE #RightsPlatformDetails
			(
				PlatformCodes Varchar(2000),
				Heirarchy_Platform_Code VARCHAR(MAX)
			)

			CREATE TABLE #tmpPlat
			(
				Platform_Codes VARCHAR(MAX),
				--Platform_Type NVARCHAR(MAX),
				Platform_Hierarchy NVARCHAR(MAX)
			)

			CREATE TABLE #PlatformDetails
			(
				Platform_Name Varchar(2000),
				Attrib_Group_Name Varchar(200),
				Mode_Of_Expoitation Varchar(2000),
				PlatformCodes Varchar(2000)
			)
			 /************************END *********************/
		END
	
		BEGIN
	
		 /************************Insert title Rights details in #TitleDetails Table *********************/

		INSERT INTO #TitleDetails
		SELECT  DISTINCT
				ISNULL(SD.Agreement_No,'') As [AgreementNo],ISNULL(V.Vendor_Name,'') [VendorName], 
				CASE 
				WHEN ISNULL(SDR.Is_Exclusive,'') = 'Y' THEN 'Exclusive' 
					 ELSE 'Non-Exclusive'  END [Exclusivity],
			  CASE WHEN ISNULL(SDR.Is_Title_Language_Right,'N')='Y' THEN ISNULL(L.language_name, '') ELSE '' END AS [TitleLanguage], 
				SD.Syn_Deal_Code,
				[dbo].[UFN_Get_Platform_Codes](SDR.Syn_Deal_Rights_Code) [PlatformCodes], 
				REPLACE(CONVERT(NVARCHAR, CAST(SDR.Right_Start_Date as date), 6), ' ', '-') As [RightStartDate],
				REPLACE(CONVERT(NVARCHAR, CAST(SDR.Right_End_Date as date), 6), ' ', '-') As [RightEndDate], 
				DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '','') AS Country,
				DBO.UFN_Get_Rights_Territory(SDR.Syn_Deal_Rights_Code, '') AS GeographicalBlock
				--CASE (DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '',''))
				--	WHEN '' THEN DBO.UFN_Get_Rights_Territory(SDR.Syn_Deal_Rights_Code, '')
				--	ELSE DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '','')
				--	END AS  [Region]
				, DBO.UFN_Get_Rights_Subtitling(SDR.Syn_Deal_Rights_Code, '') [Subtitling]
				,DBO.UFN_Get_Rights_Dubbing(SDR.Syn_Deal_Rights_Code, '') [Dubbing],t.Title_Code,SDR.Syn_Deal_Rights_Code,
				SDRT.Episode_From,SDRT.Episode_To
				FROM Syn_Deal SD WITH (NOLOCK)
				INNER JOIN Syn_Deal_Rights SDR WITH(NOLOCK) 
							ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code --AND ISNULL(SDR.Right_Status, '') = 'C' 
							AND SD.Is_Active = 'Y' 
							AND  ISNULL(SDR.Is_Theatrical_Right,'') = 'N' --AND SDR.PA_Right_Type = 'PR'
				INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) 
							ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code AND SDRT.Title_Code = @TitleCode
				INNER JOIN Vendor V WITH(NOLOCK) 
							ON SD.Vendor_Code = V.Vendor_Code
				INNER JOIN Title T WITH(NOLOCK) 
							ON SDRT.Title_Code = T.title_code AND SDRT.Title_Code = @TitleCode
				LEFT JOIN [Language] L WITH(NOLOCK) 
							ON T.Title_Language_Code = L.language_code
			  WHERE ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), GETDATE()) >= GETDATE()


		/************************END *********************/
	
		END

		BEGIN

		 /************************Insert Unique Platform Codes In #RightsPlatformDetails table *********************/

		 INSERT INTO #RightsPlatformDetails(PlatformCodes)
		 SELECT DISTINCT PlatformCodes From #TitleDetails  WHERE RTRIM(LTRIM(ISNULL(PlatformCodes,''))) <> ''
	 
		 /************************END *********************/
	
		END

		BEGIN
		
			DECLARE @Platform_Codes VARCHAR(MAX) = '', @tmp_Parent_Platform_Code INT
			DECLARE Cur_Platform CURSOR FOR SELECT PlatformCodes FROM #TitleDetails 
			OPEN Cur_Platform
			FETCH NEXT FROM Cur_Platform INTO @Platform_Codes
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
			
				IF OBJECT_ID('tempdb..#tmpParentPlatformWithChildCount') IS NOT NULL DROP TABLE #tmpParentPlatformWithChildCount
				IF OBJECT_ID('tempdb..#tmpChildPlatformWithParentCode') IS NOT NULL DROP TABLE #tmpChildPlatformWithParentCode
			
				DECLARE @tempPlatform AS TABLE 
				(
					Platform_Code INT
				)

				CREATE TABLE #tmpParentPlatformWithChildCount
				(
					Parent_Platform_Code INT,
					Child_Count INT,
					Module_Position VARCHAR(MAX)
				)

				CREATE TABLE #tmpChildPlatformWithParentCode
				(
					Platform_Code INT,
					Parent_Platform_Code INT
				)

				INSERT INTO @tempPlatform
				SELECT Number FROM DBO.fn_Split_withdelemiter(ISNULL(@Platform_Codes,''), ',')

				INSERT INTO #tmpChildPlatformWithParentCode
				SELECT tp.Platform_Code, p.Parent_Platform_Code FROM @tempPlatform tp
				INNER JOIN Platform p (NOLOCK)  ON p.Platform_Code = tp.Platform_Code

				--SELECT * FROM #tmpChildPlatformWithParentCode

				INSERT INTO #tmpParentPlatformWithChildCount(Parent_Platform_Code, Child_Count)
				SELECT tcppc.Parent_Platform_Code, Count(tcppc.Platform_Code) FROM #tmpChildPlatformWithParentCode tcppc
 				GROUP BY tcppc.Parent_Platform_Code
				HAVING tcppc.Parent_Platform_Code IS NOT NULL

				UPDATE tppcc 
				SET tppcc.Module_Position = p.Module_Position
				FROM #tmpParentPlatformWithChildCount tppcc
				INNER JOIN Platform p ON p.Platform_Code = tppcc.Parent_Platform_Code 

				--SELECT * FROM #tmpParentPlatformWithChildCount ORDER BY Parent_Platform_Code --DESC
			
				--WHERE Parent_Platform_Code = 105

				DECLARE @Parent_Platform_Code INT, @Child_Count INT, @tempChildCount INT
				DECLARE Cur_Parent_Platform CURSOR FOR SELECT Parent_Platform_Code, Child_Count FROM #tmpParentPlatformWithChildCount ORDER BY Module_Position DESC
				OPEN Cur_Parent_Platform
				FETCH NEXT FROM Cur_Parent_Platform INTO @Parent_Platform_Code, @Child_Count
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
				
					SELECT @tempChildCount = COUNT(*) FROM Platform (NOLOCK)  WHERE Parent_Platform_Code = @Parent_Platform_Code
					SELECT @Child_Count = Child_Count FROM #tmpParentPlatformWithChildCount WHERE Parent_Platform_Code = @Parent_Platform_Code 

					IF(@Child_Count = @tempChildCount)
					BEGIN
						INSERT INTO #tmpChildPlatformWithParentCode(Platform_Code,Parent_Platform_Code)
						SELECT @Parent_Platform_Code, Parent_Platform_Code FROM Platform  (NOLOCK) 
						WHERE  Platform_Code = @Parent_Platform_Code

						SELECT @tmp_Parent_Platform_Code = Parent_Platform_Code FROM #tmpChildPlatformWithParentCode
						WHERE Platform_Code = @Parent_Platform_Code

						SELECT @Child_Count = Count(Parent_Platform_Code) FROM #tmpChildPlatformWithParentCode
						GROUP BY Parent_Platform_Code
						HAVING Parent_Platform_Code = @tmp_Parent_Platform_Code

						UPDATE #tmpParentPlatformWithChildCount
						SET Child_Count = @Child_Count
						WHERE Parent_Platform_Code = @tmp_Parent_Platform_Code

						DELETE FROM #tmpChildPlatformWithParentCode
						WHERE Parent_Platform_Code = @Parent_Platform_Code 
					END
					ELSE
					BEGIN
						DELETE FROM #tmpChildPlatformWithParentCode
						WHERE Platform_Code = @Parent_Platform_Code
					END

					--SELECT @Parent_Platform_Code,'+',@Child_Count,@tempChildCount
					--SELECT * FROM #tmpChildPlatformWithParentCode WHERE Parent_Platform_Code = 137


					UPDATE #RightsPlatformDetails
					SET Heirarchy_Platform_Code = (
						STUFF((
					SELECT ',' + CAST(Platform_Code AS VARCHAR(MAX)) FROM #tmpChildPlatformWithParentCode
					FOR XML PATH('')), 1, 1, ''))
					WHERE PlatformCodes = @Platform_Codes

					FETCH NEXT FROM Cur_Parent_Platform INTO @Parent_Platform_Code, @Child_Count	
				END
				CLOSE Cur_Parent_Platform
				DEALLOCATE Cur_Parent_Platform
				
				FETCH NEXT FROM Cur_Platform INTO @Platform_Codes	
			END
			CLOSE Cur_Platform
			DEALLOCATE Cur_Platform

			INSERT INTO #tmpPlat(Platform_Codes, Platform_Hierarchy)
			SELECT tp.PlatformCodes,
			STUFF((
				SELECT '~', ROW_NUMBER() OVER (ORDER BY p.Module_Position), ') '+ p.Platform_Hiearachy FROM Platform p (NOLOCK) 
				WHERE p.Platform_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(ISNULL(tp.Heirarchy_Platform_Code,''), ','))
				ORDER BY p.Module_Position
				FOR XML PATH('')), 1, 1, ''
			) AS Platform_Hierarchy
			FROM (
				SELECT DISTINCT PlatformCodes,Heirarchy_Platform_Code FROM #RightsPlatformDetails
			) tp

		/************************Insert Platform Wise Sub Details As Parent Platform and Linear/non Linear *********************/

		--Insert InTo #PlatformDetails
		--Select p.Platform_Name, p.Attrib_Group_Name, p.Mode_Of_Expoitation, rpd.PlatformCodes
		--From #RightsPlatformDetails rpd
		--Cross Apply DBO.[UFN_Get_Platform_Group](rpd.PlatformCodes) p

		 /************************END *********************/
		END

		BEGIN

		SELECT 
		ISNULL(T.AgreementNo,'') AgreementNo,
		ISNULL(T.VendorName,'') VendorName,
		--ISNULL(p.Attrib_Group_Name,'')  AttribGroupName,
		--ISNULL(P.Platform_Name,'') PlatformName,
		--ISNULL(P.Mode_Of_Expoitation,'') ParentPlatformName,
		ISNULL(P.Platform_Hierarchy,'') Platform,
		ISNULL(T.Exclusivity,'') Exclusivity,
		ISNULL(T.RightStartDate,'') RightStartDate,
		ISNULL(T.RightEndDate,'') RightEndDate,
		CASE WHEN ISNULL(T.TitleLanguage,'') = '' THEN 'NA'  ELSE ISNULL(T.TitleLanguage,'') END AS TitleLanguage,
		CASE WHEN ISNULL(T.Subtitling,'') = '' THEN 'NA' ELSE ISNULL(T.Subtitling,'') END AS Subtitling,
		CASE WHEN ISNULL(T.Dubbing,'') = '' THEN 'NA' ELSE ISNULL(T.Dubbing,'') END AS Dubbing,
		ISNULL(T.Country,'') Country,
		ISNULL(T.GeographicalBlock,'') GeographicalBlock,
		ISNULL(T.Episode_From,'') AS Episode_From,ISNULL(T.Episode_To,'') Episode_To, 
		Syn_Deal_Code AS DealCode
		FROM #TitleDetails T
		LEFT JOIN #tmpPlat P ON T.PlatformCodes = P.Platform_Codes
		--LEFT JOIN #PlatformDetails P ON T.PlatformCodes = P.PlatformCodes
		ORDER BY AgreementNo
		END

		IF OBJECT_ID('tempdb..#tmpParentPlatformWithChildCount') IS NOT NULL DROP TABLE #tmpParentPlatformWithChildCount
		IF OBJECT_ID('tempdb..#tmpChildPlatformWithParentCode') IS NOT NULL DROP TABLE #tmpChildPlatformWithParentCode
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPIT_Title_Syn]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END