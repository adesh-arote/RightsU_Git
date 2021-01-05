CREATE PROCEDURE [dbo].[USP_List_IPR_Opp]
(
	@Ipr_For CHAR(1),
	@StrSearch NVARCHAR(Max),	
	@PageNo Int,
	@OrderByCndition NVARCHAR(100),
	@IsPaging Varchar(2),
	@PageSize Int,
	@RecordCount Int OUT,
	@User_Code INT,
	@Module_Code INT
)	
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 19 Aug 2015
-- Description:	IPR Opp List
-- =============================================
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;	
	
	--DECLARE @Ipr_For CHAR(1), @StrSearch Varchar(Max), @PageNo Int, @OrderByCndition Varchar(100), @IsPaging Varchar(2), @PageSize Int, @RecordCount Int
	--SELECT  @Ipr_For  = 'B', @StrSearch = '', @PageNo = 1, @OrderByCndition = 'IOp.IPR_Opp_Code desc', 
	--@IsPaging = 'Y', @PageSize = 10

	DECLARE @SqlPageNo NVARCHAR(Max),@Sql NVARCHAR(Max)

	IF(@PageNo = 0)
		SET @PageNo = 1	

	CREATE TABLE #Temp
	(
		IPR_Opp_Code Int,
		RowId Varchar(200)		
	)
	
	--@StrSearch will contains data like this
	--AND IOC.IPR_For = '' AND IR.Application_No = '' AND IR.Trademark = '' AND IR.Trademark_Attorney = ''
	--AND IRC.IPR_Class_Code = 0 AND IOP.Opp_No = '' AND IR.IPR_Type_Code = 0
	

	SET @SqlPageNo = '
	WITH Y AS 
	(
		SELECT IOp.IPR_Opp_Code,RowId = ROW_NUMBER() OVER (ORDER BY IOp.IPR_Opp_Code desc) 
		FROM IPR_Opp IOp
		INNER JOIN IPR_REP IR ON IOp.IPR_Rep_Code = IR.IPR_Rep_Code
		INNER JOIN IPR_REP_CLASS IRC ON IRC.IPR_Rep_Code = IR.IPR_Rep_Code
		LEFT JOIN IPR_CLASS IC ON IC.IPR_Class_Code = IOp.IPR_Class_Code OR IC.IPR_Class_Code = IRC.IPR_Class_Code
		LEFT JOIN IPR_Opp_Business_Unit IPR_BU ON IOp.IPR_Opp_Code=IPR_BU.IPR_Opp_Code
		LEFT JOIN IPR_Opp_Channel IPR_C ON IOp.IPR_Opp_Code=IPR_C.IPR_Opp_Code
		WHERE IOp.IPR_For = ''' + @Ipr_For + ''' '+@StrSearch+'
		GROUP BY IOp.IPR_Opp_Code
	)
	INSERT INTO #Temp Select IPR_Opp_Code,RowId From Y'

	EXEC(@SqlPageNo)
	SELECT @RecordCount = ISNULL(COUNT(IPR_Opp_Code),0) FROM #Temp

	IF(@IsPaging = 'Y')
	BEGIN
		DELETE FROM #Temp WHERE RowId < (((@PageNo - 1) * @PageSize) + 1) Or RowId > @PageNo * @PageSize 
	END	

	SET @Sql = '
	SELECT DISTINCT
		IOP.IPR_Opp_Code,
		IOP.[Version],
		IOP.IPR_For,
		IOP.Opp_No,
		IOP.Party_Name,
		IOP.Trademark AS Opposition_Party_Trademark,
		IR.Trademark AS Trademark,
		IOP.Application_No,
		IR.Application_No AS IPR_Rep_Application_No,
		IOP.IPR_Class_Code, IC.[Description] AS Class_Name,
		IOP.IPR_App_Status_Code,
		IOP.Order_Date,
		IOP.Outcomes,
		IOP.Comments,
		IAS.App_Status,
		CASE ISNULL(IOp.Workflow_Status, '''')
		WHEN ''A'' THEN ''Approved''
		WHEN ''E'' THEN ''Edited''
		ELSE ''Added''
		END AS Workflow_Status,
		IOp.Workflow_Status AS Workflow_Status_Flag,
		DBO.UFN_Get_IPR_Metadata(IOp.IPR_Opp_Code, ''OPP'', ''BU'') AS Business_Unit,
		DBO.UFN_Get_IPR_Metadata(IOp.IPR_Opp_Code, ''OPP'', ''CHANNEL'') AS Channel_Name,
		dbo.[UFN_BUTTON_VISIBILITY]('+ CAST(@User_Code AS VARCHAR(50)) +','+CAST(@Module_Code AS varchar(50))+') Show_Hide_Buttons
		 FROM IPR_Opp IOp
		INNER JOIN IPR_REP IR ON IOp.IPR_Rep_Code = IR.IPR_Rep_Code
		INNER JOIN IPR_APP_STATUS IAS ON IAS.IPR_App_Status_Code = IR.Application_Status_Code
		INNER JOIN IPR_REP_CLASS IRC ON IRC.IPR_Rep_Code = IR.IPR_Rep_Code
		LEFT JOIN IPR_CLASS IC ON IC.IPR_Class_Code = IOp.IPR_Class_Code
		INNER JOIN #Temp T ON IOp.IPR_Opp_Code=T.IPR_Opp_Code 
		ORDER BY ' + @OrderByCndition

	PRINT @Sql
	EXEC(@Sql)

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	--SELECT DISTINCT
	--IOP.IPR_Opp_Code,
	--IOP.[Version],
	--IOP.IPR_For,
	--IOP.Opp_No,
	--IOP.Party_Name,
	--IOP.Trademark AS Opposition_Party_Trademark,
	--IR.Trademark AS Trademark,
	--IOP.Application_No,
	--IR.Application_No AS IPR_Rep_Application_No,
	--IOP.IPR_Class_Code, IC.[Description] AS Class_Name,
	--IOP.IPR_App_Status_Code,
	--IOP.Order_Date,
	--IOP.Outcomes,
	--IOP.Comments,
	--IAS.App_Status,
	--CASE ISNULL(IOp.Workflow_Status, '')
	--	WHEN 'A' THEN 'Approved'
	--	ELSE 'Added'
	--END AS Workflow_Status,
	--IOp.Workflow_Status AS Workflow_Status_Flag ,
	--DBO.UFN_Get_IPR_Metadata(IOp.IPR_Opp_Code, 'OPP', 'BU') AS Business_Unit,
	--DBO.UFN_Get_IPR_Metadata(IOp.IPR_Opp_Code, 'OPP', 'CHANNEL') AS Channel_Name,
	--dbo.[UFN_BUTTON_VISIBILITY](200,114) Show_Hide_Buttons
	--FROM IPR_Opp IOp
	--INNER JOIN IPR_REP IR ON IOp.IPR_Rep_Code = IR.IPR_Rep_Code
	--INNER JOIN IPR_APP_STATUS IAS ON IAS.IPR_App_Status_Code = IR.Application_Status_Code
	--INNER JOIN IPR_REP_CLASS IRC ON IRC.IPR_Rep_Code = IR.IPR_Rep_Code
	--LEFT JOIN IPR_CLASS IC ON IC.IPR_Class_Code = IOP.IPR_Class_Code
END