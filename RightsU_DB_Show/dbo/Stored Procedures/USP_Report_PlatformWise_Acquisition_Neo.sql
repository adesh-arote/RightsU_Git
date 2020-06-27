CREATE PROCEDURE [dbo].[USP_Report_PlatformWise_Acquisition_Neo]
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
	@Deal_Type_Code INT = 1 
)
AS
-- =============================================
-- Author :	RESHMA KUNJAL
-- Create date: 08 MARCH 2016
-- Description:	This Procedure is to generate Platform wise Acquisition data With "Availability Report" paramters and @Is_SubLicense parameter
-- And Deals which are Approved
-- =============================================
BEGIN


	-- SET NOCOUNT ON added to prevent extra result sets FROM interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF;

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
		SELECT DISTINCT Title_Code FROM Acq_Deal_Movie
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
		Acq_Deal_Code INT, 
		Acq_Deal_Rights_Code INT, 
		Restriction_Remarks NVARCHAR(MAx), 
		Platform_Code INT, 
		Title_Code INT,
		Is_Master_Deal CHAR(1), 
		Remarks NVARCHAR(MAX), 
		Rights_Remarks NVARCHAR(MAX),
		Sub_Deal_Restriction_Remark NVARCHAR(MAX), 
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Is_Exclusive CHAR(1),
		Sub_License_Code INT
	)

	
	INSERT INTO #Temp_Right(Acq_Deal_Code, Acq_Deal_Rights_Code, Restriction_Remarks, Platform_Code, Title_Code,
		   Is_Master_Deal, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	SELECT ar.Acq_Deal_Code, ar.Acq_Deal_Rights_Code, ar.Restriction_Remarks, adrp.Platform_Code, ADRT.Title_Code,
		   ad.Is_Master_Deal, ad.Remarks, ad.Rights_Remarks, 
		   (STUFF((
			SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
			FROM Acq_Deal AD_Tmp
			INNER JOIN Acq_Deal_Rights ADR_Tmp ON adr_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
			WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
			(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = ad.Acq_Deal_Code)
			FOR XML PATH(''),type).value('.', 'NVARCHAR(max)'),1,1,'')) 
			, ar.Actual_Right_Start_Date, ar.Actual_Right_End_Date
			,ar.Is_Exclusive, ISNULL(ar.Sub_License_Code, 0)
	FROM Acq_Deal_Rights AS ar
	INNER JOIN Acq_Deal_Rights_Platform AS adrp ON adrp.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights_Title AS adrt ON adrt.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal ad ON ar.Acq_Deal_Code = ad.Acq_Deal_Code
	WHERE 
	ad.Is_Master_Deal = 'Y'
	AND ar.Is_Tentative = 'N'
	AND (ar.Is_Sub_License = @Is_SubLicense OR @Is_SubLicense = '')
	AND adrt.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt)
	AND adrp.Platform_Code IN (SELECT number FROM #Temp_Platform) 
	AND ((ar.Sub_License_Code IN (SELECT SubLicense_Code  FROM #Tmp_SL) AND @Is_SubLicense = 'Y') OR @Is_SubLicense = 'N')
	AND ad.Business_Unit_Code = @BU_Code
	AND ((ad.Deal_Workflow_Status = @Is_Approved) OR @Is_Approved = '')
	AND ad.Deal_Type_Code = @Deal_Type_Code OR (ad.Deal_Type_Code <> 1 AND @Deal_Type_Code <> 1)
	------------------ END
	END

	PRINT 'PA-STEP-3 Populate #Avail_Acq  ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	-----------------Query to get Avail information related to Title ,Platform AND Country
	CREATE TABLE #Avail_Acq 
	(
		Acq_Deal_Rights_Code INT, 
		Title_Code INT,
		Platform_Code INT, 
		Country_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Is_Exclusive CHAR(1),
		Sub_License_Code INT
	)
		
	------------------ END
	END
	
	IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
	BEGIN
		
		INSERT INTO #Avail_Acq(Acq_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code)
		SELECT DISTINCT tr.Acq_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
					   CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
					   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0)
		FROM 
		#Temp_Right tr 
		INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform) )
		AND ((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)))
		AND (ISNULL(tr.Rights_Start_Date, '9999-12-31')  <= @StartDate AND ISNULL(tr.Rights_End_Date, '9999-12-31') >=  @EndDate)
		AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	ELSE
	BEGIN

		INSERT INTO #Avail_Acq(Acq_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code)
		SELECT DISTINCT tr.Acq_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
			   CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
			   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0)
		FROM 
		#Temp_Right tr 
		INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform) )
		AND ((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)))
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
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code INT,
		Sub_License_Code INT,
		Is_Exclusive CHAR(1),
		Title_Language_Names NVARCHAR(400)
	)

	CREATE TABLE #Avail_Sub 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code INT,
		Sub_License_Code INT,
		Is_Exclusive CHAR(1)
	)

	CREATE TABLE #Avail_Dubb 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code INT,
		Sub_License_Code INT,
		Is_Exclusive CHAR(1)
	)
	-----------------Populate Title Avail for Title Languages
	
	CREATE INDEX IX_TMP_Avail_Acq ON #Avail_Acq(Acq_Deal_Rights_Code)
	CREATE INDEX IX_Temp_Language ON #Temp_Language(Language_Code)
		
	IF(@Is_Original_Language = 1) 
	BEGIN
			
		INSERT INTO #Avail_TitLang(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, tit.Title_Language_Code
			, AA.Sub_License_Code, AA.Is_Exclusive 
		FROM #Avail_Acq AA
		INNER JOIN Title tit ON AA.Title_Code = tit.Title_Code
		INNER JOIN #Temp_Title_Language TTL ON TTL.number = tit.Title_Language_Code
		
	END

	PRINT 'PA-STEP-4.1 Populate #Avail_Sub  ' + convert(varchar(30),getdate() ,109)
	-----------------Populate Title Avail for Subtitling Languages
	IF EXISTS(SELECT * WHERE 'S' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))
	BEGIN
		
		INSERT INTO #Avail_Sub(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
			AA.Sub_License_Code, AA.Is_Exclusive 
		FROM 
		Acq_Deal_Rights_Subtitling AAS
		INNER JOIN #Avail_Acq AA ON AA.Acq_Deal_Rights_Code = AAS.Acq_Deal_Rights_Code
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = aas.Language_Group_Code AND aas.Language_Type= 'G' 
		INNER JOIN #Temp_Language TL ON 
		((TL.Language_Code = AAS.Language_Code AND aas.Language_Type = 'L') OR (TL.Language_Code = lgd.Language_Code AND aas.Language_Type = 'G'))
		AND TL.Language_Type = 'S'
			
	END

	-----------------Populate Title Avail for Dubbing Languages
	PRINT 'PA-STEP-4.2 Populate #Avail_Dubb  ' + convert(varchar(30),getdate() ,109)
	--RETURN
	IF(EXISTS(SELECT * WHERE 'D' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling,','))))
	BEGIN
				
		INSERT INTO #Avail_Dubb(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive)
		SELECT DISTINCT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		CASE WHEN aaD.Language_Type= 'G' THEN lgd.Language_Code ELSE AAD.Language_Code END ,
		AA.Sub_License_Code, AA.Is_Exclusive 
		FROM 
		Acq_Deal_Rights_Dubbing AAD
		INNER JOIN #Avail_Acq AA ON AA.Acq_Deal_Rights_Code = AAD.Acq_Deal_Rights_Code
		LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = aad.Language_Group_Code AND AAD.Language_Type= 'G' 
		INNER JOIN #Temp_Language TL ON 
		((TL.Language_Code = AAD.Language_Code AND AAD.Language_Type = 'L') OR (TL.Language_Code = lgd.Language_Code AND aaD.Language_Type = 'G'))
		AND TL.Language_Type = 'D'

	END
	

	CREATE INDEX IX_Avail_TitLang ON #Avail_TitLang(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Dubb ON #Avail_Dubb(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Sub ON #Avail_Sub(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)

	PRINT 'PA-STEP-5 UPDATE Subtitling Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1, #Avail_Dubb_V1 ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Sub_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Sub_Language_Names
	INTO #Avail_Sub_V1
	FROM (
		SELECT a.* ,
		STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Sub b
				WHERE a.Acq_Deal_Rights_Code = b.Acq_Deal_Rights_Code
					AND a.Rights_Start_Date = b.Rights_Start_Date 
					AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
					AND a.Is_Exclusive = b.Is_Exclusive
					AND ISNULL(a.Sub_License_Code, 0) = ISNULL(b.Sub_License_Code, 0)
				FOR XML PATH('')
			), 1, 1, ''
		) Sub_Language_Codes
		FROM (
			SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code
			FROM #Avail_Sub
		) AS a
	) AS MainOutput

	DROP TABLE #Avail_Sub

	PRINT 'PA-STEP-5 UPDATE Dubbing Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1, #Avail_Dubb_V1 ' + convert(varchar(30),getdate() ,109)
	SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Dubb_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Dubb_Language_Names
	INTO #Avail_Dubb_V1
	FROM (
		SELECT a.* ,
		STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Dubb b
				WHERE a.Acq_Deal_Rights_Code = b.Acq_Deal_Rights_Code
					AND a.Rights_Start_Date = b.Rights_Start_Date 
					AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
					AND a.Is_Exclusive = b.Is_Exclusive
					AND ISNULL(a.Sub_License_Code, 0) = ISNULL(b.Sub_License_Code, 0)
				FOR XML PATH('')
			), 1, 1, ''
		) Dubb_Language_Codes
		FROM (
			SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code
			FROM #Avail_Dubb
		) AS a
	) AS MainOutput
	END

	DROP TABLE #Avail_Dubb

	print 'PA-STEP-6 UPDATE Language Names in  in #Avail_TitLang_V1, #Avail_Sub_V1, #Avail_Dubb_V1  ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		-----------------Get Language Names for #Temp_Main
		CREATE TABLE #Temp_Language_Names(
			Language_Codes VARCHAR(MAX),
			Language_Names NVARCHAR(MAX)
		)

		--INSERT INTO #Temp_Language_Names(Language_Codes)
		--SELECT DISTINCT Language_Code FROM #Avail_TitLang
	
		INSERT INTO #Temp_Language_Names(Language_Codes)
		SELECT DISTINCT Sub_Language_Codes FROM #Avail_Sub_V1
	
		INSERT INTO #Temp_Language_Names(Language_Codes)
		SELECT DISTINCT Dubb_Language_Codes FROM #Avail_Dubb_V1 WHERE Dubb_Language_Codes NOT IN (
			SELECT Language_Codes FROM #Temp_Language_Names
		)

		UPDATE #Temp_Language_Names SET Language_Names = [dbo].[UFN_Get_Language_With_Parent](Language_Codes)
	
		UPDATE tm SET tm.Title_Language_Names = lang.Language_Name
		FROM #Avail_TitLang tm 
		INNER JOIN Language lang ON tm.Language_Code = lang.Language_Code

		UPDATE tm SET tm.Sub_Language_Names = tml.Language_Names FROM #Avail_Sub_V1 tm 
		INNER JOIN #Temp_Language_Names tml ON tm.Sub_Language_Codes = tml.Language_Codes

		UPDATE tm SET tm.Dubb_Language_Names = tml.Language_Names FROM #Avail_Dubb_V1 tm 
		INNER JOIN #Temp_Language_Names tml ON tm.Dubb_Language_Codes = tml.Language_Codes

	END
	
	PRINT 'PA-STEP-7 Populate #Temp_Dates ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	CREATE INDEX IX_Avail_Dubb_V1 ON #Avail_Dubb_V1(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Sub_V1 ON #Avail_Sub_V1(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	
	--CREATE TABLE #Temp_Dates
	--(
	--	Avail_Acq_Code INT, 
	--	Right_Start_Date DATETIME, 
	--	Rights_End_Date DATETIME, 
	--	Is_Exclusive INT,
	--	Sub_License_Code INT
	--)

	--INSERT INTO #Temp_Dates (Acq_Deal_Rights_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code )
	--SELECT AT.Acq_Deal_Rights_Code, AT.Right_Start_Date, AT.Rights_End_Date, At.Is_Exclusive, AT.Sub_License_Code 
	--FROM #Avail_TitLang AT
	--UNION 
	--SELECT ASUB.Acq_Deal_Rights_Code, ASUB.Right_Start_Date, ASUB.Rights_End_Date, ASUB.Is_Exclusive, ASUB.Sub_License_Code 
	--FROM #Avail_Sub_V1 ASUB 
	--UNION
	--SELECT ADUB.Acq_Deal_Rights_Code, ADUB.Right_Start_Date, ADUB.Rights_End_Date, ADUB.Is_Exclusive, ADUB.Sub_License_Code 
	--FROM #Avail_Dubb_V1 ADUB 
	--END
		
	--PRINT 'PA-STEP-8 Populate #Temp_Main ' + convert(varchar(30),getdate() ,109)
	--BEGIN

	--CREATE INDEX IX_Temp_Dates ON #Temp_Dates(Avail_Acq_Code)

	--SELECT AA.Avail_Acq_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code, TD.Right_Start_Date, TD.Rights_End_Date, TD.Is_Exclusive, TD.Sub_License_Code
	--, AA.Acq_Deal_Rights_Code
	--INTO #TMP_MAIN
	--FROM #Temp_Dates TD
	--INNER JOIN #Avail_Acq AA ON AA.Avail_Acq_Code = TD.Avail_Acq_Code
	--END

	--DROP TABLE #Temp_Dates

	PRINT 'PA-STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	ALTER TABLE #Avail_Acq ADD Country_Cd_Str VARCHAR(2000),
						  Region_Type CHAR(1),
						  Country_Names NVARCHAR(2000)
	
	
	UPDATE t2
	SET t2.Country_Cd_Str =  STUFF
	(
		(
			SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #Avail_Acq t1 
			WHERE t1.Title_Code = t2.Title_Code
				  AND t1.Platform_Code = t2.Platform_Code
				  AND t1.Rights_Start_Date = t2.Rights_Start_Date
				  AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')
				  AND t1.Is_Exclusive = t2.Is_Exclusive
				  AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
			FOR XML PATH('')
		), 1, 1, ''
	)
	FROM #Avail_Acq t2
	

	CREATE TABLE #Temp_Country_Names(
		Territory_Code INT,
		Country_Cd INT,
		Country_Codes VARCHAR(2000),
		Country_Names NVARCHAR(MAX)
	)
	
	INSERT INTO #Temp_Country_Names(Country_Codes, Country_Names)
	SELECT DISTINCT Country_Cd_Str, NULL FROM #Avail_Acq
	
	
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
				SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #Temp_Country
				FOR XML PATH('')
			), 1, 1, ''
		)
			
		DELETE FROM #Avail_Acq WHERE Country_Cd_Str <> @CntryStr
				
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
		
		DELETE FROM #Avail_Acq WHERE Country_Cd_Str NOT IN (SELECT Country_Codes FROM #Temp_Country_Names)
	END
	
	PRINT 'PA-STEP-9.3- Country Names ' + convert(varchar(30),getdate() ,109)
	-----------------UPDATE Country / Territory Names
	
	UPDATE #Temp_Country_Names SET Country_Names = [dbo].[UFN_Get_Territory](Country_Codes)
	
	UPDATE tmc SET tmc.Territory_Code = ter.Territory_Code FROM Territory ter 
	INNER JOIN #Temp_Country_Names tmc ON ter.Territory_Name = tmc.Country_Names AND ISNULL(tmc.Country_Names, '') <> ''

	UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'T', tm.Country_Code = tmc.Territory_Code
	FROM #Avail_Acq tm 
	INNER JOIN #Temp_Country_Names tmc ON tm.Country_Cd_Str = tmc.Country_Codes AND ISNULL(tmc.Country_Names, '') <> ''

	
	TRUNCATE TABLE #Temp_Country_Names
	
	INSERT INTO #Temp_Country_Names(Country_Cd)
	SELECT DISTINCT Country_Code FROM #Avail_Acq Where ISNULL(Country_Names, '') = ''
	
	UPDATE tmc SET tmc.Country_Names = cur.Country_Name FROM Country cur
	INNER JOIN #Temp_Country_Names tmc ON cur.Country_Code = tmc.Country_Cd

	UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'C' FROM #Avail_Acq tm 
	INNER JOIN #Temp_Country_Names tmc ON tm.Country_Code = tmc.Country_Cd AND ISNULL(tm.Country_Names, '') = '' AND ISNULL(Region_Type, '') <> 'T' 
	
	PRINT 'PA-STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
	---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS

	SELECT Acq_Deal_Rights_Code, Title_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, 
						   Platform_Code, Country_Cd_Str, Country_Names, Region_Type 
	INTO #Temp_Main_Ctr
	FROM (
		SELECT ROW_NUMBER() OVER(
									PARTITION BY Acq_Deal_Rights_Code ,Title_Code, Platform_Code, Country_Code, Region_Type, Rights_Start_Date, Rights_End_Date
									, Is_Exclusive, Sub_License_Code
									ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type DESC
								) RowId, * 
		FROM #Avail_Acq tm
	) AS a WHERE RowId = 1
	
	---------- END

	--DROP TABLE #TMP_MAIN
	
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
				SELECT DISTINCT ',' + CAST(Platform_Code As Varchar) FROM #Temp_Main_Ctr t1 
				Where t1.Rights_Start_Date = t2.Rights_Start_Date
					AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')		
					AND t1.Title_Code = t2.Title_Code
					AND ISNULL(t1.Country_Cd_Str, 0) = ISNULL(t2.Country_Cd_Str, 0)
					AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
					AND t1.Is_Exclusive = t2.Is_Exclusive
					AND t1.Region_Type = t2.Region_Type
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

	print 'PA-STEP-11 UPDATE LANGUAGE Names in #Temp_Main_Ctr' + convert(varchar(30),getdate() ,109)	
	BEGIN		

	ALTER TABLE #Temp_Main_Ctr 
	ADD Title_Language_Names Varchar(2000),
		Sub_Language_Names Varchar(2000),
		Dub_Language_Names Varchar(2000)
	
	
	UPDATE tms
	SET tms.Title_Language_Names = at.Title_Language_Names
	FROM #Temp_Main_Ctr tms
	INNER JOIN #Avail_TitLang at ON at.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND at.Rights_Start_Date  = tms.Rights_Start_Date
		AND IsNull(at.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND at.Is_Exclusive  = tms.Is_Exclusive
		AND at.Sub_License_Code  = tms.Sub_License_Code
				
	

	UPDATE tms
	SET tms.Sub_Language_Names = asub.Sub_Language_Names
	FROM #Temp_Main_Ctr tms
	INNER JOIN #Avail_Sub_v1 asub ON asub.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND asub.Rights_Start_Date  = tms.Rights_Start_Date
		AND IsNull(asub.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND asub.Is_Exclusive  = tms.Is_Exclusive
		AND asub.Sub_License_Code  = tms.Sub_License_Code

	UPDATE tms
	SET tms.Dub_Language_Names = ad.Dubb_Language_Names
	FROM #Temp_Main_Ctr tms
	INNER JOIN #Avail_Dubb_V1 ad ON ad.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND ad.Rights_Start_Date  = tms.Rights_Start_Date
		AND IsNull(ad.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND ad.Is_Exclusive  = tms.Is_Exclusive
		AND ad.Sub_License_Code  = tms.Sub_License_Code
   END		
   
   DROP TABLE #Avail_Sub_V1
   DROP TABLE #Avail_Dubb_V1
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

	print 'PA-STEP-13 Restrication Remarks' + convert(varchar(30),getdate() ,109)	
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN
		SELECT DISTINCT Acq_Deal_Rights_Code, Remarks, Rights_Remarks, 
				Restriction_Remarks,
				Sub_Deal_Restriction_Remark
		INTO #Temp_Right_Remarks
		FROM #Temp_Right

		--Select * from #Temp_Right_Remarks
	END

	DROP TABLE #Temp_Country_Names
	DROP TABLE #Temp_Language_Names
		
	UPDATE #Temp_Main_Ctr SET Rights_Start_Date = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE Rights_Start_Date < GETDATE()

	------------------ Final Output
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN

	SELECT DISTINCT 
			trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Country_Names AS Country_Name, 
			CAST(tm.Rights_Start_Date AS DATETIME) Rights_Start_Date, 
			CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Title_Language_Names, Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark,
			trr.Remarks, trr.Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
		FROM 
			#Temp_Main_Ctr tm
			INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = tm.Acq_Deal_Rights_Code
			INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
			INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
			LEFT JOIN Sub_License sl ON tm.Sub_License_Code = sl.Sub_License_Code

		DROP TABLE #Temp_Right_Remarks
	END
	ELSE
	BEGIN
		SELECT DISTINCT 
			trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Country_Names AS Country_Name, 
			CAST(tm.Rights_Start_Date AS DATETIME) Rights_Start_Date, 
			CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Title_Language_Names , Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			'' Restriction_Remark, '' Sub_Deal_Restriction_Remark,
			'' Remarks, '' Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
		FROM #Temp_Main_Ctr tm
		INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		LEFT JOIN Sub_License sl ON ISNULL(tm.Sub_License_Code, 0) = ISNULL(sl.Sub_License_Code, 0)
	END
	------------------ END


	DROP TABLE #Temp_Title
	DROP TABLE #Temp_Main_Ctr
	DROP TABLE #Temp_Titles
	DROP TABLE #Temp_Right
	DROP TABLE #Temp_Country
	DROP TABLE #Temp_Platform
	DROP TABLE #Temp_Title_Language
	DROP TABLE #Temp_Language
	DROP TABLE #Avail_Acq
	DROP TABLE #Avail_TitLang
END
END
END
/*
	EXEC [USP_Report_NoSublicensing]
	@Title_Code ='0',
	@Platform_Code ='60,61,62,63,64,65,66,67,69,71,72,73,74,75,76,145,146,78,79,147,152,154,38,39,40,41,42,43,44,45,47,49,50,51,52,53,54,149,150,56,57,151,155,157',
	@Country_Code ='0',
	@Is_Original_Language ='true',
	@Title_Language_Code ='0',
	@Date_Type ='FL',
	@StartDate ='23-Sep-2015',
	@EndDate ='23-Sep-2015',
	@RestrictionRemarks ='false',
	@OthersRemarks ='false',--D
	@Platform_ExactMatch ='False', 
	@MustHave_Platform ='0', 
	@Exclusivity ='B' ,
	@SubLicense_Code ='0',
	@Region_ExactMatch ='false',
	@Region_MustHave ='0',
	@Subtit_Language_Code ='0',
	@Dubbing_Subtitling='0',
	@StartMonth=0,
	@EndYear=0,
	@Dubbing_Language_Code='0',
	@BU_Code=1,
	@Is_SubLicense='N'
	
*/


