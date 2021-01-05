-- =============================================    
-- Author:  Pavitar Dua 
-- Create date: 12 June 2014
-- Description: Bring all parents of a platform recursively
-- =============================================   
CREATE FUNCTION [dbo].[fn_getParentPlatform_Recursive]
( 
 @childPlatCode VARCHAR(5000), 
 @conCatCH VARCHAR(5000), 
 @notINChildPlatCode VARCHAR(5000)
)
RETURNS VARCHAR(5000) 
AS
BEGIN
DECLARE @parent_platform_code VARCHAR(500) 
    SELECT  @parent_platform_code = 
    (
		SELECT STUFF((SELECT DISTINCT  '~' + CAST( isnull(parent_platform_code,platform_Code) AS VARCHAR(max)) 
		FROM Platform WHERE 
		platform_code  IN ( SELECT ISNULL(number,0) FROM dbo.fn_Split_withdelemiter(REPLACE(@childPlatCode,'~',','),',') )
		AND platform_code NOT IN ( SELECT ISNULL(number,0) FROM dbo.fn_Split_withdelemiter(REPLACE(@notINChildPlatCode,'~',','),',') )
		FOR XML PATH('')), 1, 1, '') AS parent_platform_code
	)
	 
	IF EXISTS(SELECT TOP 1 parent_platform_code FROM Platform WHERE 
	    platform_code IN ( SELECT ISNULL(number,0) FROM dbo.fn_Split_withdelemiter(REPLACE(@childPlatCode,'~',','),','))
	    AND platform_code NOT IN ( SELECT ISNULL(number,0) FROM dbo.fn_Split_withdelemiter(REPLACE(@notINChildPlatCode,'~',','),',') )
	            AND parent_platform_code<>bASe_platform_code
    )
	BEGIN
		DECLARE @returnVar VARCHAR(5000) 
		SET @returnVar = dbo.fn_getParentPlatform_Recursive(REPLACE(@parent_platform_code,'~',','),REPLACE(@parent_platform_code,'~',','),@notINChildPlatCode)	
		return @conCatCH + '~' + REPLACE(@returnVar,',','~')
	END
	
    RETURN  @conCatCH + '~' + @parent_platform_code 

END