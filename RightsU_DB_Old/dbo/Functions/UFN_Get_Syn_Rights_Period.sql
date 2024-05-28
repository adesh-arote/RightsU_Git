CREATE FUNCTION [dbo].[UFN_Get_Syn_Rights_Period]      
(      
 @Syn_Deal_Code AS int      
)       
returns VARCHAR(max)       
AS  
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 08-October-2014
-- Description:	Get Unique Rights Period
-- =============================================    
BEGIN       
        -- DECLARE return variable here       
  DECLARE  @retStr AS NVARCHAR(max)      
  SET @retStr = ''      
              
  DECLARE @RighstPeriod AS VARCHAR(max)      
  DECLARE @cnt int SET @cnt=0      
  SET @RighstPeriod = ''      
        
  select  @cnt=COUNT(*) 
  FROM Syn_Deal_Rights ADR WITH(NOLOCK)
  WHERE ADR.Syn_Deal_Code=@Syn_Deal_Code      
      
        
  IF(@cnt>0)      
  BEGIN
	  DECLARE @multiPeriodCnt INT
	  
	  SELECT @multiPeriodCnt=COUNT(Syn_Deal_Code) FROM (
			SELECT distinct Syn_Deal_Code,Right_Type,CONVERT(VARCHAR(20),ADR.right_start_date,103) right_start_date
			 ,convert(VARCHAR(20),ADR.right_END_date,103) right_END_date       
			FROM Syn_Deal_Rights ADR WITH(NOLOCK)
			INNER JOIN Syn_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Syn_Deal_Rights_Code=ADRT.Syn_Deal_Rights_Code   
			WHERE ADR.Syn_Deal_Code=@Syn_Deal_Code AND ISNULL(ADR.Is_Pushback, 'N') != 'Y'
		) A
	  
	  IF (@multiPeriodCnt=1)
	  BEGIN  
		  SELECT DISTINCT @RighstPeriod =      
		   CASE WHEN UPPER(ADR.Right_Type) = 'U' THEN 'Perpetuity'
			 when UPPER(ADR.Right_Type) = 'R' THEN dbo.UFN_Get_Syn_Run_Based_Info(ADR.Syn_Deal_Code)    
			 --ELSE CONVERT(VARCHAR(20),ADR.right_start_date,103) +'-'+ convert(VARCHAR(20),ADR.right_END_date,103) END       
			 ELSE REPLACE(CONVERT(varchar,CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103),106),' ', '-') +' To '+ REPLACE(CONVERT(varchar,CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103),106),' ', '-') END       
			 +', '      
		  FROM Syn_Deal_Rights ADR WITH(NOLOCK)
		  INNER JOIN Syn_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Syn_Deal_Rights_Code=ADRT.Syn_Deal_Rights_Code   
		  WHERE ADR.Syn_Deal_Code=@Syn_Deal_Code AND ISNULL(ADR.Is_Pushback, 'N') != 'Y'
	  END
	  ELSE SELECT @RighstPeriod=' Multiple Right Periods'
       
  END      
  ELSE      
   SET @RighstPeriod=+', '      
          
     SET @retStr = SUBSTRING(@RighstPeriod,0,LEN(@RighstPeriod))      
               
RETURN @retStr      
           
END      
      
--select * FROM Syn_Deal WHERE agreement_no='A-2014-00176'      
--select dbo.[UFN_Get_Syn_Rights_Period](227) 