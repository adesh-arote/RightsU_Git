CREATE PROCEDURE [dbo].[USPITGetTitleLanguage]
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleLanguage]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		DECLARE 
		@LanguageNames NVARCHAR(MAX)
		SET @LanguageNames = (select Parameter_Value from System_Parameter_New WITH(NOLOCK) where Parameter_Name = 'TitleLanguages_IT') 
		SELECT Language_Code,Language_Name FROM Language WITH(NOLOCK) WHERE Language_Name IN (select number AS Language from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',',') )
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetTitleLanguage]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END