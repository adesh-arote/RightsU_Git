alter PROCEDURE [dbo].[USP_Schedule_AsRun_Report]
(
	 @Title varchar(250),
	 @EpisodeFrom INT = 0,
	 @EpisodeTo INT = 0,
	 @IsShowAll varchar(10),
	 @StartDate varchar(30),
	 @EndDate varchar(30),
	 @Channel VARCHAR(MAX),
	 @ExcludeExpiredDeal bit,
	 @RunType varchar(1)
)  
AS  
BEGIN  
-- SET NOCOUNT ON added to prevent extra result sets from  
-- interfering with SELECT statements.  
SET NOCOUNT ON;  
SET FMTONLY OFF;

	IF(ISNULL(@IsShowAll,'') = '')
	BEGIn
		SET @IsShowAll = 'N'
	END
	
	------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
	IF OBJECT_ID('tempdb..#tmpRightsUsage') IS NOT NULL
	BEGIN
		DROP TABLE #tmpRightsUsage
	END
	------------------------------------------- END DELETE TEMP TABLES -------------------------------------------	

	DECLARE @filter VARCHAR(MAX)
	DECLARE @strSql VARCHAR(MAX)
	SET @strSql=' '
	SET @filter = ' '

	if(@RunType <> '')
	BEGIN
	SET @filter = @filter + ' AND EXISTS(
	SELECT * FROM Acq_Deal_Run ADU
	INNER JOIN Acq_Deal_Run_Title ADUT ON ADU.Acq_Deal_Run_Code = ADUT.Acq_Deal_Run_Code
	WHERE ADU.Acq_Deal_Code = D.Acq_Deal_Code AND ADUT.Title_Code = DM.Title_Code AND ADU.Run_Type = '''+@RunType+'''
	)'
	END

	if(@ExcludeExpiredDeal = '1')
	BEGIN
	SET @filter = @filter + ' AND Exists (SELECT * FROM Acq_Deal_Rights ADR
				inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				Inner Join Acq_Deal_Rights_Title ADRT on ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				Inner Join Acq_Deal_Movie ADMR On ADRT.Title_Code = ADMR.Title_Code WHERE
				ADR.Acq_Deal_Code = D.Acq_Deal_Code
				And ADMR.Acq_Deal_Movie_Code = DM.Acq_Deal_Movie_Code
				AND ADRP.Platform_Code in
				(
					select platform_code from Platform where isnull(applicable_for_asrun_schedule,''N'') = ''Y''
				)
				AND ((Convert(date, ADR.Right_Start_Date, 103) >= Convert(date, GETDATE() , 103)) OR (Convert(date, isnull(ADR.Right_End_Date, GETDATE() ), 103) >= Convert(date, GETDATE() , 103)))
				)'
	END
	IF(@Channel != '')
	BEGIN
		SET @filter = @filter  + ' AND Exists	(SELECT * FROM Acq_Deal_Rights ADR 
				INNER JOIN Acq_Deal_Run ADRU ON ADR.Acq_Deal_Code=ADRU.Acq_Deal_Code AND ADRU.No_Of_Runs_Sched>0
				INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRU.Acq_Deal_Run_Code=ADRC.Acq_Deal_Run_Code AND ADRC.Channel_Code in ('+@Channel+')
				WHERE ADR.Acq_Deal_Code = D.Acq_Deal_Code)'
	END

	IF(@Title != '')
	BEGIN
		SET @filter = @filter  + ' AND DM.title_code in (select number from dbo.fn_Split_withdelemiter(''' + @Title + ''','',''))'
	END

	
	CREATE TABLE #tmpRightsUsage
	(  
		Agreement_No  VARCHAR(100),  
		Title_Code INT,  
		Acq_Deal_movie_code INT,  
		Title_Name NVARCHAR(MAX),
		Rights_Period VARCHAR(5000),  
		Provision_Run INT,  
		Actual_Run  INT,
		Deal_Code INT,
		Deal_Type CHAR(1),
		Episode_No INT
	)  
   
	IF( @IsShowAll = 'Y')
	BEGIN
		SET @filter = ' '
	END
	SET @strSql = '
	INSERT INTO #tmpRightsUsage
	(
		Agreement_No, title_code, Acq_Deal_movie_code, Title_Name, Rights_Period, Provision_Run, Actual_Run
	)

	SELECT distinct
	D.Agreement_No, DM.title_code, DM.Acq_Deal_movie_code, 
	DBO.UFN_GetTitleNameInFormat( dbo.UFN_GetDealTypeCondition(D.Deal_Type_Code), T.Title_Name, DM.Episode_Starts_From, DM.Episode_End_To) AS Title_Name, 
	( select dbo.UFN_Get_DataFor_RightsUsageReport_New(DM.Acq_Deal_movie_code, ''RP'','''+@StartDate+''','''+@EndDate+''','''+@Channel+''','''+@RunType+''')),
	ISNULL(( select dbo.UFN_Get_DataFor_RightsUsageReport_New(DM.Acq_Deal_movie_code, ''PR'','''+@StartDate+''','''+@EndDate+''','''+@Channel+''','''+@RunType+''')),0),
	ISNULL(( select dbo.UFN_Get_DataFor_RightsUsageReport_New(DM.Acq_Deal_movie_code, ''AR'','''+@StartDate+''','''+@EndDate+''','''+@Channel+''','''+@RunType+''')),0)
	FROM Acq_Deal D  
	INNER JOIN Acq_Deal_Movie DM ON DM.Acq_Deal_code = D.Acq_Deal_code  
	INNER JOIN Title T ON T.title_code = DM.title_code 
	--INNER JOIN Acq_Deal_Rights_Title ADRT on ADRT.Title_Code = T.Title_Code
	WHERE 1=1 and  D.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND
	AND D.Deal_Type_Code in (select deal_type_code from Deal_Type WHERE deal_type_name in (select Deal_Type_Name from Deal_Type where isnull(Is_Active,''N'') = ''Y'' AND  isnull(Is_Master_Deal,''N'') =''Y'' )) 
	AND (D.is_active = ''Y'')
	And dm.Acq_Deal_Movie_Code in (SELECT TCM.Acq_Deal_Movie_Code FROM Title_Content_Mapping TCM
								   INNER JOIN Title_Content tc ON tc.Title_Content_Code = TCM.Title_Content_Code
								   AND ISNULL(Ref_BMS_Content_Code,'''') <> '''') 
	--AND ((D.deal_workflow_status = ''A'') OR D.[version] > 1)
	' + @filter

	PRINT @strSql
 --  print 'ad 2'
	EXEC(@strSql)
 --  print 'ad 1'
	SELECT * FROM #tmpRightsUsage order by Title_Name asc, CAST (Agreement_No   as VARCHAR) desc
	
	------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
	IF OBJECT_ID('tempdb..#tmpRightsUsage') IS NOT NULL
	BEGIN
		DROP TABLE #tmpRightsUsage
	END
	------------------------------------------- END DELETE TEMP TABLES -------------------------------------------		
   
END  



/*
EXEc [dbo].[USP_Schedule_AsRun_Report] '5637,6000','N','','','','true','C'
EXEC USP_Schedule_AsRun_Report '1664','','','','','',''
SELECT
	D.Agreement_No, DM.title_code, DM.Acq_Deal_movie_code, 
	T.Title_Name,
	CASE WHEN [dbo].[UFN_GetDealTypeCondition](D.Deal_Type_Code) = 'DEAL_PROGRAM' 	
			THEN T.Title_Name + ' ( ' + CAST(ADRT.Episode_From AS VARCHAR) + ' - ' + CAST(ADRT.Episode_To AS VARCHAR) + ' ) '
				ELSE T.Title_Name 
			END	as 	Title_Name 
	FROM Acq_Deal D  
	INNER JOIN Acq_Deal_Movie DM ON DM.Acq_Deal_code = D.Acq_Deal_code  
	INNER JOIN Title T ON T.title_code = DM.title_code
	INNER JOIN Acq_Deal_Rights_Title ADRT on ADRT.Title_Code = T.Title_Code
	WHERE 1=1
	AND D.Deal_Type_Code in 
		(
			select deal_type_code from Deal_Type WHERE deal_type_name in 
			 (select Deal_Type_Name from Deal_Type where isnull(Is_Active,'N') = 'Y' AND  isnull(Is_Master_Deal,'N') ='Y' )
		) 
	AND (D.is_active = 'Y') 
*/