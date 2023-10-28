
CREATE FUNCTION [dbo].[UFNSplit] 
(
	@List NVARCHAR(MAX), 
	@Delimiter as NVARCHAR(100)
)
RETURNS @tbl TABLE (
	id int identity(1,1),
	number NVARCHAR(max) NOT NULL
)
AS
BEGIN
	DECLARE @pos        int,
			@nextpos    int,
			@valuelen   int

	SELECT @pos = 0, @nextpos = 1
    
	WHILE @nextpos > 0
	BEGIN
		SELECT @nextpos = charindex(@Delimiter, @List, @pos + 1)
		SELECT @valuelen = CASE WHEN @nextpos > 0
								THEN @nextpos
								ELSE len(@List) + 1
							END - @pos - 1
		INSERT @tbl (number)
			VALUES ( substring(@List, @pos + 1, @valuelen) )
		SELECT @pos = @nextpos
	END
	RETURN
END    
    
    
-- Select * from dbo.[UFNSplit]('1,2,3', ',')


