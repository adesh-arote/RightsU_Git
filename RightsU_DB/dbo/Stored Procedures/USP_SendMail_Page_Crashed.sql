CREATE PROCEDURE [dbo].[USP_SendMail_Page_Crashed]
(
	@User_Name NVARCHAR(100),	
	@Site_Address NVARCHAR(200),       
	@Entity_Name NVARCHAR(100),
	@Controller_Name VARCHAR(50),
	@Action_Name VARCHAR(50),
	@View_Name VARCHAR(50), --Here ViewNAme = id
	@Error_Desc NVARCHAR(MAX),
	@Error_Type NVARCHAR(100),
	@IP_Address VARCHAR(50),
	@FromMailId NVARCHAR(500),
	@ToMailId NVARCHAR(500)
)
AS
 --=============================================
 --Author:		SAGAR MAHAJAN
 --Create DATE: 02 Feb 2016
 --Description:	Send Exception Email When Page Crash
 --=============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_Page_Crashed]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;
		DECLARE @body  NVARCHAR(MAX)  SET @body  = 'Page Crashed Dev Environment body'       
		SELECT TOP 1 @body = Template_Desc FROM Email_template  (NOLOCK) WHERE Template_For = 'Exception_Page_Crash'

		 ------------Send E-Mail----------
		 DECLARE @DefaultSiteUrl VARCHAR(500) = ''
		 DECLARE @DatabaseEmail_Profile VARCHAR(200)	
		 SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
		 SELECT TOP 1 @ToMailId = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'ToMailID_Page_Crash' 
		 DECLARE @MailSubjectCr VARCHAR(250) = 'Page Crashed Dev Environment'
		-- DECLARE @cur_email_id  VARCHAR(100)= 'sagar@uto.in'
	 
		 SET @body  = REPLACE(@body ,'{UserName}',@User_Name)
		 --SET @body  = REPLACE(@body ,'{First_Name}',@First_Name)
		 --SET @body  = REPLACE(@body ,'{Last_Name}',@Last_Name)
		 SET @body  = REPLACE(@body ,'{Directoryname}',@Site_Address)
		 SET @body  = REPLACE(@body ,'{entityName}',@Entity_Name)
		 SET @body  = REPLACE(@body ,'{Controller_Name}',@Controller_Name)
		 SET @body  = REPLACE(@body ,'{Error_Type}',@Error_Type)
	 
		 SET @body  = REPLACE(@body ,'{Action_Name}',@Action_Name)
		 SET @body  = REPLACE(@body ,'{Search_ID}',@View_Name)
		 SET @body  = REPLACE(@body ,'{Error_Desc}',@Error_Desc)
		 SET @body  = REPLACE(@body ,'{ipAddress}',@IP_Address)
		 SET @body  = REPLACE(@body ,'{Getdate}',GETDATE())

		 PRINT @Body

		 INSERT INTO TestParam(AgreementNo) SELECT @Body

		/*
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name = @DatabaseEmail_Profile,
		@recipients =  @ToMailId,
		@subject = @MailSubjectCr,
		@body = @body, 
		@body_format = 'HTML';  
		*/
		------Send E-Mail END     
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SendMail_Page_Crashed]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''    
END