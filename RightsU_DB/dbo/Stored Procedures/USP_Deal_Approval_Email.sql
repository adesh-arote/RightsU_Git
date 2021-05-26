CREATE PROCEDURE [dbo].[USP_Deal_Approval_Email]
@mailFor VARCHAR(2) = 'AP'
AS
BEGIN
	 --'AP' = Approved
	 --'DA' = Details Added
	 --'RJ' = Rejected

	--DECLARE @Deal_heading VARCHAR(20) = 'Expiring'	

	--DECLARE @mailFor VARCHAR(2) = 'DA'

	DECLARE @Index INT = 0, @RowCount INT = 0, @RowTitleCodeOld VARCHAR(MAX) = '',@RowTitleCodeNew VARCHAR(MAX)= '', @WhereCondition VARCHAR(2)
	DECLARE @AcqSynProcess CHAR(1) = 'Y', @Details_AD_RJ_Stage_Since_Days INT = 0

	SELECT @Details_AD_RJ_Stage_Since_Days = '-'+Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Email_Details_AD_RJ_Stage_Since_Days'

	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL
		DROP TABLE #DealDetails

	IF OBJECT_ID('tempdb..#DealDetailsAdded') IS NOT NULL
		DROP TABLE #DealDetailsAdded

	IF OBJECT_ID('tempdb..#DealDetailRejected') IS NOT NULL
		DROP TABLE #DealDetailRejected

	CREATE TABLE #DealDetails
	(
		ID INT IDENTITY (1,1),
		Agreement_No VARCHAR(MAX),
		Deal_Desc NVARCHAR(MAX),
		Ref_No NVARCHAR(MAX),
		Deal_Type VARCHAR(MAX),
		Agreement_Date DateTime,
		[Status] NVARCHAR(MAX),
		Party NVARCHAR(MAX),
		Business_Unit_Code INT
	)

	CREATE TABLE #DealDetailsAdded
	(
		ID INT IDENTITY (1,1),
		Acq_Deal_Code INT,
		Agreement_No VARCHAR(MAX),
		Agreement_Date DATETIME,
		Deal_Desc NVARCHAR(MAX),
		Primary_Vendor NVARCHAR(MAX),
		Title_Names NVARCHAR(MAX),
		Deal_Creation_Date DATETIME,
		Deal_Added_Since INT,
		Business_Unit_Code INT
	)

	CREATE TABLE #DealDetailRejected
	(
		ID INT IDENTITY (1,1),
		Acq_Deal_Code INT,
		Agreement_No VARCHAR(MAX),
		Agreement_Date DATETIME,
		Deal_Desc NVARCHAR(MAX),
		Primary_Vendor NVARCHAR(MAX),
		Title_Names NVARCHAR(MAX),
		Deal_Creation_Date DATETIME,
		Deal_Rejection_Date DATETIME,
		Deal_Rejected_Since INT,
		Business_Unit_Code INT
	)


	DECLARE @ID INT, @Record_Found CHAR(1), @Agreement_No VARCHAR(MAX), @Deal_Desc NVARCHAR(MAX),@Agreement_Date VARCHAR(MAX), @Deal_Type VARCHAR(MAX),@Party NVARCHAR(100)
	DECLARE  @Acq_Deal_Code INT, @Primary_Vendor NVARCHAR(MAX),@Title_Names NVARCHAR(MAX), @Deal_Creation_Date DATETIME,@Deal_Rejection_Date DATETIME, @Deal_Added_Since INT , @Deal_Rejected_Since INT, @Business_Unit_Code INT
	DECLARE @DatabaseEmail_Profile varchar(MAX)	, @EmailUser_Body NVARCHAR(MAX), @Users_Email_Id Varchar(MAX),@Emailbody NVARCHAR(Max), @DefaultSiteUrl VARCHAR(MAX)
	DECLARE @EmailHead NVARCHAR(max), @EMailFooter NVARCHAR(max),  @MailSubjectCr AS NVARCHAR(MAX)
	DECLARE @AcqSyn NVARCHAR(MAX) = 'Acquisition'
	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = 'NDA'
	DECLARE @Users_Code INT
	SELECT @Users_Code = Users_Code FROM [dbo].[UFN_Get_Bu_Wise_User]('NDA')

	-----------------------------------------------------------
	DECLARE 
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX),
	@Channel_Codes NVARCHAR(MAX)
	
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

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'NDA', 'N'
	--------------------------------------------------------

	IF(@mailFor = 'AP')
	BEGIN

		DECLARE @Mail_alert_days INT, @Deal_Expiry_email_code INT

		INSERT INTO #DealDetails(Agreement_No,Deal_Desc,Deal_Type,Agreement_Date,[Status],Party,Business_Unit_Code)
		SELECT Agreement_No,Deal_Desc,Deal_Type_Name,Agreement_Date,Status,Vendor_Name,Business_Unit_Code FROM 
		(
		SELECT  ad.Agreement_No  ,ad.Deal_Desc,DT.Deal_Type_Name  ,Agreement_Date,ad.Acq_Deal_Code,
		Case When ad.[Status]='O' Then 'Open' When  AD.[Status]='T' Then 'Terminated' Else ' ' END AS Status,V.Vendor_Name,ad.Business_Unit_Code 
		FROM Acq_Deal ad
		INNER JOIN Deal_Type DT ON DT.Deal_Type_Code=ad.Deal_Type_Code
		INNER JOIN Vendor V ON V.Vendor_Code=ad.Vendor_Code
		INNER JOIN 
		(
			Select Record_Code from 
			(
				SELECT  msh.Record_Code,u.Security_Group_Code,Count(*) AS MSHCount FROM Module_Status_History msh 
				INNER JOIN Users u ON u.Users_Code = msh.Status_Changed_By where CONVERT(DATE,Status_Changed_On)=Convert(date,GETDATE()) AND Status='A' AND msh.Module_Code=30
				AND msh.Record_Code NOT IN
				(
					SELECT h.Record_Code FROM Module_Status_History h WHERE CONVERT(DATE,h.Status_Changed_On)!=CONVERT(DATE,GETDATE()) 
					AND Status='A' AND h.Module_Code=30
				) GROUP BY msh.Record_Code,u.Security_Group_Code
			) as tmpMSH  
			INNER JOIN 
			(
				Select mwd.Record_Code AS mwdRecord_Code, mwd.Group_Code AS mwdGroup_Code from Module_Workflow_detail mwd
				Inner join 
				(
					select Record_Code,Max(Role_Level) MAx_Role_Level from Module_Workflow_detail where Module_Code=30 Group by Record_Code
				) as a 
				on a.Record_Code =  mwd.Record_Code and a.MAx_Role_Level = mwd.Role_Level
			) AS tmpMWD on mwdRecord_Code = tmpMSH.Record_Code AND mwdGroup_Code = tmpMSH.Security_Group_Code
			WHERE tmpMSH.MSHCount =1
		) AS mainDeal on Record_Code=ad.Acq_Deal_Code
		 where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ad.Acq_Deal_Code IN(SELECT Acq_Deal_Code FROM Acq_Deal_Rights where Is_Sub_License='Y')
		 ) AS finalDeal 

		IF EXISTS(Select * from #DealDetails)
		BEGIN
			--DECLARE @ID INT, @Record_Found CHAR(1), @Agreement_No VARCHAR(MAX), @Deal_Desc NVARCHAR(MAX),
			--@Agreement_Date VARCHAR(MAX), @Deal_Type VARCHAR(MAX),@Party NVARCHAR(100)

			--DECLARE @DatabaseEmail_Profile varchar(MAX)	, @EmailUser_Body NVARCHAR(MAX), @Users_Email_Id Varchar(MAX),@Emailbody NVARCHAR(Max), @DefaultSiteUrl VARCHAR(MAX)
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
	
			SET @MailSubjectCr='Approved Deal';
			
			SELECT @DefaultSiteUrl = DefaultSiteUrl from System_Param

			DECLARE curOuter CURSOR FOR SELECT DISTINCT Email_Id FROM  Approval_Email_BU
			OPEN curOuter 
			--Select * from Approval_Email_BU
			FETCH NEXT FROM curOuter Into @Users_Email_Id
				SET @RowCount=0
				SET @EmailUser_Body=''
				--SET @RowTitleCodeNew = ''
				--SET @Emailbody = @Emailbody + '<table class="tblFormat">'
				WHILE @@Fetch_Status = 0 
				BEGIN	
				--SET @RowTitleCodeOld = ''
					SET @Index=0
					SET @Emailbody = '<table class="tblFormat">'
					Declare curInner cursor For select Agreement_No,Deal_Desc,Deal_Type,Agreement_Date,Party
					from #DealDetails
					Where Business_Unit_Code IN(select Business_Unit_Code from Approval_Email_BU where Email_Id=@Users_Email_Id)
					select * from Approval_Email_BU
						OPEN curInner
						Fetch Next From curInner Into @Agreement_No,@Deal_Desc,@Deal_Type,@Agreement_Date,@Party
						WHILE @@Fetch_Status = 0 
						BEGIN
					
							IF(@Index = 0)
							BEGIN
									SET @Emailbody=@Emailbody + '<tr><td align="center" width="10%" class="tblHead"><b>Agreement<b></td>
									<td align="center" width="40%" class="tblHead"><b>Deal Description<b></td>
									<td align="center" width="10%" class="tblHead"><b>Deal Type<b></td>
									<td align="center" width="12%" class="tblHead"><b>Agreement Date<b></td>
									<td align="center" width="10%" class="tblHead"><b>Licensor<b></td></tr>'
							END
					
							SET @Index  = @Index  + 1
							SET @RowTitleCodeNew=@Agreement_No+'|'+ @Deal_Desc +'|'+ @Deal_Type +'|'+ IsNull(@Agreement_Date, '') +'|'+ @Party
							IF((@RowTitleCodeOld<>@RowTitleCodeNew))
							BEGIN
								--set @Temp_tbl_count=@Temp_tbl_count+1
								set @RowCount=@RowCount+1
								select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" >'+ CAST  (ISNULL(@Agreement_No, ' ') as varchar(MAX))+' </td>
								<td align="center" class="tblData" >'+ CAST  (ISNULL(@Deal_Desc, ' ') as NVARCHAR(MAX))+' </td>
								<td align="center" class="tblData" >'+ CAST  (ISNULL(@Deal_Type, ' ') as varchar(MAX)) +' </td>
								<td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Agreement_Date,''), 106) +' </td>
								<td align="center" class="tblData" >'+ CAST  (ISNULL(@Party, ' ') as NVARCHAR(MAX)) +' </td></tr>'
								Set @RowTitleCodeOld = @RowTitleCodeNew
							End
							FETCH NEXT FROM curInner INTO @Agreement_No,@Deal_Desc,@Deal_Type,@Agreement_Date,@Party
						END
						CLOSE curInner
						DEALLOCATE curInner
						--SET @Emailbody = @Emailbody + '</table>'

					--DECLARE @EmailHead NVARCHAR(max)
					SET @EmailHead= '<html><head><style>
					table.tblFormat{border:1px solid black;border-collapse:collapse;}
					td.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;}
					td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>
					<p>Dear User,</p>
					<p>This email is to inform you that new Deals has been entered and approved in RightsU. </p>
					The details are as follows:'

					--DECLARE @EMailFooter NVARCHAR(max)
					SET @EMailFooter ='</table></br>
					Kindly login <a href="'+@DefaultSiteUrl+'">here</a> to know more.</br></br>
					If you have any questions or need assistance, please feel free to reach us at 
					<a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>
					<p>Regards,</br>
					RightsU Support</br>
					U-TO Solutions</p>
					</body></html>'
					--PRINT @EmailUser_Body
					PRINT(@EmailUser_Body)
					SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
					PRINT @EmailUser_Body
					IF(@RowCount!=0)
					BEGIN
							 EXEC msdb.dbo.sp_send_dbmail 
							 @profile_name = @DatabaseEmail_Profile,
							 @recipients =  @Users_Email_Id,
							 @subject = @MailSubjectCr,
							 @body = @EmailUser_Body, 
							 @body_format = 'HTML';

							 INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
							 SELECT @Email_Config_Code,GETDATE(),'N',@Emailbody,NULL,@MailSubjectCr,@Users_Email_Id
					END
					SET @EmailUser_Body=''
				
				FETCH NEXT FROM curOuter INTO @Users_Email_Id
				END
			CLOSE curOuter
			DEALLOCATE curOuter
		END
	END
	ELSE IF(@mailFor = 'DA')
	BEGIN
			

			INSERT INTO #DealDetailsAdded (Acq_Deal_Code,Agreement_No,Agreement_Date,Deal_Desc,Primary_Vendor,Title_Names,Deal_Creation_Date,Deal_Added_Since,Business_Unit_Code)
			SELECT 
				 ad.Acq_Deal_Code,
				 ad.Agreement_No,
				 ad.Agreement_Date,
				 ad.Deal_Desc,
				 V.Vendor_Name,
				 STUFF((
				 SELECT DISTINCT ', ' +  LTRIM(RTRIM(T.Title_Name))
							FROM Acq_Deal_Movie ADM
							INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
							WHERE Acq_Deal_Code = ad.Acq_Deal_Code
				FOR XML PATH('')
				), 1, 1, '') as Title_Names,
				 ad.Inserted_On,
				 DATEDIFF(dd,ad.Inserted_On, GETDATE()) AS Deal_Added_Since, --DATEADD(day,-7, GETDATE())
				 ad.Business_Unit_Code
			FROM Acq_Deal ad
			INNER JOIN Vendor V ON V.Vendor_Code=ad.Vendor_Code
			WHERE ad.Deal_Workflow_Status in ('N','AM')
			AND 0 =
			(SELECT count(*)  FROM 
				(
				select  DISTINCT Title_Code from Acq_Deal_Movie  WHERE Acq_Deal_Code =  AD.Acq_Deal_Code
				EXCEPT
				SELECT DISTINCT Title_Code FROM Acq_Deal_Rights_Title WHERE  Acq_Deal_Rights_Code IN ( SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code = AD.Acq_Deal_Code)
				) AS A
			) 
			AND ad.Inserted_On < DATEADD(day,@Details_AD_RJ_Stage_Since_Days , GETDATE()) AND ad.Is_Active = 'Y'
			ORDER BY  AD.Acq_Deal_Code

			SET @AcqSyn ='Acquisition'

			--select * from #DealDetailsAdded
			Branch_DetailsAdded_Stage_One:  
				IF EXISTS(Select * from #DealDetailsAdded)
				BEGIN
						SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
	
						SET @MailSubjectCr='RightsU - Deals under Details Added' --'RightsU - Deals under Details Added Stage';
						SELECT @DefaultSiteUrl = DefaultSiteUrl from System_Param

						DECLARE curOuter CURSOR FOR 
						SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2

						OPEN curOuter 
			
						FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes

						SET @RowCount=0
						SET @EmailUser_Body=''
				
						WHILE @@Fetch_Status = 0 
						BEGIN	
							SET @Index=0
							SET @Emailbody = '<table class="tblFormat">'
							DECLARE curInner CURSOR FOR 
							SELECT Agreement_No ,Agreement_Date ,Deal_Desc ,Primary_Vendor, Title_Names ,Deal_Creation_Date ,Deal_Added_Since FROM #DealDetailsAdded
									WHERE Title_Names IS NOT NULL AND  Business_Unit_Code IN ( SELECT Business_Unit_Codes FROM Email_Config_Detail_User ECDU INNER JOIN Email_Config_Detail ECD ON ECDU.Email_Config_Detail = ECD.Email_Config_Detail_Code INNER JOIN Email_Config EC ON ECD.Email_Config_Code = EC.Email_Config_Code  WHERE ToUser_MailID = @Users_Email_Id AND  EC.[Key] = 'NDA')

							OPEN curInner
							Fetch Next From curInner Into @Agreement_No,@Agreement_Date,@Deal_Desc,@Primary_Vendor,@Title_Names,@Deal_Creation_Date,@Deal_Added_Since
							WHILE @@Fetch_Status = 0 
							BEGIN
								IF(@Index = 0)
								BEGIN
										SET @Emailbody=@Emailbody + '<tr><td align="center" width="10%" class="tblHead"><b>Agreement No<b></td>
										<td align="center" width="10%" class="tblHead"><b>Agreement Date<b></td>
										<td align="center" width="20%" class="tblHead"><b>Deal Description<b></td>
										<td align="center" width="15%" class="tblHead"><b>Primary Licensor<b></td>
										<td align="center" width="25%" class="tblHead"><b>Title(s)<b></td>
										<td align="center" width="10%" class="tblHead"><b>Deal Creation Date<b></td>							
										<td align="center" width="10%" class="tblHead"><b>Details Added Stage Since<b></td></tr>'
								END
					
								SET @Index  = @Index  + 1
								SET @RowTitleCodeNew=@Agreement_No +'|'+ @Agreement_Date +'|'+ @Deal_Desc +'|'+ @Primary_Vendor +'|'+ @Title_Names+'|'+ CAST (@Deal_Creation_Date as varchar(MAX))   +'|'+  CAST (@Deal_Added_Since as varchar(MAX)) 
								IF((@RowTitleCodeOld<>@RowTitleCodeNew))
								BEGIN
									set @RowCount=@RowCount+1
									select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" >'+ CAST  (ISNULL(@Agreement_No, ' ') as varchar(MAX))+' </td>
									<td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Agreement_Date,''), 106)+' </td>
									<td class="tblData" >'+ CAST  (ISNULL(@Deal_Desc, ' ') as varchar(MAX)) +' </td>
									<td align="center" class="tblData" >'+ CAST  (ISNULL(@Primary_Vendor, ' ') as varchar(MAX)) +' </td>
									<td class="tblData" >'+ CAST  (ISNULL(@Title_Names, ' ') as varchar(MAX)) +' </td>
									<td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Deal_Creation_Date,''), 106) +' </td>
									<td align="center" class="tblData" >'+ CAST  (ISNULL(@Deal_Added_Since, ' ') as NVARCHAR(MAX)) +' </td></tr>'
									Set @RowTitleCodeOld = @RowTitleCodeNew
								End
								FETCH NEXT FROM curInner INTO  @Agreement_No,@Agreement_Date,@Deal_Desc,@Primary_Vendor,@Title_Names,@Deal_Creation_Date,@Deal_Added_Since
							END
							CLOSE curInner
							DEALLOCATE curInner
						
							/*SET @EmailHead= '<html><head><style>
							table.tblFormat{border:1px solid black;border-collapse:collapse;}
							td.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;}
							td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>
							<p>Dear User,</p>
							<p>The below listed Acquisition Deals are under Details Added since last '+ CAST(@Details_AD_RJ_Stage_Since_Days AS VARCHAR(MAX)) +' Stage. </p>
							The details are as follows: <br />'*/

							SET @EmailHead= '<html><head><style>
							table.tblFormat{border:1px solid black;border-collapse:collapse;}
							td.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;}
							td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>
							<p>Dear User,</p>
							<p>The below listed '+ @AcqSyn +' Deals are under Details Added Stage. </p>
							The details are as follows: <br />'
					
							SET @EMailFooter ='</table></br>
							Kindly login <a href="'+@DefaultSiteUrl+'">here</a> to know more.</br></br>
							If you have any questions or need assistance, please feel free to reach us at 
							<a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>
							<p>Regards,</br>
							RightsU Support</br>
							U-TO Solutions</p>
							</body></html>'
					
							PRINT(@EmailUser_Body)
							SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
							PRINT @EmailUser_Body
							--SELECT @EmailUser_Body
							IF(@RowCount!=0)
							BEGIN
									 EXEC msdb.dbo.sp_send_dbmail 
										@profile_name = @DatabaseEmail_Profile,
										@recipients =  @To_User_Mail_Id,
										@copy_recipients = @CC_User_Mail_Id,
										@blind_copy_recipients = @BCC_User_Mail_Id,
										@subject = @MailSubjectCr,
										@body = @EmailUser_Body, 
										@body_format = 'HTML';
									
							INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
							SELECT @Email_Config_Code,@Emailbody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  @MailSubjectCr

							END
							SET @EmailUser_Body=''
				
							FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
						END

						CLOSE curOuter
						DEALLOCATE curOuter
				END

			Branch_DetailsAdded_Stage_Two:
				IF (@AcqSynProcess = 'Y')
				BEGIN
					SET @AcqSynProcess = 'N'
					TRUNCATE TABLE #DealDetailsAdded

					INSERT INTO #DealDetailsAdded (Acq_Deal_Code,Agreement_No,Agreement_Date,Deal_Desc,Primary_Vendor,Title_Names,Deal_Creation_Date,Deal_Added_Since,Business_Unit_Code)
					SELECT 
					 ad.Syn_Deal_Code,
					 ad.Agreement_No,
					 ad.Agreement_Date,
					 ad.Deal_Description,
					 V.Vendor_Name,
					 STUFF((
					 SELECT DISTINCT ', ' + LTRIM(RTRIM(T.Title_Name))
								FROM Syn_Deal_Movie ADM
								INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
								WHERE Syn_Deal_Code = ad.Syn_Deal_Code
					FOR XML PATH('')
					), 1, 1, '') as Title_Names,
					 ad.Inserted_On,
					 DATEDIFF(dd,ad.Inserted_On, GETDATE()) AS Deal_Added_Since, --DATEADD(day,-7, GETDATE())
					 ad.Business_Unit_Code
					FROM Syn_Deal ad
					INNER JOIN Vendor V ON V.Vendor_Code=ad.Vendor_Code
					WHERE ad.Deal_Workflow_Status in ('N','AM')
					AND 0 =
					(SELECT count(*)  FROM 
						(
						select  DISTINCT Title_Code from Syn_Deal_Movie  WHERE Syn_Deal_Code =  AD.Syn_Deal_Code
						EXCEPT
						SELECT DISTINCT Title_Code FROM Syn_Deal_Rights_Title WHERE  Syn_Deal_Rights_Code IN ( SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Code = AD.Syn_Deal_Code)
						) AS A
					) 
					AND ad.Inserted_On < DATEADD(day,@Details_AD_RJ_Stage_Since_Days, GETDATE()) AND ad.Is_Active = 'Y'
					ORDER BY  AD.Syn_Deal_Code
	
					SET @AcqSyn ='Syndication'

					GOTO Branch_DetailsAdded_Stage_One;
				END	
	END
	ELSE IF(@mailFor = 'RJ')
	BEGIN
			INSERT INTO #DealDetailRejected(Acq_Deal_Code,Agreement_No,Agreement_Date,Deal_Desc,Primary_Vendor,Title_Names, Deal_Creation_Date, Deal_Rejection_Date,Deal_Rejected_Since,Business_Unit_Code)
			SELECT 
			 ad.Acq_Deal_Code,
			 ad.Agreement_No,
			 ad.Agreement_Date,
			 ad.Deal_Desc,
			 V.Vendor_Name,
			 STUFF((
			 SELECT DISTINCT ', ' +  LTRIM(RTRIM(T.Title_Name))
						FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = ad.Acq_Deal_Code
            FOR XML PATH('')
            ), 1, 1, '') as Title_Names,
			 ad.Inserted_On,
			 ad.Last_Updated_Time,
			 DATEDIFF(dd,ad.Last_Updated_Time, GETDATE()) AS Deal_Rejected_Since, --DATEADD(day,-7, GETDATE())
			 ad.Business_Unit_Code
			FROM Acq_Deal ad
			INNER JOIN Vendor V ON V.Vendor_Code=ad.Vendor_Code
			WHERE ad.Deal_Workflow_Status in ('R')
			AND ad.Last_Updated_Time < DATEADD(day,@Details_AD_RJ_Stage_Since_Days, GETDATE()) AND ad.Is_Active = 'Y'
			ORDER BY  AD.Acq_Deal_Code

			SET @AcqSyn ='Acquisition'

			Branch_DetailsRejected_Stage_One: 
				IF EXISTS(Select * from #DealDetailRejected)
				BEGIN
						SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
	
						SET @MailSubjectCr='RightsU - Deals under Rejected Stage'--'RightsU - Deals under Details Rejected Stage';
						SELECT @DefaultSiteUrl = DefaultSiteUrl from System_Param

						DECLARE curOuter CURSOR FOR 
						SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
	
						OPEN curOuter 
			
						FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
						SET @RowCount=0
						SET @EmailUser_Body=''
				
						WHILE @@Fetch_Status = 0 
						BEGIN	
							SET @Index=0
							SET @Emailbody = '<table class="tblFormat">'
							DECLARE curInner CURSOR FOR 
							SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes  FROM @Tbl2
							OPEN curInner
							Fetch Next From curInner Into @Agreement_No,@Agreement_Date,@Deal_Desc,@Primary_Vendor,@Title_Names, @Deal_Creation_Date,@Deal_Rejection_Date,@Deal_Rejected_Since
							WHILE @@Fetch_Status = 0 
							BEGIN
								IF(@Index = 0)
								BEGIN
										SET @Emailbody=@Emailbody + '<tr><td align="center" width="10%" class="tblHead"><b>Agreement No<b></td>
										<td align="center" width="10%" class="tblHead"><b>Agreement Date<b></td>
										<td align="center" width="20%" class="tblHead"><b>Deal Description<b></td>
										<td align="center" width="10%" class="tblHead"><b>Primary Licensor<b></td>
										<td align="center" width="20%" class="tblHead"><b>Title(s)<b></td>
										<td align="center" width="10%" class="tblHead"><b>Deal Creation Date<b></td>		
										<td align="center" width="10%" class="tblHead"><b>Deal Rejection Date<b></td>							
										<td align="center" width="10%" class="tblHead"><b>Deal Rejected Stage Since<b></td></tr>'
								END
					
								SET @Index  = @Index  + 1
								SET @RowTitleCodeNew=@Agreement_No +'|'+ @Agreement_Date +'|'+ @Deal_Desc +'|'+ @Primary_Vendor +'|'+ @Title_Names+'|' + CAST (@Deal_Creation_Date as varchar(MAX)) + '|'+ CAST (@Deal_Rejection_Date as varchar(MAX))   +'|'+  CAST (@Deal_Rejected_Since as varchar(MAX)) 
								IF((@RowTitleCodeOld<>@RowTitleCodeNew))
								BEGIN
									set @RowCount=@RowCount+1
									select @Emailbody=@Emailbody +'<tr><td align="center" class="tblData" >'+ CAST  (ISNULL(@Agreement_No, ' ') as varchar(MAX))+' </td>
									<td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Agreement_Date,''), 106)+' </td>
									<td class="tblData" >'+ CAST  (ISNULL(@Deal_Desc, ' ') as varchar(MAX)) +' </td>
									<td align="center" class="tblData" >'+ CAST  (ISNULL(@Primary_Vendor, ' ') as varchar(MAX)) +' </td>
									<td class="tblData" >'+ CAST  (ISNULL(@Title_Names, ' ') as varchar(MAX)) +' </td>
									<td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Deal_Creation_Date,''), 106) +' </td>
									<td align="center" class="tblData" >'+ CONVERT(varchar(11),IsNull(@Deal_Rejection_Date,''), 106) +' </td>
									<td align="center" class="tblData" >'+ CAST  (ISNULL(@Deal_Rejected_Since, ' ') as NVARCHAR(MAX)) +' </td></tr>'
									Set @RowTitleCodeOld = @RowTitleCodeNew
								End
								FETCH NEXT FROM curInner INTO  @Agreement_No,@Agreement_Date,@Deal_Desc,@Primary_Vendor,@Title_Names, @Deal_Creation_Date ,@Deal_Rejection_Date,@Deal_Rejected_Since
							END
							CLOSE curInner
							DEALLOCATE curInner
						
							/*SET @EmailHead= '<html><head><style>
							table.tblFormat{border:1px solid black;border-collapse:collapse;}
							td.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;}
							td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>
							<p>Dear User,</p>
							<p>The below listed Acquisition Deals are under Details Rejected since last '+ CAST(@Details_AD_RJ_Stage_Since_Days AS VARCHAR(MAX)) +' Stage. </p>
							The details are as follows: <br />'*/

							SET @EmailHead= '<html><head><style>
							table.tblFormat{border:1px solid black;border-collapse:collapse;}
							td.tblHead{border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:10px;}
							td.tblData{border:1px solid black; vertical-align:top;font-family:verdana;font-size:10px;}</style></head><body>
							<p>Dear User,</p>
							<p>The below listed '+ @AcqSyn +' Deals are under Rejected Stage. </p>
							The details are as follows: <br />'
					
							SET @EMailFooter ='</table></br>
							Kindly login <a href="'+@DefaultSiteUrl+'">here</a> to know more.</br></br>
							If you have any questions or need assistance, please feel free to reach us at 
							<a href=''mailto:rightsusupport@uto.in''>rightsusupport@uto.in</a>
							<p>Regards,</br>
							RightsU Support</br>
							U-TO Solutions</p>
							</body></html>'
					
							PRINT(@EmailUser_Body)
							SET @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter
							PRINT @EmailUser_Body
							--SELECT @EmailUser_Body
							IF(@RowCount!=0)
							BEGIN
									
									  EXEC msdb.dbo.sp_send_dbmail 
										@profile_name = @DatabaseEmail_Profile,
										@recipients =  @To_User_Mail_Id,
										@copy_recipients = @CC_User_Mail_Id,
										@blind_copy_recipients = @BCC_User_Mail_Id,
										@subject = @MailSubjectCr,
										@body = @EmailUser_Body, 
										@body_format = 'HTML';
														
								INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
								SELECT @Email_Config_Code,@Emailbody, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  @MailSubjectCr


							END
							SET @EmailUser_Body=''
				
							FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id, @Channel_Codes
						END

						CLOSE curOuter
						DEALLOCATE curOuter
				END

			Branch_DetailsRejected_Stage_Two:
				IF (@AcqSynProcess = 'Y')
				BEGIN
					SET @AcqSynProcess = 'N'

					TRUNCATE TABLE #DealDetailRejected

					INSERT INTO #DealDetailRejected (Acq_Deal_Code,Agreement_No,Agreement_Date,Deal_Desc,Primary_Vendor,Title_Names,Deal_Creation_Date,Deal_Rejection_Date,Deal_Rejected_Since,Business_Unit_Code)
					SELECT 
					ad.Syn_Deal_Code,
					ad.Agreement_No,
					ad.Agreement_Date,
					ad.Deal_Description,
					V.Vendor_Name,
					STUFF((
					SELECT DISTINCT ', ' +  LTRIM(RTRIM(T.Title_Name))
								FROM Syn_Deal_Movie ADM
								INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
								WHERE Syn_Deal_Code = ad.Syn_Deal_Code
					FOR XML PATH('')
					), 1, 1, '') as Title_Names,
					 ad.Inserted_On,
					 ad.Last_Updated_Time,
					 DATEDIFF(dd,ad.Last_Updated_Time, GETDATE()) AS Deal_Rejected_Since, --DATEADD(day,-7, GETDATE())
					 ad.Business_Unit_Code
					FROM Syn_Deal ad
					INNER JOIN Vendor V ON V.Vendor_Code=ad.Vendor_Code
					WHERE ad.Deal_Workflow_Status in ('R')
					AND ad.Last_Updated_Time < DATEADD(day,@Details_AD_RJ_Stage_Since_Days, GETDATE()) AND ad.Is_Active = 'Y'
					ORDER BY  AD.Syn_Deal_Code

					SET @AcqSyn ='Syndication'

					GOTO Branch_DetailsRejected_Stage_One;
				END
	END

	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT


	IF OBJECT_ID('tempdb..#DealDetailRejected') IS NOT NULL DROP TABLE #DealDetailRejected
	IF OBJECT_ID('tempdb..#DealDetails') IS NOT NULL DROP TABLE #DealDetails
	IF OBJECT_ID('tempdb..#DealDetailsAdded') IS NOT NULL DROP TABLE #DealDetailsAdded
END

--EXEC USP_Deal_Approval_Email