CREATE PROCEDURE [dbo].[USP_SendMailLegalUser]
	(
		@User_Code INT,
		@Is_Comments CHAR(1)
	)
AS
BEGIN
	--DECLARE @User_Code INT = 136,@Is_Comments CHAR(1)='Y'
	
	DECLARE @DatabaseEmail_Profile varchar(MAX),@MailSubjectCr AS NVARCHAR(MAX),@EmailUser_Body NVARCHAR(Max),@Emailbody NVARCHAR(MAX)= '',@EmailHead NVARCHAR(MAX) = ''
			,@EMailFooter NVARCHAR(max),@Users_Email_Id VARCHAR(1000),@Copy_To VARCHAR(1000),@User_Name NVARCHAR(MAX),@Department NVARCHAR(MAX),@Verticle NVARCHAR(MAX),@Report_Feedback NVARCHAR(MAX)

	SELECT @DatabaseEmail_Profile = parameter_value FROM RightsU_Revamp..System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile_User_Master'
	SET @Users_Email_Id = 'ritesh@ww.in'
	--SET @Copy_To = 'dheeraj@uto.in;prathesh@uto.in'
	SELECT @User_Name = CAST(Login_Name + ' ' + Last_Name AS VARCHAR(MAX))  FROM Users Where Users_Code  = @User_Code 

	IF OBJECT_ID('tempdb..#Department') IS NOT NULL DROP TABLE #Department
	IF OBJECT_ID('tempdb..#Verticle') IS NOT NULL DROP TABLE #Verticle

	Select U.Users_Code, U.Login_Name,AG.Attrib_Group_Name,AG.Attrib_Type into #Department 
	FROM UsersDetail UD
	INNER JOIN Users U ON UD.Users_Code = U.Users_Code
	INNER JOIN Attrib_Group AG ON UD.Attrib_Group_Code = AG.Attrib_Group_Code
	WHERE U.Users_Code  = @User_Code 
	
	Select U.Users_Code, U.Login_Name,AG.Attrib_Group_Name,AG.Attrib_Type into #Verticle 
	FROM UsersDetail UD
	INNER JOIN Users U ON UD.Users_Code = U.Users_Code
	INNER JOIN Attrib_Group AG ON UD.Attrib_Group_Code = AG.Attrib_Group_Code AND UD.Attrib_Type = 'BV'
	WHERE U.Users_Code  = @User_Code 

	SELECT @Department = COALESCE(@Department + ',', '') + CAST(Attrib_Group_Name AS NVARCHAR(MAX))
    FROM #Department  WHERE Users_Code = @User_Code

	SELECT @Verticle = COALESCE(@Verticle + ',', '') + CAST(Attrib_Group_Name AS NVARCHAR(MAX))
    FROM #Verticle  WHERE Users_Code = @User_Code

	SELECT @Report_Feedback = UserComments FROM ReportFeedback WHERE UsersCode = @User_Code
	------------------------------------------------------------------------------------------------------------------------------------
	SET @MailSubjectCr='RightsU Notification of Feedback Report';
	------------------------------------------------------------------------------------------------------------------------------------

	SET @EmailHead = 
			'<html><head>
			</head><body>
					<p>Dear Ritesh,</p>
					<p>A Business User wishes to connect with the legal team to provide feedback on Intuitive Rights. Request you 
					to kindly liaise. The details are –</p>
					'

	SET @EmailBody = '<ul>
	<li>Name: '+@User_Name+'</li>
	<li>Department: '+ @Department +'</li>
	<li>Vertical: '+@Verticle+'</li>
	<li>Email Address :'+@Users_Email_Id+' </li>'
	IF(@Is_Comments = 'Y')
	BEGIN
		SET @EmailBody = @EmailBody + '<li>Feedback Provided: </li>'
	END
	SET @EmailBody = @EmailBody + '</ul>'

	SET @EMailFooter =
					'</br>
					Regards,</br><p>
					SPNI Legal Team
					</p>
					</body></html>'

	SET @EmailUser_Body= @EmailHead + @Emailbody + @EMailFooter
	PRINT @EmailUser_Body
	
					--EXEC msdb.dbo.sp_send_dbmail 
					--@profile_name = @DatabaseEmail_Profile,
					--@recipients = @Users_Email_Id,
					----@copy_recipients = @Copy_To,
					----@blind_copy_recipients = @BCCMail,
					--@subject = @MailSubjectCr,
					--@body = @EmailUser_Body, 
					--@body_format = 'HTML';

	IF OBJECT_ID('tempdb..#Department') IS NOT NULL DROP TABLE #Department
	IF OBJECT_ID('tempdb..#Verticle') IS NOT NULL DROP TABLE #Verticle

END
