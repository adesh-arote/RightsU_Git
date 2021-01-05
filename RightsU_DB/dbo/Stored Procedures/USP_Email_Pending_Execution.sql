CREATE PROC USP_Email_Pending_Execution
AS
BEGIN
	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL
		DROP TABLE #DealDetails
	IF OBJECT_ID('tempdb..#Syn_DealDetails') IS NOT NULL
		DROP TABLE #Syn_DealDetails
	IF OBJECT_ID('tempdb..#EmailConfigDetailUser') IS NOT NULL
		DROP TABLE #EmailConfigDetailUser
	
	CREATE TABLE #DealDetails
	(
		ID INT IDENTITY  (1,1),
		Acq_Deal_Code INT,
		Agreement_No VARCHAR(MAX),
		Agreement_Date DateTime,
		Deal_Creation_Date DateTime,
		Party NVARCHAR(MAX),
		Titles NVARCHAR(MAX), 	
		Business_Unit_Code INT,
		Business_Unit_Name VARCHAR(MAX),
	)

	CREATE TABLE #Syn_DealDetails
	(
		ID INT IDENTITY  (1,1),
		Syn_Deal_Code INT,
		Agreement_No VARCHAR(MAX),
		Agreement_Date DateTime,
		Deal_Creation_Date DateTime,
		Party NVARCHAR(MAX),
		Titles NVARCHAR(MAX), 	
		Business_Unit_Code INT,
		Business_Unit_Name VARCHAR(MAX),
	)
	
	DECLARE @Deal_Tag_Code INT = 0, @Days_Freq INT

	SELECT @Days_Freq = ECDA.Mail_Alert_Days FROM email_config EC
	INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
	INNER JOIN Email_Config_Detail_Alert ECDA ON ECDA.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	WHERE EC.[Key] = 'PEX'

	SELECT @Deal_Tag_Code = Deal_Tag_Code from Deal_Tag where Deal_Tag_Description = 'Pending For Execution'
	
	--STEP 1 = Fill the #EmailConfigDetailUser table where key = PEX
	SELECT ECDU.User_Type,ECDU.Security_Group_Code,ECDU.Business_Unit_Codes,ECDU.User_Codes,ECDU.CC_Users,ECDU.ToUser_MailID,ECDU.CCUser_MailID 
	INTO #EmailConfigDetailUser 
	FROM Email_Config EC 
		INNER JOIN Email_Config_Detail ECD ON  EC.Email_Config_Code=ECD.Email_Config_Code
		INNER JOIN Email_Config_Detail_User ECDU ON ECDU.Email_Config_Detail_Code=ECD.Email_Config_Detail_Code
	WHERE EC.[Key]='PEX'
	
	--STEP 2 : Fill Acq deal data in #DealDetails
	INSERT INTO #DealDetails( Acq_Deal_Code, Agreement_No,Agreement_Date,Deal_Creation_Date,Party, Business_Unit_Code,Business_Unit_Name)
	SELECT AD.Acq_Deal_Code, AD.Agreement_No, AD.Agreement_Date, AD.Inserted_On, V.Vendor_Name, AD.Business_Unit_Code, BU.Business_Unit_Name
	FROM Acq_Deal AD
		INNER JOIN Vendor V ON V.Vendor_Code=ad.Vendor_Code	
		INNER JOIN Business_Unit BU ON BU.Business_Unit_Code=ad.Business_Unit_Code
	WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
		AND AD.Deal_Tag_Code =  @Deal_Tag_Code
		AND DATEDIFF(day, AD.Inserted_On, GETDATE())>= @Days_Freq 
		AND AD.Business_Unit_Code IN (select Business_Unit_Codes from #EmailConfigDetailUser)

	--STEP 3 : Update titles in #DealDetails
	UPDATE AD SET AD.Titles =  STUFF((
		SELECT DISTINCT ',' +  T.Title_Name FROM Acq_Deal_Movie ADM
		LEFT JOIN Title T ON T.Title_Code = ADM.Title_Code
		WHERE ADM.Acq_Deal_Code = AD.Acq_Deal_Code
	FOR XML PATH('')), 1, 1, '')
	FROM #DealDetails AD

	--STEP 3 : Fill Acq deal data in #Syn_DealDetails
	INSERT INTO #Syn_DealDetails( Syn_Deal_Code, Agreement_No,Agreement_Date,Deal_Creation_Date,Party, Business_Unit_Code,Business_Unit_Name)
	SELECT AD.Syn_Deal_Code, AD.Agreement_No, AD.Agreement_Date, AD.Inserted_On, V.Vendor_Name, AD.Business_Unit_Code, BU.Business_Unit_Name
	FROM Syn_Deal AD
		INNER JOIN Vendor V ON V.Vendor_Code=ad.Vendor_Code	
		INNER JOIN Business_Unit BU ON BU.Business_Unit_Code=ad.Business_Unit_Code
	WHERE  --AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
		 AD.Deal_Tag_Code =  @Deal_Tag_Code
		AND DATEDIFF(day, AD.Inserted_On, GETDATE())>= @Days_Freq 
		AND AD.Business_Unit_Code IN (select Business_Unit_Codes from #EmailConfigDetailUser)
	
	UPDATE AD SET AD.Titles =  STUFF((
		SELECT DISTINCT ',' +  T.Title_Name FROM Syn_Deal_Movie ADM
		LEFT JOIN Title T ON T.Title_Code = ADM.Title_Code
		WHERE ADM.Syn_Deal_Code = AD.Syn_Deal_Code
	FOR XML PATH('')), 1, 1, '')
	FROM #Syn_DealDetails AD

	DECLARE  @Agreement_No NVARCHAR(MAX), @Agreement_Date NVARCHAR(MAX), @Deal_Creation_Date NVARCHAR(MAX), @Party NVARCHAR(MAX), @Titles NVARCHAR(MAX), @Business_Unit_Name NVARCHAR(MAX)
	DECLARE  @User_Type CHAR(1), @Security_Group_Code INT, @Business_Unit_Codes INT, @User_Codes NVARCHAR(MAX) , @CC_Users NVARCHAR(MAX) , @ToUser_MailID  NVARCHAR(MAX) , @CCUser_MailID  NVARCHAR(MAX) 
	DECLARE  @TO NVARCHAR(MAX), @CC NVARCHAR(MAX)
	DECLARE @EmailHead NVARCHAR(max),@EMailFooter NVARCHAR(max),@Emailbody  NVARCHAR(max),@EmailUser_Body  NVARCHAR(max),@DefaultSiteUrl  NVARCHAR(max), @MailSubjectCr NVARCHAR(MAX),@DatabaseEmail_Profile varchar(MAX)
	
	SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
	SELECT @DefaultSiteUrl = DefaultSiteUrl from System_Param

	DECLARE db_cursor CURSOR FOR 
	SELECT  User_Type, Security_Group_Code, Business_Unit_Codes, User_Codes, CC_Users, ToUser_MailID, CCUser_MailID  
	FROM #EmailConfigDetailUser 
	WHERE Business_Unit_Codes in (SELECT DISTINCT Business_Unit_Code FROM #DealDetails)
	
	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO  @User_Type, @Security_Group_Code, @Business_Unit_Codes, @User_Codes, @CC_Users, @ToUser_MailID, @CCUser_MailID 
	
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
	     IF (@User_Type = 'U')
		 BEGIN
				SELECT @TO = STUFF((
					SELECT  DISTINCT ';' + Email_Id FROM Users WHERE Users_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@User_Codes, ',') WHERE number <> ',')
				FOR XML PATH('')), 1, 1, '')
	
				SELECT @CC = STUFF((
					SELECT DISTINCT ';' + Email_Id FROM Users WHERE Users_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@CC_Users, ',') WHERE number <> ',')
				FOR XML PATH('')), 1, 1, '')
		 END
		 ELSE IF (@User_Type = 'G')
		 BEGIN
				SELECT @TO = STUFF((
					SELECT DISTINCT ';' + Email_Id FROM Users where Security_Group_Code = @Security_Group_Code and Is_Active = 'Y'
				FOR XML PATH('')), 1, 1, '')
	
				SELECT @CC = STUFF((
					SELECT DISTINCT ';' + Email_Id FROM Users WHERE Users_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@CC_Users, ',') WHERE number <> ',')
				FOR XML PATH('')), 1, 1, '')
		 END
		 ELSE IF (@User_Type = 'E')
		 BEGIN
				SELECT @TO = @ToUser_MailID, @CC = @CCUser_MailID 
		 END
	
		 DECLARE @Index INT = 0, @RowCount INT = 0, @RowTitleCodeOld VARCHAR(MAX) = '',@RowTitleCodeNew VARCHAR(MAX)= '', @WhereCondition VARCHAR(2)
		 --Code block for acq
		 BEGIN
			 IF EXISTS(SELECT * FROM #DealDetails WHERE Business_Unit_Code = @Business_Unit_Codes)
			 BEGIN
					SELECT  @Index = 0, @RowCount = 0, @RowTitleCodeOld = '',@RowTitleCodeNew = '', @WhereCondition = ''
					SET @Index=0
					SET @Emailbody = '<br><table class="tblFormat">'
					  
					DECLARE db_cursor_AD_Detail CURSOR FOR 
					SELECT  Agreement_No , Agreement_Date , Deal_Creation_Date , Party , Titles, Business_Unit_Name
					FROM #dealdetails WHERE business_unit_code = @business_unit_codes
	
					OPEN db_cursor_AD_Detail 
					FETCH NEXT FROM db_cursor_AD_Detail INTO @Agreement_No , @Agreement_Date , @Deal_Creation_Date , @Party , @Titles, @Business_Unit_Name 
	
					WHILE @@FETCH_STATUS = 0  
					BEGIN  
					  
						  IF(@Index = 0)
						  BEGIN
					  			SET @Emailbody=@Emailbody + '<tr><td align="center" width="10%" class="tblHead"><b>Agreement No.<b></td>
					  			<td align="center" width="12%" class="tblHead"><b>Agreement Date<b></td>
					  			<td align="center" width="12%" class="tblHead"><b>Deal Creation Date<b></td>
					  			<td align="center" width="10%" class="tblHead"><b>Primary Licensor<b></td>
					  			<td align="center" width="10%" class="tblHead"><b>Title<b></td>
					  			<td align="center" width="10%" class="tblHead"><b>Business Unit<b></td></tr>'
						  END
						  SET @Index  = @Index  + 1
						  SET @RowTitleCodeNew= @Agreement_No+ IsNull(@Agreement_Date, '') +'|'+ @Party  +'|'+ IsNull(@Titles, '')    +'|'+ @Business_Unit_Name 
					  
						  IF((@RowTitleCodeOld<>@RowTitleCodeNew))
						  BEGIN
						
								set @RowCount=@RowCount+1
	
								select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" >'+ CAST  (ISNULL(@Agreement_No, ' ') as varchar(MAX))+' </td>
									   <td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Agreement_Date,''), 106) +' </td>    
									   <td align="center" class="tblData" >'+CONVERT(varchar(11),IsNull(@Deal_Creation_Date,''), 106)+' </td>
									   <td align="center" class="tblData" >'+ CAST  (ISNULL(@Party, ' ') as NVARCHAR(MAX)) +' </td>
									   <td align="center" class="tblData" >'+ CAST  (ISNULL(@Titles, ' ') as NVARCHAR(MAX)) +' </td>
									   <td align="center" class="tblData" >'+ CAST  (ISNULL(@Business_Unit_Name, ' ') as NVARCHAR(MAX)) +' </td></tr>'
									
								Set @RowTitleCodeOld = @RowTitleCodeNew
						  END
						  FETCH NEXT FROM db_cursor_AD_Detail INTO @Agreement_No , @Agreement_Date , @Deal_Creation_Date , @Party , @Titles, @Business_Unit_Name 
					END 
					CLOSE db_cursor_AD_Detail  
					DEALLOCATE db_cursor_AD_Detail 
	
					SET @MailSubjectCr='Acquisition Deals are under Pending Execution Stage ';
		
					SET @EmailHead= '<html><head><style>
						table.tblFormat{border:1px solid black;border-collapse:collapse;}
						td.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;}
						td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>
						<p>Dear User,</p>
						<p>The Acquisition Deals are under pending execution stage.</p>
						Please <a href="'+@DefaultSiteUrl+'">click here</a> to approve Acquisition Deal.<br>'
			
					 SET @EMailFooter ='</table><br>
						<p>Regards, <br>
						RightsU Support <br>
						</body></html>'
	
					  SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter				
					  Select @EmailUser_Body
					  --IF(@RowCount!=0)
					  --BEGIN
							--EXEC msdb.dbo.sp_send_dbmail 
							--@profile_name = @DatabaseEmail_Profile,
							--@recipients =  @TO,
							--@copy_recipients= @CC,
							--@subject = @MailSubjectCr,
							--@body = @EmailUser_Body, 
							--@body_format = 'HTML';
					  --END
					  SET @EmailUser_Body=''
	
			 END
			
		 END
		 --Code block for syn
		 BEGIN
			 IF EXISTS(SELECT * FROM #Syn_DealDetails WHERE Business_Unit_Code = @Business_Unit_Codes)
			 BEGIN
					SELECT  @Index = 0, @RowCount = 0, @RowTitleCodeOld = '',@RowTitleCodeNew = '', @WhereCondition = ''
					SET @Index=0
					SET @Emailbody = '<br><table class="tblFormat">'
					  
					DECLARE db_cursor_SD_Detail CURSOR FOR 
					SELECT  Agreement_No , Agreement_Date , Deal_Creation_Date , Party , Titles, Business_Unit_Name
					FROM #Syn_DealDetails WHERE business_unit_code = @business_unit_codes
	
					OPEN db_cursor_SD_Detail 
					FETCH NEXT FROM db_cursor_SD_Detail INTO @Agreement_No , @Agreement_Date , @Deal_Creation_Date , @Party , @Titles, @Business_Unit_Name 
	
					WHILE @@FETCH_STATUS = 0  
					BEGIN  
					  
						  IF(@Index = 0)
						  BEGIN
					  			SET @Emailbody=@Emailbody + '<tr><td align="center" width="10%" class="tblHead"><b>Agreement No.<b></td>
					  			<td align="center" width="12%" class="tblHead"><b>Agreement Date<b></td>
					  			<td align="center" width="12%" class="tblHead"><b>Deal Creation Date<b></td>
					  			<td align="center" width="10%" class="tblHead"><b>Primary Licensor<b></td>
					  			<td align="center" width="10%" class="tblHead"><b>Title<b></td>
					  			<td align="center" width="10%" class="tblHead"><b>Business Unit<b></td></tr>'
						  END
						  SET @Index  = @Index  + 1
						  SET @RowTitleCodeNew= @Agreement_No+ IsNull(@Agreement_Date, '') +'|'+ @Party  +'|'+ IsNull(@Titles, '')    +'|'+ @Business_Unit_Name 
					  
						  IF((@RowTitleCodeOld<>@RowTitleCodeNew))
						  BEGIN
						
								set @RowCount=@RowCount+1
	
								select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" >'+ CAST  (ISNULL(@Agreement_No, ' ') as varchar(MAX))+' </td>
									   <td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Agreement_Date,''), 106) +' </td>    
									   <td align="center" class="tblData" >'+CONVERT(varchar(11),IsNull(@Deal_Creation_Date,''), 106)+' </td>
									   <td align="center" class="tblData" >'+ CAST  (ISNULL(@Party, ' ') as NVARCHAR(MAX)) +' </td>
									   <td align="center" class="tblData" >'+ CAST  (ISNULL(@Titles, ' ') as NVARCHAR(MAX)) +' </td>
									   <td align="center" class="tblData" >'+ CAST  (ISNULL(@Business_Unit_Name, ' ') as NVARCHAR(MAX)) +' </td></tr>'
									
								Set @RowTitleCodeOld = @RowTitleCodeNew
						  END
						  FETCH NEXT FROM db_cursor_SD_Detail INTO @Agreement_No , @Agreement_Date , @Deal_Creation_Date , @Party , @Titles, @Business_Unit_Name 
					END 
					CLOSE db_cursor_SD_Detail  
					DEALLOCATE db_cursor_SD_Detail 
	
					SET @MailSubjectCr='Syndication Deals are under Pending Execution Stage ';
		
					SET @EmailHead= '<html><head><style>
						table.tblFormat{border:1px solid black;border-collapse:collapse;}
						td.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;}
						td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>
						<p>Dear User,</p>
						<p>The Syndication Deals are under pending execution stage.</p>
						Please <a href="'+@DefaultSiteUrl+'">click here</a> to approve Syndication Deal.<br>'
			
					 SET @EMailFooter ='</table><br>
						<p>Regards, <br>
						RightsU Support <br>
						</body></html>'
	
					  SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter				
					  Select @EmailUser_Body
					  --IF(@RowCount!=0)
					  --BEGIN
							--EXEC msdb.dbo.sp_send_dbmail 
							--@profile_name = @DatabaseEmail_Profile,
							--@recipients =  @TO,
							--@copy_recipients= @CC,
							--@subject = @MailSubjectCr,
							--@body = @EmailUser_Body, 
							--@body_format = 'HTML';
					  --END
					  SET @EmailUser_Body=''
	
			 END
		 END
		 FETCH NEXT FROM db_cursor INTO  @User_Type, @Security_Group_Code, @Business_Unit_Codes, @User_Codes, @CC_Users, @ToUser_MailID, @CCUser_MailID 
	END 
	CLOSE db_cursor  
	DEALLOCATE db_cursor

	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL
		DROP TABLE #DealDetails
	IF OBJECT_ID('tempdb..#Syn_DealDetails') IS NOT NULL
		DROP TABLE #Syn_DealDetails
	IF OBJECT_ID('tempdb..#EmailConfigDetailUser') IS NOT NULL
		DROP TABLE #EmailConfigDetailUser
	
END

