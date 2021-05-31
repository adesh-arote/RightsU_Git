CREATE PROCEDURE [dbo].[USP_Movie_Availability_Indiacast]
(
	--DECLARE
	@Title_Code VarChar(MAX)='0', 
	@Is_Original_Language BIT, 
	@Title_Language_Code VarChar(MAX),

	@Date_Type VarChar(2), 
	@StartDate VarChar(20),
	@EndDate VarChar(20),
	
	--@Platform_Group_Code VarChar(max)= null,
	@Platform_Code VarChar(MAX)='0',
	@Platform_ExactMatch VarChar(10),  
	@MustHave_Platform VarChar(MAX)='0',

	@Is_IFTA_Cluster Char(1) = 'N',
	--@Territory_Code VarChar(max) = null,
    @Country_Code VarChar(MAX)='0', 
	@Region_ExactMatch VarChar(10),
	@Region_MustHave VarChar(MAX)='0',
	@Region_Exclusion VarChar(MAX)='0',

	@Dubbing_Subtitling VarChar(20),
	--@Subtitling_Group_Code VarChar(max) = null,
	@Subtit_Language_Code VarChar(MAX)='0',
	@Subtitling_ExactMatch Char(10) = null,
	@Subtitling_MustHave VarChar(max) = null,
	@Subtitling_Exclusion VarChar(max) = null,
	 
	--@Dubbing_Group_Code VarChar(max) = null,
	@Dubbing_Language_Code VarChar(MAX)='0',
	@Dubbing_ExactMatch Char(10) = null,
	@Dubbing_MustHave VarChar(max) = null,
	@Dubbing_Exclusion VarChar(max) = null,

	@Exclusivity VarChar(1),   --B-Both, E-Exclusive,N-NonExclusive 
	@SubLicense_Code VarChar(MAX), --Comma   Separated SubLicensing Code. 0-No Sub Licensing,	
	@RestrictionRemarks VarChar(10),
	@OthersRemarks VarChar(10),
	@BU_Code VarChar(20),
	@Is_Digital BIT = 'false'
)
AS
BEGIN

	--Set @Episode_From = Case When IsNull(@Episode_From, 0) < 1 Then 1 Else @Episode_From End
	--Set @Episode_To = Case When IsNull(@Episode_To, 0) < 1 Then 100000 Else @Episode_To End
	Set @EndDate = Case When IsNull(@EndDate, '') = '' Then '31Mar9999' Else @EndDate End
	DECLARE @Indiacast_Avail_India_Code varchar(5)
	SELECT  @Indiacast_Avail_India_Code = Parameter_Value FROM System_Parameter_New where Parameter_Name ='India_Avail'
	--select * from title where Title_Name like '%test short%'
--select 	@title_code='598', 
--	@is_original_language='true', 
--	@title_language_code='',
--	@date_type ='FL',
--	@startdate ='29-Feb-2020',
--	@enddate ='',
--	@platform_code='50', 
--	@platform_exactmatch='', 
--	@musthave_platform='', 
--	@is_ifta_cluster = 'N',
--    @country_code='3', 
--	@region_exactmatch='',
--	@region_musthave='0',
--	@region_exclusion='0',

--	@dubbing_subtitling='D',
--	@subtit_language_code='',--'1,10,100,101,102,103,104,105,106,107,108,109,11,110,111,112,113,114,115,116,12,13,14,15,17,18,19,2,20,21,22,23,24,25,26,27,28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,41,42,43,45,46,47,48,49,5,50,51,52,53,54,55,56,57,58,59,6,60,61,62,63,64,65,66,67,68,69,7,70,71,72,73,74,75,76,77,78,79,8,80,81,82,83,84,85,86,87,88,89,9,90,91,92,93,94,95,96,97,98,99', 
--	@subtitling_exactmatch = '', --mh/em/false
--	@subtitling_musthave = '',
--	@subtitling_exclusion = '0',
	
--	@dubbing_language_code='33', 
--	@dubbing_exactmatch = '',
--	@dubbing_musthave = '',
--	@dubbing_exclusion = '0',

