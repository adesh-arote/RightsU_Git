CREATE FUNCTION [dbo].[UFN_Arrange_Codes]
(
    @CommaCds VARCHAR(2000)
)
RETURNS VARCHAR(4000)
AS
-- =============================================
-- Author:        Abhaysingh Rajpurohit
-- CREATE DATE: 10-October-2014
-- Description:    Calculate Term by passing Start Date and End Date
-- =============================================
BEGIN
    --DECLARE @startDate DATETIME = CAST('2020-03-24' AS DATETIME), @endDate DATETIME = CAST('9999-12-29' AS DATETIME)

	DECLARE @tblCodes AS TABLE
	(
		IntCode INT
	)

	INSERT INTO @tblCodes(IntCode)
	SELECT DISTINCT [value] FROM STRING_SPLIT(@commaCds, ',') WHERE [value] <> ''

	DECLARE @CodesStr VARCHAR(4000) = ''
	SELECT @CodesStr = STUFF
	(
		(
			SELECT ',' + CAST(IntCode AS VARCHAR) FROM @tblCodes ORDER BY CAST(IntCode AS INT)
			FOR XML PATH('')
		), 1, 1, ''
	)

	SELECT @CodesStr = ',' + @CodesStr + ','
	
    RETURN  ISNULL(@CodesStr, '')
END
