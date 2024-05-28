CREATE PROCEDURE [dbo].[USPSendFeedBackMail_ToUser]
(
	@User_Code INT
)
AS
BEGIN
	DECLARE @DatabaseEmail_Profile varchar(MAX),@MailSubjectCr AS NVARCHAR(MAX),@EmailUser_Body NVARCHAR(Max),@Emailbody NVARCHAR(MAX)= ''
			,@EMailFooter NVARCHAR(max),@Users_Email_Id VARCHAR(1000) = '',@Copy_To VARCHAR(1000) = ''
			,@User_Name NVARCHAR(MAX) = '',@Report_Feedback NVARCHAR(MAX)


	SELECT @DatabaseEmail_Profile = parameter_value FROM SystemParameterNew WHERE Parameter_Name = 'DatabaseEmail_Profile_User_Master'
	SELECT @Users_Email_Id = Email_Id FROM Users Where Users_Code = @User_Code
	SELECT @User_Name = CAST(Login_Name + ' ' + Last_Name AS VARCHAR(MAX))  FROM Users Where Users_Code = @User_Code
	SET @MailSubjectCr='RightsU Notification of Feedback Report';
	
	SET @Report_Feedback = (SELECT top 1 UserComments FROM ReportFeedback WHERE UsersCode = @User_Code order by ReportFeedbackID desc)

	IF(@Report_Feedback <> '')
	BEGIN
		SET @Emailbody = 
			'<html><head>
			</head><body>
					<p>Dear ' + @User_Name + ',</p>
					<p>Thank you for taking out a moment to provide feedback. We truly appreciate it.</p>
					<p>Your suggestion has been forwarded to Ritesh Khosla. He or one of his team members will get in touch</p>
					<p>with you shortly.</p>
					'
	END
	ELSE
	BEGIN
		SET @Emailbody = 
			'<html><head>
			</head><body>
					<p>Dear ' + @User_Name + ',</p>
					<p>Thank you for showing willingness to provide Feedback. Someone from Legal Team will be in touch with you shortly.</p>
					<p>If for some reason you are not contacted in 7 business days, do escalate this to Ritesh Khosla in Legal team.</p>
					'
	END

	
	SET @EMailFooter =
					'</br>
					Regards,<p>
					SPNI Legal Team
					</p>
					</body></html>'
	
	

	
	SET @EmailUser_Body= @Emailbody + @EMailFooter
	
	PRINT @EmailUser_Body
	
					--EXEC msdb.dbo.sp_send_dbmail 
					--@profile_name = @DatabaseEmail_Profile,
					--@recipients = @Users_Email_Id,
					----@copy_recipients = @Copy_To,
					--@blind_copy_recipients = 'vishal.onkar@uto.in',
					--@subject = @MailSubjectCr,
					--@body = @EmailUser_Body, 
					--@body_format = 'HTML';
END
