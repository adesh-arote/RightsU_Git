CREATE PROCEDURE [dbo].[USPBMSNotificationMail] 
AS
BEGIN
	IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Users_Data
	END
	IF OBJECT_ID('tempdb..#Update_STATUS') IS NOT NULL
	BEGIN
		DROP TABLE #Update_STATUS
	END
	IF OBJECT_ID('TEMPDB..#TempErrBMSAsset') IS NOT NULL
	BEGIN
		DROP TABLE #TempErrBMSAsset
	END
	IF OBJECT_ID('TEMPDB..#TempErrBMSAsset') IS NOT NULL
	BEGIN
		DROP TABLE #TempErrBMSAsset
	END
	IF OBJECT_ID('TEMPDB..#TempErrBMSAsset') IS NOT NULL
	BEGIN
		DROP TABLE #TempErrBMSAsset
	END
	IF OBJECT_ID('TEMPDB..#TempErrBMSAsset') IS NOT NULL
	BEGIN
		DROP TABLE #TempErrBMSAsset
	END


	/*Create User data*/
	BEGIN
		CREATE TABLE #BMSErrorLogCodes(BMSErrorLogCode INT)
		CREATE TABLE #Users_Data
		(
			users_code INT, 
			login_name NVARCHAR(250), 
			first_name NVARCHAR(250), 
			middle_Name NVARCHAR(250),
			last_name NVARCHAR(250),
			email_id NVARCHAR(250),
			security_group_name NVARCHAR(250),
			UserFullName NVARCHAR(250),
			Email_body NVARCHAR(max)
		)
		CREATE TABLE #Update_STATUS
		(
			Email_Notification_Schedule_code INT,
			File_Code INT,
			Channel_Code INT,
			User_code INT
		)
		CREATE Table #TempErrBMSAsset
		(
			BMSErrorLogCode INT,
			Asset_Name NVARCHAR(100),
			Episode VARCHAR(50),
			RUID VARCHAR(50),
			Error_Description NVARCHAR(MAX)
		)
		CREATE Table #TempErrLicensor
		(
			BMSErrorLogCode INT,
			Licensor_Name NVARCHAR(100),
			RUID VARCHAR(50),
			Error_Description NVARCHAR(MAX)
		)
		CREATE Table #TempErrBMSDeal
		(
			BMSErrorLogCode INT,
			Agreement_No NVARCHAR(100),
			RUID VARCHAR(50),
			Error_Description NVARCHAR(MAX)
		)
		CREATE Table #TempErrBMSDealContent
		(
			BMSErrorLogCode INT,
			Agreement_No NVARCHAR(100),
			Asset_Name NVARCHAR(100),
			Episode VARCHAR(50),
			[Period] VARCHAR(50),
			RUID VARCHAR(50),
			Error_Description NVARCHAR(MAX)
		)
		CREATE Table #TempErrBMSDealContentRights
		(
			BMSErrorLogCode INT,
			Agreement_No NVARCHAR(100),
			Asset_Name NVARCHAR(100),
			Episode VARCHAR(50),
			[Period] VARCHAR(50),
			Channel VARCHAR(50),
			RUID VARCHAR(50),
			Error_Description NVARCHAR(MAX)
		)

		DECLARE @cur_first_name NVARCHAR(500), @cur_middle_name NVARCHAR(500), @cur_last_name NVARCHAR(500), @cur_email_id NVARCHAR(500), @cur_userFullName NVARCHAR(500),
			@AssetEmailbody NVARCHAR(MAX), @LicensorEmailbody NVARCHAR(MAX), @DealEmailbody NVARCHAR(MAX), @ContentEmailbody NVARCHAR(MAX), @RightEmailbody NVARCHAR(MAX)

		IF exists(select * from BMSErrorLog where RecordType = 'Asset')
		BEGIN
			INSERT INTO #TempErrBMSAsset(BMSErrorLogCode,Asset_Name, Episode, RUID, Error_Description)
			select DISTINCT BEL.BMSErrorLogCode,Title, Episode_Number, 'RUBMSBVA' + CAST(BMS_Asset_Code AS VARCHAR), Error_Description from BMSErrorLog BEL
			INNER JOIN  BMS_Asset BA ON BEL.RecordCode = BA.BMS_Asset_Code
			where BEL.RecordType = 'Asset' AND BEL.IsMailSent = 'N'

			INSERT INTO #BMSErrorLogCodes(BMSErrorLogCode)
			SELECT DISTINCT BEL.BMSErrorLogCode FROM BMSErrorLog BEL
			INNER JOIN  BMS_Asset BA ON BEL.RecordCode = BA.BMS_Asset_Code WHERE BEL.RecordType = 'Asset' AND BEL.IsMailSent = 'N'
		END
		IF exists(select * from BMSErrorLog where RecordType = 'Licensor')
		BEGIN
			INSERT INTO #TempErrLicensor(Licensor_Name, RUID, Error_Description)
			select V.Vendor_Name, 'RUBMSV' + CAST(V.Vendor_Code AS VARCHAR), V.Error_Description from BMSErrorLog BEL
			INNER JOIN Vendor V ON BEL.RecordCode = V.Vendor_Code where BEL.RecordType = 'Licensor' AND BEL.IsMailSent = 'N'

			INSERT INTO #BMSErrorLogCodes(BMSErrorLogCode)
			SELECT DISTINCT BEL.BMSErrorLogCode FROM BMSErrorLog BEL
			INNER JOIN Vendor V ON BEL.RecordCode = V.Vendor_Code where BEL.RecordType = 'Licensor' AND BEL.IsMailSent = 'N'
		END
		IF exists(select * from BMSErrorLog where RecordType = 'Deal')
		BEGIN
			INSERT INTO #TempErrBMSDeal(Agreement_No, RUID, Error_Description)
			select BD.Lic_Ref_No, 'RUBMSBVD' + CAST(BD.BMS_Deal_Code AS VARCHAR), Error_Description from BMSErrorLog BEL
			INNER JOIN  BMS_Deal BD ON BEL.RecordCode = BD.BMS_Deal_Code where BEL.RecordType = 'Deal' AND BEL.IsMailSent = 'N'

			INSERT INTO #BMSErrorLogCodes(BMSErrorLogCode)
			SELECT DISTINCT BEL.BMSErrorLogCode FROM BMSErrorLog BEL
			INNER JOIN  BMS_Deal BD ON BEL.RecordCode = BD.BMS_Deal_Code where BEL.RecordType = 'Deal' AND BEL.IsMailSent = 'N'
		END
		IF EXISTS(SELECT * FROM BMSErrorLog WHERE RecordType = 'Content')
		BEGIN
			INSERT INTO #TempErrBMSDealContent(Agreement_No, Asset_Name, Episode, [Period], RUID, Error_Description)
			SELECT BD.Lic_Ref_No, BA.Title, BA.Episode_Number, CONVERT(VARCHAR,BDC.Start_Date,106) +' To ' + CONVERT(VARCHAR,BDC.End_Date,106), 'RUBMSBVDC' + CAST(DB.BMS_Deal_Content_Code AS VARCHAR), Error_Description from BMSErrorLog BEL
			INNER JOIN BMS_Deal_Content BDC ON BEL.RecordCode = BDC.BMS_Deal_Content_Code
			INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = BDC.BMS_Asset_Code
			WHERE BEL.RecordType = 'Content' AND BEL.IsMailSent = 'N'

			INSERT INTO #BMSErrorLogCodes(BMSErrorLogCode)
			SELECT DISTINCT BEL.BMSErrorLogCode FROM BMSErrorLog BEL
			INNER JOIN BMS_Deal_Content BDC ON BEL.RecordCode = BDC.BMS_Deal_Content_Code where BEL.RecordType = 'Content' AND BEL.IsMailSent = 'N'
		END
		IF EXISTS(SELECT * FROM BMSErrorLog WHERE RecordType = 'Right')
		BEGIN
			INSERT INTO #TempErrBMSDealContentRights(Agreement_No, Asset_Name, Episode, [Period], Channel, RUID, Error_Description)
			SELECT BD.Lic_Ref_No, BA.Title, BA.Episode_Number, CONVERT(VARCHAR,BDCR.Start_Date,106) +' To ' + CONVERT(VARCHAR,BDCR.End_Date,106), CH.Channel_Name, 
			'RUBMSBVDCR' + CAST(BDCR.BMS_Deal_Content_Rights_Code AS VARCHAR), BDCR.Error_Description 
			from BMSErrorLog BEL
			INNER JOIN BMS_Deal_Content_Rights BDCR ON BEL.RecordCode = BDCR.BMS_Deal_Content_Rights_Code
			INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = BDCR.BMS_Deal_Content_Code
			INNER JOIN BMS_Deal BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code
			INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = BDCR.BMS_Asset_Code
			INNER JOIN Channel CH ON CH.Channel_Code = BDCR.RU_Channel_Code
			WHERE BEL.RecordType = 'Right' AND BEL.IsMailSent = 'N'

			INSERT INTO #BMSErrorLogCodes(BMSErrorLogCode)
			SELECT DISTINCT BEL.BMSErrorLogCode FROM BMSErrorLog BEL
			INNER JOIN BMS_Deal_Content_Rights BDCR ON BEL.RecordCode = BDCR.BMS_Deal_Content_Rights_Code WHERE BEL.RecordType = 'Right' AND BEL.IsMailSent = 'N'
		END

		IF EXISTS(select * from #TempErrBMSAsset) --Asset Error
		BEGIN 
			SET @AssetEmailbody= '<br><br><table border="1" cellspacing="0" cellpadding="3">'				
										
			SET @AssetEmailbody=@AssetEmailbody + '<tr>
			<td style="color: #ffffff; background-color: #086B10"><b>Title Name<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Episode<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>RU ID<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Error Description<b></td>
			</tr>'
										
			SELECT @AssetEmailbody=@AssetEmailbody +'<tr>
			<td>'+ CAST  (ISNULL(e.Asset_Name, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Episode,' ')  AS NVARCHAR(250)) +'</td>
			<td>'+ CAST  (ISNULL(e.RUID, ' ') AS NVARCHAR(250)) +'</td>
			<td>'+ CAST  (ISNULL(e.Error_Description, ' ') AS NVARCHAR(250)) +'</td>
			</tr>' FROM #TempErrBMSAsset e

			set @AssetEmailbody += '</table>'
		END

		IF EXISTS(select * from #TempErrLicensor) --Licensor Error
		BEGIN
			SET @LicensorEmailbody= '<br><br><table border="1" cellspacing="0" cellpadding="3">'				
										
			SET @LicensorEmailbody = @LicensorEmailbody + '<tr>
			<td style="color: #ffffff; background-color: #086B10"><b>Licensor<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>RU ID<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Error Description<b></td>
			</tr>'
										
			SELECT @LicensorEmailbody = @LicensorEmailbody +'<tr>
			<td>'+ CAST  (ISNULL(e.Licensor_Name, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.RUID, ' ') AS NVARCHAR(250)) +'</td>
			<td>'+ CAST  (ISNULL(e.Error_Description, ' ') AS NVARCHAR(250)) +'</td>
			</tr>' FROM #TempErrLicensor e

			set @LicensorEmailbody += '</table>'
		END

		IF EXISTS(select * from #TempErrBMSDeal) --Deal Error
		BEGIN
			SET @DealEmailbody= '<br><br><table border="1" cellspacing="0" cellpadding="3">'				
										
			SET @DealEmailbody = @DealEmailbody + '<tr>
			<td style="color: #ffffff; background-color: #086B10"><b>Agreement No.<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>RU ID<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Error Description<b></td>
			</tr>'
										
			SELECT @DealEmailbody = @DealEmailbody +'<tr>
			<td>'+ CAST  (ISNULL(e.Agreement_No, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.RUID, ' ') AS NVARCHAR(250)) +'</td>
			<td>'+ CAST  (ISNULL(e.Error_Description, ' ') AS NVARCHAR(250)) +'</td>
			</tr>' FROM #TempErrBMSDeal e

			set @DealEmailbody += '</table>'
		END

		IF EXISTS(select * from #TempErrBMSDealContent) --Deal Content Error
		BEGIN
			SET @ContentEmailbody= '<br><br><table border="1" cellspacing="0" cellpadding="3">'				
										
			SET @ContentEmailbody = @ContentEmailbody + '<tr>
			<td style="color: #ffffff; background-color: #086B10"><b>Agreement No.<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Asset Name<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Episode<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Period<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>RU ID<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Error Description<b></td>
			</tr>'
					
			SELECT @ContentEmailbody = @ContentEmailbody +'<tr>
			<td>'+ CAST  (ISNULL(e.Agreement_No, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Asset_Name, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Episode, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Period, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.RUID, ' ') AS NVARCHAR(250)) +'</td>
			<td>'+ CAST  (ISNULL(e.Error_Description, ' ') AS NVARCHAR(250)) +'</td>
			</tr>' FROM #TempErrBMSDealContent e

			set @ContentEmailbody += '</table>'
			set @DealEmailbody +=@ContentEmailbody
		END

		IF EXISTS(select * from #TempErrBMSDealContentRights) --Deal Content Right Error
		BEGIN
			SET @RightEmailbody= '<br><br><table border="1" cellspacing="0" cellpadding="3">'				
										
			SET @RightEmailbody = @RightEmailbody + '<tr>
			<td style="color: #ffffff; background-color: #086B10"><b>Agreement No.<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Asset Name<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Episode<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Period<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Channel<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>RU ID<b></td>
			<td style="color: #ffffff; background-color: #086B10"><b>Error Description<b></td>
			</tr>'
										
			SELECT @RightEmailbody = @RightEmailbody +'<tr>
			<td>'+ CAST  (ISNULL(e.Agreement_No, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Asset_Name, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Episode, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Period, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.Channel, ' ') AS NVARCHAR(1000)) +'</td>
			<td>'+ CAST  (ISNULL(e.RUID, ' ') AS NVARCHAR(250)) +'</td>
			<td>'+ CAST  (ISNULL(e.Error_Description, ' ') AS NVARCHAR(250)) +'</td>
			</tr>' FROM #TempErrBMSDealContentRights e

			set @RightEmailbody += '</table>'
			set @DealEmailbody +=@ContentEmailbody
		END		
	END

	DECLARE @Business_Unit_Code int, @Users_Email_Id NVARCHAR(MAX),@Emailbody NVARCHAR(Max), @Type CHAR(4), @Users_Code INT, @Email_Config_Code INT
	--Change
	DECLARE curOuter CURSOR FOR SELECT DISTINCT User_Mail_Id,Users_Code, 'RBA' from [dbo].[UFN_Get_Bu_Wise_User]('RBA')
	UNION SELECT DISTINCT User_Mail_Id,Users_Code, 'RBD' from [dbo].[UFN_Get_Bu_Wise_User]('RBD')
	UNION SELECT DISTINCT User_Mail_Id,Users_Code, 'RBL' from [dbo].[UFN_Get_Bu_Wise_User]('RBL')

	OPEN curOuter 
	FETCH NEXT FROM curOuter INTO  @Users_Email_Id, @Users_Code, @Type
	WHILE @@Fetch_Status = 0
	BEGIN
		DECLARE @RedirectUrl varchar(MAX) = ''
		DECLARE @DefaultSiteUrl VARCHAR(500) = ''
		SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
				
		DECLARE @DatabaseEmail_Profile varchar(200)
		SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

		set @RedirectUrl = 'The schedule file has ‘Rights Exception’ for following channels.
							<br>For more details on licensed rights, login into the RightsU System : <a href='+ @DefaultSiteUrl +' target=''_blank''><b>RightsU</b></a>'
		
		DECLARE @MailSubjectCr AS NVARCHAR(2500)
		
		DECLARE @EMailFooter NVARCHAR(2000)
		SET @EMailFooter ='&nbsp;</br>&nbsp;</br>
		<FONT SIZE="2" COLOR="gray">This email is generated by RIGHTSU</font>'

		DECLARE @Emailbody_Username NVARCHAR(250);	SET @Emailbody_Username = ''
		/*User name with seecurity Group*/
		select @cur_first_name = First_Name from Users Where Users_Code = @Users_Code
		SET @Emailbody_Username = 'Dear&nbsp;' + @cur_first_name + ' ,<br><br>'

		DECLARE @Emailbody1 AS NVARCHAR(MAX); SET @Emailbody1 = ''
		SELECT TOP 1 @Email_Config_Code = Email_Config_Code FROM Email_Config Where Email_Type = @Type

		IF(@AssetEmailbody!='' AND @Type = 'RBA')
		BEGIN
			
			SET @Emailbody1 = @Emailbody_Username + @RedirectUrl + @AssetEmailbody + @EMailFooter

			SET @MailSubjectCr = 'RU BMS Data Push Integration Exception : Program'
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = @DatabaseEmail_Profile,
			@recipients =  @Users_Email_Id,
			@subject = @MailSubjectCr,
			@body = @Emailbody1,
			@body_format = 'HTML';
			
			INSERT INTO Email_Notification_Log(Email_Config_Code, Created_Time, Is_Read, Email_Body, User_Code, [Subject], Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @Emailbody, @Users_Code, @MailSubjectCr, @Users_Email_Id, @Type
		END

		IF(@LicensorEmailbody!='' AND @Type = 'RBL')
		BEGIN
			SET @Emailbody1 = @Emailbody_Username + @RedirectUrl + @LicensorEmailbody + @EMailFooter

			SET @MailSubjectCr = 'RU BMS Data Push Integration Exception : Licensor'
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = @DatabaseEmail_Profile,
			@recipients =  @Users_Email_Id,
			@subject = @MailSubjectCr,
			@body = @Emailbody1,
			@body_format = 'HTML';
			
			INSERT INTO Email_Notification_Log(Email_Config_Code, Created_Time, Is_Read, Email_Body, User_Code, [Subject], Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @LicensorEmailbody, @Users_Code, @MailSubjectCr, @Users_Email_Id
		END

		IF(@DealEmailbody!='' AND @Type = 'RBD')
		BEGIN
			SET @Emailbody1 = @Emailbody_Username + @RedirectUrl + @DealEmailbody + @EMailFooter

			SET @MailSubjectCr = 'RU BMS Data Push Integration Exception : Deal'
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = @DatabaseEmail_Profile,
			@recipients =  @Users_Email_Id,
			@subject = @MailSubjectCr,
			@body = @Emailbody1,
			@body_format = 'HTML';

			INSERT INTO Email_Notification_Log(Email_Config_Code, Created_Time, Is_Read, Email_Body, User_Code, [Subject], Email_Id)
			SELECT @Email_Config_Code, GETDATE(), 'N', @DealEmailbody, @Users_Code, @MailSubjectCr, @Users_Email_Id
		END

	Close curOuter
	Deallocate curOuter	
	FETCH NEXT FROM curOuter INTO @Users_Email_Id,@Users_Code
	END

	IF OBJECT_ID('tempdb..#Users_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Users_Data
	END
	IF OBJECT_ID('tempdb..#Update_STATUS') IS NOT NULL
	BEGIN
		DROP TABLE #Update_STATUS
	END
END
