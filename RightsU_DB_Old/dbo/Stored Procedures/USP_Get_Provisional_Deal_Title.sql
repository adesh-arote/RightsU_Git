CREATE PROC USP_Get_Provisional_Deal_Title     
@SearchString NVARCHAR(MAX),    
@Deal_Type_Code INT     
AS    
BEGIN    
  --DECLARE @SearchString NVARCHAR(MAX)='2017'    
  IF(@SearchString='')  
  BEGIN  
    SELECT DISTINCT TIT.Title_Code, TIT.Title_Name FROM Title TIT    
 WHERE TIT.Deal_Type_Code=@Deal_Type_Code  AND   TIT.Title_Code not in (SELECT Title_Code FROM Acq_Deal_Movie)
  END  
  ELSE  
  BEGIN  
  SELECT DISTINCT TIT.Title_Code, TIT.Title_Name FROM Title TIT    
 LEFT JOIN Title_Talent TT ON TT.Title_Code = TIT.Title_Code    
 LEFT JOIN Talent TAT ON TAT.Talent_Code = TT.Talent_Code    
 LEFT JOIN Title_Geners TG ON TG.Title_Code = TIT.Title_Code    
 LEFT JOIN Genres G ON G.Genres_Code = TG.Genres_Code    
 WHERE     
 (    
  (TAT.Talent_Name LIKE '%'+@SearchString+'%' OR '' <> '') OR     
  (G.Genres_Name LIKE '%'+@SearchString+'%' OR ''<>'' ) OR     
  (TIT.Year_Of_Production LIKE '%'+@SearchString+'%' OR ''<>'') OR
  (TIT.Title_Name LIKE '%'+@SearchString+'%' OR ''<>'')
 )    
 AND TIT.Deal_Type_Code=@Deal_Type_Code  
 AND   TIT.Title_Code not in (SELECT Title_Code  FROM Acq_Deal_Movie)  
  END  
END