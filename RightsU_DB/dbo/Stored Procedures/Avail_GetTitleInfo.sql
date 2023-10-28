CREATE PROC [dbo].[Avail_GetTitleInfo]
(    
 @Title_Code INT
)     
AS        
BEGIN  
	Declare @Loglevel int

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetTitleInfo]', 'Step 1', 0, 'Started Procedure', 0, ''

	SELECT	DISTINCT T.Title_Code TitleCode, 
			T.Title_Language_Code LanguageCode,
			CASE WHEN ISNULL(Year_Of_Production, '') = '' THEN Title_Name ELSE Title_Name + ' ('+ CAST(Year_Of_Production AS VARCHAR(10)) + ')' END TitleName,
			Genre = [dbo].[UFN_GetGenresForTitle](T.Title_Code),
			StarCast = [dbo].[UFN_GetStarCastForTitle](T.Title_Code),
			Director = [dbo].[UFN_GetDirectorForTitle](T.Title_Code),
			COALESCE(T.Duration_In_Min, '0') Duration, 
			COALESCE(T.Year_Of_Production, '') ReleaseYear,
			L.Language_Name LanguageName,
			AD.Business_Unit_Code BusinessUnitCode,DT.Deal_Type_Name,DT.Deal_Type_Code
	FROM Title T (NOLOCK)
	INNER JOIN [Language] L (NOLOCK) ON T.Title_Language_Code = L.Language_Code
	INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADM.Title_Code = T.Title_Code
	INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	Inner join deal_type DT (NOLOCK) ON AD.Deal_Type_Code = DT.Deal_Type_Code
	WHERE T.Title_Code = @Title_Code
	and AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Is_Master_Deal = 'Y'; 

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetTitleInfo]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END