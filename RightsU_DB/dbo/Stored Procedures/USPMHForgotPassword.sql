CREATE PROCEDURE [dbo].[USPMHForgotPassword]  
@LoginName NVARCHAR(50),  
@EmailID NVARCHAR(100),  
@Password NVARCHAR(MAX)  
AS   
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHForgotPassword]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE  
		--@EmailID NVARCHAR(100) = 'rahul@ut.in'  
  
		 DECLARE @MailSubjectCr AS NVARCHAR(MAX),  
		   @RequestID NVARCHAR(50),  
		   @DatabaseEmail_Profile varchar(MAX),  
		   @EmailUser_Body NVARCHAR(Max),  
		   @DefaultSiteUrl VARCHAR(MAX),  
		   @Emailbody NVARCHAR(MAX),  
		   @EmailHead NVARCHAR(max),  
		   @EMailFooter NVARCHAR(max)  
  
		   SELECT @DatabaseEmail_Profile = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile_MusicHub'  
		   SELECT @DefaultSiteUrl =  parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'MusicHub_URL_Link'  
		   SET @MailSubjectCr = 'Music Hub - Password reset'  
     
		   set @EmailHead= '<html><head><style>  
		   table.tblFormat{border:1px solid black;border-collapse:collapse;}  
		   th.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold}  
		   td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>  
		   <p>Dear User,</p>  
		   <p>Please use this code to reset the password for your account.</p>'  
  
		   SET @EMailFooter ='</br>  
		   <a href="'+@DefaultSiteUrl+'">Click here to login.</a></br></br>  
		   If you have not requested to change your password, simply ignore this email. If you suspect that your account may be compromised please contact Viacom18 administrator.   
		   <p>Thanks,</br></p>  
		   <p>The Music Hub Team</p>  
		   <p style="font-style: italic">Please Note: This is a system generated mail. Please do not reply to it.</p>  
		   </body></html>'  
     
		   SET @Emailbody='<p>Login Name: '+@LoginName+'</p>  
		   <p>Passcode: '+@Password+'</p>'  
  
		   Set @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter  
		   print @EmailUser_Body  
  
		   EXEC msdb.dbo.sp_send_dbmail   
		   @profile_name = @DatabaseEmail_Profile,  
		   @recipients =  @EmailID,  
		   @subject = @MailSubjectCr,  
		   @body = @EmailUser_Body,   
		   @body_format = 'HTML';  
    
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHForgotPassword]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''  
END
