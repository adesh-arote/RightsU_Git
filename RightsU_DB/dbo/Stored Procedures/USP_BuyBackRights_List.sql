CREATE PROCEDURE [dbo].[USP_BuyBackRights_List]
(
	@Right_Type Char(2), 
	@View_Type Char(1), 
	@Deal_Code Int, 
	@Deal_Movie_Codes Varchar(5000),
	@RegionCodes varchar(5000),
	@PlatformCodes varchar(5000),
	@ISExclusive Varchar(5),
	@PageNo INT OUT,
	@PageSize INT = 10,
	@TotalRecord INT OUT,
	@SearchText NVARCHAR(MAX),
	@Deal_Type_Code INT,
	@TitleCodes NVARCHAR(MAX),
	@LicensorCode INT
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BuyBackRights_List]', 'Step 1', 0, 'Started Procedure', 0, ''
	--DECLARE @Right_Type Char(2) = 'SR', 
	--	@View_Type Char(1) = 'G', 
	--	@Deal_Code Int =  5759, 
	--	@Deal_Movie_Codes Varchar(5000) = '',
	--	@RegionCodes varchar(5000) = '',
	--	@PlatformCodes varchar(5000)= '',
	--	@ISExclusive Varchar(5) = 'B',
	--	@PageNo INT = 1,
	--	@PageSize INT = 100,
	--	@TotalRecord INT = 0,
	--	@SearchText NVARCHAR(MAX) = '',
	--	@Deal_Type_Code INT = 1,
	--	@TitleCodes NVARCHAR(MAX) = '1444'

		--INSERT INTO TestParamBB
		--SELECT @Right_Type, @View_Type,	@Deal_Code,@Deal_Movie_Codes, @RegionCodes,@PlatformCodes, @ISExclusive,
		--@PageNo,@PageSize,	@TotalRecord, @SearchText,@Deal_Type_Code,@TitleCodes

		PRINT 'Process Started ' + CAST(GETDATE() AS VARCHAR)
		SET @SearchText = LTRIM(RTRIM(@SearchText))
		IF(@SearchText <> '')
			SET @View_Type = 'G'

		DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''

		PRINT '  Getting ''Deal_Type_Code'' and ''Deal_Type_Condition'''
		--Select @Selected_Deal_Type_Code = --Deal_Type_Code From Syn_Deal WITH(NOLOCK) Where Syn_Deal_Code = @Deal_Code

		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)

	
		PRINT '  Got ''Deal_Type_Code'' : ' + CAST(@Deal_Type_Code AS VARCHAR) + ' and ''Deal_Type_Condition'' : ' + @Deal_Type_Condition

		PRINT '  Drop all temp tables, if exists'
		IF(OBJECT_ID('TEMPDB..#TempRightsPagingData') IS NOT NULL)
			DROP TABLE #TempRightsPagingData

		IF(OBJECT_ID('TEMPDB..#TempTitle') IS NOT NULL)
			DROP TABLE #TempTitle

		IF(OBJECT_ID('TEMPDB..#TempRights') IS NOT NULL)
			DROP TABLE #TempRights

		IF(OBJECT_ID('TEMPDB..#TempResultData') IS NOT NULL)
			DROP TABLE #TempResultData

		IF(OBJECT_ID('TEMPDB..#TempDealMovie') IS NOT NULL)
			DROP TABLE #TempDealMovie

		IF(OBJECT_ID('TEMPDB..#TempPlatformCodes') IS NOT NULL)
			DROP TABLE #TempPlatformCodes

		IF(OBJECT_ID('TEMPDB..#TempRightCodes') IS NOT NULL)
			DROP TABLE #TempRightCodes

		IF(OBJECT_ID('TEMPDB..#TempRightCodesGroup') IS NOT NULL)
			DROP TABLE #TempRightCodesGroup

		IF(OBJECT_ID('TEMPDB..#TempRightCodesSummary') IS NOT NULL)
			DROP TABLE #TempRightCodesSummary

		IF(OBJECT_ID('TEMPDB..#TempRightCodesDetails') IS NOT NULL)
			DROP TABLE #TempRightCodesDetails

		IF(OBJECT_ID('TEMPDB..#TempApprovedRights') IS NOT NULL)
			DROP TABLE #TempApprovedRights
		

		PRINT '  Create temp tables'
		CREATE TABLE #TempRightsPagingData
		(
			Row_No INT IDENTITY(1,1),
			Deal_Code INT,
			Rights_Code INT,
			Title_Code INT DEFAULT(0),
			Episode_From INT DEFAULT(0),
			Episode_To INT DEFAULT(0),
			Platform_Code INT DEFAULT(0),
			Syn_Deal_Rights_Title_Code INT
		)

		CREATE TABLE #TempTitle
		(
			Title_Code INT DEFAULT(0),
			Episode_From INT DEFAULT(0),
			Episode_To INT DEFAULT(0),
			Title_Name NVARCHAR(MAX),
			Is_Closed CHAR(1)
		)

		CREATE TABLE #TempRights
		(
			Deal_Code INT,
			Rights_Code INT,
			Title_Code INT DEFAULT(0),
			Episode_From INT DEFAULT(0),
			Episode_To INT DEFAULT(0),
			Platform_Code INT DEFAULT(0),
			Title_Name NVARCHAR(MAX),
			Platform_Name NVARCHAR(MAX),
			Is_Holdback VARCHAR(5),
			Is_Exclusive VARCHAR(100),
			Is_Sublicencing VARCHAR(5),
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Term VARCHAR(10),
			Is_Theatrical VARCHAR(10),
			Country NVARCHAR(MAX),
			Territory NVARCHAR(MAX),
			Remarks NVARCHAR(max),
			Right_Type VARCHAR(5),
			Is_Tentative VARCHAR(10),
			IsTentative CHAR(1),
			Milestone_Type_Code INT,
			Milestone_No_Of_Unit INT,
			Milestone_Unit_Type INT,
			Title_Language_Right VARCHAR(5),
			Sub_Titling_Language NVARCHAR(MAX),
			Dubbing_Titling_Language NVARCHAR(MAX),
			Right_Term VARCHAR(MAX),
			Right_Status CHAR(1),
			Is_Syn_Acq_Mapp CHAR(1),
			Is_ROFR CHAR(1) NULL ,
			ROFR_Date DATETIME NULL ,
			IsDelete char(1) DEFAULT('N'),
			Is_Ref_Close_Title CHAR(1),
			Last_Updated_Time DATETIME,
			Syn_Deal_Rights_Title_Code INT
		)

		CREATE TABLE #TempResultData
		(
			Agreement_No NVARCHAR(50),
			Title_Language NVARCHAR(100),
			Deal_Code INT,
			Rights_Code INT,
			Title_Code INT DEFAULT(0),
			Episode_From INT DEFAULT(0),
			Episode_To INT DEFAULT(0),
			Platform_Code INT DEFAULT(0),
			Title_Name NVARCHAR(MAX),
			Platform_Name NVARCHAR(MAX),
			Is_Holdback VARCHAR(5),
			Is_Exclusive VARCHAR(100),
			Is_Sublicencing VARCHAR(5),
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Term VARCHAR(10),
			Is_Theatrical VARCHAR(10),
			Country NVARCHAR(MAX),
			Territory NVARCHAR(MAX),
			Remarks NVARCHAR(max),
			Right_Type VARCHAR(5),
			Is_Tentative VARCHAR(10),
			Milestone_Type_Code INT,
			Milestone_No_Of_Unit INT,
			Milestone_Unit_Type INT,
			Title_Language_Right VARCHAR(5),
			Sub_Titling_Language NVARCHAR(MAX),
			Dubbing_Titling_Language NVARCHAR(MAX),
			Right_Term VARCHAR(MAX),
			Right_Status CHAR(1),
			Is_Syn_Acq_Mapp CHAR(1),
			Is_ROFR CHAR(1) NULL ,
			ROFR_Date DATETIME NULL ,
			IsDelete char(1) DEFAULT('N'),
			Is_Ref_Close_Title CHAR(1),
			Last_Updated_Time DATETIME
		)

		CREATE TABLE #TempDealMovie
		(
			Deal_Movie_Code INT,
			Title_Code		INT,
			Episode_From	INT,
			Episode_To		INT
		)

		CREATE TABLE #TempPlatformCodes
		(
			Platform_Code		INT,
			Platform_Hiearachy	NVARCHAR(MAX)
		)

		CREATE TABLE #TempRightCodes
		(
			Right_Code INT,
			Is_Exclusive CHAR(1),
			Last_Updated_Time DATETIME
		)

		CREATE TABLE #TempRightCodesGroup
		(
			Row_No INT IDENTITY(1,1),
			Rights_Code INT,
			Syn_Deal_Rights_Title_Code INT
		)

		CREATE TABLE #TempRightCodesSummary
		(
			Row_No INT IDENTITY(1,1),
			Rights_Code INT,
			Title_Code INT DEFAULT(0),
			Episode_From INT DEFAULT(0),
			Episode_To INT DEFAULT(0),
		)

		CREATE TABLE #TempRightCodesDetails
		(
			Row_No INT IDENTITY(1,1),
			Rights_Code INT,
			Platform_Code INT
		)

		CREATE TABLE #TempApprovedRights(
			Syn_Deal_Code INT,
			Syn_Deal_Rights_Code INT,
			Syn_Deal_Rights_Title_Code INT

		)

		INSERT INTO #TempApprovedRights
		SELECT sd.Syn_Deal_Code, sdr.Syn_Deal_Rights_Code, sdrt.Syn_Deal_Rights_Title_Code 
		FROM Syn_Deal sd  (NOLOCK)
		INNER JOIN Syn_Deal_Rights sdr (NOLOCK) ON sdr.Syn_Deal_Code = sd.Syn_Deal_Code
		INNER JOIN Syn_Deal_rights_title sdrt (NOLOCK) ON sdrt.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
		WHERE sd.Deal_Workflow_Status = 'A' AND GETDATE() BETWEEN sdr.Actual_Right_Start_Date AND sdr.Actual_Right_End_Date
		AND sd.Vendor_Code IN(@LicensorCode)

		IF(ISNULL(@Deal_Movie_Codes, '') = '')
		BEGIN
			PRINT '  Select All ''Deal_Movie_Code'' for current deal'
			INSERT INTO #TempDealMovie(Deal_Movie_Code, Title_Code, Episode_From, Episode_To)
			SELECT Syn_Deal_Movie_Code, Title_Code, Episode_From, Episode_End_To 
			FROM Syn_Deal_Movie sdm WITH(NOLOCK) 
			INNER JOIN #TempApprovedRights tar ON tar.Syn_Deal_Code = sdm.Syn_Deal_Code
			--WHERE Syn_Deal_Code = @Deal_Code
		END
		ELSE
		BEGIN
			INSERT INTO #TempDealMovie(Deal_Movie_Code)
			Select  number AS Deal_Movie_Code From DBO.fn_Split_withdelemiter(@Deal_Movie_Codes, ',') WHERE number <> ''

			BEGIN
				UPDATE TDM SET TDM.Title_Code = SDM.Title_Code, TDM.Episode_From = SDM.Episode_From, TDM.Episode_To = SDM.Episode_End_To 
				FROM Syn_Deal_Movie SDM
				INNER JOIN #TempDealMovie TDM ON TDM.Deal_Movie_Code = SDM.Syn_Deal_Movie_Code
			END
		END

		IF(ISNULL(@PlatformCodes, '') <> '')
		BEGIN
			INSERT INTO #TempPlatformCodes(Platform_Code)
			Select number AS Platform_Code From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')  WHERE NUMBER <> ''

			UPDATE TP SET TP.Platform_Hiearachy = P.Platform_Hiearachy FROM #TempPlatformCodes TP
			INNER JOIN [Platform] P  ON P.Platform_Code = TP.Platform_Code
		END

		PRINT '  Select All ''Right_Code'' for current deal'
		IF(@Right_Type = 'SR')
		BEGIN
			INSERT INTO #TempRightCodes(Right_Code, Is_Exclusive, Last_Updated_Time)
			SELECT sdr.Syn_Deal_Rights_Code, Is_Exclusive, Last_Updated_Time 
			FROM Syn_Deal_Rights sdr WITH(NOLOCK) 
			INNER JOIN #TempApprovedRights tar ON tar.Syn_Deal_Rights_Code = sdr.Syn_Deal_Rights_Code
			WHERE --Syn_Deal_Code = @Deal_Code AND 
			ISNULL(Is_Pushback, 'N')  = 'N'
			--AND(Is_Exclusive IN((Select number From DBO.fn_Split_withdelemiter(@ISExclusive, ',')  WHERE NUMBER <> '')) OR @ISExclusive = 'B')
		END
		ELSE IF(@Right_Type = 'SP')
		BEGIN
			INSERT INTO #TempRightCodes(Right_Code, Is_Exclusive, Last_Updated_Time)
			SELECT Syn_Deal_Rights_Code, Is_Exclusive, Last_Updated_Time FROM Syn_Deal_Rights WITH(NOLOCK) WHERE Syn_Deal_Code = @Deal_Code AND ISNULL(Is_Pushback, 'N')  = 'Y'
		END
	
		PRINT '  View Type : ' + CASE WHEN @View_Type = 'G' THEN 'Group'  WHEN @View_Type = 'S' THEN 'Summary' ELSE 'Detail' END
		IF(@Right_Type IN ('SR', 'SP'))
		BEGIN
			PRINT '  Right Type : ' + CASE @Right_Type WHEN 'SR' THEN 'Syn Rights Tab' ELSE 'Syn Pushback Tab' END
			IF(@SearchText = '')
			BEGIN
				PRINT '  Nothing To Search'
				INSERT INTO #TempRightCodesGroup(Rights_Code, Syn_Deal_Rights_Title_Code)
				SELECT Right_Code, sdrt.Syn_Deal_Rights_Title_Code FROM (
					SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
					INNER JOIN Syn_Deal_Rights_Platform SDRP WITH(NOLOCK) ON SDRP.Syn_Deal_Rights_Code = SDR.Right_Code
					WHERE (SDRP.Platform_Code IN ((Select number From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')  WHERE NUMBER <> '')) OR @PlatformCodes = '')
					INTERSECT
					SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
					INNER JOIN Syn_Deal_Rights_Territory SDRTT WITH(NOLOCK) ON SDRTT.Syn_Deal_Rights_Code = SDR.Right_Code
					WHERE(
						(SDRTT.Territory_Type = 'G' AND SDRTT.Territory_Code IN(SELECT REPLACE(number,'T','') as Territory_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'T%')OR @RegionCodes = '') OR 
						(SDRTT.Territory_Type = 'I' AND SDRTT.Country_Code IN(SELECT REPLACE(number,'C','') as Country_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'C%') OR @RegionCodes = '')
					)
					--INTERSECT
					--SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
  					--INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = SDR.Right_Code
					--INNER JOIN #TempDealMovie TDM ON SDRT.Title_Code  = TDM.Title_Code AND SDRT.Episode_From = TDM.Episode_From 
					--AND SDRT.Episode_To = TDM.Episode_To
				) AS A
				INNER JOIN Syn_Deal_Rights_Title sdrt ON sdrt.Syn_Deal_Rights_Code = A.Right_Code
				ORDER BY A.Last_Updated_Time DESC

			
			
			END
			ELSE IF(@View_Type = 'G')
			BEGIN
				PRINT '  Search for Bulk Update'
				INSERT INTO #TempRightCodesGroup(Rights_Code, Syn_Deal_Rights_Title_Code)
				SELECT Right_Code, sdrt.Syn_Deal_Rights_Title_Code FROM (
					SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
					INNER JOIN Syn_Deal_Rights_Platform SDRP WITH(NOLOCK) ON SDRP.Syn_Deal_Rights_Code = SDR.Right_Code
					INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = SDRP.Platform_Code
					WHERE P.Platform_Hiearachy LIKE '%' + @SearchText + '%'
					UNION
					SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
					INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = SDR.Right_Code
					INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = SDRT.Title_Code
					WHERE T.Title_Name LIKE '%' + @SearchText + '%'
					UNION
					SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
					INNER JOIN Syn_Deal_Rights_Territory SDRC WITH(NOLOCK) ON SDRC.Syn_Deal_Rights_Code = SDR.Right_Code
					LEFT JOIN Country C WITH(NOLOCK) ON C.Country_Code = SDRC.Country_Code AND SDRC.Territory_Type <> 'G' AND SDRC.Territory_Code IS NULL
					LEFT JOIN Territory TC WITH(NOLOCK) ON TC.Territory_Code = SDRC.Territory_Code AND SDRC.Territory_Type = 'G' AND SDRC.Country_Code IS NULL
					WHERE C.Country_Name LIKE '%' + @SearchText + '%' OR TC.Territory_Name LIKE '%' + @SearchText + '%'
					UNION
					SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
					INNER JOIN Syn_Deal_Rights_Subtitling SDRS WITH(NOLOCK) ON SDRS.Syn_Deal_Rights_Code = SDR.Right_Code
					LEFT JOIN [Language] LS WITH(NOLOCK) ON LS.Language_Code = SDRS.Language_Code AND SDRS.Language_Type <> 'G' AND SDRS.Language_Group_Code IS NULL
					LEFT JOIN [Language_Group] LSG WITH(NOLOCK) ON LSG.Language_Group_Code = SDRS.Language_Group_Code AND SDRS.Language_Type = 'G' AND SDRS.Language_Code IS NULL
					WHERE LS.Language_Name LIKE '%' + @SearchText + '%' OR LSG.Language_Group_Name LIKE '%' + @SearchText + '%'
					UNION
					SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
					INNER JOIN Syn_Deal_Rights_Dubbing SDRD WITH(NOLOCK) ON SDRD.Syn_Deal_Rights_Code = SDR.Right_Code
					LEFT JOIN [Language] LD WITH(NOLOCK) ON LD.Language_Code = SDRD.Language_Code AND SDRD.Language_Type <> 'G' AND SDRD.Language_Group_Code IS NULL
					LEFT JOIN [Language_Group] LDG WITH(NOLOCK) ON LDG.Language_Group_Code = SDRD.Language_Group_Code AND SDRD.Language_Type = 'G' AND SDRD.Language_Code IS NULL
					WHERE  LD.Language_Name LIKE '%' + @SearchText + '%' OR LDG.Language_Group_Name LIKE '%' + @SearchText + '%'
				)AS A
				INNER JOIN Syn_Deal_Rights_Title sdrt (NOLOCK) ON sdrt.Syn_Deal_Rights_Code = A.Right_Code
				ORDER BY A.Last_Updated_Time DESC

			END
		END

		IF(@View_Type = 'G')
		BEGIN
			INSERT INTO #TempRightsPagingData(Deal_Code, Rights_Code, Syn_Deal_Rights_Title_Code)
			SELECT Distinct tar.Syn_Deal_Code, Rights_Code, sdrt.Syn_Deal_Rights_Title_Code FROM 
			#TempRightCodesGroup trcg
			INNER JOIN #TempApprovedRights tar ON tar.Syn_Deal_Rights_Code = trcg.Rights_Code
			INNER JOIN Syn_DEal_Rights_Title sdrt ON sdrt.Syn_Deal_Rights_Code = tar.Syn_Deal_Rights_Code
			--ORDER BY Row_No
		END
		ELSE
		BEGIN
	
			IF(@Right_Type = 'SR' OR @Right_Type = 'SP')
			BEGIN
				INSERT INTO #TempRightCodesSummary(Rights_Code, Title_Code, Episode_From, Episode_To)
				SELECT SDRT.Syn_Deal_Rights_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To FROM #TempRightCodesGroup SDR
				INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Rights_Code = SDRT.Syn_Deal_Rights_Code
				INNER JOIN #TempDealMovie TDM ON SDRT.Title_Code  = TDM.Title_Code AND SDRT.Episode_From = TDM.Episode_From AND SDRT.Episode_To = TDM.Episode_To
				INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = SDRT.Title_Code
				ORDER BY T.Title_Name
			END	

			IF(@View_Type = 'S')
			BEGIN
				INSERT INTO #TempRightsPagingData(Deal_Code, Rights_Code, Title_Code, Episode_From, Episode_To)
				SELECT @Deal_Code, Rights_Code, Title_Code, Episode_From, Episode_To FROM #TempRightCodesSummary
				ORDER BY Row_No
			END
			ELSE
			BEGIN
			
				DELETE FROM #TempRightCodes
				INSERT INTO #TempRightCodes(Right_Code)
				SELECT DISTINCT Rights_Code FROM #TempRightCodesSummary

	
				IF(@Right_Type = 'SR' OR @Right_Type = 'SP')
				BEGIN
					INSERT INTO #TempRightCodesDetails(Rights_Code, Platform_Code)
					SELECT SDR.Right_Code, SDRP.Platform_Code
					FROM #TempRightCodes SDR
					INNER JOIN Syn_Deal_Rights_Platform SDRP WITH(NOLOCK) ON SDRP.Syn_Deal_Rights_Code = SDR.Right_Code
				END

				IF NOT EXISTS(SELECT TOP 1 Platform_Code FROM #TempPlatformCodes)
				BEGIN
					INSERT INTO #TempPlatformCodes(Platform_Code, Platform_Hiearachy)
					SELECT A.Platform_Code, P.Platform_Hiearachy FROM (
					SELECT DISTINCT Platform_Code FROM #TempRightCodesDetails
					) AS A INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = A.Platform_Code
				END

				INSERT INTO #TempRightsPagingData(Deal_Code, Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code)
				SELECT @Deal_Code, RS.Rights_Code, RS.Title_Code, RS.Episode_From, RS.Episode_To, RD.Platform_Code FROM #TempRightCodesSummary RS
				INNER JOIN #TempRightCodesDetails RD ON RS.Rights_Code = RD.Rights_Code
				INNER JOIN #TempPlatformCodes TP ON TP.Platform_Code = RD.Platform_Code
				ORDER BY RS.Row_No, TP.Platform_Hiearachy
			END
		END
	
		PRINT '  START : Logic For Paging at ' + CAST(GETDATE() AS VARCHAR)
		SELECT @TotalRecord  = MAX(Row_No) FROM #TempRightsPagingData
		SET @TotalRecord = ISNULL(@TotalRecord, 0)
		SELECT @PageNo = DBO.UFN_Get_New_PageNo(@TotalRecord, @PageNo, @PageSize)

		DELETE FROM #TempRightsPagingData WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
		PRINT '  END : Logic For Paging' + CAST(GETDATE() AS VARCHAR)

		INSERT INTO #TempRights(Deal_Code, Rights_Code, Syn_Deal_Rights_Title_Code)
		SELECT DISTINCT Deal_Code, Rights_Code, Syn_Deal_Rights_Title_Code FROM #TempRightsPagingData

		IF(@View_Type <> 'G')
		BEGIN
			INSERT INTO #TempTitle(Title_Code, Episode_From, Episode_To)
			SELECT DISTINCT Title_Code, Episode_From, Episode_To FROM #TempRightsPagingData
		END
		ELSE
		BEGIN
		
			BEGIN
				INSERT INTO #TempTitle(Title_Code, Episode_From, Episode_To)
				SELECT DISTINCT SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To FROM #TempRights TR
				INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = TR.Rights_Code
			END
		END

	
		BEGIN
			UPDATE TT SET TT.Is_Closed = CASE WHEN  ISNULL(SDM.Is_Closed,'N') IN ('Y', 'X') THEN 'Y' ELSE 'N' END 
			FROM #TempTitle TT
			INNER JOIN Syn_Deal_Movie SDM WITH(NOLOCK) ON SDM.Title_Code = TT.Title_Code 
				AND SDM.Episode_From = TT.Episode_From AND SDM.Episode_End_To = TT.Episode_To
		END

		DECLARE @Is_Syn_CoExclusive CHAR(1) = ''
		SELECT @Is_Syn_CoExclusive = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_Syn_CoExclusive' 

		IF(@Right_Type IN ('SR', 'SP'))
		BEGIN
			UPDATE TR SET TR.Is_Holdback = 'No', 
			TR.Is_Exclusive = CASE ISNULL(SDR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'C' END, 
			TR.Is_Sublicencing = CASE ISNULL(SDR.Is_Sub_License, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END,
			TR.Rights_Start_Date = SDR.Actual_Right_Start_Date, 
			TR.Rights_End_Date = SDR.Actual_Right_End_Date, 
			TR.Is_Theatrical = CASE ISNULL(SDR.Is_Theatrical_Right, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
			TR.Remarks = SDR.Restriction_Remarks, 
			TR.Right_Type = SDR.Right_Type,
			TR.Is_Tentative = CASE ISNULL(SDR.Is_Tentative, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
			TR.IsTentative = ISNULL(SDR.Is_Tentative, 'N'),
			TR.Term = SDR.Term,
			TR.Milestone_Type_Code = SDR.Milestone_Type_Code, 
			TR.Milestone_No_Of_Unit = SDR.Milestone_No_Of_Unit, 
			TR.Milestone_Unit_Type = SDR.Milestone_Unit_Type, 
			TR.Title_Language_Right = CASE ISNULL(SDR.Is_Title_Language_Right, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
			TR.Right_Status = SDR.Right_Status,
			TR.Is_ROFR = SDR.Is_ROFR, 
			TR.ROFR_Date = SDR.ROFR_Date,
			TR.Last_Updated_Time = SDR.Last_Updated_Time
			FROM Syn_Deal_Rights SDR WITH(NOLOCK)
			INNER JOIN #TempRights TR ON SDR.Syn_Deal_Rights_Code = tr.Rights_Code
			WHERE Syn_Deal_Code = @Deal_Code

			IF (@Is_Syn_CoExclusive = 'Y' AND @Right_Type = 'SR')
			BEGIN
				UPDATE TR SET
					TR.Is_Exclusive = CASE ISNULL(SDR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Exclusive' WHEN 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END
				FROM Syn_Deal_Rights SDR WITH(NOLOCK)
				INNER JOIN #TempRights TR ON SDR.Syn_Deal_Rights_Code = tr.Rights_Code
				WHERE Syn_Deal_Code = @Deal_Code
			END

		END

		DECLARE @Type CHAR(1) = ''

		IF(@Right_Type = 'AR')
			SET @Type = 'A'
		ELSE IF(@Right_Type = 'AP')
			SET @Type = 'P'
		ELSE
			SET @Type = 'S'

		UPDATE TR SET 
		TR.Term = CASE WHEN TR.IsTentative = 'N' THEN dbo.UFN_Calculate_Term(TR.Rights_Start_Date, TR.Rights_End_Date) ELSE TR.Term END,
		TR.Country = DBO.UFN_Get_Rights_Country(TR.Rights_Code, @Type,''), 
		TR.Territory = DBO.UFN_Get_Rights_Territory(TR.Rights_Code, @Type),
		TR.Sub_Titling_Language = DBO.UFN_Get_Rights_Subtitling(TR.Rights_Code, @Type),
		TR.Dubbing_Titling_Language = DBO.UFN_Get_Rights_Dubbing(TR.Rights_Code, @Type),
		TR.Is_Syn_Acq_Mapp = CASE WHEN @Right_Type = 'AR' THEN DBO.UFN_Syn_Acq_Mapping(@View_Type, TR.Rights_Code, TR.Title_Code, TR.Platform_Code) ELSE 'N' END,
		TR.Is_Holdback = dbo.UFN_Get_Rights_Holdback_YN(0, TR.Rights_Code, @Type)
		FROM #TempRights TR

		IF(@View_Type <> 'G')
		BEGIN
			UPDATE TR SET 
			TR.Is_Syn_Acq_Mapp = CASE WHEN @Right_Type = 'AR' THEN DBO.UFN_Syn_Acq_Mapping(@View_Type, TRPD.Rights_Code, TRPD.Title_Code, TRPD.Platform_Code) ELSE 'N' END,
			TR.Is_Holdback = dbo.UFN_Get_Rights_Holdback_YN(TRPD.Platform_Code, TRPD.Rights_Code, @Type)
			FROM #TempRights TR
			INNER JOIN #TempRightsPagingData TRPD ON TRPD.Rights_Code = TR.Rights_Code 
		END

		IF(@View_Type <> 'D')
		BEGIN
			IF(@Right_Type = 'SR')
			BEGIN
				UPDATE TR SET TR.Is_Holdback = (
					CASE WHEN (SELECT COUNT(*) FROM Syn_Deal_Rights_Holdback SDRH WITH(NOLOCK) WHERE SDRH.Syn_Deal_Rights_Code = TR.Rights_Code) = 0 THEN 'N' ELSE 'Y' END
				)FROM #TempRights TR
			END
		END
		UPDATE #TempRights SET Is_Holdback = CASE Is_Holdback WHEN 'Y' Then 'Yes' WHEN 'N' THEN 'No' ELSE '' END

		DECLARE 
		@PerpetuityTerm INT

		IF EXISTS(SELECT TOP 1 Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Perpertuity_Term_In_Year')
		BEGIN
			SET @PerpetuityTerm = (SELECT TOP 1 Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Perpertuity_Term_In_Year')

			UPDATE TR SET 
			TR.Right_Term = Case TR.Right_Type
			When 'Y' Then [dbo].[UFN_Get_Rights_Term](TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term) 
			When 'M' Then [dbo].[UFN_Get_Rights_Milestone](TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type)
			When 'U' Then CAST(@PerpetuityTerm AS NVARCHAR) + ' Years'
			End
			FROM #TempRights TR
		END
		ELSE
		BEGIN

			UPDATE TR SET 
			TR.Right_Term = Case TR.Right_Type
			When 'Y' Then [dbo].[UFN_Get_Rights_Term](TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term) 
			When 'M' Then [dbo].[UFN_Get_Rights_Milestone](TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type)
			When 'U' Then 'Perpetuity'
			End
			FROM #TempRights TR

		END

	

		UPDATE TT SET TT.Title_Name = DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, TT.Episode_From, TT.Episode_To)
		FROM #TempTitle TT
		INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = TT.Title_Code

		IF(@View_Type <> 'D')
		BEGIN
			IF(@Right_Type IN ('SR', 'SP'))
			BEGIN
				UPDATE TR SET 
				TR.Platform_Code = (
					Select TOP 1 SDRP.Platform_Code
					FROM Syn_Deal_Rights_Platform SDRP WITH(NOLOCK)
					WHERE SDRP.Syn_Deal_Rights_Code = TR.Rights_Code
				)
				FROM #TempRights TR

				IF(@View_Type = 'G')
				BEGIN
					UPDATE TR SET 
					TR.Title_Name = (--STUFF ((
						--Select ', ' + 
						Select top 1 T.Title_Name 
						FROM Syn_Deal_Rights_Title SDRT WITH(NOLOCK)
						INNER JOIN #TempTitle T ON T.Title_Code = SDRT.Title_Code AND T.Episode_From = SDRT.Episode_From AND T.Episode_To = SDRT.Episode_To
						WHERE SDRT.Syn_Deal_Rights_Code = TR.Rights_Code AND SDRT.Syn_Deal_Rights_Title_Code = tr.Syn_Deal_Rights_Title_Code
						--FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
					),
					TR.Is_Ref_Close_Title = (
						SELECT TOP 1 T.Is_Closed FROM Syn_Deal_Rights_Title SDRT WITH(NOLOCK)
						INNER JOIN #TempTitle T ON T.Title_Code = SDRT.Title_Code AND T.Episode_From = SDRT.Episode_From AND T.Episode_To = SDRT.Episode_To
						WHERE SDRT.Syn_Deal_Rights_Code = TR.Rights_Code
						ORDER BY T.Is_Closed DESC
					)
					FROM #TempRights TR
				END
			END

			UPDATE TR SET TR.Platform_Name = SUBSTRING(ISNULL(P.Platform_Hiearachy, ''), 1, 
				CASE WHEN CHARINDEX(' --', ISNULL(P.Platform_Hiearachy, ''), 1) > 0 THEN
					CHARINDEX(' --', ISNULL(P.Platform_Hiearachy, ''), 1) - 1 ELSE
					LEN(ISNULL(P.Platform_Hiearachy, '')) END
				),
			TR.Platform_Code = 0 FROM #TempRights TR 
			INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = TR.Platform_Code

			IF(@View_Type = 'G')
			BEGIN
				IF(@Deal_Type_Condition = 'DEAL_MOVIE')
					UPDATE #TempRights SET Episode_From = 1, Episode_To = 1

				INSERT INTO #TempResultData (
					Deal_Code, Rights_Code, Title_Code, Platform_Code, Title_Name, Episode_From, Episode_To, Platform_Name, 
					Is_Holdback, Is_Exclusive, Is_Sublicencing, Rights_Start_Date, Rights_End_Date, Term, Is_Theatrical, Country, 
					Territory, Remarks, Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
					Title_Language_Right, Sub_Titling_Language, Dubbing_Titling_Language, Right_Term, Right_Status ,Is_Syn_Acq_Mapp, 
					Is_ROFR, ROFR_Date, IsDelete, Is_Ref_Close_Title, Last_Updated_Time
				)
				SELECT 
					TR.Deal_Code, TR.Rights_Code, TR.Title_Code, TR.Platform_Code, TR.Title_Name, TR.Episode_From, TR.Episode_To, TR.Platform_Name, 
					TR.Is_Holdback, TR.Is_Exclusive, TR.Is_Sublicencing, TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term, TR.Is_Theatrical, TR.Country, 
					TR.Territory, TR.Remarks, TR.Right_Type, TR.Is_Tentative, TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type, 
					TR.Title_Language_Right, TR.Sub_Titling_Language, TR.Dubbing_Titling_Language, TR.Right_Term, TR.Right_Status, TR.Is_Syn_Acq_Mapp,
					TR.Is_ROFR ,ROFR_Date, TR.IsDelete, TR.Is_Ref_Close_Title, TR.Last_Updated_Time
				From #TempRights TR
			END
			ELSE
			BEGIN
				INSERT INTO #TempResultData (
					Deal_Code, Rights_Code, Title_Code, Platform_Code, Title_Name, Episode_From, Episode_To, Platform_Name, 
					Is_Holdback, Is_Exclusive, Is_Sublicencing, Rights_Start_Date, Rights_End_Date, Term, Is_Theatrical, Country, 
					Territory, Remarks, Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
					Title_Language_Right, Sub_Titling_Language, Dubbing_Titling_Language, Right_Term, Right_Status ,Is_Syn_Acq_Mapp, 
					Is_ROFR, ROFR_Date, IsDelete, Is_Ref_Close_Title, Last_Updated_Time
				)
				SELECT 
					TR.Deal_Code, TR.Rights_Code, TT.Title_Code, TR.Platform_Code, TT.Title_Name, TT.Episode_From, TT.Episode_To, TR.Platform_Name, 
					TR.Is_Holdback, TR.Is_Exclusive, TR.Is_Sublicencing, TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term, TR.Is_Theatrical, TR.Country, 
					TR.Territory, TR.Remarks, TR.Right_Type, TR.Is_Tentative, TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type, 
					TR.Title_Language_Right, TR.Sub_Titling_Language, TR.Dubbing_Titling_Language, TR.Right_Term, TR.Right_Status, 
					CASE WHEN @Right_Type = 'AR' THEN DBO.UFN_Syn_Acq_Mapping(@View_Type, TRPD.Rights_Code, TRPD.Title_Code, TRPD.Platform_Code) ELSE TR.Is_Syn_Acq_Mapp END,
					--TR.Is_Syn_Acq_Mapp,
					TR.Is_ROFR ,ROFR_Date, TR.IsDelete, TT.Is_Closed, TR.Last_Updated_Time
				FROM #TempRightsPagingData TRPD
				INNER JOIN #TempRights TR ON TR.Rights_Code = TRPD.Rights_Code
				INNER JOIN #TempTitle TT ON TT.Title_Code = TRPD.Title_Code AND TT.Episode_From = TRPD.Episode_From AND TT.Episode_To = TRPD.Episode_To
			END
		END
		ELSE 
		BEGIN
			INSERT INTO #TempResultData (
				Deal_Code, Rights_Code, Title_Code, Platform_Code, Title_Name, Episode_From, Episode_To, Platform_Name, 
				Is_Holdback, Is_Exclusive, Is_Sublicencing, Rights_Start_Date, Rights_End_Date, Term, Is_Theatrical, Country, 
				Territory, Remarks, Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
				Title_Language_Right, Sub_Titling_Language, Dubbing_Titling_Language, Right_Term, Right_Status ,Is_Syn_Acq_Mapp, 
				Is_ROFR, ROFR_Date, IsDelete, Is_Ref_Close_Title, Last_Updated_Time
			)
			SELECT 
				TR.Deal_Code, TR.Rights_Code, TT.Title_Code, TRPD.Platform_Code, TT.Title_Name, TT.Episode_From, TT.Episode_To, P.Platform_Hiearachy, 
				TR.Is_Holdback, TR.Is_Exclusive, TR.Is_Sublicencing, TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term, TR.Is_Theatrical, TR.Country, 
				TR.Territory, TR.Remarks, TR.Right_Type, TR.Is_Tentative, TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type, 
				TR.Title_Language_Right, TR.Sub_Titling_Language, TR.Dubbing_Titling_Language, TR.Right_Term, TR.Right_Status, TR.Is_Syn_Acq_Mapp,
				TR.Is_ROFR ,ROFR_Date, TR.IsDelete, TT.Is_Closed, TR.Last_Updated_Time
			FROM #TempRightsPagingData TRPD
			INNER JOIN #TempRights TR ON TR.Rights_Code = TRPD.Rights_Code
			INNER JOIN #TempTitle TT ON TT.Title_Code = TRPD.Title_Code AND TT.Episode_From = TRPD.Episode_From AND TT.Episode_To = TRPD.Episode_To
			INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = TRPD.Platform_Code

		
		END

		if(@View_Type = 'D')
		BEGIN
			IF(@Right_Type = 'SR')
			BEGIN
				UPDATE TRD SET TRD.Is_Holdback = (
					CASE WHEN (
							SELECT COUNT(*) FROM Syn_Deal_Rights_Holdback SDRH WITH(NOLOCK)
							INNER JOIN Syn_Deal_Rights_Holdback_Platform SDRHP WITH(NOLOCK) ON SDRHP.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
								AND SDRHP.Platform_Code = TRD.Platform_Code
							WHERE SDRH.Syn_Deal_Rights_Code = TRD.Rights_Code
						) = 0 THEN 'N' ELSE 'Y' END
				)FROM #TempResultData TRD
			END
			UPDATE #TempResultData SET Is_Holdback = CASE Is_Holdback WHEN 'Y' Then 'Yes' WHEN 'N' THEN 'No' ELSE '' END
		END

		UPDATE t SET t.Agreement_No = sd.Agreement_No, t.Title_Language= l.Language_Name, t.Rights_Start_Date = sdr.Actual_Right_Start_Date,
					t.Rights_End_Date = sdr.Actual_Right_End_Date,t.Is_Exclusive =  CASE ISNULL(SDR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE 'C' END,
					t.Term = dbo.UFN_Calculate_Term(sdr.Actual_Right_Start_Date, sdr.Actual_Right_End_Date),
					t.Title_Code = ttl.Title_Code
		FROM #TempResultData t
		INNER JOIN Syn_Deal sd ON sd.Syn_Deal_Code = t.Deal_Code
		INNER JOIN Syn_Deal_Rights sdr ON sdr.Syn_Deal_Rights_Code = t.Rights_Code
		INNER JOIN Title ttl ON ttl.Title_Name COLLATE DATABASE_DEFAULT = t.Title_Name COLLATE DATABASE_DEFAULT
		INNER JOIN Language l ON l.Language_Code = ttl.Title_Language_Code
	
	

		PRINT '  Dynamic Query Execution started at ' + CAST(GETDATE() AS VARCHAR)
		DECLARE @Query VARCHAR(MAX)
		SET @Query = 'Select Agreement_No, Title_Language, Deal_Code, Rights_Code, Title_Code, 
		ISNULL(Platform_Code, 0) AS Platform_Code, Title_Name, Episode_From, Episode_To, 
		ISNULL(Platform_Name, '''') AS Platform_Name, 
		Is_Holdback, Is_Exclusive, 
		Is_Sublicencing, CAST(Rights_Start_Date AS NVARCHAR(MAX)) AS Rights_Start_Date, CAST(Rights_End_Date AS NVARCHAR(MAX)) AS Rights_End_Date, Term, Is_Theatrical, Country, Territory, 
		(CASE WHEN ISNULL(Remarks, '''') = '''' THEN ''No'' ELSE Remarks END) Remarks, 
		Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Title_Language_Right, 
		(CASE WHEN ISNULL(Sub_Titling_Language, '''') = '''' THEN ''No''  ELSE Sub_Titling_Language END) Sub_Titling_Language, 
		(CASE WHEN ISNULL(Dubbing_Titling_Language, '''') = '''' THEN ''No''  ELSE Dubbing_Titling_Language END) Dubbing_Titling_Language,
		Right_Term, Right_Status ,Is_Syn_Acq_Mapp ,Is_ROFR ,ROFR_Date ,IsDelete ,Is_Ref_Close_Title
		From #TempResultData t
		WHERE t.Title_Code IN ('+@TitleCodes+') AND Is_Exclusive NOT IN (''C'')
		ORDER BY '
	
		IF(@View_Type = 'G')
			SET @Query = @Query + 'Last_Updated_Time'
		ELSE
			SET @Query = @Query + 'Title_Name, Platform_Name'


		PRINT @Query
	
		EXEC(@Query)

		PRINT '  Process Ended at' + CAST(GETDATE() AS VARCHAR)

		--IF OBJECT_ID('tempdb..#TempDealMovie') IS NOT NULL DROP TABLE #TempDealMovie
		--IF OBJECT_ID('tempdb..#TempPlatformCodes') IS NOT NULL DROP TABLE #TempPlatformCodes
		--IF OBJECT_ID('tempdb..#TempResultData') IS NOT NULL DROP TABLE #TempResultData
		--IF OBJECT_ID('tempdb..#TempRightCodes') IS NOT NULL DROP TABLE #TempRightCodes
		--IF OBJECT_ID('tempdb..#TempRightCodesDetails') IS NOT NULL DROP TABLE #TempRightCodesDetails
		--IF OBJECT_ID('tempdb..#TempRightCodesGroup') IS NOT NULL DROP TABLE #TempRightCodesGroup
		--IF OBJECT_ID('tempdb..#TempRightCodesSummary') IS NOT NULL DROP TABLE #TempRightCodesSummary
		--IF OBJECT_ID('tempdb..#TempRights') IS NOT NULL DROP TABLE #TempRights
		--IF OBJECT_ID('tempdb..#TempRightsPagingData') IS NOT NULL DROP TABLE #TempRightsPagingData
		--IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BuyBackRights_List]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END