


CREATE VIEW [dbo].[TitleMetaData]
AS
SELECT t.Title_Code, Title_Name, l.Language_Name AS Title_Language, t.Year_Of_Production AS YOR, Duration_In_Min AS Duration,
REVERSE(STUFF(REVERSE(
STUFF(
	(
		select DISTINCT cast(Tal.Talent_Name as NVARCHAR(MAX)) + ', ' from TitleTalent TT
		inner join Talent Tal on tal.talent_Code = TT.Talent_code
		where TT.Title_Code = t.Title_Code AND TT.Role_Code in (4)
		FOR XML PATH(''), root('Producer'), type
	).value('/Producer[1]','NVARCHAR(max)'),1,0, '')),
	1,2,'')
) AS Producer,
REVERSE(STUFF(REVERSE(
STUFF(
	(
		select DISTINCT cast(Tal.Talent_Name as NVARCHAR(MAX)) + ', ' from TitleTalent TT
		inner join Talent Tal on tal.talent_Code = TT.Talent_code
		where TT.Title_Code = t.Title_Code AND TT.Role_Code in (1)
		FOR XML PATH(''), root('Director'), type
	).value('/Director[1]','NVARCHAR(max)'),1,0, '')),
	1,2,'')
) AS Director,
REVERSE(STUFF(REVERSE(
STUFF(
	(
		select DISTINCT cast(Tal.Talent_Name as NVARCHAR(MAX)) + ', ' from TitleTalent TT
		inner join Talent Tal on tal.talent_Code = TT.Talent_code
		where TT.Title_Code = t.Title_Code AND TT.Role_Code in (2)
		FOR XML PATH(''), root('StarCast'), type
	).value('/StarCast[1]','NVARCHAR(max)'),1,0, '')),
	1,2,'')
) AS StarCast,
REVERSE(STUFF(REVERSE(
	STUFF(
	(
		select DISTINCT cast(Tal.Genres_Name as NVARCHAR(MAX)) + ', ' from TitleGenres TG
		inner join Genres Tal on tal.Genres_Code = TG.Genres_Code
		where TG.Title_Code = t.Title_Code
		FOR XML PATH(''), root('Genres'), type
	).value('/Genres[1]','NVARCHAR(max)'),1,0, '')),
	1,2,'')
) AS Genres,
(
	SELECT TOP 1 ecv.Columns_Value FROM RightsU_Plus_Testing.dbo.MAP_Extended_Columns exc
	INNER JOIN RightsU_Plus_Testing.dbo.Extended_Columns_Value ecv ON exc.Columns_Value_Code = ecv.Columns_Value_Code AND exc.Columns_Code = 1 AND Table_Name = 'TITLE' AND Record_Code = t.Title_Code
) AS Program_Category,
(
	SELECT TOP 1 ecv.Columns_Value FROM RightsU_Plus_Testing.dbo.MAP_Extended_Columns exc
	INNER JOIN RightsU_Plus_Testing.dbo.Extended_Columns_Value ecv ON exc.Columns_Value_Code = ecv.Columns_Value_Code AND exc.Columns_Code = 5 AND Table_Name = 'TITLE' AND Record_Code = t.Title_Code
) AS Censor_Details, t.Deal_Type_Code
FROM Title t
INNER JOIN Language l ON t.Title_Language_Code = l.Language_Code


