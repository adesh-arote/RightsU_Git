CREATE PROCEDURE USPMHMailNotification
	@MHRequestCode INT,
	@MHRequestTypeCode INT = 0,
	@MHCueSheetCode INT = 0
AS
--=====================================================
-- Author:		<Akshay Rane>
-- Create date: <16 August 2018>
-- Description:	<Email Notification for music hub>
--=====================================================
BEGIN
	--DECLARE @MHRequestCode INT = 10466, @MHRequestTypeCode INT = 1, @MHCueSheetCode INT = 184

	IF OBJECT_ID('tempdb..#UsageRequest') IS NOT NULL
		DROP TABLE #UsageRequest

	IF OBJECT_ID('tempdb..#MusicTracksRequest') IS NOT NULL
		DROP TABLE #MusicTracksRequest
		
	IF OBJECT_ID('tempdb..#NewMovieRequest') IS NOT NULL
		DROP TABLE #NewMovieRequest

	DECLARE @Subject NVARCHAR(MAX), @MailSubjectCr NVARCHAR(MAX),@DatabaseEmail_Profile varchar(MAX), @EmailUser_Body NVARCHAR(MAX), @DefaultSiteUrl VARCHAR(MAX), @Email_Config_Code INT = 0

	DECLARE @ChannelName NVARCHAR(MAX),  @ShowName NVARCHAR(MAX), @EpisodeNo NVARCHAR(MAX), @TelecastDate NVARCHAR(MAX),@MusicLabel NVARCHAR(MAX), 
	@NoOfSongs NVARCHAR(MAX), @AuthorisedBy NVARCHAR(MAX) , @AuthorisedDate NVARCHAR(MAX), @RequestDate  NVARCHAR(MAX), @RequestID NVARCHAR(MAX),
	@RequestStatusName NVARCHAR(MAX), @SongsApproved NVARCHAR(MAX), @VendorCode INT

	DECLARE @ApprovedOn  NVARCHAR(MAX),  @FileName  NVARCHAR(MAX),  @SubmitBy  NVARCHAR(MAX), @SubmitOn  NVARCHAR(MAX) 

	DECLARE @DynamicTableName NVARCHAR(MAX) = ''

	BEGIN TRY
		IF(@MHCueSheetCode = 0)
		BEGIN
			IF(@MHRequestTypeCode = 1)
			BEGIN
				SELECT DISTINCT
					 @ChannelName = C.Channel_Name
					,@ShowName = (select TOP 1 T.Title_Name from Title T Where T.Title_Code = MR.TitleCode)
					,@EpisodeNo = CASE WHEN ISNULL(MR.EpisodeFrom,0)  < ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX)) +' - '+ CAST(MR.EpisodeTo AS VARCHAR(MAX))
						 WHEN ISNULL(MR.EpisodeFrom,0)  = ISNULL(MR.EpisodeTo,0) THEN  CAST(MR.EpisodeFrom AS VARCHAR(MAX))
						 ELSE '' END
					,@TelecastDate = CONVERT(varchar(11),IsNull(MR.TelecastFrom,''), 106)  + ' - ' + CONVERT(varchar(11),IsNull(MR.TelecastTo,''), 106)
					,@MusicLabel = STUFF((SELECT DISTINCT ', ' + CAST(ML.Music_Label_Name AS NVARCHAR) FROM MHRequestDetails MRD1
						 INNER JOIN Music_Title_Label MTL ON MRD1.MusicTitleCode = MTL.Music_Title_Code 
						 INNER JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
						 Where MRD1.MHRequestCode = MR.MHRequestCode
						 FOR XML PATH('')), 1, 1, '')
					,@NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
					LEFT JOIN Channel c ON c.Channel_Code = MR.ChannelCode
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr= @RequestID +' – Usage Request - is '+UPPER(@RequestStatusName)
				 --SELECT @ChannelName,@ShowName,@EpisodeNo,@TelecastDate,@MusicLabel,@NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved
	
				 DECLARE @PivotUR TABLE 
					(Channel_Name NVARCHAR(MAX),Show_Name  NVARCHAR(MAX), Episode_No  NVARCHAR(MAX),Telecast_Date  NVARCHAR(MAX),
					Music_Label  NVARCHAR(MAX),No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX) )

				INSERT INTO @PivotUR VALUES (@ChannelName, @ShowName, @EpisodeNo, @TelecastDate, @MusicLabel, @NoOfSongs, @SongsApproved)

				SELECT * INTO #UsageRequest FROM(
				SELECT 1 AS RowId, 'Channel Name: ' as ColName, Channel_Name as ColValue from @PivotUR UNION ALL
				SELECT 2 AS RowId, 'Show Name: ' as ColName, Show_Name as ColValue from @PivotUR UNION ALL
				SELECT 3 AS RowId, 'Episode No.: ' as ColName, Episode_No as ColValue from @PivotUR UNION ALL
				SELECT 4 AS RowId, 'Telecast Date: ' as ColName, Telecast_Date as ColValue from @PivotUR UNION ALL
				SELECT 5 AS RowId, 'Music Label: ' as ColName, Music_Label as ColValue from @PivotUR UNION ALL
				SELECT 6 AS RowId, 'Number of Songs: ' as ColName, No_Of_Songs as ColValue from @PivotUR UNION ALL
				SELECT 7 AS RowId, 'Songs Approved: ' as ColName, Songs_Approved as ColValue from @PivotUR) as tmp 
		
				IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED' )
				BEGIN
					DELETE FROM #UsageRequest WHERE RowId = 7
				END

				SET @DynamicTableName = '#UsageRequest'
				SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHCONSUMPTIONREQUEST'
			END
			ELSE IF(@MHRequestTypeCode = 2)
			BEGIN
				SELECT DISTINCT
					 @NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr=@RequestID +' – New Music Tracks Request - is '+UPPER(@RequestStatusName)

				 --SELECT @NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved

				 DECLARE @PivotMTR TABLE (No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX))

				 INSERT INTO @PivotMTR VALUES (@NoOfSongs, @SongsApproved)

				 SELECT * INTO #MusicTracksRequest FROM(
				 SELECT 1 AS RowId, 'Number of Songs: ' as ColName, No_Of_Songs as ColValue from @PivotMTR UNION ALL
				 SELECT 2 AS RowId, 'Approved Songs: ' as ColName, Songs_Approved as ColValue from @PivotMTR) as tmp 

				 IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED' )
				 BEGIN
		 			DELETE FROM #MusicTracksRequest WHERE RowId = 2
				 END

				 SET @DynamicTableName = '#MusicTracksRequest'
				 SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHMUSICREQUEST'
			END
			ELSE IF(@MHRequestTypeCode = 3)
			BEGIN
				 SELECT DISTINCT
					 @NoOfSongs =CAST((SELECT COUNT(*) FROM MHRequestDetails MRD WHERE MRD.MHRequestCode = MR.MHRequestCode ) AS NVARCHAR)
					,@AuthorisedBy = U.First_Name
					,@AuthorisedDate = CONVERT(varchar(11),ISNULL(MR.ApprovedOn,''), 106)
					,@RequestDate = CONVERT(varchar(11),ISNULL(MR.RequestedDate,''), 106)
					,@RequestID = MR.RequestID
					,@RequestStatusName = MRS.RequestStatusName
					,@SongsApproved = (SELECT COUNT(*) FROM MHRequestDetails MRD1 WHERE MR.MHRequestCode = MRD1.MHRequestCode AND MRD1.IsApprove = 'Y')
					,@VendorCode = MR.VendorCode
				 FROM MHRequest MR
					INNER JOIN MHRequestStatus MRS ON MR.MHRequestStatusCode = MRS.MHRequestStatusCode 
					LEFT JOIN Users U ON MR.ApprovedBy = U.Users_Code
				 WHERE MHRequestTypeCode = @MHRequestTypeCode AND MHRequestCode= @MHRequestCode 

				 SET @MailSubjectCr=@RequestID +' – New Movie Request - is '+UPPER(@RequestStatusName)

				 --SELECT @NoOfSongs,@AuthorisedBy,@AuthorisedDate,@RequestDate,@RequestID,@RequestStatusName,@SongsApproved

				 DECLARE @PivotNMR TABLE (No_Of_Songs NVARCHAR(MAX), Songs_Approved NVARCHAR(MAX))

				 INSERT INTO @PivotNMR VALUES (@NoOfSongs, @SongsApproved)

				 SELECT * INTO #NewMovieRequest FROM(
				 SELECT 1 AS RowId, 'Number of Movie/Album: ' as ColName, No_Of_Songs as ColValue from @PivotNMR UNION ALL
				 SELECT 2 AS RowId, 'Approved Movie/Album: ' as ColName, Songs_Approved as ColValue from @PivotNMR) as tmp 

				 IF(UPPER(@RequestStatusName) <> 'PARTIALLY APPROVED')
				 BEGIN
		 			DELETE FROM #NewMovieRequest WHERE RowId = 2
				 END

				 SET @DynamicTableName = '#NewMovieRequest'
				 SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHMOVIEREQUEST'
			END
		END
		ELSE
		BEGIN
			SELECT 
				@RequestID = MC.RequestID,
				@ApprovedOn =  CONVERT(VARCHAR(11),ISNULL(MC.ApprovedOn,''), 106),
				@FileName = MC.FileName, 
				@SubmitBy =V.Vendor_Name +' / ' + U.First_Name,
				@SubmitOn = CONVERT(VARCHAR(11),ISNULL(MC.SubmitOn,''), 106),
				@RequestStatusName = 'COMPLETED',
				@VendorCode = MC.VendorCode
			FROM MHCUESHEET MC
				INNER JOIN Vendor V ON V.Vendor_Code = MC.VendorCode
				INNER JOIN Users U ON U.Users_Code = MC.SubmitBy
			WHERE MC.MHCueSheetCode = @MHCueSheetCode 

			--SELECT @RequestID,@ApprovedOn,@FileName,@SubmitBy,@SubmitOn,@RequestStatusName

			SET @MailSubjectCr =  @RequestID +' – Music Assignment Request - is '+UPPER(@RequestStatusName)
			SELECT @Email_Config_Code =  Email_Config_Code FROM Email_Config WHERE UPPER(Email_Type) = 'MHCUESHEETUPLOAD'
		END
	 
		SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
		SELECT @DefaultSiteUrl = DefaultSiteUrl FROM System_Param
		
		DECLARE @Email_Id NVARCHAR(MAX),  @Users_Code INT = 0, @UserName NVARCHAR(MAX) = '',
				@RowCount INT = 0, @Emailbody NVARCHAR(MAX), @EmailHead NVARCHAR(MAX), @EMailFooter NVARCHAR(MAX)

		DECLARE curOuter CURSOR FOR 
		SELECT MU.Users_Code,U.Email_Id, UPPER(LEFT(U.First_Name, 1))+LOWER(SUBSTRING(U.First_Name, 2, LEN(U.First_Name))) +' '+UPPER(LEFT(U.Last_Name, 1))+LOWER(SUBSTRING(U.Last_Name, 2, LEN(U.Last_Name))) AS UserName FROM MHUsers MU
		INNER JOIN Users U ON U.Users_Code = MU.Users_Code WHERE MU.Vendor_Code = @VendorCode AND U.Is_Active = 'Y'
		OPEN curOuter 
			
		FETCH NEXT FROM curOuter INTO @Users_Code, @Email_Id, @UserName

		SELECT  @EmailUser_Body='', @Emailbody = '', @EmailHead= '', @EMailFooter = ''

		WHILE @@Fetch_Status = 0 
		BEGIN	
				SET @Emailbody = '<table class="tblFormat" style="width:90%; border:1px solid black;border-collapse:collapse;">'
			
				IF(@RowCount = 0)
				BEGIN
					IF(@MHCueSheetCode = 0)
					BEGIN
						  SET @Emailbody=@Emailbody + '<tr><th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="20%" class="tblHead">Request Date</th>
						  <th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="40%" class="tblHead">Request Description</th>
						  <th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="20%" class="tblHead">Authorised By</th>
						  <th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="20%" class="tblHead">Authorised Date</th></tr>'
					 END
					 ELSE
					 BEGIN
						  SET @Emailbody=@Emailbody + '<tr><th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="20%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold; padding:5px;">Request Date</th>
						  <th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="20%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold; padding:5px;">Request Description</th>
						  <th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="20%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold; padding:5px;">Requested By</th>
						  <th border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold align="center" width="20%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;font-weight:bold; padding:5px;">Uploaded On</th></tr>'
					 END
				END
				SET @RowCount  = @RowCount  + 1

				IF(@MHCueSheetCode = 0)
				BEGIN
					DECLARE @returnCount INT = 0,  @Sql NVARCHAR(MAX)=''

					SET @SQL = 'SELECT @Count= Count(*) FROM ' + @DynamicTableName 

					EXEC sp_executesql @SQL,N'@Count INT OUTPUT',@Count=@returnCount OUTPUT

					SELECT @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px" rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' >'+ CAST  (ISNULL(@RequestDate, '') as varchar(MAX))+' </td>		
								{{DYNAMIC}}
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px"  rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' >'+ CAST (ISNULL(@AuthorisedBy,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px"  rowspan='+CAST(@returnCount AS VARCHAR(MAX))+' >'+ CAST (IsNull(@AuthorisedDate,'') AS NVARCHAR(MAX)) +' </td></tr>'

					DECLARE @i INT = 0

					WHILE (@i < @returnCount)
					BEGIN
						 DECLARE @ColName NVARCHAR(MAX)= '', @ColVal NVARCHAR(MAX)= ''
						 SET @i = @i + 1

						 DECLARE @temptable TABLE (ColName NVARCHAR(MAX), ColVal NVARCHAR(MAX))
						 SET @Sql = 'SELECT ColName, ColValue  FROM '+ @DynamicTableName +' WHERE  RowId = '+ Cast(@i as varchar(10))
						 INSERT @temptable EXEC(@Sql) 		 
						 SELECT @ColName = ColName, @ColVal= ColVal FROM @temptable	 

						 IF	(@i = 1)
						 BEGIN
							SELECT @Emailbody = REPLACE(@Emailbody, '{{DYNAMIC}}', '<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px" >'+@ColName +' - '+ @ColVal+'</td>');
						 END
						 ELSE
						 BEGIN
							SELECT @Emailbody=@Emailbody+ '<tr><td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px" >'+@ColName +' - '+ @ColVal+'</td></tr>'
						 END
						 DELETE FROM @temptable	
					END
				END
				ELSE
				BEGIN
					SELECT @Emailbody=@Emailbody +'<tr>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px" >'+ CAST  (ISNULL(@ApprovedOn, '') as varchar(MAX))+' </td>		
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px" >'+ CAST (ISNULL(@FileName,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px" >'+ CAST (ISNULL(@SubmitBy,'') AS NVARCHAR(MAX)) +' </td>
								<td align="center" class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:10px; padding:5px" >'+ CAST (IsNull(@SubmitOn,'') AS NVARCHAR(MAX)) +' </td></tr>'
				END
				IF(@Emailbody!='')
					SET @Emailbody = @Emailbody + '</table>'

				SET @EmailHead= '<html><head>
				
				</head><body>
				<p>Dear '+@UserName+',</p>
				<p>The Request No: '+ @RequestID +' is <b>'+ UPPER(@RequestStatusName) +'</b>. </p>
				<p>Please click <a href="'+@DefaultSiteUrl+'">here</a> to access Music Hub to view the request.</p>
				<p>The details are as follows: </p>'


				SET @EMailFooter ='</br>
				If you have any questions or need assistance, please feel free to reach us at 
				<a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>
				<p>Regards,</br>
				RightsU Support</br>
				U-TO Solutions</p>
				</body></html>'

				SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
		
				IF(@RowCount <> 0)
				BEGIN
					--select @EmailUser_Body, @Users_Code, @Email_Id, @UserName

					EXEC msdb.dbo.sp_send_dbmail 
					@profile_name = @DatabaseEmail_Profile,
					@recipients =  @Email_Id,
					@subject = @MailSubjectCr,
					@body = @EmailUser_Body, 
					@body_format = 'HTML';

					INSERT INTO MHNotificationLog(Email_Config_Code, Created_Time, Is_Read, Email_Body,	User_Code, Vendor_Code, [Subject], Email_Id)
					SELECT @Email_Config_Code,GETDATE(),'N', @Emailbody, @Users_Code, @VendorCode, @MailSubjectCr, @Email_Id

					SET @RowCount = 0
				END
				SET @EmailUser_Body=''	
		
				FETCH NEXT FROM curOuter INTO @Users_Code, @Email_Id, @UserName
		END	
		CLOSE curOuter
		DEALLOCATE curOuter
		SELECT 'Y' as Result  
	END TRY
	BEGIN CATCH
			IF CURSOR_STATUS('global','curOuter')>=-1
			BEGIN
				CLOSE curOuter
				DEALLOCATE curOuter
			END
			
			SELECT ERROR_MESSAGE() as Result  
	END CATCH
END

--exec USPMHMailNotification 10466,1,0
--select * from MHNotificationLog
--select * from email_config order by 1 desc

--CREATE PROCEDURE USPMHMailNotification
--	@MHRequestCode INT,
--	@MHRequestTypeCode INT,
--	@MHCueSheetCode INT = 0
--AS
----=====================================================
---- Author:		<Akshay Rane>
---- Create date: <16 August 2018>
---- Description:	<Email Notification for music hub>
----=====================================================
--BEGIN
--	SELECT '' as Result  
--END