alter PROCEDURE [dbo].[USP_Report_PlatformWise_Acquisition_Neo]
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
	@Include_Sub_Deal CHAR(1) = 'Y',
	@Episode_From INT=1,
	@Episode_To INT=1,
	@Show_Expired CHAR(1)
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
	IF(ISNULL(@EndDate,'') = '')
		SET @EndDate = '9999-12-31'
	
	--	SELECT
	--@Title_Code ='12740',
	--@Platform_Code ='0',
	--@Country_Code ='0',
	--@Is_Original_Language ='true',
	--@Title_Language_Code ='0',
	--@Date_Type ='FL',
	--@StartDate ='23-Sep-2015',
	--@EndDate ='23-Sep-2020',
	--@RestrictionRemarks ='false',
	--@OthersRemarks ='false',--D
	--@Platform_ExactMatch ='False', 
	--@MustHave_Platform ='0', 
	--@Exclusivity ='B' ,
	--@SubLicense_Code ='0',
	--@Region_ExactMatch ='false',
	--@Region_MustHave ='0',
	--@Region_Exclusion = '0',
	--@Subtit_Language_Code ='0,L1',
	--@Dubbing_Subtitling='S,D',
	--@Dubbing_Language_Code='0,L1,',
	--@Bu_Code=3
	
	--select * from Language

	BEGIN--------------------Drop Temp Tables -------------------
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
	IF(OBJECT_ID('TEMPDB..#Avail_Acq') IS NOT NULL)
		DROP TABLE #Avail_Acq
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
	IF(OBJECT_ID('TEMPDB..#Temp_Rights_Code') IS NOT NULL)
		DROP TABLE #Temp_Rights_Code
	END
	
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
		DECLARE @Deal_Type_Code_Music INT = 0
		select top 1 @Deal_Type_Code_Music = CAST(Parameter_Value AS INT) from System_Parameter_New where Parameter_Name = 'Deal_Type_Music'

		CREATE TABLE #Temp_Right 
		(
			Acq_Deal_Code INT, 
			Master_Deal_Movie_Code INT, 
			Acq_Deal_Rights_Code INT, 
			Restriction_Remarks NVARCHAR(4000), 
			Platform_Code INT, 
			Title_Code INT,
			Is_Master_Deal CHAR(1), 
			Remarks NVARCHAR(4000), 
			Rights_Remarks NVARCHAR(4000),
			Sub_Deal_Restriction_Remark NVARCHAR(4000), 
			Rights_Start_Date DATETIME,
			Rights_End_Date DATETIME,
			Is_Exclusive CHAR(1),
			Sub_License_Code INT,
			Episode_From INT,
			Episode_To INT
		)
		CREATE TABLE #Temp_Rights_Code
		(
			Acq_Deal_Rights_Code INT				
		)

		INSERT INTO #Temp_Right(Acq_Deal_Code, Acq_Deal_Rights_Code, Master_Deal_Movie_Code, Restriction_Remarks, Platform_Code, Title_Code,
			   Is_Master_Deal, Remarks, Rights_Remarks, Sub_Deal_Restriction_Remark, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From, Episode_To)
		SELECT AR.Acq_Deal_Code, AR.Acq_Deal_Rights_Code, ISNULL(AD.Master_Deal_Movie_Code_ToLink, 0),  AR.Restriction_Remarks, ADRP.Platform_Code, ADRT.Title_Code,
			   AD.Is_Master_Deal, AD.Remarks, AD.Rights_Remarks, 
			   (STUFF((
				SELECT DISTINCT ',' + ADR_Tmp.Restriction_Remarks 
				FROM Acq_Deal AD_Tmp
				INNER JOIN Acq_Deal_Rights ADR_Tmp ON ADR_Tmp.Acq_Deal_Code = AD_Tmp.Acq_Deal_Code 
				WHERE AD_Tmp.Is_Master_Deal = 'N' AND ad_Tmp.Master_Deal_Movie_Code_ToLink IN
				(SELECT adm_Tmp.Acq_Deal_Movie_Code FROM Acq_Deal_Movie adm_Tmp WHERE adm_Tmp.Acq_Deal_Code = AD.Acq_Deal_Code)
				FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,'')) 
				, AR.Actual_Right_Start_Date, AR.Actual_Right_End_Date
				,AR.Is_Exclusive, ISNULL(AR.Sub_License_Code, 0), ADRT.Episode_From, ADRT.Episode_To
		FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Rights AR ON AR.Acq_Deal_Code = AD.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Platform AS ADRP ON ADRP.Acq_Deal_Rights_Code = AR.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Title AS ADRT ON ADRT.Acq_Deal_Rights_Code = AR.Acq_Deal_Rights_Code
		WHERE 
		 AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
		AR.Is_Tentative = 'N'
		AND (AR.Is_Sub_License = @Is_SubLicense OR @Is_SubLicense = '')
		AND (
			ADRT.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) OR (
				@Include_Sub_Deal = 'Y' AND AD.Master_Deal_Movie_Code_ToLink IN (
					Select Acq_Deal_Movie_Code From Acq_Deal_Movie Where Title_Code IN (SELECT Title_Code FROM #Temp_Title)
				)
			)
		)
		AND ADRP.Platform_Code IN (SELECT number FROM #Temp_Platform) 
		AND ((AR.Sub_License_Code IN (SELECT SubLicense_Code  FROM #Tmp_SL) AND @Is_SubLicense = 'Y') OR @Is_SubLicense <> 'Y')
		AND AD.Business_Unit_Code = @BU_Code
		and (AD.Is_Master_Deal != @Include_Sub_Deal OR @Include_Sub_Deal = 'Y' OR AD.Deal_Type_Code = @Deal_Type_Code_Music)
		AND (
			ADRT.Episode_From Between @Episode_From And @Episode_To Or
			ADRT.Episode_To Between @Episode_From And @Episode_To Or
			@Episode_From Between ADRT.Episode_From And ADRT.Episode_To Or
			@Episode_To Between ADRT.Episode_From And ADRT.Episode_To
		)
		------------------ END
	END

	PRINT 'PA-STEP-3 Populate #Avail_Acq  ' + convert(varchar(30),getdate() ,109)
	BEGIN
		-----------------Query to get Avail information related to Title ,Platform AND Country
		CREATE TABLE #Avail_Acq 
		(
			Acq_Deal_Rights_Code INT, 
			Master_Deal_Movie_Code INT, 
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
		
		IF(@Date_Type = 'MI' OR @Date_Type = 'FI')
			BEGIN
		
				INSERT INTO #Avail_Acq(Acq_Deal_Rights_Code, Master_Deal_Movie_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive ,
				Sub_License_Code,Episode_From ,Episode_To)
				SELECT DISTINCT tr.Acq_Deal_Rights_Code, TR.Master_Deal_Movie_Code , tr.Title_Code, tr.Platform_Code, 
				CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
				tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0), Episode_From, Episode_To
				FROM 
				#Temp_Right tr 
				INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
				LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
				WHERE 
				--tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) AND 
				--(tr.Platform_Code IN (SELECT number FROM #Temp_Platform) ) AND 
				((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)))
				AND ((ISNULL(tr.Rights_Start_Date, '9999-12-31')  <= @StartDate AND ISNULL(tr.Rights_End_Date, '9999-12-31') >=  @EndDate))
				AND ((@Show_Expired = 'Y' AND ISNULL(tr.Rights_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'N')
				AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)

			END
		ELSE
			BEGIN
		
				INSERT INTO #Avail_Acq(Acq_Deal_Rights_Code, Master_Deal_Movie_Code ,Title_Code ,Platform_Code ,Country_Code ,Rights_Start_Date ,Rights_End_Date ,Is_Exclusive,
				Sub_License_Code, Episode_From, Episode_To)
				SELECT DISTINCT tr.Acq_Deal_Rights_Code, TR.Master_Deal_Movie_Code , tr.Title_Code, tr.Platform_Code, 
				CASE WHEN adrter.Territory_Type = 'G' THEN td.Country_Code ELSE adrter.Country_Code END, 
				tr.Rights_Start_Date, tr.Rights_End_Date, tr.Is_Exclusive, ISNULL(tr.Sub_License_Code, 0),
				Episode_From, Episode_To
				FROM  #Temp_Right tr 
				INNER JOIN Acq_Deal_Rights_Territory adrter on adrter.Acq_Deal_Rights_Code = tr.Acq_Deal_Rights_Code
				LEFT JOIN Territory_Details td on (td.Territory_Code = adrter.Territory_Code AND adrter.Territory_Type = 'G')
				WHERE 
				--tr.Title_Code IN (SELECT tt.Title_Code FROM #Temp_Title tt) AND 
				--(tr.Platform_Code IN (SELECT number FROM #Temp_Platform) ) AND 
				((adrter.Territory_Type = 'G' AND td.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)) OR (adrter.Territory_Type = 'I' AND adrter.Country_Code IN (SELECT tc.Country_Code FROM #Temp_Country tc)))
				AND ((ISNULL(tr.Rights_End_Date, '9999-12-31') BETWEEN @StartDate AND  @EndDate)
					OR (ISNULL(tr.Rights_Start_Date, '9999-12-31') BETWEEN @StartDate AND @EndDate)
					OR (@StartDate BETWEEN  ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31'))
					OR (@EndDate BETWEEN ISNULL(tr.Rights_Start_Date, '9999-12-31') AND ISNULL(tr.Rights_End_Date, '9999-12-31')) 
					AND ((@Show_Expired = 'Y' AND ISNULL(tr.Rights_End_Date, GETDATE()) <= GETDATE()) OR  @Show_Expired = 'N')
					)
				AND tr.Is_Exclusive IN (@Ex_YES, @Ex_NO)
		
		END
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
			Title_Language_Names NVARCHAR(200),
			Episode_From INT,
			Episode_To INT
		)

		CREATE TABLE #Avail_Sub 
		(
			Acq_Deal_Rights_Code INT,
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
			Acq_Deal_Rights_Code INT,
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
	
		CREATE INDEX IX_TMP_Avail_Acq ON #Avail_Acq(Acq_Deal_Rights_Code)
		CREATE INDEX IX_Temp_Language ON #Temp_Language(Language_Code)
		
		IF(@Is_Original_Language = 1) 
		BEGIN
			INSERT INTO #Avail_TitLang(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive, Episode_From ,Episode_To)
			SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, tit.Title_Language_Code
				, AA.Sub_License_Code, AA.Is_Exclusive, Episode_From ,Episode_To
			FROM #Avail_Acq AA
			INNER JOIN Title tit ON AA.Title_Code = tit.Title_Code
			INNER JOIN #Temp_Title_Language TTL ON TTL.number = tit.Title_Language_Code
		END

		IF(@Include_Sub_Deal = 'Y' AND @Is_Original_Language = 1)
		BEGIN
			INSERT INTO #Avail_TitLang(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive, Episode_From ,Episode_To)
			SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, tit.Title_Language_Code
				, AA.Sub_License_Code, AA.Is_Exclusive, Episode_From ,Episode_To
			FROM #Avail_Acq AA
			INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = AA.Master_Deal_Movie_Code
			INNER JOIN Title tit ON ADM.Title_Code = tit.Title_Code
			INNER JOIN #Temp_Title_Language TTL ON TTL.number = tit.Title_Language_Code
		END

		PRINT 'PA-STEP-4.1 Populate #Avail_Sub  ' + convert(varchar(30),getdate() ,109)
		-----------------Populate Title Avail for Subtitling Languages
		IF EXISTS(SELECT * WHERE 'S' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling, ',')))
		BEGIN
			
			--Select Distinct Acq_Deal_Rights_Code, STUFF((
			--Select Distinct ',' + 
			--CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrs.Language_Code End AS NVARCHAR) From Acq_Deal_Rights_Subtitling adrs
			--LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code
			--WHERE adrs.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
			--And (
			--	(
			--		Language_Type = 'G' And lgd.Language_Code IN (
			--			Select tl.Language_Code From #Temp_Language TL Where TL.Language_Type = 'S'
			--		)
			--	) OR
			--	(
			--		Language_Type <> 'G' And adrs.Language_Code IN (
			--			Select TL1.Language_Code From #Temp_Language TL1 Where TL1.Language_Type = 'S'
			--		)
			--	)
			--)
			--FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
			--)Sub_Langs InTo #Temp_Subs
			--From (
			--	Select Distinct Acq_Deal_Rights_Code From #Avail_Acq
			--) As a
			INSERT INTO #Temp_Rights_Code(Acq_Deal_Rights_Code)
			SELECT DISTINCT Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights_Subtitling adrs
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code
			WHERE adrs.Acq_Deal_Rights_Code IN
			(
				SELECT DISTINCT Acq_Deal_Rights_Code FROM #Avail_Acq
			)
			AND 
			(
				(
					Language_Type = 'G' AND lgd.Language_Code IN (
						SELECT tl.Language_Code FROM #Temp_Language TL WHERE TL.Language_Type = 'S'
					)
				) 
				OR
				(
					Language_Type <> 'G' And adrs.Language_Code IN (
						SELECT TL1.Language_Code FROM #Temp_Language TL1 WHERE TL1.Language_Type = 'S'
					)
				)
			)
					
			IF EXISTS(SELECT TOP 1 Acq_Deal_Rights_Code  FROM  #Temp_Rights_Code)
			BEGIN
				SELECT DISTINCT Acq_Deal_Rights_Code, 
				STUFF((
				Select Distinct ',' + 
				CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrs.Language_Code End AS NVARCHAR) 
				From Acq_Deal_Rights_Subtitling adrs
				LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrs.Language_Group_Code
				WHERE adrs.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code			
				FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
				)Sub_Langs InTo #Temp_Subs
				From 
				(				
					Select Distinct Acq_Deal_Rights_Code From #Temp_Rights_Code
				) As a	

				INSERT INTO #Avail_Sub(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Sub_Language_Names)
				SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
				--CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
				AAS.Sub_Langs,
				AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
				FROM 
				#Temp_Subs AAS
				INNER JOIN #Avail_Acq AA ON AA.Acq_Deal_Rights_Code = AAS.Acq_Deal_Rights_Code
				WHERE ISNULL(AAS.Sub_Langs,'') <>''						
				
				DROP TABLE #Temp_Subs
			END

			TRUNCATE TABLE #Temp_Rights_Code

			print '2'	
			
		END

		-----------------Populate Title Avail for Dubbing Languages
		PRINT 'PA-STEP-4.2 Populate #Avail_Dubb  ' + convert(varchar(30),getdate() ,109)
		IF(EXISTS(SELECT * WHERE 'D' IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Dubbing_Subtitling,','))))
		BEGIN

			--Select Distinct Acq_Deal_Rights_Code, STUFF((
			--Select Distinct ',' + 
			--CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrd.Language_Code End AS NVARCHAR) From Acq_Deal_Rights_Dubbing adrd
			--LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrd.Language_Group_Code
			--WHERE adrd.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code
			--And (
			--	(
			--		Language_Type = 'G' And lgd.Language_Code IN (
			--			Select tl.Language_Code From #Temp_Language TL Where TL.Language_Type = 'D'
			--		)
			--	) OR
			--	(
			--		Language_Type <> 'G' And adrd.Language_Code IN (
			--			Select TL1.Language_Code From #Temp_Language TL1 Where TL1.Language_Type = 'D'
			--		)
			--	)
			--)
			--FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
			--)Dub_Langs InTo #Temp_Dubs
			--From (
			--	Select Distinct Acq_Deal_Rights_Code From #Avail_Acq
			--) As a		
			INSERT INTO #Temp_Rights_Code(Acq_Deal_Rights_Code)
			SELECT DISTINCT Acq_Deal_Rights_Code
			FROM Acq_Deal_Rights_Dubbing adrd
			LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrd.Language_Group_Code
			WHERE adrd.Acq_Deal_Rights_Code IN
			(
				SELECT DISTINCT Acq_Deal_Rights_Code FROM #Avail_Acq
			)
			AND 
			(
				(
					Language_Type = 'G' AND lgd.Language_Code IN (
						SELECT tl.Language_Code FROM #Temp_Language TL WHERE TL.Language_Type = 'D'
					)
				) 
				OR
				(
					Language_Type <> 'G' And adrd.Language_Code IN (
						SELECT TL1.Language_Code FROM #Temp_Language TL1 WHERE TL1.Language_Type = 'D'
					)
				)
			)
					
			IF EXISTS(SELECT TOP 1 Acq_Deal_Rights_Code  FROM  #Temp_Rights_Code)
			BEGIN
				SELECT DISTINCT Acq_Deal_Rights_Code, 
				STUFF((
				Select Distinct ',' + 
				CAST(Case When Language_Type = 'G' Then lgd.Language_Code Else adrd.Language_Code End AS NVARCHAR) 
				From Acq_Deal_Rights_Dubbing adrd
				LEFT JOIN Language_Group_Details lgd ON lgd.Language_Group_Code = adrd.Language_Group_Code
				WHERE adrd.Acq_Deal_Rights_Code = a.Acq_Deal_Rights_Code			
				FOR XML PATH(''),type).value('.', 'nvarchar(max)'),1,1,''
				) Dub_Langs INTO #Temp_Dubs
				FROM 
				(				
					Select Distinct Acq_Deal_Rights_Code From #Temp_Rights_Code
				) As a							
				
																	
				INSERT INTO #Avail_Dubb(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Language_Code, Sub_License_Code, Is_Exclusive,Episode_From ,Episode_To, Dubb_Language_Names)
				SELECT AA.Acq_Deal_Rights_Code, AA.Rights_Start_Date AS Rights_Start_Date, AA.Rights_End_Date AS Right_End_Date, 
				--CASE WHEN aas.Language_Type= 'G' THEN lgd.Language_Code ELSE AAS.Language_Code END ,
				AAD.Dub_Langs,
				AA.Sub_License_Code, AA.Is_Exclusive ,Episode_From ,Episode_To,''
				FROM 
				#Temp_Dubs AAD
				INNER JOIN #Avail_Acq AA ON AA.Acq_Deal_Rights_Code = AAD.Acq_Deal_Rights_Code
				WHERE ISNULL(AAD.Dub_Langs,'') <>''
				
				DROP TABLE #Temp_Dubs	
			END

			print '2'				
		END

	END
	--select * from #Avail_Dubb
	--select * from Language where Language_name like 'mara%'
	DROP TABLE #Temp_Rights_Code
			
	CREATE INDEX IX_Avail_TitLang ON #Avail_TitLang(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Dubb ON #Avail_Dubb(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
	CREATE INDEX IX_Avail_Sub ON #Avail_Sub(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)

	--PRINT 'PA-STEP-5 UPDATE Subtitling Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1, #Avail_Dubb_V1 ' + convert(varchar(30),getdate() ,109)
		--BEGIN
		--	SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Sub_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Sub_Language_Names
		--	INTO #Avail_Sub_V1
		--	FROM (
		--		SELECT a.* ,
		--		STUFF
		--		(
		--			(
		--				SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Sub b
		--				WHERE a.Acq_Deal_Rights_Code = b.Acq_Deal_Rights_Code
		--					AND a.Rights_Start_Date = b.Rights_Start_Date 
		--					AND ISNULL(a.Rights_End_Date,'')=ISNULL(b.Rights_End_Date,'')
		--					AND a.Is_Exclusive = b.Is_Exclusive
		--					AND ISNULL(a.Sub_License_Code, 0) = ISNULL(b.Sub_License_Code, 0)
		--					AND ISNULL(a.Episode_From, 0) = ISNULL(b.Episode_From, 0)
		--					AND ISNULL(a.Episode_To, 0) = ISNULL(b.Episode_To, 0)
		--					AND ISNULL(a.Episode_From, 0) = ISNULL(b.Episode_From, 0)
		--					AND ISNULL(a.Episode_To, 0) = ISNULL(b.Episode_To, 0)
		--				FOR XML PATH('')
		--			), 1, 1, ''
		--		) Sub_Language_Codes
		--		FROM (
		--			SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From, Episode_To
		--			FROM #Avail_Sub
		--		) AS a
		--	) AS MainOutput

		--	DROP TABLE #Avail_Sub

		--	PRINT 'PA-STEP-5 UPDATE Dubbing Language Codes in #Avail_TitLang_V1, #Avail_Sub_V1, #Avail_Dubb_V1 ' + convert(varchar(30),getdate() ,109)
		--	SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Dubb_Language_Codes, CAST('' AS VARCHAR(MAX)) AS Dubb_Language_Names
		--INTO #Avail_Dubb_V1
		--FROM (
		--	SELECT a.* ,
		--	STUFF
		--	(
		--		(
		--			SELECT DISTINCT ',' + CAST(Language_Code AS VARCHAR) FROM #Avail_Dubb b
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
		--		SELECT DISTINCT Acq_Deal_Rights_Code , Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, Episode_From, Episode_To
		--		FROM #Avail_Dubb
		--	) AS a
		--) AS MainOutput
		--END

		--DROP TABLE #Avail_Dubb


	print 'PA-STEP-6 UPDATE Language Names in  in #Avail_TitLang_V1, #Avail_Sub_V1, #Avail_Dubb_V1  ' + convert(varchar(30),getdate() ,109)	
	BEGIN

		-----------------Get Language Names for #Temp_Main
		CREATE TABLE #Temp_Language_Names(
			Language_Codes NVARCHAR(MAX),
			Language_Names NVARCHAR(MAX)
		)

		--INSERT INTO #Temp_Language_Names(Language_Codes)
		--SELECT DISTINCT Language_Code FROM #Avail_TitLang
	
		INSERT INTO #Temp_Language_Names(Language_Codes)
		SELECT DISTINCT Language_Code FROM #Avail_Sub
	
		INSERT INTO #Temp_Language_Names(Language_Codes)
		SELECT DISTINCT Language_Code FROM #Avail_Dubb WHERE Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  NOT IN (
			SELECT Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  FROM #Temp_Language_Names
		)

		UPDATE #Temp_Language_Names SET Language_Names = [dbo].[UFN_Get_Language_With_Parent](Language_Codes)
	
		UPDATE tm SET tm.Title_Language_Names = lang.Language_Name
		FROM #Avail_TitLang tm 
		INNER JOIN Language lang ON tm.Language_Code = lang.Language_Code

		UPDATE tm SET tm.Sub_Language_Names = tml.Language_Names FROM #Avail_Sub tm 
		INNER JOIN #Temp_Language_Names tml ON tm.Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  = tml.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  

		UPDATE tm SET tm.Dubb_Language_Names = tml.Language_Names FROM #Avail_Dubb tm 
		INNER JOIN #Temp_Language_Names tml ON tm.Language_Code COLLATE SQL_Latin1_General_CP1_CI_AS  = tml.Language_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  
	END
	
	PRINT 'PA-STEP-7 Populate #Temp_Dates ' + convert(varchar(30),getdate() ,109)
	BEGIN
		CREATE INDEX IX_Avail_Dubb_V1 ON #Avail_Dubb(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)
		CREATE INDEX IX_Avail_Sub_V1 ON #Avail_Sub(Acq_Deal_Rights_Code, Rights_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code)

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
		FROM #Avail_TitLang AT
		UNION 
		SELECT ASUB.Acq_Deal_Rights_Code, ASUB.Rights_Start_Date, ASUB.Rights_End_Date, ASUB.Is_Exclusive, ASUB.Sub_License_Code , ASUB.Episode_From, ASUB.Episode_To
		FROM #Avail_Sub ASUB 
		UNION
		SELECT ADUB.Acq_Deal_Rights_Code, ADUB.Rights_Start_Date, ADUB.Rights_End_Date, ADUB.Is_Exclusive, ADUB.Sub_License_Code , ADUB.Episode_From, ADUB.Episode_To
		FROM #Avail_Dubb ADUB 


	END

	PRINT 'PA-STEP-8 Populate #Temp_Main ' + convert(varchar(30),getdate() ,109)
	BEGIN

		CREATE INDEX IX_Temp_Dates ON #Temp_Dates(Acq_Deal_Rights_Code)

		SELECT DISTINCT AA.Acq_Deal_Rights_Code, AA.Title_Code, AA.Platform_Code, AA.Country_Code, TD.Right_Start_Date, TD.Rights_End_Date, TD.Is_Exclusive, TD.Sub_License_Code
		,AA.Episode_From, AA.Episode_To, CAST('' AS NVARCHAR(2000)) AS Country_Cd_Str ,
		CAST('' AS CHAR(1)) AS Region_Type , CAST('' AS NVARCHAR(2000)) AS Country_Names 
		, CAST('' AS NVARCHAR(MAX)) AS Region_Names 
		INTO #TMP_MAIN
		FROM #Temp_Dates TD
		INNER JOIN #Avail_Acq AA ON AA.Acq_Deal_Rights_Code = TD.Acq_Deal_Rights_Code
	END
	
	DROP TABLE #Temp_Dates

	PRINT 'PA-STEP-9- Country Exact Match/ Must Have, Country Names' + convert(varchar(30),getdate() ,109)
	BEGIN
		--ALTER TABLE #Avail_Acq ADD 
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
		
			DELETE FROM #TMP_MAIN WHERE Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS  NOT IN (SELECT Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  FROM #Temp_Country_Names)
		END
	
		PRINT 'PA-STEP-9.3- Country Names ' + convert(varchar(30),getdate() ,109)
		-----------------UPDATE Country / Territory Names
		
		UPDATE #Temp_Country_Names SET Country_Names = [dbo].[UFN_Get_Territory](Country_Codes)
	
		UPDATE tmc SET tmc.Territory_Code = ter.Territory_Code FROM Territory ter 
		INNER JOIN #Temp_Country_Names tmc ON ter.Territory_Name COLLATE SQL_Latin1_General_CP1_CI_AS  = tmc.Country_Names COLLATE SQL_Latin1_General_CP1_CI_AS   AND ISNULL(tmc.Country_Names, '') <> ''
		
		UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'T', tm.Country_Code = tmc.Territory_Code
		FROM #TMP_MAIN tm 
		INNER JOIN #Temp_Country_Names tmc ON tm.Country_Cd_Str COLLATE SQL_Latin1_General_CP1_CI_AS = tmc.Country_Codes COLLATE SQL_Latin1_General_CP1_CI_AS  AND ISNULL(tmc.Country_Names, '') <> ''
						
		TRUNCATE TABLE #Temp_Country_Names
	
		INSERT INTO #Temp_Country_Names(Country_Cd)
		SELECT DISTINCT Country_Code FROM #TMP_MAIN Where ISNULL(Country_Names, '') = ''
	
		UPDATE tmc SET tmc.Country_Names = cur.Country_Name FROM Country cur
		INNER JOIN #Temp_Country_Names tmc ON cur.Country_Code = tmc.Country_Cd

		UPDATE tm SET tm.Country_Names = tmc.Country_Names, tm.Region_Type = 'C' FROM #TMP_MAIN tm 
		INNER JOIN #Temp_Country_Names tmc ON tm.Country_Code = tmc.Country_Cd AND ISNULL(tm.Country_Names, '') = '' AND ISNULL(Region_Type, '') <> 'T' 

		
		UPDATE t2
		SET t2.Region_Names =  STUFF
		(
			(
				SELECT DISTINCT ',' + CAST(Country_Names AS NVARCHAR) FROM #TMP_MAIN t1 
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

		PRINT 'PA-STEP-9.4- Delete Duplicate Records ' + convert(varchar(30),getdate() ,109)
		---------- PARTIATIOn BY QUERY FOR DELETING DUPLICATE RECORDS
		SELECT DISTINCT Acq_Deal_Rights_Code, Title_Code, Right_Start_Date, Rights_End_Date, Is_Exclusive, Sub_License_Code, 
								Platform_Code, Country_Cd_Str, Region_Type, Episode_From, Episode_To, Region_Names
		INTO #Temp_Main_Ctr
		FROM (
			SELECT ROW_NUMBER() OVER(
										PARTITION BY Acq_Deal_Rights_Code ,Title_Code, Platform_Code, Country_Code, Region_Type, Right_Start_Date, Rights_End_Date
										, Is_Exclusive, Sub_License_Code, Region_Names
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
		ALTER TABLE #Temp_Main_Ctr 
		ADD Title_Language_Names NVARCHAR(2000),
			Sub_Language_Names NVARCHAR(2000),
			Dub_Language_Names NVARCHAR(2000)
	
		UPDATE tms
		SET tms.Title_Language_Names = at.Title_Language_Names
		FROM #Temp_Main_Ctr tms
		INNER JOIN #Avail_TitLang at ON at.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
			AND at.Rights_Start_Date  = tms.Right_Start_Date
			AND IsNull(at.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
			AND at.Is_Exclusive  = tms.Is_Exclusive
			AND at.Sub_License_Code  = tms.Sub_License_Code

			print '1'
		UPDATE tms
		SET tms.Sub_Language_Names = asub.Sub_Language_Names
		FROM #Temp_Main_Ctr tms
		INNER JOIN #Avail_Sub asub ON asub.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
			AND asub.Rights_Start_Date  = tms.Right_Start_Date
			AND IsNull(asub.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
			AND asub.Is_Exclusive  = tms.Is_Exclusive
			AND asub.Sub_License_Code  = tms.Sub_License_Code

		UPDATE tms
		SET tms.Dub_Language_Names = AD.Dubb_Language_Names
		FROM #Temp_Main_Ctr tms
		INNER JOIN #Avail_Dubb AD ON AD.Acq_Deal_Rights_Code = tms.Acq_Deal_Rights_Code
		AND AD.Rights_Start_Date  = tms.Right_Start_Date
		AND IsNull(AD.Rights_End_Date, '') = IsNull(tms.Rights_End_Date, '')
		AND AD.Is_Exclusive  = tms.Is_Exclusive
		AND AD.Sub_License_Code  = tms.Sub_License_Code
	END		
   
	DROP TABLE #Avail_Sub
	DROP TABLE #Avail_Dubb

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
			
	/*
	SELECT DISTINCT TM.Acq_Deal_Rights_Code, TM.Is_Exclusive, CAST(TM.Right_Start_Date AS DATETIME) AS Rights_Start_Date, 
	CAST(ISNULL(TM.Rights_End_Date, '31Dec9999') AS DATETIME) AS Rights_End_Date, TM.Sub_License_Code, 
	CAST('' AS VARCHAR(MAX)) Remarks, CAST('' AS VARCHAR(MAX)) Rights_Remarks, 
	CAST('' AS VARCHAR(MAX)) Restriction_Remarks, CAST('' AS VARCHAR(MAX)) Sub_Deal_Restriction_Remark
	INTO #Temp_Rights_Data
	FROM #Temp_Main_Ctr TM

	PRINT 'Altering #Temp_Platforms table...'
	ALTER TABLE #Temp_Rights_Data
	ADD Region_Names Varchar(Max), 
		Subtitling_Names Varchar(Max),
		Dubbing_Names Varchar(Max)

	PRINT 'updating value of newly added column in #Temp_Platforms table...'
	--Update #Temp_Rights_Data Set 
	--Region_Names = DBO.UFN_Get_Rights_Country(Acq_Deal_Rights_Code, 'A'),
	--Subtitling_Names = DBO.UFN_Get_Rights_Subtitling(Acq_Deal_Rights_Code, 'A'),
	--Dubbing_Names = DBO.UFN_Get_Rights_Dubbing(Acq_Deal_Rights_Code, 'A')
				

	--UPDATE #Temp_Rights_Data SET Region_Names = DBO.UFN_Get_Rights_Territory(Acq_Deal_Rights_Code, 'A') WHERE LTRIM(RTRIM(Region_Names)) = ''
	UPDATE #Temp_Rights_Data SET Subtitling_Names = 'No' WHERE LTRIM(RTRIM(Subtitling_Names)) = ''
	UPDATE #Temp_Rights_Data SET Dubbing_Names = 'No' WHERE LTRIM(RTRIM(Dubbing_Names)) = ''
	

	IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	BEGIN
		WITH Temp_Right_Remarks  AS(
			SELECT DISTINCT Acq_Deal_Rights_Code, ISNULL(Remarks, '') AS Remarks, ISNULL(Rights_Remarks, '') AS Rights_Remarks, 
				ISNULL(Restriction_Remarks, '') AS Restriction_Remarks, ISNULL(Sub_Deal_Restriction_Remark, '') AS Sub_Deal_Restriction_Remark
			FROM #Temp_Right
		)

		UPDATE TRD SET TRD.Remarks = TRM.Remarks, TRD.Rights_Remarks = TRM.Rights_Remarks, TRD.Restriction_Remarks = TRM.Restriction_Remarks, 
		TRD.Sub_Deal_Restriction_Remark = TRM.Sub_Deal_Restriction_Remark
		FROM #Temp_Rights_Data TRD
		INNER JOIN Temp_Right_Remarks TRM ON TRD.Acq_Deal_Rights_Code = TRM.Acq_Deal_Rights_Code
	END
	*/

	print 'PA-STEP-13 Restrication Remarks' + convert(varchar(30),getdate() ,109)	
	--IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	--BEGIN
		SELECT DISTINCT Acq_Deal_Rights_Code, Remarks, Rights_Remarks, 
				Restriction_Remarks,
				Sub_Deal_Restriction_Remark
		INTO #Temp_Right_Remarks
		FROM #Temp_Right

		--Select * from #Temp_Right_Remarks
	--END

	SELECT AD.Agreement_No, AD.Agreement_Date, AD.Deal_Desc, V.Vendor_Name AS Licensor, 
	DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code), T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name,
	ADR.Right_Type, TR.Acq_Deal_Rights_Code, 
	ISNULL(SL.Sub_License_Name, '') AS Sub_License,
	CASE ISNULL(ADR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END AS Is_Exclusive, 
	CASE ADR.Right_Type
		When 'Y' Then [dbo].[UFN_Get_Rights_Term](adr.Actual_Right_Start_Date, adr.Actual_Right_End_Date, adr.Term) 
		When 'M' Then [dbo].[UFN_Get_Rights_Milestone](adr.Milestone_Type_Code, adr.Milestone_No_Of_Unit, adr.Milestone_Unit_Type)
		When 'U' Then 'Perpetuity'
	End AS Term,
	TM.Right_Start_Date Rights_Start_Date, tm.Rights_End_Date, 
	CASE ISNULL(ADR.Is_Title_Language_Right, 'N') WHEN 'Y' THEN ISNULL(L.Language_Name, 'No')  ELSE 'No' END 
	AS Title_Language,
	P.Platform_Hiearachy, P.Platform_Code,
	'YES' AS Available, TM.Region_Names,  tm.Sub_Language_Names Subtitling_Names, Tm.Dub_Language_Names Dubbing_Names,
	TR.Remarks, TR.Rights_Remarks, TR.Restriction_Remarks, TR.Sub_Deal_Restriction_Remark
	FROM #Temp_Right_Remarks TR
	INNER JOIN #Temp_Main_Ctr TM ON TR.Acq_Deal_Rights_Code = TM.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = TR.Acq_Deal_Rights_Code
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Title_Code = TM.Title_Code 
		AND TM.Episode_From = ADM.Episode_Starts_From AND TM.Episode_To = ADM.Episode_End_To
	INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
	INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
	INNER JOIN [Platform] P ON P.Platform_Code = TM.Platform_Code
	LEFT JOIN Sub_License SL ON adr.Sub_License_Code = sl.Sub_License_Code
	LEFT JOIN [Language] L ON L.Language_Code = T.Title_Language_Code 
	where
	 AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
	--IF(@RestrictionRemarks = 'Y' OR @OthersRemarks = 'Y' )
	--BEGIN

	--print 'PA-STEP-13 .1.1'
	--SELECT DISTINCT 
	--		trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Region_Names AS Country_Name,  CAST('' AS VARCHAR(2000)) AS Cluster_Names, 
	--		CAST(tm.Right_Start_Date AS DATETIME) Rights_Start_Date, 
	--		CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
	--		Title_Language_Names, Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
	--		trr.Restriction_Remarks Restriction_Remark, trr.Sub_Deal_Restriction_Remark,
	--		trr.Remarks, trr.Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
	--		--,tm.Episode_From, tm.Episode_To
	--		,Case When tm.Episode_From < @Episode_From Then @Episode_From  Else tm.Episode_From End As Episode_From, 
	--		Case When tm.Episode_To > @Episode_To Then @Episode_To Else tm.Episode_To End As Episode_To

	--	FROM 
	--		#Temp_Main_Ctr tm
	--		INNER JOIN #Temp_Right_Remarks trr ON trr.Acq_Deal_Rights_Code = tm.Acq_Deal_Rights_Code
	--		INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
	--		INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
	--		LEFT JOIN Sub_License sl ON tm.Sub_License_Code = sl.Sub_License_Code

	--	DROP TABLE #Temp_Right_Remarks
	--END
	--ELSE
	--BEGIN
	
	--print 'PA-STEP-13 .1.2'
	--	SELECT DISTINCT 
	--		trt.Title_Name, pt.Platform_Hiearachy AS Platform_Name, tm.Region_Names AS Country_Name,  CAST('' AS VARCHAR(2000)) AS Cluster_Names,  
	--		CAST(tm.Right_Start_Date AS DATETIME) Rights_Start_Date, 
	--		CAST(ISNULL(tm.Rights_End_Date, '31Dec9999') AS DATETIME) Rights_End_Date,
	--		Title_Language_Names , Sub_Language_Names, Dub_Language_Names, trt.Genres_Name, trt.Star_Cast, trt.Director, trt.Duration_In_Min, trt.Year_Of_Production, 
	--		'' Restriction_Remark, '' Sub_Deal_Restriction_Remark,
	--		'' Remarks, '' Rights_Remarks, CASE WHEN tm.Is_Exclusive = 'Y' THEN 'Exclusive' ELSE 'Non Exclusive' END AS Exclusive, sl.Sub_License_Name AS Sub_License, 'Yes' Platform_Avail
	--		--,tm.Episode_From
	--		--, tm.Episode_To
	--		,Case When tm.Episode_From < @Episode_From Then @Episode_From  Else tm.Episode_From End As Episode_From, 
	--		Case When tm.Episode_To > @Episode_To Then @Episode_To Else tm.Episode_To End As Episode_To
	--	FROM #Temp_Main_Ctr tm
	--	INNER JOIN #Temp_Titles trt ON trt.Title_Code = tm.Title_Code
	--	INNER JOIN Platform pt ON pt.Platform_Code = tm.Platform_Code
	--	LEFT JOIN Sub_License sl ON ISNULL(tm.Sub_License_Code, 0) = ISNULL(sl.Sub_License_Code, 0)
	--END

	------------------ END


	DROP TABLE #Temp_Title
	DROP TABLE #Temp_Main_Ctr
	--DROP TABLE #Temp_Rights_Data
	DROP TABLE #Temp_Titles
	DROP TABLE #Temp_Right
	DROP TABLE #Temp_Country
	DROP TABLE #Temp_Platform
	DROP TABLE #Temp_Title_Language
	DROP TABLE #Temp_Language
	DROP TABLE #Avail_Acq
	DROP TABLE #Avail_TitLang
END


