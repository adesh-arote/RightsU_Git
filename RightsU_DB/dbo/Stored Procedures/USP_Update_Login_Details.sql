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
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Update_Login_Details]', 'Step 1', 0, 'Started Procedure', 0, ''  
		SET NOCOUNT ON;
			UPDATE [Login_Details] SET Logout_Time=@Logout_Time,[Description]=@Description  
			WHERE Login_Details_Code=@Login_Details_Code
		 
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Update_Login_Details]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END
