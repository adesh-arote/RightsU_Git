CREATE PROCEDURE USPMHNotificationMailForCueSheet 
@MHCueSheetCode INT,
@UsersCode INT
AS
BEGIN
-----------------------------------
--Author: Rahul Kembhavi
--Description: Notification mails would trigger on CueSheet Submit
--Date Created: 13-July-2018
---------------------------------------------
	--BEGIN
	--DECLARE
	--@MHCueSheetCode INT = 195,
	--@UsersCode INT = 1272 
	
	IF(OBJECT_ID('TEMPDB..#temp') IS NOT NULL)
		DROP TABLE #temp

	DECLARE @MailSubjectCr AS NVARCHAR(MAX),
			@RequestID NVARCHAR(50),
			@DatabaseEmail_Profile varchar(MAX),
			@EmailUser_Body NVARCHAR(Max),
			@DefaultSiteUrl VARCHAR(MAX),
			@Emailbody NVARCHAR(MAX),
			@EmailHead NVARCHAR(max),
			@EMailFooter NVARCHAR(max),
			@RequestDescription NVARCHAR(max),
			@RequestedBy NVARCHAR(50),
			@VendorName NVARCHAR(MAX),
			@VendorCode INT,
			@RequestedDate NVARCHAR(50),
			@EmailConfigCode INT,
			@Subject NVARCHAR(MAX),
			@ToMail NVARCHAR(MAX),
			@UserCode INT


			SELECT @DatabaseEmail_Profile = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile_MusicHub'

			Select @DefaultSiteUrl = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'MusicHub_URL_Link'

			SET @VendorCode = (Select top 1 Vendor_Code from MHUsers where Users_Code = @UsersCode)

			BEGIN
				SELECT RequestID,FileName,U.Login_Name AS CreatedBy,V.Vendor_Name,MCS.CreatedOn INTO #temp
				FROM MHCueSheet MCS
				INNER JOIN Users U ON U.Users_Code = MCS.CreatedBy
				INNER JOIN MHUsers MU ON MU.Users_Code = MCS.CreatedBy
				INNER JOIN Vendor V ON V.Vendor_Code = MU.Vendor_Code
				Where MHCueSheetCode = @MHCueSheetCode
			END

			SET @RequestID  = (Select RequestID from #temp)
			SET @RequestedDate  = (Select REPLACE(CONVERT(NVARCHAR,CreatedOn, 106),' ', '-') from #temp)
			SET @RequestDescription = (Select FileName from #temp)
			SET @VendorName = (Select Vendor_Name from #temp)
			SET @RequestedBy  = (Select CreatedBy from #temp)

			SET @MailSubjectCr=''+@RequestID+'  – Music Assignment Request - Awaiting Request Authorization';
			SET @EmailConfigCode = (Select Email_Config_Code from Email_Config where Email_Type = 'MHCueSheetSubmit' )
			SET @Subject = ''+@RequestID+' Sent for approval';
			
		DECLARE curOuter CURSOR FOR 
		SELECT Users_Code,Email_Id from Users Where Users_Code IN (Select Users_Code from MHUsers where Vendor_Code = (Select top 1 Vendor_Code from MHUsers where Users_Code = @UsersCode))
		OPEN curOuter 
		FETCH NEXT FROM curOuter INTO @UserCode, @ToMail
		WHILE(@@Fetch_Status = 0) 
		BEGIN
			set @EmailHead= 
			'<html>
			<head>
				
			</head>
			<body>
					<p>Dear User,</p>
					<p>The Request No: '+ @RequestID +' is waiting for approval.</p>
					<p>Please click <a href="'+@DefaultSiteUrl+'">here</a> to access RightsU - Music Hub and take appropriate actions.</p>'

			SET @Emailbody= 
			'<table class="tblFormat" style="width:90%; border:1px solid black;border-collapse:collapse;">
				<tr>
					<th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Date</th>
					<th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Description</th>
					<th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Requested By</th>
					<th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Uploaded On</th>
				</tr>'
			
			SET @Emailbody = @Emailbody +
				'<tr>
						<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST(ISNULL(@RequestedDate,' ') as varchar(MAX))+'</td>
						<td td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ CAST(ISNULL(@RequestDescription,' ') as varchar(MAX))+' </td>
						<td td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+CAST(ISNULL(@VendorName,' ') as varchar(MAX))+'/'+ CAST(ISNULL(@RequestedBy,' ') as varchar(MAX))+' </td>
						<td td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ REPLACE(CONVERT(NVARCHAR,@RequestedDate, 106),' ', '-')+' </td>
				</tr>
				</table>'
				

			SET @EMailFooter =
					'</br>
					(This is a system generated mail. Please do not reply back to the same)</br>
					</p>
					</body></html>'

			Set @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
			print @EmailUser_Body
			
			--EXEC msdb.dbo.sp_send_dbmail 
			--@profile_name = @DatabaseEmail_Profile,
			--@recipients =  @ToMail,
			--@subject = @MailSubjectCr,
			--@body = @EmailUser_Body, 
			--@body_format = 'HTML';

			INSERT INTO Email_Notification_Log VALUES(@EmailConfigCode,GETDATE(),'N',@Emailbody,@UserCode,@Subject,@ToMail)
			INSERT INTO MHNotificationLog VALUES(@EmailConfigCode,GETDATE(),'N',@Emailbody,@UserCode,@VendorCode,@Subject,@ToMail)
			Select @ToMail
			FETCH NEXT FROM curOuter INTO @UserCode, @ToMail
	END
	Close curOuter
	Deallocate curOuter
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
END