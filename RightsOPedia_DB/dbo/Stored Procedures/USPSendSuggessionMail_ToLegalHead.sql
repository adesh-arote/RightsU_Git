CREATE PROCEDURE [dbo].[USPSendSuggessionMail_ToLegalHead]
(
	@User_Code INT
)
AS
BEGIN
--DECLARE @User_Code INT = 167
	DECLARE @DatabaseEmail_Profile varchar(MAX),@MailSubjectCr AS NVARCHAR(MAX),@EmailUser_Body NVARCHAR(Max),@Emailbody NVARCHAR(MAX)= '',@EmailHead NVARCHAR(MAX) = ''
			,@EMailFooter NVARCHAR(max),@Users_Email_Id VARCHAR(1000),@Copy_To VARCHAR(1000),@User_Name NVARCHAR(MAX),@Department NVARCHAR(MAX),@Verticle NVARCHAR(MAX),@Report_Feedback NVARCHAR(MAX),
			@LegalHeadMailID NVARCHAR(max)

	SELECT @DatabaseEmail_Profile = parameter_value FROM SystemParameterNew WHERE Parameter_Name = 'DatabaseEmail_Profile_User_Master'
	SELECT @Users_Email_Id = Email_Id FROM Users Where Users_Code = @User_Code
	--SET @Copy_To = 'dheeraj@uto.in;prathesh@uto.in'
	SELECT @User_Name = CAST(First_Name + ' ' + Last_Name AS VARCHAR(MAX))  FROM Users Where Users_Code  = @User_Code 
	SELECT @LegalHeadMailID = Email_Id from Users where Users_Code = (Select Parameter_Value from SystemParameterNew where Parameter_Name = 'SPNLegalHeadUser_IT')

	IF OBJECT_ID('tempdb..#Department') IS NOT NULL DROP TABLE #Department
	IF OBJECT_ID('tempdb..#Verticle') IS NOT NULL DROP TABLE #Verticle

	Select U.Users_Code, U.Login_Name,AG.Attrib_Group_Name,AG.Attrib_Type into #Department 
	FROM UsersDetail UD
	INNER JOIN Users U ON UD.Users_Code = U.Users_Code
	INNER JOIN Attrib_Group AG ON UD.Attrib_Group_Code = AG.Attrib_Group_Code AND UD.Attrib_Type = 'DP'
	WHERE U.Users_Code  = @User_Code 
	
	Select U.Users_Code, U.Login_Name,AG.Attrib_Group_Name,AG.Attrib_Type into #Verticle 
	FROM UsersDetail UD
	INNER JOIN Users U ON UD.Users_Code = U.Users_Code
	INNER JOIN Attrib_Group AG ON UD.Attrib_Group_Code = AG.Attrib_Group_Code AND UD.Attrib_Type = 'BV'
	WHERE U.Users_Code  = @User_Code 

	SELECT @Department = COALESCE(@Department + ', ', '') + CAST(Attrib_Group_Name AS NVARCHAR(MAX))
    FROM #Department  WHERE Users_Code = @User_Code

	SELECT @Verticle = COALESCE(@Verticle + ', ', '') + CAST(Attrib_Group_Name AS NVARCHAR(MAX))
    FROM #Verticle  WHERE Users_Code = @User_Code

	SELECT TOP 1 @Report_Feedback = UserComments FROM ReportFeedback WHERE UsersCode = @User_Code AND UserComments <> '' ORDER BY  ReportFeedbackID desc--(SELECT top 1 UserComments FROM ReportFeedback WHERE UsersCode = @User_Code order by ReportFeedbackID desc)
	
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
	<li><b>Name: </b>'+@User_Name+'</li>
	<li><b>Department: </b>'+ @Department +'</li>
	<li><b>Vertical: </b>'+@Verticle+'</li>
	<li><b>Email Address: </b>'+@Users_Email_Id+' </li>'
	IF(@Report_Feedback <> '')
	BEGIN
		SET @EmailBody = @EmailBody + '<li><b>Feedback Provided: </b>'+@Report_Feedback+'</li>'
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
					--@recipients = @LegalHeadMailID,
					----@copy_recipients = @Copy_To,
					--@blind_copy_recipients = 'vishal.onkar@uto.in',
					--@subject = @MailSubjectCr,
					--@body = @EmailUser_Body, 
					--@body_format = 'HTML';

	IF OBJECT_ID('tempdb..#Department') IS NOT NULL DROP TABLE #Department
	IF OBJECT_ID('tempdb..#Verticle') IS NOT NULL DROP TABLE #Verticle
END
