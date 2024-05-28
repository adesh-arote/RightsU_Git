-- =============================================  
-- Author:  Adesh Popat Arote  
-- Create date: 11 Nov 2014
-- Description: The SP returns all Acq_Deal related   
--    counters of Rights (number of runs), scheduled and actual  
-- ============================================= 
 
alter PROCEDURE [dbo].[USP_Schedule_AsRun_Report_BAK_20141208]
(
	 @Title varchar(250),
	 @IsShowAll varchar(10)
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

	IF(@Title != '')
	BEGIN
		SET @filter = @filter  + ' AND DM.title_code in (select number from dbo.fn_Split_withdelemiter(''' + @Title + ''','',''))'
	END
	
	CREATE TABLE #tmpRightsUsage
	(  
		Agreement_No  VARCHAR(100),  
		Title_Code INT,  
		Acq_Deal_movie_code INT,  
		Title_Name VARCHAR(5000),
		Rights_Period VARCHAR(5000),  
		Provision_Run INT,  
		Actual_Run  INT
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

	SELECT
	D.Agreement_No, DM.title_code, DM.Acq_Deal_movie_code, T.Title_Name, 
	( select dbo.UFN_Get_DataFor_RightsUsageReport(DM.Acq_Deal_movie_code, ''RP'')),
	ISNULL(( select dbo.UFN_Get_DataFor_RightsUsageReport(DM.Acq_Deal_movie_code, ''PR'')),0),
	ISNULL(( select dbo.UFN_Get_DataFor_RightsUsageReport(DM.Acq_Deal_movie_code, ''AR'')),0)
	FROM Acq_Deal D  
	INNER JOIN Acq_Deal_Movie DM ON DM.Acq_Deal_code = D.Acq_Deal_code  
	INNER JOIN Title T ON T.title_code = DM.title_code 
	WHERE 1=1 and
	 AD.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND
	AND D.Deal_Type_Code in (select deal_type_code from Deal_Type WHERE deal_type_name = ''Movie'' AND is_active = ''Y'' ) 
	AND (D.is_active = ''Y'') 
	--AND ((D.deal_workflow_status = ''A'') OR D.[version] > 1)
	
	' + @filter
	

	PRINT @strSql
   print 'ad 2'
	EXEC(@strSql)
   print 'ad 1'
	SELECT * FROM #tmpRightsUsage order by Title_Name asc, CAST (Agreement_No   as VARCHAR) desc
	
	------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
	IF OBJECT_ID('tempdb..#tmpRightsUsage') IS NOT NULL
	BEGIN
		DROP TABLE #tmpRightsUsage
	END
	------------------------------------------- END DELETE TEMP TABLES -------------------------------------------		
   
END  
  
/*  
 EXEC [usp_Schedule_AsRun_Report]  @Title='363', @IsShowAll='N'
*/