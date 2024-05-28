CREATE PROCEDURE [dbo].[USPMHNotificationMailForCueSheet]   
@MHCueSheetCode INT,  
@UsersCode INT  
AS  
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHNotificationMailForCueSheet]', 'Step 1', 0, 'Started Procedure', 0, ''
	-----------------------------------  
	--Author: Rahul Kembhavi  
	--Description: Notification mails would trigger on CueSheet Submit  
	--Date Created: 13-July-2018  
	---------------------------------------------  
   
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

				SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config (NOLOCK) WHERE [Key]='MHCSS'

				INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
				EXEC USP_Get_EmailConfig_Users 'MHCSS', 'N'

	   SELECT @DatabaseEmail_Profile = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'DatabaseEmail_Profile_MusicHub'  
  
	   Select @DefaultSiteUrl = parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'MusicHub_URL_Link'  
  
	   SET @VendorCode = (Select top 1 Vendor_Code from MHUsers (NOLOCK) where Users_Code = @UsersCode)  
  
	   BEGIN  
		SELECT RequestID,FileName,U.Login_Name AS CreatedBy,V.Vendor_Name,MCS.CreatedOn INTO #temp  
		FROM MHCueSheet MCS  (NOLOCK) 
		INNER JOIN Users U (NOLOCK) ON U.Users_Code = MCS.CreatedBy  
		INNER JOIN MHUsers MU  (NOLOCK) ON MU.Users_Code = MCS.CreatedBy  
		INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code = MU.Vendor_Code  
		Where MHCueSheetCode = @MHCueSheetCode  
	   END  
  
	   SET @RequestID  = (Select RequestID from #temp)  
	   SET @RequestedDate  = (Select REPLACE(CONVERT(NVARCHAR,CreatedOn, 106),' ', '-') from #temp)  
	   SET @RequestDescription = (Select FileName from #temp)  
	   SET @VendorName = (Select Vendor_Name from #temp)  
	   SET @RequestedBy  = (Select CreatedBy from #temp)  
  
	   SET @MailSubjectCr=''+@RequestID+'  - Music Assignment Request - Awaiting Request Authorization';  
	   SET @EmailConfigCode = (Select Email_Config_Code from Email_Config (NOLOCK) where Email_Type = 'MHCueSheetSubmit' )  
	   SET @Subject = ''+@RequestID+' Sent for approval';  
     
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
  

	   SELECT  @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter  
	   print @EmailUser_Body  
     
		 INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
				SELECT @Email_Config_Code,@EmailUser_Body, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  @MailSubjectCr
				


	   --EXEC msdb.dbo.sp_send_dbmail   
	   --@profile_name = @DatabaseEmail_Profile,  
	   --@recipients =  @ToMail,  
	   --@subject = @MailSubjectCr,  
	   --@body = @EmailUser_Body,   
	   --@body_format = 'HTML';  
  
	 --  INSERT INTO Email_Notification_Log VALUES(@EmailConfigCode,GETDATE(),'N',@Emailbody,@UserCode,@Subject,@ToMail)  
	 --  INSERT INTO MHNotificationLog VALUES(@EmailConfigCode,GETDATE(),'N',@Emailbody,@UserCode,@VendorCode,@Subject,@ToMail)  
	 --  Select @ToMail  
	 --  FETCH NEXT FROM curOuter INTO @UserCode, @ToMail  
	 --END  
	 --Close curOuter  
	 --Deallocate curOuter
 
			FETCH NEXT FROM cPointer INTO @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
			END
		CLOSE cPointer
		DEALLOCATE cPointer

			--	select * from @Email_Config_Users_UDT
 		EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT
	 IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp  
 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHNotificationMailForCueSheet]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END