--	@exclusivity='B',
--	@sublicense_code='0', --comma   separated sublicensing code. 0-no sub licensing ,
--	@restrictionremarks='false',
--	@othersremarks='false',
--	@bu_code=0,
--	@is_digital= 'true'
	

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

	DECLARE @EX_YES bit=2,@EX_NO bit=2
	IF(UPPER(@Exclusivity) = 'E')
		SET @EX_YES = 1
	ELSE IF(UPPER(@Exclusivity) = 'N')
	BEGIN
		SET @EX_NO = 0
		SET @EX_YES = 0
	END
	ELSE IF(UPPER(@Exclusivity) = 'B')
	BEGIN
		SET @EX_YES = 1
		SET @EX_NO = 0
	END
	
	----------------- Title AND Platform Population
	SELECT number AS Title_Code INTO #Temp_Title FROM dbo.fn_Split_withdelemiter(@Title_Code, ',') WHERE number NOT IN('0', '')
	SELECT CAST(number AS INT) number INTO #Temp_Platform FROM dbo.fn_Split_withdelemiter(@Platform_Code,',') WHERE number NOT IN('0', '')
	
	------------------ END
			
	----------------- Country Population 
	CREATE TABLE #Temp_Country(
		Country_Code INT
	)

	INSERT INTO #Temp_Country
	SELECT DISTINCT number FROM fn_Split_withdelemiter(@Country_Code , ',') WHERE number NOT LIKE 'T%' AND number NOT IN(@Indiacast_Avail_India_Code)
	
	IF(@Is_IFTA_Cluster = 'N')
	BEGIN

		INSERT INTO #Temp_Country
		SELECT DISTINCT Country_Code FROM Territory_Details td WHERE td.Territory_Code IN (
			SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Code, ',') WHERE number LIKE 'T%' AND number NOT IN('0')
		) AND td.Country_Code NOT IN (
			SELECT tc.Country_Code FROM #Temp_Country tc
		)
		AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
		AND td.Country_Code NOT IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion, ',') WHERE number NOT IN ( '0', ''))

	END
	ELSE IF(@Is_IFTA_Cluster = 'Y')
	BEGIN
		
		INSERT INTO #Temp_Country
		SELECT DISTINCT Country_Code FROM Report_Territory_Country td WHERE td.Report_Territory_Code IN (
			SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Code, ',') WHERE number LIKE 'T%' AND number NOT IN('0')
		) AND td.Country_Code NOT IN (
			SELECT tc.Country_Code FROM #Temp_Country tc
		)
		AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
		AND td.Country_Code NOT IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion, ',') WHERE number NOT IN ( '0', ''))

	END

	------------------ END
	
	----------------- Language Population 
	SELECT @Subtit_Language_Code = LTRIM(RTRIM(@Subtit_Language_Code)), @Title_Language_Code = LTRIM(RTRIM(@Title_Language_Code)), @Dubbing_Language_Code = LTRIM(RTRIM(@Dubbing_Language_Code))
		
	SELECT number INTO #Temp_Title_Language FROM dbo.fn_Split_withdelemiter(@Title_Language_Code,',') WHERE number NOT IN('0', '')
			
	CREATE TABLE #Temp_Sub_Language(
		Language_Code INT
	)		
	CREATE TABLE #Temp_Dub_Language(
		Language_Code INT
	)
	
	CREATE TABLE #Temp_Sub_MH(
		Language_Code INT
	)		
	CREATE TABLE #Temp_Dub_MH(
		Language_Code INT
	)

	INSERT INTO #Temp_Sub_Language(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Subtit_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	INSERT INTO #Temp_Dub_Language(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Dubbing_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	INSERT INTO #Temp_Sub_MH(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Subtitling_MustHave, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	INSERT INTO #Temp_Dub_MH(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Dubbing_MustHave, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	SELECT CAST(number AS INT) SubLicense_Code INTO #Tmp_SL FROM fn_Split_withdelemiter(@SubLicense_Code, ',') WHERE number NOT IN('0', '')
	------------------ END

	DELETE FROM #Temp_Country WHERE Country_Code = 0
	DELETE FROM #Temp_Sub_Language WHERE Language_Code = 0
	DELETE FROM #Temp_Dub_Language WHERE Language_Code = 0
	DELETE FROM #Temp_Title WHERE Title_Code = 0
	DELETE FROM #Temp_Platform WHERE number = 0
	DELETE FROM #Temp_Title_Language WHERE number = 0
	

	IF NOT EXISTS(SELECT * FROM #Temp_Country)
	BEGIN
		
		INSERT INTO #Temp_Country
		SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active, 'N') = 'Y' AND c.Country_Code NOT IN(@Indiacast_Avail_India_Code)

	END

	Create Table #Temp_Avail_Languages(
		Avail_Languages_Code Numeric(38,0),
		Languages_Code Varchar(MAX),
		Languages_Name Varchar(MAx),
		Lang_Type Char(1),
		Lang_Cnt Int
	)

	Declare @Language_Code Varchar(10) = '', @MHCnt Int = 0, @MHAllCnt Int = 0
	IF(Charindex('S', @Dubbing_Subtitling) > 0)
	Begin
	
		IF(IsNull(@Subtitling_Exclusion, '') = '')
			Set @Subtitling_Exclusion = '0'

		Declare Cur_Language Cursor For Select Language_Code From #Temp_Sub_Language 
										Where Language_Code Not In (
											SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Subtitling_Exclusion,',')
										)
										Order By Cast(Language_Code AS Varchar(10)) ASC
		Open Cur_Language
		Fetch Next From Cur_Language InTo @Language_Code
		While (@@FETCH_STATUS = 0)
		Begin

			Delete From #Temp_Sub_MH Where Language_Code = 0

			Set @MHCnt = 0
			If Exists (Select Top 1 * From #Temp_Sub_MH Where Language_Code = @Language_Code)
				Set @MHCnt = @MHCnt + 1

			MERGE INTO #Temp_Avail_Languages AS tmp
			USING Avail_Languages al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @Language_Code + ',%'
			WHEN MATCHED THEN
				UPDATE SET tmp.Languages_Code = tmp.Languages_Code + ',' + @Language_Code, Lang_Cnt = Lang_Cnt + @MHCnt
			WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @Language_Code + ',%' THEN
				INSERT VALUES (al.Avail_Languages_Code, @Language_Code, '', 'S', @MHCnt)
			;

			Fetch Next From Cur_Language InTo @Language_Code	
		End
		Close Cur_Language
		Deallocate Cur_Language

		IF(UPPER(@Subtitling_ExactMatch) = 'EM')
		BEGIN
			
			DECLARE @SubStr VARCHAR(1000) = ''
			SELECT @SubStr = 
			STUFF
			(
				(
					SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Temp_Sub_Language
					FOR XML PATH('')
				), 1, 1, ''
			)
			
			DELETE FROM #Temp_Avail_Languages WHERE Languages_Code <> @SubStr AND Lang_Type = 'S'

		END
		
		IF(UPPER(@Subtitling_ExactMatch) = 'MH')
		BEGIN
			Select @MHAllCnt = Count(*) From #Temp_Sub_MH
			DELETE FROM #Temp_Avail_Languages WHERE Lang_Cnt <> @MHAllCnt AND Lang_Type = 'S'
		End
	End


	--Select * from #Temp_Sub_MH

	IF(Charindex('D', @Dubbing_Subtitling) > 0)
	Begin
		
		IF(IsNull(@Dubbing_Exclusion, '') = '')
			Set @Dubbing_Exclusion = '0'

		Declare Cur_Language Cursor For Select Language_Code From #Temp_Dub_Language 
										Where Language_Code Not In (
											SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Dubbing_Exclusion,',')
										)
										Order By Cast(Language_Code AS Varchar(10)) ASC
		Open Cur_Language
		Fetch Next From Cur_Language InTo @Language_Code
		While (@@FETCH_STATUS = 0)
		Begin
		
			Delete From #Temp_Sub_MH Where Language_Code = 0

			Set @MHCnt = 0
			If Exists (Select Top 1 * From #Temp_Dub_MH Where Language_Code = @Language_Code)
				Set @MHCnt = @MHCnt + 1

			MERGE INTO #Temp_Avail_Languages AS tmp
			USING Avail_Languages al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @Language_Code + ',%' AND tmp.Lang_Type = 'D'
			WHEN MATCHED THEN
				UPDATE SET tmp.Languages_Code = tmp.Languages_Code + ',' + @Language_Code, Lang_Cnt = Lang_Cnt + @MHCnt
			WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @Language_Code + ',%' THEN
				INSERT VALUES (al.Avail_Languages_Code, @Language_Code, '', 'D', @MHCnt)
			;

			Fetch Next From Cur_Language InTo @Language_Code	
		End
		Close Cur_Language
		Deallocate Cur_Language
		
		IF(UPPER(@Dubbing_ExactMatch) = 'EM')
		BEGIN
			
			DECLARE @DubStr VARCHAR(1000) = ''
			SELECT @DubStr = 
			STUFF
			(
				(
					SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Temp_Dub_Language
					FOR XML PATH('')
				), 1, 1, ''
			)
			
			DELETE FROM #Temp_Avail_Languages WHERE Languages_Code <> @DubStr AND Lang_Type = 'D'
		END
		
		IF(UPPER(@Dubbing_ExactMatch) = 'MH')
		BEGIN
			Select @MHAllCnt = Count(*) From #Temp_Dub_MH
			DELETE FROM #Temp_Avail_Languages WHERE Lang_Cnt <> @MHAllCnt AND Lang_Type = 'D'
		End
	End
	
	--Select * from #Temp_Avail_Languages
	--RETURN

	--Select * from #Temp_Avail_Languages

	IF NOT EXISTS(SELECT Top 1 * FROM #Temp_Title)
	BEGIN
		INSERT INTO #Temp_Title
		SELECT DISTINCT Title_Code FROM Avail_Acq
	END
	--IF NOT EXISTS(SELECT Top 1 * FROM #Temp_Title_Language)
	--BEGIN
	--	INSERT INTO #Temp_Title_Language
	--	SELECT Language_Code FROM Language
	--END
		
	IF NOT EXISTS(SELECT Top 1 * FROM #Temp_Platform)
	BEGIN
		INSERT INTO #Temp_Platform (number)
		SELECT Platform_Code FROM Platform WHERE Is_Last_Level = 'Y'
	END
	IF NOT EXISTS(SELECT Top 1 * FROM #Tmp_SL)
	BEGIN
		INSERT INTO #Tmp_SL
		SELECT Sub_License_Code FROM Sub_License
	END
	END

	PRINT 'STEP-2 Populate #Avail_Acq  ' + convert(varchar(30),getdate() ,109)
	BEGIN
	--CREATE INDEX IX_Temp_Title ON #Temp_Title(Title_Code)	
	-----------------Query to get Avail information related to Title ,Platform AND Country
	CREATE TABLE #Avail_Acq 
	(
		Avail_Acq_Code INT, 
		Title_Code INT, 
		Platform_Code INT, 
		Country_Code INT
	)
		
	INSERT INTO #Avail_Acq(Avail_Acq_Code, Title_Code, Platform_Code, Country_Code)
	SELECT DISTINCT AA.Avail_Acq_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code
	FROM Avail_Acq AA  
	WHERE AA.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) 
	AND (AA.Platform_Code IN (SELECT number FROM #Temp_Platform) )
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

		Select ar.Avail_Raw_Code, ar.Acq_Deal_Code, ar.Acq_Deal_Rights_Code, ar.Avail_Dates_Code, ar.Is_Exclusive, --ar.Episode_From, ar.Episode_To
		--Case When ar.Episode_From < @Episode_From Then @Episode_From Else ar.Episode_From End As Episode_From, 
		--Case When ar.Episode_To > @Episode_To Then @Episode_To Else ar.Episode_To End As Episode_To, 
		--ar.Episode_From,
		--ar.Episode_To,
		ad.Start_Date, ad.End_Date 
		InTo #Avail_Raw 
		From Avail_Raw ar 
		Inner Join #Avail_Dates ad On ar.Avail_Dates_Code = ad.Avail_Dates_Code
		Where 
		--(
		--	ar.Episode_From Between @Episode_From And @Episode_To Or
		--	ar.Episode_To Between @Episode_From And @Episode_To Or
		--	@Episode_From Between ar.Episode_From And ar.Episode_To Or
		--	@Episode_To Between ar.Episode_From And ar.Episode_To
		--) 
		--AND 
		ar.Is_Exclusive IN (@Ex_YES, @Ex_NO)

		Drop Table #Avail_Dates
	END

	PRINT 'STEP-3 Populate @#Temp_Right_Remarks ' + convert(varchar(30),getdate() ,109)

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
			Sub_License_Name Varchar(100),
			Category_Name VARCHAR(1000),
			Deal_Type_Name VARCHAR(1000)
		)

		IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
		Begin
		
			Insert InTo #Temp_Right_Remarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name,Category_Name,Deal_Type_Name)
			SELECT DISTINCT ar.Acq_Deal_Rights_Code, ar.Restriction_Remarks, 
				   ad.Remarks, ad.Rights_Remarks, 
				   (
						STUFF((SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
						FROM Acq_Deal AD_Tmp
						INNER JOIN Acq_Deal_Rights ADR_Tmp ON adr_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
						WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
						(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = ar.Acq_Deal_Code AND adm_Tmp.Title_Code = ADRT.Title_Code
						AND ISNULL(adm_Tmp.Episode_Starts_From,0) = ISNULL(ADRT.Episode_From,0) AND ISNULL(adm_Tmp.Episode_End_To,0) = ISNULL(ADRT.Episode_To,0))
						FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,'')
					) As Sub_Deal_Restriction_Remark, 
					CASE WHEN ISNULL(sl.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END,C.Category_Name,DT.Deal_Type_Name
			FROM Acq_Deal_Rights ar
			INNER JOIN #Avail_Raw ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			Inner Join Acq_Deal ad On ar.Acq_Deal_Code = ad.Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ar.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			Inner Join Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code
			INNER JOIN Category C ON ad.Category_Code = C.Category_Code
			INNER JOIN Deal_Type DT ON ad.Deal_Type_Code = DT.Deal_Type_Code
			Inner Join #Tmp_SL tsl On tsl.SubLicense_Code = ar.Sub_License_Code And tsl.SubLicense_Code = sl.Sub_License_Code
			WHERE (ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR  CAST(@BU_Code AS INT) = 0)
			AND ADRT.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt)
		End
		Else
		Begin
		
			Insert InTo #Temp_Right_Remarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name,Category_Name,Deal_Type_Name)
			Select DISTINCT ar.Acq_Deal_Rights_Code, '', '', '', '', 
			CASE WHEN ISNULL(sl.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END,C.Category_Name,DT.Deal_Type_Name
			FROM Acq_Deal_Rights ar
			INNER JOIN #Avail_Raw ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			Inner Join Acq_Deal ad On ar.Acq_Deal_Code = ad.Acq_Deal_Code
			Inner Join Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code
			INNER JOIN Category C ON ad.Category_Code = C.Category_Code
			INNER JOIN Deal_Type DT ON ad.Deal_Type_Code = DT.Deal_Type_Code
			Inner Join #Tmp_SL tsl On tsl.SubLicense_Code = ar.Sub_License_Code And tsl.SubLicense_Code = sl.Sub_License_Code
			WHERE (ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0)
		End
		
	END

	PRINT 'STEP-4 Populate ' + convert(varchar(30),getdate() ,109)

	BEGIN

	-----------------Populate Title Avail for Title Languages
	
	CREATE INDEX IX_TMP_Avail_Acq ON #Avail_Acq(Avail_Acq_Code)
	
	Create Table #TMP_MAIN(
		Title_Code			Int, 
		Platform_Code		Int, 
		Country_Code		Int,
		Avail_Acq_Code		numeric(38,0),
		Avail_Raw_Code		numeric(38,0),
		Is_Title_Language	bit,
		Sub_Language_Code	numeric(38,0),
		Dub_Language_code	numeric(38,0),
		Country_Cd_Str		Varchar(3000),
		Region_Type			Varchar(1),
		Country_Names		Varchar(Max),
		Group_No			Int,
		Acq_Deal_Rights_Holdback_Code INT, 
		Holdback_Type		Char(1), 
		Holdback_Release_Date Date, 
		Holdback_On_Platform_Code Int
	)

	IF EXISTS(SELECT Top 1 * FROM #Temp_Title_Language)
	Begin
		
		Select Title_Code InTo #TTL_Title From Title t 
		Inner Join #Temp_Title_Language ttl On t.Title_Language_Code = ttl.number

		Insert InTo #TMP_MAIN(Title_Code, Platform_Code, Country_Code, Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code)
		Select AA.Title_Code, AA.Platform_Code, AA.Country_Code, asd.Avail_Acq_Code, asd.Avail_Raw_Code, Case When @Is_Original_Language = 1 Then asd.Is_Title_Language Else 0 End, asd.Sub_Language_Code, asd.Dub_Language_Code
		From #Avail_Acq AA
		Inner Join #TTL_Title ttl On aa.Title_Code = ttl.Title_Code
		Inner Join Avail_Acq_Details asd On asd.Avail_Acq_Code = AA.Avail_Acq_Code
		Inner Join #Avail_Raw ar On ar.Avail_Raw_Code = asd.Avail_Raw_Code
		Where 
		(
			(@Is_Original_Language = 1 AND asd.Is_Title_Language = 1)
			OR
			(
				Charindex('S', @Dubbing_Subtitling) > 0 AND 
				asd.Sub_Language_Code In (
					Select Avail_Languages_Code From #Temp_Avail_Languages Where Lang_Type = 'S'
				)
			)
			OR
			(
				Charindex('D', @Dubbing_Subtitling) > 0 AND 
				asd.Dub_Language_Code In (
					Select Avail_Languages_Code From #Temp_Avail_Languages Where Lang_Type = 'D'
				)
			)
		)

	End
	Else
	Begin

		Insert InTo #TMP_MAIN(Title_Code, Platform_Code, Country_Code, Avail_Acq_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code)
		Select AA.Title_Code, AA.Platform_Code, AA.Country_Code, asd.Avail_Acq_Code, asd.Avail_Raw_Code, Case When @Is_Original_Language = 1 Then asd.Is_Title_Language Else 0 End, asd.Sub_Language_Code, asd.Dub_Language_Code
		From #Avail_Acq AA
		Inner Join Avail_Acq_Details asd On asd.Avail_Acq_Code = AA.Avail_Acq_Code
		Inner Join #Avail_Raw ar On ar.Avail_Raw_Code = asd.Avail_Raw_Code
		Where 
		(
			(@Is_Original_Language = 1 AND asd.Is_Title_Language = 1)
			OR
			(
				Charindex('S', @Dubbing_Subtitling) > 0 AND 
				asd.Sub_Language_Code In (
					Select Avail_Languages_Code From #Temp_Avail_Languages Where Lang_Type = 'S'
				)
			)
			OR
			(
				Charindex('D', @Dubbing_Subtitling) > 0 AND 
				asd.Dub_Language_Code In (
					Select Avail_Languages_Code From #Temp_Avail_Languages Where Lang_Type = 'D'
				)
			)
		)

	End

	
	Select Distinct tm.Avail_Raw_Code InTo #ArCodes From #TMP_MAIN tm

	Delete From #Avail_Raw Where Avail_Raw_Code Not In (Select a.Avail_Raw_Code From #ArCodes a)
	
	Drop Table #ArCodes

	END
	
	
	print 'STEP-14 Generate Holdback Data ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		Update tm
		Set tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code, tm.Holdback_Type = hb.Holdback_Type, 
			tm.Holdback_Release_Date = hb.Holdback_Release_Date, tm.Holdback_On_Platform_Code = hb.Holdback_On_Platform_Code
		From Acq_Deal_Rights_Holdback hb
		INNER JOIN #Avail_Raw ar On hb.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Platform hbp On hb.Acq_Deal_Rights_Holdback_Code = hbp.Acq_Deal_Rights_Holdback_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Territory hbt On hb.Acq_Deal_Rights_Holdback_Code = hbt.Acq_Deal_Rights_Holdback_Code
		INNER JOIN #TMP_MAIN tm On tm.Avail_Raw_Code = ar.Avail_Raw_Code AND tm.Platform_Code = hbp.Platform_Code AND tm.Country_Code = hbt.Country_Code
		Where ((hb.Holdback_Type = 'D' And CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATE) >= CAST(hb.Holdback_Release_Date AS DATE) AND CAST(hb.Holdback_Release_Date AS DATE) >= GETDATE()) Or hb.Holdback_Type = 'R')
		OR ISNULL(hb.Holdback_Release_Date,'') = ''
		--Where (hb.Holdback_Type = 'D' And CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME) > hb.Holdback_Release_Date AND hb.Holdback_Release_Date > GETDATE()) Or hb.Holdback_Type = 'R'
		
		Select Distinct Title_Code InTo #MainTit From #TMP_MAIN

		Select Distinct Acq_Deal_Rights_Holdback_Code, Holdback_Type, Cast('' As NVarchar(Max)) HBComments,  Cast(0 As Int) HB_Run_After_Release_No, Cast(0 As Int) HB_Run_After_Release_Units
		InTo #MainAH 
		From #TMP_MAIN Where Acq_Deal_Rights_Holdback_Code Is Not Null

		Update thb
		Set thb.HBComments = Case When hb.HB_Run_After_Release_No < 0 Then 'Before ' Else 'After ' End + Cast (ABS(hb.HB_Run_After_Release_No) AS VArchar(10)) + 
							 Case hb.HB_Run_After_Release_Units When 1 Then ' Days' When 2 Then ' Weeks' When 3 Then ' Months' When 4 Then ' Years' End + ' On ',
			thb.HB_Run_After_Release_No = hb.HB_Run_After_Release_No,
			thb.HB_Run_After_Release_Units = hb.HB_Run_After_Release_Units
		From #MainAH thb
		INNER JOIN Acq_Deal_Rights_Holdback hb On thb.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code

		Create Table #ReleaseCountry(
			Title_Release_Code Int, 
			Country_Code Int
		)
		
		Insert InTo #ReleaseCountry(Title_Release_Code, Country_Code)
		Select Distinct tr.Title_Release_Code, Country_Code 
		From Title_Release tr
		INNER JOIN #MainTit mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Region trr On tr.Title_Release_Code = trr.Title_Release_Code And Country_Code Is Not Null
		UNION
		Select Distinct tr.Title_Release_Code, trd.Country_Code 
		From Title_Release tr
		INNER JOIN #MainTit mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Region trr On tr.Title_Release_Code = trr.Title_Release_Code And Territory_Code Is Not Null
		INNER JOIN Territory_Details trd On trr.Territory_Code = trd.Territory_Code

		--Select tr.*
		Update tm Set tm.Holdback_Release_Date = Case mh.HB_Run_After_Release_Units 
													  When 1 Then DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
													  When 2 Then DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
													  When 3 Then DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
													  When 4 Then DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
													  Else tr.Release_Date
												 End
		From Title_Release tr
		INNER JOIN #MainTit mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Platforms trp On tr.Title_Release_Code = trp.Title_Release_Code
		INNER JOIN #ReleaseCountry trc On tr.Title_Release_Code = trc.Title_Release_Code
		INNER JOIN #TMP_MAIN tm On tm.Title_Code = tr.Title_Code AND tm.Title_Code = mt.Title_Code 
								   AND tm.Holdback_On_Platform_Code = trp.Platform_Code AND tm.Country_Code = trc.Country_Code
								   AND tm.Holdback_Type = 'R'
		Inner Join #MainAH mh On tm.Acq_Deal_Rights_Holdback_Code = mh.Acq_Deal_Rights_Holdback_Code
		Where 
			Case mh.HB_Run_After_Release_Units 
				When 1 Then DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 2 Then DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 3 Then DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 4 Then DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
				Else tr.Release_Date
			End >= Cast(GetDate() As Date)

		Delete mh
		From Title_Release tr
		INNER JOIN #MainTit mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Platforms trp On tr.Title_Release_Code = trp.Title_Release_Code
		INNER JOIN #ReleaseCountry trc On tr.Title_Release_Code = trc.Title_Release_Code
		INNER JOIN #TMP_MAIN tm On tm.Title_Code = tr.Title_Code AND tm.Title_Code = mt.Title_Code 
								   AND tm.Holdback_On_Platform_Code = trp.Platform_Code AND tm.Country_Code = trc.Country_Code
								   AND tm.Holdback_Type = 'R'
		Inner Join #MainAH mh On tm.Acq_Deal_Rights_Holdback_Code = mh.Acq_Deal_Rights_Holdback_Code
		Where 
			Case mh.HB_Run_After_Release_Units 
				When 1 Then DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 2 Then DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 3 Then DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 4 Then DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
				Else tr.Release_Date
			End < Cast(GetDate() As Date)

		Drop Table #MainTit
		Drop Table #ReleaseCountry

	END


	print 'STEP-6 UPDATE Language Names ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		-----------------Get Language Names for #Temp_Main
		CREATE TABLE #Temp_Language_Names(
			Language_Codes VARCHAR(MAX),
			Language_Names VARCHAR(MAX)
		)

		INSERT INTO #Temp_Language_Names(Language_Codes)
		SELECT DISTINCT Languages_Code FROM #Temp_Avail_Languages
	
		UPDATE #Temp_Language_Names SET Language_Names = [dbo].[UFN_Get_Language_With_Parent](Language_Codes)

		UPDATE tm SET tm.Languages_Name = tml.Language_Names FROM #Temp_Avail_Languages tm 
		INNER JOIN #Temp_Language_Names tml ON tm.Languages_Code = tml.Language_Codes

	END
	
	CREATE TABLE #Temp_Main_Ctr
		(
			Avail_Raw_Code Numeric(38,0),
			Title_Code Int, 
			Platform_Code Int,
			Country_Code Int,
			Is_Title_Language bit, 
			Sub_Language_Code Varchar(2000),
			Dub_Language_code Varchar(2000),  
			Country_Cd_Str Varchar(2000),
			Country_Names Varchar(Max),
			Region_Type Varchar(2000),
			Platform_Str Varchar(2000),
			Title_Language_Names Varchar(2000),
			Sub_Language_Names Varchar(4000),
			Dub_Language_Names Varchar(4000),
			Acq_Deal_Rights_Holdback_Code INT, 
			Holdback_Type		Char(1), 
			Holdback_Release_Date Date, 
			Holdback_On_Platform_Code Int,
			Reverse_Holdback NVarchar(Max),
			Group_no Int
		)

	INSERT INTO #Temp_Main_Ctr(Title_Code, Platform_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
							  Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code)
	SELECT DISTINCT Title_Code, Platform_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
					Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code
	FROM #TMP_MAIN


	PRINT 'STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
	BEGIN
	
		UPDATE t2 SET t2.Country_Cd_Str =  STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #TMP_MAIN t1 
				WHERE t1.Title_Code = t2.Title_Code
						AND t1.Platform_Code = t2.Platform_Code
						AND t1.Avail_Raw_Code = t2.Avail_Raw_Code
						AND t1.Is_Title_Language = t2.Is_Title_Language
						AND IsNull(t1.Sub_Language_Code, 0) = IsNull(t2.Sub_Language_Code, 0)
						AND IsNull(t1.Dub_Language_code, 0) = IsNull(t2.Dub_Language_code, 0)
						-------- Conditions for  Holdback
						AND IsNull(t1.Acq_Deal_Rights_Holdback_Code, 0) = IsNull(t2.Acq_Deal_Rights_Holdback_Code, 0)
						AND IsNull(t1.Holdback_Type, '') = IsNull(t2.Holdback_Type, '')
						AND IsNull(t1.Holdback_Release_Date, '') = IsNull(t2.Holdback_Release_Date, '') 
						AND IsNull(t1.Holdback_On_Platform_Code, 0) = IsNull(t2.Holdback_On_Platform_Code, 0) 
				FOR XML PATH('')
			), 1, 1, ''
		)
	FROM #Temp_Main_Ctr t2


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
			
			DELETE FROM #Temp_Main_Ctr WHERE Country_Cd_Str <> @CntryStr

		END
	
		Create Table #Temp_Country_Names(
			RowId Int Identity(1, 1),
			Country_Codes Varchar(2000)
		)
	
		Insert InTo #Temp_Country_Names(Country_Codes)
		Select Distinct Country_Cd_Str From #Temp_Main_Ctr
	
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
		
			DELETE FROM #Temp_Main_Ctr WHERE Country_Cd_Str NOT IN (SELECT Country_Codes FROM #Temp_Country_Names)
		END
	
		PRINT 'STEP-9.3- Country Names ' + convert(varchar(30),getdate() ,109)
		-----------------UPDATE Country / Territory Names
	
		Update a Set a.Group_No = b.RowId From #Temp_Main_Ctr a 
		Inner Join #Temp_Country_Names b On a.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS = b.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

		
	
		Create Table #Tbl_Ret (
			Region_Code Int,
			Region_Name Varchar(MAX),
			Group_No Int
		)

		Insert InTo #Tbl_Ret
		Select c.Region_Code, c.Region_Name, tc.RowId
		From #Temp_Country_Names tc
		Cross Apply DBO.UFN_Get_Indiacast_Report_Country(tc.Country_Codes, tc.RowId) c

		print 'STEP-11 Country Names in #Temp_Main_Ctr' + convert(varchar(30),getdate() ,109)	
		BEGIN		
		
			UPDATE tms
			SET tms.Country_Names = b.Region_Name , tms.Country_Code = b.Region_Code
			FROM #Temp_Main_Ctr tms
			INNER JOIN #Tbl_Ret b On tms.Group_no = b.Group_No 
		END

		PRINT 'STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
		---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS
	
		--Create Table #Temp_Main_Ctr
		--(
		--	Avail_Acq_Code Numeric(38,0),
		--	Avail_Raw_Code Numeric(38,0),
		--	Title_Code Int, 
		--	Platform_Code Int,
		--	Country_Code Int,
		--	Is_Title_Language bit, 
		--	Sub_Language_Code Varchar(2000),
		--	Dub_Language_code Varchar(2000),  
		--	Country_Cd_Str Varchar(2000),
		--	Country_Names Varchar(Max),
		--	Region_Type Varchar(2000),
		--	Platform_Str Varchar(2000),
		--	Title_Language_Names Varchar(2000),
		--	Sub_Language_Names Varchar(4000),
		--	Dub_Language_Names Varchar(4000),
		--	Acq_Deal_Rights_Holdback_Code INT, 
		--	Holdback_Type		Char(1), 
		--	Holdback_Release_Date Date, 
		--	Holdback_On_Platform_Code Int,
		--	Reverse_Holdback NVarchar(Max)
		--)

		--Insert InTo #Temp_Main_Ctr(Avail_Acq_Code, Avail_Raw_Code, Title_Code, Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
		--						   Country_Code, Country_Cd_Str,Country_Names, Region_Type, Platform_Str, Title_Language_Names, Sub_Language_Names, Dub_Language_Names,
		--						   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code)
		--Select Avail_Acq_Code, Avail_Raw_Code, Title_Code, Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
		--	   b.Region_Code, Country_Cd_Str, b.Region_Name, Region_Type, '' Platform_Str, '' Title_Language_Names, '' Sub_Language_Names, '' Dub_Language_Names,
		--	   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code
		--From (
		--	SELECT *
		--	FROM (
		--		SELECT ROW_NUMBER() OVER(
		--			PARTITION BY Avail_Acq_Code, Avail_Raw_Code, Title_Code, Platform_Code, Country_Code, Region_Type, 
		--						 Is_Title_Language, Sub_Language_Code, Dub_Language_code, Acq_Deal_Rights_Holdback_Code, Holdback_Release_Date
		--			ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type, Is_Title_Language, Sub_Language_Code, Dub_Language_code DESC
		--		) RowId, * 
		--		FROM #TMP_MAIN tm
		--	) AS a WHERE RowId = 1
		--) As a 
		--Inner Join #Tbl_Ret b On a.Group_No = b.Group_No
	
		---------- END

		DROP TABLE #TMP_MAIN
	
	END
	
	PRINT 'STEP-10- Platform Must Have / Exact Match ' + convert(varchar(30),getdate() ,109)
	--return
	BEGIN

		UPDATE t2
		SET t2.Platform_Str =  STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Platform_Code As Varchar) FROM #Temp_Main_Ctr t1 
				WHERE t1.Title_Code = t2.Title_Code
					AND ISNULL(t1.Country_Cd_Str, 0) = ISNULL(t2.Country_Cd_Str, 0)
					AND t1.Country_Code = t2.Country_Code
					AND t1.Avail_Raw_Code = t2.Avail_Raw_Code
					AND t1.Is_Title_Language = t2.Is_Title_Language
					AND IsNull(t1.Sub_Language_Code, 0) = IsNull(t2.Sub_Language_Code, 0)
					AND IsNull(t1.Dub_Language_code, 0) = IsNull(t2.Dub_Language_code, 0)
					-------- Conditions for Holdback
					AND IsNull(t1.Acq_Deal_Rights_Holdback_Code, 0) = IsNull(t2.Acq_Deal_Rights_Holdback_Code, 0)
					AND IsNull(t1.Holdback_Type, '') = IsNull(t2.Holdback_Type, '')
					AND IsNull(t1.Holdback_Release_Date, '') = IsNull(t2.Holdback_Release_Date, '') 
					AND IsNull(t1.Holdback_On_Platform_Code, 0) = IsNull(t2.Holdback_On_Platform_Code, 0) 
				FOR XML PATH('')
			), 1, 1, ''
		)
		FROM #Temp_Main_Ctr t2

		IF(UPPER(@Platform_ExactMatch) = 'EM' OR UPPER(@Platform_ExactMatch) = 'MH')
		BEGIN
			--Select 1

			IF(UPPER(@Platform_ExactMatch) = 'EM')
			BEGIN
			

				DECLARE @PlStr VARCHAR(1000) = ''
				SELECT @PlStr = 
					STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(number AS VARCHAR) FROM #Temp_Platform
							FOR XML PATH('')
						), 1, 1, ''
				   ) 

				DELETE FROM #Temp_Main_Ctr WHERE IsNull(Platform_Str, '') <> @PlStr

			END

			-----------------IF Platform = Must Have
			IF(UPPER(@Platform_ExactMatch) = 'MH')
			BEGIN
	
				TRUNCATE TABLE #Temp_Platform
				DECLARE @MustHaveCnt INT = 0

				INSERT INTO #Temp_Platform
				SELECT number FROM dbo.fn_Split_withdelemiter(@MustHave_Platform, ',') WHERE number NOT IN ('', '0')

				print '--------------1'
				SELECT @MustHaveCnt = COUNT(*) FROM #Temp_Platform
				
				SELECT DISTINCT Platform_Str
				INTO #Temp_Plt_Names
				FROM #Temp_Main_Ctr tm
				

				DELETE TM 
				FROM 
				#Temp_Plt_Names TM
				WHERE TM.Platform_Str NOT IN
				(SELECT DISTINCT Platform_Str
				FROM #Temp_Plt_Names tm
				WHERE 
					(SELECT COUNT(number) 
					FROM dbo.fn_Split_withdelemiter(Platform_Str, ',') 
					WHERE number NOT IN ('', '0') 
					AND number IN (SELECT p.number FROM #Temp_Platform p))>= @MustHaveCnt	
				)
		
				DELETE FROM #Temp_Main_Ctr WHERE Platform_Str NOT IN (SELECT tpn.Platform_Str FROM #Temp_Plt_Names tpn)
				print '--------------2'
			END
		END
	END

	print 'STEP-11 UPDATE LANGUAGE Names in #Temp_Main_Ctr' + convert(varchar(30),getdate() ,109)	
	BEGIN		
		
	UPDATE tms
	SET tms.Sub_Language_Names = asub.Languages_Name
	FROM #Temp_Main_Ctr tms
	INNER JOIN #Temp_Avail_Languages asub ON asub.Avail_Languages_Code = tms.Sub_Language_Code And asub.Lang_Type = 'S'
		
	UPDATE tms
	SET tms.Dub_Language_Names = ad.Languages_Name
	FROM #Temp_Main_Ctr tms
	INNER JOIN #Temp_Avail_Languages ad ON ad.Avail_Languages_Code = tms.Dub_Language_Code And ad.Lang_Type = 'D'

   END		
   	
	print 'STEP-12 Query to get title details' + convert(varchar(30),getdate() ,109)	
	BEGIN
		-----------------Query to get title details
		SELECT t.Title_Code, t.Title_Language_Code,
			--t.Title_Name
			CASE WHEN ISNULL(Year_Of_Production, '') = '' THEN Title_Name ELSE Title_Name + ' ('+ CAST(Year_Of_Production AS VARCHAR(10)) + ')' END Title_Name
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
	DROP TABLE #Temp_Language_Names
	
	DECLARE @RU_DB VARCHAR(50)
	select @RU_DB = Parameter_Value FROM System_Parameter_new WHERE Parameter_Name = 'RightsU_DB'
	DECLARE @strSQL VARCHAR(MAX)

	CREATE TABLE #FINALAVAIlREPORT
	(
		Title_Name VARCHAR(1000), 
		Platform_Name VARCHAR(2000), 
		Country_Name VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS , 
		Right_Start_Date DATETIME, 
		Rights_End_Date DATETIME,
		Title_Language_Names  VARCHAR(4000), 
		Sub_Language_Names VARCHAR(4000), 
		Dub_Language_Names VARCHAR(4000), 
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
		Episode_To INT,
		Category_Name NVARCHAR(MAX),
		Deal_Type_Name VARCHAR(1000)
	)

	------------------ Final Output
	
	print 'STEP-13 REVERSE HOLDBACK ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		Select Distinct Title_Code , Cast('' As NVarchar(Max)) strRHB --Country_Cd_Str, Platform_Str, 
		InTo #TempRHB From #Temp_Main_Ctr
		Update #TempRHB Set strRHB = [dbo].[UFN_GET_SYNRHB](Title_Code)

		Update a Set a.Reverse_Holdback = b.strRHB 
		From #Temp_Main_Ctr a 
		Inner Join #TempRHB b On a.Title_Code = b.Title_Code --AND a.Country_Cd_Str = b.Country_Cd_Str AND a.Platform_Str = b.Platform_Str
	
		Drop Table #TempRHB

	END

	print 'STEP-14 DIGITAL REPORT ' + convert(varchar(30),getdate() ,109)	
	IF(@Is_Digital = 1)
	BEGIN
		
		print 'If'
		SET @strSQLNEO = 'Insert InTo #FINALAVAIlREPORT EXEC '+ @RU_DB +'.[dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]
		@Title_Code = '''+ @Title_Code +''',
		@Platform_Code = '''+ @Platform_Code +''',
		@Country_Code ='''+ @Country_Code+''',
		@Is_Original_Language ='''+ CASE WHEN @Is_Original_Language = 1 THEn 'true'ELSE 'false'END +''',
		@Title_Language_Code = '''+ @Title_Language_Code +''',
		@Date_Type = '''+ @Date_Type +''',
		@StartDate = '''+ @StartDate +''',
		@EndDate = '''+ @EndDate +''',
		@RestrictionRemarks = '''+ CASE WHEN @RestrictionRemarks = 'Y' THEn 'true'ELSE 'false'END +''',
		@OthersRemarks = '''+ CASE WHEN @OthersRemarks = 'Y' THEn 'true'ELSE 'false'END +''',
		@Platform_ExactMatch = '''+ @Platform_ExactMatch +''',
		@MustHave_Platform = '''+ @MustHave_Platform +''',
		@Exclusivity = '''+ @Exclusivity +''',
		@SubLicense_Code = '''+ @SubLicense_Code +''',
		@Region_ExactMatch = '''+ @Region_ExactMatch +''',
		@Region_MustHave = '''+ @Region_MustHave +''',
		@Region_Exclusion = '''+ @Region_Exclusion +''',
		@Subtit_Language_Code = '''+ @Subtit_Language_Code +''',
		@Dubbing_Subtitling = '''+ @Dubbing_Subtitling +''',
		@StartMonth = 0,
		@EndYear = 0,
		@Dubbing_Language_Code = '''+ @Dubbing_Language_Code +''',
		@BU_Code = '''+ @BU_Code +''',
		@Is_SubLicense = ''N'',
		@Is_Approved = ''A'',
		@Deal_Type_Code= 1 ,
		@Episode_From = 0,
		@Episode_To = 0,
		@Is_IFTA_Cluster = '''+ @Is_IFTA_Cluster +''''

		print @strSQLNEO
		EXEC (@strSQLNEO)
		print '2'
		
	END



	print 'STEP-15 Final query ' + convert(varchar(30),getdate() ,109)	
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN
	print 'ad'
		SELECT DISTINCT
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name,
			 tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS  AS Country_Name, 
			 Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date
				THEN ar.Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			CAST(ISNULL(AR.End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Case When tm.Is_Title_Language = 1 Then trt.Language_Name Else '' End COLLATE SQL_Latin1_General_CP1_CI_AS Title_Language_Names,
			Sub_Language_Names, Dub_Language_Names, trt.Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS Genres_Name, trt.Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS Star_Cast, 
			trt.Director COLLATE SQL_Latin1_General_CP1_CI_AS Director, trt.Duration_In_Min, trt.Year_Of_Production,
			trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark,
			trr.Remarks, trr.Rights_Remarks, CASE WHEN ar.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive,
			trr.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail,
			CASE WHEN ISNULL(pt1.Platform_Hiearachy,'') = '' OR ar.Start_Date > tm.Holdback_Release_Date THEN '' ELSE hb.HBComments + pt1.Platform_Hiearachy END COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn, 
			tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, 
			CASE WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date THEN '' ELSE CONVERT(VARCHAR(20),tm.Holdback_Release_Date, 103) END 
			COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date, --, pt1.Platform_Hiearachy As Holdback_On_Platform
			Reverse_Holdback COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback
			,trr.Category_Name,trr.Deal_Type_Name
		FROM
			#Temp_Main_Ctr tm
			INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
			INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
			INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
			LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
			LEFT JOIN #MainAH hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ar.Acq_Deal_Code
			WHERE (ISNULL(tm.Holdback_Release_Date,'')<>'' AND CAST(tm.Holdback_Release_Date AS DATETIME) < CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME)) OR
			ISNULL(tm.Holdback_Release_Date,'') = ''
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS,  Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Sub_Language_Names, Dub_Language_Names, Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail,
		'' COLLATE SQL_Latin1_General_CP1_CI_AS AS HoldbackOn , '' COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, '' COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date,--, '' As Holdback_On_Platform
		'' COLLATE SQL_Latin1_General_CP1_CI_AS AS Reverse_Holdback,Category_Name,Deal_Type_Name
		FROM #FINALAVAIlREPORT

	END
	ELSE
	BEGIN
	print 'aa'
		
		SELECT DISTINCT
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name,
			tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS AS Country_Name, 
			Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date
				THEN ar.Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Case When tm.Is_Title_Language = 1 Then trt.Language_Name Else '' End COLLATE SQL_Latin1_General_CP1_CI_AS    Title_Language_Names,
			Sub_Language_Names, Dub_Language_Names, trt.Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS Genres_Name, trt.Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS Star_Cast, 
			trt.Director COLLATE SQL_Latin1_General_CP1_CI_AS Director, trt.Duration_In_Min, trt.Year_Of_Production,
			'' Restriction_Remark, '' Sub_Deal_Restriction_Remark,
			'' Remarks, '' Rights_Remarks, CASE WHEN ar.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive,
			trr.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail,
			CASE WHEN ISNULL(pt1.Platform_Hiearachy,'') = '' OR ar.Start_Date > tm.Holdback_Release_Date THEN '' ELSE hb.HBComments + pt1.Platform_Hiearachy END 
			COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn
			, tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS  AS Holdback_Type, 
			CASE WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date THEN '' ELSE CONVERT(VARCHAR(20), tm.Holdback_Release_Date, 103) END 
			COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date, --, pt1.Platform_Hiearachy As Holdback_On_Platform
			Reverse_Holdback COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback
			,trr.Category_Name,trr.Deal_Type_Name
		FROM #Temp_Main_Ctr tm
		INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
		INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
		LEFT JOIN #MainAH hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ar.Acq_Deal_Code
		WHERE (ISNULL(tm.Holdback_Release_Date,'')<>'' AND CAST(tm.Holdback_Release_Date AS DATETIME) < CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME)) OR
		ISNULL(tm.Holdback_Release_Date,'') = ''
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Sub_Language_Names, Dub_Language_Names, Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail,
		'' COLLATE SQL_Latin1_General_CP1_CI_AS  As HoldbackOn, '' COLLATE SQL_Latin1_General_CP1_CI_AS  AS Holdback_Type, 
		'' COLLATE SQL_Latin1_General_CP1_CI_AS  AS Holdback_Release_Date,--, '' As Holdback_On_Platform
		'' COLLATE SQL_Latin1_General_CP1_CI_AS AS Reverse_Holdback,Category_Name,Deal_Type_Name
		FROM #FINALAVAIlREPORT

	END
	------------------ END

	
	print 'STEP-16 Final query ' + convert(varchar(30),getdate() ,109)	
	DROP TABLE #FINALAVAIlREPORT
	DROP TABLE #Avail_Raw
	DROP TABLE #Temp_Title
	DROP TABLE #Temp_Main_Ctr
	DROP TABLE #Temp_Titles
	--DROP TABLE #Temp_Right
	DROP TABLE #Temp_Country
	DROP TABLE #Temp_Platform
	DROP TABLE #Temp_Title_Language
	DROP TABLE #Avail_Acq
	DROP TABLE #MainAH
	DROP TABLE #Temp_Sub_Language
	DROP TABLE #Temp_Dub_Language
	DROP TABLE #Temp_Sub_MH
	DROP TABLE #Temp_Dub_MH
	DROP TABLE #Tmp_SL
	DROP TABLE #Temp_Avail_Languages
	DROP TABLE #Temp_Right_Remarks
	DROP TABLE #Tbl_Ret
	--DROP TABLE #TMP_MAIN
	--DROP TABLE #Temp_Language_Names
	--DROP TABLE #Temp_Country_Names
END


--Exec USP_Movie_Availability_Indiacast	@Title_Code='8360', 
--	@Is_Original_Language=1, 
--	@Title_Language_Code='',
--	@Date_Type ='MI',
--	@StartDate ='15-Mar-2018',
--	@EndDate ='16-Mar-2018',
--	@Platform_Code='0', 
--	@Platform_ExactMatch='false', 
--	@MustHave_Platform='0', 

--	@Is_IFTA_Cluster = 'N',
--    @Country_Code='0', 
--	@Region_ExactMatch='false',
--	@Region_MustHave='0',
--	@Region_Exclusion='0',

--	@Dubbing_Subtitling='',
--	@Subtit_Language_Code='',--'1,10,100,101,102,103,104,105,106,107,108,109,11,110,111,112,113,114,115,116,12,13,14,15,17,18,19,2,20,21,22,23,24,25,26,27,28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,41,42,43,45,46,47,48,49,5,50,51,52,53,54,55,56,57,58,59,6,60,61,62,63,64,65,66,67,68,69,7,70,71,72,73,74,75,76,77,78,79,8,80,81,82,83,84,85,86,87,88,89,9,90,91,92,93,94,95,96,97,98,99', 
--	@Subtitling_ExactMatch = '', --MH/EM/false
--	@Subtitling_MustHave = '',
--	@Subtitling_Exclusion = '0',
	
--	@Dubbing_Language_Code='', 
--	@Dubbing_ExactMatch = '',
--	@Dubbing_MustHave = '',
--	@Dubbing_Exclusion = '0',

--	@Exclusivity='B',
--	@SubLicense_Code='0', --Comma   Separated SubLicensing Code. 0-No Sub Licensing ,
--	@RestrictionRemarks='N',
--	@OthersRemarks='false',
--	@BU_Code=0,
--	@Is_Digital= 'false'