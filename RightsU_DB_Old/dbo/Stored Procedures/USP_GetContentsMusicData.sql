CREATE PROC USP_GetContentsMusicData  
(  
	@Title_Content_Code BIGINT
)  
AS  
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 11 January 2017
-- Description:	Get Content Music data
-- =============================================
BEGIN  
	SELECT MT.Music_Title_Name, COALESCE(MA.Music_Album_Name, MT.Movie_Album, '') AS Movie_Album, ML.Music_Label_Name, V.Version_Name [Version], V.Version_Code, 
	CONVERT(VARCHAR,CML.[From],108) + ':' +  RIGHT('00' + CAST(CML.From_Frame AS VARCHAR), 2) [From],  
	CONVERT(VARCHAR,CML.[To],108) + ':' + RIGHT('00' + CAST( CML.To_Frame as VARCHAR), 2) [To],  
	CONVERT(VARCHAR,CML.[Duration],108) + ':' +RIGHT('00' +  CAST(CML.Duration_Frame as VARCHAR), 2) [Duration]
	FROM Title_Content TC
	INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
	INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code
	INNER JOIN [Version] V ON V.Version_Code = TCV.Version_Code
	INNER JOIN Music_Title MT ON MT.Music_Title_Code = CML.Music_Title_Code
	INNER JOIN Music_Title_Label MTL ON MT.Music_Title_Code = MTL.Music_Title_Code  
		AND MTL.Effective_To IS NULL
	INNER JOIN Music_Label ML ON MTL.Music_Label_Code = ML.Music_Label_Code  
	LEFT JOIN Music_Type MTY ON MTY.Music_Type_Code = MT.Music_Type_Code  
	LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code
END
