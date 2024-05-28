
CREATE PROCEDURE [dbo].[USPITGetAvailTitleAncillary]
(
	@UDT TitleCriteria READONLY,
	@IsDDL VARCHAR(2)
)
AS
BEGIN
/*----------------------------------------
Author: Rahul Kembhavi
Created On : 05/Feb/2020
Description: Used to get Avail titles & for title grid
-----------------------------------------*/

	--DECLARE @IsDDL CHAR(1) = 'N', @UDT TitleCriteria
	--INSERT INTO @UDT VALUES('PlatformCodes','15,9,7,13,17,8,16,14,10,14,16')
	------INSERT INTO @UDT VALUES('PeriodType','FL')
	--INSERT INTO @UDT VALUES('Start Date','6-Feb-2020')
	--INSERT INTO @UDT VALUES('End Date','24-Feb-2020')
	--INSERT INTO @UDT VALUES('Exclusivity','Both')
	--INSERT INTO @UDT VALUES('TitleCode','')
	--INSERT INTO @UDT VALUES('BVCode','19')

	BEGIN /*---------Temp Tables-------------------*/
	
		IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
		IF OBJECT_ID('tempdb..#Platform_Avail') IS NOT NULL DROP TABLE #Platform_Avail
		IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
		IF OBJECT_ID('tempdb..#Avail_Dates') IS NOT NULL DROP TABLE #Avail_Dates
		IF OBJECT_ID('tempdb..#TitleCodes') IS NOT NULL DROP TABLE #TitleCodes
		
		CREATE TABLE #TitleCodes
		(
			Title_Code INT
		)
		
		CREATE TABLE #tempCriteria(
			ValueField NVARCHAR(MAX),
			TextField NVARCHAR(MAX)
		)
	
		CREATE TABLE #Platform_Search(
			Platform_Code INT
		)

		CREATE TABLE #Avail_Dates(
			Avail_Dates_Code INT,
			Start_Date DATE,
			END_Date DATE
		)

		CREATE TABLE #Platform_Avail(
			Avail_Platform_Code NUMERIC(38,0),
			Platform_Codes VARCHAR(MAX),
			Platform_Names NVARCHAR(MAX)
		)

	END

	/*----------------------------------------*/
	INSERT INTO #tempCriteria
	SELECT * FROM @UDT

	-----------------Variables Declartion-------------

	DECLARE @Country_Codes NVARCHAR(MAX), @Territory_Codes NVARCHAR(MAX),@Media_Platform NVARCHAR(MAX), @Mode_Of_Exploitation NVARCHAR(MAX),
	@StartDate DATE,@ENDDate DATE,@Dubbing_Codes NVARCHAR(MAX), @Dubbing_Group_Codes NVARCHAR(MAX), @Language_Code NVARCHAR(MAX),
	@Subtitle_Codes NVARCHAR(MAX),@Subtitle_Group_Codes NVARCHAR(MAX),@LanguageCodes NVARCHAR(MAX),@VendorCodes NVARCHAR(MAX),@TalentCodes NVARCHAR(MAX),
	@Exclusivity VARCHAR(1), @BVCode INT,
	@TitleCodes NVARCHAR(MAX),@Deal_Type_Code NVARCHAR(MAX),@PlatformCodes NVARCHAR(MAX)

	SET @StartDate  = (SELECT top 1 CAST(TextField AS DATE) FROM #tempCriteria WHERE ValueField = 'Start Date')
	SET @ENDDate = (SELECT top 1  CAST(TextField AS DATE) FROM #tempCriteria WHERE ValueField = 'End Date')
	SET @TitleCodes = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'TitleCode')
	SET @BVCode = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'BVCode')
	SET @PlatformCodes = (SELECT TOP 1 TextField FROM #tempCriteria WHERE ValueField  = 'PlatformCodes')
	
	IF(@BVCode = 19)
	BEGIN
		SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Movie_IT' )
	END
	ELSE IF(@BVCode = 20)
	BEGIN
		SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Prog_IT' )
	END
	ELSE
	BEGIN
		SET @Deal_Type_Code = (Select Parameter_Value from System_Parameter_New where Parameter_Name = 'DashboardType_Web_IT' )
	END

	SELECT @Exclusivity =  CASE WHEN TextField = 'Y' THEN 1 ELSE 0 END 
	FROM #tempCriteria WHERE ValueField  = 'Exclusivity'
	
	IF(@Exclusivity = 'Y')
		SET @Exclusivity = 'E'
	ELSE IF(@Exclusivity = 'N')
		SET @Exclusivity = 'N'
	ELSE
		SET @Exclusivity = 'B'

	DECLARE @EX_YES BIT = 2, @EX_NO BIT = 2
	SET @Exclusivity = 'BOTH'
	IF(UPPER(@Exclusivity) = 'E')
		SET @EX_YES = 1
	ELSE IF(UPPER(@Exclusivity) = 'N')
		SET @EX_NO = 0
	ELSE IF(UPPER(@Exclusivity) = 'B')
	BEGIN
		SET @EX_YES = 1
		SET @EX_NO = 0
	END

	BEGIN ---------- PLATFORM PROCESSING
		IF(@PlatformCodes = '')
			BEGIN
				INSERT INTO #Platform_Avail(Avail_Platform_Code)
				SELECT Avail_Platform_Code FROM Avail_Platforms 
			END
		ELSE
			BEGIN
				INSERT INTO #Platform_Search(Platform_Code)
				SELECT Number COLLATE Latin1_General_CI_AI FROM DBO.fn_Split_withdelemiter(ISNULL(@PlatformCodes,''), ',') WHERE ISNULL(Number, '') NOT IN('', '0')

				DECLARE @Platform_Code VARCHAR(10) = ''
				DECLARE Cur_Platform_Neo CURSOR FOR SELECT Platform_Code FROM #Platform_Search ORDER BY CAST(Platform_Code AS VARCHAR(10)) ASC
				OPEN Cur_Platform_Neo
				FETCH NEXT FROM Cur_Platform_Neo INTO @Platform_Code
				WHILE (@@FETCH_STATUS = 0)
				BEGIN

					MERGE INTO #Platform_Avail AS tmp
					USING Avail_Platforms al WITH(NOLOCK) On tmp.Avail_Platform_Code = al.Avail_Platform_Code AND al.Platform_Codes Like '%,' + @Platform_Code + ',%' 
					WHEN MATCHED THEN
						UPDATE SET tmp.Platform_Codes = tmp.Platform_Codes + ',' + @Platform_Code
					WHEN NOT MATCHED AND al.Platform_Codes Like '%,' + @Platform_Code + ',%' THEN
						INSERT VALUES (al.Avail_Platform_Code, @Platform_Code, '')
					;

					FETCH NEXT FROM Cur_Platform_Neo INTO @Platform_Code	
				END
				CLOSE Cur_Platform_Neo
				DEALLOCATE Cur_Platform_Neo
			END

		

	END

	BEGIN ---------- DATE PROCESSING
		DECLARE @Date_Type VARCHAR(2) = 'FL'
		
		IF(@StartDate < '01JAN2010' AND  @ENDDate < '01JAN2010')
		BEGIN

			INSERT INTO #Avail_Dates(Avail_Dates_Code, Start_Date, END_Date)
			SELECT Avail_Dates_Code, Start_Date, END_Date FROM Avail_Dates WITH(NOLOCK)

		END
		ELSE
		BEGIN

			IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
			BEGIN
			
				INSERT INTO #Avail_Dates(Avail_Dates_Code, Start_Date, END_Date)
				SELECT Avail_Dates_Code, Start_Date, END_Date FROM Avail_Dates WITH(NOLOCK)
				WHERE (ISNULL(Start_Date, '9999-12-31') <= @StartDate AND ISNULL(END_Date, '9999-12-31') >= @ENDDate)
		
			END
			ELSE
			BEGIN
			
				INSERT INTO #Avail_Dates(Avail_Dates_Code, Start_Date, END_Date)
				SELECT Avail_Dates_Code, Start_Date, END_Date FROM Avail_Dates WITH(NOLOCK)
				WHERE (
					(ISNULL(Start_Date, '9999-12-31') BETWEEN @StartDate AND  @ENDDate)
					OR (ISNULL(END_Date, '9999-12-31') BETWEEN @StartDate AND @ENDDate)
					OR (@StartDate BETWEEN  ISNULL(Start_Date, '9999-12-31') AND ISNULL(END_Date, '9999-12-31'))
					OR (@ENDDate BETWEEN ISNULL(Start_Date, '9999-12-31') AND ISNULL(END_Date, '9999-12-31'))
				)

			END

		END

	END
	
	IF(@IsDDL = 'Y')
	BEGIN

		SELECT DISTINCT atd.Title_Code, t.Title_Name, '' AS Title_Language, '' AS Genre, '' AS StarCast, '' AS ReleaseYear
		FROM Avail_Title_Data atd WITH(NOLOCK)
		INNER JOIN Acq_Deal ad WITH(NOLOCK) ON ad.Acq_Deal_Code = atd.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
		INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = atd.Title_Code
		WHERE 
		atd.Avail_Platform_Code IN (
			SELECT Avail_Platform_Code FROM #Platform_Avail
		) AND 
		atd.Avail_Dates_Code IN (
			SELECT Avail_Dates_Code FROM #Avail_Dates
		) AND 
		atd.IS_Exclusive IN(@EX_YES, @EX_NO)

	END
	ELSE
	BEGIN
	
		BEGIN /*-------Star cast--------------*/

			INSERT INTO #TitleCodes(Title_Code)
			SELECT Number FROM dbo.fn_Split_withdelemiter(ISNULL(@TitleCodes,''), ',') WHERE ISNULL(Number, '') NOT IN ('', '0')
		
			DECLARE @IsTitleFilter CHAR(1) = 'Y'
			IF NOT EXISTS(SELECT TOP 1 * FROM #TitleCodes)
			BEGIN
			
				SET @IsTitleFilter = 'N'

			END

		END

		SELECT Title_Code, Title_Name, Language_Name AS Title_Language, 
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Genres_Name AS NVARCHAR(MAX)) FROM Title_Geners TG WITH(NOLOCK)
			INNER JOIN Genres Tal WITH(NOLOCK) ON tal.Genres_Code = TG.Genres_Code
			WHERE TG.Title_Code = TitleOutput.Title_Code
			FOR XML PATH(''), ROOT('Genres'), TYPE
		).value('/Genres[1]','NVARCHAR(max)'), 1, 2, '')),'')  AS Genre, 
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Talent_Name AS NVARCHAR(MAX)) FROM Title_Talent TT WITH(NOLOCK)
			INNER JOIN Talent Tal WITH(NOLOCK) on tal.talent_Code = TT.Talent_code
			WHERE TT.Title_Code = TitleOutput.Title_Code AND TT.Role_Code in (2)
			FOR XML PATH(''), ROOT('StarCast'), TYPE
		).value('/StarCast[1]','NVARCHAR(max)'), 1, 2, '')),'') AS StarCast, 
		Year_Of_Production AS ReleaseYear
		FROM (
			SELECT DISTINCT atd.Title_Code, t.Title_Name, t.Year_Of_Production, lg.Language_Name
			FROM Avail_Title_Data atd WITH(NOLOCK)
			INNER JOIN Acq_Deal ad WITH(NOLOCK) ON ad.Acq_Deal_Code = atd.Acq_Deal_Code AND AD.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(''+@Deal_Type_Code+'',','))
			INNER JOIN Title t WITH(NOLOCK) ON t.Title_Code = atd.Title_Code
			INNER JOIN Language lg WITH(NOLOCK) ON t.Title_Language_Code = lg.Language_Code
			WHERE atd.Avail_Platform_Code IN (
				SELECT Avail_Platform_Code FROM #Platform_Avail
			)
			AND atd.Avail_Dates_Code IN (
				SELECT Avail_Dates_Code FROM #Avail_Dates
			)
			AND atd.IS_Exclusive IN(@EX_YES, @EX_NO) 
			AND (
				atd.Title_Code IN (
					SELECT Title_Code FROM #TitleCodes
				) OR @IsTitleFilter = 'N'
			)
		) AS TitleOutput

	END

	IF OBJECT_ID('tempdb..#tempCriteria') IS NOT NULL DROP TABLE #tempCriteria
	IF OBJECT_ID('tempdb..#Platform_Avail') IS NOT NULL DROP TABLE #Platform_Avail
	IF OBJECT_ID('tempdb..#Platform_Search') IS NOT NULL DROP TABLE #Platform_Search
	IF OBJECT_ID('tempdb..#Avail_Dates') IS NOT NULL DROP TABLE #Avail_Dates
	IF OBJECT_ID('tempdb..#TitleCodes') IS NOT NULL DROP TABLE #TitleCodes

END
