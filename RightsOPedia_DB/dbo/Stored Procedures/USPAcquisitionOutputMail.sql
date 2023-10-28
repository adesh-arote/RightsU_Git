CREATE PROCEDURE [dbo].[USPAcquisitionOutputMail]
(
	@BVCode INT,
	@User NVARCHAR(MAX)
)
AS
BEGIN
	DECLARE @DatabaseEmail_Profile varchar(MAX),@MailSubjectCr AS NVARCHAR(MAX),@EmailUser_Body NVARCHAR(Max),@Emailbody NVARCHAR(MAX)= ''
			,@EMailFooter NVARCHAR(max),@Users_Email_Id VARCHAR(1000) = '',@Copy_To VARCHAR(1000) = ''
			,@User_Name NVARCHAR(MAX) = '',@Report_Feedback NVARCHAR(MAX),@BusinessVertical nvarchar(50)


	SELECT @DatabaseEmail_Profile = parameter_value FROM SystemParameterNew WHERE Parameter_Name = 'DatabaseEmail_Profile_User_Master'
	SET @Users_Email_Id = @User
	SELECT @User_Name = CAST(Login_Name + ' ' + Last_Name AS VARCHAR(MAX))  FROM Users Where Users_Code = 0
	SET @MailSubjectCr='RightsOpedia Acquisition ' + @BusinessVertical;

	SET @BusinessVertical =  (SELECT Attrib_Group_Name FROM Attrib_Group where Attrib_Group_Code = @BVCode)
	

	BEGIN
		SET @Emailbody = 
			'<html><head>
			</head><body>
					<p>Dear User,</p>
					<p>I have queried a report from RightsOPedia for '+@BusinessVertical+ ' Acquisition. Please find the attached report extracted for the same.</p>
					<p>Do reach to me in case of any further queries.</p>
					<p>with you shortly.</p>
					'
	END
	

	
	SET @EMailFooter =
					'</br>
					Regards,<p>
					RightsOPedia
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
