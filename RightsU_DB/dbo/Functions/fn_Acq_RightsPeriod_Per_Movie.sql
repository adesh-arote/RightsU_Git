CREATE FUNCTION [dbo].[fn_Acq_RightsPeriod_Per_Movie]        
(        
 @dealMovieCode as int        
)         
returns varchar(max)         
AS        
BEGIN         
        -- Declare return variable here         
        Declare  @retStr as varchar(max)        
        set @retStr = ''        
                
  Declare @RighstPeriod as varchar(max)        
  declare @cnt int set @cnt=0        
  set @RighstPeriod = ''        
          
  select  @cnt = count(*) from Acq_Deal_Movie dm         
  inner join Acq_Deal_rights dmr on dm.Acq_Deal_Code =dmr.Acq_Deal_Code
  where dm.Acq_Deal_Movie_Code = @dealMovieCode       
          
  if(@cnt>0)        
  begin        
   select @RighstPeriod +=      
     case when isnull(convert(varchar(20),dmr.right_start_date,103),'')=''         
      and isnull(convert(varchar(20),dmr.right_end_date,103),'')='' then 'Unlimited' else        
     convert(varchar(20),dmr.right_start_date,103) +'-'+ convert(varchar(20),dmr.right_end_date,103) end         
     +', '        
     from         
   Acq_Deal_Movie dm         
   left join Acq_Deal_rights dmr on dm.Acq_Deal_Code=dmr.Acq_Deal_Code        
   where dm.Acq_Deal_Movie_Code = @dealMovieCode        
   group by dm.Acq_Deal_Movie_Code,convert(varchar(20),dmr.right_start_date,103),convert(varchar(20),dmr.right_end_date,103)        
  end        
  else        
   set @RighstPeriod=+', '        
            
     set @retStr = SUBSTRING(@RighstPeriod,0,LEN(@RighstPeriod))        
                 
RETURN @retStr        
             
END        
        
--select * from Deal where deal_no='D-2011-0000125'        
--select dbo.[fn_Acq_RightsPeriod](1043)