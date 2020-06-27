

CREATE FUNCTION [dbo].[UFN_Get_Platform_Names]
(
	@Platform_Group_Code Int
)
-- =============================================
-- Author:		Anchal Sikarwar
-- Create date: 28 Sept 2015
-- Description:	Get Platform Name with comma saperated
-- =============================================

RETURNS NVARCHAR(MAX)
AS
BEGIN	
	DECLARE @pltNames NVARCHAR(MAX)
	DECLARE @pltCodes VARCHAR(MAX)
	SET @pltNames = ''
	SELECT 	@pltCodes = Stuff ((SELECT ', '+ CONVERT(varchar(10),Platform_Code)
		  FROM Platform_Group_Details PGD
		WHERE Platform_Group_Code IN(@Platform_Group_Code)
	FOR XML PATH('')), 1, 1, '')

	SELECT 	@pltNames = Stuff ((SELECT ', '+
	Platform_Hiearachy from [dbo].[UFN_Get_Platform_With_Parent](@pltCodes)
	FOR XML PATH('')), 1, 1, '')

	RETURN @pltNames
END