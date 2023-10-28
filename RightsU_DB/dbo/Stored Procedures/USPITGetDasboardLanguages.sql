CREATE PROCEDURE [dbo].[USPITGetDasboardLanguages]
AS
BEGIN	
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USPITGetDasboardLanguages]', 'Step 1', 0, 'Started Procedure', 0, ''
		Exec [USPLogSQLSteps] '[USPITGetDasboardLanguages]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @LanguageNames NVARCHAR(MAX)
		SET @LanguageNames = (SELECT Parameter_Value FROM System_Parameter_New WITH(NOLOCK) WHERE Parameter_Name like '%DBLanguageNames_IT%')

		SELECT A.Language FROM (
		SELECT 'a' AS Sort,'ALL' AS Language
		UNION
		select 'b' AS Sort,number AS Language from dbo.fn_Split_withdelemiter(''+@LanguageNames+'',',') 
		UNION
		Select 'c' AS Sort,'Others'
		) AS A
		Order by A.Sort
		Exec [USPLogSQLSteps] '[USPITGetDasboardLanguages]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPITGetDasboardLanguages]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
