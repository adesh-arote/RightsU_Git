--///////////////// FILE DB SCHEMA v5.0.3.1

--///////////////// FILE DB SCHEMA v5.0.3.2

/****** Object:  StoredProcedure [dbo].[USP_Show_Availability_Report_V3_IFTA]    Script Date: 03-02-2021 09:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[USP_Show_Availability_Report_V3_IFTA]
(

--DECLARE
	@Title_Code VARCHAR(MAX)='0', 
	@Is_Original_Language bit, 
	@Title_Language_Code VARCHAR(MAX),
	@Episode_From VARCHAR(20),
	@Episode_To VARCHAR(20),
	@Show_EpisodeWise CHAR(1)='N',
	
	@Date_Type VARCHAR(2),
	@Start_Date VARCHAR(20),
	@End_Date VARCHAR(20),
	
	@Platform_Group_Code varchar(max)= '',
	@Platform_Code VARCHAR(MAX)='0', 
    @Platform_ExactMatch VARCHAR(10), 
	@Platform_MustHave VARCHAR(MAX)='0', 
	
	@Is_IFTA_Cluster CHAR(1) = 'N', 
	@Territory_Code varchar(max) = null, 
	@Country_Code VARCHAR(MAX)='0', 
	@Region_ExactMatch VARCHAR(10),
	@Region_MustHave VARCHAR(MAX)='0',
	@Region_Exclusion VARCHAR(MAX)='0',
	
	@Dubbing_Subtitling VARCHAR(20),
	@Subtit_Language_Code VARCHAR(MAX)='0', 
	@Subtitling_Group_Code varchar(max) = null,  
	@Subtitling_ExactMatch char(10) = null,  
	@Subtitling_MustHave varchar(max) = null,  
	@Subtitling_Exclusion varchar(max) = null,  

	@Dubbing_Group_Code varchar(max) = null,  
	@Dubbing_ExactMatch char(10) = null,  
	@Dubbing_MustHave varchar(max) = null,  
	@Dubbing_Exclusion varchar(max) = null,  
	@Dubbing_Language_Code VARCHAR(MAX)='0', 
	
	@Restriction_Remarks VARCHAR(10),
	@Others_Remarks VARCHAR(10),
	@Exclusivity VARCHAR(1) ,   --B-Both, E-Exclusive,N-NonExclusive 
	@SubLicense_Code VARCHAR(MAX), --Comma   Separated SubLicensing Code. 0-No Sub Licensing ,
	@BU_Code VARCHAR(100),
	@Is_Digital bit = 'false',
	@Country_Level CHAR(1),
	@Territory_Level CHAR(1),
	@TabName CHAR(2),
	@Include_Ancillary CHAR(1)
)
AS
BEGIN
--select * from title where Title_Name like '%balika%'
--select 
--@Title_Code='584',
--	@Is_Original_Language='1',
--	@Title_Language_Code='',
--	@Episode_From='',
--	@Episode_To='',
--	@Show_EpisodeWise='N',
--	@Date_Type='FL',
--	@Start_Date='02-Feb-2021',
--	@End_Date='',
--	@Platform_Group_Code='',
--	@Platform_Code='',
--	@Platform_ExactMatch='',
--	@Platform_MustHave='0',
--	@Is_IFTA_Cluster='N',
--	@Territory_Code='',
--	@Country_Code='',
--	@Region_ExactMatch='',
--	@Region_MustHave='',
--	@Region_Exclusion='',
--	@Dubbing_Subtitling='',
--	@Subtit_Language_Code='',
--	@Subtitling_Group_Code='',
--	@Subtitling_ExactMatch='',
--	@Subtitling_MustHave='',
--	@Subtitling_Exclusion='',
--	@Dubbing_Group_Code='',
--	@Dubbing_ExactMatch='',
--	@Dubbing_MustHave='',
--	@Dubbing_Exclusion='',
--	@Dubbing_Language_Code='',
--	@Restriction_Remarks='False',
--	@Others_Remarks='False',
--	@Exclusivity='B',
--	@SubLicense_Code='',
--	@BU_Code='1',
--	@Is_Digital='0',
--	@Country_Level ='N',
--	@Territory_Level ='Y',
--	@TabName ='IF'

	Set @Episode_From = Case When IsNull(@Episode_From, 0) < 1 Then 1 Else @Episode_From End
	Set @Episode_To = Case When IsNull(@Episode_To, 0) < 1 Then 100000 Else @Episode_To End

	Set @Start_Date = Case When IsNull(@Start_Date, '') = '' Then REPLACE(CONVERT(VARCHAR,getdate()-1,106), ' ','') Else @Start_Date End
	Set @End_Date = Case When IsNull(@End_Date, '') = '' Then '31Mar9999' Else @End_Date End

--Create Table TestParam(
--	Params Varchar(Max)
--)
	
--	Insert InTo TestParam
--	Select '@Title_Code='''+ISNULL(@Title_Code, '')
--+''',@Is_Original_Language='''+ISNULL(Cast(@Is_Original_Language As Varchar), '')
--+''',@Title_Language_Code='''+ISNULL(@Title_Language_Code, '')
--+''',@Episode_From='''+ISNULL(@Episode_From, '')
--+''',@Episode_To='''+ISNULL(@Episode_To, '')
--+''',@Show_EpisodeWise='''+ISNULL(@Show_EpisodeWise, '')

--+''',@Date_Type='''+ISNULL(@Date_Type, '')
--+''',@Start_Date='''+ISNULL(@Start_Date, '')
--+''',@End_Date='''+ISNULL(@End_Date, '')

--+''',@Platform_Group_Code='''+ISNULL(@Platform_Group_Code, '')
--+''',@Platform_Code='''+ISNULL(@Platform_Code, '')
--+''',@Platform_ExactMatch='''+ISNULL(@Platform_ExactMatch, '')
--+''',@Platform_MustHave='''+ISNULL(@Platform_MustHave, '')

--+''',@Is_IFTA_Cluster='''+ISNULL(@Is_IFTA_Cluster, '')
--+''',@Territory_Code='''+ISNULL(@Territory_Code, '')
--+''',@Country_Code='''+ISNULL(@Country_Code, '')
--+''',@Region_ExactMatch='''+ISNULL(@Region_ExactMatch, '')
--+''',@Region_MustHave='''+ISNULL(@Region_MustHave, '')
--+''',@Region_Exclusion='''+ISNULL(@Region_Exclusion, '')

--+''',@Dubbing_Subtitling='''+ISNULL(@Dubbing_Subtitling, '')
--+''',@Subtit_Language_Code='''+ISNULL(@Subtit_Language_Code, '')
--+''',@Subtitling_Group_Code='''+ISNULL(@Subtitling_Group_Code, '')
--+''',@Subtitling_ExactMatch='''+ISNULL(@Subtitling_ExactMatch, '')
--+''',@Subtitling_MustHave='''+ISNULL(@Subtitling_MustHave, '')
--+''',@Subtitling_Exclusion='''+ISNULL(@Subtitling_Exclusion, '')

--+''',@Dubbing_Group_Code='''+ISNULL(@Dubbing_Group_Code, '')
--+''',@Dubbing_ExactMatch='''+ISNULL(@Dubbing_ExactMatch, '')
--+''',@Dubbing_MustHave='''+ISNULL(@Dubbing_MustHave, '')
--+''',@Dubbing_Exclusion='''+ISNULL(@Dubbing_Exclusion, '')
--+''',@Dubbing_Language_Code='''+ISNULL(@Dubbing_Language_Code, '')

--+''',@Restriction_Remarks='''+ISNULL(@Restriction_Remarks, '')
--+''',@Others_Remarks='''+ISNULL(@Others_Remarks, '')
--+''',@Exclusivity='''+ISNULL(@Exclusivity, '')
--+''',@SubLicense_Code='''+ISNULL(@SubLicense_Code, '')
--+''',@BU_Code='''+ISNULL(@BU_Code, '')
--+''',@Is_Digital='''+ISNULL(Cast(@Is_Digital AS varchar), '')


	-- SET NOCOUNT ON added to prevent extra result sets FROM
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	PRINT 'STEP-1 Filter Criteria      ' + convert(varchar(30),getdate() ,109)
	BEGIN

	IF(UPPER(@Restriction_Remarks) = 'TRUE')
		SET @Restriction_Remarks = 'Y'
	ELSE
		SET @Restriction_Remarks = 'N'

	IF(UPPER(@Others_Remarks) = 'TRUE')
		SET @Others_Remarks = 'Y'
	ELSE
		SET @Others_Remarks = 'N'

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

	SET @Subtitling_MustHave = LTRIM(RTRIM(@Subtitling_MustHave))
	SET @Dubbing_MustHave = LTRIM(RTRIM(@Dubbing_MustHave))

	INSERT INTO #Temp_Sub_Language(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Subtit_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	INSERT INTO #Temp_Dub_Language(Language_Code)
	SELECT REPLACE(number, 'L', '') FROM fn_Split_withdelemiter(@Dubbing_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	IF(@Subtitling_MustHave <> '')
	BEGIN

		INSERT INTO #Temp_Sub_MH(Language_Code)
		SELECT Cast(number as INT) FROM fn_Split_withdelemiter(@Subtitling_MustHave, ',') WHERE number NOT IN('0', '')

	END
	
	IF(@Dubbing_MustHave <> '')
	BEGIN
		
		INSERT INTO #Temp_Dub_MH(Language_Code)
		SELECT Cast(number as INT) FROM fn_Split_withdelemiter(@Dubbing_MustHave, ',') WHERE number NOT IN('0', '')
		
	END
	
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

	--Select * from #Temp_Avail_Languages
	
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

	IF NOT EXISTS(SELECT * FROM #Temp_Title)
	BEGIN
		INSERT INTO #Temp_Title
		SELECT DISTINCT Title_Code FROM Avail_Acq_Show
	END
	--IF NOT EXISTS(SELECT * FROM #Temp_Title_Language)
	--BEGIN
	--	INSERT INTO #Temp_Title_Language
	--	SELECT Language_Code FROM Language
	--END
		
	IF NOT EXISTS(SELECT * FROM #Temp_Platform)
	BEGIN
		INSERT INTO #Temp_Platform (number)
		SELECT Platform_Code FROM Platform WHERE Is_Last_Level = 'Y'
	END
	IF NOT EXISTS(SELECT * FROM #Tmp_SL)
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
		Avail_Acq_Show_Code INT, 
		Title_Code INT, 
		Platform_Code INT, 
		Country_Code INT
	)
		
	INSERT INTO #Avail_Acq(Avail_Acq_Show_Code, Title_Code, Platform_Code, Country_Code)
	SELECT DISTINCT AA.Avail_Acq_Show_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code
	FROM Avail_Acq_Show AA  
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
			Select Avail_Dates_Code, Start_Date, End_Date From Avail_Dates Where (ISNULL(Start_Date, '9999-12-31') <= @Start_Date AND ISNULL(End_Date, '9999-12-31') >= @End_Date)
		End
		Else
		Begin
			Insert InTo #Avail_Dates(Avail_Dates_Code, Start_Date, End_Date)
			Select Avail_Dates_Code, Start_Date, End_Date From Avail_Dates 
			Where (
				(ISNULL(Start_Date, '9999-12-31') BETWEEN @Start_Date AND  @End_Date)
				OR (ISNULL(End_Date, '9999-12-31') BETWEEN @Start_Date AND @End_Date)
				OR (@Start_Date BETWEEN  ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
				OR (@End_Date BETWEEN ISNULL(Start_Date, '9999-12-31') AND ISNULL(End_Date, '9999-12-31'))
			)
		End

		UPDATE #Avail_Dates SET Start_Date = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE Start_Date < GETDATE()

		--Select * From #Avail_Dates

		Select ar.Avail_Raw_Code, ar.Acq_Deal_Code, ar.Acq_Deal_Rights_Code, ar.Avail_Dates_Code, ar.Is_Exclusive, --ar.Episode_From, ar.Episode_To
		--Case When ar.Episode_From < @Episode_From Then @Episode_From Else ar.Episode_From End As Episode_From, 
		--Case When ar.Episode_To > @Episode_To Then @Episode_To Else ar.Episode_To End As Episode_To, 
		ar.Episode_From,
		ar.Episode_To,
		ad.Start_Date, ad.End_Date 
		InTo #Avail_Raw 
		From Avail_Raw ar 
		Inner Join #Avail_Dates ad On ar.Avail_Dates_Code = ad.Avail_Dates_Code
		Where (
			ar.Episode_From Between @Episode_From And @Episode_To Or
			ar.Episode_To Between @Episode_From And @Episode_To Or
			@Episode_From Between ar.Episode_From And ar.Episode_To Or
			@Episode_To Between ar.Episode_From And ar.Episode_To
		) 
		AND ar.Is_Exclusive IN (@Ex_YES, @Ex_NO)

		Drop Table #Avail_Dates
	END

	PRINT 'STEP-3 Populate @Temp_Right ' + convert(varchar(30),getdate() ,109)
	BEGIN

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
		Due_Diligence VARCHAR(10),
		Category_Name  VARCHAR(1000),
		Deal_Type_Name VARCHAR(1000)
	)

	IF(@Restriction_Remarks = 'Y' OR @Others_Remarks = 'Y' )
	Begin
		
		Insert InTo #Temp_Right_Remarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name,Due_Diligence,Category_Name,Deal_Type_Name)
		SELECT ar.Acq_Deal_Rights_Code, ar.Restriction_Remarks, 
			   ad.Remarks, ad.Rights_Remarks, 
			   (
					STUFF((SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
					FROM Acq_Deal AD_Tmp
					INNER JOIN Acq_Deal_Rights ADR_Tmp ON adr_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
					WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
					(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = ar.Acq_Deal_Code)
					FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,'')
				) As Sub_Deal_Restriction_Remark, 
		CASE WHEN ISNULL(sl.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END,ADM.Due_Diligence,C.Category_Name,DT.Deal_Type_Name
		FROM Acq_Deal_Rights ar
		INNER JOIN #Avail_Raw ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		Inner Join Acq_Deal ad On ar.Acq_Deal_Code = ad.Acq_Deal_Code
		INNER JOIN Acq_Deal_Movie ADM ON ad.Acq_Deal_Code = ADM.Acq_Deal_Code
		INNER JOin Category C ON ad.Category_Code = C.Category_Code
		INNER JOin Deal_Type DT ON ad.Deal_Type_Code = DT.Deal_Type_Code
		Inner Join Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code
		Inner Join #Tmp_SL tsl On tsl.SubLicense_Code = ar.Sub_License_Code And tsl.SubLicense_Code = sl.Sub_License_Code
		WHERE --ad.Is_Master_Deal = 'Y'
		--AND ar.Is_Tentative = 'N'
		--AND ar.Is_Sub_License = 'Y'
		--AND ar.Sub_License_Code IN (SELECT SubLicense_Code FROM #Tmp_SL)
		--AND 
		(ad.Business_Unit_Code IN (SELECT CAST(number as INT) from [dbo].[fn_Split_withdelemiter](@BU_Code,',')))
		--(ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0)   
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
		
		Insert InTo #Temp_Right_Remarks(Acq_Deal_Rights_Code, Restriction_Remarks, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Sub_License_Name,Due_Diligence,Category_Name,Deal_Type_Name)
		Select ar.Acq_Deal_Rights_Code, '', '', '', '', 
		CASE WHEN ISNULL(sl.Sub_License_Code, 0) = @Sub_License_Code_Avail  THEN 'Yes' ELSE sl.Sub_License_Name END,ADM.Due_Diligence,C.Category_Name,DT.Deal_Type_Name
		FROM Acq_Deal_Rights ar
		INNER JOIN #Avail_Raw ar1 On ar1.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		Inner Join Acq_Deal ad On ar.Acq_Deal_Code = ad.Acq_Deal_Code
		INNER JOIN Acq_Deal_Movie ADM ON ad.Acq_Deal_Code = ADM.Acq_Deal_Code
		INNER JOin Category C ON ad.Category_Code = C.Category_Code
		INNER JOin Deal_Type DT ON ad.Deal_Type_Code = DT.Deal_Type_Code
		Inner Join Sub_License sl On ar.Sub_License_Code = sl.Sub_License_Code
		Inner Join #Tmp_SL tsl On tsl.SubLicense_Code = ar.Sub_License_Code And tsl.SubLicense_Code = sl.Sub_License_Code
		WHERE --ad.Is_Master_Deal = 'Y'
		--AND ar.Is_Tentative = 'N'
		--AND ar.Is_Sub_License = 'Y'
		--AND ar.Sub_License_Code IN (SELECT SubLicense_Code FROM #Tmp_SL)
		--AND 
		(ad.Business_Unit_Code IN (SELECT CAST(number as INT) from [dbo].[fn_Split_withdelemiter](@BU_Code,',')))
		--(ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0)  
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
	
	CREATE INDEX IX_TMP_Avail_Acq ON #Avail_Acq(Avail_Acq_Show_Code)
	
	Create Table #TMP_MAIN(
		Title_Code			Int, 
		Platform_Code		Int, 
		Country_Code		Int,
		Avail_Acq_Show_Code numeric(38,0),
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

		Insert InTo #TMP_MAIN(Title_Code, Platform_Code, Country_Code, Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code)
		Select AA.Title_Code, AA.Platform_Code, AA.Country_Code, asd.Avail_Acq_Show_Code, asd.Avail_Raw_Code, Case When @Is_Original_Language = 1 Then asd.Is_Title_Language Else 0 End, asd.Sub_Language_Code, asd.Dub_Language_Code
		From #Avail_Acq AA
		Inner Join #TTL_Title ttl On aa.Title_Code = ttl.Title_Code
		Inner Join Avail_Acq_Show_Details asd On asd.Avail_Acq_Show_Code = AA.Avail_Acq_Show_Code
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
	
		Insert InTo #TMP_MAIN(Title_Code, Platform_Code, Country_Code, Avail_Acq_Show_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_Code)
		Select AA.Title_Code, AA.Platform_Code, AA.Country_Code, asd.Avail_Acq_Show_Code, asd.Avail_Raw_Code, Case When @Is_Original_Language = 1 Then asd.Is_Title_Language Else 0 End, asd.Sub_Language_Code, asd.Dub_Language_Code
		From #Avail_Acq AA
		Inner Join Avail_Acq_Show_Details asd On asd.Avail_Acq_Show_Code = AA.Avail_Acq_Show_Code
		Inner Join #Avail_Raw ar On ar.Avail_Raw_Code = asd.Avail_Raw_Code
		--Inner Join #Temp_Right_Remarks trr On trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
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

	--Return
	--Select * From #TMP_MAIN

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
		Where (hb.Holdback_Type = 'D' And CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATE) >= CAST(hb.Holdback_Release_Date AS DATE) AND CAST(hb.Holdback_Release_Date AS DATE) >= GETDATE()) Or hb.Holdback_Type = 'R'
		
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
	
		--UPDATE tm SET tm.Title_Language_Names = lang.Language_Name
		--FROM #Avail_TitLang tm 
		--INNER JOIN Language lang ON tm.Language_Code = lang.Language_Code

		UPDATE tm SET tm.Languages_Name = tml.Language_Names FROM #Temp_Avail_Languages tm 
		INNER JOIN #Temp_Language_Names tml ON tm.Languages_Code = tml.Language_Codes

		--Select * From #Temp_Avail_Languages
		--Select * From #Temp_Language_Names

	END
	
	PRINT 'STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
	BEGIN

	Create Table #TMP_MAIN_New(
		Title_Code			Int, 
		Platform_Code		Int,
		Avail_Raw_Code		numeric(38,0),
		Is_Title_Language	bit,
		Sub_Language_Code	numeric(38,0),
		Dub_Language_code	numeric(38,0),
		Country_Cd_Str		Varchar(3000)
	)

	INSERT INTO #TMP_MAIN_New(Title_Code, Platform_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code)
	SELECT DISTINCT Title_Code, Platform_Code, Avail_Raw_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code
	FROM #TMP_MAIN

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
			FOR XML PATH('')
		), 1, 1, ''
	)
	FROM #TMP_MAIN_New t2

	UPDATE t1 SET t1.Country_Cd_Str = t2.Country_Cd_Str
	FROM #TMP_MAIN_New t2
	INNER JOIN #TMP_MAIN t1 ON
		t1.Title_Code = t2.Title_Code
		AND t1.Platform_Code = t2.Platform_Code
		AND t1.Avail_Raw_Code = t2.Avail_Raw_Code
		AND t1.Is_Title_Language = t2.Is_Title_Language
		AND IsNull(t1.Sub_Language_Code, 0) = IsNull(t2.Sub_Language_Code, 0)
		AND IsNull(t1.Dub_Language_code, 0) = IsNull(t2.Dub_Language_code, 0)

		DROP TABLE #TMP_MAIN_New

	--UPDATE t2
	--SET t2.Country_Cd_Str =  STUFF
	--(
	--	(
	--		SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #TMP_MAIN t1 
	--		WHERE t1.Title_Code = t2.Title_Code
	--			  AND t1.Platform_Code = t2.Platform_Code
	--			  AND t1.Avail_Raw_Code = t2.Avail_Raw_Code
	--			  AND t1.Is_Title_Language = t2.Is_Title_Language
	--			  AND IsNull(t1.Sub_Language_Code, 0) = IsNull(t2.Sub_Language_Code, 0)
	--			  AND IsNull(t1.Dub_Language_code, 0) = IsNull(t2.Dub_Language_code, 0)
	--		FOR XML PATH('')
	--	), 1, 1, ''
	--)
	--FROM #TMP_MAIN t2

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
				
		DELETE TM 
		FROM 
		#Temp_Country_Names TM WHERE TM.Country_Codes NOT IN
		(SELECT DISTINCT 
			Country_Codes 
		FROM #Temp_Country_Names tm
		WHERE 
			(SELECT COUNT(number) 
			FROM dbo.fn_Split_withdelemiter(Country_Codes, ',') 
			WHERE number NOT IN ('', '0') 
			AND number IN (SELECT c.Country_Code FROM #Temp_Country c)) >= @Cntry_MustHaveCnt	
		)
		
		DELETE FROM #TMP_MAIN WHERE Country_Cd_Str NOT IN (SELECT Country_Codes FROM #Temp_Country_Names)
	END
	
	PRINT 'STEP-9.3- Country Names ' + convert(varchar(30),getdate() ,109)
	-----------------UPDATE Country / Territory Names

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

	Update a Set a.Group_No = b.RowId From #TMP_MAIN a 
		Inner Join #Temp_Country_Names b On a.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS = b.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 
	
		Create Table #Tbl_Ret (
			Region_Code Int,
			COL1 NVARCHAR(MAX),
			COL2 NVARCHAR(MAX),
			COL3 NVARCHAR(MAX),
			Group_No Int
		)

		Insert InTo #Tbl_Ret(Region_Code, COL1, COL2, COL3, Group_No)
		Select c.Region_Code, c.Cluster_Name, c.Region_Name, NULL, tc.RowId
		From #Temp_Country_Names tc
		Cross Apply DBO.UFN_Get_Report_Territory(tc.Country_Codes, tc.RowId) c

		--IF(@Country_Level = 'Y')
		--BEGIN	
		--	IF(@TabName = 'CO')
		--	BEGIN
		--		CREATE TABLE #tblCountries (
		--			RowId Int,
		--			Country_Codes Varchar(2000),
		--			Avail_Raw_Code INT,
		--			Acq_Rights_Code INT
		--		)

		--		INSERT INTO #tblCountries(RowId, Country_Codes, Avail_Raw_Code)
		--		SELECT DISTINCT b.RowId, b.Country_Codes, a.Avail_Raw_Code FROM #TMP_MAIN a
		--		INNER JOIN #Temp_Country_Names b ON a.Group_No = b.RowId

		--		--SELECT DISTINCT b.RowId, b.Country_Codes, a.Avail_Raw_Code 
		--		UPDATE a SET a.Acq_Rights_Code = b.Acq_Deal_Rights_Code
		--		FROM #tblCountries a
		--		INNER JOIN Avail_Raw b ON a.Avail_Raw_Code = b.Avail_Raw_Code

		--		Insert InTo #Tbl_Ret
		--		Select c.Region_Code, c.Region_Name_In, c.Region_Name_NOTIn, NULL, tc.RowId
		--		From #tblCountries tc
		--		Cross Apply DBO.UFN_Get_Report_Country(tc.Country_Codes, @Country_Code, tc.RowId, tc.Acq_Rights_Code) c
		--	END
		--	ELSE IF(@TabName = 'IF')
		--	BEGIN
		--		Insert InTo #Tbl_Ret
		--		Select c.Region_Code, c.Full_Cluster_Name, c.Partial_Cluster_Name, Region_Name, tc.RowId
		--		From #Temp_Country_Names tc
		--		Cross Apply DBO.UFN_Get_Report_Cluster_Territory(tc.Country_Codes, tc.RowId, @Territory_Code, @Is_IFTA_Cluster) c
		--	END
		--END
		--ELSE IF(@Territory_Level = 'Y')
		--BEGIN
		--	Insert InTo #Tbl_Ret
		--	Select c.Region_Code, c.Full_Cluster_Name, c.Partial_Cluster_Name, Region_Name, tc.RowId
		--	From #Temp_Country_Names tc
		--	Cross Apply DBO.UFN_Get_Report_Cluster_Territory(tc.Country_Codes, tc.RowId, @Territory_Code, @Is_IFTA_Cluster) c
		--END
		
	
	PRINT 'STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
	---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS

	Create Table #Temp_Main_Ctr
		(
			Avail_Raw_Code Numeric(38,0),
			Title_Code Int, 
			Platform_Code Int,
			Country_Code Int,
			Is_Title_Language bit, 
			Sub_Language_Code Varchar(2000),
			Dub_Language_code Varchar(2000),  
			Country_Cd_Str Varchar(2000),
			COL1 NVARCHAR(MAX),
			COL2 NVARCHAR(MAX),
			COL3 NVARCHAR(MAX),
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

		Insert InTo #Temp_Main_Ctr(Avail_Raw_Code, Title_Code, Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
								   Country_Code, Country_Cd_Str, COL1, COL2, COL3, Region_Type, Platform_Str, Title_Language_Names, Sub_Language_Names, Dub_Language_Names,
								   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code)
								   
		Select Distinct Avail_Raw_Code, Title_Code, Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
			   b.Region_Code, Country_Cd_Str, b.COL1, b.COL2, b.COL3, Region_Type, '' Platform_Str, '' Title_Language_Names, '' Sub_Language_Names, '' Dub_Language_Names,
			   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code
		From (
			SELECT *
			FROM (
				SELECT ROW_NUMBER() OVER(
					PARTITION BY  Avail_Raw_Code, Title_Code, Platform_Code, Country_Code, Region_Type, 
								 Is_Title_Language, Sub_Language_Code, Dub_Language_code
					ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type, Is_Title_Language, Sub_Language_Code, Dub_Language_code DESC
				) RowId, * 
				FROM #TMP_MAIN tm
			) AS a WHERE RowId = 1
		) As a 
		Inner Join #Tbl_Ret b On a.Group_No = b.Group_No

	--SELECT Avail_Acq_Show_Code, Avail_Raw_Code, Title_Code, Platform_Code, Is_Title_Language, Sub_Language_Code, Dub_Language_code, 
	--	   Country_Cd_Str, Country_Names, Region_Type, Cast('' As VARCHAR(2000)) As Platform_Str, Cast('' As VARCHAR(2000)) As Title_Language_Names,
	--	   Cast('' As VARCHAR(2000)) As Sub_Language_Names, Cast('' As VARCHAR(2000)) As Dub_Language_Names
	--INTO #Temp_Main_Ctr
	--FROM (
	--	SELECT ROW_NUMBER() OVER(
	--		PARTITION BY Avail_Acq_Show_Code, Avail_Raw_Code, Title_Code, Platform_Code, Country_Code, Region_Type, 
	--					 Is_Title_Language, Sub_Language_Code, Dub_Language_code
	--		ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type, Is_Title_Language, Sub_Language_Code, Dub_Language_code DESC
	--	) RowId, * 
	--	FROM #TMP_MAIN tm
	--) AS a WHERE RowId = 1
	
	---------- END

	DROP TABLE #TMP_MAIN
	
	END

	PRINT 'STEP-10- Platform Must Have / Exact Match ' + convert(varchar(30),getdate() ,109)
	BEGIN
	--IF(UPPER(@Platform_ExactMatch) = 'EM' OR UPPER(@Platform_ExactMatch) = 'MH')
	--BEGIN
	
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
				  -------- Conditions for  Holdback
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

			DELETE FROM #Temp_Main_Ctr WHERE Platform_Str <> @PlStr
			--UPDATE #Temp_Main_Ctr SET Platform_Code = 0
		END

		-----------------IF Platform = Must Have
		IF(UPPER(@Platform_ExactMatch) = 'MH')
		BEGIN
	
			TRUNCATE TABLE #Temp_Platform
			DECLARE @MustHaveCnt INT = 0

			INSERT INTO #Temp_Platform
			SELECT number FROM dbo.fn_Split_withdelemiter(@Platform_MustHave, ',') WHERE number NOT IN ('', '0')

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
		SELECT t.Title_Code, t.Title_Language_Code, t.Title_Name,
			Genres_Name = [dbo].[UFN_GetGenresForTitle](t.Title_Code),
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
		COL1 NVARCHAR(MAX),
		COL2 NVARCHAR(MAX),
		COL3 NVARCHAR(MAX), 
		--Country_Name VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS , 
		--Cluster_Names VARCHAR(1000),
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
		Restriction_Remark NVARCHAR(MAX), 
		Sub_Deal_Restriction_Remark NVARCHAR(MAX),
		Remarks NVARCHAR(MAX), 
		Rights_Remarks NVARCHAR(MAX), 
		Exclusive VARCHAR(20), 
		Sub_License VARCHAR(100), 
		Platform_Avail VARCHAR(3),
		Episode_From INT,
		Episode_To INT,
		HoldbackOn  NVARCHAR(MAX),
		Holdback_Type		Char(1), 
		Holdback_Release_Date Date, 
		Reverse_Holdback NVarchar(Max),
		Due_Diligence VARCHAR(10),
		Category_Name VARCHAR(1000),
		Deal_Type_Name VARCHAR(1000)
	)

	print 'STEP-12.01 REVERSE HOLDBACK ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		Select Distinct Title_Code , Cast('' As NVarchar(Max)) strRHB --Country_Cd_Str, Platform_Str, 
		InTo #TempRHB From #Temp_Main_Ctr
		Update #TempRHB Set strRHB = [dbo].[UFN_GET_SYNRHB](Title_Code)

		Update a Set a.Reverse_Holdback = b.strRHB 
		From #Temp_Main_Ctr a 
		Inner Join #TempRHB b On a.Title_Code = b.Title_Code --AND a.Country_Cd_Str = b.Country_Cd_Str AND a.Platform_Str = b.Platform_Str
	
		Drop Table #TempRHB

	END
	PRINT 'STEP-13 Ancillary Rights Data Population' + convert(varchar(30),getdate() ,109)
	BEGIN --------------- ANCILLARY

		Create table #Temp_Ancillary(
			Title_Code INT,
			Acq_Deal_Code INT,
			Ancillary_Rights NVARCHAR(MAX)
		)

		INSERT INTO #Temp_Ancillary (Acq_Deal_Code, Title_Code)
		SELECT AR.Acq_Deal_Code, a.Title_Code FROM (
			SELECT DISTINCT Avail_Raw_Code, Title_code FROM #Temp_Main_Ctr
		) AS a
		INNER JOIN Avail_Raw AR  ON a.Avail_Raw_Code = AR.Avail_Raw_Code

	
		--UPDATE #Temp_Ancillary SET Ancillary_Rights = DBO.UFN_Get_Report_Ancillary_Rights(Title_Code, Acq_Deal_Code)

		---End Ancillary Rights Data---

	END
	---------------- Final Output
	DECLARE @strSQLNEO AS VARCHAR(MAX)

	print 'STEP-13 DIGITAL REPORT ' + convert(varchar(30),getdate() ,109)	
	IF(@Is_Digital = 1)
	BEGIN
		
		print 'If'
		SET @strSQLNEO = 'Insert InTo #FINALAVAIlREPORT  EXEC '+ @RU_DB +'.[dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail]
		@Title_Code = '''+ @Title_Code +''',
		@Platform_Code = '''+ @Platform_Code +''',
		@Country_Code ='''+ @Country_Code+''',
		@Is_Original_Language ='''+ CASE WHEN @Is_Original_Language = 1 THEn 'true'ELSE 'false'END +''',
		@Title_Language_Code = '''+ @Title_Language_Code +''',
		@Date_Type = '''+ @Date_Type +''',
		@StartDate = '''+ @Start_Date +''',
		@EndDate = '''+ @End_Date +''',
		@RestrictionRemarks = '''+ CASE WHEN @Restriction_Remarks = 'Y' THEn 'true'ELSE 'false'END +''',
		@OthersRemarks = '''+ CASE WHEN @Others_Remarks = 'Y' THEn 'true'ELSE 'false'END +''',
		@Platform_ExactMatch = '''+ @Platform_ExactMatch +''',
		@MustHave_Platform = '''+ @Platform_MustHave +''',
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
		@Deal_Type_Code= ''13,22,11,32'' ,
		@Episode_From = '''+ @Episode_From +''',
		@Episode_To = '''+ @Episode_To +''''

		print @strSQLNEO
		EXEC (@strSQLNEO)
		print '2'
		
		--EXEC (@strSQL + ' UNION SELECT Title_Name,Episode_From, Episode_To,Platform_Name, Country_Name , Right_Start_Date ,Rights_End_Date ,Title_Language_Names , 
		--Sub_Language_Names, Dub_Language_Names, Genres_Name, Star_Cast, Director ,Duration_In_Min ,Year_Of_Production ,Restriction_Remark , 
		--Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, ''No'' AS Sub_License, Platform_Avail FROM #FINALAVAIlREPORT')

		--print @strSQL + ' UNION SELECT Title_Name,Episode_From, Episode_To, Platform_Name, Country_Name , Right_Start_Date ,Rights_End_Date ,Title_Language_Names , 
		--Sub_Language_Names, Dub_Language_Names, Genres_Name, Star_Cast, Director ,Duration_In_Min ,Year_Of_Production ,Restriction_Remark , 
		--Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, ''No'' AS Sub_License, Platform_Avail FROM #FINALAVAIlREPORT'

	END
	ELSE
	BEGIN

		print 'Else'
		EXEC (@strSQL)
		PRINT @strSQL
	END
	------------------ END
	print 'STEP-14 Final query ' + convert(varchar(30),getdate() ,109)	
	IF(@Restriction_Remarks = 'Y' OR @Others_Remarks = 'Y' )
	BEGIN
	print 'ad'
	--SET @strSQL =
		SELECT DISTINCT 
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			Case When ar.Episode_From < @Episode_From Then @Episode_From Else ar.Episode_From End As Episode_From, 
			Case When ar.Episode_To > @Episode_To Then @Episode_To Else ar.Episode_To End As Episode_To, 
			--ar.Episode_From, 
			--ar.Episode_To, 
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name, 
			-- tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS  AS Country_Name, Cluster_Names,
			COL1, COL2, COL3,
			--CAST(AR.Start_Date AS DATETIME) Right_Start_Date, 
			Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date
				THEN ar.Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			CAST(ISNULL(AR.End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Case When tm.Is_Title_Language = 1 Then trt.Language_Name Else '' End COLLATE SQL_Latin1_General_CP1_CI_AS  Title_Language_Names, 
			Sub_Language_Names, Dub_Language_Names, trt.Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS Genres_Name, trt.Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS Star_Cast, 
			trt.Director COLLATE SQL_Latin1_General_CP1_CI_AS Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark,
			trr.Remarks, trr.Rights_Remarks, CASE WHEN ar.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, 
			trr.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail,
			CASE WHEN ISNULL(pt1.Platform_Hiearachy,'') = '' OR ar.Start_Date > tm.Holdback_Release_Date THEN '' ELSE hb.HBComments + pt1.Platform_Hiearachy END COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn, 
			tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, 
			CASE 
				WHEN ISNULL(CONVERT(varchar(50), Holdback_Release_Date ),'') = '' OR ar.Start_Date > Holdback_Release_Date 
					THEN '' 
				ELSE CONVERT(VARCHAR(20), Holdback_Release_Date, 103) END 
			COLLATE SQL_Latin1_General_CP1_CI_AS AS  Holdback_Release_Date, --, pt1.Platform_Hiearachy As Holdback_On_Platform
			Reverse_Holdback COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback,'' AS Ancillary_Rights,trr.Due_Diligence,trr.Category_Name,trr.Deal_Type_Name
		FROM 
			#Temp_Main_Ctr tm
			INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
			INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
			INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
			--INNER JOIN #Temp_Ancillary TA ON trt.Title_Code = TA.Title_Code AND tm.Title_Code = TA.Title_Code AND ar.Acq_Deal_Code = TA.Acq_Deal_Code
			INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
			LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
			LEFT JOIN #MainAH hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Episode_From, Episode_To, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		COL1, COL2, COL3, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Sub_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, Dub_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail,
		HoldbackOn AS HoldbackOn , Holdback_Type AS Holdback_Type, ISNULL(REPLACE(CONVERT(varchar(15), Holdback_Release_Date, 106),' ','/'),'')  AS Holdback_Release_Date,--, '' As Holdback_On_Platform
		Reverse_Holdback AS Reverse_Holdback,'' AS Ancillary_Rights,Due_Diligence,Category_Name,Deal_Type_Name
		FROM #FINALAVAIlREPORT
	END
	ELSE
	BEGIN
		
		SELECT DISTINCT 
			trt.Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS Title_Name,
			Case When ar.Episode_From < @Episode_From Then @Episode_From Else ar.Episode_From End As Episode_From, 
			Case When ar.Episode_To > @Episode_To Then @Episode_To Else ar.Episode_To End As Episode_To, 
			--ar.Episode_From, 
			--ar.Episode_To, 
			pt.Platform_Hiearachy COLLATE SQL_Latin1_General_CP1_CI_AS  AS Platform_Name, 
			--tm.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS AS Country_Name, Cluster_Names, 
			COL1, COL2, COL3,
			--CAST(ar.Start_Date AS DATETIME) Right_Start_Date, 
			Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR ar.Start_Date > tm.Holdback_Release_Date
				THEN ar.Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			CAST(ISNULL(ar.End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Case When tm.Is_Title_Language = 1 Then trt.Language_Name Else '' End COLLATE SQL_Latin1_General_CP1_CI_AS    Title_Language_Names , 
			Sub_Language_Names, Dub_Language_Names, trt.Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS Genres_Name, trt.Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS Star_Cast, 
			trt.Director COLLATE SQL_Latin1_General_CP1_CI_AS Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			'' Restriction_Remark, '' Sub_Deal_Restriction_Remark,
			'' Remarks, '' Rights_Remarks, CASE WHEN ar.Is_Exclusive = 1 THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, 
			trr.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail,
			CASE WHEN ISNULL(pt1.Platform_Hiearachy,'') = '' OR ar.Start_Date > tm.Holdback_Release_Date THEN '' ELSE hb.HBComments + pt1.Platform_Hiearachy END 
			COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn
			, tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS  AS Holdback_Type, 
				CASE 
				WHEN ISNULL(CONVERT(varchar(50), Holdback_Release_Date ),'') = '' OR ar.Start_Date > Holdback_Release_Date 
					THEN '' 
				ELSE CONVERT(VARCHAR(20), Holdback_Release_Date, 103) END COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Release_Date
			, --, pt1.Platform_Hiearachy As Holdback_On_Platform
			Reverse_Holdback COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback,'' AS Ancillary_Rights,trr.Due_Diligence,trr.Category_Name,trr.Deal_Type_Name
		FROM #Temp_Main_Ctr tm
		INNER JOIN #Avail_Raw ar On tm.Avail_Raw_Code = ar.Avail_Raw_Code
		INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
		INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
		--INNER JOIN #Temp_Ancillary TA ON trt.Title_Code = TA.Title_Code AND tm.Title_Code = TA.Title_Code AND ar.Acq_Deal_Code = TA.Acq_Deal_Code
		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
		LEFT JOIN #MainAH hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
		UNION 
		SELECT Title_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Episode_From, Episode_To, Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS, 
		COL1, COL2, COL3, Right_Start_Date, Rights_End_Date, Title_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Sub_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, Dub_Language_Names COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Genres_Name COLLATE SQL_Latin1_General_CP1_CI_AS, Star_Cast COLLATE SQL_Latin1_General_CP1_CI_AS, 
		Director COLLATE SQL_Latin1_General_CP1_CI_AS, Duration_In_Min, Year_Of_Production, Restriction_Remark, 
		Sub_Deal_Restriction_Remark, Remarks, Rights_Remarks, Exclusive, 'No' AS Sub_License, Platform_Avail,
		HoldbackOn AS HoldbackOn , Holdback_Type AS Holdback_Type,  ISNULL(REPLACE(CONVERT(varchar(15), Holdback_Release_Date, 106),' ','/'),'')  AS Holdback_Release_Date,--, '' As Holdback_On_Platform
		Reverse_Holdback AS Reverse_Holdback,  '' AS Ancillary_Rights,Due_Diligence,Category_Name,Deal_Type_Name
		FROM #FINALAVAIlREPORT
	END
	------------------ END


	print 'STEP-14 Final query ' + convert(varchar(30),getdate() ,109)	
	--DROP TABLE #Temp_Country_Names
	DROP TABLE #Avail_Raw
	DROP TABLE #Temp_Title
	DROP TABLE #Temp_Main_Ctr
	DROP TABLE #Temp_Titles
	--DROP TABLE #Temp_Right
	DROP TABLE #Temp_Country
	DROP TABLE #Temp_Platform
	DROP TABLE #Temp_Title_Language
	DROP TABLE #Avail_Acq
	DROP TABLE #Temp_Sub_MH
	DROP TABLE #Temp_Dub_MH
	DROP TABLE #Tbl_Ret
	DROP Table #Temp_Ancillary	
	DROP TABLE #Temp_Sub_Language
	DROP TABLE #Temp_Dub_Language
	DROP TABLE #Tmp_SL
	DROP TABLE #Temp_Avail_Languages
	DROP TABLE #Temp_Right_Remarks
	DROP TABLE #FINALAVAIlREPORT
	DROP TABLE #MainAH
	--DROP TABLE #TMP_MAIN
	--DROP TABLE #Temp_title	
	--DROP TABLE #TMP_MAIN_new
	--DROP TABLE #Temp_Language_Names
	--DROP TABLE #Temp_Country_Names
	--DROP TABLE #Temp_Dub_Language
END

/*
	Exec [USP_Show_Availability_Report_V3]
	@Title_Code='5399',
	@Is_Original_Language='1',
	@Title_Language_Code='',
	@Episode_From='1',
	@Episode_To='100000',
	@Show_EpisodeWise='N',
	@Date_Type='FL',
	@Start_Date='2018-10-01',
	@End_Date='',
	@Platform_Group_Code='',
	@Platform_Code='0,0,0,60,258,61,62,259,63,64,65,66,67,69,0,71,72,73,0,262,263,75,76,0,145,146,265,78,79,147,152,154,0,0,38,256,39,40,257,41,42,43,44,45,47,0,49,50,51,0,260,261,53,54,0,149,150,264,56,57,151,155,157,0,0,268,269,270,271,272,273,274,275,276,277,278,0,280,281,282,0,284,285,286,287,0,291,292,293,288,289,294,295,296,0,0,299,300,301,302,303,304,305,306,307,308,309,0,311,312,313,0,315,316,317,318,0,322,323,324,319,320,325,326,327',
	@Platform_ExactMatch='',
	@Platform_MustHave='0',
	@Is_IFTA_Cluster='N',
	@Territory_Code='',
	@Country_Code='',
	@Region_ExactMatch='',
	@Region_MustHave='',
	@Region_Exclusion='',
	@Dubbing_Subtitling='D',
	@Subtit_Language_Code='',
	@Subtitling_Group_Code='',
	@Subtitling_ExactMatch='',
	@Subtitling_MustHave='',
	@Subtitling_Exclusion='',
	@Dubbing_Group_Code='',
	@Dubbing_ExactMatch='',
	@Dubbing_MustHave='',
	@Dubbing_Exclusion='',
	@Dubbing_Language_Code='0,24,135,25,5,26,27,28,29,11,30,31,32,33,34,35,134,36,37,38,39,41,42,43,44,140,45,46,47,137,6,48,16,49,50,130,51,52,53,54,55,56,57,58,59,60,1,61,62,63,64,66,67,68,69,21,70,71,72,73,74,75,76,77,78,131,136,79,80,10,81,139,82,83,84,85,86,87,88,133,89,90,91,92,93,94,95,15,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,132,12,118,119,120,121,20,122,123,124,125,126,127,128,129',
	@Restriction_Remarks='True',
	@Others_Remarks='False',
	@Exclusivity='B',
	@SubLicense_Code='',
	@BU_Code='8',
	@Is_Digital='1'

*/


