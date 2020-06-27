
CREATE FUNCTION [dbo].[fn_GetEpisodeNos]  
(  
 @BV_HouseId_Data_Code AS INT  
)   
returns varchar(max)   
AS  
BEGIN   
        -- Declare return variable here   
        DECLARE  @retStr as varchar(max)  
        set @retStr = ''  
          
  DECLARE @EpisodeNumbers AS VARCHAR(MAX)  
  SET @EpisodeNumbers = ''  
    
  SELECT @EpisodeNumbers += a.Episode_No +', ' 
  FROM
  (
	  SELECT DISTINCT CAST(ISNULL(BV.Episode_No,1) AS VARCHAR(5000)) Episode_No  
	  FROM BV_HouseId_Data BV WHERE BV.BV_HouseId_Data_Code = @BV_HouseId_Data_Code OR Parent_BV_HouseId_Data_Code = @BV_HouseId_Data_Code  
  ) as a
    
    
   SET @retStr = SUBSTRING(@EpisodeNumbers,0,LEN(@EpisodeNumbers))  
           
RETURN @retStr  
       
END  
  
--select dbo.[fn_GetEpisodeNos](13)  
--select * from Deal  
--Select * from BV_HouseId_Data