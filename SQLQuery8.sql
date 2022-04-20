ALTER PROCEDURE  USPMHNotificationMail
	@MHRequestCode INT,
	@MHRequestTypeCode INT,
	@UsersCode INT
AS
BEGIN
-----------------------------------
--Author: Rahul Kembhavi
--Description: Notification mails would trigger on Consumption, MusicTrack And Movie/Album Request
--Date Created: 10-July-2018
---------------------------------------------
	
	--DECLARE
	--@MHRequestCode INT = 10492,
	--@MHRequestTypeCode INT = 1,
	--@UsersCode INT = 1287


	IF(OBJECT_ID('TEMPDB..#tempUsage') IS NOT NULL)
		DROP TABLE #tempUsage
	IF(OBJECT_ID('TEMPDB..#tempMusicMovie') IS NOT NULL)
		DROP TABLE #tempMusicMovie

	DECLARE @MailSubjectCr AS NVARCHAR(MAX),
			@RequestID NVARCHAR(50),
			@DatabaseEmail_Profile varchar(MAX),
			@EmailUser_Body NVARCHAR(Max),
			@DefaultSiteUrl VARCHAR(MAX),
			@Emailbody NVARCHAR(MAX),
			@EmailHead NVARCHAR(max),
			@EMailFooter NVARCHAR(max),
			@NoOfSongs INT,
			@ChannelName NVARCHAR(50),
			@ShowName NVARCHAR(MAX),
			@EpisodeFrom INT,
			@EpisodeTo INT,
			@TeleCastFrom NVARCHAR(50),
			@TeleCastTo NVARCHAR(50),
			@TeleCastDate NVARCHAR(MAX),
			@MusicLabel NVARCHAR(MAX),
			@RequestedDate NVARCHAR(50),
			@RequestedBy NVARCHAR(50),
			@VendorName NVARCHAR(MAX),
			@VendorCode INT,
			@TitleName NVARCHAR(MAX),
			@EmailConfigCode INT,
			@Subject NVARCHAR(MAX),
			@ToMail NVARCHAR(MAX),
			@UserCode INT
			
			DECLARE @Email_Config_Code INT, @Channel_Codes NVARCHAR(MAX)
	
			DECLARE @Business_Unit_Code INT,
			@To_Users_Code NVARCHAR(MAX),
			@To_User_Mail_Id  NVARCHAR(MAX),
			@CC_Users_Code  NVARCHAR(MAX),
			@CC_User_Mail_Id  NVARCHAR(MAX),
			@BCC_Users_Code  NVARCHAR(MAX),
			@BCC_User_Mail_Id  NVARCHAR(MAX)
	
			DECLARE @Tbl2 TABLE (
				Id INT,
				BuCode INT,
				To_Users_Code NVARCHAR(MAX),
				To_User_Mail_Id  NVARCHAR(MAX),
				CC_Users_Code  NVARCHAR(MAX),
				CC_User_Mail_Id  NVARCHAR(MAX),
				BCC_Users_Code  NVARCHAR(MAX),
				BCC_User_Mail_Id  NVARCHAR(MAX),
				Channel_Codes NVARCHAR(MAX)
			)

			DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 



			SELECT @DatabaseEmail_Profile = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile_MusicHub'

			SELECT @DefaultSiteUrl = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'MusicHub_URL_Link'
			SET @RequestID = (Select RequestID from MHRequest Where MHRequestCode = @MHRequestCode)

			SET @VendorCode = (Select top 1 Vendor_Code from MHUsers where Users_Code = @UsersCode)

			If(@MHRequestTypeCode = 1)
				BEGIN
					SET @MailSubjectCr=''+@RequestID+' – Usage Request - Awaiting Request Authorization';
					SET @EmailConfigCode = (Select Email_Config_Code from Email_Config where Email_Type = 'MHConsumptionRequest' )
					SET @Subject = ''+@RequestID+' - New Usage Request is Sent for approval';

					SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='MHCR'

					INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
					EXEC USP_Get_EmailConfig_Users 'MHCR', 'N'
				END
			ELSE IF(@MHRequestTypeCode = 2)
				BEGIN
					SET @MailSubjectCr=''+@RequestID+'  – New Music Tracks Request - Awaiting Request Authorization'
					SET @EmailConfigCode = (Select Email_Config_Code from Email_Config where Email_Type = 'MHMusicRequest' )
					SET @Subject = ''+@RequestID+' - New Music Track Request is Sent for approval';

					SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='MHMUR'

					INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
					EXEC USP_Get_EmailConfig_Users 'MHMUR', 'N'
				END
			Else
				BEGIN
					SET @MailSubjectCr=''+@RequestID+'  – New Movie Request - Awaiting Request Authorization';
					SET @EmailConfigCode = (Select Email_Config_Code from Email_Config where Email_Type = 'MHMovieRequest' )
					SET @Subject = ''+@RequestID+' - New Movie Request is Sent for approval';

					SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='MHMOR'

					INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
					EXEC USP_Get_EmailConfig_Users 'MHMOR', 'N'
				END

			IF(@MHRequestTypeCode = 1)
				BEGIN
					SELECT COUNT(MHRequestCode) AS NoOfSongs,Channel_Name,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,MusicLabel,RequestedDate,Login_Name,Vendor_Name
					INTO #tempUsage
					from (
					Select MR.MHRequestCode,C.Channel_Name,T.Title_Name,MR.EpisodeFrom,MR.EpisodeTo,MR.TelecastFrom,MR.TelecastTo,
					ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS VARCHAR(Max))[text()]
								 FROM MHRequestDetails MRD
								 --INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
								 LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
								 LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
								 Where MRD.MHRequestCode = MR.MHRequestCode
								 FOR XML PATH(''), TYPE)
								.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) MusicLabel,CAST(MR.RequestedDate AS DATE) AS RequestedDate,U.Login_Name,V.Vendor_Name
					from MHRequest MR
					LEFT JOIN Channel C ON c.Channel_Code = MR.ChannelCode
					LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
					INNER JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
					INNER JOIN Users U ON U.Users_Code = MR.UsersCode
					INNER JOIN MHUsers MU ON MU.Users_Code = MR.UsersCode
					INNER JOIN VENDOR V ON V.Vendor_Code = MU.Vendor_Code
					where MR.MHRequestCode = @MHRequestCode
					) AS t
					GROUP BY t.MHRequestCode,Channel_Name,Title_Name,EpisodeFrom,EpisodeTo,TelecastFrom,TelecastTo,MusicLabel,RequestedDate,Login_Name,Vendor_Name

					
					SET @NoOfSongs = (Select NoOfSongs from #tempUsage)
					SET @ChannelName = (Select Channel_Name from #tempUsage)
					SET @ShowName = (SELECT Title_Name from #tempUsage)
					SET	@EpisodeFrom = (SELECT EpisodeFrom from #tempUsage)
					SET	@EpisodeTo =(SELECT EpisodeTo from #tempUsage)
					SET	@TeleCastFrom = REPLACE(CONVERT(NVARCHAR,(SELECT TelecastFrom from #tempUsage), 106),' ', '-')--(SELECT TelecastFrom from #tempUsage)
					SET	@TeleCastTo = REPLACE(CONVERT(NVARCHAR,(SELECT TelecastTo from #tempUsage), 106),' ', '-')--(SELECT TelecastTo from #tempUsage)
					IF(@EpisodeFrom = @EpisodeTo)
						BEGIN
							SET @TeleCastDate = @TeleCastFrom
						END
					ELSE
						BEGIN
							SET @TeleCastDate = CAST(ISNULL(@TeleCastFrom,' ') as nvarchar(MAX))+' - '+CAST(ISNULL(@TeleCastTo,' ') as nvarchar(MAX))
						END


					SET	@MusicLabel = (SELECT MusicLabel from #tempUsage)
					--@RequestedDate = REPLACE(CONVERT(NVARCHAR,(SELECT RequestedDate from #tempUsage),' ', '-')--(SELECT RequestedDate from #tempUsage)
					Select @RequestedDate =  REPLACE(CONVERT(NVARCHAR,(SELECT RequestedDate from #tempUsage), 106),' ', '-')
					SET	@RequestedBy = (SELECT Login_Name from #tempUsage)
					SET @VendorName = (SELECT Vendor_Name from #tempUsage)
				END
			ELSE 
				BEGIN
					
					SELECT COUNT(MR.MHRequestCode) AS NoOfSongs,
					ISNULL(STUFF((SELECT DISTINCT ', ' + CAST(MRD.TitleName AS VARCHAR(Max))[text()]
								 FROM MHRequestDetails MRD
								 Where MRD.MHRequestCode = MR.MHRequestCode
								 FOR XML PATH(''), TYPE)
								.value('.','NVARCHAR(MAX)'),1,2,' '),'' ) TitleName
					,MR.RequestedDate,U.Login_Name,V.Vendor_Name INTO #tempMusicMovie
					FROM MHRequest MR
					INNER JOIN MHRequestDetails MRD ON MRD.MHRequestCode = MR.MHRequestCode
					INNER JOIN Users U ON U.Users_Code = MR.UsersCode
					INNER JOIN MHUsers MU ON MU.Users_Code = MR.UsersCode
					INNER JOIN Vendor V ON V.Vendor_Code = MU.Vendor_Code
					where MR.MHRequestCode = @MHRequestCode
					GROUP BY MR.MHRequestCode,MR.RequestedDate,U.Login_Name,V.Vendor_Name,MRD.TitleName 

					SET @NoOfSongs = (Select top 1 NoOfSongs from #tempMusicMovie)
					--SET	@RequestedDate = (SELECT top 1 RequestedDate from #tempMusicMovie)
					Select @RequestedDate =  REPLACE(CONVERT(NVARCHAR,(SELECT top 1 RequestedDate from #tempMusicMovie), 106),' ', '-')
					SET	@RequestedBy = (SELECT top 1 Login_Name from #tempMusicMovie)
					SET @VendorName = (SELECT top 1 Vendor_Name from #tempMusicMovie)
					SET @TitleName = (SELECT top 1 TitleName from #tempMusicMovie)
				END
			
		--DECLARE curOuter CURSOR FOR 
		--SELECT Users_Code,Email_Id from Users Where Users_Code IN (Select Users_Code from MHUsers where Vendor_Code = (Select top 1 Vendor_Code from MHUsers where Users_Code = @UsersCode))
		--OPEN curOuter 
		--FETCH NEXT FROM curOuter INTO @UserCode, @ToMail
		--WHILE(@@Fetch_Status = 0) 
		--BEGIN

		DECLARE cPointer CURSOR FOR 
		SELECT DISTINCT To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
		-- Where To_Users_Code IN (Select Users_Code from MHUsers where Vendor_Code = (Select top 1 Vendor_Code from MHUsers where Users_Code = @UsersCode))
		OPEN cPointer
		FETCH NEXT FROM cPointer INTO  @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		WHILE @@FETCH_STATUS = 0
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
					<th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Date</th>
					<th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Request Description</th>
					<th align="center" width="20%" class="tblHead" style="border:1px solid black;  text-align:center; color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Requested By</th>
				</tr>'
			
			IF(@MHRequestTypeCode = 1 )
				BEGIN
					SET @Emailbody = @Emailbody +
					'<tr>
							<td align="center" class="tblData" rowspan=6 style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ REPLACE(CONVERT(NVARCHAR,@RequestedDate, 106),' ', '-')+'</td>
							<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>Channel Name:</b> '+ CAST(ISNULL(@ChannelName,' ') as varchar(MAX))+' </td>
							<td align="center" class="tblData" rowspan=6 style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+CAST(ISNULL(@VendorName,' ') as varchar(MAX))+'/'+ CAST(ISNULL(@RequestedBy,' ') as varchar(MAX))+' </td>
						</tr>
						<tr>
							<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>Show Name:</b>'+ CAST(ISNULL(@ShowName,' ') as varchar(MAX))+' </td>
						</tr>
						<tr>
							<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>Episode No:</b>'+ CAST(ISNULL(@EpisodeFrom,' ') as varchar(MAX))+' </td>
						</tr>
						<tr>
							<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>Telecast Date:</b>'+ CAST(ISNULL(@TeleCastDate,' ') as varchar(MAX))+'</td>
						</tr>
						<tr>
							<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>Music Label:</b>'+ CAST(ISNULL(@MusicLabel,' ') as varchar(MAX))+' </td>
						</tr>
						<tr>
							<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>No Of Songs:</b>'+ CAST(ISNULL(@NoOfSongs,' ') as varchar(MAX))+' </td>
						</tr>
					</table>'
				END
			ElSE 
				BEGIN
					Declare @Label NVARCHAR(50)
					IF(@MHRequestTypeCode = 2)
						BEGIN
							SET @Label = 'No Of. Tracks: '
							SET @Emailbody = @Emailbody +
							'<tr>
									<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ REPLACE(CONVERT(NVARCHAR,@RequestedDate, 106),' ', '-')+'</td>
									<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>No Of. Tracks:</b>'+ CAST(ISNULL(@NoOfSongs,' ') as varchar(MAX))+' </td>
									<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+CAST(ISNULL(@VendorName,' ') as varchar(MAX))+'/'+ CAST(ISNULL(@RequestedBy,' ') as varchar(MAX))+' </td>
							</tr>
							</table>'
						END
					ELSE
						BEGIN
							SET @Label = 'Movie/Album Name: '
							SET @Emailbody = @Emailbody +
							'<tr>
									<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+ REPLACE(CONVERT(NVARCHAR,@RequestedDate, 106),' ', '-')+'</td>
									<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px"><b>Movie/Album Name:</b>'+ CAST(ISNULL(@TitleName,' ') as varchar(MAX))+' </td>
									<td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+CAST(ISNULL(@VendorName,' ') as varchar(MAX))+'/'+ CAST(ISNULL(@RequestedBy,' ') as varchar(MAX))+' </td>
							</tr>
							</table>'
						END
				END

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

			INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
			SELECT @Email_Config_Code,@Emailbody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  'Channel Unutilized Run'
				
			
			
	--	FETCH NEXT FROM curOuter INTO @UserCode, @ToMail
	--END
	--Close curOuter
	--Deallocate curOuter
		FETCH NEXT FROM cPointer INTO @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
		END
	CLOSE cPointer
	DEALLOCATE cPointer

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT

	IF OBJECT_ID('tempdb..#tempMusicMovie') IS NOT NULL DROP TABLE #tempMusicMovie
	IF OBJECT_ID('tempdb..#tempUsage') IS NOT NULL DROP TABLE #tempUsage
END