GO
/****** Object:  UserDefinedFunction [dbo].[UFN_Get_Platform_With_Parent]    Script Date: 03-02-2021 09:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UFN_Get_Platform_With_Parent]
(
	@PFCodes as varchar(2000)	
)
Returns @TempPF Table(
		Platform_Code Int,
		Parent_Platform_Code Int,
		Base_Platform_Code Int,
		Is_Display Varchar(2),
		Is_Last_Level Varchar(2),
		TempCnt Int,
		TableCnt Int,
		Platform_Hiearachy NVARCHAR(1000),
		Platform_Count Int
	)
AS
-- =============================================
-- Author:		Pavitar Dua/Adesh Arote
-- Create DATE: 31-October-2014
-- Description:	INLINE TABLE VALUED FUNC TO GROUP PLATFORM
-- =============================================
BEGIN

	Declare @TempPFParent As Table(
		Parent_Platform_Code Int,
		IsUse Varchar(1)
	)

	Insert InTo @TempPF
	Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'Y', Is_Last_Level, 0, 0, Platform_Hiearachy, 0
	From [Platform] Where platform_code in (Select number From DBO.fn_Split_withdelemiter(IsNull(@PFCodes, ''), ',')) order by platform_name 

	Insert InTo @TempPFParent
	Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From @TempPF
	
	Insert InTo @TempPF
	Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0, Platform_Hiearachy, 0
	From [Platform] p 
	Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent) order by platform_name 
	
	DECLARE CUR_UPDATE_GRP CURSOR
	READ_ONLY
	FOR 
	WITH ABC AS(			
			SELECT 
			(Select Count(*) From @TempPF B Where B.Parent_Platform_Code = A.Platform_Code And Is_Display = 'Y') AS TempCnt,
			(Select Count(*) From [Platform] C Where C.Parent_Platform_Code = A.Platform_Code) AS TableCnt,
			A.Platform_Code Platform_Code			
			FROM @TempPF A
	)
	SELECT DISTINCT Platform_Code,TempCnt,TableCnt FROM ABC

	DECLARE @Platform_Code_CUR INT, @TempCnt_CUR INT, @TableCnt_CUR INT
	OPEN CUR_UPDATE_GRP

	FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
	WHILE (@@fetch_status <> -1)
	BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
					UPDATE @TempPF SET TempCnt=@TempCnt_CUR,TableCnt=@TableCnt_CUR
					WHERE Platform_Code=@Platform_Code_CUR
			END
			FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
	END

	CLOSE CUR_UPDATE_GRP
	DEALLOCATE CUR_UPDATE_GRP
	
	Update @TempPF Set Is_Display = 'U' Where Parent_Platform_Code In (
		Select platform_code From @TempPF Where TempCnt = TableCnt
	) 
	And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent)
	
	Update @TempPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'--And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent)

	While((Select COUNT(*) From @TempPFParent Where ISNULL(Parent_Platform_Code, 0) > 0) > 0)
	Begin
		Update @TempPFParent Set IsUse = 'Y'
		-- select 'a'
		Insert InTo @TempPFParent
		Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From [Platform]
		Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent) --order by platform_name 
		
		Delete From @TempPFParent Where IsUse = 'Y'
		
		Insert InTo @TempPF
		Select platform_code, ISNULL(Parent_Platform_Code, 0),ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0, Platform_Hiearachy, 0
		From [Platform] p
		Where platform_code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent) And 
			  platform_code not in (Select platform_code From @TempPF) order by platform_name ;
	
	
		DECLARE CUR_UPDATE_GRP CURSOR
		READ_ONLY
		FOR 
		WITH ABC AS(			
				SELECT 
				(Select Count(*) From @TempPF B Where B.Parent_Platform_Code = A.Platform_Code And Is_Display = 'Y') AS TempCnt,
				(Select Count(*) From [Platform] C Where C.Parent_Platform_Code = A.Platform_Code) AS TableCnt,
				A.Platform_Code Platform_Code			
				FROM @TempPF A
		)
		SELECT DISTINCT Platform_Code,TempCnt,TableCnt FROM ABC
		
		OPEN CUR_UPDATE_GRP

		FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
		WHILE (@@fetch_status <> -1)
		BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
						UPDATE @TempPF SET TempCnt=@TempCnt_CUR,TableCnt=@TableCnt_CUR
						WHERE Platform_Code=@Platform_Code_CUR
				END
				FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
		END

		CLOSE CUR_UPDATE_GRP
		DEALLOCATE CUR_UPDATE_GRP
	
		Update @TempPF Set Is_Display = 'U' Where Parent_Platform_Code In (
			Select platform_code From @TempPF Where TempCnt = TableCnt
		) And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent)
		
		Update @TempPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'
		
	End
	 
	DELETE FROM @TempPF Where Is_Display <> 'Y'
	
	Declare @RowCnt Int = 0
	Select @RowCnt = Count(*) From @TempPF
	
	Update @TempPF Set Platform_Count = @RowCnt
	--SELECT * FROM @TempPF where Is_Display='Y'
	RETURN
END
/*


SELECT Platform_Hiearachy,*
FROM Platform where 1=1 AND IS_LAST_LEVEL='Y' --Platform_Hiearachy like '%non sta%'

DECLARE @PFCodes as varchar(2000)='0'
	
SELECT @PFCodes = @PFCodes + ',' + CAST( platform_Code as varchar)
FROM Platform where 1=1 AND IS_LAST_LEVEL='Y' --Platform_Hiearachy like '%non sta%'

SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](@PFCodes)

EXEC USP_Get_Platform_With_Parent '117,118,119,120,121,122,126,127,128,129,130,131,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213'

SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent]('117,118,119,120,121,122,126,127,128,129,130,131,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213')
*/


