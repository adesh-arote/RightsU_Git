
CREATE PROCEDURE [dbo].[USPGetQuarterDefinition] 
AS 
  BEGIN 
			 SELECT quarterenddate as QuarterEndDate,
					(SELECT Getdate()) 
					AS CurrentDate 
             FROM   quarterdefinition 
             WHERE  CONVERT(DATE, Getdate()) BETWEEN 
                     quarterdefinition.quarterstartdate AND 
                     quarterdefinition.quarterenddate
  END

