CREATE FUNCTION [dbo].[UFN_Get_Class_Description]
(
	@IPR_Rep_Code INT
)
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 22 DEC 2014
-- Description:	Get Comma Separated Class Description Using IPR Rep Code And Call From IPR List Procedure
-- =============================================

RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Class_Description NVARCHAR(MAX)=''

	SELECT @Class_Description = STUFF ((
	SELECT	 DISTINCT ', ' + CAST(IPC.[Description] AS NVARCHAR(MAX))
	FROM IPR_REP_CLASS  IRC
	INNER JOIN IPR_CLASS IC ON IRC.IPR_Class_Code=IC.IPR_Class_Code
	INNER JOIN IPR_CLASS IPC ON IPC.IPR_Class_Code=IC.Parent_Class_Code
	WHERE IPR_Rep_Code = @IPR_Rep_Code
	FOR XML PATH('')), 1, 1, '')
	
	-- Return the result of the function
	RETURN @Class_Description 

END
