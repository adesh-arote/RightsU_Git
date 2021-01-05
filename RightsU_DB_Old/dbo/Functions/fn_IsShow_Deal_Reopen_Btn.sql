
CREATE FUNCTION [dbo].[fn_IsShow_Deal_Reopen_Btn]    
(    
 @Acq_Deal_Code INT    
)    
RETURNS CHAR(2)    
AS    
-- =============================================    
-- Author:  Dadasaheb G. Karande    
-- Create date: 09-JUNE-2011    
-- Description: To show and hide Deal Re-Open button     
--    depends on Right period is over or not    
-- =============================================    
BEGIN    
 -- Declare the return variable here    
 DECLARE @Result CHAR(1)    
    
 -- Add the T-SQL statements to compute the return value here    
 DECLARE @Temp INT    
 SELECT @Temp = AD.Acq_Deal_Code  
 FROM Acq_Deal AD     with(nolock) 
 INNER JOIN Acq_Deal_Rights ADR with(nolock) ON ADR.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
 WHERE AD.Acq_Deal_Code = @Acq_Deal_Code    
 GROUP BY AD.Acq_Deal_Code    
 HAVING     
 DATEDIFF(d,MAX(ADR.Right_End_Date),GETDATE())>0
 
     
 IF(@Temp > 0)    
 BEGIN    
  SET @Result = 'N'    
 END    
 ELSE     
 BEGIN    
  SET @Result = 'Y'    
 END    
    
 -- Return the result of the function    
 RETURN @Result    
    
END