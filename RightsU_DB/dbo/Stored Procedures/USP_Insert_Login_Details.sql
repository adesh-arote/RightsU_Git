
CREATE PROCEDURE [dbo].[USP_Insert_Login_Details] 	
(	
      @Login_Time DateTime,
      @Logout_Time DateTime,
      @Description Varchar(500),
      @Users_Code INT,
      @Security_Group_Code INT
)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 5 DEC 2014
-- Description:	Insert Into  Login Details
-- =============================================

BEGIN	
	SET NOCOUNT ON;
	INSERT INTO [Login_Details]
	(	
	  [Login_Time],
      [Logout_Time],
      [Description],
      [Users_Code],
      [Security_Group_Code]
	)
	  SELECT @Login_Time,
	  @Logout_Time,
	  @Description,
	  @Users_Code,
	  @Security_Group_Code
	  
	  Declare @Login_Details_Code INT
	  SELECT @Login_Details_Code = Login_Details_Code
	  FROM [Login_Details] WHERE Login_Details_Code=SCOPE_IDENTITY()
	  SELECT @Login_Details_Code  as Login_Details_Code
END
