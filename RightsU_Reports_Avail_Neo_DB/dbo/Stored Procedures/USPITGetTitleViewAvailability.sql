CREATE PROCEDURE [dbo].[USPITGetTitleViewAvailability]
(
	@TitleCode VARCHAR(MAX)	
)
AS
BEGIN
	SELECT Main.Title_Code,	Main.Title_Name, Main.Episode_From,	Main.Episode_To, Main.Start_Date, Main.End_Date, Main.Term, Main.Exclusivity, Main.Title_Language, Main.Platform, ISNULL(Main.Subtitling,'NA') AS Subtitling, ISNULL(Main.Dubbing,'NA') AS Dubbing, rt.Cluster_Name, rt.Region_Name AS Region FROM (
		SELECT atd.Acq_Deal_Code AS DealCode, atd.Title_Code, t.Title_Name, atd.Episode_From, atd.Episode_To, 
			UPPER(REPLACE(CONVERT(VARCHAR(30), ad.Start_Date, 106), ' ', '-')) AS Start_Date, 
			UPPER(REPLACE(CONVERT(VARCHAR(30), ad.End_Date, 106), ' ', '-')) AS End_Date,
			[dbo].[UFN_Get_Rights_Term](ad.Start_Date, ad.End_Date, '') AS Term,
			CASE WHEN atd.Is_Exclusive = 1 THEN 'Exclusive' WHEN atd.Is_Exclusive = 2 THEN 'Co-Exclusive' ELSE 'Non-Exclusive' END AS Exclusivity, 
			CASE WHEN atd.Is_Title_Language = 1 THEN l.Language_Name ELSE 'NA' END AS Title_Language,
			STUFF(( 
				SELECT '~', ROW_NUMBER() OVER (ORDER BY p.Platform_Code), ') '+ p.Platform_Hiearachy FROM [dbo].[UFN_Get_Platform_With_Parent](ISNULL(ap.Platform_Codes,'')) AS p
				FOR XML PATH('')), 1, 1, ''
			) AS Platform,
			[dbo].[UFN_Get_Language_With_Parent](als.Language_Codes) AS Subtitling,
			[dbo].[UFN_Get_Language_With_Parent](ald.Language_Codes) AS Dubbing,
			ac.Country_Codes
		FROM Avail_Title_Data atd
		INNER JOIN Title t ON atd.Title_Code = t.Title_Code
		INNER JOIN Avail_Platforms ap ON atd.Avail_Platform_Code=ap.Avail_Platform_Code
		INNER JOIN avail_Countries ac ON ac.avail_Country_Code = atd.avail_Country_Code
		INNER JOIN Avail_Dates ad ON ad.Avail_Dates_Code=atd.Avail_Dates_Code
		INNER JOIN Language l ON t.Title_Language_Code  = l.Language_Code
		LEFT JOIN Avail_Languages als ON als.Avail_Languages_Code = atd.Avail_Subtitling_Code
		LEFT JOIN Avail_Languages ald ON ald.Avail_Languages_Code = atd.Avail_Dubbing_Code
		WHERE atd.Title_Code = @TitleCode 
	) AS Main
	CROSS APPLY DBO.UFN_Get_Report_Territory(Main.Country_Codes, 0) AS rt
END