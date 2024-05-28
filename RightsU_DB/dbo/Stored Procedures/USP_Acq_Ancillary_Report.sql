CREATE PROCEDURE [dbo].[USP_Acq_Ancillary_Report]
@Agreement_No VARCHAR(50), @Title_Name VARCHAR(1000), @Business_Unit_Code VARCHAR(10), @SysLanguageCode INT
AS
-- =============================================
-- Author:		<Sagar Mahajan>
-- Create date: <10 Oct 2014>
-- Description:	<Ancillary Report>
-- =============================================
BEGIN	
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Ancillary_Report]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE 
		--@Agreement_No Varchar(50)='A-2018-00125',@Title_Name Varchar(1000)='',@Business_Unit_Code Varchar(10)=1, @SysLanguageCode INT=2
		IF OBJECT_ID('tempdb..#TempAcqAncillaryReport') IS NOT NULL
			DROP TABLE #TempAcqAncillaryReport

		DECLARE 
		@Col_Head01 NVARCHAR(MAX) = '',  
		@Col_Head02 NVARCHAR(MAX) = '',  
		@Col_Head03 NVARCHAR(MAX) = '',	
		@Col_Head04 NVARCHAR(MAX) = '',  
		@Col_Head05 NVARCHAR(MAX) = '',  
		@Col_Head06 NVARCHAR(MAX) = '',	
		@Col_Head07 NVARCHAR(MAX) = '',  
		@Col_Head08 NVARCHAR(MAX) = '',  
		@Col_Head09 NVARCHAR(MAX) = ''	

		SET NOCOUNT ON;
		SET @Agreement_No = '%' + @Agreement_No + '%'
		--SET @Title_Name = '%' + @Title_Name + '%'	
		--Here Title Name Means Title Code
		DECLARE @Deal_Type VARCHAR(30) = '' ,@acq_Deal_Code INT = 0
		SELECT TOP 1 @acq_Deal_Code =Acq_Deal_Code FROM Acq_Deal_Movie (NOLOCK) WHERE Title_Code IN
		(
			Select number from fn_Split_withdelemiter(@Title_Name,',')
		)	 
		SELECT TOP 1 @Deal_Type =dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) 
		FROM Acq_Deal AD (NOLOCK) WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code = @acq_Deal_Code
		SELECT DISTINCT
		 AD.Agreement_No,
		dbo.UFN_GetTitleName(ADAT.Acq_Deal_Ancillary_Code,@Title_Name,@Deal_Type) as Title_Name,
		At.Ancillary_Type_Name,
		AP.Platform_Name,
		dbo.UFN_Get_Acq_Ancillary_Medium(ADAP.Acq_Deal_Ancillary_Platform_Code) as Ancillary_Medium_Name,
		ADA.Day,
		ADA.Duration,
		ADA.Remarks,
		CASE 
			WHEN  ADA.Catch_Up_From = 'E' AND ISNULL(ADA.Catch_Up_From,'') <> '' THEN  'Each Broadcast'
			WHEN  ADA.Catch_Up_From = 'F' AND ISNULL(ADA.Catch_Up_From,'') <> '' THEN  'First Broadcast'
			ELSE  'NA'
		 END	AS Catch_Up_From
		 INTO #TempAcqAncillaryReport
		FROM Acq_Deal AD (NOLOCK)
		INNER JOIN Acq_Deal_Ancillary ADA (NOLOCK) ON AD.Acq_Deal_Code =ADA.Acq_Deal_Code
		INNER JOIN Acq_Deal_Ancillary_Title ADAT (NOLOCK) ON ADA.Acq_Deal_Ancillary_Code= ADAT.Acq_Deal_Ancillary_Code 
		--AND ADAT.Title_Code IN(Select number from fn_Split_withdelemiter(@Title_Name,','))
		AND (ADAT.Title_Code IN(Select number from fn_Split_withdelemiter(@Title_Name,',')) OR @Title_Name ='' )
		INNER JOIN Acq_Deal_Ancillary_Platform ADAP (NOLOCK) ON ADA.Acq_Deal_Ancillary_Code= ADAP.Acq_Deal_Ancillary_Code		
		INNER JOIN Ancillary_Type AT (NOLOCK) ON ADA.Ancillary_Type_code = AT.Ancillary_Type_Code			
		INNER JOIN Ancillary_Platform AP (NOLOCK) ON ADAP.Ancillary_Platform_code = AP.Ancillary_Platform_code 	
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No like @Agreement_No AND AD.Business_Unit_Code IN(@Business_Unit_Code)
		ORDER BY AD.Agreement_No DESC

		SELECT 
		@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
		@Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
		@Col_Head03 = CASE WHEN  SM.Message_Key = 'Type' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
		@Col_Head04 = CASE WHEN  SM.Message_Key = 'Rights' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
		@Col_Head05 = CASE WHEN  SM.Message_Key = 'CatchUpFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
		@Col_Head06 = CASE WHEN  SM.Message_Key = 'Medium' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
		@Col_Head07 = CASE WHEN  SM.Message_Key = 'Durationsec' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
		@Col_Head08 = CASE WHEN  SM.Message_Key = 'PeriodDay' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
		@Col_Head09 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END
		FROM System_Message SM   (NOLOCK)
		INNER JOIN System_Module_Message SMM (NOLOCK) ON SMM.System_Message_Code = SM.System_Message_Code  
		AND SM.Message_Key IN ('AgreementNo','Title','Type','Rights','CatchUpFrom','Medium','Durationsec','PeriodDay','Remarks')  
		INNER JOIN System_Language_Message SLM (NOLOCK) ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  


		SELECT [Agreement No], [Title], [Type], [Rights], [Medium], [Period(Day)], [Duration(Sec)], [Remarks], [Catch Up From]
			FROM (
				SELECT
				sorter = 1,
				CAST([Agreement_No] AS NVARCHAR(MAX)) AS [Agreement No], 
				CAST([Title_Name] AS VARCHAR(100)) AS [Title], 
				CAST([Ancillary_Type_Name] AS VARCHAR(100)) AS [Type],
				CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Rights], 
				CAST([Ancillary_Medium_Name] AS VARCHAR(100)) AS [Medium], 
				CAST([Day] AS VARCHAR(100)) AS [Period(Day)],
				CAST([Duration] AS NVARCHAR(MAX)) AS [Duration(Sec)], 
				CAST([Remarks] AS VARCHAR(100)) AS [Remarks], 
				CAST([Catch_Up_From] AS VARCHAR(100)) AS [Catch Up From]
				From #TempAcqAncillaryReport
				UNION ALL
					SELECT 0, @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head06, @Col_Head08, @Col_Head07, @Col_Head09, @Col_Head05
				) X   
		ORDER BY Sorter

		IF OBJECT_ID('tempdb..#TempAcqAncillaryReport') IS NOT NULL
			DROP TABLE #TempAcqAncillaryReport
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Ancillary_Report]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''	
END
