CREATE PROCEDURE [dbo].[USP_Update_Login_Details]
	@Login_Details_Code INT,
	@Logout_Time DATETIME,
	@Description VARCHAR(500)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 5 Dec 2014
-- Description:	Call From LogOut Button. And Update LogOut Time  
-- =============================================
BEGIN	
	SET NOCOUNT ON;
		UPDATE [Login_Details] SET Logout_Time=@Logout_Time,[Description]=@Description  
		WHERE Login_Details_Code=@Login_Details_Code
END
