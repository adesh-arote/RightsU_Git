

CREATE FUNCTION [dbo].[UFN_Get_Syn_Run_Based_Info]  
(  
	@Syn_Deal_Code AS INT  
)   
RETURNS VARCHAR(MAX)   
AS  
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 13-October-2014
-- Description:	GET Run based Info
-- =============================================
BEGIN   

  DECLARE  @retStr AS VARCHAR(MAX)  
  SET @retStr = ''  
  
	--Days -- 1
	--Weeks -- 2
	--Months -- 3
	--Years" -- 4
  
  SELECT @retStr +=  
  CASE WHEN MT.Milestone_Type_Code = 1 THEN 'From 1st '
  ELSE 'FROM' END + Milestone_Type_Name + ' TO ' + CAST(ADR.Milestone_No_Of_Unit AS VARCHAR(50))  + ' No. of ' + 
  CASE WHEN ADR.Milestone_Unit_Type = 1 THEN 'Days'
  WHEN ADR.Milestone_Unit_Type = 2 THEN 'Weeks'
  WHEN ADR.Milestone_Unit_Type = 3 THEN 'Months'
  WHEN ADR.Milestone_Unit_Type = 4 THEN 'Years' 
  ELSE ''
  END + ', '
  FROM Milestone_Type MT WITH(NOLOCK)
  INNER JOIN Syn_Deal_Rights ADR WITH(NOLOCK) on ADR.Milestone_Type_Code = MT.Milestone_Type_Code
  WHERE ADR.Syn_Deal_Rights_Code = @Syn_Deal_Code
  --GROUP BY --DM.deal_code, ADR.run_based_no_of_run, ADR.run_based_unit

  SELECT @retStr = SUBSTRING(@retStr,0,LEN(@retStr))  
  RETURN @retStr  

END

/*
SELECT * FROM Milestone_Type MT
*/