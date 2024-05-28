CREATE FUNCTION [dbo].[UFN_Get_Acq_Rights_Period]      
(      
 @Acq_Deal_Code AS int      
)       
returns VARCHAR(max)       
AS  
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 08-October-2014
-- Description:	Get Unique Rights Perioda
-- =============================================    
BEGIN       
        -- DECLARE return variable here       
  DECLARE  @retStr AS VARCHAR(max)      
  SET @retStr = ''      
              
  DECLARE @RighstPeriod AS VARCHAR(max)      
  DECLARE @cnt int SET @cnt=0      
  SET @RighstPeriod = ''      
        
  select  @cnt=COUNT(*) 
  FROM Acq_Deal_Rights ADR  
  WHERE ADR.Acq_Deal_Code=@Acq_Deal_Code      
      
        
  IF(@cnt>0)      
  BEGIN
	  DECLARE @multiPeriodCnt INT
	  
	  SELECT @multiPeriodCnt=COUNT(Acq_Deal_Code) FROM (
			SELECT distinct Acq_Deal_Code,Right_Type,CONVERT(VARCHAR(20),ADR.Actual_Right_Start_Date,103) right_start_date
			 ,convert(VARCHAR(20),ADR.Actual_Right_End_Date,103) right_END_date       
			FROM Acq_Deal_Rights ADR with(nolock)
			INNER JOIN Acq_Deal_Rights_Title ADRT with(nolock) ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code   
			WHERE ADR.Acq_Deal_Code=@Acq_Deal_Code	
		) A
	  
	  IF (@multiPeriodCnt=1)
	  BEGIN  
		  SELECT DISTINCT @RighstPeriod =      
		   CASE WHEN UPPER(ADR.Right_Type) = 'U' THEN 'Perpetuity'
			 when UPPER(ADR.Right_Type) = 'R' THEN dbo.UFN_Get_Acq_Run_Based_Info(ADR.Acq_Deal_Code)    
			 ELSE REPLACE(CONVERT(varchar,CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103),106),' ', '-') +' To '+ REPLACE(CONVERT(varchar,CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103),106),' ', '-') END       
			 +', '      
		  FROM Acq_Deal_Rights ADR with(nolock)
		  INNER JOIN Acq_Deal_Rights_Title ADRT with(nolock) ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code   
		  WHERE ADR.Acq_Deal_Code=@Acq_Deal_Code	
	  END
	  ELSE SELECT @RighstPeriod=' Multiple Right Periods'
       
  END      
  ELSE      
   SET @RighstPeriod=+', '      
          
     SET @retStr = SUBSTRING(@RighstPeriod,0,LEN(@RighstPeriod))      
               
RETURN @retStr      
           
END      
      
--select * FROM Acq_Deal WHERE agreement_no='A-2014-00176'      
--select dbo.[UFN_Get_Acq_Rights_Period](6235) 