
CREATE PROCEDURE [dbo].[USP_Theatrical_Availability_Report]
(
	@Title_Code VARCHAR(MAX)='0', 
	@Country_Code VARCHAR(MAX)='0', 
	@Title_Language_Code VARCHAR(MAX),
	@Date_Type VARCHAR(2),
	@StartDate VARCHAR(20),
	@EndDate VARCHAR(20),
	@RestrictionRemarks VARCHAR(10),
	@OthersRemarks VARCHAR(10),
	@Exclusivity VARCHAR(1) ,   --B-Both, E-Exclusive,N-NonExclusive 
	@SubLicense_Code VARCHAR(MAX), --Comma   Separated SubLicensing Code. 0-No Sub Licensing ,
	@Region_ExactMatch VARCHAR(10),
	@Region_MustHave VARCHAR(MAX)='0',
	@Region_Exclusion VARCHAR(MAX)='0',
	@BU_Code VARCHAR(20),
	@Is_Digital BIT = 'false'
)
AS
BEGIN
	
	Set @EndDate = Case When IsNull(@EndDate, '') = '' Then '31Mar9999' Else @EndDate End
	
	-- SET NOCOUNT ON added to prevent extra result sets FROM
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	PRINT 'STEP-1 Filter Criteria      ' + convert(varchar(30),getdate() ,109)
	BEGIN

	IF(UPPER(@RestrictionRemarks) = 'TRUE')
		SET @RestrictionRemarks = 'Y'
	ELSE
		SET @RestrictionRemarks = 'N'

	IF(UPPER(@OthersRemarks) = 'TRUE')
		SET @OthersRemarks = 'Y'
	ELSE
		SET @OthersRemarks = 'N'

	DECLARE @EX_YES BIT = 2, @EX_NO BIT = 2
	IF(UPPER(@Exclusivity) = 'E')
		SET @EX_YES = 1
	ELSE IF(UPPER(@Exclusivity) = 'N')
		SET @EX_NO = 0
	ELSE IF(UPPER(@Exclusivity) = 'B')
	BEGIN
		SET @EX_YES = 1
		SET @EX_NO = 0
	END
	
	----------------- Title Population
	SELECT number AS Title_Code INTO #Temp_Title FROM dbo.fn_Split_withdelemiter(@Title_Code, ',') WHERE number NOT IN('0', '')
	------------------ END
			
	----------------- Country Population 
	CREATE TABLE #Temp_Country(
		Country_Code INT
	)

	INSERT INTO #Temp_Country
	SELECT DISTINCT number FROM fn_Split_withdelemiter(@Country_Code , ',') WHERE number NOT LIKE 'T%' AND number NOT IN('0')
	
	INSERT INTO #Temp_Country
	SELECT DISTINCT Country_Code FROM Territory_Details td WHERE td.Territory_Code IN (
		SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Code, ',') WHERE number LIKE 'T%' AND number NOT IN('0')
	) AND td.Country_Code NOT IN (
		SELECT tc.Country_Code FROM #Temp_Country tc
	)
	AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
	AND td.Country_Code NOT IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion, ',') WHERE number NOT IN ( '0', ''))

	------------------ END
	
	----------------- Language Population 
	SELECT @Title_Language_Code = LTRIM(RTRIM(@Title_Language_Code))
	SELECT number INTO #Temp_Title_Language FROM dbo.fn_Split_withdelemiter(@Title_Language_Code,',') WHERE number NOT IN('0', '')
	SELECT CAST(number AS INT) SubLicense_Code INTO #Tmp_SL FROM fn_Split_withdelemiter(@SubLicense_Code, ',') WHERE number NOT IN('0', '')
	------------------ END

	DELETE FROM #Temp_Country WHERE Country_Code = 0
	DELETE FROM #Temp_Title WHERE Title_Code = 0
	DELETE FROM #Temp_Title_Language WHERE number = 0
	
	IF NOT EXISTS(SELECT * FROM #Temp_Country)
	BEGIN
		
		INSERT INTO #Temp_Country
		SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active, 'N') = 'Y'

	END

	IF NOT EXISTS(SELECT Top 1 * FROM #Temp_Title)
	BEGIN
		INSERT INTO #Temp_Title
		SELECT DISTINCT Title_Code FROM Avail_Acq_Theatrical
	END

	IF NOT EXISTS(SELECT Top 1 * FROM #Tmp_SL)
	BEGIN
		INSERT INTO #Tmp_SL
		SELECT Sub_License_Code FROM Sub_License
	END
	END

	PRINT 'STEP-2 Populate #Avail_Acq_Theatrical  ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	-----------------Query to get Avail information related to Title ,Platform AND Country
	CREATE TABLE #Avail_Acq_Theatrical 
	(
		Avail_Acq_Theatrical_Code INT, 
		Title_Code INT, 
		Platform_Code INT, 
		Country_Code INT
	)
		
	INSERT INTO #Avail_Acq_Theatrical(Avail_Acq_Theatrical_Code, Title_Code, Platform_Code, Country_Code)
	SELECT DISTINCT AA.Avail_Acq_Theatrical_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code
	FROM Avail_Acq_Theatrical AA  
	WHERE AA.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) 
	--AND (AA.Platform_Code IN (SELECT number FROM #Temp_Platform) )
	AND (AA.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc) )
	------------------ END
	END
	
	PRINT 'STEP-2.1 Populate RAW DATA  ' + convert(varchar(30),getdate() ,109)
	BEGIN
		Create Table #Avail_Dates(
			Avail_Dates_Code	int,
			Start_Date	datetime,
			End_Date	datetime
		)

		IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
		Begin
			Insert InTo #Avail_Dates(Avail_Dates_Code, Start_Date, End_Date)
			Select Avail_Dates_Code, Start_Date, End_Date From Avail_Dates Where (ISNULL(Start_Date, '9999-12-31') <= @StartDate AND ISNULL(End_Date, '9999-12-31') >= @EndDate)
		End
		Else
		Begin
			Insert InTo #Avail_Dates(Avail_Dates_Code, Start_Date, End_Date)
			Select Avail_Dates_Code, Start_Date, End_Date From Avail_Dates 
			Where (
				(ISNULL(Start_Date, '9999-12-31') BETWEEN @StartDate AND  @EndDate)
				OR (ISNULL(End_Date, '9999-12-31') BETWEEN @StartDate AND @EndDate)
				OR (@StartDate BETWEEN  ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
				OR (@EndDate BETWEEN ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
			)
		End

		UPDATE #Avail_Dates SET Start_Date = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE Start_Date < GETDATE()

		Select ar.Avail_Raw_Code, ar.Acq_Deal_Code, ar.Acq_Deal_Rights_Code, ar.Avail_Dates_Code, ar.Is_Exclusive,
			ad.Start_Date, ad.End_Date 
			InTo #Avail_Raw 
		From Avail_Raw ar 
		Inner Join #Avail_Dates ad On ar.Avail_Dates_Code = ad.Avail_Dates_Code
		Where 
			ar.Is_Exclusive IN (@Ex_YES, @Ex_NO)

		Drop Table #Avail_Dates
	END


	PRINT 'STEP-3 Populate @Temp_Right ' + convert(varchar(30),getdate() ,109)
	BEGIN

	DECLARE @strSQLNEO AS VARCHAR(MAX)
	DECLARE @Sub_License_Code_Avail VARCHAR(10)
	SELECT @Sub_License_Code_Avail = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Sub_License_Code_Avail'

	CREATE TABLE #Temp_Right_Remarks 
	(
		Acq_Deal_Rights_Code INT, 
		Restriction_Remarks VARCHAR(4000), 
		Remarks VARCHAR(4000), 
		Rights_Remarks VARCHAR(4000),
		Sub_Deal_Restriction_Remark VARCHAR(8000), 
		Sub_License_Name Varchar(100)
	)

	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	Begin
		
		Insert InTo #Temp_Right_Remarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name)
		SELECT DISTINCT ar.Acq_Deal_Rights_Code, ar.Restriction_Remarks, 
			ad.Remarks, ad.Rights_Remarks, 
			(
				STUFF((SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
				FROM Acq_Deal AD_Tmp
				INNER JOIN Acq_Deal_Rights ADR_Tmp ON adr_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
				WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
				(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = ar.Acq_Deal_Code)
				FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,'')
			) As Sub_Deal_Restriction_Remark, 
			CASE WHEN ISNULL(sl.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END
		FROM Acq_Deal_Rights ar
			INNER JOIN #Avail_Raw ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			Inner Join Acq_Deal ad On ar.Acq_Deal_Code = ad.Acq_Deal_Code
			Inner Join Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code
			Inner Join #Tmp_SL tsl On tsl.SubLicense_Code = ar.Sub_License_Code And tsl.SubLicense_Code = sl.Sub_License_Code
		WHERE 
			(ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0)
		

	End
	Else
	Begin
		
		Insert InTo #Temp_Right_Remarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name)
		Select DISTINCT ar.Acq_Deal_Rights_Code, '', '', '', '', 
		CASE WHEN ISNULL(sl.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END
		FROM Acq_Deal_Rights ar
		INNER JOIN #Avail_Raw ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		Inner Join Acq_Deal ad On ar.Acq_Deal_Code = ad.Acq_Deal_Code
		Inner Join Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code
		Inner Join #Tmp_SL tsl On tsl.SubLicense_Code = ar.Sub_License_Code And tsl.SubLicense_Code = sl.Sub_License_Code
		WHERE 
		(ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0)
		
	End
	
	END

	
	PRINT 'STEP-4 Populate ' + convert(varchar(30),getdate() ,109)
	--return
	BEGIN

	-----------------Populate Title Avail for Title Languages
	
	CREATE INDEX IX_TMP_Avail_Acq ON #Avail_Acq_Theatrical(Avail_Acq_Theatrical_Code)
	
	Create Table #TMP_MAIN(
		Title_Code			Int, 
		Platform_Code		Int, 
		Country_Code		Int,
		Avail_Acq_Theatrical_Code		numeric(38,0),
		Avail_Raw_Code		numeric(38,0),
		Country_Cd_Str		Varchar(3000),
		Region_Type			Varchar(1),
		Country_Names		Varchar(Max),
		Group_No			Int
	)

	IF EXISTS(SELECT Top 1 * FROM #Temp_Title_Language)
	Begin

		Select Title_Code InTo #TTL_Title From Title t 
		Inner Join #Temp_Title_Language ttl On t.Title_Language_Code = ttl.number

		Insert InTo #TMP_MAIN(Title_Code, Platform_Code, Country_Code, Avail_Acq_Theatrical_Code, Avail_Raw_Code)
		Select AA.Title_Code, AA.Platform_Code, AA.Country_Code, asd.Avail_Acq_Theatrical_Code, asd.Avail_Raw_Code
		From #Avail_Acq_Theatrical AA
		Inner Join #TTL_Title ttl On aa.Title_Code = ttl.Title_Code
		Inner Join Avail_Acq_Theatrical_Details asd On asd.Avail_Acq_Theatrical_Code = AA.Avail_Acq_Theatrical_Code
		Inner Join #Avail_Raw ar On ar.Avail_Raw_Code = asd.Avail_Raw_Code
	

	End
	Else
	Begin

		Insert InTo #TMP_MAIN(Title_Code, Platform_Code, Country_Code, Avail_Acq_Theatrical_Code, Avail_Raw_Code)
		Select AA.Title_Code, AA.Platform_Code, AA.Country_Code, asd.Avail_Acq_Theatrical_Code, asd.Avail_Raw_Code
		From #Avail_Acq_Theatrical AA
		Inner Join Avail_Acq_Theatrical_Details asd On asd.Avail_Acq_Theatrical_Code = AA.Avail_Acq_Theatrical_Code
		Inner Join #Avail_Raw ar On ar.Avail_Raw_Code = asd.Avail_Raw_Code
		
	End

	
	END
	
		
	PRINT 'STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	UPDATE t2 SET t2.Country_Cd_Str =  STUFF
	(
		(
			SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #TMP_MAIN t1 
			WHERE t1.Title_Code = t2.Title_Code
				  AND t1.Platform_Code = t2.Platform_Code
				  AND t1.Avail_Raw_Code = t2.Avail_Raw_Code
				  
			FOR XML PATH('')
		), 1, 1, ''
	)
	FROM #TMP_MAIN t2

	
	PRINT 'STEP-9.1- Country Exact Match ' + convert(varchar(30),getdate() ,109)
	-----------------IF Country = Exact Match
	IF(UPPER(@Region_ExactMatch) = 'EM')
	BEGIN
			
		DECLARE @CntryStr VARCHAR(1000) = ''
		SELECT @CntryStr = 
		STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #Temp_Country
				FOR XML PATH('')
			), 1, 1, ''
		)
			
		DELETE FROM #TMP_MAIN WHERE Country_Cd_Str <> @CntryStr

	END
	
	Create Table #Temp_Country_Names(
		RowId Int Identity(1, 1),
		Country_Codes Varchar(2000)
	)
	
	Insert InTo #Temp_Country_Names(Country_Codes)
	Select Distinct Country_Cd_Str From #TMP_MAIN
	
	PRINT 'STEP-9.2- Country Must Have ' + convert(varchar(30),getdate() ,109)
	-----------------IF Country = Must Have
	IF(UPPER(@Region_ExactMatch) = 'MH')
	BEGIN
		
		TRUNCATE TABLE #Temp_Country

		DECLARE @Cntry_MustHaveCnt INT = 0
		
		INSERT INTO #Temp_Country
		SELECT number FROM dbo.fn_Split_withdelemiter(@Region_MustHave, ',') WHERE number NOT IN ('', '0')
		
		SELECT @Cntry_MustHaveCnt = COUNT(*) FROM #Temp_Country
				
		DELETE TM FROM #Temp_Country_Names TM WHERE TM.Country_Codes NOT IN
		(
			SELECT DISTINCT Country_Codes FROM #Temp_Country_Names tm
			WHERE
			(
				SELECT COUNT(number) FROM dbo.fn_Split_withdelemiter(tm.Country_Codes, ',')
				WHERE number NOT IN ('', '0') AND number IN (SELECT c.Country_Code FROM #Temp_Country c)
			) >= @Cntry_MustHaveCnt
		)
		
		DELETE FROM #TMP_MAIN WHERE Country_Cd_Str NOT IN (SELECT Country_Codes FROM #Temp_Country_Names)
	END
	
	PRINT 'STEP-9.3- Country Names ' + convert(varchar(30),getdate() ,109)
	-----------------UPDATE Country / Territory Names
	
	Update a Set a.Group_No = b.RowId From #TMP_MAIN a 
	Inner Join #Temp_Country_Names b On a.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS = b.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 
	
	--Select * From #Temp_Country_Names
	--Select * From #TMP_MAIN

	Create Table #Tbl_Ret (
		Region_Code Int,
		Cluster_Names Varchar(4000),
		Region_Name Varchar(MAX),
		Group_No Int
	)

	Insert InTo #Tbl_Ret
	Select c.Region_Code, c.Cluster_Name, c.Region_Name, tc.RowId
	From #Temp_Country_Names tc
	Cross Apply DBO.UFN_Get_Report_Territory(tc.Country_Codes, tc.RowId) c

		
	PRINT 'STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
	---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS
	
	Create Table #Temp_Main_Ctr
	(
		Avail_Acq_Theatrical_Code Numeric(38,0),
		Avail_Raw_Code Numeric(38,0),
		Title_Code Int, 
		Platform_Code Int,
		Country_Code Int,
		Country_Cd_Str Varchar(2000),
		Cluster_Names Varchar(2000),
		Country_Names Varchar(Max),
		Region_Type Varchar(2000),
		Platform_Str Varchar(2000),
		Title_Language_Names Varchar(2000)
	)

	Insert InTo #Temp_Main_Ctr(Avail_Acq_Theatrical_Code, Avail_Raw_Code, Title_Code, Platform_Code,
							   Country_Code, Country_Cd_Str, Cluster_Names, Country_Names, Region_Type, Platform_Str, Title_Language_Names)
	Select Avail_Acq_Theatrical_Code, Avail_Raw_Code, Title_Code, Platform_Code, 
		   b.Region_Code, Country_Cd_Str, b.Cluster_Names, b.Region_Name, Region_Type, '' Platform_Str, '' Title_Language_Names
	From (
		SELECT *
		FROM (
			SELECT ROW_NUMBER() OVER(
				PARTITION BY Avail_Acq_Theatrical_Code, Avail_Raw_Code, Title_Code, Platform_Code, Country_Code, Region_Type
				ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type DESC
			) RowId, * 
			FROM #TMP_MAIN tm
		) AS a WHERE RowId = 1
	) As a 
	Inner Join #Tbl_Ret b On a.Group_No = b.Group_No
	
	---------- END
	
	DROP TABLE #TMP_MAIN
	
	END
	
	print 'STEP-12 Query to get title details' + convert(varchar(30),getdate() ,109)	
	BEGIN
		-----------------Query to get title details
		SELECT t.Title_Code, t.Title_Language_Code,
			t.Title_Name
			--CASE WHEN ISNULL(Year_Of_Production, '') = '' THEN Title_Name ELSE Title_Name + ' ('+ CAST(Year_Of_Production AS VARCHAR(10)) + ')' END Title_Name
			,Genres_Name = [dbo].[UFN_GetGenresForTitle](t.Title_Code),
			Star_Cast = [dbo].[UFN_GetStarCastForTitle](t.Title_Code),
			Director = [dbo].[UFN_GetDirectorForTitle](t.Title_Code),
			COALESCE(t.Duration_In_Min, '0') Duration_In_Min, COALESCE(t.Year_Of_Production, '') Year_Of_Production,
			l.Language_Name
		INTO #Temp_Titles
		FROM Title t 
		Inner Join Language l On t.Title_Language_Code = l.Language_Code
		WHERE(t.Title_Code IN (SELECT tm.Title_Code FROM #Temp_Main_Ctr tm))
		------------------END
	END


	DROP TABLE #Temp_Country_Names
	
	DECLARE @RU_DB VARCHAR(50)
	select @RU_DB = Parameter_Value FROM System_Parameter_new WHERE Parameter_Name = 'RightsU_DB'
	DECLARE @strSQL VARCHAR(MAX)

	CREATE TABLE #FINALAVAIlREPORT
	(
		Title_Name VARCHAR(1000), 
		Platform_Name VARCHAR(2000), 
		Country_Name VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS , 
		Cluster_Names VARCHAR(1000),
		Right_Start_Date DATETIME, 
		Rights_End_Date DATETIME,
		Title_Language_Names  VARCHAR(4000), 
		Genres_Name VARCHAR(1000), 
		Star_Cast  VARCHAR(1000), 
		Director  VARCHAR(1000), 
		Duration_In_Min VARCHAR(10), 
		Year_Of_Production VARCHAR(10), 
		Restriction_Remark VARCHAR(4000), 
		Sub_Deal_Restriction_Remark VARCHAR(4000),
		Remarks VARCHAR(4000), 
		Rights_Remarks VARCHAR(4000), 
		Exclusive VARCHAR(20), 
		Sub_License VARCHAR(100), 
		Platform_Avail VARCHAR(3),
		Episode_From INT,
		Episode_To INT
	)

	------------------ Final Output
	
	print 'STEP-13 DIGITAL REPORT ' + convert(varchar(30),getdate() ,109)	
	IF(@Is_Digital = 1)
	BEGIN
		
		print 'If'
		SET @strSQLNEO = 'Insert InTo #FINALAVAIlREPORT EXEC '+ @RU_DB +'.[dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail]
		@Title_Code = '''+ @Title_Code +''',
		@Country_Code ='''+ @Country_Code+''',
		@Title_Language_Code = '''+ @Title_Language_Code +''',
		@Date_Type = '''+ @Date_Type +''',
		@StartDate = '''+ @StartDate +''',
		@EndDate = '''+ @EndDate +''',
		@RestrictionRemarks = '''+ CASE WHEN @RestrictionRemarks = 'Y' THEn 'true'ELSE 'false'END +''',
		@OthersRemarks = '''+ CASE WHEN @OthersRemarks = 'Y' THEn 'true'ELSE 'false'END +''',
		@Exclusivity = '''+ @Exclusivity +''',
		@SubLicense_Code = '''+ @SubLicense_Code +''',
		@Region_ExactMatch = '''+ @Region_ExactMatch +''',
		@Region_MustHave = '''+ @Region_MustHave +''',
		@Region_Exclusion = '''+ @Region_Exclusion +''',
		@BU_Code = '''+ @BU_Code +''',
		@Is_SubLicense = ''N'',
		@Is_Approved = ''A'',
		@Deal_Type_Code= 1 ,
		@Episode_From = 0,
		@Episode_To = 0'

		print @strSQLNEO
		EXEC (@strSQLNEO)
		print '2'
	
	END
	
	------------------ END

	print 'STEP-14 Final query ' + convert(varchar(30),getdate() ,109)	
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN
			SELECT DISTINCT
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name,
			 tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS  AS Country_Name, Cluster_Names,
			CAST(AR.Start_Date AS DATETIME) Right_Start_Date,
			CAST(ISNULL(AR.End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			trt.Language_Name AS Title_Language_Names,
			trt.Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS Genres_Name, trt.Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS Star_Cast, 
			trt.Director COLLATE SQL_Latin1_General_CP1_CI_AS Director, trt.Duration_In_Min, trt.Year_Of_Production,
			trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark,
			trr.Remarks, trr.Rights_Remarks, CASE WHEN ar.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive,
			trr.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
		FROM
			#Temp_Main_Ctr tm
			INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
			--INNER JOIN #Avail_Dates AD On ar.Avail_Dates_Code = AD.Avail_Dates_Code
			INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
			INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Cluster_Names, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail 
		FROM #FINALAVAIlREPORT

	END
	ELSE
	BEGIN

		
		SELECT DISTINCT
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name,
			tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS AS Country_Name, Cluster_Names,
			CAST(ar.Start_Date AS DATETIME) Right_Start_Date, 
			CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			trt.Language_Name Title_Language_Names,
			trt.Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS Genres_Name, trt.Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS Star_Cast, 
			trt.Director COLLATE SQL_Latin1_General_CP1_CI_AS Director, trt.Duration_In_Min, trt.Year_Of_Production,
			'' Restriction_Remark, '' Sub_Deal_Restriction_Remark,
			'' Remarks, '' Rights_Remarks, CASE WHEN ar.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive,
			trr.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
		FROM #Temp_Main_Ctr tm
		INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
		INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Cluster_Names, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail 
		FROM #FINALAVAIlREPORT
		
	END
	------------------ END
	

	print 'STEP-14 Final query ' + convert(varchar(30),getdate() ,109)	
	DROP TABLE #FINALAVAIlREPORT
	DROP TABLE #Avail_Raw
	DROP TABLE #Temp_Title
	DROP TABLE #Temp_Main_Ctr
	DROP TABLE #Temp_Titles
	DROP TABLE #Temp_Country
	DROP TABLE #Temp_Title_Language
	DROP TABLE #Avail_Acq_Theatrical
END

/*
	EXEC [USP_Theatrical_Availability]
	@Title_Code ='0,13254',
	--@Platform_Code ='0',
	@Country_Code ='0',
	--@Is_Original_Language ='true',
	@Title_Language_Code ='0',
	@Date_Type ='FL',
	@StartDate ='23-Sep-2015',
	@EndDate ='23-Sep-2020',
	@RestrictionRemarks ='false',
	@OthersRemarks ='false',--D
	--@Platform_ExactMatch ='False', 
	--@MustHave_Platform ='0', 
	@Exclusivity ='B' ,
	@SubLicense_Code ='0',
	@Region_ExactMatch ='false',
	@Region_MustHave ='0',
	@Region_Exclusion = '0',
	--@Subtit_Language_Code ='0',
	--@Dubbing_Subtitling='0',
	--@Dubbing_Language_Code='0',
	@Bu_Code=1,
	@Is_Digital = 'false'

*/