GO
/****** Object:  UserDefinedFunction [dbo].[UFN_GET_SYNRHB]    Script Date: 03-02-2021 09:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UFN_GET_SYNRHB]
(
	@Title_Code Int
)
RETURNS NVarchar(Max)
As
Begin
	--Declare @Title_Code Int = '1124'--, @Platform_Str Varchar(1000) = '1,10,117,118,120,124,125,127,130,131,132,133,137,138,146,16,160,17,18,182,184,191,2,200,205,210,218,229,23,230,231,248,249,256,258,264,3,31,36,38,4,5,53,6,62,65,8', @Region_Str Varchar(1000) = '170,180,209,210,394'

	Declare @TblSynRights Table(
		Syn_Deal_Rights_Code Int,
		Country_Name NVarchar(Max),
		Platform_Codes Varchar(Max),
		Platform_Name NVarchar(Max),
		Milestone_Type_Code Int,
		Milestone_Unit_Type Int,
		Milestone_No_Of_Unit Int
	)

	Declare @TblSynRightsRgn Table(
		Syn_Deal_Rights_Code Int,
		Country_Name NVarchar(Max)
	)

	Declare @TblSynRightsPlt Table(
		Syn_Deal_Rights_Code Int,
		Platform_Code Int
	)

	Insert InTo @TblSynRights(Syn_Deal_Rights_Code, Milestone_Type_Code, Milestone_Unit_Type, Milestone_No_Of_Unit)
	Select Distinct sdr.Syn_Deal_Rights_Code, Milestone_Type_Code, Milestone_Unit_Type, Milestone_No_Of_Unit From Syn_Deal_Rights sdr
	Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code AND sdrt.Title_Code = @Title_Code And 
	Is_Pushback = 'Y' AND Right_Type = 'M' AND Actual_Right_Start_Date IS NULL
	
	Insert InTo @TblSynRightsRgn(Syn_Deal_Rights_Code, Country_Name)
	Select Distinct sdr.Syn_Deal_Rights_Code, td.Territory_Name From @TblSynRights sdr
	Inner Join Syn_Deal_Rights_Territory sdrtt On sdr.Syn_Deal_Rights_Code = sdrtt.Syn_Deal_Rights_Code AND sdrtt.Territory_Type <> 'I'
	Inner Join Territory td On sdrtt.Territory_Code = td.Territory_Code
	UNION
	Select Distinct sdr.Syn_Deal_Rights_Code, c.Country_Name From @TblSynRights sdr
	Inner Join Syn_Deal_Rights_Territory sdrtt On sdr.Syn_Deal_Rights_Code = sdrtt.Syn_Deal_Rights_Code AND sdrtt.Territory_Type = 'I'
	Inner Join Country c On sdrtt.Country_Code = c.Country_Code

	Insert InTo @TblSynRightsPlt(Syn_Deal_Rights_Code, Platform_Code)
	Select Distinct sdr.Syn_Deal_Rights_Code, Platform_Code From @TblSynRights sdr
	Inner Join Syn_Deal_Rights_Platform sdrp On sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code


	Update b Set b.Country_Name = 
	STUFF
	(
		(
			SELECT DISTINCT ', ' + CAST(Country_Name As Varchar(Max)) FROM @TblSynRightsRgn a Where b.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			FOR XML PATH('')
		), 1, 1, ''
	)
	From @TblSynRights b

	Update b Set b.Platform_Codes = 
	STUFF
	(
		(
			SELECT DISTINCT ', ' + CAST(a.Platform_Code As Varchar(Max)) FROM @TblSynRightsPlt a Where b.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			FOR XML PATH('')
		), 1, 1, ''
	)
	From @TblSynRights b
	
	Update b Set b.Platform_Name = 
	STUFF
	(
		(
			SELECT DISTINCT ', ' + CAST(Platform_Hiearachy As NVarchar(Max)) FROM DBO.[UFN_Get_Platform_With_Parent](b.Platform_Codes)
			FOR XML PATH('')
		), 1, 1, ''
	)
	From @TblSynRights b
	Declare @term NVarchar(Max) = ''
	Select @term = 
	STUFF
	(
		(
			Select '' + StrRHB From (
				Select sdr.Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS + ' - ' + sdr.Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS + ' - from ' + mt.Milestone_Type_Name COLLATE SQL_Latin1_General_CP1_CI_AS 
						+ ' to: ' + Cast(sdr.Milestone_No_Of_Unit as Varchar(4)) COLLATE SQL_Latin1_General_CP1_CI_AS +
						Case sdr.Milestone_Unit_Type When 1 Then ' Days' When 2 Then ' Weeks' When 3 Then ' Months' When 4 Then ' Years' End + ';' COLLATE SQL_Latin1_General_CP1_CI_AS As StrRHB
				From @TblSynRights sdr
				Inner Join Milestone_Type mt On sdr.Milestone_Type_Code = mt.Milestone_Type_Code
			) AS a 
			FOR XML PATH('')
		), 1, 1, ''
	)

	--Delete From @TblSynRightsRgn Where Syn_Deal_Rights_Code Not In (
	--	Select Syn_Deal_Rights_Code From @TblSynRightsPlt
	--)

	--Delete From @TblSynRightsPlt Where Syn_Deal_Rights_Code Not In (
	--	Select Syn_Deal_Rights_Code From @TblSynRightsRgn
	--)

	--Update rg Set rg.Country_Name = c.Country_Name From @TblSynRightsRgn rg
	--Inner Join Country c On rg.Country_Code = c.Country_Code 

	--Update rp Set rp.Platform_Name = p.Platform_Hiearachy From @TblSynRightsPlt rp
	--Inner Join Platform p On rp.Platform_Code = p.Platform_Code

	--Declare @term NVarchar(Max) = ''
	--Select @term = 
	--	STUFF
	--	(
	--		(
	--			Select '' + StrRHB From (
	--				Select 
	--					STUFF
	--					(
	--						(
	--							SELECT DISTINCT ', ' + CAST(Country_Name As NVarchar(Max)) FROM @TblSynRightsRgn a Where sdr.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
	--							FOR XML PATH('')
	--						), 1, 1, ''
	--					) + ' - ' +
	--					STUFF
	--					(
	--						(
	--							SELECT DISTINCT ', ' + CAST(Platform_Name As Varchar(Max)) FROM @TblSynRightsPlt a Where sdr.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
	--							FOR XML PATH('')
	--						), 1, 1, ''
	--					) + ' - from ' + mt.Milestone_Type_Name + ' to: ' + Cast(sdr.Milestone_No_Of_Unit as Varchar(4)) +
	--					Case sdr.Milestone_Unit_Type When 1 Then ' Days' When 2 Then ' Weeks' When 3 Then ' Months' When 4 Then ' Years' End + ';' As StrRHB
	--				From (Select Distinct Syn_Deal_Rights_Code From @TblSynRightsRgn) rg
	--				Inner Join Syn_Deal_Rights sdr On sdr.Syn_Deal_Rights_Code = rg.Syn_Deal_Rights_Code
	--				Inner Join Milestone_Type mt On sdr.Milestone_Type_Code = mt.Milestone_Type_Code
	--			) AS a 
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	)


	RETURN ISNULL(@term, '')
END

/*

Select DBO.[UFN_GET_SYNRHB](1124)

*/

GO

