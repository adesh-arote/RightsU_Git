
CREATE FUNCTION [dbo].[UFN_Get_Column_Value_Data] 
(
	@Map_Extended_Columns_Code INT
)
RETURNS VARCHAR(1000)
AS
BEGIN

	DECLARE  @Result VARCHAR(3000) 
	SET @Result = ''


	SELECT  @Result = @Result + cast(Columns_Value_Code AS VARCHAR) + ',' FROM (
		SELECT DISTINCT Columns_Value_Code FROM Map_Extended_Columns_Details WHERE Map_Extended_Columns_Code = @Map_Extended_Columns_Code	
	) as a
	RETURN  CASE WHEN ISNULL(@Result,'0') = '' THEN '0' ELSE @Result END
END
