CREATE PROCEDURE [dbo].[USPITTitleMetadata]
(
	--DECLARE
	@TitleCodes NVARCHAR(MAX) 
)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITTitleMetadata]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--DECLARE @TitleCodes NVARCHAR(MAX)  = '33656,33665'

		SELECT t.Title_Code, t.Title_Name, l.Language_Name, t.Duration_In_Min, t.Year_Of_Production, 
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Talent_Name AS NVARCHAR(MAX)) FROM Title_Talent TT WITH(NOLOCK)
			INNER JOIN Talent Tal WITH(NOLOCK) on tal.talent_Code = TT.Talent_code
			WHERE TT.Title_Code = t.Title_Code AND TT.Role_Code in (4)
			FOR XML PATH(''), ROOT('Producer'), TYPE
		).value('/Producer[1]','NVARCHAR(max)'), 1, 2, '')),'') AS Producer,
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Talent_Name AS NVARCHAR(MAX)) FROM Title_Talent TT WITH(NOLOCK)
			INNER JOIN Talent Tal WITH(NOLOCK) on tal.talent_Code = TT.Talent_code
			WHERE TT.Title_Code = t.Title_Code AND TT.Role_Code in (1)
			FOR XML PATH(''), ROOT('Director'), TYPE
		).value('/Director[1]','NVARCHAR(max)'), 1, 2, '')),'') AS Director,
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Talent_Name AS NVARCHAR(MAX)) FROM Title_Talent TT WITH(NOLOCK)
			INNER JOIN Talent Tal WITH(NOLOCK) on tal.talent_Code = TT.Talent_code
			WHERE TT.Title_Code = t.Title_Code AND TT.Role_Code in (2)
			FOR XML PATH(''), ROOT('StarCast'), TYPE
		).value('/StarCast[1]','NVARCHAR(max)'), 1, 2, '')),'') AS StarCast,
		ISNULL((STUFF(
		(
			SELECT DISTINCT ', '+ CAST(Tal.Genres_Name AS NVARCHAR(MAX)) FROM Title_Geners TG WITH(NOLOCK)
			INNER JOIN Genres Tal WITH(NOLOCK) ON tal.Genres_Code = TG.Genres_Code
			WHERE TG.Title_Code = t.Title_Code
			FOR XML PATH(''), ROOT('Genres'), TYPE
		).value('/Genres[1]','NVARCHAR(max)'), 1, 2, '')),'') AS Genres
		FROM Title t WITH(NOLOCK)
		INNER JOIN Language l WITH(NOLOCK) ON t.Title_Language_Code = l.Language_Code
		WHERE t.Title_Code IN (
			SELECT Number FROM DBO.fn_Split_withdelemiter(@TitleCodes, ',')
		)
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITTitleMetadata]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END