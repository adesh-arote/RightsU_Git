CREATE PROCEDURE USP_List_MusicTrack
(
	@searchText NVARCHAR(500) = NULL
)
AS
BEGIN
	SELECT MT.Music_Title_Code, MT.Music_Title_Name, MT.Release_Year, MT.Duration_In_Min, MT.Movie_Album, ML.Music_Label_Name FROM Music_Title MT
	INNER JOIN Music_Title_Label MTL ON MT.Music_Title_Code = MTL.Music_Title_Code
	INNER JOIN Music_Label ML ON MTL.Music_Label_Code = ML.Music_Label_Code
	WHERE MT.Music_Title_Name LIKE N'%' + @searchText + '%' OR 
	MT.Movie_Album LIKE N'%' + @searchText + '%' OR
	ML.Music_Label_Name LIKE N'%' + @searchText + '%'
END
