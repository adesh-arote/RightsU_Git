CREATE PROCEDURE [dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]
(
--DECLARE
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
	@Deal_Type_Code INT = 1 ,
	@Episode_From INT=1,
	@Episode_To INT=1,
	@Is_IFTA_Cluster CHAR(1) = 'N'
)
AS
-- =============================================
-- Author :	RESHMA KUNJAL
-- Create date: 08 MARCH 2016
-- Description:	This Procedure is to generate Platform wise Acquisition data With "Availability Report" paramters and @Is_SubLicense parameter
-- And Deals which are Approved
-- =============================================
BEGIN
	Set @Episode_From = Case When IsNull(@Episode_From, 0) < 1 Then 1 Else @Episode_From End
	Set @Episode_To = Case When IsNull(@Episode_To, 0) < 1 Then 100000 Else @Episode_To End

	--select 	@title_code='36432', 
	--@is_original_language='true', 
	--@title_language_code='',
	--@date_type ='FL',
	--@startdate ='15-Feb-2021',
	--@enddate ='',
	--@platform_code='0', 
	--@platform_exactmatch='', 
	--@musthave_platform='', 
	--@is_ifta_cluster = 'N',
 --   @country_code='0', 
	--@region_exactmatch='',
	--@region_musthave='0',
	--@region_exclusion='0',

	--@dubbing_subtitling='D',
	--@subtit_language_code='',--'1,10,100,101,102,103,104,105,106,107,108,109,11,110,111,112,113,114,115,116,12,13,14,15,17,18,19,2,20,21,22,23,24,25,26,27,28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,41,42,43,45,46,47,48,49,5,50,51,52,53,54,55,56,57,58,59,6,60,61,62,63,64,65,66,67,68,69,7,70,71,72,73,74,75,76,77,78,79,8,80,81,82,83,84,85,86,87,88,89,9,90,91,92,93,94,95,96,97,98,99', 
	----@subtitling_exactmatch = '', --mh/em/false
	----@subtitling_musthave = '',
	----@subtitling_exclusion = '0',
	
	--@dubbing_language_code='', 
	----@dubbing_exactmatch = '',
	----@dubbing_musthave = '',
	----@dubbing_exclusion = '0',

	--@exclusivity='B',
	--@sublicense_code='0', --comma   separated sublicensing code. 0-no sub licensing ,
	--@restrictionremarks='false',
	--@othersremarks='false',
	--@bu_code=0,	
	--@Is_SubLicense = 'N',
	--@Is_Approved  = 'A',
	--@Deal_Type_Code = 11 ,
	--@Episode_From = 1,
	--@Episode_To =1
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
	SELECT number AS Title_Code INTO #Temp_Title_Neo FROM dbo.fn_Split_withdelemiter(@Title_Code, ',') WHERE number NOT IN('0', '')
	SELECT CAST(number AS INT) number INTO #Temp_Platform_Neo FROM dbo.fn_Split_withdelemiter(@Platform_Code,',') WHERE number NOT IN('0', '')
	
	------------------ END
			
	----------------- Country Population 
	CREATE TABLE #Temp_Country_Neo(
		Country_Code INT
	)

	INSERT INTO #Temp_Country_Neo
	SELECT DISTINCT number FROM fn_Split_withdelemiter(@Country_Code , ',') WHERE number NOT LIKE 'T%' AND number NOT IN('0')
	
	IF(@Is_IFTA_Cluster = 'N')
	BEGIn
		INSERT INTO #Temp_Country_Neo
		SELECT DISTINCT Country_Code FROM Territory_Details td WHERE td.Territory_Code IN (
			SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Code, ',') WHERE number LIKE 'T%' AND number NOT IN('0')
		) AND td.Country_Code NOT IN (
			SELECT tc.Country_Code FROM #Temp_Country_Neo tc
		)
		AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
		AND td.Country_Code NOT IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion, ',') WHERE number NOT IN ( '0', ''))
	END
	ELSE IF(@Is_IFTA_Cluster = 'Y')
	BEGIn
		INSERT INTO #Temp_Country_Neo
		SELECT DISTINCT Country_Code FROM Report_Territory_Country td WHERE td.Report_Territory_Code IN (
			SELECT REPLACE(number, 'T', '') FROM fn_Split_withdelemiter(@Country_Code, ',') WHERE number LIKE 'T%' AND number NOT IN('0')
		) AND td.Country_Code NOT IN (
			SELECT tc.Country_Code FROM #Temp_Country_Neo tc
		)
		AND td.Country_Code IN (SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active,'N')='Y')
		AND td.Country_Code NOT IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Region_Exclusion, ',') WHERE number NOT IN ( '0', ''))
	END

	------------------ END
	
	----------------- Language Population 
	SELECT @Subtit_Language_Code = LTRIM(RTRIM(@Subtit_Language_Code)), @Title_Language_Code = LTRIM(RTRIM(@Title_Language_Code)), @Dubbing_Language_Code = LTRIM(RTRIM(@Dubbing_Language_Code))
		
	SELECT number INTO #Temp_Title_Language_Neo FROM dbo.fn_Split_withdelemiter(@Title_Language_Code,',') WHERE number NOT IN('0', '')
			
	CREATE TABLE #Temp_Language_Neo(
		Language_Code INT,
		Language_Type CHAR(1)
	)

	INSERT INTO #Temp_Language_Neo
	SELECT REPLACE(number, 'L', ''), 'S'  FROM fn_Split_withdelemiter(@Subtit_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	INSERT INTO #Temp_Language_Neo
	SELECT REPLACE(number, 'L', ''), 'D'  FROM fn_Split_withdelemiter(@Dubbing_Language_Code, ',') --WHERE number LIKE 'L%' AND number NOT IN('0', '')
	
	SELECT CAST(number AS INT) SubLicense_Code INTO #Tmp_SL_Neo FROM fn_Split_withdelemiter(@SubLicense_Code, ',') WHERE number NOT IN('0', '')

	------------------ END

	DELETE FROM #Temp_Country_Neo WHERE Country_Code = 0
	DELETE FROM #Temp_Language_Neo WHERE Language_Code = 0
	DELETE FROM #Temp_Title_Neo WHERE Title_Code = 0
	DELETE FROM #Temp_Platform_Neo WHERE number = 0
	DELETE FROM #Temp_Title_Language_Neo WHERE number = 0
		
	IF NOT EXISTS(SELECT * FROM #Temp_Country_Neo)
	BEGIN
		INSERT INTO #Temp_Country_Neo
		SELECT c.Country_Code FROM Country c WHERE ISNULL(c.Is_Active, 'N') = 'Y' and c.Country_Code <> 3
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Language_Neo WHERE Language_Type = 'S')
	BEGIN
		INSERT INTO #Temp_Language_Neo
		SELECT Language_Code, 'S' FROM Language
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Language_Neo WHERE Language_Type = 'D')
	BEGIN
		INSERT INTO #Temp_Language_Neo
		SELECT Language_Code, 'D' FROM Language 
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Title_Neo)
	BEGIN
		INSERT INTO #Temp_Title_Neo
		SELECT DISTINCT Title_Code FROM Acq_Deal_Movie
	END
	
	IF NOT EXISTS(SELECT * FROM #Temp_Title_Language_Neo)
	BEGIN
		INSERT INTO #Temp_Title_Language_Neo
		SELECT Language_Code FROM Language
	END
		
	IF NOT EXISTS(SELECT * FROM #Temp_Platform_Neo)
	BEGIN
		INSERT INTO #Temp_Platform_Neo (number)
		SELECT Platform_Code FROM Platform WHERE Is_Last_Level = 'Y'
	END
	
	IF NOT EXISTS(SELECT * FROM #Tmp_SL_Neo)
	BEGIN
		INSERT INTO #Tmp_SL_Neo
		SELECT Sub_License_Code FROM Sub_License
	END
	END

	PRINT 'PA-STEP-2 Populate @Temp_Right ' + convert(varchar(30),getdate() ,109)
	BEGIN
	-----------------Query to get rights information related to title
	CREATE TABLE #Temp_Right_Neo 
	(
		Acq_Deal_Code INT, 
		Acq_Deal_Rights_Code INT, 
		Restriction_Remarks NVARCHAR(MAX), 
		Platform_Code INT, 
		Title_Code INT,
		Is_Master_Deal CHAR(1), 
		Remarks NVARCHAR(4000), 
		Rights_Remarks NVARCHAR(4000),
		Sub_Deal_Restriction_Remark NVARCHAR(MAX), 
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Is_Exclusive CHAR(1),
		Sub_License_Code INT,
		Episode_From INT,
		Episode_To INT,
		Is_Title_Language_Right CHAR(1),
		Category_Name VARCHAR(1000),
		Deal_Type_Name VARCHAR(1000)
	)

	
	INSERT INTO #Temp_Right_Neo(Acq_Deal_Code, Acq_Deal_Rights_Code, Restriction_Remarks, Platform_Code, Title_Code,
		   Is_Master_Deal, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From, Episode_To, Is_Title_Language_Right,Category_Name,Deal_Type_Name)
	SELECT ar.Acq_Deal_Code, ar.Acq_Deal_Rights_Code, ar.Restriction_Remarks, adrp.Platform_Code, ADRT.Title_Code,
		   ad.Is_Master_Deal, ad.Remarks, ad.Rights_Remarks, 
		   (STUFF((
			SELECT DISTINCT ',' + adr_Tmp.Restriction_Remarks 
			FROM Acq_Deal AD_Tmp
			INNER JOIN Acq_Deal_Rights ADR_Tmp ON adr_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
			WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
			(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = ad.Acq_Deal_Code)
			FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,'')) 
			, ar.Actual_Right_Start_Date, ar.Actual_Right_End_Date
			,ar.Is_Exclusive, ISNULL(ar.Sub_License_Code, 0)
			, adrt.Episode_From, adrt.Episode_To, ar.Is_Title_Language_Right
			,C.Category_Name,DT.Deal_Type_Name
	FROM Acq_Deal_Rights AS ar
	INNER JOIN Acq_Deal_Rights_Platform AS adrp ON adrp.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights_Title AS adrt ON adrt.Acq_Deal_Rights_Code = ar.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal ad ON ar.Acq_Deal_Code = ad.Acq_Deal_Code
	INNER JOIN Category C ON ad.Category_Code = C.Category_Code
	INNER JOIN Deal_Type DT ON ad.Deal_Type_Code = DT.Deal_Type_Code
	WHERE 
	ad.Is_Master_Deal = 'Y'
	AND ar.Is_Tentative = 'N'
	AND (ar.Is_Sub_License = @Is_SubLicense OR @Is_SubLicense = '')
	AND adrt.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title_Neo tt)
	AND adrp.Platform_Code IN (SELECT number FROM #Temp_Platform_Neo) 
	AND ((ar.Sub_License_Code IN (SELECT SubLicense_Code  FROM #Tmp_SL_Neo) AND @Is_SubLicense = 'Y') OR @Is_SubLicense = 'N' OR @Is_SubLicense = '')
	AND (ad.Business_Unit_Code = CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0)
	AND ((ad.Deal_Workflow_Status = @Is_Approved) OR @Is_Approved = '')
	AND (ad.Deal_Type_Code = @Deal_Type_Code OR (ad.Deal_Type_Code <> 1 AND @Deal_Type_Code <> 1) OR @Deal_Type_Code=0)
	AND (
		adrt.Episode_From Between @Episode_From And @Episode_To Or
		adrt.Episode_To Between @Episode_From And @Episode_To Or
		@Episode_From Between adrt.Episode_From And adrt.Episode_To Or
		@Episode_To Between adrt                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                .Episode_From And adrt.Episode_To
	)
	------------------ END
	END

	PRINT 'PA-STEP-3 Populate #Avail_Acq_Neo  ' + convert(varchar(30),getdate() ,109)
	BEGIN
	                                                                                                                                                                                                                                                                                                                                                                                                   
	-----------------Query to get Avail information related to Title ,Platform AND Country
	CREATE TABLE #Avail_Acq_Neo 
	(
		Acq_Deal_Rights_Code INT, 
		Title_Code INT,
		Platform_Code INT, 
		Country_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Is_Exclusive CHAR(1),
		Sub_License_Code INT,
		Episode_From INT,
		Episode_To INT,
		Is_Title_Language_Right CHAR(1),
		Category_Name VARCHAR(1000),
		Deal_Type_Name VARCHAR(1000) 
	)
		
	------------------ END
	END
	
	IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
	BEGIN
		
		INSERT INTO #Avail_Acq_Neo(Acq_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code, Episode_From, Episode_To, Is_Title_Language_Right,Category_Name,Deal_Type_Name)
		SELECT DISTINCT tr.Acq_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
					   CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
					   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0)
					   , Episode_From, Episode_To, tr.Is_Title_Language_Right,tr.Category_Name,tr.Deal_Type_Name
		FROM 
		#Temp_Right_Neo tr 
		INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title_Neo tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform_Neo) )
		AND ((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)))
		AND (ISNULL(tr.Rights_Start_Date, '9999-12-31')  <= @StartDate AND ISNULL(tr.Rights_End_Date, '9999-12-31') >=  @EndDate)
		AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	ELSE
	BEGIN

		INSERT INTO #Avail_Acq_Neo(Acq_Deal_Rights_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
		Sub_License_Code, Episode_From, Episode_To, Is_Title_Language_Right,Category_Name,Deal_Type_Name)
		SELECT DISTINCT tr.Acq_Deal_Rights_Code , tr.Title_Code, tr.Platform_Code, 
			   CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
			   tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0), Episode_From, Episode_To, tr.Is_Title_Language_Right,tr.Category_Name,tr.Deal_Type_Name
		FROM 
		#Temp_Right_Neo tr 
		INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
		LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
		WHERE tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title_Neo tt) 
		AND (tr.Platform_Code IN (SELECT number FROM #Temp_Platform_Neo) )
		AND ((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country_Neo tc)))
		AND ((ISNULL(tr.Rights_End_Date, '9999-12-31') BETWEEN @StartDate AND  @EndDate)
			OR (ISNULL(tr.Rights_Start_Date, '9999-12-31') BETWEEN @StartDate AND @EndDate)
			OR (@StartDate BETWEEN  ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31'))
			OR (@EndDate BETWEEN ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31')))
		AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

	END
	

	PRINT 'PA-STEP-4 Populate #Avail_TitLang_Neo' + convert(varchar(30),getdate() ,109)
	BEGIN
	CREATE TABLE #Avail_TitLang_Neo 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code INT,
		Sub_License_Code INT,
		Is_Exclusive CHAR(1),
		Title_Language_Names NVARCHAR(400),
		Episode_From INT,
		Episode_To INT
	)

	CREATE TABLE #Avail_Sub_Neo 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code VARCHAR(MAX),
		Sub_License_Code INT,
		Is_Exclusive CHAR(1),
		Episode_From INT,
		Episode_To INT,
		Sub_Language_Names NVARCHAR(MAX)
	)

	CREATE TABLE #Avail_Dubb_Neo 
	(
		Acq_Deal_Rights_Code INT,
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Language_Code VARCHAR(MAX),
		Sub_License_Code INT,
		Is_Exclusive CHAR(1),
		Episode_From INT,
		Episode_To INT,
		Dubb_Language_Names NVARCHAR(MAX)
	)
	-----------------Populate Title Avail for Title Languages
	
	CREATE INDEX IX_TMP_Avail_Acq ON #Avail_Acq_Neo(Acq_Deal_Rights_Code)
	CREATE INDEX IX_Temp_Language ON #Temp_Language_Neo(Language_Code)
		
	IF(@Is_Original_Language = 1) 
	BEGIN
			
		INSERT INTO #Avail_TitLang_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, tit.Title_Language_Code
			, AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To
		FROM #Avail_Acq_Neo AA
		INNER JOIN Title tit ON AA.Title_Code = tit.Title_Code
		INNER JOIN #Temp_Title_Language_Neo TTL ON TTL.number = tit.Title_Language_Code
		WHERE AA.Is_Title_Language_Right = 'Y'
		
	END

	PRINT 'PA-STEP-4.1 Populate #Avail_Sub_Neo  ' + convert(varchar(30),getdate() ,109)
	-----------------Populate Title Avail for Subtitling Languages
	IF EXISTS(SELECT * WHERE 'S' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))
	BEGIN
		
		Select Distinct Acq_Deal_Rights_Code, STUFF((
			Select Distinct ',' + 
			CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrs.Language_Code End AS VARCHAR) From Acq_Deal_Rights_Subtitling adrs
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code
			WHERE adrs.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
			And (
				(
					Language_Type = 'G' And lgd.Language_Code IN (
						Select tl.Language_Code From #Temp_Language_Neo TL Where TL.Language_Type = 'S'
					)
				) OR
				(
					Language_Type <> 'G' And adrs.Language_Code IN (
						Select TL1.Language_Code From #Temp_Language_Neo TL1 Where TL1.Language_Type = 'S'
					)
				)
			)
			FOR XML PATH(''),type).value('.', 'NVARCHAR(max)'),1,1,''
		)Sub_Langs InTo #Temp_Subs
		From (
			Select Distinct Acq_Deal_Rights_Code From #Avail_Acq_Neo 
		) As a
		
		print '1'
		
		INSERT INTO #Avail_Sub_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Sub_Language_Names)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		--CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
		AAS.Sub_Langs,
		AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
		FROM 
		#Temp_Subs AAS
		INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = AAS.Acq_Deal_Rights_Code
		WHERE ISNULL(AAS.Sub_Langs,'') <>''
			
		print '2'	
		Drop Table #Temp_Subs
	END

	-----------------Populate Title Avail for Dubbing Languages
	PRINT 'PA-STEP-4.2 Populate #Avail_Dubb_Neo  ' + convert(varchar(30),getdate() ,109)
	--RETURN
	IF(EXISTS(SELECT * WHERE 'D' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling,','))))
	BEGIN
				
		Select Distinct Acq_Deal_Rights_Code, STUFF((
			Select Distinct ',' + 
			CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrd.Language_Code End AS VARCHAR) From Acq_Deal_Rights_Dubbing adrd
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrd.Language_Group_Code
			WHERE adrd.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
			And (
				(
					Language_Type = 'G' And lgd.Language_Code IN (
						Select tl.Language_Code From #Temp_Language_Neo TL Where TL.Language_Type = 'D'
					)
				) OR
				(
					Language_Type <> 'G' And adrd.Language_Code IN (
						Select TL1.Language_Code From #Temp_Language_Neo TL1 Where TL1.Language_Type = 'D'
					)
				)
			)
			FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
		)Dub_Langs InTo #Temp_Dubs
		From (
			Select Distinct Acq_Deal_Rights_Code From #Avail_Acq_Neo 
		) As a		
		
		INSERT INTO #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Dubb_Language_Names)
		SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		--CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
		AAD.Dub_Langs,
		AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
		FROM 
		#Temp_Dubs AAD
		INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = AAD.Acq_Deal_Rights_Code
		WHERE ISNULL(AAD.Dub_Langs,'') <>''
			
		print '2'	
		Drop Table #Temp_Dubs		
				
		--INSERT INTO #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To)
		--SELECT DISTINCT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
		--CASE WHEN aaD.Language_Type= 'G' THEN lgd.Language_Code ELSE AAD.Language_Code END ,
		--AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To
		--FROM 
		--Acq_Deal_Rights_Dubbing AAD
		--INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = AAD.Acq_Deal_Rights_Code
		--LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = aad.Language_Group_Code AND AAD.Language_Type= 'G' 
		--INNER JOIN #Temp_Language_Neo TL ON 
		--((TL.Language_Code = AAD.Language_Code AND AAD.Language_Type = 'L') OR (TL.Language_Code = lgd.Language_Code AND aaD.Language_Type = 'G'))
		--AND TL.Language_Type = 'D'

	END
	

	CREATE INDEX IX_Avail_TitLang ON #Avail_TitLang_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Dubb ON #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Sub ON #Avail_Sub_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)

	PRINT 'PA-STEP-5 UPDATE Subtitling Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1_Neo, #Avail_Dubb_V1_Neo ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	--SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Sub_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Sub_Language_Names,
	--Episode_From, Episode_To
	--INTO #Avail_Sub_V1_Neo
	--FROM (
	--	SELECT a.* ,
	--	STUFF
	--	(
	--		(
	--			SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Sub_Neo b
	--			WHERE a.Acq_Deal_Rights_Code = b.Acq_Deal_Rights_Code
	--				AND a.Rights_Start_Date = b.Rights_Start_Date 
	--				AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
	--				AND a.Is_Exclusive = b.Is_Exclusive
	--				AND ISNULL(a.Sub_License_Code, 0) = ISNULL(b.Sub_License_Code, 0)
	--				AND ISNULL(a.Episode_From, 0) = ISNULL(b.Episode_From, 0)
	--				AND ISNULL(a.Episode_To, 0) = ISNULL(b.Episode_To, 0)
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	) Sub_Language_Codes
	--	FROM (
	--		SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From,  Episode_To
	--		FROM #Avail_Sub_Neo
	--	) AS a
	--) AS MainOutput

	--DROP TABLE #Avail_Sub_Neo

	PRINT 'PA-STEP-5 UPDATE Dubbing Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1_Neo, #Avail_Dubb_V1_Neo ' + convert(varchar(30),getdate() ,109)
	--SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Dubb_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Dubb_Language_Names
	--,Episode_From, Episode_To
	--INTO #Avail_Dubb_V1_Neo
	--FROM (
	--	SELECT a.* ,
	--	STUFF
	--	(
	--		(
	--			SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Dubb_Neo b
	--			WHERE a.Acq_Deal_Rights_Code = b.Acq_Deal_Rights_Code
	--				AND a.Rights_Start_Date = b.Rights_Start_Date 
	--				AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
	--				AND a.Is_Exclusive = b.Is_Exclusive
	--				AND ISNULL(a.Sub_License_Code, 0) = ISNULL(b.Sub_License_Code, 0)
	--				AND ISNULL(a.Episode_From, 0) = ISNULL(b.Episode_From, 0)
	--				AND ISNULL(a.Episode_To, 0) = ISNULL(b.Episode_To, 0)
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	) Dubb_Language_Codes
	--	FROM (
	--		SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From,  Episode_To
	--		FROM #Avail_Dubb_Neo
	--	) AS a
	--) AS MainOutput
	
	END

	--DROP TABLE #Avail_Dubb_Neo

	print 'PA-STEP-6 UPDATE Language Names in  in #Avail_TitLang_V1, #Avail_Sub_V1_Neo, #Avail_Dubb_V1_Neo  ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		-----------------Get Language Names for #Temp_Main
		CREATE TABLE #Temp_Language_Names_Neo(
			Language_Codes VARCHAR(MAX),
			Language_Names NVARCHAR(MAX)
		)

		--INSERT INTO #Temp_Language_Names_Neo(Language_Codes)
		--SELECT DISTINCT Language_Code FROM #Avail_TitLang_Neo
	
		INSERT INTO #Temp_Language_Names_Neo(Language_Codes)
		SELECT DISTINCT Language_Code FROM #Avail_Sub_Neo
		
	
		INSERT INTO #Temp_Language_Names_Neo(Language_Codes)
		SELECT DISTINCT Language_Code FROM #Avail_Dubb_Neo WHERE Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  NOT IN (
			SELECT Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  FROM #Temp_Language_Names_Neo
		)

		UPDATE #Temp_Language_Names_Neo SET Language_Names = [dbo].[UFN_Get_Language_With_Parent](Language_Codes)
	
		UPDATE tm SET tm.Title_Language_Names = lang.Language_Name
		FROM #Avail_TitLang_Neo tm 
		INNER JOIN Language lang ON tm.Language_Code = lang.Language_Code

		UPDATE tm SET tm.Sub_Language_Names = tml.Language_Names FROM #Avail_Sub_Neo tm 
		INNER JOIN #Temp_Language_Names_Neo tml ON tm.Language_Code  COLLATE SQL_Latin1_General_CP1_CI_AS = tml.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

		UPDATE tm SET tm.Dubb_Language_Names = tml.Language_Names FROM #Avail_Dubb_Neo tm 
		INNER JOIN #Temp_Language_Names_Neo tml ON tm.Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  = tml.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS 

	END
	
	PRINT 'PA-STEP-7 Populate #Temp_Dates ' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	CREATE INDEX IX_Avail_Dubb_V1 ON #Avail_Dubb_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Sub_V1 ON #Avail_Sub_Neo(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	
	CREATE TABLE #Temp_Dates
	(
		Acq_Deal_Rights_Code INT, 
		Right_Start_Date DATETIME, 
		Rights_End_Date DATETIME, 
		Is_Exclusive  CHAR(1),
		Sub_License_Code INT,
		Episode_From INT,
		Episode_To INT
	)

	INSERT INTO #Temp_Dates (Acq_Deal_Rights_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code ,Episode_From, Episode_To)
	SELECT AT.Acq_Deal_Rights_Code, AT.Rights_Start_Date, AT.Rights_End_Date, At.Is_Exclusive, AT.Sub_License_Code , AT.Episode_From, AT.Episode_To
	FROM #Avail_TitLang_Neo AT
	UNION 
	SELECT ASUB.Acq_Deal_Rights_Code, ASUB.Rights_Start_Date, ASUB.Rights_End_Date, ASUB.Is_Exclusive, ASUB.Sub_License_Code , ASUB.Episode_From, ASUB.Episode_To
	FROM #Avail_Sub_Neo ASUB 
	UNION
	SELECT ADUB.Acq_Deal_Rights_Code, ADUB.Rights_Start_Date, ADUB.Rights_End_Date, ADUB.Is_Exclusive, ADUB.Sub_License_Code , ADUB.Episode_From, ADUB.Episode_To
	FROM #Avail_Dubb_Neo ADUB 
	END
		
	PRINT 'PA-STEP-8 Populate #Temp_Main ' + convert(varchar(30),getdate() ,109)
	BEGIN

	CREATE INDEX IX_Temp_Dates ON #Temp_Dates(Acq_Deal_Rights_Code)

	--SELECT AA.Acq_Deal_Rights_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code, TD.Right_Start_Date, TD.Rights_End_Date, TD.Is_Exclusive, TD.Sub_License_Code
	--,AA.Episode_From, AA.Episode_To, CAST('' AS VARCHAR(2000)) AS Country_Cd_Str ,
	--CAST('' AS CHAR(1)) AS Region_Type , CAST('' AS VARCHAR(2000)) AS Country_Names ,AA.Category_Name,AA.Deal_Type_Name
	--INTO #TMP_MAIN
	--FROM #Temp_Dates TD
	--INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = TD.Acq_Deal_Rights_Code
	

	--DROP TABLE #Temp_Dates

	SELECT AA.Acq_Deal_Rights_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code, TD.Right_Start_Date, TD.Rights_End_Date, TD.Is_Exclusive, TD.Sub_License_Code
	,AA.Episode_From, AA.Episode_To, CAST('' AS VARCHAR(2000)) AS Country_Cd_Str ,
	hb.Acq_Deal_Rights_Holdback_Code, hb.Holdback_Type, 
	hb.Holdback_Release_Date, hb.Holdback_On_Platform_Code,
	CAST('' AS CHAR(1)) AS Region_Type , CAST('' AS VARCHAR(2000)) AS Country_Names,AA.Category_Name,AA.Deal_Type_Name
	INTO #TMP_MAIN
	FROM #Temp_Dates TD
	INNER JOIN #Avail_Acq_Neo AA ON AA.Acq_Deal_Rights_Code = TD.Acq_Deal_Rights_Code
	LEFT JOIN Acq_Deal_Rights_Holdback hb ON hb.Acq_Deal_Rights_Code = TD.Acq_Deal_Rights_Code
	AND ((hb.Holdback_Type = 'D' And CAST(ISNULL(TD.Rights_End_Date, '31Dec9999') AS DATETIME) > hb.Holdback_Release_Date 
	AND hb.Holdback_Release_Date > GETDATE()) Or hb.Holdback_Type = 'R')
	LEFT JOIN Acq_Deal_Rights_Holdback_Platform hbp On hb.Acq_Deal_Rights_Holdback_Code = hbp.Acq_Deal_Rights_Holdback_Code and AA.Platform_Code = hbp.Platform_Code
	LEFT JOIN Acq_Deal_Rights_Holdback_Territory hbt On hb.Acq_Deal_Rights_Holdback_Code = hbt.Acq_Deal_Rights_Holdback_Code AND AA.Country_Code = hbt.Country_Code
	Where (hb.Holdback_Type = 'D' And CAST(ISNULL(TD.Rights_End_Date, '31Dec9999') AS DATE) >= CAST(hb.Holdback_Release_Date as DATE) AND CAST(hb.Holdback_Release_Date as DATE) >= GETDATE()) Or hb.Holdback_Type = 'R'
	
	Select Distinct Title_Code InTo #MainTit_AP From #TMP_MAIN
	Select Distinct Acq_Deal_Rights_Holdback_Code, Holdback_Type, Cast('' As NVarchar(Max)) HBComments,  Cast(0 As Int) HB_Run_After_Release_No, Cast(0 As Int) HB_Run_After_Release_Units
		InTo #MainAH_AP 
		From #TMP_MAIN Where Acq_Deal_Rights_Holdback_Code Is Not Null
	
	
	Update thb
		Set thb.HBComments = Case When hb.HB_Run_After_Release_No < 0 Then 'Before ' Else 'After ' End + Cast (ABS(hb.HB_Run_After_Release_No) AS VArchar(10)) + 
							 Case hb.HB_Run_After_Release_Units When 1 Then ' Days' When 2 Then ' Weeks' When 3 Then ' Months' When 4 Then ' Years' End + ' On ',
			thb.HB_Run_After_Release_No = hb.HB_Run_After_Release_No,
			thb.HB_Run_After_Release_Units = hb.HB_Run_After_Release_Units
		From #MainAH_AP thb
		INNER JOIN Acq_Deal_Rights_Holdback hb On thb.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code

		Create Table #ReleaseCountry_AP(
			Title_Release_Code Int, 
			Country_Code Int
		)
		

		Insert InTo #ReleaseCountry_AP(Title_Release_Code, Country_Code)
		Select Distinct tr.Title_Release_Code, Country_Code 
		From Title_Release tr
		INNER JOIN #MainTit_AP mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Region trr On tr.Title_Release_Code = trr.Title_Release_Code And Country_Code Is Not Null
		UNION
		Select Distinct tr.Title_Release_Code, trd.Country_Code 
		From Title_Release tr
		INNER JOIN #MainTit_AP mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Region trr On tr.Title_Release_Code = trr.Title_Release_Code And Territory_Code Is Not Null
		INNER JOIN Territory_Details trd On trr.Territory_Code = trd.Territory_Code


		Update tm Set tm.Holdback_Release_Date = Case mh.HB_Run_After_Release_Units 
													  When 1 Then DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
													  When 2 Then DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
													  When 3 Then DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
													  When 4 Then DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
													  Else tr.Release_Date
												 End
		From Title_Release tr
		INNER JOIN #MainTit_AP mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Platforms trp On tr.Title_Release_Code = trp.Title_Release_Code
		INNER JOIN #ReleaseCountry_AP trc On tr.Title_Release_Code = trc.Title_Release_Code
		INNER JOIN #TMP_MAIN tm On tm.Title_Code = tr.Title_Code AND tm.Title_Code = mt.Title_Code 
								   AND tm.Holdback_On_Platform_Code = trp.Platform_Code AND tm.Country_Code = trc.Country_Code
								   AND tm.Holdback_Type = 'R'
		Inner Join #MainAH_AP mh On tm.Acq_Deal_Rights_Holdback_Code = mh.Acq_Deal_Rights_Holdback_Code
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
		INNER JOIN #MainTit_AP mt On tr.Title_Code = mt.Title_Code
		INNER JOIN Title_Release_Platforms trp On tr.Title_Release_Code = trp.Title_Release_Code
		INNER JOIN #ReleaseCountry_AP trc On tr.Title_Release_Code = trc.Title_Release_Code
		INNER JOIN #TMP_MAIN tm On tm.Title_Code = tr.Title_Code AND tm.Title_Code = mt.Title_Code 
								   AND tm.Holdback_On_Platform_Code = trp.Platform_Code AND tm.Country_Code = trc.Country_Code
								   AND tm.Holdback_Type = 'R'
		Inner Join #MainAH_AP mh On tm.Acq_Deal_Rights_Holdback_Code = mh.Acq_Deal_Rights_Holdback_Code
		Where 
			Case mh.HB_Run_After_Release_Units 
				When 1 Then DATEADD(DAY, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 2 Then DATEADD(WEEK, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 3 Then DATEADD(MONTH, mh.HB_Run_After_Release_No, tr.Release_Date)
				When 4 Then DATEADD(YEAR, mh.HB_Run_After_Release_No, tr.Release_Date)
				Else tr.Release_Date
			End < Cast(GetDate() As Date)

		Drop Table #MainTit_AP
		Drop Table #ReleaseCountry_AP
	END
	DROP TABLE #Temp_Dates
	------Holdback changes end-------

	PRINT 'PA-STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
	BEGIN
	
	--ALTER TABLE #TMP_MAIN ADD Country_Cd_Str VARCHAR(2000),
	--					  Region_Type CHAR(1),
	--					  Country_Names VARCHAR(2000)
	
	
	UPDATE t2
	SET t2.Country_Cd_Str =  STUFF
	(
		(
			SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #TMP_MAIN t1 
			WHERE t1.Title_Code = t2.Title_Code
				  AND t1.Platform_Code = t2.Platform_Code
				  AND t1.Right_Start_Date = t2.Right_Start_Date
				  AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')
				  AND t1.Is_Exclusive = t2.Is_Exclusive
				  AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
				  AND ISNULL(t1.Episode_From, 0) = ISNULL(t2.Episode_From, 0)
				  AND ISNULL(t1.Episode_To, 0) = ISNULL(t2.Episode_To, 0)
				  AND IsNull(t1.Acq_Deal_Rights_Holdback_Code, 0) = IsNull(t2.Acq_Deal_Rights_Holdback_Code, 0)
				  AND IsNull(t1.Holdback_Type, '') = IsNull(t2.Holdback_Type, '')
				  AND IsNull(t1.Holdback_Release_Date, '') = IsNull(t2.Holdback_Release_Date, '') 
				  AND IsNull(t1.Holdback_On_Platform_Code, 0) = IsNull(t2.Holdback_On_Platform_Code, 0) 
			FOR XML PATH('')
		), 1, 1, ''
	)
	FROM #TMP_MAIN t2
	

	CREATE TABLE #Temp_Country_Names_Neo(
		Row_ID INT IDENTITY(1,1),
		Territory_Code INT,
		Country_Cd INT,
		Country_Codes VARCHAR(2000),
		Country_Names NVARCHAR(MAX)
	)
	
	INSERT INTO #Temp_Country_Names_Neo(Country_Codes, Country_Names)
	SELECT DISTINCT Country_Cd_Str, NULL FROM #TMP_MAIN
	
	
	--SELECT * FROM #Temp_Country_Names_Neo
	PRINT 'PA-STEP-9.1- Country Exact Match ' + convert(varchar(30),getdate() ,109)
	-----------------IF Country = Exact Match
	IF(UPPER(@Region_ExactMatch) = 'EM')
	BEGIN
			
		DECLARE @CntryStr VARCHAR(1000) = ''
		SELECT @CntryStr = 
		STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Country_Code AS VARCHAR) FROM #Temp_Country_Neo
				FOR XML PATH('')
			), 1, 1, ''
		)
			
		DELETE FROM #TMP_MAIN WHERE Country_Cd_Str <> @CntryStr
				
	END
	
	PRINT 'PA-STEP-9.2- Country Must Have ' + convert(varchar(30),getdate() ,109)
	-----------------IF Country = Must Have
	IF(UPPER(@Region_ExactMatch) = 'MH')
	BEGIN
		
		TRUNCATE TABLE #Temp_Country_Neo

		DECLARE @Cntry_MustHaveCnt INT = 0
		
		INSERT INTO #Temp_Country_Neo
		SELECT number FROM dbo.fn_Split_withdelemiter(@Region_MustHave, ',') WHERE number NOT IN ('', '0')
		
		SELECT @Cntry_MustHaveCnt = COUNT(*) FROM #Temp_Country_Neo
				
		DELETE TM 
		FROM 
		#Temp_Country_Names_Neo TM WHERE TM.Country_Codes NOT IN
		(SELECT DISTINCT 
			Country_Codes  
		FROM #Temp_Country_Names_Neo tm
		WHERE 
			(SELECT COUNT(number) 
			FROM dbo.fn_Split_withdelemiter(Country_Codes, ',') 
			WHERE number NOT IN ('', '0') 
			AND number IN (SELECT c.Country_Code FROM #Temp_Country_Neo c)) >= @Cntry_MustHaveCnt	
		)
		
		DELETE FROM #TMP_MAIN WHERE Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS FROM #Temp_Country_Names_Neo)
	END
	
	PRINT 'PA-STEP-9.3- Country Names ' + convert(NVARCHAR(30),getdate() ,109)
	-----------------UPDATE Country / Territory Names
	
	UPDATE #Temp_Country_Names_Neo SET Country_Names = [dbo].[UFN_Get_Territory](Country_Codes)

	print '1'
	UPDATE tmc SET tmc.Territory_Code = ter.Territory_Code FROM Territory ter 
	INNER JOIN #Temp_Country_Names_Neo tmc ON ter.Territory_Name COLLATE SQL_Latin1_General_CP1_CI_AS = tmc.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS  AND ISNULL(tmc.Country_Names, '') <> ''

	UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'T', tm.Country_Code = tmc.Territory_Code
	FROM #TMP_MAIN tm 
	INNER JOIN #Temp_Country_Names_Neo tmc ON tm.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS = tmc.Country_Codes  COLLATE SQL_Latin1_General_CP1_CI_AS  AND ISNULL(tmc.Country_Names, '') <> ''

	print '2'
	TRUNCATE TABLE #Temp_Country_Names_Neo
	

	------------Commented by Aditya implementation on next line
	--INSERT INTO #Temp_Country_Names_Neo(Country_Cd)
	--SELECT DISTINCT Country_Code FROM #TMP_MAIN Where ISNULL(Country_Names, '') = ''
	
	--UPDATE tmc SET tmc.Country_Names = cur.Country_Name FROM Country cur
	--INNER JOIN #Temp_Country_Names_Neo tmc ON cur.Country_Code = tmc.Country_Cd

	--UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'C' FROM #TMP_MAIN tm 
	--INNER JOIN #Temp_Country_Names_Neo tmc ON tm.Country_Code = tmc.Country_Cd AND ISNULL(tm.Country_Names, '') = '' AND ISNULL(Region_Type, '') <> 'T' 

	INSERT INTO #Temp_Country_Names_Neo(Country_Codes)
	SELECT DISTINCT Country_Cd_Str FROM #TMP_MAIN Where ISNULL(Country_Names, '') = ''

	UPDATE tmc SET tmc.Country_Names = c.Region_Name FROM  #Temp_Country_Names_Neo tmc 
	Cross Apply DBO.UFN_Get_Indiacast_Report_Country(tmc.Country_Codes, tmc.Row_ID) c

	UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'C' FROM #TMP_MAIN tm 
	INNER JOIN #Temp_Country_Names_Neo tmc ON tm.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS = tmc.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS AND ISNULL(tm.Country_Names, '') = '' AND ISNULL(Region_Type, '') <> 'T' 
	

	PRINT 'PA-STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
	---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS

	SELECT Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, 
						   Platform_Code, Country_Cd_Str, Country_Names, Region_Type , Episode_From, Episode_To,Category_Name,Deal_Type_Name,
						   Acq_Deal_Rights_Holdback_Code, Holdback_Type, Holdback_Release_Date, Holdback_On_Platform_Code
	INTO #Temp_Main_Ctr_Neo
	FROM (
		SELECT ROW_NUMBER() OVER(
									PARTITION BY Acq_Deal_Rights_Code ,Title_Code, Platform_Code, Country_Code, Region_Type, 
									Right_Start_Date, Rights_End_Date
									, Is_Exclusive, Sub_License_Code,Acq_Deal_Rights_Holdback_Code, Holdback_Type, 
									Holdback_Release_Date, Holdback_On_Platform_Code
									ORDER BY Title_Code, Platform_Code, Country_Code, Region_Type DESC
								) RowId, * 
		FROM #TMP_MAIN tm
	) AS a WHERE RowId = 1
	

	---------- END

	--DROP TABLE #TMP_MAIN
	
	END
	
	ALTER TABLE #Temp_Main_Ctr_Neo ADD Platform_Str VARCHAR(2000)
	
	PRINT 'PA-STEP-10- Platform Must Have / Exact Match ' + convert(varchar(30),getdate() ,109)
	BEGIN
	IF(UPPER(@Platform_ExactMatch) = 'EM' OR UPPER(@Platform_ExactMatch) = 'MH')
	BEGIN
		UPDATE t2
		SET t2.Platform_Str =  STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Platform_Code As Varchar) FROM #Temp_Main_Ctr_Neo t1 
				Where t1.Right_Start_Date = t2.Right_Start_Date
					AND ISNULL(t1.Rights_End_Date, '') = ISNULL(t2.Rights_End_Date, '')		
					AND t1.Title_Code = t2.Title_Code
					AND ISNULL(t1.Country_Cd_Str, 0) = ISNULL(t2.Country_Cd_Str, 0)
					AND ISNULL(t1.Sub_License_Code, 0) = ISNULL(t2.Sub_License_Code, 0)
					AND t1.Is_Exclusive = t2.Is_Exclusive
					--AND t1.Country_Code = t2.Country_Code
					AND ISNULL(t1.Episode_From, 0) = ISNULL(t2.Episode_From, 0)
				    AND ISNULL(t1.Episode_To, 0) = ISNULL(t2.Episode_To, 0)
					AND IsNull(t1.Acq_Deal_Rights_Holdback_Code, 0) = IsNull(t2.Acq_Deal_Rights_Holdback_Code, 0)
					AND IsNull(t1.Holdback_Type, '') = IsNull(t2.Holdback_Type, '')
					AND IsNull(t1.Holdback_Release_Date, '') = IsNull(t2.Holdback_Release_Date, '') 
					AND IsNull(t1.Holdback_On_Platform_Code, 0) = IsNull(t2.Holdback_On_Platform_Code, 0) 
				FOR XML PATH('')
			), 1, 1, ''
		)
		FROM #Temp_Main_Ctr_Neo t2
	
		IF(UPPER(@Platform_ExactMatch) = 'EM')
		BEGIN
			
			DECLARE @PlStr VARCHAR(1000) = ''
			SELECT @PlStr = 
				STUFF
				(
					(
						SELECT DISTINCT ',' + CAST(number AS VARCHAR) FROM #Temp_Platform_Neo
						FOR XML PATH('')
					), 1, 1, ''
			   ) 

			DELETE FROM #Temp_Main_Ctr_Neo WHERE Platform_Str <> @PlStr
			--UPDATE #Temp_Main_Ctr_Neo SET Platform_Code = 0
		END

		-----------------IF Platform = Must Have
		IF(UPPER(@Platform_ExactMatch) = 'MH')
		BEGIN
	
			TRUNCATE TABLE #Temp_Platform_Neo
			DECLARE @MustHaveCnt INT = 0

			INSERT INTO #Temp_Platform_Neo
			SELECT number FROM dbo.fn_Split_withdelemiter(@MustHave_Platform, ',') WHERE number NOT IN ('', '0')

			print '--------------1'
			SELECT @MustHaveCnt = COUNT(*) FROM #Temp_Platform_Neo
				
			SELECT DISTINCT Platform_Str
			INTO #Temp_Plt_Names
			FROM #Temp_Main_Ctr_Neo tm
				

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
				AND number IN (SELECT p.number FROM #Temp_Platform_Neo p))>= @MustHaveCnt	
			)
		
			DELETE FROM #Temp_Main_Ctr_Neo WHERE Platform_Str NOT IN (SELECT tpn.Platform_Str FROM #Temp_Plt_Names tpn)
		print '--------------2'
		END
		END
	END

	print 'PA-STEP-11 UPDATE LANGUAGE Names in #Temp_Main_Ctr_Neo' + convert(varchar(30),getdate() ,109)	
	BEGIN		

	ALTER TABLE #Temp_Main_Ctr_Neo 
	ADD Title_Language_Names NVARCHAR(2000),
		Sub_Language_Names NVARCHAR(2000),
		Dub_Language_Names NVARCHAR(2000),
		Reverse_Holdback NVarchar(Max)

	
	
	UPDATE tms
	SET tms.Title_Language_Names = at.Title_Language_Names
	FROM #Temp_Main_Ctr_Neo tms
	INNER JOIN #Avail_TitLang_Neo at ON at.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND at.Rights_Start_Date  = tms.Right_Start_Date
		AND IsNull(at.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND at.Is_Exclusive  = tms.Is_Exclusive
		AND at.Sub_License_Code  = tms.Sub_License_Code
				
	

	UPDATE tms
	SET tms.Sub_Language_Names = asub.Sub_Language_Names
	FROM #Temp_Main_Ctr_Neo tms
	INNER JOIN #Avail_Sub_Neo asub ON asub.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND asub.Rights_Start_Date  = tms.Right_Start_Date
		AND IsNull(asub.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND asub.Is_Exclusive  = tms.Is_Exclusive
		AND asub.Sub_License_Code  = tms.Sub_License_Code

	UPDATE tms
	SET tms.Dub_Language_Names = ad.Dubb_Language_Names
	FROM #Temp_Main_Ctr_Neo tms
	INNER JOIN #Avail_Dubb_Neo ad ON ad.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND ad.Rights_Start_Date  = tms.Right_Start_Date
		AND IsNull(ad.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND ad.Is_Exclusive  = tms.Is_Exclusive
		AND ad.Sub_License_Code  = tms.Sub_License_Code
   END		
   
   DROP TABLE #Avail_Sub_Neo
   DROP TABLE #Avail_Dubb_Neo
	print 'PA-STEP-12 Query to get title details' + convert(varchar(30),getdate() ,109)	
	BEGIN
		-----------------Query to get title details
		SELECT t.Title_Code, t.Title_Language_Code, 
		--t.Title_Name
		CASE WHEN ISNULL(Year_Of_Production, '') = '' THEN Title_Name ELSE Title_Name + ' ('+ CAST(Year_Of_Production AS VARCHAR(10)) + ')' END Title_Name
		,
			Genres_Name = [dbo].[UFN_GetGenresForTitle](t.Title_Code),
			Star_Cast = [dbo].[UFN_GetStarCastForTitle](t.Title_Code),
			Director = [dbo].[UFN_GetDirectorForTitle](t.Title_Code),
			COALESCE(t.Duration_In_Min, '0') Duration_In_Min, COALESCE(t.Year_Of_Production, '') Year_Of_Production 
		INTO #Temp_Titles_Neo
		FROM Title t 
		WHERE(t.Title_Code IN (SELECT tm.Title_Code FROM #Temp_Main_Ctr_Neo tm))
		------------------END
	END

	print 'PA-STEP-13 Restrication Remarks' + convert(varchar(30),getdate() ,109)	
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN
		SELECT DISTINCT Acq_Deal_Rights_Code, Remarks, Rights_Remarks, 
				Restriction_Remarks,
				Sub_Deal_Restriction_Remark,Category_Name,Deal_Type_Name
		INTO #Temp_Right_Remarks_Neo
		FROM #Temp_Right_Neo

		--Select * from #Temp_Right_Remarks
	END

	DROP TABLE #Temp_Country_Names_Neo
	DROP TABLE #Temp_Language_Names_Neo
		
	UPDATE #Temp_Main_Ctr_Neo SET Right_Start_Date = CONVERT(VARCHAR(30), GETDATE(), 106) WHERE Right_Start_Date < GETDATE()

	---------Reverse holdback added---------
	print 'STEP-13.1 REVERSE HOLDBACK ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		Select Distinct Title_Code , Cast('' As NVarchar(Max)) strRHB --Country_Cd_Str, Platform_Str, 
		InTo #TempRHB_AP From #Temp_Main_Ctr_Neo
		Update #TempRHB_AP Set strRHB = [dbo].[UFN_GET_SYNRHB](Title_Code)

		Update a Set a.Reverse_Holdback = b.strRHB 
		From #Temp_Main_Ctr_Neo a 
		Inner Join #TempRHB_AP b On a.Title_Code = b.Title_Code --AND a.Country_Cd_Str = b.Country_Cd_Str AND a.Platform_Str = b.Platform_Str
	
		Drop Table #TempRHB_AP

	END

	print 'PA-STEP-13 .1'
	------------------ Final Output
	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN

	print 'PA-STEP-13 .1.1'
	SELECT DISTINCT 
			trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Country_Names AS Country_Name, 
			--CAST(tm.Right_Start_Date AS DATETIME) Rights_Start_Date,
			Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR CAST(tm.Right_Start_Date as DATETIME) > CAST(tm.Holdback_Release_Date as DATETIME)
				THEN tm.Right_Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Title_Language_Names, Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark,
			trr.Remarks, trr.Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
			--,tm.Episode_From, tm.Episode_To
			,Case When tm.Episode_From < @Episode_From Then @Episode_From  Else tm.Episode_From End As Episode_From, 
			Case When tm.Episode_To > @Episode_To Then @Episode_To Else tm.Episode_To End As Episode_To,trr.Category_Name,trr.Deal_Type_Name,
			CASE WHEN ISNULL(pt1.Platform_Hiearachy,'') = '' OR tm.Right_Start_Date > tm.Holdback_Release_Date THEN '' ELSE hb.HBComments + pt1.Platform_Hiearachy END COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn,
			tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, 
			CASE WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR tm.Right_Start_Date > tm.Holdback_Release_Date THEN NULL ELSE tm.Holdback_Release_Date END 
			 AS Holdback_Release_Date, --, pt1.Platform_Hiearachy As Holdback_On_Platform
			Reverse_Holdback COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback

		FROM 
			#Temp_Main_Ctr_Neo tm
			INNER JOIN #Temp_Right_Remarks_Neo trr ON trr.Acq_Deal_Rights_Code = tm.Acq_Deal_Rights_Code
			INNER JOIN #Temp_Titles_Neo trt ON trt.Title_Code = tm.Title_Code
			INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
			LEFT JOIN Sub_License sl ON tm.Sub_License_Code = sl.Sub_License_Code
			LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
			LEFT JOIN #MainAH_AP hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
			WHERE (ISNULL(tm.Holdback_Release_Date,'')<>'' AND CAST(tm.Holdback_Release_Date AS DATETIME) < CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME))
		DROP TABLE #Temp_Right_Remarks_Neo
	END
	ELSE
	BEGIN
	
	print 'PA-STEP-13 .1.2'
		SELECT DISTINCT 
			trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Country_Names AS Country_Name, 
			--CAST(tm.Right_Start_Date AS DATETIME) Rights_Start_Date, 
			Cast(
				CASE 
					WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR CAST(tm.Right_Start_Date as DATETIME) > CAST(tm.Holdback_Release_Date as DATETIME)
				THEN tm.Right_Start_Date 
				ELSE DateAdd(D, 1, tm.Holdback_Release_Date) 
				END As DateTime
			) As Right_Start_Date,
			CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
			Title_Language_Names , Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
			'' Restriction_Remark, '' Sub_Deal_Restriction_Remark,
			'' Remarks, '' Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
			--,tm.Episode_From
			--, tm.Episode_To
			,Case When tm.Episode_From < @Episode_From Then @Episode_From  Else tm.Episode_From End As Episode_From, 
			Case When tm.Episode_To > @Episode_To Then @Episode_To Else tm.Episode_To End As Episode_To,tm.Category_Name,tm.Deal_Type_Name,
			CASE WHEN ISNULL(pt1.Platform_Hiearachy,'') = '' OR tm.Right_Start_Date > tm.Holdback_Release_Date THEN '' ELSE hb.HBComments + pt1.Platform_Hiearachy END COLLATE SQL_Latin1_General_CP1_CI_AS As HoldbackOn,
			tm.Holdback_Type COLLATE SQL_Latin1_General_CP1_CI_AS AS Holdback_Type, 
			CASE WHEN ISNULL(tm.Holdback_Release_Date,'')='' OR tm.Right_Start_Date > tm.Holdback_Release_Date THEN NULL ELSE tm.Holdback_Release_Date END 
			 AS Holdback_Release_Date, --, pt1.Platform_Hiearachy As Holdback_On_Platform
			Reverse_Holdback COLLATE SQL_Latin1_General_CP1_CI_AS As Reverse_Holdback
		FROM #Temp_Main_Ctr_Neo tm
		INNER JOIN #Temp_Titles_Neo trt ON trt.Title_Code = tm.Title_Code
		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
		LEFT JOIN Sub_License sl ON ISNULL(tm.Sub_License_Code, 0) = ISNULL(sl.Sub_License_Code, 0)
		LEFT JOIN Platform pt1 ON pt1.Platform_Code = tm.Holdback_On_Platform_Code
		LEFT JOIN #MainAH_AP hb On tm.Acq_Deal_Rights_Holdback_Code = hb.Acq_Deal_Rights_Holdback_Code
		WHERE (ISNULL(tm.Holdback_Release_Date,'')<>'' AND CAST(tm.Holdback_Release_Date AS DATETIME) < CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME))
	END
	------------------ END
	
	print 'PA-STEP-14 Proc Exceuted'

	DROP TABLE #Temp_Title_Neo
	DROP TABLE #Temp_Main_Ctr_Neo
	DROP TABLE #Temp_Titles_Neo
	DROP TABLE #Temp_Right_Neo
	DROP TABLE #Temp_Country_Neo
	DROP TABLE #Temp_Platform_Neo
	DROP TABLE #Temp_Title_Language_Neo
	DROP TABLE #Temp_Language_Neo
	DROP TABLE #Avail_Acq_Neo
	DROP TABLE #Avail_TitLang_Neo
END


	IF OBJECT_ID('tempdb..#Avail_Acq_Neo') IS NOT NULL DROP TABLE #Avail_Acq_Neo
	IF OBJECT_ID('tempdb..#Avail_Dubb_Neo') IS NOT NULL DROP TABLE #Avail_Dubb_Neo
	IF OBJECT_ID('tempdb..#Avail_Dubb_V1_Neo') IS NOT NULL DROP TABLE #Avail_Dubb_V1_Neo
	IF OBJECT_ID('tempdb..#Avail_Sub_Neo') IS NOT NULL DROP TABLE #Avail_Sub_Neo
	IF OBJECT_ID('tempdb..#Avail_Sub_V1_Neo') IS NOT NULL DROP TABLE #Avail_Sub_V1_Neo
	IF OBJECT_ID('tempdb..#Avail_Sub_V1_Neo') IS NOT NULL DROP TABLE #Avail_Sub_V1_Neo
	IF OBJECT_ID('tempdb..#Avail_TitLang_Neo') IS NOT NULL DROP TABLE #Avail_TitLang_Neo
	IF OBJECT_ID('tempdb..#Avail_TitLang_V1') IS NOT NULL DROP TABLE #Avail_TitLang_V1
	IF OBJECT_ID('tempdb..#Temp_Country_Names_Neo') IS NOT NULL DROP TABLE #Temp_Country_Names_Neo
	IF OBJECT_ID('tempdb..#Temp_Country_Neo') IS NOT NULL DROP TABLE #Temp_Country_Neo
	IF OBJECT_ID('tempdb..#Temp_Dates') IS NOT NULL DROP TABLE #Temp_Dates
	IF OBJECT_ID('tempdb..#Temp_Dubs') IS NOT NULL DROP TABLE #Temp_Dubs
	IF OBJECT_ID('tempdb..#Temp_Language_Names_Neo') IS NOT NULL DROP TABLE #Temp_Language_Names_Neo
	IF OBJECT_ID('tempdb..#Temp_Language_Neo') IS NOT NULL DROP TABLE #Temp_Language_Neo
	IF OBJECT_ID('tempdb..#Temp_Main') IS NOT NULL DROP TABLE #Temp_Main
	IF OBJECT_ID('tempdb..#Temp_Main_Ctr_Neo') IS NOT NULL DROP TABLE #Temp_Main_Ctr_Neo
	IF OBJECT_ID('tempdb..#Temp_Platform_Neo') IS NOT NULL DROP TABLE #Temp_Platform_Neo
	IF OBJECT_ID('tempdb..#Temp_Plt_Names') IS NOT NULL DROP TABLE #Temp_Plt_Names
	IF OBJECT_ID('tempdb..#Temp_Right_Neo') IS NOT NULL DROP TABLE #Temp_Right_Neo
	IF OBJECT_ID('tempdb..#Temp_Right_Remarks_Neo') IS NOT NULL DROP TABLE #Temp_Right_Remarks_Neo
	IF OBJECT_ID('tempdb..#Temp_Subs') IS NOT NULL DROP TABLE #Temp_Subs
	IF OBJECT_ID('tempdb..#Temp_Title_Language_Neo') IS NOT NULL DROP TABLE #Temp_Title_Language_Neo
	IF OBJECT_ID('tempdb..#Temp_Title_Neo') IS NOT NULL DROP TABLE #Temp_Title_Neo
	IF OBJECT_ID('tempdb..#Temp_Titles_Neo') IS NOT NULL DROP TABLE #Temp_Titles_Neo
	IF OBJECT_ID('tempdb..#TMP_MAIN') IS NOT NULL DROP TABLE #TMP_MAIN
	IF OBJECT_ID('tempdb..#Tmp_SL_Neo') IS NOT NULL DROP TABLE #Tmp_SL_Neo
	--IF OBJECT_ID('tempdb..#TMP_MAIN_AP') IS NOT NULL DROP TABLE #TMP_MAIN_AP
	IF OBJECT_ID('tempdb..#MainAH_AP') IS NOT NULL DROP TABLE #MainAH_AP
	IF OBJECT_ID('tempdb..#MainTit_AP') IS NOT NULL DROP TABLE #MainTit_AP
END