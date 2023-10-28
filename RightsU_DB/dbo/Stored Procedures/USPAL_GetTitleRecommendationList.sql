

CREATE PROCEDURE [dbo].[USPAL_GetTitleRecommendationList]
(
	@Vendor_Rule_Code INT,
	--@SearchWithinRule CHAR(1),
	--@IsShow CHAR(1)
	@Columns_Code NVARCHAR(MAX),
	@NotInTitles NVARCHAR(MAX),
	@TitleName NVARCHAR(MAX),
	@Genres_Code NVARCHAR(MAX),
	@Talent_Code NVARCHAR(MAX),
	@AL_Recommendation_Code int,
	@SearchWithinRule CHAR(1),
	@Banner_Code NVARCHAR(MAX) 
)
AS
BEGIN
/*---------------------------
Author          : Rahul D. Kembhavi
Created On      : 30/Mar/2023
Description     : Returns the List of Titles for Recommendation
Last Modified On: 12/Apr/2023
Last Change     : Added New input parameters TitleName, Genres_Code, Talent_Code			
---------------------------*/

--Declare
--	@Vendor_Rule_Code INT = 8,
--	--@SearchWithinRule CHAR(1),
--	--@IsShow CHAR(1)
--	@Columns_Code NVARCHAR(MAX) = '242,243',
--	@NotInTitles NVARCHAR(MAX) = '',
--	@TitleName NVARCHAR(MAX) = '',
--	@Genres_Code NVARCHAR(MAX) = '',
--	@Talent_Code NVARCHAR(MAX) = '',
--	@AL_Recommendation_Code int = '',
--	@SearchWithinRule CHAR(1) = 'Y',
--	@Banner_Code NVARCHAR(MAX) = ''

IF(OBJECT_ID('tempdb..#TempOutput') IS NOT NULL) DROP TABLE #TempOutput
IF(OBJECT_ID('tempdb..#tempTitle') IS NOT NULL) DROP TABLE #tempTitle
IF(OBJECT_ID('tempdb..#tempHeaders') IS NOT NULL) DROP TABLE #tempHeaders
IF(OBJECT_ID('tempdb..#TitleCode') IS NOT NULL) DROP TABLE #TitleCode
IF(OBJECT_ID('tempdb..#tempRule') IS NOT NULL) DROP TABLE #tempRule
IF(OBJECT_ID('tempdb..#tempInfo') IS NOT NULL) DROP TABLE #tempInfo	
IF(OBJECT_ID('tempdb..#tempBannerTitle') IS NOT NULL) DROP TABLE #tempBannerTitle
IF(OBJECT_ID('tempdb..#TempARD') IS NOT NULL) DROP TABLE #TempARD

