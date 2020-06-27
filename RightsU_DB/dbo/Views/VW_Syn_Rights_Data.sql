
CREATE VIEW [dbo].[VW_Syn_Rights_Data]
AS
-- =============================================
-- Author:		Sagar Mahajan/Abhaysingh N. Rajpurohit
-- Create date:	30 Jan 2015
-- Description:	Get distinct DATA of Syn Rights Data
-- =============================================

SELECT DISTINCT  SD.Syn_Deal_Code,SDR.Syn_Deal_Rights_Code,
SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To,
SDR.Is_Title_Language_Right,SDR.Is_Exclusive,SDR.Right_Type,
SDR.Actual_Right_Start_Date,ISNULL(SDR.Actual_Right_End_Date,'') AS Actual_Right_End_Date,
SDRP.Platform_Code,
SDRC.Territory_Type,SDRC.Country_Code,ISNULL(SDRC.Territory_Code,0) AS Territory_Code,
ISNULL(SDRS.Language_Code,0) AS SubTitle_Lang_Code,
0 AS Dubb_Lang_Code,
ISNULL(SDR.Is_Pushback,'N') AS Is_Pushback
FROM Syn_Deal SD
INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
INNER JOIN Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code=SDRT.Syn_Deal_Rights_Code
INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code
INNER JOIN Syn_Deal_Rights_Territory SDRC ON SDR.Syn_Deal_Rights_Code = SDRC.Syn_Deal_Rights_Code
LEFT JOIN Syn_Deal_Rights_Subtitling SDRS ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code
--LEFT JOIN Syn_Deal_Rights_Dubbing SDRD ON SDR.Syn_Deal_Rights_Code = SDRD.Syn_Deal_Rights_Code
WHERE 1 = 1
AND SDR.Actual_Right_Start_Date IS NOT NULL
Union
SELECT DISTINCT  SD.Syn_Deal_Code,SDR.Syn_Deal_Rights_Code,
SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To,
SDR.Is_Title_Language_Right,SDR.Is_Exclusive,SDR.Right_Type,
SDR.Actual_Right_Start_Date,ISNULL(SDR.Actual_Right_End_Date,'') AS Actual_Right_End_Date,
SDRP.Platform_Code,
SDRC.Territory_Type,SDRC.Country_Code,ISNULL(SDRC.Territory_Code,0) AS Territory_Code,
0 AS SubTitle_Lang_Code,
ISNULL(SDRD.Language_Code,0) AS Dubb_Lang_Code,
ISNULL(SDR.Is_Pushback,'N') AS Is_Pushback
FROM Syn_Deal SD
INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code=SDR.Syn_Deal_Code
INNER JOIN Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code=SDRT.Syn_Deal_Rights_Code
INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code
INNER JOIN Syn_Deal_Rights_Territory SDRC ON SDR.Syn_Deal_Rights_Code = SDRC.Syn_Deal_Rights_Code
--LEFT JOIN Syn_Deal_Rights_Subtitling SDRS ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code
LEFT JOIN Syn_Deal_Rights_Dubbing SDRD ON SDR.Syn_Deal_Rights_Code = SDRD.Syn_Deal_Rights_Code
WHERE 1 = 1
AND SDR.Actual_Right_Start_Date IS NOT NULL


/*

*/