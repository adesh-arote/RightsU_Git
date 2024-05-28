CREATE VIEW dbo.VW_MusicTitleDetail
AS
SELECT t.Title_Code AS Title_Code, t.Title_Name AS Title_Name, mt.Music_Title_Code AS Music_Title_Code, mt.Music_Title_Name AS Music_Title_Name, ml.Music_Label_Code AS Music_Label_Code, t.Deal_Type_Code 
FROM Title t 
		LEFT JOIN Music_Title mt ON mt.Title_Code = t.Title_Code
		LEFT JOIN Music_Title_Label mtl ON mtl.Music_Title_Code = mt.Music_Title_Code
		LEFT JOIN Music_Label ml ON ml.Music_Label_Code = mtl.Music_Label_Code
WHERE t.Reference_Flag IS NULL