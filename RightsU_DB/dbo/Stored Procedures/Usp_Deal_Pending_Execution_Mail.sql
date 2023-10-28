CREATE PROCEDURE [dbo].[Usp_Deal_Pending_Execution_Mail] 
--Author:  Vipul Surve             
-- Create date: 25-07-2017              
AS 
BEGIN 
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[Usp_Deal_Pending_Execution_Mail]', 'Step 1', 0, 'Started Procedure', 0, ''
		  SET nocount ON;                   

		  DECLARE @EmailBody            NVARCHAR(max)='', 
				  @EmailBody1           NVARCHAR(max)='', 
				  @EmailBody2           NVARCHAR(max)='', 
				  @EmailBodyT           NVARCHAR(max) = '', 
				  @MailSubject          NVARCHAR(max), 
				  @DatabaseEmailProfile NVARCHAR(25), 
				  @EmailHeader          NVARCHAR(max)='', 
				  @EmailFooter          NVARCHAR(max)='', 
				  @users                NVARCHAR(max), 
				  @UsersEmailId         NVARCHAR(max), 
				  @Users_Email_id       NVARCHAR(max), 
				  @Business_Unit_Code   INT, 
				  @Title_Name           NVARCHAR(max), 
				  @Agreement_No         NVARCHAR(max), 
				  @Deal_Desc            NVARCHAR(max), 
				  @Email_Id             NVARCHAR(max), 
				  @Vender_Name          NVARCHAR(500), 
				  @Agreement_Date       NVARCHAR(max), 
				  @Is_Daily             CHAR(1), 
				  @Days                 INT, 
				  @Bu_Name              NVARCHAR(100), 
				  @Users_Code           INT, 
				  @TUser_Code           INT, 
				  @EmailDetails         NVARCHAR(max), 
				  @Deal_Workflow_Status NVARCHAR(100), 
				  @Deal_Tag_Code        CHAR(10), 
				  @DaysFreq             INT, 
				  @MinDays              INT, 
				  @MiddleDays           INT 
		  DECLARE @Email_Config_Code INT 
		  DECLARE @DefaultSiteUrl VARCHAR(max) 

		  SELECT @DefaultSiteUrl = defaultsiteurl 
		  FROM   system_param  (NOLOCK)

		  SELECT @Email_Config_Code = email_config_code 
		  FROM   email_config  (NOLOCK)
		  WHERE  [key] = 'PEX' 

		  SELECT @DatabaseEmailProfile = parameter_value 
		  FROM   system_parameter_new 
		  WHERE  parameter_name = 'DatabaseEmail_Profile' 

		  SELECT @Is_Daily = parameter_value 
		  FROM   system_parameter_new 
		  WHERE  parameter_name = 'Approver_Alert_Is_Daily' 

		  SELECT @Deal_Tag_Code = parameter_value 
		  FROM   system_parameter_new 
		  WHERE  parameter_name = 'Deal_Tag_Pending_Execution' 

		  SELECT @DaysFreq = Substring(days_freq, 2, 2) 
		  FROM   email_config  (NOLOCK)
		  WHERE  [key] = 'PEX' 

		  --SELECT @MinDays = LEFT(days_freq, 2)    
		  --   FROM   email_config    
		  --   WHERE  [key] = 'PEX'    
		  -- SELECT @MiddleDays = substring(days_Freq,4,2)   
		  --   FROM   email_config    
		  --   WHERE  [key] = 'PEX'    
		  IF Object_id('tempdb..#TempA') IS NOT NULL 
			BEGIN 
				DROP TABLE #tempa 
			END 

		  IF Object_id('tempdb..#TempS') IS NOT NULL 
			BEGIN 
				DROP TABLE #temps 
			END 

		  IF Object_id('tempdb..#Email_Config_Alert') IS NOT NULL 
			BEGIN 
				DROP TABLE #email_config_alert 
			END 

		  SELECT F.user_mail_id, 
				 F.bucode, 
				 F.users_code, 
				 (SELECT First_Name 
				  FROM   users  (NOLOCK)
				  WHERE  users_code = F.users_code) AS Users_Name, 
				 F.channel_codes, 
				 mail_alert_days 
		  INTO   #email_config_alert 
		  FROM   [dbo].[Ufn_get_bu_wise_user]('PEX') AS F 
				 INNER JOIN email_config E  (NOLOCK)
						 ON E.[key] = 'PEX' 
				 INNER JOIN email_config_detail ED  (NOLOCK)
						 ON E.email_config_code = ED.email_config_code 
				 INNER JOIN email_config_detail_alert EDA  (NOLOCK)
						 ON ED.email_config_detail_code = 
							EDA.email_config_detail_code 
	  END 

	SET @MailSubject = 'RightsU Deal Status Change(Pending For Execution)' 
	SET @EmailFooter = '</br>      Kindly login <a href="' 
					   + @DefaultSiteUrl + '">here</a> to know more.</br></br>      If you have any questions or need assistance, please feel free to reach us at       <a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>      <p>Regards,</br>      RightsU Support</br>      U-TO Solutions</p>      </body></html>' 

	SELECT DISTINCT AD.acq_deal_code, 
					U.email_id AS Email_Id, 
					BU.business_unit_name, 
					U.users_code 
	INTO   #tempa 
	FROM   acq_deal AD  (NOLOCK)
		   INNER JOIN business_unit BU (NOLOCK)
				   ON BU.business_unit_code = AD.business_unit_code 
					  AND BU.is_active = 'Y' 
		   INNER JOIN users U (NOLOCK) 
				   ON U.users_code = AD.inserted_by 
		   LEFT JOIN #email_config_alert T 
				  ON T.bucode = AD.business_unit_code 
	WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND   AD.deal_tag_code = @Deal_Tag_Code 
		   AND Datediff(d, AD.inserted_on, Getdate()) >= @DaysFreq 

	IF EXISTS(SELECT * 
			  FROM   #tempa) 
	  BEGIN 
		  SET @EmailBody1 = @EmailBody1 
							+ '<tr> <th align="center" width="7%;" style=" font-size: 14px;" >Agreement No</th> <th align="center" width="5%;"  style="font-size: 14px;">Business Unit</th> <th align="center" width="12%;" style="font-size: 14px;">Agreement Date</th> <th align="center" w idth="13%;" style="font-size: 14px;">Deal Description</th> <th align="center" width="12%;" style="font-size: 14px;">Primary Licensor</th> <th align="center" width="10%;" style="font-size: 14px;">Titles</th> <th align="center" width="10%;" style="font-size : 14px;">Workflow Status</th> </tr>' 

		  DECLARE curmail1 CURSOR FOR 
			SELECT DISTINCT user_mail_id, 
							users_code, 
							users_name 
			FROM   #email_config_alert 

		  OPEN curmail1 

		  FETCH next FROM curmail1 INTO @Email_Id, @Users_Code, @users 

		  WHILE( @@FETCH_STATUS = 0 ) 
			BEGIN 
				SET @EmailBodyT = 
	'<table  class="tblFormat" Border = 1px solid black; border-collapse: collapse>' 

		DECLARE curmail2 CURSOR FOR 
		  SELECT DISTINCT users_code 
		  FROM   #email_config_alert 
		  WHERE  users_code = @Users_Code 

		OPEN curmail2 

		FETCH next FROM curmail2 INTO @Users_Code 

		WHILE( @@FETCH_STATUS = 0 ) 
		  BEGIN 
			  IF EXISTS (SELECT * 
						 FROM   #tempa t 
								INNER JOIN acq_deal AD (NOLOCK) 
										ON AD.acq_deal_code = t.acq_deal_code 
						 WHERE  t.email_id = @Email_Id) 
				BEGIN 
					DECLARE curmail CURSOR FOR 
					  SELECT DISTINCT AD.agreement_no, 
									  Replace(CONVERT(VARCHAR, AD.agreement_date, 106),' ','-') 
									  AS 
																 Agreement_Date, 
									  AD.deal_desc, 
									  (SELECT vendor_name 
									   FROM   vendor  (NOLOCK)
									   WHERE  vendor_code = AD.vendor_code) 
									  AS 
																 Vendor_Name, 
									  (SELECT business_unit_name 
									   FROM   business_unit  (NOLOCK)
									   WHERE  business_unit_code = 
									  AD.business_unit_code) 
									  AS 
																 Business_Unit_Name, 
									  Stuff((SELECT DISTINCT ', ' + T.title_name 
											 FROM   acq_deal_movie ADM  (NOLOCK)
													INNER JOIN acq_deal AD1 (NOLOCK) 
															ON ad.acq_deal_code = 
															   adm.acq_deal_code 
													INNER JOIN title T (NOLOCK) 
															ON T.title_code = 
															   ADM.title_code 
											 WHERE  Ad1.acq_deal_code = 
													AD.acq_deal_code 
											 FOR xml path(''), root('MyString'), 
		  type).value('/MyString[1]', 
		  'nvarchar(max)'), 1, 2, '')                         AS 
		  Title_Names, 
		  dbo.[Ufn_get_deal_dealworkflowstaus](AD.acq_deal_code, 
		  deal_workflow_status, 
		  Cast(@Users_Code AS VARCHAR(50)))                   AS 
		  Final_Deal_Workflow_Status 
		  FROM   acq_deal AD (NOLOCK) 
		  INNER JOIN #email_config_alert ECA 
		  ON AD.business_unit_code = ECA.bucode 
		  INNER JOIN users U (NOLOCK) 
		  ON U.users_code = @Users_Code 
		  AND U.users_code = ECA.users_code 
		  WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  deal_tag_code = @Deal_Tag_Code 
		  AND Datediff(d, AD.inserted_on, Getdate()) >= @DaysFreq 

		  OPEN curmail 

		  FETCH next FROM curmail INTO @Agreement_No, @Agreement_Date, @Deal_Desc, 
		  @Vender_Name, @Bu_Name, @Title_Name ,@Deal_Workflow_Status 

		  --,@Agreement_Date,@Title_Name,@Days             
		  WHILE( @@FETCH_STATUS = 0 ) 
		  BEGIN 
		  SET @EmailBody2 = Isnull(@EmailBody2, ' ') 
		  + 
		  '<tr>            <td align="center" width="7%" style="font-size: 13px;">' 
		  + Isnull(@Agreement_No, ' ') 
		  + 
		  '</td>   <td align="center" width="7%" style="font-size: 13px;">' 
		  + Isnull(@Bu_Name, ' ') 
		  + 
		  '</td>      <td align="center" width="7%" style="font-size: 13px;">' 
		  + Isnull(@Agreement_Date, ' ') 
		  + 
		  '</td>              <td width="12%" style="font-size: 13px;">' 
		  + Isnull(@Deal_Desc, ' ') 
		  + 
		  '</td>            <td width="13%" style="font-size: 13px;">' 
		  + Isnull(@Vender_Name, ' ') 
		  + '</td>    <td width="13%" style="font-size: 13px;">' 
		  + Isnull(@Title_Name, ' ')     
		  + '</td>   <td width="13%" style="font-size: 13px;">'
		  + Isnull(@Deal_Workflow_Status, ' ') 
		  +'</td>           </tr>' 

		  FETCH next FROM curmail INTO @Agreement_No, @Agreement_Date, @Deal_Desc, 
		  @Vender_Name, @Bu_Name, @Title_Name, @Deal_Workflow_Status 
		  --,@Agreement_Date,@Title_Name,@Days             
		  END 

		  CLOSE curmail; 

		  DEALLOCATE curmail; 

		  IF( @EmailBody2 != '' ) 
		  BEGIN 
		  SET @EmailBody = Isnull(@EmailBody, '') 
		  + Isnull(@EmailBodyT, '') 
		  + Isnull(@EmailBody1, '') 
		  + Isnull(@EmailBody2, '') 
		  END 
		  END 

			  FETCH next FROM curmail2 INTO @Users_Code 
		  END 

		CLOSE curmail2 

		DEALLOCATE curmail2 

		IF( @EmailBody != '' ) 
		  SET @EmailBody += '</table>' 

		--print @EmailBody 
		SET @EmailHeader= 
		'<html>        <head> <style>table {border-collapse: collapse;width: 100%;border-color:black}th, td {padding: 2px;border-color:black; Font-Size:12;}         th {background-color: #c7c6c6;color: black;border-color:black; font-weight:b  old}</style></head>         <body>         <Font FACE="" SIZE="" COLOR="Black">Dear ' 
		+ @users 
		+ 
	',<br /><br />Please find the Deals for which the Deal Status is Pending for Execution, listed as under:<br /><br />         </Font>' 

  
		--print @EmailFooter   
		IF( @EmailBody != '' ) 
		  SET @EmailBody=@EmailBody + '</table>' 

		SET @EmailDetails = @EmailHeader + @EmailBody + @EmailFooter 

		IF( @EmailBody != '' ) 
		  BEGIN 
			  EXEC msdb.dbo.Sp_send_dbmail 
				@profile_name = @DatabaseEmailProfile, 
				@recipients = @Email_Id, 
				@subject = @MailSubject, 
				@body = @EmailDetails, 
				@body_format = 'HTML'; 

			  INSERT INTO email_notification_log 
						  (email_config_code, 
						   created_time, 
						   is_read, 
						   email_body, 
						   user_code, 
						   [subject], 
						   email_id) 
			  SELECT @Email_Config_Code, 
					 Getdate(), 
					 'N', 
					 @EmailBody, 
					 @Users_Code, 
					 'Pending Execution', 
					 @Email_Id 
		  END 

		SET @EmailDetails='' 
		SET @EmailBody='' 
		SET @EmailBody2='' 

		FETCH next FROM curmail1 INTO @Email_Id, @Users_Code, @users 
	END 

		CLOSE curmail1 

		DEALLOCATE curmail1 
		IF OBJECT_ID('tempdb..#email_config_alert') IS NOT NULL DROP TABLE #email_config_alert
		IF OBJECT_ID('tempdb..#tempa') IS NOT NULL DROP TABLE #tempa
		IF OBJECT_ID('tempdb..#TempS') IS NOT NULL DROP TABLE #TempS
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Usp_Deal_Pending_Execution_Mail]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END