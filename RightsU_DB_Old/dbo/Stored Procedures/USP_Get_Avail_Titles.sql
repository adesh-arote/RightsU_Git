ALTER proc [dbo].[USP_Get_Avail_Titles]     

 @txtSearch nvarchar(max),    
 @BU_Code VARCHAR(200), 
 @AvailType char(1),
 @TitleNoInCodes Varchar(1000) 
As
-- =============================================    
-- Author:  Rahul Kembhavi    
-- Create date: 15 May 2017    
-- Description: This Procedure will search Title Names    
-- =============================================    
BEGIN    
--SET    
--@txtSearch = 'aaj'    

IF(@AvailType = 'M')
	Begin
		SELECT Title_Code,Title_Name FROM [title] where Title_Code Not in (Select Number From Fn_Split_WithDelemiter (@TitleNoInCodes, ','))     
		AND IS_Active='Y' AND Deal_Type_Code in (1,33,10)
		AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adm.Acq_Deal_Code WHERE  ad.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ad.Is_Master_Deal='Y' AND (ad.Business_Unit_Code= CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0))     
		AND ((Title_Name like '%'+@txtSearch+'%') OR (Year_Of_Production like '%'+@txtSearch+'%')  OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like N'%'+@txtSearch+'%') OR
  
		Title_Code IN (Select tt.Title_Code from Title_Talent tt INNER JOIN Talent t on t.Talent_Code = tt.Talent_Code 
		WHERE   t.Talent_Name like N'%'+@txtSearch+'%')     
		OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN  (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv WHERE ecv.Columns_Value LIKE N'%'+@txtSearch+'%')) )-- ORDER BY Title_Name ASC    
	End

IF(@AvailType = 'S')
	Begin
		SELECT Title_Code,Title_Name FROM [title] where Title_Code Not in (Select Number From Fn_Split_WithDelemiter (@TitleNoInCodes, ','))     
		AND IS_Active='Y' AND Deal_Type_Code Not in (1,33,10)
		AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm INNER JOIN 
		Acq_Deal ad ON ad.Acq_Deal_Code = adm.Acq_Deal_Code
		WHERE  ad.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  ad.Is_Master_Deal='Y' AND (ad.Business_Unit_Code= CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0))     
		AND ((Title_Name like '%'+@txtSearch+'%') OR (Year_Of_Production like '%'+@txtSearch+'%')  OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like N'%'+@txtSearch+'%') OR
  
		Title_Code IN (Select tt.Title_Code from Title_Talent tt INNER JOIN Talent t on t.Talent_Code = tt.Talent_Code WHERE t.Talent_Name like N'%'+@txtSearch+'%')     
		OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN  (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv WHERE ecv.Columns_Value LIKE N'%'+@txtSearch+'%')) )-- ORDER BY Title_Name ASC    
	End

END    

--exec USP_Get_Avail_Titles 'bha',1,'S','627'