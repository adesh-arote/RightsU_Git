CREATE FUNCTION [dbo].[fn_Split_withdelemiter] (@list NVARCHAR(MAX),@delimiter as NVARCHAR(100))    
   RETURNS @tbl TABLE (id int identity(1,1),number NVARCHAR(max) NOT NULL) AS    
BEGIN    
   DECLARE @pos        int,    
           @nextpos    int,    
           @valuelen   int    
    
   SELECT @pos = 0, @nextpos = 1    
    
   WHILE @nextpos > 0    
   BEGIN    
      SELECT @nextpos = charindex(@delimiter , @list, @pos + 1)    
      SELECT @valuelen = CASE WHEN @nextpos > 0    
                              THEN @nextpos    
                              ELSE len(@list) + 1    
                         END - @pos - 1    
      INSERT @tbl (number)    
         VALUES ( substring(@list, @pos + 1, @valuelen) )    
      SELECT @pos = @nextpos    
   END    
  RETURN    
END    
    
    
-- Select * from dbo.fn_Split('1,2,3')
