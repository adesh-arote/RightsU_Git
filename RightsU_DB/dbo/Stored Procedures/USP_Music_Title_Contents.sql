--|=========================================================================================        
--| Author:    VIPUL SURVE        
--| Date Created: 25-Jan-2017        
--| Description:  Get the Content data related to Music Track         
--|=========================================================================================        
        
CREATE PROCEDURE [dbo].[USP_Music_Title_Contents]                    
(                    
@MusicTitleCode INT,                    
@GenericSearch VARCHAR(MAX),                    
@RecordCount Int out,                    
@IsPaging Varchar(2),                    
@PageSize Int,                    
@PageNo Int                    
)                    
AS                    
BEGIN                    
DECLARE @TitleContentCode VARCHAR(MAX)                   
                    
                    
SET @TitleContentCode = (SELECT  distinct                    
    STUFF((SELECT ', ' + CAST(Title_Content_Code AS VARCHAR(10)) [text()]                    
        FROM Content_Music_Link                     
        WHERE Music_Title_Code = @MusicTitleCode                    
        FOR XML PATH(''), TYPE)                    
    .value('.','NVARCHAR(MAX)'),1,2,' ') Title_Content_Code)                    
                    
SELECT Id = ROW_NUMBER() OVER (ORDER BY TC.Title_Content_Code desc) ,  TC.Episode_Title as Content ,TC.Episode_No, t.Title_Name, TC.Duration as [Duration_In_Min],cml.[From],cml.[To],cml.Duration as Duration,cml.From_Frame,cml.To_Frame INTO #TEMP from Title_Content TC        
                   
INNER JOIN Title_Content_Mapping TCM on TCM.Title_Content_Code = TC.Title_Content_Code                     
inner join Content_Music_Link cml on TC.Title_Content_Code = cml.Title_Content_Code AND cml.Music_Title_Code = @MusicTitleCode                    
inner join Title t on t.Title_Code = TC.Title_Code where TC.Title_Content_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@TitleContentCode,0), ',')) AND Title_Name LIKE '%'+ @GenericSearch +'%'                     
                 
if(@PageNo = 0)          
Set @PageNo = 1          
              
SET @RecordCount = (SELECT COUNT(*) FROM #TEMP)          
           
If(@IsPaging = 'Y')          
Begin           
Delete From #Temp Where Id < (((@PageNo - 1) * @PageSize) + 1) Or Id > @PageNo * @PageSize           
End           
          
SELECT Content,Episode_No,Title_Name, ISNULL( Duration_In_Min,0) Duration_In_Min,[FROM],[TO],Duration,From_Frame,To_Frame FROM #TEMP          
          
	--DROP TABLE #TEMP                          
	IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL DROP TABLE #TEMP
END        
        
/*        
exec USP_Music_Title_Contents 3679 ,'S',0,'Y',3,1        
*/