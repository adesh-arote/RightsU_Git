CREATE PROCEDURE [dbo].[USP_Report_PlatformWise_Syndication_Neo]
(
	@Title_Code VARCHAR(MAX) = '0', 
	@Platform_Code VARCHAR(MAX) = '0', 
    @Country_Code VARCHAR(MAX) = '0', 
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
	@Region_MustHave VARCHAR(MAX) = '0',
	@Region_Exclusion VARCHAR(MAX) = '0',
	@Subtit_Language_Code VARCHAR(MAX) = '0', 
	@Dubbing_Language_Code VARCHAR(MAX) = '0', 
	@Dubbing_Subtitling VARCHAR(20),
	@BU_Code VARCHAR(20),
	@Is_SubLicense VARCHAR(1) = 'N',
	@Is_Approved  VARCHAR(1) = 'A',
	@Episode_From INT=1,
	@Episode_To INT=1
)
AS
-- =============================================
-- Author :	RESHMA KUNJAL
-- Create date: 08 MARCH 2016
-- Description:	This Procedure is to generate Platform wise Syndication data With "Availability Report" paramters and @Is_SubLicense parameter
-- And Deals which are Approved
-- =============================================
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets FROM interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	--DECLARE
	--@Title_Code VARCHAR(MAX) = '0,4548', 
	--@Platform_Code VARCHAR(MAX) = '', 
 --   @Country_Code VARCHAR(MAX) = '0', 
	--@Is_Original_Language bit = 'True', 
	--@Title_Language_Code VARCHAR(MAX) = '0',
	--@Date_Type VARCHAR(2) = 'FL',
	--@StartDate VARCHAR(20) = '23-Mar-2016',
	--@EndDate VARCHAR(20) = '31-Dec-9999',
	--@StartMonth VARCHAR(20) = '0',
	--@EndYear VARCHAR(20) = '0',
	--@RestrictionRemarks VARCHAR(10) = 'True',
	--@OthersRemarks VARCHAR(10) = 'False',
	--@Platform_ExactMatch VARCHAR(10) = 'False', 
	--@MustHave_Platform VARCHAR(MAX)='0', 
	--@Exclusivity VARCHAR(1) = 'B',
	--@SubLicense_Code VARCHAR(MAX) = '0',
	--@Region_ExactMatch VARCHAR(10) = 'False',
	--@Region_MustHave VARCHAR(MAX) = '0',
	--@Region_Exclusion VARCHAR(MAX) = '0',
	--@Subtit_Language_Code VARCHAR(MAX) = '0,L26,L28', 
	--@Dubbing_Language_Code VARCHAR(MAX) = '0,L26,L28', 
	--@Dubbing_Subtitling VARCHAR(20) = 'S,D',
	--@BU_Code VARCHAR(20) = '8',
	--@Is_SubLicense VARCHAR(1) = '',
	--@Is_Approved  VARCHAR(1) = 'A',
	--@Episode_From INT='',
	--@Episode_To INT=''
		
	IF(OBJECT_ID('TEMPDB..#Temp_Title') IS NOT NULL)
		DROP TABLE #Temp_Title
	IF(OBJECT_ID('TEMPDB..#Temp_Main_Ctr') IS NOT NULL)
		DROP TABLE #Temp_Main_Ctr
	IF(OBJECT_ID('TEMPDB..#Temp_Rights_Data') IS NOT NULL)
		DROP TABLE #Temp_Rights_Data
	IF(OBJECT_ID('TEMPDB..#Temp_Titles') IS NOT NULL)
		DROP TABLE #Temp_Titles
	IF(OBJECT_ID('TEMPDB..#Temp_Right') IS NOT NULL)
		DROP TABLE #Temp_Right
	IF(OBJECT_ID('TEMPDB..#Temp_Country') IS NOT NULL)
		DROP TABLE #Temp_Country
	IF(OBJECT_ID('TEMPDB..#Temp_Platform') IS NOT NULL)
		DROP TABLE #Temp_Platform
	IF(OBJECT_ID('TEMPDB..#Temp_Title_Language') IS NOT NULL)
		DROP TABLE #Temp_Title_Language
	IF(OBJECT_ID('TEMPDB..#Temp_Language') IS NOT NULL)
		DROP TABLE #Temp_Language
	IF(OBJECT_ID('TEMPDB..#Avail_Syn') IS NOT NULL)
		DROP TABLE #Avail_Syn
	IF(OBJECT_ID('TEMPDB..#Avail_TitLang') IS NOT NULL)
		DROP TABLE #Avail_TitLang

	IF(OBJECT_ID('TEMPDB..#Avail_Sub') IS NOT NULL)
		DROP TABLE #Avail_Sub
	IF(OBJECT_ID('TEMPDB..#Avail_Dubb') IS NOT NULL)
		DROP TABLE #Avail_Dubb
	IF(OBJECT_ID('TEMPDB..#Tmp_SL') IS NOT NULL)
		DROP TABLE #Tmp_SL
	IF(OBJECT_ID('TEMPDB..#Temp_Language_Names') IS NOT NULL)
		DROP TABLE #Temp_Language_Names
	IF(OBJECT_ID('TEMPDB..#Temp_Country_Names') IS NOT NULL)
		DROP TABLE #Temp_Country_Names
	IF(OBJECT_ID('TEMPDB..#Temp_Dates') IS NOT NULL)
		DROP TABLE #Temp_Dates
	IF(OBJECT_ID('TEMPDB..#TMP_MAIN') IS NOT NULL)
		DROP TABLE #TMP_MAIN

	Set @Episode_From = Case When IsNull(@Episode_From, 0) < 1 Then 1 Else @Episode_From End
	Set @Episode_To = Case When IsNull(@Episode_To, 0) < 1 Then 100000 Else @Episode_To End

	PRINT 'PA-STEP-1 Filter Criteria  ' + convert(varchar(30),getdate() ,109)
	BEGIN

		IF(UPPER(@RestrictionRemarks) = 'TRUE')
			SET @RestrictionRemarks = 'Y'
		ELSE
			SET @RestrictionRemarks = 'N'

		IF(UPPER(@OthersRemarks) = 'TRUE')
			SET @OthersRemarks = 'Y'
		ELSE
			SET @OthersRemarks = 'N'

		DECLARE @EX_YES CHAR(1)='',@EX_NO CHAR(1) =''

		IF(UPPER(@Exclusivity) = 'E')
			SET @EX_YES = 'Y'
		ELSE IF(UPPER(@Exclusivity) = 'N')
			SET @EX_NO = 'N'
		ELSE IF(UPPER(@Exclusivity) = 'B')
		BEGIN
			SET @EX_YES = 'Y'
			SET @EX_NO = 'N'
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
			
		CREATE TABLE #Temp_Language(
			Language_Code INT,
			Language_Type CHAR(1)
		)

		INSERT INTO #Temp_Language
		SELECT REPLACE(number, 'L', ''), 'S'  FROM fn_Split_withdelemiter(@Subtit_Language_Code, ',') WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
		INSERT INTO #Temp_Language
		SELECT REPLACE(number, 'L', ''), 'D'  FROM fn_Split_withdelemiter(@Dubbing_Language_Code, ',') WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
		SELECT CAST(number AS INT) SubLicense_Code INTO #Tmp_SL FROM fn_Split_withdelemiter(@SubLicense_Code, ',') WHERE number NOT IN('0', '')
		------------------ END

		DELETE FROM #Temp_Country WHERE Country_Code = 0
		DELETE FROM #Temp_Language WHERE Language_Code = 0
		DELETE FROM #Temp_Title WHERE Title_Code = 0
		DELETE FROM #Temp_Platform WHERE number = 0
		DELETE FROM #Temp_Title_Language WHERE number = 0
		
		IF NOT EXISTS(SELECT * FROM #Temp_Country)
		BEGIN
			INSERT INTO #Temp_Country
			SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active, 'N') = 'Y'
		END
	
		IF NOT EXISTS(SELECT * FROM #Temp_Language WHERE Language_Type = 'S')
		BEGIN
			INSERT INTO #Temp_Language
			SELECT Language_Code, 'S' FROM Language
		END
	
		IF NOT EXISTS(SELECT * FROM #Temp_Language WHERE Language_Type = 'D')
		BEGIN
			INSERT INTO #Temp_Language
			SELECT Language_Code, 'D' FROM Language 
		END
	
		IF NOT EXISTS(SELECT * FROM #Temp_Title)
		BEGIN
			INSERT INTO #Temp_Title
			SELECT DISTINCT Title_Code FROM Syn_Deal_Movie
		END
	
		IF NOT EXISTS(SELECT * FROM #Temp_Title_Language)
		BEGIN
			INSERT INTO #Temp_Title_Language
			SELECT Language_Code FROM Language
		END
		
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

	PRINT 'PA-STEP-2 Populate @Temp_Right ' + convert(varchar(30),getdate() ,109)
	BEGIN
		-----------------Query to get rights information related to title
		CREATE TABLE #Temp_Right 
		(
			Syn_Deal_Code INT, 
			Syn_Deal_Rights_Code INT, 
			Restriction_Remarks NVARCHAR(MAX), 
			Platform_Code INT, 
			Title_Code INT,
			Remarks NVARCHAR(MAX), 
			Rights_Remarks NVARCHAR(MAX),
			Sub_Deal_Restriction_Remark NVARCHAR(MAX), 
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Is_Exclusive CHAR(1),
			Sub_License_Code INT,
			Episode_From INT,
			Episode_To INT
		)

	
		INSERT INTO #Temp_Right(Syn_Deal_Code, Syn_Deal_Rights_Code, Restriction_Remarks, Platform_Code, Title_Code,
			   Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From, Episode_To)
		SELECT SR.Syn_Deal_Code, SR.Syn_Deal_Rights_Code, SR.Restriction_Remarks, SDRP.Platform_Code, SDRT.Title_Code,
			   SD.Remarks, SD.Rights_Remarks, 
			   (STUFF((
				SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
				FROM Syn_Deal SD_Tmp
				INNER JOIN Syn_Deal_Rights ADR_Tmp ON adr_Tmp.Syn_Deal_Code = SD_Tmp.Syn_Deal_Code 
			
				FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,'')) 
				, SR.Actual_Right_Start_Date, SR.Actual_Right_End_Date
				,SR.Is_Exclusive, ISNULL(SR.Sub_License_Code, 0), SDRT.Episode_From, SDRT.Episode_To
		FROM Syn_Deal_Rights AS SR
		INNER JOIN Syn_Deal_Rights_Platform AS SDRP ON SDRP.Syn_Deal_Rights_Code = SR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Title AS SDRT ON SDRT.Syn_Deal_Rights_Code = SR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal SD ON SR.Syn_Deal_Code = SD.Syn_Deal_Code
		WHERE SR.Is_Tentative = 'N'
		AND SR.Right_Status = 'C'
		AND (SR.Is_Sub_License = @Is_SubLicense OR @Is_SubLicense = '') 
		AND SDRT.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt)
		AND SDRP.Platform_Code IN (SELECT number FROM #Temp_Platform) 
		AND ((SR.Sub_License_Code IN (SELECT SubLicense_Code  FROM #Tmp_SL) AND @Is_SubLicense = 'Y') OR @Is_SubLicense <> 'Y')
		AND SD.Business_Unit_Code = @BU_Code
		AND ISNULL(SR.Is_Pushback, 'N') = 'N'
		--AND ((SD.Deal_Workflow_Status = @Is_Approved) OR @Is_Approved = '')
		AND (
			SDRT.Episode_From Between @Episode_From And @Episode_To Or
			SDRT.Episode_To Between @Episode_From And @Episode_To Or
			@Episode_From Between SDRT.Episode_From And SDRT.Episode_To Or
			@Episode_To Between SDRT.Episode_From And SDRT.Episode_To
		)
		------------------ END

	END

	PRINT 'PA-STEP-3 Populate #Avail_Syn  ' + convert(varchar(30),getdate() ,109)
	BEGIN
		-----------------Query to get Avail information related to Title ,Platform AND Country
		CREATE TABLE #Avail_Syn 
		(
			Syn_Deal_Rights_Code INT, 
			Title_Code INT,
			Platform_Code INT, 
			Country_Code INT,
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Is_Exclusive CHAR(1),
			Sub_License_Code INT,
			Episode_From INT,
			Episode_To INT
		)
		
		------------------ END
	END
	
	IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
	BEGIN
		
		INSERT INTO #Avail_Syn(Syn_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code,Episode_From ,Episode_To)
		SELECT DISTINCT tr.Syn_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
					   CASE WHEN SDRTER.Territory_Type = 'G' THEN td.Country_Code ELSE SDRTER.Country_Code END, 
					   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0),Episode_From ,Episode_To
		FROM 
		#Temp_Right tr 
		INNER JOIN Syn_Deal_Rights_Territory SDRTER on SDRTER.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = SDRTER.Territory_Code AND SDRTER.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform) )
		AND ((SDRTER.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (SDRTER.Territory_Type = 'I' AND SDRTER.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)))
		AND (ISNULL(tr.Rights_Start_Date, '9999-12-31')  <= @StartDate AND ISNULL(tr.Rights_End_Date, '9999-12-31') >=  @EndDate)
		AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	ELSE
	BEGIN

		INSERT INTO #Avail_Syn(Syn_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code,Episode_From, Episode_To)
		SELECT DISTINCT tr.Syn_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
			   CASE WHEN SDRTER.Territory_Type = 'G' THEN td.Country_Code ELSE SDRTER.Country_Code END, 
			   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0),Episode_From ,Episode_To
		FROM 
		#Temp_Right tr 
		INNER JOIN Syn_Deal_Rights_Territory SDRTER on SDRTER.Syn_Deal_Rights_Code = tr.Syn_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = SDRTER.Territory_Code AND SDRTER.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform) )
		AND ((SDRTER.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (SDRTER.Territory_Type = 'I' AND SDRTER.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)))
		AND ((ISNULL(tr.Rights_End_Date, '9999-12-31') BETWEEN @StartDate AND  @EndDate)
			OR (ISNULL(tr.Rights_Start_Date, '9999-12-31') BETWEEN @StartDate AND @EndDate)
			OR (@StartDate BETWEEN  ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31'))
			OR (@EndDate BETWEEN ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31')))
		AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	
	PRINT 'PA-STEP-4 Populate #Avail_TitLang' + convert(varchar(30),getdate() ,109)
	BEGIN
		CREATE TABLE #Avail_TitLang 
		(
			Syn_Deal_Rights_Code INT,
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Language_Code INT,
			Sub_License_Code INT,
			Is_Exclusive CHAR(1),
			Title_Language_Names NVARCHAR(200),
			Episode_From INT,
			Episode_To INT
		)

		CREATE TABLE #Avail_Sub 
		(
			Syn_Deal_Rights_Code INT,
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Language_Code NVARCHAR(MAX),
			Sub_License_Code INT,
			Is_Exclusive CHAR(1),
			Episode_From INT,
			Episode_To INT,
			Sub_Language_Names NVARCHAR(MAX)
		)

		CREATE TABLE #Avail_Dubb 
		(
			Syn_Deal_Rights_Code INT,
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Language_Code NVARCHAR(MAX),
			Sub_License_Code INT,
			Is_Exclusive CHAR(1),
			Episode_From INT,
			Episode_To INT,
			Dubb_Language_Names NVARCHAR(MAX)
		)
		-----------------Populate Title Avail for Title Languages
		CREATE INDEX IX_TMP_Avail_Syn ON #Avail_Syn(Syn_Deal_Rights_Code)
		CREATE INDEX IX_Temp_Language ON #Temp_Language(Language_Code)
		
		IF(@Is_Original_Language = 1) 
		BEGIN
			
			INSERT INTO #Avail_TitLang(Syn_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To)
			SELECT AA.Syn_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, tit.Title_Language_Code
				, AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To
			FROM #Avail_Syn AA
			INNER JOIN Title tit ON AA.Title_Code = tit.Title_Code
			INNER JOIN #Temp_Title_Language TTL ON TTL.number = tit.Title_Language_Code
		
		END

		PRINT 'PA-STEP-4.1 Populate #Avail_Sub  ' + convert(varchar(30),getdate() ,109)
		-----------------Populate Title Avail for Subtitling Languages
		IF EXISTS(SELECT * WHERE 'S' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))
		BEGIN
			Select Distinct Syn_Deal_Rights_Code, STUFF((
			Select Distinct ',' + 
			CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrs.Language_Code End AS NVARCHAR) From Syn_Deal_Rights_Subtitling adrs
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code
			WHERE adrs.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			And (
				(
					Language_Type = 'G' And lgd.Language_Code IN (
						Select tl.Language_Code From #Temp_Language TL Where TL.Language_Type = 'S'
					)
				) OR
				(
					Language_Type <> 'G' And adrs.Language_Code IN (
						Select TL1.Language_Code From #Temp_Language TL1 Where TL1.Language_Type = 'S'
					)
				)
			)
			FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
			)Sub_Langs InTo #Temp_Subs
			From (
				Select Distinct Syn_Deal_Rights_Code From #Avail_Syn
			) As a
		
			
			INSERT INTO #Avail_Sub
			(
				Syn_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, 
				Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Sub_Language_Names
			)
			SELECT AA.Syn_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
			AAS.Sub_Langs, AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
			FROM 
			#Temp_Subs AAS
			INNER JOIN #Avail_Syn AA ON AA.Syn_Deal_Rights_Code = AAS.Syn_Deal_Rights_Code
			WHERE ISNULL(AAS.Sub_Langs,'') <>''
			
			print '2'	
			Drop Table #Temp_Subs
			
		END

		-----------------Populate Title Avail for Dubbing Languages
		PRINT 'PA-STEP-4.2 Populate #Avail_Dubb  ' + convert(varchar(30),getdate() ,109)
		IF(EXISTS(SELECT * WHERE 'D' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling,','))))
		BEGIN
			Select Distinct Syn_Deal_Rights_Code, STUFF((
			Select Distinct ',' + 
			CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrd.Language_Code End AS NVARCHAR) From Syn_Deal_Rights_Dubbing adrd
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrd.Language_Group_Code
			WHERE adrd.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			And (
				(
					Language_Type = 'G' And lgd.Language_Code IN (
						Select tl.Language_Code From #Temp_Language TL Where TL.Language_Type = 'D'
					)
				) OR
				(
					Language_Type <> 'G' And adrd.Language_Code IN (
						Select TL1.Language_Code From #Temp_Language TL1 Where TL1.Language_Type = 'D'
					)
				)
			)
			FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
			)Dub_Langs InTo #Temp_Dubs
			From (
				Select Distinct Syn_Deal_Rights_Code From #Avail_Syn
			) As a		
		
			INSERT INTO #Avail_Dubb(Syn_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Dubb_Language_Names)
			SELECT AA.Syn_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
			--CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
			AAD.Dub_Langs,
			AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
			FROM 
			#Temp_Dubs AAD
			INNER JOIN #Avail_Syn AA ON AA.Syn_Deal_Rights_Code = AAD.Syn_Deal_Rights_Code
			WHERE ISNULL(AAD.Dub_Langs,'') <>''
			
			print '2'	
			Drop Table #Temp_Dubs	

		END
	
		CREATE INDEX IX_Avail_TitLang ON #Avail_TitLang(Syn_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
		CREATE INDEX IX_Avail_Dubb ON #Avail_Dubb(Syn_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
		CREATE INDEX IX_Avail_Sub ON #Avail_Sub(Syn_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
		
		print 'PA-STEP-6 UPDATE Language Names in  in #Avail_TitLang_V1, #Avail_Sub_V1, #Avail_Dubb_V1  ' + convert(varchar(30),getdate() ,109)	
		BEGIN

			--- Get Language Names for #Temp_Main
			CREATE TABLE #Temp_Language_Names(
				Language_Codes NVARCHAR(MAX),
				Language_Names NVARCHAR(MAX)
			)

			INSERT INTO #Temp_Language_Names(Language_Codes)
			SELECT DISTINCT Language_Code FROM #Avail_Sub
	
			INSERT INTO #Temp_Language_Names(Language_Codes)
			SELECT DISTINCT Language_Code FROM #Avail_Dubb WHERE Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS   NOT IN (
				SELECT Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS   FROM #Temp_Language_Names
			)

			UPDATE #Temp_Language_Names SET Language_Names = [dbo].[UFN_Get_Language_With_Parent](Language_Codes)
	
			UPDATE tm SET tm.Title_Language_Names = lang.Language_Name
			FROM #Avail_TitLang tm 
			INNER JOIN Language lang ON tm.Language_Code = lang.Language_Code

			UPDATE tm SET tm.Sub_Language_Names = tml.Language_Names FROM #Avail_Sub tm 
			INNER JOIN #Temp_Language_Names tml ON tm.Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  = tml.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  

			UPDATE tm SET tm.Dubb_Language_Names = tml.Language_Names FROM #Avail_Dubb tm 
			INNER JOIN #Temp_Language_Names tml ON tm.Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  = tml.Language_Codes  COLLATE SQL_Latin1_General_CP1_CI_AS  

		END
	
		PRINT 'PA-STEP-7 Populate #Temp_Dates ' + convert(varchar(30),getdate() ,109)
		BEGIN
	
			CREATE TABLE #Temp_Dates
			(
				Syn_Deal_Rights_Code INT, 
				Right_Start_Date DATETIME, 
				Rights_End_Date DATETIME, 
				Is_Exclusive  CHAR(1),
				Sub_License_Code INT,
				Episode_From INT,
				Episode_To INT
			)

			INSERT INTO #Temp_Dates (Syn_Deal_Rights_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code ,Episode_From, Episode_To)
			SELECT AT.Syn_Deal_Rights_Code, AT.Rights_Start_Date, AT.Rights_End_Date, At.Is_Exclusive, AT.Sub_License_Code , AT.Episode_From, AT.Episode_To
			FROM #Avail_TitLang AT
			UNION 
			SELECT ASUB.Syn_Deal_Rights_Code, ASUB.Rights_Start_Date, ASUB.Rights_End_Date, ASUB.Is_Exclusive, ASUB.Sub_License_Code , ASUB.Episode_From, ASUB.Episode_To
			FROM #Avail_Sub ASUB 
			UNION
			SELECT ADUB.Syn_Deal_Rights_Code, ADUB.Rights_Start_Date, ADUB.Rights_End_Date, ADUB.Is_Exclusive, ADUB.Sub_License_Code , ADUB.Episode_From, ADUB.Episode_To
			FROM #Avail_Dubb ADUB 
			END

			PRINT 'PA-STEP-8 Populate #Temp_Main ' + convert(varchar(30),getdate() ,109)
			BEGIN

			CREATE INDEX IX_Temp_Dates ON #Temp_Dates(Syn_Deal_Rights_Code)

			SELECT AA.Syn_Deal_Rights_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code, TD.Right_Start_Date, TD.Rights_End_Date, TD.Is_Exclusive, TD.Sub_License_Code
			,AA.Episode_From, AA.Episode_To, CAST('' AS NVARCHAR(2000)) AS Country_Cd_Str ,
			CAST('' AS CHAR(1)) AS Region_Type , CAST('' AS NVARCHAR(2000)) AS Country_Names 
			INTO #TMP_MAIN
			FROM #Temp_Dates TD
			INNER JOIN #Avail_Syn AA ON AA.Syn_Deal_Rights_Code = TD.Syn_Deal_Rights_Code
			END

			DROP TABLE #Temp_Dates

			PRINT 'PA-STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
			BEGIN
	
				--ALTER TABLE #Avail_Syn ADD 
				--Country_Cd_Str VARCHAR(2000),
				--Region_Type CHAR(1),
				--Country_Names VARCHAR(2000)
		
				UPDATE t2
				SET t2.Country_Cd_Str =  STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(Country_Code AS NVARCHAR) FROM #TMP_MAIN t1 
						WHERE t1.Title_Code = t2.Title_Code
							  AND t1.Platform_Code = t2.Platform_Code
							  AND t1.Right_Start_Date = t2.Right_Start_Date
							  AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')
							  AND t1.Is_Exclusive = t2.Is_Exclusive
							  AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
							  AND ISNULL(t1.Episode_From, 0) = ISNULL(t2.Episode_From, 0)
							  AND ISNULL(t1.Episode_To, 0) = ISNULL(t2.Episode_To, 0)
						FOR XML PATH('')
					), 1, 1, ''
				)
				FROM #TMP_MAIN t2
	
				CREATE TABLE #Temp_Country_Names(
					Territory_Code INT,
					Country_Cd INT,
					Country_Codes NVARCHAR(2000),
					Country_Names NVARCHAR(MAX)
				)
	
				INSERT INTO #Temp_Country_Names(Country_Codes, Country_Names)
				SELECT DISTINCT Country_Cd_Str, NULL FROM #TMP_MAIN
	
	
				--SELECT * FROM #Temp_Country_Names
				PRINT 'PA-STEP-9.1- Country Exact Match ' + convert(varchar(30),getdate() ,109)
				-----------------IF Country = Exact Match
				IF(UPPER(@Region_ExactMatch) = 'EM')
				BEGIN
			
					DECLARE @CntryStr NVARCHAR(1000) = ''
					SELECT @CntryStr = 
					STUFF
					(
						(
							SELECT DISTINCT ',' + CAST(Country_Code AS NVARCHAR) FROM #Temp_Country
							FOR XML PATH('')
						), 1, 1, ''
					)
			
					DELETE FROM #TMP_MAIN WHERE Country_Cd_Str <> @CntryStr
				
				END
	
				PRINT 'PA-STEP-9.2- Country Must Have ' + convert(varchar(30),getdate() ,109)
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
					
					-- Commented by Abhay
					--DELETE FROM #Avail_Syn WHERE Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS FROM #Temp_Country_Names)
				END
	
				PRINT 'PA-STEP-9.3- Country Names ' + convert(varchar(30),getdate() ,109)
				-----------------UPDATE Country / Territory Names
	
				UPDATE #Temp_Country_Names SET Country_Names = [dbo].[UFN_Get_Territory](Country_Codes)
	
				UPDATE tmc SET tmc.Territory_Code = ter.Territory_Code FROM Territory ter 
				INNER JOIN #Temp_Country_Names tmc ON ter.Territory_Name COLLATE SQL_Latin1_General_CP1_CI_AS= tmc.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS AND ISNULL(tmc.Country_Names, '') <> ''

				UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'T', tm.Country_Code = tmc.Territory_Code
				FROM #TMP_MAIN tm 
				INNER JOIN #Temp_Country_Names tmc ON tm.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS= tmc.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS AND ISNULL(tmc.Country_Names, '') <> ''

				TRUNCATE TABLE #Temp_Country_Names
	
				INSERT INTO #Temp_Country_Names(Country_Cd)
				SELECT DISTINCT Country_Code FROM #TMP_MAIN Where ISNULL(Country_Names, '') = ''
	
				UPDATE tmc SET tmc.Country_Names = cur.Country_Name FROM Country cur
				INNER JOIN #Temp_Country_Names tmc ON cur.Country_Code = tmc.Country_Cd

				UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'C' FROM #TMP_MAIN tm 
				INNER JOIN #Temp_Country_Names tmc ON tm.Country_Code = tmc.Country_Cd AND ISNULL(tm.Country_Names, '') = '' AND ISNULL(Region_Type, '') <> 'T' 
	
				PRINT 'PA-STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
				---------- PARTIATION BY QUERY FOR DELETING DUPLICATE RECORDS
				SELECT Syn_Deal_Rights_Code, Title_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, 
									   Platform_Code, Country_Cd_Str, Country_Names, Region_Type, Episode_From, Episode_To
				INTO #Temp_Main_Ctr
				FROM (
					SELECT ROW_NUMBER() OVER(
												PARTITION BY Syn_Deal_Rights_Code ,Title_Code, Platform_Code, Country_Code, Region_Type, Right_Start_Date, Rights_End_Date
												, Is_Exclusive, Sub_License_Code
												ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type DESC
											) RowId, * 
					FROM #TMP_MAIN tm
				) AS a WHERE RowId = 1	
				---------- END
			END
	
			ALTER TABLE #Temp_Main_Ctr ADD Platform_Str NVARCHAR(2000)
	
			PRINT 'PA-STEP-10- Platform Must Have / Exact Match ' + convert(varchar(30),getdate() ,109)
			BEGIN
				IF(UPPER(@Platform_ExactMatch) = 'EM' OR UPPER(@Platform_ExactMatch) = 'MH')
				BEGIN
				UPDATE t2
				SET t2.Platform_Str =  STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(Platform_Code As NVARCHAR) FROM #Temp_Main_Ctr t1 
						Where t1.Right_Start_Date = t2.Right_Start_Date
							AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')		
							AND t1.Title_Code = t2.Title_Code
							AND ISNULL(t1.Country_Cd_Str, 0) = ISNULL(t2.Country_Cd_Str, 0)
							AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
							AND t1.Is_Exclusive = t2.Is_Exclusive
							--AND t1.Country_Code = t2.Country_Code
							AND ISNULL(t1.Episode_From, 0) = ISNULL(t2.Episode_From, 0)
							AND ISNULL(t1.Episode_To, 0) = ISNULL(t2.Episode_To, 0)
						FOR XML PATH('')
					), 1, 1, ''
				)
				FROM #Temp_Main_Ctr t2
	
				IF(UPPER(@Platform_ExactMatch) = 'EM')
				BEGIN
			
					DECLARE @PlStr NVARCHAR(1000) = ''
					SELECT @PlStr = 
						STUFF
						(
							(
								SELECT DISTINCT ',' + CAST(number AS NVARCHAR) FROM #Temp_Platform
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
					SELECT number FROM dbo.fn_Split_withdelemiter(@MustHave_Platform, ',') WHERE number NOT IN ('', '0')

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
				END

			END
			END

			print 'PA-STEP-11 UPDATE LANGUAGE Names in #Temp_Main_Ctr' + convert(varchar(30),getdate() ,109)	
			BEGIN
				ALTER TABLE #Temp_Main_Ctr ADD 
				Title_Language_Names NVARCHAR(2000),
				Sub_Language_Names NVARCHAR(2000),
				Dub_Language_Names NVARCHAR(2000)
	
	
				UPDATE tms
				SET tms.Title_Language_Names = at.Title_Language_Names
				FROM #Temp_Main_Ctr tms
				INNER JOIN #Avail_TitLang at ON at.Syn_Deal_Rights_Code = tms.Syn_Deal_Rights_Code
					AND at.Rights_Start_Date  = tms.Right_Start_Date
					AND IsNull(at.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
					AND at.Is_Exclusive  = tms.Is_Exclusive
					AND at.Sub_License_Code  = tms.Sub_License_Code
	
				UPDATE tms
				SET tms.Sub_Language_Names = asub.Sub_Language_Names
				FROM #Temp_Main_Ctr tms
				INNER JOIN #Avail_Sub asub ON asub.Syn_Deal_Rights_Code = tms.Syn_Deal_Rights_Code
					AND asub.Rights_Start_Date  = tms.Right_Start_Date
					AND IsNull(asub.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
					AND asub.Is_Exclusive  = tms.Is_Exclusive
					AND asub.Sub_License_Code  = tms.Sub_License_Code

				UPDATE tms
				SET tms.Dub_Language_Names = SD.Dubb_Language_Names
				FROM #Temp_Main_Ctr tms
				INNER JOIN #Avail_Dubb SD ON SD.Syn_Deal_Rights_Code = tms.Syn_Deal_Rights_Code
					AND SD.Rights_Start_Date  = tms.Right_Start_Date
					AND IsNull(SD.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
					AND SD.Is_Exclusive  = tms.Is_Exclusive
					AND SD.Sub_License_Code  = tms.Sub_License_Code
		   END		
   
			--DROP TABLE #Avail_Sub_V1
			--DROP TABLE #Avail_Dubb_V1

			print 'PA-STEP-12 Query to get title details' + convert(varchar(30),getdate() ,109)	
			BEGIN
				-----------------Query to get title details
				SELECT t.Title_Code, t.Title_Language_Code, t.Title_Name,
					Genres_Name = [dbo].[UFN_GetGenresForTitle](t.Title_Code),
					Star_Cast = [dbo].[UFN_GetStarCastForTitle](t.Title_Code),
					Director = [dbo].[UFN_GetDirectorForTitle](t.Title_Code),
					COALESCE(t.Duration_In_Min, '0') Duration_In_Min, COALESCE(t.Year_Of_Production, '') Year_Of_Production 
				INTO #Temp_Titles
				FROM Title t 
				WHERE(t.Title_Code IN (SELECT tm.Title_Code FROM #Temp_Main_Ctr tm))
				------------------END
			END

			DROP TABLE #Temp_Country_Names
			DROP TABLE #Temp_Language_Names
		
			-- Commented by Abhay, Bug ID : 5462
			-- UPDATE #Temp_Main_Ctr SET Right_Start_Date = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE Right_Start_Date < GETDATE()

			SELECT DISTINCT TM.Syn_Deal_Rights_Code, TM.Is_Exclusive, CAST(TM.Right_Start_Date AS DATETIME) AS Rights_Start_Date, 
			CAST(ISNULL(TM.Rights_End_Date, '31Dec9999') AS DATETIME) AS Rights_End_Date, TM.Sub_License_Code, 
			CAST('' AS NVARCHAR(MAX)) Remarks, CAST('' AS NVARCHAR(MAX)) Rights_Remarks, CAST('' AS NVARCHAR(MAX)) Restriction_Remarks
			INTO #Temp_Rights_Data
			FROM #Temp_Main_Ctr TM
			
			PRINT 'Altering #Temp_Platforms table...'
			ALTER TABLE #Temp_Rights_Data
			ADD 
			Region_Names NVARCHAR(Max), 
			Subtitling_Names NVARCHAR(Max),
			Dubbing_Names NVARCHAR(Max)

			PRINT 'updating value of newly added column in #Temp_Platforms table...'
			Update #Temp_Rights_Data Set 
			Region_Names = DBO.UFN_Get_Rights_Country(Syn_Deal_Rights_Code, 'S',''),
			Subtitling_Names = DBO.UFN_Get_Rights_Subtitling(Syn_Deal_Rights_Code, 'S'),
			Dubbing_Names = DBO.UFN_Get_Rights_Dubbing(Syn_Deal_Rights_Code, 'S')

			UPDATE #Temp_Rights_Data SET Region_Names = DBO.UFN_Get_Rights_Territory(Syn_Deal_Rights_Code, 'S') WHERE LTRIM(RTRIM(Region_Names)) = ''
			UPDATE #Temp_Rights_Data SET Subtitling_Names = 'No' WHERE LTRIM(RTRIM(Subtitling_Names)) = ''
			UPDATE #Temp_Rights_Data SET Dubbing_Names = 'No' WHERE LTRIM(RTRIM(Dubbing_Names)) = ''
	
			IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
			BEGIN
				WITH Temp_Right_Remarks  AS(
				SELECT DISTINCT Syn_Deal_Rights_Code, ISNULL(Remarks, '') AS Remarks, ISNULL(Rights_Remarks, '') AS Rights_Remarks, 
						ISNULL(Restriction_Remarks, '') AS Restriction_Remarks
					FROM #Temp_Right
				)

				UPDATE TRD SET TRD.Remarks = TRM.Remarks, TRD.Rights_Remarks = TRM.Rights_Remarks, TRD.Restriction_Remarks = TRM.Restriction_Remarks
				FROM #Temp_Rights_Data TRD
				INNER JOIN Temp_Right_Remarks TRM ON TRD.Syn_Deal_Rights_Code = TRM.Syn_Deal_Rights_Code
			END
	
			SELECT SD.Agreement_No, SD.Agreement_Date, SD.Deal_Description, V.Vendor_Name AS Licensor, 
			DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(SD.Deal_Type_Code), T.Title_Name, SDM.Episode_From, SDM.Episode_End_To) AS Title_Name,
			SDR.Right_Type, TR.Syn_Deal_Rights_Code, 
			ISNULL(SL.Sub_License_Name, '') AS Sub_License,
			CASE ISNULL(SDR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END AS Is_Exclusive, 
			CASE SDR.Right_Type
				When 'Y' Then [dbo].[UFN_Get_Rights_Term](SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Term) 
				When 'M' Then [dbo].[UFN_Get_Rights_Milestone](SDR.Milestone_Type_Code, SDR.Milestone_No_Of_Unit, SDR.Milestone_Unit_Type)
				When 'U' Then 'Perpetuity'
			End AS Term,
			TR.Rights_Start_Date, TR.Rights_End_Date, 
			CASE ISNULL(SDR.Is_Title_Language_Right, 'N') WHEN 'Y' THEN ISNULL(L.Language_Name, 'No')  ELSE 'No' END 
			AS Title_Language,
			P.Platform_Hiearachy, P.Platform_Code,
			'YES' AS Available, TR.Region_Names, TR.Subtitling_Names, TR.Dubbing_Names,
			TR.Remarks, TR.Rights_Remarks, TR.Restriction_Remarks
			FROM #Temp_Rights_Data TR
			INNER JOIN #Temp_Main_Ctr TM ON TR.Syn_Deal_Rights_Code = TM.Syn_Deal_Rights_Code
			INNER JOIN Syn_Deal_Rights SDR ON SDR.Syn_Deal_Rights_Code = TR.Syn_Deal_Rights_Code
			INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
			INNER JOIN Syn_Deal_Movie SDM ON SDM.Syn_Deal_Code = SDM.Syn_Deal_Code AND SDM.Title_Code = TM.Title_Code
				AND TM.Episode_From = SDM.Episode_From AND TM.Episode_To = SDM.Episode_End_To
			INNER JOIN Vendor V ON V.Vendor_Code = SD.Vendor_Code
			INNER JOIN Title T ON T.Title_Code = SDM.Title_Code
			INNER JOIN [Platform] P ON P.Platform_Code = TM.Platform_Code
			LEFT JOIN Sub_License SL ON SDR.Sub_License_Code = sl.Sub_License_Code
			LEFT JOIN [Language] L ON L.Language_Code = T.Title_Language_Code 
			WHERE ISNULL(SDR.Is_Pushback, 'N') = 'N'
		END

		IF OBJECT_ID('tempdb..#Avail_Dubb') IS NOT NULL DROP TABLE #Avail_Dubb
		IF OBJECT_ID('tempdb..#Avail_Dubb_V1') IS NOT NULL DROP TABLE #Avail_Dubb_V1
		IF OBJECT_ID('tempdb..#Avail_Sub') IS NOT NULL DROP TABLE #Avail_Sub
		IF OBJECT_ID('tempdb..#Avail_Sub_V1') IS NOT NULL DROP TABLE #Avail_Sub_V1
		IF OBJECT_ID('tempdb..#Avail_Sub_V1') IS NOT NULL DROP TABLE #Avail_Sub_V1
		IF OBJECT_ID('tempdb..#Avail_Syn') IS NOT NULL DROP TABLE #Avail_Syn
		IF OBJECT_ID('tempdb..#Avail_TitLang') IS NOT NULL DROP TABLE #Avail_TitLang
		IF OBJECT_ID('tempdb..#Avail_TitLang_V1') IS NOT NULL DROP TABLE #Avail_TitLang_V1
		IF OBJECT_ID('tempdb..#Temp_Country') IS NOT NULL DROP TABLE #Temp_Country
		IF OBJECT_ID('tempdb..#Temp_Country_Names') IS NOT NULL DROP TABLE #Temp_Country_Names
		IF OBJECT_ID('tempdb..#Temp_Dates') IS NOT NULL DROP TABLE #Temp_Dates
		IF OBJECT_ID('tempdb..#Temp_Dubs') IS NOT NULL DROP TABLE #Temp_Dubs
		IF OBJECT_ID('tempdb..#Temp_Language') IS NOT NULL DROP TABLE #Temp_Language
		IF OBJECT_ID('tempdb..#Temp_Language_Names') IS NOT NULL DROP TABLE #Temp_Language_Names
		IF OBJECT_ID('tempdb..#Temp_Main') IS NOT NULL DROP TABLE #Temp_Main
		IF OBJECT_ID('tempdb..#Temp_Main_Ctr') IS NOT NULL DROP TABLE #Temp_Main_Ctr
		IF OBJECT_ID('tempdb..#Temp_Platform') IS NOT NULL DROP TABLE #Temp_Platform
		IF OBJECT_ID('tempdb..#Temp_Platforms') IS NOT NULL DROP TABLE #Temp_Platforms
		IF OBJECT_ID('tempdb..#Temp_Plt_Names') IS NOT NULL DROP TABLE #Temp_Plt_Names
		IF OBJECT_ID('tempdb..#Temp_Right') IS NOT NULL DROP TABLE #Temp_Right
		IF OBJECT_ID('tempdb..#Temp_Rights_Data') IS NOT NULL DROP TABLE #Temp_Rights_Data
		IF OBJECT_ID('tempdb..#Temp_Subs') IS NOT NULL DROP TABLE #Temp_Subs
		IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL DROP TABLE #Temp_Title
		IF OBJECT_ID('tempdb..#Temp_Title_Language') IS NOT NULL DROP TABLE #Temp_Title_Language
		IF OBJECT_ID('tempdb..#Temp_Titles') IS NOT NULL DROP TABLE #Temp_Titles
		IF OBJECT_ID('tempdb..#TMP_MAIN') IS NOT NULL DROP TABLE #TMP_MAIN
		IF OBJECT_ID('tempdb..#Tmp_SL') IS NOT NULL DROP TABLE #Tmp_SL
	END