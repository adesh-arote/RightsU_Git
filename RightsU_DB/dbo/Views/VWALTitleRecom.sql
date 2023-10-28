CREATE VIEW [dbo].[VWALTitleRecom]  
AS  
SELECT alr.AL_Recommendation_Code, alrc.Title_Code, alrc.Title_Content_Code, CAST(ISNULL(vn.Vendor_Name,'') AS NVARCHAR(MAX))  AS [Airline],   
CAST(ISNULL(T.Title_Name,'') AS NVARCHAR(MAX)) AS [Title_Name], CAST(ISNULL(dt.Deal_Type_Name,'') AS NVARCHAR(MAX)) AS [Deal_Type_Name], CAST(ISNULL(t.Year_Of_Production,'') AS NVARCHAR(MAX)) AS [Year_Of_Production],   
CAST(ISNULL(l.Language_Name,'') AS NVARCHAR(MAX)) AS [Language_Name],  
CAST(STUFF((SELECT DISTINCT ', ' + CAST(TL.Talent_Name as NVARCHAR) FROM Title_Talent TC1 (NOLOCK)  
	INNER JOIN Talent TL (NOLOCK) ON TC1.Talent_Code = TL.Talent_Code  
	WHERE TC1.Title_Code = t.Title_Code AND TC1.Role_Code = 2  
	FOR XML PATH(''), TYPE).value('(./text())[1]','varchar(max)'),1, 2, N'') AS NVARCHAR(MAX)
) AS Star_Cast,  
CAST(STUFF((SELECT DISTINCT ', ' + CAST(TL.Talent_Name as NVARCHAR) FROM Title_Talent TC1 (NOLOCK)  
	INNER JOIN Talent TL (NOLOCK) ON TC1.Talent_Code = TL.Talent_Code  
	WHERE TC1.Title_Code = t.Title_Code AND TC1.Role_Code = 1 --4  
	FOR XML PATH(''), TYPE).value('(./text())[1]','varchar(max)'),1, 2, N'') AS NVARCHAR(MAX)
) AS Director,  
CAST(STUFF((SELECT DISTINCT ', ' + CAST(cn.Country_Name as NVARCHAR) FROM Title_Country TC1 (NOLOCK)  
	INNER JOIN Country cn (NOLOCK) ON TC1.Country_Code = cn.Country_Code  
	WHERE TC1.Title_Code = t.Title_Code  
	FOR XML PATH(''), TYPE).value('(./text())[1]','varchar(max)'),1, 2, N'') AS NVARCHAR(MAX)
) AS Country,
CAST(STUFF((SELECT DISTINCT ', ' + CAST(cn.Genres_Name as NVARCHAR) FROM Title_Geners TC1 (NOLOCK)  
	INNER JOIN Genres cn (NOLOCK) ON TC1.Genres_Code = cn.Genres_Code  
	WHERE TC1.Title_Code = t.Title_Code  
	FOR XML PATH(''), TYPE).value('(./text())[1]','varchar(max)'),1, 2, N'') AS NVARCHAR(MAX)
) AS Genre,
CAST(ISNULL(t.Synopsis,'') AS NVARCHAR(MAX)) AS [Synopsis] , CAST(ISNULL(LEN(t.Synopsis),'') AS NVARCHAR(MAX)) AS [Synopsis_Length],
CAST(ISNULL(t.Duration_In_Min,'0') AS NVARCHAR(MAX)) AS [Runtime], CAST(ISNULL(t.Duration_In_Min,'0') AS NVARCHAR(MAX)) AS [Runtime_Seconds],
CAST(ISNULL(tc.Episode_Title,'') AS NVARCHAR(MAX)) AS [Episode_Title], CAST(ISNULL(tc.Episode_No,'') AS NVARCHAR(MAX)) AS [Episode_No],
CAST(ISNULL(tc.Synopsis,'') AS NVARCHAR(MAX)) AS [Episode_Synopsis], CAST(ISNULL(LEN(tc.Synopsis),'') AS NVARCHAR(MAX)) AS [Episode_Synopsis_Length],
CAST(ISNULL(alr.Start_Date,'') AS NVARCHAR(MAX)) AS [Start_Date], CAST(ISNULL(alr.End_Date,'') AS NVARCHAR(MAX)) AS [End_Date],
CAST(ISNULL(alp.End_Date,'') AS NVARCHAR(MAX)) AS [Lic_End_Date], CAST(CASE WHEN ISNULL(alrc.Content_Type,'') = 'H' THEN 'Holdover' ELSE 'NEW' END AS NVARCHAR(MAX)) AS [Status],
CAST(ISNULL(avr.Rule_Name,'') AS NVARCHAR(MAX)) AS [Rule_Name]
FROM AL_Recommendation alr (NOLOCK) 
INNER JOIN AL_Recommendation_Content alrc (NOLOCK) ON alr.AL_Recommendation_Code = alrc.AL_Recommendation_Code  
INNER JOIN AL_Vendor_Rule avr (NOLOCK) ON alrc.AL_Vendor_Rule_Code = avr.AL_Vendor_Rule_Code
INNER JOIN AL_Proposal alp (NOLOCK) ON alr.AL_Proposal_Code = alp.AL_Proposal_Code  
INNER JOIN Title t (NOLOCK) ON alrc.Title_Code = t.Title_Code  
INNER JOIN Vendor vn (NOLOCK) ON alp.Vendor_Code = vn.Vendor_Code  
INNER JOIN Deal_Type dt (NOLOCK) ON t.Deal_Type_Code = dt.Deal_Type_Code  
INNER JOIN Language l (NOLOCK) ON t.Title_Language_Code = l.Language_Code  
LEFT JOIN Title_Content tc (NOLOCK) ON alrc.Title_Content_Code = tc.Title_Content_Code AND t.Title_Code = tc.Title_Code