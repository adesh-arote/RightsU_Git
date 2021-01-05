CREATE PROCEDURE [dbo].[USP_List_IPR]
(
	@tabName Varchar(2),
	@StrSearch NVARCHAR(MAX),	
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
-- Author:		Sagar Mahajan
-- Create date: 30 OCT 2014
-- Description:	IPR List
-- =============================================
BEGIN
SET FMTONLY OFF
	--DECLARE 
	--@StrSearch NVARCHAR(MAX) =  N'AND (IR.Application_No LIKE ''%प्रिज्म टीवी प्राइवेट लिमिटिड%'' OR IR.IPR_Type_Code IN(Select IPR_Type_Code From IPR_TYPE where TYPE LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'') OR IR.Trademark LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'' OR (IR.Trademark_Attorney LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'' OR IR.International_Trademark_Attorney LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'')  OR IR.Application_Status_Code IN(Select IPR_App_Status_Code from IPR_APP_STATUS where App_Status LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'') OR IR.Applicant_Code IN(Select IPR_Entity_Code from IPR_ENTITY where Entity LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'') OR (IC.Parent_Class_Code In (Select IC1.IPR_Class_Code From IPR_CLASS IC1 Where IC1.Description LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'') OR IC.Description LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%'') OR IR.Country_Code IN(Select IPR_Country_Code From IPR_Country where IPR_Country_Name LIKE N''%प्रिज्म टीवी प्राइवेट लिमिटिड%''))  AND IR.IPR_For = ''D''',	
	--@PageNo Int = 1,
	--@OrderByCndition NVARCHAR(100) = 'T.IPR_Rep_Code desc',
	--@IsPaging Varchar(2) = 'Y',
	--@PageSize Int = 10,
	--@RecordCount Int = 0,
	--@User_Code INT = 143,
	--@Module_Code INT = 114

	DECLARE @SqlPageNo NVARCHAR(MAX),@Sql NVARCHAR(MAX)
	SET NOCOUNT ON;	
	if(@PageNo=0)
		Set @PageNo = 1	
	Create Table #Temp
	(
		IPR_Rep_Code Int,
		RowId Varchar(200)		
	);
	SET @SqlPageNo = '
	WITH Y AS 
	(
		SELECT ISNULL(IR.IPR_Rep_Code, 0) AS IPR_Rep_Code,RowId = ROW_NUMBER() OVER (ORDER BY IR.IPR_Rep_Code desc) 
		FROM IPR_REP IR
		INNER JOIN IPR_TYPE IT ON IR.IPR_Type_Code=IT.IPR_Type_Code
		INNER JOIN IPR_REP_CLASS IRC ON IRC.IPR_Rep_Code = IR.IPR_Rep_Code
		INNER JOIN IPR_CLASS IC ON IC.IPR_Class_Code = IRC.IPR_Class_Code
		INNER JOIN IPR_Country IT_C ON IR.Country_Code=IT_C.IPR_Country_Code
		INNER JOIN IPR_APP_STATUS IAS ON IR.Application_Status_Code=IAS.IPR_App_Status_Code
		INNER JOIN IPR_ENTITY IE ON IR.Applicant_Code=IE.IPR_Entity_Code
		LEFT JOIN IPR_Rep_Business_Unit IPR_BU ON IR.IPR_Rep_Code=IPR_BU.IPR_Rep_Code
		LEFT JOIN IPR_Rep_Channel IPR_C ON IR.IPR_Rep_Code=IPR_C.IPR_Rep_Code
		Where 1= 1  '+@StrSearch+'
		GROUP BY IR.IPR_Rep_Code
	)
	INSERT INTO #Temp Select IPR_Rep_Code,RowId From Y'

	PRINT @SqlPageNo
	EXEC(@SqlPageNo)
	SELECT @RecordCount = ISNULL(COUNT(IPR_Rep_Code),0) FROM #Temp

	If(@IsPaging = 'Y')
		Begin	
			Delete From #Temp Where RowId < (((@PageNo - 1) * @PageSize) + 1) Or RowId > @PageNo * @PageSize 
		End	
	SET @Sql = 'SELECT T.IPR_Rep_Code,IR.Trademark_No,IT.Type,Application_No,Application_Date,IPR_Country_Name as Country,
	--CASE WHEN ISNULL(Date_of_USe,'''') !='''' THEN Date_of_USe ELSE Proposed_Or_Date END AS Date_of_Use,
	ISNULL(Date_of_USe,'''') as Date_of_Use,
	IAS.App_Status,IE.Entity,Trademark_Attorney, IR.Workflow_Status AS Workflow_Status_Flag,
	CASE ISNULL(IR.Workflow_Status, '''')
		WHEN ''A'' THEN ''Approved''
		WHEN ''E'' THEN ''Edited''
		ELSE ''Added''
	END AS Workflow_Status, IR.Version
	,IR.Trademark,Dbo.UFN_Get_Class_Description(T.IPR_Rep_Code) as Class_Description
	,IR.International_Trademark_Attorney,
	DBO.UFN_Get_IPR_Metadata(T.IPR_Rep_Code, ''REP'', ''BU'') AS Business_Unit,
	DBO.UFN_Get_IPR_Metadata(T.IPR_Rep_Code, ''REP'', ''CHANNEL'')Channel_Name,
	dbo.[UFN_BUTTON_VISIBILITY]('+ CAST(@User_Code AS VARCHAR(50)) +','+CAST(@Module_Code AS varchar(50))+') Show_Hide_Buttons
	FROM IPR_REP IR
	INNER JOIN IPR_TYPE IT ON IR.IPR_Type_Code=IT.IPR_Type_Code
	INNER JOIN IPR_Country IT_C ON IR.Country_Code=IT_C.IPR_Country_Code
	INNER JOIN IPR_APP_STATUS IAS ON IR.Application_Status_Code=IAS.IPR_App_Status_Code
	INNER JOIN IPR_ENTITY IE ON IR.Applicant_Code=IE.IPR_Entity_Code
	INNER JOIN #Temp T ON IR.IPR_Rep_Code=T.IPR_Rep_Code ORDER BY ' + @OrderByCndition

	PRINT @Sql
	EXEC(@Sql)
	--DROP TABLE #Temp

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	
	--uncomment for Create complex type in entity framework
	--SELECT IR.IPR_Rep_Code,IR.Trademark_No,IT.Type,Application_No,Application_Date,IPR_Country_Name as Country,	
	--ISNULL(Date_of_USe,'') as Date_of_Use,
	--IAS.App_Status,IE.Entity,Trademark_Attorney, IR.Workflow_Status AS Workflow_Status_Flag,
	--CASE ISNULL(IR.Workflow_Status, '')
	--	WHEN 'A' THEN 'Approved'
	--	ELSE 'Added'
	--END AS Workflow_Status, IR.Version
	--,IR.Trademark,Dbo.UFN_Get_Class_Description(IR.IPR_Rep_Code) as Class_Description
	--,IR.International_Trademark_Attorney,
	--DBO.UFN_Get_IPR_Metadata(IR.IPR_Rep_Code, 'REP', 'BU') AS Business_Unit,
	--DBO.UFN_Get_IPR_Metadata(IR.IPR_Rep_Code, 'REP', 'CHANNEL') AS Channel_Name,
	--dbo.[UFN_BUTTON_VISIBILITY](200,114) Show_Hide_Buttons
	--FROM IPR_REP IR
	--INNER JOIN IPR_TYPE IT ON IR.IPR_Type_Code=IT.IPR_Type_Code
	--INNER JOIN IPR_Country IT_C ON IR.Country_Code=IT_C.IPR_Country_Code
	--INNER JOIN IPR_APP_STATUS IAS ON IR.Application_Status_Code=IAS.IPR_App_Status_Code
	--INNER JOIN IPR_ENTITY IE ON IR.Applicant_Code=IE.IPR_Entity_Code
END