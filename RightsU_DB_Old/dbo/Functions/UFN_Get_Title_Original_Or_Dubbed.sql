

-- =============================================
-- Author		: <Rushabh Gohil>
-- Create date  : <22 Dec 2014>
-- Description  : <Returns the 'Type of Film' of the Title (Original/Dubbed)>
-- =============================================

CREATE FUNCTION [dbo].[UFN_Get_Title_Original_Or_Dubbed]
(@TitleCode int)
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @Value VARCHAR(8)

	SET @value=(
		SELECT Columns_Value FROM Extended_Columns_Value WHERE Columns_Value_Code =(
			SELECT Columns_Value_Code FROM Map_Extended_Columns WHERE Table_Name='TITLE' and Record_Code = @TitleCode
			AND Columns_Code in (
				SELECT Columns_Code FROM Extended_Columns WHERE Columns_Name = 'Type of Film'
			)
		)
	)
	
	RETURN ISNULL(@Value,'NA')
END