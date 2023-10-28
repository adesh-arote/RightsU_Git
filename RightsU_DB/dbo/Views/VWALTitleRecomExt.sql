CREATE VIEW [dbo].[VWALTitleRecomExt]
AS
SELECT * FROM (
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, mec.Column_Value
FROM Map_Extended_Columns mec (NOLOCK)
INNER JOIN AL_OEM alo (NOLOCK) ON mec.Record_Code = alo.AL_OEM_Code AND mec.Table_Name = 'AL_OEM'
INNER JOIN Extended_Columns ec (NOLOCK) ON mec.Columns_Code = ec.Columns_Code
UNION ALL
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, mec.Column_Value
FROM Map_Extended_Columns mec (NOLOCK)
INNER JOIN Title t (NOLOCK) ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' AND mec.Is_Multiple_Select = 'N' AND mec.Columns_Value_Code IS NULL
INNER JOIN Extended_Columns ec (NOLOCK) ON mec.Columns_Code = ec.Columns_Code
UNION ALL
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, ecv.Columns_Value
FROM Map_Extended_Columns (NOLOCK) mec
INNER JOIN Title t (NOLOCK) ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' AND mec.Is_Multiple_Select = 'N' AND mec.Columns_Value_Code IS NOT NULL
INNER JOIN Extended_Columns_Value ecv (NOLOCK) ON ecv.Columns_Value_Code = mec.Columns_Value_Code
INNER JOIN Extended_Columns ec (NOLOCK) ON ec.Columns_Code = ecv.Columns_Code AND mec.Columns_Code = ec.Columns_Code
UNION ALL
--SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, bn.Banner_Name
--FROM Map_Extended_Columns mec
--INNER JOIN Title t ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' 
--AND mec.Is_Multiple_Select = 'N' AND mec.Columns_Value_Code IS NOT NULL
--INNER JOIN Banner bn ON bn.Banner_Code = mec.Columns_Value_Code 
--INNER JOIN Extended_Columns ec ON mec.Columns_Code = ec.Columns_Code AND ec.Ref_Table = 'BANNER'
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, bn.Banner_Name
FROM Map_Extended_Columns mec (NOLOCK)
INNER JOIN Title t (NOLOCK) ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' 
AND mec.Is_Multiple_Select = 'N' --AND mec.Columns_Value_Code IS NOT NULL
INNER JOIN Map_Extended_Columns_Details mecd (NOLOCK) ON mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code 
INNER JOIN Banner bn (NOLOCK) ON bn.Banner_Code = mecd.Columns_Value_Code 
INNER JOIN Extended_Columns ec (NOLOCK) ON mec.Columns_Code = ec.Columns_Code AND ec.Ref_Table = 'BANNER'
UNION ALL
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, 
STUFF((
	SELECT DISTINCT ', ' + tl.Talent_Name
	FROM Map_Extended_Columns_Details mecd
	INNER JOIN Talent tl ON mecd.Columns_Value_Code = tl.Talent_Code
	WHERE mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code
FOR XML PATH('')), 1, 2, '') AS Talent_Names
FROM (SELECT Record_Code, Table_Name, Columns_Code, Is_Multiple_Select, Map_Extended_Columns_Code FROM Map_Extended_Columns WHERE Table_Name = 'TITLE' AND Is_Multiple_Select = 'Y') mec 
INNER JOIN Title t (NOLOCK) ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' AND mec.Is_Multiple_Select = 'Y'
INNER JOIN (SELECT Columns_Code, Columns_Name, Ref_Table, Is_Defined_Values, Is_Multiple_Select FROM Extended_Columns WHERE Ref_Table = 'TALENT' ) ec ON mec.Columns_Code = ec.Columns_Code AND ec.Ref_Table = 'TALENT'
UNION ALL
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, 
STUFF((
	SELECT DISTINCT ', ' + ecv.Columns_Value
	FROM Map_Extended_Columns_Details mecd (NOLOCK)
	INNER JOIN Extended_Columns_Value ecv (NOLOCK) ON mecd.Columns_Value_Code = ecv.Columns_Value_Code
	WHERE mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code
FOR XML PATH('')), 1, 2, '') AS Talent_Names
FROM (SELECT Record_Code, Table_Name, Columns_Code, Is_Multiple_Select, Map_Extended_Columns_Code FROM Map_Extended_Columns WHERE Table_Name = 'TITLE' AND Is_Multiple_Select = 'Y') mec 
INNER JOIN Title t (NOLOCK) ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' AND mec.Is_Multiple_Select = 'Y'
INNER JOIN (SELECT Columns_Code, Columns_Name, Ref_Table, Is_Defined_Values, Is_Multiple_Select FROM Extended_Columns WHERE Ref_Table = 'Extended_Columns_Value' OR (Is_Defined_Values = 'Y' AND Is_Multiple_Select = 'Y')) ec ON ec.Columns_Code = mec.Columns_Code AND 
(ec.Ref_Table = 'Extended_Columns_Value' OR (ec.Is_Defined_Values = 'Y' AND ec.Is_Multiple_Select = 'Y'))
UNION ALL
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, al.AL_Lab_Name
FROM Map_Extended_Columns mec (NOLOCK)
INNER JOIN Title t (NOLOCK) ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' 
AND mec.Is_Multiple_Select = 'N' --AND mec.Columns_Value_Code IS NOT NULL
INNER JOIN Map_Extended_Columns_Details mecd (NOLOCK) ON mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code 
INNER JOIN AL_Lab al (NOLOCK) ON al.AL_Lab_Code = mecd.Columns_Value_Code 
INNER JOIN Extended_Columns ec (NOLOCK) ON mec.Columns_Code = ec.Columns_Code AND ec.Ref_Table = 'AL_Lab'
UNION ALL
SELECT mec.Record_Code, mec.Table_Name, mec.Columns_Code, ec.Columns_Name, v.Version_Name
FROM Map_Extended_Columns mec (NOLOCK)
INNER JOIN Title t (NOLOCK) ON mec.Record_Code = t.Title_Code AND mec.Table_Name = 'TITLE' 
AND mec.Is_Multiple_Select = 'N' --AND mec.Columns_Value_Code IS NOT NULL
INNER JOIN Map_Extended_Columns_Details mecd (NOLOCK) ON mecd.Map_Extended_Columns_Code = mec.Map_Extended_Columns_Code 
INNER JOIN Version v (NOLOCK) ON v.Version_Code = mecd.Columns_Value_Code 
INNER JOIN Extended_Columns ec (NOLOCK) ON mec.Columns_Code = ec.Columns_Code AND ec.Ref_Table = 'Version'
) AS A
WHERE ISNULL(A.Column_Value,'') <> ''