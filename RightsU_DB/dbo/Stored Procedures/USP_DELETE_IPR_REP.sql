

CREATE PROCEDURE [dbo].[USP_DELETE_IPR_REP]
(
	@IPR_Rep_Code INT
)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create DATE: 31-October-2014
-- Description:	DELETE IPR Call From EF 
-- =============================================
BEGIN
	DELETE FROM IPR_REP WHERE IPR_Rep_Code=@IPR_Rep_Code
END