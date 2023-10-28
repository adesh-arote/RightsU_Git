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
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Login_Details]', 'Step 1', 0, 'Started Procedure', 0, ''
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
		  FROM [Login_Details] (NOLOCK) WHERE Login_Details_Code=SCOPE_IDENTITY()
		  SELECT @Login_Details_Code  as Login_Details_Code
	  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Login_Details]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