CREATE TABLE #TempOutput
	(
		COL1 NVARCHAR(MAX),
		COL2 NVARCHAR(MAX),
		COL3 NVARCHAR(MAX),
		COL4 NVARCHAR(MAX),
		COL5 NVARCHAR(MAX),
		COL6 NVARCHAR(MAX),
		COL7 NVARCHAR(MAX),
		COL8 NVARCHAR(MAX),
		COL9 NVARCHAR(MAX),
		COL10 NVARCHAR(MAX),
		COL11 NVARCHAR(MAX),
		COL12 NVARCHAR(MAX),
		COL13 NVARCHAR(MAX),
		COL14 NVARCHAR(MAX),
		COL15 NVARCHAR(MAX),
		COL16 NVARCHAR(MAX),
		COL17 NVARCHAR(MAX),
		COL18 NVARCHAR(MAX),
		COL19 NVARCHAR(MAX),
		COL20 NVARCHAR(MAX),
		
	)

	CREATE table #tempTitle(
		Title_Code INT,
		Title_Content_Code INT,
		Title NVARCHAR(max),
		Season NVARCHAR(MAX),
		[Star Cast] NVARCHAR(MAX),
		Genres NVARCHAR(MAX),
		Synopsis NVARCHAR(MAX),
		Info NVARCHAR(MAX),
		Rule_Type NVARCHAR(10)
	)

	CREATE TABLE #tempHeaders(
		ColNames NVARCHAR(MAX)	
	)

	CREATE TABLE #tempRule(
	 Columns_Code INT,
	 Columns_Value NVARCHAR(MAX),
	 Additional_Condition NVARCHAR(MAX)
	)

	CREATE TABLE #TitleCode(
		Title_Code INT
	)

	DECLARE @CriteriaColumns AS TABLE
	(
		Columns_Code INT
	)

	CREATE TABLE #TempInfo
	(
		Title_Code INT,
		Info NVARCHAR(MAX)
	)

	CREATE table #tempBannerTitle(
		Title_Code INT,
		Title_Content_Code INT
	)

	DECLARE @SkipRule Char(1) = 'N'

	Declare @RuleType CHAR(1), @DealTypeCode VARCHAR(MAx)
	SET @RuleType = (Select Rule_Type from AL_Vendor_Rule WHERE AL_Vendor_Rule_Code = @Vendor_Rule_Code)

	IF(@RuleType = 'M')
	BEGIN
		SET @DealTypeCode = 1
	END
	ELSE
	BEGIN
		SET @DealTypeCode = 11
	END

	IF(@AL_Recommendation_Code > 0 AND @SearchWithinRule = 'N')
	BEGIN
		SET @SkipRule = 'Y'
	END
	ELSE IF((@AL_Recommendation_Code > 0 AND @SearchWithinRule = 'Y') OR @AL_Recommendation_Code = 0)
	BEGIN
		SET @SkipRule = 'N'
	END

	--If no rule is selected
	IF(@AL_Recommendation_Code = 0 AND (@Columns_Code = '' OR @Columns_Code = '0'))
	BEGIN
		SET @SkipRule = 'Y'
	END

	IF(@Columns_Code = '' OR @Columns_Code = '0')
	BEGIN
		SET @SkipRule = 'Y'
	END

	INSERT INTO #tempBannerTitle( Title_Code)
	SELECT DISTINCT Record_Code 
	FROM Map_Extended_Columns_Details mecd 
	INNER JOIN Map_Extended_Columns mec ON mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code
	WHERE mecd.Columns_Value_Code IN (Select number From dbo.fn_Split_withdelemiter(@Banner_Code,',')) AND Columns_Code = 32 AND mec.Table_Name = 'TITLE'
	
	IF(@SkipRule = 'N')
	BEGIN
		IF(@Columns_Code = '' OR @Columns_Code = '0')--@IsView = 'Y')
		BEGIN
			INSERT INTO @CriteriaColumns
			SELECT DISTINCT ec.Columns_Code 
			FROM AL_Vendor_Rule vr
			INNER JOIN AL_Vendor_Rule_Criteria vrc ON vrc.AL_Vendor_Rule_Code = vr.AL_Vendor_Rule_Code
			INNER JOIN Extended_Columns ec ON ec.Columns_Code = vrc.Columns_Code
			WHERE --vr.Vendor_Code = 2470 AND
			vr.AL_Vendor_Rule_Code = @Vendor_Rule_Code
			
			SET @Columns_Code = ( Select ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(c.Columns_Code AS VARCHAR(Max))[text()] FROm @CriteriaColumns c
					 FOR XML PATH(''), TYPE)
					.value('.','NVARCHAR(MAX)'),1,2,' '),'' ))
				
		END

		INSERT INTO #tempRule(Columns_Code, Columns_Value, Additional_Condition)
		Select DISTINCT vrc.Columns_Code, vrc.Columns_Value, egc.Additional_Condition 
		from AL_Vendor_Rule_Criteria vrc
		INNER JOIN Extended_Group_Config egc ON egc.Columns_Code = vrc.Columns_Code
		INNER JOIN Extended_Group eg ON eg.Extended_Group_Code = egc.Extended_Group_Code
		WHERE vrc.AL_Vendor_Rule_Code IN (@Vendor_Rule_Code) --AND Extended_Group_Code = 11
		AND vrc.Columns_Code IN (Select number From dbo.fn_Split_withdelemiter(@Columns_Code,','))
		AND eg.Module_Code = 10

		--INSERT INTO #tempTitle
		--SELECT 1,1,'A Christmas Story Christmas', 'Peter Billingsley, Erinn Hayes, Julianna Layne','Children, Comedy, Family', 'English | 2023 | ThumbsUp | 7500K | 8.8 | Up'
		--UNION
		--SELECT 2,2,'The Storied Life Of A.J. Fikry', 'Kunal Nayyar, Lucy Hale, Christina Hendricks','Drama ,Fantasy ,Romance', 'English | 2023 | ThumbsUp | 7500K | 8.8 | Down'
		--UNION
		--SELECT 3,3,'Bandit', 'Josh Duhamel, Mel Gibson, Elisha Cuthbert','Action,Thriller', 'English | 2023 | ThumbsUp | 7500K | 8.8 | Down'
		--Declare @RuleType CHAR(1), @DealTypeCode VARCHAR(MAx)
		--SET @RuleType = (Select Rule_Type from AL_Vendor_Rule WHERE AL_Vendor_Rule_Code = @Vendor_Rule_Code)

		--IF(@RuleType = 'M')
		--BEGIN
		--	SET @DealTypeCode = 1
		--END
		--ELSE
		--BEGIN
		--	SET @DealTypeCode = 11
		--END

		DECLARE @query1 NVARCHAR(MAX)
		--SET @query1 = 'Select Title_Code from Title Where 1=1 '
		--IF(@NotInTitles = '') 
		BEGIN
			SET @query1 = 'Select Title_Code from Title Where Deal_Type_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL('''+@DealTypeCode+''', ''''), '','')) AND 1=1 '
		END
		--ELSE
		--BEGIN
		--	SET @query1 = 'Select Title_Code from Title Where Deal_Type_Code IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL('''+@DealTypeCode+''', ''''), '',''))
		--				AND Title_Code NOT IN (SELECT number from dbo.fn_Split_withdelemiter(ISNULL('''+@NotInTitles+''', ''''), '','')) AND 1=1 '
		--END
	
		CREATE TABLE #TempARD
		(
			Record_Code INT,
			ARD INT
		)

		INSERT INTO #TempARD(Record_Code, ARD)
		SELECT Record_Code, DATEDIFF(D, CAST(Column_Value AS DATE), GETDATE()) AS ARD 
		FROM Map_Extended_Columns 
		WHERE Table_Name = 'TITLE' AND Columns_Code = '37' AND ISDATE(Column_Value) = 1

		DECLARE @ColumnsCode INT, @ColumnsValue NVARCHAR(MAX), @AdditionalCondition NVARCHAR(MAX)

		DECLARE curRule CURSOR FOR
		Select Columns_Code, Columns_Value, Additional_Condition FROM #tempRule
		
		OPEN curRule
		FETCH NEXT FROM curRule
		INTO @ColumnsCode, @ColumnsValue, @AdditionalCondition
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		  
			SET @query1 = @query1 + @AdditionalCondition

			SET @query1 = REPLACE(@query1,'{REPLACE}',@ColumnsValue)    
			
			FETCH NEXT FROM curRule
			INTO @ColumnsCode, @ColumnsValue, @AdditionalCondition
		END
		CLOSE curRule;
		DEALLOCATE curRule;

		--PRINT @query1

		INSERT INTO #TitleCode(Title_Code)
		EXEC (@query1)

	END
	--ELSE IF(@AL_Recommendation_Code = 0 AND (@Columns_Code = '' OR @Columns_Code = 0))
	ELSE IF((@Columns_Code = '' OR @Columns_Code = 0))
	BEGIN
	
		INSERT INTO #TitleCode
		SELECT DISTINCT Title_Code FROM Title WHERE Deal_Type_Code IN (Select number From dbo.fn_Split_withdelemiter(@DealTypeCode,','))

		--Select * from #TitleCode
	END
	ELSE
	BEGIN
		INSERT INTO #TitleCode
		SELECT DISTINCT Title_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @AL_Recommendation_Code
	END
	
	IF(@Banner_Code <> '')
	BEGIN
		DELETE FROM #TitleCode WHERE Title_Code NOT IN (
			SELECT Title_Code FROM #tempBannerTitle 
		)
	END

	---Preference Exclusion Block------
		DECLARE @PrefExclusion TABLE(
			PrefExclusionCodes INT
		)

		INSERT INTO @PrefExclusion(PrefExclusionCodes)
		(Select number From dbo.fn_Split_withdelemiter((Select Pref_Exclusion_Codes
		from AL_Vendor_Rule  vr
		INNER JOIN AL_Vendor_Details vd ON vd.Vendor_Code = vr.Vendor_Code
		where vr.AL_Vendor_Rule_Code = @Vendor_Rule_Code),','))


		DELETE FROM #TitleCode WHERE Title_Code IN(
			SELECT DISTINCT tc.Title_Code
			FROM #TitleCode tc
			INNER JOIN Map_Extended_Columns mec ON mec.Record_Code = tc.Title_Code AND Table_Name = 'TITLE' AND Columns_Code = 51 -- for keywords
			INNER JOIN Map_Extended_Columns_Details mecd ON mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code
			WHERE mecd.Columns_Value_Code IN (Select PrefExclusionCodes from @PrefExclusion)
		)
			
		---Preference Exclusion Block End---

		IF(@Talent_Code <> '')
		BEGIN
			
			DELETE FROM #TitleCode WHERE Title_Code NOT IN (
				SELECT Talent_Code FROM Title_Talent WHERE Talent_Code IN (select number from dbo.fn_Split_withdelemiter(@Talent_Code,',')) AND Role_Code = 2
			)

		END

		IF(@Genres_Code <> '')
		BEGIN
			
			DELETE FROM #TitleCode WHERE Title_Code NOT IN (
				SELECT Genres_Code FROM Title_Geners WHERE Genres_Code IN (select number from dbo.fn_Split_withdelemiter(@Genres_Code,','))
			)

		END

	INSERT INTO #TempInfo
	SELECT DISTINCT tc.Title_Code, ISNULL(l.Language_Name,'NA')+' | '+  CAST(ISNULL(CAST(t.Year_Of_Production AS NVARCHAR), 'NA') AS NVARCHAR) +' | '+ ISNULL(ecv.Columns_Value,'NA')
	+' | '+ ISNULL(mec_pop.Column_Value,'NA') +' | '+ ISNULL(mec_rat.Column_Value,'NA')
	FROM #TitleCode tc
	INNER JOIN Title t ON t.Title_Code = tc.Title_Code
	INNER JOIN Language l ON l.Language_Code = t.Title_Language_Code
	LEFT JOIN Map_Extended_Columns mec_pop ON mec_pop.Record_Code = t.Title_Code AND mec_pop.Columns_Code = 39 AND mec_pop.Table_Name = 'TITLE'
	LEFT JOIN Map_Extended_Columns mec_rat ON mec_rat.Record_Code = t.Title_Code AND mec_rat.Columns_Code = 38 AND mec_rat.Table_Name = 'TITLE'
	LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code AND mec.Columns_Code = 40 AND mec.Table_Name = 'TITLE'
	LEFT JOIN Map_Extended_Columns_Details mecd ON mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code 
	LEFT JOIN Extended_Columns_Value ecv ON ecv.Columns_Value_Code = mecd.Columns_Value_Code AND ecv.Columns_Code = 40

	IF(@SkipRule = 'N')
	BEGIN
		INSERT INTO #tempTitle
		SELECT DISTINCT t.Title_Code,ISNULL(tc.Title_Content_Code,1) AS Title_Content_Code, --T.Title_Name,
		CASE WHEN @RuleType = 'M' THEN CAST (t.Title_Name AS NVARCHAR(MAX)) ELSE CAST(t.Title_Name AS NVARCHAR(MAX))+' (Eps No: ' +CAST(ISNULL(tc.Episode_No,1) AS NVARCHAR(MAX)) +')' END AS Title,
		ISNULL(mec.Column_Value,'') AS Season,
		ISNULL(REVERSE(stuff(reverse(  stuff(      
									(         
										select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ', '
										from Title_Talent TT    (NOLOCK)   
										inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal  (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
										FOR XML PATH(''), root('TalentName'), type      
				 ).value('/TalentName[1]','NVARCHAR(max)'     
									),1,0, ''      
								)      
					   ),1,2,'')),'') as [Star Cast], ISNULL([dbo].[UFN_Get_Title_Genre](T.Title_Code),'') AS Genres, 
		ISNULL(tc.Synopsis,'') AS Synopsis,
		ti.Info AS Info,
		--'English | 2023 | ThumbsUp | 7500K | 8.8 | Down' AS Info,
		@RuleType 
		FROM #TitleCode tmpT
		INNER JOIN Title t ON t.Title_Code = tmpT.Title_Code
		INNER JOIN #TempInfo ti ON ti.Title_Code = tmpT.Title_Code
		--LEFT JOIN Title_Talent tt ON tt.Title_Code = t.Title_Code
		--LEFT JOIN Title_Geners tg ON tg.Title_Code = t.Title_Code
		INNER JOIN Title_Content tc ON tc.Title_Code = t.Title_Code AND tc.Title_Content_Code NOT IN (Select number From dbo.fn_Split_withdelemiter(@NotInTitles,','))
		LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code AND Table_Name = 'Title' AND Columns_Code = 31
		WHERE 
		--( '' = @Talent_Code OR tt.Talent_Code IN (select number from dbo.fn_Split_withdelemiter(@Talent_Code,',')))
		--AND ( '' = @Genres_Code OR tg.Genres_Code IN (select number from dbo.fn_Split_withdelemiter(@Genres_Code,',')))
		--AND 
		( '' = t.Title_Name OR t.Title_Name like '%'+@TitleName+'%')
		--where Title_Name like '%1947%'
	END
	
	ELSE
	BEGIN
		INSERT INTO #tempTitle
		SELECT DISTINCT t.Title_Code,ISNULL(tc.Title_Content_Code,1) AS Title_Content_Code, --T.Title_Name,
		CASE WHEN @RuleType = 'M' THEN CAST (t.Title_Name AS NVARCHAR(MAX)) ELSE CAST(t.Title_Name AS NVARCHAR(MAX))+' (Eps No: ' +CAST(ISNULL(tc.Episode_No,1) AS NVARCHAR(MAX)) +')' END AS Title,
		ISNULL(mec.Column_Value,'') AS Season,
		ISNULL(REVERSE(stuff(reverse(  stuff(      
									(         
										select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ', '
										from Title_Talent TT    (NOLOCK)  
										inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal  (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
										FOR XML PATH(''), root('TalentName'), type      
				 ).value('/TalentName[1]','NVARCHAR(max)'     
									),1,0, ''      
								)      
					   ),1,2,'')),'') as [Star Cast], ISNULL([dbo].[UFN_Get_Title_Genre](T.Title_Code),'') AS Genres, 
		ISNULL(tc.Synopsis,'') AS Synopsis,
		ti.Info AS Info,
		@RuleType 
		FROM #TitleCode tmpT
		INNER JOIN Title t ON t.Title_Code = tmpT.Title_Code
		INNER JOIN #TempInfo ti ON ti.Title_Code = tmpT.Title_Code
		INNER JOIN Title_Content tc ON tc.Title_Code = t.Title_Code AND tc.Title_Content_Code NOT IN (Select number From dbo.fn_Split_withdelemiter(@NotInTitles,','))
		LEFT JOIN Map_Extended_Columns mec ON mec.Record_Code = t.Title_Code AND Table_Name = 'Title' AND Columns_Code = 31
		WHERE 
		( '' = t.Title_Name OR t.Title_Name like '%'+@TitleName+'%')
		--AND tc.Title_Content_Code IN (SELECT DISTINCT Title_Content_Code FROM AL_Recommendation_Content WHERE AL_Recommendation_Code = @AL_Recommendation_Code)

	END


	INSERT INTO #tempHeaders(ColNames)
	SELECT Name 
	FROM   tempdb.sys.columns
	WHERE  object_id = Object_id('tempdb..#tempTitle'); 

	IF(@RuleType = 'M')
	BEGIN
		Delete FROM #tempHeaders WHERE ColNames IN ('Season', 'Synopsis')
	END
	
	INSERT INTO #TempOutput
	Select *
	from (
		Select ColNames, RowN = Row_Number() over (ORDER BY (SELECT NULL)) from #tempHeaders
    ) a
    pivot (max(ColNames) for RowN in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20])) p


	IF(@RuleType = 'M')
	BEGIN
		ALTER TABLE #tempTitle DROP COLUMN Season
		ALTER TABLE #tempTitle DROP COLUMN Synopsis
		
		INSERT INTO #TempOutput(COL1, COL2, COL3,COL4,Col5,COL6,COL7)
		SELECT * FROM #tempTitle
	END
	ELSE
	BEGIN
		INSERT INTO #TempOutput(COL1, COL2, COL3,COL4,Col5,COL6,COL7,COL8,COL9)
		SELECT * FROM #tempTitle
	END

	Select * from #TempOutput
	
	IF(OBJECT_ID('tempdb..#TempOutput') IS NOT NULL) DROP TABLE #TempOutput
	IF(OBJECT_ID('tempdb..#tempTitle') IS NOT NULL) DROP TABLE #tempTitle
	IF(OBJECT_ID('tempdb..#tempHeaders') IS NOT NULL) DROP TABLE #tempHeaders
	IF(OBJECT_ID('tempdb..#TitleCode') IS NOT NULL) DROP TABLE #TitleCode
	IF(OBJECT_ID('tempdb..#tempRule') IS NOT NULL) DROP TABLE #tempRule
	IF(OBJECT_ID('tempdb..#tempInfo') IS NOT NULL) DROP TABLE #tempInfo	
	IF(OBJECT_ID('tempdb..#tempBannerTitle') IS NOT NULL) DROP TABLE #tempBannerTitle
	IF(OBJECT_ID('tempdb..#TempARD') IS NOT NULL) DROP TABLE #TempARD

END