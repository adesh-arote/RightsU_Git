CREATE PROCEDURE [dbo].[USP_Get_Title_Availability_LanguageWise_3_V1]
(
	@Title_Code VARCHAR(MAX)='0', 
	@Platform_Code VARCHAR(MAX)='0', 
    @Country_Code VARCHAR(MAX)='0', 
	@Is_Original_Language bit, 
	@Title_Language_Code VARCHAR(MAX),
	@Date_Type VARCHAR(2),
	@StartDate VARCHAR(20),
	@EndDate VARCHAR(20),
	@StartMonth VARCHAR(20),
	@EndYear VARCHAR(20),
	@RestrictionRemarks VARCHAR(10),
	@OthersRemarks VARCHAR(10),
	@Platform_ExactMatch VARCHAR(10),  
	@MustHave_Platform VARCHAR(MAX)='0', 
	@Exclusivity VARCHAR(1) ,   --B-Both, E-Exclusive,N-NonExclusive 
	@SubLicense_Code VARCHAR(MAX), --Comma   Separated SubLicensing Code. 0-No Sub Licensing ,
	@Region_ExactMatch VARCHAR(10),
	@Region_MustHave VARCHAR(MAX)='0',
	@Region_Exclusion VARCHAR(MAX)='0',
	@Subtit_Language_Code VARCHAR(MAX)='0', 
	@Dubbing_Language_Code VARCHAR(MAX)='0', 
	@Dubbing_Subtitling VARCHAR(20),
	@BU_Code VARCHAR(20),
	@Is_Digital bit = 'false',
	@Is_IFTA_Cluster CHAR(1) = 'N'

--[USP_Availability_Report_V3]
--(
--	@Title_Code VARCHAR(MAX)='0', 
--	@Platform_Code VARCHAR(MAX)='0', 
--    @Country_Code VARCHAR(MAX)='0', 
--	@Is_Original_Language bit, 
--	@Title_Language_Code VARCHAR(MAX),
--	@Date_Type VARCHAR(2),
--	@StartDate VARCHAR(20),
--	@EndDate VARCHAR(20),
--	@RestrictionRemarks VARCHAR(10),
--	@OthersRemarks VARCHAR(10),
--	@Platform_ExactMatch VARCHAR(10), 
--	@MustHave_Platform VARCHAR(MAX)='0', 
--	@Exclusivity VARCHAR(1) ,   --B-Both, E-Exclusive,N-NonExclusive 
--	@SubLicense_Code VARCHAR(MAX), --Comma   Separated SubLicensing Code. 0-No Sub Licensing ,
--	@Region_ExactMatch VARCHAR(10),
--	@Region_MustHave VARCHAR(MAX)='0',
--	@Region_Exclusion VARCHAR(MAX)='0',
--	@Subtit_Language_Code VARCHAR(MAX)='0', 
--	@Dubbing_Language_Code VARCHAR(MAX)='0', 
--	@Dubbing_Subtitling VARCHAR(20),
--	@BU_Code VARCHAR(20),
--	@Is_Digital bit = 'false'
)
AS
BEGIN

	--Set @Episode_From = Case When IsNull(@Episode_From, 0) < 1 Then 1 Else @Episode_From End
	--Set @Episode_To = Case When IsNull(@Episode_To, 0) < 1 Then 100000 Else @Episode_To End
	Set @EndDate = Case When IsNull(@EndDate, '') = '' Then '31Mar9999' Else @EndDate End


--Create Table TestParam(
--	Params Varchar(Max)
--)
	
	--Insert InTo TestParam
	--Select '@Title_Code='+@Title_Code+ 
	--',@Platform_Code='+@Platform_Code+ 
 --   ',@Country_Code='+@Country_Code+ 
	--',@Is_Original_Language='+Cast(@Is_Original_Language as varchar)+ 
	--',@Title_Language_Code='+@Title_Language_Code+
	--',@Date_Type='+@Date_Type+
	--',@StartDate='+@StartDate+
	--',@EndDate='+@EndDate+
	--',@StartMonth='+@StartMonth+
	--',@EndYear='+@EndYear+
	--',@RestrictionRemarks='+@RestrictionRemarks+
	--',@OthersRemarks='+@OthersRemarks+
	--',@Platform_ExactMatch='+@Platform_ExactMatch+
	--',@MustHave_Platform='+@MustHave_Platform+
	--',@Exclusivity='+@Exclusivity+
	--',@SubLicense_Code='+@SubLicense_Code+
	--',@Region_ExactMatch='+@Region_ExactMatch+
	--',@Region_MustHave='+@Region_MustHave+
	--',@Region_Exclusion='+@Region_Exclusion+
	--',@Subtit_Language_Code='+@Subtit_Language_Code+
	--',@Dubbing_Language_Code='+@Dubbing_Language_Code+
	--',@Dubbing_Subtitling='+@Dubbing_Subtitling+
	--',@BU_Code='+@BU_Code+
	--',@Is_Digital='+Cast(@Is_Digital as varchar)


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
		SET @EX_NO = 0
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
	SELECT DISTINCT number FROM fn_Split_withdelemiter(@Country_Code , ',') WHERE number NOT LIKE 'T%' AND number NOT IN('0')
	
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

	INSERT INTO #Temp_Sub_Language(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Subtit_Language_Code, ',') WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	INSERT INTO #Temp_Dub_Language(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Dubbing_Language_Code, ',') WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
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
		SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active, 'N') = 'Y'

	END

	Create Table #Temp_Avail_Languages(
		Avail_Languages_Code Numeric(38,0),
		Languages_Code Varchar(MAX),
		Languages_Name Varchar(MAx),
		Lang_Type Char(1)
	)

	Declare @Language_Code Varchar(10) = ''
	IF(Charindex('S', @Dubbing_Subtitling) > 0)
	Begin

		Declare Cur_Language Cursor For Select Language_Code From #Temp_Sub_Language
		Open Cur_Language
		Fetch Next From Cur_Language InTo @Language_Code
		While (@@FETCH_STATUS = 0)
		Begin

			MERGE INTO #Temp_Avail_Languages AS tmp
			USING Avail_Languages al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @Language_Code + ',%'
			WHEN MATCHED THEN
				UPDATE SET tmp.Languages_Code = tmp.Languages_Code + ',' + @Language_Code
			WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @Language_Code + ',%' THEN
				INSERT VALUES (al.Avail_Languages_Code, @Language_Code, '', 'S')
			;

			Fetch Next From Cur_Language InTo @Language_Code	
		End
		Close Cur_Language
		Deallocate Cur_Language

	End

	--Select * from #Temp_Avail_Languages
	
	IF(Charindex('D', @Dubbing_Subtitling) > 0)
	Begin
		
		Declare Cur_Language Cursor For Select Language_Code From #Temp_Dub_Language
		Open Cur_Language
		Fetch Next From Cur_Language InTo @Language_Code
		While (@@FETCH_STATUS = 0)
		Begin

			MERGE INTO #Temp_Avail_Languages AS tmp
			USING Avail_Languages al On tmp.Avail_Languages_Code = al.Avail_Languages_Code AND al.Language_Codes Like '%,' + @Language_Code + ',%' AND tmp.Lang_Type = 'D'
			WHEN MATCHED THEN
				UPDATE SET tmp.Languages_Code = tmp.Languages_Code + ',' + @Language_Code
			WHEN NOT MATCHED AND al.Language_Codes Like '%,' + @Language_Code + ',%' THEN
				INSERT VALUES (al.Avail_Languages_Code, @Language_Code, '', 'D')
			;

			Fetch Next From Cur_Language InTo @Language_Code	
		End
		Close Cur_Language
		Deallocate Cur_Language

	End

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
		WHERE --ad.Is_Master_Deal = 'Y'
		--AND ar.Is_Tentative = 'N'
		--AND ar.Is_Sub_License = 'Y'
		--AND ar.Sub_License_Code IN (SELECT SubLicense_Code FROM #Tmp_SL)
		--AND 
		ad.Business_Unit_Code = @BU_Code
		--AND ar.Acq_Deal_Rights_Code IN (
		--	SELECT IsNull(adrt.Acq_Deal_Rights_Code, 0) FROM #Temp_Title tt
		--	Inner Join Acq_Deal_Rights_Title adrt On Cast(tt.Title_Code As Int) = adrt.Title_Code
		--)
		--AND ar.Acq_Deal_Rights_Code IN (
		--	SELECT IsNull(adrp.Acq_Deal_Rights_Code, 0) FROM #Temp_Platform tp
		--	Inner Join Acq_Deal_Rights_Platform adrp On Cast(tp.number As Int) = adrp.Platform_Code
		--)

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
		WHERE --ad.Is_Master_Deal = 'Y'
		--AND ar.Is_Tentative = 'N'
		--AND ar.Is_Sub_License = 'Y'
		--AND ar.Sub_License_Code IN (SELECT SubLicense_Code FROM #Tmp_SL)
		--AND 
		ad.Business_Unit_Code = @BU_Code
		--AND ar.Acq_Deal_Rights_Code IN (
		--	SELECT IsNull(adrt.Acq_Deal_Rights_Code, 0) FROM #Temp_Title tt
		--	Inner Join Acq_Deal_Rights_Title adrt On Cast(tt.Title_Code As Int) = adrt.Title_Code
		--)
		--AND ar.Acq_Deal_Rights_Code IN (
		--	SELECT IsNull(adrp.Acq_Deal_Rights_Code, 0) FROM #Temp_Platform tp
		--	Inner Join Acq_Deal_Rights_Platform adrp On Cast(tp.number As Int) = adrp.Platform_Code
		--)

	End


	END

	
	PRINT 'STEP-4 Populate ' + convert(varchar(30),getdate() ,109)
	--return
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
	--Select * From #Avail_Raw --Where Avail_Acq_Code = 4299020
	--Select * From #TMP_MAIN Where Title_Code = 899 And Platform_Code = 170 And Country_Code = 134

	--Return
	--Select * From #TMP_MAIN

	END
	
	
	print 'STEP-14 Generate Holdback Data ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		--Select Distinct hb.Acq_Deal_Rights_Holdback_Code, Holdback_Type, hb.Holdback_Release_Date, hb.Holdback_On_Platform_Code,
		--ar.Avail_Raw_Code, tm.Title_Code, hbp.Platform_Code, tm.Country_Code
		Update tm
		Set tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code, tm.Holdback_Type = hb.Holdback_Type, 
			tm.Holdback_Release_Date = hb.Holdback_Release_Date, tm.Holdback_On_Platform_Code = hb.Holdback_On_Platform_Code
		From Acq_Deal_Rights_Holdback hb
		INNER JOIN #Avail_Raw ar On hb.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Platform hbp On hb.Acq_Deal_Rights_Holdback_Code = hbp.Acq_Deal_Rights_Holdback_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Territory hbt On hb.Acq_Deal_Rights_Holdback_Code = hbt.Acq_Deal_Rights_Holdback_Code
		INNER JOIN #TMP_MAIN tm On tm.Avail_Raw_Code = ar.Avail_Raw_Code AND tm.Platform_Code = hbp.Platform_Code AND tm.Country_Code = hbt.Country_Code
		Where (hb.Holdback_Type = 'D' And CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME) > hb.Holdback_Release_Date AND hb.Holdback_Release_Date > GETDATE()) Or hb.Holdback_Type = 'R'
		
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
		--Where tr.Release_Date > GETDATE()
		UNION
		Select Distinct tr.Title_Release_Code, trd.Country_Code 
		From Title_Release tr
		INNER JOIN #MainTit mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Region trr On tr.Title_Release_Code = trr.Title_Release_Code And Territory_Code Is Not Null
		INNER JOIN Territory_Details trd On trr.Territory_Code = trd.Territory_Code
		--Where tr.Release_Date > GETDATE()

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

		--Select * From #ReleaseCountry
		--Select * From #TMP_MAIN Where Country_Code = 31

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

		--Select * From #Temp_Avail_Languages

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
	FROM #TMP_MAIN t2

	--Select * From #TMP_MAIN

	--Select * From #TMP_MAIN Where Country_Cd_Str Is Null
	--Return

	--CREATE TABLE #Temp_Country_Names(
	--	Territory_Code INT,
	--	Country_Cd INT,
	--	Country_Codes VARCHAR(2000),
	--	Country_Names VARCHAR(MAX)
	--)
	
	--INSERT INTO #Temp_Country_Names(Country_Codes, Country_Names)
	--SELECT DISTINCT Country_Cd_Str, NULL FROM #TMP_MAIN
	
	--SELECT * FROM #Temp_Country_Names
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

	--Select * From #Temp_Country_Names

	--UPDATE #Temp_Country_Names SET Country_Names = [dbo].[UFN_Get_Territory](Country_Codes)
	
	--UPDATE tmc SET tmc.Territory_Code = ter.Territory_Code FROM Territory ter 
	--INNER JOIN #Temp_Country_Names tmc ON ter.Territory_Name COLLATE SQL_Latin1_General_CP1_CI_AS = tmc.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS AND ISNULL(tmc.Country_Names, '') <> ''

	--UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'T', tm.Country_Code = tmc.Territory_Code
	--FROM #TMP_MAIN tm 
	--INNER JOIN #Temp_Country_Names tmc ON tm.Country_Cd_Str = tmc.Country_Codes AND ISNULL(tmc.Country_Names, '') <> ''

	--TRUNCATE TABLE #Temp_Country_Names
	
	--INSERT INTO #Temp_Country_Names(Country_Cd)
	--SELECT DISTINCT Country_Code FROM #TMP_MAIN Where ISNULL(Country_Names, '') = ''
	
	--UPDATE tmc SET tmc.Country_Names = cur.Country_Name FROM Country cur
	--INNER JOIN #Temp_Country_Names tmc ON cur.Country_Code = tmc.Country_Cd

	--UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'C' FROM #TMP_MAIN tm 
	--INNER JOIN #Temp_Country_Names tmc ON tm.Country_Code = tmc.Country_Cd AND ISNULL(tm.Country_Names, '') = '' AND ISNULL(Region_Type, '') <> 'T' 
	
	PRINT 'STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
	---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS
	
	Create Table #Temp_Main_Ctr
	(
		Avail_Acq_Code Numeric(38,0),
		Avail_Raw_Code Numeric(38,0),
		Title_Code Int, 
		Platform_Code Int,
		Country_Code Int,
		Is_Title_Language bit, 
		Sub_Language_Code Varchar(2000),
		Dub_Language_code Varchar(2000),  
		Country_Cd_Str Varchar(2000),
		Cluster_Names Varchar(2000),
		Country_Names Varchar(Max),
		Region_Type Varchar(2000),
		Platform_Str Varchar(2000),
		Title_Language_Names Varchar(2000),
		Sub_Language_Names Varchar(4000),
		Dub_Language_Names Varchar(4000),
		Acq_Deal_Rights_Holdback_Code INT, 
		Holdback_Type		Char(1), 
		Holdback_Release_Date Date, 
		Holdback_On_Platform_Code Int
	)

	Insert InTo #Temp_Main_Ctr(Avail_Acq_Code, Avail_Raw_Code, Title_Code, Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
							   Country_Code, Country_Cd_Str, Cluster_Names, Country_Names, Region_Type, Platform_Str, Title_Language_Names, Sub_Language_Names, Dub_Language_Names,
							   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code)
	Select Avail_Acq_Code, Avail_Raw_Code, Title_Code, Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
		   b.Region_Code, Country_Cd_Str, b.Cluster_Names, b.Region_Name, Region_Type, '' Platform_Str, '' Title_Language_Names, '' Sub_Language_Names, '' Dub_Language_Names,
		   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code
	From (
		SELECT *
		FROM (
			SELECT ROW_NUMBER() OVER(
				PARTITION BY Avail_Acq_Code, Avail_Raw_Code, Title_Code, Platform_Code, Country_Code, Region_Type, 
							 Is_Title_Language, Sub_Language_Code, Dub_Language_code, Acq_Deal_Rights_Holdback_Code, Holdback_Release_Date
				ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type, Is_Title_Language, Sub_Language_Code, Dub_Language_code DESC
			) RowId, * 
			FROM #TMP_MAIN tm
		) AS a WHERE RowId = 1
	) As a 
	Inner Join #Tbl_Ret b On a.Group_No = b.Group_No
	
	---------- END

	DROP TABLE #TMP_MAIN
	
	END
	
	PRINT 'STEP-10- Platform Must Have / Exact Match ' + convert(varchar(30),getdate() ,109)
	--return
	BEGIN
	IF(UPPER(@Platform_ExactMatch) = 'EM' OR UPPER(@Platform_ExactMatch) = 'MH')
	BEGIN
		--Select 1

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

		--Select 
		--STUFF
		--(
		--	(
		--		SELECT DISTINCT ',' + CAST(Platform_Code As Varchar) FROM #Temp_Main_Ctr t1 
		--		WHERE t1.Title_Code = t2.Title_Code
		--		  AND ISNULL(t1.Country_Cd_Str, 0) = ISNULL(t2.Country_Cd_Str, 0)
		--		  AND t1.Region_Type = t2.Region_Type
		--		  AND t1.Avail_Raw_Code = t2.Avail_Raw_Code
		--		  AND t1.Is_Title_Language = t2.Is_Title_Language
		--		  AND IsNull(t1.Sub_Language_Code, 0) = IsNull(t2.Sub_Language_Code, 0)
		--		  AND IsNull(t1.Dub_Language_code, 0) = IsNull(t2.Dub_Language_code, 0)
		--		FOR XML PATH('')
		--	), 1, 1, ''
		--), *
		--FROM #Temp_Main_Ctr t2
	
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

			--Select Platform_Str, @PlStr, * From #Temp_Main_Ctr

			DELETE FROM #Temp_Main_Ctr WHERE IsNull(Platform_Str, '') <> @PlStr

			--UPDATE #Temp_Main_Ctr SET Platform_Code = 0
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
   	
	--Select * From #Temp_Main_Ctr
	
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
		Cluster_Names VARCHAR(1000),
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
		Episode_To INT
	)

	------------------ Final Output
	
	print 'STEP-13 DIGITAL REPORT ' + convert(varchar(30),getdate() ,109)	
	IF(@Is_Digital = 1)
	BEGIN
		
		print 'If'
		SET @strSQLNEO = 'Insert InTo #FINALAVAIlREPORT EXEC '+ @RU_DB +'.[dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail]
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
		
		--Set @strSQL = @strSQL + ' UNION SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		--Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Cluster_Names, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		--Sub_Language_Names, Dub_Language_Names, Genres_Name, Star_Cast, Director, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		--Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, ''No'' AS Sub_License, Platform_Avail FROM #FINALAVAIlREPORT'

		--Exec(@strSQL)
	END
	--ELSE
	--BEGIN

	--	print 'Else'
	--	EXEC (@strSQL)
	--	PRINT @strSQL
	--END
	------------------ END

	--Select * From #Temp_Main_Ctr
	--Select * From #Avail_Raw

	print 'STEP-15 Final query ' + convert(varchar(30),getdate() ,109)	
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN
	print 'ad'
		SELECT DISTINCT
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name,
			 tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS  AS Country_Name, Cluster_Names,
			 Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date
				THEN ar.Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			--CAST(AR.Start_Date AS DATETIME) Right_Start_Date,
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
			COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date--, pt1.Platform_Hiearachy As Holdback_On_Platform
		FROM
			#Temp_Main_Ctr tm
			INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
			--INNER JOIN #Avail_Dates AD On ar.Avail_Dates_Code = AD.Avail_Dates_Code
			INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
			INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
			LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
			LEFT JOIN #MainAH hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Cluster_Names, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Sub_Language_Names, Dub_Language_Names, Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail,
		'' COLLATE SQL_Latin1_General_CP1_CI_AS AS HoldbackOn , '' COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, '' COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date--, '' As Holdback_On_Platform
		FROM #FINALAVAIlREPORT

	END
	ELSE
	BEGIN
	print 'aa'
		SELECT DISTINCT
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name,
			tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS AS Country_Name, Cluster_Names,
			Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date
				THEN ar.Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			--CAST(ar.Start_Date AS DATETIME) Right_Start_Date, 
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
			COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date--, pt1.Platform_Hiearachy As Holdback_On_Platform
		FROM #Temp_Main_Ctr tm
		INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
		INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
		LEFT JOIN #MainAH hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Cluster_Names, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Sub_Language_Names, Dub_Language_Names, Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail,
		'' COLLATE SQL_Latin1_General_CP1_CI_AS  As HoldbackOn, '' COLLATE SQL_Latin1_General_CP1_CI_AS  AS Holdback_Type, 
		'' COLLATE SQL_Latin1_General_CP1_CI_AS  AS Holdback_Release_Date--, '' As Holdback_On_Platform
		FROM #FINALAVAIlREPORT

	END
	------------------ END

	
	print 'STEP-14 Final query ' + convert(varchar(30),getdate() ,109)	
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
END

/*
	EXEC [USP_Availability_Report_V3]
	@Title_Code ='0,676',
	@Platform_Code ='0',
	@Country_Code ='0',
	@Is_Original_Language ='true',
	@Title_Language_Code ='0',
	@Date_Type ='FL',
	@StartDate ='23-Sep-2015',
	@EndDate ='23-Sep-2020',
	@RestrictionRemarks ='false',
	@OthersRemarks ='false',--D
	@Platform_ExactMatch ='False', 
	@MustHave_Platform ='0', 
	@Exclusivity ='B' ,
	@SubLicense_Code ='0',
	@Region_ExactMatch ='false',
	@Region_MustHave ='0',
	@Region_Exclusion = '0',
	@Subtit_Language_Code ='0',
	@Dubbing_Subtitling='0',
	@Dubbing_Language_Code='0',
	@Bu_Code=1,
	@Is_Digital = 'false'

*/


--020-25503100 / 06 / 07

--170605196

--actssupprt@cdac.in

