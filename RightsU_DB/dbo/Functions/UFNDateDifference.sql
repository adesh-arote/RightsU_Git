CREATE FUNCTION [dbo].[UFNDateDifference]
(
--DECLARE
	@RequestedDate DATETIME -- ='2018-06-17 18:59:45.450'
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @INT INT, @DateDiff VARCHAR(50) = ''

	SET @INT = DATEDIFF(SECOND,@RequestedDate,GETDATE())

	if((@INT/86400) != 0)
		SET @DateDiff = convert(VARCHAR(10), (@INT/86400)) + ' Days '
	if(((@INT%86400)/3600)  != 0 AND @DateDiff = '')
		SET @DateDiff = @DateDiff + convert(varchar(10), ((@INT%86400)/3600)) + ' Hours '

	if((((@INT%86400)%3600)/60)  != 0 AND @DateDiff = '')
		SET @DateDiff = @DateDiff + convert(varchar(10), (((@INT%86400)%3600)/60)) + ' Minutes '
	

	--select  @DateDiff
	
	RETURN @DateDiff
END
--select [dbo].[UFNDateDifference]('2018-06-15 18:59:45.450')